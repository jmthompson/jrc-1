#pragma once

#include <stddef.h>

typedef unsigned int mem_loc_t;
typedef unsigned int mem_bank_t;
typedef unsigned char *mem_ptr_t;

/**
 * This struct is used to represent memory addresses
 * entered by the user as part of a monitor command.
 */
typedef union mem_addr_t {
    struct {
        mem_loc_t loc;
        mem_bank_t bank;
    };
    mem_ptr_t ptr;
};

extern unsigned int a_reg;
extern unsigned int d_reg;
extern unsigned int s_reg;
extern unsigned int x_reg;
extern unsigned int y_reg;
extern unsigned int pc_reg;
extern unsigned char b_reg;
extern unsigned char k_reg;
extern unsigned char p_reg;
extern unsigned int m_width;
extern unsigned int x_width;

extern mem_addr_t start_loc;
extern mem_addr_t end_loc;
