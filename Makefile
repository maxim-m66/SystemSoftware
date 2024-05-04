all: run

executable: src/main.cpp
	g++ -o asembler src/main.cpp

run: executable
	./asembler tests/test1.s

.PHONY: all run