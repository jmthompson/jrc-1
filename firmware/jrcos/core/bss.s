; *******************************
; *  JRC-1 65816 SBC Firmware   *
; * (C) 2022 Joshua M. Thompson *
; *******************************

        .export current_pid

        .segment "BSS"

; Current process ID
current_pid:    .res    2
