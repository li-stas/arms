/***********************************************************
 * Модуль    : czg.prg
 * Версия    : 0.0
 * Автор     :
 * Дата      : 09/19/17
 * Изменен   :
 * Примечание: Текст обработан утилитой CF версии 2.02
 */

#include "common.ch"
#include "inkey.ch"

// set orde to tag t4
// netseek('t4','Mrshr')
crtt('otsek', "f:npp c:n(2) f:ves c:n(5)")
sele 0
use otsek excl
inde on str(npp, 2) tag t1

bNNasp_NRn:={ || kln->(netseek('t1', 'czg->kkl')), knasp->(netseek('t1', 'kln->knasp')), krn->(netseek('t1', 'kln->krn')), alltrim(knasp->nnasp)+' '+alltrim(krn->nrn) }

sele czg
set orde to tag t5
netseek('t5', 'Mrshr')
rcCzgr=recn()
fldnomr=1
while (.t.)
  sele czg
  set orde to tag t5
  go rcCzgr
  if (prDelr=0)
    if (prZr=0)
      foot('INS,DEL,F4,F5,F7,F9', 'Доб,Уд,Печ СФ,Пор(Точка),Вес(Отсек),Пор(ТТН)')
    else
      foot('F4,F5,F8', 'Печ СФ,Вес(Отсек),Отказ')
    endif

  else
    foot('F10', 'Восстановить')
  endif

  set cent off
  // *   ngpr=getfield('t1','czg->kkl','kgp','ngrpol')
  // *   ngpr=getfield('t1','czg->kkl','kln','nkl')
  if (gnEnt=20)
    if (prDelr=0)
      if (attempr=1.or.attempr=3)
        rcCzgr=slce('czg',,,,, "e:sk h:' SK' c:n(3) e:ttn h:'ТТН' c:n(6) e:kop h:'КОП' c:n(3) e:dvzttn h:'Возврат' c:d(8) e:getfield('t1','czg->kkl','kgp','ngrpol') h:'Наименование TT' c:c(27) e:mppsf h:'Пч' c:n(2) e:vsv h:'Вес кг' c:n(5) e:sdv h:'Сумма' c:n(8,2) e:vMrsh h:'VM' c:n(2) e:pri h:'П' c:n(1) e:vz h:'О' c:n(1) e:npp h:'Пз' c:n(2) e:getfield('t1','czg->vMrsh','atvm','nvMrsh') h:'Направление' c:c(20) e:eval(bNNasp_NRn) h:'Адрес TT' c:с(25)",,, 1, 'Mrsh=Mrshr',,, 'Маршрутный лист '+str(Mrshr, 6)+' '+nMrshr+' Вес '+str(mvsvr, 4)+' кг')
      else
        rcCzgr=slce('czg',,,,, "e:sk h:' SK' c:n(3) e:ttn h:'ТТН' c:n(6) e:kop h:'КОП' c:n(3) e:dop h:'Отгрузка' c:d(8) e:getfield('t1','czg->kkl','kgp','ngrpol') h:'Наименование' c:c(27) e:mppsf h:'Пч' c:n(2) e:vsv h:'Вес кг' c:n(5) e:sdv h:'Сумма' c:n(8,2) e:vMrsh h:'VM' c:n(2) e:pri h:'П' c:n(1) e:vz h:'О' c:n(1) e:npp h:'Пз' c:n(2)",,, 1, 'Mrsh=Mrshr',,, 'Маршрутный лист '+str(Mrshr, 6)+' '+nMrshr+' Вес '+str(mvsvr, 4)+' кг')
      endif

    else
      rcCzgr=slce('czg',,,,, "e:sk h:' SK' c:n(3) e:ttn h:'ТТН' c:n(6) e:kop h:'КОП' c:n(3) e:iif(deleted(),'Уд','  ') h:'Уд' c:c(2) e:getfield('t1','czg->kkl','kgp','ngrpol') h:'Наименование' c:c(29) e:mppsf h:'Пч' c:n(2) e:vsv h:'Вес кг' c:n(5) e:sdv h:'Сумма' c:n(8,2) e:vMrsh h:'VM' c:n(2) e:pri h:'П' c:n(1)",,, 1, 'Mrsh=Mrshr',,, 'Маршрутный лист '+str(Mrshr, 6)+' '+nMrshr+' Вес '+str(mvsvr, 4)+' кг')
    endif

  else
    if (prDelr=0)
      if (attempr=1.or.attempr=3)
        rcCzgr=slce('czg',,,,, "e:sk h:' SK' c:n(3) e:ttn h:'ТТН' c:n(6) e:kop h:'КОП' c:n(3) e:dvzttn h:'Возврат' c:d(8) e:getfield('t1','czg->kkl','kln','nkl') h:'Наименование' c:c(27) e:mppsf h:'Пч' c:n(2) e:vsv h:'Вес кг' c:n(5) e:sdv h:'Сумма' c:n(8,2) e:vMrsh h:'VM' c:n(2) e:pri h:'П' c:n(1) e:vz h:'О' c:n(1) e:npp h:'Пз' c:n(2) e:getfield('t1','czg->vMrsh','atvm','nvMrsh') h:'Направление' c:c(20)",,, 1, 'Mrsh=Mrshr',,, 'Маршрутный лист '+str(Mrshr, 6)+' '+nMrshr+' Вес '+str(mvsvr, 4)+' кг')
      else
        rcCzgr=slce('czg',,,,, "e:sk h:' SK' c:n(3) e:ttn h:'ТТН' c:n(6) e:kop h:'КОП' c:n(3) e:dop h:'Отгрузка' c:d(8) e:getfield('t1','czg->kkl','kln','nkl') h:'Наименование' c:c(27) e:mppsf h:'Пч' c:n(2) e:vsv h:'Вес кг' c:n(5) e:sdv h:'Сумма' c:n(8,2) e:vMrsh h:'VM' c:n(2) e:pri h:'П' c:n(1) e:vz h:'О' c:n(1) e:npp h:'Пз' c:n(2)",,, 1, 'Mrsh=Mrshr',,, 'Маршрутный лист '+str(Mrshr, 6)+' '+nMrshr+' Вес '+str(mvsvr, 4)+' кг')
      endif

    else
      rcCzgr=slce('czg',,,,, "e:sk h:' SK' c:n(3) e:ttn h:'ТТН' c:n(6) e:kop h:'КОП' c:n(3) e:iif(deleted(),'Уд','  ') h:'Уд' c:c(2) e:getfield('t1','czg->kkl','kln','nkl') h:'Наименование' c:c(29) e:mppsf h:'Пч' c:n(2) e:vsv h:'Вес кг' c:n(5) e:sdv h:'Сумма' c:n(8,2) e:vMrsh h:'VM' c:n(2) e:pri h:'П' c:n(1)",,, 1, 'Mrsh=Mrshr',,, 'Маршрутный лист '+str(Mrshr, 6)+' '+nMrshr+' Вес '+str(mvsvr, 4)+' кг')
    endif

  endif

  set cent on
  sele czg
  go rcCzgr
  entr=ent
  skr=sk
  ttnr=ttn
  kklr=kkl
  tvsvr=vsv
  tsdvr=sdv
  if (fieldpos('sdvu')#0)
    tsdvur=sdvu
  else
    tsdvur=0
  endif

  prir=pri
  vMrshnr=vMrsh
  nppr=npp
  d0k1r=d0k1
  if (fieldpos('vz')#0)
    vzr=vz
  else
    vzr=0
  endif

  if (fieldpos('sdvu')#0)
    sdvur=sdvu
  else
    sdvur=0
  endif

  if (fieldpos('kpl')#0)
    kplr=kpl
  else
    kplr=0
  endif

  if (fieldpos('ttnp')#0)
    ttnpr=ttnp
    ttncr=ttnc
  else
    ttnpr=0
    ttncr=0
  endif

  if (fieldpos('dtro')#0)
    dtror=dtro
  else
    dtror=ctod('')
  endif

  if (fieldpos('dvzttn')#0)
    dvzttnr=dvzttn
  else
    dvzttnr=ctod('')
  endif

  if (fieldpos('npp')#0)
    MrshNppr=npp
  else
    MrshNppr=0
  endif

  if (fieldpos('vsvb')#0)
    tvsvbr=vsvb
  else
    tvsvbr=0
  endif
  // outlog(__FILE__,__LINE__,lastkey())
  do case
  case (lastkey()=K_LEFT)     // Left
    fldnomr=fldnomr-1
    if (fldnomr=0)
      fldnomr=1
    endif

  case (lastkey()=K_RIGHT)      //
    fldnomr=fldnomr+1
  case (lastkey()=K_ESC)
    exit
  case (lastkey()=K_INS .and.prZr=0.and.prDelr=0.and.prZor=0)// Добавить
    CzgIns()
    sele czg
    netseek('t1', 'Mrshr')
    rcCzgr=recn()
  case (lastkey()= K_DEL .and.prZr=0.and.prDelr=0.and.prZor=0)// Удалить
    sele atDocs
    if (netseek('t5', 'Mrshr,entr,skr,d0k1r,ttnr'))
      netrepl('Mrsh', {0})
    endif

    sele cMrsh
    netrepl('vsv,sdv', {vsv-tvsvr,sdv-tsdvr}, 1)
    if (fieldpos('sdvu')#0)
      netrepl('sdvu', {sdvu-tsdvur}, 1)
    endif

    sele setup
    locate for ent=entr
    pathdr=gcPath_m+alltrim(nent)+'\'+gcDir_g+gcDir_d
    pathr=pathdr+alltrim(getfield('t1', 'skr', 'cskl', 'path'))
    if (d0k1r=0)
      if (netfile('rs1', 1))
        netuse('rs1',,, 1)
        if (netseek('t1', 'ttnr',,, 1))
          If rs1->(ttn129 + ttn139 + ttn169) = 0 // ТТН не свернута
            netrepl('Mrsh', {0})
          else
            wmess('Отказ: ТТН в ТТН'+str(rs1->(ttn129 + ttn139 + ttn169),6), 1)
          EndIf
        endif

        nuse('rs1')
      endif

    else
      if (netfile('pr1', 1))
        netuse('pr1',,, 1)
        if (netseek('t2', 'ttnr',,, 1))
          netrepl('Mrsh', {0})
        endif

        nuse('pr1')
      endif

    endif

    sele czg
    netdel()
    skip -1
    if (bof())
      go top
    endif

    rcCzgr=recn()
  case (lastkey()=K_F4.and.(!(who=0.or.who=1).or.gnAdm=1).and.prDelr=0) // Печать CФ
    PrnSf()
  case (lastkey()=K_CTRL_F5  .or.  lastkey()=K_ALT_F5 .or. lastkey()=K_F5.and.prZr<2.and.prDelr=0)// Порядок (Точка)
    MrshLkkl()

    sele lkkl
    If (lastkey()=K_ALT_F5 .or. lastkey()=K_CTRL_F5)
      repl all npp with 0
      repl all npp with -8 for Empty(GpsLat)
    EndIf

    inde on str(npp, 2) tag Npp
    index on str(knasp,4)+GpsLat+GpsLon tag UniCord uniq for .not. (npp = -8 .or. empty(GpsLat+GpsLon))
    ordsetfocus(0)

    // проверка назаполнение к-т
    //locate for Empty(GpsLat)
    //If !found()
    If (lastkey()=K_ALT_F5 .or. lastkey()=K_CTRL_F5)
      // к-т заполнены
      tsp_npp((lastkey()=K_ALT_F5 .or. lastkey()=K_F5))
    EndIf

    //EndIf

    sele lkkl
    ordsetfocus('npp')
    go top
    while (.t.)
      foot('ENTER,F3,F10', 'Коррекция,GMap,Выход')
      // devpos(maxrow(),2),devout(getfield('t1','lkkl->kkl','kln','nkl'),'N/W')
      rcLKklr=slcf('lkkl',,,,,;
        "e:kkl h:'Код' c:n(7)";
      +" e:iif(empty(GpsLat),'*','')+getfield('t1','lkkl->kkl','kln','nkl') h:'Наименование' c:c(34)" ;
      ;//+" e:getfield('t1','lkkl->kkl','kln','adr') h:'Адрес доставки' c:c(34)";
      ;//+" e:agp h:'Адрес доставки' c:c(34)";
      +" e:npp h:'По' c:n(2)";
      +" e:ves h:'Вес' c:n(5)",,, 1,,{||.t.},,;
       'Порядок загрузки'+' Вес '+str(mvsvr, 4)+' кг')
      sele lkkl
      go rcLKklr
      kklr=kkl
      MrshNppr=npp
      do case
      case (lastkey()=K_F3)
        DBGoTo(rcLKklr)

        cCoord := GpsLat+GpsLon
        // cOldOrdSetFocus:=OrdSetFocus('UniCord')
        Locate for cCoord = GpsLat+GpsLon
        //b rowse()
        nNext:=10

        cUrl:='URL=www.google.com.ua/maps/dir'
        Do While !eof()
          cUrl+='/'+allt(GpsLat)+','+allt(GpsLon)

          cCoord := GpsLat+GpsLon
          Do While cCoord = GpsLat+GpsLon
            DBSkip()
          EndDo

          nNext--
          If nNext = 0
            exit
          EndIf
        EndDo
        // OrdSetFocus(cOldOrdSetFocus)
        DBGoTop()

        cFile_wget:=gcIn
        cFile_wget+=DTOC(DATE(),"yyyy-mm-dd")+"T"+CHARREPL(":", TIME(), "-")+'#'+PADL(LTRIM(STR(Mrshr)),6,'0')
        cFile_wget+='.url'
        SET CONSOLE OFF;  SET PRINT ON;  SET PRINT TO (cFile_wget)
        ??'[{000214A0-0000-0000-C000-000000000046}]'
        ?'Prop3=19,2'
        ?'[InternetShortcut]'
        ? cUrl
        ?'IDList='
        SET PRINT TO ;  SET PRINT OFF

      case (lastkey()=K_ESC .or. lastkey()=K_F10 )
        exit
      case (lastkey()=K_ENTER)
        @ row(), 57 get MrshNppr color 'r/w,r/w+' valid MrshNppr >=1 .and. MrshNppr<=LastRec()
        read
        if (lastkey()=K_ENTER)
          sele lkkl
          repl npp2 with (npp * 10) all

          go rcLKklr
          repl npp2 with ((MrshNppr) * 10) //-1
          lkklNppSort()


          sele lkkl
          DBGoTop()
          Do While !eof()
            kklr:=kkl
            MrshNppr:=npp

            sele czg
            set orde to tag t2
            netseek('t2', 'Mrshr,kklr')
            Do While Mrsh=Mrshr .and. kklr=kkl
              netrepl('npp', {MrshNppr})
              DBSkip()
            EndDo

            sele lkkl
            DBSkip()
          EndDo

          /*
          netrepl('npp', {MrshNppr})
          sele czg
          if (netseek('t5', 'Mrshr'))
            while (Mrsh=Mrshr)
              if (kkl=kklr)
                netrepl('npp', {MrshNppr})
              endif

              sele czg
              skip
            enddo
          endif
          */

          sele lkkl
          //go top
          go rcLKklr
        endif

      endcase

    enddo

    sele czg
    go rcCzgr
  case (lastkey()=K_F6.and.prDelr=0)// Возврат
    if (.f..and.gnAdm=1)
      clvz=setcolor('gr+/b,n/w')
      wvz=wopen(10, 20, 12, 60)
      wbox(1)
      @ 0, 1 say 'Дата возврата' get dvzttnr
      read
      netrepl('dvzttn', {dvzttnr})
      if (fieldpos('tvzttn')#0)
        netrepl('tvzttn', {time()})
      endif

      wclose(wvz)
      setcolor(clvz)
    endif

  case (lastkey()=K_F7.and.prDelr=0)// Вес(отсек) - визуалный отчет
    sele otsek
    zap
    sele czg
    if (netseek('t5', 'Mrshr'))
      while (Mrsh=Mrshr)
        nppr=npp
        vsvr=vsv
        sele otsek
        locate for npp=nppr
        if (!foun())
          netadd()
          repl npp with nppr, ;
           ves with vsvr
        else
          repl ves with ves+vsvr
        endif

        sele czg
        skip
      enddo

      sele otsek
      go top
      while (.t.)
        rcOtsekr=slcf('otsek',,,,, "e:npp h:'Пз' c:n(2) e:ves h:'Вес' c:n(5)",,,,,,, 'Вес')
        if (lastkey()=K_ESC)
          exit
        endif

      enddo

    endif

  case (lastkey()=K_F9.and.prDelr=0)// Порядок(ТТН)
    clot=setcolor('gr+/b,n/w')
    wot=wopen(10, 20, 13, 60)
    wbox(1)
    @ 0, 1 say str(ttnr, 6)
    @ 1, 1 say 'Отсек' get nppr
    read
    if (lastkey()=K_ENTER)
      sele czg
      netrepl('npp', {nppr})
    endif

    wclose(wot)
    setcolor(clot)
  case (lastkey()=K_F10.and.prDelr=1)// Восстановить
    sele cMrsh
    if (reclock())
      sele czg
      set orde to tag t1
      if (netseek('t1', 'Mrshr'))
        while (Mrsh=Mrshr)
          skr=sk
          entr=ent
          ttnr=ttn
          prRclr=1
          sele cskl
          locate for sk=skr
          if (found())
            sele setup
            locate for ent=entr
            pathdr=gcPath_m+alltrim(nent)+'\'+gcDir_g+gcDir_d
            sele cskl
            pathr=pathdr+alltrim(path)
            netuse('rs1', 'rs1d',, 1)
            if (netseek('t1', 'ttnr',,, 1))
              if (Mrsh=0)
                netrepl('Mrsh', {Mrshr})
              else
                if (Mrsh#Mrshr)
                  prRclr=0
                else
                endif

              endif

            else
            endif

            nuse('rs1d')
          endif

          sele czg
          if (deleted().and.prRclr=1)
            if (reclock())
              recall
            endif

          endif

          skip
        enddo

        sele czg
        dbunlock()
      endif

      sele czg
      go rcCzgr
      sele cMrsh
      recall
      dbunlock()
    endif

  case (lastkey()=K_F8.and.prZr=1)// Отказ
    sele mvz
    if (!netseek('t1', '0'))
      nvzr='НОРМА'
      netadd()
      netrepl('nvz', {nvzr})
    endif

    go top
    rcmvzr=recn()
    while (.t.)
      foot('INS,DEL,F4,ENTER', 'Добавить,Удалить,Коррекция,Выбрать')
      sele mvz
      go rcmvzr
      rcmvzr=slcf('mvz',,,,, "e:vz h:'Код' c:n(2) e:nvz h:'Наименование' c:c(20) ",,,,,,, 'Отказ')
      if (lastkey()=K_ESC)
        exit
      endif

      sele mvz
      go rcmvzr
      vzr=vz
      nvzr=nvz
      do case
      case (lastkey()=K_ENTER)// ENTER
        exit
      case (lastkey()=K_INS)  // INS
        mvzins()
      case (lastkey()=K_DEL)  // DEL
        if (vzr#0)
          netdel()
          skip-1
          rcmvzr=recn()
        endif

      case (lastkey()=K_F4)// CORR
        mvzins(1)
      endcase

    enddo

    sele setup
    locate for ent=entr
    pathdr=gcPath_m+alltrim(nent)+'\'+gcDir_g+gcDir_d
    pathr=pathdr+alltrim(getfield('t1', 'skr', 'cskl', 'path'))
    netuse('rs1',,, 1)
    if (netseek('t1', 'ttnr',,, 1))
      if (vzr#0)
        netrepl('Mrsh', {0})
      else
        netrepl('Mrsh', {Mrshr})
      endif

    endif

    nuse('rs1')
    sele czg
    if (fieldpos('vz')#0)
      netrepl('vz', {vzr})
    endif

  endcase

enddo

if (select('otsek')#0)
  sele otsek
  CLOSE
endif

erase otsek.dbf
erase otsek.cdx
sele czg
set orde to tag t1
return (.t.)

/************** */
static function CzgIns()
  /************** */
  if (atrcr#2)
    ForAtVmr='atrc=atrcr'
  else
    ForAtVmr='atrc=atrcr.or.atrc=0'
  endif

  while (.t.)
    sele atvm
    dbunlock()
    go top
    foot('ENTER', 'Выбор')
    vMrshr=slcf('atvm', 1, 1, 18,, "e:vMrsh h:' N' c:n(3) e:nvMrsh h:'Маршрут' c:с(20)", 'vMrsh',,,, ForAtVmr,, 'Направления')
    sele atvm
    LOCATE for vMrsh=vMrshr
    atrcnr=atrc             // atrc выбранного направления
    do case
    case (lastkey()=K_ESC)// Выход
      exit
    case (lastkey()=K_ENTER)// Выбор
      sele atvm
      if (atrcr#4)
        if (atrcr=1)
          if (!reclock(1))
            wmess('Направление занято', 1)
            loop
          endif

        else
          if (atrcnr=1.or.atrcnr=0)
            if (!reclock(1))
              wmess('Направление занято', 1)
              loop
            endif

          else              // atrcnr=2
            go top
            cityzr=0
            while (!eof())
              if (atrc#atrcnr)
                skip
                loop
              endif

              rcvMrsh_r=recn()
              if (!reclock(1))
                wmess('Город занят', 1)
                cityzr=1
                exit
              endif

              skip
            enddo

            if (cityzr=1)
              loop
            endif

          endif

        endif

      else
        if (!reclock(1))
          wmess('Направление занято', 1)
          loop
        endif

      endif

    otherwise
      loop
    endcase

    sele sl
    zap

    CzgPd()

    sele atDocs
    set orde to tag t3
    go top
    adforr='Mrsh=0'
    fldnomr=1
    while (.t.)
      foot('ALT-F10,ENTER,ESC)', 'Отбор страницы,Запись,Отмена')
      set cent off
      rcdocsr=slce('atDocs',,,,, "e:ent h:'П' c:n(2) e:sk h:' SK' c:n(3) e:ttn h:'TTН' c:n(6) e:ktas h:'SW' c:n(4) e:dtro h:'ДРО' c:d(8) e:kop h:'КОП' c:n(3) e:pvt h:'CВ' c:n(1) e:vts h:'С' c:c(1) e:vsv h:'Вес' c:n(5) e:sdv h:'Сумма' c:n(8,2) e:pri h:'П' c:n(1) e:getfield('t1','atDocs->kkl','kgp','ngrpol') h:'Наименование' c:c(40) e:getfield('t1','atDocs->ktas','s_tag','fio') h:'Супервайзер' c:c(15) e:getfield('t1','atDocs->vMrsh','atvm','nvMrsh') h:'Направление' c:с(20)",, 1,,, adforr,, 'Документы')
      set cent on
      go rcdocsr
      do case
      case (lastkey()=K_LEFT) // Left
        fldnomr=fldnomr-1
        if (fldnomr=0)
          fldnomr=1
        endif

      case (lastkey()=K_RIGHT)  // Right
        fldnomr=fldnomr+1
      case (lastkey()=K_ESC)
        exit
      case (lastkey()=K_ENTER)
        sele sl
        go top
        sk_r=0
        while (!eof())
          sele sl
          rcslr=val(kod)
          if (rcslr=0)
            skip
            loop
          endif

          sele atDocs
          go rcslr
          entr=ent
          skr=sk
          if (skr#sk_r)
            nuse('rs1')
            nuse('pr1')
            sele setup
            locate for ent=entr
            pathdr=gcPath_m+alltrim(nent)+'\'+gcDir_g+gcDir_d
            sele cskl
            if (netseek('t1', 'skr'))
              pathr=pathdr+alltrim(path)
              netuse('rs1',,, 1)
              netuse('pr1',,, 1)
              sk_r=skr
            else
              sele sl
              skip
              loop
            endif

          endif

          sele atDocs
          ttnr=ttn
          kopr=kop
          pvtr=pvt
          kklr=kkl
          dvsvr=vsv
          d0k1r=d0k1
          if (fieldpos('vsvb')#0)
            dvsvbr=vsvb
          else
            dvsvbr=0
          endif

          dsdvr=sdv
          if (fieldpos('sdvu')#0)
            dsdvur=sdvu
          else
            dsdvur=0
          endif

          prir=pri
          mppsfr=mppsf
          vMrshnr=vMrsh
          ktar=kta
          if (fieldpos('ttnp')#0)
            ttnpr=ttnp
            ttncr=ttnc
          else
            ttnpr=0
            ttncr=0
          endif

          if (fieldpos('kpl')#0)
            kplr=kpl
          else
            kplr=0
          endif

          if (fieldpos('ztxt')#0)
            ztxtr=ztxt
            plr=pl
            gpr=gp
          else
            ztxtr=''
            plr=0
            gpr=0
          endif

          sele czg
          if (!netseek('t6', 'Mrshr,entr,skr,d0k1r,ttnr'))
            netadd()
            netrepl('Mrsh,ent,sk,ttn,kkl,vsv,sdv,kop,pri,vMrsh,d0k1,mppsf',                            ;
                     { Mrshr, entr, skr, ttnr, kklr, dvsvr, dsdvr, kopr, prir, vMrshnr, d0k1r, mppsfr } ;
                  )
            if (fieldpos('vsvb')#0)
              netrepl('vsvb', {dvsvbr})
            endif

            if (fieldpos('sdvu')#0)
              netrepl('sdvu', {dsdvur})
            endif

            if (fieldpos('kta')#0)
              netrepl('kta', {ktar})
            endif

            if (fieldpos('ttnp')#0)
              netrepl('ttnp,ttnc', {ttnpr,ttncr})
            endif

            if (fieldpos('kpl')#0)
              netrepl('kpl', {kplr})
            endif

            if (fieldpos('ztxt')#0)
              netrepl('ztxt,pl,gp', {ztxtr,plr,gpr})
            endif

            sele atDocs
            netrepl('Mrsh', {Mrshr})
            sele cMrsh
            netrepl('vsv,sdv', {vsv+dvsvr,sdv+dsdvr}, 1)
            netrepl('vsvb', {vsvb+dvsvbr}, 1)
            if (fieldpos('sdvu')#0)
              netrepl('sdvu', {sdvu+dsdvur})
            endif

            if (d0k1r=0)
              sele rs1
              if (netseek('t1', 'ttnr',,, 1))
                netrepl('Mrsh,kecs,atnom', {Mrshr,kecsr,anomr})
              endif

            else
              sele pr1
              if (netseek('t2', 'ttnr',,, 1))
                netrepl('Mrsh', {Mrshr})
              endif

            endif

          endif

          sele sl
          dele
          skip
        enddo

        nuse('rs1')
        nuse('pr1')
        nuse('rs2')
        exit
      endcase

    enddo

  enddo

  sele czg
  czgend()
  return (.t.)

/*************** */
static function CzgPd()
  /*************** */
  sele atDocs
  zap
  save scre to scttn
  sele setup
  go top
  while (!eof())
    sele setup
    if (nMrsh=0)
      skip
      loop
    endif

    if (ent#gnEnt)
      skip
      loop
    endif

    entr=ent
    pathdr=gcPath_m+alltrim(nent)+'\'+gcDir_g+gcDir_d
    sele cskl
    go top
    while (!eof())
      if (ent#entr)
        skip
        loop
      endif

      if (!(rasc=1.or.rasc=2))
        skip
        loop
      endif

      if (gnEntrm=0.and.rm#0)
        skip
        loop
      endif

      if (gnEntrm=1.and.rm=0)
        skip
        loop
      endif

      pathr=pathdr+alltrim(path)
      skr=sk
      if (!netfile('tov', 1))
        skip
        loop
      endif

      mess(pathr)
      nuse('rs1')
      netuse('rs1',,, 1)
      netuse('rs3',,, 1)
      netuse('pr1',,, 1)
      sele rs1
#ifdef __CLIP__
        set orde to tag t3
        count to nCntOrd_3
        set orde to 0
        count to nCntOrd_0
        if (ROUND(nCntOrd_3-nCntOrd_0, 2)#0)
          outlog(3,  __FILE__, __LINE__, TIME(), "nCntOrd_3", nCntOrd_3, "nCntOrd_0", nCntOrd_0)
        endif

#endif

      set orde to 0
      go top
      while (!eof())      //prZ=0.and.Mrsh=0.and.!eof()
        if (prZ=1)
          skip
          loop
        endif

        if (Mrsh#0)
          skip
          loop
        endif

        if (ddc>=ctod('01.12.2005').and.ddc<=ctod('18.12.2005'))// Документы 1С
          skip
          loop
        endif

        pvtr=pvt
        if (sdv=0.and.!(vo=6.and.(kop=181.or.kop=101.or.kop=121)))
          if (empty(ztxt))
            skip
            loop
          endif

        endif

        If kop=169 .and. !(sdv < 50000) //sdv50000
          skip
          loop
        EndIf

        if (empty(dfp))
          skip
          loop
        endif

        if (!(vo=9.or.vo=2.or.(vo=6.and.kop=188)))
          skip
          loop
        endif

        if (fieldpos('fc')#0)
          if (fc#0)
            skip
            loop
          endif

        endif

        dotr=dot
        dspr=dsp
        dfpr=dfp
        ttnr=ttn
        if (dfpr#date())
          sele czg
          set orde to tag t3
          prdotr=1
          if (fieldpos('vz')#0)
            if (netseek('t3', 'entr,skr,ttnr'))
              while (ent=entr.and.sk=skr.and.ttn=ttnr)
                if (d0k1=1)
                  skip
                  loop
                endif

                if (vz>0)
                  prdotr=0
                  exit
                endif

                skip
              enddo

            endif

          endif

          if (prdotr=1)
            if (!empty(dotr))
              sele rs1
              skip
              loop
            endif

          endif

        endif

        sele rs1
        if (gnEnt=13.and.(kop=181.or.kop=101.or.kop=121))
          do case
          case (kop=181)
            kklr=2054800
          case (kop=101)
            kklr=2653305
          case (kop=121)
            kklr=3352550
          endcase

        else
          kklr=kpv
        endif

        if (kklr=0)
          kklr=kgp
        endif

        if (kklr=0)
          kklr=kpl
        endif

        if (gnEntRm=1)
          if (getfield('t1', 'kklr', 'kgp', 'rm')#gnRmsk)
            sele rs1
            skip
            loop
          endif

        endif

        kopr=kop
        ttnpr=ttnp
        docidr=docid
        rcrs1_r=recn()
        if (kklr=20034)   //.or.(kklr=20540.and.kopr#173)
          sele rs1
          skip
          loop
        endif

        vMrsh_r=getfield('t2', 'kklr', 'atvme', 'vMrsh')
        atrc_r=getfield('t1', 'vMrsh_r', 'atvm', 'atrc')
        if (atrcr#4)
          if (subs(docguid, 1, 2)='SV')
            sele rs1
            skip
            loop
          else
            if (kopr=170)
              if (ttnpr#0)
                docguid_r=getfield('t1', 'ttnpr', 'rs1', 'docguid')
                sele rs1
                go rcrs1_r
                if (subs(docguid_r, 1, 2)='SV')
                  sele rs1
                  skip
                  loop
                endif

              endif

            endif

            if (kopr=177.or.kopr=168)
              if (docidr#0)
                docguid_r=getfield('t1', 'docidr', 'rs1', 'docguid')
                sele rs1
                go rcrs1_r
                if (subs(docguid_r, 1, 2)='SV')
                  sele rs1
                  skip
                  loop
                endif

              endif

            endif

          endif

          if (vMrsh_r#vMrshr.and.kopr#188)
            sele rs1
            skip
            loop
          endif

        else
          if (subs(docguid, 1, 2)#'SV')
            if (kopr=170)
              if (ttnpr#0)
                docguid_r=getfield('t1', 'ttnpr', 'rs1', 'docguid')
                sele rs1
                go rcrs1_r
                if (subs(docguid_r, 1, 2)#'SV')
                  sele rs1
                  skip
                  loop
                endif

              else
                sele rs1
                skip
                loop
              endif

            else
              if (kopr=177.or.kopr=168)
                if (docidr#0)
                  docguid_r=getfield('t1', 'docidr', 'rs1', 'docguid')
                  sele rs1
                  go rcrs1_r
                  if (subs(docguid_r, 1, 2)#'SV')
                    sele rs1
                    skip
                    loop
                  endif

                else
                  sele rs1
                  skip
                  loop
                endif

              else
                sele rs1
                skip
                loop
              endif

            endif

          endif

        endif

        ttnr=ttn
        ktar=kta
        ktasr=ktas
        if (ktasr=0.and.ktar#0)
          ktasr=getfield('t1', 'ktar', 's_tag', 'ktas')
        endif

        vsvr=vsv
        if (fieldpos('vsvb')#0)
          vsvbr=vsvb
        else
          vsvbr=0
        endif

        if (fieldpos('ztxt')#0)
          ztxtr=ztxt
        else
          ztxtr=''
        endif

        sdvr=sdv
        sdvur=getfield('t1', 'ttnr,96', 'rs3', 'ssf')
        plr=nkkl
        gpr=kpv
        vor=vo
        totr=tot
        dtror=dtro
        kopr=kop
        ttnpr=ttnp
        ttncr=ttnc
        kplr=nkkl
        nklr=getfield('t1', 'kklr', 'kln', 'nkle')
        prir=getfield('t1', 'kklr', 'kln', 'pri')
        mppsfr=ppsf
        if (prir=0)
          prir=9
        endif

        vtsr=''
        if (ktasr#0)
          do case
          case (ktasr=327)// Кириешки
            vtsr='C'
          case (ktasr=44) // Табак
            vtsr='Т'
          case (ktasr=227)// SV
            vtsr='В'
          case (ktasr=308)// Жова
            vtsr='Ж'
          case (ktasr=457)// Орешки
            vtsr='О'
          case (ktasr=938)// Кеги
            vtsr='К'
          endcase

        endif

        sele czg
        if (fieldpos('vz')#0)
          if (!netseek('t3', 'entr,skr,ttnr,0'))
            sele atDocs
            netadd()
            netrepl('ent,sk,ttn,vo,kop,kkl,nkl,vsv,sdv,dsp,dot,tot,dtro,vMrsh,pri,vts,mppsf,pvt,kta,ktas,mppsf',                                            ;
                     { entr, skr, ttnr, vor, kopr, kklr, nklr, vsvr, sdvr, dfpr, dotr, totr, dtror, vMrsh_r, prir, vtsr, mppsfr, pvtr, ktar, ktasr, mppsfr } ;
                  )
            if (fieldpos('ttnp')#0)
              netrepl('ttnp,ttnc', {ttnpr,ttncr})
            endif

            if (fieldpos('kpl')#0)
              netrepl('kpl', {kplr})
            endif

            if (fieldpos('vsvb')#0)
              netrepl('vsvb', {vsvbr})
            endif

            if (fieldpos('ztxt')#0)
              netrepl('ztxt,pl,gp', {ztxtr,plr,gpr})
            endif

            if (fieldpos('sdvu')#0)
              netrepl('sdvu', {sdvur})
            endif

          endif

        else
          if (!netseek('t3', 'entr,skr,ttnr'))
            sele atDocs
            netadd()
            netrepl('ent,sk,ttn,vo,kop,kkl,nkl,vsv,sdv,dsp,dot,tot,dtro,vMrsh,pri,vts,mppsf,pvt,kta,ktas',                                          ;
                     { entr, skr, ttnr, vor, kopr, kklr, nklr, vsvr, sdvr, dfpr, dotr, totr, dtror, vMrsh_r, prir, vtsr, mppsfr, pvtr, ktar, ktasr } ;
                  )
            if (fieldpos('ttnp')#0)
              netrepl('ttnp,ttnc', {ttnpr,ttncr})
            endif

            if (fieldpos('kpl')#0)
              netrepl('kpl', {kplr})
            endif

            if (fieldpos('vsvb')#0)
              netrepl('vsvb', {vsvbr})
            endif

            if (fieldpos('ztxt')#0)
              netrepl('ztxt,pl,gp', {ztxtr,plr,gpr})
            endif

            if (fieldpos('sdvu')#0)
              netrepl('sdvu', {sdvur})
            endif

          endif

        endif

        sele rs1
        skip
      enddo

      sele pr1
      go top
      while (!eof())
        if (atrcr=4)
          if (!('SV' $ docguid))
            sele pr1
            skip
            loop
          endif

        else
          if ('SV' $ docguid)
            sele pr1
            skip
            loop
          endif

        endif

        if (vo=1.and.kop=108.and.prZ=0.and.Mrsh=0.and.kzg#0.and.!empty(docguid))

          mnr=mn
          ktar=kta
          ktasr=ktas
          kplr=kps
          kklr=kzg

          nklr=getfield('t1', 'kklr', 'kln', 'nkl')
          vMrsh_r=getfield('t2', 'kklr', 'atvme', 'vMrsh')
          atrc_r=getfield('t1', 'vMrsh_r', 'atvm', 'atrc')

          if (atrcr#4)
            if (vMrsh_r#vMrshr)
              sele pr1
              skip
              loop
            endif

          endif

          sele czg
          if (!netseek('t7', 'entr,skr,1,mnr'))
            sele atDocs
            netadd()
            netrepl('ent,sk,ttn,vo,kop,kkl,nkl,vMrsh,kta,ktas,d0k1',                ;
                     { entr, skr, mnr, 1, 108, kklr, nklr, vMrsh_r, ktar, ktasr, 1 } ;
                  )
            netrepl('kpl', {kplr})
          endif

        endif

        sele pr1
        skip
      enddo

      nuse('rs1')
      nuse('rs3')
      nuse('pr1')

      sele cskl
      skip
    enddo

    sele setup
    skip
  enddo

  sele cMrsh
  set orde to tag t1
  go top
  rest scre from scttn
  return (.t.)

/***************** */
static function mvzIns(p1)
  /***************** */
  if (p1=nil)
    sele mvz
    go bott
    vzr=vz+1
    nvzr=space(20)
  endif

  clvz=setcolor('gr+/b,n/w')
  wvz=wopen(10, 20, 12, 60)
  wbox(1)
  @ 0, 1 say 'Отказ'+' '+ str(vzr, 2) get nvzr
  read
  nvzr=upper(nvzr)
  if (p1=nil)
    netadd()
    netrepl('vz,nvz', {vzr,nvzr})
  else
    netrepl('nvz', {nvzr})
  endif

  wclose(wvz)
  setcolor(clvz)
  return (.t.)


/*****************************************************************
 
 FUNCTION:
 АВТОР..ДАТА..........С. Литовка  09-19-17 * 04:19:17pm
 НАЗНАЧЕНИЕ.........
 ПАРАМЕТРЫ..........
 ВОЗВР. ЗНАЧЕНИЕ....
 ПРИМЕЧАНИЯ.........
 */
STATIC FUNCTION tsp_npp(lGMApi)
  LOCAL aCrdOrig, aCrd, i, c, aCrd4Center, aCenter, nKnasp
  LOCAL nClaster, lRun_kmeans, nRecCnt, s
  LOCAL nDist, nMinD:=99999999999
  LOCAL klnOrigin,klnDestination,nAdd
  LOCAL cOldOrdSetFocus, cSaveSreen

  cSaveSreen:=SaveScreen(0,0,MaxRow(),MaxCol())
  cOldOrdSetFocus:=OrdSetFocus('UniCord')
  count to nRecCnt
  outlog(__FILE__,__LINE__,nRecCnt)
  If .F. .AND. nRecCnt > 23

    // KommVoya(nRecCnt)

    aClasterS:={} //
    aClasterSCenter:={} //
    // нужна кластеризация
    // по коду города
    DBGoTop()
    Do While !eof()
      nKnasp:=Knasp
      aCrdOrig := {}
      Do While nKnasp = Knasp
        AAdd(aCrdOrig, {str(kkl,7),{val(GpsLat),val(GpsLon)}})
        DBSkip()
      EndDo

      Aadd(aClasterS, AClone(aCrdOrig))
      // сохранение цетров кластеров
      AAdd(aClasterSCenter,AClone(aCrdOrig[1]))

    EndDo

  else
    aCrdOrig := {}
    OrdSetFocus('UniCord')
    DBEval({|| AAdd(aCrdOrig, {str(kkl,7),{val(GpsLat),val(GpsLon)}}) })


    aClasterS:={}
    Aadd(aClasterS, AClone(aCrdOrig))
    // сохранение цетров кластеров
    aClasterSCenter:={}
    AAdd(aClasterSCenter,AClone(aClasterS[1,1]))
    //AAdd(aClasterSCenter,aClasterS[1,1])
  EndIf
  aCrdOrig:={}

  If nRecCnt > 23

    s:=1
    Do While .T.
      if s++ > 50
        RETURN (NIL)
      endif
      lRun_kmeans:=.f.
      nCntCenter:=LEN(aClasterS)
          // outlog(__FILE__,__LINE__,'всего клст',nCntCenter)

      For nClaster:=1 To nCntCenter
        @ MaxRow(), 0 say 'Разбивка на кластеры '+str(nClaster,2)+'/'+str(nCntCenter,2) color 'B/W'
        // проверка кластера на 23 точки макс
        aCrdOrig:=AClone(aClasterS[nClaster])
        nLen_aCrdOrig:=LEN(aCrdOrig)
          // outlog(__FILE__,__LINE__,'точек в клст',nLen_aCrdOrig)
        If nLen_aCrdOrig > 23

          lRun_kmeans:=.t.

          nCntCenter := Ceiling(nLen_aCrdOrig/23)
          // получение центронов
          aCenter:={}
          If nCntCenter = 12
            DBGoTo(Ceiling(nLen_aCrdOrig/4));    AAdd(aCenter, {str(kkl,7),{val(GpsLat),val(GpsLon)}})
            DBGoTo(Ceiling(nLen_aCrdOrig/4*3));    AAdd(aCenter, {str(kkl,7),{val(GpsLat),val(GpsLon)}})
          else
            aCenter := CenterSeek(aCrdOrig, nCntCenter, .t.)
          EndIf
          // outlog(__FILE__,__LINE__,nCntCenter)


          // кластеризация
          // outlog(__FILE__,__LINE__,'aCenter ',aCenter)
          aCrd := kmeans(aCrdOrig,@aCenter, .t.) // lGpsDist
          // outlog(__FILE__,__LINE__,'aCenter ',aCenter)
          // outlog(__FILE__,__LINE__,len(aCrd[1]), len(aCrd[2])   )
          // начальный заменяем
          aClasterS[nClaster] := Aclone(aCrd[1])
          For i:=2 To Len(aCrd)
            Aadd(aClasterS,Aclone(aCrd[i]))
          Next
          // сохранение к-т центронов
          aClasterSCenter[nClaster] := Aclone(aCenter[1])
          For i:=2 To Len(aCenter)
            Aadd(aClasterSCenter,Aclone(aCenter[i]))
          Next

          exit

        EndIf
      Next
      If !lRun_kmeans
        exit
      EndIf

    EndDo

    // запись ном кластеров к точкам
    nCntCenter:=LEN(aClasterS)
    For c:=1 To nCntCenter
      aCrd4Center:=aClasterS[c]
      For i:=1 to len(aCrd4Center)
        locate for kkl = val(aCrd4Center[i,1])
        repl klaster with c
      Next i
    Next c

  Else
    repl all Klaster with 1
  EndIf
  aCrdOrig:={}
  aCenter:={}
  aCrd:={}
  aClasterS:={}

  // сохранение очередности, еще одни элемент
  For i:=1 To LEN(aClasterSCenter)
    aadd(aClasterSCenter[i],i)
  Next i

  If len(aClasterSCenter) > 1
    // дистанция от центронов до 20034
    // поиск минимального  - сортировка

    //outlog(__FILE__, __LINE__, aClasterSCenter)

    kln->(netseek('t1','20034'))
    aClasterSCenter := ASORT(aClasterSCenter,,,{|x1,x2,x1d,x2d|;
    x1d :=  GMA_DistMatr(;
    allt(kln->GpsLat)+','+allt(kln->GpsLon),;
    str(x1[2,1],10,7)+','+str(x1[2,2],10,7);
   ),;
    x2d := GMA_DistMatr(;
    allt(kln->GpsLat)+','+allt(kln->GpsLon),;
    str(x2[2,1],10,7)+','+str(x2[2,2],10,7);
   ),;
    ;//outlog(__FILE__,__LINE__,allt(kln->GpsLat)+','+allt(kln->GpsLon)),;
    ;//outlog(__FILE__,__LINE__,str(x1[2,1],10,7)+','+str(x1[2,2],10,7)),;
    ;//outlog(__FILE__,__LINE__,str(x2[2,1],10,7)+','+str(x2[2,2],10,7)),;
    ;//outlog(__FILE__,__LINE__,x1d,x2d),;
    x1d < x2d;
        })
    //outlog(__FILE__, __LINE__, aClasterSCenter)
  EndIf


  // обработка кластеров
  For i:=1 To LEN(aClasterSCenter)
    @ MaxRow(), 0 say 'Маршруты кластеры    '+str(i,2)+'/'+str(LEN(aClasterSCenter),2)  color 'B/W'
    sele lkkl
    // текущий кластер и уникальные к-ты
    ordsetfocus('UniCord')
    FileDelete('tmp_dire.*')
    copy to tmp_dire for Klaster = aClasterSCenter[i][3]
    use tmp_dire new

    Do Case
    Case i = 1
      klnOrigin:=20034
      nAdd:=0
    Case i = LEN(aClasterSCenter)
      //
    OtherWise
      // см ниже!!!
      // klnOrigin := kkl // новая стартовая точка
    EndCase

    // точка прибытия Destination
    Do Case
    Case LEN(aClasterSCenter) = 1 // одини кластер
      klnDestination:=20034
    Case i = LEN(aClasterSCenter) // последний кластер
      klnDestination:=20034
    OtherWise
      // в любую точку из след кластера

      sele lkkl
      locate for Klaster = aClasterSCenter[i+1][3]
      klnDestination:=lkkl->Kkl
      //  outlog(__FILE__,__LINE__,klnDestination,Klaster)
      // может вычислить минимальную дистаную ?
    EndCase

    // outlog(__FILE__,__LINE__,klnOrigin,klnDestination,nAdd)
    sele tmp_dire
    If lGMApi
      GMA_Direct(klnOrigin,klnDestination,nAdd)
    Else
      VizitApiDirect(klnOrigin,klnDestination,nAdd)
    EndIf

    // перенос результатов
    sele tmp_dire

    nAdd += LastRec()
    DBGoTop()
    Do While !eof()
      sele lkkl
      locate for lkkl->kkl = tmp_dire->kkl
      repl npp with tmp_dire->npp
      sele tmp_dire
      DBSkip()
    EndDo

    sele tmp_dire
    index on npp tag t1
    DBGoBottom()
    klnOrigin := kkl // новая стартовая точка
    close tmp_dire

  Next i

  sele lkkl
  DubleCoord()

  OrdSetFocus(0)

  lkklNppSort()

  RestScreen(0,0,MaxRow(),MaxCol(),cSaveSreen)
  RETURN (NIL)

  /*
  */




/*****************************************************************
 
 FUNCTION:
 АВТОР..ДАТА..........С. Литовка  09-25-17 * 12:59:20pm
 НАЗНАЧЕНИЕ.........
 ПАРАМЕТРЫ..........
 ВОЗВР. ЗНАЧЕНИЕ....
 ПРИМЕЧАНИЯ.........
 */
STATIC FUNCTION GMA_Direct(klnOrigin,klnDestination,nAdd)
  LOCAL cErrSysCmd := cLogSysCmd := cSysCmd := ""
  LOCAL cL, oTsp, nRecCnt, i
  LOCAL cGMA_Url, cUrl, cWGetPhp, cUrlWGet, nHandle
  LOCAL cKeyAuthor:='AIzaSyDyRfRMBxeyZexHK3ZHCNFvG1yxUndqICI'
  LOCAL cKeyWget, nCase
  LOCAL cFile_wget,  cFile_json

  DEFAULT klnOrigin TO 20034, klnDestination TO 20034, nAdd TO 0

  cFile_wget:='_tspg.wget'
  cFile_json:='_tspg.json'

  cGMA_Url:='https://maps.googleapis.com/maps/api/directions/json?'
  cWGetPhp:='http://10.0.1.113/maps/api/directions/json.php?'
  cUrlWGet:='http://10.0.1.113/wget-https.php?url='

  cUrl:=""
  count to nRecCnt
  // поиск первой точки -1
  locate for npp = -1
  nRecFirst:=0
  // origin=Adelaide,SA // начало маршрута
  cUrl+='origin='
  If found()
    nRecFirst:=RecNo()
    cKeyWget:=allt(GpsLat)+','+allt(GpsLon)
  else
    klnOrigin:=allt(str(klnOrigin))
    kln->(netseek('t1',klnOrigin))
    cKeyWget:=allt(kln->GpsLat)+','+allt(kln->GpsLon)
  EndIf
  cUrl += cKeyWget

  // &destination=Adelaide,SA // конец маршрута
  klnDestination:=allt(str(klnDestination))
  kln->(netseek('t1',klnDestination))
  cUrl += '&'+'destination='
  cKeyWget:=allt(kln->GpsLat)+','+allt(kln->GpsLon)

  cUrl += cKeyWget // кольцевой

  // '&waypoints=optimize:true' // оптимизация маршрута
  cUrl += '&waypoints=optimize:true' // оптимизация маршрута

  // ordsetfocus('UniCord')

  DBGoTop()
  // DBGoBottom();  DBSkip(-2)
  Do While !eof()
    If nRecFirst # RecNo()
      If empty(GpsLat)
        //cUrl+='|'+ UrlParamEncode('"'+allt(agp_full)+'"')
      Else
        cUrl+='|'+allt(GpsLat)+','+allt(GpsLon)
      EndIf
    EndIf
    DBSkip()
  EndDo

  cUrl+=('&'+'key=' + cKeyAuthor)

  nCase:=2
  Do Case
  Case  nCase = 1
    // cWGetPhp:='http://10.0.1.113/maps/api/directions/json.php?'
    cWGetPhp += cUrl
    cUrlWGet := cWGetPhp
    // вывод в файл
    nHandle:=fcreate(cFile_wget)
      fwrite(nHandle,cUrlWGet)
    fclose(nHandle)
    /*
    SET CONSOLE OFF;  SET PRINT ON;  SET PRINT TO (cFile_wget)
    ??cWGetPhp
    SET PRINT TO ;  SET PRINT OFF
    */
  Case  nCase = 2
    // cGMA_Url:='https://maps.googleapis.com/maps/api/directions/json?'
    cUrl := cGMA_Url + cUrl
    cUrl:=base64encode(cUrl)
    cUrl:=CharRem(CHR(10),cUrl)
    // cUrlWGet:='http://10.0.1.113/wget-https.php?url='
    cUrlWGet += cUrl
    nHandle:=fcreate(cFile_wget)
      fwrite(nHandle,cUrlWGet)
    fclose(nHandle)

  OtherWise

  EndCase


  cErrSysCmd := cLogSysCmd := cSysCmd := ""
  cSysCmd += "wget ";
          +'-O ' +  cFile_json + ' ' ;
          +'-i ' +  cFile_wget
  SYSCMD(cSysCmd,"" ,@cLogSysCmd,@cErrSysCmd)
   // outlog(__FILE__,__LINE__,cSysCmd, ,cLogSysCmd,cErrSysCmd)

  cL := memoread(cFile_json)
  cL := CHARREM(CHR(10),cL)

   // outlog(__FILE__,__LINE__,cL)

   If len(cL) = 0
     wmess('Запрос Расчета маршрута не просчитан',5)
     RETURN (NIL)
   EndIf

  oTsp:=JsonDecode(cL)

  If !(UPPER(oTsp['status']) = 'OK')
    Do Case
    Case UPPER(oTsp['status']) = 'ZERO_RESULTS'
      wmess('Запрос Расчета маршрута не просчитан ' + oTsp['status'],5)
    // Case
    OtherWise
      outlog(__FILE__,__LINE__,oTsp['error_message'])
      wmess('Запрос Расчета маршрута не просчитан ' + oTsp['status'],5)

    EndCase
    RETURN (NIL)
  EndIf
   // outlog(__FILE__,__LINE__,oTsp)
  // outlog(__FILE__,__LINE__,oTsp['routes']) //['waypoint_order']
  // outlog(__FILE__,__LINE__,oTsp['routes'][1]['waypoint_order']) //

  // OrdSetFocus(0)

  For i:=1 To len(oTsp['routes'][1]['waypoint_order'])
    nRec:=oTsp['routes'][1]['waypoint_order'][i] // на какую перейти
    DBGoTop()
    DBSkip(nRec)
    netrepl('npp', { i + nAdd })
  Next


  RETURN (NIL)

/*****************************************************************
 
 FUNCTION:
 АВТОР..ДАТА..........С. Литовка  09-26-17 * 11:44:57am
 НАЗНАЧЕНИЕ.........
 ПАРАМЕТРЫ..........
 ВОЗВР. ЗНАЧЕНИЕ....
 ПРИМЕЧАНИЯ.........
 */
STATIC FUNCTION VizitApiDirect(klnOrigin,klnDestination,nAdd)
  LOCAL cErrSysCmd := cLogSysCmd := cSysCmd := ""
  LOCAL cL, oTsp, nRecCnt
  LOCAL cWGetApi:='http://api.visicom.ua/data-api/3.0/core/tsp.json?'
  LOCAL cKeyAuthor:='68a3781162ee36af7054bcc5723a22a1'
  LOCAL cRound_trip:='false' //'true'
  LOCAL cFile_wget,  cFile_json
  LOCAL cCoord, nRec, nNpp2

  // формирование строки
  cWGetApi+='waypoints='

  count to nRecCnt
  nRecCnt:=0
  // поиск первой точки -1
  locate for npp = -1
  nRecFirst:=0
  If found()
    nRecFirst:=RecNo()
    cWGetApi+=allt(GpsLon)+','+allt(GpsLat)+'|'
  else
    klnOrigin:=allt(str(klnOrigin))
    kln->(netseek('t1',klnOrigin))
    cWGetApi+=allt(kln->GpsLon)+','+allt(kln->GpsLat)+'|'
    nRecCnt++
  EndIf

  //index on GpsLat+GpsLon tag t2 uniq

  DBGoTop()
  Do While !eof()
    If nRecFirst # RecNo()
      cWGetApi+=allt(GpsLon)+','+allt(GpsLat)+'|'
      nRecCnt++
    EndIf
    DBSkip()
  EndDo
  // конец маршрута
  klnDestination:=allt(str(klnDestination))
  kln->(netseek('t1',klnDestination))
  cWGetApi+=allt(kln->GpsLon)+','+allt(kln->GpsLat)+'|'
      nRecCnt++
  outlog(__FILE__,__LINE__,'nRecCnt',nRecCnt)
  cWGetApi:=left(cWGetApi,len(cWGetApi)-1) // del последний разграничитель

  cWGetApi+='&round_trip='+ cRound_trip
  cWGetApi+='&mode='+ 'driving'
  //cWGetApi+='&mode='+ 'driving-shortest'
  cWGetApi+=('&'+'key=' + cKeyAuthor)


  cFile_wget:='_tspv.wget'
  cFile_json:='_tspv.json'
  // вывод в файл
  SET CONSOLE OFF;  SET PRINT ON
  SET PRINT TO (cFile_wget)
  ??cWGetApi
  SET PRINT TO ;  SET PRINT OFF

  cErrSysCmd := cLogSysCmd := cSysCmd := ""
  cSysCmd += "wget ";
          +'-O ' +  cFile_json + ' ' ;
          +'-i ' +  cFile_wget
  SYSCMD(cSysCmd,"" ,@cLogSysCmd,@cErrSysCmd)

   cL := memoread(cFile_json)
   cL := CHARREM(CHR(10),cL)

   If len(cL) = 0
     wmess('Запрос Расчета маршрута не просчитан',5)
     RETURN (NIL)
   EndIf
   // outlog(__FILE__,__LINE__,cL)

   oTsp:=JsonDecode(cL)

   // outlog(__FILE__,__LINE__,nRecCnt,oTsp)
   // outlog(__FILE__,__LINE__,len(oTsp['list']),oTsp['list'])
   // outlog(__FILE__,__LINE__,oTsp['list'][1],oTsp['list'][2])
   // outlog(__FILE__,__LINE__,oTsp['list'][1]['index'],oTsp['list'][2]['index'])

  If nRecFirst = 0 // nRecCnt <= 24

    For i:=1 To len(oTsp['list'])
      nRec:=oTsp['list'][i]['index'] // на какую перейти
      If nRec # 0
        DBGoTop()
        DBSkip(nRec-1)
        netrepl('npp', { (i-1) + nAdd})
      EndIf
    Next

  Else

  EndIf

  RETURN (NIL)

/*****************************************************************
 
 FUNCTION:
 АВТОР..ДАТА..........С. Литовка  09-28-17 * 08:01:03pm
 НАЗНАЧЕНИЕ......... заполнение дублированных координат
 ПАРАМЕТРЫ..........
 ВОЗВР. ЗНАЧЕНИЕ....
 ПРИМЕЧАНИЯ.........
 */
STATIC FUNCTION DubleCoord()
  OrdSetFocus(0)
  repl npp2 with (npp * 10) all for npp # -8

  Do While .t.
    locate for npp2 = 0 .and. npp # -8
    cCoord := GpsLat+GpsLon

    If found()
      locate for npp2 # 0 .and. cCoord = GpsLat+GpsLon
      nNpp2 := Npp2
      i:=1
      locate for npp2 = 0 .and. cCoord = GpsLat+GpsLon
      Do While found()
        repl npp2 with nNpp2 + (i++)
        continue
      EndDo

    Else
      exit
    EndIf

  EndDo
  RETURN (NIL)


/*****************************************************************
 
 FUNCTION:
 АВТОР..ДАТА..........С. Литовка  10-25-17 * 01:20:49pm
 НАЗНАЧЕНИЕ......... перестройка таблицы
 ПАРАМЕТРЫ..........
 ВОЗВР. ЗНАЧЕНИЕ....
 ПРИМЕЧАНИЯ.........
 */
STATIC FUNCTION lkklNppSort()
  sort to lkklnpp on npp2
  use lkklnpp new Exclusive
  repl npp with recno() all
  close

  sele lkkl
  copy to lkkl0
  zap
  append from lkklnpp
  RETURN (NIL)

/*****************************************************************
 
 FUNCTION:
 АВТОР..ДАТА..........С. Литовка  10-27-17 * 01:48:55pm
 НАЗНАЧЕНИЕ.........
 ПАРАМЕТРЫ..........
 ВОЗВР. ЗНАЧЕНИЕ....
 ПРИМЕЧАНИЯ.........
 */
FUNCTION  KommVoya(nRecCnt)
  LOCAL aM:={}, i, c, x1,y1,x2,y2, nXY2D
  LOCAL aRow:={}
  nRecCnt:=4
  For i:=0 To nRecCnt
    AADD(aRow,i)
  Next
  AADD(aM,aRow)

  For i:=1 To nRecCnt
    aRow:={}
    AADD(aRow,i)
    For c:=1 To nRecCnt
      If c = i // сопадают
        AADD(aRow,{NIL,0})
      Else
        If .t.
          DBGoTop();DBSkip(i-1)
          x1:=GpsLat
          y1:=GpsLon
          DBGoTop();DBSkip(c-1)
          x2:=GpsLat
          y2:=GpsLon
          outlog(__FILE__,__LINE__,'  x1,y1,x2,y2',x1,y1,x2,y2)

          nXY2D :=  GMA_DistMatr(allt(x1)+','+allt(y1),;
          allt(x2)+','+allt(y1))

        Else
          DBGoTop();DBSkip(i-1)
          x1:=val(GpsLat)
          y1:=val(GpsLon)
          DBGoTop();DBSkip(c-1)
          x2:=val(GpsLat)
          y2:=val(GpsLon)
          nXY2D:=LatLng2Distance(x1,y1,x2,y2)
        EndIf
          outlog(__FILE__,__LINE__,'  dist',nXY2D)
        AADD(aRow,{nXY2D,0})
      EndIf
    Next c
    AADD(aM,aRow)
  Next i

  For i:=1 To nRecCnt+1
    outlog(__FILE__,__LINE__,aM[i])
  Next
  RETURN (NIL)
