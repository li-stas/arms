ifdef CLIPROOT
include $(CLIPROOT)/include/Makefile.inc
endif
CLIP	= $(CLIPROOT)/bin/clip
CLIPFLAGS = -a -O -l 
CLIPLIBS  =
OBJS  = main.o sklad.o vtara.o\
	msklad.o prhrsh.o pere.o cdocopt.o crdocopt.o sert.o psert.o \
	sklprv.o\
	\
	sctov.o vobr.o tov.o tovp.o tovm.o vost.o vostm.o tovins.o cen.o\
	pr1ktl.o rs1ktl.o vcen.o vinv.o obncen.o vobrpr.o ctov.o \
	prnprice.o deb.o debn.o debn03.o debs.o lpos.o lposd.o mcrdbc.o\
	\
	pudl.o protch.o prh.o prved.o pr2kvp.o pr2.o\
	ptovslc.o ptovslc3.o ptovslcc.o ptovslcd.o\
	pfakt.o crpro.o pro.o pprot.o pprh.o paotv.o\
	pr3ssf.o etic.o praotv.o rfakt.o rprh.o rprhp.o rpaotv.o rs2zen.o\
	rudl.o rved_e.o rzag.o tsert.o bso1.o bso2.o rtovslc.o rtovmslc.o\
	rs2ins.o rs2mins.o rvedvgr.o rsved.o rsh.o rs2.o rs2m.o rso.o crrso.o\
	rprot.o rsprn.o rs3ssf.o rfinskl.o vtar.o vkach.o rsdogzen.o rsshap.o\
	rssert.o rsvedtd.o rszg.o sp_ttn.o rsprnm.o rsnaczen.o rslib.o rslibe.o\
	\
	dobnv.o tost.o  slct.o nost.o protv.o scen.o crs2m.o psort.o s92.o\
	tdoc.o frarh.o s361.o maska.o\
	\
	pnn.o nnt.o head.o pnnv.o \
	\
	cmrsh.o kgpsk.o vmrsh.o crmrsh.o czg.o vzttn.o cmrshlib.o\
	\
	tov_d.o sbarost.o\
	\
	rmsk.o rmsd0.o rmsd1.o rmrc0.o rmrc1.o rmsdrc.o corvt.o corauto.o autodoc.o\
	\
	lic.o nds.o s_soper.o s_tag.o s_sgrp.o odkp.o mkotchd.o ndsdoc.o\
	\
	bindx.o slctn2.o periodn.o vpath.o maine.o libfcn.o libdbf.o libfcne.o\
	ftoken.o\
	\
	menu.o ent.o mmain.o

#rddsys.o\
#aaa

.SUFFIXES: .prg .o

all:    $(OBJS) 
#	$(CLIP) -e -s $(OBJS) $(CLIPLIBS)
	$(CLIP) -e --static  $(OBJS)
	cp main app_sklad
	rm main

clean:
	rm -rf *.o *.c *.a *.so *.b *.BAK *.bak *~ core* *core *.ex *.nm

copy:
	./cp_sklad
	
install:
	rm -f /usr/local/sbin/app_sklad
	cp ./app_sklad /usr/local/sbin/app_sklad

.prg.o:
	$(CLIP) $(CLIPFLAGS) $<

.prg.po:
	$(CLIP) $(CLIPFLAGS) -p $<

