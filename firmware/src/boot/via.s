; *******************************
; *  JRC-1 65816 SBC Firmware   *
; * (C) 2021 Joshua M. Thompson *
; *******************************

                .global         via_init,via_irq

via_portb       .equlab         0xF000
via_porta       .equlab         0xF001
via_ddrb        .equlab         0xF002
via_ddra        .equlab         0xF003
via_t1cl        .equlab         0xF004
via_t1ch        .equlab         0xF005
via_t1ll        .equlab         0xF006
via_t1lh        .equlab         0xF007
via_t2cl        .equlab         0xF008
via_t2ch        .equlab         0xF009
via_sr          .equlab         0xF00A
via_acr         .equlab         0xF00B
via_pcr         .equlab         0xF00C
via_ifr         .equlab         0xF00D
via_ier         .equlab         0xF00E
via_portaxA     .equlab         0xF00F

                .section        bootcode

via_init:       lda             #0x7F
                sta             via_ier         ; Disable all interrupts
                stz             via_porta
                stz             via_portb
                stz             via_ddra
                lda             #0xC0
                sta             via_acr         ; SPI clock 400 kHZ
                lda             #8              ; 8 MHz phi2
                sta             via_t1cl
                stz             via_t1ch
                bit             via_porta
                rts

via_irq:        rts
