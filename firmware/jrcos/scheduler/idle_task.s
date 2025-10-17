; *******************************
; *  JRC-1 65816 SBC Firmware   *
; * (C) 2025 Joshua M. Thompson *
; *******************************
;
; This is the idle task, a kernel-mode task that is runs as PID 0.
;

        .include "common.inc"
        .include "errors.inc"
        .include "kernel/scheduler.inc"

        .export  idle_task

        .import  monitor_start, task_list, start_task
        .importzp next_task

        .segment "OSROM"

;;
; Start the idle task. This is only ever called from the startup/reset code.
; It will never exit.
;
.proc idle_task
        ; Start the system monitor. It will run as soon as we reschedule
        _PushLong monitor_start
        jsl     start_task

        ; Quick and dirty reschedule, for now
        sei
        ldaw    #.loword(task_list)
        clc
        adcw    #.sizeof(Task)
        sta     next_task
        cli
:       bra     :-

.endproc
