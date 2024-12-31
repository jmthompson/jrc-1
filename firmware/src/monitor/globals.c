#include <stddef.h>
#include "types.h"

unsigned int a_reg = 0x0401;
unsigned int d_reg = 0x0402;
unsigned int s_reg = 0x0403;
unsigned int x_reg = 0x0404;
unsigned int y_reg = 0x0405;
unsigned int pc_reg = 0x0406;

unsigned char b_reg = 0x81;
unsigned char k_reg = 0x82;
unsigned char p_reg = 0x83;

unsigned int m_width = 1;
unsigned int x_width = 1;

mem_addr_t start_loc;
mem_addr_t end_loc;
