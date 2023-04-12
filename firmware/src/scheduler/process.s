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
        _BeginDirectPage
          l_bank0   .dword
          _StackFrameRTS
        _EndDirectPage

        _SetupDirectPage
        sta     tmp
        stx     tmp + 2
        
        jsr     get_task_slot
        bcc     @bank0
        ldyw    #ENOMEM
        bra     @exit

        ; Each process gets 1K in bank $00, so multiply pid
        ; by 1024 to get the base adress of this region.

@bank0: lda     [ptr]               ; get PID
        ldxw    #10
:       asl
        dex
        bne     :-
        sta     bank0
        stz     bank0 + 2

        ldyw    #Process::d_reg
        sta     [ptr],y
        ldyw    #Process::sp
        clc
        adcw    #$03FB
        sta     [ptr],y

        ; TODO: clear fd table
        ; init uid/gid/etc
        ldyw    #Process::state
        ldaw    #TASK_RUNNABLE
        sta     [ptr],y

        ; make fake stack frame

        shortm
        ldyw    #$03FC
        lda     #0
        sta     [bank0],y         ; P
        ldyw    #$03FF
        lda     tmp + 2
        sta     [bank0],y         ; K
        longm
        ldyw    #$03FD
        lda     tmp
        sta     [bank0],y         ; PC
@exit:  _RemoveParams
        _SetExitState
        pld
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
