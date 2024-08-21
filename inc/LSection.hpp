//
// Created by os on 8/21/24.
//

#ifndef RESENJE_LSECTION_HPP
#define RESENJE_LSECTION_HPP


#include <vector>
#include <string>
#include <set>
#include <unordered_map>

class LSection {
public:
    static void add_file(const std::string &file);

    static void add_section(const std::string &filename, std::ifstream &file, const std::string &section_name, int size);

    static void print();

private:
    LSection(std::ifstream &file, int lines);

    static std::vector<std::string> file_order;
    static std::vector<std::string> section_order;
    static std::set<std::string> section_set;
    static std::unordered_map<std::string, LSection *> sections;

    int origin = -1;
    int lines;
    std::vector<uint32_t> words;
};


#endif //RESENJE_LSECTION_HPP
