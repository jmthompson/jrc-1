; *******************************
; *  JRC-1 65816 SBC Firmware   *
; * (C) 2021 Joshua M. Thompson *
; *******************************

        .include "common.s"
        .include "sys/ascii.s"
        .include "sys/io.s"

        .import uart_init
        .import uart_irq
        .import cic_init
        .import monitor_start
        .import monitor_brk
        .import monitor_nmi
        .import spi_init
        .import spi_irq
        .import via_init
        .import via_irq
        .import device_manager_init

        .import console_init
        .import console_attach
        .import console_reset
        .import console_read
        .import console_readln
        .import console_write
        .import console_writeln

        .import install_device
        .import remove_device
        .import find_device
        .import call_device

        .import getc_seriala
        .import putc_seriala
        .import getc_serialb
        .import putc_serialb

        .import jros_init

        .import __SYSDP_START__
        .import __SYSSTACK_START__
        .import __SYSSTACK_SIZE__

        ;; from buildinfo.s
        .import hw_revision
        .import rom_version
        .import rom_date

        .importzp   param

STACKTOP    = __SYSSTACK_START__ + __SYSSTACK_SIZE__ - 1

; Processor status register bits
PREG_I      =   %00000100
PREG_C      =   %00000001

SHIFT_OUT   = 14
SHIFT_IN    = 15

        .segment "SYSDATA": far

syscall_trampoline: .res 4

        .segment "BIOSROM"

;;
; Print the 8-bit number in the accumulator in decimal
;
; Accumulator is corrupted on exit
;
print_decimal8:
        ldx     #$ff
        sec
@pr100: inx
        sbc     #100
        bcs     @pr100
        adc     #100
        cpx     #0
        beq     @skip100
        jsr     @digit
@skip100: ldx     #$ff
        sec
@pr10:  inx
        sbc     #10
        bcs     @pr10
        adc     #10
        cpx     #0
        beq     @skip10
        jsr     @digit
@skip10: tax
@digit: pha
        txa
        ora     #'0'
        call    SYS_CONSOLE_WRITE
        pla 
        rts
;;
;
; Print the boot banner to the console
;
startup_banner:
        ; top line of box
        putc    #SHIFT_OUT
        putc    #'l'
        puts    @line
        putc    #'k'
        putc    #SHIFT_IN
        putc    #CR

        ; System ID
        puts    @sysid

        ; HW Revision
        puts    @hwrev
        lda     hw_revision
        jsr     print_decimal8
        puts    @hwrev2

        ; ROM Version
        puts    @romver
        lda     rom_version
        lsr
        lsr
        lsr
        lsr
        jsr     print_decimal8
        putc    #'.'
        lda     rom_version
        and     #$0f
        jsr     print_decimal8
        putc    #' '
        putc    #'('
        puts    rom_date
        putc    #')'
        puts    @romver2

        ; bottom line of box
        putc    #SHIFT_OUT
        putc    #'m'
        puts    @line
        putc    #'j'
        putc    #SHIFT_IN
        putc    #CR

        puteol
        puteol

        rtl

@line:  .repeat 31
        .byte   "q"
        .endrepeat
        .byte   0

@sysid:  .byte  SHIFT_OUT, "x", SHIFT_IN
         .byte  " JRC-1 Single Board Computer   "
         .byte  SHIFT_OUT, "x", SHIFT_IN, CR, 0

@hwrev:  .byte  SHIFT_OUT, "x", SHIFT_IN, " Hardware Revision ", 0
@hwrev2: .byte  "           ", SHIFT_OUT, "x", SHIFT_IN, CR, 0

@romver:  .byte SHIFT_OUT, "x", SHIFT_IN, " ROM Version ", 0
@romver2: .byte "  ", SHIFT_OUT, "x", SHIFT_IN, CR, 0

read_seriala:
        jml     getc_seriala

write_seriala:
        jml     putc_seriala

read_serialb:
        jml     getc_serialb

write_serialb:
        jml     putc_serialb

.macro  syscall     func, psize
        .faraddr    func
        .byte       psize
.endmacro

syscall_table:
        syscall     console_attach, 0
        syscall     console_read, 0
        syscall     console_write, 0
        syscall     console_readln, 4
        syscall     console_writeln, 4
        syscall     read_seriala, 0
        syscall     write_seriala, 0
        syscall     read_serialb, 0
        syscall     write_serialb, 0
        syscall     install_device, 4
        syscall     remove_device, 0
        syscall     find_device, 4
        syscall     call_device, 4

syscall_max = (*-syscall_table)/4

        .segment "BOOTROM"

;;
; COP handler; dispatches to the syscall indicated by the signature byte
;
syscall_dispatch:

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

; Start of parameters passed by caller
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
        cmp     #syscall_max
        bge     @error
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
@error: brk     $00

sysreset:
        sei
        cld
        clc
        xce

        shortx

        longm
        ldaw    #BIOS_DP
        tcd
        ldaw    #STACKTOP
        tcs
        shortm

        lda     #BIOS_DB
        pha
        plb

        lda     #$5C                ; JML $xxyyzz
        sta     syscall_trampoline  ; Init syscall trampoline vector

        jsl     device_manager_init
        
        jsr     via_init
        jsr     spi_init
        jsr     uart_init

        cli

        jsl     console_init
        jsl     startup_banner

        ;jsl     jros_init        ; Initialize JR/OS
        ;jml     LAB_COLD        ; ... and drop the user into BASIC
        jml     monitor_start

sysnmi:
        longmx
        phb
        phd
        pha
        phx
        phy
        ldaw    #BIOS_DP
        tcd
        shortmx
        lda     #BIOS_DB
        pha
        plb
        cli
        jml     monitor_nmi

sysirq: 
        rep     #$30
        phb
        phd
        pha
        phx
        phy
        ldaw    #BIOS_DP
        tcd
        sep     #$30
        pha                 ; Low byte of BIOS_DP will always be $00
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

sysbrk:
        longmx
        phb
        phd
        pha
        phx
        phy
        ldaw    #BIOS_DP
        tcd
        shortmx
        lda     #BIOS_DB
        pha
        plb
        cli
        jml     monitor_brk

        .segment "HWVECTORS"

        .addr   syscall_dispatch    ; $FFE4 (cop native)
        .addr   sysbrk              ; $FFE6 (brk native)
        .addr   sysreset            ; $FFE8 (abort native)
        .addr   sysnmi              ; $FFEA (nmi native)
        .addr   0                   ; $FFEC (not used)
        .addr   sysirq              ; $FFEE (irq native)
        .addr   0                   ; $FFF0 (not used)
        .addr   0                   ; $FFF2 (not used)
        .addr   sysreset            ; $FFF4 (cop emulation)
        .addr   0                   ; $FFF6 (not used)
        .addr   sysreset            ; $FFF8 (abort emulation)
        .addr   sysreset            ; $FFFA (nmi emulation)
        .addr   sysreset            ; $FFFC (reset)
        .addr   sysreset            ; $FFFE (irq emulation)
