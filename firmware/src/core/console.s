; *******************************
; *  JRC-1 65816 SBC Firmware   *
; * (C) 2021 Joshua M. Thompson *
; *******************************

        .include "common.inc"
        .include "kernel/function_macros.inc"

        .export   kprint

        .import   putc_seriala
        .importzp ptr

        .segment "OSROM"

;;
; Print a null-terminated string to the kernel console (serial A)
;
; On exit:
; C,X undefined
;
.proc kprint
        _BeginDirectPage
          _StackFrameRTL
          i_ptr   .dword
        _EndDirectPage

        _SetupDirectPage
        shortm
        ldyw    #0
@loop:  lda     [i_ptr],y
        beq     @exit
        jsl     putc_seriala
        iny
        bne     @loop
@exit:  longm
        _RemoveParams
        pld
        rtl
.endproc
