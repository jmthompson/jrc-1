; *  JRC-1 65816 SBC Firmware   *
; * (C) 2023 Joshua M. Thompson *
; *******************************
;
; Data private to the scheduler

        .include  "kernel/device.inc"
        .include  "kernel/scheduler.inc"

        .segment    "BSS"

        .export     task_list

; Task table
task_list:        .res    MAX_TASKS * .sizeof(Task)
