; *******************************
; *  JRC-1 65816 SBC Firmware   *
; * (C) 2021 Joshua M. Thompson *
; *******************************

        .include "common.inc"
        .include "syscalls.inc"
        .include "stack.inc"
        .include "kernel/console.inc"

        .export phex
        .import putc_seriala

        .segment "OSROM"

;;
; Print the contents of the accumulator as a two-digit hexadecimal number.
;
; On exit:
;
; All registers preserved
;
phex:
        pha
        pha
        lsr
        lsr
        lsr
        lsr
        jsr     @digit
        pla
        and     #$0F
        jsr     @digit
        pla
        rts
@digit: and     #$0F
        ora     #'0'
        cmp     #'9'+1
        blt     :+
        adc     #6
:       _kputc
        rts
