#include <string>
#include <fstream>
#include <iostream>
#include <set>

#include "../inc/lexer.hpp"
#include "../inc/parser.hpp"
#include "../inc/section.hpp"
#include "../inc/symbol_table.hpp"

using namespace std;

int fileline = 0;
bool was_error = false;

int main(int argc, char **argv) {

    string input_filename, output_filename;

    if (argc != 2 && argc != 4) return 0;

    if (argc == 2) {
        input_filename = argv[1];
        output_filename = input_filename;
        output_filename[output_filename.size() - 1] = 'o';
    } else if (argc == 4) {
        input_filename = argv[3];
        output_filename = argv[2];
    }

    if (input_filename[input_filename.size() - 1] != 's') {
        cerr << "Invalid input file" << endl;
        return -1;
    }

    ifstream input;
    input.open(input_filename);
    if (!input) {
        cerr << "Unable to open file " << input_filename << endl;
        return -1;
    }
    for (int lineN = 0; !input.eof(); lineN++) {
        string line;
        getline(input, line);
        yy_scan_string(line.c_str());
        fileline++;
        int ret = yyparse();
        if (was_error) {
            was_error = false;
            continue;
        } else if (ret) {
            break;
        }
    }
    input.close();

    SymbolTable::check_multiple_defs();
    Section::set_jumps();

    ofstream output;
    output.open(output_filename, ios::out);
    SymbolTable &symbol_table = SymbolTable::get_table();
    output << symbol_table;
    Section::out_obj(output);
}