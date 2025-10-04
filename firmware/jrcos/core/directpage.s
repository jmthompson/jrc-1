; * (C) 2021 Joshua M. Thompson *
; *******************************
;
; This file defines global direct page locations for jrcOS

        .exportzp   ptr, scparams, tmp

        .segment "ZEROPAGE"

; Generic temp locations, used lots of places. VERY temporary!
ptr:            .res    4
tmp:            .res    2

; Pointer to start of syscall parameters on the user stack
scparams:       .res    4
