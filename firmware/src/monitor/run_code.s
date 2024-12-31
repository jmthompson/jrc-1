        .extern a_reg,x_reg,y_reg,start_loc

        .section code

        .public run_code

run_code:
        phk
        pea     #.word0(ret$-1)
        sep     #0x20
        lda     .near (start_loc+2)
        pha
        rep     #0x20
        lda     .near start_loc
        dec     a
        pha
        lda     .near a_reg
        ldx     .near x_reg
        ldy     .near y_reg
        rtl
ret$:   rep     #0x30
        sta     .near a_reg
        stx     .near x_reg
        sty     .near y_reg
        rtl
