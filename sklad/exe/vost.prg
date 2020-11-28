#include "common.ch"
#include "inkey.ch"
  // Ведомость остатков с учетом отгруженного товара
  // Формат A4 Пика сжатый
  // h=62 w=140
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
netUse('tov')
if gnMskl=0
   tovizg()
else
   tovtar()
endif
************************************************************
crtt('totv','f:skl c:n(7) f:ktl c:n(9) f:mntov c:n(7) f:kf c:n(10,3)')
sele 0
use totv excl
inde on str(skl,7)+str(ktl,9) tag t1
sele pr1
if netseek('t3','1')
   do while otv=1
      sklr=skl
      mnr=mn
      sele pr2
      if netseek('t1','mnr')
         do while mn=mnr
            ktlr=ktl
            mntovr=mntov
            kfr=kf
            sele totv
            if !netseek('t1','sklr,ktlr')
               netadd()
               netrepl('skl,ktl,mntov,kf','sklr,ktlr,mntovr,kfr')
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
store 1 to psr,pir,fvr
kg_r=999
izg_r=99999999
post_r=9999999
drlz_r=ctod('')
dpp_r=ctod('')
do while .t.
   sele tov
   go top
   if gnMskl=1
      @ 0,1 say 'Подотчетник' get skl_r pict '9999999' valid skl()
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
   @ 8,1 prom 'Факт'
   @ 8,col()+1 prom 'С уч. выписанного'
   @ 8,col()+1 prom 'Факт с уч. отгр.'
   menu to fvr
   if lastkey()=K_ESC
      exit
   endif
   if fvr=1
      @ 9,1 say 'Конечный срок реализации' get drlz_r
      if empty(drlz_r)
         @ 10,1 say 'Дата последнего проихода' get dpp_r
      endif
      read
      if lastkey()=K_ESC
         exit
      endif
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
   vostpod()
endd
wclose(wostf)
setcolor(oclr)
nuse()
nuse('lizg')
nuse('ltar')
nuse('totv')
erase lizg.dbf
erase ltar.dbf
erase ltar.cdx
erase totv.dbf
erase totv.cdx
**************************************************************************
static function kg()
**************************************************************************
*if kg_r=0
   if select('sl')=0
      sele 0
      use _slct alias sl excl
   endif
   sele sl
   zap
if kg_r=0
   sele sgrp
   go top
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
  //   ng_r=getfield('t1','kg_r','sgrp','ngr')
  //   @ 4,18 say n_gr
else
   ng_r=getfield('t1','kg_r','sgrp','ngr')
   @ 6,18 say alltrim(ng_r)
   sele sl
   append blank
   repl kod with str(kg_r,12)
   sele tov
endif
retu .t.

**************************************************************************
static function izg()
**************************************************************************
if izg_r#99999999
   sele lizg
   set orde to tag t1
   locate for izg=izg_r
   if !FOUND()
      set orde to tag t2
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
      //  @ 4,9 say npostr
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
      wselect(0)
      skl_r=slcf('kln',,,,,"e:kkl h:'Код' c:n(7) e:nkl h:'Подотчетник' c:c(20)",'kkl',,,'kkl<10000')
  //      wselect(0)
      if gnSk=106 .or. gnSk=107
         sele ltar
         go top
         do while .t.
            rc_tar=recn()
            skl_r=slcf('ltar',,,,,"e:nskl h:'Наименование' c:c(40) e:skl h:'Код' c:n(7)",'skl')
            if lastkey()=K_ESC.or.lastkey()=K_ENTER
               exit
            endif
            if lastkey()>32.and.lastkey()<255
            //if lastkey()>=65.and.lastkey()<=90.or.lastkey()>=97.and.lastkey()<=122.or.lastkey()>=128.and.lastkey()<=175.or.lastkey()>=224.and.lastkey()<=239
               lstkr=upper(chr(lastkey()))
               seek lstkr
               if !FOUND()
                  go rc_tar
               endif
            endif
         enddo
      endif
  //      skl_r=slcf('kln',,,,,"e:kkl h:'Код' c:n(7) e:nkl h:'Подотчетник' c:c(20)",'kkl',,,'kkl<10000')
   endif
   wselect(wostf)
   nskl_r=getfield('t1','skl_r','kln','nkl')
   @ 0,21 say nskl_r
else
   nskl_r='по всем'
endif
retu .t.

**************************************************************************
proc vostpod
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
      if gnSk=14
  //         apr={'Epson','HP'}
  //         vpr=alert('Выбор принтера',apr)
         if empty(gcPrn)
            ??chr(27)+chr(80)+chr(15)
         else
           ??chr(27)+'E'+chr(27)+'&l1h26a0O'+chr(27)+chr(27)+'(3R'+chr(27)+'(s0p17.00h0s1b4102T'+chr(27)  // Книжная А4
  //         ??chr(27)+'E'+chr(27)+'&l1h26a0O'+chr(27)+chr(27)+'(3R'+chr(27)+'(s0p17.00h0s1b4102T'+chr(27)  // Книжная А4
  //         ??chr(27)+'E'+chr(27)+'&l1h26a0O'+chr(27)+chr(27)+'(3R'+chr(27)+'(s0p20.00h0s0b4099T'+chr(27)  // Книжная А4
         endif
      else
         if empty(gcPrn)
            ??chr(27)+chr(80)+chr(15)
         else
            ??chr(27)+'E'+chr(27)+'&l1h26a0O'+chr(27)+chr(27)+'(3R'+chr(27)+'(s0p17.00h0s1b4102T'+chr(27)  // Книжная А4
         endif
      endif
   endif
endif
set devi to print
sele tov
set orde to tag t2
wlr='!eof()'
frr='.t.'
if fvr=1
   if !empty(drlz_r)
      frr=frr+'.and.drlz<=drlz_r'
   endif
   if !empty(dpp_r)
      frr=frr+'.and.dpp<=dpp_r'
   endif
endif
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
  //         netseek('t2','str(skl_r,4)+str(gnVu,1)+iif(kg_r#0,str(kg_r,3),space(3))',,1)
         netseek('t2','skl_r,kg_r')
         wlr='skl=skl_r.and.int(ktl/1000000)=kg_r'
      endif
   endif
endif
lstr=1
ostfwr=1
ostsh()
prkgr=0
prsklr=0
prktlr=0
prmntovr=0
skl_rr=9997
kg_rr=998
ktl_rr=999999998
mntov_rr=9999998
store 0 to sumtr,sumgr,sumir,sumsr,kmntovr,summr
store 0 to mosvr,mosnr,mosfr,mosfmr,mosvor,mcntr
if gnOut=2.and.psr#3
   set devi to scre
   wselect(0)
   save scre to scmess
   mess('Ждите,идет печать...')
endif
if fvr=3
   if !file('dopv')
      crtt('dopv','f:ktl c:n(9) f:mntov c:n(7) f:kvp c:n(10,3) f:ttn c:n(6) f:dot c:d(8) f:ks c:n(10,3) f:ktl1 c:n(9) f:kvp1 c:n(10,3) f:ttn1 c:n(6) f:dot1 c:d(8) f:ks1 c:n(10,3)')
   else
      erase dopv.dbf
      crtt('dopv','f:ktl c:n(9) f:mntov c:n(7) f:kvp c:n(10,3) f:ttn c:n(6) f:dot c:d(8) f:ks c:n(10,3) f:ktl1 c:n(9) f:kvp1 c:n(10,3) f:ttn1 c:n(6) f:dot1 c:d(8) f:ks1 c:n(10,3)')
   endif
   sele 0
   use dopv
endif

sele tov
if gnMskl=0
   set orde to tag t2
   netseek('t2','skl_r')
endif

outlog(3,__FILE__,__LINE__,'do while wlr',wlr)
outlog(3,__FILE__,__LINE__,'if frr',frr)

prk=0
ch0=0
ch1=0
do while &wlr
   if !&frr
      skip
      loop
   endif
   sklr=skl
   ktlr=ktl
   mntovr=mntov
   kgr=int(ktlr/1000000)
   do case
      case fvr=1
           if osf=0
              sele tov
              skip
              loop
            endif
      case fvr=2
         if osv=0
            sele tov
            skip
            loop
         endif
      case fvr=3
           if osfo=0.and.!netseek('t1','sklr,ktlr','totv')
              sele tov
              skip
              loop
            endif
   endc
***************8888888888888888888888888888888888888
   if fvr=3
      ktlrr=0
      skotg=0
      skotgo=0
      sele rs2
      set order to tag t6
      netseek('t6','ktlr')
      do while ktl=ktlr
         if !empty(getfield('t1','rs2->ttn','rs1','dot')) .and. getfield('t1','rs2->ttn','rs1','prz')=0
            sele dopv
            if prk=0
               append blank
               if ktlrr#ktlr
                  repl ktl with ktlr,mntov with mntovr,kvp with rs2->kvp,ttn with rs2->ttn,dot with getfield('t1','rs2->ttn','rs1','dot')
                  ktlrr=ktlr
               else
                  repl kvp with rs2->kvp,ttn with rs2->ttn,dot with getfield('t1','rs2->ttn','rs1','dot')
               endif
               sele rs2
               skotg=skotg+kvp
               skip
               do while .t.
                  if ktlr=ktl .and.!(!empty(getfield('t1','rs2->ttn','rs1','dot')) .and. getfield('t1','rs2->ttn','rs1','prz')=0)
                     skip
                     loop
                  else
                     exit
                  endif
               enddo
               if ktl#ktlr
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
               if ktlrr#ktlr
                  repl ktl1 with ktlr,mntov with mntovr,kvp1 with rs2->kvp,ttn1 with rs2->ttn,dot1 with getfield('t1','rs2->ttn','rs1','dot')
                  ktlrr=ktlr
               else
                  repl kvp1 with rs2->kvp,ttn1 with rs2->ttn,dot1 with getfield('t1','rs2->ttn','rs1','dot')
               endif
               sele rs2
               skotg=skotg+kvp
               skip
               do while .t.
                  if ktlr=ktl .and.!(!empty(getfield('t1','rs2->ttn','rs1','dot')) .and. getfield('t1','rs2->ttn','rs1','prz')=0)
                     skip
                     loop
                  else
                     exit
                  endif
               enddo
               if ktl#ktlr
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
      sele tov
   endif
*******************
   if ktl_rr#ktlr.or.skl_rr#sklr
      if prktlr=1  // Закрыть предыдущий KTL
  //         to_end()
         prktlr=0
      endif
      ktl_rr=ktlr
   endif
   if mntov_rr#mntovr.or.skl_rr#sklr
      if prmntovr=1  // Закрыть предыдущий MNTOV
         to_end()
         prmntovr=0
         summr=0
         store 0 to mosvr,mosnr,mosfr,mosfmr,mosvor,mcntr
      endif
      mntov_rr=mntovr
   endif
   if kg_rr#kgr.or.skl_rr#sklr
      if prkgr=1 // Закрыть предыдущую группу
         go_end()
         prkgr=0
      endif
      kg_rr=kgr
   endif
   if skl_rr#sklr   // Смена мультисклада
      if gnMskl#0
         if prsklr=1 // Закрыть предыдущий мультисклад
            so_end()
            prsklr=0
         endif
      endif
      skl_rr=sklr
   endif
   if gnMskl#0
      if prsklr=0 // Открыть новый мультисклад
         if gnout=2.and.psr#3
            @ 24,1 say str(sklr,7)+' '+getfield('t1','sklr','kln','nkl') color 'g/n'
         endif
         ?space(5)+str(sklr,7)+' '+getfield('t1','sklr','kln','nkl')
         ostle()
         prsklr=1
      endif
   endif
   if prkgr=0 // Открыть новую группу
  //      kg_rrr=kgr
      if gnout=2.and.psr#3
         @ 24,40 say str(kg_rr,3)+' '+getfield('t1','kg_rr','sgrp','ngr') color 'g/n'
      endif
      ?str(kgr,3)+' '+getfield('t1','kg_rr','sgrp','ngr')
      ostle()
      prkgr=1
   endif
   sele tov
   if prktlr=0  // Открыть новый KTL
      prktlr=1
   endif
   if prmntovr=0  // Открыть новый MNTOV
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
   kfr=getfield('t1','sklr,ktlr','totv','kf')
   if gnCtov=1
      mosvr=mosvr+osv
      mosfr=mosfr+osf
      mosfmr=mosfmr+osfm
      mosvor=mosvor+osvo
   endif
   drlzr=drlz
   dppr=dpp
   if fvr=1
      sumtr=ROUND(osfr*optr,2)
   else
      if fvr=2
         sumtr=ROUND(osvr*optr,2)
      else
         sumtr=ROUND((osfr-skotgo)*optr,2)
         osfr=osfr-skotgo
         mosfr=mosfr-skotgo
      endif
   endif

   summr=summr+sumtr
   sumgr=sumgr+sumtr
   sumsr=sumsr+sumtr
   sumir=sumir+sumtr
   if pir=1.and.(abs(osfr)+abs(kfr))#0
      natr=subs(alltrim(getfield('t1','kger','GrpE','nge'))+' '+natr,1,50)
      if !empty(dpp_r)
         dtr=iif(!empty(dppr),dtoc(dppr),'')
      else
         dtr=iif(!empty(drlzr),dtoc(drlzr),space(10))
      endif
      if gnSkl=92.and.upak<>0
         upakr=str(upak,5)
  //         ?str(ktlr,9)+' '+substr(natr,1,43)+' '+upakr+'  '+subs(neir,1,4)+' '+str(optr,10,3)+' '+iif(fvr=1,str(osfr,10,3),str(osvr,10,3))+' '+str(sumtr,10,2)+' '+dtr
         ?str(ktlr,9)+' '+substr(natr,1,43)+' '+upakr+'  '+subs(neir,1,4)+' '+str(optr,10,3)+' '+iif(fvr=1.or.fvr=3,str(osfr,10,3),str(osvr,10,3))+' '+str(sumtr,10,2)+' '+dtr
      else
  //         ?str(ktlr,9)+' '+natr+' '+subs(neir,1,4)+' '+str(optr,10,3)+' '+iif(fvr=1,str(osfr,10,3),str(osvr,10,3))+' '+str(sumtr,10,2)+' '+dtr
         ?str(ktlr,9)+' '+natr+' '+subs(neir,1,4)+' '+str(optr,10,3)+' '+iif(fvr=1.or.fvr=3,str(osfr,10,3),str(osvr,10,3))+' '+str(sumtr,10,2)+' '+dtr
      endif
      if kfr#0
         ??' '+str(kfr,10,3)
      endif
      ostle()
      mcntr=mcntr+1
   endif
   sele tov
   skip
endd
to_end()
go_end()
so_end()
io_end()
?repl('-',107)
ostle()
eject
*******
if fvr=3
   avv={'Да','Нет'}
   vv=alert('Печать дополнения',avv)
   if vv=1
      dopved()
   endif
   nuse('dopv')
   erase dopv.dbf
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
proc ostsh()
*****************************************************************************
?'Ведомость '+iif(fvr=1,'фактических остатков ',iif(fvr=2,'остатков с уч.вып. ','остатков с уч. отгр  '))+alltrim(nskl_r)+' на '+dtoc(gdTd)+' '+dtoc(date())+' '+time()
ostle()
if izg_r#0
   ?'По изготовителю '+str(izg_r,8)+' '+getfield('t1','izg_r','kln','nkl')
   ostle()
endif
if post_r#0
   ?'По поставщику '+str(post_r,7)+' '+getfield('t1','post_r','kln','nkl')
   ostle()
endif
if !empty(drlz_r)
   ?'Дата реализации '+dtoc(drlz_r)
   ostle()
endif
if !empty(dpp_r)
   ?'Дата последнего прихода не выше '+dtoc(dpp_r)
   ostle()
endif
?space(100)+'Лист '+str(lstr,2)
ostle()
?repl('-',118)
ostle()
if gnSkl=92
   ?'|  Код  |               Наименование                |Упак.|Изм.|   Цена   |Количество|  Сумма   |'+iif(!empty(dpp_r),'Д.посл.пр.',' Ср.реал. ')+'|'
else
   ?'|  Код  |                  Наименование                   |Изм.|   Цена   |Количество|  Сумма   |'+iif(!empty(dpp_r),'Д.посл.пр.',' Ср.реал. ')+'|'+'Отв.хран. |'
endif
ostle()
?repl('-',118)
ostle()
retu

*****************************************************************************
proc ostle()
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
   ostsh()
endif
retu
************************************************************************
proc so_end()
************************************************************************
if gnMskl=1
   ?'Всего по подотчетнику:'+space(65)+str(sumsr,10,2)
   ostle()
endif
sumsr=0
retu
************************************************************************
proc go_end()
************************************************************************
?'   Всего по группе:'+space(68)+str(sumgr,10,2)
sumgr=0
ostle()
retu
************************************************************************
proc to_end()
************************************************************************
if pir=1.and.gnCtov=1.and.summr#0.and.mcntr>1
   ?'Всего по товару :'+space(44)+' '+space(4)+' '+space(9)+' '+iif(fvr=1.or.fvr=3,str(mosfr,10,3),str(mosvr,10,3))+' '+str(summr,10,2)
   ostle()
endif
retu
************************************************************************
proc io_end()
************************************************************************
?'Итого:'+space(81)+str(sumir,10,2)
ostle()
sumir=0
retu
*********************
proc dopved()
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
ostshd()
sele dopv
go top
do while !eof()
   ?iif(ktl=0,space(9),str(ktl,9))+' '+iif(kvp=0,space(10),str(kvp,10,3))+' '+iif(ttn=0,space(6),str(ttn,6))+' '+iif(empty(dot),space(10),dtoc(dot))+' '+iif(ks=0,space(10),str(ks,10,3))+space(25)+iif(ktl1=0,space(9),str(ktl1,9))+' '+iif(kvp1=0,space(10),str(kvp1,10,3))+' '+iif(ttn1=0,space(6),str(ttn1,6))+' '+iif(empty(dot1),space(10),dtoc(dot1))+' '+iif(ks1=0,space(10),str(ks1,10,3))
   ostled()
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
proc ostshd()
*****************************************************************************

?'       Дополнение к вед. фактических остатков с уч. отгр. '
?'             по складу  '+alltrim(nskl_r)+' на '+dtoc(gdTd)
ostled()
?space(110)+'Лист '+str(lstr,2)
ostle()
?repl('-',50)+space(20)+repl('-',50)
ostled()
?'|  Код  |Количество| TTN  |Дата отгр.|Кол-во общ.|                    |  Код  |Количество| TTN  |Дата отгр.|Кол-во общ.|'
ostled()
?repl('-',50)+space(20)+repl('-',50)
ostle()
retu
*****************************************************************************
proc ostled()
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
   ostshd()
endif
retu
**************
func kspovo()
**************
asvkr=savesetkey()
set key -1 to
set key -2 to
set key -3 to
set key -4 to
sele kspovo
if !netseek('t1','kspovor').or.kspovor=0
   go top
   rckspovor=recn()
   do while .t.
      sele kspovo
      go rckspovor
      foot('','')
      rckspovor=slcf('kspovo',,,,,"e:kod h:'Код' c:n(4) e:uk h:'Наименование' c:c(40) e:upu h:'Сокращение' c:c(20)",,,,,'ud=0')
      if lastkey()=K_ESC // Отмена
         exit
      endif
      sele kspovo
      go rckspovor
      kspovor=kod
      upur=upu
      if lastkey()=K_ENTER // Выбрать
         @ 8,37 say subs(upur,1,8)
         exit
      endif
   endd
else
   upur=upu
   @ 8,37 say subs(upur,1,8)
endif
restsetkey(asvkr)
retu .t.
***************
func skspovo()
***************
clea
netuse('kspovo')
sele kspovo
go top
rckspovor=recn()
do while .t.
   sele kspovo
   go rckspovor
   foot('Пробел,INS,F4,DEL','Пок/НеПок,Доб,Корр,Уд')
   rckspovor=slcf('kspovo',,,,,"e:kod h:'Код' c:n(4) e:uk h:'Наименование' c:c(40) e:upu h:'Сокращение' c:c(20) e:ud h:'Не показ' c:n(1)",,,1)
   if lastkey()=K_ESC // Отмена
      exit
   endif
   sele kspovo
   go rckspovor
   kspovor=kod
   upur=upu
   udr=ud
   kodr=kod
   dprr=dpr
   coeir=coei
   ukr=uk
   upur=upu
   upmr=upm
   zvur=zvu
   dpur=dpu
   if lastkey()=K_ESC
      exit
   endif
   do case
      case lastkey()=K_SPACE.and.kspovor#0
           if udr=0
              netrepl('ud','1')
           else
              netrepl('ud','0')
           endif
    case lastkey()=K_DEL // del
         netdel()
         skip -1
         if bof()
            go top
         endif
         rckspovor=recn()
    case lastkey()=K_F4 // corr
         kspins(1)
    case lastkey()=K_INS // ins
         kspins(0)
   endc
endd
nuse()
retu .t.
*****************
func kspins(p1)
*****************
if p1=0
   store 0 to kodr,dprr,coeir
   ukr=space(40)
   upur=space(20)
   upmr=space(4)
   zvur=space(4)
   dpur=space(4)
endif
clbs=setcolor('gr+/b,n/w')
wbs=wopen(10,10,21,70)
wbox(1)
do while .t.
   if p1=0
      @ 0,1 say 'Код         ' get kodr pict '9999'
   else
      @ 0,1 say 'Код         '+' '+str(kodr,4)
   endif
   @ 1,1 say 'Наименование' get ukr
   @ 2,1 say 'Сокращение  ' get upur
   @ 3,1 say 'UPM         ' get upmr
   @ 4,1 say 'DPR         ' get dprr pict '9999'
   @ 5,1 say 'ZVU         ' get zvur
   @ 6,1 say 'DPU         ' get dpur
   @ 7,1 say 'COEI        ' get coeir pict '9999'
   @ 8,1 prom '<Верно>'
   @ 8,col()+1 prom '<Не верно>'
   read
   if lastkey()=K_ESC
      exit
   endif
   menu to mbsr
   if mbsr=1
      if p1=0
         if !netseek('t1','kodr')
            netadd()
            netrepl('kod,uk,upu,upm,dpr,zvu,dpu,coei','kodr,ukr,upur,upmr,dprr,zvur,dpur,coeir')
            rckspovor=recn()
            exit
         else
            wmess('Такой счет существует',1)
         endif
      else
         if netseek('t1','kodr')
            netrepl('kod,uk,upu,upm,dpr,zvu,dpu,coei','kodr,ukr,upur,upmr,dprr,zvur,dpur,coeir')
            exit
         endif
      endif
   endif
enddo
wclose()
setcolor(clbs)
retu .t.

*************
func kprod()
  *************
  clea
  netuse('kprod')
  sele kprod
  go top
  rckprodr=recn()
  do while .t.
     sele kprod
     go rckprodr
     foot('INS,F4,DEL','Доб,Корр,Уд')
     rckprodr=slcf('kprod',1,0,18,,"e:kod h:'Код' c:n(10) e:ukt h:'УКТ ЗЕД' c:c(10) e:vid h:'Вид' c:c(60)",,,1,,,,'Коды продукции')
     if lastkey()=K_ESC // Отмена
        exit
     endif
     sele kprod
     go rckprodr
     kodr=kod
     uktr=ukt
     vidr=vid
     do case
        case lastkey()=K_DEL // 7 del
             netdel()
             skip -1
             if bof()
                go top
             endif
             rckprodr=recn()
        case lastkey()=K_F4 // -3 corr
             kprins(1)
        case lastkey()=K_INS // ins
             kprins(0)
     endc
  endd
  nuse('kprod')
  retu .t.

****************
func kprins(p1)
****************
if empty(p1)
   kodr=0
   uktr=space(10)
   vidr=space(60)
endif
clbs=setcolor('gr+/b,n/w')
wbs=wopen(10,10,15,70)
wbox(1)
do while .t.
   @ 0,1 say 'Код    ' get kodr pict '9999999999'
   @ 1,1 say 'УКТ ЗЕД' get uktr
   @ 2,1 say 'Вид' get vidr
   @ 3,1 prom '<Верно>'
   @ 3,col()+1 prom '<Не верно>'
   read
   if lastkey()=K_ESC
      exit
   endif
   menu to mbsr
   if mbsr=1
      if p1=0
         if !netseek('t1','kodr')
            netadd()
            netrepl('kod,ukt,vid','kodr,uktr,vidr')
            rckprodr=recn()
            exit
         else
            wmess('Такой код существует',1)
         endif
      else
         netrepl('kod,ukt,vid','kodr,uktr,vidr')
         exit
      endif
   endif
enddo
wclose()
setcolor(clbs)
retu .t.
