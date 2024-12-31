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
  TK_ERROR1,
  TK_EOL,
  TK_LITERAL,
  TK_STRING,
  TK_IDENTIFIER,
  TK_PERIOD,
  TK_SLASH,
  TK_COLON,
  TK_POUND,
  TK_COMMA,
  TK_LPAREN,
  TK_RPAREN,
  TK_EQUALS,
  TK_EXCLAMATION
} token_t;
