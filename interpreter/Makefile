.PHONY: all english hindi
CC = g++
SOURCES = mapper.cpp interpreter.cpp action.cpp grammar.cpp
OBJECTS = $(SOURCES:.cpp=.o)
HEADERS = $(SOURCES:.cpp=.h)
EXECUTABLE = interpret

all: english hindi

english:
	cp ./english/english-source.vcb ./source.vcb
	cp ./english/english-target.vcb ./target.vcb
	cp ./english/alignment.txt ./

hindi:
	cp ./hindi/hindi-source.vcb ./source.vcb
	cp ./hindi/hindi-target.vcb ./target.vcb
	cp ./hindi/alignment.txt ./

interpret: $(OBJECTS) $(HEADERS)
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
