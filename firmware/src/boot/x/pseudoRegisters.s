;;; ***************************************************************************
;;;
;;; Pseudo registers.
;;;
;;; This section has to be placed in the direct page (tiny memory).
;;;
;;; ***************************************************************************

              .section registers, noinit
              .public _Dp, _Vfp
_Dp:          .space  16            ; direct page registers
_Vfp:         .space  4             ; virtual frame pointer (for VLAs)
