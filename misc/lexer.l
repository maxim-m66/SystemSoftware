%{
#include <stdio.h>

enum Tokens {
  ERROR = -1,
  END,
  GLOBAL,
  EXTERN,
  SECTION,
  WORD,
  SKIP,
  ASCII,
  EQU,
  SYMBOL,
  COMMA,
  LABEL,
  INTEGER,
  HALT,
  INT,
  IRET,
  CALL,
  RET,
  JMP,
  BEQ,
  BNE,
  BGT,
  PUSH,
  POP,
  XCHG,
  ADD,
  SUB,
  MUL,
  DIV,
  NOT,
  AND,
  OR,
  XOR,
  SHL,
  SHR,
  LD,
  ST,
  CSRRD,
  CSRWR,
  REGISTER,
  SYSREG,
  IMMED,
  REGIND,
  REGINDREL,
  WHITESPACE,
  NEWLINE
};

%}

spc [ ]*
gap [ ]+
digit [0-9]
integer {digit}+
lowercase [a-z]
uppercase [A-Z]
letter {lowercase}|{uppercase}
alphanum ({digit}|{letter})+
symbol {letter}({alphanum})*
operator "+"|"-"|"*"|"/"
reg "%"(("r"{digit}[0-5]?)|"pc"|"sp")

%%

".end" {return END;}
".global" {return GLOBAL;}
".extern" {return EXTERN;}
".section" {return SECTION;}
".word" {return WORD;}
".skip" {return SKIP;}
".ascii" {return ASCII;}
".equ" {return EQU;}
{symbol} {return SYMBOL;}
"," {return COMMA;}
{symbol}":" {return LABEL;}
{integer} {return INTEGER;}
{reg} {return REGISTER;}
"%"("sstatus"|"handler"|"scause") {return SYSREG;}
("$"{integer})|("$"{symbol}) {return IMMED;}
"["{reg}"]" {return REGIND;}
"["{reg}{spc}"+"{spc}({integer}|{symbol})"]" {return REGINDREL;}
[ \t]+ {return WHITESPACE;}
[\n]
(.)* {return -100;}
%%

int main() {
  while(1) {
    printf("%d\n", yylex());
  }
  return 0;
}

int yywrap() {
    return 1;
}