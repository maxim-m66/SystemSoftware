# Output files
LEXER_OUT = src/lexer.cpp
LEXER_HEADER = inc/lexer.hpp
PARSER_OUT = src/parser.cpp
ASEMBLER_OUT = asembler
PARSER_HEADER = inc/parser.hpp
EMULATOR_OUT = emulator

# Input files
LEXER_IN = misc/lexer.l
PARSER_IN = misc/parser.y
ASEMBLER_IN = src/asembler.cpp src/section.cpp src/codes.cpp src/table.cpp src/symbol_table.cpp src/elf.cpp
EMULATOR_IN = src/emulator.cpp

# Tools
LEX = flex
PARSE = bison
COMPILE = g++

# Flags
LEX_FLAGS = --header-file=$(LEXER_HEADER) -o $(LEXER_OUT)
PARSE_FLAGS = -d -o $(PARSER_OUT)
ASEMBLER_FLAGS = -o $(ASEMBLER_OUT)
EMULATOR_FLAGS = -o $(EMULATOR_OUT)

# Input variables
MSG ?=Update

all: lexer parser asembler runasm

asembler: $(ASEMBLER_IN) lexer parser
	$(COMPILE) $(ASEMBLER_FLAGS) $(ASEMBLER_IN) $(LEXER_OUT) $(PARSER_OUT)

runasm:
	./$(ASEMBLER_OUT) tests/test1.s

lexer: $(LEXER_IN)
	$(LEX) $(LEX_FLAGS) $(LEXER_IN)

parser: $(PARSER_IN)
	$(PARSE) $(PARSE_FLAGS) $(PARSER_IN)
	mv src/*.hpp inc/

emulator:
	$(COMPILE) $(EMULATOR_FLAGS) $(EMULATOR_IN)

runemu:
	./$(EMULATOR_OUT)

clean:
	rm -f $(LEXER_OUT) $(LEXER_HEADER) $(PARSER_OUT) $(PARSER_HEADER) $(ASEMBLER_OUT) tests/*.o

git: clean
	git add .
	git commit -m "${MSG}"
	git push -u origin master

.PHONY: all clean asembler run lexer parser