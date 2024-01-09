;;; ----------------------------------------------------------------------
;;;
;;; Low level control flow support.
;;;
;;; ----------------------------------------------------------------------

              .rtmodel version, "1"
              .rtmodel cpu, "*"

              .extern _Dp

#include "macros.h"

;;; ***************************************************************************
;;;
;;; _JmpInd - make a 16-bits indirect jump
;;;
;;; ***************************************************************************

              .public _JmpInd
              .section libcode
_JmpInd:      ldy     dp:.tiny (_Dp+8)
              dey
              phy
              rts

;;; ***************************************************************************
;;;
;;; _JmpIndLong - make a 24x-bits indirect jump
;;;
;;; ***************************************************************************

              .public _JmpIndLong
              .section libcode
_JmpIndLong:  tay                   ; preserve argument
              sep     #0x20         ; 8-bits data
              lda     dp:.tiny (_Dp+10)
              pha                   ; push bank
              rep     #0x20         ; 16-bits data
              lda     dp:.tiny (_Dp+8)
              dec     a
              pha
              tya
              rtl
