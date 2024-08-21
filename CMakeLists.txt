cmake_minimum_required(VERSION 3.28)
project(resenje)

set(CMAKE_CXX_STANDARD 17)

add_executable(resenje
        src/lexer.cpp
        src/parser.cpp
        src/asembler.cpp
        src/section.cpp
        inc/section.hpp
        src/codes.cpp
        inc/codes.hpp
        src/codes.cpp
        src/table.cpp
        inc/table.hpp
        src/symbol_table.cpp
        inc/symbol_table.hpp
        src/emulator.cpp
        src/elf.cpp
        inc/elf.hpp
        src/linker.cpp
        src/linker.cpp
        src/LSymTable.cpp
        inc/LSymTable.hpp
        inc/binding.hpp
        src/LSection.cpp
        inc/LSection.hpp)
