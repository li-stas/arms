#include "common.ch"
#include "inkey.ch"

*************  печать ТТН ***************
local sel
sel=select()
kk=1
kkr=1
vlpt1='lpt1'
vpt=2
@ 24,0 clea
ccp=1
do while .t.
   @ 24,5  prompt' ПРОСМОТР '
   @ 24,25 prompt'  ПЕЧАТЬ  '
*   @ 24,35 prompt'ЭКРАН'
   menu to ccp
   if lastkey()=K_ESC
      set devi to scre
      exit
   endif
   @ 24,0 clea
   set devi to scre
   @ 24,11 say 'ЖДИТЕ РАБОТАЕТ ПЕЧАТЬ'
   If ccp = 1
      Set Prin To kach.TXT
   else
      if ccp=2
         set prin to
*      if gnOut=1
         if gnSpech=1
            alpt0={'ДА','НЕТ'}
            vpt=alert('СЕТЕВОЙ ПРИНТЕР',alpt0)
         endif
         if vpt=2 // Локальная печать
            if empty(gcPrn)
               set prin to lpt1
            else
               ??chr(27)+'E'+chr(27)+'&l4h25a0O'+chr(27)+'&k2S'+chr(27)+'&a20l'+chr(27)+'(3R'+chr(27)+'(s0p17.00h0s1b4102T'+chr(27)
            endif
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
         ??chr(27)+'E'+chr(27)+'&l4h25a0O'+chr(27)+'&k2S'+chr(27)+'&a20l'+chr(27)+'(3R'+chr(27)+'(s0p17.00h0s1b4102T'+chr(27)
      endif
   endif
   if vpt=1.and.ccp=2
      ??chr(27)+'E'+chr(27)+'&l4h25a0O'+chr(27)+'&k2S'+chr(27)+'&a20l'+chr(27)+'(3R'+chr(27)+'(s0p17.00h0s1b4102T'+chr(27)
   endif
   do while kkr<=kk
      if vpt=2
         prnkach()
         exit
      else
         prnkach()
      endif
      kkr=kkr+1
   enddo
set print off
set print to
set cons on
if ccp=3
   edfile('kach.txt')
endif

@ 24,0 clea
sele(sel)
exit
enddo
return


proc prnkach  // Печать

lstr=1
rswr=1
if vpt=2  // Локальная печать
   set devi to scre
   save scre to scmess
   mess(notr+' Вставте лист и нажмите пробел',0)
   rest scre from scmess
endi
vkachsh()
nn=1
Do While ttn=ttnr
   rcnr=recn()
   ktlr=ktl
   kvpr=kvp
   dotr=getfield('t1','ttnr','rs1','dot')
   srealr=getfield('t1','sklr,ktlr','tov','sreal')
   natr=getfield('t1','sklr,ktlr','tov','nat')
   /*
 *  if getfield('t1','int(ktlr/10000)','sgrp','mark')=1
 *     nat_r=alltrim(getfield('t1','kger','GrpE','nge'))+' '+alltrim(natr)+iif(upakr#0,' 1/'+kzero(upakr,10,3),'')
 *  else
 *     nat_r=alltrim(natr)+iif(upakr#0,' 1/'+kzero(upakr,10,3),'')
 *  endif
 *  lnat_r=len(nat_r)
 *  if lnat_r<50
 *     if upakr=0
 *        nat_r=nat_r+space(50-lnat_r)
 *     else
 *        nat_r=iif(getfield('t1','int(ktlr/10000)','sgrp','mark')=1,alltrim(getfield('t1','kger','GrpE','nge'))+' '+alltrim(natr),alltrim(natr))
 *        lnat_r=len(nat_r)
 *        cupakr=' 1/'+kzero(upakr,10,3)
 *        lcupakr=len(cupakr)
 *        nat_r=nat_r+space(50-lnat_r-lcupakr)+cupakr
 *     endif
 *        lnat_r=50
 *  endif
 */
   if !empty(srealr)
      ?' '+str(nn,2)+' '+substr(natr,1,50)+' '+str(kvpr,10,3)+' '+dtoc(dotr)+' '+dtoc(dotr)+' '+ltrim(str(srealr,10))+'час '
   else
      ?' '+str(nn,2)+' '+substr(natr,1,50)+' '+str(kvpr,10,3)+' '+dtoc(dotr)+' '+dtoc(dotr)
   endif
   nn=nn+1
   rslett()
   skip
enddo
rslett()
?' '
?'          Кондитерские изделия соответствуют требованиям ГОСТа утвержденным рецептурам. '
?'          Контроль за выпускаемой продукцией осуществляет бракеражная комиссия. '
?'          Удостоверение качества выдано кондитерским цехом АООТ "АГРАРНИК".    '
return

proc vkachsh()
?'                                    УДОСТОВЕРЕНИЕ О КАЧЕСТВЕ '
rslett()
?'                            выдано на указанные ниже кондитерские изделия, '
rslett()
?'                             вырабатываемые Сумским кондитерским цехом'
rslett()
?'                                            АООТ "АГРАРНИК"    '
rslett()
?'   Отправляются по накладной N '+str(ttnr,6)+'  от '+dtoc(dotr)
rslett()
?'   для реализации  _______________________________________________________________________________ '
rslett()
?''
rslett()
?'┌──┬─────────────────────────────────────────────────┬──────────┬──────────┬──────────┬──────────┬────┐'
?'│N │     Наименование                                │Количество│   Дата   │   Дата   │Срок      │Вид │'
?'│  │                                                 │          │ отгрузки │  отпуск  │реализ.   │упак│'
?'└──┴─────────────────────────────────────────────────┴──────────┴──────────┴──────────┴──────────┴────┘'
retu

proc rslett
rswr++
if rswr>=60
   rswr=1
   lstr++
   eject
     if vpt<>1
      set devi to scre
      save scre to scmess
      mess('Вставте лист и нажмите пробел',0)
      rest scre from scmess
      vkachsh()
     endif
endif
retu

