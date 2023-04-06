; *******************************
; *  JRC-1 65816 SBC Firmware   *
; * (C) 2021 Joshua M. Thompson *
; *******************************

        .include "common.inc"
        .include "errors.inc"
        .include "kernel/device.inc"
        .include "kernel/fs.inc"
        .include "kernel/function_macros.inc"

        .export     via_init
        .export     via_irq
        .export     via_register
        .export     wait_ms

.struct VIA
        .org $F000

        portb   .byte
        porta   .byte
        ddrb    .byte
        ddra    .byte
        t1cl    .byte
        t1ch    .byte
        t1ll    .byte
        t1lh    .byte
        t2cl    .byte
        t2ch    .byte
        sr      .byte
        acr     .byte
        pcr     .byte
        ifr     .byte
        ier     .byte
        portaxA .byte
.endstruct

        .segment "BOOTROM"

via_init:
        ; Disable all interrupts
        lda     #$7F
        sta     VIA::ier

        ; Disable timers & shift registers
        stz     VIA::acr

        ; VIA ports A & B
        stz     VIA::porta
        stz     VIA::portb
        stz     VIA::ddra

        ; SPI clock 400 kHZ
        lda     #$C0
        sta     VIA::acr
        lda     #8                ; assuming 8 MHz phi2
        sta     VIA::t1cl
        stz     VIA::t1ch

        bit     VIA::porta
        rts

via_irq:
        ; dispatch to registered handler
 
@exit:  rts

; Wait up to 7ms (assuming 8MHz phi2 clock), with about 1% error because
; we use a x8192 multiplier instead of x8000. Must be called with m=1.
;
; On entry:
; A = number of ms to wait, 0-7.
;
; On exit:
; A trashed

wait_ms:
        pha
        lda     #0
        sta     f:VIA::t2cl
        pla
        and     #$07        ; can't wait more than about 7 ms
        asl
        asl
        asl
        asl
        asl                 ; x8192 because this will be the upper byte
        sta     f:VIA::t2ch
:       lda     f:VIA::ifr
        and     #$20
        beq     :-
        lda     f:VIA::t2cl
        rtl

        .segment "OSROM"

via_name:
        .asciiz     "userport"

; Serial operations for port 1
via_ops:
        .dword  via_open
        .dword  via_release
        .dword  via_seek
        .dword  via_read
        .dword  via_write
        .dword  via_flush
        .dword  via_poll
        .dword  via_ioctl

;;
; Register the SPI device drivers
;
.proc via_register
        _PushLong via_name
        _PushWord DEVICE_ID_USERPORT
        _PushLong via_ops
        _PushLong 0
        jsr     register_device
        rts
.endproc

;-------- FileOperations methods --------;

;;
; Open the user port. Currently a no-op
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
.proc via_open
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
; Close the user port
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
.proc via_release
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
.proc via_seek
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
; Read from the user port
;
; Stack frame:
;
; |------------------------------|
; | [4] Space for returned count |
; |------------------------------|
; | [4] Pointer to File          |
; |------------------------------|
; | [4] Pointer to buffer        |
; |------------------------------|
; | [4] Number of bytes to read  |
; |------------------------------|
;
; On exit:
; C,X,Y trashed
;
.proc via_read
        _BeginDirectPage
          _StackFrameRTL
          i_size      .dword
          i_bufferp   .dword
          i_filep     .dword
          o_size      .dword
        _EndDirectPage

        _SetupDirectPage
        stz     o_size
        stz     o_size + 2
        _RemoveParams o_size
        ldaw    #0
        clc
        pld
        rtl
.endproc

;;
; Write to the user port
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
; On exit:
; C,X,Y trashed
;
.proc via_write
        _BeginDirectPage
          _StackFrameRTL
          i_filep     .dword
          i_bufferp   .dword
          i_size      .dword
          o_size      .dword
        _EndDirectPage

        _SetupDirectPage
        stz     o_size
        stz     o_size + 2
        _RemoveParams o_size
        ldaw    #0
        clc
        pld
        rtl
.endproc

;;
; Flush user port buffers. This is a noop
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
.proc via_flush
        _BeginDirectPage
          _StackFrameRTL
        _EndDirectPage

        _SetupDirectPage
        _RemoveParams
        pld
        rtl
.endproc

;;
; Poll the user port
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
.proc via_poll
        _BeginDirectPage
          _StackFrameRTL
        _EndDirectPage

        _SetupDirectPage
        _RemoveParams
        pld
        rtl
.endproc

;;
; User port ioctl
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
.proc via_ioctl
        _BeginDirectPage
          _StackFrameRTL
        _EndDirectPage

        _SetupDirectPage
        _RemoveParams
        pld
        rtl
.endproc
