ifdef CLIPROOT
include $(CLIPROOT)/include/Makefile.inc
endif
CLIP	= $(CLIPROOT)/bin/clip
CLIPFLAGS = -a -O -l 
CLIPLIBS  =
OBJS  = main.o fin.o\
	mfin.o bl_s.o dk_bs.o order.o rost.o odkp.o os_ob.o\
	dokkkta.o crdkkln.o crbsdokk.o glav.o \
	maska.o reestr.o s_bs.o xmlnds.o\
	s_dclr.o s_dkkln.o s_operb.o s_podr.o s_soper.o s_tipd.o s_izder.o\
	s_zatr.o s_tara.o oborkl.o s_kln.o klnins.o s_sgrp.o s_lic.o lic.o nds.o\
	s_lice.o s_vo.o s_vop.o s_tcen.o s_banks.o s_otd.o regord.o ndsdoc.o\
	klnusl.o cond.o crdokz.o pbanks.o vbanks.o prd.o crdknap.o\
        rmsk.o rmsdrc.o rmsd0.o rmsd1.o rmrc0.o rmrc1.o\
	slct.o pere.o  adokz.o adoks.o adokk.o adokkz.o zdocall.o\
	sklprov.o sklprv.o corauto.o autodoc.o corvt.o crdocopt.o\
	bindx.o periodn.o maine.o libfcn.o slctn2.o menu.o libfcne.o\
	ent.o mmain.o deb.o kass.o libdbf.o\
	\
	head.o pnn.o\
	\
	fisc_client.o\
	\
	viewtext.o

#rs2kvp.o
#rddsys.o\

.SUFFIXES: .prg .o

all:    $(OBJS) 
#	$(CLIP) -e -s $(OBJS) $(CLIPLIBS)
	$(CLIP) -e --static $(OBJS) 
	cp main app_fin
	rm main

clean:
	rm -rf *.o *.c *.a *.so *.b *.BAK *.bak *~ core* *core *.ex *.nm

install:
	rm -f /usr/local/sbin/app_fin
	cp ./app_fin /usr/local/sbin/app_fin

copy:
	./cp_fin

.prg.o:
	$(CLIP) $(CLIPFLAGS) $<

.prg.po:
	$(CLIP) $(CLIPFLAGS) -p $<

