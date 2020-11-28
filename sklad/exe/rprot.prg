#include "common.ch"
#include "inkey.ch"
 * Пртокол расхода (просмотр)
store 0 to nppr,ttnr,ktlr,prnppr,kopr,prdopr
pttnd=date()
if !file(gcPath_t+'rso1.dbf')
   retu
endif
clea
netuse('rso1')
netuse('rso2')
netuse('speng')
netuse('tov')
netuse('ctov')
netuse('rs1')
netuse('rs2')


forr='.t.'
for_r='.t.'
sele rso1
go top
rcrso1r=recn()
fldnomr=1
do while .t.
   sele rso1
   go rcrso1r
   foot('ENTER,F3,F4,F5','Просмотр,Фильтр,Печать,Восстанов')
   if fieldpos('docip')#0
      rcrso1r=slce('rso1',1,,18,,"e:npp h:'Номер ' c:n(6) e:ttn h:' ТТН  ' c:n(6) e:kop h:'КОП' c:n(3) e:dop h:'  ДатаO ' c:d(10) e:dnpp h:'  Дата  ' c:d(10) e:tnpp h:' Время  ' c:c(8) e:prnpp h:'В' c:n(2) e:nrs() h:'Операция' c:c(25) e:getfield('t1','rso1->ktonpp','speng','fio') h:'Исполнитель' c:c(12) e:docip h:'IP' c:c(15) e:sdv h:'Сумма пр' c:n(12,2) e:getfield('t1','rso1->ttn','rs1','sdv') h:'Сумма т' c:n(12,2)",,,1,,forr)
   else
      rcrso1r=slce('rso1',1,,18,,"e:npp h:'Номер ' c:n(6) e:ttn h:' ТТН  ' c:n(6) e:kop h:'КОП' c:n(3) e:dop h:'  ДатаO ' c:d(10) e:dnpp h:'  Дата  ' c:d(10) e:tnpp h:' Время  ' c:c(8) e:prnpp h:'В' c:n(2) e:nrs() h:'Операция' c:c(25) e:getfield('t1','rso1->ktonpp','speng','fio') h:'Исполнитель' c:c(12) e:sdv h:'Сумма пр' c:n(12,2) e:getfield('t1','rso1->ttn','rs1','sdv') h:'Сумма т' c:n(12,2)",,,1,,forr)
   endif
   go rcrso1r
   nppr=npp
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
           flt()
      case lastkey()=K_ENTER
           prosm()
      case lastkey()=K_F4
           if gnOut=1
              set prin to lpt1
           else
              set prin to prot.txt
          endif
          set prin on
          set cons off
          sele rso1
          go top
          ?'Номер '+' '+' ТТН  '+' '+'   Дата   '+' '+' Время  '+' '+'В '+' '+space(8)+'Операция'+space(9)+' '+'Исполнитель'
          do while !eof()
             if !&forr
                skip
                loop
             endif
             ?str(npp,6)+' '+str(ttn,6)+' '+dtoc(dnpp)+' '+tnpp+' '+str(prnpp,2)+' '+nrs()+' '+getfield('t1','rso1->ktonpp','speng','fio')
             sele rso1
             skip
          endd
          set prin off
          if gnOut=2
             set prin to txt.txt
          endif
          set cons on
     case lastkey()=K_F5.and.gnAdm=1
          sele rso1
          netseek('t1','nppr')
          if prnpp=1.or.prnpp=2
*             vosrsh()
          else
*            wmess('Оперция возможна только для удаленного документа',1)
          endif
  endc
  sele rso1
  netseek('t1','nppr')
endd
nuse()

func vosrsh()
ttnr=ttn
sele rs1
if netseek('t1','ttnr',,,1)
   perz=alert('Документ существует, продолжить востановление?',{'ДА','НЕТ'})
   if perz=2
      return
   endif
endif

sele rso1
nppr=npp
prnppr=prnpp
arec:={}
getrec()
netrepl('prnpp','12')
sele rs1
netadd()
putrec()

sele rso2
netseek('t1','nppr')
do while npp=nppr
   ktlr=ktl
   kvpr=kvp
   arec:={}
   getrec()

   sele rs2
   netadd()
   putrec()

   sele tov
   netseek('t1','sklr,ktlr')
   reclock()
   repl osv with osv-kvpr
   netunlock()

   sele rso2
   netdel()
   skip
 enddo

sele rso1
return

func nrs()
do case
   case rso1->prnpp= 1
        retu 'Удаление выписанного     '
   case rso1->prnpp= 2
        retu 'Удаление отгруженного    '
   case rso1->prnpp= 3
        retu 'Снятие подтверждения     '
   case rso1->prnpp= 4
        retu 'Коррекция позиции        '
   case rso1->prnpp= 5
        retu 'Удаление позиции         '
   case rso1->prnpp= 6
        retu 'Печать в товарном отделе '
   case rso1->prnpp= 7
        retu 'Отгрузка со склада       '
   case rso1->prnpp= 8
        retu 'Подтверждение            '
   case rso1->prnpp= 9
        retu 'Новый документ           '
   case rso1->prnpp=10
        retu 'Коррекция шапки          '
   case rso1->prnpp=11
        retu 'Сетевая печать счета-фак.'
   case rso1->prnpp=12
        retu 'Востановление            '
   case rso1->prnpp=14
        retu 'Коррекция позиции на "0" '
   case rso1->prnpp=15
        retu 'Снятие отгрузки          '
   case rso1->prnpp=16
        retu 'Установка отгрузки       '
   case rso1->prnpp=18
        retu 'Цена вручную             '
   case rso1->prnpp=19
        retu 'Доб в док с ddc#date()   '
   case rso1->prnpp=20
        retu 'Изменение даты отгрузки  '
   case rso1->prnpp=21
        retu 'Пересчет цен вручную     '
   case rso1->prnpp=22
        retu 'Снятие ФП                '
   case rso1->prnpp=23
        retu 'Установка ФП             '
   case rso1->prnpp=24
        retu 'Изменение ФП             '
   case rso1->prnpp=25
        retu 'Удаление ksz=46          '
   othe
        retu space(25)
endc

stat func flt()
oclr=setcolor('w+/b,n/w')
wflt=wopen(4,5,19,75)
wbox(1)
store 0 to ttnr,kopr,prnppr,ktlr
store space(20) to natr
store ctod('') to pttnd
do while .t.
   @ 0,1 say 'ТТН         ' get ttnr pict '999999'
   @ 1,1 say 'KOP         ' get kopr pict '999'
   @ 2,1 say 'Вид операции' get prnppr pict '99'
   @ 3,1 say 'Отгруженные ' get prdopr pict '9'
   @ 13,1 say 'Код         ' get ktlr pict '999999999'

   @ 4 ,1 say '1 - Удаление выписанного     '
   @ 5 ,1 say '2 - Удаление отгруженного    '
   @ 6 ,1 say '3 - Снятие подтверждения     '
   @ 7 ,1 say '4 - Коррекция позиции        '
   @ 8 ,1 say '5 - Удаление позиции         '
   @ 9 ,1 say '6 - Печать в товарном отделе '
   @ 10 ,1 say '7- Отгрузка со склада        '
   @ 11,1 say '8 - Подтверждение            '
   @ 12,1 say '9 - Новый документ           '

   @ 0 ,40 say '10- Коррекция шапки          '
   @ 1 ,40 say '11- Сетевая печать счета-фак.'
   @ 2 ,40 say '12- Востановление            '
   @ 3 ,40 say '14- Коррекция позиции на "0" '
   @ 4 ,40 say '15- Снятие отгрузки          '
   @ 5 ,40 say '16- Установка отгрузки       '
   @ 6 ,40 say '18- Цена вручную             '
   @ 7 ,40 say '19- Доб в док с ddc#date()   '
   @ 8 ,40 say '20- Изм даты отгрузки        '
   @ 9 ,40 say '21- Перерасчет по F2         '
   @ 10,40 say '22- Снятие ФП                '
   @ 11,40 say '23- Установка ФП             '
   @ 12,40 say '24- Изменение ФП             '
   @ 13,40 say '25- Удаление ksz=46          '
   read
   do case
      case lastkey()=K_ESC
           forr=for_r
           exit
      case lastkey()=K_ENTER
           if ttnr#0
              forr=for_r+'.and.ttn=ttnr'
           else
              forr=for_r
           endif
           if kopr#0
              forr=forr+'.and.kop=kopr'
           endif
           if prnppr#0
              forr=forr+'.and.prnpp=prnppr'
           endif
           if prdopr#0
              forr=forr+'.and.!empty(dop)'
           endif
           if ktlr#0
              forr=forr+".and.netseek('t1','rso1->npp,rso1->ttn,ktlr','rso2')"
           endif
           sele rso1
           go top
           rcrso1r=recn()
           exit
   endc
endd
wclose(wflt)
setcolor(oclr)
retu .t.

func prosm()
sele rso2
if netseek('t1','nppr')
   ktlr=slcf('rso2',,,,,"e:ktl h:'Код' c:n(9) e:getfield('t1','rso2->mntov','ctov','nat') h:'Товар' c:c(25) e:kvp h:'К-во' c:n(10,3) e:svp h:'Сумма' c:n(10,2) e:zen h:'Цена' c:n(10,3) e:sr h:'Сумма(Р)' c:n(10,2)",'ktl',,,'npp=nppr')
endif
retu .t.
