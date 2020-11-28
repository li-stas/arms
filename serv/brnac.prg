* Наценки по брендам
clea 

netuse('mkeep')
netuse('mkeepe')
netuse('ctov')
netuse('cgrp')
netuse('kln')
netuse('kpl')
netuse('kplkgp')
rccr=recc()
netuse('brand')
netuse('brnac')
netuse('mnnac')

store '' to nkpl_r,nkpl1_r
for_r=".t." && Плательщики
forr=for_r
prnacr=0
sele kln
go top
rckplr=recn()
do while .t.
   sele kln
   go rckplr
   foot('ENTER,F3,F5,F6','Маркодержатели,Фильтр,Обновить всех,Обновить выбр.')
   rckplr=slcf('kpl',1,1,18,,"e:kpl h:'Код' c:n(7) e:getfield('t1','kpl->kpl','kln','nkl') h:'Наименование' c:c(30)",,,1,,,,'Плательщики')
   if lastkey()=27
      exit
   endif
   sele kpl
   go rckplr
   kplr=kpl
   nkplr=getfield('t1','kplr','kln','nkl')
   do case
      case lastkey()=13 && Маркодержатели
           nacm()   
      case lastkey()=-2 && Фильтр
           klnflt() 
      case lastkey()=-4 && Обновить Всех
           obnbr(0) 
      case lastkey()=-5 && Обновить
           obnbr(1) 
   endc
endd

nuse()


func klnflt()
scfltr=setcolor('gr+/b,n/w')
wfltr=wopen(8,10,12,70)
wbox(1)
kpl_r=0
nkpl_r=space(20)
@ 0,1 say 'Код      ' get kpl_r pict '9999999'
@ 1,1 say 'Контекст ' get nkpl_r
read
if !empty(nkpl_r)
   kpl_r=0 
endif
if kpl_r#0
   if !netseek('t1','kpl_r')
      wmess('Не найден',2)  
   else
      rckplr=recn()
   endif
   forr=for_r 
endif
if !empty(nkpl_r)
   nkpl_r=alltrim(nkpl_r)
   nkpl1_r=upper(nkpl_r) 
   forr=for_r+".and.(at(nkpl_r,getfield('t1','kpl->kpl','kln','nkl'))#0.or.at(nkpl1_r,getfield('t1','kpl->kpl','kln','nkl'))#0)"
   sele kpl
   go top
   rckplr=recn() 
endif

wclose(wfltr)
setcolor(scfltr)

retu .t.

func nacm()

sele mkeep
save scre to scmkeepr
set orde to tag t2
formkr="netseek('t1','kplr,mkeep->mkeep','brnac')"
go top
rcmkeepr=recn()
do while .t.
   sele mkeep
   go rcmkeepr
   foot('F5,F6','Бренды,Группы')
   rcmkeepr=slcf('mkeep',1,50,18,,"e:mkeep h:'Код' c:n(3) e:nmkeep h:'Наименование' c:c(20)",,,1,,formkr,,alltrim(nkplr))
   if lastkey()=27
      exit
   endif
   go rcmkeepr
   mkeepr=mkeep
   nmkeepr=nmkeep
   do case
      case lastkey()=-4 && Бренды 
           nacbr()
      case lastkey()=-5 && Группы 
   endc 
endd
rest scree from scmkeepr
retu .t.

func nacbr()
save scree to scnacbr
sele brnac
if netseek('t1','kplr,mkeepr')
   rcbrnacr=recn()
else
   go top
   rcbrnacr=recn()
endif
whlbrr='kkl=kplr.and.mkeep=mkeepr'
forbrr='brand#0'
do while .t.
   foot('ENTER,F4','Товар,Коррекция')
   sele brnac
   go rcbrnacr
   rcbrnacr=slcf('brnac',5,1,,,"e:brand h:'Код' c:n(10) e:getfield('t1','brnac->brand','brand','nbrand') h:'Наименование' c:c(28) e:nac h:'Нац1' c:n(6,2) e:nac1 h:'Нац2' c:n(6,2) e:minzen1 h:'M' c:n(1) e:ftxt h:'Основание' c:c(20)",,,1,whlbrr,forbrr,,alltrim(nmkeepr))
   if lastkey()=27
      exit
   endif
   go rcbrnacr
   brandr=brand
   nbrandr=getfield('t1','brandr','brand','nbrand')
   nacr=nac
   nac1r=nac1
   minzen1r=minzen1
   ftxtr=ftxt
   do case
      case lastkey()=-3 && Коррекция
           brnacins()   
      case lastkey()=13 && Товар
           mnnac()
   endc 
endd
rest scree from scnacbr
retu .t.

func nacgr()
retu .t.

func obnbr(p1)
if p1=0
   save scre to scobnbr
   @ 1,70 say str(rccr,8)
   sele kplkgp
   go top
   kpl_r=0
   rcc_r=0
   do while !eof()
      rcc_r=rcc_r+1
      @ 2,70 say str(rcc_r,8)   
      if kpl=kpl_r
         sele kplkgp
         skip
         loop
      endif 
      kplr=kpl
      obbnc(kplr)
      sele kplkgp
      kpl_r=kpl
      skip
   endd
   rest scre from scobnbr
else
   save scre to scobnbr
   mess('Ждите...')
   obbnc(kplr)
   rest scre from scobnbr
endif   
retu .t.

func obbnc(p1)      
kpl_rr=p1
sele mkeep
go top
do while !eof()
   if mkeep=0
      skip
      loop
   endif
   mkeepr=mkeep
   sele brand
   set orde to tag t2
   if netseek('t2','mkeepr')
      do while mkeep=mkeepr
         if brand=0
            skip
            loop
         endif
         brandr=brand  
         sele brnac
         if !netseek('t1','kpl_rr,mkeepr,brandr')
            netadd()
            netrepl('kkl,mkeep,brand','kpl_rr,mkeepr,brandr')
         endif
         sele brand
         skip
      endd
   endif
   sele mkeep
   skip
endd
retu .t.

func brnacins()
scbrir=setcolor('gr+/b,n/w')
wbrir=wopen(8,10,14,70)
wbox(1)
@ 0,1 say 'Наценка1        ' get nacr  pict '999.99'
@ 1,1 say 'Наценка2        ' get nac1r pict '999.99'
@ 2,1 say 'Пров.на мин цену' get minzen1r pict '9'
@ 3,1 say 'Основание       ' get ftxtr 
read
if lastkey()=13
   sele brnac
   netrepl('nac,nac1,minzen1,ftxt','nacr,nac1r,minzen1r,ftxtr')
endif
wclose(wbrir)
setcolor(scbrir)
retu .t.

func mnnac()
sele ctov
set orde to tag t7
if netseek('t7','brandr')
   do while brand=brandr
      if mkeep#mkeepr
         skip
         loop 
      endif  
      mntovr=mntov
      sele mnnac
      if !netseek('t1','kplr,brandr,mntovr')
         netadd()
         netrepl('kkl,brand,mntov','kplr,brandr,mntovr')
      endif
      sele ctov
      skip
   endd
endif
sele mnnac
netseek('t1','kplr,brandr')
rcmnnacr=recn()
do while .t.
   foot('F4','Коррекция')
   sele mnnac
   go rcmnnacr
   rcmnnacr=slcf('mnnac',8,1,,,"e:mntov h:'Код' c:n(7) e:getfield('t1','mnnac->mntov','ctov','nat') h:'Наименование' c:c(28) e:nac h:'Нац1' c:n(6,2) e:nac1 h:'Нац2' c:n(6,2) e:minzen1 h:'M' c:n(1) e:ftxt h:'Основание' c:c(20)",,,1,'kkl=kplr.and.brand=brandr',,,alltrim(nbrandr))
   if lastkey()=27
      exit
   endif
   go rcmnnacr
   brandr=brand
   mntovr=mntov
   nacr=nac
   nac1r=nac1
   minzen1r=minzen1
   ftxtr=ftxt
   do case
      case lastkey()=-3 && Коррекция
           mnnacins()   
   
   endc
endd
retu .t.


func mnnacins()
scmnir=setcolor('gr+/b,n/w')
wmnir=wopen(8,10,14,70)
wbox(1)
@ 0,1 say 'Наценка1        ' get nacr  pict '999.99'
@ 1,1 say 'Наценка2        ' get nac1r pict '999.99'
@ 2,1 say 'Пров.на мин цену' get minzen1r pict '9'
@ 3,1 say 'Основание       ' get ftxtr 
read
if lastkey()=13
   sele mnnac
   netrepl('nac,nac1,minzen1,ftxt','nacr,nac1r,minzen1r,ftxtr')
endif
wclose(wmnir)
setcolor(scmnir)
retu .t.
