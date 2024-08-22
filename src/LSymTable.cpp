#include <iostream>
#include "../inc/LSymTable.hpp"
#include "../inc/LinkerSection.hpp"

std::vector<LSymTable::Entry> LSymTable::linker_table;
std::vector<LSymTable::SymbolDef> LSymTable::symbol_defs;
std::set<std::string> LSymTable::defined_symbols;
std::set<std::string> LSymTable::required_symbols;
std::vector<std::string> LSymTable::undefined_symbols;
std::unordered_map<std::string, uint32> LSymTable::symbol_values;
std::unordered_map<std::string, LSymTable::BindTimes> LSymTable::encountered_symbols;

void LSymTable::new_occurrence(const std::string &file, const std::string &section, const std::string &symbol, int line,
                               bool whole, bool local) {
    std::string qualified_name = (local ? file + "#" : "") + symbol;
    if (encountered_symbols.find(qualified_name) == encountered_symbols.end()) {
        encountered_symbols[qualified_name] = {local, 1};
    } else {
        encountered_symbols[qualified_name].times += 1;
    }
    linker_table.push_back({file, section, qualified_name, line, whole});
    if (!local) {
        required_symbols.insert(symbol);
    }
}

bool LSymTable::new_definition(const std::string &file, const std::string &section, const std::string &symbol, int byte,
                               bool local) {
    std::string qualified_name = (local ? file + "#" : "") + symbol;
    if (encountered_symbols.find(qualified_name) == encountered_symbols.end()) {
        encountered_symbols[qualified_name] = {local, 0};
    }
    symbol_defs.push_back({file, section, qualified_name, byte});
    if (!local) {
        if (defined_symbols.find(symbol) != defined_symbols.end()) {
            return false;
        }
        defined_symbols.insert(symbol);
    }
    return true;
}

void LSymTable::check_undefined() {
    for (auto &symbol: required_symbols) {
        if (defined_symbols.find(symbol) == defined_symbols.end()) {
            undefined_symbols.push_back(symbol);
        }
    }
    if (undefined_symbols.empty()) return;
    std::cerr << "undefined reference to:\n";
    for (auto &symbol: undefined_symbols) {
        std::cerr << symbol << ";\n";
    }
    exit(0);
}

void LSymTable::resolve_symbols() {
    for (auto &data: symbol_defs) {
        int value = LinkerSection::get_symbol_value(data.section, data.file, data.byte);
        symbol_values[data.symbol] = value;
    }
}

void LSymTable::relocate() {
    for (auto &data: linker_table) {
        LinkerSection::symbolize(data.file, data.section, data.byte, symbol_values[data.symbol], data.whole);
    }
}

void LSymTable::out_obj(std::ostream &out) {
    out << "symbols " << encountered_symbols.size() << std::endl;
    for (auto &pair: encountered_symbols) {
        int binding;
        if (pair.second.local) {
            binding = LOCAL_SYMBOL;
        } else if (defined_symbols.find(pair.first) == defined_symbols.end()) {
            binding = EXTERN_SYMBOL;
        } else {
            binding = GLOBAL_SYMBOL;
        }
        out << pair.first << " " << binding << " " << pair.second.times << std::endl;
        if (binding != EXTERN_SYMBOL) {
            for (auto &data: symbol_defs) {
                if (data.symbol != pair.first) continue;
                int byte = data.byte + LinkerSection::get_file_displacement(data.section, data.file);
                out << data.section << " " << byte << std::endl;
            }
        }
        for (auto &data: linker_table) {
            if (data.symbol != pair.first) continue;
            std::string section = data.section;
            int byte = data.byte + LinkerSection::get_file_displacement(data.section, data.file);
            out << section << " " << byte << " " << data.whole << std::endl;
        }
    }
}
