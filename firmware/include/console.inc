;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Console support definitions and macros ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;
; Read a character
;
.macro  _GetChar
        _Call    SYS_CONSOLE_READ
.endmacro

;;
; Output a character
;
.macro  _PrintChar
        _Call    SYS_CONSOLE_WRITE
.endmacro

;;
; Output a null-terminated string
;
.macro  _PrintString   string
.ifnblank string
        pea     .hiword(string)
        pea     .loword(string)
.endif
        _Call    SYS_CONSOLE_WRITELN
.endmacro
