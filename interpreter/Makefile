.PHONY: all english hindi
CC = g++
SOURCES = mapper.cpp interpreter.cpp action.cpp grammar.cpp filter.cpp parse.cpp lib.cpp
OBJECTS = $(SOURCES:.cpp=.o)
HEADERS = $(SOURCES:.cpp=.h)
SOURCES1 = mapper.cpp interpreter1.cpp filter.cpp lib.cpp
OBJECTS1 = $(SOURCES1:.cpp=.o)
HEADERS1 = $(SOURCES1:.cpp=.h)
EXECUTABLE = interpret

#~ all: english hindi
all: interpret

english:
	cp ./english/english-source.vcb ./source.vcb
	cp ./english/english-target.vcb ./target.vcb
	cp ./english/alignment.txt ./

hindi:
	cp ./hindi/hindi-source.vcb ./source.vcb
	cp ./hindi/hindi-target.vcb ./target.vcb
	cp ./hindi/alignment.txt ./

interpret: main.cpp $(OBJECTS) $(HEADERS)
	$(CC) -g -o $@ $^

interpret1: $(OBJECTS1) $(HEADERS1)
	$(CC) -g -o $@ $^

image: interpret
	rm -f drawing_instructions.txt
	./interpret
	python constructImage.py

.cpp.o:
	$(CC) -g -c $< -o $@

clean:
	rm -f drawing_instructions.txt
	#rm -f ./source.vcb ./target.vcb ./alignment.txt
	rm -f interpret *.o
