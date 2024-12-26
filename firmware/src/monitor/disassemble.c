#include "globals.h"
#include "opcodes.h"
#include <kernel/console.h>
#include <stdio.h>
#include <stdlib.h>

#define PREG_M 0x20
#define PREG_X 0x10

/**
 * Update M/X widths based on current instruction
 */

static void update_mx(const mem_ptr_t ptr)
{
  opcode_t opcode = *ptr;

  switch (opcode) {
  case 0xC2: // REP
    if (ptr[1] & PREG_M) {
      m_width = 1;
    } else {
      m_width = 0;
    }
    break;
  case 0xE2: // SEP
    if (ptr[1] & PREG_X) {
      x_width = 1;
    } else {
      x_width = 0;
    }
    break;
  case 0xFB: // XCE
    m_width = x_width = 1;
    break;
  default:
    break;
  };
}

/**
 * Print out a string of spaces
 */
static void print_spaces(unsigned int count)
{
  while (count--) {
    putc_seriala(' ');
  }
}

static void print_constant(mem_ptr_t ptr, unsigned int len)
{
  while (--len) {
    printf("%02X", ptr[len]);
  }
}
static void print_immediate_operand(mem_ptr_t ptr, unsigned int len)
{
  putc_seriala('#');
  print_constant(ptr, len);
}

/**
 * Disassemble the instruction at the given address and return the number of byte disassembled.
 */
static unsigned int print_instruction(mem_addr_t ptr)
{
  opcode_t opcode = *ptr.ptr;
  instr_t instr = opcode_instr[opcode];
  operand_am_t am = opcode_am[opcode];
  unsigned int len = am_lengths[am];

  if ((am == immediate_m) && (!m_width)) len++;
  if ((am == immediate_x) && (!x_width)) len++;

  printf("%02X/%04X  ", ptr.bank, ptr.loc);

  for (unsigned int i = 0; i < len; i++) {
    printf("%02X ", ptr.ptr[i]);
  }

  if (len < 4) {
    print_spaces((4 - len) * 3);
  }

  printf("%s   ", instr_mnemonics[instr]);

  int offset;

  switch (am) {
  case immediate8:
  case immediate16:
    print_immediate_operand(ptr.ptr, len);
    break;
  case absolute:
  case al:
  case d:
    print_constant(ptr.ptr, len);
    break;
  case implied:
    break; // no operand
  case dix:
    putc_seriala('(');
    print_constant(ptr.ptr, len);
    putc_seriala(')');
    putc_seriala(',');
    putc_seriala('Y');
    break;
  case dixl:
    putc_seriala('[');
    print_constant(ptr.ptr, len);
    putc_seriala(']');
    putc_seriala(',');
    putc_seriala('Y');
    break;
  case axi:
  case dxi:
    putc_seriala('(');
    print_constant(ptr.ptr, len);
    putc_seriala(',');
    putc_seriala('X');
    putc_seriala(')');
    break;
  case axx:
  case alxx:
  case dxx:
    print_constant(ptr.ptr, len);
    putc_seriala(',');
    putc_seriala('X');
    break;
  case axy:
  case dxy:
    print_constant(ptr.ptr, len);
    putc_seriala(',');
    putc_seriala('Y');
    break;
  case pcr:
    offset = (int)ptr.ptr[1] + 2;
    printf("%04X", ptr.loc + offset);
    break;
  case pcrl:
    offset = *((int *)ptr.ptr + 1) + 2;
    printf("%04X", ptr.loc + offset);
    break;
  case ai:
  case di:
    putc_seriala('(');
    print_constant(ptr.ptr, len);
    putc_seriala(')');
    break;
  case dil:
    putc_seriala('[');
    print_constant(ptr.ptr, len);
    putc_seriala(']');
    break;
  case sr:
    print_constant(ptr.ptr, len);
    putc_seriala(',');
    putc_seriala('S');
    break;
  case arix:
    putc_seriala('(');
    print_constant(ptr.ptr, len);
    printf(",S),Y");
    putc_seriala('S');
    break;
  case blockmove:
    printf("%02X,%02X", ptr.ptr[1], ptr.ptr[2]);
    break;
  case immediate_m:
    print_immediate_operand(ptr.ptr, m_width ? 2 : 3);
    break;
  case immediate_x:
    print_immediate_operand(ptr.ptr, x_width ? 2 : 3);
    break;
  default:
    break;
  }

  putc_seriala('\n');

  return len;
}

void disassemble(void)
{
  unsigned int count = 20;

  while (count--) {
    update_mx(start_loc.ptr);
    start_loc.loc += print_instruction(start_loc);
  }
}
