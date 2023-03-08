; * (C) 2021 Joshua M. Thompson *
; *******************************
;
; This file defines global direct page locations for jrcOS

        .exportzp   current_process

        .segment "ZEROPAGE"

; Pointer to current process
current_process:  .res    4
