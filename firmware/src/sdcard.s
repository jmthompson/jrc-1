; *******************************
; *  JRC-1 65816 SBC Firmware   *
; * (C) 2021 Joshua M. Thompson *
; *******************************

        .include "common.s"
        .include "sys/console.s"

        .import spi_deselect
        .import spi_transfer
        .import spi_select
        .import spi_slow_speed
        .import spi_fast_speed

        .import wait_ms

        .importzp device_cmd
        .importzp blkbuff
        .importzp ptr
        .importzp tmp

        .export sdcard_driver

.macro  send    bytes
        pea     .hiword(bytes)
        pea     .loword(bytes)
        jsr     send_cmd
.endmacro

SD_DEVICE_ID    = 0     ; SPI device ID
SD_CMD_SIZE     = 6     ; acmd flag + cmd byte + 4 byte arg + CRC
SD_DATA_TOKEN   = $FE   ; start of data token
SD_FILL         = $FF   ; fill byte

CARD_TYPE_UNKNOWN = 0
CARD_TYPE_V1      = 1
CARD_TYPE_V2      = 2

        .segment "SYSDATA"

cmd:
csd:        .res    16
nr_sectors: .res    4
card_type:  .res    1

        .segment "OSROM"

; JR/OS driver structure
sdcard_driver:
        .byte   "SD CARD        ",0
        longaddr sdc_init
        longaddr sdc_status
        longaddr sdc_mount
        longaddr sdc_eject
        longaddr sdc_format
        longaddr sdc_rdblock
        longaddr sdc_wrblock

;;
; INIT
;
; Initialize the SD card. Nothing to do here since there may not be a card
; inserted yet.
;
sdc_init:
        stz     card_type
        clc
        rtl

;;
; MOUNT
;
; Attempts to mount an SD card. This consists of initializing the card and
; placing it into SPI mode
;
sdc_mount:
        stz     card_type
        jsr     init_card
        bcs     @error
        jsr     read_csd
        bcs     @error
        clc
        rtl
@error: syserr  ERR_NO_MEDIA

;;
; EJECT
;
; Ejects (unmounts) the card, which for us is just zeroing out the
; card_type.
;
sdc_eject:
        stz     card_type
        clc
        rtl

;;
; STATUS
;
; Returns online/offline status and the device size in sectors
;
sdc_status:
        lda     card_type
        beq     @error
        lda     #1
        sta     [device_cmd];   ; online
        longm
        ldy     #1
        lda     nr_sectors
        sta     [device_cmd],Y
        iny
        iny
        lda     nr_sectors+2
        sta     [device_cmd],Y
        shortm
        clc
        rtl
@error: lda     #0
        sta     [device_cmd]    ; Offline
        longm
        ldy     #1
        ldaw    #0
        sta     [device_cmd],Y
        iny
        iny
        sta     [device_cmd],Y
        shortm
        sec
        rtl

;;
; FORMAT
;
; SD cards do not support formatting
;
sdc_format:
        syserr  ERR_NOT_SUPPORTED

;;
; READ_BLOCK
;
; Read a single 512-byte block from the card
;
sdc_rdblock:
        lda     card_type
        bne     :+
        syserr  ERR_NO_MEDIA
:       lda     #$51            ; CMD17
        sta     cmd
        ldx     #4
        ldy     #0
:       lda     [device_cmd],Y
        sta     cmd,X           ; flip byte order
        iny
        dex
        bne     :-
        longm
        lda     [device_cmd],Y
        sta     blkbuff
        iny
        iny
        lda     [device_cmd],Y
        sta     blkbuff+2
        shortm
        send    cmd
        bne     @error
        jsr     wait_data
        bcs     @error
        longx
        ldyw    #0
:       lda     #SD_FILL
        jsl     spi_transfer
        sta     [blkbuff],Y
        iny
        cpyw    #512
        bne     :-
        shortx
        jsl     spi_transfer
        jsl     spi_transfer    ; Eat two-byte CRC
        jsr     deselect
        clc
        rtl
@error: jsr     deselect
        syserr  ERR_IO_ERROR

;;
; WRITE_BLOCK
;
; Write a single 512-byte block to the card
;
sdc_wrblock:
        lda     card_type
        bne     :+
        syserr  ERR_NO_MEDIA
:       lda     #$58            ; CMD24
        sta     cmd
        ldx     #4
        ldy     #0
:       lda     [device_cmd],Y
        sta     cmd,X           ; flip byte order
        iny
        dex
        bne     :-
        longm
        lda     [device_cmd],Y
        sta     blkbuff
        iny
        iny
        lda     [device_cmd],Y
        sta     blkbuff+2
        shortm
        send    cmd
        bne     @error
        lda     #SD_DATA_TOKEN
        jsl     spi_transfer
        longx
        ldyw    #0
:       lda     [blkbuff],Y
        jsl     spi_transfer
        iny
        cpyw    #512
        bne     :-
        shortx
        jsr     wait_rdy
        bcs     @error
        and     #$1F
        cmp     #$05
        bne     @error
        ldx     #255
:       lda     #SD_FILL
        jsl     spi_transfer
        bne     @exit           ; exit when non-zero byte received
        dex
        bne     :-
@error: jsr     deselect
        syserr  ERR_IO_ERROR
@exit:  clc
        rtl

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
        ldx     #255
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
        jsr     deselect
        ldx     #10
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
        ldx     #8
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
        ldx     #0
:       lda     #SD_FILL
        jsl     spi_transfer
        sta     csd,X
        inx
        cpx     #16
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
        ldx     #255
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
        ldx     #255
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

        jsr     select

        ldy     #0
:       lda     [ptr],Y
        jsl     spi_transfer
        iny
        cpy     #SD_CMD_SIZE
        bne     :-
        ldy     #17
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
; Select the SD card interface board
;
select:
        lda     #SD_DEVICE_ID
        jsl     spi_select
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
        ldx     #10             ; Multiplier is fixed at 2^10 for v2
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
