#include "inkey.ch"
* Банковская выписка
clea
netuse('dokz')
netuse('doks')
netuse('mfochk')
netuse('banks')
netuse('kln')
crtt('lbank','f:mfo c:c(6) f:nmfo c:c(20) f:bs c:n(6)')
sele 0
use lbank excl
sele mfochk
go top
do while !eof()
   if kkl8#gnKln_c
      skip
      loop
   endif
   mfor=mfo
   bsr=bs
   cmfor='000'+mfor
   nmfor=getfield('t1','cmfor','banks','otb')
   sele lbank
   loca for mfo=mfor
   if !found()
      appe blank
      repl mfo with mfor,;
           nmfo with nmfor,;
           bs with bsr
   endif
   sele mfochk
   skip
endd
sele lbank
go top
rclbankr=recn()
do while .t.
   foot('ENTER','Состав')
   sele lbank
   go rclbankr
   rclbankr=slcf('lbank',,,,,"e:mfo h:'МФО' c:c(6) e:nmfo h:'Наименование' c:c(20)",,,1,,,,'Банки')
   if lastkey()=K_ESC
      exit
   endif
   go rclbankr
   bsr=bs
   nmfor=alltrim(nmfo)
   if lastkey()=13
      sele dokz
      go top
      rcdokzr=recn()
      do while .t.
         foot('ENTER','Состав')
         sele dokz
         go rcdokzr
         rcdokzr=slcf('dokz',,,,,"e:ddc h:'Дата' c:d(10) e:knsd h:'Дебет' c:n(12,2) e:knsk h:'Кредит' c:n(12,2)",,,,,'bs=bsr',,nmfor)
         if lastkey()=K_ESC
            exit
         endif
         go rcdokzr
         mnr=mn
         ddcr=ddc
         if lastkey()=13
            sele doks
            netseek('t1','mnr')
            rcdoksr=recn()
            fldnomr=1
            do while .t.
               foot('','')
               sele doks
               go rcdoksr
               rcdoksr=slce('doks',1,1,18,,"e:tip h:'Т' c:n(1) e:kkl h:'Код' c:n(7) e:getfield('t1','doks->kkl','kln','nkl') h:'Наименование' c:с(40) e:nplp h:'ПП' c:n(6) e:ssd h:'Сумма' c:n(12,2) e:bosn h:'Основание' c:c(80)",,,,'mn=mnr',,,dtoc(ddcr),0,0)
               if lastkey()=K_ESC
                  exit
               endif
               sele doks
               go rcdoksr
               do case
                  case lastkey()=19 // Left
                       fldnomr=fldnomr-1
                       if fldnomr=0
                          fldnomr=1
                       endif
                  case lastkey()=4 // Right
                       fldnomr=fldnomr+1
               endc
               go rcdoksr
            endd
         endif
      endd
   endif
endd
sele lbank
use
erase lbank.dbf
nuse()
