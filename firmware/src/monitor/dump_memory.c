#include "globals.h"
#include <ctype.h>
#include <kernel/console.h>
#include <stdio.h>

void dump_memory(void)
{
  while (1) {
    mem_loc_t row_end = start_loc.loc;
    mem_loc_t row_start = start_loc.loc;

    row_end |= 0x0007;
    if (end_loc.loc < row_end) row_end = end_loc.loc;
    ++row_end;

    kprintf("%02x/%04X:", start_loc.bank, start_loc.loc);

    while (start_loc.loc != row_end) {
      kprintf(" %02X", *start_loc.ptr);
      ++start_loc.loc;
    }

    kprintf(" | ");

    start_loc.loc = row_start;
    while (start_loc.loc != row_end) {
      char c = *start_loc.ptr & 0x7F;

      if (!isprint(c)) c = '?';
      putc_seriala(c);

      ++start_loc.loc;
    }

    putc_seriala('\n');

    if (end_loc.loc == (row_end - 1)) break;
  }
}
