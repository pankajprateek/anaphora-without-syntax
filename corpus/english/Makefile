.PHONY: all

all english: source.txt target.txt

source.txt target.txt: ncert.06.14.english.corp ncert.07.10.english.corp ncert.08.04.english.corp ncert.09.11.english.corp
	touch source.txt
	../filter ncert.06.14.english.corp | ../filter.sh | ../get0mod3Lines >> source.txt
	../filter ncert.07.10.english.corp | ../filter.sh | ../get0mod3Lines >> source.txt
	../filter ncert.08.04.english.corp | ../filter.sh | ../get0mod3Lines >> source.txt
	../filter ncert.09.11.english.corp | ../filter.sh | ../get0mod3Lines >> source.txt
	touch target.txt
	../filter ncert.06.14.english.corp | ../filter.sh | ../get1mod3Lines >> target.txt
	../filter ncert.07.10.english.corp | ../filter.sh | ../get1mod3Lines >> target.txt
	../filter ncert.08.04.english.corp | ../filter.sh | ../get1mod3Lines >> target.txt
	../filter ncert.09.11.english.corp | ../filter.sh | ../get1mod3Lines >> target.txt

clean:
	rm -f source.txt
	rm -f target.txt
