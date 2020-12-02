/***********************************************************
 * Модуль    : rfakt.prg
 * Версия    : 0.0
 * Автор     :
 * Дата      : 07/30/18
 * Изменен   :
 * Примечание: Текст обработан утилитой CF версии 2.02
 */

#include "common.ch"
#include "inkey.ch"
// (OTGRZ) 05-06-89 // факт отгр
local i
if (!PrDp())
  return
endif

set colo to g/n, n/g,,,
nuse()
if (Who = 2.or.Who=4)
  wmess('Подтверждение запрещено !')
  return
endif

CLEAR
STOR 0 to ND1, R10, GRPOL, KOD1, GRP2, GRP4, GRP6, NOM, vor, Ttnr, sdvr, kgpr, kplr, ndsr, pndsr, nkklr, pr1ndsr
STOR 0.00 to R20, KSUM, SUMT
STOR 0.000 to KOLT, FKT1

store 0 to gnSkt, gnSklt    // Адрес назначения по OPER

DOTR=gdTd
vur=1

store 0 to Ttnr, kplr, kgpr, sklr, kopr, spdr, vor, ktor, przr, bprzr, sdvr, vsvr, mskltr, skltr, prNppr, pstr, ktar, ktasr, pr1ndsr, prDecr
tarar=1
store ctod('') to dvpr, ddcr, dnzr
store '' to nnzr, fktor

skr=gnSk
rmskr=gnRmsk

/*  ----------------------------- */
NOM=1
/*OTV=0 */
DDCR=DATE()
SET DEVICE to SCREEN
Pathr=gcPath_t
if (!netUse('rs1'))
  nuse()
  return
endif

if (!netUse('rs2'))
  nuse()
  return
endif

if (!netUse('rs3'))
  nuse()
  return
endif

if (!netUse('sgrp'))
  nuse()
  return
endif

if (!netUse('tov'))
  nuse()
  return
endif

if (!netUse('etm'))
  nuse()
  return
endif

if (gnCtov=1)
  if (!netUse('tovm'))
    nuse()
    return
  endif

  if (!netUse('ctov'))
    nuse()
    return
  endif

  if (!netUse('cgrp'))
    nuse()
    return
  endif

endif

if (!netUse('sOPER'))
  nuse()
  return
endif

if (!netUse('cskl'))
  nuse()
  return
endif

if (!netUse('stagtm'))
  nuse()
  return
endif

if (!netUse('moddoc'))
  nuse()
  return
endif

if (!netUse('mdall'))
  nuse()
  return
endif

if (!netUse('kpl'))
  nuse()
  return
endif

if (!netUse('kps'))
  nuse()
  return
endif

if (!netUse('nap'))
  nuse()
  return
endif

if (!netUse('naptm'))
  nuse()
  return
endif

if (!netUse('kplnap'))
  nuse()
  return
endif

if (!netUse('ktanap'))
  nuse()
  return
endif

if (!netUse('nds'))
  nuse()
  return
endif

if (!netUse('nnds'))
  nuse()
  return
endif

if (!netUse('cntm'))
  nuse()
  return
endif

sele tov
/*#ifdef __CLIP__
 *   if !(netUse('dokk').AND.netuse('aninf').AND.netuse('aninfl').AND.netuse('DokA'))
 *      nuse()
 *      retu
 *   endif
 *#else
 */
if (!netUse('dokk'))
  nuse()
  return
endif

/*#endif */
if (!netUse('bs'))
  nuse()
  return
endif

if (!netUse('dkkln'))
  nuse()
  return
endif

if (!netUse('dknap'))
  nuse()
  return
endif

if (!netUse('dkklns'))
  nuse()
  return
endif

if (!netUse('dkklna'))
  nuse()
  return
endif

if (!netUse('dokko'))
  nuse()
  return
endif

if (!netUse('s_tag'))
  nuse()
  return
endif

if (!netUse('stagm'))
  nuse()
  return
endif

if (!netUse('kplkgp'))
  nuse()
  return
endif

if (!netUse('tmesto'))
  nuse()
  return
endif

if (!netUse('speng'))
  nuse()
  return
endif

if (!netUse('kln'))
  nuse()
  return
endif

if (!netUse('vo'))
  nuse()
  return
endif

if (gnCtov=3)
  if (!netUse('ctovk'))
    nuse()
    return
  endif

  if (!netUse('cgrpk'))
    nuse()
    return
  endif

endif

netuse('grpizg')
netuse('dclr')
netuse('tcen')
//netuse('tovpt')

RsPod()

unlock all
CLEA
nuse()
return

/******************** */
function RsPod(p1)
  /* p1=1 из документа
   *******************
   */
  if (!empty(p1))
    pdfDocr=1
    nom=1
  else
    pdfDocr=0
  endif

  while (NOM<>0)
    prNppr=0
    if (pdfDocr=0)
      @ 5, 0 clea
      @ 15, 1 clear to 19, 40
      @ 1, 57, 4, 78 box FRAME
      @ 2, 58 say 'Фактическая отгрузка'
      @ 3, 64 say (IIF(DATE()>=BOM(gDTd) .AND. DATE()<=EOM(gDTd), DTOC(DATE()), DTOC(EOM(gDTd))))//DTOC(DATE())
      @ 5, 0 CLEA
      Ttnr = 0
      @ 7, 10 say 'Номер док.' get Ttnr PICT '999999' RANGE 0, 999999
      read
      if (LastKey() = 27)
        exit
      endif

      if (Ttnr=0)
        SET DEVI to SCREE
        exit
      endif

    endif

    if (!netseek('t1', 'Ttnr', 'rs2'))
      wmess('Нет товара', 3)
      if (pdfDocr=0)
        Ttnr=0
        loop
      else
        return (.f.)
      endif

    endif

    Pathr=gcPath_t
    if (pdfDocr=0)
      SELE RS1
      if (!netseek('t1', 'Ttnr',,, 1))
        wmess('Документ отсутствует', 3)
        Ttnr=0
        loop
      endif

    else
      if (Ttnr#rs1->ttn)
        sele rs1
        netseek('t1', 'Ttnr',,, 1)
      endif

    endif // (ALT+F4)

    if (rs1->vo=9 .and. rs1->pSt=0)// (продажа и возврат с/т)
                                     //.and. rs1->pt=1 ; // признак, что есть тара
      wmess('СТ/Т только продажная!!! (F5)', 3)
      if (pdfDocr=0)
        Ttnr=0
        loop
      else
        return (.f.)
      endif

    endif

    if (rs1->prz=1)
      wmess('Документ '+STR(Ttnr, 6)+' подтвержден '+DTOC(rs1->DOT), 3)
      if (pdfDocr=0)
        Ttnr=0
        loop
      else
        return (.f.)
      endif

    endif

    if (gnEntrm=0.and.rs1->rmsk#0.or.gnEntrm=1.and.rs1->rmsk=0)
      wmess('Чужой документ НИЗЗЯ!!!', 3)
      if (pdfDocr=0)
        Ttnr=0
        loop
      else
        return (.f.)
      endif

    endif

    if (rs1->kop=151.and.gnEnt=21.and.!(gnSk=237.or.gnSk=702))
      wmess('151  НИЗЗЯ!!!', 3)
      if (pdfDocr=0)
        Ttnr=0
        loop
      else
        return (.f.)
      endif

    endif

    if (rs1->mk169#0.and.rs1->pr169#2)
      wmess('169 NOF НИЗЗЯ!!!', 3)
      if (pdfDocr=0)
        Ttnr=0
        loop
      else
        return (.f.)
      endif

    endif

    if (rs1->mk129#0.and.rs1->pr129#2)
      wmess('129 NOF НИЗЗЯ!!!', 3)
      if (pdfDocr=0)
        Ttnr=0
        loop
      else
        return (.f.)
      endif

    endif

    if (rs1->mk139#0.and.rs1->pr139#2)
      wmess('139 NOF НИЗЗЯ!!!', 3)
      if (pdfDocr=0)
        Ttnr=0
        loop
      else
        return (.f.)
      endif

    endif

    if (gnAdm=0.and.(rs1->kop=126.or.rs1->kop=196.or.rs1->kop=177))
      wmess('126-й,196-й,177-й НИЗЗЯ!!!', 3)
      if (pdfDocr=0)
        Ttnr=0
        loop
      else
        return (.f.)
      endif

    endif

    sele rs1
    bsor=bso
    if (bsor#0.and.!(alltrim(uprlr)=='dadi'.or.alltrim(uprlr)=='sweet').and.(gnEnt=13.or.gnEnt=16))
      wmess('Только Павловна НИЗЗЯ!!!', 3)
      if (pdfDocr=0)
        Ttnr=0
        loop
      else
        return (.f.)
      endif

    endif

    sklr=skl
    sele rs2
    prOtchr=1
    prXmlr=0
    if (netseek('t1', 'Ttnr'))
      while (ttn=Ttnr)
        if (otv#0)
          prOtchr=0
        endif

        mntovr=mntov
        if (gnCtov=1)
          uktr=getfield('t1', 'mntovr', 'ctov', 'ukt')
          if (!empty(uktr))
            if (rs1->kop=160.or.rs1->kop=161)
              prXmlr=1
            endif

          endif

        else
          uktr=space(10)
        endif

        sele rs2
        skip
      enddo

    endif

    // ********************************
    // *prOtchr=1
    // ********************************
    if (prOtchr=0)
      wmess('Не подтвержден отчет по ответ.хранению', 2)
      if (pdfDocr=0)
        Ttnr=0
        loop
      else
        return (.f.)
      endif

    endif

    sele rs1
    if (pdfDocr=0)
      if (!RecLock(1))
        wmess('Документ блокирован, повторите позже', 2)
        Ttnr=0
        loop
      endif

    endif

    Ttnr=TTN
    DVPR=DVP
    DDCR=DDC
    tdcr=tdc
    KPLR=KPL
    kpsbbr=getfield('t1', 'kplr', 'kps', 'prbb')
    pr1ndsr=getfield('t1', 'kplr', 'kpl', 'pr1nds')
    nkklr=nkkl
    kpvr=kpv
    nkplr=getfield('t1', 'kplr', 'kln', 'nkl')
    KGPR=KGP
    nkgpr=getfield('t1', 'kgpr', 'kln', 'nkl')
    sklr=SKL
    nsklr=gcNskl
    NNZR=NNZ
    DNZR=DNZ
    KOPR=KOP
    kopir=kopi
    qr=mod(kopr, 100)
    vor=vo
    nvor=getfield('t1', 'vor', 'vo', 'nvo')
    SPDR=SPD
    DOTR=DOT
    totr=tot
    KTOR=KTO
    fktor=getfield('t1', 'ktor', 'speng', 'fio')
    ktar=kta
    ktasr=ktas
    if (ktasr=0)
      ktas_r=getfield('t1', 'ktar', 's_tag', 'ktas')
      if (ktasr#ktas_r)
        sele rs1
        netrepl('ktas', 'ktas_r', 1)
        ktasr=ktas
      endif

    endif

    tmestor=tmesto
    if (tmestor#0)
      tmesto_r=getfield('t2', 'nkklr,kpvr', 'etm', 'tmesto')
      if (tmesto_r#0)
        if (tmestor#tmesto_r)
          tmestor=tmesto_r
        endif

      else
        tmesto_r=getfield('t2', 'nkklr,kpvr', 'tmesto', 'tmesto')
        if (tmestor#tmesto_r)
          tmestor=tmesto_r
        endif

      endif

    else
      tmesto_r=getfield('t2', 'nkklr,kpvr', 'etm', 'tmesto')
      if (tmesto_r#0)
        tmestor=tmesto_r
      else
        tmesto_r=getfield('t2', 'nkklr,kpvr', 'tmesto', 'tmesto')
        tmestor=tmesto_r
      endif

    endif

    sele rs1
    netrepl('tmesto', 'tmestor', 1)
    PRZR=PRZ
    bprzr=bprz
    SDVR=SDV
    VSVR=VSV
    ztr = KON
    kgnr=kgn
    otnr=otn
    sktr=skt
    skltr=sklt
    sksr=sks
    sklsr=skls
    entpr=entp
    sktpr=sktp
    skltpr=skltp
    skspr=sksp
    sklspr=sklsp
    pr49r=pr49
    pprr=ppr
    pstr=pst
    rmskr=rmsk
    if (fieldpos('prDec')#0)
      prDecr=prDec
    else
      prDecr=0
    endif

    pr177r=pr177
    if (fieldpos('mntov177')#0)
      mntov177r=mntov177
      prc177r=prc177
    else
      mntov177r=0
      prc177r=0
    endif

    if (fieldpos('pr169')#0)
      pr169r=pr169
      mk169r=mk169
      ttn169r=ttn169
    else
      pr169r=0
      mk169r=0
      ttn169r=0
    endif

    if (fieldpos('pr129')#0)
      pr129r=pr129
      mk129r=mk129
      ttn129r=ttn129

      pr139r=pr139
      mk139r=mk139
      ttn139r=ttn139
    else
      pr129r=0
      mk129r=0
      ttn129r=0

      pr139r=0
      mk139r=0
      ttn139r=0
    endif

    if (gnRoz=1 .and. empty(dotr))
      dotr=dvpr
    endif

    dopr=dop
    if (empty(dopr).and.!(vor=7.or.vor=5).or.(vor=7.or.vor=5).and.pprr=0)//.and. gnRoz#1
      wmess('Документ '+STR(Ttnr, 6)+' не распечатан '+DTOC(DOT), 3)
      if (pdfDocr=0)
        Ttnr=0
        loop
      else
        return (.f.)
      endif

    endif

    if (gnEnt=20.and.ktar#556.and.ktasr=556.and..f.)//gnRmsk#5
      if (tmestor=0)
        wmess(STR(Ttnr, 6)+' торг место = 0 ', 1)
        if (pdfDocr=0)
          Ttnr=0
          loop
        else
          return (.f.)
        endif

      else
        tmesto_r=getfield('t2', 'nkklr,kpvr', 'etm', 'tmesto')
        if (tmesto_r=0)
          wmess('Нет торг места в спр торг мест ETM', 1)
          if (pdfDocr=0)
            Ttnr=0
            loop
          else
            return (.f.)
          endif

        endif

        sele rs1
        if (tmesto#tmesto_r)
          tmestor=tmesto_r
          netrepl('tmesto', 'tmestor', 1)
        endif

        if (!netseek('t1', 'ktar,tmestor', 'stagtm'))
          wmess(STR(Ttnr, 6)+' непpивяз торг место к агенту ', 1)
          if (pdfDocr=0)
            Ttnr=0
            loop
          else
            return (.f.)
          endif

        endif

      endif

    endif

    if (kplr=20034)
      tarar=0
    else
      ssf12r=getfield('t1', 'Ttnr,12', 'rs3', 'ssf')
      if (ssf12r#0)
        tarar=0
      else
        tarar=1
      endif

    endif

    sele soper
    if (netseek('t1', 'gnD0k1,gnVu,Vor,qr'))
      autor=auto
      nopr=nop
      tcenr=tcen
      pbzenr=pbzen
      ndsr=nds
      pndsr=pnds
      prnnr=prnn
      koppr=kopp
      if (autor=3.or.autor=4.or.autor=1.and.vor=6.and.kopr=189)
        if (koppr=0)
          wmess('Нет кода операции для автомата', 3)
          if (pdfDocr=0)
            Ttnr=0
            loop
          else
            return (.f.)
          endif

        endif

      endif

      pxzenr=pxzen
      xndsr=xnds
      nofr=nof
      if (autor#0)
        if (autor#4)
          if (sktr#0)
            sele cskl
            if (netseek('t1', 'sktr'))
              gcPath_tt=gcPath_d+alltrim(path)
              if (!file(gcPath_tt+'tprds01.dbf'))
                wmess('Нет баз для автоматического прихода', 3)
                loop
              endif

              mskltr=mskl
            else
              wmess('Не найден адрес в CSKL', 3)
              if (pdfDocr=0)
                Ttnr=0
                loop
              else
                return (.f.)
              endif

            endif

          else
            wmess('Нет адреса для автоматического прихода в документе', 3)
            if (pdfDocr=0)
              Ttnr=0
              loop
            else
              return (.f.)
            endif

          endif

        else
          if (entpr#0)
            sele menent
            locate for ent=entpr
            if (!foun())
              entpr=0
            endif

          endif

          if (entpr=0)
            wmess('Нет предприятия назначения в MENENT', 3)
            if (pdfDocr=0)
              Ttnr=0
              loop
            else
              return (.f.)
            endif

          endif

          sele menent
          commr=comm
          nentpr=uss
          direpr=alltrim(nent)+'\'
          if (commr=0)
            pathemr=gcPath_ini
          else
            pathemr=gcPath_ini+direpr
          endif

          pathepr=pathemr+direpr
          pathecr=pathemr+gcDir_c
          if (sktpr#0)
            pathr=pathecr
            netuse('cskl', 'ecskl',, 1)
            if (netseek('t1', 'sktpr'))
              pathtpr=pathepr+gcDir_g+gcDir_d+alltrim(path)
              if (!file(pathtpr+'tprds01.dbf'))
                wmess('Нет баз для автоматического прихода', 3)
                if (pdfDocr=0)
                  Ttnr=0
                  loop
                else
                  return (.f.)
                endif

              endif

              mskltr=mskl
            else
              wmess('Не найден адрес в CSKL', 3)
              if (pdfDocr=0)
                Ttnr=0
                loop
              else
                return (.f.)
              endif

            endif

            nuse('ecskl')
          else
            wmess('Нет адреса для автоматического прихода в документе', 3)
            if (pdfDocr=0)
              Ttnr=0
              loop
            else
              return (.f.)
            endif

          endif

        endif

      endif

    else
      wmess('Не найдена операция', 3)
      if (pdfDocr=0)
        Ttnr=0
        loop
      else
        return (.f.)
      endif

    endif

    sele rs2
    netseek('t1', 'Ttnr')
    exr=0
    lError=.F.
    cntrs2r=0
    while (TTN = Ttnr)
      mntovr=mntov
      ktlr=ktl
      kvpr=kvp
      zenr=zen
      SELE tov
      netseek('t1', 'sklr,ktlr')
      if (gnVo#4)
        if (OSF - KVPr < 0 .and. !gnRoz=1 .and. !gnOst0=1)
          lError=.T.

          if (exr=0 .or. exr=2)
            nKey:=wmess('Отстаток по продукции '+Str(KTLr, 9)+' ОТРИЦАТЕЛЕН! Подтверждение НЕ ВОЗМОЖНО!', 3)
            nKey:=K_ESC
            if (nKey = K_ENTER)
            //
            elseif (nKey = K_ESC)
              aqstr=1
              aqst:={ "Выйти", "Продолжить", "Формировать протокол" }
              aqstr:=alert(" Отстаток по продукции  ОТРИЦАТЕЛЕН!", aqst)
              do case
              case (aqstr = 1 .or.aqstr = 0)
                if (pdfDocr=0)
                  exit
                else
                  return (.f.)
                endif

              case (aqstr = 2)
              //
              case (aqstr = 3)
                //
                sele tov
                aDbStru:=DBStruct()
                aFlNm := { aDbStru[ ascan(aDbStru, { | aFld | upper(aFld[ 1 ])='NAT' }) ] }
                //aFlNm[1,3]:=20 // укоротим наименование
                SELE rs2
                aDbStru:=DBStruct()
                aeval(aDbStru, { | aFld | aadd(aFlNm, aFld) })
                dbcreate('tmp_dot', aFlNm)//copy stru to tmp_dot
                use tmp_dot new Exclusive
                exr:=1
              endcase

            else
              lError=.T.
              if (pdfDocr=0)
                exr=1
                exit
              else
                return (.f.)
              endif

            endif

          else
          //
          endif

          if (exr = 1)
            SELE rs2
            copy to tmp1 next 1
            sele tmp_dot
            locate for mntovr=mntov
            if (!found())
              append from tmp1
            endif

            repl KVPO with KVPO + KVPr ;// накопление к-ва
             , KVP with tov->OSF - KVPO;// сколько не хватает
             , skl with tov->OSF       ;// остаток общий
             , Nat with tov->Nat        // остаток общий

            SELE tov
          endif

        endif

      endif

      if (zenr=0.and.!(int(ktlr/1000000)=0.or.int(ktlr/1000000)=1))
        wmess('Нет отпускной цены '+Str(KTLr, 9)+' Подтверждение НЕ ВОЗМОЖНО!', 3)
        lError=.T.
        if (pdfDocr=0)
          exr=1
          exit
        else
          return (.f.)
        endif

      endif

      SELE rs2
      cntrs2r++
      Skip
    enddo

    if (lError)           //exr = 1
      if (type('aqstr')='N' .and. aqstr = 3)
        tmp_dot->(DBGoTop(), BROWSE(), DBCloseArea())

      endif

      exit
    endif

    // ***************************************************************
    // * Перерасчет
    // ***************************************************************
    // **********************************************
    mode=1
    // **********************************************
    tbl1r='rs1'
    tbl2r='rs2'
    tbl3r='rs3'
    mDocr='Ttnr'
    fDocr='ttn'
    fKolr='kvp'
    fSumr='svp'
    fprr='pr'
    mprr='prr'
    Tbl3Oper()
    pere(2)
    sele rs3

    // удаление пустых
    If (netseek('t1', '0'))
      DBEval({|| netdel()}, , {|| ttn=0})
    EndIf
    if (netseek('t1', 'Ttnr'))

      // удаление пустых
      while (ttn=Ttnr)
        if (ssf=0.and.bssf=0)
          netdel()
        endif

        skip
      enddo

    endif

    // ***************************************************************
    SELE rs1
    if (pdfDocr=0)
      RZAG()
      R10=0
      N1=24
      STREL()
      @ 24, 6 say 'Информация по документу верна - "─┘"(ENTER), иначе - "1","─┘"(ENTER)  ' get R10 PICT '9' RANGE 0, 1
      READ
      @ 1, 0
      if (R10=1)
        @ 1, 10 say '       '
        @ 4, 0, 4, 56 box ""
        @ 5, 0 CLEA
        loop
      endif

      R10=0
      kopr1=kopr
      vor1=vor
      dotr1=dot
      ddc1=ddc
      pr_loop=.F.
      while (.T.)
        @ 13, 27 say str(KOPR, 3)
        @ 15, 28 say str(VOR, 1)
        if (empty(dotr).or.(month(dotr)#month(gdTd).and.year(dotr)#year(gdTd)))
          DOTR=gdTd
        endif

        //dotr:=date()
        //@ 17,27 GET DOTR RANGE bom(gdTd),eom(gdTd)
        dotr:=(IIF(DATE()>=BOM(gDTd) .AND. DATE()<=EOM(gDTd), DATE(), EOM(gDTd)))
        @ 18, 27 get DOTR RANGE bom(gdTd), eom(gdTd)
        @ 24, 0
        N1=24
        STREL()
        @ 24, 6 say 'Проставьте дату отгрузки и нажмите "─┘"(ENTER) ' get R10 PICT '9' RANGE 0, 0
        READ
        if (lastkey()=K_ESC)
          @ 1, 0 clear
          pr_loop=.T.
          exit
        endif

        if (bsor#0.and.!(alltrim(uprlr)=='dadi'.or.alltrim(uprlr)=='sweet').and.(gnEnt=13.or.gnEnt=16))
          if (!(gnEnt=13.and.kopr=191.or.gnEnt=16.and.kopr=169).and.dotr>ctod('24.07.2006'))
            wmess('Дата больше 24.07.2006', 2)
            loop
          endif

        endif

        SELE RS1
        @ 24, 0 clea
        @ 24, 10 say 'Ждите идет обработка'
        SELE RS1
        exit
      enddo

      if (pr_loop=.T.)
        @ 2, 0 clear to 5, 50
        loop
      endif

    else
      dotr:=(IIF(DATE()>=BOM(gDTd) .AND. DATE()<=EOM(gDTd), DATE(), EOM(gDTd)))
      @ 24, 0 clea
      @ 24, 1 say 'Дата подтверждения' get DOTR RANGE bom(gdTd), eom(gdTd)
      read
      if (lastkey()=K_ESC)
        return (.f.)
      endif

    endif

    // ***************
    save screen to scrfakt
    mess('Товар...')
    VUR=gnVu
    SELE RS2
    set orde to tag t1
    KOD1=1
    netseek('t1', 'Ttnr')
    while (TTN = Ttnr)
      mntovr=mntov
      ktlr=ktl
      kvpr=kvp
      svpr=svp
      srr=sr
      zenr=zen
      kfr=kf
      sfr=sf
      netrepl('sf,kf', 'svpr,kvpr')
      SELE tov
      if (!netSEEK('t1', 'sklr,ktlr'))
        wmess('В файле "Продукция" отсутствует код '+STR(KTLr, 9), 0)
      else
        netrepl('osf,dpo', 'osf-kvpr,dotr')
        if (!(vor=9.or.vor=2.or.vor=6.and.(kopr=101.or.kopr=181.or.kopr=198)).and.empty(dopr))
          netrepl('osfo', 'osfo-kvpr')
        endif

        if (gnCtov=1)
          sele tovm
          if (netseek('t1', 'sklr,mntovr'))
            netrepl('osf', 'osf-kvpr')
          endif

          if (!(vor=9.or.vor=2.or.vor=6.and.(kopr=101.or.kopr=181.or.kopr=121.or.kopr=198)).and.empty(dopr))
            netrepl('osfo', 'osfo-kvpr')
          endif

        endif

        sele rs2
        if (!(vor=9.or.vor=2.or.vor=6.and.(kopr=101.or.kopr=181.or.kopr=121.or.kopr=198)).and.empty(dopr))
          netrepl('prosfo', '1')
        endif

        sele tov
        KEIR=KEI
        keurr=keur
        keur1r=keur1
        keur2r=keur2
        keur3r=keur3
        keur4r=keur4
        keuhr=keuh
        do case
        case (month(dotr)>2.and.month(dotr)<6)
          keu_r=keur1r
        case (month(dotr)>5.and.month(dotr)<9)
          keu_r=keur2r
        case (month(dotr)>8.and.month(dotr)<12)
          keu_r=keur3r
        otherwise
          keu_r=keur4r
        endcase

        if (keu_r=0)
          keu_r=keurr
        endif

        sele RS2
        netrepl('seu', 'svp*keu_r/100')
      endif

      SELE RS2
      Skip
    enddo

    s92r=0
    sele rs2
    if (netseek('t1', 'Ttnr'))
      while (ttn=Ttnr)
        s92r=s92r+seu
        skip
      enddo

    endif

    sele rs3
    if (netseek('t1', 'Ttnr,92'))
      if (s92r#0)
        netrepl('ssf,ssz', 's92r,s92r')
        if (pbzenr=1)
          netrepl('bssf', 's92r')
        endif

      else
        netdel()
      endif

    else
      if (s92r#0)
        netadd()
        netrepl('ttn,ksz,ssf,ssz', 'Ttnr,92,s92r,s92r')
        if (pbzenr=1)
          netrepl('bssf', 's92r')
        endif

      endif

    endif

    mess('Проводки...')
    sele rs1
    netrepl('dot,tot', 'dotr,time()', 1)
    if (empty(dop))
      netrepl('dop,top', 'dotr,time()', 1)
    endif

    if (!EMPTY(rs1->dvttn))//удаляем старую аналитику т.к. может изменилась сумма докумета
    else
      rs1->(netrepl('dvttn,tvttn,ktovttn', 'date(),time(),gnKto', 1))
      prModr=1
    endif

    rsprv(2, 1)
    rsprv(1, 0)
    SET DEVI to SCREE
    if (gnSkotv#0)        // gnOtv=1
      /* Коррекция прихода-автомата в складе cskl.skotv */
      pacotv()
    endif

    if (autor#0)
      if (autor#4)
        mess('Автомат склад-склад...')
        RPRH()
      else
        mess('Автомат предпр-предпр...')
        RPRHP()
      endif

    endif

    mess('Протокол...')
    rso(8)
    rest screen from scrfakt
    sele rs1
    netrepl('prz', '1', 1)
    if (bom(gdTd)<ctod('01.03.2011'))
      if (rs1->kop=169)
        nndsr=rs1->nnds
        sele nds
        if (!netseek('t3', 'gnSk,rs1->ttn,0'))
          sele setup
          locate for ent=gnEnt
          reclock()
          nndsr=nnds
          netrepl('nnds', 'nnds+1')
          sele nds
          netadd()
          netrepl('nomnds,kkl,sk,ttn,sum,dnn,d0k1,rmsk',                ;
                   'nndsr,kplr,gnSk,rs1->ttn,rs1->sdv,rs1->dot,0,gnRmsk' ;
                )
        else
          netrepl('nomnds,kkl,sk,ttn,sum,dnn,d0k1,rmsk',                ;
                   'nndsr,kplr,gnSk,rs1->ttn,rs1->sdv,rs1->dot,0,gnRmsk' ;
                )
        endif

        sele rs1
        netrepl('nnds', 'nndsr', 1)
      endif

    endif

    sele rs1
    prModr=1
    if (fieldpos('krspo')#0)
      netrepl('krspo,krspb,krspnb,krsp', '0,0,0,0', 1)
    endif

    netrepl('dtmod,tmmod', 'date(),time()', 1)
    if (pdfDocr=0)
    else
      exit
    endif

  enddo

  return (.t.)

/*************** */
function lstfakt()
  /*************** */
  clea
  gnScout=1
  skr=gnSk
  mode=1
  set prin to lstfakt.txt
  set prin on
  do case
  case (gnRmsk=0)
    aflr='zensdva0'
  case (gnRmsk=3)
    aflr='zensdva3'
  case (gnRmsk=4)
    aflr='zensdva4'
  case (gnRmsk=5)
    aflr='zensdva5'
  case (gnRmsk=6)
    aflr='zensdva6'
  endcase

  cl169=setcolor('gr+/b,n/w')
  w169=wopen(8, 15, 11, 65)
  wbox(1)
  @ 0, 1 say 'Файл       ' get aflr
  read
  wclose(w169)
  setcolor(cl169)
  if (lastkey()=K_ESC)
    gnScout=0
    return (.t.)
  endif

  if (!file(aflr+'.dbf'))
    gnScout=0
    wmess('Нет файла', 2)
    return (.t.)
  endif

  netuse('rs1')
  netuse('rs2')
  netuse('rs3')
  netuse('sgrp')
  netuse('tov')
  netuse('etm')
  netuse('tovm')
  netuse('ctov')
  netuse('cgrp')
  netuse('soper')
  netuse('cskl')
  netuse('stagtm')
  netuse('moddoc')
  netuse('mdall')
  netuse('kpl')
  netuse('nap')
  netuse('naptm')
  netuse('kplnap')
  netuse('ktanap')
  netuse('dokk')
  netuse('bs')
  netuse('dkkln')
  netuse('dknap')
  netuse('dkklns')
  netuse('dkklna')
  netuse('dokko')
  netuse('s_tag')
  netuse('stagm')
  netuse('kplkgp')
  netuse('tmesto')
  netuse('speng')
  netuse('kln')
  netuse('vo')
  netuse('grpizg')
  netuse('dclr')
  netuse('tcen')
  netuse('nds')

  sele 0
  use (aflr) alias zensdv
  go top
  while (!eof())
    prNppr=0
    Ttnr=ttn
    ?str(Ttnr, 6)
    sele rs1
    if (!netseek('t1', 'Ttnr'))
      ??' не найден'
      sele zensdv
      skip
      loop
    endif

    sele rs2
    if (!netseek('t1', 'Ttnr'))
      ??' нет товара'
      sele zensdv
      skip
      loop
    endif

    sele rs1
    przr=prz
    if (przr=1)
      ??' уже подтвержден'
      sele zensdv
      skip
      loop
    endif

    if (gnEntrm=0.and.rs1->rmsk#0.or.gnEntrm=1.and.rs1->rmsk=0)
      ??' не свой документ'
      sele zensdv
      skip
      loop
    endif

    if (kop=126.or.kop=196.or.kop=177)
      ??' kop='+str(kop, 3)
      sele zensdv
      skip
      loop
    endif

    bsor=bso
    if (bsor#0)
      ??' bso='+str(bsor, 1)
      sele zensdv
      skip
      loop
    endif

    sklr=skl
    sele rs2
    prOtchr=1
    if (netseek('t1', 'Ttnr'))
      while (ttn=Ttnr)
        if (otv#0)
          prOtchr=0
        endif

        sele rs2
        skip
      enddo

    endif

    if (prOtchr=0)
      ??' отч отв хр'
      sele zensdv
      skip
      loop
    endif

    sele rs1
    if (!RecLock(1))
      ??' нет блокировки'
      sele zensdv
      skip
      loop
    endif

    DVPR=DVP
    DDCR=DDC
    tdcr=tdc
    KPLR=KPL
    nkklr=nkkl
    kpvr=kpv
    nkplr=getfield('t1', 'kplr', 'kln', 'nkl')
    KGPR=KGP
    nkgpr=getfield('t1', 'kgpr', 'kln', 'nkl')
    sklr=SKL
    nsklr=gcNskl
    NNZR=NNZ
    DNZR=DNZ
    KOPR=KOP
    qr=mod(kopr, 100)
    vor=vo
    nvor=getfield('t1', 'vor', 'vo', 'nvo')
    SPDR=SPD
    DOTR=gdTd
    totr=tot
    KTOR=KTO
    fktor=getfield('t1', 'ktor', 'speng', 'fio')
    ktar=kta
    ktasr=ktas
    if (ktasr=0)
      ktas_r=getfield('t1', 'ktar', 's_tag', 'ktas')
      if (ktasr#ktas_r)
        sele rs1
        netrepl('ktas', 'ktas_r', 1)
        ktasr=ktas
      endif

    endif

    tmestor=tmesto
    tmesto_r=getfield('t2', 'nkklr,kpvr', 'tmesto', 'tmesto')
    if (tmestor#tmesto_r)
      sele rs1
      netrepl('tmesto', 'tmesto_r', 1)
      tmestor=tmesto
    endif

    bprzr=bprz
    SDVR=SDV
    VSVR=VSV
    ztr = KON
    kgnr=kgn
    otnr=otn
    sktr=skt
    skltr=sklt
    sksr=sks
    sklsr=skls
    entpr=entp
    sktpr=sktp
    skltpr=skltp
    skspr=sksp
    sklspr=sklsp
    pr49r=pr49
    pprr=ppr
    pstr=pst
    rmskr=rmsk
    if (gnRoz=1 .and. empty(dotr))
      dotr=dvpr
    endif

    dopr=dop
    if (empty(dopr).and.!(vor=7.or.vor=5).or.(vor=7.or.vor=5).and.pprr=0)//.and. gnRoz#1
      ??' dopr='+dtoc(dopr)
      netrepl('dop', 'date()')
    endif

    if (gnEnt=20.and.ktar#556.and.ktasr=556)
      if (tmestor=0)
        ??' tmestor=0'
        sele zensdv
        skip
        loop
      else
        tmesto_r=getfield('t2', 'nkklr,kpvr', 'etm', 'tmesto')
        if (tmesto_r=0)
          ??' tmesto_r=0'
          sele zensdv
          skip
          loop
        endif

        sele rs1
        if (tmesto#tmesto_r)
          tmestor=tmesto_r
          netrepl('tmesto', 'tmestor', 1)
        endif

        if (!netseek('t1', 'ktar,tmestor', 'stagtm'))
        /*            ??' ktar нет в stagtm'
         *            sele zensdv
         *            skip
         *            loop
         */
        endif

      endif

    endif

    if (kplr=20034)
      tarar=0
    else
      ssf12r=getfield('t1', 'Ttnr,12', 'rs3', 'ssf')
      if (ssf12r#0)
        tarar=0
      else
        tarar=1
      endif

    endif

    sele soper
    if (netseek('t1', 'gnD0k1,gnVu,Vor,qr'))
      autor=auto
      nopr=nop
      tcenr=tcen
      pbzenr=pbzen
      ndsr=nds
      pndsr=pnds
      prnnr=prnn
      koppr=kopp
      if (autor=3.or.autor=4.or.autor=1.and.vor=6.and.kopr=189)
        if (koppr=0)
          ??' koppr=0'
          sele zensdv
          skip
          loop
        endif

      endif

      pxzenr=pxzen
      xndsr=xnds
      nofr=nof
      if (autor#0)
        if (autor#4)
          if (sktr#0)
            netuse('cskl')
            if (netseek('t1', 'sktr'))
              gcPath_tt=gcPath_d+alltrim(path)
              if (!file(gcPath_tt+'tprds01.dbf'))
                ??' нет склада sktr'
                sele zensdv
                skip
                loop
              endif

              mskltr=mskl
            else
              ??' нет склада sktr в cskl'
              sele zensdv
              skip
              loop
            endif

          else
            ??' sktr=0'
            sele zensdv
            skip
            loop
          endif

        else
          if (entpr#0)
            sele menent
            locate for ent=entpr
            if (!foun())
              entpr=0
            endif

          endif

          if (entpr=0)
            ??' entpr=0'
            sele zensdv
            skip
            loop
          endif

          sele menent
          commr=comm
          nentpr=uss
          direpr=alltrim(nent)+'\'
          if (commr=0)
            pathemr=gcPath_ini
          else
            pathemr=gcPath_ini+direpr
          endif

          pathepr=pathemr+direpr
          pathecr=pathemr+gcDir_c
          if (sktpr#0)
            pathr=pathecr
            netuse('cskl', 'ecskl',, 1)
            if (netseek('t1', 'sktpr'))
              pathtpr=pathepr+gcDir_g+gcDir_d+alltrim(path)
              if (!file(pathtpr+'tprds01.dbf'))
                ??' нет склада sktpr'
                sele zensdv
                skip
                loop
              endif

              mskltr=mskl
            else
              ??' нет склада sktpr в cskl '
              sele zensdv
              skip
              loop
            endif

            nuse('ecskl')
          else
            ??' sktpr=0'
            sele zensdv
            skip
            loop
          endif

        endif

      endif

    else
      ??' '+str(kopr, 3)+' нет в опер'
      sele zensdv
      skip
      loop
    endif

    sele rs2
    if (netseek('t1', 'Ttnr'))
      exr=0
      cntrs2r=0
      while (TTN = Ttnr)
        mntovr=mntov
        ktlr=ktl
        kvpr=kvp
        zenr=zen
        SELE tov
        netseek('t1', 'sklr,ktlr')
        if (gnVo#4)
          if (OSF-KVPr<0 .and. !gnRoz=1 .and. !gnOst0=1)
            exr=1
            exit
          endif

        endif

        if (zenr=0.and.!(int(ktlr/1000000)=0.or.int(ktlr/1000000)=1))
          exr=1
          exit
        endif

        SELE rs2
        cntrs2r++
        Skip
      enddo

      if (exr = 1)
        ??' нет ост или цена=0'
        sele zensdv
        skip
        loop
      endif

      /***************************************************************
       * Перерасчет
       ***************************************************************
       */
      tbl1r='rs1'
      tbl2r='rs2'
      tbl3r='rs3'
      mDocr='Ttnr'
      fDocr='ttn'
      fKolr='kvp'
      fSumr='svp'
      fprr='pr'
      mprr='prr'
      set cons off
      Tbl3Oper()
      pere(2)
      set cons on
      sele rs3
      if (netseek('t1', 'Ttnr'))
        while (ttn=Ttnr)
          if (ssf=0.and.bssf=0)
            netdel()
          endif

          skip
        enddo

      endif

      SELE RS2
      set orde to tag t1
      if (netseek('t1', 'Ttnr'))
        while (TTN = Ttnr)
          mntovr=mntov
          ktlr=ktl
          kvpr=kvp
          svpr=svp
          srr=sr
          zenr=zen
          kfr=kf
          sfr=sf
          netrepl('sf,kf', 'svpr,kvpr')
          SELE tov
          if (netseek('t1', 'sklr,ktlr'))
            netrepl('osf,dpo', 'osf-kvpr,dotr')
            if (!(vor=9.or.vor=2.or.vor=6.and.(kopr=101.or.kopr=181.or.kopr=198)).and.empty(dopr))
              if (fieldpos('osfo')#0)
                netrepl('osfo', 'osfo-kvpr')
              endif

            endif

            if (gnCtov=1)
              sele tovm
              if (netseek('t1', 'sklr,mntovr'))
                netrepl('osf', 'osf-kvpr')
              endif

              if (!(vor=9.or.vor=2.or.vor=6.and.(kopr=101.or.kopr=181.or.kopr=121.or.kopr=198)).and.empty(dopr))
                if (fieldpos('osfo')#0)
                  netrepl('osfo', 'osfo-kvpr')
                endif

              endif

            endif

            sele tov
            KEIR=KEI
            keurr=keur
            keur1r=keur1
            keur2r=keur2
            keur3r=keur3
            keur4r=keur4
            keuhr=keuh
            do case
            case (month(dotr)>2.and.month(dotr)<6)
              keu_r=keur1r
            case (month(dotr)>5.and.month(dotr)<9)
              keu_r=keur2r
            case (month(dotr)>8.and.month(dotr)<12)
              keu_r=keur3r
            otherwise
              keu_r=keur4r
            endcase

            if (keu_r=0)
              keu_r=keurr
            endif

          endif

          sele rs2
          if (!(vor=9.or.vor=2.or.vor=6.and.(kopr=101.or.kopr=181.or.kopr=121.or.kopr=198)).and.empty(dopr))
            if (fieldpos('prosfo')#0)
              netrepl('prosfo', '1')
            endif

          endif

          netrepl('seu', 'svp*keu_r/100')
          SELE RS2
          Skip
        enddo

      endif

      s92r=0
      sele rs2
      if (netseek('t1', 'Ttnr'))
        while (ttn=Ttnr)
          s92r=s92r+seu
          skip
        enddo

      endif

      sele rs3
      if (netseek('t1', 'Ttnr,92'))
        if (s92r#0)
          netrepl('ssf,ssz', 's92r,s92r')
          if (pbzenr=1)
            netrepl('bssf', 's92r')
          endif

        else
          netdel()
        endif

      else
        if (s92r#0)
          netadd()
          netrepl('ttn,ksz,ssf,ssz', 'Ttnr,92,s92r,s92r')
          if (pbzenr=1)
            netrepl('bssf', 's92r')
          endif

        endif

      endif

      sele rs1
      netrepl('dot,tot', 'dotr,time()', 1)
      if (empty(dop))
        netrepl('dop,top', 'dotr,time()', 1)
      endif

      if (!EMPTY(rs1->dvttn))//удаляем старую аналитику т.к. может изменилась сумма докумета
      else
        rs1->(netrepl('dvttn,tvttn,ktovttn', 'date(),time(),gnKto', 1))
        prModr=1
      endif

      rsprv(2, 1)
      rsprv(1, 0)
      if (autor#0)
        if (autor#4)
          RPRH()
        else
          RPRHP()
        endif

      endif

    endif

    rso(8)
    sele rs1
    netrepl('prz', '1', 1)
    if (rs1->kop=169)
      nndsr=rs1->nnds
      sele nds
      if (!netseek('t3', 'gnSk,rs1->ttn,0'))
        sele setup
        locate for ent=gnEnt
        reclock()
        nndsr=nnds
        netrepl('nnds', 'nnds+1')
        sele nds
        netadd()
        netrepl('nomnds,kkl,sk,ttn,sum,dnn,d0k1,rmsk',                ;
                 'nndsr,kplr,gnSk,rs1->ttn,rs1->sdv,rs1->dot,0,gnRmsk' ;
              )
      else
        netrepl('nomnds,kkl,sk,ttn,sum,dnn,d0k1,rmsk',                ;
                 'nndsr,kplr,gnSk,rs1->ttn,rs1->sdv,rs1->dot,0,gnRmsk' ;
              )
      endif

      sele rs1
      netrepl('nnds', 'nndsr', 1)
    endif

    prModr=1
    if (fieldpos('krspo')#0)
      netrepl('krspo,krspb,krspnb,krsp', '0,0,0,0', 1)
    endif

    netrepl('dtmod,tmmod', 'date(),time()', 1)
    ??'Ok'
    sele zensdv
    skip
  enddo

  sele zensdv
  CLOSE
  nuse()
  set prin off
  set prin to txt.txt
  gnScout=0
  return (.t.)
