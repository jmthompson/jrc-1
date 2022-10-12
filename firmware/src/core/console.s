; *******************************
; *  JRC-1 65816 SBC Firmware   *
; * (C) 2021 Joshua M. Thompson *
; *******************************

        .include "common.inc"
        .include "ascii.inc"

        .export console_cll
        .export console_cls
        .export console_init
        .export console_reset
        .export console_writeln

        .import putc_seriala

        .segment "BOOTROM"

console_init:
        php
        jsl     console_reset
        jsl     console_cls
        plp
        rts

console_reset:
        shortmx
        ldx     #0
:       lda     f:@reset,x
        beq     :+
        phx
        jsl     putc_seriala
        plx
        inx
        bne     :-
:       clc
        rtl
@reset: .byte   ESC,"c"     ; reset terminal to default state
        .byte   ESC,"[7h"   ; enable line wrap
        .byte   ESC,")0"    ; set char set G1 to line drawing chars
        .byte   0

console_cls:
        shortmx
        lda     #ESC
        jsl     putc_seriala
        lda     #LBRACKET
        jsl     putc_seriala
        lda     #'2'
        jsl     putc_seriala
        lda     #'J'
        jml     putc_seriala

console_cll:
        shortmx
        lda     #ESC
        jsl     putc_seriala
        lda     #LBRACKET
        jsl     putc_seriala
        lda     #'2'
        jsl     putc_seriala
        lda     #'K'
        jml     putc_seriala
        
;;
; Print a null-terminated string up to 255 characters in length.
;
console_writeln:

; Input parameters
@str = $01

        shortmx
        ldy     #0
@loop:  lda     [@str],y
        beq     @exit
        jsl     putc_seriala
        iny
        bne     @loop
@exit:  rtl
