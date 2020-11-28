* Коррекция счетчиков
clea
aqstr=1
aqst:={"Просмотр","Коррекция"}
aqstr:=alert(" ",aqst)
if lastkey()=27
   retu
endif
*if !(year(gdTd)=year(date()).and.month(gdTd)=month(date()))
*   aqstr=1
*endif
set prin to txt.txt
set prin on

netuse('cskl')

cntctov()
cntctovk()
nuse()
set prin off
set prin to

func cntctov()
netind('ctov')
if !netuse('ctov',,'e')  
   ?'gnCtov=1 занят'
else   
   ?'gnCtov=1'
   sele ctov
   set orde to tag t1
   go top
   ?'CTOV двойники'
   mntovr=9999999
   do while !eof()
      if mntovr#mntov
         mntovr=mntov
      else
         ?str(mntov,7)
         netdel()
      endif
      sele ctov
      skip   
   endd
   netind('cgrp')
   netuse('cgrp')  
   set orde to tag t1
   go top
   ?'CGRP двойники'
   kgrr=999
   do while !eof()
      if kgrr#kgr
         kgrr=kgr
         if aqstr=2
            netrepl('mntov,ktl','0,0')
         endif   
      else
         ?str(kgr,3)
         if aqstr=2
            netdel()
         endif   
      endif
      sele cgrp
      skip   
   endd
   
   sele cskl
   go top
   do while !eof()
      if ent#gnEnt.or.ctov#1.or.sk=140.or.sk=141.or.sk=156
         sele cskl
         skip
         loop
      endif
      skr=sk
      msklr=mskl
      pathr=gcPath_d+alltrim(path)
      if !netfile('tov',1)
         sele cskl
         skip
         loop
      endif
      ?pathr
      netind('sgrp',1)
      netuse('sgrp',,,1)
      set orde to tag t1
      go top
      ?'SGRP двойники'
      kgrr=999
      do while !eof()
         if kgrr#kgr
            kgrr=kgr
         else
            ?str(kgr,3)
            if aqstr=2
               netdel()
            endif   
         endif
         sele sgrp
         skip   
      endd
      if msklr=1
         netind('sgrpe',1)
         netuse('sgrpe',,,1)
      endif
      netind('rs1',1)
      netuse('rs1',,,1)
      netind('pr1',1)
      netuse('pr1',,,1)
      netind('tov',1)
      netuse('tov',,,1)
      
      ?'TTN'
      sele rs1
      set orde to tag t1
      go bott
      ttnr=ttn+1
      sele cskl
      if ttn#ttnr
         ?' Тек '+str(ttn,6)+' Расч '+str(ttnr)
         if aqstr=2
*            netrepl('ttn','ttnr')
         endif
      endif
      
      ?'MN'
      sele pr1
      set orde to tag t2
      go bott
      mnr=mn+1
      sele cskl
      if mn#mnr
         ?' Тек '+str(mn,6)+' Расч '+str(mnr)
         if aqstr=2
*            netrepl('mn','mnr')
         endif
      endif
      
      ?'Группы'
      sele sgrp
      go top
      do while !eof()
         kgrr=kgr
         ktlr=kgrr*1000000 
         if aqstr=2
            netrepl('ktl','ktlr') 
         endif
         arec:={}
         getrec()
         sele cgrp
         if !netseek('t1','kgrr')
            ?str(kgrr,3)+' нет в CGRP'
            if aqstr=2
               netadd()
               putrec()
            endif   
         endif
         sele sgrp
         skip
      endd
      
      ?'MNTOV,KTL'
      sele sgrp
      go top
      sele cgrp
      go top
      sele tov
      set orde to tag t1
      go top
      do while !eof()
         mntovr=mntov
         ktlr=ktl
         kgrr=int(ktlr/1000000)
         if kg#kgrr
            if aqstr=2
               netrepl('kg','kgrr')
            endif   
         endif
         if (skr=140.or.skr=141.or.skr=156)
            if !(kgrr=10.or.kgrr=11.or.kgrr=0.or.kgrr=1)
               netdel()
               sele tov
               skip
               loop
            endif
         endif
         sele sgrp
         if !netseek('t1','kgrr')  
            sele cgrp
            if netseek('t1','kgrr')   
               arec:={} 
               getrec()
               sele sgrp
               netadd()
               putrec()     
            endif 
         endif  
         sele sgrp   
         if kgr#kgrr.or.eof()
            netseek('t1','kgrr') 
         endif   
         if kgr=kgrr.and.!eof()
            if ktl<=ktlr.and.int(ktlr/1000000)=kgr
               ?'SGRP Тек '+str(ktl,9)+' Расч '+str(ktlr,9)
               if aqstr=2
                  netrepl('ktl','ktlr+1')
               endif
            endif
         endif
         sele cgrp
         if kgr#kgrr.or.eof()
            netseek('t1','kgrr') 
         endif   
         if kgr=kgrr.and.!eof()
            if ktl<=ktlr
               ?'CGRP Тек '+str(ktl,9)+' Расч '+str(ktlr,9)
               if aqstr=2.and.int(ktlr/1000000)=kgr
                  netrepl('ktl','ktlr+1')
               endif
            endif
            if mntov<=mntovr.and.int(mntovr/10000)=kgr
               ?'CGRP Тек '+str(mntov,7)+' Расч '+str(mntovr,7)
               if aqstr=2
                  netrepl('mntov','mntovr+1')
               endif
            endif
         endif
         sele tov
         skip
      endd
      
      nuse('sgrp')
      if msklr=1
         nuse('sgrpe')
      endif
      nuse('rs1')
      nuse('pr1')
      nuse('tov')
      sele cskl
      skip   
   endd
endif
retu .t.

func cntctovk()
netind('ctovk')
if !netuse('ctovk',,'e')  
   ?'gnCtov=3 занят'
else
   ?'gnCtov=3'
   sele ctovk
   set orde to tag t1
   go top
   ?'CTOVK двойники'
   ktlr=999999999
   do while !eof()
      if ktlr#ktl
         ktlr=ktl
      else
         ?str(ktl,9)
         if aqstr=2
            netdel()
         endif   
      endif
      sele ctovk
      skip   
   endd
   netind('cgrpk')
   netuse('cgrpk')  
   set orde to tag t1
   go top
   ?'CGRPK двойники'
   kgrr=999
   do while !eof()
      if kgrr#kgr
         kgrr=kgr
         if aqstr=2
            netrepl('ktl','0')
         endif   
      else
         ?str(kgr,3)
         if aqstr=2
            netdel()
         endif   
      endif
      sele cgrpk
      skip   
   endd
   sele cskl
   go top
   do while !eof()
      if ent#gnEnt.or.ctov#3
         sele cskl
         skip
         loop
      endif
      msklr=mskl
      pathr=gcPath_d+alltrim(path)
      if !netfile('tov',1)
         sele cskl
         skip
         loop
      endif
      ?pathr
      netind('sgrp',1)
      netuse('sgrp',,,1)
      ?'SGRP двойники'
      kgrr=999
      do while !eof()
         if kgrr#kgr
            kgrr=kgr
         else
            ?str(kgr,3)
            if aqstr=2
               netdel()
            endif   
         endif
         sele sgrp
         skip   
      endd
      if msklr=1
         netind('sgrpe',1)
         netuse('sgrpe',,,1)
      endif
      netind('rs1',1)
      netuse('rs1',,,1)
      netind('pr1',1)
      netuse('pr1',,,1)
      netind('tov',1)
      netuse('tov',,,1)
      
      ?'TTN'
      sele rs1
      set orde to tag t1
      go bott
      ttnr=ttn+1
      sele cskl
      if ttn#ttnr
         ?' Тек '+str(ttn,6)+' Расч '+str(ttnr)
         if aqstr=2
            netrepl('ttn','ttnr')
         endif
      endif
      
      ?'MN'
      sele pr1
      set orde to tag t2
      go bott
      mnr=mn+1
      sele cskl
      if mn#mnr
         ?' Тек '+str(mn,6)+' Расч '+str(mnr)
         if aqstr=2
            netrepl('mn','mnr')
         endif
      endif
      
      ?'Группы'
      sele sgrp
      go top
      do while !eof()
         kgrr=kgr
         if aqstr=2
            netrepl('ktl','0') 
         endif
         arec:={}
         getrec()
         sele cgrpk
         if !netseek('t1','kgrr')
            ?str(kgrr,3)+' нет в CGRPK'
            if aqstr=2
               netadd()
               putrec()
            endif   
         endif
         sele sgrp
         skip
      endd
      
      ?'MNTOV,KTL'
      sele sgrp
      go top
      sele cgrpk
      go top  
      sele tov
      set orde to tag t1
      do while !eof()
         mntovr=mntov
         ktlr=ktl
         kgrr=int(ktlr/1000000)
         if kg#kgrr
            if aqstr=2
               netrepl('kg','kgrr')
            endif
         endif
         sele sgrp
         if kgr#kgrr.or.eof()
            netseek('t1','kgrr') 
         endif   
         if kgr=kgrr.and.!eof()
            if ktl<=ktlr
               ?'SGRP Тек '+str(ktl,9)+' Расч '+str(ktlr,9)
               if aqstr=2
                  netrepl('ktl','ktlr+1')
               endif
            endif
         endif
         sele cgrpk
         if kgr#kgrr.or.eof()
            netseek('t1','kgrr') 
         endif   
         if kgr=kgrr.and.!eof()
            if ktl<=ktlr.and.int(ktlr/1000000)=kgr
               ?'CGRPK Тек '+str(ktl,9)+' Расч '+str(ktlr,9)
               if aqstr=2
                  netrepl('ktl','ktlr+1')
               endif
            endif
         endif
         sele tov
         skip
      endd
      
      nuse('sgrp')
      if msklr=1
         nuse('sgrpe')
      endif
      nuse('rs1')
      nuse('pr1')
      nuse('tov')
      sele cskl
      skip
   endd
endif
retu .t.

func cpfls()
clea
sele dbft
go top
do while !eof()
   alsr=alltrim(als)
   fnamer=alltrim(fname)
   dirr=dir
   dirnr=dirn
   if dirr=dirnr
      skip
      loop 
   endif
   sele dir
   loca for dir=dirr
   cpathinr=alltrim(ndir)
   loca for dir=dirnr
   cpathoutr=alltrim(ndir)
   pathinr=&cpathinr
   pathoutr=&cpathoutr
   if !file(pathoutr+fnamer+'.dbf')
      if file(pathinr+fnamer+'.dbf')
         copy file (pathinr+fnamer+'.dbf') to (pathoutr+fnamer+'.dbf')
         erase (pathinr+fnamer+'.dbf')
         ?pathinr+fnamer+'.dbf'+' -> '+pathoutr+fnamer+'.dbf'
      endif
   else   
      ?pathoutr+fnamer+'.dbf'+' существует'
   endif
   if !file(pathoutr+fnamer+'.cdx')      
      if file(pathinr+fnamer+'.cdx')
         copy file (pathinr+fnamer+'.cdx') to (pathoutr+fnamer+'.cdx')
         erase (pathinr+fnamer+'.cdx')
         ?pathinr+fnamer+'.cdx'+' -> '+pathoutr+fnamer+'.cdx'
      endif
   else   
      ?pathoutr+fnamer+'.cdx'+' существует'
   endif   
   if !file(pathoutr+fnamer+'.fpt')   
      if file(pathinr+fnamer+'.fpt')
         copy file (pathinr+fnamer+'.fpt') to (pathoutr+fnamer+'.fpt')
         erase (pathinr+fnamer+'.fpt')
         ?pathinr+fnamer+'.fpt'+' -> '+pathoutr+fnamer+'.fpt'
      endif
   else   
      ?pathoutr+fnamer+'.fpt'+' существует'
   endif   
   sele dbft
   netrepl('dir','dirnr')
   skip
endd
wmess('Перемещение закончено',0)
retu .t.