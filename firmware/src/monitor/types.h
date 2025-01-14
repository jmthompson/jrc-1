#pragma once

#include <stddef.h>
#include <kernel/types.h>

typedef unsigned int mem_loc_t;
typedef unsigned int mem_bank_t;
typedef unsigned char __far *mem_ptr_t;

typedef union {
    unsigned char b[4];
    unsigned int w[2];
    unsigned long l;
} value_t;

typedef union {
  struct {
    mem_loc_t loc;
    mem_bank_t bank;
  };
  mem_ptr_t ptr;
} mem_addr_t;
