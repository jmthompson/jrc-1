; *******************************
; *  JRC-1 65816 SBC Firmware   *
; * (C) 2023 Joshua M. Thompson *
; *******************************

         .exportzp   blockp, currfd, currfile

        .segment "ZEROPAGE"

; Pointer for block buffers
blockp:     .res    4

; Current file descriptor in use by active syscall
currfd:     .res    2

; Current file pointer in use by active syscall
currfile:   .res    4
