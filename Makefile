# requires GNU make
SHELL=/bin/bash

%.pdf:	%.tex %.bbl
	pdflatex -halt-on-error -file-line-error $<
	while grep 'Rerun to get ' $*.log ; do pdflatex -halt-on-error $< ; done

%.aux:	%.tex
	pdflatex -halt-on-error -file-line-error $<

%.bbl:	references.bib %.aux
	bibtex $*

all:	debs-keynote.pdf

clean:
	rm -f *.{aux,log,bbl,blg,pdf}
