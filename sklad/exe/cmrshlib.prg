/***********************************************************
 * Модуль    : cmrshlib.prg
 * Версия    : 0.0
 * Автор     :
 * Дата      : 05/10/17
 * Изменен   :
 * Примечание: Текст обработан утилитой CF версии 2.02
 */
#include "common.ch"
#include "inkey.ch"

/***********************************************************
 * Mrshins() -->
 *   Параметры :
 *   Возвращает:
 */
function MrshIns(p1)
  clmins=setcolor('gr+/b,n/w')
  wmins=wopen(4, 10, 19, 70)
  wbox(1)
  if (p1=nil)
    store 0 to Mrshr, kecsr, ktar, ktor, przr, aSdvr, KATranr, KATranPr, vMrshr, mrstr, kmr, kmpr, ogrpodr, grpodr, grpodpr, premr, Mrshpr, svczr
    store 1 to atranr
    store space(10) to nMrshr, anomr, necsr, nktar, nktor, nvMrshr
    store space(15) to dfoir
    dMrshr=date()
    dtpoer=date()
    store '' to natranr, natranpr
  endif

  go mrc_r
  if (przr=0.and.prandr#1)
    @ 0, 1 say 'Маршр.лис т    '+' '+str(Mrshr, 6)
    @ 0, 25 get nMrshr
    @ 1, 1 say 'Направление    ' get vMrshr pict '999' valid vMrsh1()
    @ 1, 25 say nvMrshr
    @ 2, 1 say 'Автомобиль     ' get KATranr pict '9999999' valid KATran()
    @ 2, 25 say natranr
    @ 3, 1 say 'Прицеп         ' get KATranPr pict '9999999' ;
                valid KATranP()  .and.  Iif(KATranPr#0,KATranr#0,.T.)

    @ 3, 25 say natranpr
    @ 5, 1 say 'Водитель       '+' '+dfior
    @ 6, 1 say 'Экспедитор     '+' '+str(kecsr, 3)+' '+getfield('t1', 'kecsr', 's_tag', 'fio')
    @ 7, 1 say 'Маршр.составил '+getfield('t1', 'ktar', 'speng', 'fio')
    @ 8, 1 say 'Распечатал     '+getfield('t1', 'ktor', 'speng', 'fio')
    @ 9, 1 say 'Расстояние     '+' '+str(mrstr, 5)
    @ 10, 1 say 'Без накладных  '+' '+str(premr, 1)
    if (gnEnt=20.and.gnEntRm=1)
      @ 10, col()+1 say 'Центрозавоз'+' '+str(svczr, 1)
    endif

    @ 11, 1 say 'Дата поездки   '+' '+dtoc(dtpoer)
    @ 12, 1 say 'Сумма АТ       '+' '+str(aSdvr, 10, 2)
    if (gnEnt=20)
      @ 13, 1 say 'Маршрут-родит. '+' '+str(Mrshpr, 6)
    endif

    read
    if (lastkey()=K_ESC)
      wclose(wmins)
      setcolor(clmins)
      return
    endif

    @ 5, 1 say 'Водитель       ' get dfior
    @ 6, 1 say 'Экспедитор     ' get kecsr pict '999' valid ecs()
    necsr=getfield('t1', 'kecsr', 's_tag', 'fio')
    @ 6, 25 say necsr
    @ 7, 1 say 'Маршр.составил '+getfield('t1', 'ktar', 'speng', 'fio')
    @ 8, 1 say 'Распечатал     '+getfield('t1', 'ktor', 'speng', 'fio')
    @ 9, 1 say 'Расстояние     ' get mrstr pict '99999'
    @ 10, 1 say 'Без накладных  ' get premr pict '9'
    if (gnEnt=20.and.gnEntRm=1)
      @ 10, col()+1 say 'Центрозавоз' get svczr pict '9'
    endif

    read
    @ 11, 1 say 'Дата поездки   ' get dtpoer
    if (mrstr#0)
      aSdvr=mrstr*(kmr+kmpr)
    endif

    @ 12, 1 say 'Сумма АТ       ' get aSdvr pict '9999999.99'
    if (gnEnt=20)
      @ 13, 1 say 'Маршрут-родит. ' get Mrshpr pict '999999' valid Mrshp()
    endif

    read
  else
    @ 0, 1 say 'Маршр.лист     '+' '+str(Mrshr, 6)+' '+nMrshr
    @ 1, 1 say 'Направление    '+' '+str(vMrshr, 3)+' '+nvMrshr
    @ 2, 1 say 'Автомобиль     '+' '+str(KATranr, 7)+' '+natranr
    @ 3, 1 say 'Прицеп         '+' '+str(KATranPr, 7)+' '+natranpr
    @ 5, 1 say 'Водитель       '+' '+dfior
    @ 6, 1 say 'Экспедитор     '+' '+getfield('t1', 'kecsr', 's_tag', 'fio')
    @ 7, 1 say 'Маршр.составил '+' '+getfield('t1', 'ktar', 'speng', 'fio')
    @ 8, 1 say 'Распечатал     '+' '+getfield('t1', 'ktor', 'speng', 'fio')
    @ 9, 1 say 'Расстояние     ' get mrstr pict '99999'
    @ 10, 1 say 'Без накладных  ' get premr pict '9'
    if (gnEnt=20.and.gnEntRm=1)
      @ 10, col()+1 say 'Центрозавоз' get svczr pict '9'
    endif

    @ 11, 1 say 'Дата поездки   '+' '+dtoc(dtpoer)
    @ 12, 1 say 'Сумма АТ       '+' '+str(aSdvr, 10, 2)
    read
    if (mrstr#0)
      aSdvr=mrstr*(kmr+kmpr)
    endif

    @ 12, 1 say 'Сумма АТ       ' get aSdvr pict '9999999.99'
    if (gnEnt=20)
      @ 13, 1 say 'Маршрут-родит. '+' '+str(Mrshpr, 6)
    endif

    read
  endif

  if (lastkey()=K_ESC)
    wclose(wmins)
    setcolor(clmins)
    return
  endif

  wselect(wmins)
  mminsr=0
  @ 13, 44 prom 'Верно'
  @ 13, col()+1 prom 'Не Верно'
  menu to mminsr
  ogrpodr=grpodr+grpodpr
  if (przr=0)
    sele cMrsh
    if (mminsr=1)
      if (!netseek('t1', '0,Mrshr'))
        if (p1=nil)
          sele setup
          locate for ent=gnEnt
          reclock()
          if (nMrsh=0)
            repl nMrsh with 1
          endif

          Mrshr=nMrsh
          while (.t.)
            sele cMrsh
            if (netseek('t2', 'Mrshr'))
              Mrshr=Mrshr+1
              loop
            endif

            sele setup
            netrepl('nMrsh', {Mrshr+1})
            exit
          enddo

          sele cMrsh
          netadd()
          netrepl('prz,Mrsh,nMrsh,atran,dMrsh,kto,kta,kecs,anom,dfio,atrc,mSdv,vMrsh,prem',               ;
                   {0,Mrshr,nMrshr,atranr,dMrshr,ktor,gnKto,kecsr,anomr,dfior,atrcr,aSdvr,vMrshr,premr}, 1 ;
                )
          if (fieldpos('dtpoe')#0)
            netrepl('dtpoe,KATran', {dtpoer,KATranr})
          endif

          if (fieldpos('mrst')#0)
            netrepl('mrst', {mrstr})
          endif

          if (fieldpos('ogrpod')#0)
            netrepl('ogrpod', {ogrpodr})
          endif

          if (fieldpos('KATranP')#0)
            netrepl('KATranP', {KATranPr})
          endif

          if (fieldpos('Mrshp')#0)
            netrepl('Mrshp', {Mrshpr})
          endif

          if (fieldpos('svcz')#0)
            netrepl('svcz', {svczr})
          endif

          rcMrshr=RecNo()
          rcMrsh1r=RecNo()
          rcMrsh2r=RecNo()
        endif

      else
        go rcMrshr
        if (p1=1)
          netrepl('nMrsh,atran,kto,kta,kecs,anom,dfio,mSdv,vMrsh,prem',              ;
                   {nMrshr,atranr,ktor,gnKto,kecsr,anomr,dfior,aSdvr,vMrshr,premr}, 1 ;
                )
          if (fieldpos('dtpoe')#0)
            netrepl('dtpoe,KATran', {dtpoer,KATranr})
          endif

          if (fieldpos('mrst')#0)
            netrepl('mrst', {mrstr})
          endif

          if (fieldpos('KATranP')#0)
            netrepl('KATranP', {KATranPr})
          endif

          if (fieldpos('ogrpod')#0)
            netrepl('ogrpod', {ogrpodr})
          endif

          if (fieldpos('Mrshp')#0)
            netrepl('Mrshp', {Mrshpr})
          endif

          if (fieldpos('svcz')#0)
            netrepl('svcz', {svczr})
          endif

        endif

      endif

    endif

  else
    netrepl('mSdv,prem', {aSdvr,premr}, 1)
    if (fieldpos('mrst')#0)
      netrepl('mrst', {mrstr}, 1)
    endif

  endif

  wclose(wmins)
  setcolor(clmins)
  return (.t.)

/***********************************************************
 * matran() -->
 *   Параметры :
 *   Возвращает:
 */
function matran()
  local getlist:={}
  sele atran
  if (atranr#0)
    if (!netseek('t1', 'atranr'))
      atranr=0
    endif

  endif

  if (atranr=0)
    go top
    wselect(0)
    atranr=slcf('atran', 10, 60,,, "e:atran h:'Код' c:n(2) e:natran h:'Транспорт' c:с(10) e:grpod h:'Гп' c:n(2)", 'atran',,,,,, 'Транспорт')
    wselect(wmins)
  endif

  locate for atran=atranr
  natranr=natran+' '+str(grpod, 4, 1)+' тн'+space(10)
  @ 3, 18 say natranr
  sele cMrsh
  return (.t.)

/***********************************************************
 * ecs() -->
 *   Параметры :
 *   Возвращает:
 */
function ecs()
  local getlist:={}
  sele s_tag
  if (kecsr#0)
    if (!netseek('t1', 'kecsr'))
      kecsr=0
    endif

  endif

  if (kecsr=0)
    go top
    wselect(0)
    kecsr=slcf('s_tag',,,,, "e:kod h:'Код' c:n(3) e:fio h:'' c:с(30)", 'kod',,,,,, 'Экспедиторы')
    wselect(wmins)
  endif

  locate for kod=kecsr
  necsr=fio
  @ 6, 25 say necsr
  sele cMrsh
  return (.t.)

/***********************************************************
 * rslea() -->
 *   Параметры :
 *   Возвращает:
 */
static function rslea()
  rswr++
  if (rswr>=rlistr)
    rswr=1
    lstr++
    eject
    AtSh()
  endif

  return

/***********************************************************
 * atsh() -->
 *   Параметры :
 *   Возвращает:
 */
static function AtSh()
  ?'Маршрутный лист N '+str(Mrshr, 6)+ ' '+iif(przr=1.and.lstr=1, 'Копия', '')
  rslea()
  ?'Маршрут '+alltrim(nMrshr)+' '+dtoc(dtpoer) + ' вес, т:'+ STR(CMrsh->vsv, 5)+' к-во ТТ, ед:'+STR(CMrsh->CntKkl, 3)//dtoc(dMrshr)
  rslea()
  ?'Транспорт '+alltrim(natranr)+' грузоподъемность '+str(grpodr, 3)+' тн'
  rslea()
  ?'Номер '+anomr+' '+'Водитель'+' '+dfior+' '+'Экспедитор '+getfield('t1', 'kecsr', 's_tag', 'fio')
  rslea()
  //?'Загрузка '+str(mvsvr,11,3)+' кг'+' Сумма '+str(mSdvr,15,2)+' грн'+space(20)+'Лист '+str(lstr,2)
  ?' Сумма '+str(mSdvr, 15, 2)+' грн'+space(20)+'Лист '+str(lstr, 2)
  rslea()
  ?dtoc(date())+' '+time()
  rslea()
  ?'┌──┬───┬──────┬───┬───────┬──────────────────────────────┬───────────┬──────────┬──┐'
  ?'│ П│SK │  ТТН │КОП│  КОД  │      ПОЛУЧАТЕЛЬ              │   СУММА   │  СУММА   │По│'
  ?'├──┼───┼──────┼───┼───────┼──────────────────────────────┼───────────┼──────────┼──┤'
  rslea()

  return (nil)

/***********************************************************
 * rsleo() -->
 *   Параметры :
 *   Возвращает:
 */
function rsleo()
  rswr++
  if (rswr>=rlistr)
    rswr=1
    lstr++
    eject
    otchsh()
  endif

  return

/***********************************************************
 * otchsh() -->
 *   Параметры :
 *   Возвращает:
 */
function otchsh()
  ?'Отчет загрузки автотранспорта за '+dtoc(dtotchr)
  rsleo()
  ?dtoc(date())+' '+time()
  rsleo()
  ?'┌──────┬──────────┬────┬──────┬──────────┬──────┬──────┬───────────────┬──────────────┬─┐'
  ?'│ Ном  │Наименован│ КM │ А ном│Автотрансп│  Вес │ Сумма│  Экспедитор   │   Составил   │П│'
  ?'├──────┼──────────┼────┼──────┼──────────┼──────┼──────┼───────────────┼──────────────┼─┤'
  rsleo()

  return (nil)

/***********************************************************
 * czgend() -->
 *   Параметры :
 *   Возвращает:
 */
function CzgEnd()
  sele czg
  set orde to tag t2
  if (netseek('t2', 'Mrshr'))
    kklr=kkl
    skr=sk
    entr=ent
    store 0 to vsvr, Sdvr, SdvUr, cntKklr, vsvbr, cvsvr, cSdvr, cvsvbr
    crtt('temp', "f:kkl c:n(7) f:cnt c:n(3) ")
    sele 0
    use temp
    sele czg
    sk_r=0
    while (Mrsh=Mrshr)
      sele czg
      vsvr=vsvr+vsv
      vsvbr=vsvbr+vsvb
      Sdvr=Sdvr+Sdv
      SdvUr=SdvUr+SdvU
      skr=sk
      entr=ent
      d0k1r=d0k1
      ttnr=ttn
      kklr=kkl
      dvzttnr=dvzttn
      mppsfr=mppsf
      if (fieldpos('vz')#0)
        vzr=vz
      else
        vzr=0
      endif

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

      sele temp
      locate for kkl=kklr
      if (!FOUND())
        netadd()
        netrepl('kkl', {kklr})
      endif

      sele czg
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
          sele czg
          skip
          loop
        endif

      endif

      dopr=ctod('')
      topr=space(8)
      if (d0k1r=0)
        if (select('rs1')#0)
          sele rs1
          if (netseek('t1', 'ttnr',,, 1))
            if (vzr=0)
              netrepl('Mrsh,kecs,atnom', {Mrshr,kecsr,anomr})
            else
              netrepl('kecs,atnom', {kecsr,anomr})
            endif

            dopr=dop
            topr=top
            ttnpr=ttnp
            ttncr=ttnc
            kplr=kpl
            dvzttnr=dvzttn
            mppsfr=ppsf
            vsvr=vsv
            vsvbr=vsvb
            Sdvr=Sdv
          else
            vsvr=0
            vsvbr=0
            Sdvr=0
          endif

          sele czg
          netrepl('vsv,vsvb,Sdv', {vsvr,vsvbr,Sdvr})
          cvsvr=cvsvr+vsvr
          cvsvbr=cvsvbr+vsvbr
          cSdvr=cSdvr+Sdvr
          if (!empty(dopr))
            netrepl('dop,top', {dopr,topr})
          endif

          if (fieldpos('ttnp')#0)
            netrepl('ttnp,ttnc', {ttnpr,ttncr})
          endif

          if (fieldpos('kpl')#0)
            netrepl('kpl', {kplr})
          endif

          if (!empty(dvzttnr))
            netrepl('dvzttn', {dvzttnr})
          endif

          netrepl('mppsf', {mppsfr})
        endif

      else
        if (select('pr1')#0)
          sele pr1
          if (netseek('t2', 'ttnr',,, 1))
            netrepl('Mrsh', {Mrshr})
          endif

        endif

      endif

      sele czg
      skip
    enddo

    nuse('rs1')
    nuse('pr1')
    //   nuse('tovpt')
    sele temp
    go top
    cntKklr=recc()
    close
    erase temp.dbf
    sele cMrsh
    netrepl('Sdv,vsv,cntkkl', {cSdvr,cvsvr,cntKklr}, 1)
    if (fieldpos('vsvb')#0)
      netrepl('vsvb', {cvsvbr}, 1)
    endif

    if (fieldpos('SdvU')#0)
      netrepl('SdvU', {SdvUr}, 1)
    endif

    mvsvr=vsvr
  endif

  return

/*****************************************************************
 
 FUNCTION:
 АВТОР..ДАТА..........С. Литовка  08-21-18 * 03:03:33pm
 НАЗНАЧЕНИЕ.........
 ПАРАМЕТРЫ..........
 ВОЗВР. ЗНАЧЕНИЕ....
 ПРИМЕЧАНИЯ.........
 */
FUNCTION MrshList(prZr)
  LOCAL aChMrsh, nChMrsh
  LOCAL pr177eq2
  LOCAL aTtnUc, i, m, aListTtn, nKoef
  LOCAL nSDv
  If Empty(prZr) .or. prZr=1
    MrshListNotPrz()
  Else // маршрут доставлен  prZr=2

    // итоговая сумма для экпедитора
    filedelete('nf'+padl(allt(str(Mrshr)),6,'0')+'.*')

    Do While .T.

      If file('nf'+padl(allt(str(Mrshr)),6,'0')+'.dbf')
        aChMrsh:={'Экспидитору', 'Для кассы', 'Нет' }
      Else
        aChMrsh:={'Экспидитору', 'Нет' }
      EndIf

      nChMrsh=alert('Печатать маршрут?', aChMrsh)
      Do Case
      Case empty(nChMrsh) .or. nChMrsh=len(aChMrsh)
        //RETURN (NIL)   // отказ
        exit
      Case nChMrsh = 1 // Экспидитору
        sele czg
        set orde to tag t5
        if (netseek('t5', 'Mrshr'))

          copy to tmpczg1  while (Mrsh=Mrshr)
          netseek('t5', 'Mrshr')

          while (Mrsh=Mrshr)
            skr=sk
            ttnr=ttn
            sdvr=sdv
            kopr=kop

            dir_rr=getfield('t1', 'skr', 'cskl', 'path')
            pathr=gcPath_d+alltrim(dir_rr)
            netuse('rs1', 'rs1fp',, 1)

            if netseek('t1', 'ttnr')
              If pr177_or('2;')  // pr169=2 .or. pr139=2 .or. pr129=2
                // пропускаем
              Else // prTTn # 2 -> 0 1
                // перечитать сумму из ТТН
                if rs1fp->ttn169#0  .or. rs1fp->ttn139#0 .or. rs1fp->ttn129#0

                  // открываем "свертку" и читаем сумму
                  // путь и номер "ттн свернутой", где лежит ttnr
                  ttn_r:=0;  cPath:=''
                  rs1fp->(cPathDecode(gdTd,skr,'1;',@cPath,@ttn_r))

                  pathr=cPath + 't'+alltrim(str(ttn_r, 6))+'\'
                  if (netfile('rs1', 1))
                    netuse('rs1', 'rs1_177',, 1)
                    sele rs1_177
                    if netseek('t1', 'ttnr')
                      sdvr:=rs1_177->sdv
                      kopr:=rs1_177->kop
                    endif
                    nuse('rs1_177')

                  endif

                else // док не свернутый
                  sdvr:=rs1fp->sdv
                  kopr:=rs1fp->kop
                  If  pr169=1 // .or. pr139=1 .or. pr129=1 //pr177_or('1;') //
                    // нужна свертка
                    // флаг "документ для кассы"  - да
                    // меняем шапку - делаем пометку.
                    outlog(__FILE__,__LINE__,ttnr,sdvr,'док не свернутый')

                  EndIf
                endif
                sele czg
                czg->(netrepl('sdv,kop',{sdvr,kopr}))
              EndIf
            endif

            nuse('rs1fp')

            sele czg
            skip
          enddo
        endif

          sele czg
          netseek('t5', 'Mrshr')
          copy  to tmpczg2  while (Mrsh=Mrshr)

        MrshListNotPrz(.T.) // для Кассы

      Case nChMrsh = 2 .and. len(aChMrsh) > 2 // печать маршрута для кассы
        outlog(__FILE__,__LINE__,'печать маршрута для кассы')


        cPathCur:=pathr

        sele czg
        set orde to tag t5
        if (netseek('t5', 'Mrshr'))
          Do While .T.
              outlog(__FILE__,__LINE__,'Анализ УЦ-КА Mrshr',Mrshr)
            filedelete('lczg.*')
            filedelete('lrs1.*')
            filedelete('lcMrsh.*')

            lcrtt('lrs1','rs1')
            lindx('lrs1','rs1')

            lcrtt('lcMrsh','cMrsh')
            lindx('lcMrsh','cMrsh')

            lcrtt('lczg','czg')
            lindx('lczg','czg')

            luse('lcMrsh')
            luse('lczg')
            luse('lrs1')

            aTtnUc:={{0, {} } }

            // проверка на УЖЕ свернутые документы prXXX = 2
            pr177eq2:=.F.

            sele czg
            while (Mrsh=Mrshr)

              skr=sk
              ttnr=ttn

              dir_rr=getfield('t1', 'skr', 'cskl', 'path')
              pathr=gcPath_d+alltrim(dir_rr)
              netuse('rs1', 'rs1fp',, 1)

              if netseek('t1', 'ttnr')
                // в табл. сверкти и есть ном. ттн свернутой
                Do Case
                Case  rs1fp->pr169=1 .and. rs1fp->ttn169#0
                  //.or. pr139=1 .or. pr129=1 // pr177_or('1;') ; //
                  // .and. rs1fp->ttn169#0 .or. rs1fp->ttn139#0 .or. rs1fp->ttn129#0
                  // сохраним
                  ttnr=ttn169 //Iif(ttn169#0,ttn169,iif(ttn139#0,ttn139,iif(ttn129#0,ttn129,-1)))
                  netseek('t1', 'ttnr')

                  sele lrs1
                  locate for ttn == ttnr
                  If !found()

                    sele rs1fp
                    aRec:={}; getrec()
                    sele lrs1
                    DBAppend(); putrec()
                    netrepl('pr169',{1}) //netrepl('pr169, pr139, pr129',{0,0,0})
                    netrepl('sks,skls',{skr,czg->Ent})


                  EndIf

                Case rs1fp->pr169=1 .and. rs1fp->ttn169=0
                  // нужна свертка
                  // запоминаем склады
                  i:=AScan(aTtnUc,{|aSkTtn| skr=aSkTtn[1] })
                  If i=0 // добавлем склад
                    aadd(aTtnUc, {skr, {} } )
                    aadd(aTtnUc[len(aTtnUc),2], ttnr)
                  else // в склад добавим ТТН
                    aadd(aTtnUc[i,2], ttnr)
                  EndIf

                EndCase
              EndIf

              nuse('rs1fp')
              sele czg;     skip
            enddo

            outlog(__FILE__,__LINE__,len(aTtnUc),lrs1->(LastRec()),'len(aTtnUc),lrs1->(LastRec())')

            If len(aTtnUc) > 1  ;// есть док для Уц-ки
              .or. lrs1->(LastRec())>0 // нет свернутых
              // ok!
            else
               wmess('Нет выбранных ТТН (pr169=1) ',3)
               RETURN (NIL)
            EndIf

            // уценка -> найдены д-ки, которые помечены на уценку.
            If len(aTtnUc) > 1 //.and. gnEnt=20 //gnAdm=1

              For m:=2 To len(aTtnUc)
                aSkTtn:=aTtnUc[m]
                outlog(__FILE__,__LINE__,aSkTtn[1],aSkTtn[2],'уценка. найдены д-ки, которые помечены на уценку.')

                skr:=aSkTtn[1]
                If skr # gnSk
                  wmess('что то пошло не так.... skr # gnSk '+str(skr,3)+"#"+str(gnSk,3),3)
                  Return
                EndIf
                dir_rr=getfield('t1', 'skr', 'cskl', 'path')
                pathr=gcPath_d+alltrim(dir_rr)
                netuse('rs1', 'rs1',, 1)
                netuse('rs2', 'rs2',, 1)
                netuse('rs3', 'rs3',, 1)
                netuse('soper', 'soper_uc',, 1)

                sele rs1
                sklr=skl
                mkeep_r:=169
                kopr:=169
                cKopr=str(kopr, 3)
                cTtnUcr='ttn'+ckopr
                cMkUcr='mk'+ckopr
                cPrUcr='pr'+ckopr


                //aTypeUc:={2,0.01, NIL, NIL} // тип уценки
                //3-й % акцизного 4-тый - % без акциза
                If gnEnt=20
                  // тип уценки
                  aTypeUc:={3, NIL, 1.5, 1.5} //nPercent}
                  // по сколько собирать?
                  nKoef:=5 //200
                Else
                  // тип уценки Лодис
                  //aTypeUc:={3, NIL, 15} //nPercent}
                  //aTypeUc:={3, NIL, 12} //nPercent} 01-03-19 03:40pm
                  //aTypeUc:={3, NIL, 10} //nPercent} 06-25-19 12:49pm
                  //aTypeUc:={3, NIL, 11} //nPercent} 07-01-19 12:27pm
                  aTypeUc:={3, NIL, 10, 5} //nPercent} 07-20-20 09:37pm
                  // по сколько собирать?
                  nKoef:=2 //200
                EndIf
                // aTypeUc:={2,0.01, NIL, NIL} //коп

                // проверка на протокол ОТВ.ХР
                aListTtn:=aSkTtn[2]
                If !OtvProtTest(NIL,aListTtn)
                  // не прошло , выходим
                  nuse('rs1')
                  nuse('rs2')
                  nuse('rs3')
                  nuse('soper_uc')

                  sele czg
                  set orde to tag t5
                  netseek('t5', 'Mrshr')
                  Return

                EndIf

                If (len(aSkTtn[2]) <= nKoef)

                  aGrupListTtn:={}; aGrupSumTtn:={}
                  aListTtn:={}
                  ttnr:=0 // ini
                  sdvr:=0
                  For i:=1 To len(aSkTtn[2])

                    ttnr:=aSkTtn[2][i]
                    nSDv:=getfield('t1', 'ttnr','rs1','sdv')
                    If SDvr + nSDv < 50000 // сумма меньше sdv50000
                      //
                    else // сумма больше получится
                      aadd(aGrupSumTtn,sdvr) // закрываем группу
                      aadd(aGrupListTtn,aListTtn) // закрываем группу
                      aListTtn:={} // новая группа
                      sdvr:=0 // обнулить
                    EndIf
                    sdvr += nSDv

                    aadd(aListTtn,aSkTtn[2][i]) // добавли в группу

                  next i

                  If !Empty(aListTtn)
                    aadd(aGrupSumTtn,sdvr) // закрываем группу
                    aadd(aGrupListTtn,aListTtn) // закрываем группу
                    aListTtn:={} // новая группа
                    sdvr:=0 // обнулить
                  EndIf

                Else

                  aGrupListTtn:={}; aGrupSumTtn:={}
                  aListTtn:={}
                  ttnr:=0 // ini
                  sdvr:=0
                  For i:=1 To len(aSkTtn[2])

                    ttnr:=aSkTtn[2][i]
                    nSDv:=getfield('t1', 'ttnr','rs1','sdv')
                    If SDvr + nSDv < 50000 // сумма меньше
                      //
                    else // сумма больше получится
                      aadd(aGrupSumTtn,sdvr) // закрываем группу
                      aadd(aGrupListTtn,aListTtn) // закрываем группу
                      aListTtn:={} // новая группа
                      sdvr:=0 // обнулить
                    EndIf
                    sdvr += nSDv

                    aadd(aListTtn,aSkTtn[2][i])

                    // по сколько в группе
                    If len(aListTtn)=nKoef
                      aadd(aGrupSumTtn,sdvr) // закрываем группу
                      aadd(aGrupListTtn,aListTtn)
                      aListTtn:={}
                      sdvr:=0 // обнулить
                    EndIf
                  Next i

                  // как минимум два группы
                  If !Empty(aListTtn)
                    // сумма последней и пре
                    If (aGrupSumTtn[len(aGrupSumTtn)] + sdvr) < 50000
                      // в последнюю групп добавить
                      For i:=1 To LEN(aListTtn)
                        aadd(aGrupListTtn[len(aGrupListTtn)],aListTtn[i])
                      Next i
                    Else
                      // новая укороченная группа
                      aadd(aGrupListTtn,aListTtn)
                    EndIf

                  EndIf

                endif

                outlog(__FILE__,__LINE__,aGrupListTtn)
                //return
                // проверка на огнраничение суммы
                For i:=1 To len(aGrupListTtn)
                  aListTtn:=aGrupListTtn[i]
                  ttnr:=0 // ini
                  sdvr:=0

                  AEval(aListTtn,{|nTtn| ttnr:=nTtn, sdvr += getfield('t1', 'ttnr','rs1','sdv') })
                  If sdvr > 50000
                    // что то пошло не так....
                      wmess('что то пошло не так.... S>50кГрн ',3)
                      RETURN (NIL)

                  EndIf
                Next i

                For i:=1 To len(aGrupListTtn)
                  aListTtn:=aGrupListTtn[i]
                  outlog(__FILE__,__LINE__,aListTtn, i)
                  TtnUcr:=0 // номер ТТН уценки
                  TtnUcr:=TtnUcO(aTypeUc,aListTtn)
                  ttnr:=TtnUcr
                  netseek('t1', 'ttnr')
                  //DocPereRs()
                Next i

                nuse('rs1')
                nuse('rs2')
                nuse('rs3')
                nuse('soper_uc')

              Next m
              // AEval(aTtnUc,{|aSkTtn|outlog(__FILE__,__LINE__,aSkTtn) })
              // свернули  повторный цикл
              pr177eq2:=.F.
              close ('lcMrsh')
              close ('lczg')
              close ('lrs1')
              // послать на печать докуметов сверутых
              // а потом уже перечает мар-т для КА.

              sele czg
              set orde to tag t5
              netseek('t5', 'Mrshr')
              loop

              //return nil

            else
              pr177eq2 := (lrs1->(LastRec()) # 0)
              exit
            EndIf
          EndDo


          If pr177eq2 // есть собранные документы

            sele cMrsh
            aRec:={}; getrec()
            sele lcMrsh
            DBAppend(); putrec()

            // собираем во времмный маршрут ТТН с prXXX 0
            sele czg
            netseek('t5', 'Mrshr')
            while (Mrsh=Mrshr)

              skr=sk
              ttnr=ttn

              dir_rr=getfield('t1', 'skr', 'cskl', 'path')
              pathr=gcPath_d+alltrim(dir_rr)
              netuse('rs1', 'rs1fp',, 1)
              if netseek('t1', 'ttnr')
                // доки без признаков и опреации с Налом
                If pr169=0 .and. str(kop,3)$'169;161'
                  sele czg
                  aRec:={}; getrec()
                  sele lczg
                  DBAppend(); putrec()

                EndIf
              EndIf

              nuse('rs1fp')
              sele czg;     skip
            enddo

          EndIf

        EndIf

        // добавить в маршрут ТТН с prXXX=2 (lrs1)
        sele lcMrsh
        DBGoTop()

        sele lrs1
        DBGoTop()
        Do While !eof()
          Mrshr:=lcMrsh->Mrsh
          entr:=lrs1->skls
          skr:=lrs1->sks
          ttnr:=lrs1->ttn
          kklr:=lrs1->kpv
          dvsvr:=lrs1->vsv
          dsdvr:=lrs1->sdv
          kopr:=lrs1->Kop
          prir:=9
          vMrshnr:=getfield('t2', 'kklr', 'atvme', 'vMrsh')
          d0k1r:=0
          mppsfr:=lrs1->ppsf
          dvsvbr:=0 // ??
          dsdvur:=0 // g?? etfield('t1', 'ttnr,96', 'rs3', 'ssf')
          ktar:=lrs1->kta
          ttnpr:=lrs1->ttnp
          ttncr:=lrs1->ttnc
          kplr:=lrs1->kpl
          ztxtr:=lrs1->ztxt
          plr:=lrs1->nkkl
          gpr:=lrs1->kpv

          sele lczg
          netadd()
          netrepl('Mrsh,ent,sk,ttn,kkl,vsv,sdv,kop,pri,vMrsh,d0k1,mppsf',                            ;
                    {Mrshr, entr, skr, ttnr, kklr, dvsvr, dsdvr, kopr, prir, vMrshnr, d0k1r, mppsfr } ;
                 )
            netrepl('vsvb', {dvsvbr})
            netrepl('sdvu', {dsdvur})
            netrepl('kta', {ktar})
            netrepl('ttnp,ttnc', {ttnpr,ttncr})
            netrepl('kpl', {kplr})
            netrepl('ztxt,pl,gp', {ztxtr,plr,gpr})
            netrepl('nof', {1})


          sele lrs1
          DBSkip()
        EndDo

        sele lrs1
        sele lczg

        close ('lcMrsh')
        close ('lczg')
        close ('lrs1')

        sele cMrsh
        rccMrsh:=RecNo()

        close ('cMrsh')
        close ('czg')

        luse('lcMrsh','cMrsh')
        luse('lczg','czg')

        // печать
        MrshListNotPrz(nChMrsh = 2)

        close ('cMrsh')
        close ('czg')

        pathr:=cPathCur
        netuse('cMrsh')
        netuse('czg')

        sele ('cMrsh')
        DBGoTo(rccMrsh)

      EndCase
    EndDo

  EndIf
  RETURN (NIL)

/***********************************************************
 * Mrshlist() -->
 *   Параметры :
 *   Возвращает:
 */
static function MrshListNotPrz(lKassa)
  DEFAULT lKassa TO .F.

  filedelete('zadan.txt')

  netuse('ctov')
  if (gnRmlo=0)
    If lKassa
      atsfr=0
    Else
      aSfr:={'Да', 'Нет' }
      atSfr=alert('Печатать СФ', asfr)
    EndIf
    if (atsfr=1)
      sele czg
      set orde to tag t5
      if (netseek('t5', 'Mrshr'))
        while (Mrsh=Mrshr)
          skr=sk
          ttnr=ttn
          d0k1r=d0k1
          if (d0k1r=0)
            if (gnEnt=20)
              dir_rr=getfield('t1', 'skr', 'cskl', 'path')
              pathr=gcPath_d+alltrim(dir_rr)
              netuse('rs1', 'rs1fp',, 1)
              dfp_rr=getfield('t1', 'ttnr', 'rs1fp', 'dfp')
              nuse('rs1fp')
            else
              dfp_rr=ctod('')
            endif

            if (gnEnt=20)
              if (!empty(dfp_rr))
                save scre to scsf
                mess(str(skr, 3)+' '+str(ttnr, 6))
                prnsf()
                rest scre from scsf
              endif

            else
              save scre to scsf
              mess(str(skr, 3)+' '+str(ttnr, 6))
              prnsf()
              rest scre from scsf
            endif

          endif

          sele czg
          skip
        enddo

      endif

    endif

  endif

  netuse('ctov')

  iif(file('ttara.dbf'),FileDelete('ttara.*'),)
  crtt('ttara', 'f:kpl c:n(7) f:kgp c:n(7) f:vzt_tov c:n(1) f:vzt_tara c:n(1)')
  use ttara new Exclusive

  sele czg
  set orde to tag t5
  if (netseek('t5', 'Mrshr'))

    save scre to scsf
    while (Mrsh=Mrshr)
      kplr=kpl
      kgpr=kkl
      sele ttara
      locate for kpl=kplr
      if (!found())
        netadd()
        netrepl('kpl,kgp', {kplr,kgpr})
        // признак возврат тары или товар
      endif
      If czg->kop=180
        If .t. // тара
          repl vzt_tara with 1
        Else  // товар
          repl vzt_tov with 1
        EndIf
      EndIf

      sele czg
      skip
    enddo

    // найдем  склад тары
    SkTarar:=0
    sele cskl
    locate for ent=gnEnt.and.tpstpok=2
    if (foun())
      SkTarar=sk
      pathr=gcPath_d+alltrim(path)
      If netfile('tovm')
        netuse('tovm', 'tovmpok',, 1)
        set orde to tag t2
      EndIf
    endif

    if !empty(SkTarar) .and. select('tovmpok')#0
      if (select('KplTara')#0)
        sele KplTara
        close
      endif

      If(file('KplTara.dbf'),filedelete('KplTara.*'),)
      crtt('KplTara', 'f:kpl c:n(7) f:mntov c:n(7) f:nat c:c(40) f:nei c:c(5) f:opt c:n(10,3) f:osn c:n(10) f:osf c:n(10) f:osfo c:n(10) f:kgp c:n(7)')
      use KplTara new
      inde on str(kpl, 7)+str(mntov, 7) tag t1
      inde on str(kgp, 7)+str(kpl, 7)+str(mntov, 7) tag t2

      set orde to tag t1
      sele ttara
      go top
      while (!eof())
        kplr=kpl
        kgpr=kgp
        sele tovmpok
        if (netseek('t2', 'kplr'))
          while (skl=kplr)
            if (kg#0)
              skip
              loop
            endif

            mntovr=mntov
            mntovtr=mntovt
            if (mntovtr=0)
              mntovtr=getfield('t1', 'mntovr', 'ctov', 'mntovt')
            endif

            if (mntovtr=0)
              mntovr=mntovtr
            endif

            natr=nat
            neir=nei
            optr=opt
            osnr=osn
            osfr=osf
            osfor=osfo
            sele KplTara
            locate for kpl=kplr.and.mntov=mntovr
            if (!foun())
              netadd()
              netrepl('kpl,mntov,nat,nei,opt,osn,osf,osfo,kgp',         ;
                       {kplr,mntovr,natr,neir,optr,osnr,osfr,osfor,kgpr} ;
                    )
            else
              netrepl('osn,osf,osfo', {osn+osnr,osf+osfr,osfo+osfor})
            endif

            sele tovmpok
            skip
          enddo

        endif

        sele ttara
        skip
      enddo

      sele KplTara
      nuse('tovmpok')
    endif

    rest scre from scsf
  endif


  if (gnRmlo=0.and.select('KplTara')#0)
    sele KplTara
    atr=0
    If lKassa
      //
    Else
      if (fieldpos('kpl')#0)
        aTara:={'По возвратам', 'Всю по маршруту', 'Нет' }
        aTr=alert('Печатать Тару?', atara)
      endif
    EndIf

    if !(empty(aTr) .or. atr=len(aTara))
      // выбрали не ЕСЦ27 или последний

      do case
      case (atrcr=1.and.gnAdm=0)
        if (gnOut=1)
          vLpt=3
          vLpt1='Lpt3'
        else
          vLpt=1
          vLpt1='KplTara.txt'
        endif

      case (atrcr=2.and.gnAdm=0)
        if (gnOut=1)
          vLpt=2
          vLpt1='Lpt2'
        else
          vLpt=1
          vLpt1='KplTara.txt'
        endif

      otherwise
        vLpt=0; vLpt1=''
        vLpt(@vLpt, @vLpt1,'ПЕЧАТЬ ТАРЫ','KplTara.txt')
      endcase
      set prin to (vLpt1)
      ovLptr=vLpt

      set prin on
      set cons off
      if (vLpt=1)
        if (empty(gcPrn))
          ??chr(27)+chr(80)+chr(15)
          rlistr=62
        else
          ??chr(27)+'E'+chr(27)+'&l4h25a0O'+chr(27)+'&k2S'+chr(27)+'(3R'+chr(27)+'(s0p18.00h0s1b4102T'+chr(27)
          rlistr=43
        endif

      else
        ??chr(27)+'E'+chr(27)+'&l4h25a0O'+chr(27)+'&k2S'+chr(27)+'(3R'+chr(27)+'(s0p18.00h0s1b4102T'+chr(27)
        rlistr=43
      endif

      kplr=0
      nnnn=0
      rlist_r=0

      sele KplTara
      go top
      rcKplTara=RecNo()
      while (!eof())

        If aTr = 1 // проверка на возврат 108
          sele ttara
          locate for  kplr=kpl .and. kgpr=kgp .and. !empty(vzt_tara)

          If !found()
            sele KplTara
            DBSkip()
            loop
          EndIf

        EndIf

        if (kplr#kpl)
          if (nnnn=0)
            rcKplTara=RecNo()
            nnnn=1
          endif

          if (kplr#0)
            ?'└───────┴─────────────────────────────────────┴─────┴──────────┴──────────┴─────────┼─────────┤'
            rlist_r=rlist_r+1
            ?'                                                                      Загальна сума │         │'
            rlist_r=rlist_r+1
            ?'                                                                                    └─────────┘ '
            rlist_r=rlist_r+1
            for gg=rlist_r to rlistr-9
              ?''
            next

            ?''
            ?'Сума до сплати____________________________________________________________________________'
            ?'Керiвник________________________________________________Вiдпустив_________________________'
            ?'Головний бухгалтер__________________'
            eject
            if (nnnn=1)
              go rcKplTara
              nnnn=2
              kplr=0
              loop
            else
              nnnn=0
              kplr=0
              loop
            endif

          endif

          rlist_r=0
          kplr=kpl
          kgpr=kgp
          ?space(30)+'НАКЛАДНА N_______________'+'('+str(Mrshr, 6)+')'
          rlist_r=rlist_r+1
          ?space(20)+'вiд '+'"'+'______'+'"'+'______________________________200  р.'
          rlist_r=rlist_r+1
          ?'Вiд кого: '+str(kplr, 7)+' '+getfield('t1', 'kplr', 'kln', 'nkl')+' '+str(kgpr, 7)+' '+getfield('t1', 'kgpr', 'kln', 'nkl')
          rlist_r=rlist_r+1
          ?'Мiсце   : '+str(kgpr, 7)+' '+getfield('t1', 'kgpr', 'kln', 'nkl')
          rlist_r=rlist_r+1
          ?'Кому    : '+getfield('t1', 'gnKkl_c', 'kln', 'nkl')
          rlist_r=rlist_r+1
          ?'Через   : '+'Номер '+anomr+' '+'Водитель'+' '+dfior+' '+'експедитор '+getfield('t1', 'kecsr', 's_tag', 'fio')
          rlist_r=rlist_r+1
          ?'Пiдстава: Договiр'
          rlist_r=rlist_r+1
          ?'┌───────┬─────────────────────────────────────┬─────┬──────────┬──────────┬─────────┬─────────┐'
          rlist_r=rlist_r+1
          ?'│ Код   │           Назва                     │Вимiр│  Борг    │  Цiна    │Повернуто│  Сума   │'
          rlist_r=rlist_r+1
          loop
        else
          mntovr=mntov
          natr=nat
          neir=nei
          optr=opt
          osnr=osn
          osfr=osf
          osfor=osfo
          ?'├───────┼─────────────────────────────────────┼─────┼──────────┼──────────┼─────────┼─────────┤'
          rlist_r=rlist_r+1
          ?'│'+str(mntovr, 7)+'│'+subs(natr, 1, 37)+'│'+neir+'│'+str(osfr, 10)+'│'+str(optr, 10, 3)+'│'+space(9)+'│'+space(9)+'│'//+' '+str(round(osf*optr,2))
          rlist_r=rlist_r+1
        endif

        sele KplTara
        skip
      enddo

      If !empty(0)
        ?'└───────┴─────────────────────────────────────┴─────┴──────────┴──────────┴─────────┼─────────┤'
        rlist_r=rlist_r+1
        ?'                                                                      Загальна сума │         │'
        rlist_r=rlist_r+1
        ?'                                                                                    └─────────┘ '
        rlist_r=rlist_r+1
        for gg=rlist_r to rlistr-9
          ?''
        next

        ?''
        ?'Сума до сплати____________________________________________________________________________'
        ?'Керiвник________________________________________________Вiдпустив_________________________'
        ?'Головний бухгалтер__________________'
        eject
      EndIf
    endif

  endif

  sele ttara
  close

  if (gnRmlo=0.or.gnRmlo=1)
    // Маршрутный лист
    vLpt=0
    do case
    case (atrcr=1.and.gnAdm=0.and.!lKassa)

      if (gnOut=1)

        ovLptr=3
        vLpt1='Lpt3'
        set prin to (vLpt1)
      else
        vLpt=1
        ovLptr=vLpt
        set prin to zgat.txt
      endif

    case (atrcr=2.and.gnAdm=0.and.!lKassa)

      if (gnOut=1)
        ovLptr=2
        vLpt1='Lpt2'
        set prin to (vLpt1)
      else
        vLpt=1
        ovLptr=vLpt
        set prin to zgat.txt
      endif

    otherwise
      vLpt=0; vLpt1=''
      vLpt(@vLpt, @vLpt1, 'ПЕЧАТЬ МАРШРУТНОГО ЛИСТА','zadan.txt')
    endcase

    set prin on
    set cons off
    if (vLpt=1)
      if (empty(gcPrn))
        ??chr(27)+chr(80)+chr(15)
        rlistr=62
      else
        ??chr(27)+'E'+chr(27)+'&l4h25a0O'+chr(27)+'&k2S'+chr(27)+'(3R'+chr(27)+'(s0p18.00h0s1b4102T'+chr(27)
        rlistr=40
      endif

    else
      ??chr(27)+'E'+chr(27)+'&l4h25a0O'+chr(27)+'&k2S'+chr(27)+'(3R'+chr(27)+'(s0p18.00h0s1b4102T'+chr(27)
      rlistr=40
    endif

    rswr=1
    lstr=1
    AtSh()

    filedelete('sk169.*')
    crtt('sk169', 'f:sk c:n(3) f:nof c:n(1) f:sm c:n(12,2) f:sm_tpSdv c:n(12,2)')
    use sk169 excl new
    sele czg
    set orde to tag t5
    if (netseek('t5', 'Mrshr'))
      s96_r:=0
      s98_r:=0
      kkl_r=kkl
      while (Mrsh=Mrshr)
        skr=sk
        rascr=getfield('t1', 'skr', 'cskl', 'rasc')
        entr=ent
        ttnr=ttn
        kklr=kkl
        czgSdvr:=Sdv
        if (kklr#kkl_r.and.gnEnt#20)
          if (select('KplTara')#0)
            sele KplTara
            set orde to tag t2
            if (netseek('t2', 'kkl_r'))
              kpl_r=0
              while (kgp=kkl_r)
                if (gnEnt=21)
                  if (int(mntov/10000)=1)// Стеклотара
                    skip;  loop
                  endif
                  If osf=0
                    skip;  loop
                  EndIf

                endif

                kplr=kpl
                if (kpl_r#kplr)
                  ?'Плательщик'+' '+str(kplr, 7)+' '+getfield('t1', 'kplr', 'kln', 'nkl')
                  rslea()
                  kpl_r=kplr
                endif

                mntovr=mntov
                natr=nat
                neir=nei
                optr=opt
                osnr=osn
                osfr=osf
                osfor=osfo
                ?'│'+str(mntovr, 7)+'│'+subs(natr, 1, 37)+'│'+neir+'│'+str(osfr, 10)+'│'+str(optr, 10, 3)//+'│'+space(9)+'│'+space(9)+'│'
                rslea()
                sele KplTara
                skip
              enddo

            endif

            kkl_r=kklr
          endif

        endif

        sele czg
        if (fieldpos('npp')#0)
          Mrshnppr=npp
        else
          Mrshnppr=0
        endif

        nuse('rs1')
        nuse('rs3')
        nuse('soper')

        sele setup
        locate for ent=entr
        pathdr=gcPath_m+alltrim(nent)+'\'+gcDir_g+gcDir_d
        pathr=pathdr+alltrim(getfield('t1', 'skr', 'cskl', 'path'))
        netuse('rs1',,, 1)
        netuse('rs2',,, 1)
        netuse('rs3',,, 1)
        netuse('soper',,, 1)

        if .F. .AND. (rs1->ttn169#0  .or. rs1->ttn139#0 .or. rs1->ttn129#0)
          // !!!! нет третей базы !!!!!
          // могли пересчитать
          ttn_r:=0;  cPath:=''
          rs1->(cPathDecode(gdTd,skr,'1;',@cPath,@ttn_r))
          pathr=cPath + 't'+alltrim(str(ttn_r, 6))+'\'
          if (netfile('rs1', 1))
            nuse('rs1')
            nuse('rs2')
            nuse('rs3')
            //nuse('soper')
            netuse('rs1',,, 1)
            netuse('rs2',,, 1)
            netuse('rs3',,, 1)
            //netuse('soper',,, 1)
          endif
        endif


        tvSvr=0  //getfield('t1','ttnr','rs1','vsv')

        sele rs1
        netseek('t1', 'ttnr')
        tSdvr=Sdv
        kopr=kop
        vor=vo
        ktar=kta

        nktar=getfield('t1', 'ktar', 's_tag', 'fio')
        if (kopr=169)
          mk169r=mk169
          pr169r=pr169
          ttn169r=ttn169
          nof_r=0
          if (rascr=2.or.rascr=1.and.mk169r#0.and.pr169r#2)
            nof_r=1
          endif

          // накопление итоговый сумм
          sele sk169
          locate for sk=skr.and.nof=nof_r
          if (!foun())
            appe blank
            repl sk with skr, nof with nof_r
          endif
          repl sm with sm + czgSdvr // tSdvr - сумма с ТТН

        else
          mk169r=0
          pr169r=0
          ttn169r=0
          nof_r=0
        endif

        // промосмотреть накладную и посчитать сумму
        s96_1r:=0
        s98_1r:=0
        rs2->(iif(netseek('t1', 'ttnr'), s96s98(), nil))
        // сумма по марш.
        s96_r += s96_1r
        s98_r += s98_1r

        tSdvUr=getfield('t1', 'ttnr,96', 'rs3', 'ssf')

        qr=mod(kopr, 100)
        nofr=getfield('t1', '0,1,vor,qr', 'soper', 'nof')
        // вторая сумма - прайсовая сумма
        if (nofr=1)
          tpSdvr=getfield('t1', 'ttnr,90', 'rs3', 'bssf')
        else
          tpSdvr=0
        endif

        // накопление итоговый сумм
        sele sk169
        locate for sk=skr.and.nof=nof_r
        repl sm_tpSdv with sm_tpSdv + tpSdvr

        nuse('rs1')
        nuse('rs2')
        nuse('rs3')
        nuse('soper')
        sele czg

        if (tvsvr=0)
          tvsvr=0           // vsv
        endif

        if (tSdvr=0)
          tSdvr=Sdv // из маршрута
        endif

        kopr=kop
        nklr=getfield('t1', 'kklr', 'kgp', 'ngrpol')
        if (empty(nklr))
          nklr=getfield('t1', 'kklr', 'kln', 'nkl')
        endif

        //         ?' '+str(skr,3)+' '+str(ttnr,6)+' '+str(kopr,3)+' '+str(kklr,7)+' '+subs(nklr,1,30)+' '+str(tvsvr,11,3)+' '+str(tSdvr,10,2)
        ent1r:=entr
        entr:=ROUND(s98_1r/s96_1r*100, 0)
        if (kopr#108)
          if (nof_r=1)
            //  ??chr(27)+'(s3B'+chr(27)  // Жирный
            ?' '+str(entr, 2)+' '+str(skr, 3)+' '+str(ttnr, 6);
            +' '+str(kopr, 3)+' '+str(kklr, 7)+' '+subs(nklr, 1, 30);
            +' '+str(tSdvr, 10, 2);
            +' '+iif(nofr=1, str(tpSdvr, 10, 2), space(10));
            +' '+str(Mrshnppr, 2)+'*'
            //  ??chr(27)+'(s1B4102T'+chr(27)  // Средний
          else
            ?' '+str(entr, 2)+' '+str(skr, 3)+' '+str(ttnr, 6);
            +' '+str(kopr, 3)+' '+str(kklr, 7)+' '+subs(nklr, 1, 30);
            +' '+str(tSdvr, 10, 2);
            +' '+iif(nofr=1, str(tpSdvr, 10, 2), space(10));
            +' '+str(Mrshnppr, 2)
          endif

        else
          ?' '+str(entr, 2)+' '+str(skr, 3)+' '+str(ttnr, 6)+' '+str(kopr, 3)+' '+str(kklr, 7)+' '+subs(nklr, 1, 30)+' '+' Возврат  '+' '+space(10)+' '+str(Mrshnppr, 2)
        endif

        entr:=ent1r

        if (gnEnt=20)
          ??' '+nktar
        endif

        rslea()
        sele czg
        skip
      enddo

      sele sk169
      if (recc()#0)
        inde on str(sk, 3)+str(nof, 1) tag t1
        go top
        ?''
        rslea()
        nSm:=nSm_tpSdv:=0
        while (!eof())
          If nof=0
            nSm:=Sm
          Else
            If gnEnt=201
              nSm_tpSdv:=sm_tpSdv
            Else // 21 Лодис
              nSm_tpSdv:=Sm // так нужно  - первая колонка
              //nSm_tpSdv:=sm_tpSdv
            EndIf
          EndIf
          if (sm#0)
            ?' '+'  '+' '+str(sk, 3)+' '+str(nof, 6)+' '+space(3)+' '+space(7)+' '+space(30)+' '+str(sm, 10, 2) +' '+str(sm_tpSdv, 10, 2) //+' '+str(sm_tpSdv - sm, 10, 2)
            rslea()
          endif
          // ? nof, nSm, nSm_tpSdv
          sele sk169
          skip
        enddo

        ?space(3), ROUND(s98_r/s96_r*100, 0), nSm + nSm_tpSdv
        rslea()
      endif

    endif

    sele sk169
    If !file('nf'+padl(allt(str(Mrshr)),6,'0')+'.dbf')
      copy to ('nf'+padl(allt(str(Mrshr)),6,'0'))
    Else
      sele sk169
      sum Sm to nSumNot0 for nof=0

      // просчет суммы Нал по маршр. экспи
      use ('nf'+padl(allt(str(Mrshr)),6,'0')) new
      nSm:=nSm_tpSdv:=0
      while (!eof())

        If nof=0
          nSm:=Sm
        Else
          If gnEnt=201
            nSm_tpSdv:=sm_tpSdv
          Else // 21 Лодис
            nSm_tpSdv:=Sm // так нужно - первая колонка
            //nSm_tpSdv:=sm_tpSdv
          EndIf
        EndIf
        skip
      enddo
      ?space(3), ROUND(99, 0), ;
      transform(nSm + nSm_tpSdv,"@ER 999'999.99"),;
      space(50),;
      transform((nSm + nSm_tpSdv) - nSumNot0 ,"@R 999'999.99")

      close
    EndIf
    close sk169

    //erase sk169.dbf
    //erase sk169.cdx

    sele cMrsh
    if (gnRmlo=0)
      netrepl('kto,dMrsh', {gnKto,dMrshr}, 1)
    endif

    ?space(60)
    rslea()
    rslea()
    ?'Маршрут составил '+getfield('t1', 'cMrsh->kta', 'speng', 'fio')+'______________'
    rslea()
    rslea()
    ?'Маршрут отправил '+getfield('t1', 'ktor', 'speng', 'fio')+'______________'
    rslea()
    ?'Подпись отв.лица '+'/'+space(38)+'/'+'______________'
    rslea()
    eject

    If lKassa
      //
    Else
      if (gnEnt=20)         // Заявка экспедитору на деньги
        kolekzr=1
      else
        kolekzr=2
      endif

      for ike=1 to kolekzr
        rswr=1
        lstr=1
        MrshZsh()
        Mrshz()
        eject
      next
    EndIf

    //   endif
    if .t. .or.  gnEnt=20          // Заявка экспедитору на возврат
      If lKassa
        //
      Else
        aVzPrn={'Нет', 'Да' }
        vVzr=alert('Печатать возвраты?', aVzPrn)
        if (vVzr=2)
          PrnVzM()
        endif
      EndIf

    endif

    if (gnEnt=21)
      rswr=1
      lstr=1
       // Заявка экспедитору на тару через Заявку на КПК
      MrshZT()
    endif

    set prin off
    set prin to
    set cons on
  endif

  if (select('KplTara')#0)
    sele KplTara
    close
    erase KplTara.dbf
    erase KplTara.cdx
  endif

  if (gnRmlo=0)
    If lKassa
      atsfr=1
    Else
      atsfr=2
      asfr:={'Нет', 'Да' }
      atsfr=alert('Печатать Отборку ?', asfr)
    EndIf
    if (atsfr=2)
      set prin to
      do case
      case (ovLptr=1)
        ovLptr1='Lpt1'
      case (ovLptr=2)
        ovLptr1='Lpt2'
      case (ovLptr=3)
        ovLptr1='Lpt3'
      case (ovLptr=4)
        ovLptr1='atotb.txt'
      endcase
      set prin to (ovLptr1)

      set prin on
      set cons off
      if (ovLptr=1)
        if (empty(gcPrn))
          ??chr(27)+chr(80)+chr(15)
          rlistr=62
        else
          ??chr(27)+'E'+chr(27)+'&l4h25a0O'+chr(27)+'&k2S'+chr(27)+'(3R'+chr(27)+'(s0p18.00h0s1b4102T'+chr(27)
          //            ??chr(27)+'E'+chr(27)+'&l4h2a0O'+chr(27)+'&k2S'+chr(27)+'&a20l'+chr(27)+'(3R'+chr(27)+'(s0p17.00h0s0b4099T'+chr(27)
          rlistr=43
        endif

      else
        ??chr(27)+'E'+chr(27)+'&l4h25a0O'+chr(27)+'&k2S'+chr(27)+'(3R'+chr(27)+'(s0p18.00h0s1b4102T'+chr(27)
        //         ??chr(27)+'E'+chr(27)+'&l4h2a0O'+chr(27)+'&k2S'+chr(27)+'&a20l'+chr(27)+'(3R'+chr(27)+'(s0p17.00h0s0b4099T'+chr(27)
        rlistr=43
      endif

      if (select('atotb')#0)
        sele atotb
        close
      endif

      erase atotb.dbf
      erase atotb.cdx
      erase atoto.dbf
      erase atoto.cdx
      crtt('atoto', "f:ot c:n(2) f:not c:c(60)")
      sele 0
      use atoto excl
      inde on str(ot, 2) tag t1
      crtt('atotb', "f:ot c:n(2) f:pp c:n(1) f:not c:c(20) f:mntov c:n(7) f:nat c:c(40) f:kvp c:n(12,3) f:nei c:c(5)")
      sele 0
      use atotb excl
      inde on str(ot, 2)+str(mntov, 7) tag t1
      inde on str(ot, 2)+str(pp, 1)+nat tag t2
      sele czg
      set orde to tag t5
      if (netseek('t5', 'Mrshr'))
        if (sk=136)       // Оболонь (ent=)
          protbr=1
        else
          protbr=0
        endif

        while (Mrsh=Mrshr)
          skr=sk
          entr=ent
          ttnr=ttn
          nppr=npp
          nuse('rs2')
          nuse('tov')
          sele setup
          locate for ent=entr
          pathdr=gcPath_m+alltrim(nent)+'\'+gcDir_g+gcDir_d
          pathr=pathdr+alltrim(getfield('t1', 'skr', 'cskl', 'path'))
          skl_r=getfield('t1', 'skr', 'cskl', 'skl')
          netuse('tov',,, 1)
          netuse('rs2',,, 1)
          if (netseek('t1', 'ttnr'))
            while (ttn=ttnr)
              ktlr=ktl
              mntovr=mntov
              if (gnEnt=21)
                if (int(mntovr/10000)#503)
                  skip
                  loop
                endif

                ppr=1
              else
                do case
                case (int(mntovr/10000)=0)
                  ppr=3
                case (int(mntovr/10000)=1)
                  ppr=2
                otherwise
                  ppr=1
                endcase

              endif

              kvpr=kvp
              sele tov
              if (netseek('t1', 'skl_r,ktlr'))
                natr=nat
                neir=nei
                otr=ot
              else
                natr=''
                neir=''
                otr=0
              endif

              if (protbr=0)
                if (otr#0)
                  notr=getfield('t1', 'skr,otr', 'cskle', 'nai')
                else
                  notr=''
                endif

              else
                otr=nppr
                notr='Отсек '+str(nppr, 1)
              endif

              sele atotb
              set orde to tag t1
              if (!netseek('t1', 'otr,mntovr'))
                netadd()
                netrepl('ot,not,mntov,nat,kvp,nei,pp', {otr,notr,mntovr,natr,kvpr,neir,ppr})
              else
                netrepl('kvp', {kvp+kvpr})
              endif

              sele atoto
              if (!netseek('t1', 'otr'))
                netadd()
                notr=str(ttnr, 6)+','
                netrepl('ot,not', {otr,notr})
              else
                if (at(str(ttnr, 6), not)=0)
                  notr=alltrim(not)+str(ttnr, 6)+','
                  netrepl('not', {notr})
                endif

              endif

              sele rs2
              skip
            enddo

          endif

          nuse('rs2')
          nuse('tov')
          sele czg
          skip
        enddo

        sele atotb
        set orde to tag t2
        go top
        notr=not
        ot_r=999
        lstr=1
        rswr=1
        while (!eof())
          if (ot_r#ot)
            if (ot_r#999)
              ?'Отобрал          '+'/'+space(38)+'/'+'______________'
              //               rslet()
              ?'Принял           '+'/'+space(38)+'/'+'______________'
              //                  rslet()
              rswr=1
              lstr=lstr+1
              eject
            endif

            ot_r=ot
            notr=not
            atosh()
          endif

          ?' '+nat+' '+nei+' '+str(kvp, 12, 3)
          rslet()
          skip
        enddo

        close
        erase atotb.dbf
        erase atotb.cdx
        sele atoto
        close
        erase atoto.dbf
        erase atoto.cdx
        ?space(60)
        rslet()
        rslet()
        ?'Отобрал          '+'/'+space(38)+'/'+'______________'
        rslet()
        ?'Принял           '+'/'+space(38)+'/'+'______________'
        rslet()
      endif

      set prin off
      set prin to
      set cons on
    endif

    sele cMrsh
    if (fieldpos('przo')#0)
    //      netrepl('przo',{1})  // признак Отборки
    endif

  endif

  If file('zadan.txt')
    edFile('zadan.txt')
  EndIf

  return

/***********************************************************
 * Marshotch() -->
 *   Параметры :
 *   Возвращает:
 */
function Marshotch()
  if (gnEnt=21)
    crtt('atotch', "f:Mrsh c:n(6) f:dtpoe c:d(8) f:dn c:c(2) f:nvMrsh c:c(20) f:anom c:c(6) f:grpod c:n(4) f:vsv c:n(6) f:Sdv c:n(10,2) f:necs c:c(20) f:dfio c:c(15) f:cntkkl c:n(4) f:nkto c:c(20) f:prz c:n(1) f:nkklp c:c(30) f:aSdv c:n(10,2) f:vsvb c:n(6) f:atrc c:n(1) f:SdvU c:n(10,2) f:SdvUn c:n(10,2) f:k1 c:n(3) f:k2 c:n(3) f:Sdv_uch c:n(10,2) f:Sdv_nac c:n(10,2) f:Sdv_tot c:n(10,2) f:pct_nac c:n(4,0)")
  else
    crtt('atotch', "f:Mrsh c:n(6) f:dtpoe c:d(8) f:dn c:c(2) f:nvMrsh c:c(20) f:anom c:c(6) f:grpod c:n(4) f:vsv c:n(6) f:vsvb c:n(6) f:Sdv c:n(10,2) f:necs c:c(20) f:dfio c:c(15) f:cntkkl c:n(4) f:nkto c:c(20) f:prz c:n(1) f:nkklp c:c(30) f:aSdv c:n(10,2) f:atrc c:n(1) f:SdvU c:n(10,2) f:SdvUn c:n(10,2) f:k1 c:n(3) f:k2 c:n(3) f:Sdv_uch c:n(10,2) f:Sdv_nac c:n(10,2) f:Sdv_tot c:n(10,2) f:pct_nac c:n(4,0)")
  endif

  sele 0
  use atotch
  dtotchr=date()
  dt1r=gdTd
  dt2r=gdTd
  oclr=setcolor('gr+/b,n/w')
  wotch=wopen(10, 20, 13, 60)
  wbox(1)
  @ 0, 1 say 'Период с' get dt1r
  @ 0, col()+1 say 'по ' get dt2r
  read
  @ 1, 1 prom 'Lpt1'
  @ 1, col()+1 prom 'Lpt2'
  @ 1, col()+1 prom 'Lpt3'
  @ 1, col()+1 prom 'Файл'
  menu to motchr
  do case
  case (motchr=1)
    vLpt1='Lpt1'
  case (motchr=2)
    vLpt1='Lpt2'
  case (motchr=3)
    vLpt1='Lpt3'
  case (motchr=4)
    vLpt1='atotch.txt'
    vLpt=1
  endcase
  set prin to (vLpt1)

  set prin on
  set cons off

  if (motchr=1)
    if (empty(gcPrn))
      ??chr(27)+chr(80)+chr(15)
      rlistr=62
    else
      ??chr(27)+'E'+chr(27)+'&l4h25a0O'+chr(27)+'&k2S'+chr(27)+'(3R'+chr(27)+'(s0p18.00h0s1b4102T'+chr(27)
      //      ??chr(27)+'E'+chr(27)+'&l4h2a0O'+chr(27)+'&k2S'+chr(27)+'&a20l'+chr(27)+'(3R'+chr(27)+'(s0p17.00h0s0b4099T'+chr(27)
      rlistr=43
    endif

  else
    if (motchr#4)
      ??chr(27)+'E'+chr(27)+'&l4h25a0O'+chr(27)+'&k2S'+chr(27)+'(3R'+chr(27)+'(s0p18.00h0s1b4102T'+chr(27)
      //      ??chr(27)+'E'+chr(27)+'&l4h2a0O'+chr(27)+'&k2S'+chr(27)+'&a20l'+chr(27)+'(3R'+chr(27)+'(s0p17.00h0s0b4099T'+chr(27)
      rlistr=43
    else
      if (empty(gcPrn))
        ??chr(27)+chr(80)+chr(15)
      endif

      rlistr=62
    endif

  endif

  rswr=1
  lstr=1
  otchsh()
  sele cMrsh
  go top
  dMrshr=ctod('')
  while (!eof())
    if (dMrsh<dt1r.or.dMrsh>dt2r)
      skip
      loop
    endif

    if (dMrsh#(dMrshr).and.dt1r#dt2r)
      ?dtoc(dMrsh)
    endif

    dMrshr=dMrsh
    nMrshr=nMrsh
    cntKklr=cntkkl
    anomr=anom
    vsvr=vsv
    vsvbr=vsvb
    necsr=getfield('t1', 'cMrsh->kecs', 's_tag', 'fio')
    nktar=getfield('t1', 'cMrsh->kta', 'speng', 'fio')
    nktor=getfield('t1', 'cMrsh->kto', 'speng', 'fio')
    przr=prz
    dfior=dfio
    atrcr=atrc
    Sdvr=Sdv
    SdvUr=SdvU
    Mrshr=Mrsh
    atranr=atran
    if (fieldpos('KATran')#0)
      KATranr=KATran
    else
      KATranr=0
    endif

    if (KATranr=0)
      natranr=space(20)
      grpodr=0
      kklpr=0
      kmr=0
    else
      natranr=getfield('t1', 'KATranr', 'kln', 'nkl')
      grpodr=val(getfield('t1', 'KATranr', 'kln', 'tlf'))
      kmr=val(getfield('t1', 'KATranr', 'kln', 'ns1'))
      kklpr=getfield('t1', 'KATranr', 'kln', 'kklp')
      natranr=alltrim(natranr)+' '+str(grpodr, 4, 1)+' тн'
    endif

    if (fieldpos('KATranP')#0)
      KATranPr=KATranP
    else
      KATranPr=0
    endif

    if (KATranPr=0)
      natranpr=space(20)
      grpodpr=0
      kmpr=0
      kklppr=0
    else
      natrapnr=getfield('t1', 'KATranPr', 'kln', 'nkl')
      grpodpr=val(getfield('t1', 'KATranPr', 'kln', 'tlf'))
      kmpr=val(getfield('t1', 'KATranPr', 'kln', 'ns1'))
      kklppr=getfield('t1', 'KATranPr', 'kln', 'kklp')
      natranr=alltrim(natranpr)+' '+str(grpodpr, 4, 1)+' тн'
    endif

    nkklpr=getfield('t1', 'kklpr', 'kln', 'nkl')
    nkklppr=getfield('t1', 'kklppr', 'kln', 'nkl')
    if (fieldpos('mSdv')#0)
      aSdvr=mSdv
    else
      aSdvr=0
    endif

    if (fieldpos('dtpoe')#0)
      dtpoer=dtpoe
    else
      dtpoer=ctod('')
    endif

    dr=dow(dtpoer)
    do case
    case (dr=1)
      dnr='Вс'
    case (dr=2)
      dnr='Пн'
    case (dr=3)
      dnr='Вт'
    case (dr=4)
      dnr='Ср'
    case (dr=5)
      dnr='Чт'
    case (dr=6)
      dnr='Пн'
    case (dr=7)
      dnr='Сб'
    endcase

    vMrshr=vMrsh
    nvMrshr=getfield('t1', 'vMrshr', 'atvm', 'nvMrsh')

    sele atotch
    appe blank
    repl cntkkl with cntKklr, ;
     anom with anomr,         ;
     vsv with vsvr,           ;
     vsvb with vsvbr,         ;
     necs with necsr,         ;
     prz with przr,           ;
     dfio with dfior,         ;
     Sdv with Sdvr,           ;
     SdvU with SdvUr,         ;
     nkto with nktor,         ;
     Mrsh with Mrshr,         ;
     nvMrsh with nvMrshr,     ;
     grpod with grpodr,       ;
     dtpoe with dtpoer,       ;
     nkklp with nkklpr,       ;
     aSdv with aSdvr,         ;
     dn with dnr,             ;
     atrc with atrcr
    sele cMrsh
    ?'│'+str(Mrsh, 6)+'│'+nMrsh+'│'+str(cntkkl, 4)+'│'+subs(anom, 1, 6)+'│'+getfield('t1', 'cMrsh->atran', 'atran', 'natran')+'│'+str(vsv, 6)+'│'+str(Sdv, 6)+'│'+subs(necsr, 1, 15)+'│'+subs(nktar, 1, 14)+'│'+str(prz, 1)+'│'+str(SdvU, 6)+'│'
    rsleo()
    skip
  enddo

  if (dirchange(gcPath_w+'sklad17')#0)
    dirmake(gcPath_w+'sklad17')
  endif
  dirchange(gcPath_l)

  sk_r=0
  do case
  case (gnRmsk=0)
    if (gnEnt=20)
      sk_r=228
    else
      sk_r=232
    endif

  case (gnRmsk=4)
    if (gnEnt=20)
      sk_r=400
    else
      sk_r=700
    endif

  endcase

  if (sk_r#0)
    sele cskl
    locate for sk=sk_r
    pathr=gcPath_d+alltrim(path)
    netuse('rs1', 'rs1u',, 1)
    netuse('rs2', 'rs2u',, 1)
    netuse('rs3', 'rs3u',, 1)
    sele atotch
    go top
    while (!eof())
      Mrshr=Mrsh
      k1r=0
      k2r=0
      SdvUnr:=0

      sele rs1u
      set orde to tag t3
      outlog(3, __FILE__, __LINE__, Mrshr, '*1,Mrshr')
      if (netseek('t3', '1,Mrshr'))
        while (prz=1.and.Mrsh=Mrshr)
          ttnr=ttn
          //товар 96
          s96_1r:=getfield('t1', 'ttnr,96', 'rs3u', 'ssf')
          outlog(3, __FILE__, __LINE__, ttnr, s96_1r)
          if (s96_1r#0)
            k1r=k1r+1
          endif

          SdvUnr+=s96_1r
          sele rs1u
          skip
        enddo

      else
        outlog(3, __FILE__, __LINE__, Mrshr, '*0,Mrshr')
        if (netseek('t3', '0,Mrshr'))
          while (prz=0.and.Mrsh=Mrshr)
            ttnr=ttn
            //товар 96
            s96_1r:=getfield('t1', 'ttnr,96', 'rs3u', 'ssf')
            outlog(3, __FILE__, __LINE__, '*0', ttnr, s96_1r)
            if (s96_1r#0)
              k2r=k2r+1
            endif

            SdvUnr += s96_1r
            sele rs1u
            skip
          enddo

        endif

      endif

      // товар
      s96_r:= 0
      // наценка
      s98_r:= 0
      // итого
      s90_r:= 0
      // для подвержеднный
      outlog(3, __FILE__, __LINE__, Mrshr, '-1,Mrshr')
      sele rs1u
      if (netseek('t3', '1,Mrshr'))
        while (prz=1.and.Mrsh=Mrshr)
          ttnr=ttn
          // товар
          s96_1r:=getfield('t1', 'ttnr,96', 'rs3u', 'ssf')
          s96_r += s96_1r
          // наценка
          s98_1r:=getfield('t1', 'ttnr,98', 'rs3u', 'ssf')
          s98_r += s98_1r
          // итого
          s90_1r:=getfield('t1', 'ttnr,90', 'rs3u', 'ssf')
          s90_r += s90_1r
          outlog(3, __FILE__, __LINE__, ttnr, s96_1r, s98_1r, s90_1r)
          sele rs1u
          skip
        enddo

      endif

      // для не подвержденных
      outlog(3, __FILE__, __LINE__, Mrshr, '-0,Mrshr')
      sele rs1u
      if (netseek('t3', '0,Mrshr'))
        while (prz=0.and.Mrsh=Mrshr)
          ttnr=ttn
          sele rs2u
          s96_1r := s98_1r := s90_1r:=0
          if (netseek('t1', 'ttnr'))
            // промосмотреть накладную и посчитать сумму
            s96s98()
            // итого
            s90_1r:=getfield('t1', 'ttnr,90', 'rs3u', 'ssf')
            outlog(3, __FILE__, __LINE__, ttnr, s96_1r, s98_1r, s90_1r)
          else
            outlog(3, __FILE__, __LINE__, 'нет ттн', ttnr)
          endif

          // товар          //s96_1r:=getfield('t1','ttnr,96','rs3u','ssf')
          s96_r += s96_1r
          // наценка       //s98_1r:=getfield('t1','ttnr,98','rs3u','ssf')
          s98_r += s98_1r
          // итого
          s90_r += s90_1r

          if (ABS(ROUND((s96_1r + s98_1r)*1.2, 0) - ROUND(s90_1r, 0)) > 1)
            outlog(__FILE__, __LINE__, ROUND((s96_1r + s98_1r)*1.2, 0) - ROUND(s90_1r, 0), ttnr, s96_1r, s98_1r, '#', s90_1r)
          endif

          sele rs1u
          skip
        enddo

      endif

      sele atotch
      netrepl('SdvUn,k1,k2', {SdvUnr, k1r, k2r })
      netrepl('Sdv_uch,Sdv_nac,Sdv_tot,pct_nac', {s96_r, s98_r, s90_r, ROUND(s98_r/s96_r*100, 0) })
      skip
    enddo

    nuse('rs1u')
    nuse('rs2u')
    nuse('rs3u')
  endif

  sele atotch
  copy to (gcPath_w+'sklad17\atotch.dbf')
  close atotch
  set cons on
  set prin off
  wclose(wotch)
  setcolor(oclr)
  sele cMrsh
  go rcMrshr
  return

/***********************************************************
 * prnsf() -->
 *   Параметры :
 *   Возвращает:
 */
function PrnSf()
  netuse('sert')
  sele cskl
  if (netseek('t1', 'skr'))
    gcNskl=alltrim(nskl)
    gnRasc=rasc
    ctovr=ctov
    entr=ent
    sele setup
    locate for ent=entr
    pather=gcPath_m+alltrim(nent)+'\'
    pathdr=gcPath_m+alltrim(nent)+'\'+gcDir_g+gcDir_d
    sele cskl
    pathr=pathdr+alltrim(path)
    netuse('rs1',,, 1)
    //   netuse('tovpt',,,1)
    netuse('rs2',,, 1)
    netuse('rs2m',,, 1)
    netuse('rs3',,, 1)
    netuse('soper',,, 1)
    netuse('sgrp',,, 1)
    netuse('tov',,, 1)
    netuse('tov', 'tovsrt',, 1)
    netuse('tovm',,, 1)
    pathr=pather
    netuse('ctov',,, 1)
    netuse('kps',,, 1)
    netuse('cgrp',,, 1)
    netuse('klndog',,, 1)
    netuse('tcen',,, 1)
    sele rs1
    if (netseek('t1', 'ttnr',,, 1))
      pvtr=pvt
      ppsfr=ppsf
      gnVo=vo
      vor=vo
      nkklr=nkkl
      kopr=kop
      npvr=npv
      kpvr=kpv
      textr=text
      atnomr=atnom
      pstr=pst
      sklr=skl
      kplr=kpl
      kpsbbr=getfield('t1', 'kplr', 'kps', 'prbb')
      kgpr=kgp
      kpvr=kpv
      bsor=bso
      dspr=dsp
      dotr=dot
      sktr=skt
      skltr=sklt
      ktasr=ktas
      Sdvr=Sdv

      if (fieldpos('ttnp')#0)
        ttnpr=ttnp
        ttncr=ttnc
      else
        ttnpr=0
        ttncr=0
      endif

      mk169r=0;     ttn169r=0;      pr169r=0
      if (fieldpos('mk169')#0)
        mk169r=mk169;        ttn169r=ttn169;        pr169r=pr169
      endif

      mk129r=0;      ttn129r=0;      pr129r=0
      if (fieldpos('mk129')#0)
        mk129r=mk129;        ttn129r=ttn129;        pr129r=pr129
      endif

      mk139r=0;      ttn139r=0;      pr139r=0
      if (fieldpos('mk139')#0)
        mk139r=mk139;        ttn139r=ttn139;        pr139r=pr139
      endif

      rtcenr=0
      ttn1cr=ttn1c
      nndsr=nnds
      if (empty(dot))
        przp=0
      else
        przp=1
      endif

      sele soper
      netseek('t1', '0,1,gnVo,kopr-100')
      if (fieldpos('brpr')=0)
        brprr=0
      else
        brprr=brpr
      endif

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
      kopr=kop
      kopir=kopi
      if (fieldpos('kolpos')#0)
        kolposr=kolpos
      else
        kolposr=0
      endif

      fktor=alltrim(getfield('t1', 'ktor', 'speng', 'fio'))
      symklr=''
      symkl=0
      if (gnRasc=2.or.(gnRasc=1.and.mk169r#0.and.pr169r#2))
        vzz=1
        rsprn(2)          // ТТН
      else
        vzz=2
        rsprn(2)          // Сетевая печать
      endif

      sele czg
      netrepl('mppsf', {mppsf+1})
    endif

    nuse('rs1')
    //   nuse('tovpt')
    nuse('rs2')
    nuse('rs2m')
    nuse('rs3')
    nuse('soper')
    nuse('sgrp')
    nuse('tov')
    nuse('tovsrt')
    nuse('tovm')
    nuse('ctov')
    nuse('kps')
    nuse('cgrp')
    nuse('klndog')
    nuse('tcen')
  endif

  nuse('sert')
  return (.t.)

/***********************************************************
 * vMrsh1() -->
 *   Параметры :
 *   Возвращает:
 */
function vMrsh1()
  local getlist:={}
  if (atrcr#2)
    foratvmr='atrc=atrcr'
  else
    foratvmr='atrc=atrcr.or.atrc=0'
  endif

  while (.t.)
    sele atvm
    dbunlock()
    if (!netseek('t1', 'vMrshr'))
      go top
    endif

    wselect(0)
    vMrshr=slcf('atvm', 2, 50, 18,, "e:vMrsh h:' N' c:n(3) e:nvMrsh h:'Маршрут' c:с(20)", 'vMrsh',,,, foratvmr,, 'Направления')
    wselect(wmins)
    if (lastkey()=13)
      locate for vMrsh=vMrshr
      nvMrshr=nvMrsh
      @ 1, 25 say nvMrshr
    endif

    if (lastkey()=13.or.lastkey()=K_ESC)
      exit
    endif

  enddo

  sele cMrsh
  return (.t.)

/***********************************************************
 * KATranP() -->
 *   Параметры :
 *   Возвращает:
 */
function KATran()
  local getlist:={}
  sele kln
  if (!netseek('t1', '2000'))
    netadd()
    netrepl('kkl', {2000})
  endif

  if (KATranr#0)
    if (!netseek('t1', 'KATranr'))
      KATranr=0
    else
      if (empty(anomr))
        if (!empty(nkls))
          anomr=nkls
        else
          anomr=nkl
        endif

      endif

      if (empty(dfior))
        dfior=adr
      endif

      natranr=alltrim(nkl)+' '+alltrim(tlf)+' тн'
      kmr=val(ns1)
      grpodr=val(tlf)
      @ 2, 25 say natranr
    endif

  endif

  if (KATranr=0)
    whlKATranr='kkl>=2000.and.kkl<=3000'
    frktr='.t.'
    if (gnEntRm=0)
      if (gnEnt=21)
        frktr='TabNo=21'
      endif
    endif

    while (.t.)
      sele kln
      wselect(0)
      rcKATranr=slcf('kln',,,,, "e:kkl h:'Код' c:n(7) e:nkl h:'Траспорт' c:с(30) e:adr h:'Водитель' c:с(30)",,,, whlKATranr, frktr,, 'Транспорт')
      wselect(wmins)
      if (lastkey()=13)
        go rcKATranr
        KATranr=kkl
        natranr=alltrim(nkl)+' '+alltrim(tlf)+' тн'
        grpodr=val(tlf)
        if (!empty(nkls))
          anomr=nkls
        else
          anomr=nkl
        endif

        dfior=adr
        kmr=val(ns1)
      endif

      if (lastkey()=K_ESC)
        KATranr=0
        natranr=space(20)
        grpodr=0
        anomr=''
        dfior=''
        kmr=0
      endif

      @ 2, 25 say natranr
      if (lastkey()=13.or.lastkey()=K_ESC)
        exit
      endif

    enddo

  endif

  if (KATranr=0)
    setlastkey(13)
  endif

  sele cMrsh
  return (.t.)

/***********************************************************
 * KATranP() -->
 *   Параметры :
 *   Возвращает:
 */
function KATranP()
  local getlist:={}
  sele kln
  if (KATranPr#0)
    if (!netseek('t1', 'KATranPr'))
      KATranPr=0
    else
      if (empty(anomr))
        if (!empty(nkls))
          anomr=nkls
        else
          anomr=nkl
        endif

      endif

      if (empty(dfior))
        dfior=adr
      endif

      natranpr=alltrim(nkl)+' '+alltrim(tlf)+' тн'
      kmpr=val(ns1)
      grpodpr=val(tlf)
      @ 3, 25 say natranpr
    endif

  endif

  if (KATranPr=0)
    whlKATranr='kkl>=2000.and.kkl<=3000'

    while (.t.)
      sele kln
      wselect(0)
      rcKATranr=slcf('kln',,,,, "e:kkl h:'Код' c:n(7) e:nkl h:'Траспорт' c:с(30) e:adr h:'Водитель' c:с(30)",,,, whlKATranr,,, 'Транспорт')
      wselect(wmins)
      if (lastkey()=13)
        go rcKATranr
        KATranPr=kkl
        if (KATranPr#KATranr)
          grpodpr=val(tlf)
          natranpr=alltrim(nkl)+' '+alltrim(tlf)+' тн'
          kmpr=val(ns1)
        else
          KATranPr=0
          natranpr=space(20)
          kmpr=0
          grpodpr=0
        endif

      endif

      if (lastkey()=K_ESC)
        KATranPr=0
        natranpr=space(20)
        kmpr=0
        grpodpr=0
      endif

      @ 3, 25 say natranpr
      if (lastkey()=13.or.lastkey()=K_ESC)
        exit
      endif

    enddo

  endif

  if (KATranPr=0)
    setlastkey(13)
  endif

  sele cMrsh
  return (.t.)

/*************** */
function Mrshzad()
  /*************** */
  sele czg
  set orde to tag t5
  if (netseek('t5', 'Mrshr'))
    while (Mrsh=Mrshr)
      skr=sk
      entr=ent
      sklr=getfield('t1', 'skr', 'cskl', 'skl')
      ttnr=ttn
      kklr=kkl
      Mrshnppr=npp
      kopr=kop
      nuse('rs2')
      nuse('tov')
      sele setup
      locate for ent=entr
      pather=gcPath_m+alltrim(nent)+'\'
      pathdr=gcPath_m+alltrim(nent)+'\'+gcDir_g+gcDir_d
      pathr=pathdr+alltrim(getfield('t1', 'skr', 'cskl', 'path'))
      netuse('rs2',,, 1)
      netuse('tov',,, 1)
      sele rs2
      if (netseek('t1', 'ttnr'))
        while (ttn=ttnr)
          ktlr=ktl
          otr=getfield('t1', 'sklr,ktlr', 'tov', 'ot')
          cotir='oti'+alltrim(str(otr, 2))
          if (select(cotir)=0)
            crtt(cotir, 'f:ent c:n(2) f:sk c:n(3) f:ttn c:n(6) f:kkl c:n(7) f:npp c:n(2) f:kop c:n(3)')
            sele 0
            use (cotir)
          endif

          sele (cotir)
          locate for ent=entr.and.sk=skr.and.ttn=ttnr
          if (!foun())
            netadd()
            netrepl('ent,sk,ttn,kop,kkl,npp', {entr,skr,ttnr,kopr,kklr,Mrshnppr})
          endif

          sele rs2
          skip
        enddo

      endif

      nuse('rs2')
      nuse('rs3')
      nuse('tov')
      sele czg
      skip
    enddo

  else
    return (.t.)
  endif

  vLpt=0; vLpt1=''
  do case
  case (atrcr=1.and.gnAdm=0)
    vLpt1='Lpt3'
  case (atrcr=2.and.gnAdm=0)
    vLpt1='Lpt2'
  otherwise
    vLpt=0; vLpt1=''
    vLpt(@vLpt, @vLpt1, 'ПЕЧАТЬ','zadan.txt')
  endcase
  set prin to (vLpt1)

  for otii=1 to 10
    cotir='oti'+alltrim(str(otii, 2))
    if (select(cotir)=0)
      loop
    endif

    set prin to &vLpt1
    set prin on
    set cons off
    if (vLpt=1)
      if (empty(gcPrn))
        ??chr(27)+chr(80)+chr(15)
        rlistr=62
      else
        ??chr(27)+'E'+chr(27)+'&l4h25a0O'+chr(27)+'&k2S'+chr(27)+'(3R'+chr(27)+'(s0p18.00h0s1b4102T'+chr(27)
        //          ??chr(27)+'E'+chr(27)+'&l4h2a0O'+chr(27)+'&k2S'+chr(27)+'&a20l'+chr(27)+'(3R'+chr(27)+'(s0p17.00h0s0b4099T'+chr(27)
        rlistr=43
      endif

    else
      ??chr(27)+'E'+chr(27)+'&l4h25a0O'+chr(27)+'&k2S'+chr(27)+'(3R'+chr(27)+'(s0p18.00h0s1b4102T'+chr(27)
      //       ??chr(27)+'E'+chr(27)+'&l4h2a0O'+chr(27)+'&k2S'+chr(27)+'&a20l'+chr(27)+'(3R'+chr(27)+'(s0p17.00h0s0b4099T'+chr(27)
      rlistr=43
    endif

    sele (cotir)
    go top
    rswr=1
    lstr=1
    AtShz()
    while (!eof())
      skr=sk
      entr=ent
      ttnr=ttn
      kklr=kkl
      Mrshnppr=npp
      kopr=kop
      nklr=getfield('t1', 'kklr', 'kgp', 'ngrpol')
      if (empty(nklr))
        nklr=getfield('t1', 'kklr', 'kln', 'nkl')
      endif

      ?' '+str(entr, 2)+' '+str(skr, 3)+' '+str(ttnr, 6)+' '+str(kopr, 3)+' '+str(kklr, 7)+' '+subs(nklr, 1, 30)+' '+str(Mrshnppr, 2)
      rslea()
      sele (cotir)
      skip
    enddo

    close
    set prin off
    set prin to
    set cons on
  next

  //sele cMrsh
  //netrepl('kto,dMrsh',{gnKto,dMrshr})
  //?space(60)
  //rslea()
  //rslea()
  //?'Маршрут составил '+getfield('t1','ktar','speng','fio')+'______________'
  //rslea()
  //rslea()
  //?'Маршрут отправил '+getfield('t1','ktor','speng','fio')+'______________'
  //rslea()
  //?'Подпись отв.лица '+'/'+space(38)+'/'+'______________'
  //rslea()

  return (.t.)

/***********************************************************
 * atshz() -->
 *   Параметры :
 *   Возвращает:
 */
static function AtShz()
  ?'Маршрутный лист N '+str(Mrshr, 6)+ ' '+'Отдел'+' '+str(otii, 2)
  rslea()
  ?'Маршрут '+' '+alltrim(nMrshr)+' '+dtoc(dMrshr)
  rslea()
  ?'Транспорт '+alltrim(natranr)+' грузоподъемность '+str(grpodr, 3)+' тн'
  rslea()
  ?'Номер '+anomr+' '+'Водитель'+' '+dfior+' '+'Экспедитор '+getfield('t1', 'kecsr', 's_tag', 'fio')
  rslea()
  ?'Загрузка '+str(mvsvr, 11, 3)+' кг'+' Сумма '+str(mSdvr, 15, 2)+' грн'+space(20)+'Лист '+str(lstr, 2)
  rslea()
  ?dtoc(date())+' '+time()
  rslea()
  ?'┌──┬───┬──────┬───┬───────┬──────────────────────────────┬──┐'
  ?'│ П│SK │  ТТН │КОП│  КОД  │      ПОЛУЧАТЕЛЬ              │По│'
  ?'├──┼───┼──────┼───┼───────┼──────────────────────────────┼──┤'
  rslea()

  return (nil)

/***********************************************************
 * cMrsho() -->
 *   Параметры :
 *   Возвращает:
 */
function cMrsho(p1)
  local slr
  slr=select()
  prznk=p1

  //  Значения признака prznk для записи в протокол RSO
  //  1 - Удаление выписанного документа
  //  2 - Удаление отгруженного документа
  //  3 - Снятие признака подтвержденного документа
  //  4 - Коррекция товарной части документа
  //  5 - Удаление позиции из выписанного документа
  //  6 - Печать в товарном отделе
  //  7 - Отгрузка со склада
  //  8 - Подтверждение складом
  //  9 - Создание нового документа
  // 10 - Коррекция шапки
  // 11 - Сетевая печать
  // 12 - Востановление
  // 14 - Коррекция позиции кол-ва на "0"
  // 15 - Снятие отгрузки
  // 16 - Установка отгрузки
  // 17 - Смена прайса (kopi)
  // 18 - Цена вручную
  if (prznk#prnppr)
    netuse('cMrsho')
    go top
    reclock()
    nppr=cntkkl+1
    repl cntkkl with nppr
    dbunlock()
    arec:={}
    sele cMrsh
    getrec()
    sele cMrsho
    netadd()
    putrec()
    netrepl('npp,dnpp,tnpp,ktonpp,prnpp', {nppr,date(),time(),gnKto,prznk})
    prnppr=prznk
  endif

  do case
  //   case prznk=1 // Удаление выписанного документа
  case (prznk=2.or.prznk=1)// Удаление отгруженного документа или Удаление выписанного документа
  case (prznk=3)           // Снятие признака подтвержденного документа
  case (prznk=4)           // Коррекция товарной части документа
  case (prznk=5)           // Удаление позиции из выписанного документа
  case (prznk=6)           // Печать в товарном отделе
  case (prznk=7)           // Отгрузка со склада
  case (prznk=8)           // Подтверждение складом
  case (prznk=9)           // Создание нового документа
  case (prznk=10)          // Коррекция шапки
  case (prznk=11)          // Сетевая печать
  case (prznk=12)          // Восстановление
  case (prznk=15)          // Снятие отгрузки
  case (prznk=16)          // Установка отгрузки
  case (prznk=17)          // Смена прайса(kopi)
  case (prznk=14.or.prznk=18)// Коррекция на "0" , Цена вручную
  endcase

  nuse('cMrsho')
  sele (slr)
  return (.t.)

/***********************************************************
 * atosh() -->
 *   Параметры :
 *   Возвращает:
 */
function atosh()
  ?'Отборный лист'+' '+'К маршр листу N '+str(Mrshr, 6)+' '+' '+str(ot_r, 2)+' '+notr+space(5)+'Лист '+str(lstr, 2)
  rslet()
  nttnr=getfield('t1', 'ot_r', 'atoto', 'not')
  ?'ТТН - '+nttnr
  rslet()
  if (lstr=1)
    ?'Маршрут '+' '+alltrim(nMrshr)+' '+dtoc(dtpoer)//dtoc(dMrshr)
    rslet()
    ?'Транспорт '+alltrim(natranr)+' грузоподъемность '+str(grpodr, 3)+' тн'
    rslet()
    ?'Номер '+anomr+' '+'Водитель'+' '+dfior+' '+'Экспедитор '+getfield('t1', 'kecsr', 's_tag', 'fio')
    rslet()
    ?dtoc(date())+' '+time()
    rslet()
  endif

  rslet()

  return (nil)

/***********************************************************
 * rslet() -->
 *   Параметры :
 *   Возвращает:
 */
function rslet()
  rswr++
  if (rswr>=rlistr)
    rswr=1
    lstr++
    eject
    atosh()
  endif

  return

/************** */
function Mrshz()
  /************** */
  local ztr:='т='           // номер ТТН префикс номера ТТН
  local nSumTnn, nSdv

  sele czg
  set orde to tag t1
  if (fieldpos('ztxt')#0)
    if (netseek('t1', 'Mrshr'))
      rc_rr=RecNo()
      prPZr=0
      // поиск хоть одного задания
      // locate for !(d0k1#0) .and. !empty(ztxt).and.at(ztr,ztxt)#0 while Mrsh=Mrshr
      while (Mrsh=Mrshr)
        if (d0k1#0)
          skip; loop
        endif

        if (!empty(ztxt).and.at(ztr, ztxt)#0)
          prPZr=1
          exit
        endif

        skip
      enddo

      // нашли задание
      if (prPZr=1)

        tzvk_crt()          //  создали тбл Заданий

        sele czg
        go rc_rr
        while (Mrsh=Mrshr)
          ztr='т='          // номер ТТН
          if (!empty(ztxt).and.at(ztr, ztxt)#0)

            tzvk_ztxt(pl, gp, ztxt, ttn)

          endif

          sele czg
          skip
        enddo

        ////////  добавить итоговы суммы 01-24-17 08:23pm
        tzvk_crt('tzvk_sum')//  создали тбл Заданий
        sele tzvk
        go top
        while (!eof())
          kplr := kpl
          kgpr := kgp
          nSumTnn := Sdv      // сумма первой ТТН, а может и последней
          SUM Sdv to nSdv while kplr = kpl
          if (nSumTnn # nSdv)// те две и больше ТТН по Плат
            sele tzvk_sum
            DBAppend()
            repl ttn with 0, Sdv with nSdv, kom with '<- ИТОГО !', ;
             kpl with kplr, kgp with kgpr

          endif

          sele tzvk
        enddo

        close tzvk_sum
        /////
        sele tzvk
        append from tzvk_sum

        // вывод на печать
        sele tzvk
        go top
        store 0 to kpl_r, kgp_r
        while (!eof())
          // код ТА
          kplr=kpl
          nplr=alltrim(getfield('t1', 'kplr', 'kln', 'nkl'))
          kgpr=kgp
          ngpr=alltrim(getfield('t1', 'kgpr', 'kln', 'nkl'))
          ttnr=ttn
          Sdvr=Sdv
          komr=alltrim(kom)
          napr=nap

          if (ttnr # 0)
            sele czg
            go rc_rr
            locate for ttn = tzvk->ttn2 while Mrsh=Mrshr
            ktar=kta
            nktar=getfield('t1', 'ktar', 's_tag', 'fio')

            If gnEnt=20
              If Empty(tzvk->DtOpl)
                // нет даты оплаты - не верная ТТН или нет в Аккрде
                komr+='*'
              EndIf
              Do Case
              Case  date() - tzvk->DtOpl  > 10
                komr+='Б/$ НЕ ВЫГРУЖАТЬ'
              OtherWise
                komr+=(str(ktar, 4)+' '+alltrim(nktar))
              EndCase

            Else
              komr+=(str(ktar, 4)+' '+alltrim(nktar))
            EndIf

          endif

          sele tzvk
          if (!(kplr=kpl_r.and.kgpr=kgp_r))
            ?'Плательщик'+' '+str(kplr, 7)+' '+nplr
            rslez()
            ?'Получатель'+' '+str(kgpr, 7)+' '+ngpr
            rslez()
            kpl_r=kplr
            kgp_r=kgpr
          endif

          if (gnEnt=20)
            ??chr(27)+'(s3b10.00h'+chr(27)// Жирный
            if (ttnr<999999)
              ?Transform(ttnr, '@Z '+Replicate('9', 10))
            else
              ?str(ttnr, 10) +' * '
            endif

            ??' '+str(Sdvr, 12, 2)+' '                    ;
             + Transform(napr, '@Z '+Replicate('9', 4));// str(napr,4);
             +' '+komr
            ??chr(27)+'(s0p18.00h0s1b4102T'+chr(27)// Средний
          else
            if (ttnr<999999)
              ?Transform(ttnr, '@Z '+Replicate('9', 10))
            else
              ?str(ttnr, 10) +' * '
            endif

            ??' '+str(Sdvr, 12, 2)+' '+str(napr, 4)+' '+komr
          endif

          rslez()
          sele tzvk
          skip
        enddo

        sele tzvk
        close
      //erase tzvk.dbf
      endif

    endif

  endif

  return (.t.)

/*************** */
function MrshZsh()
  /*************** */
  ?'Заявка экспедитору к маршрутному листу N'+' '+str(Mrshr, 6)
  rslez()
  ?'┌──────────┬────────────┬────┬────────────────────────────────────────────┐'
  rslez()
  ?'│   ТТН    │   Сумма    │Напр│           Комментарий                      │'
  rslez()
  ?'├──────────┼────────────┼────┼────────────────────────────────────────────┤'
  rslez()
  return (.t.)

/************** */
function rslez()
  /************** */
  rswr++
  if (rswr>=rlistr)
    rswr=1
    lstr++
    eject
    MrshZsh()
  endif

  return (.t.)


/*****************************************************************
 
 FUNCTION:
 АВТОР..ДАТА..........С. Литовка  08-04-17 * 03:38:57pm
 НАЗНАЧЕНИЕ......... формирование возврата тары чз заявку
 ПАРАМЕТРЫ..........
 ВОЗВР. ЗНАЧЕНИЕ....
 ПРИМЕЧАНИЯ.........
 */
function MrshZT()
  local aNUse:={}
  if (select('rs2kpk')#0)
    nuse('rs2kpk')
  endif

  crtt('TzvkT', 'f:kpl c:n(7) f:kgp c:n(7) f:mntov c:n(7),f:kvp c:n(10,3)')
  sele 0
  use TzvkT excl
  inde on str(kpl, 7)+str(kgp, 7)+str(mntov, 7) tag t1

  crtt('TzvkTt', 'f:kpl c:n(7) f:kgp c:n(7)')
  sele 0
  use TzvkTt excl
  inde on str(kpl, 7)+str(kgp, 7) tag t1

  sele czg
  set orde to tag t1
  sk_rr=0
  if (netseek('t1', 'Mrshr'))
    while (Mrsh=Mrshr)

      if (d0k1#0) // приходы
        skip
        loop
      endif

      ent_r=ent
      sk_r=sk
      ttn_r=ttn
      kpl_r=pl
      kgp_r=gp
      pathr=gcPath_d+alltrim(getfield('t1', 'sk_r', 'cskl', 'path'))
      if (!netfile('rs2kpk', 1))
        sele czg
        skip
        loop
      endif

      if (sk_rr#sk_r)
        nuse('rs2kpk')
        netuse('rs2kpk',,, 1)
        sk_rr=sk_r
      endif

      sele rs2kpk
      if (netseek('t1', 'ttn_r'))
        while (ttn=ttn_r)
          if (int(mntov/10000)>1) // если товар, то пропуск
            sele rs2kpk
            skip
            loop
          endif
          // тара в заявке
          mntov_r=mntov
          kvp_r=kvp
          sele TzvkTt
          if (!netseek('t1', 'kpl_r,kgp_r'))
            appe blank
            repl kpl with kpl_r, ;
             kgp with kgp_r
          endif

          sele TzvkT
          if (!netseek('t1', 'kpl_r,kgp_r,mntov_r'))
            appe blank
            repl kpl with kpl_r, ;
             kgp with kgp_r,     ;
             mntov with mntov_r
          endif

          repl kvp with kvp+kvp_r
          sele rs2kpk
          skip
        enddo

      endif

      sele czg
      skip
    enddo

    nuse('rs1kpk')
    nuse('rs2kpk')
  endif

  // Печать
  netuse('klndog'); aadd(aNUse,'klndog')
  If empty(select('ctov'))
    netuse('ctov'); aadd(aNUse,'ctov')
  EndIf

  store 0 to kpl_r, kgp_r
  sele TzvkTt
  go top
  while (!eof())
    kpl_r=kpl
    kgp_r=kgp
    for zi=1 to 2
      ?space(15)+'НАКЛАДНА N________вiд "___"_______________________201___р'+' '+str(Mrshr, 6)
      ?'Вiд кого '+str(kpl_r, 7)+' '+alltrim(getfield('t1', 'kpl_r', 'kln', 'nkl'))+' '+str(kgp_r, 7)+' '+alltrim(getfield('t1', 'kgp_r', 'kln', 'nkl'))
      ?'Кому '+gcName_c+' Договiр N'+str(getfield('t1', 'kpl_r', 'klndog', 'ndog'), 6)
      ?'Через '+getfield('t1', 'kecsr', 's_tag', 'fio')+'__________________________________'
      //       ?'Точка      '+str(kgp_r,7)+' '+getfield('t1','kgp_r','kln','nkl')
      ?'┌───────┬────────────────────────────────────────┬──┬────┬──────┬──────────┬──────────┐'
      ?'│  Код  │             Найменуванння              │  │КiлЗ│ КiлВ │  Цiна    │  Сума    │'
      ?'├───────┼────────────────────────────────────────┼──┼────┼──────┼──────────┼──────────┤'
      sele TzvkT
      kkk_r=0
      if (netseek('t1', 'kpl_r,kgp_r'))
        while (kpl=kpl_r.and.kgp=kgp_r)
          ?'│'+str(mntov, 7)+'│'+subs(getfield('t1', 'TzvkT->mntov', 'ctov', 'nat'), 1, 40)+'│шт│'+str(TzvkT->kvp, 4)+'│'+space(6)+'│'+str(getfield('t1', 'TzvkT->mntov', 'ctov', 'opt'), 10, 2)+'│'+space(10)+'│'
          kkk_r=kkk_r+1
          if (kkk_r<3)
            ?'├───────┼────────────────────────────────────────┼──┼────┼──────┼──────────┼──────────┤'
          endif

          if (kkk_r=3)
            exit
          endif

          sele TzvkT
          skip
        enddo

      endif

      if (kkk_r<3)
        for lll=kkk_r to 3
          ?'│       │                                        │  │    │      │          │          │'
          lll=lll+1
          if (lll<3)
            ?'├───────┼────────────────────────────────────────┼──┼────┼──────┼──────────┼──────────┤'
          endif

        next

      endif

      ?'└───────┴────────────────────────────────────────┴──┴────┴──────┴──────────┼──────────┤'
      ?'                                                            Всього без ПДВ │          │'
      //       ?'                                                                       ПДВ │          │'
      ?'                                                       Загальна сума з ПДВ │          │'
      ?'                                                                           └──────────┘'
      //       ?''
      ?'Сума до сплати _________________________________________________________'
      ?''
      ?'Вiдпустив_____________  МП                 Одержав____________ МП    '
      if (zi=1)
        ?''
        ?repl('-', 80)
        ?''
      endif

    endfor

    eject
    sele TzvkTt
    skip
  enddo

  sele TzvkT
  close
  //erase TzvkT.dbf
  //erase TzvkT.cdx
  sele TzvkTt
  close
  //erase TzvkTt.dbf
  //erase TzvkTt.cdx

  AEval(aNUse, {|cAls| nuse('cAls')})

  return (.t.)

/************* */
function PrnVzM()
  /************* */
  sele czg
  set orde to tag t5
  if (netseek('t5', 'Mrshr'))
    save scre to scsf
    while (Mrsh=Mrshr)
      skr=sk
      ttnr=ttn
      d0k1r=d0k1
      if (d0k1r=1) // признак приход
        mess(str(skr, 3)+' '+str(ttnr, 6))
        PrnVz1()
      endif

      sele czg
      skip
    enddo

    rest scre from scsf
  endif

  return (.t.)

/************** */
function PrnVz1()
  /************** */
  sele cskl
  if (netseek('t1', 'skr'))
    gcNskl=alltrim(nskl)
    ctovr=ctov
    entr=ent
    sele setup
    locate for ent=entr
    pather=gcPath_m+alltrim(nent)+'\'
    pathdr=gcPath_m+alltrim(nent)+'\'+gcDir_g+gcDir_d
    sele cskl
    pathr=pathdr+alltrim(path)
    netuse('pr1',,, 1)
    netuse('pr2',,, 1)
    netuse('pr3',,, 1)
    netuse('soper',,, 1)
    netuse('sgrp',,, 1)
    netuse('tov',,, 1)
    pathr=pather
    netuse('ctov',,, 1)
    netuse('cgrp',,, 1)
    sele pr1
    if (netseek('t1', 'ttnr',,, 1))
      mnr=mn
      gnVo=vo
      vor=vo
      kopr=kop
      q_r=mod(kopr, 100)
      sklr=skl
      kpsr=kps
      kzgr=kzg
      dvpr=dvp
      ktar=kta
      ktor=kto
      ttnvzr=ttnvz
      nopr=getfield('t1', '1,1,1,q_r', 'soper', 'nop')
      for prvzmi=1 to 2
        PrnPrRs()
      next

    endif

    nuse('pr1')
    nuse('pr2')
    nuse('pr3')
    nuse('soper')
    nuse('sgrp')
    nuse('tov')
    nuse('ctov')
    nuse('cgrp')
  endif

  return (.t.)

/************** */
function Mrsh19i()
  /************** */
  fl19r=gcPath_l+'\aaa.txt'
  if (file(fl19r))
    Mrshr=idMrsh()
    sele cMrsh
    netadd()
    netrepl('Mrsh,dMrsh,atrc',      ;
             {Mrshr,date(),atrcr}, 1 ;
          )
    rcMrshr=RecNo()

    cDelim=CHR(13) + CHR(10)
    hzvr=fopen(fl19r)
    n=1
    while (!feof(hzvr))
      //      if n<7
      //         n=n+1
      //         aaa=FReadLn(hzvr, 1, 80, cDelim)
      //         loop
      //      endif
      aaa=FReadLn(hzvr, 1, 80, cDelim)
      cttnr=subs(aaa, 1, 6)
    enddo

    fclose(hzvr)
  endif

  return (.t.)

/***********************************************************
 * Mrsh19o() -->
 *   Параметры :
 *   Возвращает:
 */
function Mrsh19o()
  return (.t.)

/***********************************************************
 * idMrsh() -->
 *   Параметры :
 *   Возвращает:
 */
function idMrsh()
  sele setup
  locate for ent=gnEnt
  reclock()
  if (nMrsh=0)
    repl nMrsh with 1
  endif

  mras_rr=nMrsh
  while (.t.)
    if (!netseek('t2', 'Mrsh_rr', 'cMrsh'))
      netrepl('nMrsh', {nMrsh+1})
      exit
    else
      netrepl('nMrsh', {nMrsh+1})
    endif

  enddo

  return (Mrsh_rr)

/***********************************************************
 * Mrshp() -->
 *   Параметры :
 *   Возвращает:
 */
function Mrshp()
  if (Mrshpr#0)
    if (!netseek('t2', 'Mrshpr', 'cMrsh'))
      wmess('Такого нет', 2)
      return (.f.)
    endif

  endif

  return (.t.)

/*****************************************************************
 
 FUNCTION:
 АВТОР..ДАТА..........С. Литовка  07-20-16 * 01:14:21pm
 НАЗНАЧЕНИЕ......... вычисление сумм s96 товар по уч. цена из 'ctov','opt'
                    s98 - наценка (разница в ценах * на к-во)
 ПАРАМЕТРЫ..........
 ВОЗВР. ЗНАЧЕНИЕ....
 ПРИМЕЧАНИЯ.........
 */
function s96s98()
  local s96_2r, s98_2r

  while (ttn=ttnr)
    // найти в ctov входная цена
    kvpr:=kvp
    mntovr:=mntov
    zenr:=zen               // цена реализации
    optr=getfield('t1', 'mntovr', 'ctov', 'opt')// цена учетная
    s96_2r:=ROUND(kvpr*optr, 2)// товар
    s98_2r:=ROUND(kvpr*(zenr-optr), 2)// наценка


    s96_1r += s96_2r
    s98_1r += s98_2r
    skip
  enddo

  return (nil)


/*****************************************************************
 
 FUNCTION:
 АВТОР..ДАТА..........С. Литовка  10-31-17 * 02:13:11pm
 НАЗНАЧЕНИЕ.........
 ПАРАМЕТРЫ..........
 ВОЗВР. ЗНАЧЕНИЕ....
 ПРИМЕЧАНИЯ.........
 */
Function MrshLkkl()
  if (select('lkkl')#0)
    sele lkkl
    close
  endif

  FileDelete('lkkl.*')
  crtt('lkkl', 'f:kkl c:n(7) f:npp c:n(2) f:npp2 c:n(3) f:klaster c:n(3) f:ves c:n(5) f:agp c:c(40) f:GpsLat c:c(10) f:GpsLon c:c(10) f:ngp c:c(50) f:agp_full c:c(80) f:knasp c:n(4) f:list_ot c:c(30)')
  use lkkl new Exclusive
  sele czg
  set orde to tag t5
  netseek('t5', 'Mrshr')
  while (Mrsh=Mrshr)
    kklr=kkl
    vsvr=vsv

    MrshNppr=0
    if (fieldpos('npp')#0)
      MrshNppr=npp
    endif

    sele lkkl
    locate for npp=MrshNppr.and.kkl=kklr

    if (!found())
      kln->(netseek('t1','kklr'))
      netadd()
      netrepl('npp,kkl,ves,GpsLat,GpsLon,ngp,agp,agp_full,knasp', ;
      {MrshNppr,kklr,round(vsvr,0),kln->GpsLat,kln->GpsLon,kln->nkl,kln->adr,kln->(adr_full('kklr')),kln->knasp})
      repl  agp  with agp_full
      If Empty(GpsLat)
        // -8 нет к-т
        repl agp with '*'+agp
        If empty(npp)
          repl npp with -8
        EndIf

      EndIf
    else
      netrepl('ves', {ves+vsvr})
    endif



    sele czg
    skip
  enddo
  Return (Nil)

/*****************************************************************
 
 FUNCTION:
 АВТОР..ДАТА..........С. Литовка  03-14-18 * 03:51:48pm
 НАЗНАЧЕНИЕ.........
 ПАРАМЕТРЫ..........
 ВОЗВР. ЗНАЧЕНИЕ....
 ПРИМЕЧАНИЯ.........
 */
FUNCTION vLpt(vLpt, vLpt1, cMessPrn, cTxtFile)
  LOCAL aLpt
    aLpt:={'Lpt1', 'Lpt2', 'Lpt3', 'Файл:'+cTxtFile }
    vLpt:=alert(cMessPrn, aLpt)
    do case
    case (str(vLpt,1)$'1;2;3')
      vLpt1:=aLpt[vLpt]
    case (vLpt=4  .or. vLpt=0)
      vLpt:=1
      vLpt1:=cTxtFile

    endcase
    set prin to (vLpt1)
    //If vLpt=4  .or. vLpt=0
    //  ViewFileText(vLpt1)
    //EndIf
  RETURN (NIL)

/*****************************************************************
 
 FUNCTION:
 АВТОР..ДАТА..........С. Литовка  08-27-18 * 12:27:34pm
 НАЗНАЧЕНИЕ......... получение пути где лежит развернутая ТТН и номера ТТН
 (возварт по ссылке)
 ПАРАМЕТРЫ..........
 ВОЗВР. ЗНАЧЕНИЕ....
 ПРИМЕЧАНИЯ.........
 */
STATIC FUNCTION cPathDecode(dTd,lc_skr,cListPr177,cPath,nTtn)
  skr:=lc_skr
  // по текущей дате
  PathYYMMr:='g'+str(year(dTd), 4)+'\m'+iif(month(dTd)<10, '0'+str(month(dTd), 1), str(month(dTd), 2))+'\'
  pathdr=gcPath_e+PathYYMMr
  path129dr=gcPath_129+PathYYMMr
  path139dr=gcPath_139+PathYYMMr
  path169dr=gcPath_169+PathYYMMr
  path177dr=gcPath_177+PathYYMMr
  path151dr=gcPath_151+PathYYMMr

  // с учетом склада
  cskl->(netseek('t1', 'skr'))
  pathr=pathdr+alltrim(cskl->path)
  path129r=path129dr+allt(cskl->path)
  path139r=path139dr+allt(cskl->path)
  path151r=path151dr+allt(cskl->path)
  path169r=path169dr+allt(cskl->path)
  path177r=path177dr+allt(cskl->path)
  // outlog(__FILE__,__LINE__,cskl->(found()),path177r)

  // доки свернутые ttn_r -> cсылка на свернутую ТТН, там
  // ищем развернутую ТТН
  Do Case
  Case (str(_field->pr129,1)$cListPr177)
    nTtn=_field->ttn129
    cPath=path129r
  Case (str(_field->pr139,1)$cListPr177)
    nTtn=_field->ttn139
    cPath=path139r
  Case (str(_field->pr169,1)$cListPr177)
    nTtn=_field->ttn169
    cPath=path169r
  Case  (str(_field->pr177,1)$cListPr177)
    //nTtn=
    cPath=path177r
  case (gnEnt=21.and._field->ttnt=999999)
    //nTtn=
    cPath=path151r
  EndCase
  RETURN (NIL)


/*****************************************************************
 
 FUNCTION:
 АВТОР..ДАТА..........С. Литовка  08-27-18 * 03:35:24pm
 НАЗНАЧЕНИЕ......... поверка на ИЛИ признаков
 ПАРАМЕТРЫ..........
 ВОЗВР. ЗНАЧЕНИЕ....
 ПРИМЕЧАНИЯ.........
 */
FUNCTION pr177_or(cListPr177)
  LOCAL lInClude:=.f.
  // aeval({"pr169",'pr139','pr129'},{|cFld| iif(str(eval(fieldblock()),1) = '0;1;' })
  Do Case
  Case (str(_field->pr129,1)$cListPr177)
    lInClude:=.T.
  Case (str(_field->pr139,1)$cListPr177)
    lInClude:=.T.
  Case (str(_field->pr169,1)$cListPr177)
    lInClude:=.T.
  Case  (str(_field->pr177,1)$cListPr177)
    lInClude:=.T.
  case (gnEnt=21.and._field->ttnt=999999)
    lInClude:=.T.
  EndCase

  RETURN (lInClude)

/*****************************************************************
 
 FUNCTION:
 АВТОР..ДАТА..........С. Литовка  06-30-19 * 12:46:19pm
 НАЗНАЧЕНИЕ......... удаление свернутых ТТН из маршрута
 ПАРАМЕТРЫ..........
 ВОЗВР. ЗНАЧЕНИЕ....
 ПРИМЕЧАНИЯ.........
 */
FUNCTION TtnUcDel4Mrsh(nMrsh)
  LOCAL dTd  := gdTd //dTd = CTOD('01.03.2019')
  LOCAL cEnt := gcNent //'LODIS'
  LOCAL cSkl := substr(gcDir_t,1,len(gcDir_t)-1) //'LOD01'
  path := gcPath_t

  outlog(3,__FILE__,__LINE__,'dTd,cEnt,cSkl,nMrsh,path')
  outlog(3,__FILE__,__LINE__,dTd,cEnt,cSkl,nMrsh,path)

  // Return

  netuse('rs1') //  use trsho14.dbf alias rs1
  netuse('rs2') //use trsho15.dbf alias rs2

  sele rs1
  copy to ListTtn field  ttn ;
    for  mrsh = nMrsh .and. Pr169=2 ;

  use ListTtn new
  sele ListTtn
  Do While !eof()
    outlog(3,__FILE__,__LINE__,"  ",ListTtn->Ttn,'ListTtn->Ttn')
    del4ttn(ListTtn->Ttn,  cSkl, dTd, cEnt)

    sele ListTtn
    skip
  EndDo
  //wait

  sele ListTtn
  use
  sele rs1
  use
  sele rs2
  use

  RETURN

/*****************************************************************
 
 FUNCTION:
 АВТОР..ДАТА..........С. Литовка  03-04-19 * 11:49:44am
 НАЗНАЧЕНИЕ.........
 ПАРАМЕТРЫ..........
 ВОЗВР. ЗНАЧЕНИЕ....
 ПРИМЕЧАНИЯ.........
 */
STATIC Function del4ttn(nTtn, cSkl, dTd, cEnt)
  LOCAL cPth:='J:\' +cEnt + '\TTN169';
  + '\G' + STR(YEAR(dTd),4);
  + '\M' + padl(ltrim(str(month(dTd),2)),2,'0');
  + '\' + cSkl;
  + '\T' + AllT(STR(nTtn,6))+'\'

  sele rs1
  locate for ttn = nTtn
  If found() .and. !deleted()
    // ? "удаление с =2"
    netDEL() // ttn = nTtn ; // удаление pr169=2
    //return

    // удаление pr169=1 и прописанным куда ушли данные
    DBEval({|| netDEL() },{||ttn169 = nTtn})

    // востановление шапки в rs1
    append from (cPth+'trsho14.dbf')

    // востановление строк
    sele rs2
    DBEval({|| netDEL() },{||ttn = nTtn})
    append from (cPth+'trsho15.dbf')
  EndIf

  RETURN (NIL)

