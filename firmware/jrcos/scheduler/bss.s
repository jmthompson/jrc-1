; *  JRC-1 65816 SBC Firmware   *
; * (C) 2023 Joshua M. Thompson *
; *******************************
;
; Data private to the scheduler

        .include  "kernel/device.inc"
        .include  "kernel/scheduler.inc"

        .segment    "BSS"

        .export     task_list

        .align      256
task_list:  .res    .sizeof(Task) * MAX_TASKS
