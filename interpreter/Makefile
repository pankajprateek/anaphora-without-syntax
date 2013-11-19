.PHONY: all english hindi
CC = g++
SOURCES = mapper.cpp interpreter.cpp action.cpp
OBJECTS = $(SOURCES:.cpp=.o)
HEADERS = $(SOURCES:.cpp=.h)
EXECUTABLE = interpret

all: english

english:
	cp ./english/english-source.vcb ./source.vcb
	cp ./english/english-target.vcb ./target.vcb
	cp ./english/alignment.txt ./

hindi:
	cp ./hindi/hindi-source.vcb ./source.vcb
	cp ./hindi/hindi-target.vcb ./target.vcb
	cp ./hindi/alignment.txt ./

interpret: $(OBJECTS) $(HEADERS)
	$(CC) -o $@ $^

.cpp.o:
	$(CC) -c $< -o $@

clean:
	rm -f ./source.vcb ./target.vcb ./alignment.txt
	rm -f interpret *.o
