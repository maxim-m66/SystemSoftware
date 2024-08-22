#include <iostream>
#include <fstream>
#include "../inc/LSymTable.hpp"
#include "../inc/LinkerSection.hpp"

#define EQ 6

using namespace std;

std::string read_file(const std::string &filename) {

    std::ifstream file("tests/" + filename);
    if (!file.is_open()) return "Unable to open file " + filename;

    LinkerSection::add_file(filename);

    std::string header, name, section;
    int elements, binding, lines, line, byte, whole;

    file >> header >> elements;
    if (header != "symbols" or elements < 0) return "No symbol table in file " + filename;
    for (int i = 0; i < elements; i++) {
        file >> name >> binding >> lines;
        if (binding != EXTERN_SYMBOL) {
            file >> section >> byte;
            if (!LSymTable::new_definition(filename, section, name, byte, binding == LOCAL_SYMBOL)) {
                return "Multiple definitions of a symbol: " + name;
            }
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
    return "";
}

int main(int argc, char **argv) {

    bool executable = false, relocatable = false;
    string input, output_filename = "out.hex";
    vector<string> files;
    unordered_map<string, int> starts;
    for (int i = 1; i < argc; i++) {
        input = argv[i];
        if (input == "-o") {
            output_filename = argv[++i];
            continue;
        } else if (input.size() >= EQ and input[EQ] == '=') {
            int at = input.find('@');
            int position = to_int(input.substr(at + 1));
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
        exit(0);
    }

    for (auto &file: files) {
        std::string error = read_file(file);
        if (error != "") {
            cerr << error << "\n";
            exit(0);
        }
    }

    LinkerSection::link();

    ofstream output;
    output.open("tests/" + output_filename, ios::out);
    if (executable) {
        LSymTable::check_undefined();
        LSymTable::resolve_symbols();
        LSymTable::relocate();
        LinkerSection::out_hex(output);
    } else if (relocatable) {
        LSymTable::out_obj(output);
        LinkerSection::out_obj(output);
    }
}