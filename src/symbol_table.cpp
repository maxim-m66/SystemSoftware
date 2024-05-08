#include "../inc/symbol_table.hpp"

#include <ostream>

SymbolTable* SymbolTable::table = nullptr;

void SymbolTable::insert_symbol(const std::string& symbol) {
    if (this->has_symbol(symbol)) return;
    this->symbols[symbol] = new ValueOccurence();
}

void SymbolTable::new_occurrence(const std::string& symbol, const std::string& section, int line) {
    this->insert_symbol(symbol);
    this->symbols[symbol]->occurences.push_back({section, line});
}

SymbolTable& SymbolTable::get_table() {
    if (SymbolTable::table == nullptr) {
        SymbolTable::table = new SymbolTable();
    }
    return *SymbolTable::table;
}

std::ostream& operator<<(std::ostream& out, const SymbolTable& table) {
    for (auto& pair: table.symbols) {
        out << pair.first << "(" << pair.second->section << ", " << pair.second->value << "):"<< std::endl;
        for (auto& sectionline: pair.second->occurences) {
            out << sectionline.section << " " << sectionline.line << std::endl;
        }
    }
    return out;
}
