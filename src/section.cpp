#include "../inc/section.hpp"

#include <ostream>
#include <bitset>
#include <iostream>

extern std::vector<std::string> mnemonics;

std::string to_my_string(std::string);

Section::Section(const std::string& name, int name_offset): name(name), line_count(0), name_offset(name_offset) {}

std::unordered_map<std::string, Section*> Section::sections({{".strtab", new StringSection(0)}});

std::vector<std::string> Section::_extern;

std::vector<std::string> Section::_global;

uint32& Section::next() {
    this->words.push_back(0);
    this->line_count++;
    return this->words.back();
}

void Section::symbolise(int index, int value) {
    if (value > 1 << 12) {
        throw std::runtime_error("Symbol value too large");
    }
    value = value & 0xFFF;
    this->words[index] |= value;
}

Section* Section::get_section(const std::string& name) {
    if (Section::sections.find(name) == Section::sections.end()) {
        Section::sections[name] = new Section(name, get_strings()->line());
        get_strings()->add(name);
    }
    return Section::sections[name];
}

std::vector<Section*>& Section::get_sections() {
    std::vector<Section*>* result = new std::vector<Section*>();
    for (auto& pair : Section::sections) {
        result->push_back(pair.second);
    }
    return *result;
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

void Section::flush(std::ostream& out) {
    for (auto& pair : Section::sections) {
        out << *pair.second;
    }
}

std::ostream& operator<<(std::ostream& out, const Section& section) {
    for (const uint32 word : section.words) {
        std::bitset<32> binary(word);
        out << binary.to_string() << std::endl;
    }
    return out;
}

std::ostream& operator<<(std::ostream& out, const StringSection& section) {
    for (const uint32 word : section.words) {
        out << static_cast<char>(word & 0xFF);
    }
    return out;
}

void StringSection::add(const std::string& string) {
    for (const char c : string) {
        this->next() = c;
    }
}

StringSection::StringSection(int name_offset) : Section(".strtab", name_offset) {
    this->add(".strtab");
}
