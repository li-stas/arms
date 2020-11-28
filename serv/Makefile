ifdef CLIPROOT
include $(CLIPROOT)/include/Makefile.inc
endif
CLIP	= $(CLIPROOT)/bin/clip
CLIPFLAGS = -a -O -l 
CLIPLIBS  =
OBJS  = main.o serv.o mserv.o \
	\
        mkeep.o brands.o brnac.o mmplan.o mkotch.o mkotchn.o mkotchd.o mkotchda.o\
        \
        klnnac.o kgp.o kps.o s_kln.o s_krn.o sbarost.o\
        \
        stag.o smarsh.o amplan.o sprod.o kpksk.o napprod.o bon.o\
        \
        vid.o s_ctov.o lic.o nds.o ndsdoc.o\
        \
        sstat.o crctov.o krstat.o\
        \
        cmrsh.o crmrsh.o czg.o kgpsk.o vmrsh.o cmrshlib.o atsl.o\
        \
        sinctov.o users.o ktoins.o\
        \
        s_tag.o\
        \
        rsprn.o rso.o sp_ttn.o rslib.o rslibe.o\
        \
        smtp_obj.o vpath.o periodn.o maine.o libfcn.o libdbf.o slctn2.o slct.o\
        menu.o ent.o mmain.o libfcne.o
        
#rddsys.o\

.SUFFIXES: .prg .o

all:    $(OBJS) 
#	$(CLIP) -e -s $(OBJS) $(CLIPLIBS)
	$(CLIP) -e --static $(OBJS)
	cp main app_serv
	rm main

clean:
	rm -rf *.o *.c *.a *.so *.b *.BAK *.bak *~ core* *core *.ex *.nm

copy:
	./cp_serv
	
install:
	rm -f /usr/local/sbin/app_serv
	cp ./app_serv /usr/local/sbin/app_serv

.prg.o:
	$(CLIP) $(CLIPFLAGS) $<

.prg.po:
	$(CLIP) $(CLIPFLAGS) -p $<

