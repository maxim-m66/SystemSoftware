%{
#include "../inc/parser.hpp"
%}

spc [ ]*
gap [ ]+
digit [0-9]
decimal {digit}+
hexadigit [0-9]|[A-F]|[a-f]
hexa "0x"({hexadigit})+
octadigit [0-7]
octal "0o"({octadigit})+
bindigit [0-1]
binary "0b"({bindigit})+
integer {decimal}|{hexa}|{octal}|{binary}
lowercase [a-z]
uppercase [A-Z]
letter {lowercase}|{uppercase}|"_"
alphanum ({digit}|{letter})+
symbol {letter}({alphanum})*
operator "+"|"-"|"*"|"/"
reg "%"(("r"{digit}[0-5]?)|"pc"|"sp")

%%

"," { yylval.str = strdup(yytext); return COMMA; }
".end" { yylval.str = strdup(yytext); return END; }
".global" { yylval.str = strdup(yytext); return GLOBAL; }
".extern" { yylval.str = strdup(yytext); return EXTERN; }
".section" { yylval.str = strdup(yytext); return SECTION; }
".word" { yylval.str = strdup(yytext); return WORD; }
".skip" { yylval.str = strdup(yytext); return SKIP; }
".ascii" { yylval.str = strdup(yytext); return ASCII; }
".equ" { yylval.str = strdup(yytext); return EQU; }
"\"".*"\""[\n] { yylval.str = strdup(yytext); return STRING; }
"+"|"-"|"*"|"/" { yylval.str = strdup(yytext); return OPERATOR; }
"halt"|"int" { yylval.str = strdup(yytext); return INONE; }
"ret" { yylval.str = strdup(yytext); return RET; }
"iret" { yylval.str = strdup(yytext); return IRET; }
"call"|"jmp" { yylval.str = strdup(yytext); return JUMP; }
"beq"|"bne"|"bgt" { yylval.str = strdup(yytext); return BRANCH; }
"push" { yylval.str = strdup(yytext); return PUSH; }
"pop" { yylval.str = strdup(yytext); return POP; }
"add"|"sub"|"mul"|"div"|"and"|"or"|"xor"|"shl"|"shr" { yylval.str = strdup(yytext); return ALO; }
"not" { yylval.str = strdup(yytext); return NOT; }
"xchg" { yylval.str = strdup(yytext); return XCHG; }
"ld" { yylval.str = strdup(yytext); return LD; }
"st" { yylval.str = strdup(yytext); return ST; }
"csrrd" { yylval.str = strdup(yytext); return CSRRD; }
"csrwr" { yylval.str = strdup(yytext); return CSRWR; }
{symbol} { yylval.str = strdup(yytext); return SYMBOL; }
{symbol}":" { yylval.str = strdup(yytext); return LABEL; }
{integer} { yylval.str = strdup(yytext); return INTEGER; }
{reg} { yylval.str = strdup(yytext); return REGISTER; }
"%"("status"|"handler"|"cause") { yylval.str = strdup(yytext); return SYSREG; }
("$"{integer})|("$"{symbol}) { yylval.str = strdup(yytext); return IMMED; }
"["{reg}"]" { yylval.str = strdup(yytext); return REGIND; }
"["{reg}{spc}"+"{spc}({integer}|{symbol})"]" { yylval.str = strdup(yytext); return REGINDREL; }
[ \t]+ {/* Ignore whitespace */}
[\n] { yylval.str = strdup(yytext); return NEWLINE; }
"#"(.)* { yylval.str = strdup(yytext); return COMMENT; }
. { yylval.str = strdup(yytext); return ERROR; }
%%

int yywrap() {
    return 1;
}