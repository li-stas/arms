#include "common.ch"
#include "inkey.ch"
 * Пртокол прихода (просмотр)
store 0 to Nppr,ndr,mnr,ktlr
if !file(gcPath_t+'pro1.dbf')
   retu
endif
clea
netuse('pro1')
netuse('pro2')
netuse('speng')
netuse('tov')
forr=nil
sele pro1
do while .t.
   foot('F3,ENTER','Фильтр,Просмотр')
   Nppr=slcf('pro1',1,,18,,"e:Npp h:'Номер ' c:n(6) e:nd h:'N прих' c:n(6) e:dNpp h:'  Дата  ' c:d(10) e:tNpp h:' Время  ' c:c(8) e:prNpp h:'В' c:n(2) e:npr() h:'Операция' c:c(25) e:getfield('t1','pro1->ktoNpp','speng','fio') h:'Исполнитель' c:c(12)",'Npp',,1,,forr)

   do case
      case lastkey()=K_ESC
           exit
      case lastkey()=K_F3
           flt()
      case lastkey()=K_ENTER
           prosm()
   endc
   sele pro1
   netseek('t1','Nppr')
endd

nuse()

func npr()
do case
   case pro1->prNpp= 1
        retu 'Удаление выписанного     '
   case pro1->prNpp= 2
        retu space(25)
   case pro1->prNpp= 3
        retu 'Снятие подтверждения     '
   case pro1->prNpp= 4
        retu 'Коррекция позиции        '
   case pro1->prNpp= 5
        retu 'Удаление позиции         '
   case pro1->prNpp= 6
        retu 'Печать в товарном отделе '
   case pro1->prNpp= 7
        retu space(25)
   case pro1->prNpp= 8
        retu 'Подтверждение            '
   case pro1->prNpp= 9
        retu 'Новый документ           '
   case pro1->prNpp=10
        retu 'Коррекция шапки          '
   case pro1->prNpp=11
        retu 'Ошибка отв.хран.         '
   othe
        retu space(25)
endc

stat func flt()
oclr=setcolor('w+/b,n/w')
wflt=wopen(5,20,15,60)
wbox(1)
store 0 to ndr,ktlr,mnr
store space(20) to natr
do while .t.
   @ 0,1 say 'Номер прихода        ' get ndr pict '999999'
   @ 1,1 say 'Код товара           ' get ktlr pict '9999999'
   if ktlr=0
      @ 2,1 say 'Контекст наименования' get natr
   endif
   read
   do case
      case lastkey()=K_ESC
           forr=nil
           sele pro1
           go top
           exit
      case lastkey()=K_ENTER
           forr=iif(ndr#0,'nd=ndr.and.','')+iif(ktlr#0,'ktl=ktlr.and.','')+iif(!empty(natr),'at(natr,nat)#0','')
           if right(forr,5)='.and.'
              forr=subs(forr,1,len(forr)-5)
           endif
           exit
   endc
endd
wclose(wflt)
setcolor(oclr)
retu .t.

stat func prosm()
sele pro2
if netseek('t1','Nppr')
   ktlr=slcf('pro2',,,,,"e:ktl h:'Код' c:n(9) e:kf h:'К-во' c:n(10,3) e:sf h:'Сумма' c:n(10,2) e:zen h:'Цена' c:n(10,3) e:sr h:'Сумма(Р)' c:n(10,2)",'ktl',,,'Npp=Nppr')
endif
retu .t.
