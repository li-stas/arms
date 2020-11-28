/***********************************************************
 * Модуль    : vinv.prg
 * Версия    : 0.0
 * Автор     :
 * Дата      : 02/04/20
 * Изменен   :
 * Примечание: Текст обработан утилитой CF версии 2.02
 */

#include "common.ch"
#include "inkey.ch"
// Ведомость инвентаризации
//Формат A4 Пика сжатый
//h=62 w=140
set colo to g/n, n/g,,,
CLEAR
netuse('cskl')
netuse('GrpE')
netuse('kln')
netuse('tcen')
/*locate for tcen=gnTcen */
if (!empty(gcCopt))
  coptr=alltrim(gcCopt)
else
  coptr='opt'
endif

CLOSE
store bom(gdTd) to dt1r
store gdTd to dt2r
netuse('rs2')
netuse('rs1')
netuse('pr2')
netuse('pr1')
netuse('kln')
netuse('sgrp')
netUse('tov')
if (gnSkotv#0)
  sele cskl
  locate for sk=gnSkotv
  skljfr=skl
  pathr=gcPath_d+alltrim(path)
  netuse('tov', 'tovjf',, 1)
endif

if (gnMskl=0)
  tovizg()
endif

sele tov
set orde to tag t1
go top
oclr=setcolor('gr+/b,n/w')
wostf=wopen(5, 20, 20, 60)
wbox(1)
if (gnMskl=1)
  skl_r=9998
  nskl_r=''
else
  skl_r=gnSkl
  nskl_r=gcNskl
endif

store 1 to psr, pir, fvr
kg_r=999
izg_r=99999999
post_r=9999999
drlz_r=ctod('')
dpp_r=ctod('')
while (.t.)
  sele tov
  go top
  if (gnMskl=1)
    @ 0, 1 say 'Подотчетник' get skl_r pict '9999999' valid skl()
    @ 1, 1 say '9998 - По всем подотчетникам'
  else
    @ 0, 1 say 'Склад '+gcNskl
  endif

  if (gnMskl=0)
    @ 2, 1 say 'Изготовитель' get izg_r pict '99999999' valid izg()
    @ 3, 1 say '99999999 - по всем'
  endif

  if (gnMskl=0)
    @ 4, 1 say 'Поставщик   ' get post_r pict '9999999' valid post()
    @ 5, 1 say '99999999 - по всем'
  endif

  @ 6, 1 say 'Группа     ' get kg_r pict '999' valid kg()
  @ 7, 1 say '999 - По всем группам'

  @ 8, 1 say 'Период с '+dtoc(dt1r)
  @ 8, col()+1 say 'по '+dtoc(dt2r)//get dt2r
  read
  if (lastkey()=K_ESC)
    exit
  endif

  @ 9, 1 prom 'Факт'
  @ 9, col()+1 prom 'С учетом вып.'
  @ 9, col()+1 prom 'Факт с уч. отгр.'
  menu to fvr
  if (lastkey()=K_ESC)
    exit
  endif

  if (fvr=1)
    @ 10, 1 say 'Конечный срок реализации' get drlz_r
    if (empty(drlz_r))
      @ 11, 1 say 'Дата последнего проихода' get dpp_r
    endif

    read
    if (lastkey()=K_ESC)
      exit
    endif

  endif

  @ 12, 1 prom 'Полностью'
  @ 12, col()+1 prom 'Итоги'
  menu to pir
  if (lastkey()=K_ESC)
    exit
  endif

  @ 13, 1 prom 'Печать'
  @ 13, col()+1 prom 'Экран'
  if (gnSpech=1 .or. gnAdm=1)
    @ 13, col()+1 prom 'Сет. печать'
  endif

  menu to psr
  if (lastkey()=K_ESC)
    exit
  endif

  vinvpod()
enddo

wclose(wostf)
setcolor(oclr)
nuse()
nuse('lizg')
nuse('tovjf')

/************************************************************************** */
static function kg()
  /************************************************************************** */
  if (kg_r#999)
    if (select('sl')=0)
      sele 0
      use _slct alias sl excl
    endif

    sele sl
    zap
    sele sgrp
    go top
    wselect(0)
    while (.t.)
      if (izg_r=0)
        kg_r=slcf('sgrp',,,,, "e:kgr h:'Код' c:n(3) e:ngr h:'Наименование' c:c(20)", 'kgr', 1)
      else
        kg_r=slcf('sgrp',,,,, "e:kgr h:'Код' c:n(3) e:ngr h:'Наименование' c:c(20)", 'kgr', 1)
      endif

      netseek('t1', 'kg_r')
      if (lastkey()=K_ESC)
        kg_r=999
        sele sl
        zap
        exit
      endif

      if (lastkey()=K_ENTER)
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

  return (.t.)

/************************************************************************** */
static function izg()
  /************************************************************************** */
  if (izg_r#99999999)
    sele lizg
    set orde to 1
    seek str(izg_r, 8)
    if (!FOUND())
      set orde to 2
      go top
      wselect(0)
      izg_r=slcf('lizg',,,,, "e:nizg h:'Наименование' c:c(40) e:izg h:'Код' c:n(8)", 'izg')
      if (izg_r=0)
        izg_r=99999999
      endif

      sele lizg
      seek str(izg_r, 8)
      nizgr=nizg
      wselect(wostf)
      @ 2, 18 say nizgr
    endif

  endif

  return (.t.)

/************************************************************************** */
static function post()
  if (post_r#0.and.post_r#9999999)
    sele kln
    if (netseek('t1', 'post_r'))
      npostr=nkl
      // @ 4,9 say npostr
      sele tov
    else
      post_r=0
    endif

  endif

  if (post_r=0)
    sele kln
    kklr=post_r
    wselect(0)
    post_r=slct_kl(10, 1, 12)
    sele kln
    netseek('t1', 'post_r')
    npostr=nkl
    /*@ 4,18 say npostr */
    sele tov
    wselect(wostf)
  endif

  return (.t.)

/************************************************************************** */
static function skl()
  /************************************************************************** */
  if (skl_r#9998)
    sele kln
    if (!netseek('t1', 'skl_r'))
      go top
    endif

    wselect(0)
    skl_r=slcf('kln',,,,, "e:kkl h:'Код' c:n(7) e:nkl h:'Подотчетник' c:c(20)", 'kkl',,, 'kkl<10000')
    wselect(wostf)
    nskl_r=getfield('t1', 'skl_r', 'kln', 'nkl')
    @ 0, 18 say nskl_r
  else
    nskl_r='по всем'
  endif

  return (.t.)

/************************************************************************** */
procedure vinvpod()
  /************************************************************************** */
  pitog=.f.
  set prin to
  if (psr#3)
    if (gnOut=1)
      set prin to lpt1
    else
      set prin to txt.txt
    endif

  else
    set print to lpt2
  endif

  set prin on
  set cons off
  if (psr=3)
    ??chr(27)+'E'+chr(27)+'&l1h26a0O'+chr(27)+chr(27)+'(3R'+chr(27)+'(s0p17.00h0s1b4102T'+chr(27)// Книжная А4
  else
    //  if gnEnt=14
    //     apr={'Epson','HP'}
    //     vpr=alert('Выбор принтера',apr)
    //     if empty(gcPrn)
    //        ??chr(27)+chr(80)+chr(15)
    //     else
    //       ??chr(27)+'E'+chr(27)+'&l1h26a0O'+chr(27)+chr(27)+'(3R'+chr(27)+'(s0p17.00h0s1b4102T'+chr(27)  // Книжная А4
    //       ??chr(27)+'E'+chr(27)+'&l1h26a0O'+chr(27)+chr(27)+'(3R'+chr(27)+'(s0p16.00h0s0b4099T'+chr(27)  // Книжная А4
    //       ??chr(27)+'E'+chr(27)+'&l4h2a0O'+chr(27)+'&k2S'+chr(27)+'&a20l'+chr(27)+'(3R'+chr(27)+'(s0p17.00h0s0b4099T'+chr(27)
    //     endif
    //   else
    if (empty(gcPrn))
      ??chr(27)+chr(80)+chr(15)
    else
      ??chr(27)+'E'+chr(27)+'&l1h26a0O'+chr(27)+chr(27)+'(3R'+chr(27)+'(s0p17.00h0s1b4102T'+chr(27)// Книжная А4
    endif

  //  endif
  endif

  set devi to print
  sele tov
  set orde to tag t2
  wlr='!eof()'
  frr='.t.'
  if (fvr=1)
    if (!empty(drlz_r))
      frr=frr+'.and.drlz<=drlz_r'
    endif

    if (!empty(dpp_r))
      frr=frr+'.and.dpp<=dpp_r'
    endif

  endif

  if (gnMskl=0)
    if (izg_r#99999999)
      frr=frr+'.and.izg=izg_r'
    endif

    if (post_r#9999999)
      frr=frr+'.and.post=post_r'
    endif

  endif

  if (gnMskl=0)
    if (kg_r=999)
      go top
    else
      sele sl
      go top
      f=0
      while (!eof())
        jjj=val(kod)
        if (f=0)
          frr=frr+'.and.(int(ktl/1000000)='+str(jjj, 3)
        else
          frr=frr+'.or.int(ktl/1000000)='+str(jjj, 3)
        endif

        f++
        sele sl
        skip
      enddo

      if (f#0)
        frr=frr+')'
      endif

      wlr='skl=skl_r'
    endif

  else
    if (skl_r=9998)
      if (kg_r=999)
        go top
      else
        go top
        frr=frr+'.and.int(ktl/1000000)=kg_r'
      endif

    else
      if (kg_r=999)
        netseek('t2', 'skl_r')
        wlr='skl=skl_r'
      else
        //        netseek('t2','str(skl_r,4)+str(gnVu,1)+iif(kg_r#0,str(kg_r,3),space(3))',,1)
        netseek('t2', 'skl_r,kg_r')
        wlr='skl=skl_r.and.int(ktl/1000000)=kg_r'
      endif

    endif

  endif

  lstr=1
  ostfwr=1
  invsh()
  invshm()
  prkgr=0
  prsklr=0
  prktlr=0
  skl_rr=9997
  kg_rr=998
  ktl_rr=999999998
  store 0 to sumtr, sumgr, sumir, sumsr
  if (gnOut=2.and.psr#3)
    set devi to scre
    wselect(0)
    save scre to scmess
    mess('Ждите,идет печать...')
  endif

  sele tov
  if (gnMskl=0)
    set orde to tag t2
    netseek('t2', 'skl_r')
  endif

  while (&wlr)
    if (!&frr)
      skip
      loop
    endif

    //  if ktl#5034
    //     skip
    //     loop
    //  endif
    sklr=skl
    ktlr=ktl
    kgr=int(ktlr/1000000)
    osfr=osf
    osvr=osv
    osnr=osn
    //  if fvr=1.or.fvr=3
    //     if osf=0
    //        sele tov
    //        skip
    //        loop
    //     endif
    //  else
    //    if fvr=2
    //     if osv=0
    //        sele tov
    //        skip
    //        loop
    //     endif
    //    endif
    //  endif
    /***************8888888888888888888888888888888888888 */
    //  if fvr=3
    ktlrr=0
    skotg=0
    skotgo=0
    sele rs2
    set order to tag t2
    netseek('t2', 'ktlr')
    while (ktl=ktlr)
      if (!empty(getfield('t1', 'rs2->ttn', 'rs1', 'dot')) .and. getfield('t1', 'rs2->ttn', 'rs1', 'prz')=0)//.and.getfield('t1','rs2->ttn','rs1','dot')<=dt2r
        sele rs2
        skotg=skotg+kvp
      endif

      //        if !empty(getfield('t1','rs2->ttn','rs1','dot')) .and. getfield('t1','rs2->ttn','rs1','prz')=0 //.and.getfield('t1','rs2->ttn','rs1','dot')>dt2r
      //           sele rs2
      //           skotg=skotg-kvp
      //           osvr=osvr+kvp
      //        endif
      //        if getfield('t1','rs2->ttn','rs1','prz')=1 //.and.getfield('t1','rs2->ttn','rs1','dot')>dt2r
      //           osvr=osvr+kvp
      //           osfr=osfr+kvp
      //        endif
      skip
      if (ktl#ktlr)
        exit
      endif

      loop
    enddo

    /************************* */
    if (ktl_rr#ktlr.or.skl_rr#sklr)
      if (prktlr=1)       // Закрыть предыдущий товар
        to_endinv()
        prktlr=0
      endif

      ktl_rr=ktlr
    endif

    if (kg_rr#kgr.or.skl_rr#sklr)
      if (prkgr=1)        // Закрыть предыдущую группу
        go_endinv()
        prkgr=0
      endif

      kg_rr=kgr
    endif

    if (skl_rr#sklr)      // Смена мультисклада
      if (gnMskl#0)
        if (prsklr=1)     // Закрыть предыдущий мультисклад
          so_endinv()
          prsklr=0
        endif

      endif

      skl_rr=sklr
    endif

    if (gnMskl#0)
      if (prsklr=0)       // Открыть новый мультисклад
        if (gnout=2.and.psr#3)
          @ 24, 1 say str(sklr, 7)+' '+getfield('t1', 'sklr', 'kln', 'nkl') color 'g/n'
        endif

        ?space(5)+str(sklr, 7)+' '+getfield('t1', 'sklr', 'kln', 'nkl')
        ostleinv()
        prsklr=1
      endif

    endif

    if (prkgr=0)          // Открыть новую группу
                            //      kg_rrr=kgr
      if (gnout=2.and.psr#3)
        @ 24, 40 say str(kg_rr, 3)+' '+getfield('t1', 'kg_rr', 'sgrp', 'ngr') color 'g/n'
      endif

      ?str(kgr, 3)+' '+getfield('t1', 'kg_rr', 'sgrp', 'ngr')
      ostleinv()
      prkgr=1
    endif

    sele tov
    if (prktlr=0)         // Открыть новый товар
      prktlr=1
    endif
    optr=&coptr
    kger=kge
    natr=nat
    neir=nei
    //   osfr=osf
    //   osvr=osv
    //   osnr=osn
    drlzr=drlz
    dppr=dpp
    if (fvr=1)
      sumtr=ROUND(osfr*optr, 2)
    else
      if (fvr=2)
        sumtr=ROUND(osvr*optr, 2)
      else
        sumtr=ROUND((osfr-skotg)*optr, 2)
        osfr=osfr-skotg
      endif

    endif

    sumgr=sumgr+sumtr
    sumsr=sumsr+sumtr
    sumir=sumir+sumtr
    if (pir=1)
      natr=subs(alltrim(getfield('t1', 'kger', 'GrpE', 'nge'))+' '+natr, 1, 50)
      if (!empty(dpp_r))
        dtr=iif(!empty(dppr), dtoc(dppr), '')
      else
        dtr=iif(!empty(drlzr), dtoc(drlzr), '')
      endif

      if (gnSkl=92.and.upak<>0)
        upakr=str(upak, 5)
        if (fvr=1.or.fvr=3)
          if (osfr#0)
            ?str(ktlr, 9)+' '+substr(natr, 1, 33)+' '+str(mntov, 7)+' '+upakr+'  '+subs(neir, 1, 4)+' '+str(optr, 10, 3)+' '+str(osfr, 10, 3)+' '+str(sumtr, 10, 2)+' '+repl('_', 8)+' '+repl('_', 10)+' '+' '+repl('_', 8)+' '+repl('_', 10)
            ostleinv()
          endif

        else
          if (osvr#0)
            ?str(ktlr, 9)+' '+substr(natr, 1, 33)+' '+str(mntov, 7)+' '+upakr+'  '+subs(neir, 1, 4)+' '+str(optr, 10, 3)+' '+str(osvr, 10, 3)+' '+str(sumtr, 10, 2)+' '+repl('_', 8)+' '+repl('_', 10)+' '+' '+repl('_', 8)+' '+repl('_', 10)
            ostleinv()
          endif

        endif

      else
        if (fvr=1.or.fvr=3)
          if (osfr#0)
            if (gnSkotv=0)
              ?str(ktlr, 9)+' '+substr(natr, 1, 40)+' '+str(mntov, 7)+' '+subs(neir, 1, 4)+' '+str(optr, 10, 3)+' '+str(osfr, 10, 3)+' '+str(sumtr, 10, 2)+' '+repl('_', 8)+' '+repl('_', 10)+' '+' '+repl('_', 8)+' '+repl('_', 10)
            else
              ?str(ktlr, 9)+' '+substr(natr, 1, 40)+' '+str(mntov, 7)+' '+subs(neir, 1, 4)+' '+str(optr, 10, 3)+' '+str(osfr, 10, 3)+' '+str(sumtr, 10, 2)+' '+repl('_', 8)+' '+str(getfield('t1', 'skljfr,ktlr', 'tovjf', 'osvo'), 10, 3)
            endif

            ostleinv()
          endif

        else
          if (osvr#0)
            ?str(ktlr, 9)+' '+substr(natr, 1, 40)+' '+str(mntov, 7)+' '+subs(neir, 1, 4)+' '+str(optr, 10, 3)+' '+str(osvr, 10, 3)+' '+str(sumtr, 10, 2)+' '+repl('_', 8)+' '+repl('_', 10)+' '+' '+repl('_', 8)+' '+repl('_', 10)
            ostleinv()
          endif

        endif

      endif

    endif

    sele tov
    skip
  enddo

  pitog=.t.
  to_endinv()
  go_endinv()
  so_endinv()
  io_endinv()
  /*?repl('-',107)
   *ostleinv()
   */
  eject
  if (gnOut=2.and.psr#3)
    rest scre from scmess
    wselect(wostf)
  endif

  set cons on
  set prin off
  set prin to
  set devi to screen
  if (psr=2)
    wselect(0)
    edfile('txt.txt')
    wselect(wostf)
  endif

  return

/***************************************************************************** */
procedure invsh()
  /***************************************************************************** */
  ?space(10)+gcName_c
  ostleinv()
  ?space(10)+'Цех '+gcNskl+space(55)+'Код по ОКУД    0309003  8'
  ostleinv()
  ?' '
  ostleinv()
  ?space(35)+'IНВЕНТАРИЗАЦIЙНИЙ ОПИС        N  ________'
  ostleinv()
  /*?space(35)+'  ТОВАРНО - МАТЕРIАЛЬНИХ   ЦIННОСТЕЙ ' */
  if (fvr=3)
    ?space(30)+'  ТОВАРНО - МАТЕРIАЛЬНИХ   ЦIННОСТЕЙ (з урахуванням вiдвантажених)'
  else
    ?space(35)+'  ТОВАРНО - МАТЕРIАЛЬНИХ   ЦIННОСТЕЙ '
  endif

  ostleinv()
  ?space(35)+'"_____"  ____________________ 20_____р.'
  ostleinv()
  ?' '
  ostleinv()
  ?space(10)+repl('_', 109)
  ostleinv()
  ?space(30)+'рiд товарно-матерiальних цiнностей'
  ostleinv()
  ?space(43)+'РОЗПИСКА'
  ostleinv()
  ?space(10)+'До початку  проведення iнвентарiзацiї всi видатковi  та  прибутковi документи на товарно-матерiальнi цiнностi'
  ostleinv()
  ?space(10)+'переданi в бухгалтерiю  та  всi товарно-матерiальнi  цiнностi,  якi надiйшли  на мою (нашу)  вiдповiдальнiсть'
  ostleinv()
  ?space(10)+'оприбуткованi, а тi, що вибули, списанi.                              '
  ostleinv()
  ?' '
  ostleinv()
  ?space(25)+'Матерiально-вiдповiдальнi особи:'
  ostleinv()
  ?''
  ostleinv()
  ?space(10)+repl('_', 33)+space(5)+repl('_', 33)+space(5)+repl('_', 33)
  ostleinv()
  ?space(10)+'           посада                          прiзвище, i., п.                           пiдпис '
  ostleinv()
  ?''
  ostleinv()
  ?space(10)+repl('_', 33)+space(5)+repl('_', 33)+space(5)+repl('_', 33)
  ostleinv()
  ?space(10)+'           посада                           прiзвище, i., п.                          пiдпис '
  ostleinv()
  ?space(10)+'На  пiдставi наказу  N ________  вiд   "_____"____________________ 20_____р.    проведено зняття фактичних   '
  ostleinv()
  ?space(10)+'залишкiв, якi знаходяться на балансовому рахунку  N ______________                                           '
  ostleinv()
  ?space(10)+'на    "_____"________________________20______р.'
  ostleinv()
  ?space(10)+'Iнвентаризацiя:   розпочата  "_____"______________________20______р.'
  ostleinv()
  ?space(10)+'та                закiнчена  "_____"______________________20______р.'
  ostleinv()
  ?space(10)+'При   iнвентаризацiї   встановлено    наступне:'
  return

/*********** */
procedure invshm()
  /*********** */
  ?space(115)+'Лист '+str(lstr, 2)
  ostleinv()
  ?repl('-', 137)
  ostleinv()
  if (gnSkl=92)
    ?'|         |                                 |       |     |    |     За даними бух. облiку      |     Фактично      | Вiдхилення +(-)   |'
    ostleinv()
    ?'|   Код   |          Найменування           |Маш.ном|Упак.|Од.в|----------|----------|----------|--------|----------|--------|----------|'
    ostleinv()
    ?'|         |                                   |       |     |    |   Цiна   |Кiлькiсть |  Сума    |  Кiл-ть|  Сума    |  Кiл-ть|  Сума    |'

  else
    ?'|         |                                       |       |    |     За даними бух. облiку      |    Фактично       | Вiдхилення +(-)   |'
    ostleinv()
    ?'|   Код   |                Найменування           |Маш.ном|Од.в|----------|----------|----------|--------|----------|--------|----------|'
    ostleinv()
    ?'|         |                                       |       |    |   Цiна   |Кiлькiсть |  Сума    |  Кiл-ть|  Сума    |  Кiл-ть|  Сума    |'
  endif

  ostleinv()
  ?repl('-', 137)
  ostleinv()
  return

/**********************
 *****************************************************************************
 */
procedure ostleinv()
  /***************************************************************************** */
  ostfwr++
  if (ostfwr>=61)
    ostfwr=1
    lstr++
    eject
    if (gnOut=1.and.psr#3)
      set devi to scre
      wselect(0)
      save scre to scmess
      mess('Вставьте лист и нажмите пробел', 1)
      rest scre from scmess
      wselect(wostf)
    endif

    if (pitog#.t.)
      invshm()
    endif

  endif

  return

/************************************************************************ */
procedure so_endinv()
  /************************************************************************ */
  if (gnMskl=1)
    ?'Всього о подотчетнику:'+space(65)+str(sumsr, 10, 2)
    ostleinv()
  endif

  sumsr=0
  return

/************************************************************************ */
procedure go_endinv()
  /************************************************************************ */
  ?'   Всього по групi:'+space(68)+str(sumgr, 10, 2)
  sumgr=0
  ostleinv()
  return

/************************************************************************ */
procedure to_endinv()
  /************************************************************************
   *if pir=1
   */
  //  ?'Всього за товар :'
  /* */
  //  ?space(81)+str(sumtr,10,2)
  //  ostleinv()
  /*endif */
  return

/************************************************************************ */
procedure io_endinv()
  /************************************************************************ */
  ?'   Разом:'+space(77)+str(sumir, 10, 2)
  ostleinv()
  ?''
  ostleinv()
  ?space(10)+'Загальна кiлькiсть одиниць фактично _________________________________________________________________________'
  ostleinv()
  ?space(10)+repl('_', 109)
  ostleinv()
  ?space(10)+'Разом фактично за описом, грн.  _____________________________________________________________________________'
  ostleinv()
  ?space(10)+repl('_', 109)
  ostleinv()
  ?space(10)+repl('_', 109)
  ostleinv()
  ?space(10)+repl('_', 109)
  ostleinv()
  ?space(10)+'Голова комiсiї        __________________________   ___________________________   ____________________________'
  ostleinv()
  ?space(10)+'Члени комiсiї:        __________________________   ___________________________   ____________________________'
  ostleinv()
  ?space(10)+'                      __________________________   ___________________________   ____________________________'
  ostleinv()
  ?space(10)+'                      __________________________   ___________________________   ____________________________'
  ostleinv()
  ?space(10)+'                      __________________________   ___________________________   ____________________________'
  ostleinv()
  ?space(10)+'                      __________________________   ___________________________   ____________________________'
  ostleinv()
  ?space(10)+'  Усi  цiнностi,  перелiченi в iнвентарному описi з N  _________   по N  ___________,   комiсiєй   перевiренi'
  ostleinv()
  ?space(10)+'в моїй (нашiй) присутностi i внесенi до опису, в зв"язку  з  чим  претензiй  до   iнвентаризацiйної   комiсiї'
  ostleinv()
  ?space(10)+'не маю (не маємо). Цiнностi, перелiченi в опису, знаходяться на моєму (нашому) вiдповiдальному зберiганнi.'
  ostleinv()
  ?space(10)+'                                                    '
  ostleinv()
  ?space(10)+ 'Матерiально -  вiдовiдальна особа (особи)'
  ostleinv()
  ?space (10)+'"________"______________________  20____р."'
  ostleinv()
  ?space(10) +'Зазначенi у цьому опису данi та пiдрахунки   перевiрив         ________________________   __________________'
  ostleinv()
  ?space (10)+'"________"______________________  20____р.'
  sumir=0
  return

/*****************************************************************
 
 FUNCTION:
 АВТОР..ДАТА..........С. Литовка  31.05.16   //15:00:27
 НАЗНАЧЕНИЕ......... по плательщику
 ПАРАМЕТРЫ..........
 ВОЗВР. ЗНАЧЕНИЕ....
 ПРИМЕЧАНИЯ.........
 */
function AktChkKpl()
  local bFor1
  netuse('kln')
  netuse('kpl')
  netuse('banks')
  //netuse('mkeep')
  clear screen
  oclr=setcolor('gr+/b,n/w')

  kplr=1402546              //9999999
  mkeepr:=999

  while (.t.)

    @ 0, 1 say 'Плательщик   ' get kplr pict '9999999' ;
     valid kplr == 9999999 .or. akplkpl()

    /*
    @ 3,1 say 'Торг Марка МД' get mkeepr pict '999' ;
    valid mkeepr == 999 .or. mkeepi()
    @ 4,1 say '999 - Торг Марка MД'
    */
    read

    if (lastkey()=K_ESC)
      exit
    endif

    if (kplr == 9999999)
      bFor1:={ || .T. }
    else
      //
      bFor1:={ ||                                                        ;
               tmestor:=skl,                                             ;
               kplr = getfield('t1', 'tov->skl', 'etm', 'kpl')         ;
               .OR. kplr = getfield('t1', 'tov->skl', 'tmesto', 'kpl') ;
             }
    endif

    sbArOst(bFor1)

    use sbarost new
    index on str(kpl)+str(kgp) to t2

    CArAktChk()

    sele sbarost
    close

  enddo

  setcolor(oclr)
  nuse('kln')
  nuse('kpl')
  //nuse('mkeep')

  // выбор Плательщика
  // выбор МД
  return (nil)

/*****************************************************************
 
 FUNCTION:
 АВТОР..ДАТА..........С. Литовка  31.05.16   //15:19:36
 НАЗНАЧЕНИЕ......... по Торговому агенту
 ПАРАМЕТРЫ..........
 ВОЗВР. ЗНАЧЕНИЕ....
 ПРИМЕЧАНИЯ.........
 */
function AktChkTa()
  local bFor1
  netuse('s_tag')
  netuse('cskl')
  netuse('stagtm')
  netuse('stagm')
  clear screen
  oclr=setcolor('gr+/b,n/w')

  ktar=141                  //9999999

  while (.t.)

    @ 0, 1 say 'Торговый агент (TA)   ' get ktar pict '999' ;
     valid ktar == (-1) .or. kta()
    @ 2, 1 say '-1 -ТA без привязки к маршуту'

    /*
    @ 3,1 say 'Торг Марка МД' get mkeepr pict '999' ;
    valid mkeepr == 999 .or. mkeepi()
    @ 4,1 say '999 - Торг Марка MД'
    */
    read

    if (lastkey()=K_ESC)
      exit
    endif

    sele s_tag
    ktasr:=ktas
    if (ktar == (-1))
      nktar:='ТA без привязки к маршуту'
    else
      nktar:=fio
    endif

    @ 4, 1 say ALLTRIM(STR(ktar))+" "+ALLTRIM(nktar)

    if (ktar == -1)
      /*bFor1:={|| ;
      tmestor:=skl,;
      netseek('t1','tmestor'),;
             }*/
      /*
       bFor1:={|| ;
       tmestor:=skl, .f. ;
       .or. .not. stagtm->(netseek('t2','tov->skl'))  ; // ТТ найдено у ТА
       .or. .not. s_tag->(netseek('t1','stagtm->kta')) ; //  ТТ найдена, но ТА уволен или не найден
       .or. s_tag->uvol = 1 ;
              }
      */
      /*
       bFor1:={|| ;
       tmestor:=skl, .f. ;
       .or. .not. stagtm->(netseek('t2','tmestor'))  ; // ТТ найдено у ТА
       .or. .not. s_tag->(netseek('t1','stagtm->kta')) ; //  ТТ найдена, но ТА уволен или не найден
       .or. s_tag->uvol = 1 ;
              }
      */
      bFor1:={ ||                                                                                                  ;
               tmestor:=skl, .f.                                                                                   ;
               .or. .not. stagtm->(netseek('t2', 'tmestor'));// ТТ найдено у ТА
               .or. .not. stagtm->(                                                                               ;
                                    ordsetfocus('t2'),                                                           ;
                                    __dbLocate({ || s_tag->(netseek('t1', 'stagtm->kta')), s_tag->uvol = 0 }, ;
                                                { || tmestor == stagtm->tmesto }                                   ;
                                             ),                                                                   ;
                                    FOUND()                                                                        ;
                                 )                                                                                ;
             }

    else
      //
      if (gnEnt = 20)
        aListMkeep:={}
        do case
        case (stagm->(netseek('t1', 'ktar', 'stagm')))// по ТА
          while (ktar == stagm->kta)
            AADD(aListMkeep, stagm->Mkeep)
            stagm->(DBSKIP())
          enddo

        case (stagm->(netseek('t1', 'ktasr', 'stagm')))// по СВ
          while (ktasr == stagm->kta)
            AADD(aListMkeep, stagm->Mkeep)
            stagm->(DBSKIP())
          enddo

        endcase

        //aListMkeep:={}

        bFor1:={ ||                                                                         ;
                 (tmestor:=skl,                                                            ;
                   stagtm->(netseek('t1', 'ktar,tov->skl'))                             ;
                )         ;//  найдено ТА и ТТ
                 .and. IIF(EMPTY(aListMkeep), .T., ASCAN(aListMkeep, tov->Mkeep) # 0) ;
               }
      else
        bFor1:={ ||                                           ;
                 tmestor:=skl,                                ;
                 stagtm->(netseek('t1', 'ktar,tov->skl'));//  найдено ТА и ТТ
               }
        outlog(__FILE__, __LINE__)
      endif

    /*
    bFor1:={|| ;
    tmestor:=skl,;
    stagtm->(netseek('t1','ktar,tmestor')); //  найдено ТА и ТТ
           }
           */
    endif

    SbArOst(bFor1)

    use sbarost new Exclusive
    repl all ng with                                                           ;
     (tmestor:=skl, XTOC(.not.stagtm->(netseek('t2', 'tmestor'))))+' ' ;
     +XTOC(.not. s_tag->(netseek('t1', 'stagtm->kta'))) +' '             ;
     +XTOC(s_tag->uvol = 1)
    // FOR (tmestor:=skl, .T.)
    index on str(kgp)+str(kpl) to t3

    nCnt:=0
    kgpr:=0
    DBEVAL({ || iif(kgpr#kgp, (kgpr:=kgp, nCnt++), nil) })
    nktar=getfield('t1', 'ktar', 's_tag', 'fio')

    //b rowse()

    CArAktTAChk(nCnt, LASTREC())

    sele sbarost
    close

  enddo

  setcolor(oclr)
  nuse()
  nuse('kln')
  nuse('kpl')
  netuse('stagtm')
  netuse('stagm')
  return (nil)

/*****************************************************************
 
 FUNCTION:
 АВТОР..ДАТА..........С. Литовка  02.06.16   //19:40:21
 НАЗНАЧЕНИЕ.........  печать акта сверки по Плательщику
 ПАРАМЕТРЫ..........
 ВОЗВР. ЗНАЧЕНИЕ....
 ПРИМЕЧАНИЯ.........
 */
function CArAktChk()
  claprem=setcolor('gr+/b,n/bg')

  dtpremr=gdTd
  dgpremr=0
  dtdgpremr:= date()        //ctod('')
  firmr:=npl

  akldr=2
  aklar=3
  aklor=2
  waprem=wopen(7, 20, 17, 70)
  store space(15) to tvedr, mehr//firmr
  mlptr=4
  wbox(1)
  while (.t.)
    @ 0, 1 say 'Фирма     ' get firmr
    @ 1, 1 say 'Дата      ' get dtpremr
    @ 2, 1 say 'Акт N ' get dgpremr pict '9999999999'
    @ 2, col()+1 say 'От  ' get dtdgpremr
    @ 6, 1 say 'К-во экз A' get aklar pict '9'
    @ 8, 1 prom 'LPT1'
    @ 8, col()+1 prom 'LPT2'
    @ 8, col()+1 prom 'LPT3'
    @ 8, col()+1 prom 'Файл'
    read
    if (lastkey()=K_ESC)
      exit
    endif

    menu to mlptr
    if (lastkey()=K_ESC)
      exit
    endif

    exit
  enddo

  wclose(waprem)
  setcolor(claprem)
  if (mlptr#0)
    set cons off
    do case
    case (mlptr=1)
      set prin to lpt1
    case (mlptr=2)
      set prin to lpt2
    case (mlptr=3)
      set prin to lpt3
    case (mlptr=4)
      set prin to apremdu.txt
      mlptr=1
    endcase

    set prin on
    if (gnArnd=2)         //  склад Аренда
      while (aklar>0)
        sele sbarost
        DBGoTop()
        CAPrnAktChk()
        aklar=aklar-1
      enddo

    else                    // скда СубАренда
      while (aklar>0)
        sele sbarost
        DBGoTop()
        CAPrnAktChk()
        aklar=aklar-1
      enddo

    endif

    set prin off
    set prin to
    set cons on
  endif

  return (.t.)

/*****************************************************************
 
 FUNCTION:
 АВТОР..ДАТА..........С. Литовка  02.06.16   //15:37:42
 НАЗНАЧЕНИЕ.........  Акт  всерки субаренды по покудпателю
 ПАРАМЕТРЫ..........
 ВОЗВР. ЗНАЧЕНИЕ....
 ПРИМЕЧАНИЯ.........
 */
function CAPrnAktChk()
  // Книжная А4
  ?? chr(27)+'E'
  ?? chr(27)+'&l1h26a0O'+chr(27)
  ?? chr(27)+'(3R'
  ?? chr(27)+'(s0p20.00h0s1b4102T'+chr(27)

  ??space(70)+'Акт N"'+str(dgpremr, 10)
  ?PADC('звiрки взаємних розрахункiв за Обладнання', 128)
  ?PADC('на дату '+DTOC(dtdgpremr), 128)
  ?'Ми, що нижче пiписалися ______________________________________ '+gcName+' '   ;
   +alltrim(getfield('t1', 'gnKkl_c', 'kln', 'nklprn'))+' за одного боку та '

  ?subs(getfield('t1', 'kplr', 'kln', 'nklprn'), 1, 66)+' код ' ;
   + str(getfield('t1', 'kplr', 'kln', 'kkl1'), 10)             ;
   +' адрес '+subs(getfield('t1', 'kplr', 'kln', 'adr'), 1, 71)
  ?'з iншого, переглянувши, вивчивши та проаналiзував Видатковi накладнi та Акти приїму-передачi Обладнання склали наступний акт'

  while (Kpl = kplr)
    kgpr:=kgp
    nn_rr=1
    // счетчики сумм
    kol_rr:=sm_rr:=0
    adr_rr:=alltrim(getfield('t1', 'kgpr', 'kln', 'adr'))
    knasp_r:=getfield('t1', 'kgpr', 'kln', 'knasp')
    nnasp_r:=alltrim(getfield('t1', 'knasp_r', 'knasp', 'nnasp'))
    adr_r:= ALLTRIM(ngp) + ' ' + nnasp_r + ' ' + adr_rr
    ?''
    ?'│'+ PADR(adr_r + ' [kgp:'+LTRIM(STR(kgpr)) +' ТТ:'+LTRIM(STR(skl))+']', 180-2)+'│'
    ?'│(Фактична адреса торгової точки (мiсто, вулиця, будинок, назва торгової точки з вивiски)'
    ?'┌───┬───────────────────────────────────────────────────────────┬─────────┬──────────────┬───────────┬──────────────┬──────┬───────────────┬───────────────┐'
    ?'│N  │        Перелiк та модель Обладнання                       │Кiлькiсть│  Заводський  │Iнвентарний│Вартiсть Обл. │ Рiк  │Наявнiсть на   │               │'
    ?'│пп │                                                           │   Обл.  │ номер Обл.   │номер Обл. │  за одиницю  │введ в│торговель точцi│ Невiдповiднiть│'
    ?'│   │                                                           │ одиниць │              │           │(грн. без ПДВ)│експл.│               │               │'
    ?'├───┼───────────────────────────────────────────────────────────┼─────────┼──────────────┼───────────┼──────────────┼──────┼───────────────┼───────────────┤'

    while (Kpl = kplr .AND. kgpr = kgp)
      adr_r:=""; adr_r:= padr(adr_r, 15, '_')+'│'+padr(adr_r, 15, '_')
      ?'│'+str(nn_rr++, 3)+'│'+subs(nat, 1, 43+16)+'│'+(kol_rr+=osf, str(osf, 9))+'│'+subs(zn, 1, 14)+'│'+(subs(inp, 1, 11))+'│'+(sm_rr+=(ROUND(opt*osf, 2)), str(opt, 14, 3))+'│ '+str(year(dizg), 4)+' │'+adr_r+'│'
      DBSKIP()
    enddo

    ?'├───┼───────────────────────────────────────────────────────────┼─────────┼──────────────┼───────────┼──────────────┼──────┼───────────────────────────────┤'
    ?'│   │                                 РАЗОМ                     │'+str(kol_rr, 9)+'│              │           │'+str(sm_rr, 14, 2)+'│      │                               │'
    ?'└───┴───────────────────────────────────────────────────────────┴─────────┴──────────────┴───────────┴──────────────┴──────┴───────────────────────────────┘'

  enddo

  ?''
  //??chr(27)+'(3R'+chr(27)+'(s0p29.00h0s1b4102T'
  ??chr(27)+'&l3C'

  kob1r=getfield('t1', 'gnKkl_c', 'kln', 'kb1')
  kob2r=getfield('t1', 'kplr', 'kln', 'kb1')
  psser=getfield('t1', 'kplr', 'kln', 'psse')
  psnr=getfield('t1', 'kplr', 'kln', 'psn')
  psdtvr=getfield('t1', 'kplr', 'kln', 'psdtv')
  pskvr=getfield('t1', 'kplr', 'kln', 'pskv')
  ?'┌'+repl('─', 78-3)+'┬'+repl('─', 78)+'┐'
  ?'│'+padc('', 78-3)+'│'+padc(' ', 78)+'│'
  ?'│'+space(78-3)+'│'+space(78)+'│'
  ?'│'+'Найменування:'+subs(getfield('t1', 'gnKkl_c', 'kln', 'nklprn'), 1, 65-3)+'│'+'Найменування:'+subs(getfield('t1', 'kplr', 'kln', 'nklprn'), 1, 65)+'│'
  ?'│'+space(78-3)+'│'+space(78)+'│'
  ?'│'+'Адреса:'+subs(getfield('t1', 'gnKkl_c', 'kln', 'adr'), 1, 71-3)+'│'+'Адреса:'+subs(getfield('t1', 'kplr', 'kln', 'adr'), 1, 71)+'│'
  ?'│'+space(78-3)+'│'+space(78)+'│'
  ?'│'+'Телефон: '+getfield('t1', 'gnKkl_c', 'kln', 'tlf')+' Факс: '+space(52-3)+'│'+'Телефон: '+getfield('t1', 'kplr', 'kln', 'tlf')+' Факс: '+space(52)+'│'
  ?'│'+space(78-3)+'│'+space(78)+'│'
  ?'│'+'Код в ЄДРПОУ '+str(getfield('t1', 'gnKkl_c', 'kln', 'kkl1'), 10)+' IПН '+str(getfield('t1', 'gnKkl_c', 'kln', 'nn'), 12)+space(38-3)+'│'+'Код в ЄДРПОУ '+str(getfield('t1', 'kplr', 'kln', 'kkl1'), 10)+' IПН '+str(getfield('t1', 'kplr', 'kln', 'nn'), 12)+space(38)+'│'
  ?'│'+space(78)+'│'+space(78)+'│'
  ?'│'+'Св-во платника ПДВ '+getfield('t1', 'gnKkl_c', 'kln', 'nsv')+space(39-3)+'│'+'Св-во платника ПДВ '+getfield('t1', 'kplr', 'kln', 'nsv')+space(39)+'│'
  ?'│'+space(78-3)+'│'+space(78)+'│'
  ?'│'+'п/р '+getfield('t1', 'gnKkl_c', 'kln', 'ns1')+space(54-3)+'│'+'п/р '+getfield('t1', 'kplr', 'kln', 'ns1')+space(54)+'│'
  ?'│'+space(78-3)+'│'+space(78)+'│'
  ?'│'+'в '+getfield('t1', 'kob1r', 'banks', 'otb')+' МФО '+str(val(kob1r), 6)+space(25-3)+'│'+'в '+getfield('t1', 'kob2r', 'banks', 'otb')+' МФО '+str(val(kob2r), 6)+space(25)+'│'
  ?'│'+space(78-3)+'│'+space(78)+'│'
  ?'│'+space(78-3)+'│Паспорт: серiя '+allt(psser)+' номер '+allt(str(psnr, 9))+' виданий '+dtous(psdtvr)+' '+subs(pskvr, 1, 19)+'│'
  ?'│'+space(78-3)+'│'+space(78)+'│'
  ?'│'+space(78-3)+'│'+subs(pskvr, 20, 78)+'│'
  ?'└'+repl('─', 78-3)+'┴'+repl('─', 78)+'┘'
  ??chr(27)+'&l4C'
  ?''
  ?' _______Директор ТОВ "Лодiс-Суми"____________________________________           _____________________________________________________________'
  ?''
  ?''
  ?' ____________________________________/_______В.Ю.Калюжний____________/          __________________________________/_______________________________/'
  ?''
  ?'                                       М.П.                                                                     М.П.'
  ?''
  eject
  return (.t.)

/*****************************************************************
 
 FUNCTION:
 АВТОР..ДАТА..........С. Литовка  09.06.16   //14:56:23
 НАЗНАЧЕНИЕ.........
 ПАРАМЕТРЫ..........
 ВОЗВР. ЗНАЧЕНИЕ....
 ПРИМЕЧАНИЯ.........
 */
function CArAktTAChk(nCnt, nTotRec)
  claprem=setcolor('gr+/b,n/bg')

  dtpremr=gdTd
  dgpremr=0
  dtdgpremr:= date()        //ctod('')
  firmr:=npl

  akldr=2
  aklar=3
  aklor=2
  waprem=wopen(7, 20, 17, 70)
  store space(15) to tvedr, mehr//firmr
  mlptr=4
  wbox(1)
  while (.t.)
    @ 0, 1 say 'Торговый Агент ' get nktar
    @ 1, 1 say 'Дата      ' get dtpremr
    @ 2, 1 say 'Акт N ' get dgpremr pict '9999999999'
    @ 2, col()+1 say 'От  ' get dtdgpremr
    @ 4, 0 say 'Всего ТТ:'+LTRIM(STR(nCnt))+' записей:'+LTRIM(STR(nTotRec))

    @ 6, 1 say 'К-во экз A' get aklar pict '9'
    @ 8, 1 prom 'LPT1'
    @ 8, col()+1 prom 'LPT2'
    @ 8, col()+1 prom 'LPT3'
    @ 8, col()+1 prom 'Файл'
    read
    if (lastkey()=K_ESC)
      exit
    endif

    menu to mlptr
    if (lastkey()=K_ESC)
      exit
    endif

    exit
  enddo

  wclose(waprem)
  setcolor(claprem)
  if (mlptr#0)
    set cons off
    do case
    case (mlptr=1)
      set prin to lpt1
    case (mlptr=2)
      set prin to lpt2
    case (mlptr=3)
      set prin to lpt3
    case (mlptr=4)
      set prin to apremdu.txt
      mlptr=1
    endcase

    set prin on
    if (gnArnd=2)         //  склад Аренда
      while (aklar>0)
        sele sbarost
        DBGoTop()
        CAPrnAktTAChk()
        aklar=aklar-1
      enddo

    else                    // скда СубАренда
      while (aklar>0)
        sele sbarost
        DBGoTop()
        CAPrnAktTAChk()
        aklar=aklar-1
      enddo

    endif

    set prin off
    set prin to
    set cons on
  endif

  return (.t.)

/*****************************************************************
 
 FUNCTION:
 АВТОР..ДАТА..........С. Литовка  09.06.16   //15:41:37
 НАЗНАЧЕНИЕ.........    //Акт  всерки субаренды по TA
 ПАРАМЕТРЫ..........
 ВОЗВР. ЗНАЧЕНИЕ....
 ПРИМЕЧАНИЯ.........
 */
function CAPrnAktTAChk()
  // Книжная А4
  ?? chr(27)+'E'
  ?? chr(27)+'&l1h26a0O'+chr(27)
  ?? chr(27)+'(3R'
  ?? chr(27)+'(s0p20.00h0s1b4102T'+chr(27)

  ??PADC('Акт N"'+str(dgpremr, 10)+' вiд '+DTOC(dtdgpremr), 128)
  ?PADC('звiрки закрiпленого  Обладнання за Торговим Агентом ' ;
         + ALLTRIM(nktar)                                     ;
         +' ('+ALLTRIM(STR(ktar))+')', 128                  ;
      )

  nCntTT:=1
  kol_ro:=sm_ro:=0          // по общий
  while (!EOF())

    kgpr:=kgp
    kplr:=0
    // счетчики сумм
    nn_rr:=1
    kol_rr:=sm_rr:=0        // по точке

    adr_rr:=alltrim(getfield('t1', 'kgpr', 'kln', 'adr'))
    knasp_r:=getfield('t1', 'kgpr', 'kln', 'knasp')
    nnasp_r:=alltrim(getfield('t1', 'knasp_r', 'knasp', 'nnasp'))
    adr_r:= ALLTRIM(ngp) + ' ' + nnasp_r + ' ' + adr_rr
    //?''

    ??chr(27)+'&l4C'
    ?'│'+LTRIM(STR(nCntTT++))+'. '+ PADR(adr_r + ' [kgp:'+LTRIM(STR(kgpr)) +' ТТ:'+LTRIM(STR(skl))+']', 180-2)+'│'
    ?'│(Фактична адреса торгової точки (мiсто, вулиця, будинок, назва торгової точки з вивiски)'
    ?'┌───┬───────────────────────────────────────────────────────────┬─────────┬──────────────┬───────────┬──────────────┬──────┬───────────────┬───────────────┐'
    ?'│N  │        Перелiк та модель Обладнання                       │Кiлькiсть│  Заводський  │Iнвентарний│Вартiсть Обл. │ Рiк  │Наявнiсть на   │               │'
    ?'│пп │                                                           │   Обл.  │ номер Обл.   │номер Обл. │  за одиницю  │введ в│торговель точцi│ Невiдповiднiть│'
    ?'│   │                                                           │ одиниць │              │           │(грн. без ПДВ)│експл.│               │               │'
    ?'├───┼───────────────────────────────────────────────────────────┼─────────┼──────────────┼───────────┼──────────────┼──────┼───────────────┼───────────────┤'
    ??chr(27)+'&l6C'

    while (kgpr = kgp)
      if (kplr = 0 .or. kplr # kpl)
        kplr:=kpl
        //?'│'
        ?space(0)+'ПЛАТНИК:'
        ??ALLTRIM(subs(getfield('t1', 'kplr', 'kln', 'nklprn'), 1, 66))+' код ' ;
         + str(getfield('t1', 'kplr', 'kln', 'kkl1'), 10)                         ;
         +' адрес '+subs(getfield('t1', 'kplr', 'kln', 'adr'), 1, 71)
      //?'│'
      endif

      adr_r:=""; adr_r:= padr(adr_r, 15, '_')+'│'+padr(adr_r, 15, '_')
      ?'│'+str(nn_rr++, 3)+'│'+subs(nat, 1, 43+16)+'│'+(kol_rr+=osf, str(osf, 9))+'│'+subs(zn, 1, 14)+'│'+(subs(inp, 1, 11))+'│'+(sm_rr+=(ROUND(opt*osf, 2)), str(opt, 14, 3))+'│ '+str(year(dizg), 4)+' │'+adr_r+'│'
      DBSKIP()
    enddo

    // вывод итогов по ТТ
    ??chr(27)+'&l4C'
    ?'├───┼───────────────────────────────────────────────────────────┼─────────┼──────────────┼───────────┼──────────────┼──────┼───────────────────────────────┤'
    ?'│   │                                 РАЗОМ ПО ТТ               │'+(kol_ro += kol_rr, str(kol_rr, 9))+'│              │           │'+(sm_ro += sm_rr, str(sm_rr, 14, 2))+'│      │                               │'
    ?'└───┴───────────────────────────────────────────────────────────┴─────────┴──────────────┴───────────┴──────────────┴──────┴───────────────────────────────┘'
    ??chr(27)+'&l6C'
  enddo

  ??chr(27)+'&l4C'
  ?'├───┼───────────────────────────────────────────────────────────┼─────────┼──────────────┼───────────┼──────────────┼──────┼───────────────────────────────┤'
  ?'│   │                                 ВСЬОГО ПО ТА              │'+(str(kol_ro, 9))+'│              │           │'+(str(sm_ro, 14, 2))+'│      │                               │'
  ?'└───┴───────────────────────────────────────────────────────────┴─────────┴──────────────┴───────────┴──────────────┴──────┴───────────────────────────────┘'
  ??chr(27)+'&l6C'
  ?''
  ?' ____________________________________________________________________           _____________________________________________________________'
  ?''
  ?''
  ?' ____________________________________/_______________________________/          __________________________________/_______________________________/'
  ?''
  ?''
  eject
  return (.t.)
  return (nil)
