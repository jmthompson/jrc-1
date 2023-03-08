; *******************************
; *  JRC-1 65816 SBC Firmware   *
; * (C) 2023 Joshua M. Thompson *
; *******************************
;
; Context switching functions

        .include    "common.inc"
        .include    "ascii.inc"
        .include    "kernel/console.inc"
        .include    "kernel/linker.inc"
        .include    "kernel/scheduler.inc"

        .importzp   current_process

.segment "BSS"

a_tmp:  .res  2
d_tmp:  .res  2
y_tmp:  .res  2

        .segment "BOOTROM"

;;
; Save the current process' context
;
.proc save_context
        sta     f:a_tmp
        tdc
        sta     f:d_tmp
        tya
        sta     f:y_tmp

        ldaw    #OS_DP
        tcd

        ldyw    #Process::a_reg
        lda     f:a_tmp
        sta     [current_process],y
        iny
        iny
        shortm
        phb
        pla
        sta     [current_process],y
        longm
        iny
        lda     f:d_tmp
        sta     [current_process],y
        iny
        iny
        txa
        sta     [current_process],y
        iny
        iny
        lda     f:y_tmp
        sta     [current_process],y
        iny
        iny
        tsc
        inc
        inc                    ; remove caller's address on restore
        sta     [current_process],y
:       rts
.endproc

;;
; Restore the current process' context
;
.proc restore_context
        plx                     ; save return address
        ldyw    #Process::sp
        lda     [current_process],y
        tcs
        phx

        ldyw    #Process::a_reg
        lda     [current_process],y
        sta     f:a_tmp
        iny
        iny
        shortm
        lda     [current_process],y
        pha
        plb
        longm
        iny
        lda     [current_process],y
        sta     f:d_tmp
        iny
        iny
        lda     [current_process],y
        tax
        iny
        iny
        lda     [current_process],y
        tay
        lda     f:d_tmp
        tcd
        lda     f:a_tmp

        rts
.endproc
