# -*- makefile -*-

# adding variables
include ../make.vars

all:

install:
	mkdir -p $$DESTDIR$(CFG_DIR)
	install -m 0644 lilo.example.conf $$DESTDIR$(CFG_DIR)/lilo.conf_example

clean:

distclean:

uninstall:
	rm -f $$DESTDIR$(CFG_DIR)/lilo.conf_example
