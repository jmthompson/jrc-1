; *******************************
; *  JRC-1 65816 SBC Firmware   *
; * (C) 2021 Joshua M. Thompson *
; *******************************
;
; Process struct management functions

        .include    "common.inc"
        .include    "errors.inc"
        .include    "kernel/function_macros.inc"
        .include    "kernel/heap.inc"
        .include    "kernel/interrupts.inc"
        .include    "kernel/scheduler.inc"

        .import     processes

        .segment "ZEROPAGE"

ptr:    .res    4
bank0:  .res    4

        .segment "BSS"

tmp:    .res    4

        .segment "OSROM"

;;
; Start a new task (process). This does not actually run the new task;
; it simply makes it schedulable.
;
; On entry:
; A/X = pointer to new task entry point (hi/low)
;
; On exit:
; PID in something
;
.proc start_task
        sta     tmp
        stx     tmp + 2
        
        jsr     get_task_slot
        bcc     @bank0
        ldaw    #ENOMEM
        sec
        rts

        ; Each process gets 1K in bank $00, so multiply pid
        ; by 1024 to get the base address of this region.

@bank0: lda     [ptr]               ; get PID
        ldxw    #10
:       asl
        dex
        bne     :-
        sta     bank0
        stz     bank0 + 2

        ; TODO: clear fd table
        ; init uid/gid/etc
        ldyw    #Process::state
        ldaw    #TASK_RUNNABLE
        sta     [ptr],y
        ldyw    #Process::sp
        lda     bank0
        clc
        adcw    #TASK_STACK_TOP
        sta     [ptr],y

        ; build the task stack frame
        ldyw    #TASK_STACK_TOP - (INT_STACK_FRAME_SIZE - IntStackFrame::y_reg)
        ldaw    #0
        sta     [bank0],y         ; Y
        iny
        iny
        sta     [bank0],y         ; X
        iny
        iny
        sta     [bank0],y         ; A
        iny
        iny
        lda     bank0
        sta     [bank0],y         ; D
        iny
        iny
        shortm
        lda     #1
        sta     [bank0],y         ; B
        iny
        lda     #0
        sta     [bank0],y         ; P
        ldyw    #TASK_STACK_TOP - (INT_STACK_FRAME_SIZE - IntStackFrame::k_reg)
        lda     tmp + 2
        sta     [bank0],y         ; K
        dey
        dey
        longm
        lda     tmp
        sta     [bank0],y         ; PC
@exit:  clc
        rts
.endproc

;;
; Look for a free slot in the process table.
;
; On exit:
; c = 0 on success, c = 1 on failure
; ptr = pointer to entry
;
.proc get_task_slot
        ldaw    #.loword(processes)
        sta     ptr
        ldaw    #.hiword(processes)
        sta     ptr + 2
        ldxw    #0
        ldyw    #Process::state
@loop:  lda     [ptr],y
        cmpw    #TASK_UNUSED
        beq     @done
        inx
        cpxw    #MAX_PROCESSES
        beq     @notfound
        lda     ptr
        clc
        adcw    #.sizeof(Process)
        sta     ptr
        lda     ptr + 2
        adcw    #0
        sta     ptr + 2
        bra     @loop
@done:  clc
        rts
@notfound:
        stz     ptr
        stz     ptr + 2
        ldaw    #ENOMEM
        sec
        rts
.endproc
