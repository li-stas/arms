/***********************************************************
 * Модуль    : ptovslc3.prg
 * Версия    : 0.0
 * Автор     :
 * Дата      : 02/13/20
 * Изменен   :
 * Примечание: Текст обработан утилитой CF версии 2.02
  Отбор товара из CTOVK (приход)
 */

#include "common.ch"
#include "inkey.ch"
/*
FUNCTION ptovslc3()
  RETURN (NIL)
*/
local rcn_rr
mntovpr=0
pptr=0
ktlpr=0
rcn_rr=0
save scre to sctovslcd
oclr2=setcolor('w+/b')
if (select('sl')=0)
  sele 0
  use _slct alias sl excl
  zap
endif

sele ctovk
set orde to tag t2
kg_rr=int(ktlr/1000000)
nat_r=upper(nat)
if (!netseek('t2', 'kg_rr,nat_r'))
  nat_rr=subs(nat_r, 1, 1)
  if (!netseek('t2', 'kg_rr,nat_rr'))
    if (!netseek('t2', 'kg_rr'))
      go top
    endif

  endif

endif

skllr=sklr
while (.t.)
  sklr=skllr
  foot('SPACE,INS,F4,F8,ESC', 'Отбор,Доб,Корр,Группа,Закон.')
  ctovkrcnr=recn()
  ctovkskpr="!netseek('t1','sklr,ctovk->ktl','tov')"
  nazvr='Общий внутренний справочник предприятия'
  ktlr=slcf('ctovk', 7, 1, 12,, "e:ktl h:'Код' c:n(9) e:cnt h:'Счт' c:n(3) e:' ' h:'Д' c:c(1) e:nat h:'Наименование' c:c(39) e:upak_s() h:'Упк' c:c(4) e:nei h:'Изм' c:c(3) e:&coptr h:'Зак.цена' c:n(9,3)", 'ktl', 1, 1,, ctovkskpr, 'g/n,n/g', nazvr)
  sele ctovk
  netseek('t1', 'ktlr')
  cntr=cnt
  exxr=0
  ctovkrcnr=recn()
  do case
  case (lastkey()=K_SPACE)// Отбор
    tovins(0, 'tov', ktlr, 1)
    if (prinstr=1)        // Запись добавлена в TOV
      pr2kvp(1)
      pere(1)
      exit
    endif

  case (lastkey()=K_INS)  // Добавить
    tovins(0, 'ctovk')
  case (lastkey()=K_F4)   // Коррекция
    if (cntr=0)
      tovins(1, 'ctovk')
    else
      tovins(2, 'ctovk')
    endif

  case (lastkey()=K_F8)   // Группа
    foot('', '')
    sele sgrp
    set orde to tag t2
    go top
    rcn_gr=recn()
    while (.t.)
      sele sgrp
      set orde to tag t2
      rcn_gr=recn()
      kg_r=slcf('sgrp',,,,, "e:kgr h:'Код' c:n(3) e:ngr h:'Наименование' c:c(20)", 'kgr',, 1)
      sele sgrp
      netseek('t1', 'kg_r')
      grmr=mark
      do case
      case (lastkey()=K_ENTER)
        sele ctovk
        if (!netseek('t2', 'kg_r'))
          ktlr=kg_r*1000000
          netAdd()
          netrepl('kg,ktl', 'kg_r,ktlr')
        endif

        exit
      case (lastkey()=K_ESC)
        exit
      case (lastkey()>32.and.lastkey()<255)
        //case lastkey()>=65.and.lastkey()<=90.or.lastkey()>=97.and.lastkey()<=122.or.lastkey()>=128.and.lastkey()<=175.or.lastkey()>=224.and.lastkey()<=239
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

    sele ctovk
    loop
  case (lastkey()=K_ESC)  //
    exit
  case (lastkey()>32.and.lastkey()<255)
    //case lastkey()>=65.and.lastkey()<=90.or.lastkey()>=97.and.lastkey()<=122.or.lastkey()>=128.and.lastkey()<=175.or.lastkey()>=224.and.lastkey()<=239
    sele ctovk
    lstkr=upper(chr(lastkey()))
    if (!netseek('t2', 'int(ktlr/1000000),lstkr'))
      go ctovkrcnr
    endif

  otherwise
    loop
  endcase

enddo

setcolor(oclr2)
rest scre from sctovslcd

