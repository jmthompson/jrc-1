;;
; ==============
; Device support
; ==============
;
; The jrcOS kernel supports character and block devices. The function
; register_device is used to register a device with the system:
;
;        pea  .hiword(device_name)
;        pea  .loword(device_name)
;        pea  MAJORID
;        pea  .hiword(ops)
;        pea  .loword(ops)
;        pea  .hiword(privatedata)
;        pea  .loword(privatedata)
;        jsr  register_device
;
; Where:
;
; device_name is a pointer to a null-terminated string naming the device.
; The name is used primarliy for displaying kernel messags about the
; device.
;
; MAJORID is the major device ID for this device. All minor numbers
; for this major are implicitly handled by this driver. The device ID
; must have bit 15 set if this is a block device.
;
; <ops> is a pointer to a FileOperations (for char devices) or
; BlockOperations (for block devices) table.
;
; <privatedata> is an optional pointer to a private data structure for
; use by the driver. It can be NULL.
;
; As with most kernel functions it returns with carry clear on success
; or carry set on error. On error an error code will also be returned
; in the accumulator.

        .global register_device, find_device
        .global bdev_open, bdev_release, bdev_rdblock, bdev_wrblock
        .global cdev_open, cdev_release, cdev_read, cdev_write 

;;
; Device IDs
;
DEVICE_ID_CONSOLE  = 1      ; char device #1
DEVICE_ID_SERIAL   = 2      ; char device #2
DEVICE_ID_SPI      = 3      ; char device #3
DEVICE_ID_USERPORT = 4      ; char device #4
DEVICE_ID_SDCARD   = $8001  ; block device #1

;;
; Device structure representing a device. A single linked list of Device
; structures is used to track all registered devices, both block and
; character.
;
.struct Device
        refcount      .word   ; number of references currently held to this device
        name          .dword  ; Pointer to name string
        major         .word   ; Major device ID
        ops           .dword  ; Pointer to operations table
        private       .dword  ; Pointer to private driver data
.endstruct

;;
; The BlockOperations structure is a table of pointers to functions that
; implement block device functions.
;
.struct BlockOperations
        open          .dword      ; Pointer to open function
        release       .dword      ; Pointer to release function
        rdblock       .dword      ; Pointer to rdblock function
        wrblock       .dword      ; Pointer to wrblock function
        ioctl         .dword      ; Pointer to ioctl function
        mediachanged  .dword      ; Pointer to mediachanged function
.endstruct

NUM_DEVICES := 8
