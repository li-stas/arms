#include "common.ch"
#include "inkey.ch"
clea
netuse('tipd')
do while .t.
   foot('INS,DEL,F4,ESC','Добавить,Удалить,Коррекция,Выход')
   rctipd=slcf('tipd',1,,18,,"e:tipo h:'ТО' c:n(2) e:tip h:'Тип' c:n(3) e:ndok h:'Наименование' c:c(30) e:prz h:'П' c:n(1)")
   sele tipd
   go rctipd
   tipor=tipo
   tipr=tip
   ndokr=ndok
   przr=prz
   do case
      case lastkey()=22 .and. (dkklnr=1.or.gnadm=1)
           tipdins(0)
      case lastkey()=7 .and. (dkklnr=1.or.gnadm=1)
           if netseek('t1','tipor,tipr')
              netdel()
           endif
      case lastkey()=-3 .and. (dkklnr=1.or.gnadm=1)
           tipdins(1)
      case lastkey()=K_ESC
           exit
   endc
enddo
nuse()

func tipdins(p1)
if p1=0
   store 0 to tipor,tipr
   store space(30) to ndokr
endif
cltipdins=setcolor('gr+/b,n/w')
wtipdins=wopen(10,20,16,70)
wbox(1)
do while .t.
   if p1=0
      @ 0,1 say 'Группа докум.' get tipor pict '99'
      @ 1,1 say 'Тип документа' get tipr pict '999'
   else
      @ 0,1 say 'Группа докум. '+str(tipor,2)
      @ 1,1 say 'Тип документа '+str(tipr,3)
   endif
   @ 2,1 say 'Наименование ' get ndokr
   @ 3,1 say 'Признак Дб/Кр' get przr
   @ 4,1 prom '<Верно>'
   @ 4,col()+1 prom '<Не верно>'
   read
   if lastkey()=K_ESC
      exit
   endif
   menu to mtipdins
   if mtipdins =1
      if p1=0
         if !netseek('t1','tipor,tipr')
            netadd()
            netrepl('tipo,tip,ndok,prz','tipor,tipr,ndokr,przr')
            exit
         else
            wselect(0)
            save scre to sctipdins
            mess('Такой тип документа уже существует',1)
            rest scre from sctipdins
            wselect(wtipdins)
         endif
      else
         if netseek('t1','tipor,tipr')
            netrepl('ndok,prz','ndokr,przr')
            exit
         endif
      endif
   endif
endd
wclose(wtipdins)
setcolor(cltipdins)
retu
