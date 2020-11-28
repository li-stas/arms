#include "common.ch"
#include "inkey.ch"
func chkotgr()
  //Контроль отгрузки
clea
cchkr='chk'+str(gnSk,3)
if file(cchkr+'.dbf')
   adirect=directory(cchkr+'.dbf')
   dtcr=adirect[1,3]
   tmcr=adirect[1,4]
   aobn={'ДА ','НЕТ'}
   aobnr=alert(dtoc(dtcr)+' Обновить?',aobn)
   if lastkey()=K_ESC
      retu
   endif
else
   aobnr=1
endif
if aobnr=1
   kmonr=3
   ddc_r=bom(addmonth(gdTd,-kmonr+1))
   mess('Ждите...')
   netuse('rs1')
   erase (cchkr+'.dbf')
   erase (cchkr+'.cdx')
   crtt(cchkr,'f:ttn c:n(6) f:ddc c:d(10) f:prz c:n(1) f:kop c:n(3) f:dtotgr c:d(10) f:smotgr c:n(12,2) f:dttek c:d(10) f:smtek c:n(12,2)')
   sele 0
   use (cchkr) alias chkotgr excl
   inde on str(ttn,6) tag t1
   sele rs1
   go top
   do while !eof()
      if !(vo=9.or.vo=6)
         skip
         loop
      endif
      if ddc<ddc_r
         skip
         loop
      endif
      ttnr=ttn
      kopr=kop
      przr=prz
      dttekr=dop
      smtekr=sdv
      ddcr=ddc
      sele chkotgr
      netadd()
      netrepl('ttn,ddc,prz,kop,dttek,smtek','ttnr,ddcr,przr,kopr,dttekr,smtekr')
      sele rs1
      skip
   endd
   for krsor=kmonr to 1 step -1
       kmon_r=kmonr-krsor
       dtr=addmonth(gdTd,-kmon_r)
       yy_r=year(dtr)
       mm_r=month(dtr)
       pathr=gcPath_e+'g'+str(yy_r,4)+'\m'+iif(mm_r<10,'0'+str(mm_r,1),str(mm_r,2))+'\'+gcDir_t
       mess(pathr)
       netuse('rso1',,,1)
       set orde to tag t2
       sele chkotgr
       go top
       do while !eof()
          if !empty(dtotgr)
             skip
             loop
          endif
          ttnr=ttn
          sele rso1
          if netseek('t2','ttnr')
             do while ttn=ttnr
                if prNpp=7
                   dtotgrr=dNpp
                   smotgrr=sdv
                   sele chkotgr
                   netrepl('dtotgr,smotgr','dtotgrr,smotgrr')
                   sele rso1
                   exit
                endif
                sele rso1
                skip
              endd
          endif
          sele chkotgr
          skip
       endd
       nuse('rso1')
   next
   clea
else
   sele 0
   use (cchkr) alias chkotgr excl
endif
sele chkotgr
go top
rcchkr=recn()
forr='smotgr#smtek.and.(!empty(dtotgr).or.!empty(dttek))'
do while .t.
   sele chkotgr
   go rcchkr
   foot('F3','Фильтр')
   rcchkr=slcf('chkotgr',1,1,18,,"e:ttn h:'ТТН' c:n(6) e:prz h:'П' c:n(1) e:kop h:'КОП' c:n(3) e:ddc h:'Создан' c:d(10) e:dtotgr h:'Отгружен' c:d(10) e:smotgr h:'СуммаО' c:n(10,2) e:dttek h:'ОтгруженТ' c:d(10) e:smtek h:'СуммаОТ' c:n(10,2)",,,,,forr,,'Измененные документы')
   if lastkey()=K_ESC
      exit
   endif
endd
nuse('chkotgr')
nuse()
retu .t.
****************
func chkzvkpk()
****************
clea
netuse('rs1')
netuse('rs2m')
netuse('s_tag')
netuse('rs1kpk')
netuse('rs2kpk')
netuse('ctov')
crtt('chkzvkpk','f:ttn c:n(6) f:mntov c:n(7) f:nat c:c(40) f:kvp c:n(10,3) f:kvpo c:n(10,3) f:ddc c:d(10) f:ktas c:n(4) f:kta c:n(4) f:dop c:d(10) f:lit c:n(10,3) f:lito c:n(10,3) f:kvpt c:n(10,3) f:litt c:n(10,3) f:keip c:n(4) f:vesp c:n(10,3)')
sele 0
use chkzvkpk
sele rs1kpk
go top
do while !eof()
   ttnr=ttn
   skpkr=skpk
   ddcr=ddc
   ktasr=ktas
   ktar=kta
   if ktasr=0.and.ktar#0
      ktasr=getfield('t1','ktar','s_tag','ktas')
   endif
   dopr=getfield('t1','ttnr','rs1','dop')
   sele rs2kpk
   if netseek('t1','ttnr,skpkr')
      do while skpk=skpkr.and.ttn=ttnr
         if kvp#kvpo
            mntovr=mntov
            kvpr=kvp
            kvptr=getfield('t1','ttnr,mntovr','rs2m','kvp')
            kvpor=kvpo
            sele ctov
            store 0 to litr,litor,littr,keipr,vespr
            if netseek('t1','mntovr')
               keipr=keip
               vespr=vesp
               if keipr=800.or.keipr=166.or.keipr=163
                  litr=kvpr*vesp
                  littr=kvptr*vesp
                  litor=kvpor*vesp
               endif
            endif
            natr=getfield('t1','mntovr','ctov','nat')
            sele chkzvkpk
            netadd()
            netrepl('ttn,mntov,kvp,kvpo,ddc,ktas,kta,dop,lit,lito,litt,keip,vesp,nat','ttnr,mntovr,kvpr,kvpor,ddcr,ktasr,ktar,dopr,litr,litor,littr,keipr,vespr,natr')
         endif
         sele rs2kpk
         skip
      endd
   endif
   sele rs1kpk
   skip
endd
nuse('rs1kpk')
nuse('rs2kpk')
sele chkzvkpk
go top
rcchkr=recn()
for_r='.t.'
forr=for_r
fldnomr=1
do while .t.
   go rcchkr
   foot('F3,F5','Фильтр,Печать')
   rcchkr=slce('chkzvkpk',1,1,18,,"e:ttn h:'ТТН' c:n(6) e:mntov h:'Код' c:n(7) e:getfield('t1','chkzvkpk->mntov','ctov','nat') h:'Наименование' c:c(40) e:kvp h:'Заявка' c:n(10,3) e:kvpo h:'Выписано' c:n(10,3) e:kvpt h:'Текущее' c:n(10,3) e:dop h:'ДТО' c:d(10) e:lit h:'ЗвЛ' c:n(10,3) e:lito h:'ВыпЛ' c:n(10,3) e:litt h:'ТекЛ' c:n(10,3) e:ddc h:'ДтЗ' c:d(10)",,,,,forr,,'Контроль заявок')
   if lastkey()=K_ESC
      exit
   endif
   do case
      case lastkey()=19 // Left
           fldnomr=fldnomr-1
           if fldnomr=0
              fldnomr=1
           endif
      case lastkey()=4 // Right
           fldnomr=fldnomr+1
      case lastkey()=K_F3
           store gdTd to dt2r
           store 0 to ktasr,ktar,protgr,nosovr
           dt1r=dt2r-1
           if month(dt1r)#month(dt2r)
              dt1r=dt2r
           endif
           clzvr=setcolor('gr+/b,n/bg')
           wzvr=wopen(10,10,15,70)
           wbox(1)
           @ 0,1 say 'Созданы    ' get dt1r
           @ 0,col()+1 get dt2r
           @ 1,1 say 'Супервайзер' get ktasr pict '9999'
           @ 2,1 say 'Агент      ' get ktar  pict '9999'
           @ 3,1 say 'Отгруженные' get protgr  pict '9'
           read
           wclose(wzvr)
           setcolor(clzvr)
           if lastkey()=K_ESC
              forr=for_r
              store ctod('') to dt1r,dt2r
              sele chkzvkpk
               go top
              rcchkr=recn()
              loop
           endif
           forr=for_r+'.and.ddc>=dt1r.and.ddc<=dt2r'
           if ktasr#0
              forr=forr+'.and.ktas=ktasr'
           endif
           if ktar#0
              forr=forr+'.and.kta=ktar'
           endif
           if protgr#0
              forr=forr+'.and.!empty(dop)'
           endif
           sele chkzvkpk
           go top
           rcchkr=recn()
      case lastkey()=K_F5
           chkzvprn()
   endc
endd
nuse('ctov')
sele chkzvkpk
use
nuse()
retu .t.

func chkzvprn()
vlpt=0
alpt={'lpt1','lpt2','lpt3','Файл'}
vlpt=alert('ПЕЧАТЬ',alpt)
if lastkey()=K_ESC
   retu
endif
set cons off
do case
   case vlpt=1
        set prin to lpt1
   case vlpt=2
        set prin to lpt2
   case vlpt=3
        set prin to lpt3
   case vlpt=4
        set prin to chkzv.txt
endc
set prin on
if vlpt=1
   if empty(gcPrn)
      ??chr(27)+chr(80)+chr(15)
   else
      ??chr(27)+'E'+chr(27)+'&l4h25a0O'+chr(27)+'&k2S'+chr(27)+'(3R'+chr(27)+'(s0p18.00h0s1b4102T'+chr(27)
   endif
else
   ??chr(27)+'E'+chr(27)+'&l4h25a0O'+chr(27)+'&k2S'+chr(27)+'(3R'+chr(27)+'(s0p18.00h0s1b4102T'+chr(27)
endif
?'Контроль заявок'
?gcNskl+' '+dtoc(date())+' '+time()+' '+dtoc(gdTd)
if !empty(dt1r)
   ?'Период с '+dtoc(dt1r)+' по '+dtoc(dt2r)
endif
?'┌──────┬──────────┬───────┬──────────────────────────────┬──────────┬──────────┐'
?'│  ТТН │  Создан  │  Код  │         Наименование         │ Заявка   │ Документ │'
?'├──────┼──────────┼───────┼──────────────────────────────┼──────────┼──────────┤'
sele chkzvkpk
go top
store 0 to kvpir,kvpoir
store 0 to litir,litoir
do while !eof()
   if forr=='.t.'
   else
      if !&(forr)
         skip
         loop
      endif
   endif
   mntovr=mntov
   ddcr=ddc
   ttnr=ttn
   kvpr=kvp
   kvpor=kvpo
   litr=lit
   litor=lito
   kvpir=kvpir+kvpr
   kvpoir=kvpoir+kvpor
   litir=litir+litr
   litoir=litoir+litor
   natr=getfield('t1','mntovr','ctov','nat')
   natr=subs(natr,1,30)
   ?'│'+str(ttn,6)+'│'+dtoc(ddc)+'│'+str(mntov,7)+'│'+natr+'│'+str(kvpr,10,3)+'│'+str(kvpor,10,3)+'│'
   sele chkzvkpk
   skip
endd
?'Итого в литрах'+space(42)+' '+str(litir,12,3)+' '+str(litoir,12,3)

?'Процент выполнения шт'+str(kvpoir*100/kvpir,6,2)
?'Процент выполнения  л'+str(litoir*100/litir,6,2)
set prin off
set prin to
set cons on
retu .t.

***************
func ostday()
***************
clea
dt1r=gdTd
prdtotr=0
clodr=setcolor('gr+/b,n/bg')
wodr=wopen(10,20,13,60)
wbox(1)
@ 0,1 say 'Дата' get dt1r
@ 1,1 say 'DTOT' get prdtotr pict '9'
read
wclose(wodr)
setcolor(clodr)
if lastkey()=K_ESC
   retu .t.
endif
if dt1r<bom(gdTd).or.dt1r>gdTd
   wmess('Неверная дата',2)
   retu .t.
endif
netuse('rs1')
netuse('rs2')
netuse('pr1')
netuse('pr2')
netuse('tov')
netuse('sgrp')
dtpr=addmonth(gdTd,-1)
pathpr=gcPath_e+'g'+str(year(dtpr),4)+'\m'+iif(month(dtpr)<10,'0'+str(month(dtpr),1),str(month(dtpr),2))+'\'+gcDir_t
pathr=pathpr
*netuse('tov','tovp')
crtt('ostday','f:kg c:n(3) f:mntov c:n(7) f:nat c:c(40) f:osn c:n(12,2) f:pr c:n(12,2) f:rs c:n(12,2) f:prd c:n(12,2) f:rsd c:n(12,2) f:osfo c:n(12,2) f:upak c:n(10,2) f:nei c:c(5) f:vesp c:n(12,2)')
sele 0
use ostday excl
inde on str(mntov,7) tag t1
inde on str(kg,3)+nat tag t2
set orde to tag t1

sele tov
go top
do while !eof()
   mntovr=mntov
   natr=nat
   osnr=osn
   upakr=upak
   vespr=vesp
   neir=nei
   sele ostday
   seek str(mntovr,7)
   if !found()
      appe blank
      repl mntov with mntovr,;
           nat with natr,;
           nei with neir,;
           upak with upakr,;
           vesp with vespr,;
           kg with int(mntovr/10000)
   endif
   repl osn with osn+osnr
   sele tov
   skip
endd

sele pr1
go top
do while !eof()
   if prz=0
      skip
      loop
   endif
   if dpr>dt1r
      skip
      loop
   endif
   sklr=skl
   mnr=mn
   dprr=dpr
   sele pr2
   if netseek('t1','mnr')
      do while mn=mnr
         mntovr=mntov
         ktlr=ktl
         kfr=kf
         sele ostday
         seek str(mntovr,7)
         if !foun()
            sele tov
            if netseek('t1','sklr,ktlr')
               natr=nat
               upakr=upak
               vespr=vesp
               neir=nei
               sele ostday
               appe blank
               repl mntov with mntovr,;
                    nat with natr,;
                    nei with neir,;
                    upak with upakr,;
                    vesp with vespr
            endif
         endif
         if dprr=dt1r
            repl prd with prd+kfr
         else
            repl pr with pr+kfr
         endif
         sele pr2
         skip
      endd
   endif
   sele pr1
   skip
endd

sele rs1
go top
do while !eof()
   if empty(dop)
      skip
      loop
   endif
   dopr=dop
   dtotr=dtot
   if empty(dtotr)
      dtotr=dopr
   endif
   if prdtotr=0
      if dopr>dt1r
         skip
         loop
      endif
   else
      if dtotr>dt1r
         skip
         loop
      endif
   endif
   sklr=skl
   ttnr=ttn
  //  dopr=dop
  //  dtotr=dtot
   ddcr=ddc
   sele rs2
   if netseek('t1','ttnr')
      do while ttn=ttnr
         mntovr=mntov
         ktlr=ktl
         kvpr=kvp
         sele ostday
         seek str(mntovr,7)
         if prdtotr=0
            if dopr=dt1r
               repl rsd with rsd+kvpr
            else
               repl rs with rs+kvpr
            endif
         else
            if dtotr=dt1r
               repl rsd with rsd+kvpr
            else
               repl rs with rs+kvpr
            endif
         endif
         sele rs2
         skip
      endd
   endif
   sele rs1
   skip
endd
*nuse('tovp')
sele ostday
set orde to tag t2
go top
rcodr=recn()
forr='.t.'
prupakr=0
do while .t.
   sele ostday
   go rcodr
   do case
      case prupakr=0
           foot('F5,F8,F9,F10','Упак,Группа,Приход,Расход')
           rcodr=slcf('ostday',1,1,18,,"e:mntov h:'Код' c:n(7) e:nat h:'Наименование' c:c(20) e:osn+pr-rs h:'ОстНД' c:n(11,2) e:prd h:'Приход' c:n(11,2) e:rsd h:'Расход' c:n(11,2) e:osn+pr-rs+prd-rsd h:'Остаток' c:n(11,2)",,,1,,forr,,'Ост в уч ед изм с уч отгр на '+dtoc(dt1r))
      case prupakr=1
           foot('F5,F8,F9,F10','Дал,Группа,Приход,Расход')
           rcodr=slcf('ostday',1,1,18,,"e:mntov h:'Код' c:n(7) e:nat h:'Наименование' c:c(20) e:(osn+pr-rs)/upak h:'ОстНД' c:n(11,2) e:prd/upak h:'Приход' c:n(11,2) e:rsd/upak h:'Расход' c:n(11,2) e:(osn+pr-rs+prd-rsd)/upak h:'Остаток' c:n(11,2)",,,1,,forr,,'Ост в упак с уч отгр на '+dtoc(dt1r))
      case prupakr=2
           foot('F5,F8,F9,F10','Уч,Группа,Приход,Расход')
           rcodr=slcf('ostday',1,1,18,,"e:mntov h:'Код' c:n(7) e:nat h:'Наименование' c:c(20) e:(osn+pr-rs)*vesp/10 h:'ОстНД' c:n(11,2) e:prd*vesp/10 h:'Приход' c:n(11,2) e:rsd*vesp/10 h:'Расход' c:n(11,2) e:(osn+pr-rs+prd-rsd)*vesp/10 h:'Остаток' c:n(11,2)",,,1,,forr,,'Ост в дал с уч отгр на '+dtoc(dt1r))
   endc
   if lastkey()=K_ESC
      exit
   endif
   sele ostday
   go rcodr
   mntovr=mntov
   kgr=kg
   natr=nat
   do case
      case lastkey()=K_F5
           do case
              case prupakr=0
                   prupakr=1
              case prupakr=1
                   prupakr=2
              case prupakr=2
                   prupakr=0
           endc
      case lastkey()=K_F8
           sele sgrp
           set order to tag t2
           go top
           forgr=".t..and.netseek('t2','sgrp->kgr','ostday')"
           rcn_gr=recn()
           do while .t.
              sele sgrp
              set order to tag t2
              rcn_gr=recno()
              kg_r=slcf('sgrp',,,,,"e:kgr h:'Код' c:n(3) e:ngr h:'Наименование' c:c(20)",'kgr',,,,forgr)
              do case
                 case lastkey()=K_ENTER
                      sele ostday
                      if !netseek('t2','kg_r')
                         go rcodr
                      else
                         rcodr=recn()
                      endif
                      exit
                 case lastkey()=K_ESC
                      sele ostday
                      if !netseek('t2','kg_r')
                         go rcodr
                      else
                         rcodr=recn()
                      endif
                      forr='.t.'
                      exit
                 case lastkey()>32.and.lastkey()<255
                      sele sgrp
                      lstkr=upper(chr(lastkey()))
                      if !netseek('t2','lstkr')
                         go rcn_gr
                      endif
                      loop
                 othe
                      loop
              endc
           enddo
      case lastkey()=K_F9 // Приход
           tov_r='ostday'
           pr1d()
      case lastkey()=K_F10 // Расход
           tov_r='ostday'
           rs1d()
   endc
endd
nuse()
nuse('ostday')
retu .t.

**************
func pr1d()
**************
  //Просмотр прихода по коду
save scre to scpr1ktl
ss=select()
store 0 to prpr1r,prpr2r
@ 0,1 say str(ktlr,9)+' '+natr
sele pr1
rpr1r=recn()
opr1r=indexord()
set orde to tag t2
sele pr2
rpr2r=recn()
opr2r=indexord()
nazvr=str(mntovr,7)+' '+alltrim(natr)
set orde to tag t4
go top
netseek('t4','mntovr')
pr1dforr="getfield('t2','pr2->mn','pr1','dpr')<=dt1r"
set cent off
mn_r=slcf('pr2',,,,,"e:getfield('t2','pr2->mn','pr1','nd') h:'N док.' c:n(6) e:mn h:'Маш.N' c:n(6) e:getfield('t2','pr2->mn','pr1','kop') h:'КОП' c:n(3) e:getfield('t2','pr2->mn','pr1','nnz') h:'Договор' c:c(6) e:iif(getfield('t2','pr2->mn','pr1','prz')=0,getfield('t2','pr2->mn','pr1','dvp'),getfield('t2','pr2->mn','pr1','dpr')) h:'Дата'  c:d(8) e:getfield('t2','pr2->mn','pr1','prz') h:'П' c:n(1) e:kf h:'Количество' c:n(10,3) e:zen h:'Цена' c:n(9,3) e:sf h:'Сумма' c:n(10,2) e:getfield('t2','pr2->mn','pr1','kps') h:'Поставщ' c:n(7)",'mn',,,'mntov=mntovr',pr1dforr,,nazvr)
set cent on
sele pr1
go rpr1r
set orde to (opr1r)
sele pr2
go rpr2r
set orde to (opr2r)
sele (ss)
rest scre from scpr1ktl
retu .t.
**************
func rs1d()
**************
  //Просмотр расхода по коду
save scre to scpr1ktl
ss=select()
store 0 to prrs1r,prrs2r,prklnr
if select('kln')=0
   netuse('kln')
   prklnr=1
endif
@ 0,1 say str(mntovr,7)+' '+natr
sele rs1
rpr1r=recn()
opr1r=indexord()
set orde to tag t2
sele rs2
rpr2r=recn()
opr2r=indexord()
nazvr=str(mntovr,7)+' '+alltrim(natr)
if prdtotr=0
   rs1dforr="getfield('t1','rs2->ttn','rs1','dop')<=dt1r.and.getfield('t1','rs2->ttn','rs1','dop')#ctod('')"
else
   rs1dforr="getfield('t1','rs2->ttn','rs1','dtot')<=dt1r.and.getfield('t1','rs2->ttn','rs1','dtot')#ctod('')"
endif
set orde to tag t4
go top
netseek('t4','mntovr')
rcrs2_r=recn()
prtekdr=0
do while .t.
   sele rs2
   go rcrs2_r
   foot('F5','За тек день')
   set cent off
   rsrs2_r=slcf('rs2',,,,,"e:ttn h:'N ТТН ' c:n(6) e:getfield('t1','rs2->ttn','rs1','kop') h:'КОП' c:n(3) e:getfield('t1','rs2->ttn','rs1','dop') h:'Дата O'  c:d(8) e:getfield('t1','rs2->ttn','rs1','dtot') h:'Дата OR'  c:d(8) e:getfield('t1','rs2->ttn','rs1','ddc') h:'Дата С'  c:d(8) e:getfield('t1','rs2->ttn','rs1','prz') h:'П' c:n(1) e:kvp h:'Количество' c:n(8,3) e:zen h:'Цена' c:n(7,3) e:svp h:'Сумма' c:n(9,2) e:getfield('t1','rs2->ttn','rs1','kta') h:'Аг' c:n(4) e:getfield('t1','rs2->ttn','rs1','docguid') h:'DOCGUID' c:с(10) e:getfield('t1','rs2->ttn','rs1','rmsk') h:'R' c:n(1)",,,,'mntov=mntovr',rs1dforr,,nazvr)
   set cent on
   if lastkey()=K_ESC
      exit
   endif
   if lastkey()=K_F5
      if prtekdr=0
         prtekdr=1
         if prdtotr=0
            rs1dforr="getfield('t1','rs2->ttn','rs1','dop')=dt1r"
         else
            rs1dforr="getfield('t1','rs2->ttn','rs1','dtot')=dt1r"
         endif
      else
         prtekdr=0
         if prdtotr=0
            rs1dforr="getfield('t1','rs2->ttn','rs1','dop')<=dt1r.and.getfield('t1','rs2->ttn','rs1','dop')#ctod('')"
         else
            rs1dforr="getfield('t1','rs2->ttn','rs1','dtot')<=dt1r.and.getfield('t1','rs2->ttn','rs1','dtot')#ctod('')"
         endif
      endif
      sele rs2
      netseek('t4','mntovr')
      rcrs2_r=recn()
   endif
endd
sele rs1
go rpr1r
set orde to (opr1r)
sele rs2
go rpr2r
set orde to (opr2r)
if prklnr=1
   nuse('kln')
endif
sele (ss)
rest scre from scpr1ktl
retu .t.
**************
func zvkpk()
**************
clea
netuse('rs1kpk')
netuse('rs2kpk')
netuse('ctov')
*#ifndef __CLIP__
 crtt('tttn','f:ttn c:n(6) f:skpk c:n(10)')
 sele 0
 use tttn excl
 inde on str(ttn,6) tag t1
 sele rs2kpk
 go top
 do while !eof()
    ttn_r=ttn
    skpk_r=skpk
    if kvp#kvpo
       sele tttn
       seek str(ttn_r,6)
       if !foun()
          appe blank
          repl ttn with ttn_r,;
               skpk with skpk_r
       endif
    endif
    sele rs2kpk
    skip
    if eof()
       exit
    endif
 endd
*#endif
sele rs1kpk
coun to kolzvr
ddc_r=gdTd
kta_r=0
sb_r=0
forkpkr='.t.'
forkpk_r='.t.'
go top
rcrs1kpkr=recn()
fldnomr=1
do while .t.
   sele rs1kpk
   go rcrs1kpkr
   set cent off
   foot('F3','Фильтр')
   rcrs1kpkr=slce('rs1kpk',1,1,18,,"e:ttn h:'ТТН' c:n(6) e:ddc h:'ДатаС' c:d(8) e:tdc h:'ВрС' c:c(8) e:kop h:'КОП' c:n(3) e:kpl h:'КодПлат' c:n(7) e:kpl h:'КодПолу' c:n(7) e:kta h:'КодА' c:n(4) e:docguid h:'ДокКПК' c:c(36) e:timecrt h:'ВремяКПК' c:c(19) e:timecrtfrm h:'ВремяКПК форм' c:c(19) e:skpk h:'N сеанса' c:n(10) e:nnz h:'N в сеан' c:c(9) e:ser h:'SER' c:c(5)",,,,,forkpkr,,'Заявки '+str(kolzvr,10),1,1)
   set cent on
   if lastkey()=K_ESC
      exit
   endif
   sele rs1kpk
   go rcrs1kpkr
   ttnr=ttn
   docguidr=alltrim(docguid)
   do case
      case lastkey()=19 // Left
           fldnomr=fldnomr-1
           if fldnomr=0
              fldnomr=1
           endif
      case lastkey()=4 // Right
           fldnomr=fldnomr+1
      case lastkey()=K_F3 // Фильтр
           ddc_r=gdTd
           clkpkr=setcolor('gr+/b,n/bg')
           wkpkr=wopen(10,10,15,70)
           wbox(1)
           @ 0,1 say 'Дата ' get ddc_r
           @ 1,1 say 'Агент' get kta_r pict '9999'
           @ 2,1 say 'Сбойные' get sb_r pict '9'
           read
           wclose(wkpkr)
           setcolor(clkpkr)
           if lastkey()=K_ESC
              forkpkr=forkpk_r
           endif
           if lastkey()=K_ENTER
              forkpkr=forkpk_r
              if !empty(ddc_r)
                 forkpkr=forkpkr+'.and.ddc=ddc_r'
              endif
              if kta_r#0
                 forkpkr=forkpkr+'.and.kta=kta_r'
              endif
              if sb_r#0
                 forkpkr=forkpkr+".and.netseek('t1','rs1kpk->ttn','tttn')"
              endif
           endif
           sele rs1kpk
           go top
           coun to kolzvr for &forkpkr
           go top
           rcrs1kpkr=recn()
      case lastkey()=K_ENTER // Состав
           zvkpks()
   endc
endd
nuse()
nuse('tttn')
*erase tttn.dbf
*erase tttn.cdx
retu .t.
******************
func zvkpks()
******************
sele rs2kpk
if netseek('t1','ttnr')
   rcrs2kpkr=recn()
   do while ttn=ttnr
      sele rs2kpk
      go rcrs2kpkr
      set cent off
      foot('','')
      rcrs2kpkr=slcf('rs2kpk',1,1,18,,"e:mntov h:'Код' c:n(7) e:getfield('t1','rs2kpk->mntov','ctov','mkeep') h:'TM' c:n(3) e:getfield('t1','rs2kpk->mntov','ctov','nat') h:'Товар' c:c(36) e:kvp h:'Заявлено' c:n(9,3) e:kvpo h:'Выписано' c:n(9,3) e:kvp-kvpo h:'Разница' c:n(9,3)",,,,'ttn=ttnr',,,'ТТН '+str(ttnr,6)+' '+docguidr)
      set cent on
      if lastkey()=K_ESC
         exit
      endif
      sele rs2kpk
      go rcrs2kpkr
   endd
endif
retu .t.

**************
func sbzvkpk()
**************
clea
netuse('rs1')
netuse('rs2')
netuse('rs1kpk')
netuse('rs2kpk')
netuse('ctov')
sele rs1
ddc_r=gdTd
kta_r=0
forkpk_r="rs1->kop#170.and.bom(rs1->ddc)=bom(gdTd).and.!empty(rs1->docguid).and.!netseek('t1','rs1->ttn','rs1kpk')"
forkpkr=forkpk_r
go top
rcrs1r=recn()
fldnomr=1
do while .t.
   sele rs1
   go rcrs1r
   set cent off
   foot('F3','Фильтр')
   rcrs1r=slce('rs1',1,1,18,,"e:ttn h:'ТТН' c:n(6) e:ddc h:'ДатаС' c:d(8) e:tdc h:'ВрС' c:c(8) e:kop h:'КОП' c:n(3) e:kpl h:'КодПлат' c:n(7) e:kpl h:'КодПолу' c:n(7) e:kta h:'КодА' c:n(4) e:docguid h:'ДокКПК' c:c(36) e:timecrt h:'ВремяКПК' c:c(19) e:timecrtfrm h:'ВремяКПК форм' c:c(19) e:ser h:'SER' c:c(5)",,,,,forkpkr,,'Сбойные заявки',1,1)
   set cent on
   if lastkey()=K_ESC
      exit
   endif
   sele rs1
   go rcrs1r
   ttnr=ttn
   docguidr=alltrim(docguid)
   do case
      case lastkey()=19 // Left
           fldnomr=fldnomr-1
           if fldnomr=0
              fldnomr=1
           endif
      case lastkey()=4 // Right
           fldnomr=fldnomr+1
      case lastkey()=K_F3 // Фильтр
           ddc_r=gdTd
           clkpkr=setcolor('gr+/b,n/bg')
           wkpkr=wopen(10,10,15,70)
           wbox(1)
           @ 0,1 say 'Дата ' get ddc_r
           @ 1,1 say 'Агент' get kta_r pict '9999'
           read
           wclose(wkpkr)
           setcolor(clkpkr)
           if lastkey()=K_ESC
              forkpkr=forkpk_r
           endif
           if lastkey()=K_ENTER
              forkpkr=forkpk_r
              if !empty(ddc_r)
                 forkpkr=forkpkr+'.and.ddc=ddc_r'
              endif
              if kta_r#0
                 forkpkr=forkpkr+'.and.kta=kta_r'
              endif
           endif
           sele rs1
           go top
           rcrs1r=recn()
      case lastkey()=K_ENTER // Состав
           zvsbkpks()
   endc
endd
nuse()
retu .t.
******************
func zvsbkpks()
******************
sele rs2
if netseek('t1','ttnr')
   rcrs2r=recn()
   do while ttn=ttnr
      sele rs2
      go rcrs2r
      set cent off
      foot('','')
      rcrs2r=slcf('rs2',1,1,18,,"e:mntov h:'КодТ' c:n(7) e:ktl h:'КодП' c:n(9) e:getfield('t1','rs2->mntov','ctov','nat') h:'Товар' c:c(40) e:kvp h:'Количеств' c:n(9,3)",,,,'ttn=ttnr',,,'ТТН '+str(ttnr,6)+' '+docguidr)
      set cent on
      if lastkey()=K_ESC
         exit
      endif
      sele rs2
      go rcrs2r
   endd
endif
retu .t.

***************
func ktaopl()
***************
clea
netuse('dokz')
netuse('doks')
netuse('dokk')
netuse('kln')
netuse('kpl')
netuse('bs')
netuse('s_tag')
netuse('operb')
netuse('nap')
netuse('moddoc')
netuse('mdall')
netuse('ktanap')
crtt('tkkl','f:bs c:n(6) f:ddc c:d(10) f:kkl c:n(7) f:sm c:n(12,2) f:kta c:n(4) f:ktas c:n(4) f:nap c:n(4) f:mn c:n(6) f:rnd c:n(6) f:rn c:n(6) f:ktapl c:n(4) f:dokksk c:n(3) f:dokkttn c:n(6)')
sele 0
use tkkl excl
inde on str(bs,6)+dtos(ddc)+str(kkl,7) tag t1
sele dokz
do while !eof()
   if !(int(bs/1000)=301.or.int(bs/1000)=311)
      skip
      loop
   endif
   mnr=mn
   ddcr=ddc
   bsr=bs
   sele doks
   if netseek('t1','mnr')
      do while mn=mnr
         if kkl=20034
            skip
            loop
         endif
         kklr=kkl
         if !netseek('t1','kklr','kpl')
            skip
            loop
         endif
         rndr=rnd
         ktaplr=ktapl
         sele dokk
         if netseek('t1','mnr,rndr,kklr')
            do while mn=mnr.and.rnd=rndr.and.kkl=kklr
               if bs_k#361001
                  skip
                  loop
               endif
               smr=bs_s
               ktar=kta
               ktasr=ktas
               napr=nap
               rnr=rn
               dokkskr=dokksk
               dokkttnr=dokkttn
               sele tkkl
               appe blank
               repl bs with bsr,;
                    ddc with ddcr,;
                    kkl with kklr,;
                    sm with smr,;
                    kta with ktar,;
                    ktas with ktasr,;
                    nap with napr,;
                    mn with mnr,;
                    rnd with rndr,;
                    rn with rnr,;
                    ktapl with ktaplr,;
                    dokksk with dokkskr,;
                    dokkttn with dokkttnr
               sele dokk
               skip
            endd
         endif
         sele doks
         skip
      endd
   endif
   sele dokz
   skip
endd
sele tkkl
go top
rctkklr=recn()
fldnomr=1
for_r='.t.'
forr=for_r
store 0 to sm1r,sm2r
do while .t.
   sele tkkl
   go rctkklr
   foot('F3,F4','Фильтр,Корр')
   rctkklr=slce('tkkl',1,0,18,,"e:kkl h:'Код' c:n(7) e:getfield('t1','tkkl->kkl','kln','nkl') h:'Клиент' c:c(30) e:ddc h:'Дата' c:d(10) e:bs h:'Счет' c:n(6) e:sm h:'Сумма' c:n(10,2) e:tkkl->kta h:'Код' c:n(4) e:getfield('t1','tkkl->kta','s_tag','fio') h:'Агент' c:c(20) e:tkkl->ktas h:'Код' c:n(4) e:getfield('t1','tkkl->ktas','s_tag','fio') h:'Суперв' c:c(20) e:tkkl->nap h:'Код' c:n(4) e:getfield('t1','tkkl->nap','nap','nnap') h:'Направление' c:c(25) e:tkkl->ktapl h:'Код'c:n(4) e:getfield('t1','tkkl->ktapl','s_tag','fio') h:'Внес в кассу' c:c(20)",,,1,,forr,,,,1)
   if lastkey()=K_ESC
      exit
   endif
   sele tkkl
   go rctkklr
   mnr=mn
   rndr=rnd
   kklr=kkl
   rnr=rn
   ktaplr=ktapl
   ktar=kta
   ktasr=ktas
   napr=nap
   do case
      case lastkey()=19 // Left
           fldnomr=fldnomr-1
           if fldnomr=0
              fldnomr=1
           endif
      case lastkey()=4 // Right
           fldnomr=fldnomr+1
      case lastkey()=K_F3
           clzvr=setcolor('gr+/b,n/bg')
           wzvr=wopen(8,20,17,70)
           wbox(1)
           store 0 to sm1r,sm2r,bsr,kklr,ktar,ktasr,napr,ktaplr
           store gdTd to ddcr
           do while .t.
              @ 0,1 say 'Дата       ' get ddcr
              @ 1,1 say 'Счет       ' get bsr     pict '999999'
              @ 2,1 say 'Клиент     ' get kklr    pict '9999999'
              @ 3,1 say 'Агент      ' get ktar    pict '9999'
              @ 4,1 say 'Супервайзер' get ktasr   pict '9999'
              @ 5,1 say 'Направление' get napr    pict '9999'
              @ 6,1 say 'Кто внес   ' get ktaplr  pict '9999'
              @ 7,1 say 'Сумма с' get sm1r  pict '9999999.99'
              @ 7,col()+1 say 'по' get sm2r  pict '9999999.99'
              read
              if lastkey()=K_ESC
                 forr=for_r
                 exit
              endif
              if lastkey()=K_ENTER
                 forr=for_r
                 if !empty(ddcr)
                    forr=forr+'.and.ddc=ddcr'
                 endif
                 if bsr#0
                    forr=forr+'.and.bs=bsr'
                 endif
                 if kklr#0
                    forr=forr+'.and.kkl=kklr'
                 endif
                 if ktar#0
                    forr=forr+'.and.kta=ktar'
                 endif
                 if ktasr#0
                    forr=forr+'.and.ktas=ktasr'
                 endif
                 if napr#0
                    forr=forr+'.and.nap=napr'
                 endif
                 if ktaplr#0
                    forr=forr+'.and.ktapl=ktaplr'
                 endif
                 if sm2r#0
                    forr=forr+'.and.sm>=sm1r.and.sm<=sm2r'
                 else
                    if sm1r#0
                       forr=forr+'.and.sm=sm1r'
                    endif
                 endif
                 exit
              endif
           endd
           wclose(wzvr)
           setcolor(clzvr)
           sele tkkl
           go top
           rctkklr=recn()
      case lastkey()=K_F4 // Коррекция
           clzvr=setcolor('gr+/b,n/bg')
           wzvr=wopen(8,20,13,70)
           wbox(1)
           do while .t.
              kta_r=ktar
              ktas_r=ktasr
              nap_r=nap
              @ 0,1 say 'Агент      '+' '+str(kta_r,4)+' '+getfield('t1','kta_r','s_tag','fio')
              @ 1,1 say 'Супервайзер'+' '+str(ktas_r,4)+' '+getfield('t1','ktas_r','s_tag','fio')
              @ 2,1 say 'Направление'+' '+str(nap_r,4)+' '+getfield('t1','nap_r','nap','nnap')
              @ 0,1 say 'Агент      ' get kta_r    pict '9999' valid chkas(kta_r)
              read
              if lastkey()=K_ESC
                 exit
              endif
              @ 0,1 say 'Агент      '+' '+str(kta_r,4)+' '+getfield('t1','kta_r','s_tag','fio')
              ktas_r=getfield('t1','kta_r','s_tag','ktas')
              nap_r=getfield('t1','kta_r','ktanap','nap')
              if nap_r=0
                 nap_r=getfield('t1','ktas_r','ktanap','nap')
              endif
              @ 1,1 say 'Супервайзер'+' '+str(ktas_r,4)+' '+getfield('t1','ktas_r','s_tag','fio')
              @ 2,1 say 'Направление'+' '+str(nap_r,4)+' '+getfield('t1','nap_r','nap','nnap')
              if kta_r=0
                 @ 1,1 say 'Супервайзер' get ktas_r   pict '9999' valid chkas(ktas_r)
                 read
                 if lastkey()=K_ESC
                    exit
                 endif
                 if nap_r=0
                    nap_r=getfield('t1','ktas_r','ktanap','nap')
                 endif
              endif
              @ 1,1 say 'Супервайзер'+' '+str(ktas_r,4)+' '+getfield('t1','ktas_r','s_tag','fio')
              @ 2,1 say 'Направление'+' '+str(nap_r,4)+' '+getfield('t1','nap_r','nap','nnap')
              if nap_r=0
                 @ 2,1 say 'Направление' get nap_r    pict '9999'
                 read
                 if lastkey()=K_ESC
                    exit
                 endif
                 if !netseek('t1','nap_r','nap')
                    nap_r=0
                 endif
              endif
              @ 2,1 say 'Направление'+' '+str(nap_r,4)+' '+getfield('t1','nap_r','nap','nnap')
              @ 3,1 say 'ENTER - запись; ESC - отмена'
              inkey(0)
              if lastkey()=K_ENTER
                 sele dokk
                 if netseek('t1','mnr,rndr,kklr,rnr')
                    if !(kta=kta_r.and.ktas=ktas_r.and.nap=nap_r)
                       netrepl('kta,ktas,nap','kta_r,ktas_r,nap_r')
                       docmod('корр')
                       mdall('корр')
                       sele tkkl
                       netrepl('kta,ktas,nap','kta_r,ktas_r,nap_r')
                    endif
                 endif
                 exit
              endif
          endd
          wclose(wzvr)
          setcolor(clzvr)
   endc
endd
nuse()
nuse('tkkl')
retu .t.

**************
func OplNap()
**************
clea
netuse('dokz')
netuse('doks')
netuse('dokk')
netuse('kln')
netuse('kpl')
netuse('bs')
netuse('s_tag')
netuse('operb')
netuse('nap')
netuse('moddoc')
netuse('mdall')
netuse('ktanap')
sele dokk
go top
rcdokkr=recn()
fldnomr=1
for_r='mn#0.and.(int(dokk->bs_d/1000)=301.or.int(dokk->bs_d/1000)=311).and.val(subs(dokk->dokkmsk,3,2))#0.and.dokk->kkl#20034'
forr=for_r
store 0 to sm1r,sm2r
do while .t.
   sele dokk
   go rcdokkr
   foot('F3,F4,F9','Фильтр,Коррекция,Разделение')
   if fieldpos('rnpar')=0
      rcdokkr=slce('dokk',1,0,18,,"e:kkl h:'Код' c:n(7) e:getfield('t1','dokk->kkl','kln','nkl') h:'Клиент' c:c(30) e:ddk h:'Дата' c:d(10) e:dokk->bs_d h:'Счет' c:n(6) e:dokk->bs_s h:'Сумма' c:n(10,2) e:dokk->nap h:'Код' c:n(4) e:getfield('t1','dokk->nap','nap','nnap') h:'Направление' c:c(15) e:dokk->kta h:'Код' c:n(4) e:getfield('t1','dokk->kta','s_tag','fio') h:'Агент' c:c(20) e:dokk->ktas h:'Код' c:n(4) e:getfield('t1','dokk->ktas','s_tag','fio') h:'Суперв' c:c(20) e:dokk->ktapl h:'Код'c:n(4) e:getfield('t1','dokk->ktapl','s_tag','fio') h:'Внес в кассу' c:c(20) ",,,1,,forr,,,,1)
   else
      rcdokkr=slce('dokk',1,0,18,,"e:kkl h:'Код' c:n(7) e:getfield('t1','dokk->kkl','kln','nkl') h:'Клиент' c:c(30) e:ddk h:'Дата' c:d(10) e:dokk->bs_d h:'Счет' c:n(6) e:dokk->bs_s h:'Сумма' c:n(10,2) e:dokk->nap h:'Код' c:n(4) e:getfield('t1','dokk->nap','nap','nnap') h:'Направление' c:c(15) e:rnpar h:'Родитель' c:n(6) e:dokk->kta h:'Код' c:n(4) e:getfield('t1','dokk->kta','s_tag','fio') h:'Агент' c:c(20) e:dokk->ktas h:'Код' c:n(4) e:getfield('t1','dokk->ktas','s_tag','fio') h:'Суперв' c:c(20) e:dokk->ktapl h:'Код'c:n(4) e:getfield('t1','dokk->ktapl','s_tag','fio') h:'Внес в кассу' c:c(20) e:getfield('t1','dokk->mn,dokk->rnd,dokk->kkl','doks','bosn') h:'Банк основание' c:c(78)",,,1,,forr,,,,1)
   endif
   if lastkey()=K_ESC
      exit
   endif
   go rcdokkr
   mnr=mn
   rndr=rnd
   kklr=kkl
   rnr=rn
   bs_sr=bs_s
   ktar=kta
   ktasr=ktas
   dokkskr=dokksk
   dokkttnr=dokkttn
   rmskr=rmsk
   if fieldpos('nap')#0
      napr=nap
   else
      napr=0
   endif
   if fieldpos('rnpar')#0
      rnparr=rnpar
   else
      rnparr=0
   endif
   tzdocr=getfield('t1','kklr','kpl','tzdoc')
   do case
      case lastkey()=19 // Left
           fldnomr=fldnomr-1
           if fldnomr=0
              fldnomr=1
           endif
      case lastkey()=4 // Right
           fldnomr=fldnomr+1
      case lastkey()=K_F3
           clzvr=setcolor('gr+/b,n/bg')
           wzvr=wopen(7,20,17,70)
           wbox(1)
           store 0 to sm1r,sm2r,bsr,kklr,ktar,ktasr,napr,ktaplr,rmskr
           if gnEntrm=1
              rmskr=gnRmsk
           endif
           store gdTd to ddkr
           do while .t.
              @ 0,1 say 'Дата       ' get ddkr
              @ 1,1 say 'Счет       ' get bsr     pict '999999'
              @ 2,1 say 'Клиент     ' get kklr    pict '9999999'
              @ 3,1 say 'Агент      ' get ktar    pict '9999'
              @ 4,1 say 'Супервайзер' get ktasr   pict '9999'
              @ 5,1 say 'Направление' get napr    pict '9999'
              @ 6,1 say 'Кто внес   ' get ktaplr  pict '9999'
              @ 7,1 say 'Сумма с' get sm1r  pict '9999999.99'
              @ 7,col()+1 say 'по' get sm2r  pict '9999999.99'
  //             if gnEntrm=0
  //                @ 8,1 say 'Уд скад ' get rmskr  pict '9'
  //             endif
              read
              if lastkey()=K_ESC
                 forr=for_r
                 exit
              endif
              if lastkey()=K_ENTER
                 forr=for_r
                 if !empty(ddkr)
                    forr=forr+'.and.ddk=ddkr'
                 endif
                 if bsr#0
                    forr=forr+'.and.dokk->bs_d=bsr'
                 endif
                 if kklr#0
                    forr=forr+'.and.kkl=kklr'
                 endif
                 if ktar#0
                    forr=forr+'.and.kta=ktar'
                 endif
                 if ktasr#0
                    forr=forr+'.and.ktas=ktasr'
                 endif
                 if napr#0
                    forr=forr+'.and.nap=napr'
                 endif
                 if ktaplr#0
                    forr=forr+'.and.ktapl=ktaplr'
                 endif
                 if sm2r#0
                    forr=forr+'.and.sm>=sm1r.and.sm<=sm2r'
                 else
                    if sm1r#0
                       forr=forr+'.and.sm=sm1r'
                    endif
                 endif
  //                if rmskr#0
  //                   forr=forr+'.and.rmsk=rmskr'
  //                else
  //                   if gnEntRm=0
  //                      forr=forr+'.and.rmsk=0'
  //                   else
  //                      forr=forr+'.and.rmsk=gnRmSk'
  //                   endif
  //                endif
                 exit
              endif
           endd
           wclose(wzvr)
           setcolor(clzvr)
           sele dokk
           go top
           rcdokkr=recn()
      case lastkey()=K_F4 // Коррекция
           if gnEntRm=0
              if rmskr#0
                 wmess('Проводка удаленного склада',2)
                 loop
              endif
           else
              if rmskr#gnRmsk
                 wmess('Не своя проводка',2)
                 loop
              endif
           endif
           clzvr=setcolor('gr+/b,n/bg')
           wzvr=wopen(8,20,13,70)
           wbox(1)
           do while .t.
              kta_r=ktar
              ktas_r=ktasr
              nap_r=nap
              @ 0,1 say 'Агент      '+' '+str(kta_r,4)+' '+getfield('t1','kta_r','s_tag','fio')
              @ 1,1 say 'Супервайзер'+' '+str(ktas_r,4)+' '+getfield('t1','ktas_r','s_tag','fio')
              @ 2,1 say 'Направление'+' '+str(nap_r,4)+' '+getfield('t1','nap_r','nap','nnap')
              @ 0,1 say 'Агент      ' get kta_r    pict '9999' valid chkas(kta_r)
              read
              if lastkey()=K_ESC
                 exit
              endif
              @ 0,1 say 'Агент      '+' '+str(kta_r,4)+' '+getfield('t1','kta_r','s_tag','fio')
              ktas_r=getfield('t1','kta_r','s_tag','ktas')
              nap_r=getfield('t1','kta_r','ktanap','nap')
              if nap_r=0
                 nap_r=getfield('t1','ktas_r','ktanap','nap')
              endif
              @ 1,1 say 'Супервайзер'+' '+str(ktas_r,4)+' '+getfield('t1','ktas_r','s_tag','fio')
              @ 2,1 say 'Направление'+' '+str(nap_r,4)+' '+getfield('t1','nap_r','nap','nnap')
              if kta_r=0
                 @ 1,1 say 'Супервайзер' get ktas_r   pict '9999' valid chkas(ktas_r)
                 read
                 if lastkey()=K_ESC
                    exit
                 endif
                 if nap_r=0
                    nap_r=getfield('t1','ktas_r','ktanap','nap')
                 endif
              endif
              @ 1,1 say 'Супервайзер'+' '+str(ktas_r,4)+' '+getfield('t1','ktas_r','s_tag','fio')
              @ 2,1 say 'Направление'+' '+str(nap_r,4)+' '+getfield('t1','nap_r','nap','nnap')
              if nap_r=0
                 @ 2,1 say 'Направление' get nap_r    pict '9999'
                 read
                 if lastkey()=K_ESC
                    exit
                 endif
                 if !netseek('t1','nap_r','nap')
                    nap_r=0
                 endif
              endif
              @ 2,1 say 'Направление'+' '+str(nap_r,4)+' '+getfield('t1','nap_r','nap','nnap')
              @ 3,1 say 'ENTER - запись; ESC - отмена'
              inkey(0)
              if lastkey()=K_ENTER
                 sele dokk
                 netrepl('kta,ktas,nap','kta_r,ktas_r,nap_r')
                 docmod('корр')
                 mdall('корр')
                 exit
              endif
          endd
          wclose(wzvr)
          setcolor(clzvr)
      case lastkey()=K_F9 // Разделение
           if gnEntRm=0
              if rmskr#0
                 wmess('Проводка удаленного склада',2)
                 loop
              endif
           else
              if rmskr#gnRmsk
                 wmess('Не своя проводка',2)
                 loop
              endif
           endif
           sele dokk
           if fieldpos('rnpar')=0
              wmess('Нет поля DOKK->RNPAR',2)
              loop
           endif
           if tzdocr=0
              wmess('Нет направлений у клиента',2)
              loop
           endif
  //          if dokkttnr#0.and.gnAdm=0
  //             wmess('Закрыта по ТТН',2)
  //             loop
  //          endif
           rzdprv()
   endc
endd
nuse()
retu .t.

**************
func vzkpk()
**************
clea
netuse('pr1kpk')
netuse('pr2kpk')
netuse('ctov')
sele pr1kpk
ddc_r=gdTd
kta_r=0
forkpkr='.t.'
forkpk_r='.t.'
go top
rcpr1kpkr=recn()
fldnomr=1
do while .t.
   sele pr1kpk
   go rcpr1kpkr
   set cent off
   foot('F3','Фильтр')
   rcpr1kpkr=slce('pr1kpk',1,1,18,,"e:nd h:'НД' c:n(6) e:ddc h:'ДатаС' c:d(8) e:tdc h:'ВрС' c:c(8) e:kop h:'КОП' c:n(3) e:kps h:'КодПлат' c:n(7) e:kzg h:'КодПолу' c:n(7) e:kta h:'КодА' c:n(4) e:docguid h:'ДокКПК' c:c(36) e:skpk h:'N сеанса' c:n(10) e:nnz h:'N в сеан' c:c(9) ",,,,,forkpkr,,'Возвраты',1,1)
   set cent on
   if lastkey()=K_ESC
      exit
   endif
   sele pr1kpk
   go rcpr1kpkr
   mnr=mn
   docguidr=alltrim(docguid)
   do case
      case lastkey()=19 // Left
           fldnomr=fldnomr-1
           if fldnomr=0
              fldnomr=1
           endif
      case lastkey()=4 // Right
           fldnomr=fldnomr+1
      case lastkey()=K_F3 // Фильтр
           ddc_r=gdTd
           clkpkr=setcolor('gr+/b,n/bg')
           wkpkr=wopen(10,10,15,70)
           wbox(1)
           @ 0,1 say 'Дата ' get ddc_r
           @ 1,1 say 'Агент' get kta_r pict '9999'
           read
           wclose(wkpkr)
           setcolor(clkpkr)
           if lastkey()=K_ESC
              forkpkr=forkpk_r
           endif
           if lastkey()=K_ENTER
              forkpkr=forkpk_r
              if !empty(ddc_r)
                 forkpkr=forkpkr+'.and.ddc=ddc_r'
              endif
              if kta_r#0
                 forkpkr=forkpkr+'.and.kta=kta_r'
              endif
           endif
           sele pr1kpk
           go top
           rcpr1kpkr=recn()
      case lastkey()=K_ENTER // Состав
           vzkpks()
   endc
endd
nuse()
retu .t.
******************
func vzkpks()
******************
sele pr2kpk
if netseek('t1','mnr')
   rcpr2kpkr=recn()
   do while mn=mnr
      sele pr2kpk
      go rcpr2kpkr
      set cent off
      foot('','')
      rcpr2kpkr=slcf('pr2kpk',1,1,18,,"e:mntov h:'Код' c:n(7) e:getfield('t1','pr2kpk->mntov','ctov','nat') h:'Товар' c:c(40) e:kf h:'Заявлено' c:n(9,3) e:kfo h:'Выписано' c:n(9,3) e:kf-kfo h:'Разница' c:n(9,3)",,,,'mn=mnr',,,'Приход '+str(mnr,6)+' '+docguidr)
      set cent on
      if lastkey()=K_ESC
         exit
      endif
      sele pr2kpk
      go rcpr2kpkr
   endd
endif
retu .t.
