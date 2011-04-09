# -*- makefile -*-

# adding variables
include ../make.vars

all:

install:
	mkdir -p $$DESTDIR$(USRSBIN_DIR)

	install -m 0755  liloconfig  $$DESTDIR$(USRSBIN_DIR)
	install -m 0755  lilo-uuid-diskid  $$DESTDIR$(USRSBIN_DIR)

clean:

distclean:

uninstall:
	rm -f $$DESTDIR$(USRSBIN_DIR)/liloconfig
	rm -f $$DESTDIR$(USRSBIN_DIR)/lilo-uuid-diskid

