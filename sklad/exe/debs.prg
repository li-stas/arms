#include "common.ch"
#include "inkey.ch"
* Дебеторка по супервайзерам
if gnArm#0
  clea
endif
pathdebr=gcPath_ew+'debs\'
dirdebr=gcPath_ew+'debs'

if dirchange(dirdebr)#0
   dirmake(dirdebr)
endif
dirchange(gcPath_l)

netuse('kln')
netuse('cskl')
netuse('s_tag')
netuse('krn')
netuse('knasp')
netuse('opfh')
netuse('bs')
if !file(pathdebr+'tbs.dbf')
   crtt(pathdebr+'tbs','f:bs c:n(6) f:nbs c:c(20) f:uchr c:n(1) f:dtc c:d(10) f:tmc c:c(8)')
endif
sele 0
use (pathdebr+'tbs') excl
sele bs
do while !eof()
   if gnArm#0
      if !(uchr=1.or.uchr=2)
         skip
         loop
      endif
   else
      if !(bs=361001.or.bs=361002)
         skip
         loop
      endif
   endif
   bsr=bs
   nbsr=nbs
   uchrr=uchr
   sele tbs
   locate for bs=bsr
   if !foun()
      netadd()
      netrepl('bs,nbs,uchr','bsr,nbsr,uchrr')
   endif
   sele bs
   skip
endd

sele tbs
go top
do while !eof()
   bsr=bs
   ddebr=pathdebr+'s'+str(bsr,6)
   if dirchange(ddebr)#0
      dirmake(ddebr)
   endif
   dirchange(gcPath_l)

   pdebr=pathdebr+'s'+str(bsr,6)+'\'
   if file(pdebr+'pdeb.dbf')
      adirect=directory(pdebr+'pdeb.dbf')
      dtcr=adirect[1,3]
      tmcr=adirect[1,4]
      repl dtc with dtcr,tmc with tmcr
   endif
   sele tbs
   skip
endd
go top
if gnArm#0
   store 0 to bsr,uchr,ogrr
   store ctod('') to dtcr
   store '' to nbsr,tmcr
   store 1 to psr
   rctbsr=recn()
   do while .t.
      sele tbs
      go rctbsr
      foot('ENTER,F5','Просмотр,Обновить')
      rctbsr=slcf('tbs',,,,,"e:bs h:'Счет' c:n(6) e:nbs h:'Наименование' c:c(20) e:uchr h:'Уч' c:n(3) e:dtc h:'Дата' c:d(10) e:tmc h:'Время' c:c(8)",,,,,,,'СЧЕТА')
      if lastkey()=K_ESC
         exit
      endif
      go rctbsr
      bsr=bs
      nbsr=nbs
      uchrr=uchr
      dtcr=dtc
      tmcr=tmc
      pdebr=pathdebr+'s'+str(bsr,6)+'\'
      do case
         case lastkey()=K_ENTER
              if empty(dtcr)
                 debbs(bsr)
              endif
              save scre to scshow
              showdebs()
              rest scre from scshow
         case lastkey()=K_F5.and.gnAdm=1
              debbs(bsr)
      endc
   endd
else
   ogrr=0
   sele tbs
   go top
   do while !eof()
      rctbsr=recn()
      bsr=bs
      if !(bsr=361001.or.bsr=361002)
         skip
         loop
      endif
      nbsr=nbs
      uchrr=uchr
      dtcr=dtc
      tmcr=tmc
      pdebr=pathdebr+'s'+str(bsr,6)+'\'
      debbs(bsr)
      sele tbs
      go rctbsr
      skip
   endd
endif
sele tbs
use
if select('pdeb')#0
   sele pdeb
   use
endif
if select('trs2')#0
   sele trs2
   use
endif
if select('tpr2')#0
   sele tpr2
   use
endif
if select('tdokk')#0
   sele tdokk
   use
endif
nuse()

*******************
func debbs(p1)
*******************
kkl_rr=0
if select('pdeb')#0
   sele pdeb
   use
endif
erase (pdebr+'pdeb.ddf')
erase (pdebr+'pdeb.cdx')

if select('dz')#0
   sele dz
   use
endif
erase (pdebr+'dz.dbf')
erase (pdebr+'dz.cdx')

if select('kz')#0
   sele kz
   use
endif
erase (pdebr+'kz.dbf')
erase (pdebr+'kz.cdx')

if select('tdop')#0
   sele tdop
   use
endif
erase (pdebr+'tdop.dbf')
erase (pdebr+'tdop.cdx')

if select('trs2')#0
   sele trs2
   use
endif
erase (pdebr+'trs2.dbf')
erase (pdebr+'trs2.cdx')

if select('tpr2')#0
   sele tpr2
   use
endif
erase (pdebr+'tpr2.dbf')
erase (pdebr+'tpr2.cdx')

if select('tsaldo')#0
   sele tsaldo
   use
endif
erase (pdebr+'tsaldo.dbf')
erase (pdebr+'tsaldo.cdx')

if select('tprz01')#0
   sele tprz01
   use
endif
erase (pdebr+'tprz01.dbf')
erase (pdebr+'tprz01.cdx')

if select('tprz02')#0
   sele tprz02
   use
endif
erase (pdebr+'tprz02.dbf')
erase (pdebr+'tprz02.cdx')

if select('trs27')#0
   sele trs27
   use
endif
erase (pdebr+'trs27.dbf')
erase (pdebr+'trs27.cdx')

if select('tdeb')#0
   sele tdeb
   use
endif
erase (pdebr+'tdeb.dbf')
erase (pdebr+'tdeb.cdx')

if select('tdokk')#0
   sele tdokk
   use
endif
erase (pdebr+'tdokk.dbf')
erase (pdebr+'tdokk.cdx')

crtt(pdebr+'tpr2','f:kps c:n(7) f:dpr c:d(10) f:sdv c:n(10,2) f:sdvm c:n(10,2) f:sdvt c:n(10,2) f:sdvs c:n(10,2) f:prz c:n(1) f:reg c:n(4) f:kta c:n(4) f:sk c:n(3) f:nd c:n(6) f:mn c:n(6) f:kop c:n(3) f:ktas c:n(4)')
sele 0
use (pdebr+'tpr2') excl
crtt(pdebr+'trs2','f:kpl c:n(7) f:dop c:d(10) f:sdv c:n(10,2) f:sdvm c:n(10,2) f:sdvm1 c:n(10,2) f:sdvm2 c:n(10,2) f:sdvt c:n(10,2) f:sdvs c:n(10,2) f:prz c:n(1) f:reg c:n(4) f:kta c:n(4) f:sk c:n(3) f:ttn c:n(6) f:kop c:n(3) f:kgp c:n(7) f:ktas c:n(4)')
sele 0
use (pdebr+'trs2') excl

dtpmr=ctod(stuff(dtoc(addmonth(gdTd,-1)),1,2,'01'))
gpmr=year(dtpmr)
mpmr=month(dtpmr)
ppathr=gcPath_e+'g'+str(gpmr,4)+'\m'+iif(mpmr>9,str(mpmr,2),'0'+str(mpmr,1))+'\'
sele cskl
go top
do while !eof()
   if !(rasc=1.and.ent=gnEnt)
      skip
      loop
   endif
   skr=sk
   pathr=gcPath_d+alltrim(path)
   if !netfile('soper',1)
      sele cskl
      skip
      loop
   endif
   netuse('rs1',,,1)
   netuse('rs3',,,1)
   netuse('pr1',,,1)
   netuse('pr3',,,1)
   netuse('soper',,,1)
   koprp(bsr)
   * Продажи
   crtt(pdebr+'trs22','f:sk c:n(3) f:kpl c:n(7) f:dop c:d(10) f:sdv c:n(12,2) f:prz c:n(1) f:reg c:n(4) f:ttn c:n(6) f:kta c:n(4) f:kop c:n(3) f:sdvm c:n(12,2) f:sdvm1 c:n(12,2) f:sdvm2 c:n(12,2) f:sdvt c:n(12,2) f:vo c:n(2) f:kgp c:n(7) f:ktas c:n(4)')
   sele 0
   use (pdebr+'trs22') excl
   sele rs1
   go top
   do while !eof()
      if empty(dop)
         skip
         loop
      endif
      if kkl_rr#0
         if kpl#kkl_rr
            skip
            loop
         endif
      endif
      kopr=kop
      kop_r=mod(kopr,100)
      vur=1
      vor=vo
      pr361r=0
      pr361r=pr361(0,vur,vor,kop_r)
*      sele koprp
*      locate for d0k1=0.and.vo=vor.and.kop=kopr
      if pr361r=0 // !foun()
         sele rs1
         skip
         loop
      endif
      sele rs1
      kplr=kpl
      kgpr=kgp
      dopr=dop
      sdvr=sdv
      przr=prz
      ttnr=ttn
      ktar=kta
      ktasr=ktas
      if ktasr=0.and.ktar#0
         ktasr=getfield('t1','ktar','s_tag','ktas')
      endif
*if ktasr=0
*wait
*endif
      sdvmr=sdvm
      if fieldpos('sdvm1')#0
         sdvm1r=sdvm1
         sdvm2r=sdvm2
      else
         sdvm1r=0
         sdvm2r=0
      endif
      sdvtr=sdvt
      sele trs22
      appe blank
      repl sk with skr,;
           vo with vor,;
           kop with kopr,;
           kpl with kplr,;
           kgp with kgpr,;
           dop with dopr,;
           sdv with sdvr,;
           prz with przr,;
           ttn with ttnr,;
           kta with ktar,;
           ktas with ktasr,;
           sdvm with sdvmr,;
           sdvm1 with sdvm1r,;
           sdvm2 with sdvm2r,;
           sdvt with sdvtr
      sele rs1
      skip
   endd
   sele trs22
   use
   sele trs2
   appe from (pdebr+'trs22')
   erase (pdebr+'trs22.dbf')
   * Возвраты
   crtt(pdebr+'tpr22','f:sk c:n(3) f:kps c:n(7) f:dpr c:d(10) f:sdv c:n(12,2) f:prz c:n(1) f:reg c:n(4) f:nd c:n(6) f:mn c:n(6) f:kta c:n(4) f:kop c:n(3) f:sdvm c:n(12,2) f:sdvt c:n(12,2) f:vo c:n(2) f:ktas c:n(4)')
   sele 0
   use (pdebr+'tpr22') excl
   sele pr1
   go top
   do while !eof()
      if prz=0
         skip
         loop
      endif
      if kkl_rr#0
         if kps#kkl_rr
            skip
            loop
         endif
      endif
      kopr=kop
      vor=vo
      vur=1
      kop_r=mod(kopr,100)
      pr361r=0
      pr361r=pr361(1,vur,vor,kop_r)
      if pr361r=0
         sele pr1
         skip
         loop
      endif
*      sele koprp
*      locate for d0k1=1.and.vo=vor.and.kop=kopr
*      if !foun()
*         sele pr1
*         skip
*         loop
*      endif
      sele pr1
      kpsr=kps
      dprr=dpr
      sdvr=sdv
      przr=prz
      ndr=nd
      mnr=mn
      ktar=kta
      ktasr=ktas
      if ktasr=0.and.ktar#0
         ktasr=getfield('t1','ktar','s_tag','ktas')
      endif
*if ktasr=0
*wait
*endif
      sdvmr=sdvm
      sdvtr=sdvt
      sele tpr22
      appe blank
      repl sk with skr,;
           vo with vor,;
           kop with kopr,;
           kps with kpsr,;
           dpr with dprr,;
           sdv with sdvr,;
           prz with przr,;
           nd with ndr,;
           mn with mnr,;
           kta with ktar,;
           ktas with ktasr,;
           sdvm with sdvmr,;
           sdvt with sdvtr
      sele pr1
      skip
   endd
   sele tpr22
   use
   sele tpr2
   appe from (pdebr+'tpr22')
   erase (pdebr+'tpr22.dbf')
   sele koprp
   use
   erase koprp.dbf
   nuse('rs1')
   nuse('rs3')
   nuse('pr1')
   nuse('pr3')
   nuse('soper')
   * Предыдущий
   sele cskl
   pathr=ppathr+alltrim(path)
   if !netfile('soper',1)
      sele cskl
      skip
      loop
   endif
   netuse('rs1',,,1)
   netuse('rs3',,,1)
   netuse('pr1',,,1)
   netuse('pr3',,,1)
   netuse('soper',,,1)
   koprp(bsr)
   crtt(pdebr+'trs22','f:sk c:n(3) f:kpl c:n(7) f:dop c:d(10) f:sdv c:n(12,2) f:prz c:n(1) f:reg c:n(4) f:ttn c:n(6) f:kta c:n(4) f:kop c:n(3) f:sdvm c:n(12,2) f:sdvm1 c:n(12,2) f:sdvm2 c:n(12,2) f:sdvt c:n(12,2) f:vo c:n(2) f:kgp c:n(7) f:ktas c:n(4)')
   sele 0
   use (pdebr+'trs22') excl
   sele rs1
   go top
   do while !eof()
      if prz=0
         skip
         loop
      endif
      if kkl_rr#0
         if kpl#kkl_rr
            skip
            loop
         endif
      endif
      kopr=kop
      vor=vo
      vur=1
      kop_r=mod(kopr,100)
      pr361r=0
      pr361r=pr361(0,vur,vor,kop_r)
      if pr361r=0
         sele rs1
         skip
         loop
      endif
 *     sele koprp
 *     locate for d0k1=0.and.vo=vor.and.kop=kopr
 *     if !foun()
 *        sele rs1
 *        skip
 *        loop
 *     endif
      sele rs1
      kplr=kpl
      kgpr=kgp
      dopr=dop
      sdvr=sdv
      przr=prz
      ttnr=ttn
      ktar=kta
      ktasr=ktas
      if ktasr=0.and.ktar#0
         ktasr=getfield('t1','ktar','s_tag','ktas')
      endif
*if ktasr=0
*wait
*endif
      sdvmr=sdvm
      if fieldpos('sdvm1')#0
         sdvm1r=sdvm1
         sdvm2r=sdvm2
      else
         sdvm1r=0
         sdvm2r=0
      endif
      sdvtr=sdvt
      sele trs22
      appe blank
      repl sk with skr,;
           vo with vor,;
           kop with kopr,;
           kpl with kplr,;
           kgp with kgpr,;
           dop with dopr,;
           sdv with sdvr,;
           prz with przr,;
           ttn with ttnr,;
           kta with ktar,;
           ktas with ktasr,;
           sdvm with sdvmr,;
           sdvm1 with sdvm1r,;
           sdvm2 with sdvm2r,;
           sdvt with sdvtr
      sele rs1
      skip
   endd
   sele trs22
   use
   sele trs2
   appe from (pdebr+'trs22')
   erase (pdebr+'trs22.dbf')
   * Возвраты
   crtt(pdebr+'tpr22','f:sk c:n(3) f:kps c:n(7) f:dpr c:d(10) f:sdv c:n(12,2) f:prz c:n(1) f:reg c:n(4) f:nd c:n(6) f:mn c:n(6) f:kta c:n(4) f:kop c:n(3) f:sdvm c:n(12,2) f:sdvt c:n(12,2) f:vo c:n(2) f:ktas c:n(4)')
   sele 0
   use (pdebr+'tpr22') excl
   sele pr1
   go top
   do while !eof()
      if prz=0
         skip
         loop
      endif
      if kkl_rr#0
         if kps#kkl_rr
            skip
            loop
         endif
      endif
      kopr=kop
      vor=vo
      vur=1
      kop_r=mod(kopr,100)
      pr361r=0
      pr361r=pr361(1,vur,vor,kop_r)
      if pr361r=0
         sele pr1
         skip
         loop
      endif
*      sele koprp
*      locate for d0k1=1.and.vo=vor.and.kop=kopr
*      if !foun()
*         sele pr1
*         skip
*         loop
*      endif
      sele pr1
      kpsr=kps
      dprr=dpr
      sdvr=sdv
      przr=prz
      ndr=nd
      mnr=mn
      ktar=kta
      ktasr=ktas
      if ktasr=0.and.ktar#0
         ktasr=getfield('t1','ktar','s_tag','ktas')
      endif
*if ktasr=0
*wait
*endif
      sdvmr=sdvm
      sdvtr=sdvt
      sele tpr22
      appe blank
      repl sk with skr,;
           vo with vor,;
           kop with kopr,;
           kps with kpsr,;
           dpr with dprr,;
           sdv with sdvr,;
           prz with przr,;
           nd with ndr,;
           mn with mnr,;
           kta with ktar,;
           ktas with ktasr,;
           sdvm with sdvmr,;
           sdvt with sdvtr
      sele pr1
      skip
   endd
   sele tpr22
   use
   sele tpr2
   appe from (pdebr+'tpr22')
   erase (pdebr+'tpr22.dbf')
   sele koprp
   use
   erase koprp.dbf
   nuse('rs1')
   nuse('rs3')
   nuse('pr1')
   nuse('pr3')
   nuse('soper')
   sele cskl
   skip
endd
sele trs2
do case
   case bsr=361001
        repl all sdvs with sdvm
   case bsr=361002
        repl all sdvs with sdvt
   other
        repl all sdvs with sdv
endc
inde on str(ktas,4)+str(kpl,7) tag t1
sele tpr2
do case
   case bsr=361001
        repl all sdvs with sdvm
   case bsr=361002
        repl all sdvs with sdvt
   other
        repl all sdvs with sdv
endc
inde on str(ktas,4)+str(kps,7) tag t1

netuse('dkklns')
crtt('tsaldo','f:kkl c:n(7) f:ktas c:n(4) f:saldo c:n(12,2) f:ddb c:d(10)')
sele 0
use tsaldo excl
sele dkklns
go top
do while !eof()
   if bs#bsr
      skip
      loop
   endif
   if kkl_rr#0
      if kkl#kkl_rr
         skip
         loop
      endif
   endif
   kklr=kkl
   ktasr=skl
*if ktasr=0
*wait
*endif
   saldor=dn-kn+db-kr
   ddbr=ddb
   sele tsaldo
   appe blank
   repl kkl with kklr,;
        ktas with ktasr,;
        saldo with saldor,;
        ddb with ddbr
   sele dkklns
   skip
endd
sele tsaldo
inde on str(ktas,4)+str(kkl,7) tag t1
* Кредиторская задолженность
crtt(pdebr+'kz','f:kkl c:n(7) f:ktas c:n(4) f:kz c:n(12,2) f:bs c:n(6)')
sele 0
use (pdebr+'kz') excl
sele dkklns
go top
do while !eof()
   bs_r=bs
   if bs_r=bsr
      skip
      loop
   endif
   kklr=kkl
   if kkl_rr#0
      if kkl#kkl_rr
         skip
         loop
      endif
   endif
   sele tbs
   locate for bs=bs_r
   if !foun()
      sele dkklns
      skip
      loop
   endif
   sele dkklns
   if dn-kn+db-kr>=0
      sele dkklns
      skip
      loop
   endif
   ktasr=skl
*if ktasr=0
*wait
*endif
   kzr=dn-kn+db-kr
   sele kz
   appe blank
   repl kkl with kklr,ktas with ktasr,kz with kzr,bs with bs_r
   sele dkklns
   skip
endd
sele kz
inde on str(ktas,4)+str(kkl,7) tag t1
crtt(pdebr+'dz','f:kkl c:n(7) f:ktas c:n(4) f:dz c:n(12,2) f:ddb c:d(10)')
sele 0
use (pdebr+'dz') excl
inde on str(ktas,4)+str(kkl,7) tag t1
* Дебеторская задолженность
crtt('tprz01','f:kkl c:n(7) f:ktas c:n(4) f:sdv c:n(12,2)')
sele 0
use tprz01 excl
inde on str(ktas,4)+str(kkl,7) tag t1
sele trs2
go top
do while !eof()
   if prz=1
      skip
      loop
   endif
   kklr=kpl
   ktar=kta
   ktasr=ktas
   if ktasr=0.and.ktar#0
      ktasr=getfield('t1','ktar','s_tag','ktas')
   endif
*if ktasr=0
*wait
*endif
   sele tsaldo
   seek str(ktasr,4)+str(kklr,7)
   if !found()
      sele trs2
      skip
      loop
   endif
   sele trs2
   sdvr=sdvs
   sele tprz01
   seek str(ktasr,4)+str(kklr,7)
   if !foun()
      appe blank
      repl kkl with kklr,;
      ktas with ktasr
   endif
   repl sdv with sdv+sdvr
   sele trs2
   skip
endd
crtt(pdebr+'tdop1','f:ndop c:n(4) f:dop c:d(10)')
sele 0
use (pdebr+'tdop1') excl
inde on dtos(dop) tag t1 desc

crtt('tprz02','f:kkl c:n(7) f:ktas c:n(4) f:sdv c:n(12,2) f:dop c:d(10)')
sele 0
use tprz02 excl
inde on str(ktas,4)+str(kkl,7) tag t1
sele trs2
go top
do while !eof()
   dopr=dop
   sele tdop1
   seek dtos(dopr)
   if !foun()
      appe blank
      repl dop with dopr
   endif
   sele trs2
   if prz=1
      skip
      loop
   endif
   kklr=kpl
   ktar=kta
   ktasr=ktas
   sele tsaldo
   seek str(ktasr,4)+str(kklr,7)
   if found()
      sele trs2
      skip
      loop
   endif
   sele trs2
   sdvr=sdvs
   dopr=dop
   sele tprz02
   seek str(ktasr,4)+str(kklr,7)
   if !foun()
      appe blank
      repl kkl with kklr,;
           ktas with ktasr
   endif
   repl sdv with sdv+sdvr
   sele trs2
   skip
endd

sele tsaldo
go top
do while !eof()
   kklr=kkl
   ktasr=ktas
   saldor=saldo
   ddbr=ddb
   sele tprz01
   seek str(ktasr,4)+str(kklr,7)
   if foun()
      saldor=saldor+sdv
   endif
   if .t. //saldor>=ogrr
      sele dz
      appe blank
      repl kkl with kklr,ktas with ktasr,dz with saldor,ddb with ddbr
   endif
   sele tsaldo
   skip
endd

sele tprz02
go top
do while !eof()
   if sdv=0
      skip
      loop
   endif
   kklr=kkl
   ktasr=ktas
   saldor=sdv
   ddbr=dop
   if .t. //saldor>=ogrr
      sele dz
      appe blank
      repl kkl with kklr,ktas with ktasr,dz with saldor,ddb with ddbr
   endif
   sele tprz02
   skip
endd

sele tdop1
locate for dop=date()
if !foun()
   appe blank
   repl dop with date()
   sele trs2
   appe blank
   repl dop with date()
endif

sele tdop1
go bott
mindopr=dop
go top
do while !eof()
   rcnr=recn()
   dopr=dop
   if dopr=mindopr
      exit
   endif
   skip
   if dop#dopr-1
      appe blank
      repl dop with dopr-1
      sele trs2
      appe blank
      repl dop with dopr-1
      sele tdop1
      go rcnr
      skip
      loop
   endif
endd
rccr=recc()
if rccr<40
   sele tdop1
   go bott
   dopr=dop
   for l=rccr+1 to 40
       dopr=dopr-1
       sele tdop1
       appe blank
       repl dop with dopr
       sele trs2
       appe blank
       repl dop with dopr
   next
endif

sele tdop1
ir=recc()

if ir>94
   ir=94
endif

sele tdop1
sort to (pdebr+'tdop') on dop /D
use
sele 0
use (pdebr+'tdop') excl
repl all ndop with recn()
dele all for ndop>94
pack

crtt(pdebr+'trs27','f:kkl c:n(7) f:kta c:n(4) f:dop c:d(10) f:prz c:n(1) f:sdv c:n(12,2) f:ndop c:n(2) f:reg c:n(4) f:ktas c:n(4)')
sele 0
use (pdebr+'trs27') excl
inde on str(kkl,7)+str(kta,4)+dtos(dop) tag t1
sele trs2
go top
do while !eof()
   dopr=dop
   sele tdop
   locate for dop=dopr
   if !foun()
      sele trs2
      skip
      loop
   else
      ndopr=ndop
   endif
   sele trs2
   kklr=kpl
   ktar=kta
   ktasr=ktas
   przr=prz
   sdvr=sdvs
   regr=reg
   sele trs27
   seek str(kklr,7)+str(ktar,4)+dtos(dopr)
   if !foun()
      appe blank
      repl kkl with kklr,;
           kta with ktar,;
           ktas with ktasr,;
           dop with dopr
   endif
   repl sdv with sdv+sdvr,;
        prz with przr,;
        reg with regr,;
        ndop with ndopr
   sele trs2
   skip
endd
sele tdop
copy stru to stemp exte
sele 0
use stemp excl
zap
appe blank
repl field_name with 'kkl',;
     field_type with 'n',;
     field_len with 7,;
     field_dec with 0
appe blank
repl field_name with 'ktas',;
     field_type with 'n',;
     field_len with 4,;
     field_dec with 0
appe blank
repl field_name with 'reg',;
     field_type with 'n',;
     field_len with 4,;
     field_dec with 0
appe blank
repl field_name with 'nkl',;
     field_type with 'c',;
     field_len with 40,;
     field_dec with 0
appe blank
repl field_name with 'nktas',;
     field_type with 'c',;
     field_len with 15,;
     field_dec with 0
appe blank
repl field_name with 'krn',;
     field_type with 'n',;
     field_len with 4,;
     field_dec with 0
appe blank
repl field_name with 'knasp',;
     field_type with 'n',;
     field_len with 4,;
     field_dec with 0
appe blank
repl field_name with 'nrn',;
     field_type with 'c',;
     field_len with 20,;
     field_dec with 0
appe blank
repl field_name with 'pdz',;
     field_type with 'n',;
     field_len with 12,;
     field_dec with 2
appe blank
repl field_name with 'pdz1',;
     field_type with 'n',;
     field_len with 12,;
     field_dec with 2
appe blank
repl field_name with 'pdz3',;
     field_type with 'n',;
     field_len with 12,;
     field_dec with 2
appe blank
repl field_name with 'dz',;
     field_type with 'n',;
     field_len with 12,;
     field_dec with 2
appe blank
repl field_name with 'kz',;
     field_type with 'n',;
     field_len with 12,;
     field_dec with 2
appe blank
repl field_name with 'ddk',;
     field_type with 'd',;
     field_len with 10,;
     field_dec with 0
appe blank
repl field_name with 'ddb',;
     field_type with 'd',;
     field_len with 10,;
     field_dec with 0
appe blank
repl field_name with 'bs_s',;
     field_type with 'n',;
     field_len with 9,;
     field_dec with 2
appe blank
repl field_name with 'bs_d',;
     field_type with 'n',;
     field_len with 3,;
     field_dec with 0
appe blank
repl field_name with 'sprz0',;
     field_type with 'n',;
     field_len with 9,;
     field_dec with 2
sele tdop
go top
do while !eof()
   ndopr=ndop
   csdvr='sdv'+alltrim(str(ndopr,2))
   cdopr='dop'+alltrim(str(ndopr,2))
   sele stemp
   appe blank
   repl field_name with csdvr,;
        field_type with 'n',;
        field_len with 12,;
        field_dec with 2
   appe blank
   repl field_name with cdopr,;
        field_type with 'd',;
        field_len with 10,;
        field_dec with 0
   sele tdop
   skip
endd
sele stemp
use
create (pdebr+'tdeb') from stemp new
use
sele 0
use (pdebr+'tdeb') excl
inde on str(ktas,4)+str(kkl,7) tag t1

sele trs27
go top
do while !eof()
   kklr=kkl
   ktar=kta
   ktasr=ktas
   if ktasr=0.and.ktar#0
      ktasr=getfield('t1','ktar','s_tag','ktas')
   endif
*if ktasr=0
*wait
*endif
   dopr=dop
   regr=reg
   sdvr=sdv
   ndopr=ndop
   csdvr='sdv'+alltrim(str(ndopr,2))
   cdopr='dop'+alltrim(str(ndopr,2))
   sele tdeb
   seek str(ktasr,4)+str(kklr,7)
   if !foun()
      appe blank
      repl kkl with kklr,;
           ktas with ktasr,;
           reg with regr
   endif
   repl &csdvr with sdvr,;
        &cdopr with dopr
   sele trs27
   skip
endd

sele dz
go top
do while !eof()
   kklr=kkl
   ktasr=ktas
   sele tdeb
   seek str(ktasr,4)+str(kklr,7)
   if !foun()
      appe blank
      repl kkl with kklr,;
           ktas with ktasr
   endif
   sele dz
   skip
endd
sele trs27
use

netuse('dokk')
netuse('doks')
crtt(pdebr+'tdokk','f:kkl c:n(7) f:ktas c:n(4) f:ddk c:d(10) f:bs_d c:n(6) f:bs_s c:n(10,2) f:rn c:n(6) f:nplp c:n(6) f:osn c:c(20)')
sele 0
use (pdebr+'tdokk') excl
inde on str(ktas,4)+str(kkl,7) tag t1
sele dokk
go top
do while !eof()
   if prc
      skip
      loop
   endif
   if mn=0
      skip
      loop
   endif
   if kkl_rr#0
      if kkl#kkl_rr
         skip
         loop
      endif
   endif
   if !(int(bs_d/1000)=361.or.int(bs_k/1000)=361)
      skip
      loop
   endif
   kklr=kkl
   mnr=mn
   rndr=rnd
*if mnr=5091.and.rndr=9.and.kklr=2936712
*   wait
*endif
   ktasr=getfield('t1','mnr,rndr,kklr','doks','ktas')
*if ktasr=0
*wait
*endif
   sele tdeb
   seek str(ktasr,4)+str(kklr,7)
   if !foun()
      appe blank
      repl kkl with kklr,;
           ktas with ktasr
   endif
   sele dokk
   ddkr=ddk
   bs_dr=bs_d
   bs_sr=bs_s
   rnr=rn
   nplpr=nplp
   sele tdokk
   appe blank
   repl kkl with kklr,;
        ktas with ktasr,;
        rn with rnr,;
        bs_d with bs_dr,;
        bs_s with bs_sr,;
        nplp with nplpr,;
        ddk with ddkr
   sele dokk
   skip
endd
*sele tdokk
*kklr=0
*scan all
*     if kklr=kkl
*        kklr=kkl
*        dele
*     endif
*ends
*pack

sele tdeb
go top
do while !eof()
   kklr=kkl
   ktasr=ktas
   krnr=krn
   regr=reg
   knaspr=getfield('t1','kklr','kln','knasp')
   nnaspr=getfield('t1','knaspr','knasp','nnasp')
   nkler=getfield('t1','kklr','kln','nkle')
   opfhr=getfield('t1','kklr','kln','opfh')
   nsopfhr=getfield('t1','opfhr','opfh','nsopfh')
   nklr=alltrim(nnaspr)+' '+alltrim(nsopfhr)+' '+alltrim(nkler)
   nklr=upper(nklr)
   pdzr=0
   pdz1r=0
   pdz2r=0
   pdz3r=0
   sele dz
   seek str(ktasr,4)+str(kklr,7)
   if foun()
      pdzr=dz
      pdz1r=dz
      pdz2r=dz
      pdz3r=dz
   endif

   sele dkklns
   locate for kkl=kklr.and.bs=bsr.and.skl=ktasr
   if foun()
      ddbr=ddb
      sele tdeb
      repl ddb with ddbr
   endif
   sele tdeb
   for i=1 to ir
       csdvr='sdv'+alltrim(str(i,3))
       sdvr=&csdvr
       if i<8
          if pdzr>sdvr
             pdzr=pdzr-sdvr
          else
             sdvr=pdzr
             repl &csdvr with sdvr
             pdzr=0
          endif
       endif
       if i<15
          if pdz1r>sdvr
             pdz1r=pdz1r-sdvr
          else
             sdvr=pdz1r
             repl &csdvr with sdvr
             pdz1r=0
          endif
       endif
       if i<22
          if pdz3r>sdvr
             pdz3r=pdz3r-sdvr
          else
             sdvr=pdz3r
             repl &csdvr with sdvr
             pdz3r=0
          endif
       endif
       if pdz2r>sdvr
          pdz2r=pdz2r-sdvr
       else
          sdvr=pdz2r
          repl &csdvr with sdvr
          pdz2r=0
       endif
       if sdvr>100
          sele tdop
          locate for ndop=i
          ddbr=dop
          sele tdeb
          repl ddb with ddbr
       endif
  next
  repl pdz with pdzr,pdz1 with pdz1r,pdz3 with pdz3r
  sele kz
  locate for kkl=kklr.and.ktas=ktasr
  kzr=0
  if foun()
     kzr=abs(kz)
     sele tdeb
     repl kz with kzr
  endif
  sele tprz01
  locate for kkl=kklr.and.ktas=ktasr
  if foun()
     sprz0r=sdv
     sele tdeb
     repl sprz0 with sprz0r
  endif
  sele tprz02
  locate for kkl=kklr.and.ktas=ktasr
  if foun()
     sprz0r=sdv
     sele tdeb
     repl sprz0 with sprz0r
  endif
  sele dz
  seek str(ktasr,4)+str(kklr,7)
  if foun()
     dzr=dz
     sele tdeb
     repl dz with dzr
  endi
  nrnr=''
  sele krn
  locate for krn=krnr
  if foun()
     nrnr=nrn
  endif
  sele tdeb
  repl nrn with nrnr,;
       nkl with nklr
  sele tdokk
  seek str(ktasr,4)+str(kklr,7)
  if foun()
     ddkr=ddk
     bs_sr=bs_s
     bs_dr=int(bs_d/1000)
     sele tdeb
     repl bs_s with bs_sr,ddk with ddkr,bs_d with bs_dr
  endif
  sele tdeb
  skip
endd

sele tdokk
sele tdeb
sort on ktas,nkl to (pdebr+'pdeb') //for dz#0
use
sele 0
use (pdebr+'pdeb') excl
*dele all for dz=0.and.ktas>0.and.ktas<999
dele all for dz=0.and.kz=0
sele tdop
go top
do while !eof()
   cdopr='dop'+alltrim(str(ndop,3))
   dopr=dop
   sele pdeb
   repl all &cdopr with dopr
   sele tdop
   skip
endd
if select('dz')#0
   sele dz
   use
endif
if select('kz')#0
   sele kz
   use
endif
if select('tdop')#0
   sele tdop
   use
endif
if select('trs2')#0
   sele trs2
   use
endif
if select('tpr2')#0
   sele tpr2
   use
endif
if select('tsaldo')#0
   sele tsaldo
   use
endif
if select('tprz01')#0
   sele tprz01
   use
endif
if select('tprz02')#0
   sele tprz02
   use
endif
if select('trs27')#0
   sele trs27
   use
endif
if select('tdeb')#0
   sele tdeb
   use
endif
if select('tdokk')#0
   sele tdokk
   use
endif
sele pdeb
inde on str(ktas,4)+nkl tag t1
repl all reg with 1
use
retu .t.

********************
func showdebs()
********************
netuse('kln')
store 0 to ktas_r
if select('pdeb')#0
   sele pdeb
   use
endif
if select('trs2')#0
   sele trs2
   use
endif
if select('tpr2')#0
   sele tpr2
   use
endif
if select('tdokk')#0
   sele tdokk
   use
endif

sele 0
use (pdebr+'pdeb') share
set orde to tag t1
go top

sele 0
use (pdebr+'trs2') share
set orde to tag t1
go top

sele 0
use (pdebr+'tpr2') share
set orde to tag t1
go top

sele 0
use (pdebr+'tdokk') share
set orde to tag t1
go top

sele pdeb
rcdebr=recn()
fldnomr=1
for_r='.t.'
forr=for_r
store space(20) to ctextr
store 0 to kkl_r,napr
store space(9) to msk_r
do while .t.
   sele pdeb
   go rcdebr
   foot('F3,F4,F5,F6','Фильтр,Отгрузки,Оплата,Возврат')
   rcdebr=slce('pdeb',1,1,18,,"e:ktas h:'S' c:n(4) e:kkl h:'Код' c:n(7) e:nkl h:'Наименование' c:c(25) e:dz h:'ДЗ' c:n(10,2) e:pdz h:'ПДЗ>7' c:n(10,2) e:pdz1 h:'ПДЗ>14' c:n(10,2) e:pdz3 h:'ПДЗ>21' c:n(10,2) e:kz h:'КЗ' c:n(10,2) e:ddk h:'ДПО' c:d(10) e:bs_s h:'СПО' c:n(10,2) e:bs_d h:'Вид' c:n(3)",,,1,,forr,,str(bsr,6),1,2)
   go rcdebr
   kklr=kkl
   ktasr=ktas
   nkplr=getfield('t1','kklr','kln','nkl')
   nkplr=alltrim(nkplr)
   do case
      case lastkey()=K_ESC
           exit
      case lastkey()=19 // Left
           fldnomr=fldnomr-1
           if fldnomr=0
              fldnomr=1
           endif
      case lastkey()=4 // Right
           fldnomr=fldnomr+1
      case lastkey()=K_F3
           debsflt()
      case lastkey()=K_F4 // Отгрузки
           sele trs2
           if netseek('t1','ktasr,kklr')
              fldnom_rr=fldnomr
              fldnomr=1
              rcskdocr=recn()
              do case
                 case bsr=361001
                      rsforr='.t..and.sdvm#0'
                 case bsr=361002
                      rsforr='.t..and.sdvt#0'
                 othe
                      rsforr='.t.'
              endc
              do while .t.
                 go rcskdocr
                 rcskdocr=slce('trs2',,,,,"e:sk h:'SK' c:n(3) e:ttn h:'TTN' c:n(6) e:dop h:'Дата' c:d(10) e:prz h:'П' c:n(1) e:kop h:'КОП' c:n(3) e:sdv h:'Сумма' c:n(10,2) e:sdvm h:'СуммаM' c:n(10,2) e:sdvt h:'СуммаT' c:n(10,2) e:kta  h:'Код' c:n(4) e:getfield('t1','trs2->kta','s_tag','fio') h:'Агент' c:с(15) e:kgp h:'КодП' c:n(7) e:getfield('t1','trs2->kgp','kln','nkl') h:'Получатель' c:c(20)",,,,'ktas=ktasr.and.kpl=kklr',rsforr,,nkplr)
                 go rcskdocr
                 do case
                    case lastkey()=K_ESC
                         exit
                    case lastkey()=19 // Left
                         fldnomr=fldnomr-1
                         if fldnomr=0
                            fldnomr=1
                         endif
                    case lastkey()=4 // Right
                         fldnomr=fldnomr+1
                 endc
              endd
              fldnomr=fldnom_rr
           endif
      case lastkey()=K_F5 // Оплата
           sele tdokk
           if netseek('t1','ktasr,kklr')
              fldnom_rr=fldnomr
              fldnomr=1
              rcbdocr=recn()
              do while .t.
                 go rcbdocr
                 rcbdocr=slce('tdokk',,,,,"e:ddk h:'Дата' c:d(10) e:bs_d h:'Счет' c:n(6) e:bs_s h:'Сумма' c:n(10,2) e:nplp  h:'Поруч' c:n(6) e:osn h:'Основание' c:с(20)",,,,'ktas=ktasr.and.kkl=kklr',,,nkplr)
                 go rcbdocr
                 do case
                    case lastkey()=K_ESC
                         exit
                    case lastkey()=19 // Left
                         fldnomr=fldnomr-1
                         if fldnomr=0
                            fldnomr=1
                         endif
                    case lastkey()=4 // Right
                         fldnomr=fldnomr+1
                 endc
              endd
              fldnomr=fldnom_rr
           endif
      case lastkey()=K_F5 // Возврат
           sele tpr2
           if netseek('t1','ktasr,kklr')
              fldnom_rr=fldnomr
              fldnomr=1
              rcskdocr=recn()
              do case
                 case bsr=361001
                      prforr='.t..and.sdvm#0'
                 case bsr=361002
                      prforr='.t..and.sdvt#0'
                 othe
                      rsforr='.t.'
              endc
              do while .t.
                 go rcskdocr
                 rcskdocr=slce('tpr2',,,,,"e:sk h:'SK' c:n(3) e:nd h:'ND' c:n(6) e:mn h:'MN' c:n(6) e:dpr h:'Дата' c:d(10) e:kop h:'КОП' c:n(3) e:sdv h:'Сумма' c:n(10,2) e:sdvm h:'СуммаM' c:n(10,2) e:sdvt h:'СуммаT' c:n(10,2)",,,,'ktas=ktasr.and.kps=kklr',prforr,,nkplr)
                 go rcskdocr
                 do case
                    case lastkey()=K_ESC
                         exit
                    case lastkey()=19 // Left
                         fldnomr=fldnomr-1
                         if fldnomr=0
                            fldnomr=1
                         endif
                    case lastkey()=4 // Right
                         fldnomr=fldnomr+1
                 endc
              endd
              fldnomr=fldnom_rr
           endif
   endc
endd
retu .t.

func debsflt()
cldeb=setcolor('w/b,n/w')
wdeb=wopen(10,20,14,60)
wbox(1)
store space(20) to ctextr
store 0 to kkl_r,ktas_r
store space(9) to msk_r
do while .t.
   @ 0,1 say 'Контекст   ' get ctextr
   @ 1,1 say 'Супервайзер' get ktas_r pict '9999'
   @ 2,1 say 'Клиент     ' get kkl_r pict '9999999'
   read
   if lastkey()=K_ESC
      forr=for_r
      sele pdeb
      go top
      rcdebr=recn()
      exit
   endif
   if lastkey()=K_ENTER
      forr=for_r
      if !empty(ctextr)
         ctextr=alltrim(ctextr)
         ctextr=upper(ctextr)
         forr=forr+'.and.at(ctextr,nkl)#0'
      endif
      if !empty(kkl_r)
         forr=forr+'.and.kkl=kkl_r'
      endif
      if !empty(ktas_r)
         forr=forr+'.and.ktas=ktas_r'
      endif
      sele pdeb
      go top
      rcdebr=recn()
      exit
   endif
endd
wclose(wdeb)
setcolor(cldeb)
retu .t.
******************************
func kssk(x1, nSvSrc)
  * Контрольная сумма по складу
  ******************************
  LOCAL t1, cSvSrc, nOWS
  DEFAULT x1 to 19

  If !EMPTY(nSvSrc)
    clear
  EndIf

  netuse('pr1')
  netuse('pr3')
  netuse('rs1')
  netuse('rs3')
  netuse('tov')
  crtt('kssk','f:osn c:n(12,2) f:pr c:n(12,2) f:rsp c:n(12,2) f:rspz c:n(12,2)';
  +' f:rso c:n(12,2) f:rsoz c:n(12,2) f:rsv c:n(12,2) f:osf c:n(12,2)';
  +' f:osfo c:n(12,2) f:osv c:n(12,2)';
  +' f:tr_osn c:n(12,2) f:tr_osf c:n(12,2)')
  sele 0
  use kssk
  appe blank
  store 0 to    osnr,    osfr,   osfor,   osvr  ,prr,rspr,rsor,rsvr
  store 0 to tr_osnr, tr_osfr,tr_osfor,tr_osvr

  t1:=SECONDS()
  sele tov
  go top
  nMax:=LASTREC();  Termo((nCurent:=0),nMax,MaxRow(),4)
  do while !eof()

    If int(mntovt/10^4) < 2 // 0 или 1 тара - стекло
      //тара
      tr_osnr  +=  round(osn*opt,2)
      tr_osfr  +=  round(osf*opt,2)
      tr_osfor +=  round(osfo*opt,2)
      tr_osvr  +=  round(osv*opt,2)
    Else
      osnr  +=  round(osn*opt,2)
      osfr  +=  round(osf*opt,2)
      osfor +=  round(osfo*opt,2)
      osvr  +=  round(osv*opt,2)
    EndIf
    skip
    Termo((++nCurent),nMax,MaxRow(),4)
  enddo
     Termo(nMax,nMax,MaxRow(),4)

  p19r:=p18r:=p12r:=p96r:=0
  sele pr1
  nMax:=LASTREC();  Termo((nCurent:=0),nMax,MaxRow(),4)
  go top
  do while !eof()
     Termo((++nCurent),nMax,MaxRow(),4)
     if prz=0
        skip
        loop
     endif
     prr=prr+sdv
     p96r+=getfield('t1','pr1->mn,10','pr3','ssf')
     p19r+=getfield('t1','pr1->mn,19','pr3','ssf')
     p18r+=getfield('t1','pr1->mn,18','pr3','ssf')
     p12r+=getfield('t1','pr1->mn,12','pr3','ssf')
     skip
  enddo
     Termo(nMax,nMax,MaxRow(),4)

  r19r:=r18r:=r12r:=r96r:=0
  sele rs1
  nMax:=LASTREC();  Termo((nCurent:=0),nMax,MaxRow(),4)
  go top
  do while !eof()
     Termo((++nCurent),nMax,MaxRow(),4)
     do case
        case prz=1

          r19r+=getfield('t1','rs1->ttn,19','rs3','ssf') // тара
          r18r+=getfield('t1','rs1->ttn,18','rs3','ssf') // стелотра
          r12r+=getfield('t1','rs1->ttn,12','rs3','ssf') // не возратная тара

          r96r+=getfield('t1','rs1->ttn,96','rs3','ssf')
          rspr=rspr+sdv
        case prz=0.and.!empty(dop)
             rsor=rsor+sdv
        case prz=0.and.empty(dop)
             rsvr=rsvr+sdv
     endcase
     skip
  enddo
     Termo(nMax,nMax,MaxRow(),4)

  sele kssk
  repl osn with osnr,;
       pr with prr,;
       rsp with rspr,;
       rso with rsor,;
       rsv with rsvr,;
       osf with osfr,;
       osfo with osfor,;
       osv with osvr,;
       tr_osn with tr_osnr,;
       tr_osf with tr_osfr

  clkssk=setcolor('w/b,n/w')
  nOWS:=wselect()
  wkssk=wopen(1,20-x1,1+15+2,60-x1)
  wbox(1)
  @  0,1 say 'Ост на нач'+' '+str(osn,12,2)
  @  1,1 say '  Приход  '+' '+str(p96r,12,2)
  @  2,1 say '  Расх    '+' '+str(r96r,12,2)
  @  3,1 say 'Ост факт  '+' '+str(osf,12,2) +' ('+str(osn+p96r-r96r-osf,8,2)+')'
  @  4,1 say 'Приход под'+' '+str(pr,12,2)
  @  5,1 say 'Расх под  '+' '+str(rsp,12,2)
  @  6,1 say 'Расх отгр.'+' '+str(rso,12,2)
  @  7,1 say 'Расх вып. '+' '+str(rsv,12,2)
  @  8,1 say 'Ост отгр. '+' '+str(osfo,12,2) //+' '+str(osn+pr-rso-osfo,12,2)
  @  9,1 say 'Ост вып.  '+' '+str(osv,12,2)  //+' '+str(osn+pr-rsv-osv,12,2)
  @ 10,1 say '===Тара==='
  @ 11,1 say 'Ост на нач'+' '+str(tr_osn,12,2)
  @ 12,1 say '  Приход  '+' '+str(p19r+p18r+p12r,12,2)
  @ 13,1 say '  Расх    '+' '+str(r19r+r18r+r12r,12,2)
  @ 14,1 say 'Ост факт  '+' '+str(tr_osf,12,2) +' ('+str(tr_osn+(p19r+p18r+p12r)-(r19r+r18r+r12r)-tr_osf,8,2)+')'
  @ 15,1 say 'Период.  '+' '+STR(YEAR(gdTd))+' '+CMONTH(gdTd)+' ('+STR(SECONDS()-t1,6,2)+')'

  If EMPTY(nSvSrc)
    inkey(0)
    wclose(wkssk)
    wselect(nOWS)
    setcolor(clkssk)
  else
    wselect(nOWS)
    cSvSrc:=SAVESCREEN(6,20-x1,19,60-x1)
    wclose(wkssk)
    setcolor(clkssk)
    RESTSCREEN(6,20-x1,19,60-x1,cSvSrc)
  EndIf
  nuse()
  sele kssk
  use
  retu .t.
