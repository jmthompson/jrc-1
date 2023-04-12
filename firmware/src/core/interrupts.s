; *******************************
; *  JRC-1 65816 SBC Firmware   *
; * (C) 2021 Joshua M. Thompson *
; *******************************

        .include "common.inc"
        .include "errors.inc"
        .include "kernel/linker.inc"

        .import monitor_start
        .import monitor_brk
        .import monitor_nmi

        .import serial_irq
        .import spi_irq
        .import via_irq

        .import syscall_table
        .import trampoline

        .importzp scparams

        .export syscop
        .export sysirq
        .export sysnmi
        .export sysbrk

        .segment "ZEROPAGE"

copsig:   .res  4
cf_size:  .res  2

; Processor status register bits
PREG_I      =   %00000100
PREG_C      =   %00000001

        .segment "BOOTROM"

.proc syscop

        ; Stack relative variables
        .struct
          .org 1
          y_reg     .word
          x_reg     .word
          a_reg     .word
          d_reg     .word
          b_reg     .byte
          p_reg     .byte   ; start of COP frame
          ret_addr  .addr
        .endstruct

        @sc_size  := p_reg - y_reg
        @cop_size := 4

        longmx
        phb
        phd
        pha
        phx
        phy
        ldaw    #OS_DP
        tcd
        shortm
        lda     #OS_DB
        pha
        plb
        lda     p_reg,s
        and     #~PREG_C&$FF    ; clear carry
        sta     p_reg,s
        bit     #PREG_I         ; were interrupts disabled?
        bne     :+
        cli                     ; no, so re-enable them
:       lda     ret_addr + 2,s
        sta     copsig + 2
        longm
        lda     ret_addr,s
        dec
        sta     copsig
        tsc
        clc
        adcw    #@sc_size + @cop_size + 1
        sta     scparams
        stz     scparams + 2
        lda     [copsig]
        andw    #255
        asl
        asl
        asl
        tax
        lda     syscall_table + 4,x     ; Parameter frame size
        sta     cf_size
        lda     syscall_table + 2,x     ; Top word of handler address
        sta     trampoline + 3
        lda     syscall_table,x         ; Low word of handler address
        sta     trampoline + 1
        ora     trampoline + 3
        bne     @valid
        ldaw    #ENOSYS
        sec
        bra     @cleanup
@valid: lda     a_reg,s                 ; Grab A; it might be a parameter
        jsl     trampoline
@cleanup:
        longmx
        sta     a_reg,s                 ; return value of A to caller
        bcc     @noerr
        shortm
        lda     p_reg,s
        ora     #PREG_C                 ; set carry on return to caller
        sta     p_reg,s
        longm
@noerr: lda     cf_size
        beq     @nocopy

        tsc
        clc
        adcw    #@sc_size + @cop_size
        tax                             ; copy from end of cop stack frame
        adc     cf_size
        tay                             ; copy to end of params frame
        ldaw    #@sc_size + @cop_size - 1   ; copy local + cop frame
        mvp     0,0                     ; remove parameters
        tya                             ; Y will end up one byte lower than the last byte written
        tcs                             ;  which is exactly where our stack frame starts

@nocopy:
        ply
        plx
        pla
        pld
        plb
        rti
.endproc

sysirq: 
        rep     #$30
        phb
        phd
        pha
        phx
        phy
        ldaw    #OS_DP
        tcd
        sep     #$30
        lda     #IRQ_DB
        pha
        plb                 ; Set interrupt data bank

        jsr     via_irq
        jsr     serial_irq

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
        ldaw    #OS_DP
        tcd
        shortmx
        lda     #OS_DB
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
        ldaw    #OS_DP
        tcd
        shortmx
        lda     #OS_DB
        pha
        plb
        cli
        jml     monitor_brk

