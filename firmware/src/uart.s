; *******************************
; *  JRC-1 65816 SBC Firmware   *
; * (C) 2021 Joshua M. Thompson *
; *******************************

        .include "common.s"
        .include "sys/devices.s"
        .include "hw/nxp_uart.s"

        .export uart_init
        .export uart_irq
        .export getc_seriala
        .export getc_serialb
        .export putc_seriala
        .export putc_serialb

        .import noop

        .importzp   jiffies

buffer_size = 256

nxp_base := $F020

        .segment "ZEROPAGE"
;
; Serial buffer r/w indices
;
rxa_rdi: .res   1
rxa_wri: .res   1
txa_rdi: .res   1
txa_wri: .res   1

rxb_rdi: .res   1
rxb_wri: .res   1
txb_rdi: .res   1
txb_wri: .res   1

; UART tx status
txa_on: .res    1
txb_on: .res    1

        .segment "BUFFERS"

;
; Serial buffers
;
txa_ibuf: .res    buffer_size
rxa_ibuf: .res    buffer_size
txb_ibuf: .res    buffer_size
rxb_ibuf: .res    buffer_size

        .segment "BOOTROM"

;
; Initialize the UART as well as our Rx buffers and the system timekeeping
;
uart_init:
        stz     rxa_rdi
        stz     rxa_wri
        stz     rxb_rdi
        stz     rxb_wri

        stz     txa_rdi
        stz     txb_rdi
        stz     txa_wri
        stz     txb_wri

        rep     #$30
        stz     jiffies
        stz     jiffies+2
        sep     #$30

        lda     #$80
        sta     txa_on
        sta     txb_on

        ldy     #s_nxptab-2         ; DUART setup table index
@loop:  ldx     nxpsutab,y          ; get register
        lda     nxpsutab+1,y        ; get parameter
        sta     nxp_base,x          ; write to register
        nop
        nop
        nop
        nop
        nop
        dey
        dey
        bpl     @loop               ; next register

        bit     nxp_base+nx_sct     ; start the timer

        rts

;
; Main serial interrupt handler. This checks the ISR to see if
; the interrupt was from the UART, and if so, branches to the
; appropriate handler to service the interrupt.
;
uart_irq:
        lda     #$FF
        sta     $F003
        sta     $F001
        lda     nxp_base+nx_isr
        sta     $F001
        beq     @done               ; Exit early if nothing is interrupting
        bit     #nxpctirq
        beq     :+
        jsr     timer_irq
:       bit     #nxpatirq
        beq     :+
        jsr     txa_irq
:       bit     #nxparirq
        beq     :+
        jsr     rxa_irq
:       bit     #nxpbtirq
        beq     :+
        jsr     txb_irq
:       bit     #nxpbrirq
        beq     @done
        jsr     rxb_irq
@done:  lda     #$08
        sta     $F001
        rts

;
; Timer interrupt handler
;
timer_irq:
        bit     nxp_base+nx_rct     ; reset the interrupt
        inc32   jiffies
        rts

;
; Channel A Tx interrupt handler
;
txa_irq:
        pha
        ldx     txa_rdi
@send:  cpx     txa_wri             ; Is the tx buffer empty?
        beq     @empty              ; yes, so disable transmitter and exit
        lda     nxp_base+nx_sra
        bit     #nxptxdr            ; is fifo space available?
        beq     @done               ; nope, so exit
        lda     txa_ibuf,x
        sta     nxp_base+nx_fifoa
        inx
        stx     txa_rdi
        bra     @send
@empty: lda     #nxpcrtxd
        sta     nxp_base+nx_cra     ; Disable transmitter
        stz     txa_on              ;  and mark it as such
@done:  pla
        rts

;
; Channel B Tx interrupt handler
;
txb_irq:
        pha
        ldx     txb_rdi
@send:  cpx     txb_wri             ; Is the tx buffer empty?
        beq     @empty              ; yes, so disable transmitter and exit
        lda     nxp_base+nx_srb
        bit     #nxptxdr            ; is fifo space available?
        beq     @done               ; nope, so exit
        lda     txb_ibuf,x
        sta     nxp_base+nx_fifob
        inx
        stx     txb_rdi
        bra     @send
@empty: lda     #nxpcrtxd
        sta     nxp_base+nx_crb     ; Disable transmitter
        stz     txb_on              ;  and mark it as such
@done:  pla
        rts

;
; Channel A Rx interrupt handler
;
rxa_irq:
        pha
        ldx     rxa_wri
@load:  lda     nxp_base+nx_sra
        bit     #nxprxdr            ; Is there more to read?
        beq     @exit
        lda     nxp_base+nx_fifoa   ; load character to clear the interrupt
        xba
        txa
        inc
        cmp     rxa_rdi
        beq     @load               ; buffer full; drop character
        xba
        sta     rxa_ibuf,x
        xba
        tax
        bra     @load
@exit:  stx     rxa_wri
        pla
        rts

;
; Channel B receive interrupt handler
;
rxb_irq:
        pha
        ldx     rxb_wri
@load:  lda     nxp_base+nx_srb
        bit     #nxprxdr            ; Is there more to read?
        beq     @exit
        lda     nxp_base+nx_fifob   ; load character to clear the interrupt
        xba
        txa
        inc
        cmp     rxb_rdi
        beq     @load               ; buffer full; drop character
        xba
        sta     rxb_ibuf,x
        xba
        tax
        bra     @load
@exit:  stx     rxb_wri
        pla
        rts

;PHILIPS/NXP DUAL UART INITIALIZATION DATA
;
;   ————————————————————————————————————————————————————————————————————————
;   The following data table is used to initialize the 26C92 & 28L92 DUARTs
;   following reset.  Each entry in this table consists of a chip register
;   offset paired with the parameter that is to be loaded into the register.
;   Table entries are read in reverse order during device setup.
;
;   Parameters are defined in include_hardware/uart/nxp_constants.asm & are
;   to be modified there, not here.  Only edit this table if you need to add
;   or remove an entry.  Be sure to back up nxp_constants.asm before editing
;   it!
;
;   NOTE: The data in nxp_constants.asm cannot be used to configure the 2692
;         DUART, as it does not have TxD FIFOs.
;   ————————————————————————————————————————————————————————————————————————

nxpsutab:
        .byte nx_imr, nxpiqmsk  ;IMR (enables IRQs)
        .byte nx_ctu, nxpctdhi  ;CTU
        .byte nx_ctl, nxpctdlo  ;CTL
        .byte nx_crb, nxpcrrte  ;CRB
        .byte nx_csrb,nxpcsdef  ;CSRB
        .byte nx_mrb, nxpm2def  ;MR2B
        .byte nx_mrb, nxpm1def  ;MR1B
        .byte nx_crb, nxpcrmr1  ;CRB
        .byte nx_mrb, nxpm0def  ;MR0B
        .byte nx_crb, nxpcrmr0  ;CRB
        .byte nx_cra, nxpcrrsa  ;CRA
        .byte nx_cra, nxpcrrte  ;CRA
        .byte nx_csra,nxpcsdef  ;CSRA
        .byte nx_mra, nxpm2def  ;MR2A
        .byte nx_mra, nxpm1def  ;MR1A
        .byte nx_cra, nxpcrmr1  ;CRA
        .byte nx_mra, nxpm0def  ;MR0A
        .byte nx_cra, nxpcrmr0  ;CRA
        .byte nx_acr, nxparbrt  ;ACR
        .byte nx_opcr,nxpopdef  ;OPCR
        .byte nx_crb, nxpcrtmd  ;CRB
        .byte nx_crb, nxpcresr  ;CRB
        .byte nx_crb, nxpcrbir  ;CRB
        .byte nx_crb, nxpcrtxr  ;CRB
        .byte nx_crb, nxpcrrxr  ;CRB
        .byte nx_crb, nxpcrrsd  ;CRB
        .byte nx_cra, nxpcrtmd  ;CRA
        .byte nx_cra, nxpcresr  ;CRA
        .byte nx_cra, nxpcrbir  ;CRA
        .byte nx_cra, nxpcrtxr  ;CRA
        .byte nx_cra, nxpcrrxr  ;CRA
        .byte nx_cra, nxpcrrsd  ;CRA
        .byte nx_cra, nxpcrpdd  ;CRA
        .byte nx_imr, 0         ;IMR (disables all IRQs)
s_nxptab = *-nxpsutab

        .segment "OSROM"

;
; Get next character from serial channel A. On exit, C=0 if
; no character was available; otherwise, C=1 and the character
; code is in A.
;
getc_seriala:
        phx
        ldx     rxa_rdi
        cpx     rxa_wri
        beq     @empty
        lda     rxa_ibuf,X
        inx
        stx     rxa_rdi
        sec
@exit:  plx
        rtl
@empty: clc
        bra     @exit

;
; Get next character from serial channel B. On exit, C=0 if
; no character was available; otherwise, C=1 and the character
; code is in A.
;
getc_serialb:
        phx
        ldx     rxb_rdi
        cpx     rxb_wri
        beq     @empty
        lda     rxb_ibuf,X
        inx
        stx     rxb_rdi
        sec
@exit:  plx
        rtl
@empty: clc
        bra     @exit

;
; Transmit character in A on serial channel A. This is a blocking
; operation, meaning this function will wait for the Tx FIFO to
; have an empty slot before returning.
;
putc_seriala:
        phx
        ldx     txa_wri
        inx
@wait:  cpx     txa_rdi             ; is the buffer full?
        bne     @store              ; if no then store
        ;wai                         ; yes, so wait for an interrupt to hopefully clear some space
        bra     @wait               ; and then check again
@store: dex
        sta     txa_ibuf,x          ; Store the byte in the output buffer
        inx
        stx     txa_wri             ; ... and update write index
        lda     #$80
        tsb     txa_on              ; is the transmitter enabled?
        bne     :+                  ; if yes, we're done
        lda     #nxpcrtxe
        sta     nxp_base+nx_cra     ; Enable transmitter
:       plx
        rtl
;
; Transmit character in A on serial channel B. This is a blocking
; operation, meaning this function will wait for the Tx FIFO to
; have an empty slot before returning.
;
putc_serialb:
        phx
        ldx     txb_wri
        inx
@wait:  cpx     txb_rdi             ; is the buffer full?
        bne     @store              ; if no then store
        ;wai                         ; yes, so wait for an interrupt to hopefully clear some space
        bra     @wait               ; and then check again
@store: dex
        sta     txb_ibuf,x          ; Store the byte in the output buffer
        inx
        stx     txb_wri             ; ... and update write index
        lda     #$80
        tsb     txb_on              ; is the transmitter enabled?
        bne     :+                  ; if yes, we're done
        lda     #nxpcrtxe
        sta     nxp_base+nx_crb     ; Enable transmitter
:       plx
        rtl
