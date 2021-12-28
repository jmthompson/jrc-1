; *******************************
; *  JRC-1 65816 SBC Firmware   *
; * (C) 2021 Joshua M. Thompson *
; *******************************

        .include "common.s"

        .import monitor_start
        .import monitor_brk
        .import monitor_nmi

        .import uart_irq
        .import spi_irq
        .import via_irq

        .export sysirq
        .export sysnmi
        .export sysbrk

        .segment "BOOTROM"

sysirq: 
        rep     #$30
        phb
        phd
        pha
        phx
        phy
        ldaw    #BIOS_DP
        tcd
        sep     #$30
        pha                 ; Low byte of BIOS_DP will always be $00
        plb                 ; Set interrupt data bank

        jsr     via_irq
        jsr     spi_irq
        jsr     uart_irq

        rep     #$30
        ply
        plx
        pla
        pld
        plb

        rti

sysnmi:
        longmx
        phb
        phd
        pha
        phx
        phy
        ldaw    #BIOS_DP
        tcd
        shortmx
        lda     #BIOS_DB
        pha
        plb
        cli
        jml     monitor_nmi

sysbrk:
        longmx
        phb
        phd
        pha
        phx
        phy
        ldaw    #BIOS_DP
        tcd
        shortmx
        lda     #BIOS_DB
        pha
        plb
        cli
        jml     monitor_brk

