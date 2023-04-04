;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Syscall handler macros. These assist in reading and writing parameters to    ;
; and from the user stack.                                                     ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

        .importzp scparams

;;
; Retrieve a 2-byte parameter from the user stack.
; Returns the parameter in A.
;
.macro  _GetParam16 offset
        ldyw    #offset
        lda     [scparams],y
.endmacro

;;
; Retrieve a 4-byte parameter from the user stack
; Returns the parameter in A/X (low/high)
;
.macro  _GetParam32 offset
        ldyw    #offset + 2
        lda     [scparams],y
        tax
        dey
        dey
        lda     [scparams],y
.endmacro

;;
; Store a 2-byte parameter onto the user stack.
; The parameter should be in A.
;
.macro  _PutParam16 offset
        ldyw    #offset
        sta     [scparams],y
.endmacro

;;
; Retrieve a 4-byte parameter from the user stack
; The parameter should be in A/X (low/high)
;
.macro  _PutParam32 offset
        ldyw    #offset
        sta     [scparams],y
        iny
        iny
        txa
        sta     [scparams],y
.endmacro
