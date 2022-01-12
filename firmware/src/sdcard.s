; *******************************
; *  JRC-1 65816 SBC Firmware   *
; * (C) 2021 Joshua M. Thompson *
; *******************************

        .include "common.s"
        .include "sys/console.s"

        .import spi_deselect
        .import spi_transfer
        .import spi_select
        .import wait_ms

        .importzp device_cmd
        .importzp ptr
        .importzp tmp

        .export sdcard_driver

.macro  send    bytes
        pea     .hiword(bytes)
        pea     .loword(bytes)
        jsr     send_cmd
.endmacro

        .segment "SYSDATA"

cmd51:
csd:        .res    16
nr_sectors: .res    4

        .segment "OSROM"

SD_DEVICE_ID = 0     ; SPI device ID
SD_CMD_SIZE  = 6     ; acmd flag + cmd byte + 4 byte arg + CRC
SD_FILL      = $ff   ; fill byte

driver_name:
        .byte   "SD CARD", 0

sdcard_driver:
        longaddr driver_name
        longaddr sdc_init
        longaddr sdc_status
        longaddr sdc_format
        longaddr sdc_rdblock
        longaddr sdc_wrblock

;;
; INIT
;
; Initialize the SD card
sdc_init:
        jsr     set_spi_mode
        jsr     set_idle
        bcs     @error
:       send    @cmd08
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
        clc
        rtl
@error: jsr     deselect
        puts    @errmsg
        sec
        rtl
@errmsg: .byte "SD card not detected", CR, LF, 0

@cmd16:     .byte   $50,$00,$00,$02,$00,$01
@cmd01:     .byte   $41,$00,$00,$00,$00,$01
@cmd08:     .byte   $48,$00,$00,$01,$AA,$87
@cmd55:     .byte   $77,$00,$00,$00,$00,$65
@acmd41:    .byte   $69,$40,$00,$00,$00,$01

;;
; STATUS
;
; Returns online/offline status and the device size in sectors
;
sdc_status:
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
        jsr     get_nr_sectors_v1
        bra     @cont
@v2:    jsr     get_nr_sectors_v2
@cont:  lda     #1
        sta     [device_cmd];   ; oneline
        longm
        ldy     #1
        lda     nr_sectors
        sta     [device_cmd],Y
        iny
        iny
        lda     nr_sectors+2
        sta     [device_cmd],Y
        shortm
        iny
        iny
        ldx     #0
:       lda     f:driver_name,X
        sta     [device_cmd],Y  ; Copy driver name as unit name
        beq     @exit
        inx
        iny
        bra     :-
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
@exit:  jsr     deselect
        clc
        rtl
@cmd09: .byte   $49,$00,$00,$00,$00,$01

sdc_format:
        sec
        rtl

sdc_rdblock:
        ldy     #0
        lda     [device_cmd],Y
        beq     @ok             ; only supports unit 0
        sec
        rtl

; Build CMD51 with device number in command block

@ok:    lda     #$51
        sta     cmd51
        lda     #$01
        sta     cmd51+5

        ldx     #4
        iny
@copy:  lda     (device_cmd),Y
        sta     cmd51,X
        iny
        dex
        bne     @copy

        ; Copy pblock buffer pointer to ptr
        lda     (device_cmd),Y
        sta     ptr
        iny
        lda     (device_cmd),Y
        sta     ptr+1

        send    cmd51
        bne     @error
        jsr     wait_data
        bcc     @recv
@error: jsr     deselect
        sec
        bra     @exit
@recv:  ldy     #0
@recv1: lda     #SD_FILL
        jsl     spi_transfer
        sta     (ptr),Y
        iny
        bne     @recv1
        inc     ptr+1
@recv2: lda     #SD_FILL
        jsl     spi_transfer
        sta     (ptr),Y
        iny
        bne     @recv2
        jsr     deselect
        clc
@exit:  rtl

sdc_wrblock:
        sec
        rtl

; Put the SD card into SPI mode

set_spi_mode:
        jsr     deselect
        ldx     #10
:       lda     #SD_FILL
        jsl     spi_transfer
        dex
        bne     :-
        rts

; Tell the SD card to go into the idle state

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

; Wait for the SD card to be ready. Returns carry clear on success or set on failure

wait_rdy:
        lda     #$ff
        sta     ptr
@loop:  lda     #SD_FILL
        jsl     spi_transfer
        cmp     #SD_FILL
        beq     @ready
        dec     ptr
        bne     @loop
        sec
        rts
@ready: clc
        rts

; Wait for data to be ready. Returns carry set on error.

wait_data:
        ldx     #255
@wait:  lda     #SD_FILL
        jsl     spi_transfer
        cmp     #$FE
        beq     @ok
        dex
        bne     @wait
        sec
        rts
@ok:    clc
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
        sta     $020000
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

:
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
