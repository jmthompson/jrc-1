;;
; Device Type identifiers
;;

.macro  device_function funcaddr
        .faraddr    funcaddr
        .byte       0
.endmacro

; if this bit is set then the device is a block device
BLOCK_DEVICE = $80

; Character device types

DEVICE_TYPE_CONSOLE = 0
DEVICE_TYPE_SERIAL_PORT = 1

; Block devices

DEVICE_TYPE_SDCARD = BLOCK_DEVICE|0     ; SD card
DEVICE_TYPE_FLASH  = BLOCK_DEVICE|1     ; USB flash drive
