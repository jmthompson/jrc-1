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
nx_acr          .equ            0b0100
nx_cra          .equ            0b0010
nx_crb          .equ            0b1010
nx_csra         .equ            0b0001
nx_csrb         .equ            0b1001
nx_ctl          .equ            0b0111
nx_ctu          .equ            0b0110
nx_fifoa        .equ            0b0011
nx_fifob        .equ            0b1011
nx_imr          .equ            0b0101
nx_isr          .equ            0b0101
nx_mra          .equ            0b0000
nx_mrb          .equ            0b1000
nx_opcr         .equ            0b1101
nx_sra          .equ            0b0001
nx_srb          .equ            0b1001
nx_sct          .equ            0b1110
nx_rct          .equ            0b1111
nx_sopr         .equ            0b1110
nx_ropr         .equ            0b1111

nxx1freq        .equ            3686400         ;X1 clock frequency in Hz
nxctscal        .equ            nxx1freq/2      ;C/T scaled clock
;
;
;   ACR — auxiliary control register
;
nxparbrt        .equ            0b01100000       ;C/T in timer mode, source  X1/CLK
;
;   a) Use baud rate table #1 —— see data sheet.
;   b) C/T acts as a timer.
;   c) C/T clock source is scaled to X1 ÷ 1.
;
;
;   CR — command register...
;
nxpcrrxe        .equ            0b00000001       ;enable receiver
nxpcrrxd        .equ            0b00000010       ;disable receiver
nxpcrtxe        .equ            0b00000100       ;enable transmitter
nxpcrtxd        .equ            0b00001000       ;disable transmitter
nxpcrmr1        .equ            0b00010000       ;select MR1
nxpcrrxr        .equ            0b00100000       ;reset receiver
nxpcrtxr        .equ            0b00110000       ;reset transmitter
nxpcresr        .equ            0b01000000       ;reset error status
nxpcrbir        .equ            0b01010000       ;reset received break change IRQ
nxpcrbks        .equ            0b01100000       ;start break
nxpcrbke        .equ            0b01110000       ;stop break
nxpcrrsa        .equ            0b10000000       ;assert request to send
nxpcrrsd        .equ            0b10010000       ;deassert request to send
nxpcrtme        .equ            0b10100000       ;select C/T timer mode
nxpcrmr0        .equ            0b10110000       ;select MR0
nxpcrtmd        .equ            0b11000000       ;select C/T counter mode
nxpcrpde        .equ            0b11100000       ;enable power-down mode — CRA only
nxpcrpdd        .equ            0b11110000       ;disable power-down mode — CRA only
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
nxpcsdef        .equ            0b01100110       ;RxD & TxD at 115.2 Kbps...
;
;   ————————————————————————————————————————————————————————————————
;   The above data rate is based upon the value of NXPARBRT (above).
;   ————————————————————————————————————————————————————————————————
;
;
;   CT — counter/timer...
;
nxpctdef        .equ            nxctscal/100    ;HZ underflows per second
;
;
;   MR0 — mode 0 register...
nxpm0def        .equ            0b11001100       ;if using a 28L92 ...
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
nxpm1def        .equ            0b11010011       ;...
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
nxpm2def        .equ            0b00110111       ;normal mode, auto RTS/CTS
;
;
;   OPCR — output port configuration register...
;
nxpopdef        .equ            0b00000000       ;no operation
;
;
;   combined setup commands...
;
nxpcrrtd        .equ            nxpcrtxd|nxpcrrxd  ;disable transmitter & receiver
nxpcrrte        .equ            nxpcrtxe|nxpcrrxe  ;enable transmitter & receiver
;
;
;   channel status analysis masks...
;
nxprxdr         .equ            0b00000001       ;RxD: FIFO not empty
nxprxdf         .equ            0b00000010       ;RxD: FIFO full
nxptxdr         .equ            0b00000100       ;TxD: FIFO not full
nxptxdur        .equ            0b00001000       ;TxD: FIFO empty
nxprxdor        .equ            0b00010000       ;RxD: FIFO overrun
nxpparer        .equ            0b00100000       ;RxD: parity error
nxpfrmer        .equ            0b01000000       ;RxD: framing error
nxpbreak        .equ            0b10000000       ;RxD: break

;
;   interrupt status analysis masks...
;
nxpatirq        .equ            0b00000001       ;ch A: TxD
nxparirq        .equ            0b00000010       ;ch A: RxD
nxpabirq        .equ            0b00000100       ;ch A: break change
nxpctirq        .equ            0b00001000       ;C/T: underflow
nxpbtirq        .equ            0b00010000       ;ch B: TxD
nxpbrirq        .equ            0b00100000       ;ch B: RxD
nxpbbirq        .equ            0b01000000       ;ch B: break change
nxpipirq        .equ            0b10000000       ;input port change
;
; IRQ mask
;
nxpiqmsk        .equ            nxpatirq|nxparirq|nxpbtirq|nxpbrirq|nxpctirq
;nxpiqmsk .equ nxparirq|nxpbrirq|nxpctirq
;
; OPx bits
;
nxpop0          .equ            0b00000001
nxpop1          .equ            0b00000010
nxpop2          .equ            0b00000100
nxpop3          .equ            0b00001000
nxpop4          .equ            0b00010000
nxpop5          .equ            0b00100000
nxpop6          .equ            0b01000000
nxpop7          .equ            0b10000000
