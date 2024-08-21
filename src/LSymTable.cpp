#include <iostream>
#include "../inc/LSymTable.hpp"

std::vector<LSymTable::Entry> LSymTable::linker_table;
std::vector<LSymTable::SymbolDef> LSymTable::symbol_defs;
std::set<std::string> LSymTable::defined_symbols;
std::set<std::string> LSymTable::required_symbols;


void LSymTable::new_occurrence(const std::string &file, const std::string &section, const std::string &symbol, int line, bool whole, bool local) {
    linker_table.push_back({file, section, symbol, line, whole});
    if (!local) {
        required_symbols.insert(symbol);
    }
}

bool LSymTable::new_definition(const std::string &file, const std::string &section, const std::string &symbol, int byte, bool local) {
    symbol_defs.push_back({file, section, symbol, byte, local});
    if (!local) {
        if (defined_symbols.find(symbol) != defined_symbols.end()) {
            return false;
        }
        defined_symbols.insert(symbol);
    }
    return true;
}

void LSymTable::print() {
    std::cout << std::boolalpha;
    for (auto & entry : symbol_defs) {
        std::cout << entry.symbol << " "<< entry.file << " " << entry.section << " " << entry.byte << " " << entry.local << std::endl;
    }
    std::cout << std::endl;
    for (auto &entry : linker_table) {
        std::cout << entry.symbol << " "<< entry.file << " " << entry.section << " " << entry.line << " " << entry.whole << std::endl;
    }
}
