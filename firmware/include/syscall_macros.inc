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
.endmacro

;;
; Exit a syscall handler.
;
.macro  SC_EXIT
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
