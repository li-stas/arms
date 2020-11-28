#include "common.ch"
#include "inkey.ch"
para p1
*************  печать ТТН ***************
local sel
sel=select()
kplr=p1
kk=1
kkr=1
vlpt1='lpt1'
vpt=2
@ 24,0 clea

ccp=1
do while .t.
   @ 24,5  prompt' ПРОСМОТР '
   @ 24,25 prompt'  ПЕЧАТЬ  '
   @ 24,35 prompt'ЭКРАН'
   menu to ccp
   if lastkey()=K_ESC
      set devi to scre
      exit
   endif
   @ 24,0 clea
   set devi to scre
   @ 24,11 say 'ЖДИТЕ РАБОТАЕТ ПЕЧАТЬ'
   If ccp = 1
      Set Prin To txt.TXT
   else
      if ccp=2
         set prin to
*      if gnOut=1
         if gnSpech=1
            alpt0={'ДА','НЕТ'}
            vpt=alert('СЕТЕВОЙ ПРИНТЕР',alpt0)
         endif
         if vpt=2 // Локальная печать
            set prin to lpt1
            kk=1
         endif    // Сетевая печать
         if vpt=1
            @ 24,0 say 'ПЕЧАТЬ НА СЕТЕВОЙ ПРИНТЕР        '
            vlpt1='lpt2'
            alpt={'lpt2','lpt3'}
            vlpt=alert('ПЕЧАТЬ НА СЕТЕВОЙ ПРИНТЕР',alpt)
            if vlpt=1
               vlpt1='lpt2'
            else
               vlpt1='lpt3'
            endif
            kk=1
            kkr=1 // Счетчик экземпляров
            @ 24,36 say 'Количество  экз.'
            @ 24,52 get kk pict '9' valid kk<4
            read
            set prin to &vlpt1
         endif
*      else
*         Set Prin To txt.TXT
*      endif
       endif
   EndIF
   set prin on
   set cons off
   if vpt=2.and.ccp=2 // Локальная печать
      if empty(gcPrn)
         ??chr(27)+chr(80)+chr(15)
      else
         ??chr(27)+'E'+chr(27)+'&l4h2a0O'+chr(27)+'&k2S'+chr(27)+'&a20l'+chr(27)+'(3R'+chr(27)+'(s0p17.00h0s1b4102T'+chr(27)
      endif
   endif
   if vpt=1.and.ccp=2
      ??chr(27)+'E'+chr(27)+'&l4h2a0O'+chr(27)+'&k2S'+chr(27)+'&a20l'+chr(27)+'(3R'+chr(27)+'(s0p17.00h0s1b4102T'+chr(27)
   endif
   do while kkr<=kk
      if vpt=2
         prntar()
         exit
      else
         prntar()
      endif
      kkr=kkr+1
   enddo
set print off
set print to
set cons on
if ccp=3
   edfile('txt.txt')
endif

@ 24,0 clea
sele(sel)
exit
enddo
return


proc prntar  // Печать

lstr=1
rswr=1
if vpt=2  // Локальная печать
   set devi to scre
   save scre to scmess
   mess(notr+' Вставте лист и нажмите пробел',0)
   rest scre from scmess
endi
vtarsh()
if autor#0
   if skar#0
      netuse('cskl')
      if netseek('t1','skar')
         gcPath_tt=gcPath_d+alltrim(path)
         if !file(gcPath_tt+'tprds01.dbf')
            wmess('Нет баз для автоматического прихода',3)
            select(sel)
*            nuse('cskl')
            return
         endif
      else
         wmess('Не найден адрес в CSKL',3)
         select(sel)
*         nuse('cskl')
         return
      endif
   else
      wmess('Нет адреса для автоматического прихода в OPER',3)
      select(sel)
*      nuse('cskl')
      return
   endif
endif
pathr=gcPath_tt
netuse('tov','tovt',,1)
set orde to tag t5
netseek('t5','kplr')
skltr=kplr
ssvprt=0
ssvprst=0
Do While skl=skltr
   rcnr=recn()
   ktlr=ktl
   natr=nat
   osfr=osf
   osfmr=osfm
   optr=opt
   kgr=kg
   svpr=round(osfr*optr,2)
   ?' '+ substr(natr,1,30)+' '+str(osfr,10,3)+' '+str(optr,10,3)+' '+str(svpr,15,2)+' '+dtoc(dpp)
   rslet1()
   if kgr=0
      ssvprt=ssvprt+svpr
   else
      ssvprst=ssvprst+svpr
   endif
   sele tovt
   skip
enddo
*nuse('cskl')
nuse('tovt')
rslet1()
?''
?space(30)+'────────────────────────────────────────'

?space(30)+'Итого по стеклотаре '+space(5)+alltrim(str(ssvprst,15,2)) //+' грн.'
rslet1()
?space(30)+'Итого по таре       '+space(5)+alltrim(str(ssvprt,15,2)) //+' грн.'
?''
?'  Возвратная тара должна быть возвращена на склад поставщика'
?'  в течении  5  банковских  дней  со  дня  получения товара.'
?'  В  случае  невозврата   в  срок  Ваша  ЗАДОЛЖЕННОСТЬ перед'
?'  поставщиком  БУДЕТ  УВЕЛИЧИНА  на сумму  НДС, начисленного'
?'  на залоговую стоимость тары.'
?''
?''
return

proc vtarsh
?'                        Ведомость по возвратной таре'
rslet1()
?''
?'Поставщик : '+alltrim(gcName_c)+'  код '+str(gnKln_c,8)
rslet1()
?'Получатель : '+ alltrim(nkplr)+'  код '+str(kplr,7)
rslet1()
?'Дата   '+dtoc(gdTd)
rslet1()
?'┌──────────────────────────────┬──────────┬──────────┬───────────────┬────────┐'
?'│       Наименование           │Количество│  Цена    │    Сумма      │ Дата   │'
?'│          тары                │          │          │               │        │'
?'└──────────────────────────────┴──────────┴──────────┴───────────────┴────────┘'
retu

proc rslet1
rswr++
if rswr>=43
   rswr=1
   lstr++
   eject
     if vpt<>1
      set devi to scre
      save scre to scmess
      mess('Вставте лист и нажмите пробел',0)
      rest scre from scmess
      vtarsh()
     endif
endif
retu

