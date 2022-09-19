; *******************************
; *  JRC-1 65816 SBC Firmware   *
; * (C) 2021 Joshua M. Thompson *
; *******************************

        .include    "volume.inc"

        .exportzp   blockp
        .exportzp   devicep
        .export     block_buffer
        .export     cmd_buffer
        .export     devicenr
        .export     num_volumes
        .export     volumes

        .segment "ZEROPAGE"

; Pointer for block buffers
blockp:         .res    4
; Poiner to current device
devicep:        .res    4

        .segment "BSS"

; General-purpose block r/w buffer
block_buffer:   .res    512
; General-purpose buffer for device commands
cmd_buffer:     .res    32
; Number of currently selected device
devicenr:       .res    1
; Number of active volumes
num_volumes:    .res    1
; An array of volume strucures
volumes:        .res    MAX_VOLUMES * VOLUME_STRUCT_SIZE
