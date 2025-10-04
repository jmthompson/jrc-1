; *******************************
; *  JRC-1 65816 SBC Firmware   *
; * (C) 2023 Joshua M. Thompson *
; *******************************

        .include "common.inc"
        .include "syscalls.inc"
        .include "stdio.inc"
        .include "kernel/function_macros.inc"

        .segment "BSS"

buffer: .res  2

        .segment "OSROM"

;;
; Output a single character to the console.
;
; On entry:
; A = characer to print
;
; On exit:
; C undefined
;
.proc putchar
        php
        longm
        sta     f:buffer
        pha
        pha
        _PushLong 1
        _PushLong buffer
        _PushWord STDOUT
        _write
        pla
        pla
        plp
        lda     f:buffer
        rtl
.endproc
