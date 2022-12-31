;;
; System monitor data locations
;

        .export     arg, ibuff, IBUFFSZ
        .export     instr, instr_len, operand, operand_size, operand_type, token
        .export     a_reg,b_reg,d_reg,p_reg,s_reg,x_reg,y_reg,pc_reg,k_reg,m_width,x_width

IBUFFSZ := 256

        .segment "BSS"

arg:        .res    4
instr:      .res    2
instr_len:  .res    2
operand:    .res    4
operand_type: .res    2
operand_size: .res    2
token:      .res    2
a_reg:      .res    2
b_reg:      .res    1
d_reg:      .res    2
p_reg:      .res    1
s_reg:      .res    2
x_reg:      .res    2
y_reg:      .res    2
pc_reg:     .res    2
k_reg:      .res    1
m_width:    .res    1
x_width:    .res    1


        .align  256
ibuff:  .res    IBUFFSZ
