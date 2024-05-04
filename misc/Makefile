all: flex executable run

flex: lexer.l
	flex lexer.l

executable: flex
	gcc lex.yy.c -o a.out

run: executable
	./a.out

.PHONY: all run flex