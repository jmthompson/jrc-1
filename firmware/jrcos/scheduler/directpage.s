; *******************************
; * (C) 2025 Joshua M. Thompson *
; *******************************
;
; This file defines direct page locations for the jrcOS scheduler

        .exportzp   current_task, next_task

        .segment "ZEROPAGE"

current_task: .res    4
next_task:    .res    4
