; *  JRC-1 65816 SBC Firmware   *
; * (C) 2023 Joshua M. Thompson *
; *******************************
;
; Data private to the scheduler

        .include  "kernel/device.inc"
        .include  "kernel/scheduler.inc"

        .segment    "BSS"

        .export     tasks, idle_task

idle_task: .res   .sizeof(Task)

        .align      256
tasks:  .res    .sizeof(Task) * MAX_TASKS

