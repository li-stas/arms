* Структура продаж
clea
netuse('spotd')
netuse('spbm')
netuse('spmk')
netuse('spfoc')
netuse('mkeep')
netuse('fent')
netuse('fbr')
netuse('fag')
netuse('s_tag')
netuse('brand')
netuse('kplkgp')

sele spotd
rcspotdr=recn()
do while .t.
   sele spotd
   go rcspotdr
   foot('INS,DEL,F4,F2,ENTER','Добавить,Удалить,Коррекция,Бригады,Бр.Менедж')
   rcspotdr=slcf('spotd',1,1,,,"e:kotd h:'Код' c:n(2) e:notd h:'Наименование' c:c(20)",,,1,,,,'Отделы продаж')
   if lastkey()=27
      exit
   endif
   go rcspotdr
   kotdr=kotd
   notdr=notd
   do case
      case lastkey()=22 && INS
           otdins()
      case lastkey()=7  && DEL
           sele spbm
           set orde to tag t2
           if netseek('t2','kotdr')
              do while kotd=kotdr
                 kbmr=kbm
                 sele spmk
                 if netseek('t1','kbmr')
                    do while kbm=kbmr
                       netdel()  
                       skip
                    endd 
                 endif
                 sele spbm
                 netdel()
                 skip
              endd
           endif
           sele spotd
           netdel()      
           skip -1
           if bof()
              go top 
           endif       
           rcspotdr=recn()   
      case lastkey()=-3 && Corr
           otdins(1)
      case lastkey()=13  && БМ
           save scre to scbm   
           spbm()
           rest scre from scbm   
      case lastkey()=-1  && Бригады
           save scre to scfoc
           spfoc()
           rest scre from scfoc
   endc   
endd
nuse()

func otdins(p1)
if p1=nil
   kotdr=0
   notdr=space(20)
endif
cler=setcolor('gr+/b,n/w')
wer=wopen(10,15,14,60)
wbox(1)
do while .t.
   @ 0,1 say 'Код'+' '+str(kotdr,3)
   @ 1,1 say 'Наименование' get notdr 
   @ 2,1 prom '<Верно>'
   @ 2,col()+1 prom '<Не верно>'
   read
   if lastkey()=27
      exit
   endif
   notdr=upper(notdr)
   menu to mer
   if mer=1
      if p1=nil
         go bott
         if eof()
            kotdr=1
         else
            kotdr=kotd+1
         endif
         netadd()
         netrepl('kotd,notd','kotdr,notdr')
         rcspotdr=recn()
         exit
      else
         if netseek('t1','kotdr')
            netrepl('notd','notdr')
            exit
         endif
      endif
   endif
enddo
wclose(wer)
setcolor(cler)
retu .t.

func spbm()
sele spbm
set orde to tag t2
netseek('t2','kotdr') 
rcspbmr=recn()
do while .t.
   sele spbm
   go rcspbmr
   foot('INS,DEL,F4,ENTER','Добавить,Удалить,Коррекция,Маркодержатели')
   rcspbmr=slcf('spbm',1,29,,,"e:kbm h:'Код' c:n(2) e:nbm h:'Бренд менеджеры' c:c(20)",,,1,'kotd=kotdr',,,alltrim(notdr))
   if lastkey()=27
      exit
   endif
   go rcspbmr
   kbmr=kbm
   nbmr=nbm
   do case
      case lastkey()=22 && INS
           bmins()
      case lastkey()=7  && DEL
           sele spmk
           if netseek('t1','kbmr')
              do while kbm=kbmr
                 netdel()  
                 skip
              endd 
           endif
           sele spbm
           netdel()
           skip -1
           if kotd#kotdr
              netseek('t1','kotdr') 
           endif       
           rcspbmr=recn()   
      case lastkey()=-3 && Corr
           bmins(1)
      case lastkey()=13  && Мkeep
           save scre to scmk
           spmk()
           rest scre from scmk
   endc   
endd
retu .t.

func bmins(p1)
if p1=nil
   kbmr=0
   nbmr=space(20)
endif
cler=setcolor('gr+/b,n/w')
wer=wopen(10,15,14,60)
wbox(1)
do while .t.
   @ 0,1 say 'Код'+' '+str(kbmr,3)
   @ 1,1 say 'Наименование' get nbmr 
   @ 2,1 prom '<Верно>'
   @ 2,col()+1 prom '<Не верно>'
   read
   if lastkey()=27
      exit
   endif
   nbmr=upper(nbmr)
   menu to mer
   if mer=1
      if p1=nil
         set orde to tag t1  
         go bott
         if eof()
            kbmr=1
         else
            kbmr=kbm+1
         endif
         set orde to tag t2  
         netadd()
         netrepl('kotd,kbm,nbm','kotdr,kbmr,nbmr')
         rcspbmr=recn()
         exit
      else
         if netseek('t2','kotdr,kbmr')
            netrepl('nbm','nbmr')
            exit
         endif
      endif
   endif
enddo
wclose(wer)
setcolor(cler)
retu .t.

func spmk()
sele spmk
set orde to tag t1
netseek('t1','kbmr') 
rcspmkr=recn()
do while .t.
   sele spmk
   go rcspmkr
   foot('INS,DEL','Добавить,Удалить')
   rcspmkr=slcf('spmk',1,57,,,"e:mkeep h:'Код' c:n(3) e:getfield('t1','spmk->mkeep','mkeep','nmkeep') h:'Маркодержатели' c:c(14)",,,1,'kbm=kbmr',,,alltrim(nbmr))
   if lastkey()=27
      exit
   endif
   go rcspmkr
   mkeepr=mkeep
   do case
      case lastkey()=22 && INS
           mkins()
           sele spmk
           netseek('t1','kbmr') 
           rcspmkr=recn()
      case lastkey()=7  && DEL
           netdel()
           skip -1
           if kbm#kbmr
              netseek('t1','kbmr') 
           endif           
           rcspmkr=recn()
   endc   
endd
retu .t.
   
func mkins()
if select('sl')=0
   sele 0
   use _slct alias sl excl
endif
sele sl
zap
sele mkeep
go top
rcmkr=recn()
do while .t.
   foot('','')
   sele mkeep
   go rcmkr 
   rcmkr=slcf('mkeep',1,30,18,,"e:mkeep h:'Код' c:n(3) e:nmkeep h:'Наименование' c:c(20)",,1,,,,'gr+/b,n/w','Маркодержатели')
   if lastkey()=27
      exit
   endif
   if lastkey()=13
      sele sl
      go top
      do while !eof()
         rcmkeepr=val(kod)
         sele mkeep
         go rcmkeepr
         mkeepr=mkeep     
         sele spmk
         if !netseek('t1','kbmr,mkeepr')
            netadd()
            netrepl('kbm,mkeep','kbmr,mkeepr')
         endif
         sele sl
         skip
      endd
      sele sl
      use
      exit
   endif
endd
retu .t.

func spfoc()
sele spfoc
set orde to tag t1
netseek('t1','kotdr') 
rcspfocr=recn()
do while .t.
   sele spfoc
   go rcspfocr
   foot('INS,DEL','Добавить,Удалить')
   rcspfocr=slcf('spfoc',1,29,,,"e:kfent h:'Код' c:n(3) e:getfield('t1','spfoc->kfent','fent','nfent') h:'Бригады' c:c(14)",,,1,'kotd=kotdr',,,alltrim(notdr))
   if lastkey()=27
      exit
   endif
   go rcspfocr
   kfentr=kfent
   do case
      case lastkey()=22 && INS
           focins()
           sele spfoc
           netseek('t1','kotdr') 
           rcspfocr=recn()
      case lastkey()=7  && DEL
           netdel()
           skip -1
           if kotd#kotdr
              netseek('t1','kotdr') 
           endif           
           rcspfocr=recn()
   endc   
endd
retu .t.

func focins()
sele fent
go top
rcfentr=recn()
do while .t.
   foot('','')
   sele fent
   go rcfentr 
   rcfentr=slcf('fent',1,30,18,,"e:kfent h:'Код' c:n(3) e:nfent h:'Наименование' c:c(20)",,,,,,'gr+/b,n/w','Бригады')
   if lastkey()=27
      exit
   endif
   if lastkey()=13
      go rcfentr
      kfentr=kfent
      sele spfoc
      if !netseek('t1','kotdr,kfentr')
         netadd()
         netrepl('kotd,kfent','kbmr,kfentr')
         rcspfocr=recn()
      endif
   endif
endd
retu .t.

func agcor()
clea
?'STAGTM'
netuse('s_tag')
netuse('stagtm')
store 0 to tmestor,ktasr
sele stagtm
do while !eof()
*   if tmesto=164
*wait
*   endif 
   if tmesto=tmestor.and.kta=ktar
      netdel()
      ?str(tmestor,7)+' '+str(ktar,4)+' двойник удален'  
      skip 
      loop
   else
      tmestor=tmesto
      ktar=kta
   endif    
   uvolr=getfield('t1','ktar','s_tag','uvol')
   if uvolr=1
      sele stagtm
      netdel()
      ?str(tmestor,7)+' '+str(ktar,4)+' '+str(uvolr,1)+' уволен удален'  
      skip 
      loop
   endif
   skip
endd
nuse('')
wmess('Проверка окончена',0)
retu .t.
