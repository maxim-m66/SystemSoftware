#ifndef ELF_HPP
#define ELF_HPP

#define EI_MAG0 0 /* File identification byte 0 index */
#define EI_MAG1 1 /* File identification byte 1 index */
#define EI_MAG2 2 /* File identification byte 2 index */
#define EI_MAG3 3 /* File identification byte 3 index */
#define EI_CLASS 4 /* File class byte index */
#define EI_DATA 5 /* Data encoding byte index */
#define EI_VERSION 6 /* File version byte index */
#define EI_OSABI 7 /* OS ABI identification */
#define EI_ABIVERSION 8 /* ABI version */
#define EI_PAD 9 /* Byte index of padding bytes */

#define ELFCLASSNONE 0 /* Invalid class */
#define ELFCLASS32 1 /* 32-bit objects */
#define ELFCLASS64 2 /* 64-bit objects */

#define ELFDATANONE 0 /* Invalid data encoding */
#define ELFDATA2LSB 1 /* 2's complement, little endian */
#define ELFDATA2MSB 2 /* 2's complement, big endian */

#define ELFOSABI_NONE 0 /* UNIX System V ABI */
#define ELFOSABI_SYSV 0 /* Alias. */
#define ELFOSABI_HPUX 1 /* HP-UX */
#define ELFOSABI_NETBSD 2 /* NetBSD. */
#define ELFOSABI_GNU 3 /* Object uses GNU ELF extensions. */

#define ET_NONE 0 /* No file type */
#define ET_REL 1 /* Relocatable file */
#define ET_EXEC 2 /* Executable file */
#define ET_DYN 3 /* Shared object file */

#define EM_NONE 0 /* No machine */
#define EM_386 3 /* Intel 80386 */
#define EM_860 7 /* Intel 80860 */
#define EM_ARM 40 /* ARM */
#define EM_MIPS_X 51 /* Stanford MIPS-X */
#define EM_X86_64 62 /* AMD x86-64 architecture */
#define EM_RISCV 243 /* RISC-V */

#define EV_NONE 0 /* Invalid ELF version */
#define EV_CURRENT 1 /* Current version */

#define SHT_NULL 0 /* Section header table entry unused */
#define SHT_PROGBITS 1 /* Program data */
#define SHT_SYMTAB 2 /* Symbol table */
#define SHT_STRTAB 3 /* String table */
#define SHT_RELA 4 /* Relocation entries with addends */

#define SHF_WRITE (1 << 0) /* Writable */
#define SHF_ALLOC (1 << 1) /* Occupies memory during execution */
#define SHF_EXECINSTR (1 << 2) /* Executable */
#define SHF_STRINGS (1 << 5) /* Contains nul-terminated strings */

#define REGULAR SHF_WRITE | SHF_ALLOC | SHF_EXECINSTR



#include <ostream>
#include <vector>

#include "section.hpp"

typedef unsigned long Elf64_Addr;
typedef unsigned long Elf64_Off;
typedef unsigned short Elf64_Half;
typedef unsigned int Elf64_Word;
typedef signed int Elf64_Sword;
typedef unsigned long Elf64_Xword;
typedef signed long Elf64_Sxword;

#define EI_NIDENT 16

struct {
    unsigned char e_ident[EI_NIDENT] = {
        0x7f, 'E', 'L', 'F', ELFCLASS32, ELFDATA2LSB, ELFOSABI_SYSV, 0, 0, 0, 0, 0, 0, 0, 0, 0
    };
    Elf64_Half e_type = ET_REL; // ELF file type
    Elf64_Half e_machine = EM_NONE; // Architecture
    Elf64_Word e_version = EV_CURRENT; // Object file version
    Elf64_Addr e_entry = 0; // Entry point virtual address
    Elf64_Off e_phoff = 0; // Program header table file offset
    Elf64_Off e_shoff = 64; // Section header table file offset
    Elf64_Word e_flags = 0; // Processor-specific flags
    Elf64_Half e_ehsize = 64; // ELF header size
    Elf64_Half e_phentsize = 64; // Program header table entry size
    Elf64_Half e_phnum = 0; // Program header table entry count
    Elf64_Half e_shentsize = 64; // Section header table entry size
    Elf64_Half e_shnum = 0; // Section header table entry count
    Elf64_Half e_shstrndx = 0; // Section header string table index
} Elf64_Ehdr;

struct Elf64_Shdr {
    Elf64_Word sh_name;
    Elf64_Word sh_type;
    Elf64_Xword sh_flags;
    Elf64_Addr sh_addr;
    Elf64_Off sh_offset;
    Elf64_Xword sh_size;
    Elf64_Word sh_link;
    Elf64_Word sh_info;
    Elf64_Xword sh_addralign;
    Elf64_Xword sh_entsize;
    friend std::ostream& operator<<(std::ostream& out, const Elf64_Shdr& section) {
        out << section.sh_name << section.sh_type << section.sh_flags << section.sh_addr << section.sh_offset << section.sh_size << section.sh_link << section.sh_info << section.sh_addralign << section.sh_entsize;
        return out;
    }
};

void make_linkable(std::ofstream& out, const std::vector<Section*>& sections);

inline void write_elf_header(std::ostream& out);

#endif
