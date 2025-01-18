/**
 * This is a simple scanner/parser used by the monitor and the assembler. It supports a
 * limited set of token types: hexadecimal literals, identifiers, and string literals, plus a
 * few single-character tokens.
 */
#include "parser.h"
#include "globals.h"
#include "types.h"
#include <calypsi/intrinsics65816.h>
#include <ctype.h>
#include <kernel/console.h>
#include <stdio.h>

SIMPLE_CALL int getc_seriala(void);
SIMPLE_CALL void putc_seriala(char character);

token_t token_type;
char __near *token_ptr;
unsigned int token_len;
unsigned int token_index;
value_t token_value;

// The input buffer
#define IBUFFSZ 256
static char __near input_buffer[IBUFFSZ];

// Internal pointer to current scanning position in the input buffer
#define IBUFFSZ 256
static char __near *ibuffp;

/**
 * Convert a constant token to its numeric equivalent.
 */
static void set_token_value(void)
{
  unsigned int len = token_len;
  char __near *ptr = token_ptr;
  char c;

  token_value.l = 0;

  for (unsigned int i = 0 ; i < token_len ; i++, ptr++) {
    c = *ptr;
    // if alphanumeric, uppercase it
    if (c & 0x40) c &= ~0x20;

    token_value.l <<= 4;

    if ((c >= '0') && (c <= '9'))
      token_value.l += (c - '0');
    else
      token_value.l += (c - 'A' + 10);
  }
}

/* Try to promote an identifier to SREG/XREG/YREG */
static void promote_single_char(void)
{
  switch (*token_ptr) {
  case 'S':
    token_type = TK_SREG;
    break;
  case 'X':
    token_type = TK_XREG;
    break;
  case 'Y':
    token_type = TK_YREG;
    break;
  default:
    token_type = TK_COMMAND;
    break;
  }
}

/**
 * Read a line of input to input_buffer. Input stops when ENTER
 * is received or the buffer fills.
 */
unsigned int read_line()
{
  size_t count = 0;
  char __near *pos = input_buffer;

  while (count < IBUFFSZ - 1) {
    int ch = getc_seriala();

    if (ch < 0) {
      __wait_for_interrupt();
    } else if ((ch == BS) && (count > 0)) {
      putc_seriala((char)ch);
      pos--;
      count--;
    } else if (ch == CR) {
      break;
    } else if (ch >= ' ') {
      *pos++ = (char)ch;
      putc_seriala((char)ch);
      count++;
    }
  }

  *pos = 0;

  return count;
}

/**
 * Reset the scanner to point to the start of the input buffer.
 * Returns a pointer to the start of the buffer.
 */
char __near *reset_scanner(void) { return ibuffp = input_buffer; }

/**
 * "Put back" the last token by rewinding ibuffp back to token_ptr.
 */
void put_token(void) { ibuffp = token_ptr; }

/**
 * Scan an input buffer starting at ibuffp and determine the next token.
 * If no valid token is found -1 will be returned. Otherwise, the token type
 * is returned, and the token information will be in token_type, token_ptr,
 * and token_len.
 *
 * The hints are a bitmask controlling certain behavior of the parser:
 *
 * TK_NO_CONST
 * Do not allow constants. Interpret them as identifiers instead. This
 * is useful if an expected identifier starts with valid hexadecimal chars,
 * such as 'BPL'.
 */
token_t get_token(token_hints_t hints)
{
  // skip any whitespace
  while (*ibuffp && isspace(*ibuffp)) {
    ++ibuffp;
  }

  token_ptr = ibuffp;
  token_len = 0;

  /*
   * Based on the first character at ibuffp, try to determine the
   * type of token we're dealing with.
   */

  char c = *ibuffp;

  if (!c) {
    token_type = TK_EOL;
    return TK_EOL;
  } else if (isxdigit(c) && !(hints & TK_NO_CONST)) {
    token_type = TK_CONST8;
    token_len = 1;
  } else if (isalpha(c)) {
    *ibuffp = toupper(c);
    token_type = TK_IDENTIFIER;
    token_len = 1;
  } else if (c == '\'') {
    token_type = TK_STRING;
  } else { // Single-character tokens
    if (c == '/') {
      token_type = TK_SLASH;
    } else if (c == ':') {
      token_type = TK_COLON;
    } else if (c == '#') {
      token_type = TK_POUND;
    } else if (c == ',') {
      token_type = TK_COMMA;
    } else if (c == '(') {
      token_type = TK_LPAREN;
    } else if (c == ')') {
      token_type = TK_RPAREN;
    } else if (c == '[') {
      token_type = TK_LBRACKET;
    } else if (c == ']') {
      token_type = TK_RBRACKET;
    } else if (c == '.') {
      token_type = TK_PERIOD;
    } else if (c == '=') {
      token_type = TK_EQUALS;
    } else if (c == '!') {
      token_type = TK_EXCLAMATION;
    } else {
      return -1;
    }

    ++ibuffp;
    token_len = 1;

    return token_type;
  }

  ++ibuffp;

  /* at this point we have a multi-character token, so loop through
   * the buffer until we hit something that isn't valid for the current
   * token type or the token maximum length is hit (255 chars for strings,
   * four digits for literals).
   */
  while ((c = *ibuffp)) {
    if (token_type == TK_STRING) {
      token_len++;
    } else if ((token_type == TK_IDENTIFIER) && (token_len < 255) && isalnum(c)) {
      *ibuffp = toupper(c);
      token_len++;
    } else if (isxdigit(c)) {
      if (token_type == TK_CONST8) {
        if (token_len == 2) token_type = TK_CONST16;
        token_len++;
      } else if (token_type == TK_CONST16) {
        if (token_len == 4) token_type = TK_CONST24;
        token_len++;
      } else if (token_type == TK_CONST24) {
        if (token_len == 6) break;
        token_len++;
      } else {
        break;
      }
    } else {
      break;
    }
    ++ibuffp;
  }

  switch (token_type) {
  case TK_CONST8:
  case TK_CONST16:
  case TK_CONST24:
    set_token_value();
    break;
  case TK_IDENTIFIER:
    if (token_len == 1)
      promote_single_char();
    else if (token_len == 3)
      token_type = TK_MNEMONIC;
    else
      token_type = -1;
    break;
  default:
    break;
  }

  return token_type;
}

/**
 * Display a syntax error message that includes the character position.
 */
void parse_error(const unsigned char __far *reason)
{
  kprintf("\nError at character position %d: %s\n", ibuffp - input_buffer + 1, reason);
}

/**
 * Parse a memory address and store the result in the given mem_addr_t struct.
 *
 * The following formats are valid addresses:
 *
 * BB/
 * BB/XXXX
 * XXXX
 *
 * Where BB and XXXX are literals of up to 2 and 4 digits, respectively.
 */
int parse_address(mem_addr_t *addr)
{
  const unsigned int first_value = token_value.w[0];
  token_t first_type = token_type;

  switch (get_token(TH_NONE)) {
  case TK_SLASH:
    if (first_type != TK_CONST8) return -1;
    addr->bank = first_value;

    switch (get_token(TH_NONE)) {
    case TK_EOL: // entering "XX/" can be used to just set the bank, but only at the end of the line.
      return 0;
    case TK_CONST8:
    case TK_CONST16:
      addr->loc = token_value.w[0];
      return 0;
    default:
      return -1;
    }
  default:
    addr->loc = first_value;
    put_token();
    return 0;
  }
}

int parse_range(mem_addr_t *start, mem_addr_t *end)
{
  if (parse_address(start)) return -1;
  end->ptr = start->ptr;

  switch (get_token(TH_NONE)) {
  case TK_EOL:
    return 0;
  case TK_PERIOD:
    switch (get_token(TH_NONE)) {
    case TK_CONST8:
    case TK_CONST16:
      end->loc = token_value.w[0];
      return 0;
    default:
      return -1;
    }
  default:
    put_token();
    return 0;
  }
}
