#include <ctype.h>
#include <stdio.h>
#include <kernel/console.h>
#include "globals.h"
#include "messages.h"
#include "parser.h"

void set_memory(void)
{
  token_t token;

  while ((token = get_token()) != TK_EOL) {
    if ((token == TK_LITERAL) && (token_len <= 2)) {
      *(start_loc.ptr) = token_to_uint8();
      ++start_loc.loc;
    } else if (token == TK_STRING) {
      for (unsigned int i = 1 ; i <= token_len ; i++) {
        *(start_loc.ptr) = token_ptr[i];
        ++start_loc.loc;
      }
    } else {
      parse_error(UNEXPECTED_TOKEN);
      break;
    }
  }
}
