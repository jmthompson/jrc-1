#pragma once

#include <stddef.h>

// Make VSCode stop erroring on custom Calypsi type qualifiers
#ifdef __INTELLISENSE__
#define __tiny
#define __near
#define __far
#define __far24
#endif

typedef unsigned int mem_loc_t;
typedef unsigned int mem_bank_t;
typedef unsigned char __far *mem_ptr_t;

/**
 * This struct is used to represent memory addresses
 * entered by the user as part of a monitor command.
 */
typedef union {
  struct {
    mem_loc_t loc;
    mem_bank_t bank;
  };
  mem_ptr_t ptr;
} mem_addr_t;

typedef enum {
  TK_ERROR = -1,
  TK_EOL = 1,
  TK_LITERAL = 2,
  TK_STRING = 4,
  TK_IDENTIFIER = 8,
  TK_PERIOD = 16,
  TK_SLASH = 32,
  TK_COLON = 64,
  TK_POUND = 128,
  TK_COMMA = 256,
  TK_LPAREN = 512,
  TK_RPAREN = 1024,
  TK_EQUALS = 2048,
} token_t;
