%{
#include <stdio.h>
#include <string.h>
#include <fstream>
#include <iostream>
#include "../inc/lexer.hpp"
#include "../inc/section.hpp"
#include "../inc/codes.hpp"
#include <bitset>

extern std::ofstream output;

Section &section = Section::get_section("aaa");

uint8 instruction[8] = {};

int to_int(const char *);

void fill(uint8 opcode, uint8 mod = 0, uint8 a = 0, uint8 b = 0, uint8 c = 0, int displacement = 0);

void displacement(uint8* instruction, int displacement);

void yyerror(const char *s);
%}

%union {
    const char *str;
}

%token<str> END GLOBAL EXTERN SECTION WORD SKIP ASCII EQU //directives
%token<str> INONE RET IRET JUMP BRANCH PUSH POP ALO XCHG NOT LD ST CSRRD CSRWR //instructions
%token<str> SYMBOL INTEGER REGISTER SYSREG IMMED REGIND REGINDREL //operand types
%token<str> COMMA STRING LABEL COMMENT OPERATOR //miscellaneous
%token<str> NEWLINE
%token<str> ERROR

%%

line: label | instruction | label instruction | directive | terminate;

instruction: inone | ret | iret | jump | branch | push | pop | alo | xchg | not | ld | st | csrrd | csrwr;

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
    output << "ascii" << $1;
};

equ: EQU SYMBOL COMMA expression terminate {
    output << "equ " << $1 << " " << $2 << " " << $3;
};

inone: INONE terminate {
    fill(Codes::opcode[$1]);
    int word = Section::make_word(instruction);
    section.next() = word;
    std::bitset<32> binary(word);
    output << "inone " << binary.to_string();
};

ret: RET terminate {
    fill(Codes::opcode[$1], Codes::mod[$1], Codes::reg["pc"], Codes::reg["sp"], 0, 1);
    int word = Section::make_word(instruction);
    section.next() = word;
    std::bitset<32> binary(word);
    output << "inone " << binary.to_string();
};

iret: IRET terminate {
    fill(Codes::opcode[$1], Codes::mod[$1], Codes::reg["pc"], Codes::reg["sp"], 0, 1);
    int word = Section::make_word(instruction);
    section.next() = word;
    std::bitset<32> binary(word);
    output << "iret " << binary.to_string();
};

jump: JUMP value terminate {
    fill(Codes::opcode[$1], Codes::mod[$1]);
    int word = Section::make_word(instruction);
    section.next() = word;
    std::bitset<32> binary(word);
    output << "jump " << binary.to_string();
} | JUMP IMMED terminate {
    const char *number = $2 + 1;
    fill(Codes::opcode[$1], Codes::mod[$1], 0, 0, 0, to_int(number));
    int word = Section::make_word(instruction);
    section.next() = word;
    std::bitset<32> binary(word);
    output << "jump " << binary.to_string();
};

branch: BRANCH REGISTER COMMA REGISTER COMMA value terminate {
    fill(Codes::opcode[$1], Codes::mod[$1], 0, Codes::reg[$2], Codes::reg[$4]);
    int word = Section::make_word(instruction);
    section.next() = word;
    std::bitset<32> binary(word);
    output << "branch " << binary.to_string();
} | BRANCH REGISTER COMMA REGISTER COMMA IMMED terminate {
    const char *number = $6 + 1;
    fill(Codes::opcode[$1], Codes::mod[$1], 0, Codes::reg[$2], Codes::reg[$4], to_int(number));
    int word = Section::make_word(instruction);
    section.next() = word;
    std::bitset<32> binary(word);
    output << "branch " << binary.to_string();
};

push: PUSH REGISTER terminate {
    fill(Codes::opcode[$1], Codes::mod[$1], Codes::reg["sp"], 0, Codes::reg[$2], -1);
    int word = Section::make_word(instruction);
    section.next() = word;
    std::bitset<32> binary(word);
    output << "push " << binary.to_string();
};

pop: POP REGISTER terminate {
    fill(Codes::opcode[$1], Codes::mod[$1], Codes::reg[$2], Codes::reg["sp"], 0, 1);
    int word = Section::make_word(instruction);
    section.next() = word;
    std::bitset<32> binary(word);
    output << "pop " << binary.to_string();
};

alo: ALO REGISTER COMMA REGISTER terminate {
    fill(Codes::opcode[$1], Codes::mod[$1], Codes::reg[$4], Codes::reg[$2], Codes::reg[$4]);
    int word = Section::make_word(instruction);
    section.next() = word;
    std::bitset<32> binary(word);
    output << "alo " << binary.to_string();
};

xchg: XCHG REGISTER COMMA REGISTER {
    fill(Codes::opcode[$1], 0, 0, Codes::reg[$2], Codes::reg[$4]);
    int word = Section::make_word(instruction);
    section.next() = word;
    std::bitset<32> binary(word);
    output << "alo " << binary.to_string();
};

not: NOT REGISTER {
    fill(Codes::opcode[$1], Codes::opcode[$1], Codes::reg[$2], Codes::reg[$2]);
    int word = Section::make_word(instruction);
    section.next() = word;
    std::bitset<32> binary(word);
    output << "not " << binary.to_string();
};

ld: LD IMMED COMMA REGISTER terminate {
         
    section.next() = Section::make_word(instruction);
    output << "ld";
}
    | LD SYMBOL COMMA REGISTER terminate {
         
    section.next() = Section::make_word(instruction);
    output << "ld";
};

st: ST REGISTER COMMA SYMBOL terminate {
         
    section.next() = Section::make_word(instruction);
    output << "st";
};

csrrd: CSRRD SYSREG COMMA REGISTER terminate {
    fill(Codes::opcode[$1], Codes::mod[$1], Codes::reg[$2], Codes::reg[$4]);
    int word = Section::make_word(instruction);
    section.next() = word;
    std::bitset<32> binary(word);
    output << "csrwr  " << binary.to_string();
};

csrwr: CSRWR REGISTER COMMA SYSREG terminate {
    fill(Codes::opcode[$1], Codes::mod[$1], Codes::reg[$2], Codes::reg[$4]);
    int word = Section::make_word(instruction);
    section.next() = word;
    std::bitset<32> binary(word);
    output << "csrwr  " << binary.to_string();
};

label: LABEL terminate {
    output << "label";
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