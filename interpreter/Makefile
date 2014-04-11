.PHONY: all english hindi
CC = g++
SOURCES = mapper.cpp interpreter.cpp action.cpp grammar.cpp filter.cpp parse.cpp lib.cpp
OBJECTS = $(SOURCES:.cpp=.o)
HEADERS = $(SOURCES:.cpp=.h)
SOURCES1 = mapper.cpp interpreter1.cpp filter.cpp lib.cpp
OBJECTS1 = $(SOURCES1:.cpp=.o)
HEADERS1 = $(SOURCES1:.cpp=.h)
EXECUTABLE = interpret.out

#~ all: english hindi
all: interpret.out lyparser.out

english:
	cp ./english/english-source.vcb ./source.vcb
	cp ./english/english-target.vcb ./target.vcb
	cp ./english/alignment.txt ./

hindi:
	cp ./hindi/hindi-source.vcb ./source.vcb
	cp ./hindi/hindi-target.vcb ./target.vcb
	cp ./hindi/alignment.txt ./

interpret.out: main.cpp $(OBJECTS) $(HEADERS)
	$(CC) -g -o $@ $^
	#./interpret.out < jeetesh_temp_english.txt > temp.txt

interpret1.out: $(OBJECTS1) $(HEADERS1)
	rm *.o
	$(CC) -g -o $@ $^

image: interpret
	rm -f drawing_instructions.txt
	./interpret.out
	python constructImage.py

.cpp.o:
	$(CC) -g -c $< -o $@

lyparser.out: tokenize.l lyparse.y
	flex tokenize.l
	yacc lyparse.y -Wall -k  --report=all -g -x -d -t
	$(CC) lex.yy.c y.tab.c -o lexer -pg -w -std=c++0x

listkeywords:
	python listKeywords.py < target.vcb > keywords.txt

clean:
	rm -f drawing_instructions.txt
	#rm -f ./source.vcb ./target.vcb ./alignment.txt
	rm -f interpret.out *.o
	rm lex.yy.c y.tab.c lyparser.out
