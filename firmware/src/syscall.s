; *******************************
; *  JRC-1 65816 SBC Firmware   *
; * (C) 2021 Joshua M. Thompson *
; *******************************

        .include "common.s"

        .export syscop
        .export syscall_trampoline

        .import console_reset
        .import console_writeln
        .import install_device
        .import remove_device
        .import find_device
        .import getc_seriala
        .import putc_seriala

        .importzp   param

; Processor status register bits
PREG_I      =   %00000100
PREG_C      =   %00000001

        .segment "SYSDATA": far

syscall_trampoline: .res 4

        .segment "BOOTROM"

syscop:
        jml     syscall

        .segment "OSROM"

;;
; COP handler; dispatches to the syscall indicated by the signature byte
;
syscall:

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
@param   := @pb_reg + 1

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

        lda     #BIOS_DB
        pha
        plb                     ; Set kernel data bank

        lda     @p_reg
        and     #~PREG_C&$FF    ; clear carry
        sta     @p_reg
        bit     #PREG_I         ; were interrupts disabled?
        bne     @noirq
        cli                     ; no, so re-enable them

@noirq: longm
        lda     @pc_reg
        dec
        sta     @copsig
        shortm
        lda     @pb_reg
        sta     @copsig+2

        lda     [@copsig]
        longm
        andw    #255
        asl
        asl
        tax

        shortm
        lda     f:syscall_table+3,x     ; Parameter frame size
        sta     @cf_size
        stz     @cf_size+1

        lda     f:syscall_table+2,x     ; Bank byte of handler
        sta     syscall_trampoline+3
        longm
        lda     f:syscall_table,x       ; Bank address of handler
        sta     syscall_trampoline+1
        phd                             ; save our DP for after dispatch

        lda     @a_reg                  ; Grab A; it might be a parameter
        pha
        ldaw    @param
        pha
        ldaw    @param+2
        pha
        ldaw    #BIOS_DP
        tcd
        pla
        sta     param+2
        pla
        sta     param
        pla                             ; restore A from caller

        shortmx
        jsl     syscall_trampoline
        pld
        sta     @a_reg                  ; return value of A to caller
        bcc     @noerr
        lda     @p_reg
        ora     #PREG_C                 ; set carry on return to caller
        sta     @p_reg
        
@noerr: longmx
        lda     @cf_size
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

; Macro for declaring dispatch table entries
.macro  syscall_entry func, psize
        .faraddr    func
        .byte       psize
.endmacro

unsupported_syscall:
        syserr  ERR_NOT_SUPPORTED

syscall_table:
        syscall_entry     unsupported_syscall, 0
        syscall_entry     getc_seriala, 0
        syscall_entry     putc_seriala, 0
        syscall_entry     console_writeln, 4
        syscall_entry     install_device, 4
        syscall_entry     remove_device, 0
        syscall_entry     find_device, 4
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
        syscall_entry     unsupported_syscall, 0
