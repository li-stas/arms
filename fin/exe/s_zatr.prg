#include "common.ch"
#include "inkey.ch"
clea
netuse('zatr')
do while .t.
   foot('INS,DEL,F4,ESC','Добавить,Удалить,Коррекция,Выход')
   konr=slcf('zatr',1,,18,,"e:kon h:'Код' c:n(5) e:non h:'Наименование' c:c(20)",'kon',,1)
   sele zatr
   netseek('t1','konr')
*   netseek('t1',konr,,1)
   nonr=non
   do case
      case lastkey()=22.and. (dkklnr=1.or.gnadm=1)
           zatrins(0)
      case lastkey()=7 .and. (dkklnr=1.or.gnadm=1)
           LOCATE FOR kon=konr
           if FOUND()
              netdel()
           endif
      case lastkey()=-3 .and. (dkklnr=1.or.gnadm=1)
           zatrins(1)
      case lastkey()=K_ESC
           exit
   endc
enddo
nuse()

func zatrins(p1)
if p1=0
   store 0 to konr
   nonr=space(20)
endif
clzatrins=setcolor('gr+/b,n/w')
wzatrins=wopen(10,15,15,60)
wbox(1)
do while .t.
   if p1=0
      @ 0,1 say 'Код         ' get konr pict '99999'
   else
      @ 0,1 say 'Код          '+str(konr,5)
   endif
   @ 1,1 say    'Наименование' get nonr
   @ 3,1 prom '<Верно>'
   @ 3,col()+1 prom '<Не верно>'
   read
   if lastkey()=K_ESC
      exit
   endif
   menu to mzatrr
   if mzatrr=1
      if p1=0
*          seek konr
*          if !FOUND()
         if !netseek('t1',konr,,1)
            netadd()
            netrepl('kon,non','konr,nonr')
            exit
         else
            wselect(0)
            save scre to sczatrins
            mess('Такой код существует',1)
            rest scre from sczatrins
            wselect(wzatrins)
         endif
      else
*         seek konr
*         if FOUND()
         if netseek('t1',konr,,1)
            netrepl('non','nonr')
            exit
         endif
      endif
   endif
enddo
wclose(wzatrins)
setcolor(clzatrins)
retu
