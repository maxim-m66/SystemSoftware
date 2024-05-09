%{
#include <stdio.h>
#include <string.h>
#include <fstream>
#include <iostream>
#include "../inc/symbol_table.hpp"
#include "../inc/lexer.hpp"
#include "../inc/section.hpp"
#include "../inc/codes.hpp"
#include <bitset>

extern std::ofstream output;

Section *section = Section::get_section("");

SymbolTable &symbol_table = SymbolTable::get_table();

std::vector<std::string> symbols;

std::vector<std::string> mnemonics;

uint8 instruction[8] = {};

int to_int(const char *);

void fill(uint8 opcode, uint8 mod = 0, uint8 a = 0, uint8 b = 0, uint8 c = 0, int displacement = 0);

void displacement(uint8* instruction, int displacement);

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

line: label | instruction | label instruction | directive | terminate;

instruction: inone | ret | iret | jump | branch | push | pop | alo | xchg | not | ld | st | csrrd | csrwr;

directive: global | extern | section | word | skip | ascii | equ | end;

symbol_list: SYMBOL {
    symbols.push_back($1);
}
| symbol_list COMMA SYMBOL {
    symbols.push_back($3);
};

value: SYMBOL | INTEGER;

values_list: value | values_list COMMA value;

expression: value | value OPERATOR expression;

terminate: COMMENT |;

end: END terminate {
    output << "end";
};

global: GLOBAL symbol_list terminate {
    for (std::string symbol : symbols) {
        Section::get_global().push_back(symbol);
    }
    symbols.clear();
    output << "global";
};

extern: EXTERN symbol_list terminate {
    for (std::string symbol : symbols) {
        Section::get_extern().push_back(symbol);
    }
    symbols.clear();
    output << "extern";
};

section: SECTION SYMBOL terminate {
    section = Section::get_section($2);
};

word: WORD values_list terminate {
    output << "word";
};

skip: SKIP value terminate {
    output << "skip";
};

label: SYMBOL LABEL terminate {
    if (!symbol_table.has_symbol($1)) {
        symbol_table.insert_symbol($1);
    }
    if (symbol_table.has_value($1)) {
        throw "Symbol already defined";
    }
    symbol_table.value($1) = section->line()*4;
    symbol_table.section($1) = section->get_name();
};

ascii: ASCII STRING terminate {
    output << "ascii" << $1;
};

equ: EQU SYMBOL COMMA expression terminate {
    output << "equ " << $1 << " " << $2 << " " << $3;
};

inone: INONE terminate {
    fill(Codes::opcode[$1]);
    section->next() = Section::make_word(instruction);
};

ret: RET terminate {
    fill(Codes::opcode[$1], Codes::mod[$1], Codes::reg["%pc"], Codes::reg["%sp"], 0, 1);
    section->next() = Section::make_word(instruction);
};

iret: IRET terminate {
    fill(Codes::opcode[$1], Codes::mod[$1], Codes::reg["%status"], Codes::reg["%sp"], 0, 1);
    section->next() = Section::make_word(instruction);
    fill(Codes::opcode["ret"], Codes::mod["ret"], Codes::reg["%pc"], Codes::reg["%sp"], 0, 1);
    section->next() = Section::make_word(instruction);
};

jump: JUMP SYMBOL terminate {
    symbol_table.new_occurrence($2, section->get_name(), section->line());
    fill(Codes::opcode[$1], Codes::mod[$1]);
    section->next() = Section::make_word(instruction);
}
    | JUMP INTEGER terminate {
    fill(Codes::opcode[$1], Codes::mod[$1], 0, 0, 0, to_int($2));
    section->next() = Section::make_word(instruction);
};

branch: BRANCH REGISTER COMMA REGISTER COMMA SYMBOL terminate {
    symbol_table.new_occurrence($6, section->get_name(), section->line());
    fill(Codes::opcode[$1], Codes::mod[$1], 0, Codes::reg[$2], Codes::reg[$4]);
    section->next() = Section::make_word(instruction);
}
    | BRANCH REGISTER COMMA REGISTER COMMA INTEGER terminate {
    fill(Codes::opcode[$1], Codes::mod[$1], 0, Codes::reg[$2], Codes::reg[$4], to_int($6));
    section->next() = Section::make_word(instruction);
};

push: PUSH REGISTER terminate {
    fill(Codes::opcode[$1], Codes::mod[$1], Codes::reg["%sp"], 0, Codes::reg[$2], -1);
    section->next() = Section::make_word(instruction);
};

pop: POP REGISTER terminate {
    fill(Codes::opcode[$1], Codes::mod[$1], Codes::reg[$2], Codes::reg["%sp"], 0, 1);
    section->next() = Section::make_word(instruction);
};

alo: ALO REGISTER COMMA REGISTER terminate {
    fill(Codes::opcode[$1], Codes::mod[$1], Codes::reg[$4], Codes::reg[$2], Codes::reg[$4]);
    section->next() = Section::make_word(instruction);
};

xchg: XCHG REGISTER COMMA REGISTER {
    fill(Codes::opcode[$1], 0, 0, Codes::reg[$2], Codes::reg[$4]);
    section->next() = Section::make_word(instruction);
};

not: NOT REGISTER {
    fill(Codes::opcode[$1], Codes::mod[$1], Codes::reg[$2], Codes::reg[$2]);
    section->next() = Section::make_word(instruction);
};

ld: LD IMMED INTEGER COMMA REGISTER terminate {
    fill(Codes::opcode[$1], Codes::mod["limmed"], Codes::reg[$5], 0, 0, to_int($3));
    section->next() = Section::make_word(instruction);
}
    | LD IMMED SYMBOL COMMA REGISTER terminate {
    symbol_table.new_occurrence($3, section->get_name(), section->line());
    fill(Codes::opcode[$1], Codes::mod["limmed"], Codes::reg[$5]);
    section->next() = Section::make_word(instruction);
}
    | LD INTEGER COMMA REGISTER terminate {
    fill(Codes::opcode[$1], Codes::mod["lmem"], Codes::reg[$4], 0, 0, to_int($2));
    section->next() = Section::make_word(instruction);
}
    | LD SYMBOL COMMA REGISTER terminate {
    symbol_table.new_occurrence($2, section->get_name(), section->line());
    fill(Codes::opcode[$1], Codes::mod["lmem"], Codes::reg[$4]);
    section->next() = Section::make_word(instruction);
}
    | LD REGISTER COMMA REGISTER terminate {
    fill(Codes::opcode[$1], Codes::mod["lreg"], Codes::reg[$4], Codes::reg[$2]);
    section->next() = Section::make_word(instruction);
}
    | LD LBRACKET REGISTER RBRACKET COMMA REGISTER terminate {
    fill(Codes::opcode[$1], Codes::mod["lmem"], Codes::reg[$6], Codes::reg[$3]);
    section->next() = Section::make_word(instruction);
}
    | LD LBRACKET REGISTER OPERATOR INTEGER RBRACKET COMMA REGISTER terminate {
    fill(Codes::opcode[$1], Codes::mod["lmem"], Codes::reg[$8], Codes::reg[$3], 0, to_int($5));
    section->next() = Section::make_word(instruction);
}
    | LD LBRACKET REGISTER OPERATOR SYMBOL RBRACKET COMMA REGISTER terminate {
    symbol_table.new_occurrence($5, section->get_name(), section->line());
    fill(Codes::opcode[$1], Codes::mod["lmem"], Codes::reg[$8], Codes::reg[$3]);
    section->next() = Section::make_word(instruction);
};

st: ST REGISTER COMMA INTEGER terminate {
    fill(Codes::opcode[$1], Codes::mod[$1], 0, 0, Codes::reg[$2], to_int($4));
    section->next() = Section::make_word(instruction);
}
    | ST REGISTER COMMA SYMBOL terminate {
    symbol_table.new_occurrence($4, section->get_name(), section->line());
    fill(Codes::opcode[$1], Codes::mod[$1], 0, 0, Codes::reg[$2]);
    section->next() = Section::make_word(instruction);
}
    | ST REGISTER COMMA REGISTER terminate {
    fill(Codes::opcode["ld"], Codes::mod["lreg"], Codes::reg[$4], Codes::reg[$2]);
    section->next() = Section::make_word(instruction);
}
    | ST REGISTER COMMA LBRACKET REGISTER RBRACKET terminate {
    fill(Codes::opcode[$1], Codes::mod[$1], Codes::reg[$5], 0, Codes::reg[$2]);
    section->next() = Section::make_word(instruction);
}
    | ST REGISTER COMMA LBRACKET REGISTER OPERATOR INTEGER RBRACKET terminate {
    fill(Codes::opcode[$1], Codes::mod[$1], Codes::reg[$5], 0, Codes::reg[$2], to_int($7));
    section->next() = Section::make_word(instruction);
}
    | ST REGISTER COMMA LBRACKET REGISTER OPERATOR SYMBOL RBRACKET terminate {
    symbol_table.new_occurrence($7, section->get_name(), section->line());
    fill(Codes::opcode[$1], Codes::mod[$1], Codes::reg[$5], 0, Codes::reg[$2]);
    section->next() = Section::make_word(instruction);
};

csrrd: CSRRD SYSREG COMMA REGISTER terminate {
    fill(Codes::opcode[$1], Codes::mod[$1], Codes::reg[$2], Codes::reg[$4]);
    section->next() = Section::make_word(instruction);
};

csrwr: CSRWR REGISTER COMMA SYSREG terminate {
    fill(Codes::opcode[$1], Codes::mod[$1], Codes::reg[$2], Codes::reg[$4]);
    section->next() = Section::make_word(instruction);
};

%%

void yyerror(const char *s) {
    output << s;
    fprintf(stderr, "error: %s", s);
}

static std::unordered_map<char, int> digits = {
    {'0', 0}, {'1', 1}, {'2', 2}, {'3', 3}, {'4', 4},
    {'5', 5}, {'6', 6}, {'7', 7}, {'8', 8}, {'9', 9},
    {'A', 10}, {'B', 11}, {'C', 12}, {'D', 13}, {'E', 14}, {'F', 15},
    {'a', 10}, {'b', 11}, {'c', 12}, {'d', 13}, {'e', 14}, {'f', 15}
};

int to_int(const char *string) {
    int base = 10;
    int start = 0;
    int end = strlen(string);
    if (end < 3);
    else if (string[1] == 'h') base = 16;
    else if (string[1] == 'o') base = 8;
    else if (string[1] == 'b') base = 2;
    if (base != 10) start = 2;
    int ret = digits[string[start]];
    for(int i = start + 1; i < end; i++)
        ret = ret*base + digits[string[i]];
    return ret;
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

std::string to_my_string(std::string binary) {
    std::string ret = "";
    for(int i = 0; i < 32; i ++) {
        if (i % 4 == 0) ret += " ";
        ret += binary[i];
    }
    return ret;
}