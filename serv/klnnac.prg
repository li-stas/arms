/* Наценки по брендам */
clea
netuse('kobl')
netuse('kfs')
netuse('opfh')
netuse('knasp')
netuse('kgos')
netuse('kulc')
netuse('krn')
netuse('banks')

netuse('brand')
netuse('brnac')
netuse('mnnac')

netuse('kpl')
netuse('nap')
netuse('kplnap')
netuse('kplnp')
netuse('ktanap')
netuse('klndog')
netuse('tara')
netuse('atvm')
netuse('mkeep')
netuse('mkeepe')
netuse('cskl')
netuse('ctov')
set orde to tag t6
netuse('cgrp')
netuse('kgp')
netuse('kln')
rccr=recc()
netuse('klnnac')
netuse('tcen')

netuse('s_tag')
netuse('stagtm')
netuse('etm')

netuse('kplid')
netuse('kplidx')

netuse('chst')

store '' to nkkl_r, nkkl1_r, crmsk_r, nkpl_r, nkpl1_r, nseal_r
store 0 to izg_r, prnacr, nac_r, kop_r, tzdoc_r, seal_r
for_r=".t."                 // Плательщики
forr=for_r
sele klnnac
go top
while (!eof())
  kplr=kkl
  if (!netseek('t1', 'kplr', 'kpl'))
    sele klnnac
    netdel()
    skip
    loop
  endif

  sele klnnac
  skip
enddo

sele kpl
go top
rckplr=recn()
fldnomr=1
prf1r=0
while (.t.)
  sele kpl
  go rckplr
  if (prf1r=0)
    if (gnAdm=1)
      foot('ENTER,F2,F3,F4,F5,F6,F7,F8,F9,F10', 'Нац,Коп,Флт,Корр,Обн,Обн выбр.,Обн РП,Обн KOP,Уст ск,Br')
    else
      foot('ENTER,F2,F3,F4,F6,F9,F10', 'Нац,Коп,Флт,Корр,Обн выбр,Уст ск,Br')
    endif

  else
    if (gnEnt=21)
      foota('F2,F3,F4,F5,F7,F8,F9,F10', 'ОбнАг,Кросс,Корр KLN,FNAC,ДзТов,ДзТар,Обн из KLN,CGBM')
    else
      /*         foota('F2,F3,F4,F5,F7,F8,F9,F10','Напр,Напр%,Корр KLN,FNAC,ДзТов,ДзТар,Обн из KLN,CGBM') */
      foota('F2,F3,F4,F5,F7,F8,F9,F10', 'Напр,Напр%,Корр KLN,FNAC,ДзТов,ДзТар,ГрПол,CGBM')
    endif

  endif

  set cent off
  /*   rckplr=slcf('kpl',1,1,18,,"e:kpl h:'Код' c:n(7) e:getfield('t1','kpl->kpl','kln','nkl') h:'Наименование' c:c(28) e:crmsk h:'ССРКШA' c:c(6) e:getfield('t1','kpl->kpl','klndog','ndog') h:'N Дог.' c:n(6) e:getfield('t1','kpl->kpl','klndog','dtdogb') h:'ДатаН' c:d(8) e:getfield('t1','kpl->kpl','klndog','dtdoge') h:'ДатаО' c:d(8) e:getfield('t1','kpl->kpl','tara','ddog') h:'ДатаТ' c:d(8)",,,1,,forr,,'Плательщики') */
  rckplr=slce('kpl', 1, 1, 18,, "e:kpl h:'Код' c:n(7) e:getfield('t1','kpl->kpl','kln','nkl') h:'Наименование' c:c(28) e:crmsk h:'ССРКШA' c:c(6) e:getfield('t1','kpl->kpl','klndog','ndog') h:'N Дог.' c:n(6) e:getfield('t1','kpl->kpl','klndog','dtdogb') h:'ДатаН' c:d(8) e:getfield('t1','kpl->kpl','klndog','dtdoge') h:'ДатаО' c:d(8) e:getfield('t1','kpl->kpl','tara','ddog') h:'ДатаТ' c:d(8) e:kta h:'Kta' c:n(4) e:getfield('t1','kpl->kta','s_tag','fio') h:'Агент' c:c(15)",,, 1,, forr,, 'Плательщики', 1, 2)
  set cent on
  if (lastkey()=27)
    exit
  endif

  sele kpl
  go rckplr
  kplr=kpl
  nkplr=getfield('t1', 'kpl->kpl', 'kln', 'nkl')
  sele klndog
  if (netseek('t1', 'kplr'))
    ndogr=ndog
    dtdogbr=dtdogb
    dtdoger=dtdoge
    if (fieldpos('kdopl')#0)
      kdoplr=kdopl
    else
      kdoplr=7
    endif

    if (fieldpos('cndog')#0)
      cndogr=cndog
    else
      cndogr=space(20)
    endif

  else
    ndogr=0
    cndogr=space(20)
    dtdogbr=ctod('')
    dtdoger=ctod('')
    kdoplr=7
  endif

  ddogr=getfield('t1', 'kpl->kpl', 'tara', 'ddog')
  sele kpl
  crmskr=crmsk
  codelistr=subs(codelist, 1, 70)
  pricetypesr=subs(pricetypes, 1, 70)

  chstr=chst
  nchstr=getfield('t1', 'chstr', 'chst', 'nchst')

  /*   prir=pri */
  ktar=kta
  nktar=getfield('t1', 'ktar', 's_tag', 'fio')
  pstr=pst
  skidr=skid
  dtnacbr=dtnacb
  dtnacer=dtnace
  prsvr=prsv
  dtsvr=dtsv
  prmzenr=prmzen
  nacr=nac
  nac1r=nac1
  prksz61r=prksz61
  smksz61r=smksz61
  prksz46r=prksz46
  smksz46r=smksz46
  ksz46r=ksz46
  nodebr=nodeb
  tzdocr=tzdoc
  dzr=dz
  dtdzr=dtdz
  naclr=nacl
  sealr=seal
  pr1ndsr=pr1nds
  if (fieldpos('prskpd')#0)
    prskpdr=prskpd
  else
    prskpdr=0
  endif

  /*   nsealr=getfield('t1','sealr','seal','nseal') */
  sele kln
  netseek('t1', 'kplr')
  kkl1r=kkl1
  nklr=alltrim(nkl)
  adrr=adr
  tlfr=tlf
  kb1r=kb1
  nmfo1r=getfield('t1', 'kb1r', 'banks', 'otb')
  kb2r=kb2
  nmfo2r=getfield('t1', 'kb2r', 'banks', 'otb')
  ns1r=ns1
  ns2r=ns2
  ns1ndsr=ns1nds
  ns2ndsr=ns2nds
  nnr=nn
  rstr=rst
  nsvr=nsv
  sele kpl
  do case
  case (lastkey()=19)     // Left
    fldnomr=fldnomr-1
    if (fldnomr=0)
      fldnomr=1
    endif

  case (lastkey()=4)      // Right
    fldnomr=fldnomr+1
  case (lastkey()=28)     // F1
    if (prf1r=0)
      prf1r=1
    else
      prf1r=0
    endif

  case (lastkey()=13.and.iif(gnEnt=21, str(gnKto, 3)$'129;786'.or.gnAdm=1, .t.))// Наценки
    nackpl()
  case (lastkey()=-2)     // Фильтр
    kplflt()
  case (lastkey()=-3)     // Коррекция
    kplins(1)
  case (lastkey()=22)     // INS
    kplins()
  case (lastkey()=-33)    // Коррекция KLN
    sele kln
    if (netseek('t1', 'kplr'))
      klnins(1)
    endif

  case (lastkey()=-4 .and.gnAdm=1)// Обновить Всех
    obnkln()
  case (lastkey()=-5)             //.and.gnAdm=1// Обновить
    obnkln(1)
  case (lastkey()=-6 .and.gnAdm=1)// Обновить РП
    obnap()
  case (lastkey()=-7 .and.gnAdm=1)// Обновить KOP
    obkop()
  case (lastkey()=-8)             // Уст ск
    setskid()
  case (lastkey()=-38)            //.and.gnAdm=1 // Обновить из KLN
    /*           obkln() */
    kpltt()                         //  s_krn.prg Троговые точки(грузополучатели)
  case (lastkey()=-1)             // Копировать скидки по изг
    cpizg()
  case (lastkey()=-31)            // Направления
    kplnap()
  case (lastkey()=-32)
    if (gnEnt=20.and.(gnAdm=1.or.gnKto=117.or.gnKto=160.or.gnKto=782.or.gnKto=848))// Направления%
      kplnp()
    endif

    if (gnEnt=21)
      kplid()
    endif

  case (lastkey()=-34)    // nacenka
    sknc()
  case (lastkey()=-36)    // ДзТов
    dztv(1)
  case (lastkey()=-37)    // ДзТар
    dztv(2)
  case (lastkey()=-9)
    nacm()
  case (lastkey()=-39)    // CGBM
    cgbm()
  endcase

enddo

nuse()

/************** */
function nackpl()
  /************** */
  save scree to scnacbr
  sele klnnac
  if (netseek('t1', 'kplr'))
    rcklnnacr=recn()
  else
    go top
    rcklnnacr=recn()
  endif

  whlklnr='kkl=kplr'
  forklnr='.t.'
  fldnomr=1
  while (.t.)
    foot('F3,F4', 'Фильтр,Коррекция')
    sele klnnac
    go rcklnnacr
    if (fieldpos('kdopl')=0)
      rcklnnacr=slce('klnnac', 5, 1,,, "e:izg h:'Изг' c:n(7) e:fnmkeep() h:'MK' c:c(20) e:kg h:'Гр' c:n(3) e:nac h:'Нац1' c:n(6,2) e:nac1 h:'Нац2' c:n(6,2) e:minzen1 h:'M' c:n(1) e:tcen h:'ТЦ' c:n(2) e:ftxt h:'Основание' c:c(20)",,, 1, whlklnr, forklnr,, alltrim(nkplr))
    else
      rcklnnacr=slce('klnnac', 5, 1,,, "e:izg h:'Изг' c:n(7) e:fnmkeep() h:'MK' c:c(20) e:kg h:'Гр' c:n(3) e:nac h:'Нац1' c:n(6,2) e:nac1 h:'Нац2' c:n(6,2) e:minzen1 h:'M' c:n(1) e:tcen h:'ТЦ' c:n(2) e:ftxt h:'Основание' c:c(20) e:kdopl h:'Опл' c:n(3)",,, 1, whlklnr, forklnr,, alltrim(nkplr))
    endif

    if (lastkey()=27)
      exit
    endif

    go rcklnnacr
    izgr=izg
    kgr=kg
    nacr=nac
    nac1r=nac1
    minzen1r=minzen1
    ftxtr=ftxt
    tcenr=tcen
    if (fieldpos('kdopl')=0)
      kdoplr=0
    else
      kdoplr=kdopl
    endif

    do case
    case (lastkey()=19)   // Left
      fldnomr=fldnomr-1
      if (fldnomr=0)
        fldnomr=1
      endif

    case (lastkey()=4)    // Right
      fldnomr=fldnomr+1
    case (lastkey()=-2)   // Фильтр
      nacflt()
    case (lastkey()=-3)   // Коррекция
      klnnacins()
    endcase

  enddo

  rest scree from scnacbr
  return (.t.)

/***********************************************************
 * fnmkeep() -->
 *   Параметры :
 *   Возвращает:
 */
function fnmkeep()
  local cmkeepr
  mkeepr=getfield('t2', 'klnnac->izg', 'mkeepe', 'mkeep')
  nmkeepr=getfield('t1', 'mkeepr', 'mkeep', 'nmkeep')
  return (nmkeepr)

/**************** */
function obnkln(p1)
  /**************** */
  if (empty(p1))
    save scre to scobnbr
    @ 1, 70 say str(rccr, 8)
    sele kpl
    go top
    kklr=0
    rcc_r=0
    while (!eof())
      rcc_r=rcc_r+1
      @ 2, 70 say str(rcc_r, 8)
      kklr=kpl
      kkl1r=getfield('t1', 'kklr', 'kln', 'kkl1')
      if (kkl1r=0)
        sele klnnac
        if (netseek('t1', 'kklr'))
          while (kkl=kklr)
            netdel()
            skip
          enddo

        endif

        sele kpl
        netdel()
        skip
        loop
      endif

      obnac()
      sele kpl
      /*      if getfield('t1','kpl->kpl,3332458,999','klnnac','nac')=0.5
       *         sele kpl
       *         if empty(dtnacb)
       *            netrepl('dtnacb','date()')
       *         endif
       *         netrepl('dtnace','ctod("31.12.2008")')
       *      endif
       *      if getfield('t1','kpl->kpl,3195932,999','klnnac','nac')=0.5
       *         sele kpl
       *         if empty(dtnacb)
       *            netrepl('dtnacb','date()')
       *         endif
       *         netrepl('dtnace','ctod("31.12.2008")')
       *      endif
       */
      skip
    enddo

    rest scre from scobnbr
  else
    save scre to scobnbr
    mess('Ждите...')
    kklr=kpl
    kkl1r=getfield('t1', 'kklr', 'kln', 'kkl1')
    if (kkl1r=0)
      wmess('Нет кода ОКПО', 1)
      sele klnnac
      if (netseek('t1', 'kklr'))
        while (kkl=kklr)
          netdel()
          skip
        enddo

      endif

      sele kpl
      netdel()
      skip -1
    else
      obnac()
    endif

    rest scre from scobnbr
  endif

  return (.t.)

/************** */
function obnac()
  /************** */
  sele mkeep
  go top
  while (!eof())
    if (mkeep=0)
      skip
      loop
    endif

    if (gnEnt=20)
      if (lv20=0)
        skip
        loop
      endif

    endif

    mkeepr=mkeep
    sele ctov
    if (netseek('t6', 'mkeepr'))
      while (mkeep=mkeepr)
        if (izg=0)
          skip
          loop
        endif

        izgr=izg
        if (!netseek('t1', 'mkeepr,izgr', 'mkeepe'))
          sele ctov
          skip
          loop
        endif

        /*         if izgr=3332458.or.izgr=3195932
         *            store 0.5 to nac_r,nac1_r
         *         else
         *            store 0 to nac_r,nac1_r
         *         endif
         */
        kgr=int(mntov/10000)
        if (kgr<2)
          skip
          loop
        endif

        sele klnnac
        if (!netseek('t1', 'kklr,izgr,kgr'))
          netadd()
          netrepl('kkl,izg,kg', 'kklr,izgr,kgr')
        /*             if mkeepr#1
         *                netrepl('kkl,izg,kg','kklr,izgr,kgr')
         *             else
         *                ftxtr='доб'
         *                netrepl('kkl,izg,kg,ftxt','kklr,izgr,kgr,ftxtr')
         *             endif
         */
        endif

        /*          if mkeepr=1.and.(izgr=3195932.and.kgr=505.or.izgr=3332458.and.(kgr=251.or.kgr=505.or.kgr=506))
         *             if nac=0.and.nac1=0
         *                ftxtr=alltrim(ftxt)+' 1%'
         *                netrepl('nac,nac1,ftxt','1,1,ftxtr')
         *             endif
         *          endif
         */
        if (!netseek('t1', 'kklr,izgr,999'))
          netadd()
          netrepl('kkl,izg,kg', 'kklr,izgr,999')
        /*             netrepl('nac,nac1','nac_r,nac1_r') */
        else
        /*             if tcen=0.and.nac=0
         *                netrepl('nac,nac1','nac_r,nac1_r')
         *             endif
         */
        endif

        sele ctov
        skip
      enddo

    endif

    sele mkeep
    skip
  enddo

  sele klnnac
  if (netseek('t1', 'kklr'))
    while (kkl=kklr)
      izgr=izg
      mkeepr=getfield('t2', 'izgr', 'mkeepe', 'mkeep')
      sele ctov
      if (!netseek('t6', 'mkeepr'))
        sele klnnac
        netdel()
        skip
        loop
      endif

      sele klnnac
      skip
    enddo

  endif

  return (.t.)

/****************** */
function klnnacins()
  /****************** */
  scbrir=setcolor('gr+/b,n/w')
  wbrir=wopen(8, 10, 15, 70)
  wbox(1)
  @ 0, 1 say 'Наценка1        ' get nacr pict '999.99'
  @ 1, 1 say 'Наценка2        ' get nac1r pict '999.99'
  @ 2, 1 say 'Пров.на мин цену' get minzen1r pict '9'
  @ 3, 1 say 'VIP прайс       ' get tcenr pict '99'
  @ 4, 1 say 'Основание       ' get ftxtr
  @ 5, 1 say 'К-во дн отсрочки' get kdoplr
  read
  if (lastkey()=13)
    sele klnnac
    netrepl('nac,nac1,minzen1,ftxt,tcen', 'nacr,nac1r,minzen1r,ftxtr,tcenr')
    if (fieldpos('kdopl')#0)
      netrepl('kdopl', 'kdoplr')
    endif

  endif

  wclose(wbrir)
  setcolor(scbrir)
  return (.t.)

/*************** */
function nacflt()
  /*************** */
  scfltr=setcolor('gr+/b,n/w')
  wfltr=wopen(8, 10, 12, 70)
  wbox(1)
  izg_r=0
  nac_r=0
  @ 0, 1 say 'Изготовитель' get izg_r pict '9999999'
  @ 1, 1 say 'Все-0;Нац-1 ' get nac_r pict '9'
  read
  if (izg_r#0)
    forklnr='.t..and.izg=izg_r'
  else
    forklnr='.t.'
  endif

  if (nac_r#0)
    forklnr=forklnr+'.and.(nac#0.or.nac1#0)'
  endif

  sele klnnac
  if (netseek('t1', 'kplr'))
    rcklnnacr=recn()
  else
    go top
    rcklnnacr=recn()
  endif

  wclose(wfltr)
  setcolor(scfltr)

  return (.t.)

/************* */
function obnap()
  /************* */
  sele cskl
  go top
  while (!eof())
    if (ent#gnEnt)
      sele cskl
      skip
      loop
    endif

    if (rasc#1)
      sele cskl
      skip
      loop
    endif

    skr=sk
    if (gnEntrm=0)
      rmr=rm
    else
      rmr=gnRmsk
    endif

    pathr=gcPath_d+alltrim(path)
    if (netfile('tov', 1))
      ?pathr
      netuse('rs1',,, 1)
      while (!eof())
        nkklr=nkkl
        if (nkklr#0)
          rm_r=0
          if (rmr=0)
            vmrshr=getfield('t1', 'nkklr', 'kln', 'vmrsh')
            if (vmrshr=0)
              sele rs1
              skip
              loop
            endif

            atrcr=getfield('t1', 'vmrshr', 'atvm', 'atrc')
            if (atrcr=0)
              sele rs1
              skip
              loop
            endif

            if (atrcr=1)
              rm_r=2
            endif

            if (atrcr=2)
              rm_r=1
            endif

            if (rm_r=0)
              sele rs1
              skip
              loop
            endif

          else
            rm_r=rmr
          endif

          sele kpl
          if (!netseek('t1', 'nkklr'))
            crmskr=stuff(space(9), rm_r, 1, '1')
            netadd()
            netrepl('kpl,crmsk', 'nkklr,crmskr')
            if (fieldpos('dtkpl')#0)
              netrepl('dtkpl', 'date()')
            endif

          else
            crmskr=crmsk
            crmskr=stuff(crmskr, rm_r, 1, '1')
            netrepl('crmsk', 'crmskr')
          endif

        endif

        sele rs1
        skip
      enddo

      nuse('rs1')
    endif

    sele cskl
    skip
  enddo

  if (gnEntrm=1)
    sele kpl
    go top
    while (!eof())
      crmskr=crmsk
      if (subs(crmskr, gnRmsk, 1)#'1')
        netdel()
        sele kpl
        skip
        loop
      endif

      sele kpl
      skip
    enddo

  endif

  return (.t.)

/****************** */
function kplins(p1)
  /****************** */
  if (empty(p1))
    kplr=0
    crmskr=space(5)
    ndogr=0
    dtdogbr=ctod('')
    dtdoger=ctod('')
    ddogr=ctod('')
    codelistr=space(70)
    pricetypesr=space(70)
    vmrshr=0
    nvmrshr=getfield('t1', 'vmrshr', 'atvm', 'nvmrsh')
    /*   prir=0 */
    pstr=1
    skidr=0
    dtnacbr=ctod('')
    dtnacer=ctod('')
    prsvr=0
    dtsvr=ctod('')
    prmzenr=1
    nacr=0
    nac1r=0
    prksz61r=0
    smksz61r=0
    prksz46r=0
    smksz46r=0
    ksz46r=0
    kdoplr=0
    nodebr=0
    dzr=0
    dtdzr=ctod('')
    tzdocr=0
    ktar=0
    nktar=''
    pr1ndsr=0
    prskpdr=0
    chstr=0
    nchstr=space(40)
  endif

  scbrir=setcolor('gr+/b,n/w')
  wbrir=wopen(1, 0, 24, 79)
  wbox(1)
  while (.t.)
    /*if gnEnt#21 */
    if (empty(p1))
      @ 0, 1 say 'Плательщик  ' get kplr pict '9999999' valid kplkpl()
    else
      @ 0, 1 say 'Плательщик  '+' '+str(kplr, 7)
      @ 0, col()+1 say 'Наименование  '+' '+nkplr
      @ 1, 1 say 'Код ОКП       '+' '+str(kkl1r, 10)
      @ 1, col()+1 say 'Телефон       '+' '+tlfr
      @ 2, 1 say 'Адрес         '+' '+adrr
      @ 3, 1 say 'Банк1         '+' МФО '+kb1r+' р/с '+ns1r
      @ 4, 1 say 'Банк2         '+' МФО '+kb2r+' р/с '+ns2r
      @ 5, 1 say 'Налоговый N   '+' '+str(nnr, 12)
      @ 5, col()+1 say 'Номер свидет  '+' '+nsvr
      @ 6, 1 say '              '+' '+'ССРКША'
      @ 7, 1 say 'Маска продаж  ' get crmskr
      if (gnEnt=21)
        @ 7, 37 say nchstr
        @ 7, 26 say 'Сеть ' get chstr pict '9999' valid kplchst()
      endif

      @ 8, 1 say 'Договор       ' get ndogr pict '999999'
      @ 8, col()+1 say 'от' get dtdogbr
      @ 8, col()+1 say 'по' get dtdoger
      @ 8, col()+1 get cndogr
      /*      @ 9,60 say nsealr */
      @ 9, 1 say 'Возвр тара    ' get ddogr
      @ 9, col()+1 say 'НЕ возв с/тара ' get pstr pict '9'
      @ 9, col()+1 say 'Нал. печати ' get sealr pict '99'//valid seal()
      @ 10, 1 say 'Дог.на скидки ' get dtnacbr
      @ 10, col()+1 get dtnacer
      @ 11, 1 say 'Пров min цен  ' get prmzenr pict '9'
      @ 11, col()+1 say 'Разр скидки   ' get skidr pict '9'
      @ 12, 1 say 'Скидки        ' get nacr pict '999.99'
      @ 12, col()+1 get nac1r pict '999.99'
      @ 13, 1 say 'Транспортные %' get prksz61r pict '999.99'
      @ 13, col()+1 say 'Сумма' get smksz61r pict '9999.99'
      @ 14, 1 say 'Оформление док' get ksz46r pict '9'
      @ 14, col()+1 get prksz46r pict '999.99'
      @ 14, col()+1 get smksz46r pict '9999.99'
      @ 15, 1 say 'Блок дебеторки' get nodebr pict '9'
      @ 16, 1 say 'Макс деб задол' get dzr pict '999999999.99'
      @ 17, 1 say 'Дата деб задол' get dtdzr
      @ 18, 1 say 'Тип закр дебет' get tzdocr pict '9'
      if (gnEnt=21)
        @ 18, 20 say 'Агент' get ktar pict '9999' valid pla(18, 32)
        @ 18, 32 say nktar
        @ 10, 40 say 'Одна НДС' get pr1ndsr pict '9'
      endif

      @ 19, 1 say 'Коды операций ' get codelistr
      @ 20, 1 say 'Типы цен      ' get pricetypesr
      @ 21, 1 say 'К-во дней опл.' get kdoplr pict '999'
      if (gnEnt=21)
        if (gnKto=129.or.gnAdm=1)
          @ 11, 40 say 'Наценка Л' get naclr pict '999.99'
        endif

        @ 11, col()+1 say 'ПрСкТтн Л' get prskpdr pict '9'
      endif

    endif

    /*else
     *      @ 21,1 say 'К-во дней опл.' get kdoplr pict '999'
     *endif
     */
    @ 21, 60 prom 'Верно'
    @ 21, col()+1 prom 'Не Верно'
    read
    if (lastkey()=27)
      exit
    endif

    menu to vnr
    if (lastkey()=27)
      exit
    endif

    if (vnr=1.and.(((gnRkpl=1.or.gnAdm=1).and.gnEnt=20).or.gnEnt=21))
      if (gnEnt=21)
        if (kplr#20034)
          dtnacbr=dtdogbr
          dtnacer=dtdoger
        else
          dtnacer=dtdoger
        endif

      endif

      sele kpl
      if (netseek('t1', 'kplr'))
        if (!empty(p1))
          netrepl('crmsk,skid,prksz61,smksz61,prksz46,smksz46,ksz46,pst,prmzen,nac,nac1,dtnacb,dtnace,prsv,dtsv,codelist,pricetypes,kta',                                     ;
                   { crmskr, skidr, prksz61r, smksz61r, prksz46r, smksz46r, ksz46r, pstr, prmzenr, nacr, nac1r, dtnacbr, dtnacer, prsvr, dtsvr, codelistr, pricetypesr, ktar } ;
                )
          netrepl('nodeb,tzdoc', 'nodebr,tzdocr')
          sele klndog
          if (netseek('t1', 'kplr'))
            netrepl('ndog,dtdogb,dtdoge,kdopl', 'ndogr,dtdogbr,dtdoger,kdoplr')
          else
            netadd()
            netrepl('kkl,ndog,dtdogb,dtdoge,kto,kdopl', 'kplr,ndogr,dtdogbr,dtdoger,gnKto,kdoplr')
          endif

          if (fieldpos('cndog')#0)
            netrepl('cndog', 'cndogr')
          endif

          sele kpl
          netrepl('dz,dtdz,nacl', 'dzr,dtdzr,naclr')
          if (fieldpos('seal')#0)
            netrepl('seal', 'sealr')
          endif

          netrepl('chst', 'chstr')
          netrepl('pr1nds', 'pr1ndsr')
          if (fieldpos('prskpd')#0)
            netrepl('prskpd', 'prskpdr')
          endif

          sele tara
          if (netseek('t1', 'kplr'))
            netrepl('ddog', 'ddogr')
          else
            netadd()
            netrepl('kkl,ddog,kto', 'kplr,ddogr,gnKto')
          endif

        else
          wmess('Такой уже есть', 2)
          rckplr=recn()
        endif

      else
        sele kln
        if (netseek('t1', 'kplr'))
          sele kpl
          netadd()
          netrepl('kpl,dtkpl,pst', {kplr,date(),1})
          clstr='160,161,169,170,129,139'
          prtpr='160'
          netrepl('codelist,pricetypes', {clstr,prtpr})
          rckplr=recn()
        else
          sele kpl
          wmess('Нет в справочнике клиентов', 2)
        endif

      endif

      exit
    endif

  enddo

  wclose(wbrir)
  setcolor(scbrir)
  return (.t.)

/**************** */
function kplflt()
  /**************** */
  scfltr=setcolor('gr+/b,n/w')
  wfltr=wopen(8, 10, 17, 70)
  wbox(1)
  kpl_r=0
  nkpl_r=space(20)
  izg_r=0
  prcrmsk_r=0
  dog_r=0
  kop_r=0
  tzdoc_r=0
  crmsk_r=space(9)
  @ 0, 1 say 'Код       ' get kpl_r pict '9999999'
  @ 1, 1 say 'Контекст  ' get nkpl_r
  @ 2, 1 say 'Изготовит.' get izg_r pict '9999999'
  @ 3, 1 say 'Маска прод' get prcrmsk_r pict '9'
  read
  if (prcrmsk_r#0)
    @ 4, 1 say '          ' get crmsk_r
    read
  else
    crmsk_r=space(9)
  endif

  @ 5, 1 say 'Договор   ' get dog_r pict '9'
  @ 6, 1 say 'Код опер. ' get kop_r pict '999'
  @ 7, 1 say 'Тип закр. ' get tzdoc_r pict '999'
  read
  if (!empty(nkpl_r))
    kpl_r=0
  endif

  if (kpl_r#0)
    if (!netseek('t1', 'kpl_r'))
      wmess('Не найден', 2)
    else
      rckplr=recn()
    endif

    forr=for_r
  else
    forr=for_r
    sele kpl
    go top
    rckplr=recn()
  endif

  if (!empty(nkpl_r))
    nkpl_r=alltrim(nkpl_r)
    nkpl1_r=upper(nkpl_r)
    forr=for_r+".and.(at(nkpl_r,getfield('t1','kpl->kpl','kln','nkl'))#0.or.at(nkpl1_r,getfield('t1','kpl->kpl','kln','nkl'))#0)"
    sele kpl
    go top
    rckplr=recn()
  endif

  if (!empty(crmsk_r))
    forr=forr+".and.crmsk=crmsk_r"
    sele kpl
    go top
    rckplr=recn()
  endif

  if (!empty(izg_r))
    forr=forr+".and.netseek('t1','kpl->kpl,izg_r','klnnac')"
    sele kpl
    go top
    rckplr=recn()
  endif

  if (dog_r#0)
    do case
    case (dog_r=1)        // нет договора
      forr=forr+".and.getfield('t1','kpl->kpl','klndog','ndog')=0"
    case (dog_r=2)        // закончился договор
      forr=forr+".and.getfield('t1','kpl->kpl','klndog','dtdoge')<date().and.getfield('t1','kpl->kpl','klndog','ndog')#0"
    case (dog_r=3)        // заканчивается в тек мес
      forr=forr+".and.getfield('t1','kpl->kpl','klndog','dtdoge')>date().and.getfield('t1','kpl->kpl','klndog','dtdoge')<addmonth(date(),1).and.getfield('t1','kpl->kpl','klndog','ndog')#0"
    case (dog_r=4)        // закончился договор
      forr=forr+".and.getfield('t1','kpl->kpl','klndog','dtdoge')>=date().and.getfield('t1','kpl->kpl','klndog','ndog')#0"
    endcase

    sele kpl
    go top
    rckplr=recn()
  endif

  if (kop_r#0)
    forr=forr+'.and.at(str(kop_r,3),codelist)#0'
  endif

  if (tzdoc_r#0)
    if (tzdoc_r=1)
      forr=forr+'.and.tzdoc=0'
    else
      forr=forr+'.and.tzdoc=1'
    endif

  endif

  wclose(wfltr)
  setcolor(scfltr)

  return (.t.)

/************* */
function obkop()
  /************* */
  clea
  clstr='160,161,169,170'
  prtpr='160'
  sele klndog
  go top
  while (!eof())
    kplr=kkl
    sele kpl
    if (!netseek('t1', 'kplr'))
      netadd()
      netrepl('kpl,codelist,pricetypes,pst', 'kplr,clstr,prtpr,1')
      ?str(kplr, 7)
    endif

    sele klndog
    skip
  enddo

  sele kpl
  go top
  while (!eof())
    if (empty(codelist))
      netrepl('codelist,pricetypes,pst', 'clstr,prtpr,1')
    endif

    skip
  enddo

  return (.t.)

/************* */
function obkln()
  /************* */
  sele kpl
  go top
  while (!eof())
    kplr=kpl
    sele kln
    if (netseek('t1', 'kplr'))
      /*      prir=pri */
      if (pst_l)
        pstr=0
      else
        pstr=1
      endif

      skidr=skid
      dtnacbr=dt_beg
      dtnacer=dt_end
      prsvr=prsv
      dtsvr=dtsv
      if (chknzen)
        prmzenr=1
      else
        prmzenr=0
      endif

      nacr=tov_oth
      nac1r=tov_oth1
      prksz61r=zat61_p
      smksz61r=zat61_sum
      prksz46r=zat46_p
      smksz46r=zat46_sum
      if (zat46_l)
        ksz46r=1
      else
        ksz46r=0
      endif

      sele kpl
      netrepl('skid,prksz61,smksz61,prksz46,smksz46,ksz46,pst,prmzen,nac,nac1,dtnacb,dtnace,prsv,dtsv',              ;
               'skidr,prksz61r,smksz61r,prksz46r,smksz46r,ksz46r,pstr,prmzenr,nacr,nac1r,dtnacbr,dtnacer,prsvr,dtsvr' ;
            )
    endif

    sele kpl
    skip
  enddo

  return (.t.)

/************** */
function kplkpl()
  /************** */
  if (kplr#0)
    nkplr=getfield('t1', 'kpl->kpl', 'kln', 'nkl')
    ndogr=getfield('t1', 'kpl->kpl', 'klndog', 'ndog')
    dtdogbr=getfield('t1', 'kpl->kpl', 'klndog', 'dtdogb')
    dtdoger=getfield('t1', 'kpl->kpl', 'klndog', 'dtdoge')
    ddogr=getfield('t1', 'kpl->kpl', 'tara', 'ddog')
  endif

  return (.t.)

/************* */
function cpizg()
  /************* */
  scfltr=setcolor('gr+/b,n/w')
  wfltr=wopen(8, 10, 11, 70)
  wbox(1)
  store 0 to izg1r, izg2r
  @ 0, 1 say 'Копировать с' get izg1r pict '9999999'
  @ 0, col()+1 say ' на' get izg2r pict '9999999'
  read
  wclose(wfltr)
  setcolor(scfltr)
  if (lastkey()=13)
    sele klnnac
    copy stru to tmp
    sele 0
    use tmp excl
    sele kpl
    go top
    while (!eof())
      kplr=kpl
      sele tmp
      zap
      sele klnnac
      if (netseek('t1', 'kplr,izg1r'))
        while (kkl=kplr.and.izg=izg1r)
          arec:={}
          getrec()
          sele tmp
          netadd()
          putrec()
          netrepl('izg', 'izg2r')
          sele klnnac
          skip
        enddo

      endif

      sele tmp
      go top
      while (!eof())
        kklr=kkl
        izgr=izg
        kgr=kg
        arec:={}
        getrec()
        sele klnnac
        if (!netseek('t1', 'kklr,izgr,kgr'))
          netadd()
          putrec()
        endif

        sele tmp
        skip
      enddo

      sele kpl
      skip
    enddo

  endif

  return (.t.)

/**************** */
function setskid()
  /**************** */
  store 0 to mkeep_r, izg_r, nac_r, nac1_r
  store gdTd to dt1r, dt2r
  dtnacer=ctod('31.12.2008')
  scss=setcolor('gr+/b,n/w')
  wss=wopen(8, 10, 13, 70)
  wbox(1)
  while (.t.)
    @ 0, 1 say 'Торговая марка' get mkeep_r pict '999'
    @ 1, 1 say 'Изготовитель  ' get izg_r pict '9999999'
    @ 2, 1 say 'Период с' get dt1r
    @ 2, col()+1 say ' по ' get dt2r
    @ 3, 1 say 'Скидки' get nac_r pict '999.99'
    @ 3, col()+1 get nac1_r pict '999.99'
    read
    if (lastkey()=27)
      exit
    endif

    if (mkeep_r=0.and.izg_r=0)
      exit
    endif

    if (nac1_r=0)
      nac1_r=nac_r
    endif

    if (nac_r=0)
      exit
    endif

    if (lastkey()=13)
      crtt('tmp1', 'f:kpl c:n(7)')
      sele 0
      use tmp1
      crtt('tmp', 'f:izg c:n(7)')
      sele 0
      use tmp
      if (izg_r#0)
        appe blank
        repl izg with izg_r
      else
        if (mkeep_r#0)
          sele mkeepe
          if (netseek('t1', 'mkeep_r'))
            while (mkeep=mkeep_r)
              izg_r=izg
              sele tmp
              appe blank
              repl izg with izg_r
              sele mkeepe
              skip
            enddo

          else
            exit
          endif

        endif

      endif

      for yyr=year(dt1r) to year(dt2r)
        do case
        case (year(dt1r)=year(dt2r))
          m1r=month(dt1r)
          m2r=month(dt2r)
        case (yyr=year(dt1r))
          m1r=month(dt1r)
          m2r=12
        case (yyr=year(dt2r))
          m1r=1
          m2r=month(dt2r)
        otherwise
          m1r=1
          m2r=12
        endcase

        for mmr=m1r to m2r
          pathdr=gcPath_e+'g'+str(yyr, 4)+'\m'+iif(mmr<10, '0'+str(mmr, 1), str(mmr, 2))+'\'
          sele cskl
          go top
          while (!eof())
            if (ent#gnEnt)
              skip
              loop
            endif

            if (rasc=0)
              skip
              loop
            endif

            skr=sk
            if (!(skr=228.or.skr=232.or.skr=300.or.skr=400.or.skr=700))
              skip
              loop
            endif

            pathr=pathdr+alltrim(path)
            if (!netfile('tov', 1))
              sele cskl
              skip
              loop
            endif

            netuse('rs1',,, 1)
            netuse('rs2',,, 1)
            sele kpl
            go top
            while (!eof())
              kplr=kpl
              crmskr=crmsk
              do case
              case (skr=228.or.skr=232)
                if (val(subs(crmskr, 1, 2))=0)
                  skip
                  loop
                endif

              case (skr=300)
                if (val(subs(crmskr, 3, 1))=0)
                  skip
                  loop
                endif

              case (skr=400.or.skr=700)
                if (val(subs(crmskr, 4, 1))=0)
                  skip
                  loop
                endif

              case (skr=500)
                if (val(subs(crmskr, 5, 1))=0)
                  skip
                  loop
                endif

              endcase

              sele tmp1
              locate for kpl=kplr
              if (foun())
                sele kpl
                skip
                loop
              endif

              prexr=0
              sele rs1
              locate for nkkl=kplr
              if (foun())
                go top
                while (!eof())
                  if (nkkl#kplr)
                    skip
                    loop
                  endif

                  ttnr=ttn
                  sele rs2
                  if (netseek('t1', 'ttnr'))
                    while (ttn=ttnr)
                      izg_r=getfield('t1', 'rs2->mntov', 'ctov', 'izg')
                      sele tmp
                      locate for izg=izg_r
                      if (foun())
                        sele tmp1
                        appe blank
                        repl kpl with kplr
                        prexr=1
                      endif

                      if (prexr=1)
                        exit
                      endif

                      sele rs2
                      skip
                    enddo

                  endif

                  if (prexr=1)
                    exit
                  endif

                  sele rs1
                  skip
                enddo

              endif

              sele kpl
              skip
            enddo

            nuse('rs1')
            nuse('rs2')
            sele cskl
            skip
          enddo

        next

      next

      sele tmp1
      go top
      while (!eof())
        kplr=kpl
        sele kpl
        if (netseek('t1', 'kplr'))
          if (empty(dtnacb))
            netrepl('dtnacb', 'date()')
          endif

          netrepl('dtnace', 'dtnacer')
        endif

        sele tmp
        go top
        while (!eof())
          izg_r=izg
          sele klnnac
          if (!netseek('t1', 'kplr,izg_r,999'))
            netadd()
            netrepl('kkl,nac,nac1,kg,izg', 'kplr,nac_r,nac1_r,999,izg_r')
          else
            if (tcen=0)
              if (nac=0)
                netrepl('nac,nac1', 'nac_r,nac1_r')
              endif

            endif

          endif

          sele tmp
          skip
        enddo

        sele tmp1
        skip
      enddo

      exit
    endif

  enddo

  if (select('tmp')#0)
    sele tmp
    CLOSE
  endif

  erase tmp.dbf
  wclose(wss)
  setcolor(scss)
  return (.t.)

/************** */
function kplnap()
  /************** */
  if (gnEnt=20)
    sele kplnap
    if (netseek('t1', 'kplr'))
      rcknr=recn()
    else
      rcknr=1
    endif

    while (.t.)
      sele kplnap
      go rcknr
      foot('INS,DEL,F4', 'Доб,Уд,Корр')
      rcknr=slcf('kplnap',,,,, "e:nap h:'Код' c:n(4) e:getfield('t1','kplnap->nap','nap','nnap') h:'Направление' c:c(20) e:blk h:'Б' c:n(1) e:smdb h:'ДБ' c:n(12,2)",,, 1, 'kpl=kplr',,, 'Направления')
      if (lastkey()=27)
        exit
      endif

      sele kplnap
      go rcknr
      napr=nap
      blkr=blk
      smdbr=smdb
      do case
      case (lastkey()=22.and.gnEntrm=0.and.(gnAdm=1.or.iif(gnEnt=20, gnKto=160.or.gnKto=186.or.gnKto=782.or.gnKto=848, .t.)))// INS
        kplnapi()
      case (lastkey()=7.and.gnEntrm=0.and.(gnAdm=1.or.iif(gnEnt=20, gnKto=160.or.gnKto=186.or.gnKto=782.or.gnKto=848, .t.)))// DEL
        netdel()
        skip -1
        if (bof())
          go top
        endif

        rcknr=recn()
      case (lastkey()=-3.and.gnEntrm=0.and.(gnAdm=1.or.iif(gnEnt=20, gnKto=160.or.gnKto=186.or.gnKto=782.or.gnKto=848, .t.)))// F4
        kplnapi(1)
      endcase

    enddo

  endif

  if (gnEnt=21.and.gnAdm=1)
    sele kpl
    go top
    while (!eof())
      kplr=kpl
      ktar=kta
      if (ktar#0)
        skip
        loop
      endif

      sele etm
      set orde to tag t2
      if (netseek('t2', 'kplr'))
        while (kpl=kplr)
          tmestor=tmesto
          sele stagtm
          set orde to tag t2
          if (netseek('t2', 'tmestor'))
            while (tmesto=tmestor)
              ktar=kta
              if (ktar=0)
                skip
                loop
              endif

              sele s_tag
              if (netseek('t1', 'ktar'))
                if (!(ent=gnEnt.and.uvol=0))
                  ktar=0
                endif

              else
                ktar=0
              endif

              if (ktar#0)
                exit
              endif

              sele stagtm
              skip
            enddo

          endif

          if (ktar#0)
            exit
          endif

          sele etm
          skip
        enddo

      endif

      if (ktar#0)
        sele kpl
        netrepl('kta', 'ktar')
      endif

      sele kpl
      skip
    enddo

  endif

  return (.t.)

/**************** */
function kplnapi(p1)
  /**************** */
  if (empty(p1))
    napr=0
    blkr=0
    smdbr=0
  endif

  sckn=setcolor('gr+/b,n/w')
  wkn=wopen(8, 20, 13, 60)
  wbox(1)
  while (.t.)
    if (empty(p1))
      @ 0, 1 say 'Направление' get napr pict '9999'
    else
      @ 0, 1 say 'Направление'+' '+str(napr, 4)+' '+getfield('t1', 'napr', 'nap', 'nnap')
    endif

    @ 1, 1 say 'Блокировка ' get blkr pict '9'
    @ 2, 1 say '1-Товар;2-Тара;3-Полная'
    @ 3, 1 say 'Сумма      ' get smdbr pict '999999999.99'
    read
    if (lastkey()=27)
      exit
    endif

    if (lastkey()=13)
      if (empty(p1))
        if (netseek('t1', 'kplr,napr'))
          wmess('Такое уже есть', 2)
          napr=0
          blkr=0
          smdbr=0
          loop
        endif

        netadd()
        netrepl('kpl,nap,blk,smdb', 'kplr,napr,blkr,smdbr')
        rcknr=recn()
      else
        netrepl('blk,smdb', 'blkr,smdbr')
      endif

      exit
    endif

  enddo

  wclose(wkn)
  setcolor(sckn)
  return (.t.)

/************** */
function kplnp()
  /************** */
  sele kplnp
  set orde to tag t1
  if (!netseek('t1', 'kplr'))
    go top
  endif

  rcnpr=recn()
  store gdTd to dt1_rr, dt2_rr
  store 0 to nap_rr, mes_rr
  nfor_r='.t.'
  nforr=for_r
  vidr=1
  while (.t.)
    sele kplnp
    if (vidr=1)
      set orde to tag t1
    else
      set orde to tag t2
    endif

    go rcnpr
    foot('F2,F3,F4,F5,F6', 'Обн Все,Фильтр,Корр,Обн,Вид')
    if (vidr=1)
      rcnpr=slcf('kplnp', 1, 1, 18,, "e:god h:'Год' c:n(4) e:mes h:'Мес' c:n(2) e:nap h:'Nap' c:n(4) e:getfield('t1','kplnp->nap','nap','nnap') h:'Направление' c:c(10) e:smnapd h:'СуммаД' c:n(10,2) e:prrnap h:'ПрПр' c:n(8,2) e:smnapdo h:'СуммаДO' c:n(8,2) e:kdopl h:'ДО' c:n(3) e:prnap h:'Проц' c:n(6,2) e:smnap h:'Сумма' c:n(10,2)",,, 1, 'kpl=kplr', nforr,, alltrim(nkplr))
    else
      rcnpr=slcf('kplnp', 1, 1, 18,, "e:nap h:'Nap' c:n(4) e:getfield('t1','kplnp->nap','nap','nnap') h:'Направление' c:c(10) e:god h:'Год' c:n(4) e:mes h:'Мес' c:n(2) e:smnapd h:'СуммаД' c:n(10,2) e:prrnap h:'ПрПр' c:n(8,2) e:smnapdo h:'СуммаДO' c:n(8,2) e:kdopl h:'ДО' c:n(3) e:prnap h:'Проц' c:n(6,2) e:smnap h:'Сумма' c:n(10,2)",,, 1, 'kpl=kplr', nforr,, alltrim(nkplr))
    endif

    if (lastkey()=27)
      exit
    endif

    go rcnpr
    godr=god
    mesr=mes
    napr=nap
    prnapr=prnap
    smnapr=smnap
    smnapdr=smnapd
    prrnapr=prrnap
    kdoplr=kdopl
    do case
    case (lastkey()=-1)
      obnnp()
      exit
    case (lastkey()=-2)
      npflt()
    case (lastkey()=-3)
      npcor()
    case (lastkey()=-4)
      obnnp(kplr)
    case (lastkey()=-5)
      if (vidr=1)
        vidr=2
      else
        vidr=1
      endif

    endcase

  enddo

  return (.t.)

/*************** */
function obnnp(p1)
  /*************** */
  for yyr=2006 to year(date())
    pathgr=gcPath_e+'g'+str(yyr, 4)+'\'
    do case
    case (yyr=2006)
      mm1r=8
      mm2r=12
    case (yyr=year(date()))
      mm1r=1
      mm2r=month(date())
    otherwise
      mm1r=1
      mm2r=12
    endcase

    for mmr=mm1r to mm2r
      pathmr=pathgr+'m'+iif(mmr<10, '0'+str(mmr, 1), str(mmr, 2))+'\'
      pathr=pathmr+'bank\'
      if (!netfile('dknap', 1))
        loop
      endif

      mess(pathr)
      netuse('dknap',,, 1)
      if (empty(p1))
        while (!eof())
          if (bs#361001)
            skip
            loop
          endif

          kpl_r=kkl
          nap_r=skl
          smnapdr=db
          smnapdor=dbo
          sele kplnp
          if (!netseek('t1', 'kpl_r,yyr,mmr,nap_r'))
            netadd()
            netrepl('kpl,god,mes,nap', 'kpl_r,yyr,mmr,nap_r')
          endif

          netrepl('smnapd,smnapdo', 'smnapdr,smnapdor')
          sele dknap
          skip
        enddo

      else
        if (netseek('t1', 'kplr,361001'))
          while (kkl=kplr.and.bs=361001)
            kpl_r=kkl
            nap_r=skl
            smnapdr=db
            smnapdor=dbo
            sele kplnp
            if (!netseek('t1', 'kpl_r,yyr,mmr,nap_r'))
              netadd()
              netrepl('kpl,god,mes,nap', 'kpl_r,yyr,mmr,nap_r')
            endif

            netrepl('smnapd,smnapdo', 'smnapdr,smnapdor')
            sele dknap
            skip
          enddo

        endif

      endif

      nuse('dknap')
    next

  next

  sele kplnp
  set orde to tag t2
  if (empty(p1))
    smnapdpr=0
    napr=nap
    kplr=kpl
    go top
    while (!eof())
      smnapdr=smnapd
      if (kpl=kplr.and.nap=napr)
        if (smnapdr#0.and.smnapdpr#0)
          prrnapr=(1-smnapdpr/smnapdr)*100
          if (abs(prrnapr)<=10000)
            netrepl('prrnap', 'prrnapr')
          endif

          if (god=year(date()).and.mes=month(date()))
            prnap_r=getfield('t1', 'nap_r', 'nap', 'prnap')
            kdopl_r=getfield('t1', 'kplr', 'klndog', 'kdopl')
            if (prnap_r#0)
              kprnap_r=(100+prnap_r)/100
              smnap_r=smnapdpr*kprnap_r*kdopl_r/30
              netrepl('prnap,smnap', 'prnap_r,smnap_r')
            endif

            netrepl('kdopl', 'kdopl_r')
          endif

        endif

        smnapdpr=smnapdr
      else
        napr=nap
        kplr=kpl
        smnapdpr=0
        loop
      endif

      sele kplnp
      skip
    enddo

  else
    if (netseek('t2', 'kplr'))
      smnapdpr=0
      napr=nap
      while (kpl=kplr)
        smnapdr=smnapd
        if (nap=napr)
          if (smnapdr#0.and.smnapdpr#0)
            prrnapr=(1-smnapdpr/smnapdr)*100
            if (abs(prrnapr)<=10000)
              netrepl('prrnap', 'prrnapr')
            endif

          endif

          if (god=year(date()).and.mes=month(date()))
            prnap_r=getfield('t1', 'nap_r', 'nap', 'prnap')
            kdopl_r=getfield('t1', 'kplr', 'klndog', 'kdopl')
            if (prnap_r#0)
              kprnap_r=(100+prnap_r)/100
              smnap_r=smnapdpr*kprnap_r*kdopl_r/30
              netrepl('prnap,smnap', 'prnap_r,smnap_r')
            endif

            netrepl('kdopl', 'kdopl_r')
          endif

          smnapdpr=smnapdr
        else
          napr=nap
          smnapdpr=0
          loop
        endif

        sele kplnp
        skip
      enddo

    endif

  endif

  return (.t.)

/************** */
function npcor()
  /************** */
  if (!(godr=year(date()).and.mesr=month(date())))
    wmess('Только текущий месяц!', 3)
    return (.t.)
  endif

  scsmr=setcolor('gr+/b,n/w')
  wsmr=wopen(10, 10, 12, 70)
  wbox(1)
  @ 0, 1 say 'Сумма' get smnapr pict '999999999.99'
  read
  if (lastkey()=13)
    netrepl('smnap', 'smnapr')
  endif

  wclose(wsmr)
  setcolor(scsmr)
  return (.t.)

/************** */
function npflt()
  /************** */
  scnr=setcolor('gr+/b,n/w')
  wnr=wopen(10, 10, 15, 70)
  wbox(1)
  store ctod('01.09.2006') to dt1_rr
  store gdTd to dt2_rr
  store 0 to nap_rr, mes_rr

  @ 0, 1 say 'Период с' get dt1_rr
  @ 0, col()+1 say ' по' get dt2_rr
  @ 1, 1 say 'Направление' get nap_rr pict '9999'
  @ 2, 1 say 'Месяц      ' get mes_rr pict '99'
  read
  wclose(wnr)
  setcolor(scnr)

  if (lastkey()=13)
    nforr=nfor_r
    if (!empty(dt1_rr).and.!empty(dt2_rr))
      nforr=nforr+'.and.kplnp->god>=year(dt1_rr).and.kplnp->god<=year(dt2_rr)'
    endif

    if (nap_rr#0)
      nforr=nforr+'.and.kplnp->nap=nap_rr'
    endif

    if (mes_rr#0)
      nforr=nforr+'.and.kplnp->mes=mes_rr'
    endif

    sele kplnp
    if (netseek('t1', 'kplr'))
      rcnpr=recn()
    endif

  endif

  if (lastkey()=27)
    nforr=nfor_r
    sele kplnp
    if (netseek('t1', 'kplr'))
      rcnpr=recn()
    endif

  endif

  return (.t.)

/****************************** */
function sknc()
  /* Обновление klnnac из файла
   ******************************
   */
  fl_rr='j:\vitaliyi\*******.dbf'+space(30)
  scskncr=setcolor('gr+/b,n/w')
  wskncr=wopen(10, 10, 12, 70)
  wbox(1)
  @ 0, 1 say 'Файл' get fl_rr
  read
  wclose(wskncr)
  setcolor(scskncr)
  if (lastkey()=13)
    fl_rr=alltrim(fl_rr)
    if (file(fl_rr))
      if (select('mknac')#0)
        sele mknac
        CLOSE
      endif

      sele 0
      use (fl_rr) alias mknac shared
      go top
      while (!eof())
        if (fieldtype(fieldnum('kkl'))='C')
          kklr=val(kkl)
        else
          kklr=kkl
        endif

        if (fieldtype(fieldnum('izg'))='C')
          izgr=val(izg)
        else
          izgr=izg
        endif

        if (fieldtype(fieldnum('kg'))='C')
          kgr=val(kg)
        else
          kgr=kg
        endif

        if (fieldtype(fieldnum('nac'))='C')
          nacr=val(nac)
        else
          nacr=nac
        endif

        if (fieldtype(fieldnum('nac1'))='C')
          nac1r=val(nac1)
        else
          nac1r=nac1
        endif

        ftxtr=ftxt
        if (fieldtype(fieldnum('tcen'))='C')
          tcenr=val(tcen)
        else
          tcenr=tcen
        endif

        if (fieldtype(fieldnum('mkeep'))='C')
          mkeepr=val(mkeep)
        else
          mkeepr=mkeep
        endif

        if (fieldpos('brand')#0)
          if (fieldtype(fieldnum('brand'))='C')
            brandr=val(brand)
          else
            brandr=brand
          endif

          if (fieldtype(fieldnum('mntov'))='C')
            mntovr=val(mntov)
          else
            mntovr=mntov
          endif

        else
          store 0 to brandr, mntovr
        endif

        do case
        case (izgr#0)
          sele klnnac
          if (netseek('t1', 'kklr,izgr,kgr'))
            netrepl('nac,nac1,ftxt,tcen', 'nacr,nac1r,ftxtr,tcenr')
          else
            netadd()
            netrepl('kkl,izg,kg,nac,nac1,ftxt,tcen',       ;
                     'kklr,izgr,kgr,nacr,nac1r,ftxtr,tcenr' ;
                  )
          endif

        case (izgr=0.and.mntovr=0.and.brandr#0)
          sele brnac
          if (netseek('t1', 'kklr,mkeepr,brandr'))
            netrepl('nac,nac1,ftxt', 'nacr,nac1r,ftxtr')
          else
            netadd()
            netrepl('kkl,mkeep,brand,nac,nac1,ftxt',      ;
                     'kklr,mkeepr,brandr,nacr,nac1r,ftxtr' ;
                  )
          endif

        case (izgr=0.and.mntovr#0)
          sele mnnac
          if (netseek('t1', 'kklr,brandr,mntovr'))
            netrepl('nac,nac1,ftxt', 'nacr,nac1r,ftxtr')
          else
            netadd()
            netrepl('kkl,brand,mntov,nac,nac1,ftxt',      ;
                     'kklr,brandr,mntovr,nacr,nac1r,ftxtr' ;
                  )
          endif

        endcase

        sele mknac
        skip
      enddo

      sele mknac
      CLOSE
    else
      wmess('Не найден файл', 3)
    endif

  endif

  return (.t.)

/************ */
function cgbm()
  /************ */
  store 0 to izg_rr, kg_rr, brand_rr, mntov_rr, prc_rr
  scbrir=setcolor('gr+/b,n/w')
  wbrir=wopen(8, 10, 16, 70)
  wbox(1)
  @ 0, 1 say 'Копировать с  '
  @ 1, 1 say 'Изг    (0-Все)' get izg_rr pict '9999999'
  @ 2, 1 say 'Группа (0-Все)' get kg_rr pict '999'
  @ 3, 1 say 'На            '
  @ 4, 1 say 'Бренд         ' get brand_rr pict '9999999999'
  /*@ 5,1 say 'Товар         ' get mntov_rr pict '9999999' */
  @ 6, 1 say 'Переместить   ' get prc_rr pict '9'
  read
  if (lastkey()=13)
    if (brand_rr#0)
      for_rr='.t.'
      if (izg_rr#0)
        for_rr=for_rr+'.and.izg=izg_rr'
      endif

      if (kg_rr#0)
        for_rr=for_rr+'.and.kg=kg_rr'
      endif

      sele klnnac
      go top
      while (!eof())
        if (&for_rr)
          kkl_rr=kkl
          izg_rr=izg
          kg_rr=kg
          nac_rr=nac
          nac1_rr=nac1
          minzen1_rr=minzen1
          ftxt_rr=ftxt
          mkeep_rr=getfield('t2', 'izg_rr', 'mkeepe', 'mkeep')
          if (mkeep_rr#0)
            sele brnac
            if (!netseek('t1', 'kkl_rr,mkeep_rr,brand_rr'))
              netadd()
              netrepl('kkl,mkeep,brand', 'kkl_rr,mkeep_rr,brand_rr')
              netrepl('nac,nac1,minzen1,ftxt',            ;
                       'nac_rr,nac1_rr,minzen1_rr,ftxt_rr' ;
                    )
              sele klnnac
              if (prc_rr=1)
                netdel()
              endif

            else
              sele klnnac
              if (prc_rr=1)
                netdel()
              endif

            endif

          endif

        endif

        sele klnnac
        skip
      enddo

    endif

  endif

  wclose(wbrir)
  setcolor(scbrir)
  return (.t.)

/************ */
function seal()
  /************ */
  sele seal
  if (recc()=0)
    netadd()
  endif

  if (sealr#0)
    if (netseek('t1', 'sealr'))
      nsealr=nseal
      return (.t.)
    else
      sealr=0
      nsealr=''
    endif

  endif

  sele seal
  go top
  rcsealr=recn()
  save scree to scwbrir
  wselect(0)
  while (.t.)
    sele seal
    go rcsealr
    foot('INS,DEL,F4', 'Доб,Уд,Корр')
    rcsealr=slcf('seal',,,,, "e:seal h:'Код' c:n(2) e:nseal h:'Наименование' c:c(20)",,, 1,,,, 'Печати')
    if (lastkey()=27)
      exit
    endif

    sele seal
    go rcsealr
    sealr=seal
    nsealr=nseal
    do case
    case (lastkey()=22)   // INS
      seali()
    case (lastkey()=7.and.sealr#0)// DEL
      netdel()
      skip -1
      if (bof())
        go top
      endif

      rcsealr=recn()
    case (lastkey()=-3)   // F4
      seali(1)
    case (lastkey()=13)   // F4
      exit
    endcase

  enddo

  wselect(wbrir)
  rest scree from scwbrir
  @ 9, 60 say nsealr
  return (.t.)

/**************** */
function seali(p1)
  /**************** */
  local getlist:={}
  if (empty(p1))
    sealr=0
    nsealr=space(20)
  endif

  sckn=setcolor('gr+/b,n/w')
  wkn=wopen(10, 20, 13, 60)
  wbox(1)
  while (.t.)
    if (empty(p1))
      @ 0, 1 say 'Печать' get sealr pict '99'
    else
      @ 0, 1 say 'Печать'+' '+str(sealr, 2)
    endif

    @ 1, 1 say 'Наименование ' get nsealr
    read
    if (lastkey()=27)
      exit
    endif

    if (lastkey()=13)
      if (empty(p1))
        if (netseek('t1', 'sealr'))
          wmess('Такое уже есть', 2)
          sealr=0
          nsealr=space(20)
          loop
        endif

        netadd()
        netrepl('seal,nseal', 'sealr,nsealr')
        rcsealr=recn()
      else
        netrepl('nseal', 'nsealr')
      endif

      exit
    endif

  enddo

  wclose(wkn)
  setcolor(sckn)
  return (.t.)

/******************* */
function pla(p1, p2)
  /******************* */
  if (ktar#0)
    sele s_tag
    if (netseek('t1', 'ktar'))
      if (ent#gnEnt)
        wmess('Предприятие '+str(ent, 2), 2)
        ktar=0
      endif

      if (ktar#0)
        if (uvol=1)
          wmess('Уволен', 2)
          ktar=0
        endif

      endif

    else
      ktar=0
    endif

  endif

  if (ktar=0)
    wselect(0)
    sele s_tag
    go top
    rcktar=recn()
    while (.t.)
      sele s_tag
      go rcktar
      rcktar=slcf('s_tag',,,,, "e:kod h:'Код' c:n(4) e:fio h:'   Ф.  И.  О.  ' c:c(30) e:ktas h:'SW' c:n(4)",,,,, 'ent=gnEnt.and.uvol=0.and.krj=0.or.kod=0',, 'АГЕНТЫ')
      if (lastkey()=27)
        exit
      endif

      go rcktar
      ktar=kod
      nktar=fio
      if (lastkey()=13)
        if (!empty(p1).and.!empty(p2))
          wselect(wbrir)
          @ p1, p2 say nktar
        endif

        exit
      endif

    enddo

    wselect(wbrir)
  endif

  return (.t.)

/************* */
function kplid()
  /************* */
  save screen to scmkeepr
  sele kplid
  netseek('t1', 'kplr')
  if (foun())
    rckplidr=recn()
  else
    rckplidr=1
  endif

  kplidfr='.t..and.kpl=kplr'
  while (.t.)
    sele kplid
    go rckplidr
    foot('INS,DEL,F4,ENTER', 'Доб,Уд,Корр,Состав')
    rckplidr=slcf('kplid', 5, 5,,, "e:id h:'Код' c:c(10) e:nai h:'Наименование' c:c(60)",,, 1,, kplidfr,, str(kplr, 7)+' '+alltrim(nkplr))
    if (lastkey()=27)
      exit
    endif

    sele kplid
    go rckplidr
    idr=id
    nair=nai
    do case
    case (lastkey()=7)    // Удалить
      netdel()
      skip -1
      if (bof().or.kpl#kplr)
        go top
      endif

      rckplidr=recn()
    case (lastkey()=22)   // Добавить
      kplidi()
    case (lastkey()=-3)   // Корр
      kplidi(1)
    case (lastkey()=13)   // Состав
      kplidx()
    endcase

  enddo

  rest screen from scmkeepr
  return (.t.)

/***************** */
function kplidi(p1)
  /***************** */
  local getlist:={}
  wmkcr=nwopen(10, 5, 14, 75, 1, 'gr+/b,n/w')
  if (p1=nil)
    idr=space(10)
    nair=space(60)
  endif

  while (.t.)
    if (p1=nil)
      @ 0, 1 say 'Код          ' get idr
    else
      @ 0, 1 say 'Код          '+' '+idr
    endif

    @ 1, 1 say 'Наименование ' get nair
    read
    if (lastkey()=27)
      exit
    endif

    @ 2, 40 prom 'Верно'
    @ 2, col()+1 prom 'Не верно'
    menu to vn
    if (lastkey()=27)
      exit
    endif

    if (vn=1)
      idr=upper(idr)
      sele kplid
      if (p1=nil)
        if (!netseek('t1', 'kplr,idr'))
          sele kplid
          netadd()
          netrepl('kpl,id,nai', 'kplr,idr,nair')
          rckplidr=recn()
          exit
        else
          wmess('Такой уже есть', 1)
        endif

      else
        netrepl('nai', 'nair')
        exit
      endif

    endif

  enddo

  wclose(wmkcr)
  return (.t.)

/************** */
function kplidx()
  /************** */
  save scre to sckplidx
  sele kplidx
  seek str(kplr, 7)+idr
  if (foun())
    rckplidxr=recn()
  else
    rckplidxr=1
  endif

  kplidxfr='.t..and.kpl=kplr.and.id=idr'

  while (.t.)
    sele kplidx
    go rckplidxr
    foot('INS,DEL', 'Доб,Уд')
    rckplidxr=slcf('kplidx',,,,, "e:mntov h:'Код' c:n(7) e:getfield('t1','kplidx->mntov','ctov','nat') h:'Наименование' c:c(40)",,, 1,, kplidxfr,, alltrim(idr)+' '+alltrim(nair))
    if (lastkey()=27)
      exit
    endif

    sele kplidx
    go rckplidxr
    mntovr=mntov
    do case
    case (lastkey()=7)    // Удалить
      netdel()
      skip -1
      if (bof().or.kpl#kplr.or.id#idr)
        go top
      endif

      rckplidxr=recn()
    case (lastkey()=22)   // Добавить
      kplidxi()
    endcase

  enddo

  rest scre from sckplidx
  return (.t.)

/************** */
function kplidxi()
  /************** */
  if (select('sl')=0)
    sele 0
    use _slct alias sl excl
  endif

  sele sl
  zap
  sele ctov
  rcctovrr=recn()
  save scre to scctov
  while (.t.)
    foot('SPACE,F8,ENTER,ESC', 'Отбор,Группа,Выполнить,Отмена')
    rcctovrr=slcf('ctov', 5, 10, 10,, "e:mntov h:'Код' c:n(7) e:nat h:'Наименование' c:c(40) ",, 1, 1)
    sele ctov
    go rcctovrr
    if (lastkey()=27)
      exit
    endif

    do case
    case (lastkey()=13)
      sele sl
      go top
      while (!eof())
        rcctovrr=val(kod)
        sele ctov
        go rcctovrr
        mntovr=mntov
        sele kplidx
        if (!netseek('t1', 'kplr,idr,mntovr'))
          netadd()
          netrepl('kpl,id,mntov', 'kplr,idr,mntovr')
          rckplidxr=recn()
        endif

        sele sl
        skip
      enddo

      exit
    case (lastkey()=-7)   // Группа
      save scre to sccgrp
      foot('', '')
      sele cgrp
      set orde to tag t2
      go top
      rcn_gr=recn()
      while (.t.)
        sele cgrp
        set orde to tag t2
        rckgr=recn()
        rckgr=slcf('cgrp',,,,, "e:kgr h:'Код' c:n(3) e:ngr h:'Наименование' c:c(20)",,, 1,, ".t..and.netseek('t1','cgrp->kgr*10000','ctov','3')",, 'Группы')
        go rckgr
        kg_r=kgr
        do case
        case (lastkey()=13)
          sele ctov
          if (!netseek('t2', 'kg_r'))
            go rcctovrr
          else
            rcctovrr=recn()
          endif

          exit
        case (lastkey()=27)
          exit
        case (lastkey()>32.and.lastkey()<255)
          sele cgrp
          lstkr=upper(chr(lastkey()))
          if (!netseek('t2', 'lstkr'))
            go rckgr
          endif

          loop
        otherwise
          loop
        endcase

      enddo

    endcase

  enddo

  rest scre from scctov
  return (.t.)

/**************** */
function kplchst()
  /**************** */
  sele chst
  set orde to tag t2
  locate for chst=chstr
  rckgr=recn()
  wselect(0)
  while (.t.)
    sele chst
    set orde to tag t2
    rckgr=slcf('chst',,,,, "e:chst h:'Код' c:n(4) e:nchst h:'Наименование' c:c(40)",,,,,,, 'Сети')
    go rckgr
    do case
    case (lastkey()=13)
      chstr=chst
      nchstr=nchst
      exit
    case (lastkey()=27)
      exit
    endcase

  enddo

  wselect(wbrir)
  sele kpl
  @ 7, 37 say nchstr
  return (.t.)
