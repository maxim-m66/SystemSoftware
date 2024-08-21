#include <iostream>
#include <fstream>
#include "../inc/LSymTable.hpp"
#include "../inc/binding.hpp"
#include "../inc/LSection.hpp"

using namespace std;

int read_file(const std::string &filename) {

    std::ifstream file("tests/" + filename);
    if (!file.is_open()) return -1;

    std::string header, name, section;
    int elements, binding, lines, line, byte, whole;

    file >> header >> elements;
    if (header != "symbols" or elements < 0) return -2;
    for (int i = 0; i < elements; i++) {
        file >> name >> binding >> lines;
        if (binding != EXTERN_SYMBOL) {
            file >> section >> byte;
            LSymTable::new_definition(filename, section, name, byte, binding == LOCAL_SYMBOL);
        }
        for (int j = 0; j < lines; j++) {
            file >> section >> line >> whole;
            LSymTable::new_occurrence(filename, section, name, line, whole == 1, binding == LOCAL_SYMBOL);
        }
    }

    file >> header >> elements;
    if (header != "sections") return -4;
    for (int i = 0; i < elements; i++) {
        file >> name >> lines;
        LSection::add_section(filename, file, name, lines);
    }
    return 0;
}

int main(int argc, char **argv) {
    int error = read_file("test1.o");
    if (error) {
        cout << "ERROR " << error;
    } else {
        LSymTable::print();
        LSection::print();
    }
}