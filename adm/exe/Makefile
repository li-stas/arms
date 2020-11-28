ifdef CLIPROOT
include $(CLIPROOT)/include/Makefile.inc
endif
CLIP	= $(CLIPROOT)/bin/clip
CLIPFLAGS = -a -O -l 
CLIPLIBS  =
OBJS  = main.o adm.o\
	madm.o\
	\
	ktoins.o users.o ktoeins.o s_gru.o stag.o\
	\
	prvm.o abindx.o tovd.o tov_d.o podg.o prov.o final.o indall.o corauto.o corrch.o\
	netrs1.o corvt.o sinctov.o kplkgp.o setup.o rmsk.o s_dbft.o s_cgrp.o\
	rmsdrc.o rmrc0.o rmrc1.o rmsd0.o rmsd1.o rmsdrcf.o\
	autodoc.o kplif.o corrnds.o s_soper.o\
	crdocopt.o pere.o sklprov.o sklprv.o maska.o\
	s_cskl.o skclea.o setks.o mcrdbc.o test.o \
	ctov.o tovins.o \
	\
	dobnv.o\
	\
	vpath.o periodn.o libfcn.o libdbf.o slctn2.o libfcne.o\
	\
	maine.o menu.o ent.o mmain.o 

.SUFFIXES: .prg .o

all:    $(OBJS) 
#	$(CLIP) -e -s $(OBJS) $(CLIPLIBS)
	$(CLIP) -e --static $(OBJS)
	cp main app_adm
	rm main

clean:
	rm -rf *.o *.c *.a *.so *.b *.BAK *.bak *~ core* *core *.ex *.nm

install:
	rm -f /usr/local/sbin/app_adm
	cp ./app_adm /usr/local/sbin/app_adm

copy:
	./cp_adm

.prg.o:
	$(CLIP) $(CLIPFLAGS) $<

.prg.po:
	$(CLIP) $(CLIPFLAGS) -p $<

