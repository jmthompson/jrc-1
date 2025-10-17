; *******************************
; *  JRC-1 65816 SBC Firmware   *
; * (C) 2021 Joshua M. Thompson *
; *******************************
;
; Task struct management functions

        .include    "common.inc"
        .include    "errors.inc"
        .include    "stack.inc"
        .include    "kernel/heap.inc"
        .include    "kernel/interrupts.inc"
        .include    "kernel/scheduler.inc"

        .export     build_task_list, start_task, task_quit, task_yield

        .import     task_list
        .import     print_hex
        .importzp   current_task,ptr

        .segment "ZEROPAGE"

task:   .res    4

        .segment "OSROM"

;;
; Initiliaze the task list. The list is preallocated in the BSS segment, but
; we still need to create the linked list and initialize all of the PID fields.
;
.proc build_task_list
        ldaw    #.loword(task_list)
        sta     task
        ldaw    #.hiword(task_list)
        sta     task + 2

        ; Task 0 is the idle task and is always runnable
        ldyw    #Task::state
        ldaw    #TASK_RUNNABLE
        sta     [task],y

        sei
        ldxw    #0
@init:  ldyw    #Task::pid
        txa
        sta     [task],y
        cpxw    #MAX_TASKS-1
        beq     @done
        lda     task
        clc
        adcw    #.sizeof(Task)
        sta     [task]
        pha
        ldyw    #Task::next + 2
        lda     task + 2
        sta     [task],y
        pla
        sta     task
        inx
        bra     @init
@done:  ldyw    #Task::next
        ldaw    #0
        sta     [task],y
        iny
        iny
        sta     [task],y
        cli
        rtl
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
        pla
        pla
        pla
        pla
        ldaw    #ENOMEM
        sec
        rtl

        ; Each process gets 1K in bank $00, so multiply pid
        ; by 1024 to get the base address of this region.

@go:    lda     [task]               ; get PID
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
        sta     [task],y
        ldyw    #Task::sp
        lda     ptr
        clc
        adcw    #(TASK_STACK_TOP - INT_STACK_FRAME_SIZE)
        sta     [task],y

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
        lda     6,s
        sta     [ptr],y         ; K
        dey
        dey
        longm
        lda     4,s
        sta     [ptr],y         ; PC
@exit:  clc
        rtl
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
        sta     [current_task],y
        rtl
.endproc

;;
; Cause the current task to yield the remainder of its time slice.
; A reschedule will then be triggered to pick a new task to run.
;
.proc task_yield
        rtl
.endproc

;;
; Look for a free slot in the process table.
;
; On exit:
; c = 0 on success, c = 1 on failure
; task = pointer to entry
;
.proc get_task_slot
        ldaw    #.loword(task_list)
        sta     task
        ldaw    #.hiword(task_list)
        sta     task + 2
@loop:  ldyw    #Task::state
        lda     [task],y
        cmpw    #TASK_UNUSED
        beq     @done
        lda     [task]
        tax
        ldyw    #Task::next + 2
        lda     [task],y
        sta     task + 2
        stx     task
        ora     task
        bne     @loop
@done:  clc
        rts
@notfound:
        stz     task
        stz     task + 2
        ldaw    #ENOMEM
        sec
        rts
.endproc
