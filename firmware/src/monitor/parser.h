#pragma once

#include "types.h"

extern token_t token_type;
extern char __near *token_ptr;
extern unsigned int token_index;
extern unsigned int token_len;

extern void parse_error(const unsigned char __far *);
extern unsigned char token_to_uint8(void);
extern unsigned int token_to_uint16(void);
extern unsigned int read_line(void);
extern void reset_scanner(void);
extern void put_token(void);
extern token_t get_token(void);
extern int parse_address(mem_addr_t *);
extern int parse_range(mem_addr_t *, mem_addr_t *);
