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
all: interpret.out lyparse.out

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
	rm *.o
	./interpret.out < jeetesh_temp_english.txt > temp.txt

interpret1.out: $(OBJECTS1) $(HEADERS1)
	rm *.o
	$(CC) -g -o $@ $^

image: interpret
	rm -f drawing_instructions.txt
	./interpret.out
	python constructImage.py

.cpp.o:
	$(CC) -g -c $< -o $@

lyparser.out: y.tab.c lex.yy.o lylib.o
	$(CC) -g -o $@ y.tab.c lex.yy.o lylib.o -w -std=c++0x

lylib.o: lylib.c
	$(CC) -g -c $< -o $@ -w -std=c++0x

lex.yy.o: tokenize.l
	flex tokenize.l
	$(CC) -g -c lex.yy.c -o lex.yy.o

y.tab.c: lyparse.y lylib.h lyparse.h
	yacc lyparse.y -Wall -k --report=all -g -x -d -t
	#$(CC) -g -c y.tab.c lylib.h -o y.tab.o -w -std=c++0x

listkeywords:
	python listKeywords.py < target.vcb > keywords.txt

clean:
	rm -f drawing_instructions.txt
	#rm -f ./source.vcb ./target.vcb ./alignment.txt
	rm -f interpret.out *.o
