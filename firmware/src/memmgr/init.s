; *******************************
; *  JRC-1 65816 SBC Firmware   *
; * (C) 2022 Joshua M. Thompson *
; *******************************

        .include "common.inc"
        .include "memory.inc"

        .export   mm_init

        .import   mm_active_list
        .import   mm_alloc_size
        .import   mm_in_alloc
        .import   mm_inactive_list
        .import   mm_last_bank
        .import   mm_num_inactive
        .import   mm_low_water_mark
        .import   mm_free_list

        .import   mm_add_to_free
        .import   mm_alloc_handle
        .import   mm_create_handle_list

        .import __BANK0RAM_SIZE__
        .import __USERRAM_START__
        .import __USERRAM_SIZE__

        .segment "SYSDATA"

        .segment "OSROM"

;;
; Initialize the memory manager
;
mm_init:
        ; Set highest installed bank number
        ldaw    #.BANKBYTE(__USERRAM_START__ + __USERRAM_SIZE__ - 1)
        sta     mm_last_bank

        ; Init allocation parameters to default values
        ldaw    #MM_ALLOC_SIZE_DEFAULT
        sta     mm_alloc_size
        ldaw    #MM_LOW_WATER_MARK_DEFAULT
        sta     mm_low_water_mark

        ; Initialize empty active and free lists
        stz     mm_active_list
        stz     mm_active_list + 2
        stz     mm_free_list
        stz     mm_free_list + 2
        
        ; not currently allocating
        stz     mm_in_alloc

        ; Build the inactive list by manually allocating the first chunk
        ; of handles.
        pea     0
        pea     0                       ; no current list head
        ldaw    #.hiword(__USERRAM_START__)
        sta     mm_inactive_list + 2
        pha
        ldaw    #.loword(__USERRAM_START__)
        sta     mm_inactive_list
        pha
        ldaw    #MM_ALLOC_SIZE_DEFAULT
        sta     mm_num_inactive
        pha
        jsr     mm_create_handle_list

        ; Now we need to build the free list. There will be two initially:
        ; one at the bottom of bank $00, and one immediately following the
        ; inactive handle list we just created.

        ; Build free space handle for bank 0
        pha                     ; space for handle
        pha
        pea     0               ; start address (hi)
        pea     0               ; start address (lo)
        pea     .hiword(__BANK0RAM_SIZE__)  ; size (hi)
        pea     .loword(__BANK0RAM_SIZE__)  ; size(lo)
        pea     MM_OWNER_SYSTEM ; owner id
        jsr     mm_alloc_handle ; allocate handle
        jsr     mm_add_to_free  ; and add it to free list

        ; Build free space handle for the USERRAM segment
        pha                     ; space for handle
        pha
        pea     .hiword(__USERRAM_START__ + (MM_ALLOC_SIZE_DEFAULT*MM_HANDLE_SIZE)) ; start (hi)
        pea     .loword(__USERRAM_START__ + (MM_ALLOC_SIZE_DEFAULT*MM_HANDLE_SIZE)) ; start (lo)
        pea     .hiword(__USERRAM_SIZE__ - (MM_ALLOC_SIZE_DEFAULT*MM_HANDLE_SIZE))  ; size (hi)
        pea     .loword(__USERRAM_SIZE__ - (MM_ALLOC_SIZE_DEFAULT*MM_HANDLE_SIZE))  ; size (lo)
        pea     MM_OWNER_SYSTEM ; owner id
        jsr     mm_alloc_handle ; allocate handle
        jsr     mm_add_to_free  ; and add it to free list

        rtl
