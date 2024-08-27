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
std::unordered_map<std::string, LSymTable::op_op> LSymTable::equs;
extern std::string output_filename;

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
        if (defined_symbols.find(symbol) == defined_symbols.end() and equs.find(symbol) == equs.end()) {
            undefined_symbols.push_back(symbol);
        }
    }
    if (undefined_symbols.empty()) return;
    std::cerr << "undefined reference to:\n";
    for (auto &symbol: undefined_symbols) {
        std::cerr << symbol << ";\n";
    }
    exit(-1);
}

void LSymTable::resolve_symbols() {
    for (auto &data: symbol_defs) {
        int value = LinkerSection::get_symbol_value(data.section, data.file, data.byte);
        symbol_values[data.symbol] = value;
    }
    std::vector<std::string> trash;
    while (!equs.empty()) {
        int size = equs.size();
        for (auto &data: equs) {
            std::string symbol = data.first;
            auto &operands = data.second.operands;
            auto &operators = data.second.operators;
            int i = 0;
            if (operands[i].is_symbol and symbol_values.find(operands[i].symbol) == symbol_values.end()) continue;
            int value = operands[i].is_symbol ? symbol_values[operands[i].symbol] : to_int(operands[i].symbol);
            bool broken = false;
            for (i++; i < operands.size(); i++) {
                if (operands[i].is_symbol and symbol_values.find(operands[i].symbol) == symbol_values.end()) {
                    broken = true;
                    break;
                }
                int addon = operands[i].is_symbol ? symbol_values[operands[i].symbol] : to_int(operands[i].symbol);
                if (operators[i - 1] == "+") {
                    value += addon;
                } else if (operators[i - 1] == "-") {
                    value -= addon;
                } else if (operators[i - 1] == "*") {
                    value *= addon;
                } else if (operators[i - 1] == "/") {
                    value /= addon;
                }
            }
            if (broken) continue;
            symbol_values[symbol] = value;
            trash.push_back(symbol);
        }
        for (auto &data: trash) equs.erase(data);
        trash.clear();
        if (equs.size() == size) {
            std::cerr << "Unable to resolve symbols:";
            for (auto &data: equs) std::cerr << " " << data.first;
            exit(-1);
        }
    }
}

void LSymTable::relocate() {
    for (auto &data: linker_table) {
        LinkerSection::symbolize(data.file, data.section, data.byte, symbol_values[data.symbol], data.whole);
    }
//    for ( auto & pair : symbol_values) {
//        std::cout << std::hex << pair.first << " " << pair.second << std::endl;
//    }
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
        bool equ = equs.find(pair.first) != equs.end();
        out << pair.first << " " << binding << " " << equ << " " << pair.second.times << std::endl;
        if (binding != EXTERN_SYMBOL and not equ) {
            for (auto &data: symbol_defs) {
                if (data.symbol != pair.first) continue;
                int byte = data.byte + LinkerSection::get_file_displacement(data.section, data.file);
                out << data.section << " " << byte << std::endl;
            }
        } else if (equ) {
            std::vector<LSymTable::pair> operands = equs[pair.first].operands;
            std::vector<std::string> operators = equs[pair.first].operators;
            out << operands.size() << std::endl;
            for (int i = 0; i < operands.size(); i++) {
                std::string sym = operands[i].symbol;
                if (operands[i].is_symbol and encountered_symbols[sym].local) {
                    sym = output_filename + "#" + sym;
                }
                out << sym << " " << operands[i].is_symbol << ((i == operands.size() - 1) ? "\n" : " ");
            }
            std::cout << encountered_symbols.size() << " ";
            for (int i = 0; i < operators.size(); i++) {
                out << operators[i] << ((i == operators.size() - 1) ? "\n" : " ");
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

void LSymTable::new_equ(const std::string &symbol, std::vector<pair> &operands, std::vector<std::string> &operators) {
    equs[symbol] = *(new op_op);
    equs[symbol].operands = operands;
    equs[symbol].operators = operators;
}
