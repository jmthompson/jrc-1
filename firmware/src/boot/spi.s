; *******************************
; *  JRC-1 65816 SBC Firmware   *
; * (C) 2021 Joshua M. Thompson *
; *******************************

                .global         spi_init
                .global         spi_select
                .global         spi_select_sdc
                .global         spi_deselect
                .global         spi_transfer
                .global         spi_slow_speed
                .global         spi_fast_speed

spi_base        .equlab         0xF010

; 65SPI register numbers
spi_data_reg    .equlab         spi_base|0x00   ; (R/W) SPI data register
spi_status_reg  .equlab         spi_base|0x01   ; (R) SPI status register
spi_ctrl_reg    .equlab         spi_base|0x01   ; (R/W) SPI control register
spi_ss_reg      .equlab         spi_base|0x03   ; (R/W) slave select

; Bits in the control/status register
SPI_TC          .equ            0x80            ; transmission complete
SPI_SR          .equ            0x80            ; Software reset
SPI_BSY         .equ            0x40            ; busy flag
SPI_IER         .equ            0x20            ; interrupt enable
SPI_FRX         .equ            0x10            ; Fast receive mode enable
SPI_TMO         .equ            0x08            ; Tri-state MOSI enable
SPI_ECE         .equ            0x04            ; External clock enable
SPI_CPOL        .equ            0x02            ; Clock polarity
SPI_CPHA        .equ            0x01            ; Clock phase

SPI_SS0         .equ            0x01            ; /SS0
SPI_SS1         .equ            0x02            ; /SS1
SPI_SS2         .equ            0x04            ; /SS2
SPI_SS3         .equ            0x08            ; /SS3
SPI_SS4         .equ            0x10            ; /SS4
SPI_SS5         .equ            0x20            ; /SS5
SPI_SS6         .equ            0x40            ; /SS6
SPI_SS7         .equ            0x80            ; /SS7

                .section        bootcode

spi_slaves:     .byte           SPI_SS0^0xFF
                .byte           SPI_SS1^0xFF
                .byte           SPI_SS2^0xFF
                .byte           SPI_SS3^0xFF
                .byte           SPI_SS4^0xFF
                .byte           SPI_SS5^0xFF
                .byte           SPI_SS6^0xFF
                .byte           SPI_SS7^0xFF

;;
; Initialize the 65SPI
;
spi_init:       lda             #SPI_SR
                sta             spi_ctrl_reg    ; reset chip to defaults
                lda             #SPI_SS0|SPI_SS1|SPI_SS2|SPI_SS3|SPI_SS4|SPI_SS5|SPI_SS6|SPI_SS7
                sta             spi_ss_reg      ; Disable all slaves
                rts

;;
; Select an SD card device.
;
; On entry:
; C = slave ID to select
; 
spi_select:     sep             #0x20
                tax
                lda             long:spi_slaves,x
                sta             long:spi_ss_reg
                rep             #0x30
                rtl

;;
; Select the SD card device.
; 
spi_select_sdc: sep             #0x20
                lda             #SPI_SS0^0xFF
                sta             long:spi_ss_reg
                sep             #0x30
                rtl

;;
; Deselect all slaves.
;
spi_deselect:   sep             #0x20
                lda             #SPI_SS0|SPI_SS1|SPI_SS2|SPI_SS3|SPI_SS4|SPI_SS5|SPI_SS6|SPI_SS7
                sta             long:spi_ss_reg
                sep             #0x30
                rtl

;;
; Exchange byte with the slave.
;
; On entry:
; A = byte to send
;
; On exit:
; A = byte received
;
spi_transfer:   sep             #0x20
                sta             long:spi_data_reg  ; send byte
wait$:          lda             long:spi_status_reg
                and             #SPI_TC
                beq             wait$           ; wait for TC=1
                lda             long:spi_data_reg  ; get received byte
                sep             #0x30
                rtl

;;
; Set slow (400 kHZ) SPI mode.
;
spi_slow_speed: sep             #0x20
                lda             long:spi_ctrl_reg
                ora             #SPI_ECE
                sta             long:spi_ctrl_reg
                sep             #0x30
                rtl

;;
; Set fast (phi2) SPI mode. Call with m=1
;
; On exit:
;
; SPI set to fast phi2 clock
; A undefined
;
spi_fast_speed: sep             #0x20
                lda             long:spi_ctrl_reg
                eor             #SPI_ECE
                sta             long:spi_ctrl_reg
                sep             #0x30
                rtl
