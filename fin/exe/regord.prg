#include "common.ch"
#include "inkey.ch"
***************     Печать регист. кас.операций       **************

stor 0 to bsr
nbsr=space(20)
ddcr=gdTdn
stro=0
ndokr=space(30)
tipr=0
tipor=0
netuse('tipd')
netuse('dokz')
netUse('dokk')
netUse('bs')
set color to g/n,n/g,,,
******************************************************************
go top
@ 0,0 clea
@ 1,20 say 'Регистрация кассовых операций'
clor=setcolor('gr+/b,n/w')
wor=wopen(10,20,16,69)
wbox(1)
do while lastkey()#K_ESC
   @ 0,1 say 'Счет ' get bsr pict '999999' valid vbsr()
   @ 2,1 say 'Дата ' get ddcr
   @ 3,1 say 'Тип док-та ' get tipr pict '999' valid vtip()
   read
   @ 4,1  Prompt ' Печать '
   @ 4,col()+1 prompt ' Файл '
   @ 4,col()+1 Prompt ' Выход '
   Menu To Men1
   do case
      Case Men1 = 1.or.men1=2
           wselect(0)
           save screen to scpregord
           mess('Ждите... ')
           pregord()
           rest screen from scpregord
           wselect(wor)
      Case Men1 = 3
           Set Device To Screen
           exit
      case lastkey()=K_ESC
           exit
   EndCase
enddo
wclose(wor)
setcolor(clor)
nuse()
erase ('vdb.dbf')
erase ('vkr.dbf')

retu


stat func vbsr()
*показ справочника балансовых счетов
wselect(0)
sele bs
do whil .t.
   if bsr=0
      go top
      bsr=slcf('bs',,,,,"e:bs h:'Счет' c:n(6) e:nbs h:'Наименование' c:c(20)",'bs')
   endi
   if !netseek('t1','bsr')
      @ MAXROW()-1,20
      wait 'Баллансового счета с этим кодом нет! Нажмите любую клавишу...'
      @ MAXROW()-1,0 clear
      set color to g/n,n/g,,,
      bsr=0
      if lastkey()=K_ESC
         exit
      endif
      loop
   else
      nbsr=nbs
      tipor=tipo
      exit
   endi
   if lastkey()=K_ESC
      exit
      nuse()
      return .f.
   endif
enddo
wselect(wor)
@ 1,1 say alltrim(nbsr)
return .t.

stat func vtip()
wselect(0)
if select('sl')=0
   sele 0
   use _slct alias sl excl
else
   sele sl
   zap
endif
sele tipd
go top
do while .t.
   tipr=slcf('tipd',,,,,"e:tipo h:'ТО' c:n(2) e:tip h:'Тип' c:n(3) e:ndok h:'Наименование' c:c(30)",'tip',1,,,'tipo=tipor')
   netseek('t1','tipor,tipr')
   if lastkey()=K_ESC .or.lastkey()=13
      exit
   endif
enddo
wselect(wor)
return .t.

func pregord
lis=1
if file('vdb.bdf')
   erase ('vdb.dbf')
endif
if file('vkr.bdf')
   erase ('vkr.dbf')
endif
sele dokz
netseek('t1','bsr,ddcr')
mnr=mn
sele dokk
set order to tag t4
seek dtos(ddcr)
copy to vdb fields ddk,rn,bs_s,tip for bs_d=bsr .and. mn=mnr  while ddk=ddcr
go top
seek dtos(ddcr)
copy to vkr fields ddk,rn,bs_s,tip for bs_k=bsr .and. mn=mnr  while ddk=ddcr
sele 0
use vdb
*index on str(tip,3)+str(rn,6) to ivdb
sele vdb
go top
do while !eof()
    tipr=tip
    sele sl
    go top
    locate for val(kod)=tipr
    if !found()
       sele vdb
       dele
    endif
    sele vdb
    skip
enddo
sele vdb
pack
index on str(tip,3)+str(rn,6) to ivdb
go top
sele 0
use vkr
*index on str(tip,3)+str(rn,6) to ivkr
sele vkr
go top
do while !eof()
    tipr=tip
    sele sl
    go top
    locate for val(kod)=tipr
    if !found()
       sele vkr
       dele
    endif
    sele vkr
    skip
enddo
sele vkr
pack
index on str(tip,3)+str(rn,6) to ivkr
go top
vk=1
vd=1
tipd_r=0
tipk_r=0
sdb=0
skr=0
do case
   Case Men1 = 1
        if gnOut=1
*           Set Device To Print
           set print to LPT1
        else
*           Set Device To Print
           set print to order.txt
        endif
   Case Men1 = 2
*        Set Device To Print
        set print to order.txt
EndCase
if gnEnt=14
   ?chr(27)+'E'+chr(27)+'&l1h26a0O'+chr(27)+chr(27)+'(3R'+chr(27)+'(s0p21.00h0s0b4099T'+chr(27)  // Книжная А4
else
   ?chr(27)+chr(77)+chr(15)
endif
zagr()
do while .t.
   sele vdb
   tipr=tip
   if !eof()
      if tipr#tipd_r
         if sdb#0
            ?space(22)+str(sdb,15,2)
            sdb=0
         else
            ?getfield('t1','tipor,tipr','tipd','ndok')+space(7)
            tipd_r=tipr
         endif
      else
         ?dtoc(ddk)+'  '+str(rn,6)+'    '+substr(str(bs_s,15,2),1,13)+subs(str(bs_s,15,2),14,2)
          sdb=sdb+bs_s
        skip
      endif
      vd=1
   else
      if sdb#0
         ?space(22)+str(sdb,15,2)
         sdb=0
         vd=1
      else
         vd=0
      endif
   endif
   sele vkr
   tipr=tip
   if !eof()
      if vd=1
         if tipr#tipk_r
            if skr#0
               ??space(35)+str(skr,15,2)
               skr=0
            else
               ??space(14)+alltrim(getfield('t1','tipor,tipr','tipd','ndok'))
               tipk_r=tipr
            endif
         else
            ??space(14)+dtoc(ddk)+'  '+str(rn,6)+'   '+substr(str(bs_s,15,2),1,13)+subs(str(bs_s,15,2),14,2)
              skr=skr+bs_s
              skip
         endif
      else
         if tipr#tipk_r
            if skr#0
               ?space(73)+str(skr,15,2)
               skr=0
            else
               ?space(51)+alltrim(getfield('t1','tipor,tipr','tipd','ndok'))
               tipk_r=tipr
            endif
         else
             ?space(51)+dtoc(ddk)+'  '+str(rn,6)+'   '+substr(str(bs_s,15,2),1,13)+subs(str(bs_s,15,2),14,2)
              skr=skr+bs_s
              skip
         endif
      endif
      vk=1
   else
      if skr#0
         if vd=1
            ??space(35)+str(skr,15,2)
         else
            ?space(73)+str(skr,15,2)
         endif
         skr=0
         vk=1
      else
         vk=0
      endif
   endif


   if vd=1.or.vk=1
      snova()
   else
      exit
   endif
enddo
?'  '
/*
set cons on
set print off
set print to
set devi to screen
*/
ClosePrintFile()
if select('sl')#0
   sele sl
   zap
endif
nuse('vdb')
nuse('vkr')
*rest screen from sord
*wselect(wor)
retu

*************
stat func zagr()
set devi to print
set print on
stro=0
?'Журнал регистрации кассовых ордеров по счету: '+str(bsr,6)+'   на '+dtoc(ddcr)+' г.  Лист '+str(lis,3)
?'----------------------------------------------------------------------------------------------------|'
?'|Приходной документ  |     Сумма      | Примечание| Расходной документ |     Сумма      | Примечание|'
?'---------------------|----------------|-----------|--------------------|----------------|-----------|'
?'|  Дата    |   Номер |     грн    |коп|           |    Дата  |   Номер |   грн      |коп|           |'
?'----------------------------------------------------------------------------------------------------|'
stro=6
lis=lis+1
retu

stat func snova()
stro=stro+1
if stro>61
   eject
   zagr()
endi
retu



