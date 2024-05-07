#ifndef CODES_HPP
#define CODES_HPP

#include <unordered_map>
#include <string>
#include "section.hpp"

class Codes {
public:
    static std::unordered_map<std::string, uint8> opcode;
    static std::unordered_map<std::string, uint8> mod;
    static std::unordered_map<std::string, uint8> reg;
};

#endif //CODES_HPP
