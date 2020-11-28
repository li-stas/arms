#include "common.ch"
#include "inkey.ch"
clea
netuse('podr')
go top
rcpodrr=recn()
do while .t.
   sele podr
   go rcpodrr
   foot('INS,DEL,F4,ESC','Добавить,Удалить,Коррекция,Выход')
   rcpodrr=slcf('podr',1,,18,,"e:pod h:'Подр.' c:n(4) e:npod h:'Наименование' c:c(20)")
   sele podr
   go rcpodrr
   npodr=npod
   podr=pod
   do case
      case lastkey()=22 .and. (dkklnr=1.or.gnadm=1)
           podrins(0)
      case lastkey()=7 .and. (dkklnr=1.or.gnadm=1)
           netdel()
      case lastkey()=-3 .and. (dkklnr=1.or.gnadm=1)
           podrins(1)
      case lastkey()=K_ESC
           exit
   endc
enddo
nuse()

func podrins(p1)
if p1=0
   store 0 to sklr,podr
   npodr=space(20)
endif
clpodrins=setcolor('gr+/b,n/w')
wpodrins=wopen(10,15,15,60)
wbox(1)
do while .t.
   if p1=0
*      @ 0,1 say 'Код склада  ' get sklr pict '9999'
      @ 0,1 say 'Код подразд.' get podr pict '9999'
   else
*      @ 0,1 say 'Код cклада  '+str(sklr,4)
      @ 0,1 say 'Код подразд.'+str(podr,4)
   endif
   @ 1,1 say    'Наименование' get npodr
   @ 3,1 prom '<Верно>'
   @ 3,col()+1 prom '<Не верно>'
   read
   if lastkey()=K_ESC
      exit
   endif
   menu to mpodrr
   if mpodrr=1
      if p1=0
         if !netseek('t1','podr')
            netadd()
            netrepl('pod,npod','podr,npodr')
            rcpodrr=recn()
            exit
         else
            wselect(0)
            save scre to scpodrins
            mess('Такой код существует',1)
            rest scre from scpodrins
            wselect(wpodrins)
         endif
      else
         netrepl('npod','npodr')
         exit
      endif
   endif
enddo
wclose()
setcolor(clpodrins)
retu
