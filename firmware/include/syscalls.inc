;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Syscall handler macros. These assist in setting up the handler environment   ;
; such as pulling call parameters.                                             ;
;                                                                              ;
; It is assumed that syscall hadnlers run with 16-bit registers by default.    ;
; Handlers can of course switch modes as needed.                               ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;
; Enter a syscall handler. This will assure we are in 16-bit mode, and
; initialize the Y register to zero for parameter access.
;
.macro  SC_ENTER
        rep     #$30
        ldyw    #0
.endmacro

;;
; Exit a syscall handler.
;
.macro  SC_EXIT
        sep     #$30        ; FIXME: remove when everything is 16-biy clean
        rtl
.endmacro
;;
; Exit a syscall with no error. Must be called in 16-bit mode.
;
.macro  SC_SUCCESS code
        ldaw    #0
        clc
        SC_EXIT
.endmacro

;;
; Exit a syscall with an error code. Must be called in 16-bit mode.
;
.macro  SC_ERROR    code
.ifnblank code
        ldaw    #code
.endif
        sec
        SC_EXIT
.endmacro

;;
; Extract a 16-bit caller parameter into <loc>. If <cont> is defined,
; the Y register is incremented to point to the next parameter.
;
.macro  PARAM16 loc, cont
        lda     [params],y
        sta     loc
.ifnblank cont
        iny
        iny
.endif
.endmacro

;;
; Extract a 16-bit caller parameter into <loc>. If <cont> is defined,
; the Y register is incremented to point to the next parameter.
;
.macro  PARAM32 loc, cont
        lda     [params],y
        sta     loc
        iny
        iny
        lda     [params],y
        sta     loc+2
.ifnblank cont
        iny
        iny
.endif
.endmacro
