#include <stdio.h>
#include <ctype.h>
#include <kernel/console.h>
#include "globals.h"
#include "messages.h"
#include "opcodes.h"
#include "parser.h"

// From disassembler.c
extern unsigned int print_instruction(mem_addr_t, unsigned int, unsigned int);
// From opcode_parser.c
extern unsigned int parse_operand(void);

instr_t instr;

/*
 * Try to match the current token against the mnemonics table.
 * Returns the instruction matched or -1 if no match was found.
 */
static instr_t find_instruction()
{
  char __far *entry = (char __far *)&mnemonics;
  instr_t index = 0;

  // this is a bit obnoxious due to entry being __far but token_ptr is __near.
  while (*entry) {
    if ((token_ptr[0] == entry[0]) && (token_ptr[1] == entry[1]) && (token_ptr[2] == entry[2])) {
      instr = index;
      return 0;
    }
    entry += 4;
    ++index;
  }

  return -1;
}

static unsigned int handle_relative_operand(void)
{
  if ((operand_type != absolute) && (operand_type != d)) return -1;

  signed int offset;

  if (instr >= BRL) {
    operand_type = pcrl;
    offset = ((signed int) operand.w[0]) - (start_loc.loc + 3);
  } else {
    operand_type = pcr;
    offset = operand.w[0] - (start_loc.loc + 2);
    if ((offset < -128) || (offset > 127)) return -1;
  }

  operand.w[0] = offset;
  return 0;
}

/*
 * Given instr/operand find a matching opcode and generate assembly code
 * at start_loc, then update start_loc.
 */
static unsigned int generate_instruction()
{
  // The end of the insruction list are instuctions with relative oeprands,
  // which need to compute the final operand_value.
  if ((instr >= BCC) && (handle_relative_operand() == -1)) {
    parse_error(INVALID_OPERAND);
    return 0;
  }

  const opcode_t *op = opcodes;
  unsigned int opcode;

  // Lookup the opcode matching the tuple <instr, operand_type>
  for (opcode = 0; opcode < 256; opcode++, op++) {
    if (op->instr != instr) continue;

    if (op->operand_type == operand_type) break;
    if ((op->operand_type == immediate_m) || (op->operand_type == immediate_x)) {
      if (operand_type == immediate8) {
        operand_size = 1;
        break;
      } else if (operand_type == immediate16) {
        operand_size = 0;
        break;
      } else
        continue;
    }
  }

  if (opcode == 256) {
    parse_error(INVALID_OPERAND);
    return 0;
  }

  unsigned int instr_len = op->size;
  if (operand_size == 0) instr_len++;

  start_loc.ptr[0] = (unsigned char)opcode;
  for (unsigned int i = 1 ; i < instr_len ; i++) {
    start_loc.ptr[i] = operand.b[i-1];
  }

  kprintf("\x1B[2K\n"); // Clear line
  print_instruction(start_loc, operand_size, operand_size);
  start_loc.ptr += instr_len;

  return 0;
}

void start_assembler(void)
{
  while (1) {
    kprintf("! ");
    char __near *ibuffp = reset_scanner();
    token_t token;

    // empty line exits back to the monitor prompt
    if (read_line() == 0) break;

    // If the line does not start with whitespace then it must be
    // a valid memory adddress followed by a colon.
    if (*ibuffp != ' ') {
      token = get_token(TH_NONE);

      if (parse_address(&start_loc) == -1) {
        parse_error(ADDRESS_PARSE_ERROR);
        break;
      }

      if (get_token(TH_NONE) != TK_COLON) {
        parse_error(COLON_EXPECTED);
        break;
      }
    }

    token = get_token(TK_NO_CONST);

    // Next token must be a valid instruction mnemonic
    if (token != TK_MNEMONIC) {
      parse_error(UNEXPECTED_TOKEN);
      break;
    }
    if (find_instruction() == -1) {
      parse_error(UNKNOWN_OPCODE);
      break;
    }
    if (parse_operand() == -1) {
      parse_error(INVALID_OPERAND);
      break;
    }
    if (generate_instruction() == -1) {
      parse_error(INTERNAL_ERROR);
      break;
    }
  }
}
