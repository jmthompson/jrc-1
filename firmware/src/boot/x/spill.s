;;; ----------------------------------------------------------------------
;;;
;;; Spill handling support.
;;;
;;; ----------------------------------------------------------------------

              .rtmodel version, "1"
              .rtmodel cpu, "*"

#include "macros.h"

              .section registers, noinit ; use a static pointer for this
_FillInd:     .space  3

;;; ***************************************************************************
;;;
;;; _FillDP2 - fill a DP2 pseudo register
;;;
;;; Uses: 11 bytes of stack temporarily and sign and zero flags
;;;
;;; ***************************************************************************

              .public _FillDP2
              .section libcode
_FillDP2:     pha                   ; preserve A
              phy                   ; preserve Y
              lda     8,s           ; value to fill with
              tay                   ; Y= fill value for DP register
              php
              sep     #0x24         ; 8-bits data, disable interrupts
              lda     8,s           ; _FillInd = return address
              sta     dp:.tiny (_FillInd+2)
              sta     10,s          ; also move return address on stack
              rep     #0x20         ; 16-bits data
              lda     6,s
              inc     a             ; step ahead
              sta     dp:.tiny _FillInd
              sta     8,s
              lda     [.tiny _FillInd]
              plp                   ; restore original interrupt status
              and     ##0x00ff
              phx
              tax                   ; X= offset to location in direct page to fill
              sty     dp:0,x        ; restore pseudo register
              plx
              ply
              pla
              sta     1,s
              pla
              rtl

;;; ***************************************************************************
;;;
;;; _FillDP4 - fill a DP2 pseudo register
;;;
;;; Uses: 12 bytes of stack temporarily and sign and zero flags
;;;
;;; ***************************************************************************

              .public _FillDP4
              .section libcode
_FillDP4:     pha                   ; preserve registers
              phx                   ;
              phy
              lda     12,s
              pha                   ; push high part of fill
              lda     12,s          ; low value to fill with
              tay                   ; Y= low fill value for DP register
              php
              sep     #0x24         ; 8-bits data, disable interrupts
              lda     12,s          ; _FillInd = return address
              sta     dp:.tiny (_FillInd+2)
              rep     #0x20         ; 16-bits data
              lda     10,s
              inc     a             ; step ahead
              sta     dp:.tiny _FillInd
              sta     10,s
              lda     [.tiny _FillInd]
              plp                   ; restore original interrupt status
              and     ##0x00ff
              tax                   ; X= offset to location in direct page to fill
              sty     dp:0,x        ; restore pseudo register
              pla
              sta     dp:2,x
              lda     8,s           ; move return address
              sta     12,s
              lda     7,s
              sta     11,s
              ply
              plx
              pla
              sta     3,s
              pla
              pla
              rtl
