clea
*set dele on
?set(11)
*set dele off
*?set(11)
wait
retu

?filedate('shrift.dbf')
wait
retu
aaa='   '
do while .t.
   inkey(0) 
   @2,1 say lastkey()
   if lastkey()=27
      exit
   endif
endd
retu


clea
netuse('cskl')
netuse('ctov')
netuse('nei')
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
   pathr=gcPath_d+alltrim(path)
   ?pathr
   if netfile('tov',1)
      netuse('tov',,,1,)
      netuse('tovm',,,1,)
      sele tov
      go top
      do while !eof()
         sklr=skl
         ktlr=ktl  
         mntovr=mntov
         keir=kei
         if empty(nei)
            ?'TOV'+' '+str(sklr,7)+' '+str(ktlr,9)
         endif
         neir=getfield('t1','keir','nei','nei')
         sele tov
         netrepl('nei','neir')
         sele tovm
         if netseek('t1','sklr,mntovr')
            if empty(nei)
               ?'TOVM'+' '+str(sklr,7)+' '+str(mntovr,7)
            endif
            netrepl('nei','neir')
         endif
         sele ctov
         if netseek('t1','mntovr')
            if empty(nei)
               ?'CTOV'+' '+str(mntovr,7)
            endif
            netrepl('nei','neir')
         endif
         sele tov
         skip
      endd
      sele tovm
      go top
      do while !eof()
         sklr=skl
         mntovr=mntov
         keir=kei 
         if empty(nei)
            ?'TOVM+'+' '+str(sklr,7)+' '+str(mntovr,7)
            neir=getfield('t1','keir','nei','nei') 
            sele tovm
            netrepl('nei','neir')
         endif
         sele tovm
         skip
      endd
      nuse('tov')
      nuse('tovm')
   endif
   sele  cskl
   skip 
endd