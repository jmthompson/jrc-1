; *******************************
; *  JRC-1 65816 SBC Firmware   *
; * (C) 2021 Joshua M. Thompson *
; *******************************

        .include "common.inc"
        .include "errors.inc"
        .include "kernel/interrupts.inc"
        .include "kernel/linker.inc"
        .include "kernel/scheduler.inc"

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
        lda     IntStackFrame::p_reg,s
        and     #~PREG_C&$FF    ; clear carry
        sta     IntStackFrame::p_reg,s
        bit     #PREG_I         ; were interrupts disabled?
        bne     :+
        cli                     ; no, so re-enable them
:       lda     IntStackFrame::k_reg,s
        sta     copsig + 2
        longm
        lda     IntStackFrame::pc_reg,s
        dec
        sta     copsig
        tsc
        clc
        adcw    #IntStackFrame::sc_params
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
@valid: lda     IntStackFrame::a_reg,s ; Grab A; it might be a parameter
        jsl     trampoline
@cleanup:
        longmx
        sta     IntStackFrame::a_reg,s ; return value of A to caller
        bcc     @noerr
        shortm
        lda     IntStackFrame::p_reg,s
        ora     #PREG_C                 ; set carry on return to caller
        sta     IntStackFrame::p_reg,s
        longm
@noerr: lda     cf_size
        beq     @nocopy

        tsc
        clc
        adcw    #INT_STACK_FRAME_SIZE
        tax                             ; copy from end of cop stack frame
        adc     cf_size
        tay                             ; copy to end of params frame
        ldaw    #INT_STACK_FRAME_SIZE - 1 ; copy local + cop frame
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

