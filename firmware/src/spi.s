; *******************************
; *  JRC-1 65816 SBC Firmware   *
; * (C) 2021 Joshua M. Thompson *
; *******************************

        .include "common.s"

        .export spi_init
        .export spi_irq
        .export spi_select
        .export spi_deselect
        .export spi_transfer

; VIA register numbers
spi_data   = $00    ; (R/W) SPI data register
spi_status = $01    ; (R) SPI status register
spi_ctrl   = $01    ; (R/W) SPI control register
spi_ss     = $03    ; (R/W) slave select

spi_base := $F010

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
SPI_SS4     = $01   ; /SS4
SPI_SS5     = $02   ; /SS5
SPI_SS6     = $04   ; /SS6
SPI_SS7     = $08   ; /SS7

        .segment "BOOTROM"

        .a8
        .i8

spi_init:
        ; Reset chip to defaults
        lda     #SPI_SR
        sta     spi_base+spi_ctrl

        ; Disable all slaves
        lda     #SPI_SS0|SPI_SS1|SPI_SS2|SPI_SS3|SPI_SS4|SPI_SS5|SPI_SS6|SPI_SS7
        sta     spi_base+spi_ss

        rts

spi_irq:
        rts

;;
; Select slave 0-3. Slave number is in A
;
spi_select:
        phx
        and     #$03
        tax
        lda     @slave,X
        sta     spi_base+spi_ss
        plx
        rts
@slave: .byte   SPI_SS0
        .byte   SPI_SS1
        .byte   SPI_SS2
        .byte   SPI_SS3
        .byte   SPI_SS4
        .byte   SPI_SS5
        .byte   SPI_SS6
        .byte   SPI_SS7

;;
; Deselect all slaves
;
spi_deselect:
        pha
        lda     #SPI_SS0|SPI_SS1|SPI_SS2|SPI_SS3|SPI_SS4|SPI_SS5|SPI_SS6|SPI_SS7
        sta     spi_base+spi_ss
        pla
        rts

;;
; Send byte in A to the currently selected slave,
; and return the received byte back in A
;
spi_transfer:
        sta     spi_base+spi_data   ; send byte
        lda     #SPI_TC
@wait:  bit     spi_base+spi_status
        beq     @wait               ; wait for TC=1
        lda     spi_base+spi_data   ; get received byte
        rts
