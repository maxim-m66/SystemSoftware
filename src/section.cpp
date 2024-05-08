#include "../inc/section.hpp"

#include <ostream>
#include <bitset>

Section::Section(const std::string& name): name(name), line_count(0) {}

std::unordered_map<std::string, Section*> Section::sections;

std::vector<std::string> Section::_extern;

std::vector<std::string> Section::_global;

uint32& Section::next() {
    this->words.push_back(0);
    this->line_count++;
    return this->words.back();
}

void Section::symbolise(int index, uint32 value) {
    if (value > 2 ^ 12) {
        throw std::runtime_error("Symbol value too large");
    }
    value = value & 0xFFF;
    this->words[index] |= value;
}

Section* Section::get_section(const std::string& name) {
    if (Section::sections.find(name) == Section::sections.end()) {
        Section::sections[name] = new Section(name);
    }
    return Section::sections[name];
}

uint32 Section::make_word(uint8* nibbles) {
    uint32 word = 0;
    for (int i = 0; i < 8; i++) {
        word <<= 4;
        word |= nibbles[i];
        nibbles[i] = 0;
    }
    return word;
}

std::ostream& operator<<(std::ostream& os, const Section& section) {
    os << section.name << std::endl;
    for (const uint32 word : section.words) {
        std::bitset<32> binary(word);
        os << binary.to_string() << std::endl;
    }
    return os;
}
