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

        .export     scheduler_init, scheduler_tick, reschedule

        .import     task_list, build_task_list
        .importzp   current_task, next_task

        .segment "OSROM"

.proc scheduler_init
        jsl     build_task_list

        ldaw    #.loword(task_list)
        sta     current_task
        sta     next_task
        ldaw    #.hiword(task_list)
        sta     current_task + 2
        sta     next_task + 2
        rtl
.endproc

;;
; Schedule a new task to run.
;
; This implementation is horribly naive but will work for now. It just round-
; robins through runnable tasks. If nothing is ready to run the idle task will
; be schedule instead.
;
.proc reschedule
        rtl
.endproc

;;
; Housekeeping function called during the system tick interrupt. The main purpose
; here is to call reschedule() to swap tasks on every tick.
;
.proc scheduler_tick
        jml      reschedule
.endproc
