#include "globals.h"
#include "messages.h"
#include "parser.h"
#include <ctype.h>
#include <kernel/console.h>
#include <stdio.h>

void set_memory(void)
{
  token_t token;

  while (get_token(TH_NONE) != TK_EOL) {
    switch (token_type) {
    case TK_CONST8:
      *(start_loc.ptr)++ = token_value.b[0];
      break;
    case TK_STRING:
      ++token_ptr; // skip the single qutoe
      for (unsigned int i = 0; i < token_len; i++) {
        *(start_loc.ptr)++ = (unsigned char) *token_ptr++;
      }
      return;
    default:
      parse_error(UNEXPECTED_TOKEN);
      return;
    }
  }
}
