#ifndef CODES_HPP
#define CODES_HPP

#include <unordered_map>
#include <string>
#include "section.hpp"

class Codes {
    static std::unordered_map<std::string, uint8> memonics;
    static std::unordered_map<std::string, uint8> modifiers;
    static std::unordered_map<std::string, uint8> sysregs;
    static std::unordered_map<std::string, uint8> operators;
};

#endif //CODES_HPP
