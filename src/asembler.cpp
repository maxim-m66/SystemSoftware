#include <string>
#include <fstream>
#include <iostream>
#include <sstream>
#include "../misc/lexer.hpp"
#include "../misc/parser.hpp"

using namespace std;

string getTokenName(yytokentype token) {
    switch (token) {
        case END: return "END";
        case GLOBAL: return "GLOBAL";
        case EXTERN: return "EXTERN";
        case SECTION: return "SECTION";
        case WORD: return "WORD";
        case SKIP: return "SKIP";
        case ASCII: return "ASCII";
        case EQU: return "EQU";
        case INONE: return "INONE";
        case IPCOP: return "IPCOP";
        case IPCREGREGOP: return "IPCREGREGOP";
        case IREG: return "IREG";
        case IREGREG: return "IREGREG";
        case LD: return "LD";
        case ST: return "ST";
        case CSRRD: return "CSRRD";
        case CSRWR: return "CSRWR";
        case SYMBOL: return "SYMBOL";
        case INTEGER: return "INTEGER";
        case REGISTER: return "REGISTER";
        case SYSREG: return "SYSREG";
        case IMMED: return "IMMED";
        case REGIND: return "REGIND";
        case REGINDREL: return "REGINDREL";
        case COMMA: return "COMMA";
        case STRING: return "STRING";
        case LABEL: return "LABEL";
        case COMMENT: return "COMMENT";
        case OPERATOR: return "OPERATOR";
        case NEWLINE: return "NEWLINE";
        case ERROR: return "ERROR";
        default: return "Unknown";
    }
}


int main(int argc, char **argv) {
    string input_filename, output_filename;
    
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

    ofstream output;
    output.open(output_filename);

    for (int lineN = 0; !input.eof(); lineN++) {
        string line;
        getline(input, line);
        yy_scan_string(line.c_str());
		int a;
		output << line;
		int numSpaces = (40 - line.length());  // Estimate the number of tabs needed
	    for (int i = 0; i < numSpaces - 1; i++) {
	        output << ' ';
	    }
		while ((a = yylex()) != 0) {
			if (a == yytokentype::ERROR) {
                output << " ERROR";
				cout << "unrecognized token on line:" << lineN << endl;
				output.close();
                return 0;
			}
			else
				output << " " << getTokenName((yytokentype)a);
		}
		output << endl;
        //yyparse();
    } while (!input.eof());
    output.close();
}