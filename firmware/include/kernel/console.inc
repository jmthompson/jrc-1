;;
; Kernel I/O macros
;

        .import putc_seriala
        .import kprint

.macro _kprint str
        pea     .hiword(str)
        pea     .loword(str)
        jsl     kprint
.endmacro

.macro _kputc
        jsl     putc_seriala
.endmacro
