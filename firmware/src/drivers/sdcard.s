; *******************************
; *  JRC-1 65816 SBC Firmware   *
; * (C) 2021 Joshua M. Thompson *
; *******************************

        .include "common.inc"
        .include "syscalls.inc"
        .include "errors.inc"
        .include "kernel/device.inc"
        .include "kernel/fs.inc"
        .include "kernel/heap.inc"
        .include "kernel/function_macros.inc"

        .export sdcard_register

        .import spi_select_sdc
        .import spi_deselect
        .import spi_transfer
        .import spi_slow_speed
        .import spi_fast_speed
        .import wait_ms

SD_CMD_SIZE     := 6    ; acmd flag + cmd byte + 4 byte arg + CRC
SD_DATA_TOKEN   := $FE  ; start of data token
SD_FILL         := $FF  ; fill byte

CARD_TYPE_UNKNOWN := 0
CARD_TYPE_V1      := 1
CARD_TYPE_V2      := 2

;;
; Macro for sending a 6-byte command to the SD card.
;
.macro  send    bytes
        ldxw    #SD_CMD_SIZE-1
:       lda     f:bytes,X
        sta     cmd,X
        dex
        bpl     :-
        jsr     send_cmd
.endmacro

        .segment "BSS"

cmd:        .res    SD_CMD_SIZE
csd:        .res    16
csdtmp:     .res    2
nr_sectors: .res    4
card_type:  .res    2
retries:    .res    2

        .segment "OSROM"

sdcard_name:
        .asciiz     "sdcard0"

sdcard_ops:
        .dword      sdc_open
        .dword      sdc_release
        .dword      sdc_rdblock
        .dword      sdc_wrblock
        .dword      sdc_ioctl
        .dword      sdc_mediachanged

.proc sdcard_register
        stz     card_type
        _PushLong sdcard_name
        _PushWord DEVICE_ID_SDCARD
        _PushLong sdcard_ops
        _PushLong 0
        jsr     register_device
        rts
.endproc

;-------- BlockOperations methods --------;

;;
; Attempt to initialize the SD card and bring it online
;
; Stack frame (top to bottm):
;
; |-----------------------|
; | [4] Pointer to Device |
; |-----------------------|
;
; On exit:
; C,X,Y trashed
;
.proc sdc_open
        _BeginDirectPage
          l_diskp     .dword
          _StackFrameRTL
          i_devicep   .dword
        _EndDirectPage

        _SetupDirectPage
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
        pha
        pha
        jsr     allocate_disk
        pla
        sta     l_diskp
        pla
        sta     l_diskp + 2
        ldyw    #Disk::device
        ldaw    i_devicep
        sta     [l_diskp],y     ; device (lo)
        iny
        iny
        ldaw    i_devicep + 2
        sta     [l_diskp],y     ; device (hi)
        iny
        iny
        ldaw    #0
        sta     [l_diskp],y     ; parent (lo)
        iny
        iny
        sta     [l_diskp],y     ; parent (hi)
        iny
        iny
        sta     [l_diskp],y     ; start_sector (lo)
        iny
        iny
        sta     [l_diskp],y     ; start_sector (hi)
        iny
        iny
        lda     nr_sectors
        sta     [l_diskp],y     ; num_sectors (lo)
        iny
        iny
        lda     nr_sectors + 2
        sta     [l_diskp],y     ; num_sectors (hi)
        iny
        iny
        ldaw    #0
        sta     [l_diskp],y     ; type
        lda     l_diskp + 2
        pha
        lda     l_diskp
        pha
        jsr     attach_disk
        tay
@exit:  _RemoveParams
        _SetExitState
        pld
        rtl
@error: longm
        ldyw    #ERR_NO_MEDIA
        bra     @exit
.endproc

;;
; Release the card.
;
; Stack frame (top to bottm):
;
; |-----------------------|
; | [4] Pointer to Device |
; |-----------------------|
;
; On exit:
; C,X,Y trashed
;
.proc sdc_release
        _BeginDirectPage
          _StackFrameRTL
          i_devicep  .dword
        _EndDirectPage

        _SetupDirectPage
        stz     card_type
        _RemoveParams
        ldaw    #0
        clc
        pld
        rtl
.endproc

;;
; Ioctl handler
;
; Stack frame (top to bottm):
;
; |--------------------------|
; | [4] Pointer to Device    |
; |--------------------------|
; | [2] Request              |
; |--------------------------|
; | [4] Reauest data pointer |
; |--------------------------|
;
; On exit:
; C,X,Y trashed
;
.proc sdc_ioctl
        _BeginDirectPage
          _StackFrameRTL
          i_devicep   .dword
          i_datap     .dword
          i_request   .word
        _EndDirectPage

        _SetupDirectPage
        _RemoveParams
        ldaw    #ERR_NOT_SUPPORTED
        sec
        pld
        rtl
.endproc

;;
; Read a single 512-byte block from the card
;
; Stack frame (top to bottm):
;
; |----------------------------|
; | [4] Pointer to Device      |
; |----------------------------|
; | [4] Sector number          |
; |----------------------------|
; | [4] Pointer to data buffer |
; |----------------------------|
;
; On exit:
; C,X,Y trashed
;
.proc sdc_rdblock
        _BeginDirectPage
          _StackFrameRTL
          i_devicep   .dword
          i_bufferp   .dword
          i_sector    .dword
        _EndDirectPage

        _SetupDirectPage
        lda     card_type
        bne     :+
        ldyw    #ERR_NO_MEDIA
        bra     @exit
:       shortm
        lda     #$51            ; CMD17
        sta     cmd
        ldxw    #0
        ldyw    #4
:       lda     i_sector,X
        sta     cmd,Y           ; flip byte order
        inx
        dey
        bne     :-
        jsr     send_cmd
        bne     @ioerr
        jsr     wait_data
        bcs     @ioerr
        ldyw    #0
:       lda     #SD_FILL
        jsl     spi_transfer
        sta     [i_bufferp],Y
        iny
        cpyw    #512
        bne     :-
        jsl     spi_transfer
        jsl     spi_transfer    ; Eat two-byte CRC
        jsr     deselect
        longm
        ldyw    #0
@exit:  _RemoveParams
        _SetExitState
        pld
        rtl
@ioerr: jsr     deselect
        longm
        ldyw    #ERR_IO_ERROR
        bra     @exit
.endproc

;;
; Write a single 512-byte block to the card
;
; Stack frame (top to bottm):
;
; |----------------------------|
; | [4] Pointer to Device      |
; |----------------------------|
; | [4] Sector number          |
; |----------------------------|
; | [4] Pointer to data buffer |
; |----------------------------|
;
.proc sdc_wrblock
        _BeginDirectPage
          _StackFrameRTL
          i_devicep   .dword
          i_bufferp   .dword
          i_sector    .dword
        _EndDirectPage

        _SetupDirectPage
        lda     card_type
        bne     :+
        ldyw    #ERR_NO_MEDIA
        bra     @exit
:       shortm
        lda     #$58            ; CMD24
        sta     cmd
        ldxw    #4
        ldyw    #0
:       lda     i_sector,Y
        sta     cmd,X           ; flip byte order
        iny
        dex
        bne     :-
        jsr     send_cmd
        bne     @ioerr
        lda     #SD_DATA_TOKEN
        jsl     spi_transfer
        ldyw    #0
:       lda     [i_bufferp],Y
        jsl     spi_transfer
        iny
        cpyw    #512
        bne     :-
        jsr     wait_rdy
        bcs     @ioerr
        and     #$1F
        cmp     #$05
        bne     @ioerr
        ldxw    #255
:       lda     #SD_FILL
        jsl     spi_transfer
        bne     @exit       ; exit when non-zero byte received
        dex
        bne     :-
@ioerr: jsr     deselect
        longm
        ldyw    #ERR_IO_ERROR
        bra     @exit
@done:  longm
        ldyw    #0
@exit:  _RemoveParams
        _SetExitState
        pld
        rtl
.endproc

;;
; Return true (nonzero) if the media was changed since the last call
;
; Stack frame (top to bottm):
;
; |-----------------------|
; | [4] Pointer to Device |
; |-----------------------|
;
; On exit:
; C = nonzero if media was changed, 0 if it was not
;
.proc sdc_mediachanged
        _BeginDirectPage
          _StackFrameRTL
          i_devicep  .dword
        _EndDirectPage

        _SetupDirectPage
        _RemoveParams
        ldaw    #0
        clc
        pld
        rtl
.endproc

; -------- Private functions --------

;;
; Attempt to initialize the SD card
;
; On exit:
; c = 0 on success
; c = 1 on failure
; C/X/Y trashed
;
.proc init_card
        jsl     spi_slow_speed
        jsr     set_spi_mode
        jsr     set_idle
        bcc     :+
        jmp     @error
:       send    @cmd08
        bcs     @v1             ; Might be an older card
        jsl     spi_transfer
        beq     :+
        jmp     @error
:       jsl     spi_transfer
        beq     :+
        jmp     @error
:       jsl     spi_transfer
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

.endproc

;;
; Put the SD card into SPI mode
;
; On exit: 
; C,X trashed
;
.proc set_spi_mode
        rts
        jsr     deselect
        ldxw    #10
:       lda     #SD_FILL
        jsl     spi_transfer
        dex
        bne     :-
        rts
.endproc

;;
; Put the SD card into the idle state
;
; On exit:
; C,X trashed
; c = 0 on success
; c = 1 on failure
;
.proc set_idle
        ldxw    #8
        send    @cmd00
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
.endproc

;;
; Read the card's CSD to determine card type and size
;
; On exit:
;
; All registers trashed
; c=0 and card_type set on success
; c=1 on error
;
.proc read_csd
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

.endproc

;;
; Wait for the SD card to be ready (return something other than $FF)
; 
; On exit:
;
; X trashed
; C contains received byte
; c=0 on success, 1 on failure
;
.proc wait_rdy
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
.endproc

;;
; Wait for the data start token
; 
; On exit:
;
; C,X trashed
; c=0 on success, 1 on failure
;
.proc wait_data
        ldxw    #0
@wait:  lda     #SD_FILL
        jsl     spi_transfer
        cmp     #SD_DATA_TOKEN
        beq     @done
        inx
        cpxw    #512
        bne     @wait
        sec
        rts
@done:  clc
        rts
.endproc

;;
; Send a command to the SD card. The pointer to the command to send should be
; on the stack.
;
.proc send_cmd
        jsl     spi_select_sdc
        ldyw    #0
:       lda     cmd,Y
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
@exit:  ora     #0
        rts
.endproc

;;
; Deselect the SD card interface board
;
.proc deselect
        jsl     spi_deselect
        lda     #SD_FILL
        jsl     spi_transfer        ; give SD card time to release DO
        rts
.endproc

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
.proc get_nr_sectors_v1
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
        sta     csdtmp
        lda     csd+10
        asl
        rol     csdtmp
        stz     csdtmp+1
        ldx     csdtmp
        inx
        inx                     ; C_SIZE_MULT+2
        jmp     csize_to_nr_sectors
.endproc

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
.proc get_nr_sectors_v2
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
.endproc
 
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
.proc csize_to_nr_sectors
        longm
        inc32   nr_sectors      ; Do the +1
:       asl     nr_sectors
        rol     nr_sectors+2    ; Shift left to multiply by 2^X
        dex
        bne     :-
        shortm
        rts
.endproc
