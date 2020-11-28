// Загрузка автотранспорта
#include "common.ch"
#include "inkey.ch"
set colo to g/n, n/g,,,
clea
if (!netuse('cMrsh'))
  return
endif

prnppr=0
fopr=1                      // Для пакетной печати НН

if (!netfile('cMrsho'))
  crddop('cMrsho')
  netuse('cMrsho')
  netadd()
  nuse('cMrsho')
endif

netuse('atran')
netuse('czg')
netuse('kln')
netuse('speng')
netuse('s_tag')
netuse('atvm')
netuse('atvme')
netuse('cskl')
netuse('cskle')
netuse('mkeep')
netuse('mkeepe')
netuse('kpl')
netuse('kgp')
netuse('krn')
netuse('knasp')
netuse('ctov')
netuse('banks')
netuse('klndog')
netuse('klnnac')
netuse('grpe')
netuse('dclr')
netuse('mvz')
netuse('dkkln')
netuse('dknap')
netuse('bs')
netuse('nnds')
netuse('dokk')
netuse('fop')
netuse('kspovo')
netuse('tov')
netuse('sgrp')

crtt('attntemp', "f:ent c:n(2) f:sk c:n(3) f:ttn c:n(6) f:Mrsh c:n(6) f:kecs c:n(3) f:necs c:c(12) f:kta c:n(4) f:nkta c:c(12) f:dtpoe c:d(8) f:dop c:d(8) dvzttn c:d(8) f:kop c:n(3) f:sdv c:n(12,2) f:sdvu c:n(12,2)")
sele 0
use attntemp excl
inde on str(ent, 2)+str(sk, 3)+str(ttn, 6)+str(Mrsh, 6) tag t1
inde on dtos(dtpoe)+str(Mrsh, 6)+str(ent, 2)+str(sk, 3)+str(ttn, 6) tag t2
set orde to tag t1

crtt('attemp', "f:Mrsh c:n(6)")
sele 0
use attemp excl
inde on str(Mrsh, 6) tag t1

crtt('atdocs', "f:Mrsh c:n(6) f:ent c:n(2) f:sk c:n(3) f:ttn c:n(6) f:vo c:n(2) f:kop c:n(3) f:kkl c:n(7) f:nkl c:c(30) f:vsv c:n(11,3) f:vsvb c:n(11,3) f:sdvu c:n(15,2) f:sdv c:n(15,2) f:dsp c:d(10) f:dot c:d(10) f:tot c:c(8) f:pri c:n(1) f:tsp c:c(8) f:vMrsh c:n(2) f:dtro c:d(10) f:vts c:c(1) f:mppsf c:n(2) f:pvt c:n(1) f:kta c:n(4) f:vz c:n(2) f:ttnp c:n(6) f:ttnc c:n(6) f:kpl c:n(7) f:ktas c:n(4) f:ztxt c:c(200) f:pl c:n(7) f:gp c:n(7) f:d0k1 c:n(1)")
sele 0
use atdocs excl
inde on str(ent, 2)+str(sk, 3)+str(ttn, 6) tag t1
inde on str(Mrsh, 6)+str(ent, 2)+str(sk, 3)+str(ttn, 6) tag t2
inde on str(pri, 1)+nkl tag t3
inde on str(ent, 2)+str(sk, 3)+str(d0k1, 1)+str(ttn, 6) tag t4
inde on str(Mrsh, 6)+str(ent, 2)+str(sk, 3)+str(d0k1, 1)+str(ttn, 6) tag t5
set orde to tag t1

sele cMrsh
set orde to tag t1
go top

atrcr=1
while (.t.)
  /*if gnAdm=0 */
  //   arcr:={'Район','Город','Остальные'}
  /*else */
  if (gnEnt=20)
    arcr:={ 'Район', 'Город', 'Остальные', 'Славутич' }
  else
    arcr:={ 'Район', 'Город', 'Остальные' }
  endif

  /*endif */
  atrcr=alert('Выбор', arcr)
  if (lastkey()=K_ESC)
    exit
  endif

  if (atrcr=3)
    atrcr=0
  endif

  if (select('sl')=0)
    sele 0
    use _slct alias sl excl
  endif

  sele sl
  zap
  prAllr=0
  attempr=1
  if (gdTd=date())
    if (prAllr=0)
      forr='(dMrsh>date()-15.or.prZ=0)'
      for_r='(dMrsh>date()-15.or.prZ=0)'
    else
      forr='.t.'
      for_r='.t.'
    endif

  else
    forr='.t.'
    for_r='.t.'
  endif

  anom_r=space(10)
  afor_r='.t.'
  save scre to scczg
  sele cMrsh
  set orde to tag t3
  netseek('t3', 'atrcr')
  rcMrshr=recn()
  rcMrsh1r=recn()
  rcMrsh2r=recn()
  prAndr=0
  nrzasdvr=0
  Mrshdelr=0
  prDelr=0
  fldnomr=1
  while (.t.)
    sele cMrsh
    dbunlock()
    if (prAndr=0.or.prAndr=2.or.prAndr=3)
      set orde to tag t3
      rcMrshr=rcMrsh1r
      if (rcMrshr=0)
        sele cMrsh
        set orde to tag t3
        netseek('t3', 'atrcr')
        rcMrshr=recn()
      endif

      go rcMrshr
    else
      set orde to tag t4
      rcMrshr=rcMrsh2r
      go rcMrshr
    endif

    set cent off
    do case
    case (prAndr=0.and.atrcr=4)
      foot('F2,F3,F4,F5,F6,F7,F8,F9,F10', 'Из файла,Поиск,Корр,ПечМар,ПодС,ПечОтч,ПодД,ПечЗагр,Задан')
      //              rcMrshr=slce('cMrsh',1,,18,,"e:Mrsh h:' N' c:n(6) e:dtpoe h:'Дата' c:d(8) e:getfield('t1','cMrsh->vMrsh','atvm','nvMrsh') h:'Маршр. ' c:c(7) e:anom h:'Номер' c:c(6) e:ogrpod h:'ГП' c:n(4,1) e:vsv h:'Вес' c:n(5) e:vsvb h:'ВесБ' c:n(5) e:sdv h:'Сумма' c:n(6) e:getfield('t1','cMrsh->kecs','s_tag','fio') h:'Экспедит' c:c(8) e:dfio h:'Водитель' c:c(8) e:cntkkl h:'KM' c:n(2) e:prZ h:'П' c:n(1) e:prZo h:'X' c:n(1)",,,1,'atrc=atrcr',forr,,'Маршрутные листы 3 Славутич')
      rcMrshr=slce('cMrsh', 1,, 18,, "e:Mrsh h:' N' c:n(6) e:dtpoe h:'Дата' c:d(8) e:getfield('t1','cMrsh->vMrsh','atvm','nvMrsh') h:'Маршр. ' c:c(7) e:anom h:'Номер' c:c(6) e:ogrpod h:'ГП' c:n(4,1) e:vsv h:'Вес' c:n(5) e:vsvb h:'ВесБ' c:n(5) e:sdv h:'Сумма' c:n(6) e:getfield('t1','cMrsh->kecs','s_tag','fio') h:'Экспедит' c:c(8) e:dfio h:'Водитель' c:c(8) e:cntkkl h:'KM' c:n(2) e:prZ h:'П' c:n(1) e:prZo h:'X' c:n(1) e:anom h:'Номер' c:c(10)",,, 1, 'atrc=atrcr', forr,, 'Маршрутные листы 3 Славутич')
      rcMrsh1r=rcMrshr
    case (prAndr=0.and.atrcr#4)
      foot('F2,F3,F4,F5,F6,F7,F8,F9,F10', 'Вид,Поиск,Корр,ПечМар,ПодС,ПечОтч,ПодД,ПечЗаг,Задан')

      if (Mrshdelr=0)
        if (fieldpos('vsvb')=0)
          rcMrshr=slcf('cMrsh', 1,, 18,, "e:Mrsh h:' N' c:n(6) e:dtpoe h:'Дата' c:d(8) e:getfield('t1','cMrsh->vMrsh','atvm','nvMrsh') h:'Маршрут' c:c(8) e:anom h:'Номер' c:c(6) e:ogrpod h:'ГП' c:n(4,1) e:vsv h:'Вес' c:n(5) e:sdv h:'Сумма' c:n(6) e:getfield('t1','cMrsh->kecs','s_tag','fio') h:'Экспедитор' c:c(9) e:dfio h:'Водитель' c:c(9) e:cntkkl h:'KM' c:n(2) e:prZ h:'П' c:n(1) e:prZo h:'X' c:n(1)",,, 1, 'atrc=atrcr', forr,, 'Маршрутные листы 3 '+iif(atrcr=1, 'район', iif(atrcr=2, 'город', 'остальные')))
        else
          //                    rcMrshr=slce('cMrsh',1,,18,,"e:Mrsh h:' N' c:n(6) e:dtpoe h:'Дата' c:d(8) e:getfield('t1','cMrsh->vMrsh','atvm','nvMrsh') h:'Маршрут' c:c(8) e:anom h:'Номер' c:c(6) e:ogrpod h:'ГП' c:n(4,1) e:vsv h:'Вес' c:n(5) e:vsvb h:'ВесБ' c:n(5) e:sdv h:'Сумма' c:n(6) e:getfield('t1','cMrsh->kecs','s_tag','fio') h:'Экспедитор' c:c(9) e:dfio h:'Водитель' c:c(9) e:cntkkl h:'KM' c:n(2) e:prZ h:'П' c:n(1) e:prZo h:'X' c:n(1)",,,1,'atrc=atrcr',forr,,'Маршрутные листы 3 '+iif(atrcr=1,'район',iif(atrcr=2,'город','остальные')))
          if (fieldpos('sdvu')=0)
            rcMrshr=slce('cMrsh', 1,, 18,, "e:Mrsh h:' N' c:n(6) e:dtpoe h:'Дата' c:d(8) e:getfield('t1','cMrsh->vMrsh','atvm','nvMrsh') h:'Маршр. ' c:c(7) e:anom h:'Номер' c:c(6) e:ogrpod h:'ГП' c:n(4,1) e:vsv h:'Вес' c:n(5) e:vsvb h:'ВесБ' c:n(5) e:sdv h:'Сумма' c:n(6) e:getfield('t1','cMrsh->kecs','s_tag','fio') h:'Экспедит' c:c(8) e:dfio h:'Водитель' c:c(8) e:cntkkl h:'KM' c:n(2) e:prZ h:'П' c:n(1) e:prZo h:'X' c:n(1)",,, 1, 'atrc=atrcr', forr,, 'Маршрутные листы 3 '+iif(atrcr=1, 'район', iif(atrcr=2, 'город', 'остальные')))
          else
            if (gnEnt=20)
              rcMrshr=slce('cMrsh', 1,, 18,, "e:Mrsh h:' N' c:n(6) e:dtpoe h:'Дата' c:d(8) e:getfield('t1','cMrsh->vMrsh','atvm','nvMrsh') h:'Маршр.' c:c(6) e:anom h:'Номер' c:c(6) e:ogrpod h:'ГП' c:n(4,1) e:vsv h:'Вес' c:n(5)  e:vsvb h:'ВесБ' c:n(5) e:sdv h:'Сумма' c:n(6) e:getfield('t1','cMrsh->kecs','s_tag','fio') h:'Экспедит' c:c(8) e:dfio h:'Водитель' c:c(8) e:cntkkl h:'KM' c:n(2) e:prZ h:'П' c:n(1) e:prZo h:'X' c:n(1) e:sdvu h:'См Уч' c:n(6)",,, 1, 'atrc=atrcr', forr,, 'Маршрутные листы 3 '+iif(atrcr=1, 'район', iif(atrcr=2, 'город', 'остальные')))
            else
              rcMrshr=slce('cMrsh', 1,, 18,, "e:Mrsh h:' N' c:n(6) e:dtpoe h:'Дата' c:d(8) e:getfield('t1','cMrsh->vMrsh','atvm','nvMrsh') h:'Маршр.' c:c(6) e:anom h:'Номер' c:c(6) e:ogrpod h:'ГП' c:n(4,1) e:vsv h:'Вес' c:n(5) e:sdvu h:'См Уч' c:n(6) e:sdv h:'Сумма' c:n(6) e:getfield('t1','cMrsh->kecs','s_tag','fio') h:'Экспедит' c:c(8) e:dfio h:'Водитель' c:c(8) e:cntkkl h:'KM' c:n(2) e:prZ h:'П' c:n(1) e:prZo h:'X' c:n(1) e:vsvb h:'ВесБ' c:n(5)",,, 1, 'atrc=atrcr', forr,, 'Маршрутные листы 3 '+iif(atrcr=1, 'район', iif(atrcr=2, 'город', 'остальные')))
            endif

          endif

        endif

      else
        rcMrshr=slcf('cMrsh', 1,, 18,, "e:Mrsh h:' N' c:n(6) e:dtpoe h:'Дата' c:d(8) e:getfield('t1','cMrsh->vMrsh','atvm','nvMrsh') h:'Маршрут' c:c(8) e:iif(deleted(),'Уд','  ') h:'Уд' c:c(2) e:anom h:'Номер' c:c(6) e:ogrpod h:'ГП' c:n(4,1) e:vsv h:'Вес' c:n(5) e:sdv h:'Сумма' c:n(6) e:getfield('t1','cMrsh->kecs','s_tag','fio') h:'Экспедитор' c:c(9) e:dfio h:'Водитель' c:c(9) e:cntkkl h:'KM' c:n(2) e:prZ h:'П' c:n(1)",,, 1, 'atrc=atrcr', forr,, 'Маршрутные листы 3 '+iif(atrcr=1, 'район', iif(atrcr=2, 'город', 'остальные'))+' с удаленными')
      endif

      rcMrsh1r=rcMrshr
    case (prAndr=1)
      foot('F2,F3,F4,ENTER', 'Вид,Фильтр,Корр,Загр')
      rcMrshr=slcf('cMrsh', 1,, 18,, "e:anom h:'Номер' c:c(6) e:dMrsh h:'Дата' c:d(8) e:msdv h:'СуммаАТ' c:n(10,2) e:Mrsh h:' N' c:n(6) e:nMrsh h:'Маршрут' c:c(10) e:cntkkl h:'KM' c:n(2) e:getfield('t1','cMrsh->atran','atran','natran') h:'Транспорт' c:c(10) e:atrc h:'  ' c:n(2) e:getfield('t1','cMrsh->kecs','s_tag','fio') h:'Экспедитор' c:c(14) e:prZ h:'П' c:n(1)",,, 1,, forr,, 'Маршрутные листы 1 '+iif(atrcr=1, 'район', iif(atrcr=2, 'город', 'остальные')))
      rcMrsh2r=rcMrshr
    case (prAndr=2)
      foot('INS,DEL,ENTER,F2,F4,F5,F6,F7,F8,F9,F10', 'Доб,Удал,Загр,Вид,Корр,Печ.Маршр,ПодС,Печ.Отч,ПодД,ПечЗагр,Задан')
      rcMrshr=slcf('cMrsh', 1,, 18,, "e:Mrsh h:' N' c:n(6) e:getfield('t1','cMrsh->vMrsh','atvm','nvMrsh') h:'Направление' c:c(20) e:getfield('t1','cMrsh->katran','kln','nkl') h:'Транспорт' c:c(19) e:getfield('t1','cMrsh->katran','kln','tlf') h:'ГП' c:c(4) e:vsv h:'Вес кг' c:n(5) e:sdv h:'Сумма' c:n(6) e:getfield('t1','cMrsh->kecs','s_tag','fio') h:'Экспедитор' c:c(10) e:prZ h:'П' c:n(1) e:dMrsh h:'Дата' c:d(8)",,, 1, 'atrc=atrcr', forr,, 'Маршрутные листы 2 '+iif(atrcr=1, 'район', iif(atrcr=2, 'город', 'остальные')))
      rcMrsh1r=rcMrshr
    case (prAndr=3)
      foot('INS,DEL,ENTER,F2,F4,F5,F6,F7,F8,F9,F10', 'Доб,Удал,Загр,Вид,Корр,Печ.Маршр,ПодС,Печ.Отч,ПодД,ПечЗагр,Задан')
      rcMrshr=slcf('cMrsh', 1,, 18,, "e:Mrsh h:' N' c:n(6) e:nMrsh h:'Маршрут' c:c(10) e:cntkkl h:'KM' c:n(2) e:anom h:'Номер' c:c(6) e:getfield('t1','cMrsh->atran','atran','natran') h:'Транспорт' c:c(10) e:getfield('t1','cMrsh->atran','atran','grpod') h:'ГП' c:n(2) e:vsv h:'Вес кг' c:n(5) e:sdv h:'Сумма' c:n(6) e:getfield('t1','cMrsh->kecs','s_tag','fio') h:'Экспедитор' c:c(11) e:prZ h:'П' c:n(1) e:dMrsh h:'Дата' c:d(8)",,, 1, 'atrc=atrcr', forr,, 'Маршрутные листы 0 '+iif(atrcr=1, 'район', iif(atrcr=2, 'город', 'остальные')))
      rcMrsh1r=rcMrshr
    endcase

    set cent on
    sele cMrsh
    go rcMrshr
    Mrshr=Mrsh
    mrc_r=recn()
    nMrshr=nMrsh
    premr=prem
    if (fieldpos('prZo')#0)
      prZor=prZo
    else
      prZor=0
    endif

    if (fieldpos('Mrshp')#0)
      Mrshpr=Mrshp
    else
      Mrshpr=0
    endif

    if (fieldpos('vsvb')#0)
      vsvbr=vsvb
    else
      vsvbr=0
    endif

    if (fieldpos('sdvu')#0)
      sdvur=sdvu
    else
      sdvur=0
    endif

    if (fieldpos('svcz')#0)
      svczr=svcz            // Самовывоз/Центрозавоз
    else
      svczr=0
    endif

    ogrpodr=ogrpod
    katranr=katran
    katranpr=katranp
    atranr=atran
    if (katranr=0)
      natranr=space(20)
      grpodr=0
      kmr=0
    else
      natranr=getfield('t1', 'katranr', 'kln', 'nkl')
      grpodr=val(getfield('t1', 'katranr', 'kln', 'tlf'))
      kmr=val(getfield('t1', 'katranr', 'kln', 'ns1'))
      natranr=alltrim(natranr)+' '+str(grpodr, 4, 1)+' тн'
    endif

    if (katranpr=0)
      natranpr=''
      grpodpr=0
      kmpr=0
    else
      natranpr=getfield('t1', 'katranpr', 'kln', 'nkl')
      grpodpr=val(getfield('t1', 'katranpr', 'kln', 'tlf'))
      kmpr=val(getfield('t1', 'katranpr', 'kln', 'ns1'))
      natranpr=alltrim(natranpr)+' '+str(grpodpr, 4, 1)+' тн'
    endif

    anomr=anom
    dfior=dfio
    ktor=kto
    ktar=kta
    kecsr=kecs
    if (deleted())
      prDelr=1
    else
      prDelr=0
    endif

    mvsvr=vsv
    msdvr=sdv
    asdvr=msdv
    mrstr=mrst
    dtpoer=dtpoe
    prZr=prZ
    dMrshr=dMrsh
    vMrshr=vMrsh
    nvMrshr=getfield('t1', 'vMrshr', 'atvm', 'nvMrsh')
    necsr=getfield('t1', 'kecsr', 's_tag', 'fio')
    nktar=getfield('t1', 'ktar', 'speng', 'fio')
    nktor=getfield('t1', 'ktor', 'speng', 'fio')
    do case
    case (lastkey()=K_ESC)   // Выход
      set dele on
      exit
    case (lastkey()=K_LEFT)   // Left
      fldnomr=fldnomr-1
      if (fldnomr=0)
        fldnomr=1
      endif

    case (lastkey()=K_RIGHT)    //
      fldnomr=fldnomr+1
    case (lastkey()=K_F2)   // Вид
      if (atrcr#4)
        do case
        case (prAndr=0)
          prAndr=1
          forr=afor_r
          set orde to tag t4
          go top
        case (prAndr=1)
          prAndr=2
          forr=for_r
          set orde to tag t3
          netseek('t3', 'atrcr')
        case (prAndr=2)
          prAndr=3
        case (prAndr=3)
          prAndr=0
        endcase

      else
        Mrsh19i()           // Загрузить готовые маршруты из Славутича
      endif

      rcMrshr=recn()
    case (lastkey()=-31)  // Выложить ттн для маршрутов Славутичу
                            //              Mrsh19o()
    case (lastkey()=-32.and.Mrshdelr=0.and.prAndr#1)
      sele attemp
      if (recc()#0)
        zap
      endif

      attempr=1
      atemp:={ 'Все', 'Не отгруженные', 'Не возвращенные' }
      attempr=alert('Маршруты', atemp)
      if (lastkey()=K_ESC)
        loop
      endif

      do case
      case (attempr=1)    // Все
        if (recc()#0)
          sele attemp
          zap
        endif

        forr=for_r
        sele cMrsh
        set orde to tag t3
        netseek('t3', 'atrcr')
        rcMrshr=recn()
        rcMrsh1r=recn()
        rcMrsh2r=recn()
      case (attempr=2)    // Не отгруженные
        sele czg
        if (fieldpos('dop')#0)
          set orde to tag t1
          sele cMrsh
          if (netseek('t3', 'atrcr'))
            while (atrc=atrcr.and.prZ#2)
              Mrsh_r=Mrsh
              sele czg
              if (netseek('t1', 'Mrsh_r'))
                while (Mrsh=Mrsh_r)
                  if (empty(dop))
                    sele attemp
                    appe blank
                    repl Mrsh with Mrsh_r
                  endif

                  sele czg
                  skip
                enddo

              endif

              sele cMrsh
              skip
            enddo

            sele attemp
            if (recc()#0)
              sele cMrsh
              if (netseek('t3', 'atrcr'))
                rcMrsh1r=recn()
                forr=for_r+".and.netseek('t1','cMrsh->Mrsh','attemp')"
                loop
              endif

            endif

          endif

        endif

      case (attempr=3)    // Не возвращенные
        sele czg
        if (fieldpos('dvzttn')#0)
          set orde to tag t1
          sele cMrsh
          if (netseek('t3', 'atrcr,2'))
            while (atrc=atrcr.and.prZ=2)
              Mrsh_r=Mrsh
              sele czg
              if (netseek('t1', 'Mrsh_r'))
                while (Mrsh=Mrsh_r)
                  if (empty(dvzttn))
                    sele attemp
                    appe blank
                    repl Mrsh with Mrsh_r
                  endif

                  sele czg
                  skip
                enddo

              endif

              sele cMrsh
              skip
            enddo

            sele attemp
            if (recc()#0)
              sele cMrsh
              if (netseek('t3', 'atrcr'))
                rcMrsh1r=recn()
                forr=for_r+".and.netseek('t1','cMrsh->Mrsh','attemp')"
                loop
              endif

            endif

          endif

        endif

      endcase

    case (lastkey()=-33.and.Mrshdelr=0.and.prAndr#1)
      store gdTd to dt1r, dt2r
      cldtpoe=setcolor('gr+/b,n/w')
      wdtpoe=wopen(7, 10, 10, 60)
      wbox(1)
      @ 0, 1 say 'Период поездки '
      @ 0, col()+1 get dt1r
      @ 0, col()+1 get dt2r
      read
      wclose(wdtpoe)
      setcolor(cldtpoe)
      if (lastkey()=K_ESC)
        loop
      endif

      sele attntemp
      if (recc()#0)
        zap
      endif

      attntempr=1
      atemp:={ 'Не отгруженные', 'Не возвр 2', 'Отгр.Не Возвр.' }
      attntempr=alert('ТТН', atemp)
      if (lastkey()=K_ESC)
        loop
      endif

      do case
      case (attntempr=1)  // Не отгруженные
        sele czg
        if (fieldpos('dop')#0)
          set orde to tag t1
          sele cMrsh
          if (netseek('t3', 'atrcr'))
            while (atrc=atrcr.and.prZ#2)
              if (dtpoe<dt1r.or.dtpoe>dt2r)
                sele cMrsh
                skip
                loop
              endif

              dtpoe_r=dtpoe
              Mrsh_r=Mrsh
              kecs_r=kecs
              necs_r=getfield('t1', 'kecs_r', 's_tag', 'fio')
              sele czg
              if (netseek('t1', 'Mrsh_r'))
                while (Mrsh=Mrsh_r)
                  if (!empty(dop))
                    sele czg
                    skip
                    loop
                  endif

                  sk_r=sk
                  ttn_r=ttn
                  if (fieldpos('kta')#0)
                    kta_r=kta
                  else
                    kta_r=0
                  endif

                  nkta_r=getfield('t1', 'kta_r', 's_tag', 'fio')
                  sele attntemp
                  appe blank
                  repl Mrsh with Mrsh_r, ;
                   sk with sk_r,         ;
                   ttn with ttn_r,       ;
                   kecs with kecs_r,     ;
                   necs with necs_r,     ;
                   kta with kta_r,       ;
                   nkta with nkta_r,     ;
                   dtpoe with dtpoe_r
                  sele czg
                  skip
                enddo

              endif

              sele cMrsh
              skip
            enddo

            sele attntemp
            go top
            rctnr=slcf('attntemp', 1,, 18,, "e:sk h:'SK' c:n(3) e:ttn h:'ТТН' c:n(6) e:Mrsh h:' N' c:n(6) e:dtpoe h:'Дата П' c:d(10) e:kecs h:'КЭ' c:n(3) e:necs h:'Экспедитор' c:c(11) e:kta h:'КТА' c:n(4) e:nkta h:'Агент' c:c(11) ",,,,,, 'n/bg,n/w', 'ТТН не отгруженные '+dtoc(dt1r)+' '+dtoc(dt2r))
            sele cMrsh
          endif

        endif

      case (attntempr=2)  // Не возвращенные 2
        sele czg
        if (fieldpos('dop')#0)
          set orde to tag t1
          sele cMrsh
          set orde to tag t3
          if (netseek('t3', 'atrcr,2'))
            while (atrc=atrcr)
              if (dtpoe<dt1r.or.dtpoe>dt2r)
                sele cMrsh
                skip
                loop
              endif

              Mrsh_r=Mrsh
              dtpoe_r=dtpoe
              kecs_r=kecs
              necs_r=getfield('t1', 'kecs_r', 's_tag', 'fio')
              sele czg
              if (netseek('t1', 'Mrsh_r'))
                while (Mrsh=Mrsh_r)
                  if (!empty(dvzttn))
                    sele czg
                    skip
                    loop
                  endif

                  sk_r=sk
                  ttn_r=ttn
                  if (fieldpos('kta')#0)
                    kta_r=kta
                  else
                    kta_r=0
                  endif

                  nkta_r=getfield('t1', 'kta_r', 's_tag', 'fio')
                  sele attntemp
                  appe blank
                  repl Mrsh with Mrsh_r, ;
                   sk with sk_r,         ;
                   ttn with ttn_r,       ;
                   kecs with kecs_r,     ;
                   necs with necs_r,     ;
                   kta with kta_r,       ;
                   nkta with nkta_r,     ;
                   dtpoe with dtpoe_r
                  sele czg
                  skip
                enddo

              endif

              sele cMrsh
              skip
            enddo

            sele attntemp
            go top
            set cent off
            rctnr=slcf('attntemp', 1,, 18,, "e:sk h:'SK' c:n(3) e:ttn h:'ТТН' c:n(6) e:Mrsh h:' N' c:n(6) e:dtpoe h:'Дата П' c:d(8) e:kecs h:'КЭ' c:n(3) e:necs h:'Экспедитор' c:c(11) e:kta h:'КТА' c:n(4) e:nkta h:'Агент' c:c(11) ",,,,,, 'n/bg,n/w', 'ТТН не возвращенные '+dtoc(dt1r)+' '+dtoc(dt2r))
            set cent on
            sele cMrsh
          endif

        endif

      case (attntempr=3)  // Отгруженные не возвращенные
        sele czg
        if (fieldpos('dop')#0)
          set orde to tag t1
          sele cMrsh
          set orde to tag t3
          if (netseek('t3', 'atrcr'))
            while (atrc=atrcr)
              if (dtpoe<dt1r.or.dtpoe>dt2r)
                sele cMrsh
                skip
                loop
              endif

              Mrsh_r=Mrsh
              dtpoe_r=dtpoe
              kecs_r=kecs
              necs_r=getfield('t1', 'kecs_r', 's_tag', 'fio')
              sele czg
              if (netseek('t1', 'Mrsh_r'))
                while (Mrsh=Mrsh_r)
                  if (empty(dop))
                    sele czg
                    skip
                    loop
                  endif

                  if (!empty(dvzttn))
                    sele czg
                    skip
                    loop
                  endif

                  sk_r=sk
                  ttn_r=ttn
                  kop_r=kop
                  sdv_r=sdv
                  if (fieldpos('sdvu')#0)
                    sdvu_r=sdvu
                  else
                    sdvu_r=0
                  endif

                  if (fieldpos('kta')#0)
                    kta_r=kta
                  else
                    kta_r=0
                  endif

                  dop_r=dop
                  nkta_r=getfield('t1', 'kta_r', 's_tag', 'fio')
                  sele attntemp
                  appe blank
                  repl Mrsh with Mrsh_r, ;
                   sk with sk_r,         ;
                   ttn with ttn_r,       ;
                   kecs with kecs_r,     ;
                   necs with necs_r,     ;
                   kta with kta_r,       ;
                   nkta with nkta_r,     ;
                   dtpoe with dtpoe_r,   ;
                   dop with dop_r,       ;
                   kop with kop_r,       ;
                   sdv with sdv_r,       ;
                   sdvu with sdvu_r
                  sele czg
                  skip
                enddo

              endif

              sele cMrsh
              skip
            enddo

            sele attntemp
            set orde to tag t2
            go top
            set cent off
            rctnr=slcf('attntemp', 1,, 18,, "e:sk h:'SK' c:n(3) e:ttn h:'ТТН' c:n(6) e:kop h:'КОП' c:n(3) e:sdv h:'Сумма' c:n(9,2) e:Mrsh h:' N' c:n(6) e:dop h:'Дата O' c:d(8) e:dtpoe h:'Дата П' c:d(8) e:kecs h:'КЭ' c:n(3) e:necs h:'Экспедитор' c:c(10) e:kta h:'КТА' c:n(4) e:nkta h:'Агент' c:c(10) ",,,,,, 'n/bg,n/w', 'Отгруженные не возвращенные '+dtoc(dt1r)+' '+dtoc(dt2r))
            set cent on
            sele cMrsh
          endif

        endif

      endcase

    case (lastkey()=K_F3.and.Mrshdelr=0)
      if (prAndr=1)       // Фильтр
        clmflt=setcolor('gr+/b,n/w')
        wmflt=wopen(7, 20, 11, 50)
        wbox(1)
        @ 0, 1 say 'Неразнесенные' get nrzasdvr pict '9'
        @ 1, 1 say 'Номер        ' get anom_r
        read
        wclose(wmflt)
        setcolor(clmflt)
        if (nrzasdvr=0)
          forr=afor_r
        endif

        if (nrzasdvr=1)
          forr=afor_r+'.and.msdv=0'
        endif

        if (!empty(anom_r))
          anom_rr=alltrim(anom_r)
          forr=forr+'.and.at(anom_rr,anom)#0'
        endif

        go top
        rcMrshr=recn()
      else
        clmflt=setcolor('gr+/b,n/w')
        wmflt=wopen(7, 20, 11, 50)
        wbox(1)
        store 0 to Mrsh_r, ttn_r
        @ 0, 1 say 'Маршр.лист' get Mrsh_r pict '999999'
        @ 1, 1 say 'ТТН       ' get ttn_r pict '999999'
        read
        wclose(wmflt)
        setcolor(clmflt)
        do case
        case (Mrsh_r#0.and.ttn_r#0)
          wmess('Только одно значение')
        case (Mrsh_r#0.and.ttn_r=0)
          sele cMrsh
          locate for Mrsh=Mrsh_r
          if (foun())
            if (atrc#atrcr)
              wmess('В направлении '+str(atrc, 1))
            else
              rcMrshr=recn()
              rcMrsh1r=recn()
              rcMrsh2r=recn()
            endif

          else
            wmess('Не найден', 2)
          endif

        case (Mrsh_r=0.and.ttn_r#0)
          sele czg
          locate for ttn=ttn_r
          if (foun())
            Mrsh_r=Mrsh
            sele cMrsh
            locate for Mrsh=Mrsh_r
            if (foun())
              if (atrc#atrcr)
                wmess('В направлении '+str(atrc, 1))
              else
                rcMrshr=recn()
                rcMrsh1r=recn()
                rcMrsh2r=recn()
              endif

            else
              wmess('Не найден марш.лист '+str(Mrsh_r, 6), 2)
            endif

          else
            wmess('Не найдена', 2)
          endif

        otherwise
          loop
        endcase

        sele cMrsh
      endif

    case (lastkey()=K_ENTER.and.premr=0)// Загрузка
      if (!reclock(1))
        wmess('Маршрутный лист занят '+getfield('t1', 'cMrsh->ktoblk', 'speng', 'fio'), 2)
        loop
      endif

      czg()
      if (prDelr=0)
        czgend()
      endif

      sele cMrsh
      go rcMrshr
      dbunlock()
    case (lastkey()=K_F6.and.prAndr=0)//.and.gnAdm=1.and.prDelr=0.and.prZor=0 // Подтвердждение
      if (prZor=0)
        if (prZr=0)
          if (!reclock(1))
            wmess('Маршрутный лист занят', 2)
            loop
          endif

          netrepl('prZ', '1')
        endif

      else
        if (gnRml#0.or.gnAdm=1)
          netrepl('prZo', '0')
        endif

      endif

    case (lastkey()=K_INS.and.prAndr=0)// Добавить
      MrshIns()
    case (lastkey()=K_F4.and.prDelr=0)// Коррекция
      if (!reclock(1))
        wmess('Маршрутный лист занят', 2)
        loop
      endif

      MrshIns(1)
      sele cMrsh
      go rcMrshr
      dbunlock()
    case (lastkey()=K_DEL.and.prZr#2.and.prAndr=0.and.prDelr=0.and.prZor=0)// Удалить
      if (prZr=0)
        if (!reclock(1))
          wmess('Маршрутный лист занят', 2)
          loop
        endif

        cMrsho(1)
        sele atdocs
        repl all Mrsh with 0 for Mrsh=Mrshr
        sele czg
        set orde to tag t1
        if (netseek('t1', 'Mrshr'))
          sk_r=0
          while (Mrsh=Mrshr)
            skr=sk
            entr=ent
            ttnr=ttn
            if (skr#sk_r)
              nuse('rs1')
              sele cskl
              if (netseek('t1', 'skr'))
                entr=ent
                sele setup
                locate for ent=entr
                pathdr=gcPath_m+alltrim(nent)+'\'+gcDir_g+gcDir_d
                sele cskl
                pathr=pathdr+alltrim(path)
                netuse('rs1',,, 1)
                sk_r=skr
              endif

            endif

            if (select('rs1')#0)
              sele rs1
              if (netseek('t1', 'ttnr',,, 1))
                netrepl('Mrsh', '0')
              endif

            endif

            sele czg
            netdel()
            skip
          enddo

          nuse('rs1')
        //                    nuse('tovpt')
        endif

        sele cMrsh
        set orde to tag t3
        netdel()
        skip -1
        if (!bof())
          while (atrc#atrcr)
            skip -1
            if (bof())
              netseek('t3', 'atrcr')
              exit
            endif

          enddo

        else
          netseek('t3', 'atrcr')
        endif

        rcMrshr=recn()
        rcMrsh1r=recn()
        rcMrsh2r=recn()
      endif

      if (prZr=1)         //.and.gnAdm=1
        if (!reclock(1))
          wmess('Маршрутный лист занят', 2)
          loop
        endif

        netrepl('prZ', '0')
      endif

    case (lastkey()=K_F5.and.prAndr=0.and.prDelr=0)// Печать маршр. листа
      if (!reclock(1))
        wmess('Маршрутный лист занят', 2)
        loop
      endif

      MrshList()
      sele cMrsh
      go rcMrshr
      dbunlock()
    case (lastkey()=-34)  // Печать НН к маршр. листу
      Mrshnds()
    case (lastkey()=K_F7.and.prAndr=0.and.Mrshdelr=0)// Печать отчета -6
      marshotch()
    case (lastkey()=K_F8.and.(prZr=1.or.prZr=2).and.(gnAdm=1.or.gnatMrsh=1).and.prAndr=0.and.prDelr=0)
      // Подтверждение доставки -7
      if (!reclock(1))
        wmess('Маршрутный лист занят', 2)
        loop
      endif

      if (prZr=1)
        netrepl('prZ', '2')
      else
        netrepl('prZ', '1')
      endif

      prZr=prZ
      if (prZr=2)
        dvzttnr=date()
      else
        dvzttnr=ctod('')
      endif

      sele czg
      if (.f..and.fieldpos('dvzttn')#0)
        set orde to tag t4
        if (netseek('t4', 'Mrshr'))
          sk_r=0
          while (Mrsh=Mrshr)
            netrepl('dvzttn', 'dvzttnr')
            ttnr=ttn
            entr=ent
            skr=sk
            if (skr#sk_r)
              pathrr=getfield('t1', 'skr', 'cskl', 'path')
              if (!empty(pathrr))
                sele setup
                locate for ent=entr
                pathdr=gcPath_m+alltrim(nent)+'\'+gcDir_g+gcDir_d
                pathr=pathdr+alltrim(pathrr)
                nuse('rs1')
                //                             nuse('tovpt')
                //                             netuse('tovpt',,,1)
                netuse('rs1',,, 1)
                sk_r=skr
              endif

            endif

            sele rs1
            if (fieldpos('dvzttn')#0)
              if (netseek('t1', 'ttnr',,, 1))
              //                             netrepl('dvzttn','dvzttnr')
              endif

            endif

            sele czg
            skip
          enddo

          nuse('rs1')
        //                    nuse('tovpt')
        endif

      endif

      sele cMrsh
    case (lastkey()=K_F9)   //печать на загрузку машины
      MrshZag()
    case (lastkey()=K_ALT_F9)   // Снять/установить фильтр
      if (prAllr=0)
        prAllr=1
      else
        prAllr=0
      endif

      if (prAllr=0)
        forr='(dMrsh>date()-15.or.prZ=0)'
        for_r='(dMrsh>date()-15.or.prZ=0)'
      else
        forr='.t.'
        for_r='.t.'
      endif

    case (lastkey()=-38)  // Удаленные
      if (Mrshdelr=0)
        Mrshdelr=1
        set dele off
      else
        Mrshdelr=0
        set dele on
      endif

    case (lastkey()=K_ALT_F8)  //.and.gnAdm=1 // Восстановление из архива
      PathDelr='j:\budinf\Mrshdel\'+space(30)
      cldel=setcolor('gr+/b,n/w')
      wdel=wopen(7, 10, 10, 60)
      wbox(1)
      @ 0, 1 say 'Путь' get PathDelr
      read
      PathDelr=alltrim(PathDelr)
      erase (PathDelr+'cMrsh.dbf')
      erase (PathDelr+'cMrsh.cdx')
      erase (PathDelr+'czg.dbf')
      erase (PathDelr+'czg.cdx')
      set dele off
      sele cMrsh
      copy to (PathDelr+'cMrsh.dbf') for deleted()
      sele czg
      copy to (PathDelr+'czg.dbf') for deleted()
      set dele on
      wclose(wdel)
      setcolor(cldel)
      if (!file(PathDelr+'cMrsh.dbf'))
        wmess('Нет файла'+' '+PathDelr+'cMrsh.dbf')
      else
        if (!file(PathDelr+'czg.dbf'))
          wmess('Нет файла'+' '+PathDelr+'czg.dbf')
        else
          set dele off
          sele 0
          use (PathDelr+'cMrsh.dbf') alias atm excl
          recall all
          if (recc()=0)
            wmess('Нет удаленных')
            CLOSE
          else
            sele 0
            use (PathDelr+'czg.dbf') alias atz excl
            recall all
            set dele on
            inde on str(Mrsh, 6) tag t1
            go top
            sele atm
            inde on str(Mrsh, 6) tag t1
            go top
            while (.t.)
              set cent off
              foot('F10', 'Восстановить')
              sele atm
              rcmr=slcf('atm', 1,, 18,, "e:Mrsh h:' N' c:n(6) e:dtpoe h:'Дата' c:d(8) e:getfield('t1','cMrsh->vMrsh','atvm','nvMrsh') h:'Маршрут' c:c(7) e:iif(deleted(),'Уд','  ')  h:'Уд' c:c(2) e:anom h:'Номер' c:c(6) e:val(getfield('t1','cMrsh->katran','kln','tlf')) h:'ГП' c:n(2) e:vsv h:'Вес кг' c:n(5) e:sdv h:'Сумма' c:n(6) e:getfield('t1','cMrsh->kecs','s_tag','fio') h:'Экспедитор' c:c(11) e:dfio h:'Водитель' c:c(10) e:cntkkl h:'KM' c:n(2) e:prZ h:'П' c:n(1)",,, 1,, "atrc=atrcr.and.!netseek('t2','atm->Mrsh','cMrsh')",, 'Маршрутные листы 3 '+iif(atrcr=1, 'район', iif(atrcr=2, 'город', 'остальные'))+' Архив')
              set cent on
              sele atm
              go rcmr
              Mrshr=Mrsh
              do case
              case (lastkey()=-9)
                sele cMrsh
                if (netseek('t2', 'Mrshr'))
                  wmess('Маршрут существует', 1)
                else
                  sele atz
                  if (netseek('t1', 'Mrshr'))
                    while (Mrsh=Mrshr)
                      skr=sk
                      ttnr=ttn
                      entr=ent
                      nuse('rs1d')
                      sele cskl
                      locate for sk=skr
                      prrclr=0
                      if (foun())
                        sele setup
                        locate for ent=entr
                        pathdr=gcPath_m+alltrim(nent)+'\'+gcDir_g+gcDir_d
                        sele cskl
                        pathr=pathdr+alltrim(path)
                        netuse('rs1', 'rs1d',, 1)
                        if (netseek('t1', 'ttnr',,, 1))
                          if (!deleted())
                            if (Mrsh=0)
                              prrclr=1
                            else
                              if (Mrsh=Mrshr)
                                prrclr=1
                              endif

                            endif

                          endif

                        endif

                      endif

                      if (prrclr=1)
                        sele czg
                        set orde to tag t3
                        if (!netseek('t3', 'skr,ttnr'))
                          sele atz
                          arec:={}
                          getrec()
                          sele czg
                          netadd()
                          putrec()
                        endif

                        sele rs1d
                        netrepl('Mrsh,kecs', 'Mrshr,kecsr')
                        nuse('rs1d')
                      endif

                      sele atz
                      skip
                    enddo

                    nuse('rs1d')
                  endif

                  sele atm
                  arec:={}
                  getrec()
                  sele cMrsh
                  netadd()
                  putrec()
                endif

              case (lastkey()=K_ESC)
                exit
              endcase

            enddo

            sele atm
            CLOSE
            sele atz
            CLOSE
          endif

        endif

      endif

      set dele on
    case (lastkey()=K_F10.and.prAndr=0.and.prDelr=0)// Печать задания
      if (!reclock(1))
        wmess('Маршрутный лист занят', 2)
        loop
      endif

      MrshZad()
      sele cMrsh
      go rcMrshr
      dbunlock()
    endcase

  enddo

  rest scre from scczg
enddo

if (select('atdocs')#0)
  sele atdocs
  CLOSE
endif

if (select('atotch')#0)
  sele atotch
  CLOSE
endif

if (select('attemp')#0)
  sele attemp
  CLOSE
  erase attemp.dbf
  erase attemp.cdx
endif

if (select('attntemp')#0)
  sele attntemp
  CLOSE
  erase attntemp.dbf
  erase attntemp.cdx
endif

nuse()

function MrshNds()
  clea
  crtt('tkkl', 'f:kkl c:n(7)')
  sele 0
  use tkkl excl
  sele czg
  if (netseek('t1', 'Mrshr'))
    while (Mrsh=Mrshr)
      skr=sk
      d0k1r=d0k1
      docr=ttn
      nuse('rs1')
      nuse('pr1')
      sele cskl
      locate for sk=skr
      if (foun())
        pathr=gcPath_d+alltrim(path)
        if (d0k1r=0)
          if (netfile('rs1', 1))
            netuse('rs1',,, 1)
            if (netseek('t1', 'docr'))
              //                  if prZ=1
              kklr=kpl
              pr1ndsr=getfield('t1', 'kklr', 'kpl', 'pr1nds')
              if (pr1ndsr=1)
                sele czg
                skip
                loop
              endif

              sele kln
              if (netseek('t1', 'kklr'))
                if (nn#0) //.and.!empty(nsv)
                  sele tkkl
                  locate for kkl=kklr
                  if (!foun())
                    appe blank
                    repl kkl with kklr
                  endif

                endif

              endif

            //                  endif
            endif

            nuse('rs1')
          endif

        else
          if (netfile('pr1', 1))
            netuse('pr1',,, 1)
            if (netseek('t2', 'docr'))
              //                  if prZ=1
              kklr=kps
              kopr=kop
              vor=vo
              pr1ndsr=getfield('t1', 'kklr', 'kpl', 'pr1nds')
              if (pr1ndsr=1.and.vor=1.and.kopr=110)
                sele czg
                skip
                loop
              endif

              ndr=nd
              sele kln
              if (netseek('t1', 'kklr'))
                if (nn#0) //.and.!empty(nsv)
                  sele tkkl
                  locate for kkl=kklr
                  if (!foun())
                    appe blank
                    repl kkl with kklr
                  endif

                endif

              endif

            //                  endif
            endif

            nuse('pr1')
          endif

        endif

      endif

      sele czg
      skip
    enddo

    sele tkkl
    rcctkklr=recc()
    if (rcctkklr#0)

      lpt_r=2
      alpt={ 'lpt1', 'lpt2', 'lpt3', 'Файл' }
      lpt_r=alert('ПЕЧАТЬ'+'('+str(rcctkklr, 3)+')', alpt)

      sele nnds
      go top
      while (!eof())
        if (nn#0.and.empty(dprn))//.and.!empty(nsv)
          kklr=kkl
          dnnr=dnn
          if (kklr#0)
            sele tkkl
            locate for kkl=kklr
            if (foun())
              sele nnds
              if (nnds->dnn<ctod('16.12.2011'))
                prnnn(nnds->mn, nnds->rnd, nnds->sk, nnds->rn, nnds->mnp, lpt_r, 1)
              else
                prnds(nnds->mn, nnds->rnd, nnds->sk, nnds->rn, nnds->mnp, lpt_r, 1)
              endif

            endif

          endif

        endif

        sele nnds
        skip
      enddo

    endif

  endif

  sele tkkl
  CLOSE
  /*erase tkkl.dbf */
  return (.t.)

/*****************************************************************
 
 FUNCTION:
 АВТОР..ДАТА..........С. Литовка  10-31-17 * 12:40:25pm
 НАЗНАЧЕНИЕ.........
 ПАРАМЕТРЫ..........
 ВОЗВР. ЗНАЧЕНИЕ....
 ПРИМЕЧАНИЯ.........
 */
FUNCTION MrshZag()

  MrshLkkl() // получим список точек

  sk_r:=0
  sele czg
  set orde to tag t5
  netseek('t5', 'Mrshr')
  while (Mrsh=Mrshr)
    // запонили скла и ТТН
    skr=sk;    ttnr=ttn
    // открыли таблицу
    if skr#sk_r
      nuse('tov')
      nuse('rs2')
      sele cskl
      if netseek('t1','skr')
          pathr=gcPath_d+alltrim(path)
          netuse('tov',,,1)
          netuse('rs2',,,1)
          sk_r=skr
      endif
    endif
    // поиск ттн в второй базе
    sele rs2
    if netseek('t1','ttnr')
      Do While ttnr=ttn
        // определение Отдела
        sklr=skl
        ktlr=ktl
        otr=getfield('t1','sklr,ktlr','tov','ot')
        If Empty(otr)
          otr=getfield('t1','int(ktlr/1000000)','sgrp','ot')
        EndIf
        // проверка и добаления списка отделов
        otr:=padl(allt(str(otr,2)),2,'0')
        sele lkkl
        locate for czg->kkl = kkl
        If !(otr $ list_ot)
          repl list_ot with allt(list_ot)+otr+';'
        EndIf

        sele rs2
        DBSkip()
      EndDo
    endif

    sele czg
    skip
  enddo
  nuse('rs2')



  sele lkkl
  inde on descend(npp) tag DescNpp



    alpt={ 'lpt1', 'lpt2', 'lpt3', 'Файл' }
    vlpt=alert('ПЕЧАТЬ ПЛАНА ЗАГРУЗКИ МАРШРУТНОГО ЛИСТА', alpt)
    ovlptr=vlpt
    do case
    case (vlpt=1)
      vlpt1='lpt1'
      set prin to &vlpt1
    case (vlpt=2)
      vlpt1='lpt2'
      set prin to &vlpt1
    case (vlpt=3)
      vlpt1='lpt3'
      set prin to &vlpt1
    case (vlpt=4)
      vlpt=1
      set prin to plzgr.txt
    endcase

  set prin on
  set cons off
  if (vlpt=1)
    if (empty(gcPrn))
      ??chr(27)+chr(80)+chr(15)
      rListr=62
    else
      ??chr(27)+'E'+chr(27)+'&l4h25a0O'+chr(27)+'&k2S'+chr(27)+'(3R'+chr(27)+'(s0p18.00h0s1b4102T'+chr(27)
      rListr=40
    endif

  else
    ??chr(27)+'E'+chr(27)+'&l4h25a0O'+chr(27)+'&k2S'+chr(27)+'(3R'+chr(27)+'(s0p18.00h0s1b4102T'+chr(27)
    rListr=40
  endif

  rswr=1 // строки
  lstr=1 // страницы
  AtSh() // заголовок
  sele lkkl
  DBGoTop()
  Do While !eof()

    ?'│'+padl(left(list_ot,36),36,' ')+'│'+padc(allt(str(npp)),5,' ')+'│'+str(kkl,7)+'│'+left(ngp,34)+'│';rslea()
    ?'│'+'                                    '+'│'+space(5)+'│'+space(7)+'│'+left(agp,34)+'│';rslea()
    DBSkip()
    If !eof()
      ?'├────────────────────────────────────┼─────┼───────┼──────────────────────────────────┤';rslea()
    EndIf
  EndDo

  ?'└────────────────────────────────────┴─────┴───────┴──────────────────────────────────┘';rslea()

  set prin off
  set prin to
  set cons on

  RETURN (NIL)

static proc rslea()
  rswr++
  if rswr>=rlistr
     rswr=1
     lstr++
     eject
     AtSh()
  endif
  retu

/*****************************************************************
 
 PROCEDURE:
 АВТОР..ДАТА..........С. Литовка  11-01-17 * 10:08:21am
 НАЗНАЧЕНИЕ.........
 ПАРАМЕТРЫ..........
 ПРИМЕЧАНИЯ.........
 */
static Procedure AtSh()
  ??'ПЛАН ЗАГРУЗКИ ТРАНСПОТРА К МАРШРУТНОМУ ЛИСТУ N'+' '+str(Mrshr, 6)+padl(iif(lstr>1,'стр.'+str(lstr,2),''),30);rslea()
  ?'┌────────────────────────────────────┬─────┬───────┬──────────────────────────────────┐';rslea()
  ?'│                                    │N П.П│  КОД  │   ТОРГОВАЯ ТОЧКА -  ПОЛУЧАТЕЛЬ   │';rslea()
  ?'│                                    │     │   ТТ  │         АДРЕС ДОСТАВКИ           │';rslea()
  ?'├────────────────────────────────────┼─────┼───────┼──────────────────────────────────┤';rslea()

  Return
