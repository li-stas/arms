/***********************************************************
 * Модуль    : prved.prg
 * Версия    : 0.0
 * Автор     :
 * Дата      : 12/18/17
 * Изменен   :
 * Примечание: Текст обработан утилитой CF версии 2.02
 */

#include "common.ch"
#include "inkey.ch"
// Ведомость прихода
// Формат A4 Пика сжатый
// h=62 w=140
set colo to g/n, n/g,,,
clea
ErasePrTmp()

kk=2
netuse('pr1')
netuse('pr3')
netuse('kln')
netuse('soper')
netuse('dclr')

tt='f:skl c:n(7) f:kps c:n(7) f:kop c:n(3) '
while (!eof())
  kzr=kz
  tt=tt+'f:z'+str(kzr, 2)+' c:n(13,2) '
  skip
enddo

nuse('dclr')
sele 0
crtt('itog', tt)
sele 0
use itog excl
inde on str(skl, 7)+str(kps, 7)+str(kop, 3) tag t1
set orde to tag t1

store 0 to ndr, mnr, sum10r, sum19r, sum40r, sum20r, sum62r, sum90r
kps_r=9999999
kop_r=999
store '' to nkps_r, nkop_r, nskl_r

if (gnMskl=0)
  skl_r=gnSkl
else
  skl_r=9998
endif

dt1_r=gdTd                  //bom(gdTd)
dt2_r=gdTd
store 1 to pir, psr

oclr=setcolor('gr+/b,n/w')
wvpr=wopen(5, 10, 15, 70)
wbox(1)
while (.t.)
  sele itog
  zap
  if (file('lpr1.dbf'))
  endif

  dt1or=dt1_r
  dt2or=dt2_r
  sklor=skl_r
  kpsor=kps_r
  kopor=kop_r
  pior=pir
  psor=psr
  kko =kk

  @ 0, 1 say 'С ' get dt1_r
  @ 0, col()+1 say ' по' get dt2_r valid dt()
  if (gnMskl=1)
    @ 1, 1 say 'Склад    ' get skl_r pict '9999999' valid skl()
    @ 2, 1 say '9998 - по всем'
  else
    @ 1, 1 say 'Склад '+gcNskl
  endif

  @ 3, 1 say 'Поставщик' get kps_r pict '9999999' valid kps()
  @ 4, 1 say '9999999 - по всем'
  @ 5, 1 say 'Код операции' get kop_r pict '999' valid kop()
  @ 6, 1 say '999 - по всем'
  read
  if (lastkey()=K_ESC)
    exit
  endif

  @ 7, 1 prom 'Полностью'
  @ 7, col()+1 prom 'Итоги'
  menu to pir
  if (lastkey()=K_ESC)
    exit
  endif

  @ 8, 1 prom 'Печать'
  @ 8, col()+1 prom 'Экран'
  if (gnSpech=1 .or. gnAdm=1)
    @ 8, col()+1 prom 'Сет. печать'
  endif

  menu to psr
  if (psr=3)
    @ 8, 26 say 'Кол-во экз.' get kk pict '9'
    read
    alpt={ 'lpt2', 'lpt3' }
    vlpt=alert('ПЕЧАТЬ НА СЕТЕВОЙ ПРИНТЕР', alpt)
    if (vlpt=1)
      vlpt1='lpt2'
    else
      vlpt1='lpt3'
    endif

  endif

  if (lastkey()=K_ESC)
    exit
  endif

  sele lpr1
  if (recc()=0)
    wselect(0)
    save scre to scmess
    mess('Нет документов для этих условий', 3)
    rest scre from scmess
    wselect(wvpr)
    loop
  endif

  if (psr=3)              // сетевая печать
    kkr=0
    while (kkr<kk)
      sele itog
      zap
      vpr()
      kkr=kkr+1
    enddo

  else
    if (kop_r=999)
      //SaveVar_PrVed()
      // 12-21-17 03:21pm  - перчатать отдельно!!!
      vpr() // без КОП 111


    else
      vpr()

    endif

  endif

enddo

wclose(wvpr)
setcolor(oclr)

nuse()
ErasePrTmp()

/************************************************************************** */
static function skl()
  /************************************************************************** */
  if (skl_r#9998)
    if (select('lskl1')=0)
      sele lpr1
      go top
      total on skl field sdv to lskl1
    else
      if (sklor#skl_r)
        sele lskl1
        CLOSE
        sele lpr1
        go top
        total on skl field sdv to lskl1
      endif

    endif

    sele 0
    use lskl1 excl
    locate for skl=skl_r
    if (!FOUND())
      go top
    endif

    wselect(0)
    skl_r=slcf('lskl1',,,,, "e:skl h:'Склад' c:n(7) e:getfield('t1','lskl1->skl','kln','nkl') h:'Наименование' c:c(30)", 'skl')
    if (lastkey()=K_ESC)
      skl_r=0
    endif

    wselect(wvpr)
    nskl_r=getfield('t1', 'skl_r', 'kln', 'nkl')
    @ 1, 18 say nskl_r
  else
    nskl_r='по всем'
  endif

  return (.t.)

/************************************************************************** */
static function kps()
  /************************************************************************** */
  LOCAL lRet:=.T.
  crtt('tkps', 'f:skl c:n(7) f:kps c:n(7)')
  sele 0
  use tkps excl
  inde on str(skl, 7)+str(kps, 7) tag t1
  CLOSE
  sele 0
  use tkps shared
  set orde to tag t1

  if (kps_r#9999999)
    if (skl_r#9998)
      sele lpr1
      go top
      while (!eof())
        if (skl=skl_r.and.kps=kps_r)
          sele tkps
          if (!netseek('t1', 'skl_r,kps_r'))
            netadd()
            netrepl('skl,kps', 'skl_r,kps_r')
          endif

        endif

        sele lpr1
        skip
      enddo

    else
      sele lpr1
      go top
      while (!eof())
        if (kps=kps_r)
          sele tkps
          if (!netseek('t1', '0,kps_r'))
            netadd()
            netrepl('skl,kps', '0,kps_r')
          endif

        endif

        sele lpr1
        skip
      enddo

    endif

    sele tkps
    go top
    If eof()
      wmess('Данных НЕТ! Поставщик '+str(kps_r,7)+' '+left(getfield('t1', 'kps_r', 'kln', 'nkl'),30), 3)
      //kps_r=0
      lRet:=.f.
    Else
      wselect(0)
      kps_r=slcf('tkps',,,,, "e:kps h:'Код' c:n(7) e:getfield('t1','tkps->kps','kln','nkl') h:'Поставщик' c:c(30)", 'kps')
      if (lastkey()=K_ESC)
        kps_r=0
      endif
      wselect(wvpr)
      nkps_r=getfield('t1', 'kps_r', 'kln', 'nkl')
      @ 3, 20 say nkps_r
    EndIf

  else
    nkps_r='по всем'
  endif

  sele tkps
  CLOSE

  sele lpr1
  set orde to
  go top

  // if kps_r#9999999
  //   sele lpr1
  //   if skl_r#9998
  //      inde on str(skl,7)+str(kps,7) tag t1 uniq
  //      if !netseek('t1','skl_r,kps_r')
  //         netseek('t1','skl_r')
  //      endif
  //      wlr='skl=skl_r'
  //   else
  //      inde on str(kps,7) tag t1 uniq
  //      if !netseek('t1','kps_r')
  //         go top
  //      endif
  //      wlr=nil
  //   endif
  //   wselect(0)
  //   kps_r=slcf('lpr1',,,,,"e:kps h:'Код' c:n(7) e:getfield('t1','lpr1->kps','kln','nkl') h:'Поставщик' c:c(30)",'kps',,,wlr)
  //   if lastkey()=K_ESC
  //      kps_r=0
  //   endif
  //   wselect(wvpr)
  //   nkps_r=getfield('t1','kps_r','kln','nkl')
  //   @ 3,20 say nkps_r
  // else
  //   nkps_r='по всем'
  // endif
  // sele lpr1
  // set orde to
  // go top
  return (lRet)

/************************************************************************** */
static function kop()
  /************************************************************************** */
  if (kop_r#999)
    sele lpr1
    if (gnMskl=1)
      do case
      case (skl_r=9998.and.kps_r=9999999)
        inde on str(kop, 3) tag t1 uniq
        if (!netseek('t1', 'kop_r'))
          go top
        endif

        wlr='kop=kop_r'
      case (skl_r=9998.and.kps_r#9999999)
        inde on str(kps, 7)+str(kop, 3) tag t1 uniq
        if (!netseek('t1', 'kps_r,kop_r'))
          netseek('t1', 'kps_r')
        endif

        wlr='kps=kps_r'
      case (skl_r#9998.and.kps_r=9999999)
        inde on str(skl, 7)+str(kop, 3) tag t1 uniq
        if (!netseek('t1', 'skl_r,kop_r'))
          netseek('t1', 'skl_r')
        endif

        wlr='skl=skl_r'
      case (skl_r#9998.and.kps_r#9999999)
        inde on str(skl, 7)+str(kps, 7)+str(kop, 3) tag t1 uniq
        if (!netseek('t1', 'skl_r,kps_r,kop_r'))
          netseek('t1', 'skl_r,kps_r')
        endif

        wlr='skl=skl_r.and.kps=kps_r'
      endcase

    else
      do case
      case (kps_r=9999999)
        inde on str(kop, 3) tag t1 uniq
        if (!(kop_r=0.or.kop_r=999))
          if (!netseek('t1', 'kop_r'))
            go top
            wlr='.t.'
          else
            wlr='kop=kop_r'
          endif

        else
          go top
          wlr='.t.'
        endif

      case (kps_r#9999999)
        inde on str(kps, 7)+str(kop, 3) tag t1 uniq
        if (!(kop_r=0.or.kop_r=999))
          if (!netseek('t1', 'kps_r,kop_r'))
            netseek('t1', 'kps_r')
          endif

          wlr='kps=kps_r'
        else
          wlr='kps=kps_r'
        endif

      endcase

    endif

    wselect(0)
    kop_r=slcf('lpr1',,,,, "e:kop h:'Код' c:n(3) e:getfield('t1','1,1,lpr1->vo,mod(lpr1->kop,100)','soper','nop') h:'Операция' c:c(40)", 'kop',,, wlr)
    if (lastkey()=K_ESC)
      kop_r=0
    endif

    wselect(wvpr)
    nkop_r=getfield('t1', '1,1,0,mod(kop_r,100)', 'soper', 'nop')
    @ 3, 19 say nkop_r
  endif

  return (.t.)

/************************************************************************** */
static function dt()
  /************************************************************************** */
  if (select('lpr1')=0)
    sele pr1
    go top
    sort on skl, kps, dpr, mn to lpr1 for dpr>=dt1_r.and.dpr<=dt2_r.and.prz=1
  else
    if (dt1_r#dt1or.or.dt2_r#dt2or)
      sele lpr1
      CLOSE
      sele pr1
      go top
      sort on skl, kps, dpr, mn to lpr1 for dpr>=dt1_r.and.dpr<=dt2_r.and.prz=1
    endif

  endif

  sele 0
  use lpr1 excl
  /*repl all vo with 0 */
  return (.t.)

/************************************************************************ */
procedure vpr()
  /************************************************************************ */
  set prin to
  if (psr#3)
    if (gnOut=1)
      set prin to lpt1
    else
      set prin to txt.txt
    endif

  else
    set print to &vlpt1
  endif

  set prin on
  set cons off
  if (psr=3)
    ??chr(27)+'E'+chr(27)+'&l1h26a0O'+chr(27)+chr(27)+'(3R'+chr(27)+'(s0p17.00h0s1b4102T'+chr(27)// Книжная А4
  else
    //   if gnEnt=14
    //      apr={'Epson','HP'}
    //      vpr=alert('Выбор принтера',apr)
    //      if empty(gcPrn)
    //         ??chr(27)+chr(80)+chr(15)
    //      else
    //         ??chr(27)+'E'+chr(27)+'&l1h26a0O'+chr(27)+chr(27)+'(3R'+chr(27)+'(s0p14.00h0s0b4099T'+chr(27)  // Книжная А4
    //      endif
    //    else
    if (empty(gcPrn))
      ??chr(27)+chr(80)+chr(15)
    else
      ??chr(27)+'E'+chr(27)+'&l1h26a0O'+chr(27)+chr(27)+'(3R'+chr(27)+'(s0p17.00h0s1b4102T'+chr(27)// Книжная А4
    endif

  //   endif
  endif

  set devi to print
  // ?chr(27)+chr(80)+chr(15)
  if (gnOut=2.and.psr#3)
    set devi to scre
    wselect(0)
    save scre to scmess
    mess('Ждите,идет печать...')
  endif

  sele lpr1
  set orde to
  go top
  do case
  case (skl_r=9998.and.kps_r=9999999)
    if (kop_r=999)
      frr='.t.'+'.and.kop#111'
    else
      frr='kop=kop_r'
    endif

  case (skl_r=9998.and.kps_r#9999999)
    if (kop_r=999)
      frr='kps=kps_r'+'.and.kop#111'
    else
      frr='kps=kps_r.and.kop=kop_r'
    endif

  case (skl_r#9998.and.kps_r=9999999)
    if (kop_r=999)
      frr='skl=skl_r'+'.and.kop#111'
    else
      frr='skl=skl_r.and.kop=kop_r'
    endif

  case (skl_r#9998.and.kps_r#9999999)
    if (kop_r=999)
      // 12-18-17 11:41am без пересортицы kop=111, вывод отдельно
      frr='skl=skl_r.and.kps=kps_r'+'.and.kop#111'
    else
      frr='skl=skl_r.and.kps=kps_r.and.kop=kop_r'
    endif

  endcase

  lstr=1
  prsklr=0
  prkpsr=0
  vprwr=0
  skl_rr=9997
  kps_rr=0
  vprsh()
  Nppr=1
  pskpsr=1                  // Счетчик для печати итога
  pssklr=1                  // Счетчик для печати итогов по подотчетникам

  /*If !isblock(frr) */
  cFrr:=frr; frr:=&('{|| '+cFrr+' }')
  //EndIf

  while (!eof())
    store 0 to ndr, mnr, sum10r, sum19r, sum40r, sum20r, sum61r, sum90r
    sele lpr1
    // outlog(__FILE__,__LINE__,&cFrr,eval(frr),nd,mn,kop,kps,',nd,mn,kop,kps')
    if (!eval(frr))     //!&frr
      skip
      loop
    endif

    ndr=nd
    mnr=mn
    dprr=dpr
    kopr=kop
    kpsr=kps
    sklr=skl
    if (gnMskl=1)
      if (sklr#skl_rr)
        do case
        case (prsklr=0)   // Новый склад
          ?str(sklr, 7)+' '+getfield('t1', 'sklr', 'kln', 'nkl')
          vprle()
          prsklr=1
          kps_rr=0
        case (prsklr=1)   // Итоги
          if (prkpsr#0.and.pssklr>1)
            itog(skl_rr, kps_rr)// Итог по поставщику
            prkpsr=0
          endif

          if (prkpsr#0.and.pssklr=1)
            //                 itog(skl_rr,kps_rr)  // Итог по поставщику
            prkpsr=0
          endif

          if (gnMskl=1.and.pssklr>1)
            itog(skl_rr, 9999999)// Итог по складу
            pssklr=1
          endif

          prsklr=0
          sele lpr1
          loop
        endcase

        skl_rr=sklr
      else
        pssklr++
      endif

    endif

    if (kps_rr#kpsr)
      if (gnOut=2.and.psr#3)
        @ 24, 1 say 'Поставщик '+str(kpsr, 7)+' '+getfield('t1', 'kpsr', 'kln', 'nkl') color 'g/n'
      endif

      do case
      case (prkpsr=0.and.pir=1)// Новый поставщик
        ?'Поставщик '+str(kpsr, 7)+' '+getfield('t1', 'kpsr', 'kln', 'nkl')
        vprle()
        prkpsr=1
      case (prkpsr=1.and.pir=1.and.pskpsr>1)// Итоги по поставщику
        itog(sklr, kps_rr)// Итог по поставщику
        prkpsr=0
        pskpsr=1
        sele lpr1
        loop
      case (prkpsr=1.and.pir=1)// Переход к следующему
        prkpsr=0
        sele lpr1
        loop
      endcase

      kps_rr=kpsr
    else
      pskpsr++
    endif

    sum10r=getfield('t1', 'mnr,10', 'pr3', 'ssf')
    sum19r=getfield('t1', 'mnr,19', 'pr3', 'ssf')
    sum20r=getfield('t1', 'mnr,20', 'pr3', 'ssf')
    sum40r=getfield('t1', 'mnr,40', 'pr3', 'ssf')
    sum61r=getfield('t1', 'mnr,61', 'pr3', 'ssf')
    sum90r=getfield('t1', 'mnr,90', 'pr3', 'ssf')

    addit(sklr, kpsr, 999)// Итоги по kps
    addit(sklr, kpsr, kopr)// Итоги по kps,kop
    if (gnMskl=1)
      addit(sklr, 9999999, 999)// Итоги по skl
      addit(sklr, 9999999, kopr)// Итоги по skl,kop
    endif

    addit(9998, 9999999, 999)// Итоги полные
    addit(9998, 9999999, kopr)// Итоги полные,kop

    sele pr3
    cntkszr=0
    onerecr=0
    if (netseek('t1', 'mnr'))
      sumr=0
      while (mn=mnr)
        sele pr3
        if (str(ksz,2) $ '10;19;20;40;61;90')
          skip
          loop
        endif

        kszr=ksz
        sumr=ssf
        tt='z'+str(kszr, 2)
        sele itog
        if (fieldpos(tt)=0)
          sele pr3
          skip
          loop
        endif

        if (!netseek('t1', 'sklr,kpsr,999'))
          netadd()
          netrepl('skl,kps,kop,&tt', 'sklr,kpsr,999,sumr', 1)
        else
          sumrr=&tt+sumr
          netrepl('&tt', 'sumrr', 1)
        endif

        if (!netseek('t1', 'sklr,kpsr,kopr'))
          netadd()
          netrepl('skl,kps,kop,&tt', 'sklr,kpsr,kopr,sumr', 1)
        else
          sumrr=&tt+sumr
          netrepl('&tt', 'sumrr', 1)
        endif

        if (gnMskl=1)
          if (!netseek('t1', 'sklr,9999999,999'))
            netadd()
            netrepl('skl,kps,kop,&tt', 'sklr,9999999,999,sumr', 1)
          else
            sumrr=&tt+sumr
            netrepl('&tt', 'sumrr', 1)
          endif

          if (!netseek('t1', 'sklr,9999999,kopr'))
            netadd()
            netrepl('skl,kps,kop,&tt', 'sklr,9999999,kopr,sumr', 1)
          else
            sumrr=&tt+sumr
            netrepl('&tt', 'sumrr', 1)
          endif

        endif

        if (!netseek('t1', '9998,9999999,999'))
          netadd()
          netrepl('skl,kps,kop,&tt', '9998,9999999,999,sumr', 1)
        else
          sumrr=&tt+sumr
          netrepl('&tt', 'sumrr', 1)
        endif

        if (!netseek('t1', '9998,9999999,kopr'))
          netadd()
          netrepl('skl,kps,kop,&tt', '9998,9999999,kopr,sumr', 1)
        else
          sumrr=&tt+sumr
          netrepl('&tt', 'sumrr', 1)
        endif

        if (onerecr=0)
          if (pir=1)
            //               ?' '+str(Nppr,3)+' '+dtoc(dprr)+' '+str(ndr,6)+' '+str(mnr,6)+' '+iif(sum10r#0,str(sum10r,10,2),space(10))+' '+iif(sum19r#0,str(sum19r,10,2),space(10))+' '+iif(sum20r#0,str(sum20r,10,2),space(10))+' '+iif(sum40r#0,str(sum40r,10,2),space(10))+' '+iif(sum61r#0,str(sum61r,10,2),space(10))+' '+space(2)+' '+space(10)+' '+iif(sum90r#0,str(sum90r,10,2),space(10))+' '+str(kopr,3)
            ?' '+str(Nppr, 3)+' '+dtoc(dprr)+' '+str(ndr, 6)+' '+str(mnr, 6)+' '+iif(sum10r#0, str(sum10r, 10, 2), space(10))+' '+iif(sum19r#0, str(sum19r, 10, 2), space(10))+' '+iif(sum20r#0, str(sum20r, 10, 2), space(10))+' '+iif(sum40r#0, str(sum40r, 10, 2), space(10))+' '+iif(sum61r#0, str(sum61r, 10, 2), space(10))+' '+iif(sumr#0, str(kszr, 2), space(2))+' '+iif(sumr#0, str(sumr, 10, 2), space(10))+' '+iif(sum90r#0, str(sum90r, 10, 2), space(10))+' '+str(kopr, 3)
            Nppr++
            vprle()
          endif

          onerecr=1
        else
          if (pir=1)
            if (sumr#0)
              ?' '+space(14)+' '+space(6)+' '+space(6)+' '+space(10)+' '+space(10)+' '+space(10)+' '+space(10)+' '+space(10)+' '+str(kszr, 2)+' '+str(sumr, 10, 2)+' '+space(10)+' '+space(3)
              vprle()
            endif

          endif

        endif

        cntkszr++
        sele pr3
        skip
      enddo

      if (cntkszr=0)
        if (pir=1)
          ?' '+str(Nppr, 3)+' '+dtoc(dprr)+' '+str(ndr, 6)+' '+str(mnr, 6)+' '+iif(sum10r#0, str(sum10r, 10, 2), space(10))+' '+iif(sum19r#0, str(sum19r, 10, 2), space(10))+' '+iif(sum20r#0, str(sum20r, 10, 2), space(10))+' '+iif(sum40r#0, str(sum40r, 10, 2), space(10))+' '+iif(sum61r#0, str(sum61r, 10, 2), space(10))+' '+space(2)+' '+space(10)+' '+iif(sum90r#0, str(sum90r, 10, 2), space(10))+' '+str(kopr, 3)
          Nppr++
          vprle()
        endif

      endif
    else
    endif

    sele lpr1
    skip
  enddo

  if (pir=1.and.pskpsr>1)
    itog(sklr, kpsr)      // Итог по поставщику
    if (gnMskl=1)
      itog(sklr, 9999999) // Итог по складу
    endif

  endif

  itog(9998, 9999999)     // Общий итог
  eject
  if (gnOut=2.and.psr#3)
    rest scre from scmess
    wselect(wvpr)
  endif

  set cons on
  set prin off
  set prin to
  set devi to scre
  if (psr=2)
    wselect(0)
    edfile('txt.txt')
    wselect(wvpr)
  endif

  return

/***************************************************************************** */
procedure vprle()
  /***************************************************************************** */
  vprwr++
  if (vprwr>63)
    vprwr=1
    lstr++
    eject
    if (gnOut=1)
      set devi to scre
      wselect(0)
      save scre to scmess
      mess('Вставьте лист и нажмите пробел', 1)
      rest scre from scmess
      wselect(wvpr)
    endif

    vprsh()
  endif

  return

/*************************************************************************** */
procedure vprsh()
  /*************************************************************************** */
  if (gnMskl=0.or.skl_r=9998)
    ?'Ведомость прихода на склад '+gcNskl
  else
    ?'Ведомость прихода на склад '+nskl_r
  endif

  vprle()
  ?' С '+dtoc(dt1_r)+' по '+dtoc(dt2_r)
  vprle()
  if (kps_r#9999999)
    ?' По поставщику '+str(kps_r, 7)+' '+nkps_r
    vprle()
  endif

  if (kop_r#999)
    ?' Операция '+str(kop_r, 7)+' '+nkop_r
    vprle()
  endif

  ?space(100)+'Лист '+str(lstr, 3)
  vprle()
  ?'┌───┬──────────┬──────┬──────┬──────────┬──────────┬──────────┬──────────┬──────────┬──┬──────────┬────────────┬───┐'
  vprle()
  ?'│ N │   Дата   │Номер │ Маш. │  Товар   │  Тара    │ Скидка   │ Наценка  │Транспорт.│К │  Сумма   │  По докум. │КОП│'
  vprle()
  ?'│п/п│ прихода  │прих. │номер │          │          │          │ поставщ. │ расходы  │С │          │  поставщ.  │   │'
  vprle()
  ?'│   │          │докум.│      │          │          │          │          │          │З │          │            │   │'
  vprle()
  ?'├───┼──────────┼──────┼──────┼──────────┼──────────┼──────────┼──────────┼──────────┼──┼──────────┼────────────┼───┤'
  vprle()
  return

/**************************************************************************** */
procedure itog(p1, p2)
  /**************************************************************************** */
  private skl1r, kps1r
  skl1r=p1
  kps1r=p2
  z90r=0
  bbb='В т.ч. по операции     '
  do case
  case (skl1r#9998)
    if (kps1r#9999999)
      iwlr='skl=skl1r.and.kps=kps1r'
      aaa='Всего по поставщику       '//19
    else
      iwlr='skl=skl1r.and.kps=9999999'
      aaa='Всего по складу    '       //15
    endif

  case (skl1r=9998)
    if (kps1r#9999999)
      iwlr='skl=9998.and.kps=kps1r'
      aaa='Итого по поставщику    '//19
    else
      iwlr='skl=9998.and.kps=9999999'
      aaa='Итого      '            //5
    endif

  endcase

  ivr='skl1r,kps1r,999'
  sele itog
  if (netseek('t1', ivr))
    kszr=0
    sumr=0
    z90r=z90
    onerecr=0
    for i=10 to 99
      sumr=0
      if (fieldpos('z'+str(i, 2))=0.or.i=10.or.i=19.or.i=20.or.i=40.or.i=61.or.i=90)
        loop
      endif

      kszr=i
      sumr=&('z'+str(kszr, 2))
      if (sumr#0.and.(pir=1.or.skl1r=9998.and.kps1r=9999999))
        if (onerecr=0)
          ?aaa+space(26-len(aaa))+space(3)+' '+iif(z10#0, str(z10, 10, 2), space(10))+' '+iif(z19#0, str(z19, 10, 2), space(10))+' '+iif(z20#0, str(z20, 10, 2), space(10))+' '+iif(z40#0, str(z40, 10, 2), space(10))+' '+iif(z61#0, str(z61, 10, 2), space(10))+' '+str(kszr, 2)+' '+str(sumr, 10, 2)+' '+iif(z90#0, str(z90, 12, 2), space(12))
          onerecr=1
        else
          ?' '+space(7)+space(7)+' '+space(6)+' '+space(6)+' '+space(10)+' '+space(10)+' '+space(10)+' '+space(10)+' '+space(10)+' '+str(kszr, 2)+' '+str(sumr, 10, 2)+' '+space(12)
        endif

        vprle()
      endif

    next

    if (onerecr=0)
      ?aaa+space(26-len(aaa))+space(3)+' '+iif(z10#0, str(z10, 10, 2), space(10))+' '+iif(z19#0, str(z19, 10, 2), space(10))+' '+iif(z20#0, str(z20, 10, 2), space(10))+' '+iif(z40#0, str(z40, 10, 2), space(10))+' '+iif(z61#0, str(z61, 10, 2), space(10))+' '+space(2)+' '+space(10)+' '+iif(z90#0, str(z90, 12, 2), space(12))
      vprle()
    endif

  endif

  ivr='skl1r,kps1r'
  cImlr:=iwlr; bImlr:=&('{||'+cImlr+'}')
  sele itog
  if (netseek('t1', ivr).and.z90#z90r)
    while (eval(bImlr)) //&iwlr
      kopr=kop
      if (kopr=999)
        skip
        loop
      endif

      kszr=0
      sumr=0
      //      ?bbb+space(3)+str(kopr,3)+' '+iif(z10#0,str(z10,10,2),space(10))+' '+iif(z19#0,str(z19,10,2),space(10))+' '+iif(z20#0,str(z20,10,2),space(10))+' '+iif(z40#0,str(z40,10,2),space(10))+' '+iif(z61#0,str(z61,10,2),space(10))+' '+space(2)+' '+space(10)+' '+iif(z90#0,str(z90,10,2),space(10))
      //      vprle()
      onerecr=0
      for i=10 to 99
        sumr=0
        if (fieldpos('z'+str(i, 2))=0.or.i=10.or.i=19.or.i=20.or.i=40.or.i=61.or.i=90)
          loop
        endif

        kszr=i
        sumr=&('z'+str(kszr, 2))
        if (sumr#0)
          if (onerecr=0)
            ?bbb+space(3)+str(kopr, 3)+' '+iif(z10#0, str(z10, 10, 2), space(10))+' '+iif(z19#0, str(z19, 10, 2), space(10))+' '+iif(z20#0, str(z20, 10, 2), space(10))+' '+iif(z40#0, str(z40, 10, 2), space(10))+' '+iif(z61#0, str(z61, 10, 2), space(10))+' '+str(kszr, 2)+' '+str(sumr, 10, 2)+' '+iif(z90#0, str(z90, 12, 2), space(12))
            onerecr=1
          else
            ?' '+space(7)+space(7)+' '+space(6)+' '+space(6)+' '+space(10)+' '+space(10)+' '+space(10)+' '+space(10)+' '+space(10)+' '+str(kszr, 2)+' '+str(sumr, 10, 2)+' '+space(12)
          endif

          vprle()
        endif

      next

      if (onerecr=0)
        ?bbb+space(3)+str(kopr, 3)+' '+iif(z10#0, str(z10, 10, 2), space(10))+' '+iif(z19#0, str(z19, 10, 2), space(10))+' '+iif(z20#0, str(z20, 10, 2), space(10))+' '+iif(z40#0, str(z40, 10, 2), space(10))+' '+iif(z61#0, str(z61, 10, 2), space(10))+' '+space(2)+' '+space(10)+' '+iif(z90#0, str(z90, 12, 2), space(12))
        vprle()
      endif

      sele itog
      skip
    enddo

  endif

  return

/***********************************************************
 * addit
 *   Параметры:
 */
procedure addit(p1, p2, p3)
  private s1, s3, s3
  s1=p1
  s2=p2
  s3=p3
  sele itog
  if (!netseek('t1', 's1,s2,s3'))// Итоги по kps
    netadd()
    netrepl('skl,kps,kop,z10,z19,z20,z40,z61,z90', 's1,s2,s3,sum10r,sum19r,sum20r,sum40r,sum61r,sum90r', 1)
  else
    z10r=z10+sum10r
    z19r=z19+sum19r
    z20r=z20+sum20r
    z40r=z40+sum40r
    z61r=z61+sum61r
    z90r=z90+sum90r
    netrepl('z10,z19,z20,z40,z61,z90', 'z10r,z19r,z20r,z40r,z61r,z90r', 1)
  endif

  return

/*****************************************************************
 
 FUNCTION:
 АВТОР..ДАТА..........С. Литовка  11-23-04 * 01:08:55pm
 НАЗНАЧЕНИЕ.........
 ПАРАМЕТРЫ..........
 ВОЗВР. ЗНАЧЕНИЕ....
 ПРИМЕЧАНИЯ.........
 */
static function ErasePrTmp()

  if (select('lpr1')#0)
    sele lpr1
    CLOSE
  endif

  //erase lpr1.dbf
  //erase lpr1.cdx

  if (select('itog')#0)
    sele itog
    CLOSE
  endif

  erase itog.dbf
  erase itog.cdx

  if (select('lskl1')#0)
    sele lskl1
    CLOSE
  endif

  erase lskl1.dbf
  return (nil)

/*****************************************************************
 
 FUNCTION:
 АВТОР..ДАТА..........С. Литовка  12-18-17 * 03:33:15pm
 НАЗНАЧЕНИЕ.........
 ПАРАМЕТРЫ..........
 ВОЗВР. ЗНАЧЕНИЕ....
 ПРИМЕЧАНИЯ.........
 */
STATIC FUNCTION SaveVar_PrVed()
  dt1or=dt1_r
  dt2or=dt2_r
  sklor=skl_r
  kpsor=kps_r
  kopor=kop_r
  pior =pir
  psor =psr
  kko  =kk
  RETURN (NIL)

/*****************************************************************
 
 FUNCTION:
 АВТОР..ДАТА..........С. Литовка  12-18-17 * 03:33:53pm
 НАЗНАЧЕНИЕ.........
 ПАРАМЕТРЫ..........
 ВОЗВР. ЗНАЧЕНИЕ....
 ПРИМЕЧАНИЯ.........
 */
STATIC FUNCTION RestVar_PrVed()
  dt1_r=dt1or
  dt2_r=dt2or
  skl_r=sklor
  kps_r=kpsor
  kop_r=kopor
  pir  =pior
  psr  =psor
  kk   =kko
  RETURN (NIL)
