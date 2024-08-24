%{
#include <stdio.h>
#include <string.h>
#include <fstream>
#include <iostream>
#include <bitset>

#include "../inc/symbol_table.hpp"
#include "../inc/lexer.hpp"
#include "../inc/section.hpp"
#include "../inc/codes.hpp"
#include "../inc/int_util.hpp"

Section *section = Section::get_section("txt");

SymbolTable &symbol_table = SymbolTable::get_table();

extern int fileline;

extern bool was_error;

std::vector<pair> symbols;

std::vector<pair> operands;

std::vector<std::string> operators;

uint8 instruction[8] = {};

void fill(uint8 opcode, uint8 mod = 0, uint8 a = 0, uint8 b = 0, uint8 c = 0, int displacement = 0);

void displacement(uint8* instruction, int displacement);

int endian(int number);

void yyerror(const char *s);

std::string to_my_string(std::string);
%}

%union {
    const char *str;
}

%token<str> END GLOBAL EXTERN SECTION WORD SKIP ASCII EQU //directives
%token<str> INONE RET IRET JUMP BRANCH PUSH POP ALO XCHG NOT LD ST CSRRD CSRWR //instructions
%token<str> SYMBOL INTEGER REGISTER SYSREG IMMED //operand types
%token<str> COMMA STRING LABEL COMMENT OPERATOR LBRACKET RBRACKET //miscellaneous
%token<str> NEWLINE
%token<str> ERROR

%%

line: label | instruction | label instruction | directive | label directive | terminate;

instruction: inone | ret | iret | jump | branch | push | pop | alo | xchg | not | ld | st | csrrd | csrwr;

directive: global | extern | section | word | skip | ascii | equ | end;

symbol_list: SYMBOL {
    symbols.push_back({true, $1});
}
| symbol_list COMMA SYMBOL {
    symbols.push_back({true, $3});
};

values_list: INTEGER {
    symbols.push_back({true, $1});
}
| SYMBOL {
    symbols.push_back({false, $1});
}
| values_list COMMA INTEGER {
    symbols.push_back({true, $3});
}
| values_list COMMA SYMBOL {
    symbols.push_back({false, $3});
};

expression: INTEGER {
    operands.push_back({false, $1});
}
    | SYMBOL {
    operands.push_back({true, $1});
}
    | INTEGER OPERATOR expression {
    operators.push_back($2);
    operands.push_back({false, $1});
}
    | SYMBOL OPERATOR expression {
    operators.push_back($2);
    operands.push_back({true, $1});
};

terminate: COMMENT |;

end: END terminate {
    YYABORT;
};

global: GLOBAL symbol_list terminate {
    for (auto& pair : symbols) {
        symbol_table.get_global().insert(pair.symbol);
    }
    symbols.clear();
};

extern: EXTERN symbol_list terminate {
    for (auto& pair : symbols) {
        symbol_table.get_extern().insert(pair.symbol);
    }
    symbols.clear();
};

section: SECTION SYMBOL terminate {
    section = Section::get_section($2);
};

word: WORD values_list terminate {
    for (pair value : symbols) {
        if (!value.is_symbol) {
            symbol_table.new_occurrence(value.symbol, section->get_name(), section->line(), true);
            section->next_word(0);
        } else {
            section->next_word(endian(to_int(value.symbol)));
        }
    }
    symbols.clear();
};

skip: SKIP INTEGER terminate {
    for (int i = 0; i < to_int($2); i++) {
        section->next_byte(0);
    }
}

label: SYMBOL LABEL terminate {
    symbol_table.new_def($1, fileline);
    symbol_table.value($1) = section->line();
    symbol_table.section($1) = section->get_name();
};

ascii: ASCII STRING terminate {
    std::string string = $2;
    section->ascii(string);
};

equ: EQU SYMBOL COMMA expression terminate {
    SymbolTable::new_equ(std::string($2), operands, operators);
    operators.clear();
    operands.clear();
};

inone: INONE terminate {
    fill(Codes::opcode[$1]);
    section->next_word(Section::make_word(instruction));
};

ret: RET terminate {
    fill(Codes::opcode[$1], Codes::mod[$1], Codes::reg["%pc"], Codes::reg["%sp"], 0, 1);
    section->next_word(Section::make_word(instruction));
};

iret: IRET terminate {
    fill(Codes::opcode["pop"], Codes::mod[$1], Codes::reg["%status"], Codes::reg["%sp"], 0, 4);
    section->next_word(Section::make_word(instruction));
    fill(Codes::opcode["ret"], Codes::mod["ret"], Codes::reg["%pc"], Codes::reg["%sp"], 0, 4);
    section->next_word(Section::make_word(instruction));
};

jump: JUMP SYMBOL terminate {
    section->new_jump(-1, $2);
    fill(Codes::opcode[$1], Codes::mod[$1], 15);
    section->next_word(Section::make_word(instruction));
}
    | JUMP INTEGER terminate {
    section->new_jump(to_int($2), "");
    fill(Codes::opcode[$1], Codes::mod[$1], 15);
    section->next_word(Section::make_word(instruction));
};

branch: BRANCH REGISTER COMMA REGISTER COMMA SYMBOL terminate {
    section->new_jump(-1, $6);
    fill(Codes::opcode[$1], Codes::mod[$1], 15, Codes::reg[$2], Codes::reg[$4]);
    section->next_word(Section::make_word(instruction));
}
    | BRANCH REGISTER COMMA REGISTER COMMA INTEGER terminate {
    section->new_jump(to_int($6), "");
    section->next_word(Section::make_word(instruction));
};

push: PUSH REGISTER terminate {
    fill(Codes::opcode[$1], Codes::mod[$1], Codes::reg["%sp"], 0, Codes::reg[$2], -4);
    section->next_word(Section::make_word(instruction));
};

pop: POP REGISTER terminate {
    fill(Codes::opcode[$1], Codes::mod[$1], Codes::reg[$2], Codes::reg["%sp"], 0, 4);
    section->next_word(Section::make_word(instruction));
};

alo: ALO REGISTER COMMA REGISTER terminate {
    fill(Codes::opcode[$1], Codes::mod[$1], Codes::reg[$4], Codes::reg[$2], Codes::reg[$4]);
    section->next_word(Section::make_word(instruction));
};

xchg: XCHG REGISTER COMMA REGISTER {
    fill(Codes::opcode[$1], 0, 0, Codes::reg[$2], Codes::reg[$4]);
    section->next_word(Section::make_word(instruction));
};

not: NOT REGISTER {
    fill(Codes::opcode[$1], Codes::mod[$1], Codes::reg[$2], Codes::reg[$2]);
    section->next_word(Section::make_word(instruction));
};

ld: LD IMMED INTEGER COMMA REGISTER terminate {
    section->new_jump(to_int($3), "");
    fill(Codes::opcode[$1], Codes::mod["limmed"], Codes::reg[$5], 15);
    section->next_word(Section::make_word(instruction));
}
    | LD IMMED SYMBOL COMMA REGISTER terminate {
    section->new_jump(-1, $3);
    fill(Codes::opcode[$1], Codes::mod["limmed"], Codes::reg[$5], 15);
    section->next_word(Section::make_word(instruction));
}
    | LD INTEGER COMMA REGISTER terminate {
    bool alt = (std::string($4) == "%r1");

    fill(Codes::opcode["push"], Codes::mod["push"], Codes::reg["%sp"], 0, alt ? 2 : 1, -1);
    section->next_word(Section::make_word(instruction));

    section->new_jump(to_int($2), "");
    fill(Codes::opcode[$1], Codes::mod["limmed"], alt ? 2 : 1, 15);
    section->next_word(Section::make_word(instruction));

    fill(Codes::opcode[$1], Codes::mod["lmem"], Codes::reg[$4], alt ? 2 : 1);
    section->next_word(Section::make_word(instruction));

    fill(Codes::opcode["pop"], Codes::mod["pop"], alt ? 2 : 1, Codes::reg["%sp"], 0, 1);
    section->next_word(Section::make_word(instruction));
}
    | LD SYMBOL COMMA REGISTER terminate {
    bool alt = (std::string($4) == "%r1");

    fill(Codes::opcode["push"], Codes::mod["push"], Codes::reg["%sp"], 0, alt ? 2 : 1, -1);
    section->next_word(Section::make_word(instruction));

    section->new_jump(-1, $2);
    fill(Codes::opcode[$1], Codes::mod["limmed"], alt ? 2 : 1, 15);
    section->next_word(Section::make_word(instruction));

    fill(Codes::opcode[$1], Codes::mod["lmem"], Codes::reg[$4], alt ? 2 : 1);
    section->next_word(Section::make_word(instruction));

    fill(Codes::opcode["pop"], Codes::mod["pop"], alt ? 2 : 1, Codes::reg["%sp"], 0, 1);
    section->next_word(Section::make_word(instruction));
}
    | LD REGISTER COMMA REGISTER terminate {
    fill(Codes::opcode[$1], Codes::mod["lreg"], Codes::reg[$4], Codes::reg[$2]);
    section->next_word(Section::make_word(instruction));
}
    | LD LBRACKET REGISTER RBRACKET COMMA REGISTER terminate {
    fill(Codes::opcode[$1], Codes::mod["lmem"], Codes::reg[$6], Codes::reg[$3]);
    section->next_word(Section::make_word(instruction));
}
    | LD LBRACKET REGISTER OPERATOR INTEGER RBRACKET COMMA REGISTER terminate {
    fill(Codes::opcode[$1], Codes::mod["lmem"], Codes::reg[$8], Codes::reg[$3], 0, to_int($5));
    section->next_word(Section::make_word(instruction));
}
    | LD LBRACKET REGISTER OPERATOR SYMBOL RBRACKET COMMA REGISTER terminate {
    symbol_table.new_occurrence($5, section->get_name(), section->line());
    fill(Codes::opcode[$1], Codes::mod["lmem"], Codes::reg[$8], Codes::reg[$3]);
    section->next_word(Section::make_word(instruction));
};

st: ST REGISTER COMMA INTEGER terminate {
    section->new_jump(to_int($4), "");
    fill(Codes::opcode[$1], Codes::mod["stdir"], 15, 0, Codes::reg[$2]);
    section->next_word(Section::make_word(instruction));
}
    | ST REGISTER COMMA SYMBOL terminate {
    section->new_jump(-1, $4);
    fill(Codes::opcode[$1], Codes::mod["stdir"], 15, 0, Codes::reg[$2]);
    section->next_word(Section::make_word(instruction));
}
    | ST REGISTER COMMA REGISTER terminate {
    fill(Codes::opcode["ld"], Codes::mod["lreg"], Codes::reg[$4], Codes::reg[$2]);
    section->next_word(Section::make_word(instruction));
}
    | ST REGISTER COMMA LBRACKET REGISTER RBRACKET terminate {
    fill(Codes::opcode[$1], Codes::mod[$1], Codes::reg[$5], 0, Codes::reg[$2]);
    section->next_word(Section::make_word(instruction));
}
    | ST REGISTER COMMA LBRACKET REGISTER OPERATOR INTEGER RBRACKET terminate {
    fill(Codes::opcode[$1], Codes::mod[$1], Codes::reg[$5], 0, Codes::reg[$2], to_int($7));
    section->next_word(Section::make_word(instruction));
}
    | ST REGISTER COMMA LBRACKET REGISTER OPERATOR SYMBOL RBRACKET terminate {
    symbol_table.new_occurrence($7, section->get_name(), section->line());
    fill(Codes::opcode[$1], Codes::mod[$1], Codes::reg[$5], 0, Codes::reg[$2]);
    section->next_word(Section::make_word(instruction));
};

csrrd: CSRRD SYSREG COMMA REGISTER terminate {
    fill(Codes::opcode[$1], Codes::mod[$1], Codes::reg[$2], Codes::reg[$4]);
    section->next_word(Section::make_word(instruction));
};

csrwr: CSRWR REGISTER COMMA SYSREG terminate {
    fill(Codes::opcode[$1], Codes::mod[$1], Codes::reg[$2], Codes::reg[$4]);
    section->next_word(Section::make_word(instruction));
};

%%

void yyerror(const char *s) {
    was_error = true;
    fprintf(stderr, "%s on line %d\n", s, fileline);
}

void fill(uint8 opcode, uint8 mod, uint8 a, uint8 b, uint8 c, int displacement) {
    instruction[0] = opcode;
    instruction[1] = mod;
    instruction[2] = a;
    instruction[3] = b;
    instruction[4] = c;
    instruction[5] = (displacement & 0xF00) >> 8;
    instruction[6] = (displacement & 0xF0) >> 4;
    instruction[7] = displacement & 0xF;
}

void displacement(uint8* instruction, int displacement) {
    int mask = 0b1111;
    for(int i = 0; i < 3; i ++) {
        instruction[7 - i] = displacement & mask;
        mask <<= 4;
    }
}

int endian(int number) {
    unsigned int b0 = number & 0xFF, b1 = number & 0xFF00, b2 = number & 0xFF0000, b3 = number & 0xFF000000;
    int ret = 0;
    ret |= b0 << 24;
    ret |= b1 << 8;
    ret |= b2 >> 8;
    ret |= b3 >> 24;
    return ret;
}
