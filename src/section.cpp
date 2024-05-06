#include "../inc/section.hpp"

Section::Section() : line_count(0) {}

uint32& Section::next() {
    this->words.push_back(0);
    return this->words.back();
}