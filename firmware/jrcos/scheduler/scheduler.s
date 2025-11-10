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

        .import     tasks, idle_task, build_task_list, start_task
        .importzp   current_task, next_task, task_head, task

        .segment "OSROM"

.proc scheduler_init
        jsr     build_task_list
        ldaw    #.loword(idle_task)
        sta     current_task
        sta     next_task
        stz     task_head
        
        rts
.endproc

;;
; Schedule a new task to run.
;
; This implementation is horribly naive but will work for now. It just round-
; robins through runnable tasks. If nothing is ready to run the idle task will
; be schedule instead.
;
.proc reschedule
        lda     current_task
        cmpw    #.loword(idle_task)
        bne     :+
        lda     task_head
:       beq     @idle             ; no runnable tasks, so run the idle task
        sta     task
@loop:  lda     (task)
        cmp     current_task      ; Have we looped around?
        beq     @done
        sta     task
        ldyw    #Task::state
        lda     (task),y
        cmpw    #TASK_RUNNABLE
        bne     @loop
        lda     task
        sta     next_task
@done:  rts
@idle:  ldaw    #.loword(idle_task)
        sta     next_task
        rts
.endproc

;;
; Housekeeping function called during the system tick interrupt. The main purpose
; here is to call reschedule() to swap tasks on every tick.
; 
; This is called from the interrupt handler in bank 0 so it must exit with RTL.
;
.proc scheduler_tick
        jsr     reschedule
        rtl
.endproc
