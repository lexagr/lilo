# -*- makefile -*-
#
# Copyright 2009-2013 Joachim Wiedorn
# All rights reserved.
# 
# Licensed under the terms contained in the file 'COPYING'
# in the source directory.
#

# adding variables
include ../make.vars

#
#  Do not modify anything below this point
#

SHELL=/bin/sh
CC=gcc
CPP=$(CC) -E -P -ffreestanding
AS86=as86 -0 -a
LD86=ld86 -0
NASM=nasm
G=`cat foo1 foo2 | grep version | cut -d " " -f 3`

CFLAGS=$(OPT) -Wall $(PCONFIG)
LDFLAGS=#-Xlinker -qmagic
LIBS=$(DEVMAPPER)

OBJS=lilo.o raid.o map.o geometry.o boot.o device.o common.o bsect.o cfg.o \
  partition.o identify.o probe.o shs2.o edit.o temp.o

EDIT=edit.c common.o

LIS=chain.lis disk.lis dparam.lis first.lis second.lis \
  bootsect.lis third.lis mbr.lis bitmap.lis pseudo.lis mbr2.lis \
  pseudo1.lis loader.lis pseudo3.lis
BFILES=first.b second.b third.b bitmap.b chain.b mbr.b mbr2.b \
  bootsect.b pseudo1.b pseudo2.b pseudo3.b
CFILES=boot.c bsect.c cfg.c common.c device.c edit.c geometry.c \
  identify.c lilo.c map.c partition.c probe.c raid.c shs2.c temp.c
HFILES=bdata.h bitmap.h boot.h bsect.h cfg.h common.h config.h device.h \
  edit.h geometry.h identify.h lilo.h loader.h map.h md-int.h partition.h \
  probe.h raid.h shs2.h temp.h version.h vesainfo.h

.SUFFIXES:	.img .b .com .S .s


#
# everything needed to run, just short of installation
#
all:	lilo bootsect.b

#
# everything above plus the statically linked version
#
alles: all diag1.img lilo.static

#
# make the bootable diagnostic floppies
#
floppy1: disk.com bootsect.b
	@echo
	@echo Creating Diagnostic Floppy 1.6
	@echo
	@echo Insert a blank, formatted, floppy into drive 0
	@echo "Press <Enter> to continue, <^C> to abort ..."
	@read
	cat bootsect.b disk.com | dd of=/dev/fd0 bs=512

floppy2: disk.b
	@echo
	@echo Creating Diagnostic Floppy 2.4
	@$(MAKE) -C ../diagnose check
	@$(MAKE) -C ../diagnose floppy

diagnostic: ../test.img diag1.img diag2.img diag3.img

manpath:
	echo $(MAN_DIR)

.c.o:
		$(CC) -c $(CFLAGS) $*.c

.s.o:
		$(AS86) -w -l $*.lis -o $*.o $*.s

.o.img:
		$(LD86) -s -o $*.img $*.o

.img.b:
		dd if=$*.img of=$*.b bs=32 skip=1

edit:		$(EDIT)
		$(CC) $(CFLAGS) -DSTANDALONE -o edit $(EDIT) $(LDFLAGS)

loader.i:	mkloader first.b second.b third.b bitmap.b mbr.b chain.b mbr2.b
		./mkloader >loader.i

disk.com:	disk.b
		cp disk.b disk.com

disk.s:		disk.S read.S bdata.h biosdata.S lilo.h Makefile
		$(CPP) -traditional $(PCONFIG) -o disk.s  disk.S

mbr.s:		mbr.S lilo.h Makefile
		$(CPP) -traditional $(PCONFIG) -DMBR=0xafbbe760 \
			-o mbr.s  mbr.S

mbr.b:		mbr.img
		dd if=$*.img of=$*.b bs=32 skip=49

mbr2.s:		mbr.S lilo.h Makefile
		$(CPP) -traditional $(PCONFIG) -DMBX=0x93c00848 \
			-o mbr2.s  mbr.S

mbr2.b: mbr2.img
	dd if=$*.img of=$*.b bs=32 skip=49

bootsect.s: bootsect.S disk.b
	$(CPP) -traditional $(PCONFIG) \
		-DSIZEDISKB=`wc -c <disk.b | sed "s/ //g"` \
		-o bootsect.s  bootsect.S

pseudo1.s: bootsect.S pseudo.S disk.com
	cat bootsect.S pseudo.S >$(TMP).S
	$(CPP) -traditional $(PCONFIG) \
		-DSIZEKRNL=`wc -c <disk.com | sed "s/ //g"` \
		-DSIZEDISKB=512 -o pseudo1.s $(TMP).S
	rm -f $(TMP).S

pseudo2.s: bootsect.S pseudo.S
	$(MAKE) -C ../diagnose all
	cat bootsect.S pseudo.S >$(TMP).S
	$(CPP) -traditional $(PCONFIG) \
		-DSIZEKRNL=`wc -c <../diagnose/test4.com | sed "s/ //g"` \
		-DSIZEDISKB=512 -o pseudo2.s $(TMP).S
	rm -f $(TMP).S

pseudo3.s: bootsect.S pseudo.S
	$(MAKE) -C ../diagnose all
	cat bootsect.S pseudo.S >$(TMP).S
	$(CPP) -traditional $(PCONFIG) \
		-DSIZEKRNL=`wc -c <../diagnose/test5.com | sed "s/ //g"` \
		-DSIZEDISKB=512 -o pseudo3.s $(TMP).S
	rm -f $(TMP).S

pseudo1.b:	pseudo1.s
pseudo2.b:	pseudo2.s
pseudo3.b:	pseudo3.s


diag1.img:	disk.com pseudo1.b
	cat pseudo1.b disk.com >diag1.img

diag2.img: pseudo2.b
	$(MAKE) -C ../diagnose all
	cat pseudo2.b ../diagnose/test4.com >diag2.img

diag3.img: pseudo3.b
	$(MAKE) -C ../diagnose all
	cat pseudo3.b ../diagnose/test5.com >diag3.img

flags.i:	../test.img Makefile version $(CFILES) $(HFILES)
	echo "#define CFLAGS \"" $(CFLAGS) "\"" >flags.i
	tail -$$((`wc -l <Makefile`-`sed /\#\#\#/q <Makefile | wc -l`)) \
	  <Makefile | grep -v "0x" >$(TMP)
	for i in $(CFILES) $(HFILES) ; do cat $$i >>$(TMP) ; done
	echo "#define CSOURCE " `./version $(TMP)` >>flags.i
	rm -f $(TMP)


dparam.com:	dparam.img
		dd if=dparam.img of=dparam.com bs=288 skip=1

dparam.s:	dparam.S
		cp -p dparam.S dparam.s

lilo:		$(OBJS)
		$(CC) -o lilo $(LDFLAGS) $(OBJS) $(LIBS)

lilo.static:	$(OBJS)
		$(CC) -o lilo.static -static $(LDFLAGS) $(OBJS) $(LIBS)

common.s:	common.h
		$(CPP) -C -traditional -DLILO_ASM -o common.s common.h

bitmap.o: bitmap.s common.s
third.o: third.s common.s
second.o: second.s common.s
first.o: first.s common.s
chain.o: chain.s common.s

first.s:	first.S lilo.h version.h Makefile
		$(CPP) $(PCONFIG) -DFIRST=0x62177489 -o first.s first.S

second.s:	second.S read.S volume.S mapper.S biosdata.S shs3.S bdata.h lilo.h version.h \
			graph.S menu.S strlen.S bitmap.S crt.S display4.S Makefile
		$(CPP) $(PCONFIG) -DTEXT=0x9dd476ec second.S -o second.s

third.s:	second.S read.S volume.S mapper.S biosdata.S shs3.S bdata.h lilo.h version.h \
			graph.S menu.S strlen.S bitmap.S crt.S display4.S Makefile
		$(CPP) $(PCONFIG) -DMENU=0x2012a4a7 second.S -o third.s

bitmap.s:	second.S read.S volume.S mapper.S biosdata.S shs3.S bdata.h lilo.h version.h \
			graph.S menu.S strlen.S bitmap.S crt.S display4.S Makefile
		$(CPP) $(PCONFIG) -DBITMAP=0x2ece2fbe second.S -o bitmap.s

chain.s:	chain.S lilo.h version.h first.b Makefile
		$(CPP) $(PCONFIG) -DCHAIN=0x536a7646 chain.S -o chain.s

xxx.s:		chain.S lilo.h Makefile
		$(CPP) chain.S -DXXX -o xxx.s

$(OBJS):	Makefile

#
# shorthand install, if one knows that one has the 'bcc' compiler
#
ins:	diag install

#
#  normal install, but doesn't make the diagnostic binaries
#
install:
	mkdir -p $$DESTDIR$(SBIN_DIR) $$DESTDIR$(CFG_DIR) 
	mkdir -p $$DESTDIR$(BOOT_DIR) $$DESTDIR$(USRSBIN_DIR)

	@if [ -e $$DESTDIR$(BOOT_DIR)/boot.b -o -e $$DESTDIR$(BOOT_DIR)/boot.old ]; then \
	  rm -f $$DESTDIR$(BOOT_DIR)/boot.b; rm -f $$DESTDIR$(BOOT_DIR)/boot.old; fi
	@if [ -f $$DESTDIR$(BOOT_DIR)/boot-bmp.b -o -f $$DESTDIR$(BOOT_DIR)/boot-bmp.old ]; then \
	  rm -f $$DESTDIR$(BOOT_DIR)/boot-bmp.b; rm -f $$DESTDIR$(BOOT_DIR)/boot-bmp.old; fi
	@if [ -f $$DESTDIR$(BOOT_DIR)/boot-menu.b -o -f $$DESTDIR$(BOOT_DIR)/boot-menu.old ]; then \
	  rm -f $$DESTDIR$(BOOT_DIR)/boot-menu.b; rm -f $$DESTDIR$(BOOT_DIR)/boot-menu.old; fi
	@if [ -f $$DESTDIR$(BOOT_DIR)/boot-text.b -o -f $$DESTDIR$(BOOT_DIR)/boot-text.old ]; then \
	  rm -f $$DESTDIR$(BOOT_DIR)/boot-text.b; rm -f $$DESTDIR$(BOOT_DIR)/boot-text.old; fi
	@if [ -f $$DESTDIR$(BOOT_DIR)/chain.b ]; then \
	  mv $$DESTDIR$(BOOT_DIR)/chain.b $$DESTDIR$(BOOT_DIR)/chain.old; fi
	@if [ -f $$DESTDIR$(BOOT_DIR)/mbr.b ]; then \
	  mv $$DESTDIR$(BOOT_DIR)/mbr.b $$DESTDIR$(BOOT_DIR)/mbr.old; fi

	if [ -f chain.b -a  $(BUILTIN) -eq 0 ]; then cp chain.b $$DESTDIR$(BOOT_DIR); fi
	if [ -f mbr.b   -a  $(BUILTIN) -eq 0 ]; then cp mbr.b   $$DESTDIR$(BOOT_DIR); fi
	if [ -f diag1.img ]; then cp -f diag1.img $$DESTDIR$(BOOT_DIR); fi
	if [ -f diag2.img ]; then cp -f diag2.img $$DESTDIR$(BOOT_DIR); fi

	strip lilo
	cp lilo $$DESTDIR$(SBIN_DIR)/lilo
	[ -x lilo.static ] && strip lilo.static
	cp ../mkrescue $$DESTDIR$(USRSBIN_DIR)/mkrescue
	cp ../keytab-lilo.pl $$DESTDIR$(USRSBIN_DIR)/keytab-lilo

dep:
	sed '/\#\#\# Dependencies/q' <Makefile >tmp_make
	$(CPP) $(CFLAGS) -MM *.c >>tmp_make
	mv tmp_make Makefile

version:	common.c lilo.h common.h
	$(CC) $(CFLAGS) -DSHS_MAIN -o version common.c

mkloader:	temp.c
	$(CC) $(CFLAGS) -DLILO_BINARY -o mkloader temp.c


tidy:
	rm -f core $(LIS) *.shs *.crc $(TMP)*
	rm -rf sbin boot usr

clean:
	rm -f *.o *.s *.i *.img *.b tmp_make version
	rm -f lilo lilo.static edit mkloader

distclean:
	rm -f *~ */*~ *.b *.com lilo*tar.gz

uninstall:
	rm -f $$DESTDIR$(SBIN_DIR)/lilo
	rm -f $$DESTDIR$(USRSBIN_DIR)/mkrescue
	rm -f $$DESTDIR$(USRSBIN_DIR)/keytab-lilo
	rm -f $$DESTDIR$(BOOT_DIR)/diag1.img
	rm -f $$DESTDIR$(BOOT_DIR)/diag2.img

	if [ -f $$DESTDIR$(BOOT_DIR)/chain.b ]; then \
	  rm -f $$DESTDIR$(BOOT_DIR)/chain.b; fi
	if [ -f $$DESTDIR$(BOOT_DIR)/mbr.b ]; then \
	  rm -f $$DESTDIR$(BOOT_DIR)/mbr.b; fi


### Dependencies
boot.o: boot.c config.h lilo.h version.h common.h geometry.h device.h \
  cfg.h map.h partition.h boot.h loader.h
bsect.o: bsect.c config.h lilo.h version.h common.h raid.h cfg.h device.h \
  geometry.h map.h temp.h partition.h boot.h bsect.h bitmap.h probe.h \
  loader.h edit.h shs2.h
cfg.o: cfg.c lilo.h version.h common.h temp.h cfg.h
common.o: common.c lilo.h version.h common.h
device.o: device.c config.h lilo.h version.h common.h temp.h device.h \
  geometry.h partition.h cfg.h probe.h md-int.h
edit.o: edit.c config.h lilo.h version.h common.h cfg.h temp.h bsect.h \
  bitmap.h edit.h
geometry.o: geometry.c config.h lilo.h version.h common.h device.h raid.h \
  geometry.h cfg.h md-int.h probe.h
identify.o: identify.c lilo.h version.h common.h cfg.h
lilo.o: lilo.c config.h lilo.h version.h common.h cfg.h raid.h boot.h \
  device.h flags.i geometry.h map.h bsect.h identify.h partition.h \
  probe.h temp.h loader.h md-int.h edit.h bitmap.h
map.o: map.c lilo.h version.h common.h geometry.h map.h
partition.o: partition.c config.h lilo.h version.h common.h cfg.h \
  device.h geometry.h partition.h boot.h loader.h
probe.o: probe.c lilo.h version.h common.h device.h geometry.h \
  partition.h bsect.h bdata.h probe.h
raid.o: raid.c config.h lilo.h version.h common.h raid.h boot.h device.h \
  geometry.h bsect.h cfg.h partition.h md-int.h
shs2.o: shs2.c lilo.h version.h shs2.h
temp.o: temp.c lilo.h version.h common.h temp.h loader.i
