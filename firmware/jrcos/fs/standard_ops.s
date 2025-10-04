; *******************************
; *  JRC-1 65816 SBC Firmware   *
; * (C) 2023 Joshua M. Thompson *
; *******************************
;
; read_file

        .include    "common.inc"
        .include    "errors.inc"
        .include    "kernel/device.inc"
        .include    "kernel/fs.inc"
        .include    "kernel/function_macros.inc"

        .export     bdev_operations, dir_operations, file_operations
        .import     trampoline

        .segment "OSROM"

bdev_operations:
dir_operations:
file_operations:
