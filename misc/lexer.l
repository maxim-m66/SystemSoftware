%{
#include <stdio.h>

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
"," {return COMMA;}
"\"".*"\""[\n] {return STRING;}
"+"|"-"|"*"|"/" {return OPERATOR;}
"halt"|"int"|"iret"|"ret" {return INONE;}
"call"|"jmp" {return IPCOP;}
"beq"|"bne"|"bgt" {return IPCREGREGOP;}
"push"|"pop"|"not" {return IREG;}
"xchg"|"add"|"sub"|"mul"|"div"|"and"|"or"|"xor"|"shl"|"shr" {return IREGREG;}
"ld" {return LD;}
"st" {return ST;}
"csrrd" {return CSRRD;}
"csrwr" {return CSRWR;}
{symbol} {return SYMBOL;}
{symbol}":" {return LABEL;}
{integer} {return INTEGER;}
{reg} {return REGISTER;}
"%"("sstatus"|"handler"|"scause") {return SYSREG;}
("$"{integer})|("$"{symbol}) {return IMMED;}
"["{reg}"]" {return REGIND;}
"["{reg}{spc}"+"{spc}({integer}|{symbol})"]" {return REGINDREL;}
[ \t]+
[\n] {return NEWLINE;}
"#"(.)* {return COMMENT;}
%%

int main() {
  /*


*/
  while(1) {
    printf("%d\n", yylex());
  }
  return 0;
}

int yywrap() {
    return 1;
}