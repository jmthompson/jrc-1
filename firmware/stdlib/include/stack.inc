;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Macros for writing functions that take parameters on the stack.              ;
;                                                                              ;
; To use these functions you need to declare your function with .PROC, because ;
; these macros create labels that must be within a local scope.                ;
;                                                                              ;
; .proc function_name                                                          ;
;   _BeginDirectPage                                                           ;
;     l_local1      .word                                                      ;
;     l_local2      .byte                                                      ;
;     _SysParams                                                               ;
;     i_first_arg   .word                                                      ;
;     i_second_arg  .word                                                      ;
;     o_ret_value   .dword                                                     ;
;   _EndParams                                                                 ;
;                                                                              ;
;   _SetupDirectPage                                                           ;
;   ... code here ...                                                          ;
;   _RemoveParams                                                              ;
;   rtl                                                                        ;
; .endproc                                                                     ;
;                                                                              ;
; This function would be called like this:                                     ;
;                                                                              ;
;   pha                                                                        ;
;   pha       ; space for dword return value                                   ;
;   pea first_arg                                                              ;
;   pea second_parg                                                            ;
;   jsr function                                                               ;
;   pla                                                                        ;
;   sta result                                                                 ;
;   pla                                                                        ;
;   sta result + 2                                                             ;
;                                                                              ;
; The use of .proc to define the function makes sure that the names of the     ;
; parameters will not conflict with other, similarly-named parameters in other ;
; functions in the same source file.                                           ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;
; Begin defining the direct page.
;
.macro _BeginDirectPage
        .struct
        .res 1
.endmacro

;;
; Add the parameters representing the saved direct page and the function return
; address.
;
.macro _StackFrameRTS
        s_dreg    .word
        s_ret     .word
.endmacro

.macro _StackFrameRTL
        s_dreg    .word
        s_ret     .word
        s_bank    .byte
.endmacro

;;
; Signal the end of the direct page definition
;
.macro _EndDirectPage
        _pend  .byte
        .endstruct
.endmacro

;;
; Function preamble for setting up the direct page.
;
; The current DP is saved on the stack
;
.macro _SetupDirectPage
        phd
        tsc
.if s_dreg > 1
        sec
        sbcw    #s_dreg-1
        tcs
.endif
        tcd
.endmacro

;;
; Function cleanup code to remove any input parameters from the stack. If there
; are any output values left on the stack the name of the first one must be
; passed here in order co calculate how many bytes to remove from the stack. If
; nothing is passed it is assumed all declared params are to be removed.
;
; This macro does NOT restore the direct page; the caller needs to do a PHD for
; that. The reason for this is so that output parameters on the direct page are
; still accessible after using this macro.
;
.macro _RemoveParams pend
.ifblank pend
          @pend := _pend
.else
          @pend := pend
.endif
.ifdef s_bank
          @psize := @pend - s_bank - 1
.else
          @psize := @pend - s_ret - 2
.endif
.if @psize > 0
.ifdef s_bank
        shortm
        lda     s_bank,s
        sta     s_bank + @psize,s
        longm
.endif
        lda     s_ret,s
        sta     s_ret + @psize,s
        lda     s_dreg,s
        sta     s_dreg + @psize,s
.endif
        tsc
        clc
        adcw    #@psize + s_dreg - 1
        tcs
.endmacro

;;
; The _SetExitState macro implements standard function return semantics, in
; which the carry indicates error state and the C register contains the
; return code.
;
; This routine assumes the exit code is in the Y register (to avoid being
; destroyed by _RemoveParams), and carry will be set or clear based on
; whether or not Y == 0.
;
.macro _SetExitState
        clc
        tya
        beq     :+
        sec
:
.endmacro
