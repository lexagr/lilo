# -*- makefile -*-

#
#  make help
#
help:
	@echo ""
	@echo "Targets:"
	@echo "  make all         # binaries"
	@echo "  make dosexe      # DOS lilo.com utility"
	@echo "  make diagnostic  # standalone diagnostics"
	@echo "  make alles       # all above + static binary"
	@echo "  make docs        # doc/[user,tech].[ps,dvi] docs"
	@echo "  make floppy      # 2 standalone bootable diagnostic floppies"
	@echo ""
	@echo "  make install     # install binaries"
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
all:
	make -C src all

#
# everything above plus the statically linked version
#
alles: 
	make -C src alles

#
# documentation files
#
docs:
	make -C doc all

#
# if you have the 'bcc' compiler, then you can make the diagnostics, too
# bcc = Bruce Evans’ C 16bit compiler (also for BIOS- and DOS code)
#
it:	docs alles diagnostic dosexe

#
# make the bootable diagnostic floppies
#
floppy:
	make -C src floppy

diagnostic:	
	make -C src diagnostic
	
dosexe:
	make -C src dosexe
	

#
# shorthand install, if one knows that one has the 'bcc' compiler
#
ins:
	make -C src ins

#
#  normal install, but doesn't make the diagnostic binaries
#
install:  all
	make -C src install
	make -C man install
	make -C dos install
	make -C src insobs

tidy:
	make -C src tidy
	make -C diagnose tidy
	make -C dos tidy
	make -C doc tidy

clean: tidy
	make -C src clean
	make -C diagnose clean
	make -C dos clean

spotless: distclean
distclean: clean
	make -C src distclean
	make -C diagnose distclean
	make -C dos distclean
	make -C doc clean

