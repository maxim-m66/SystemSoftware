%{
#include <stdio.h>
#include "parser.hpp"
%}

spc [ ]*
gap [ ]+
digit [0-9]
decimal {digit}+
hexadigit [0-9]|[A-F]|[a-f]
hexa "0x"({hexadigit})+
integer {decimal}|{hexa}
lowercase [a-z]
uppercase [A-Z]
letter {lowercase}|{uppercase}|"_"
alphanum ({digit}|{letter})+
symbol {letter}({alphanum})*
operator "+"|"-"|"*"|"/"
reg "%"(("r"{digit}[0-5]?)|"pc"|"sp")

%%

"," {return COMMA;}
".end" {return END;}
".global" {return GLOBAL;}
".extern" {return EXTERN;}
".section" {return SECTION;}
".word" {return WORD;}
".skip" {return SKIP;}
".ascii" {return ASCII;}
".equ" {return EQU;}
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
"%"("status"|"handler"|"cause") {return SYSREG;}
("$"{integer})|("$"{symbol}) {return IMMED;}
"["{reg}"]" {return REGIND;}
"["{reg}{spc}"+"{spc}({integer}|{symbol})"]" {return REGINDREL;}
[ \t]+ {/* Ignore whitespace */}
[\n] {return NEWLINE;}
"#"(.)* {return COMMENT;}
. {return ERROR;}
%%

int yywrap() {
    return 1;
}