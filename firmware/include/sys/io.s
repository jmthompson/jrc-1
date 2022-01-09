; Output a single character
.macro  putc    char
        lda     char
        call    SYS_CONSOLE_WRITE
.endmacro

; Output a CR
.macro  puteol
        putc    #CR
.endmacro

; Output a null-terminated string
.macro  puts    string
        pea     .hiword(string)
        pea     .loword(string)
        call    SYS_CONSOLE_WRITELN
.endmacro

; Output a 2-digit hex value
.macro  puthex  value
        lda     value
        jsl     print_hex
.endmacro

