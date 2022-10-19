; *******************************
; *  JRC-1 65816 SBC Firmware   *
; * (C) 2022 Joshua M. Thompson *
; *******************************

        .export mm_active_list
        .export mm_alloc_size
        .export mm_free_list
        .export mm_in_alloc
        .export mm_inactive_list
        .export mm_last_bank
        .export mm_low_water_mark
        .export mm_num_inactive

        .segment "BSS"

; Highest available bank number
mm_last_bank:     .res    2

; Pointer to start of active hnadle list
mm_active_list:   .res    4

; Pointer to start of active hnadle list
mm_inactive_list: .res    4

; Pointer to start of free handle list
mm_free_list:     .res    4

; Number of inactive handles
mm_num_inactive:  .res    2

; How many new handles to allocate at once
mm_alloc_size:    .res    2

; Low water mark. When mm_num_inactive <= mm_low_water_mark
; we will allocate mm_alloc_size new handles
mm_low_water_mark:  .res    2

; Nonzero if we're currently allocating memory. Used to
; avoid unwanted recursion.
mm_in_alloc:      .res    2
