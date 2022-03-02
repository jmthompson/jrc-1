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

        .import syscall_table
        .import trampoline

        .importzp params

        .export syscop
        .export sysirq
        .export sysnmi
        .export sysbrk

; Processor status register bits
PREG_I      =   %00000100
PREG_C      =   %00000001

        .segment "BOOTROM"

syscop:
; syscall stack frame
@copsig  := 1                   ; Pointer to COP signature byte
@cf_size := @copsig + 4         ; Size of caller's stack frame (size of parameters)
@y_reg   := @cf_size + 2        ; Y
@x_reg   := @y_reg + 2          ; X
@a_reg   := @x_reg + 2          ; A
@d_reg   := @a_reg + 2          ; D
@db_reg  := @d_reg + 2          ; DB
@sc_size := @db_reg + 1 - @copsig

; COP instruction stack frame
@p_reg   := @db_reg + 1         ; P
@pc_reg  := @p_reg  + 1         ; PC
@pb_reg  := @pc_reg + 2         ; PB
@cop_size := @pb_reg + 1 - @p_reg
@params  := @pb_reg + 1

        longmx
        phb
        phd
        pha
        phx
        phy
        pha                     ; Make space for our local variables
        pha                     ; """
        pha                     ; """
        tsc
        tcd                     ; DP now points to our local stack frame
        shortm
        lda     #OS_DB
        pha
        plb                     ; Set kernel data bank
        lda     @p_reg
        and     #~PREG_C&$FF    ; clear carry
        sta     @p_reg
        bit     #PREG_I         ; were interrupts disabled?
        bne     :+
        cli                     ; no, so re-enable them
:       longm
        lda     @pc_reg
        dec
        sta     @copsig
        lda     @pb_reg
        sta     @copsig+2
        lda     [@copsig]
        andw    #255
        asl
        asl
        asl
        tax
        lda     syscall_table+4,x       ; Parameter frame size
        sta     @cf_size
        lda     syscall_table+2,x       ; Top word of handler address
        sta     trampoline+3
        lda     syscall_table,x         ; Low word of handler address
        sta     trampoline+1
        lda     params
        pha
        phd                             ; save our DP for after dispatch
        lda     @a_reg                  ; Grab A; it might be a parameter
        pha
        phd                             ; save for params calc
        ldaw    #OS_DP
        tcd
        pla                             ; get original DP
        clc
        adcw    #@params
        sta     params                  ; [params] now points to caller's params
        stz     params+2
        pla                             ; restore A from caller
        shortmx
        jsl     trampoline
        longmx
        pld
        sta     @a_reg                  ; return value of A to caller
        pla
        sta     params
        bcc     @noerr
        shortm
        lda     @p_reg
        ora     #PREG_C                 ; set carry on return to caller
        sta     @p_reg
        longm

@noerr: lda     @cf_size
        beq     @nocopy

        tsc
        clc
        adcw    #@sc_size+@cop_size
        tax                             ; copy from end of cop stack frame
        adc     @cf_size
        tay                             ; copy to end of params frame
        ldaw    #@sc_size+@cop_size-1   ; copy local + cop frame
        mvp     0,0                     ; remove parameters
        tya                             ; Y will end up one byte lower than the last byte written
        tcs                             ;  which is exactly where our stack frame starts

@nocopy:
        ply                             ; remove space used for local vars
        ply                             ; """
        ply                             ; """
        ply
        plx
        pla
        pld
        plb
        rti

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

