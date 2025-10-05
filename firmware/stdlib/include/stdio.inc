;;
; stdio functions
;

STDIN  := 0
STDOUT := 1
STDERR := 2

      .global getchar, putchar, puts

.macro _open
        _syscall  SYS_OPEN
.endmacro

.macro _seek
        _syscall  SYS_SEEK
.endmacro

.macro _read
        _syscall  SYS_READ
.endmacro

.macro _write
        _syscall  SYS_WRITE
.endmacro

.macro _getchar
        jsl     getchar
.endmacro

.macro _putchar
        jsl     putchar
.endmacro

.macro _puts  str
.ifnblank str
        _PushLong str
.endif
        jsl     puts
.endmacro
