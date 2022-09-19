;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Constants for locating the size of location of various linker segments ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

        .import __BIOS_DP_START__
        .import __BSS_START__
        .import __SYSSTACK_START__
        .import __SYSSTACK_SIZE__

IRQ_DB       = $00
OS_DB        = .bankbyte(__BSS_START__)
OS_DP        = __BIOS_DP_START__
OS_STACKTOP  = __SYSSTACK_START__ + __SYSSTACK_SIZE__ - 1
