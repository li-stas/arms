#include "common.ch"
#include "inkey.ch"
PRIVATE forNaT, whileNat, whileNat
forNaT:=".AND..T."
whileCond:=".T."
whileNat:=".AND..T."
rctovmr=0
save scre to sctovslc
oclr1=setcolor('w+/b')
sele tovm
set orde to tag t2
if mntovr#0
   if netseek('t1','sklr,mntovr')
      rctovmr=recn()
   else
      mntovr=0
   endif
endif
if mntovr=0
   go top
   mntovr=mntov
endif
rcn_r_start:=rctovmr:=recn()
whileCond:=NIL
prF1r=0
do while .t.
   sele tovm
   go rctovmr
   set orde to tag t2
   if prF1r=0
      foot('SPACE,F4,F5,F8,ESC','Отбор,Корр,Отдел,Группа,Закон.')
   else
      foota('F8','Маркодержатель')
   endif
   if gnOt=0
      skpr="skl=sklr"
   else
      skpr="skl=sklr.and.ot=gnOt"
   endif
   skpr:=skpr+forkopr+forNaT+'.and.iif(gnOtv=0,osv>0,(osv+osvo)>0)'

   if gnBlk=0
      if gnRoz=1.and.gnVo=1
         rctovmr=slcf('tovm',7,1,12,,"e:mntov h:'Код' c:n(7) e:nat h:'Наименование' c:c(37) e:upak_s() h:'Упк' c:c(4) e:nei h:'Изм' c:c(3) e:osv+osvo h:'Ост.вып.' c:n(10,3) e:&coptr h:subs(ntcenr,1,10) c:n(9,3)",,1,1,whileCond,skpr,'n/bg,n/w','Справочник склада по отпускным ценам')
      else
         rctovmr=slcf('tovm',7,1,12,,"e:mntov h:'Код' c:n(7) e:nat h:'Наименование' c:c(37) e:upak_s() h:'Упк' c:c(4) e:nei h:'Изм' c:c(3) e:osv+osvo h:'Ост.вып.' c:n(10,3) e:"+coptr+iif(ndsr=5,"*1.2","")+" h:subs(ntcenr,1,10) c:n(9,3)",,1,1,whileCond,skpr,'n/bg,n/w','Справочник склада по отпускным ценам')
      endif
   endif
   if gnBlk=2
      if gnRoz=1.and.gnVo=1
         rctovmr=slcf('tovm',7,1,12,,"e:mntov h:'Код' c:n(7) e:nat h:'Наименование' c:c(37) e:upak_s() h:'Упк' c:c(4) e:nei h:'Изм' c:c(3) e:osv h:'Ост.вып.' c:n(10,3) e:&coptr h:subs(ntcenr,1,10) c:n(9,3)",,1,1,whileCond,skpr,'n/bg,n/w','Справочник склада по отпускным ценам')
      else
         rctovmr=slcf('tovm',7,1,12,,"e:mntov h:'Код' c:n(7) e:nat h:'Наименование' c:c(37) e:upak_s() h:'Упк' c:c(4) e:nei h:'Изм' c:c(3) e:osv h:'Ост.вып.' c:n(10,3) e:"+coptr+iif(ndsr=5,"*1.2","")+" h:subs(ntcenr,1,10) c:n(9,3)",,1,1,whileCond,skpr,'n/bg,n/w','Справочник склада по отпускным ценам')
      endif
   endif
   sele tovm
   go rctovmr
   izgrr=izgr
   mntovr=mntov
   natr=nat
   exxr=0
   do case
      case lastkey()=K_F1 // F1
           if prF1r=0
              prF1r=1
           else
              prF1r=0
           endif
      case lastkey()=K_SPACE.and.ChkGr350M() // Отбор
*           if gnCtov=1
*              obncen(mntovr)
*           endif
           rs2mins(0)
           pere(1)
      case lastkey()=K_F3 // фильтр по наименованию
*           CreateFiltNamTov(@forNaT)
*           whileCond:="kg_r=INT(ktl/1000000)"
*           sele tovm
*           kg_r:=INT(INT(mntov/10000))
*           //найдем первую
*           if !netseek('t2','sklr,kg_r')
*               go rctovmr
*           else
*               rctovmr=recn()
*           endif

      case lastkey()=K_F42 // снять фильтр по наименованию
*           forNaT:=".AND..T."
*           whileCond:=NIL
*           @ MAXROW()-1, 0 SAY SPACE(MAXROW())
*           rctovmr:=rcn_r_start
      case lastkey()=K_F4 // Коррекция
*           wmess('Коррекция в партионном экране',1)
           tovins(2, 'tovm')
      case lastkey()=K_F5 // Отдел
           sele cskle
           if netseek('t1','gnSk')
              gnOt=slcf('cskle',,,,,"e:ot h:'От' c:n(2) e:nai h:'Наименование' c:c(20)",'ot',0,,'sk=gnSk')
              if netseek('t1','gnSk,gnOt')
                 gcNot=nai
                 @ 1,60 say gcNot color 'gr+/n'
              endif
           endif
           sele tovm
           go top
           rctovmr=recn()
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
              if gnOt=0
                 forgr='.T.'
              else
                 forgr='ot=gnOt'
              endif
              forgr=forgr+forgkopr
              kg_r=slcf('sgrp',,,,,"e:kgr h:'Код' c:n(3) e:ngr h:'Наименование' c:c(20)",'kgr',,1,,forgr)
              do case
                 case lastkey()=K_ENTER
                      sele tovm
                      if !netseek('t2','sklr,kg_r')
                         go rctovmr
                      else
                         rctovmr=recn()
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
           sele tovm
           loop
      case lastkey()=K_ESC //
           exit
      case lastkey()>32.and.lastkey()<255
      //case lastkey()>=65.and.lastkey()<=90.or.lastkey()>=97.and.lastkey()<=122.or.lastkey()>=128.and.lastkey()<=175.or.lastkey()>=224.and.lastkey()<=239
           sele tovm
           lstkr=upper(chr(lastkey()))
           if !netseek('t2','sklr,int(mntovr/10000),lstkr')
              go rctovmr
           else
              rctovmr=recn()
           endif
      case lastkey()=K_ENTER.and.(gnAdm=1.or.gnKto=181) // Переход в партии
           sele tov
           set orde to tag t5
           if netseek('t5','sklr,mntovr')
              rtovslcm()
              pere(1)  // Перерасчет без rs3
           endif
   othe
      loop
   endc
enddo
setcolor(oclr1)
rest scre from sctovslc

FUNCTION ChkGr350M()
LOCAL nRecNo
LOCAL lAddRec:=.T.

nRecNo:=rs2m->(RECNO())
IF rs2m->(netseek("t1","ttnr"))

  IF int(mntovr/10000)=350 //табак
    IF rs2m->(int(mntov/10000))=350
      lAddRec:=.T.
    ELSE
      lAddRec:=.F.
    ENDIF
  ELSEIF int(mntovr/10000)#350
    IF rs2->(int(mntov/10000))#350
      lAddRec:=.T.
    ELSE
      lAddRec:=.F.
    ENDIF
  ENDIF

ELSE
  lAddRec:=.T.
ENDIF

IF !lAddRec
  IF int(mntovr/10000)=350
    wmess("Группу ТАБАК вводите в другую накладную")
  ELSE
    wmess("В этой накладной только группа ТАБАК")
  ENDIF
ENDIF

rs2->(DBGOTO(nRecNo))
RETURN lAddRec

func rtovslcm()
rs2vidr=2
save scre to sctovslcm
oclr1=setcolor('w+/b')
if select('sl')=0
   sele 0
   use _slct alias sl excl
   zap
endif
sele tov
rcktlr:=recn()
do while .t.
   sele tov
   foot('SPACE,F4','Отбор,Корр.')
   go rcktlr
   rcktlr=slcf('tov',10,1,7,,"e:ktl h:'Код' c:n(9) e:nat h:'Наименование' c:c(32) e:upak_s() h:'Упк' c:c(4) e:nei h:'Изм' c:c(3) e:iif(opt#0,' ','*') h:'O' c:c(1) e:osv+osvo h:'Ост.вып.' c:n(10,3) e:&coptr h:subs(ntcenr,1,10) c:n(9,3)",,1,1,'mntov=mntovr','iif(gnOtv=0,osv>0,(osv+osvo)>0)','n/w,n/bg',str(mntovr,7)+' '+alltrim(natr)+' по партиям')
   sele tov
   go rcktlr
   ktlr=ktl
   izgrr=izgr
   mntovr=mntov
   do case
      case lastkey()=K_SPACE // Отбор
           if gnCtov=1
*              obncen(mntovr)
           endif
           rs2ins(0)
           pere(1)
      case lastkey()=K_F4 // Коррекция
           if gnD0k1=1
              tovins(1, 'tov')
           else
              if gnCtov=1
*                 obncen(mntovr)
              endif
              tovins(2, 'tov')
           endif
      case lastkey()=K_ESC //
           exit
   othe
      loop
   endc
enddo
rs2vidr=1
setcolor(oclr1)
rest scre from sctovslcm

