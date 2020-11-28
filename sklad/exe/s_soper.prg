/***********************************************************
 * Модуль    : s_soper.prg
 * Версия    : 0.0
 * Автор     :
 * Дата      : 11/14/19
 * Изменен   :
 * Примечание: Текст обработан утилитой CF версии 2.02
 */

#include "common.ch"
#include "inkey.ch"

clea
netuse('bs')
netuse('cskl')
netuse('tcen')
netuse('vo')
netuse('vop')
netuse('tto')
netuse('snds')
netuse('dclr')
netuse('kln')
store space(20) to NtC1r, NtC2r, NtC3r, nonC1r, nonC2r, nonC3r
crtt('prov', 'f:n20 c:n(2) f:ksz c:n(2) f:db c:n(6) f:kr c:n(6) f:mask c:c(6) f:lev c:n(1) f:nz c:c(20)')
sele 0
use prov excl
inde on str(ksz, 2) tag t1
while (.t.)
  clea
  if (gnArm#3)
    sele cskl
    skr=slcf('cskl', 1, 1, 18,, "e:sk h:'SK' c:n(3) e:nskl h:'Наименование' c:c(20) e:ctov h:'C' c:n(1)", 'sk',, 1,, "ent=gnEnt.and.file(gcPath_d+alltrim(path)+'tprds01.dbf')")
    if (lastkey()=K_ESC)
      exit
    endif

  else
    skr=gnSk
  endif

  sele cskl
  LOCATE for sk=skr
  gnRoz=roz
  nsklr=nskl
  Pathr=gcPath_d+alltrim(path)
  rccsklr=recn()
  if (lastkey()=K_ENTER)
    netuse('soper',,, 1)
    rckopr=recn()
    sopervdr=0
    while (.t.)
      sele soper
      go rckopr
      foot('INS,DEL,F2,F4,F5', 'Добавить,Удалить,Вид,Коррекция,Корр SKA')
      if (sopervdr=0)
        rckopr=slcf('soper', 1,, 18,, "e:d0k1 h:'Р' c:n(1) e:vo h:'О' c:n(2) e:kop h:'КОП' c:n(3) e:kopp h:'К А' c:n(3) e:nop h:'Операция' c:c(33) e:str(tcen,2) h:'Ц1' c:c(2) e:str(nds,2) h:'Н1' c:c(2) e:pBZen h:'2' c:n(1) e:str(ptcen,2) h:'Ц2' c:c(2) e:str(pnds,2) h:'Н2' c:c(2) e:pXZen h:'3' c:n(1) e:str(xtcen,2) h:'Ц3' c:c(2) e:str(xnds,2) h:'Н3' c:c(2) e:ska h:'ska' c:n(3) e:prnn h:'ПН' c:n(1) e:nof h:'Н' c:n(1)",,, 1)
      else
        rckopr=slcf('soper', 1,, 18,, "e:d0k1 h:'Р' c:n(1) e:vo h:'О' c:n(2) e:kop h:'КОП' c:n(3) e:kopp h:'К А' c:n(3) e:nop h:'Операция' c:c(33) e:str(tcen,2) h:'Ц1' c:c(2) e:str(nds,2) h:'Н1' c:c(2) e:kpl h:'Плател.' c:n(7) e:kkl h:'Получат' c:n(7) e:ska h:'ska' c:n(3) e:prnn h:'ПН' c:n(1) e:nof h:'Н' c:n(1)",,, 1)
      endif

      if (lastkey()=K_ESC)
        exit
      endif

      sele soper
      go rckopr
      d0k1r=d0k1
      vur=vu
      vor=vo
      qr=mod(kop, 100)
      kopr=100+qr
      if (fieldpos('kopp')#0)
        koppr=kopp
      else
        koppr=0
      endif

      nopr=nop
      noppr=''
      ndsr=nds
      pndsr=pnds
      tcenr=tcen
      if (fieldpos('pXZen')#0)
        pXZenr=pXZen
        xndsr=xnds
        xtcenr=xtcen
      else
        pXZenr=0
        xndsr=0
        xtcenr=0
      endif

      zcr=zc
      ttor=tto
      vpr=vp
      if (fieldpos('brpr')#0)
        brprr=brpr
      endif

      autor=auto
      skar=ska
      sktr=ska
      grtcenr=grtcen
      prnnr=prnn
      ptcenr=ptcen
      if (fieldpos('kkl')#0)
        kklr=kkl
      endif

      kplr=kpl
      if (fieldpos('pBZen')#0)
        pBZenr=pBZen
      else
        pBZenr=9
      endif

      if (fieldpos('rtcen')#0)
        rtcenr=rtcen
      else
        rtcenr=0
      endif

      nofr=0
      if (fieldpos('nof')#0)
        nofr=nof
      endif

      RndSdvr:=if(fieldpos('RndSdv')#0, RndSdv, 2)

      sele prov
      zap
      for i=1 to 20
        sele soper
        if (i<10)
          cdszr='dsz'+str(i, 1)
          cddbr='ddb'+str(i, 1)
          cdkrr='dkr'+str(i, 1)
          cprzr='prz'+str(i, 1)
          clevr='lev'+str(i, 1)
        else
          cdszr='dsz'+str(i, 2)
          cddbr='ddb'+str(i, 2)
          cdkrr='dkr'+str(i, 2)
          cprzr='prz'+str(i, 2)
          clevr='lev'+str(i, 2)
        endif

        /*
        //переделано ч.з. soper->(FIELDGET(FIELDPOS(cdszr)))
        АВТОР..ДАТА..........С. Литовка  27.04.05 * 10:05:53
        cdszrr=cdszr+'r'
        cddbrr=cddbr+'r'
        cdkrrr=cdkrr+'r'
        cprzrr=cprzr+'r'

        &cdszrr=&cdszr
        &cddbrr=&cddbr
        &cdkrrr=&cdkrr
        &cprzrr=&cprzr
        sele prov
        appe blank
        repl n20 with i
        repl ksz  with &cdszrr
        repl db   with &cddbrr
        repl kr   with &cdkrrr
        repl mask with &cprzrr
        */
        sele prov
        appe blank
        repl n20 with i
        repl ksz with soper->(FIELDGET(FIELDPOS(cdszr)))//&cdszrr
        repl db with soper->(FIELDGET(FIELDPOS(cddbr)))//&cddbrr
        repl kr with soper->(FIELDGET(FIELDPOS(cdkrr)))//&cdkrrr
        repl mask with soper->(FIELDGET(FIELDPOS(cprzr)))//&cprzrr
        repl lev with soper->(FIELDGET(FIELDPOS(clevr)))//

        ksz_r=ksz
        nz_r=getfield('t1', 'ksz_r', 'dclr', 'nz')
        sele prov
        repl nz with nz_r
      next

      sele prov
      dele all for ksz=0
      pack
      sele soper
      do case
      case (lastkey()=K_INS .and. (dkklnr=1.or.gnadm=1))
        SOperIns()
      case (lastkey()=-1)
        if (sopervdr=0)
          sopervdr=1
        else
          sopervdr=0
        endif

      case (lastkey()=K_DEL .and. (dkklnr=1.or.gnadm=1))
        netdel()
        skip -1
        if (bof())
          go top
        endif

        rckopr=recn()
      case (lastkey()=-3 .and. (dkklnr=1.or.gnadm=1))
        soperins(1)
      case (lastkey()=-4 .and. (dkklnr=1.or.gnadm=1))
        corrska()
      case (lastkey()=K_ESC)
        exit
      endcase

    enddo

    nuse('soper')
  endif

  if (gnArm#2)
    exit
  endif

  sele cskl
  go rccsklr
enddo

nuse()
sele prov
CLOSE
erase prov.dbf
erase prov.cdx

/***********************************************************
 * soperins() -->
 *   Параметры :
 *   Возвращает:
 */
function soperins(p1)
  clsoins=setcolor('gr+/b,n/w')
  if (p1=nil)
    cr_r=0
  else
    cr_r=p1
  endif

  if (p1=nil)
    store 0 to d0k1r, vor, ndsr, pndsr, skar, zcr, prnnr, kopr, koppr, vpr, autor, ttor, ;
     qr, ptcenr, kklr, kplr, brprr, nofr, RndSdvr
    tcenr=1

    if (pBZenr#9)
      pBZenr=0
    endif

    store space(40) to nopr, noppr, nptcenr, NtCenr, nrtcenr, nxtcenr

    sele prov
    zap
  endif

  foot('F3', 'Проводки')
  set key K_F3 to prv()
  // wsoins=wopen(1,1,MAXROW()-2,65)
  wsoins=wopen(1, 1, MAXROW()-2, 80)
  wbox(1)
  if (cr_r=1)
    zapsc()
  endif

  while (.t.)

    @ 0, 1 say 'Склад          '+nsklr

    @ 1, 19 say '(0-Расход;1-Приход)'
    @ 1, 1 say 'Тип документа  ' get d0k1r pict '9'// valid d0k1()
    @ 1, 46 say 'Округ.знак SDV'
    @ row(), col()+1 SAY RndSdvr pict '99'
    if (d0k1r=0)
      @ 1, 40 say 'НОФ '+str(nofr, 1)
    endif

    read
    if (lastkey()=K_ESC)
      exit
    endif

    if (d0k1r=0)
      @ 1, 40 say 'НОФ' get nofr pict '9'
      read
      if (lastkey()=K_ESC)
        exit
      endif

    endif
    if (d0k1r=0)
      nvor=getfield('t1', 'vor', 'vo', 'nvo')
    else
      nvor=getfield('t1', 'vor', 'vop', 'nvo')
    endif

    @ 1, 46 say 'Округ.знак SDV' get RndSdvr pict '99' ;
     valid RndSdvr <= 2 .AND. RndSdvr >= (-2)
    read
    if (lastkey()=K_ESC)
      exit
    endif



    //   @  2,36 say 'Плат '+str(kplr,7)+' '+getfield('t1','kplr','kln','nkl')
    //   @  3,36 say 'Пол. '+str(kklr,7)+' '+getfield('t1','kklr','kln','nkl')

    @ 2, 19 say subs(nvor, 1, 16)
    @ 2, 1 say 'Вид оплаты/опер' get vor pict '99' valid vo(2)
    read
    if (lastkey()=K_ESC)
      exit
    endif

    NtCenr=alltrim(getfield('t1', 'tcenr', 'tcen', 'NtCen'))
    @ 3, 21 say NtCenr      //25
    @ 3, 1 say NtC1r

    if (d0k1r=1)
      @ 3, 19 say str(tcenr, 2)//21
    else
      @ 3, 19 get tcenr pict '99' valid tcen(3)
    endif

    nndsr=getfield('t1', 'ndsr', 'snds', 'nnds')
    @ 4, 25 say nndsr
    @ 4, 1 say nonC1r get ndsr pict '9' valid nds(4)

    @ 5, 1 say 'Место в списке ' get grtcenr pict '99'

    @ 6, 1 say 'Код операции   ' get kopr pict '999' valid kop(6)
    @ 6, 21 get nopr
    read
    if (lastkey()=K_ESC)
      exit
    endif

    if (fieldpos('brpr')#0)
      @ 7, 1 say 'Банк. рек-ты   ' get brprr pict '99'
      @ 7, 21 say '(если "1", см SetUp.dbf пред-тия)'
      read
    endif

    if (lastkey()=K_ESC)
      exit
    endif

    if (d0k1r=0)
      @ 8, 25 say '(1 - разрешено формирование)'
      @ 8, 1 say 'Признак налог.накл.' get prnnr pict '9' when prnn()
    endif

    @ 9, 19 say '(1,2,3,4-авт.док.)'
    @ 9, 1 say 'Призн.авт.док. ' get autor pict '9'
    read
    if (lastkey()=K_ESC)
      exit
    endif

    sele soper
    if (fieldpos('ska')#0)
      if (autor=1.or.autor=2.or.autor=5)
        nsklar=getfield('t1', 'skar', 'cskl', 'nskl')
        @ 10, 21 say nsklar
        @ 10, 1 say 'Адрес назнач. ' get skar pict '999' valid vcskl(10)
      endif

      if (autor=0)
        skar=0
      endif

    else
      nskltr=getfield('t1', 'sktr', 'cskl', 'nskl')
      @ 10, 21 say nskltr
      @ 10, 1 say 'Адрес назн/ист.' get sktr pict '999' valid vcsklt(10)
    endif

    if (fieldpos('kopp')#0)
      //      if vor=6.and.(autor=1.or.autor=3.or.autor=4) // autor=3
      if (autor=1.or.autor=3.or.autor=4.or.autor=5)
        @ 11, 1 say 'Код авт операц.' get koppr pict '999'
      endif

    endif

    // 2-я цена
    if (d0k1r=0)
      @ 12, 1 say 'Призн.форм.2-й. цены ' get pBZenr pict '9'
      read
    else
      if (gnRoz=1)
        pBZenr=1
        //            @ 12,1 say 'Призн.отобр. отп. цен' get pBZenr pict '9'
      //            read
      endif

    endif

    if (lastkey()=K_ESC)
      exit
    endif

    if (pBZenr=1)
      inic()
      nptcenr=getfield('t1', 'ptcenr', 'tcen', 'NtCen')
      @ 13, 29 say nptcenr
      @ 13, 1 say NtC2r get ptcenr pict '99' when wptcen(13) valid vptcen(13)
      npndsr=getfield('t1', 'pndsr', 'snds', 'nnds')
      @ 14, 29 say npndsr
      @ 14, 1 say nonC2r get pndsr pict '99' when wpnds(14) valid vpnds(14)
    endif

    // 3-я цена
    sele soper
    //   if fieldpos('pXZen')#0
    if (d0k1r=0)
      @ 15, 1 say 'Призн.форм. 3-й цены ' get pXZenr pict '9'
      read
      if (lastkey()=K_ESC)
        exit
      endif

    endif

    //   endif
    if (pXZenr=1)
      inic()
      nxtcenr=getfield('t1', 'xtcenr', 'tcen', 'NtCen')
      @ 16, 29 say nxtcenr
      @ 16, 1 say NtC3r get xtcenr pict '99' when wptcen(16) valid vptcen(16)
      nxNdsr=getfield('t1', 'xndsr', 'snds', 'nnds')
      @ 17, 29 say nxNdsr
      @ 17, 1 say nonC3r get xndsr pict '99' when wpnds(17) valid vpnds(17)
    endif

    if (vor=2.and.gnD0k1=0 .or. (vor=6 .and.gnEnt=13))
      sele soper
      if (fieldpos('rtcen')#0)
        nrtcenr=getfield('t1', 'rtcenr', 'tcen', 'NtCen')
        @ 16, 29 say nrtcenr
        @ 16, 1 say 'Тип реком. цен ' get rtcenr pict '99' when wrtcen(16) valid vrtcen(16)
      endif

    endif

    nttor=getfield('t1', 'ttor', 'tto', 'nai')
    @ 18, 20 say nttor
    @ 18, 1 say 'Тип операции   ' get ttor pict '99' valid tto(18)

    if (d0k1r=0)
      @ 19, 19 say '(1 - Печать вознаграждения)'
      @ 19, 1 say 'Пр.для печ.цен ' get zcr pict '9' when wzc()
    endif

    //   @ 19,1 say 'Вид учета      ' get vur pict '9'

    read
    if (lastkey()=K_ESC)
      exit
    endif

    //   if vor=2
    sele soper
    if (fieldpos('kkl')#0)
      @ 2, 52 say getfield('t1', 'kplr', 'kln', 'nkl')
      @ 2, 36 say 'Плат' get kplr pict '9999999' valid kpl()
      read
      if (lastkey()=K_ESC)
        exit
      endif

      @ 3, 52 say getfield('t1', 'kklr', 'kln', 'nkl')
      @ 3, 36 say 'Пол.' get kklr pict '9999999' valid kkl()
      read
      if (lastkey()=K_ESC)
        exit
      endif

    endif

    //   else
    //      @ 2,30 say space(40)
    //   endif

    @ 19, 63 prom 'Верно'
    @ 19, col()+1 prom 'Не верно'
    menu to msoins
    if (lastkey()=K_ESC)
      exit
    endif

    if (msoins=1)
      sele soper
      if (p1=nil)
        if (netseek('t1', 'd0k1r,vur,vor,qr'))
          wselect(0)
          wmess('Такая операция уже существует')
          wselect('wsoins')
          loop
        endif

        netadd()
      //      endif
      else
        go rckopr
      endif

      reclock()
      repl d0k1 with d0k1r
      repl vu with 1        //gnVu
      repl vo with vor
      repl kop with qr
      repl nds with ndsr
      repl tcen with tcenr
      if (fieldpos('brpr')#0)
        repl brpr with brprr
      endif

      if (fieldpos('kopp')#0)
        repl kopp with koppr
      endif

      repl ska with skar
      repl zc with zcr
      repl prnn with prnnr
      repl tto with ttor
      repl vp with vpr
      repl auto with autor
      repl grtcen with grtcenr
      repl nop with nopr
      if (fieldpos('kkl')#0)
        repl kkl with kklr
        repl kpl with kplr
      endif

      repl pBZen with pBZenr
      repl pTCen with pTCenr
      repl pNds with pNdsr

      if (fieldpos('pXZen')#0)
        repl pxZen with pxZenr
        repl xTCen with xTCenr
        repl xNds with xNdsr
      endif

      if (fieldpos('rtcen')#0)
        repl rtcen with rtcenr
      endif

      if (fieldpos('nof')#0)
        repl nof with nofr
      endif
      if (fieldpos('RndSdv')#0)
        repl RndSdv  with RndSdvr
      endif

      for i=1 to 20
        sele soper
        if (i<10)
          dszcr='dsz'+str(i, 1)
          ddbcr='ddb'+str(i, 1)
          dkrcr='dkr'+str(i, 1)
          przcr='prz'+str(i, 1)
          levcr='lev'+str(i, 1)
        else
          dszcr='dsz'+str(i, 2)
          ddbcr='ddb'+str(i, 2)
          dkrcr='dkr'+str(i, 2)
          przcr='prz'+str(i, 2)
          levcr='lev'+str(i, 2)
        endif

        sele prov
        LOCATE for n20=i
        if (FOUND())
          kszr=ksz
          dbr=db
          krr=kr
          maskr=mask
          levr=_field->lev
        else
          store 0 to kszr, dbr, krr, levr
          store space(6) to maskr
        endif

        sele soper
        repl &dszcr with kszr
        repl &ddbcr with dbr
        repl &dkrcr with krr
        repl &przcr with maskr
        FIELDPUT(FIELDPOS(levcr), levr)
      next

      sele soper
      unlock
    endif

    exit
  enddo

  set key -2 to
  wclose(wsoins)
  setcolor(clsoins)
  return

/***********************************************************
 * vo() -->
 *   Параметры :
 *   Возвращает:
 */
static function vo(p1)
  wselect(0)
  if (d0k1r=0)
    sele vo
  else
    sele vop
  endif

  if (!netseek('t1', 'vor').or.vor=0)
    go top
    if (d0k1r=0)
      vor=slcf('vo',,,,, "e:vo h:' ' c:n(2) e:nvo h:'Наименование' c:c(20)", 'vo')
    else
      vor=slcf('vop',,,,, "e:vo h:' ' c:n(2) e:nvo h:'Наименование' c:c(20)", 'vo')
    endif

  endif

  if (d0k1r=0)
    nvor=getfield('t1', 'vor', 'vo', 'nvo')
  else
    nvor=getfield('t1', 'vor', 'vop', 'nvo')
  endif

  wselect(wsoins)
  @ p1, 19 say nvor
  inic()
  return (.t.)

/***********************************************************
 * tcen() -->
 *   Параметры :
 *   Возвращает:
 */
static function tcen(p1)
  wselect(0)
  sele tcen
  if (!netseek('t1', 'tcenr').or.tcenr=0)
    while (.t.)
      go top
      tcenr=slcf('tcen',,,,, "e:tcen h:' ' c:n(2) e:NtCen h:'Наименование' c:c(20) e:Zen h:'Поле' c:c(10)", 'tcen')
      //      if tcenr#0
      exit
    //      endif
    enddo

  endif

  wselect(wsoins)
  NtCenr=alltrim(getfield('t1', 'tcenr', 'tcen', 'NtCen'))
  @ p1, 21 say NtCenr
  return (.t.)

/***********************************************************
 * wptcen() -->
 *   Параметры :
 *   Возвращает:
 */
static function wptcen(p1)
  do case
  case (p1=13)
    if (pBZenr=0)
      ptcenr=0
      nptcenr=space(20)
      pndsr=0
      npndsr=space(20)
      @ p1, 25 say nptcenr
      return (.f.)
    endif

  case (p1=16)
    if (pXZenr=0)
      xtcenr=0
      nxtcenr=space(20)
      xndsr=0
      nxNdsr=space(20)
      @ p1, 25 say nxtcenr
      return (.f.)
    endif

  endcase

  return (.t.)

/***********************************************************
 * vptcen() -->
 *   Параметры :
 *   Возвращает:
 */
static function vptcen(p1)
  wselect(0)
  sele tcen
  do case
  case (p1=13)
    tcen_rr='ptcenr'
  case (p1=16)
    tcen_rr='xtcenr'
  endcase

  if (!netseek('t1', tcen_rr).or.&tcen_rr=0)
    while (.t.)
      go top
      &tcen_rr=slcf('tcen',,,,, "e:tcen h:' ' c:n(2) e:NtCen h:'Наименование' c:c(20) e:Zen h:'Поле' c:c(10)", 'tcen')
      //      if ptcenr#0
      exit
    //      endif
    enddo

  endif

  wselect(wsoins)
  do case
  case (p1=13)
    nptcenr=getfield('t1', 'ptcenr', 'tcen', 'NtCen')
    @ p1, 29 say nptcenr
  case (p1=16)
    nxtcenr=getfield('t1', 'xtcenr', 'tcen', 'NtCen')
    @ p1, 29 say nxtcenr
  endcase

  return (.t.)

/***********************************************************
 * wrtcen() -->
 *   Параметры :
 *   Возвращает:
 */
static function wrtcen(p1)
  if (d0k1r=1)
    rtcenr=0
    nrtcenr=space(30)
    @ p1, 29 say nrtcenr
    return (.f.)
  endif

  return (.t.)

/***********************************************************
 * vrtcen() -->
 *   Параметры :
 *   Возвращает:
 */
static function vrtcen(p1)
  wselect(0)
  sele tcen
  if (!netseek('t1', 'rtcenr').or.rtcenr=0)
    go top
    rtcenr=slcf('tcen',,,,, "e:tcen h:' ' c:n(2) e:NtCen h:'Наименование' c:c(20) e:Zen h:'Поле' c:c(10)", 'tcen')
  endif

  wselect(wsoins)
  nrtcenr=getfield('t1', 'rtcenr', 'tcen', 'NtCen')
  @ p1, 29 say nrtcenr
  return (.t.)

/***********************************************************
 * wcskl() -->
 *   Параметры :
 *   Возвращает:
 */
static function wcskl(p1)
  if (autor=0)
    skar=0
    nsklar=space(20)
    @ p1, 21 say nsklar
    return (.f.)
  endif

  return (.t.)

/***********************************************************
 * wcsklt() -->
 *   Параметры :
 *   Возвращает:
 */
static function wcsklt(p1)
  if (autor=0)
    sktr=0
    nskltr=space(20)
    @ p1, 21 say nskltr
    return (.f.)
  endif

  return (.t.)

/***********************************************************
 * vcskl() -->
 *   Параметры :
 *   Возвращает:
 */
static function vcskl(p1)
  local rcnr
  wselect(0)
  sele cskl
  rcnr=recn()
  if (!netseek('t1', 'skar').or.skar=0 .OR. ent#gnEnt)
    go top
    skar=slcf('cskl',,,,, "e:sk h:'SK' c:n(3) e:nskl h:'Наименование' c:c(20)", 'sk',,,, "ent=gnEnt")
  endif

  go rcnr
  wselect(wsoins)
  nsklar=getfield('t1', 'skar', 'cskl', 'nskl')
  @ p1, 21 say nsklar
  return (.t.)

/***********************************************************
 * vcsklt() -->
 *   Параметры :
 *   Возвращает:
 */
static function vcsklt(p1)
  local rcnr
  wselect(0)
  sele cskl
  rcnr=recn()
  if (!netseek('t1', 'sktr').or.sktr=0 .OR. ent#gnEnt)
    go top
    sktr=slcf('cskl',,,,, "e:sk h:'SK' c:n(3) e:nskl h:'Наименование' c:c(20)", 'sk',,,, "ent=gnEnt")
  endif

  go rcnr
  wselect(wsoins)
  nskltr=getfield('t1', 'sktr', 'cskl', 'nskl')
  @ p1, 21 say nskltr
  return (.t.)

/***********************************************************
 * tto() -->
 *   Параметры :
 *   Возвращает:
 */
static function tto(p1)
  wselect(0)
  sele tto
  if (!netseek('t1', 'ttor').or.ttor=0)
    go top
    ttor=slcf('tto',,,,, "e:tto h:'ТО' c:n(2) e:nai h:'Наименование' c:c(20)", 'tto')
    if (lastkey()=K_ESC)
      ttor=0
    endif

  endif

  wselect(wsoins)
  nttor=getfield('t1', 'ttor', 'tto', 'nai')
  @ p1, 20 say nttor
  return (.t.)

/***********************************************************
 * nds() -->
 *   Параметры :
 *   Возвращает:
 */
static function nds(p1)
  wselect(0)
  sele snds
  if (!netseek('t1', 'ndsr').or.ndsr=0)
    while (.t.)
      go top
      ndsr=slcf('snds',,,,, "e:nds h:'Код' c:n(1) e:nnds h:'Наименование' c:c(30)", 'nds')
      //      if ndsr#0
      exit
    //      endif
    enddo

  endif

  wselect(wsoins)
  nndsr=getfield('t1', 'ndsr', 'snds', 'nnds')
  wselect(wsoins)
  @ p1, 25 say nndsr
  return (.t.)

/***********************************************************
 * wpnds() -->
 *   Параметры :
 *   Возвращает:
 */
static function wpnds(p1)
  do case
  case (p1=14)
    if (pBZenr=0)
      pndsr=0
      npndsr=space(30)
      @ p1, 25 say npndsr
      return (.f.)
    endif

  case (p1=17)
    if (pXZenr=0)
      xndsr=0
      nxNdsr=space(30)
      @ p1, 25 say nxNdsr
      return (.f.)
    endif

  endcase

  return (.t.)

/***********************************************************
 * vpnds() -->
 *   Параметры :
 *   Возвращает:
 */
static function vpnds(p1)
  wselect(0)
  do case
  case (p1=14)
    nds_rr='pndsr'
  case (p1=17)
    nds_rr='xndsr'
  endcase

  sele snds
  if (!netseek('t1', nds_rr).or.&nds_rr=0)
    while (.t.)
      go top
      &nds_rr=slcf('snds',,,,, "e:nds h:'Код' c:n(1) e:nnds h:'Наименование' c:c(30)", 'nds')
      //      if pndsr#0
      exit
    //      endif
    enddo

  endif

  wselect(wsoins)
  do case
  case (p1=14)
    npndsr=getfield('t1', 'pndsr', 'snds', 'nnds')
    @ p1, 25 say npndsr
  case (p1=17)
    nxNdsr=getfield('t1', 'xndsr', 'snds', 'nnds')
    @ p1, 25 say nxNdsr
  endcase

  return (.t.)

/***********************************************************
 * kop() -->
 *   Параметры :
 *   Возвращает:
 */
static function kop(p1)
  if (kopr<100)
    kopr=kopr+100
  endif

  qr=mod(kopr, 100)
  sele soper
  if (qr=0)
    wselect(0)
    save scre to scmess
    mess('Код операции равен 0', 1)
    rest scre from scmess
    wselect(wsoins)
    return (.f.)
  endif

  if (netseek('t1', 'd0k1r,gnVu,vor,qr'))
    if (cr_r=0.or.(cr_r=1.and.recn()#rckopr))
      wselect(0)
      save scre to scmess
      mess('Этот код принадлежит другой операции', 1)
      go rckopr
      rest scre from scmess
      wselect(wsoins)
      return (.f.)
    endif

  endif

  return (.t.)

/***********************************************************
 * prv() -->
 *   Параметры :
 *   Возвращает:
 */
static function prv()
  wselect(0)
  save scre to scprv
  foot('INS,DEL,F4', 'Добавить,Удалить,Коррекция')
  sele prov
  go top
  while (.t.)
    rcprv=slcf('prov', 1, 30, 14,,                ;
                "e:ksz  h:'Кз'    c:n(2) "+        ;
                "e:db   h:'Дб'    c:n(6) "+        ;
                "e:kr   h:'Кр'    c:n(6) "+        ;
                "e:mask h:'Маска' c:c(6) "+        ;
                "e:lev  h:'Этап'  c:n(1) "+        ;
                "e:nz   h:'Наименование' c:c(20)", ;
                nil,, 1                            ;
             )
    go rcprv
    kszr=ksz
    dbr=db
    krr=kr
    maskr=mask
    nzr=nz
    levr=_field->lev
    do case
    case (lastkey()=K_ENTER)
      exit
    case (lastkey()=K_ESC)
      exit
    case (lastkey()=K_INS)// INS
      ProvIns()
    case (lastkey()=K_DEL)// DEL
      netdel()
      skip -1
    case (lastkey()=K_F4) // F4
      ProvIns(1)
    endcase

  enddo

  rest scre from scprv
  wselect(wsoins)
  return (.t.)

/***********************************************************
 * ProvIns() -->
 *   Параметры :
 *   Возвращает:
 */
static function ProvIns(p1)
  local getlist:={}
  clprvins=setcolor('gr+/b,n/w')
  wprvins=wopen(10, 20, 16, 60)
  wbox(1)
  sel=select()
  if (p1=nil)
    store 0 to ksz_r, db_r, kr_r, lev_r
    store space(6) to mask_r
    store space(20) to nz_r
  else
    ksz_r=kszr
    db_r=dbr
    kr_r=krr
    mask_r=maskr
    lev_r=levr
  endif

  while (.t.)
    if (p1=nil)
      @ 0, 1 say 'Код затрат' get ksz_r pict '99' valid ksz()
    else
      @ 0, 1 say 'Код затрат'+' '+str(ksz_r, 2)+' '+nzr
    endif

    @ 1, 1 say 'Дебет ' get db_r pict '999999' valid prdb()
    @ 2, 1 say 'Кредит' get kr_r pict '999999' valid prkr()
    @ 3, 1 say 'Маска ' get mask_r
    @ 4, 1 say 'Этап  ' get lev_r pict '9'
    read
    if (lastkey()=K_ESC)
      exit
    endif

    @ 4, 20 prom 'Верно'
    @ 4, col()+1 prom 'Не верно'
    menu to vnr
    if (lastkey()=K_ESC)
      exit
    endif

    if (vnr=1)
      sele prov
      if (p1=nil)
        set order to
        go bott
        if (ksz_r=90)
          n20r=20
        else
          if (ksz#90)
            n20r=n20+1
          else
            skip -1
            n20r=n20+1
          endif

        endif

        set order to tag t1
        netadd()
        netrepl('n20,ksz,db,kr,mask,nz,lev', 'n20r,ksz_r,db_r,kr_r,mask_r,nz_r,lev_r')
      else
        netrepl('db,kr,mask,lev', 'db_r,kr_r,mask_r,lev_r')
      endif

      exit
    endif

  enddo

  wclose(wprvins)
  setcolor(clprvins)
  wselect(0)
  sele (sel)
  return

/***********************************************************
 * prdb() -->
 *   Параметры :
 *   Возвращает:
 */
static function prdb()
  sele bs
  //*if !netseek('t1','db_r')
  //   wmess('Счет отсутствует в справочнике балансовых счетов',1)
  //   returnrn .f.
  //*endif
  return (.t.)

/***********************************************************
 * prkr() -->
 *   Параметры :
 *   Возвращает:
 */
static function prkr()
  sele bs
  //if !netseek('t1','kr_r')
  //   wmess('Счет отсутствует в справочнике балансовых счетов',1)
  //   returnrn .f.
  //endif
  return (.t.)

/***********************************************************
 * ksz() -->
 *   Параметры :
 *   Возвращает:
 */
static function ksz()
  sele dclr
  if (!netseek('t1', 'ksz_r').or.ksz_r=0)
    go top
    wselect(0)
    ksz_r=slcf('dclr',,,,, "e:kz h:'Кз' c:n(2) e:nz h:'Наименование' c:c(20)", 'kz')
    wselect(wprvins)
    nz_r=getfield('t1', 'ksz_r', 'dclr', 'nz')
    @ 0, 15 say nz_r
  else
    nz_r=getfield('t1', 'ksz_r', 'dclr', 'nz')
    @ 0, 15 say nz_r
  endif

  return (.t.)

/***********************************************************
 * prnn() -->
 *   Параметры :
 *   Возвращает:
 */
static function prnn()
  if (d0k1r=1)
    prnnr=0
    return (.f.)
  endif

  return (.t.)

/***********************************************************
 * wzc() -->
 *   Параметры :
 *   Возвращает:
 */
static function wzc()
  if (d0k1r=1)
    zcr=0
    return (.f.)
  endif

  return (.t.)

  //*stat func d0k1()
  //*inic()
  //*return .t.

static function inic()
  store space(20) to NtC1r, NtC2r, NtC3r, nonC1r, nonC2r, nonC3r
  if (d0k1r=1)            // Приход
    NtC1r= 'Тип учетной цены    '
    nonC1r='Отн.к НДС уч.цены   '
    if (gnRoz=1)
      NtC2r= 'Тип отпускной цены  '
      nonC2r='Отн.к НДС отп.цены  '
    endif

  else                      // Расход
    NtC1r= 'Тип цены прайса     '
    nonC1r='Отн.к НДС цен прайса'
    if (pBZenr=1)
      NtC2r= 'Тип 2-й цены        '
      nonC2r='Отн.к НДС 2-й цены  '
    endif

    if (pXZenr=1)
      NtC3r= 'Тип 3-й цены        '
      nonC3r='Отн.к НДС 3-й.цены  '
    endif

  endif

  @ 3, 1 say NtC1r
  @ 4, 1 say nonC1r
  @ 13, 1 say NtC2r
  @ 14, 1 say nonC2r
  @ 16, 1 say NtC3r
  @ 17, 1 say nonC3r
  return (.t.)

/***********************************************************
 * kkl() -->
 *   Параметры :
 *   Возвращает:
 */
static function kkl()
  if (kklr=0)
  //   return .f.
  endif

  nklr=getfield('t1', 'kklr', 'kln', 'nkl')
  if (empty(nklr))
  //   return .f.
  endif

  @ 3, 52 say nklr
  return (.t.)

/***********************************************************
 * kpl() -->
 *   Параметры :
 *   Возвращает:
 */
static function kpl()
  if (kplr=0)
  //   return .f.
  endif

  nklr=getfield('t1', 'kplr', 'kln', 'nkl')
  if (empty(nklr))
  //   return .f.
  endif

  @ 2, 52 say nklr
  return (.t.)

/***********************************************************
 * zapsc() -->
 *   Параметры :
 *   Возвращает:
 */
static function zapsc()
  inic()
  @ 1, 19 say '(0-Расход;1-Приход)'
  @ 1, 1 say 'Тип документа  '+' '+str(d0k1r, 1)
  if (d0k1r=0)
    nvor=getfield('t1', 'vor', 'vo', 'nvo')
  else
    nvor=getfield('t1', 'vor', 'vop', 'nvo')
  endif

  @ 2, 20 say subs(nvor, 1, 16)
  @ 2, 1 say 'Вид оплаты/опер'+' '+str(vor, 2)
  /*if vor=2 */
  sele soper
  @ 2, 52 say getfield('t1', 'kplr', 'kln', 'nkl')
  @ 2, 36 say 'Плат'+' '+str(kplr, 7)
  if (fieldpos('kkl')#0)
    @ 3, 52 say getfield('t1', 'kklr', 'kln', 'nkl')
    @ 3, 36 say 'Пол.'+' '+str(kklr, 7)
  endif

  /*endif */
  NtCenr=getfield('t1', 'tcenr', 'tcen', 'NtCen')
  @ 3, 25 say alltrim(NtCenr)
  @ 3, 1 say NtC1r
  @ 3, 21 say str(tcenr, 2)

  nndsr=getfield('t1', 'ndsr', 'snds', 'nnds')
  @ 4, 25 say nndsr
  @ 4, 1 say nonC1r+' '+str(ndsr, 1)

  @ 5, 1 say 'Место в списке '+' '+str(grtcenr, 2)

  @ 6, 1 say 'Код операции   '+' '+str(kopr, 3)
  @ 6, 21 say nopr

  if (d0k1r=0)
    @ 8, 25 say '(1 - разрешено формирование)'
    @ 8, 1 say 'Признак налог.накл.'+' '+str(prnnr, 1)
  endif

  @ 9, 19 say '(1,2,3-авт.док.)'
  @ 9, 1 say 'Призн.авт.док. '+' '+str(autor, 1)

  sele soper
  if (fieldpos('ska')#0)
    if (autor=1.or.autor=2)
      nsklar=getfield('t1', 'skar', 'cskl', 'nskl')
      @ 10, 21 say nsklar
      @ 10, 1 say 'Адрес назнач. '+' '+str(skar, 3)
    endif

  else
    nskltr=getfield('t1', 'sktr', 'cskl', 'nskl')
    @ 10, 21 say nskltr
    @ 10, 1 say 'Адрес назн/ист.'+str(sktr, 3)
  endif

  //*if d0k1r=0
  //   if vor=2
  //      @ 12,1 say 'Призн.форм.бухг.цены '+' '+str(pBZenr,1)
  //   else
  //      @ 12,1 say 'Призн.форм.ном. цены '+' '+str(pBZenr,1)
  //   endif
  //*else
  //   if gnRoz=1
  //      pBZenr=1
  //   endif
  //*endif
  if (pBZenr=1)
    inic()
    nptcenr=getfield('t1', 'ptcenr', 'tcen', 'NtCen')
    @ 13, 29 say nptcenr
    @ 13, 1 say NtC2r+' '+str(ptcenr, 2)
    npndsr=getfield('t1', 'pndsr', 'snds', 'nnds')
    @ 14, 29 say npndsr
    @ 14, 1 say nonC2r+' '+str(pndsr, 2)
  endif

  if (pXZenr=1)
    inic()
    nxtcenr=getfield('t1', 'xtcenr', 'tcen', 'NtCen')
    @ 16, 29 say nxtcenr
    @ 16, 1 say NtC3r+' '+str(xtcenr, 2)
    nxNdsr=getfield('t1', 'xndsr', 'snds', 'nnds')
    @ 17, 29 say nxNdsr
    @ 17, 1 say nonC3r+' '+str(xndsr, 2)
  endif

  if (d0k1r=0)
    if (vor=2 .or. (vor=6 .and. gnEnt=13))
      sele soper
      if (fieldpos('rtcen')#0)
        nrtcenr=getfield('t1', 'rtcenr', 'tcen', 'NtCen')
        @ 16, 29 say nrtcenr
        @ 16, 1 say 'Тип реком. цен '+' '+str(rtcenr, 1)
      endif

    endif

  endif

  nttor=getfield('t1', 'ttor', 'tto', 'nai')
  @ 18, 20 say nttor
  @ 18, 1 say 'Тип операции   '+' '+str(ttor, 2)

  if (d0k1r=0)
    @ 19, 19 say '(1 - Печать вознаграждения)'
    @ 19, 1 say 'Пр.для печ.цен '+' '+str(zcr, 1)
  endif

  /*@ 19,1 say 'Вид учета      '+' '+str(vur,1) */
  return (.t.)

/*************** */
function corrska()
  /*************** */
  if (gnArnd#0)
    return (.t.)
  endif

  if (gnArm=3.or.gnArm=1)
    sele soper
    go top
    while (!eof())
      skar=ska
      for i=1 to 20
        cddbr='ddb'+alltrim(str(i, 2))
        cdkrr='dkr'+alltrim(str(i, 2))
        ddbr=&cddbr
        dkrr=&cdkrr
        do case
        case (int(ddbr/1000)=361.or.int(dkrr/1000)=361)
          sele cskl
          locate for ent=gnEnt.and.tpstpok=2
          if (foun())
            skar=sk
            exit
          endif

        case (int(ddbr/1000)=631.or.int(dkrr/1000)=631)
          sele cskl
          locate for ent=gnEnt.and.tpstpok=1
          if (foun())
            skar=sk
            exit
          endif

        otherwise
        endcase

      next

      sele soper
      if (skar#0)
        if (skar#ska)
          wmess(str(d0k1, 1)+' '+str(vo, 2)+' '+str(kop, 2)+' '+str(ska, 3)+'-'+str(skar, 3))
          netrepl('ska,auto', 'skar,2')
        else
          netrepl('auto', '2')
        endif

      else
        if (auto=2)
          netrepl('ska,auto', '0,0')
        else
          netrepl('ska', '0')
        endif

      endif

      sele soper
      skip
    enddo

  endif

  return (.t.)
