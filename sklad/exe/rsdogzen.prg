/***********************************************************
 * Модуль    : rsdogZen.prg
 * Версия    : 0.0
 * Автор     :
 * Дата      : 11/26/20
 * Изменен   :
 * Примечание: Текст обработан утилитой CF версии 2.02
 */

#include "common.ch"
#include "inkey.ch"
// RsDogZen()
// gprZenr,gprBZenr,gprXZenr   - max % на группу
// iprZenr,iprBZenr,iprXZenr   - max % на изготовителя
// tprZenr,tprBZenr,tprXZenr   -     % на товар
// SmSBZenr           - сумма скидки по 2-й цене
// SmBZenr            - сумма по 2-й цене
// SmSXZenr           - сумма скидки по 3-й цене
// SmXZenr            - сумма по 3-й цене
aPcenr=0
if (przr=0)
  if (gnAdm=1.or.gnCenr=1)
    aPcen={'Прайс2', 'Документ2', 'Прайс3', 'Документ3'}
    If gnAdm=1
      aPcen={'Прайс2', 'Документ2', 'Прайс3', 'Документ3', "На сумму Ц1"}
    EndIf
    aPcenr=alert('Пересчитать цены?', aPcen)
    if (lastkey()=K_ESC)
      return
    endif

    if (aPcenr=1.or.aPcenr=2.or.aPcenr=5)
      prDecr=2
    else
      prDecr=0
    endif

  else                      // prDecr из документа
    do case
    case (prDecr=1.or.prDecr=2)
      aPcenr=2
    case (prDecr=0)
      aPcenr=4
    endcase

    if (prDecr=1)
      aPcenr=2
    else
      aPcenr=4
    endif

  endif

endif

if (select('psgr')#0)
  sele psgr
  CLOSE
endif

Create_pSGr()

if (prdp())
  sele rs3
  if (netseek('t1', 'ttnr,49'))
    netdel()
  endif

  if (kplr=20034)
    tarar=0
  else
    ssf12r=getfield('t1', 'ttnr,12', 'rs3', 'ssf')
    if (ssf12r#0)
      tarar=0
    else
      tarar=1
    endif

  endif

  if (aPcenr#0)
    if (aPcenr=1.or.aPcenr=3.or.aPcenr=5)
      // p1=1 текущие прайсовые цены ,договорные скидки
      // p1=2 прайсовые цены по документу,скидки по документу
      rs2pZen(1)
    else
      rs2pZen(2)
    endif

  endif

  if (przr=0)
    rso(21) // протокол "дог цены"
  endif

endif

while (.t.)
  /* ============= заполнение таблицы скидок  ================= */
  sele psgr
  zap
  sele rs2
  set orde to tag t1
  netseek('t1','ttnr')
  do while ttn=ttnr
    ktlr=ktl
    kgrr=int(ktlr/1000000)
    if kgrr<=1
      skip
      loop
    endif
    prZenr=pZen
    prZenPr=prZenP
    SmZenr=roun(kvp*Zen,2)
    if (ndsr=2.or.ndsr=3.or.ndsr=5)
      SmZenPr=roun(kvp*ZenP,2)
    else
      SmZenPr=roun(kvp*ZenP*(1+gnNds/100),2)
    endif

    if BZen=0
      BZenr=Zenr
      prBZenr=prZenr
      BZenPr=ZenPr
      prBZenPr=prZenPr
      netrepl('BZen,pBZen,BZenP,prBZenP','BZenr,prBZenr,BZenPr,prBZenPr')
    endif

    if XZen=0
      XZenr=getfield('t1','sklr,ktlr','tov','opt')
      XZenPr=XZenr
      if int(ktlr/1000000)=350
        prXZenr=0 //gnPret
        prXZenPr=0 //prXZenr
      else
        if int(ktlr/1000000)>1
            prXZenr=0 //gnPre
            prXZenPr=0 //prXZenr
        else
            prXZenr=0
            prXZenPr=0
        endif
      endif
      if (ndsr=2.or.ndsr=3.or.ndsr=5)
        XZenr=ROUND(XZenPr*(prXZenr+100)/100,2)
      else
        XZenr=ROUND(XZenPr*(1+gnNds/100)*(prXZenr+100)/100,2)
      endif
      sele rs2
      netrepl('XZen,pXZen,XZenP,prXZenP','XZenr,prXZenr,XZenPr,prXZenPr')
    endif

    prBZenr=pBZen
    prBZenPr=prBZenP
    SmBZenr=roun(kvp*BZen,2)
    if (ndsr=2.or.ndsr=3.or.ndsr=5)
      SmBZenPr=roun(kvp*BZenP,2)
    else
      SmBZenPr=roun(kvp*BZenP*(1+gnNds/100),2)
    endif

    prXZenr=pXZen
    prXZenPr=prXZenP
    SmXZenr=roun(kvp*XZen,2)
    if (ndsr=2.or.ndsr=3.or.ndsr=5)
      SmXZenPr=roun(kvp*XZenP,2)
    else
      SmXZenPr=roun(kvp*XZenP*(1+gnNds/100),2)
    endif

    prUZenr=10
    prUZenPr=10
    SmUZenr=roun(kvp*XZen * ((prUZenr+100)/100), 2)
    if (ndsr=2.or.ndsr=3.or.ndsr=5)
      SmUZenPr=roun(kvp*XZenP*((prUZenr+100)/100),2)
    else
      SmUZenPr=roun(kvp*XZenP*((prUZenr+100)/100)*(1+gnNds/100) ,2)
    endif



    ngrr=getfield('t1','kgrr','sgrp','ngr')

    sele psgr
    seek str(kgrr,3)
    if !FOUND()
        appe blank
        repl kg with kgrr,ng with ngrr,;
        ;//
        pXZen with prXZenr,prXZenP with prXZenPr,;
        SmXZen with SmXZenr,;
        SmXZenP with SmXZenPr,;
        ;//
        pUZen with prUZenr,prUZenP with prUZenPr,;
        SmUZen with SmUZenr,;
        SmUZenP with SmUZenPr,;
        SmSUZen with SmUZenr-SmZenr,; // разница между Сумм Опт+10 и Сумм Ц.Дог1
        ;//
        pZen with prZenr,prZenP with prZenPr,;
        SmZen with SmZenr,;
        SmZenP with SmZenPr,;
        SmSZen with SmZenr-SmZenPr,;
        ;//
        pBZen with prBZenr,prBZenP with prBZenPr,;
        SmBZen with SmBZenr,;
        SmBZenP with SmBZenPr,;
        SmSBZen with SmBZenr-SmBZenPr
    else
        if abs(prZenr)>abs(pZen)
          repl pZen with prZenr
        endif
        if abs(prBZenr)>abs(pBZen)
          repl pBZen with prBZenr
        endif
        repl ;
            SmXZen with SmXZen+SmXZenr,;
            SmXZenP with SmXZenP+SmXZenPr,;
            ;//
            SmUZen with SmUZen+SmUZenr,;
            SmUZenP with SmUZenP+SmUZenPr,;
            SmSUZen with SmSUZen+(SmUZenr-SmZenr),;// разница между Сумм Опт+10 и Сумм Ц.Дог1
            ;//
            SmZen with SmZen+SmZenr,;
            SmZenP with SmZenP+SmZenPr,;
            SmSZen with SmSZen+SmZenr-SmZenPr,;
            ;//
            SmBZen with SmBZen+SmBZenr,;
            SmBZenP with SmBZenP+SmBZenPr,;
            SmSBZen with SmSBZen+SmBZenr-SmBZenPr
    endif
    sele rs2
    skip
  enddo
  /* =================================== */


  // сумма скидки если Опр+10 и ценуПрайсаСкидки
  sele psgr
  sum SmSUZen to nSmSUZen for !(str(int(kg/1000000),3) $ '340;350')

  sele psgr
  go top
  sele psgr
  foot('F4,ENTER', 'Коррекция,Изготовитель'+" "+allt(str(nSmSUZen,10,2)))
  do case
  case (pBZenr=0)         //.and.pXZenr=0
    rckgrr=slcf('psgr', 8,,,, "e:kg h:'КОД' c:n(3) e:ng h:'Наименов. группы' c:с(20) e:pZen h:'% цены' c:n(6,2) e:prZenP h:'% дог.ц' c:n(6,2)",,, 1,,,, 'НА ГРУППУ')
  case (pBZenr=1)         //.and.pXZenr=0
    rckgrr=slcf('psgr', 8,,,, "e:kg h:'КОД' c:n(3) e:ng h:'Наименов. группы' c:с(20) e:pZen h:'% 1 цены' c:n(6,2) e:prZenP h:'% 1 дог.ц' c:n(6,2) e:pBZen h:'% 2 цены' c:n(6,2) e:prBZenP h:'% 2 дог.ц' c:n(6,2)",,, 1,,,, 'НА ГРУППУ')
  endcase

  if (lastkey()=K_ESC)
    exit
  endif

  sele psgr
  go rckgrr
  kgrr=kg
  gprZenr=pZen
  gprZenPr=prZenP
  gSmZenr=SmZen
  gSmZenPr=SmZenP
  gSmSZenr=SmSZen           // Сумма1 скидки суммой
  gprBZenr=pBZen
  gprBZenPr=prBZenP
  gSmBZenr=SmBZen
  gSmBZenPr=SmBZenP
  gSmSBZenr=SmSBZen         // Сумма2 скидки суммой
  do case
  case (lastkey()=K_F4.and.przr=0)

    clttnr=setcolor('gr+/b,n/bg')
    wttnr=wopen(10, 14, 15, 60)
    wbox(1)
    @ 0, 1 say '%  изменения 1-й цены  ' get gprZenr pict '999.99'//VALID GETACTIVE():varGet()>=gprZenPr
    @ 0, col()+1 say str(gSmSZenr, 10, 2)
    if (pBZenr=1)
      if (gnCenr=0)
        @ 1, 1 say '%  изменения 2-й цены  ' get gprBZenr pict '999.99'//VALID GETACTIVE():varGet()>=gprBZenPr
      else
        @ 1, 1 say '%  изменения 2-й цены  ' get gprBZenr pict '999.99'// VALID GETACTIVE():varGet()>=gprBZenPr
      endif

      @ 1, col()+1 say str(gSmSBZenr, 10, 2)
    endif

    read
    if (pBZenr=1.and.gprBZenr=0)
      @ 1, 32 get gSmSBZenr pict '9999999.99' VALID prBZen(1)
      read
    endif

    wclose(wttnr)
    setcolor(clttnr)
    if (lastkey()=K_ESC.or.!prdp())
      loop
    endif

    Repl_ZenRs2()

  case (lastkey()=K_ENTER)
    while (.t.)
      sele pizg
      zap
      sele rs2
      netseek('t1', 'ttnr')
      while (ttn=ttnr)
        if (int(ktl/1000000)=kgrr)
          izgr=izg
          nizgr=getfield('t1', 'izgr', 'kln', 'nkl')
          prZenr=pZen
          prZenPr=prZenP
          SmZenr=round(kvp*Zen, 2)
          if (ndsr=2.or.ndsr=3.or.ndsr=5)
            SmZenPr=round(kvp*ZenP, 2)
          else
            SmZenPr=round(kvp*ZenP*(1+gnNds/100), 2)
          endif

          prBZenr=pBZen
          prBZenPr=prBZenP
          SmBZenr=round(kvp*BZen, 2)
          if (ndsr=2.or.ndsr=3.or.ndsr=5)
            SmBZenPr=round(kvp*BZenP, 2)
          else
            SmBZenPr=round(kvp*BZenP*(1+gnNds/100), 2)
          endif

          sele pizg
          seek str(izgr, 7)
          if (!FOUND())
            appe blank
            repl izg with izgr, nizg with nizgr,                                                                                  ;
             pZen with prZenr, prZenP with prZenPr, SmZen with SmZenr, SmZenP with SmZenPr, SmSZen with SmZenr-SmZenPr,           ;
             pBZen with prBZenr, prBZenP with prBZenPr, SmBZen with SmBZenr, SmBZenP with SmBZenPr, SmSBZen with SmBZenr-SmBZenPr
          else
            if (abs(prZenr)>abs(pZen))
              repl pZen with prZenr
            endif

            if (abs(prBZenr)>abs(pBZen))
              repl pBZen with prBZenr
            endif

            repl SmZen with SmZen+SmZenr, SmZenP with SmZenP+SmZenPr, SmSZen with SmSZen+SmZenr-SmZenPr,      ;
             SmBZen with SmBZen+SmBZenr, SmBZenP with SmBZenP+SmBZenPr, SmSBZen with SmSBZen+SmBZenr-SmBZenPr
          endif

        endif

        sele rs2
        skip
      enddo

      foot('F4', 'Коррекция')
      sele pizg
      go top
      do case
      case (pBZenr=0)     //.and.pXZenr=0
        rcizgr=slcf('pizg', 10,, 8,, "e:izg h:'КОД' c:n(7) e:nizg h:'Наименов. изгот.' c:с(20) e:pZen h:'% цены' c:n(6,2) e:prZenP h:'% дог.ц' c:n(6,2)",,,,,,,, 'НА ИЗГОТОВИТЕЛЯ')
      case (pBZenr=1)     //.and.pXZenr=0
        rcizgr=slcf('pizg', 10,, 8,, "e:izg h:'КОД' c:n(7) e:nizg h:'Наименов. изгот.' c:с(20) e:pZen h:'% 1 цены' c:n(6,2) e:prZenP h:'% 1 дог.ц' c:n(6,2) e:pBZen h:'% 2 цены' c:n(6,2) e:prBZenP h:'% 2 дог.ц' c:n(6,2)",,,,,,, 'НА ИЗГОТОВИТЕЛЯ')
      endcase

      if (lastkey()=K_ESC)
        exit
      endif

      sele pizg
      go rcizgr
      izgr=izg
      iprZenr=pZen
      iprZenPr=prZenP
      iSmZenr=SmZen
      iSmZenPr=SmZenP
      iSmSZenr=SmSZen       // Сумма1 скидки суммой
      iprBZenr=pBZen
      iprBZenPr=prBZenP
      iSmBZenr=SmBZen
      iSmBZenPr=SmBZenP
      iSmSBZenr=SmSBZen     // Сумма2 скидки суммой
      do case
      case (lastkey()=K_F4.and.przr=0)
        clttnr=setcolor('gr+/b,n/bg')
        wttnr=wopen(10, 14, 15, 60)
        wbox(1)
        @ 0, 1 say '%  изменения 1-й цены  ' get iprZenr pict '999.99' VALID GETACTIVE():varGet()>=iprZenPr
        @ 0, col()+1 say str(iSmSZenr, 10, 2)
        if (pBZenr=1)
          @ 1, 1 say '%  изменения 2-й цены  ' get iprBZenr pict '999.99' VALID GETACTIVE():varGet()>=iprBZenPr
          @ 1, col()+1 say str(iSmSBZenr, 10, 2)
        endif

        read
        if (pBZenr=1.and.iprBZenr=0)
          @ 1, 32 get iSmSBZenr pict '9999999.99' VALID prBZen(2)
          read
        endif

        wclose(wttnr)
        setcolor(clttnr)
        if (lastkey()=K_ESC.or.!prdp())
          loop
        endif

        Repl_ZenIzgRs2()

      endcase

    enddo

  endcase

enddo

if (select('psgr')#0)
  sele psgr
  CLOSE
endif


//erase psgr.dbf
//erase psgr.cdx

if (select('pizg')#0)
  sele pizg
  CLOSE
endif

//erase pizg.dbf
//erase pizg.cdx

sele rs2
set order to tag t3

/********************* */
// Функции
/********************* */

function prBZen(p1)
  if (p1=1)               // На группу
    sele psgr
    ngprBZenr=((gSmSBZenr+gSmBZenPr)/gSmBZenPr-1)*100
    if (ngprBZenr<gprBZenPr)
      wmess('Низзя!!!', 1)
      return (.f.)
    endif

    gprBZenr=ngprBZenr
    netrepl('pBZen', 'gprBZenr')
  else                      // На изготовителя
    sele pizg
    niprBZenr=((iSmSBZenr+iSmBZenPr)/iSmBZenPr-1)*100
    if (niprBZenr<iprBZenPr)
      wmess('Низзя!!!', 1)
      return (.f.)
    endif

    iprBZenr=niprBZenr
    netrepl('pBZen', 'iprBZenr')
  endif

  return (.t.)

/***************** */
function prXZen(p1)
  /***************** */
  if (p1=1)               // На группу
    sele psgr
    gprXZenr=((gSmSXZenr+gSmXZenPr)/gSmXZenPr-1)*100
    netrepl('pXZen', 'gprXZenr')
  else                      // На изготовителя
    sele pizg
    iprXZenr=((iSmSXZenr+iSmXZenPr)/iSmXZenPr-1)*100
    netrepl('pXZen', 'iprXZenr')
  endif

  return (.t.)

/******************************************************* */
function rs2prc(p1)
  // p1=1 текущие прайсовые цены ,договорные скидки
  // p1=2 прайсовые цены по документу,скидки по документу
  /******************************************************* */
  if (gnKt=1)
    return (.t.)
  endif

  pckopr=0
  store 0 to pctcenr, pcptcenr, pcxtcenr, pcnofr, pcpBZenr, pcpXZenr
  store '' to pccoptr, pccBOptr, pccxoptr
  sele rs2
  set orde to tag t1
  if (netseek('t1', 'ttnr'))
    while (ttn=ttnr)
      ktlr=ktl
      ktlpr=ktlp
      pptr=ppt
      mntovr=mntov
      kvpr=kvp
      KolAkcr=getfield('t1', 'mntovr', 'ctov', 'KolAkc')
      if (KolAkcr#0)
        if (kvpr>=KolAkcr)
          sele rs2
          skip
          loop
        endif

      endif

      if (fieldpos('mntovp')#0)
        mntovpr=mntovp
      endif

      if (mntovpr=0)
        if (ktlr=ktlpr)
          mntovpr=mntovr
        else
          mntovpr=getfield('t1', 'sklr,ktlpr', 'tov', 'mntov')
        endif

      endif

      if (ktlr=1)
        netdel()
        skip
        loop
      endif

      kvpr=kvp
      svp_r=svp
      if (fieldpos('bsvp')#0)
        bsvp_r=bsvp
        xsvp_r=xsvp
      else
        bsvp_r=0
        xsvp_r=0
      endif

      sr_r=sr
      if (kvpr=0)
        netdel()
        skip
        loop
      endif

      Zenr=Zen
      prZenr=pZen
      ZenPr=ZenP
      prZenPr=prZenP
      BZenr=BZen
      prBZenPr=prBZenP
      prBZenr=pBZen
      BZenPr=BZenP
      XZenr=XZen
      prXZenr=pXZen
      XZenPr=XZenP
      prXZenPr=prXZenP
      if (fieldpos('MZen')#0)
        MZenr=MZen
      else
        MZenr=0
      endif

      if (fieldpos('tcenp')#0)
        rcenpr=tcenp
      else
        rtcenpr=0
      endif

      sele tov
      if (netseek('t1', 'sklr,ktlr'))
        if (p1=1)
          Zen()
        else
          Zen(1)
        endif

        sele tov
        optr=opt
        MZenr=c24

        sele rs2
        srr=round(optr*kvp, 2)
        svpr=round(Zenr*kvp, 2)
        bsvpr=round(BZenr*kvp, 2)
        xsvpr=round(XZenr*kvp, 2)
        netrepl('svp,sr,Zen,pZen,BZen,pBZen,ZenP,prZenP,BZenP,prBZenP,XZen,pXZen,XZenP,prXZenP',                 ;
                 'svpr,srr,Zenr,prZenr,BZenr,prBZenr,ZenPr,prZenPr,BZenPr,prBZenPr,XZenr,prXZenr,XZenPr,prXZenPr' ;
              )
        if (fieldpos('bsvp')#0)
          netrepl('bsvp,xsvp', 'bsvpr,xsvpr')
        endif

        if (fieldpos('tcenp')#0)
          netrepl('tcenp', 'rtcenpr')
        endif

        if (fieldpos('MZen')#0)
          if (round(MZen, 3)#round(MZenr, 3))
            netrepl('MZen', 'MZenr')
          endif

        endif

        if (fieldpos('mntovp')#0)
          mntovpr=mntovp
        endif

        if (mntovpr=0)
          if (ktlr=ktlpr)
            mntovpr=mntovr
          else
            mntovpr=getfield('t1', 'sklr,ktlpr', 'tov', 'mntov')
          endif

        endif

        if (gnCtov=1)
          sele rs2m
          if (netseek('t3', 'ttnr,mntovpr,pptr,mntovr'))
            netrepl('svp,sr,ZenP,prZenP,BZenP,prBZenP,XZenP,prXZenP',                          ;
                     'svp-svp_r+svpr,sr-sr_r+srr,ZenPr,prZenPr,BZenPr,prBZenPr,XZenPr,prXZenPr' ;
                  )
            if (fieldpos('bsvp')#0)
              netrepl('bsvp,xsvp', 'bsvp-bsvp_r+bsvpr,xsvp-xsvp_r+xsvpr')
            endif

            if (fieldpos('MZen')#0)
              if (round(MZen, 3)#round(MZenr, 3))
                netrepl('MZen', 'MZenr')
              endif

            endif

            Zenmr=Zenr
            prZenmr=prZenr
            BZenmr=BZenr
            prBZenmr=prBZenr
            XZenmr=XZenr
            prXZenmr=prXZenr
            if (otv>1)
              if (ndsr=2.or.ndsr=3.or.ndsr=5)
                Zenmr=ROUND(svp/kvp, 2)
              else
                Zenmr=ROUND(svp/kvp, 2)
              endif

              prZenmr=round((Zenmr/ZenPr-1)*100, 2)
              if (fieldpos('bsvp')#0)
                if (pndsr=2.or.pndsr=3.or.pndsr=5)
                  BZenmr=ROUND(bsvp/kvp, 2)
                else
                  BZenmr=ROUND(bsvp/kvp, 2)
                endif

                if (xndsr=2.or.xndsr=3.or.xndsr=5)
                  XZenmr=ROUND(xsvp/kvp, 2)
                else
                  XZenmr=ROUND(xsvp/kvp, 2)
                endif

                prBZenmr=round((BZenmr/BZenPr-1)*100, 2)
                prXZenmr=round((XZenmr/XZenPr-1)*100, 2)
              endif

            endif

            netrepl('Zen,pZen,BZen,pBZen,XZen,pXZen',               ;
                     'Zenmr,prZenmr,BZenmr,prBZenmr,XZenmr,prXZenmr' ;
                  )
          endif

        endif

      endif

      sele rs2
      skip
    enddo

  endif

  sele rs1
  if (fieldpos('prDec')#0)
    netrepl('prDec', 'prDecr')
  endif

  if (p1=1.and.aPcenr#3)
    sele rs1
    if (kopi#177)
      netrepl('kopi', 'kopr', 1)
    endif

  endif

  if (p1=1)
    if (gnScOut=0)
      @ 2, 14 say str(rs1->kop, 3)+'('+str(rs1->kopi, 3)+')'+' '+nopr
    endif

    if (kopir#177)
      kopir=kopr
    endif

    nds_fr=ndsr
    pnds_fr=pndsr
    xnds_fr=xndsr
    kop_fr=kopr
    nKkl_fr=nKkl
    if (fieldpos('prDec')#0)
      prDec_fr=prDec
    else
      prDec_fr=0
    endif

    nof_fr=nofr
  endif

  return (.t.)

/*****************************************************************
 
 FUNCTION:
 АВТОР..ДАТА..........С. Литовка  11-26-20 * 04:00:26pm
 НАЗНАЧЕНИЕ.........
 ПАРАМЕТРЫ..........
  // p1 0 - по текущему прайсу; 1 - коррекция по прайсу документа
  // p2 - ktl
  // p3 - mntov
 ВОЗВР. ЗНАЧЕНИЕ....
 ПРИМЕЧАНИЯ.........
 */
function Zen(p1, p2, p3)  // Цены
  local ktl_rr, mntov_rr

  if (!empty(p2))
    ktl_rr=ktlr
    ktlr=p2
  endif

  if (!empty(p3))
    mntov_rr=mntovr
    mntovr=p3
  endif

  store 0 to rcmntovr, rcmntovtr
  if (gnCtov#1)
    sele tov
    mntovtr=0
  else
    sele ctov
    if (!netseek('t1', 'mntovr'))
      wmess('Не найден в CTOV', 3)
      quit
    else
      mntovtr=mntovt
      rcmntovr=recn()
      if (mntovtr=0)
        mntovtr=mntovr
        rcmntovtr=rcmntovr
      else
        if (!netseek('t1', 'mntovtr'))
          mntovtr=mntovr
          rcmntovtr=rcmntovr
        else
          rcmntovtr=recn()
        endif

      endif

      go rcmntovr
    endif

  endif

  izgr=izg
  mkeepr=mkeep
  brandr=brand
  kgr_r=int(mntovr/10000)

  if (fieldpos('blksk')#0)
    blkskr=blksk
  else
    blkskr=0
  endif

  if (gnVo=9.and.kopir#177)
    sele klnnac
    if (fieldpos('tcen')=0)
      viptcenr=0
    else
      viptcenr=getfield('t1', 'nkklr,izgr,kgr_r', 'klnnac', 'tcen')
      if (viptcenr=0)
        viptcenr=getfield('t1', 'nkklr,izgr,999', 'klnnac', 'tcen')
      endif

    endif

    if (viptcenr=0)
      kgptcenr=0
      kgpnacr=0
      kgpnac1r=0
      sele kgptm
      if (netseek('t1', 'kpvr,mkeepr'))
        kgptcenr=tcen
        kgpnacr=nac
        kgpnac1r=nac
      endif

      if (kgptcenr=0)
        knaspr=getfield('t1', 'kpvr', 'kln', 'knasp')
        kgpcatr=getfield('t1', 'kpvr', 'kgp', 'kgpcat')
        if (knaspr#0)
          sele nasptm
          if (kgpcatr#0)
            if (netseek('t2', 'knaspr,kgpcatr,mkeepr'))
              kgptcenr=tcen
              kgpnacr=nac
              kgpnac1r=nac
            endif

          endif

          if (kgptcenr=0)
            if (netseek('t2', 'knaspr,0,mkeepr'))
              kgptcenr=tcen
              kgpnacr=nac
              kgpnac1r=nac
            endif

          endif

        endif

      endif

      if (kgptcenr=0)
        krnr=getfield('t1', 'kpvr', 'kln', 'krn')
        kgpcatr=getfield('t1', 'kpvr', 'kgp', 'kgpcat')
        if (krnr#0)
          sele rntm
          if (kgpcatr#0)
            if (netseek('t2', 'krnr,kgpcatr,mkeepr'))
              kgptcenr=tcen
              kgpnacr=nac
              kgpnac1r=nac
            endif

          endif

          if (kgptcenr=0)
            sele krntm
            if (netseek('t1', 'krnr,mkeepr'))
              kgptcenr=tcen
              kgpnacr=nac
              kgpnac1r=nac
            endif

          endif

        endif

      endif

      if (kgptcenr#0)
        viptcenr=kgptcenr
      endif

    endif

  else
    viptcenr=0
  endif

  if (gnCtov=1)
    sele ctov
  else
    sele tov
  endif

  if (viptcenr#0)
    cvipoptr=alltrim(getfield('t1', 'viptcenr', 'tcen', 'Zen'))
    if (gnEnt=21)
      vipZenr=getfield('t1', 'mntovtr', 'ctov', cvipoptr)
      cenprr=getfield('t1', 'mntovtr', 'ctov', 'cenpr')
    else
      vipZenr=&cvipoptr     //cvipZenr
      cenprr=cenpr
    endif

    rtcenpr=viptcenr
  else
    rtcenpr=tcenr
  endif

  if (empty(p1).or.nKklr#nKkl_fr.and.corsh=1.or.prDecr#prDec_fr)
    if (aPcenr#3)
      if (kopr=191)
        if (viptcenr=0)
          Zenr =round(cenprr*(1+gnNds/100), 2)
        else
          Zenr =round(vipZenr*(1+gnNds/100), 2)
        endif

        ZenPr =cenprr
      else
        if (viptcenr=0)
          if (coptr#'opt')
            if (gnEnt=21)
              Zenr=getfield('t1', 'mntovtr', 'ctov', coptr)
            else
              Zenr =&coptr
            endif

          else
            Zenr =tov->&coptr
          endif

          ZenPr =Zenr
        else
          if (cvipoptr#'opt')
            if (gnEnt=21)
              Zenr=getfield('t1', 'mntovtr', 'ctov', cvipoptr)
            else
              Zenr =&cvipoptr
            endif

          else
            Zenr =tov->&cvipoptr
          endif

          ZenPr =Zenr
        endif

      endif

      if (nofr=1)
        BZenr =Zenr
        BZenPr=ZenPr
        if (int(ktlr/1000000)>1)
          XZenr=tov->opt
          XZenPr=XZenr
        else
          if (Zenr=0)
            XZenr=Zenr
            XZenPr=ZenPr
          else
            XZenr=tov->opt
            XZenPr=XZenr
          endif

        endif

      else
        if (pBZenr=1)
          if (cBOptr#'opt')
            if (gnEnt=21)
              BZenr=getfield('t1', 'mntovtr', 'ctov', cBOptr)
            else
              BZenr =&cBOptr
            endif

          else
            BZenr =tov->&cBOptr
          endif

          BZenPr=BZenr
        else
          BZenr=Zenr
          BZenPr=ZenPr
        endif

        if (pXZenr=1)
          if (cxoptr#'opt')
            if (gnEnt=21)
              XZenr=getfield('t1', 'mntovtr', 'ctov', cxoptr)
            else
              XZenr=&cxoptr
            endif

          else
            XZenr=tov->&cxoptr
          endif

          XZenPr=XZenr
        else
          XZenr=tov->opt
          XZenPr=XZenr
        endif

      endif

    else                    // Выбор прайса
      if (pckopr=191)
        if (vipZenr=0)
          Zenr =round(cenprr*(1+gnNds/100), 2)
        else
          Zenr =round(vipZenr*(1+gnNds/100), 2)
        endif

        ZenPr =cenpr
      else
        if (vipZenr=0)
          if (pccoptr#'opt')
            if (gnEnt=21)
              Zenr = getfield('t1', 'mntovtr', 'ctov', pccoptr)
            else
              Zenr = &pccoptr
            endif

          else
            Zenr = tov->&pccoptr
          endif

        else
          if (cvipoptr#'opt')
            if (gnEnt=21)
              Zenr=getfield('t1', 'mntovtr', 'ctov', cvipoptr)
            else
              Zenr =&cvipoptr
            endif

          else
            Zenr =tov->&cvipoptr
          endif

        endif

        ZenPr =Zenr
      endif

      if (pcnofr=1)
        BZenr = Zenr
        BZenPr = ZenPr
        if (int(ktlr/1000000)>1)
          XZenr=tov->opt
          XZenPr=XZenr
        else
          if (Zenr=0)
            XZenr=Zenr
            XZenPr=ZenPr
          else
            XZenr=tov->opt
            XZenPr=XZenr
          endif

        endif

      else
        if (pcpBZenr=1)
          if (gnEnt=21)
            BZenr = getfield('t1', 'mntovtr', 'ctov', pccBOptr)
          else
            BZenr = &pccBOptr
          endif

          BZenPr=BZenr
        else
          BZenr=Zenr
          BZenPr=ZenPr
        endif

        if (pcpXZenr=1)
          if (gnEnt=21)
            XZenr=getfield('t1', 'mntovtr', 'ctov', pccxoptr)
          else
            XZenr=&pccxoptr
          endif

          XZenPr=XZenr
        else
          XZenr=tov->opt
          XZenPr=XZenr
        endif

      endif

    endif

  else
    // Из документа
    if (nofr=1)
      BZenPr=ZenPr
      if (int(ktlr/1000000)>1)
        XZenPr=tov->opt
      else
        XZenPr=ZenPr
      endif

    endif

  endif

  // Договорные скидки
  store 0 to nprZenPr, nprBZenPr, nprXZenPr, MinZen1r
  kgrr=int(ktlr/1000000)
  if (doguslr=1.and.kopir#177.and.(blkskr=0.or.blkskr=1.and.viptcenr#0))
    if (brandr#0)
      if (kgrr>1)
        if (select('mnnac')#0)
          sele mnnac
          if (netseek('t1', 'nkklr,brandr,mntovr'))
            nprZenPr=nac
            nprBZenPr=Nac1
            MinZen1r=MinZen1
          endif

        endif

        if (nprZenPr=0)
          store 0 to nprZenPr, nprBZenPr, nprXZenPr, MinZen1r
          sele brnac
          if (netseek('t1', 'nkklr,mkeepr,brandr'))
            nprZenPr=nac
            nprBZenPr=Nac1
            MinZen1r=MinZen1
          endif

        endif

      endif

    endif

    if (nprZenPr=0)
      store 0 to nprZenPr, nprBZenPr, nprXZenPr, MinZen1r
      if (kgrr>1)
        sele klnnac
        if (!netseek('t1', 'nKklr'))
          sele mkeepe
          if (netseek('t2', 'izgr') .AND. !DELETED())//ДА!!!!!!!!!!!!
            nprZenPr=0
            nprBZenPr=0
            MinZen1r=0
          else              //нет - по  //общий процент
            sele kpl
            if (netseek('t1', 'nKKLr'))
              nprZenPr=nac
              nprBZenPr=nac1
              MinZen1r=0
            endif

          endif

        else
          sele mkeepe
          if (NetSeek('t2', 'izgr').AND. !DELETED())//ДА!!!!!!!!!!!!
            sele klnnac
            if (!NetSeek('t1', 'nKklr,izgr'))//нет такого изготовителя
              nprZenPr=0
              nprBZenPr=0
              MinZen1r=0
              viptcenr=0
            else            //изготовитель такой есть!!!
              sele klnnac
              if (!NetSeek("T1", "nKklr, Izgr, 999"))
                //                     wmess('Проблемы с таблицей Условий, должна быть группа 999', 3)
                nprZenPr=0
                nprBZenPr=0
                MinZen1r=0
              else
                nprZenPr=nac
                nprBZenPr=nac1
                MinZen1r=MinZen1
              endif

              if (nprZenPr=0)
                if (netseek("T1", "nKklr, Izgr, kgrr"))
                  nprZenPr=nac
                endif

              endif

              if (nprBZenPr=0)
                if (netseek("T1", "nKklr, Izgr, kgrr"))
                  nprBZenPr=nac1
                  MinZen1r=MinZen1
                endif

              endif

            endif

          else              // не маркодержатель в klnnac
            sele kpl
            if (netseek('t1', 'nKKLr'))
              nprZenPr=nac
              nprBZenPr=nac1
              MinZen1r=0
            endif

          endif

        endif

      endif                 // kgrr>1

    endif                   // nprZenPr=0(brand)

  endif

  // Если есть наценка по грузополучателю
  if (gnVo=9.and.kopir#177.and.kgrr>1.and.blkskr=0)
    if (viptcenr=0)
      if (nprZenPr=0)
        nprZenPr=kgpnacr
      endif

      if (nprBZenPr=0)
        nprBZenPr=kgpnac1r
      endif

    endif

  endif

  /****************************************************** */
  // Условия автоматического пересчета цен
  /****************************************************** */
  if (empty(p1).or.nKklr#nKkl_fr.and.corsh=1.and.kopir#177.and.blkskr=0.or.prDecr#prDec_fr)
    if (gnVo=9.or.gnVo=2)
      prZenr=nprZenPr
      prZenPr=nprZenPr
    else
      if (kopr=186)       // Комиссия
        prZenr=1
        prZenPr=1
      else
        prZenr=0
        prZenPr=0
      endif

    endif

    if (gnVo=9.or.gnVo=2)
      prBZenr=nprBZenPr
      prBZenPr=nprBZenPr
    else
      prBZenr=0             //nprBZenPr
      prBZenPr=0            //nprBZenPr
    endif

    if (gnVo=9.or.gnVo=2)
      if (nofr=1.or.pXZenr=0)
        if (int(ktlr/1000000)=350)
          prXZenr=0         //gnPret
          prXZenPr=0        //gnPret
        else
          if (int(ktlr/1000000)>1)
            prXZenr=0       //gnPre
            prXZenPr=0      //gnPre
          else
            prXZenr=0
            prXZenPr=0
          endif

        endif

      else
        prXZenr=nprXZenPr
        prXZenPr=nprXZenPr
      endif

    else
      prXZenr=0
      prXZenPr=0
    endif

  endif

  /******************************************************** */

  // Расчет новых цен
  if (nofr=1)
    if (ndsr=2.or.ndsr=3.or.ndsr=5)
      Zenr=ROUND(ZenPr*(prZenr+100)/100, 2)
      BZenr=ROUND(BZenPr*(prBZenr+100)/100, 2)
      XZenr=ROUND(XZenPr*(prXZenr+100)/100, 2)
    else
      Zenr=ROUND(ZenPr*(1+gnNds/100)*(prZenr+100)/100, 2)
      BZenr=ROUND(BZenPr*(1+gnNds/100)*(prBZenr+100)/100, 2)
      XZenr=ROUND(XZenPr*(1+gnNds/100)*(prXZenr+100)/100, 2)
      if (Zenr=0.and.int(ktlr/1000000)>1)
        Zenr=0.01
      endif

      if (BZenr=0.and.int(ktlr/1000000)>1)
        BZenr=0.01
      endif

      if (XZenr=0.and.int(ktlr/1000000)>1)
        XZenr=0.01
      endif

    endif

  else
    if (ndsr=2.or.ndsr=3.or.ndsr=5)
      Zenr=ROUND(ZenPr*(prZenr+100)/100, 2)
    else
      if (kopr=191)
        Zenr=ROUND(ZenPr*(1+gnNds/100)*(prZenr+100)/100, 2)
      else
        Zenr=ROUND(ZenPr*(prZenr+100)/100, 2)
      endif

      if (Zenr=0.and.int(ktlr/1000000)>1)
        Zenr=0.01
      endif

    endif

    //   if pBZenr=1
    if (pndsr=2.or.pndsr=3.or.pndsr=5)
      BZenr=ROUND(BZenPr*(prBZenr+100)/100, 2)
    else
      if (kopr=191)
        BZenr=ROUND(BZenPr*(1+gnNds/100)*(prBZenr+100)/100, 2)
      else
        BZenr=ROUND(BZenPr*(prBZenr+100)/100, 2)
      endif

    endif

    if (BZenr=0.and.int(ktlr/1000000)>1)
      BZenr=0.01
    endif

    //   endif
    //   if pXZenr=1
    if (xndsr=2.or.xndsr=3.or.xndsr=5)
      XZenr=ROUND(XZenPr*(prXZenr+100)/100, 2)
    else
      if (kopr=191)
        XZenr=ROUND(XZenPr*(1+gnNds/100)*(prXZenr+100)/100, 2)
      else
        XZenr=ROUND(XZenPr*(prXZenr+100)/100, 2)
      endif

    endif

    if (XZenr=0.and.int(ktlr/1000000)>1)
      XZenr=0.01
    endif

  //   endif
  endif

  // Проверка 1-й цены на минимальную и входную
  if (gnCtov=1)
    sele ctov
  else
    sele tov
  endif

  if (empty(p1).or.nKklr#nKkl_fr.and.corsh=1.or.prDecr#prDec_fr)
    MZenr=c24
  else
    if (MZenr=0)
      MZenr=c24
    endif

  endif

  optr=tov->opt
  if (fieldpos('noopt')#0)
    nooptr=noopt
  else
    nooptr=0
  endif

  MZen_rr=MZenr
  opt_rr=optr

  //нормализируем цену минимальную
  if (!(ndsr=5.or.ndsr=3.or.ndsr=2))
    MZenr=round(MZenr*(1+gnNds/100), 2)
  endif

  //нормализируем цену закупочную
  if (!(ndsr=5.or.ndsr=3.or.ndsr=2))
    optr:=round(optr*(1+gnNds/100), 2)
  endif

  // sele kln
  // if netseek('t1','nKKLr')
  //   ChkNZenr=ChkNZen
  // else
  //   ChkNZenr=.f.
  // endif

  prMZenr=getfield('t1', 'nkklr', 'kpl', 'prMZen')

  if (gnEnt=20)
    if (empty(p1).or.nKklr#nKkl_fr.and.corsh=1.or.prDecr#prDec_fr).and.int(ktlr/1000000)>1
      if (gnVo=9.or.gnVo=2)
        if (IIF(prMZenr=0, EMPTY(MZenr), .T.))
          //            IF Zenr<optr.and.(gnEnt#20.or.gnEnt=20.and.!(mkeepr=92.or.mkeepr=25.or.mkeepr=85)) //меньше получилось
          if (Zenr<optr)  //меньше получилось
            if (nooptr=0)
              Zenr:=optr
            endif

          endif

        else
          //            IF Zenr<MZenr.and.(gnEnt#20.or.gnEnt=20.and.!(mkeepr=92.or.mkeepr=25.or.mkeepr=85))  //меньше получилось
          if (Zenr<MZenr) //меньше получилось
            if (nooptr=0)
              Zenr:=MZenr
            endif

          endif

        endif

        //         if MZenr#0.and.MinZen1r=0.and.nofr=1.and.(gnEnt#20.or.gnEnt=20.and.!(mkeepr=92.or.mkeepr=25.or.mkeepr=85))
        if (MZenr#0.and.MinZen1r=0.and.nofr=1)
          if (BZenr<MZenr)
            if (nooptr=0)
              BZenr=MZenr
            endif

          endif

        endif

        //         if MinZen1r=1.and.nofr=1.and.(gnEnt#20.or.gnEnt=20.and.!(mkeepr=92.or.mkeepr=25.or.mkeepr=85))
        if (MinZen1r=1.and.nofr=1)
          if (BZenr<optr)
            BZenr=optr
          endif

        endif

      else
        //         IF Zenr<optr.and.(gnEnt#20.or.gnEnt=20.and.!(mkeepr=92.or.mkeepr=25.or.mkeepr=85))
        if (Zenr<optr)
          if (nooptr=0)
            Zenr:=optr
          endif

        endif

        //         IF BZenr<optr.and.nofr=1.and.(gnEnt#20.or.gnEnt=20.and.!(mkeepr=92.or.mkeepr=25.or.mkeepr=85))
        if (BZenr<optr.and.nofr=1)
          if (nooptr=0)
            BZenr:=optr
          endif

        endif

      endif

    endif

  else
    if (empty(p1).or.nKklr#nKkl_fr.and.corsh=1.or.prDecr#prDec_fr).and.int(ktlr/1000000)>1
      if (gnVo=9.or.gnVo=2)
        if (IIF(prMZenr=1, EMPTY(MZenr), .T.))
          //            IF Zenr<optr.and.(gnEnt#20.or.gnEnt=20.and.!(mkeepr=92.or.mkeepr=25.or.mkeepr=85)) //меньше получилось
          if (Zenr<optr)  //меньше получилось
            if (nooptr=0)
              Zenr:=optr
            endif

          endif

        else
          //            IF Zenr<MZenr.and.(gnEnt#20.or.gnEnt=20.and.!(mkeepr=92.or.mkeepr=25.or.mkeepr=85))  //меньше получилось
          if (Zenr<MZenr) //меньше получилось
            if (nooptr=0)
              Zenr:=MZenr
            endif

          endif

        endif

        //         if MZenr#0.and.MinZen1r=0.and.nofr=1.and.(gnEnt#20.or.gnEnt=20.and.!(mkeepr=92.or.mkeepr=25.or.mkeepr=85))
        if (MZenr#0.and.MinZen1r=0.and.nofr=1)
          if (BZenr<MZenr)
            if (nooptr=0)
              BZenr=MZenr
            endif

          endif

        endif

        //         if MinZen1r=1.and.nofr=1.and.(gnEnt#20.or.gnEnt=20.and.!(mkeepr=92.or.mkeepr=25.or.mkeepr=85))
        if (MinZen1r=1.and.nofr=1)
          if (BZenr<optr)
            if (nooptr=0)
              BZenr=optr
            endif

          endif

        endif

      else
        //         IF Zenr<optr.and.(gnEnt#20.or.gnEnt=20.and.!(mkeepr=92.or.mkeepr=25.or.mkeepr=85))
        if (Zenr<optr)
          if (nooptr=0)
            Zenr:=optr
          endif

        endif

        //         IF BZenr<optr.and.nofr=1.and.(gnEnt#20.or.gnEnt=20.and.!(mkeepr=92.or.mkeepr=25.or.mkeepr=85))
        if (BZenr<optr.and.nofr=1)
          if (nooptr=0)
            BZenr:=optr
          endif

        endif

      endif

    endif

  endif

  // Проверка на индикатив
  // Индикатив(без НДС)
  if (gnVo=9.or.gnVo=2)
    sele tov
    vespr=vesp
    keipr=keip
    if (gnCtov=1)
      sele cgrp
      if (netseek('t1', 'int(ktlr/1000000)').and.vespr#0.and.keipr#0)
        grkeir=grkei
      else
        grkeir=0
      endif

      if (grkeir=keipr.and.grkeir#0)
        indloptr=indlopt
        indlrozr=indlroz
        indloptr=ROUND(indloptr*vespr, 3)
        indlrozr=ROUND(indlrozr*vespr, 3)
      else
        indloptr=0
        indlrozr=0
      endif

    else
      indloptr=0
      indlrozr=0
    endif

    if (kopr=191)         // Розница
      if (indlrozr#0)
        if (Zenr<round(indlrozr*(1+gnNds/100), 2))
          Zenr=round(indlrozr*(1+gnNds/100), 2)
        endif

        if (nofr=1)
          if (BZenr<round(indlrozr*(1+gnNds/100), 2))
            BZenr=round(indlrozr*(1+gnNds/100), 2)
          endif

          if (XZenr<round(indlrozr*(1+gnNds/100), 2))
            XZenr=round(indlrozr*(1+gnNds/100), 2)
          endif

        endif

      endif

    else                    // Опт
      if (indloptr#0)
        if (Zenr<indloptr)
          Zenr=indloptr
        endif

        if (nofr=1)
          if (BZenr<indloptr)
            BZenr=indloptr
          endif

          if (XZenr<indloptr)
            XZenr=indloptr
          endif

        endif

      endif

    endif

    // Проверка 2-й цены на 1-ю

    if (BZenr>Zenr.and.nofr=1)
      BZenr=Zenr
      prBZenr=prZenr
    endif

    // Проверка 2-й цены на 3-ю
    if (BZenr<XZenr.and.nofr=1)
      //      BZenr=XZenr
    //      prBZenr=prXZenr
    endif

  endif

  if (int(ktlr/1000000)<2)
    if (Zenr=0)
      BZenr=0
      XZenr=0
    endif

  endif

  sele rs2

  RpZen(0)
  ktlr=ktl_rr
  MZenr=MZen_rr
  optr=opt_rr
  return

/****************** */
function chkZen1(p1)
  /****************** */
  local ktl_rrr
  if (gnKt=1)
    return (.t.)
  endif

  if (!empty(p1))
    ktl_rrr=ktlr
    ktlr=p1
  endif

  // if Zenr<nZenr
  //   if gnCenr=0.and.gnAdm=0
  //      wmess('Низзя!!!',1)
  //      retu .f.
  //   else
  rpZen(1)
  ktlr=ktl_rrr
  return (.t.)
  //   endif
  // else
  //   rpZen(1)
  //   retu .t.
  // endif
  // retu .t.

/******************* */
function chkZenm1(p1)
  /******************* */
  if (gnKt=1)
    return (.t.)
  endif

  // local mntov_rrr
  // if !empty(p1)
  //   mntov_rrr=mntovr
  //   mntovr=p1
  // endif
  // rpZen(1)
  // mntovr=mntov_rrr
  return (.t.)

/***********************************************************
 * rpZen() -->
 *   Параметры :
 *   Возвращает:
 */
function rpZen(p1)
  // Расчет реального процента наценки
  if (nofr=1)
    if (ndsr=2.or.ndsr=3.or.ndsr=5)
      if (p1=0.or.p1=1)
        if (int(ktlr/1000000)<2.and.Zenr=0)
          prZenr=0
        else
          if (ZenPr#0)
            if (Zenr#0)
              prZenr=round((Zenr/ZenPr-1)*100, 2)
            else
              prZenr=0
            endif

          else
            prZenr=0
          endif

        endif

      endif

      if (p1=0.or.p1=2)
        if (int(ktlr/1000000)<2.and.BZenr=0)
          prBZenr=0
        else
          if (BZenPr#0)
            if (BZenr#0)
              prBZenr=round((BZenr/BZenPr-1)*100, 2)
            else
              prBZenr=0
            endif

          else
            prBZenr=0
          endif

        endif

      endif

      if (p1=0.or.p1=3)
        if (int(ktlr/1000000)<2.and.XZenr=0)
          prXZenr=0
        else
          if (XZenPr#0)
            if (XZenr#0)
              prXZenr=round((XZenr/XZenPr-1)*100, 2)
            else
              prXZenr=0
            endif

          else
            prXZenr=0
          endif

        endif

      endif

    else
      if (p1=0.or.p1=1)
        if (int(ktlr/1000000)<2.and.Zenr=0)
          prZenr=0
        else
          if (ZenPr#0)
            //               prZenr=round((Zenr/(ZenPr*(1+gnNds/100))-1)*100,2)
            prZenr=round((Zenr/(round(ZenPr*(1+gnNds/100), 2))-1)*100, 2)
          else
            prZenr=0
          endif

        endif

      endif

      if (p1=0.or.p1=2)
        if (int(ktlr/1000000)<2.and.BZenr=0)
          prBZenr=0
        else
          if (BZenPr#0)
            //               prBZenr=round((BZenr/(BZenPr*(1+gnNds/100))-1)*100,2)
            prBZenr=round((BZenr/(round(BZenPr*(1+gnNds/100), 2))-1)*100, 2)
          else
            prBZenr=0
          endif

        endif

      endif

      if (p1=0.or.p1=3)
        if (int(ktlr/1000000)<2.and.XZenr=0)
          prXZenr=0
        else
          if (XZenPr#0)
            //               prXZenr=round((XZenr/(XZenPr*(1+gnNds/100))-1)*100,2)
            prXZenr=round((XZenr/(round(XZenPr*(1+gnNds/100), 2))-1)*100, 2)
          else
            prXZenr=0
          endif

        endif

      endif

    endif

  else
    if (ndsr=2.or.ndsr=3.or.ndsr=5)
      if (p1=0.or.p1=1)
        if (int(ktlr/1000000)<2.and.Zenr=0)
          prZenr=0
        else
          if (ZenPr#0)
            prZenr=round((Zenr/ZenPr-1)*100, 2)
            if (prZenr>999.99)
              prZenr=999.99
            endif

          else
            prZenr=0
          endif

        endif

      endif

      if (p1=0.or.p1=2)
        if (int(ktlr/1000000)<2.and.BZenr=0)
          prBZenr=0
        else
          if (BZenPr#0)
            prBZenr=round((BZenr/BZenPr-1)*100, 2)
            if (prBZenr>999.99)
              prBZenr=999.99
            endif

          else
            prBZenr=0
          endif

        endif

      endif

      if (p1=0.or.p1=3)
        if (int(ktlr/1000000)<2.and.XZenr=0)
          prXZenr=0
        else
          if (XZenPr#0)
            prXZenr=round((XZenr/XZenPr-1)*100, 2)
            if (prXZenr>999.99)
              prXZenr=999.99
            endif

          else
            prXZenr=0
          endif

        endif

      endif

    else
      if (p1=0.or.p1=1)
        if (int(ktlr/1000000)<2.and.Zenr=0)
          prZenr=0
        else
          if (ZenPr#0)
            if (kopr=191)
              //                  prZenr=round((Zenr/(ZenPr*(1+gnNds/100))-1)*100,2)
              prZenr=round((Zenr/(round(ZenPr*(1+gnNds/100), 2))-1)*100, 2)
              if (prZenr>999.99)
                prZenr=999.99
              endif

            else
              prZenr=round((Zenr/ZenPr-1)*100, 2)
              if (prZenr>999.99)
                prZenr=999.99
              endif

            endif

          else
            prZenr=0
          endif

        endif

      endif

      if (p1=0.or.p1=2)
        if (int(ktlr/1000000)<2.and.BZenr=0)
          prBZenr=0
        else
          if (BZenPr#0)
            if (kopr=191)
              //                  prBZenr=round((BZenr/(BZenPr*(1+gnNds/100))-1)*100,2)
              prBZenr=round((BZenr/(round(BZenPr*(1+gnNds/100), 2))-1)*100, 2)
              if (prBZenr>999.99)
                prBZenr=999.99
              endif

            else
              prBZenr=round((BZenr/BZenPr-1)*100, 2)
              if (prBZenr>999.99)
                prBZenr=999.99
              endif

            endif

          else
            prBZenr=0
          endif

        endif

      endif

      if (p1=0.or.p1=3)
        if (int(ktlr/1000000)<2.and.XZenr=0)
          prXZenr=0
        else
          if (XZenPr#0)
            if (kopr=191)
              //                  prXZenr=round((XZenr/(XZenPr*(1+gnNds/100))-1)*100,2)
              prXZenr=round((XZenr/(round(XZenPr*(1+gnNds/100), 2))-1)*100, 2)
              if (prXZenr>999.99)
                prXZenr=999.99
              endif

            else
              prXZenr=round((XZenr/XZenPr-1)*100, 2)
              if (prXZenr>999.99)
                prXZenr=999.99
              endif

            endif

          else
            prXZenr=0
          endif

        endif

      endif

    endif

  endif

  return (.t.)

/**************** */
function chkZen2()
  /*************** */
  if (gnKt=1)
    return (.t.)
  endif

  if (BZenr<XZenr.and.nofr=1)
    if (gnCenr=0.and.gnAdm=0)
      wmess('Низзя!!!', 1)
      return (.f.)
    else
      rpZen(2)
      return (.t.)
    endif

  else
    rpZen(2)
    return (.t.)
  endif

  return (.t.)

/*************** */
function chkZen3()
  /*************** */
  if (gnKt=1)
    return (.t.)
  endif

  if (XZenr<optr.and.nofr=1)
    if (gnCenr=0.and.gnAdm=0)
      //       wmess('Низзя!!!',1)
    //       retu .f.
    else
      rpZen(3)
      return (.t.)
    endif

  else
    rpZen(3)
    return (.t.)
  endif

  return (.t.)

/**************** */
function chkZenm2()
  /**************** */
  if (gnKt=1)
    return (.t.)
  endif

  if (BZenmr<XZenmr.and.nofr=1)
    if (gnCenr=0.and.gnAdm=0)
      //       wmess('Низзя!!!',1)
    //       retu .f.
    else
      //       rpZen(2)
      return (.t.)
    endif

  else
    //   rpZen(2)
    return (.t.)
  endif

  return (.t.)

/***********************************************************
 * chkZenm3() -->
 *   Параметры :
 *   Возвращает:
 */
function chkZenm3()
  if (gnKt=1)
    return (.t.)
  endif

  return (.t.)

/*****************************************************************
 
 FUNCTION:
 АВТОР..ДАТА..........С. Литовка  04-10-17 * 01:41:46pm
 НАЗНАЧЕНИЕ......... ввод цены по акции на Количество
 ПАРАМЕТРЫ..........  // p1 mntov   // p2 kol
 ВОЗВР. ЗНАЧЕНИЕ....
 ПРИМЕЧАНИЯ.........
 */
function ZenAk(p1, p2)
  local kol_rr, nZenRoz:=0
  mntov_rr=p1
  kol_rr=p2

  if (kol_rr#0)
    mntovt_rr=getfield('t1', 'mntov_rr', 'ctov', 'mntovt')
    KolAkc_rr=getfield('t1', 'mntov_rr', 'ctov', 'KolAkc')
    if (KolAkc_rr # 0)
      if (kol_rr >= KolAkc_rr)
        if (gnEnt=21)
          ZenAkr=getfield('t1', 'mntov_rr', 'ctov', 'c14')

          if (kopr = 169) // розница
            nZenRoz:=0
            kg_r:=int(mntovt_rr/10000)
            if (!empty(getfield('t1', 'kg_r', 'cgrp', 'nal')))
              // акциз
              nZenRoz:=getfield('t1', 'mntov_rr', 'ctov', 'RozPr')
            endif

            if (nZenRoz # 0)
              ZenAkr := nZenRoz
            endif

          else
            // для других операция

          endif

        else
          ZenAkr=getfield('t1', 'mntovt_rr', 'ctov', 'c14')

        endif

        if (ZenAkr#0)
          Zenr=round(ZenAkr, 2)
          ZenPr=Zenr
          BZenr=Zenr
          BZenPr=Zenr
        endif

      endif

    endif

  endif

  return (.t.)


/*****************************************************************
 
 FUNCTION:
 АВТОР..ДАТА..........С. Литовка  11-26-20 * 03:58:02pm
 НАЗНАЧЕНИЕ.........
 ПАРАМЕТРЫ..........
 ВОЗВР. ЗНАЧЕНИЕ....
 ПРИМЕЧАНИЯ.........
 */
STATIC FUNCTION Repl_ZenRs2()
  sele rs2
  if (netseek('t1', 'ttnr'))
    while (ttn=ttnr)
      ktlr=ktl
      mntovr=mntov
      if (int(ktlr/1000000)#kgrr)
        skip
        loop
      endif

      Zenr=Zen
      ZenPr=ZenP
      BZenr=BZen
      BZenPr=BZenP
      XZenr=XZen
      XZenPr=XZenP
      prZenr=gprZenr
      prZenPr=prZenP
      prBZenr=gprBZenr
      prBZenPr=prBZenP
      sele tov
      if (netseek('t1', 'sklr,ktlr'))
        Zen(1)
      endif

      sele rs2
      kvpr=kvp
      svpr=round(kvpr*Zenr, 2)
      netrepl('svp,Zen,pZen,BZen,pBZen',       ;
                'svpr,Zenr,prZenr,BZenr,prBZenr' ;
            )
      skip
    enddo

  endif
  RETURN ( NIL )

/*****************************************************************
 
 FUNCTION:
 АВТОР..ДАТА..........С. Литовка  11-26-20 * 04:41:59pm
 НАЗНАЧЕНИЕ.........
 ПАРАМЕТРЫ..........
 ВОЗВР. ЗНАЧЕНИЕ....
 ПРИМЕЧАНИЯ.........
 */
STATIC FUNCTION Repl_ZenIzgRs2()
  sele rs2
  if (netseek('t1', 'ttnr'))
    while (ttn=ttnr)
      ktlr=ktl
      mntovr=mntov
      if (int(ktlr/1000000)#kgrr.and.izg#izgr)
        skip
        loop
      endif

      Zenr=Zen
      ZenPr=ZenP
      BZenr=BZen
      BZenPr=BZenP
      XZenr=XZen
      XZenPr=XZenP
      prZenr=iprZenr
      prZenPr=prZenP
      prBZenr=iprBZenr
      prBZenPr=prBZenP
      sele tov
      if (netseek('t1', 'sklr,ktlr'))
        Zen(1)
      endif

      sele rs2
      kvpr=kvp
      svpr=round(kvpr*Zenr, 2)
      netrepl('svp,Zen,pZen,BZen,pBZen',       ;
                'svpr,Zenr,prZenr,BZenr,prBZenr' ;
            )
      skip
    enddo

  endif
  RETURN ( NIL )

/*****************************************************************
 
 FUNCTION:
 АВТОР..ДАТА..........С. Литовка  11-26-20 * 06:57:12pm
 НАЗНАЧЕНИЕ.........
 ПАРАМЕТРЫ..........
 ВОЗВР. ЗНАЧЕНИЕ....
 ПРИМЕЧАНИЯ.........
 */
STATIC FUNCTION Create_pSGr()

  erase psgr.dbf
  erase psgr.cdx

  crtt('pSGr',;
   'f:kg c:n(3) f:ng c:c(20)';
   +' f:pXZen c:n(7,2) f:prXZenP c:n(7,2)';
   +' f:SmXZen c:n(10,2) f:SmXZenP c:n(10,2)';
   ;//
   +' f:pUZen c:n(7,2) f:prUZenP c:n(7,2)';
   +' f:SmUZen c:n(10,2) f:SmUZenP c:n(10,2) f:SmSUZen c:n(10,2)';
   ;//
   +' f:pZen c:n(7,2) f:prZenP c:n(7,2)';
   +' f:SmZen c:n(10,2) f:SmZenP c:n(10,2) f:SmSZen c:n(10,2)';
   ;//
   +' f:pBZen c:n(7,2) f:prBZenP c:n(7,2)';
   +' f:SmBZen c:n(10,2) f:SmBZenP c:n(10,2) f:SmSBZen c:n(10,2)';
   )
  sele 0
  use psgr
  index on str(kg, 3) tag t1

  if (select('pizg')#0)
    sele pizg
    CLOSE
  endif

  erase pizg.dbf
  erase pizg.cdx
  crtt('pIzg',;
   'f:izg c:n(7) f:nizg c:c(20)';
   +' f:pXZen c:n(7,2) f:prXZenP c:n(7,2)';
   +' f:SmXZen c:n(10,2) f:SmXZenP c:n(10,2)';
   ;//
   +' f:pUZen c:n(7,2) f:prUZenP c:n(7,2)';
   +' f:SmUZen c:n(10,2) f:SmUZenP c:n(10,2) f:SmSUZen c:n(10,2)';
   ;//
   +' f:pZen c:n(7,2) f:prZenP c:n(7,2)';
   +' f:SmZen c:n(10,2) f:SmZenP c:n(10,2) f:SmSZen c:n(10,2)';
   ;//
   +' f:pBZen c:n(7,2) f:prBZenP c:n(7,2)';
   +' f:SmBZen c:n(10,2) f:SmBZenP c:n(10,2) f:SmSBZen c:n(10,2)';
   )
  sele 0
  use pizg
  index on str(izg, 7) tag t1

  RETURN ( NIL )
