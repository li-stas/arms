****************************
func prnds(p1,p2,p3,p4,p5,p6,p7,p8)
* pr1ndsr=0
* mn
* rnd
* sk
* rn
* mnp
* lpt
* к-во экз
* с квадратиками(для дебилов)
****************************
sm10_r=0
sm10_rr=0
if p6#nil
   gnScOut=1
endif
mn_r=p1
rnd_r=p2
sk_r=p3
rn_r=p4
mnp_r=p5
if !empty(p8)
   prdblr=1
else
   prdblr=0
endif
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

dnn_r=dnn
prxmlr=prxml
if fieldpos('prprn')#0
   prprnr=prprn
else
   prprnr=0
endif
if !empty(nnds->dreg)
   prxmlr=1
endif

if .f..and.gnEnt=20.and.gnEntRm=0.and.bom(gdTd)>=ctod('01.01.2012')
   if fieldpos('prxml')#0
      if empty(nnds->dreg)
         if prxmlr=1.and.nn#0.and.!empty(nsv)
            iflr=lower(ifl)
            #ifndef __CLIP__
               ifl_r='n'+subs(iflr,26,7)
            #else
               ifl_r=iflr
            #endif
            if empty(iflr)
               wmess('Сформируйте XML файл',2)
               if p6#nil
                  gnScOut=0
               endif
               retu .f.
            else
               diryyr=gcPath_nxml+'g'+str(year(dnn_r),4)
               dirmmr=diryyr+'\m'+iif(month(dnn_r)<10,'0'+str(month(dnn_r),1),str(month(dnn_r),2))
               dirddr=dirmmr+'\d'+iif(day(dnn_r)<10,'0'+str(day(dnn_r),1),str(day(dnn_r),2))
               pathnxmlr=dirddr+'\'
               if !file(pathnxmlr+ifl_r+'.xml')
                  wmess('Нет XML файла',2)
                  if p6#nil
                     gnScOut=0
                  endif
                  retu .f.
               else
                  adirect=directory(pathnxmlr+ifl_r+'.xml')
                  dtcr=adirect[1,3]
                  tmcr=adirect[1,4]
                  if date()-dtcr<1
                     wmess('Нельзя.Время не вышло',2)
                     if p6#nil
                        gnScOut=0
                     endif
                     retu .f.
                  endif
               endif
            endif
         endif
      else
         prxmlr=1
      endif
   else
      prxmlr=0
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
prdebilr=0

if kkl=3229489
   prdebilr=1
endif

if fieldpos('kto')#0
   if gnEnt=20
*      netrepl('kto','847')
      netrepl('kto','882')
   endif
   if gnEnt=21
      netrepl('kto','331')
   endif
   if nnds->kto#0
      nmndsr=getfield('t1','nnds->kto','speng','fio')
   else
      nmndsr=gcName
   endif
else
   nmndsr=gcName
endif

if gnArm=2.and.prndsktor=1
*   kto_r=gnKto
*   if gnKto=882
*      kto_r=gnKto
*      gnKto=847
*   endif
   nmndsr=getfield('t1','gnKto','speng','fio')
*   gnKto=kto_r
endif

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
nn2_r=nn
cnn2r=cnn
if dnn_r<ctod('01.12.2014') //.and.gnAdm=0
else
   if nn2r=0
      if dnn_r<ctod('01.01.2015')
         nn2r=400000000000
         cnn2r='400000000000'
      else
         nn2r=100000000000
         cnn2r='100000000000'
      endif
   endif
endif
if nn2_r#0
   adr2r=alltrim(adr)
   tlf2r=alltrim(tlf)
   nsv2r=alltrim(nsv)
else
   adr2r=''
   tlf2r=''
   nsv2r=''
endif
if dnn_r<ctod('01.12.2014')
*   if nn2_r=0.and.!(gnKto=331.or.gnKto=882.or.gnAdm=1)
*      wmess('Не плательщик НДС',2)
*      if p6#nil
*         gnScOut=0
*      endif
*      retu .f.
*   endif
else
   if nn2_r=0
*      nai2r='Неплатник'
*      if !(gnKto=331.or.gnKto=882.or.gnAdm=1)
*         wmess('Не плательщик НДС',2)
*         if p6#nil
*            gnScOut=0
*         endif
*         retu .f.
*      endif
   endif
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

fopr=1
if gnArm=2
   if nn2_r#0
      netuse('fop')
      go top
      rcfopr=recn()
      do while .t.
         sele fop
         go rcfopr
         rcfopr=slcf('fop',,,,,"e:fop h:'Код' c:n(2) e:nfop h:'Наименование' c:c(30)")
         if lastkey()=27
            exit
         endif
         go rcfopr
         fopr=fop
         if lastkey()=13
            exit
         endif
      endd
   else
      fopr=2
   endif
else
   if select('rs1')#0.and.nnds->mnp=0
      if rs1->kop=161
         fopr=2
      endif
   endif
endif

if bs_kr=641002
   if vor=3.and.(kopr=136.or.kopr=137)
         crtt('tdoc',"f:gr1 c:c(10) f:gr2 c:c(18) f:gr3 c:c(46) f:gr4 c:c(10) f:gr5 c:c(5) f:gr6 c:c(10) f:gr7 c:c(10) f:gr8 c:c(10) f:gr9 c:c(10) f:gr10 c:c(10) f:gr11 c:c(10) f:gr12 c:c(10) f:rzd c:n(2) f:nn c:n(2) f:gr51 c:c(10) f:gr52 c:c(4)")
   *   A5 Альбом
      sprnr=chr(27)+'E'+chr(27)+'&l1h25a1O'+chr(27)+'&l3C'+chr(27)+'(3R'+chr(27)+'(s0p29.00h0s1b4102T'+chr(27)
   *   gr1r =space(10)  // Дата
   *   gr2r =space(18)  // Причина
   *   gr3r =space(46)  // Наименование
   *   gr4r =space(5)   // Ед изм.
   *   gr5r =space(10)  // Изм кол-ва
   *   gr6r =space(10)  // Цена поставки
   *   gr7r =space(10)  // Изм цены
   *   gr8r =space(10)  // Кол-во поставки
   *   gr9r =space(10)  // 20%
   *   gr10r=space(10)  // 0%
   *   gr11r=space(10)  // Освобожденнные от НДС
      nrowr=75
   else
      crtt('tdoc','f:gr1 c:c(3) f:gr2 c:c(10) f:gr3 c:c(46) f:gr4 c:c(10) f:gr5 c:c(5) f:gr6 c:c(10) f:gr7 c:c(10) f:gr8 c:c(12) f:gr9 c:c(10) f:gr10 c:c(10) f:gr11 c:c(10) f:gr12 c:c(12) f:rzd c:n(2) f:nn c:n(2) f:gr51 c:c(10) f:gr52 c:c(4)')
   *   A5
      sprnr=chr(27)+'E'+chr(27)+'&l1h25a0O'+chr(27)+'&l3C'+chr(27)+'(3R'+chr(27)+'(s0p29.00h0s1b4102T'+chr(27)
      nrowr=115
   *   gr1r =space(3)   // Раздел
   *   gr2r =space(10)  // Дата
   *   gr3r =space(46)  // Наименование
   *   gr4r =space(10)   // УКТ ЗЕД
   *   gr5r =space(5)   // Ед изм.
   *   gr6r =space(10)  // Кол-во
   *   gr7r =space(10)  // Цена поставки
   *   gr8r =space(12)  // 20%
   *   gr9r =space(10)  // 0%
   *   gr10r =space(10)  // 0% экспорт
   *   gr11r=space(10)  // Освобожденнные от НДС
   *   gr12r=space(12)  // Общая сумма
   endif
else
   crtt('tdoc',"f:gr1 c:c(10) f:gr2 c:c(18) f:gr3 c:c(46) f:gr4 c:c(10) f:gr5 c:c(5) f:gr6 c:c(10) f:gr7 c:c(10) f:gr8 c:c(10) f:gr9 c:c(10) f:gr10 c:c(10) f:gr11 c:c(10) f:gr12 c:c(10) f:rzd c:n(2) f:nn c:n(2) f:gr51 c:c(10) f:gr52 c:c(4)")
*   A5 Альбом
   sprnr=chr(27)+'E'+chr(27)+'&l1h25a1O'+chr(27)+'&l3C'+chr(27)+'(3R'+chr(27)+'(s0p29.00h0s1b4102T'+chr(27)
*       ??chr(27)+'E'+chr(27)+'&l1h26a1O3C'+chr(27)+chr(27)+'(3R'+chr(27)+'(s0p20.00h0s0b4099T'+chr(27)  // Книжная А4
*      ??chr(27)+'E'+chr(27)+'&l1h25a1O'+chr(27)+'&l3C'+chr(27)+'(3R'+chr(27)+'(s0p29.00h0s1b4102T'+chr(27)
   nrowr=79
*   gr1r =space(10)  // Дата
*   gr2r =space(18)  // Причина
*   gr3r =space(46)  // Наименование
*   gr4r =space(10)   // УКТ ЗЕД
*   gr5r =space(5)   // Ед изм.
*   gr6r =space(10)  // Изм кол-ва
*   gr7r =space(10)  // Цена поставки
*   gr8r =space(10)  // Изм цены
*   gr9r =space(10)  // Кол-во поставки
*   gr10r =space(10) // 20%
*   gr11r=space(10)  // 0%
*   gr12r=space(10)  // Освобожденнные от НДС
   nrowr=75
endif

sele 0
use tdoc excl
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
      if lastkey()=27
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
                 ndsrsktn()
               else
                 ndsrsn()
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
            ndsrsktn()
         else
            ndsrsn()
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
               ndsprn()
            endif
            nuse('pr1')
            nuse('pr2')
            nuse('pr3')
            nuse('tov')
            nuse('sgrp')
         endif
      else
         ndsprn()
      endif
   endif
else // Бух документ
   if bs_kr=641002
      rsbndsn()
   else
      prbndsn()
   endif
endif

sele nnds
netrepl('dprn','date()')

if select('tdoc')#0
   sele tdoc
   use
endif

retu .t.

***************
func ndsrsn(p1)
***************
  sele rs1
  ttnr=ttn
  sklr=skl
  pr177r=pr177
  pr169r=pr169
  pr129r=pr129
  pr139r=pr139
  if fieldpos('mntov177')#0
     mntov177r=mntov177
     prc177r=prc177
  else
     mntov177r=0
     prc177r=0
  endif

  if pr177r=2.or.pr169r=2.or.pr129r=2.or.pr139r=2
    sele nnds
    if fieldpos('prprn')#0
      netrepl('prprn','1')
    endif
  endif


  prmk17r=0

  //SumKszRs3()
  //SumKszRs3()
  nacr=0;  skidr=0; sm19r=0;  sm18r=0;  sm90r=0;  sm61r=0
  sm10r=0;  sm11r=0;  sm12r=0
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
     enddo

     if sm61r#0
        gr1r ='   '       // Раздел
        if dnn_r<ctod('01.03.2014') //.and.gnAdm=0
           gr2r =dtoc(dnn_r)  // Дата
        else
           gr2r =strtran(dtoc(dnn_r),'.','')  // Дата
        endif
        gr3r ='Товаро-транспортнi витрати                        '  // Наименование
        gr4r =space(10)
        gr5r ='посл.'   // Ед изм.
        gr6r ='     1.000'  // Кол-во
        if dnn_r<ctod('01.03.2014') //.and.gnAdm=0
           gr7r =str(ttr,10,3)  // Цена поставки
        else
           gr7r =str(ttr,10,2)  // Цена поставки
        endif
        gr8r =str(ttr,12,2)  // 20%
        gr9r =space(10)  // 0%
        gr10r =space(10)  // 0% экспорт
        gr11r=space(10)  // Освобожденнные от НДС
        gr12r=space(12)  // Общая сумма
        sele tdoc
        netadd()
        netrepl('gr1,gr2,gr3,gr4,gr5,gr6,gr7,gr8,gr9,gr10,gr11,gr12,rzd,nn',;
        'gr1r,gr2r,gr3r,gr4r,gr5r,gr6r,gr7r,gr8r,gr9r,gr10r,gr11r,gr12r,2,1')
     endif
     if nacr#0
        gr1r ='   '       // Раздел
  //      gr2r =dtoc(dnn_r)  // Дата
        if dnn_r<ctod('01.03.2014') //.and.gnAdm=0
           gr2r =dtoc(dnn_r)  // Дата
        else
           gr2r =strtran(dtoc(dnn_r),'.','')  // Дата
        endif
        gr3r =' Надано покупцю: | надбавка (+)                   '  // Наименование
        gr4r =space(10)
        gr5r ='посл.'   // Ед изм.
        gr6r ='     1.000'  // Кол-во
        if dnn_r<ctod('01.03.2014') //.and.gnAdm=0
           gr7r =str(nacr,10,3)  // Цена поставки
        else
           gr7r =str(nacr,10,2)  // Цена поставки
        endif
        gr8r =str(nacr,12,2)  // 20%
        gr9r =space(10)  // 0%
        gr10r =space(10)  // 0% экспорт
        gr11r=space(10)  // Освобожденнные от НДС
        gr12r=space(12)  // Общая сумма
        sele tdoc
        netadd()
        netrepl('gr1,gr2,gr3,gr4,gr5,gr6,gr7,gr8,gr9,gr10,gr11,gr12,rzd,nn',;
        'gr1r,gr2r,gr3r,gr4r,gr5r,gr6r,gr7r,gr8r,gr9r,gr10r,gr11r,gr12r,1,2')
     endif
     if skidr#0
        gr1r ='   '       // Раздел
  //      gr2r =dtoc(dnn_r)  // Дата
        if dnn_r<ctod('01.03.2014') //.and.gnAdm=0
           gr2r =dtoc(dnn_r)  // Дата
        else
           gr2r =strtran(dtoc(dnn_r),'.','')  // Дата
        endif
        gr3r =' Надано покупцю: | знижка   (-)                   '  // Наименование
        gr4r =space(10)
        gr5r ='посл.'   // Ед изм.
        gr6r ='     1.000'  // Кол-во
        if dnn_r<ctod('01.03.2014') //.and.gnAdm=0
           gr7r =str(skidr,10,3)  // Цена поставки
        else
           gr7r =str(skidr,10,2)  // Цена поставки
        endif
        gr8r =str(skidr,12,2)  // 20%
        gr9r =space(10)  // 0%
        gr10r =space(10)  // 0% экспорт
        gr11r=space(10)  // Освобожденнные от НДС
        gr12r=space(12)  // Общая сумма
        sele tdoc
        netadd()
        netrepl('gr1,gr2,gr3,gr4,gr5,gr6,gr7,gr8,gr9,gr10,gr11,gr12,rzd,nn',;
        'gr1r,gr2r,gr3r,gr4r,gr5r,gr6r,gr7r,gr8r,gr9r,gr10r,gr11r,gr12r,1,3')
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
        if dnn_r<ctod('01.03.2014')
           gr2r =dtoc(dnn_r)  // Дата
        else
           gr2r =strtran(dtoc(dnn_r),'.','')  // Дата
        endif
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
           kg_r=int(ktlr/1000000)
           if gnEnt=21.and.(kg_r=342.or.kg_r=343.or.kg_r=338.or.kg_r=339)
              natr=alltrim(getfield('t1','kger','grpe','nge'))+' '+alltrim(nat_r)
           else
              natr=nat_r
           endif
        endif
        natr=padr(natr,46)
        gr3r=subs(natr,1,46)
        gr4r =ukt_r
        gr5r =getfield('t1','mntovr','ctov','nei')   // Ед изм.
        kspovor =getfield('t1','mntovr','ctov','kspovo')   // Ед изм.
        gr52r=padl(alltrim(str(kspovor,4)),4,'0')
        gr51r=getfield('t1','kspovor','kspovo','upu')   // Ед изм.
        gr51r=subs(gr51r,1,10)
        gr6r =str(rs2->kvp,10,3)  // Кол-во
        if dnn_r<ctod('01.03.2014')
           gr7r =str(rs2->zen,10,3)  // Цена поставки
        else
           gr7r =str(rs2->zen,10,2)  // Цена поставки
        endif
        gr8r =str(rs2->svp,12,2)  // 20%
        gr9r =space(10)  // 0%
        gr10r =space(10)  // 0% экспорт
        gr11r=space(10)  // Освобожденнные от НДС
        gr12r=space(12)  // Общая сумма
        sele tdoc
        netadd()
        netrepl('gr1,gr2,gr3,gr4,gr5,gr6,gr7,gr8,gr9,gr10,gr11,gr12,rzd,gr51,gr52',;
        'gr1r,gr2r,gr3r,gr4r,gr5r,gr6r,gr7r,gr8r,gr9r,gr10r,gr11r,gr12r,1,gr51r,gr52r')
        sele rs2
        skip
     endd
  endif
   // if prprnr=1
   if pr177r=2.or.pr169r=2.or.pr129r=2.or.pr139r=2
     if mntov177r=0
       mntov177r:=mntov177r(gnEnt)
     endif
     if prc177r=0
       prc177r=getfield('t1','mntov177r','ctov','cenpr')
     endif
     sele rs1
     if mntov177=0.or.prc177=0
        netrepl('mntov177,prc177','mntov177r,prc177r')
     endif
     sele ctov
     netseek('t1','mntov177r')
     kg_r=kg
     kge_r=kge
     nat_r=nat
     ukt_r=ukt
     kspovo_r=kspovo   // Ед изм.
     nei_r=nei
     cenpr_r=prc177r
     if getfield('t1','kg_r','sgrp','mark')=1.and.kge_r#0
        natr=alltrim(getfield('t1','kge_r','grpe','nge'))+' '+alltrim(nat_r)
     else
        if gnEnt=21.and.(kg_r=342.or.kg_r=343.or.kg_r=338.or.kg_r=339)
           natr=alltrim(getfield('t1','kge_r','grpe','nge'))+' '+alltrim(nat_r)
        else
           natr=nat_r
        endif
     endif
     natr=padr(natr,46)

     gr1r ='   '       // Раздел
     gr2r ='  '+strtran(dtoc(dnn_r),'.','')  // Дата
     gr3r=subs(natr,1,46)
     gr4r=ukt_r
     gr5r=nei_r   // Ед изм.
     gr52r=padl(alltrim(str(kspovo_r,4)),4,'0')
     gr51r=getfield('t1','kspovo_r','kspovo','upu')   // Ед изм.
     gr51r=subs(gr51r,1,10)
     gr6r =''  // Кол-во 10.2
     gr7r =''  // Цена поставки 10.2
     gr8r =''  // svp 12.2
     gr9r =space(10)  // 0%
     gr10r =space(10)  // 0% экспорт
     gr11r=space(10)  // Освобожденнные от НДС
     gr12r=space(12)  // Общая сумма
     zen_r=roun(cenpr_r,2)
     kvp_r:=0

     TmpSvp4Trs2()

   //   erase tmpsvp.dbf
     gr7r =str(zen_r,10,2)   // Цена поставки 10.2
     gr6r =str(kvp_r,9,2)    // Кол-во 9.2
   //   gr6_r =str(kvp_r,10,2)  // Кол-во 10.2
     svp_r=roun(kvp_r*zen_r,2)
     gr8r=str(svp_r,12,2)
     sele tdoc
     zap
     appe blank
     repl gr1 with gr1r,;
          gr2 with gr2r,;
          gr3 with gr3r,;
          gr4 with gr4r,;
          gr5 with gr5r,;
          gr51 with gr51r,;
          gr52 with gr52r,;
          gr6 with gr6r,;
          gr7 with gr7r,;
          gr8 with gr8r,;
          gr9 with gr9r,;
          gr10 with gr10r,;
          gr11 with gr11r,;
          gr12 with gr12r,;
          rzd with 1
  endif

  sele tdoc
  inde on str(rzd,2)+str(nn,2) tag t1

  sele tdoc
  go top
  sm10_rr=0
  do while !eof()
     if rzd#1
        skip
        loop
     endif
     sm10_rr=sm10_rr+val(gr8)
     sele tdoc
     skip
  endd

  if empty(p1)
  // Печать
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
         if dnn_r<ctod('01.01.2015') //.and.gnAdm=0
            hdndsrn()
         else
            if dnn_r<ctod('01.04.2016') //.and.gnAdm=0
               hdndsrn3()
            else
               hdndsrn4()
            endif
         endif
      endif
      if dnn_r<ctod('01.12.2014') //.and.gnAdm=0
         hdndsr1n()
      else
         if dnn_r<ctod('01.01.2015') //.and.gnAdm=0
            hdndsr2n()
         else
            if dnn_r<ctod('01.04.2016') //.and.gnAdm=0
               hdndsr3n()
            else
               hdndsr4n()
            endif
         endif
      endif
      sele tdoc
      go top
      sm10_r=0
      nn_r=1
      do while !eof()
         if rzd#1
            skip
            loop
         endif
         sm10_r=sm10_r+val(gr8)
  //       if prprnr=0
            if dnn_r<ctod('01.12.2014') //.and.gnAdm=0
               listr='│'+gr1+'│'+gr2+'│'+gr3+'│'+gr4+'│'+gr5+'│'+gr6+'│'+gr7;
                +'│'+gr8+'│'+gr9+'│'+gr10+'│'+gr11+'│'+gr12+'│'
            else
               if dnn_r<ctod('01.01.2015') //.and.gnAdm=0
                  listr='│'+gr1+'│'+gr2+'│'+gr3+'│'+gr4+'│'+gr5+'│'+gr6+'│'+gr7;
                   +'│'+right(gr8,7)+'│'+space(9)+'│'+right(gr9,9)+'│'+right(gr10,7)+'│'+gr11+'│'+right(gr12,11)+'│'
               else
                  if dnn_r<ctod('01.04.2016') //.and.gnAdm=0
                     listr='│'+gr1+'│'+gr2+'│'+gr3+'│'+gr4+'│'+subs(gr51,1,6)+'│'+gr52+'│'+subs(gr6,1,9)+'│'+gr7;
                      +'│'+right(gr8,7)+'│'+space(9)+'│'+right(gr9,9)+'│'+right(gr10,7)+'│'+subs(gr11,1,5)+'│'+right(gr12,11)+'│'
                  else
  //                   listr='│'+gr1+'│'+gr2+'│'+gr3+'│'+gr4+'│'+subs(gr51,1,6)+'│'+gr52+'│'+subs(gr6,1,9)+'│'+gr7;
  //                    +'│'+right(gr8,7)+'│'+space(9)+'│'+right(gr9,9)+'│'+right(gr10,7)+'│'+subs(gr11,1,5)+'│'+right(gr12,11)+'│'
                     listr='│'+str(nn_r,4)+'│'+subs(gr3,1,44)+'│'+gr2+'│'+padr(gr51,17)+'│'+gr52+'│'+subs(gr6,1,9)+'│'+padl(gr7,24);
                      +'│'+'    20'+'│'+space(6)+'│'+padl(gr8,25)+'│'
                  endif
               endif
            endif
            ?listr
            lsten(3)
  //       endif
         sele tdoc
         nn_r=nn_r+1
         skip
      endd
      if dnn_r<ctod('01.12.2014') //.and.gnAdm=0
         ftndsrn()
      else
         if dnn_r<ctod('01.01.2015') //.and.gnAdm=0
            ftndsr2n()
         else
            if dnn_r<ctod('01.04.2016') //.and.gnAdm=0
               ftndsr3n()
            else
               ftndsr4n()
            endif
         endif
      endif
  next
  set prin off
  set cons on
  set prin to
  endif
  retu .t.

**************
func ndsprn(p1)
**************
sele pr1
mnr=mn
ndr=nd
sklr=skl
kopr=kop
ttnvzr=ttnvz

sm61r=0
sm11r=0
sm12r=0
sm19r=0
sm90r=0
sm10r=0
sm18r=0

sele pr3
if netseek('t1','mnr')
   do while mn=mnr
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
      if ksz=18
         if ssf#0
            sm18r=ssf
         endif
      endif
      if ksz=90
         sm90r=ssf
      endif
      sele pr3
      skip
   endd
endif

sele pr1
if (gnEnt=20.or.gnEnt=21).and.kop=110.and.vo=1
   prvzznr=1
else
   prvzznr=0
endif
store 0 to sgr10
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
      if int(mntovr/10000)<2.and.gnEnt#21
         sele pr2
         skip
         loop
      endif
      if dnn_r<ctod('01.03.2014') //.and.gnAdm=0
         gr1r =dtoc(dnn_r)  // Дата
      else
         gr1r =strtran(dtoc(dnn_r),'.','')  // Дата
      endif
*      gr1r =dtoc(dnn_r)  // Дата
      if prvzznr=0
         gr2r='повернення товару '
      else
         gr2r='    змiна цiни    '
      endif
      sele ctov
      netseek('t1','mntovr')
      nat_r=nat
*if empty(nat_r)
*wait
*endif
      if fieldpos('ukt')#0
         ukt_r=ukt
      else
         ukt_r=space(10)
      endif
      sele pr2
      if getfield('t1','int(ktlr/1000000)','sgrp','mark')=1.and.kger#0
         natr=alltrim(getfield('t1','kger','grpe','nge'))+' '+alltrim(nat_r)
      else
         kg_r=int(ktlr/1000000)
         if gnEnt=21.and.(kg_r=342.or.kg_r=343.or.kg_r=338.or.kg_r=339)
            natr=alltrim(getfield('t1','kger','grpe','nge'))+' '+alltrim(nat_r)
         else
            natr=nat_r
         endif
      endif
      natr=padr(natr,46)
      gr3r=subs(natr,1,46)
      gr4r =ukt_r
      gr5r =getfield('t1','mntovr','ctov','nei')   // Ед изм.
      kspovor =getfield('t1','mntovr','ctov','kspovo')   // Ед изм.
      gr52r=padl(alltrim(str(kspovor,4)),4,'0')
      gr51r=getfield('t1','kspovor','kspovo','upu')   // Ед изм.
      gr51r=subs(gr51r,1,10)
      if prvzznr=0
         gr6r =str(-kfr,10,3)   // Изм кол-ва
         if dnn_r<ctod('01.03.2014')
            gr7r =str(zenr,10,3)  // Цена поставки
         else
            gr7r =str(zenr,10,2)  // Цена поставки
         endif
         gr8r =space(10)  // Изм цены
         gr9r =space(10)  // Кол-во поставки
         gr10=ROUND(-kfr*zenr,2)
      else
         gr6r =space(10)  // Изм кол-ва
         gr7r =space(10)  // Цена поставки
         if dnn_r<ctod('01.03.2014')
            gr8r =str(-zenr,10,3)  // Изм цены
         else
            gr8r =str(-zenr,10,2)  // Изм цены
         endif
         gr9r =str(kfr,10,3)   // Кол-во поставки
         gr10=ROUND(-kfr*zenr,2)
      endif
      sgr10=sgr10+gr10
      gr10r=str(gr10,10,2)
      gr11r=space(10)  // 0%
      gr12r=space(10)  // Освобожденнные от НДС

      sele tdoc
      netadd()
      netrepl('gr1,gr2,gr3,gr4,gr5,gr6,gr7,gr8,gr9,gr10,gr11,gr12,rzd,gr51,gr52',;
      'gr1r,gr2r,gr3r,gr4r,gr5r,gr6r,gr7r,gr8r,gr9r,gr10r,gr11r,gr12r,1,gr51r,gr52r')
      sele pr2
      skip
  enddo
endif

sele tdoc
inde on str(rzd,2)+str(nn,2) tag t1
if empty(p1)
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
       if dnn_r<ctod('01.01.2015') //.and.gnAdm=0
          hdndspn()
       else
          if dnn_r<ctod('01.04.2016') //.and.gnAdm=0
             hdndspn3()
          else
             hdndspn4()
          endif
       endif
    endif
    if dnn_r<ctod('01.12.2014') //.and.gnAdm=0
       hdndsp1n()
    else
       if dnn_r<ctod('01.01.2015') //.and.gnAdm=0
          hdndsp2n()
       else
          if dnn_r<ctod('01.04.2016') //.and.gnAdm=0
             hdndsp3n()
          else
             hdndsp4n()
          endif
       endif
    endif
    sele tdoc
    go top
    do while !eof()
       if rzd#1
          skip
          loop
       endif
       if dnn_r<ctod('01.12.2014') //.and.gnAdm=0
          listr='│'+gr1+'│'+gr2+'│'+gr3+'│'+gr4+'│'+gr5+'│'+gr6+'│'+gr7;
           +'│'+gr8+'│'+gr9+'│'+gr10+'│'+gr11+'│'+gr12+'│'
       else
          if dnn_r<ctod('01.01.2015') //.and.gnAdm=0
             listr='│'+gr1+'│'+gr2+'│'+gr3+'│'+gr4+'│'+gr5+'│'+gr6+'│'+gr7;
              +'│'+gr8+'│'+gr9+'│'+gr10+'│'+gr11+'│'+gr12+'│'+space(10)+'│'
          else
             if dnn_r<ctod('01.04.2016') //.and.gnAdm=0
                listr='│'+gr1+'│'+gr2+'│'+gr3+'│'+gr4+'│'+gr51+'│'+gr52+'│'+gr6+'│'+gr7;
                 +'│'+gr8+'│'+gr9+'│'+gr10+'│'+gr11+'│'+gr12+'│'+space(10)+'│'
             else
                listr='│'+gr1+'│'+gr2+'│'+gr3+'│'+gr4+'│'+gr51+'│'+gr52+'│'+gr6+'│'+gr7;
                 +'│'+gr8+'│'+gr9+'│'+gr10+'│'+gr11+'│'+gr12+'│'+space(10)+'│'
             endif
          endif
       endif
       ?listr
       lsten(3)
       sele tdoc
       skip
    endd
    if dnn_r<ctod('01.12.2014') //.and.gnAdm=0
       ftndspn()
    else
       if dnn_r<ctod('01.01.2015') //.and.gnAdm=0
          ftndsp2n()
       else
          if dnn_r<ctod('01.04.2016') //.and.gnAdm=0
             ftndsp3n()
          else
             ftndsp4n()
          endif
       endif
    endif
next
set prin off
set cons on
set prin to
endif
retu .t.
**************
func rsbndsn()
**************
retu .t.
**************
func prbndsn()
**************
retu .t.

**************
func hdndsrn()
**************
if pr1ndsr=0
   ?str(ttnr,6)+space(134)+'Лист '+str(nlstr,2)
else
   ?space(140)+'Лист '+str(nlstr,2)
endif
lsten(1)
?''
lsten(1)
?''
lsten(1)
?''
lsten(1)
?''
lsten(1)
if dnn_r<ctod('01.03.2014') //.and.gnAdm=0
   ?'┌────────┬──────────────────────┬─────┐'+space(75)+'ЗАТВЕРДЖЕНО'
   lsten(1)
   ?'│        │Видається покупцю     │  X  │'+space(75)+'Наказ Мiнiстерсва фiнансiв України'
   lsten(1)
   ?'│        ├──────────────────────┼─────┤'+space(75)+'01.11.2011 N1379'
   lsten(1)
   ?'│Оригiнал│Включено до ЄРПН      │  '+iif(prxmlr=1.and.dnn_r>=ctod('01.01.2012'),'X',' ')+'  │'
   lsten(1)
   ?'│        ├──────────────────────┼─────┤'
   lsten(1)
   ?'│        │Залишається в продавця│     │'+space(8)+'П О Д А Т К О В А   Н А К Л А Д Н А'
   lsten(1)
   ?'│        │                      ├──┬──┤'
   lsten(1)
   ?'│        │(тип причини)         │  │  │'
   lsten(1)
   ?'├────────┴──────────────────────┼──┴──┤'
   lsten(1)
   ?'│Копiя(залишається у продавця)  │     │'
   lsten(1)
   ?'└───────────────────────────────┴─────┘'
   lsten(1)
   ?'Потрiбне вiдмiтити помiткою X'
   lsten(1)
else
   ?'┌────────┬────────────────────────────┬─────┐'+space(75)+'ЗАТВЕРДЖЕНО'
   lsten(1)
   if dnn_r<ctod('01.12.2014') //.and.gnAdm=0
      ?'│        │Оригинал(видається покупцю) │  X  │'+space(75)+'Наказ Мiнiстерсва доходiв i зборiв'
      lsten(1)
      ?'│Паперова├────────────────────────────┼─────┤'+space(75)+'України'
      lsten(1)
      ?'│        │Копiя(залишаєтся у продавця)│     │'+space(75)+'14.01.2014 N10'
      lsten(1)
   else
      ?'│        │Оригинал(видається покупцю) │  X  │'+space(75)+'Наказ Мiнiстерсва фiнансiв України'
      lsten(1)
      ?'│Паперова├────────────────────────────┼─────┤'+space(75)+'22 вересня 2014 року N 957'
      lsten(1)
      ?'│        │Копiя(залишаєтся у продавця)│     │'
      lsten(1)
   endif
   ?'├─────────────────────────────────────┼─────┤'
   lsten(1)
   ?'│Електронна                           │     │'
   lsten(1)
   ?'├─────────────────────────────────────┼─────┤'
   lsten(1)
   ?'│Пiдлягає рєєстрацiї в ЄРПН           │  '+iif(prxmlr=1.and.dnn_r>=ctod('01.01.2012'),'X',' ')+'  │'
   lsten(1)
   ?'├─────────────────────────────────────┼─────┤'
   lsten(1)
   ?'│Усi примiрники залишаються у продавця│     │'
   lsten(1)
   ?'│                                     ├──┬──┤'
   lsten(1)
   ?'│(тип причини)                        │  │  │'
   lsten(1)
   ?'└─────────────────────────────────────┴──┴──┘'+space(8)+'П О Д А Т К О В А   Н А К Л А Д Н А'
   lsten(1)
   if dnn_r<ctod('01.12.2014') //.and.gnAdm=0
      ?'потрiбне вiдмiтити помiткою X'
   else
      ?'(потрiбне вiдмiтити помiткою "X")'
   endif
   lsten(1)
endif
if prdblr=0
   ?''
   lsten(1)
   if dnn_r<ctod('01.03.2014') //.and.gnAdm=0
      ?'Дата виписки податкової накладної:     ' +subs(dtos(dnn_r),7,2)+subs(dtos(dnn_r),5,2)+subs(dtos(dnn_r),1,4)+space(36)+'Порядковий номер  '+space(36)+str(nnds_r,7) //+'/' //+str(0,5)
   else
      ?'Дата складання податкової накладної    ' +subs(dtos(dnn_r),7,2)+subs(dtos(dnn_r),5,2)+subs(dtos(dnn_r),1,4)+space(36)+'Порядковий номер  '+space(36)+str(nnds_r,7)+'/ /' //+str(0,5)
   endif
   lsten(1)
   ?'                                                                                                                    '+space(28)+'(1)'+'(номер фiлiї)'
   lsten(1)
else
   ?'                                       ┌─┬─┬─┬─┬─┬─┬─┬─┐                                             '+space(33)+'┌─┬─┬─┬─┬─┬─┬─┐ ┌─┬─┬─┬─┬─┐'
   lsten(1)
   if dnn_r<ctod('01.03.2014') //.and.gnAdm=0
      ?'Дата виписки податкової накладної:     ' + rzdt(dnn_r) + '                           Порядковий номер  '+space(33)+rznum(nnds_r,7)+'/'+rznum(0,5)
   else
      ?'Дата складання податкової накладної   ' + rzdt(dnn_r) + '                           Порядковий номер  '+space(33)+rznum(nnds_r,7)+'/ /'+rznum(0,5)
   endif
   lsten(1)
   ?'                                       └─┴─┴─┴─┴─┴─┴─┴─┘                                             '+space(33)+'└─┴─┴─┴─┴─┴─┴─┘   └─┴─┴─┴─┴─┘'
   lsten(1)
endif


nn11r=iif(len(nai1r)>50,subs(nai1r,1,50),padl(nai1r,50))
if len(nai1r)>50
   nn12r=iif(len(subs(nai1r,51,50))>50,subs(nai1r,51,50),padl(subs(nai1r,51,50),50))
else
   nn12r=space(50)
endif

nn21r=iif(len(nai2r)>50,subs(nai2r,1,50),padl(nai2r,50))
if len(nai2r)>50
   nn22r=iif(len(subs(nai2r,51,50))>50,subs(nai2r,51,50),padl(subs(nai2r,51,50),50))
else
   nn22r=space(50)
endif
*if prdblr=0
*   ?'Особа (платник        '+nn11r+' '+space(10)+'Особа (платник      '+space(6)+' '+nn21r+' '
*   lsten(1)
*   ?'податку) - продавець  '+nn12r+' '+space(10)+'податку) - покупець '+space(6)+' '+nn22r+' '
*   lsten(1)
*   ?space(21)+'  (найменування; прiзвище, iм"я, по батьковi - для '+space(38)+' (найменування;прiзвище,iм"я,по батьковi, - для    '
*   lsten(1)
*   ?space(21)+'            фiзичної особи - пiдприємця)           '+space(38)+'            фiзичної особи - пiдприємця)           '
*   lsten(1)
*   ?''
*   lsten(1)
*else
   ?space(21)+'┌──────────────────────────────────────────────────┐'+space(36)+'┌──────────────────────────────────────────────────┐'
   lsten(1)
   ?'Особа (платник       │'+nn11r+'│'+space(10)+'Особа (платник      '+space(6)+'│'+nn21r+'│'
   lsten(1)
   ?'податку) - продавець │'+nn12r+'│'+space(10)+'податку) - покупець '+space(6)+'│'+nn22r+'│'
   lsten(1)
   ?space(21)+'└──────────────────────────────────────────────────┘'+space(36)+'└──────────────────────────────────────────────────┘'
   lsten(1)
   ?space(21)+'  (найменування; прiзвище, iм"я, по батьковi - для '+space(38)+' (найменування;прiзвище,iм"я,по батьковi, - для    '
   lsten(1)
   ?space(21)+'            фiзичної особи - пiдприємця)           '+space(38)+'            фiзичної особи - пiдприємця)           '
   lsten(1)
*endif

if prdblr=0
   ?space(61)+str(nn1r,12) +space(76)+iif(empty(cnn2r),str(nn2r,12),cnn2r)
   lsten(1)
   ?space(32)+'(iндивiдуальний податковий номер продавця)'+space(46)+'(iндивiдуальний податковий номер покупця)'
   lsten(1)
else
   ?space(48)+'┌─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┐'+space(63)+'┌─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┐'
   lsten(1)
   ?space(48)+rznum(nn1r,12) +space(63)+iif(empty(cnn2r),rznum(nn2r,12),rzchr(cnn2r,12,0))
   ?space(48)+'└─┴─┴─┴─┴─┴─┴─┴─┴─┴─┴─┴─┘'+space(63)+'└─┴─┴─┴─┴─┴─┴─┴─┴─┴─┴─┴─┘'
   lsten(1)
endif


adr11r=iif(len(adr1r)>46,subs(adr1r,1,46),padl(adr1r,46))
if len(adr1r)>46
   adr12r=iif(len(subs(adr1r,47,46))>30,subs(adr1r,47,46),padl(subs(adr1r,47,46),46))
else
   adr12r=space(46)
endif
adr21r=iif(len(adr2r)>51,subs(adr2r,1,51),padl(adr2r,51))
if len(adr2r)>50
   adr22r=iif(len(subs(adr2r,51,50))>51,subs(adr2r,52,50),padl(subs(adr2r,52,50),50))
   adr23r=padl(subs(adr2r,101,50),50)
else
   adr22r=space(50)
   adr23r=space(50)
endif
?'Мiсцезнаходження           '+adr11r+space(10)+'Мiсцезнаходження           '+adr21r
lsten(1)
?'(податкова ареса) продавця '+adr12r+space(10)+'(податкова ареса) покупця  '+adr22r
lsten(1)
if !empty(adr23r)
   ?space(54)+adr23r
   lsten(1)
endif

tt1r=strtran(alltrim(tlf1r),'-')
tt2r=strtran(alltrim(tlf2r),'-')
if prdblr=0
   ?''
   lsten(1)
   ?'Номер телефону  '+space(47) + padr(tt1r,10)+space(10)+'Номер телефону  '+space(52)+padr(tt2r,10)
   lsten(1)
   ?''
   lsten(1)
else
   ?space(52)+'┌─┬─┬─┬─┬─┬─┬─┬─┬─┬─┐'+space(16)+space(51)+'┌─┬─┬─┬─┬─┬─┬─┬─┬─┬─┐'
   lsten(1)
   ?'Номер телефону: '+space(36) + rzchr(tt1r,10,0)+space(10)+'Номер телефону: '+space(41)+ rzchr(tt2r,10,0)
   ?space(52)+'└─┴─┴─┴─┴─┴─┴─┴─┴─┴─┘'+space(16)+space(51)+'└─┴─┴─┴─┴─┴─┴─┴─┴─┴─┘'
   lsten(1)
endif

if dnn_r<ctod('01.03.2014') //.and.gnAdm=0
   if prdblr=0
      ?'Номер свiдоцтва про          '+space(23)+space(21)+space(10)+'Номер свiдоцтва про         '+space(29)+space(21)
      lsten(1)
      ?'реєстрацiю платника податку  '+space(34)+padl(alltrim(nsv1r),10)+space(10)+'реєстрацiю платника податку '+space(40)+padl(alltrim(nsv2r),10)
      lsten(1)
      ?'на додану вартiсть(продавця) '+space(23)+space(21)+space(10)+'на додану вартiсть(покупця) '+space(29)+space(21)
      lsten(1)
      ?''
      lsten(1)
   else
      ?'Номер свiдоцтва про          '+space(23)+'┌─┬─┬─┬─┬─┬─┬─┬─┬─┬─┐'+space(10)+'Номер свiдоцтва про         '+space(29)+'┌─┬─┬─┬─┬─┬─┬─┬─┬─┬─┐'
      lsten(1)
      ?'реєстрацiю платника податку  '+space(23)+rzchr(alltrim(nsv1r),10,0)+space(10)+'реєстрацiю платника податку '+space(29)+rzchr(alltrim(nsv2r),10,0)
      lsten(1)
      ?'на додану вартiсть(продавця) '+space(23)+'└─┴─┴─┴─┴─┴─┴─┴─┴─┴─┘'+space(10)+'на додану вартiсть(покупця) '+space(29)+'└─┴─┴─┴─┴─┴─┴─┴─┴─┴─┘'
      lsten(1)
   endif
endif

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
   if prdblr=0
      ?'Вид цивiльно-правового договору:договiр про реалiзацiю продуктiв харчування '+space(22)+'вiд '+subs(dtos(dd_r),7,2)+subs(dtos(dd_r),5,2)+subs(dtos(dd_r),1,4)+' N '+padl(cndogr,12)  //+' '+str(kplr,7)
      lsten(1)
      ?''
      lsten(1)
   else
*      ?space(80)+'┌─┬─┬─┬─┬─┬─┬─┬─┐'+space(3)+'┌─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┐'
      ?space(80)+'┌─┬─┬─┬─┬─┬─┬─┬─┐'+space(3)+'┌───────────────────────┐'
      lsten(1)
      ?'Вид цивiльно-правового договору:договiр про реалiзацiю продуктiв харчування '+'вiд '+rzdt(dd_r)+' N '+rzchr(cndogr,12,0,1)  //+' '+str(kplr,7)
      ?space(80)+'└─┴─┴─┴─┴─┴─┴─┴─┘'+space(3)+'└───────────────────────┘'
      lsten(1)
   endif
else
   if prdblr=0
      ?'Вид цивiльно-правового договору '+repl('_',78)+'договiр поставки '+'вiд '+subs(dtos(dd_r),7,2)+subs(dtos(dd_r),5,2)+subs(dtos(dd_r),1,4)+space(4)+' N '+space(3)+padl(cndogr,12)  //+' '+str(kplr,7)
      lsten(1)
      ?space(31)+space(35)+'(вид договору)'
      lsten(1)
      ?''
      lsten(1)
   else
      ?space(109)+'┌─┬─┬─┬─┬─┬─┬─┬─┐'+space(10)+'┌───────────────────────┐'
      lsten(1)
      ?'Вид цивiльно-правового договору:'+space(56)+'договiр поставки '+'вiд '+rzdt(dd_r)+space(4)+' N '+space(3)+rzchr(cndogr,12,0,1)  //+' '+str(kplr,7)
      ?space(109)+'└─┴─┴─┴─┴─┴─┴─┴─┘'+space(10)+'└───────────────────────┘'
      lsten(1)
   endif
endif
?'Форма проведених разрахункiв  '+space(100)+padl(iif(fopr=0,'р/р',alltrim(getfield('t1','fopr','fop','nfop'))),30)
lsten(1)
?'                              '+repl('─',131)
lsten(1)
?'                                 (бартер, готiвка, оплата з поточного рахунку, чек тощо)'
lsten(1)
retu .t.

**************
func hdndsr1n()
**************
if nlstr#1
   ?space(140)+'Лист '+str(nlstr,2)
   lsten(2)
endif
?'┌───┬──────────┬──────────────────────────────────────────────┬──────────┬─────┬──────────┬──────────┬─────────────────────────────────────────────┬────────────┐'
lsten(2)
?'│ Р │   Дата   │                 Номенклатура                 │Код товару│Одини│ Кiлькiсть│   Цiна   │    Обсяг постачання(база оподаткування)     │  Загальна  │'
lsten(2)
?'│ О │виникнення│               товарiв/ послуг                │згiдно з  │ця ви│(об"ем,   │постачання│      без урахування ПДВ,що пiдлягають       │сума коштiв │'
lsten(2)
?'│ З │податковог│                   продавця                   │ УКТ ЗЕД  │мiру │ обсяг)   │одиницi   │          оподаткуванню за ставками          │що пiдлягає │'
lsten(2)
?'│ Д │о зобов"яз│                                              │          │товар│          │товару/   ├────────────┬─────────────────────┬──────────┤  сплатi    │'
lsten(2)
?'│ I │ання(поста│                                              │          │у/пос│          │послуг без│            │    нульова ставка   │          │            │'
lsten(2)
?'│ Л │чання(опла│                                              │          │луги │          │урахування│            ├──────────┬──────────┤          │            │'
lsten(2)
?'│   │ти2))     │                                              │          │     │          │   ПДВ    │  основна   │ постачанн│          │звiльнення│            │'
lsten(2)
?'│   │          │                                              │          │     │          │          │  ставка    │на митнiй │ експорт  │вiд ПДВ3  │            │'
lsten(2)
?'│   │          │                                              │          │     │          │          │            │терiторiї │          │          │            │'
lsten(2)
?'│   │          │                                              │          │     │          │          │            │України   │          │          │            │'
lsten(2)
?'├───┼──────────┼──────────────────────────────────────────────┼──────────┼─────┼──────────┼──────────┼────────────┼──────────┼──────────┼──────────┼────────────┤'
lsten(2)
?'│ 1 │    2     │                        3                     │  4       │  5  │     6    │     7    │      8     │     9    │    10    │    11    │     12     │'
lsten(2)
?'├───┼──────────┼──────────────────────────────────────────────┼──────────┼─────┼──────────┼──────────┼────────────┼──────────┼──────────┼──────────┼────────────┤'
lsten(2)
?'│ I │          │                                              │          │     │          │          │            │          │          │          │            │'
lsten(2)
retu .t.

**************
func ftndsrn()
**************
?'│   ├─────────────────────────────────────────────────────────┼──────────┼─────┼──────────┼──────────┼────────────┼──────────┼──────────┼──────────┤            │'
lsten(4)
?'│   │ Усього за роздiлом I                                    │    X     │  X  │     X    │     X    │'+str(sm10_r,12,2)+'│          │          │          │'+Str(sm10_r,12,2)+'│'
lsten(4)
?'├───┼─────────────────────────────────────────────────────────┼──────────┼─────┼──────────┼──────────┼────────────┼──────────┼──────────┼──────────┼────────────┤'
lsten(4)
?'│ II│ Зворотня(заставна) тара                                 │    X     │  X  │     X    │     X    │     X      │     X    │     X    │     X    │'+iif(sm19r#0,Str(sm19r,12,2),space(12))+'│'
lsten(4)
?'├───┼─────────────────────────────────────────────────────────┼──────────┼─────┼──────────┼──────────┼────────────┼──────────┼──────────┼──────────┼────────────┤'
lsten(2)
*?'│III│ Податок на додану вартiсть                              │    X     │  X  │     X    │     X    │'+str(sm11r+sm12r,12,2)+'│          │          │          │'+Str(sm11r+sm12r,12,2)+'│'
if dnn_r<ctod('01.12.2014')
   ?'│III│ Податок на додану вартiсть                              │    X     │  X  │     X    │     X    │'+Str(sm10_r*20/100,12,2)+'│          │          │          │'+Str(sm10_r*20/100,12,2)+'│'
else
   ?'│III│ Податок на додану вартiсть                              │    X     │  X  │     X    │     X    │'+Str(sm10_r*20/100,12,2)+'│    0     │    0     │    X     │'+Str(sm10_r*20/100,12,2)+'│'
endif
lsten(4)
?'├───┼─────────────────────────────────────────────────────────┼──────────┼─────┼──────────┼──────────┼────────────┼──────────┼──────────┼──────────┼────────────┤'
lsten(2)
*?'│ IV│ Загальна сума з ПДВ                                     │    X     │  X  │     X    │     X    │'+str(sm90r-sm19r,12,2)+'│          │          │          │'+Str(sm90r,12,2)+'│'
*?'│ IV│ Загальна сума з ПДВ                                     │    X     │  X  │     X    │     X    │'+str(sm90r-sm19r,12,2)+'│          │          │          │'+Str((sm10_r+sm10_r*20/100+sm19r),12,2)+'│'
*?'│ IV│ Загальна сума з ПДВ                                     │    X     │  X  │     X    │     X    │'+Str((sm10_r+sm10_r*20/100+sm19r),12,2)+'│          │          │          │'+Str((sm10_r+sm10_r*20/100+sm19r),12,2)+'│'
?'│ IV│ Загальна сума з ПДВ                                     │    X     │  X  │     X    │     X    │'+Str((sm10_r+sm10_r*20/100),12,2)+'│          │          │          │'+Str((sm10_r+sm10_r*20/100+sm19r),12,2)+'│'
lsten(4)
?'└───┴─────────────────────────────────────────────────────────┴──────────┴─────┴──────────┴──────────┴────────────┴──────────┴──────────┴──────────┴────────────┘'
lsten(4)

?'Суми ПДВ, нарахованi(сплаченi) в зв"язку з постачанням товарiв/послуг,зазначених у цiй накладнiй, визначенi правильно,'
lsten(4)
?'вiдповiдають сумi податкових зобов"язань продавця i включенi до реєстру виданих та отриманих податкових накладних.'
lsten(4)

?''
lsten(4)
?''
lsten(4)
?'                                                                               ___________________________________________/'+nmndsr //gcName
lsten(4)
?'                                                                               (пiдпис,iнiцiали та прiзвище особи, яка склала податкову накладну)'
lsten(4)
?'----------------------------------------------------------------------------------------------------------------------------------------------------------'
lsten(4)

?'1 Зазначається код виду дiяльностi, що передбачає спецiальний режим оподаткування(2, або 3, або 4), у разi складання податкової накладної за такою дiяльнiстю.'
lsten(4)
?'2 Дата оплати ставиться у разi попередньоi оплати постачання, на яку виписуеться податкова накладна, для операцiй з постачання товарiв/послуг вiдповiдно до'
lsten(4)
?'пункту 187.10 статтi 187 роздiлу V Податкового кодексу України.'
lsten(4)
?'3_____________________________________________________________________________________________________________________________________________________________'
lsten(4)
?'              (вiдповiднi пункти (пiдпункти), статтi, пiдроздiли, роздiли Податкового кодексу України, якими передбачено звiльненя вiд оподаткування)'
lsten(4)
eject
retu .t.
**************
func hdndspn()
**************
if pr1ndsr=0
   ?str(ndr,6)+space(140)+'Лист '+str(nlstr,2)
else
   ?space(146)+'Лист '+str(nlstr,2)
endif
lsten(1)
if dnn_r<ctod('01.03.2014') //.and.gnAdm=0
   ?'┌────────┬────────────────────┬─────┐'+space(95)+'Додаток 2'
   lsten(1)
   ?'│        │Видається покупцю   │  X  │'+space(95)+'до Податкової накладної'
   lsten(1)
   ?'│        ├────────────────────┼─────┤'
   lsten(1)
   ?'│Оригiнал│Включено до ЄРПН    │  '+iif(prxmlr=1.and.dnn_r>=ctod('01.01.2012'),'X',' ')+'  │'
   lsten(1)
   ?'│        ├────────────────────┼─────┤'
   lsten(1)
   ?'│        │Залиш. у продавця   │     │'
   lsten(1)
   ?'│        │                    ├──┬──┤'
   lsten(1)
   ?'│        │(тип причини)       │  │  │'
   lsten(1)
   ?'├────────┴────────────────────┼──┴──┤'
   lsten(1)
   ?'│Копiя(залишається у продавця)│     │'
   lsten(1)
   ?'└─────────────────────────────┴─────┘'
   lsten(1)
   ?'Потрiбне вiдмiтити помiткою X'
   lsten(1)
else
   ?'┌────────┬────────────────────────────┬─────┐'+space(95)+'Додаток 2'
   lsten(1)
   ?'│        │Оригинал(видається покупцю) │  X  │'+space(95)+'до податкової накладної'
   lsten(1)
   ?'│Паперова├────────────────────────────┼─────┤'
   lsten(1)
   ?'│        │Копiя(залишаєтся у продавця)│     │'
   lsten(1)
   ?'├─────────────────────────────────────┼─────┤'
   lsten(1)
   ?'│Електронна                           │     │'
   lsten(1)
   ?'├─────────────────────────────────────┼─────┤'
   lsten(1)
   ?'│Пiдлягає рєєстрацiї в ЄРПН           │  '+iif(prxmlr=1.and.dnn_r>=ctod('01.01.2012'),'X',' ')+'  │'
   lsten(1)
   ?'├─────────────────────────────────────┼─────┤'
   lsten(1)
   ?'│Усi примiрники залишаються у продавця│     │'
   lsten(1)
   ?'│                                     ├──┬──┤'
   lsten(1)
   ?'│(тип причини)                        │  │  │'
   lsten(1)
   ?'└─────────────────────────────────────┴──┴──┘'
   lsten(1)
   if dnn_r<ctod('01.12.2014') //.and.gnAdm=0
      ?'потрiбне вiдмiтити помiткою X'
   else
      ?'(потрiбне вiдмiтити помiткою "X")'
   endif
   lsten(1)
endif
if prdblr=0
   ?''
   lsten(1)
   if dnn_r<ctod('01.03.2014') //.and.gnAdm=0
      ?space(30)+'Р О З Р А Х У Н О К    N '+str(nnds_r,10)+'/  '+space(13)+' вiд '+subs(dtos(dnn_r),7,2)+subs(dtos(dnn_r),5,2)+subs(dtos(dnn_r),1,4)
   else
      ?space(30)+'Р О З Р А Х У Н О К    N '+str(nnds_r,10)+'/ /'+space(13)+' вiд '+subs(dtos(dnn_r),7,2)+subs(dtos(dnn_r),5,2)+subs(dtos(dnn_r),1,4)
   endif
   lsten(1)
   ?space(47)+'(порядковий номер)'+'(1)'+'(номер фiлiї)'+'(дата складання)'
   lsten(1)
   ?space(30)+'коригування кiлькiстних i вартiсних показникiв до податкової накладної'
   lsten(1)
else
   ?space(30)+space(25)+'┌─┬─┬─┬─┬─┬─┬─┬─┬─┬─┐ ┌─┬─┬─┬─┬─┐'+space(5)+'┌─┬─┬─┬─┬─┬─┬─┬─┐'
   lsten(1)
   ?space(30)+'Р О З Р А Х У Н О К    N '+rznum(nnds_r,10)+'/'+rznum(0,5)+' '+'вiд'+' '+rzdt(dnn_r)
   lsten(1)
   ?space(30)+space(25)+'└─┴─┴─┴─┴─┴─┴─┴─┴─┴─┘ └─┴─┴─┴─┴─┘'+space(5)+'└─┴─┴─┴─┴─┴─┴─┴─┘'
   lsten(1)
   ?space(30)+'коригування кiлькiстних i вартiсних показникiв до податкової накладної'
   lsten(1)
endif

dd_r=getfield('t1','kklr','klndog','dtdogb')
cndogr=alltrim(getfield('t1','kklr','klndog','cndog'))
if empty(cndogr)
   cndogr=alltrim(str(getfield('t1','kklr','klndog','ndog'),6))
endif

if prdblr=0
   ?''
   lsten(1)
*   ?space(30)+'вiд '+subs(dtos(dnn1_r),7,2)+subs(dtos(dnn1_r),5,2)+subs(dtos(dnn1_r),1,4)+' N '+str(nnds1_r,10)+' за договором вiд '+subs(dtos(dd_r),7,2)+subs(dtos(dd_r),5,2)+subs(dtos(dd_r),1,4)+' N '+padl(cndogr,6)
   if dnn_r<ctod('01.03.2014') //.and.gnAdm=0
      ?space(30)+'вiд '+subs(dtos(dnn1_r),7,2)+subs(dtos(dnn1_r),5,2)+subs(dtos(dnn1_r),1,4)+' N '+str(nnds1_r,10)+'/  '+space(13)+' за договором вiд '+subs(dtos(dd_r),7,2)+subs(dtos(dd_r),5,2)+subs(dtos(dd_r),1,4)+' N '+padl(cndogr,6)
   else
      ?space(30)+'вiд '+subs(dtos(dnn1_r),7,2)+subs(dtos(dnn1_r),5,2)+subs(dtos(dnn1_r),1,4)+' N '+str(nnds1_r,10)+space(11)+'/ /'+space(13)+' за договором вiд '+subs(dtos(dd_r),7,2)+subs(dtos(dd_r),5,2)+subs(dtos(dd_r),1,4)+' N '+padl(cndogr,6)
      ?space(30)+'(дата складання)'+space(1)+'(порядковий номер)'+space(1)+'(1)'+space(1)+'(номер филiї)'
   endif
   lsten(1)
   ?''
   lsten(1)
else
   ?space(23)+'┌─┬─┬─┬─┬─┬─┬─┬─┐'+space(3)+'┌─┬─┬─┬─┬─┬─┬─┬─┬─┬─┐'+space(18)+'┌─┬─┬─┬─┬─┬─┬─┬─┐'+space(3)+'┌───────────┐'
   lsten(1)
   ?space(19)+'вiд '+rzdt(dnn1_r)+' N '+rznum(nnds1_r,10)+' за договором вiд '+rzdt(dd_r)+' N '+rzchr(cndogr,6,0,1)
   lsten(1)
   ?space(23)+'└─┴─┴─┴─┴─┴─┴─┴─┘'+space(3)+'└─┴─┴─┴─┴─┴─┴─┴─┴─┴─┘'+space(18)+'└─┴─┴─┴─┴─┴─┴─┴─┘'+space(3)+'└───────────┘'
   lsten(1)
endif

nn11r=iif(len(nai1r)>50,subs(nai1r,1,50),padl(nai1r,50))
if len(nai1r)>50
   nn12r=iif(len(subs(nai1r,51,50))>50,subs(nai1r,51,50),padl(subs(nai1r,51,50),50))
else
   nn12r=space(50)
endif
nn21r=iif(len(nai2r)>50,subs(nai2r,1,50),padl(nai2r,50))
if len(nai2r)>50
   nn22r=iif(len(subs(nai2r,51,50))>50,subs(nai2r,51,50),padl(subs(nai2r,51,50),50))
else
   nn22r=space(50)
endif
if prdblr=0
   ?space(21)+'┌──────────────────────────────────────────────────┐'+space(47)+'┌──────────────────────────────────────────────────┐'
   lsten(1)
   ?'Особа (платник       │'+nn11r+'│'+space(27)+'Особа (платник      │'+nn21r+'│'
   lsten(1)
   ?'податку) - продавець │'+nn12r+'│'+space(27)+'податку) - покупець │'+nn22r+'│'
   lsten(1)
   ?space(21)+'└──────────────────────────────────────────────────┘'+space(47)+'└──────────────────────────────────────────────────┘'
   lsten(1)
   ?space(21)+'  (найменування; прiзвище, iм"я, по батьковi - для '+space(49)+' (найменування;прiзвище,iм"я,по батьковi, - для    '
   lsten(1)
   ?space(21)+'            фiзичної особи - пiдприємця)           '+space(49)+'            фiзичної особи - пiдприємця)           '
   lsten(1)
else
   ?space(21)+'┌──────────────────────────────────────────────────┐'+space(47)+'┌──────────────────────────────────────────────────┐'
   lsten(1)
   ?'Особа (платник       │'+nn11r+'│'+space(27)+'Особа (платник      │'+nn21r+'│'
   lsten(1)
   ?'податку) - продавець │'+nn12r+'│'+space(27)+'податку) - покупець │'+nn22r+'│'
   lsten(1)
   ?space(21)+'└──────────────────────────────────────────────────┘'+space(47)+'└──────────────────────────────────────────────────┘'
   lsten(1)
   ?space(21)+'  (найменування; прiзвище, iм"я, по батьковi - для '+space(49)+' (найменування;прiзвище,iм"я,по батьковi, - для    '
   lsten(1)
   ?space(21)+'            фiзичної особи - пiдприємця)           '+space(49)+'            фiзичної особи - пiдприємця)           '
   lsten(1)
endif

if prdblr=0
   ?''
   lsten(1)
   ?space(61)+str(nn1r,12) +space(87)+iif(empty(cnn2r),str(nn2r,12),padl(cnn2r,12))
   lsten(1)
   ?''
   lsten(1)
else
   ?space(48)+'┌─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┐'+space(74)+'┌─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┐'
   lsten(1)
   ?space(48)+rznum(nn1r,12) +space(74)+iif(empty(cnn2r),rznum(nn2r,12),rzchr(cnn2r,12,0))
   lsten(1)
   ?space(48)+'└─┴─┴─┴─┴─┴─┴─┴─┴─┴─┴─┴─┘'+space(74)+'└─┴─┴─┴─┴─┴─┴─┴─┴─┴─┴─┴─┘'
   lsten(1)
endif

adr11r=iif(len(adr1r)>46,subs(adr1r,1,46),padr(adr1r,46))
if len(adr1r)>46
   adr12r=iif(len(subs(adr1r,47,46))>46,subs(adr1r,47,46),padl(subs(adr1r,47,46),46))
else
   adr12r=space(46)
endif
adr21r=iif(len(adr2r)>46,subs(adr2r,1,46),padl(adr2r,46))
if len(adr2r)>46
   adr22r=iif(len(subs(adr2r,47,46))>46,subs(adr2r,47,46),padl(subs(adr2r,47,46),46))
else
   adr22r=space(46)
endif
?'Мiсцезнаходження             '+adr11r+space(25)+'Мiсцезнаходження          '+adr21r
lsten(1)
?'(податкова ареса) продавця   '+adr12r+space(25)+'(податкова ареса) покупця '+adr22r
lsten(1)

tt1r=strtran(alltrim(tlf1r),'-')
tt2r=strtran(alltrim(tlf2r),'-')
if prdblr=0
   ?''
   lsten(1)
   ?'Номер телефону  '+space(47) + padl(tt1r,10)+space(27)+'Номер телефону  '+space(46)+ padl(tt2r,10)
   ?''
   lsten(1)
else
   ?space(52)+'┌─┬─┬─┬─┬─┬─┬─┬─┬─┬─┐'+space(78)+'┌─┬─┬─┬─┬─┬─┬─┬─┬─┬─┐'
   lsten(1)
   ?'Номер телефону: '+space(36) + rzchr(tt1r,10,0)+space(27)+'Номер телефону: '+space(35)+ rzchr(tt2r,10,0)
   ?space(52)+'└─┴─┴─┴─┴─┴─┴─┴─┴─┴─┘'+space(78)+'└─┴─┴─┴─┴─┴─┴─┴─┴─┴─┘'
   lsten(1)
endif

if dnn_r<ctod('01.03.2014') //.and.gnAdm=0
if prdblr=0
   ?'Номер свiдоцтва про          '+space(71)+'Номер свiдоцтва про         '+space(23)+space(21)
   lsten(1)
   ?'реєстрацiю платника податку  '+space(34)+padl(alltrim(nsv1r),10)+space(27)+'реєстрацiю платника податку '+space(34)+padl(alltrim(nsv2r),10)
   lsten(1)
   ?'на додану вартiсть(продавця) '+space(71)+'на додану вартiсть(покупця) '+space(23)+space(21)
   lsten(1)
else
   ?'Номер свiдоцтва про          '+space(23)+'┌─┬─┬─┬─┬─┬─┬─┬─┬─┬─┐'+space(27)+'Номер свiдоцтва про         '+space(23)+'┌─┬─┬─┬─┬─┬─┬─┬─┬─┬─┐'
   lsten(1)
   ?'реєстрацiю платника податку  '+space(23)+rzchr(alltrim(nsv1r),10,0)+space(27)+'реєстрацiю платника податку '+space(23)+rzchr(alltrim(nsv2r),10,0)
   lsten(1)
   ?'на додану вартiсть(продавця) '+space(23)+'└─┴─┴─┴─┴─┴─┴─┴─┴─┴─┘'+space(27)+'на додану вартiсть(покупця) '+space(23)+'└─┴─┴─┴─┴─┴─┴─┴─┴─┴─┘'
   lsten(1)
endif
endif

dd_r=getfield('t1','kklr','klndog','dtdogb')
cndogr=alltrim(getfield('t1','kklr','klndog','cndog'))
if empty(cndogr)
   cndogr=alltrim(str(getfield('t1','kklr','klndog','ndog'),6))
endif

if prdblr=0
   ?''
   lsten(1)
   ?'Вид цивiльно-правового договору '+repl('_',102)+'договiр поставки '+'вiд '+subs(dtos(dd_r),7,2)+subs(dtos(dd_r),5,2)+subs(dtos(dd_r),1,4)+' N '+padl(cndogr,6)  //+' '+str(kplr,7)
   lsten(1)
   ?space(31)+space(45)+'(вид договору)'
   lsten(1)
else
   ?space(139)+'┌─┬─┬─┬─┬─┬─┬─┬─┐'+space(3)+'┌───────────┐'
   lsten(1)
   ?'Вид цивiльно-правового договору:'+space(86)+'договiр поставки '+'вiд '+rzdt(dd_r)+' N '+rzchr(cndogr,6,0,1)  //+' '+str(kplr,7)
   lsten(1)
   ?space(139)+'└─┴─┴─┴─┴─┴─┴─┴─┘'+space(3)+'└───────────┘'
   lsten(1)
endif

if dnn_r<ctod('01.12.2014') //.and.gnAdm=0
   dd_r=ctod('')
   if prdblr=0
      ?''
      lsten(1)
      ?'Дата оплати '+subs(dtos(dd_r),7,2)+subs(dtos(dd_r),5,2)+subs(dtos(dd_r),1,4)
      lsten(1)
      ?''
      lsten(1)
   else
      ?space(12)+'┌─┬─┬─┬─┬─┬─┬─┬─┐'
      lsten(1)
      ?'Дата оплати '+rzdt(dd_r)
      lsten(1)
      ?space(12)+'└─┴─┴─┴─┴─┴─┴─┴─┘'
      lsten(1)
   endif
   ?'Форма проведених разрахункiв: '+space(111) + padl(iif(fopr=0,'р/р',alltrim(getfield('t1','fopr','fop','nfop'))),30)
   lsten(1)
else
   ?'1 Зазначається код виду дiяльностi, що передбачає спецiальний режим оподаткування (2,або 3,або 4) у разi складання податкової накданої за такою дiяльнiстю'
   lsten(1)
endif
*?'                              '+repl('─',120)
*lsten(1)
*?'                                 (бартер, готiвка, оплата з поточного рахунку, чек тощо)'
*lsten(1)
retu .t.
**************
func hdndsp1n()
**************
?'┌──────────┬──────────────────┬──────────────────────────────────────────────┬──────────┬─────┬─────────────────────┬─────────────────────┬────────────────────────────────┐'
lsten(2)
?'│   Дата   │    Причина       │ Номенклатура товарiв/послуг, вартiсть чи     │Код товару│Один.│Коригування кiлькостi│ Коригування вартостi│ Пiдлягають коригуванню обсяги  │'
lsten(2)
?'│коригуван │   коригування    │        кiлькiсть яких коригується            │  згiдно  │ вим.├──────────┬──────────┼──────────┬──────────┤     без урахування ПДВ,що      │'
lsten(2)
?'│          │                  │                                              │ з УКТ ЗЕД│     │   Змiна  │   Цiна   │  Змiна   │ Кiлькiсть├──────────┬──────────┬──────────┤'
lsten(2)
?'│          │                  │                                              │          │     │ кiлькоcтi│постачання│   цiни   │постачання│оподатков.│оподатков.│звiльненi │'
lsten(2)
?'│          │                  │                                              │          │     │об"ем,обся│тов/посл  │ (-) (+)  │тов/посл  │за осн ст │за нуль ст│ вiд ПДВ  │'
lsten(2)
?'│          │                  │                                              │          │     │  (-) (+) │          │          │          │  (-) (+) │  (-) (+) │ (-) (+)  │'
lsten(2)
?'├──────────┼──────────────────┼──────────────────────────────────────────────┼──────────┼─────┼──────────┼──────────┼──────────┼──────────┼──────────┼──────────┼──────────┤'
lsten(2)
?'│    1     │        2         │                       3                      │     4    │  5  │     6    │     7    │     8    │     9    │    10    │    11    │    12    │'
lsten(2)
?'├──────────┼──────────────────┼──────────────────────────────────────────────┼──────────┼─────┼──────────┼──────────┼──────────┼──────────┼──────────┼──────────┼──────────┤'
lsten(2)
retu .t.
**************
func ftndspn()
**************
sgr1r ='Усього    '  // space(10)   // Дата
sgr2r =space(18)  // Причина
sgr3r =space(46)  // Наименование
sgr4r =space(10)  // УКТ ЗЕД
sgr5r =space(5)   // Ед изм.
sgr6r =space(10)  // Изм.кол-ва (корр.кол-ва)
sgr7r =space(10)  // Изм.цены   (корр.кол-ва)
sgr8r =space(10)  // Изм.цены   (корр.стоимости)
sgr9r =space(10)  // Изм.кол-ва (корр.стоимости)
sgr10r =str(sgr10,10,2)  // 20%
sgr11r=space(10)  //  0%
sgr12r=space(10)  // ст.5
sgr13r=str(sgr10*20/100,10,2)  // ст.5
*?'│'+sgr1r+'│'+sgr2r+'│'+sgr3r+'│'+sgr4r+'│'+sgr5r+'│'+sgr6r+'│'+sgr7r;
*     +'│'+sgr8r+'│'+sgr9r+'│'+sgr10r+'│'+sgr11r+'│'+sgr12r+'│'
?'├──────────┴──────────────────┴──────────────────────────────────────────────┴──────────┴─────┴──────────┴──────────┴──────────┴──────────┼──────────┼──────────┼──────────┤'
lsten(4)
if prvzznr=0
   ?'│Усього                                                                                                                                   │'+sgr10r+'│'+'          '+'│'+'          '+'│'
else // prvzznr=1
   if pr1ndsr=0
      ?'│Усього                                                                                                                                   │'+str(-sm10r-sm18r,10,2)+'│'+'          '+'│'+'          '+'│'
   else
      ?'│Усього                                                                                                                                   │'+str(-sgr10,10,2)+'│'+'          '+'│'+'          '+'│'
   endif
endif
lsten(4)
?'├─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┼──────────┼──────────┼──────────┤'
lsten(4)
if pr1ndsr=1
   ?'│Сума коригування податкового забов"язання та податкового кредиту                                                                         │'+sgr13r+'│'+'    X     '+'│'+'    X     '+'│'
else
   ?'│Сума коригування податкового забов"язання та податкового кредиту                                                                         │'+str(-sm11r,10,2)+'│'+'    X     '+'│'+'    X     '+'│'
endif
lsten(4)
?'└─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┴──────────┴──────────┴──────────┘'
lsten(4)

?'Суми ПДВ,якi скоригованi у зв"язку зi змiною кiлькiсних чи вартiсних показникiв,що зазначенi в цьому розрахунку,визначенi правильно,включенi'
lsten(4)
?'вiдповiдно до податкового забов"язання з одночасним вiдображенням у реестрi отриманих та виданих податкових накладних.'
lsten(4)
?''
lsten(4)
?'                                                            _____________________________________________________________'
lsten(4)
?'                                                          (дата,пiдпис iнiцiали та прiзвище особи,яка склала розрахунок коригування)'
lsten(4)
?'Розрахунок коригування вiд_________________________N______до податковоi накладноi вiд____________________N_________отримав i зобов"язуюся'
lsten(4)
?'включити суми коригування до реєстру виданих та отриманих податкових накладних та сум податкового кредиту i податкового зобов"язання '
lsten(4)
? ''
lsten(4)
?''
lsten(4)
?'                                                            _____________________________________________________________'
lsten(4)
?'                                                                     (дата отримання розрахунку,пiдпис покупця)'
lsten(4)
?'  '
eject
retu .t.
************
func lsten(p1)
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
              lsten(4)
           endif
           if mnp_r=0
*              hdndsr1()
              hdndsr1n()
           else
*              hdndsp1()
              hdndsp1n()
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
              lsten(4)
           endif
   endc
endif
retu .t.

**************
func ndsrsktn()
**************
sele rs1
ttnr=ttn

store 0 to sgr10
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

      if dnn_r<ctod('01.03.2014') //.and.gnAdm=0
         gr1r =dtoc(dnn_r)  // Дата
      else
         gr1r =strtran(dtoc(dnn_r),'.','')  // Дата
      endif

*      gr1r =dtoc(dnn_r)  // Дата
      sele ctov
      netseek('t1','mntovr')
      nat_r=nat
*if empty(nat_r)
*wait
*endif
      if fieldpos('ukt')#0
         ukt_r=ukt
      else
         ukt_r=space(10)
      endif
      sele rs2
      if getfield('t1','int(ktlr/1000000)','sgrp','mark')=1.and.kger#0
         natr=alltrim(getfield('t1','kger','grpe','nge'))+' '+alltrim(nat_r)
      else
         kg_r=int(ktlr/1000000)
         if gnEnt=21.and.(kg_r=342.or.kg_r=343.or.kg_r=338.or.kg_r=339)
            natr=alltrim(getfield('t1','kger','grpe','nge'))+' '+alltrim(nat_r)
         else
            natr=nat_r
         endif
      endif
      natr=padr(natr,46)
      gr3r=subs(natr,1,46)
      gr4r=ukt_r
      gr5r =getfield('t1','mntovr','ctov','nei')   // Ед изм.
      kspovor =getfield('t1','mntovr','ctov','kspovo')   // Ед изм.
      gr52r=padl(alltrim(str(kspovor,4)),4,'0')
      gr51r=getfield('t1','kspovor','kspovo','upu')   // Ед изм.
      gr51r=subs(gr51r,1,10)
      if kopr=137
         gr2r='цiна              '
         gr6r =str(0,10,3)   // Изм кол-ва
         if dnn_r<ctod('01.03.2014')
            gr7r =str(0,10,3)  // Цена поставки
            gr8r =str(-bzenr,10,3)  // Изм цены
         else
            gr7r =str(0,10,2)  // Цена поставки
            gr8r =str(-bzenr,10,2)  // Изм цены
         endif
         gr9r =str(kfr,10,3)   // Кол-во поставки
      else
         gr2r='кiлькiсть         '
         gr6r =str(-kfr,10,3)   // Изм кол-ва
         if dnn_r<ctod('01.03.2014')
            gr7r =str(zenpr,10,3)  // Цена поставки
            gr8r =str(0,10,3)  // Изм цены
         else
            gr7r =str(zenpr,10,2)  // Цена поставки
            gr8r =str(0,10,2)  // Изм цены
         endif
         gr9r =str(0,10,3)   // Кол-во поставки
      endif
      gr10=ROUND(-kfr*bzenr,2)

      sgr10=sgr10+gr10
      gr10r=str(gr10,10,2)
      gr11r=space(10)  // 0%
      gr12r=space(10)  // Освобожденнные от НДС

      sele tdoc
      netadd()
      netrepl('gr1,gr2,gr3,gr4,gr5,gr6,gr7,gr8,gr9,gr10,gr11,gr12,rzd,gr51,gr52',;
      'gr1r,gr2r,gr3r,gr4r,gr5r,gr6r,gr7r,gr8r,gr9r,gr10r,gr11r,gr12r,1,gr51r,gr52r')
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
       hdndspn()
    endif
    hdndsp1n()
    sele tdoc
    go top
    do while !eof()
       if rzd#1
          skip
          loop
       endif
       listr='│'+gr1+'│'+gr2+'│'+gr3+'│'+gr4+'│'+gr5+'│'+gr6+'│'+gr7;
        +'│'+gr8+'│'+gr9+'│'+gr10+'│'+gr11+'│'+gr12+'│'
       ?listr
       lsten(3)
       sele tdoc
       skip
    endd
    ftndspn()
next
set prin off
set cons on
set prin to
retu .t.
*********************************************************************************
****************************
func pr1nn(p1,p2,p3,p4)
* Для клиентов с одной nnds  (pr1ndsr=1)
* nnds
* lpt
* к-во экз
* с квадратиками(для дебилов)
****************************

if gnArm#2
   retu .t.
endif

mnp_r=0

sm10_r=0
if p2#nil
   gnScOut=1
endif
nnds_r=p1
if !empty(p4)
   prdblr=1
else
   prdblr=0
endif
if alias()#'NNDS'
   sele nnds
   if !netseek('t1','nnds_r')
      wmess('Нет в NNDS',2)
      if p2#nil
         gnScOut=0
      endif
      retu .f.
   endif
endif

dnn_r=dnn
prxmlr=prxml
if !empty(nnds->dreg)
   prxmlr=1
endif

nnds_r=nnds
dnn_r=dnn
nnds1_r=nnds1
dnn1_r=dnn1
kklr=kkl

if nnds1#0
   mnp_r=1
endif

prdebilr=0

if kkl=3229489
   prdebilr=1
endif

if fieldpos('kto')#0
   if gnEnt=20
      netrepl('kto','145')
*      netrepl('kto','882')
   endif
   if gnEnt=21
      netrepl('kto','331')
   endif
   if nnds->kto#0
      nmndsr=getfield('t1','nnds->kto','speng','fio')
   else
      nmndsr=gcName
   endif
else
   nmndsr=gcName
endif

if gnArm=2.and.prndsktor=1
   nmndsr=getfield('t1','gnKto','speng','fio')
endif

sele dokk
set orde to tag t15
if !netseek('t15','nnds_r')
   wmess('Нет в DOKK',2)
   if p6#nil
      gnScOut=0
   endif
   retu .f.
endif
if select('lnndoc')#0
   sele lnndoc
   use
   erase lnndoc.dbf
endif
crtt('lnndoc','f:sk c:n(3) f:doc c:n(6) f:sm c:n(12,2)')
sele 0
use lnndoc
if select('lnnsk')#0
   sele lnnsk
   use
   erase lnnsk.dbf
endif
crtt('lnnsk','f:sk c:n(3)')
sele 0
use lnnsk
sele dokk
do while nnds=nnds_r
   skr=sk
   if mnp=0
      docr=rn
   else
      docr=mnp
   endif
   smr=bs_s
   sele lnndoc
   appe blank
   repl sk with skr,;
        doc with docr,;
        sm with smr
   sele lnnsk
   loca for sk=skr
   if !foun()
      appe blank
      repl sk with skr
   endif
   sele dokk
   skip
endd

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
nn2_r=nn
cnn2r=cnn
if dnn_r<ctod('01.12.2014') //.and.gnAdm=0
else
   if nn2r=0
      if dnn_r<ctod('01.01.2015')
         nn2r=400000000000
         cnn2r='400000000000'
      else
         nn2r=100000000000
         cnn2r='100000000000'
      endif
   endif
endif
if nn2_r#0
   adr2r=alltrim(adr)
   tlf2r=alltrim(tlf)
   nsv2r=alltrim(nsv)
else
   adr2r=''
   tlf2r=''
   nsv2r=''
endif
*cnn2r=cnn
*adr2r=alltrim(adr)
*tlf2r=alltrim(tlf)
*nsv2r=alltrim(nsv)

*if !(nn2r#0.and.!empty(nsv2r)).and.gnKto#331
*if nn2r=0.and.!(gnKto=331.or.gnAdm=1)
*   wmess('Не плательщик НДС',2)
*   if p6#nil
*      gnScOut=0
*   endif
*   retu .f.
*endif

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

fopr=1
if gnArm=2
   netuse('fop')
   go top
   rcfopr=recn()
   do while .t.
      sele fop
      go rcfopr
      rcfopr=slcf('fop',,,,,"e:fop h:'Код' c:n(2) e:nfop h:'Наименование' c:c(30)")
      if lastkey()=27
         exit
      endif
      go rcfopr
      fopr=fop
      if lastkey()=13
         exit
      endif
   endd
endif

if nnds1_r=0 // Расходы
   crtt('tdoc','f:gr1 c:c(3) f:gr2 c:c(10) f:gr3 c:c(46) f:gr4 c:c(10) f:gr5 c:c(5) f:gr6 c:c(10) f:gr7 c:c(10) f:gr8 c:c(12) f:gr9 c:c(10) f:gr10 c:c(10) f:gr11 c:c(10) f:gr12 c:c(12) f:rzd c:n(2) f:nn c:n(2) f:gr51 c:c(10) f:gr52 c:c(4)')
   *   A5
   sprnr=chr(27)+'E'+chr(27)+'&l1h25a0O'+chr(27)+'&l3C'+chr(27)+'(3R'+chr(27)+'(s0p29.00h0s1b4102T'+chr(27)
   nrowr=115
else // Возвраты
   crtt('tdoc',"f:gr1 c:c(10) f:gr2 c:c(18) f:gr3 c:c(46) f:gr4 c:c(10) f:gr5 c:c(5) f:gr6 c:c(10) f:gr7 c:c(10) f:gr8 c:c(10) f:gr9 c:c(10) f:gr10 c:c(10) f:gr11 c:c(10) f:gr12 c:c(10) f:rzd c:n(2) f:nn c:n(2) f:gr51 c:c(10) f:gr52 c:c(4)")
*   A5 Альбом
   sprnr=chr(27)+'E'+chr(27)+'&l1h25a1O'+chr(27)+'&l3C'+chr(27)+'(3R'+chr(27)+'(s0p29.00h0s1b4102T'+chr(27)
   nrowr=75
endif

sele 0
use tdoc excl
if p2=nil
   vlptr=0
   alpt={'lpt1','lpt2','lpt3','Файл'}
   vlptr=alert('ПЕЧАТЬ',alpt)
else
   vlptr=p6
endif
set cons off

if vlptr=1.or.vlptr=2.or.vlptr=3
   if p3=nil
      kkr=2
      @ 24,50 say 'Количество  экз.'
      @ 24,68 get kkr pict '9' valid kkr<4
      read
      if lastkey()=27
         if p2#nil
            gnScOut=0
          endif
         retu .f.
      endif
   else
      kkr=p3
   endif
else
   kkr=1
endif

if nnds1_r=0
   ndsrsa()
else
   ndspra()
endif

sele nnds
netrepl('dprn','date()')

if select('tdoc')#0
   sele tdoc
   use
endif
if select('lnndoc')#0
   sele lnndoc
   use
endif

retu .t.

**************
func ndsrsa(p1)
**************
sele lnnsk
go top
do while !eof()
   skr=sk
   sele cskl
   loca for sk=skr
   pathr=gcPath_d+alltrim(path)
   netuse('sgrp','sgrp'+str(skr,3),,1)
   netuse('rs2','rs2'+str(skr,3),,1)
   netuse('rs3','rs3'+str(skr,3),,1)
   sele lnnsk
   skip
endd
copy file(gcPath_a+'rs2.dbf') to lrs2.dbf
copy file(gcPath_a+'rs3.dbf') to lrs3.dbf

sele 0
use lrs2 excl
inde on str(mntov,7)+str(zen,15,3) tag t1
set orde to tag t1

sele 0
use lrs3 excl

sele lnndoc
go top
do while !eof()
   skr=sk
   ttnr=doc
   smr=sm
   sele ('rs2'+str(skr,3))
   if netseek('t1','ttnr')
      do while ttn=ttnr
         mntovr=mntov
         markr=getfield('t1','int(mntovr/10000)','sgrp'+str(skr,3),'mark')
         kvpr=kvp
         zenr=zen
         svpr=svp
         sele lrs2
         seek str(mntovr,7)+str(zenr,15,3)
         if !foun()
            appe blank
            repl mntov with mntovr,;
                 zen with zenr
         endif
         repl kvp with kvp+kvpr,;
              svp with svp+svpr
         if markr=1
            repl ttn with markr
         endif
         sele ('rs2'+str(skr,3))
         skip
      endd
      sele ('rs3'+str(skr,3))
      if netseek('t1','ttnr')
         do while ttn=ttnr
            kszr=ksz
            ssfr=ssf
            sele lrs3
            locate for ksz=kszr
            if !foun()
               appe blank
               repl ksz with kszr
            endif
            repl ssf with ssf+ssfr
            sele ('rs3'+str(skr,3))
            skip
         endd
      endif
   endif
   sele lnndoc
   skip
endd

prmk17r=0
nacr=0
skidr=0
sm61r=0
sm11r=0
sm12r=0
sm19r=0
sm90r=0
sm10r=0

sele lrs3
go top
do while !eof()
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
   sele lrs3
   skip
endd
if sm61r#0
   gr1r ='   '       // Раздел
*   gr2r =dtoc(dnn_r)  // Дата
    if dnn_r<ctod('01.03.2014') //.and.gnAdm=0
       gr2r =dtoc(dnn_r)  // Дата
    else
       gr2r =strtran(dtoc(dnn_r),'.','')  // Дата
    endif
*   gr2r =strtran(dtoc(dnn_r),'.','')  // Дата
   gr3r ='Товаро-транспортнi витрати                        '  // Наименование
   gr4r =space(10)
   gr5r ='посл.'   // Ед изм.
   gr6r ='     1.000'  // Кол-во
   if dnn_r<ctod('01.03.2014')
      gr7r =str(ttr,10,3)  // Цена поставки
   else
      gr7r =str(ttr,10,2)  // Цена поставки
   endif
   gr8r =str(ttr,12,2)  // 20%
   gr9r =space(10)  // 0%
   gr10r =space(10)  // 0% экспорт
   gr11r=space(10)  // Освобожденнные от НДС
   gr12r=space(12)  // Общая сумма
   sele tdoc
   netadd()
   netrepl('gr1,gr2,gr3,gr4,gr5,gr6,gr7,gr8,gr9,gr10,gr11,gr12,rzd,nn',;
   'gr1r,gr2r,gr3r,gr4r,gr5r,gr6r,gr7r,gr8r,gr9r,gr10r,gr11r,gr12r,2,1')
endif
if nacr#0
   gr1r ='   '       // Раздел
*   gr2r =dtoc(dnn_r)  // Дата
   if dnn_r<ctod('01.03.2014') //.and.gnAdm=0
      gr2r =dtoc(dnn_r)  // Дата
   else
      gr2r =strtran(dtoc(dnn_r),'.','')  // Дата
   endif
*   gr2r =strtran(dtoc(dnn_r),'.','')  // Дата
   gr3r =' Надано покупцю: | надбавка (+)                   '  // Наименование
   gr4r =space(10)
   gr5r ='посл.'   // Ед изм.
   gr6r ='     1.000'  // Кол-во
   if dnn_r<ctod('01.03.2014')
      gr7r =str(nacr,10,3)  // Цена поставки
   else
      gr7r =str(nacr,10,2)  // Цена поставки
   endif
   gr8r =str(nacr,12,2)  // 20%
   gr9r =space(10)  // 0%
   gr10r =space(10)  // 0% экспорт
   gr11r=space(10)  // Освобожденнные от НДС
   gr12r=space(12)  // Общая сумма
   sele tdoc
   netadd()
   netrepl('gr1,gr2,gr3,gr4,gr5,gr6,gr7,gr8,gr9,gr10,gr11,gr12,rzd,nn',;
   'gr1r,gr2r,gr3r,gr4r,gr5r,gr6r,gr7r,gr8r,gr9r,gr10r,gr11r,gr12r,1,2')
endif
if skidr#0
   gr1r ='   '       // Раздел
   if dnn_r<ctod('01.03.2014') //.and.gnAdm=0
      gr2r =dtoc(dnn_r)  // Дата
   else
      gr2r =strtran(dtoc(dnn_r),'.','')  // Дата
   endif
*   gr2r =strtran(dtoc(dnn_r),'.','')  // Дата
*   gr2r =dtoc(dnn_r)  // Дата
   gr3r =' Надано покупцю: | знижка   (-)                   '  // Наименование
   gr4r =space(10)
   gr5r ='посл.'   // Ед изм.
   gr6r ='     1.000'  // Кол-во
   if dnn_r<ctod('01.03.2014')
      gr7r =str(skidr,10,3)  // Цена поставки
   else
      gr7r =str(skidr,10,2)  // Цена поставки
   endif
   gr8r =str(skidr,12,2)  // 20%
   gr9r =space(10)  // 0%
   gr10r =space(10)  // 0% экспорт
   gr11r=space(10)  // Освобожденнные от НДС
   gr12r=space(12)  // Общая сумма
   sele tdoc
   netadd()
   netrepl('gr1,gr2,gr3,gr4,gr5,gr6,gr7,gr8,gr9,gr10,gr11,gr12,rzd,nn',;
   'gr1r,gr2r,gr3r,gr4r,gr5r,gr6r,gr7r,gr8r,gr9r,gr10r,gr11r,gr12r,1,3')
endif

sele lrs2
go top
do while !eof()
   mntovr=mntov
   markr=ttn
   if gnEnt=20.and.kklr=3229492
      if prmk17r=0
         mkeep_r=getfield('t1','mntovr','ctov','mkeep')
         if mkeep_r=17
            prmk17r=1
         endif
      endif
   endif
   kger=getfield('t1','mntovr','ctov','kge')
   if sm12r=0
      if int(mntovr/10000)=0
         skip
         loop
      endif
   endif
   gr1r ='   '       // Раздел
*   gr2r =dtoc(dnn_r)  // Дата
   if dnn_r<ctod('01.03.2014')
      gr2r =dtoc(dnn_r)  // Дата
   else
      gr2r =strtran(dtoc(dnn_r),'.','')  // Дата
   endif
*   gr2r =strtran(dtoc(dnn_r),'.','')  // Дата
   sele ctov
   netseek('t1','mntovr')
   nat_r=nat
*if empty(nat_r)
*wait
*endif
   if fieldpos('ukt')#0
      ukt_r=ukt
   else
      ukt_r=space(10)
   endif
   sele lrs2
   if markr=1.and.kger#0
      natr=alltrim(getfield('t1','kger','grpe','nge'))+' '+alltrim(nat_r)
   else
      kg_r=int(ktlr/1000000)
      if gnEnt=21.and.(kg_r=342.or.kg_r=343.or.kg_r=338.or.kg_r=339)
         natr=alltrim(getfield('t1','kger','grpe','nge'))+' '+alltrim(nat_r)
      else
         natr=nat_r
      endif
   endif
   natr=padr(natr,46)
   gr3r=subs(natr,1,46)
   gr4r =ukt_r
   gr5r =getfield('t1','mntovr','ctov','nei')   // Ед изм.
   kspovor =getfield('t1','mntovr','ctov','kspovo')   // Ед изм.
   gr52r=padl(alltrim(str(kspovor,4)),4,'0')
   gr51r=getfield('t1','kspovor','kspovo','upu')   // Ед изм.
   gr51r=subs(gr51r,1,10)
   gr6r =str(lrs2->kvp,10,3)  // Кол-во
   if dnn_r<ctod('01.03.2014')
      gr7r =str(lrs2->zen,10,3)  // Цена поставки
   else
      gr7r =str(lrs2->zen,10,2)  // Цена поставки
   endif
*   gr8r =str(lrs2->svp,12,2)  // 20%
   gr8_r=roun(lrs2->kvp*lrs2->zen,2)
   gr8r =str(gr8_r,12,2)  // 20%
   gr9r =space(10)  // 0%
   gr10r =space(10)  // 0% экспорт
   gr11r=space(10)  // Освобожденнные от НДС
   gr12r=space(12)  // Общая сумма
   sele tdoc
   netadd()
   netrepl('gr1,gr2,gr3,gr4,gr5,gr6,gr7,gr8,gr9,gr10,gr11,gr12,rzd,gr51,gr52',;
   'gr1r,gr2r,gr3r,gr4r,gr5r,gr6r,gr7r,gr8r,gr9r,gr10r,gr11r,gr12r,1,gr51r,gr52r')
   sele lrs2
   skip
endd
sele tdoc
inde on str(rzd,2)+str(nn,2) tag t1

if empty(p1)
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
       hdndsrn()
    endif
    hdndsr1n()
    sele tdoc
    go top
    sm10_r=0
    do while !eof()
       if rzd#1
          skip
          loop
       endif
       sm10_r=sm10_r+val(gr8)
       listr='│'+gr1+'│'+gr2+'│'+gr3+'│'+gr4+'│'+gr5+'│'+gr6+'│'+gr7;
        +'│'+gr8+'│'+gr9+'│'+gr10+'│'+gr11+'│'+gr12+'│'
       ?listr
       lsten(3)
       sele tdoc
       skip
    endd
    ftndsrn()
next
set prin off
set cons on
set prin to
endif

sele lnnsk
go top
do while !eof()
   skr=sk
   nuse('sgrp'+str(skr,3))
   nuse('rs2'+str(skr,3))
   nuse('rs3'+str(skr,3))
   sele lnnsk
   skip
endd
retu .t.

**************
func ndspra(p1)
**************
sele lnnsk
go top
do while !eof()
   skr=sk
   sele cskl
   loca for sk=skr
   pathr=gcPath_d+alltrim(path)
   netuse('sgrp','sgrp'+str(skr,3),,1)
   netuse('pr2','pr2'+str(skr,3),,1)
   netuse('pr3','pr3'+str(skr,3),,1)
   sele lnnsk
   skip
endd
if select('lpr2')#0
  sele lpr2
  use
  erase lpr2.dbf
endif
if select('lpr3')#0
  sele lpr3
  use
  erase lpr3.dbf
endif
copy file(gcPath_a+'pr2.dbf') to lpr2.dbf
copy file(gcPath_a+'pr3.dbf') to lpr3.dbf

sele 0
use lpr2 excl
inde on str(mntov,7)+str(zen,15,3)+str(zenttn,15,3)+str(zenpr,15,3)+str(ozen,15,3) tag t1
set orde to tag t1

sele 0
use lpr3 excl

sele lnndoc
go top
do while !eof()
   skr=sk
   mnr=doc
   ndr=mnr
   smr=sm
   sele ('pr2'+str(skr,3))
   if netseek('t1','mnr')
      do while mn=mnr
         mntovr=mntov
         markr=getfield('t1','int(mntovr/10000)','sgrp'+str(skr,3),'mark')
         kfr=kf
         zenr=zen
         sfr=sf
         zenttnr=zenttn
         zenprr=zenpr
         kfttnr=kfttn
         ozenr=ozen
         sele lpr2
         seek str(mntovr,7)+str(zenr,15,3)+str(zenttnr,15,3)+str(zenprr,15,3)+str(ozenr,15,3)
         if !foun()
            appe blank
            repl mntov with mntovr,;
                 zen with zenr,;
                 zenttn with zenttnr,;
                 zenpr with zenprr,;
                 ozen with ozenr
         endif
         repl kf with kf+kfr,;
              kfttn with kfttn+kfttnr,;
              sf with sf+sfr
         if markr=1
            repl mn with markr
         endif
         sele ('pr2'+str(skr,3))
         skip
      endd
      sele ('pr3'+str(skr,3))
      if netseek('t1','mnr')
         do while mn=mnr
            kszr=ksz
            ssfr=ssf
            sele lpr3
            locate for ksz=kszr
            if !foun()
               appe blank
               repl ksz with kszr
            endif
            repl ssf with ssf+ssfr
            sele ('pr3'+str(skr,3))
            skip
         endd
      endif
   endif
   sele lnndoc
   skip
endd

sm11r=0
sm12r=0
sm19r=0
sm90r=0
sm10r=0

sele lpr3
go top
do while !eof()
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
   if ksz=90
      sm90r=ssf
   endif
   sele lpr3
   skip
endd

*if (gnEnt=20.or.gnEnt=21).and.kop=110.and.vo=1
*   prvzznr=1
*else
*   prvzznr=0
*endif

store 0 to sgr10
sele lpr2
go top
do while !eof()
   if zenttn#0
      prvzznr=1
   else
      prvzznr=0
   endif
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
   sfr=sf
   mntovr=mntov
   markr=mn
   kger=getfield('t1','mntovr','ctov','kge')
   if int(mntovr/10000)<2
      sele lpr2
      skip
      loop
   endif
*   gr1r =dtoc(dnn_r)  // Дата
   if dnn_r<ctod('01.03.2014') //.and.gnAdm=0
      gr1r =dtoc(dnn_r)  // Дата
   else
      gr1r =strtran(dtoc(dnn_r),'.','')  // Дата
   endif
   if prvzznr=0
      gr2r='повернення товару '
   else
      gr2r='    змiна цiни    '
   endif
   sele ctov
   netseek('t1','mntovr')
   nat_r=nat
*if empty(nat_r)
*wait
*endif
   if fieldpos('ukt')#0
      ukt_r=ukt
   else
      ukt_r=space(10)
   endif
   sele lpr2
   if markr=1.and.kger#0
      natr=alltrim(getfield('t1','kger','grpe','nge'))+' '+alltrim(nat_r)
   else
      kg_r=int(ktlr/1000000)
      if gnEnt=21.and.(kg_r=342.or.kg_r=343.or.kg_r=338.or.kg_r=339)
         natr=alltrim(getfield('t1','kger','grpe','nge'))+' '+alltrim(nat_r)
      else
         natr=nat_r
      endif
   endif
   natr=padr(natr,46)
   gr3r=subs(natr,1,46)
   gr4r =ukt_r
   gr5r =getfield('t1','mntovr','ctov','nei')   // Ед изм.
   kspovor =getfield('t1','mntovr','ctov','kspovo')   // Ед изм.
   gr52r=padl(alltrim(str(kspovor,4)),4,'0')
   gr51r=getfield('t1','kspovor','kspovo','upu')   // Ед изм.
   gr51r=subs(gr51r,1,10)
   if prvzznr=0
      gr6r =str(-kfr,10,3)   // Изм кол-ва
      if dnn_r<ctod('01.03.2014')
         gr7r =str(zenr,10,3)  // Цена поставки
      else
         gr7r =str(zenr,10,2)  // Цена поставки
      endif
      gr8r =space(10)  // Изм цены
      gr9r =space(10)  // Кол-во поставки
*      gr10=ROUND(-kfr*zenr,2)
      gr10=-sfr
   else
      gr6r =space(10)  // Изм кол-ва
      gr7r =space(10)  // Цена поставки
      if dnn_r<ctod('01.03.2014')
         gr8r =str(-zenr,10,3)  // Изм цены
      else
         gr8r =str(-zenr,10,2)  // Изм цены
      endif
      gr9r =str(kfr,10,3)   // Кол-во поставки
      gr10=ROUND(-kfr*zenr,2)
*      gr10=-sfr
   endif
   sgr10=sgr10+gr10
   gr10r=str(gr10,10,2)
   gr11r=space(10)  // 0%
   gr12r=space(10)  // Освобожденнные от НДС

   sele tdoc
   netadd()
   netrepl('gr1,gr2,gr3,gr4,gr5,gr6,gr7,gr8,gr9,gr10,gr11,gr12,rzd,gr51,gr52',;
   'gr1r,gr2r,gr3r,gr4r,gr5r,gr6r,gr7r,gr8r,gr9r,gr10r,gr11r,gr12r,1,gr51r,gr52r')
   sele lpr2
   skip
enddo

sele tdoc
inde on str(rzd,2)+str(nn,2) tag t1
if empty(p1)
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
       if dnn_r<ctod('01.01.2015') //.and.gnAdm=0
          hdndspn()
       else
          if dnn_r<ctod('01.04.2016') //.and.gnAdm=0
             hdndspn3()
          else
             hdndspn4()
          endif
       endif
    endif
    if dnn_r<ctod('01.12.2014') //.and.gnAdm=0
       hdndsp1n()
    else
       if dnn_r<ctod('01.01.2015') //.and.gnAdm=0
          hdndsp2n()
       else
          if dnn_r<ctod('01.04.2016') //.and.gnAdm=0
             hdndsp3n()
          else
             hdndsp4n()
          endif
       endif
    endif
*    if nlstr=1
*       hdndspn()
*    endif
*    hdndsp1n()
    sele tdoc
    go top
    do while !eof()
       if rzd#1
          skip
          loop
       endif
       if dnn_r<ctod('01.12.2014') //.and.gnAdm=0
          listr='│'+gr1+'│'+gr2+'│'+gr3+'│'+gr4+'│'+gr5+'│'+gr6+'│'+gr7;
           +'│'+gr8+'│'+gr9+'│'+gr10+'│'+gr11+'│'+gr12+'│'
       else
          if dnn_r<ctod('01.01.2015') //.and.gnAdm=0
             listr='│'+gr1+'│'+gr2+'│'+gr3+'│'+gr4+'│'+gr5+'│'+gr6+'│'+gr7;
              +'│'+gr8+'│'+gr9+'│'+gr10+'│'+gr11+'│'+gr12+'│'+space(10)+'│'
          else
             if dnn_r<ctod('01.04.2016') //.and.gnAdm=0
                listr='│'+gr1+'│'+gr2+'│'+gr3+'│'+gr4+'│'+gr51+'│'+gr52+'│'+gr6+'│'+gr7;
                 +'│'+gr8+'│'+gr9+'│'+gr10+'│'+gr11+'│'+gr12+'│'+space(10)+'│'
             else
                listr='│'+gr1+'│'+gr2+'│'+gr3+'│'+gr4+'│'+gr51+'│'+gr52+'│'+gr6+'│'+gr7;
                 +'│'+gr8+'│'+gr9+'│'+gr10+'│'+gr11+'│'+gr12+'│'+space(10)+'│'
             endif
          endif
       endif
*       listr='│'+gr1+'│'+gr2+'│'+gr3+'│'+gr4+'│'+gr5+'│'+gr6+'│'+gr7;
*        +'│'+gr8+'│'+gr9+'│'+gr10+'│'+gr11+'│'+gr12+'│'
       ?listr
       lsten(3)
       sele tdoc
       skip
    endd
    if dnn_r<ctod('01.12.2014') //.and.gnAdm=0
       ftndspn()
    else
       if dnn_r<ctod('01.01.2015') //.and.gnAdm=0
          ftndsp2n()
       else
          if dnn_r<ctod('01.04.2016') //.and.gnAdm=0
             ftndsp3n()
          else
             ftndsp4n()
          endif
       endif
    endif
*    ftndspn()
next
set prin off
set cons on
set prin to
endif

sele lnnsk
go top
do while !eof()
   skr=sk
   nuse('sgrp'+str(skr,3))
   nuse('pr2'+str(skr,3))
   nuse('pr3'+str(skr,3))
   sele lnnsk
   skip
endd
retu .t.
