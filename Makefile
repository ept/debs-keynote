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

# The minted package does source code syntax highlighting using Pygments: https://pygments.org/
# Pygments must be installed on your system, e.g. using `pip3.8 install Pygments`.
# To allow the document to be built on systems without Pygments, commit the files in the
# _minted-curve25519/ directory to git. Use option finalizecache=true to update the cached
# syntax-highlighted listings, and use option frozencache=true to use that cache.
# With frozencache=true, the -shell-escape option is no longer needed.
refresh-syntax-highlighting:
	sed -e 's/\\usepackage\[.*\]{minted}/\\usepackage[finalizecache=true]{minted}/' -i '' debs-keynote.tex
	pdflatex -shell-escape -halt-on-error -file-line-error debs-keynote
	sed -e 's/\\usepackage\[.*\]{minted}/\\usepackage[frozencache=true]{minted}/' -i '' debs-keynote.tex

clean:
	rm -f *.{aux,log,bbl,blg,pdf}
