# -*- makefile -*-

# adding variables
include ../make.vars

POSTUP   = initramfs/post-update.d
POSTINST = kernel/postinst.d
POSTRM   = kernel/postrm.d

all:

install:
	mkdir -p $$DESTDIR$(CFG_DIR)/$(POSTUP)
	mkdir -p $$DESTDIR$(CFG_DIR)/$(POSTINST)
	mkdir -p $$DESTDIR$(CFG_DIR)/$(POSTRM)
	install -m 0755  $(POSTUP)/runlilo  $$DESTDIR$(CFG_DIR)/$(POSTUP)
	install -m 0755  $(POSTINST)/zz-runlilo  $$DESTDIR$(CFG_DIR)/$(POSTINST)
	install -m 0755  $(POSTRM)/zz-runlilo  $$DESTDIR$(CFG_DIR)/$(POSTRM)

clean:

distclean:

uninstall:
	rm -f $$DESTDIR$(CFG_DIR)/$(POSTUP)/runlilo
	rm -f $$DESTDIR$(CFG_DIR)/$(POSTINST)/zz-runlilo
	rm -f $$DESTDIR$(CFG_DIR)/$(POSTRM)/zz-runlilo
