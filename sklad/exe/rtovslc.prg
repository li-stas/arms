/***********************************************************
 * Модуль    : rtovslc.prg
 * Версия    : 0.0
 * Автор     :
 * Дата      : 09/11/19
 * Изменен   :
 * Примечание: Текст обработан утилитой CF версии 2.02
 */

#include "common.ch"
#include "inkey.ch"
para p1, p2
local rcn_rr, rcn_r_start, rcn_r
private forNaT, whileNat, whileNat
forakc:=".AND..T."
forNaT:=".AND..T."
forOtv:=.T.; Otv()
whileCond:=".T."
whileNat:=".AND..T."
rcn_rr=0
filterr=.f.
save scre to sctovslc
oclr1=setcolor('w+/b')
if (select('sl')=0)
  sele 0
  use _slct alias sl excl
  zap
endif

sele rs2
if (netseek('t1', 'ttnr'))
  set orde to tag t1
  while (ttn=ttnr)
    ktl_r=ktl
    sele tov
    if (netseek('t1', 'sklr,ktl_r'))
      rcn_rr=recn()
    endif

    sele sl
    appe blank
    repl kod with str(ktl_r, 9), kol with rcn_rr
    sele rs2
    skip
  enddo

endif

sele tov
set orde to tag t2
ind='2'
go top
ktlr=ktl
rcn_r_start:=rcn_r:=recn()
whileCond:=nil
prTovr=0
prf8r=0
prF1r=0
fldnomr=1
while (.t.)
  sele tov
  if (prf8r=0)
    set orde to tag t2
  else
    set orde to tag t6
  endif

  go rcn_r
  if (prF1r=0)
    if (prTovr=0)
      foot('SPACE,INS,F2,F3,F4,F5,F6,F8,ESC', 'Отбор,Доб.,Тов-7,Фильтр,Корр,Отдел,Изгот,Группа,Закон.')
    else
      foot('SPACE,INS,F2,F3,F4,F5,F6,F8,ESC', 'Отбор,Доб.,Код-9,Фильтр,Корр,Отдел,Изгот,Группа,Закон.')
    endif

  else
    foota('F8', 'Маркодержатель')
  endif

  do case
  case (gnD0k1=0.and.gnRegrs=0)//анализ на ноль только в расходе
    if (gnOt=0)
      if (gnBlk#2)
        if (forOtv)
          skpr="iif(otv=0,osv>0,osvo>0).and.skl=sklr"
        else
          skpr="iif(otv=0,osv#0,osvo#0).and.skl=sklr"
        endif

      else
        skpr="osv>0.and.skl=sklr"
      endif

    else
      if (gnBlk#2)
        skpr="iif(otv=0,osv>0,osvo>0).and.skl=sklr.and.ot=gnOt"
      else
        skpr="osv>0.and.skl=sklr.and.ot=gnOt"
      endif

    endif

  case (gnD0k1=0.and.gnRegrs=1)
    if (gnOt=0)
      skpr='skl=sklr'
    else
      skpr='skl=sklr.and.ot=gnOt'
    endif

  endcase

  //   if gnD0k1=0.and.gnVo=6
  //      skpr=skpr+".and.tov->otv=0"
  //   endif
  if (gnD0k1=0.and.gnKt=1)
    skpr=skpr+'.and.ttnkt=ttnktr'
  endif

  if (gnRasc=1)
    if (fieldpos('pr169')#0)
      if (gnVo=9.and.kopr#169)
        skpr=skpr+".and.iif(getfield('t1','tov->mntov','ctov','pr169')=0,.t.,.f.)"
      endif

    endif

  endif

  sele tov
  if (fieldpos('bon')=0)
    skpr:=skpr+forkopr+forNaT
  else
    if (!(gnVo=6.and.(kopr=101.or.kopr=121.or.kopr=181).or.gnVo=9.and.(kopr=191.or.kopr=173).or.gnVo=2.and.kopr=173))
      skpr:=skpr+forkopr+forNaT
    else
      skpr:=skpr+forkopr+forNaT+'.and.bon#1'
    endif

  endif

  if (gnCtov=1.and.(gnEnt=13.or.gnEnt=16).and.!(kopr=191.or.kopr=173).and.gnVo=9.and.!(alltrim(uprlr)=='orex'.or.alltrim(uprlr)=='tanp'))
    forakc:=".and.getfield('t1','int(tov->mntov/10000)','cgrp','tgrp')=0"
  else
    forakc:=".AND..T."
  endif

  skpr=skpr+forakc
  if (gnEnt=20)           //.and.gnRasc=1
    if (kopr=177.or.kopir=177)
      if (prakcr=0)
        skpr=skpr+".and.getfield('t1','tov->mntov','ctov','akc')=1"
      else
        skpr=skpr+".and.getfield('t1','tov->mntov','ctov','akc')=prakcr"
      endif

    else
      if (gnVo=9)
        skpr=skpr+".and.getfield('t1','tov->mntov','ctov','akc')=0"
      endif

    endif

  else
    if (gnVo=9)
      skpr=skpr+".and.getfield('t1','tov->mntov','ctov','akc')=0"
    endif

  endif

  if (gnEnt=20.and.mk174r#0.and.(kopr=174.or.kopir=174))
    skpr=skpr+".and.iif(tov->kg>1,getfield('t1','tov->mntov','ctov','mkeep')=mk174r,.t.)"
  endif

  //   if gnEnt=21
  //      if gnRasc=1.and.(kopr=177.or.kopir=177) //      if kopr=177.or.kopir=177
  //         if prakcr=0
  //            skpr=skpr+".and.getfield('t1','tov->mntov','ctov','akc')=1"
  //         else
  //            skpr=skpr+".and.getfield('t1','tov->mntov','ctov','akc')=prakcr"
  //         endif
  //      else
  //         if gnVo=9
  //            skpr=skpr+".and.getfield('t1','tov->mntov','ctov','akc')=0"
  //         endif
  //      endif
  //   endif
  do case
  case (gnEnt=20.and.kopr=169)
    skpr=skpr+'.and.tov->kg#340'
  case (gnEnt=20.and.kopr=168)
    skpr=skpr+'.and.tov->kg=340'
  endcase

  if (gnEnt=21.and.gnArnd=3)
    kobolr=alltrim(getfield('t1', 'sktr', 'cskl', 'kobol'))
    lkobolr=len(kobolr)
    skpr=skpr+".and.subs('tov->kobol',1,lkobolr)=kobolr"
  endif

  if (fieldpos('bon')=0)
    if (gnRoz=1.and.gnVo=1)
      if (prTovr=0)
        ktlr=slcf('tov', 7, 1, 12,, "e:ktl h:'Код' c:n(9) e:nat h:'Наименование' c:c(32) e:upak_s() h:'Упк' c:c(4) e:nei h:'Изм' c:c(3) e:iif(otv()=0,' ','*') h:'O' c:c(1) e:iif(otv()=0,osv,osvo) h:'Ост.вып.' c:n(10,3) e:&coptr h:subs(ntcenr,1,10) c:n(9,3)", 'ktl', 1, 1, whileCond, skpr, 'gr+/b,n/w', 'Справочник склада по партиям')
      else
        ktlr=slcf('tov', 7, 1, 12,, "e:mntov h:'Тов' c:n(7) e:nat h:'Наименование' c:c(34) e:upak_s() h:'Упк' c:c(4) e:nei h:'Изм' c:c(3) e:iif(otv()=0,' ','*') h:'O' c:c(1) e:iif(otv()=0,osv,osvo) h:'Ост.вып.' c:n(10,3) e:&coptr h:subs(ntcenr,1,10) c:n(9,3)", 'ktl', 1, 1, whileCond, skpr, 'gr+/b,n/w', 'Справочник склада по партиям')
      endif

    else
      if (prTovr=0)
        ktlr=slcf('tov', 7, 1, 12,, "e:ktl h:'Код' c:n(9) e:nat h:'Наименование' c:c(32) e:upak_s() h:'Упк' c:c(4) e:nei h:'Изм' c:c(3) e:iif(otv()=0,' ','*') h:'O' c:c(1) e:iif(otv()=0,osv,osvo) h:'Ост.вып.' c:n(10,3) e:"+coptr+iif(ndsr=5, "*1.2", "")+" h:subs(ntcenr,1,10) c:n(9,3)", 'ktl', 1, 1, whileCond, skpr, 'gr+/b,n/w', 'Справочник склада по партиям')
      else
        ktlr=slcf('tov', 7, 1, 12,, "e:mntov h:'Тов' c:n(7) e:nat h:'Наименование' c:c(34) e:upak_s() h:'Упк' c:c(4) e:nei h:'Изм' c:c(3) e:iif(otv()=0,' ','*') h:'O' c:c(1) e:iif(otv()=0,osv,osvo) h:'Ост.вып.' c:n(10,3) e:"+coptr+iif(ndsr=5, "*1.2", "")+" h:subs(ntcenr,1,10) c:n(9,3)", 'ktl', 1, 1, whileCond, skpr, 'gr+/b,n/w', 'Справочник склада по партиям')
      endif

    endif

  else
    if (gnRoz=1.and.gnVo=1)
      if (prTovr=0)
        ktlr=slcf('tov', 7, 1, 12,, "e:ktl h:'Код' c:n(9) e:nat h:'Наименование' c:c(32) e:upak_s() h:'Упк' c:c(4) e:nei h:'Изм' c:c(3) e:iif(otv()=0,str(bon,1),'*') h:'O' c:c(1) e:iif(otv()=0,osv,osvo) h:'Ост.вып.' c:n(10,3) e:&coptr h:subs(ntcenr,1,10) c:n(9,3)", 'ktl', 1, 1, whileCond, skpr, 'gr+/b,n/w', 'Справочник склада по партиям')
      else
        ktlr=slcf('tov', 7, 1, 12,, "e:mntov h:'Тов' c:n(7) e:nat h:'Наименование' c:c(34) e:upak_s() h:'Упк' c:c(4) e:nei h:'Изм' c:c(3) e:iif(otv()=0,str(bon,1),'*') h:'O' c:c(1) e:iif(otv()=0,osv,osvo) h:'Ост.вып.' c:n(10,3) e:&coptr h:subs(ntcenr,1,10) c:n(9,3)", 'ktl', 1, 1, whileCond, skpr, 'gr+/b,n/w', 'Справочник склада по партиям')
      endif

    else
      if (prTovr=0)
        //               #ifdef __CLIP__
        //                  ktlr=slcf('tov',7,1,12,,"e:ktl h:'Код' c:n(9) e:nat h:'Наименование' c:c(32) e:upak_s() h:'Упк' c:c(4) e:nei h:'Изм' c:c(3) e:iif(otv()=0,str(bon,1),'*') h:'O' c:c(1) e:iif(otv()=0,osv,osvo) h:'Ост.вып.' c:n(10,3) e:"+coptr+iif(ndsr=5,"*1.2","")+" h:subs(ntcenr,1,10) c:n(9,3)",'ktl',1,1,whileCond,skpr,'gr+/b,n/w','Справочник склада по партиям')
        //               #else
        outlog(3, __FILE__, __LINE__, 'skpr', skpr)
        if (gnKt=0)
          if (gnAdm=0)
            ktlr=slce('tov', 7, 1, 12,, "e:ktl h:'Код' c:n(9) e:nat h:'Наименование' c:c(32) e:upak_s() h:'Упк' c:c(4) e:nei h:'Изм' c:c(3) e:iif(otv()=0,str(bon,1),'*') h:'O' c:c(1) e:iif(otv()=0,osv,osvo) h:'Ост.вып.' c:n(10,3) e:"+coptr+iif(ndsr=5, "*1.2", "")+" h:subs(ntcenr,1,10) c:n(9,3) e:rtovzen() h:'Цена+Ндс' c:n(9,3)", 'ktl', 1, 1, whileCond, skpr, 'gr+/b,n/w', 'Справочник склада по партиям')
          else
            skpr:=STUFF(ForTtnr, ;
                  AT('iif(otv=0,osv>0,osvo>0)', ForTtnr),;
                  len('iif(otv=0,osv>0,osvo>0)'), '.t.')
            ktlr=slce('tov', 7, 1, 12,, "e:ktl h:'Код' c:n(9) e:nat h:'Наименование' c:c(32) e:upak_s() h:'Упк' c:c(4) e:nei h:'Изм' c:c(3) e:iif(otv()=0,str(bon,1),'*') h:'O' c:c(1) e:iif(otv()=0,osv,osvo) h:'Ост.вып.' c:n(10,3) e:cenpr h:'Прайс' c:n(9,3) e:rtovzen() h:'Цена+Ндс' c:n(9,3)", 'ktl', 1, 1, whileCond, skpr, 'gr+/b,n/w', 'Справочник склада по партиям')
          endif

        else
          if (kopr=137)   // Продажа
            ktlr=slce('tov', 7, 1, 12,, "e:ktl h:'Код' c:n(9) e:nat h:'Наименование' c:c(32) e:upak_s() h:'Упк' c:c(4) e:nei h:'Изм' c:c(3) e:iif(otv()=0,osv,osvo) h:'Ост.вып.' c:n(10,3) e:cenkt h:'Цена' c:n(9,3)", 'ktl', 1, 1, whileCond, skpr, 'gr+/b,n/w', 'Справочник склада по партиям')
          else              // 136 Возврат
            ktlr=slce('tov', 7, 1, 12,, "e:ktl h:'Код' c:n(9) e:nat h:'Наименование' c:c(32) e:upak_s() h:'Упк' c:c(4) e:nei h:'Изм' c:c(3) e:iif(otv()=0,osv,osvo) h:'Ост.вып.' c:n(10,3) e:opt h:'Цена' c:n(9,3)", 'ktl', 1, 1, whileCond, skpr, 'gr+/b,n/w', 'Справочник склада по партиям')
          endif

        endif

        outlog(3, __FILE__, __LINE__, 'skpr', skpr)

      //               #endif
      else
        ktlr=slcf('tov', 7, 1, 12,, "e:mntov h:'Тов' c:n(7) e:nat h:'Наименование' c:c(34) e:upak_s() h:'Упк' c:c(4) e:nei h:'Изм' c:c(3) e:iif(opt#0,str(bon,1),'*') h:'O' c:c(1) e:iif(opt#0,osv,osvo) h:'Ост.вып.' c:n(10,3) e:"+coptr+iif(ndsr=5, "*1.2", "")+" h:subs(ntcenr,1,10) c:n(9,3)", 'ktl', 1, 1, whileCond, skpr, 'gr+/b,n/w', 'Справочник склада по партиям')
      endif

    endif

  endif

  sele tov
  netseek('t1', 'sklr,ktlr')
  izgrr=izgr
  mntovr=mntov
  mkeepr=mkeep
  if (gnCtov=1)
    mkeepr=getfield('t1', 'mntovr', 'ctov', 'mkeep')
  endif

  sele tov
  if (gnCtov=1.and.coptr#'opt'.and.&coptr=0)
    //      if gnEntrm=0
    cenr=getfield('t1', 'mntovr', 'ctov', coptr)
    //      else
    //         cenr=getfield('t1','sklr,mntovr','tovm',coptr)
    //      endif
    if (cenr#0.and.cenr#&coptr)
      netrepl(coptr, 'cenr')
    endif

  endif

  rcn_r=recn()
  exxr=0
  do case
  case (lastkey()=19)     // Left
    fldnomr=fldnomr-1
    if (fldnomr=0)
      fldnomr=1
    endif

  case (lastkey()=4)      // Right
    fldnomr=fldnomr+1
  case (lastkey()=K_F1)   // F1
    if (prF1r=0)
      prF1r=1
    else
      prF1r=0
    endif

  case (lastkey()=K_SPACE.and.(CheckGr350().and.chkmkkgp(mntovr, kgpr).and.empty(dfpr).or.gnVo#9))// Отбор
    cKop:=ALLTRIM(STR(kopr))
    cLsKop:=cKop
    if (kopr=129)
      prXXXr=getfield('t1', 'mkeepr', 'mkeep', 'pr'+cKop)//'pr129')
      if (prXXXr # 0 .and. BrandCodeList(cKop, cLsKop))
      //
      else                  //   if getfield('t1','mkeepr','mkeep','pr129')=0
        wmess('Не разрешено', 2)
        loop
      endif

      if (rs1->mk129=0)
        sele rs1
        netrepl('mk129', 'mkeepr', 1)
        @ 2, 76 say str(rs1->mk129, 3) color 'bg/n'
      else
        if (rs1->mk129#mkeepr)
          wmess('Не совпадает МД '+str(mkeepr, 3), 2)
          loop
        endif

      endif

    endif

    if (kopr=139)
      prXXXr=getfield('t1', 'mkeepr', 'mkeep', 'pr'+cKop)//'pr139')
      if (prXXXr # 0 .and. BrandCodeList(cKop, cLsKop))
      //
      else                  // getfield('t1','mkeepr','mkeep','pr139')=0
        wmess('Не разрешено', 2)
        loop
      endif

      if (rs1->mk139=0)
        sele rs1
        netrepl('mk139', 'mkeepr', 1)
        @ 2, 76 say str(rs1->mk139, 3) color 'bg/n'
      else
        if (rs1->mk139#mkeepr)
          wmess('Не совпадает МД '+str(mkeepr, 3), 2)
          loop
        endif

      endif

    endif

    sele tov
    if (gnVo#6.and.&coptr=0.and.int(ktlr/1000000)>1)
      wmess('Нулевая цена в прайсе', 2)
      loop
    endif

    if (gnVo=6.and.kopr=189.and.int(ktlr/1000000)>1)
      wmess('Только тара', 2)
      loop
    endif

    if (gnCtov=1)
      if (bsor#0.and.int(ktlr/1000000)>1)
        tgrpr=getfield('t1', 'int(ktlr/1000000)', 'cgrp', 'tgrp')
        if (tgrpr=0)
          wmess('БСО - Только АЛКОГОЛЬ!!!', 2)
          loop
        endif

      endif

      if (autor=4)
        if (kgnr>1)
          if (int(ktlr/1000000)#kgnr)
            wmess('Не та группа', 2)
            loop
          endif

        else
          ktl_rrr=getfield('t1', 'ttnr', 'rs2', 'ktl')
          kg_rrr=int(ktl_rrr/1000000)
          if (kg_rrr>1)
            wmess('Не та группа', 2)
            loop
          endif

        endif

      endif

    //              obncen(mntovr)
    endif

    rs2ins(0)
    pere(1)
  case (lastkey()=K_INS)  // Добавить
    if (gnD0k1=1)
      tovins(0, 'tov')
    endif

  case (lastkey()=K_F2)   // Тов/Код
    if (prTovr=0)
      prTovr=1
    else
      prTovr=0
    endif

  case (lastkey()=K_F3)   // фильтр по наименованию
    CreateFiltNamTov(@forNaT)
    whileCond:="kg_r=INT(ktl/1000000)"
    sele tov
    kg_r:=INT(INT(ktl/1000000))
    //найдем первую
    if (!netseek('t2', 'sklr,kg_r'))
      go rcn_r
    else
      rcn_r=recn()
    endif

  case (lastkey()=K_ALT_F3)// снять фильтр по наименованию
    forNaT:=".AND..T."
    whileCond:=nil
    @ MAXROW()-1, 0 say SPACE(MAXROW())
    rcn_r:=rcn_r_start
  case (lastkey()=K_F4)    // Коррекция
    if (gnD0k1=1)
      tovins(1, 'tov')
    else
      if (gnCtov=1)
      //                 obncen(mntovr)
      endif

      tovins(2, 'tov')
    endif

  case (lastkey()=K_F5)
    sele cskle
    if (netseek('t1', 'gnSk'))
      gnOt=slcf('cskle',,,,, "e:ot h:'От' c:n(2) e:nai h:'Наименование' c:c(20)", 'ot', 0,, 'sk=gnSk')
      if (netseek('t1', 'gnSk,gnOt'))
        gcNot=nai
        @ 1, 60 say gcNot color 'gr+/n'
      endif

    endif

    sele tov
    go top
    loop
  case (lastkey()=K_F8)   // Группа
    prf8r=0
    sele tov
    set orde to tag t2
    foot('', '')
    sele sgrp
    set orde to tag t2
    go top
    rcn_gr=recn()
    while (.t.)
      sele sgrp
      set orde to tag t2
      rcn_gr=recn()
      if (gnOt=0)
        forgr=".T..and.netseek('t2','sklr,sgrp->kgr','tov')"
      else
        forgr="ot=gnOt.and.netseek('t2','sklr,sgrp->kgr','tov')"
      endif

      forgr=forgr+forgkopr
      kg_r=slcf('sgrp',,,,, "e:kgr h:'Код' c:n(3) e:ngr h:'Наименование' c:c(20)", 'kgr',, 1,, forgr)
      do case
      case (lastkey()=K_ENTER)
        if (gnCtov=1)
          if (bsor#0.and.kg_r>1)
            tgrpr=getfield('t1', 'kg_r', 'cgrp', 'tgrp')
            if (tgrpr=0)
              wmess('БСО - Только АЛКОГОЛЬ!!!', 2)
              loop
            endif

          endif

        endif

        sele tov
        if (!netseek('t2', 'sklr,kg_r'))
          go rcn_r
        else
          rcn_r=recn()
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

    sele tov
    set orde to
    loop
  case (lastkey()=K_ALT_F7)// режим показа остатков
    forOtv:=!(forOtv)
  case (lastkey()=K_ALT_F8)// Маркодержатель
    prf8r=1
    sele tov
    set orde to tag t6
    foot('', '')
    sele mkeep
    go top
    rcmkeepr=recn()
    while (.t.)
      sele mkeep
      go rcmkeepr
      rcmkeepr=slcf('mkeep',,,,, "e:mkeep h:'Код' c:n(3) e:nmkeep h:'Наименование' c:c(20)",,, 1,, "mkeep#0.and.netseek('t6','sklr,mkeep->mkeep','tov')",, 'Маркодержатели')
      go rcmkeepr
      mkeepr=mkeep
      if (lastkey()=K_ESC)
        exit
      endif

      if (lastkey()=K_ENTER)
        sele tov
        if (!netseek('t6', 'sklr,mkeepr'))
          go rcn_r
        else
          rcn_r=recn()
        endif

        exit
      endif

    enddo

    sele tov
    loop
  case (lastkey()=K_F6)
    if (filterr=.t.)
      filterr=.f.
      ind='2'
      set order to tag t2
      go rcn_r
    else
      filterr=.t.
      ind='4'
      set order to tag t4
      seek str(izgrr, 7)
    endif

    loop
  case (lastkey()=K_ESC)  //
    exit
  case (lastkey()>32.and.lastkey()<255)
    //case lastkey()>=65.and.lastkey()<=90.or.lastkey()>=97.and.lastkey()<=122.or.lastkey()>=128.and.lastkey()<=175.or.lastkey()>=224.and.lastkey()<=239
    sele tov
    lstkr=upper(chr(lastkey()))
    if (!netseek('t2', 'sklr,int(ktlr/1000000),lstkr'))
      go rcn_r
    else
      rcn_r=recn()
    endif

  otherwise
    loop
  endcase

enddo

setcolor(oclr1)
rest scre from sctovslc

/***********************************************************
 * upak_s() -->
 *   Параметры :
 *   Возвращает:
 */
function upak_s()
  k1=int(upak/1)
  k2=1000*mod(upak, 1)
  if (k2#0)
    if (k1>=100)
      return (str(k1, 4))
    else
      if (k1>=10)
        return (str(k1, 2)+'.'+str(ROUND(k2/100, 0), 1))
      else
        return (str(k1, 1)+'.'+str(ROUND(k2/10, 0), 2))
      endif

    endif

  else
    if (gnSkotv=0)        // gnOtv
      return (str(k1, 4))
    else
      return (str(upakp, 4))
    endif

  endif

  return (.t.)

/***********************************************************
 * upak_sp() -->
 *   Параметры :
 *   Возвращает:
 */
function upak_sp()
  k1=int(upakp/1)
  k2=1000*mod(upakp, 1)
  if (k2#0)
    if (k1>=100)
      return (str(k1, 4))
    else
      if (k1>=10)
        return (str(k1, 2)+'.'+str(ROUND(k2/100, 0), 1))
      else
        return (str(k1, 1)+'.'+str(ROUND(k2/10, 0), 2))
      endif

    endif

  else
    return (str(k1, 4))
  endif

  return (.t.)

/***********************************************************
 * skpr() -->
 *   Параметры :
 *   Возвращает:
 */
static function skpr()
  sele sgrp
  if (fieldpos('lic')=0)
    sele tov
    skp1r=skpr
    return (skp1r)
  endif

  licr=getfield('t1', 'int(tov->ktl/1000000)', 'sgrp', 'lic')
  if (licr#0)
    sele klnlic
    if (netseek('t1', 'kplr'))
      skp1r='.f.'
      while (kkl=kplr)
        if (lic#licr)
          skip
          loop
        endif

        if (gdTd>=dnl.and.gdTd<=dol)
          skp1r=skpr
        else
          skip
          loop
        endif

        skip
      enddo

    else
      skp1r='.f.'
    endif

  else
    skp1r=skpr
  endif

  sele tov
  return (skp1r)

/***********************************************************
 * CheckGr350() -->
 *   Параметры :
 *   Возвращает:
 */
function CheckGr350()
  local nRecNo
  local lAddRec:=.T.
  if (.f.)
    nRecNo:=rs2->(RECNO())
    if (rs2->(netseek("t1", "ttnr")))
      if (int(ktlr/10^6)=290.or.int(ktlr/10^6)=460.or.int(ktlr/10^6)=280)
        if (rs2->(int(ktl/10^6))=290.or.rs2->(int(ktl/10^6))=460.or.rs2->(int(ktl/10^6))=280)
          lAddRec:=.T.
        else
          lAddRec:=.F.
        endif

      elseif (!(int(ktlr/10^6)=290.or.int(ktlr/10^6)=460.or.int(ktlr/10^6)=280))
        if (!(rs2->(int(ktl/10^6))=290.or.rs2->(int(ktl/10^6))=460.or.rs2->(int(ktl/10^6))=280))
          lAddRec:=.T.
        else
          lAddRec:=.F.
        endif

      endif

    else
      lAddRec:=.T.
    endif

    if (!lAddRec)
      if (int(ktlr/10^6)=290.or.int(ktlr/10^6)=460.or.int(ktlr/10^6)=280)
        wmess("КРУПЫ,Макароны,Муку в другую накладную")
      else
        wmess("Только КРУПЫ,Макароны,Мука")
      endif

    endif

    rs2->(DBGOTO(nRecNo))
  endif

  return (lAddRec)

/***********************************************************
 * CheckGr351() -->
 *   Параметры :
 *   Возвращает:
 */
function CheckGr351()
  local nRecNo
  local lAddRec:=.T.

  nRecNo:=rs2->(RECNO())
  if (rs2->(netseek("t1", "ttnr")))

    if (int(ktlr/10^6)=350.or.int(ktlr/10^6)=351)//табак
      if (rs2->(int(ktl/10^6))=350.or.rs2->(int(ktl/10^6))=351)
        lAddRec:=.T.
      else
        lAddRec:=.F.
      endif

    elseif (int(ktlr/10^6)#350.and.int(ktlr/10^6)#351)
      if (rs2->(int(ktl/10^6))#350.and.rs2->(int(ktl/10^6))#351)
        lAddRec:=.T.
      else
        lAddRec:=.F.
      endif

    endif

  else
    lAddRec:=.T.
  endif

  if (!lAddRec)
    if (int(ktlr/10^6)=350.or.int(ktlr/10^6)=351)
      wmess("Группу ТАБАК вводите в другую накладную")
    else
      wmess("В этой накладной только группа ТАБАК")
    endif

  endif

  rs2->(DBGOTO(nRecNo))
  return (lAddRec)

/***********************************************************
 * rtovzen() -->
 *   Параметры :
 *   Возвращает:
 */
function rtovzen()
  local zen_rr
  if (gnCtov=1)
    viptcenr=getfield('t1', 'rs1->nkkl,tov->izg,int(tov->ktl/1000000)', 'klnnac', 'tcen')
    if (viptcenr=0)
      viptcenr=getfield('t1', 'rs1->nkkl,tov->izg,999', 'klnnac', 'tcen')
    endif

    if (viptcenr#0)
      czen_rr=alltrim(getfield('t1', 'viptcenr', 'tcen', 'zen'))
      zen_rr=getfield('t1', 'tov->mntov', 'ctov', czen_rr)
    else
      zen_rr=getfield('t1', 'tov->mntov', 'ctov', 'cenpr')
    endif

  else
    zen_rr=cenpr
  endif

  if (ndsr=5)
    zen_rr=zen_rr*1.2
  endif

  return (zen_rr)

/*****************************************************************
 
 FUNCTION:
 АВТОР..ДАТА..........С. Литовка  04-23-18 * 12:48:33pm
 НАЗНАЧЕНИЕ.........
 ПАРАМЕТРЫ..........
 ВОЗВР. ЗНАЧЕНИЕ....
 ПРИМЕЧАНИЯ.........
 */
function otv()
  return (Iif(forOtv, _field->otv, 0))
