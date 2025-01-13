#include "globals.h"
#include "messages.h"
#include "parser.h"
#include <ctype.h>
#include <kernel/console.h>
#include <stdio.h>

void set_register(void)
{
  token_t token = get_token(TK_NO_CONST);

  if (token != TK_IDENTIFIER) {
    parse_error(UNEXPECTED_TOKEN);
    return;
  }
  if (token_len != 1) {
    parse_error(UNKNOWN_REGISTER);
    return;
  }

  unsigned char reg = *token_ptr;

  if (get_token(TH_NONE) != TK_EQUALS) {
    parse_error(UNEXPECTED_TOKEN);
    return;
  }

  get_token(TH_NONE);

  switch (reg) {
  case 'A':
    if (token == TK_CONST16)
      a_reg = token_value.w[0];
    else
      parse_error(UNEXPECTED_TOKEN);
    break;
  case 'B':
    if (token == TK_CONST8)
      b_reg = token_value.b[0];
    else
      parse_error(UNEXPECTED_TOKEN);
    break;
  case 'D':
    if (token == TK_CONST16)
      d_reg = token_value.w[0];
    else
      parse_error(UNEXPECTED_TOKEN);
    break;
  case 'P':
    if (token == TK_CONST8)
      p_reg = token_value.b[0];
    else
      parse_error(UNEXPECTED_TOKEN);
    break;
  case 'X':
    if (token == TK_CONST16)
      x_reg = token_value.w[0];
    else
      parse_error(UNEXPECTED_TOKEN);
    break;
  case 'Y':
    if (token == TK_CONST16)
      y_reg = token_value.w[0];
    else
      parse_error(UNEXPECTED_TOKEN);
    break;
  default:
    parse_error(UNKNOWN_REGISTER);
    break;
  }
}
