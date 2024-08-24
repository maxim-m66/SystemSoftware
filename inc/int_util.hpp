#ifndef RESENJE_INT_UTIL_HPP
#define RESENJE_INT_UTIL_HPP

#include <string>

typedef unsigned long uint64;

typedef unsigned int uint32;

typedef unsigned short uint16;

typedef unsigned char uint8;

std::string to_my_string(std::string binary);

long to_int(std::string s);

long to_int(const char *string);

#endif //RESENJE_INT_UTIL_HPP
