#include <string>
#include <fstream>
#include <iostream>
#include "../inc/lexer.hpp"
#include "../inc/parser.hpp"
#include "../inc/section.hpp"

using namespace std;

ofstream output;

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

    output.open(output_filename);

    for (int lineN = 0; !input.eof(); lineN++) {
        string line;
        getline(input, line);
        yy_scan_string(line.c_str());
		output << line;
		int numSpaces = (40 - line.length());  // Estimate the number of tabs needed
	    for (int i = 0; i < numSpaces - 1; i++) {
	        output << ' ';
	    }
        yyparse();
		output << endl;
    } while (!input.eof());
    output.close();
}