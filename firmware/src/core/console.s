; *******************************
; *  JRC-1 65816 SBC Firmware   *
; * (C) 2021 Joshua M. Thompson *
; *******************************

        .include "common.inc"

        .export   kprint

        .import   putc_seriala
        .importzp ptr

        .segment "OSROM"

;;
; Print a null-terminated string to the kernel console (serial A)
;
; On exit:
; C,X undefined
;
.proc kprint
        php
        longmx
        lda     5,s
        sta     ptr
        lda     7,s
        sta     ptr + 2
        lda     1,s
        sta     5,s
        lda     3,s
        sta     7,s
        tsc
        clc
        adcw    #4
        tcs
        shortm
        ldyw    #0
@loop:  lda     [ptr],y
        beq     @exit
        jsl     putc_seriala
        iny
        bne     @loop
@exit:  plp
        rtl
.endproc
