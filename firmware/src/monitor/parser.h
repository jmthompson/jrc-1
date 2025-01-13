#pragma once

#include "types.h"

typedef enum {
  TK_IDENTIFIER = -2, // internal use by parser
  TK_ANY = -1,
  TK_EOL,
  TK_CONST8,
  TK_CONST16,
  TK_CONST24,
  TK_STRING,
  TK_COMMAND,
  TK_MNEMONIC,
  TK_SREG,
  TK_XREG,
  TK_YREG,
  TK_PERIOD,
  TK_SLASH,
  TK_COLON,
  TK_POUND,
  TK_COMMA,
  TK_LPAREN,
  TK_RPAREN,
  TK_LBRACKET,
  TK_RBRACKET,
  TK_EQUALS,
  TK_EXCLAMATION
} token_t;

typedef enum {
  TH_NONE = 0,
  TK_NO_CONST = 1,
} token_hints_t;

extern token_t token_type;
extern char __near *token_ptr;
extern unsigned int token_index;
extern unsigned int token_len;
extern value_t token_value;

// Return -1 unless the current token is an 8-bit constant
static inline int is_int8(void) {
  return token_type == TK_CONST8? 0 : -1;
}

// Return -1 unless the current token is a 16-bit constant
static inline int is_int16(void) {
  return (token_type == TK_CONST8 || (token_type == TK_CONST16)) ? 0 : -1;
}

// Return -1 unless the current token is a 24-bit constant
static inline int is_int24(void) {
  return (token_type == TK_CONST8 || (token_type == TK_CONST16) || (token_type == TK_CONST24)) ? 0 : -1;
}

extern void parse_error(const unsigned char __far *);
extern unsigned int read_line(void);
extern char __near *reset_scanner(void);
extern void put_token(void);
extern token_t get_token(token_hints_t);
extern int parse_address(mem_addr_t *);
extern int parse_range(mem_addr_t *, mem_addr_t *);
