;PHILIPS/NXP MULTIPLE CHANNEL UART CONFIGURATION & CONTROL CONSTANTS
;
;   —————————————————————————————————————————————————————————————————————
;   This file contains definitions that are used in DUART & QUART setup
;   tables.  Any changes to device configuration should be made herein, &
;   no changes should be made to the setup tables themselves unless a new
;   function is being added or an existing function is being removed.
;
;   The constants in this file are applicable to the 26C92, 28L92 & 28C94
;   only.  Consult with the appropriate data sheets before changing any-
;   thing & be sure to make a backup copy of this file before you do make
;   changes.  DO NOT use this setup data with the 2692!
;
;   The values used to select baud & counter/timer (C/T) rates are based
;   upon use of the recommended 3.6864 MHz X1 clock.
;   —————————————————————————————————————————————————————————————————————
;
;
; register names
nx_acr  = %0100
nx_cra  = %0010
nx_crb  = %1010
nx_csra = %0001
nx_csrb = %1001
nx_ctl  = %0111
nx_ctu  = %0110
nx_fifoa = %0011
nx_fifob = %1011
nx_imr  = %0101
nx_isr  = %0101
nx_mra  = %0000
nx_mrb  = %1000
nx_opcr = %1101
nx_sra  = %0001
nx_srb  = %1001
nx_sct  = %1110
nx_rct  = %1111
nx_sopr = %1110
nx_ropr = %1111

nxx1freq = 3686400              ;X1 clock frequency in Hz
nxctscal = nxx1freq/2           ;C/T scaled clock
;
;
;   ACR — auxiliary control register
;
nxparbrt = %01100000            ;C/T in timer mode, source = X1/CLK
;
;   a) Use baud rate table #1 —— see data sheet.
;   b) C/T acts as a timer.
;   c) C/T clock source is scaled to X1 ÷ 1.
;
;
;   CR — command register...
;
nxpcrrxe = %00000001            ;enable receiver
nxpcrrxd = %00000010            ;disable receiver
nxpcrtxe = %00000100            ;enable transmitter
nxpcrtxd = %00001000            ;disable transmitter
nxpcrmr1 = %00010000            ;select MR1
nxpcrrxr = %00100000            ;reset receiver
nxpcrtxr = %00110000            ;reset transmitter
nxpcresr = %01000000            ;reset error status
nxpcrbir = %01010000            ;reset received break change IRQ
nxpcrbks = %01100000            ;start break
nxpcrbke = %01110000            ;stop break
nxpcrrsa = %10000000            ;assert request to send
nxpcrrsd = %10010000            ;deassert request to send
nxpcrtme = %10100000            ;select C/T timer mode
nxpcrmr0 = %10110000            ;select MR0
nxpcrtmd = %11000000            ;select C/T counter mode
nxpcrpde = %11100000            ;enable power-down mode — CRA only
nxpcrpdd = %11110000            ;disable power-down mode — CRA only
;
;   ————————————————————————————————————————————————————————————————————————
;   NXPCRPDD & NXPCRPDE apply to the 26C92 & are reserved in the 28L92 & the
;   28C94.  These parameters should not be used in any setup function.  They
;   are listed here only for reference purposes.  A hard reset automatically
;   brings the device out of power-down mode.
;   ————————————————————————————————————————————————————————————————————————
;
;
;   CSR — clock select register...
;
nxpcsdef = %01100110            ;RxD & TxD at 115.2 Kbps...
;
;   ————————————————————————————————————————————————————————————————
;   The above data rate is based upon the value of NXPARBRT (above).
;   ————————————————————————————————————————————————————————————————
;
;
;   CT — counter/timer...
;
nxpctdef = nxctscal/100         ;HZ underflows per second
nxpctdlo = <nxpctdef            ;underflows/sec LSB
nxpctdhi = >nxpctdef            ;underflows/sec MSB
;
;
;   MR0 — mode 0 register...
nxpm0def = %11001100            ;if using a 28L92 ...
;
;   11001100
;   ||||||||
;   |||||+++———> extended baud rate #2
;   ||||+——————> 16-deep FIFO
;   ||++———————> TxD interrupts only when FIFO is empty
;   |+—————————> RxD interrupts only when FIFO is full (see also MR1:6)
;   +——————————> enable RxD watchdog timer
;
;   MR1 — mode 1 register...
;
nxpm1def = %11010011            ;...
;
;   11010011
;   ||||||||
;   ||||||++———> 8 bit char size
;   |||||+—————> parity type (ignored)
;   |||++——————> no parity generated or checked
;   ||+————————> character error mode
;   |+—————————> RxD interrupts only when FIFO is full (see also MR0:6)
;   +——————————> RxD controls RTS
;
;   MR2 — mode 2 register...
;
nxpm2def = %00110111            ;normal mode, auto RTS/CTS
;
;
;   OPCR — output port configuration register...
;
nxpopdef = %00000000            ;no operation
;
;
;   combined setup commands...
;
nxpcrrtd = nxpcrtxd|nxpcrrxd    ;disable transmitter & receiver
nxpcrrte = nxpcrtxe|nxpcrrxe    ;enable transmitter & receiver
;
;
;   channel status analysis masks...
;
nxprxdr  = %00000001    ;RxD: FIFO not empty
nxprxdf  = %00000010    ;RxD: FIFO full
nxptxdr  = %00000100    ;TxD: FIFO not full
nxptxdur = %00001000    ;TxD: FIFO empty
nxprxdor = %00010000    ;RxD: FIFO overrun
nxpparer = %00100000    ;RxD: parity error
nxpfrmer = %01000000    ;RxD: framing error
nxpbreak = %10000000    ;RxD: break

;
;   interrupt status analysis masks...
;
nxpatirq = %00000001    ;ch A: TxD
nxparirq = %00000010    ;ch A: RxD
nxpabirq = %00000100    ;ch A: break change
nxpctirq = %00001000    ;C/T: underflow
nxpbtirq = %00010000    ;ch B: TxD
nxpbrirq = %00100000    ;ch B: RxD
nxpbbirq = %01000000    ;ch B: break change
nxpipirq = %10000000    ;input port change
;
; IRQ mask
;
nxpiqmsk = nxpatirq|nxparirq|nxpbtirq|nxpbrirq|nxpctirq
;nxpiqmsk = nxparirq|nxpbrirq|nxpctirq
;
; OPx bits
;
nxpop0 = %00000001
nxpop1 = %00000010
nxpop2 = %00000100
nxpop3 = %00001000
nxpop4 = %00010000
nxpop5 = %00100000
nxpop6 = %01000000
nxpop7 = %10000000
