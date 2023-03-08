; *******************************
; *  JRC-1 65816 SBC Firmware   *
; * (C) 2022 Joshua M. Thompson *
; *******************************

        .include "common.inc"
        .include "ascii.inc"
        .include "console.inc"
        .include "syscalls.inc"
        .include "kernel/function_macros.inc"

        .export mon_show_heap

        .import print_address, print_hex

        .import __HEAP_START__, __HEAP_SIZE__

        .segment "OSROM"

.proc mon_show_heap
        _BeginDirectPage
          l_ptr   .dword
          _StackFrameRTS
        _EndDirectPage

        _SetupDirectPage
        ldaw    #.loword(__HEAP_START__)
        sta     l_ptr
        ldaw    #.hiword(__HEAP_START__)
        sta     l_ptr + 2

        ; Line format: "xx/xxxx yyyy *"
@loop:
        lda   l_ptr + 2
        pha
        lda   l_ptr
        pha
        jsl   print_address
        shortm
        lda     #' '
        _PrintChar
        lda     #' '
        _PrintChar
        ldyw    #1
        lda     [l_ptr],y
        jsl     print_hex
        lda     [l_ptr]
        and     #$FC
        jsl     print_hex
        lda     [l_ptr]
        and     #1
        beq     :+
        lda     #' '
        _PrintChar
        lda     #'*'
        _PrintChar
:       lda     #CR
        _PrintChar
        lda     #LF
        _PrintChar
        longm
        lda     [l_ptr]
        andw    #$FFFC
        clc
        adc     l_ptr
        bcs     @done       ; the heap doesn't cross bank boundaries
        cmpw    #.loword(__HEAP_START__ + __HEAP_SIZE__ - 1)
        bge     @done       ; end of heap
        sta     l_ptr
        bra     @loop
@done:  _RemoveParams
        pld
        rts
.endproc
