//
// Created by ss on 5/6/24.
//

#include "../inc/codes.hpp"

std::unordered_map<std::string, uint8> Codes::memonic = {
    {"halt", 0b0000},
    {"push", 0b0001},
    {"call", 0b0010},
    {"jmp", 0b0011},
    {"beq", 0b0011},
    {"xchg", 0b0100},
    {"add", 0b0101},
    {"sub", 0b0101},
    {"mul", 0b0101},
    {"div", 0b0101},
    {"not", 0b0110},
    {"and", 0b0110},
    {"or", 0b0110},
    {"xor", 0b0110},
    {"shl", 0b0111},
    {"shr", 0b0111},
    {"st", 0b1000},
    {"ld", 0b1001},
    {"csrrd", 0b1001},
    {"csrwr", 0b1001}
};
