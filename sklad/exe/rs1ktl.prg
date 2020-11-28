#include "common.ch"
#include "inkey.ch"
  //Просмотр расхода по коду
save scre to scpr1ktl
ss=select()
store 0 to prrs1r,prrs2r,prklnr
if select('rs1')=0
   netuse('rs1')
   prrs1r=1
endif
if select('rs2')=0
   netuse('rs2')
   prrs2r=1
endif
if select('kln')=0
   netuse('kln')
   prklnr=1
endif
@ 0,1 say str(ktlr,9)+' '+natr
sele rs1
rpr1r=recn()
opr1r=indexord()
set orde to tag t2
sele rs2
rpr2r=recn()
opr2r=indexord()
set cent off
if tov_r=='tovm'.or.tov_r=='ctov'
   nazvr=str(mntovr,7)+' '+alltrim(natr)
   set orde to tag t4
   go top
   netseek('t4','mntovr')
   rcrs2r=recn()
   if gnMskl=1
      rfor_r="getfield('t1','rs2->ttn','rs1','skl')=sklr"
   else
      rfor_r='.t.'
   endif
   rforr=rfor_r
   foot('F3','Фильтр')
   do while .t.
      sele rs2
      go rcrs2r
      if gnMskl=1
         rcrs2r=slcf('rs2',,,,,"e:ttn h:'N ТТН ' c:n(6) e:getfield('t1','rs2->ttn','rs1','kop') h:'КОП' c:n(3) e:getfield('t1','rs2->ttn','rs1','dop') h:'Дата O'  c:d(8) e:getfield('t1','rs2->ttn','rs1','dot') h:'Дата П'  c:d(8) e:getfield('t1','rs2->ttn','rs1','prz') h:'П' c:n(1) e:kvp h:'Количество' c:n(8,3) e:zen h:'Цена' c:n(7,3) e:svp h:'Сумма' c:n(9,2) e:getfield('t1','rs2->ttn','rs1','kpl') h:' Код ' c:n(7) e:getfield('t1','rs2->ttn','rs1','amn') h:'AMN' c:n(6) e:otv h:'O' c:n(1) e:getfield('t1','rs2->ttn','rs1','rmsk') h:'R' c:n(1)",,,1,'mntov=mntovr',rforr,,nazvr)
      else
         rcrs2r=slcf('rs2',,,,,"e:ttn h:'N ТТН ' c:n(6) e:getfield('t1','rs2->ttn','rs1','kop') h:'КОП' c:n(3) e:getfield('t1','rs2->ttn','rs1','dop') h:'Дата O'  c:d(8) e:getfield('t1','rs2->ttn','rs1','dot') h:'Дата П'  c:d(8) e:getfield('t1','rs2->ttn','rs1','prz') h:'П' c:n(1) e:kvp h:'Количество' c:n(8,3) e:zen h:'Цена' c:n(7,3) e:svp h:'Сумма' c:n(9,2) e:getfield('t1','rs2->ttn','rs1','kpl') h:' Код ' c:n(7) e:getfield('t1','rs2->ttn','rs1','amn') h:'AMN' c:n(6) e:otv h:'O' c:n(1) e:getfield('t1','rs2->ttn','rs1','rmsk') h:'R' c:n(1)",,,1,'mntov=mntovr',rforr,,nazvr)
      endif
      if lastkey()=K_ESC
         exit
      endif
      do case
         case lastkey()=K_F3
              kpl_r=0
              wa=wopen(10,20,12,50)
              wbox(1)
              @ 0,1 say 'Плательщик' get kpl_r pict '9999999'
              read
              wclose(wa)
              if kpl_r#0
                 rforr=rfor_r+".and.getfield('t1','rs2->ttn','rs1','kpl')=kpl_r"
              else
                 rforr=rfor_r
              endif
              sele rs2
              set orde to tag t4
              go top
              netseek('t4','mntovr')
              rcrs2r=recn()
      endc
   endd
else
   nazvr=str(ktlr,9)+' '+alltrim(natr)
   set orde to tag t6
   go top
   netseek('t6','ktlr')
   if gnMskl=1
      ttn_r=slcf('rs2',,,,,"e:ttn h:'N ТТН ' c:n(6) e:getfield('t1','rs2->ttn','rs1','kop') h:'КОП' c:n(3) e:getfield('t1','rs2->ttn','rs1','dop') h:'Дата O'  c:d(8) e:getfield('t1','rs2->ttn','rs1','dot') h:'Дата П'  c:d(8) e:getfield('t1','rs2->ttn','rs1','prz') h:'П' c:n(1) e:getfield('t1','rs2->ttn','rs1','otv') h:'O' c:n(1) e:kvp h:'Количество' c:n(8,3) e:zen h:'Цена' c:n(7,3) e:svp h:'Сумма' c:n(9,2) e:getfield('t1','rs2->ttn','rs1','kpl') h:' Код ' c:n(7) e:getfield('t1','rs2->ttn','rs1','amn') h:'AMN' c:n(6) e:otv h:'O' c:n(1) e:getfield('t1','rs2->ttn','rs1','rmsk') h:'R' c:n(1)",'ttn',,,'ktl=ktlr',"getfield('t1','rs2->ttn','rs1','skl')=sklr",,nazvr)
   else
      ttn_r=slcf('rs2',,,,,"e:ttn h:'N ТТН ' c:n(6) e:getfield('t1','rs2->ttn','rs1','kop') h:'КОП' c:n(3) e:getfield('t1','rs2->ttn','rs1','dop') h:'Дата O'  c:d(8) e:getfield('t1','rs2->ttn','rs1','dot') h:'Дата П'  c:d(8) e:getfield('t1','rs2->ttn','rs1','prz') h:'П' c:n(1) e:getfield('t1','rs2->ttn','rs1','otv') h:'O' c:n(1) e:kvp h:'Количество' c:n(8,3) e:zen h:'Цена' c:n(7,3) e:svp h:'Сумма' c:n(9,2) e:getfield('t1','rs2->ttn','rs1','kpl') h:' Код ' c:n(7) e:getfield('t1','rs2->ttn','rs1','amn') h:'AMN' c:n(6) e:otv h:'O' c:n(1) e:getfield('t1','rs2->ttn','rs1','rmsk') h:'R' c:n(1)",'ttn',,,'ktl=ktlr',,,nazvr)
   endif
endif
set cent on
sele rs1
go rpr1r
set orde to (opr1r)
sele rs2
go rpr2r
set orde to (opr2r)
if prrs1r=1
   nuse('rs1')
endif
if prrs2r=1
   nuse('rs2')
endif
if prklnr=1
   nuse('kln')
endif
sele (ss)
rest scre from scpr1ktl

***************
func rs1ktla()
***************
pathmr=gcPath_e+'g'+str(year(dpor),4)+'\m'+iif(month(dpor)<10,'0'+str(month(dpor),1),str(month(dpor),2))+'\'
pathr=pathmr+gcDir_t
if netfile('rs1',1)
   netuse('rs1',,,1)
   netuse('rs2',,,1)
   if netseek('t4','mntovr')
      ttnr=ttn
      sele rs1
      if netseek('t1','ttnr')
         sktr=skt
         mnr=amn
         nsksr=getfield('t1','sktr','cskl','nskl')
         wa=wopen(10,5,14,75)
         wbox(1)
         @ 0,1 say 'Дата расхода'+' '+dtoc(dpor)
         @ 1,1 say 'На склад    '+' '+str(sktr,4)+' '+nsksr
         @ 2,1 say 'Приход      '+' '+str(mnr,6)
         inkey(0)
         wclose(wa)
      endif
   else
      wmess('Не найден',3)
   endif
   nuse('rs1')
   nuse('rs2')
endif
retu .t.
