# -*- makefile -*-

LATEX=latex
PDFLATEX=pdflatex
RLATEX=./rlatex
FIG2DEV=fig2dev
SHELL=/bin/sh

IMAGES=bootloader.tex map.tex image.tex parameter.tex other.tex

.SUFFIXES:	.fig .tex .dvi .ps

.fig.tex:
		$(FIG2DEV) -L latex $*.fig $*.tex

.tex.dvi:
		$(RLATEX) $*

all:		user.dvi tech.dvi user.pdf tech.pdf

user.ps:	user.dvi
		dvips -o user.ps user.dvi

tech.ps:	tech.dvi
		dvips -o tech.ps tech.dvi

user.dvi:	user.tex

tech.dvi:	tech.tex $(IMAGES)

user.pdf:	user.dvi
		$(PDFLATEX) user
		$(PDFLATEX) user

tech.pdf:	tech.dvi
		$(PDFLATEX) tech
		$(PDFLATEX) tech

html:		user.ps tech.ps
		latex2html -split 2 -link 2 -toc_depth 2 user
		latex2html -split 1 -link 1 -toc_depth 1 tech

again:
		$(PDFLATEX) user
		$(PDFLATEX) tech

tidy:
		rm -f *~ *.toc *.aux *.log *.out

clean:		tidy
		rm -f *.ps *.dvi *.pdf
		rm -Rf user tech

distclean:	clean


dummies:
		for n in $(IMAGES); do echo '(omitted)' >$$n; done
