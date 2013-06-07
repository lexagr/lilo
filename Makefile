# -*- makefile -*-
#
# Copyright 2009-2013 Joachim Wiedorn
# All rights reserved.
# 
# Licensed under the terms contained in the file 'COPYING'
# in the source directory.
#

#
#  make help
#
help:
	@echo ""
	@echo "Targets:"
	@echo "  make all         # binaries (without dosexe, diag.)"
	@echo "  make dosexe      # DOS lilo.com utility"
	@echo "  make diagnostic  # standalone diagnostics"
	@echo "  make alles       # all above + static binary"
	@echo "  make docs        # doc/[user,tech].html docs"
	@echo "  make floppy      # 2 standalone bootable diagnostic floppies"
	@echo ""
	@echo "  make install     # install binaries++ into root directory"
	@echo "  make install DESTDIR=<dir>  # install binaries++ into directory"
	@echo ""
	@echo "  make uninstall     # remove binaries++ from root directory"
	@echo "  make uninstall DESTDIR=<dir>  # rmove binaries++ from directory"
	@echo ""
	@echo "Maintenance:"
	@echo "  make test        # test for all needed utilities (as86, ld86, etc.)"
	@echo "  make tidy        # remove listings & other unnecessary files"
	@echo "  make clean       # remove objects & ready for a fresh 'make all'"
	@echo "  make distclean   # remove editor temps, & all of the above"
	@echo ""

#
# everything needed to run, just short of installation
#
all: test
	$(MAKE) -C src all
	$(MAKE) -C images all

#
# everything above plus the statically linked version
#
alles: test
	$(MAKE) -C src alles
	$(MAKE) -C images all

#
# documentation files
#
docs:

#
# if you have the 'bcc' compiler, then you can make the diagnostics, too
# bcc = Bruce Evans’ C 16bit compiler (also for BIOS- and DOS code)
#
it:	docs alles diagnostic dosexe

#
# make the bootable diagnostic floppies
#
floppy: test
	@echo
	@echo Make sure you have 2 blank, formatted, 1.44Mb floppies
	@echo before you proceed from this point.
	@echo "Press <Enter> to continue, <^C> to abort ..."
	@read
	@$(MAKE) -C src floppy1
	@echo Done.
	@echo
	@echo Remove the floppy from the drive.  Label it "\"1.6\""
	@echo "Press <Enter> to continue, <^C> to abort ..."
	@read
	@$(MAKE) -C src floppy2
	@echo Done.
	@echo
	@echo Remove the floppy from the drive.  Label it "\"2.4\""
	@echo

diagnostic: test
	$(MAKE) -C src diagnostic

dosexe: test
	$(MAKE) -C dos lilo

#
# test for compilers & utilities
#
test: test.img
test.img:
	./checkit
	echo Tested >test.img	

#
# shorthand install, if one knows that one has the 'bcc' compiler
#
ins:
	$(MAKE) -C src ins

#
#  normal install, but doesn't make the diagnostic binaries
#
install:  all
	$(MAKE) -C src install
	$(MAKE) -C images install
	$(MAKE) -C hooks install
	$(MAKE) -C sample install
	$(MAKE) -C scripts install
	$(MAKE) -C man install
	$(MAKE) -C dos install

tidy:
	$(MAKE) -C src tidy
	$(MAKE) -C diagnose tidy
	$(MAKE) -C dos tidy

clean: tidy
	rm -f test.img
	$(MAKE) -C src clean
	$(MAKE) -C images clean
	$(MAKE) -C diagnose clean
	$(MAKE) -C dos clean

spotless: distclean
distclean: clean
	$(MAKE) -C src distclean
	$(MAKE) -C diagnose distclean
	$(MAKE) -C dos distclean

uninstall:
	$(MAKE) -C src uninstall
	$(MAKE) -C images uninstall
	$(MAKE) -C hooks uninstall
	$(MAKE) -C sample uninstall
	$(MAKE) -C scripts uninstall
	$(MAKE) -C man uninstall
