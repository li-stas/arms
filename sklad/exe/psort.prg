/***********************************************************
 * Модуль    : psort.prg
 * Версия    : 0.0
 * Автор     :
 * Дата      : 03/28/18
 * Изменен   :
 * Примечание: Текст обработан утилитой CF версии 2.02
 */

#include "common.ch"
#include "inkey.ch"
/*  Пересортица -OSV
  nTypePrz  (prz_r=0.and.aqstr=2) - не подвержденные
            (prz_r=1.and.aqstr=3) - подвержденные
             aqstr=4 - все
  */
param nSkl, nMnTov, nTypePrz

if (Empty(nMnTov))
  if (gnEntRm=0.and.gnSkOtv#0)
    wmess(str(gnSkOtv, 3))
    return (.t.)
  endif

  if (gnEntRm=0)
    if (gnRm#0 .and. gnAdm # 1)
      return
    endif

  else
    if (gnRm#1)
      return
    endif

  endif

  if (!netuse('soper',, 'e'))
    wmess('Склад занят,просмотр', 1)
    aqstr=1
  endif

  clea
  netuse('tcen')
  clea
  aqstr=0
  if (aqstr=0)
    aqst:={ "Просмотр", "Корр.!подтв.", "Корр.подтв." }
    aqstr:=alert(" ", aqst)
    if (lastkey()=K_ESC)
      nuse()
      return
    endif

  endif

  set prin to psort.txt
  set prin on
  if (aqstr#1)
    ?'Индексация TOV'
    netind('tov')
  endif

  netuse('tov')
  if (aqstr#1)
    ?'Индексация RS1'
    netind('rs1')
  endif

  netuse('rs1')
  if (aqstr#1)
    ?'Индексация RS2'
    netind('rs2')
  endif

  netuse('rs2')
  set orde to tag t6

  if (gnCtov=1)
    if (aqstr#1)
      ?'Индексация RS2M'
      netind('rs2m')
    endif

    netuse('rs2m')
    set orde to tag t3
  endif

else                        // МнТов не указан
  DEFAULT nTypePrz to 4
  aqstr := nTypePrz         //все
  netuse('soper')
  netuse('tcen')
  netuse('rs1')
  netuse('rs2')
  netuse('rs2m')

  sele rs2
  set orde to tag t6
  sele rs2m
  set orde to tag t3

  sele tov
  cOrdSet:=OrdSetFocus()
  nRec:=RECNO()
endif

sele tov
set orde to
nMax:=LASTREC(); Termo((nCurent:=0), nMax, MaxRow(), 4)

go top
while (!eof())
  if (!Empty(nMnTov))
    if (!(nSkl = tov->skl .and. nMnTov = tov->MnTov))
      sele tov
      skip
      Termo((++nCurent), nMax, MaxRow(), 4)
      loop
    endif

  endif

  if (osv >= 0)
    sele tov
    skip
    Termo((++nCurent), nMax, MaxRow(), 4)
    loop
  endif

  if (otv # 0)            // остаток ответ хранения
    sele tov
    skip
    Termo((++nCurent), nMax, MaxRow(), 4)
    loop
  endif

  ?str(skl, 7)+' '+str(mntov, 7)+' '+str(ktl, 9)+' '+subs(nat, 1, 30)+' '+str(osv, 10, 3)

  if (aqstr=1)
    skip
    Termo((++nCurent), nMax, MaxRow(), 4)
    loop
  endif

  sklr=skl
  ktlr=ktl                  // Старый ktl
  mntovr=mntov
  optr=opt
  dppr=dpp
  kolr=abs(osv)
  outlog(__FILE__,__LINE__,ktl,mntov,'ktl,mntov // Текущий отрицательный остаток')

  rctovr=recn()
  set orde to tag t5
  if (netseek('t5', 'sklr,mntovr'))
    while (skl=sklr.and.mntov=mntovr)
      if (otv # 0)
        skip;     loop
      endif
      outlog(__FILE__,__LINE__,'  ',ktl,'ktl не ОТВ.ХР')

      if (fieldpos('bon')#0)
        if (bon # 0)
          skip;          loop
        endif

      endif
      outlog(__FILE__,__LINE__,'  ',ktl,'ktl 4 bon=0')

      if (osv <= 0)
        skip;        loop
      endif
      outlog(__FILE__,__LINE__,'  ',ktl,'ktl osv>0')

      if (osv-kolr >= 0)
        kolir=kolr
      else
        kolir=osv
      endif
      outlog(__FILE__,__LINE__,'  ',kolir,osv,kolr,'kolir,osv,kolr')

      kolrr=kolir           // Необходимо для коррекции
                            // kolrr     // Текущее количество для коррекции
      KtlNr=ktl             // Новый ktl
      optnr=opt

      CorRs2(nMnTov)
      outlog(__FILE__,__LINE__,'  ','сделали CorRs2(nMnTov)')

      sele tov
      osvr:=osv-kolir+kolrr
      kolr:=kolr-kolir+kolrr
      outlog(__FILE__,__LINE__,'  ',osvr,kolr,'osvr,kolr')

      netrepl('osv', { osvr })
      if (kolr = 0)
        exit
      endif

      skip
    enddo

  endif

  sele tov
  set orde to
  go rctovr
  if (kolr = 0)
    netrepl('osv', { 0 })
  endif

  skip
  Termo((++nCurent), nMax, MaxRow(), 4)
enddo

Termo(nMax, nMax, MaxRow(), 4)

if (Empty(nMnTov))
  nuse()
else
  netuse('soper')
  nuse('tcen')
  nuse('rs1')
  nuse('rs2')
  nuse('rs2m')
  sele tov
  OrdSetFocus(cOrdSet)
  go nRec
endif

set prin off
set prin to

wmess('Выполните Сервис/ "Остатки тек",/"Корр.док",/"Корр. RS2M"', 0)

/***********************************************************
 * corrs2() -->
 *   Параметры :
 *   Возвращает:
 */
static function CorRs2(nMnTov)
  sele rs2
  if (netseek('t6', 'ktlr'))// старый ktlr
    while (ktl=ktlr)
      skip
      rcRs2r=recn()
      skip -1
      ttnr=ttn
      mntovr=mntov
      pptr=ppt
      mntovpr=mntovp
      sele rs1
      if (netseek('t1', 'ttnr'))
        prz_r=prz
        vo_r=vo
        kop_r=kop
        kopi_r=kopi
        q_r=mod(kop_r, 100)
        dvp_r=dvp
        dfp_r=dfp               // фин конт для 139
        skl_r=skl
        tcen_r=getfield('t1', '0,1,vo_r,q_r', 'soper', 'tcen')
        ctcen_r=getfield('t1', 'tcen_r', 'tcen', 'zen')
        ctcen_r=alltrim(ctcen_r)
      endif

      sele rs2

      if (skl_r#sklr)
        sele rs2
        skip
        loop
      endif

      if (int(mntovr/10^4) # 507)
        dpp_r=getfield('t1', 'skl_r,KtlNr', 'tov', 'dpp')
        if (!empty(dpp_r).and.!empty(dvp_r))
          if (empty(nMnTov))
            if (dvp_r < dpp_r)
              sele rs2
              skip
              loop
            endif

          endif

        endif

      endif

      if .F. // (kop_r = 177)
        //     .or. kop_r = 139 .and. empty(dfp_r)
        //  списание
        // датаФанКон пустая или (дата отгрузки и дата подверждения пустые)
        sele rs2
        skip
        loop
      endif

      if (vo_r = 6)
        outlog(__FILE__,__LINE__,'vo_r=6 -> skip ')
        sele rs2
        skip
        loop
      else
        if (kopi_r#0.and.kopi_r=kop_r.and.ctcen_r='opt')
          //            if optr#optnr
          //               sele rs2
          //               skip
          //               loop
        //            endif
        endif

      endif

      if (!((prz_r=0.and.aqstr=2) .or. (prz_r=1.and.aqstr=3) .or. aqstr=4))
        sele rs2
        skip
        loop
      endif

      if (kolrr-kvp>=0)
        kolrr=kolrr-kvp
        netrepl('ktl', { KtlNr })
        if (ktlp=ktlr)
          netrepl('ktlp', { KtlNr })
        endif

        if (ktlm=ktlr)
          netrepl('ktlm', { KtlNr })
        endif

        if (ktlmp=ktlr)
          netrepl('ktlmp', { KtlNr })
        endif

        ?str(ttnr, 6)+' '+str(kop_r, 3)+' '+str(ktl, 9)+' перекод '+str(kvp, 10, 3)
        if (optr#optnr)
          ??' С '+str(optr, 10, 3)+' Н '+str(optnr, 10, 3)
          if (aqstr=2)
            srr=roun(optr*kvp, 2)
            netrepl('sr', { srr })
          endif

        endif

      else
        netrepl('kvp', { kvp-kolrr })
        if (kf#0)
          netrepl('kf', { kvp })
        endif

        svpr=roun(kvp*zen, 2)
        netrepl('svp', { svpr })
        if (rs1->prz=1)
          netrepl('sf', { svpr })
        endif

        if (fieldpos('bsvp')#0)
          bsvpr=roun(kvp*bzen, 2)
          xsvpr=roun(kvp*xzen, 2)
          netrepl('bsvp,xsvp', { bsvpr, xsvpr })
        endif

        ?str(ttnr, 6)+' '+str(kop_r, 3)+' '+str(ktl, 9)+' уменьш. '+str(kolrr, 10, 3)
        arec:={}
        getrec()
        netadd()
        putrec()
        netrepl('ktl,kvp', { KtlNr, kolrr })
        if (kf#0)
          netrepl('kf', { kvp })
        endif

        if (ktlp=ktlr)
          netrepl('ktlp', { KtlNr })
        endif

        if (ktlm=ktlr)
          netrepl('ktlm', { KtlNr })
        endif

        if (ktlmp=ktlr)
          netrepl('ktlmp', { KtlNr })
        endif

        netrepl('svp', { roun(kvp*zen, 2) })
        if (rs1->prz=1)
          netrepl('sf', { svp })
        endif

        if (fieldpos('bsvp')#0)
          bsvpr=roun(kvp*bzen, 2)
          xsvpr=roun(kvp*xzen, 2)
          netrepl('bsvp,xsvp', { bsvpr, xsvpr })
        endif

        if (gnCtov=1)
          sele rs2m
          if (netseek('t3', 'ttnr,mntovpr,pptr,mntovr'))
            netrepl('otv', { otv+1 })
          endif

        endif

        sele rs2
        ?str(ttnr, 6)+' '+str(kop_r, 3)+' '+str(ktl, 9)+' добавл '+str(kolrr, 10, 3)
        if (optr#optnr)
          sr_r=sr
          srr=roun(kvp*optnr, 2)
          netrepl('sr', { srr })
          if (gnCtov=1)
            sele rs2m
            if (netseek('t3', 'ttnr,mntovpr,pptr,mntovr'))
              netrepl('sr', { sr-sr_r+srr })
            endif

          endif

          ??' С '+str(optr, 10, 3)+' Н '+str(optnr, 10, 3)
        endif

        kolrr=0
      endif

      if (kolrr=0)
        exit
      endif

      sele rs2
      go rcrs2r
    //      skip
    enddo

  endif

RETURN (NIL)

/***********************************************************
 * autodoc1() -->
 *   Параметры :
 *   Возвращает:
 */
function autodoc1()
  clea
  // aqstr=1
  // aqst:={"Просмотр","Коррекция"}
  // aqstr:=alert(" ",aqst)
  // if lastkey()=K_ESC
  //   return
  // endif
  set prin to autodoc.txt
  set prin on
  netuse('cskl')
  netuse('pr1')
  netuse('pr2')
  set orde to tag t3
  netuse('rs1')
  netuse('rs2')
  set orde to tag t3
  ?'Приход'
  sele pr1
  while (!eof())
    if (prz=0)
      skip
      loop
    endif

    if (otv#0)
      skip
      loop
    endif

    if (vo#6)
      skip
      loop
    endif

    if (kop#188)
      skip
      loop
    endif

    if (sks=0)
      skip
      loop
    endif

    if (amn=0)
      skip
      loop
    endif

    ndr=nd
    mnr=mn
    sksr=sks
    amnr=amn
    sklr=skl
    path_r=getfield('t1', 'sksr', 'cskl', 'path')
    sk_r=getfield('t1', 'sksr', 'cskl', 'sk')
    pathr=gcPath_d+alltrim(path_r)
    if (!netfile('tov', 1))
      ?'Нет склада '+str(sksr, 3)
      sele pr1
      skip
      loop
    endif

    netuse('rs1', 'rs1s',, 1)
    if (!netseek('t1', 'amnr'))
      ?'PR ND '+str(ndr, 6)+' PR MN '+str(mnr, 6)+' '+'Нет расхода TTN '+str(amnr, 6)
      nuse('rs1s')
      sele pr1
      skip
      loop
    endif

    ttnr=ttn
    amn_r=amn
    if (sksr#sk_r)
      ?'PR SK '+str(sksr, 3)+' PR ND '+str(ndr, 6)+' RS SK '+str(sk_r, 3)+' RS TTN '+str(ttnr, 6)+'  sk#sk'
      nuse('rs1s')
      sele pr1
      skip
      loop
    endif

    if (amn_r#mnr)
      ?'PR ND '+str(ndr, 6)+' PR MN '+str(mnr, 6)+' PR AMN '+str(amnr, 6)+' RS ANM '+str(amn_r, 6)+' mn#amn'
      nuse('rs1s')
      sele pr1
      skip
      loop
    endif

    //   ?str(gnSk,3)+' '+str(ndr,6)+' '+str(mnr,6)
    netuse('rs2', 'rs2s',, 1)
    set orde to tag t3
    sele pr2
    if (netseek('t3', 'mnr'))
      while (mn=mnr)
        ktlr=ktl
        pptr=ppt
        ktlpr=ktlp
        kfr=kf
        zenr=zen
        sele rs2s
        if (netseek('t3', 'amnr,ktlpr,pptr,ktlr'))
          if (kfr#kvp)
            ?str(sk_r, 3)+' '+str(ttnr, 6)+' '+str(amnr, 6)+' '+str(ktlpr, 9)+' '+str(pptr, 1)+' '+str(ktlr, 9)+' pr '+str(kfr, 10, 3)+' rs '+str(kvp, 10, 3)
          endif

          if (zenr#zen)
            ?str(sk_r, 3)+' '+str(ttnr, 6)+' '+str(amnr, 6)+' '+str(ktlpr, 9)+' '+str(pptr, 1)+' '+str(ktlr, 9)+' pr '+str(zenr, 10, 3)+' rs '+str(zen, 10, 3)
          endif

        else
          ?str(sk_r, 3)+' '+str(ttnr, 6)+' '+str(amnr, 6)+' '+str(ktlpr, 9)+' '+str(pptr, 1)+' '+str(ktlr, 9)+' нет'
        endif

        sele pr2
        skip
      enddo

    endif

    nuse('rs1s')
    nuse('rs2s')
    sele pr1
    skip
  enddo

  ?'Расход'
  sele rs1
  while (!eof())
    if (prz=0)
      skip
      loop
    endif

    if (vo#6)
      skip
      loop
    endif

    if (kop#188)
      skip
      loop
    endif

    if (skt=0)
      skip
      loop
    endif

    if (amn=0)
      skip
      loop
    endif

    ttnr=ttn
    sktr=skt
    amnr=amn
    sklr=skl
    path_r=getfield('t1', 'sktr', 'cskl', 'path')
    sk_r=getfield('t1', 'sktr', 'cskl', 'sk')
    pathr=gcPath_d+alltrim(path_r)
    if (!netfile('tov', 1))
      ?'Нет склада '+str(sktr, 3)
      sele rs1
      skip
      loop
    endif

    netuse('pr1', 'pr1t',, 1)
    if (!netseek('t2', 'amnr'))
      ?'Нет прихода MN '+str(amnr, 6)
      nuse('pr1t')
      sele rs1
      skip
      loop
    endif

    ndr=nd
    mnr=mn
    amn_r=amn
    if (sktr#sk_r)
      ?'RS SK '+str(sktr, 3)+' RS TTN '+str(ttnr, 6)+' PR SK '+str(sk_r, 3)+' PR ND '+str(ndr, 6)
      nuse('pr1t')
      sele rs1
      skip
      loop
    endif

    if (amn_r#ttnr)
      ?'RS TTN '+str(ttnr, 6)+' RS AMN '+str(amnr, 6)+' PR ANM '+str(amn_r, 6)
      nuse('pr1t')
      sele rs1
      skip
      loop
    endif

    //   ?str(gnSk,3)+' '+str(ttnr,6)
    netuse('pr2', 'pr2t',, 1)
    set orde to tag t3
    sele rs2
    if (netseek('t3', 'ttnr'))
      while (ttn=ttnr)
        ktlr=ktl
        pptr=ppt
        ktlpr=ktlp
        kvpr=kvp
        zenr=zen
        sele pr2t
        if (netseek('t3', 'amnr,ktlpr,pptr,ktlr'))
          if (kvpr#kf)
            ?str(sk_r, 3)+' '+str(ndr, 6)+' '+str(amnr, 6)+' '+str(ktlpr, 9)+' '+str(pptr, 1)+' '+str(ktlr, 9)+' rs '+str(kvpr, 10, 3)+' pr '+str(kf, 10, 3)
          endif

          if (zenr#zen)
            ?str(sk_r, 3)+' '+str(ndr, 6)+' '+str(amnr, 6)+' '+str(ktlpr, 9)+' '+str(pptr, 1)+' '+str(ktlr, 9)+' rs '+str(zenr, 10, 3)+' pr '+str(zen, 10, 3)
          endif

        else
          ?str(sk_r, 3)+' '+str(ndr, 6)+' '+str(amnr, 6)+' '+str(ktlpr, 9)+' '+str(pptr, 1)+' '+str(ktlr, 9)+' нет'
        endif

        sele rs2
        skip
      enddo

    endif

    nuse('pr1t')
    nuse('pr2t')
    sele rs1
    skip
  enddo

  nuse()
  set prin off
  set prin to txt.txt
  wmess('Проверка закончена', 0)
  return (.t.)
