/***********************************************************
 * Модуль    : paotv.prg
 * Версия    : 0.0
 * Автор     :
 * Дата      : 02/25/19
 * Изменен   :
 * Примечание: Текст обработан утилитой CF версии 2.02
 */

#include "common.ch"
#include "inkey.ch"
/* Автоматический приход из отв.хр. в основной склад */
sele cskl
if (!netseek('t1', 'gnSkotv'))
  wmess('Автомат не создан.Нет склада родителя отв хр '+str(gnSkotv, 3), 0)
  return
endif

pathr=gcPath_d+alltrim(path)
skltpr=skl
netUse('pr1', 'pr1t',, 1)
netUse('pr2', 'pr2t',, 1)
netUse('pr3', 'pr3t',, 1)
netUse('tov', 'tovt',, 1)
netUse('tovm', 'tovmt',, 1)
netuse('sgrp', 'sgrpt',, 1)

sele pr2
if (!netseek('t1', 'mnr'))
  nuse('pr1t')
  nuse('pr2t')
  nuse('pr3t')
  nuse('tovt')
  nuse('tovmt')
  nuse('sgrpt')
  return
endif

while (mn=mnr)
  ktlr=ktl
  kgnr=int(ktlr/1000000)
  if (!netseek('t1', 'kgnr', 'sgrpt'))
    wmess('Автомат не создан.Нет группы '+str(kgnr, 3)+' в складе '+str(gnSkotv, 3), 0)
    nuse('pr1t')
    nuse('pr2t')
    nuse('pr3t')
    nuse('tovt')
    nuse('tovmt')
    nuse('sgrpt')
    return
  endif

  if (gnVotv=2)           // поставка на основной склад в упаковках поставщика
    if (getfield('t1', 'gnSkl,ktlr', 'tov', 'upakp')=0)
      wmess('Автомат не создан.Нет упаковки поставщика', 0)
      nuse('pr1t')
      nuse('pr2t')
      nuse('pr3t')
      nuse('tovt')
      nuse('tovmt')
      nuse('sgrpt')
      return
    endif

  endif

  sele pr2
  skip
enddo

/*** Данные из pr1 , записать в pr1t ******************* */
if (mode = 1)             // Формирование
  sele pr1t
  mntr=0
  if (netseek('t3', '1,kpsr'))
    mntr=mn
    skltpr=skl
    sele pr1
    if (netseek('t1', 'ndr'))
      sklr=skl
      reclock()
      repl amnp with mntr, ;
       sktp with gnSkotv,  ;
       skltp with skltpr
    endif

  else

    sele cskl
    netseek('t1', 'gnSkotv')
    Reclock()
    mntr=mn
    skltpr=skl
    if (mn<999999)
      netrepl('mn', { mn+1 })
    else
      netrepl('mn', { 1 })
    endif

    sele pr1
    if (netseek('t1', 'ndr'))
      sklr=skl
      reclock()
      arec:={}
      getrec()
      repl amnp with mntr, ;
       sktp with gnSkotv,  ;
       skltp with skltpr
      sele pr1t
      NetAdd()
      putrec()
      netrepl('nd,mn,skl,vo,sdv,sksp,sklsp,amnp,sktp,skltp,otv', 'mntr,mntr,skltpr,0,0,gnSk,sklr,mnr,0,0,1')
    endif

  endif

else
  sele pr1
  if (netseek('t1', 'ndr'))
    sklr=skl
    mntr=amnp
    sktpr=sktp
    skltpr=skltp
  endif

endif

/*** Данные с pr3 , записать в pr3t ********************
 *** Данные с pr2 , записать в pr2t ********************
 */
if (mode=1)
  SELE pr2
  netseek('t1', 'mnr')
  while (mn=mnr)
    mntovr=mntov
    ktlr=ktl
    kgnr=int(ktlr/1000000)
    kfr=kf
    /*      zenr=zen */
    zenr=0.01
    sele tov
    netseek('t1', 'sklr,ktlr')
    arec:={}
    getrec()
    sele tovt
    if (!netseek('t1', 'skltpr,ktlr'))
      netadd()
      putrec()
      netrepl('skl,ktl,opt,post,osn,osv,osf,osfm,osvo,osfo,osfop,otv', ;
               'skltpr,ktlr,zenr,kpsr,0,0,0,0,kfr,0,0,1'                ;
            )
    else
      netrepl('osvo', 'osvo+kfr')
    endif

    sele tovmt
    if (!netseek('t1', 'skltpr,mntovr'))
      sele tovm
      netseek('t1', 'sklr,mntovr')
      arec:={}
      getrec()
      sele tovmt
      netadd()
      putrec()
      netrepl('skl,osn,osv,osf,osfm,osvo,osfo,osfop,opt', 'skltpr,0,0,0,0,kfr,0,0,zenr')
    else
      netrepl('osvo,opt', 'osvo+kfr,zenr')
    endif

    sele pr2t
    if (!netseek('t1', 'mntr,ktlr'))
      netadd()
      netrepl('mn,ktl,kf,kfo,sf,zen,ktlp,ppt,mntov',   ;
               'mntr,ktlr,kfr,kfr,0,zenr,ktlr,0,mntovr' ;
            )
    else
      netrepl('kf,kfo', 'kf+kfr,kfo+kfr')
    endif

    sele pr2
    skip
  enddo

else                        // Удаление
  sele pr2
  if (netseek('t1', 'mnr'))
    while (mn=mnr)
      ktr=ktl
      mntovr=mntov
      kfr=kf
      sele pr2t
      if (netseek('t1', 'mntr,ktlr'))
        netrepl('kf,kfo', 'kf-kfr,kfo-kfr')
        sele tovt
        if (netseek('t1', 'skltpr,ktlr'))
          netrepl('osvo', 'osvo-kfr')
        endif

        sele tovmt
        if (netseek('t1', 'skltpr,mntovr'))
          netrepl('osvo', 'osvo-kfr')
        endif

      endif

      sele pr2
      skip
    enddo

  endif

endif

unlock all
nuse('pr1t')
nuse('pr2t')
nuse('pr3t')
nuse('tovt')
nuse('sgrpt')
nuse('sGrpEt')
return

/*************************** */
function prtotv
  /* Протокол передачи отв хр
   *
   ***************************
   */
  clea
  kpsr=2248008
  netuse('speng')
  pathsoxr=gcPath_ew+'sox\'
  while (.t.)
    clea
    @ 0, 1 say 'Поставщик' get kpsr pict '9999999'
    read
    if (lastkey()=K_ESC)
      return (.t.)
    endif

    pathpstr=pathsoxr+'p'+alltrim(str(kpsr, 7))+'\'
    if (!file(pathpstr+'prot1.dbf'))
      wmess('Нет передач для '+str(kpsr, 7), 2)
      loop
    endif

    sele 0
    use (pathpstr+'prot1')
    sele 0
    use (pathpstr+'prot2')
    sele prot1
    rcprot1r=recn()
    while (.t.)
      clea typeahead
      sele prot1
      go rcprot1r
      rcprot1r=slcf('prot1', 2, 2,,, "e:sns h:'Сеанс' c:n(6) e:mn h:'N прих' c:n(6) e:dt h:'Дата' c:d(10) e:tm h:'Время' c:c(8) e:getfield('t1','prot1->kto','speng','fio') h:'Передал' c:c(20) e:rzlt h:'Результат' c:c(10)",,, 1,,,, 'Сеансы передачи')
      if (lastkey()=K_ESC)
        exit
      endif

      go rcprot1r
      snsr=sns
      mnr=mn
      do case
      case (lastkey()=K_ENTER)
        sele prot2
        if (netseek('t1', 'snsr,mnr'))
          rcprot2r=recn()
          while (sns=snsr.and.mn=mnr)
            sele prot2
            go rcprot2r
            rcprot2r=slcf('prot2',,,,, "e:nat h:'Наименование' c:c(40) e:kol h:'Кол-во' c:n(15,3) e:bar h:'ШК' c:n(13)",,,,,,, 'Товар')
            if (lastkey()=K_ESC)
              exit
            endif

            sele prot2
            go rcprot2r
          enddo

        endif

      endcase

    enddo

    sele prot1
    CLOSE
    sele prot2
    CLOSE
  enddo

  nuse()
  return (.t.)

/************************************************************** */
function pacotv()
  /* Коррекция остатков в осн скл по расходу из склада отв хр
   ***************************************************************
   */
  sele cskl
  if (!netseek('t1', 'gnSkotv'))
    wmess('Нет склада родителя отв хр '+str(gnSkotv, 3), 0)
    return
  endif

  pathr=gcPath_d+alltrim(path)
  skltpr=skl

  netUse('pr1', 'pr1t',, 1)
  if (!netseek('t3', '1,kplr'))
    wmess('Нет прихода с остатками отв хр '+str(gnSkotv, 3), 0)
    nuse('pr1t')
    return (.t.)
  endif

  mntr=mn                   // Приход с остатками

  netUse('pr2', 'pr2t',, 1)
  netUse('tov', 'tovt',, 1)
  netUse('tovm', 'tovmt',, 1)

  sele rs2
  if (!netseek('t1', 'ttnr'))
    nuse('pr1t')
    nuse('pr2t')
    nuse('tovt')
    nuse('tovmt')
    return (.t.)
  endif

  /*** Данные с rs2 , записать в pr2t ******************** */
  if (mode=1)             // Снять  остатки
    sele rs2
    netseek('t1', 'ttnr')
    while (ttn=ttnr)
      ktlr=ktl
      mntovr=mntov
      kvpr=kvp
      sele tovt
      if (netseek('t1', 'skltpr,ktlr'))
        netrepl('osvo', 'osvo-kvpr')
      endif

      sele tovmt
      if (netseek('t1', 'skltpr,mntovr'))
        netrepl('osvo', 'osvo-kvpr')
      endif

      sele pr2t
      if (netseek('t1', 'mntr,ktlr'))
        netrepl('kf,kfo', 'kf-kvpr,kfo-kvpr')
      endif

      sele rs2
      skip
    enddo

  else                      // Восстановить остатки
    sele rs2
    netseek('t1', 'ttnr')
    while (ttn=ttnr)
      ktlr=ktl
      mntovr=mntov
      kvpr=kvp
      sele tovt
      if (netseek('t1', 'skltpr,ktlr'))
        netrepl('osvo', 'osvo+kvpr')
      endif

      sele tovmt
      if (netseek('t1', 'skltpr,mntovr'))
        netrepl('osvo', 'osvo+kvpr')
      endif

      sele pr2t
      if (netseek('t1', 'mntr,ktlr'))
        netrepl('kf,kfo', 'kf+kvpr,kfo+kvpr')
      endif

      sele rs2
      skip
    enddo

  endif

  nuse('pr1t')
  nuse('pr2t')
  nuse('tovt')
  nuse('tovmt')
  return (.t.)






// создает базу sohost с остатками ответхранения
// из кросс-таблици
/*
set talk off
set safety off
set date germ
Set century on
*/
/*****************************************************************
 
 FUNCTION:
 АВТОР..ДАТА..........С. Литовка  02-25-19 * 03:50:22pm
 НАЗНАЧЕНИЕ.........
 ПАРАМЕТРЫ..........
 ВОЗВР. ЗНАЧЕНИЕ....
 ПРИМЕЧАНИЯ.........
 */
Function MkSoh2()
  /****************************************************** */
  local skr
  skr=gnSk
  // формирование промежут баз
  sele 0
  netuse('mkcros', 'mkc')   // use i:\lodis\mkcros alias mkc
  set order to tag t1
  ////
  sele 0
  netuse('ctov', 'ctov')
  set order to tag t1
  ////
  m_soh2()
  sele 0
  use soh_s
  m_srtost()
  sele 0
  use sohost alias soh
  index on str(skl,7)+nat to tsoh

  if (!file('docnum.dbf'))
    m_ndoc()
  endif

  sele 0
  use docnum alias docn

  /************************************************ */

  mounr=month(date())
  yearr=year(date())
  // создается база остатков СОХ для одного склада SOHOST
  save screen to scr1s
  @ 0, 0 clear to 25, 80
  if (skr=232 .or. skr=700)

    MadeOst(skr)
    // add mntov in sohost
    makesoh()
    // создает базу для b_rowse
    @ 0, 0 clear to 25, 80
    makebrw()

    // создает базу для выгрузки в СВЕ
    made4swe(skr)

  endif
  restore screen from scr1s
  sele mkc
  CLOSE
  sele ctov
  CLOSE
  sele soh
  CLOSE
  sele soh_s
  CLOSE
  Return (Nil)


/* *************** */
static function MadeOst(nomskl)

  mounr=month(date())
  yearr=year(date())
  //outlog(__FILE__, __LINE__, nomskl)
  if (nomskl=232)
    // Lodis
    aa ='i:\lodis\g'+alltrim(str(yearr))+'\m'+right('0'+alltrim(str(mounr)), 2)+'\lod02\tovm'
    namesr='LODIS'
  else
    // Konotop
    aa='i:\lodis\g'+alltrim(str(yearr))+'\m'+right('0'+alltrim(str(mounr)), 2)+'\konotv\tovm'
    namesr='KONOTOP'
  endif

  sele soh
  appe from (aa) for kg>100 .and. osf>0
  ////
  set filt to mkcros=0
  go top
  ii=0
  while (!eof())
    ii=ii+1
    mntovr=str(mntov,7)
    sele ctov
    seek mntovr
    if found()
      mkcrosr=mkcros
      sele soh
      repl mkcros with mkcrosr
    endif
    if ii=1
      sele 0
      use &aa alias aatov
    endif
    sele aatov
    loca for str(mntov,7)=mntovr
    if found()
      repl mkcros with mkcrosr
    endif
    sele soh
    skip
  enddo
  if ii>0
    sele aatov
    CLOSE
  endif

  ////
  sele soh
  set filt to
  go top
  while (!eof())
    mkcrosr=str(mkcros, 7)
    if (upak>0)
      osfr=osf/upak
    else
      osfr=osf
    endif

    sele mkc
    set order to tag t1
    seek mkcrosr

    if (found())
      mkidr=val(alltrim(mkid))
      nmkidr=nmkid
      sele soh
      repl mkid with mkidr, ;
       nmkid with nmkidr,   ;
       osf with osfr
    endif
    sele soh
    recr=recno()
    repl nomrec with recr
    skip
  enddo

  sele soh
  repl nmskl with NomSkl,  ;
   nameskl with namesr all
  sele soh
  return

//********************* */
function makesoh
  clsoh=setcolor('gr+/b,n/bg')
  //wsoh=wopen(1,10,25,71)
  //wbox(1)
  sele soh
  //browse()
  go top
  do while.t.
      foot('','')
      foot('INS','Copy')
      sohzr=slcf('soh',,,,,"e:skl h:'SKLAD' c:n(7) e:mntov h:'MNTOV' c:n(7) e:nat h:'NAIM' c:c(25) e:osf h:'OST4SKL' c:n(10)",,,,,,,)
      go sohzr
      nmsklr=nmskl
      namesklr=nameskl
      sklr=skl
      kgr=kg
      mntovr=mntov
      natr=nat
      salenumr=salenum
      osfzr=osfz
      osfr=osf
      neir=nei
      upakr=upak
      mkcrosr=mkcros
      mkidr=mkid
      nmkidr=nmkid
      nomrecr=nomrec
      do case
        case lastkey()=K_ESC
          exit
        case lastkey()=K_INS
          sohins()
      endcase
  enddo
  //wclose(wsoh)
return

// ******************** */

function makebrw
  m_tsoh()
  sele soh
  CLOSE
  sele 0
  use zsoh
  append from sohost
  index on str(skl,7)+nat to zsoh
  go top
  browse()
  sele 0
  use sohost alias soh
  index on str(skl,7)+nat to tsoh
  sele zsoh
  set filt to !empty(osfz)
  go top
  do while !eof()
    salenumr=salenum
    osfzr=osfz
    sklr=skl
    mntovr=mntov
    nomrecr=nomrec
    seekr=str(sklr,7)+str(mntovr,7)+str(nomrecr,3)
    sele soh
    locate for str(skl,7)+str(mntov,7)+str(nomrec,3)=seekr
    if found()
      repl salenum with salenumr ,;
           osfz with osfzr
    endif
    sele zsoh
    skip
  enddo
  sele zsoh
  CLOSE
return

/**************** */
function sohins()
  sele soh
  appe blank
  repl nmskl with nmsklr,;
      nameskl with namesklr,;
      skl with sklr,;
      kg with kgr,;
      mntov with mntovr,;
      nat with natr,;
      salenum with salenumr,;
      osfz with osfzr,;
      osf with osfr,;
      nei with neir,;
      upak with upakr,;
      mkcros with mkcrosr,;
      mkid with mkidr,;
      nmkid with nmkidr,;
      nomrec with nomrecr+1

return

/*************** */
function made4swe(nmsklr)

  // создает базу soh2swe для передачи в СВЕ - нужно
  // ее переделать в xml
  // удаление предыдущих ф-лов
  // путь куда викладиваются soh*.xml
  dirsoh='j:\lodis\sales\'
  ii=0
  // цикл по кол-ву производителей
  for ii=1 to 5
    tsoh='soh2swe'+alltrim(str(ii, 1))+'.dbf'
    //txml=dirsoh+'soh'+alltrim(str(ii, 1))+'.xml'
    if (file(tsoh))
      dele file (tsoh)
    endif
    if (nmsklr=232)
        txml=dirsoh+'soh_s'+alltrim(str(ii, 1))+'.xml'
    else
        txml=dirsoh+'soh_k'+alltrim(str(ii, 1))+'.xml'
    endif

    if (file(txml))
      dele file (txml)
    endif

  next

  sele soh
  index on str(nmskl, 3)+str(skl, 7) to t3
  total on str(nmskl, 3)+str(skl, 7) to sskl field osfz

  sele 0
  use sskl
  go top
  ii=0
  /************* */
  while (!eof())          // цикл по кол-ву производителей
    if (osfz>0)
      ii=ii+1
      nmsklr=nmskl
      sklr=skl

      tsoh='soh2swe'+alltrim(str(ii, 1))+'.dbf'

      sele soh_s
      copy stru to (tsoh)
      sele 0
      use (tsoh) alias swe
      sele docn
      docnr=docnum+1
      repl docnum with docnr
      sele soh
      seek str(nmsklr, 3)+str(sklr, 7)

      while (nmskl=nmsklr .and. skl=sklr)
        mkidr=mkid
        nmkidr=nmkid
        salenumr=salenum
        osfr=osfz
        if (osfz>0)
          sele swe
          appe blank
          repl docnum with docnr, ;
           docdate with date(),   ;
           distrcod with 18005,   ;
           prodcod with mkidr,    ;
           prodnam with nmkidr,   ;
           salenum with salenumr, ;
           packcou with osfr
          if (nmsklr=232)
            repl delivery with 2029
          else
            repl delivery with 7732
          endif

          do case
          case (sklr=2298568)
            repl obolonc with '450'
          case (sklr=382533)
            repl obolonc with '451'
          case (sklr=386053)
            repl obolonc with '488'
          case (sklr=5513371)
            repl obolonc with '452'
          case (sklr=539105)
            repl obolonc with '133/1'
          endcase

        endif

        sele soh
        skip
      enddo

      sele swe
      CLOSE
      copy file (tsoh) to soh2swe.dbf
      cPth_Plt_lsoh=''
      soh_2xml(cPth_Plt_lsoh)
      if (nmsklr=232)
        txml=dirsoh+'soh_s'+alltrim(str(ii, 1))+'.xml'
      else
        txml=dirsoh+'soh_k'+alltrim(str(ii, 1))+'.xml'
      endif
      copy file soh.xml to (txml)
    endif

    /********** */
    if (file('soh.xml'))
      dele file soh.xml
    endif

    //erase
    sele sskl
    skip
  enddo
  sele sskl
  CLOSE
  return

/************* */
static function soh_2xml
  para cPth_Plt_lsoh
  sele 0
  use soh2swe
  index on str(prodcod,9) to tsw
  // set("PRINTER_CHARSET","cp1251")

  set console off
  set print on
  set print to soh.xml

  // ??'<?xml version="1.0" encoding="windows-1251"?>'
  ??'<?xml version="1.0" encoding="cp866"?>'
  ?'<ExportSOH>'
  ?'<Document DocNum="' + allt(str(docnum)) + '" DocDate="' +dtoc(docdate, 'ddmmyyyy') ;
   +' " DistrCode="'+allt(str(distrcod))                                                 ;
   +'" ObolonCode="'+obolonc+'" DeliveryCode="'+alltrim(str(delivery))+'">'
  while (!eof())
    ?'  <DocRows ProdCode="' + allt(str(prodcod)) + '" ProdDate="'+'' ;
     +'" ProdName="' + XmlCharTran(prodnam)                             ;
     +'" PackCount="' + allt(str(packcou))                            ;
     +'" SaleNum="' + iif(empty(salenum), '', allt(str(salenum))) ;
     +'" SaleName=""/>'
    Skip
  enddo

  ?'</Document>'
  ?'</ExportSOH>'
  ?

  set print to
  set print off

  sele soh2swe
  CLOSE

  return

/***********************************************************
 * XmlCharTran() -->
 *   Параметры :
 *   Возвращает:
 */
static function XmlCharTran
  para cChr

  cChr = ALLTRIM(cChr)
  cChr = STRTRAN(cChr, '\', "/")
  cChr = STRTRAN(cChr, "&", "&amp;")
  cChr = STRTRAN(cChr, ">", "&gt;")
  //cChr = STRTRAN(cChr, ">", "&qt;")
  cChr = STRTRAN(cChr, "<", "&lt;")
  cChr = STRTRAN(cChr, '"', "&quot;")
  cChr = STRTRAN(cChr, "'", "&apos;")
  cChr = ALLTRIM(cChr)
  return (cChr)

/**************** */
static function m_srtost
  sele mkc
  copy stru exte to TmpExt

  sele 0
  use TmpExt Exclusive
  zap
  appe blank
  repl Field_name with 'nmskl'
  repl Field_type with 'N'
  repl Field_len with 3
  repl Field_dec with 0
  appe blank
  repl Field_name with 'nameskl'
  repl Field_type with 'C'
  repl Field_len with 8
  appe blank
  repl Field_name with 'skl'
  repl Field_type with 'N'
  repl Field_len with 7
  repl Field_dec with 0
  appe blank
  repl Field_name with 'kg'
  repl Field_type with 'N'
  repl Field_len with 3
  repl Field_dec with 0
  appe blank
  repl Field_name with 'mntov'
  repl Field_type with 'N'
  repl Field_len with 7
  repl Field_dec with 0
  appe blank
  repl Field_name with 'nat'
  repl Field_type with 'C'
  repl Field_len with 60
  appe blank
  repl Field_name with 'salenum'
  repl Field_type with 'N'
  repl Field_len with 5
  repl Field_dec with 0
  appe blank
  repl Field_name with 'osfz'
  repl Field_type with 'N'
  repl Field_len with 10
  repl Field_dec with 2
  appe blank
  repl Field_name with 'osf'
  repl Field_type with 'N'
  repl Field_len with 10
  repl Field_dec with 2
  appe blank
  repl Field_name with 'nei'
  repl Field_type with 'C'
  repl Field_len with 5
  appe blank
  repl Field_name with 'upak'
  repl Field_type with 'N'
  repl Field_len with 10
  repl Field_dec with 2
  appe blank
  repl Field_name with 'mkcros'
  repl Field_type with 'N'
  repl Field_len with 4
  repl Field_dec with 0
  appe blank
  repl Field_name with 'mkid'
  repl Field_type with 'N'
  repl Field_len with 9
  repl Field_dec with 0
  appe blank
  repl Field_name with 'nmkid'
  repl Field_type with 'C'
  repl Field_len with 50
  appe blank
  repl Field_name with 'nomrec'
  repl Field_type with 'N'
  repl Field_len with 3
  repl Field_dec with 0
  sele TmpExt
  CLOSE
  create sohost from TmpExt
  CLOSE
  erase TmpExt.dbf
  return

/*****************/
static function m_tsoh
  sele mkc
  copy stru exte to TmpExt

  sele 0
  use TmpExt Exclusive
  zap
  appe blank
  repl Field_name with 'skl'
  repl Field_type with 'N'
  repl Field_len with 7
  repl Field_dec with 0
  appe blank
  repl Field_name with 'nat'
  repl Field_type with 'C'
  repl Field_len with 30
  appe blank
  repl Field_name with 'salenum'
  repl Field_type with 'N'
  repl Field_len with 5
  repl Field_dec with 0
  appe blank
  repl Field_name with 'osfz'
  repl Field_type with 'N'
  repl Field_len with 10
  repl Field_dec with 2
  appe blank
  repl Field_name with 'osf'
  repl Field_type with 'N'
  repl Field_len with 10
  repl Field_dec with 2
  appe blank
  repl Field_name with 'mntov'
  repl Field_type with 'N'
  repl Field_len with 7
  repl Field_dec with 0
  appe blank
  repl Field_name with 'nomrec'
  repl Field_type with 'N'
  repl Field_len with 3
  repl Field_dec with 0

  sele TmpExt
  CLOSE
  create zsoh from TmpExt
  CLOSE
  erase TmpExt.dbf
  return



/*************** */
static function m_ndoc
  sele mkc
  copy stru exte to TmpExt

  sele 0
  use TmpExt Exclusive
  zap
  appe blank
  repl Field_name with 'docnum'
  repl Field_type with 'N'
  repl Field_len with 7
  repl Field_dec with 0
  sele TmpExt
  CLOSE
  create docnum from TmpExt
  CLOSE
  erase TmpExt.dbf
  use docnum
  appe blank
  //repl docnum with 1
  CLOSE
  return

  /************** */

static function m_soh2
  sele mkc
  copy stru exte to TmpExt

  sele 0
  use TmpExt Exclusive
  zap
  appe blank
  repl Field_name with 'docnum'
  repl Field_type with 'N'
  repl Field_len with 7
  repl Field_dec with 0
  appe blank
  repl Field_name with 'docdate'
  repl Field_type with 'D'
  repl Field_len with 8
  appe blank
  repl Field_name with 'distrcod'
  repl Field_type with 'N'
  repl Field_len with 7
  repl Field_dec with 0
  appe blank
  repl Field_name with 'obolonc'
  repl Field_type with 'C'
  repl Field_len with 10
  appe blank
  repl Field_name with 'delivery'
  repl Field_type with 'N'
  repl Field_len with 7
  repl Field_dec with 0
  appe blank
  repl Field_name with 'prodcod'
  repl Field_type with 'N'
  repl Field_len with 9
  repl Field_dec with 0
  appe blank
  repl Field_name with 'proddat'
  repl Field_type with 'D'
  repl Field_len with 8
  appe blank
  repl Field_name with 'prodnam'
  repl Field_type with 'C'
  repl Field_len with 60
  appe blank
  repl Field_name with 'packcou'
  repl Field_type with 'N'
  repl Field_len with 10
  repl Field_dec with 0
  appe blank
  repl Field_name with 'salenum'
  repl Field_type with 'N'
  repl Field_len with 5
  repl Field_dec with 0
  appe blank
  repl Field_name with 'salenam'
  repl Field_type with 'C'
  repl Field_len with 60

  sele TmpExt
  CLOSE
  create soh_s from TmpExt
  CLOSE
  erase TmpExt.dbf
  return
  /************** */

