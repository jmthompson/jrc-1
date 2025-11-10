; *******************************
; * (C) 2025 Joshua M. Thompson *
; *******************************
;
; This file defines direct page locations for the jrcOS scheduler

        .exportzp   current_task, next_task, task_head

        .segment "ZEROPAGE"

current_task: .res    2
next_task:    .res    2
task_head   : .res    2
