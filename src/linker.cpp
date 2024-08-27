#include <iostream>
#include <fstream>
#include "../inc/LSymTable.hpp"
#include "../inc/LinkerSection.hpp"

#define EQ 6

using namespace std;

std::string read_file(const std::string &filename) {

    std::ifstream file(filename);
    if (!file.is_open()) return "Unable to open file " + filename;

    LinkerSection::add_file(filename);

    std::string header, name, section;
    int elements, binding, lines, line, byte, whole;
    bool is_equ;

    file >> header >> elements;
    if (header != "symbols" or elements < 0) return "No symbol table in file " + filename;
    for (int i = 0; i < elements; i++) {
        file >> name >> binding >> is_equ >> lines;
        if (binding != EXTERN_SYMBOL and !is_equ) {
            file >> section >> byte;
            if (!LSymTable::new_definition(filename, section, name, byte, binding == LOCAL_SYMBOL)) {
                return "Multiple definitions of a symbol: " + name;
            }
        } else if (is_equ) {
            int Noperands;
            file >> Noperands;
            vector<LSymTable::pair> operands;
            vector<std::string> operators;
            for (int j = 0; j < Noperands; j++) {
                std::string symbol;
                bool is_symbol;
                file >> symbol >> is_symbol;
                operands.push_back({is_symbol, symbol});
            }
            for (int j = 0; j < Noperands - 1; j++) {
                std::string operator1;
                file >> operator1;
                operators.push_back(operator1);
            }
            LSymTable::new_equ(binding == LOCAL_SYMBOL ? filename + "#" + name : name, operands, operators);
        }
        for (int j = 0; j < lines; j++) {
            file >> section >> line >> whole;
            LSymTable::new_occurrence(filename, section, name, line, whole == 1, binding == LOCAL_SYMBOL);
        }
    }

    file >> header >> elements;
    if (header != "sections") return "No sections in file " + filename;
    for (int i = 0; i < elements; i++) {
        file >> name >> lines;
        OldSection::add_section(filename, file, name, lines);
    }
    file.close();
    return "";
}

string output_filename = "";

int main(int argc, char **argv) {

    bool executable = false, relocatable = false;
    string input;
    vector<string> files;
    unordered_map<string, long> starts;
    for (int i = 1; i < argc; i++) {
        input = argv[i];
        if (input == "-o") {
            output_filename = argv[++i];
            continue;
        } else if (input.size() >= EQ and input[EQ] == '=') {
            int at = input.find('@');
            long position = to_int(input.substr(at + 1));
            LinkerSection::add_start_position(input.substr(EQ + 1, at - EQ - 1), position);
        } else if (input == "-hex") {
            executable = true;
        } else if (input == "-relocatable") {
            relocatable = true;
        } else {
            files.push_back(input);
        }
    }

    if (relocatable == executable) {
        cerr << "output type not defined";
        exit(-1);
    }

    if (output_filename == "") output_filename = string("tests/out.") + (executable ? "hex" : "o");

    for (auto &file: files) {
        std::string error = read_file(file);
        if (error != "") {
            cerr << error << "\n";
            exit(-1);
        }
    }

    LinkerSection::link();

    ofstream output;
    output.open(output_filename, std::ios::out | std::ios::trunc);
    if (executable) {
        LSymTable::check_undefined();
        LSymTable::resolve_symbols();
        LSymTable::relocate();
        LinkerSection::out_hex(output);
    } else if (relocatable) {
        LSymTable::out_obj(output);
        LinkerSection::out_obj(output);
    }
    output.close();
}