; *******************************
; *  JRC-1 65816 SBC Firmware   *
; * (C) 2021 Joshua M. Thompson *
; *******************************

        .include "common.inc"
        .include "kernel/function_macros.inc"

        .export kmemcpy

        .segment "OSROM"

;;
; Copy data from one memory location to another
;
; This can copy at most 64k bytes and can cross bank boundaries.
; TODO: maybe rewrite to use MVP/MVN
;
; Stack frame (top to bottm):
;
; |-----------------------------|
; | [4] Source pointer          |
; |-----------------------------|
; | [4] Destination pointer     |
; |-----------------------------|
; | [2] Number of bytes to copy |
; |-----------------------------|
;
; On exit:
; C,X,Y trashed
;
.proc kmemcpy
        _BeginDirectPage
          _StackFrameRTL
          i_len   .word
          i_dst   .dword
          i_src   .dword
        _EndDirectPage

        _SetupDirectPage
        ldy     i_len
        iny
:       dey
        lda     [i_src],y
        sta     [i_dst],y
        cpyw    #0
        bne     :-
        _RemoveParams
        pld
        rtl
.endproc
