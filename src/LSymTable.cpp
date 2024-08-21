#include <iostream>
#include "../inc/LSymTable.hpp"
#include "../inc/LinkerSection.hpp"

std::vector<LSymTable::Entry> LSymTable::linker_table;
std::vector<LSymTable::SymbolDef> LSymTable::symbol_defs;
std::set<std::string> LSymTable::defined_symbols;
std::set<std::string> LSymTable::required_symbols;
std::vector<std::string> LSymTable::undefined_symbols;
std::unordered_map<std::string, uint32> LSymTable::symbol_values;

void LSymTable::new_occurrence(const std::string &file, const std::string &section, const std::string &symbol, int line,
                               bool whole, bool local) {
    std::string qualified_name = (local ? file + "#" : "") + symbol;
    linker_table.push_back({file, section, qualified_name, line, whole});
    if (!local) {
        required_symbols.insert(symbol);
    }
}

bool LSymTable::new_definition(const std::string &file, const std::string &section, const std::string &symbol, int byte,
                               bool local) {
    std::string qualified_name = (local ? file + "#" : "") + symbol;
    symbol_defs.push_back({file, section, qualified_name, byte});
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
    for (auto &entry: symbol_defs) {
        std::cout << entry.symbol << " " << entry.file << " " << entry.section << " " << entry.byte << " " << entry.byte
                  << std::endl;
    }
    std::cout << std::endl;
    for (auto &entry: linker_table) {
        std::cout << entry.symbol << " " << entry.file << " " << entry.section << " " << entry.byte << " "
                  << entry.whole << std::endl;
    }
    std::cout << std::endl;
    for (auto &entry: symbol_values) {
        std::cout << entry.first << " " << entry.second << std::endl;
    }
}

std::vector<std::string> &LSymTable::check_undefined() {
    for (auto &symbol: required_symbols) {
        if (defined_symbols.find(symbol) == defined_symbols.end()) {
            undefined_symbols.push_back(symbol);
        }
    }
    return undefined_symbols;
}

void LSymTable::resolve_symbols() {
    for (auto &data: symbol_defs) {
        int value = LinkerSection::get_symbol_value(data.section, data.file, data.byte);
        symbol_values[data.symbol] = value;
    }
}

void LSymTable::relocate() {
    for (auto &data: linker_table) {
        std::cout << data.symbol << " ";
        LinkerSection::symbolize(data.file, data.section, data.byte, symbol_values[data.symbol], data.whole);
        std::cout << '\n';
    }
}
