#include "inkey.ch"
***************     Печать журнала-ордера       **************
men1=0

filedelete(gcPath_l+'\t'+'??????k.dbf')
filedelete(gcPath_l+'\t'+'??????d.dbf')

if file(gcPath_l+'\'+'vs_bs.dbf')
   erase (gcPath_l+'\'+'vs_bs.dbf')
endif
if file(gcPath_l+'\'+'vs_d.dbf')
   erase (gcPath_l+'\'+'vs_d.dbf')
endif
if file(gcPath_l+'\'+'vs_k.dbf')
   erase (gcPath_l+'\'+'vs_k.dbf')
endif
if file(gcPath_l+'\'+'fstru.dbf')
   erase (gcPath_l+'\'+'fstru.dbf')
endif
if file(gcPath_l+'\'+'fstrub.dbf')
   erase (gcPath_l+'\'+'fstrub.dbf')
endif
if file(gcPath_l+'\'+'vs_d.cdx')
   erase (gcPath_l+'\'+'vs_d.cdx')
endif
if file(gcPath_l+'\'+'vs_k.cdx')
   erase (gcPath_l+'\'+'vs_k.cdx')
endif
if file(gcPath_l+'\'+'vs_d1.cdx')
   erase (gcPath_l+'\'+'vs_d1.cdx')
endif
if file(gcPath_l+'\'+'vs_k1.cdx')
   erase (gcPath_l+'\'+'vs_k1.cdx')
endif

stor 0 to bsr,is_saldo_d,is_saldo_k,stro,lis,tek_saldo,sub_d,sub_k
declare chet_d[1116]
declare chet_k[1116]
declare name[70]
afill(chet_d,0)
afill(chet_k,0)
afill(name,'0')
netUse('doks') // 2
netUse('dokk') // 1
netUse('kln')  // 4
netUse('bs')   // 3
set color to g/n,n/g,,,
******************************************************************
sele 20
crea (gcPath_l+'\'+'fstru.dbf')
appe blank
repl field_name with 'mn',field_type with 'n',field_len with 6,field_dec with 0
appe blank
repl field_name with 'rnd',field_type with 'n',field_len with 6,field_dec with 0
appe blank
repl field_name with 'nplp',field_type with 'n',field_len with 6,field_dec with 0
appe blank
repl field_name with 'rn',field_type with 'n',field_len with 6,field_dec with 0
appe blank
repl field_name with 'ddk',field_type with 'd',field_len with 8,field_dec with 0
appe blank
repl field_name with 'bs_d',field_type with 'n',field_len with 6,field_dec with 0
appe blank
repl field_name with 'bs_k',field_type with 'n',field_len with 6,field_dec with 0
appe blank
repl field_name with 'bs_s',field_type with 'n',field_len with 13,field_dec with 2
appe blank
repl field_name with 'kkl',field_type with 'n',field_len with 7,field_dec with 0
use

crea (gcPath_l+'\'+'fstrub.dbf')
appe blank
repl field_name with 'bs',field_type with 'n',field_len with 6,field_dec with 0
use

sele 0
crea (gcPath_l+'\'+'vs_bs.dbf') from (gcPath_l+'\'+'fstrub.dbf')


*******************************************************************
stor 1 to dell
@ 0,0 clea
forma=1
@ MAXROW()-1,1 prom ' Полностью '
@ MAXROW()-1,col()+1 prom ' Итоги     '
menu to forma
do while .t.
   @ MAXROW()-1,0 clear to MAXROW()-1,79
   clear gets
   korsh=0
   @ MAXROW()-1,1 say 'Укажите корреспондирующий счет (если по всем нажмите "Enter") : ' get korsh picture '999999'
   read
   if korsh=0
      exit
   endif
   sele vs_bs
   netAdd()
   repl bs with korsh
enddo
sele vs_bs
go top
@ 0,0 clea
do while .t.
   @ 0,0 clea
   *показ справочника балансовых счетов
   @ MAXROW()-1,25 say 'Выберите счет : '
   bsr=0
   do whil .t.
      netuse('bs')
      @ MAXROW()-1,42 get bsr pict '999999'
      read
      if lastkey()=K_ESC
         nuse()
         sele vs_bs
         use
         erase vs_bs.dbf
         nuse()
         retu
      endi
      if bsr#0
         exit
      else
         bsr=slcf('bs',,,,,"e:bs h:'Счет' c:n(6) e:nbs h:'Наименование' c:c(20)",'bs')
      endi
      exit
   endd
   if bsr=0
      exit
   endi
   set color to r+/n,n/gr+,,,
   @ MAXROW()-1,0 clea
   if !netseek('t1','bsr')
      @ MAXROW()-1,20
      wait 'Баллансового счета с этим кодом нет! Нажмите любую клавишу...'
      @ MAXROW()-1,0 clear
      set color to g/n,n/g,,,
      loop
   endi
   sele vs_bs
   f=''
   f1='.or.'
   if reccount()#0
      do while .not.eof()
         f=f+'(bs_d=bsr.and.bs_k='+str(bs,6)+').or.(bs_d='+str(bs,6)+'.and.bs_k=bsr)'
         f=f+f1
         skip
      enddo
      kol=len(ltrim(trim(f)))
      f=substr(f,1,kol-4) +".and. !prc"
*      f=substr(f,1,kol-6)
      sele dokk
      set filter to &f
   else
      sele dokk
      set filter to !prc
   endi
   DBGOTOP()
   sele bs
   @ MAXROW(),2 say 'Счет: '+str(bsr,6)+' - '+nbs
   otch=obs
   stor dn to dn_r
   stor kn to kn_r
   set color to g/n,n/g,,,
   @ 1,55 say 'Ж/Ордер от '
   @ 2,55 say str(bsr,6)+' '+nbs
   @ 0,54,3,79  box frame
*   ddcr=ctod('01'+substr(dtoc(),3,6))
   ddcr=bom(gdTd) //gdTdn
   ddcr1=bom(gdTd) //gdTdn
   ddcr2=gdTd
   lis=1
   @ 1,66 say date()
   @ 2,2 say 'Укажите диапазон по дате : с '
   @ 2,33 get ddcr1
   @ 2,42 say ' по '
   @ 2,46 get ddcr2
   read
   @ 2,33 say ddcr1
   @ 2,46 say ddcr2

   lp=1
   @ MAXROW(),0  Say space(80)
   @ MAXROW(),1  Prompt ' ПЕЧАТЬ '
   @ MAXROW(),col()+1 Prompt ' ВЫХОД '
   @ MAXROW(),col()+1 Prompt ' СЕТ. ПЕЧАТЬ '
   @ MAXROW(),col()+1 prompt ' ФАЙЛ '

Menu To Men1
do case
   Case Men1 = 1
        lp=1
*        if gnEnt=14
*           lp=3
*        endif
        Set Device To Print
        set print to LPT1

   Case Men1 = 2
        Set Device To Screen
        retu
   Case Men1 = 3
        lp=2
        Set Device To Print
        set print to lpt2

   Case Men1 = 4
        Set Device To Print
        set print to order.txt
EndCase






*********************************************************************

   sele 0
   crea (gcPath_l+'\'+'vs_d.dbf') from (gcPath_l+'\'+'fstru.dbf')
*********************************************************************
   sele dokk
   set order to tag t2
   if substr(str(bsr,6),4,3)='000'
      netseek('t2','bsr',,'3')
*      logic='substr(str(bsr,6),1,3)'
   else
      logic='str(bsr,6)'
      netseek('t2','bsr')
   endi
*   if netseek('t2',&logic,,1)
   if found()
      do while .t.
         mash=mn
         rnr=rn
         rndr=rnd
         nplpr=nplp
         dt=ddk
         debet=bs_d
         kredit=bs_k
         sym=bs_s
         kklr=kkl
         sele vs_d
         netAdd()
         repl mn   with mash
         repl rn  with rnr
         repl rnd  with rndr
         repl nplp with nplpr
         repl kkl  with kklr
         repl ddk  with dt
         repl bs_d with debet
         repl bs_k with kredit
         repl bs_s with sym
         sele dokk
         skip
         if substr(str(bsr,6),4,3)='000'
            logic='substr(str(bs_d,6),1,3)#substr(str(bsr,6),1,3)'
         else
            logic='bs_d#bsr'
         endi
         if EOF().or.&logic
            exit
         endi
      endd
   endi
************************************************************************

   sele 0
   crea (gcPath_l+'\'+'vs_k.dbf') from (gcPath_l+'\'+'fstru.dbf')

************************************************************************
   sele dokk
   set order to tag t3
   if substr(str(bsr,6),4,3)='000'
      netseek('t3','bsr',,'3')
*      logic='substr(str(bsr,6),1,3)'
   else
      netseek('t3','bsr')
      logic='str(bsr,6)'
   endi
*   seek &logic
   if found()
      do while .t.
         mash=mn
         rnr=rn
         rndr=rnd
         nplpr=nplp
         dt=ddk
         debet=bs_d
         kredit=bs_k
         sym=bs_s
         kklr=kkl
         sele vs_k
         netAdd()
         repl mn   with mash
         repl rnd  with rndr
         repl nplp with nplpr
         repl rn  with rnr
         repl kkl  with kklr
         repl ddk  with dt
         repl bs_d with debet
         repl bs_k with kredit
         repl bs_s with sym
         sele dokk
         skip
         if substr(str(bsr,6),4,3)='000'
            logic='substr(str(bs_k,6),1,3)#substr(str(bsr,6),1,3)'
         else
            logic='bs_k#bsr'
         endi
         if EOF().or.&logic
            exit
         endi
      endd
   endi
   sele vs_d
   go top
   sym_d=0
*   datd=stuff(dtoc(ddcr1),1,5,'01/01')
*   datd=ctod(datd)
   datd=bom(ddcr1)
   do while .not.EOF()
      if ddk>=datd.and.ddk<ddcr1
         sym_d=sym_d+bs_s
      endi
      if ddk<ddcr1.or.ddk>ddcr2
         netdel()
      endi
      skip
   endd
*   pack
   sele vs_k
   go top
   sym_k=0
*   datd=stuff(dtoc(ddcr1),1,5,'01/01')
*   datd=ctod(datd)
   datd=bom(ddcr1)
   do while .not.EOF()
      if ddk>=datd.and.ddk<ddcr1
         sym_k=sym_k+bs_s
      endi
      if ddk<ddcr1.or.ddk>ddcr2
         netdel()
      endi
      skip
   endd
*   pack
   tek_saldo=(sym_d+dn_r)-(sym_k+kn_r)
****************************
   sele vs_d
   use
   use vs_d excl
   index on dtos(ddk) tag vs_d1
   sele vs_k
   use
   use vs_k excl
   index on dtos(ddk) tag vs_k1

**********************************
   sele vs_d
   go top
   dt1=ctod(' ')
   fi=1
   do while .not.EOF()
      dt=ddk
      re=recno()
      if dt#dt1
*         wait dtos(dt)+' '+dtos(dt1)
         dtt=dtoc(dt)
         d1=substr(dtt,1,2)
         d2=substr(dtt,4,2)
         d3=substr(dtt,7,2)
         dtt=gcPath_l+'\t'+d1+d2+d3+'D.dbf'
         erase &dtt
         name[fi]=dtt
         fi=fi+1
         copy to &dtt for ddk=dt
         dt1=dt
         go re
      endi
      skip
   endd
   sele vs_k
   go top
   dt1=ctod(' ')
   do while .not.EOF()
      dt=ddk
      re=recno()
      if dt#dt1
*         wait dtos(dt)+' '+dtos(dt1)
         dtt=dtoc(dt)
         d1=substr(dtt,1,2)
         d2=substr(dtt,4,2)
         d3=substr(dtt,7,2)
         dtt=gcPath_l+'\t'+d1+d2+d3+'K.dbf'
         erase &dtt
         name[fi]=dtt
         fi=fi+1
         copy to &dtt for ddk=dt
         dt1=dt
         go re
      endi
      skip
   endd
set devi to print
set console off
set print on
if lp=1
   if empty(gcPrn)
      ?chr(27)+chr(77)+chr(15)
   else
      ?chr(27)+'E'+chr(27)+'&l1h26a0O'+chr(27)+chr(27)+'(3R'+chr(27)+'(s0p21.00h0s0b4099T'+chr(27)  // Книжная А4
   endif
else
   ?chr(27)+'E'+chr(27)+'&l1h26a0O'+chr(27)+chr(27)+'(3R'+chr(27)+'(s0p21.00h0s0b4099T'+chr(27)  // Книжная А4
endif

   zag()
   osn()
   cons()
   fi=1
   do while fi<71
      if len(name[fi])>4
         erase (name[fi])
      endi
      fi=fi+1
   enddo
   exit
endd
sele 30
use
sele 31
use
if men1=4
   edfile('order.txt')
endif
nuse()
if select('vs_bs')#0
   sele vs_bs
   use
endif
erase vs_bs.dbf
retu


proc zag
stro=0
if !empty(gcPrn)
   ?chr(27)+'(s3b10.00h'+chr(27)  // Жирный
endif
?upper(gcNent)+' Журнал-ордер по счету: '+str(bsr,6)+'   на '+dtoc(ddcr2)+' г.                              Лист '+str(lis,3)
if !empty(gcPrn)
   ?chr(27)+'(s0b21.00h'+chr(27)  // Средний
endif
?'--------------------------------------------------------------------------------------------------------------------------------------------------------------------'
?'|                                       В   Е   Д   О   М   О   С   Т   Ь                            |         Ж   У   Р   Н   А   Л - О   Р   Д   Е   Р           |'
?'-----------------------------------------------------------------------------------------------------|-------------------------------------------------------------|'
?'|          |Номер |      |                                       |      В дебет счета:   '+str(bsr,6)+'      |       Кредит  счета:  '+str(bsr,6)+'      | Сальдо по счету: '+str(bsr,6)+' |'
?'|   Дата   |плат. |Номер |           Направление  средств        |-----------------------------------|-----------------------------------|-------------------------|'
?'|          |докум.|докум.|---------------------------------------|с кредита|            |  Итого по  | В дебет |            |  Итого по  |            |            |'
?'|          |      |      |  Код  |      Наименование             | счетов  |   Сумма    |    дебету  | счетов  |   Сумма    |   кредиту  |    Дебет   |   Кредит   |'
?'--------------------------------------------------------------------------------------------------------------------------------------------------------------------'
?' '
* 1      9      16     23      31                        57        67           80           93        103          116          129          142
stro=9
lis=lis+1
retu


proc osn
f=space(60)+'Входящее сальдо на '+dtoc(ddcr1)
if tek_saldo>0
   ts=space(43)+str(tek_saldo,15,2)
endi
if tek_saldo<0
   ts=space(56)+str(abs(tek_saldo),15,2)
endi
if tek_saldo=0
   ts=' '
endi
?f+ts
stro=stro+1
snova()
dd=ddcr1
is_saldo_d=0
is_saldo_k=0
do while .t.
   dt=dtoc(dd)
   d1=substr(dt,1,2)
   d2=substr(dt,4,2)
   d3=substr(dt,7,2)
   dt=d1+d2+d3
   dtd=gcPath_l+'\t'+dt+'D.DBF'
   a=0
   b=0
   c=0
   d=0
   prizn=1
   re=1
   rb=1
   prid=1
   prik=1
   s_po_shd=0
   s_po_shk=0
   shetd1=0
   shetk1=0
   td=0
   tk=0
   po_datd=0
   po_datk=0
   kol_dat=0
   syb_ch_d=0
   syb_ch_k=0
   sub_d1=-1
   sub_k1=-1
   td1=0
   tk1=0
   pri=0
   prii=0
   do while .t.
      if file(dtd).and.c=0
         debo()
         kol_dat=kol_dat+1
         if c=1.and.td>1.and.sub_d#0

            ?space(48)+'Итого по '+substr(str(sub_d+1000,4),2,3)+' субсчету : '+str(syb_ch_d,15,2)
            stro=stro+1
            snova()
         endi
         if c=1.and.td>1

            ?space(51)+'Итого по '+substr(str(shetd1+1000,4),2,3)+' счету : '+str(s_po_shd,15,2)
            stro=stro+1
            snova()
            s_po_shd=0
            td=0
         endi
      endi
      if .not.file(dtd).or.c=1
         a=1
      endi
      dtk=gcPath_l+'\t'+dt+'K.DBF'
      if file(dtk).and.d=0
         kred()
         kol_dat=kol_dat+1
         if d=1.and.tk>1.and.sub_k#0

            ?space(84)+'Итого по '+substr(str(sub_k+1000,4),2,3)+' субсчету : '+str(syb_ch_k,15,2)
            stro=stro+1
            snova()
         endi
         if d=1.and.tk>1

            ?space(87)+'Итого по '+substr(str(shetk1+1000,4),2,3)+' счету : '+str(s_po_shk,15,2)
            stro=stro+1
            snova()
            s_po_shk=0
            tk=0
         endi
      endi
      if .not.file(dtk).or.d=1
         b=1
      endi
      if (a=1.and.b=1).or.(c=1.and.d=1)
         if kol_dat>1
            r_podat=po_datd-po_datk
            stro=stro+1
            snova()
            ?'  Итого по дате : '
            ??space(66)+str(po_datd,15,2)+space(21)+str(po_datk,14,2)
            if r_podat>0
               ??str(r_podat,14,2)
            endi
            if r_podat<0
               ??space(12)+str(abs(r_podat),15,2)
            endi
         endi
         exit
      endi
   endd
   dd=dd+1
   if dd>ddcr2
      exit
   endi
endd

proc debo
sele 30
if prid=1
   use &dtd
   fill1=gcPath_l+'\'+'vs_d2'
   index on bs_k to &fill1
   set index to &fill1
   prid=0
endi
mash=mn
rndr=rnd
kklr=kkl
sele doks
*seek str(mash,6)+str(rndr,6)+str(kklr,7)
If netseek('t1','mash,rndr,kklr')
   kod = kkl
Else
   kod = kklr
EndIf
sele kln
If netseek('t1','kod')
   naz = subs(nkl,1,30)
Else
   naz = 'Клиента  нет  в  TKLNS02 !!!!!'
EndIf
sele 30
if nplp=0
   rn1=str(rn,6)
endif
if nplp#0
   rn1=str(nplp,6)
endif
if rnd=0
   rnd1=space(6)
endif
if rnd#0
   rnd1=str(rnd,6)
endif
f=0
if prizn=1
   if forma=1
      f=dtoc(ddk)+' '+rnd1+' '+rn1+' '+str(kod,7)+' '+naz
   else
      f=dtoc(ddk)
   endi
   prizn=0
else
   if forma=1
      f=space(11)+rnd1+' '+rn1+' '+str(kod,7)+' '+naz
   endi
endi
d0=ltrim(str(bs_k,6))
d1=substr(d0,1,3)
d2=substr(d0,4,3)
shetd=val(d1)
sub_d=val(d2)
If shetd = 0
   shetd = 1
EndIf
chet_d[shetd]=chet_d[shetd]+bs_s
if sub_d#sub_d1
   sd1=sub_d1
   sub_d1=sub_d
   if td1>1

      ?space(48)+'Итого по '+substr(str(sd1+1000,4),2,3)+' субсчету : '+str(syb_ch_d,15,2)
      stro=stro+1
      snova()
      prii=1
   endif
   td1=0
   syb_ch_d=0
endif
if sub_d#0.and.shetd=shetd1
   syb_ch_d=syb_ch_d+bs_s
   td1=td1+1
endif
if shetd#shetd1
   if prii=0.and.td1>1.and.td1#td

      ?space(48)+'Итого по '+substr(str(shetd1+1000,4),2,3)+' субсчету : '+str(syb_ch_d,15,2)
      stro=stro+1
      snova()
      prii=0
   endif
   syb_ch_d=0
   syb_ch_d=syb_ch_d+bs_s
   td1=0
   td1=td1+1
   if td>1
      ?space(51)+'Итого по '+substr(str(shetd1+1000,4),2,3)+' счету : '+str(s_po_shd,15,2)
      stro=stro+1
      snova()
   endi
   s_po_shd=0
   td=0
   shetd1=shetd
endi
s_po_shd=s_po_shd+bs_s
td=td+1
if !empty(f)
   ?f
   stro=stro+1
endi
f=str(bs_k,10)+str(bs_s,15,2)
is_saldo_d=is_saldo_d+bs_s
po_datd=po_datd+bs_s
if forma=1
   ??f
endi
snova()
skip
if EOF()
   c=1
endif
return


proc kred
   sele 31
   if prik=1
      use &dtk
      fill1=gcPath_l+'\'+'vs_k2'
      index on bs_d to &fill1
      set index to &fill1
      prik=0
   endi
   mash=mn
   rndr=rnd
   kklr=kkl
   sele doks
*   seek str(mash,6)+str(rndr,6)+str(kklr,7)
   If netseek('t1','mash,rndr,kklr')
     kod = kkl
   Else
     kod = kklr
   EndIf
   sele kln
*   seek str(kod,7)
   If netseek('t1','kod')
     naz = subs(nkl,1,30)
   Else
     naz = 'Клиента  нет  в  TKLNS02 !!!!!'
  EndIf
   sele 31
   if nplp=0
      rn1=space(6)
   endif
   if nplp#0
      rn1=str(nplp,6)
   endif
   if rnd=0
      rnd1=space(6)
   endif
   if rnd#0
      rnd1=str(rnd,6)
   endif
   f=0
   if prizn=1
      if forma=1
         f=dtoc(ddk)+' '+rnd1+' '+rn1+' '+str(kod,7)+' '+naz
      else
         f=dtoc(ddk)
      endi
      prizn=0
   else
      if forma=1
         f=space(11)+rnd1+' '+rn1+' '+str(kod,7)+' '+naz
      endi
   endi
   d0=alltrim(str(bs_d,6))
   d1=substr(d0,1,3)
   d2=substr(d0,4,3)
   shetk=val(d1)
   sub_k=val(d2)

   If shetk = 0
     shetk = 1
   EndIf

   chet_k[shetk]=chet_k[shetk]+bs_s
   if sub_k#sub_k1
      sk1=sub_k1
      sub_k1=sub_k
      if tk1>1

         ?space(84)+'Итого по '+substr(str(sk1+1000,4),2,3)+' субсчету : '+str(syb_ch_k,15,2)
         stro=stro+1
         snova()
         pri=1
      endif
      tk1=0
      syb_ch_k=0
   endif
   if sub_k#0.and.shetk=shetk1
      syb_ch_k=syb_ch_k+bs_s
      tk1=tk1+1
   endif
   if shetk#shetk1
      sk1=sub_k1
      if pri=0.and.tk1>1.and.tk1#tk

         ?space(84)+'Итого по '+substr(str(sk1+1000,4),2,3)+' субсчету : '+str(syb_ch_k,15,2)
         stro=stro+1
         snova()
         pri=0
      endif
      syb_ch_k=0
      syb_ch_k=syb_ch_k+bs_s
      tk1=0
      tk1=tk1+1
      if tk>1
         ?space(87)+'Итого по '+substr(str(shetk1+1000,4),2,3)+' счету : '+str(s_po_shk,15,2)
         stro=stro+1
         snova()
      endi
      s_po_shk=0
      tk=0
      shetk1=shetk
   endi
   s_po_shk=s_po_shk+bs_s
   tk=tk+1
   if !empty(f)
      ?f
      stro=stro+1
   endi
   f=space(35)+str(bs_d,11)+str(bs_s,15,2)
   is_saldo_k=is_saldo_k+bs_s
   po_datk=po_datk+bs_s
   if forma=1
      ??f
   endi
   snova()
   skip
   if EOF()
      d=1
   endi
return


proc snova
if lp=1
   if stro>61
*     set devi to scre
*     set color to w/r
*     @ MAXROW()-1,1 say '  Для продолжения печати на следующем листе нажмите любую клавишу ...  '
*     asdf=inkey(0)
*     set color to g/n
*     @ MAXROW()-1,0 clea
*     set devi to prin
      zag()
   endi
else
   if stro>122
      zag()
   endif
endif
retu


proc cons
f=space(60)+'Исходящее сальдо на'+dtoc(ddcr2)
ts=' '
razn=is_saldo_d-is_saldo_k
if tek_saldo>=0.and.razn>0
   ts=space(43)+str((tek_saldo+razn),15,2)
endi
if tek_saldo>=0.and.razn<=0
   razn1=tek_saldo+razn
   if razn1>=0
      ts=space(43)+str(razn1,15,2)
   endi
   if razn1<0
      ts=space(56)+str(abs(razn1),15,2)
   endi
endi
if tek_saldo<=0.and.razn<0
   ts=space(56)+str((abs(tek_saldo)+abs(razn)),15,2)
endi
if tek_saldo<=0.and.razn>=0
   razn1=tek_saldo+razn
   if razn1>=0
      ts=space(43)+str(abs(razn1),15,2)
   endi
   if razn1<0
      ts=space(56)+str(abs(razn1),15,2)
   endi
endi
?f+ts
stro=stro+1
snova()
?'---------------------------------------------------------------------------------------------------------------------------------------------------'
stro=stro+1
snova()
i=1
j=1
do while i#1001
   if chet_d[i]#0
*      ?''
      ?space(30)+'Всего по '+str(i,3)+' счету : '+str(chet_d[i],15,2)
      do while j#101
         if chet_k[j]#0
            ??space(21)+'  Всего по '+str(j,3)+' счету : '+str(chet_k[j],15,2)
            j=j+1
            exit
         endi
         j=j+1
      enddo
      stro=stro+1
      snova()
   endi
   i=i+1
enddo
if j<1001
   do while j#1001
      if chet_k[j]#0
         ?space(88)+'Всего по '+str(j,3)+' счету : '+str(chet_k[j],15,2)
         stro=stro+1
         snova()
      endi
      j=j+1
   enddo
endi
?
//set devi to screen
//set print off
//set console on
ClosePrintFile()
sele 20
use
sele vs_d
use
sele vs_k
use
sele vs_bs
use
sele 30
use
sele 31
use

if file(gcPath_l+'\'+'vs_bs.dbf')
   erase (gcPath_l+'\'+'vs_bs.dbf')
endif
if file(gcPath_l+'\'+'vs_d.dbf')
*   erase (gcPath_l+'\'+'vs_d.dbf')
endif
if file(gcPath_l+'\'+'vs_k.dbf')
*   erase (gcPath_l+'\'+'vs_k.dbf')
endif
if file(gcPath_l+'\'+'fstru.dbf')
   erase (gcPath_l+'\'+'fstru.dbf')
endif
if file(gcPath_l+'\'+'fstrub.dbf')
   erase (gcPath_l+'\'+'fstrub.dbf')
endif
if file(gcPath_l+'\'+'vs_d1.idx')
   erase (gcPath_l+'\'+'vs_d1.idx')
endif
if file(gcPath_l+'\'+'vs_k1.idx')
   erase (gcPath_l+'\'+'vs_k1.idx')
endif
if file(gcPath_l+'\'+'vs_d2.idx')
   erase (gcPath_l+'\'+'vs_d2.idx')
endif
if file(gcPath_l+'\'+'vs_k2.idx')
   erase (gcPath_l+'\'+'vs_k2.idx')
endif
if file(gcPath_l+'\'+'vs_d.cdx')
   erase (gcPath_l+'\'+'vs_d.cdx')
endif
if file(gcPath_l+'\'+'vs_k.cdx')
   erase (gcPath_l+'\'+'vs_k.cdx')
endif
retu

