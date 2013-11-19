doc:
	devnag report.dn
	#latex report.tex
	#dvips report.dvi
	#ps2pdf report.pdf
	pdflatex report.tex
	bibtex report.aux
	pdflatex report.tex
	pdflatex report.tex

pstr:
	latex pstr.tex
	dvips pstr.dvi
	ps2pdf pstr.ps
clean:
	rm -rf *.aux
	rm -rf *.log
	rm -rf *.jeeteshm.*
	rm -rf *.pankaj.*
