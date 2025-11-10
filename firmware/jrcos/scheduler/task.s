; *******************************
; *  JRC-1 65816 SBC Firmware   *
; * (C) 2021 Joshua M. Thompson *
; *******************************
;
; Task struct management functions
;
; Unless otherwise noted all functions in this file must be called with
; interrupts disabled.

        .include    "common.inc"
        .include    "errors.inc"
        .include    "stack.inc"
        .include    "kernel/heap.inc"
        .include    "kernel/interrupts.inc"
        .include    "kernel/scheduler.inc"

        .export     build_task_list, start_task, task_quit, task_yield
        .exportzp   task

        .import     tasks
        .import     print_hex, reschedule
        .importzp   current_task,task_head,ptr

        .segment "ZEROPAGE"

task:   .res    2

        .segment "OSROM"

;;
; Initiliaze the task list. The list is preallocated in the BSS segment, but
; we still need to fill in the PID values.
;
.proc build_task_list
        ldaw    #.loword(tasks)
        sta     task

        ldxw    #1
@init:  txa
        ldyw    #Task::pid
        sta     (task),y
        inx
        cpxw    #MAX_TASKS+1
        beq     @done
        lda     task
        clc
        adcw    #.sizeof(Task)
        sta     task
        bra     @init
@done:  rts
.endproc

;;
; Start a new task (process). This does not actually run the new task;
; it simply makes it schedulable.
;
; Stack frame (top to bottm):
;
; |------------------------------|
; | [4] Entry point for new task |
; |------------------------------|
;
; On exit:
; c=0 on success and PID of new task in C
; c=1 on error and error code in C
; Y trashed
;
.proc start_task
        jsr     get_task_slot
        bcc     @go
        lda     1,s
        sta     5,s
        tsc
        clc
        adcw    #4
        tcs
        ldaw    #ENOMEM
        sec
        rts

        ; Each process gets 1K in bank $00, so multiply pid
        ; by 1024 to get the base address of this region.

@go:    ldyw    #Task::pid
        lda     (task),y             ; get PID
        ldxw    #10
:       asl
        dex
        bne     :-
        sta     ptr 
        stz     ptr + 2
        ; TODO: clear fd table
        ; init uid/gid/etc
        ldyw    #Task::state
        ldaw    #TASK_RUNNABLE
        sta     (task),y
        ldyw    #Task::sp
        lda     ptr
        clc
        adcw    #(TASK_STACK_TOP - INT_STACK_FRAME_SIZE)
        sta     (task),y

        ; build the task stack frame
        ldyw    #TASK_STACK_TOP - (INT_STACK_FRAME_SIZE - IntStackFrame::y_reg)
        ldaw    #0
        sta     [ptr],y         ; Y
        iny
        iny
        sta     [ptr],y         ; X
        iny
        iny
        sta     [ptr],y         ; A
        iny
        iny
        lda     ptr
        sta     [ptr],y         ; D
        iny
        iny
        shortm
        lda     #1
        sta     [ptr],y         ; B
        iny
        lda     #0
        sta     [ptr],y         ; P
        ldyw    #TASK_STACK_TOP - (INT_STACK_FRAME_SIZE - IntStackFrame::k_reg)
        lda     5,s
        sta     [ptr],y         ; K
        dey
        dey
        longm
        lda     3,s
        sta     [ptr],y         ; PC

        lda     task_head
        bne     @add

        ; empty task_head, so put this task in as the first and only entry
        lda     task
        sta     task_head
        ldyw    #Task::prev
        sta     (task_head)
        sta     (task_head),y
        bra     @exit

@add:   lda     (task_head)
        sta     (task)          ; task.next = task_head.next
        pha                     ; save for later

        lda     task
        sta     (task_head)     ; task_head.next = task

        ldyw    #Task::prev
        lda     task_head
        sta     (task),y        ; task.prev = task_head

        lda     task
        sta     (1,s),y         ; task_head.next.prev = task
        pla 

@exit:  lda     1,s
        sta     5,s
        tsc
        clc
        adcw    #4
        tcs
        clc
        rts
.endproc

;;
; Cause the current task to exit. It will be removed from the task list.
; A reschedule will then be triggered to pick a new task to run.
; 
; TODO: All the fun cleanup stuff. Close file descriptors, free memory, etc.
;
.proc task_quit
        ldyw    #Task::state
        ldaw    #TASK_UNUSED
        sta     (current_task),y
        ; TODO remove from task list
        jmp     reschedule
.endproc

;;
; Cause the current task to yield the remainder of its time slice.
; A reschedule will then be triggered to pick a new task to run.
;
.proc task_yield
        rts
.endproc

;;
; Look for a free slot in the process table.
;
; On exit:
; c = 0 on success, c = 1 on failure
; task = pointer to entry
;
.proc get_task_slot
        ldaw    #.loword(tasks)
        sta     task
        ldxw    #0
@loop:  ldyw    #Task::state
        lda     (task),y
        cmpw    #TASK_UNUSED
        beq     @done
        inx
        cpx     #MAX_TASKS
        beq     @done
        clc
        adcw    #.sizeof(Task)
        sta     task
        bra     @loop
@done:  clc
        rts
@notfound:
        stz     task
        ldaw    #ENOMEM
        sec
        rts
.endproc
