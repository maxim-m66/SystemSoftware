#include "../inc/symbol_table.hpp"
#include "../inc/section.hpp"
#include "../inc/binding.hpp"

#include <iostream>
#include <ostream>

SymbolTable* SymbolTable::table = nullptr;
std::unordered_map<std::string, std::vector<int>> SymbolTable::multiple_defs;

void SymbolTable::insert_symbol(const std::string& symbol) {
    if (this->has_symbol(symbol)) return;
    this->symbols[symbol] = new ValueOccurence();
}

void SymbolTable::new_occurrence(const std::string& symbol, const std::string& section, int line, bool whole) {
    this->insert_symbol(symbol);
    this->symbols[symbol]->occurences.push_back({section, line, whole});
}

SymbolTable& SymbolTable::get_table() {
    if (table == nullptr) {
        table = new SymbolTable();
    }
    return *table;
}

void SymbolTable::symbolise() {
    for (auto& pair : table->symbols) {
        for (auto& sectionline : pair.second->occurences) {
            if (pair.second->section != sectionline.section) continue;
            Section::get_section(sectionline.section)->symbolise(sectionline.line, pair.second->value, sectionline.whole);
        }
    }
}

std::ostream& operator<<(std::ostream& out, const SymbolTable& table) {
    std::vector<std::string> undefined;
    out << "symbols " << table.symbols.size() << std::endl;
    for (auto& pair : table.symbols) {
        int linking;
        if (table._extern.find(pair.first) != table._extern.end()) {
            linking = EXTERN_SYMBOL;
        } else if (table._global.find(pair.first) != table._global.end()) {
            linking = GLOBAL_SYMBOL;
        } else {
            linking = LOCAL_SYMBOL;
        }
        out << pair.first << " " << linking << " " << pair.second->occurences.size() << std::endl;
        if (linking != EXTERN_SYMBOL) {
            if (pair.second->value == -1) undefined.push_back(pair.first);
            out << pair.second->section << " " << pair.second->value << std::endl;
        }
        for (auto& sectionline : pair.second->occurences) {
            out << sectionline.section << " " << sectionline.line << " " << sectionline.whole << std::endl;
        }
    }
    if (!undefined.empty()) {
        std::cerr << "Undefined symbols:\n";
        for (auto &symbol : undefined) {
            std::cerr << symbol << std::endl;
        }
    }
    return out;
}

void SymbolTable::new_def(const std::string &name, int asm_line) {
    if (table->has_symbol(name)) {
        multiple_defs[name].push_back(asm_line);
    } else {
        table->insert_symbol(name);
        multiple_defs[name] = *(new std::vector<int>{asm_line});
    }
}

void SymbolTable::check_multiple_defs() {
    bool error = false;
    for (auto & pair : multiple_defs) {
        if (pair.second.size() > 1) {
            error = true;
            std::cerr << "Multiple defintions of symbol " << pair.first << " on lines:";
            for (int line : pair.second) {
                std::cerr << " " << line;
            }
            std::cerr << std::endl;
        }
    }
    if (error) exit(0);
}
