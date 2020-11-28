/***********************************************************
 * Модуль    : rslibe.prg
 * Версия    : 0.0
 * Автор     :
 * Дата      : 04/03/18
 * Изменен   :
 * Примечание: Текст обработан утилитой CF версии 2.02
 */

#include "common.ch"
#include "inkey.ch"
//

/*************** */
function prnnds()
  /*************** */
  knds=1
  p_nds=ndsr
  p_pnds=pndsr
  nklr=nkplr
  d0k1r=gnD0k1
  if (bom(gdTd)<ctod('01.03.2011'))
    if (!netuse('nds'))
      return
    endif

    sele nds
    if (netseek('t3', 'gnSk,ttnr,d0k1r'))
      nomndsr=nomnds
      ndsdr=ndsd
      sumdcr=sumc
      sumr=sum
      dtt=dnn
      private arab[ 1, 5 ], andsd[ 10, 2 ], attn[ 1 ]
      if (empty(gcPrn))
        upri=chr(27)+chr(77)+chr(15)
      endif

      store 0 to ndsr, sfr, sumkr
      sele kln
      if (netseek('t1', 'kplr'))
        //      nklr=alltrim(nkl)
        if (!empty(nklprn))
          nklr=alltrim(nklprn)
        else
          nklr=alltrim(nkl)
        endif

        adrr=adr
        tlfr=tlf
        nnr=nn
        cnnr=cnn
        nsvr=nsv
        kkl1r=kkl1
      else
        nklr='Нет в справочнике'
        store '' to adrr, tlfr, nsvr
        nnr=0
        cnnr=''
      endif

      if (!netuse('tovn'))
        nuse()
        return
      endif

      ktlr=ktl
      natr=nat
      neir=nei
      zenr=zen
      nopr='Отпуск ТМЦ по предоплате'
      srr=0
      rndsr=0
      ndsr=0
      cntttnr=1
      ddokr=dtt
      nkl=nkplr
      if (ndsdr#0)        // НН - коррекция
        arab[ 1, 1 ]=ttnr
        arab[ 1, 2 ]=gnSk
        arab[ 1, 3 ]=0
        arab[ 1, 4 ]=sumdcr
      else                  // НН - обычная
        arab[ 1, 1 ]=ttnr
        arab[ 1, 2 ]=gnSk
        arab[ 1, 3 ]=sdvr
        arab[ 1, 4 ]=sdvr
      endif

      sele nds
      set orde to tag t1
      save scre to scnnpr
      clnppr=setcolor('g/n,n/g')
      clea
      pnn()
      clnppr=setcolor(clnppr)
      rest scre from scnnpr
    else
      save scre to scnnpr
      sele kln
      if (netseek('t1', 'kplr'))
        nklr=alltrim(nkl)
        adrr=adr
        tlfr=tlf
        nnr=nn
        cnnr=cnn
        nsvr=nsv
        kkl1r=kkl1
      else
        nklr='Нет в справочнике'
        store '' to adrr, tlfr, nsvr
        nnr=0
        cnnr=''
      endif

      nnt()
      rest scre from scnnpr
    endif

  else
    if (!netuse('nnds'))
      return
    endif

    sele nnds
    if (netseek('t2', '0,0,gnSk,ttnr,0'))
      nomndsr=nnds
      ndsdr=0
      sumdcr=0
      sumr=sm
      dtt=dnn
      private arab[ 1, 5 ], andsd[ 10, 2 ], attn[ 1 ]
      store 0 to ndsr, sfr, sumkr
      sele kln
      if (netseek('t1', 'kplr'))
        if (!empty(nklprn))
          nklr=alltrim(nklprn)
        else
          nklr=alltrim(nkl)
        endif

        adrr=adr
        tlfr=tlf
        nnr=nn
        cnnr=cnn
        nsvr=nsv
        kkl1r=kkl1
      else
        nklr='Нет в справочнике'
        store '' to adrr, tlfr, nsvr
        nnr=0
        cnnr=''
      endif

      if (!netuse('tovn'))
        nuse()
        return
      endif

      ktlr=ktl
      natr=nat
      neir=nei
      zenr=zen
      nopr='Отпуск ТМЦ по предоплате'
      srr=0
      rndsr=0
      ndsr=0
      cntttnr=1
      ddokr=dtt
      nkl=nkplr
      if (ndsdr#0)        // НН - коррекция
        arab[ 1, 1 ]=ttnr
        arab[ 1, 2 ]=gnSk
        arab[ 1, 3 ]=0
        arab[ 1, 4 ]=sumdcr
      else                  // НН - обычная
        arab[ 1, 1 ]=ttnr
        arab[ 1, 2 ]=gnSk
        arab[ 1, 3 ]=sdvr
        arab[ 1, 4 ]=sdvr
      endif

      sele nds
      set orde to tag t1
      save scre to scnnpr
      clnppr=setcolor('g/n,n/g')
      clea
      pnn()
      clnppr=setcolor(clnppr)
      rest scre from scnnpr
    endif

  endif

  return (.t.)

/************ */
function ttnw()
  /************ */
  skttnr=savesetkey()
  set key 32 to ttn
  return (.t.)

/************ */
function ttnv()
  /************ */
  set key 32 to
  restsetkey(skttnr)
  return (.t.)

/*********** */
function ttn()
  /*********** */
  static nRecStartView
  local getList:={}
  DEFAULT nRecStartView to (DBGoTop(), RECNO())
  set key 32 to
  sele sl
  zap
  kol177r=0
  fldnomr=1
  sele rs1
  go nRecStartView          //top
  while (.t.)
    set cent off
    sele rs1
    foot('F3,F4,F5,F6,F7,F8,F10', 'Фильтр,Печать СФ,ФП,ДтМод,В общую,ДЗ,З/Экс')
    //   foot('F3,F4,F5,F6,F7,F8,F9,F10','Фильтр,Печать СФ,ФП,ДтМод,В общую,ДЗ,Серт,З/Экс')
    do case
    case (gnVo=2.or.gnVo=9.or.gnVo=1.or.gnVo=3)
      do case
      case (TtnPrzr=0)    // Все
        if (TtnKpkr=0)
          if (gnKt=0)
            //    ttnr=slcf('rs1',1,,18,,"e:ttn h:'ТТН' c:n(6) e:kop h:'КОП' c:n(3) e:prz h:'П' c:n(1) e:dvp h:'Дата В' c:d(8) e:dop h:'Дата О' c:d(8) e:sdv h:'Сумма' c:n(10,2) e:getfield('t1','rs1->kpv','kln','nkl') h:'Получатель' c:c(23) e:getfield('t1','rs1->kta','s_tag','fio') h:'Агент' c:c(8) e:kolosp h:'O' c:n(1) e:pr49 h:'П' c:n(1)",'ttn',,,,forttnr)
            if (fieldpos('ttn177')#0)
              if (gnEnt=20)
                ttnr=slcf('rs1', 1,, 18,, "e:ttn h:'ТТН' c:n(6) e:kop h:'КОП' c:n(3) e:prz h:'П' c:n(1) e:dvp h:'Дата В' c:d(8) e:dop h:'Дата О' c:d(8) e:sdv h:'Сумма' c:n(10,2) e:getfield('t1','rs1->kpv','kgp','ngrpol') h:'Получатель' c:c(23) e:getfield('t1','rs1->kta','s_tag','fio') h:'Агент' c:c(8) e:przzen h:'Z' c:n(1) e:pr177 h:'O' c:n(1)", 'ttn',,,, forttnr)
              else
                if (gnEnt=20)
                  ttnr=slcf('rs1', 1,, 18,, "e:ttn h:'ТТН' c:n(6) e:kop h:'КОП' c:n(3) e:prz h:'П' c:n(1) e:dvp h:'Дата В' c:d(8) e:dop h:'Дата О' c:d(8) e:sdv h:'Сумма' c:n(10,2) e:getfield('t1','rs1->kpv','kgp','ngrpol') h:'Получатель' c:c(23) e:getfield('t1','rs1->kta','s_tag','fio') h:'Агент' c:c(8) e:przzen h:'Z' c:n(1) e:pr177 h:'O' c:n(1)", 'ttn',,,, forttnr)
                else
                  ttnr=slcf('rs1', 1,, 18,, "e:ttn h:'ТТН' c:n(6) e:kop h:'КОП' c:n(3) e:prz h:'П' c:n(1) e:dvp h:'Дата В' c:d(8) e:dop h:'Дата О' c:d(8) e:sdv h:'Сумма' c:n(10,2) e:getfield('t1','rs1->kpv','kln','nkl') h:'Получатель' c:c(23) e:getfield('t1','rs1->kta','s_tag','fio') h:'Агент' c:c(8) e:przzen h:'Z' c:n(1) e:pr177 h:'O' c:n(1)", 'ttn',,,, forttnr)
                endif

              endif

            else
              if (gnEnt=20)
                ttnr=slcf('rs1', 1,, 18,, "e:ttn h:'ТТН' c:n(6) e:kop h:'КОП' c:n(3) e:prz h:'П' c:n(1) e:dvp h:'Дата В' c:d(8) e:dop h:'Дата О' c:d(8) e:sdv h:'Сумма' c:n(10,2) e:getfield('t1','rs1->kpv','kgp','ngrpol') h:'Получатель' c:c(23) e:getfield('t1','rs1->kta','s_tag','fio') h:'Агент' c:c(8) e:przzen h:'Z' c:n(1) e:pr49 h:'П' c:n(1)", 'ttn',,,, forttnr)
              else
                ttnr=slcf('rs1', 1,, 18,, "e:ttn h:'ТТН' c:n(6) e:kop h:'КОП' c:n(3) e:prz h:'П' c:n(1) e:dvp h:'Дата В' c:d(8) e:dop h:'Дата О' c:d(8) e:sdv h:'Сумма' c:n(10,2) e:getfield('t1','rs1->kpv','kln','nkl') h:'Получатель' c:c(23) e:getfield('t1','rs1->kta','s_tag','fio') h:'Агент' c:c(8) e:przzen h:'Z' c:n(1) e:pr49 h:'П' c:n(1)", 'ttn',,,, forttnr)
              endif

            endif

          else
            ttnr=slcf('rs1', 1,, 18,, "e:ttn h:'ТТН' c:n(6) e:kop h:'КОП' c:n(3) e:prz h:'П' c:n(1) e:dot h:'Дата П' c:d(8) e:sdv h:'Сумма' c:n(10,2) e:getfield('t1','rs1->kpl','kln','nkl') h:'Комиссионер' c:c(23) e:ttnkt h:'ТТНКТ' c:n(6) e:nndskt h:'ННКТ' c:n(6) e:dnnkt h:'ДтКТ' c:d(8)", 'ttn',,,, forttnr)
          endif

        else
          if (TtnKpkpr=0)
            if (gnEnt=20.and.gnSk=241.or.gnEnt=21.and.gnSk=244)
              ttnr=slce('rs1', 1,, 18,, "e:ttn h:'ТТН' c:n(6) e:kop h:'КОП' c:n(3) e:timecrt h:'Время КПК' c:c(19) e:sdv h:'Сумма' c:n(10,2) e:getfield('t1','rs1->kpv','kgp','ngrpol') h:'Получатель' c:c(23) e:getfield('t1','rs1->kta','s_tag','fio') h:'Агент' c:c(8) e:docguid h:'Документ КПК' c:c(36) e:kta h:'KTA' c:n(4) e:ktas h:'KTAS' c:n(4) e:prz h:'П' c:n(1) e:dfp h:'Дата ФП' c:d(8) e:dop h:'Дата O' c:d(8)", 'ttn',,,, forttnr,,, 1, 2)
            else
              if (fieldpos('fc')=0)
                if (gnEnt=20)
                  ttnr=slce('rs1', 1,, 18,, "e:ttn h:'ТТН' c:n(6) e:kop h:'КОП' c:n(3) e:prz() h:'П' c:c(3) e:dfp h:'Дата ФП' c:d(8) e:dop h:'Дата O' c:d(8) e:sdv h:'Сумма' c:n(10,2) e:getfield('t1','rs1->kpv','kgp','ngrpol') h:'Получатель' c:c(23) e:getfield('t1','rs1->kta','s_tag','fio') h:'Агент' c:c(8) e:docguid h:'Документ КПК' c:c(36) e:timecrt h:'Время КПК' c:c(19) e:kta h:'KTA' c:n(4) e:ktas h:'KTAS' c:n(4) e:tdc h:'ВрС' c:c(8)", 'ttn',,,, forttnr,,, 1, 2)
                else
                  ttnr=slce('rs1', 1,, 18,, "e:ttn h:'ТТН' c:n(6) e:kop h:'КОП' c:n(3) e:prz h:'П' c:n(1) e:dfp h:'Дата ФП' c:d(8) e:dop h:'Дата O' c:d(8) e:sdv h:'Сумма' c:n(10,2) e:getfield('t1','rs1->kpv','kln','nkl') h:'Получатель' c:c(23) e:getfield('t1','rs1->kta','s_tag','fio') h:'Агент' c:c(8) e:docguid h:'Документ КПК' c:c(36) e:timecrt h:'Время КПК' c:c(19) e:kta h:'KTA' c:n(4) e:ktas h:'KTAS' c:n(4) e:tdc h:'ВрС' c:c(8)", 'ttn',,,, forttnr,,, 1, 2)
                endif

              else
                if (gnEnt=20 .or. gnEnt=21)
                  //ttnr=slce('rs1',1,,18,,"e:ttn h:'ТТН' c:n(6) e:kop h:'КОП' c:n(3) e:kopi h:'КОП' c:n(3) e:prz h:'П' c:n(1) e:dfp h:'Дата ФП' c:d(8) e:dop h:'Дата O' c:d(8) e:sdv h:'Сумма' c:n(10,2) e:getfield('t1','rs1->kpv','kln','nkl') h:'Получатель' c:c(23) e:getfield('t1','rs1->kta','s_tag','fio') h:'Агент' c:c(8) e:docguid h:'Документ КПК' c:c(36) e:timecrt h:'Время КПК' c:c(19) e:kta h:'KTA' c:n(4) e:ktas h:'KTAS' c:n(4) e:tdc h:'ВрС' c:c(8) e:fc h:'Блок' c:n(1) e:getfield('t1','rs1->ttn,46','rs3','ssf') h:'Серт' c:n(10,2)",'ttn',,,,forttnr,,,1,2)
                  ttnr=slce('rs1', 1,, 18,, "e:ttn h:'ТТН' c:n(6) e:kop h:'КОП' c:n(3) e:prz() h:'П' c:c(3) e:dfp h:'Дата ФП' c:d(8) e:ktofp h:'ФК' c:n(4) e:dop h:'Дата O' c:d(8) e:sdv h:'Сумма' c:n(10,2) e:getfield('t1','rs1->kpv','kgp','ngrpol') h:'Получатель' c:c(23) e:getfield('t1','rs1->kta','s_tag','fio') h:'Агент' c:c(8) e:docguid h:'Документ КПК' c:c(36) e:timecrt h:'Время КПК' c:c(19) e:kta h:'KTA' c:n(4) e:ktas h:'KTAS' c:n(4) e:tdc h:'ВрС' c:c(8) e:fc h:'Блок' c:n(1) e:getfield('t1','rs1->ttn,46','rs3','ssf') h:'Серт' c:n(10,2)", 'ttn',,,, forttnr,,, 1, 2)
                else
                  ttnr=slce('rs1', 1,, 18,, "e:ttn h:'ТТН' c:n(6) e:kop h:'КОП' c:n(3) e:prz h:'П' c:n(1) e:dfp h:'Дата ФП' c:d(8) e:ktofp h:'ФК' c:n(4) e:dop h:'Дата O' c:d(8) e:sdv h:'Сумма' c:n(10,2) e:getfield('t1','rs1->kpv','kln','nkl') h:'Получатель' c:c(23) e:getfield('t1','rs1->kta','s_tag','fio') h:'Агент' c:c(8) e:docguid h:'Документ КПК' c:c(36) e:timecrt h:'Время КПК' c:c(19) e:kta h:'KTA' c:n(4) e:ktas h:'KTAS' c:n(4) e:tdc h:'ВрС' c:c(8) e:fc h:'Блок' c:n(1) e:getfield('t1','rs1->ttn,46','rs3','ssf') h:'Серт' c:n(10,2)", 'ttn',,,, forttnr,,, 1, 2)
                endif

              endif

            endif

          else
            ttnr=slcf('rs1', 1,, 18,, "e:ttn h:'ТТН' c:n(6) e:kop h:'КОП' c:n(3) e:prz h:'П' c:n(1) e:dfp h:'Дата ФП' c:d(8) e:ktofp h:'ФК' c:n(4) e:dsp h:'Дата СФ' c:d(8) e:sdv h:'Сумма' c:n(10,2) e:getfield('t1','rs1->kpl','kln','nkl') h:'Плательщик' c:c(23) e:getfield('t1','rs1->kta','s_tag','fio') h:'Агент' c:c(8) e:kolosp h:'O' c:n(1)", 'ttn', 1,,, forttnr)
          endif

        endif

      case (TtnPrzr=1)    // Вып
        ttnr=slce('rs1', 1,, 18,, "e:ttn h:'ТТН' c:n(6) e:kop h:'КОП' c:n(3) e:prz h:'П' c:n(1) e:dfp h:'Дата ФП' c:d(8) e:dop h:'Дата O' c:d(8) e:sdv h:'Сумма' c:n(10,2) e:getfield('t1','rs1->kpv','kln','nkl') h:'Получатель' c:c(23) e:getfield('t1','rs1->kta','s_tag','fio') h:'Агент' c:c(8) e:docguid h:'Документ КПК' c:c(36) e:timecrt h:'Время КПК' c:c(19) e:kta h:'KTA' c:n(4) e:ktas h:'KTAS' c:n(4) e:tdc h:'ВрС' c:c(8)", 'ttn',,,, forttnr,,, 1, 2)
      //01-31-17 06:10pm ttnr=slcf('rs1',1,,18,,"e:ttn h:'ТТН' c:n(6) e:kop h:'КОП' c:n(3) e:kopi h:'КОП' c:n(3) e:prz h:'П' c:n(1) e:dvp h:'Дата В' c:d(8) e:dfp h:'Дата ФП' c:d(8) e:sdv h:'Сумма' c:n(10,2) e:getfield('t1','rs1->kpl','kln','nkl') h:'Плательщик' c:c(23) e:getfield('t1','rs1->kta','s_tag','fio') h:'Агент' c:c(4) e:kolosp h:'O' c:n(1) e:pr49 h:'П' c:n(1)",'ttn',,,,forttnr)
      case (TtnPrzr=2)    // ФП
        ttnr=slcf('rs1', 1,, 18,, "e:ttn h:'ТТН' c:n(6) e:kop h:'КОП' c:n(3) e:prz h:'П' c:n(1) e:dfp h:'Дата ФП' c:d(8) e:dsp h:'Дата СФ' c:d(8) e:sdv h:'Сумма' c:n(10,2) e:getfield('t1','rs1->kpl','kln','nkl') h:'Плательщик' c:c(23) e:getfield('t1','rs1->kta','s_tag','fio') h:'Агент' c:c(8) e:kolosp h:'O' c:n(1) e:pr49 h:'П' c:n(1)", 'ttn',,,, forttnr)
      case (TtnPrzr=3)    // СФ
        ttnr=slcf('rs1', 1,, 18,, "e:ttn h:'ТТН' c:n(6) e:kop h:'КОП' c:n(3) e:prz h:'П' c:n(1) e:dsp h:'Дата СФ' c:d(8) e:dop h:'Дата О' c:d(8) e:sdv h:'Сумма' c:n(10,2) e:getfield('t1','rs1->kpl','kln','nkl') h:'Плательщик' c:c(23) e:getfield('t1','rs1->kta','s_tag','fio') h:'Агент' c:c(8) e:kolosp h:'O' c:n(1) e:pr49 h:'П' c:n(1)", 'ttn',,,, forttnr)
      case (TtnPrzr=4)    // ТТНО
        ttnr=slcf('rs1', 1,, 18,, "e:ttn h:'ТТН' c:n(6) e:kop h:'КОП' c:n(3) e:prz h:'П' c:n(1) e:dop h:'Дата О' c:d(8) e:dot h:'Дата П' c:d(8) e:sdv h:'Сумма' c:n(10,2) e:getfield('t1','rs1->kpl','kln','nkl') h:'Плательщик' c:c(23) e:getfield('t1','rs1->kta','s_tag','fio') h:'Агент' c:c(8) e:kolosp h:'O' c:n(1) e:pr49 h:'П' c:n(1)", 'ttn',,,, forttnr)
      case (TtnPrzr=5)    // ТТНП
        ttnr=slcf('rs1', 1,, 18,, "e:ttn h:'ТТН' c:n(6) e:kop h:'КОП' c:n(3) e:prz h:'П' c:n(1) e:dot h:'Дата П' c:d(8) e:dvttn h:'Дата Вз' c:d(8) e:sdv h:'Сумма' c:n(10,2) e:getfield('t1','rs1->kpl','kln','nkl') h:'Плательщик' c:c(23) e:getfield('t1','rs1->kta','s_tag','fio') h:'Агент' c:c(8) e:kolosp h:'O' c:n(1) e:pr49 h:'П' c:n(1)", 'ttn',,,, forttnr)
      case (TtnPrzr=6)    // Вз
        ttnr=slcf('rs1', 1,, 18,, "e:ttn h:'ТТН' c:n(6) e:kop h:'КОП' c:n(3) e:prz h:'П' c:n(1) e:dvttn h:'Дата Вз' c:d(8) e:sdv h:'Сумма' c:n(10,2) e:getfield('t1','rs1->kpl','kln','nkl') h:'Плательщик' c:c(23) e:getfield('t1','rs1->kta','s_tag','fio') h:'Агент' c:c(8) e:kolosp h:'O' c:n(1) e:pr49 h:'П' c:n(1)", 'ttn',,,, forttnr)
      case (TtnPrzr=7)    // СетНеПол
        ttnr=slcf('rs1', 1,, 18,, "e:ttn h:'ТТН' c:n(6) e:kop h:'КОП' c:n(3) e:prz h:'П' c:n(1) e:dvp h:'Дата В' c:d(8) e:dot h:'Дата П' c:d(8) e:sdv h:'Сумма' c:n(10,2) e:getfield('t1','rs1->kpl','kln','nkl') h:'Плательщик' c:c(23) e:getfield('t1','rs1->kta','s_tag','fio') h:'Агент' c:c(8) e:kolosp h:'O' c:n(1) e:pr49 h:'П' c:n(1)", 'ttn',,,, forttnr)
      endcase

    case (gnVo=5.or.gnVo=4)
      if (gnVo=5.and.prlkr=0).or.gnVo=4
        ttnr=slcf('rs1', 1,, 18,, "e:ttn h:'ТТН' c:n(6) e:kop h:'КОП' c:n(3) e:prz h:'П' c:n(1) e:dvp h:'Дата В' c:d(8) e:skl h:'Скл.' c:n(7) e:sdv h:'Сумма' c:n(10,2) e:str(kpl,7)+' '+getfield('t1','rs1->kpl','bs','nbs') h:'Счет' c:c(20) e:getfield('t1','rs1->kps','kln','nkl') h:space(15) c:c(15)", 'ttn',,,, forttnr)
      else
        ttnr=slcf('rs1', 1,, 18,, "e:ttn h:'ТТН' c:n(6) e:kop h:'КОП' c:n(3) e:prz h:'П' c:n(1) e:dvp h:'Дата В' c:d(8) e:skl h:'Скл.' c:n(7) e:sdv h:'Сумма' c:n(10,2) e:str(kpl,7)+' '+getfield('t1','rs1->kpl','bs','nbs') h:'Счет' c:c(20) e:getfield('t1','rs1->kps','kln','nkl') h:'Автомобиль' c:c(15)", 'ttn',,,, forttnr)
      endif

    otherwise
      // +' '+getfield('t1','rs1->skt','cskl','nskl')
      ttnr=slcf('rs1', 1,, 18,, "e:ttn h:'ТТН' c:n(6) e:kop h:'КОП' c:n(3) e:prz h:'П' c:n(1) e:dot h:'Дата' c:d(8) e:str(rs1->skl,7)+' '+getfield('t1','rs1->skl','kln','nkl') h:'Источник' c:c(26) e:sdv h:'Сумма' c:n(10,2) e:str(rs1->skt,7) h:'Склад куда' c:c(10) e:amn h:'Приход' c:n(6)", 'ttn',,,, forttnr)
    endcase

    set cent on
    store 0 to kolospr, kolpspr
    sele rs1
    netseek('t1', 'ttnr',,, 1)
    kolospr=kolosp
    kolpspr=kolpsp
    docguidr=docguid
    nkklr=nkkl
    kpvr=kpv
    kplr=kpl
    kgpr=kgp
    dopr=dop
    kopr=kop
    vor=vo
    bsor=bso
    napr=nap
    ttn177r=ttn177
    pr177r=pr177
    ttn169r=ttn169
    pr169r=pr169
    if (fieldpos('mntov177')#0)
      mntov177r=mntov177
      prc177r=prc177
    else
      mntov177r=0
      prc177r=0
    endif

    if (fieldpos('ztxt')#0)
      ztxtr=ztxt
    else
      ztxtr=space(200)
    endif

    do case
    case (lastkey()=19.and.TtnKpkr=1)// Left
      fldnomr=fldnomr-1
      if (fldnomr=0)
        fldnomr=1
      endif

    case (lastkey()=4.and.TtnKpkr=1)// Right
      fldnomr=fldnomr+1
    case (lastkey()=K_F2)
      if (gnAdm=1.or.gnKto=160.or.gnKto=848)
        if (fieldpos('przzen')#0)
          if (rs1->przzen=0)
            netrepl('przzen', '1')
          else
            netrepl('przzen', '0')
          endif

        endif

      endif

    case (lastkey()=K_F3)
      clttnr=setcolor('gr+/b,n/bg')
      wttnr=wopen(5, 10, 20, 70)
      wbox(1)
      @ 0, 1 say 'Период    ' get ttndt1r
      @ 0, col()+1 get ttndt2r
      @ 1, 1 say 'Признак   ' get TtnPrzr pict '9'
      @ 1, col()+1 say '0Все;1Вып;2ФП;3СФ;4ТТНО;5ТТНП;6Вз;7СетНеПол'
      @ 2, 1 say 'Плательщик' get ttnkplr pict '9999999'
      @ 3, 1 say 'Товаровед ' get ttnktor pict '999'
      @ 4, 1 say 'Сумма не 0' get ttnsdvr pict '9'
      @ 5, 1 say 'КПК       ' get TtnKpkr pict '9'
      @ 6, 1 say 'Агент     ' get ttnktar pict '9999'
      @ 7, 1 say 'Непр.tmesto' get ttntmr pict '9'
      @ 8, 1 say 'Печ СФ КПК ' get TtnKpkpr pict '9'
      @ 9, 1 say 'Деб задолж ' get ttndzr pict '9'
      @ 10, 1 say 'БСО        ' get TtnBsor pict '9'
      @ 11, 1 say 'Акция      ' get ttnakcr pict '9'
      @ 12, 1 say 'Пр. акции  ' get ttnpr177r pict '9'
      @ 13, 1 say 'КОП        ' get kopucr pict '999'
      read
      if (lastkey()=K_ESC)
        wclose(wttnr)
        setcolor(clttnr)
        forttnr=forttn_r
        loop
      endif

      if (!empty(ttndt1r))
        if (empty(ttndt2r))
          forttnr=forttn_r+'.and.dvp=ttndt1r'
        else
          forttnr=forttn_r+'.and.dvp>=ttndt1r.and.dvp<=ttndt2r'
        endif

      endif

      do case
      case (TtnPrzr=0)    // Все
        forttnr=forttnr+'.and..t.'
      case (TtnPrzr=1)    // Вып
        forttnr=forttnr+'.and.empty(dfp)'
      case (TtnPrzr=2)    // ФП
        forttnr=forttnr+'.and.!empty(dfp).and.empty(dsp)'
      case (TtnPrzr=3)    // СФ
        forttnr=forttnr+'.and.!empty(dsp).and.empty(dop)'
      case (TtnPrzr=4)    // ТТНО
        forttnr=forttnr+'.and.!empty(dop).and.prz=0'
      case (TtnPrzr=5)    // ТТНП
        forttnr=forttnr+'.and.prz=1'
      case (TtnPrzr=6)    // Вз
        forttnr=forttnr+'.and.!empty(dvttn).and.prz=0'
      case (TtnPrzr=7)    // Сетевые не полученные
        sele rs1
        forttnr=forttnr+'.and.!empty(dsp).and.empty(dop).and.kolosp#kolpsp.and.kolosp#0'
      endcase

      if (ttnkplr#0)
        forttnr=forttnr+'.and.kpl=ttnkplr'
      endif

      if (ttnktor#0)
        forttnr=forttnr+'.and.kto=ttnktor'
      endif

      if (ttnsdvr#0)
        forttnr=forttnr+'.and.sdv#0'
      endif

      if (TtnKpkr#0)
        //              forttnr=forttnr+".and.(!empty(docguid).or.!empty(getfield('t1','rs1->ttnp','rs1','docguid')).or.!empty(getfield('t1','rs1->docid','rs1','docguid')))"
        //              if fieldpos('prkpk')#0
        //                 forttnr=forttnr+"and.rs1->prkpk=1"
      //              endif
      endif

      if (ttnktar#0)
        forttnr=forttnr+'.and.kta=ttnktar'
      endif

      if (ttntmr=1)
        forttnr=forttnr+".and.!netseek('t1','rs1->kta,rs1->tmesto','stagtm')"
      endif

      if (TtnKpkpr=1)
        forttnr=forttn_r+'.and.dvp>=ttndt1r.and.dvp<=ttndt2r.and.pvt=1.and.sdv#0'
        if (ttnktar#0)
          forttnr=forttnr+'.and.kta=ttnktar'
        endif

        if (TtnKpkr=1)
          forttnr=forttnr+".and.(!empty(docguid).or.!empty(getfield('t1','rs1->ttnp','rs1','docguid')))"
        endif

        forttnr=forttnr+'.and.!empty(dfp).and.empty(dop).and.prz=0'
      endif

      if (ttndzr=1)
        forttnr=forttnr+".and.getfield('t1','rs1->nkkl','edz','pdz4')>0"
      endif

      if (TtnBsor=1)
        forttnr=forttnr+".and.bso#0"
      endif

      if (ttnakcr=1)
        forttnr=forttnr+".and.kop=177"
        //              forttnr=forttnr+".and.kopi=177"
      //              forttnr=forttnr+".and.pr177=ttnpr177r"
      endif

      if (ttnakcr=0.and.ttnpr177r#0)
        forttnr=forttnr+".and.pr177=ttnpr177r"
      endif

      if (kopucr#0)
        forttnr=forttnr+".and.kop=kopucr"
      endif

      wclose(wttnr)
      setcolor(clttnr)
      sele rs1
      go top
      loop
    case (lastkey()=K_F4)
      vlpt=0
      sele sl
      go top
      while (!eof())
        ttnr=val(kod)
        sele rs1
        if (netseek('t1', 'ttnr',,, 1))
          pvtr=pvt
          kplr=kpl
          if (rs1->ktas#0)
            prExter=getfield('t1', 'rs1->ktas', 's_tag', 'prExte')
            if (prExter=2)
              if (kgpr#20034)
                if (!netseek('t1', 'kgpr', 'kgp'))
                  wmess('Нет грузополучателя в справочнике', 3)
                  loop
                endif

              endif

            endif

          endif

          if (!empty(docguid).or.!empty(getfield('t1', 'rs1->ttnp', 'rs1', 'docguid')))
            if (!dog(rs1->kpl))
              wmess('Проблемы с договором', 1)
              sele rs1
              skip
              loop
            endif

          endif

          vmrshr=getfield('t2', 'kplr', 'atvme', 'vmrsh')
          atrcr=getfield('t1', 'vmrshr', 'atvm', 'atrc')
          if (atrcr=0)
            sele sl
            skip
            loop
          endif

          ppsfr=ppsf
          gnVo=vo
          kopr=kop
          npvr=npv
          kpvr=kpv
          textr=text
          AtNomr=atnom
          pSTr=pst
          sklr=skl
          kplr=kpl
          kgpr=kgp
          kpvr=kpv
          bsor=bso
          dspr=dsp
          dotr=dot
          sktr=skt
          skltr=sklt
          ttnpr=ttnp
          ttncr=ttnc
          rtcenr=0
          ttn1cr=ttn1c
          nndsr=nnds
          sele soper
          netseek('t1', '0,1,gnVo,kopr-100')
          brprr=brpr
          if (brprr=1)
            sele setup
            locate for ent=gnEnt
            Nbankr=OB2
            Bankr=KB2
            Schtr=NS2
          endif

          sele soper
          zcr=zc
          nopr=nop
          tcenr=tcen
          coptr=alltrim(getfield('t1', 'tcenr', 'tcen', 'zen'))
          sele rs1
          dvpr=dvp
          dopr=dop
          ktar=kta
          ktor=kto
          pprr=ppr
          if (fieldpos('kolpos')#0)
            kolposr=kolpos
          else
            kolposr=0
          endif

          fktor=alltrim(getfield('t1', 'ktor', 'speng', 'fio'))
          symklr=''
          symkl=0
          skr=gnSk
          rsprn(2, 1)     // Сетевая печать,1 экз
                            //                 rsprn(2,2) // Сетевая печать,2 экз
        endif

        sele sl
        skip
      enddo

      set prin off
      set prin to
      set cons on
      loop

    case (lastkey()=K_F5.and.(gnRfp=1.or.gnAdm=1)) // ФП
      prnppr=0
      dfpr=date()
      tfpr=time()
      if (bsor#0.and.!(kopr=169.or.kopr=151))

        dolr:=klnlic->(DtLic(kplr, kgpr, 2)) // 2 - лицензия алкоголь
        Do Case
        Case Empty(dolr)
          wmess('Нет лицензии', 2)
          loop
        Case (dolr<date())
          wmess('Лицензия закончилась '+dtoc(dolr), 2)
          loop
        EndCase
        /*
        sele klnlic
        if (!netseek('t1', 'kplr,kgpr'))
          wmess('Нет лицензии', 2)
          loop
        else
          dolr=dol
          while (kkl=kplr.and.kgp=kgpr)
            if (lic#2)
              skip
              loop
            endif

            if (dol>dolr)
              dolr=dol
            endif

            sele klnlic
            skip
          enddo

          if (dolr<date())
            wmess('Лицензия закончилась '+dtoc(dolr), 2)
            loop
          endif

        endif
        */

      endif

      sele rs1
      if (gnEnt=20 .or. gnEnt=21)
        prfp_rr=1
        ktar=kta
        ktasr=ktas
        kopr=kop
        kplr=kpl
        kgpr=kgp
        if (kplr=0.or.kgpr=0)
          wmess('Плат или плуч =0', 2)
          prfp_rr=0
        else
          if (ktar#0)
            sele s_tag
            if (!netseek('t1', 'ktar'))
              wmess('Агента нет в справочнике', 2)
              ktar=0
            else
              if (ktas=0)
                wmess('Супервайзер =0', 2)
                ktar=0
              else
                ktasr=ktas
              endif

            endif

          endif

          if (ktar=0)
            prfp_rr=0
          else
            if (ktasr=0)
              ktasr=getfield('t1', 'ktar', 's_tag', 'ktas')
            endif

            exter=exte(ktar)
            if (vor=9.and.(kopr=160.or.kopr=161.or.kopr=169.or.kopr=177))
              kplr=ChkKpl()
              if (kplr=0)
                prfp_rr=0
              else
                kgpr=ChkKgp()
                if (kgpr=0)
                  prfp_rr=0
                endif

              endif

            endif

          endif

        endif

      endif

      if !(gnEnt=20)

        prfp_rr=1
        if (rs1->ktas#0)
          prExter=getfield('t1', 'rs1->ktas', 's_tag', 'prExte')
          if (prExter=2.and.gnVo=9)
            if (kgpr#20034)
              if (!netseek('t1', 'kgpr', 'kgp'))
                wmess('Нет грузополучателя в справочнике', 3)
                loop
              endif

            endif

          endif

        endif

        if (!empty(docguid).or.!empty(getfield('t1', 'rs1->ttnp', 'rs1', 'docguid')))
          prfp_rr=0
          if (!dog(kplr))
            wmess('Проблемы с договором', 1)
          else
            if (!kgprm(kpvr))
              wmess('Грузополучатель не этого региона', 1)
            else
              if (prExter=0)
                if (tmesto=0)
                  tmestor=getfield('t2', 'nkklr,kpvr', 'tmesto', 'tmesto')
                  netrepl('tmesto', 'tmestor')
                endif

                if (tmesto#0)
                  if (!netseek('t1', 'rs1->kta,rs1->tmesto', 'stagtm'))
                    prfp_rr=0
                  else
                    prfp_rr=1
                  endif

                endif

              else
                prfp_rr=1
              endif

              if (prExter=1)
                if (prfp_rr=0)
                  ach:={ 'Нет', 'Да' }
                  achr=0
                  achr=alert('Нет привязки торгового места.Продолжить?', ach)
                  if (achr=2)
                    prfp_rr=1
                  endif

                endif

              else
                if (ktasr=556)
                  prfp_rr=0
                  wmess('Нет привязки торгового места '+str(ktasr, 4), 2)
                endif

              endif

            endif

          endif

        endif

        if (gnEnt=21)
          if (!ChkLic())
            prfp_rr=0
          endif

        endif

        if (prfp_rr=1)
          if (gnEnt=20.and.kplr#0.and.pr361r=1.and.!(kopr=169.or.kopr=168).and.gnVo=9)
            prfp_rr=0
            codelistr=getfield('t1', 'kplr', 'kpl', 'codelist')
            if (!empty(codelistr))
              ckopr=str(kopr, 3)
              if (at(ckopr, codelistr)=0)
                if (kopr#177)
                  wmess('Недопустимый код операции', 1)
                  prfp_rr=0
                else
                  prfp_rr=1
                endif

              else
                prfp_rr=1
              endif

            else
              wmess('Нет привяз кодов опер', 1)
              prfp_rr=0
            endif

          endif

        endif

      endif

      sele rs1
      if (prfp_rr=1)
        if (empty(dfp).and.!docblk())
          sele rs1
          netrepl('dfp,tfp,ktofp', 'dfpr,tfpr,gnKto')
          rso(23)
        else
          edtr=ctod('')
          etmr=space(8)
          sele rs1
          netrepl('dfp,tfp,ktofp', 'edtr,etmr,gnKto')
          rso(22)
        endif

      endif

      loop
    case (lastkey()=K_F6) // Дата модификации
      netrepl('dtmod,tmmod', 'date(),time()')

    case (lastkey()=K_F7.and.kopr=177; // Признак в общую 7
      .and.str(gnEnt,3)$' 20; 21';
      .and.(gnAdm=1 .or. str(gnKto,3)$' 28; 71;160;217;786'))

      if (select('ttrs2')=0)
        crtt('ttrs2', 'f:ktl c:n(9) f:kvp c:n(12,3)')
        sele 0
        use ttrs2
      endif

      sele rs1
      if (fieldpos('pr177')#0)
        if (pr177=0)
          netrepl('pr177', '1')
          sele rs2
          if (netseek('t1', 'ttnr'))
            while (ttn=ttnr)
              ktlr=ktl
              kvpr=kvp
              sele ttrs2
              locate for ktl=ktlr
              if (!foun())
                netadd()
                netrepl('ktl', 'ktlr')
              endif

              netrepl('kvp', 'kvp+kvpr')
              sele rs2
              skip
            enddo

            //                    coun to a while ttn=ttnr
          //                    kol177r=kol177r+a
          endif

        else
          netrepl('pr177', '0')
          sele rs2
          if (netseek('t1', 'ttnr'))
            while (ttn=ttnr)
              ktlr=ktl
              kvpr=kvp
              sele ttrs2
              locate for ktl=ktlr
              if (!foun())
                netadd()
                netrepl('ktl', 'ktlr')
              endif

              netrepl('kvp', 'kvp-kvpr')
              sele rs2
              skip
            enddo

            //                    coun to a while ttn=ttnr
          //                    kol177r=kol177r-a
          endif

        endif

        sele ttrs2
        go top
        coun to kol177r for kvp#0
        @ 23, 70 say str(kol177r, 9)
        sele rs1
        netrepl('dtmod,tmmod', 'date(),time()')
      endif

    case (lastkey()=K_ALT_F7 ; // Создать общую
      .and.str(gnEnt,3)$' 20; 21';
      .and.(gnAdm=1 .or. str(gnKto,3)$' 28; 71;160;217;786'))

      if (select('ttrs2')#0)
        sele ttrs2
        CLOSE
      endif

      ttn177()
      ttnr=ttn177r
      forttnr='.t.'
      sele rs2
      if (netseek('t1', 'ttnr'))
        while (ttn=ttnr)
          svpr=roun(kvp*zen, 2)
          netrepl('svp', 'svpr')
          sele rs2
          skip
        enddo

      endif

      sele rs1
      netseek('t1', 'ttnr')
      kol177r=0
      @ 23, 70 say str(kol177r, 9)
    case (lastkey()=K_F8) // ДЗ
      dztv(1)
    case (lastkey()=K_ESC)
      exit
    case (lastkey()=K_F9) // Сертификаты
                            //           ttnsert()
    case (lastkey()=K_F10)// ztxt
      ztxt()
    case (lastkey()=K_ENTER)
      nRecStartView:=RECNO()
      exit
    endcase

  enddo

  sele rs1
  set key 32 to ttn
  @24, 0 clea to 24, 79
  set key 32 to ttn
  return (.t.)

/************** */
function entp()
  /************** */
  if (entpr=gnEnt)
    entpr=0
  endif

  sele menent
  if (entpr#0)
    locate for ent=entpr.and.comm=0
  endif

  if (!foun())
    entpr=0
    nentpr=''
    direpr=''
    pathepr=''
  endif

  if (entpr=0)
    go top
    rcentpr=slcf('menent', 10, 10,,, "e:ent h:'Код' c:n(2) e:uss h:'Наименование' c:c(30)",,,,, 'ent#gnEnt.and.comm=0',, 'Предприятия')
    sele menent
    go rcentpr
    entpr=ent
    nentpr=uss
    direpr=alltrim(nent)+'\'
    if (comm=0)
      pathemr=gcPath_ini
    else
      pathemr=gcPath_ini+direpr
    endif

    pathepr=pathemr+direpr
    pathecr=pathemr+gcDir_c
  endif

  @ 5, 1 say 'Предприятие: '+ ' '+str(entpr, 3)+' '+nentpr
  return (.t.)

/************** */
function sktp()
  /************** */
  sele 0
  pathr=pathecr
  /*use (pathecr+'cskl') alias ecskl */
  netuse('cskl', 'ecskl',, 1)
  go top
  rcsktpr=slcf('ecskl', 10, 10,,, "e:sk h:'Код' c:n(3) e:nskl h:'Наименование' c:c(30)",,,,, 'ent=entpr.and.ctov=1',, 'Склад')
  sele ecskl
  go rcsktpr
  sktpr=sk
  nsktpr=nskl
  nuse('ecskl')
  @ 6, 1 say 'Склад:       '+' '+str(sktpr, 3)+' '+nsktpr
  return (.t.)

/*********** */
function otn()
  /*********** */
  sele cskle
  if (netseek('t1', 'gnSk'))
    while (sk=gnSk)
      rccskler=recn()
      arec:={}
      getrec()
      otr=ot
      if (!netseek('t1', 'sktr,otr'))
        netadd()
        putrec()
        netrepl('sk', 'sktr')
      endif

      go rccskler
      skip
    enddo

  endif

  if (!netseek('t1', 'sktr,otnr').or.otnr=0)
    while (.t.)
      rccskler=slcf('cskle',,, 10,, "e:sk h:'SK' c:n(3) e:ot h:'ОТ' c:n(2) e:nai h:'Наименование' c:c(20)",,,,, 'sk=sktr',, 'Отдел-назначение')
      if (lastkey()=K_ESC)
        exit
      endif

      go rccskler
      otnr=ot
      notnr=nai
      do case
      case (lastkey()=K_ENTER)
        @ 6, 1 say 'Отдел     : '+' '+str(otnr, 2)+' '+notnr
        exit
      endcase

    enddo

  else
    notnr=nai
    @ 6, 1 say 'Отдел     : '+' '+str(otnr, 2)+' '+notnr
  endif

  return (.t.)

/*********** */
function kgn()
  /*********** */
  sele cgrp
  if (!netseek('t1', 'kgnr').or.kgnr=0)
    while (.t.)
      rccgrpr=slcf('cgrp',,, 10,, "e:kgr h:'Код' c:n(3) e:ngr h:'Наименование' c:c(20)",,,,,,, 'Группа-назначение')
      if (lastkey()=K_ESC)
        exit
      endif

      go rccgrpr
      kgnr=kgr
      if (kgnr=0)
        ngnr='Та же'
      else
        ngnr=ngr
      endif

      do case
      case (lastkey()=K_ENTER)
        @ 7, 1 say 'Группа    : '+' '+str(kgnr, 3)+' '+ngnr
        exit
      endcase

    enddo

  else
    ngnr=ngr
    @ 7, 1 say 'Группа    : '+' '+str(kgnr, 3)+' '+ngnr
  endif

  return (.t.)

/************ */
function otnp()
  /************ */
  sele cskle
  if (netseek('t1', 'gnSk'))
    while (sk=gnSk)
      rccskler=recn()
      arec:={}
      getrec()
      otr=ot
      if (!netseek('t1', 'sktpr,otr'))
        netadd()
        putrec()
        netrepl('sk', 'sktpr')
      endif

      go rccskler
      skip
    enddo

  endif

  if (!netseek('t1', 'sktpr,otnr').or.otnr=0)
    while (.t.)
      rccskler=slcf('cskle',,, 10,, "e:sk h:'SK' c:n(3) e:ot h:'ОТ' c:n(2) e:nai h:'Наименование' c:c(20)",,,,, 'sk=sktpr',, 'Отдел-назначение')
      if (lastkey()=K_ESC)
        exit
      endif

      go rccskler
      otnr=ot
      notnr=nai
      do case
      case (lastkey()=K_ENTER)
        @ 7, 1 say 'Отдел:'+' '+str(otnr, 2)+' '+subs(notnr, 1, 10)
        exit
      endcase

    enddo

  else
    notnr=nai
    @ 7, 1 say 'Отдел:'+' '+str(otnr, 2)+' '+subs(notnr, 1, 10)
  endif

  return (.t.)

/************* */
function kgnp()
  /************* */
  pathr=pathepr
  sele 0
  netuse('cgrp', 'cgrpp',, 1)
  if (!netseek('t1', 'kgnr').or.kgnr=0)
    rccgrpr=slcf('cgrpp',,, 10,, "e:kgr h:'Код' c:n(3) e:ngr h:'Наименование' c:c(20)",,,,,,, 'Группа-назначение')
    go rccgrpr
    kgnr=kgr
    if (kgnr=0)
      ngnr='Та же'
    else
      ngnr=ngr
    endif

    @ 7, 22 say 'Группа    : '+' '+str(kgnr, 3)+' '+ngnr
  else
    ngnr=ngr
    @ 7, 22 say 'Группа    : '+' '+str(kgnr, 3)+' '+ngnr
  endif

  nuse('cgrpp')
  return (.t.)

/************** */
function kpladd()
  /************** */
  if (gnVo=9)
    if (nkklr#20034.and.nkklr#0)
      if (gnRmsk#0)
        sele kpl
        if (!netseek('t1', 'nkklr'))
          crmskr=stuff(space(9), gnRmsk, 1, '1')
          netadd()
          netrepl('kpl,crmsk', 'nkklr,crmskr')
          netrepl('dtkpl', 'date()')
        else
          crmskr=crmsk
          crmskr=stuff(crmskr, gnRmsk, 1, '1')
          netrepl('crmsk', 'crmskr')
        endif

      else
        vmrshr=getfield('t1', 'nkklr', 'kln', 'vmrsh')
        if (vmrshr#0)
          atrc_r=getfield('t1', 'vmrshr', 'atvm', 'atrc')
          if (atrc_r#0)
            if (atrc_r=1)
              rm_r=2
            endif

            if (atrc_r=2)
              rm_r=1
            endif

            sele kpl
            if (!netseek('t1', 'nkklr'))
              crmskr=stuff(space(9), rm_r, 1, '1')
              netadd()
              netrepl('kpl,crmsk', 'nkklr,crmskr')
              netrepl('dtkpl', 'date()')
            else
              crmskr=crmsk
              crmskr=stuff(crmskr, rm_r, 1, '1')
              netrepl('crmsk', 'crmskr')
            endif

          endif

        endif

      endif

    endif

  endif

  return (.t.)

/************** */
function kgpadd()
  /************** */
  if (gnVo=9)
    if (kpvr#20034.and.kpvr#0)
      sele kgp
      if (!netseek('t1', 'kpvr'))
        netadd()
        netrepl('kgp', 'kpvr')
        netrepl('dtkgp', 'date()')
      endif

    endif

  endif

  return (.t.)

/********************** */
function ttnprov(p1, p2, p3)
  /********************** */
  // p1 sk
  // p2 ttn
  // p3 0 - dokk; 1 - dokko
  sk_rr=p1
  ttn_rr=p2
  fordocr='sk=sk_rr.and.rn=ttn_rr.and.mnp=0'
  whldocr='sk=sk_rr.and.rn=ttn_rr.and.mnp=0'
  while (.t.)
    foot('ENTER', 'PROV')
    if (!nettag('dokk', 't13'))
      if (p3=0)
        sele dokk
        go top
        rcdokkr=slcf('dokk', 4,, 8,, "e:bs_d h:'Дб' c:n(6) e:bs_k h:'Кр' c:n(6) e:bs_s h:'Сумма' c:n(10,2) e:ddk h:'Дата' c:d(10) e:ksz h:'Сз' c:n(2) e:nap h:'Напр' c:n(4)",,,,, fordocr,, 'DOKK')
      else
        sele dokko
        go top
        rcdokkor=slcf('dokko', 4,, 8,, "e:bs_d h:'Дб' c:n(6) e:bs_k h:'Кр' c:n(6) e:bs_s h:'Сумма' c:n(10,2) e:ddk h:'Дата' c:d(10) e:ksz h:'Сз' c:n(2) e:nap h:'Напр' c:n(4)",,,,, fordocr,, 'DOKKO')
      endif

    else
      if (p3=0)
        sele dokk
        set orde to tag t13
        netseek('t13', 'sk_rr,ttn_rr,0')
        rcdokkr=slcf('dokk', 4,, 8,, "e:bs_d h:'Дб' c:n(6) e:bs_k h:'Кр' c:n(6) e:bs_s h:'Сумма' c:n(10,2) e:ddk h:'Дата' c:d(10) e:ksz h:'Сз' c:n(2) e:nap h:'Напр' c:n(4) e:nnds h:'НДС' c:n(10) e:nndsvz h:'НДСВЗ' c:n(10) e:dnnvz h:'ДНДСВЗ' c:d(10)",,,, whldocr,,, 'DOKK')
      else
        sele dokko
        set orde to tag t13
        netseek('t13', 'sk_rr,ttn_rr,0')
        rcdokkor=slcf('dokko', 4,, 8,, "e:bs_d h:'Дб' c:n(6) e:bs_k h:'Кр' c:n(6) e:bs_s h:'Сумма' c:n(10,2) e:ddk h:'Дата' c:d(10) e:ksz h:'Сз' c:n(2) e:nap h:'Напр' c:n(4)",,,, whldocr,,, 'DOKKO')
      endif

      set orde to tag t1
    endif

    do case
    case (lastkey()=K_ESC)
      exit
    case (lastkey()=K_ENTER.and.!empty(dopr))
      if (przr=1)
        rsprv(2, 0)
        rsprv(1, 0)
      else
        rsprv(2, 1)
        rsprv(1, 1)
      endif

    endcase

  enddo

  keyboard ''
  return (.t.)

/*************** */
function ttnsert()
  /*************** */
  if (empty(dopr).and.gnEnt=20)
    qr=mod(kopr, 100)
    store 0 to onofr, opbzenr, opxzenr, ;
     otcenpr, otcenbr, otcenxr,         ;
     odecpr, odecbr, odecxr
    inikop(gnD0k1, gnVu, gnVo, qr)
    sele rs3
    if (!netseek('t1', 'ttnr,46'))
      netadd()
      netrepl('ttn,ksz', 'ttnr,46')
    endif

    if (ssf#0)
      netrepl('ssf,bssf,xssf', '0,0,0')
    else
      netrepl('ssf,bssf,xssf', '0.30,0.30,0.30')
    endif

    pere(3)
  endif

  return (.t.)

/********************** */
function prprov(p1, p2, p3)
  /********************** */
  // p1 sk
  // p2 nd
  // p3 mn
  sk_rr=p1
  nd_rr=p2
  mnp_rr=p3
  fordocr='sk=sk_rr.and.rn=nd_rr.and.mnp=mnp_rr'
  whldocr='sk=sk_rr.and.rn=nd_rr.and.mnp=mnp_rr'
  while (.t.)
    foot('ENTER', 'PROV')
    if (!nettag('dokk', 't13'))
      sele dokk
      go top
      rcdokkr=slcf('dokk', 4,, 8,, "e:bs_d h:'Дб' c:n(6) e:bs_k h:'Кр' c:n(6) e:bs_s h:'Сумма' c:n(10,2) e:ddk h:'Дата' c:d(10) e:ksz h:'Сз' c:n(2)",,,,, fordocr,, 'DOKK')
    else
      sele dokk
      set orde to tag t13
      netseek('t13', 'sk_rr,nd_rr,mnp_rr')
      rcdokkr=slcf('dokk', 4,, 8,, "e:bs_d h:'Дб' c:n(6) e:bs_k h:'Кр' c:n(6) e:bs_s h:'Сумма' c:n(10,2) e:ddk h:'Дата' c:d(10) e:ksz h:'Сз' c:n(2) e:nnds h:'НН' c:n(10) e:nndsvz h:'ННВЗ' c:n(10)",,,, whldocr,,, 'DOKK')
      set orde to tag t1
    endif

    do case
    case (lastkey()=K_ESC)
      exit
    case (lastkey()=K_ENTER.and.przr=1)//.and.gnAdm=1
      prprv(2)
      prprv(1)
    endcase

  enddo

  keyboard ''
  return (.t.)

/************* */
function dztv(p1)
  /************* */
  local lAccDeb

  if (.t.)                //gnEnt=20
    if (file(gcPath_ew+"deb\accord_deb"+".dbf"))
      netuse('dkkln')
      use (gcPath_ew+"deb\accord_deb") ALIAS skdoc NEW SHARED READONLY
      SET ORDER to TAG t1
      lAccDeb:=.T.
    endif

    skdoc->(dbseek(str(rs1->nkkl, 7)))

    sele skdoc
    index on ngp+nkta+DTOS(dtopl) to tmpskdoc while rs1->nkkl=kpl
    DBGoTop()

    skdoc->(slcf('skdoc', 4, 1, MAXROW()-8,,             ;
                   "e:ngp h:'Получатель' c:c(23)"          ;
                   +" e:nkta h:'Агент' c:c(5)"             ;
                   +" e:nnap h:'Напр' c:c(4)"              ;
                   +" e:ttn h:'ТТН' c:n(6)"                ;
                   +" e:sdp h:'СуммЗадол' c:n(8,2)"        ;
                   +" e:dtopl h:'ДатаОплаты' c:d(8)"       ;
                   +" e:(dtopl-date()) h:'СрокОпл' c:n(4)" ;
                   ,,,, 'rs1->nkkl=kpl',,, npl             ;
                )                                         ;
          )

    if (lAccDeb)
      close skdoc
    endif

  else
    if (p1=1)
      pathr=gcPath_ew+'deb\s361001\'
    else
      pathr=gcPath_ew+'deb\s361002\'
    endif

    if (file(pathr+'pdeb.dbf'))
      adirect=directory(pathr+'pdeb.dbf')
      dtcr=adirect[ 1, 3 ]
      tmcr=adirect[ 1, 4 ]
      sele 0
      use (pathr+'pdeb') shared
#ifdef nkklr
        locate for kkl=nkklr
#else
        locate for kkl=kplr
#endif
      if (foun())
        dzr=dz
        pdzr=pdz
        pdz1r=pdz1
        pdz3r=pdz3
        pdz4r=pdz4
        CLOSE
        cldzr=setcolor('gr+/b,n/bg')
        wdzr=wopen(8, 20, 17, 60)
        wbox(1)
        if (p1=1)
          @ 0, 1 say '361001'
        else
          @ 0, 1 say '361002'
        endif

        @ 1, 1 say 'Дата'+' '+dtoc(dtcr)+' Время '+tmcr color 'r+/b'
        @ 2, 1 say 'Деб задолж    '+' '+str(dzr, 10, 2)
        @ 3, 1 say 'Деб задолж >7 '+' '+str(pdzr, 10, 2)
        @ 4, 1 say 'Деб задолж >14'+' '+str(pdz1r, 10, 2)
        @ 5, 1 say 'Деб задолж >21'+' '+str(pdz3r, 10, 2)
        @ 6, 1 say 'Деб задолж >30'+' '+str(pdz4r, 10, 2)
        inkey(0)
        wclose(wdzr)
        setcolor(cldzr)
      else
        sele pdeb
        CLOSE
      endif

    endif

  endif

RETURN (NIL)

/*************** */
function PrnPrRs()
  /***************
   *wait
   */
  vzz=1
  lnn=48
  lstr=1
  rswr=1
  PrVzShap()
  sele pr2
  set orde to tag t3
  netseek('t3', 'mnr')
  kolpos_r=0
  ssf10r=0
  ssf11r=0
  ssf90r=0
  svesr=0
  while (mn=mnr)
    ktlr=ktl
    ktlpr=ktlp
    pptr=ppt
    mntovr=mntov
    kfr=kf
    zenr=ozen
    optr=zen
    sfr=roun(zenr*kfr, 2)
    ssf10r=ssf10r+sfr
    sele ctov
    netseek('t1', 'mntovr')
    nat_r=alltrim(nat)
    neir=nei
    sele tov
    netseek('t1', 'sklr,ktlr')
    k1tr=k1t
    vespr=vesp
    upakr=upak
    vesr=ves
    lnat_r=len(nat_r)
    if (lnat_r<lnn)       //50
      nat_r=nat_r+space(lnn-lnat_r)
      svesr=svesr+ROUND(kfr*vesr, 3)
      ?str(ktlr, 9)+' '+nat_r+' '+subs(neir, 1, 4)+' '+str(kfr, 10, 3)+' '+str(zenr, 9, 3)+' '+iif(sfr<10000000, str(sfr, 9, 2), str(sfr, 12, 2))
      kolpos_r=kolpos_r+1
      RsVzE()
    else
      store '' to xxx, yyy
      for i=lnat_r to 1 step -1
        yyy=right(nat_r, lnat_r-i)
        xxx=subs(nat_r, 1, i)
        if (i<lnn.and.subs(nat_r, i, 1)=' ')
          exit
        endif

      next

      if (len(xxx)<lnn)
        xxx=xxx+space(lnn-len(xxx))
      endif

      ?str(ktlr, 9)+' '+xxx+' '+subs(neir, 1, 4)+' '+str(kfr, 10, 3)+' '+str(zenr, 9, 3)+' '+iif(sfr<10000000, str(sfr, 9, 2), str(sfr, 12, 2))
      kolpos_r=kolpos_r+1
      RsVzE()
      ?space(9)+' '+yyy
      RsVzE()
    endif

    sele pr2
    skip
  enddo

  if (ttnvzr#0)
    ssf90r=ssf10r*(100+gnNds)/100
    ssf11r=ssf90r-ssf10r
  else
    ssf90r=ssf10r
    ssf11r=0
  endif

  nszr=getfield('t1', '10', 'dclr', 'nz')
  ?space(51)+str(10, 2)+'-'+nszr+':'+' '+str(0, 5, 2)+space(3)+iif(ssf10r<10000000, str(ssf10r, 10, 2), str(ss10r, 12, 2))
  RsVzE()
  if (ttnvzr#0)
    nszr=getfield('t1', '11', 'dclr', 'nz')
    ?space(51)+str(11, 2)+'-'+nszr+':'+' '+str(0, 5, 2)+space(3)+iif(ssf11r<10000000, str(ssf11r, 10, 2), str(ss11r, 12, 2))
    RsVzE()
  endif

  /*nszr=getfield('t1','90','dclr','nz')
   *?space(51)+str(90,2)+'-'+nszr+':'+' '+str(0,5,2)+space(3)+iif(ssf90r<10000000,str(ssf90r,10,2),str(ss90r,12,2))
   *RsVzE()
   */

  ?'Позиций '+'     '+str(kolpos_r, 3)+space(35)+'Итого по документу  '+space(8)+str(ssf90r, 15, 2)//+' грн.'
  RsVzE()
  for i=1 to 43-rswr-6
    ?''
  endfor

  ?'Отпуск подтвердил     ___________       '+'           г.'+ '          Оператор  ___________ '
  ?'Груз к перевозке принял  ___________                           Груз получил ____________'
  ?repl('-', 94)
  eject
  return (.t.)

/*************** */
function PrVzShap()
  /*************** */
  kbr=getfield('t1', 'kpsr', 'kln', 'kb1')
  rschr=getfield('t1', 'kpsr', 'kln', 'ns1')
  kkl1r=getfield('t1', 'kpsr', 'kln', 'kkl1')
  nklr=getfield('t1', 'kpsr', 'kln', 'nkl')
  adrr=alltrim(getfield('t1', 'kpsr', 'kln', 'adr'))

  kzg_kbr=getfield('t1', 'kzgr', 'kln', 'kb1')
  kzg_rschr=getfield('t1', 'kzgr', 'kln', 'ns1')
  kzg_kkl1r=getfield('t1', 'kzgr', 'kln', 'kkl1')
  kzg_nklr=getfield('t1', 'kzgr', 'kln', 'nkl')
  kzg_adrr=alltrim(getfield('t1', 'kzgr', 'kln', 'adr'))

  ?'Товаро-транспортная накладная N '+str(mnr, 6); RsVzE()

  aaa=allt('Поставщик: '+str(kpsr, 7)+' '+alltrim(nklr)+' '+str(kkl1r, 10)+' '+adrr)
  if (len(aaa)<80)
    ?aaa; RsVzE()
  else
    ?subs(aaa, 1, 79); RsVzE(); ?subs(aaa, 80); RsVzE()
  endif

  if (!empty(kbr))
    ?alltrim(getfield('t1', 'kbr', 'banks', 'otb'))+' МФО '+alltrim(kbr)+' р/с '+alltrim(rschr)
    RsVzE()
  endif

  aaa:=allt('Место отгрузки: '+str(kzgr, 7)+' '+alltrim(kzg_nklr)+' '+str(kzg_kkl1r, 10)+' '+kzg_adrr)
  if (len(aaa)<80)
    ?aaa; RsVzE()
  else
    ?subs(aaa, 1, 79); RsVzE(); ?subs(aaa, 80); RsVzE()
  endif

  ?; RsVzE()

  RsVzE()
  aaa='Плательщик: '+alltrim(gcName_c)+' код  '+str(gnKln_c, 8)+' тел '+alltrim(getfield('t1', 'gnKkl_c', 'kln', 'tlf'))+' '+alltrim(getfield('t1', 'gnKkl_c', 'kln', 'adr'))
  if (len(aaa)<80)
    ?aaa
    RsVzE()
  else
    ?subs(aaa, 1, 79)
    RsVzE()
    ?subs(aaa, 80)
    RsVzE()
  endif

  ?alltrim(gcOb1_c)+' МФО-'+Right(gnKb1_c, 6)+' р/с-'+gcNs1_c//+' р/с НДС -'+gcNs1nds_c
  RsVzE()
  ?'Получатель: он же'
  RsVzE()
  ?'Код опеpации - '+str(kopr, 3)+' '+nopr
  RsVzE()
  ?'Маршрут '+str(mrshr, 6)+'       '+'                                                                   Лист '+str(lstr, 1)
  RsVzE()
  ?repl('-', 94)
  RsVzE()
  ?'| Код  |                 Наименование                     |Наим|    Фактически отпущено      |'
  RsVzE()
  ?'|      |                                                  |енов|-----------------------------|'
  RsVzE()
  ?'| М.ц  |                                                  |ед.и| К - во  |  Цена   |  Сумма  |'
  RsVzE()
  ?repl('-', 94)
  RsVzE()
  return (.t.)

/************* */
function RsVzE(p1)
  /************* */
  rswr++
  rsw_r=42
  if (rswr>=rsw_r)
    rswr=1
    lstr++
    eject
    if (p1=nil)
      PrVzShap()
    endif

  endif

  return (.t.)

/********************************************* */
function ttn177()
  // Создать из отмеченных (pr177) общую ТТН
  /********************************************* */
  sele rs1
  set filt to
  go top
  prttn177r=0
  while (!eof())
    if (pr177#1)
      skip
      loop
    endif

    if (kop#177)
      skip
      loop
    endif

    if (ttn177#0)
      skip
      loop
    endif

    ttn_r=ttn
    sele rs2
    if (!netseek('t1', 'ttn_r'))
      sele rs1
      skip
      loop
    else
      prttn177r=1
      exit
    endif

    sele rs1
    skip
  enddo

  if (prttn177r=0)
    wmess('Нет ТТН для объединения,3')
    return (.t.)
  endif

  sele cskl
  netseek('t1', 'gnSk',,, 1)//  locate for sk=gnSk
  NextNumTtn('ttn177r')

  /*
  sele cskl
  locate for sk=gnSk
  if (foun())
    reclock()
    ttn177r=ttn
    if (ttn177r=999999)
      ttn177r=1
    endif

    sele rs1
    set filt to
    while (.t.)
      if (!netseek('t1', 'ttn177r'))
        exit
      endif

      ttn177r=ttn177r+1
      if (ttn177r=999999)
        ttn177r=1
      endif

    enddo
  else
    return
  endif
    */

  sele rs1
  locate for pr177=1.and.kop=177
  if (foun())
    arec:={}
    getrec()
    netadd()
    putrec()
    docguidr=''
    netrepl("ttn,kop,kopi,kpl,nkkl,kgp,kpv,ttn177,pr177,prz,vo,docguid,kto,ddc,tdc,dfp,dop,dvp",                    ;
              {ttn177r,169,169,20034,20034,20034,20034,0,2,0,9,docguidr,gnKto,date(),time(),ctod(''),ctod(''),date()} ;
           )

    if (gnEnt=20)
      if (gnEntRm=0)
        netrepl('kta,ktas,kgp,kpv', {51,51,22012,22012})
      else
        netrepl('kta,ktas,kgp,kpv', {51,51,22044,22044})
      endif

    endif

    netrepl('dtmod,tmmod', {date(),time()})
    if (fieldpos('mntov177')#0)
      MnTov177r:=mntov177r(gnEnt)
      Prc177r:=getfield('t1', 'mntov177r', 'ctov', 'cenpr')
      netrepl('mntov177,prc177', {mntov177r,Prc177r})
    endif

    dir_r=gcPath_m177+subs(gcDir_t, 1, len(gcDir_t)-1)
    if (dirchange(dir_r)#0)
      dirmake(dir_r)
    endif

    dir_r=gcPath_m177+gcDir_t+'t'+alltrim(str(ttn177r))
    if (dirchange(dir_r)#0)
      dirmake(dir_r)
    endif

    pathttn177r=gcPath_m177+gcDir_t+'t'+alltrim(str(ttn177r))+'\'
    pathr=pathttn177r
    if (!netfile('rs1', 1))
      copy file (gcPath_a+'rs1.dbf') to (pathttn177r+'trsho14.dbf')
      lindx('trsho14', 'rs1', 1)
    endif

    if (!netfile('rs2', 1))
      copy file (gcPath_a+'rs2.dbf') to (pathttn177r+'trsho15.dbf')
      lindx('trsho15', 'rs2', 1)
    endif

    netuse('rs1', 'rs1177',, 1)
    netuse('rs2', 'rs2177',, 1)
    sele rs1
    set filt to
    go top
    while (!eof())
      if (pr177#1)
        skip
        loop
      endif

      if (kop#177)
        skip
        loop
      endif

      if (ttn177#0)
        skip
        loop
      endif

      ttn_r=ttn
      sele rs2
      if (netseek('t1', 'ttn_r'))
        sele rs1
        reclock()
        arec:={}
        getrec()
        sele rs1177
        netadd()
        putrec()
        sele rs2
        while (ttn=ttn_r)
          rc177r=recn()
          ktlr=ktl
          kvpr=kvp
          arec:={}
          getrec()
          sele rs2177
          netadd()
          putrec()
          sele rs2
          if (!netseek('t1', 'ttn177r,ktlr'))
            netadd()
            putrec()
            netrepl('ttn', {ttn177r})
          else
            netrepl('kvp', {kvp+kvpr})
          endif

          netrepl('zen', {0.01})

          sele rs2
          go rc177r
          netdel()
          skip
        enddo

      endif

      sele rs1
      netrepl('ttn177', {ttn177r})
      skip
    enddo

    sele rs2
    rznst2r=0
    rc_r=0
    if (netseek('t1', 'ttn177r'))
      // коррекция к-ва и цены
      Zen4KolUc(ttn177r)

    endif

    nuse('rs1177')
    nuse('rs2177')
  endif


  return (.t.)

/************** */
function prn11tn()
  /************** */
  svczr:=0

  if (!ChkPrn11tn())
    return (.F.)
  endif
  adrnvr=gcAdr_c
  if (gnRmsk#0)
    if (gnEnt=21)
      do case
      case (gnRmsk=4)
        knvr=9000000
      endcase

    endif

    if (gnEnt=20)
      do case
      case (gnRmsk=3)
        knvr=8000000
      case (gnRmsk=4)
        knvr=9000000
      case (gnRmsk=5)
        knvr=7000000
      endcase

    endif

    adrnvr=getfield('t1', 'knvr', 'kln', 'adr')
  endif

  nAtvoKklr=''
  AtvoKkl1r=0
  AtvoKklr=0
  svczr=0
  if (mrshr#0) // есть маршрут
    sele cmrsh
    if (netseek('t2', 'mrshr'))
      dfior=alltrim(dfio)
      KATranr=KATran
      vsvbr=vsvb
      kecsr=kecs
      svczr=0
      if (fieldpos('svcz')#0)
        svczr=svcz
      endif

      if (gnEnt=20.and.(kopr=169.or.gnEntRm=1.and.svczr=0))
        dfior=''
        AtNomr=''
        vsvbr=0
        anomr=''
        AtvoKklr=0
        nAtvoKklr=''
        AtvoKkl1r=0
        mrshr=0
        necsr=''
      else
        if (KATranr#0)
          sele kln
          if (netseek('t1', 'KATranr'))
            natranr=alltrim(nkl)
            dfior=alltrim(adr)
            anomr=alltrim(nkls)
            AtNomr=natranr+' '+anomr
            AtvoKklr=kklp
            nAtvoKklr=''
            AtvoKkl1r=0
          else
            dfior=''
            AtNomr=''
            vsvbr=0
            anomr=''
            AtvoKklr=0
            nAtvoKklr=''
            AtvoKkl1r=0
          endif

        endif

      endif

    else
      dfior=''
      AtNomr=''
      vsvbr=0
      anomr=''
      AtvoKklr=0
      nAtvoKklr=''
      AtvoKkl1r=0
    endif

  else                      // без Маршрута
    if (gnArnd#0)         //  не тарные слады - торварный
      kecsr=rs1->kecs
      if (KATranr=0)
        dfior=''
        AtNomr=rs1->AtNom
        vsvbr=0
        anomr=''
        AtvoKklr=0
        nAtvoKklr=''
        AtvoKkl1r=0
      else // тарный склад
        sele kln
        if (netseek('t1', 'KATranr'))
          natranr=alltrim(nkl)
          dfior=alltrim(adr)
          anomr=alltrim(nkls)
          AtNomr=natranr+' '+anomr
          AtvoKklr=kklp
          nAtvoKklr=''
          AtvoKkl1r=0
        else
          dfior=''
          AtNomr=''
          vsvbr=0
          anomr=''
          AtvoKklr=0
          nAtvoKklr=''
          AtvoKkl1r=0
        endif

      endif

    else                    //  gnArnd=0 - тарные склады
      if (kopr=154 ;       // Возврат поставщику
          .or. iif(gnEnt=21, (kopr=160 .and. pSTr=1), .f.); // продажа С/Т
          )

        kecsr=0
        dfior=vodr
        AtNomr=Iif(kopr=154                                                            ;
                    .or. iif(gnEnt=21, (kopr=160 .and. pSTr=1), .f.), Avtor, AtNomr ;
                 )
        vsvbr=0
        anomr=''
        AtvoKklr=0
        nAtvoKklr=prvzr
        AtvoKkl1r=0
      else
        kecsr=0
        dfior=''
        AtNomr=''
        vsvbr=0
        anomr=''
        AtvoKklr=0
        nAtvoKklr=''
        AtvoKkl1r=0
      // outlog(__FILE__,__LINE__,AtNomr)
      endif

    endif

  endif

  necsr=''
  if (kecsr#0)
    necsr=getfield('t1', 'kecsr', 's_tag', 'fio')
  endif

  if (!Empty(AtvoKklr)) // определен атомобиль через ккл
    nAtvoKklr=alltrim(getfield('t1', 'AtvoKklr', 'kln', 'nkl'))
    AtvoKkl1r=getfield('t1', 'AtvoKklr', 'kln', 'kkl1')
  endif

  if (kopr#154)
    do case
    case (iif(gnEnt=21, (kopr=160 .and. pSTr=1), .f.))
    // не меняем ничего
    case (!(gnEnt=20.and.(kopr=169.or.gnEntRm=1.and.svczr=0)))
    endcase

  endif

  kmestr=0
  sele rs2
  if (netseek('t1', 'ttnr'))
    while (ttn=ttnr)
      mntovr=mntov
      kvpr=kvp
      //      upakr=getfield('t1','mntovr','ctov','upak')
      //      kmestr=kmestr+int(kvpr/upakr)
      kmestr=kmestr+kvpr
      skip
    enddo

  endif

  // outlog(__FILE__,__LINE__,ttnr,AtNomr,dopr,'ttnr,AtNomr,dopr')
  if (Empty(AtNomr))
    outlog(__FILE__,__LINE__,'*Prn11tn')
    return (.t.)
  endif

  ??chr(27)+'E'+chr(27)+'&l1h25a1O'+chr(27)+'&l3C'+chr(27)+'(3R'+chr(27)+'(s0p19.00h0s1b4102T'+chr(27)
  ??space(78)+'Додаток 7'
  ?''
  ?space(78)+'до Правил перевезень вантажiв автомобiльним транспортом в Українi'
  ?''
  ?space(78)+'Форма N 1-ТН'
  ?''
  ?''
  ?space(43)+'ТОВАРО - ТРАНСПОРТНА НАКЛАДНА '
  ?''
  if (gnEnt=20)
    if (rs1->prz=0)
      ?space(42)+' N '+str(ttnr, 6)+' вiд '+dtous(dopr)
    else
      ?space(42)+' N '+str(ttnr, 6)+' вiд '+dtous(dotr)
    endif

  else
    ?space(42)+' N '+str(ttnr, 6)+' вiд '+dtous(dopr)
  endif

  ?''
  ?''
  ?'Автомобiль '+padc(AtNomr, 20)+' '+'Причiп/напивпричiп'+space(55)+' '+'Вид перевезень'+' '+'за кiлометровим тарифом'
  ?''
  if (empty(nAtvoKklr))
    ?'Автомобiльний перевiзник '+padr(gcName_c, 37)+space(43)+'Водiй '+alltrim(dfior)
  else
    ?'Автомобiльний перевiзник '+padr(nAtvoKklr, 37)+space(43)+'Водiй '+alltrim(dfior)
  endif

  ?''
  ?'Замовник '+padr(gcName_c, 107)
  ?''
  ?'Вантажовiдправник '+alltrim(getfield('t1', 'gnKkl_c', 'kln', 'nklprn'))+' '+alltrim(getfield('t1', 'gnKkl_c', 'kln', 'adr'))
  ?''
  ?'Вантажоодержувач '+alltrim(getfield('t1', 'kplr', 'kln', 'nklprn'))+' '+alltrim(getfield('t1', 'kplr', 'kln', 'adr'))
  ?''
  knaspr=getfield('t1', 'kgpr', 'kln', 'knasp')
  nnaspr=getfield('t1', 'knaspr', 'knasp', 'nnasp')
  ?'Пункт навантаження '+padr(adrnvr, 60)+space(2)+'Пункт розвантаження '+' '+alltrim(nnaspr)+' '+padr(getfield('t1', 'kgpr', 'kln', 'adr'), 60)
  ?''
  ?'Переадресування вантажу'
  ?''
  ?'вiдпуск за довiренiстю вантажоодержувача: серiя_________________N____________вiд_"______"___________________20____р.,виданою_______________________'
  ?''
  ?'Вантаж наданий для перевезення у станi,що видповiдає правилам перевезень вiдповiдних вантажiв, номер пломби(за наявностi)__________________________'
  ?''
  ?'кiлькiсть мiсць '+numstr(kmestr, 1)+' ,масою бруто,кг '+numstr(roun(vsvr, 0), 1)+',отримав експедитор '+padr(necsr, 15)+'______________'
  ?''
  buhr=repl('_', 40)
  do case
  case (gnEnt=20.and.gnSk=228)
    komir=subs(getfield('t1', '60', 'speng', 'fio'), 1, 15)
  case (gnEnt=20.and.gnSk=400)
    komir=subs(getfield('t1', '415', 'speng', 'fio'), 1, 15)
  case (gnEnt=21.and.gnSk=232)
    komir=subs(getfield('t1', '204', 'speng', 'fio'), 1, 15)
  case (gnEnt=21.and.gnSk=700)
    komir=subs(getfield('t1', '946', 'speng', 'fio'), 1, 15)
  otherwise
    komir=space(15)
  endcase

  ?'Бухгалтер(вiдповiдальна особа вантажовiдправника) '+buhr+'вiдпуск дозволив комiрник '+komir+'________________'
  ?''
  s11r=getfield('t1', 'ttnr,11', 'rs3', 'ssf')
  ?'Усього вiдпущено на загальну суму '+padr(numstr(sdvr), 55)+',у т.ч.ПДВ '+str(s11r, 10, 2)+' грн'
  ?''
  ?'Супровiднi документи на вантаж '+'ТТН N '+str(ttnr, 6)
  ?''
  ?'Транспортнi послуги, якi надаються автомобiльним перевiзником'+repl('_', 86)
  ?''
  ?space(53)+'ВIДОМОСТI ПРО ВАНТАЖ'
  ?''
  /*?'└───────────────────────────────────────────┴──────┴─────────┴─────────┴─────────┴──────────┴─────────┴─────┴────────────┴───────┴───────┴──────┘' */
  ?'┌───┬──────────────────────────────────────┬───────┬─────────┬───────────────┬───────────────┬──────────┬────────────────────┬────────┐'
  ?'│ N │     Найменування вантажу(номер       │Одиниця│Кiлькiсть│Цiна без ПДВ за│Загальна сума з│   Вид    │Документи з вантажем│  Маса  │'
  ?'│з/п│    контейнера),у разi перевезення    │       │         │               │               │          │                    │        │'
  ?'│   │небезпечних вантажiв: клас небезпечних│ вимiру│  мисць  │одиницю,грн    │    ПДВ,грн    │пакування │                    │брутто,т│'
  ?'│   │речовин,до якого вiднесено вантаж     │       │         │               │               │          │                    │        │'
  ?'├───┼──────────────────────────────────────┼───────┼─────────┼───────────────┼───────────────┼──────────┼────────────────────┼────────┤'
  ?'│ 1 │                  2                   │   3   │    4    │        5      │        6      │    7     │          8         │    9   │'
  ?'├───┼──────────────────────────────────────┼───────┼─────────┼───────────────┼───────────────┼──────────┼────────────────────┼────────┤'
  ?'│   │Вiдповiдно п.11.7 Правил перевезення вантажiв автомобiльним транспортом, як товарний роздiл додаєтся видатковою накладноюN'+str(ttnr, 6)+' │'
  ?'│   │без якого дана товаро-транспортна накладна вважається недiйсною         │               │          │                    │        │'
  ?'├───┴──────────────────────────────────────┼───────┼─────────┼───────────────┼───────────────┼──────────┼────────────────────┼────────┤'
  ?'│                  Всього                  │       │         │               │               │          │                    │        │'
  ?'└──────────────────────────────────────────┴───────┴─────────┴───────────────┴───────────────┴──────────┴────────────────────┴────────┘'
  ?''
  ?'Здав (вiдповiдальна особа вантажовiдправника)'+space(5)+'Прийняв експедитор'+space(5)+'Здав експедитор     '+space(5)+'Прийняв (вiдповiдальна особа вантажоодержувача)'
  ?''
  ?''
  ?'Комiрник '+komir+'_____________________'+space(2)+padr(necsr, 15)+'_________'+space(2)+padr(necsr, 15)+'_____________'+space(2)+repl('_', 45)
  ?''
  ?''
  ?space(51)+'Водiй '+padr(dfior, 15)+'___________________________'
  ?''
  ?space(48)+'ВАНТАЖНО-РОЗВАНТАЖУВАЛЬНI ОПЕРАЦIЇ'
  ?''
  ?'┌─────────────────────────────┬──────────────────────────┬──────────────────────────────────────────────────────┬─────────────────────┐'
  ?'│         Операцiя            │      Маса бруто, т       │                        Час(год.,хв.)                 │Пiдпис вiдповiдальної│'
  ?'│                             │                          ├──────────────────┬─────────────────┬─────────────────┤       особи         │'
  ?'│                             │                          │     прибуття     │     вибуття     │      простою    │                     │'
  ?'├─────────────────────────────┼──────────────────────────┼──────────────────┼─────────────────┼─────────────────┼─────────────────────┤'
  ?'│            10               │             11           │        12        │        13       │        14       │          15         │'
  ?'├─────────────────────────────┼──────────────────────────┼──────────────────┼─────────────────┼─────────────────┼─────────────────────┤'
  ?'│Навантаження                 │'+padr(str(roun(vsvr, 0)/1000, 15, 3), 26)+'│     8-00         │     8-20        │      0-20       │                     │'
  ?'├─────────────────────────────┼──────────────────────────┼──────────────────┼─────────────────┼─────────────────┼─────────────────────┤'
  ?'│Розвантаження                │'+padr(str(roun(vsvr, 0)/1000, 15, 3), 26)+'│                  │                 │                 │                     │'
  ?'└─────────────────────────────┴──────────────────────────┴──────────────────┴─────────────────┴─────────────────┴─────────────────────┘'
  eject

  return (.t.)

/************* */
function prprc()
  /************* */
  ??setprnr

  ?'Прайс '+subs(str(ttnr, 6), 4, 3)
  ?''
  ?''
  sele prs2
  go top
  while (!eof())
    ?nat+' '+str(zenp, 10, 3)
    sele prs2
    skip
  enddo

  eject
  return (.t.)

/*****************************************************************
 
 FUNCTION:
 АВТОР..ДАТА..........С. Литовка  09-12-16 * 11:21:23am
 НАЗНАЧЕНИЕ.........
 ПАРАМЕТРЫ..........
 ВОЗВР. ЗНАЧЕНИЕ....
 ПРИМЕЧАНИЯ.........
 */
function prz()
  cOut:=REPLICATE('_', 3)
  // задание
  cOut:=STUFF(cOut, 1, 1, iif(empty(rs1->ztxt), ' ', 'z'))
  // договор
  cOut:=STUFF(cOut, 2, 1, iif(dog(rs1->nkkl, rs1->Kop), ' ', 'd'))
  // GPS - к-ты
  cOut:=STUFF(cOut, 3, 1, IIF(Ttn = DocId .and. EMPTY(VAL(GpsLat)), ' ', '~'))

  /*
  LOCAL nRet:=_FIELD->prz
  DO CASE
  CASE Ttn = DocId
    nRet:=IIF(EMPTY(VAL(GpsLat)),0,1)
  OTHERWISE
    nRet:=1
  ENDCASE
  */
  //TRANSFORM(
  //,'@Z 9')
  return (cOut)

/*****************************************************************
 
 FUNCTION:
 АВТОР..ДАТА..........С. Литовка  11-09-17 * 12:11:45pm
 НАЗНАЧЕНИЕ.........
 ПАРАМЕТРЫ..........
 ВОЗВР. ЗНАЧЕНИЕ....
 ПРИМЕЧАНИЯ.........
 */
function ChkPrn11tn(lvzz)
  DEFAULT lvzz to .T.       // проверять
                             //outlog(__FILE__,__LINE__,procname(1),procline(1))
  if (gnKto=934)
    outlog(3,__FILE__,__LINE__,'gnKto=934')
    return (.f.)
  endif

  if (lvzz)
    if (!(vzz=1.or.vzz=4))
    outlog(3,__FILE__,__LINE__,'lvzz & !(vzz=1.or.vzz=4)')
      return (.F.)
    endif

  endif

  if (kplr=20034)
    outlog(3,__FILE__,__LINE__,'kplr=20034')
    return (.F.)
  endif

  if (!(str(kopr, 3)$'160;161;183;193;188;'.or.(kopr=154.and.vor=1)))
    outlog(3,__FILE__,__LINE__,!(str(kopr, 3)$'160;161;183;193;188;'.or.(kopr=154.and.vor=1)))
    return (.f.)
  endif

  // outlog(__FILE__,__LINE__,ttnr,AtNomr,dopr,iif(TYPE('lPrn11tn')='U','U->.F.',lPrn11tn),'ttnr,AtNomr,dopr,lPrn11tn')

  if (lvzz)               // проверять
    if (!empty(dopr))   // отгружен
      if (TYPE('lPrn11tn')='U')
        outlog(3,__FILE__,__LINE__,"!empty(dopr) lPrn11tn')='U'")
        return (.f.)
      elseif (lPrn11tn)
      // продолжим печать
      else
        outlog(3,__FILE__,__LINE__,'!lPrn11tn')
        return (.f.)
      endif

    endif

  endif

  if (mrshr#0.and.gnEnt=20.and.gnEntRm=1)
    sele cmrsh
    svczr=0
    if (fieldpos('svcz')#0)
      svczr=getfield('t2', 'mrshr', 'cmrsh', 'svcz')
    endif

    if (svczr=0)
      outlog(3,__FILE__,__LINE__,'svczr=0')
      return (.F.)
    endif

  endif

  // номер машины
  if (TYPE('AtNomr')='U')
    AtNomr=space(10)
  endif

  // попробуем востановить
  if (Empty(AtNomr))
    if (mrshr#0)
      sele cmrsh
      if (netseek('t2', 'mrshr'))
        KATranr=KATran
        svczr=0
        if (fieldpos('svcz')#0)
          svczr=svcz
        endif

        if (gnEnt=20.and.(kopr=169.or.gnEntRm=1.and.svczr=0))
          AtNomr=space(10)
        else
          if (KATranr#0)
            sele kln
            if (netseek('t1', 'KATranr'))
              natranr=allt(nkl)
              anomr=allt(nkls)
              AtNomr=natranr+' '+anomr
            else
              AtNomr=space(10)
            endif

          endif

        endif

      else
        AtNomr=space(10)
      endif

    else                    // без Марш
      if (gnArnd#0)
        kecsr=rs1->kecs
        if (KATranr=0)
          AtNomr=rs1->AtNom
        else
          sele kln
          if (netseek('t1', 'KATranr'))
            AtNomr=natranr+' '+anomr
          else
            AtNomr=space(10)
          endif

        endif

      else               // тарные склады
        if (kopr=154)  // Возврат поставщику
                         // .or. (kopr=160 .and. pSTr=1)) продажа С/Т
          AtNomr=Iif(kopr=154, Avtor, AtNomr)
        else
          AtNomr=space(10)
        endif

      endif

    endif

  endif

  if (Empty(AtNomr))
    outlog(3,__FILE__,__LINE__,'Empty(AtNomr)')
    return (.F.)
  endif

  outlog(3, __FILE__, __LINE__, "можно печать 1ТН")
  return (.t.)
