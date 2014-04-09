.PHONY: all english hindi
all: english

english:
	make english --directory=./english
	cp ./english/source.txt ./english-source.txt
	cp ./english/target.txt ./english-target.txt

hindi: 
	make hindi --directory=./hindi
	cp ./hindi/source.txt ./hindi-source.txt
	cp ./hindi/target.txt ./hindi-target.txt

clean:
	make clean --directory=./hindi
	rm -f english-source.txt english-target.txt
	make clean --directory=./english
	rm -f hindi-source.txt hindi-target.txt
