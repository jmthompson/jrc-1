; *******************************
; *  JRC-1 65816 SBC Firmware   *
; * (C) 2021 Joshua M. Thompson *
; *******************************

                .extern         syscop
                .extern         sysbrk
                .extern         sysreset
                .extern         sysnmi
                .extern         sysirq

                .section        hwvectors, root

                ;.word          syscop          ; $FFE4 (cop native)
                .word           0               ; $FFE4 (cop native)
                .word           sysbrk          ; $FFE6 (brk native)
                .word           sysreset        ; $FFE8 (abort native)
                .word           sysnmi          ; $FFEA (nmi native)
                .word           0               ; $FFEC (not used)
                .word           sysirq          ; $FFEE (irq native)
                .word           0               ; $FFF0 (not used)
                .word           0               ; $FFF2 (not used)
                .word           sysreset        ; $FFF4 (cop emulation)
                .word           0               ; $FFF6 (not used)
                .word           sysreset        ; $FFF8 (abort emulation)
                .word           sysreset        ; $FFFA (nmi emulation)
                .word           sysreset        ; $FFFC (reset)
                .word           sysreset        ; $FFFE (irq emulation)
