; *******************************
; *  JRC-1 65816 SBC Firmware   *
; * (C) 2021 Joshua M. Thompson *
; *******************************

        .include "common.inc"
        .include "ascii.inc"
        .include "kernel/console.inc"

        .export dump_stack
        .import putc_seriala, phex

        .segment "OSROM"

.macro print_stack offset
        lda   offset+2,s
        jsr   phex
        lda   #' '
        jsl   putc_seriala
.endmacro

.macro lf
        lda     #CR
        _kputc
        lda     #LF
        _kputc
.endmacro

.proc dump_stack
        shortm
        lf
        print_stack      1
        print_stack      2
        print_stack      3
        print_stack      4
        print_stack      5
        print_stack      6
        print_stack      7
        print_stack      8
        print_stack      9
        print_stack      10
        print_stack      11
        print_stack      12
        print_stack      13
        print_stack      14
        print_stack      15
        print_stack      16
        lf
        print_stack      17
        print_stack      18
        print_stack      19
        print_stack      20
        print_stack      21
        print_stack      22
        print_stack      23
        print_stack      24
        print_stack      25
        print_stack      26
        print_stack      27
        print_stack      28
        print_stack      29
        print_stack      30
        print_stack      31
        print_stack      32
        lf
        longm
        rts
.endproc
