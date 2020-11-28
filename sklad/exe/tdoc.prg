#include "common.ch"
#include "inkey.ch"
  // Документы по времени
clea

set prin to tdoc.txt
set prin on
crtt('tdoc','f:nd c:n(6) f:mn c:n(6) f:dpr c:d(8) f:ttn c:n(6) f:dvp c:d(8)')
sele 0
use tdoc excl
inde on str(mn,6)+str(ttn,6) tag t1
netuse('rs1')
netuse('rs2')
netuse('pr1')
netuse('pr2')
netuse('tov')
sele rs2
do while !eof()
   if int(ktl/1000000)<2
      skip
      loop
   endif
   ttnr=ttn
   ktlr=ktl
   sele rs1
   if !netseek('t1','ttnr')
      sele rs2
      skip
      loop
   endif
   dvpr=dvp
   dopr=dop
   dotr=dot
   sklr=skl
   sele tov
   if !netseek('t1','sklr,ktlr')
      sele rs2
      skip
      loop
   endif
   prmnr=prmn
   dppr=dpp
   dprr=ctod('')
   if prmnr#0
      sele pr2
      if netseek('t1','prmnr,ktlr')
         dprr=getfield('t2','prmnr','pr1','dpr')
      endif
   endif
   if empty(dprr)
      if !empty(dppr)
         dprr=dppr
      endif
   endif
   if !empty(dprr)
      if !empty(dvpr).and.dvpr<dprr //.or.!empty(dopr).and.dopr<dprr.or.!empty(dotr).and.dotr<dprr
         ?str(ttnr,6)+' '+str(ktlr,9)+' DVP '+dtoc(dvpr)+' DOP '+dtoc(dopr)+' DOT '+dtoc(dotr)+' DPR '+dtoc(dprr)+' '+str(prmnr,6)
         sele tdoc
         seek str(prmnr,6)+str(ttnr,6)
         if !foun()
            appe blank
            repl mn with prmnr,dpr with dprr,ttn with ttnr,dvp with dvpr
         endif
      endif
   endif
   sele rs2
   skip
endd
sele tdoc
go top
do while .t.
   rctdocr=slcf('tdoc',,,,,"e:nd h:'ND' c:n(6) e:mn h:'MN' c:n(6) e:dpr h:'Дата П' c:d(10) e:ttn h:'ТТН' c:n(6) e:dvp h:'DVP' c:d(10)")
   if lastkey()=K_ESC
      exit
   endif
endd
set prin off
set prin to
sele tdoc
use
nuse()

func docsrch()
clea
netuse('cskl')
store gdTd to dt1r,dt2r
store space(36) to docguidr
crtt('docsrch','f:sk c:n(3) f:nskl c:c(15),f:ttn c:n(6) f:docguid c:c(36)')
sele 0
use docsrch
do while .t.
   cldsr=setcolor('gr+/b,n/bg')
   wdsr=wopen(10,10,15,60)
   wbox(1)
   @ 0,1 say 'Период c' get dt1r
   @ 0,col()+1 say 'по ' get dt2r
   @ 1,1 say 'Основание' get docguidr
   read
   wclose(wdsr)
   setcolor(cldsr)
   if lastkey()=K_ESC
      exit
   endif
   docguidr=alltrim(docguidr)
   if lastkey()=K_ENTER
      for yyr=year(dt1r) to year(dt2r)
          pathgr=gcPath_e+'g'+str(yyr,4)+'\'
          do case
             case year(dt1r)=year(dt2r)
                  mm1r=month(dt1r)
                  mm2r=month(dt2r)
             case yyr=year(dt1r)
                  mm1r=month(dt1r)
                  mm2r=12
             case yyr=year(dt2r)
                  mm1r=1
                  mm2r=month(dt2r)
                  mm1r=1
                  mm2r=12
             other
          endc
          for mmr=mm1r to mm2r
              pathdr=pathgr+'m'+iif(mmr<10,'0'+str(mmr,1),str(mmr,2))+'\'
              sele cskl
              go top
              do while !eof()
                 if !(ent=gnEnt.and.rasc=1)
                    skip
                    loop
                 endif
                 pathr=pathdr+alltrim(path)
                 if !netfile('rs1',1)
                    sele cskl
                    skip
                    loop
                 endif
                 skr=sk
                 nsklr=alltrim(nskl)
                 netuse('rs1',,,1)
                 go top
                 do while !eof()
                    if empty(docguid)
                       skip
                       loop
                    endif
                    if at(docguidr,docguid)#0
                       ttnr=ttn
                       docguid_r=docguid
                       sele docsrch
                       netadd()
                       netrepl('sk,nskl,ttn,docguid','skr,nsklr,ttnr,docguid_r')
                    endif
                    sele rs1
                    skip
                 endd
                 nuse('rs1')
                 sele cskl
                 skip
              endd
          next
      next
      exit
   endif
endd
sele docsrch
go top
do while .t.
   rcdsr=slcf('docsrch',,,,,"e:sk h:'SK' c:n(3) e:nskl h:'Склад' c:c(15) e:ttn h:'ТТН' c:n(6) e:docguid h:'Документ КПК' c:c(36)")
   if lastkey()=K_ESC
      exit
   endif
endd
sele docsrch
use
erase docsrch.dbf
nuse()
retu .t.
