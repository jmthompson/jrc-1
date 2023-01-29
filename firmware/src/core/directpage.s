; * (C) 2021 Joshua M. Thompson *
; *******************************
;
; This file defines global direct page locations for jrcOS

        .exportzp   ptr, tmp

        .segment "ZEROPAGE"

; Generic temp locations, used lots of places. VERY temporary!
ptr:            .res    4
tmp:            .res    2
