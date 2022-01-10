
.macro  call    funcid
        cop     funcid
.endmacro

SYS_GET_UPTIME      = $00
SYS_GET_VERSION     = $01

SYS_CONSOLE_RESET   = $10   ; reset console
SYS_CONSOLE_READ    = $11   ; read char
SYS_CONSOLE_WRITE   = $12   ; write char
SYS_CONSOLE_WRITELN = $13   ; write null-terminated string
SYS_CONSOLE_CLS     = $14   ; clear screen
SYS_CONSOLE_CLL     = $15   ; clear line

SYS_READ_SERIALA    = $20
SYS_WRITE_SERIALA   = $21
SYS_READ_SERIALB    = $22
SYS_WRITE_SERIALB   = $23

SYS_SPI_SELECT      = $30
SYS_SPI_DESELECT    = $31
SYS_SPI_TRANSFER    = $32

