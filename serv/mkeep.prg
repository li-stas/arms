/***********************************************************
 * Модуль    : mkeep.prg
 * Версия    : 0.0
 * Автор     :
 * Дата      : 02/05/18
 * Изменен   :
 * Примечание: Текст обработан утилитой CF версии 2.02
 */

#include "inkey.ch"
/* Маркодержатели */
clea

netuse('mkeep')
netuse('mkeepe')
netuse('mkeepg')
netuse('ctov')
netuse('cgrp')
netuse('kln')
netuse('brand')
netuse('grbr')
netuse('MkCros')
netuse('grbrnd')
netuse('cskl')
netuse('klnnac')
netuse('tcen')
netuse('krntm')
netuse('rntm')
netuse('nasptm')
netuse('kgptm')
netuse('kgp')

sele mkeep
set orde to tag t2
for_r='.t.'

if (gnEnt=20)
  forr=for_r+'.and.lv20=1'
  lv_r=1
endif

if (gnEnt=21)
  forr=for_r+'.and.lv21=1'
  lv_r=0
endif

go top
rcmkeepr=recn()
prF1r=0
while (.t.)
  sele mkeep
  go rcmkeepr
  if (prF1r=0)
    foot('F2,F3,F4,F5,ENTER,F6,F7,F8,F9', 'ГрБр,Фильтр,Корр,Бренды,Изг,CTOV,Отчет,Кросс,Отчет(П)')
  else
    foota('F5,F6,F7,F8,F9', 'АрндОб,ГрКросс,ОстДн,Ост по дн,ОтчДн')
  endif

  if (str(gnEnt, 3)$' 20; 21')
    if (fieldpos('pr129')#0)
      rcmkeepr=slcf('mkeep', 1, 1, 18,,                                                                                                                                                                                            ;
                     "e:mkeep h:'Код' c:n(3) e:nmkeep h:'Наименование' c:с(20) e:lv20 h:'20' c:n(1) e:lv21 h:'21' c:n(1) e:BlkMk h:'Блк' c:n(1) e:pr169 h:'169' c:n(1) e:pr129 h:'129' c:n(1) e:pr139 h:'139' c:n(1)",,, 1,, forr,, ;
                     'Маркодержатели'                                                                                                                                                                                               ;
                  )
    else
      rcmkeepr=slcf('mkeep', 1, 1, 18,,                                                                                                                                              ;
                     "e:mkeep h:'Код' c:n(3) e:nmkeep h:'Наименование' c:с(20) e:lv20 h:'20' c:n(1) e:lv21 h:'21' c:n(1) e:BlkMk h:'Блк' c:n(1) e:pr169 h:'169' c:n(1)",,, 1,, forr,, ;
                     'Маркодержатели'                                                                                                                                                 ;
                  )
    endif

  else
    rcmkeepr=slcf('mkeep', 1, 1, 18,, "e:mkeep h:'Код' c:n(3) e:nmkeep h:'Наименование' c:с(20) e:lv20 h:'20' c:n(1) e:lv21 h:'21' c:n(1) e:BlkMk h:'Блк' c:n(1)",,, 1,, forr,, 'Маркодержатели')
  endif

  sele mkeep
  go rcmkeepr
  mkeepr=mkeep
  nmkeepr=nmkeep
  drepr=drep
  lv20r=lv20
  lv21r=lv21
  BlkMkr=BlkMk
  pr169r=pr169
  if (fieldpos('pr129')#0)
    pr129r=pr129
    pr139r=pr139
  else
    pr129r=0
    pr139r=0
  endif

  do case
  case (lastkey()=K_ESC)
    exit
  case (lastkey()=K_F1)   //28 && F1
    if (prF1r=0)
      prF1r=1
    else
      prF1r=0
    endif

  case (lastkey()=K_ENTER)// && Изготовители
    mkeepe()
  case (lastkey()=K_INS)  //22 && Добавить
    MkeepIns()
    sele mkeep
  case (lastkey()=K_F2)   //-1 && Группы брендов
    save scre to scgrbr
    grbr()
    rest scree from scgrbr
  case (lastkey()=K_F3 .and. gnEnt=20)// -2 && Фильтр
    clflt=setcolor('gr+/b,n/w')
    wflt=wopen(10, 20, 13, 40)
    wbox(1)
    @ 0, 1 say 'Вид' get lv_r pict '9'
    @ 1, 1 say '0-все;1-раб;2-не раб'
    read
    if (lastkey()=K_ENTER)
      do case
      case (lv_r=0)
        forr=for_r
      case (lv_r=1)
        forr=for_r+'.and.lv20=1'
      case (lv_r=2)
        forr=for_r+'.and.lv20=0'
      endcase

      go top
      rcmkeepr=recn()
    endif

    wclose(wflt)
    setcolor(clflt)
  case (lastkey()=K_F4)   //-3 // Коррекция
    MkeepIns(1)
    sele mkeep
  case (lastkey()=K_F5)   //-4  && Бренды
    Brands()
  case (lastkey()=K_F6)   //-5 // CTOV
    CorrCTov()
    sele mkeep
  case (lastkey()=K_F7)   //-6 && Отчет
    mkotch(gdTd, mkeepr)
  case (lastkey()=K_F9)   //-8 && Отчет(П)
    mkotchn(gdTd, mkeepr)
  case (lastkey()=K_ALT_F5)// Аренда
    sbarost(mkeepr,gcPath_arnd)
  case (lastkey()=K_ALT_F7)// Остатки на день по mkeep
    save scree to scmkdayr
    mntovday()
    rest scre from scmkdayr
  case (lastkey()=K_ALT_F8)// Остатки по дням по mkeep
    mkostsh(mkeepr)
  case (lastkey()=K_ALT_F9)//&&.and.gnAdm=1 && Отчет(Д)
    mkotchd(gdTd, mkeepr)
  case (lastkey()=K_DEL .and.gnAdm=1)// 7 Удалить
    sele mkeepe
    if (netseek('t1', 'mkeepr'))
      while (mkeep=mkeepr)
        netdel()
        skip
      enddo

    endif

    sele mkeep
    netdel()
    skip -1
    if (bof())
      go top
    endif

    rcmkeepr=recn()
  case (lastkey()=K_F8)   // -7 && Кросс
    MkCros()
  case (lastkey()=K_ALT_F6)//-35 && Группы кросс
    grbrnd()
  endcase

enddo

nuse()

/***********************************************************
 * MkeepIns() -->
 *   Параметры :
 *   Возвращает:
 */
function MkeepIns(p1)
  local getlist:={}
  wmkr=nwopen(8, 10, 18, 70, 1, 'gr+/b,n/w')
  if (p1=nil)
    mkeepr=0
    nmkeepr=space(20)
    drepr=space(10)
  endif

  while (.t.)
    if (p1=nil)
      @ 0, 1 say 'Код' get mkeepr pict '999' valid vmkeep()
    else
      @ 0, 1 say 'Код'+' '+str(mkeepr, 3)
    endif

    @ 1, 1 say 'Наименование' get nmkeepr
    @ 2, 1 say 'Отчет       ' get drepr
    @ 3, 1 say 'Режим 20    ' get lv20r pict '9'
    @ 4, 1 say 'Режим 21    ' get lv21r pict '9'
    @ 5, 1 say 'Блок.выписки' get BlkMkr pict '9'
    if (str(gnEnt, 3)$' 20; 21')
      @ 6, 1 say 'Признак 169' get pr169r pict '9'
      @ 7, 1 say 'Признак 129' get pr129r pict '9'
      @ 8, 1 say 'Признак 139' get pr139r pict '9'
    endif

    read
    if (lastkey()=K_ESC)
      exit
    endif

    @ 8, 40 prom 'Верно'
    @ 8, col()+1 prom 'Не верно'
    menu to vn
    if (lastkey()=K_ESC)
      exit
    endif

    if (vn=1)
      sele mkeep
      if (p1=nil)
        netadd()
        netrepl('mkeep,nmkeep,drep', 'mkeepr,nmkeepr,drepr')
      else
        netrepl('nmkeep,drep', 'nmkeepr,drepr')
      endif

      netrepl('lv20,lv21', 'lv20r,lv21r')
      if (gnEnt=20.and.(gnAdm=1.or.gnKto=814.or.gnKto=118.or.gnKto=57.or.gnKto=969))// Лебедев,Бубнова,Ярмак,Коробко Ю
        netrepl('BlkMk', 'BlkMkr')
      endif

      if (.t.                            ;
          .and.str(gnEnt, 3)$' 20; 21' ;
          .and.(gnAdm=1.or.str(gnKto, 4)$' 129; 160; 117') ; // Калюжный Таранец Ищенко 169
        )
        netrepl('pr169', 'pr169r')
        if (fieldpos('pr129')#0)
          netrepl('pr129', 'pr129r')
          netrepl('pr139', 'pr139r')
        endif

      endif

    endif

    exit
  enddo

  wclose(wmkr)
  return

/***********************************************************
 * vmkeep() -->
 *   Параметры :
 *   Возвращает:
 */
function vmkeep()
  sele mkeep
  if (netseek('t1', 'mkeepr'))
    wmess('Такой уже есть', 1)
    return (.f.)
  endif

  return (.t.)

/***********************************************************
 * mkeepe() -->
 *   Параметры :
 *   Возвращает:
 */
function mkeepe()
  save scre to scmkeepe
  forr='mkeep=mkeepr'
  while (.t.)
    sele mkeepe
    go top
    foot('INS,DEL,ENTER', 'Добавить,Удалить,Группы')
    rcmkeeper=slcf('mkeepe', 1, 30, 5,, "e:izg h:'Код' c:n(7) e:getfield('t1','mkeepe->izg','kln','nkl') h:'Наименование' c:с(40)",,, 1,, forr,, nmkeepr)
    sele mkeepe
    go rcmkeeper
    izgr=izg
    nizgr=alltrim(getfield('t1', 'izgr', 'kln', 'nkl'))
    do case
    case (lastkey()=K_ESC)
      exit
    case (lastkey()=K_INS)
      mkeepei()
    case (lastkey()=K_DEL.and.(gnAdm=1.or.gnKto=160))
      netdel()
    case (lastkey()=K_ENTER)   // Группы
      izggr()
    endcase

  enddo

  rest scre from scmkeepe
  return (.t.)

/***********************************************************
 * mkeepei() -->
 *   Параметры :
 *   Возвращает:
 */
function mkeepei()
  local getlist:={}
  wmker=nwopen(10, 10, 14, 70, 1, 'gr+/b,n/w')
  izgr=0
  nizgr=space(20)
  while (.t.)
    @ 0, 1 say 'Код' get izgr pict '9999999'
    read
    if (lastkey()=K_ESC)
      exit
    endif

    @ 1, 1 say 'Наименование '+getfield('t1', 'izgr', 'kln', 'nkl')
    @ 2, 40 prom 'Верно'
    @ 2, col()+1 prom 'Не верно'
    menu to vn
    if (lastkey()=K_ESC)
      exit
    endif

    if (vn=1)
      sele mkeepe
      if (!netseek('t1', 'mkeepr,izgr'))
        netadd()
        netrepl('mkeep,izg', 'mkeepr,izgr')
      endif

    endif

    exit
  enddo

  wclose(wmker)
  return

/***********************************************************
 * prgr() -->
 *   Параметры :
 *   Возвращает:
 */
function prgr()
  local getlist:={}
  wprgr=nwopen(10, 30, 18, 70, 1, 'gr+/b,n/w')
  izgr=0
  nizgr=space(20)
  while (.t.)
    @ 0, 1 say 'Код' get izgr pict '9999999'
    read
    if (lastkey()=K_ESC)
      exit
    endif

    @ 1, 1 say 'Наименование '+getfield('t1', 'izgr', 'kln', 'nkl')
    @ 2, 40 prom 'Верно'
    @ 2, col()+1 prom 'Не верно'
    menu to vn
    if (lastkey()=K_ESC)
      exit
    endif

    if (vn=1)
      sele mkeepe
      if (!netseek('t1', 'mkeepr,izgr'))
        netadd()
        netrepl('mkeep,izg', 'mkeepr,izgr')
      endif

    endif

    exit
  enddo

  wclose(wmker)
  return

/***********************************************************
 * izggr() -->
 *   Параметры :
 *   Возвращает:
 */
function izggr()
  save scre to scmkeepg
  forgr='izg=izgr'
  sele mkeepg
  go top
  while (.t.)
    foot('F4,F5', 'Коррекция,Обновить')
    rcmkeepgr=slcf('mkeepg', 11, 30, 8,, "e:kg h:'Код' c:n(3) e:getfield('t1','mkeepg->kg','cgrp','ngr') h:'Группа' c:c(20) e:prrlz h:'%Р' c:n(6,2) e:prdoh h:'%Д' c:n(6,2)",,, 1,, forgr,, nizgr)
    sele mkeepg
    go rcmkeepgr
    prrlz_r=prrlz
    prdoh_r=prdoh
    do case
    case (lastkey()=K_ESC)
      exit
    case (lastkey()=-3)   // Коррекция
      mkeepgi()
    case (lastkey()=-4)   // Обновить
      save scre to scg
      mess('Ждите...')
      sele ctov
      go top
      while (!eof())
        kg_r=int(mntov/10000)
        if (kg_r<2)
          skip
          loop
        endif

        izg_r=izg
        if (izg_r=0)
          skip
          loop
        endif

        mkeep_r=getfield('t2', 'izg_r', 'mkeepe', 'mkeep')
        if (mkeep_r#0)
          sele mkeepg
          if (!netseek('t1', 'izg_r,kg_r'))
            netadd()
            netrepl('izg,kg', 'izg_r,kg_r')
          endif

        endif

        sele ctov
        skip
      enddo

      rest scre from scg
      sele mkeepg
      if (!netseek('t1', 'izg_r'))
        exit
      endif

    endcase

  enddo

  rest scre from scmkeepg
  return

/***********************************************************
 * mkeepgi() -->
 *   Параметры :
 *   Возвращает:
 */
function mkeepgi()
  clmkgi=setcolor('gr+/b,n/w')
  wmkgi=wopen(10, 20, 14, 40)
  wbox(1)
  while (.t.)
    @ 0, 1 say '% реализации' get prrlz_r pict '999.99'
    @ 1, 1 say '% дохода    ' get prdoh_r pict '999.99'
    read
    if (lastkey()=K_ESC)
      exit
    endif

    @ 2, 1 prom 'Верно'
    @ 2, col()+1 prom 'Не Верно'
    menu to vn
    if (lastkey()=K_ESC)
      exit
    endif

    if (vn=1)
      sele mkeepg
      netrepl('prrlz,prdoh',    ;
               'prrlz_r,prdoh_r' ;
            )
      exit
    endif

  enddo

  wclose(wmkgi)
  setcolor(clmkgi)
  return

/***********************************************************
 * corrctov() -->
 *   Параметры :
 *   Возвращает:
 */
function corrctov()
  sele ctov
  if (fieldpos('mkeep')#0)
    mess('Ждите...')
    go top
    while (!eof())
      if (izg=0)
        skip
        loop
      endif

      izgr=izg
      mkeepr=getfield('t2', 'izgr', 'mkeepe', 'mkeep')
      sele ctov
      netrepl('mkeep', 'mkeepr')
      skip
    enddo

    clea
  endif

  return (.t.)

/************** */
function MkCros()
  /************** */
  save screen to scmkeepr
  clea
  sele MkCros
  set orde to tag t3
  if (netseek('t3', 'mkeepr'))
    while (mkeep=mkeepr)
      netrepl('mkcnt', '0')
      sele MkCros
      skip
    enddo

  endif

  sele ctov
  set orde to tag t6
  if (netseek('t6', 'mkeepr'))
    while (mkeep=mkeepr)
      if (MkCros=0)
        skip
        loop
      endif

      MkCrosr=MkCros
      sele MkCros
      if (netseek('t1', 'MkCrosr'))
        netrepl('mkcnt', 'mkcnt+1')
      endif

      sele ctov
      skip
    enddo

  endif

  netseek('t3', 'mkeepr')
  if (foun())
    rcMkCrosr=recn()
  else
    rcMkCrosr=1
  endif

  MkCrosfr='.t..and.mkeep=mkeepr'
  while (.t.)
    sele MkCros
    go rcMkCrosr
    foot('INS,F2,DEL,F4,ENTER', 'Доб,ДобФ,Уд,Корр,Состав')
    rcMkCrosr=slcf('MkCros', 1, 1, 18,, "e:MkCros h:'Код' c:n(7) e:mkid h:'Код МД' c:с(20) e:nmkid h:'Наименование МД' c:c(37) e:grbrand h:'Гр' c:n(2) e:keg h:'Кег' c:n(3) e:mkcnt h:'Сч' c:n(2)",,, 1,, MkCrosfr,, str(mkeepr, 3)+' '+alltrim(nmkeepr))
    if (lastkey()=K_ESC)
      exit
    endif

    sele MkCros
    go rcMkCrosr
    MkCrosr=MkCros
    mkidr=mkid
    nmkidr=nmkid
    kegr=keg
    grbrandr=grbrand
    gr1r=gr1
    gr2r=gr2
    gr3r=gr3
    gr4r=gr4
    gr5r=gr5
    do case
    case (lastkey()=K_DEL)    // Удалить
      netdel()
      skip -1
      if (bof())
        go top
      endif

      rcMkCrosr=recn()
    case (lastkey()=K_INS)   // Добавить
      MkCrosI()
    case (lastkey()=K_F4)   // Корр
      MkCrosI(1)
    case (lastkey()=K_ENTER)   // Состав
      MkCrosEntry()
    case (lastkey()=K_F2)   // Добавить из файла
      MkCrosInsFile()
    endcase

  enddo

  rest screen from scmkeepr
  return (.t.)

/***************** */
function MkCrosi(p1)
  /***************** */
  local getlist:={}
  wmkcr=nwopen(5, 10, 18, 70, 1, 'gr+/b,n/w')
  if (p1=nil)
    mkidr=space(20)
    nmkidr=space(90)
    MkCrosr=0
    kegr=0
    grbrandr=0
    store 0 to gr1r, gr2r, gr3r, gr4r, gr5r
  endif

  while (.t.)
    @ 0, 1 say 'Кросс Код      '+' '+str(MkCrosr, 7)
    @ 1, 1 say 'Код          MД' get mkidr
    @ 2, 1 say 'Наименование MД' get nmkidr
    @ 3, 1 say 'Группа       МД' get grbrandr pict '99' valid gbrn()
    @ 4, 1 say 'Емкость кеги   ' get kegr
    @ 5, 1 say 'Аналитческие группы'
    @ 6, 1 say 'Група 1        ' get gr1r pict '999'
    @ 7, 1 say 'Група 2        ' get gr2r pict '999'
    @ 8, 1 say 'Група 3        ' get gr3r pict '999'
    @ 9, 1 say 'Група 4        ' get gr4r pict '999'
    @ 10, 1 say 'Група 5        ' get gr5r pict '999'
    read
    if (lastkey()=K_ESC)
      exit
    endif

    @ 11, 40 prom 'Верно'
    @ 11, col()+1 prom 'Не верно'
    menu to vn
    if (lastkey()=K_ESC)
      exit
    endif

    if (vn=1)
      mkidr=upper(mkidr)
      sele MkCros
      if (p1=nil)
        if (!netseek('t2', 'mkeepr,mkidr'))
          sele CntCm
          reclock()
          if (MkCros=0)
            repl MkCros with 1
          endif
          MkCrosr=MkCros
          netrepl('MkCros', {MkCros+1})

          sele MkCros
          netadd()
          netrepl('MkCros,mkeep,mkid,nmkid,keg,grbrand', {MkCrosr,mkeepr,mkidr,nmkidr,kegr,grbrandr})
          netrepl('gr1,gr2,gr3,gr4,gr5', {gr1r,gr2r,gr3r,gr4r,gr5r})
          rcMkCrosr=recn()
          exit
        else
          wmess('Такой уже есть', 1)
        endif

      else
        netrepl('mkid,nmkid,keg,grbrand', 'mkidr,nmkidr,kegr,grbrandr')
        netrepl('gr1,gr2,gr3,gr4,gr5', 'gr1r,gr2r,gr3r,gr4r,gr5r')
        exit
      endif

    endif

  enddo

  wclose(wmkcr)
  return (.t.)

/*************** */
function MkCrosEntry()
  /*************** */
  sele ctov
  set orde to tag t6
  if (netseek('t6', 'mkeepr'))
    rcCTovr=recn()
  else
    rcCTovr=1
  endif

  save scre to MkCrosEntry
  while (.t.)
    foot('INS,DEL', 'Доб.,Уд.')
    sele ctov
    go rcCTovr
    rcCTovr=slcf('ctov', 3, 5, 10,, "e:mntov h:'Код' c:n(7) e:nat h:'Наименование' c:с(60)",,, 1, 'mkeep=mkeepr', 'MkCros=MkCrosr',, alltrim(mkidr)+' '+alltrim(nmkidr))
    if (lastkey()=K_ESC)
      exit
    endif

    sele ctov
    go rcCTovr
    do case
    case (lastkey()=K_INS)   // Добавить
      if (select('sl')=0)
        sele 0
        use _slct alias sl excl
      endif

      sele sl
      zap
      sele ctov
      if (netseek('t6', 'mkeepr'))
        rcCTovrr=recn()
      else
        rcCTovrr=1
      endif

      save scre to scctov
      while (.t.)
        foot('SPACE,F8,ENTER,ESC', 'Отбор,Группа,Выполнить,Отмена')
        rcCTovrr=slcf('ctov', 5, 10, 10,, "e:mntov h:'Код' c:n(7) e:nat h:'Наименование' c:c(40) ",, 1, 1;
        , 'mkeep=mkeepr';
        , "(MkCros=0.or.!netseek('t1','ctov->MkCros','MkCros')).and.merch=1")
        sele ctov
        go rcCTovrr
        if (lastkey()=K_ESC)
          exit
        endif

        do case
        case (lastkey()=K_ENTER)
          sele sl
          go top
          while (!eof())
            rcCTovrr=val(kod)
            sele ctov
            go rcCTovrr
            netrepl('MkCros', 'MkCrosr')
            sele sl
            skip
          enddo

          exit
        case (lastkey()=K_F8)// Группа
          If !Empty(kg_r:=ChoiceGGrp())
            sele ctov
            netseek('t6', 'mkeepr')
            locate while mkeep=mkeepr for kg_r = kg
            if (!found())
              go rcCTovrr
            else
              rcCTovrr=recn()
            endif
            outlog(__FILE__,__LINE__,"kg_r,mkeepr",kg_r,found(),mkeepr)

            sele ctov
            //browse()
            loop
          EndIf


        endcase

      enddo

      rest scre from scctov
      sele ctov
      if (netseek('t6', 'mkeepr'))
        rcCTovr=recn()
      else
        rcCTovr=1
      endif

    case (lastkey()=K_DEL)    // Удалить
      netrepl('MkCros', '0')
      skip -1
      if (bof())
        go top
      endif

      rcCTovr=recn()
    endcase

  enddo

  rest scre from MkCrosEntry
  return (.t.)

/***********************************************************
 * MkCrosInsFile() -->
 *   Параметры :
 *   Возвращает:
 */
function MkCrosInsFile()
  local getlist:={}
  wmkcr=nwopen(10, 10, 13, 70, 1, 'gr+/b,n/w')
  pathfr='j:\resurs\'+space(20)
  while (.t.)
    @ 0, 1 say 'Файл  tMkCros.dbf'
    @ 1, 1 say 'Путь ' get pathfr
    read
    if (lastkey()=K_ESC)
      exit
    endif

    if (!file(alltrim(pathfr)+'tMkCros.dbf'))
      wmess('Нет файла', 1)
      exit
    endif

    sele 0
    use (alltrim(pathfr)+'tMkCros.dbf')
    if (fieldpos('mkeep')=0)
      wmess('Нет поля MKEEP')
      exit
    endif

    if (fieldpos('mkid')=0)
      wmess('Нет поля MKID')
      exit
    endif

    if (fieldpos('nmkid')=0)
      wmess('Нет поля NMKID')
      exit
    endif

    if (fieldpos('mntov')=0)
      wmess('Нет поля MNTOV')
      exit
    endif

    sele tMkCros
    go top
    while (!eof())
      if (mkeep#mkeepr)
        skip
        loop
      endif

      if (empty(mkid))
        skip
        loop
      endif

      if (empty(nmkid))
        skip
        loop
      endif

      mkidr=allt(mkid)
      do case
      case (len(mkidr)>20)
        mkidr=subs(mkidr, 1, 20)
      case (len(mkidr)<20)
        mkidr=mkidr+space(20-len(mkidr))
      endcase

      nmkidr=nmkid
      mntovr=mntov
      sele MkCros
      if (!netseek('t2', 'mkeepr,mkidr'))
        sele CntCm
        reclock()
        MkCrosr=MkCros
        netrepl('MkCros', {MkCros+1})
      else
        MkCrosr=MkCros
      endif

      sele MkCros
      if (!netseek('t2', 'mkeepr,mkidr'))
        netadd()
        netrepl('MkCros,mkeep,mkid,nmkid', 'MkCrosr,mkeepr,mkidr,nmkidr')
      endif

      if (mntovr#0)
        sele ctov
        set orde to tag t6
        if (netseek('t6', 'mkeepr'))
          while (mkeep=mkeepr)
            if (mntov=mntovr)
              netrepl('MkCros', 'MkCrosr')
            endif

            skip
          enddo

        endif

      endif

      sele tMkCros
      skip
    enddo

    exit
  enddo

  if (select('tMkCros')#0)
    sele tMkCros
    CLOSE
  endif

  wclose(wmkcr)
  return (.t.)

/************** */
function grbr()
  /************** */
  sele grbr
  if (netseek('t1', 'mkeepr'))
  else
    go top
  endif

  rcgrbrr=recn()
  while (.t.)
    sele grbr
    go rcgrbrr
    foot('INS,DEL,F4', 'Доб,Уд,Корр')
    rcgrbrr=slcf('grbr', 1, 30,,, "e:grbrand h:'Код' c:n(2) e:ngrbrand h:'Наименование' c:с(40)",,, 1, 'mkeep=mkeepr',,, 'Группы брендов')
    if (lastkey()=K_ESC)
      exit
    endif

    go rcgrbrr
    grbrandr=grbrand
    ngrbrandr=ngrbrand
    do case
    case (lastkey()=K_INS)   // Добавить
      grbrins()
    case (lastkey()=K_DEL)    // Удалить
      netdel()
      skip -1
      if (bof())
      endif

      go top
      rcgrbrr=recn()
    case (lastkey()=-3)   // Коррекция
      grbrins(1)
    endcase

  enddo

  return (.t.)

/***************** */
function grbrins(p1)
  /*************** */
  wgrbrr=nwopen(10, 10, 14, 70, 1, 'gr+/b,n/w')
  if (empty(p1))
    grbrandr=0
    ngrbrandr=space(40)
  endif

  while (.t.)
    if (empty(p1))
      @ 0, 1 say 'Группа' get grbrandr pict '99'
      read
      if (lastkey()=K_ESC)
        exit
      endif

    else
      @ 0, 1 say 'Группа'+' '+str(grbrandr, 2)
    endif

    @ 1, 1 say 'Наименование ' get ngrbrandr
    read
    if (lastkey()=K_ESC)
      exit
    endif

    @ 2, 40 prom 'Верно'
    @ 2, col()+1 prom 'Не верно'
    menu to vn
    if (lastkey()=K_ESC)
      exit
    endif

    if (vn=1)
      sele grbr
      if (!netseek('t1', 'mkeepr,grbrandr'))
        netadd()
        netrepl('mkeep,grbrand', 'mkeepr,grbrandr')
      endif

      netrepl('ngrbrand', 'ngrbrandr')
      rcgrbrr=recn()
    endif

    exit
  enddo

  wclose(wgrbrr)
  return (.t.)

/****************** */
function mntovday()
  /****************** */
  do case
  case (mkeepr<10)
    cmkeepr='00'+str(mkeepr, 1)
  case (mkeepr<100)
    cmkeepr='0'+str(mkeepr, 2)
  otherwise
    cmkeepr=str(mkeepr, 3)
  endcase

  dayr=day(gdTd)
  scdt_r=setcolor('gr+/b,n/w')
  wdt_r=wopen(8, 20, 11, 60)
  wbox(1)
  @ 0, 1 say 'День' get dayr pict '99'
  read
  cdayr=iif(dayr<10, '0'+str(dayr, 1), str(dayr, 2))
  cdtr=stuff(dtoc(gdTd), 1, 2, cdayr)
  dtr=ctod(cdtr)
  dtpr=dtr-1
  wclose(wdt_r)
  setcolor(scdt_r)
  if (lastkey()=K_ESC)
    return (.t.)
  endif

  dirostr=gcPath_ew+'ost'
  dirmkr=gcPath_ew+'ost\mk'+cmkeepr

  diryyr=dirmkr+'\g'+str(year(dtr), 4)
  dirmmr=diryyr+'\m'+iif(month(dtr)<10, '0'+str(month(dtr), 1), str(month(dtr), 2))
  pathddr=dirmmr+'\d'+iif(day(dtr)<10, '0'+str(day(dtr), 1), str(day(dtr), 2))+'\'
  if (file(pathddr+'mkost.dbf'))
    if (!file(pathddr+'mkost.cdx'))
      sele 0
      use (pathddr+'mkost.dbf') excl
      inde on str(sk, 3)+str(mntov, 7) tag t1
      CLOSE
    endif

    sele 0
    use (pathddr+'mkost.dbf') share
    set orde to tag t1
    if (select('tmkost')#0)
      sele tmkost
      CLOSE
    endif

    crtt('tmkost', 'f:sk c:n(3) f:mntov c:n(7) f:osndb c:n(12,3)')
    sele 0
    use tmkost
    inde on str(sk, 3)+str(mntov, 7) tag t1

    pathmr=gcPath_e+'\g'+str(year(gdTd), 4)+'\m'+iif(month(gdTd)<10, '0'+str(month(gdTd), 1), str(month(gdTd), 2))+'\'
    sele cskl
    go top
    while (!eof())
      if (!(ent=gnEnt.and.rasc=1))
        skip
        loop
      endif

      pathr=pathmr+alltrim(path)
      if (!netfile('tov', 1))
        skip
        loop
      endif

      skr=sk
      netuse('tov',,, 1)
      while (!eof())
        osn_r=osn
        mntovr=mntov
        mntovtr=getfield('t1', 'mntovr', 'ctov', 'mntovt')
        if (mntovtr#0)
          mntovr=mntovtr
        endif

        sele mkost
        seek str(skr, 3)+str(mntovr, 7)
        if (foun())
          sele tmkost
          seek str(skr, 3)+str(mntovr, 7)
          if (!foun())
            appe blank
            repl sk with skr,  ;
             mntov with mntovr
          endif

          repl osndb with osndb+osn_r
        endif

        sele tov
        skip
      enddo

      nuse('tov')
      sele cskl
      skip
    enddo

    /*   if !file(pathddr+'mkpr.cdx') */
    sele 0
    use (pathddr+'mkpr.dbf') excl
    inde on str(sk, 3)+str(mn, 7)+str(mntov, 7) tag t1
    inde on str(sk, 3)+str(mntov, 7) tag t2
    CLOSE
    /*   endif */
    sele 0
    use (pathddr+'mkpr.dbf') share
    set orde to tag t1

    /*   if !file(pathddr+'mkrs.cdx') */
    sele 0
    use (pathddr+'mkrs.dbf') excl
    inde on str(sk, 3)+str(ttn, 7)+str(mntov, 7) tag t1
    inde on str(sk, 3)+str(mntov, 7) tag t2
    CLOSE
    /*   endif */
    sele 0
    use (pathddr+'mkrs.dbf') share
    set orde to tag t1
    /********************************* */
    diryypr=dirmkr+'\g'+str(year(dtpr), 4)
    dirmmpr=diryypr+'\m'+iif(month(dtpr)<10, '0'+str(month(dtpr), 1), str(month(dtpr), 2))
    pathddpr=dirmmpr+'\d'+iif(day(dtpr)<10, '0'+str(day(dtpr), 1), str(day(dtpr), 2))+'\'
    if (file(pathddpr+'mkost.dbf'))
      if (!file(pathddpr+'mkost.cdx'))
        sele 0
        use (pathddpr+'mkost.dbf') alias mkostp excl
        inde on str(sk, 3)+str(mntov, 7) tag t1
        CLOSE
      endif

      sele 0
      use (pathddpr+'mkost.dbf') alias mkostp share
      set orde to tag t1
      /*      if !file(pathddpr+'mkpr.cdx') */
      sele 0
      use (pathddpr+'mkpr.dbf') alias mkprp excl
      inde on str(sk, 3)+str(mn, 7)+str(mntov, 7) tag t1
      inde on str(sk, 3)+str(mntov, 7) tag t2
      CLOSE
      /*      endif */
      sele 0
      use (pathddpr+'mkpr.dbf') alias mkprp share
      set orde to tag t1

      /*      if !file(pathddpr+'mkrs.cdx') */
      sele 0
      use (pathddpr+'mkrs.dbf') alias mkrsp excl
      inde on str(sk, 3)+str(ttn, 7)+str(mntov, 7) tag t1
      inde on str(sk, 3)+str(mntov, 7) tag t2
      CLOSE
      /*      endif */
      sele 0
      use (pathddpr+'mkrs.dbf') alias mkrsp share
      set orde to tag t1
    endif

    /********************************* */
    sele mkost
    go top
    rcmkostr=recn()
    fldnomr=1
    forost_r='.t.'
    forostr=forost_r
    while (.t.)
      sele mkost
      go rcmkostr
      foot('F2,F4,F5,F9,F10', 'Коррекции,ПрКорр,РсКорр,Приход,Расход')
      rcmkostr=slce('mkost', 1, 1, 18,, "e:sk h:'Скл' c:n(3) e:mntov h:'Код' c:n(7) e:nat h:'Наименование' c:c(40) e:nei h:'Еизм' c:c(4) e:cenpr h:'Прайс' c:n(10,3) e:c08 h:'ПрайсБб' c:n(10,3) e:cenbb h:'Бутылка' c:n(10,3) e:osn h:'ОстНФ' c:n(10,3) e:getfield('t1','mkost->sk,mkost->mntov','tmkost','osndb') h:'ОстНБД' c:n(10,3) e:osfon h:'ОстНO' c:n(10,3) e:prpp h:'ПрПрП' c:n(10,3) e:rspp h:'РсПрП' c:n(10,3) e:prdd h:'ПрДД' c:n(10,3) e:rsdd h:'РсДД' c:n(10,3) e:osfond h:'ОстНД' c:n(10,3) e:osfondch h:'ОстНДP' c:n(10,3) e:prc h:'ПрКорр' c:n(10,3) e:rsc h:'РсКорр' c:n(10,3) e:pr h:'Пр' c:n(10,3) e:rs h:'Рс' c:n(10,3) e:osfotd h:'ОстКД' c:n(10,3) e:prpd h:'ПрПоП' c:n(10,3) e:rspd h:'РсПоП' c:n(10,3) e:osfoch h:'Ост' c:n(10,3) e:osfodb h:'ОстБД' c:n(10,3) e:vesp h:'Vesp' c:n(10,3) e:keip h:'Keip' c:n(10,3) e:upak h:'Упак' c:n(10,3) e:kfc h:'Коэф' c:n(10,3)",,, 1,, forostr,, 'Остатки на '+dtoc(dtr), 1, 2)
      if (lastkey()=K_ESC)
        exit
      endif

      sele mkost
      go rcmkostr
      skr=sk
      pathmr=gcPath_e+'g'+str(year(dtr), 4)+'\m'+iif(month(dtr)<10, '0'+str(month(dtr), 1), str(month(dtr), 2))+'\'
      path_r=getfield('t1', 'skr', 'cskl', 'path')
      pathskr=pathmr+alltrim(path_r)
      sele mkost
      mntovr=mntov
      natr=nat
      neir=nei
      vespr=vesp
      keipr=keip
      cenprr=cenpr
      c08r=c08
      cenbbr=cenbb
      upakr=upak
      kfcr=kfc
      osnr=osn
      prppr=prpp
      rsppr=rspp
      osfonr=osfon
      prddr=prdd
      rsddr=rsdd
      osfondchr=osfondch
      osfondr=osfond
      prcr=prc
      rscr=rsc
      prr=pr
      rsr=rs
      osfotdr=osfotd
      rspdr=rspd
      prpdr=prpd
      osfochr=osfoch
      osfodbr=osfodb
      do case
      case (lastkey()=19) // Left
        fldnomr=fldnomr-1
        if (fldnomr=0)
          fldnomr=1
        endif

      case (lastkey()=4)  // Right
        fldnomr=fldnomr+1
      case (lastkey()=-1) // Коррекции
        if (forostr=forost_r)
          forostr='prc#0.or.rsc#0'
        else
          forostr=forost_r
        endif

      case (lastkey()=-3) // ПрКорр
        prc()
      case (lastkey()=-4) // РсКорр
        rsc()
      case (lastkey()=-8) // Приход
        mkpr()
      case (lastkey()=-38)// Приход
        mkpr(1)
      case (lastkey()=-9) // Расход
        mkrs()
      case (lastkey()=-39)// Расход
        mkrs(1)
      endcase

    enddo

    nuse('mkost')
    nuse('mkpr')
    nuse('mkrs')
    nuse('mkostp')
    nuse('mkprp')
    nuse('mkrsp')
  endif

  nuse('tmkost')
  erase tmkost.dbf
  erase tmkost.cdx
  return (.t.)

/************* */
function mkpr(p1)
  /************* */
  sele mkpr
  copy stru to stmkpr exte
  sele 0
  use stmkpr
  appe blank
  repl field_name with 'kfdb', ;
   field_type with 'n',        ;
   field_len with 10,          ;
   field_dec with 3
  appe blank
  repl field_name with 'dprdb', ;
   field_type with 'd',         ;
   field_len with 10
  appe blank
  repl field_name with 'dob', ;
   field_type with 'n',       ;
   field_len with 1
  CLOSE
  create tmkpr from stmkpr
  erase stmkpr.dbf
  sele tmkpr
  appe from (pathddr+'mkpr.dbf') for sk=skr.and.mntov=mntovr.and.dpr=dtr
  CLOSE
  sele 0
  use tmkpr
  inde on str(sk, 3)+str(mn, 7)+str(mntov, 7) tag t1

  pathr=pathskr
  netuse('pr1',,, 1)
  netuse('pr2',,, 1)
  sele tmkpr
  go top
  while (!eof())
    mnr=mn
    mntovr=mntov
    dprr=dpr
    dpr_r=getfield('t2', 'mnr', 'pr1', 'dpr')
    sele tmkpr
    repl dprdb with dpr_r
    sele pr2
    if (netseek('t1', 'mnr'))
      while (mn=mnr)
        mntov_r=mntov
        kf_r=kf
        mntovt_r=getfield('t1', 'mntov_r', 'ctov', 'mntovt')
        if (mntovt_r=0)
          mntovt_r=mntov_r
        endif

        if (mntovt_r=mntovr)
          sele tmkpr
          repl kfdb with kfdb+kf_r
        endif

        sele pr2
        skip
      enddo

    endif

    sele tmkpr
    skip
  enddo

  sele pr1
  go top
  while (!eof())
    if (empty(p1))
      if (dpr#dtr)
        skip
        loop
      endif

    endif

    mnr=mn
    ndr=nd
    ddcr=ddc
    kopr=kop
    dprr=dpr
    sele tmkpr
    seek str(skr, 3)+str(mnr, 7)
    if (!foun())
      sele pr2
      if (netseek('t1', 'mnr'))
        while (mn=mnr)
          mntov_r=mntov
          kf_r=kf
          zen_r=zen
          mntovt_r=getfield('t1', 'mntov_r', 'ctov', 'mntovt')
          if (mntovt_r=0)
            mntovt_r=mntov_r
          endif

          if (mntovt_r=mntovr)
            sele tmkpr
            seek str(skr, 3)+str(mnr, 7)+str(mntovr, 7)
            if (!foun())
              appe blank
              repl sk with skr,   ;
               mn with mnr,       ;
               nd with ndr,       ;
               mntov with mntovr, ;
               ddc with ddcr,     ;
               dprdb with dprr,   ;
               dpr with dprr,     ;
               zen with zen_r,    ;
               kop with kopr,     ;
               dob with 1
            endif

            repl kfdb with kfdb+kf_r
          /*               if dob=1
           *                  repl kf with kf+kf_r
           *               endif
           */
          endif

          sele pr2
          skip
        enddo

      endif

    endif

    sele pr1
    skip
  enddo

  nuse('pr1')
  nuse('pr2')

  sele tmkpr
  go top
  rcmkprr=recn()
  while (.t.)
    sele tmkpr
    go rcmkprr
    set cent off
    if (empty(p1))
      rcmkprr=slcf('tmkpr',,,,, "e:nd h:'Ном' c:n(7) e:mn h:'МНом' c:n(7) e:ddc h:'ДСозд' c:d(8) e:kop h:'КОП' c:n(3) e:kf h:'Кол-во' c:n(10,3) e:kfdb h:'КолБД' c:n(10,3) e:dcl h:'Дл' c:n(10,3) e:zen h:'Цена' c:n(8,3) e:dprdb h:'Дата' c:d(8)",,,,, 'sk=skr.and.mntov=mntovr.and.dpr=dtr',, 'ПРИХОД')
    else
      rcmkprr=slcf('tmkpr',,,,, "e:nd h:'Ном' c:n(7) e:mn h:'МНом' c:n(7) e:ddc h:'ДСозд' c:d(8) e:kop h:'КОП' c:n(3) e:kf h:'Кол-во' c:n(10,3) e:kfdb h:'КолБД' c:n(10,3) e:dcl h:'Дл' c:n(10,3) e:zen h:'Цена' c:n(8,3) e:dprdb h:'Дата' c:d(8)",,,,, 'sk=skr.and.mntov=mntovr',, 'ПРИХОД ВЕСЬ')
    endif

    set cent on
    if (lastkey()=K_ESC)
      exit
    endif

  enddo

  sele tmkpr
  CLOSE
  return (.t.)

/************* */
function mkrs(p1)
  /************* */
  sele mkrs
  copy stru to stmkrs exte
  sele 0
  use stmkrs
  appe blank
  repl field_name with 'kvpdb', ;
   field_type with 'n',         ;
   field_len with 10,           ;
   field_dec with 3
  appe blank
  repl field_name with 'dopdb', ;
   field_type with 'd',         ;
   field_len with 10
  appe blank
  repl field_name with 'dob', ;
   field_type with 'n',       ;
   field_len with 1
  CLOSE
  create tmkrs from stmkrs
  erase stmkrs.dbf
  sele tmkrs
  appe from (pathddr+'mkrs.dbf') for sk=skr.and.mntov=mntovr.and.dop=dtr
  CLOSE
  sele 0
  use tmkrs
  inde on str(sk, 3)+str(ttn, 7)+str(mntov, 7) tag t1

  pathr=pathskr
  netuse('rs1',,, 1)
  netuse('rs2',,, 1)
  sele tmkrs
  go top
  while (!eof())
    ttnr=ttn
    mntovr=mntov
    dopr=dop
    dop_r=getfield('t1', 'ttnr', 'rs1', 'dop')
    sele tmkrs
    repl dopdb with dop_r
    sele rs2
    if (netseek('t1', 'ttnr'))
      while (ttn=ttnr)
        mntov_r=mntov
        kvp_r=kvp
        mntovt_r=getfield('t1', 'mntov_r', 'ctov', 'mntovt')
        if (mntovt_r=0)
          mntovt_r=mntov_r
        endif

        if (mntovt_r=mntovr)
          sele tmkrs
          repl kvpdb with kvpdb+kvp_r
        endif

        sele rs2
        skip
      enddo

    endif

    sele tmkrs
    skip
  enddo

  sele rs1
  go top
  while (!eof())
    if (empty(p1))
      if (dop#dtr)
        skip
        loop
      endif

    endif

    ttnr=ttn
    ddcr=ddc
    kopr=kop
    dopr=dop
    sele tmkrs
    seek str(skr, 3)+str(ttnr, 7)
    if (!foun())
      sele rs2
      if (netseek('t1', 'ttnr'))
        while (ttn=ttnr)
          mntov_r=mntov
          kvp_r=kvp
          zen_r=zen
          mntovt_r=getfield('t1', 'mntov_r', 'ctov', 'mntovt')
          if (mntovt_r=0)
            mntovt_r=mntov_r
          endif

          if (mntovt_r=mntovr)
            sele tmkrs
            seek str(skr, 3)+str(ttnr, 7)+str(mntovr, 7)
            if (!foun())
              appe blank
              repl sk with skr,   ;
               ttn with ttnr,     ;
               mntov with mntovr, ;
               ddc with ddcr,     ;
               dopdb with dopr,   ;
               dop with dopr,     ;
               zen with zen_r,    ;
               kop with kopr,     ;
               dob with 1
            endif

            repl kvpdb with kvpdb+kvp_r
          /*               if dob=1
           *                  repl kvp with kvp+kvp_r
           *               endif
           */
          endif

          sele rs2
          skip
        enddo

      endif

    endif

    sele rs1
    skip
  enddo

  nuse('rs1')
  nuse('rs2')

  sele tmkrs
  go top
  rcmkrsr=recn()
  while (.t.)
    sele tmkrs
    go rcmkrsr
    set cent off
    if (empty(p1))
      rcmkprr=slcf('tmkrs',,,,, "e:ttn h:'Ном' c:n(7) e:ddc h:'ДСозд' c:d(8) e:kop h:'КОП' c:n(3) e:kvp h:'Кол-во' c:n(10,3) e:kvpdb h:'КолБД' c:n(10,3) e:dcl h:'Дл' c:n(10,3) e:zen h:'Цена' c:n(8,3) e:dopdb h:'Дата' c:d(8)",,,,, 'sk=skr.and.mntov=mntovr.and.dop=dtr',, 'РАСХОД')
    else
      rcmkprr=slcf('tmkrs',,,,, "e:ttn h:'Ном' c:n(7) e:ddc h:'ДСозд' c:d(8) e:kop h:'КОП' c:n(3) e:kvp h:'Кол-во' c:n(10,3) e:kvpdb h:'КолБД' c:n(10,3) e:dcl h:'Дл' c:n(10,3) e:zen h:'Цена' c:n(8,3) e:dopdb h:'Дата' c:d(8)",,,,, 'sk=skr.and.mntov=mntovr',, 'РАСХОД ВЕСЬ')
    endif

    set cent on
    if (lastkey()=K_ESC)
      exit
    endif

  enddo

  sele tmkrs
  CLOSE
  return (.t.)

/************** */
function grbrnd()
  /************** */
  sele grbrnd
  if (!netseek('t1', 'mkeepr'))
    netadd()
    ngrbrandr='Не определена'
    netrepl('mkeep,grbrand,ngrbrand', 'mkeepr,0,ngrbrandr')
    go top
  endif

  rcgrbrndr=recn()
  while (.t.)
    sele grbrnd
    go rcgrbrndr
    foot('INS,DEL,F4', 'Доб,Уд,Корр')
    rcgrbrndr=slcf('grbrnd', 1, 30,,, "e:grbrand h:'Код' c:n(2) e:ngrbrand h:'Наименование' c:с(40)",,,, 'mkeep=mkeepr',,, 'Кросс группы')
    if (lastkey()=K_ESC)
      exit
    endif

    go rcgrbrndr
    grbrandr=grbrand
    ngrbrandr=ngrbrand
    do case
    case (lastkey()=K_INS)   // Добавить
      grbrndins()
    case (lastkey()=K_DEL)    // Удалить
      if (gnAdm=1)
        netdel()
      else
        if (grbrandr#0)
          netdel()
        endif

      endif

      skip -1
      if (bof())
        go top
      endif

      rcgrbrndr=recn()
    case (lastkey()=-3)   // Коррекция
      grbrndins(1)
    endcase

  enddo

  return (.t.)

/***************** */
function grbrndins(p1)
  /*************** */
  wgrbrndr=nwopen(10, 10, 14, 70, 1, 'gr+/b,n/w')
  if (empty(p1))
    grbrandr=0
    ngrbrandr=space(40)
  endif

  while (.t.)
    if (empty(p1))
      @ 0, 1 say 'Группа' get grbrandr pict '99'
      read
      if (lastkey()=K_ESC)
        exit
      endif

    else
      @ 0, 1 say 'Группа'+' '+str(grbrandr, 2)
    endif

    @ 1, 1 say 'Наименование ' get ngrbrandr
    read
    if (lastkey()=K_ESC)
      exit
    endif

    @ 2, 40 prom 'Верно'
    @ 2, col()+1 prom 'Не верно'
    menu to vn
    if (lastkey()=K_ESC)
      exit
    endif

    if (vn=1)
      sele grbrnd
      if (!netseek('t1', 'mkeepr,grbrandr'))
        netadd()
        netrepl('mkeep,grbrand', 'mkeepr,grbrandr')
      endif

      netrepl('ngrbrand', 'ngrbrandr')
      rcgrbrndr=recn()
    endif

    exit
  enddo

  wclose(wgrbrndr)
  return (.t.)

/************ */
function gbrn()
  /************ */
  wselect(0)
  sele grbrnd
  if (!netseek('t1', 'mkeepr,grbrandr').or.grbrandr=0)
    go top
    rcr=recn()
    while (.t.)
      sele grbrnd
      go rcr
      foot('Enter', 'Выбор')
      rcr=slcf('grbrnd', 10, 10,,, "e:grbrand h:'Код' c:n(2) e:ngrbrand h:'Наименование' c:с(40)",,,, 'mkeep=mkeepr',,, 'Кросс группы')
      if (lastkey()=K_ESC)
        exit
      endif

      go rcr
      grbrandr=grbrand
      ngrbrandr=ngrbrand
      if (lastkey()=K_ENTER)
        exit
      endif

    enddo

  endif

  wselect(wmkcr)
  return (.t.)

/*********** */
function prc()
  /*********** */

  sele mkost
  copy to tprc for sk=skr.and.mntov=mntovr.and.(prc#0.or.rsc#0)
  sele 0
  use tprc excl
  inde on str(sk, 3)+str(mntov, 7) tag t1

  sele mkpr
  copy stru to tmkpr
  sele 0
  use tmkpr excl
  inde on str(sk, 3)+str(mn, 7)+str(mntov, 7) tag t1

  sele mkpr
  set orde to tag t2
  if (netseek('t2', 'skr,mntovr'))
    while (sk=skr.and.mntov=mntovr)
      mnr=mn
      if (netseek('t1', 'skr,mntovr', 'tprc'))
        sele mkpr
        arec:={}
        getrec()
        sele tmkpr
        netadd()
        putrec()
      endif

      sele mkpr
      skip
    enddo

  endif

  sele mkprp
  copy stru to tmkprp
  sele 0
  use tmkprp excl
  inde on str(sk, 3)+str(mn, 7)+str(mntov, 7) tag t1
  sele mkprp
  set orde to tag t2
  if (netseek('t2', 'skr,mntovr'))
    while (sk=skr.and.mntov=mntovr)
      mnr=mn
      if (netseek('t1', 'skr,mntovr', 'tprc'))
        sele mkprp
        arec:={}
        getrec()
        sele tmkprp
        netadd()
        putrec()
      endif

      sele mkprp
      skip
    enddo

  endif

  if (select('tpr')#0)
    sele tpr
    CLOSE
  endif

  crtt('tpr', 'f:sk c:n(3) f:mn c:n(7) f:mntov c:n(7) f:dprp c:d(10)  f:dprt c:d(10) f:kfp c:n(10,3) f:kft c:n(10,3) f:sc c:n(1) f:ddc c:d(10) f:tdc c:c(8)')
  sele 0
  use tpr excl
  inde on str(sk, 3)+str(mn, 7)+str(mntov, 7) tag t1

  sele tmkpr
  go top
  while (!eof())
    skr=sk
    mnr=mn
    mntovr=mntov
    kftr=kf
    dprtr=dpr
    ddcr=ddc
    tdcr=tdc
    sele tmkprp
    if (!netseek('t1', 'skr,mnr,mntovr'))
      if (dprtr<dtr)
        sele tpr
        netadd()
        repl sk with skr,   ;
         mn with mnr,       ;
         mntov with mntovr, ;
         kft with kftr,     ;
         dprt with dprtr,   ;
         ddc with ddcr,     ;
         tdc with tdcr,     ;
         sc with 1
      endif

    else
      kfpr=kf
      dprpr=dpr
      if (kftr#kfpr.or.dprtr#dprpr)
        sele tpr
        appe blank
        repl sk with skr,   ;
         mn with mnr,       ;
         mntov with mntovr, ;
         kft with kftr,     ;
         dprt with dprtr,   ;
         kfp with kfpr,     ;
         dprp with dprpr,   ;
         ddc with ddcr,     ;
         tdc with tdcr,     ;
         sc with 2
      endif

    endif

    sele tmkpr
    skip
  enddo

  sele tmkprp
  go top
  while (!eof())
    skr=sk
    mnr=mn
    mntovr=mntov
    kfpr=kf
    dprpr=dpr
    ddcr=ddc
    tdcr=tdc
    sele tmkpr
    if (!netseek('t1', 'skr,mnr,mntovr'))
      sele tpr
      appe blank
      repl sk with skr,   ;
       mn with mnr,       ;
       mntov with mntovr, ;
       kfp with kfpr,     ;
       dprp with dprpr,   ;
       ddc with ddcr,     ;
       tdc with tdcr,     ;
       sc with 3
    else
      kftr=kf
      /*      dprtr=dpr */
      dprtr=dpr
      if (kftr#kfpr.or.dprtr#dprpr)
        sele tpr
        appe blank
        repl sk with skr,   ;
         mn with mnr,       ;
         mntov with mntovr, ;
         kft with kftr,     ;
         dprt with dprtr,   ;
         kfp with kfpr,     ;
         dprp with dprpr,   ;
         ddc with ddcr,     ;
         tdc with tdcr,     ;
         sc with 4
      endif

    endif

    sele tmkprp
    skip
  enddo

  sele tpr
  go top
  rctprr=recn()
  while (.t.)
    sele tpr
    go rctprr
    foot('', '')
    rctprr=slcf('tpr',,,,, "e:sk h:'Скл' c:n(3) e:mn h:'MN' c:n(7) e:mntov h:'Код Тов' c:n(7) e:dprp h:'ДатаП' c:d(10) e:dprt h:'ДатаТ' c:d(10) e:kfp h:'Кол П' c:n(10,3) e:kft h:'Кол Т' c:n(10,3)",,,,,,, 'Коррекции прихода')
    if (lastkey()=K_ESC)
      exit
    endif

  enddo

  sele tprc
  CLOSE
  /*erase tprc.dbf
   *erase tprc.cdx
   */

  sele tmkpr
  CLOSE
  /*erase tmkpr.dbf
   *erase tmkpr.cdx
   */

  sele tmkprp
  CLOSE
  /*erase tmkprp.dbf
   *erase tmkprp.cdx
   */
  return (.t.)

  sele tpr
  CLOSE
  /*erase tpr.dbf
   *erase tpr.cdx
   */

RETURN (NIL)

/*********** */
function rsc()
  /*********** */
  sele mkost
  copy to tprc for sk=skr.and.mntov=mntovr.and.(prc#0.or.rsc#0)
  sele 0
  use tprc excl
  inde on str(sk, 3)+str(mntov, 7) tag t1

  if (select('tsk')#0)
    sele tsk
    CLOSE
  endif

  crtt('tsk', 'f:sk c:n(3)')
  sele 0
  use tsk excl

  sele mkrs
  copy stru to tmkrs
  sele 0
  use tmkrs excl
  inde on str(sk, 3)+str(ttn, 7)+str(mntov, 7) tag t1
  sele mkrs
  set orde to tag t2
  if (netseek('t2', 'skr,mntovr'))
    while (sk=skr.and.mntov=mntovr)
      ttnr=ttn
      if (netseek('t1', 'skr,mntovr', 'tprc'))
        sele mkrs
        arec:={}
        getrec()
        sele tmkrs
        netadd()
        putrec()
      endif

      sele mkrs
      skip
    enddo

  endif

  sele mkrsp
  copy stru to tmkrsp
  sele 0
  use tmkrsp excl
  inde on str(sk, 3)+str(ttn, 7)+str(mntov, 7) tag t1

  sele mkrsp
  set orde to tag t2
  if (netseek('t2', 'skr,mntovr'))
    while (sk=skr.and.mntov=mntovr)
      ttnr=ttn
      mntovr=mntov
      if (netseek('t1', 'skr,mntovr', 'tprc'))
        sele mkrsp
        arec:={}
        getrec()
        sele tmkrsp
        netadd()
        putrec()
      endif

      sele mkrsp
      skip
    enddo

  endif

  if (select('trs')#0)
    sele trs
    CLOSE
  endif

  crtt('trs', 'f:sk c:n(3) f:ttn c:n(7) f:mntov c:n(7) f:dopp c:d(10)  f:dopt c:d(10) f:kvpp c:n(10,3) f:kvpt c:n(10,3) f:sc c:n(1) f:ddc c:d(10) f:tdc c:c(8)')
  sele 0
  use trs excl
  inde on str(sk, 3)+str(ttn, 7)+str(mntov, 7) tag t1

  sele tmkrs
  go top
  while (!eof())
    skr=sk
    ttnr=ttn
    mntovr=mntov
    kvptr=kvp
    doptr=dop
    ddcr=ddc
    tdcr=tdc
    sele tmkrsp
    if (!netseek('t1', 'skr,ttnr,mntovr'))
      if (doptr<dtr)
        sele trs
        appe blank
        repl sk with skr,   ;
         ttn with ttnr,     ;
         mntov with mntovr, ;
         kvpt with kvptr,   ;
         dopt with doptr,   ;
         ddc with ddcr,     ;
         tdc with tdcr,     ;
         sc with 1
      endif

    else
      kvppr=kvp
      doppr=dop
      if (kvptr#kvppr.or.doptr#doppr)
        sele trs
        appe blank
        repl sk with skr,   ;
         ttn with ttnr,     ;
         mntov with mntovr, ;
         kvpt with kvptr,   ;
         dopt with doptr,   ;
         kvpp with kvppr,   ;
         dopp with doppr,   ;
         ddc with ddcr,     ;
         tdc with tdcr,     ;
         sc with 2
      endif

    endif

    sele tmkrs
    skip
  enddo

  sele tmkrsp
  go top
  while (!eof())
    skr=sk
    ttnr=ttn
    mntovr=mntov
    kvppr=kvp
    doppr=dop
    ddcr=ddc
    tdcr=tdc
    sele tmkrs
    if (!netseek('t1', 'skr,ttnr,mntovr'))
      sele trs
      appe blank
      repl sk with skr,   ;
       ttn with ttnr,     ;
       mntov with mntovr, ;
       kvpp with kvppr,   ;
       dopp with doppr,   ;
       ddc with ddcr,     ;
       tdc with tdcr,     ;
       sc with 3
    else
      kvptr=kvp
      doptr=dop
      if (kvptr#kvppr.or.doptr#doppr)
        sele trs
        appe blank
        repl sk with skr,   ;
         ttn with ttnr,     ;
         mntov with mntovr, ;
         kvpt with kvptr,   ;
         dopt with doptr,   ;
         kvpp with kvppr,   ;
         dopp with doppr,   ;
         ddc with ddcr,     ;
         tdc with tdcr,     ;
         sc with 4
      endif

    endif

    sele tmkrsp
    skip
  enddo

  sele trs
  go top
  rctrsr=recn()
  while (.t.)
    sele trs
    go rctrsr
    foot('', '')
    rctprr=slcf('trs',,,,, "e:sk h:'Скл' c:n(3) e:ttn h:'TTN' c:n(7) e:mntov h:'Код Тов' c:n(7) e:dopp h:'ДатаП' c:d(10) e:dopt h:'ДатаТ' c:d(10) e:kvpp h:'Кол П' c:n(10,3) e:kvpt h:'Кол Т' c:n(10,3) e:sc h:'T' c:n(1) e:ddc h:'ДатаС' c:d(10) e:tdc h:'ВремяС' c:c(8)",,,,,,, 'Коррекции расхода')
    if (lastkey()=K_ESC)
      exit
    endif

  enddo

  sele tsk
  CLOSE

  sele tprc
  CLOSE
  /*erase tprc.dbf
   *erase tprc.cdx
   */

  sele tmkrs
  CLOSE
  /*erase tmkrs.dbf
   *erase tmkrs.cdx
   */

  sele tmkrsp
  CLOSE
  /*erase tmkrsp.dbf
   *erase tmkrsp.cdx
   */

  sele trs
  CLOSE
  /*erase trs.dbf
   *erase trs.cdx
   */
  return (.t.)

/*****************************************************************
 
 FUNCTION:
 АВТОР..ДАТА..........С. Литовка  06-30-20 * 10:07:20am
 НАЗНАЧЕНИЕ.........
 ПАРАМЕТРЫ..........
 ВОЗВР. ЗНАЧЕНИЕ....
 ПРИМЕЧАНИЯ.........
 */
STATIC FUNCTION ChoiceGGrp()
  LOCAL ln_kg_r
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
    ln_kg_r=kgr
    do case
    case (lastkey()=K_ENTER)
      exit
    case (lastkey()=K_ESC)
      ln_kg_r:=nil
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
  rest scre from sccgrp
  RETURN (ln_kg_r)
