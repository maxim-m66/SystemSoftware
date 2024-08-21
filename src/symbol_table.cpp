#include "../inc/symbol_table.hpp"

#include <iostream>
#include <ostream>

#include "../inc/section.hpp"

SymbolTable* SymbolTable::table = nullptr;

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
    out << "symbols " << table.symbols.size() << std::endl;
    for (auto& pair : table.symbols) {
        int linking;
        if (table._extern.find(pair.first) != table._extern.end()) {
            linking = 0;
        } else if (table._global.find(pair.first) != table._global.end()) {
            linking = 1;
        } else {
            linking = 2;
        }
        out << pair.first << " " << linking << " " << pair.second->occurences.size() << std::endl;
        if (linking != 0) {
            out << pair.second->section << " " << pair.second->value << std::endl;
        }
        for (auto& sectionline : pair.second->occurences) {
            out << sectionline.section << " " << sectionline.line << " " << sectionline.whole << std::endl;
        }
    }
    return out;
}
