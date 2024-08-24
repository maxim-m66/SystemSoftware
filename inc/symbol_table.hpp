#ifndef SYMBOL_TABLE_HPP
#define SYMBOL_TABLE_HPP
#include <string>
#include <unordered_map>
#include <vector>
#include <set>

struct pair {
    bool is_symbol;
    std::string symbol;
};

class SymbolTable {
public:
    struct SectionLine {
        std::string section;
        int line;
        bool whole;
    };

    std::vector<SectionLine>& get_occurences(const std::string& symbol) { return this->symbols[symbol]->occurences; }

    int& value(const std::string& symbol) { return this->symbols[symbol]->value; }

    std::string& section(const std::string& symbol) { return this->symbols[symbol]->section; }

    bool has_value(const std::string& symbol) { return this->symbols[symbol]->value != -1; }

    bool has_symbol(const std::string& symbol) { return this->symbols.find(symbol) != this->symbols.end(); }

    void insert_symbol(const std::string& symbol);

    void new_occurrence(const std::string& symbol, const std::string& section, int line, bool whole = false);

    friend std::ostream& operator<<(std::ostream &out, const SymbolTable &table);

    std::set<std::string>& get_extern() { return _extern; }

    std::set<std::string>& get_global() { return _global; }

    static SymbolTable& get_table();

    static void symbolise();

    static void new_def(const std::string &name, int asm_line);

    static void check_multiple_defs();

    static void new_equ(const std::string &symbol, std::vector<pair> &operands, std::vector<std::string> &operators);

    static std::string filename;

protected:
    explicit SymbolTable() {}

private:
    struct ValueOccurence {
        int value = -1;
        std::string section;
        std::vector<SectionLine> occurences;
    };
    struct op_op {
        std::vector<pair> operands;
        std::vector<std::string > operators;
    };
    std::unordered_map<std::string, ValueOccurence*> symbols;
    std::set<std::string> _extern;
    std::set<std::string> _global;
    static SymbolTable* table;
    static std::unordered_map<std::string, std::vector<int>> multiple_defs;
    static std::unordered_map<std::string, op_op> equs;
};

#endif //SYMBOL_TABLE_HPP
