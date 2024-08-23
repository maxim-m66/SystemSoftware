#include <fstream>
#include <bitset>
#include <iostream>
#include "../inc/LinkerSection.hpp"
#include <iomanip>
#include <algorithm>

#define BREAK 8

std::vector<std::string> LinkerSection::file_order;
std::vector<std::string> LinkerSection::section_order;
std::set<std::string> LinkerSection::section_set;
std::unordered_map<std::string, OldSection *> LinkerSection::old_sections;
std::unordered_map<std::string, FinishedSection *> LinkerSection::finished_sections;
std::unordered_map<std::string, int> LinkerSection::start_positions;
std::vector<LinkerSection::triplet> LinkerSection::overlaps;

void OldSection::add_file(const std::string &file) {
    file_order.push_back(file);
}

void
OldSection::add_section(const std::string &filename, std::ifstream &file, const std::string &section_name, int size) {
    if (section_set.find(section_name) == section_set.end()) {
        section_order.push_back(section_name);
        section_set.insert(section_name);
    }
    OldSection *section = new OldSection(file, size);
    old_sections[filename + section_name] = section;
}

unsigned int bin_to_int(const std::string &string) {
    int a = 0;
    for (char c: string) {
        a <<= 1;
        if (c == '1') a |= 1;
    }
    return a;
}

OldSection::OldSection(std::ifstream &file, int lines) {
    for (int i = 0; i < lines; i++) {
        std::string s0;
        file >> s0;
        this->bytes.push_back(bin_to_int(s0));
    }
}

void OldSection::print() {
    for (auto &pair: old_sections) {
        std::string name = pair.first;
        OldSection &section = *pair.second;
        std::cout << name << "\n";
        int i = 0;
        for (const unsigned int word: section.bytes) {
            std::bitset<8> binary(word);
            std::cout << binary.to_string() << ((i % 4 != 3) ? " " : "\n");
            i++;
        }
        std::cout << std::endl;
    }
}

void LinkerSection::link() {
    int current_address = 0;
    for (auto &current_section: section_order) {
        if (start_positions.find(current_section) != start_positions.end()) {
            current_address = start_positions[current_section];
        }
        FinishedSection *section = new FinishedSection(current_section, current_address);
        finished_sections[current_section] = section;
        for (auto &current_file: file_order) {
            std::string key = current_file + current_section;
            if (old_sections.find(key) == old_sections.end()) {
                continue;
            }
            section->fill(current_file, old_sections[key]->get_bytes());
        }
        overlaps.push_back({current_section, current_address, section->get_size(), false});
        current_address += section->get_size();
    }
    std::sort(overlaps.begin(), overlaps.end(), [](const triplet &a, const triplet &b) { return a.start < b.start; });
    for (int i = 0; i < overlaps.size() - 1; i++) {
        if (overlaps[i].start + overlaps[i].len == overlaps[i + 1].start) {
            overlaps[i].continues = true;
        } else if (overlaps[i].start + overlaps[i].len > overlaps[i + 1].start) {
            std::cerr << "Sections overlap" << std::endl;
            exit(0);
        }
    }
}

int LinkerSection::get_symbol_value(std::string &section, std::string &filename, int byte) {
    return finished_sections[section]->get_symbol_value(filename, byte);
}

void FinishedSection::fill(std::string &filename, std::vector<uint8> &old) {
    subsections_start[filename] = this->length;
    for (auto byte: old) {
        this->bytes.push_back(byte);
    }
    this->length += old.size();
}

int FinishedSection::get_symbol_value(std::string &filename, int byte) {
    return subsections_start[filename] + byte;
}

void FinishedSection::print() {
    for (auto &sectionName: section_order) {
        FinishedSection *section = finished_sections[sectionName];
        std::cout << sectionName << std::endl;
        for (int i = 0; i < section->length; i++) {
            std::bitset<8> binary(section->bytes[i]);
            std::cout << binary.to_string() << " ";
            if (i % 4 == 3) std::cout << std::endl;
        }
        std::cout << std::endl;
    }
}

void
LinkerSection::symbolize(const std::string &file, const std::string &section, int location, uint32 value, bool whole) {
    finished_sections[section]->symbolize(file, location, value, whole);
}

void FinishedSection::symbolize(const std::string &file, int location, uint32 value, bool whole) {
    location = location + this->subsections_start[file];
    if (whole) {
        uint16 b0 = value & 0xFF, b1 = value & 0xFF00, b2 = value & 0xFF0000, b3 = value & 0xFF000000;
        this->bytes[location] = b0;
        this->bytes[location + 1] = b1;
        this->bytes[location + 2] = b2;
        this->bytes[location + 3] = b3;
    } else {
        uint16 octet = value & 0xFF;
        uint8 quartet = value & 0xF00;
        this->bytes[location + 3] = octet;
        this->bytes[location + 2] = (this->bytes[location + 2] & 0xF0) | quartet;
    }
}

int LinkerSection::get_file_displacement(std::string &section, std::string filename) {
    return finished_sections[section]->get_file_displacement(filename);
}

int FinishedSection::get_file_displacement(std::string filename) {
    return this->subsections_start[filename];
}


void LinkerSection::out_hex(std::ostream &out) {
    out << std::hex;
    bool continued = false;
    for (auto &triplet: overlaps) {
        FinishedSection *section = finished_sections[triplet.section];
        section->out_hex(out, continued);
        continued = triplet.continues;
        if (!triplet.continues) {
            if (section->where_next() % BREAK != 0)
                for (int i = 0; i < BREAK - section->where_next() % BREAK; i++)
                    out << "00" << (i == BREAK - section->where_next() % BREAK - 1 ? "\n" : " ");
        }
    }
}

void FinishedSection::out_hex(std::ostream &out, bool continued) {
    int location = this->start_address;
    if (not continued && location % BREAK != 0) {
        out << std::setw(4) << std::setfill('0') << (location / BREAK) * BREAK << ": ";
        for (int i = 0; i < location % BREAK; i++) out << "00 ";
    }
    for (int i = 0; i < this->bytes.size(); i++, location++) {
        if (location % BREAK == 0) out << std::setw(4) << std::setfill('0') << location << ": ";
        out << std::setw(2) << std::setfill('0') << (uint16) this->bytes[i] << ((location % BREAK == 7) ? "\n" : " ");
    }
}

void LinkerSection::out_obj(std::ostream &out) {
    out << "sections " << finished_sections.size() << std::endl;
    for (auto &section_name: section_order) {
        finished_sections[section_name]->out_obj(out);
    }
}

void FinishedSection::out_obj(std::ostream &out) {
    int i = 0;
    out << this->name << " " << this->bytes.size() << std::endl;
    for (const uint32 word: this->bytes) {
        std::bitset<8> binary(word);
        out << binary.to_string() << "\n";
    }
}

