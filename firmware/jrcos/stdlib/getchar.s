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
; Read a single character from the console.
;
; On exit:
; C = the character read
;
.proc getchar
        php
        longm
        pha
        pha
        _PushLong 1
        _PushLong buffer
        _PushWord STDIN
        _read
        pla
        pla
        plp
        lda   f:buffer
        clc
        rtl
.endproc
