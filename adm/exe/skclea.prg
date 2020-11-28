* Чистка складов (gnEntrm=1)
retu .t.
if gnEntrm=0
   retu
endif
clea
netuse('kpl')
netuse('cskl')
do while !eof()
   if ent#gnEnt
      skip
      loop
   endif
   if tpstpok#0
      skip
      loop
   endif
   if arnd=3
      skip
      loop
   endif
   if merch=1
      skip
      loop
   endif
   if rm=1
      skip
      loop
   endif
   pathr=gcPath_d+alltrim(path)
   if !netfile('tov',1)
      sele cskl
      skip
      loop
   endif
   ?pathr
   netuse('tov',,'e',1)
   zap
   use
   netuse('tovm',,'e',1)
   zap
   use
   netuse('pr1',,'e',1)
   zap
   use
   netuse('pr2',,'e',1)
   zap
   use
   netuse('pr3',,'e',1)
   zap
   use
   netuse('rs1',,'e',1)
   zap
   use
   netuse('rs2',,'e',1)
   zap
   use
   netuse('rs2m',,'e',1)
   zap
   use
   netuse('rs3',,'e',1)
   zap
   use
   sele cskl
   skip
endd
nuse()
*************
func crdop()
*************
netuse('cskl')
netuse('s_tag')
if gnScOut=0
   clea
   store gdTd to dt1r,dt2r
   setcolor(clr)
   if lastkey()=27.or.empty(dt1r).or.empty(dt2r).or.dt2r<dt1r
      retu .t.
   endif

   aqstr=1
   aqst:={"Просмотр","Коррекция"}
   aqstr:=alert(" ",aqst)
   if lastkey()=27
      retu .t.
   endif
else
   aqstr=2
endif

set print to crdop.txt
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
        pathbpr=gcPath_e+'g'+str(year(dtpr),4)+'\'+'m'+iif(month(dtpr)<10,'0'+str(month(dtpr),1),str(month(dtpr),2))+'\bank\'
        pathmr=pathgr+'m'+iif(mmr<10,'0'+str(mmr,1),str(mmr,2))+'\'
        pathbr=pathmr+'bank\'
        pathr=pathbpr
        if netfile('dkkln',1)
           netuse('dkkln','dkklnp',,1)
           pathr=pathbr
           if netfile('dkkln',1)
              netuse('dkkln',,,1)
              sele dkklnp
              go top
              do while !eof()
                 kklr=kkl
                 bsr=bs
                 ddbr=ddb
                 dkrr=dkr
                 if !empty(ddbr).or.!empty(dkrr)
                    sele dkkln
                    if netseek('t1','kklr,bsr')
                       if empty(ddb).and.!empty(ddbr)
                          ?'DKKLN DDB N'+' '+str(kklr,7)+' '+str(bsr,6)+' '+dtoc(ddb)+'->'+dtoc(ddbr)
                          if aqstr=2
                             netrepl('ddb','ddbr')
                          endif
                       endif
                       if empty(dkr).and.!empty(dkrr)
                          ?'DKKLN DKR N'+' '+str(kklr,7)+' '+str(bsr,6)+' '+dtoc(dkr)+'->'+dtoc(dkrr)
                          if aqstr=2
                             netrepl('dkr','dkrr')
                          endif
                       endif
                    endif
                 endif
                 sele dkklnp
                 skip
              endd
              nuse('dkkln')
              nuse('dknap')
           endif
           nuse('dkklnp')
        endif
        pathr=pathbr
        if netfile('dokk',1)
           ?pathbr+'dokk'
           pathr=pathbr
           if select('tsk')=0
              crtt('tsk','f:csk c:c(4)')
              sele 0
              use tsk excl
           else
              sele tsk
              zap
           endif
           netuse('dkkln',,,1)
           netuse('dokk',,,1)
           go top
           do while !eof()
              if mn#0.or.mnp#0
                 skip
                 loop
              endif
              skr=sk
              ttnr=rn
              bs_dr=bs_d
              bs_kr=bs_k
              ddkr=ddk
              kklr=kkl
              if int(bs_dr/1000)=361.or.int(bs_kr/1000)=361
                 cskr='s'+str(sk,3)
                 ccskr=str(sk,3)
                 sele tsk
                 locate for csk=cskr
                 if !foun()
                    appe blank
                    repl csk with cskr
                    dirsr=getfield('t1','skr','cskl','path')
                    pathr=pathmr+alltrim(dirsr)
                    netuse('rs1',cskr,,1)
                 else
                    sele (cskr)
                 endif
                 dopr=getfield('t1','ttnr',cskr,'dop')
                 ktar=getfield('t1','ttnr',cskr,'kta')
                 ktasr=getfield('t1','ttnr',cskr,'ktas')
                 if ktasr=0.and.ktar#0
                    ktasr=getfield('t1','ktar','s_tag','ktas')
                 endif
                 sele dokk
                 if dop#dopr
                    ?str(skr,3)+' '+str(ttnr,6)+' '+dtoc(dop)+'->'+dtoc(dopr)
                    if aqstr=2
                       netrepl('dop','dopr')
                    endif
                 endif
                 if kta#ktar
                    ?str(skr,3)+' '+str(ttnr,6)+' kta '+str(kta,4)+'->'+str(ktar,4)
                    if aqstr=2
                       netrepl('kta','ktar')
                    endif
                 endif
                 if ktas#ktasr
                    ?str(skr,3)+' '+str(ttnr,6)+' ktas '+str(ktas,4)+'->'+str(ktasr,4)
                    if aqstr=2
                       netrepl('ktas','ktasr')
                    endif
                 endif
              endif
              sele dokk
              if subs(dokkmsk,3,1)='1'
                 sele dkkln
                 if netseek('t1','kklr,bs_dr')
                    if ddkr>ddb
                       ?'DKKLN->DDB'+' '+dtoc(ddb)+'->'+dtoc(ddkr)
                       if aqstr=2
                          netrepl('ddb','ddkr')
                       endif
                    endif
                 endif
              endif
              sele dokk
              if subs(dokkmsk,4,1)='1'
                 sele dkkln
                 if netseek('t1','kklr,bs_kr')
                    if ddkr>dkr
                       ?'DKKLN->DKR'+' '+dtoc(dkr)+'->'+dtoc(ddkr)
                       if aqstr=2
                          netrepl('dkr','ddkr')
                       endif
                    endif
                 endif
              endif
              sele dokk
              skip
           endd
           nuse('dokk')
           nuse('dkkln')
           nuse('dknap')
           sele tsk
           go top
           do while !eof()
              cskr=csk
              nuse(cskr)
              sele tsk
              skip
           endd
        endif

        pathr=pathbr
        if netfile('dokko',1)
           ?pathbr+'dokko'
           pathr=pathbr
           if select('tsk')=0
              crtt('tsk','f:csk c:c(4)')
              sele 0
              use tsk excl
           else
              sele tsk
              zap
           endif
           netuse('dokko',,,1)
           go top
           do while !eof()
              skr=sk
              ttnr=rn
              cskr='s'+str(sk,3)
              ccskr=str(sk,3)
              sele tsk
              locate for csk=cskr
              if !foun()
                 appe blank
                 repl csk with cskr
                 dirsr=getfield('t1','skr','cskl','path')
                 pathr=pathmr+alltrim(dirsr)
                 netuse('rs1',cskr,,1)
              else
                 sele (cskr)
              endif
              dopr=getfield('t1','ttnr',cskr,'dop')
              ktar=getfield('t1','ttnr',cskr,'kta')
              ktasr=getfield('t1','ttnr',cskr,'ktas')
              if ktasr=0.and.ktar#0
                 ktasr=getfield('t1','ktar','s_tag','ktas')
              endif
              sele dokko
              if dop#dopr
                 ?str(skr,3)+' '+str(ttnr,6)+' '+dtoc(dop)+'->'+dtoc(dopr)
                 if aqstr=2
                    netrepl('dop,ddk','dopr,dopr')
                 endif
              endif
              if kta#ktar
                 ?str(skr,3)+' '+str(ttnr,6)+' kta '+str(kta,4)+'->'+str(ktar,4)
                 if aqstr=2
                    netrepl('kta','ktar')
                 endif
              endif
              if ktas#ktasr
                 ?str(skr,3)+' '+str(ttnr,6)+' ktas '+str(ktas,4)+'->'+str(ktasr,4)
                 if aqstr=2
                    netrepl('ktas','ktasr')
                 endif
              endif
              sele dokko
              skip
           endd
           nuse('dokko')
        endif
        sele tsk
        go top
        do while !eof()
           cskr=csk
           nuse(cskr)
           sele tsk
           skip
        endd
    next
next
set prin off
set prin to
retu .t.
**************
func chkdo()
**************
netuse('cskl')
netuse('tmesto')
netuse('s_tag')
netuse('moddoc')
netuse('mdall')
if gnScOut=0
   clea
   store gdTd to dt1r,dt2r
   clr=setcolor('gr+/b,n/bg')
   wr=wopen(8,20,11,60)
   wbox(1)
   @ 0,1 say 'Период с ' get dt1r
   @ 0,col()+1 say ' по ' get dt2r
   read
   wbox(1)
   wclose(wr)
   setcolor(clr)
   if lastkey()=27.or.empty(dt1r).or.empty(dt2r).or.dt2r<dt1r
      retu .t.
   endif

   aqstr=1
   aqst:={"Просмотр","Коррекция"}
   aqstr:=alert(" ",aqst)
   if lastkey()=27
      retu .t.
   endif
else
   aqstr=2
endif

set print to chkdo.txt
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
        pathbpr=gcPath_e+'g'+str(year(dtpr),4)+'\'+'m'+iif(month(dtpr)<10,'0'+str(month(dtpr),1),str(month(dtpr),2))+'\bank\'
        pathmr=pathgr+'m'+iif(mmr<10,'0'+str(mmr,1),str(mmr,2))+'\'
        ?pathmr
        pathbr=pathmr+'bank\'
        pathr=pathbr
        if netfile('dokko',1)
           netuse('bs',,,1)
           netuse('dokk',,,1)
           netuse('dokko',,,1)
           netuse('dkkln',,,1)
           netuse('dkklns',,,1)
           netuse('dkklna',,,1)
           * Проверить документы
           sele dokko
           set orde to tag t12
           go top
           sk_r=0
           do while !eof()
              skr=sk
              ttnr=rn
              if skr=0
                 if aqstr=2
                    sele dokko
                    netdel()
                 endif
                 ?str(skr,3)+' '+str(ttnr,6)+' '+'уд. sk=0'+' '+str(skr,3)
                 skip
                 loop
              endif
              if skr#sk_r
                 sele cskl
                 locate for sk=skr
                 pathr=pathmr+alltrim(path)
                 if !netfile('rs1',1)
                    if aqstr=2
                       sele dokko
                       netdel()
                    endif
                    ?str(skr,3)+' '+str(ttnr,6)+' '+'уд. нет складa'+' '+str(skr,3)
                    skip
                    loop
                 endif
              endif
              nuse('rs1')
              netuse('rs1',,,1)
              sk_r=skr
              sele rs1
              if !netseek('t1','ttnr')
                 if aqstr=2
                    sele dokko
                    netdel()
                 endif
                 ?str(skr,3)+' '+str(ttnr,6)+' '+'уд. нет в складе'+' '+str(skr,3)
              else
                 if prz=1
                    if aqstr=2
                       sele dokko
                       netdel()
                    endif
                    ?str(skr,3)+' '+str(ttnr,6)+' '+'уд. prz=1'+' '+str(skr,3)
                 else
                    if empty(dop)
                       if aqstr=2
                          sele dokko
                          netdel()
                       endif
                       ?str(skr,3)+' '+str(ttnr,6)+' '+'уд. empty(dop)'+' '+str(skr,3)
                    endif
                 endif
              endif
              nuse('rs1')
              sele dokko
              skip
           endd
           * Перестроить проводки
           if .f.
           sele cskl
           go top
           do while !eof()
              if ent#gnEnt
                 skip
                 loop
              endif
              if rasc=0
                 skip
                 loop
              endif
              pathr=pathmr+alltrim(path)
              if !netfile('rs1',1)
                 sele cskl
                 skip
                 loop
              endif
              ?pathr
              skr=sk
              netuse('rs1',,,1)
              netuse('rs3',,,1)
              netuse('soper',,,1)
              sele rs1
              go top
              do while !eof()
                 ttnr=ttn
                 ttn_r=ttnr
                 przr=prz
                 if przr=1
                    sele rs1
                    skip
                    loop
                 endif
                 dopr=dop
                 if empty(dopr)
                    sele rs1
                    skip
                    loop
                 endif
                 vur=gnVu
                 vor=vo
                 d0k1r=0
                 kop_r=mod(kop,100)
                 kplr=kpl
                 kgpr=kgp
                 nkklr=nkkl
                 kpvr=kpv
                 if pr361(d0k1r,vur,vor,kop_r)=0
                    sele rs1
                    skip
                    loop
                 endif
                 ?str(ttnr,6)+' '+str(przr,1)
                 rsprv(1,1)
                 sele rs1
                 skip
              endd
              nuse('rs1')
              nuse('rs3')
              nuse('soper')
              sele cskl
              skip
           endd
           endif
        endif
    next
next
set prin off
set prin to
nuse()
retu .t.

**************
func cment()
**************
if !file(gcPath_e+'s_tag.dbf')
   retu .t.
endif
netuse('s_tag')
netuse('cskl')
netuse('stage')
netuse('stagm')
netuse('stagtm')
netuse('stagt')
if gnScOut=0
   clea
   store gdTd to dt1r,dt2r
   clr=setcolor('gr+/b,n/bg')
   wr=wopen(8,20,11,60)
   wbox(1)
   @ 0,1 say 'Период с ' get dt1r
   @ 0,col()+1 say ' по ' get dt2r
   read
   wbox(1)
   wclose(wr)
   setcolor(clr)
   if lastkey()=27.or.empty(dt1r).or.empty(dt2r).or.dt2r<dt1r
      retu .t.
   endif

   aqstr=1
   aqst:={"Просмотр","Коррекция"}
   aqstr:=alert(" ",aqst)
   if lastkey()=27
      retu .t.
   endif
else
   aqstr=2
endif

set print to cment.txt
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
        pathbpr=gcPath_e+'g'+str(year(dtpr),4)+'\'+'m'+iif(month(dtpr)<10,'0'+str(month(dtpr),1),str(month(dtpr),2))+'\bank\'
        pathmr=pathgr+'m'+iif(mmr<10,'0'+str(mmr,1),str(mmr,2))+'\'
        pathbr=pathmr+'bank\'
        pathr=pathbr
        sele cskl
        go top
        do while !eof()
           if !(ent=gnEnt.and.rasc=1)
              skip
              loop
           endif
           pathr=pathmr+alltrim(path)
           if !netfile('rs1',1)
              skip
              loop
           endif
           ?pathr
           netuse('rs1',,,1)
           netuse('pr1',,,1)
           sele rs1
           go top
           do while !eof()
              ktar=kta
              ktasr=ktas
              sele s_tag
              if netseek('t1','ktar')
                 netrepl('ent','gnEnt')
              endif
              if netseek('t1','ktasr')
                 netrepl('ent','gnEnt')
              endif
              sele rs1
              skip
           endd
           sele pr1
           go top
           do while !eof()
              ktar=kta
              ktasr=ktas
              sele s_tag
              if netseek('t1','ktar')
                 netrepl('ent','gnEnt')
              endif
              if netseek('t1','ktasr')
                 netrepl('ent','gnEnt')
              endif
              sele pr1
              skip
           endd
           nuse('rs1')
           nuse('pr1')
           sele cskl
           skip
        endd
    next
next
sele s_tag
go top
do while !eof()
   if ent#gnEnt
      netdel()
   endif
   skip
endd
sele stage
go top
do while !eof()
   ktar=kta
   if !netseek('t1','ktar','s_tag')
      sele stage
      netdel()
   endif
   sele stage
   skip
endd
sele stagt
go top
do while !eof()
   ktar=kta
   if !netseek('t1','ktar','s_tag')
      sele stagt
      netdel()
   endif
   sele stagt
   skip
endd
sele stagm
go top
do while !eof()
   ktar=kta
   if !netseek('t1','ktar','s_tag')
      sele stagm
      netdel()
   endif
   sele stagm
   skip
endd
sele stagtm
go top
do while !eof()
   ktar=kta
   if !netseek('t1','ktar','s_tag')
      sele stagtm
      netdel()
   endif
   sele stagtm
   skip
endd
set prin off
set prin to
nuse()
retu .t.
*****************
func rskolpos()
*****************
set print to rskolpos.txt
set prin on
clea
netuse('cskl')
go top
do while !eof()
   if !(ent=gnEnt.and.rasc=1)
      skip
      loop
   endif
   pathr=gcPath_d+alltrim(path)
   if !netfile('tov',1)
      skip
      loop
   endif
   ?str(sk,3)+' '+nskl
   netuse('rs1',,,1)
   netuse('rs2',,,1)
   sele rs1
   do while !eof()
      if reclock(1)
         ttnr=ttn
         kolposr=kolpos
         kolpos_r=0
         sele rs2
         if kolposr#0
            if netseek('t1','ttnr',,,1)
               do while ttn=ttnr
                  kolpos_r=kolpos_r+1
                  skip
               endd
               if kolposr#kolpos_r
                  ?str(ttnr,6)+' RS1 '+str(kolposr,3)+' RS2 '+str(kolpos_r,3)
               endif
            else
               ?str(ttnr,6)+' RS1 '+str(kolposr,3)+' не найден в RS2'
            endif
         endif
         sele rs1
         netunlock()
      endif
      sele rs1
      skip
   endd
   nuse('rs1')
   nuse('rs2')
   sele cskl
   skip
endd
set prin off
set prin to
nuse()
wmess('Проверка окончена',0)
retu .t.

*****************
func docnap()
*****************
set print to docnap.txt
set prin on
clea
netuse('nap')
netuse('naptm')
netuse('ktanap')
netuse('ctov')
netuse('cskl')
go top
do while !eof()
   if !(ent=gnEnt.and.rasc=1)
      skip
      loop
   endif
   pathr=gcPath_d+alltrim(path)
   if !netfile('tov',1)
      skip
      loop
   endif
   ?str(sk,3)+' '+nskl
   netuse('rs1',,,1)
   netuse('rs2',,,1)
   netuse('pr1',,,1)
   netuse('pr2',,,1)
   ?'РАСХОД'
   sele rs1
   if fieldpos('nap')#0
      do while !eof()
         if reclock(1)
            ttnr=ttn
            ktar=kta
            ktasr=ktas
            napr=nap
            nap_r=nap
            if ktar#0
               napr=getfield('t1','ktar','ktanap','nap')
               if napr=0
                  if ktasr#0
                     napr=getfield('t1','ktasr','ktanap','nap')
                  endif
               endif
            endif
            netrepl('nap','napr',1)
            cnap_r=''
            sele rs2
            if netseek('t1','ttnr')
               do while ttn=ttnr
                  mntov_rr=mntov
                  mkeep_r=getfield('t1','mntov_rr','ctov','mkeep')
                  sele naptm
                  set orde to tag t2
                  if netseek('t2','mkeep_r')
                     do while mkeep=mkeep_r
                        cnap_rr=alltrim(str(nap,4))
                        cnap_rr=padl(cnap_rr,2,'0')
                        if at(cnap_rr,cnap_r)=0
                           cnap_r=cnap_r+cnap_rr+','
                        endif
                        skip
                     endd
                  endif
                  sele rs2
                  skip
               endd
            endif
            sele rs1
            if fieldpos('cnap')#0
               netrepl('cnap','cnap_r',1)
            endif
            if napr#nap_r
               ?str(ttnr,6)+str(napr,4)+' '+str(nap_r,4)
            endif
         endif
         netunlock()
         sele rs1
         skip
      endd
   endif
   ?'ПРИХОД'
   sele pr1
   if fieldpos('nap')#0
      do while !eof()
         if reclock(1)
            mnr=mn
            napr=nap
            nap_r=0
            sele pr2
            if netseek('t1','mnr',,,1)
               do while mn=mnr
                  mntovr=mntov
                  mkeepr=getfield('t1','mntovr','ctov','mkeep')
                  if mkeepr#0
                     nap_r=getfield('t2','mkeepr','naptm','nap')
                  endif
                  skip
               endd
               if nap_r#0
                  sele pr1
                  netrepl('nap','nap_r')
                  if napr#nap_r
                     ?str(mnr,6)+str(napr,4)+' '+str(nap_r,4)
                  endif
               endif
            endif
         endif
         sele pr1
         netunlock()
         sele pr1
         skip
      endd
   endif
   nuse('rs1')
   nuse('rs2')
   nuse('pr1')
   nuse('pr2')
   sele cskl
   skip
endd
set prin off
set prin to
nuse()
wmess('Проверка окончена',0)
retu .t.

*************
func dokkdv()
*************
clea
set prin to dokkdv.txt
set prin on
netuse('dokk')
sele dokk
set orde to tag t12
go top
do while !eof()
   if mn=0
      skip
      loop
   endif
   mnr=mn
   rndr=rnd
   skr=sk
   rnr=rn
   mnpr=mnp
   rcdokkr=recn()
   skip
   do while mn=mnr.and.rnd=rndr.and.sk=skr.and.rn=rnr
      netdel()
      ?str(mnr,6)+' '+str(rndr,6)+' '+str(skr,6)+' '+str(rnr,6)+' уд'
      skip
   endd
   sele dokk
   go rcdokkr
   skip
endd
nuse()
set prin off
set prin to
****************
func delrs102()
****************
set prin to delrs102.txt
set prin on
if !(gnSk=228.or.gnSk=259)
   retu .t.
endif
clea
dtr=gdTd
clr=setcolor('gr+/b,n/bg')
wr=wopen(8,20,11,60)
wbox(1)
@ 0,1 say 'Дата ' get dtr
read
wclose(wr)
if lastkey()=27
   retu .t.
endif
if lastkey()=13
   netuse('ctov')
   netuse('rs1')
   netuse('rs2')
   netuse('rs3')
   netuse('rs1kpk')
   netuse('rs2kpk')
   sele rs1kpk
   go top
   do while !eof()
      if ddc#dtr
         skip
         loop
      endif
      ttnr=ttn
      skpkr=skpk
      sele rs2kpk
      if netseek('t1','ttnr,skpkr')
         prdelr=0
         do while ttn=ttnr
            mntovr=mntov
            mkeepr=getfield('t1','mntovr','ctov','mkeep')
            if mkeepr=102
               prdelr=1
               exit
            endif
            sele rs2kpk
            skip
         endd
         if prdelr=1
            sele rs3
            if netseek('t1','ttnr')
               do while ttn=ttnr
                  netdel()
                  sele rs3
                  skip
               endd
            endif
            sele rs2
            if netseek('t1','ttnr')
               do while ttn=ttnr
                  netdel()
                  sele rs2
                  skip
               endd
            endif
            docguidr=''
            sele rs1
            if netseek('t1','ttnr')
               ?str(ttnr,6)+' удалена'
               netrepl('docguid','docguidr')
            endif
         endif
      endif
      sele rs1kpk
      skip
   endd
endif
nuse('')
set prin off
set prin to txt.txt
retu .t.
