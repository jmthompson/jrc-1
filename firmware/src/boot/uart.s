; *******************************
; *  JRC-1 65816 SBC Firmware   *
; * (C) 2021 Joshua M. Thompson *
; *******************************
;
;
#include "uart_constants.inc"

                .global         uart_init,uart_irq
                .global         getc_seriala,putc_seriala
                .global         getc_serialb,putc_serialb
                .global         jiffies

BUFFER_SIZE     .equ            256
INDEX_MASK      .equ            BUFFER_SIZE-1

nxp_base        .equlab         0xF020

                .section        zpage, noinit

rxa_rdi:        .space          1
rxa_wri:        .space          1
txa_rdi:        .space          1
txa_wri:        .space          1
rxb_rdi:        .space          1
rxb_wri:        .space          1
txb_rdi:        .space          1
txb_wri:        .space          1
txa_on:         .space          1
txb_on:         .space          1
jiffies:        .space          4

                .section        buffers,bss

; Serial buffers
txa_ibuf:       .space          BUFFER_SIZE
rxa_ibuf:       .space          BUFFER_SIZE
txb_ibuf:       .space          BUFFER_SIZE
rxb_ibuf:       .space          BUFFER_SIZE

                .section        bootcode

;;
; Initialize the UART, Tx/Rx buffers and system timekeeping
;
uart_init:      rep             #0x30
                stz             dp:.tiny jiffies
                stz             dp:.tiny(jiffies+2)
                sep             #0x30
                stz             dp:.tiny rxa_rdi
                stz             dp:.tiny rxa_wri
                stz             dp:.tiny rxb_rdi
                stz             dp:.tiny rxb_wri
                stz             dp:.tiny txa_rdi
                stz             dp:.tiny txb_rdi
                stz             dp:.tiny txa_wri
                stz             dp:.tiny txb_wri
                lda             #0x80
                sta             dp:.tiny txa_on
                sta             dp:.tiny txb_on

                ldy             #s_nxptab-2     ; DUART setup table index  
loop$:          ldx             nxpsutab,y      ; get register
                lda             nxpsutab+1,y    ; get parameter
                sta             nxp_base,x      ; write to register
                nop
                nop
                nop
                nop
                nop
                dey
                dey
                bpl             loop$           ; next register

                lda             nxp_base+nx_sct ; start the timer
                rts

;;
; UART interrupt handler. This checks the ISR to see if
; the interrupt was from the UART, and if so, branches to the
; appropriate handler to service the interrupt.
;
uart_irq:       sep             #0x30
                phb
                lda             #0
                pha
                plb
                lda             nxp_base+nx_isr
                bit             #nxpctirq
                beq             check_rxa$
                bit             nxp_base+nx_rct   ; reset the interrupt
                rep             #0x20
                inc             dp:.tiny jiffies
                beq             skip$
                inc             dp:.tiny(jiffies + 2)
skip$:          sep             #0x20
check_rxa$:     bit             #nxparirq
                beq             check_rxb$
                pha
                jsr             .kbank rxa_irq
                pla
check_rxb$:     bit             #nxpbrirq
                beq             check_txa$
                pha
                jsr             .kbank rxb_irq
                pla
check_txa$:     bit             #nxpatirq
                beq             check_txb$
                pha
                jsr             .kbank txa_irq
                pla
check_txb$:     bit             #nxpbtirq
                beq             done$
                jsr             .kbank txb_irq
done$:          plb
                rep             #0x30
                rts

;;
; Channel A Rx interrupt handler
;
rxa_irq:        ldx             dp:.tiny rxa_wri
load$:          lda             nxp_base+nx_sra
                bit             #nxprxdr        ; Is there more to read?
                beq             exit$
                lda             nxp_base+nx_fifoa  ; load character to clear the interrupt
                xba
                txa
                inc             a
                cmp             dp:.tiny rxa_rdi
                beq             load$           ; buffer full; drop character
                xba
                sta             long:rxa_ibuf,x
                xba
                tax
                bra             load$
exit$:          stx             dp:.tiny rxa_wri
                rts

;;
; Channel B receive interrupt handler
;
rxb_irq:        ldx             dp:.tiny rxb_wri
load$:          lda             nxp_base+nx_srb
                bit             #nxprxdr        ; Is there more to read?
                beq             exit$
                lda             nxp_base+nx_fifob  ; load character to clear the interrupt
                xba
                txa
                inc             a
                cmp             dp:.tiny rxb_rdi
                beq             load$           ; buffer full; drop character
                xba
                sta             long:rxb_ibuf,x
                xba
                tax
                bra             load$
exit$:          stx             dp:.tiny rxb_wri
                rts

;;
; Channel A Tx interrupt handler
;
txa_irq:        ldx             dp:.tiny txa_rdi
send$:          cpx             dp:.tiny txa_wri ; Is the tx buffer empty?
                beq             empty$          ; yes, so disable transmitter and exit
                lda             nxp_base+nx_sra
                bit             #nxptxdr        ; is fifo space available?
                beq             done$           ; nope, so exit
                lda             long:txa_ibuf,x
                sta             nxp_base+nx_fifoa
                inx
                stx             dp:.tiny txa_rdi
                bra             send$
empty$:         lda             #nxpcrtxd
                sta             nxp_base+nx_cra ; Disable transmitter
                stz             dp:.tiny txa_on ;  and mark it as such
done$:          rts

;;
; Channel B Tx interrupt handler
;
txb_irq:        ldx             dp:.tiny txb_rdi
send$:          cpx             dp:.tiny txb_wri ; Is the tx buffer empty?
                beq             empty$          ; yes, so disable transmitter and exit
                lda             nxp_base+nx_srb
                bit             #nxptxdr        ; is fifo space available?
                beq             done$           ; nope, so exit
                lda             long:txb_ibuf,x
                sta             nxp_base+nx_fifob
                inx
                stx             dp:.tiny txb_rdi
                bra             send$
empty$:         lda             #nxpcrtxd
                sta             nxp_base+nx_crb ; Disable transmitter
                stz             dp:.tiny txb_on ;  and mark it as such
done$:          rts

;;
; Get next character from serial channel A. Returns character
; in low byte of C or error code if an error occured.
;
getc_seriala:   sep             #0x30
                ldx             dp:.tiny rxa_rdi
                cpx             dp:.tiny rxa_wri
                beq             empty$
                lda             #0
                xba
                lda             abs:.near rxa_ibuf,x
                inx
                stx             dp:.tiny rxa_rdi
exit$:          rep             #0x30
                rtl
empty$:         rep             #0x30
                lda             ##0xFFFF
                rtl

;;
; Get next character from serial channel B. Returns character
; in low byte of C or error code if an error occured.
;
getc_serialb:   sep             #0x30
                ldx             dp:.tiny rxb_rdi
                cpx             dp:.tiny rxb_wri
                beq             empty$
                lda             abs:.near rxb_ibuf,x
                inx
                stx             dp:.tiny rxb_rdi
exit$:          rep             #0x30
                rtl
empty$:         rep             #0x30
                lda             ##0xFFFF
                rtl

;;
; Transmit character in A on serial channel A. This is a blocking
; operation, meaning this function will wait for the Tx FIFO to
; have an empty slot before returning.
;
putc_seriala:   sep             #0x30
                ldx             dp:.tiny txa_wri
                inx
wait$:          cpx             dp:.tiny txa_rdi ; is the buffer full?
                bne             store$          ; if no then store
                ;wai            ; yes, so wait for an interrupt to hopefully clear some space
                bra             wait$           ; and then check again
store$:         dex
                sta             abs:.near txa_ibuf,x      ; Store the byte in the output buffer
                inx
                stx             dp:.tiny txa_wri ; ... and update write index
                lda             #0x80
                tsb             dp:.tiny txa_on ; is the transmitter enabled?
                bne             done$           ; if yes, we're done
                lda             #nxpcrtxe
                sta             long:nxp_base+nx_cra ; Enable transmitter
done$:          rep             #0x30
                rtl

;;
; Transmit character in A on serial channel B. This is a blocking
; operation, meaning this function will wait for the Tx FIFO to
; have an empty slot before returning.
;
putc_serialb:   sep             #0x30
                ldx             dp:.tiny txb_wri
                inx
wait$:          cpx             dp:.tiny txb_rdi ; is the buffer full?
                bne             store$          ; if no then store
                ;wai            ; yes, so wait for an interrupt to hopefully clear some space
                bra             wait$           ; and then check again
store$:         dex
                sta             abs:.near txb_ibuf,x      ; Store the byte in the output buffer
                inx
                stx             dp:.tiny txb_wri ; ... and update write index
                lda             #0x80
                tsb             dp:.tiny txb_on ; is the transmitter enabled?
                bne             done$           ; if yes, we're done
                lda             #nxpcrtxe
                sta             long:nxp_base+nx_crb ; Enable transmitter
done$:          rep             #0x30
                rtl
;;
; UART initialization table
;
nxpsutab:       .byte           nx_imr, nxpiqmsk  ;IMR (enables IRQs)
                .byte           nx_ctu, .byte1 nxpctdef  ;CTU
                .byte           nx_ctl, .byte0 nxpctdef  ;CTL
                .byte           nx_crb, nxpcrrte  ;CRB
                .byte           nx_csrb,nxpcsdef  ;CSRB
                .byte           nx_mrb, nxpm2def  ;MR2B
                .byte           nx_mrb, nxpm1def  ;MR1B
                .byte           nx_crb, nxpcrmr1  ;CRB
                .byte           nx_mrb, nxpm0def  ;MR0B
                .byte           nx_crb, nxpcrmr0  ;CRB
                .byte           nx_cra, nxpcrrsa  ;CRA
                .byte           nx_cra, nxpcrrte  ;CRA
                .byte           nx_csra,nxpcsdef  ;CSRA
                .byte           nx_mra, nxpm2def  ;MR2A
                .byte           nx_mra, nxpm1def  ;MR1A
                .byte           nx_cra, nxpcrmr1  ;CRA
                .byte           nx_mra, nxpm0def  ;MR0A
                .byte           nx_cra, nxpcrmr0  ;CRA
                .byte           nx_acr, nxparbrt  ;ACR
                .byte           nx_opcr,nxpopdef  ;OPCR
                .byte           nx_crb, nxpcrtmd  ;CRB
                .byte           nx_crb, nxpcresr  ;CRB
                .byte           nx_crb, nxpcrbir  ;CRB
                .byte           nx_crb, nxpcrtxr  ;CRB
                .byte           nx_crb, nxpcrrxr  ;CRB
                .byte           nx_crb, nxpcrrsd  ;CRB
                .byte           nx_cra, nxpcrtmd  ;CRA
                .byte           nx_cra, nxpcresr  ;CRA
                .byte           nx_cra, nxpcrbir  ;CRA
                .byte           nx_cra, nxpcrtxr  ;CRA
                .byte           nx_cra, nxpcrrxr  ;CRA
                .byte           nx_cra, nxpcrrsd  ;CRA
                .byte           nx_cra, nxpcrpdd  ;CRA
                .byte           nx_imr, 0       ;IMR (disables all IRQs)
s_nxptab        .equ            .-nxpsutab
