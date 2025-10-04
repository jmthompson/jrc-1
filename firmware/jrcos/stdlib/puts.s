; *******************************
; *  JRC-1 65816 SBC Firmware   *
; * (C) 2023 Joshua M. Thompson *
; *******************************

        .include "common.inc"
        .include "syscalls.inc"
        .include "stdio.inc"
        .include "kernel/function_macros.inc"

        .segment "OSROM"

;;
; Print a text string to the console.
;
; Stack frame:
;
; |--------------------------------|
; | [4] Pointer to string to print |
; |--------------------------------|
;
; On exit:
; C,Y undefined
;
.proc puts
        _BeginDirectPage
          _StackFrameRTL
          i_str   .dword
        _EndDirectPage

        _SetupDirectPage
        shortm
        ldyw    #0
@size:  lda     [i_str],y
        beq     @go
        cpyw    #$FFFF
        beq     @go
        iny
        bra     @size
@go:    longm
        pha
        pha
        pea     0
        phy
        lda     i_str + 2
        pha
        lda     i_str
        pha
        _PushWord STDOUT
        _write
        pla
        pla
        _RemoveParams
        pld
        rtl
.endproc
