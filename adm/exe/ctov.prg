/***********************************************************
 * Модуль    : ctov.prg
 * Версия    : 0.0
 * Автор     :
 * Дата      : 02/13/20
 * Изменен   :
 * Примечание: Текст обработан утилитой CF версии 2.02
 */

#include "common.ch"
#include "inkey.ch"
para p1
// p1
// Справочник CTOV,CTOVP
sklr=0
save scre to sccskl
if (p1#nil)
  pathr=gcPath_ep
  if (!netuse('ctov', 'ctovp',, 1))
    wmess('Не удалось открыть CTOV поставщика')
    return
  endif

endif

netuse('kln')
netuse('cgrp')
netuse('ctov')
if (p1=nil)
  headr=alltrim(gcName_c)
else
  headr=alltrim(gcName_cp)
endif

oclr=setcolor('w+/b')
vur=1
clea
if (gnArm=19)
  forr='.t.'
else
  sklr=gnSkl
  forr="netseek('t5','gnSkl,ctov->mntov','tov')"
endif

bw='kg=kg_r'
store 0 to mnctovr, mnctovpr
go top
while (.t.)
  if (p1=nil)
    sele ctov
    set orde to 2
    if (gnArm=19)
      if (forr='.t.')
        foot('INS,F4,F6,F5,F8,ESC', 'Доб.,Коррекция,Изм.цены,Печать нов.карт.,Группа,Отмена')
      else
        foot('INS,F4,F6,F8,ESC', 'Доб.,Коррекция,Все,Группа,Отмена')
      endif

    else
      if (forr="netseek('t5','gnSkl,ctov->mntov','tov')")
        foot('INS,F4,F6,F8,ESC', 'Доб.,Коррекция,Изм.цены,Группа,Отмена')
      else
        foot('INS,F4,F6,F8,ESC', 'Доб.,Коррекция,Все,Группа,Отмена')
      endif

    endif

    mntovr=slcf('ctov', 1, 0, 18,, "e:mntov h:'Код' c:n(7) e:cnt h:'Сч' c:n(2) e:nat h:'Наименование' c:c(33) e:nei h:'Изм' c:c(3) e:izg h:'Изгот.' c:n(8) e:getfield('t1','ctov->izg','kln','nkl') h:'Наименование' c:c(20)", 'mntov',, 1,, forr,, 'ОБЩИЙ СПРАВОЧНИК '+headr)
  else
    sele ctovp
    set orde to 2
    if (forr='.t.')
      foot('INS,F6,F8,F5,ESC', 'Доб.в свой,Новые,Группа,Печать,Отмена')
    else
      foot('INS,F6,F8,ESC', 'Доб.в свой,Все,Группа,Отмена')
    endif

    mntovr=slcf('ctovp', 1, 0, 18,, "e:mntov h:'Код' c:n(7) e:cnt h:'Сч' c:n(2) e:nat h:'Наименование' c:c(33) e:nei h:'Изм' c:c(3) e:izg h:'Изгот.' c:n(8) e:getfield('t1','ctovp->izg','kln','nkl') h:'Наименование' c:c(20)", 'mntov',, 1,, forr,, 'ОБЩИЙ СПРАВОЧНИК '+headr)
  endif

  exxr=0
  netseek('t1', 'mntovr')
  rcn_rr=recn()
  kgrr=int(mntovr/10000)
  sele cgrp
  netseek('t1', 'kgrr')
  grmr=mark
  do case
  case (lastkey()=K_ESC)
    exit
  case (lastkey()=K_INS)  // Добавить в свой CTOV новую запись
    if (p1=nil)
      tovins(0, 'ctov')
    else                    // Добавить в свой CTOV новую запись из CTOVP
      tovins(0, 'ctov', mntovr)
    endif

  case (lastkey()=-3)     // Коррекция/Просмотр
    if (p1=nil)
      tovins(1, 'ctov')
    endif

  case (lastkey()=-5)     // Все/Изм
    if (p1=nil)
      if (gnArm=19)
        if (forr='.t.')
          forr='&gcDopt<&gcDoptp'
        else
          forr='.t.'
        endif

      else
        if (forr="netseek('t5','gnSkl,ctov->mntov','tov')")
          forr="netseek('t5','gnSkl,ctov->mntov').and."+'&gcDopt<&gcDoptp'
        else
          forr="netseek('t5','gnSkl,ctov->mntov','tov')"
        endif

      endif

    else                    // Все/Новые
      if (forr='.t.')
        forr='mntov'+iif(gnEnt<10, '0'+str(gnEnt, 1), str(gnEnt, 2))+'=0'
      else
        forr='.t.'
      endif

    endif

  case (lastkey()=-4)     // Нов/Изм
    if (p1=nil)
      vforr='&gcDopt<&gcDoptp'
    else
      vforr='mntov'+iif(gnEnt<10, '0'+str(gnEnt, 1), str(gnEnt, 2))+'=0'
    endif

    save screen to ctpr
    mess('Ждите...')
    if (p1=nil)
      sele ctov
    else
      sele ctovp
    endif

    if (gnOut=1)
      Set Device to Print
      set print to LPT1
    else
      Set Device to Print
      set print to txt.txt
    endif

    go top
    copy to nctovp for &vforr
    sele 0
    use nctovp
    list=1
    str=1
    set console off
    set print on
    ?chr(27)+chr(77)+chr(15)
    ?'Печать новых карточек'
    ?repl('-', 60)
    ??'  Лист'+str(list, 2)
    go top
    while (!eof())
      ?str(mntov, 7)+' '+substr(nat, 1, 50)
      str=str+1
      if (str=61)
        str=2
        list=list+1
        eject
        ?repl('-', 60)
        ??'  Лист'+str(list)
      endif

      skip
    enddo

    set console on
    set print off
    set device to screen
    nuse('nctovp')
    erase nctovp.dbf
    rest screen from ctpr
    if (p1=nil)
      sele ctov
    else
      sele ctovp
    endif

    go rcn_rr
    loop
  case (lastkey()=-7)     // Выбор группы
    if (gnArm=19)
      sele cgrp
    else
      sele sgrp
    endif

    set order to 2
    go top
    rcn_gr=recn()
    while (.t.)
      if (gnArm=19)
        sele cgrp
      else
        sele sgrp
      endif

      set order to 2
      rcn_gr=recno()
      if (gnArm=19)
        kg_r=slcf('cgrp',,,,, "e:kgr h:'Код' c:n(3) e:ngr h:'Наименование' c:c(20)", 'kgr')
      else
        kg_r=slcf('cgrp',,,,, "e:kgr h:'Код' c:n(3) e:ngr h:'Наименование' c:c(20)", 'kgr')
      endif

      do case
      case (lastkey()=K_ENTER)
        if (p1=nil)
          sele ctov
        else
          sele ctovp
        endif

        if (!netseek('t2', 'kg_r'))
          go rcn_rr
        endif

        exit
      case (lastkey()=K_ESC)
        exit
      case (lastkey()>32.and.lastkey()<255)
        //case lastkey()>=65.and.lastkey()<=90.or.lastkey()>=97.and.lastkey()<=122.or.lastkey()>=128.and.lastkey()<=175.or.lastkey()>=224.and.lastkey()<=239
        if (gnArm=19)
          sele cgrp
        else
          sele sgrp
        endif

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
    //case lastkey()>=65.and.lastkey()<=90.or.lastkey()>=97.and.lastkey()<=122.or.lastkey()>=128.and.lastkey()<=175.or.lastkey()>=224.and.lastkey()<=239
    if (p1=nil)
      sele ctov
    else
      sele ctovp
    endif

    lstkr=upper(chr(lastkey()))
    if (!netseek('t2', 'int(mntovr/10000),lstkr'))
      go rcn_rr
    endif

  otherwise
    return
  endcase

enddo

setcolor(oclr)
nuse()
nuse('ctovp')
rest scre from sccskl

