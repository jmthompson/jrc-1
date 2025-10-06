; *******************************
; *  JRC-1 65816 SBC Firmware   *
; * (C) 2023 Joshua M. Thompson *
; *******************************
;
; File struct management functions

        .include    "common.inc"
        .include    "errors.inc"
        .include    "kernel/fs.inc"
        .include    "stack.inc"
        .include    "kernel/object.inc"
        .include    "kernel/scheduler.inc"

        .importzp   current_task, currfd, currfile

        .segment "OSROM"

;;
; Find a free file descriptor slot in the file table of the current process
; and return the new fd number in currfd
;
; On exit:
; c = 0 on success, 1 on failure
; currfd contains new fd
;
.proc get_free_fd
        ldxw    #0
        ldyw    #Task::files
@loop:  lda     [current_task],y
        iny
        iny
        ora     [current_task],y
        beq     @found
        iny
        iny
        inx
        cpxw    #TASK_MAX_FDS
        bne     @loop
        ldaw    #EMFILE
        sec
        rts
@found: stx     currfd
        ldaw    #0
        clc
        rts
.endproc

;;
; Given a file descriptor belonging to the current process,
; return the associated File pointer.
;
; On entry:
; C = file descriptor number
;
; On exit:
; c = 0 on success, 1 on failure
; C/X = file pointer (low/high)
;
.proc fd_to_file
        lda     currfd
        cmpw    #TASK_MAX_FDS
        bge     @bad
        asl
        asl
        clc
        adcw    #Task::files
        tay
        lda     [current_task],y
        sta     currfile
        iny
        iny
        lda     [current_task],y
        sta     currfile + 2
        ora     currfile
        beq     @bad
        ldaw    #0
        clc
        rts
@bad:   ldaw    #EINVAL
        sec
        rts
.endproc
