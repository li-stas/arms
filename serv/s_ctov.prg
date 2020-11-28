* CTOV
clea
netuse('mkeep')
netuse('cgrp')
netuse('ctov')
netuse('ctov','ctovc')
set orde to tag t9
sele ctov
set orde to tag t6 && mkeep kg nat
go top
rcctovr=recn()
for_r='.t..and.ctov->mkeep#0'
forr='.t..and.ctov->mkeep#0'
store 0 to mkeepr,kgr,parcr,partr,prMerchr
fldnomr=1
do while .t.
   sele ctov
   set orde to tag t2
   go rcctovr
   foot('F3,F4,ENTER,F7,F8,F9','Фильтр,Коррекция,Доч Цены,Доч Тов,Группа,ОбнРод')
   if fieldpos('evz')=0
      rcctovr=slce('ctov',1,1,18,,"e:mkeep h:'МД' c:n(3) e:MnTov h:'Код' c:n(7) e:nat h:'Наименование' c:c(44) e:MnTovC h:'РодЦ' c:n(7) e:MnTovT h:'РодТ' c:n(7) e:merch h:'M' c:n(1) e:bar h:'Штрих-код' c:n(13)",,,1,,forr,,'Справочник товара '+gcName_c)
   else
      rcctovr=slce('ctov',1,1,18,,"e:mkeep h:'МД' c:n(3) e:MnTov h:'Код' c:n(7) e:nat h:'Наименование' c:c(44) e:MnTovC h:'РодЦ' c:n(7) e:MnTovT h:'РодТ' c:n(7) e:merch h:'M' c:n(1) e:evz h:'В' c:n(1) e:bar h:'Штрих-код' c:n(13)",,,1,,forr,,'Справочник товара '+gcName_c)
   endif
   if lastkey()=27
      exit
   endif
   go rcctovr
   mkeepr=mkeep
   MnTovr=MnTov
   natr=nat
   kgr=int(MnTovr/10000)
   merchr=merch
   MnTovCr=MnTovC
   MnTovTr=MnTovT
   barr=bar
   mkcrosr=mkcros
   if fieldpos('evz')#0
      evzr=evz
   else
      evzr=0
   endif
   if fieldpos('minosv')#0
      minosvr=minosv
   else
      minosvr=0
   endif
   do case
      case lastkey()=19 && Left
           fldnomr=fldnomr-1
           if fldnomr=0
              fldnomr=1
           endif
      case lastkey()=4 && Right
           fldnomr=fldnomr+1
      case lastkey()=-3 && CORR
           ccor()
      case lastkey()=-2 && Фильтр
           ctovflt()
      case lastkey()>32.and.lastkey()<255
           sele ctov
           lstkr=upper(chr(lastkey()))
           if !netseek('t6','mkeepr,int(MnTovr/10000),lstkr')
              go rcctovr
           else
              rcctovr=recn()
           endif
      case lastkey()=-6 && Доч Товар
              child(1)
      case lastkey()=-7 && Группа
           foot('','')
           sele cgrp
           set orde to tag t2
           go top
           rcn_gr=recn()
           do while .t.
              sele cgrp
              set orde to tag t2
              rckgr=recn()
*              forgr=".t..and.netseek('t6','mkeepr,cgrp->kgr','ctov')"
              rckgr=slcf('cgrp',,,,,"e:kgr h:'Код' c:n(3) e:ngr h:'Наименование' c:c(20)",,,1,,".t..and.netseek('t1','cgrp->kgr*10000','ctov','3')",,'Группы')
              go rckgr
              kg_r=kgr
              do case
                 case lastkey()=13
                      sele ctov
                      if !netseek('t2','kg_r')
                         go rcctovr
                      else
                         rcctovr=recn()
                      endif
                      exit
                 case lastkey()=27
                      exit
                 case lastkey()>32.and.lastkey()<255
                      sele cgrp
                      lstkr=upper(chr(lastkey()))
                      if !netseek('t2','lstkr')
                          go rckgr
                      endif
                      loop
                 othe
                      loop
              endc
           endd
           sele ctov
           loop
      case lastkey()=-37 && Маркодержатель
           prf8r=1
           foot('','')
           sele mkeep
           go top
           rcmkeepr=recn()
           do while .t.
              sele mkeep
              go rcmkeepr
              rcmkeepr=slcf('mkeep',,,,,"e:mkeep h:'Код' c:n(3) e:nmkeep h:'Наименование' c:c(20)",,,1,,"mkeep#0.and.netseek('t6','mkeep->mkeep','ctov')",,'Маркодержатели')
              go rcmkeepr
              mkeepr=mkeep
              if lastkey()=27
                 exit
              endif
              if lastkey()=13
                 sele ctov
                 if !netseek('t6','mkeepr')
                    go rcctovr
                 else
                    rcctovr=recn()
                 endif
                 exit
              endif
           endd
           sele ctov
           loop
      case lastkey()=-8 && ОбнРод
           obnpar()
      case lastkey()=13 &&Доч Цены
           if MnTovr=MnTovCr
              child()
           endif
   endc
endd
nuse('ctovc')
nuse()

func ccor()
clmr=setcolor('gr+/b,n/w')
wmr=wopen(10,20,19,52)
wbox(1)
mkeep_r=mkeepr
do while .t.
   @ 0,1 say 'Признак для КПК' get merchr pict '9'
   @ 1,1 say 'Родитель ШК    ' get MnTovCr pict '9999999'
   @ 2,1 say 'Родитель Товар ' get MnTovTr pict '9999999'
   @ 3,1 say 'Разреш возврата' get evzr pict '9'
   @ 4,1 say 'Штрих код      ' get barr pict '9999999999999'
   @ 5,1 say 'Маркодержатель ' get mkeep_r pict '999'
   @ 6,1 say 'Кросс код      ' get mkcrosr pict '9999999'
   @ 7,1 say 'MIN остаток    ' get minosvr pict '9999999.999'
   read
   if lastkey()=27
      exit
   endif
   netrepl('merch,MnTovC,MnTovT,bar,mkeep,mkcros','merchr,MnTovCr,MnTovTr,barr,mkeep_r,mkcrosr')
   if fieldpos('evz')#0
      netrepl('evz','evzr')
   endif
   if fieldpos('minosv')#0
      netrepl('minosv','minosvr')
   endif
   exit
enddo
wclose(wmr)
setcolor(clmr)
retu .t.

func ctovflt()
store 0 to mkeepr,kgr,barr
clpodrins=setcolor('gr+/b,n/w')
wktaflt=wopen(10,25,17,56)
wbox(1)
do while .t.
   @ 0,1 say 'МД       ' get mkeepr pict '999'
   @ 1,1 say 'Группа   ' get kgr   pict '999'
   @ 2,1 say 'Родит.Ц  ' get parcr  pict '9'
   @ 3,1 say 'Родит.Т  ' get partr  pict '9'
   @ 4,1 say 'Продажа  ' get prMerchr  pict '9'
   @ 5,1 say 'Штрих код' get barr  pict '9999999999999'
   read
   if lastkey()=27
      exit
   endif
   if barr#0
      forr=for_r+'.and.bar=barr'
   else
      if mkeepr#0
         forr=for_r+'.and.mkeep=mkeepr'
      else
         if kgr#0
            forr=for_r+'.and.int(MnTov/10000)=kgr'
         else
            forr=for_r
         endif
      endif
      if parcr=1
         forr=forr+'.and.MnTov=MnTovC'
      endif
      if parcr=2
         forr=forr+'.and.MnTov#MnTovC'
      endif
      if partr=1
         forr=forr+'.and.MnTov=MnTovT'
      endif
      if partr=2
         forr=forr+'.and.MnTov#MnTovT'
      endif
   endif
   forr=forr+'.and.ctov->merch=prMerchr'
   sele ctov
   go top
   rcctovr=recn()
   exit
enddo
wclose(wktaflt)
setcolor(clpodrins)
retu

func obnpar()
clea
clmr=setcolor('gr+/b,n/w')
wmr=wopen(10,20,13,60)
wbox(1)
store gdTd to dt1r,dt2r
probnr=0
do while .t.
   @ 0,1 say 'Период с' get dt1r
   @ 0,col()+1 say ' по' get dt2r
   read
   if lastkey()=27
      probnr=0
      exit
   endif
   if lastkey()=13
      probnr=1
      exit
   endif
endd
wclose(wmr)
setcolor(clmr)
if probnr=1
   netuse('cskl')
   for yyr=year(dt1r) to year(dt2r)
       do case
          case year(dt1r)=year(dt2r)
               mm1r=month(dt1r)
               mm2r=month(dt2r)
          case yyr=year(dt1r)
               mm1r=month(dt1r)
               mm2r=12
          case yyr=year(dt2r)
               mm1r=1
               mm2r=month(dt2r)
          othe
               mm1r=1
               mm2r=12
       endc
       for mmr=mm1r to mm2r
           pathdr=gcPath_e+'g'+str(yyr,4)+'\m'+iif(mmr<10,'0'+str(mmr,1),str(mmr,2))+'\'
           sele cskl
           go top
           do while !eof()
              if !(ent=gnEnt.and.rasc=1)
                 skip
                 loop
              endif
              pathr=pathdr+alltrim(path)
              if !netfile('tovm',1)
                 skip
                 loop
              endif
              netuse('pr1',,,1)
              locate for vo=9
              if foun()
                 prsklr=1
              else
                 prsklr=0
              endif
              nuse('pr1')
              if prsklr=1
                 ?pathr
                 netuse('tovm',,,1)
                 do while !eof()
                    MnTovr=MnTov
                    sele ctov
                    if netseek('t1','MnTovr')
                       if MnTovC=0
                          if gnEnt=21
                             if fieldpos('MnTovC')#0
                                netrepl('MnTovC','MnTovr')
                             endif
                          else
                             if !empty('bar')
                                if fieldpos('MnTovC')#0
                                   netrepl('MnTovC','MnTovr')
                                endif
                             endif
                          endif
                       endif
                       if MnTovT=0
                          if gnEnt=21
                             if fieldpos('MnTovT')#0
                                netrepl('MnTovT','MnTovr')
                             endif
                          else
                             if !empty('bar')
                                if fieldpos('MnTovT')#0
                                   netrepl('MnTovT','MnTovr')
                                endif
                             endif
                          endif
                       endif
                       if MnTovT=0.and.MnTovC#0
                          netrepl('MnTovT','MnTovC')
                       endif
                    endif
                    sele tovm
                    skip
                 endd
                 nuse('tovm')
              endif
              sele cskl
              skip
           endd
       next
   next
   nuse('cskl')
endif
clea
retu .t.

func child(p1)
sele ctovc
if empty(p1)
   set orde to tag t9
   netseek('t9','MnTovr')
   forcr='.t..and.MnTov#MnTovC.and.MnTovC#0'
   whlcr='MnTovC=MnTovr'
else
   set orde to tag t10
   netseek('t10','MnTovr')
   forcr='.t..and.MnTov#MnTovT.and.MnTovT#0'
   whlcr='MnTovT=MnTovr'
endif
rcctovcr=recn()
do while .t.
   sele ctovc
   go rcctovcr
   foot('INS,DEL','Добавить,Удалить')
   rcctovcr=slcf('ctovc',3,1,,,"e:mkeep h:'МД' c:n(3) e:MnTov h:'Код' c:n(7) e:nat h:'Наименование' c:c(60)",,,1,whlcr,forcr,,str(MnTovr,7)+' '+alltrim(natr))
   if lastkey()=27
      exit
   endif
   go rcctovcr
   do case
      case lastkey()=22 && INS
           if empty(p1)
              ctovcins()
           else
              ctovcins(1)
           endif
      case lastkey()=7  && DEL
           if empty(p1)
              netrepl('MnTovC','0')
           else
              netrepl('MnTovT','0')
           endif
           skip -1
           if empty(p1)
              if MnTovC#MnTovr.or.bof()
                 netseek('t9','MnTovr')
              endif
           else
              if MnTovT#MnTovr.or.bof()
                 netseek('t10','MnTovr')
              endif
           endif
           rcctovcr=recn()
   endc
endd
retu .t.

func ctovcins(p1)
if select('sl')#0
   sele sl
   use
endif
sele 0
use _slct alias sl excl
zap
sele ctov
set orde to tag t2
kg_r=int(MnTovr/10000)
ng_r=getfield('t1','kg_r','cgrp','ngr')
netseek('t2','kg_r')
if empty(p1)
   if gnEnt=21
      forpr='.t..and.MnTovC=0'
   else
      forpr='.t..and.MnTovC=0.and.!empty(bar)'
   endif
else
   if gnEnt=21
      forpr='.t..and.MnTovT=0'
   else
      forpr='.t..and.MnTovT=0.and.!empty(bar)'
   endif
endif
whlpr='.t..and.int(MnTov/10000)=kg_r'
do while .t.
   sele ctov
   foot('INS,DEL','Добавить,Удалить')
   MnTovCr=slcf('ctov',7,1,,,"e:mkeep h:'МД' c:n(3) e:MnTov h:'Код' c:n(7) e:nat h:'Наименование' c:c(60)",'MnTov',1,1,whlpr,forpr,,str(kg_r,3)+' '+alltrim(ng_r))
   if lastkey()=27
      exit
   endif
   if empty(p1)
      netseek('t1','MnTovCr')
   else
      netseek('t1','MnTovTr')
   endif
   if lastkey()=13
      sele sl
      go top
      do while !eof()
         if empty(p1)
            MnTovCr=val(kod)
            sele ctovc
            if netseek('t1','MnTovCr')
               netrepl('MnTovC','MnTovr')
               rcctovcr=recn()
            endif
         else
            MnTovTr=val(kod)
            sele ctovc
            if netseek('t1','MnTovTr')
               netrepl('MnTovT','MnTovr')
               rcctovcr=recn()
            endif
         endif
         sele sl
         skip
      endd
      exit
   endif
endd
sele sl
pack
use
retu .t.

