Local Sfr,Sfr1,Trn,Sum_s,Sum_n,Sum_t,Sum_nds,Sum_all,Srt_kl,Sum_tl
priv pspch  && признак сетевой печати
if empty(gcPrn)
   upri=chr(27)+chr(77)+chr(15)
else
   upri=''   
endif
pspch=0
kk=1
kkr=1
vlpt1='lpt1'
lshr=31
@ 24,0  Say space(80)
@ 24,1       Prompt ' ПЕЧАТЬ '
@ 24,col()+1 Prompt ' СЕТ. ПЕЧАТЬ '
@ 24,col()+1 prompt ' ФАЙЛ '
@ 24,col()+1 Prompt ' ВЫХОД '
*set devi to prin
Menu To Men1
set cons off
do case
   Case Men1 = 1 && Локальная печать
        if !empty(gcPrn)
           kk=2
           @ 24,50 say 'Количество  экз.'
           @ 24,68 get kk pict '9' valid kk<4
           read
        endif
        set prin to lpt1
        set prin on
        if empty(gcPrn)
           ??chr(27)+chr(77)+chr(15)
        else
           ??chr(27)+'E'+chr(27)+'&l1h26a1O3C'+chr(27)+chr(27)+'(3R'+chr(27)+'(s0p20.00h0s0b4099T'+chr(27)  && Книжная А4
        endif
   Case Men1 = 2.and.(gnSpech=1.or.gnAdm=1)  && Сетевая печать
        alpt={'lpt2','lpt3'}
        vlpt=alert('ПЕЧАТЬ НА СЕТЕВОЙ ПРИНТЕР',alpt)
        if vlpt=1
           vlpt1='lpt2'
        else
           vlpt1='lpt3'
        endif
        pspch=2
        kk=2
        kkr=1 && Счетчик экземпляров
        @ 24,50 say 'Количество  экз.'
        @ 24,68 get kk pict '9' valid kk<4
        read
        set print to &vlpt1
        set prin on
*         ??chr(27)+'E'+chr(27)+'&l1h26a1O'+chr(27)+'&l3C'+chr(27)+'(3R'+chr(27)+'(s0p20.00h0s1b4102T'+chr(27)  && Альбом А4
*        ??chr(27)+'E'+chr(27)+'&l1h26a1O'+chr(27)+chr(27)+'(3R'+chr(27)+'(s0p20.00h0s1b4102T'+chr(27)  && Книжная А4
        ??chr(27)+'E'+chr(27)+'&l1h25a1O'+chr(27)+'&l3C'+chr(27)+'(3R'+chr(27)+'(s0p29.00h0s1b4102T'+chr(27)  && Книжная А5
   Case Men1 = 3  && Файл
        set print to nds.txt
        if empty(gcPrn)
           ??chr(27)+chr(77)+chr(15)
        else
           ??chr(27)+'E'+chr(27)+'&l1h26a1O3C'+chr(27)+chr(27)+'(3R'+chr(27)+'(s0p20.00h0s0b4099T'+chr(27)  && Книжная А4
        endif
   Case Men1 = 4  && Выход
        retu
EndCase

Stri = 1
store 0 to Sfr,Sfr1,Trn,Sum_S,Sum_n,Sum_t,Sum_nds,Sum_tl
Str_kl = 43  &&  45 &&63

netuse('dclr')

ars2:={}

aadd(ars2,{'sk','n',3,0})
aadd(ars2,{'skl','n',4,0})
aadd(ars2,{'ttn','n',6,0})
aadd(ars2,{'ktl','n',9,0})
aadd(ars2,{'nat','c',60,0})
aadd(ars2,{'nei','c',5,0})
aadd(ars2,{'kvp','n',15,3})
aadd(ars2,{'svp','n',15,2})
aadd(ars2,{'sr','n',15,2})
aadd(ars2,{'kop','n',3,0})
aadd(ars2,{'nop','c',20,0})
aadd(ars2,{'dot','d',8,2})
aadd(ars2,{'vu','n',1,0})
aadd(ars2,{'vo','n',1,0})
aadd(ars2,{'nds','n',1,0})
aadd(ars2,{'zen','n',15,3})

dbcreate('rs21',ars2)

sele 0
use rs21 excl
inde on str(sk,3)+str(ttnr,6) tag rs21

sele cskl
seek str(skr,3)
Pathr=gcPath_d+alltrim(path)
if select('pr1')#0
   sele pr1
   use
endif
if select('pr2')#0
   sele pr2
   use
endif
if select('tov')#0
   sele tov
   use
endif
if select('soper')#0
   sele soper
   use
endif
*netuse('pr3',,'s',1)
*kszr=12
*if !netseek('t1','ttnr,kszr')
*  tarar=1
*else
*   tarar=0
*endif

netuse('pr1',,'s',1)
netuse('pr2',,'s',1)
netuse('tov',,'s',1)
netuse('soper',,'s',1)
sele pr1
set order to tag t2
seek str(ttnr,6)
sklr=skl
kopr=kop
dotr=dvp
vor=vo
pstr=pst
vur=int(kop/100)
sele soper
seek str(1,1)+str(vur,1)+str(vor,1)+str(mod(kopr,100),2)
nopr=alltrim(nop)
rndsr=nds
sele pr2
seek str(ttnr,6)
do while mn=ttnr
   if prvzznr=1
      if zenttn=zenpr
         skip
         loop   
      endif  
   endif
   if prvzznr=0
      kvpr=kf
      zenr=ozen
   else
      kvpr=kfttn
      zenr=zen
   endif   
   svpr=sf
   srr=sr
   ktlr=ktl
   sele tov
   netseek('t1','sklr,ktlr,')
   natr=nat
   neir=nei
   sele rs21
   appe blank
   repl sk with skr,ttn with ttnr,dot with dotr,ktl with ktlr,;
        nat with natr,nei with neir,kop with kopr,nop with nopr,;
        vu with vur,vo with vor,skl with sklr,nds with rndsr,;
        kvp with kvpr,svp with svpr,sr with srr,zen with zenr
   sele pr2
   skip
enddo
if gnPnds=1
   if select('pr1')#0
      sele pr1
      use
   endif
   if select('pr2')#0
      sele pr2
      use
   endif
   if select('tov')#0
      sele tov
      use
   endif
   if select('soper')#0
      sele soper
      use
   endif
endif
set devi to screen
wmess('ВНИМАНИЕ!!! Печать на стандартном листе поперек',2)
set devi to prin


do while kkr<=kk
   pnncv()
   eject
   kkr=kkr+1
enddo

set cons on

if select('rs21')#0
   sele rs21
   use
endif
if select('rs31')#0
   sele rs31
   use
endif

if file('rs21.dbf')
   erase rs21.dbf
endif
if file('rs21.cdx')
   erase rs21.cdx
endif
if file('rs211.cdx')
   erase rs211.cdx
endif

if file('rs31.dbf')
   erase rs31.dbf
endif
if file('rs31.cdx')
   erase rs31.cdx
endif

set print off
set print to
Set Device To Screen

*********************************************************************
func pnncv() && Печать коррекции
*********************************************************************

str_kl=43

netuse('tovn')

store 0 to gr6,gr9,gr10,gr11,gr12,gr14,sgr9,sgr12,sgr13
sele rs21
seek str(skr,3)+str(ttnr,6)
gr1r=dtoc(dot)
dtt=dot
if gnArm=2
   dvpr=dtt
endif

if bom(gdTd)<ctod('01.03.2011')
   if dvpr>=ctod('10.01.2011')
      head33()
      head44()
   else
      HEAD3()
      HEAD4()
   endif
else
      head33()
      head44()
endif   

sele rs21
do while sk=skr.and.ttn=ttnr
   gr1r =space(10)  && Дата
   gr2r =space(18)  && Причина
   gr3r =space(50)  && Наименование
   gr4r =space(5)   && Ед изм.
   gr5r =space(10)  && Изм.кол-ва (корр.кол-ва)
   gr6r =space(10)  && Изм.цены   (корр.кол-ва)
   gr7r =space(10)  && Изм.цены   (корр.стоимости)
   gr8r =space(10)  && Изм.кол-ва (корр.стоимости)
   gr9r =space(10)  && 20%
   gr10r=space(10)  &&  0%
   gr11r=space(10)  && ст.5
   gr12r=space(10)  && ум.обяз.(отр.гр.9)
   gr13r=space(10)  && ум.кред.(отр.гр.9)
   gr14r=space(10)  && ув.обяз.(пол.гр.9)
   gr15r=space(10)  && ув.кред.(пол.гр.9)
   gr1r=dtoc(dot)
   if prvzznr=0
      gr2r='     возврат      '
   else
      gr2r='     изм цены     '
   endif   
   gr3r=subs(nat,1,50)
   gr4r=nei
   
   if prvzznr=0
      gr5r=str(-kvp,10,3)
   endif
   
   gr8r=str(kvp,10,3) 
   
   store 0 to gr6,gr7,gr8,gr9,gr10,gr11,gr12,gr14

   if prvzznr=0 
      do case
         case nds=5.or.nds=0
              gr6=zen
              gr9=ROUND(-kvp*gr6,2)
       endc
    else
      do case
         case nds=5.or.nds=0
              gr7=-zen
              gr9=ROUND(kvp*gr7,2)
       endc
    endif   
    sgr9=sgr9+gr9
    
    if prvzznr=0
       gr5=kvp
    else
       gr5=0
    endif   
    
    if int(ktl/1000000)=0 .or.int(ktl/1000000)=1
       if (tarar=1 .and. int(ktl/1000000)=0) .or.(tarar=1 .and. int(ktl/1000000)=1 .and. pstr=0)
          gr12=0
          gr13=0
       endif
       if (tarar=0 .and. int(ktl/1000000)=0) .or.(tarar=1 .and. int(ktl/1000000)=1 .and. pstr=1) .or.(tarar=0 .and. int(ktl/1000000)=1 .and. pstr=1)
          gr12=ROUND(gr9*20/100,3)
          gr13=gr12
       endif
    else
       gr12=ROUND(gr9*20/100,3)
       gr13=gr12
    endif
    sgr12=sgr12+gr12
    sgr13=sgr12
    if gr6#0
       gr6r=str(gr6,10,3)
    endif
    if gr7#0   
       gr7r=str(gr7,10,3)
    endif   
    if gr9#0
       gr9r=str(gr9,10,2)
    endif
    if gr11#0
       gr11r=str(gr11,10,3)
    endif
    if gr12#0
       gr12r=str(gr12,10,3)
       gr13r=gr12r
    endif

if bom(gdTd)<ctod('01.03.2011')
   if dvpr>=ctod('10.01.2011')
       listr='|'+gr1r+'|'+gr2r+'|'+gr3r+'|'+gr4r+'|'+gr5r+'|'+gr6r+'|'+gr7r;
            +'|'+gr8r+'|'+gr9r+'|'+gr10r+'|'+gr11r+'|'
   else
       listr='|'+gr1r+'|'+gr2r+'|'+gr3r+'|'+gr4r+'|'+gr5r+'|'+gr6r+'|'+gr7r;
            +'|'+gr8r+'|'+gr9r+'|'+gr10r+'|'+gr11r+'|'+gr12r+'|'+gr13r+'|'+gr14r;
            +'|'+gr15r+'|'
   endif         
else
       listr='|'+gr1r+'|'+gr2r+'|'+gr3r+'|'+gr4r+'|'+gr5r+'|'+gr6r+'|'+gr7r;
            +'|'+gr8r+'|'+gr9r+'|'+gr10r+'|'+gr11r+'|'
endif   

    @ Prow()+1,1 Say listr
    Stri ++
    lstend(2,1)
    sele rs21
    skip
endd
if bom(gdTd)<ctod('01.03.2011')
   if dvpr>=ctod('10.01.2011')
      @ prow()+1,1 say '--------------------------------------------------------------------------------------------------------------------------------------------------------------------|'
   else
      @ prow()+1,1 say '---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------'
   endi   
else
      @ prow()+1,1 say '--------------------------------------------------------------------------------------------------------------------------------------------------------------------|'
endif   
Stri ++
if bom(gdTd)<ctod('01.03.2011')
   if dvpr>=ctod('10.01.2011')
      foot22()
   else
      foot2()
   endif
else
      foot22()
endif   
lstend(2,2)
retu



