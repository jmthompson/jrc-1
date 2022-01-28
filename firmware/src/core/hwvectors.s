; *******************************
; *  JRC-1 65816 SBC Firmware   *
; * (C) 2021 Joshua M. Thompson *
; *******************************

        .import syscop
        .import sysbrk
        .import sysreset
        .import sysnmi
        .import sysirq

        .segment "HWVECTORS"

        .addr   syscop              ; $FFE4 (cop native)
        .addr   sysbrk              ; $FFE6 (brk native)
        .addr   sysreset            ; $FFE8 (abort native)
        .addr   sysnmi              ; $FFEA (nmi native)
        .addr   0                   ; $FFEC (not used)
        .addr   sysirq              ; $FFEE (irq native)
        .addr   0                   ; $FFF0 (not used)
        .addr   0                   ; $FFF2 (not used)
        .addr   sysreset            ; $FFF4 (cop emulation)
        .addr   0                   ; $FFF6 (not used)
        .addr   sysreset            ; $FFF8 (abort emulation)
        .addr   sysreset            ; $FFFA (nmi emulation)
        .addr   sysreset            ; $FFFC (reset)
        .addr   sysreset            ; $FFFE (irq emulation)
