; *  JRC-1 65816 SBC Firmware   *
; * (C) 2023 Joshua M. Thompson *
; *******************************
;
; Data private to the scheduler

        .include  "kernel/device.inc"
        .include  "kernel/scheduler.inc"

        .segment    "BSS"

        .export     processes

; Process table
processes:        .res    MAX_PROCESSES * .sizeof(Process)
