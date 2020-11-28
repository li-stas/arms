/***********************************************************
 * Модуль    : tovm.prg
 * Версия    : 0.0
 * Автор     :
 * Дата      : 05/01/18
 * Изменен   :
 * Примечание: Текст обработан утилитой CF версии 2.02
 */

#include "common.ch"
#include "inkey.ch"
// Справочник TOVM()
/*****************************************************************
 
 PROCEDURE:
 АВТОР..ДАТА..........С. Литовка  31.05.16 * 16:20:52
 НАЗНАЧЕНИЕ.........
 ПАРАМЕТРЫ..........
 ПРИМЕЧАНИЯ.........
 */
//PROCEDURE tovm
if (gnCtov#1)
  return
endif

save scre to sccskl
netuse('ctov')
netuse('cgrp')
netuse('tovm')
netuse('tov')
netuse('sgrp')
netuse('cskle')
netuse('cskl')
netuse('kln')
netuse('soper')
netuse('lic')
netuse('klnlic')
netuse('dkkln')
netuse('mkeep')
netuse('mkeepe')
netuse('tmesto'); netuse('etm')
// netuse('tovpt')
netuse('arvid')
netuse('posid')
netuse('posbrn')
netuse('kspovo')

netuse('pr1')
netuse('pr2')

sele pr1
prJfr=0
SklJfr=0
SkJfr=0
if (netseek('t3', '1'))
  if (kps=2248008)
    prJfr=1
  endif

endif

nuse('pr1')

sele pr2
ordSetFocus('t5')

// *wait
if (prJfr=1)
  SkJfr=254
  sele cskl
  locate for sk=SkJfr
  if (foun())
    pathr=gcPath_d+alltrim(path)
    SklJfr=skl
    if (!netfile('tov', 1))
      prJfr=0
    endif

  endif

endif

if (prJfr=1)
  netuse('tov', 'tovj',, 1)
  netuse('tovm', 'tovmj',, 1)
endif

oclr=setcolor('w+/b')
cntr=0
clea
if (gnMskl=0)
  sklr=gnSkl
else
  TovTarm()
  sklr=0
endif

if (prJfr=1)
  sele tovmj
  ordSetFocus('t6')
  // 48459 - ном док протокола (времменного ПА)
  sele tovm
  set rela to ' 48459'+str(MnTov, 7) into pr2, str(MnTov, 7) into tovmj
endif

sele tovm
set orde to tag t2

go top
rctovmr=recn()
prF7r=0
TovmVidr=1
ctxtr=space(20)
kodst1_r=0
prtpr=0
for_r='.t.'
forr='.t.'
if (gnMskl=0)
  whilr='.t.'
else
  if (sklr=0)
    whilr='.t.'
  else
    whilr='skl=sklr'
  endif

endif

prF1r=0
while (.t.)
  if (prF1r=0)
    if (prF7r=0)
      foot('ENTER,F2,F3,F4,F5,F6,F7,F8,F9,F10', 'Парт,Вид,Код,Просм,-Ост,Скл,ШК.,Гр,Пр,Рсх')
    else
      foot('ENTER,F2,F3,F4,F5,F6,F7,F8,F9,F10', 'Парт,Вид,Код,Просм,-Ост,Скл,ШК.,Гр,Пр,Рсх')
    endif

  else
    foota('F2,F3,F7,F9,F10', 'КонтрОтгр,Тместо,ШК,ПрA,РсхA')
  endif

  sele tovm
  set orde to tag t2

  go rctovmr
  if (gnMskl=1)
    if (sklr=0)
      whilr='.t.'
    else
      whilr='skl=sklr'
    endif

  else
    sklr=gnSkl
  endif

  nspravr='Справочник склада '+alltrim(gcNskl)+' по отпускным ценам'
  FldNomr:=1
  if (prF7r=0)
    if (gnOtv=1)
      if (gnMskl=0)

        if (TovmVidr=1)
          FldNomr:=3
          rctovmr=slcf('tovm', 1, 0, 18,, "e:mntov h:'Код' c:n(7) e:nat h:'Наименование' c:c(27) e:nei h:'Изм' c:c(3) e:osn h:'Ост.нач.' c:n(9,2) e:osf h:'Ост.факт' c:n(9,2) e:osv h:'Ост.вып.' c:n(9,2)" ;
                        +" e:osvo h:'Ост.ОТВ.' c:n(9,2)"                                                                                                                                                    ;
                        +" e:osvo+pr2->kf h:'Без пр-ла' c:n(9,2)"                                                                                                                                           ;
                        +" e:tovmj->osf h:'Ост.254' c:n(9,2)",                                                                                                                                              ;
                        nil, nil, 1, whilr, forr,, nspravr, nil, 3                                                                                                                                          ;
                     )
        else
          FldNomr:=3
          rctovmr=slcf('tovm', 1, 0, 18,, "e:mntov h:'Код' c:n(7) e:nat h:'Наименование' c:c(27) e:nei h:'Изм' c:c(3) e:osn h:'Ост.нач.' c:n(9,2) e:osfo h:'Ост.отгр' c:n(9,2) e:osv h:'Ост.вып.' c:n(9,2)" ;
                        +" e:osvo h:'Ост.ОТВ.' c:n(9,2)"                                                                                                                                                     ;
                        +" e:osvo+pr2->kf h:'Без пр-ла' c:n(9,2)"                                                                                                                                            ;
                        +" e:tovmj->osf h:'Ост.254' c:n(9,2)",                                                                                                                                               ;
                        nil, nil, 1, whilr, forr,, nspravr                                                                                                                                                   ;
                     )     // ,1,2)
        endif

      else
        if (TovmVidr=1)
          rctovmr=slcf('tovm', 1, 0, 18,, "e:skl h:'Склад' c:n(7) e:mntov h:'Код' c:n(7) e:nat h:'Наименование' c:c(27) e:nei h:'Изм' c:c(3) e:osn h:'Ост.нач.' c:n(9,2) e:osf h:'Ост.факт' c:n(9,2) e:osv h:'Ост.вып.' c:n(9,2)", ;
                        ,, 1, whilr, forr,, nspravr                                                                                                                                                                                 ;
                     )
        else
          rctovmr=slcf('tovm', 1, 0, 18,, "e:skl h:'Склад' c:n(7) e:mntov h:'Код' c:n(7) e:nat h:'Наименование' c:c(27) e:nei h:'Изм' c:c(3) e:osn h:'Ост.нач.' c:n(9,2) e:osfo h:'Ост.отгр' c:n(9,2) e:osv h:'Ост.вып.' c:n(9,2)", ;
                        ,, 1, whilr, forr,, nspravr                                                                                                                                                                                  ;
                     )
        endif

      endif

    else
      if (gnMskl=0)
        if (TovmVidr=1)
          rctovmr=slcf('tovm', 1, 0, 18,, "e:mntov h:'Код' c:n(7) e:nat h:'Наименование' c:c(36) e:nei h:'Изм' c:c(3) e:osn h:'Ост.нач.' c:n(9,2) e:osf h:'Ост.факт' c:n(9,2) e:osv h:'Ост.вып.' c:n(9,2)", ;
                        ,, 1, whilr, forr,, nspravr                                                                                                                                                          ;
                     )
        else
          rctovmr=slcf('tovm', 1, 0, 18,, "e:mntov h:'Код' c:n(7) e:nat h:'Наименование' c:c(36) e:nei h:'Изм' c:c(3) e:osn h:'Ост.нач.' c:n(9,2) e:osfo h:'Ост.отгр' c:n(9,2) e:osv h:'Ост.вып.' c:n(9,2)", ;
                        ,, 1, whilr, forr,, nspravr                                                                                                                                                           ;
                     )
        endif

      else
        if (TovmVidr=1)
          rctovmr=slcf('tovm', 1, 0, 18,, "e:skl h:'Склад' c:n(7) e:mntov h:'Код' c:n(7) e:nat h:'Наименование' c:c(28) e:nei h:'Изм' c:c(3) e:osn h:'Ост.нач.' c:n(9,2) e:osf h:'Ост.факт' c:n(9,2) e:osv h:'Ост.вып.' c:n(9,2)", ;
                        ,, 1, whilr, forr,, nspravr                                                                                                                                                                                 ;
                     )
        else
          rctovmr=slcf('tovm', 1, 0, 18,, "e:skl h:'Склад' c:n(7) e:mntov h:'Код' c:n(7) e:nat h:'Наименование' c:c(28) e:nei h:'Изм' c:c(3) e:osn h:'Ост.нач.' c:n(9,2) e:osfo h:'Ост.отгр' c:n(9,2) e:osv h:'Ост.вып.' c:n(9,2)", ;
                        ,, 1, whilr, forr,, nspravr                                                                                                                                                                                  ;
                     )
        endif

      endif

    endif

  else
    if (gnOtv=1)
      if (gnMskl=0)
        if (TovmVidr=1)
          rctovmr=slcf('tovm', 1, 0, 18,, "e:mntov h:'Код' c:n(7) e:nat h:'Наименование' c:c(27) e:'ящ.' h:'Изм' c:c(3) e:osn/upakp h:'Ост.нач.' c:n(9,2) e:osf/upakp h:'Ост.факт' c:n(9,2) e:osv/upakp h:'Ост.вып.' c:n(9,2) e:osvo/upakp h:'Ост.ОТВ.' c:n(9,2) ", ;
                        ,, 1, whilr, forr,, nspravr                                                                                                                                                                                                                  ;
                     )
        else
          rctovmr=slcf('tovm', 1, 0, 18,, "e:mntov h:'Код' c:n(7) e:nat h:'Наименование' c:c(27) e:'ящ.' h:'Изм' c:c(3) e:osn/upakp h:'Ост.нач.' c:n(9,2) e:osfo/upakp h:'Ост.отгр' c:n(9,2) e:osv/upakp h:'Ост.вып.' c:n(9,2) e:osvo/upakp h:'Ост.ОТВ.' c:n(9,2) ", ;
                        ,, 1, whilr, forr,, nspravr                                                                                                                                                                                                                   ;
                     )
        endif

      else
        if (TovmVidr=1)
          rctovmr=slcf('tovm', 1, 0, 18,, "e:skl h:'Склад' c:n(7) e:mntov h:'Код' c:n(7) e:nat h:'Наименование' c:c(27) e:'ящ.' h:'Изм' c:c(3) e:osn/upakp h:'Ост.нач.' c:n(9,2) e:osf/upakp h:'Ост.факт' c:n(9,2) e:osv/upakp h:'Ост.вып.' c:n(9,2)", ;
                        ,, 1, whilr, forr,, nspravr                                                                                                                                                                                                     ;
                     )
        else
          rctovmr=slcf('tovm', 1, 0, 18,, "e:skl h:'Склад' c:n(7) e:mntov h:'Код' c:n(7) e:nat h:'Наименование' c:c(27) e:'ящ.' h:'Изм' c:c(3) e:osn/upakp h:'Ост.нач.' c:n(9,2) e:osfo/upakp h:'Ост.отгр' c:n(9,2) e:osv/upakp h:'Ост.вып.' c:n(9,2)", ;
                        ,, 1, whilr, forr,, nspravr                                                                                                                                                                                                      ;
                     )
        endif

      endif

    else
      if (gnMskl=0)
        if (TovmVidr=1)
          rctovmr=slcf('tovm', 1, 0, 18,, "e:mntov h:'Код' c:n(7) e:nat h:'Наименование' c:c(36) e:'ящ.' h:'Изм' c:c(3) e:osn/upakp h:'Ост.нач.' c:n(9,2) e:osf/upakp h:'Ост.факт' c:n(9,2) e:osv/upakp h:'Ост.вып.' c:n(9,2)", ;
                        ,, 1, whilr, forr,, nspravr                                                                                                                                                                              ;
                     )
        else
          rctovmr=slcf('tovm', 1, 0, 18,, "e:mntov h:'Код' c:n(7) e:nat h:'Наименование' c:c(36) e:'ящ.' h:'Изм' c:c(3) e:osn/upakp h:'Ост.нач.' c:n(9,2) e:osfo/upakp h:'Ост.отгр' c:n(9,2) e:osv/upakp h:'Ост.вып.' c:n(9,2)", ;
                        ,, 1, whilr, forr,, nspravr                                                                                                                                                                               ;
                     )
        endif

      else
        if (TovmVidr=1)
          rctovmr=slcf('tovm', 1, 0, 18,, "e:skl h:'Склад' c:n(7) e:mntov h:'Код' c:n(7) e:nat h:'Наименование' c:c(28) e:'ящ.' h:'Изм' c:c(3) e:osn/upakp h:'Ост.нач.' c:n(9,2) e:osf/upakp h:'Ост.факт' c:n(9,2) e:osv/upakp h:'Ост.вып.' c:n(9,2)", ;
                        ,, 1, whilr, forr,, nspravr                                                                                                                                                                                                     ;
                     )
        else
          rctovmr=slcf('tovm', 1, 0, 18,, "e:skl h:'Склад' c:n(7) e:mntov h:'Код' c:n(7) e:nat h:'Наименование' c:c(28) e:'ящ.' h:'Изм' c:c(3) e:osn/upakp h:'Ост.нач.' c:n(9,2) e:osfo/upakp h:'Ост.отгр' c:n(9,2) e:osv/upakp h:'Ост.вып.' c:n(9,2)", ;
                        ,, 1, whilr, forr,, nspravr                                                                                                                                                                                                      ;
                     )
        endif

      endif

    endif

  endif

  exxr=0
  sele tovm
  go rctovmr
  llsklr=skl
  if (gnMskl=0)
    sklr=skl
  endif

  mntovr=mntov
  natr=nat
  kg_r=int(mntovr/10000)
  barr=bar
  dppr=dpp
  dpor=dpo
  sele sgrp
  do case
  case (lastkey()=K_LEFT)
    FldNomr--
    if (FldNomr=0)
      FldNomr:=1
    endif

    loop
  case (lastkey()=K_RIGHT)
    FldNomr++
    loop
  case (lastkey()=K_F1)   // F1
    if (prF1r=0)
      prF1r=1
    else
      prF1r=0
    endif

  case (lastkey()=K_ESC)
    exit
  case (lastkey()=K_F2)   // Вид
    sele tovm
    if (fieldpos('osfo')#0)
      if (TovmVidr=1)
        TovmVidr=2
      else
        TovmVidr=1
      endif

    endif

  case (lastkey()=K_ALT_F2)// Контроль отгрузки
    chktm()
  case (lastkey()=K_ALT_F3)//-32 // Тместо

    kgpr=0; kplr=0
    sele etm
    if !netseek('t1','llsklr')
      sele tmesto
      netseek('t1','llsklr')
    endif
    kgpr=kgp; kplr=kpl

    if (kgpr # 0)
      scetmvr=setcolor('gr+/b,n/w')
      wetmvr=wopen(8, 5, 18, 75)
      wbox(1)
      @ 0, 1 say 'Плательщик'+' '+str(kplr, 7)+' '+alltrim(getfield('t1', 'kplr', 'kln', 'nkl'))
      @ 1, 1 say 'Адрес     '+' '+alltrim(getfield('t1', 'kplr', 'kln', 'adr'))
      @ 3, 1 say 'Получатель'+' '+str(kgpr, 7)+' '+alltrim(getfield('t1', 'kgpr', 'kln', 'nkl'))
      @ 4, 1 say 'Адрес     '+' '+alltrim(getfield('t1', 'kgpr', 'kln', 'adr'))
      inkey(0)
      wclose(wetmvr)
      setcolor(scetmvr)
    endif

  case (lastkey()=K_F4)
    mmsklr=sklr
    sklr=llsklr
    if (gnAdm=1.or.gnCenP=1.or.gnArnd#0)
      TovIns(1, 'tovm')
    else
      TovIns(2, 'tovm')
    endif

    sklr=mmsklr
    sele tovm
    go rctovmr
  case (lastkey()=K_F5)   // Краснота
    if (gnMskl=0)
      if (select('tred')#0)
        sele tred
        CLOSE
      endif

      erase tred.dbf
      crtt('tred', 'f:mntov c:n(7) f:ktl c:n(9) f:nat c:c(40) f:osn c:n(12,3) f:osv c:n(12,3) f:osf c:n(12,3) f:osvo c:n(12,3)')
      sele 0
      use tred
      sele tov
      go top
      /*              mess('Ждите...') */
      while (!eof())
        /*                 if otv=1
         *                    skip
         *                    loop
         *                 endif
         */
        otvr=otv
        if (osn<0.or.osv<0.or.osf<0).and.otvr=0.or.osvo<0.and.otvr=1
          mntovr=mntov
          ktlr=ktl
          natr=nat
          osnr=osn
          osvr=osv
          osfr=osf
          osvor=osvo
          sele tred
          netadd()
          if (otvr=0)
            netrepl('mntov,ktl,nat,osn,osv,osf', 'mntovr,ktlr,natr,osnr,osvr,osfr')
          else
            netrepl('mntov,ktl,nat,osvo', 'mntovr,ktlr,natr,osvor')
          endif

        endif

        sele tov
        skip
      enddo

      sele tred
      go top
      rctredr=slcf('tred',,,,, "e:ktl h:'Код' c:n(9) e:nat h:'Наименование' c:c(29) e:osn h:'ОстН' c:n(9,3) e:osv h:'ОстВ' c:n(9,3) e:osf h:'ОстФ' c:n(9,3) e:osvo h:'ОстОтв' c:n(9,3)")
      if (lastkey()=K_ENTER)
        sele tred
        go rctredr
        mntovr=mntov
        sele tovm
        if (netseek('t1', 'sklr,mntovr'))
          rctovmr=recn()
        endif

      endif

    endif

    sele tovm
  case (lastkey()=K_F6.and.gnMskl=1)
    cltt=setcolor('gr+/b,n/bg')
    wtt=wopen(10, 20, 14, 40)
    wbox(1)
    llsklr=sklr
    mmsklr=sklr
    @ 0, 1 say 'Код скл.' get llsklr pict '9999999'
    read
    wclose(wtt)
    setcolor(cltt)
    if (lastkey()=K_ESC)
      loop
    endif

    store 0 to kpl_r, kgp_r
    tsklfor_r='.t.'
    tsklforr=tsklfor_r
    if (llsklr=0)
      sele ltar
      go top
      while (.t.)
        rc_tar=recn()
        if (gnTskl=3)
          foot('F3', 'Фильтр')
          llsklr=slcf('ltar',,,,, "e:skl h:'Код' c:n(7) e:nskl h:'Наименование' c:c(40) e:skl h:'Код' c:n(7) e:kpl h:'Плат' c:n(7) e:kgp h:'Получ' c:n(7)", 'skl',, 1,, tsklforr)
        else
          foot('', '')
          llsklr=slcf('ltar',,,,, "e:nskl h:'Наименование' c:c(40) e:skl h:'Код' c:n(7)", 'skl')
        endif

        do case
        case (lastkey()=K_ESC.or.lastkey()=K_ENTER)
          if (lastkey()=K_ENTER)
            sklr=llsklr
          endif

          if (lastkey()=K_ESC)
            sklr=mmsklr
          endif

          exit
        case (lastkey()>32.and.lastkey()<255)
          lstkr=upper(chr(lastkey()))
          seek lstkr
          if (!FOUND())
            go rc_tar
          endif

        case (lastkey()=K_F3.and.gnTskl=3)
          tsklflt()
          sele ltar
          go top
          rc_tar=recn()
        endcase

      enddo

    else
      sklr=llsklr
    endif

    sele tovm
    if (sklr#0)
      if (sklr#1)
        if (!netseek('t2', 'sklr'))
          sklr=1
        endif

      endif

    endif

    if (sklr#1)
      if (sklr#mmsklr)
        rctovmr=recn()
        whilr='skl=sklr'
      endif

    else
      sklr=0
      whilr='.t.'
      sele tovm
      go top
      rctovmr=recn()
    endif

    wclose(wtt)
    setcolor(cltt)
  case (lastkey()=K_F7)   // Штрих-код было в ящиках
    clsco=setcolor('gr+/b,n/bg')
    wsco=wopen(10, 30, 12, 70)
    wbox(1)
    @ 0, 1 say 'Штрих-код ' get barr pict '9999999999999'
    read
    if (barr#0.and.lastkey()=K_ENTER)
      if (!netseek('t3', 'barr', 'tovm'))
        sele ctov
        //                 if !netseek('t4','barr')
        if (netseek('t1', 'mntovr'))
          netrepl('bar,dtbar', 'barr,date()')
          sele tovm
          go rctovmr
          netrepl('bar,dtbar', 'barr,date()')
        endif

      /*                else
       *                   wmess('Такой код существует в CTOV '+str(ctov->mntov,7),0)
       *                endif
       */
      else
        wmess('Такой код существует в TOVM '+str(tovm->mntov, 7), 0)
      endif

    endif

    wclose(wsco)
    setcolor(clsco)

  /*           if prF7r=0
  *              prF7r=1
  *           else
  *              prF7r=0
  *           endif
  */
  case (lastkey()=K_ALT_F7)// Штрих-код было в ящиках
    clsco=setcolor('gr+/b,n/bg')
    wsco=wopen(10, 30, 12, 70)
    wbox(1)
    while (.t.)
      @ 0, 1 say 'Штрих-код ' get barr pict '9999999999999'
      read
      if (lastkey()=K_ESC)
        exit
      endif

      if (barr#0)
        if (!netseek('t4', 'barr', 'ctov'))
          wmess('Не найден', 1)
        else
          wmess('Существует', 1)
        endif

      endif

      barr=0
    enddo

    wclose(wsco)
    setcolor(clsco)
  case (lastkey()=K_F3)
    ctxtr=space(20)
    bar_r=0
    kodst1_r=0
    /*           prtpr=0 */
    if (gnMskl=1)
      sklr=0
    endif

    ktlr=0
    mntovr=0
    cltt=setcolor('gr+/b,n/bg')
    wtt=wopen(10, 20, 17, 50)
    wbox(1)
    if (gnMskl=0)
      @ 0, 1 say 'Штрих-код ' get bar_r pict '9999999999999'
      @ 1, 1 say 'Код товара' get ktlr pict '999999999'
      @ 2, 1 say 'Товар     ' get mntovr pict '9999999'
      @ 3, 1 say 'Контекст  ' get ctxtr
      @ 4, 1 say 'Код стат  ' get kodst1_r pict '9999'
      @ 5, 1 say 'Только род' get prtpr pict '9'
    else
      @ 0, 1 say 'Склад     ' get sklr pict '9999999'
      @ 1, 1 say 'Код товара' get ktlr pict '999999999'
      @ 2, 1 say 'Товар     ' get mntovr pict '9999999'
      @ 3, 1 say 'Контекст  ' get ctxtr
    endif

    read
    wclose(wtt)
    setcolor(cltt)
    if (lastkey()=K_ESC)
      forr=for_r
      ctxtr=space(20)
      ktlr=0
      mmtovr=0
      loop
    else
      ctxtr=alltrim(upper(ctxtr))
      forr=for_r
      if (gnMskl=0)
        if (bar_r#0)
          sele tovm
          if (!netseek('t3', 'bar_r'))
            wmess('Нет такого кода', 2)
            go rctovmr
          else
            rctovmr=recn()
          endif

        endif

        if (ktlr#0)
          sele tov
          if (netseek('t1', 'sklr,ktlr'))
            mntovr=mntov
            sele tovm
            if (!netseek('t1', 'sklr,mntovr'))
              go rctovmr
            else
              rctovmr=recn()
            endif

          else
            wmess('Нет такого кода', 1)
          endif

          forr=for_r
        endif

        if (mntovr#0)
          sele tovm
          if (!netseek('t1', 'sklr,mntovr'))
            go rctovmr
          else
            rctovmr=recn()
          endif

          forr=for_r
        endif

        if (!empty(ctxtr))
          ctxtr=alltrim(ctxtr)
          forr=for_r+'.and.at(ctxtr,upper(nat))#0'
          sele tovm
          go top
          rctovmr=recn()
        endif

        if (kodst1_r#0)
          forr=for_r+'.and.kodst1=kodst1_r'
          sele tovm
          go top
          rctovmr=recn()
        endif

        if (prtpr=1)
          forr=for_r+'.and.mntov=mntovt'
          sele tovm
          go top
          rctovmr=recn()
        endif

      else                  // gnMskl=1
        if (sklr#0)
          if (bar_r=0.and.ktlr=0.and.mntovr=0.and.empty(ctxtr))
            forr=for_r
            sele tovm
            if (netseek('t2', 'sklr'))
              rctovmr=recn()
            endif

            loop
          endif

          if (bar_r#0)
            forr=for_r+'.and.skl=sklr.and.bar=bar_r'
            sele tovm
            go top
            rctovmr=recn()
            loop
          endif

          if (ktlr#0)
            forr=for_r+".and.skl=sklr.and.netseek('t1','sklr,ktlr','tov')"
            sele tovm
            go top
            rctovmr=recn()
            loop
          endif

          if (mntovr#0)
            sele tovm
            if (!netseek('t1', 'sklr,mntovr'))
              go rctovmr
            else
              rctovmr=recn()
            endif

            forr=for_r
            loop
          endif

          if (!empty(ctxtr))
            ctxtr=alltrim(ctxtr)
            forr=for_r+'.and.skl=sklr.and.at(ctxtr,nat)#0'
            sele tovm
            go top
            rctovmr=recn()
            loop
          endif

        else                // sklr=0
          if (bar_r#0)
            forr=for_r+'.and.bar=bar_r'
            sele tovm
            go top
            rctovmr=recn()
            loop
          endif

          if (ktlr#0)
            forr=for_r+".and.getfield('t4','ktlr','tov','mntov')=tovm->mntov.and.tovm->skl#0"
            /*                       forr=for_r+".and.netseek('t4','ktlr','tov')" */
            sele tovm
            go top
            rctovmr=recn()
            loop
          endif

          if (mntovr#0)
            forr=for_r+".and.mntov=mntovr"
            sele tovm
            go top
            rctovmr=recn()
          endif

          if (!empty(ctxtr))
            ctxtr=alltrim(ctxtr)
            forr=for_r+'.and.at(ctxtr,upper(nat))#0'
            sele tovm
            go top
            rctovmr=recn()
            loop
          endif

        endif

      endif

    endif

  case (lastkey()=K_F8)   //.and.gnMskl=0
    sele sgrp
    set order to tag t2
    go top
    if (gnOt=0)
      forgr=".t..and.netseek('t2','sklr,sgrp->kgr','tovm')"
    else
      forgr="ot=gnOt.and.netseek('t2','sklr,sgrp->kgr','tovm')"
    endif

    rcn_gr=recn()
    while (.t.)
      sele sgrp
      set order to tag t2
      rcn_gr=recno()
      kg_r=slcf('sgrp',,,,, "e:kgr h:'Код' c:n(3) e:ot h:'От' c:n(2) e:ngr h:'Наименование' c:c(20)", 'kgr',,,, forgr)
      do case
      case (lastkey()=K_ENTER)
        sele tovm
        if (!netseek('t2', 'sklr,kg_r'))
          go rctovmr
        else
          rctovmr=recn()
        endif

        /*                      forr='kg=kg_r' */
        exit
      case (lastkey()=K_ESC)
        sele tovm
        if (!netseek('t2', 'sklr,kg_r'))
          go rctovmr
        else
          rctovmr=recn()
        endif

        forr='.t.'
        exit
      case (lastkey()>32.and.lastkey()<255)
        sele sgrp
        lstkr=upper(chr(lastkey()))
        if (!netseek('t2', 'lstkr'))
          go rcn_gr
        endif

        loop
      otherwise
        loop
      endcase

    enddo

  case (lastkey()>32.and.lastkey()<255)
    sele tovm
    lstkr=upper(chr(lastkey()))
    if (!netseek('t2', 'sklr,int(mntovr/10000),lstkr'))
      go rctovmr
    else
      rctovmr=recn()
    endif

  case (lastkey()=K_F9)   // Приход
    mmsklr=sklr
    sklr=llsklr
    tov_r='tovm'
    pr1ktl()
    sklr=mmsklr
  case (lastkey()=K_F10)  // Расход
    mmsklr=sklr
    sklr=llsklr
    tov_r='tovm'
    rs1ktl()
    sklr=mmsklr
  case (lastkey()=K_ALT_F9.and.gnArnd#0)// Приход аренда
    pr1ktla()
  case (lastkey()=K_ALT_F10.and.gnArnd#0)// Расход аренда
    rs1ktla()
  case (lastkey()=K_ENTER)               // По партиям
    mmsklr=sklr
    sklr=llsklr
    tovp()
    sklr=mmsklr
  endcase

enddo

setcolor(oclr)
if (prJfr=1)
  nuse('tovj')
  nuse('tovmj')
endif

nuse()
nuse('lizg')
nuse('ltar')
nuse('totv')
erase lizg.dbf
erase lizg.cdx
erase ltar.dbf
erase ltar.cdx
erase totv.dbf
erase totv.cdx
rest scre from sccskl
//RETURN

procedure tovizgm
  if (select('lizg')#0)
    sele lizg
    CLOSE
  endif

  if (gnMskl=0)
    crtt('lizg', "f:izg c:n(8) f:nizg c:c(40)")
    sele 0
    use lizg
    index on str(izg, 8) tag lizg1
    sele tovm
    while (!eof())
      iz_rr=izg
      nizgr=''
      if (iz_rr=0)
        skip
        loop
      endif

      sele lizg
      seek str(iz_rr, 8)
      if (!FOUND())
        nizgr=getfield('t1', 'iz_rr', 'kln', 'nkl')
        appe blank
        repl izg with iz_rr, nizg with nizgr
      endif

      sele tovm
      skip
    enddo

    sele lizg
    inde on nizg tag lizg2
  endif

  return

/***********************************************************
 * tovtarm
 *   Параметры:
 */
procedure tovtarm
  if (gnMskl#0)
    crtt('ltar', "f:skl c:n(7) f:nskl c:c(40) f:kpl c:n(7) f:kgp c:n(7)")
    sele 0
    use ltar
    index on str(skl, 7) tag ltar1
    netadd()
    netrepl('skl,nskl', '1,".    Все"')
    sele tovm
    while (!eof())
      skl_rr=skl
      nsklrr=''
      if (skl_rr=0)
        skip
        loop
      endif

      sele ltar
      seek str(skl_rr, 7)
      if (!FOUND())
        store 0 to kplr, kgpr
        if (gnTskl=3)

          kgpr=0; kplr=0
          sele etm
          if !netseek('t1','skl_rr')
            sele tmesto
            netseek('t1','skl_rr')
          endif
          kgpr=kgp; kplr=kpl

          nsklrr=subs(ntmesto, 1, 40)

        else
          nsklrr=getfield('t1', 'skl_rr', 'kln', 'nkl')
        endif

        sele ltar
        if (!empty(nsklrr))
          appe blank
          repl skl with skl_rr, nskl with alltrim(nsklrr)
          if (gnTskl=3)
            repl kpl with kplr, ;
             kgp with kgpr
          endif

        endif

      endif

      sele tovm
      skip
    enddo

    sele ltar
    inde on nskl tag ltar2
  endif

  return

/***********************************************************
 * ost() -->
 *   Параметры :
 *   Возвращает:
 */
function ost(p1, p2, p3, p4, p5)
  local ctovr, ctovmr, sklr, ktlr, mntovr, rctovr, rctovmr, kolr, mskostr, iost, iostr

  /* p1 - skl
   * p2 - ktl
   * p3 - kol
   * p4 - mskost (osv,osf,osfo,osvo) '1111'
   * p5 - pref ('in','out')
   */

  if (empty(p1).or.empty(p2).or.empty(p4))
    return (.f.)
  endif

  if (p3=nil)
    return (.f.)
  endif

  sklr=p1
  ktlr=p2
  kolr=p3
  mskostr=p4

  if (empty(p5))
    ctovr='tov'
    ctovmr='tovm'
  else
    ctovr='tov'+p3
    ctovmr='tovm'+p3
  endif

  sele (ctovr)
  rctovr=recn()
  sele (ctovmr)
  rctovmr=recn()

  sele (ctovr)
  if (netseek('t1', 'sklr,ktlr'))
    mntovr=mntov
    sele (ctovmr)
    if (netseek('t1', 'sklr,mntovr'))
      reclock()
      sele (ctovr)
      reclock()
      for iost=1 to len(mskostr)
        iostr=subs(mskostr, iost, 1)
        if (iostr='1')
          do case
          case (iost=1)
            sele (ctovr)
            netrepl('osv', 'osv+kolr', 1)
            sele (ctovmr)
            netrepl('osv', 'osv+kolr', 1)
          case (iost=2)
            sele (ctovr)
            netrepl('osf', 'osf+kolr', 1)
            sele (ctovmr)
            netrepl('osf', 'osf+kolr', 1)
          case (iost=3)
            sele (ctovr)
            netrepl('osfo', 'osfo+kolr', 1)
            sele (ctovmr)
            netrepl('osfo', 'osfo+kolr', 1)
          case (iost=4)
            sele (ctovr)
            netrepl('osvo', 'osvo+kolr', 1)
            sele (ctovmr)
            netrepl('osvo', 'osvo+kolr', 1)
          endcase

        endif

      next

      sele (ctov)
      netunlock()
      sele (ctovm)
      netunlock()
    else
      go rctovmr
      sele (ctovr)
      go rctovr
      return (.f.)
    endif

  else
    go rctovr
    return (.f.)
  endif

  sele (ctovmr)
  go rctovmr
  sele (ctovr)
  go rctovr
  return (.t.)

/***********************************************************
 * chktm() -->
 *   Параметры :
 *   Возвращает:
 */
function chktm()
  /* p1 mntov
   * Контроль отгрузки
   */
  clea
  kmonr=2
  cltt=setcolor('gr+/b,n/bg')
  wtt=wopen(8, 30, 12, 50)
  wbox(1)
  @ 0, 1 say 'К-во месяцев' get kmonr pict '99'
  read
  wclose(wtt)
  setcolor(cltt)
  if (lastkey()=K_ESC)
    return (.t.)
  endif

  ddc_r=bom(addmonth(gdTd, -kmonr+1))
  mess('Ждите...')
  erase chktm.dbf
  erase chktm.cdx
  crtt('chktm', 'f:ttn c:n(6) f:ddc c:d(10) f:prz c:n(1) f:kop c:n(3) f:dtotgr c:d(10) f:smotgr c:n(12,2) f:dttek c:d(10) f:smtek c:n(12,2) f:dt c:d(10)')
  sele 0
  use chktm excl
  inde on str(ttn, 6) tag t1
  for krsor=kmonr to 1 step -1
    kmon_r=kmonr-krsor
    dtr=bom(addmonth(gdTd, -kmon_r))
    yy_r=year(dtr)
    mm_r=month(dtr)
    pathr=gcPath_e+'g'+str(yy_r, 4)+'\m'+iif(mm_r<10, '0'+str(mm_r, 1), str(mm_r, 2))+'\'+gcDir_t
    mess(pathr)
    netuse('rso1',,, 1)
    netuse('rso2',,, 1)
    netuse('rs1',,, 1)
    netuse('rs2',,, 1)
    sele rs1
    go top
    while (!eof())
      /*if ttn=30221
       *wait
       *endif
       */
      if (!(vo=9.or.vo=6))
        skip
        loop
      endif

      if (ddc<ddc_r)
        skip
        loop
      endif

      ttnr=ttn
      praddr=0
      if (!netseek('t2', 'ttnr,mntovr', 'rs2'))
        sele rso2
        set orde to tag t4
        if (!netseek('t4', 'mntovr'))
          sele rs1
          skip
          loop
        else
          while (mntov=mntovr)
            if (ttn=ttnr)
              praddr=1
              exit
            endif

            sele rso2
            skip
          enddo

        endif

      else
        praddr=1
      endif

      if (praddr=0)
        sele rs1
        skip
        loop
      endif

      sele rs1
      kopr=kop
      przr=prz
      dttekr=dop
      smtekr=sdv
      ddcr=ddc
      sele chktm
      if (!netseek('t1', 'ttnr'))
        netadd()
        netrepl('ttn,ddc,prz,kop,dttek,smtek,dt', 'ttnr,ddcr,przr,kopr,dttekr,smtekr,dtr')
      endif

      if (empty(dtotgr))
        sele rso1
        set orde to tag t2
        if (netseek('t2', 'ttnr'))
          while (ttn=ttnr)
            if (prNpp#7)
              skip
              loop
            else
              if (vo=9.or.vo=6).and.ddc>ddc_r
                dtotgrr=dNpp
                smotgrr=sdv
                sele chktm
                netrepl('dtotgr,smotgr', 'dtotgrr,smotgrr')
                exit
              endif

            endif

            sele rso1
            skip
          enddo

        endif

      endif

      sele rs1
      skip
    enddo

    sele rso2
    set orde to tag t4
    if (netseek('t4', 'mntovr'))
      while (mntov=mntovr)
        /*if ttn=30221
         *wait
         *endif
         */
        ttnr=ttn
        sele chktm
        if (!netseek('t1', 'ttnr'))
          sele rso1
          if (netseek('t2', 'ttnr'))
            while (ttn=ttnr)
              if (prNpp#7)
                skip
                loop
              else
                if (vo=9.or.vo=6).and.ddc>ddc_r
                  kopr=kop
                  przr=prz
                  dtotgrr=dNpp
                  smotgrr=sdv
                  ddcr=ddc
                  sele chktm
                  netadd()
                  netrepl('ttn,ddc,prz,kop,dtotgr,smotgr,dt', 'ttnr,ddcr,przr,kopr,dtotgrr,smotgrr,dtr')
                  exit
                endif

              endif

              sele rso1
              skip
            enddo

          endif

        else
          if (empty(dtotgr))
            sele rso1
            if (netseek('t2', 'ttnr'))
              while (ttn=ttnr)
                if (prNpp=7)
                  dtotgrr=dNpp
                  smotgrr=sdv
                  sele chktm
                  netrepl('dtotgr,smotgr', 'dtotgrr,smotgrr')
                  sele rso1
                  exit
                endif

                sele rso1
                skip
              enddo

            endif

          endif

        endif

        sele rso2
        skip
      enddo

    endif

    nuse('rso1')
    nuse('rso2')
    nuse('rs1')
    nuse('rs2')
  next

  clea
  sele chktm
  go top
  for_rr='smotgr#smtek.and.(!empty(dtotgr).or.!empty(dttek))'
  rcchkr=recn()
  while (.t.)
    foot('F5', 'Печать')
    sele chktm
    go rcchkr
    rcchkr=slcf('chktm', 1, 1, 18,, "e:ttn h:'ТТН' c:n(6) e:prz h:'П' c:n(1) e:kop h:'КОП' c:n(3) e:ddc h:'Создан' c:d(10) e:dtotgr h:'Отгружен' c:d(10) e:smotgr h:'СуммаО' c:n(10,2) e:dttek h:'ОтгруженТ' c:d(10) e:smtek h:'СуммаОТ' c:n(10,2) e:dt h:'Месяц' c:d(10)",,,,, for_rr,, str(mntovr, 7)+' '+alltrim(natr))
    if (lastkey()=K_ESC)
      exit
    endif

    do case
    case (lastkey()=K_F5)
      chktmprn()
    endcase

  enddo

  nuse('chktm')
  return (.t.)

/***********************************************************
 * chktmprn() -->
 *   Параметры :
 *   Возвращает:
 */
function chktmprn()
  vlpt=0
  alpt={ 'lpt1', 'lpt2', 'lpt3', 'Файл' }
  vlpt=alert('ПЕЧАТЬ', alpt)
  if (lastkey()=K_ESC)
    return
  endif

  set cons off
  do case
  case (vlpt=1)
    set prin to lpt1
  case (vlpt=2)
    set prin to lpt2
  case (vlpt=3)
    set prin to lpt3
  case (vlpt=4)
    set prin to chktm.txt
  endcase

  set prin on
  if (vlpt=1)
    if (empty(gcPrn))
      ??chr(27)+chr(80)+chr(15)
    else
      ??chr(27)+'E'+chr(27)+'&l4h25a0O'+chr(27)+'&k2S'+chr(27)+'(3R'+chr(27)+'(s0p18.00h0s1b4102T'+chr(27)
    endif

  else
    ??chr(27)+'E'+chr(27)+'&l4h25a0O'+chr(27)+'&k2S'+chr(27)+'(3R'+chr(27)+'(s0p18.00h0s1b4102T'+chr(27)
  endif

  ?gcNskl+' '+dtoc(date())+' '+time()+' '+dtoc(gdTd)
  ?str(mntovr, 7)+' '+natr
  ?'┌──────┬─┬───┬──────────┬──────────┬──────────┬──────────┬──────────┬──────────┐'
  ?'│  ТТН │П│КОП│  Создан  │ Отгружен │  СуммаО  │ ОтгруженТ│  СуммаТ  │В периоде │'
  ?'├──────┼─┼───┼──────────┼──────────┼──────────┼──────────┼──────────┼──────────┤'
  sele chktm
  go top
  while (!eof())
    if (!(smotgr#smtek.and.(!empty(dtotgr).or.!empty(dttek))))
      skip
      loop
    endif

    ?'│'+str(ttn, 6)+'│'+str(prz, 1)+'│'+str(kop, 3)+'│'+dtoc(ddc)+'│'+dtoc(dtotgr)+'│'+str(smotgr, 10, 2)+'│'+dtoc(dttek)+'│'+str(smtek, 10, 2)+'│'+dtoc(dt)+'│'
    skip
  enddo

  set prin off
  set prin to
  set cons on
  return (.t.)

/**************** */
function tsklflt()
  /**************** */
  store 0 to kpl_r, kgp_r
  sctskl=setcolor('gr+/b,n/w')
  wtskl=wopen(8, 20, 12, 60)
  wbox(1)
  @ 0, 1 say 'Плательщик' get kpl_r pict '9999999'
  @ 1, 1 say 'Получатель' get kgp_r pict '9999999'
  read
  wclose(wtskl)
  setcolor(sctskl)
  if (lastkey()=K_ESC)
    tsklforr=tsklfor_r
  endif

  if (lastkey()=K_ENTER)
    tsklforr=tsklfor_r
    if (kpl_r#0)
      tsklforr=tsklforr+'.and.kpl=kpl_r'
    endif

    if (kgp_r#0)
      tsklforr=tsklforr+'.and.kgp=kgp_r'
    endif

  endif

  return (.t.)
