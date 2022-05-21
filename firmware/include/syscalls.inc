;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Definitions of available BIOS/OS syscall numbers ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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
SYS_SPI_SLOW_SPEED  = $33
SYS_SPI_FAST_SPEED  = $34

SYS_REGISTER_DEVICE     = $40
SYS_UNREGISTER_DEVICE   = $41
SYS_GET_NUM_DEVICES     = $42
SYS_GET_DEVICE          = $43
SYS_FIND_DEVICE         = $44
SYS_DEV_CALL            = $45
SYS_DEV_OPEN            = $46
SYS_DEV_CLOSE           = $47

JROS_MOUNT_DEVICE       = $41
JROS_EJECT_DEVICE       = $42
JROS_FORMAT_DEVICE      = $43
JROS_DEVICE_STATUS      = $44
JROS_READ_BLOCK         = $45
JROS_WRITE_BLOCK        = $46
