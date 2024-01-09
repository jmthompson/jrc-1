; *******************************
; *  JRC-1 65816 SBC Firmware   *
; * (C) 2021 Joshua M. Thompson *
; *******************************

                .extern         _DirectPageStart, _NearBaseAddress
                .extern         monitor_start, monitor_brk, monitor_nmi
                .extern         uart_irq,via_irq

                .global         sysbrk, sysirq, sysnmi

                .section        directPage
                .section        stack

                .section        bootcode

sysirq:         rep             #0x38
                phb
                phd
                pha
                phx
                phy
                lda             ##_DirectPageStart
                tcd
                lda             ##.word2 _NearBaseAddress
                xba
                pha
                plb
                plb

                jsr             .kbank via_irq
                jsr             .kbank uart_irq

                rep             #0x30
                ply
                plx
                pla
                pld
                plb
                rti

sysnmi:         rep             #0x38
                phb
                phd
                pha
                phx
                phy
                lda             ##_DirectPageStart
                tcd
                ;lda             ##.sectionEnd stack
                ;tcs
                lda             ##.word2 _NearBaseAddress
                xba
                pha
                plb
                plb

                cli
                jmp            long:monitor_nmi

sysbrk:         rep             #0x38
                phb
                phd
                pha
                phx
                phy
                lda             ##_DirectPageStart
                tcd
                ;lda             ##.sectionEnd stack
                ;tcs
                lda             ##.word2 _NearBaseAddress
                xba
                pha
                plb
                plb

                cli
                jmp            long:monitor_brk
