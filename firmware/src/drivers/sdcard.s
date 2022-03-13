; *******************************
; *  JRC-1 65816 SBC Firmware   *
; * (C) 2021 Joshua M. Thompson *
; *******************************

        .include "common.s"
        .include "sys/console.s"
        .include "device.inc"

        .export sdcard_init

        .import dm_register_internal
        .import spi_select_sdc
        .import spi_deselect
        .import spi_transfer
        .import spi_slow_speed
        .import spi_fast_speed
        .import wait_ms

        .importzp ptr
        .importzp tmp

.macro  send    bytes
        pea     .hiword(bytes)
        pea     .loword(bytes)
        jsr     send_cmd
.endmacro

SD_CMD_SIZE     = 6     ; acmd flag + cmd byte + 4 byte arg + CRC
SD_DATA_TOKEN   = $FE   ; start of data token
SD_FILL         = $FF   ; fill byte

CARD_TYPE_UNKNOWN = 0
CARD_TYPE_V1      = 1
CARD_TYPE_V2      = 2

        .segment "ZEROPAGE"

blockp:         .res    4
device_params:  .res    4

        .segment "SYSDATA"

cmd:
csd:        .res    16
nr_sectors: .res    4
card_type:  .res    2
retries:    .res    2

        .segment "OSROM"

sdcard_driver:
        .word       0                   ; version
        .word       DEVICE_TYPE_BLOCK   ; feature flags
        longaddr    @n                  ; device name
        longaddr    0                   ; private data
        .word       9                   ; number of functions
        longaddr    sdc_startup         ; #0
        longaddr    sdc_shutdown        ; #1
        longaddr    sdc_status          ; #2
        longaddr    sdc_mount           ; #3
        longaddr    sdc_eject           ; #4
        longaddr    sdc_format          ; #5
        longaddr    sdc_rdblock         ; #6
        longaddr    sdc_wrblock         ; #7
@n:     .byte "SDCARD", 0

sdcard_init:
        stz     card_type
        REGISTER_DEVICE sdcard_driver
        rtl

;;
; STARTUP
;
; Init the driver; does nothing for now
;
sdc_startup:
        DRVR_SUCCESS

;;
; SHUTDOWN
;
; Shut dowwn the SD card. Not much to do here other than zero the card type.
;
sdc_shutdown:
        DRVR_ENTER
        stz     card_type
        DRVR_SUCCESS

;;
; MOUNT
;
; Attempt to initialize the SD card and bring it online
;
sdc_mount:
        DRVR_ENTER
        shortm
        lda     #255
        sta     retries
@try:   dec     retries
        beq     @error
        jsr     init_card
        bcs     @try
        jsr     read_csd
        bcs     @try
        longm

        DRVR_SUCCESS
@error: longm
        DRVR_ERROR ERR_NO_MEDIA

;;
; EJECT
;
; Ejects (unmounts) the card, which for us is just zeroing out the
; card_type.
;
sdc_eject:
        DRVR_ENTER
        stz     card_type
        DRVR_SUCCESS

;;
; STATUS
;
; Returns online/offline status and the device size in sectors
;
sdc_status:
        DRVR_ENTER
        DRVR_PARAMS device_params

        lda     card_type
        beq     @error
        ldaw    #DEVICE_ONLINE
        ldyw    #0
        sta     [device_params],Y
        iny
        iny
        lda     nr_sectors
        sta     [device_params],Y
        iny
        iny
        lda     nr_sectors+2
        sta     [device_params],Y

        DRVR_SUCCESS

@error: ldaw    #0
        sta     [device_params]    ; Offline
        ldyw    #2
        sta     [device_params],Y
        iny
        iny
        sta     [device_params],Y

        DRVR_SUCCESS

;;
; FORMAT
;
; SD cards do not support formatting
;
sdc_format:
        DRVR_ERROR  ERR_NOT_SUPPORTED

;;
; READ_BLOCK
;
; Read a single 512-byte block from the card
;
sdc_rdblock:
        DRVR_ENTER
        DRVR_PARAMS device_params

        lda     card_type
        bne     :+
        DRVR_ERROR ERR_NO_MEDIA
:       shortm
        lda     #$51            ; CMD17
        sta     cmd
        ldxw    #4
        ldyw    #0
:       lda     [device_params],Y
        sta     cmd,X           ; flip byte order
        iny
        dex
        bne     :-
        longm
        lda     [device_params],Y
        sta     blockp
        iny
        iny
        lda     [device_params],Y
        sta     blockp+2
        shortm
        send    cmd
        bne     @error
        jsr     wait_data
        bcs     @error
        ldyw    #0
:       lda     #SD_FILL
        jsl     spi_transfer
        sta     [blockp],Y
        iny
        cpyw    #512
        bne     :-
        jsl     spi_transfer
        jsl     spi_transfer    ; Eat two-byte CRC
        jsr     deselect
        longm
        DRVR_SUCCESS
@error: jsr     deselect
        longm
        DRVR_ERROR ERR_IO_ERROR

;;
; WRITE_BLOCK
;
; Write a single 512-byte block to the card
;
sdc_wrblock:
        DRVR_ENTER
        DRVR_PARAMS device_params

        lda     card_type
        bne     :+
        DRVR_ERROR ERR_NO_MEDIA
:       shortm
        lda     #$58            ; CMD24
        sta     cmd
        ldxw    #4
        ldyw    #0
:       lda     [device_params],Y
        sta     cmd,X           ; flip byte order
        iny
        dex
        bne     :-
        longm
        lda     [device_params],Y
        sta     blockp
        iny
        iny
        lda     [device_params],Y
        sta     blockp+2
        shortm
        send    cmd
        bne     @error
        lda     #SD_DATA_TOKEN
        jsl     spi_transfer
        ldyw    #0
:       lda     [blockp],Y
        jsl     spi_transfer
        iny
        cpyw    #512
        bne     :-
        jsr     wait_rdy
        bcs     @error
        and     #$1F
        cmp     #$05
        bne     @error
        ldxw    #255
:       lda     #SD_FILL
        jsl     spi_transfer
        bne     @exit           ; exit when non-zero byte received
        dex
        bne     :-
@error: jsr     deselect
        longm
        DRVR_ERROR ERR_IO_ERROR
@exit:  longm
        DRVR_SUCCESS

;;
; Attempt to initialize the SD card
;
; On exit:
; All registers trashed
; c = 0 on success
; c = 1 on failure
;
init_card:
        jsl     spi_slow_speed
        jsr     set_spi_mode
        jsr     set_idle
        bcs     @error
        send    @cmd08
        bcs     @v1             ; Might be an older card
        jsl     spi_transfer
        bne     @error
        jsl     spi_transfer
        bne     @error
        jsl     spi_transfer
        cmp     #$01
        bne     @error
        jsl     spi_transfer
        cmp     #$AA
        bne     @error
        ldxw    #255
@v2:    jsr     deselect
        send    @cmd55
        bcs     @v1
        jsr     deselect
        send    @acmd41
        beq     @blksz
        lda     #15
        jsl     wait_ms
        dex
        bne     @v2
        bra     @error
@v1:    send    @cmd01
        bcc     @blksz
        lda     #15
        jsl     wait_ms
        dex
        bne     @v1
        bra     @error
@blksz: jsr     deselect
        send    @cmd16
        bne     @error
        jsr     deselect
        jsl     spi_fast_speed
        clc
        rts
@error: jsr     deselect
        jsl     spi_fast_speed
        sec
        rts

@cmd16:     .byte   $50,$00,$00,$02,$00,$01
@cmd01:     .byte   $41,$00,$00,$00,$00,$01
@cmd08:     .byte   $48,$00,$00,$01,$AA,$87
@cmd55:     .byte   $77,$00,$00,$00,$00,$65
@acmd41:    .byte   $69,$40,$00,$00,$00,$01

;;
; Put the SD card into SPI mode
;
; On exit: 
; C,X trashed
;
set_spi_mode:
        rts
        jsr     deselect
        ldxw    #10
:       lda     #SD_FILL
        jsl     spi_transfer
        dex
        bne     :-
        rts

;;
; Put the SD card into the idle state
;
; On exit:
; C,X trashed
; c = 0 on success
; c = 1 on failure
;
set_idle:
        ldxw    #8
:       send    @cmd00
        bcc     @r1
        lda     #1
        jsl     wait_ms
        dex
        bne     :-
@error: jsr     deselect
        sec
        rts
@r1:    cmp     #1                  ; is the idle bit set now?
        bne     @error
        jsr     deselect
        clc
        rts
@cmd00: .byte   $40,$00,$00,$00,$00,$95

;;
; Read the card's CSD to determine card type and size
;
; On exit:
;
; All registers trashed
; c=0 and card_type set on success
; c=1 on error
;
read_csd:
        send    @cmd09
        bne     @error
        jsr     wait_data
        bcs     @error
        ldxw    #0
:       lda     #SD_FILL
        jsl     spi_transfer
        sta     csd,X
        inx
        cpxw    #16
        bne     :-
        jsl     spi_transfer
        jsl     spi_transfer    ; Eat CRC
        bit     csd
        bmi     @error          ; reserved bit must be 0
        lda     csd+5
        and     #$0F            ; Mask off RD_BLK_LEN
        cmp     #9              ; Is it 2^9 (512 bytes)?
        bne     @error          ; If not we can't use this card
        bit     csd             ; Check CSD version to parse C_SIZE
        bvs     @v2             ; if bit 6 is set it's v2
        lda     #CARD_TYPE_V1
        sta     card_type
        jsr     get_nr_sectors_v1
        bra     @exit
@v2:    lda     #CARD_TYPE_V2
        sta     card_type
        jsr     get_nr_sectors_v2
@exit:  jsr     deselect
        clc
        rts
@error: sec
        rts

@cmd09: .byte   $49,$00,$00,$00,$00,$01

;;
; Wait for the SD card to be ready (return something other than $FF)
; 
; On exit:
;
; X trashed
; C contains received byte
; c=0 on success, 1 on failure
;
wait_rdy:
        ldxw    #255
        lda     #SD_FILL
@wait:  jsl     spi_transfer
        cmp     #SD_FILL
        bne     @done
        dex
        bne     @wait
        sec
        rts
@done:  clc
        rts

;;
; Wait for the data start token
; 
; On exit:
;
; C,X trashed
; c=0 on success, 1 on failure
;
wait_data:
        ldxw    #255
@wait:  lda     #SD_FILL
        jsl     spi_transfer
        cmp     #SD_DATA_TOKEN
        beq     @done
        dex
        bne     @wait
        sec
        rts
@done:  clc
        rts

;;
; Send a command to the SD card. The pointer to the command to send should be
; on the stack.
;
send_cmd:
        longm
        lda     3,s
        sta     ptr
        lda     5,s
        sta     ptr+2
        lda     1,s
        sta     5,s
        tsc
        clc
        adcw    #4
        tcs
        shortm

        phx
        phy

        jsl     spi_select_sdc

        ldyw    #0
:       lda     [ptr],Y
        jsl     spi_transfer
        iny
        cpyw    #SD_CMD_SIZE
        bne     :-
        ldyw    #17
:       lda     #SD_FILL
        jsl     spi_transfer
        bpl     @r1
        dey
        bne     :-
        pha
@error: jsr     deselect
        pla
        sec
        bra     @exit
@r1:    pha
        and     #%01111100  ; see if any of the error bits are set
        bne     @error
        pla
        clc
@exit:  ply
        plx
        ora     #0          ; set N/Z flags for caller
        rts

;;
; Deselect the SD card interface board
;
deselect:
        jsl     spi_deselect
        lda     #SD_FILL
        jsl     spi_transfer        ; give SD card time to release DO
        rts

;; Calculate the number of sectors from a v1 CSD
;
; For V2 the formula is NR_SECTORS = (C_SIZE+1)*(2^(C_MULT+2))
;
; CSIZE is bits 73-62 in the CSD, which is the lower two bits of csd[6],
; all of csd[7], and the upper two bits of csd[8]. And iike all CSD values
; it's in big-endiannd order so we need to reverse it before doing the math.
;
; CSIZE_MULT is bits 49-47, aka lower two bits of csd[9] and the upper bit of
; csd[10]
;
; On entry:
;
; csd populated
;
; On exit:
;
; nr_sectors populated
; C,X,Y trashed
;
get_nr_sectors_v1:
        stz     nr_sectors+3
        stz     nr_sectors+2    ; Bits 31-15 are all zero
        lda     csd+6
        and     #$03
        sta     nr_sectors+1    ; Bits 11-10
        lda     csd+7
        sta     nr_sectors      ; Bits 9-2
        lda     csd+8
        and     #$C0            ; bits 1-0
        asl
        rol     nr_sectors      ; Rotate bits into position
        rol     nr_sectors+1
        asl
        rol     nr_sectors
        rol     nr_sectors+1
        lda     csd+9
        and     #$03            ; upper two bits of C_SIZE_MULT
        sta     tmp
        lda     csd+10
        asl
        rol     tmp
        stz     tmp+1
        ldx     tmp
        inx
        inx                     ; C_SIZE_MULT+2
        jmp     csize_to_nr_sectors

;; Calculate the number of sectors from a v2 CSD
;
; For V2 the formula is NR_SECTORS = (C_SIZE+1)*1024
;
; CSIZE is bits 69-48 in the CSD, which is the lower six bits of csd[7]
; and all of csd[8] and csd[9]. And like all CSD values it's in big-endian
; order so we need to reverse it before doing the math.
;
; On entry:
;
; csd populated
;
; On exit:
;
; nr_sectors populated
; C,X,Y trashed
;
get_nr_sectors_v2:
        stz     nr_sectors+3    ; bits 31-24 are always 0 since C_SIZE is 22 bits
        lda     csd+7
        and     #%00111111
        sta     nr_sectors+2    ; bits 23-16
        lda     csd+8
        sta     nr_sectors+1    ; bits 15-8
        lda     csd+9
        sta     nr_sectors      ; bits 7-0
        ldxw    #10             ; Multiplier is fixed at 2^10 for v2
        ; fall through
 
;;
; Set nr_sectors = (nr_sectors+1)*(2^X)
;
; Inputs:
;
; nr_sectors contains raw C_SIZE
; X = shift factor, must be >0
;
; Outputs;
;
; nr_sectors updated
; X trashed
;
csize_to_nr_sectors:
        longm
        inc32   nr_sectors      ; Do the +1
:       asl     nr_sectors
        rol     nr_sectors+2    ; Shift left to multiply by 2^X
        dex
        bne     :-
        shortm
        rts
