; *******************************
; *  JRC-1 65816 SBC Firmware   *
; * (C) 2021 Joshua M. Thompson *
; *******************************

                .rtmodel        cstartup,"jrcos"

                .extern         os_start
                .extern         _DirectPageStart, _NearBaseAddress
                .extern         _Dp, _Vfp
                .extern         __initialize_sections
                .extern         __heap_initialize, __default_heap
                .extern         via_init,uart_init,spi_init
                .extern         getc_seriala,putc_seriala

                .global         sysreset
                .global         __call_heap_initialize
                .global         __data_initialization_needed

                .section        stack
                .section        heap
                .section        directPage
                .section        data_init_table

                .section        bootcode

sysreset:       sei
                clc
                xce
                rep             #0x38

                lda             ##_DirectPageStart
                tcd
                lda             ##.sectionEnd stack
                tcs
                stz            dp:.tiny(_Vfp+2)

                ; Do hardware init in 8-bit mode with DB in bank $00
                pea             #0
                plb
                plb
                sep             #0x30

                jsr             via_init
                jsr             uart_init
                jsr             spi_init

                lda             #.byte2 _NearBaseAddress
                pha
                plb
                rep             #0x30

__data_initialization_needed:
                lda             ##.word2 (.sectionEnd data_init_table)
                sta             dp:.tiny(_Dp+6)
                lda             ##.word0 (.sectionEnd data_init_table)
                sta             dp:.tiny(_Dp+4)
                lda             ##.word2 (.sectionStart data_init_table)
                sta             dp:.tiny(_Dp+2)
                lda             ##.word0 (.sectionStart data_init_table)
                sta             dp:.tiny(_Dp+0)
                jsl             long:__initialize_sections

__call_heap_initialize:
                lda             ##.word2 (.sectionStart heap)
                sta             dp:.tiny(_Dp+6)
                lda             ##.word0 (.sectionStart heap)
                sta             dp:.tiny(_Dp+4)
                lda             ##.word2 __default_heap
                sta             dp:.tiny(_Dp+2)
                lda             ##.word0 __default_heap
                sta             dp:.tiny(_Dp+0)
                ldx             ##.word2 (.sectionSize heap)
                lda             ##.word0 (.sectionSize heap)
                jsl             long:__heap_initialize

                cli
                jmp             long:os_start
