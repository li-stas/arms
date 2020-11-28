#include "common.ch"
#include "inkey.ch"
  //Ведомость остатков с учетом отгруженного товара (по отп.ценам)
  //Формат A4 Пика сжатый
  //h=62 w=140
if gnCtov#1
   retu
endif
vlpt1='lpt1'
set colo to g/n,n/g,,,
CLEAR
netuse('GrpE')
netuse('kln')
netuse('tcen')
*locate for tcen=gnTcen
if !empty(gcCopt)
   coptr=alltrim(gcCopt)
else
   coptr='opt'
endif
use
netuse('pr1')
set orde to tag t3
netuse('pr2')
netuse('rs1')
netuse('rs2')
netuse('kln')
netuse('sgrp')
netUse('tovm')
tovizgm()
************************************************************
crtt('totv','f:skl c:n(7) f:mntov c:n(9) f:kf c:n(10,3)')
sele 0
use totv excl
inde on str(skl,7)+str(mntov,7) tag t1
sele pr1
if netseek('t3','1')
   do while otv=1
      sklr=skl
      mnr=mn
      sele pr2
      if netseek('t1','mnr')
         do while mn=mnr
            mntovr=mntov
            kfr=kf
            sele totv
            if !netseek('t1','sklr,mntovr')
               netadd()
               netrepl('skl,mntov,kf','sklr,mntovr,kfr')
            else
               netrepl('kf','kf+kfr')
            endif
            sele pr2
            skip
         enddo
      endif
      sele pr1
      skip
   endd
endif
************************************************************
sele tovm
set orde to tag t1
go top
oclr=setcolor('gr+/b,n/w')
wostf=wopen(5,20,20,60)
wbox(1)
skl_r=gnSkl
nskl_r=gcNskl
store 1 to psr,pir,fvr
kg_r=999
izg_r=99999999
post_r=9999999
drlz_r=ctod('')
dpp_r=ctod('')
do while .t.
   sele tovm
   go top
   @ 0,1 say 'Склад '+gcNskl
   @ 2,1 say 'Изготовитель' get izg_r pict '99999999'
   @ 3,1 say '99999999 - по всем'

   @ 6,1 say 'Группа     ' get kg_r  pict '999'
   @ 7,1 say '999 - По всем группам'
   read
   if lastkey()=K_ESC
      exit
   endif
   @ 8,1 prom 'Факт'
   @ 8,col()+1 prom 'С уч. выписанного'
   @ 8,col()+1 prom 'Факт с уч. отгр.'
   menu to fvr
   if lastkey()=K_ESC
      exit
   endif
   @ 11,1 prom 'Полностью'
   @ 11,col()+1 prom 'Итоги'
   menu to pir
   if lastkey()=K_ESC
      exit
   endif
   @ 12,1 prom 'Печать'
   @ 12,col()+1 prom 'Экран'
   if gnSpech=1 .or. gnAdm=1
      @ 12,col()+1 prom 'Сет. печать'
   endif
   menu to psr
   if psr=3
      alpt={'lpt2','lpt3'}
      vlpt=alert('ПЕЧАТЬ НА СЕТЕВОЙ ПРИНТЕР',alpt)
      if vlpt=1
         vlpt1='lpt2'
      else
         vlpt1='lpt3'
      endif
   endif
   if lastkey()=K_ESC
      exit
   endif
   vostpodm()
endd
wclose(wostf)
setcolor(oclr)
nuse()
nuse('totv')
erase totv.dbf
erase totv.cdx
**************************************************************************
proc vostpodm
**************************************************************************
set prin to
if psr#3
   if gnOut=1
      set prin to lpt1
   else
      set prin to txt.txt
   endif
else
   set print to &vlpt1
endif
set prin on
set cons off
if psr=3
   ??chr(27)+'E'+chr(27)+'&l1h26a0O'+chr(27)+chr(27)+'(3R'+chr(27)+'(s0p17.00h0s1b4102T'+chr(27)  // Книжная А4
else
   if psr=1
      if empty(gcPrn)
         ??chr(27)+chr(80)+chr(15)
      else
        ??chr(27)+'E'+chr(27)+'&l1h26a0O'+chr(27)+chr(27)+'(3R'+chr(27)+'(s0p17.00h0s1b4102T'+chr(27)  // Книжная А4
      endif
   endif
endif
set devi to print
sele tovm
set orde to tag t2
wlr='!eof()'
frr='.t.'
if izg_r#99999999
   frr=frr+'.and.izg=izg_r'
endif
if kg_r=999
   go top
else
   frr=frr+'.and.kg=kg_r'
endif
lstr=1
ostfwr=1
ostshm()
prkgr=0
prsklr=0
prmntovr=0
skl_rr=9997
kg_rr=998
mntov_rr=999999998
store 0 to sumtr,sumgr,sumir,sumsr
if gnOut=2.and.psr#3
   set devi to scre
   wselect(0)
   save scre to scmess
   mess('Ждите,идет печать...')
endif
if fvr=3
  //  if !file('dopv')
  //     crtt('dopv','f:mntov c:n(9) f:kvp c:n(10,3) f:ttn c:n(6) f:dot c:d(8) f:ks c:n(10,3) f:mntov1 c:n(9) f:kvp1 c:n(10,3) f:ttn1 c:n(6) f:dot1 c:d(8) f:ks1 c:n(10,3)')
  //  else
  //     erase dopv.dbf
  //     crtt('dopv','f:mntov c:n(9) f:kvp c:n(10,3) f:ttn c:n(6) f:dot c:d(8) f:ks c:n(10,3) f:mntov1 c:n(9) f:kvp1 c:n(10,3) f:ttn1 c:n(6) f:dot1 c:d(8) f:ks1 c:n(10,3)')
  //  endif
  //  sele 0
  //  use dopv
endif

prk=0
ch0=0
ch1=0
sele tovm
do while &wlr
   if !&frr
      skip
      loop
   endif
   sklr=skl
   mntovr=mntov
   kgr=int(mntovr/10000)
   do case
      case fvr=1
           if osf=0
              sele tovm
              skip
              loop
            endif
      case fvr=2
         if osv=0
            sele tovm
            skip
            loop
         endif
      case fvr=3
           if osf=0.and.!netseek('t1','sklr,mntovr','totv')
              sele tovm
              skip
              loop
            endif
   endc
***************8888888888888888888888888888888888888
   if fvr=3.and.gnCtov=10
      mntovrr=0
      skotg=0
      skotgo=0
      sele rs2
      set order to tag t4
      netseek('t4','mntovr')
      do while mntov=mntovr
         if !empty(getfield('t1','rs2->ttn','rs1','dot')) .and. getfield('t1','rs2->ttn','rs1','prz')=0
            sele dopv
            if prk=0
               append blank
               if mntovrr#mntovr
                  repl mntov with mntovr,kvp with rs2->kvp,ttn with rs2->ttn,dot with getfield('t1','rs2->ttn','rs1','dot')
                  mntovrr=mntovr
               else
                  repl kvp with rs2->kvp,ttn with rs2->ttn,dot with getfield('t1','rs2->ttn','rs1','dot')
               endif
               sele rs2
               skotg=skotg+kvp
               skip
               do while .t.
                  if mntovr=mntov .and.!(!empty(getfield('t1','rs2->ttn','rs1','dot')) .and. getfield('t1','rs2->ttn','rs1','prz')=0)
                     skip
                     loop
                  else
                     exit
                  endif
               enddo
               if mntov#mntovr
                  sele dopv
                  repl ks with skotg
                  skotgo=skotg
                  skotg=0
               endif
               sele dopv
               ch0=ch0+1
               if ch0=58
                  prk=1
                  rr=recno()-ch0+1
                  go rr
                  ch0=0
               endif
               sele rs2
               loop
            else
               if mntovrr#mntovr
                  repl mntov1 with mntovr,kvp1 with rs2->kvp,ttn1 with rs2->ttn,dot1 with getfield('t1','rs2->ttn','rs1','dot')
                  mntovrr=mntovr
               else
                  repl kvp1 with rs2->kvp,ttn1 with rs2->ttn,dot1 with getfield('t1','rs2->ttn','rs1','dot')
               endif
               sele rs2
               skotg=skotg+kvp
               skip
               do while .t.
                  if mntovr=mntov .and.!(!empty(getfield('t1','rs2->ttn','rs1','dot')) .and. getfield('t1','rs2->ttn','rs1','prz')=0)
                     skip
                     loop
                  else
                     exit
                  endif
               enddo
               if mntov#mntovr
                  sele dopv
                  repl ks1 with skotg
                  skotgo=skotg
                  skotg=0
               endif
               sele dopv
               ch0=ch0+1
               skip
               if ch0=58
                  prk=0
                  ch0=0
               endif
               sele rs2
               loop
            endif
         else
            skip
            loop
         endif
      enddo
      sele tovm
   endif
*******************
   if mntov_rr#mntovr.or.skl_rr#sklr
      if prmntovr=1  // Закрыть предыдущий товар
         to_endm()
         prmntovr=0
      endif
      mntov_rr=mntovr
   endif
   if kg_rr#kgr
      if prkgr=1 // Закрыть предыдущую группу
         go_endm()
         prkgr=0
      endif
      kg_rr=kgr
   endif
   if prkgr=0 // Открыть новую группу
      if gnout=2.and.psr#3
         @ 24,40 say str(kg_rr,3)+' '+getfield('t1','kg_rr','sgrp','ngr') color 'g/n'
      endif
      ?str(kgr,3)+' '+getfield('t1','kg_rr','sgrp','ngr')
      ostlem()
      prkgr=1
   endif
   sele tovm
   if prmntovr=0  // Открыть новый товар
      prmntovr=1
   endif
   optr=&coptr
   kger=kge
   natr=nat
   neir=nei
   osfr=osf
   osvr=osv
   osfmr=osfm
   osvor=osvo
   kfr=getfield('t1','sklr,mntovr','totv','kf')
   osfr=osfr
   osvr=osvr
   drlzr=drlz
   dppr=dpp
   if fvr=1
      sumtr=0
   else
      if fvr=2
         sumtr=0
      else
         sumtr=0
         skotgo=0
         sele rs2
         set order to tag t4
         if netseek('t4','mntovr')
            do while mntov=mntovr
               ttnr=ttn
               kvpr=kvp
               sele rs1
               if netseek('t1','ttnr')
                  if prz=0.and.!empty(dot)
                     skotgo=skotgo+kvpr
                  endif
               endif
               sele rs2
               skip
            endd
         endif
         osfr=osfr-skotgo
      endif
   endif
   sumgr=0
   sumsr=0
   sumir=0
   optr=0
   if pir=1
      natr=subs(alltrim(getfield('t1','kger','GrpE','nge'))+' '+natr,1,50)
      dtr=''
      ?str(mntovr,7)+' '+natr+' '+subs(neir,1,4)+' '+str(optr,10,3)+' '+iif(fvr=1.or.fvr=3,str(osfr,10,3),str(osvr,10,3))+' '+str(sumtr,10,2)+' '+dtr
      if kfr#0
         ??' '+str(kfr,10,3)
      endif
      ostlem()
   endif
   sele tovm
   skip
endd
to_endm()
go_endm()
so_endm()
io_endm()
?repl('-',107)
ostlem()
eject
*******
if fvr=3.and.gnCtov=10
   avv={'Да','Нет'}
   vv=alert('Печать дополнения',avv)
   if vv=1
      dopvedm()
   endif
  //  nuse('dopv')
  //  erase dopv.dbf
endif
********
if gnOut=2.and.psr#3
   rest scre from scmess
   wselect(wostf)
endif
set cons on
set prin off
set prin to
set devi to screen
if psr=2
   wselect(0)
   edfile('txt.txt')
   wselect(wostf)
endif
retu

*****************************************************************************
proc ostshm()
*****************************************************************************
?'Ведомость '+iif(fvr=1,'фактических остатков ',iif(fvr=2,'остатков с уч.вып. ','фактических остатков с уч. отгруженного  '))+alltrim(nskl_r)+' на '+dtoc(gdTd)
ostlem()
if izg_r#0
   ?'По изготовителю '+str(izg_r,8)+' '+getfield('t1','izg_r','kln','nkl')
   ostlem()
endif
if post_r#0
   ?'По поставщику '+str(post_r,7)+' '+getfield('t1','post_r','kln','nkl')
   ostlem()
endif
?space(100)+'Лист '+str(lstr,2)
ostlem()
?repl('-',118)
ostlem()
if gnSkl=92
   ?'|  Код  |               Наименование                |Упак.|Изм.|   Цена   |Количество|  Сумма   |'+iif(!empty(dpp_r),'Д.посл.пр.',' Ср.реал. ')+'|'
else
   ?'|  Код  |                  Наименование                   |Изм.|   Цена   |Количество|  Сумма   |'+iif(!empty(dpp_r),'Д.посл.пр.',' Ср.реал. ')+'|'+'Отв.хран. |'
endif
ostlem()
?repl('-',118)
ostlem()
retu

*****************************************************************************
proc ostlem()
*****************************************************************************
ostfwr++
if ostfwr>63
   ostfwr=1
   lstr++
   eject
   if gnOut=1.and.psr#3
      set devi to scre
      wselect(0)
      save scre to scmess
      mess('Вставьте лист и нажмите пробел',1)
      rest scre from scmess
      wselect(wostf)
   endif
   ostshm()
endif
retu
************************************************************************
proc so_endm()
************************************************************************
sumsr=0
retu
************************************************************************
proc go_endm()
************************************************************************
?'   Всего по группе:'+space(68)+str(sumgr,10,2)
sumgr=0
ostlem()
retu
************************************************************************
proc to_endm()
************************************************************************
retu
************************************************************************
proc io_endm()
************************************************************************
?'Итого:'+space(81)+str(sumir,10,2)
ostlem()
sumir=0
retu
*********************
proc dopvedm()
********************
set prin to
if psr#3
   if gnOut=1
      set prin to lpt1
   else
      set prin to txtd.txt
   endif
else
   set print to &vlpt1
endif
set prin on
set cons off
if psr=3
   ??chr(27)+'E'+chr(27)+'&l1h26a0O'+chr(27)+chr(27)+'(3R'+chr(27)+'(s0p17.00h0s1b4102T'+chr(27)  // Книжная А4
else
   if empty(gcPrn)
      ??chr(27)+chr(80)+chr(15)
   else
      ??chr(27)+'E'+chr(27)+'&l1h26a0O'+chr(27)+chr(27)+'(3R'+chr(27)+'(s0p17.00h0s1b4102T'+chr(27)  // Книжная А4
   endif
endif
set devi to print

lstr=1
ostfwr=1
ostshdm()
sele dopv
go top
do while !eof()
   ?iif(mntov=0,space(7),str(mntov,7))+' '+iif(kvp=0,space(10),str(kvp,10,3))+' '+iif(ttn=0,space(6),str(ttn,6))+' '+iif(empty(dot),space(10),dtoc(dot))+' '+iif(ks=0,space(10),str(ks,10,3))+space(25)+iif(mntov1=0,space(9),str(mntov1,9))+' '+iif(kvp1=0,space(10),str(kvp1,10,3))+' '+iif(ttn1=0,space(6),str(ttn1,6))+' '+iif(empty(dot1),space(10),dtoc(dot1))+' '+iif(ks1=0,space(10),str(ks1,10,3))
   ostlemd()
   skip
enddo
if psr=2
   set cons on
   set prin off
   set prin to
   set devi to screen
   edfile('txtd.txt')
   wselect(wostf)
endif
return
*************************
proc ostshdm()
*****************************************************************************

?'       Дополнение к вед. фактических остатков с уч. отгр. '
?'             по складу  '+alltrim(nskl_r)+' на '+dtoc(gdTd)
ostlemd()
?space(110)+'Лист '+str(lstr,2)
ostlem()
?repl('-',50)+space(20)+repl('-',50)
ostlemd()
?'|  Код  |Количество| TTN  |Дата отгр.|Кол-во общ.|                    |  Код  |Количество| TTN  |Дата отгр.|Кол-во общ.|'
ostlemd()
?repl('-',50)+space(20)+repl('-',50)
ostlem()
retu
*****************************************************************************
proc ostlemd()
*****************************************************************************
ostfwr++
if ostfwr>63
   ostfwr=1
   lstr++
   eject
   if gnOut=1.and.psr#3
      set devi to scre
      wselect(0)
      save scre to scmess
      mess('Вставьте лист и нажмите пробел',1)
      rest scre from scmess
      wselect(wostf)
   endif
   ostshdm()
endif
retu

