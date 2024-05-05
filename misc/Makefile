# Output files
LEXER_OUT = lexer.cpp
PARSER_OUT = parser.cpp

# Input files
LEXER_IN = lexer.l
PARSER_IN = parser.y

# Tools
LEX = flex
YACC = bison

# Flags
LEX_FLAGS = -o $(LEXER_OUT)
YACC_FLAGS = -d -o $(PARSER_OUT)

all: $(LEXER_OUT) $(PARSER_OUT)

$(LEXER_OUT): $(LEXER_IN)
    $(LEX) $(LEX_FLAGS) $(LEXER_IN)

$(PARSER_OUT): $(PARSER_IN)
    $(YACC) $(YACC_FLAGS) $(PARSER_IN)

clean:
    rm -f $(LEXER_OUT) $(PARSER_OUT) parser.hpp