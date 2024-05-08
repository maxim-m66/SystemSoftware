//
// Created by ss on 5/8/24.
//

#ifndef SYMBOL_TABLE_HPP
#define SYMBOL_TABLE_HPP
#include <string>
#include <unordered_map>
#include <vector>


class SymbolTable {
public:
    struct SectionLine {
        std::string section;
        int line;
    };

    std::vector<SectionLine>& get_occurences(const std::string& symbol) { return this->symbols[symbol]->occurences; }

    int& value(const std::string& symbol) { return this->symbols[symbol]->value; }

    std::string& section(const std::string& symbol) { return this->symbols[symbol]->section; }

    bool has_value(const std::string& symbol) { return this->symbols[symbol]->value != -1; }

    bool has_symbol(const std::string& symbol) { return this->symbols.find(symbol) != this->symbols.end(); }

    void insert_symbol(const std::string& symbol);

    void new_occurrence(const std::string& symbol, const std::string& section, int line);

    friend std::ostream& operator<<(std::ostream &out, const SymbolTable &table);

    static SymbolTable& get_table();

protected:
    explicit SymbolTable() {}

private:
    struct ValueOccurence {
        int value = -1;
        std::string section;
        std::vector<SectionLine> occurences;
    };
    std::unordered_map<std::string, ValueOccurence*> symbols;
    static SymbolTable* table;
};

#endif //SYMBOL_TABLE_HPP
