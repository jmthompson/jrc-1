; *******************************
; *  JRC-1 65816 SBC Firmware   *
; * (C) 2023 Joshua M. Thompson *
; *******************************
;
; Filesystem initialization code

        .include    "common.inc"
        .include    "ascii.inc"
        .include    "kernel/console.inc"
        .include    "kernel/linker.inc"
        .include    "kernel/scheduler.inc"

        .import     processes
        .importzp   current_process

        .segment "BSS"
flag:   .res    1

        .segment "OSROM"

.proc sched_yield
        shortm
        lda     #.bankbyte(@ret)
        pha
        longm
        pea     .loword(@ret)
        php
        phb
        phd
        pha
        phx
        phy
        ldaw    #OS_DP
        tcd
        jsl     scheduler_tick
        ply
        plx
        pla
        pld
        plb
        rti
@ret:   rtl
.endproc

.proc scheduler_tick
        ldaw    #.loword(processes)
        sta     current_process
        ldaw    #.hiword(processes)
        sta     current_process + 2
        lda     f:flag
        andw    #1
        bne     :+
        lda     current_process
        clc
        adcw    #.sizeof(Process)
        ;sta     current_process
:       lda     f:flag
        inc
        sta     f:flag
        rtl
.endproc
