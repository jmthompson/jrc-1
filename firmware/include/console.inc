;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Console support definitions and macros ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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
        pea     .hiword(string)
        pea     .loword(string)
        _Call    SYS_CONSOLE_WRITELN
.endmacro
