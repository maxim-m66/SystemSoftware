# Output files
LEXER_OUT = misc/lexer.cpp
LEXER_HEADER = misc/lexer.hpp
PARSER_OUT = misc/parser.cpp
ASEMBLER_OUT = asembler

# Input files
LEXER_IN = misc/lexer.l
PARSER_IN = misc/parser.y
ASEMBLER_IN = src/asembler.cpp

# Tools
LEX = flex
PARSE = bison
COMPILE = g++

# Flags
LEX_FLAGS = --header-file=$(LEXER_HEADER) -o $(LEXER_OUT)
PARSE_FLAGS = -d -o $(PARSER_OUT)
ASEMBLER_FLAGS = -o $(ASEMBLER_OUT)

# Input variables
MSG ?= "Update"

all: asembler run

asembler: $(ASEMBLER_IN) lexer parser
	g++ -o asembler src/asembler.cpp misc/lexer.cpp misc/parser.cpp

run: asembler
	./asembler tests/test1.s

lexer: $(LEXER_IN)
	$(LEX) $(LEX_FLAGS) $(LEXER_IN)

parser: $(PARSER_IN)
	$(PARSE) $(PARSE_FLAGS) $(PARSER_IN)

clean:
	rm -f asembler tests/*.o misc/parser.cpp misc/lexer.cpp misc/parser.hpp misc/lexer.hpp

git:
	git add .
	git commit -m "${MSG}"
	git push -u origin master
.PHONY: all clean asembler run lexer parser