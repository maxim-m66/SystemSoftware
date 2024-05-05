%{
#include <stdio.h>
#include "lexer.hpp"
void yyerror(const char *s);
%}

%token END GLOBAL EXTERN SECTION WORD SKIP ASCII EQU //directives
%token INONE IPCOP IPCREGREGOP IREG IREGREG LD ST CSRRD CSRWR //instructions
%token SYMBOL INTEGER REGISTER SYSREG IMMED REGIND REGINDREL //operand types
%token COMMA STRING LABEL COMMENT OPERATOR //miscleanious
%token NEWLINE
%token ERROR

%%

line: instruction | label instruction | directive | terminate;

instruction: inone | ipcop | ipcregregop | ireg | iregreg;

directive: global | extern | section | word | skip | ascii | equ;

symbol_list: SYMBOL | symbol_list COMMA SYMBOL;

value: SYMBOL | INTEGER;

values_list: value | values_list COMMA value;

expression: value | value OPERATOR expression;

terminate: COMMENT | ;

global: GLOBAL symbol_list terminate {

};

extern: EXTERN symbol_list terminate {

};

section: SECTION SYMBOL terminate {

};

word: WORD values_list terminate {

};

skip: SKIP value terminate {

};

ascii: ASCII STRING terminate {

};

equ: EQU SYMBOL expression terminate {
    
};

inone: INONE terminate {

};

ipcop: IPCOP value terminate
    | IPCOP IMMED terminate {

};

ipcregregop: IPCREGREGOP REGISTER REGISTER value terminate
    | IPCREGREGOP REGISTER REGISTER IMMED terminate {

};

ireg: IREG REGISTER terminate {

};

iregreg: IREGREG REGISTER COMMA REGISTER terminate {

};

label: LABEL {

};

%%

void yyerror(const char *s) {
    fprintf(stderr, "error: %s\n", s);
    exit(-1);
}
