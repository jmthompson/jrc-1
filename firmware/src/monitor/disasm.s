; *******************************
; *  JRC-1 65816 SBC Firmware   *
; * (C) 2021 Joshua M. Thompson *
; *******************************
;
; Most of this is a rough translation of the C++ code in the
; XGS debugger

        .include "common.inc"
        .include "syscalls.inc"
        .include "console.inc"
        .include "ascii.inc"
        .include "kernel/syscall_macros.inc"

        .include "opcode.inc"
        .include "operand.inc"

        .export   disassemble, print_instruction

        .import   m_width,x_width
        .import   print_hex
        .importzp start_loc

        .segment "OSROM"

PREG_M  = $20
PREG_X  = $10

;;
; Entry point for the monitor's (L)ist command
;;
.proc disassemble
        ldxw    #20
@loop:  phx
        jsr     update_widths
        lda     start_loc + 2
        pha
        lda     start_loc
        pha
        shortm
        lda     m_width
        pha
        lda     x_width
        pha
        longm
        jsr     print_instruction
        txa
        clc
        adc     start_loc
        sta     start_loc
        plx
        dex
        bne     @loop
        rts
.endproc

;; Update M/X widths based on current instruction
;
; On exit:
;
; A/Y trashed
; m/x bit values possibly updated
;
.proc update_widths
        shortm
        lda     [start_loc]
        cmp     #$C2            ; REP
        beq     @rep
        cmp     #$E2            ; SEP
        beq     @sep
        cmp     #$FB            ; XCE
        beq     @xce
@exit:  longm
        rts

@rep:   ldyw    #1
        lda     [start_loc],y
        and     #PREG_M
        beq     :+
        stz     m_width
:       lda     [start_loc],y
        and     #PREG_X
        beq     @exit
        stz     x_width
        bra     @exit
@sep:   ldyw    #1
        lda     [start_loc],y
        and     #PREG_M
        beq     :+
        lda     #1
        sta     m_width
:       lda     [start_loc],y
        and     #PREG_X
        beq     @exit
        lda     #1
        sta     x_width
        bra     @exit
@xce:   lda     #1
        sta     m_width
        sta     x_width
        bra     @exit
.endproc
        
;;
; Disassemble the instruction at the given address, and return the
; number fo byte disassembled.
;
; Stack frame:
;
; |----------------------------|
; | [1] Index width (0/1)      |
; |----------------------------|
; | [1] Memory width (0/1)     |
; |----------------------------|
; | [4] Pointer to instruction |
; |----------------------------|
;
; On exit:
;
; C,Y trashed
; X = number of bytes disassembled
;
.proc print_instruction

BEGIN_PARAMS
  PARAM l_tmp     .byte
  PARAM l_len     .byte
  PARAM l_am      .byte
  PARAM l_instr   .byte
  PARAM s_dreg    .word
  PARAM s_ret     .word
  PARAM i_xwidth  .byte
  PARAM i_mwidth  .byte
  PARAM i_ptr     .dword
END_PARAMS

@lsize  := s_dreg - 1
@psize  := 6

        phd
        tsc
        sec
        sbcw    #@lsize
        tcs
        tcd
        shortmx
        lda     [i_ptr]
        tax
        lda     f:opcode_instr,x
        sta     l_instr
        lda     f:opcode_operands,x
        sta     l_am
        tax
        lda     f:instr_lengths,x
        sta     l_len
        cpx     #Operand::immediate_m
        bne     :+
        lda     i_mwidth
        bne     @len
        inc     l_len
        bra     @len
:       cpx     #Operand::immediate_x
        bne     @len
        lda     i_xwidth
        bne     @len
        inc     l_len
        bra     @len
@len:   lda     i_ptr + 2
        jsl     print_hex
        lda     #'/'
        _PrintChar
        lda     i_ptr + 1
        jsl     print_hex
        lda     i_ptr
        jsl     print_hex
        ldx     #2
        jsr     print_spaces
        ldy     #0
@hex:   lda     [i_ptr],y
        jsl     print_hex
        lda     #' '
        _PrintChar
        iny
        cpy     l_len
        bne     @hex
        lda     #4
        sec
        sbc     l_len               ; If len < 4 then we need filler spaces
        bcc     :+
        sta     l_tmp
        asl                         ; x2
        clc
        adc     l_tmp               ; x3
        tax
        jsr     print_spaces        ; fill in the blanks
:       lda     l_instr
        pea     .hiword(instr_mnemonics)
        longm
        andw    #$FF                ; mask high byte garbage
        asl
        asl                         ; x4
        clc
        adcw    #.loword(instr_mnemonics)
        pha                         ; low word
        _PrintString
        shortm
        ldx     #3
        jsr     print_spaces
        jsr     print_operand
        lda     #CR
        _PrintChar
        lda     #LF
        _PrintChar
        ldx     l_len
        longmx
        lda     s_dreg,s
        sta     s_dreg + @psize,s
        lda     s_ret,s
        sta     s_ret + @psize,s
        tsc
        clc
        adcw    #@psize + @lsize
        tcs
        pld
        rts

;;
; Print the operand
;
print_operand:
        lda     l_am
        asl
        tax
        longm
        lda     f:@handlers,x
        pha
        shortm
        rts
@handlers:
        .addr   disp_am_immediate-1
        .addr   disp_am_immediate-1
        .addr   disp_am_a-1
        .addr   disp_am_al-1
        .addr   disp_am_d-1
        .addr   disp_am_implied-1
        .addr   disp_am_dix-1
        .addr   disp_am_dixl-1
        .addr   disp_am_dxi-1
        .addr   disp_am_dxx-1
        .addr   disp_am_dxy-1
        .addr   disp_am_axx-1
        .addr   disp_am_alxx-1
        .addr   disp_am_axy-1
        .addr   disp_am_pcr-1
        .addr   disp_am_pcrl-1
        .addr   disp_am_ai-1
        .addr   disp_am_di-1
        .addr   disp_am_dil-1
        .addr   disp_am_axi-1
        .addr   disp_am_sr-1
        .addr   disp_am_srix-1
        .addr   disp_am_blockmove-1
        .addr   disp_am_immediate_m-1
        .addr   disp_am_immediate_x-1

;;
; Print the immediate mode operand
;
; On entry:
;
; Y = instruction length
;;
print_immediate_operand:
        lda   #'#'    ; fall through to print_constant
        _PrintChar

;;
; Print the operand
;
; On entry:
;
; Y = instruction length
;;
print_constant:
        ldy     l_len
@loop:  dey
        bne     :+
        rts
:       lda     [i_ptr],y
        jsl     print_hex
        bra     @loop

disp_am_immediate:
        ldy     l_len
        jmp     print_immediate_operand

disp_am_immediate_m:
        ldy     #2
        lda     i_mwidth
        bne     :+
        iny
:       jmp     print_immediate_operand

disp_am_immediate_x:
        ldy     #2
        lda     i_xwidth
        bit     #PREG_X
        bne     :+
        iny
:       jmp     print_immediate_operand

disp_am_a:
disp_am_al:
disp_am_d:
        jmp     print_constant

disp_am_implied:
        rts

disp_am_dix:
        lda     #'('
        _PrintChar
        jsr     print_constant
        _PrintString @str
        rts
@str:   .byte   "),Y", 0

disp_am_dixl:
        lda     #'['
        _PrintChar
        jsr     print_constant
        _PrintString @str
        rts
@str:   .byte   "],Y", 0

disp_am_dxi:
disp_am_axi:
        lda     #'('
        _PrintChar
        jsr     print_constant
        _PrintString @str
        rts
@str:   .byte   ",X)", 0

disp_am_dxx:
disp_am_axx:
disp_am_alxx:
        jsr     print_constant
        lda     #','
        _PrintChar
        lda     #'X'
        _PrintChar
        rts

disp_am_dxy:
disp_am_axy:
        ldy     l_len
        jsr     print_constant
        lda     #','
        _PrintChar
        lda     #'Y'
        _PrintChar
        rts

disp_am_pcr:
        ldy     #1
        lda     [i_ptr],y
        longm
        andw    #$ff
        bitw    #$80
        beq     :+
        oraw    #$ff00
:       clc
        adc     i_ptr
        inc
        inc
        shortm
        xba
        jsl     print_hex   ; print high byte
        xba
        jsl     print_hex   ; print low byte
        rts

disp_am_pcrl:
        ldy     #1
        longm
        lda     [i_ptr],y
        clc
        adc     i_ptr
        clc
        adcw    #3
        shortm
        xba
        jsl     print_hex   ; print high byte
        xba
        jsl     print_hex   ; print low byte
        rts

disp_am_ai:
disp_am_di:
        lda     #'('
        _PrintChar
        ldy     l_len
        jsr     print_constant
        lda     #')'
        _PrintChar
        rts

disp_am_dil:
        lda     #'['
        _PrintChar
        ldy     l_len
        jsr     print_constant
        lda     #']'
        _PrintChar
        rts

disp_am_sr:
        ldy     l_len
        jsr     print_constant
        lda     #','
        _PrintChar
        lda     #'S'
        _PrintChar
        rts

disp_am_srix:
        lda     #'('
        _PrintChar
        ldy     l_len
        jsr     print_constant
        _PrintString @str
        rts
@str:   .byte   ",S),Y", 0

disp_am_blockmove:
        ldy     #1
        lda     [i_ptr],y
        jsl     print_hex
        lda     #','
        _PrintChar
        iny
        lda     [i_ptr],y
        jsl     print_hex
        rts

;;
; Print out a string of space whose length is given in the X register.
; X may be zero, in which case nothing is printed.
;
print_spaces:
        cpx     #0
        beq     :+
        lda     #' '
        _PrintChar
        dex
        bra     print_spaces
:       rts
.endproc
