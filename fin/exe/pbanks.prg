/***********************************************************
 * Модуль    : pbanks.prg
 * Версия    : 0.0
 * Автор     :
 * Дата      : 05/02/19
 * Изменен   :
 * Примечание: Текст обработан утилитой CF версии 2.02
 */

#include "inkey.ch"

#ifdef __CLIP__
#else
  #translate DTOC(< v1 >, <v2>) =>            ;
   (iif(<v2> = nil, DTOC(<v1>),             ;
          (                                    ;
            _sdtf:=Set(_SET_DATEFORMAT, <v2>) ;
            , _cDtoC:=DTOC(<v1>)              ;
            , Set(_SET_DATEFORMAT, _sdtf)     ;
            , _cDtoC                            ;
         )                                     ;
       )                                       ;
  )
  #translate CTOD(< v1 >, <v2>) =>            ;
   (iif(<v2> = nil, CTOD(<v1>),             ;
          (                                    ;
            _sdtf:=Set(_SET_DATEFORMAT, <v2>) ;
            , _cCtoD:=CTOD(<v1>)              ;
            , Set(_SET_DATEFORMAT, _sdtf)     ;
            , _cCtoD                            ;
         )                                     ;
       )                                       ;
  )
#endif

// Автомат банка
flr=alltrim(PathBnr)+alltrim(fBanksr)
if (!file(flr))
  wmess('Нет файла '+flr)
  prautor=0
  return
endif

crtt('tbank', "f:tip c:n(1) f:dkkl c:n(7) f:dkkl8 c:n(12) f:kkkl c:n(7) f:kkkl8 c:n(12) f:ssd c:n(15,2) f:osn c:c(100) f:ndkkl8 c:c(37) f:nkkkl8 c:c(37) f:dMFO c:c(6) f:dRS c:c(15) f:kMFO c:c(6) f:kRS c:c(15) f:nplp c:n(6) f:knsd c:n(12,2) f:knsk c:n(12,2) f:lord c:n(1) f:cnplp c:c(20)")
sele 0
use tbank
do case
case (bsr=311001 .or.(bsr=311007.and.gnEnt=21))//
  ugb()
case (bsr=311003.or.bsr=311008.or.bsr=311010.or.bsr=313011.or.bsr=311011)//Укрсоц
                            // файл r:\banks\usb.dbf
  usb()
case (bsr=601003)         //Укрсоц
                            // файл r:\banks\usb.dbf
  usb()
case (bsr=311004 .and.gnEnt=20)         //Аваль новый
  UkrsibNew()

case (bsr=311006.or.bsr=311009.and.gnEnt=21)//Укрсиб
                            // файл r:\banks\budnfo~1.dbf
  if (prUkrsibr=2)
    UkrsibNew()
  else
    Ukrsib()
  endif

case (bsr=311009.and.gnEnt=20)//Приватбанк
                                // файл r:\privat\dbf\export.dbf  //budinf
                                // файл r:\privat1\dbf\export.dbf //tabak
  prvat()
case (bsr=311007-1)           //Индекс  откл 05-17-17 03:27pm
                                // файл r:\kidex\upp\export.dbf
  kindex()
case (bsr=311001-1)       //Аваль
                            // текстовый файл r:\banks\vyymmdd.zzz
  aval()
case (bsr=311004-1)         //ПИБ
                            // файл r:\klient\exit\export.dbf
  pib()
otherwise
endcase

sele tbank
go top
while (!eof())
  dkkl8r=dkkl8
  kkkl8r=kkkl8
  tipr=tip
  if (tipr=3)
    lordr=1
  else
    lordr=2
  endif

  dkklr=getfield('t5', 'dkkl8r', 'kln', 'kkl')
  kkklr=getfield('t5', 'kkkl8r', 'kln', 'kkl')
  sele tbank
  repl dkkl with dkklr, ;
   kkkl with kkklr,     ;
   lord with lordr
  skip
enddo

sele tbank
inde on str(lord, 1)+str(ssd, 15, 2) tag t1
go top
fldnomr=1
rctbankr=recn()
while (.t.)
  foot('F2,F3,DEL', 'Поиск А,Поиск Б,Удалить')
  sele tbank
  go rctbankr
  rctbankr=slce('tbank', 1, 1, 18,, "e:tip h:'ТП' c:n(1) e:nplp h:'ПП' c:n(6) e:ssd h:'Сумма' c:n(12,2) e:dkkl h:'Код' c:n(7) e:getfield('t1','tbank->dkkl','kln','nkl') h:'Клиент А' c:c(20) e:kkkl h:'Код' c:n(7) e:getfield('t1','tbank->kkkl','kln','nkl') h:'Клиент Б' c:c(20) e:osn h:'Основание' c:c(100) e:dkkl8 h:'А8' c:n(12) e:ndkkl8 h:'Клиент А8' c:с(37) e:kkkl8 h:'Б8' c:n(12) e:nkkkl8 h:'Клиент Б8' c:c(37)",,,,, 'tip>0',,, 0, 0)
  if (lastkey()=K_ESC)
    exit
  endif

  go rctbankr
  dkklr=dkkl
  kkklr=kkkl
  dkkl8r=dkkl8
  kkkl8r=kkkl8
  ndkkl8r=ndkkl8
  nkkkl8r=nkkkl8
  dMFOr=dMFO
  dRSr=dRS
  kMFOr=kMFO
  kRSr=kRS
  do case
  case (lastkey()=19)     //Left
    fldnomr=fldnomr-1
    if (fldnomr=0)
      fldnomr=1
    endif

  case (lastkey()=4)      //Right
    fldnomr=fldnomr+1
  case (lastkey()=-1)     //Поиск А
    psk(1)
  case (lastkey()=-2)     //Поиск B
    psk(2)
  case (lastkey()=7)      //Удалить
    netdel()
    skip -1
    if (bof())
      go top
    endif

    rctbankr=recn()
  endcase

enddo

sele tbank
go top
while (!eof())
  dkklr=dkkl
  dMFOr=dMFO
  dRSr=dRS
  sele kklrs
  if (!netseek('t1', 'dkklr,dMFOr,dRSr'))
    netadd()
    netrepl('kkl,MFO,rs', 'dkklr,dMFOr,dRSr')
  endif

  sele tbank
  kkklr=kkkl
  kMFOr=kMFO
  kRSr=kRS
  sele kklrs
  if (!netseek('t1', 'kkklr,kMFOr,kRSr'))
    netadd()
    netrepl('kkl,MFO,rs', 'kkklr,kMFOr,kRSr')
  endif

  sele tbank
  skip
enddo

sele tbank
if (recc()=0)
  wmess('Нет документов')
  prautor=0
endif

CLOSE

/***********************************************************
 * aval() -->
 *   Параметры :
 *   Возвращает:
 */
function aval()
  cDelim=CHR(13) + CHR(10)
  hzvr=fopen(flr)
  n=1
  nn=2
  /*467 */
  while (!feof(hzvr))
    if (n<nn)
      n=n+1
      aaa=FReadLn(hzvr, 1, 470, cDelim)
      loop
    endif

    aaa=FReadLn(hzvr, 1, 470, cDelim)
#ifdef __CLIP__
      aaa := translate_charset("cp866", host_charset(), aaa)
#endif
    if (subs(aaa, 2, 1)='+')
      tipr=1
    else
      tipr=3
    endif

    aaa_r=subs(aaa, 200, 8)
    ddc_r=ctod(subs(aaa_r, 7, 2)+'.'+subs(aaa_r, 5, 2)+'.'+subs(aaa_r, 1, 4))
    if (ddc_r#ddcr)
      loop
    endif

    dkkl8r=val(subs(aaa, 28, 12))
    kkkl8r=val(subs(aaa, 105, 12))
    ssdr=val(subs(aaa, 175, 13))/100
    osnr=subs(aaa, 212, 100)
    ndkkl8r=subs(aaa, 40, 37)
    nkkkl8r=subs(aaa, 117, 37)
    dMFOr=subs(aaa, 6, 6)
    dRSr=subs(aaa, 12, 15)
    kMFOr=subs(aaa, 83, 6)
    kRSr=subs(aaa, 89, 15)
    nplpr=val(subs(aaa, 163, 6))
    cnplpr=subs(aaa, 163, 10)

    przgr=0
    dMFO_r=alltrim(dMFOr)
    dRS_r=alltrim(dRSr)
    kMFO_r=alltrim(kMFOr)
    kRS_r=alltrim(kRSr)
    sele MFOchk
    if (netseek('t1', 'gnKln_c,bsr,dMFO_r,dRS_r'))
      przgr=1
    endif

    if (przgr=0)
      if (netseek('t1', 'gnKln_c,bsr,kMFO_r,kRS_r'))
        przgr=1
      endif

    endif

    if (przgr=0)
      loop
    endif

    sele tbank
    appe blank
    repl tip with tipr,   ;
     dkkl8 with dkkl8r,   ;
     kkkl8 with kkkl8r,   ;
     ndkkl8 with ndkkl8r, ;
     nkkkl8 with nkkkl8r, ;
     dMFO with dMFOr,     ;
     dRS with dRSr,       ;
     kMFO with kMFOr,     ;
     kRS with kRSr,       ;
     ssd with ssdr,       ;
     osn with osnr,       ;
     nplp with nplpr,     ;
     cnplp with cnplpr
  enddo

  fclose(hzvr)
  return (.t.)

/***********************************************************
 * psk() -->
 *   Параметры :
 *   Возвращает:
 */
function psk(p1)
  local getlist:={}
  if (p1=1)
    kkl8r=dkkl8r
    nkkl8r=ndkkl8r
    kb1r='000'+dMFO
    ns1r=dRS
  else
    kkl8r=kkkl8r
    nkkl8r=nkkkl8r
    kb1r='000'+kMFO
    ns1r=kRS
  endif

  store space(20) to cntxtr
  clpsk=setcolor('n/w,n/bg')
  wpsk=wopen(6, 10, 13, 60)
  wbox(1)
  @ 0, 1 say 'Клиент  '+' '+str(kkl8r, 12)+' '+nkkl8r
  @ 1, 1 say 'Контекст'+' ' get cntxtr
  read
  wclose(wpsk)
  setcolor(clpsk)
  wselect(0)
  if (lastkey()=13.and.!empty(cntxtr))
    cntxt_r=alltrim(upper(cntxtr))
    sele kln
    go top
    rcklnr=recn()
    pskforr='.t..and.at(cntxt_r,upper(nkl))#0.and.kkl>10000'
    foot('', '')
    rcklnr=slcf('kln', 1, 1, 18,, "e:kkl h:'Код' c:n(7) e:nkl h:'Наименование' c:c(30) e:kkl1 h:'Код8' c:n(10) e:alltrim(kb1) h:'Банк' c:c(9) e:kklp h:'КодП' c:n(7) e:nn h:'Нал.Код' c:n(12)",,,,, pskforr,, str(kkl8r, 12)+' '+alltrim(nkkl8r))
    if (lastkey()=13)
      go rcklnr
      kklr=kkl
      netrepl('kklp,kkl1', 'kklr,kkl8r')
      if (empty(kb1))
        netrepl('kb1', 'kb1r')
      endif

      if (empty(ns1))
        netrepl('ns1', 'ns1r')
      endif

      sele tbank
      if (p1=1)
        netrepl('dkkl,dMFO,dRS,kMFO,kRS', 'kklr,dMFOr,dRSr,kMFOr,kRSr')
      else
        netrepl('kkkl', 'kklr')
      endif

    endif

  endif

  return (.t.)

/*****************************************************************
 
 FUNCTION:
 АВТОР..ДАТА..........С. Литовка  04-05-17 * 02:45:14pm
 НАЗНАЧЕНИЕ.........
 ПАРАМЕТРЫ..........
 ВОЗВР. ЗНАЧЕНИЕ....
 ПРИМЕЧАНИЯ.........
 */
function ugb()
  use (flr) alias ugb new readonly//shared
                                    //browse()
  while (!EOF())
    // пропускаем дни
    if (.t. .and. ddcr # CTOD(data_d, 'dd.mm.yyyy'))// дата проведения д-та
      sele ugb
      skip
      loop
    endif

    ssdr := sum_pd_nom      // сумма оплата
    osnr := win2lin(Purpose)// основания
    Nplpr:= cNplpr(nd)      // ном докум
    cNplpr:=nd                // ном докум

    dKkl8r:=val(okpo)     // ОКПО  n6
    nDKkl8r:=win2lin(name)// название с6
    dMFOr:=MFO              //  МФО банка с6
    dRSr:=ac                // счет с6

    kKkl8r:=val(okpo_kor) // ОКПО корресподента
    nKkkl8r:=win2lin(name_kor)// назван корресподента
    kMFOr:=MFO_kor              // МФО корресподента
    kRSr:=ac_kor                // счет  корресподента

    /*делаем копии */
    dMFO_r:=alltrim(dMFOr)
    dRS_r:=alltrim(dRSr)
    kMFO_r:=alltrim(kMFOr)
    kRS_r:=alltrim(kRSr)

    store '' to ChkDr, ChkKr
    prZgr=0

    // Дб и Кр? проводка
    sele MFOchk
    if (netseek('t1', 'gnKln_c,bsr,dMFO_r,dRS_r'))
      ChkDr=alltrim(chk)
    endif

    if (netseek('t1', 'gnKln_c,bsr,kMFO_r,kRS_r'))
      ChkKr=alltrim(chk)
    endif

    if (empty(ChkDr).and.empty(ChkKr))// не нашли ничего
      sele ugb
      skip
      loop
    endif

    dkkl8_r=dkkl8r
    ndkkl8_r=ndkkl8r
    dMFO_r=dMFOr
    dRS_r=dRSr

    kkkl8_r=kkkl8r
    nkkkl8_r=nkkkl8r
    kMFO_r=kMFOr
    kRS_r=kRSr

    sele ugb
    tipr:=iif(alltrim(dk)#'1', 1, 3)
    do case
    case (tipr=1.and.!empty(ChkKr))//Поступление
      tipr=1

      dkkl8_r=dkkl8r
      ndkkl8_r=ndkkl8r
      dMFO_r=dMFOr
      dRS_r=dRSr

      kkkl8_r=kkkl8r
      nkkkl8_r=nkkkl8r
      kMFO_r=kMFOr
      kRS_r=kRSr

    case (tipr=1.and.!empty(ChkDr))//Снятие
      tipr=3

      dkkl8_r=dkkl8r
      ndkkl8_r=ndkkl8r
      dMFO_r=dMFOr
      dRS_r=dRSr

      kkkl8_r=kkkl8r
      nkkkl8_r=nkkkl8r
      kMFO_r=kMFOr
      kRS_r=kRSr

    case (tipr=3.and.!empty(ChkDr))//Поступление
      tipr=1

      dkkl8_r=kkkl8r
      ndkkl8_r=nkkkl8r
      dMFO_r=kMFOr
      dRS_r=kRSr

      kkkl8_r=dkkl8r
      nkkkl8_r=ndkkl8r
      kMFO_r=dMFOr
      kRS_r=dRSr

    case (tipr=3.and.!empty(ChkKr))//Снятие
      tipr=3

      dkkl8_r=kkkl8r
      ndkkl8_r=nkkkl8r
      dMFO_r=kMFOr
      dRS_r=kRSr

      kkkl8_r=dkkl8r
      nkkkl8_r=ndkkl8r
      kMFO_r=dMFOr
      kRS_r=dRSr

    otherwise
      skip
      loop
    endcase

    sele tbank
    appe blank
    repl tip with tipr,    ;
     dkkl8 with dkkl8_r,   ;// счет ДТ
     kkkl8 with kkkl8_r,   ;// счет КТ
     ndkkl8 with ndkkl8_r, ;
     nkkkl8 with nkkkl8_r, ;
     dMFO with dMFO_r,     ;
     dRS with dRS_r,       ;
     kMFO with kMFO_r,     ;
     kRS with kRS_r,       ;
     ssd with ssdr,        ;
     osn with osnr,        ;// основание
     nplp with nplpr,      ;// n6 номер плат поруч
     cnplp with cnplpr      // c6 номер плат поруч
    sele ugb
    skip
  enddo

  close ugb
  return (.T.)

/***********************************************************
 * Ukrsib() -->
 *   Параметры :
 *   Возвращает:
 */
function Ukrsib()
  sele 0
  use (flr) alias Ukrsib readonly//shared
  while (!eof())
    // //   if date_doc#ddcr
    if (date_carry#ddcr)
      sele Ukrsib
      skip
      loop
    endif

    if (debet='К')
      tipr=1
    else
      tipr=3
    endif

    dkkl8r=val(okpo_payer)
    kkkl8r=val(okpo_rec)
    ssdr=summa
    osnr=ground
    ndkkl8r=payer
    nkkkl8r=receiver
    dMFOr=MFO_payer
    dRSr=acc_payer
    kMFOr=MFO_rec
    kRSr=acc_rec

    przgr=0
    dMFO_r=alltrim(dMFOr)
    dRS_r=alltrim(dRSr)
    kMFO_r=alltrim(kMFOr)
    kRS_r=alltrim(kRSr)
    cnplpr=numb_doc

    sele MFOchk
    if (netseek('t1', 'gnKln_c,bsr,dMFO_r,dRS_r'))
      przgr=1
    endif

    if (przgr=0)
      if (netseek('t1', 'gnKln_c,bsr,kMFO_r,kRS_r'))
        przgr=1
      endif

    endif

    if (przgr=0)
      sele Ukrsib
      skip
      loop
    endif

    if (len(alltrim(cnplpr))<7)
      nplpr=val(cnplpr)
    else
      nplpr=val(right(cnplpr, 6))
    endif

    sele tbank
    appe blank
    repl tip with tipr,   ;
     dkkl8 with dkkl8r,   ;
     kkkl8 with kkkl8r,   ;
     ndkkl8 with ndkkl8r, ;
     nkkkl8 with nkkkl8r, ;
     dMFO with dMFOr,     ;
     dRS with dRSr,       ;
     kMFO with kMFOr,     ;
     kRS with kRSr,       ;
     ssd with ssdr,       ;
     osn with osnr,       ;
     nplp with nplpr,     ;
     cnplp with cnplpr
    sele Ukrsib
    skip
  enddo

  sele Ukrsib
  CLOSE
  return (.t.)

/***********************************************************
 * usb() -->
 *   Параметры :
 *   Возвращает:
 */
function usb()
  sele 0
  use (flr) alias usb readonly
  while (!eof())

    dkkl8r=val(kl_okp)
    ndkkl8r=kl_nm
    dMFOr=MFO
    dRSr=kl_chk
    kkkl8r=val(kl_okp_k)
    nkkkl8r=kl_nm_k
    kMFOr=MFO_k
    kRSr=kl_chk_k

    dMFO_r=alltrim(dMFOr)
    dRS_r=alltrim(dRSr)
    kMFO_r=alltrim(kMFOr)
    kRS_r=alltrim(kRSr)

    store '' to ChkDr, ChkKr
    przgr=0
    sele MFOchk
    if (netseek('t1', 'gnKln_c,bsr,dMFO_r,dRS_r'))
      ChkDr=alltrim(chk)
    endif

    if (netseek('t1', 'gnKln_c,bsr,kMFO_r,kRS_r'))
      ChkKr=alltrim(chk)
    endif

    if (empty(ChkDr).and.empty(ChkKr))
      sele usb
      skip
      loop
    endif

    dkkl8_r=dkkl8r
    kkkl8_r=kkkl8r
    ndkkl8_r=ndkkl8r
    nkkkl8_r=nkkkl8r
    dMFO_r=dMFOr
    dRS_r=dRSr
    kMFO_r=kMFOr
    kRS_r=kRSr
    sele usb
    do case
    case (dk=1.and.!empty(ChkKr))//Поступление
      tipr=1
      dkkl8_r=dkkl8r
      kkkl8_r=kkkl8r
      ndkkl8_r=ndkkl8r
      nkkkl8_r=nkkkl8r
      dMFO_r=dMFOr
      dRS_r=dRSr
      kMFO_r=kMFOr
      kRS_r=kRSr
    case (dk=1.and.!empty(ChkDr))//Снятие
      tipr=3
      dkkl8_r=dkkl8r
      kkkl8_r=kkkl8r
      ndkkl8_r=ndkkl8r
      nkkkl8_r=nkkkl8r
      dMFO_r=dMFOr
      dRS_r=dRSr
      kMFO_r=kMFOr
      kRS_r=kRSr
    case (dk=2.and.!empty(ChkDr))//Поступление
      tipr=1
      dkkl8_r=kkkl8r
      kkkl8_r=dkkl8r
      ndkkl8_r=nkkkl8r
      nkkkl8_r=ndkkl8r
      dMFO_r=kMFOr
      dRS_r=kRSr
      kMFO_r=dMFOr
      kRS_r=dRSr
    case (dk=2.and.!empty(ChkKr))//Снятие
      tipr=3
      dkkl8_r=kkkl8r
      kkkl8_r=dkkl8r
      ndkkl8_r=nkkkl8r
      nkkkl8_r=ndkkl8r
      dMFO_r=kMFOr
      dRS_r=kRSr
      kMFO_r=dMFOr
      kRS_r=dRSr
    otherwise
      skip
      loop
    endcase

    /**************** */

    ssdr=s
    osnr=n_p
    /*************** */
    cnplpr=nd
    cnssr=''
    for i=1 to 10
      aaa=subs(cnplpr, i, 1)
      if (empty(aaa))
        loop
      endif

      if (isdigit(aaa))
        cnssr=cnssr+aaa
      endif

    next

    if (!empty(cnssr))
      if (len(cnssr)>6)
        cnssr=subs(cnssr, 1, 6)
      endif

      nplpr=val(cnssr)
    else
      nplpr=0
    endif

    /*************** */
    //   nplpr=val(nd)
    sele tbank
    appe blank
    repl tip with tipr,    ;
     dkkl8 with dkkl8_r,   ;
     kkkl8 with kkkl8_r,   ;
     ndkkl8 with ndkkl8_r, ;
     nkkkl8 with nkkkl8_r, ;
     dMFO with dMFO_r,     ;
     dRS with dRS_r,       ;
     kMFO with kMFO_r,     ;
     kRS with kRS_r,       ;
     ssd with ssdr,        ;
     osn with osnr,        ;
     nplp with nplpr,      ;
     cnplp with cnplpr
    sele usb
    skip
  enddo

  sele usb
  CLOSE
  return (.t.)

/***********************************************************
 * pib() -->
 *   Параметры :
 *   Возвращает:
 */
function pib()
  sele 0
  use (flr) alias pib readonly
  while (!eof())
    if (fieldpos('un_data')#0)
      if (un_data#ddcr)
        sele pib
        skip
        loop
      endif

    endif

    if (fieldpos('data')#0)
      if (data#ddcr)
        sele pib
        skip
        loop
      endif

    endif

    if (dk=1)
      tipr=3
      dkkl8r=val(kl_okp)
      ndkkl8r=''            //kl_nm
      dMFOr=MFO
      dRSr=kl_chk
      kkkl8r=val(kl_okp_k)
      nkkkl8r=kl_nm_k
      kMFOr=MFO_k
      kRSr=kl_chk_k
    else
      tipr=1
      dkkl8r=val(kl_okp_k)
      ndkkl8r=kl_nm_k       //kl_nm
      dMFOr=MFO_k
      dRSr=kl_chk_k
      kkkl8r=val(kl_okp)
      nkkkl8r=''            //kl_nm_k
      kMFOr=MFO
      kRSr=kl_chk
    endif

    przgr=0
    dMFO_r=alltrim(dMFOr)
    dRS_r=alltrim(dRSr)
    kMFO_r=alltrim(kMFOr)
    kRS_r=alltrim(kRSr)
    sele MFOchk
    if (netseek('t1', 'gnKln_c,bsr,dMFO_r,dRS_r'))
      przgr=1
    endif

    if (przgr=0)
      if (netseek('t1', 'gnKln_c,bsr,kMFO_r,kRS_r'))
        przgr=1
      endif

    endif

    sele pib
    if (przgr=0)
      skip
      loop
    endif

    if (fieldpos('text1')#0)
      osnr=text1
      ssdr=s/100
    endif

    if (fieldpos('n_p')#0)
      osnr=n_p
      ssdr=s
    endif

    cnplpr=alltrim(nd)
    nssr=at('/', cnplpr)
    if (nssr#0)
      cnplpr=subs(cnplpr, nssr+1)
    endif

    cnplpr=alltrim(cnplpr)
    if (len(cnplpr)>6)
      cnplpr=subs(cnplpr, 1, 6)
    endif

    nplpr=val(cnplpr)
    sele tbank
    appe blank
    repl tip with tipr,   ;
     dkkl8 with dkkl8r,   ;
     kkkl8 with kkkl8r,   ;
     ndkkl8 with ndkkl8r, ;
     nkkkl8 with nkkkl8r, ;
     dMFO with dMFOr,     ;
     dRS with dRSr,       ;
     kMFO with kMFOr,     ;
     kRS with kRSr,       ;
     ssd with ssdr,       ;
     osn with osnr,       ;
     nplp with nplpr,     ;
     cnplp with cnplpr
    sele pib
    skip
  enddo

  sele pib
  CLOSE
  return (.t.)

/***********************************************************
 * prvat() -->
 *   Параметры :
 *   Возвращает:
 */
function prvat()

  sele 0
  use (flr) alias private readonly

  while (!eof())
    if (date#dtos(ddcr))
      skip
      loop
    endif

    if (summa<0)
      tipr=3
    else
      tipr=1
    endif

    dkkl8r=val(okpo_a)
    ndkkl8r=win2lin(name_a)
    dMFOr=MFO_a
    dRSr=count_a
    kkkl8r=val(okpo_b)
    nkkkl8r=win2lin(name_b)
    kMFOr=MFO_b
    kRSr=count_b

    przgr=0
    dMFO_r=alltrim(dMFOr)
    dRS_r=alltrim(dRSr)
    kMFO_r=alltrim(kMFOr)
    kRS_r=alltrim(kRSr)
    sele MFOchk
    if (netseek('t1', 'gnKln_c,bsr,dMFO_r,dRS_r'))
      przgr=1
    endif

    if (przgr=0)
      if (netseek('t1', 'gnKln_c,bsr,kMFO_r,kRS_r'))
        przgr=1
      endif

    endif

    sele private
    if (przgr=0)
      skip
      loop
    endif

    ssdr=abs(summa)

    osnr=win2lin(n_p)

    cnplpr=n_d
    cnssr=''
    for i=1 to 10
      aaa=subs(cnplpr, i, 1)
      if (empty(aaa))
        loop
      endif

      if (isdigit(aaa))
        cnssr=cnssr+aaa
      endif

    next

    if (!empty(cnssr))
      if (len(cnssr)>6)
        cnssr=subs(cnssr, 6)
      endif

      nplpr=val(cnssr)
    else
      nplpr=0
    endif

    sele tbank
    appe blank
    repl tip with tipr,   ;
     dkkl8 with dkkl8r,   ;
     kkkl8 with kkkl8r,   ;
     ndkkl8 with ndkkl8r, ;
     nkkkl8 with nkkkl8r, ;
     dMFO with dMFOr,     ;
     dRS with dRSr,       ;
     kMFO with kMFOr,     ;
     kRS with kRSr,       ;
     ssd with ssdr,       ;
     osn with osnr,       ;
     nplp with nplpr,     ;
     cnplp with cnplpr
    sele private
    skip
  enddo

  sele private
  CLOSE
  return (.t.)

/***********************************************************
 * MFOchk() -->
 *   Параметры :
 *   Возвращает:
 */
function MFOchk()
  clea
  netuse('banks')
  netuse('kln')
  netuse('MFOchk')
  sele MFOchk
  chkwhlr='.t..and.kkl8=gnKln_c'
  netseek('t1', 'gnKln_c')
  rcMFOchkr=recn()
  while (.t.)
    go rcMFOchkr
    foot('INS,DEL,F4', 'Доб,Удал.,Корр')
    rcMFOchkr=slcf('MFOchk', 1, 1, 18,, "e:MFO h:'МФО' c:c(6) e:chk h:'Счет' c:c(29) e:nchk h:'Назначение' c:c(40) e:bs h:'Счет' c:n(6)",,, 1, chkwhlr,,, 'Счета '+alltrim(gcName_c))
    if (lastkey()=K_ESC)
      exit
    endif

    go rcMFOchkr
    MFOr=MFO
    cMFOr='000'+MFOr
    nMFOr=getfield('t1', 'cMFOr', 'banks', 'otb')
    chkr=chk
    nchkr=nchk
    pathbnr=pathbn
    fbanksr=fbanks
    bsr=bs
    do case
    case (lastkey()=22)   //Добавить
      chkins(0)
    case (lastkey()=7)    //Удалить
      netdel()
      skip -1
      if (kkl8#gnKln_c)
        netseek('t1', 'gnKln_c')
      endif

      rcMFOchkr=recn()
    case (lastkey()=-3)   //Коррекция
      chkins(1)
    endcase

  enddo

  nuse()
  return (.t.)

/***********************************************************
 * chkins() -->
 *   Параметры :
 *   Возвращает:
 */
function chkins(p1)
  if (p1=0)

    sele MFOchk
    copy stru to tmpstru
    use tmpstru new

    MFOr=    MFO
    chkr=    chk
    nchkr=   nchk
    pathbnr= pathbn
    fbanksr= fbanks
    bsr=0
    nMFOr=''

    close tmpstru
    sele MFOchk
  endif

  clchk=setcolor('gr+/b,n/bg')
  wchk=wopen(10, 10, 18, 70)
  wbox(1)
  while (.t.)
    if (p1=0)
      @ 0, 1 say 'МФО' get MFOr
      @ 0, col()+1 say alltrim(nMFOr)
      @ 1, 1 say 'Счет' get chkr pict "@R XX99_9999_9999_9999_9999_9999_9999_9" ;
      valid (mod97_10(chkr),.t.)
    else
      @ 0, 1 say 'МФО'+' '+alltrim(MFOr)
      @ 0, col()+1 say alltrim(nMFOr)
      @ 1, 1 say 'Счет'+' '+chkr pict "@R XX99_9999_9999_9999_9999_9999_9999_9"
    endif

    @ 2, 1 say 'Назначение' get nchkr
    @ 3, 1 say 'Бух Счет' get bsr pict '999999'
    @ 4, 1 say 'Путь' get pathbnr
    @ 5, 1 say 'Файл' get fbanksr
    @ 6, 1 prom 'Верно'
    @ 6, col()+1 prom 'Не Верно'
    read
    if (lastkey()=K_ESC)
      exit
    endif

    menu to mchkr
    if (mchkr=1)
      if (p1=0)
        netadd()
        netrepl('kkl8', 'gnKln_c')
        netrepl('MFO,chk,nchk,bs,pathbn,fbanks', 'MFOr,chkr,nchkr,bsr,pathbnr,fbanksr')
        rcMFOchkr=recn()
      else
        netrepl('nchk,bs,pathbn,fbanks', 'nchkr,bsr,pathbnr,fbanksr')
      endif

      exit
    endif

  enddo

  wbox(1)
  wclose(wchk)
  setcolor(clchk)
  return (.t.)

/***********************************************************
 * UkrsibNew() -->
 *   Параметры :
 *   Возвращает:
 */
function UkrsibNew()
  sele 0
  use (flr) alias Ukrsib readonly
  while (!eof())

    dkkl8r=val(kl_okp)
    ndkkl8r=win2lin(kl_nm)
    dMFOr=MFO
    dRSr=kl_chk
    kkkl8r=val(kl_okp_k)
    nkkkl8r=win2lin(kl_nm_k)
    kMFOr=MFO_k
    kRSr=kl_chk_k

    przgr=0
    dMFO_r=alltrim(dMFOr)
    dRS_r=alltrim(dRSr)
    kMFO_r=alltrim(kMFOr)
    kRS_r=alltrim(kRSr)
    store '' to ChkDr, ChkKr
    sele MFOchk
    if (netseek('t1', 'gnKln_c,bsr,dMFO_r,dRS_r'))
      ChkDr=alltrim(chk)
    endif

    if (netseek('t1', 'gnKln_c,bsr,kMFO_r,kRS_r'))
      ChkKr=alltrim(chk)
    endif

    if (empty(ChkDr).and.empty(ChkKr))
      sele Ukrsib
      skip
      loop
    endif

    dkkl8_r=dkkl8r
    kkkl8_r=kkkl8r
    ndkkl8_r=ndkkl8r
    nkkkl8_r=nkkkl8r
    dMFO_r=dMFOr
    dRS_r=dRSr
    kMFO_r=kMFOr
    kRS_r=kRSr
    sele Ukrsib
    do case
    case (dk=1.and.!empty(ChkKr).and.empty(ChkDr))//Поступление
      tipr=1
      dkkl8_r=dkkl8r
      kkkl8_r=kkkl8r
      ndkkl8_r=ndkkl8r
      nkkkl8_r=nkkkl8r
      dMFO_r=dMFOr
      dRS_r=dRSr
      kMFO_r=kMFOr
      kRS_r=kRSr
    case (dk=1.and.!empty(ChkDr).and.empty(ChkKr))//Снятие
      tipr=3
      dkkl8_r=dkkl8r
      kkkl8_r=kkkl8r
      ndkkl8_r=ndkkl8r
      nkkkl8_r=nkkkl8r
      dMFO_r=dMFOr
      dRS_r=dRSr
      kMFO_r=kMFOr
      kRS_r=kRSr
    case (dk=2.and.!empty(ChkDr).and.empty(ChkKr))//Поступление
      tipr=1
      dkkl8_r=kkkl8r
      kkkl8_r=dkkl8r
      ndkkl8_r=nkkkl8r
      nkkkl8_r=ndkkl8r
      dMFO_r=kMFOr
      dRS_r=kRSr
      kMFO_r=dMFOr
      kRS_r=dRSr
    case (dk=2.and.!empty(ChkKr).and.empty(ChkDr))//Снятие
      tipr=3
      dkkl8_r=kkkl8r
      kkkl8_r=dkkl8r
      ndkkl8_r=nkkkl8r
      nkkkl8_r=ndkkl8r
      dMFO_r=kMFOr
      dRS_r=kRSr
      kMFO_r=dMFOr
      kRS_r=dRSr
    case (!empty(ChkKr).and.!empty(ChkDr))//Переброска
      if (dk=1)
        tipr=1
        dkkl8_r=dkkl8r
        kkkl8_r=kkkl8r
        ndkkl8_r=ndkkl8r
        nkkkl8_r=nkkkl8r
        dMFO_r=dMFOr
        dRS_r=dRSr
        kMFO_r=kMFOr
        kRS_r=kRSr
      else
        tipr=3
        dkkl8_r=kkkl8r
        kkkl8_r=dkkl8r
        ndkkl8_r=nkkkl8r
        nkkkl8_r=ndkkl8r
        dMFO_r=kMFOr
        dRS_r=kRSr
        kMFO_r=dMFOr
        kRS_r=dRSr
      endif

    otherwise
      skip
      loop
    endcase

    /**************** */

    ssdr=s
    osnr=win2lin(n_p)
    /*************** */
    cnplpr=nd
    cnssr=''
    for i=1 to 10
      aaa=subs(cnplpr, i, 1)
      if (empty(aaa))
        loop
      endif

      if (isdigit(aaa))
        cnssr=cnssr+aaa
      endif

    next

    if (!empty(cnssr))
      if (len(cnssr)>6)
        cnssr=subs(cnssr, 1, 6)
      endif

      nplpr=val(cnssr)
    else
      nplpr=0
    endif

    /*************** */
    //   nplpr=val(nd)
    sele tbank
    appe blank
    repl tip with tipr,    ;
     dkkl8 with dkkl8_r,   ;
     kkkl8 with kkkl8_r,   ;
     ndkkl8 with ndkkl8_r, ;
     nkkkl8 with nkkkl8_r, ;
     dMFO with dMFO_r,     ;
     dRS with dRS_r,       ;
     kMFO with kMFO_r,     ;
     kRS with kRS_r,       ;
     ssd with ssdr,        ;
     osn with osnr,        ;
     nplp with nplpr,      ;
     cnplp with cnplpr
    sele Ukrsib
    skip
  enddo

  sele Ukrsib
  CLOSE
  return (.t.)

/*************** */
function kindex()
  /*************** */
  sele 0
  use (flr) alias kindex readonly// shared
  while (!eof())
    if (operdata#ddcr)
      sele kindex
      skip
      loop
    endif

    //   if debet='К'
    tipr=1
    //   else
    //      tipr=3
    //   endif
    dkkl8r=val(kod_deb)
    kkkl8r=val(kod_cred)
    ssdr=opersum
    osnr=naznach
    ndkkl8r=naim_deb
    nkkkl8r=naim_cred
    dMFOr=MFO_deb
    dRSr=acc_debit
    kMFOr=MFO_cred
    kRSr=acc_credit

    przgr=0
    dMFO_r=str(dMFOr, 6)
    dRS_r=alltrim(dRSr)
    kMFO_r=str(kMFOr, 6)
    kRS_r=alltrim(kRSr)

    cnplpr=nomer

#ifdef __CLIP__
      outlog(__FILE__, __LINE__, "Определение переменных Ok")
#endif

    sele MFOchk
    if (netseek('t1', 'gnKln_c,bsr,dMFO_r,dRS_r'))
      tipr=3
      przgr=1
    endif

    if (przgr=0)
      if (netseek('t1', 'gnKln_c,bsr,kMFO_r,kRS_r'))
        tipr=1
        przgr=1
      endif

    endif

    if (przgr=0)
      sele kindex
      skip
      loop
    endif

    if (len(alltrim(cnplpr))<7)
      nplpr=val(cnplpr)
    else
      nplpr=val(right(cnplpr, 6))
    endif

    sele tbank
    appe blank
    repl tip with tipr,   ;
     dkkl8 with dkkl8r,   ;
     kkkl8 with kkkl8r,   ;
     ndkkl8 with ndkkl8r, ;
     nkkkl8 with nkkkl8r, ;
     dMFO with dMFO_r,    ;
     dRS with dRS_r,      ;
     kMFO with kMFO_r,    ;
     kRS with kRS_r,      ;
     ssd with ssdr,       ;
     osn with osnr,       ;
     nplp with nplpr,     ;
     cnplp with cnplpr
    sele kindex
    skip
  enddo

  sele kindex
  CLOSE
  return (.t.)

/*****************************************************************
 
 FUNCTION:
 АВТОР..ДАТА..........С. Литовка  04-05-17 * 04:40:16pm
 НАЗНАЧЕНИЕ......... удалить не числовые символы и урезать до 6 знаков
 ПАРАМЕТРЫ..........
 ВОЗВР. ЗНАЧЕНИЕ....
 ПРИМЕЧАНИЯ.........
 */
static function cnplpr(cnplpr)
  local cnssr:='', aaa, nplpr

  for i=1 to 10
    aaa=subs(cnplpr, i, 1)
    if (empty(aaa))
      loop
    endif

    if (isdigit(aaa))
      cnssr += aaa
    endif

  next

  if (!empty(cnssr))
    if (len(cnssr)>6)
      cnssr=subs(cnssr, 1, 6)
    endif

    nplpr=val(cnssr)
  else
    nplpr=0
  endif

  return (nplpr)
