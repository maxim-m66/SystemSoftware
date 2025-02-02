//
// Created by ss on 5/6/24.
//

#include "../inc/codes.hpp"

std::unordered_map<std::string, uint8> Codes::opcode = {
        {"halt",  0b0000},
        {"int",   0b0001},
        {"iret",  0b1001},
        {"call",  0b0010},
        {"ret",   0b1001},
        {"jmp",   0b0011},
        {"beq",   0b0011},
        {"bne",   0b0011},
        {"bgt",   0b0011},
        {"push",  0b1000},
        {"pop",   0b1001},
        {"xchg",  0b0100},
        {"add",   0b0101},
        {"sub",   0b0101},
        {"mul",   0b0101},
        {"div",   0b0101},
        {"not",   0b0110},
        {"and",   0b0110},
        {"or",    0b0110},
        {"xor",   0b0110},
        {"shl",   0b0111},
        {"shr",   0b0111},
        {"st",    0b1000},
        {"ld",    0b1001},
        {"csrrd", 0b1001},
        {"csrwr", 0b1001}
};

std::unordered_map<std::string, uint8> Codes::mod{
        {"iret",      0b0111},
        {"call",      0b0001},
        {"ret",       0b0011},
        {"jmp",       0b1000},
        {"beq",       0b1001},
        {"bne",       0b1010},
        {"bgt",       0b1011},
        {"xchg",      0b0000},
        {"add",       0b0000},
        {"sub",       0b0001},
        {"mul",       0b0010},
        {"div",       0b0011},
        {"not",       0b0000},
        {"and",       0b0001},
        {"or",        0b0010},
        {"xor",       0b0011},
        {"shl",       0b0000},
        {"shr",       0b0001},
        {"st",        0b0000},
        {"push",      0b0001},
        {"csrrd",     0b0000},
        {"mv",        0b0001},
        {"regindrel", 0b0010},
        {"csrwr",     0b0100},
        {"pop",       0b0011},
        {"ret",       0b0011},
        {"iret",      0b0011},
        {"limmed",    0b0010},
        {"lreg",      0b0001},
        {"lmem",      0b0010},
        {"st",        0b0000},
        {"stdir",     0b0010}
};

std::unordered_map<std::string, uint8> Codes::reg{
        {"%r0",      0b0000},
        {"%status",  0b0000},
        {"%r1",      0b0001},
        {"%handler", 0b0001},
        {"%r2",      0b0010},
        {"%cause",   0b0010},
        {"%r3",      0b0011},
        {"%r4",      0b0100},
        {"%r5",      0b0101},
        {"%r6",      0b0110},
        {"%r7",      0b0111},
        {"%r8",      0b1000},
        {"%r9",      0b1001},
        {"%r10",     0b1010},
        {"%r11",     0b1011},
        {"%r12",     0b1100},
        {"%r13",     0b1101},
        {"%r14",     0b1110},
        {"%sp",      0b1110},
        {"%r15",     0b1111},
        {"%pc",      0b1111}
};