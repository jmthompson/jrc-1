; *******************************
; *  JRC-1 65816 SBC Firmware   *
; * (C) 2023 Joshua M. Thompson *
; *******************************
;
; File struct management functions

        .include    "common.inc"
        .include    "errors.inc"
        .include    "kernel/fs.inc"
        .include    "kernel/function_macros.inc"
        .include    "kernel/object.inc"
        .include    "kernel/scheduler.inc"

        .importzp   current_process, currfd, currfile

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
        ldyw    #Process::files
@loop:  lda     [current_process],y
        iny
        iny
        ora     [current_process],y
        beq     @found
        iny
        iny
        inx
        cpxw    #PROC_MAX_FDS
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
        cmpw    #PROC_MAX_FDS
        bge     @bad
        asl
        asl
        clc
        adcw    #Process::files
        tay
        lda     [current_process],y
        sta     currfile
        iny
        iny
        lda     [current_process],y
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
