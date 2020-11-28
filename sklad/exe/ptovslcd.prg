#include "common.ch"
#include "inkey.ch"
* Отбор товара из TOVD (приход)
* TOVD
local rcn_rr
rcn_rr=0
mntovpr=0
pptr=0
ktlpr=0
save scre to sctovslcd
oclr2=setcolor('w+/b')
if select('sl')=0
   sele 0
   use _slct alias sl excl
   zap
endif
sele tovd
set orde to tag t2
kg_rr=int(ktlr/1000000)
nat_rr=upper(natr)
if !netseek('t2','kg_rr,nat_rr')
   nat_rr=subs(nat_rr,1,1)
   if !netseek('t2','kg_rr,nat_rr')
      if !netseek('t2','kg_rr')
         go top
      endif
    endif
endif
skllr=sklr
do while .t.
   sklr=skllr
   foot('SPACE,INS,F4,F8,ESC','Отбор,Доб,Корр,Группа,Закон.')
   rcn_rr=recn()
   skpr='.t.'
   nazvr='Дополнительный справочник склада'
   if gnRoz=0
      ktlr=slcf('tovd',7,1,12,,"e:ktl h:'Код' c:n(9) e:' ' h:'Д' c:c(1) e:nat h:'Наименование' c:c(43) e:upak_s() h:'Упк' c:c(4) e:nei h:'Изм' c:c(3) e:&coptr h:'Зак.цена' c:n(9,3)",'ktl',1,1,,skpr,'g/n,n/g',nazvr)
   else
      ktlr=slcf('tovd',7,1,12,,"e:ktl h:'Код' c:n(9) e:' ' h:'Д' c:c(1) e:nat h:'Наименование' c:c(34) e:upak_s() h:'Упк' c:c(4) e:nei h:'Изм' c:c(3) e:&coptr h:'Зак.цена' c:n(9,3)  e:&cboptr h:'Отп.цена' c:n(9,3)",'ktl',1,1,,skpr,'g/n,n/g',nazvr)
   endif
   sele tovd
   netseek('t1','ktlr')
   kg_r=int(ktl/1000000)
   ktlpr=0
   grmr=getfield('t1','kg_r','sgrp','mark')
   sele tovd
   exxr=0
   cntr=0
   do case
      case lastkey()=K_SPACE // Отбор
           tovins(0, 'tov', ktlr, 1)
           if prinstr=1  // Запись добавлена в TOV
              pr2kvp(1)
              pere(1)
              exit
           endif
      case lastkey()=K_INS // Добавить
           tovins(0, 'tovd')
      case lastkey()=K_F4 // Коррекция
           if substr(str(ktlr,9),(len(alltrim(str(ktlr,9)))-3),6)='000000'
              wmess('Добавьте запись!',2)
              loop
           endif
           tovins(1, 'tovd')
      case lastkey()=K_F5 // Отдел
           sele cskle
           if netseek('t1','gnSk')
              gnOt=slcf('cskle',,,,,"e:ot h:'От' c:n(2) e:nai h:'Наименование' c:c(20)",'ot',0,,'sk=gnSk')
              if netseek('t1','gnSk,gnOt')
                 gcNot=nai
                 @ 1,60 say gcNot color 'gr+/n'
              endif
           endif
           sele tovd
           go top
           loop
      case lastkey()=K_F8 // Группа
           foot('','')
           sele sgrp
           set orde to tag t2
           go top
           rcn_gr=recn()
           do while .t.
              sele sgrp
              set orde to tag t2
              rcn_gr=recn()
              kg_r=slcf('sgrp',,,,,"e:kgr h:'Код' c:n(3) e:ngr h:'Наименование' c:c(20)",'kgr',,1)
              grmr=getfield('t1','kg_r','sgrp','mark')
              do case
                 case lastkey()=K_ENTER
                      sele tovd
                      if !netseek('t2','kg_r')
                         ktlr=kg_r*10000
                         netAdd()
                         netrepl('ktl,kg','ktlr,kg_r',1)
                      endif
                      exit
                 case lastkey()=K_ESC
                      exit
                 case lastkey()>32.and.lastkey()<255
                 //case lastkey()>=65.and.lastkey()<=90.or.lastkey()>=97.and.lastkey()<=122.or.lastkey()>=128.and.lastkey()<=175.or.lastkey()>=224.and.lastkey()<=239
                      sele sgrp
                      lstkr=upper(chr(lastkey()))
                      if !netseek('t2','lstkr')
                         go rcn_gr
                      endif
                      loop
                 othe
                      loop
              endc
           endd
           sele tovd
           loop
      case lastkey()=K_ESC //
           exit
      case lastkey()>32.and.lastkey()<255
      //case lastkey()>=65.and.lastkey()<=90.or.lastkey()>=97.and.lastkey()<=122.or.lastkey()>=128.and.lastkey()<=175.or.lastkey()>=224.and.lastkey()<=239
           sele tovd
           lstkr=upper(chr(lastkey()))
           if !netseek('t2','int(ktlr/1000000),lstkr')
              go rcn_rr
           endif
   othe
      loop
   endc
enddo
setcolor(oclr2)
rest scre from sctovslcd

