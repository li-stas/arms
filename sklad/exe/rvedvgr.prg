#include "common.ch"
#include "inkey.ch"
save scre to scrvedv
setcolor('gr+/b,n/w')
vlpt1='lpt1'
clea
netuse('rs1')
netuse('rs2')
netuse('kln')
netuse('soper')
netuse('tto')
netuse('s_tag')
netuse('sgrp')

crtt('grp','f:kgrp c:n(3)')
sele 0
use grp
inde on str(kgrp,3) tag t1

crtt('kop','f:kop c:n(3) f:tto c:n(2) f:nop c:c(40)')
sele 0
use kop
inde on str(tto,2)+str(kop,3) tag t1
crtt('drs1','f:tto c:n(2) f:kop c:n(3) f:kgp c:n(7) f:kpv c:n(7) f:npv c:c(30) f:ttn c:n(6) f:nkgp c:c(30) f:nkpv c:c(30) f:sdv c:n(10,2) f:dvp c:d(8) f:dot c:d(8) f:fio c:c(20) f:prz c:n(1) f:sdvgr c:n(10,2)')
sele 0
use drs1
inde on str(tto,2)+dtos(dvp)+str(kgp,7)+str(kop,3) tag t1

dt1r=bom(gdTd)
dt2r=eom(gdTd)
oclr=setcolor('gr+/b,n/w')
*wrvedv=wopen(1,1,23,78)
*wbox(1)
kgrpr=0
do while .t.
   kgrpr=0
   @ 0,1 say '¥à¨®¤ c ' get dt1r
   @ 0,col()+1 say '¯® ' get dt2r
   read
   if lastkey()=K_ESC
      exit
   endif
   @ 1,1 prom '¥¯®¤â¢¥à¦¤¥­­ë¥'
   @ 1,col()+1 prom '®¤â¢¥à¦¤¥­­ë¥'
   menu to np
   if lastkey()=K_ESC
      exit
   endif
   if np=1
      prz_r=0
   else
      prz_r=1
   endif

   if select('sl')=0
      sele 0
      use _slct alias sl excl
   endif

   sele sl
   zap
   do while .t.
      sele sgrp
      kgrpr=slcf('sgrp',,,,,"e:kgr h:'Š®¤' c:n(3) e:ngr h:' ¨¬¥­®¢ ­¨¥' c:c(20)",'kgr',1)
      if lastkey()=K_ENTER
         exit
      endif

   enddo
   sele sl
   if recc()#0
      go top
      do whil !eof()
         kgrpr=val(kod)
         sele grp
         appe blank
         netrepl('kgrp','kgrpr')
         sele sl
         skip
      endd
      przgrr=1
   else
      przgrr=0
   endif

   sele sl
   zap

*   wselect(0)
*   save scre to scved
*   oclr1=setcolor(oclr)
   clea
   r_ved()
*  setcolor(oclr1)
*  rest scre from scved
*  wselect(wrvedv)
enddo
*wclose(wrvedv)
*setcolor(oclr)
sele grp
use
erase grp.dbf
erase grp.cdx
sele kop
use
erase kop.dbf
erase kop.cdx
if select('dtto')#0
   sele dtto
   use
endif
erase dtto.dbf
sele drs1
use
*erase drs1.dbf
*erase drs1.cdx
rest scre from scrvedv
nuse()

proc r_ved
save scre to scmess
mess('†¤¨â¥...')
vlpt1='lpt1'
d0k1r=0
sele rs1
go top
do while !eof()
   if prz#prz_r
      skip
      loop
   endif
   if sdv=0
      skip
      loop
   endif
   if !(dvp>=dt1r.and.dvp<=dt2r)
      skip
      loop
   endif
   dvpr=dvp
   dotr=dot
   kopr=kop
   vur=int(kopr/100)
   qr=mod(kopr,100)
   vor=vo
   ttnr=ttn
   kgpr=kgp
   kpvr=kpv
   npvr=npv
   sdvr=sdv
   przr=prz
   ktar=kta
   sele soper
   if netseek('t1','d0k1r,vur,vor,qr')
      nopr=nop
      ttor=tto
   else
      nopr=''
      ttor=0
   endif
*   if ttor#0
      sele kop
      if !netseek('t1','ttor,kopr')
         appe blank
         netrepl('kop,tto,nop','kopr,ttor,nopr')
      endif
      nkgpr=getfield('t1','kgpr','kln','nkl')
      nkpvr=getfield('t1','kpvr','kln','nkl')
      fior=getfield('t1','ktar','s_tag','fio')
      sdvgrr=0
      if przgrr=1
         sele rs2
         if netseek('t1','ttnr')
            do while ttn=ttnr
               kgrpr=int(ktl/1000000)
               sele grp
               seek str(kgrpr,3)
               if FOUND()
                  sele rs2
                  sdvgrr=sdvgrr+svp
               endif
               sele rs2
               skip
            endd
         endif
      endif
      sele drs1
      appe blank
      netrepl('tto,kop,kgp,kpv,npv,ttn,nkgp,nkpv,sdv,fio,dvp,dot,prz,sdvgr','ttor,kopr,kgpr,kpvr,npvr,ttnr,nkgpr,nkpvr,sdvr,fior,dvpr,dotr,przr,sdvgrr')
*   endif
   sele rs1
   skip
endd
crtt('dtto','f:tto c:n(2) f:nai c:c(20)')
sele 0
use dtto
appe blank
repl nai with 'Žáâ «ì­ë¥'
sele kop
go top
do while !eof()
   ttor=tto
   sele dtto
   locate for tto=ttor
   if !FOUND()
       sele tto
       if netseek('t1','ttor')
          nttor=nai
          sele dtto
          appe blank
          netrepl('tto,nai','ttor,nttor')
       endif
   endif
   sele kop
   skip
endd
rest scre from scmess
if select('sl')=0
   sele 0
   use _slct alias sl excl
endif
do while .t.
   sele dtto
   go top
   ttor=slcf('dtto',,,,,"e:tto h:'’Ž' c:n(2) e:nai h:' ¨¬¥­®¢ ­¨¥' c:c(20)",'tto')
   do case
      case lastkey()=K_ESC
           exit
      case lastkey()=K_ENTER
           sele sl
           zap
           sele kop
           netseek('t1','ttor')
           do while .t.
              foot('SPACE,ENTER,F4','Žâ¬¥â¨âì,¥ç âì,‘¥â¥¢ ï ¯¥ç âì')
              kopr=slcf('kop',,,,,"e:kop h:'Š®¤' c:n(3) e:nop h:' ¨¬¥­®¢ ­¨¥' c:c(40)",'kop',1,,'tto=ttor')
              do case
                 case lastkey()=K_ESC
                      exit
                 case lastkey()=K_ENTER
                      rvedvp(1)
                 case lastkey()=K_F4
                    alpt={'lpt2','lpt3'}
                    vlpt=alert('…—€’œ € ‘…’…‚Ž‰ ˆ’…',alpt)
                    if vlpt=1
                       vlpt1='lpt2'
                    else
                       vlpt1='lpt3'
                    endif
                      rvedvp(2)
              endc
              sele kop
              netseek('t1','ttor,kopr')
           endd
   endc
endd

proc rvedvp
para p1
sele sl
go top
if eof()
   retu
endif
sele tto
netseek('t1','ttor')
nttor=nai
sele drs1
if netseek('t1','ttor')
   if p1=1
      if gnOut=1
         set print to lpt1
      else
         set prin to txt.txt
      endif
      set cons off
      set prin on
      if empty(gcPrn)
         ?chr(27)+chr(80)+chr(15)
      else
         ? chr(27)+'E'+chr(27)+'&l1h26a0O'+chr(27)+chr(27)+'(3R'+chr(27)+'(s0p20.00h0s1b4102T'+chr(27)  // Š­¨¦­ ï €4
      endif
   else
      set print to &vlpt1
      set cons off
      set prin on
      ? chr(27)+'E'+chr(27)+'&l1h26a0O'+chr(27)+chr(27)+'(3R'+chr(27)+'(s0p20.00h0s1b4102T'+chr(27)  // Š­¨¦­ ï €4
   endif
   set devi to print
   lstr=1
   rw_r=8
   rw_re=60
   srvedv()
   dvpr=ctod('')
   kgpr=0
   kopr=0
   ssdvr=0
   ssdvgrr=0
   do while tto=ttor
      kop_r=kop
      sele sl
      locate for val(kod)=kop_r
      if !FOUND()
         sele drs1
         skip
         loop
      endif
      sele drs1
      if przgrr=1.and.sdvgr=0
         skip
         loop
      endif
      if dvp#dvpr
         ?' '+dtoc(dvp)
         rw()
         dvpr=dvp
      endif
      if kgp#kgpr
         ?' '+str(kgp,7)+' '+nkgp+' '+str(ttn,6)+' '+str(sdv,10,2)+' '+dtoc(dot)+' '+str(prz,1)+' '+str(kop,3)+' '+fio+' '+nkpv+' '+npv //iif(sdvgr#0,str(sdvgr,10,2),space(10))
         rw()
         kgpr=kgp
         kopr=kop
      else
         if kop#kopr
            ?space(40)+str(ttn,6)+' '+str(sdv,10,2)+' '+dtoc(dot)+' '+str(prz,1)+' '+str(kop,3)+' '+fio+' '+' '+nkpv+' '+npv //+iif(sdvgr#0,str(sdvgr,10,2),space(10))
            rw()
            kopr=kop
         else
            ?space(40)+str(ttn,6)+' '+str(sdv,10,2)+' '+dtoc(dot)+' '+str(prz,1)+' '+str(kop,3)+' '+fio+' '+' '+nkpv+' '+npv //+iif(sdvgr#0,str(sdvgr,10,2),space(10))
            rw()
         endif
      endif
      ssdvr=ssdvr+sdv
      ssdvgrr=ssdvgrr+sdvgr
      skip
   endd
   ?' '+space(7)+' '+'ˆâ®£® :'+space(23)+' '+space(6)+' '+str(ssdvr,10,2)+space(39)+str(ssdvgrr,10,2)
   rw()
   eject
   set prin off
   set cons on
   set print to
   set devi to screen
endif
retu

proc srvedv
if lstr=1
   ?'                                        ‚¥¤®¬®áâì ¢ë¯¨á ­­ëå à áå®¤­ëå ¤®ªã¬¥­â®¢'
   ?'                                           ¯® '+alltrim(gcNskl)+' c '+dtoc(dt1r)+' ¯® '+dtoc(dt2r)
   ?'                                                    '+nttor
   rw_r=8
else
   rw_r=5
endif
?'                                                                                                                                          ‹¨áâ '+str(lstr,2)
?'ÚÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÂÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿'
?'³  Š®¤  ³            Š«¨¥­â            ³ ’’  ³  ‘ã¬¬    ³ Žâ£àã§ª ³³ŠŽ³        €£¥­â       ³  ƒàã§®¯®«ãç â¥«ì   ³ Š®­.¯ã­ªâ ¢ë£àã§ª¨ ³  Žâ¬¥âª  ³'
?'ÃÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÅÄÅÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄ´'

proc rw
rw_r++
if rw_r=rw_re
   eject
   lstr++
   srvedv()
endif
***********************
func otkms()
* Žâç¥âë ª®¬¨áá¨®­¥à®¢
***********************
if gnKt#1
   retu .t.
endif
clea
netuse('skl')
netuse('tov')
netuse('tovm')
netuse('rs1')
netuse('rs2')
netuse('rs3')
netuse('otkt')
netuse('otkte')
netuse('kln')
netuse('cskl')

sele tov
go top
do while !eof()
   sklr=skl
   sele skl
   if !netseek('t1','sklr')
      netadd()
      netrepl('skl','sklr')
   endif
   sele tov
   skip
endd
sele skl
go top
rcsklr=recn()
do while .t.
   sele skl
   go rcsklr
   foot('','')
   rcsklr=slcf('skl',1,1,5,,"e:skl h:'Š®¤' c:n(7) e:getfield('t1','skl->skl','kln','nkl') h:' ¨¬¥­®¢ ­¨¥' c:c(40)",,,1,,,,'Š®¬¨áá¨®­¥àë')
   if lastkey()=K_ESC
      exit
   endif
   go rcsklr
   kklr=skl
   if lastkey()=K_ENTER
      otkt()
   endif
endd
nuse()
retu .t.

*************
func otkt()
*************
save scre to scotktr
sele otkt
set orde to tag t2
if !netseek('t2','kklr')
   go top
endif
go top
rcotktr=recn()
do while .t.
   sele otkt
   set orde to tag t2
   go rcotktr
   foot('INS,DEL,ENTER','„®¡,“¤,‘®áâ ¢')
   rcotktr=slcf('otkt',1,55,5,,"e:otkt h:'Š®¤' c:n(10) e:dt h:'„ â ' c:d(10)",,,1,,,,'Žâç¥âë')
   if lastkey()=K_ESC
      exit
   endif
   go rcotktr
   otktr=otkt
   dtr=dt
   do case
      case lastkey()=K_ENTER
           otkte()
      case lastkey()=K_INS // ins
           sele cskl
           locate for sk=gnSk
           if foun()
              reclock()
              if aktkt=0
                 replace aktkt with gnSk*10000000+1
              endif
              otktr=aktkt
              do while .t.
                 sele otkt
                 if !netseek('t1','otktr')
                    exit
                 else
                    otktr=otktr+1
                 endif
              endd
              sele cskl
              netrepl('aktkt','otktr')
              sele otkt
              netadd()
              netrepl('otkt,dt','otktr,date()')
              rcotktr=recn()
           endif
      case lastkey()=K_DEL  // del
           sele otkte
           if netseek('t2','otktr')
              wmess('Žâç¥â ­¥ ¯ãáâ®©',2)
              loop
           endif
           netdel()
           skip -1
           if bof()
              go top
           endif
           rcotktr=recn()
   endc
endd
rest scre from scotktr
retu .t.

**************
func otkte()
**************
save scre to scotkter
sele otkte
set orde to tag t2
store 0 to smr,smar
if !netseek('t2','otktr')
   go top
else
   do while otkt=otktr
      smar=smar+roun(kvp*zenp,2)
      smr=smr+roun(kvp*zenot,2)
      skip
   endd
   netseek('t2','otktr')
endif
wlr='.t..and.otkt=otktr'
rcotkter=recn()
do while .t.
   sele otkte
   set orde to tag t2
   go rcotkter
   foot('INS,DEL,F9','„®¡,“¤,‘®§¤ âì ¤®ªã¬¥­âë')
   rcotkter=slcf('otkte',11,,8,,"e:ktl h:'Š®¤' c:n(9) e:nat h:' ¨¬¥­®¢ ­¨¥' c:c(30) e:kvp h:'Š®«-¢®' c:n(4) e:zenp h:'–¥­ A' c:n(5,2) e:zenot h:'–¥­ Ž' c:n(5,2) e:ttn h:'’’A' c:n(6) e:ttno h:'’’O' c:n(6) e:getfield('t1','otkte->ttno,otkte->ktl','rs2','kvp') h:'Š®«Ž' c:n(4)",,,1,wlr,,,str(otktr,10)+' '+dtoc(dtr)+' A='+str(smar,10,2)+' O='+str(smr,10,2))
   if lastkey()=K_ESC
      exit
   endif
   go rcotkter
   skr=sk
   ttnr=ttn
   ktlr=ktl
   kvpr=kvp
   zenpr=zenp
   zenotr=zenot
   natr=nat
   do case
      case lastkey()=K_F9 // ‘®§¤ âì ¤®ªã¬¥­âë
           crttno()
      case lastkey()=K_INS // ins
           otktei()
           sele otkte
           set orde to tag t2
           if !netseek('t2','otktr')
              go top
           endif
           rcotkter=recn()
      case lastkey()=K_DEL  // del
           if ttno#0
              wmess('„®ªã¬¥­â ã¦¥ á®§¤ ­',2)
              loop
           endif
           netdel()
           skip -1
           if bof()
              go top
           endif
           rcotkter=recn()
   endc
endd
rest scre from scotkter
retu .t.

**************
func otktei()
**************
sele tov
if netseek('t1','kklr')
   rctovr=recn()
   do while .t.
      sele tov
      go rctovr
      foot('SPACE','Žâ¡®à')
      set cent off
      rctovr=slcf('tov',,,,,"e:ktl h:'Š®¤' c:n(9) e:nat h:' ¨¬¥­®¢ ­¨¥' c:c(30) e:osv h:'Žáâ â®ª' c:n(4) e:cenkt h:'–¥­ ' c:n(6,3) e:skkt h:'‘ª«' c:n(3) e:ttnkt h:'’’A' c:n(6) e:dtkt h:'„ â ' c:d(8)",,,,,,,'Žáâ âª¨')
      set cent on
      if lastkey()=K_ESC
         exit
      endif
      go rctovr
      ktlr=ktl
      osvr=osv
      cenktr=cenkt
      natr=nat
      skktr=skkt
      ttnktr=ttnkt
      if lastkey()=K_SPACE
         otkteadd()
      endif
   endd
endif
retu .t.
****************
func otkteadd()
****************
claddr=setcolor('gr+/b,n/bg')
waddr=wopen(10,5,14,75)
wbox(1)
zenotr=getfield('t1','otktr,skktr,ttnktr,ktlr','otkte','zenot')
if zenotr=0
   zenotr=cenktr
endif
kvpr=getfield('t1','otktr,skktr,ttnktr,ktlr','otkte','kvp')
do while .t.
   @ 0,1 say str(ktlr,9)+' '+natr
   @ 1,1 say 'Žáâ â®ª'+' '+str(osvr,10,3)+' '+'–¥­ €'+' '+str(cenktr,10,3)
   @ 2,1 say 'Š®«-¢® ' get kvpr pict '999999.999' range 0,osvr
   @ 2,col()+1 say '–¥­ Ž' get zenotr pict '999999.999'
   read
   if lastkey()=K_ESC
      exit
   endif
   if lastkey()=K_ENTER
      sele otkte
      if !netseek('t1','otktr,skktr,ttnktr,ktlr')
         netadd()
         netrepl('otkt,sk,ttn,ktl,zenp,nat','otktr,skktr,ttnktr,ktlr,cenktr,natr')
      endif
      if ttno=0
         netrepl('kvp,zenot','kvpr,zenotr')
         if kvp=0.or.zenot=0
            netdel()
            skip -1
            if bof()
               go top
            endif
            rcotkter=recn()
         endif
      else
         wmess('„®ªã¬¥­â ã¦¥ á®§¤ ­',2)
      endif
      exit
   endif
endd
wclose(waddr)
setcolor(claddr)
retu .t.

**************
func crttno()
**************
sele otkte
set orde to tag t1
if netseek('t1','otktr')
   kplr=kklr
   store 0 to skkt_r,ttnkt_r,ttnr
   do while otkt=otktr
      if ttno#0
         sele otkte
         skip
         loop
      endif
      if kvp=0
         sele otkte
         skip
         loop
      endif
      if zenot=0
         sele otkte
         skip
         loop
      endif
      skktr=sk
      ttnktr=ttn
      ktlr=ktl
      kvpr=kvp
      zenr=zenot
      zenpr=zenp
      sele tov
      if netseek('t1','kklr,ktlr')
         reclock()
         if kvpr>osv
            kvpr=osv
         endif
         if kvpr>0
            mntovr=mntov
            ktlktr=ktlkt
            svpr=roun(kvpr*zenr,2)
            if !(skkt_r=skktr.and.ttnkt_r=ttnktr)
               sele cskl
               locate for sk=gnSk
               if foun()
                  reclock()
                  ttnr=ttn
                  do while .t.
                     if !netseek('t1','ttnr','rs1')
                        exit
                     endif
                     ttnr=ttnr+1
                  endd
                  sele cskl
                  netrepl('ttn','ttnr')
               else
                  ttnr=0
               endif
               skkt_r=skktr
               ttnkt_r=ttnktr
            endif
            sele otkte
            if ttnr#0
               sele rs1
               if !netseek('t1','ttnr')
                  store 0 to nndsktr
                  store ctod('') to dnnktr
                  ttnkt()
                  sele rs1
                  netadd()
                  netrepl('ttn,ttnkt,vo,kop,kopi','ttnr,ttnktr,3,137,137',1)
                  netrepl('kpl,kgp,skl,nkkl,kpv','kklr,gnKkl_c,kklr,kklr,gnKkl_c',1)
                  netrepl('ddc,tdc,dvp','date(),time(),date()',1)
                  netrepl('nndskt,dnnkt','nndsktr,dnnktr')
               endif
               sele rs2
               if !netseek('t1','ttnr,ktlr')
                  netadd()
                  netrepl('ttn,ktl,ktlp,mntov,mntovp,kvp,zen,zenp,bzen,ktlkt,svp','ttnr,ktlr,ktlr,mntovr,mntovr,kvpr,zenr,zenpr,zenr-zenpr,ktlktr,svpr')
               endif
               sele tov
               netrepl('osv','osv-kvpr')
               sele tovm
               if netseek('t1','kklr,mntovr')
                  netrepl('osv','osv-kvpr')
               endif
               sele otkte
               netrepl('ttno','ttnr')
            endif
         endif
         sele tov
         netunlock()
      endif
      sele otkte
      skip
   endd
endif
retu .t.
