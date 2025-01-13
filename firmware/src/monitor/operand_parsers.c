#include "globals.h"
#include "messages.h"
#include "opcodes.h"
#include "parser.h"
#include <kernel/console.h>
#include <stdio.h>
#include <stdlib.h>

static unsigned int parse_immediate(void)
{
  switch (get_token(TH_NONE)) {
  case TK_CONST8:
    operand_type = immediate8;
    operand_size = 1;
    return 0;
  case TK_CONST16:
    operand_type = immediate16;
    operand_size = 0;
    return 0;
  default:
    return -1;
  }
}

static unsigned int parse_indirect(void)
{
  switch (get_token(TH_NONE)) {
  case TK_CONST16:
    operand.w[0] = token_value.w[0];
    switch (get_token(TH_NONE)) {
    case TK_RPAREN:
      operand_type = ai;
      return 0;
    case TK_COMMA:
      if (get_token(TH_NONE) != TK_XREG) return -1;
      if (get_token(TH_NONE) != TK_RPAREN) return -1;
      operand_type = axi;
      return 0;
    default:
      return -1;
    }
  case TK_CONST8:
    operand.b[0] = token_value.b[0];
    switch (get_token(token_type)) {
    case TK_RPAREN:
      switch (get_token(TH_NONE)) {
      case TK_EOL:
        operand_type = di;
        return 0;
      case TK_COMMA:
        if (get_token(TH_NONE) != TK_YREG) return -1;
        operand_type = dix;
        return 0;
      default:
        return -1;
      }
    case TK_COMMA:
      switch (get_token(token_type)) {
      case TK_SREG:
        if (get_token(TH_NONE) != TK_RPAREN) return -1;
        if (get_token(TH_NONE) != TK_COMMA) return -1;
        if (get_token(TH_NONE) != TK_YREG) return -1;
        operand_type = srix;
        return 0;
      case TK_XREG:
        if (get_token(TH_NONE) != TK_RPAREN) return -1;
        operand_type = dxi;
        return 0;
      default:
        return -1;
      }
    default:
      return -1;
    }
  default:
    return -1;
  }
}

static unsigned int parse_indirect_long(void)
{
  if (get_token(TH_NONE) != TK_CONST8) return -1;
  operand.b[0] = token_value.b[0];
  if (get_token(TH_NONE) != TK_RBRACKET) return -1;

  switch (get_token(TH_NONE)) {
  case TK_EOL:
    operand_type = dil;
    return 0;
  case TK_COMMA:
    if (get_token(TH_NONE) != TK_YREG) return -1;
    operand_type = dixl;
    return 0;
  default:
    return -1;
  }
}

static unsigned int parse_const8(void)
{
  operand.b[0] = token_value.b[0];
  get_token(TH_NONE);

  switch (get_token(TH_NONE)) {
  case TK_EOL:
    operand_type = d;
    return 0;
  case TK_COMMA:
    switch (get_token(TH_NONE)) {
    case TK_CONST8:
      operand.b[1] = token_value.b[1];
      operand_type = blockmove;
      return 0;
    case TK_SREG:
      operand_type = sr;
      return 0;
    case TK_XREG:
      operand_type = dxx;
      return 0;
    case TK_YREG:
      operand_type = dxy;
      return 0;
    default:
      return -1;
    }
  default:
    return -1;
  }
}

static unsigned int parse_const16(void)
{
  operand.w[0] = token_value.w[0];

  switch (get_token(TH_NONE)) {
  case TK_EOL:
    operand_type = absolute;
    break;
  case TK_COMMA:
    switch (get_token(token_type)) {
    case TK_XREG:
      operand_type = axx;
      return 0;
    case TK_YREG:
      operand_type = axy;
      return 0;
    default:
      return -1;
    }
  default:
    return -1;
  }

  return 0;
}

static unsigned int parse_const24(void)
{
  operand.l = token_value.l;

  switch (get_token(TH_NONE)) {
  case TK_EOL:
    operand_type = al;
    break;
  case TK_COMMA:
    if (get_token(TH_NONE) != TK_XREG) return -1;
    operand_type = alxx;
    break;
  default:
    return -1;
  }

  return 0;
}

/**
 * Parse the operand. On success operand, operand_size, and oprand_type will be valid
 * and 0 is returned. Otherwise, returns -1.
 */
unsigned int parse_operand(void)
{
  operand.l = 0;
  get_token(TH_NONE);

  switch (token_type) {
  case TK_EOL:
    operand_type = implied;
    operand_size = 0;
    return 0;
  case TK_POUND:
    return parse_immediate();
  case TK_LPAREN:
    return parse_indirect();
  case TK_LBRACKET:
    return parse_indirect_long();
  case TK_CONST8:
    return parse_const8();
  case TK_CONST16:
    return parse_const16();
  case TK_CONST24:
    return parse_const24();
  default:
    return -1;
  }
}
