# -*- makefile -*-

# adding variables
include ../make.vars

BINLILO := ../src/lilo
BMPS8 := coffee.bmp
BMPS4 := debian.bmp debian-de.bmp debianlilo.bmp inside.bmp onlyblue.bmp tuxlogo.bmp


all: $(BMPS4) $(BMPS8)

$(BMPS4): %.bmp: %_16c.uu
	uudecode $<
	@echo Y | $(BINLILO) -E $(addsuffix .dat,$(basename $<)) 1>/dev/null

$(BMPS8): %.bmp: %_256c.uu
	uudecode $<
	@echo Y | $(BINLILO) -E $(addsuffix .dat,$(basename $<)) 1>/dev/null

install: all
	mkdir -p $$DESTDIR$(BOOT_DIR)
	install -m 0644  $(BMPS4) $(BMPS8)  $$DESTDIR$(BOOT_DIR)

clean:
	rm -f $(BMPS4) $(BMPS8)

distclean: clean

uninstall:
	(cd $$DESTDIR$(BOOT_DIR); rm -f $(BMPS4) $(BMPS8))

