cmake_minimum_required(VERSION 3.28)
project(resenje)

set(CMAKE_CXX_STANDARD 17)

add_executable(resenje main.cpp
        src/lexer.cpp
        src/parser.cpp
        src/asembler.cpp
        src/section.cpp
        inc/section.hpp)
