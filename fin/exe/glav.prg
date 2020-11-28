/***********************************************************
 * Модуль    : glav.prg
 * Версия    : 0.0
 * Автор     :
 * Дата      : 03/28/18
 * Изменен   :
 * Примечание: Текст обработан утилитой CF версии 2.02
 */

#include "inkey.ch"
/***********************
 ** Главная книга
 ***********************
 */
if (subs(gcPath_m, 1, 1)='i'.or.subs(gcPath_m, 1, 1)='I')
  if (gnEnt=14.or.gnEnt=15.or.gnEnt=17)
    if (dirchange('I:\UPGRADE'+gcNent)<0)
      dirmake('I:\UPGRADE'+gcNent)
    endif

    path_rr='I:\UPGRADE'+gcNent+'\'
  else
    if (dirchange('J:\'+gcNent)<0)
      dirmake('J:\'+gcNent)
    endif

    path_rr='J:\'+gcNent+'\'
  endif

else
  if (dirchange(gcPath_l+'\'+gcNent)<0)
    dirmake(gcPath_l+'\'+gcNent)
  endif

  path_rr=gcPath_l+'\'+gcNent+'\'
endif

dirchange(gcPath_l)
clea
if (!file(path_rr+'glav.dbf'))
  probnr=1
else
  probnr=0
endif

if (probnr=0)
  ccc=dtoc(filedate(path_rr+'glav.dbf'))+' '+filetime(path_rr+'glav.dbf')
  aqstr=1
  aqst:={ "Продолжить", "Обновить" }
  aqstr:=alert(ccc, aqst)
  if (aqstr=2)
    probnr=1
  endif

endif

netuse('dokk')
netuse('bs')
netuse('kln')
netuse('speng')
if (probnr=1)
  if (file(path_rr+'glav.dbf'))
    sele 0
    use (path_rr+'glav.dbf') excl
    if (neterr())
      wmess('Файл занят')
      CLOSE
      probnr=0
    else
      CLOSE
    endif

  endif

endif

if (probnr=1)
  mess('Ждите...')
  crtt(path_rr+'glav', 'f:bs c:n(6) f:be c:n(1) f:nbs c:c(20) f:dn c:n(12,2) f:kn c:n(12,2) f:dbks c:n(6) f:db c:n(12,2) f:krks c:n(6) f:kr c:n(12,2) f:dk c:n(12,2) f:kk c:n(12,2)')
  sele 0
  use (path_rr+'glav') excl
  inde on str(bs, 6)+str(dbks, 6)+str(krks, 6) tag t1
  inde on str(bs, 6)+str(krks, 6)+str(dbks, 6) tag t2
  inde on str(bs, 6)+str(be, 1) tag t3
  sele dokk
  while (!eof())
    if (bs_d<1000.or.bs_k<1000)
      skip
      loop
    endif

    if (prc)
      skip
      loop
    endif

    bs_sr=bs_s
    bs_dr=bs_d
    sele bs
    seek str(bs_dr, 6)
    if (foun())
      bs_dr=bsm
      nbsr=nbs
    endif

    sele dokk
    bs_kr=bs_k
    sele bs
    seek str(bs_kr, 6)
    if (foun())
      bs_kr=bsm
      nbsr=nbs
    endif

    if (bs_dr#bs_kr)
      sele glav
      set orde to tag t1
      seek str(bs_dr, 6)+str(bs_kr, 6)+str(bs_kr, 6)
      if (!foun())
        seek str(bs_dr, 6)+str(bs_kr, 6)
        if (!foun())
          seek str(bs_dr, 6)+str(0, 6)
          if (!foun())
            appe blank
            repl bs with bs_dr, be with 1
          endif

        endif

      endif

      repl db with db+bs_sr, dbks with bs_kr
      sele glav
      set orde to tag t2
      seek str(bs_kr, 6)+str(bs_dr, 6)+str(bs_dr, 6)
      if (!foun())
        seek str(bs_kr, 6)+str(bs_dr, 6)
        if (!foun())
          seek str(bs_kr, 6)+str(0, 6)
          if (!foun())
            appe blank
            repl bs with bs_kr, be with 1
          endif

        endif

      endif

      repl kr with kr+bs_sr, krks with bs_dr
    endif

    sele dokk
    skip
  enddo

  sele glav
  set orde to tag t1
  sele bs
  go top
  while (!eof())
    if (bsm<1000)
      skip
      loop
    endif

    bsr=bsm
    nbsr=nbs
    dnr=dn
    knr=kn
    sele glav
    set orde to tag t3
    seek str(bsr, 6)+str(0, 1)
    if (!foun())
      appe blank
      repl bs with bsr, nbs with nbsr
    endif

    seek str(bsr, 6)+str(2, 1)
    if (!foun())
      appe blank
      repl bs with bsr, nbs with 'Итого по '+str(bsr, 6)+' счету', be with 2
    endif

    repl dn with dn+dnr, kn with kn+knr
    set orde to tag t3
    seek str(bsr, 6)+str(3, 1)
    if (!foun())
      appe blank
      repl bs with bsr, be with 3
      skip
    endif

    sele bs
    skip
    loop
  enddo

  sele glav
  set orde to tag t3
  go top
  while (!eof())
    do case
    case (be=0)
      dbr=0
      krr=0
      cntglavr=0
      skip
      loop
    case (be=2)
      repl db with dbr, kr with krr, dk with dn+dbr, kk with kn+krr
      skip
      loop
    case (be=3)
      skip
      loop
    otherwise
      dbr=dbr+db
      krr=krr+kr
      cntglavr=cntglavr+1
    endcase

    skip
  enddo

  sele glav
  set orde to
  go top
  while (!eof())
    if (be#2)
      skip
      loop
    endif

    ww=dk-kk
    do case
    case (ww>0)
      repl dk with ww, kk with 0
    case (ww<0)
      repl kk with abs(ww), dk with 0
    case (ww=0)
      repl dk with 0, kk with 0
    endcase

    skip
  enddo

  CLOSE
  clea
endif

if (select('glav')#0)
  sele glav
  CLOSE
endif

sele 0
use (path_rr+'glav.dbf') share
set orde to tag t3
go top
fldnomr=1
while (.t.)
  clea
  foot('F3,F4,F5', 'Поиск,Дебет,Кредит')
  //   rcglavr=slce('glav',1,1,18,,"e:bs h:'Счет' c:n(6) e:nbs h:'Наименование' c:c(20) e:iif(dn#0,str(dn,12,2),space(12)) h:'Д Н' c:c(12) e:kn h:'К Н' c:n(12,2) e:dbks h:'СчетД' c:n(6) e:db h:'Дебет' c:n(12,2) e:krks h:'СчетК' c:n(6) e:kr h:'Кредит' c:n(12,2) e:dk h:'Д К' c:n(12,2) e:kk h:'К К' c:n(12,2)",,,,,,,'ГЛАВНАЯ КНИГА',fldnomr,2)
  rcoglavr=recn()
  rcglavr=slce('glav', 1, 1, 18,, "e:iif(be=0.or.be=2,bs,0) h:'Счет' c:n(6) e:nbs h:'Наименование' c:c(20) e:dn h:'Д Н' c:n(12,2) e:kn h:'К Н' c:n(12,2) e:dbks h:'СчетД' c:n(6) e:db h:'Дебет' c:n(12,2) e:krks h:'СчетК' c:n(6) e:kr h:'Кредит' c:n(12,2) e:dk h:'Д К' c:n(12,2) e:kk h:'К К' c:n(12,2)",,, 1,,,, 'ГЛАВНАЯ КНИГА', fldnomr, 1)
  if (lastkey()=K_ESC)
    exit
  endif

  sele glav
  go rcglavr
  bsr=bs
  dbksr=dbks
  krksr=krks
  do case
  case (lastkey()=19)     // Left
    fldnomr=fldnomr-1
    if (fldnomr=0)
      fldnomr=1
    endif

  //           go rcoglavr
  case (lastkey()=4)      // Right
    fldnomr=fldnomr+1
  //           go rcoglavr
  case (lastkey()=K_F3)
    clglav=setcolor('n/w,n/bg')
    wglav=wopen(10, 30, 13, 50)
    wbox(1)
    bsr=0
    @ 0, 1 say 'Счет' get bsr pict '999999'
    read
    if (bsr#0)
      seek str(bsr, 6)
      rcglavr=recn()
    endif

    wclose(wglav)
    setcolor(clglav)
  case (lastkey()=K_F4)   // Дебет
    if (dbksr#0)
      sele dokk
      set orde to tag t2
      seek str(bsr, 6)+str(dbksr, 6)
      for_r='!prc'
      forr='!prc'
      if (foun())
        hd_r=str(bsr, 6)+' '+str(dbksr, 6)+' '+alltrim(getfield('t1', 'dbksr', 'bs', 'nbs'))
        hdr=hd_r
        while (.t.)
          foot('F3', 'Фильтр')
          set cent off
          kklr=slcf('dokk',,,,, "e:mn h:'mn' c:n(6) e:rn h:'rn' c:n(6) e:rnd h:'rnd' c:n(6) e:bs_s h:'bs_s' c:n(10,2) e:kkl h:'kkl' c:n(7) e:getfield('t1','dokk->kkl','kln','nkl') h:'nkl' c:c(20) e:sk h:'sk' c:n(3) e:ddk h:'ddk' c:d(8) e:ksz h:'ksz' c:n(2)", 'kkl',, 1, 'bs_d=bsr.and.bs_k=dbksr', forr,, hdr)
          set cent on
          if (lastkey()=K_ESC)
            exit
          endif

          if (lastkey()=K_F3)
            clfnd=setcolor('n/w,n/bg')
            wfnd=wopen(10, 30, 13, 50)
            wbox(1)
            //                       kklr=0
            @ 0, 1 say 'Клиент' get kklr pict '9999999'
            read
            if (kklr#0)
              forr=for_r+'.and.kkl=kklr'
              hdr=hd_r+' '+str(kklr, 7)
            else
              forr=for_r
              hdr=hd_r
            endif

            sele dokk
            set orde to tag t2
            seek str(bsr, 6)+str(dbksr, 6)
            wclose(wfnd)
            setcolor(clfnd)
          endif

        enddo

      endif

    endif

    sele glav
  case (lastkey()=K_F5)   // Кредит
    if (krksr#0)
      sele dokk
      set orde to tag t3
      seek str(bsr, 6)+str(krksr, 6)
      if (foun())
        hd_r=str(krksr, 6)+' '+alltrim(getfield('t1', 'krksr', 'bs', 'nbs'))+' '+str(bsr, 6)
        hdr=hd_r
        for_r='!prc'
        forr='!prc'
        while (.t.)
          foot('F3', 'Фильтр')
          set cent off
          kklr=slcf('dokk',,,,, "e:mn h:'mn' c:n(6) e:rn h:'rn' c:n(6) e:rnd h:'rnd' c:n(6) e:bs_s h:'bs_s' c:n(10,2) e:kkl h:'kkl' c:n(7) e:getfield('t1','dokk->kkl','kln','nkl') h:'nkl' c:c(20) e:sk h:'sk' c:n(3) e:ddk h:'ddk' c:d(8) e:ksz h:'ksz' c:n(2)", 'kkl',, 1, 'bs_k=bsr.and.bs_d=krksr', forr,, hdr)
          set cent on
          if (lastkey()=K_ESC)
            exit
          endif

          if (lastkey()=K_F3)
            clfnd=setcolor('n/w,n/bg')
            wfnd=wopen(10, 30, 13, 50)
            wbox(1)
            //                       kklr=0
            @ 0, 1 say 'Клиент' get kklr pict '9999999'
            read
            if (kklr#0)
              forr=for_r+'.and.kkl=kklr'
              hdr=hd_r+' '+str(kklr, 7)
            else
              forr=for_r
              hdr=hd_r
            endif

            sele dokk
            set orde to tag t3
            seek str(bsr, 6)+str(krksr, 6)
            wclose(wfnd)
            setcolor(clfnd)
          endif

        enddo

      endif

    endif

    sele glav
  endcase

enddo

nuse()
sele glav
CLOSE

/*************** */
function shmdall()
  /*************** */
  clea
  set prin to shmdall.txt
  set prin on
  netuse('speng')
  netuse('mdall')
  for_r='.t.'
  forr=for_r
  sele mdall
  set orde to tag t1
  go top
  rcmdallr=recn()
  fldnomr=1
  while (.t.)
    sele mdall
    go rcmdallr
    foot('F3,F5', 'Фильтр,Чистка')
    rcmdallr=slce('mdall', 1, 1, 18,, "e:mn h:'MN' c:n(6) e:rnd h:'RND' c:n(6) e:rn h:'RN' c:n(6) e:mnp h:'MNP' c:n(6) e:sk h:'SK' c:n(3) e:dtmod h:'Дата' c:d(10) e:tmmod h:'Время' c:c(8) e:subs(dtos(prd),3,4) h:'PRD' c:c(4) e:fld h:'Операция' c:c(10) e:przp h:'П' c:n(1) e:kto h:'KTO' c:n(4) e:getfield('t1','mdall->kto','speng','fio') h:'ФИО' c:c(15) e:dtmodvz h:'ДатаВ' c:d(10) e:tmmodvz h:'ВремяВ' c:c(8)",,, 1,, forr,, 'Модифицированные документы')
    if (lastkey()=K_ESC)
      exit
    endif

    sele mdall
    go rcmdallr
    mnr=mn
    rndr=rnd
    rnr=rn
    skr=sk
    mnpr=mnp
    przpr=przp
    prdr=prd
    do case
    case (lastkey()=19)   // Left
      fldnomr=fldnomr-1
      if (fldnomr=0)
        fldnomr=1
      endif

    case (lastkey()=4)    // Right
      fldnomr=fldnomr+1
    case (lastkey()=K_F3)
      cldokk=setcolor('gr+/b,n/w')
      wdokk=wopen(10, 20, 14, 60)
      wbox(1)
      store date() to dtr
      store 0 to bhskr, ntprdr
      @ 0, 1 say 'Дата модиф>= ' get dtr
      @ 1, 1 say 'Бух-Ск       ' get bhskr pict '9'
      @ 2, 1 say 'Не тек период' get ntprdr pict '9'
      read
      wclose('wdokk')
      setcolor('cldokk')
      if (lastkey()=K_ENTER)
        if (!empty(dtr))
          forr=for_r+'.and.dtmod>=dtr'
        else
          forr=for_r
        endif

        do case
        case (bhskr=0)
          forr=forr
        case (bhskr=1)
          forr=forr+'.and.mn=0'
        case (bhskr=2)
          forr=forr+'.and.mn#0'
        endcase

        if (ntprdr=1)
          forr=for_r+'.and.prd<bom(date())'
        endif

        sele mdall
        go top
        rcmdallr=recn()
      endif

    case (lastkey()=K_F5.and.gnAdm=1)// Уд тек периода
      sele mdall
      go top
      while (!eof())
        if (prd=bom(date()))
          netdel()
        endif

        sele mdall
        skip
      enddo

      go top
      rcmdallr=recn()
    case (lastkey()=-34.and.gnAdm=1)// Удаление всех
      sele mdall
      go top
      while (!eof())
        netdel()
        sele mdall
        skip
      enddo

      go top
      rcmdallr=recn()
    endcase

  enddo

  nuse()
  set prin off
  set prin to
  return (.t.)

/************** */
function EntNn()
  /************** */
  if (bom(gdTd)<ctod('01.03.2011'))
    return (.t.)
  endif

  clea
  netuse('dokk')
  netuse('kln')
  netuse('ctov')
  netuse('mkcros')
  netuse('cgrp')
  netuse('klndog')
  netuse('fop')
  netuse('nds')
  netuse('nnds')
  netuse('cntm')
  netuse('cskl')
  netuse('grpe')
  netuse('speng')
  netuse('kpl')
  netuse('kspovo')
  sele nnds

  /*crifl() */

  dt_r=ctod('')
  kkl_r=0
  tip_r=0
  plnds_r=0
  prXml_r=0
  sk_r=0
  // sele lnnds
  // sele (anndsr)
  sele nnds
  go top
  rcnnr=recn()
  fldnomr=1
  nfor_r='.t.'
  nforr=nfor_r
  tmr=time()
  prvidr=0
  while (.t.)
    foot('F2,F3,F4,F5,F6,F7,F8,F9', 'Обновить,Фильтр,XMLпер,Печать,XML,По дням,Вид,Корр')
    //   sele lnnds
    //   sele (anndsr)
    sele nnds
    go rcnnr
    if (fieldpos('prXml')=0)
      rcnnr=slce('nnds', 1, 1, 18,, "e:nnds h:'N НН' c:n(10) e:rnd h:'RND' c:n(6) e:sk h:'SK' c:n(3) e:rn h:'RN' c:n(6) e:mnp h:'MNP' c:n(6) e:dnn h:'DNN' c:d(10) e:sm h:'SM' c:n(12,2) e:getfield('t12','nnds->mn,nnds->rnd,nnds->sk,nnds->rn,nnds->mnp','dokk','kop') h:'KOP' c:n(4) e:kkl h:'KKL' c:n(7) e:nnds1 h:'N ННB' c:n(10) e:dnn1 h:'DNNB' c:d(10) e:nn h:'NN' c:n(12) e:nsv h:'NSV' c:c(20) e:dprn h:'DPRN' c:d(10) e:ifl h:'Имя XML файла' c:c(43)",,, 1,, nforr,, 'Налоговые Накладные', fldnomr, 1)
    else
      if (prvidr=0)
        rcnnr=slce('nnds', 1, 1, 18,, "e:nnds h:'N НН' c:n(10) e:rnd h:'RND' c:n(6) e:sk h:'SK' c:n(3) e:rn h:'RN' c:n(6) e:mnp h:'MNP' c:n(6) e:dnn h:'DNN' c:d(10) e:sm h:'SM' c:n(12,2) e:getfield('t12','nnds->mn,nnds->rnd,nnds->sk,nnds->rn,nnds->mnp','dokk','kop') h:'KOP' c:n(4) e:kkl h:'KKL' c:n(7) e:prXml h:'XML' c:n(1) e:nnds1 h:'N ННB' c:n(10) e:dnn1 h:'DNNB' c:d(10) e:nn h:'NN' c:n(12) e:nsv h:'NSV' c:c(20) e:dprn h:'DPRN' c:d(10) e:ifl h:'Имя XML файла' c:c(43)",,, 1,, nforr,, 'Налоговые Накладные', fldnomr, 1)
      else
        if (fieldpos('difl')=0)
          rcnnr=slce('nnds', 1, 1, 18,, "e:nnds h:'N НН' c:n(5) e:dnn h:'DNN' c:d(10) e:prXml h:'XML' c:n(1) e:dreg h:'DREG' c:d(10) e:ifl h:'Имя XML файла' c:c(43) e:rnd h:'RND' c:n(6) e:sk h:'SK' c:n(3) e:rn h:'RN' c:n(6) e:mnp h:'MNP' c:n(6) e:sm h:'SM' c:n(12,2) e:getfield('t12','nnds->mn,nnds->rnd,nnds->sk,nnds->rn,nnds->mnp','dokk','kop') h:'KOP' c:n(4) e:kkl h:'KKL' c:n(7) e:nnds1 h:'N ННB' c:n(10) e:dnn1 h:'DNNB' c:d(10) e:nn h:'NN' c:n(12) e:nsv h:'NSV' c:c(20) e:dprn h:'DPRN' c:d(10)",,, 1,, nforr,, 'Налоговые Накладные', fldnomr, 1)
        else
          if (gnKto=145.or.gnKto=891.or.gnKto=117.or.gnAdm=1)
            if (fieldpos('prprn')#0)
              rcnnr=slce('nnds', 1, 1, 18,, "e:nnds h:'N НН' c:n(5) e:dnn h:'DNN' c:d(10) e:prprn h:'PRN' c:n(1) e:dreg h:'DREG' c:d(10) e:difl h:'DIFL' c:d(10) e:tifl h:'TIFL' c:c(8) e:rnd h:'RND' c:n(6) e:sk h:'SK' c:n(3) e:rn h:'RN' c:n(6) e:mnp h:'MNP' c:n(6) e:sm h:'SM' c:n(12,2) e:getfield('t12','nnds->mn,nnds->rnd,nnds->sk,nnds->rn,nnds->mnp','dokk','kop') h:'KOP' c:n(4) e:kkl h:'KKL' c:n(7) e:nnds1 h:'N ННB' c:n(10) e:dnn1 h:'DNNB' c:d(10) e:nn h:'NN' c:n(12) e:nsv h:'NSV' c:c(20) e:dprn h:'DPRN' c:d(10) e:ifl h:'Имя XML файла' c:c(43)",,, 1,, nforr,, 'Налоговые Накладные', fldnomr, 1)
            else
              rcnnr=slce('nnds', 1, 1, 18,, "e:nnds h:'N НН' c:n(5) e:dnn h:'DNN' c:d(10) e:prXml h:'XML' c:n(1) e:dreg h:'DREG' c:d(10) e:difl h:'DIFL' c:d(10) e:tifl h:'TIFL' c:c(8) e:rnd h:'RND' c:n(6) e:sk h:'SK' c:n(3) e:rn h:'RN' c:n(6) e:mnp h:'MNP' c:n(6) e:sm h:'SM' c:n(12,2) e:getfield('t12','nnds->mn,nnds->rnd,nnds->sk,nnds->rn,nnds->mnp','dokk','kop') h:'KOP' c:n(4) e:kkl h:'KKL' c:n(7) e:nnds1 h:'N ННB' c:n(10) e:dnn1 h:'DNNB' c:d(10) e:nn h:'NN' c:n(12) e:nsv h:'NSV' c:c(20) e:dprn h:'DPRN' c:d(10) e:ifl h:'Имя XML файла' c:c(43)",,, 1,, nforr,, 'Налоговые Накладные', fldnomr, 1)
            endif

          else
            rcnnr=slce('nnds', 1, 1, 18,, "e:nnds h:'N НН' c:n(5) e:dnn h:'DNN' c:d(10) e:prXml h:'XML' c:n(1) e:dreg h:'DREG' c:d(10) e:difl h:'DIFL' c:d(10) e:tifl h:'TIFL' c:c(8) e:rnd h:'RND' c:n(6) e:sk h:'SK' c:n(3) e:rn h:'RN' c:n(6) e:mnp h:'MNP' c:n(6) e:sm h:'SM' c:n(12,2) e:getfield('t12','nnds->mn,nnds->rnd,nnds->sk,nnds->rn,nnds->mnp','dokk','kop') h:'KOP' c:n(4) e:kkl h:'KKL' c:n(7) e:nnds1 h:'N ННB' c:n(10) e:dnn1 h:'DNNB' c:d(10) e:nn h:'NN' c:n(12) e:nsv h:'NSV' c:c(20) e:dprn h:'DPRN' c:d(10) e:ifl h:'Имя XML файла' c:c(43)",,, 1,, nforr,, 'Налоговые Накладные', fldnomr, 1)
          endif

        endif

      endif

    endif

    if (lastkey()=K_ESC)
      exit
    endif

    sele nnds
    //   sele (anndsr)
    go rcnnr
    mnr=mn
    rndr=rnd
    skr=sk
    rnr=rn
    mnpr=mnp
    kklr=kkl
    pr1ndsr=getfield('t1', 'kklr', 'kpl', 'pr1nds')
    if (rnr#0.and.pr1ndsr=1)
      pr1ndsr=0
    endif

    dnnr=dnn
    nndsr=nnds
    okpor=getfield('t1', 'gnKkl_c', 'kln', 'kkl1')

    ifl_r:=ifl_r()

    if (fieldpos('ifl')#0)
      iflr=ifl
    else
      iflr=space(43)
    endif

    if (fieldpos('prXml')#0)
      prXmlr=prXml
    else
      prXmlr=0
    endif

    pathnxmlr=gcPath_mxml+'d'+iif(day(dnnr)<10, '0'+str(day(dnnr), 1), str(day(dnnr), 2))+'\'
    if (fieldpos('prprn')#0)
      prprnr=prprn
    else
      prprnr=0
    endif

    do case
    case (lastkey()=K_LEFT)   // Left
      fldnomr=fldnomr-1
      if (fldnomr=0)
        fldnomr=1
      endif

    case (lastkey()=K_RIGHT)    // Right
      fldnomr=fldnomr+1
    case (lastkey()=K_F2) //.and.gnAdm=1 // Обновить
      ObnXml()
    //           obnnds()
    case (lastkey()=K_F3)
      clglav=setcolor('n/w,n/bg')
      wglav=wopen(7, 25, 18, 50)
      wbox(1)
      dt_r=ctod('')
      kkl_r=0
      tip_r=0
      sk_r=0
      prnnds_r=0
      ennds_r=0
      nnds_r=0
      prXml_r=0
      nreg_r=0
      @ 0, 1 say 'Дата     ' get dt_r
      @ 1, 1 say 'Тип c/б  ' get tip_r pict '9'
      @ 2, 1 say 'Клиент   ' get kkl_r pict '9999999'
      @ 3, 1 say 'Отн к НДС' get plnds_r pict '9'
      @ 4, 1 say 'Не печат.' get prnnds_r pict '9'
      @ 5, 1 say 'Склад    ' get sk_r pict '999'
      @ 6, 1 say 'Пустые НН' get ennds_r pict '9'
      @ 7, 1 say 'Номер    ' get nnds_r pict '9999999999'
      @ 8, 1 say 'XML      ' get prXml_r pict '9'
      @ 9, 1 say 'Не зарег.' get nreg_r pict '9'
      read
      wclose(wglav)
      setcolor(clglav)
      if (lastkey()#K_ESC)
        if (nnds_r#0)
          if (netseek('t1', 'nnds_r'))
            nforr=nfor_r
            rcnnr=recn()
            loop
          endif

        endif

        nforr=nfor_r
        if (!empty(dt_r))
          nforr=nforr+'.and.dnn=dt_r'
        endif

        do case
        case (tip_r=1)
          nforr=nforr+'.and.mn=0'
        case (tip_r=2)
          nforr=nforr+'.and.mn#0'
        endcase

        if (kkl_r#0)
          nforr=nforr+".and.kkl=kkl_r"
        endif

        if (prXml_r#0)
          nforr=nforr+".and.prXml=prXml_r"
        endif

        do case
        case (plnds_r=1)
          //                      nforr=nforr+".and.nn#0.and.!empty(nsv)"
          nforr=nforr+".and.nn#0"
        case (plnds_r=2)
          //                     nforr=nforr+".and.!(nn#0.and.!empty(nsv))"
          nforr=nforr+".and.nn=0"
        endcase

        if (prnnds_r#0)
          nforr=nforr+".and.empty(dprn)"
        endif

        if (sk_r#0)
          nforr=nforr+".and.sk=sk_r"
        endif

        if (nreg_r#0)
          nforr=nforr+".and.empty(dreg)"
        endif

        if (ennds_r#0)
          nforr=nfor_r+".and.rn=0"
        endif

        //              sele lnnds
        //              sele (anndsr)
        sele nnds
        go top
        rcnnr=recn()
      endif

    case (lastkey()=K_F5)
      prndsktor=0
      //           if nnds->dnn<ctod('16.12.2011')
      //              prnnn(mnr,rndr,skr,rnr,mnpr)
      //           else
      if (pr1ndsr=0)
        prnds(mnr, rndr, skr, rnr, mnpr)
      else
        pr1nn(nndsr)
      endif

    //           endif
    case (lastkey()=-34)
      prndsktor=0
      //           if nnds->dnn<ctod('16.12.2011')
      //              prnnn(mnr,rndr,skr,rnr,mnpr)
      //           else
      prnds(mnr, rndr, skr, rnr, mnpr,,, 1)
    //           endif
    case (lastkey()=-35)
      prndsktor=1
      //           if nnds->dnn<ctod('16.12.2011')
      //              prnnn(mnr,rndr,skr,rnr,mnpr)
      //           else
      prnds(mnr, rndr, skr, rnr, mnpr,,, 1)
    //           endif
    case (lastkey()=K_F6) //.and.gnAdm=1
      if (.t.)            //prXmlr=1.or.nnds->dnn>=ctod('01.01.2015')
        if (nnds->dnn>=ctod('16.03.2016').and.date()>=ctod('01.04.2016'))
          XmlNds()          // xmlnds.prg
        else
          NdsXml()          // glav.prg
        endif

      endif

    case (lastkey()=K_F4) //.and.gnAdm=1
      ndsxmlp()
    case (lastkey()=K_F7) //.and.gnAdm=1
      ndsday()              // glav.prg
    case (lastkey()=K_F8) //.and.gnAdm=1
      if (prvidr=0)
        prvidr=1
      else
        prvidr=0
      endif

    case (lastkey()=K_F9) //.and.gnAdm=1
      crnds()
    case (lastkey()=K_SPACE .and.nnds->mnp=0.and.nnds->dnn>=ctod('01.01.2015').and.(gnKto=145.or.gnKto=891.or.gnKto=117.or.gnAdm=1))
      sele cskl
      locate for sk=skr
      pathr=gcPath_d+alltrim(path)
      if (netfile('rs1', 1))
        netuse('rs1',,, 1)
        if (netseek('t1', 'rnr'))
          if (pr177=2.or.pr169=2.or.pr129=2.or.pr139=2)
            sele nnds
            if (prprn=0)
              netrepl('prprn', '1')
            else
              netrepl('prprn', '0')
            endif

          else
            wmess('Не общая ТТН', 3)
          endif

        endif

        nuse('rs1')
      endif

      sele nnds
    endcase

  enddo

  //nuse(anndsr)
  nuse()
  return (.t.)

/*************** */
function NdsXml(p1)
  // p1=1 за период
  /*************** */
  sele nnds
  mnr=mn
  rndr=rnd
  skr=sk
  rnr=rn
  mnpr=mnp
  kklr=kkl
  pr1ndsr=getfield('t1', 'kklr', 'kpl', 'pr1nds')
  if (rnr#0.and.pr1ndsr=1)
    pr1ndsr=0
  endif

  dnnr=dnn
  nndsr=nnds
  okpor=getfield('t1', 'gnKkl_c', 'kln', 'kkl1')
  prXmlr=prXml
  pathnxmlr=gcPath_mxml+'d'+iif(day(dnnr)<10, '0'+str(day(dnnr), 1), str(day(dnnr), 2))+'\'

  if (fieldpos('prprn')#0)
    prprnr=prprn
  else
    prprnr=0
  endif

  ifl_r:=ifl_r()

  if (!empty(ifl_r))
#ifdef __CLIP__
      cCodePrint:= set("PRINTER_CHARSET", "cp1251")
      set prin to (pathnxmlr+ifl_r+'.xml')
#else
      set prin to (pathnxmlr+'n'+subs(ifl_r, 26, 7)+'.xml')
#endif
    set prin on
    set cons off

    //      PERIOD_MONTHr=iif(month(nnds->dnn)<10,'0'+str(month(nnds->dnn),1),str(month(nnds->dnn),2))
    PERIOD_MONTHr=alltrim(str(month(nnds->dnn), 2))
    PERIOD_YEARr=str(year(nnds->dnn), 4)
    //      D_FILLr=strtran(dtoc(nnds->dnn),'.','')
    D_FILLr=subs(dtos(nnds->dnn), 7, 2)+subs(dtos(nnds->dnn), 5, 2)+subs(dtos(nnds->dnn), 1, 4)
    HNUMr=alltrim(str(nnds->nnds, 10))
    //      HFILLr=strtran(dtoc(nnds->dnn),'.','')
    HFILLr=subs(dtos(nnds->dnn), 7, 2)+subs(dtos(nnds->dnn), 5, 2)+subs(dtos(nnds->dnn), 1, 4)

    //      H01G1Sr='договiр поставки'
    //      sele klndog
    //      netseek('t1','nnds->kkl')
    //      H01G2Dr=strtran(dtoc(dtdogb),'.','')
    //      H01G1Dr=strtran(dtoc(dtdogb),'.','')
    //      if !empty(cndog)
    //         H01G3Sr=alltrim(cndog)
    //         H01G2Sr=alltrim(cndog)
    //      else
    //         H01G3Sr=alltrim(str(ndog,6))
    //         H01G2Sr=alltrim(str(ndog,6))
    //      endif

    HPODFILLr=strtran(dtoc(nnds->dnn1), '.', '')
    HPODNUMr=alltrim(str(nnds->nnds1, 10))

    sele kln
    netseek('t1', 'gnKkl_c')
    TINr=alltrim(str(kkl1, 10))
    HNAMESELr=alltrim(nklprn)
    if (!empty(cnn))
      HKSELr=cnn
    else
      HKSELr=alltrim(str(nn, 12))
    endif

    HLOCSELr=alltrim(adr)
    HTELSELr=alltrim(tlf)
    HNSPDVSELr=alltrim(nsv)

    sele kln
    netseek('t1', 'nnds->kkl')
    //      ckklr=alltrim(str(getfield('t1','nnds->kkl','kln','kkl1'),10))
    //      HNAMEBUYr=alltrim(nklprn)

    if (dnnr<ctod('01.01.2015'))
      if (!empty(cnn))
        HKBUYr=cnn
      else
        HKBUYr=alltrim(str(nn, 12))
      endif

      HLOCBUYr=alltrim(adr)
      HTELBUYr=alltrim(tlf)
      HNSPDVBUYr=alltrim(nsv)
      H01G1Sr='договiр поставки'
      sele klndog
      netseek('t1', 'nnds->kkl')
      H01G2Dr=strtran(dtoc(dtdogb), '.', '')
      H01G1Dr=strtran(dtoc(dtdogb), '.', '')
      if (!empty(cndog))
        H01G3Sr=alltrim(cndog)
        H01G2Sr=alltrim(cndog)
      else
        H01G3Sr=alltrim(str(ndog, 6))
        H01G2Sr=alltrim(str(ndog, 6))
      endif

      sele kln
      netseek('t1', 'nnds->kkl')
      ckklr=alltrim(str(getfield('t1', 'nnds->kkl', 'kln', 'kkl1'), 10))
      HNAMEBUYr=alltrim(nklprn)
      H02G1Sr='оплата з поточного рахунку'
      H03G1Sr='оплата з поточного рахунку'
    else
      if (kln->nn#0)
        if (!empty(kln->cnn))
          HKBUYr=kln->cnn
        else
          HKBUYr=alltrim(str(kln->nn, 12))
        endif

        HLOCBUYr=alltrim(adr)
        HTELBUYr=alltrim(tlf)
        HNSPDVBUYr=alltrim(nsv)
        H01G1Sr='договiр поставки'
        sele klndog
        netseek('t1', 'nnds->kkl')
        H01G2Dr=strtran(dtoc(dtdogb), '.', '')
        H01G1Dr=strtran(dtoc(dtdogb), '.', '')
        if (!empty(cndog))
          H01G3Sr=alltrim(cndog)
          H01G2Sr=alltrim(cndog)
        else
          H01G3Sr=alltrim(str(ndog, 6))
          H01G2Sr=alltrim(str(ndog, 6))
        endif

        sele kln
        netseek('t1', 'nnds->kkl')
        ckklr=alltrim(str(getfield('t1', 'nnds->kkl', 'kln', 'kkl1'), 10))
        HNAMEBUYr=alltrim(nklprn)
        H02G1Sr='договiр поставки'
        //            H02G1Sr='оплата з поточного рахунку'
        H03G1Sr='оплата з поточного рахунку'
      else
        HKBUYr='100000000000'
        HLOCBUYr=''
        HTELBUYr=''
        HNSPDVBUYr=''
        H01G1Sr='рахунок'
        H01G2Dr=strtran(dtoc(dnnr), '.', '')
        H01G1Dr=strtran(dtoc(dnnr), '.', '')
        H01G3Sr=alltrim(str(nnds->rn, 6))
        H01G2Sr=alltrim(str(nnds->rn, 6))
        HNAMEBUYr='Неплатник'
        ckklr=alltrim(str(getfield('t1', 'nnds->kkl', 'kln', 'kkl1'), 10))
        H02G1Sr='готiвка'
        H03G1Sr='готiвка'
      endif

    endif

    if (subs(ifl_r, 15, 8)='j1201004'.or.subs(ifl_r, 15, 8)='j1201005'.or.subs(ifl_r, 15, 8)='j1201006'.or.subs(ifl_r, 15, 8)='j1201007')
      if (pr1ndsr=0)
        skr:=nnds->sk
        ttnr:=nnds->rn
        pathr=gcPath_d+alltrim(getfield('t1', 'skr', 'cskl', 'path'))
        if (netfile('rs1', 1))
          netuse('rs1',,, 1)
          netuse('rs2',,, 1)
          netuse('rs3',,, 1)
          netuse('tov',,, 1)
          netuse('sgrp',,, 1)
          sele rs1
          netseek('t1', 'ttnr')
          vor=vo
          kopr=kop
          if (vor=3.and.(kopr=136.or.kopr=137))
            crtt('tdoc', "f:gr1 c:c(10) f:gr2 c:c(18) f:gr3 c:c(46) f:gr4 c:c(10) f:gr5 c:c(5) f:gr6 c:c(10) f:gr7 c:c(10) f:gr8 c:c(10) f:gr9 c:c(10) f:gr10 c:c(10) f:gr11 c:c(10) f:gr12 c:c(10) f:rzd c:n(2) f:nn c:n(2) f:gr51 c:c(10) f:gr52 c:c(4)")
          else
            crtt('tdoc', "f:gr1 c:c(3) f:gr2 c:c(10) f:gr3 c:c(46) f:gr4 c:c(10) f:gr5 c:c(5) f:gr6 c:c(10) f:gr7 c:c(10) f:gr8 c:c(12) f:gr9 c:c(10) f:gr10 c:c(10) f:gr11 c:c(10) f:gr12 c:c(12) f:rzd c:n(2) f:nn c:n(2) f:gr51 c:c(10) f:gr52 c:c(4)")
          endif
          sele 0
          use tdoc excl
          dnn_r=dnnr
          NdsRsN(1)
            outlog(__FILE__,__LINE__)
          ??'<?xml version="1.0" encoding="windows-1251"?>'
          if (dnnr<ctod('01.03.2014'))
            ?'<DECLAR xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="J1201004.xsd">'
          else
            if (dnnr<ctod('01.12.2014'))
              ?'<DECLAR xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="J1201005.xsd">'
            else
              if (dnnr<ctod('01.01.2015'))
                ?'<DECLAR xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="J1201006.xsd">'
              else
                ?'<DECLAR xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="J1201007.xsd">'
              endif

            endif

          endif

          ?'<DECLARHEAD>'
          ?'<TIN>'+tinr+'</TIN>'
          ?'<C_DOC>J12</C_DOC>'
          ?'<C_DOC_SUB>010</C_DOC_SUB>'
          if (dnnr<ctod('01.03.2014'))
            ?'<C_DOC_VER>4</C_DOC_VER>'
          else
            if (dnnr<ctod('01.12.2014'))
              ?'<C_DOC_VER>5</C_DOC_VER>'
            else
              if (dnnr<ctod('01.01.2015'))
                ?'<C_DOC_VER>6</C_DOC_VER>'
              else
                ?'<C_DOC_VER>7</C_DOC_VER>'
              endif

            endif

          endif

          ?'<C_DOC_TYPE>0</C_DOC_TYPE>'
          ?'<C_DOC_CNT>0</C_DOC_CNT>'
          ?'<C_REG>18</C_REG>'
          ?'<C_RAJ>19</C_RAJ>'
          ?'<PERIOD_MONTH>'+PERIOD_MONTHr+'</PERIOD_MONTH>'
          ?'<PERIOD_TYPE>1</PERIOD_TYPE>'
          ?'<PERIOD_YEAR>'+PERIOD_YEARr+'</PERIOD_YEAR>'
          ?'<C_STI_ORIG>1819</C_STI_ORIG>'
          ?'<C_DOC_STAN>1</C_DOC_STAN>'
          ?'<LINKED_DOCS xsi:nil="true"></LINKED_DOCS>'
          ?'<D_FILL>'+D_FILLr+'</D_FILL>'
          ?'<SOFTWARE xsi:nil="true"></SOFTWARE>'
          ?'</DECLARHEAD>'
          ?'<DECLARBODY>'
          //               ?'<HORIG>1</HORIG><HERPN xsi:nil="true"></HERPN>'
          ?'<HORIG>1</HORIG><HERPN>1</HERPN>'
          ?'<HORIG1 xsi:nil="true"></HORIG1>'
          ?'<HTYPR xsi:nil="true"></HTYPR>'
          ?'<HFILL>'+HFILLr+'</HFILL>'
          ?'<HNUM>'+HNUMr+'</HNUM>'
          ?'<HNUM1 xsi:nil="true"></HNUM1>'
          ?'<HNUM2 xsi:nil="true"></HNUM2>'
          ?'<HNAMESEL>'+HNAMESELr+'</HNAMESEL>'
          ?'<HNAMEBUY>'+HNAMEBUYr+'</HNAMEBUY>'
          ?'<HKSEL>'+HKSELr+'</HKSEL>'
          ?'<HKBUY>'+HKBUYr+'</HKBUY>'
          ?'<HLOCSEL>'+HLOCSELr+'</HLOCSEL>'
          ?'<HLOCBUY>'+HLOCBUYr+'</HLOCBUY>'
          ?'<HTELSEL>'+HTELSELr+'</HTELSEL>'
          ?'<HTELBUY>'+HTELBUYr+'</HTELBUY>'
          if (dnnr<ctod('01.03.2014'))
            ?'<HNSPDVSEL>'+HNSPDVSELr+'</HNSPDVSEL>'
            ?'<HNSPDVBUY>'+HNSPDVBUYr+'</HNSPDVBUY>'
          endif

          //               H01G1Sr='договiр поставки'
          ?'<H01G1S>'+H01G1Sr+'</H01G1S>'
          ?'<H01G2D>'+H01G2Dr+'</H01G2D>'
          ?'<H01G3S>'+H01G3Sr+'</H01G3S>'
          H02G1Sr='оплата з поточного рахунку'
          ?'<H02G1S>'+H02G1Sr+'</H02G1S>'
          if (dnnr<ctod('01.01.2015'))
            for irs2r=1 to 7
              nrs2r=1
              sele tdoc
              go top
              while (!eof())
                do case
                case (irs2r=1)
                  if (at('.', gr2)#0)
                    gr2r=subs(gr2, 1, 2)+subs(gr2, 4, 2)+subs(gr2, 7, 4)
                  else
                  //                                 gr2r=subs(gr2,1,2)+'.'+subs(gr2,3,2)+'.'+subs(gr2,5,4)
                  endif

                  gr2r=alltrim(gr2)
                  ?'<RXXXXG2D ROWNUM="'+alltrim(str(nrs2r, 3))+'">'+gr2r+'</RXXXXG2D>'
                  nrs2r=nrs2r+1
                case (irs2r=2)
                  ?'<RXXXXG3S ROWNUM="'+alltrim(str(nrs2r, 3))+'">'+alltrim(gr3)+'</RXXXXG3S>'
                  nrs2r=nrs2r+1
                case (irs2r=3)
                  ?'<RXXXXG4 ROWNUM="'+alltrim(str(nrs2r, 3))+'">'+alltrim(gr4)+'</RXXXXG4>'
                  nrs2r=nrs2r+1
                case (irs2r=4)
                  ?'<RXXXXG4S ROWNUM="'+alltrim(str(nrs2r, 3))+'">'+alltrim(gr5)+'</RXXXXG4S>'
                  nrs2r=nrs2r+1
                case (irs2r=5)
                  ?'<RXXXXG5 ROWNUM="'+alltrim(str(nrs2r, 3))+'">'+alltrim(gr6)+'</RXXXXG5>'
                  nrs2r=nrs2r+1
                case (irs2r=6)
                  ?'<RXXXXG6 ROWNUM="'+alltrim(str(nrs2r, 3))+'">'+alltrim(gr7)+'</RXXXXG6>'
                  nrs2r=nrs2r+1
                case (irs2r=7)
                  ?'<RXXXXG7 ROWNUM="'+alltrim(str(nrs2r, 3))+'">'+alltrim(gr8)+'</RXXXXG7>'
                  nrs2r=nrs2r+1
                case (irs2r=8)
                  ?'<RXXXXG7 ROWNUM="'+alltrim(str(nrs2r, 3))+'">'+alltrim(gr9)+'</RXXXXG7>'
                  nrs2r=nrs2r+1
                endcase

                sele tdoc
                skip
              enddo

            next

          else
            for irs2r=1 to 8
              nrs2r=1
              sele tdoc
              go top
              while (!eof())
                do case
                case (irs2r=1)
                  if (at('.', gr2)#0)
                    gr2r=subs(gr2, 1, 2)+subs(gr2, 4, 2)+subs(gr2, 7, 4)
                  else
                  //                                 gr2r=subs(gr2,1,2)+'.'+subs(gr2,3,2)+'.'+subs(gr2,5,4)
                  endif

                  gr2r=alltrim(gr2)
                  ?'<RXXXXG2D ROWNUM="'+alltrim(str(nrs2r, 3))+'">'+gr2r+'</RXXXXG2D>'
                  nrs2r=nrs2r+1
                case (irs2r=2)
                  ?'<RXXXXG3S ROWNUM="'+alltrim(str(nrs2r, 3))+'">'+alltrim(gr3)+'</RXXXXG3S>'
                  nrs2r=nrs2r+1
                case (irs2r=3)
                  ?'<RXXXXG4 ROWNUM="'+alltrim(str(nrs2r, 3))+'">'+alltrim(gr4)+'</RXXXXG4>'
                  nrs2r=nrs2r+1
                case (irs2r=4)
                  ?'<RXXXXG4S ROWNUM="'+alltrim(str(nrs2r, 3))+'">'+alltrim(gr51)+'</RXXXXG4S>'
                  nrs2r=nrs2r+1
                case (irs2r=5)
                  ?'<RXXXXG105_2S ROWNUM="'+alltrim(str(nrs2r, 3))+'">'+padl(alltrim(gr52), 4, '0')+'</RXXXXG105_2S>'
                  nrs2r=nrs2r+1
                case (irs2r=6)
                  ?'<RXXXXG5 ROWNUM="'+alltrim(str(nrs2r, 3))+'">'+alltrim(gr6)+'</RXXXXG5>'
                  nrs2r=nrs2r+1
                case (irs2r=7)
                  ?'<RXXXXG6 ROWNUM="'+alltrim(str(nrs2r, 3))+'">'+alltrim(gr7)+'</RXXXXG6>'
                  nrs2r=nrs2r+1
                case (irs2r=8)
                  ?'<RXXXXG7 ROWNUM="'+alltrim(str(nrs2r, 3))+'">'+alltrim(gr8)+'</RXXXXG7>'
                  nrs2r=nrs2r+1
                case (irs2r=9)
                  ?'<RXXXXG7 ROWNUM="'+alltrim(str(nrs2r, 3))+'">'+alltrim(gr9)+'</RXXXXG7>'
                  nrs2r=nrs2r+1
                endcase

                sele tdoc
                skip
              enddo

            next

          endif

          sele tdoc
          CLOSE
          sm10r=getfield('t1', 'ttnr,10', 'rs3', 'ssf')
          sm11r=getfield('t1', 'ttnr,11', 'rs3', 'ssf')
          sm12r=getfield('t1', 'ttnr,12', 'rs3', 'ssf')
          sm13r=getfield('t1', 'ttnr,13', 'rs3', 'ssf')
          sm18r=getfield('t1', 'ttnr,18', 'rs3', 'ssf')
          sm19r=getfield('t1', 'ttnr,19', 'rs3', 'ssf')
          sm90r=getfield('t1', 'ttnr,90', 'rs3', 'ssf')
          pstr=getfield('t1', 'ttnr', 'rs1', 'pst')

          if (pstr=0)
            R01G7r=alltrim(str(sm10r, 10, 2))
          else
            R01G7r=alltrim(str(sm10r+sm18r, 10, 2))
          endif

          ?'<R01G7>'+R01G7r+'</R01G7>'
          ?'<R01G8 xsi:nil="true"></R01G8>'
          ?'<R01G9 xsi:nil="true"></R01G9>'
          ?'<R01G10 xsi:nil="true"></R01G10>'
          ?'<R01G11>'+R01G7r+'</R01G11>'
          R02G11r=alltrim(str(sm19r, 10, 2))
          ?'<R02G11>'+R02G11r+'</R02G11>'
          R03G7r=alltrim(str((sm11r+sm12r), 10, 2))
          ?'<R03G7>'+R03G7r+'</R03G7>'
          ?'<R03G8 xsi:nil="true"></R03G8>'
          ?'<R03G9 xsi:nil="true"></R03G9>'
          ?'<R03G10S xsi:nil="true"></R03G10S>'
          ?'<R03G11>'+R03G7r+'</R03G11>'
          R04G7r=alltrim(str((sm90r-sm19r-sm13r), 10, 2))
          ?'<R04G7>'+R04G7r+'</R04G7>'
          ?'<R04G8 xsi:nil="true"></R04G8>'
          ?'<R04G9 xsi:nil="true"></R04G9>'
          ?'<R04G10 xsi:nil="true"></R04G10>'
          ?'<R04G11>'+R04G7r+'</R04G11>'
          nuse('rs1')
          nuse('rs2')
          nuse('rs3')
          nuse('tov')
          nuse('sgrp')
        endif

      else                  // pr1ndsr=1
        if (select('lnndoc')#0)
          sele lnndoc
          CLOSE
          erase lnndoc.dbf
        endif

        crtt('lnndoc', 'f:sk c:n(3) f:doc c:n(6) f:sm c:n(12,2)')
        sele 0
        use lnndoc
        if (select('lnnsk')#0)
          sele lnnsk
          CLOSE
          erase lnnsk.dbf
        endif

        crtt('lnnsk', 'f:sk c:n(3)')
        sele 0
        use lnnsk
        sele dokk
        set orde to tag t15
        if (netseek('t15', 'nndsr'))
          while (nnds=nndsr)
            skr=sk
            if (mnp=0)
              docr=rn
            else
              docr=mnp
            endif

            smr=bs_s
            sele lnndoc
            appe blank
            repl sk with skr, ;
             doc with docr,   ;
             sm with smr
            sele lnnsk
            locate for sk=skr
            if (!foun())
              appe blank
              repl sk with skr
            endif

            sele dokk
            skip
          enddo

        endif

        if (select('tdoc')#0)
          sele tdoc
          CLOSE
        endif

        crtt('tdoc', "f:gr1 c:c(3) f:gr2 c:c(10) f:gr3 c:c(46) f:gr4 c:c(10) f:gr5 c:c(5) f:gr6 c:c(10) f:gr7 c:c(10) f:gr8 c:c(12) f:gr9 c:c(10) f:gr10 c:c(10) f:gr11 c:c(10) f:gr12 c:c(12) f:rzd c:n(2) f:nn c:n(2) f:gr51 c:c(10) f:gr52 c:c(4)")
        sele 0
        use tdoc excl
        dnn_r=dnnr

        ndsrsa(1)
            outlog(__FILE__,__LINE__)
        ??'<?xml version="1.0" encoding="windows-1251"?>'
        if (dnnr<ctod('01.03.2014'))
          ?'<DECLAR xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="J1201004.xsd">'
        else
          if (dnnr<ctod('01.12.2014'))
            ?'<DECLAR xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="J1201005.xsd">'
          else
            if (dnnr<ctod('01.01.2015'))
              ?'<DECLAR xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="J1201006.xsd">'
            else
              ?'<DECLAR xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="J1201007.xsd">'
            endif

          endif

        endif

        ?'<DECLARHEAD>'
        ?'<TIN>'+tinr+'</TIN>'
        ?'<C_DOC>J12</C_DOC>'
        ?'<C_DOC_SUB>010</C_DOC_SUB>'
        if (dnnr<ctod('01.03.2014'))
          ?'<C_DOC_VER>4</C_DOC_VER>'
        else
          if (dnnr<ctod('01.12.2014'))
            ?'<C_DOC_VER>5</C_DOC_VER>'
          else
            if (dnnr<ctod('01.01.2015'))
              ?'<C_DOC_VER>6</C_DOC_VER>'
            else
              ?'<C_DOC_VER>7</C_DOC_VER>'
            endif

          endif

        endif

        ?'<C_DOC_TYPE>0</C_DOC_TYPE>'
        ?'<C_DOC_CNT>0</C_DOC_CNT>'
        ?'<C_REG>18</C_REG>'
        ?'<C_RAJ>19</C_RAJ>'
        ?'<PERIOD_MONTH>'+PERIOD_MONTHr+'</PERIOD_MONTH>'
        ?'<PERIOD_TYPE>1</PERIOD_TYPE>'
        ?'<PERIOD_YEAR>'+PERIOD_YEARr+'</PERIOD_YEAR>'
        ?'<C_STI_ORIG>1819</C_STI_ORIG>'
        ?'<C_DOC_STAN>1</C_DOC_STAN>'
        ?'<LINKED_DOCS xsi:nil="true"></LINKED_DOCS>'
        ?'<D_FILL>'+D_FILLr+'</D_FILL>'
        ?'<SOFTWARE xsi:nil="true"></SOFTWARE>'
        ?'</DECLARHEAD>'
        ?'<DECLARBODY>'
        //            ?'<HORIG>1</HORIG><HERPN xsi:nil="true"></HERPN>'
        ?'<HORIG>1</HORIG><HERPN>1</HERPN>'
        ?'<HORIG1 xsi:nil="true"></HORIG1>'
        ?'<HTYPR xsi:nil="true"></HTYPR>'
        ?'<HFILL>'+HFILLr+'</HFILL>'
        ?'<HNUM>'+HNUMr+'</HNUM>'
        ?'<HNUM1 xsi:nil="true"></HNUM1>'
        ?'<HNUM2 xsi:nil="true"></HNUM2>'
        ?'<HNAMESEL>'+HNAMESELr+'</HNAMESEL>'
        ?'<HNAMEBUY>'+HNAMEBUYr+'</HNAMEBUY>'
        ?'<HKSEL>'+HKSELr+'</HKSEL>'
        ?'<HKBUY>'+HKBUYr+'</HKBUY>'
        ?'<HLOCSEL>'+HLOCSELr+'</HLOCSEL>'
        ?'<HLOCBUY>'+HLOCBUYr+'</HLOCBUY>'
        ?'<HTELSEL>'+HTELSELr+'</HTELSEL>'
        ?'<HTELBUY>'+HTELBUYr+'</HTELBUY>'
        if (dnnr<ctod('01.03.2014'))
          ?'<HNSPDVSEL>'+HNSPDVSELr+'</HNSPDVSEL>'
          ?'<HNSPDVBUY>'+HNSPDVBUYr+'</HNSPDVBUY>'
        endif

        //            H01G1Sr='договiр поставки'
        ?'<H01G1S>'+H01G1Sr+'</H01G1S>'
        ?'<H01G2D>'+H01G2Dr+'</H01G2D>'
        ?'<H01G3S>'+H01G3Sr+'</H01G3S>'
        H02G1Sr='оплата з поточного рахунку'
        ?'<H02G1S>'+H02G1Sr+'</H02G1S>'
        if (dnnr<ctod('01.01.2015'))
          for irs2r=1 to 7
            nrs2r=1
            sele tdoc
            go top
            while (!eof())
              do case
              case (irs2r=1)
                //                           gr2r=subs(gr2,1,2)+subs(gr2,4,2)+subs(gr2,7,4)
                if (at('.', gr2)#0)
                  gr2r=subs(gr2, 1, 2)+subs(gr2, 4, 2)+subs(gr2, 7, 4)
                else
                //                              gr2r=subs(gr2,1,2)+'.'+subs(gr2,3,2)+'.'+subs(gr2,5,4)
                endif

                gr2r=alltrim(gr2)
                ?'<RXXXXG2D ROWNUM="'+alltrim(str(nrs2r, 3))+'">'+alltrim(gr2r)+'</RXXXXG2D>'
                nrs2r=nrs2r+1
              case (irs2r=2)
                ?'<RXXXXG3S ROWNUM="'+alltrim(str(nrs2r, 3))+'">'+alltrim(gr3)+'</RXXXXG3S>'
                nrs2r=nrs2r+1
              case (irs2r=3)
                ?'<RXXXXG4 ROWNUM="'+alltrim(str(nrs2r, 3))+'">'+alltrim(gr4)+'</RXXXXG4>'
                nrs2r=nrs2r+1
              case (irs2r=4)
                ?'<RXXXXG4S ROWNUM="'+alltrim(str(nrs2r, 3))+'">'+alltrim(gr5)+'</RXXXXG4S>'
                nrs2r=nrs2r+1
              case (irs2r=5)
                ?'<RXXXXG5 ROWNUM="'+alltrim(str(nrs2r, 3))+'">'+alltrim(gr6)+'</RXXXXG5>'
                nrs2r=nrs2r+1
              case (irs2r=6)
                ?'<RXXXXG6 ROWNUM="'+alltrim(str(nrs2r, 3))+'">'+alltrim(gr7)+'</RXXXXG6>'
                nrs2r=nrs2r+1
              case (irs2r=7)
                ?'<RXXXXG7 ROWNUM="'+alltrim(str(nrs2r, 3))+'">'+alltrim(gr8)+'</RXXXXG7>'
                nrs2r=nrs2r+1
              case (irs2r=8)
                ?'<RXXXXG7 ROWNUM="'+alltrim(str(nrs2r, 3))+'">'+alltrim(gr9)+'</RXXXXG7>'
                nrs2r=nrs2r+1
              endcase

              sele tdoc
              skip
            enddo

          next

        else
          for irs2r=1 to 8
            nrs2r=1
            sele tdoc
            go top
            while (!eof())
              do case
              case (irs2r=1)
                if (at('.', gr2)#0)
                  gr2r=subs(gr2, 1, 2)+subs(gr2, 4, 2)+subs(gr2, 7, 4)
                else
                //                                 gr2r=subs(gr2,1,2)+'.'+subs(gr2,3,2)+'.'+subs(gr2,5,4)
                endif

                gr2r=alltrim(gr2)
                ?'<RXXXXG2D ROWNUM="'+alltrim(str(nrs2r, 3))+'">'+gr2r+'</RXXXXG2D>'
                nrs2r=nrs2r+1
              case (irs2r=2)
                ?'<RXXXXG3S ROWNUM="'+alltrim(str(nrs2r, 3))+'">'+alltrim(gr3)+'</RXXXXG3S>'
                nrs2r=nrs2r+1
              case (irs2r=3)
                ?'<RXXXXG4 ROWNUM="'+alltrim(str(nrs2r, 3))+'">'+alltrim(gr4)+'</RXXXXG4>'
                nrs2r=nrs2r+1
              case (irs2r=4)
                ?'<RXXXXG4S ROWNUM="'+alltrim(str(nrs2r, 3))+'">'+alltrim(gr51)+'</RXXXXG4S>'
                nrs2r=nrs2r+1
              case (irs2r=5)
                ?'<RXXXXG105_2S ROWNUM="'+alltrim(str(nrs2r, 3))+'">'+padl(alltrim(gr52), 4, '0')+'</RXXXXG105_2S>'
                nrs2r=nrs2r+1
              case (irs2r=6)
                ?'<RXXXXG5 ROWNUM="'+alltrim(str(nrs2r, 3))+'">'+alltrim(gr6)+'</RXXXXG5>'
                nrs2r=nrs2r+1
              case (irs2r=7)
                ?'<RXXXXG6 ROWNUM="'+alltrim(str(nrs2r, 3))+'">'+alltrim(gr7)+'</RXXXXG6>'
                nrs2r=nrs2r+1
              case (irs2r=8)
                ?'<RXXXXG7 ROWNUM="'+alltrim(str(nrs2r, 3))+'">'+alltrim(gr8)+'</RXXXXG7>'
                nrs2r=nrs2r+1
              case (irs2r=9)
                ?'<RXXXXG7 ROWNUM="'+alltrim(str(nrs2r, 3))+'">'+alltrim(gr9)+'</RXXXXG7>'
                nrs2r=nrs2r+1
              endcase

              sele tdoc
              skip
            enddo

          next

        endif

        sele tdoc
        CLOSE

        sele lrs3
        locate for ksz=10
        if (foun())
          sm10r=ssf
        else
          sm10r=0
        endif

        locate for ksz=11
        if (foun())
          sm11r=ssf
        else
          sm11r=0
        endif

        locate for ksz=12
        if (foun())
          sm12r=ssf
        else
          sm12r=0
        endif

        locate for ksz=13
        if (foun())
          sm13r=ssf
        else
          sm13r=0
        endif

        locate for ksz=19
        if (foun())
          sm19r=ssf
        else
          sm19r=0
        endif

        locate for ksz=18
        if (foun())
          sm18r=ssf
        else
          sm18r=0
        endif

        locate for ksz=90
        if (foun())
          sm90r=ssf
        else
          sm90r=0
        endif

        R01G7r=alltrim(str(sm10r, 10, 2))
        ?'<R01G7>'+R01G7r+'</R01G7>'
        ?'<R01G8 xsi:nil="true"></R01G8>'
        ?'<R01G9 xsi:nil="true"></R01G9>'
        ?'<R01G10 xsi:nil="true"></R01G10>'
        ?'<R01G11>'+R01G7r+'</R01G11>'
        R02G11r=alltrim(str(sm19r, 10, 2))
        ?'<R02G11>'+R02G11r+'</R02G11>'
        R03G7r=alltrim(str((sm11r+sm12r), 10, 2))
        ?'<R03G7>'+R03G7r+'</R03G7>'
        ?'<R03G8 xsi:nil="true"></R03G8>'
        ?'<R03G9 xsi:nil="true"></R03G9>'
        ?'<R03G10S xsi:nil="true"></R03G10S>'
        ?'<R03G11>'+R03G7r+'</R03G11>'
        R04G7r=alltrim(str((sm90r-sm19r-sm13r), 10, 2))
        ?'<R04G7>'+R04G7r+'</R04G7>'
        ?'<R04G8 xsi:nil="true"></R04G8>'
        ?'<R04G9 xsi:nil="true"></R04G9>'
        ?'<R04G10 xsi:nil="true"></R04G10>'
        ?'<R04G11>'+R04G7r+'</R04G11>'
      endif

      ?'<R003G10S xsi:nil="true"></R003G10S>'
      do case
      case (gnEnt=20)
        ktor=145
        //                 ktor=847
      //                 ktor=882
      case (gnEnt=21)
        ktor=331
      otherwise
        ktor=gnKto
      endcase

      H10G1SR=alltrim(getfield('t1', 'ktor', 'speng', 'fio'))
      ?'<H10G1S>'+H10G1SR+'</H10G1S>'
      ?'</DECLARBODY>'
      ?'</DECLAR>'
    else
      if (pr1ndsr=0)
        skr=nnds->sk
        ndr=nnds->rn
        mnr=nnds->mnp
        pathr=gcPath_d+alltrim(getfield('t1', 'skr', 'cskl', 'path'))
        if (netfile('pr1', 1))
          netuse('pr1',,, 1)
          netuse('pr2',,, 1)
          netuse('pr3',,, 1)
          netuse('tov',,, 1)
          netuse('sgrp',,, 1)
          sele pr1
          netseek('t1', 'ndr')
          vor=vo
          kopr=kop
          crtt('tdoc', "f:gr1 c:c(10) f:gr2 c:c(18) f:gr3 c:c(46) f:gr4 c:c(10) f:gr5 c:c(5) f:gr6 c:c(10) f:gr7 c:c(10) f:gr8 c:c(10) f:gr9 c:c(10) f:gr10 c:c(10) f:gr11 c:c(10) f:gr12 c:c(10) f:rzd c:n(2) f:nn c:n(2) f:gr51 c:c(10) f:gr52 c:c(4)")
          sele 0
          use tdoc excl
          dnn_r=dnnr
          ndsprn(1)
            outlog(__FILE__,__LINE__)
          ??'<?xml version="1.0" encoding="windows-1251"?>'
          if (dnnr<ctod('01.03.2014'))
            ?'<DECLAR xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="J1201204.xsd">'
          else
            if (dnnr<ctod('01.12.2014'))
              ?'<DECLAR xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="J1201205.xsd">'
            else
              if (dnnr<ctod('01.01.2015'))
                ?'<DECLAR xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="J1201206.xsd">'
              else
                ?'<DECLAR xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="J1201207.xsd">'
              endif

            endif

          endif

          ?'<DECLARHEAD>'
          ?'<TIN>'+tinr+'</TIN>'
          ?'<C_DOC>J12</C_DOC>'
          ?'<C_DOC_SUB>012</C_DOC_SUB>'

          if (dnnr<ctod('01.03.2014'))
            ?'<C_DOC_VER>4</C_DOC_VER>'
          else
            if (dnnr<ctod('01.12.2014'))
              ?'<C_DOC_VER>5</C_DOC_VER>'
            else
              if (dnnr<ctod('01.01.2015'))
                ?'<C_DOC_VER>6</C_DOC_VER>'
              else
                ?'<C_DOC_VER>7</C_DOC_VER>'
              endif

            endif

          endif

          ?'<C_DOC_TYPE>0</C_DOC_TYPE>'
          ?'<C_DOC_CNT>0</C_DOC_CNT>'
          ?'<C_REG>18</C_REG>'
          ?'<C_RAJ>19</C_RAJ>'
          ?'<PERIOD_MONTH>'+PERIOD_MONTHr+'</PERIOD_MONTH>'
          ?'<PERIOD_TYPE>1</PERIOD_TYPE>'
          ?'<PERIOD_YEAR>'+PERIOD_YEARr+'</PERIOD_YEAR>'
          ?'<C_STI_ORIG>1819</C_STI_ORIG>'
          ?'<C_DOC_STAN>1</C_DOC_STAN>'
          ?'<LINKED_DOCS xsi:nil="true"></LINKED_DOCS>'
          ?'<D_FILL>'+D_FILLr+'</D_FILL>'
          ?'<SOFTWARE xsi:nil="true"></SOFTWARE>'
          ?'</DECLARHEAD>'
          ?'<DECLARBODY>'
          //               ?'<HORIG>1</HORIG><HERPN xsi:nil="true"></HERPN>'
          ?'<HORIG>1</HORIG><HERPN>1</HERPN>'
          ?'<HORIG1 xsi:nil="true"></HORIG1>'
          ?'<HTYPR xsi:nil="true"></HTYPR>'
          ?'<HFILL>'+HFILLr+'</HFILL>'
          ?'<HNUM>'+HNUMr+'</HNUM>'
          ?'<HNUM1 xsi:nil="true"></HNUM1>'
          ?'<HNUM2 xsi:nil="true"></HNUM2>'
          ?'<HPODFILL>'+HPODFILLr+'</HPODFILL>'
          ?'<HPODNUM>'+HPODNUMr+'</HPODNUM>'
          ?'<H01G1D>'+H01G1Dr+'</H01G1D>'
          ?'<H01G2S>'+H01G2Sr+'</H01G2S>'
          ?'<HNAMESEL>'+HNAMESELr+'</HNAMESEL>'
          ?'<HNAMEBUY>'+HNAMEBUYr+'</HNAMEBUY>'
          ?'<HKSEL>'+HKSELr+'</HKSEL>'
          ?'<HKBUY>'+HKBUYr+'</HKBUY>'
          ?'<HLOCSEL>'+HLOCSELr+'</HLOCSEL>'
          ?'<HLOCBUY>'+HLOCBUYr+'</HLOCBUY>'
          ?'<HTELSEL>'+HTELSELr+'</HTELSEL>'
          ?'<HTELBUY>'+HTELBUYr+'</HTELBUY>'
          if (dnnr<ctod('01.03.2014'))
            ?'<HNSPDVSEL>'+HNSPDVSELr+'</HNSPDVSEL>'
            ?'<HNSPDVBUY>'+HNSPDVBUYr+'</HNSPDVBUY>'
          endif

          if (HKBUYr='100000000000')
            H02G1Sr='готiвка'
          else
            H02G1Sr='договiр поставки'
          endif

          ?'<H02G1S>'+H02G1Sr+'</H02G1S>'
          //               H03G1Sr='оплата з поточного рахунку'
          ?'<H03G1S>'+H03G1Sr+'</H03G1S>'
          ?'<H02G2D>'+H01G2Dr+'</H02G2D>'
          ?'<H02G3S>'+H01G3Sr+'</H02G3S>'
          if (dnnr<ctod('01.01.2015'))
            for irs2r=1 to 10
              nrs2r=1
              sele tdoc
              go top
              while (!eof())
                do case
                case (irs2r=1)
                  gr1r=alltrim(gr1)
                  //                              gr1r=subs(gr1,1,2)+subs(gr1,4,2)+subs(gr1,7,4)
                  ?'<RXXXXG1D ROWNUM="'+alltrim(str(nrs2r, 3))+'">'+gr1r+'</RXXXXG1D>'
                  nrs2r=nrs2r+1
                case (irs2r=2)
                  ?'<RXXXXG2S ROWNUM="'+alltrim(str(nrs2r, 3))+'">'+alltrim(gr2)+'</RXXXXG2S>'
                  nrs2r=nrs2r+1
                case (irs2r=3)
                  ?'<RXXXXG3S ROWNUM="'+alltrim(str(nrs2r, 3))+'">'+alltrim(gr3)+'</RXXXXG3S>'
                  nrs2r=nrs2r+1
                case (irs2r=4)
                  ?'<RXXXXG4 ROWNUM="'+alltrim(str(nrs2r, 3))+'">'+alltrim(gr4)+'</RXXXXG4>'
                  nrs2r=nrs2r+1
                case (irs2r=5)
                  ?'<RXXXXG4S ROWNUM="'+alltrim(str(nrs2r, 3))+'">'+alltrim(gr5)+'</RXXXXG4S>'
                  nrs2r=nrs2r+1
                case (irs2r=6)
                  ?'<RXXXXG5 ROWNUM="'+alltrim(str(nrs2r, 3))+'">'+alltrim(gr6)+'</RXXXXG5>'
                  nrs2r=nrs2r+1
                case (irs2r=7)
                  ?'<RXXXXG6 ROWNUM="'+alltrim(str(nrs2r, 3))+'">'+alltrim(gr7)+'</RXXXXG6>'
                  nrs2r=nrs2r+1
                case (irs2r=8)
                  ?'<RXXXXG7 ROWNUM="'+alltrim(str(nrs2r, 3))+'">'+alltrim(gr8)+'</RXXXXG7>'
                  nrs2r=nrs2r+1
                case (irs2r=9)
                  ?'<RXXXXG8 ROWNUM="'+alltrim(str(nrs2r, 3))+'">'+alltrim(gr9)+'</RXXXXG8>'
                  nrs2r=nrs2r+1
                case (irs2r=10)
                  ?'<RXXXXG9 ROWNUM="'+alltrim(str(nrs2r, 3))+'">'+alltrim(gr10)+'</RXXXXG9>'
                  nrs2r=nrs2r+1
                endcase

                sele tdoc
                skip
              enddo

            next

          else
            for irs2r=1 to 11
              nrs2r=1
              sele tdoc
              go top
              while (!eof())
                do case
                case (irs2r=1)
                  gr1r=alltrim(gr1)
                  //                              gr1r=subs(gr1,1,2)+subs(gr1,4,2)+subs(gr1,7,4)
                  ?'<RXXXXG1D ROWNUM="'+alltrim(str(nrs2r, 3))+'">'+gr1r+'</RXXXXG1D>'
                  nrs2r=nrs2r+1
                case (irs2r=2)
                  ?'<RXXXXG2S ROWNUM="'+alltrim(str(nrs2r, 3))+'">'+alltrim(gr2)+'</RXXXXG2S>'
                  nrs2r=nrs2r+1
                case (irs2r=3)
                  ?'<RXXXXG3S ROWNUM="'+alltrim(str(nrs2r, 3))+'">'+alltrim(gr3)+'</RXXXXG3S>'
                  nrs2r=nrs2r+1
                case (irs2r=4)
                  ?'<RXXXXG4 ROWNUM="'+alltrim(str(nrs2r, 3))+'">'+alltrim(gr4)+'</RXXXXG4>'
                  nrs2r=nrs2r+1
                case (irs2r=5)
                  ?'<RXXXXG4S ROWNUM="'+alltrim(str(nrs2r, 3))+'">'+alltrim(gr51)+'</RXXXXG4S>'
                  nrs2r=nrs2r+1
                case (irs2r=6)
                  ?'<RXXXXG105_2S ROWNUM="'+alltrim(str(nrs2r, 3))+'">'+padl(alltrim(gr52), 4, '0')+'</RXXXXG105_2S>'
                  nrs2r=nrs2r+1
                case (irs2r=7)
                  ?'<RXXXXG5 ROWNUM="'+alltrim(str(nrs2r, 3))+'">'+alltrim(gr6)+'</RXXXXG5>'
                  nrs2r=nrs2r+1
                case (irs2r=8)
                  ?'<RXXXXG6 ROWNUM="'+alltrim(str(nrs2r, 3))+'">'+alltrim(gr7)+'</RXXXXG6>'
                  nrs2r=nrs2r+1
                case (irs2r=9)
                  ?'<RXXXXG7 ROWNUM="'+alltrim(str(nrs2r, 3))+'">'+alltrim(gr8)+'</RXXXXG7>'
                  nrs2r=nrs2r+1
                case (irs2r=10)
                  ?'<RXXXXG8 ROWNUM="'+alltrim(str(nrs2r, 3))+'">'+alltrim(gr9)+'</RXXXXG8>'
                  nrs2r=nrs2r+1
                case (irs2r=11)
                  ?'<RXXXXG9 ROWNUM="'+alltrim(str(nrs2r, 3))+'">'+alltrim(gr10)+'</RXXXXG9>'
                  nrs2r=nrs2r+1
                endcase

                sele tdoc
                skip
              enddo

            next

          endif

          sele tdoc
          CLOSE
          //               sm10r=-getfield('t1','mnr,10','pr3','ssf')
          sm10r=-(getfield('t1', 'mnr,10', 'pr3', 'ssf')+getfield('t1', 'mnr,40', 'pr3', 'ssf'))
          sm11r=-getfield('t1', 'mnr,11', 'pr3', 'ssf')
          R01G9r=alltrim(str(sm10r, 10, 2))
          ?'<R01G8 xsi:nil="true"></R01G8>'
          ?'<R01G9>'+R01G9r+'</R01G9>'
          ?'<R01G10 xsi:nil="true"></R01G10>'
          //               R02G9r=alltrim(str(sm10r*20/100,10,2))
          R02G9r=alltrim(str(sm11r, 10, 2))
          ?'<R02G9>'+R02G9r+'</R02G9>'
          ?'<R02G11 xsi:nil="true"></R02G11>'
          ?'<R03G7 xsi:nil="true"></R03G7>'
          ?'<R03G8 xsi:nil="true"></R03G8>'
          ?'<R03G9 xsi:nil="true"></R03G9>'
          ?'<R03G10S xsi:nil="true"></R03G10S>'
          ?'<R03G11 xsi:nil="true"></R03G11>'
          ?'<R04G7 xsi:nil="true"></R04G7>'
          ?'<R04G8 xsi:nil="true"></R04G8>'
          ?'<R04G9 xsi:nil="true"></R04G9>'
          ?'<R04G10 xsi:nil="true"></R04G10>'
          ?'<R04G11 xsi:nil="true"></R04G11>'
          nuse('pr1')
          nuse('pr2')
          nuse('pr3')
          nuse('tov')
          nuse('sgrp')
        endif

      else                  // pr1ndsr=1
        if (select('lnndoc')#0)
          sele lnndoc
          CLOSE
          erase lnndoc.dbf
        endif

        crtt('lnndoc', 'f:sk c:n(3) f:doc c:n(6) f:sm c:n(12,2)')
        sele 0
        use lnndoc
        if (select('lnnsk')#0)
          sele lnnsk
          CLOSE
          erase lnnsk.dbf
        endif

        crtt('lnnsk', 'f:sk c:n(3)')
        sele 0
        use lnnsk
        sele dokk
        set orde to tag t15
        if (netseek('t15', 'nndsr'))
          while (nnds=nndsr)
            skr=sk
            if (mnp=0)
              docr=rn
            else
              docr=mnp
            endif

            smr=bs_s
            sele lnndoc
            appe blank
            repl sk with skr, ;
             doc with docr,   ;
             sm with smr
            sele lnnsk
            locate for sk=skr
            if (!foun())
              appe blank
              repl sk with skr
            endif

            sele dokk
            skip
          enddo

        endif

        if (select('tdoc')#0)
          sele tdoc
          CLOSE
        endif

        crtt('tdoc', "f:gr1 c:c(10) f:gr2 c:c(18) f:gr3 c:c(46) f:gr4 c:c(10) f:gr5 c:c(5) f:gr6 c:c(10) f:gr7 c:c(10) f:gr8 c:c(10) f:gr9 c:c(10) f:gr10 c:c(10) f:gr11 c:c(10) f:gr12 c:c(10) f:rzd c:n(2) f:nn c:n(2) f:gr51 c:c(10) f:gr52 c:c(4)")
        sele 0
        use tdoc excl
        dnn_r=dnnr
        ndspra(1)
            outlog(__FILE__,__LINE__)
        ??'<?xml version="1.0" encoding="windows-1251"?>'
        if (dnnr<ctod('01.03.2014'))
          ?'<DECLAR xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="J1201204.xsd">'
        else
          if (dnnr<ctod('01.12.2014'))
            ?'<DECLAR xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="J1201205.xsd">'
          else
            if (dnnr<ctod('01.01.2015'))
              ?'<DECLAR xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="J1201206.xsd">'
            else
              ?'<DECLAR xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="J1201207.xsd">'
            endif

          endif

        endif

        ?'<DECLARHEAD>'
        ?'<TIN>'+tinr+'</TIN>'
        ?'<C_DOC>J12</C_DOC>'
        ?'<C_DOC_SUB>012</C_DOC_SUB>'
        if (dnnr<ctod('01.03.2014'))
          ?'<C_DOC_VER>4</C_DOC_VER>'
        else
          if (dnnr<ctod('01.12.2014'))
            ?'<C_DOC_VER>5</C_DOC_VER>'
          else
            if (dnnr<ctod('01.01.2015'))
              ?'<C_DOC_VER>6</C_DOC_VER>'
            else
              ?'<C_DOC_VER>7</C_DOC_VER>'
            endif

          endif

        endif

        //            ?'<C_DOC_VER>4</C_DOC_VER>'
        ?'<C_DOC_TYPE>0</C_DOC_TYPE>'
        ?'<C_DOC_CNT>0</C_DOC_CNT>'
        ?'<C_REG>18</C_REG>'
        ?'<C_RAJ>19</C_RAJ>'
        ?'<PERIOD_MONTH>'+PERIOD_MONTHr+'</PERIOD_MONTH>'
        ?'<PERIOD_TYPE>1</PERIOD_TYPE>'
        ?'<PERIOD_YEAR>'+PERIOD_YEARr+'</PERIOD_YEAR>'
        ?'<C_STI_ORIG>1819</C_STI_ORIG>'
        ?'<C_DOC_STAN>1</C_DOC_STAN>'
        ?'<LINKED_DOCS xsi:nil="true"></LINKED_DOCS>'
        ?'<D_FILL>'+D_FILLr+'</D_FILL>'
        ?'<SOFTWARE xsi:nil="true"></SOFTWARE>'
        ?'</DECLARHEAD>'
        ?'<DECLARBODY>'
        //            ?'<HORIG>1</HORIG><HERPN xsi:nil="true"></HERPN>'
        ?'<HORIG>1</HORIG><HERPN>1</HERPN>'
        ?'<HORIG1 xsi:nil="true"></HORIG1>'
        ?'<HTYPR xsi:nil="true"></HTYPR>'
        ?'<HFILL>'+HFILLr+'</HFILL>'
        ?'<HNUM>'+HNUMr+'</HNUM>'
        ?'<HNUM1 xsi:nil="true"></HNUM1>'
        ?'<HNUM2 xsi:nil="true"></HNUM2>'
        ?'<HPODFILL>'+HPODFILLr+'</HPODFILL>'
        ?'<HPODNUM>'+HPODNUMr+'</HPODNUM>'
        ?'<H01G1D>'+H01G1Dr+'</H01G1D>'
        ?'<H01G2S>'+H01G2Sr+'</H01G2S>'
        ?'<HNAMESEL>'+HNAMESELr+'</HNAMESEL>'
        ?'<HNAMEBUY>'+HNAMEBUYr+'</HNAMEBUY>'
        ?'<HKSEL>'+HKSELr+'</HKSEL>'
        ?'<HKBUY>'+HKBUYr+'</HKBUY>'
        ?'<HLOCSEL>'+HLOCSELr+'</HLOCSEL>'
        ?'<HLOCBUY>'+HLOCBUYr+'</HLOCBUY>'
        ?'<HTELSEL>'+HTELSELr+'</HTELSEL>'
        ?'<HTELBUY>'+HTELBUYr+'</HTELBUY>'
        if (dnnr<ctod('01.03.2014'))
          ?'<HNSPDVSEL>'+HNSPDVSELr+'</HNSPDVSEL>'
          ?'<HNSPDVBUY>'+HNSPDVBUYr+'</HNSPDVBUY>'
        endif

        //            H02G1Sr='договiр поставки'
        ?'<H02G1S>'+H02G1Sr+'</H02G1S>'
        H03G1Sr='оплата з поточного рахунку'
        ?'<H03G1S>'+H03G1Sr+'</H03G1S>'
        ?'<H02G2D>'+H01G2Dr+'</H02G2D>'
        ?'<H02G3S>'+H01G3Sr+'</H02G3S>'
        if (dnnr<ctod('01.01.2015'))
          for irs2r=1 to 10
            nrs2r=1
            sele tdoc
            go top
            while (!eof())
              do case
              case (irs2r=1)
                gr1r=alltrim(gr1)
                //                           gr1r=subs(gr1,1,2)+subs(gr1,4,2)+subs(gr1,7,4)
                ?'<RXXXXG1D ROWNUM="'+alltrim(str(nrs2r, 3))+'">'+gr1r+'</RXXXXG1D>'
                nrs2r=nrs2r+1
              case (irs2r=2)
                ?'<RXXXXG2S ROWNUM="'+alltrim(str(nrs2r, 3))+'">'+alltrim(gr2)+'</RXXXXG2S>'
                nrs2r=nrs2r+1
              case (irs2r=3)
                ?'<RXXXXG3S ROWNUM="'+alltrim(str(nrs2r, 3))+'">'+alltrim(gr3)+'</RXXXXG3S>'
                nrs2r=nrs2r+1
              case (irs2r=4)
                ?'<RXXXXG4 ROWNUM="'+alltrim(str(nrs2r, 3))+'">'+alltrim(gr4)+'</RXXXXG4>'
                nrs2r=nrs2r+1
              case (irs2r=5)
                ?'<RXXXXG4S ROWNUM="'+alltrim(str(nrs2r, 3))+'">'+alltrim(gr5)+'</RXXXXG4S>'
                nrs2r=nrs2r+1
              case (irs2r=6)
                ?'<RXXXXG5 ROWNUM="'+alltrim(str(nrs2r, 3))+'">'+alltrim(gr6)+'</RXXXXG5>'
                nrs2r=nrs2r+1
              case (irs2r=7)
                ?'<RXXXXG6 ROWNUM="'+alltrim(str(nrs2r, 3))+'">'+alltrim(gr7)+'</RXXXXG6>'
                nrs2r=nrs2r+1
              case (irs2r=8)
                ?'<RXXXXG7 ROWNUM="'+alltrim(str(nrs2r, 3))+'">'+alltrim(gr8)+'</RXXXXG7>'
                nrs2r=nrs2r+1
              case (irs2r=9)
                ?'<RXXXXG8 ROWNUM="'+alltrim(str(nrs2r, 3))+'">'+alltrim(gr9)+'</RXXXXG8>'
                nrs2r=nrs2r+1
              case (irs2r=10)
                ?'<RXXXXG9 ROWNUM="'+alltrim(str(nrs2r, 3))+'">'+alltrim(gr10)+'</RXXXXG9>'
                nrs2r=nrs2r+1
              endcase

              sele tdoc
              skip
            enddo

          next

        else
          for irs2r=1 to 11
            nrs2r=1
            sele tdoc
            go top
            while (!eof())
              do case
              case (irs2r=1)
                gr1r=alltrim(gr1)
                //                           gr1r=subs(gr1,1,2)+subs(gr1,4,2)+subs(gr1,7,4)
                ?'<RXXXXG1D ROWNUM="'+alltrim(str(nrs2r, 3))+'">'+gr1r+'</RXXXXG1D>'
                nrs2r=nrs2r+1
              case (irs2r=2)
                ?'<RXXXXG2S ROWNUM="'+alltrim(str(nrs2r, 3))+'">'+alltrim(gr2)+'</RXXXXG2S>'
                nrs2r=nrs2r+1
              case (irs2r=3)
                ?'<RXXXXG3S ROWNUM="'+alltrim(str(nrs2r, 3))+'">'+alltrim(gr3)+'</RXXXXG3S>'
                nrs2r=nrs2r+1
              case (irs2r=4)
                ?'<RXXXXG4 ROWNUM="'+alltrim(str(nrs2r, 3))+'">'+alltrim(gr4)+'</RXXXXG4>'
                nrs2r=nrs2r+1
              case (irs2r=5)
                ?'<RXXXXG4S ROWNUM="'+alltrim(str(nrs2r, 3))+'">'+alltrim(gr51)+'</RXXXXG4S>'
                nrs2r=nrs2r+1
              case (irs2r=6)
                ?'<RXXXXG105_2S ROWNUM="'+alltrim(str(nrs2r, 3))+'">'+padl(alltrim(gr52), 4, '0')+'</RXXXXG105_2S>'
                nrs2r=nrs2r+1
              case (irs2r=7)
                ?'<RXXXXG5 ROWNUM="'+alltrim(str(nrs2r, 3))+'">'+alltrim(gr6)+'</RXXXXG5>'
                nrs2r=nrs2r+1
              case (irs2r=8)
                ?'<RXXXXG6 ROWNUM="'+alltrim(str(nrs2r, 3))+'">'+alltrim(gr7)+'</RXXXXG6>'
                nrs2r=nrs2r+1
              case (irs2r=9)
                ?'<RXXXXG7 ROWNUM="'+alltrim(str(nrs2r, 3))+'">'+alltrim(gr8)+'</RXXXXG7>'
                nrs2r=nrs2r+1
              case (irs2r=10)
                ?'<RXXXXG8 ROWNUM="'+alltrim(str(nrs2r, 3))+'">'+alltrim(gr9)+'</RXXXXG8>'
                nrs2r=nrs2r+1
              case (irs2r=11)
                ?'<RXXXXG9 ROWNUM="'+alltrim(str(nrs2r, 3))+'">'+alltrim(gr10)+'</RXXXXG9>'
                nrs2r=nrs2r+1
              endcase

              sele tdoc
              skip
            enddo

          next

        endif

        sele tdoc
        CLOSE
        sele lpr3
        locate for ksz=10
        if (foun())
          sm10r=-ssf
        else
          sm10r=0
        endif

        locate for ksz=40
        if (foun())
          sm40r=-ssf
        else
          sm40r=0
        endif

        locate for ksz=11
        if (foun())
          sm11r=-ssf
        else
          sm11r=0
        endif

        R01G9r=alltrim(str(sm10r+sm40r, 10, 2))
        ?'<R01G8 xsi:nil="true"></R01G8>'
        ?'<R01G9>'+R01G9r+'</R01G9>'
        ?'<R01G10 xsi:nil="true"></R01G10>'
        //            R02G9r=alltrim(str(sm10r*20/100,10,2))
        R02G9r=alltrim(str(sm11r, 10, 2))
        ?'<R02G9>'+R02G9r+'</R02G9>'
        ?'<R02G11 xsi:nil="true"></R02G11>'
        ?'<R03G7 xsi:nil="true"></R03G7>'
        ?'<R03G8 xsi:nil="true"></R03G8>'
        ?'<R03G9 xsi:nil="true"></R03G9>'
        ?'<R03G10S xsi:nil="true"></R03G10S>'
        ?'<R03G11 xsi:nil="true"></R03G11>'
        ?'<R04G7 xsi:nil="true"></R04G7>'
        ?'<R04G8 xsi:nil="true"></R04G8>'
        ?'<R04G9 xsi:nil="true"></R04G9>'
        ?'<R04G10 xsi:nil="true"></R04G10>'
        ?'<R04G11 xsi:nil="true"></R04G11>'
      endif

      ?'<R003G10S xsi:nil="true"></R003G10S>'
      do case
      case (gnEnt=20)
        ktor=145
        //                 ktor=847
      //                 ktor=882
      case (gnEnt=21)
        ktor=331
      otherwise
        ktor=gnKto
      endcase

      H10G1SR=alltrim(getfield('t1', 'ktor', 'speng', 'fio'))
      H10G1Dr=HFILLr
      ?'<H10G1D>'+H10G1Dr+'</H10G1D>'
      ?'<H10G2S>'+H10G1SR+'</H10G2S>'
      ?'</DECLARBODY>'
      ?'</DECLAR>'
    endif

#ifdef __CLIP__
      set("PRINTER_CHARSET", cCodePrint)
#endif
    set prin off
    set prin to
    set cons on
    sele nnds
#ifdef __CLIP__
      if (file(pathnxmlr+ifl_r+'.xml'))
        sele nnds
        if (fieldpos('ifl')#0)
          netrepl('ifl', 'ifl_r')
        endif

        if (fieldpos('difl')#0)
          difl_r=date()
          tifl_r=time()
          netrepl('difl,tifl', 'difl_r,tifl_r')
        endif

        if (fieldpos('kto')#0)
          if (gnEnt=20)
            //                  netrepl('kto','847')
            netrepl('kto', '882')
          endif

          if (gnEnt=21)
            netrepl('kto', '331')
          endif

        endif

      else
        ifl_rr=''
        sele nnds
        if (fieldpos('ifl')#0)
          netrepl('ifl', 'ifl_rr')
        endif

        if (fieldpos('difl')#0)
          difl_r=ctod('')
          tifl_r=space(8)
          netrepl('difl,tifl', 'difl_r,tifl_r')
        endif

        if (fieldpos('kto')#0)
          netrepl('kto', '0')
        endif

      endif

#else
      if (file(pathnxmlr+'n'+subs(ifl_r, 26, 7)+'.xml'))
        sele nnds
        if (fieldpos('ifl')#0)
          netrepl('ifl', 'ifl_r')
        endif

        if (fieldpos('difl')#0)
          difl_r=date()
          tifl_r=time()
          netrepl('difl,tifl', 'difl_r,tifl_r')
        endif

        if (gnEnt=20)
          //               netrepl('kto','847')
          netrepl('kto', '882')
        endif

        if (gnEnt=21)
          netrepl('kto', '331')
        endif

      else
        ifl_rr=''
        sele nnds
        if (fieldpos('ifl')#0)
          netrepl('ifl', 'ifl_rr')
        endif

        if (fieldpos('difl')#0)
          difl_r=ctod('')
          tifl_r=space(8)
          netrepl('difl,tifl', 'difl_r,tifl_r')
        endif

        if (fieldpos('kto')#0)
          netrepl('kto', '0')
        endif

      endif

#endif
  endif

  return (.t.)

/*************** */
function obnnds()
  /*************** */
  clea
  set prin to entnn.txt
  set prin on
  sele dokk
  set orde to tag t4
  go top
  while (!eof())
    if (!(bs_k=641002.or.bs_d=641002.and.bs_k=704101))
      skip
      loop
    endif

    nnds(1)
    sele dokk
    mnr=mn
    rndr=rnd
    skr=sk
    rnr=rn
    mnpr=mnp
    nndsr=nnds
    //              nndsr=getfield('t2','mnr,rndr,skr,rnr,mnpr','nnds','nnds')
    //              sele dokk
    //              netrepl('nnds','nndsr')
    if (skr#0.and.nndsr#0)
      sele cskl
      locate for sk=skr
      pathr=gcPath_d+alltrim(path)
      if (mnpr=0)
        if (netfile('rs1', 1))
          netuse('rs1',,, 1)
          if (netseek('t1', 'rnr'))
            if (nnds#nndsr)
              ?str(skr, 3)+' '+str(ttn, 6)+' '+'rs1->nnds'+' '+str(rs1->nnds, 10)+' '+'nnds->nnds'+' '+str(nndsr, 10)
            endif

            netrepl('nnds', 'nndsr')
          endif

          nuse('rs1')
        endif

      else
        if (netfile('pr1', 1))
          netuse('pr1',,, 1)
          if (netseek('t2', 'mnpr'))
            if (nnds#nndsr)
              ?str(skr, 3)+' '+str(nd, 6)+' '+str(mn, 6)+' '+'pr1->nnds'+' '+str(pr1->nnds, 10)+' '+'nnds->nnds'+' '+str(nndsr, 10)
            endif

            netrepl('nnds', 'nndsr')
          endif

          nuse('pr1')
        endif

      endif

    endif

    sele dokk
    skip
  enddo

  sele nnds
  go top
  while (!eof())
    nndsr=nnds
    mnr=mn
    rndr=rnd
    skr=sk
    rnr=rn
    mnpr=mnp
    sele dokk
    if (netseek('t12', 'mnr,rndr,skr,rnr,mnpr'))
      sm_r=0
      while (mn=mnr.and.rnd=rndr.and.sk=skr.and.rn=rnr.and.mnp=mnpr)
        if (bs_k=641002.or.bs_d=641002.and.bs_k=704101)
          if (dokk->nnds=0)
            netrepl('nnds', 'nndsr')
          else
            if (dokk->nnds#nndsr)
              sele nnds
              cnlr=''
              netrepl('mn,rnd,sk,rn,mnp,sm,kkl,nn,nsv', '0,0,0,0,0,0,0,0,cnlr')
              netrepl('mn1,rnd1,sk1,rn1,mnp1,nnds1', '0,0,0,0,0,0')
            endif

          endif

          sm_r=sm_r+dokk->bs_s
        endif

        sele dokk
        skip
      enddo

      sele nnds
      netrepl('sm', 'sm_r')
    else
      sele nnds
      if (rn#0)
        ?'NNDS '+str(nnds, 10)+' '+str(mn, 6)+' '+str(rnd, 6)+' '+str(sk, 3)+' '+str(mnp, 6)+' нет в DOKK обнулен'
      endif

      cnlr=''
      netrepl('mn,rnd,sk,rn,mnp,sm,kkl,nn,nsv', '0,0,0,0,0,0,0,0,cnlr')
      netrepl('mn1,rnd1,sk1,rn1,mnp1,nnds1,sm1', '0,0,0,0,0,0,0')
    endif

    sele nnds
    skip
  enddo

  set prin off
  set prin to txt.txt
  sele nnds
  go top
  rcnnr=recn()
  return (.t.)

/*************** */
function obnxml()
  /*************** */
  if (gnEntRm#0)
    return (.t.)
  endif

  mess('Обновление...')
  crtt('tsk', 'f:sk c:n(3) f:alssk c:c(6)')
  sele 0
  use tsk shared
  sele nnds
  go top
  /*wait */
  while (!eof())
    dnnr=dnn
    prXmlr=prXml
    pathnxmlr=gcPath_mxml+'d'+iif(day(dnnr)<10, '0'+str(day(dnnr), 1), str(day(dnnr), 2))+'\'
    if (fieldpos('ifl')#0)
      ifl_r=lower(ifl)
      netrepl('ifl', 'ifl_r')
      if (!empty(ifl_r))
#ifdef __CLIP__
          if (!file(pathnxmlr+ifl_r+'.xml'))
            ifl_rr=''
            sele nnds
            netrepl('ifl', 'ifl_rr')
            if (fieldpos('difl')#0)
              difl_r=ctod('')
              tifl_r=space(8)
              netrepl('difl,tifl', 'difl_r,tifl_r')
            endif

          else
            //               if prXmlr=0
            //                  erase(pathnxmlr+ifl_r+'.xml')
            //                  ifl_rr=''
            //                  sele nnds
            //                  netrepl('ifl','ifl_rr')
            //                  if fieldpos('difl')#0
            //                     difl_r=ctod('')
            //                     tifl_r=space(8)
            //                     netrepl('difl,tifl','difl_r,tifl_r')
            //                  endif
          //               endif
          endif

#else
          if (!file(pathnxmlr+'n'+subs(ifl_r, 26, 7)+'.xml'))
            ifl_rr=''
            sele nnds
            netrepl('ifl', 'ifl_rr')
            if (fieldpos('difl')#0)
              difl_r=ctod('')
              tifl_r=space(0)
              netrepl('difl,tifl', 'difl_r,tifl_r')
            endif

          else
            //               if prXmlr=0
            //                  erase(pathnxmlr+'n'+subs(ifl_r,26,7)+'.xml')
            //                  ifl_rr=''
            //                  sele nnds
            //                  netrepl('ifl','ifl_rr')
            //                  if fieldpos('difl')#0
            //                     difl_r=ctod('')
            //                     tifl_r=space(0)
            //                     netrepl('difl,tifl','difl_r,tifl_r')
            //                  endif
          //               endif
          endif

#endif
      endif

    endif

    sele nnds
    if (mn#0)
      if (sm<10000)
        netrepl('prXml', '0')
      endif

      skip
      loop
    endif

    kklr=kkl
    rnr=rn
    pr1ndsr=getfield('t1', 'kklr', 'kpl', 'pr1nds')
    if (rnr#0.and.pr1ndsr=1)
      pr1ndsr=0
    endif

    if (pr1ndsr=0)
      if (rn=0)
        skip
        loop
      endif

    else
      //      if kkl=0
      netrepl('prXml', '1')
      skip
      loop
    //      endif
    endif

    prXmlr=0
    skr=sk
    rnr=rn
    mnpr=mnp
    cskr=str(skr, 3)
    frs1r='rs1'+cskr
    frs2r='rs2'+cskr
    fpr1r='pr1'+cskr
    fpr2r='pr2'+cskr
    sele tsk
    locate for sk=skr
    if (!foun())
      appe blank
      repl sk with skr
      sele cskl
      locate for sk=skr
      pathr=gcPath_d+alltrim(path)
      if (netfile('rs1', 1))
        netuse('rs1', frs1r,, 1)
        netuse('rs2', frs2r,, 1)
      endif

      if (netfile('pr1', 1))
        netuse('pr1', fpr1r,, 1)
        netuse('pr2', fpr2r,, 1)
      endif

    endif

    if (mnpr=0)
      if (select(frs1r)#0)
        sele (frs1r)
        kopr=getfield('t1', 'rnr', frs1r, 'kop')
        if (kopr=160.or.kopr=161)
          sele (frs2r)
          if (netseek('t1', 'rnr'))
            while (ttn=rnr)
              mntovr=mntov
              uktr=getfield('t1', 'mntovr', 'ctov', 'ukt')
              if (!empty(uktr))
                prXmlr=1
                exit
              endif

              sele (frs2r)
              skip
            enddo

          endif

        else
          prXmlr=0
        endif

      endif

    else
      if (select(fpr1r)#0)
        kopr=getfield('t2', 'mnpr', fpr1r, 'kop')
        if (kopr=108.or.kopr=110)
          sele (fpr2r)
          if (netseek('t1', 'mnpr'))
            while (mn=mnpr)
              mntovr=mntov
              uktr=getfield('t1', 'mntovr', 'ctov', 'ukt')
              if (!empty(uktr))
                prXmlr=1
                exit
              endif

              sele (fpr2r)
              skip
            enddo

          endif

        else
          prXmlr=0
        endif

      endif

    endif

    sele nnds
    if (fieldpos('prXml')#0)
      //      if nn#0.and.!empty(nsv)
      if (nn#0)
        netrepl('prXml', 'prXmlr')
      else
        prXmlr=0
      endif

      if (prXmlr=0)
        iflr=''
        //         netrepl('ifl,prXml','iflr,0')
        netrepl('prXml', '0')
      endif

    endif

    skip
  enddo

  sele tsk
  go top
  while (!eof())
    skr=sk
    cskr=str(skr, 3)
    frs1r='rs1'+cskr
    frs2r='rs2'+cskr
    fpr1r='pr1'+cskr
    fpr2r='pr2'+cskr
    nuse(frs1r)
    nuse(frs2r)
    nuse(fpr1r)
    nuse(fpr2r)
    sele tsk
    skip
  enddo

  sele tsk
  CLOSE
  erase tsk.dbf
  /*erase abc.dbf */

  mess('Обновление регистации...')
  sele nnds
  if (fieldpos('dreg')#0)
#ifndef __CLIP__
      //     fregr=gcPath_nxml+'OUTNAKLKVT'+str(year(gdTd),4)+iif(month(gdTd)<10,'0'+str(month(gdTd),1),str(month(gdTd),2))+iif(day(gdTd)<10,'0'+str(day(gdTd),1),str(day(gdTd),2))+'.dbf'  //g:\work\upgrade\resurs\nxml\OUTNAKLKVT20120112.dbf
      fregr=gcPath_nxml+'OUTNAKLKVT'+str(year(date()), 4)+iif(month(date())<10, '0'+str(month(date()), 1), str(month(date()), 2))+iif(day(date())<10, '0'+str(day(date()), 1), str(day(date()), 2))+'.dbf'//g:\work\upgrade\resurs\nxml\OUTNAKLKVT20120112.dbf
      erase xmldbf1.bat
      erase xmldbf2.bat
      ffr=fcreate('xmldbf1.bat')
      fwrite(ffr, '@echo off '+chr(13)+chr(10))
      fwrite(ffr, 'cmd /Q /C xmldbf2.bat')
      fclose(ffr)

      ffr=fcreate('xmldbf2.bat')
      fwrite(ffr, '@echo off '+chr(13)+chr(10))
      fwrite(ffr, 'copy '+fregr+' abc.dbf /n >kkk'+chr(13)+chr(10))
      fclose(ffr)
      !xmldbf1.bat
#else
      if (gnEnt=20)
        fregr='/m1/upgrade/resurs/nxml/OUTNAKLKVT'+str(year(date()), 4)+iif(month(date())<10, '0'+str(month(date()), 1), str(month(date()), 2))+iif(day(date())<10, '0'+str(day(date()), 1), str(day(date()), 2))+'.dbf'//g:\work\upgrade\resurs\nxml\OUTNAKLKVT20120112.dbf
      else
        fregr='/m1/upgrade/lodis/nxml/OUTNAKLKVT'+str(year(date()), 4)+iif(month(date())<10, '0'+str(month(date()), 1), str(month(date()), 2))+iif(day(date())<10, '0'+str(day(date()), 1), str(day(date()), 2))+'.dbf'//g:\work\upgrade\resurs\nxml\OUTNAKLKVT20120112.dbf
      endif

      cLogSysCmd:=""
      cCmd:="cp "+fregr+" abc.dbf"
      SYSCMD(cCmd, "", @cLogSysCmd)
      if (!EMPTY(cLogSysCmd))
        OUTLOG(__FILE__, __LINE__, cLogSysCmd, cCmd, gnEnt)
      endif

#endif
  endif

  if (file('abc.dbf'))
    sele 0
    use abc shared
    go top
    while (!eof())
      nndsr=val(number)
      dregr=date_reg
      datedocr=datedoc
      regnumr=regnum
      sele nnds
      locate for nnds=nndsr
      if (foun())
        if (datedocr=dnn)
          netrepl('dreg', 'dregr')
          if (fieldpos('regnum')#0)
            netrepl('regnum', 'regnumr')
          endif

        endif

      endif

      sele abc
      skip
    enddo

    sele abc
    CLOSE
  endif

  return (.t.)

/************** */
function ndsday()
  /************** */
  if (select('ndsday')#0)
    sele ndsday
    CLOSE
  endif

  erase ndsday.dbf
  crtt('ndsday', 'f:dt c:c(8) f:dn c:c(2) f:kolv c:n(4) f:kolnp c:n(4) f:kolp c:n(4) f:kole c:n(4) f:kolxml c:n(4) f:kolfl c:n(4) f:kolz c:n(4) f:smnp c:n(12,2) f:smp c:n(12,2)')
  sele 0
  use ndsday excl
  dtr=bom(gdTd)
  set cent off
  cdtr=dtoc(dtr)
  set cent on
  dt_r=dtr
  for i=1 to 31
    dayr=dow(dtr)
    do case
    case (dayr=1)
      dnr='Вс'
    case (dayr=2)
      dnr='Пн'
    case (dayr=3)
      dnr='Вт'
    case (dayr=4)
      dnr='Ср'
    case (dayr=5)
      dnr='Чт'
    case (dayr=6)
      dnr='Пн'
    case (dayr=7)
      dnr='Сб'
    endcase

    appe blank
    repl dt with cdtr, dn with dnr
    dtr=dtr+1
    set cent off
    cdtr=dtoc(dtr)
    set cent on
    if (month(dtr)#month(dt_r))
      exit
    endif

  next

  store 0 to ismnpr, ismpr
  sele nnds
  go top
  while (!eof())
    dtr=dnn
    set cent off
    cdtr=dtoc(dtr)
    set cent on
    smr=sm
    sele ndsday
    locate for dt=cdtr
    if (foun())
      repl kolv with kolv+1
      if (nnds->rn#0)
        //         if !(nnds->nn#0.and.!empty(nnds->nsv))
        if (nnds->nn=0)
          if (nnds->mnp=0)
            repl kolnp with kolnp+1, ;
             smnp with smnp+smr
            ismnpr=ismnpr+smr
          else
            repl kolnp with kolnp+1, ;
             smnp with smnp-smr
            ismnpr=ismnpr+smr
          endif

        else
          if (nnds->mnp=0)
            repl kolp with kolp+1, ;
             smp with smp+smr
            ismpr=ismpr+smr
          else
            repl kolp with kolp+1, ;
             smp with smp-smr
            ismpr=ismpr-smr
          endif

        endif

        if (nnds->prXml#0)
          repl kolxml with kolxml+1
        endif

        if (!empty(nnds->ifl))
          repl kolfl with kolfl+1
        endif

        if (!empty(nnds->dreg))
          repl kolz with kolz+1
        endif

      endif

    endif

    if (nnds->rn=0)
      repl kole with kole+1
    endif

    sele nnds
    skip
  enddo

  sele ndsday
  appe blank
  repl dt with 'Итого', ;
   smnp with ismnpr,    ;
   smp with ismpr
  go top
  rcndsdr=recn()
  while (.t.)
    sele ndsday
    go rcndsdr
    foot('', '')
    rcndsdr=slcf('ndsday',,,,, "e:dt h:'Дата' c:c(8) e:dn h:'Дн' c:c(2) e:kolv h:'Всего' c:n(4) e:kolnp h:'Не пл' c:n(4) e:kolp h:'Плат' c:n(4) e:kole h:'Проп' c:n(4) e:kolxml h:'Пр XML' c:n(4) e:kolfl h:'Фалов XML' c:n(4) e:kolz h:'Рег' c:n(4) e:smnp h:'См не пл' c:n(10,2) e:smp h:'См плат' c:n(10,2)",,,,,,, 'По дням')
    if (lastkey()=K_ESC)
      exit
    endif

  enddo

  sele ndsday
  CLOSE
  return (.t.)

/************* */
function crnds()
  /************* */
  if (select('dvnds')#0)
    sele dvnds
    CLOSE
  endif

  erase dvnds.dbf
  erase dvnds.cdx
  crtt('dvnds', "f:nnds c:n(10) f:mn c:n(6) f:rnd c:n(6) f:sk c:n(3) f:rn c:n(6) f:mnp c:n(6) f:ddk c:d(10)")
  sele 0
  use dvnds excl
  inde on str(mn, 6)+str(rnd, 6)+str(sk, 3)+str(rn, 6)+str(mnp, 6) tag t1
  sele dokk
  set orde to tag t15       // nnds
  mess('Двойники ...')
  sele nnds
  go top
  while (!eof())
    nndsr=nnds
    kklr=kkl
    pr1ndsr=getfield('t1', 'kklr', 'kpl', 'pr1nds')
    rn_r=rn
    if (rn_r#0.and.pr1ndsr=1)
      pr1ndsr=0
    endif

    sele dokk
    if (netseek('t15', 'nndsr'))
      mnr=mn
      rndr=rnd
      skr=sk
      rnr=rn
      mnpr=mnp
      ddkr=ddk
      while (nnds=nndsr)
        if (!(mn=mnr.and.rnd=rndr.and.sk=skr.and.rn=rnr.and.mnp=mnpr).and.pr1ndsr=0)
          // Двойник
          sele dvnds
          seek str(mnr, 6)+str(rndr, 6)+str(skr, 3)+str(rnr, 6)+str(mnpr, 6)
          if (!foun())
            sele dvnds
            appe blank
            repl nnds with nndsr, ;
             mn with mnr,         ;
             rnd with rndr,       ;
             sk with skr,         ;
             rn with rnr,         ;
             mnp with mnpr,       ;
             ddk with ddkr
          endif

          sele dokk
          mnr=mn
          rndr=rnd
          skr=sk
          rnr=rn
          mnpr=mnp
          ddkr=ddk
          sele dvnds
          seek str(mnr, 6)+str(rndr, 6)+str(skr, 3)+str(rnr, 6)+str(mnpr, 6)
          if (!foun())
            sele dvnds
            appe blank
            repl nnds with nndsr, ;
             mn with mnr,         ;
             rnd with rndr,       ;
             sk with skr,         ;
             rn with rnr,         ;
             mnp with mnpr,       ;
             ddk with ddkr
          endif

        endif

        sele dokk
        skip
      enddo

    else
      if (rn_r#0)
        sele dvnds
        appe blank
        repl nnds with nndsr
      endif

    endif

    sele nnds
    skip
  enddo

  sele dvnds
  if (recc()#0)
    go top
    while (.t.)
      nndsr=slcf('dvnds',,,,, "e:nnds h:'nnds' c:n(10) e:mn h:'mn' c:n(6) e:rnd h:'rnd' c:n(6) e:sk h:'sk' c:n(3) e:rn h:'rn' c:n(6) e:mnp h:'mnp' c:n(6) e:ddk h:'ddk' c:d(10)", 'nnds')
      if (lastkey()=K_ESC)
        exit
      endif

    enddo

    return (.t.)
  endif

  mess('Коррекция IFL...')
  crifl()

  mess('Коррекция сум...')
  set cons off
  set prin to crnds.txt
  set prin on
  sele nnds
  go top
  while (!eof())
    nndsr=nnds
    smr=sm
    sele dokk
    if (netseek('t15', 'nndsr'))
      sm_r=0
      while (nnds=nndsr)
        sm_r=sm_r+bs_s
        sele dokk
        skip
      enddo

      if (smr#sm_r)
        sele nnds
        ?str(nndsr, 10)+' '+str(smr, 10, 2)+'->'+str(sm_r, 10, 2)
        netrepl('sm', 'sm_r')
      endif

    endif

    sele nnds
    skip
  enddo

  set cons on
  sele dvnds
  CLOSE
  erase dvnds.dbf
  erase dvnds.cdx
  set prin off
  set prin to
  return (.t.)

/************* */
function crifl()
  /************* */
  sele nnds
  go top
  while (!eof())
    nndsr=nnds
    dnnr=dnn
    iflr=ifl
    kklr=kkl
    pr1ndsr=getfield('t1', 'kklr', 'kpl', 'pr1nds')
    okpor=getfield('t1', 'gnKkl_c', 'kln', 'kkl1')

    pathnxmlr=gcPath_mxml+'d'+iif(day(dnnr)<10, '0'+str(day(dnnr), 1), str(day(dnnr), 2))+'\'
    ifl_r:=ifl_r()
#ifdef __CLIP__
      if (file(pathnxmlr+ifl_r+'.xml'))
        if (empty(iflr))
          netrepl('ifl', 'ifl_r')
        endif

      else
        ifl_r=''
        netrepl('ifl', 'ifl_r')
      endif

#else
      if (file(pathnxmlr+'n'+subs(ifl_r, 26, 7)+'.xml'))
        if (empty(iflr))
          netrepl('ifl', 'ifl_r')
        endif

      else
        ifl_r=''
        netrepl('ifl', 'ifl_r')
      endif

#endif
    sele nnds
    skip
  enddo

  return (.t.)

/*************** */
function ndsxmlp()
  /************** */
  store gdTd to dt1r, dt2r
  clglav=setcolor('gr+/b,n/w')
  wglav=wopen(10, 20, 13, 60)
  wbox(1)
  @ 0, 1 say 'Период с' get dt1r
  @ 0, col()+1 say ' по' get dt2r
  read
  wclose(wglav)
  setcolor(clglav)
  if (lastkey()=K_ENTER)
    sele nnds
    go top
    while (!eof())
      if (dnn<dt1r.or.dnn>dt2r)
        skip; loop
      endif

      if (mn#0)
        skip; loop
      endif

      dnnr=dnn
      if (nnds->dnn>=ctod('16.03.2016').and.date()>=ctod('01.04.2016'))
        xmlnds()
      else
        ndsxml()
      endif

      mess(nnds->ifl)
      sele nnds
      skip
    enddo

  endif

  return (.t.)

/*****************************************************************
 
 FUNCTION:
 АВТОР..ДАТА..........С. Литовка  03-03-17 * 03:29:28pm
 НАЗНАЧЕНИЕ.........
 ПАРАМЕТРЫ..........
 ВОЗВР. ЗНАЧЕНИЕ....
 ПРИМЕЧАНИЯ.........
 */
function ifl_r()
  local ifl_r:=''
  do case
  case (dnnr<ctod('01.03.2014'))
    if (pr1ndsr=0)
      ifl_r='1819'+lzero(okpor, 10)+'j12'+iif(mnp=0, '010', '012')+'04'+'1'+'00'+lzero(nnds, 7)+'1'+lzero(month(dnn), 2)+str(year(dnn), 4)+'1819'
    else
      ifl_r='1819'+lzero(okpor, 10)+'j12'+iif(nnds1=0, '010', '012')+'04'+'1'+'00'+lzero(nnds, 7)+'1'+lzero(month(dnn), 2)+str(year(dnn), 4)+'1819'
    endif

  case (dnnr<ctod('01.12.2014'))
    if (pr1ndsr=0)
      ifl_r='1819'+lzero(okpor, 10)+'j12'+iif(mnp=0, '010', '012')+'05'+'1'+'00'+lzero(nnds, 7)+'1'+lzero(month(dnn), 2)+str(year(dnn), 4)+'1819'
    else
      ifl_r='1819'+lzero(okpor, 10)+'j12'+iif(nnds1=0, '010', '012')+'05'+'1'+'00'+lzero(nnds, 7)+'1'+lzero(month(dnn), 2)+str(year(dnn), 4)+'1819'
    endif

  case (dnnr<ctod('01.01.2015'))
    if (pr1ndsr=0)
      ifl_r='1819'+lzero(okpor, 10)+'j12'+iif(mnp=0, '010', '012')+'06'+'1'+'00'+lzero(nnds, 7)+'1'+lzero(month(dnn), 2)+str(year(dnn), 4)+'1819'
    else
      ifl_r='1819'+lzero(okpor, 10)+'j12'+iif(nnds1=0, '010', '012')+'06'+'1'+'00'+lzero(nnds, 7)+'1'+lzero(month(dnn), 2)+str(year(dnn), 4)+'1819'
    endif

  case (dnnr<ctod('16.03.2016'))
    if (pr1ndsr=0)
      ifl_r='1819'+lzero(okpor, 10)+'j12'+iif(mnp=0, '010', '012')+'07'+'1'+'00'+lzero(nnds, 7)+'1'+lzero(month(dnn), 2)+str(year(dnn), 4)+'1819'
    else
      ifl_r='1819'+lzero(okpor, 10)+'j12'+iif(nnds1=0, '010', '012')+'07'+'1'+'00'+lzero(nnds, 7)+'1'+lzero(month(dnn), 2)+str(year(dnn), 4)+'1819'
    endif

  case (dnnr<ctod('16.03.2017'))
    if (pr1ndsr=0)
      ifl_r='1819'+lzero(okpor, 10)+'j12'+iif(mnp=0, '010', '012')+'08'+'1'+'00'+lzero(nnds, 7)+'1'+lzero(month(dnn), 2)+str(year(dnn), 4)+'1819'
    else
      ifl_r='1819'+lzero(okpor, 10)+'j12'+iif(nnds1=0, '010', '012')+'08'+'1'+'00'+lzero(nnds, 7)+'1'+lzero(month(dnn), 2)+str(year(dnn), 4)+'1819'
    endif

  otherwise
    if (pr1ndsr=0)
      ifl_r='1819'+lzero(okpor, 10)+'j12'+iif(mnp=0, '010', '012')+'09'+'1'+'00'+lzero(nnds, 7)+'1'+lzero(month(dnn), 2)+str(year(dnn), 4)+'1819'
    else
      ifl_r='1819'+lzero(okpor, 10)+'j12'+iif(nnds1=0, '010', '012')+'09'+'1'+'00'+lzero(nnds, 7)+'1'+lzero(month(dnn), 2)+str(year(dnn), 4)+'1819'
    endif

  endcase

  return (ifl_r)

  /*
     if dnnr<ctod('01.03.2014')
        if pr1ndsr=0
           ifl_r='1819'+lzero(okpor,10)+'j12'+iif(mnp=0,'010','012')+'04'+'1'+'00'+lzero(nnds,7)+'1'+lzero(month(dnn),2)+str(year(dnn),4)+'1819'
        else
           ifl_r='1819'+lzero(okpor,10)+'j12'+iif(nnds1=0,'010','012')+'04'+'1'+'00'+lzero(nnds,7)+'1'+lzero(month(dnn),2)+str(year(dnn),4)+'1819'
        endif
     else
        if dnnr<ctod('01.12.2014')
           if pr1ndsr=0
              ifl_r='1819'+lzero(okpor,10)+'j12'+iif(mnp=0,'010','012')+'05'+'1'+'00'+lzero(nnds,7)+'1'+lzero(month(dnn),2)+str(year(dnn),4)+'1819'
           else
              ifl_r='1819'+lzero(okpor,10)+'j12'+iif(nnds1=0,'010','012')+'05'+'1'+'00'+lzero(nnds,7)+'1'+lzero(month(dnn),2)+str(year(dnn),4)+'1819'
           endif
        else
           if dnnr<ctod('01.01.2015')
              if pr1ndsr=0
                 ifl_r='1819'+lzero(okpor,10)+'j12'+iif(mnp=0,'010','012')+'06'+'1'+'00'+lzero(nnds,7)+'1'+lzero(month(dnn),2)+str(year(dnn),4)+'1819'
              else
                 ifl_r='1819'+lzero(okpor,10)+'j12'+iif(nnds1=0,'010','012')+'06'+'1'+'00'+lzero(nnds,7)+'1'+lzero(month(dnn),2)+str(year(dnn),4)+'1819'
              endif
           else
              if pr1ndsr=0
                 ifl_r='1819'+lzero(okpor,10)+'j12'+iif(mnp=0,'010','012')+'07'+'1'+'00'+lzero(nnds,7)+'1'+lzero(month(dnn),2)+str(year(dnn),4)+'1819'
              else
                 ifl_r='1819'+lzero(okpor,10)+'j12'+iif(nnds1=0,'010','012')+'07'+'1'+'00'+lzero(nnds,7)+'1'+lzero(month(dnn),2)+str(year(dnn),4)+'1819'
              endif
           endif
        endif
     endif
  */

  /*
     if dnnr<ctod('01.03.2014')
        if pr1ndsr=0
           ifl_r='1819'+lzero(okpor,10)+'j12'+iif(mnp=0,'010','012')+'04'+'1'+'00'+lzero(nnds,7)+'1'+lzero(month(dnn),2)+str(year(dnn),4)+'1819'
        else
           ifl_r='1819'+lzero(okpor,10)+'j12'+iif(nnds1=0,'010','012')+'04'+'1'+'00'+lzero(nnds,7)+'1'+lzero(month(dnn),2)+str(year(dnn),4)+'1819'
        endif
     else
        if dnnr<ctod('01.12.2014')
           if pr1ndsr=0
              ifl_r='1819'+lzero(okpor,10)+'j12'+iif(mnp=0,'010','012')+'05'+'1'+'00'+lzero(nnds,7)+'1'+lzero(month(dnn),2)+str(year(dnn),4)+'1819'
           else
              ifl_r='1819'+lzero(okpor,10)+'j12'+iif(nnds1=0,'010','012')+'05'+'1'+'00'+lzero(nnds,7)+'1'+lzero(month(dnn),2)+str(year(dnn),4)+'1819'
           endif
        else
           if dnnr<ctod('01.01.2015')
              if pr1ndsr=0
                 ifl_r='1819'+lzero(okpor,10)+'j12'+iif(mnp=0,'010','012')+'06'+'1'+'00'+lzero(nnds,7)+'1'+lzero(month(dnn),2)+str(year(dnn),4)+'1819'
              else
                 ifl_r='1819'+lzero(okpor,10)+'j12'+iif(nnds1=0,'010','012')+'06'+'1'+'00'+lzero(nnds,7)+'1'+lzero(month(dnn),2)+str(year(dnn),4)+'1819'
              endif
           else
              if dnnr<ctod('16.03.2016')
                 if pr1ndsr=0
                    ifl_r='1819'+lzero(okpor,10)+'j12'+iif(mnp=0,'010','012')+'07'+'1'+'00'+lzero(nnds,7)+'1'+lzero(month(dnn),2)+str(year(dnn),4)+'1819'
                 else
                    ifl_r='1819'+lzero(okpor,10)+'j12'+iif(nnds1=0,'010','012')+'07'+'1'+'00'+lzero(nnds,7)+'1'+lzero(month(dnn),2)+str(year(dnn),4)+'1819'
                 endif
              else
                 if pr1ndsr=0
                    ifl_r='1819'+lzero(okpor,10)+'j12'+iif(mnp=0,'010','012')+'08'+'1'+'00'+lzero(nnds,7)+'1'+lzero(month(dnn),2)+str(year(dnn),4)+'1819'
                 else
                    ifl_r='1819'+lzero(okpor,10)+'j12'+iif(nnds1=0,'010','012')+'08'+'1'+'00'+lzero(nnds,7)+'1'+lzero(month(dnn),2)+str(year(dnn),4)+'1819'
                 endif
              endif
           endif
        endif
     endif
  */

