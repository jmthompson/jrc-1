; *******************************
; *  JRC-1 65816 SBC Firmware   *
; * (C) 2025 Joshua M. Thompson *
; *******************************
;
; This is the idle task, a kernel-mode task that is runs as PID 0.
;

        .include "common.inc"
        .include "errors.inc"
       .include "kernel/console.inc"
        .include "kernel/scheduler.inc"

        .export  idle_task_loop
        .import  reschedule, jiffies, monitor_start

        .segment "OSROM"

;;
; Start the idle task. This is only ever called from the startup/reset code.
; It will never exit.
;
.proc idle_task_loop
        jsr     reschedule
        bra     idle_task_loop
.endproc
