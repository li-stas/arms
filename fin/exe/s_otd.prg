#include "common.ch"
#include "inkey.ch"
clea
netuse('cskl')
netuse('cskle')
sele cskl
go top
do while .t.
   skr=slcf('cskl',1,1,18,,"e:sk h:'SK' c:n(3) e:nskl h:'Наименование' c:c(20)",'sk',,1,,"ent=gnEnt.and.file(gcPath_d+alltrim(path)+'tprds01.dbf')")
   netseek('t1','skr')
   skr=sk
   recskr=recno()
   if lastkey()=K_ESC
      exit
   endif
   sele cskle
   if !netseek('t1','skr')
      otr=0
      notr='Все отделы'
      netadd()
      netrepl('sk,ot,nai','skr,otr,notr')
   endif
   do while sk=skr
         foot('INS,DEL,F4,ESC','Добавить,Удалить,Коррекция,Выход')
         otr=slcf('cskle',1,40,18,,"e:sk h:'SK' c:n(3) e:ot h:'OT' c:n(2) e:Nai h:'Наименование' c:c(20)",'ot',,,,'sk=skr')
         netseek('t1','skr,otr')
         do case
            case lastkey()=22 .and. (dkklnr=1.or.gnadm=1)
                 otdins(0)
            case lastkey()=7 .and. (dkklnr=1.or.gnadm=1)
                 if netseek('t1','skr,otr')
                    netdel()
                 endif
                 loop
            case lastkey()=-3 .and. (dkklnr=1.or.gnadm=1)
                 otdins(1)
            case lastkey()=K_ESC
                 sele cskl
                 go recskr
                 exit
        endc
   enddo

enddo
nuse('cskl')
nuse('cskle')

return
func otdins(p1)
if p1=0
   store 0 to otr
   nair=space(20)
else
   otr=ot
   nair=nai
endif
clotdins=setcolor('gr+/b,n/w')
wotdins=wopen(10,15,15,60)
wbox(1)
do while .t.
   if p1=0
      @ 0,1 say 'Код отдела' get otr pict '99'
   else
      @ 0,1 say 'Код отдела'+str(otr,2)
   endif
   @ 1,1 say    'Наименование' get nair
   @ 2,1 prom '<Верно>'
   @ 2,col()+1 prom '<Не верно>'
   read
   if lastkey()=K_ESC
      exit
   endif
   menu to mpodrr
   if mpodrr=1
      if p1=0
         if !netseek('t1','skr,otr')
            netadd()
            netrepl('sk,ot,nai','skr,otr,nair')
            exit
         else
            wselect(0)
            save scre to sotdins
            mess('Такой код существует',1)
            rest scre from sotdins
            wselect(wotdins)
         endif
      else
         if netseek('t1','skr,otr')
            netrepl('ot,nai','otr,nair')
            exit
         endif
      endif
   endif
enddo
wclose()
setcolor(clotdins)
retu
