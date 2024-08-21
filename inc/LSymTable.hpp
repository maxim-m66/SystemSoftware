//
// Created by os on 8/21/24.
//

#ifndef RESENJE_LSYMTABLE_HPP
#define RESENJE_LSYMTABLE_HPP


#include <string>
#include <vector>
#include <set>
#include <unordered_map>
#include "int_util.hpp"

class LSymTable {
public:
    static void
    new_occurrence(const std::string &file, const std::string &section, const std::string &symbol, int line, bool whole,
                   bool local);

    static bool new_definition(const std::string &file, const std::string &section, const std::string &symbol, int byte,
                               bool local);

    static void print();

    static std::vector<std::string> &check_undefined();

    static void resolve_symbols();

    static void relocate();

private:
    ///marks a place where said symbol is required, and whether it is required on a full line
    struct Entry {
        std::string file;
        std::string section;
        std::string symbol;
        int byte;
        bool whole;
    };
    ///marks a place where said symbol is defined, and whether it's locally bound
    struct SymbolDef {
        std::string file;
        std::string section;
        std::string symbol;
        int byte;
    };
    static std::vector<Entry> linker_table;
    static std::vector<SymbolDef> symbol_defs;
    static std::set<std::string> required_symbols;
    static std::set<std::string> defined_symbols;
    static std::vector<std::string> undefined_symbols;
    static std::unordered_map<std::string, uint32> symbol_values;
};


#endif //RESENJE_LSYMTABLE_HPP
