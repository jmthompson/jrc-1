#include "globals.h"
#include <ctype.h>
#include <kernel/console.h>
#include <stdio.h>

void dump_memory(void)
{
  while (start_loc.loc <= end_loc.loc) {
    mem_loc_t row_end = start_loc.loc | 0x0007;
    mem_loc_t row_start = start_loc.loc - 1;

    printf("%02x/%04X:", start_loc.bank, start_loc.loc);

    start_loc.loc = row_start;
    while ((start_loc.loc != row_end) && (start_loc.loc != end_loc.loc)) {
      printf(" %02X", *start_loc.ptr);
      ++start_loc.loc;
    }

    printf(" | ");

    start_loc.loc = row_start;
    while ((start_loc.loc != row_end) && (start_loc.loc != end_loc.loc)) {
      char c = *start_loc.ptr & 0x7F;

      if (!isprint(c)) c = '?';
      putc_seriala(c);

      ++start_loc.loc;
    }

    putc_seriala('\n');

    // Stop if we've rolled over to the start of the bank
    if (!++start_loc.loc) break;
  }
}
