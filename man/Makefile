# -*- makefile -*-

# adding variables
include ../make.vars

all:

install:
	mkdir -p $$DESTDIR$(MAN_DIR)/man5
	mkdir -p $$DESTDIR$(MAN_DIR)/man8

	install -m 0644  lilo.8  $$DESTDIR$(MAN_DIR)/man8
	install -m 0644  mkrescue.8  $$DESTDIR$(MAN_DIR)/man8
	install -m 0644  lilo.conf.5  $$DESTDIR$(MAN_DIR)/man5
	install -m 0644  keytab-lilo.8  $$DESTDIR$(MAN_DIR)/man8

clean:

distclean:

uninstall:
	rm -f $$DESTDIR$(MAN_DIR)/man8/lilo.8
	rm -f $$DESTDIR$(MAN_DIR)/man8/mkrescue.8
	rm -f $$DESTDIR$(MAN_DIR)/man5/lilo.conf.5
	rm -f $$DESTDIR$(MAN_DIR)/man8/keytab-lilo.8
