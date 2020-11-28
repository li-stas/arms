Local Sfr,Sfr1,Trn,Sum_s,Sum_n,Sum_t,Sum_nds,Sum_all,Srt_kl,Sum_tl
priv pspch  // признак сетевой печати
pspch=0
erase rs21.dbf
erase rs21.cdx
erase rs21.idx
erase rs211.dbf
erase rs211.cdx
erase rs211.idx
erase rs31.dbf
erase rs31.cdx
erase rs31.idx

nlstrr=1
kk=1
kkr=1
vlpt1='lpt1'
vpr=1
lshr=0
@ 24,0  Say space(80)
@ 24,1       Prompt ' ПЕЧАТЬ '
@ 24,col()+1 Prompt ' СЕТ. ПЕЧАТЬ '
@ 24,col()+1 prompt ' ФАЙЛ '
@ 24,col()+1 Prompt ' ВЫХОД '

Menu To Men1
*set devi to prin
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
           ??chr(27)+'E'+chr(27)+'&l1h25a0O'+chr(27)+'&l5C'+chr(27)+'(3R'+chr(27)+'(s0p29.00h0s1b4102T'+chr(27)  && Книжная А5
        endif
   Case Men1 = 2.and.gnSpech=1  && Сетевая печать
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
 //        ??chr(27)+'E'+chr(27)+'&l1h25a1O'+chr(27)+chr(27)+'(3R'+chr(27)+'(s0p20.00h0s1b4102T'+chr(27)  && Книжная А4
        ??chr(27)+'E'+chr(27)+'&l4h25a0O'+chr(27)+'&l5C'+chr(27)+'(3R'+chr(27)+'(s0p29.00h0s1b4102T'+chr(27)  && Книжная А5
   Case Men1 = 3  && Файл
        set print to ndsv.txt
        set prin on
        if empty(gcPrn)
           ??chr(27)+chr(77)+chr(15)
        else
 //           ??chr(27)+'E'+chr(27)+'&l1h25a1O'+chr(27)+chr(27)+'(3R'+chr(27)+'(s0p20.00h0s0b4099T'+chr(27)  && Книжная А4
           ??chr(27)+'E'+chr(27)+'&l1h25a0O'+chr(27)+'&l5C'+chr(27)+'(3R'+chr(27)+'(s0p29.00h0s1b4102T'+chr(27)  && Книжная А4
        endif
   Case Men1 = 4  && Выход
        retu
EndCase

set cons on

Stri = 1
store 0 to Sfr,Sfr1,Trn,Sum_S,Sum_n,Sum_t,Sum_nds,Sum_tl
*Str_kl = 63
*Str_kl = 108
Str_kl = 114

*@ Prow(),1 Say Upri          // Установка шрифта принтера

netuse('dclr')

ars2:={}

aadd(ars2,{'sk','n',3,0})
aadd(ars2,{'skl','n',7,0})
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
aadd(ars2,{'vo','n',2,0})
aadd(ars2,{'nds','n',1,0})
aadd(ars2,{'zen','n',15,3})
aadd(ars2,{'fop','n',1,0})

dbcreate('rs21',ars2)

ars3={}

aadd(ars3,{'sk','n',3,0})
aadd(ars3,{'ttn','n',6,0})
aadd(ars3,{'ksz','n',2,0})
aadd(ars3,{'ssf','n',15,2})
aadd(ars3,{'nds','n',1,0})
aadd(ars3,{'nz','c',30,0})
aadd(ars3,{'pr','n',1,0})

dbcreate('rs31',ars3)

sele 0
use rs21 excl
inde on str(sk,3)+str(ttnr,6) to rs21

sele 0
use rs31 excl
inde on str(ksz,2)+str(nds,1) to rs31

sk_r=0
sdvr=0

netuse('cskl')

for i=1 to len(arab)
    ttnr=arab[i,1]
    skr=arab[i,2]
    do case
       case prnnr=1   && Под товар
            if skr#sk_r.and.gnPnds=1
               sele cskl
               seek str(skr,3)
               Pathr=gcPath_d+alltrim(path)
               if select('rs1')#0
                  sele rs1
                  use
               endif
               if select('rs2')#0
                  sele rs2
                  use
               endif
               if select('rs3')#0
                  sele rs3
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
               netuse('rs1',,'s',1)
               netuse('rs2',,'s',1)
               netuse('rs3',,'s',1)
               netuse('tov',,'s',1)
               netuse('soper',,'s',1)
               sk_r=skr
            else
               ndsr=p_nds
            endif
            sele rs1
            seek str(ttnr,6)
            sklr=skl
            kopr=kop
*            dotr=dot
            dotr=dop
            dopr=dop
            vor=vo
            pstr=pst
            if fieldpos('fop')#0
               fopr=fop
            else
               fopr=0
            endif
            sele fop
            if fopr=0
               go top
            else
               locate for fop=fopr
            endif
            rcfopr=recn()
            do while .t.
               rcfopr=slcf('fop',,,,,"e:fop h:'Код' c:n(2) e:nfop h:'Наименование' c:c(20)")
               if lastkey()=K_ESC
                  exit
               endif
               if lastkey()=K_ENTER
                  go rcfopr
                  fopr=fop
                  exit
               endif
            endd
            sele rs1
            if fieldpos('fop')#0
               if gnArm=3
                  netrepl('fop','fopr',1)
               else
                  netrepl('fop','fopr')
               endif
            endif
            vur=int(kop/100)
            sele soper
            seek str(0,1)+str(vur,1)+str(vor,2)+str(mod(kopr,100),2)
            nopr=alltrim(nop)
            rndsr=nds
            kszrr=12
            if getfield('t1','ttnr,kszrr','rs3','ssf')#0
               tararr=0
            else
               tararr=1
            endif
            sele rs2
            set orde to tag t1
            if !netseek('t1','ttnr')
               seek str(ttnr,6)
            endif
            do while ttn=ttnr.and.!eof()
               kvpr=kvp
               svpr=svp
               srr=sr
               zenr=zen
               if int(ktl/1000000)=0.and.tararr=1
                  skip
                  loop
               endif
               if int(ktl/1000000)=1.and.tararr=1.and.pstr=0
                  skip
                  loop
               endif
               ktlr=ktl
               sele tov
               netseek('t1','sklr,ktlr')
               natr=nat
               neir=nei
               sele rs21
               appe blank
               repl sk with skr,ttn with ttnr,dot with dotr,ktl with ktlr,;
               nat with natr,nei with neir,kop with kopr,nop with nopr,;
               vu with vur,vo with vor,skl with sklr,nds with rndsr,;
               kvp with kvpr,svp with svpr,sr with srr,zen with zenr,fop with fopr
               sele rs2
               skip
            enddo
            sele rs3
            seek str(ttnr,6)
            ssfr18=0
            do while ttn=ttnr.and.!eof()
               kszr=ksz
               nzr=space(20)
               prr=1
               sele dclr
               if netseek('t1','kszr')
                  nzr=str(kz,2)+' '+nz
                  prr=pr
               endif
               sele rs3
               if kszr=18
                  ssfr18=ssf
               endif
               ssfr=ssf
               sele rs31
               seek str(kszr,2)+str(rndsr,1)
               if !FOUND()
                  appe blank
                  repl sk with skr,ttn with ttnr,ksz with kszr,ssf with ssfr,;
                  nds with rndsr,nz with nzr,pr with prr
               else
                  repl ssf with ssf+ssfr
               endif
               sele rs3
               skip
            endd
            if ssfr18<>0.and.tararr=1
               sele rs31
               if pstr=1
                  seek str(10,2)
                  if eof()
                     seek str(18,2)
                     repl ksz with 10
                  else
                     repl ssf with (ssf+ssfr18)
                  endif
               else
                  seek str(19,2)
                  if eof()
                     seek str(18,2)
                     repl ksz with 19
                  else
                     repl ssf with (ssf+ssfr18)
                  endif
               endif
            endif
       case prnnr=2          && Под деньги
            sele nds
            netseek('t1','nomndsr')
            korktlr=korktl
            if korktlr=0
               korktlr=1
            endif
            sele tovn
            locate for ktl=korktlr
            ktlr=ktl
            natr=nat
            neir=nei
            zenr=zen
            tararr=1
            svpr=sumkr-ROUND(sumkr/6,2)
            kvpr=svpr/zenr
            sele rs21
            appe blank
            repl sk with 0,ttn with ttnr,dot with gdTd,ktl with ktlr,;
                 nat with natr,nei with neir,kop with kopr,nop with nopr,;
                 vu with vur,vo with vor,skl with sklr,nds with rndsr,;
                 kvp with kvpr,svp with svpr,sr with srr,zen with zenr
            sele rs31
            appe blank
                    repl ksz with 10,ssf with svpr,nds with rndsr,sk with skr,ttn with ttnr,nz with 'Товар     '
            appe blank
            repl ksz with 11,ssf with ROUND(sumkr/6,2),nds with rndsr,sk with skr,ttn with ttnr,nz with 'НДС       '
            appe blank
            repl ksz with 90,ssf with sumkr,nds with rndsr,sk with skr,ttn with ttnr,nz with 'Всего     '
    endc
next
if gnPnds=1.and.gnArm#2
   if select('rs1')#0
      sele rs1
      use
   endif
   if select('rs2')#0
      sele rs2
      use
   endif
   if select('rs3')#0
      sele rs3
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
a=0
c=0
for i=1 to len(arab)
    if arab[i,3]#arab[i,4]
       c=i
       loop
    else
       a=i
       exit
    endif
next
b=len(arab)

if ttnr=0.and.prnnr=1
   c=1
endif

set cons off
if c=0 && Коррекции нет
   private attt[b,5]
   acopy(arab,attt)
   save scree to scmess
   set devi to scre
   mess('ВНИМАНИЕ!!! Печать на стандартном листе',2)


   if pspch=2
      set print to &vlpt1
      set print on
      ??chr(27)+'E'+chr(27)+'&l1h25a0O'+chr(27)+'&l3C'+chr(27)+'(3R'+chr(27)+'(s0p29.00h0s1b4102T'+chr(27)  && Книжная А5
   endif
   if pspch=0 &&.and.gnVttn=1
      if gnOut=2.or.men1=3
         set print to nds.txt
      else
         set print to lpt1
      endif
      set print on
      if empty(gcPrn)
         ??chr(27)+chr(77)+chr(15)
      else
*        ??chr(27)+'E'+chr(27)+'&l1h25a0O'+chr(27)+chr(27)+'(3R'+chr(27)+'(s0p29.00h0s1b4099T'+chr(27)  && Книжная А4
        ??chr(27)+'E'+chr(27)+'&l1h25a0O'+chr(27)+'&l5C'+chr(27)+'(3R'+chr(27)+'(s0p29.00h0s1b4102T'+chr(27)  && Книжная А4
      endif
   endif
   set devi to prin
   rest scre from scmess
   do while kkr<=kk
      pnnt()
      kkr=kkr+1
   enddo
else   && Есть коррекция
   if gnOut=2
      set print to ndsc.txt
   endif
   private acor[c,5]
   acopy(arab,acor,c)
   for i=1 to len(acor)
       acor[i,4]=acor[i,4]-ROUND(acor[i,4]/6,2)
   next
   save scree to scmess
   set devi to scree
   mess('ВНИМАНИЕ!!! Печать на стандартном листе поперек',2)
   if pspch=2
      set print to &vlpt1
      set print on
*      ??chr(27)+'E'+chr(27)+'&l1h25a1O'+chr(27)+chr(27)+'(3R'+chr(27)+'(s0p29.00h0s1b4102T'+chr(27)  && Книжная А4
      ??chr(27)+'E'+chr(27)+'&l4h25a0O'+chr(27)+'&l5C'+chr(27)+'(3R'+chr(27)+'(s0p29.00h0s1b4102T'+chr(27)  && Книжная А4
   endif
   if pspch=0 &&.and.gnVttn=1
      if gnOut=2.or.men1=3
         set print to nds.txt
      else
         set print to lpt1
      endif
      set print on
      if empty(gcPrn)
         ??chr(27)+chr(77)+chr(15)
      else
*         ??chr(27)+'E'+chr(27)+'&l1h25a1O'+chr(27)+chr(27)+'(3R'+chr(27)+'(s0p20.00h0s0b4099T'+chr(27)  && Книжная А4
*         ??chr(27)+'E'+chr(27)+'&l1h25a1O'+chr(27)+chr(27)+'(3R'+chr(27)+'(s0p29.00h0s1b4102T'+chr(27)  && Книжная А4
         ??chr(27)+'E'+chr(27)+'&l1h25a0O'+chr(27)+'&l5C'+chr(27)+'(3R'+chr(27)+'(s0p29.00h0s1b4102T'+chr(27)  && Книжная А4
      endif
   endif

   set devi to prin
   rest scre from scmess
   do while kkr<=kk
      pnnc()
      eject
      kkr=kkr+1
   enddo
   private attt[b-c,5]
   acopy(arab,attt,a)
   if len(attt)#0
   save scree to scmess
   set devi to scree
   mess('ВНИМАНИЕ!!! Печать на стандартном листе',2)
   if pspch=2
      set print to &vlpt1
      set print on
      ??chr(27)+'E'+chr(27)+'&l1h25a0O'+chr(27)+chr(27)+'(3R'+chr(27)+'(s0p20.00h0s1b4102T'+chr(27)  && Книжная А4
   endif
   set devi to prin
   rest scre from scmess
      do while kkr<=kk
         pnnt()
         kkr=kkr+1
      enddo
   endif
endi

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

erase rs21.idx
erase rs211.idx
erase rs31.idx

/*
set print off
set print to
Set Device To Screen
*/
ClosePrintFile()

*****************************************************************
func pnnt() && Печать НН без коррекции
*****************************************************************


*str_kl= 61 &&  63
*str_kl= 108 &&  63
Str_kl = 114


if dopr>=ctod('10.01.2011')
   head11()
   head22()
else
   HEAD1()
   HEAD2()
endif

**************************************************************
if dopr>=ctod('10.01.2011').and.gnEnt=21
SELECT RS31
go top
store 0 to trn,sum_s,sum_n,sum_nds,sum_t,sum_all,sumttnr,sfr
Do While !Eof()
   ttnr=ttn
   skr=sk
   a=0
   for i=1 to len(attt)
      if attt[i,1]=ttnr.and.attt[i,2]=skr
         a=1
         exit
      endif
   next
   if a=0
      skip
      loop
   endif
   do case
      case KSZ = 61.or.ksz=46.or.ksz=48.or.ksz=62.and.ssf>0.or.ksz=40.and.ssf>0
           do case
              case nds=1
                   trn=trn+ssf-ROUND(ssf/6,2)
              case nds=4
                   trn=trn+ssf-ROUND(ssf/6,3)
           othe
              trn=trn+ssf
           endc
      case (KSZ =62.or.ksz=40).and.ssf<0  //Скидка Лодис на документ
           do case
              case nds=1
                   sum_s=sum_s+abs(ssf-ROUND(ssf/6,2))
              case nds=4
                   sum_s=sum_s+abs(ssf-ROUND(ssf/6,3))
           othe
              sum_s=sum_s+abs(ssf)
           endc
*           do case
*              case nds=1
*                   sum_s=sum_s+(ssf-ROUND(ssf/6,2))
*              case nds=4
*                   sum_s=sum_s+(ssf-ROUND(ssf/6,3))
*           othe
*              sum_s=sum_s+ssf
*           endc
   Endc

   Skip
EndDo
endif
********************************************************************
sele rs21
inde on dtoc(dot)+nat to rs211
go top

store space(2) to sgr1r
store space(8) to sgr2r
store space(50) to sgr3r
store space(5)  to sgr4r
store space(10) to sgr5r,sgr6r,sgr7r,sgr8r,sgr9r,sgr10r,sgr11r
slistr=sgr1r+'|УСЬОГО ПО РОЗДIЛУ I                                         |';
+sgr4r+'|'+sgr5r+'|'+sgr6r+'|'+sgr7r+'|'+sgr8r+'|'+sgr9r+'|'+sgr10r+'|'+sgr11r+'|'
store 0 to sgr5,sgr6,sgr7,sgr8,sgr9,sgr10,sgr11

do while !eof()
   ttnr=ttn
   skr=sk
   a=0
   for i=1 to len(attt)
      if attt[i,1]=ttnr.and.attt[i,2]=skr
         a=1
         exit
      endif
   next
   if a=0
      skip
      loop
   endif
   gr1r =space(2)   && Раздел
   gr2r =space(10)   && Дата
   gr3r =space(50)  && Наименование
   gr4r =space(5)   && Ед изм.
   gr5r =space(10)  && Кол-во
   gr6r =space(10)  && Цена без НДС
   gr7r =space(12)  && 20%
   gr8r =space(10)  &&  0%
   gr9r =space(10)  &&  0% экспорт
   gr10r=space(10)  && ст.5
   gr11r=space(12)  && Общая сумма

   store 0 to gr6,gr7,gr10

   gr2r=dtoc(dot)
   gr3r=subs(nat,1,50)
   gr4r=nei
   gr5r=str(kvp,10,3)
   do case
      case nds=5.or.nds=0
           gr6=zen
           gr7=svp
*           gr7=ROUND(kvp*gr6,2)
           sgr7=sgr7+gr7
      case nds=1
           gr6=ROUND(ZEN-ZEN/6,3)
           gr7=ROUND(svp-svp/6,3)
*           gr7=ROUND(kvp*(ZEN-ZEN/6),2)
           sgr7=sgr7+gr7
      case nds=2
           gr6=zen
*           gr7=svp
            gr10=svp
*           gr7=ROUND(kvp*gr6,2)
*           sgr7=sgr7+gr7
            sgr10=sgr10+gr10
*           gr8=ROUND(gr6*kvp,2)
*           sgr8=sgr8+gr8
      case nds=3
           gr6=zen
           gr7=svp-sr
           sgr7=sgr7+gr7
           gr10=sr
           sgr10=sgr10+gr10
      case nds=4
           gr6=zen-ROUND((svp-sr)/(6*kvp),3)
           gr7=(svp-sr)-ROUND((svp-sr)/6,3)
           sgr7=sgr7+gr7
           gr10=sr
           sgr10=sgr10+gr10
   endc

   if gr6#0
      gr6r=str(gr6,10,3)
   endif
   if gr7#0
      gr7r=str(gr7,12,3)
   endif
   if gr10#0
      gr10r=str(gr10,10,3)
   endif

*   if sgr6#0
*      sgr6r=str(sgr6,10,3)
*   endif
   if sgr7#0
      sgr7r=str(sgr7,12,3)
   endif
   if sgr10#0
      sgr10r=str(sgr10,10,3)
   endif
   sgr11r=str(sgr7+sgr10,12,3)

   if len(arab)#1
      gr2r=dtoc(dot)
   endif

   listr='│'+gr1r+'│'+gr2r+'│'+gr3r+'│'+gr4r+'│'+gr5r+'│'+gr6r+'│'+gr7r;
   +'│'+gr8r+'│'+gr9r+'│'+gr10r+'│'+gr11r+'│'
   @ Prow()+1,1 Say listr
   Stri ++
   lstend(1,1)
   sele rs21
   skip
endd
if dopr>=ctod('10.01.2011').and.gnEnt=21
   if rndsr=2
   else
       S26 ='│  │'+gr2r+'│'+'Товаро-транспортнi витрати                        │посл.│     1.000│'+Str(Trn,10,3)+'│'+Str(Trn,12,3)+'│          │          │          │            │'
       S28 ='│  │'+gr2r+'│'+' Надано покупцю: │ знижка   (-)                   │посл.│     1.000│'+Str(-Sum_s,10,3)+'│'+Str(-Sum_s,12,3)+'│          │          │          │            │'
   endif
   if trn#0
      @ Prow()+1,1 Say s26
      Stri ++
      lstend(1,1)
   endif
   if sum_s#0
      @ Prow()+1,1 Say s28
      Stri ++
      lstend(1,1)
   endif
   sgr7r=str(sgr7+trn-sum_s,12,3)
   sgr11r=str(sgr7+sgr10+trn-sum_s,12,3)
endif
S24  ='├──┼──────────┴──────────────────────────────────────────────────┼─────┼──────────┼──────────┼────────────┼──────────┼──────────┼──────────┼────────────┤'
if dopr>=ctod('10.01.2011')
   sgr4r='  X  '
   store '     X    ' to sgr5r,sgr6r
endif
slistr='│'+sgr1r+'│УСЬОГО ПО РОЗДIЛУ I                                          │'+sgr4r+'│';
+sgr5r+'│'+sgr6r+'│'+sgr7r+'│'+sgr8r+'│'+sgr9r+'│'+sgr10r+'│'+sgr11r+'│'
@ Prow()+1,1 Say S24
Stri ++
lstend(1,1)
@ Prow()+1,1 Say slistr
Stri ++
lstend(1,1)

**lshr=31
*lshr=42
*If Stri >= Str_kl - lshr
*      eject
*   if pspch<>2
*      BEEPER()
**      EJECT
*      Set Device To Screen
*      @ 24,0 Say space(80)
*      @ 24,1 Say 'Вставте следующий лист и нажмите ENTER'
*      Inkey(0)
*      @ 20,5 Say '                                      '
*      Set Device To Print
*   endif
*   Stri = 1
*EndIf

SELECT RS31
go top
store 0 to trn,sum_s,sum_n,sum_nds,sum_t,sum_all,sumttnr,sfr
Do While !Eof()
   ttnr=ttn
   skr=sk
   a=0
   for i=1 to len(attt)
      if attt[i,1]=ttnr.and.attt[i,2]=skr
         a=1
         exit
      endif
   next
   if a=0
      skip
      loop
   endif
   do case
      case KSZ = 61
           do case
              case nds=1
                   trn=trn+ssf-ROUND(ssf/6,2)
              case nds=4
                   trn=trn+ssf-ROUND(ssf/6,3)
           othe
              trn=trn+ssf
           endc
      case KSZ >=20 .And. KSZ <=39  //Скидка
           do case
              case nds=1
                   sum_s=sum_s+ssf-ROUND(ssf/6,2)
              case nds=4
                   sum_s=sum_s+ssf-ROUND(ssf/6,3)
           othe
              sum_s=sum_s+ssf
           endc
      case KSZ =62.and.gnEnt=21  //Скидка Лодис на документ
           do case
              case nds=1
                   sum_s=sum_s+abs(ssf-ROUND(ssf/6,2))
              case nds=4
                   sum_s=sum_s+abs(ssf-ROUND(ssf/6,3))
           othe
              sum_s=sum_s+abs(ssf)
           endc
      case KSZ >=40 .And. KSZ <=80 .And. KSZ <> 61  //Наценка
           do case
              case nds=1
                   sum_n=sum_n+ssf-ROUND(ssf/6,2)
              case nds=4
                   sum_n=sum_n+ssf-ROUND(ssf/6,3)
           othe
              sum_n=sum_n+ssf
           endc
      case KSZ = 11 .Or. KSZ = 12
           Sum_nds =sum_nds+ SSF
      case KSZ = 19
              Sum_t = sum_t+SSF
      case KSZ = 90
           Sum_all =sum_all+ SSF
   Endc

   Skip
EndDo


If Tararr = 1
   Sfr   = Sum_all-Sum_nds-Sum_t
Else
   sum_t = 0
   Sfr   = Sum_all-Sum_nds
EndIf

if dopr>=ctod('10.01.2011')
   foot11()
else
   foot1()
endif
retu

*********************************************************************
func pnnc() && Печать коррекции
*********************************************************************

str_kl=43

netuse('tovn')

sele rs21
*inde on dtoc(dot)+nat to rs211
go top
for i=1 to len(acor)
    store space(10)  to gr1r
    store space(18) to gr2r
    store space(50) to gr3r
    store space(5)  to gr4r
    store space(10) to gr5r,gr6r,gr7r,gr8r,gr9r,gr10r,gr11r,gr12r,;
                       gr13r,gr14r,gr15r
    store 0 to gr6,gr9,gr10,gr11,gr12,gr14,sgr9,sgr12,sgr14,sgr13,sgr15
    ttnr=acor[i,1]
    skr =acor[i,2]
    if !empty(acor[i,5])
       gr1r=dtoc(acor[i,5])
    endif
    HEAD3()
    HEAD4()

    sele nds
    set order to tag t1
    seek str(ndsdr,10)
    korktlr=korktl
    if korktlr=0
       korktlr=1
    endif
    sele tovn
    locate for ktl=korktlr
    ktlr=ktl
    natr=nat
    if len(natr)#50
       natr=natr+space(50-len(natr))
    endif
    neir=nei
    zenr=zen
    sdvr=acor[i,4]

    sele rs21

    gr3r=natr
    gr4r=neir
    gr5=ROUND(-sdvr/zenr,3)
    gr6=zenr
    gr9=-sdvr

    store 0 to gr12,gr14,gr13,gr15

    if gr9<0
       gr12=ROUND(gr9*20/100,3)
       gr13=gr12
    endif
    if gr9>0
       gr14=ROUND(gr9*20/100,3)
       gr15=gr14
    endif

    gr5r=str(-sdvr/zenr,10,3)

    gr6r=str(gr6,10,3)

    if gr9#0
       gr9r=str(gr9,10,2)
    endif
    if gr12#0
       gr12r=str(gr12,10,3)
       gr13r=str(gr13,10,3)
    endif
    if gr14#0
       gr14r=str(gr14,10,3)
       gr15r=str(gr15,10,3)
    endif
    listr='|'+gr1r+'|'+gr2r+'|'+gr3r+'|'+gr4r+'|'+gr5r+'|'+gr6r+'|'+gr7r;
    +'|'+gr8r+'|'+gr9r+'|'+gr10r+'|'+gr11r+'|'+gr12r+'|'+gr13r+'|'+gr14r;
    +'|'+gr15r+'|'

    @ Prow()+1,1 Say listr
    Stri ++
    lstend(2,1)

    sele rs21
    seek str(skr,3)+str(ttnr,6)

    sgr9=gr9
    sgr12=gr12
    sgr14=gr14
    sgr13=gr13
    sgr15=gr15

    do while sk=skr.and.ttn=ttnr.and.!eof()


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
       gr3r=subs(nat,1,50)
       gr4r=nei
       gr5r=str(kvp,10,3)

       store 0 to gr6,gr9,gr10,gr11,gr12,gr14,gr13,gr15

       do case
          case nds=5.or.nds=0
               gr6=zen
               gr9=ROUND(kvp*gr6,2)
          case nds=1
               gr6=Round(ZEN-ZEN/6,3)
               gr9=ROUND(kvp*gr6,2)
          case nds=2
               gr6=zen
               gr10=ROUND(gr6*kvp,3)
          case nds=3
               gr6=zen
               gr9=svp-sr
               gr11=sr
          case nds=4
               gr6=zen-ROUND((svp-sr)/6*kvp,3)
               gr9=(svp-sr)-ROUND((svp-sr)/6,2)
       endc
       sgr9=sgr9+gr9
       gr5=kvp

       if gr9<0
          gr12=-ROUND(gr9*20/100,3)
          gr13=-ROUND(gr9*20/100,3)
       endif
       if gr9>0
          gr14=ROUND(gr9*20/100,3)
          gr15=ROUND(gr9*20/100,3)
       endif

       sgr12=sgr12+gr12
       sgr14=sgr14+gr14
       sgr13=sgr13+gr13
       sgr15=sgr15+gr15

       gr6r=str(gr6,10,3)
       if gr9#0
          gr9r=str(gr9,10,2)
       endif
       if gr11#0
          gr11r=str(gr11,10,3)
       endif
       if gr12#0
          gr12r=str(gr12,10,3)
          gr13r=str(gr13,10,3)
       endif
       if gr14#0
          gr14r=str(gr14,10,3)
          gr15r=str(gr15,10,3)
       endif

       listr='|'+gr1r+'|'+gr2r+'|'+gr3r+'|'+gr4r+'|'+gr5r+'|'+gr6r+'|'+gr7r;
       +'|'+gr8r+'|'+gr9r+'|'+gr10r+'|'+gr11r+'|'+gr12r+'|'+gr13r+'|'+gr14r;
       +'|'+gr15r+'|'

       @ Prow()+1,1 Say listr
       Stri ++
       lstend(2,1)
       sele rs21
       skip
   endd

   sele rs31
   go top

*   seek str(skr,3)+str(ttnr,6)
*   sgr9=gr9
*   sgr12=gr12
*   sgr14=gr14

    do while !eof()  &&sk=skr.and.ttn=ttnr
       if pr=1
          skip
          loop
       endif
       if ksz=12 .or. ssf=0
          skip
          loop
       endif
       gr1r =space(10)   && Дата
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

       store 0 to gr9,gr12,gr14,gr13,gr15

*       gr1r=dtoc(dot)
       gr3r=nz
       if len(gr3r)#50
          gr3r=gr3r+space(50-len(gr3r))
       endif
*       gr4r=nei
*       gr5r=str(kvp,10,3)
        gr9=ssf
        gr9r=str(ssf,10,2)
*        if ssf<0
*           gr12=ROUND(ssf*.2,3)
*           gr12r=str(gr12,10,3)
*        else
          * if ksz#12
              gr14=ROUND(ssf*.2,3)
              gr15=ROUND(ssf*.2,3)
          * else
          *    gr14=ROUND(0*.2,3)
          * endif
              gr14r=str(gr14,10,3)
              gr15r=str(gr15,10,3)
*        endif
       sgr9=sgr9+gr9
       sgr12=sgr12+gr12
       sgr13=sgr13+gr13
       sgr14=sgr14+gr14
       sgr15=sgr15+gr15
       listr='|'+gr1r+'|'+gr2r+'|'+gr3r+'|'+gr4r+'|'+gr5r+'|'+gr6r+'|'+gr7r;
       +'|'+gr8r+'|'+gr9r+'|'+gr10r+'|'+gr11r+'|'+gr12r+'|'+gr13r+'|'+gr14r;
       +'|'+gr15r+'|'

       @ Prow()+1,1 Say listr
       Stri ++
       lstend(2,1)
       sele rs31
       skip
   endd
   @ prow()+1,1 say '---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------'
   Stri ++
   foot2()
   lstend(2,2)
next

retu

***************************************************************
func lstend(p1,p2)
local aaa
if p2=1
   aaa=str_kl
else
   aaa=str_kl-lshr && 19
endif
If Stri = aaa
   if p2=1
      @ Prow()+1,1 Say ' '
      @ Prow()+1,40 Say 'Продовження на другiй сторонi бланку'
   endif
   if pspch=2
      eject
   else
      BEEPER()
      EJECT
      Set Device To Screen
      @ 24,0 Say space(80)
      @ 24,1 Say 'Вставте следующий лист и нажмите ENTER'
      Inkey(0)
      @ 20,5 Say '                                      '
      Set Device To Print
   endif
   Stri = 1
   if p2=1
      if p1=1
         nlstrr++
         if dopr>=ctod('10.01.2011')
            head55()
         else
            HEAD5()
         endif
      else
      endif
   endif
EndIf
retu

If Stri >= Str_kl - lshr &&19
  if pspch=2
     eject
  else
   BEEPER()
   EJECT
   Set Device To Screen
   @ 24,0 Say space(80)
   @ 24,1 Say 'Вставте следующий лист и нажмите ENTER'
   Inkey(0)
   @ 20,5 Say '                                      '
   Set Device To Print
  endif
   Stri = 1
EndIf


