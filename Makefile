.PHONY: all watch clean

SOURCES=$(wildcard *.tex)
BASES=$(basename $(SOURCES))
PSS=$(addsuffix .ps,$(BASES))
PDFS=$(addsuffix .pdf,$(BASES))
DVIS=$(addsuffix .dvi,$(BASES))

RESULTS=$(PSS) $(PDFS) $(DVIS)
JUNK=$(RESULTS) $(wildcard *.log) $(wildcard *.aux)
AUXIL=$(wildcard *.sty) $(wildcard *.cls)

all: $(SOURCES)
	latexmk --pdf $^
#	rubber --pdf $^

watch: all
	@while inotifywait -e modify $(SOURCES) $(AUXIL); do make all; done

%.dvi: %.tex $(AUXIL)
	rubber --dvi $<

%.ps: %.tex $(AUXIL)
	rubber --ps $<

%.pdf: %.tex $(AUXIL)
	rubber --pdf $<

clean:
	rm -f $(JUNK)
