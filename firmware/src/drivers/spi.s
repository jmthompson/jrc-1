; *******************************
; *  JRC-1 65816 SBC Firmware   *
; * (C) 2021 Joshua M. Thompson *
; *******************************

; TODO:
; - no way to set spi mode through driver
; - spi_select_sdc doesn't respect spi_busy

        .include "common.inc"
        .include "errors.inc"
        .include "kernel/device.inc"
        .include "kernel/fs.inc"
        .include "kernel/function_macros.inc"

        .export spi_init
        .export spi_register
        .export spi_select_sdc
        .export spi_deselect
        .export spi_transfer
        .export spi_slow_speed
        .export spi_fast_speed

        .importzp ptr
        .importzp tmp

SPI_BASE = $F010

; 65SPI register numbers
SPI_DATA_REG    = SPI_BASE|$00    ; (R/W) SPI data register
SPI_STATUS_REG  = SPI_BASE|$01    ; (R) SPI status register
SPI_CTRL_REG    = SPI_BASE|$01    ; (R/W) SPI control register
SPI_SS_REG      = SPI_BASE|$03    ; (R/W) slave select

; Bits in the control/status register
SPI_TC      = $80   ; transmission complete
SPI_SR      = $80   ; Software reset
SPI_BSY     = $40   ; busy flag
SPI_IER     = $20   ; interrupt enable
SPI_FRX     = $10   ; Fast receive mode enable
SPI_TMO     = $08   ; Tri-state MOSI enable
SPI_ECE     = $04   ; External clock enable
SPI_CPOL    = $02   ; Clock polarity
SPI_CPHA    = $01   ; Clock phase

SPI_SS0     = $01   ; /SS0
SPI_SS1     = $02   ; /SS1
SPI_SS2     = $04   ; /SS2
SPI_SS3     = $08   ; /SS3
SPI_SS4     = $10   ; /SS4
SPI_SS5     = $20   ; /SS5
SPI_SS6     = $40   ; /SS6
SPI_SS7     = $80   ; /SS7

        .segment "BSS"

; Nonzero if the SPI hardware is busy (has a slave selecteD)
spi_busy:   .res    2

        .segment "BOOTROM"

;;
; Initialize the 65SPI
;
spi_init:
        lda     #SPI_SR
        sta     SPI_CTRL_REG      ; reset chip to defaults
        lda     #SPI_SS0|SPI_SS1|SPI_SS2|SPI_SS3|SPI_SS4|SPI_SS5|SPI_SS6|SPI_SS7
        sta     SPI_SS_REG        ; Disable all slaves
        stz     spi_busy
        rts

        .segment "OSROM"

spi_units:
        .byte   SPI_SS0^$FF
        .byte   SPI_SS1^$FF
        .byte   SPI_SS2^$FF
        .byte   SPI_SS3^$FF
        .byte   SPI_SS4^$FF
        .byte   SPI_SS5^$FF
        .byte   SPI_SS6^$FF
        .byte   SPI_SS7^$FF

spi_name:
        .asciiz     "spi"

spi_ops:
        .dword      spi_open
        .dword      spi_release
        .dword      spi_seek
        .dword      spi_xfer_bytes
        .dword      spi_xfer_bytes
        .dword      spi_flush
        .dword      spi_poll
        .dword      spi_ioctl

;;
; Register the SPI device drivers
;
.proc spi_register
        _PushLong spi_name
        _PushWord DEVICE_ID_SPI
        _PushLong spi_ops
        _PushLong 0
        jsr     register_device
        rts
.endproc

;-------- FileOperations methods --------;

;;
; Open the SPI device and select the slave device corresponding to the
; unit number.
;
; Stack frame (top to bottom):
;
; |---------------------------------------------|
; | [4] pointer to File representing the device |
; |---------------------------------------------|
;
; On exit:
; c = 0 on success, 1 on failure
; C,Y trashed
;
.proc spi_open
        _BeginDirectPage
          _StackFrameRTL
          i_file  .dword
        _EndDirectPage

        _SetupDirectPage
        bit     spi_busy
        bpl     :+
        ldyw    #ERR_DEVICE_BUSY
        bra     @exit
:       dec     spi_busy
        ldyw    #File::unit
        lda     [i_file],y
        tax
        shortm
        lda     f:spi_units,x
        sta     f:SPI_SS_REG
        longm
        ldyw    #0
@exit:  _RemoveParams
        _SetExitState
        pld
        rtl
.endproc

;;
; Release the SPI device, deselecting the targeted slave device.
;
; Stack frame (top to bottom):
;
; |---------------------------------------------|
; | [4] pointer to File representing the device |
; |---------------------------------------------|
;
; On exit:
; c = 0 on success, 1 on failure
; C,Y trashed
;
; Parameters:
; none
;
.proc spi_release
        _BeginDirectPage
          _StackFrameRTL
          i_file  .dword
        _EndDirectPage

        _SetupDirectPage
        shortm
        lda     #SPI_SS0|SPI_SS1|SPI_SS2|SPI_SS3|SPI_SS4|SPI_SS5|SPI_SS6|SPI_SS7
        sta     f:SPI_SS_REG
        longm
        stz     spi_busy
        _RemoveParams
        ldaw    #0
        clc
        pld
        rtl
.endproc

;;
; Seek
;
; Stack frame:
;
; |-------------------------------|
; | [4] Space for returned offset |
; |-------------------------------|
; | [4] Offset                    |
; |-------------------------------|
; | [2] Whence                    |
; |-------------------------------|
; | [4] Pointer to File           |
; |-------------------------------|
;
; On exit:
; C,X,Y trashed
;
.proc spi_seek
        _BeginDirectPage
          _StackFrameRTL
          i_filep   .dword
          i_whence  .word
          i_offset  .dword
          o_offset  .dword
        _EndDirectPage

        _SetupDirectPage
        _RemoveParams o_offset
        ldaw    #0
        clc
        pld
        rtl
.endproc

;;
; Read/write the SPI device. As SPI is bidirectional one function
; is used for both, and both operations happen at the same time.
;
; Stack frame (top to bottom):
;
; |---------------------------------------------|
; | [4] pointer to File representing the device |
; |---------------------------------------------|
; | [4] Pointer to buffer                       |
; |---------------------------------------------|
; | [4] Number of bytes to transfer             |
; |---------------------------------------------|
;
; Parameters:
; +0 : [2] Number of bytes to exchange
; +2 : [4] Pointer to buffer
;
.proc spi_xfer_bytes
        _BeginDirectPage
          _StackFrameRTL
          i_len     .dword
          i_buffer  .dword
          i_file    .dword
        _EndDirectPage

        _SetupDirectPage
        lda     i_len + 2
        beq     :+
        ldyw    #ERR_NOT_SUPPORTED
        bra     @exit
:       shortm
        ldyw    #0
@xfer:  lda     [ptr],y
        jsl     spi_transfer
        sta     [ptr],y
        iny
        cpy     tmp
        bne     @xfer
        longm
        ldaw    #0
@exit:  _RemoveParams
        _SetExitState
        pld
        rtl
.endproc 

.proc spi_flush
        _BeginDirectPage
          _StackFrameRTL
          i_file    .dword
        _EndDirectPage

        _SetupDirectPage
        _RemoveParams
        ldaw    #0
        clc
        pld
        rtl
.endproc

.proc spi_poll
        _BeginDirectPage
          _StackFrameRTL
          i_file    .dword
        _EndDirectPage

        _SetupDirectPage
        _RemoveParams
        ldaw    #0
        clc
        pld
        rtl
.endproc

.proc spi_ioctl
        _BeginDirectPage
          _StackFrameRTL
          i_file    .dword
        _EndDirectPage

        _SetupDirectPage
        _RemoveParams
        ldaw    #0
        clc
        pld
        rtl
.endproc

;-------- Private/Internal methods --------;

;;
; Select the SD card device. Call wit m=1
; 
; On exit:
; A undefined
;
spi_select_sdc:
        lda     #SPI_SS0^$FF
        sta     f:SPI_SS_REG
        rtl

;;
; Deselect all slaves. Call with m=1
; 
; On exit:
; A undefined
;
spi_deselect:
        lda     #SPI_SS0|SPI_SS1|SPI_SS2|SPI_SS3|SPI_SS4|SPI_SS5|SPI_SS6|SPI_SS7
        sta     f:SPI_SS_REG
        rtl

;;
; Exchange byte with the slave. Call with m=1
;
; On entry:
; A = byte to send
;
; On exit:
; A = byte received
;
spi_transfer:
        sta     f:SPI_DATA_REG     ; send byte
:       lda     f:SPI_STATUS_REG
        and     #SPI_TC
        beq     :-                 ; wait for TC=1
        lda     f:SPI_DATA_REG     ; get received byte
        rtl

;;
; Set slow (400 kHZ) SPI mode. Call with m=1
;
; On exit:
;
; SPI set to slow external clock
; A undefined
;
spi_slow_speed:
        lda     f:SPI_CTRL_REG
        ora     #SPI_ECE
        sta     f:SPI_CTRL_REG
        rtl

;;
; Set fast (phi2) SPI mode. Call with m=1
;
; On exit:
;
; SPI set to fast phi2 clock
; A undefined
;
spi_fast_speed:
        lda     f:SPI_CTRL_REG
        eor     #SPI_ECE
        sta     f:SPI_CTRL_REG
        rtl
