#include "inkey.ch"
clea
netuse('kln')
netuse('tara')
pd=0
do while .t.
   sele tara
   foot('INS,DEL,F4,F3,ESC','Добавить,Удалить,Коррекция,Поиск,Выход')
*   kklr=slcf('tara',1,,18,,"e:kkl h:'Код' c:n(7) e:getfield('t1','tara->kkl','kln','nkl') h:'Наименование' c:c(27) e:tkday h:'Дни' c:n(3) e:ddog h:'Дата дог' c:d(8)'",'kkl',,1,,'pd=0')
   set cent off
   kklr=slcf('tara',1,,18,,"e:kkl h:'Код' c:n(7) e:getfield('t1','tara->kkl','kln','nkl') h:'Наименование' c:c(27) e:tkday h:'Дни' c:n(3) e:ddog h:'Дата дог' c:d(8)' e:pd h:'ПД' c:n(1)",'kkl',,1)
   set cent on
   sele tara
   netseek('t1','kklr')
   tkdayr=tkday
   ddogr=ddog
   pdr=pd
   sele kln
   if netseek('t1','kklr')
      nklr=nkl
   else
      nklr=space(30)
   endif
   sele tara
   do case
      case lastkey()=22 .and. (dkklnr=1.or.gnadm=1)
           tarains(0)
      case lastkey()=7 .and. (dkklnr=1.or.gnadm=1)
           netrepl('pd','1')
           loop
      case lastkey()=-3 .and. (dkklnr=1.or.gnadm=1)
           tarains(1)
      case lastkey()=K_F3
           tarafilt()
      case lastkey()=K_ESC
           exit
   endc
enddo
nuse()

func tarains(p1)
if p1=0
   store 0 to kklr,tkdayr
   nklr=space(30)
   ddogr=date()

endif
cltara=setcolor('gr+/b,n/w')
wtara=wopen(10,15,16,60)
wbox(1)
do while .t.
   if p1=0
      @ 0,1 say 'Клиент       ' get kklr pict '9999999'
   else
      @ 0,1 say 'Клиент        '+str(kklr,7)
   endif
   @ 1,1 say 'Наименование '+nklr
   @ 2,1 say 'Возврат     ' get tkdayr pict '999'
   @ 2,col()+1 say 'дн'
   @ 3,1 say 'Дата договора ' get ddogr
   @ 4,1 say 'Приост. догов ' get pdr  pict '9'
   read
   if lastkey()=K_ESC
      exit
   endif
   @ 4,20 prom '<Верно>'
   @ 4,col()+1 prom '<Не верно>'
   menu to mtarar
   if lastkey()=K_ESC
      exit
   endif
   if mtarar=1
      if p1=0
         if !netseek('t1','kklr')
            netadd()
            netrepl('kkl,tkday,ddog,ddc,kto,pd','kklr,tkdayr,ddogr,date(),gnKto,pdr')
            exit
         else
            wselect(0)
            save scre to sctarains
            mess('Такой клиент существует',1)
            rest scre from sctarains
            wselect(wtara)
         endif
      else
         if netseek('t1','kklr')
            netrepl('tkday,ddog,ddc,kto,pd','tkdayr,ddogr,date(),gnKto,pdr')
            exit
         endif
      endif
   endif
enddo
wclose(wtara)
setcolor(cltara)
retu

func tarafilt()
store 0 to kklr
nklr=space(30)
cltaraf=setcolor('gr+/b,n/w')
wtaraf=wopen(10,15,16,60)
wbox(1)
@ 0,1 say 'Клиент       ' get kklr pict '9999999'
read
if lastkey()=K_ESC
   return
endif
if netseek('t1','kklr')
   rectara=recno()
   go rectara
endif

wclose(wtaraf)
setcolor(cltaraf)
return
