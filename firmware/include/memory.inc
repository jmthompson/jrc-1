;;
; Size of a handle structure in bytes
;
MM_HANDLE_SIZE = 16

;;
; Default value for mm_alloc_size.
; 32 handles exactly fit in 512 bytes
;
MM_ALLOC_SIZE_DEFAULT = 32

;;
; Default value for mm_low_water_mark
;
MM_LOW_WATER_MARK_DEFAULT = 8

;;
; The smallest chunk of memory we will allocate and track
;
MM_MIN_ALLOCATION = 32

;;
; Ownwer ID for system-owned handles
;
MM_OWNER_SYSTEM = $0000

;;
; Handle structure
;
.struct Handle
        Start     .dword      ; Pointer to start of memory block
        Size      .dword      ; Size of memory block in bytes
        OwnerId   .word       ; ID of process that allocated this block
        reserved  .word       ; reserved
        Next      .dword      ; Pointer to next handle
.endstruct

;;
; Attributs word for allocation requests
; |---------------------------------------------------------------|
; | 1 | 1 | 1 | 1 | 1 | 1 |   |   |   |   |   |   |   |   |   |   |
; | 5 | 4 | 3 | 2 | 1 | 0 | 9 | 8 | 7 | 6 | 5 | 4 | 3 | 2 | 1 | 0 |
; |---------------------------------------------------------------|
;   |________________________________________|  ^   ^   ^   ^   ^
;                    Reserved                   |   |   |   |   |
;                                               |   |   |   |   |
; 1 = use bank $00, 0 = don't bank $00 ---------|   |   |   |   |
; 1 = cannot cross banks, 0 = can cross banks ------|   |   |   |
; 1 = cannot cross pages, 0 = can cross pages ----------|   |   |
; 1 = bank aligned, 0 = no bank align ----------------------|   |
; 1 = page aligned, 0 = no page align --------------------------|
;

MM_ATTR_BANK_ZERO   = $10
MM_ATTR_SINGLE_BANK = $08
MM_ATTR_SINGLE_PAGE = $04
MM_ATTR_BANK_ALIGN  = $02
MM_ATTR_PAGE_ALIGN  = $01
