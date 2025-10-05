
.struct IntStackFrame
        .org 1
        y_reg     .word
        x_reg     .word
        a_reg     .word
        d_reg     .word
        b_reg     .byte
        p_reg     .byte
        pc_reg    .word
        k_reg     .byte
        sc_params .byte
.endstruct

INT_STACK_FRAME_SIZE := IntStackFrame::k_reg
