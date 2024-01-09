              .rtmodel version, "1"
              .rtmodel cpu, "*"

#include "macros.h"

              .extern _Dp

bias:         .equ    127

              .argdelim <>

NaN:          .macro  isNaN, lowPart
              asl     a
              cmp     ##0xff00      ; all bits set in exponent?
              bcc     10$           ; no
              and     ##0x00ff      ; any bits set in mantissa?
              bne     \isNaN        ; yes
              lda     \lowPart
              bne     \isNaN        ; yes
10$:          .endm

;;; ***************************************************************************
;;;
;;; _Float32EQ - 32-bit float compare equal
;;;
;;; In: xc - operand 1
;;;     _Dp[0:3] - operand 2
;;;
;;; Out: Z flag - result
;;;
;;; Destroys: a
;;;
;;; ***************************************************************************

              .section libcode
              .public _Float32EQ
_Float32EQ:   pha
              txa                   ; any NaN gives not equal
              NaN     exitWithZ, <1,s>
              lda     dp:.tiny(_Dp+2)
              NaN     exitWithZ, dp:.tiny(_Dp+0)
              lda     dp:.tiny(_Dp+2) ; op2 zero?
              asl     a             ; clear sign
              ora     dp:.tiny(_Dp+0)
              bne     nonZero       ; op1 non-zero
              txa
              asl     a             ; clear sign
              ora     1,s
              beq     exitWithZ
nonZero:      txa                   ; compare parts
              cmp     dp:.tiny(_Dp+2)
              bne     exitWithZ
              lda     1,s
              cmp     dp:.tiny(_Dp+0)
exitWithZ:                          ; return with Z flag properly set
              php
              php
              lda     1,s
              sta     3,s
              pla
              plp
              plp
              return

;;; ***************************************************************************
;;;
;;; _Float32LT - 32-bit float compare less than
;;;
;;; In: xc - operand 1
;;;     _Dp[0:3] - operand 2
;;;
;;; Out: CY clear if less than, set otherwise
;;;
;;; Destroys: a
;;;
;;; ***************************************************************************

              .section libcode, noreorder
              .public _Float32LT
_Float32LT:   pha
              txa                   ; any NaN gives not less than
              NaN     exitNotLT, <1,s>
              lda     dp:.tiny(_Dp+2)
              NaN     exitNotLT, dp:.tiny(_Dp+0)
              txa                   ; op1 zero?
              asl     a             ; ignore sign of op1
              clc                   ; clear carry (= assume less-than)
              ora     1,s
              beq     check_op2     ; op1 zero
              lda     dp:.tiny(_Dp+2) ; op2 exponent zero?
              and     ##0x7f80
              bne     compare       ; no
              txa                   ; yes, check sign of op1
              bmi     exitFloat32LT ; negative < 0
exitNotLT:    sec                   ; not less-than
              bra     exitFloat32LT
check_op2:    lda     dp:.tiny(_Dp+2) ; op2 also zero?
              asl     a
              ora     dp:.tiny(_Dp+0)
              beq     exitNotLT     ; yes, both 0, not less-than
              bcs     exitFloat32LT ; op2 negative, not less-than
              clc

              .section libcode, noreorder
exitFloat32LT:
              pla
              return

compare:      txa
              ora     dp:.tiny(_Dp+2)
              bpl     10$           ; compare two positive
              lda     dp:.tiny(_Dp+0) ; either is negative, compare with swapped operands
              cmp     1,s
              phx
              lda     dp:.tiny(_Dp+2)
              sbc     1,s
              plx
              bra     exitFloat32LT

10$:          lda     1,s
              cmp     dp:.tiny(_Dp+0)
              txa
              sbc     dp:.tiny(_Dp+2)
              bra     exitFloat32LT

;;; ***************************************************************************
;;;
;;; _Float32GE - 32-bit float compare great than or equal
;;;
;;; In: xc - operand 1
;;;     _Dp[0:3] - operand 2
;;;
;;; Out: CY set if greater than or equal, set otherwise
;;;
;;; Destroys: a
;;;
;;; ***************************************************************************

              .section libcode, noreorder
              .public _Float32GE
_Float32GE:   pha
              txa                   ; any NaN gives not greater than or equal
              NaN     exitNotGE, <1,s>
              lda     dp:.tiny(_Dp+2)
              NaN     exitNotGE, dp:.tiny(_Dp+0)
              txa                   ; op1 zero?
              asl     a             ; clear sign of op1
              sec                   ; assume greater-than or equal
              ora     1,s
              beq     10$           ; op1 zero
              lda     dp:.tiny(_Dp+2) ; op2 zero?
              asl     a
              ora     dp:.tiny(_Dp+0)
              bne     compare       ; no
              txa
              bmi     exitNotGE
              sec
              bra     exitFloat32LT

10$:          lda     dp:.tiny(_Dp+2) ; op2 also zero?
              asl     a
              ora     dp:.tiny(_Dp+0)
              beq     exitNotLT     ; yes
              bcs     exitFloat32LT ; op2 negative, op1 is zero so greater than
exitNotGE:    clc                   ; not greater-than or equal
              pla
              return

;;; ***************************************************************************
;;;
;;; _UInt32ToFloat32 - unsigned 32-bit integer to float conversion
;;; _SInt32ToFloat32 - signed 32-bit integer to float conversion
;;;
;;; In: xc - integer
;;;
;;; Out: xc - floating point number
;;;
;;; Destroys: y, _Dp6-7
;;;
;;; ***************************************************************************

              .section libcode, noreorder
              .public _UInt32ToFloat32, _SInt32ToFloat32
_SInt32ToFloat32:
              phx
              pha
              txa                   ; signed?
              bpl     IntToFloat05  ; no
              sec                   ; yes, negate
              ldy     ##0
              tya
              sbc     1,s
              sta     1,s
              tya
              sbc     3,s
              sta     3,s
              tax
              sec
              bra     IntToFloat10

              .section libcode, noreorder
_UInt32ToFloat32:
              phx
              pha
IntToFloat05: clc
IntToFloat10: php                   ; save result sign on stack
              ldy     ##bias+24     ; biased exponent
              stz     dp:.tiny (_Dp+6) ; clear bucket
              txa                   ; check bits 24-31
              xba
              bne     IntToFloat50  ; too large for mantissa
              xba                   ; any bits 16-23 set?
              bne     20$           ; yes
              sec                   ; no, shift 8 steps
              tya                   ; adjust exponent
              sbc     ##8
              tay
              lda     2,s
              beq     IntToFloat00  ; it is actually 0
              xba
              and     ##0x00ff
              sta     4,s
              lda     2,s
              xba
              and     ##0xff00
              sta     2,s
20$:          lda     4,s           ; load upper part
30$:          tax                   ; left shift mantissa
              dey                   ; adjust exponent
              lda     2,s
              asl     a
              sta     2,s
              txa
              rol     a
              bit     ##0x0100      ; done?
              beq     30$           ; no, keep shifting
IntToFloat40: and     ##0x00ff      ; clear implicit bit
              plp                   ; sign to carry
              ror     a             ; shift in sign
              sta     3,s
              php                   ; save carry for shift into low part later
              tya                   ; A.low= exponent
              xba
              and     ##0xff00
              lsr     a             ; A[14:7]= exponent
              ora     4,s           ; combine with sign and mantissa
              tax                   ; X= high part
              plp
              lda     1,s           ; low part
              ror     a
              bcc     IntToFloat60  ; no rounding needed
              ldy     dp:.tiny (_Dp+6)
              bne     30$           ; yes round up
              bit     ##1           ; check lsb of result
              beq     IntToFloat60  ; not set
30$:          inc     a             ; round up
              bne     IntToFloat60
              inx
IntToFloat60: ply
              ply
              return

IntToFloat50: txa
              cmp     ##0x0200
              bcc     IntToFloat40  ; correctly aligned
              lsr     a             ; shift down
              tax
              lda     2,s
              ror     a
              sta     2,s
              ror     dp:.tiny (_Dp+6) ; into bucket
              iny                   ; adjust exponent
              bra     IntToFloat50

IntToFloat00: plp                   ; drop sign
              tax                   ; zero result
              bra     IntToFloat60

;;; ***************************************************************************
;;;
;;; _Float32ToUInt32 - float to unsigned 32-bit integer conversion
;;; _Float32ToSInt32 - float to signed 32-bit integer conversion
;;;
;;; In: xc - floating point number
;;;
;;; Out: xc - integer
;;;
;;; Destroys: y
;;;
;;; ***************************************************************************

              .section libcode
              .public _Float32ToUInt32, _Float32ToSInt32
_Float32ToUInt32:
              call    floatToUInt32
              bcc     20$           ; positive
              lda     ##0           ; negative, return 0
              tax
20$:          return

              .section libcode
_Float32ToSInt32:
              call    floatToUInt32
              txy                   ; overflowed?
              bmi     overflowToInt32
              bcc     20$           ; positive
              phx
              pha
              lda     ##0
              sbc     1,s
              tay
              lda     ##0
              sbc     3,s
              tax
              tya
              ply
              ply
20$:          return

overflowToInt32:                      ; return 0x80000000 if overflowed
              ldx     ##0x8000
              lda     ##0
              return

;;; ***************************************************************************
;;;
;;; floatToUInt32 - convert floating point value to unsigned 32 bit integer
;;;
;;; In: x:c - floating point value
;;;
;;; Out: x:c - integer
;;;      carry - sign flag
;;;
;;; Destroys: y
;;;
;;; ***************************************************************************

              .section libcode
floatToUInt32:
              pha                   ; save low part
              txa                   ; unpack mantissa
              and     ##0x007f
              ora     ##0x0080
              pha
              txa                   ; unpack exponent
              asl     a             ; CY= sign
              php
              xba
              and     ##0x00ff
              sec
              sbc     ##bias
              bcc     100$          ; too small, zero
              sbc     ##24
              bcs     30$           ; no right shift
              eor     ##0xffff
              beq     1$            ; done
              tay
25$:          lda     2,s           ; right shift
              lsr     a
              sta     2,s
              lda     4,s
              ror     a
              sta     4,s
              dey
              bne     25$
1$:           plp
              plx
              pla
              return

30$:          cmp     ##8
              bcc     40$           ; not too large
              plp
              lda     ##0xffff      ; set all bits
              bra     110$

40$:          tay
45$:          lda     4,s           ; left shift
              asl     a
              sta     4,s
              lda     2,s
              rol     a
              sta     2,s
              dey
              bpl     45$
              bra     1$

100$:         plp
              lda     ##0           ; zero result
110$:         tax
              ply
              ply
              return

;;; ***************************************************************************
;;;
;;; _UInt64ToFloat32 - unsigned 64-bit integer to float conversion
;;; _SInt64ToFloat32 - signed 64-bit integer to float conversion
;;;
;;; In: _Dp0-3 - pointer to integer
;;;
;;; Out: xc - floating point number
;;;
;;; Destroys: y, _Dp0-1
;;;
;;; ***************************************************************************

              .section libcode, noreorder
              .public _UInt64ToFloat32, _SInt64ToFloat32
_SInt64ToFloat32:
              sec                   ; we want to fix sign later
              bra     Int64ToFloat32

              .section libcode, noreorder
_UInt64ToFloat32:
              clc
Int64ToFloat32:
              ldy     ##6           ; copy integer to stack
10$:          lda     [.tiny _Dp],y
              pha
              dey
              dey
              bpl     10$
              iny
              iny                   ; y=0, assume positive sign
              bcc     20$           ; doing unsigned
              lda     7,s           ; signed input, negative?
              bpl     20$           ; no
              iny                   ; remember negative result
              lda     ##0           ; negate input
              tax
              sbc     1,s
              sta     1,s
              txa
              sbc     3,s
              sta     3,s
              txa
              sbc     5,s
              sta     5,s
              txa
              sbc     7,s
              sta     7,s

20$:          ldx     ##bias+24     ; biased exponent
              stz     dp:.tiny(_Dp) ; clear bucket
              lda     3,s           ; check highest bits exceed mantissa
              and     ##0xff00
              ora     5,s
              ora     7,s
              bne     50$           ; yes bits above mantissa range set
              lda     1,s           ; check for 0
              ora     3,s
              bne     35$           ; non-zero
              tax                   ; return 0
              ply
              ply
              bra     49$
35$:          dex                   ; adjust exponent
              lda     1,s           ; shift left one step at a time
              asl     a
              sta     1,s
              lda     3,s
              rol     a
              sta     3,s
              bit     ##0x0100
              beq     35$

40$:          tya                   ; get sign
              lsr     a             ; sign to carry
              txa                   ; get exponent
              xba                   ; exponent to upper byte
              eor     ##0x0100      ; flip lower byte as to compensate for
                                    ;   currently set implicit bit in mantissa
              eor     3,s           ; combine mantissa with exponent
              ror     a             ; shift in sign
              sta     3,s
              lda     1,s
              ror     a
              sta     1,s
              bcc     48$           ; no round if msb shifted out is 0
              lda     dp:.tiny(_Dp) ; any bit in bucket?
              bne     45$           ; yes, round up
              lda     1,s           ; check lsb of result
              lsr     a
              bcc     48$
45$:          lda     1,s           ; round up, increment
              inc     a
              sta     1,s
              bne     48$
              lda     3,s
              inc     a
              sta     3,s
48$:          pla                   ; x:c = result
              plx
49$:          ply
              ply
              return

50$:          lda     7,s           ; any bits sets in upper 16?
              beq     60$           ; no
              lda     1,s           ; yes, shift by 16
              sta     dp:.tiny(_Dp) ; lower go to bucket
              lda     3,s
              sta     1,s
              lda     5,s
              sta     3,s
              lda     7,s
              sta     5,s
              txa                   ; adjust exponent by 16
              clc
              adc     ##16
              tax
60$:          lda     5,s           ; single shift, check if done
              bne     62$           ; no
              lda     3,s
              cmp     ##0x0200
              bcc     40$           ; yes, we are done
              lda     5,s
62$:          lsr     a             ; right shift one step
              sta     5,s
              lda     3,s
              ror     a
              sta     3,s
              lda     1,s
              ror     a
              sta     1,s
              ror     dp:.tiny(_Dp) ; into bucket
              bcc     64$
              lda     dp:.tiny(_Dp) ; keep bit in bucket
              ora     ##1
              sta     dp:.tiny(_Dp)
64$:          inx                   ; adjust exponent
              bra     60$

;;; ***************************************************************************
;;;
;;; _Float32ToUInt64 - float to unsigned 64-bit integer conversion
;;; _Float32ToSInt64 - float to signed 64-bit integer conversion
;;;
;;; In: xc - floating point number
;;;     _Dp0-2 - pointer to integer result
;;;
;;; Out: _Dp0-2 - pointer to integer result (unchanged)
;;;
;;; Destroys: a, x, y, _Zp8-15
;;;
;;; ***************************************************************************

              .section libcode
              .public _Float32ToUInt64, _Float32ToSInt64
_Float32ToUInt64:
              call     floatToUInt64
              bcc     20$           ; positive
              lda     ##0
              ldy     ##6
10$:          sta     [.tiny _Dp],y ; negative, return 0
              dey
              dey
              bpl     10$
20$:          return

              .section libcode
_Float32ToSInt64:
              call    floatToUInt64
              ldy     ##6           ; overflowed?
              lda     [.tiny _Dp],y
              bmi     overflowToInt64
              bcc     20$           ; positive
              ldy     ##0           ; negative, negate result
              ldx     ##3
10$:          lda     ##0
              sbc     [.tiny _Dp],y
              sta     [.tiny _Dp],y
              iny
              iny
              dex
              bpl     10$
20$:          return

overflowToInt64:
              lda     ##0x8000      ; return 0x8000....
              sta     [.tiny _Dp],y
              asl     a             ; A = 0
10$:          dey
              dey
              sta     [.tiny _Dp],y
              bne     10$
              return

              .section libcode
floatToUInt64:
              sta     [.tiny _Dp]   ; unpack mantissa
              txa                   ; and save in result
              and     ##0x007f
              ora     ##0x0080
              ldy     ##2
              sta     [.tiny _Dp],y
              lda     ##0
              iny
              iny
              sta     [.tiny _Dp],y
              iny
              iny
              sta     [.tiny _Dp],y

              txa                   ; unpack exponent
              asl     a             ; CY= sign
              php
              xba
              and     ##0x00ff
              sec
              sbc     ##bias
              bcc     100$          ; too small, zero
              sbc     ##24
              bcs     30$           ; no right shift
              eor     ##0xffff
              beq     1$            ; done
              tax
25$:          ldy     ##6           ; right shift mantissa
              clc
27$:          lda     [.tiny _Dp],y
              ror     a
              sta     [.tiny _Dp],y
              dey
              dey
              bpl     27$
              dex
              bne     25$
1$:           plp
              return

30$:          cmp     ##8 + 32
              bcc     40$           ; not too large
              lda     ##0xffff      ; set all bits
              bra     110$

40$:          tax
45$:          lda     [.tiny _Dp]   ; left shift
              asl     a
              sta     [.tiny _Dp]
              ldy     ##2
              lda     [.tiny _Dp],y
              rol     a
              sta     [.tiny _Dp],y
              iny
              iny
              lda     [.tiny _Dp],y
              rol     a
              sta     [.tiny _Dp],y
              iny
              iny
              lda     [.tiny _Dp],y
              rol     a
              sta     [.tiny _Dp],y
              dex
              bpl     45$
              plp
              return

100$:         lda     ##0           ; zero result
110$:         ldy     ##6           ; set all bits to pattern in A
120$:         sta     [.tiny _Dp],y
              dey
              dey
              bpl     120$
              plp
              return

#ifndef __CALYPSI_TARGET_SYSTEM_FOENIX__
;;; ***************************************************************************
;;;
;;; _Float32Add - floating point addition
;;; _Float32Sub - floating point subtract
;;;
;;; In: xc - operand 1
;;;     _Dp[0:3] - operand 2
;;;
;;; Out: xc - result
;;;
;;; Destroys: y, _Dp[0:7]
;;;
;;; ***************************************************************************

              .section libcode
              .pubweak _Float32Add, _Float32Sub

_Float32Sub:  call    checkNaN2
              call    checkZero
              bne     10$

              ldy     dp:.tiny(_Dp+2) ; if op2 negative, force positive
              bpl     5$              ;   result sign
              ldx     ##0
5$:           return

10$:          tay
              lda     dp:.tiny(_Dp+2)  ; change sign of op2
              eor     ##0x8000
              sta     dp:.tiny(_Dp+2)
              tya
              bra     add10

_Float32Add:  call    checkNaN2
              call    checkZero
              bne     add10
              ldy     dp:.tiny(_Dp+2) ; of op2 is positive, force positive
              bne     10$
              tyx
10$:          return

add10:        call    unpack
                                    ; dp[4:5].1 = tentative result sign
                                    ; dp[4:5].0 = operation (1 = subtract)
              phx                   ; tos = op1 mantissa
              pha
              cmp     dp:.tiny(_Dp+0) ; check if op1 >= op2
              txa
              sbc     dp:.tiny(_Dp+2)
              tya
              sbc     dp:.tiny(_Dp+6)
              bcs     10$           ; yes

              lda     dp:.tiny(_Dp+2) ; no, swap operands
              sta     3,s
              stx     dp:.tiny(_Dp+2)

              pla
              ldx     dp:.tiny(_Dp+0)
              sta     dp:.tiny(_Dp+0)
              phx

              lda     dp:.tiny(_Dp+6)
              sty     dp:.tiny(_Dp+6)
              tay

              lda     dp:.tiny(_Dp+4) ; fix result sign
              asl     a
              eor     dp:.tiny(_Dp+4)
              sta     dp:.tiny(_Dp+4)

;;; We know op1 >= op2
10$:          pea     #0            ; clear bucket (used for rounding)

              cpy     ##0x00ff
              bne     12$
              jmp     long:addsubINF ; op1 INF

12$:          sec
              tya
              sbc     dp:.tiny(_Dp+6)
              beq     30$           ; exponents the same
              cmp     ##25
              bcs     addsubPack10  ; drowns
              tax
20$:          lsr     dp:.tiny(_Dp+2)
              ror     dp:.tiny(_Dp+0)
              lda     1,s           ; to bucket
              ror     a
              bcc     28$
              lsr     a
              sec                   ; keep sticky bit inside bucket
              asl     a
28$:          sta     1,s
              dex
              bne     20$

30$:          lsr     dp:.tiny(_Dp+4) ; select operation
              bcc     doadd

              lda     ##0
              sbc     1,s
              sta     1,s
              lda     3,s
              sbc     dp:.tiny(_Dp+0)
              sta     3,s
              lda     5,s
              sbc     dp:.tiny(_Dp+2)
              sta     5,s
              bit     ##0x0080
              bne     addsubRound
              tya                   ; subnormal input?
              beq     addsubSubnorm_relay ; yes

                                    ; normalize after subtract
              lda     3,s           ; check for 0
              ora     5,s
              bne     normalizeSub  ; non-zero
              tax
              ply
              ply
              ply
              return

normalizeSub: dey                   ; decrement exponent
addsubSubnorm_relay:
              beq     addsubSubnorm
              lda     1,s
              asl     a
              sta     1,s
              lda     3,s
              rol     a
              sta     3,s
              lda     5,s
              rol     a
              sta     5,s
              xba
              xba
              bpl     normalizeSub

addsubRound:  lda     3,s
              lsr     a
              lda     1,s
              adc     ##0x7fff
              bcc     addsubPack
              lda     3,s
              inc     a
              sta     3,s
              bne     addsubPack
              lda     5,s
              inc     a
              sta     5,s
              xba
              lsr     a
              bcc     addsubPack
              iny
addsubPack:   lda     5,s
              xba
              asl     a             ; make room (dropping implicit bit)
              ror     dp:.tiny(_Dp+4) ; sign to carry
              sty     dp:.tiny(_Dp+4)
              ora     dp:.tiny(_Dp+4) ; exponent to low byte
              xba                   ; eemm
              ror     a             ; shift in sign
              tax                   ; X= high half done
              pla                   ; drop bucket
              pla                   ; load low part
              ply                   ; drop old high mantissa
              return

addsubPack10: lsr     dp:.tiny(_Dp+4) ; drop operation bit
              bra     addsubPack

doadd:        lda     3,s
              adc     dp:.tiny(_Dp+0)
              sta     3,s
              lda     5,s
              adc     dp:.tiny(_Dp+2)
              sta     5,s
              bit     ##0x0100
              beq     addsubRound
              iny                   ; increment exponent
              lsr     a
              sta     5,s
              lda     3,s
              ror     a
              sta     3,s
              lda     1,s
              ror     a
              bcc     10$
              sec
              ror     a
              asl     a             ; keep bit in bucket
10$:          sta     1,s
              cpy     ##0x00ff
              bne     addsubRound

addsubOverflow:
              lda     ##0           ; overflow, clear mantissa
              sta     3,s
              sta     5,s
              beq     addsubPack

addsubSubnorm:
              lda     3,s
              ora     5,s
              bne     addsubPack    ; subnormal number (not zero)
              sta     dp:.tiny(_Dp+4) ; clear sign, underflow is positive
              bra     addsubPack    ; done, all bits are already 0

checkZero:    phx
              pha
              txa
              ora     dp:.tiny(_Dp+2)
              asl     a
              lsr     a
              ora     dp:.tiny(_Dp+0)
              ora     1,s
              tay
              pla
              plx
              iny                   ; set Z flag if both are zero
              dey
              return

addsubINF:    lda     dp:.tiny(_Dp+6) ; check exponent of op2
              cmp     ##0x00ff
              bne     addsubPack    ; not INF
              lsr     dp:.tiny(_Dp+4) ; are we doing subtract?
              bcc     addsubPack    ; no
                                    ; create a qNaN
                                    ;   0x400000
              lda     ##0
              sta     3,s
              lda     ##0x0040
              sta     5,s
              bra     addsubPack

;;; ***************************************************************************
;;;
;;; Handle NaN input for a binary operation.
;;;
;;; ***************************************************************************

              .section libcode
checkNaN2:    phx                   ; push operand 1
              pha
              txa
              and     ##0x7f80
              cmp     ##0x7f80
              bne     10$           ; operand 1 is not NaN (or infinity)
              txa                   ; test for infinity
              and     ##0x007f
              ora     1,s
              bne     90$           ; operand 1 is NaN
10$:          lda     dp:.tiny (_Dp+2)
              tax
              and     ##0x7f80
              cmp     ##0x7f80
              bne     rts10         ; operand 2 is not NaN (or infinity)
              txa
              and     ##0x007f      ; test for infinity
              ora     dp:.tiny (_Dp+0)
              beq     rts10         ; operand 2 in infinity
              txa                   ; operand 2 is NaN, move it to op1
              sta     3,s
              lda     dp:.tiny (_Dp+0)
              sta     1,s
90$:          ply
              pla
              ora     ##0x40        ; make it qNaN
              tax
              tya
#ifdef __CALYPSI_CODE_MODEL_SMALL__
              ply                   ; drop top return address
#else
              php
              ply
              ply
#endif
              return

rts10:        pla
              plx
              return

;;; ***************************************************************************
;;;
;;; unpack - unpack two floating point numbers
;;;
;;; In: xc - op1
;;;     dp[0:3] - op2
;;;
;;; Out: y - exponent op1
;;;      dp[6:7]= exponent op2
;;;      xc - mantissa of op1
;;;      dp[0:3] - mantissa of op2
;;;      dp[4:5].0 - operation (1 = subtract)
;;;      dp[4:5].1 - sign of op1
;;;
;;; ***************************************************************************

              .section libcode
unpack:       phx
              pha
              txa
              asl     a
              rol     dp:.tiny (_Dp+4) ; sign of op1 to _Dp4.0
              xba
              pha
              and     ##0x00ff
              tay                   ; Y= exponent op1

              lda     dp:.tiny (_Dp+2)
              asl     a
              xba
              pha
              and     ##0x00ff
              sta     dp:.tiny (_Dp+6) ; _Dp+6= exponent op2
              rol     a             ; sign of op2 to A.0
              eor     dp:.tiny (_Dp+4)
              lsr     a
              rol     dp:.tiny (_Dp+4) ; _Dp4.1 = sign of op1
                                       ; _Dp4.0 = operation (1 = subtract)

                                    ; set implicit 1 for normal numbers, and
                                    ; implicit 0 for subnormal numbers
                                    ; also realign mantissas
              lda     dp:.tiny (_Dp+6)
              cmp     ##1
              pla
              and     ##0xff00
              ror     a
              xba
              sta     dp:.tiny (_Dp+2)

              cpy     ##1
              pla
              and     ##0xff00
              ror     a
              xba
              sta     3,s
              pla
              plx
              return

;;; ***************************************************************************
;;;
;;; _Float32Mul - floating point multiply
;;;
;;; In: xc - operand 1
;;;     _Dp[0:3] - operand 2
;;;
;;; Out: xc - result
;;;
;;; Destroys: y, _Dp[0:7]
;;;
;;; ***************************************************************************

              .section libcode
              .pubweak _Float32Mul
mulINFop2:    sty     dp:.tiny(_Dp+6) ; swap operands
              tay

              lda     dp:.tiny(_Dp+2)
              sta     3,s
              stx     dp:.tiny(_Dp+2)

              plx
              pei     dp:.tiny(_Dp+0)
              stx     dp:.tiny(_Dp+0)

mulINFop1:    lda     dp:.tiny(_Dp+6) ; check if op2 is zero
              ora     1,s
              ora     3,s
              bne     mulPack10     ; not zero, use INF
              lda     ##0x0040      ; INF * zero gives qNaN 0x400000
              sta     3,s
mulPack10:    brl     mulPack

_Float32Mul:  call    checkNaN2
              call    unpack
              phx                   ; push op1 mantissa
              pha

              cpy     ##0x00ff      ; check if op1 is INF
              beq     mulINFop1     ; yes
              lda     dp:.tiny(_Dp+6) ; check if op2 is INF
              cmp     ##0x00ff
              beq     mulINFop2     ; yes
              ldx     ##0           ; see if we have any subnormal operand,
                                    ; exponent needs adjustment in that case
              phx                   ; result to be, 6 bytes
              phx
              phx
              inc     a
              dec     a
              bne     2$
              inx
2$:           tya
              bne     4$
              inx
4$:           phx

              pei     dp:.tiny(_Dp+4) ; A.0 = result sign

              stz     dp:.tiny(_Dp+4) ; extend op1 to 6 bytes
;;; Stack looks like this:
;;;    op1 middle                   13,s
;;;    op1 low                      11,s
;;;    result high                   9,s
;;;    result middle                 7,s
;;;    result low                    5,s
;;;    adjustment for subnormal      3,s
;;;    sign                          1,s
;;;
;;;    op1 high                      _Dp+4
;;; Op2 is in _Dp[0-3]

              ldx     ##23          ; bit counter
20$:          lsr     dp:.tiny(_Dp+2) ; op2 >>= 1
              ror     dp:.tiny(_Dp+0)
              bcc     30$
              clc                   ; add to result
              lda     5,s
              adc     11,s
              sta     5,s
              lda     7,s
              adc     13,s
              sta     7,s
              lda     9,s
              adc     dp:.tiny(_Dp+4)
              sta     9,s

30$:          lda     11,s          ; op1 <<= 1
              asl     a
              sta     11,s
              lda     13,s
              rol     a
              sta     13,s
              rol     dp:.tiny(_Dp+4)

              dex
              bpl     20$

40$:          tya                   ; calculate exponent
              sec
              adc     3,s
              adc     dp:.tiny(_Dp+6)
              sbc     ##bias-1
              tay
              plx                   ; sign
              pla                   ; drop adjustment for subnormal
              pla
              sta     dp:.tiny(_Dp+4) ; low bits result
              pla
              sta     dp:.tiny(_Dp+0) ; middle bit result
              pla
              sta     dp:.tiny(_Dp+2) ; upper bits result
              pla                   ; drop op1
              pla
              tya
              bpl     50$           ; positive exponent
              cpy     ##-23
              bcc     mulUnderflow ; this is way too small
45$:          dey                   ; need one extra shift of mantissa as
                                    ; subnormal number
46$:          lsr     dp:.tiny(_Dp+2) ; shift subnormal result
              ror     dp:.tiny(_Dp+0)
              ror     dp:.tiny(_Dp+4)
              bcc     49$
              lsr     dp:.tiny(_Dp+4) ; sticky bit
              sec
              rol     dp:.tiny(_Dp+4)

49$:          iny
              bne     46$

              lda     dp:.tiny(_Dp+0) ; exponent zero, done shifting
              ora     dp:.tiny(_Dp+2) ; result mantissa is zero?
              bne     mulRound      ; non-zero
              bra     mulPack       ; zero

50$:          beq     45$           ; exponent zero, subnormal
              cpy     ##0x100       ; test for overflow, we can at most
                                    ; reduce it by one, so 0x100 and above
                                    ; means overflow
              bcs     mulOverflow
55$:          bit     dp:.tiny(_Dp+2)
              bmi     mulNorm       ; already normalized
              asl     dp:.tiny(_Dp+4) ; left shift to normalize
              rol     dp:.tiny(_Dp+0)
              rol     dp:.tiny(_Dp+2)
              dey                   ; adjust exponent
              bne     55$
              beq     45$           ; subnormal

mulUnderflow: stz     dp:.tiny(_Dp+0)
              stz     dp:.tiny(_Dp+2)
              ldy     ##0
              bra     mulPack

mulOverflow:  ldy     ##0x00ff
              stz     dp:.tiny(_Dp+2)
              stz     dp:.tiny(_Dp+0)
              bra     mulPack

mulNorm:      cpy     ##0xff        ; check for overflow
              bcs     mulOverflow
mulRound:     lda     dp:.tiny(_Dp+4) ; align mantissa by right shift 8
              pha
              xba
              and     ##0xff
              sta     dp:.tiny(_Dp+4)
              pla
              beq     2$
              lsr     dp:.tiny(_Dp+4)
              sec
              rol     dp:.tiny(_Dp+4)
2$:           lda     dp:.tiny(_Dp+0)
              xba
              pha
              and     ##0xff00
              ora     dp:.tiny(_Dp+4)
              sta     dp:.tiny(_Dp+4)
              pla
              and     ##0xff
              sta     dp:.tiny(_Dp+0)
              lda     dp:.tiny(_Dp+2)
              xba
              pha
              and     ##0xff00
              ora     dp:.tiny(_Dp+0)
              sta     dp:.tiny(_Dp+0)
              pla
              and     ##0xff
              sta     dp:.tiny(_Dp+2)
              lda     dp:.tiny(_Dp+4)
              asl     a
              bcc     mulPack
              bne     10$           ; round up
              lda     dp:.tiny(_Dp+0); 0.5, check lowest bit in mantissa
              lsr     a
              bcc     mulPack
10$:          inc     dp:.tiny(_Dp+0) ; round up
              bne     mulPack
              inc     dp:.tiny(_Dp+2)
              lda     dp:.tiny(_Dp+2) ; overflowed?
              xba
              lsr     a
              bcc     mulPack       ; no
              iny                   ; yes, increment exponent too

mulPack:      lda     dp:.tiny(_Dp+2)
              xba
              asl     a             ; make room and drop implicit bit
              phy
              ora     1,s           ; combine with exponent
              xba
              tay
              txa
              lsr     a             ; carry = sign
              tya
              ror     a
              tax
              lda     dp:.tiny(_Dp+0)
              ply
              return

;;; ***************************************************************************
;;;
;;; _Float32Div - floating point divide
;;;
;;; In: xc - operand 1
;;;     _Dp[0:3] - operand 2
;;;
;;; Out: xc - result
;;;
;;; Destroys: y, _Dp[0:7]
;;;
;;; ***************************************************************************

              .section libcode
              .pubweak _Float32Div

divINFop1:    cmp     ##0x00ff      ; is op2 INF?
              bne     divPack10     ; no, return INF (already in op1)
divNaN:       lda     ##0x0040      ; qNan 0x400000 mantissa
              sta     5,s
              lda     ##0
              sta     3,s
divINFop2:
divPack10:    ldy     ##0xff        ; exponent = ff
divPack20:    lda     5,s           ; pack floating point
              xba
              asl     a
              phy
              ora     1,s
              xba
              tay
              pla
              pla                   ; A.0= sign
              lsr     a
              tya
              ror     a
              tax
              pla
              ply
              return

op2Zero:      tya                   ; check if op1 is 0
              ora     3,s
              ora     5,s
              beq     divNaN        ; yes, NaN
              lda     ##0
              sta     5,s           ; infinite result
              sta     3,s
              bra     divPack10

_Float32Div:  call    checkNaN2
              call    unpack
              phx                   ; push op1 mantissa on stack
              pha
              pei     dp:.tiny(_Dp+4) ; A.0 = result sign
              lda     dp:.tiny(_Dp+6) ; A= exponent of op2

              cpy     ##0x00ff      ; check if op1 is INF
              beq     divINFop1     ; yes
              cmp     ##0x00ff      ; op2 is INF?
              beq     divINFop2     ; yes


              ora     dp:.tiny(_Dp+0) ; check if op2 is 0
              ora     dp:.tiny(_Dp+2)
              beq     op2Zero       ; yes

              tya                   ; check if op1 is 0
              ora     3,s
              ora     5,s
              beq     divPack20     ; yes

              sec
              tya                   ; calculate exponent
              sbc     dp:.tiny(_Dp+6)
              clc
              adc     ##bias
              tay

              lda     5,s           ; is op1 normalized with msb set?
              xba
              xba
              bmi     20$           ; yes
              bpl     16$
10$:          dey                   ; adjust exponent for subnormal
16$:          lda     3,s           ; left shift
              asl     a
              sta     3,s
              lda     5,s
              rol     a
              sta     5,s
              xba
              xba
              bpl     10$

20$:          lda     ##0x80        ; is op2 normalized with msb set?
              bit     dp:.tiny(_Dp+2)
              bne     30$           ; yes
              beq     27$
25$:          iny
27$:          asl     dp:.tiny(_Dp+0) ; left shift op2
              rol     dp:.tiny(_Dp+2)
              bit     dp:.tiny(_Dp+2)
              beq     25$

30$:          pei     dp:.tiny(_Dp+2) ; push op2
              pei     dp:.tiny(_Dp+0)

                                    ; op1/reminder to _Dp[4-6]
              sec                   ; rem -= op2
              lda     7,s
              sbc     1,s
              sta     dp:.tiny(_Dp+4)
              lda     9,s
              sbc     3,s
              sta     dp:.tiny(_Dp+6)
              bcs     40$
                                    ; normalize start value
              dey                   ; decrement exponent
              asl     dp:.tiny(_Dp+4) ; rem <<= 1
              rol     dp:.tiny(_Dp+6)

              clc                   ; rem += op2
              lda     dp:.tiny(_Dp+4)
              adc     1,s
              sta     dp:.tiny(_Dp+4)
              lda     dp:.tiny(_Dp+6)
              adc     3,s
              sta     dp:.tiny(_Dp+6)

40$:          lda     ##0x0201       ; loop termination bit and implicit 1
              sta     dp:.tiny(_Dp+0)
              stz     dp:.tiny(_Dp+2)

50$:                                ; main loop
              asl     dp:.tiny(_Dp+4) ; rem <<= 1
              rol     dp:.tiny(_Dp+6)

              sec                   ; try rem -= op2
              lda     dp:.tiny(_Dp+4)
              sbc     1,s
              tax
              lda     dp:.tiny(_Dp+6)
              sbc     3,s
              bcc     54$           ; no
              sta     dp:.tiny(_Dp+6) ; success
              stx     dp:.tiny(_Dp+4)

54$:          rol     dp:.tiny(_Dp+0) ; rotate in result bit
              rol     dp:.tiny(_Dp+2)
              bcc     50$

              asl     dp:.tiny(_Dp+4) ; rem <<= 1
              rol     dp:.tiny(_Dp+6)

              sec                   ;   get bits for rounding
              lda     dp:.tiny(_Dp+4)
              sbc     1,s
              sta     1,s
              lda     dp:.tiny(_Dp+6)
              sbc     3,s
              bcc     80$           ; no guard bit, no round up
              ora     1,s
              bne     70$           ; sticky bit, round up
              lda     dp:.tiny(_Dp+0)
              ror     a             ; last bit to carry
              bcc     80$           ; even, no round up
70$:          inc     dp:.tiny(_Dp+0) ; round up
              bne     80$
              inc     dp:.tiny(_Dp+2)
              lda     ##0x0100
              bit     dp:.tiny(_Dp+2)
              beq     80$
              iny                   ; increment exponent
              lsr     dp:.tiny(_Dp+2) ; realign mantissa
              ror     dp:.tiny(_Dp+0)

80$:          tya
              bpl     90$
              cpy     ##-23         ; subnormal
              bcc     underflow
81$:          dey                   ; one step extra due to leading 0 (subnormal)
              lda     ##0
82$:          lsr     dp:.tiny(_Dp+2)
              ror     dp:.tiny(_Dp+0)
              ror     a             ; into bit for rounding
              bcc     83$
              ora     ##1           ; keep sticky bit
83$:          iny
              bne     82$
              asl     a
              bcc     pack          ; no rounding
              beq     88$           ; 0.5, round if odd
85$:          inc     dp:.tiny(_Dp+0) ; round up
              bne     pack
              inc     dp:.tiny(_Dp+2)
              lda     dp:.tiny(_Dp+2) ; overflowed?
              xba
              lsr     a
              bcc     pack          ; no
              iny                   ; yes, increment exponent too
              bra     pack

88$:          lda     dp:.tiny(_Dp+0)
              lsr     a
              bcc     pack
              bcs     85$           ; round up

90$:                                ; no subnormal
              tya
              beq     81$           ; 00 exponent, needs mantissa shift
              cpy     ##255
              bcc     pack

overflow:     ldy     ##255
              bra     clear
underflow:    ldy     ##0
clear:        stz     dp:.tiny(_Dp+0)
              stz     dp:.tiny(_Dp+2)

pack:         lda     dp:.tiny(_Dp+2)
              xba
              asl     a             ; shift out implicit bit
              phy
              ora     1,s           ; combine with exponent
              xba
              tax
              pla                   ; drop temp exponent
              pla                   ; drop op2
              pla
              pla                   ; get sign
              lsr     a             ; sign to carry
              txa
              ror     a             ; sign to upper part, realign
              tax                   ; X= upper part of result
              lda     dp:.tiny(_Dp+0) ; A= lower part of result
              ply                   ; drop op1
              ply
              return

#else    // __CALYPSI_TARGET_SYSTEM_FOENIX__
status:       .equ    0xafe200
input1:       .equ    0xafe208
input2:       .equ    0xafe20c
output:       .equ    input1

;;; ***************************************************************************
;;;
;;; _Float32Add - floating point addition
;;; _Float32Sub - floating point subtract
;;; _Float32Mul - floating point multiply
;;; _Float32Div - floating point divide
;;;
;;; In: xc - first operand
;;;     _Dp[0:3] - second operand
;;;
;;; Out: xc - result
;;;
;;; Destroys: y
;;;
;;; ***************************************************************************

              .section libcode
              .pubweak _Float32Add, _Float32Sub, _Float32Mul, _Float32Div

_Float32Add:  ldy     ##0x0248
              bra     foenixOperate

_Float32Sub:  ldy     ##0x0240
              bra     foenixOperate

_Float32Mul:  ldy     ##0x0040
              bra     foenixOperate

_Float32Div:  ldy     ##0x0140

foenixOperate:
              pha
              tya
              php
              sei
              sta     long:status
              lda     2,s           ; first input
              sta     long:input1
              txa
              sta     long:input1+2
              lda     dp:.tiny(_Dp+0) ; second input
              sta     long:input2
              lda     dp:.tiny(_Dp+2)
              sta     long:input2+2
              nop                   ; give it some time
              lda     long:output+2 ; collect the result
              tax
              lda     long:output+0
              plp
              ply
              return
#endif  // __CALYPSI_TARGET_SYSTEM_FOENIX__
