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

;;
; Retrieve a 2-byte parameter from the user stack
; and push it onto the kernel stack.
;
.macro  _PushParam16 offset
        ldyw    #offset
        lda     [scparams],y
        pha
.endmacro

;;
; Retrieve a 4-byte parameter from the user stack
; and push it onto the kernel stack.
;
.macro  _PushParam32 offset
        ldyw    #offset + 2
        lda     [scparams],y
        pha
        dey
        dey
        lda     [scparams],y
        pha
.endmacro

;;
; Pull a 2-byte parameter from the kernel stack and store
; it onto the user stack.
;
.macro  _PullParam16 offset
        ldyw    #offset
        pla
        sta     [scparams],y
.endmacro

;;
; Pull a 4-byte parameter from the kernel stack and store
; it onto the user stack.
;
.macro  _PullParam32 offset
        ldyw    #offset
        pla
        sta     [scparams],y
        iny
        iny
        pla
        sta     [scparams],y
.endmacro
