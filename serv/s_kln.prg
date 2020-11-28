clea
netuse('kobl')
netuse('kfs')
netuse('opfh')
netuse('knasp')
netuse('kgos')
netuse('kulc')
netuse('krn')
netuse('banks')
netuse('kln')
sele kln
rckklr=recn()
oclr=setcolor('w+/b')
clea
for_r='.t.'
forr=for_r
fldnomr=1
do while .t.
   sele kln
   set orde to tag t1
   go rckklr
   foot('INS,DEL,F3,F4,F7','Добавить,Удалить,Фильтр,Коррекция,Дв')
   set cent off
   rckklr=slce('kln',1,,18,,"e:kkl h:'Код' c:n(7) e:kklp h:'Родитель' c:n(7) e:kkl1 h:'ОКПО' c:n(10) e:nkl h:'Наименование' c:c(30) e:krn h:'Рн' c:n(4) e:knasp h:'НасП' c:n(4) e:adr h:'Адрес' c:c(40)",,,1,,forr,,,,1,1)
   set cent on
   sele kln
   go rckklr
   prir:=pri
   kklr=kkl
   kkl1r=kkl1
   kklpr:=kklp
   nklpr:=getfield('t1','kklpr','kln','nkl')
   nklr=upper(nkl)
   nklr=alltrim(nklr) 
   nkler=upper(nkle)
   nklsr=lower(nkls)
   adrr=adr
   tlfr=tlf
   kb1r=kb1
   nmfo1r=getfield('t1','kb1r','banks','otb')
   kb2r=kb2
   nmfo2r=getfield('t1','kb2r','banks','otb')
   ns1r=ns1
   ns2r=ns2
   ns1ndsr=ns1nds
   ns2ndsr=ns2nds
   nnr=nn
   rstr=rst
   nsvr=nsv
   koblr=kobl
   noblr=getfield('t1','koblr','kobl','nobl')
   kfsr=kfs
   nfsr=getfield('t1','kfsr','kfs','nfs')
   opfhr=opfh
   nopfhr=getfield('t1','opfhr','opfh','nopfh')
   nsopfhr=getfield('t1','opfhr','opfh','nsopfh')
   knaspr=knasp
   nnaspr=getfield('t1','knaspr','knasp','nnasp')
   kgosr=kgos
   ngosr=getfield('t1','kgosr','kgos','ngos')
   kulcr=kulc
   nulcr=getfield('t1','kulcr','kulc','nulc')
   krnr=krn
   nrnr=getfield('t1','krnr','krn','nrn')
   do case
      case lastkey()=19 && Left
           fldnomr=fldnomr-1
           if fldnomr=0
              fldnomr=1
           endif
      case lastkey()=4 && Right
           fldnomr=fldnomr+1
      case lastkey()=22.and.gnArm#4 .and. (dkklnr=1.or.gnadm=1) && INS
           klnins()
      case lastkey()=7.and.gnAdm=1  && DEL
           netdel()
           skip -1
           if bof()
              go top 
           endif 
           rckklr=recn()   
      case lastkey()=-2 && F3
           clkln=setcolor('gr+/b,n/w')
           wkln=wopen(7,20,17,60)
           wbox(1)
           store 0 to kklr,kkl1r,krnr,knaspr,plgpr
           store space(20) to ktxr,ktx1r
           store space(15) to rschr
           @ 0,1 say 'Код 7зн  ' get kklr pict '9999999'
           @ 1,1 say 'ОКПО     ' get kkl1r pict '9999999999'
           @ 2,1 say 'Расч.счет' get rschr
           @ 3,1 say 'Конт наим' get ktxr
           @ 4,1 say 'Конт адр ' get ktx1r
           @ 5,1 say 'Код район' get krnr pict '9999' valid vkrn(wkln)
           @ 6,1 say 'Код город' get knaspr pict '9999' valid vknasp(wkln)
           @ 7,1 say 'Плат/ГрП ' get plgpr pict '9'
           @ 8,1 say 'Все 0; Плат 1; ГрП 2' 
           read
           if kklr#0.or.kkl1r#0.or.!empty(rschr)
              forr=for_r
              do case
                 case kklr#0
                      sele kln  
                      set orde to tag t1
                      if !netseek('t1','kklr')
                         go top
                      endif
                      rckklr=recn()
                case kkl1r#0
                      sele kln
                      set orde to tag t5
                      if !netseek('t5','kkl1r')
                         go top
                      endif
                      rckklr=recn()
                 case !empty(rschr)
                      rschr=alltrim(rschr)
                      sele kln
                      set orde to tag t1
                      go top
                      rckklr=recn()
                      forr=for_r+'.and.at(rschr,kln->kb1)#0'
              endc         
           else 
              forr=for_r   
              if !empty(ktxr)
                 ktxr=alltrim(upper(ktxr))
                 forr=forr+'.and.at(ktxr,upper(kln->nkl))#0'
              endif   
              if !empty(ktx1r)
                 ktx1r=alltrim(upper(ktx1r))
                 forr=forr+'.and.at(ktx1r,upper(kln->adr))#0'
              endif   
              if !empty(krnr)
                 forr=forr+'.and.krn=krnr'
              endif   
              if !empty(knaspr)
                 forr=forr+'.and.knasp=knaspr'
              endif   
              do case  
                 case plgpr=0
                      forr=forr
                 case plgpr=1
                      forr=forr+'.and.kkl1#0'
                 case plgpr=2
                      forr=forr+'.and.kkl1=0'
              endc   
              sele kln
              set orde to tag t1
              go top
              rckklr=recn()
           endif
           if kklr=0.and.empty(ktxr).and.kkl1r=0.and.empty(ktx1r);
              .and.krnr=0.and.knaspr=0.and.plgpr=0
              forr=for_r
              go top
              rckklr=recn()
           endif   
           wclose(wkln)
           setcolor(clkln)
      case lastkey()=-3  &&.and. (dkklnr=1.or.gnadm=1) && F4
           klnins(1)
      case lastkey()=27 
           exit
      case lastkey()=-6 && Двойники
           save scre to sckldv
           clea  
           sele kln
           set filt to  
           set orde to tag t1  
           go top
           kklr=9999999999
           do while !eof()
              if kkl=kklr
                 ?str(kkl,7) 
                 netdel()
                 skip  
                 loop   
              endif
              kklr=kkl   
              sele kln
              skip
           endd       
           rest scre from sckldv         
           go top
           kklr=kkl
   endc
enddo
nuse()

func klnins(p1)
if empty(p1)
   corr=0 
else
   corr=1 
endif
save scre to scklnins
clklnins=setcolor('gr+/b,n/w')
clea
@ 0,0,MAXROW(),MAXCOL() box frame

sele kln
if corr=1
   prir:=pri
   kklr=kkl
   kkl1r=kkl1
   kklpr:=kklp
   nklpr:=getfield('t1','kklpr','kln','nkl')
   nklr=upper(nkl)
   nklr=alltrim(nklr) 
   nkler=upper(nkle)
   nklsr=lower(nkls)
   adrr=adr
   tlfr=tlf
   kb1r=kb1
   nmfo1r=getfield('t1','kb1r','banks','otb')
   kb2r=kb2
   nmfo2r=getfield('t1','kb2r','banks','otb')
   ns1r=ns1
   ns2r=ns2
   ns1ndsr=ns1nds
   ns2ndsr=ns2nds
   nnr=nn
   rstr=rst
   nsvr=nsv
   koblr=kobl
   noblr=getfield('t1','koblr','kobl','nobl')
   kfsr=kfs
   nfsr=getfield('t1','kfsr','kfs','nfs')
   opfhr=opfh
   nopfhr=getfield('t1','opfhr','opfh','nopfh')
   nsopfhr=getfield('t1','opfhr','opfh','nsopfh')
   knaspr=knasp
   nnaspr=getfield('t1','knaspr','knasp','nnasp')
   kgosr=kgos
   ngosr=getfield('t1','kgosr','kgos','ngos')
   kulcr=kulc
   nulcr=getfield('t1','kulcr','kulc','nulc')
   krnr=krn
   nrnr=getfield('t1','krnr','krn','nrn')
else
   store 0 to kklpr,kklr,kkl1r,nnr,rstr,kobr,kfsr,opfhr,knaspr,kgosr,kulcr,krnr,;
              koblr,skidr,vmrshr,prir,kgpcatr
   store space(30) to nmfo1r,nmfo2r,nopfhr,klnnpvr
   store space(60) to adrr
   store space(80) to nklr,nklpr
   store space(70) to nkler
   store space(20) to nklsr,nsvr,ns1r,ns2r,ns1ndsr,ns2ndsr,noblr,nfsr,nnaspr,ngosr,;
                      nulcr,nrnr,nvmrshr,nkgpcatr
   store space(10) to nklsr,tlfr,nsopfhr
   kb1r=space(15)
   kb2r=space(15)
endif

do while .t.
   @ 1,1 say 'Код 7 знаков'
   @ 3,26 say nklpr
   if corr=0
      @ 1,14 get kklr pict '9999999' valid kkl() 
   else
      @ 1,14 say ' '+str(kklr,7)
   endif
   @ 1,16+8 say nklr
   if corr=1
      if dkklnr=1.or.gnAdm=1  
         @ 2,1  SAY 'Код плательщика' get kklpr pict '9999999' valid kkl_p() 
      else
         @ 2,1  SAY 'Код плательщика'+' '+str(kklpr,7) 
      endif
   else
      @ 2,1  SAY 'Код плательщика' get kklpr pict '9999999' 
   endif
   if gnArm=3.or.gnAdm=1
      @ 3,1  say 'Код ОКП     '
      @ 3,14 get kkl1r pict '9999999999'  
   else
      @ 3,1  say 'Код ОКП     '+' '+str(kkl1r,10)
   endif

   if dkklnr=1.or.gnAdm=1  
      @ 4,1  say 'Наим' get nkler 
      @ 5,1  say 'Наим.коротк.' get nklsr 
      @ 5, 12+20  say 'Телефон     ' get tlfr  
      @ 6,1  say 'Адрес       ' get adrr  
   else
      @ 4,1  say 'Наим'+' '+nkler 
      @ 5,1  say 'Наим.коротк.'+' '+nklsr 
      @ 5, 12+20  say 'Телефон     '+' '+tlfr  
      @ 6,1  say 'Адрес       '+' '+adrr  
   endif

   if gnArm=3.or.gnAdm=1
      @ 7,1  say 'MФО1        ' get kb1r valid mfo1() 
      @ 8,1  say 'Расч. счет1 ' get ns1r   
      @ 8,col()+1  say 'Счет НДС1' get ns1ndsr   
      @ 9,30 say nmfo2r
      @ 9,1  say 'MФО2        ' get kb2r valid mfo2()   
      @ 10,1  say 'Расч. счет2 ' get ns2r               
      @ 10,col()+1  say 'Счет НДС2' get ns2ndsr         
      @ 11,1  say 'Налоговый N ' get nnr pict '999999999999'   
      @ 12,1 say 'Номер свидет' get nsvr                       
   else
      @ 7,1  say 'MФО1        '+' '+kb1r 
      @ 8,1  say 'Расч. счет1 '+' '+ns1r   
      @ 8,col()+1  say 'Счет НДС1'+' '+ns1ndsr   
      @ 9,30 say nmfo2r
      @ 9,1  say 'MФО2        '+' '+kb2r   
      @ 10,1  say 'Расч. счет2 '+' '+ns2r               
      @ 10,col()+1  say 'Счет НДС2'+' '+ns2ndsr         
      @ 11,1  say 'Налоговый N '+' '+str(nnr,12)   
      @ 12,1 say 'Номер свидет'+' '+nsvr                       
   endif
   if dkklnr=1.or.gnAdm=1  
      @ 14,1 say 'Тип предпр. ' get opfhr  pict '9999' valid opfh()   
   else
      @ 14,1 say 'Тип предпр. '    
   endif
   @ 14,19 say nopfhr PICT REPLICATE("X",20)
   @ 15,19 say ngosr
   if dkklnr=1.or.gnAdm=1  
      @ 15,1 say 'Государство ' get kgosr  pict '9999' valid kgos()   
   endif
   @ 16,19 say noblr
   if dkklnr=1.or.gnAdm=1  
      @ 16,1 say 'Область     ' get koblr  pict '9999' valid kobl()    
   endif
   @ 17,19 say nrnr
   if dkklnr=1.or.gnAdm=1  
      @ 17,1 say 'Район       ' get krnr   pict '9999' valid krn()     
   endif
   @ 18,19 say nnaspr
   if dkklnr=1.or.gnAdm=1  
      @ 18,1 say 'Нас.пункт   ' get knaspr pict '9999' valid knasp()   
   endif
   @ 19,19 say nulcr
   if dkklnr=1.or.gnAdm=1  
      @ 19,1 say 'Улица       ' get kulcr  pict '9999' valid kulc()    
   endif
   if dkklnr=1.or.gnAdm=1  
      read
   else
      inkey(0)  
   endif
   nklr=upper(nklr)
   nklsr=lower(nklsr)
   if lastkey()=27
      exit
   endif
   if dkklnr=1.or.gnAdm=1  
      @ MAXROW()-1,60 prom 'Верно'
      @ MAXROW()-1,col()+1 prom 'Не верно'
      menu to vn
   else
      vn=0
   endif
   if lastkey()=27
      exit
   endif
   nkler=alltrim(nkler)
   if !empty(nsopfhr)
      nklr=alltrim(nsopfhr)+' '+nkler
   else
      nklr=nkler
   endif 
   if vn=1
      sele kln
      if corr=1
         netrepl('pri,nkle,kklp,kkl1,nkl,nkls,adr,tlf,kb1,kb2,ns1,ns2,nn,nsv,rst,kgos,kobl,krn,knasp,kulc,kfs,opfh','prir,nkler,kklpr,kkl1r,nklr,nklsr,adrr,tlfr,kb1r,kb2r,ns1r,ns2r,nnr,nsvr,rstr,kgosr,koblr,krnr,knaspr,kulcr,kfsr,opfhr')
      endif
      if corr=0
         if !netseek('t1','kklr')       
            netadd()
            netrepl('nkle,kklp,kkl,kkl1,nkl,nkls,adr,tlf,kb1,kb2,ns1,ns2,nn,nsv,rst,kgos,kobl,krn,knasp,kulc,kfs,opfh,kto','nkler,kklpr,kklr,kkl1r,nklr,nklsr,adrr,tlfr,kb1r,kb2r,ns1r,ns2r,nnr,nsvr,rstr,kgosr,koblr,krnr,knaspr,kulcr,kfsr,opfhr,gnKto')
         endif 
      endif
      if kkl#kklp    
         netrepl('kkl1','0')  
      endif  
      exit
   endif
   sele kln
endd
setcolor(clklnins)
rest scre from scklnins

stat func mfo1()
save scre to scmfo
foot('INS,DEL,F4','Добавить,Удалить,Коррекция')
sele banks
if empty(kb1r).or.!netseek('t1','kb1r')
   go top
   do while .t.
      kb1r=slcf('banks',,,,,"e:kob h:'Код' c:c(15) e:otb h:'Наименование' c:c(40)",'kob',,1,,,,'МФО')
      if lastkey()=27
         kb1r=space(15)
      endif
      sele banks
      netseek('t1','kb1r')
      nmfor=otb
      do case
         case lastkey()=27.or.lastkey()=13
              exit
         case lastkey()=22 && INS
              mfoins1()
         case lastkey()=7  && DEL
              netdel()
              skip -1
         case lastkey()=-3 && F4
              mfoins1(1)
      endc
   enddo
endif
rest scre from scmfo
sele banks
netseek('t1','kb1r')
nmfo1r=otb
@ 7,30 say nmfo1r
retu .t.

stat func mfo2()
save scre to scmfo
foot('INS,DEL,F4','Добавить,Удалить,Коррекция')
sele banks
if empty(kb2r).or.!netseek('t1','kb2r')
   go top
   do while .t.
      kb2r=slcf('banks',,,,,"e:kob h:'Код' c:c(15) e:otb h:'Наименование' c:c(40)",'kob',,1,,,,'МФО')
      if lastkey()=27
         kb2r=space(15)
      endif
      sele banks
      netseek('t1','kb2r')
      nmfor=otb
      do case
         case lastkey()=27.or.lastkey()=13
              exit
         case lastkey()=22 && INS
              mfoins2()
         case lastkey()=7  && DEL
              netdel()
              skip -1
         case lastkey()=-3 && F4
              mfoins2(1)
      endc
   enddo
endif
rest scre from scmfo
sele banks
netseek('t1','kb2r')
nmfo2r=otb
@ 9,30 say nmfo2r
retu .t.

stat func mfoins1(p1)
local getlist:={}
wmfoins=nwopen(10,10,14,70,1,'gr+/b')
if p1=nil
   kb1r=space(15)
   nmfo1r=space(40)
endif
do while .t.
   if p1=nil
      @ 0,1 say 'МФО' get kb1r valid kb1()
   else
      @ 0,1 say 'МФО'+' '+kb1r
   endif
   @ 1,1 say 'Наименование' get nmfo1r
   read
   if lastkey()=27
      exit
   endif
   @ 2,40 prom 'Верно'
   @ 2,col()+1 prom 'Не верно'
   menu to vn
   if lastkey()=27
      exit
   endif
   if vn=1
      sele banks
      if p1=nil
         netadd()
         netrepl('kob,otb','kb1r,nmfo1r')
      else
         netrepl('otb','nmfo1r')
      endif
   endif
   exit
endd
wclose(wmfoins)
retu .t.

stat func mfoins2(p1)
local getlist:={}
wmfoins=nwopen(10,10,14,70,1,'gr+/b')
if p1=nil
   kb2r=space(15)
   nmfo2r=space(40)
endif
do while .t.
   if p1=nil
      @ 0,1 say 'МФО' get kb2r valid kb2()
   else
      @ 0,1 say 'МФО'+' '+kb2r
   endif
   @ 1,1 say 'Наименование' get nmfo2r
   read
   if lastkey()=27
      exit
   endif
   @ 2,40 prom 'Верно'
   @ 2,col()+1 prom 'Не верно'
   menu to vn
   if lastkey()=27
      exit
   endif
   if vn=1
      sele banks
      if p1=nil
         netadd()
         netrepl('kob,otb','kb2r,nmfo2r')
      else
         netrepl('otb','nmfo2r')
      endif
   endif
   exit
endd
wclose(wmfoins)
retu .t.

stat func kb1()
if netseek('t1','kb1r')
   wselect(0)
   save scre to scmess
   mess('Такой банк уже существует',1)
   rest scre from scmess
   wselect(wmfoins)
   retu .f.
endif
retu .t.

stat func kb2()
if netseek('t1','kb2r')
   wselect(0)
   save scre to scmess
   mess('Такой банк уже существует',1)
   rest scre from scmess
   wselect(wmfoins)
   retu .f.
endif
retu .t.

stat func kfs()
save scre to sckfs
foot('INS,DEL,F4','Добавить,Удалить,Коррекция')
sele kfs
if kfsr=0.or.!netseek('t1','kfsr')
   go top
   do while .t.
      kfsr=slcf('kfs',,,,,"e:kfs h:'Код' c:n(4) e:nfs h:'Наименование' c:c(20)",'kfs',,,,,,'Фин.структ.')
      netseek('t1','kfsr')
      nfsr=nfs
      do case
         case lastkey()=27.or.lastkey()=13
              exit
         case lastkey()=22
              kfsins()
         case lastkey()=7
              netdel()
              skip -1
         case lastkey()=-3
              kfsins(1)
      endc
   endd
endif
rest scre from sckfs
@ 13,19 say nfsr PICT REPLICATE("X",20)
retu .t.

stat func kfsins(p1)
local getlist:={}
wkfsins=nwopen(10,10,14,70,1,'gr+/b')
if p1=nil
   kfsr=0
   nkfsr=space(20)
endif
do while .t.
   if p1=nil
      @ 0,1 say 'Код' get kfsr pict '9999' valid kfsi()
   else
      @ 0,1 say 'Код'+' '+str(kfsr,4)
   endif
   @ 1,1 say 'Наименование' get nfsr
   read
   if lastkey()=27
      exit
   endif
   @ 2,40 prom 'Верно'
   @ 2,col()+1 prom 'Не верно'
   menu to vn
   if lastkey()=27
      exit
   endif
   if vn=1
      sele kfs
      if p1=nil
         netadd()
         netrepl('kfs,nfs','kfsr,nfsr')
      else
         netrepl('nfs','nfsr')
      endif
   endif
   exit
endd
wclose(wkfsins)
retu .t.

stat func kfsi()
if netseek('t1','kfsr')
   wselect(0)
   save scre to scmess
   mess('Такой код уже существует',1)
   rest scre from scmess
   wselect(wkfsins)
   retu .f.
endif
retu .t.

stat func opfh()
save scre to sckfs
foot('INS,DEL,F4','Добавить,Удалить,Коррекция')
sele opfh
if opfhr=0.or.!netseek('t1','opfhr')
   go top
   do while .t.
      opfhr=slcf('opfh',,,,,"e:opfh h:'Код' c:n(4) e:nopfh h:'Наименование' c:c(20) e:nsopfh h:'Абб' c:c(10)",'opfh',,,,,,'Тип предпр.')
      netseek('t1','opfhr')
      nopfhr=nopfh
      nsopfhr=nsopfh
      do case
         case lastkey()=27.or.lastkey()=13
              exit
         case lastkey()=22
              opfhins()
         case lastkey()=7
              netdel()
              skip -1
         case lastkey()=-3
              opfhins(1)
      endc
   endd
else
  nopfhr:=nopfh
  nsopfhr:=nsopfh
endif
rest scre from sckfs
@ 14,19 say nopfhr PICT REPLICATE("X",20)
retu .t.

stat func opfhins(p1)
local getlist:={}
wopfhins=nwopen(10,10,15,70,1,'gr+/b')
if p1=nil
   opfhr=0
   nopfhr=space(20)
   nsopfhr=space(10)
endif
do while .t.
   if p1=nil
      @ 0,1 say 'Код' get opfhr pict '9999' valid opfhi()
   else
      @ 0,1 say 'Код'+' '+str(opfhr,4)
   endif
   @ 1,1 say 'Наименование' get nopfhr
   @ 2,1 say 'Аббревиатура' get nsopfhr
   read
   if lastkey()=27
      exit
   endif
   @ 2,40 prom 'Верно'
   @ 2,col()+1 prom 'Не верно'
   menu to vn
   if lastkey()=27
      exit
   endif
   if vn=1
      sele opfh
      if p1=nil
         netadd()
         netrepl('opfh,nopfh,nsopfh','opfhr,nopfhr,nsopfhr')
      else
         netrepl('nopfh,nsopfh','nopfhr,nsopfhr')
      endif
   endif
   exit
endd
wclose(wopfhins)
retu .t.

stat func opfhi()
if netseek('t1','opfhr')
   wselect(0)
   save scre to scmess
   mess('Такой код уже существует',1)
   rest scre from scmess
   wselect(wopfhins)
   retu .f.
endif
retu .t.

stat func kgos()
save scre to sckfs
foot('INS,DEL,F4','Добавить,Удалить,Коррекция')
sele kgos
if kgosr=0.or.!netseek('t1','kgosr')
   go top
   do while .t.
      kgosr=slcf('kgos',,,,,"e:kgos h:'Код' c:n(4) e:ngos h:'Наименование' c:c(20)",'kgos',,,,,,'Государства')
      netseek('t1','kgosr')
      ngosr=ngos
      do case
         case lastkey()=27.or.lastkey()=13
              exit
         case lastkey()=22
              gosins()
         case lastkey()=7
              netdel()
              skip -1
         case lastkey()=-3
              gosins(1)
      endc
   endd
endif
rest scre from sckfs
ngosr=getfield('t1','kgosr','kgos','ngos')
@ 15,19 say ngosr PICT REPLICATE("X",20)
retu .t.

stat func gosins(p1)
local getlist:={}
wopfhins=nwopen(10,10,14,70,1,'gr+/b')
if p1=nil
   kgosr=0
   ngosr=space(20)
endif
do while .t.
   if p1=nil
      @ 0,1 say 'Код' get kgosr pict '9999' valid gosi()
   else
      @ 0,1 say 'Код'+' '+str(kgosr,4)
   endif
   @ 1,1 say 'Наименование' get ngosr
   read
   if lastkey()=27
      exit
   endif
   @ 2,40 prom 'Верно'
   @ 2,col()+1 prom 'Не верно'
   menu to vn
   if lastkey()=27
      exit
   endif
   if vn=1
      sele kgos
      if p1=nil
         netadd()
         netrepl('kgos,ngos','kgosr,ngosr')
      else
         netrepl('ngos','ngosr')
      endif
   endif
   exit
endd
wclose(wopfhins)
retu .t.

stat func gosi()
if netseek('t1','kgosr')
   wselect(0)
   save scre to scmess
   mess('Такой код уже существует',1)
   rest scre from scmess
   wselect(wopfhins)
   retu .f.
endif
retu .t.


stat func kobl()
if kgosr=0
   save scre to scmess
   mess('Нет кода государства',2)
   rest scre from scmess
   retu .t.
endif
save scre to sckfs
foot('INS,DEL,F4','Добавить,Удалить,Коррекция')
sele kobl
if koblr=0.or.!netseek('t1','koblr')
   go top
   do while .t.
      koblr=slcf('kobl',,,,,"e:kobl h:'Код' c:n(4) e:nobl h:'Наименование' c:c(20)",'kobl',,,,'kgos=kgosr',,'Области')
      netseek('t1','koblr')
      noblr=nobl
      do case
         case lastkey()=27.or.lastkey()=13
              exit
         case lastkey()=22
              oblins()
         case lastkey()=7
              netdel()
              skip -1
         case lastkey()=-3
              oblins(1)
      endc
   enddo
endif
noblr=getfield('t1','koblr','kobl','nobl')
rest scre from sckfs
@ 16,19 say noblr PICT REPLICATE("X",20)
retu .t.

stat func oblins(p1)
local getlist:={}
wopfhins=nwopen(10,10,14,70,1,'gr+/b')
if p1=nil
   koblr=0
   noblr=space(20)
endif
do while .t.
   if p1=nil
      @ 0,1 say 'Код' get koblr pict '9999' valid obli()
   else
      @ 0,1 say 'Код'+' '+str(koblr,4)
   endif
   @ 1,1 say 'Наименование' get noblr
   read
   if lastkey()=27
      exit
   endif
   @ 2,40 prom 'Верно'
   @ 2,col()+1 prom 'Не верно'
   menu to vn
   if lastkey()=27
      exit
   endif
   if vn=1
      sele kobl
      if p1=nil
         netadd()
         netrepl('kobl,nobl,kgos','koblr,noblr,kgos')
      else
         netrepl('nobl','noblr')
      endif
   endif
   exit
endd
wclose(wopfhins)
retu .t.

stat func obli()
if netseek('t1','koblr')
   wselect(0)
   save scre to scmess
   mess('Такой код уже существует',1)
   rest scre from scmess
   wselect(wopfhins)
   retu .f.
endif
retu .t.

stat func krn()
if koblr=0
   save scre to scmess
   mess('Нет кода области',2)
   rest scre from scmess
   retu .t.
endif
save scre to sckfs
foot('INS,DEL,F4','Добавить,Удалить,Коррекция')
sele krn
if krnr=0.or.!netseek('t1','krnr')
   go top
   do while .t.
      krnr=slcf('krn',,,,,"e:krn h:'Код' c:n(4) e:nrn h:'Наименование' c:c(20)",'krn',,,,'kobl=koblr',,'Районы')
      netseek('t1','krnr')
      nrnr=nrn
      do case
         case lastkey()=27.or.lastkey()=13
              exit
         case lastkey()=22
              rnins()
         case lastkey()=7
              netdel()
              skip -1
         case lastkey()=-3
              rnins(1)
      endc
   enddo
endif
rest scre from sckfs
nrnr=getfield('t1','krnr','krn','nrn')
@ 17,19 say nrnr PICT REPLICATE("X",20)
retu .t.

stat func rnins(p1)
local getlist:={}
wopfhins=nwopen(10,10,14,70,1,'gr+/b')
if p1=nil
   rnr=0
   nrnr=space(20)
endif
do while .t.
   if p1=nil
      @ 0,1 say 'Код' get krnr pict '9999' valid rni()
   else
      @ 0,1 say 'Код'+' '+str(krnr,4)
   endif
   @ 1,1 say 'Наименование' get nrnr
   read
   if lastkey()=27
      exit
   endif
   @ 2,40 prom 'Верно'
   @ 2,col()+1 prom 'Не верно'
   menu to vn
   if lastkey()=27
      exit
   endif
   if vn=1
      sele krn
      if p1=nil
         netadd()
         netrepl('krn,nrn,kobl','krnr,nrnr,koblr')
      else
         netrepl('nrn','nrnr')
      endif
   endif
   exit
endd
wclose(wopfhins)
retu .t.

stat func rni()
if netseek('t1','krnr')&&   netseek('t1','koblr')
   wselect(0)
   save scre to scmess
   mess('Такой код уже существует',1)
   rest scre from scmess
   wselect(wopfhins)
   retu .f.
endif
retu .t.

stat func knasp()
if krnr=0
   save scre to scmess
   mess('Нет кода района',2)
   rest scre from scmess
   retu .t.
endif
save scre to sckfs
foot('INS,DEL,F4','Добавить,Удалить,Коррекция')
sele knasp
if knaspr=0.or.!netseek('t1','knaspr')
   go top
   do while .t.
      knaspr=slcf('knasp',,,,,"e:knasp h:'Код' c:n(4) e:nnasp h:'Наименование' c:c(20) e:rasst h:'Расст.' c:n(4) e:problc h:'O' c:n(1) e:prrnc h:'P' c:n(1)",'knasp',,,,'krn=krnr',,'Нас.пункты')
      netseek('t1','knaspr')
      nnaspr=nnasp
      rasstr=rasst
      problcr=problc
      prrncr=prrnc
      do case
         case lastkey()=27.or.lastkey()=13
              exit
         case lastkey()=22
              naspins()
         case lastkey()=7.and.(gnAdm=1.or.gnKto=160.or.gnKto=848) 
              netdel()  
              skip -1
              if bof()
                 go top 
              endif
         case lastkey()=-3
              naspins(1)
      endc
   enddo
endif
rest scre from sckfs
nnaspr=getfield('t1','knaspr','knasp','nnasp')
@ 18,19 say nnaspr
retu .t.

stat func naspins(p1)
local getlist:={}
wopfhins=nwopen(10,10,17,70,1,'gr+/b')
if p1=nil
   knaspr=0
   nnaspr=space(20)
   rasstr=0
endif
do while .t.
   if p1=nil
      @ 0,1 say 'Код' get knaspr pict '9999' valid naspi()
   else
      @ 0,1 say 'Код'+' '+str(knaspr,4)
   endif
   @ 1,1 say 'Наименование' get nnaspr
   @ 2,1 say 'Расстояние  ' get rasstr pict '9999'
   @ 3,1 say 'Обл. центр  ' get problcr pict '9'
   @ 4,1 say 'Райцентр    ' get prrncr pict '9'

   read
   if lastkey()=27
      exit
   endif
   @ 5,40 prom 'Верно'
   @ 5,col()+1 prom 'Не верно'
   menu to vn
   if lastkey()=27
      exit
   endif
   if vn=1
      sele knasp
      if p1=nil
         netadd()
         netrepl('knasp,nnasp,krn,rasst,problc,prrnc','knaspr,nnaspr,krnr,rasstr,problcr,prrncr')
      else
         netrepl('nnasp,rasst,problc,prrnc','nnaspr,rasstr,problcr,prrncr')
      endif
   endif
   exit
endd
wclose(wopfhins)
retu .t.

stat func naspi()
if netseek('t1','knaspr')
   wselect(0)
   save scre to scmess
   mess('Такой код уже существует',1)
   rest scre from scmess
   wselect(wopfhins)
   retu .f.
endif
retu .t.

stat func kulc()
if knaspr=0
   save scre to scmess
   mess('Нет кода нас.пункта',2)
   rest scre from scmess
   retu .t.
endif
save scre to sckfs
foot('INS,DEL,F4','Добавить,Удалить,Коррекция')
sele kulc
if kulcr=0.or.!netseek('t1','kulcr')
   go top
   do while .t.
      kulcr=slcf('kulc',,,,,"e:kulc h:'Код' c:n(4) e:nulc h:'Наименование' c:c(20)",'kulc',,,,'knasp=knaspr',,'Улицы')
      netseek('t1','kulcr')
      nulcr=nulc
      do case
         case lastkey()=27.or.lastkey()=13
              exit
         case lastkey()=22
              ulcins()
         case lastkey()=7
              netdel() 
              skip -1
         case lastkey()=-3
              ulcins(1)
      endc
   enddo
endif
rest scre from sckfs
nulcr=getfield('t1','kulcr','kulc','nulc')
@ 19,19 say nulcr
retu .t.

stat func ulcins(p1)
local getlist:={}
wopfhins=nwopen(10,10,14,70,1,'gr+/b')
if p1=nil
   kulcr=0
   nulcr=space(20)
endif
do while .t.
   if p1=nil
      @ 0,1 say 'Код' get kulcr pict '9999' valid ulci()
   else
      @ 0,1 say 'Код'+' '+str(kulcr,4)
   endif
   @ 1,1 say 'Наименование' get nulcr
   read
   if lastkey()=27
      exit
   endif
   @ 2,40 prom 'Верно'
   @ 2,col()+1 prom 'Не верно'
   menu to vn
   if lastkey()=27
      exit
   endif
   if vn=1
      sele kulc
      if p1=nil
         netadd()
         netrepl('kulc,nulc,knasp','kulcr,nulcr,knaspr')
      else
         netrepl('nulc','nulcr')
      endif
   endif
   exit
endd
wclose(wopfhins)
retu .t.

stat func ulci()
if netseek('t1','kulcr')
   wselect(0)
   save scre to scmess
   mess('Такой код уже существует',1)
   rest scre from scmess
   wselect(wopfhins)
   retu .f.
endif
retu .t.

stat func kkl()
sele kln
if corr=0
   if netseek('t1','kklr')
      save scre to scmess
      mess('Такой код уже существует',1)
      rest scre from scmess
      retu .f.
   endif
endif
retu .t.

func kkl_p
LOCAL nRec
nRec:=kln->(RECNO())
sele kln
if kklpr=0
   kklpr=slct_kl(10,1,12)
endif
if netseek('t1','kklpr')
   nklpr=nkl
else
   kklpr=0
   kln->(DBGOTO(nRec))
endif
@ 3,26 say nklpr
kln->(DBGOTO(nRec))
retu .t.

func vkrn(p1)
*local getlist:={}
*save screen to scvkrn
wselect(0)
sele krn
go top
rckrnr=recn()
rckrnr=slcf('krn',,,,,"e:krn h:'Код' c:n(4) e:nrn h:'Наименование' c:c(20)",,,,,,,'Районы')
if lastkey()=13
   go rckrnr
   krnr=krn
endif
*rest screen from sckrn
wselect(p1)
retu .t.

func vknasp(p1)
wselect(0)
*local getlist:={}
sele knasp
set orde to tag t2
if krnr#0
   whlr='krn=krnr'
   if !netseek('t2','krnr')
      krnr=0
      go top  
      whlr='.t.'
   endif
else
   whlr='.t.'
   go top
endif
rcknaspr=recn()
rcknaspr=slcf('knasp',,,,,"e:knasp h:'Код' c:n(4) e:nnasp h:'Наименование' c:c(20)",,,,whlr,,,'Нас.пункты')
if lastkey()=13
   go rcknaspr
   knaspr=knasp
endif
wselect(p1)
retu .t.
