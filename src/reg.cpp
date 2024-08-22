#include <iostream>
#include "../inc/reg.hpp"

reg &reg::operator=(const reg &right) {
    this->value = right.value;
    return *this;
}

reg &reg::operator=(int value) {
    this->value = value;
    return *this;
}

bool reg::operator==(const reg &right) {
    return this->value == right.value;
}

bool reg::operator==(int value) {
    return this->value == value;
}

bool reg::operator>(const reg &right) {
    return this->value > right.value;
}

bool reg::operator>(int value) {
    return this->value > value;
}

reg0 &reg0::operator=(const reg &right) {
    return *this;
}

reg0 &reg0::operator=(const int value) {
    return *this;
}

register_file::register_file(bool system) : len(system ? 3 : 16) {
    registers = new reg *[len];
    registers[0] = (system ? new reg(0) : new reg0());
    for (int i = 1; i < len; i++) {
        registers[i] = new reg(0);
    }
}

reg &register_file::operator[](int i) {
    if (i < 0 or i >= len)
        std::cerr << "Register out of bounds" << std::endl;
    return *registers[i];
}
