#include "common.ch"
#include "inkey.ch"

/* Поставщики */
clea
netuse('kps')
netuse('kpsmk')
netuse('kln')
netuse('mkeep')
netuse('pstgpl')
netuse('kgpcat')
netuse('kgppst')
netuse('cskl')
netuse('ctov')
netuse('kgp')

for_r=".t."
forr=for_r
sele kps
go top
rckpsr=recn()
while (.t.)
  sele kps
  go rckpsr
  foot('INS,DEL,ENTER,F2,F3', 'Доб,Уд,МД,Категории,Грузополучатели')
  rckpsr=slcf('kps', 1, 1, 18,, "e:kps h:'Код' c:n(7) e:getfield('t1','kps->kps','kln','nkl') h:'Наименование' c:c(30) e:ndogt h:'N ДогТ' c:c(10) e:ddogt h:'ДатаДогТ' c:d(10)",,, 1,, forr,, 'Поставщики')
  if (lastkey()=27)
    exit
  endif

  sele kps
  go rckpsr
  kpsr=kps
  prbbr=prbb
  ndogtr=ndogt
  ddogtr=ddogt
  nkpsr=getfield('t1', 'kpsr', 'kln', 'nkl')
  do case
  case (lastkey()=22.and.gnEntrm=0)// INS
    kpsins()
  case (lastkey()=-3.and.gnEntrm=0)// CORR
    kpsins(1)
  case (lastkey()=7.and.gnEntrm=0) // DEL
    sele kpsmk
    if (netseek('t1', 'kpsr'))
      while (kps=kpsr)
        netdel()
        skip
      enddo

    endif

    sele kps
    netdel()
    skip -1
    if (bof())
      go top
    endif

    rckpsr=recn()
  case (lastkey()=13)
    save scre to sc1
    kpsmk()
    rest scre from sc1
  case (lastkey()=-1)     // Категории
    pstgpl()
  case (lastkey()=-2)     // Грузополучатели
    kgppst()
  endcase

enddo

nuse()

/**************** */
function kpsins(p1)
  /**************** */
  if (empty(p1))
    kps_r=0
    prbb_r=0
    ndogt_r=space(10)
    ddogt_r=ctod('')
  else
    kps_r=kpsr
    prbb_r=prbbr
    ndogt_r=ndogtr
    ddogt_r=ddogtr
  endif

  sckps=setcolor('gr+/b,n/w')
  wkps=wopen(8, 20, 13, 60)
  wbox(1)
  while (.t.)
    if (empty(p1))
      @ 0, 1 say 'Поставщик   ' get kps_r pict '9999999'
    else
      @ 0, 1 say 'Поставщик   '+str(kps_r, 7)
    endif

    @ 1, 1 say 'Прих без бут' get prbb_r pict '9'
    @ 2, 1 say 'Ном дог тары' get ndogt_r
    @ 3, 1 say 'Дата дог тар' get ddogt_r
    read
    if (lastkey()=27)
      exit
    endif

    if (lastkey()=13)
      if (!netseek('t1', 'kps_r', 'kln'))
        wmess('Нет в справочнике клиентов')
        loop
      endif

      if (getfield('t1', 'kps_r', 'kln', 'kkl1')=0)
        wmess('Нет кода ОКПО')
        loop
      endif

      sele kps
      if (empty(p1))
        if (!netseek('t1', 'kps_r'))
          netadd()
          netrepl('kps,prbb,ndogt,ddogt', 'kps_r,prbb_r,ndogt_r,ddogt_r')
          rckpsr=recn()
          exit
        else
          wmess('Уже существует')
        endif

      else
        netrepl('prbb,ndogt,ddogt', 'prbb_r,ndogt_r,ddogt_r')
        exit
      endif

    endif

  enddo

  wclose(wkps)
  setcolor(sckps)
  return (.t.)

/************* */
function kpsmk()
  /************* */
  sele kpsmk
  netseek('t1', 'kpsr')
  rckpsmkr=recn()
  formkr='kps=kpsr'
  while (.t.)
    sele kpsmk
    go rckpsmkr
    foot('INS,DEL', 'Добавить,Удалить')
    rckpsmkr=slcf('kpsmk', 1, 42,,, "e:mkeep h:'Код' c:n(3) e:getfield('t1','kpsmk->mkeep','mkeep','nmkeep') h:'Наименование' c:c(30)",,, 1,, formkr,, alltrim(nkpsr))
    if (lastkey()=27)
      exit
    endif

    go rckpsmkr
    do case
    case (lastkey()=22.and.gnEntrm=0)// INS
      kpsmkins()
    case (lastkey()=7.and.gnEntrm=0) // DEL
      netdel()
      skip -1
      if (bof().or.kps#kpsr)
        go top
      endif

      rckpsmkr=recn()
    endcase

  enddo

  return (.t.)

/***********************************************************
 * kpsmkins() -->
 *   Параметры :
 *   Возвращает:
 */
function kpsmkins()
  if (select('sl')#0)
    sele sl
    CLOSE
  endif

  sele 0
  use _slct alias sl excl
  zap
  sele mkeep
  go top
  rcmkr=recn()
  formker=".t..and.mkeep->mkeep#0"
  /*formker=".t..and.!netseek('t2','mkeep->mkeep','kpsmk').and.mkeep->mkeep#0" */
  while (.t.)
    foot('SPACE,ENTER', 'Отбор,Выполнить')
    sele mkeep
    go rcmkr
    mkeepr=slcf('mkeep',,,,, "e:mkeep h:'Код' c:n(3) e:nmkeep h:'Наименование' c:c(30)", 'mkeep', 1,,, formker,, 'Маркодержатели')
    if (lastkey()=27)
      exit
    endif

    sele mkeep
    locate for mkeep=mkeepr
    rcmkr=recn()
    if (lastkey()=13)
      sele sl
      go top
      while (!eof())
        mkeepr=val(kod)
        sele kpsmk
        if (!netseek('t1', 'kpsr,mkeepr'))
          netadd()
          netrepl('kps,mkeep', 'kpsr,mkeepr')
          rckpsmkr=recn()
        endif

        sele sl
        skip
      enddo

      exit
    endif

  enddo

  sele sl
  zap
  CLOSE
  return (.t.)

/************** */
function pstgpl()
  /************** */
  store 0 to rcpstgplr, rcpstgpl1r, rcpstgpl2r, rcpstgpl3r, levr, lev1r, lev2r, lev3r
  store '' to nlevr, nlev1r, nlev2r, nlev3r

  sele pstgpl
  if (!netseek('t1', 'kpsr,0,0,0'))
    netadd()
    netrepl('post', 'kpsr')
  endif

  rcpstgpl1r=recn()

  wl1r='post=kpsr'
  for1r='lev1#0.and.lev2=0'
  wl2r='post=kpsr.and.lev1=lev1r'
  for2r='lev2#0.and.lev3=0'
  wl3r='post=kpsr.and.lev1=lev1r.and.lev2=lev2r'
  for3r='lev3#0'

  prlevr=1
  wlr=wl1r
  forlr=for1r
  rcpstgplr=rcpstgpl1r
  while (.t.)
    sele pstgpl
    go rcpstgplr
    foot('ENTER', 'Выбрать')
    do case
    case (prlevr=1)
      rcpstgplr=slcf('pstgpl',,,,, "e:lev1 h:'Код' c:n(4) e:nlev1 h:'Наименование' c:c(70)",,,, wlr, forlr,, '')
    case (prlevr=2)
      rcpstgplr=slcf('pstgpl',,,,, "e:lev2 h:'Код' c:n(4) e:nlev2 h:'Наименование' c:c(70)",,,, wlr, forlr,, alltrim(nlev1r))
    case (prlevr=3)
      rcpstgplr=slcf('pstgpl',,,,, "e:lev3 h:'Код' c:n(4) e:kgpcat h:'CK' c:n(2) e:nlev3 h:'Наименование' c:c(70)",,,, wlr, forlr,, alltrim(nlev2r))
    endcase

    go rcpstgplr
    do case
    case (prlevr=1)
      levr=lev1
      nlevr=nlev1
      nlev1r=nlev1
      lev1r=lev1
    case (prlevr=2)
      levr=lev2
      nlevr=nlev2
      nlev2r=nlev2
      lev2r=lev2
    case (prlevr=3)
      levr=lev3
      nlevr=nlev3
      nlev3r=nlev3
      lev3r=lev3
    endcase

    kgpcatr=kgpcat
    do case
    case (lastkey()=27)
      do case
      case (prlevr=1)
        exit
      case (prlevr=2)
        prlevr=1
        rcpstgplr=rcpstgpl1r
        wlr=wl1r
        forlr=for1r
        nlevr=nlev1r
      case (prlevr=3)
        prlevr=2
        rcpstgplr=rcpstgpl2r
        wlr=wl2r
        forlr=for2r
        nlevr=nlev2r
      endcase

    case (lastkey()=13)
      do case
      case (prlevr=1.and.lev1#0)
        prlevr=2
        wlr=wl2r
        forlr=for2r
        sele pstgpl
        if (netseek('t1', 'kpsr,lev1r'))
          if (lev2=0)
            skip
          endif

          if (post=kpsr.and.lev1=lev1r.and.lev2#0)
            rcpstgpl2r=recn()
            rcpstgplr=recn()
          endif

        endif

      case (prlevr=2.and.lev2#0)
        prlevr=3
        wlr=wl3r
        forlr=for3r
        sele pstgpl
        if (netseek('t1', 'kpsr,lev1r,lev2r'))
          if (lev3=0)
            skip
          endif

          if (post=kpsr.and.lev1=lev1r.and.lev2=lev2r.and.lev3#0)
            rcpstgpl3r=recn()
            rcpstgplr=recn()
          endif

        endif

      endcase

    case (lastkey()=22.and.gnEntrm=0)// INS
      pstglins()
    case (lastkey()=-3.and.gnEntrm=0)// CORR
      if (!(lev1=0.and.lev2=0.and.lev3=0))
        pstglins(1)
      endif

    case (lastkey()=7.and.gnEntrm=0)// DEL
      if (!(lev1=0.and.lev2=0.and.lev3=0))
        netdel()
        skip -1
        rcpstgplr=recn()
      endif

    endcase

  enddo

  return (.t.)

/***************** */
function pstglins(p1)
  /***************** */
  if (empty(p1))
    lev_r=0
    nlev1_r=space(70)
    nlev2_r=space(70)
    nlev3_r=space(60)
    kgpcat_r=0
  else
    lev_r=levr
    nlev1_r=subs(nlevr, 1, 70)
    nlev2_r=subs(nlevr, 71, 70)
    nlev3_r=subs(nlevr, 141, 60)
    kgpcat_r=kgpcatr
  endif

  sclev=setcolor('gr+/b,n/w')
  wlev=wopen(8, 5, 15, 78)
  wbox(1)
  while (.t.)
    if (empty(p1))
      @ 0, 1 say 'Номер    ' get lev_r pict '9999'
    else
      @ 0, 1 say 'Номер    '+str(levr, 4)
    endif

    @ 1, 1 say 'Наименование'
    @ 2, 1 get nlev1_r
    @ 3, 1 get nlev2_r
    @ 4, 1 get nlev3_r
    if (prlevr=3)
      @ 5, 1 say 'Своя категория' get kgpcat_r pict '99' valid gpcat(5, 20)
      @ 5, 20 say getfield('t1', 'kgpcat_r', 'kgpcat', 'nkgpcat')
    endif

    read
    if (lastkey()=27)
      exit
    endif

    if (lastkey()=13.and.lev_r#0)
      nlev_r=alltrim(nlev1_r)+alltrim(nlev2_r)+alltrim(nlev3_r)
      if (empty(p1))
        do case
        case (prlevr=1)
          if (!netseek('t1', 'kpsr,lev_r,0,0'))
            netadd()
            netrepl('post,lev1,nlev1', 'kpsr,lev_r,nlev_r')
            rcpstgpl1r=recn()
            rcpstgplr=recn()
          endif

        case (prlevr=2)
          if (!netseek('t1', 'kpsr,lev1r,lev_r,0'))
            netadd()
            netrepl('post,lev1,lev2,nlev2', 'kpsr,lev1r,lev_r,nlev_r')
            rcpstgpl2r=recn()
            rcpstgplr=recn()
          endif

        case (prlevr=3)
          if (!netseek('t1', 'kpsr,lev1r,lev2r,lev_r'))
            netadd()
            netrepl('post,lev1,lev2,lev3,nlev3,kgpcat', 'kpsr,lev1r,lev2r,lev_r,nlev_r,kgpcat_r')
            rcpstgpl3r=recn()
            rcpstgplr=recn()
          endif

        endcase

      else
        do case
        case (prlevr=1)
          netrepl('nlev1', 'nlev_r')
        case (prlevr=2)
          netrepl('nlev2', 'nlev_r')
        case (prlevr=3)
          netrepl('nlev3,kgpcat', 'nlev_r,kgpcat_r')
        endcase

      endif

      exit
    endif

  enddo

  wclose(wlev)
  setcolor(sclev)
  return (.t.)

/*********************** */
function gpcat(p1, p2)
  /*********************** */
  local getlist:={}
  local row_r, col_r, nkgpcat_rr, als_rr
  als_rr=lower(alias())
  if (!empty(p1))
    row_rr=p1
  endif

  if (!empty(p2))
    col_rr=p2
  endif

  sele kgpcat
  if (kgpcat_r#0)
    if (!netseek('t1', 'kgpcat_r'))
      kgpcat_r=0
      nkgpcat_rr=space(20)
    else
      nkgpcat_rr=nkgpcat
    endif

  endif

  if (kgpcat_r=0)
    wwr=wselect(0)
    go top
    kgpcat_r=slcf('kgpcat',,,,, "e:kgpcat h:'Код' c:n(2) e:nkgpcat h:'Наименование' c:c(20)", 'kgpcat',,,,,, 'Категории ГП')
    wselect(wlev)
    nkgpcat_rr=getfield('t1', 'kgpcat_r', 'kgpcat', 'nkgpcat')
  endif

  if (!empty(nkgpcat_rr).and.col_rr#0)
    @ row_rr, col_rr say nkgpcat_rr
  else
    @ row_rr, col_rr say space(20)
  endif

  if (!empty(als_rr))
    sele (als_rr)
  endif

  return (.t.)

/************** */
function kgppst()
  /************** */
  sele kgppst
  set orde to tag t2
  if (netseek('t2', 'kpsr'))
    rcgppstr=recn()
  else
    rcgppstr=0
  endif

  gpfor_r='.t.'
  gpforr='.t.'
  kgp_r=0
  ngp_r=''
  while (.t.)
    sele kgppst
    set orde to tag t2
    go rcgppstr
    foot('F2,F3', 'Обновить,Фильтр')
    rcgppstr=slcf('kgppst',,,,, "e:kgp h:'ГП' c:n(7) e:getfield('t1','kgppst->kgp','kln','nkl') h:'Наименование' c:c(40) e:lev1 h:'LEV1' c:n(4) e:lev2 h:'LEV2' c:n(4) e:lev3 h:'LEV3' c:n(4) e:getfield('t1','kgppst->kgp','kgp','kgpcat') h:'CK' c:n(2)",,,, 'post=kpsr', gpforr,, '')
    if (lastkey()=27)
      exit
    endif

    go rcgppstr
    kgpr=kgp
    lev1r=lev1
    lev2r=lev2
    lev3r=lev3
    kgpcatr=kgpcat
    if (kgpcatr=0)
      kgpcatr=getfield('t1', 'kgpr', 'kgp', 'kgpcat')
      sele kgppst
      netrepl('kgpcat', 'kgpcatr')
    endif

    do case
    case (lastkey()=-1.and.gnEntrm=0)
      /*           kgppsto() */
      kgppsts()
      sele kgppst
      set orde to tag t2
      if (netseek('t2', 'kpsr'))
        rcgppstr=recn()
      else
        rcgppstr=0
      endif

    case (lastkey()=22.and.gnEntrm=0)// INS
      kgppsti()
    case (lastkey()=-3.and.gnEntrm=0)// CORR
      kgppsti(1)
    case (lastkey()=7.and.gnEntrm=0) // DEL
      netdel()
      skip -1
      if (post#kpsr)
        if (netseek('t2', 'kpsr'))
          rcgppstr=recn()
        else
          rcgppstr=0
        endif

      endif

      rcgppstr=recn()
    case (lastkey()=-2.and.gnEntrm=0)// Фильтр
      gppsflt()
    endcase

  enddo

  return (.t.)

/**************** */
function kgppsto()
  /**************** */
  save scre to sckp_r
  sele cskl
  go top
  while (!eof())
    if (!(ent=gnEnt.and.rasc=1))
      skip
      loop
    endif

    skr=sk
    pathr=gcPath_d+alltrim(path)
    mess(pathr)
    netuse('rs1',,, 1)
    netuse('rs2',,, 1)
    sele rs1
    go top
    while (!eof())
      if (vo#9)
        skip
        loop
      endif

      kgpr=kpv
      sele kgppst
      if (netseek('t2', 'kpsr,kgpr'))
        sele rs1
        skip
        loop
      endif

      sele rs1
      ttnr=ttn
      sele rs2
      prokr=0
      if (netseek('t1', 'ttnr'))
        while (ttn=ttnr)
          if (int(mntov/10000)<2)
            skip
            loop
          endif

          mntovr=mntov
          mkeepr=getfield('t1', 'mntovr', 'ctov', 'mkeep')
          if (mkeepr#0)
            sele kpsmk
            if (netseek('t1', 'kpsr,mkeepr'))
              prokr=1
              exit
            endif

          endif

          sele rs2
          skip
        enddo

      endif

      if (prokr=1)
        kgpcatr=getfield('t1', 'kgpr', 'kgp', 'kgpcat')
        sele pstgpl
        set orde to tag t2
        if (netseek('t1', 'kpsr,kgpcatr'))
          lev1r=lev1
          lev2r=lev2
          lev3r=lev3
        else
          lev1r=0
          lev2r=0
          lev3r=0
        endif

        set orde to tag t1
        sele kgppst
        if (!netseek('t2', 'kpsr,kgpr'))
          netadd()
          netrepl('post,kgp,kgpcat,lev1,lev2,lev3', 'kpsr,kgpr,kgpcatr,lev1r,lev2r,lev3r')
        endif

      endif

      sele rs1
      skip
    enddo

    nuse('rs1')
    nuse('rs2')
    sele cskl
    skip
  enddo

  rest scre from sckp_r
  return (.t.)

/***************** */
function kgppsti(p1)
  /***************** */
  if (empty(p1))
    store 0 to kgp_r, lev1_r, lev2_r, lev3_r, kgpcat_r
  else
    kgp_r=kgpr
    lev1_r=lev1r
    lev2_r=lev2r
    lev3_r=lev3r
    kgpcat_r=kgpcatr
  endif

  scgppr=setcolor('gr+/b,n/w')
  wgppr=wopen(8, 5, 15, 75)
  wbox(1)
  while (.t.)
    if (empty(p1))
      @ 0, 1 say 'Грузополучатель' get kgp_r pict '9999999' valid gpchk()
    else
      @ 0, 1 say 'Грузополучатель'+str(kgp_r, 7)
    endif

    read
    if (lastkey()=27)
      exit
    endif

    @ 1, 23 say getfield('t1', 'kpsr,lev1_r,0,0', 'pstgpl', 'nlev1')
    @ 1, 1 say 'Уровень 1      ' get lev1_r pict '9999' valid vpstlev(1, 1, 23, wgppr)
    @ 2, 23 say getfield('t1', 'kpsr,lev1_r,lev2_r,0', 'pstgpl', 'nlev2')
    @ 2, 1 say 'Уровень 2      ' get lev2_r pict '9999' valid vpstlev(2, 2, 23, wgppr)
    @ 3, 23 say getfield('t1', 'kpsr,lev1_r,lev2_r,lev3_r', 'pstgpl', 'nlev3')
    @ 3, 1 say 'Уровень 3      ' get lev3_r pict '9999' valid vpstlev(3, 3, 23, wgppr)
    @ 4, 1 say 'Своя категория '+str(kgpcat_r, 2)+' '+getfield('t1', 'kgpcat_r', 'kgpcat', 'nkgpcat')
    read
    if (lastkey()=27)
      exit
    endif

    if (lastkey()=13)
      sele kgppst
      if (empty(p1))
        if (kgpr#0)
          if (!netseek('t2', 'kpsr,kgp_r'))
            netadd()
            netrepl('post,kgp,lev1,lev2,lev3', 'kpsr,kgp_r,lev1_r,lev2_r,lev3_r')
            exit
          endif

        endif

      else
        netrepl('lev1,lev2,lev3', 'lev1_r,lev2_r,lev3_r')
        exit
      endif

    endif

  enddo

  wclose(wgppr)
  setcolor(scgppr)
  return (.t.)

/*************** */
function gpchk()
  /*************** */
  sele kgp
  if (!netseek('t1', 'kgp_r'))
    sele kgppst
    return (.f.)
  else
    kgpcat_r=kgpcat
  endif

  sele kgppst
  return (.t.)

/************************** */
function vpstlev(p1, p2, p3, p4)
  /************************** */
  lev_rr=p1
  row_rr=p2
  col_rr=p3
  wout_r=p4
  wselect(0)
  sele pstgpl
  do case
  case (lev_rr=1)
    if (lev1_r#0)
      if (!netseek('t1', 'kpsr,lev1_r,0,0'))
        lev1_r=0
      endif

    endif

    if (lev1_r=0)
      lev1_r=pstlev(1)
    endif

    wselect(wout_r)
    @ row_rr, col_rr say getfield('t1', 'kpsr,lev1_r,0,0', 'pstgpl', 'nlev1')
  case (lev_rr=2)
    if (lev1_r#0)
      if (lev2_r#0)
        if (!netseek('t1', 'kpsr,lev1_r,lev2_r,0'))
          lev2_r=0
        endif

      endif

      if (lev2_r=0)
        lev2_r=pstlev(2)
      endif

    else
      lev2_r=0
    endif

    wselect(wout_r)
    @ row_rr, col_rr say getfield('t1', 'kpsr,lev1_r,lev2_r,0', 'pstgpl', 'nlev2')
  case (lev_rr=3)
    if (lev2_r#0)
      if (lev3_r#0)
        if (!netseek('t1', 'kpsr,lev1_r,lev2_r,lev3_r'))
          lev3_r=0
        endif

      endif

      if (lev3_r=0)
        lev3_r=pstlev(3)
      endif

    else
      lev3_r=0
    endif

    wselect(wout_r)
    @ row_rr, col_rr say getfield('t1', 'kpsr,lev1_r,lev2_r,lev3_r', 'pstgpl', 'nlev3')
  endcase

  wselect(wout_r)
  return (.t.)

/**************** */
function pstlev(p1)
  /**************** */
  local lev_rr
  lev_rr=0
  sele pstgpl
  go top
  do case
  case (p1=1)
    forl_r='post=kpsr.and.lev1#0.and.lev2=0.and.lev3=0'
  case (p1=2)
    forl_r='post=kpsr.and.lev1=lev1_r.and.lev2#0.and.lev3=0'
  case (p1=3)
    forl_r='post=kpsr.and.lev1=lev1_r.and.lev2=lev2_r.and.lev3#0'
  endcase

  go top
  rclev_rr=recn()
  while (.t.)
    sele pstgpl
    go rclev_rr
    foot('ENTER', 'Выбрать')
    do case
    case (p1=1)
      rclev_rr=slcf('pstgpl',,,,, "e:lev1 h:'Код' c:n(4) e:nlev1 h:'Наименование' c:c(70)",,,,, forl_r,, '')
    case (p1=2)
      rclev_rr=slcf('pstgpl',,,,, "e:lev2 h:'Код' c:n(4) e:nlev2 h:'Наименование' c:c(70)",,,,, forl_r,, '')
    case (p1=3)
      rclev_rr=slcf('pstgpl',,,,, "e:lev3 h:'Код' c:n(4) e:nlev3 h:'Наименование' c:c(70)",,,,, forl_r,, '')
    endcase

    go rclev_rr
    do case
    case (lastkey()=27)
      lev_rr=0
      exit
    case (lastkey()=13)
      do case
      case (p1=1)
        lev_rr=lev1
      case (p1=2)
        lev_rr=lev2
      case (p1=3)
        lev_rr=lev3
      endcase

      exit
    endcase

  enddo

  return (lev_rr)

/**************** */
function kgppsts()
  /**************** */
  save scree to scop
  mess('Ждите...')
  sele kgp
  go top
  while (!eof())
    if (kgp=0)
      skip
      loop
    endif

    kgpr=kgp
    kgpcatr=kgpcat
    sele kgppst
    if (!netseek('t1', 'kgpr,kpsr'))
      netadd()
      netrepl('kgp,post,kgpcat', 'kgpr,kpsr,kgpcatr')
      if (kgpcatr#0)
        store 0 to lev1r, lev2r, lev3r
        sele pstgpl
        if (netseek('t2', 'kpsr,kgpcatr'))
          lev1r=lev1
          lev2r=lev2
          lev3r=lev3
          sele kgppst
          netrepl('lev1,lev2,lev3', 'lev1r,lev2r,lev3r')
        endif

      endif

    else
      if (lev1=0.and.kgpcatr#0)
        store 0 to lev1r, lev2r, lev3r
        sele pstgpl
        if (netseek('t2', 'kpsr,kgpcatr'))
          lev1r=lev1
          lev2r=lev2
          lev3r=lev3
          sele kgppst
          netrepl('lev1,lev2,lev3,kgpcat', 'lev1r,lev2r,lev3r,kgpcatr')
        endif

      endif

    endif

    sele kgp
    skip
  enddo

  sele kgppst
  set orde to tag t2
  if (netseek('t2', 'kpsr'))
    while (post=kpsr)
      if (kgp=0)
        netdel()
        skip
        loop
      endif

      kgpr=kgp
      if (!netseek('t1', 'kgpr', 'kgp'))
        sele kgppst
        netdel()
      endif

      sele kgppst
      skip
    enddo

  endif

  rest scree from scop
  return (.t.)

/**************** */
function gppsflt()
  /**************** */
  scfltr=setcolor('gr+/b,n/w')
  wfltr=wopen(8, 10, 12, 70)
  wbox(1)
  store 0 to kgpr
  store space(20) to ngpr
  @ 0, 1 say 'Грузополучатель' get kgpr pict '9999999'
  @ 1, 1 say 'Наименование   ' get ngpr
  read
  kgp_r=kgpr
  ngp_r=ngpr
  if (lastkey()=27)
    gpforr=gpfor_r
  endif

  gpforr=gpfor_r
  if (kgp_r#0)
    gpforr=gpfor_r+'.and.kgp=kgp_r'
  endif

  if (kgp_r=0.and.!empty(ngp_r))
    ngp_r=alltrim(upper(ngp_r))
    gpforr=gpfor_r+".and.at(ngp_r,upper(getfield('t1','kgppst->kgp','kln','nkl')))#0"
  endif

  sele kgppst
  set orde to tag t2
  netseek('t2', 'kpsr')
  rcgppstr=recn()
  wclose(wfltr)
  setcolor(scfltr)
  return (.t.)

/**************** */
function skidlst()
  /**************** */
  clea
  netuse('kln')
  netuse('klnnac')
  if (!file('skidlst.dbf'))
    crtt('skidlst', 'f:kkl c:n(7) f:izg c:n(7) f:kg c:n(3) f:nac c:n(6,2) f:nac1 c:n(6,2)')
  endif

  store 0 to izgrr, kgrr, nacrr, nac1rr// по умолчанию
  sele 0
  use skidlst excl
  inde on str(kkl, 7)+str(izg, 7)+str(kg, 3) tag t1
  sele skidlst
  go top
  izgr=izg
  kgr=kg
  nacr=nac
  nac1r=nac1
  rcsklr=recn()
  while (.t.)
    sele skidlst
    go rcsklr
    foot('INS,DEL,F2,F4,F6,F7', 'Доб,Уд,Параметры,Корр,Запись,Уд.все')
    rcsklr=slcf('skidlst', 1, 1, 18,, "e:kkl h:'Код' c:n(7) e:getfield('t1','skidlst->kkl','kln','nkl') h:'Наименование' c:c(30) e:izg h:'Изг' c:n(7) e:kg h:'Гр' c:n(3) e:nac h:'Nac' c:n(6,2) e:nac1 h:'Nac1' c:n(6,2) e:getfield('t1','skidlst->kkl,skidlst->izg,skidlst->kg','klnnac','nac') h:'NacR' c:n(6,2) e:getfield('t1','skidlst->kkl,skidlst->izg,skidlst->kg','klnnac','nac1') h:'Nac1R' c:n(6,2)",,, 1,,,, 'Список клиентов')
    if (lastkey()=27)
      exit
    endif

    sele skidlst
    go rcsklr
    izgr=izg
    kgr=kg
    nacr=nac
    nac1r=nac1
    do case
    case (lastkey()=22)   // INS
      klsti()
    case (lastkey()=-3)   // CORR
      klsti(1)
    case (lastkey()=7)    // DEL
      netdel()
      skip -1
      if (bof())
        go top
      endif

      rcsklr=recn()
    case (lastkey()=-1)   // PARAM
      sckps=setcolor('gr+/b,n/w')
      wkps=wopen(8, 20, 13, 60)
      wbox(1)
      while (.t.)
        @ 0, 1 say 'Изготовитель' get izgrr pict '9999999'
        @ 1, 1 say 'Группа      ' get kgrr pict '999'
        @ 2, 1 say 'Наценка     ' get nacrr pict '999.99'
        @ 3, 1 say 'Наценка1    ' get nac1rr pict '999.99'
        read
        if (lastkey()=27)
          exit
        endif

        if (lastkey()=13)
          exit
        endif

      enddo

      wclose(wkps)
      setcolor(sckps)
    case (lastkey()=-5)   // WRITE
      klstw()
    case (lastkey()=-6)   // DEL ALL
      aqstr=1
      aqst:={ "Нет", "Да" }
      aqstr:=alert("Удалить все? ", aqst)
      if (aqstr=2)
        dele all
        pack
        go top
        rcsklr=recn()
      endif

    endcase

  enddo

  nuse('skidlst')
  nuse()
  return (.t.)

/************* */
function klsti(p1)
  /************* */
  if (empty(p1))
    kklr=0
    izgr=izgrr
    kgr=kgrr
    nacr=nacrr
    nac1r=nac1rr
    trwr=row()+1
  else
    kklr=kkl
    izgr=izg
    kgr=kg
    nacr=nac
    nac1r=nac1
    trwr=row()
  endif

  while (.t.)
    if (empty(p1))
      @ trwr, 2 get kklr pict '9999999' color 'r/w'
    else
      @ trwr, 2 say str(kklr, 7) color 'n/bg'
    endif

    /*   @ trwr,41 get izgr pict '9999999'     color 'r/w'
     *   @ trwr,49 get kgr  pict '999'        color 'r/w'
     */
    @ trwr, 41 say str(izgr, 7) color 'n/bg'
    @ trwr, 49 say str(kgr, 3) color 'n/bg'
    if (empty(p1))
      @ trwr, 53 say str(nacr, 6, 2) color 'n/bg'
      @ trwr, 60 say str(nac1r, 6, 2) color 'n/bg'
    else
      @ trwr, 53 get nacr pict '999.99' color 'r/w'
      @ trwr, 60 get nac1r pict '999.99' color 'r/w'
    endif

    read
    if (lastkey()=27)
      exit
    endif

    if (lastkey()=13)
      if (izgr#0.and.kgr#0)
        if (empty(p1))
          if (!netseek('t1', 'kklr,izgr,kgr'))
            netadd()
            netrepl('kkl,izg,kg,nac,nac1', 'kklr,izgr,kgr,nacr,nac1r')
            rcsklr=recn()
          else
            wmess('Уже есть', 2)
          endif

        else
          netrepl('nac,nac1', 'nacr,nac1r')
        endif

      else
        wmess('Пустые параметры', 2)
      endif

      exit
    endif

  enddo

  return (.t.)

/************** */
function klstw()
  /************** */
  aqstr=1
  aqst:={ "Нет", "Да" }
  aqstr:=alert("Записать? ", aqst)
  if (lastkey()=27)
    return
  endif

  if (aqstr#2)
    return
  endif

  set prin to skidlst.txt
  set prin on
  sele skidlst
  go top
  while (!eof())
    kklr=kkl
    izgr=izg
    kgr=kg
    nacr=nac
    nac1r=nac1
    sele klnnac
    if (!netseek('t1', 'kklr,izgr,kgr'))
      ?str(kklr, 7)+' '+str(izgr, 7)+' '+str(kgr, 7)+' добавлен'
      netadd()
      netrepl('kkl,izg,kg,nac,nac1', 'kklr,izgr,kgr,nacr,nac1r')
    else
      ?str(kklr, 7)+' '+str(izgr, 7)+' '+str(kgr, 7)+' nac '+str(nac, 5, 2)+' -> '+str(nacr, 5, 2)+' nac1 '+str(nac1, 5, 2)+' -> '+str(nac1r, 5, 2)
      netrepl('nac,nac1', 'nacr,nac1r')
    endif

    sele skidlst
    skip
  enddo

  set prin off
  set prin to

  return (.t.)

/*************** */
function skidusl()
  /*************** */
  clea
  netuse('klnnac')
  sckps=setcolor('gr+/b,n/w')
  wkps=wopen(8, 10, 14, 70)
  wbox(1)
  store 0 to izgr, kgr, nacr, nac_r, nac1r, nac1_r
  while (.t.)
    @ 0, 1 say 'Изготовитель' get izgr pict '9999999'
    @ 1, 1 say 'Группа      ' get kgr pict '999'
    @ 2, 1 say 'Для наценки ' get nacr pict '999.99'
    @ 2, col()+1 say 'Уст.наценку ' get nac_r pict '999.99'
    /*   @ 3,1 say 'Для наценки1    ' get nac1r   pict '999.99'
     *   @ 3,col()+1 say 'Уст.наценку1' get nac1_r  pict '999.99'
     */
    read
    if (lastkey()=K_ESC)
      exit
    endif

    if (lastkey()=K_ENTER)
      if (izgr=0)
        wmess('Изг=0', 1)
        loop
      endif

      if (kgr=0)
        wmess('Группа=0', 1)
        loop
      endif

      sele klnnac
      go top
      while (!eof())
        if (izg=izgr.and.kg=kgr.and.nac=nacr.and.tcen=0)
          netrepl('nac,nac1', 'nac_r,nac_r')
        endif

        skip
      enddo

      exit
    endif

  enddo

  wclose(wkps)
  setcolor(sckps)
  nuse()
  return (.t.)

/*****************************************************************
 
 FUNCTION:
 АВТОР..ДАТА..........С. Литовка  11-18-19 * 03:19:23pm
 НАЗНАЧЕНИЕ.........
 ПАРАМЕТРЫ..........
 ВОЗВР. ЗНАЧЕНИЕ....
 ПРИМЕЧАНИЯ.........
 */
FUNCTION a_IdAct()  //
  LOCAL  prF1r, forr

  netuse('ctov')
  netuse('kln')
  netuse('kgp')
  netuse('kgpnet')
  OpenDbSW4Zen(gcPath_ew+"aktsii",NO)

  sele a_IdAct

  prF1r=0
  forr:='.t.'
  Do While .t.
    if (prF1r=0)
      foot('INS,F3,F4,F5,F6', 'Доб.,Фильтр,Корр,Товар,Тор.места')
    else
      footA('', '')
    endif

    sele a_IdAct
    rcA_IdActr=slcf('a_IdAct', 1, 1, 18,,                                                                                                                                                                                            ;
                      "e:A_Id h:'Ид Акции' c:n(5)";
                    +" e:AName h:'Наименование' c:с(30)";
                    +" e:ABeg h:'Дата Н' c:d(10)";
                    +" e:AEnd h:'Дата К' c:d(10)";
                    +" e:AType h:'Тип' c:n(1)",,, 1,, forr,, ;
                    'Акции'       ;
                 )

    sele a_IdAct
    go rcA_IdActr

    do case
    case (lastkey()=K_ESC)
      exit
    case (lastkey()=K_F1)   //28 && F1
      if (prF1r=0)
        prF1r=1
      else
        prF1r=0
      endif
    case (lastkey()=K_INS)  //22 && Добавить
      a_IdAct->(a_IdActIns())
    case (lastkey()=K_F4)   //-3 // Коррекция
      a_IdAct->(a_IdActIns(1))
    case (lastkey()=K_F5)   //-3 // товар

      sele a_Prod
      ordsetfocus('t2')
      netseek('t2','a_IdAct->A_Id')

      a_Prod(a_IdAct->A_Id,a_IdAct->AName,{||a_IdAct->A_Id = a_Prod->A_Id})

    case (lastkey()=K_F6)   //-3 // торговые места

      sele a_TT
      ordsetfocus('t2')
      netseek('t2','a_IdAct->A_Id')

      a_TT(a_IdAct->A_Id,a_IdAct->AName,{||a_IdAct->A_Id = a_TT->A_Id})
    endcase

  EndDo

  close a_tt
  close a_Prod
  close a_IdAct
  nuse('kgpnet')
  nuse('kln')
  nuse('kgp')
  nuse('ctov')

  RETURN (NIL)

/*****************************************************************
 
 FUNCTION:
 АВТОР..ДАТА..........С. Литовка  11-18-19 * 03:46:32pm
 НАЗНАЧЕНИЕ.........
 ПАРАМЕТРЫ..........
 ВОЗВР. ЗНАЧЕНИЕ....
 ПРИМЕЧАНИЯ.........
 */
STATIC FUNCTION a_IdActIns(nIns)
  local getlist:={}
  local wmkr:=nwopen(8, 10, 18, 70, 1, 'gr+/b,n/w')
  LOCAL nRec:=RECNO()

  A_Idr  := a_Id
  If Empty(nIns)
    DBGoBottom()
    A_Idr = A_Id + 1
    DBSkip()
  EndIf
  // инициализация переменных
  ANamer := AName
  ABegr :=  ABeg
  AEndr := AEnd
  ATyper := AType
  Do While .t.
    @ 1, 1 say 'Ид Акции'
    @ row(), col()+1 say A_Idr COLOR "B/W"
    @ 2, 1 say 'Наименование' get  ANamer
    @ 3, 1 say 'Дата Н'       get  ABegr
    @ 4, 1 say 'Дата К'       get  AEndr
    @ 5, 1 say 'Тип'          get  ATyper

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
      if (Empty(nIns))
        netadd()
        nRec:=RECNO()
      endif
      netrepl('A_Id, AName, ABeg, AEnd, AType',;
      {A_Idr, ANamer, ABegr, AEndr, ATyper})
      exit
    endif
  EndDo

  wclose(wmkr)

  DBGoTo(nRec)
  RETURN (NIL)

/*****************************************************************
 
 FUNCTION:
 АВТОР..ДАТА..........С. Литовка  11-18-19 * 03:19:39pm
 НАЗНАЧЕНИЕ.........
 ПАРАМЕТРЫ..........
 ВОЗВР. ЗНАЧЕНИЕ....
 ПРИМЕЧАНИЯ.........
 */
FUNCTION a_Prod(A_Idr,cAName,bWhile) //
  LOCAL  prF1r, forr
  sele a_Prod

  prF1r=0
  forr:='.t.'
  Do While .t.
    if (prF1r=0)
      foot('INS,DEL,F4', 'Доб,Удал,Корр')
    else
      footA('', '')
    endif

    sele a_Prod
    rcA_Prod=slcf('a_Prod', 1, 1, 18,,                                                                                                                                                                                            ;
                      "e:MnTov h:'Код товара' c:n(7)";
                    +" e:Nat h:'Наименование' c:с(40)";
                    +" e:Price h:'Цена+НДС' c:n(10,2)";
                    ,,, 1, bWhile, forr,, ;
                    'Акция:'+allt(cAName)       ;
                 )

    sele a_Prod
    go rcA_Prod

    do case
    case (lastkey()=K_ESC)
      exit
    case (lastkey()=K_F1)   //28 && F1
      if (prF1r=0)
        prF1r=1
      else
        prF1r=0
      endif
    case (lastkey()=K_INS)  // Добавить
      a_Prod->(a_ProdIns(,A_Idr))
    case (lastkey()=K_F4)   // Коррекция
      a_Prod->(a_ProdIns(1,A_Idr))
    case (lastkey()=K_DEL)   // удалить
      a_Prod->(netdel())
    endcase

  EndDo
  RETURN (NIL)

/*****************************************************************
 
 FUNCTION:
 АВТОР..ДАТА..........С. Литовка  11-25-19 * 03:23:05pm
 НАЗНАЧЕНИЕ.........
 ПАРАМЕТРЫ..........
 ВОЗВР. ЗНАЧЕНИЕ....
 ПРИМЕЧАНИЯ.........
 */
STATIC FUNCTION a_ProdIns(nIns, nA_Id)
  local getlist:={}
  local wmkr:=nwopen(8, 10, 18, 70, 1, 'gr+/b,n/w')
  LOCAL nRec:=RECNO()

  A_Idr:= nA_Id

  If Empty(nIns)
    DBGoBottom()
    DBSkip()
  EndIf
  // инициализация переменных
  MnTovr := MnTov
  Natr := Nat
  Pricer :=  Price
  Do While .t.

    @ 1, 1 say 'Ид Акции'
    @ row(), col()+1 say A_Idr COLOR "B/W"
    @ 2, 1 say 'Код товара' get  MnTovr ;
    valid (Natr:=getfield("t1","MnTovr","ctov",'nat'),!Empty(Natr))
    @ 3, 1 say 'Наименование' get  Natr when .f.
    @ 4, 1 say 'Цена с НДС'       get  Pricer valid Pricer > 0

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
      if (Empty(nIns))
        netadd()
        nRec:=RECNO()
      endif
      netrepl('A_Id, MnTov,  Nat, Price',;
      { A_Idr, MnTovr,  Natr, Pricer })
      exit
    endif
  EndDo

  wclose(wmkr)

  DBGoTo(nRec)
  RETURN (NIL)


/*****************************************************************
 
 FUNCTION:
 АВТОР..ДАТА..........С. Литовка  11-18-19 * 03:19:58pm
 НАЗНАЧЕНИЕ.........
 ПАРАМЕТРЫ..........
 ВОЗВР. ЗНАЧЕНИЕ....
 ПРИМЕЧАНИЯ.........
 */
FUNCTION a_TT(A_Idr,cAName,bWhile)  //
  LOCAL  prF1r, forr
  kgp->(ordsetfocus('t1'))
  kln->(ordsetfocus('t1'))
  sele a_TT
  set rela to str((VAL(LEFT(a_TT->Ol_code,AT('-', a_TT->Ol_code)-1))),7) into kgp,;
   str((VAL(SUBSTR(LTRIM(a_TT->Ol_code), AT('-',a_TT->Ol_code)+1))),7) into kln



  prF1r=0
  forr:='.t.'
  Do While .t.
    if (prF1r=0)
      foot('INS,DEL,F4,F5', 'Доб,Удал,Корр,Доб.СетьГП')
    else
      footA('', '')
    endif

    sele a_TT
    rcA_TT=slcf('a_TT', 1, 1, 18,,;
                      "e:(VAL(LEFT(a_TT->Ol_code,AT('-', a_TT->Ol_code)-1))) h:'Код ГП' c:n(7)";
                    +" e:kgp->NGrPol h:'Наименование ГП' c:с(30)";
                    +" e:(VAL(SUBSTR(LTRIM(a_TT->Ol_code), AT('-',a_TT->Ol_code)+1))) h:'Код Пл' c:n(7)";
                    +" e:kln->Nkl h:'Наименование Пл' c:с(35)";
                    ,,, 1, bWhile, forr,, ;
                    'Акция:'+allt(cAName)       ;
                 )

    sele a_TT
    go rcA_TT

    do case
    case (lastkey()=K_ESC)
      exit
    case (lastkey()=K_F1)   //28 && F1
      if (prF1r=0)
        prF1r=1
      else
        prF1r=0
      endif
    case (lastkey()=K_INS)  // Добавить
      a_TT->(a_TTIns(,A_Idr))
    case (lastkey()=K_F4)   // Коррекция
      a_TT->(a_TTIns(1,A_Idr))
    case (lastkey()=K_F5)   // добавить Сеть ГП
     a_TT->(a_TTIns_kgpnet(A_Idr))
    case (lastkey()=K_DEL)   // удалить
      a_TT->(netdel())
    endcase

  EndDo
  RETURN (NIL)

/*****************************************************************
 
 FUNCTION:
 АВТОР..ДАТА..........С. Литовка  11-25-19 * 04:15:07pm
 НАЗНАЧЕНИЕ.........
 ПАРАМЕТРЫ..........
 ВОЗВР. ЗНАЧЕНИЕ....
 ПРИМЕЧАНИЯ.........
 */
STATIC FUNCTION a_TTIns(nIns, nA_Id)
  local getlist:={}
  local wmkr:=nwopen(8, 10, 18, 70, 1, 'gr+/b,n/w')
  LOCAL nRec:=RECNO()

  A_Idr:= nA_Id

  If Empty(nIns)
    DBGoBottom()
    DBSkip()
  EndIf
  // инициализация переменных
  KGpr := (VAL(LEFT(a_TT->Ol_code,AT('-', a_TT->Ol_code)-1)))
  NGpr := left(kgp->NGrPol,40)
  KPlr := (VAL(SUBSTR(LTRIM(a_TT->Ol_code), AT('-',a_TT->Ol_code)+1)))
  NPlr := left(kln->Nkl,40)
  Do While .t.

    @ 1, 1 say 'Ид Акции'
    @ row(), col()+1 say A_Idr COLOR "B/W"
    @ 2, 1 say 'Код ГП' get  KGpr PICT "@K 999999" ;
    valid (NGpr:=getfield("t1","KGpr","kgp",'NGrPol'),!Empty(NGpr) .and. !empty(KGpr))
    @ 3, 1 say 'Наим. ГП' get  NGpr when .f.
    @ 4, 1 say 'Код Пл' get  KPlr PICT "@K 999999" ;
    valid iif(empty(KPlr),.t., (NPlr:=getfield("t1","KPlr","kln",'NGrPol'),!Empty(NPlr)))
    @ 5, 1 say 'Наим. Пл.' get  NPlr when .f.

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
      if (Empty(nIns))
        netadd()
        nRec:=RECNO()
      endif
      netrepl('A_Id, Ol_code', { A_Idr, STR(kGpr,7)+"-"+STR(kPlr,7) })
      exit
    endif
  EndDo

  wclose(wmkr)

  DBGoTo(nRec)
  RETURN (NIL)

/*****************************************************************
 
 FUNCTION:
 АВТОР..ДАТА..........С. Литовка  11-25-19 * 08:24:36pm
 НАЗНАЧЕНИЕ.........
 ПАРАМЕТРЫ..........
 ВОЗВР. ЗНАЧЕНИЕ....
 ПРИМЕЧАНИЯ.........
 */
STATIC FUNCTION a_TTIns_kgpnet(nA_Id)
  scfltr=setcolor('gr+/b,n/w')
  wfltr=wopen(8, 10, 18, 70)
  wbox(1)
  store 0 to knetr
  A_Idr:=nA_Id
  Ol_coder:=""
  Do While .t.
    @ 0,1 say 'Код сети       ' get knetr pict '999' ;
    valid vKGpNet(wfltr) .and. (NNetr:=getfield("t1","KNetr","KgpNet",'NNet'),!Empty(NNetr))
    @ 0, col()+1 get NNetr pict "@S40" when .f.
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
      kgp->(DBEval({||;
      Ol_coder:=STR(kgp->kGp,7)+"-"+STR(0,7),;
      iif(a_tt->(netseek('t1','Ol_coder,A_Idr')),;
      NIL,;
      a_tt->(netadd(),netrepl('A_Id, Ol_code', { A_Idr, Ol_coder }));
      );
      },{||KNet = KNetr}))

      exit
    endif
  EndDo

  wclose(wfltr)
  setcolor(scfltr)

  RETURN (NIL)

/*****************************************************************
 
 FUNCTION:
 АВТОР..ДАТА..........С. Литовка  09-16-19 * 12:38:12pm
 НАЗНАЧЕНИЕ.........
 ПАРАМЕТРЫ..........
 ВОЗВР. ЗНАЧЕНИЕ....
 ПРИМЕЧАНИЯ.........
 */
Function OpenDbSW4Zen(cPath_Order, lReadOnly)
  DEFAULT lReadOnly TO .T.
  DEFAULT cPath_Order TO gcPath_ew+"obolon\swe2cus"
  If !file(cPath_Order+'\a_prod'+'.dbf')
    Return (.F.)
  EndIf
  If empty(select('a_prod'))
    use (cPath_Order+'\a_prod') alias a_prod new  Shared
    If lReadOnly
    use (cPath_Order+'\a_prod') alias a_prod new ReadOnly Shared
    EndIf
    //index on str(mntov,7)+str(a_id,5) to a_prod
    ordsetfocus('t1')
  EndIf
  If empty(select('a_idAct'))
    use (cPath_Order+'\a_idAct') alias a_idAct new Shared
    If lReadOnly
    use (cPath_Order+'\a_idAct') alias a_idAct new ReadOnly Shared
    EndIf
    //index on str(a_id,5) to a_idAct
    ordsetfocus('t1')
  EndIf
  If empty(select('a_tt'))
    use (cPath_Order+'\a_tt') alias a_tt new Shared
    If lReadOnly
    use (cPath_Order+'\a_tt') alias a_tt new ReadOnly Shared
    EndIf
    //index on ol_code+str(a_id,5) to a_tt
    ordsetfocus('t1')
  EndIf
  Return (.t.)
