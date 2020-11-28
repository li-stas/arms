#include "common.ch"
#include "inkey.ch"
  //Ведомость цен
  //Формат A4 Пика сжатый
  //h=62 w=140
set colo to g/n,n/g,,,
CLEAR
prdol=0
stop=.f.
netuse('GrpE')
netuse('kln')
netuse('tcen')
netuse('sgrp')
netUse('tov')
if select('sl')=0
   sele 0
   use _slct alias sl excl
endif
sele sl
zap
@ 02,20 say 'Выбор необходимых для печати цен'
sele tcen
go top
do while .t.
   tcenr=slcf('tcen',,,14,,"e:tcen h:'Тип' c:n(2) e:ntcen h:'Наименование' c:c(20)",'tcen',1)
   netseek('t1','tcenr')
   if lastkey()=K_ESC.or.lastkey()=K_ENTER
      exit
   endif
enddo
if file('ltcen')
   erase ("ltcen.dbf")
endif

sele sl
copy to ltcen
zap
select 0
use ltcen alias ltcen excl
count to kz
if kz=0
   return
endif
*iif(kz>8,prdol=1,prdol=0)
if kz>8
   prdol=1
else
   prdol=0
endif

if prdol=1
   if file('prod')
      erase ("prod.dbf")
   endif
   aprod:={}
   for i=1 to kz-8
       if (kz-8)<10
          cenr='cenr'+str(i,1)
       else
          cenr='cenr'+str(i,2)
       endif
       aadd(aprod,{cenr,'n',10,3})
   next
   dbcreate('prod',aprod)
   sele 0
   use prod alias prod
endif
clea
sele tov
set orde to tag t1
go top
oclr=setcolor('gr+/b,n/w')
wostf=wopen(5,20,20,60)
wbox(1)
if gnMskl=1
   skl_r=9998
   nskl_r=''
else
   skl_r=gnSkl
   nskl_r=gcNskl
endif
store 1 to psr,pir
kg_r=999
izg_r=99999999
post_r=9999999
do while .t.
   sele tov
   go top
   if gnMskl=1
      @ 0,1 say 'Подотчетник' get skl_r pict '9999' valid skl()
      @ 1,1 say '9998 - По всем подотчетникам'
   else
      @ 0,1 say 'Склад '+gcNskl
   endif
   if gnMskl=0
      @ 2,1 say 'Изготовитель' get izg_r pict '99999999' valid izg()
      @ 3,1 say '99999999 - по всем'
   endif
   if gnMskl=0
      @ 4,1 say 'Поставщик   ' get post_r pict '9999999' valid post()
      @ 5,1 say '99999999 - по всем'
   endif

   @ 6,1 say 'Группа     ' get kg_r  pict '999' valid kg()
   @ 7,1 say '999 - По всем группам'
   read
   if lastkey()=K_ESC
      exit
   endif

   @ 12,1 prom 'Печать'
   @ 12,col()+1 prom 'Экран'
   menu to psr
   if lastkey()=K_ESC
      exit
   endif
   vcenprn()
endd
wclose(wostf)
setcolor(oclr)
nuse()
nuse('lizg')
nuse('ltcen')
nuse('lsl')
nuse('prod')
erase("ltcen.dbf")
erase("prod.dbf")
erase("lizg.dbf")
erase("lizg1.cdx")
erase("lizg2.cdx")
erase("prod.dbf")
erase("sl1.dbf")
erase("sl1.cdx")



**************************************************************************
static function kg()
**************************************************************************
if kg_r#999
   if select('sl')=0
      sele 0
      use _slct alias sl excl
   endif
   sele sl
   zap
   sele sgrp
   if kg_r=0
      go top
   else
      netseek('t1','kg_r')
   endif
   wselect(0)
   do while .t.
      if izg_r=0
         kg_r=slcf('sgrp',,,,,"e:kgr h:'Код' c:n(3) e:ngr h:'Наименование' c:c(20)",'kgr',1)
      else
         kg_r=slcf('sgrp',,,,,"e:kgr h:'Код' c:n(3) e:ngr h:'Наименование' c:c(20)",'kgr',1)
      endif
      netseek('t1','kg_r')
      if lastkey()=K_ESC
         kg_r=999
         sele sl
         zap
         exit
      endif
      if lastkey()=K_ENTER
         sele sl
         inde on kod to sl1
         exit
      endif
   enddo
   setlastkey(0)
   wselect(wostf)
  //  ng_r=getfield('t1','kg_r','sgrp','ngr')
  //  @ 4,18 say ngr
endif
retu .t.

**************************************************************************
static function izg()
**************************************************************************
if izg_r#99999999
   if gnMskl=0
      wmess('Ждите,идет формирование справочника...',2)
      tovizg()
   endif
   sele lizg
   set orde to 1
   seek str(izg_r,8)
   if !FOUND()
      set orde to 2
      go top
      wselect(0)
      izg_r=slcf('lizg',,,,,"e:nizg h:'Наименование' c:c(40) e:izg h:'Код' c:n(8)",'izg')
      if izg_r=0
         izg_r=99999999
      endif
      sele lizg
      seek str(izg_r,8)
      nizgr=nizg
      wselect(wostf)
      @ 2,18 say nizgr
   endif
endif
retu .t.
**************************************************************************
stat func post()
if post_r#0.and.post_r#9999999
   sele kln
   if netseek('t1','post_r')
      npostr=nkl
      // @ 4,9 say npostr
      sele tov
   else
      post_r=0
   endif
endif
if post_r=0
   sele kln
   kklr=post_r
   wselect(0)
   post_r=slct_kl(10,1,12)
   sele kln
   netseek('t1','post_r')
   npostr=nkl
   *@ 4,18 say npostr
   sele tov
   wselect(wostf)
endif
retu .t.

**************************************************************************
static function skl()
**************************************************************************
if skl_r#9998
   sele kln
   if !netseek('t1','skl_r')
      go top
   endif
   wselect(0)
   skl_r=slcf('kln',,,,,"e:kkl h:'Код' c:n(4) e:nkl h:'Подотчетник' c:c(20)",'kkl',,,'kkl<10000')
   wselect(wostf)
   nskl_r=getfield('t1','skl_r','kln','nkl')
   @ 0,18 say nskl_r
else
   nskl_r='по всем'
endif
retu .t.

**************************************************************************
proc vcenprn()
**************************************************************************
pprd=.f.
set prin to
if gnOut=1
   set prin to lpt1
else
   set prin to txt.txt
endif
set prin on
set cons off
if empty(gcPrn)
   ?chr(27)+chr(77)+chr(15)
else
   ??chr(27)+'E'+chr(27)+'&l1h26a0O'+chr(27)+chr(27)+'(3R'+chr(27)+'(s0p17.00h0s1b4102T'+chr(27)  // Книжная А4
endif
sele tov
set orde to tag t2
wlr='!eof()'
frr='.t.'
if gnMskl=0
   if izg_r#99999999
      frr=frr+'.and.izg=izg_r'
   endif
   if post_r#9999999
      frr=frr+'.and.post=post_r'
   endif
endi
if gnMskl=0
   if kg_r=999
      go top
   else
      sele sl
      go top
      f=0
      do while !eof()
         jjj=val(kod)
         if f=0
            frr=frr+'.and.(int(ktl/1000000)='+str(jjj,3)
         else
            frr=frr+'.or.int(ktl/1000000)='+str(jjj,3)
         endif
         f++
         sele sl
         skip
      endd
      if f#0
         frr=frr+')'
      endif
      wlr='skl=skl_r'
   endif
else
   if skl_r=9998
      if kg_r=999
         go top
      else
         go top
         frr=frr+'.and.int(ktl/1000000)=kg_r'
      endif
   else
      if kg_r=999
         netseek('t2','skl_r')
         wlr='skl=skl_r'
      else
  //        netseek('t2','str(skl_r,4)+str(gnVu,1)+iif(kg_r#0,str(kg_r,3),space(3))',,1)
         netseek('t2','str(skl_r,7)+iif(kg_r#0,str(kg_r,3),space(3))',,1)
         wlr='skl=skl_r.and.int(ktl/1000000)=kg_r'
      endif
   endif
endif
lstr=1
ostfwr=1
antcen:={}
azen:={}
sele ltcen
go top
for i=1 to kz
    kodr=val(kod)
    sele tcen
    if netseek('t1','kodr')
       aadd(antcen,ntcen)
       aadd(azen,alltrim(zen))
    endif
    sele ltcen
    skip
next
censh()
prkgr=0
prsklr=0
prktlr=0
skl_rr=9997
kg_rr=998
ktl_rr=999999998
store 0 to sumtr,sumgr,sumir,sumsr
if gnOut=2
   set devi to scre
   wselect(0)
   save scre to scmess
   mess('Ждите,идет печать...')
endif
sele tov
if gnMskl=0
   set orde to tag t4
   netseek('t2','skl_r')
endif
do while &wlr
   if !&frr
      skip
      loop
   endif
   sklr=skl
   ktlr=ktl
   kgr=int(ktlr/1000000)
   if osf=0
      sele tov
      skip
      loop
   endif
   if ktl_rr#ktlr.or.skl_rr#sklr
      if prktlr=1  // Закрыть предыдущий товар
         cto_end()
         prktlr=0
      endif
      ktl_rr=ktlr
   endif
   if kg_rr#kgr.or.skl_rr#sklr
      if prkgr=1 // Закрыть предыдущую группу
         cgo_end()
         prkgr=0
      endif
      kg_rr=kgr
   endif
   if skl_rr#sklr   // Смена мультисклада
      if gnMskl#0
         if prsklr=1 // Закрыть предыдущий мультисклад
            cso_end()
            prsklr=0
         endif
      endif
      skl_rr=sklr
   endif
   if gnMskl#0
      if prsklr=0 // Открыть новый мультисклад
         @ 24,1 say str(sklr,4)+' '+getfield('t1','sklr','kln','nkl') color 'g/n'
         ?space(5)+str(sklr,4)+' '+getfield('t1','sklr','kln','nkl')
         cenle()


      prsklr=1
      endif
   endif
   if prkgr=0 // Открыть новую группу
  //     kg_rrr=kgr
      @ 24,40 say str(kg_rr,3)+' '+getfield('t1','kg_rr','sgrp','ngr') color 'g/n'
      if prdol=1
         sele prod
         appe blank
      endif
      sele tov
      ?str(kgr,3)+' '+getfield('t1','kg_rr','sgrp','ngr')
      cenle()
      prkgr=1
   endif
   sele tov
   if prktlr=0  // Открыть новый товар
  //     if pir=1
  //        ?str(ktlr,9)+' '+nat
  //        cenle()
  //     endif
      prktlr=1
   endif
   // optr=&coptr
   kger=kge
   natr=nat
   neir=nei
   osfr=osf
   if upak=0
      upakr=space(5)
   else
      upakr=str(upak,5)
   endif
   acen:={}
   for i=1 to kz
       ccenr=azen[i]
       acenr=&ccenr
       aadd(acen,acenr)
   next
  //  sumgr=sumgr+sumtr
  //  sumsr=sumsr+sumtr
  //  sumir=sumir+sumtr

   if pir=1
      natr=subs(alltrim(getfield('t1','kger','GrpE','nge'))+' '+natr,1,59)
  //     if gnSkl=92.and.upak<>0
  //        upakr=str(upak,5)
         osntext=str(ktlr,9)+' '+natr+' '+upakr+' '+subs(neir,1,4)+' '+str(osfr,10,3)
  //     else
  //        osntext=str(ktlr,9)+' '+natr+' '+subs(neir,1,4)+str(osfr,10,3)
  //     endif
      strtext=osntext
      if prdol=1
         for i=1 to 8
            strtext=strtext+' '+iif(acen[i]>0,str(acen[i],7,3),space(7))
         next
         nfield=0
         sele prod
         appe blank
         for i=9 to kz
             acenr=acen[i]
             nfield=nfield+1
             cenr='cenr'+alltrim(str(nfield))
             repl &cenr with acenr
         next
      else
         for i=1 to kz
            strtext=strtext+' '+str(acen[i],7,3)
         next
      endif
      ?strtext
      cenle()
   endif
   sele tov
   skip
endd
cto_end()
cgo_end()
cso_end()
cio_end()
*?repl('-',krepl)
stop=.t.
if prdol=1
   censhprd()
endif
cenle()
eject
if gnOut=2
   rest scre from scmess
   wselect(wostf)
endif
set cons on
set prin to
set prin off
if psr=2
   wselect(0)
   edfile('txt.txt')
   wselect(wostf)
endif


retu

*****************************************************************************
proc censh()
*****************************************************************************
?space(45)+'Ведомость цен   '+alltrim(nskl_r)
?space(45)+'за    '+cmonth(gdTd)+'    ' +str(year(gdtd),4)+'  гoда'
cenle()
*if izg_r#0
  //  ?'По изготовителю '+str(izg_r,8)+' '+getfield('t1','izg_r','kln','nkl')
  //  cenle()
*endif
*if post_r#0
  //  ?'По поставщику '+str(post_r,7)+' '+getfield('t1','post_r','kln','nkl')
  //  cenle()
*endif
? dtoc(date())+space(80)+'Лист '+str(lstr,2)
cenle()
if prdol=1
   krepl=70
else
   krepl=kz*8
endif
krepl=krepl+90
?repl('-',krepl)
cenle()
*if gnSkl=92
   osnsh='  Код  |              Наименование                                 |Упак.|Изм.|Количество'
  osnsh1='       |                                                           |     |    |          '

*else
  //  osnsh='|  Код  |                 Наименование                              |Изм.|Количество'
*endif
strsh=osnsh
strsh1=osnsh1
if prdol=1
   for i=1 to 8
      strsh=strsh+'|'+substr(antcen[i],1,7)
      strsh1=strsh1+'|'+substr(antcen[i],8,7)
   next
else
   for i=1 to kz
      strsh=strsh+'|'+substr(antcen[i],1,7)
     strsh1=strsh1+'|'+substr(antcen[i],8,7)

   next
endif
?strsh
?strsh1
cenle()
?repl('-',krepl)
cenle()
pprd=.t.
retu
*****************************************************************************
proc censhprd()
*****************************************************************************
?space(15)+'Ведомость цен   '+alltrim(nskl_r)
?space(15)+'за    '+cmonth(gdTd)+'    ' +str(year(gdtd),4)+'  гoда'
? space(10)+dtoc(date())+space(10)+'Продолжение листа '+str(lstr,2)
krepl=(kz-8)*8
?repl('-',krepl+10)
strsh=''
strsh1=''
for i=9 to kz
      strsh=strsh+'|'+substr(antcen[i],1,7)
     strsh1=strsh1+'|'+substr(antcen[i],8,7)

   next
?space(10)+strsh
?space(10)+strsh1
?repl('-',krepl+10)
strtext=''
sele prod
go top
do while !eof()
   for i=1 to kz-8
       cenr='cenr'+alltrim(str(i))
       cenrr=&cenr
       strtext=strtext+' '+iif(cenrr>0,str(cenrr,7,3),space(7))
   next
   ?space(10)+strtext
   strtext=''
skip
enddo
sel:=select()
sele prod
zap
select(sel)
pprd=.f.
retu

*****************************************************************************
proc cenle()
*****************************************************************************
ostfwr++
if ostfwr>63
   ostfwr=1
  //  lstr++
   eject
   if gnOut=1
      set devi to scre
      wselect(0)
      save scre to scmess
      mess('Вставьте лист и нажмите пробел',1)
      rest scre from scmess
      wselect(wostf)
   endif
   if prdol=1 .and. pprd=.t.
      censhprd()
      if stop#.t.
         ostfwr=1
         eject
         lstr++
         censh()
      endif
   else
      lstr++
      censh()
   endif
endif

retu
************************************************************************
proc cso_end()
************************************************************************
if gnMskl=1
  //  ?'Всего по подотчетнику:'  //+space(65)+str(sumsr,10,2)
   cenle()
endif
*sumsr=0
retu
************************************************************************
proc cgo_end()
***********************************************************************
*?'   Всего по группе:' // +space(68)+str(sumgr,10,2)
*sumgr=0
cenle()
retu
************************************************************************
proc cto_end()
************************************************************************
*if pir=1
  //  ?'Всего по товару :'
  //  cenle()
  //  ?space(81)+str(sumtr,10,2)
  //  cenle()
*endif
retu
************************************************************************
proc cio_end()
***********************************************************************
*?'Итого:'+space(81) // +str(sumir,10,2)
cenle()
*sumir=0
retu


