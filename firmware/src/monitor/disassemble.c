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
  switch (ptr[0]) {
  case 0xC2: // REP
    if (ptr[1] & PREG_M) m_width = 0;
    if (ptr[1] & PREG_X) x_width = 0;
    break;
  case 0xE2: // SEP
    if (ptr[1] & PREG_M) m_width = 1;
    if (ptr[1] & PREG_X) x_width = 1;
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
    kprintf("%02X", ptr[len]);
  }
}
static void print_immediate_operand(mem_ptr_t ptr, unsigned int len)
{
  putc_seriala('#');
  print_constant(ptr, len);
}

static mem_loc_t calculate_relative_target(mem_addr_t ptr, const operand_type_t type)
{
  mem_ptr_t operand_loc = ptr.ptr + 1;

  if (type == pcrl) {
    int offset = *((int *) operand_loc);
    return ptr.loc + offset + 3;
  } else {
    signed char offset = (signed char) *operand_loc;
    return ptr.loc + offset + 2;
  }
}

/**
 * Disassemble the instruction at the given address and return the number of byte disassembled.
 */
unsigned int print_instruction(mem_addr_t ptr, unsigned int m_width, unsigned int x_width)
{
  const unsigned char opcode_value = *ptr.ptr;
  const opcode_t *opcode = &opcodes[opcode_value];
  const operand_type_t am = opcode->operand_type;
  unsigned int len = opcode->size;

  if ((am == immediate_m) && (!m_width)) len++;
  if ((am == immediate_x) && (!x_width)) len++;

  kprintf("%02X/%04X  ", ptr.bank, ptr.loc);

  for (unsigned int i = 0; i < len; i++) {
    kprintf("%02X ", ptr.ptr[i]);
  }

  if (len < 4) print_spaces((4 - len) * 3);

  kprintf("%s   ", mnemonics[opcode->instr]);

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
  case pcrl:
    kprintf("%04X", calculate_relative_target(ptr, am));
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
  case srix:
    putc_seriala('(');
    print_constant(ptr.ptr, len);
    kprintf(",S),Y");
    putc_seriala('S');
    break;
  case blockmove:
    kprintf("%02X,%02X", ptr.ptr[1], ptr.ptr[2]);
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
    start_loc.loc += print_instruction(start_loc, m_width, x_width);
  }
}
