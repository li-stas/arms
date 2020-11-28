clea
netuse('s_tag')
netuse('stage')
netuse('stagt')
netuse('stagtm')
netuse('stagm')
netuse('cgrp')
netuse('kln')
netuse('swrd')
netuse('mkeep')
netuse('mkeepe')
netuse('kplkgp')
netuse('kpl')
netuse('kgp')
netuse('cskl')
netuse('tmesto')
netuse('etm')
netuse('klndog')
netuse('nap')
netuse('ktanap')
netuse('speng')
netuse('kgpcat')
netuse('sv')
sele s_tag
locate for kod=0
if foun()
   if reclock()
      netblank()
      dbunlock()
   endif   
endif
uvol_r=0
ksv_r=0
if gnEnt=20
   for_r='.t..and.uvol=uvol_r'
else
   for_r='.t..and.ent=gnEnt.and.uvol=uvol_r'
endif   
forr=for_r
prf1r=0
sele s_tag
go top
rcktar=recn()
do while .t.
   sele s_tag
   set orde to tag t2
   go rcktar
   if prf1r=0
      foot('F2,F3,F4,F5,F6,F7,F8,F9,ENTER','Тест,Фильтр,Корр,Гр,Напр,SW,МД,Док,ТМ')
   else
      foota('F2','Тест KTAS')
   endif
   if fieldpos('ksv')=0
      rcktar=slcf('s_tag',1,,18,,"e:kod h:'Код' c:n(4) e:fio h:'   Ф.  И.  О.  ' c:c(30) e:ktas h:'SW' c:n(4) e:deviceid h:'PALM' c:n(3) e:krj h:'Р' c:n(2) e:ent h:'ENT' c:n(2) e:agsk h:'SK' c:n(3) e:prexte h:'EXT' c:n(1) e:uvol h:'Ув' c:n(1) e:exte h:'EXTE' c:n(1)",,,1,,forr,,'АГЕНТЫ')
   else
      rcktar=slcf('s_tag',1,,18,,"e:kod h:'Код' c:n(4) e:fio h:'   Ф.  И.  О.  ' c:c(30) e:ktas h:'SW' c:n(4) e:deviceid h:'PALM' c:n(3) e:krj h:'Р' c:n(2) e:ent h:'ENT' c:n(2) e:agsk h:'SK' c:n(3) e:prexte h:'EXT' c:n(1) e:uvol h:'Ув' c:n(1) e:exte h:'EXTE' c:n(1) e:ksv h:'SV' c:n(4)",,,1,,forr,,'АГЕНТЫ')
   endif   
   go rcktar
   fior=fio
   ktasr=ktas
   nktasr=getfield('t1','ktasr','s_tag','fio')
   go rcktar
   ktar=kod
   nktar=fio
   deviceidr=deviceid
   krjr=krj
   entr=ent
   agskr=agsk
   skpodr=skpod
   uvolr=uvol
   kta19r=kta19
   ppcdebr=ppcdeb
   ktakklr=ktakkl
   prexter=prexte
   exter=exte
   centr=cent
   uvolr=uvol
   platr=plat
   if fieldpos('ksv')#0
      ksvr=ksv
   else
      ksvr=0
   endif
   nsvr=getfield('t1','ksvr','sv','nsv')
   if fieldpos('idlod')#0
      idlodr=idlod
   else
      idlodr=0
   endif
   do case
      case lastkey()=28 && F1
           if prf1r=0
              prf1r=1
           else
              prf1r=0
           endif
      case lastkey()=27
           exit
      case lastkey()=22
           ktains()
      case lastkey()=7.and.gnAdm=1.and.gnEntrm=0
           netdel()
           skip -1
           if bof()
              go top
           endif
      case lastkey()=-1
           ktatest()
      case lastkey()=-2
           ktaflt()
      case lastkey()=-3
           if kod#0
              ktains(1)
           else
              if gnAdm=1
                 ktains(1)
              endif
           endif   
      case lastkey()>32.and.lastkey()<255
           sele s_tag
           lstkr=upper(chr(lastkey()))
           if !netseek('t2','lstkr')
              go rcktar
           endif
      case lastkey()=-4 && Группы
           stage()
      case lastkey()=-5 && Точки
           ktanap()
*      case lastkey()=-35 && Торговые места
*           stagtm()
      case lastkey()=-6.and.ktas#0 && SW
           sw()
      case lastkey()=-7 && МД
           stagm()
      case lastkey()=-8 && Документы
           stagdoc()
      case lastkey()=13 && Торговые места
           stagtm()
*           kplkgp()
      case lastkey()=-31 && Тест KTAS
           ktastest()
   endc
enddo
nuse()

func ktains(p1)
if p1=nil
   store 0 to ktasr,deviceidr,agskr,ppcdebr,ktakklr,ktar,ktasr,idlodr,ksvr
   centr=str(gnEnt,2)
   fior=space(30)
   nsvr=space(20)
   kta19r=space(15)
   sele s_tag
   set orde to tag t1
   for i=1 to 999
       sele s_tag
       locate for kod=i
       if !foun()
          ktar=i 
          exit
       endif
   next
   if ktar=0
      go bott
      ktar=kod+1
   endif   
   if netseek('t1','ktar')
      wmess('Ошибка добавления нового кода')
      retu
   endif
endif
clpodrins=setcolor('gr+/b,n/w')
wpodrins=wopen(3,15,20,60)
wbox(1)
do while .t.
   @ 0,1 say 'Ф.И.О.      ' get fior
   @ 1,1 say 'Код суперв. ' get ktasr pict '9999'
   @ 1,col()+1 say getfield('t1','ktasr','s_tag','fio')
   @ 2,1 say 'PALM        ' get deviceidr pict '999'
   @ 3,1 say 'Для экспед. ' get krjr pict '9'
   @ 4,1 say 'Подразделен.' get skpodr pict '9999'
   @ 5,1 say 'Уволен      ' get uvolr pict '9'
   @ 6,1 say 'Предприятие ' get entr pict '99'
   @ 7,1 say 'Склад       ' get agskr pict '999'
   @ 8,1 say 'Код Славутич' get kta19r
   @ 9,1 say 'Деб для КПК ' get ppcdebr pict '9'
   @ 10,1 say 'Код СПД     ' get ktakklr pict '9999999'
   @ 11,1 say 'Внешний стар' get prexter pict '9'
   @ 12,1 say 'Внешний     ' get exter pict '9'
   @ 13,1 say 'Платежи     ' get platr pict '9'
   if gnEnt=21
      @ 14,1 say 'Код Sales   ' get idlodr pict '9999999'
   else   
      @ 14,1 say 'Код Супер' get ksvr pict '9999'
      @ 14,col()+1 say nsvr
   endif   
   @ 15,1 prom '<Верно>'
   @ 15,col()+1 prom '<Не верно>'
   read
   if lastkey()=27
      exit
   endif
   fior=upper(fior)
   fior=alltrim(fior)
   menu to mpodrr
   if mpodrr=1 
      if p1=nil.and.gnEntrm=0
         if entr=0
            if ktasr=0  
               entr=gnEnt
            else  
               entr=getfield('t1','ktasr','s_tag','ent')
            endif
         endif
         if !netseek('t1','ktar')
            netadd()
            netrepl('kod,fio,ktas,deviceid,agsk,ent','ktar,fior,ktasr,deviceidr,agskr,gnEnt')
            netrepl('krj','krjr')
            netrepl('skpod,uvol','skpodr,uvolr')
            netrepl('kta19','kta19r')
            netrepl('ppcdeb','ppcdebr')
            netrepl('ktakkl','ktakklr')
            netrepl('prexte','prexter')
            netrepl('exte','exter')
            netrepl('cent','centr')
            netrepl('kto','gnKto')
            netrepl('plat','platr')
            if fieldpos('ksv')#0
               netrepl('ksv','ksvr')
            endif
            if fieldpos('idlod')#0
               netrepl('idlod','idlodr')
            endif
            exit
         else
            wselect(0)
            save scre to scpodrins
            mess('Такой код существует',1)
            rest scre from scpodrins
            wselect(wpodrins)
         endif
      else
         if netseek('t1','ktar')
            if gnEntrm=0
               netrepl('fio,ktas,deviceid,agsk','fior,ktasr,deviceidr,agskr')
            else
               netrepl('deviceid','deviceidr')
            endif   
            netrepl('krj','krjr')
            netrepl('ent','entr')
            netrepl('skpod,uvol','skpodr,uvolr')
            netrepl('kta19','kta19r')
            netrepl('ppcdeb','ppcdebr')
            netrepl('ktakkl','ktakklr')
            netrepl('prexte','prexter')
            netrepl('exte','exter')
            netrepl('cent','centr')
            netrepl('plat','platr')
            if fieldpos('ksv')#0
               netrepl('ksv','ksvr')
            endif
            if fieldpos('idlod')#0
               netrepl('idlod','idlodr')
            endif
            exit
         endif
      endif
   endif
enddo
wclose(wpodrins)
setcolor(clpodrins)
retu

***************
func ktaflt()
***************
store 0 to ktasr,kta_r,ksv_r
entr=gnEnt
clpodrins=setcolor('gr+/b,n/w')
wktaflt=wopen(10,25,15,45)
wbox(1)
do while .t.
   @ 0,1 say 'Код суперв. ' get ktasr pict '9999'
   @ 1,1 say 'Код агента  ' get kta_r  pict '9999'
      @ 2,1 say 'Уволен 0,1  ' get uvol_r  pict '9'
*   if gnEnt=20
*      @ 3,1 say 'Супервайзер ' get ksv_r  pict '9999'
*   endif   
   read
   if lastkey()=27
      exit
   endif
   do case
      case ktasr=0
           forr=for_r
      case ktasr=9999
           forr=for_r+'.and.s_tag->kod=s_tag->ktas'
      case ktasr#0
           forr=for_r+'.and.ktas=ktasr'
   endc
   if kta_r#0
      sele s_tag
      if netseek('t1','kta_r')
         forr=for_r
         rcktar=recn()
      endif
      exit
   endif
*   sele s_tag
*   if fieldpos('ksv')#0
*      if ksv_r=0
*         forr=for_r
*      else
*         forr=for_r+'.and.s_tag->ksv=ksv_r'
*      endif
*   endif   
   sele s_tag
*   do case
*      case uvol_r=0 
*           forr=forr
*      case uvol_r=1 
*           forr=forr+'.and.uvol=1'
*      case uvol_r=2 
*           forr=forr+'.and.uvol=0'
*      other     
*           forr=forr
*   endc
   sele s_tag
   go top
   rcktar=recn()
   exit
enddo
wclose(wktaflt)
setcolor(clpodrins)
retu

func stage()
* Группы
save scre to scste
sele stage
go top
forer='kta=ktar'
do while .t.
   sele stage
   foot('INS,DEL,F4','Добавить,Удалить,Коррекция')
   rcstager=slcf('stage',,,,,"e:kg h:'Код' c:n(3) e:getfield('t1','stage->kg','cgrp','ngr') h:'Группа' c:c(20) e:izg h:'Код' c:n(7) e:getfield('t1','stage->izg','kln','nkl') h:'Изготовитель' c:c(40)",,,1,,forer,,alltrim(nktar))
   go rcstager
   do case
      case lastkey()=27
           exit
      case lastkey()=22
           stageins()
      case lastkey()=7.and.gnEntrm=0
           netdel()
           skip -1
           if bof()
              go top
           endif
   endc
endd
rest scre from scste
retu

func stageins()
store 0 to kg_r,izg_r
clstei=setcolor('gr+/b,n/w')
wstei=wopen(10,25,14,50)
wbox(1)
do while .t.
   @ 0,1 say 'Группа      ' get kg_r pict '999'
   @ 1,1 say 'Изготовитель' get izg_r pict '99999999'
   read
   if lastkey()=27
      exit
   endif
   @ 2,1 prom 'Верно'
   @ 2,col()+1 prom 'Не Верно'
   menu to vn
   if lastkey()=27
      exit
   endif
   if vn=1.and.gnEntrm=0
      netadd()
      netrepl('kta,kg,izg','ktar,kg_r,izg_r')
   endif
   exit
enddo
wclose(wstei)
setcolor(clstei)
retu

func stagt()
* Точки
save scre to scstt
sele stagt
go top
forer='kta=ktar'
do while .t.
   sele stagt
   foot('INS,DEL,F2,F9','Добавить,Удалить,Маска,Доб(Авт)')
   rcstagtr=slcf('stagt',,,,,"e:iif(netseek('t4','stagt->kta,stagt->kgp','kplkgp'),1,0) h:'П' c:n(1) e:kgp h:'Код' c:n(7) e:getfield('t1','stagt->kgp','kln','nkl') h:'Грузополучатель' c:c(40) e:wmsk h:'ПВСЧПСВ' c:c(7)",,,1,,forer,,alltrim(nktar))
   go rcstagtr
   wmskr=wmsk
   kgpr=kgp
   do case
      case lastkey()=27
           exit
      case lastkey()=22
           stagtins()
      case lastkey()=7.and.gnEntrm=0
           netdel()
           skip -1
           if bof()
              go top
           endif
      case lastkey()=-1
           wmsk('stagt')
      case lastkey()=-8
        IF .T.
            wmess('Cправочник обновляется в ручную',2)
        ELSE
           stagtia()
        ENDIF
   endc
endd
rest scre from scstt
retu

func stagtins()
store 0 to kgpr
clstti=setcolor('gr+/b,n/w')
wstti=wopen(10,25,13,50)
wbox(1)
do while .t.
   @ 0,1 say 'Грузополучатель' get kgpr pict '9999999'
   read
   if lastkey()=27
      exit
   endif
   @ 1,1 prom 'Верно'
   @ 1,col()+1 prom 'Не Верно'
   menu to vn
   if lastkey()=27
      exit
   endif
   if vn=1.and.gnEntrm=0
      netadd()
      netrepl('kta,kgp','ktar,kgpr')
   endif
   exit
enddo
wclose(wstti)
setcolor(clstti)
retu

func sw()
* SW
save scre to scsw
sele swrd
go top
forwr='ktas=ktasr'
do while .t.
   sele swrd
   foot('INS,DEL,F4','Добавить,Удалить,Коррекция')
   rcswr=slcf('swrd',,,,,"e:mkeep h:'Код' c:n(2) e:getfield('t1','swrd->mkeep','mkeep','nmkeep') h:'МД' c:c(10) e:kg h:'Код' c:n(3) e:getfield('t1','swrd->kg','cgrp','ngr') h:'Группа' c:c(15) e:izg h:'Код' c:n(7) e:getfield('t1','swrd->izg','kln','nkl') h:'Изготовитель' c:c(20) e:prreal h:'%Р' c:n(6,2) e:prdoh h:'%Д' c:n(6,2)",,,1,,forwr,,alltrim(nktasr))
   go rcswr
   mkeep_r=mkeep
   kg_r=kg
   izg_r=izg
   prreal_r=prreal
   prdoh_r=prdoh
   nmkeep_r=getfield('t1','mkeep_r','mkeep','nmkeep')
   ng_r=getfield('t1','kg_r','cgrp','ngr')
   nizg_r=getfield('t1','izg_r','kln','nkl')
   do case
      case lastkey()=27
           exit
      case lastkey()=22
           swins()
      case lastkey()=-3
           swins(1)
      case lastkey()=7.and.gnEntrm=0
           netdel()
           skip -1
           if bof()
              go top
           endif
   endc
endd
rest scre from scsw
retu

func swins(p1)
if p1=nil
   store 0 to mkeep_r,kg_r,izg_r,prreal_r,prdoh_r
   store '' to nmkeep_r,ng_r,nizg_r
endif
clktai=setcolor('gr+/b,n/w')
wktai=wopen(10,10,17,70)
wbox(1)
do while .t.
   if p1=nil
      @ 0,1 say 'Маркодержатель' get mkeep_r pict '99'
      @ 1,1 say 'Изготовитель  ' get izg_r pict '99999999'
      @ 2,1 say 'Группа        ' get kg_r pict '999'
   else
      @ 0,1 say 'Маркодержатель'+' '+str(mkeep_r,2)+' '+nmkeep_r
      @ 1,1 say 'Изготовитель  '+' '+str(izg_r,7)+' '+nizg_r
      @ 2,1 say 'Группа        '+' '+str(kg_r,3)+' '+ng_r
   endif
   @ 3,1 say '% реализации' get prreal_r pict '999.99'
   @ 4,1 say '% дохода    ' get prdoh_r pict '999.99'
   read
   if lastkey()=27
      exit
   endif
   nmkeep_r=getfield('t1','mkeep_r','mkeep','nmkeep')
   ng_r=getfield('t1','kg_r','cgrp','ngr')
   nizg_r=getfield('t1','izg_r','kln','nkl')
   if p1=nil
      @ 0,1 say 'Маркодержатель'+' '+str(mkeep_r,2)+' '+nmkeep_r
      @ 1,1 say 'Изготовитель  '+' '+str(izg_r,7)+' '+nizg_r
      @ 2,1 say 'Группа        '+' '+str(kg_r,3)+' '+ng_r
   endif
   @ 5,1 prom 'Верно'
   @ 5,col()+1 prom 'Не Верно'
   menu to vn
   if lastkey()=27
      exit
   endif
   if vn=1.and.gnEntrm=0
      sele swrd
      if !netseek('t1','ktasr,mkeep_r,izg_r,kg_r')
         netadd()
         netrepl('ktas,mkeep,izg,kg,prreal,prdoh',;
                 'ktasr,mkeep_r,izg_r,kg_r,prreal_r,prdoh_r')
      else
         netrepl('prreal,prdoh',;
                 'prreal_r,prdoh_r')
      endif
      exit
   endif
enddo
wclose(wktai)
setcolor(clktai)
retu

func kplkgp()
sele kplkgp
set orde to tag t3
netseek('t3','ktar')
do while .t.
   sele kplkgp
   set orde to tag t3
   foot('INS,DEL,F2,F5,F6','Добавить,Удалить,Маска,Копировать,Оновить')
   rckplkgp=slcf('kplkgp',,,,,"e:iif(netseek('t1','kplkgp->kta,kplkgp->kgp','stagt'),1,0) h:'П' c:n(1) e:kpl h:'КодП' c:n(7) e:getfield('t1','kplkgp->kpl','kln','nkl') h:'Плательщик' c:c(25) e:kgp h:'КодГ' c:n(7) e:getfield('t1','kplkgp->kgp','kln','nkl') h:'Грузополучатель' c:c(25) e:wmsk h:'ПВСЧПСВ' c:c(7)",,,,'kta=ktar',,,str(ktar,4)+' '+alltrim(nktar))
   if lastkey()=27
      exit
   endif
   sele kplkgp
   go rckplkgp
   kplr=kpl
   kgpr=kgp
   wmskr=wmsk
   do case
      case lastkey()=22
           kplkgpins1()
           sele kplkgp
      case lastkey()=7.and.gnEntrm=0
           sele kplkgp
           go rckplkgp
           netdel()
           skip -1
           if bof().or.kta#ktar
              netseek('t3','ktar')
           endif
      case lastkey()=-1 && Маска
           wmsk('kplkgp')
      case lastkey()=-4 && Копировать
           ktacopy()
      case lastkey()=-5
        IF .T.
            wmess('Cправочник обновляется в ручную',2)
        ELSE
           kplkgpins()
           sele kplkgp
           netseek('t3','ktar')
        ENDIF
   endc
endd
retu .t.

func kplkgpins1()
clkpl1i=setcolor('gr+/b,n/w')
wkpl1i=wopen(10,10,14,70)
wbox(1)
do while .t.
   store 0 to kpl_r,kgp_r
   @ 0,1 say 'Плательщик     ' get kpl_r pict '9999999' valid kpl1i()
   @ 1,1 say 'Грузополучатель' get kgp_r pict '9999999' valid kgp1i()
   read
   if lastkey()=27
      exit
   endif
   @ 2,1 prom 'Верно'
   @ 2,col()+1 prom 'Не верно'
   menu to vn1r
   if lastkey()=27
      exit
   endif
   if vn1r=1.and.gnEntrm=0
      sele kplkgp
      if !netseek('t3','ktar,kpl_r,kgp_r')
         netadd()
         netrepl('kta,kpl,kgp','ktar,kpl_r,kgp_r')
         rckplkgpr=recn()
         exit
      else
         wmess('уже есть',1)
      endif
   endif
endd
wclose(wkpl1i)
setcolor(clkpl1i)
retu .t.

func kpl1i()
nkpl_r=getfield('t1','kpl_r','kln','nkl')
if empty(nkpl_r)
   wmess('Нет в клиентах',1)
   retu .f.
endif
if !netseek('t1','kpl_r','kpl')
   wmess('Нет в плательщиках',1)
   retu .f.
endif
@ 0,25 say nkpl_r
retu .t.

func kgp1i()
ngp_r=getfield('t1','kgp_r','kln','nkl')
if empty(ngp_r)
   wmess('Нет в клиентах',1)
   retu .f.
endif
if !netseek('t1','kgp_r','kgp')
   wmess('Нет в грузополучателях',1)
   retu .f.
endif
if !netseek('t1','ktar,kgp_r','stagt')
   wmess('Нет в точках',1)
   retu .f.
endif
@ 1,25 say ngp_r
retu .t.

func kplkgpins()
if gnEntrm#0
   retu .t.
endif
dt1r=bom(gdTd)
dt2r=gdTd
clkpli=setcolor('gr+/b,n/w')
wkpli=wopen(10,10,12,70)
wbox(1)
@ 0,1 say 'Период ' get dt1r
@ 0,col()+1 get dt2r
read
if lastkey()=13
   netuse('cskl')
   for g=year(dt1r) to year(dt2r)
       if year(dt1r)=year(dt2r)
          m1=month(dt1r)
          m2=month(dt2r)
       else
          do case
             case g=year(dt1r)
                  m1=month(dt1r)
                  m2=12
             case g=year(dt2r)
                  m1=1
                  m2=month(dt2r)
             othe
                  m1=1
                  m2=12
          endc
       endif
       for m=m1 to m2
           path_d=gcPath_e+'g'+str(g,4)+'\m'+iif(m<10,'0'+str(m,1),str(m,2))+'\'
           sele cskl
           do while !eof()
              if !(ent=gnEnt.and.rasc=1)
                 sele cskl
                 skip
                 loop
              endif
              pathr=path_d+alltrim(path)
              if !netfile('rs1',1)
                 sele cskl
                 skip
                 loop
              endif
              mess(pathr)
              netuse('rs1',,,1)
              sele rs1
              do while !eof()
                 if vo#9
                    sele rs1
                    skip
                    loop
                 endif
                 ktar=kta
                 store 0 to kgpr,kplr
                 if !(kop=191.or.kop=196.or.kop=169.or.kop=168)
                    kplr=kpl
                    kgpr=kgp
                 else
                    if nkkl#0
                       kplr=kpl
                    else
                       kplr=kpl
                    endif
                    if kpv#0
                       kgpr=kpv
                    else
                       kgpr=kgp
                    endif
                 endif
                 if ktar#0.and.kplr#0.and.kgpr#0.and.!(kplr=20034.or.kplr=20540).and.!(kgpr=20034.or.kgpr=20540)
                    sele kplkgp
                    if !netseek('t1','kplr,kgpr')
                       netadd()
                       netrepl('kta,kpl,kgp','ktar,kplr,kgpr')
                    else
                       if netseek('t1','kplr,kgpr,0')
                          netrepl('kta','ktar')
                       else
                          if !netseek('t1','kplr,kgpr,ktar')
                             netadd()
                             netrepl('kta,kpl,kgp','ktar,kplr,kgpr')
                          endif
                       endif
                    endif
                 endif
                 sele rs1
                 skip
              endd
              nuse('rs1')
              sele cskl
              skip
           endd
       next
   next
   nuse('cskl')
endif
wclose(wkpli)
setcolor(clkpli)
retu .t.

func wmsk(p1)
*local w1r,w2r,w3r,w4r,w5r,w6r,w7r,aaa,cwr
* p1 - dbf
store 0 to w1r,w2r,w3r,w4r,w5r,w6r,w7r,nwr
aaa=''
wmsk_r=''
cwr=''
for ii=1 to 7
    cwr='w'+str(ii,1)+'r'
    &cwr=val(subs(wmskr,ii,1))
next
clwmsk=setcolor('gr+/b,n/w')
wwmsk=wopen(10,10,13,70)
wbox(1)
@ 0,1 say 'Маска  Пн Вт Ср Чт Пт Сб Вс'
@ 1,9 get w1r pict '9'
@ 1,col()+2 get w2r pict '9'
@ 1,col()+2 get w3r pict '9'
@ 1,col()+2 get w4r pict '9'
@ 1,col()+2 get w5r pict '9'
@ 1,col()+2 get w6r pict '9'
@ 1,col()+2 get w7r pict '9'
read
wclose(wwmsk)
setcolor(clwmsk)

for ii=1 to 7
    cwr='w'+str(ii,1)+'r'
    nwr=&cwr
    if nwr>0
       aaa='1'
    else
       aaa=' '
    endif
    wmsk_r=wmsk_r+aaa
next
sele (p1) &&kplkgp
netrepl('wmsk','wmsk_r')
do case
   case p1='stagt'
        sele kplkgp
        set orde to tag t4
        if netseek('t4','ktar,kgpr').and.gnEntrm=0
           do while kta=ktar.and.kgp=kgpr
              netrepl('wmsk','wmsk_r')
              skip
           endd
        endif
   case p1='kplkgp'
        sele stagt
        if netseek('t1','ktar,kgpr').and.gnEntrm=0
           netrepl('wmsk','wmsk_r')
        endif
   case p1='tstagtm'
        sele stagtm
        if netseek('t1','ktar,tmestor').and.gnEntrm=0
           netrepl('wmsk','wmsk_r')
        endif
endc
retu .t.

func kgpcat()
clea
netuse('kgpcat')
rckgpcatr=recn()
netuse('catt')
netuse('mkeep')
netuse('brand')
netuse('cgrp')
netuse('ctov')
set orde to tag t2
go top
do while .t.
   sele kgpcat
   go rckgpcatr
   foot('INS,DEL,F4,ENTER','Добавить,Удалить,Коррекция,Бренды')
   rckgpcatr=slcf('kgpcat',,,,,"e:kgpcat h:'Код' c:n(2) e:nkgpcat h:'Наименование' c:c(20)",,,1,,,,'Категории ГП')
   if lastkey()=27
      exit
   endif
   go rckgpcatr
   kgpcatr=kgpcat
   nkgpcatr=nkgpcat
   do case
      case lastkey()=22 &&INS
           kgpcati(0)
      case lastkey()=-3 &&CORR
           kgpcati(1)
      case lastkey()=7.and.gnEntrm=0  &&Del
           netdel()
           skip -1
           if bof()
              go top
           endif
      case lastkey()=13 && ТМ
           catt()
   endc
endd
nuse()
retu .t.

func kgpcati(p1)
clcati=setcolor('gr+/b,n/w')
wcati=wopen(10,15,13,60)
wbox(1)
if p1=0
   kgpcatr=0
   nkgpcatr=space(20)
endif
cativr=1
do while .t.
   if p1=0
      @ 0,1 say 'Код' get kgpcatr pict '99'
   else
      @ 0,1 say 'Код'+' '+str(kgpcatr,2)
   endif
   @ 0,col()+1 get nkgpcatr
   @ 1,1 prom 'Верно'
   @ 1,col()+1 prom 'Не Верно'
   read
   if lastkey()=27
      exit
   endif
   menu to cativr
   if cativr=1.and.gnEntrm=0
      sele kgpcat
      if p1=0
         if netseek('t1','kgpcatr')
            wmess('Такой код уже есть',1)
            kgpcatr=0
            nkgpcatr=space(20)
            loop
         endif
         netadd()
         netrepl('kgpcat,nkgpcat','kgpcatr,nkgpcatr')
         exit
      else
         netrepl('nkgpcat','nkgpcatr')
         exit
      endif
   endif
endd
wclose(wcati)
setcolor(clcati)
retu .t.

func catt()
sele catt
go top
rccattr=recn()
do while .t.
   sele catt
   go rccattr
   foot('INS,DEL,F4','Добавить,Удалить,Коррекция')
   rccattr=slcf('catt',,,,,"e:mkeep h:'Код' c:n(3) e:getfield('t1','catt->mkeep','mkeep','nmkeep') h:'ТМ' c:c(18) e:brand h:'Код' c:n(10) e:getfield('t1','catt->brand','brand','nbrand') h:'Бренд' c:c(27) e:kolmrch() h:'Поз' c:n(5) e:kol h:'Кол' c:n(5)",,,,,'kgpcat=kgpcatr',,alltrim(nkgpcatr))
   if lastkey()=27
      exit
   endif
   go rccattr
   mkeepr=mkeep
   brandr=brand
   kolr=kol
   do case
      case lastkey()=22 &&INS
           catti()
      case lastkey()=-3 &&CORR
           cattc()
      case lastkey()=7.and.gnEntrm=0  &&Del
           netdel()
           skip -1
           if bof()
              go top
           endif
           rccattr=recn()
   endc
endd
retu .t.

func kolmrch()
kolmrchr=0
sele ctov
set orde to tag t7
if netseek('t7','catt->brand')
   do while brand=catt->brand
      if merch=1 
         kolmrchr=kolmrchr+1
      endif   
      skip
   endd
endif
sele catt
retu kolmrchr

func catti(p1)
sele 0
use _slct alias sl excl
zap
sele mkeep
go top
rcmkeepr=recn()
do while .t.
   sele mkeep
   go rcmkeepr
   foot('ENTER','Выбор')
   rcmkeepr=slcf('mkeep',,,,,"e:mkeep h:'Код' c:n(3) e:nmkeep h:'Наименование' c:c(20)",,,,,,,'ТМ')
   if lastkey()=27
      exit
   endif  
   go rcmkeepr
   mkeepr=mkeep
   nmkeepr=nmkeep   
   do case
      case lastkey()=13
           sele brand
           set orde to tag t2
           if netseek('t2','mkeepr')
              rcbrandr=recn()
           else   
              go top
              rcbrandr=recn()
           endif   
           do while .t.
              sele brand
              go rcbrandr
              foot('SPACE,ENTER','Отбор,Добавить')
              rcbrandr=slcf('brand',,,,,"e:brand h:'Код' c:n(10) e:nbrand h:'Наименование' c:c(40)",,1,,'mkeep=mkeepr',,,alltrim(nmkeepr))
              if lastkey()=27
                 exit
              endif     
              do case
                 case lastkey()=13
                      sele sl
                      go top
                      do while !eof()
                         rcr=val(kod)
                         sele brand
                         go rcr
                         brandr=brand
                         sele catt
                         if !netseek('t1','kgpcatr,mkeepr,brandr').and.gnEntrm=0
                            netadd()
                            netrepl('kgpcat,mkeep,brand','kgpcatr,mkeepr,brandr')
                            rccattr=recn()
                         endif
                         sele sl
                         skip
                      endd
                      sele sl
                      zap
                      use
                      exit
              endc        
              sele mkeep
           endd    
   endc        
endd
retu .t.

func cattc()
sele catt
clcp=setcolor('gr+/b,n/w')
wcp=wopen(10,10,13,70)
wbox(1)
do while .t.
   @ 0,1 say 'Количество' get kolr pict '99999999.999'
   read
   if lastkey()=27
      exit
   endif
   @ 1,1 prom 'Верно'
   @ 1,col()+1 prom 'Не Верно'
   menu to mcpr
   if lastkey()=27
      exit
   endif
   if mcpr=1.and.gnEntrm=0
      netrepl('kol','kolr')
      exit
   endif
endd      
wclose(wcp)
setcolor(clcp)
retu .t.

func ktacopy()
if gnEntrm#0
   retu .t.
endif
clcp=setcolor('gr+/b,n/w')
wcp=wopen(10,10,13,70)
wbox(1)
do while .t.
   kta_r=0
   @ 0,1 say 'Агент источник' get kta_r pict '9999'
   read
   if lastkey()=27
      exit
   endif
   @ 1,1 prom 'Верно'
   @ 1,col()+1 prom 'Не Верно'
   menu to mcpr
   if lastkey()=27
      exit
   endif
   if mcpr=1
      sele kplkgp
      set orde to tag t3
      if netseek('t3','kta_r')
         copy to ktatemp while kta=kta_r
         sele 0
         use ktatemp
         go top
         do while !eof()
            kplr=kpl
            kgpr=kgp
            sele kplkgp
            if !netseek('t3','ktar,kplr,kgpr')
               netadd()
               netrepl('kta,kpl,kgp','ktar,kplr,kgpr')
            endif
            sele ktatemp
            skip
         endd
         sele ktatemp
         use
         erase ktatemp.dbf
      endif
      sele stagt
      set orde to tag t1
      if netseek('t1','kta_r')
         copy to ktatemp while kta=kta_r
         sele 0
         use ktatemp
         go top
         do while !eof()
            kgpr=kgp
            sele stagt
            if !netseek('t1','ktar,kgpr')
               netadd()
               netrepl('kta,kgp','ktar,kgpr')
            endif
            sele ktatemp
            skip
         endd
         sele ktatemp
         use
         erase ktatemp.dbf
      endif
      exit
   endif
endd
wclose(wcp)
setcolor(clcp)
retu .t.


func stagm()
* Маркодержатели
save scre to scstt
sele stagm
go top
rcstagmr=recn()
forer='kta=ktar'
do while .t.
   sele stagm
   go rcstagmr
   foot('INS,DEL,F4','Добавить,Удалить,Коррекция')
   rcstagmr=slcf('stagm',,,,,"e:mkeep h:'Код' c:n(3) e:getfield('t1','stagm->mkeep','mkeep','nmkeep') h:'Маркодержатель' c:c(40) ",,,1,,forer,,alltrim(nktar))
   go rcstagmr
   mkeepr=mkeep
   do case
      case lastkey()=27
           exit
      case lastkey()=22
           stagmins()
      case lastkey()=7.and.gnEntrm=0
           netdel()
           skip -1
           if bof()
              go top
           endif
           rcstagmr=recn()
      case lastkey()=-3
           stagmins(1)
   endc
endd
rest scre from scstt
retu

func stagmins(p1)
if empty(p1)
   store 0 to mkeep_r
else
   mkeep_r=mkeepr
endif
clstti=setcolor('gr+/b,n/w')
wstti=wopen(10,25,13,50)
wbox(1)
do while .t.
   @ 0,1 say 'Маркодержатель' get mkeep_r pict '999'
   read
   if lastkey()=27
      exit
   endif
   if !netseek('t1','mkeep_r','mkeep').or.mkeep_r=0
      wmess('Такого нет')
      loop
   endif
   @ 1,1 prom 'Верно'
   @ 1,col()+1 prom 'Не Верно'
   menu to vn
   if lastkey()=27
      exit
   endif
   if vn=1.and.gnEntrm=0
      if empty(p1)
         if !netseek('t1','ktar,mkeep_r')
            netadd()
            netrepl('kta,mkeep','ktar,mkeep_r')
            rcstagmr=recn()
         endif
      else
         if !netseek('t1','ktar,mkeep_r')
            go rcstagmr
            netrepl('mkeep','mkeep_r')
         endif
      endif
   endif
   exit
enddo
wclose(wstti)
setcolor(clstti)
retu

func stagtia()
if gnEntrm#0
   retu .t.
endif
dt1r=bom(gdTd)
dt2r=gdTd
clia=setcolor('gr+/b,n/w')
wia=wopen(10,10,12,70)
wbox(1)
@ 0,1 say 'Период ' get dt1r
@ 0,col()+1 get dt2r
read
wclose(wia)
setcolor(clia)
if lastkey()=13
   netuse('cskl')
   for g=year(dt1r) to year(dt2r)
       if year(dt1r)=year(dt2r)
          m1=month(dt1r)
          m2=month(dt2r)
       else
          do case
             case g=year(dt1r)
                  m1=month(dt1r)
                  m2=12
             case g=year(dt2r)
                  m1=1
                  m2=month(dt2r)
             othe
                  m1=1
                  m2=12
          endc
       endif
       for m=m1 to m2
           path_d=gcPath_e+'g'+str(g,4)+'\m'+iif(m<10,'0'+str(m,1),str(m,2))+'\'
           sele cskl
           do while !eof()
              if !(ent=gnEnt.and.rasc=1)
                 sele cskl
                 skip
                 loop
              endif
              pathr=path_d+alltrim(path)
              if !netfile('rs1',1)
                 sele cskl
                 skip
                 loop
              endif
              mess(pathr)
              netuse('rs1',,,1)
              sele rs1
              do while !eof()
                 if vo#9
                    sele rs1
                    skip
                    loop
                 endif
                 if prz=0
                    skip
                    loop
                 endif
                 ktar=kta
                 kgpr=kpv
                 if ktar#0.and.kgpr#0.and.kgpr#20034
                    sele stagt
                    if !netseek('t1','ktar,kgpr')
                       netadd()
                       netrepl('kta,kgp','ktar,kgpr')
                    endif
                 endif
                 sele rs1
                 skip
              endd
              nuse('rs1')
              sele cskl
              skip
           endd
       next
   next
   nuse('cskl')
endif
retu .t.
******************
func stagdoc()
******************
clea
dayr=dow(date())-1
if dayr=8
   dayr=1
endif
itogr=0
clday=setcolor('gr+/b,n/w')
wday=wopen(10,25,13,55)
wbox(1)
@ 0,1 say 'День недели' get dayr pict '9' range 0,7
@ 0,col()+2 say '0 - все'
@ 1,1 say 'Итоги      ' get itogr pict '9'
read
wclose(wday)
setcolor(clday)
if lastkey()=27
   retu .t.
endif


crtt('tkpl','f:kpl c:n(7)')
sele 0
use tkpl

copy stru to stmp exte
sele 0
use stmp excl
zap
appe blank
repl field_name with 'lev',;
     field_type with 'n',;
     field_len with 2,;
     field_dec with 0
appe blank
repl field_name with 'kta',;
     field_type with 'n',;
     field_len with 4,;
     field_dec with 0
appe blank
repl field_name with 'nkta',;
     field_type with 'c',;
     field_len with 20,;
     field_dec with 0
appe blank
repl field_name with 'ktapl',;
     field_type with 'n',;
     field_len with 4,;
     field_dec with 0
appe blank
repl field_name with 'nktapl',;
     field_type with 'c',;
     field_len with 20,;
     field_dec with 0
appe blank
repl field_name with 'kpl',;
     field_type with 'n',;
     field_len with 7,;
     field_dec with 0
appe blank
repl field_name with 'npl',;
     field_type with 'c',;
     field_len with 40,;
     field_dec with 0
appe blank
repl field_name with 'bs',;
     field_type with 'n',;
     field_len with 6,;
     field_dec with 0
appe blank
repl field_name with 'dn',;
     field_type with 'n',;
     field_len with 12,;
     field_dec with 2
appe blank
repl field_name with 'kn',;
     field_type with 'n',;
     field_len with 12,;
     field_dec with 2
appe blank
repl field_name with 'db',;
     field_type with 'n',;
     field_len with 12,;
     field_dec with 2
appe blank
repl field_name with 'kr',;
     field_type with 'n',;
     field_len with 12,;
     field_dec with 2
appe blank
repl field_name with 'dbk',;
     field_type with 'n',;
     field_len with 12,;
     field_dec with 2
appe blank
repl field_name with 'krk',;
     field_type with 'n',;
     field_len with 12,;
     field_dec with 2
appe blank
repl field_name with 'kz',;
     field_type with 'n',;
     field_len with 12,;
     field_dec with 2
appe blank
repl field_name with 'dz',;
     field_type with 'n',;
     field_len with 12,;
     field_dec with 2
appe blank
repl field_name with 'dz7',;
     field_type with 'n',;
     field_len with 12,;
     field_dec with 2
appe blank
repl field_name with 'dz14',;
     field_type with 'n',;
     field_len with 12,;
     field_dec with 2
appe blank
repl field_name with 'dz21',;
     field_type with 'n',;
     field_len with 12,;
     field_dec with 2
appe blank
repl field_name with 'sk',;
     field_type with 'n',;
     field_len with 3,;
     field_dec with 0
appe blank
repl field_name with 'ttn',;
     field_type with 'n',;
     field_len with 6,;
     field_dec with 0
appe blank
repl field_name with 'kop',;
     field_type with 'n',;
     field_len with 4,;
     field_dec with 0
appe blank
repl field_name with 'dop',;
     field_type with 'd',;
     field_len with 8,;
     field_dec with 0
appe blank
repl field_name with 'prz',;
     field_type with 'n',;
     field_len with 1,;
     field_dec with 0
appe blank
repl field_name with 'sdv',;
     field_type with 'n',;
     field_len with 12,;
     field_dec with 2
appe blank
repl field_name with 'sdvm',;
     field_type with 'n',;
     field_len with 12,;
     field_dec with 2
appe blank
repl field_name with 'sdvt',;
     field_type with 'n',;
     field_len with 12,;
     field_dec with 2
appe blank
repl field_name with 'nd',;
     field_type with 'n',;
     field_len with 6,;
     field_dec with 0
appe blank
repl field_name with 'mn',;
     field_type with 'n',;
     field_len with 6,;
     field_dec with 0
appe blank
repl field_name with 'dpr',;
     field_type with 'd',;
     field_len with 8,;
     field_dec with 0
appe blank
repl field_name with 'rn',;
     field_type with 'n',;
     field_len with 6,;
     field_dec with 0
appe blank
repl field_name with 'nplp',;
     field_type with 'n',;
     field_len with 6,;
     field_dec with 0
appe blank
repl field_name with 'bs_d',;
     field_type with 'n',;
     field_len with 6,;
     field_dec with 0
appe blank
repl field_name with 'bs_s',;
     field_type with 'n',;
     field_len with 12,;
     field_dec with 2
appe blank
repl field_name with 'ddk',;
     field_type with 'd',;
     field_len with 8,;
     field_dec with 0
use
create stagdoc from stmp     

sele stagtm
set orde to tag t1
if netseek('t1','ktar')
   do while kta=ktar
      tmestor=tmesto
      wmskr=wmsk
      sele etm
      if netseek('t1','tmestor')
         kplr=kpl
         kgpr=kgp
      else   
         sele stagtm
         skip
         loop
      endif   
      if kplr=20034
         sele stagtm
         skip
         loop
      endif
      if dayr#0
         if empty(subs(wmskr,dayr,1))
            sele stagtm
            skip
            loop
         endif
      endif
      sele tkpl
      locate for kpl=kplr
      if !foun()
         netadd()
         netrepl('kpl','kplr')
      endif
      sele stagtm
      skip
   endd
endif
erase tkpl.dbf
alptl={'lpt1','lpt2','Файл'}
vlptlr=alert('ПЕЧАТЬ',alptl)
if lastkey()=27
   retu .t.
endif
do case
   case vlptlr=1
        clptlr='lpt1'
   case vlptlr=2
        clptlr='lpt2'
   case vlptlr=3
        clptlr='stagdoc.txt'
endc
set prin to &clptlr
set cons off
set prin on
if vlptlr=1.or.vlptlr=3
   if empty(gcPrn)
      ??chr(27)+chr(80)+chr(15)
   else
*      ??chr(27)+'E'+chr(27)+'&l4h25a0O'+chr(27)+'&k2S'+chr(27)+'(3R'+chr(27)+'(s0p18.00h0s1b4102T'+chr(27)
      ??chr(27)+'E'+chr(27)+'&l1h25a0O'+chr(27)+'&l5C'+chr(27)+'(3R'+chr(27)+'(s0p29.00h0s1b4102T'+chr(27)  && Книжная А5
   endif
else
*   ??chr(27)+'E'+chr(27)+'&l4h25a0O'+chr(27)+'&k2S'+chr(27)+'(3R'+chr(27)+'(s0p18.00h0s1b4102T'+chr(27)
   ??chr(27)+'E'+chr(27)+'&l1h25a0O'+chr(27)+'&l5C'+chr(27)+'(3R'+chr(27)+'(s0p29.00h0s1b4102T'+chr(27)  && Книжная А5
endif
nktar=getfield('t1','ktar','s_tag','fio')
?str(ktar,4)+' '+nktar
*sele stagdoc
*appe blank
*repl lev with 1,kta with ktar,nkta with nktar
netuse('dkkln')
netuse('dknap')
pathdebr=gcPath_ew+'deb\s361001\'
if file(pathdebr+'pdeb.dbf')
   prdeb01r=1
   dflr=filedate(pathdebr+'pdeb.dbf')
   tflr=filetime(pathdebr+'pdeb.dbf')
   sele 0
   use (pathdebr+'pdeb') alias pdeb01
   set orde to tag t1
   go top
   sele 0
   use (pathdebr+'trs2') alias trs201
   set orde to tag t1
   go top
   sele 0
   use (pathdebr+'tpr2') alias tpr201
   set orde to tag t1
   go top
   sele 0
   use (pathdebr+'tdokk') alias tdokk01
   set orde to tag t1
   go top
else
   prdeb01r=0
endif
pathdebr=gcPath_ew+'deb\s361002\'
if file(pathdebr+'pdeb.dbf')
   prdeb02r=1
   dflr=filedate(pathdebr+'pdeb.dbf')
   tflr=filetime(pathdebr+'pdeb.dbf')
   sele 0
   use (pathdebr+'pdeb') alias pdeb02
   set orde to tag t1
   go top
   sele 0
   use (pathdebr+'trs2') alias trs202
   set orde to tag t1
   go top
   sele 0
   use (pathdebr+'tpr2') alias tpr202
   set orde to tag t1
   go top
   sele 0
   use (pathdebr+'tdokk') alias tdokk02
   set orde to tag t1
   go top
else
   prdeb02r=0
endif
sele tkpl
go top
do while !eof()
   kplr=kpl
   nplr=getfield('t1','kplr','kln','nkl')
   ?''
   ?'>>> '+str(kplr,7)+' '+nplr
   sele stagdoc
*   appe blank
*   repl lev with 2,kta with ktar,nkta with nktar,kpl with kplr,npl with nplr
   sele dkkln
   locate for kkl=kplr.and.bs=361001
*   if foun()
      dnr=dn
      knr=kn
      dbr=db
      krr=kr
      ggg=dnr-knr+dbr-krr
      store 0 to dbkr,krkr
      if ggg>0
         dbkr=ggg
         krkr=0
      else
         dbkr=0
         krkr=abs(ggg)
      endif
      ?'361001'+'│'+str(dnr,10,2)+'│'+str(knr,10,2)+'│'+str(dbr,10,2)+'│'+str(krr,10,2)+'│'+str(dbkr,10,2)+'│'+str(krkr,10,2)+'│'
      sele stagdoc
      appe blank
      repl lev with 3,bs with 361001,dn with dnr,kn with knr,db with dbr,kr with krr,dbk with dbkr,krk with krkr
      repl kta with ktar,nkta with nktar,kpl with kplr,npl with nplr
      if prdeb01r=1
         sele pdeb01
         locate for kkl=kplr
         if foun()
            ?'Дебеторка 361001 '+dtoc(dflr)+' '+tflr
            dzr=dz
            kzr=kz
            pdzr=pdz
            pdz1r=pdz1
            pdz3r=pdz3
            ?'КЗ '+str(kzr,10,2)+' ДЗ '+str(dzr,10,2)
            ?'>7дн  '+str(pdzr,10,2)+' >14дн  '+str(pdz1r,10,2)+' >21дн  '+str(pdz3r,10,2)
            sele stagdoc
            repl kz with kzr,dz with dzr,dz7 with pdzr,dz14 with pdz1r,dz21 with pdz3r
            if itogr=0
               sele trs201
               if netseek('t1','kplr')
                  ?'Продажи'
                  do while kpl=kplr
                     if sdvm=0
                        skip
                       loop
                     endif
                     if kta#ktar
                        skip
                        loop
                     endif
                     if fieldpos('sdvm1')=0
                        ?str(sk,3)+' '+str(ttn,6)+' '+str(kop,3)+' '+dtoc(dop)+' '+str(prz,1)+' '+str(sdv,10,2)+' '+iif(sdvm=0,space(10),str(sdvm,10,2))+' '+space(10)+' '+iif(sdvt=0,space(10),str(sdvt,10,2))
                     else
                        if sdvm1=0.or.sdvm=sdvm1
                           ?str(sk,3)+' '+str(ttn,6)+' '+str(kop,3)+' '+dtoc(dop)+' '+str(prz,1)+' '+str(sdv,10,2)+' '+iif(sdvm=0,space(10),str(sdvm,10,2))+' '+space(10)+' '+iif(sdvt=0,space(10),str(sdvt,10,2))
                        else
                           ?str(sk,3)+' '+str(ttn,6)+' '+str(kop,3)+' '+dtoc(dop)+' '+str(prz,1)+' '+str(sdv,10,2)+' '+iif(sdvm=0,space(10),str(sdvm,10,2))+' '+' '+iif(sdvm1=0,space(10),str(sdvm1,10,2))+' '+iif(sdvt=0,space(10),str(sdvt,10,2))
                        endif
                     endif
                     sele stagdoc
                     appe blank
                     repl lev with 4,sk with trs201->sk,ttn with trs201->ttn,kop with trs201->kop,dop with trs201->dop,prz with trs201->prz,sdv with trs201->sdv,sdvm with trs201->sdvm,sdvt with trs201->sdvt
                     repl kta with ktar,nkta with nktar,kpl with kplr,npl with nplr,bs with 361001
                     sele trs201
                     skip
                   endd
                endif
                sele tpr201
                if netseek('t1','kplr')
                   ?'Возвраты'
                   do while kps=kplr
                      if sdvm=0
                         skip
                         loop
                      endif
                      ?str(sk,3)+' '+str(nd,6)+' '+str(mn,6)+' '+str(kop,3)+' '+dtoc(dpr)+' '+str(sdv,10,2)+' '+iif(sdvm=0,space(10),str(sdvm,10,2))+' '+iif(sdvt=0,space(10),str(sdvt,10,2))
                      sele stagdoc
                      appe blank
                      repl lev with 5,sk with tpr201->sk,nd with tpr201->nd,mn with tpr201->mn,kop with tpr201->kop,dpr with tpr201->dpr,sdv with tpr201->sdv,sdvm with tpr201->sdvm,sdvt with tpr201->sdvt
                      repl kta with ktar,nkta with nktar,kpl with kplr,npl with nplr,bs with 361001
                      sele tpr201
                      skip
                   endd
                endif
                sele tdokk01
                if netseek('t1','kplr')
                   ?'Оплата'
                   do while kkl=kplr
                      kta_rr=0
                      nkta_rr=''
                      ?str(rn,6)+' '+str(nplp,6)+' '+str(bs_d,6)+' '+str(bs_s,10,2)+' '+dtoc(ddk)
                      sele stagdoc
                      appe blank
                      repl lev with 6,rn with tdokk01->rn,nplp with tdokk01->nplp,bs_d with tdokk01->bs_d,bs_s with tdokk01->bs_s,ddk with tdokk01->ddk
                      repl kta with ktar,nkta with nktar,kpl with kplr,npl with nplr,bs with 361001
                      sele tdokk01
                      if fieldpos('ktapl')=0
                         if gnEnt=21
                            if fieldpos('kta')#0
                               kta_rr=kta
                               if kta_rr#0
                                  nkta_rr=getfield('t1','kta_rr','s_tag','fio')
                                  ??' '+str(kta_rr,4)+' '+nkta_rr
                               endif   
                            endif
                         endif
                      else
                         kta_rr=ktapl
                         if gnEnt=21
                            if kta_rr=0
                               kta_rr=kta 
                            endif
                         endif
                         if kta_rr#0
                            nkta_rr=getfield('t1','kta_rr','s_tag','fio')
                            ??' '+str(kta_rr,4)+' '+nkta_rr
                         endif   
                      endif   
                      sele stagdoc
                      repl ktapl with kta_rr,nktapl with nkta_rr
                      sele tdokk01
                      skip
                   endd
                endif
            endif
         endif
      endif
*   endif
   sele dkkln
   locate for kkl=kplr.and.bs=361002
*   if foun()
      dnr=dn
      knr=kn
      dbr=db
      krr=kr
      ggg=dnr-knr+dbr-krr
      store 0 to dbkr,krkr
      if ggg>0
         dbkr=ggg
         krkr=0
      else
         dbkr=0
         krkr=abs(ggg)
      endif
      ?'361002'+'│'+str(dnr,10,2)+'│'+str(knr,10,2)+'│'+str(dbr,10,2)+'│'+str(krr,10,2)+'│'+str(dbkr,10,2)+'│'+str(krkr,10,2)+'│'
      sele stagdoc
      appe blank
      repl lev with 13,bs with 361002,dn with dnr,kn with knr,db with dbr,kr with krr,dbk with dbkr,krk with krkr
      repl kta with ktar,nkta with nktar,kpl with kplr,npl with nplr,bs with 361002
*if kplr=1884808
*wait
*endif
      if prdeb02r=1
         sele pdeb02
         locate for kkl=kplr
         if found()
            ?'Дебеторка 361002 '+dtoc(dflr)+' '+tflr
            dzr=dz
            kzr=kz
            pdzr=pdz
            pdz1r=pdz1
            pdz3r=pdz3
            ?'КЗ '+str(kzr,10,2)+' ДЗ '+str(dzr,10,2)
            ?'>7дн  '+str(pdzr,10,2)+' >14дн  '+str(pdz1r,10,2)+' >21дн  '+str(pdz3r,10,2)
            sele stagdoc
            repl kz with kzr,dz with dzr,dz7 with pdzr,dz14 with pdz1r,dz21 with pdz3r
            if itogr=0
               sele trs202
               if netseek('t1','kplr')
                  ?'Продажи'
                  do while kpl=kplr
                     if sdvt=0
                        skip
                        loop
                     endif
                     if kta#ktar
                        skip
                        loop
                     endif
                     ttnr=ttn
                     sele trs201
                     loca for ttn=ttnr
                     if foun().and.sdvm#0
                        sele trs202
                        skip
                        loop
                     endif
                     ?str(sk,3)+' '+str(ttn,6)+' '+str(kop,3)+' '+dtoc(dop)+' '+str(prz,1)+' '+str(sdv,10,2)+' '+iif(sdvm=0,space(10),str(sdvm,10,2))+' '+iif(sdvt=0,space(10),str(sdvt,10,2))
                     sele stagdoc
                     appe blank
                     repl lev with 14,sk with trs202->sk,ttn with trs202->ttn,kop with trs202->kop,dop with trs202->dop,prz with trs202->prz,sdv with trs202->sdv,sdvm with trs202->sdvm,sdvt with trs202->sdvt
                     repl kta with ktar,nkta with nktar,kpl with kplr,npl with nplr,bs with 361002
                     sele trs202
                     skip
                   endd
                endif
                sele tpr202
                if netseek('t1','kplr')
                   ?'Возвраты'
                   do while kps=kplr
                      if sdvt=0
                         skip
                         loop
                      endif
                      ?str(sk,3)+' '+str(nd,6)+' '+str(mn,6)+' '+str(kop,3)+' '+dtoc(dpr)+' '+str(sdv,10,2)+' '+iif(sdvm=0,space(10),str(sdvm,10,2))+' '+iif(sdvt=0,space(10),str(sdvt,10,2))
                      sele stagdoc
                      appe blank
                      repl lev with 15,sk with tpr202->sk,nd with tpr202->nd,mn with tpr202->mn,kop with tpr202->kop,dpr with tpr202->dpr,sdv with tpr202->sdv,sdvm with tpr202->sdvm,sdvt with tpr202->sdvt
                      repl kta with ktar,nkta with nktar,kpl with kplr,npl with nplr,bs with 361002
                      sele tpr202
                      skip
                   endd
                endif
                sele tdokk02
                if netseek('t1','kplr')
                   ?'Оплата'
                   do while kkl=kplr
                      ?str(rn,6)+' '+str(nplp,6)+' '+str(bs_d,6)+' '+str(bs_s,10,2)+' '+dtoc(ddk)
                      sele stagdoc
                      appe blank
                      repl lev with 16,rn with tdokk02->rn,nplp with tdokk02->nplp,bs_d with tdokk02->bs_d,bs_s with tdokk02->bs_s,ddk with tdokk02->ddk
                      repl kta with ktar,nkta with nktar,kpl with kplr,npl with nplr,bs with 361002
                      sele tdokk02
                      skip
                   endd
                endif
            endif
         endif
      endif
*   endif
   ?repl('-',80)
   sele tkpl
   skip
endd
if prdeb01r=1
   sele pdeb01
   use
   sele trs201
   use
   sele tpr201
   use
   sele tdokk01
   use
endif
if prdeb02r=1
   sele pdeb02
   use
   sele trs202
   use
   sele tpr202
   use
   sele tdokk02
   use
endif
sele tkpl
use
set prin off
set cons on
set prin to
nuse('dkkln')
nuse('dknap')
#ifdef __CLIP__
if gnKto=336
   sele stagdoc
   set translate path off
   copy to j:\Basanets\stagdoc
   set translate path on
endif
#endif
nuse('stagdoc')
retu .t.
***************
func ktatest()
***************
local forr
crtt('ktatest','f:kgp c:n(7) f:kpl c:n(7) f:tmesto c:n(7) f:ndog c:n(6) f:dtdogb c:d(10) f:dtdoge c:d(10) f:fkgp c:n(1) f:fkpl c:n(1)')
sele 0
use ktatest excl
inde on str(kgp,7)+str(kpl,7) tag t1
sele stagtm
if netseek('t1','ktar')
   do while kta=ktar
      tmestor=tmesto
      kgpr=getfield('t1','tmestor','etm','kgp')
      kplr=getfield('t1','tmestor','etm','kpl')
      sele ktatest
      locate for kpl=kplr.and.kgp=kgpr
      if !foun()
         appe blank
         repl kgp with kgpr,;
              kpl with kplr,;
              tmesto with tmestor
      endif
      if netseek('t1','kgpr','kgp')
         repl fkgp with 1    
      endif
      if netseek('t1','kplr','kpl')
         repl fkpl with 1    
      endif
      sele klndog
      if netseek('t1','kplr')
         ndogr=ndog
         dtdogbr=dtdogb
         dtdoger=dtdoge
         sele ktatest
         repl ndog with ndogr,;
              dtdogb with dtdogbr,;
              dtdoge with dtdoger
      endif
      sele stagtm
      skip
   endd
endif
sele ktatest
go top
fldnomr=1
forr='.t..and.(fkgp=0.or.fkpl=0.or.ndog=0.or.tmesto=0.or.empty(dtdoge).or.dtdoge<date())'
rctestr=recn()
do while .t.
   sele ktatest
   go rctestr
   rctestr=slce('ktatest',1,1,18,,"e:kgp h:'KGP' c:n(7) e:kpl h:'KPL' c:n(7) e:fkgp h:'FKGP' c:n(1) e:fkpl h:'FKPL' c:n(1) e:tmesto h:'TMESTO' c:n(7) e:ndog h:'NDOG' c:n(6) e:dtdoge h:'DTDOGE' c:d(10)",,,,,forr,,str(ktar,4))
   go rctestr
   do case
      case lastkey()=27
           exit
      case lastkey()=19 && Left
           fldnomr=fldnomr-1
           if fldnomr=0
              fldnomr=1
           endif
      case lastkey()=4 && Right
           fldnomr=fldnomr+1
   endc
endd
sele ktatest
use
retu .t.
*************************
func stagtm()
* Торговые места агентов 
*************************
if select('sl')#0
   sele sl
   use
endif
sele 0 
use _slct alias sl excl
zap
save scre to scstt
erase tstagtm.dbf
erase tstagtm.cdx
sele stagtm
copy stru to stmp exte
sele 0
use stmp
appe blank
repl field_name with 'kpl',;
     field_type with 'n',;
     field_len with 7,;
     field_dec with 0
appe blank
repl field_name with 'npl',;
     field_type with 'c',;
     field_len with 30,;
     field_dec with 0
appe blank
repl field_name with 'kgp',;
     field_type with 'n',;
     field_len with 7,;
     field_dec with 0
appe blank
repl field_name with 'ngp',;
     field_type with 'c',;
     field_len with 30,;
     field_dec with 0
appe blank
repl field_name with 'ntmesto',;
     field_type with 'c',;
     field_len with 68,;
     field_dec with 0
use
create tstagtm from stmp
use
use tstagtm excl
inde on str(tmesto,7) tag t1
inde on ntmesto tag t2
erase stemp.dbf
sele stagtm
if netseek('t1','ktar')
   do while kta=ktar
      tmestor=tmesto
      wmskr=wmsk
      sele etm
      if netseek('t1','tmestor')
         kplr=kpl
         kgpr=kgp
         nplr=getfield('t1','kplr','kln','nkl')
         ngpr=getfield('t1','kgpr','kln','nkl')
         ntmestor=ntmesto
         sele tstagtm
         if !netseek('t1','tmestor')
            netadd()
            netrepl('kta,tmesto,kpl,kgp,npl,ngp,wmsk,ntmesto','ktar,tmestor,kplr,kgpr,nplr,ngpr,wmskr,ntmestor')
         endif
     endif
     sele stagtm
     skip
   endd
endif
***********
sele tstagtm
set orde to tag t2
go top
rcagtmr=recn()
fortm_r='.t.'
fortmr=fortm_r
store space(30) to ntmesto_r
store 0 to tmesto_r,kpl_r,kgp_r
fldnomr=1
do while .t.
   sele tstagtm
   go rcagtmr
   if gnEnt=20
      foot('INS,DEL,F2,F3,F4,F6,F8,F9','Доб,Уд,Маска,Фильтр,Просм,Пер Выб,Доб(Авт),Пер Все')
   else
      foot('INS,DEL,F2,F3,F4,F6,F8,F9','Доб,Уд,Маска,Фильтр,Просм,Перем KTA,Доб(Авт),Копир')
   endif   
   rcagtmr=slce('tstagtm',,,,,"e:tmesto h:'ТМ' c:n(7) e:ntmesto h:'Наименование' c:c(60) e:wmsk h:'ПВСЧПСВ' c:c(7) e:kpl h:'KPL' c:n(7) e:kgp h:'KGP' c:n(7) e:kto h:'KI' c:n(4) e:getfield('t1','tstagtm->kto','speng','fio') h:'Оператор' c:c(15)",,1,1,,fortmr,,alltrim(nktar))
   go rcagtmr
   wmskr=wmsk
   tmestor=tmesto
   sele etm
   if netseek('t1','tmestor')
      kplr=kpl
      kgpr=kgp
      kgpcatr=cat
      dppr=dpp
      nactr=nact
   endif   
   sele tstagtm
   do case
      case lastkey()=27
           exit
      case lastkey()=19 && Left
           fldnomr=fldnomr-1
           if fldnomr=0
              fldnomr=1
           endif
      case lastkey()=4 && Right
           fldnomr=fldnomr+1
      case lastkey()=22.and.gnEntrm=0
           stagtmins()
      case lastkey()=7.and.gnEntrm=0
           sele stagtm
           if netseek('t1','ktar,tmestor')
              netdel()
           endif
           sele tstagtm
           netdel()
           skip -1
           if bof()
              go top
           endif
           rcagtmr=recn()
      case lastkey()=-1.and.gnEntrm=0
           wmsk('tstagtm')
      case lastkey()=-7
        IF .T.
            wmess('Cправочник обновляется в ручную',2)
        ELSE
           save scree to sctmp
           stagtmia()
           rest scre from sctmp
        ENDIF
      case lastkey()=-5.and.gnEntrm=0 && переместить точку(Выбранные)
           if gnEnt=20
              tmmove()
           else
              tmremove()
           endif   
      case lastkey()=-2 && Фильтр
           tmflt()
      case lastkey()=-3 && Просмотр
           etmview()
      case lastkey()=-8 && Переместить все
           if gnEnt=20 
              agtmmove() 
           else
              agtmcopy() 
           endif   
           exit   
   endc
endd
rest scre from scstt
sele tstagtm
use
erase stagtm.dbf
erase stagtm.cdx
sele sl
use
retu .t.



func tmflt()
  store space(30) to ntmesto_r
  store 0 to tmesto_r,kpl_r,kgp_r
  clpodrins=setcolor('gr+/b,n/w')
  wktaflt=wopen(10,20,15,70)
  wbox(1)
  do while .t.
     @ 0,1 say 'Контекст' get ntmesto_r 
     @ 1,1 say 'Торг мст' get tmesto_r pict '9999999'
     @ 2,1 say 'Плательщ' get kpl_r pict '9999999'
     @ 3,1 say 'Получат.' get kgp_r pict '9999999'
     read
     if lastkey()=27
        fortmr=fortm_r
        exit
     endif
     ntmesto_r=alltrim(upper(ntmesto_r))
     if lastkey()=13
        fortmr=fortm_r 
        if !empty(ntmesto_r)
           fortmr=fortmr+'.and.at(ntmesto_r,upper(tstagtm->ntmesto))#0'
        endif
        if tmesto_r#0
           fortmr=fortmr+'.and.tmesto=tmesto_r'
        endif   
        if kpl_r#0
           fortmr=fortmr+'.and.kpl=kpl_r'
        endif   
        if kgp_r#0
           fortmr=fortmr+'.and.kgp=kgp_r'
        endif   
        sele tstagtm
        go top
        rcagtmr=recn()
        exit
     endif
  enddo
  wclose(wktaflt)
  setcolor(clpodrins)
  retu

*****************
func stagtmins()
*****************

  if select('sl')#0
     sele sl
     use
  endif
  sele 0
  use _slct alias sl excl
  pack

  store '' to tmesto_r
  store 0 to kpl_r,kgp_r 
  foretm_r="!netseek('t1','ktar,etm->tmesto','stagtm')"
  foretmr=foretm_r
  sele etm
  go top
  do while .t.
     foot('SPACE,ENTER,F3,F4','Отбор,Добавить,Фильтр,Просмотр')
     tmestor=slcf('etm',1,1,18,,"e:tmesto h:'ID' c:n(7) e:ntmesto h:'Наименование' c:c(66)",'tmesto',1,,,foretmr,,'Торговые места '+alltrim(gcName_c))
     if lastkey()=27
        exit
     endif
     sele etm
     netseek('t1','tmestor')
     ntmestor=ntmesto
     kgpr=kgp
     kplr=kpl
     do case
        case lastkey()=13.and.gnEntrm=0
             sele sl
             go top
             do while !eof()
                tmesto_r=val(kod)
                sele stagtm
                avybr=2
                if gnEnt=20
                   sele s_tag
                   set orde to tag t4
                   if netseek('t4','ktasr')
                      do while ktas=ktasr
                         if kod=ktar
                            skip
                            loop
                         endif
                         kta_r=kod
                         if netseek('t1','kta_r,tmesto_r','stagtm') 
*                            avyb={'Нет','Да'}
*                            avybr=alert('Эта пара есть у '+str(kta_r,4)+',Продолжить?',avyb)
                             wmess('Эта пара есть у '+str(kta_r,4),3)
                             avybr=0 
                             exit
                         endif
                         skip
                      endd
                   endif
                endif
                if avybr#2
                   sele sl
                   skip
                   loop
                endif
                sele stagtm
                if !netseek('t1','ktar,tmesto_r')
                   netadd()
                   netrepl('kta,tmesto','ktar,tmesto_r')
                   if fieldpos('kto')#0
                      netrepl('kto','gnKto') 
                   endif
                   if fieldpos('ntmesto')#0
                      netrepl('ntmesto','ntmestor') 
                   endif
                endif
                sele tstagtm
                if !netseek('t1','tmesto_r')
                   netadd()
                   netrepl('kta,tmesto,ntmesto','ktar,tmesto_r,ntmestor')
                   if fieldpos('kto')#0
                      netrepl('kto','gnKto') 
                   endif
                endif
                sele sl
              skip
           endd
           sele tstagtm
           go top
           rcagtmr=recn()
           exit
        case lastkey()=-2 && Фильтр
           etmflta()
           sele etm
           go top
        case lastkey()=-3 && Просмотр
           etmview() 
     endc
  endd
  sele sl
  pack
*  use
retu .t.

func stagtmia()
if gnEntrm#0
   retu .t.
endif
dt1r=bom(gdTd)
dt2r=gdTd
clia=setcolor('gr+/b,n/w')
wia=wopen(10,10,12,70)
wbox(1)
@ 0,1 say 'Период ' get dt1r
@ 0,col()+1 get dt2r
read
wclose(wia)
setcolor(clia)
if lastkey()=13
   netuse('cskl')
   for g=year(dt1r) to year(dt2r)
       if year(dt1r)=year(dt2r)
          m1=month(dt1r)
          m2=month(dt2r)
       else
          do case
             case g=year(dt1r)
                  m1=month(dt1r)
                  m2=12
             case g=year(dt2r)
                  m1=1
                  m2=month(dt2r)
             othe
                  m1=1
                  m2=12
          endc
       endif
       for m=m1 to m2
           path_d=gcPath_e+'g'+str(g,4)+'\m'+iif(m<10,'0'+str(m,1),str(m,2))+'\'
           sele cskl
           do while !eof()
              if !(ent=gnEnt.and.rasc=1)
                 sele cskl
                 skip
                 loop
              endif
              pathr=path_d+alltrim(path)
              if !netfile('rs1',1)
                 sele cskl
                 skip
                 loop
              endif
              mess(pathr)
              netuse('rs1',,,1)
              sele rs1
              do while !eof()
                 if vo#9
                    sele rs1
                    skip
                    loop
                 endif
                 if prz=0
                    skip
                    loop
                 endif
                 ktar=kta
                 kgpr=kpv
                 kplr=nkkl
                 if ktar#0.and.kgpr#0.and.kgpr#20034.and.kplr#0.and.kplr#20034
                    tmestor=getfield('t2','kplr,kgpr','etm','tmesto')
                    ntmestor=getfield('t1','tmestor','etm','ntmesto')
                    wmskr=getfield('t1','kplr,kgpr,ktar','kplkgp','wmsk')
                    if tmestor#0
                       sele stagtm
                       if !netseek('t1','ktar,tmestor')
                          netadd()
                          netrepl('kta,tmesto,wmsk,ntmesto','ktar,tmestor,wmskr,ntmestor')
                       else
                          if empty(wmsk).and.!empty(wmskr)
                             netrepl('wmsk','wmskr')
                          endif
*                          if empty(ntmesto)
*                             netrepl('ntmesto','ntmestor')
*                          endif
                       endif
                    endif
                 endif
                 sele rs1
                 skip
              endd
              nuse('rs1')
              sele cskl
              skip
           endd
       next
   next
   nuse('cskl')
endif
retu .t.

func etmflta()
store space(30) to ntmesto_r
store 0 to kgp_r,kpl_r
clpodrins=setcolor('gr+/b,n/w')
wktaflt=wopen(10,20,14,60)
wbox(1)
do while .t.
   @ 0,1 say 'Плательщик' get kpl_r pict '9999999'
   @ 1,1 say 'Получатель' get kgp_r pict '9999999'
   @ 2,1 say 'Контекст  ' get ntmesto_r 
   read
   if lastkey()=27
      foretmr=foretm_r
      exit
   endif
   if lastkey()=13
      if empty(ntmesto_r)
         foretmr=foretm_r
         if kpl_r#0
            foretmr=foretmr+'.and.kpl=kpl_r'
         endif
         if kgp_r#0
            foretmr=foretmr+'.and.kgp=kgp_r'
         endif
      else   
         ntmesto_r=alltrim(upper(ntmesto_r))
         foretmr=foretm_r+'.and.at(ntmesto_r,upper(etm->ntmesto))#0'
      endif        
      sele etm
      go top
      exit
   endif
enddo
wclose(wktaflt)
setcolor(clpodrins)
retu .t.

****************
func agtmmove()
****************
if gnEntrm#0
   retu .t.
endif
kta_r=0
prcp_r=0
clpodrins=setcolor('gr+/b,n/w')
wktaflt=wopen(10,20,13,60)
wbox(1)
do while .t.
   @ 0,1 say 'С кого переместить' get kta_r pict '9999'
   @ 1,1 say 'Копировать        ' get prcp_r pict '9'
   read
   if lastkey()=27
      exit
   endif
   sele stagtm
   if !netseek('t1','kta_r')
      wmess('Нет такого кода',2)
      loop
   endif
   if ktasr#getfield('t1','kta_r','s_tag','ktas').and.prcp_r=0
      wmess('Агент другого супервайзера',2)
      kta_r=0
      loop
   endif
   if lastkey()=13
      sele stagtm
      if netseek('t1','kta_r')
         do while kta=kta_r
            rc_rr=recn()
            tmestor=tmesto
            wmskr=wmsk
            if !netseek('t1','ktar,tmestor')
               netadd()
               netrepl('kta,tmesto,wmsk','ktar,tmestor,wmskr') 
               if fieldpos('kto')#0
                  netrepl('kto','gnKto')
               endif 
            endif
            sele stagtm
            go rc_rr
            if prcp_r=0
               netdel()
            endif   
            skip 
         endd
      endif
      exit
   endif
enddo
wclose(wktaflt)
setcolor(clpodrins)
retu .t.

****************
func tmmove()
****************
if gnEntrm#0
   retu .t.
endif

kta_r:=ktar

clpodrins=setcolor('gr+/b,n/w')
wktaflt=wopen(10,20,12,60)
wbox(1)

do while .t.
   @ 0,1 say 'Куда переносим? Код торг. агента' get kta_r ;
   valid !empty(kta_r) .and. kta_r>0 .and. s_tag->(netseek('t1','kta_r')).and.getfield('t1','kta_r','s_tag','ktas')=ktasr
   read
   if lastkey()=27
      exit
   endif
   if lastkey()=13
      sele sl
      go top
      do while !eof()
         rc_r=val(kod)    
         sele tstagtm
         go rc_r
         tmesto_rr=tmesto
         netdel()
         sele stagtm
         if netseek('t1','ktar,tmesto_rr')
            netrepl('kta','kta_r')
         endif
         sele sl
         skip
      endd
      sele tstagtm
      go top
      rcagtmr=recn()
      exit
   endif
enddo
wclose(wktaflt)
setcolor(clpodrins)
retu .t.
***************
func ktanap()
**************
* Напрвления
save scre to scstt
sele ktanap
if !netseek('t1','ktar')
   go top
endif   
rcktanapr=recn()
do while .t.
   sele ktanap
   go rcktanapr 
   foot('INS,DEL','Добавить,Удалить')
   rcktanapr=slcf('ktanap',,,,,"e:nap h:'Код' c:n(4) e:getfield('t1','ktanap->nap','nap','nnap') h:'Наименование'c:c(20)",,,1,,'kta=ktar',,alltrim(nktar))
   go rcktanapr
   napr=nap
   do case
      case lastkey()=27
           exit
      case lastkey()=22
           ktanapins()
      case lastkey()=7.and.gnEntrm=0
           netdel()
           skip -1
           if bof()
              go top
           endif
           rcktanapr=recn()
   endc
endd
rest scre from scstt
retu .t.

func ktanapins()
store 0 to nap_r,nnap_r
clstei=setcolor('gr+/b,n/w')
wstei=wopen(10,15,14,65)
wbox(1)
do while .t.
   @ 0,1 say 'Направление ' get nap_r pict '9999'
   read
   if lastkey()=27
      exit
   endif
   sele nap
   if !netseek('t1','nap_r')
      wmess('Такого нет',3)   
      nap_r=0
      loop   
   endif
   nnap_r=getfield('t1','nap_r','nap','nnap')
   @ 1,1 say 'Наименование'+' '+nnap_r 
   @ 2,1 prom 'Верно'
   @ 2,col()+1 prom 'Не Верно'
   menu to vn
   if lastkey()=27
      exit
   endif
   if vn=1.and.gnEntrm=0
      sele ktanap
      if !netseek('t1','ktar,nap_r')
         netadd()
         netrepl('kta,nap','ktar,nap_r')
         rcktanapr=recn()
         exit
      else
         wmess('Уже есть',3)    
      endif   
   endif
enddo
wclose(wstei)
setcolor(clstei)
retu
retu .t.
*****************
func agtmcopy()
*****************
if gnEntrm#0
   retu .t.
endif
kta_r=0
clpodrins=setcolor('gr+/b,n/w')
wktaflt=wopen(10,20,12,60)
wbox(1)
do while .t.
   @ 0,1 say 'С кого копировать' get kta_r pict '9999'
   read
   if lastkey()=27
      exit
   endif
   sele stagtm
   if !netseek('t1','kta_r')
      wmess('Нет такого кода',2)
      loop
   endif
   if lastkey()=13
      sele stagtm
      if netseek('t1','kta_r')
         do while kta=kta_r
            rc_rr=recn()
            tmestor=tmesto
            wmskr=wmsk
            if !netseek('t1','ktar,tmestor')
               netadd()
               netrepl('kta,tmesto,wmsk','ktar,tmestor,wmskr') 
               if fieldpos('kto')#0
                  netrepl('kto','gnKto')
               endif 
            endif
            sele stagtm
            go rc_rr
            skip 
         endd
      endif
      exit
   endif
enddo
wclose(wktaflt)
setcolor(clpodrins)
retu .t.
****************
func tmremove()
****************
if gnEntrm#0
   retu .t.
endif
  kta_r:=ktar

  clpodrins=setcolor('gr+/b,n/w')
  wktaflt=wopen(10,20,12,60)
  wbox(1)

  do while .t.
    @ 0,1 say 'Куда переносим? Код торг. агента' get kta_r ;
    valid !empty(kta_r) .and. kta_r>0 .and. s_tag->(netseek('t1','kta_r'))
    read
    if lastkey()=27
      exit
    endif
    if lastkey()=13

      sele stagtm
      if netseek('t1','ktar,tmestor')
        netrepl('kta','kta_r')
      endif
      sele tstagtm
      netdel()
      skip -1
      if bof()
        go top
      endif
      rcagtmr=recn()

      exit
    endif
  enddo

  wclose(wktaflt)
  setcolor(clpodrins)
retu .t.
****************
func ktastest()
****************
if ktar#ktasr
   wmess('Это не супервайзер',2)
   retu .t.
endif
clea
mess('Ждите...')
crtt('latm','f:tmesto c:n(7),f:ntmesto c:c(40),f:kta c:n(4) f:nkta c:c(15) f:cnt c:n(3)')
sele 0
use latm
inde on str(tmesto,7)+str(kta,4) tag t1
sele stagtm
go top
do while !eof()
   kta_r=kta
   tmesto_r=tmesto
   ntmesto_r=subs(getfield('t1','tmesto_r','etm','ntmesto'),1,40)
   nkta_r=getfield('t1','kta_r','s_tag','fio')
   ktas_r=getfield('t1','kta_r','s_tag','ktas')
   if ktasr=ktas_r
      sele latm
      seek str(tmesto_r,7)
      if !foun()
         appe blank
         repl tmesto with tmesto_r,;
              ntmesto with ntmesto_r,;
              kta with kta_r,;
              nkta with nkta_r
      else
         repl cnt with 1        
         appe blank
         repl tmesto with tmesto_r,;
              ntmesto with ntmesto_r,;
              kta with kta_r,;
              nkta with nkta_r,;
              cnt with 1
      endif        
   endif
   sele stagtm
   skip
endd
clea
sele latm
go top
rclatmr=recn()
do while .t.
   sele latm
   go rclatmr
   foot('DEL','Удалить')
   rclatmr=slcf('latm',1,,18,,"e:tmesto h:'TMESTO' c:n(7) e:ntmesto h:'Наименование' c:c(40) e:kta h:'KTA' c:n(4) e:nkta h:'Агент' c:c(15) ",,,,,'cnt=1',,str(ktasr,4))
   if lastkey()=27
      exit
   endif
   go rclatmr
   kta_r=kta
   tmesto_r=tmesto
   do case
      case lastkey()=7.and.gnEntrm=0
           sele stagtm
           if netseek('t1','kta_r,tmesto_r')
              netdel()
              sele latm
              netdel()
              skip -1
              if bof()
                 go top
              endif
              rclatmr=recn()
          else
             wmess('Не наден в STAGTM')    
          endif    
   endc
endd
sele latm
use
erase latm.dbf
erase latm.cdx
retu .t.