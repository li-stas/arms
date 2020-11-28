* Синхронизация CROSID,CTOV предприятий
* Сжатие CTOV
* id n(10) name c(40)
clea
netuse('crosid')
netuse('ctov')
netuse('cgrp')
netuse('kln')
crtt('tent',"f:kkl c:n(8) f:kkl7 c:n(7) f:nkl c:c(40)")
sele 0
use tent
sele crosid
copy stru to scrosid exte
sele 0
use scrosid
do while !eof()
   if subs(field_name,1,2)='ID'
      if subs(field_name,3,2)='1C'
         kklr=0
         kkl7r=0
         nklr='1C'
      else
         kklr=val(subs(field_name,3))
         if kklr#gnKln_c
            sele setup
            loca for kkl=kklr
            nklr=uss
            kkl7r=kkl7
         else
            sele scrosid
            skip
            loop 
         endif
      endif  
      if empty(nklr)
         sele kln
         loca for kkl1=kklr
         nklr=nkl
         kkl7r=kkl     
      endif
      sele tent
      appe blank
      repl kkl with kklr,kkl7 with kkl7r,nkl with nklr
   endif
   sele scrosid
   skip
endd
use
erase scrosid.dbf

sele tent
go top
rctentr=slcf('tent',,,,,"e:kkl h:'Код8' c:n(8) e:kkl7 h:'Код7' c:n(7) e:nkl h:'Предприятие' c:c(40)",,,,,,,alltrim(gcName_c))
if lastkey()=27
   sele tent
   use
   nuse()
   retu .t.
endif
if lastkey()=13
   sele tent
   go rctentr
   kklr=kkl
   kkl7r=kkl7
   nklr=nkl
endif

sele tent
use
erase tent.dbf

clzv=setcolor('gr+/b,n/bg')
wzv=wopen(10,10,12,70)
wbox(1)
zvr=space(50)
@ 0,1 say 'Файл' get zvr
read
wclose(wzv) 
setcolor(clzv)

* Исходник
if kklr#0
   cidr='id'+alltrim(str(kklr,8))
   cnamer='n'+alltrim(str(kklr,8))
else
   cidr='id1c'
   cnamer='n1c'
endif

* Свой
cnatr='n'+alltrim(str(gnKln_c,8))
cmntovr='id'+alltrim(str(gnKln_c,8))

sele crosid
inde on str(&cidr,10) tag t9 to lcrosid
set orde to tag t9 in lcrosid

crtt('rid',"f:id c:n(10) f:name c:c(50) f:mntov c:n(7) f:nat c:c(40)")
sele 0
use rid
appe from (zvr)
rccr=recc()
@ 0,1 say str(rccr,10)
go top
do while !eof()
   @ 1,1 say str(recn(),10) 
   mntovr=mntov
   sele crosid
   seek str(mntovr,10)
   if foun()
      idr=mntov
      namer=&cnatr     
      sele rid
      repl id with idr,;
           name with namer
   endif
   sele rid
   skip
endd
go top

rcridr=recn()
kg_r=0
do while .t.
   foot('ENTER,INS','Выполнить,Справочник')
   sele rid
   go rcridr
   rcridr=slcf('rid',1,1,18,,"e:name h:'Свой' c:c(38) e:mntov h:'Код' c:n(7) e:nat h:'Источник' c:c(30)",,,1)
   if lastkey()=27
      sele rid
      use  
      nuse()  
      erase rid.dbf
      erase lcrosid.cdx
      retu  
   endif 
   if lastkey()=13
      exit
   endif
   if lastkey()=22
      go rcridr 
      namer=name
      @ 0,2 say namer color 'r/w'
      @ 2,2 say namer color 'r/w'
      sele ctov
      set orde to tag t2
      if !netseek('t2','kg_r')
         go top
      endif
      rcctovr=recn()    
      do while .t.    
         foot('ENTER,F8','Выбрать,Группа')
         rcctovr=slcf('ctov',1,40,18,,"e:mntov h:'Код' c:n(7) e:nat h:'Наименование' c:c(30)")
         if lastkey()=27
            exit   
         endif 
         go rcctovr
         mntovr=mntov
         do case
            case lastkey()=13
                 go rcctovr
                 mntovr=mntov
                 natr=nat   
                 sele rid
                 netrepl('id,name','mntovr,natr')   
                 exit 
            case lastkey()=-7
                 sele cgrp
                 set orde to tag t2
                 go top
                 rcn_gr=recn()
                 do while .t.
                    sele cgrp
                    set orde to tag t2
                    rcn_gr=recn()
                    forgr='.T.'
                    kg_r=slcf('cgrp',,,,,"e:kgr h:'Код' c:n(3) e:ngr h:'Наименование' c:c(20)",'kgr',,,,forgr)
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
                               go rcn_gr
                            endif
                            loop
                       othe
                            loop
                    endc
                 endd
                 sele ctov
                 loop
            case lastkey()>32.and.lastkey()<255
                 sele ctov
                 lstkr=upper(chr(lastkey()))
                 if !netseek('t2','int(mntovr/10000),lstkr')
                    go rcctovr
                 else
                    rcctovr=recn()
                 endif
         endc
      endd
   endif
endd
*rest scre from sczv

nuse('crosid')
netuse('crosid')
sele rid
go top
do while !eof()
   if mntov=0
      skip
      if eof()
         exit
      endif    
      loop  
   endif  
   idr=id
   namer=name
   mntovr=mntov
   natr=nat 
   sele crosid
   if netseek('t1','idr')   
      netrepl(cidr+','+cnamer,'mntovr,natr')
   endif
   sele rid
   skip
endd

sele rid  
use 
erase rid.dbf
nuse()
erase lcrosid.cdx
retu .t.

**************
func sictov()
**************
if gnEnt=13
   retu
endif
sele setup
rcnr=recn()
locate for ent=13
pathe_r=alltrim(path_e)
clea
clgr=setcolor('gr+/b,n/bg')
wgr=wopen(10,20,13,60)
wbox(1)
kgrr=999
@ 0,1 say 'Группа' get kgrr pict '999'
@ 1,1 say '999 - Все' 
read
if lastkey()=27
   retu
endif
wclose(wgr)
setcolor(clgr)

aqstr=1
aqst:={"Просмотр","Коррекция"}
aqstr:=alert(" ",aqst)
if lastkey()=27
   retu
endif
set prin to ctov.txt
set prin on
netuse('ctov')
pathr=pathe_r
netuse('ctov','ctov13',,1)
fmntovr='mntov'+alltrim(str(gnEnt,2))
sele ctov
do while !eof()
   mntovr=mntov
   if mntovr=0
      skip
      loop  
   endif
   if kgrr#999
      if int(mntovr/10000)#kgrr
         skip
         loop
      endif
   endif
*   if mntovr=3500105
*      wait
*   endif
   kg_r=int(mntovr/10000)
   mntov13r=mntov13
   natr=nat
   nat_r=upper(nat)
   izgr=izg
   upakpr=upakp
   mntov_r=0
   mntov13_r=0
   sele ctov13
   set orde to
   loca for &fmntovr=mntovr
   if foun()
      mntov13_r=mntov
      if nat=natr &&.and.izg=izgr.and.upakp=upakpr
         sele ctov
         if mntov13r#mntov13_r
            ?str(mntovr,7)+' '+str(gnEnt,2)+'-'+str(mntov13r,7)+' 13-'+str(mntov13_r,7)+' '+natr
            if aqstr=2
               netrepl(mntov13,'mntov13_r')
            endif
         endif
         skip
         loop 
      endif
   endif      
   if mntov13_r=0
      sele ctov13
      if mntov13r#0
         nat_rr=getfield('t1','mntov13r','ctov13','nat')  
         if nat_rr=natr
            sele ctov
            skip
            loop     
         endif  
      endif    
      netseek('t2','kg_r,nat_r')
*      loca for nat=natr &&.and.izg=izgr.and.upakp=upakpr   
      if foun()
         mntov13_r=mntov
         mntov_r=&fmntovr
         ?'Наим '+str(gnEnt,2)+'-'+str(mntovr,7)+' 13-'+str(mntov13_r,7)+' '+natr
         if aqstr=2
            sele ctov13
            netrepl(fmntovr,'mntovr')
            sele ctov
            netrepl('mntov13','mntov13_r')
            skip
            loop
        endif
      else
        ?str(mntovr,7)+' '+natr+'Нет соотв'   
        if mntov13r#0
           nat_rr=getfield('t1','mntov13r','ctov13','nat')  
           if !empty(nat_rr)    
              ?str(mntov13r,7)+' '+nat_rr+' 13 '   
           endif  
        endif 
      endif
   endif 
   sele ctov
   skip
endd
nuse('ctov13')
nuse()

set prin off
set prin to
retu .f.

***************
func ctovpk()
***************
clea
clcp=setcolor('gr+/b,n/bg')
wcp=wopen(10,10,13,70)
wbox(1)

do while .t.
   store gdTd to dt1r,dt2r
   prpkr=0
   @ 0,1 say 'Период' get dt1r
   @ 0,col()+1 get dt2r
   read
   if lastkey()=27
      exit
   endif 
   if lastkey()=13
      prpkr=1
      exit    
   endif
endd
wclose(wcp) 
setcolor(clcp)
if prpkr=1
   netuse('ctov')
   netuse('cskl')
   crtt('tctov','f:mntov c:n(7) f:prud c:n(1)')
   sele 0
   use tctov
   inde on str(mntov,7) tag t1 
   yy1r=year(dt1r)
   yy2r=year(dt2r)
   for g=yy1r to yy2r
       do case
          case yy1r=yy2r
               mm1r=month(dt1r)  
               mm2r=month(dt2r)  
          case g=yy1r
               mm1r=month(dt1r)  
               mm2r=12  
          case g=yy2r
               mm1r=1  
               mm2r=month(dt2r)  
          other 
               mm1r=1  
               mm2r=12  
       endc   
       for m=mm1r to mm2r
           pathdr=gcPath_e+'g'+str(g,4)+'\m'+iif(m<10,'0'+str(m,1),str(m,2))+'\'
           sele cskl
           go top
           do while !eof()
              if ent#gnEnt
                 skip
                 loop   
              endif     
              if ctov#1
                 skip  
                 loop 
              endif
              pathr=pathdr+alltrim(path)  
              if !netfile('tov',1)    
                 sele cskl
                 skip
                 loop   
              endif  
              ?pathr 
              netuse('tovm',,,1) 
              go top
              do while !eof()
                 if mntov=0
                    skip
                    loop    
                 endif  
                 mntovr=mntov
                 sele tctov
                 seek str(mntovr,7)    
                 if !foun()
                    netadd()
                    netrepl('mntov','mntovr')   
                 endif   
                 sele tovm
                 skip  
              endd    
              nuse('tovm') 
              sele cskl
              skip 
           endd     
       next     
   next
   sele ctov
   go top
   do while !eof()
      mntovr=mntov
      if !netseek('t1','mntovr','tctov')   
         ?str(mntovr,7)    
         sele ctov
         netdel()
      endif  
      sele ctov
      skip      
   endd
   nuse()
   sele tctov
   use
endif
retu .t.

func ctovmerch()
if !(gnEnt=20.or.gnEnt=21)
   retu .t.
endif
clea
netuse('ctov')
netuse('cskl')
yyr=year(gdTd)
mmr=month(gdTd)
for yy=yyr to 2006 step -1
    do case
       case yy=yyr
            mm1r=mmr
            mm2r=1
       case yyr=2006
            mm1r=12
            mm2r=8
       othe      
            mm1r=12
            mm2r=1
    endc
    for mm=mm1r to mm2r step -1
        sele cskl
        go top
        do while !eof()
           if ent#gnEnt
              skip
              loop   
           endif  
           if ctov=0
              skip
              loop   
           endif  
           if gnEnt=20
              if !(rasc=1.or.sk=240)
                 skip
                 loop   
              endif 
           else
              if !(rasc=1.or.sk=237)
                 skip
                 loop   
              endif 
           endif
           pathr=gcPath_e+'g'+str(yy,4)+'\m'+iif(mm<10,'0'+str(mm,1),str(mm,2))+'\'+alltrim(path)                   
           if !netfile('tovm',1)  
              skip
              loop  
           endif  
           ?pathr
           netuse('tovm',,,1)
           do while !eof()
              if int(mntov/10000)<2
                 skip
                 loop   
              endif  
              if mkeep=0
                 skip
                 loop  
              endif   
              mntovr=mntov
              sele ctov
              if netseek('t1','mntovr')  
                 if merch=0
                    netrepl('merch','1')
                 endif  
              endif    
              sele tovm
              skip
           endd 
           nuse('tovm')   
           sele cskl  
           skip
        endd   
    next
next
nuse('')
wmess('Проверка закончена')
retu .t.

***************
func crarnd()
***************
clea
set prin to crpra.txt
set prin on
netuse('cskl')
netuse('tmesto')
netuse('etm')
sele cskl
locate for ent=gnEnt.and.arnd=3 && Субаренда
pathr=gcPath_d+alltrim(path)
?pathr
skr=sk
if netfile('tov',1)
   netuse('pr1',,,1) 
   netuse('pr2',,,1) 
   netuse('pr3',,,1) 
   netuse('tov',,,1) 
   netuse('tovm',,,1) 
   sele pr1
   set orde to tag t2
   go top
   do while !eof()
      if kop#193 && 193 - Приход в субаренду
         sele pr1
         skip
         loop  
      endif 
      rcnr=recn()
      amnr=amn
      sksr=sks
      sklsr=skls
      if amnr#0.and.sksr#0.and.sklsr#0
         do while .t.
            locate for amn=amnr.and.recn()#rcnr
            if foun()
               mnr=mn
               pradel(mnr)
               ?'mn'+' '+str(mnr,6)+' '+'amn'+' '+'двойник удален'
               sele pr1
            else
               sele pr1
               go rcnr
               exit
            endif
         endd
      endif   
      ndr=nd
      mnr=mn
      amnr=amn
      sksr=sks
      sklsr=skls
      sklr=skl
      prdelr=0
      if amnr=0.or.sksr=0.or.sklsr=0
         ?'mn'+' '+str(mnr,6)+' '+'amnr'+' '+str(amnr,6)+' '+'sksr'+' '+str(sksr,6)+' '+'sklr'+' '+str(sklr,6)
         prdelr=1
      else 
         sele cskl
         locate for sk=sksr 
         pathr=gcPath_d+alltrim(path)  
         if !netfile('rs1',1) 
            ?'mn'+' '+str(mnr,6)+' '+'amnr'+' '+str(amnr,6)+' '+'sksr'+' '+str(sksr,6)+' '+'sklr'+' '+str(sklr,6)+' '+'нет источника'
            prdelr=1
         else
            netuse('rs1',,,1)   
            if !netseek('t1','amnr')
               ?'mn'+' '+str(mnr,6)+' '+'amnr'+' '+str(amnr,6)+' '+'sksr'+' '+str(sksr,6)+' '+'sklr'+' '+str(sklr,6)+' '+'нет в источнике'
               prdelr=1
            else
               sktr=skt
               skltr=sklt
               amn_r=amn 
               kplr=kpl
               kgpr=kgp
*               skl_r=getfield('t2','kplr,kgpr','tmesto','tmesto')
               if !(amn_r=mnr.and.sktr=skr.and.skltr=sklr)
                  ?'mn'+' '+str(mnr,6)+' '+'назначение несовпадает с источником'
                  prdelr=1
               else
               endif   
            endif
            nuse('rs1') 
         endif 
      endif
      if prdelr=1
         sele pr1
         go rcnr
         pradel(mnr)
         ?'mn'+' '+str(mnr,6)+' '+'удален'
         sele pr1
         go rcnr
      else
         sele pr1
         go rcnr
         if nd#amn   
            amnr=amn
            sksr=sks
            locate for sks=sksr.and.nd=amnr
            if !foun()
               go rcnr 
               netrepl('nd','amnr')
            endif
            go rcnr
         endif
      endif
      sele pr1
      skip
   endd 
   nuse('pr1') 
   nuse('pr2') 
   nuse('pr3') 
   nuse('tov') 
   nuse('tovm') 
endif   
sele cskl
go top
do while  !eof()
   if ent#gnEnt
      skip
      loop
   endif
   if arnd#2 && Аренда
      skip
      loop
   endif 
   pathr=gcPath_d+alltrim(path)
   ?pathr
   skr=sk
   rccskr=recn()
   if netfile('tov',1)
      netuse('pr1',,,1) 
      netuse('pr2',,,1) 
      netuse('pr3',,,1) 
      netuse('tov',,,1) 
      netuse('tovm',,,1) 
      sele pr1
      set orde to tag t2
      go top
      do while !eof()
         if kop#183 && Приход из субаренды
            sele pr1
            skip
            loop  
         endif 
         rcnr=recn()
         amnr=amn
         sksr=sks
         sklsr=skls
         if amnr#0.and.sksr#0.and.sklsr#0
            do while .t.
               locate for amn=amnr.and.recn()#rcnr
               if foun()
                  mnr=mn
                  pradel(mnr)
                  ?'mn'+' '+str(mnr,6)+' '+'amn'+' '+'двойник удален'
                  sele pr1
               else
                  sele pr1
                  go rcnr
                  exit
               endif
            endd
         endif   
         ndr=nd
         mnr=mn
         amnr=amn
         sksr=sks
         sklsr=skls
         sklr=skl
         prdelr=0
         if amnr=0.or.sksr=0.or.sklsr=0
            ?'mn'+' '+str(mnr,6)+' '+'amnr'+' '+str(amnr,6)+' '+'sksr'+' '+str(sksr,6)+' '+'sklr'+' '+str(sklr,6)
            prdelr=1
         else 
            sele cskl
            locate for sk=sksr 
            pathr=gcPath_d+alltrim(path)  
            if !netfile('rs1',1) 
               ?'mn'+' '+str(mnr,6)+' '+'amnr'+' '+str(amnr,6)+' '+'sksr'+' '+str(sksr,6)+' '+'sklr'+' '+str(sklr,6)+' '+'нет источника'
               prdelr=1
            else
               netuse('rs1',,,1)   
               if !netseek('t1','amnr')
                  ?'mn'+' '+str(mnr,6)+' '+'amnr'+' '+str(amnr,6)+' '+'sksr'+' '+str(sksr,6)+' '+'sklr'+' '+str(sklr,6)+' '+'нет в источнике'
                  prdelr=1
               else
                  sktr=skt
                  skltr=sklt
                  amn_r=amn 
                  kplr=kpl
                  kgpr=kgp
   *               skl_r=getfield('t2','kplr,kgpr','tmesto','tmesto')
                  if !(amn_r=mnr.and.sktr=skr.and.skltr=sklr)
                     ?'mn'+' '+str(mnr,6)+' '+'назначение несовпадает с источником'
                     prdelr=1
                  else
                  endif   
               endif
               nuse('rs1') 
            endif 
            sele cskl
            go rccskr
         endif
         if prdelr=1
            sele pr1
            go rcnr
            pradel(mnr)
            ?'mn'+' '+str(mnr,6)+' '+'удален'
            sele pr1
            go rcnr
         else
            sele pr1
            go rcnr
            if nd#amn   
               amnr=amn
               sksr=sks
               locate for sks=sksr.and.nd=amnr
               if !foun()
                  go rcnr 
                  netrepl('nd','amnr')
               endif
               go rcnr
            endif
         endif
         sele pr1
         skip
      endd 
      nuse('pr1') 
      nuse('pr2') 
      nuse('pr3') 
      nuse('tov') 
      nuse('tovm') 
   endif  
   sele cskl
   skip
endd
nuse()
set prin off
set prin to
wait 'Проверка закончена'
retu .t.

**************
func pradel(p1)
**************
mn_r=p1
sele pr1
skl_r=skl
sele pr2
if netseek('t1','mn_r')
   do while mn=mn_r
      kfr=kf
      ktlr=ktl
      mntovr=mntov
      sele tov
      if netseek('t1','skl_r,ktlr')
         netrepl('osv,osf,osfo','osv-kfr,osf-kfr,osfo-kfr') 
      endif
      sele tovm
      if netseek('t1','skl_r,mntovr')
         netrepl('osv,osf,osfo','osv-kfr,osf-kfr,osfo-kfr') 
      endif
      sele pr2
      netdel()
      sele pr2
      skip
   endd
endif
sele pr3
if netseek('t1','mn_r')
   do while mn=mn_r
      netdel()
      skip
   endd
endif   
sele pr1
netdel()
retu .t.
****************
func rsadel(p1)
****************
ttn_r=p1
skl_r=skl
sele rs2
if netseek('t1','ttn_r')
   do while ttn=ttn_r
      kvpr=kf
      ktlr=ktl
      mntovr=mntov
      sele tov
      if netseek('t1','skl_r,ktlr')
         netrepl('osv,osf,osfo','osv+kvpr,osf+kvpr,osfo+kvpr') 
      endif
      sele tovm
      if netseek('t1','skl_r,mntovr')
         netrepl('osv,osf,osfo','osv+kvpr,osf+kvpr,osfo+kvpr') 
      endif
      sele rs2
      netdel()
      sele rs2
      skip
   endd
endif
sele rs3
if netseek('t1','ttnr')
   do while ttn=ttnr
      netdel()
      skip
   endd
endif   
sele rs1
netdel()
retu .t.
