#include "inkey.ch"
***********************************
* Коррекция DKNAP за период
***********************************

netuse('s_tag')
netuse('nap')
netuse('kpl')

if gnScOut=0
   clea
   store gdTd to dt1r,dt2r
   store 0 to klnr,probnr
   clr=setcolor('gr+/b,n/bg')
   wr=wopen(8,20,12,60)
   wbox(1)
   @ 0,1 say 'Период с ' get dt1r
   @ 0,col()+1 say ' по ' get dt2r
   @ 1,1 say 'Клиент   ' get klnr pict '9999999'
   @ 2,1 say 'С обнул  ' get probnr pict '9'
   read
   wbox(1)
   wclose(wr)
   setcolor(clr)
   if lastkey()=K_ESC.or.empty(dt1r).or.empty(dt2r).or.dt2r<dt1r
      retu
   endif
endif

set print to crdknap.txt
crtt('lkln','f:kkl c:n(7)')
sele 0
use lkln excl
inde on str(kkl,7) tag t1

set prin on
for yyr=year(dt1r) to year(dt2r)
    pathgr=gcPath_e+'g'+str(yyr,4)+'\'
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
        dtr=ctod('01.'+iif(mmr<10,'0'+str(mmr,1),str(mmr,2))+'.'+str(yyr,4))
        dtpr=addmonth(dtr,-1)
        pathmpr=gcPath_e+'g'+str(year(dtpr),4)+'\m'+iif(month(dtpr)<10,'0'+str(month(dtpr),1),str(month(dtpr),2))+'\'
        pathmr=pathgr+'m'+iif(mmr<10,'0'+str(mmr,1),str(mmr,2))+'\'
        pathr=pathmr+'bank\'
        ?pathr
        if !netfile('dokk',1)
           loop
        endif

        sele lkln
        zap
        if klnr=0
           appe from (pathr+'dkkln.dbf') for bs=361001
        else
           appe blank
           repl kkl with klnr
        endif

        copy file (gcPath_a+'dkkln.dbf') to (gcPath_l+'\ldknap.dbf')
        sele 0
        use ldknap excl
        zap
        inde on str(kkl,7)+str(bs,6)+str(skl,7) tag t1
        inde on str(kkl,7)+str(bs,6)+dtos(ddb) tag t2
        set orde to tag t1

        * Остатки на начало LDKNAP
        pathr=pathmpr+'bank\'
        if netfile('dknap',1).and..F.
           netuse('dknap','dknapp',,1)
           sele lkln
           go top
           do while !eof()
              kklr=kkl
              sele dknapp
              if netseek('t1','kklr,361001')
                 do while kkl=kklr.and.bs=361001
                    sklr=skl
                    ddbr=ddb
                    dkrr=dkr
                    ddbor=ddbo
                    saldor=dn-kn+db-kr
                    store 0 to dnr,knr
                    if saldor>0
                       dnr=saldor
                    endif
                    if saldor<0
                       knr=abs(saldor)
                    endif
                    sele ldknap
                    seek str(kklr,7)+str(361001,6)+str(sklr,7)
                    if !foun()
                       appe blank
                       repl kkl with kklr,;
                            bs with 361001,;
                            skl with sklr
                    endif
                    repl dn with dnr,;
                         kn with knr,;
                         ddb with ddbr,;
                         dkr with dkrr,;
                         ddbo with ddbor
                    sele dknapp
                    skip
                 endd
              endif
              sele lkln
              skip
           endd
           nuse('dknapp')
        endif

        *Постоение оборотов в LDKNAP
        pathr=pathmr+'bank\'
        netuse('dokk',,,1)
        netuse('dokko',,,1)
        odokk()
        odokko()
        nuse('dokk')
        nuse('dokko')

        * Закрытие направлений
*        odknap()
        * Остаток на конец
        sele ldknap
        go top
        do while !eof()
           store 0 to dpr,kpr
           saldor=dn+db-kn-kr
           if saldor>=0
              dpr=saldor
           else
              kpr=abs(saldor)
           endif
           repl dp with dpr,;
                kp with kpr
           skip
        endd

        * Коррекция DKNAP из LDKNAP
        pathr=pathmr+'bank\'
        netuse('dknap',,,1)

        if probnr=1
           do while !eof()
              netdel()
              sele dknap
              skip
           endd
        endif

        sele ldknap
        go top
        do while !eof()
           kklr=kkl
           bsr=bs
           sklr=skl
           dnr=dn
           knr=kn
           dbr=db
           krr=kr
           ddbr=ddb
           dkrr=dkr
           dbor=dbo
           ddbor=ddbo
           dpr=dp
           kpr=kp
           sele dknap
           seek str(kklr,7)+str(bsr,6)+str(sklr,7)
           if foun()
              if !(db=dbr.and.kr=krr.and.dbo=dbor)
                 ?str(kklr,7)+' '+str(bsr,6)+' '+str(sklr,7)
                 ?'ДТ  '+str(db,12,2)+ ' ДР  '+str(dbr,12,2)
                 ?'КТ  '+str(kr,12,2)+ ' КР  '+str(krr,12,2)
                 ?'ДТO '+str(dbo,12,2)+' ДРO '+str(dbor,12,2)
                 netrepl('db,kr,ddb,dkr,dbo,ddbo,dp,kp','dbr,krr,ddbr,dkrr,dbor,ddbor,dpr,kpr')
              endif
              if !(dn=dnr.and.kn=knr).and..F.
                 ?str(kklr,7)+' '+str(bsr,6)+' '+str(sklr,7)
                 ?'ДНТ '+str(dn,12,2)+' ДНР '+str(dnr,12,2)
                 ?'КНТ '+str(kn,12,2)+' КНР '+str(knr,12,2)
                 netrepl('dn,kn','dnr,knr')
              endif
           else
              ?str(kklr,7)+' '+str(bsr,6)+' '+str(sklr,7)+' Не найден'
              netadd()
              netrepl('kkl,bs,db,kr,skl,ddb,dkr,dn,kn,dbo,ddbo,dp,kp','kklr,bsr,dbr,krr,sklr,ddbr,dkrr,dnr,knr,dbor,ddbor,dpr,kpr')
           endif
           sele ldknap
           skip
        endd

        sele lkln
        go top
        do while !eof()
           kklr=kkl
           sele dknap
           seek str(kklr,7)+str(361001,6)
           if foun()
              do while kkl=kklr.and.bs=361001
                 sklr=skl
                 dnr=dn
                 knr=kn
                 if !(dnr=0.and.knr=0).and..F.
                    skip
                    loop
                 endif
                 sele ldknap
                 seek str(kklr,7)+str(361001,6)+str(sklr,7)
                 if !foun()
                    sele dknap
                    netdel()
                    ?str(kklr,7)+' '+str(361001,6)+' '+str(sklr,7)+' Удален'
                 endif
                 sele dknap
                 skip
              endd
           endif
           sele lkln
           skip
        endd
        nuse('dknap')
        nuse('ldknap')
    next
next
nuse()
nuse('lkln')


******************
func odokk()
******************
sele lkln
go top
do while !eof()
   kklr=kkl
   sele dokk
   for klni=1 to 2
       if klni=1
          set orde to tag t10
          if netseek('t10','kklr,361001')
             do while kkl=kklr.and.bs_d=361001
                bs_sr=bs_s
                ddkr=ddk
                sklr=nap
                sele ldknap
                seek str(kklr,7)+str(361001,6)+str(sklr,7)
                if !foun()
                   appe blank
                   repl kkl with kklr,;
                        bs with 361001,;
                        skl with sklr
                endif
                repl db with db+bs_sr
                if ddb<ddkr
                   repl ddb with ddkr
                endif
                sele dokk
                skip
             endd
          endif
       else
          set orde to tag t11
          if netseek('t11','kklr,361001')
             do while kkl=kklr.and.bs_k=361001
                bs_sr=bs_s
                ddkr=ddk
                sklr=nap
                sele ldknap
                seek str(kklr,7)+str(361001,6)+str(sklr,7)
                if !foun()
                   appe blank
                   repl kkl with kklr,;
                        bs with 361001,;
                        skl with sklr
                endif
                repl kr with kr+bs_sr
                if dkr<ddkr
                   repl dkr with ddkr
                endif
                sele dokk
                skip
             endd
          endif
       endif
   next
   sele lkln
   skip
endd
retu .t.

******************
func odokko()
******************
sele lkln
go top
do while !eof()
   kklr=kkl
   sele dokko
   set orde to tag t10
   if netseek('t10','kklr,361001')
      do while kkl=kklr.and.bs_d=361001
         bs_sr=bs_s
         ddkr=ddk
         sklr=nap
         sele ldknap
         seek str(kklr,7)+str(361001,6)+str(sklr,7)
         if !foun()
            appe blank
            repl kkl with kklr,;
                 bs with 361001,;
                 skl with sklr
         endif
         repl dbo with dbo+bs_sr
         if ddbo<ddkr
            repl ddbo with ddkr
         endif
         sele dokko
         skip
      endd
   endif
   sele lkln
   skip
endd
retu .t.

***************
func odknap()
***************
sele lkln
go top
do while !eof()
   kklr=kkl
   tzdocr=getfield('t1','kklr','kpl','tzdoc')
   sele ldknap
   set orde to tag t1
*   seek str(kklr,7)+str(361001,6)
*   prnapr=0
*   do while kkl=kklr.and.bs=361001
*      if skl#0
*         prnapr=1
*         exit
*      endif
*      skip
*   endd
   seek str(kklr,7)+str(361001,6)+str(0,7)
   if foun()
      if dn+db-kn-kr<0 //.and.!(tzdocr=1.and.prnapr=1)
         dkr0r=dkr
         rc0r=recn()
         kr_r=abs(dn+db-kn-kr)
         sele ldknap
         set orde to tag t2
         seek str(kklr,7)+str(361001,6)
         if foun()
            do while kkl=kklr.and.bs=361001
               if skl=0
                  skip
                  loop
               endif
               rcxr=recn()
               if dn+db-kn-kr>0
                  if dn+db-kn-kr-kr_r>=0
                     repl kr with kr+kr_r
                     if dkr0r>dkr
                        repl dkr with dkr0r
                     endif
                     go rc0r
                     repl kr with kr-kr_r
                     go rcxr
                     kr_r=0
                     exit
                  else
                     kr_r=abs(dn+db-kn-kr-kr_r)
                     kr_rr=dn+db-kn-kr
                     repl kr with kr+kr_rr
                     if dkr0r>dkr
                        repl dkr with dkr0r
                     endif
                     go rc0r
                     repl kr with kr-kr_rr
                     go rcxr
                  endif
               endif
               sele ldknap
               skip
            endd
         endif
      endif
   endif
   sele lkln
   skip
endd
sele ldknap
set orde to tag t1
retu .t.
