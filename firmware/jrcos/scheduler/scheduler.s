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

        .import     task_list, monitor_start
        .importzp   current_task, next_task

        .segment "BSS"
flag:   .res    1

        .segment "OSROM"

.proc scheduler_init
        ldaw    #.loword(task_list)
        sta     current_task
        sta     next_task
        ldaw    #.hiword(task_list)
        sta     current_task + 2
        sta     next_task + 2

        ; Initialize task 0, which is always the kernel itself
        ldyw    #Task::state
        ldaw    #TASK_RUNNABLE
        sta     [current_task],y

        ; Now initialize the monitor task
        ldaw    #.loword(monitor_start)
        ldxw    #.hiword(monitor_start)
        jsr     start_task
        rtl
.endproc
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
        rtl
.endproc
