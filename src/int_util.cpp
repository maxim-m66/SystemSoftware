#include <string>
#include <cstring>
#include <unordered_map>
#include "../inc/int_util.hpp"

static std::unordered_map<char, int> digits = {
        {'0', 0},
        {'1', 1},
        {'2', 2},
        {'3', 3},
        {'4', 4},
        {'5', 5},
        {'6', 6},
        {'7', 7},
        {'8', 8},
        {'9', 9},
        {'A', 10},
        {'B', 11},
        {'C', 12},
        {'D', 13},
        {'E', 14},
        {'F', 15},
        {'a', 10},
        {'b', 11},
        {'c', 12},
        {'d', 13},
        {'e', 14},
        {'f', 15}
};

std::string to_my_string(std::string binary) {
    std::string ret = "";
    for (int i = 0; i < 32; i++) {
        if (i % 8 == 0 and i > 0) ret += " ";
        ret += binary[i];
    }
    return ret;
}

int to_int(std::string s) {
    return to_int(s.c_str());
}

int to_int(const char *string) {
    int base = 10;
    int start = 0;
    int end = strlen(string);
    if (end < 3);
    else if (string[1] == 'x') base = 16;
    else if (string[1] == 'o') base = 8;
    else if (string[1] == 'b') base = 2;
    if (base != 10) start = 2;
    int ret = digits[string[start]];
    for (int i = start + 1; i < end; i++)
        ret = ret * base + digits[string[i]];
    return ret;
}