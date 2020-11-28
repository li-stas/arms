/***********************************************************
 * Модуль    : s_kln.prg
 * Версия    : 0.0
 * Автор     :
 * Дата      : 03/25/19
 * Изменен   :
 * Примечание: Текст обработан утилитой CF версии 2.02
 */

#include "inkey.ch"
para corr

save scre to sccskl
netuse('kln')
netuse('ctov')
netuse('cgrp')
netuse('klnDog')
netuse('mkeepe')
netuse('opfh')
oclr=setcolor('w+/b')
clea
forr='.t.'
for_r='.t.'
while (.t.)
  sele kln
  set orde to tag t1
  foot('F3,F4,F5,F6,F7,F8', 'Фильтр,Коррекция,Дог.усл,СвДог,Дв,КрНп')
  set cent off
  kklr=slcf('kln', 1,, 18,, "e:kkl h:'Код' c:n(7) e:nkl h:'Наименование' c:c(30) e:getfield('t1','kln->kkl','klnDog','prSvKln') h:'Св' c:n(2) e:getfield('t1','kln->kkl','klnDog','dtSvKln') h:'Дата Св' c:d(8) e:getfield('t1','kln->kkl','klnDog','nDog') h:'N Дог' c:n(6) e:getfield('t1','kln->kkl','klnDog','dtDogb') h:'Дата Н' c:d(8) e:getfield('t1','kln->kkl','klnDog','dtDoge') h:'Дата О' c:d(8)", 'kkl',, 1,, forr)
  set cent on
  sele kln
  netseek('t1', 'kklr')
  rcklnr=recn()
  kklpr=kklp
  krnr=krn
  knaspr=knasp
  adrr=adr
  psser=psse
  psnr=psn
  psdtvr=psdtv
  pskvr=pskv
  dtbsvr=dtbsv
  dtesvr=dtesv
  avtokklr=avtokkl
  do case
  case (lastkey()=22.and.gnArm#4 .and. (dkklnr=1.or.gnadm=1))// INS
    klnins()
  case (lastkey()=7.and.gnAdm=1)// DEL
    netdel()
    skip -1
  case (lastkey()=K_F3)         // F3
    clkln=setcolor('gr+/b,n/w')
    wkln=wopen(7, 20, 17, 60)
    wbox(1)
    store 0 to kklr, kkl1r, klntipr, krnr, knaspr, nnr
    store space(20) to ktxr, ktx1r
    store space(15) to rschr
    @ 0, 1 say 'Код 7зн  ' get kklr pict '9999999'
    @ 1, 1 say 'ОКПО     ' get kkl1r pict '9999999999'
    @ 2, 1 say 'Расч.счет' get rschr
    @ 3, 1 say 'Конт наим' get ktxr
    @ 4, 1 say 'Конт адр ' get ktx1r
    @ 5, 1 say 'Район    ' get krnr pict '9999'
    @ 6, 1 say 'Город    ' get knaspr pict '9999'
    @ 7, 1 say 'Тип      ' get klntipr pict '9'
    @ 8, 1 say 'Нал N    ' get nnr pict '999999999999'
    read
    if (kklr#0.or.kkl1r#0.or.!empty(rschr))
      do case
      case (kklr#0)
        forr=nil
        set orde to tag t1
        if (!netseek('t1', 'kklr'))
          go top
        endif

      case (!empty(rschr))
        rschr=alltrim(rschr)
        sele kln
        set orde to tag t1
        go top
        forr='at(rschr,kln->kb1)#0'
      case (kkl1r#0)
        forr='.t.'
        set orde to tag t5
        if (!netseek('t5', 'kkl1r'))
          go top
        endif

      endcase

    else
      forr=for_r
      if (!empty(ktxr))
        ktxr=alltrim(upper(ktxr))
        forr=forr+'.and.at(ktxr,upper(kln->nkl))#0'
      endif

      if (!empty(ktx1r))
        ktx1r=alltrim(upper(ktx1r))
        forr=forr+'.and.at(ktx1r,upper(kln->adr))#0'
      endif

      if (klntipr#0)
        if (klntipr=1)
          forr=forr+'.and.kkl1#0.and.kkl=kklp'
        endif

        if (klntipr=2)
          forr=forr+'.and.!(kkl1#0.and.kkl=kklp)'
        endif

      endif

      if (krnr#0)
        forr=forr+'.and.krn=krnr'
      endif

      if (knaspr#0)
        forr=forr+'.and.knasp=knaspr'
      endif

      if (nnr#0)
        forr=forr+'.and.nn=nnr'
      endif

      sele kln
      set orde to tag t1
      go top
    endif

    if (kklr=0.and.empty(ktxr).and.kkl1r=0.and.klntipr=0.and.empty(ktx1r) ;
         .and.krnr=0.and.knaspr=0.and.nnr=0                                    ;
      )
      forr=for_r
      set orde to tag t1
      go top
    endif

    wclose(wkln)
    setcolor(clkln)
  case (lastkey()=-3 .and. (dkklnr=1.or.gnadm=1))// F4
    klnins(1)
  /*      case lastkey()=-4 .and. (dkklnr=1.or.gnadm=1) // F5
   *           klnins(1, .T., .T.)
   */
  case (lastkey()=K_ESC.or.lastkey()=13)// ESC/ENTER
    exit
  case (lastkey()=-5)                // СвДог
    svdg()
  case (lastkey()=-6)                // Двойники
    save scre to sckldv
    clea
    sele kln
    set filt to
    set orde to tag t1
    go top
    kklr=9999999999
    while (!eof())
      if (kkl=kklr)
        ?str(kkl, 7)
        netdel()
        skip
        loop
      endif

      kklr=kkl
      sele kln
      skip
    enddo

    rest scre from sckldv
    go top
    kklr=kkl
  /*           kplkgp() */
  case (lastkey()=-7)     // Коррекция nklprn,nkl
    sele kln
    go top
    while (!eof())
      kkl1r=kkl1
      nkler=alltrim(nkle)
      nopfhr=''
      nospfhr=''
      opfhr=opfh
      if (kkl1r=0)
        opfhr=0
      endif

      if (opfhr#0)
        nopfhr=getfield('t1', 'opfhr', 'opfh', 'nopfh')
        nsopfhr=getfield('t1', 'opfhr', 'opfh', 'nsopfh')
        nklprnr=alltrim(nopfhr)+' '+nkler
        if (!empty(nsopfhr))
          nklr=alltrim(nsopfhr)+' '+nkler
        else
          nklr=nkler
        endif

        sele kln
        netrepl('nklprn,nkl,opfh', 'nklprnr,nklr,opfhr')
      else
        netrepl('nklprn,nkl,opfh', 'nkler,nkler,opfhr')
      endif

      sele kln
      skip
    enddo

    go top
  endcase

enddo

if (FILE("TmpIzKg.dbf"))
  ERASE TmpIzKg.dbf
endif

setcolor(oclr)
nuse()
rest scre from sccskl

/***********************************************************
 * svdg() -->
 *   Параметры :
 *   Возвращает:
 */
function svdg()
  sele klnDog
  if (netseek('t1', 'kklr'))
    prSvKlnr=prSvKln
    dtSvKlnr=dtSvKln
    dtSvKln_r=dtSvKln
    nDogr=nDog
    dtDogbr=dtDogb
    dtDoger=dtDoge
    KtoSvr=kto
    KtoSvr=KtoSv
    prinsr=0
    if (fieldpos('KtoSv')#0)
      ktasvr=ktasv
    else
      ktasvr=0
    endif

    if (fieldpos('dtSv')#0)
      dtSvr=dtSv
    else
      dtSvr=ctod('')
    endif

  else
    store 0 to prSvKlnr, nDogr, KtoSvr, ktasvr
    store ctod('') to dtSvKlnr, dtDogbr, dtDoger, dtSvKln_r
    dtSvr=ctod('')
    prinsr=1
  endif

  clsv=setcolor('gr+/b,n/w')
  wsv=wopen(10, 20, 18, 60)
  wbox(1)
  svvnr=1
  while (.t.)
    @ 0, 1 say 'Признак сверки' get prSvKlnr pict '99'
    @ 1, 1 say 'Дата сверки   ' get dtSvKlnr
    @ 2, 1 say 'N договора    ' get nDogr pict '999999'
    @ 3, 1 say 'Дата начала   ' get dtDogbr
    @ 4, 1 say 'Дата окончания' get dtDoger
    @ 5, 1 say 'Дата св агента' get dtSvr
    @ 5, col()+1 say 'Агент' get ktasvr pict '9999'
    @ 6, 1 prom 'Верно'
    @ 6, col()+1 prom 'Не верно'
    read
    if (lastkey()=K_ESC)
      exit
    endif

    menu to svvnr
    if (lastkey()=K_ESC)
      exit
    endif

    if (svvnr=1)
      if (prinsr=1)
        netadd()
        netrepl('kkl,prSvKln,dtSvKln,nDog,dtDogb,dtDoge,kto', 'kklr,prSvKlnr,dtSvKlnr,nDogr,dtDogbr,dtDoger,gnKto')
        prinsr=0
      else
        netrepl('prSvKln,dtSvKln,nDog,dtDogb,dtDoge', 'prSvKlnr,dtSvKlnr,nDogr,dtDogbr,dtDoger')
      endif

      if (dtSvKln_r#dtSvKlnr)
        netrepl('KtoSv', 'gnKto')
      endif

      if (fieldpos('ktasv')#0)
        netrepl('ktasv', 'ktasvr')
      endif

      if (fieldpos('dtSv')#0)
        netrepl('dtSv', 'dtSvr')
      endif

      if (prinsr=0.and.prSvKlnr=0.and.empty(dtSvKlnr).and.nDogr=0.and.empty(dtDogbr).and.empty(dtDoger))
        netdel()
      endif

      exit
    endif

  enddo

  wclose(wsv)
  clsv=setcolor(clsv)
  sele kln
  return (.t.)

