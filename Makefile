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
	pdflatex -interaction=nonstopmode -halt-on-error \
		-output-directory "$$(dirname $<)" $<
	pdflatex -interaction=nonstopmode -halt-on-error \
		-output-directory "$$(dirname $<)" $<

$(FIGURAS_PDF): %.pdf : %.svg
	printf "file-open:%s;\
		export-area-page;\
		export-filename:%s;\
		export-overwrite;\
		export-do;" $^ $@\
		| DISPLAY="" SELF_CALL=NO inkscape --shell

$(LOGOS_PDF): %.pdf : %.svg
	printf "file-open:%s;\
		export-area-drawing;\
		export-filename:%s;\
		export-overwrite;\
		export-do;" $^ $@\
		| DISPLAY="" SELF_CALL=NO inkscape --shell

clean: clean-garbage
	rm -f $(PDF) $(TP_PDF)

clean-garbage:
	rm -f $(GARBAGE)
	cd exams && rm -f $(GARBAGE)

pdf-only: all clean-garbage
	rm -f $(PDF)
