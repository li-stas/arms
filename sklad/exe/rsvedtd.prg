#include "common.ch"
#include "inkey.ch"
* Ведомость расхода текущего дня
clea
netuse('rs1')
netuse('rs2')
netuse('ctov')
netuse('kln')
netuse('soper')
netuse('s_tag')
netuse('speng')
netuse('sgrp')

store 0 to kop_r,tdtr,onvr
store bom(gdTd) to dt1r
store gdTd to dt2r
sele rs1
go top
forttnr='.t.'
forttn_r='.t.'
ttnprzr=0
ttngrpr=999
ttnmntovr=0
hdttnr='Все'
fldnomr=1
do while .t.
   sele rs1
   foot('F3,F5,F6,ENTER','Фильтр,Печать,Протокол,Товар')
   set cent off
   rcttnr=slce('rs1',1,,18,,"e:ttn h:'TTН' c:n(6) e:kop h:'КОП' c:n(3) e:sdv h:'Сумма' c:n(10,2) e:ddc h:'ДатаС' c:d(8) e:dvp h:'ДатаВ' c:d(8) e:dsp h:'ДатаФ' c:d(8) e:dop h:'ДатаО' c:d(8) e:dvzttn h:'ДатаВз' c:d(8) e:iif(rs1->prz=1,dot,ctod('')) h:'ДатаП' c:d(8) e:getfield('t1','rs1->kto','speng','fio') h:'Выписал' c:c(11) e:tvzttn h:'ВрВз' c:c(8) e:getfield('t1','rs1->kecs','s_tag','fio') h:'Экспедитор' c:c(15) e:mrsh h:'Маршр.' c:n(6)",,,,,forttnr,,hdttnr)
   set cent on
   sele rs1
   go rcttnr
   ttnr=ttn
   kgpr=kpv
   if kgpr=0
      kgpr=kgp
      if kgpr=0
         kgpr=kpl
      endif
   endif
   ngpr=alltrim(getfield('t1','kgpr','kln','nkl'))
   kopr=kop
   do case
      case lastkey()=K_ESC
           exit
      case lastkey()=19 // Left
           fldnomr=fldnomr-1
           if fldnomr=0
              fldnomr=1
           endif
      case lastkey()=4 // Right
           fldnomr=fldnomr+1
      case lastkey()=K_F3
           store 0 to kop_r,tdtr,onvr
           store bom(gdTd) to dt1r
           store gdTd to dt2r
           clttnr=setcolor('gr+/b,n/bg')
           wttnr=wopen(9,15,16,70)
           wbox(1)
           @ 0,1 say 'Признак   ' get ttnprzr pict '9'
           @ 0,col()+1 say '0Все;1Вып;2Сет;3Отг;4Дост;5Под;6СетНеПол'
           @ 1,1 say 'Группа    ' get ttngrpr pict '999'
           @ 1,col()+1 say 'Товар' get ttnmntovr pict '9999999'
           @ 2,1 say 'Код операц' get kop_r pict '999'
           @ 3,1 say 'Дата     c' get dt1r
           @ 3,col()+1 say 'по' get dt2r
           @ 3,col()+1 say 'Тип даты' get tdtr pict '9'
           @ 4,1 say '0Все;1Сист;2Вып;3ФП;4СП;5Отг;6Дст;7Под'
           @ 5,1 say 'ДатаО#ДатаВз' get onvr pict '9'
           read
           if lastkey()=K_ESC
              wclose(wttnr)
              setcolor(clttnr)
              loop
           endif
           do case
              case  ttnprzr=0 // Все
                    forttnr=forttn_r
                    hdttnr='Все'
              case  ttnprzr=1 // Вып
                    forttnr=forttn_r+'.and.empty(dsp).and.empty(dop)'
                    hdttnr='Выписанные'
              case  ttnprzr=2 // Сет
                    forttnr=forttn_r+'.and.!empty(dsp).and.empty(dop)'
                    hdttnr='Сетевые'
              case  ttnprzr=3 // Отгр
                    forttnr=forttn_r+'.and.!empty(dop).and.prz=0'
                    hdttnr='Отгруженные'
              case  ttnprzr=4 // Вз
                    forttnr=forttn_r+'.and.!empty(dvzttn).and.prz=0'
                    hdttnr='Подтвержденная доставка'
              case  ttnprzr=5 // Под
                    forttnr=forttn_r+'.and.prz=1'
                    hdttnr='Подтвержденные'
              case  ttnprzr=6 // Сетевые не полученные
                    sele rs1
                    if fieldpos('kolosp')#0
                       forttnr=forttn_r+'.and.!empty(dsp).and.empty(dop).and.kolosp#kolpsp.and.kolosp#0'
                    else
                       forttnr=forttn_r+'.and.!empty(dsp).and.empty(dop)'
                    endif
                    hdttnr='Сетевые не полученные'
           endc
           if ttnmntovr#0
                 forttnr=forttnr+".and.netseek('t2','rs1->ttn,ttnmntovr','rs2')"
           else
              if ttngrpr#999
                 kkkkr=ttngrpr*10000
                 forttnr=forttnr+".and.netseek('t2','rs1->ttn,kkkkr','rs2','3')"
                 hdttnr=hdttnr+' Группа '+str(ttngrpr,3)+' '+getfield('t1','ttngrpr','sgrp','ngr')
              endif
           endif
           if kop_r#0
              forttnr=forttnr+'.and.kop=kop_r'
           endif
           if tdtr#0.and.!empty(dt1r).and.dt2r>=dt1r
              do case
                 case tdtr=1
                      forttnr=forttnr+'.and.ddc>=dt1r.and.ddc<=dt2r'
                 case tdtr=2
                      forttnr=forttnr+'.and.dvp>=dt1r.and.dvp<=dt2r'
                 case tdtr=3
                      forttnr=forttnr+'.and.dfp>=dt1r.and.dfp<=dt2r'
                 case tdtr=4
                      forttnr=forttnr+'.and.dsp>=dt1r.and.dsp<=dt2r'
                 case tdtr=5
                      forttnr=forttnr+'.and.dop>=dt1r.and.dop<=dt2r'
                 case tdtr=6
                      forttnr=forttnr+'.and.dvzttn>=dt1r.and.dvzttn<=dt2r'
                 case tdtr=7
                      forttnr=forttnr+'.and.dot>=dt1r.and.dot<=dt2r'
              endc
           endif
           if onvr=1
              forttnr=forttnr+'.and.dop#dvzttn'
           endif
           sele rs1
           go top
           wclose(wttnr)
           setcolor(clttnr)
      case lastkey()=K_F5
           prntd()
      case lastkey()=K_F6
           rs2prot()
      case lastkey()=K_ENTER
           if ttnmntovr#0
              rs2forr='rs2->mntov=ttnmntovr'
           else
              if ttngrpr=999
                 rs2forr='.t.'
              else
                 rs2forr='int(rs2->mntov/10000)=ttngrpr'
              endif
           endif
           sele rs2
           if netseek('t1','ttnr')
              do while .t.
                 foot('ESC','Выход')
                 rcrs2r=slcf('rs2',,,,,"e:ktl h:'KTL' c:n(9) e:getfield('t1','rs2->mntov','ctov','nat') h:'наименование' c:c(35) e:kvp h:'Количество' c:n(10,3) e:zen h:'Цена' c:n(10,3) e:svp h:'Сумма' c:n(10,2)",,,,'ttn=ttnr',rs2forr,,'ТТН '+str(ttnr,6)+' '+ngpr)
                 do case
                    case lastkey()=K_ESC
                         exit
                 endc
              endd
           endif
   endc
endd
nuse()



proc prntd
aprntdr=1
aprntd={'LPT1','LPT2','LPT3','Файл'}
aprntdr=alert('Печать',aprntd)
do case
   case lastkey()=K_ESC
        retu
   case aprntdr=1
        set print to lpt1
   case aprntdr=2
        set print to lpt2
   case aprntdr=3
        set print to lpt3
   case aprntdr=4
        set print to rsvetd.txt
endc
set cons off
set prin on
if aprntdr=1.or.aprntdr=4
   if empty(gcPrn).or.aprntdr=4
      ?chr(27)+chr(80)+chr(15)
   else
      ? chr(27)+'E'+chr(27)+'&l1h26a0O'+chr(27)+chr(27)+'(3R'+chr(27)+'(s0p20.00h0s1b4102T'+chr(27)  // Книжная А4
   endif
else
      ? chr(27)+'E'+chr(27)+'&l1h26a0O'+chr(27)+chr(27)+'(3R'+chr(27)+'(s0p20.00h0s1b4102T'+chr(27)  // Книжная А4
endif
lstr=1
rwtekr=1
rwendr=62
set cent off
tdsh()
sele rs1
go top
do while !eof()
   if !(&forttnr)
      skip
      loop
   endif
   ?' '+str(ttn,6)+' '+str(kop,3)+' '+str(sdv,10,2)+' '+dtoc(ddc)+' '+dtoc(dvp)+' '+dtoc(dsp)+' '+dtoc(dop)+' '+dtoc(dvzttn)+' '+iif(rs1->prz=1,dtoc(dot),space(8))
   rwtd()
   skip
endd
eject
set prin off
set cons on
set print to
set cent on
sele rs1
go rcttnr
retu

proc tdsh()
if lstr=1
   ?'Ведомость состояния документов на '+dtoc(date())+' '+time()
   ?'по '+alltrim(gcNskl)
   ?hdttnr
   rwtekr=8
else
   rwtekr=5
endif
?'                                                            Лист '+str(lstr,2)
?'┌──────┬───┬──────────┬────────┬────────┬────────┬────────┬────────┬──────────┐'
?'│ ТТН  │КОП│  СУММА   │ ДатаС  │ ДатаВ  │ ДатаФ  │ ДатаО  │ ДатаВз │  ДатаП   │'
?'├──────┼───┼──────────┼────────┼────────┼────────┼────────┼────────┼──────────┤'

func rwtd()
rwtekr++
if rwtekr=rwendr
   eject
   lstr++
   rwtekr=1
   tdsh()
endif
