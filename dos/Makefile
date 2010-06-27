# -*- makefile -*-
# Makefile for BCC compilation of 'lilo.com'
#
# Known to work with BCC version 0.16.15
# Known not to work with BCC version 0.16.10

# adding variables
include ../make.vars

MODEL=d
CC = bcc -M$(MODEL)
CPP = gcc -E
CINCL = /usr/lib/bcc/include
AS = as86
LINK = $(CC) -v
COPT = -ansi -I.. -I$(CINCL) -c -O $(CFLAGS)
LOPT = -m >$*.map -M -d
AOPT = -0 -a -w
CFLAGS = -DLCF_IGNORECASE -DLCF_DSECS=3 -DLCF_PASS160

.SUFFIXES:	.com .S

HFILES = ../src/lilo.h ../src/bitmap.h ../src/cfg.h ../src/config.h ../src/common.h ../src/map.h ../src/temp.h ../src/version.h

.c.o:
	$(CC) $(COPT) -o $@ ../$*.c

.o.com:
	$(LINK) $(LOPT) -o $@ $^

.s.o:
	$(AS) $(AOPT) -l $*.lis -o $@ $<




all:	check lilo.com

alles:	all
	cp -ufv lilo.com lilo.map /dosC/boot

check:
	@echo $(CFLAGS)
	@if [ -x /usr/bin/bcc -o -x /usr/local/bin/bcc ]; then echo Okay; \
	else echo; echo "You don't seem to have the 'bcc' compiler from the 'dev86' package."; \
		echo; exit 1; fi

lilo:
	make -e CFLAGS="$(PCONFIG)" lilo.com

lilo.com:	lilo.o common.o cfg.o map.o   # cprintf.o

lilo.o:		../src/lilo.c $(HFILES)
	$(CC) $(COPT) -o $@  ../src/$*.c

cfg.o:		../src/cfg.c $(HFILES)
	$(CC) $(COPT) -o $@  ../src/$*.c

common.o:	../src/common.c $(HFILES)
	$(CC) $(COPT) -o $@  ../src/$*.c

cprintf.o:	../src/cprintf.c $(HFILES)
	$(CC) $(COPT) -o $@  ../src/$*.c

map.o:		../src/map.c $(HFILES)
	$(CC) $(COPT) -o $@  ../src/$*.c


install:
	if [ -d $$DESTDIR$(DOS_DIR) -a -f lilo.com ]; then \
	  cp lilo.com $$DESTDIR$(DOS_DIR); fi

tidy:
	rm -f *.map *.lis core

clean:	tidy
	rm -f *.o *.s *.img *.b *.com *.gz

distclean:  clean
	rm -f *~ *.c *.h

