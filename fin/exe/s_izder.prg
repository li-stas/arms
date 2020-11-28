#include "common.ch"
#include "inkey.ch"
clea
netuse('izder')
do while .t.
   foot('INS,DEL,F4,ESC','Добавить,Удалить,Коррекция,Выход')
   statr=slcf('izder',1,,18,,"e:stat h:'Стат' c:n(6) e:grp h:'Гр' c:n(2)",'stat',,1)
   do case
      case lastkey()=22.and. (dkklnr=1.or.gnadm=1)
           izderins(0)
      case lastkey()=7.and. (dkklnr=1.or.gnadm=1)
           LOCATE FOR sk=skr
           if FOUND()
              netdel()
           endif
      case lastkey()=-3.and. (dkklnr=1.or.gnadm=1)
           izderins(1)
      case lastkey()=K_ESC
           exit
   endc
enddo
nuse()

func izderins(p1)
retu
