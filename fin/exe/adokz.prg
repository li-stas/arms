/***********************************************************
 * Модуль    : adokz.prg
 * Версия    : 0.0
 * Автор     :
 * Дата      : 05/02/19
 * Изменен   :
 * Примечание: Текст обработан утилитой CF версии 2.02
 */

#include "common.ch"
#include "inkey.ch"
/*
procedure adokz(p1)
*/
para p1
/*Касса,Банк,Все */
netUse('tov')
netUse('cgrp')
netUse('dokz')
netUse('doks')
netUse('banks')
netUse('pbanks')
netUse('mfochk')
netUse('kklrs')
netUse('rmsk')
netuse('dokk')
netuse('dokko')
netuse('dokkz')
netUse('s_tag')
netUse('cskl')
netUse('kln')
netUse('operb')
netUse('bs')
netUse('dkkln')
netUse('dknap')
netUse('dkklns')
netUse('dkklna')
netUse('tipd')
netuse('podr')
netuse('tmesto')
netuse('kplkgp')
netuse('s_tag')
netuse('kpl')
netuse('kassa')
netuse('kassae')
netuse('moddoc')
netuse('mdall')
netuse('nap')
netuse('ktanap')
netuse('vdnal')
netuse('vdnaln')
netuse('nnds')
netuse('cntm')
netuse('ctov')
netuse('kspovo')
netuse('dclr')

set color to g/n, n/g,,,

store 0 to bsr, sklr, mnr, rndr, rnr, bs_dr, bs_kr, bs_sr, kklr, sumdr, sumkr, ;
 knsdr, knskr, tipor, kopr, przr, ktar, prFrmr, nchekr, prukrsibr
store '' to nklr, nopr, ndokr
store gdTd to ddcr, ddkr

clea

while (.t.)
  if (gnEntrm=1.or.gnEntrm=0.and.bsr=301001).and.lastkey()=K_ESC
    exit
  endif

  clea
  @ 0, 1 say gcName_c color 'bg+/n'
  if (gnEntrm=0)
    do case
    case (p1=1)           // Касса
      store 0 to bsr
      @ 1, 1 say 'Счет' get bsr pict '999999' valid bsbank(1)
      read
      if (lastkey()=K_ESC)
        exit
      endif

    case (p1=2)           // Банк
      store 0 to bsr
      @ 1, 1 say 'Счет' get bsr pict '999999' valid bsbank(2)
      read
      if (lastkey()=K_ESC)
        exit
      endif

    case (p1=3)           // Остальные
      store 0 to bsr
      @ 1, 1 say 'Счет' get bsr pict '999999' valid bsbank(3)
      read
      if (lastkey()=K_ESC)
        exit
      endif

    endcase

  else
    bsr=gnRmbs
  endif

  prrmbsr=0
  if (gnEntrm=0)
    sele rmsk
    locate for rmbs=bsr
    if (foun())
      prrmbsr=1
    endif

  endif

  sele bs
  if (netseek('t1', 'bsr'))
    nbsr=nbs
    tipor=tipo
    if (tipor=0)
      wmess('Нет признака разработки этого счета', 3)
      loop
    endif

  else
    wmess('Нет счета в справочнике', 3)
    if (gnEntrm=0)
      loop
    else
      exit
    endif

  endif

  @ 1, 1 say 'Счет '+str(bsr, 6)+' '+nbsr color 'gr+/n'

  sele dokz
  set orde to tag t1
  if (!netseek('t1', 'bsr'))
    go top
  endif

  rcdokzr=recn()

  while (.t.)
    sele dokz
    set orde to tag t1
    go rcdokzr
    store 0 to mnr, sumdr, sumkr, knsdr, knskr
    if (int(bsr/1000)=301)
      foot('INS,DEL,F4,F5,F6,F7', 'Добавить,Удалить,Коррекция,ОтчетК,Xотч,Zотч')
    else
      foot('INS,DEL,F4', 'Добавить,Удалить,Коррекция')
    endif

    rcdokzr=slcf('dokz',,,,, "e:ddc  h:'Дата' c:d(10) e:sumd h:'Дебет' c:n(10,2) e:sumk h:'Кредит' c:n(10,2) e:knsd h:'Дебет К' c:n(10,2) e:knsk h:'Кредит К' c:n(10,2) e:mn   h:'Маш.N' c:n(6)",,,,, 'bs=bsr',, 'Числа месяца')
    if (lastkey()=K_ESC)
      exit
    endif

    sele dokz
    go rcdokzr
    if (!eof())
      bsr=bs
      mnr=mn
      ddcr=ddc
    endif

    sumdr=sumd
    sumkr=sumk
    knsdr=knsd
    knskr=knsk
    do case
    case (lastkey()=13)   // Выбор
      if (eof())
        wmess('Нет чисел месяца', 3)
        loop
      endif

      sumd_r=asum(0, mnr)
      sumk_r=asum(1, mnr)
      if (sumdr#sumd_r)
        netrepl('sumd', 'sumd_r')
        sumdr=sumd_r
      endif

      if (sumkr#sumk_r)
        netrepl('sumk', 'sumk_r')
        sumkr=sumk_r
      endif

      @ 2, 1 say 'Маш.N '+str(mnr, 6)+' от '+dtoc(ddcr)+space(10)
      @ 0, 40 say 'K.Дебет'+str(knsdr, 10, 2) + space(3)+'K.Кредит'+str(knskr, 10, 2)
      @ 1, 40 say '  Дебет'+str(sumdr, 10, 2) + space(3)+'  Кредит'+str(sumkr, 10, 2)
      adoks()
      @ 2, 0 clea
    case (lastkey()=K_INS.and.prrmbsr=0.and.prdp())// Добавить
      adokzins(0)
    case (lastkey()=7.and.prrmbsr=0.and.prdp().and..f.)// Удалить
      apcen:={ 'НЕТ', 'ДА' }
      vdel:=alert('Удаление записи!!!', apcen)
      if (vdel=2)
        sele dokk
        set orde to tag t1
        if (netseek('t1', 'mnr'))
          while (mn=mnr)
            sele dokk
            if (!(prc.or.bs_d=0.or.bs_k=0))
              docmod('уд', 1)
              mdall('уд', 1)
              sele dokk
              msk(0, 0)
            endif

            sele dokk
            netdel()
            skip
          enddo

        endif

        sele doks
        set orde to tag t1
        if (netseek('t1', 'mnr'))
          while (mn=mnr)
            netrepl('ssd', '0')
            skip
          enddo

        endif

        sele dokz
        netrepl('sumd,sumk', '0,0')
      endif

    case (lastkey()=K_F4) // Коррекция
      adokzins(1)
    case (lastkey()=-4.and.int(bsr/1000)=301)// Отчет касса
      ksotch()
    case (lastkey()=-5.and.int(bsr/1000)=301)// X отчет
#ifdef __CLIP__
/*                if MariaQ(gaKassa:nConnect, gaKassa:scCashMen, gaKassa:MRA_PASSWD, gaKassa:snTimeOut,;
 *                        gaKassa:Host, gaKassa:Ports, 1)
 *                   xzot(1)
 *                endif
 */
#else
        xzot(1)
#endif
    case (lastkey()=-6.and.int(bsr/1000)=301)// Z отчет
#ifdef __CLIP__
/*                if MariaQ(gaKassa:nConnect, gaKassa:scCashMen, gaKassa:MRA_PASSWD, gaKassa:snTimeOut,;
 *                        gaKassa:Host, gaKassa:Ports, 2)
 *                   xzot(2)
 *                endif
 */
#else
        xzot(2)
#endif
    case (lastkey()=K_ESC)// Выход
      exit
    otherwise
      loop
    endcase

  enddo

enddo

nuse()
return

/****************** */
function adokzins(p1)
  /****************** */
  if (p1=0)
    if (prrmbsr=0.and.prdp())
      ddcr=gdTd
      store 0 to sumdr, sumkr, knsdr, knskr, mnr
    else
      return (.f.)
    endif

  endif

  cldokz=setcolor('n/w,n/bg')
  prautor=0
  prautorr=0
  pathbnr=space(30)
  fbanksr=space(12)
  kobr=''
  ckobr=alltrim(kobr)

  sele mfochk
  ordsetfocus('t1')
  if (netseek('t1', 'gnKln_c,bsr'))
    xKeySeek:=NetKeySeek('t1', 'kkl8,bs')
    // найдем не помеченные * те активные
    locate for left(NChk, 1) # "*" while xKeySeek = NetKeySeek('t1', 'kkl8,bs')

    kobr=mfo
    ckobr=alltrim(kobr)
    dirbnnr=alltrim(pathbn)
    fbanksr=alltrim(fbanks)
#ifdef __CLIP__
      ckobr='b'+ckobr
#else
      bckobr='d'+ckobr
      ckobr='b'+ckobr
#endif
    direr=dirbnnr+alltrim(gcNent)
    dirbnsr=dirbnnr+alltrim(gcNent)+'\banks'
    pathbnsr=dirbnnr+alltrim(gcNent)+'\banks\'
    dirbnr=dirbnnr+alltrim(gcNent)+'\banks\'+ckobr
    pathbnr=dirbnnr+alltrim(gcNent)+'\banks\'+ckobr+'\'
#ifdef __CLIP__
      ldirbnnr:=set(upper(subs(dirbnnr, 1, 2)))+'/'
      lpathbnr=ldirbnnr+alltrim(gcNent)+'/banks/'+ckobr+'/'
      fbatr=lpathbnr+ckobr+'.bat'
#else
      fbatr=pathbnr+bckobr+'.bat'
#endif

    if (dirchange(direr)<0)
      dirmake(direr)
    endif

    if (dirchange(dirbnsr)<0)
      dirmake(dirbnsr)
    endif

    if (dirchange(dirbnr)<0)
      dirmake(dirbnr)
    endif

    dirchange(gcPath_l)

    prautor=1
  endif

  wdokz=wopen(5, 5, 11, 75)
  wbox(1)
  while (.t.)
    if (p1=0.and.prrmbsr=0.and.prdp())
      @ 0, 1 say 'Маш.номер  '+str(mnr, 6)+' Дата ' get ddcr valid addc()
    else
      @ 0, 1 say 'Маш.номер  '+str(mnr, 6)+' Дата '+dtoc(ddcr)
    endif

    @ 1, 1 say 'Путь'+' '+pathbnr+' запуск '+ckobr+'.bat'
    fposr=col()+1
    @ 1, col()+1 say 'Файл'+' '+fbanksr
    if (p1=0.and.prrmbsr=0.and.prdp())
      read
      if (lastkey()=K_ESC)
        go rcdokzr
        exit
      endif

    else
    endif

    prUkrsibr=1
    if (kobr='351005'.or.kobr='380009')
      aqst:={ "Старый", "Новый" }
      prUkrsibr:=alert("Выбор", aqst)
      if (lastkey()=K_ESC.or.!prdp())
        prautor=0
      endif

    endif

    if (prUkrsibr=2)
      do case
      case (kobr='337483')
        aaa=dtos(ddcr)
        favalr='v'+subs(aaa, 3, 6)+'.zzz'
      case (kobr='351005'.or.kobr='380009')
        fukrsibr='export.dbf'
#ifdef __CLIP__
          fbatr=lpathbnr+'n'+kobr+'.bat'
#else
          fbatr=pathbnr+'k'+kobr+'.bat'
#endif
      endcase

    else
      do case
      case (kobr='337483')
        aaa=dtos(ddcr)
        favalr='v'+subs(aaa, 3, 6)+'.zzz'
      case (kobr='351005'.or.kobr='380009')
        aaa=dtos(ddcr)
        fukrsibr=subs(aaa, 7, 2)+subs(aaa, 5, 2)+subs(aaa, 1, 4)+'.dbf'
      endcase

    endif

    @ 1, fposr say 'Файл'+' '+fbanksr
    if (prrmbsr=0.and.prdp().and.p1=1)
      if (prautor=1)
        aqstr=1
        aqst:={ "Загрузить",'Повторить',"Отмена" }
        aqstr:=alert("Выписка", aqst)
        if (lastkey()=K_ESC.or.aqstr=len(aqst).or.!prdp())
          prautor=0
        endif

        save scre to scbat
        flr=alltrim(pathbnr)+alltrim(fbanksr)
#ifdef __CLIP__
          If aqstr=1
            erase (flr)
          EndIf
          do case
          case (kobr='337483')
            run (fbatr+' '+favalr)
          case (kobr='351005'.or.kobr='380009')
            run (fbatr+' '+fukrsibr)
          otherwise
            run (fbatr)
          endcase

#endif
        set cons off
        set prin to btxt.txt
        set prin on
        ?fbatr
        set prin off
        set prin to
        set cons on
        rest scre from scbat
      endif

      if (file('tbank.dbf'))
        erase tbank.dbf
        erase tbank.cdx
      endif

      if (prautor=1)
        wselect(0)
        pbanks()
        wselect(wdokz)
      endif

      if (prautor=0)
        erase tbank.dbf
        erase tbank.cdx
      endif

      knsd_r=0
      knsk_r=0
      if (file('tbank.dbf'))//.and.gnAdm=1
        aqstr=1
        aqst:={ "Да", "Отмена" }
        aqstr:=alert("Создать документы?", aqst)
        if (aqstr=1.and.prdp().and.prrmbsr=0)
          if (p1=1)
            sele doks
            set orde to tag t3
            if (netseek('t3', '1,mnr'))
              while (auto=1.and.mn=mnr)
                rndr=rnd
                kklr=kkl
                sele dokk
                if (netseek('t1', 'mnr,rndr,kklr'))
                  while (mn=mnr.and.rnd=rndr.and.kkl=kklr)
                    docmod('уд', 1)
                    mdall('уд', 1)
                    netdel()
                    skip
                  enddo

                endif

                sele doks
                netdel()
                skip
              enddo

            endif

          endif

          sele 0
          use tbank
          set orde to tag t1
          go top
          rndr=1
          while (!eof())
            tipr=tip
            przr=getfield('t1', 'tipor,tipr', 'tipd', 'prz')
            knsdr=knsd
            knskr=knsk
            nplpr=nplp
            ssdr=ssd
            bosnr=osn
            cnplpr=cnplp
            do case
            case (tipr=0)
            /*                       sele dokz
             *                       netrepl('knsd,knsk','knsdr,knskr',1)
             */
            case (tipr=1)
              kklr=dkkl
              knsd_r=knsd_r+ssdr
            case (tipr=3)
              kklr=kkkl
              knsk_r=knsk_r+ssdr
            endcase

            sele doks
            if (tipr#0)
              while (.t.)
                if (netseek('t1', 'mnr,rndr'))
                  rndr=rndr+1
                else
                  exit
                endif

              enddo

              netadd()
              netrepl('mn,rnd', 'mnr,rndr')
              netrepl('kkl,nplp,ddc,ssd,tipo,tip,prz,kto,bosn,auto,prz',        ;
                       'kklr,nplpr,ddcr,ssdr,tipor,tipr,przr,gnKto,bosnr,1,przr' ;
                    )
              if (fieldpos('cnplp')#0)
                netrepl('cnplp', 'cnplpr')
              endif

              rcdoksr=recn()
            endif

            rndr=rndr+1
            sele tbank
            skip
          enddo

          sele doks
          set orde to tag t1
          if (knsdr=0.and.knsd_r#0)
            knsdr=knsd_r
          endif

          if (knskr=0.and.knsk_r#0)
            knskr=knsk_r
          endif

          sele tbank
          CLOSE
          erase tbank.dbf
        endif

      endif

    endif

    if (prrmbsr=0.and.prdp())
      @ 2, 1 say 'К.Дебет    ' get knsdr pict '9999999.99'
      @ 3, 1 say 'К.Кредит   ' get knskr pict '9999999.99'
      read
      if (lastkey()=K_ESC)
        exit
      endif

    else
      @ 2, 1 say 'К.Дебет    '+' '+str(knsdr, 12, 2)
      @ 3, 1 say 'К.Кредит   '+' '+str(knskr, 12, 2)
    endif

    @ 4, 1 prom 'Верно'
    @ 4, col()+1 prom 'Не верно'
    menu to mdokz
    if (lastkey()=K_ESC.or.!prdp().or.prrmbsr=1)
      sele dokz
      go rcdokzr
      exit
    endif

    if (mdokz=1)
      sele dokz
      if (p1=0)
        sele setup
        locate for ent=gnEnt
        reclock()
        mnr=dokzmn
        while (.t.)
          if (netseek('t2', 'mnr', 'dokz'))
            mnr=mnr+1
          else
            exit
          endif

        enddo

        netrepl('dokzmn', 'mnr+1')
      endif

      sele dokz
      if (!netseek('t2', 'mnr'))
        netadd()
        netrepl('bs,mn,ddc,knsd,knsk', 'bsr,mnr,ddcr,knsdr,knskr', 1)
        rcdokzr=recn()
      else
        netrepl('knsd,knsk', 'knsdr,knskr', 1)
      endif

      exit
    endif

  enddo

  wclose(wdokz)
  setcolor(cldokz)
  return (.t.)

/********* */
function addc()
  /********* */
  sele dokz
  if (bom(ddcr)#bom(gdTd))
    wmess('Неверная дата', 1)
    return (.f.)
  endif

  if (netseek('t1', 'bsr,ddcr'))
    wmess('Отчет с этой датой существует', 1)
    return (.f.)
  endif

  return (.t.)

/**************** */
function bsbank(p1)
  /**************** */
  if (bsr#0)
    do case
    case (p1=1)
      if (int(bsr/1000)#301)
        bsr=0
      else
        if (!netseek('t1', 'bsr', 'bs'))
          bsr=0
        else
          tipor=getfield('t1', 'bsr', 'bs', 'tipo')
        endif

      endif

    case (p1=2)
      if (int(bsr/1000)#311)
        bsr=0
      else
        if (!netseek('t1', 'bsr', 'bs'))
          bsr=0
        else
          tipor=getfield('t1', 'bsr', 'bs', 'tipo')
        endif

      endif

    case (p1=3)
      if (int(bsr/1000)=311.or.int(bsr/1000)=301)
        bsr=0
      else
        if (!netseek('t1', 'bsr', 'bs'))
          bsr=0
        else
          tipor=getfield('t1', 'bsr', 'bs', 'tipo')
        endif

      endif

    endcase

  endif

  if (bsr=0)
    sele bs
    go top
    rcbsr=recn()
    do case
    case (p1=1)
      rcbsr=slcf('bs',,,,, "e:bs h:'Счет' c:n(6) e:nbs h:'Наименование' c:c(20)",,,,, 'int(bs/1000)=301',, 'Касса')
    case (p1=2)
      rcbsr=slcf('bs',,,,, "e:bs h:'Счет' c:n(6) e:nbs h:'Наименование' c:c(20)",,,,, 'int(bs/1000)=311',, 'Банк')
    case (p1=3)
      rcbsr=slcf('bs',,,,, "e:bs h:'Счет' c:n(6) e:nbs h:'Наименование' c:c(20)",,,,,,, 'Счета')
    endcase

    if (lastkey()=K_ESC)
      bsr=0
      return (.f.)
    endif

    go rcbsr
    bsr=bs
    tipor=tipo
  endif

  return (.t.)

/************** */
function aklnflt()
  /************** */
  local getlist:={}
  txtr=space(30)
  wkln=wopen(8, 15, 10, 65)
  wbox(1)
  @ 0, 1 say 'Контекст' get txtr
  read
  if (lastkey()=13)
    txtr=upper(alltrim(txtr))
    if (empty(txtr))
      forklnr=forkln_r
    else
      forklnr=forkln_r+'.and.at(txtr,upper(kln->nkl))#0'
    endif

  else
    forklnr=forkln_r
  endif

  sele kln
  go top
  rcklnr=recn()
  wclose(wkln)
  wselect(0)
  return (.t.)
