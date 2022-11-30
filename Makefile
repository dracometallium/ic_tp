OUTDIR=output
TEX:=$(wildcard *.tex exams/*.tex)
TEX_INC:=$(wildcard tex/*.tex)
STYLES:=$(wildcard styles/*)
TP_PDF:=$(TEX:.tex=.pdf)
AUX=$(TEX:.tex=.aux)
LOGOS:=$(wildcard logos/*.svg)
FIGURAS:=$(wildcard img/*.svg)
LOGOS_PDF=$(LOGOS:.svg=.pdf)
FIGURAS_PDF=$(FIGURAS:.svg=.pdf)
PDF=$(FIGURAS_PDF) $(LOGOS_PDF)
GARBAGE=*.aux *.bbl *.blg *.log *.toc *.lof *.nav *.out *.snm

all: $(TP_PDF)

$(TP_PDF): %.pdf : %.tex $(STYLES) $(LOGOS_PDF) $(FIGURAS_PDF) $(TEX_INC)
	mkdir -p $(OUTDIR)
	pdflatex -interaction=nonstopmode -halt-on-error \
		-output-directory $(OUTDIR) $^
	pdflatex -interaction=nonstopmode -halt-on-error \
		-output-directory $(OUTDIR) $^

$(FIGURAS_PDF): %.pdf : %.svg
	inkscape $^ --batch-process --export-area-drawing  -o $@

$(LOGOS_PDF): %.pdf : %.svg
	inkscape $^ --batch-process --export-area-drawing -o $@

clean:
	cd $(OUTDIR) && \
		rm -f $(GARBAGE) *.pdf
	rm -f $(PDF)

clean-garbage:
	cd $(OUTDIR) && \
		rm -f $(GARBAGE)

pdf-only: all clean-garbage
	rm -f $(PDF)
