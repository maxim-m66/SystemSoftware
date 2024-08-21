#include "../inc/section.hpp"
#include "../inc/symbol_table.hpp"

#include <ostream>
#include <bitset>
#include <iostream>


extern std::string to_my_string(std::string binary);

extern int endian(int);

extern std::vector<std::string> mnemonics;

std::string to_my_string(std::string);

Section::Section(const std::string &name, int name_offset) : name(name), line_count(0), name_offset(name_offset) {}

std::unordered_map<std::string, Section *> Section::sections({{".strtab", new StringSection(0)}});

uint32 &Section::next() {
    this->ascii_byte = 0;
    this->words.push_back(0);
    this->line_count++;
    return this->words.back();
}

void Section::ascii(std::string &string) {
    int end = string.size() - 1;
    int start = 1;
    if (this->ascii_byte != 0) {
        uint32 last = this->words.back();
        uint32 next = 0;
        while (this->ascii_byte > 0) {
            next <<= 8;
            next |= string[start++];
            this->ascii_byte--;
        }
        this->words.back() = last | next;
    }
    for (int i = start; i < end; i += 4) {
        int c0 = 0, c1 = 0, c2 = 0, c3 = 0;
        c0 = string[i];
        if (i + 1 >= end) {
            this->ascii_byte = 3;
        } else if (i + 2 >= end) {
            c1 = string[i + 1];
            this->ascii_byte = 2;
        } else if (i + 3 >= end) {
            c1 = string[i + 1];
            c2 = string[i + 2];
            this->ascii_byte = 1;
        } else {
            c1 = string[i + 1];
            c2 = string[i + 2];
            c3 = string[i + 3];
            this->ascii_byte = 0;
        }
        this->line_count++;
        this->words.push_back((c0 << 24) | (c1 << 16) | (c2 << 8) | c3);
    }
}

void Section::symbolise(int index, int value, bool whole) {
    if (whole) {
        this->words[index] = endian(value);
    } else {
        value = value & 0xFFF;
        this->words[index] |= value;
    }
}

Section *Section::get_section(const std::string &name) {
    if (Section::sections.find(name) == Section::sections.end()) {
        Section::sections[name] = new Section(name, get_strings()->line());
        get_strings()->add(name);
    }
    return Section::sections[name];
}

std::vector<Section *> &Section::get_sections() {
    std::vector<Section *> *result = new std::vector<Section *>();
    for (auto &pair: Section::sections) {
        result->push_back(pair.second);
    }
    return *result;
}

uint32 Section::make_word(uint8 *nibbles) {
    uint32 word = 0;
    for (int i = 0; i < 8; i++) {
        word <<= 4;
        word |= nibbles[i];
        nibbles[i] = 0;
    }
    return word;
}

void Section::flush(std::ostream &out) {
    for (auto &pair: Section::sections) {
        out << *pair.second;
    }
}

std::ostream &operator<<(std::ostream &out, const Section &section) {
    for (const uint32 word: section.words) {
        std::bitset<32> binary(word);
        out << to_my_string(binary.to_string()) << std::endl;
    }
    return out;
}

void Section::set_jumps() {
    for (auto &pair: sections) {
        Section *section = pair.second;
        for (auto &jump: section->jumps) {
            if (jump.value == -1) {
                SymbolTable::get_table().new_occurrence(jump.symbol, pair.first, section->line(), true);
                section->next() = 0;
            } else {
                section->next() = endian(jump.value);
            }
            section->symbolise(jump.line, (section->line() - jump.line - 2) * 4);
        }
    }
}

std::ostream &operator<<(std::ostream &out, const StringSection &section) {
    for (const uint32 word: section.words) {
        out << static_cast<char>(word & 0xFF);
    }
    out << std::endl;
    return out;
}

void StringSection::add(const std::string &string) {
    for (const char c: string) {
        this->next() = c;
    }
}

StringSection::StringSection(int name_offset) : Section(".strtab", name_offset) {
    this->add(".strtab");
}
