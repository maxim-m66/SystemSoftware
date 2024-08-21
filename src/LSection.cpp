#include <fstream>
#include <bitset>
#include <iostream>
#include "../inc/LSection.hpp"

std::vector<std::string> LSection::file_order;
std::vector<std::string> LSection::section_order;
std::set<std::string> LSection::section_set;
std::unordered_map<std::string, LSection *> LSection::sections;

void LSection::add_file(const std::string &file) {
    file_order.push_back(file);
}

void
LSection::add_section(const std::string &filename, std::ifstream &file, const std::string &section_name, int size) {
    if (section_set.find(section_name) == section_set.end()) {
        section_order.push_back(section_name);
    }
    LSection *section = new LSection(file, size);
    sections[filename + section_name] = section;
}

unsigned int to_int(const std::string &string) {
    int a = 0;
    for (char c: string) {
        a <<= 1;
        if (c == '1') a |= 1;
    }
    return a;
}

LSection::LSection(std::ifstream &file, int lines) {
    this->lines = lines;
    for (int i = 0; i < lines; i++) {
        std::string s0, s1, s2, s3;
        file >> s0 >> s1 >> s2 >> s3;
        this->words.push_back(to_int(s0) << 24 | to_int(s1) << 16 | to_int(s2) << 8 | to_int(s3));
    }
}

std::string to_my_string(std::string binary) {
    std::string ret = "";
    for(int i = 0; i < 32; i ++) {
        if (i % 8 == 0 and i > 0) ret += " ";
        ret += binary[i];
    }
    return ret;
}

void LSection::print() {
    for (auto &pair : sections) {
        std::string name = pair.first;
        LSection &section = *pair.second;
        std::cout << name << "\n";
        for (const unsigned int word: section.words) {
            std::bitset<32> binary(word);
            std::cout << to_my_string(binary.to_string()) << std::endl;
        }
        std::cout << std::endl;
    }
}
