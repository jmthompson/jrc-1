; *******************************
; *  JRC-1 65816 SBC Firmware   *
; * (C) 2021 Joshua M. Thompson *
; *******************************

        .include "common.inc"
        .include "ascii.inc"
        .include "fcntl.inc"
        .include "kernel/device.inc"
        .include "kernel/fs.inc"
        .include "kernel/function_macros.inc"
        .include "kernel/syscall_macros.inc"

        ;.export console_cll
        ;.export console_cls
        .export console_init
        .export console_register
        ;.export console_reset
        ;.export console_writeln

        .import getc_seriala, putc_seriala

        .segment "ZEROPAGE"
tmp:    .res 4

        .segment "BOOTROM"

.proc console_init
        php
        jsl     console_reset
        jsl     console_cls
        plp
        rts
.endproc

        .segment "OSROM"

console_name:
        .asciiz "console"

console_ops:
        .dword  console_open
        .dword  console_release
        .dword  console_seek
        .dword  console_read
        .dword  console_write
        .dword  console_flush
        .dword  console_poll
        .dword  console_ioctl

.proc console_register
        _PushLong console_name
        _PushWord DEVICE_ID_CONSOLE
        _PushLong console_ops
        _PushLong 0
        jsr     register_device
        rts
.endproc

;-------- FileOperations methods --------;

;;
; Open the console. Currently a no-op
;
; Stack frame:
;
; |-----------------------|
; | [4] Pointer to Inode  |
; |-----------------------|
; | [4] Pointer to File   |
; |-----------------------|
;
; On exit:
; C,X,Y trashed
;
.proc console_open
        _BeginDirectPage
          _StackFrameRTL
          i_filep   .dword
          i_inodep  .dword
        _EndDirectPage

        _SetupDirectPage
        _RemoveParams
        ldaw    #0
        clc
        pld
        rtl
.endproc

;;
; Close the console
;
; Stack frame:
;
; |-----------------------|
; | [4] Pointer to Inode  |
; |-----------------------|
; | [4] Pointer to File   |
; |-----------------------|
;
; On exit:
; C,X,Y trashed
;
.proc console_release
        _BeginDirectPage
          _StackFrameRTL
          i_filep   .dword
          i_inodep  .dword
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
.proc console_seek
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
; Read from the console
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
; On exit:
; C,X,Y trashed
;
.proc console_read
        _BeginDirectPage
          l_nonblock  .byte
          _StackFrameRTL
          i_filep     .dword
          i_bufferp   .dword
          i_size      .dword
          o_size      .dword
        _EndDirectPage

        _SetupDirectPage
        ldyw    #File::flags
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
@wait:  jsl     getc_seriala        ; TODO: maybe allow attaching console to serial b?
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
; Write to the console
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
.proc console_write
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
@loop:  lda     i_size
        ora     i_size + 2
        beq     @exit
        shortm
        lda     [i_bufferp]
        jsl     putc_seriala        ; always blocks; no O_NONBLOCK writes
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
; Flush console buffers
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
.proc console_flush
        _BeginDirectPage
          _StackFrameRTL
          i_filep     .dword
        _EndDirectPage

        _SetupDirectPage
        _RemoveParams
        pld
        rtl
.endproc

;;
; Console poll
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
.proc console_poll
        _BeginDirectPage
          _StackFrameRTL
          i_filep     .dword
        _EndDirectPage

        _SetupDirectPage
        _RemoveParams
        pld
        rtl
.endproc

;;
; Console ioctl
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
.proc console_ioctl
        _BeginDirectPage
          _StackFrameRTL
          i_filep     .dword
        _EndDirectPage

        _SetupDirectPage
        _RemoveParams
        pld
        rtl
.endproc

; -------- private functions -------

; -------- legacy syscall functions -------
; TODO: remove as soon as driver is working

console_reset:
        shortmx
        ldx     #0
:       lda     f:@reset,x
        beq     :+
        phx
        jsl     putc_seriala
        plx
        inx
        bne     :-
:       clc
        rtl
@reset: .byte   ESC,"c"     ; reset terminal to default state
        .byte   ESC,"[7h"   ; enable line wrap
        .byte   ESC,")0"    ; set char set G1 to line drawing chars
        .byte   0

console_cls:
        shortmx
        lda     #ESC
        jsl     putc_seriala
        lda     #LBRACKET
        jsl     putc_seriala
        lda     #'2'
        jsl     putc_seriala
        lda     #'J'
        jml     putc_seriala

console_cll:
        shortmx
        lda     #ESC
        jsl     putc_seriala
        lda     #LBRACKET
        jsl     putc_seriala
        lda     #'2'
        jsl     putc_seriala
        lda     #'K'
        jml     putc_seriala
        
;;
; Print a null-terminated string up to 255 characters in length.
;
console_writeln:
        _GetParam32 0
        sta     tmp
        stx     tmp + 2
        shortmx
        ldy     #0
@loop:  lda     [tmp],y
        beq     @exit
        jsl     putc_seriala
        iny
        bne     @loop
@exit:  rtl
