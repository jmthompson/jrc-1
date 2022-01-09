; *******************************
; *  JRC-1 65816 SBC Firmware   *
; * (C) 2021 Joshua M. Thompson *
; *******************************

        .include "common.s"
        .include "sys/ascii.s"
        .include "sys/devices.s"
        .include "sys/io.s"

        .export console_init
        .export console_writeln

        .import getc_seriala
        .import putc_seriala

        .importzp   param

        .segment "BOOTROM"

console_init:
        jsl     console_reset
        rts

console_reset:
        ldx     #0
:       lda     @reset,x
        beq     :+
        jsl     putc_seriala
        inx
        bne     :-
:       clc
        rtl
@reset: .byte   ESC,"c"     ; reset terminal to default state
        .byte   ESC,"[7h"   ; enable line wrap
        .byte   ESC,")0"    ; set char set G1 to line drawing chars
        .byte   ESC,"[2J"   ; clear screen
        .byte   0

;;
; Print a null-terminated string up to 255 characters in length.
;
console_writeln:
        ldy     #0
@loop:  lda     [param],y
        beq     @exit
        jsl     putc_seriala
        iny
        bne     @loop
@exit:  rtl
