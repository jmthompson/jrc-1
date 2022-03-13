;;
; BIOS bdevice support
;

;;
; Enter a device driver. Currently no-op but may change in the future.
;
.macro  DRVR_ENTER
.endmacro

;;
; Exit a device driver.
;
.macro  DRVR_EXIT
        rtl
.endmacro
;;
; Exit a device driver with no error. Must be called in 16-bit mode.
;
.macro  DRVR_SUCCESS
        ldaw    #0
        clc
        DRVR_EXIT
.endmacro

;;
; Get the private data pointer and store it in the given location
;
.macro  DRVR_PRIVATE    loc
        lda     4,s
        sta     loc
        lda     6,s
        sta     loc+2
.endmacro

;;
; Get the parameters pointer and store it in the given location
;
.macro  DRVR_PARAMS loc
        lda     8,s
        sta     loc
        lda     10,s
        sta     loc+2
.endmacro

;;
; Exit a device driver with an error code. Must be called in 16-bit mode.
;
.macro  DRVR_ERROR    code
.ifnblank code
        ldaw    #code
.endif
        sec
        DRVR_EXIT
.endmacro

;;
; Register a driver via the DM internal interface
;
.macro  REGISTER_DEVICE device
        pea     .hiword(device)
        pea     .loword(device)
        jsr     dm_register_internal
.endmacro

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Device driver structure:
;
; +0:  [2] Device driver version, currently $0000
; +2:  [2] Device flags
;       bit 15: 0 = char, 1 = block
;       bite 0: 0 = offline, 1 = online
; +4:  [4] Pointer to device name
; +8:  [4] Pointer to device private data (may be null)
; +12: [2] Number of functions
; +14: [4 x n] Function pointers, four bytes per function
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Maximum number of devices
MAX_DEVICES  = 16

; Device feature flags
DEVICE_TYPE_BLOCK = $0000   ; Block device
DEVICE_TYPE_CHAR  = $8000   ; Character device

; device status flags
DEVICE_ONLINE   = $0001 ; device is online if set

; Generic device driver function numbers
DEV_STARTUP     = 0
DEV_SHUITDOWN   = 1
DEV_STATUS      = 2

; Block device funcctions
DEV_MOUNT   = 3
DEV_EJECT   = 4
DEV_FORMAT  = 5
DEV_RDBLOCK = 6
DEV_WRBLOCK = 7

; Character device functions
DEV_OPEN        = 3
DEV_CLOSE       = 4
DEV_READ_BYTE   = 5
DEV_READ_BYTES  = 6
DEV_WRITE_BYTE  = 7
DEV_WRITE_BYTES = 8
DEV_GET_MODE    = 9
DEV_SET_MODE    = 10
