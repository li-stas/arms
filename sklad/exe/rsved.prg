#include "common.ch"
#include "inkey.ch"

*Ведомость расхода
* Формат A4 Пика сжатый
* h=62 w=140
set colo to g/n,n/g,,,
clea
kk=2
vlpt1='lpt1'
netuse('rs1')
netuse('rs3')
netuse('kln')
netuse('soper')
netuse('bs')
netuse('dclr')
*if file('itog.dbf')
   erase itog.dbf
   erase itog.cdx
   erase itog.idx
*endif
tt='f:skl c:n(7) f:kpl c:n(7) f:kop c:n(3) '
do while !eof()
   kzr=kz
   tt=tt+'f:z'+str(kzr,2)+' c:n(12,2) '
   skip
endd
nuse('dclr')
sele 0
crtt('itog',tt)
sele 0
use itog excl
inde on str(skl,7)+str(kpl,7)+str(kop,3) tag t1
*set orde to tag t1

store 0 to ttnr,sum10r,sum19r,sum40r,sum20r,sum62r,sum90r
kpl_r=9999999
kop_r=999
store '' to nkpl_r,nkop_r,nskl_r
if gnMskl=0
   skl_r=gnSkl
else
   skl_r=9998
endif
dt1_r=gdTd //bom(gdTd)
dt2_r=gdTd
store 1 to pir,psr,mtv_r

oclr=setcolor('gr+/b,n/w')
wvrs=wopen(5,10,18,70)
wbox(1)
do while .t.
   sele itog
   zap
   dt1or=dt1_r
   dt2or=dt2_r
   sklor=skl_r
   kplor=kpl_r
   kopor=kop_r
   @ 1,1 say 'С ' get dt1_r
   @ 1,col()+1 say ' по' get dt2_r
   read
   if lastkey()=K_ESC
      exit
   endif
   @ 2,1 say 'Тип документов:'
   @ 2,17 prom '<Подтв.>'
   @ 2,col()+1 prom '<Отгр.>'
   @ 2,col()+1 prom '<Подтв.+Отгр.>'
   menu to mtv_r
   if lastkey()=K_ESC
      exit
   endif

   if select('lrs1')=0
      sele rs1
      copy stru to lrs1
   else
      sele lrs1
      use
      erase lrs1.dbf
      sele rs1
      copy stru to lrs1
   endif
   sele 0
   use lrs1 excl
   sele rs1
   go top
   do while !eof()
*if ttn=302290
*wait
*endif
      if !(dot>=dt1_r.and.dot<=dt2_r)
         skip
         loop
      endif
      do case
         case mtv_r=1    // Подтвержденные
              if prz#1
                 skip
                 loop
              endif
         case mtv_r=2    // Отгруженные
              if !(prz=0.and.!empty(dot))
                 skip
                 loop
              endif
         case mtv_r=3    // Подтв.+Отгр.
              if empty(dot)
                 skip
                 loop
              endif
      endc
      vor=vo
      sklr=skl
      kplr=kpl
      kgpr=kgp
      arec:={}
      getrec()
      sele lrs1
      appe blank
      putrec()
      if vor=5.or.vor=7.or.vor=8
         repl kpl with gnKkl_c,skl with gnSkl
      endif
      sele rs1
      skip
   endd
   sele lrs1
   if gnMskl=1
      @ 3,1 say 'Склад    ' get skl_r pict '9999999' valid skl()
      @ 4,1 say '9998 - по всем'
   else
      @ 3,1 say 'Склад '+gcNskl
   endif
   @ 5,1 say 'Плательщик' get kpl_r pict '9999999' valid kpl()
   @ 6,1 say '9999999 - по всем'
   @ 7,1 say 'Код операции' get kop_r pict '999' valid kop()
   @ 8,1 say '999 - по всем'
   read
   if lastkey()=K_ESC
      exit
   endif
   @ 9,1 prom 'Полн.'
   @ 9,col()+1 prom 'Итоги'
   if gnEnt=20
      @ 9,col()+1 prom 'Полно. без сз'
      @ 9,col()+1 prom 'Полно. без S'
   endif
   menu to pir
   if lastkey()=K_ESC
      exit
   endif
   @ 10,1 prom 'Печать'
   @ 10,col()+1 prom 'Экран'
***********
   if gnSpech=1 .or. gnAdm=1
      @ 10,col()+1 prom 'Сет. печать'
   endif
   menu to psr
   if psr=3
      @ 10,26 say 'Кол-во экз.' get kk pict '9'
      read
      alpt={'lpt2','lpt3'}
      vlpt=alert('ПЕЧАТЬ НА СЕТЕВОЙ ПРИНТЕР',alpt)
      do case
         case vlpt=1
              vlpt1='lpt2'
         case vlpt=2
              vlpt1='lpt3'
//         case vlpt=3
//              vlpt1='l pt4'
      endc
   endif
   if lastkey()=K_ESC
      exit
   endif
   sele lrs1
   if recc()=0
      wselect(0)
      save scre to scmess
      mess('Нет документов для этих условий',3)
      rest scre from scmess
      wselect(wvrs)
      loop
   endif
   if psr=3
      kkr=0
      do while kkr<kk
         sele itog
         zap
         vrs()
         kkr=kkr+1
      enddo
   else
      vrs()
   endif
endd
wclose(wvrs)
setcolor(oclr)

nuse()

if select('lrs1')#0
   sele lrs1
   use
endif
erase lrs1.dbf
erase lrs1.cdx

if select('itog')#0
   sele itog
   use
endif
erase itog.dbf
erase itog.cdx

if select('lskl1')#0
   sele lskl1
   use
endif
erase lskl1.dbf

**************************************************************************
static function skl()
**************************************************************************
if skl_r#9998
   if select('lskl1')=0
      sele lrs1
      go top
      total on skl field sdv to lskl1
   else
      if sklor#skl_r
         sele lskl1
         use
         sele lrs1
         go top
         total on skl field sdv to lskl1
      endif
   endif
   sele 0
   use lskl1 excl
   LOCATE FOR skl=skl_r
   if !FOUND()
      go top
   endif
   wselect(0)
   skl_r=slcf('lskl1',,,,,"e:skl h:'Склад' c:n(7) e:getfield('t1','lskl1->skl','kln','nkl') h:'Наименование' c:c(30)",'skl')
   if lastkey()=K_ESC
      skl_r=0
   endif
   wselect(wvrs)
   nskl_r=getfield('t1','skl_r','kln','nkl')
   @ 1,18 say nskl_r
else
   nskl_r='по всем'
endif
retu .t.

**************************************************************************
static function kpl()
**************************************************************************
if kpl_r#9999999
   sele lrs1
   if skl_r#9998
*      inde on str(skl,7)+str(kpl,7) to lrs1 uniq
      inde on str(skl,7)+str(kpl,7) tag t1
*      set orde to tag t1
      if !netseek('t1','skl_r,kpl_r')
         netseek('t1','skl_r')
      endif
      wlr='skl=skl_r'
   else
*      inde on str(kpl,7) to lrs1 uniq
      inde on str(kpl,7) tag t1
*      set orde to tag t1
      if !netseek('t1','kpl_r')
         go top
      endif
      wlr=nil
   endif
   wselect(0)
   kpl_r=slcf('lrs1',,,,,"e:kpl h:'Код' c:n(7) e:getfield('t1','lrs1->kpl','kln','nkl') h:'Поставщик' c:c(30)",'kpl',,,wlr)
   if lastkey()=K_ESC
      kpl_r=0
   endif
   wselect(wvrs)
   nkpl_r=getfield('t1','kpl_r','kln','nkl')
   @ 3,20 say nkpl_r
else
   nkpl_r='по всем'
endif
sele lrs1
set inde to
go top
retu .t.
**************************************************************************
static function kop()
**************************************************************************
if kop_r#999
   sele lrs1
   do case
      case skl_r=9998.and.kpl_r=9999999
           inde on str(kop,3) tag t1
*           set order to tag t1
           if !netseek('t1','kop_r')
              go top
           endif
           wlr=nil
      case skl_r=9998.and.kpl_r#9999999
           inde on str(kpl,7)+str(kop,3) tag t1
*           set order to tag t1
           if !netseek('t1','kpl_r,kop_r')
              netseek('t1','kpl_r')
           endif
           wlr='kpl=kpl_r'
      case skl_r#9998.and.kpl_r=9999999
           inde on str(skl,7)+str(kop,3) tag t1
*           set order to tag t1
           if !netseek('t1','skl_r,kop_r')
              netseek('t1','skl_r')
           endif
           wlr='skl=skl_r'
      case skl_r#9998.and.kpl_r#9999999
           inde on str(skl,7)+str(kpl,7)+str(kop,3) tag t1
*           set order to tag t1
           if !netseek('t1','skl_r,kpl_r,kop_r')
              netseek('t1','skl_r,kpl_r')
           endif
           wlr='skl=skl_r.and.kpl=kpl_r'
   endc
   wselect(0)
   kop_r=slcf('lrs1',,,,,"e:kop h:'Код' c:n(3) e:getfield('t1','1,1,0,mod(lrs1->kop,100)','soper','nop') h:'Операция' c:c(40)",'kop',,,wlr)
   if lastkey()=K_ESC
      kop_r=0
   endif
   wselect(wvrs)
   nkop_r=getfield('t1','1,1,0,mod(kop_r,100)','soper','nop')
   @ 3,19 say nkop_r
endif
retu .t.

************************************************************************
proc vrs()
  ************************************************************************
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
  *?chr(27)+chr(80)+chr(15)
  if psr=3
     ?chr(27)+'E'+chr(27)+'&l1h26a0O'+chr(27)+chr(27)+'(3R'+chr(27)+'(s0p17.00h0s1b4102T'+chr(27)  // Книжная А4
  else
     if empty(gcPrn)
        ??chr(27)+chr(80)+chr(15)
     else
        ??chr(27)+'E'+chr(27)+'&l1h26a0O'+chr(27)+chr(27)+'(3R'+chr(27)+'(s0p16.00h0s0b4099T'+chr(27)  // Книжная А4
     endif
  *   if gnVttn=1.or.gnEnt=14
  *      apr={'Epson','HP'}
  *      vpr=alert('Выбор принтера',apr)
  *      if vpr=1
  *         ??chr(27)+chr(80)+chr(15)
  *      else
  *        ??chr(27)+'E'+chr(27)+'&l1h26a0O'+chr(27)+chr(27)+'(3R'+chr(27)+'(s0p16.00h0s0b4099T'+chr(27)  // Книжная А4
  **        ??chr(27)+'E'+chr(27)+'&l4h2a0O'+chr(27)+'&k2S'+chr(27)+'&a20l'+chr(27)+'(3R'+chr(27)+'(s0p17.00h0s0b4099T'+chr(27)
  *      endif
  *    else
  *      ??chr(27)+chr(80)+chr(15)
  *    endif
  endif
  set devi to print
  if gnOut=2.and.psr#3
     set devi to scre
     wselect(0)
     save scre to scmess
     mess('Ждите,идет печать...')
  endif
  sele lrs1
  if indexord()=0
     inde on str(skl,7)+str(kpl,7)+dtos(dot)+str(ttn,6) tag t1
  endif
  *set order to tag t1
  go top
  do case
     case skl_r=9998.and.kpl_r=9999999
          if kop_r=999
             frr='.t.'
          else
             frr='kop=kop_r'
          endif
     case skl_r=9998.and.kpl_r#9999999
          if kop_r=999
             frr='kpl=kpl_r'
          else
             frr='kpl=kpl_r.and.kop=kop_r'
          endif
     case skl_r#9998.and.kpl_r=9999999
          if kop_r=999
             frr='skl=skl_r'
          else
             frr='skl=skl_r.and.kop=kop_r'
          endif
     case skl_r#9998.and.kpl_r#9999999
          if kop_r=999
             frr='skl=skl_r.and.kpl=kpl_r'
          else
             frr='skl=skl_r.and.kpl=kpl_r.and.kop=kop_r'
          endif
  endc
  lstr=1
  prsklr=0
  prkplr=0
  vrswr=0
  skl_rr=9997
  kpl_rr=0
  vrssh()
  nppr=1
  pskplr=1   // Признак для печати итога по плательщику(счетчик)
  pssklr=1   // Признак для печати итога по подотчетникам
  go top
  do while !eof()
     store 0 to ndr,ttnr,sum10r,sum19r,sum40r,sum20r,sum61r,sum90r
     sele lrs1
     if !&frr
        skip
        loop
     endif
     ttnr=ttn
     dotr=dot
     kopr=kop
     kplr=kpl
     sklr=skl
     vor=vo
     przr=prz
     if gnMskl=1
      if sklr#skl_rr
        do case
           case prsklr=0  // Новый склад
                ?str(sklr,7)+' '+getfield('t1','sklr','kln','nkl')
                vrsle()
                prsklr=1
                kpl_rr=0
           case prsklr=1  // Итоги
                if prkplr#0.and.(pir=1.or.pir=3.or.pir=4).and.pssklr>1
                   itogr(skl_rr,kpl_rr)  // Итог по поставщику
                   prkplr=0
                endif
                if prkplr#0.and.(pir=1.or.pir=3.or.pir=4)
                   prkplr=0
                endif
                if gnMskl=1.and.pssklr>1
                   itogr(skl_rr,9999999)  // Итог по складу
                   pssklr=1
                endif
                prsklr=0
                sele lrs1
                loop
        endc
        skl_rr=sklr
      else
        pssklr++
      endif
     endif
     if kpl_rr#kplr
        do case
           case prkplr=0.and.(pir=1.or.pir=3.or.pir=4)    // Новый поставщик
                if gnout=2 .and. psr#3
                   @ 24,1 say str(kplr,7)+'('+alltrim(str(getfield('t1','kplr','kln','kkl1'),10))+')'+' '+getfield('t1','kplr','kln','nkl') color 'g/n'
                endif
                ?'Плательщик '+str(kplr,7)+'('+alltrim(str(getfield('t1','kplr','kln','kkl1'),10))+')'+' '+getfield('t1','kplr','kln','nkl')
                vrsle()
                prkplr=1
           case prkplr=1.and.(pir=1.or.pir=3.or.pir=4)    // Переход к следующему
                prkplr=0
                sele lrs1
                loop
           case prkplr=1.and.(pir=1.or.pir=3.or.pir=4).and.pskplr>1    // Итоги по поставщику
                itogr(sklr,kpl_rr)  // Итог по поставщику
                prkplr=0
                pskplr=1
                sele lrs1
                loop
        endc
        kpl_rr=kplr
     else
        pskplr++
     endif

     sum10r=getfield('t1','ttnr,10','rs3','ssf')
     sum19r=getfield('t1','ttnr,19','rs3','ssf')
     sum20r=getfield('t1','ttnr,20','rs3','ssf')
     sum40r=getfield('t1','ttnr,40','rs3','ssf')
     sum61r=getfield('t1','ttnr,61','rs3','ssf')
     sum90r=getfield('t1','ttnr,90','rs3','ssf')

     additr(sklr,kplr,999)    // Итоги по kpl
     additr(sklr,kplr,kopr)    // Итоги по kpl,kop
     if gnMskl=1
        additr(sklr,9999999,999)  // Итоги по skl
        additr(sklr,9999999,kopr) // Итоги по skl,kop
     endif
     additr(9998,9999999,999)  // Итоги полные
     additr(9998,9999999,kopr) // Итоги полные,kop

     sele rs3
     cntkszr=0
     onerecr=0
     if netseek('t1','ttnr')
        sumr=0
        do while ttn=ttnr
           sele rs3
           if ksz=10.or.ksz=19.or.ksz=20.or.ksz=40.or.ksz=61.or.ksz=90
              skip
              loop
           endif
           kszr=ksz
           sumr=ssf
           tt='z'+str(kszr,2)
           sele itog
           if fieldpos(tt)=0
              sele rs3
              skip
              loop
           endif
           if !netseek('t1','sklr,kplr,999')
              netadd()
              netrepl('skl,kpl,kop,&tt','sklr,kplr,999,sumr',,1)
           else
              sumrr=&tt+sumr
              netrepl('&tt','sumrr',,1)
           endif
           if !netseek('t1','sklr,kplr,kopr')
              netadd()
              netrepl('skl,kpl,kop,&tt','sklr,kplr,kopr,sumr',,1)
           else
              sumrr=&tt+sumr
              netrepl('&tt','sumrr',,1)
           endif
           if gnMskl=1
              if !netseek('t1','sklr,9999999,999')
                 netadd()
                 netrepl('skl,kpl,kop,&tt','sklr,9999999,999,sumr',,1)
              else
                 sumrr=&tt+sumr
                 netrepl('&tt','sumrr',,1)
              endif
              if !netseek('t1','sklr,9999999,kopr')
                 netadd()
                 netrepl('skl,kpl,kop,&tt','sklr,9999999,kopr,sumr',,1)
              else
                 sumrr=&tt+sumr
                 netrepl('&tt','sumrr',,1)
              endif
           endif
           if !netseek('t1','9998,9999999,999')
              netadd()
              netrepl('skl,kpl,kop,&tt','9998,9999999,999,sumr',,1)
           else
              sumrr=&tt+sumr
              netrepl('&tt','sumrr',,1)
           endif
           if !netseek('t1','9998,9999999,kopr')
              netadd()
              netrepl('skl,kpl,kop,&tt','9998,9999999,kopr,sumr',,1)
           else
              sumrr=&tt+sumr
              netrepl('&tt','sumrr',,1)
           endif
           if onerecr=0
              if pir=1.or.pir=3.or.pir=4
                 ?' '+str(nppr,5)+' '+dtoc(dotr)+' '+str(ttnr,6)
                 If !(pir=4)
                   ??' '+iif(sum10r#0,str(sum10r,12,2),space(10))+' '+iif(sum19r#0,str(sum19r,10,2),space(10))+' '+iif(sum20r#0,str(sum20r,10,2),space(10))+' '+iif(sum40r#0,str(sum40r,10,2),space(10))+' '+iif(sum61r#0,str(sum61r,10,2),space(10))+' '+iif(sumr#0,str(kszr,2),space(2))+' '+iif(sumr#0,str(sumr,12,2),space(12))+' '+iif(sum90r#0,str(sum90r,12,2),space(10))+' '+str(kopr,3)+' '+str(przr,1)
                 EndIf
                 nppr++
                 vrsle()
                 onerecr=1
              endif
           else
              if pir=1
                 if sumr#0
                    ?' '+space(5)+' '+space(10)+' '+space(6)+' '+space(12)+' '+space(10)+' '+space(10)+' '+space(10)+' '+space(10)+' '+str(kszr,2)+' '+str(sumr,12,2)+' '+space(10)+' '+space(3)
                    vrsle()
                 endif
              endif
           endif
           cntkszr++
           sele rs3
           skip
        endd
        if cntkszr=0
           if pir=1.or.pir=3.or.pir=4
              ?' '+str(nppr,5)+' '+dtoc(dotr)+' '+str(ttnr,6)
              If !(pir=4)
                ??' '+iif(sum10r#0,str(sum10r,12,2),space(10))+' '+iif(sum19r#0,str(sum19r,10,2),space(10))+' '+iif(sum20r#0,str(sum20r,10,2),space(10))+' '+iif(sum40r#0,str(sum40r,10,2),space(10))+' '+iif(sum61r#0,str(sum61r,10,2),space(10))+' '+space(2)+' '+space(12)+' '+iif(sum90r#0,str(sum90r,12,2),space(10))+' '+str(kopr,3)+' '+str(przr,1)
              EndIf
              nppr++
              vrsle()
           endif
        endif
     endif
     sele lrs1
     skip
  endd
  if (pir=1.or.pir=3.or.pir=4).and.pskplr>1
    itogr(sklr,kplr)  // Итог по поставщику
    if gnMskl=1
        itogr(sklr,9999999)  // Итог по складу
    endif
  endif
  itogr(9998,9999999)    // Общий итог
  eject
  if gnOut=2.and.psr#3
     rest scre from scmess
     wselect(wvrs)
  endif
  set cons on
  set prin off
  set prin to
  set devi to screen
  if psr=2
     wselect(0)
     edfile('txt.txt')
     wselect(wvrs)
  endif
  retu
*****************************************************************************
proc vrsle()
*****************************************************************************
vrswr++
if vrswr>61 // 63
   vrswr=1
   lstr++
   eject
   if gnOut=1
      set devi to scre
      wselect(0)
      save scre to scmess
      mess('Вставьте лист и нажмите пробел',1)
      rest scre from scmess
      wselect(wvrs)
   endif
   vrssh()
endif
retu
***************************************************************************
proc vrssh()
  ***************************************************************************
  if gnMskl=0.or.skl_r=9998
     ?'Ведомость расхода со склада '+gcNskl
  else
     ?'Ведомость расхода со склада '+nskl_r
  endif
  ??' ('+iif(mtv_r=1,'Подтв.',iif(mtv_r=2,'Отгр.','Подтв.+Отгр'))+')'
  vrsle()
  ?' С '+dtoc(dt1_r)+' по '+dtoc(dt2_r)
  vrsle()
  if kpl_r#9999999
     ?' По плательщику '+str(kpl_r,7)+' '+nkpl_r
     vrsle()
  endif
  if kop_r#999
     ?' Операция '+str(kop_r,7)+' '+nkop_r
     vrsle()
  endif
  ?space(100)+'Лист '+str(lstr,3)
  vrsle()
  ?'┌─────┬──────────┬──────┬────────────┬──────────┬──────────┬──────────┬──────────┬──┬────────────┬────────────┬───┐'
  vrsle()
  ?'│  N  │   Дата   │ ТТН  │   Товар    │  Тара    │ Скидка   │ Наценка  │Транспорт.│К │   Сумма    │  По докум. │КОП│'
  vrsle()
  ?'│ п/п │ расхода  │      │            │          │          │ поставщ. │ расходы  │С │            │  поставщ.  │   │'
  vrsle()
  ?'│     │          │      │            │          │          │          │          │З │            │            │   │'
  vrsle()
  ?'├─────┼──────────┼──────┼────────────┼──────────┼──────────┼──────────┼──────────┼──┼────────────┼────────────┼───┤'
  vrsle()
  retu

****************************************************************************
proc itogr(p1,p2)
  ****************************************************************************
  priv skl1r,kpl1r
  skl1r=p1
  kpl1r=p2
  z90r=0
  bbb='В т.ч. по опер'
  do case
     case skl1r#9998
          if kpl1r#9999999
             iwlr='skl=skl1r.and.kpl=kpl1r'
             aaa='Всего по плательщ.' //23
          else
             iwlr='skl=skl1r.and.kpl=9999999'
             aaa='Всего по складу'     //19
          endif
     case skl1r=9998
          if kpl1r#9999999
             iwlr='skl=9998.and.kpl=kpl1r'
             aaa='Итого по плательщ.' //23
          else
             iwlr='skl=9998.and.kpl=9999999'
             aaa='Итого '              //9
          endif
  endc
  ivr='skl1r,kpl1r,999'
  sele itog
  if netseek('t1',ivr)
     kszr=0
     sumr=0
     z90r=z90
     onerecr=0
     for i=10 to 99
         sumr=0
         if fieldpos('z'+str(i,2))=0.or.i=10.or.i=19.or.i=20.or.i=40.or.i=61.or.i=90
            loop
         endif
         kszr=i
         sumr=&('z'+str(kszr,2))
         if sumr#0.and.((pir=1.or.pir=3.or.pir=4).or.skl1r=9998.and.kpl1r=9999999)
           If !(pir=4)
            if onerecr=0
               ?aaa+space(23-len(aaa))+iif(z10#0,str(z10,12,2),space(10))+' '+iif(z19#0,str(z19,10,2),space(10))+' '+iif(z20#0,str(z20,10,2),space(10))+' '+iif(z40#0,str(z40,10,2),space(10))+' '+iif(z61#0,str(z61,10,2),space(10))+' '+str(kszr,2)+' '+str(sumr,12,2)+' '+iif(z90#0,str(z90,12,2),space(10))
               vrsle()
               onerecr=1
            else
               if !(pir=3)
                  ?' '+space(14)+' '+space(6)+' '+space(12)+' '+space(10)+' '+space(10)+' '+space(10)+' '+space(10)+' '+str(kszr,2)+' '+str(sumr,12,2)+' '+space(10)
                  vrsle()
               endif
            endif
           EndIf
         endif
     next
     If !(pir=4)
       if onerecr=0
          ?aaa+space(23-len(aaa))+iif(z10#0,str(z10,12,2),space(10))+' '+iif(z19#0,str(z19,10,2),space(10))+' '+iif(z20#0,str(z20,10,2),space(10))+' '+iif(z40#0,str(z40,10,2),space(10))+' '+iif(z61#0,str(z61,10,2),space(10))+' '+space(2)+' '+space(12)+' '+iif(z90#0,str(z90,12,2),space(10))
          vrsle()
       endif
     endif
  endif
  ivr='skl1r,kpl1r'
  sele itog
  if netseek('t1',ivr).and.z90#z90r
     do while &iwlr
        kopr=kop
        if kopr=999
           skip
           loop
        endif
        kszr=0
        sumr=0
        onerecr=0
        for i=10 to 99
            sumr=0
            if fieldpos('z'+str(i,2))=0.or.i=10.or.i=19.or.i=20.or.i=40.or.i=61.or.i=90
               loop
            endif
            kszr=i
            sumr=&('z'+str(kszr,2))
            if sumr#0
              If !(pir=4)
               if onerecr=0
                  ?space(4)+bbb+' '+str(kopr,3)+' '+iif(z10#0,str(z10,12,2),space(10))+' '+iif(z19#0,str(z19,10,2),space(10))+' '+iif(z20#0,str(z20,10,2),space(10))+' '+iif(z40#0,str(z40,10,2),space(10))+' '+iif(z61#0,str(z61,10,2),space(10))+' '+str(kszr,2)+' '+str(sumr,12,2)+' '+iif(z90#0,str(z90,12,2),space(10))
                  vrsle()
                  onerecr=1
               else
                  if pir#3
                     ?' '+space(14)+' '+space(6)+' '+space(12)+' '+space(10)+' '+space(10)+' '+space(10)+' '+space(10)+' '+str(kszr,2)+' '+str(sumr,12,2)+' '+space(10)
                     vrsle()
                  endif
               endif
              endif
            endif
        next
        If !(pir=4)
          if onerecr=0
             ?space(4)+bbb+' '+str(kopr,3)+' '+iif(z10#0,str(z10,12,2),space(10))+' '+iif(z19#0,str(z19,10,2),space(10))+' '+iif(z20#0,str(z20,10,2),space(10))+' '+iif(z40#0,str(z40,10,2),space(10))+' '+iif(z61#0,str(z61,10,2),space(10))+' '+space(2)+' '+space(12)+' '+iif(z90#0,str(z90,12,2),space(10))
             vrsle()
          endif
        endif
        sele itog
        skip
     endd
  endif

  retu

proc additr(p1,p2,p3)
  priv s1,s3,s3
  s1=p1
  s2=p2
  s3=p3
  sele itog
  if !netseek('t1','s1,s2,s3') // Итоги по kpl
     netadd()
     netrepl('skl,kpl,kop,z10,z19,z20,z40,z61,z90','s1,s2,s3,sum10r,sum19r,sum20r,sum40r,sum61r,sum90r',,1)
  else
     z10r=z10+sum10r
     z19r=z19+sum19r
     z20r=z20+sum20r
     z40r=z40+sum40r
     z61r=z61+sum61r
     z90r=z90+sum90r
     netrepl('z10,z19,z20,z40,z61,z90','z10r,z19r,z20r,z40r,z61r,z90r',,1)
  endif
  retu
