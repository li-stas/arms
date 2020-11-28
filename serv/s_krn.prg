* Районы
netuse('krn')
netuse('krntm')
netuse('mkeep')
netuse('knasp')
netuse('nasptm')
netuse('rntm')
netuse('kgpcat')
clea
sele krn
rckrnr=recn()
do while .t.
   sele krn
   go rckrnr
   foot('ENTER,F5,F6','Нас пункты,ТМ,Категории') 
   rckrnr=slcf('krn',1,1,18,,"e:krn h:'ID' c:n(4) e:nrn h:'Наименование' c:c(20)",,,1,,,,'Районы')
   if lastkey()=27
      exit
   endif
   go rckrnr
   krnr=krn
   nrnr=alltrim(nrn)
   do case
      case lastkey()=-4.and.gnEntrm=0.and.(gnAdm=1.or.iif(gnEnt=20,gnKto=160.or.gnKto=186.or.gnKto=848,.t.)) && corr
           krntm()
      case lastkey()=13.and.gnEntrm=0.and.(gnAdm=1.or.iif(gnEnt=20,gnKto=160.or.gnKto=186.or.gnKto=848,.t.)) && corr
           nasp()  
      case lastkey()=-5.and.gnEntrm=0.and.(gnAdm=1.or.iif(gnEnt=20,gnKto=160.or.gnKto=186.or.gnKto=848,.t.)) && corr
           rncat()
   endc
endd
nuse()

func krntm()
save scre to sckrntm
sele krntm
if !netseek('t1','krnr')
   go top
endif
rckrntmr=recn()
do while .t.
  sele krntm
  go rckrntmr
  foot('INS,DEL,F4','Доб,Уд,Корр') 
   if fieldpos('nac')#0
      rckrntmr=slcf('krntm',8,20,,,"e:mkeep h:'ID' c:n(4) e:getfield('t1','krntm->mkeep','mkeep','nmkeep') h:'Наименование' c:c(20) e:tcen h:'ТЦ' c:n(2) e:nac h:'Нац' c:n(6,2) e:nac1 h:'Нац1' c:n(6,2)",,,1,,'krn=krnr',,nrnr)
   else
      rckrntmr=slcf('krntm',8,20,,,"e:mkeep h:'ID' c:n(4) e:getfield('t1','krntm->mkeep','mkeep','nmkeep') h:'Наименование' c:c(20) e:tcen h:'ТЦ' c:n(2)",,,1,,'krn=krnr',,nrnr)
   endif   
   if lastkey()=27
      exit
   endif
   sele krntm
   go rckrntmr
   mkeepr=mkeep
   tcenr=tcen
   if fieldpos('nac')#0
      nacr=nac
      nac1r=nac1
   else
      nacr=0
      nac1r=0
   endif
   do case
      case lastkey()=22.and.gnEntrm=0.and.(gnAdm=1.or.iif(gnEnt=20,gnKto=160.or.gnKto=186.or.gnKto=848,.t.)) && ins
           krntmi()
           sele krntm  
           netseek('t1','krnr')
           rckrntmr=recn()
      case lastkey()=-3.and.gnEntrm=0.and.(gnAdm=1.or.iif(gnEnt=20,gnKto=160.or.gnKto=186.or.gnKto=848,.t.)) && corr
           krntmi(1)
      case lastkey()=7.and.gnEntrm=0.and.(gnAdm=1.or.iif(gnEnt=20,gnKto=160.or.gnKto=186.or.gnKto=848,.t.)) && del
           netdel()
           skip -1
           if bof()
              go top
           endif
           rckrntmr=recn()
   endc
endd
rest scre from sckrntm
retu .t.

func krntmi(p1)
if empty(p1)
   sele mkeep
   go top
   do while !eof()
      mkeepr=mkeep
*      if val(subs(nmkeep,1,2))>0.and.val(subs(nmkeep,1,2))<15
      if gnEnt=20.and.lv20=1.or.gnEnt=21.and.lv21=1
         sele krntm
         if !netseek('t1','krnr,mkeepr')
            netadd()
            netrepl('krn,mkeep','krnr,mkeepr')
         endif
      endif
      sele mkeep
      skip
   endd
else
   sctmr=setcolor('gr+/b,n/w')
   wtmr=wopen(10,20,14,60)
   wbox(1)
   @ 0,1 say 'Тип цены' get tcenr pict '99'
   @ 1,1 say 'Наценка ' get nacr pict '999.99'
   @ 2,1 say 'Наценка1' get nac1r pict '999.99'
   read
   if lastkey()=13
      netrepl('tcen','tcenr')
      if fieldpos('nac')#0
         netrepl('nac,nac1','nacr,nac1r')
      endif   
   endif
   wclose(wtmr)
   setcolor(sctmr)
endif   
retu .t.

func nasp()
save scre to scnasp
sele knasp
if !netseek('t1','krnr')
   go top
endif
rcnaspr=recn()
do while .t.
   sele knasp
   go rcnaspr
   foot('F5,F6','ТМ,Категории') 
   rcnaspr=slcf('knasp',1,40,18,,"e:knasp h:'ID' c:n(4) e:nnasp h:'Наименование' c:c(20)",,,1,,'krn=krnr',,nrnr)
   if lastkey()=27
      exit
   endif
   sele knasp
   go rcnaspr
   knaspr=knasp
   nnaspr=alltrim(nnasp)
   do case
      case lastkey()=-4.and.gnEntrm=0.and.(gnAdm=1.or.iif(gnEnt=20,gnKto=160.or.gnKto=186.or.gnKto=848,.t.)) && corr
           nasptm()
      case lastkey()=-5.and.gnEntrm=0.and.(gnAdm=1.or.iif(gnEnt=20,gnKto=160.or.gnKto=186.or.gnKto=848,.t.)) && corr
           sele nasptm  
           if fieldpos('kgpcat')#0
              naspcat()
           endif   
   endc
endd
rest scre from scnasp
retu .t.

func nasptm()
save scre to scnasptm
sele nasptm
set orde to tag t1
if !netseek('t1','knaspr')
   go top
endif
rcnasptmr=recn()
do while .t.
   sele nasptm
   go rcnasptmr
   foot('INS,DEL,F4','Доб,Уд,Корр') 
   if fieldpos('kgpcat')#0
      rcnasptmr=slcf('nasptm',8,20,,,"e:mkeep h:'ID' c:n(4) e:getfield('t1','nasptm->mkeep','mkeep','nmkeep') h:'Наименование' c:c(20) e:tcen h:'ТЦ' c:n(2)e:nac h:'Нац' c:n(6,2) e:nac1 h:'Нац1' c:n(6,2)",,,1,,'knasp=knaspr.and.kgpcat=0',,nnaspr)
   else
      rcnasptmr=slcf('nasptm',8,20,,,"e:mkeep h:'ID' c:n(4) e:getfield('t1','nasptm->mkeep','mkeep','nmkeep') h:'Наименование' c:c(20) e:tcen h:'ТЦ' c:n(2)e:nac h:'Нац' c:n(6,2) e:nac1 h:'Нац1' c:n(6,2)",,,1,,'knasp=knaspr',,nnaspr)
   endif
   if lastkey()=27
      exit
   endif
   sele nasptm
   go rcnasptmr
   mkeepr=mkeep
   tcenr=tcen
   if fieldpos('nac')#0
      nacr=nac
      nac1r=nac1
   else
      nacr=0
      nac1r=0
   endif
   do case
      case lastkey()=22.and.gnEntrm=0.and.(gnAdm=1.or.iif(gnEnt=20,gnKto=160.or.gnKto=186.or.gnKto=848,.t.)) && ins
           nasptmi()
           sele nasptm  
           netseek('t1','knaspr')
           rcnasptmr=recn()
      case lastkey()=-3.and.gnEntrm=0.and.(gnAdm=1.or.iif(gnEnt=20,gnKto=160.or.gnKto=186.or.gnKto=848,.t.)) && corr
           nasptmi(1)
      case lastkey()=7.and.gnEntrm=0.and.(gnAdm=1.or.iif(gnEnt=20,gnKto=160.or.gnKto=186.or.gnKto=848,.t.)) && del
           netdel()
           skip -1
           if bof()
              go top
           endif
           rcnasptmr=recn()
   endc
endd
rest scre from scnasptm
sele nasptm
go top
do while !eof()
   if tcen=0.and.nac=0.and.nac1=0 
      netdel()
   endif   
   skip
endd
retu .t.

func nasptmi(p1)
if empty(p1)
   sele mkeep
   go top
   do while !eof()
      mkeepr=mkeep
*      if val(subs(nmkeep,1,2))>0.and.val(subs(nmkeep,1,2))<15
      if gnEnt=20.and.lv20=1.or.gnEnt=21.and.lv21=1
         sele nasptm
         if !netseek('t2','knaspr,0,mkeepr')
            netadd()
            netrepl('knasp,mkeep','knaspr,mkeepr')
         endif
      endif
      sele mkeep
      skip
   endd
else
   sctmr=setcolor('gr+/b,n/w')
   wtmr=wopen(10,20,14,60)
   wbox(1)
   @ 0,1 say 'Тип цены' get tcenr pict '99'
   @ 1,1 say 'Наценка ' get nacr pict '999.99'
   @ 2,1 say 'Наценка1' get nac1r pict '999.99'
   read
   if lastkey()=13
      netrepl('tcen','tcenr')
      if fieldpos('nac')#0
         netrepl('nac,nac1','nacr,nac1r')
      endif   
   endif
   wclose(wtmr)
   setcolor(sctmr)
endif   
retu .t.
**************
func naspcat()
**************
save scree to naspcatr
sele nasptm
set orde to tag t2
if netseek('t2','knaspr')
   go top 
endif
rcncr=recn()
do while .t.
   foot('INS,DEL,F4','Доб,Уд,Корр')
   sele nasptm
   go rcncr
   rcncr=slcf('nasptm',8,,,,"e:kgpcat h:'К' c:n(2) e:getfield('t1','nasptm->kgpcat','kgpcat','nkgpcat') h:'Категория' c:c(20) e:mkeep h:'ID' c:n(4) e:getfield('t1','nasptm->mkeep','mkeep','nmkeep') h:'Наименование' c:c(20) e:tcen h:'ТЦ' c:n(2) e:nac h:'Нац' c:n(6,2) e:nac1 h:'Нац1' c:n(6,2)",,,1,'knasp=knaspr','kgpcat#0',,nnaspr)
   if lastkey()=27
      exit
   endif
   go rcncr
   kgpcatr=kgpcat
   mkeepr=mkeep
   tcenr=tcen
   nacr=nac
   nac1r=nac1
   do case
      case lastkey()=22.and.gnEntrm=0.and.(gnAdm=1.or.iif(gnEnt=20,gnKto=160.or.gnKto=186.or.gnKto=848,.t.)) && ins
           naspci()
           sele nasptm  
           netseek('t1','knaspr')
           rcncr=recn()
      case lastkey()=-3.and.gnEntrm=0.and.(gnAdm=1.or.iif(gnEnt=20,gnKto=160.or.gnKto=186.or.gnKto=848,.t.)) && corr
           naspci(1)
      case lastkey()=7.and.gnEntrm=0.and.(gnAdm=1.or.iif(gnEnt=20,gnKto=160.or.gnKto=186.or.gnKto=848,.t.)) && del
           netdel()
           skip -1
           if bof().or.knasp#knaspr
              netseek('t2','knaspr')
           endif
           rcncr=recn()
   endc
endd
rest scree from naspcatr
sele nasptm
go top
do while !eof()
   if tcen=0.and.nac=0.and.nac1=0 
      netdel()
   endif   
   skip
endd
retu .t.

****************
func naspci(p1) 
****************
if empty(p1)
   sele kgpcat
   go top
   do while !eof()
      if kgpcat=0
         skip
         loop  
      endif  
      kgpcatr=kgpcat
      sele mkeep
      go top
      do while !eof()
         mkeepr=mkeep
*         if val(subs(nmkeep,1,2))>0.and.val(subs(nmkeep,1,2))<15
         if gnEnt=20.and.lv20=1.or.gnEnt=21.and.lv21=1
            sele nasptm
            if !netseek('t2','knaspr,kgpcatr,mkeepr')
               netadd()
               netrepl('knasp,kgpcat,mkeep','knaspr,kgpcatr,mkeepr')
            endif
         endif
         sele mkeep
         skip
      endd
      sele kgpcat
      skip
   endd 
else
   sctmr=setcolor('gr+/b,n/w')
   wtmr=wopen(10,20,14,60)
   wbox(1)
   @ 0,1 say 'Тип цены' get tcenr pict '99'
   @ 1,1 say 'Наценка ' get nacr pict '999.99'
   @ 2,1 say 'Наценка1' get nac1r pict '999.99'
   read
   if lastkey()=13
      netrepl('tcen','tcenr')
      netrepl('nac,nac1','nacr,nac1r')
   endif
   wclose(wtmr)
   setcolor(sctmr)
endif
retu .t.

**************
func rncat()
**************
save scree to naspcatr
sele rntm
set orde to tag t2
if netseek('t2','krnr')
   go top 
endif
rcncr=recn()
do while .t.
   foot('INS,DEL,F4','Доб,Уд,Корр')
   sele rntm
   go rcncr
   rcncr=slcf('rntm',8,,,,"e:kgpcat h:'К' c:n(2) e:getfield('t1','rntm->kgpcat','kgpcat','nkgpcat') h:'Категория' c:c(20) e:mkeep h:'ID' c:n(4) e:getfield('t1','rntm->mkeep','mkeep','nmkeep') h:'Наименование' c:c(20) e:tcen h:'ТЦ' c:n(2) e:nac h:'Нац' c:n(6,2) e:nac1 h:'Нац1' c:n(6,2)",,,1,'krn=krnr','kgpcat#0',,nrnr)
   if lastkey()=27
      exit
   endif
   go rcncr
   kgpcatr=kgpcat
   mkeepr=mkeep
   tcenr=tcen
   nacr=nac
   nac1r=nac1
   do case
      case lastkey()=22.and.gnEntrm=0.and.(gnAdm=1.or.iif(gnEnt=20,gnKto=160.or.gnKto=186.or.gnKto=848,.t.)) && ins
           rnci()
           sele rntm  
           netseek('t1','krnr')
           rcncr=recn()
      case lastkey()=-3.and.gnEntrm=0.and.(gnAdm=1.or.iif(gnEnt=20,gnKto=160.or.gnKto=186.or.gnKto=848,.t.)) && corr
           rnci(1)
      case lastkey()=7.and.gnEntrm=0.and.(gnAdm=1.or.iif(gnEnt=20,gnKto=160.or.gnKto=186.or.gnKto=848,.t.)) && del
           netdel()
           skip -1
           if bof().or.krn#krnr
              netseek('t2','krnr')
           endif
           rcncr=recn()
   endc
endd
rest scree from naspcatr
sele rntm
go top
do while !eof()
   if tcen=0.and.nac=0.and.nac1=0 
      netdel()
   endif   
   skip
endd
retu .t.

****************
func rnci(p1) 
****************
if empty(p1)
   sele kgpcat
   go top
   do while !eof()
      if kgpcat=0
         skip
         loop  
      endif  
      kgpcatr=kgpcat
      sele mkeep
      go top
      do while !eof()
         mkeepr=mkeep
*         if val(subs(nmkeep,1,2))>0.and.val(subs(nmkeep,1,2))<15
         if gnEnt=20.and.lv20=1.or.gnEnt=21.and.lv21=1
            sele rntm
            if !netseek('t2','krnr,kgpcatr,mkeepr')
               netadd()
               netrepl('krn,kgpcat,mkeep','krnr,kgpcatr,mkeepr')
            endif
         endif
         sele mkeep
         skip
      endd
      sele kgpcat
      skip
   endd 
else
   sctmr=setcolor('gr+/b,n/w')
   wtmr=wopen(10,20,14,60)
   wbox(1)
   @ 0,1 say 'Тип цены' get tcenr pict '99'
   @ 1,1 say 'Наценка ' get nacr pict '999.99'
   @ 2,1 say 'Наценка1' get nac1r pict '999.99'
   read
   if lastkey()=13
      netrepl('tcen','tcenr')
      netrepl('nac,nac1','nacr,nac1r')
   endif
   wclose(wtmr)
   setcolor(sctmr)
endif
retu .t.

*************
func kpltt()
*************
sele etm
set orde to tag t2
if netseek('t2','kplr')
   rcetmr=recn()
   fldnomr=1
   do while .t.
      sele etm
      go rcetmr
      rcetmr=slce('etm',5,1,,,"e:kgp h:'Код' c:n(7) e:getfield('t1','etm->kgp','kgp','ngrpol') h:'Наименование' c:c(30) e:getfield('t1','etm->kgp','kln','adr') h:'Адрес' c:c(40) ",,,1,'kpl=kplr',"netseek('t2','etm->tmesto','stagtm')",,alltrim(nkplr))
      if lastkey()=27
         exit
      endif
      do case
         case lastkey()=19 && Left
              fldnomr=fldnomr-1
              if fldnomr=0
                 fldnomr=1
              endif
         case lastkey()=4 && Right
              fldnomr=fldnomr+1
     endc         
   endd
endif 
retu .t.
