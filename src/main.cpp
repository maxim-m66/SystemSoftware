#include <string>
#include <fstream>
#include <iostream>

using namespace std;

int main(int argc, char **argv) {
    string input_filename, output;
        if (argc == 2) {
        input_filename = argv[1];
        output = input_filename;
        output[output.size() - 1] = 'o';
    } else if (argc == 4) {
        input_filename = argv[3];
        output = argv[2];
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

    while (!input.eof()) {
        string line;
        getline(input, line);
        cout << line << endl;
    } 
}