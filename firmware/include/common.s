        .setcpu "65816"
        .a8
        .i8

        .include "sys/syscall.s"
        .include "sys/error.s"

        .import __BIOS_DP_START__
        .import __SYSRAM_START__
        .import __SYSSTACK_START__
        .import __SYSSTACK_SIZE__

IRQ_DB       = $00
OS_DB        = .bankbyte(__SYSRAM_START__)
OS_DP        = __BIOS_DP_START__
OS_STACKTOP  = __SYSSTACK_START__ + __SYSSTACK_SIZE__ - 1

.macro  syserr  code
        lda     #code
        sec
        rtl
.endmacro

; Increment a 32-bit value in memory
.macro  inc32   addr
        inc     addr
        bne     :+
        inc     addr+2
:       
.endmacro

.macro  longaddr addr
        .faraddr addr
        .byte 0
.endmacro

;;
; blt/bge so i don't have to remember which is bcc
; and which is bcs
;
;
.macro  blt     label
        bcc     label
.endmacro

.macro  bge     label
        bcs     label
.endmacro

;;
;
; Convenience macros for register-width handling.
; They provide an unambiguous way to specify that
; you want a 16-bit operand for an opcode without
; having to manually manipulate the assembler mode.
;
;
.macro  adcw    operand
        .a16
        adc     operand
        .a8
.endmacro

.macro  andw    operand
        .a16
        and     operand
        .a8
.endmacro

.macro  bitw    operand
        .a16
        bit     operand
        .a8
.endmacro

.macro  cmpw    operand
        .a16
        cmp     operand
        .a8
.endmacro

.macro  cpxw    operand
        .i16
        cpx     operand
        .i8
.endmacro

.macro  cpyw    operand
        .i16
        cpy     operand
        .i8
.endmacro

.macro  eorw    operand
        .a16
        eor     operand
        .a8
.endmacro

.macro  ldaw    operand
        .a16
        lda     operand
        .a8
.endmacro

.macro  ldxw    operand
        .i16
        ldx     operand
        .i8
.endmacro

.macro  ldyw    operand
        .i16
        ldy     operand
        .i8
.endmacro

.macro  oraw    operand
        .a16
        ora     operand
        .a8
.endmacro

.macro  sbcw    operand
        .a16
        sbc     operand
        .a8
.endmacro

.macro  longm
        rep     #$20
.endmacro

.macro  longx
        rep     #$10
.endmacro

.macro  longmx
        rep     #$30
.endmacro

.macro  shortm
        sep     #$20
.endmacro

.macro  shortx
        sep     #$10
.endmacro

.macro  shortmx
        sep     #$30
.endmacro
