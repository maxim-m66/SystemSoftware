# Output files
LEXER_OUT = src/lexer.cpp
LEXER_HEADER = inc/lexer.hpp
PARSER_OUT = src/parser.cpp
ASEMBLER_OUT = asembler
PARSER_HEADER = inc/parser.hpp
LINKER_OUT = linker
EMULATOR_OUT = emulator

# Input files
LEXER_IN = misc/lexer.l
PARSER_IN = misc/parser.y
ASEMBLER_IN = src/asembler.cpp src/section.cpp src/codes.cpp src/symbol_table.cpp src/int_util.cpp
LINKER_IN = src/linker.cpp src/LSymTable.cpp src/LinkerSection.cpp src/int_util.cpp
EMULATOR_IN = src/emulator.cpp src/reg.cpp

# Tools
LEX = flex
PARSE = bison
COMPILE = g++

# Flags
LEX_FLAGS = --header-file=$(LEXER_HEADER) -o $(LEXER_OUT)
PARSE_FLAGS = -d -o $(PARSER_OUT)
ASEMBLER_FLAGS = -o $(ASEMBLER_OUT)
LINKER_FLAGS = -o $(LINKER_OUT)
EMULATOR_FLAGS = -o $(EMULATOR_OUT)

FILENAME = tests/test1

# Input variables
MSG ?=Update

all: asembler linker emulator

lexer: $(LEXER_IN)
	$(LEX) $(LEX_FLAGS) $(LEXER_IN)

parser: $(PARSER_IN)
	$(PARSE) $(PARSE_FLAGS) $(PARSER_IN)
	mv src/*.hpp inc/

asembler: $(ASEMBLER_IN) lexer parser
	$(COMPILE) $(ASEMBLER_FLAGS) $(ASEMBLER_IN) $(LEXER_OUT) $(PARSER_OUT)

emulator: cleanemulator
	$(COMPILE) $(EMULATOR_FLAGS) $(EMULATOR_IN)

linker: cleanlinker
	$(COMPILE) $(LINKER_FLAGS) $(LINKER_IN)

cleanlinker:
	rm -f $(LINKER_OUT)

cleanemulator:
	rm -f $(EMULATOR_OUT)

clean: cleana cleanb cleanc
	rm -f $(LEXER_OUT) $(LEXER_HEADER) $(PARSER_OUT) $(PARSER_HEADER) $(ASEMBLER_OUT) $(LINKER_OUT) $(EMULATOR_OUT) tests/*.o tests/*.hex mm210092.zip

rlc:
	./linker -relocatable -o tests/rel.o tests/test1.o

run:
	./$(ASEMBLER_OUT) $(FILENAME).s
	./$(LINKER_OUT) -o $(FILENAME).hex $(FILENAME).o -hex -place=txt@0x40000000
	./$(EMULATOR_OUT) $(FILENAME).hex

git: clean
	git add .
	git commit -m "${MSG}"
	git push -u origin master

nivoa:
	./$(ASEMBLER_OUT) -o tests/nivo-a/main.o tests/nivo-a/main.s
	./$(ASEMBLER_OUT) -o tests/nivo-a/math.o tests/nivo-a/math.s
	./$(ASEMBLER_OUT) -o tests/nivo-a/handler.o tests/nivo-a/handler.s
	./$(ASEMBLER_OUT) -o tests/nivo-a/isr_timer.o tests/nivo-a/isr_timer.s
	./$(ASEMBLER_OUT) -o tests/nivo-a/isr_terminal.o tests/nivo-a/isr_terminal.s
	./$(ASEMBLER_OUT) -o tests/nivo-a/isr_software.o tests/nivo-a/isr_software.s
	./$(LINKER_OUT) -hex \
		-place=my_code@0x40000000 -place=math@0xF0000000 \
		-o tests/nivo-a/program.hex \
		tests/nivo-a/handler.o tests/nivo-a/math.o tests/nivo-a/main.o tests/nivo-a/isr_terminal.o tests/nivo-a/isr_timer.o tests/nivo-a/isr_software.o
	./$(EMULATOR_OUT) tests/nivo-a/program.hex

nivob:
	./$(ASEMBLER_OUT) -o tests/nivo-b/main.o tests/nivo-b/main.s
	./$(ASEMBLER_OUT) -o tests/nivo-b/handler.o tests/nivo-b/handler.s
	./$(ASEMBLER_OUT) -o tests/nivo-b/isr_terminal.o tests/nivo-b/isr_terminal.s
	./$(ASEMBLER_OUT) -o tests/nivo-b/isr_timer.o tests/nivo-b/isr_timer.s
	./$(LINKER_OUT) -hex \
      -place=my_code@0x40000000 \
      -o tests/nivo-b/program.hex \
      tests/nivo-b/main.o tests/nivo-b/isr_terminal.o tests/nivo-b/isr_timer.o tests/nivo-b/handler.o
	./$(EMULATOR_OUT) tests/nivo-b/program.hex

nivoc:
	./$(ASEMBLER_OUT) -o tests/nivo-c/main.o tests/nivo-c/main.s
	./$(ASEMBLER_OUT) -o tests/nivo-c/handler.o tests/nivo-c/handler.s
	./$(ASEMBLER_OUT) -o tests/nivo-c/isr_terminal.o tests/nivo-c/isr_terminal.s
	./$(ASEMBLER_OUT) -o tests/nivo-c/isr_timer.o tests/nivo-c/isr_timer.s
	./$(LINKER_OUT) -hex \
	  -place=code@0x40000000 \
	  -o tests/nivo-c/program.hex \
	  tests/nivo-c/main.o tests/nivo-c/isr_terminal.o tests/nivo-c/isr_timer.o tests/nivo-c/handler.o
	./$(EMULATOR_OUT) tests/nivo-c/program.hex

cleana:
	rm -f tests/nivo-a/*.o tests/nivo-a/*.hex

cleanb:
	rm -f tests/nivo-b/*.o tests/nivo-b/*.hex

cleanc:
	rm -f tests/nivo-b/*.o tests/nivo-c/*.hex

zip: clean
	zip -r mm210092.zip inc
	zip -r -u mm210092.zip misc
	zip -r -u mm210092.zip src
	zip -r -u mm210092.zip tests
	zip -u mm210092 Makefile
.PHONY: all clean asembler run lexer parser linker cleanlinker cleanemulator nivoa cleana nivob run git