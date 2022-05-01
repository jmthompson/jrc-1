; *******************************
; *  JRC-1 65816 SBC Firmware   *
; * (C) 2021 Joshua M. Thompson *
; *******************************

; TODO:
; - no way to set spi mode through driver
; - spi_select_sdc doesn't respect spi_busy

        .include "common.inc"
        .include "errors.inc"
        .include "device.inc"

        .export spi_init
        .export spi_select_sdc
        .export spi_deselect
        .export spi_transfer
        .export spi_slow_speed
        .export spi_fast_speed

        .import dm_register_internal

        .importzp   ptr
        .importzp   tmp

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

        .segment "SYSDATA"

; Nonzero if the SPI hardware is busy (has a slave selecteD)
spi_busy:   .res    2

        .segment "OSROM"

.macro  spi_driver  name, slave
        .word       0                   ; version
        .word       DEVICE_TYPE_CHAR    ; feature flags
        longaddr    @n                  ; device name
        longaddr    @p                  ; private data
        .word       11                  ; number of functions
        longaddr    spi_startup         ; #0
        longaddr    spi_shutdown        ; #1
        longaddr    spi_status          ; #2
        longaddr    spi_open            ; #3
        longaddr    spi_close           ; #4
        longaddr    spi_xfer_byte       ; #5
        longaddr    spi_xfer_bytes      ; #6
        longaddr    spi_xfer_byte       ; #7
        longaddr    spi_xfer_bytes      ; #8
        longaddr    spi_get_mode        ; #9
        longaddr    spi_set_mode        ; #10
@n:     .byte   name, 0
@p:     .byte   slave^$FF
.endmacro

spi1_driver:    spi_driver "SPI1", SPI_SS1
spi2_driver:    spi_driver "SPI2", SPI_SS2
spi3_driver:    spi_driver "SPI3", SPI_SS3
spi4_driver:    spi_driver "SPI4", SPI_SS4
spi5_driver:    spi_driver "SPI5", SPI_SS5
spi6_driver:    spi_driver "SPI6", SPI_SS6
spi7_driver:    spi_driver "SPI7", SPI_SS7

;;
; Initialize the SPI hardware and register our devices
spi_init:
        shortm
        lda     #SPI_SR
        sta     f:SPI_CTRL_REG     ; reset chip to defaults
        lda     #SPI_SS0|SPI_SS1|SPI_SS2|SPI_SS3|SPI_SS4|SPI_SS5|SPI_SS6|SPI_SS7
        sta     f:SPI_SS_REG       ; Disable all slaves
        longm

        stz     spi_busy

        REGISTER_DEVICE spi1_driver
        REGISTER_DEVICE spi2_driver
        REGISTER_DEVICE spi3_driver
        REGISTER_DEVICE spi4_driver
        REGISTER_DEVICE spi5_driver
        REGISTER_DEVICE spi6_driver
        REGISTER_DEVICE spi7_driver

        rtl

;;
; STARTUP
;
; Start the SPI device. Currently a no-op
;
; Parameters:
; none
;
spi_startup:
        DRVR_SUCCESS

;;
; SHUTDOWN
;
; Shut down the SPI device. Currently a no-op
;
; Parameters:
; none
;
spi_shutdown:
        DRVR_SUCCESS

;;
; STATUS
;
; Return the device status
;
; Parameters:
; none
;
spi_status:
        DRVR_SUCCESS

;;
; OPEN
;
; Open the SPI device. This causes the target SPI slave to be selected.
;
; Parameters:
; none
;
spi_open:
        DRVR_ENTER
        DRVR_PRIVATE ptr

        bit     spi_busy
        bmi     @busy
:       ldaw    #$8000
        sta     spi_busy
        shortm
        lda     [ptr]       ; get slave select bit from private data
        sta     f:SPI_SS_REG
        longm

        DRVR_SUCCESS
@busy:  DRVR_ERROR  ERR_DEVICE_BUSY

;;
; CLOSE
;
; Close the SPI device. This causes the target SPI slave to be deselected.
;
; Parameters:
; none
;
spi_close:
        DRVR_ENTER

        shortm
        lda     #SPI_SS0|SPI_SS1|SPI_SS2|SPI_SS3|SPI_SS4|SPI_SS5|SPI_SS6|SPI_SS7
        sta     f:SPI_SS_REG
        longm
        stz     spi_busy

        DRVR_SUCCESS

;;
; READ_BYTE/WRITE_BYTE
;
; Transmit a single byte to the SPI slave, while simultaneously
; receiving a single byte in return
;
; Parameters:
; A = byte to send
;
; On exit:
; A = Byte received
;
spi_xfer_byte:
        DRVR_ENTER

        shortm
        jsl     spi_transfer
        longm
        clc

        DRVR_EXIT

;;
; READ_BYTES/WRITE_BYTES
;
; Transmit multiple bytes to the SPI slave, while simultaneously
; receiving an equal number of bytes in return.
;
; Parameters:
; +0 : [2] Number of bytes to exchange
; +2 : [4] Pointer to buffer
;
spi_xfer_bytes:
        DRVR_ENTER
        DRVR_PARAMS ptr

        lda     [ptr]
        sta     tmp         ; Get byte count
        ldyw    #2
        lda     [ptr],y
        tax
        iny
        iny
        lda     [ptr],y
        sta     ptr+2       ; [ptr] now points to buffer
        stx     ptr
        
        shortm
        ldyw    #0
@xfer:  lda     [ptr],y
        jsl     spi_transfer
        sta     [ptr],y
        iny
        cpy     tmp
        bne     @xfer
        longm

        DRVR_SUCCESS

;;
; GET_MODE
;
; Get the SPI transfer mode.
;
; Parameters;
; +0 : [2] 0 = slow mode, 1 = fast mode
;
spi_get_mode:
        DRVR_SUCCESS

;;
; SET_MODE
;
; Set the SPI transfer mode.
;
; Parameters;
; +0 : [2] 0 = slow mode, 1 = fast mode
;
spi_set_mode:
        DRVR_SUCCESS
        DRVR_PARAMS ptr
        DRVR_SUCCESS

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
