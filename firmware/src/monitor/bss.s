;;
; System monitor data locations
;

        .export     arg, ibuff, IBUFFSZ
        .export     opcode, am, len
        .export     a_reg,b_reg,d_reg,p_reg,s_reg,x_reg,y_reg,pc_reg,k_reg,mwidth,xwidth

IBUFFSZ := 256

        .segment "BSS"

arg:        .res    4
operand:    .res    4
opcode:     .res    1
am:         .res    1
len:        .res    1

a_reg:      .res    2
b_reg:      .res    1
d_reg:      .res    2
p_reg:      .res    1
s_reg:      .res    2
x_reg:      .res    2
y_reg:      .res    2
pc_reg:     .res    2
k_reg:      .res    1
mwidth:     .res    1
xwidth:     .res    1


        .align  256
ibuff:  .res    IBUFFSZ
