%{
#include <stdio.h>
%}

%token END GLOBAL EXTERN SECTION WORD SKIP ASCII EQU //directives
%token INONE IPCOP IPCREGREGOP IREG IREGREG LD ST CSRRD CSRWR //instructions
%token SYMBOL REGISTER SYSREG IMMED REGIND REGINDREL //operand types
%token COMMA STRING LABEL COMMENT OPERATOR //miscleanious
%token NEWLINE

%%

symbol_list: SYMBOL | symbol_list COMMA SYMBOL;

value: SYMBOL | INTEGER;

values_list: value | values_list COMMA value;

expression: value | value OPERATOR expression;

terminate: NEWLINE | COMMENT;

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

equ: SYMBOL expression terminate {

};

inone: INONE terminate {

};

ipcop: IPCOP (value | IMMED) terminate {

};

ipcregregop: IPCREGREGOP REGISTER REGISTER (value | IMMED) terminate {

};

ireg: IREG REGISTER terminate {

};

iregreg: IREGREG REGISTER COMMA REGISTER terminate {

};

label: LABEL {

};

%%

int main() {
    yyparse();
}

void yyerror(char *s) {
    fprintf(stderr, "error: %s\n", s);
}