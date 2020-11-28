#include "common.ch"
#include "inkey.ch"
*****************
func licc(p1,p2)
****************
kpl_r=p1
kgp_r=p2
*netuse('klnlic')
*netuse('lic')
save scre to scklnlic
sele klnlic
if gnArm=3
   if !netseek('t1','kpl_r,kgp_r')
      go top
   endif
   forlicr='kkl=kpl_r.and.kgp=kgp_r'
else
   kpl_r=kln->kkl
   if !netseek('t1','kpl_r')
      go top
   endif
   forlicr='kkl=kpl_r'
endif
rcklnlic=recn()
set cent on
do while .t.
   sele klnlic
   go rcklnlic
   foot('INS,DEL,F4,F5','Добавить,Удалить,Коррекция,Печать спр.')
   if gnArm=2
      rcklnlic=slcf('klnlic',,,,,"e:kgp h:'Код' c:n(7) e:rnlic h:'N' c:n(4) e:dtoc(dnl) h:'Дата Н' c:c(10) e:dtoc(dol) h:'Дата О' c:c(10) e:serlic h:'Сер.' c:c(4) e:numlic h:'Номер' c:n(13) e:getfield('t1','klnlic->lic','lic','nlic') h:'Наименование' c:c(20)",,,1,forlicr,,,'Лицензии')
   else
      rcklnlic=slcf('klnlic',,,,,"e:rnlic h:'N' c:n(4) e:dtoc(dnl) h:'Дата Н' c:c(10) e:dtoc(dol) h:'Дата О' c:c(10) e:serlic h:'Сер.' c:c(4) e:numlic h:'Номер' c:n(13) e:getfield('t1','klnlic->lic','lic','nlic') h:'Наименование' c:c(20)",,,1,forlicr,,,'Лицензии')
   endif
   go rcklnlic
   rnlicr=rnlic
   dnlr=dnl
   dolr=dol
   serlicr=serlic
   numlicr=numlic
   kgp_r=kgp
   if fieldpos('regnom')#0
      regnomr=regnom
   else
      regnomr=0
   endif
   if fieldpos('lice')#0
      licer=lice
   else
      licer=0
   endif
   nlicer=getfield('t1','licer','lice','nlice')
   licr=lic
   nlicr=getfield('t1','licr','lic','nlic')
   do case
      case lastkey()=K_ESC.or.lastkey()=K_ENTER
           exit
         case lastkey()=22.and.(gnAdm=1.or.gnRlic=1)
              klicins()
              rcklnlic=recn()
         case lastkey()=7.and.(gnRlic=1.or.gnAdm=1)
              netdel()
              skip -1
         case lastkey()=-3
              if gnAdm=1.or.gnRlic=1
                 klicins(1)
              else
                 klicins(2)
              endif
         case lastkey()=-4
              licprn()
   endc
endd
set cent off
rest scre from scklnlic
*nuse('klnlic')
*nuse('lic')
retu .t.

**********************
stat func klicins(p1)
  **********************
  local getlist:={},cl1,l_numlicr,l_regnomr
  cor_r=p1
  cl1=setcolor()
  wopfhins=nwopen(9,20,19,65,1,'gr+/b')
  if p1=nil
     store 0 to rnlicr,numlicr,licr,regnomr
     store ctod('') to dnlr,dolr
     store space(4) to serlicr
     if gnArm=3
        kgp_r=rs1->kgp
     else
        kgp_r=0
     endif
     sele klnlic
     set orde to tag t5
     if netseek('t5','kpl_r')
  *   if netseek('t1','kpl_r')
        do while kkl=kpl_r
           rnlicr=rnlic
           skip
        endd
        rnlicr=rnlicr+1
     endif
     set orde to tag t1
     go rcklnlic
  endif
  set cent on
  do while .t.
     if p1=nil
        @ 0,1 say 'Маш.N лицензии' get rnlicr pict '9999' valid rnlici()
        if gnArm=2
            @ 1,1 say 'Получатель' get kgp_r pict '9999999'
        else
            @ 1,1 say 'Получатель'+' '+str(kgp_r,7)
        endif
     else
        @ 0,1 say 'Маш.N лицензии'+' '+str(rnlicr,4)
        if gnArm=2
           @ 1,1 say 'Получатель' get kgp_r pict '9999999'
        else
           @ 1,1 say 'Получатель'+' '+str(kgp_r,7)
        endif
     endif
     if p1#2
        @ 2,1 say 'Рег.номер лицензии    ' get regnomr  pict '@R 99999999-99999'
        @ 3,1 say 'Дата начала лицензии  ' get dnlr
        @ 4,1 say 'Дата окочания лицензии' get dolr
        @ 5,1 say 'Серия' get serlicr valid serlic() pict '9999'
        @ 5,col()+1 say 'Номер' get numlicr pict '@R 99999999-99999' // valid numlic()
        @ 6,26 say nlicr
        @ 6,1 say 'Вид лицензии         '  get licr pict '9' valid vlic()
        @ 7,26 say nlicer
        @ 7,1 say 'Тип лицензии         '  get licer pict '99' valid vlice()
     else
        @ 1,1 say 'Получатель'+' '+str(kgp_r,7)
        @ 2,1 say 'Рег.номер лицензии    '+' '+str(regnomr,17)
        @ 3,1 say 'Дата начала лицензии  '+' '+dtoc(dnlr)
        @ 4,1 say 'Дата окочания лицензии'+' '+dtoc(dolr)
        @ 5,1 say 'Серия'+' '+serlicr
        @ 5,col()+1 say 'Номер'+' '+str(numlicr,17)
        @ 6,26 say nlicr
        @ 6,1 say 'Вид лицензии         '+' '+str(licr,1)
        @ 7,26 say nlicer
        @ 7,1 say 'Тип лицензии         '+' '+str(licer,2)
     endif
     if p1#2
        read
        if lastkey()=K_ESC
           exit
        endif
     endif
     @ 8,25 prom 'Верно'
     @ 8,col()+1 prom 'Не верно'
     menu to vn
     if lastkey()=K_ESC
        exit
     endif
     if p1#2
  //      if kpl_r=0.or.kgp_r=0.or.rnlicr=0.or.empty(dnlr).or.empty(dolr).or.empty(serlicr).or.numlicr=0.or.licr=0.or.regnomr=0.or.licer=0
  //         exit
  //      endif
        if kpl_r=0.or.kgp_r=0.or.rnlicr=0.or.empty(dnlr).or.empty(dolr).or.licr=0.or.regnomr=0.or.licer=0
           exit
        endif
        if vn=1
           sele klnlic
           if p1=nil
              netadd()
              netrepl('kkl,kgp,rnlic,dnl,dol,serlic,numlic,lic',;
              {kpl_r,kgp_r,rnlicr,dnlr,dolr,serlicr,numlicr,licr})
              if fieldpos('kto')#0
                 netrepl('kto',{gnKto})
              endif
              if fieldpos('lice')#0
                 netrepl('lice',{licer})
              endif
              if fieldpos('regnom')#0
                 netrepl('regnom',{regnomr})
              endif
           else
              netrepl('dnl,dol,serlic,numlic,lic',;
              {dnlr,dolr,serlicr,numlicr,licr})
              if fieldpos('kto')#0
                 netrepl('kto',{gnKto})
              endif
              if fieldpos('lice')#0
                 netrepl('lice',{licer})
              endif
              if fieldpos('regnom')#0
                 netrepl('regnom',{regnomr})
              endif
              if gnArm=2
                 netrepl('kgp',{kgp_r})
              endif
           endif
        endif
        exit
    endif
  endd
  set cent off
  wclose(wopfhins)
  setcolor(cl1)
  retu .t.

stat func rnlici()
if netseek('t1','kpl_r,kgp_r,rnlicr')
   wselect(0)
   save scre to scmess
   mess('Такой маш.N уже существует',1)
   rest scre from scmess
   wselect(wopfhins)
   retu .f.
endif
retu .t.

stat func serlic()
serlicr=upper(serlicr)
retu .t.

stat func numlic()
if netseek('t2','serlicr,numlicr').and.cor_r=0
   rnlic_r=rnlic
   wselect(0)
   save scre to scmess
   mess('Эта лицензия уже зарегистрирована под N '+str(rnlic_r,6),1)
   rest scre from scmess
   wselect(wopfhins)
   retu .f.
endif
retu .t.

stat func vlic()
  sele lic
  if licr=0.or.!netseek('t1','licr')
     go top
     wselect(0)
     do while .t.
        licr=slcf('lic',,,,,"e:lic h:'Код' c:n(1) e:nlic h:'Наименование' c:c(20) ",'lic')
        netseek('t1','licr')
        nlicr=nlic
        do case
           case lastkey()=K_ESC.or.lastkey()=K_ENTER
                exit
        endc
     endd
     wselect(wopfhins)
  endif
  @ row(),26 say nlicr
retu .t.

stat func vlice()
sele lice
if licr=0.or.!netseek('t1','licer')
   go top
   wselect(0)
   do while .t.
      licer=slcf('lice',,,,,"e:lice h:'Код' c:n(1) e:nlice h:'Наименование' c:c(20) ",'lice')
      netseek('t1','licer')
      nlicer=nlice
      do case
         case lastkey()=K_ESC.or.lastkey()=K_ENTER
              exit
      endc
   endd
   wselect(wopfhins)
endif
@ row(),26 say nlicer
retu .t.

*******************
stat func licprn()
*******************

sel=select()
recr=recno()
sele klnlic
go top
rswr=1
lstr=1
save scre to scmess
mess(' Вставте лист и нажмите пробел',0)
rest scre from scmess
set devi to print
if gnOut=2
   set print to txt.txt
else
   set print to lpt1
endif
set print on
set cons off
shs()
rsl1()
do while !eof()
   if !(gdTd>=dnl .and. gdTd<=dol)
      skip
      loop
   endif
   // ?' '+str(kkl,7)+' '+str(kgp,7)+' '+subs(getfield('t1','klnlic->kkl','kln','nkl'),1,30)+' '+str(regnom,12)+' '+serlic+' '+dtoc(dnl)+' '+dtoc(dol)+' '+str(numlic,6)+' '+getfield('t1','klnlic->lic','lic','nlic')
   ?' '+str(kkl,7)+' '+str(kgp,7)+' '+subs(getfield('t1','klnlic->kkl','kln','nkl'),1,30)+' '+dtoc(dnl)+' '+dtoc(dol)+' '+serlic+''+str(numlic,13)+' '+getfield('t1','klnlic->lic','lic','nlic')
   rsl1()
   skip
enddo
sele(sel)
go recr
/*
set print off
set print to
set devi to screen
*/
ClosePrintFile()
return

proc rsl1()
rswr++
if rswr>=60
   rswr=1
   lstr++
   eject
   if gnOut=1
      set devi to scre
      save scre to scmess
      mess('Вставте лист и нажмите пробел',0)
      rest scre from scmess
      set devi to print
   endif
   shs()
endif
retu

proc shs()
?'             Справочник клиентов с лицензией.                                                                                      Лист'+str(lstr)
?'┌───────┬──────────────────────────────┬───────┬──────────────────────────────┬────────────┬────┬──────────┬──────────┬──────┬────────────────────┐'
?'│Kод    │        Плательщик            │   Код │       Получатель             │ Рег.номер  │Сер.│  Начало  │ Оканчание│ Номер│        Вид         │'
?'└───────┴──────────────────────────────┴───────┴──────────────────────────────┴────────────┴────┴──────────┴──────────┴──────┴────────────────────┘'

return
****************************
func  prnnn(p1,p2,p3,p4,p5,p6,p7)
* mn
* rnd
* sk
* rn
* mnp
* lpt
* к-во экз
****************************
if p6#nil
   gnScOut=1
endif
mn_r=p1
rnd_r=p2
sk_r=p3
rn_r=p4
mnp_r=p5
fopr=1
if alias()#'NNDS'
   sele nnds
   if !netseek('t2','mn_r,rnd_r,sk_r,rn_r,mnp_r')
      wmess('Нет в NNDS',2)
      if p6#nil
         gnScOut=0
      endif
      retu .f.
   endif
endif
nnds_r=nnds
dnn_r=dnn

mn1_r=mn1
rnd1_r=rnd1
sk1_r=sk1
rn1_r=rn1
mnp1_r=mnp1
nnds1_r=nnds1
dnn1_r=dnn1

sele dokk
set orde to tag t12
if !netseek('t12','mn_r,rnd_r,sk_r,rn_r,mnp_r')
   wmess('Нет в DOKK',2)
   if p6#nil
      gnScOut=0
   endif
   retu .f.
else
   prndsr=0
   do while mn=mn_r.and.rnd=rnd_r.and.sk=sk_r.and.mnp=mnp_r
      if bs_k=641002.or.bs_d=641002.and.bs_k=704101.or.bs_d=641002.and.bs_k=643001
         prndsr=1
         exit
      endif
      sele dokk
      skip
   endd
   if prndsr=0
      wmess('Нет 641002 в DOKK',2)
      if p6#nil
         gnScOut=0
      endif
      retu .f.
   endif
endif
kklr=kkl
bs_dr=bs_d
bs_kr=bs_k
kopr=kop
vor=vo
* Реквизиты предприятия
sele kln
if !netseek('t1','gnKkl_c')
   wmess('Нет gnKkl_c в KLN',2)
   if p6#nil
      gnScOut=0
   endif
   retu .f.
endif
nai1r=alltrim(nklprn)
nn1r=nn
cnn1r=cnn
adr1r=alltrim(adr)
tlf1r=alltrim(tlf)
nsv1r=alltrim(nsv)

* Реквизиты клиента
sele kln
if !netseek('t1','kklr')
   wmess('Нет KKL в KLN',2)
   if p6#nil
      gnScOut=0
   endif
   retu .f.
endif
nai2r=alltrim(nklprn)
nn2r=nn
cnn2r=cnn
adr2r=alltrim(adr)
tlf2r=alltrim(tlf)
nsv2r=alltrim(nsv)

*if !(nn2r#0.and.!empty(nsv2r))
if nn2r=0
   wmess('Не плательщик НДС',2)
   if p6#nil
      gnScOut=0
   endif
   retu .f.
endif

fopr=1
if gnArm=2
   netuse('fop')
   go top
   rcfopr=recn()
   do while .t.
      sele fop
      go rcfopr
      rcfopr=slcf('fop',,,,,"e:fop h:'Код' c:n(2) e:nfop h:'Наименование' c:c(30)")
      if lastkey()=K_ESC
         exit
      endif
      go rcfopr
      fopr=fop
      if lastkey()=K_ENTER
         exit
      endif
   endd
endif

sele klndog
if netseek('t1','kklr')
   ndogr=ndog
   cndogr=alltrim(cndog)
   dtdogr=dtdogb
else
   ndogr=0
   cndogr=''
   dtdogr=ctod('')
endif

if select('tdoc')#0
   sele tdoc
   use
endif
erase tdoc.dbf
erase tdoc.cdx

if bs_kr=641002
   if vor=3.and.(kopr=136.or.kopr=137)
      crtt('tdoc',"f:gr1 c:c(10) f:gr2 c:c(18) f:gr3 c:c(50) f:gr4 c:c(5) f:gr5 c:c(10) f:gr6 c:c(10) f:gr7 c:c(10) f:gr8 c:c(10) f:gr9 c:c(10) f:gr10 c:c(10) f:gr11 c:c(10) f:rzd c:n(2) f:nn c:n(2)")
   *   A5 Альбом
      sprnr=chr(27)+'E'+chr(27)+'&l1h25a1O'+chr(27)+'&l3C'+chr(27)+'(3R'+chr(27)+'(s0p29.00h0s1b4102T'+chr(27)
   *   gr1r =space(10)  // Дата
   *   gr2r =space(18)  // Причина
   *   gr3r =space(50)  // Наименование
   *   gr4r =space(5)   // Ед изм.
   *   gr5r =space(10)  // Изм кол-ва
   *   gr6r =space(10)  // Цена поставки
   *   gr7r =space(10)  // Изм цены
   *   gr8r =space(10)  // Кол-во поставки
   *   gr9r =space(10)  // 20%
   *   gr10r=space(10)  // 0%
   *   gr11r=space(10)  // Освобожденнные от НДС
      nrowr=76
   else
      crtt('tdoc','f:gr1 c:c(3) f:gr2 c:c(10) f:gr3 c:c(50) f:gr4 c:c(5) f:gr5 c:c(10) f:gr6 c:c(10) f:gr7 c:c(12) f:gr8 c:c(10) f:gr9 c:c(10) f:gr10 c:c(10) f:gr11 c:c(12) f:rzd c:n(2) f:nn c:n(2)')
   *   A5
      sprnr=chr(27)+'E'+chr(27)+'&l1h25a0O'+chr(27)+'&l3C'+chr(27)+'(3R'+chr(27)+'(s0p29.00h0s1b4102T'+chr(27)
      nrowr=115
   *   gr1r =space(3)   // Раздел
   *   gr2r =space(10)  // Дата
   *   gr3r =space(50)  // Наименование
   *   gr4r =space(5)   // Ед изм.
   *   gr5r =space(10)  // Кол-во
   *   gr6r =space(10)  // Цена поставки
   *   gr7r =space(12)  // 20%
   *   gr8r =space(10)  // 0%
   *   gr9r =space(10)  // 0% экспорт
   *   gr10r=space(10)  // Освобожденнные от НДС
   *   gr11r=space(12)  // Общая сумма
   endif
else
   crtt('tdoc',"f:gr1 c:c(10) f:gr2 c:c(18) f:gr3 c:c(50) f:gr4 c:c(5) f:gr5 c:c(10) f:gr6 c:c(10) f:gr7 c:c(10) f:gr8 c:c(10) f:gr9 c:c(10) f:gr10 c:c(10) f:gr11 c:c(10) f:rzd c:n(2) f:nn c:n(2)")
*   A5 Альбом
   sprnr=chr(27)+'E'+chr(27)+'&l1h25a1O'+chr(27)+'&l3C'+chr(27)+'(3R'+chr(27)+'(s0p29.00h0s1b4102T'+chr(27)
*       ??chr(27)+'E'+chr(27)+'&l1h26a1O3C'+chr(27)+chr(27)+'(3R'+chr(27)+'(s0p20.00h0s0b4099T'+chr(27)  // Книжная А4
*      ??chr(27)+'E'+chr(27)+'&l1h25a1O'+chr(27)+'&l3C'+chr(27)+'(3R'+chr(27)+'(s0p29.00h0s1b4102T'+chr(27)
   nrowr=80
*   gr1r =space(10)  // Дата
*   gr2r =space(18)  // Причина
*   gr3r =space(50)  // Наименование
*   gr4r =space(5)   // Ед изм.
*   gr5r =space(10)  // Изм кол-ва
*   gr6r =space(10)  // Цена поставки
*   gr7r =space(10)  // Изм цены
*   gr8r =space(10)  // Кол-во поставки
*   gr9r =space(10)  // 20%
*   gr10r=space(10)  // 0%
*   gr11r=space(10)  // Освобожденнные от НДС
   nrowr=76
endif

sele 0
use tdoc shared
if p6=nil
   vlptr=0
   alpt={'lpt1','lpt2','lpt3','Файл'}
   vlptr=alert('ПЕЧАТЬ',alpt)
else
   vlptr=p6
endif
set cons off

if vlptr=1.or.vlptr=2.or.vlptr=3
   if p7=nil
      kkr=2
      @ 24,50 say 'Количество  экз.'
      @ 24,68 get kkr pict '9' valid kkr<4
      read
      if lastkey()=K_ESC
         if p6#nil
            gnScOut=0
          endif
         retu .f.
      endif
   else
      kkr=p7
   endif
else
   kkr=1
endif

if mn_r=0
   dir_r=getfield('t1','sk_r','cskl','path')
   pathr=gcPath_d+alltrim(dir_r)
   if mnp_r=0
      if select('rs1')=0
         if netfile('rs1',1)
            netuse('rs1',,,1)
            netuse('rs2',,,1)
            netuse('rs3',,,1)
            netuse('tov',,,1)
            netuse('sgrp',,,1)
            sele rs1
            if netseek('t1','rn_r')
               if kopr=135.or.kopr=136.or.kopr=137
                 ndsrskt()
               else
                 ndsrs()
               endif
            endif
            nuse('rs1')
            nuse('rs2')
            nuse('rs3')
            nuse('tov')
            nuse('sgrp')
         endif
      else
         if kopr=136.or.kopr=137
            ndsrskt()
         else
            ndsrs()
         endif
      endif
   else
      if select('pr1')=0
         if netfile('pr1',1)
            netuse('pr1',,,1)
            netuse('pr2',,,1)
            netuse('pr3',,,1)
            netuse('tov',,,1)
            netuse('sgrp',,,1)
            sele pr1
            if netseek('t2','mnp_r')
               ndspr()
            endif
            nuse('pr1')
            nuse('pr2')
            nuse('pr3')
            nuse('tov')
            nuse('sgrp')
         endif
      else
         ndspr()
      endif
   endif
else // Бух документ
   if bs_kr=641002
      rsbnds()
   else
      prbnds()
   endif
endif

sele nnds
netrepl('dprn','date()')

if select('tdoc')#0
   sele tdoc
   use
endif

retu .t.

**************
func ndsrs()
**************
sele rs1
ttnr=ttn
sklr=skl
prmk17r=0
nacr=0
skidr=0
sm61r=0
sm11r=0
sm12r=0
sm19r=0
sm90r=0
sm10r=0
sele rs3
if netseek('t1','ttnr')
   do while ttn=ttnr
      if ksz=10
         if ssf#0
            sm10r=ssf
         endif
      endif
      if ksz=12
         if ssf#0
            sm12r=ssf
         endif
      endif
      if ksz=19
         if ssf#0
            sm19r=ssf
         endif
      endif
      if ksz=11
         if ssf#0
            sm11r=ssf
         endif
      endif
      if ksz>=40.and.ksz<90
         if ksz#61
            if ssf>0
               nacr=nacr+ssf
            else
               skidr=skidr+ssf
            endif
         else
            sm61r=sm61r+ssf
         endif
      endif
      if ksz=90
         sm90r=ssf
      endif
      sele rs3
      skip
   endd
   if sm61r#0
      gr1r ='   '       // Раздел
      gr2r =dtoc(dnn_r)  // Дата
      gr3r ='Товаро-транспортнi витрати                        '  // Наименование
      gr4r ='посл.'   // Ед изм.
      gr5r ='     1.000'  // Кол-во
      gr6r =str(ttr,10,3)  // Цена поставки
      gr7r =str(ttr,12,2)  // 20%
      gr8r =space(10)  // 0%
      gr9r =space(10)  // 0% экспорт
      gr10r=space(10)  // Освобожденнные от НДС
      gr11r=space(12)  // Общая сумма
      sele tdoc
      netadd()
      netrepl('gr1,gr2,gr3,gr4,gr5,gr6,gr7,gr8,gr9,gr10,gr11,rzd,nn',;
      'gr1r,gr2r,gr3r,gr4r,gr5r,gr6r,gr7r,gr8r,gr9r,gr10r,gr11r,2,1')
   endif
   if nacr#0
      gr1r ='   '       // Раздел
      gr2r =dtoc(dnn_r)  // Дата
      gr3r =' Надано покупцю: | надбавка (+)                   '  // Наименование
      gr4r ='посл.'   // Ед изм.
      gr5r ='     1.000'  // Кол-во
      gr6r =str(nacr,10,3)  // Цена поставки
      gr7r =str(nacr,12,2)  // 20%
      gr8r =space(10)  // 0%
      gr9r =space(10)  // 0% экспорт
      gr10r=space(10)  // Освобожденнные от НДС
      gr11r=space(12)  // Общая сумма
      sele tdoc
      netadd()
      netrepl('gr1,gr2,gr3,gr4,gr5,gr6,gr7,gr8,gr9,gr10,gr11,rzd,nn',;
      'gr1r,gr2r,gr3r,gr4r,gr5r,gr6r,gr7r,gr8r,gr9r,gr10r,gr11r,1,2')
   endif
   if skidr#0
      gr1r ='   '       // Раздел
      gr2r =dtoc(dnn_r)  // Дата
      gr3r =' Надано покупцю: | знижка   (-)                   '  // Наименование
      gr4r ='посл.'   // Ед изм.
      gr5r ='     1.000'  // Кол-во
      gr6r =str(skidr,10,3)  // Цена поставки
      gr7r =str(skidr,12,2)  // 20%
      gr8r =space(10)  // 0%
      gr9r =space(10)  // 0% экспорт
      gr10r=space(10)  // Освобожденнные от НДС
      gr11r=space(12)  // Общая сумма
      sele tdoc
      netadd()
      netrepl('gr1,gr2,gr3,gr4,gr5,gr6,gr7,gr8,gr9,gr10,gr11,rzd,nn',;
      'gr1r,gr2r,gr3r,gr4r,gr5r,gr6r,gr7r,gr8r,gr9r,gr10r,gr11r,1,3')
   endif
endif
sele rs2
if netseek('t1','ttnr')
   do while ttn=ttnr
      mntovr=mntov
      if gnEnt=20.and.kklr=3229492
         if prmk17r=0
            mkeep_r=getfield('t1','mntovr','ctov','mkeep')
            if mkeep_r=17
               prmk17r=1
            endif
         endif
      endif
      ktlr=ktl
      kger=getfield('t1','sklr,ktlr','tov','kge')
      if sm12r=0
         if int(mntovr/10000)=0
            skip
            loop
         endif
      endif
      gr1r ='   '       // Раздел
      gr2r =dtoc(dnn_r)  // Дата
      sele ctov
      netseek('t1','mntovr')
      nat_r=nat
      if fieldpos('ukt')#0
         ukt_r=ukt
      else
         ukt_r=space(10)
      endif
      sele rs2
      if getfield('t1','int(ktlr/1000000)','sgrp','mark')=1.and.kger#0
         natr=alltrim(getfield('t1','kger','grpe','nge'))+' '+alltrim(nat_r)
      else
         natr=nat_r
      endif
      natr=padr(natr,50)
      if empty(ukt_r)
         gr3r=subs(natr,1,50)
      else
         gr3r=subs(natr,1,39)+' '+ukt_r
      endif
*      gr3r =subs(getfield('t1','mntovr','ctov','nat'),1,50)  // Наименование
      gr4r =getfield('t1','mntovr','ctov','nei')   // Ед изм.
      gr5r =str(rs2->kvp,10,3)  // Кол-во
      gr6r =str(rs2->zen,10,3)  // Цена поставки
      gr7r =str(rs2->svp,12,2)  // 20%
      gr8r =space(10)  // 0%
      gr9r =space(10)  // 0% экспорт
      gr10r=space(10)  // Освобожденнные от НДС
      gr11r=space(12)  // Общая сумма
      sele tdoc
      netadd()
      netrepl('gr1,gr2,gr3,gr4,gr5,gr6,gr7,gr8,gr9,gr10,gr11,rzd',;
      'gr1r,gr2r,gr3r,gr4r,gr5r,gr6r,gr7r,gr8r,gr9r,gr10r,gr11r,1')
      sele rs2
      skip
   endd
endif
sele tdoc
inde on str(rzd,2)+str(nn,2) tag t1

* Печать
do case
   case vlptr=1
        set prin to lpt1
   case vlptr=2
        set prin to lpt2
   case vlptr=3
        set prin to lpt3
   case vlptr=4
        set prin to nds.txt
endc
set cons off
set prin on
??sprnr
for kk=1 to kkr
    nlstr=1 // N листа
    store 0 to hd1r,hd2r,irowr // Счетчики шапок
    if nlstr=1
       hdndsr()
    endif
    hdndsr1()
    sele tdoc
    go top
    do while !eof()
       if rzd#1
          skip
          loop
       endif
       listr='│'+gr1+'│'+gr2+'│'+gr3+'│'+gr4+'│'+gr5+'│'+gr6+'│'+gr7;
        +'│'+gr8+'│'+gr9+'│'+gr10+'│'+gr11+'│'
       ?listr
       lste(3)
       sele tdoc
       skip
    endd
    ftndsr()
next
set prin off
set cons on
set prin to
retu .t.
**************
func ndspr()
**************
sele pr1
mnr=mn
ndr=nd
sklr=skl

if (gnEnt=20.or.gnEnt=21).and.kop=110.and.vo=1
   prvzznr=1
else
   prvzznr=0
endif
store 0 to sgr9
sele pr2
set orde to tag t3
if netseek('t3','mnr')
   do while mn=mnr
      if prvzznr=1
         if zenttn=zenpr
            skip
            loop
         endif
         kfr=kfttn
         zenr=zen
      else
         kfr=kf
         zenr=ozen
      endif
      mntovr=mntov
      ktlr=ktl
      kger=getfield('t1','sklr,ktlr','tov','kge')
      if int(mntovr/10000)<2
         sele pr2
         skip
         loop
      endif
      gr1r =dtoc(dnn_r)  // Дата
      if prvzznr=0
         gr2r='     возврат      '
      else
         gr2r='     изм цены     '
      endif
      sele ctov
      netseek('t1','mntovr')
      nat_r=nat
      if fieldpos('ukt')#0
         ukt_r=ukt
      else
         ukt_r=space(10)
      endif
      sele pr2
      if getfield('t1','int(ktlr/1000000)','sgrp','mark')=1.and.kger#0
         natr=alltrim(getfield('t1','kger','grpe','nge'))+' '+alltrim(nat_r)
      else
         natr=nat_r
      endif
      natr=padr(natr,50)
      if empty(ukt_r)
         gr3r=subs(natr,1,50)
      else
         gr3r=subs(natr,1,39)+' '+ukt_r
      endif
*      gr3r =subs(getfield('t1','mntovr','ctov','nat'),1,50)  // Наименование
      gr4r =getfield('t1','mntovr','ctov','nei')   // Ед изм.
      if prvzznr=0
         gr5r =str(-kfr,10,3)   // Изм кол-ва
         gr6r =str(zenr,10,3)  // Цена поставки
         gr7r =space(10)  // Изм цены
         gr8r =space(10)  // Кол-во поставки
         gr9=ROUND(-kfr*zenr,2)
      else
         gr5r =space(10)  // Изм кол-ва
         gr6r =space(10)  // Цена поставки
         gr7r =str(-zenr,10,3)  // Изм цены
         gr8r =str(kfr,10,3)   // Кол-во поставки
         gr9=ROUND(-kfr*zenr,2)
      endif
      sgr9=sgr9+gr9
      gr9r=str(gr9,10,2)
      gr10r=space(10)  // 0%
      gr11r=space(10)  // Освобожденнные от НДС

      sele tdoc
      netadd()
      netrepl('gr1,gr2,gr3,gr4,gr5,gr6,gr7,gr8,gr9,gr10,gr11,rzd',;
      'gr1r,gr2r,gr3r,gr4r,gr5r,gr6r,gr7r,gr8r,gr9r,gr10r,gr11r,1')
      sele pr2
      skip
  enddo
endif

sele tdoc
inde on str(rzd,2)+str(nn,2) tag t1
* Печать
do case
   case vlptr=1
        set prin to lpt1
   case vlptr=2
        set prin to lpt2
   case vlptr=3
        set prin to lpt3
   case vlptr=4
        set prin to nds.txt
endc
set cons off
set prin on
??sprnr
for kk=1 to kkr
    nlstr=1 // N листа
    store 0 to hd1r,hd2r,irowr // Счетчики шапок
    if nlstr=1
       hdndsp()
    endif
    hdndsp1()
    sele tdoc
    go top
    do while !eof()
       if rzd#1
          skip
          loop
       endif
       listr='│'+gr1+'│'+gr2+'│'+gr3+'│'+gr4+'│'+gr5+'│'+gr6+'│'+gr7;
        +'│'+gr8+'│'+gr9+'│'+gr10+'│'+gr11+'│'
       ?listr
       lste(3)
       sele tdoc
       skip
    endd
    ftndsp()
next
set prin off
set cons on
set prin to
retu .t.
**************
func rsbnds()
**************
retu .t.
**************
func prbnds()
**************
retu .t.

**************
func hdndsr()
**************
?str(ttnr,6)+space(134)+'Лист '+str(nlstr,2)
lste(1)
?''
lste(1)
?''
lste(1)
?''
lste(1)
?''
lste(1)
?'┌────────┬────────────────────┬─────┐'+space(85)+'ЗАТВЕРДЖЕНО'
lste(1)
?'│        │Видається покупцю   │  X  │'+space(77)+'Наказ Державної податкової'
lste(1)
?'│        ├────────────────────┼─────┤'+space(79)+'адмiнiстрацiї України'
lste(1)
?'│Оригiнал│Включено до ЄРПН    │     │'+space(82)+'21.12.2010 N969'
lste(1)
?'│        ├────────────────────┼─────┤'
lste(1)
?'│        │Залиш. у продавця   │     │'+space(10)+'П О Д А Т К О В А   Н А К Л А Д Н А'
lste(1)
?'│        │                    ├──┬──┤'
lste(1)
?'│        │(тип причини)       │  │  │'
lste(1)
?'├────────┴────────────────────┼──┴──┤'
lste(1)
?'│Копiя(залишається у продавця)│     │'
lste(1)
?'└─────────────────────────────┴─────┘'
lste(1)
?'Потрiбне вiдмiтити помiткою X'
lste(1)

?'                                       ┌─┬─┬─┬─┬─┬─┬─┬─┐                                             ┌─┬─┬─┬─┬─┬─┬─┐ ┌─┬─┬─┬─┐'
lste(1)
?'Дата виписки податкової накладної:     ' + rzdt(dnn_r) + '                           Порядковий номер  '+rznum(nnds_r,7)+'/'+rznum(0,4)
lste(1)
?'                                       └─┴─┴─┴─┴─┴─┴─┴─┘                                             └─┴─┴─┴─┴─┴─┴─┘ └─┴─┴─┴─┘'
lste(1)
?'                                                                                                                    (номер фiлiї)'
lste(1)

nn11r=iif(len(nai1r)>50,subs(nai1r,1,50),padr(nai1r,50))
if len(nai1r)>50
   nn12r=iif(len(subs(nai1r,51,50))>50,subs(nai1r,51,50),padr(subs(nai1r,51,50),50))
else
   nn12r=space(50)
endif
nn21r=iif(len(nai2r)>50,subs(nai2r,1,50),padr(nai2r,50))
if len(nai2r)>50
   nn22r=iif(len(subs(nai2r,51,50))>50,subs(nai2r,51,50),padr(subs(nai2r,51,50),50))
else
   nn22r=space(50)
endif
?space(21)+'┌──────────────────────────────────────────────────┐'+space(30)+'┌──────────────────────────────────────────────────┐'
lste(1)
?'Особа (платник       │'+nn11r+'│'+space(10)+'Особа (платник      │'+nn21r+'│'
lste(1)
?'податку) - продавець │'+nn12r+'│'+space(10)+'податку) - покупець │'+nn22r+'│'
lste(1)
?space(21)+'└──────────────────────────────────────────────────┘'+space(30)+'└──────────────────────────────────────────────────┘'
lste(1)
?space(21)+'  (найменування; прiзвище, iм"я, по батьковi - для '+space(32)+' (найменування;прiзвище,iм"я,по батьковi, - для    '
lste(1)
?space(21)+'            фiзичної особи - пiдприємця)           '+space(32)+'            фiзичної особи - пiдприємця)           '
lste(1)

?'┌─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┐'+space(58)+'┌─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┐'
lste(1)
?rznum(nn1r,12) +space(58)+iif(empty(cnn2r),rznum(nn2r,12),rzchr(cnn2r,12,0))
lste(1)
?'└─┴─┴─┴─┴─┴─┴─┴─┴─┴─┴─┴─┘'+space(58)+'└─┴─┴─┴─┴─┴─┴─┴─┴─┴─┴─┴─┘'
lste(1)

adr11r=iif(len(adr1r)>30,subs(adr1r,1,30),padr(adr1r,30))
if len(adr1r)>30
   adr12r=iif(len(subs(adr1r,31,30))>30,subs(adr1r,31,30),padr(subs(adr1r,31,30),30))
else
   adr12r=space(30)
endif
adr21r=iif(len(adr2r)>40,subs(adr2r,1,40),padr(adr2r,40))
if len(adr2r)>40
   adr22r=iif(len(subs(adr2r,41,40))>40,subs(adr2r,41,40),padr(subs(adr2r,41,40),40))
else
   adr22r=space(40)
endif
?'Мiсцезнаходження           '+adr11r+space(26)+'Мiсцезнаходження          '+adr21r
lste(1)
?'(податкова ареса) продавця '+adr12r+space(26)+'(податкова ареса) покупця '+adr22r
lste(1)

tt1r=strtran(alltrim(tlf1r),'-')
tt2r=strtran(alltrim(tlf2r),'-')
?space(16)+'┌─┬─┬─┬─┬─┬─┬─┬─┬─┬─┐'+space(46)+space(16)+'┌─┬─┬─┬─┬─┬─┬─┬─┬─┬─┐'
lste(1)
?'Номер телефону: ' + rzchr(tt1r,10,0)+space(46)+'Номер телефону: ' + rzchr(tt2r,10,0)
lste(1)
?space(16)+'└─┴─┴─┴─┴─┴─┴─┴─┴─┴─┘'+space(46)+space(16)+'└─┴─┴─┴─┴─┴─┴─┴─┴─┴─┘'
lste(1)

?'Номер свiдоцтва про          '+'┌─┬─┬─┬─┬─┬─┬─┬─┬─┬─┐'+space(33)+'Номер свiдоцтва про         '+'┌─┬─┬─┬─┬─┬─┬─┬─┬─┬─┐'
lste(1)
?'реєстрацiю платника податку  '+rzchr(alltrim(nsv1r),10,0)+space(33)+'реєстрацiю платника податку '+rzchr(alltrim(nsv2r),10,0)
lste(1)
?'на додану вартiсть(продавця) '+'└─┴─┴─┴─┴─┴─┴─┴─┴─┴─┘'+space(33)+'на додану вартiсть(покупця) '+'└─┴─┴─┴─┴─┴─┴─┴─┴─┴─┘'
lste(1)

dd_r=getfield('t1','kklr','klndog','dtdogb')
if prmk17r=0
   cndogr=alltrim(getfield('t1','kklr','klndog','cndog'))
   if empty(cndogr)
      cndogr=alltrim(str(getfield('t1','kklr','klndog','ndog'),6))
   endif
else
   cndogr='383/КО/11-ПН'
endif
if kklr=2401764
   ?space(80)+'┌─┬─┬─┬─┬─┬─┬─┬─┐'+space(3)+'┌─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┐'
   lste(1)
   ?'Вид цивiльно-правового договору:договiр про реалiзацiю продуктiв харчування '+'вiд '+rzdt(dd_r)+' N '+rzchr(cndogr,12,0)  //+' '+str(kplr,7)
   lste(1)
   ?space(80)+'└─┴─┴─┴─┴─┴─┴─┴─┘'+space(3)+'└─┴─┴─┴─┴─┴─┴─┴─┴─┴─┴─┴─┘'
   lste(1)
else
   ?space(53)+'┌─┬─┬─┬─┬─┬─┬─┬─┐'+space(3)+'┌─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┐'
   lste(1)
   ?'Вид цивiльно-правового договору:договiр поставки '+'вiд '+rzdt(dd_r)+' N '+rzchr(cndogr,12,0)  //+' '+str(kplr,7)
   lste(1)
   ?space(53)+'└─┴─┴─┴─┴─┴─┴─┴─┘'+space(3)+'└─┴─┴─┴─┴─┴─┴─┴─┴─┴─┴─┴─┘'
   lste(1)
endif

?'Форма проведених разрахункiв: ' + iif(fopr=0,'р/р',getfield('t1','fopr','fop','nfop'))
lste(1)
?'                              '+repl('─',120)
lste(1)
?'                                 (бартер, готiвка, оплата з поточного рахунку, чек тощо)'
lste(1)
retu .t.

**************
func hdndsr1()
**************
if nlstr#1
   ?space(140)+'Лист '+str(nlstr,2)
   lste(2)
endif
?'┌───┬──────────┬──────────────────────────────────────────────────┬─────┬──────────┬──────────┬─────────────────────────────────────────────┬────────────┐'
lste(2)
?'│ Р │   Дата   │          Номенклатура постачання товарiв/        │Один.│ Кiлькiсть│   Цiна   │    Обсяг постачання(база оподаткування)     │  Загальна  │'
lste(2)
?'│ О │вiдвантаж.│                 послуг продавця                  │ вим.│(об"ем,   │постачання│      без урахування ПДВ,що пiдлягають       │сума коштiв │'
lste(2)
?'│ З │(виконання│                                                  │това-│ обсяг)   │одиницi   │          оподаткуванню за ставками          │що пiдлягає │'
lste(2)
?'│ Д │постачання│                                                  │ру   │          │товару/   ├────────────┬──────────┬──────────┬──────────┤  сплатi    │'
lste(2)
?'│ I │(оплати*) │                                                  │     │          │послуг без│     20%    │0%(постач.│    0%    │звiльнення│            │'
lste(2)
?'│ Л │товарiв   │                                                  │     │          │урахування│            │на митн.  │(експорт )│вiд ПДВ** │            │'
lste(2)
?'│   │(послуг)  │                                                  │     │          │   ПДВ    │            │тер Укр)  │          │          │            │'
lste(2)
?'├───┼──────────┼──────────────────────────────────────────────────┼─────┼──────────┼──────────┼────────────┼──────────┼──────────┼──────────┼────────────┤'
lste(2)
?'│ 1 │    2     │                          3                       │  4  │     5    │     6    │      7     │     8    │     9    │    10    │     11     │'
lste(2)
?'├───┼──────────┼──────────────────────────────────────────────────┼─────┼──────────┼──────────┼────────────┼──────────┼──────────┼──────────┼────────────┤'
lste(2)
?'│ I │          │                                                  │     │          │          │            │          │          │          │            │'
lste(2)
retu .t.

**************
func ftndsr()
**************
?'├───┼─────────────────────────────────────────────────────────────┼─────┼──────────┼──────────┼────────────┼──────────┼──────────┼──────────┼────────────┤'
lste(4)
?'│   │ УСЬОГО ПО РОЗДIЛУ I                                         │  X  │     X    │     X    │'+str(sm10r,12,2)+'│          │          │          │'+Str(sm10r,12,2)+'│'
lste(4)
?'├───┼─────────────────────────────────────────────────────────────┼─────┼──────────┼──────────┼────────────┼──────────┼──────────┼──────────┼────────────┤'
lste(4)
?'│ II│ Зворотня(заставна) тара                                     │  X  │     X    │     X    │     X      │     X    │     X    │     X    │'+Str(sm19r,12,2)+'│'
lste(4)
?'├───┼─────────────────────────────────────────────────────────────┼─────┼──────────┼──────────┼────────────┼──────────┼──────────┼──────────┼────────────┤'
lste(2)
?'│III│ Податок на додану вартiсть                                  │  X  │     X    │     X    │'+str(sm11r+sm12r,12,2)+'│          │          │          │'+Str(sm11r+sm12r,12,2)+'│'
lste(4)
?'├───┼─────────────────────────────────────────────────────────────┼─────┼──────────┼──────────┼────────────┼──────────┼──────────┼──────────┼────────────┤'
lste(2)
?'│ IV│ Загальна сума з ПДВ                                         │  X  │     X    │     X    │'+str(sm90r-sm19r,12,2)+'│          │          │          │'+Str(sm90r,12,2)+'│'
lste(4)
?'└───┴─────────────────────────────────────────────────────────────┴─────┴──────────┴──────────┴────────────┴──────────┴──────────┴──────────┴────────────┘'
lste(4)

?'Суми ПДВ, нарахованi(сплаченi) в зв"язку з постачанням товарiв/послуг,зазначених у цiй накладнiй, визначенi правильно,'
lste(4)
?'вiдповiдають сумi податкових зобов"язань продавця i включенi до реєстру виданих та отриманих податкових накладних.'
lste(4)

?''
lste(4)
?''
lste(4)
?'                                                                               ___________________________________________/'+gcName
lste(4)
?'                                                                               Пiдпис i прiзвище особи, яка склала податкову накладну'
lste(4)
?'----------------------------------------------------------------------------------------------------------------------------------------------------------'
lste(4)

?'* Дата оплати ставиться у разi попередньоi оплати постачання, на яку виписуеться податкова накладна, для операцiй з поставки товарiв/послуг вiдповiдно до'
lste(4)
?'пункту 187.10 статтi 187 роздiлу V Податкового кодексу України'
lste(4)
?'**(вiдповiднi пункти(пiдпункти),статтi,пiдроздiли,роздiли Податкового кодексу України,якими передбачено звiльнення вiд оподаткування )'
lste(4)
eject
retu .t.
**************
func hdndsp()
**************
?str(ndr,6)+space(140)+'Лист '+str(nlstr,2)
lste(1)
?'┌────────┬────────────────────┬─────┐'+space(95)+'Додаток 2'
lste(1)
?'│        │Видається покупцю   │  X  │'+space(95)+'до Податкової накладної'
lste(1)
?'│        ├────────────────────┼─────┤'
lste(1)
?'│Оригiнал│Включено до ЄРПН    │     │'
lste(1)
?'│        ├────────────────────┼─────┤'
lste(1)
?'│        │Залиш. у продавця   │     │'
lste(1)
?'│        │                    ├──┬──┤'
lste(1)
?'│        │(тип причини)       │  │  │'
lste(1)
?'├────────┴────────────────────┼──┴──┤'
lste(1)
?'│Копiя(залишається у продавця)│     │'
lste(1)
?'└─────────────────────────────┴─────┘'
lste(1)
?'Потрiбне вiдмiтити помiткою X'
lste(1)

?space(30)+space(25)+'┌─┬─┬─┬─┬─┬─┬─┬─┬─┬─┐ ┌─┬─┬─┬─┐'
lste(1)
?space(30)+'Р О З Р А Х У Н О К    N '+rznum(nnds_r,10)+'/'+rznum(0,4)
lste(1)
?space(30)+space(25)+'└─┴─┴─┴─┴─┴─┴─┴─┴─┴─┘ └─┴─┴─┴─┘'
lste(1)
?space(20)+'коригування кiлькiстних i вартiсних показникiв до податкової накладної'
lste(1)

dd_r=getfield('t1','kklr','klndog','dtdogb')
cndogr=alltrim(getfield('t1','kklr','klndog','cndog'))
if empty(cndogr)
   cndogr=alltrim(str(getfield('t1','kklr','klndog','ndog'),6))
endif

?space(23)+'┌─┬─┬─┬─┬─┬─┬─┬─┐'+space(3)+'┌─┬─┬─┬─┬─┬─┬─┬─┬─┬─┐'+space(18)+'┌─┬─┬─┬─┬─┬─┬─┬─┐'+space(3)+'┌─┬─┬─┬─┬─┬─┐'
lste(1)
?space(19)+'вiд '+rzdt(dnn1_r)+' N '+rznum(nnds1_r,10)+' за договором вiд '+rzdt(dd_r)+' N '+rzchr(cndogr,6,0)
lste(1)
?space(23)+'└─┴─┴─┴─┴─┴─┴─┴─┘'+space(3)+'└─┴─┴─┴─┴─┴─┴─┴─┴─┴─┘'+space(18)+'└─┴─┴─┴─┴─┴─┴─┴─┘'+space(3)+'└─┴─┴─┴─┴─┴─┘'
lste(1)

nn11r=iif(len(nai1r)>50,subs(nai1r,1,50),padr(nai1r,50))
if len(nai1r)>50
   nn12r=iif(len(subs(nai1r,51,50))>50,subs(nai1r,51,50),padr(subs(nai1r,51,50),50))
else
   nn12r=space(50)
endif
nn21r=iif(len(nai2r)>50,subs(nai2r,1,50),padr(nai2r,50))
if len(nai2r)>50
   nn22r=iif(len(subs(nai2r,51,50))>50,subs(nai2r,51,50),padr(subs(nai2r,51,50),50))
else
   nn22r=space(50)
endif
?space(21)+'┌──────────────────────────────────────────────────┐'+space(30)+'┌──────────────────────────────────────────────────┐'
lste(1)
?'Особа (платник       │'+nn11r+'│'+space(10)+'Особа (платник      │'+nn21r+'│'
lste(1)
?'податку) - продавець │'+nn12r+'│'+space(10)+'податку) - покупець │'+nn22r+'│'
lste(1)
?space(21)+'└──────────────────────────────────────────────────┘'+space(30)+'└──────────────────────────────────────────────────┘'
lste(1)
?space(21)+'  (найменування; прiзвище, iм"я, по батьковi - для '+space(32)+' (найменування;прiзвище,iм"я,по батьковi, - для    '
lste(1)
?space(21)+'            фiзичної особи - пiдприємця)           '+space(32)+'            фiзичної особи - пiдприємця)           '
lste(1)

?'┌─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┐'+space(58)+'┌─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┐'
lste(1)
?rznum(nn1r,12) +space(58)+iif(empty(cnn2r),rznum(nn2r,12),rzchr(cnn2r,12,0))
lste(1)
?'└─┴─┴─┴─┴─┴─┴─┴─┴─┴─┴─┴─┘'+space(58)+'└─┴─┴─┴─┴─┴─┴─┴─┴─┴─┴─┴─┘'
lste(1)

adr11r=iif(len(adr1r)>30,subs(adr1r,1,30),padr(adr1r,30))
if len(adr1r)>30
   adr12r=iif(len(subs(adr1r,31,30))>30,subs(adr1r,31,30),padr(subs(adr1r,31,30),30))
else
   adr12r=space(30)
endif
adr21r=iif(len(adr2r)>40,subs(adr2r,1,40),padr(adr2r,40))
if len(adr2r)>40
   adr22r=iif(len(subs(adr2r,41,40))>40,subs(adr2r,41,40),padr(subs(adr2r,41,40),40))
else
   adr22r=space(40)
endif
?'Мiсцезнаходження           '+adr11r+space(26)+'Мiсцезнаходження          '+adr21r
lste(1)
?'(податкова ареса) продавця '+adr12r+space(26)+'(податкова ареса) покупця '+adr22r
lste(1)

tt1r=strtran(alltrim(tlf1r),'-')
tt2r=strtran(alltrim(tlf2r),'-')
?space(16)+'┌─┬─┬─┬─┬─┬─┬─┬─┬─┬─┐'+space(46)+space(16)+'┌─┬─┬─┬─┬─┬─┬─┬─┬─┬─┐'
lste(1)
?'Номер телефону: ' + rzchr(tt1r,10,0)+space(46)+'Номер телефону: ' + rzchr(tt2r,10,0)
lste(1)
?space(16)+'└─┴─┴─┴─┴─┴─┴─┴─┴─┴─┘'+space(46)+space(16)+'└─┴─┴─┴─┴─┴─┴─┴─┴─┴─┘'
lste(1)

?'Номер свiдоцтва про          '+'┌─┬─┬─┬─┬─┬─┬─┬─┬─┬─┐'+space(33)+'Номер свiдоцтва про         '+'┌─┬─┬─┬─┬─┬─┬─┬─┬─┬─┐'
lste(1)
?'реєстрацiю платника податку  '+rzchr(alltrim(nsv1r),10,0)+space(33)+'реєстрацiю платника податку '+rzchr(alltrim(nsv2r),10,0)
lste(1)
?'на додану вартiсть(продавця) '+'└─┴─┴─┴─┴─┴─┴─┴─┴─┴─┘'+space(33)+'на додану вартiсть(покупця) '+'└─┴─┴─┴─┴─┴─┴─┴─┴─┴─┘'
lste(1)

dd_r=getfield('t1','kklr','klndog','dtdogb')
cndogr=alltrim(getfield('t1','kklr','klndog','cndog'))
if empty(cndogr)
   cndogr=alltrim(str(getfield('t1','kklr','klndog','ndog'),6))
endif
?space(53)+'┌─┬─┬─┬─┬─┬─┬─┬─┐'+space(3)+'┌─┬─┬─┬─┬─┬─┐'
lste(1)
?'Вид цивiльно-правового договору:договiр поставки '+'вiд '+rzdt(dd_r)+' N '+rzchr(cndogr,6,0)  //+' '+str(kplr,7)
lste(1)
?space(53)+'└─┴─┴─┴─┴─┴─┴─┴─┘'+space(3)+'└─┴─┴─┴─┴─┴─┘'
lste(1)

dd_r=ctod('')
?space(12)+'┌─┬─┬─┬─┬─┬─┬─┬─┐'
lste(1)
?'Дата оплати '+rzdt(dd_r)
lste(1)
?space(12)+'└─┴─┴─┴─┴─┴─┴─┴─┘'
lste(1)

?'Форма проведених разрахункiв: ' + iif(fopr=0,'р/р',getfield('t1','fopr','fop','nfop'))
lste(1)
*?'                              '+repl('─',120)
*lste(1)
*?'                                 (бартер, готiвка, оплата з поточного рахунку, чек тощо)'
*lste(1)
retu .t.
**************
func hdndsp1()
**************
?'┌──────────┬──────────────────┬──────────────────────────────────────────────────┬─────┬─────────────────────┬─────────────────────┬────────────────────────────────┐'
lste(2)
?'│   Дата   │    Причина       │   Номенклатура товарiв/послуг, вартiсть чи       │Один.│Коригування кiлькостi│ Коригування вартостi│ Пiдлягають коригуванню обсяги  │'
lste(2)
?'│коригуван │   коригування    │          кiлькiсть яких коригуеться              │ вим.├──────────┬──────────┼──────────┬──────────┤     без урахування ПДВ,що      │'
lste(2)
?'│          │                  │                                                  │     │   Змiна  │   Цiна   │  Змiна   │ Кiлькiсть│  оподатковуються за ставками   │'
lste(2)
?'│          │                  │                                                  │     │ кiлькоcтi│постачання│   цiни   │постачання├──────────┬──────────┬──────────┤'
lste(2)
?'│          │                  │                                                  │     │об"ем,обся│тов/посл  │ (-) (+)  │тов/посл  │    20%   │     0%   │звiльнення│'
lste(2)
?'│          │                  │                                                  │     │  (-) (+) │          │          │          │  (-) (+) │  (-) (+) │вiд ПДВ с5│'
lste(2)
?'├──────────┼──────────────────┼──────────────────────────────────────────────────┼─────┼──────────┼──────────┼──────────┼──────────┼──────────┼──────────┼──────────┤'
lste(2)
?'│    1     │        2         │                          3                       │  4  │     5    │     6    │     7    │     8    │     9    │    10    │    11    │'
lste(2)
?'├──────────┼──────────────────┼──────────────────────────────────────────────────┼─────┼──────────┼──────────┼──────────┼──────────┼──────────┼──────────┼──────────┤'
lste(2)
*?'│          │                  │                                                  │     │          │          │          │          │          │          │          │'
*lste(2)
retu .t.
**************
func ftndsp()
**************
sgr1r ='Усього    '  // space(10)   // Дата
sgr2r =space(18)  // Причина
sgr3r =space(50)  // Наименование
sgr4r =space(5)   // Ед изм.
sgr5r =space(10)  // Изм.кол-ва (корр.кол-ва)
sgr6r =space(10)  // Изм.цены   (корр.кол-ва)
sgr7r =space(10)  // Изм.цены   (корр.стоимости)
sgr8r =space(10)  // Изм.кол-ва (корр.стоимости)
sgr9r =str(sgr9,10,2)  // 20%
sgr10r=space(10)  //  0%
sgr11r=space(10)  // ст.5
sgr12r=str(sgr9*20/100,10,2)  // ст.5
*?'│'+sgr1r+'│'+sgr2r+'│'+sgr3r+'│'+sgr4r+'│'+sgr5r+'│'+sgr6r+'│'+sgr7r;
*     +'│'+sgr8r+'│'+sgr9r+'│'+sgr10r+'│'+sgr11r+'│'
?'├──────────┴──────────────────┴──────────────────────────────────────────────────┴─────┴──────────┴──────────┴──────────┴──────────┼──────────┼──────────┼──────────┤'
lste(4)
?'│Усього                                                                                                                            │'+sgr9r+'│'+'          '+'│'+'          '+'│'
lste(4)
?'├──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┼──────────┼──────────┼──────────┤'
lste(4)
?'│Сума коригування податкового забов"язання та податкового кредиту                                                                  │'+sgr12r+'│'+'    X     '+'│'+'    X     '+'│'
lste(4)
?'└──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┴──────────┴──────────┴──────────┘'
lste(4)

?'Суми ПДВ,якi скоригованi у зв"язку зi змiною кiлькiсних чи вартiсних показникiв,що зазначенi в цьому розрахунку,визначенi правильно,включенi'
lste(4)
?'вiдповiдно до податкового забов"язання з одночасним вiдображенням у реестрi отриманих та виданих податкових накладних.'
lste(4)
?''
lste(4)
?'                                                            _____________________________________________________________'
lste(4)
?'                                                          (дата,пiдпис i прiзвище особи,яка склала розрахунок коригування)'
lste(4)
?'Розрахунок коригування вiд_________________________N______до податковоi накладноi вiд____________________N_________отримав i зобов"язуюся'
lste(4)
?'включити суми коригування до реєстру виданих та отриманих податкових накладних та сум податкового кредиту i податкового зобов"язання '
lste(4)
? ''
lste(4)
?''
lste(4)
?'                                                            _____________________________________________________________'
lste(4)
?'                                                                     (дата отримання розрахунку,пiдпис покупця)'
lste(4)
?'  '
eject
retu .t.
************
func lste(p1)
* 1 head1
* 2 head2
* 3 det
* 4 foot
************
irowr=irowr+1
if irowr=nrowr // Конец листа
   do case
      case p1=1
      case p1=2
      case p1=3
           irowr=0
           nlstr=nlstr+1
           eject
           if nlstr#1
              if mnp_r=0
                 ?space(140)+'Лист '+str(nlstr,2)
              else
                 ?str(ndr,6)+space(140)+'Лист '+str(nlstr,2)
              endif
              lste(4)
           endif
           if mnp_r=0
              hdndsr1()
           else
              hdndsp1()
           endif
      case p1=4
           irowr=0
           nlstr=nlstr+1
           eject
           if nlstr#1
              if mnp_r=0
                 ?space(140)+'Лист '+str(nlstr,2)
              else
                 ?str(ndr,6)+space(140)+'Лист '+str(nlstr,2)
              endif
              lste(4)
           endif
   endc
endif
retu .t.

**************
func ndsrskt()
**************
sele rs1
ttnr=ttn

store 0 to sgr9
sele rs2
set orde to tag t3
if netseek('t3','ttnr')
   do while ttn=ttnr
*      kfr=kf
      kfr=kvp
      zenr=bzenp
      zenpr=zenp
      bzenr=bzen
      mntovr=mntov
      ktlr=ktl
      kger=getfield('t1','sklr,ktlr','tov','kge')
      if int(mntovr/10000)<2
         sele rs2
         skip
         loop
      endif

      gr1r =dtoc(dnn_r)  // Дата
      sele ctov
      netseek('t1','mntovr')
      nat_r=nat
      if fieldpos('ukt')#0
         ukt_r=ukt
      else
         ukt_r=space(10)
      endif
      sele rs2
      if getfield('t1','int(ktlr/1000000)','sgrp','mark')=1.and.kger#0
         natr=alltrim(getfield('t1','kger','grpe','nge'))+' '+alltrim(nat_r)
      else
         natr=nat_r
      endif
      natr=padr(natr,50)
      if empty(ukt_r)
         gr3r=subs(natr,1,50)
      else
         gr3r=subs(natr,1,39)+' '+ukt_r
      endif
*      gr3r =subs(getfield('t1','mntovr','ctov','nat'),1,50)  // Наименование
      gr4r =getfield('t1','mntovr','ctov','nei')   // Ед изм.
      if kopr=137
         gr2r='цiна              '
         gr5r =str(0,10,3)   // Изм кол-ва
         gr6r =str(0,10,3)  // Цена поставки
         gr7r =str(-bzenr,10,3)  // Изм цены
         gr8r =str(kfr,10,3)   // Кол-во поставки
      else
         gr2r='кiлькiсть         '
         gr5r =str(-kfr,10,3)   // Изм кол-ва
         gr6r =str(zenpr,10,3)  // Цена поставки
         gr7r =str(0,10,3)  // Изм цены
         gr8r =str(0,10,3)   // Кол-во поставки
      endif
      gr9=ROUND(-kfr*bzenr,2)

      sgr9=sgr9+gr9
      gr9r=str(gr9,10,2)
      gr10r=space(10)  // 0%
      gr11r=space(10)  // Освобожденнные от НДС

      sele tdoc
      netadd()
      netrepl('gr1,gr2,gr3,gr4,gr5,gr6,gr7,gr8,gr9,gr10,gr11,rzd',;
      'gr1r,gr2r,gr3r,gr4r,gr5r,gr6r,gr7r,gr8r,gr9r,gr10r,gr11r,1')
      sele rs2
      skip
  enddo
endif

sele tdoc
inde on str(rzd,2)+str(nn,2) tag t1

* Печать
do case
   case vlptr=1
        set prin to lpt1
   case vlptr=2
        set prin to lpt2
   case vlptr=3
        set prin to lpt3
   case vlptr=4
        set prin to nds.txt
endc
set cons off
set prin on
??sprnr
for kk=1 to kkr
    nlstr=1 // N листа
    store 0 to hd1r,hd2r,irowr // Счетчики шапок
    if nlstr=1
       hdndsp()
    endif
    hdndsp1()
    sele tdoc
    go top
    do while !eof()
       if rzd#1
          skip
          loop
       endif
       listr='│'+gr1+'│'+gr2+'│'+gr3+'│'+gr4+'│'+gr5+'│'+gr6+'│'+gr7;
        +'│'+gr8+'│'+gr9+'│'+gr10+'│'+gr11+'│'
       ?listr
       lste(3)
       sele tdoc
       skip
    endd
    ftndsp()
next
set prin off
set cons on
set prin to
retu .t. 
