//
// Created by os on 8/21/24.
//

#ifndef RESENJE_LINKERSECTION_HPP
#define RESENJE_LINKERSECTION_HPP


#include <vector>
#include <string>
#include <set>
#include <unordered_map>
#include "int_util.hpp"

class OldSection;

class FinishedSection;

class LinkerSection {
public:
    static void link();

    static void add_file(const std::string &filename) {
        file_order.push_back(filename);
    }

    static void add_start_position(const std::string &section, long position) {
        start_positions[section] = position;
    }

    static int get_symbol_value(std::string &section, std::string &filename, int byte);

    static int get_file_displacement(std::string &section, std::string filename);

    static void symbolize(const std::string &file, const std::string &section, int location, uint32 value, bool whole);

    static void out_hex(std::ostream &out);

    static void out_obj(std::ostream &out);

protected:
    struct triplet {
        std::string section;
        long start;
        int len;
        bool continues;
    };
    static std::vector<triplet> overlaps;
    static std::vector<std::string> file_order;
    static std::vector<std::string> section_order;
    static std::set<std::string> section_set;
    static std::unordered_map<std::string, OldSection *> old_sections;
    static std::unordered_map<std::string, FinishedSection *> finished_sections;
    static std::unordered_map<std::string, long> start_positions;
};

class OldSection : public LinkerSection {
public:
    static void add_file(const std::string &file);

    static void
    add_section(const std::string &filename, std::ifstream &file, const std::string &section_name, int size);

    static void print();

    std::vector<uint8> &get_bytes() { return bytes; }

private:
    OldSection(std::ifstream &file, int lines);

    std::vector<uint8> bytes;
};

class FinishedSection : public LinkerSection {
public:
    FinishedSection(std::string &name, long start_address) : name(name), start_address(start_address), length(0) {};

    void fill(std::string &filename, std::vector<uint8> &old);

    int get_symbol_value(std::string &filename, int byte);

    int get_file_displacement(std::string filename);

    int get_size() const { return length; }

    long where_next() const {return start_address + length;}

    static void print();

    void symbolize(const std::string &file, int location, uint32 value, bool whole);

    void out_hex(std::ostream &out, bool continued);

    void out_obj(std::ostream &out);

private:
    std::vector<uint8> bytes;
    std::string name;
    std::unordered_map<std::string, long> subsections_start;
    long start_address;
    int length;
};


#endif //RESENJE_LINKERSECTION_HPP
