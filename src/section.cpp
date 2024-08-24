#include "../inc/section.hpp"
#include "../inc/symbol_table.hpp"

#include <ostream>
#include <bitset>
#include <iostream>


extern std::string to_my_string(std::string binary);

extern int endian(int);

extern std::vector<std::string> mnemonics;

std::string to_my_string(std::string);

Section::Section(const std::string &name) : name(name), byte_count(0) {}

std::unordered_map<std::string, Section *> Section::sections;
std::vector<std::string> Section::section_order;
int Section::txt_called = 0;

void Section::next_word(uint32 word) {
    this->byte_count += 4;
    uint32 b0 = word & 0xFF, b1 = word & 0xFF00, b2 = word & 0xFF0000, b3 = word & 0xFF000000;
    this->bytes.push_back(b3 >> 24);
    this->bytes.push_back(b2 >> 16);
    this->bytes.push_back(b1 >> 8);
    this->bytes.push_back(b0);
}

void Section::next_byte(uint8 byte) {
    this->byte_count += 1;
    this->bytes.push_back(byte);
}

void Section::ascii(std::string &string) {
    int end = string.size() - 1;
    int start = 1;
    for (int i = start; i < end; i++) {
        this->next_byte(string[i]);
    }
}

void Section::symbolise(int index, int value, bool whole) {
    if (whole) {
        uint32 b0 = value & 0xFF, b1 = value & 0xFF00, b2 = value & 0xFF0000, b3 = value & 0xFF000000;
        this->bytes[index + 3] = b3 >> 24;
        this->bytes[index + 2] = b2 >> 16;
        this->bytes[index + 1] = b1 >> 8;
        this->bytes[index] = b0;
    } else {
        uint32 halfbyte = value & 0xF00, byte = value & 0xFF;
        this->bytes[index + 2] |= (halfbyte >> 8);
        this->bytes[index + 3] = byte;
    }
}

Section *Section::get_section(const std::string &name) {
    if (name == "txt") {
        if (txt_called == 0) {
            txt_called = 1;
            Section::sections[name] = new Section(name);
        } else if (txt_called == 1 && Section::sections["txt"]->line() == 0) {
            txt_called = 2;
            section_order.push_back(name);
        }
    } else {
        if (Section::sections.find(name) == Section::sections.end()) {
            Section::sections[name] = new Section(name);
            section_order.push_back(name);
        }
    }
    return Section::sections[name];
}

std::vector<Section *> &Section::get_sections() {
    std::vector<Section *> *result = new std::vector<Section *>();
    if (txt_called == 1) result->push_back(sections["txt"]);
    for (auto &section: Section::section_order) {
        result->push_back(sections[section]);
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
    for (const uint32 word: section.bytes) {
        std::bitset<8> binary(word);
        out << binary.to_string() << "\n";
    }
    return out;
}

void Section::set_jumps() {
    for (auto &pair: sections) {
        Section *section = pair.second;
        for (auto &jump: section->jumps) {
            if (jump.value == -1) {
                SymbolTable::get_table().new_occurrence(jump.symbol, pair.first, section->line(), true);
                section->next_word(0);
            } else {
                section->next_word(endian(jump.value));
            }
            section->symbolise(jump.line, (section->line() - jump.line - 8));
        }
    }
}

int Section::number() {
    return (txt_called == 1 and get_section("txt")->byte_count == 0) ? sections.size() - 1 : sections.size();
}

void Section::out_obj(std::ostream &out) {
    std::vector<Section *> &sctns = Section::get_sections();
    out << "sections " << Section::number() << std::endl;
    for (auto &section: sctns) {
        if (txt_called == 1 and section->name == "txt" and section->byte_count == 0) continue;
        out << section->get_name() << " " << section->line() << std::endl;
        out << *section;
    }
}
