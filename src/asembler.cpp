#include <string>
#include <fstream>
#include <iostream>

#include "../inc/elf.hpp"
#include "../inc/lexer.hpp"
#include "../inc/parser.hpp"
#include "../inc/section.hpp"
#include "../inc/symbol_table.hpp"

using namespace std;

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

    if (input_filename[input_filename.size() - 1] != 's')  {
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
        yyparse();
    } while (!input.eof());
    input.close();
    ofstream output;
    output.open(output_filename, ios::out);
    SymbolTable::symbolise();
    std::vector<Section*>& sections = Section::get_sections();
    output << "sections " << sections.size() << endl;
    int offset = 0;
    for (auto& section : sections) {
        output << section->get_name() << " " << section->size() << endl;
    }
    for (auto& section : sections) {
        cout << section->get_name() << endl;
        if (section->get_name() == ".strtab") {
            StringSection &section1 = reinterpret_cast<StringSection&>(*section);
            output << section1;
            cout << section1;
        } else {
            output << *section;
            cout << *section;
        }
    }
    //make_linkable(output, sections);
    //output.close();
    //input.open(output_filename, ios::binary | ios::in);
    //cout << *Section::get_section("txt");
    // while (true) {
    //     if (input.eof()) break;
    //     int a = input.get();
    //     if (a != 16);
    //     cout << hex << a << endl;
    // }
}