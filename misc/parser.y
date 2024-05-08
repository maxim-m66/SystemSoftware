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
    output << "section";
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
    output << "label   " << symbol_table.value($1);
};

ascii: ASCII STRING terminate {
    output << "ascii" << $1;
};

equ: EQU SYMBOL COMMA expression terminate {
    output << "equ " << $1 << " " << $2 << " " << $3;
};

inone: INONE terminate {
    fill(Codes::opcode[$1]);
    int word = Section::make_word(instruction);
    section->next() = word;
    std::bitset<32> binary(word);
    output << "inone  " << to_my_string(binary.to_string());
};

ret: RET terminate {
    fill(Codes::opcode[$1], Codes::mod[$1], Codes::reg["%pc"], Codes::reg["%sp"], 0, 1);
    int word = Section::make_word(instruction);
    section->next() = word;
    std::bitset<32> binary(word);
    output << "ret    " << to_my_string(binary.to_string());
};

iret: IRET terminate {
    fill(Codes::opcode[$1], Codes::mod[$1], Codes::reg["%status"], Codes::reg["%sp"], 0, 1);
    int word1 = Section::make_word(instruction);
    section->next() = word1;
    std::bitset<32> binary1(word1);
    fill(Codes::opcode["ret"], Codes::mod["ret"], Codes::reg["%pc"], Codes::reg["%sp"], 0, 1);
    int word = Section::make_word(instruction);
    section->next() = word;
    std::bitset<32> binary(word);
    output << "iret   " << to_my_string(binary1.to_string()) << to_my_string(binary.to_string());
};

jump: JUMP SYMBOL terminate {
    fill(Codes::opcode[$1], Codes::mod[$1]);
    int word = Section::make_word(instruction);
    section->next() = word;
    symbol_table.new_occurrence($2, section->get_name(), section->line());
    std::bitset<32> binary(word);
    output << "jump   " << to_my_string(binary.to_string());
} | JUMP INTEGER terminate {
    fill(Codes::opcode[$1], Codes::mod[$1], 0, 0, 0, to_int($2));
    int word = Section::make_word(instruction);
    section->next() = word;
    std::bitset<32> binary(word);
    output << "jump   " << to_my_string(binary.to_string());
};

branch: BRANCH REGISTER COMMA REGISTER COMMA SYMBOL terminate {
    fill(Codes::opcode[$1], Codes::mod[$1], 0, Codes::reg[$2], Codes::reg[$4]);
    int word = Section::make_word(instruction);
    section->next() = word;
    symbol_table.new_occurrence($6, section->get_name(), section->line());
    std::bitset<32> binary(word);
    output << "branch " << to_my_string(binary.to_string());
} | BRANCH REGISTER COMMA REGISTER COMMA INTEGER terminate {
    fill(Codes::opcode[$1], Codes::mod[$1], 0, Codes::reg[$2], Codes::reg[$4], to_int($6));
    int word = Section::make_word(instruction);
    section->next() = word;
    std::bitset<32> binary(word);
    output << "branch " << to_my_string(binary.to_string());
};

push: PUSH REGISTER terminate {
    fill(Codes::opcode[$1], Codes::mod[$1], Codes::reg["%sp"], 0, Codes::reg[$2], -1);
    int word = Section::make_word(instruction);
    section->next() = word;
    std::bitset<32> binary(word);
    output << "push   " << to_my_string(binary.to_string());
};

pop: POP REGISTER terminate {
    fill(Codes::opcode[$1], Codes::mod[$1], Codes::reg[$2], Codes::reg["%sp"], 0, 1);
    int word = Section::make_word(instruction);
    section->next() = word;
    std::bitset<32> binary(word);
    output << "pop    " << to_my_string(binary.to_string());
};

alo: ALO REGISTER COMMA REGISTER terminate {
    fill(Codes::opcode[$1], Codes::mod[$1], Codes::reg[$4], Codes::reg[$2], Codes::reg[$4]);
    int word = Section::make_word(instruction);
    section->next() = word;
    std::bitset<32> binary(word);
    output << "alo    " << to_my_string(binary.to_string());
};

xchg: XCHG REGISTER COMMA REGISTER {
    fill(Codes::opcode[$1], 0, 0, Codes::reg[$2], Codes::reg[$4]);
    int word = Section::make_word(instruction);
    section->next() = word;
    std::bitset<32> binary(word);
    output << "alo    " << to_my_string(binary.to_string());
};

not: NOT REGISTER {
    fill(Codes::opcode[$1], Codes::mod[$1], Codes::reg[$2], Codes::reg[$2]);
    int word = Section::make_word(instruction);
    section->next() = word;
    std::bitset<32> binary(word);
    output << "not    " << to_my_string(binary.to_string());
};

ld: LD IMMED INTEGER COMMA REGISTER terminate {
    fill(Codes::opcode[$1], Codes::mod["limmed"], Codes::reg[$5], 0, 0, to_int($3));
    int word = Section::make_word(instruction);
    section->next() = word;
    std::bitset<32> binary(word);
    output << "ld     " << to_my_string(binary.to_string());
}
    | LD IMMED SYMBOL COMMA REGISTER terminate {
    fill(Codes::opcode[$1], Codes::mod["limmed"], Codes::reg[$5]);
    int word = Section::make_word(instruction);
    section->next() = word;
    symbol_table.new_occurrence($3, section->get_name(), section->line());
    std::bitset<32> binary(word);
    output << "ld     " << to_my_string(binary.to_string());
}
    | LD INTEGER COMMA REGISTER terminate {
    fill(Codes::opcode[$1], Codes::mod["lmem"], Codes::reg[$4], 0, 0, to_int($2));
    int word = Section::make_word(instruction);
    section->next() = word;
    std::bitset<32> binary(word);
    output << "ld     " << to_my_string(binary.to_string());
}
    | LD SYMBOL COMMA REGISTER terminate {
    fill(Codes::opcode[$1], Codes::mod["lmem"], Codes::reg[$4]);
    int word = Section::make_word(instruction);
    section->next() = word;
    symbol_table.new_occurrence($2, section->get_name(), section->line());
    std::bitset<32> binary(word);
    output << "ld     " << to_my_string(binary.to_string());
}
    | LD REGISTER COMMA REGISTER terminate {
    fill(Codes::opcode[$1], Codes::mod["lreg"], Codes::reg[$4], Codes::reg[$2]);
    int word = Section::make_word(instruction);
    section->next() = word;
    std::bitset<32> binary(word);
    output << "ld     " << to_my_string(binary.to_string());
}   | LD LBRACKET REGISTER RBRACKET COMMA REGISTER terminate {
    fill(Codes::opcode[$1], Codes::mod["lmem"], Codes::reg[$6], Codes::reg[$3]);
    int word = Section::make_word(instruction);
    section->next() = word;
    std::bitset<32> binary(word);
    output << "ld     " << to_my_string(binary.to_string());
}   | LD LBRACKET REGISTER OPERATOR INTEGER RBRACKET COMMA REGISTER terminate {
    fill(Codes::opcode[$1], Codes::mod["lmem"], Codes::reg[$8], Codes::reg[$3], 0, to_int($5));
    int word = Section::make_word(instruction);
    section->next() = word;
    std::bitset<32> binary(word);
    output << "ld     " << to_my_string(binary.to_string());
}   | LD LBRACKET REGISTER OPERATOR SYMBOL RBRACKET COMMA REGISTER terminate {
    fill(Codes::opcode[$1], Codes::mod["lmem"], Codes::reg[$8], Codes::reg[$3]);
    int word = Section::make_word(instruction);
    section->next() = word;
    symbol_table.new_occurrence($5, section->get_name(), section->line());
    std::bitset<32> binary(word);
    output << "ld     " << to_my_string(binary.to_string());
};

st: ST REGISTER COMMA INTEGER terminate {
    fill(Codes::opcode[$1], Codes::mod[$1], 0, 0, Codes::reg[$2], to_int($4));
    int word = Section::make_word(instruction);
    section->next() = word;
    std::bitset<32> binary(word);
    output << "st     " << to_my_string(binary.to_string());
}   | ST REGISTER COMMA SYMBOL terminate {
    fill(Codes::opcode[$1], Codes::mod[$1], 0, 0, Codes::reg[$2]);
    int word = Section::make_word(instruction);
    section->next() = word;
    symbol_table.new_occurrence($4, section->get_name(), section->line());
    std::bitset<32> binary(word);
    output << "st     " << to_my_string(binary.to_string());
}   | ST REGISTER COMMA REGISTER terminate {
    fill(Codes::opcode["ld"], Codes::mod["lreg"], Codes::reg[$4], Codes::reg[$2]);
    int word = Section::make_word(instruction);
    section->next() = word;
    std::bitset<32> binary(word);
    output << "ld     " << to_my_string(binary.to_string());
}   | ST REGISTER COMMA LBRACKET REGISTER RBRACKET terminate {
    fill(Codes::opcode[$1], Codes::mod[$1], Codes::reg[$5], 0, Codes::reg[$2]);
    int word = Section::make_word(instruction);
    section->next() = word;
    std::bitset<32> binary(word);
    output << "ld     " << to_my_string(binary.to_string());
}   | ST REGISTER COMMA LBRACKET REGISTER OPERATOR INTEGER RBRACKET terminate {
    fill(Codes::opcode[$1], Codes::mod[$1], Codes::reg[$5], 0, Codes::reg[$2], to_int($7));
    int word = Section::make_word(instruction);
    section->next() = word;
    std::bitset<32> binary(word);
    output << "ld     " << to_my_string(binary.to_string());
}   | ST REGISTER COMMA LBRACKET REGISTER OPERATOR SYMBOL RBRACKET terminate {
    fill(Codes::opcode[$1], Codes::mod[$1], Codes::reg[$5], 0, Codes::reg[$2]);
    int word = Section::make_word(instruction);
    section->next() = word;
    symbol_table.new_occurrence($7, section->get_name(), section->line());
    std::bitset<32> binary(word);
    output << "ld     " << to_my_string(binary.to_string());
}
;

csrrd: CSRRD SYSREG COMMA REGISTER terminate {
    fill(Codes::opcode[$1], Codes::mod[$1], Codes::reg[$2], Codes::reg[$4]);
    int word = Section::make_word(instruction);
    section->next() = word;
    std::bitset<32> binary(word);
    output << "csrrd  " << to_my_string(binary.to_string());
};

csrwr: CSRWR REGISTER COMMA SYSREG terminate {
    fill(Codes::opcode[$1], Codes::mod[$1], Codes::reg[$2], Codes::reg[$4]);
    int word = Section::make_word(instruction);
    section->next() = word;
    std::bitset<32> binary(word);
    output << "csrwr  " << to_my_string(binary.to_string());
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