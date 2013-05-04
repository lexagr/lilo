#!/usr/bin/make -f
# -*- makefile -*-

# adding variables
include ../make.vars

PODFILES  := lilo-uuid-diskid lilo liloconfig
MANFILES5 := lilo.conf
MANFILES8 := keytab-lilo lilo-uuid-diskid lilo liloconfig mkrescue

all:

build:
	for PF in $(PODFILES); do \
	  sh ./pod2manpage $$PF.pod; \
	done

install:
	mkdir -p $$DESTDIR$(MAN_DIR)/man5
	for MF in $(MANFILES5); do \
	  install -m 0644  $$MF.5  $$DESTDIR$(MAN_DIR)/man5; \
	done

	mkdir -p $$DESTDIR$(MAN_DIR)/man8
	for MF in $(MANFILES8); do \
	  install -m 0644  $$MF.8  $$DESTDIR$(MAN_DIR)/man8; \
	done

clean:

distclean:

uninstall:
	for MF in $(MANFILES5); do \
	  rm -vf $$DESTDIR$(MAN_DIR)/man5/$$MF.5 || true; \
	done

	for MF in $(MANFILES8); do \
	  rm -vf $$DESTDIR$(MAN_DIR)/man8/$$MF.8 || true; \
	done

