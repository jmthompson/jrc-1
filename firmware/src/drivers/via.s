; *******************************
; *  JRC-1 65816 SBC Firmware   *
; * (C) 2021 Joshua M. Thompson *
; *******************************

        .include "common.inc"
        .include "errors.inc"

        .importzp   jiffies

        .export     via_init
        .export     via_irq
        .export     wait_ms
        .export     via_register

PB_ACT_LED = $80        ; Activity LED
PB_CONSOLE = $40        ; Console select jumper

; VIA register numbers
via_portb  = $00
via_porta  = $01
via_ddrb   = $02
via_ddra   = $03
via_t1cl   = $04
via_t1ch   = $05
via_t1ll   = $06
via_t1lh   = $07
via_t2cl   = $08
via_t2ch   = $09
via_sr     = $0A
via_acr    = $0B
via_pcr    = $0C
via_ifr    = $0D
via_ier    = $0E
via_portax = $0F

via_base := $F000

        .segment "BOOTROM"

        .a8
        .i8

via_init:
        ; Disable all interrupts
        lda     #$7F
        sta     via_base+via_ier

        ; Disable timers & shift registers
        stz     via_base+via_acr

        ; VIA ports A & B
        stz     via_base+via_porta
        stz     via_base+via_portb
        stz     via_base+via_ddra

        ; SPI clock 400 kHZ
        lda     #$C0
        sta     via_base+via_acr
        lda     #8                ; assuming 8 MHz phi2
        sta     via_base+via_t1cl
        stz     via_base+via_t1ch

        rts

via_irq:
        ; dispatch to registered handler
 
@exit:  rts

; Wait up to 7ms (assuming 8MHz phi2 clock), with about 1% error because
; we use a x8192 multiplier instead of x8000. Must be called with m=1.
;
; On entry:
; A = number of ms to wait, 0-7.
;
; On exit:
; A trashed

wait_ms:
        pha
        lda     #0
        sta     f:via_base+via_t2cl
        pla
        and     #$07        ; can't wait more than about 7 ms
        asl
        asl
        asl
        asl
        asl                 ; x8192 because this will be the upper byte
        sta     f:via_base+via_t2ch
:       lda     f:via_base+via_ifr
        and     #$20
        beq     :-
        lda     f:via_base+via_t2cl
        rtl

        .segment "OSROM"

via_register:
        rts
