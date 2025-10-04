; *******************************
; *  JRC-1 65816 SBC Firmware   *
; * (C) 2021 Joshua M. Thompson *
; *******************************
;
; Serial port driver, supports units 0 and 1 (port A/B)
;
; TODO: the serial_read and serial_write functions should not
; call out to getc/putc functions; they should directly access
; the buffers. Additionally it may be worth increasing the
; buffer sizes beyond 256 bytes to allow larger writes to
; execute without blocking.

        .include "common.inc"
        .include "errors.inc"
        .include "fcntl.inc"
        .include "kernel/device.inc"
        .include "kernel/fs.inc"
        .include "kernel/function_macros.inc"
        .include "kernel/linker.inc"
        .include "nxp_uart.s"

        .export serial_init
        .export serial_irq
        .export serial_register
        .export getc_seriala
        .export putc_seriala
        .export jiffies

        .import trampoline

; Currently it is assumes the buffer is exactly one page, because
; 8-bit index registers are used to access them and it is assumed
; that those index values roll over naturally. To go larger will
; require the index valuss to be explicitly masked.
BUFFER_SIZE := 256

nxp_base := $F020

        .segment    "ZEROPAGE"

rxa_rdi:    .res    1
rxa_wri:    .res    1
txa_rdi:    .res    1
txa_wri:    .res    1
rxb_rdi:    .res    1
rxb_wri:    .res    1
txb_rdi:    .res    1
txb_wri:    .res    1
txa_on:     .res    1
txb_on:     .res    1

        .segment "BSS"

; System uptime counter
jiffies:  .res    4

; Serial buffers
txa_ibuf: .res    BUFFER_SIZE
rxa_ibuf: .res    BUFFER_SIZE
txb_ibuf: .res    BUFFER_SIZE
rxb_ibuf: .res    BUFFER_SIZE

        .segment "BOOTROM"

;;
; Initialize the UART, Tx/Rx buffers and system timekeeping
;
serial_init:
        stz     rxa_rdi
        stz     rxa_wri
        stz     rxb_rdi
        stz     rxb_wri

        stz     txa_rdi
        stz     txb_rdi
        stz     txa_wri
        stz     txb_wri

        longm
        ldaw    #0
        sta     f:jiffies
        sta     f:jiffies+2
        shortm

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

;;
; Main serial interrupt handler. This checks the ISR to see if
; the interrupt was from the UART, and if so, branches to the
; appropriate handler to service the interrupt.
;
serial_irq:
        lda     nxp_base+nx_isr
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
@done:  rts

;;
; Timer interrupt handler
;
timer_irq:
        bit     nxp_base+nx_rct     ; reset the interrupt
        longm
        lda     f:jiffies
        inc
        sta     f:jiffies
        bne     :+
        lda     f:jiffies + 2
        inc
        sta     f:jiffies + 2
:       shortm
        rts

;;
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
        lda     f:txa_ibuf,x
        sta     nxp_base+nx_fifoa
        inx
        stx     txa_rdi
        bra     @send
@empty: lda     #nxpcrtxd
        sta     nxp_base+nx_cra     ; Disable transmitter
        stz     txa_on              ;  and mark it as such
@done:  pla
        rts

;;
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
        lda     f:txb_ibuf,x
        sta     nxp_base+nx_fifob
        inx
        stx     txb_rdi
        bra     @send
@empty: lda     #nxpcrtxd
        sta     nxp_base+nx_crb     ; Disable transmitter
        stz     txb_on              ;  and mark it as such
@done:  pla
        rts

;;
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
        sta     f:rxa_ibuf,x
        xba
        tax
        bra     @load
@exit:  stx     rxa_wri
        pla
        rts

;;
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
        sta     f:rxb_ibuf,x
        xba
        tax
        bra     @load
@exit:  stx     rxb_wri
        pla
        rts

;;
; UART initialization table
;
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

serial_name:
        .asciiz     "serial"

; Serial operations
serial_ops:
        .dword  serial_open
        .dword  serial_release
        .dword  serial_seek
        .dword  serial_read
        .dword  serial_write
        .dword  serial_flush
        .dword  serial_poll
        .dword  serial_ioctl

;;
; Register the SPI device drivers
;
.proc serial_register
        _PushLong serial_name
        _PushWord DEVICE_ID_SERIAL
        _PushLong serial_ops
        _PushLong 0
        jsr     register_device
        rts
.endproc

;-------- FileOperations methods --------;

;;
; Open a serial port.
;
; Stack frame:
;
; |-----------------------|
; | [4] Pointer to File   |
; |-----------------------|
; | [4] Pointer to Inode  |
; |-----------------------|
;
; On exit:
; C,X,Y trashed
;
.proc serial_open
        _BeginDirectPage
          _StackFrameRTL
          i_inodep  .dword
          i_filep   .dword
        _EndDirectPage

        _SetupDirectPage
        ldyw    #File::unit
        lda     [i_filep],y
        cmpw    #2
        blt     @ok
        ldyw    #ENOSYS
        bra     @exit
@ok:    ldyw    #0
@exit:  _RemoveParams
        _SetExitState
        pld
        rtl
.endproc

;;
; Close the console
;
; Stack frame:
;
; |-----------------------|
; | [4] Pointer to File   |
; |-----------------------|
; | [4] Pointer to Inode  |
; |-----------------------|
;
.proc serial_release
        _BeginDirectPage
          _StackFrameRTL
          i_inodep  .dword
          i_filep   .dword
        _EndDirectPage

        _SetupDirectPage
        _RemoveParams
        ldaw    #0
        clc
        pld
        rtl
.endproc

;;
; Seek
;
; Stack frame:
;
; |-------------------------------|
; | [4] Space for returned offset |
; |-------------------------------|
; | [4] Offset                    |
; |-------------------------------|
; | [2] Whence                    |
; |-------------------------------|
; | [4] Pointer to File           |
; |-------------------------------|
;
; On exit:
; C,X,Y trashed
;
.proc serial_seek
        _BeginDirectPage
          _StackFrameRTL
          i_filep   .dword
          i_whence  .word
          i_offset  .dword
          o_offset  .dword
        _EndDirectPage

        _SetupDirectPage
        _RemoveParams o_offset
        ldaw    #0
        clc
        pld
        rtl
.endproc

;;
; Read from a serial port
;
; Stack frame:
;
; |------------------------------|
; | [4] Space for returned count |
; |------------------------------|
; | [4] Number of bytes to read  |
; |------------------------------|
; | [4] Pointer to buffer        |
; |------------------------------|
; | [4] Pointer to File          |
; |------------------------------|
;
.proc serial_read
        _BeginDirectPage
          l_nonblock  .byte
          _StackFrameRTL
          i_filep     .dword
          i_bufferp   .dword
          i_size      .dword
          o_size      .dword
        _EndDirectPage

        _SetupDirectPage
        ldyw    #File::unit
        lda     [i_filep],y
        bne     @s2
        ldaw    #.loword(getc_seriala)
        sta     trampoline + 1
        ldaw    #.hiword(getc_seriala)
        sta     trampoline + 3
        bra     @cont
@s2:    ldaw    #.loword(getc_serialb)
        sta     trampoline + 1
        ldaw    #.hiword(getc_serialb)
        sta     trampoline + 3
@cont:  ldyw    #File::flags
        shortm
        lda     [i_filep],y
        and     #O_NONBLOCK
        sta     l_nonblock
        longm
        stz     o_size
        stz     o_size + 2
@loop:  lda     i_size
        ora     i_size + 2
        beq     @exit
        shortm
@wait:  jsl     trampoline
        bcc     @store
        lda     l_nonblock
        beq     @wait
        longm
        bra     @exit
@store: sta     [i_bufferp]
        longm
        inc32   i_bufferp
        inc32   o_size
        dec32   i_size
        bra     @loop
@exit:  _RemoveParams o_size
        ldaw    #0
        clc
        pld
        rtl
.endproc

;;
; Write to a serial port
;
; Stack frame:
;
; |------------------------------|
; | [4] Space for returned count |
; |------------------------------|
; | [4] Number of bytes to write |
; |------------------------------|
; | [4] Pointer to buffer        |
; |------------------------------|
; | [4] Pointer to File          |
; |------------------------------|
;
.proc serial_write
        _BeginDirectPage
          _StackFrameRTL
          i_filep     .dword
          i_bufferp   .dword
          i_size      .dword
          o_size      .dword
        _EndDirectPage

        _SetupDirectPage
        ldyw    #File::unit
        lda     [i_filep],y
        bne     @s2
        ldaw    #.loword(putc_seriala)
        sta     trampoline + 1
        ldaw    #.hiword(putc_seriala)
        sta     trampoline + 3
        bra     @cont
@s2:    ldaw    #.loword(putc_serialb)
        sta     trampoline + 1
        ldaw    #.hiword(putc_serialb)
        sta     trampoline + 3
@cont:  stz     o_size
        stz     o_size + 2
@loop:  lda     i_size
        ora     i_size + 2
        beq     @exit
        shortm
        lda     [i_bufferp]
        jsl     trampoline
        longm
        inc32   i_bufferp
        inc32   o_size
        dec32   i_size
        bra     @loop
@exit:  _RemoveParams o_size
        ldaw    #0
        clc
        pld
        rtl
.endproc

;;
; Flush serial buffers
;
; Stack frame:
;
; |------------------------------|
; | [4] Pointer to File          |
; |------------------------------|
;
; On exit:
; C,X,Y trashed
;
.proc serial_flush
        _BeginDirectPage
          _StackFrameRTL
          i_filep     .dword
        _EndDirectPage

        _SetupDirectPage
        _RemoveParams
        ldaw    #0
        clc
        pld
        rtl
.endproc

;;
; Serial poll
;
; Stack frame:
;
; |------------------------------|
; | [4] Pointer to File          |
; |------------------------------|
;
; On exit:
; C,X,Y trashed
;
.proc serial_poll
        _BeginDirectPage
          _StackFrameRTL
          i_filep     .dword
        _EndDirectPage

        _SetupDirectPage
        _RemoveParams
        ldaw    #0
        clc
        pld
        rtl
.endproc

;;
; Serial ioctl
;
; Stack frame:
;
; |------------------------------|
; | [4] Pointer to File          |
; |------------------------------|
;
; On exit:
; C,X,Y trashed
;
.proc serial_ioctl
        _BeginDirectPage
          _StackFrameRTL
          i_filep     .dword
        _EndDirectPage

        _SetupDirectPage
        _RemoveParams
        ldaw    #0
        clc
        pld
        rtl
.endproc

; --------- Private/internal functions --------

;;
; Get next character from serial channel A. On exit, C=1 if
; no character was available; otherwise, C=0 and the character
; code is in A.
;
getc_seriala:
        phd
        php
        longm
        ldaw    #OS_DP
        tcd
        shortmx
        ldx     rxa_rdi
        cpx     rxa_wri
        beq     @empty
        lda     f:rxa_ibuf,X
        inx
        stx     rxa_rdi
        plp
        pld
        clc
        rtl
@empty: plp
        pld
        sec
        rtl

;;
; Get next character from serial channel B. On exit, C=1 if
; no character was available; otherwise, C=0 and the character
; code is in A.
;
getc_serialb:
        phd
        php
        longm
        ldaw    #OS_DP
        tcd
        shortmx
        ldx     rxb_rdi
        cpx     rxb_wri
        beq     @empty
        lda     f:rxb_ibuf,X
        inx
        stx     rxb_rdi
        plp
        pld
        clc
        rtl
@empty: plp
        pld
        sec
        rtl

;;
; Transmit character in A on serial channel A. This is a blocking
; operation, meaning this function will wait for the Tx FIFO to
; have an empty slot before returning.
;
putc_seriala:
        phd
        php
        longm
        pha
        ldaw    #OS_DP
        tcd
        pla
        shortmx
        ldx     txa_wri
        inx
@wait:  cpx     txa_rdi             ; is the buffer full?
        bne     @store              ; if no then store
        ;wai                        ; yes, so wait for an interrupt to hopefully clear some space
        bra     @wait               ; and then check again
@store: dex
        sta     f:txa_ibuf,x        ; Store the byte in the output buffer
        inx
        stx     txa_wri             ; ... and update write index
        lda     #$80
        tsb     txa_on              ; is the transmitter enabled?
        bne     :+                  ; if yes, we're done
        lda     #nxpcrtxe
        sta     f:nxp_base+nx_cra   ; Enable transmitter
:       plp
        pld
        clc
        rtl

;;
; Transmit character in A on serial channel B. This is a blocking
; operation, meaning this function will wait for the Tx FIFO to
; have an empty slot before returning.
;
putc_serialb:
        phd
        php
        longm
        pha
        ldaw    #OS_DP
        tcd
        pla
        shortmx
        ldx     txb_wri
        inx
@wait:  cpx     txb_rdi             ; is the buffer full?
        bne     @store              ; if no then store
        ;wai                        ; yes, so wait for an interrupt to hopefully clear some space
        bra     @wait               ; and then check again
@store: dex
        sta     f:txb_ibuf,x        ; Store the byte in the output buffer
        inx
        stx     txb_wri             ; ... and update write index
        lda     #$80
        tsb     txb_on              ; is the transmitter enabled?
        bne     :+                  ; if yes, we're done
        lda     #nxpcrtxe
        sta     f:nxp_base+nx_crb   ; Enable transmitter
:       plp
        pld
        clc
        rtl
