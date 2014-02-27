all hindi: source.txt target.txt
	
source.txt target.txt: ncert.06.14.hindi.corp ncert.07.10.hindi.corp ncert.08.04.hindi.corp ncert.09.11.hindi.corp
	touch source.txt
	../filter ncert.06.14.hindi.corp | ../filter.sh | ../get0mod3Lines >> source.txt
	../filter ncert.07.10.hindi.corp | ../filter.sh | ../get0mod3Lines >> source.txt
	../filter ncert.08.04.hindi.corp | ../filter.sh | ../get0mod3Lines >> source.txt
	../filter ncert.09.11.hindi.corp | ../filter.sh | ../get0mod3Lines >> source.txt
	touch target.txt
	../filter ncert.06.14.hindi.corp | ../filter.sh | ../get1mod3Lines >> target.txt
	../filter ncert.07.10.hindi.corp | ../filter.sh | ../get1mod3Lines >> target.txt
	../filter ncert.08.04.hindi.corp | ../filter.sh | ../get1mod3Lines >> target.txt
	../filter ncert.09.11.hindi.corp | ../filter.sh | ../get1mod3Lines >> target.txt

clean:
	rm -f source.txt
	rm -f target.txt
