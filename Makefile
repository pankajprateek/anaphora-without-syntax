all:
	rm *.jeeteshm.*
	make --directory=./corpus
	cp ./corpus/source.txt ./
	cp ./corpus/target.txt ./
	./giza-pp/GIZAppv2/plain2snt.out source.txt target.txt
	./giza-pp/GIZAppv2/snt2cooc.out source.vcb target.vcb source_target.snt > coocurrenceFile.cooc
	./giza-pp/GIZAppv2/GIZA++ -s source.vcb -t target.vcb -c source_target.snt -CoocurrenceFile coocurrenceFile.cooc
	
	
