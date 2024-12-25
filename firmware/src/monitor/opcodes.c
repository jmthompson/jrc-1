#include "globals.h"
#include "opcodes.h"
#include "operand.h"

/*
 * Instruction nnemonics
 */
char __far instr_mnemonics[][4] = {
  "ADC", // $00
  "AND", // $01
  "ASL", // $02
  "BIT", // $03
  "BRK", // $04
  "CLC", // $05
  "CLD", // $06
  "CLI", // $07
  "CLV", // $08
  "CMP", // $09
  "COP", // $0A
  "CPX", // $0B
  "CPY", // $0C
  "DEC", // $0D
  "DEX", // $0E
  "DEY", // $0F
  "EOR", // $10
  "INC", // $11
  "INX", // $12
  "INY", // $13
  "JML", // $14
  "JMP", // $15
  "JSL", // $16
  "JSR", // $17
  "LDA", // $18
  "LDX", // $19
  "LDY", // $1A
  "LSR", // $1B
  "MVN", // $1C
  "MVP", // $1D
  "NOP", // $1E
  "ORA", // $1F
  "PEA", // $20
  "PEI", // $21
  "PHA", // $22
  "PHB", // $23
  "PHD", // $24
  "PHK", // $25
  "PHP", // $26
  "PHX", // $27
  "PHY", // $28
  "PLA", // $29
  "PLB", // $2A
  "PLD", // $2B
  "PLP", // $2C
  "PLX", // $2D
  "PLY", // $2E
  "REP", // $2F
  "ROL", // $30
  "ROR", // $31
  "RTI", // $32
  "RTL", // $33
  "RTS", // $34
  "SBC", // $35
  "SEC", // $36
  "SED", // $37
  "SEI", // $38
  "SEP", // $39
  "STA", // $3A
  "STP", // $3B
  "STX", // $3C
  "STY", // $3D
  "STZ", // $3E
  "TAX", // $3F
  "TAY", // $40
  "TCD", // $41
  "TCS", // $42
  "TDC", // $43
  "TRB", // $44
  "TSB", // $45
  "TSC", // $46
  "TSX", // $47
  "TXA", // $48
  "TXS", // $49
  "TXY", // $4A
  "TYA", // $4B
  "TYX", // $4C
  "WAI", // $4D
  "WDC", // $4E
  "WDM", // $4F
  "XBA", // $50
  "XCE", // $51
  "BCC", // $52
  "BCS", // $53
  "BEQ", // $54
  "BMI", // $55
  "BNE", // $56
  "BPL", // $57
  "BRA", // $58
  "BVC", // $59
  "BVS", // $5A
  "BRL", // $5B
  "PER", // $5C
  "\0\0\0"
};

instr_t __far opcode_instr[] = {
  BRK,
  ORA,
  COP,
  ORA,
  TSB,
  ORA,
  ASL,
  ORA,
  PHP,
  ORA,
  ASL,
  PHD,
  TSB,
  ORA,
  ASL,
  ORA,
  BPL,
  ORA,
  ORA,
  ORA,
  TRB,
  ORA,
  ASL,
  ORA,
  CLC,
  ORA,
  INC,
  TCS,
  TRB,
  ORA,
  ASL,
  ORA,
  JSR,
  AND,
  JSL,
  AND,
  BIT,
  AND,
  ROL,
  AND,
  PLP,
  AND,
  ROL,
  PLD,
  BIT,
  AND,
  ROL,
  AND,
  BMI,
  AND,
  AND,
  AND,
  BIT,
  AND,
  ROL,
  AND,
  SEC,
  AND,
  DEC,
  TSC,
  BIT,
  AND,
  ROL,
  AND,
  RTI,
  EOR,
  WDM,
  EOR,
  MVP,
  EOR,
  LSR,
  EOR,
  PHA,
  EOR,
  LSR,
  PHK,
  JMP,
  EOR,
  LSR,
  EOR,
  BVC,
  EOR,
  EOR,
  EOR,
  MVN,
  EOR,
  LSR,
  EOR,
  CLI,
  EOR,
  PHY,
  TCD,
  JMP,
  EOR,
  LSR,
  EOR,
  RTS,
  ADC,
  PER,
  ADC,
  STZ,
  ADC,
  ROR,
  ADC,
  PLA,
  ADC,
  ROR,
  RTL,
  JMP,
  ADC,
  ROR,
  ADC,
  BVS,
  ADC,
  ADC,
  ADC,
  STZ,
  ADC,
  ROR,
  ADC,
  SEI,
  ADC,
  PLY,
  TDC,
  JMP,
  ADC,
  ROR,
  ADC,
  BRA,
  STA,
  BRL,
  STA,
  STY,
  STA,
  STX,
  STA,
  DEY,
  BIT,
  TXA,
  PHB,
  STY,
  STA,
  STX,
  STA,
  BCC,
  STA,
  STA,
  STA,
  STY,
  STA,
  STX,
  STA,
  TYA,
  STA,
  TXS,
  TXY,
  STZ,
  STA,
  STZ,
  STA,
  LDY,
  LDA,
  LDX,
  LDA,
  LDY,
  LDA,
  LDX,
  LDA,
  TAY,
  LDA,
  TAX,
  PLB,
  LDY,
  LDA,
  LDX,
  LDA,
  BCS,
  LDA,
  LDA,
  LDA,
  LDY,
  LDA,
  LDX,
  LDA,
  CLV,
  LDA,
  TSX,
  TYX,
  LDY,
  LDA,
  LDX,
  LDA,
  CPY,
  CMP,
  REP,
  CMP,
  CPY,
  CMP,
  DEC,
  CMP,
  INY,
  CMP,
  DEX,
  WAI,
  CPY,
  CMP,
  DEC,
  CMP,
  BNE,
  CMP,
  CMP,
  CMP,
  PEI,
  CMP,
  DEC,
  CMP,
  CLD,
  CMP,
  PHX,
  STP,
  JML,
  CMP,
  DEC,
  CMP,
  CPX,
  SBC,
  SEP,
  SBC,
  CPX,
  SBC,
  INC,
  SBC,
  INX,
  SBC,
  NOP,
  XBA,
  CPX,
  SBC,
  INC,
  SBC,
  BEQ,
  SBC,
  SBC,
  SBC,
  PEA,
  SBC,
  INC,
  SBC,
  SED,
  SBC,
  PLX,
  XCE,
  JSR,
  SBC,
  INC,
  SBC
};

operand_am_t __far opcode_am[] = {
  d,
  dxi,
  d,
  sr,
  d,
  d,
  d,
  dil,
  implied,
  immediate_m,
  implied,
  implied,
  absolute,
  absolute,
  absolute,
  al,
  pcr,
  dix,
  di,
  arix,
  d,
  dxx,
  dxx,
  dixl,
  implied,
  axy,
  implied,
  implied,
  absolute,
  axx,
  axx,
  alxx,
  absolute,
  dxi,
  al,
  sr,
  d,
  d,
  d,
  dil,
  implied,
  immediate_m,
  implied,
  implied,
  absolute,
  absolute,
  absolute,
  al,
  pcr,
  dix,
  di,
  arix,
  dxx,
  dxx,
  dxx,
  dixl,
  implied,
  axy,
  implied,
  implied,
  axx,
  axx,
  axx,
  alxx,
  implied,
  dxi,
  immediate8,
  sr,
  blockmove,
  d,
  d,
  dil,
  implied,
  immediate_m,
  implied,
  implied,
  absolute,
  absolute,
  absolute,
  al,
  pcr,
  dix,
  di,
  arix,
  blockmove,
  dxx,
  dxx,
  dixl,
  implied,
  axy,
  implied,
  implied,
  al,
  axx,
  axx,
  alxx,
  implied,
  dxi,
  pcrl,
  sr,
  d,
  d,
  d,
  dil,
  implied,
  immediate_m,
  implied,
  implied,
  ai,
  absolute,
  absolute,
  al,
  pcr,
  dix,
  di,
  arix,
  dxx,
  dxx,
  dxx,
  dixl,
  implied,
  axy,
  implied,
  implied,
  axi,
  axx,
  axx,
  alxx,
  pcr,
  dxi,
  pcrl,
  sr,
  d,
  d,
  d,
  dil,
  implied,
  immediate_m,
  implied,
  implied,
  absolute,
  absolute,
  absolute,
  al,
  pcr,
  dix,
  di,
  arix,
  dxx,
  dxx,
  dxy,
  dixl,
  implied,
  axy,
  implied,
  implied,
  absolute,
  axx,
  axx,
  alxx,
  immediate_x,
  dxi,
  immediate_x,
  sr,
  d,
  d,
  d,
  dil,
  implied,
  immediate_m,
  implied,
  implied,
  absolute,
  absolute,
  absolute,
  al,
  pcr,
  dix,
  di,
  arix,
  dxx,
  dxx,
  dxy,
  dixl,
  implied,
  axy,
  implied,
  implied,
  axx,
  axx,
  axy,
  alxx,
  immediate_x,
  dxi,
  immediate8,
  sr,
  d,
  d,
  d,
  dil,
  implied,
  immediate_m,
  implied,
  implied,
  absolute,
  absolute,
  absolute,
  al,
  pcr,
  dix,
  di,
  arix,
  d,
  dxx,
  dxx,
  dixl,
  implied,
  axy,
  implied,
  implied,
  ai,
  axx,
  axx,
  alxx,
  immediate_x,
  dxi,
  immediate8,
  sr,
  d,
  d,
  d,
  di,
  implied,
  immediate_m,
  implied,
  implied,
  absolute,
  absolute,
  absolute,
  al,
  pcr,
  dix,
  di,
  arix,
  immediate16,
  dxx,
  dxx,
  dixl,
  implied,
  axy,
  implied,
  implied,
  axi,
  axx,
  axx,
  alxx
};

/* Opcode lengths for each instruction type */
unsigned int __far am_lengths[] = {
  2,    // immediate8
  3,    // immediate16
  3,    // absolute
  4,    // al
  2,    // d
  1,    // implied
  2,    // dix
  2,    // dixl
  2,    // dxi
  2,    // dxx
  2,    // dxy
  3,    // axx
  4,    // alxx
  3,    // axy
  2,    // pcr
  3,    // pcrl
  3,    // ai
  2,    // di
  2,    // dil
  3,    // axi
  2,    // sr
  2,    // arix
  3,    // blockmove
  2,    // immediate_x
  2 ,   // immediate_m
};
