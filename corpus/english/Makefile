.PHONY: all

all english: source.txt target.txt

source.txt target.txt: ncert.06.14.english.corp ncert.07.10.english.corp ncert.08.04.english.corp ncert.09.11.english.corp
	rm -f source.txt
	touch source.txt
	../get0mod3Lines < ncert.06.14.english.corp > temp
	../filter temp | ../filter.sh | perl -ne 'print if /\S/' > temp1
	../get0mod3Lines < ncert.07.10.english.corp > temp
	../filter temp | ../filter.sh | perl -ne 'print if /\S/' > temp2
	../get0mod3Lines < ncert.08.04.english.corp > temp
	../filter temp | ../filter.sh | perl -ne 'print if /\S/' > temp3
	../get0mod3Lines < ncert.09.11.english.corp > temp
	../filter temp | ../filter.sh | perl -ne 'print if /\S/' > temp4
	cat temp1 >> source.txt
	cat temp2 >> source.txt
	cat temp3 >> source.txt
	cat temp4 >> source.txt
	#../filter ncert.06.14.english.corp | ../filter.sh | ../get0mod3Lines >> source.txt
	#../filter ncert.07.10.english.corp | ../filter.sh | ../get0mod3Lines >> source.txt
	#../filter ncert.08.04.english.corp | ../filter.sh | ../get0mod3Lines >> source.txt
	#../filter ncert.09.11.english.corp | ../filter.sh | ../get0mod3Lines >> source.txt
	rm -f target.txt
	touch target.txt
	../get1mod3Lines < ncert.06.14.english.corp > temp
	../filter temp | ../filter.sh | perl -ne 'print if /\S/' > temp1
	../get1mod3Lines < ncert.07.10.english.corp > temp
	../filter temp | ../filter.sh | perl -ne 'print if /\S/' > temp2
	../get1mod3Lines < ncert.08.04.english.corp > temp
	../filter temp | ../filter.sh | perl -ne 'print if /\S/' > temp3
	../get1mod3Lines < ncert.09.11.english.corp > temp
	../filter temp | ../filter.sh | perl -ne 'print if /\S/' > temp4
	cat temp1 >> target.txt
	cat temp2 >> target.txt
	cat temp3 >> target.txt
	cat temp4 >> target.txt
	#../filter ncert.06.14.english.corp | ../filter.sh | ../get1mod3Lines >> target.txt
	#../filter ncert.07.10.english.corp | ../filter.sh | ../get1mod3Lines >> target.txt
	#../filter ncert.08.04.english.corp | ../filter.sh | ../get1mod3Lines >> target.txt
	#../filter ncert.09.11.english.corp | ../filter.sh | ../get1mod3Lines >> target.txt

clean:
	rm -f source.txt
	rm -f target.txt
