%{
#include <stdio.h>
#include <fstream>
#include "../inc/lexer.hpp"
#include "../inc/section.hpp"
#include "../inc/codes.hpp"

extern std::ofstream output;

Section &section = Section::get_section("aaa");

uint8 instruction[8] = {};

int i;

void reset() {
    for (int i = 0; i < 8; i++) {
        instruction[i] = 0;
    }
}

void yyerror(const char *s);
%}

%token END GLOBAL EXTERN SECTION WORD SKIP ASCII EQU //directives
%token INONE IPCOP IPCREGREGOP IREG IREGREG LD ST CSRRD CSRWR //instructions
%token SYMBOL INTEGER REGISTER SYSREG IMMED REGIND REGINDREL //operand types
%token COMMA STRING LABEL COMMENT OPERATOR //miscleanious
%token NEWLINE
%token ERROR

%%

line: label | instruction | label instruction | directive | terminate;

instruction: inone | ipcop | ipcregregop | ireg | iregreg | ld | st | csrrd | csrwr;

directive: global | extern | section | word | skip | ascii | equ | end;

symbol_list: SYMBOL | symbol_list COMMA SYMBOL;

value: SYMBOL | INTEGER;

values_list: value | values_list COMMA value;

expression: value | value OPERATOR expression;

terminate: COMMENT |;

end: END terminate {
    output << "end";
};

global: GLOBAL symbol_list terminate {
    output << "global";
};

extern: EXTERN symbol_list terminate {
    output << "extern";
};

section: SECTION SYMBOL terminate {
    output << "section";
};

word: WORD values_list terminate {
    output << "word";
};

skip: SKIP value terminate {
    output << "skip";
};

ascii: ASCII STRING terminate {
    output << "ascii";
};

equ: EQU SYMBOL COMMA expression terminate {
    output << "equ";
};

inone: INONE terminate {
    reset();
     
    section.next() = Section::make_word(instruction);
    output << "inone";
};

ipcop: IPCOP value terminate {
    reset();
     
    section.next() = Section::make_word(instruction);
    output << "ipcop";
}
    | IPCOP IMMED terminate {
    reset();
     
    section.next() = Section::make_word(instruction);
    output << "ipcop";
};

ipcregregop: IPCREGREGOP REGISTER COMMA REGISTER COMMA value terminate {
    reset();
     
    section.next() = Section::make_word(instruction);
    output << "ipcregregop";
}
    | IPCREGREGOP REGISTER COMMA REGISTER COMMA IMMED terminate {
    reset();
     
    section.next() = Section::make_word(instruction);
    output << "ipcregregop";
};

ireg: IREG REGISTER terminate {
    reset();
     
    section.next() = Section::make_word(instruction);
    output << "ireg";
};

iregreg: IREGREG REGISTER COMMA REGISTER terminate {
    reset();
     
    section.next() = Section::make_word(instruction);
    output << "iregreg";
};

ld: LD IMMED COMMA REGISTER terminate {
    reset();
     
    section.next() = Section::make_word(instruction);
    output << "ld";
}
    | LD SYMBOL COMMA REGISTER terminate {
    reset();
     
    section.next() = Section::make_word(instruction);
    output << "ld";
};

st: ST REGISTER COMMA SYMBOL terminate {
    reset();
     
    section.next() = Section::make_word(instruction);
    output << "st";
};

csrrd: CSRRD SYSREG COMMA REGISTER terminate {
    reset();
     
    section.next() = Section::make_word(instruction);
    output << "csrrd";
};

csrwr: CSRWR REGISTER COMMA SYSREG terminate {
    reset();
     
    section.next() = Section::make_word(instruction);
    output << "csrwr";
};

label: LABEL terminate {
    output << "label";
};

%%

void yyerror(const char *s) {
    output << s;
    fprintf(stderr, "error: %s", s);
}
