# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.29

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:

#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:

# Disable VCS-based implicit rules.
% : %,v

# Disable VCS-based implicit rules.
% : RCS/%

# Disable VCS-based implicit rules.
% : RCS/%,v

# Disable VCS-based implicit rules.
% : SCCS/s.%

# Disable VCS-based implicit rules.
% : s.%

.SUFFIXES: .hpux_make_needs_suffix_list

# Command-line flag to silence nested $(MAKE).
$(VERBOSE)MAKESILENT = -s

#Suppress display of executed commands.
$(VERBOSE).SILENT:

# A target that is always out of date.
cmake_force:
.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /snap/clion/291/bin/cmake/linux/x64/bin/cmake

# The command to remove a file.
RM = /snap/clion/291/bin/cmake/linux/x64/bin/cmake -E rm -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /home/os/CLionProjects/SystemSoftware

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /home/os/CLionProjects/SystemSoftware/cmake-build-debug

# Include any dependencies generated for this target.
include CMakeFiles/resenje.dir/depend.make
# Include any dependencies generated by the compiler for this target.
include CMakeFiles/resenje.dir/compiler_depend.make

# Include the progress variables for this target.
include CMakeFiles/resenje.dir/progress.make

# Include the compile flags for this target's objects.
include CMakeFiles/resenje.dir/flags.make

CMakeFiles/resenje.dir/src/lexer.cpp.o: CMakeFiles/resenje.dir/flags.make
CMakeFiles/resenje.dir/src/lexer.cpp.o: /home/os/CLionProjects/SystemSoftware/src/lexer.cpp
CMakeFiles/resenje.dir/src/lexer.cpp.o: CMakeFiles/resenje.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green --progress-dir=/home/os/CLionProjects/SystemSoftware/cmake-build-debug/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object CMakeFiles/resenje.dir/src/lexer.cpp.o"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT CMakeFiles/resenje.dir/src/lexer.cpp.o -MF CMakeFiles/resenje.dir/src/lexer.cpp.o.d -o CMakeFiles/resenje.dir/src/lexer.cpp.o -c /home/os/CLionProjects/SystemSoftware/src/lexer.cpp

CMakeFiles/resenje.dir/src/lexer.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Preprocessing CXX source to CMakeFiles/resenje.dir/src/lexer.cpp.i"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/os/CLionProjects/SystemSoftware/src/lexer.cpp > CMakeFiles/resenje.dir/src/lexer.cpp.i

CMakeFiles/resenje.dir/src/lexer.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Compiling CXX source to assembly CMakeFiles/resenje.dir/src/lexer.cpp.s"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/os/CLionProjects/SystemSoftware/src/lexer.cpp -o CMakeFiles/resenje.dir/src/lexer.cpp.s

CMakeFiles/resenje.dir/src/parser.cpp.o: CMakeFiles/resenje.dir/flags.make
CMakeFiles/resenje.dir/src/parser.cpp.o: /home/os/CLionProjects/SystemSoftware/src/parser.cpp
CMakeFiles/resenje.dir/src/parser.cpp.o: CMakeFiles/resenje.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green --progress-dir=/home/os/CLionProjects/SystemSoftware/cmake-build-debug/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Building CXX object CMakeFiles/resenje.dir/src/parser.cpp.o"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT CMakeFiles/resenje.dir/src/parser.cpp.o -MF CMakeFiles/resenje.dir/src/parser.cpp.o.d -o CMakeFiles/resenje.dir/src/parser.cpp.o -c /home/os/CLionProjects/SystemSoftware/src/parser.cpp

CMakeFiles/resenje.dir/src/parser.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Preprocessing CXX source to CMakeFiles/resenje.dir/src/parser.cpp.i"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/os/CLionProjects/SystemSoftware/src/parser.cpp > CMakeFiles/resenje.dir/src/parser.cpp.i

CMakeFiles/resenje.dir/src/parser.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Compiling CXX source to assembly CMakeFiles/resenje.dir/src/parser.cpp.s"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/os/CLionProjects/SystemSoftware/src/parser.cpp -o CMakeFiles/resenje.dir/src/parser.cpp.s

CMakeFiles/resenje.dir/src/asembler.cpp.o: CMakeFiles/resenje.dir/flags.make
CMakeFiles/resenje.dir/src/asembler.cpp.o: /home/os/CLionProjects/SystemSoftware/src/asembler.cpp
CMakeFiles/resenje.dir/src/asembler.cpp.o: CMakeFiles/resenje.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green --progress-dir=/home/os/CLionProjects/SystemSoftware/cmake-build-debug/CMakeFiles --progress-num=$(CMAKE_PROGRESS_3) "Building CXX object CMakeFiles/resenje.dir/src/asembler.cpp.o"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT CMakeFiles/resenje.dir/src/asembler.cpp.o -MF CMakeFiles/resenje.dir/src/asembler.cpp.o.d -o CMakeFiles/resenje.dir/src/asembler.cpp.o -c /home/os/CLionProjects/SystemSoftware/src/asembler.cpp

CMakeFiles/resenje.dir/src/asembler.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Preprocessing CXX source to CMakeFiles/resenje.dir/src/asembler.cpp.i"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/os/CLionProjects/SystemSoftware/src/asembler.cpp > CMakeFiles/resenje.dir/src/asembler.cpp.i

CMakeFiles/resenje.dir/src/asembler.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Compiling CXX source to assembly CMakeFiles/resenje.dir/src/asembler.cpp.s"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/os/CLionProjects/SystemSoftware/src/asembler.cpp -o CMakeFiles/resenje.dir/src/asembler.cpp.s

CMakeFiles/resenje.dir/src/section.cpp.o: CMakeFiles/resenje.dir/flags.make
CMakeFiles/resenje.dir/src/section.cpp.o: /home/os/CLionProjects/SystemSoftware/src/section.cpp
CMakeFiles/resenje.dir/src/section.cpp.o: CMakeFiles/resenje.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green --progress-dir=/home/os/CLionProjects/SystemSoftware/cmake-build-debug/CMakeFiles --progress-num=$(CMAKE_PROGRESS_4) "Building CXX object CMakeFiles/resenje.dir/src/section.cpp.o"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT CMakeFiles/resenje.dir/src/section.cpp.o -MF CMakeFiles/resenje.dir/src/section.cpp.o.d -o CMakeFiles/resenje.dir/src/section.cpp.o -c /home/os/CLionProjects/SystemSoftware/src/section.cpp

CMakeFiles/resenje.dir/src/section.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Preprocessing CXX source to CMakeFiles/resenje.dir/src/section.cpp.i"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/os/CLionProjects/SystemSoftware/src/section.cpp > CMakeFiles/resenje.dir/src/section.cpp.i

CMakeFiles/resenje.dir/src/section.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Compiling CXX source to assembly CMakeFiles/resenje.dir/src/section.cpp.s"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/os/CLionProjects/SystemSoftware/src/section.cpp -o CMakeFiles/resenje.dir/src/section.cpp.s

CMakeFiles/resenje.dir/src/codes.cpp.o: CMakeFiles/resenje.dir/flags.make
CMakeFiles/resenje.dir/src/codes.cpp.o: /home/os/CLionProjects/SystemSoftware/src/codes.cpp
CMakeFiles/resenje.dir/src/codes.cpp.o: CMakeFiles/resenje.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green --progress-dir=/home/os/CLionProjects/SystemSoftware/cmake-build-debug/CMakeFiles --progress-num=$(CMAKE_PROGRESS_5) "Building CXX object CMakeFiles/resenje.dir/src/codes.cpp.o"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT CMakeFiles/resenje.dir/src/codes.cpp.o -MF CMakeFiles/resenje.dir/src/codes.cpp.o.d -o CMakeFiles/resenje.dir/src/codes.cpp.o -c /home/os/CLionProjects/SystemSoftware/src/codes.cpp

CMakeFiles/resenje.dir/src/codes.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Preprocessing CXX source to CMakeFiles/resenje.dir/src/codes.cpp.i"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/os/CLionProjects/SystemSoftware/src/codes.cpp > CMakeFiles/resenje.dir/src/codes.cpp.i

CMakeFiles/resenje.dir/src/codes.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Compiling CXX source to assembly CMakeFiles/resenje.dir/src/codes.cpp.s"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/os/CLionProjects/SystemSoftware/src/codes.cpp -o CMakeFiles/resenje.dir/src/codes.cpp.s

CMakeFiles/resenje.dir/src/table.cpp.o: CMakeFiles/resenje.dir/flags.make
CMakeFiles/resenje.dir/src/table.cpp.o: /home/os/CLionProjects/SystemSoftware/src/table.cpp
CMakeFiles/resenje.dir/src/table.cpp.o: CMakeFiles/resenje.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green --progress-dir=/home/os/CLionProjects/SystemSoftware/cmake-build-debug/CMakeFiles --progress-num=$(CMAKE_PROGRESS_6) "Building CXX object CMakeFiles/resenje.dir/src/table.cpp.o"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT CMakeFiles/resenje.dir/src/table.cpp.o -MF CMakeFiles/resenje.dir/src/table.cpp.o.d -o CMakeFiles/resenje.dir/src/table.cpp.o -c /home/os/CLionProjects/SystemSoftware/src/table.cpp

CMakeFiles/resenje.dir/src/table.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Preprocessing CXX source to CMakeFiles/resenje.dir/src/table.cpp.i"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/os/CLionProjects/SystemSoftware/src/table.cpp > CMakeFiles/resenje.dir/src/table.cpp.i

CMakeFiles/resenje.dir/src/table.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Compiling CXX source to assembly CMakeFiles/resenje.dir/src/table.cpp.s"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/os/CLionProjects/SystemSoftware/src/table.cpp -o CMakeFiles/resenje.dir/src/table.cpp.s

CMakeFiles/resenje.dir/src/symbol_table.cpp.o: CMakeFiles/resenje.dir/flags.make
CMakeFiles/resenje.dir/src/symbol_table.cpp.o: /home/os/CLionProjects/SystemSoftware/src/symbol_table.cpp
CMakeFiles/resenje.dir/src/symbol_table.cpp.o: CMakeFiles/resenje.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green --progress-dir=/home/os/CLionProjects/SystemSoftware/cmake-build-debug/CMakeFiles --progress-num=$(CMAKE_PROGRESS_7) "Building CXX object CMakeFiles/resenje.dir/src/symbol_table.cpp.o"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT CMakeFiles/resenje.dir/src/symbol_table.cpp.o -MF CMakeFiles/resenje.dir/src/symbol_table.cpp.o.d -o CMakeFiles/resenje.dir/src/symbol_table.cpp.o -c /home/os/CLionProjects/SystemSoftware/src/symbol_table.cpp

CMakeFiles/resenje.dir/src/symbol_table.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Preprocessing CXX source to CMakeFiles/resenje.dir/src/symbol_table.cpp.i"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/os/CLionProjects/SystemSoftware/src/symbol_table.cpp > CMakeFiles/resenje.dir/src/symbol_table.cpp.i

CMakeFiles/resenje.dir/src/symbol_table.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Compiling CXX source to assembly CMakeFiles/resenje.dir/src/symbol_table.cpp.s"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/os/CLionProjects/SystemSoftware/src/symbol_table.cpp -o CMakeFiles/resenje.dir/src/symbol_table.cpp.s

CMakeFiles/resenje.dir/src/emulator.cpp.o: CMakeFiles/resenje.dir/flags.make
CMakeFiles/resenje.dir/src/emulator.cpp.o: /home/os/CLionProjects/SystemSoftware/src/emulator.cpp
CMakeFiles/resenje.dir/src/emulator.cpp.o: CMakeFiles/resenje.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green --progress-dir=/home/os/CLionProjects/SystemSoftware/cmake-build-debug/CMakeFiles --progress-num=$(CMAKE_PROGRESS_8) "Building CXX object CMakeFiles/resenje.dir/src/emulator.cpp.o"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT CMakeFiles/resenje.dir/src/emulator.cpp.o -MF CMakeFiles/resenje.dir/src/emulator.cpp.o.d -o CMakeFiles/resenje.dir/src/emulator.cpp.o -c /home/os/CLionProjects/SystemSoftware/src/emulator.cpp

CMakeFiles/resenje.dir/src/emulator.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Preprocessing CXX source to CMakeFiles/resenje.dir/src/emulator.cpp.i"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/os/CLionProjects/SystemSoftware/src/emulator.cpp > CMakeFiles/resenje.dir/src/emulator.cpp.i

CMakeFiles/resenje.dir/src/emulator.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Compiling CXX source to assembly CMakeFiles/resenje.dir/src/emulator.cpp.s"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/os/CLionProjects/SystemSoftware/src/emulator.cpp -o CMakeFiles/resenje.dir/src/emulator.cpp.s

CMakeFiles/resenje.dir/src/elf.cpp.o: CMakeFiles/resenje.dir/flags.make
CMakeFiles/resenje.dir/src/elf.cpp.o: /home/os/CLionProjects/SystemSoftware/src/elf.cpp
CMakeFiles/resenje.dir/src/elf.cpp.o: CMakeFiles/resenje.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green --progress-dir=/home/os/CLionProjects/SystemSoftware/cmake-build-debug/CMakeFiles --progress-num=$(CMAKE_PROGRESS_9) "Building CXX object CMakeFiles/resenje.dir/src/elf.cpp.o"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT CMakeFiles/resenje.dir/src/elf.cpp.o -MF CMakeFiles/resenje.dir/src/elf.cpp.o.d -o CMakeFiles/resenje.dir/src/elf.cpp.o -c /home/os/CLionProjects/SystemSoftware/src/elf.cpp

CMakeFiles/resenje.dir/src/elf.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Preprocessing CXX source to CMakeFiles/resenje.dir/src/elf.cpp.i"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/os/CLionProjects/SystemSoftware/src/elf.cpp > CMakeFiles/resenje.dir/src/elf.cpp.i

CMakeFiles/resenje.dir/src/elf.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Compiling CXX source to assembly CMakeFiles/resenje.dir/src/elf.cpp.s"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/os/CLionProjects/SystemSoftware/src/elf.cpp -o CMakeFiles/resenje.dir/src/elf.cpp.s

CMakeFiles/resenje.dir/src/linker.cpp.o: CMakeFiles/resenje.dir/flags.make
CMakeFiles/resenje.dir/src/linker.cpp.o: /home/os/CLionProjects/SystemSoftware/src/linker.cpp
CMakeFiles/resenje.dir/src/linker.cpp.o: CMakeFiles/resenje.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green --progress-dir=/home/os/CLionProjects/SystemSoftware/cmake-build-debug/CMakeFiles --progress-num=$(CMAKE_PROGRESS_10) "Building CXX object CMakeFiles/resenje.dir/src/linker.cpp.o"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT CMakeFiles/resenje.dir/src/linker.cpp.o -MF CMakeFiles/resenje.dir/src/linker.cpp.o.d -o CMakeFiles/resenje.dir/src/linker.cpp.o -c /home/os/CLionProjects/SystemSoftware/src/linker.cpp

CMakeFiles/resenje.dir/src/linker.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Preprocessing CXX source to CMakeFiles/resenje.dir/src/linker.cpp.i"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/os/CLionProjects/SystemSoftware/src/linker.cpp > CMakeFiles/resenje.dir/src/linker.cpp.i

CMakeFiles/resenje.dir/src/linker.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Compiling CXX source to assembly CMakeFiles/resenje.dir/src/linker.cpp.s"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/os/CLionProjects/SystemSoftware/src/linker.cpp -o CMakeFiles/resenje.dir/src/linker.cpp.s

CMakeFiles/resenje.dir/src/LSymTable.cpp.o: CMakeFiles/resenje.dir/flags.make
CMakeFiles/resenje.dir/src/LSymTable.cpp.o: /home/os/CLionProjects/SystemSoftware/src/LSymTable.cpp
CMakeFiles/resenje.dir/src/LSymTable.cpp.o: CMakeFiles/resenje.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green --progress-dir=/home/os/CLionProjects/SystemSoftware/cmake-build-debug/CMakeFiles --progress-num=$(CMAKE_PROGRESS_11) "Building CXX object CMakeFiles/resenje.dir/src/LSymTable.cpp.o"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT CMakeFiles/resenje.dir/src/LSymTable.cpp.o -MF CMakeFiles/resenje.dir/src/LSymTable.cpp.o.d -o CMakeFiles/resenje.dir/src/LSymTable.cpp.o -c /home/os/CLionProjects/SystemSoftware/src/LSymTable.cpp

CMakeFiles/resenje.dir/src/LSymTable.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Preprocessing CXX source to CMakeFiles/resenje.dir/src/LSymTable.cpp.i"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/os/CLionProjects/SystemSoftware/src/LSymTable.cpp > CMakeFiles/resenje.dir/src/LSymTable.cpp.i

CMakeFiles/resenje.dir/src/LSymTable.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Compiling CXX source to assembly CMakeFiles/resenje.dir/src/LSymTable.cpp.s"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/os/CLionProjects/SystemSoftware/src/LSymTable.cpp -o CMakeFiles/resenje.dir/src/LSymTable.cpp.s

CMakeFiles/resenje.dir/src/LSection.cpp.o: CMakeFiles/resenje.dir/flags.make
CMakeFiles/resenje.dir/src/LSection.cpp.o: /home/os/CLionProjects/SystemSoftware/src/LSection.cpp
CMakeFiles/resenje.dir/src/LSection.cpp.o: CMakeFiles/resenje.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green --progress-dir=/home/os/CLionProjects/SystemSoftware/cmake-build-debug/CMakeFiles --progress-num=$(CMAKE_PROGRESS_12) "Building CXX object CMakeFiles/resenje.dir/src/LSection.cpp.o"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT CMakeFiles/resenje.dir/src/LSection.cpp.o -MF CMakeFiles/resenje.dir/src/LSection.cpp.o.d -o CMakeFiles/resenje.dir/src/LSection.cpp.o -c /home/os/CLionProjects/SystemSoftware/src/LSection.cpp

CMakeFiles/resenje.dir/src/LSection.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Preprocessing CXX source to CMakeFiles/resenje.dir/src/LSection.cpp.i"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/os/CLionProjects/SystemSoftware/src/LSection.cpp > CMakeFiles/resenje.dir/src/LSection.cpp.i

CMakeFiles/resenje.dir/src/LSection.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Compiling CXX source to assembly CMakeFiles/resenje.dir/src/LSection.cpp.s"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/os/CLionProjects/SystemSoftware/src/LSection.cpp -o CMakeFiles/resenje.dir/src/LSection.cpp.s

CMakeFiles/resenje.dir/src/int_util.cpp.o: CMakeFiles/resenje.dir/flags.make
CMakeFiles/resenje.dir/src/int_util.cpp.o: /home/os/CLionProjects/SystemSoftware/src/int_util.cpp
CMakeFiles/resenje.dir/src/int_util.cpp.o: CMakeFiles/resenje.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green --progress-dir=/home/os/CLionProjects/SystemSoftware/cmake-build-debug/CMakeFiles --progress-num=$(CMAKE_PROGRESS_13) "Building CXX object CMakeFiles/resenje.dir/src/int_util.cpp.o"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT CMakeFiles/resenje.dir/src/int_util.cpp.o -MF CMakeFiles/resenje.dir/src/int_util.cpp.o.d -o CMakeFiles/resenje.dir/src/int_util.cpp.o -c /home/os/CLionProjects/SystemSoftware/src/int_util.cpp

CMakeFiles/resenje.dir/src/int_util.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Preprocessing CXX source to CMakeFiles/resenje.dir/src/int_util.cpp.i"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/os/CLionProjects/SystemSoftware/src/int_util.cpp > CMakeFiles/resenje.dir/src/int_util.cpp.i

CMakeFiles/resenje.dir/src/int_util.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Compiling CXX source to assembly CMakeFiles/resenje.dir/src/int_util.cpp.s"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/os/CLionProjects/SystemSoftware/src/int_util.cpp -o CMakeFiles/resenje.dir/src/int_util.cpp.s

CMakeFiles/resenje.dir/src/FinishedSection.cpp.o: CMakeFiles/resenje.dir/flags.make
CMakeFiles/resenje.dir/src/FinishedSection.cpp.o: /home/os/CLionProjects/SystemSoftware/src/FinishedSection.cpp
CMakeFiles/resenje.dir/src/FinishedSection.cpp.o: CMakeFiles/resenje.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green --progress-dir=/home/os/CLionProjects/SystemSoftware/cmake-build-debug/CMakeFiles --progress-num=$(CMAKE_PROGRESS_14) "Building CXX object CMakeFiles/resenje.dir/src/FinishedSection.cpp.o"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT CMakeFiles/resenje.dir/src/FinishedSection.cpp.o -MF CMakeFiles/resenje.dir/src/FinishedSection.cpp.o.d -o CMakeFiles/resenje.dir/src/FinishedSection.cpp.o -c /home/os/CLionProjects/SystemSoftware/src/FinishedSection.cpp

CMakeFiles/resenje.dir/src/FinishedSection.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Preprocessing CXX source to CMakeFiles/resenje.dir/src/FinishedSection.cpp.i"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/os/CLionProjects/SystemSoftware/src/FinishedSection.cpp > CMakeFiles/resenje.dir/src/FinishedSection.cpp.i

CMakeFiles/resenje.dir/src/FinishedSection.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Compiling CXX source to assembly CMakeFiles/resenje.dir/src/FinishedSection.cpp.s"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/os/CLionProjects/SystemSoftware/src/FinishedSection.cpp -o CMakeFiles/resenje.dir/src/FinishedSection.cpp.s

# Object files for target resenje
resenje_OBJECTS = \
"CMakeFiles/resenje.dir/src/lexer.cpp.o" \
"CMakeFiles/resenje.dir/src/parser.cpp.o" \
"CMakeFiles/resenje.dir/src/asembler.cpp.o" \
"CMakeFiles/resenje.dir/src/section.cpp.o" \
"CMakeFiles/resenje.dir/src/codes.cpp.o" \
"CMakeFiles/resenje.dir/src/table.cpp.o" \
"CMakeFiles/resenje.dir/src/symbol_table.cpp.o" \
"CMakeFiles/resenje.dir/src/emulator.cpp.o" \
"CMakeFiles/resenje.dir/src/elf.cpp.o" \
"CMakeFiles/resenje.dir/src/linker.cpp.o" \
"CMakeFiles/resenje.dir/src/LSymTable.cpp.o" \
"CMakeFiles/resenje.dir/src/LSection.cpp.o" \
"CMakeFiles/resenje.dir/src/int_util.cpp.o" \
"CMakeFiles/resenje.dir/src/FinishedSection.cpp.o"

# External object files for target resenje
resenje_EXTERNAL_OBJECTS =

resenje: CMakeFiles/resenje.dir/src/lexer.cpp.o
resenje: CMakeFiles/resenje.dir/src/parser.cpp.o
resenje: CMakeFiles/resenje.dir/src/asembler.cpp.o
resenje: CMakeFiles/resenje.dir/src/section.cpp.o
resenje: CMakeFiles/resenje.dir/src/codes.cpp.o
resenje: CMakeFiles/resenje.dir/src/table.cpp.o
resenje: CMakeFiles/resenje.dir/src/symbol_table.cpp.o
resenje: CMakeFiles/resenje.dir/src/emulator.cpp.o
resenje: CMakeFiles/resenje.dir/src/elf.cpp.o
resenje: CMakeFiles/resenje.dir/src/linker.cpp.o
resenje: CMakeFiles/resenje.dir/src/LSymTable.cpp.o
resenje: CMakeFiles/resenje.dir/src/LSection.cpp.o
resenje: CMakeFiles/resenje.dir/src/int_util.cpp.o
resenje: CMakeFiles/resenje.dir/src/FinishedSection.cpp.o
resenje: CMakeFiles/resenje.dir/build.make
resenje: CMakeFiles/resenje.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green --bold --progress-dir=/home/os/CLionProjects/SystemSoftware/cmake-build-debug/CMakeFiles --progress-num=$(CMAKE_PROGRESS_15) "Linking CXX executable resenje"
	$(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/resenje.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
CMakeFiles/resenje.dir/build: resenje
.PHONY : CMakeFiles/resenje.dir/build

CMakeFiles/resenje.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/resenje.dir/cmake_clean.cmake
.PHONY : CMakeFiles/resenje.dir/clean

CMakeFiles/resenje.dir/depend:
	cd /home/os/CLionProjects/SystemSoftware/cmake-build-debug && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/os/CLionProjects/SystemSoftware /home/os/CLionProjects/SystemSoftware /home/os/CLionProjects/SystemSoftware/cmake-build-debug /home/os/CLionProjects/SystemSoftware/cmake-build-debug /home/os/CLionProjects/SystemSoftware/cmake-build-debug/CMakeFiles/resenje.dir/DependInfo.cmake "--color=$(COLOR)"
.PHONY : CMakeFiles/resenje.dir/depend

