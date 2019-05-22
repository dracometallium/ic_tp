TEX:=$(wildcard *.tex)
STYLES:=$(wildcard styles/*)
TP_PDF:=$(TEX:.tex=.pdf)
AUX=$(TEX:.tex=.aux)
LOGOS:=$(wildcard logos/*.svg)
FIGURAS:=$(wildcard img/*.svg)
LOGOS_PDF=$(LOGOS:.svg=.pdf)
FIGURAS_PDF=$(FIGURAS:.svg=.pdf)
PDF=$(FIGURAS_PDF) $(LOGOS_PDF)
GARBAGE=*.aux *.bbl *.blg *.log *.pdf *.toc *.lof $(PDF) *.nav *.out *.snm

all: $(TP_PDF)

$(TP_PDF): %.pdf : %.tex $(STYLES) $(LOGOS_PDF) $(FIGURAS_PDF)
	pdflatex $^
	pdflatex $^

$(FIGURAS_PDF): %.pdf : %.svg
	inkscape $^ -z -A $@

$(LOGOS_PDF): %.pdf : %.svg
	inkscape $^ -z -A $@

clean:
	rm -f $(GARBAGE)
	rm -f $(PDF) $(DATOS)
