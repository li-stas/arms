/***********************************************************
 * Модуль    : ptovslcc.prg
 * Версия    : 0.0
 * Автор     :
 * Дата      : 02/13/20
 * Изменен   :
 * Примечание: Текст обработан утилитой CF версии 2.02
 * Отбор товара из CTOV (приход)
 * gnCtov=1
 */

#include "common.ch"
#include "inkey.ch"
/*
Function ptovslcc()
  Return (Nil)
*/
local rcn_rr
pptr=0
mntovpr=0
ktlpr=0
rcn_rr=0
kgs_r=0
save scre to sctovslcd
oclr2=setcolor('w+/b')
if (select('sl')=0)
  sele 0
  use _slct alias sl excl
  zap
endif

netuse('ctov')
sele ctov
set order to tag t2
kg_rr=int(mntovr/10000)
if (!netseek('t1', 'mntovr,natr'))
  if (!netseek('t2', 'kg_rr'))
    go top
  endif

endif

skllr=sklr
prpstr=0
skp_r='.t.'
skpr=skp_r
ctxtr=space(20)
flttmr=0                    // Признак тек.мес.
fltizgr=0                   // Изг
flttvr=0
while (.t.)
  sklr=skllr
  foot('SPACE,F2,F3,F5,F7,F8', 'Отбор,Поиск,Фильтр,Отдел,Копия,Группа')
  rcn_rr=recn()
  /*   if gnOt=0
   *      skpr='.t.'
   *   else
   *      skpr='ot=gnOt'
   *   endif
   */
  skpr='fskpr().and.&skpr'
  nazvr='Общий справочник предприятия'
  if (gnRoz=0)
    mntovr=slcf('ctov', 7, 1, 12,, "e:mntov h:'Код' c:n(7) e:iif(netseek('t1','sklr,ctov->mntov','tovm'),1,0) h:'Д' c:n(1) e:nat h:'Наименование' c:c(51) e:upak_s() h:'Упаковка' c:c(4) e:nei h:'Изм' c:c(4)", 'mntov', 1, 1,, skpr, 'g/n,n/g', nazvr)
  else
    mntovr=slcf('ctov', 7, 1, 12,, "e:mntov h:'Код' c:n(7) e:iif(netseek('t1','sklr,ctov->mntov','tovm'),1,0) h:'Д' c:n(1) e:nat h:'Наименование' c:c(41) e:upak_s() h:'Упаковка' c:c(4) e:nei h:'Изм' c:c(3) e:&cboptr h:'Отп.цена' c:n(9,3)", 'mntov', 1, 1,, skpr, 'g/n,n/g', nazvr)
  endif

  sele ctov
  netseek('t1', 'mntovr')
  /*   cntr=cnt */
  ktlpr=0
  exxr=0
  do case
  case (lastkey()=K_SPACE)// Отбор
    sele tov
    tovins(0, 'tov', mntovr)
    if (prinstr=1)        // Запись добавлена в TOV
      // pr2kvp(1)
      pr2kvp(0)
      pere(1)
      exit
    endif

  case (lastkey()=K_F3)   // Фильтр
    clfltr=setcolor('gr+/b,n/bg')
    wfltr=wopen(10, 24, 14, 55)
    wbox(1)
    do case
    case (gnArnd=2)
      ctxtr=space(20)
      @ 0, 1 say 'Контекст' get ctxtr
      read
    otherwise
      @ 0, 1 get flttmr pict '9'
      @ 0, col()+1 say '0-Все;1-Тек.мес.'
      @ 1, 1 say 'Изг  ' get fltizgr pict '9999999'
      @ 2, 1 say 'Товар' get flttvr pict '9999999'
      read
    endcase

    wclose(wfltr)
    setcolor(clfltr)
    if (lastkey()=K_ENTER)
      do case
      case (gnArnd=2)
        ctxtr=alltrim(ctxtr)
        ctxtr=lower(ctxtr)
        if (empty(ctxtr))
          skpr=skp_r
        else
          skpr=skp_r+".and.at(ctxtr,lower(nat))#0"
        endif

      otherwise
        if (flttvr=0)
          if (flttmr=0)
            skpr=skp_r
          else
            skpr=skp_r+".and.netseek('t1','sklr,ctov->mntov','tovm')"
          endif

          if (fltizgr#0)
            skpr=skpr+'.and.iif(ctov->kg=kgs_r,izg=fltizgr,.t.)'
          endif

        else
          sele ctov
          if (!netseek('t1', 'flttvr'))
            go top
          endif

        endif

      endcase

    endif

  case (lastkey()=K_F2.and.gnArnd=2)// Поиск в аренде
    clfltr=setcolor('gr+/b,n/bg')
    wfltr=wopen(10, 24, 13, 55)
    wbox(1)
    ctxtr=space(20)
    @ 0, 1 say 'Контекст' get ctxtr
    read
    wclose(wfltr)
    setcolor(clfltr)
    if (lastkey()=K_ENTER)
      save scree to scarnd
      ctxtr=alltrim(ctxtr)
      ctxtr=lower(ctxtr)
      crtt('tarnd', 'f:sk c:n(3) f:tmesto c:n(7) f:arnd c:n(3) f:nat c:c(60)')
      sele 0
      use tarnd
      sele cskl
      go top
      while (!eof())
        if (!(ent=gnEnt.and.arnd#0))
          skip
          loop
        endif

        pathr=gcPath_d+alltrim(path)
        skr=sk
        arndr=arnd
        mess(pathr)
        if (sk=gnSk)
          sele tov
          go top
          while (!eof())
            if (osf=0)
              skip
              loop
            endif

            tmestor=Skl
            natr=alltrim(nat)
            natr=lower(natr)
            if (at(ctxtr, natr)#0)
              sele tarnd
              appe blank
              repl sk with skr,     ;
               tmesto with tmestor, ;
               arnd with arndr,     ;
               nat with natr
            endif

            sele tov
            skip
          enddo

        else
          netuse('tov', 'tov3',, 1)
          sele tov3
          go top
          while (!eof())
            if (osf=0)
              skip
              loop
            endif

            natr=alltrim(nat)
            natr=lower(natr)
            tmestor=skl
            if (at(ctxtr, natr)#0)
              sele tarnd
              appe blank
              repl sk with skr,     ;
               tmesto with tmestor, ;
               arnd with arndr,     ;
               nat with natr
            endif

            sele tov3
            skip
          enddo

          nuse('tov3')
        endif

        sele cskl
        skip
      enddo

      rest scree from scarnd
      sele tarnd
      go top
      rctarndr=recn()
      while (.t.)
        foot('', '')
        sele tarnd
        go rctarndr
        mntovr=slcf('tarnd',,,,, "e:sk h:'SK' c:n(7) e:arnd h:'A' c:n(2) e:tmesto h:'TMESTO' c:n(7) e:nat h:'Наименование' c:c(60)",,,,,,,)
        if (lastkey()=K_ESC)
          exit
        endif

        go rctarndr
      enddo

      sele tarnd
      CLOSE
      erase tarnd.dbf
      sele ctov
    endif

  case (lastkey()=K_F5)   // Отдел
    sele cskle
    if (netseek('t1', 'gnSk'))
      gnOt=slcf('cskle',,,,, "e:ot h:'От' c:n(2) e:nai h:'Наименование' c:c(20)", 'ot', 0,, 'sk=gnSk')
      if (netseek('t1', 'gnSk,gnOt'))
        gcNot=nai
        @ 1, 60 say gcNot color 'gr+/n'
      endif

    endif

    sele ctov
    go top
    loop
  case (lastkey()=K_F7.and.gnArnd=2.and.int(mntovr/10000)=30)// Копия
    sele ctov
    arec:={}
    getrec()
    kg_r=int(mntovr/10000)
    sele cgrp
    if (netseek('t1', 'kg_r'))
      reclock()
      mntovr=mntov
      netrepl('mntov', 'mntov+1')
      sele ctov
      netadd()
      putrec()
      netrepl('mntov', 'mntovr')
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
      kgs_r=kg_r
      do case
      case (lastkey()=K_ENTER)
        sele ctov
        if (!netseek('t2', 'kg_r'))
          mntovr=kg_r*10000
          netAdd()
          netrepl('mntov,kg', 'mntovr,kg_r', 1)
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

    store 0 to flttmr, fltizgr
    skpr=skp_r
    sele ctov
    loop
  case (lastkey()=K_ESC)  //
    exit
  case (lastkey()>32.and.lastkey()<255)
    //case lastkey()>=65.and.lastkey()<=90.or.lastkey()>=97.and.lastkey()<=122.or.lastkey()>=128.and.lastkey()<=175.or.lastkey()>=224.and.lastkey()<=239
    sele ctov
    lstkr=upper(chr(lastkey()))
    if (!netseek('t2', 'int(mntovr/10000),lstkr'))
      go rcn_rr
    endif

  case (lastkey()=K_F4)
    tovins(1, 'ctov')
  case (lastkey()=K_INS)
    tovins(0, 'ctov')
  otherwise
    loop
  endcase

enddo

setcolor(oclr2)
rest scre from sctovslcd

/***********************************************************
 * fskpr() -->
 *   Параметры :
 *   Возвращает:
 */
function fskpr()
  sele sgrp
  if (netseek('t1', 'ctov->kg'))
    sele ctov
    return (.t.)
  else
    sele ctov
    return (.f.)
  endif

RETURN (NIL)

/*********************** */
function ktlzen(p1)
  /* Поиск ktl c ценой p1
   ***********************
   */
  for yyr=year(gdTd) to 2006 step -1
    pathgr=gcPath_e+'g'+str(yyr, 4)+'\'
    do case
    case (yyr=year(gdTd))
      mm1r=month(gdTd)
      mm2r=1
    endcase

  next

  return (ktlr)
