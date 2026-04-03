; *******************************
; *  JRC-1 65816 SBC Firmware   *
; * (C) 2023 Joshua M. Thompson *
; *******************************

        .include "common.inc"
        .include "syscalls.inc"
        .include "stdio.inc"
        .include "stack.inc"

        .segment "LIBDATA"

buffer: .res  2

        .segment "LIBCODE"

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
        _PushWord 1
        _PushLong buffer
        _PushWord STDIN
        _read
        pla
        cmpw  #0
        beq   @empty
        lda   f:buffer
        plp
        clc
        rtl
@empty: plp
        sec
        rtl
        
.endproc
