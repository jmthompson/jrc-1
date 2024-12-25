/**
 * This is a simple scanner/parser used by the monitor and the assembler. It supports a
 * limited set of token types: hexadecimal literals, identifiers, and string literals, plus a
 * few single-character tokens.
 */
#include "parser.h"
#include "globals.h"
#include <ctype.h>
#include <kernel/console.h>
#include <stdio.h>

token_t token_type;
char __near *token_ptr;
unsigned int token_len;
unsigned int token_index;

// Internal pointer to the input buffer; used to determine token starting offsets
static char __near *buffer;

// Internal pointer to current scanning position in the input buffer
static char __near *ibuffp;

/**
 * Reset the scanner to point to the start of a new input buffer.
 */
void reset_scanner(char __near *new_buffer) { buffer = ibuffp = new_buffer; }

/**
 * "Put back" the last token by Rewinding ibuffp back to token_ptr.
 */
void put_token(void) { ibuffp = token_ptr; }

/**
 * Scan an input buffer starting at ibuffp and determine the next token.
 *
 * If no valid token is found -1 will be returned. Otherwise, the token type
 * is returned, and the token information will be in token_type, token_ptr,
 * and token_len.
 */
token_t get_token(void)
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
  } else if (isxdigit(c)) {
    token_type = TK_LITERAL;
    token_len = 1;
  } else if (isalpha(c)) {
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
    } else if (c == '.') {
      token_type = TK_PERIOD;
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
    } else if ((token_type == TK_LITERAL) && (token_len <= 4) && isxdigit(c)) {
      token_len++;
    } else if ((token_type == TK_IDENTIFIER) && (token_len <= 255) && isalnum(c)) {
      token_len++;
    } else {
      break;
    }
    ++ibuffp;
  }

  return token_type;
}

/**
 * Display a syntax error message that includes the character position.
 */
void syntax_error(void) { printf("\nError at character position %d\n", ibuffp - buffer + 1); }

/**
 * Return the value of a TK_LITERAL token as a uint16.
 */
unsigned int token_to_uint16(void)
{
  unsigned int val = 0;
  unsigned int len = token_len;
  char __near *ptr = token_ptr;

  while (len--) {
    char c = *ptr++;

    // if alphanumeric, uppercase it
    if (c & 0x40) c &= ~0x20;

    val <<= 4;

    if ((c >= '0') && (c <= '9'))
      val += (c - '0');
    else
      val += (c - 'A' + 10);
  }

  return val;
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
  const unsigned int val = token_to_uint16();
  token_t token = get_token();

  if (token == TK_SLASH) {
    if (val > 255) return -1;
    addr->bank = val;

    token = get_token();

    // entering "XX/" can be used to just set the bank, but only at the end of the line.
    if (token == TK_EOL) return 0;
    // Otherwise the next token must be a literal
    if (token != TK_LITERAL) return -1;

    addr->loc = token_to_uint16();
  } else {
    put_token();
    addr->loc = val;
  }

  return 0;
}

int parse_range(mem_addr_t *start, mem_addr_t *end)
{
  if (parse_address(start)) return -1;

  end->ptr = start->ptr;

  token_t token = get_token();
  if (token == TK_EOL) {
    return 0;
  } else if (token == TK_PERIOD) {
    if ((get_token() != TK_LITERAL) || parse_address(end)) {
      return -1;
    }
  } else {
    put_token();
    return 0;
  }

  return 0;
}
