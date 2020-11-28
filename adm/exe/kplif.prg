* Разделение 361
clea
set prin to sdv.txt
set prin on
if gnEnt<20
   retu .t.
endif
netuse('cskl')
sele cskl
go top
do while !eof()
   if !(ent=gnEnt.and.rasc=1).and.!(gnEnt=21.and.sk=238.or.gnEnt=20.and.sk=239)
      skip
      loop
   endif
   pathr=gcPath_d+alltrim(path)
   if !netfile('tov',1)
      sele cskl
      skip
      loop
   endif
   ?pathr
   gnSk=sk
   ?'Расход'
if .T.
   netuse('rs1',,,1)
   netuse('rs3',,,1)
   sele rs1
   go top
   do while !eof()
      ttnr=ttn
      kopr=kop

      sdv1r=getfield('t1','ttnr,90','rs3','bssf')
      sdv2r=getfield('t1','ttnr,90','rs3','xssf')

      ssftr=getfield('t1','ttnr,19','rs3','ssf') && тара

      ndstr=getfield('t1','ttnr,12','rs3','ssf') && НДС на тару
      if ndstr#0
         ssftr=0
      endif

      ?str(ttnr,6)+' '+str(kopr,3)
      sele rs1
      netrepl('sdvm,sdvt','sdv-ssftr,ssftr')
      if fieldpos('sdvm1')#0
         netrepl('sdvm1','sdv1r-ssftr')
         netrepl('sdvm2','sdv2r-ssftr')
      endif
      ??' '+str(sdv,12,2)+' '+str(sdvm,12,2)+' '+str(sdvt,12,2)
      sele rs1
      skip
   endd
   nuse('rs1')
   nuse('rs3')
endif
   ?'Приход'
   netuse('pr1',,,1)
   netuse('pr3',,,1)
   sele pr1
   go top
   do while !eof()
      if prz=0
         sele pr1
         skip
         loop
      endif
      mnr=mn
      kopr=kop
      ndr=nd
      ssftr=getfield('t1','mnr,19','pr3','ssf') && тара
*      if ssftr=0
*         sele pr1
*         skip
*         loop
*      endif

      ndstr=getfield('t1','mnr,12','pr3','ssf') && НДС на тару
      if ndstr#0
         ssftr=0
      endif

      ?str(ndr,6)+' '+str(mnr,6)+' '+str(kopr,3)

      sele pr1
      netrepl('sdvm,sdvt','sdv-ssftr,ssftr')
      ??' '+str(sdv,12,2)+' '+str(sdvm,12,2)+' '+str(sdvt,12,2)

      sele pr1
      skip
   endd
   nuse('pr1')
   nuse('pr3')
   sele cskl
   skip
   loop
endd
nuse()
set prin off
set prin to txt.txt

****************
func zensdva()
****************
clea
set prin to zensdva.txt
set prin on
if gnEnt#20
   retu .t.
endif
netuse('cskl')
do case
   case gnRmSk=0
        skr=228
   case gnRmSk=3
        skr=300
   case gnRmSk=4
        skr=400
   case gnRmSk=5
        skr=500
   case gnRmSk=6
        skr=600
endc
flr='zensdva'+str(gnRmSk,1)+'.dbf'
flxr='zensdvax.dbf'
if !file(flr)
   if !file(flxr)
      wmess('Нет файла '+flr)
      retu .t.
   else
      aflr='zensdvax'
   endif
else
   aflr='zensdva'+str(gnRmSk,1)
endif
   netuse('tara')
   netuse('tcen')
   netuse('kln')
   netuse('kpl')
   netuse('kgp')
   netuse('kgptm')
   netuse('krntm')
   netuse('nasptm')
   netuse('rntm')
   netuse('ctov')
   netuse('stagm')
   netuse('tmesto')
   netuse('cskl')
   netuse('s_tag')
   netuse('vop')
   netuse('dclr')
   netuse('vo')
   netuse('dokk')
   netuse('dkkln')
   netuse('dknap')
   netuse('dkklns')
   netuse('dkklna')
   netuse('dokko')
   netuse('bs')
   netuse('moddoc')
   netuse('mdall')
   netuse('tov')
   netuse('sgrp')
   netuse('cgrp')
   netuse('tovm')
   netuse('soper')
   netuse('grpizg')
   netuse('nap')
   netuse('naptm')
   netuse('kplnap')
   netuse('ktanap')
sele cskl
locate for sk=skr
pathr=gcPath_d+alltrim(path)
netuse('rs1',,,1)
netuse('rs2',,,1)
netuse('rs3',,,1)
sele 0
use (aflr)
sele (aflr)
go top
do while !eof()
   reclock()
   sdv_rr=sdv
   ttnr=ttn
   sele rs1
   if netseek('t1','ttnr')
      reclock()
      kop_r=kop
      sdv_r=getfield('t1','ttnr,90','rs3','ssf')
      sele rs2
      if netseek('t1','ttnr')
         do while ttn=ttnr
            ktlr=ktl
            mntovr=mntov
            zenr=getfield('t1','mntovr','ctov','cenpr')
            kvpr=kvp
            zen_r=zen
            svpr=roun(kvpr*zenr,2)
            ?str(ttnr,6)+' '+str(ktlr,9)+' '+str(zen_r,10,3)+' -> '+str(zenr,10,3)
            netrepl('zen,svp,zenp,przenp,bzen,prbzenp','zenr,svpr,zenr,0,zenr,0')
            sele rs2
            skip
         enddo
         sele rs1
         kop_rr=kop
         kopr=kop
         if kop_rr#169
            kplr=kpl
            kgpr=kgp
            ?str(ttnr,6)+' '+str(kop_r,3)+' -> '+str(kopr,3)
            netrepl('kop,kpl,kgp,nkkl,kpv','169,20034,20034,kplr,kgpr')
            kopr=kop
         endif
         dcpere(0,ttnr)
         sele rs1
         sdvr=getfield('t1','ttnr,90','rs3','ssf')
         sele rs1
         przr=prz
         sele (aflr)
         repl sdv with sdv_r,;
              nsdv with sdvr,;
              kop with kop_rr,;
              nkop with kopr,;
              prz with przr
      endif
      sele rs1
      netunlock()
   else
      ?str(ttnr,6)+' не найдена'
   endif
   sele (aflr)
   netunlock()
   skip
endd

sele (aflr)
use

if aflr#'zensdvax'
   rename (flr) to 'zensdvax.dbf'
endif

nuse()
set prin off
set prin to txt.txt
retu .t.



