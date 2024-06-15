//
// Created by ss on 5/9/24.
//

#include "../inc/elf.hpp"

#include <fstream>
#include <iostream>


std::ofstream& operator<<(std::ofstream& out, char number) {
    char data = number;
    out.write(reinterpret_cast<char*>(&data), sizeof(data));
    return out;
}

std::ofstream& operator<<(std::ofstream& out, unsigned char number) {
    unsigned char data = number;
    out.write(reinterpret_cast<char*>(&data), sizeof(data));
    return out;
}

std::ofstream& operator<<(std::ofstream& out, short number) {
    short data = number;
    out.write(reinterpret_cast<char*>(&data), sizeof(data));
    return out;
}

std::ofstream& operator<<(std::ofstream& out, unsigned short number) {
    unsigned short data = number;
    out.write(reinterpret_cast<char*>(&data), sizeof(data));
    return out;
}

std::ofstream& operator<<(std::ofstream& out, int number) {
    int data = number;
    out.write(reinterpret_cast<char*>(&data), sizeof(data));
    return out;
}

std::ofstream &operator<<(std::ofstream &out, unsigned int number) {
    unsigned int data = number;
    out.write(reinterpret_cast<char*>(&data), sizeof(data));
    return out;
}

std::ofstream& operator<<(std::ofstream& out, long number) {
    long data = number;
    out.write(reinterpret_cast<char*>(&data), sizeof(data));
    return out;
}

std::ofstream& operator<<(std::ofstream& out, unsigned long number) {
    unsigned long data = number;
    out.write(reinterpret_cast<char*>(&data), sizeof(data));
    return out;
}

void write_elf_header(std::ofstream& out) {
    for (unsigned char i : Elf64_Ehdr.e_ident) {
        out << i;
    }
    out << Elf64_Ehdr.e_type; // ELF file type
    out << Elf64_Ehdr.e_machine; // Architecture
    out << Elf64_Ehdr.e_version; // Object file version
    out << Elf64_Ehdr.e_entry; // Entry point virtual address
    out << Elf64_Ehdr.e_phoff; // Program header table file offset
    out << Elf64_Ehdr.e_shoff; // Section header table file offset
    out << Elf64_Ehdr.e_flags; // Processor-specific flags
    out << Elf64_Ehdr.e_ehsize; // ELF header size
    out << Elf64_Ehdr.e_phentsize; // Program header table entry size
    out << Elf64_Ehdr.e_phnum; // Program header table entry count
    out << Elf64_Ehdr.e_shentsize; // Section header table entry size
    out << Elf64_Ehdr.e_shnum; // Section header table entry count
    out << Elf64_Ehdr.e_shstrndx; // Section header string table index
}

void make_linkable(std::ofstream& out, const std::vector<Section*>& sections) {
    Elf64_Ehdr.e_phoff = 0;
    Elf64_Ehdr.e_shoff = 64;
    Elf64_Ehdr.e_phnum = sections.size();
    write_elf_header(out);
    Elf64_Shdr* headers = new Elf64_Shdr[sections.size() + 2];
    size_t offset = 64 + sizeof(Elf64_Ehdr) * sections.size();
    for (int i = 0; i < sections.size(); i++) {
        headers[i].sh_name = sections[i]->get_offset();
        if (sections[i]->get_name() == "txt") {
            headers[i].sh_type = SHT_PROGBITS;
            headers[i].sh_flags = SHF_EXECINSTR;
            }
        else if (sections[i]->get_name() == "data") {
            headers[i].sh_type = SHT_PROGBITS;
            headers[i].sh_flags = SHF_WRITE | SHF_ALLOC;
            }
        else if (sections[i]->get_name() == ".strtab") {
            headers[i].sh_type = SHT_STRTAB;
            headers[i].sh_flags = SHF_STRINGS;
            }
        else {
            headers[i].sh_type = SHT_PROGBITS;
            headers[i].sh_flags = REGULAR;
        }
        headers[i].sh_addr = 0;
        headers[i].sh_offset = offset;
        headers[i].sh_size = sections[i]->size();
        out << headers[i];
        offset += sections[i]->size();
    }
    delete headers;
    for(auto *section: sections) {
        out << *section;
    }
    delete &sections;
}
