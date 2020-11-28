* Бонусы
clea
netuse('kln')
netuse('kpl')
netuse('mkeep')
netuse('kplbon')
netuse('kplboe')
netuse('cskl')
netuse('ctov')
sele kplbon
go top
rckbr=recn()
fldnomr=1
wlb_r='.t.'
forb_r='.t.'
wlbr=wlb_r
forbr=forb_r
do while .t.
   sele kplbon
   go rckbr
   foot('F3,F4,F6,F7','Фильтр,Корр,Обн реал,Обн ост')
   rckbr=slce('kplbon',1,0,18,,"e:kpl h:'Kpl' c:n(7) e:mkeep h:'Mkeep' c:n(3) e:getfield('t1','kplbon->mkeep','mkeep','nmkeep') h:'Наименование' c:c(20) e:small h:'SmAll' c:n(10,2) e:smost h:'SmOst' c:n(10,2) e:smst h:'SmSt' c:n(10,2) e:prrlz h:'PrRlz' c:n(6,2) e:smrlzp h:'SmRlzP' c:n(12,2) e:smrlz h:'SmRlz' c:n(12,2) e:ostn h:'OstN' c:n(12,2) e:smbon h:'SmBon' c:n(12,2)",,,1,wlbr,forbr,,,1,2)
   if lastkey()=27
      exit
   endif
   sele kplbon
   go rckbr
   kplr=kpl
   mkeepr=mkeep
   smstr=smst
   prrlzr=prrlz
   ostnr=ostn
   smrlzr=smrlz
   smrlzpr=smrlzp
   smallr=small
   smostr=smost
   do case
      case lastkey()=19 && Left
           fldnomr=fldnomr-1
           if fldnomr=0
              fldnomr=1
           endif
      case lastkey()=4 && Right
           fldnomr=fldnomr+1
      case lastkey()=-2 && Фильтр
           kbflt()
      case lastkey()=22 && Добавить
           kbins()
      case lastkey()=-3 && Коррекция
           kbins(1)
      case lastkey()=7.and.gnEntrm=0
           netdel()
           skip -1
           if bof()
              go top
           endif
           rckbr=recn()
      case lastkey()=-5 && Обн реализ
           kbrlz()
      case lastkey()=-6 && Обн остаток
           kbost() 
      case lastkey()=13 && TTN
           sele kplboe
           if netseek('t1','kplr,mkeepr') 
              rcboer=recn()
              wlboer='kpl=kplr.and.mkeep=mkeepr'
              do while .t.
                 sele kplboe
                 go rcboer
                 foot('','') 
                 rcboer=slcf('kplboe',,,,,"e:sk h:'SK' c:n(3) e:ttn h:'TTN' c:n(6) e:sm h:'Sm' c:n(10,2)",,,,wlboer)
                 sele kplboe
                 go rcboer 
                 if lastkey()=27
                    exit
                 endif                 
              endd 
           endif
  endc
endd
nuse()

*************
func kbflt()
*************
retu .t.

**************
func kbins(p1)
**************
if empty(p1)
   kplr=0
   mkeepr=0
   smstr=0
   prrlzr=0
   ostnr=0
   smrlzr=0
   smrlzpr=0
   smallr=0
   smostr=0
endif
clkb=setcolor('gr+/b,n/w')
wkb=wopen(8,20,14,60)
wbox(1)
do while .t.
   if empty(p1)
      @ 0,1 say 'Клиент        '  get kplr pict '9999999' valid kplb()
      @ 1,1 say 'Торговая марка' get mkeepr pict '999' valid mkb()
   else
      @ 0,1 say 'Клиент         '+' '+str(kplr,7)
      @ 1,1 say 'Торговая марка '+' '+str(mkeepr,3)
   endif   
   @ 2,1 say 'Сумма ставки' get smstr pict '999999999.99'
   @ 3,1 say '% от реализ.' get prrlzr pict '999.99'
   read
   if lastkey()=27
      exit
   endif
   if lastkey()=13
      if empty(p1)
         sele kplbon
         if !netseek('t1','kplr,mkeepr')
            netadd()
            netrepl('kpl,mkeep','kplr,mkeepr')
            rckbr=recn()
         else
            wmess('Уже есть',2)
            loop
         endif   
      endif 
      netrepl('smst,prrlz','smstr,prrlzr')
      exit
   endif
endd
wclose(wkb)
setcolor(clkb)
retu .t.
*************
func kplb()
*************
if kplr=0
   retu .f.
endif
if !netseek('t1','kplr','kpl')
   wmess('Нет в спр плательщиков',2)
   retu .f.
endif
retu .t.
*************
func mkb()
*************
if !netseek('t1','mkeepr','mkeep')
   wmess('Нет в спр направлений',2)
   retu .f.
endif
retu .t.
*************
func kbrlz()
*************
sele kplbon
copy to tkplbon
sele 0
use tkplbon excl
repl all smrlz with 0
inde on str(kpl,7)+str(mkeep,3) tag t1
*use
*sele 0
*use tkplbon shared
set orde to tag t1
dtr=addmonth(gdTd,-1)
pathmr=gcPath_e+'g'+str(year(dtr),4)+'\m'+iif(month(dtr)<10,'0'+str(month(dtr),1),str(month(dtr),2))+'\'
if netfile('kplbon',1)
   netuse('kplbon','kplbonp',,1)
endif
sele cskl
go top
do while !eof()
   if ent#gnEnt
      skip
      loop
   endif 
   if rasc#1
      skip
      loop
   endif 
   pathr=pathmr+alltrim(path)
   if !netfile('rs1',1)
      sele cskl
      skip
      loop
   endif
   mess(pathr)
   netuse('rs1',,,1)
   netuse('rs2',,,1)
   sele rs1
   go top
   do while !eof()
      if prz=0
         skip
         loop
      endif 
      if vo#9
         skip
         loop
      endif 
      kplr=nkkl
      if kplr=0
         kplr=kpl 
      endif
      ttnr=ttn
      sele rs2
      if netseek('t1','ttnr')
         do while ttn=ttnr
            if int(mntov/10000)<2
               skip
               loop 
            endif
            kvpr=kvp
            zenr=zen
            mntovr=mntov
            sele ctov
            if netseek('t1','mntovr')
               mkeepr=mkeep
               sele tkplbon
               if !netseek('t1','kplr,mkeepr')
                  sele rs2
                  skip
                  loop 
               endif
               sele ctov
               if c08#0
                  zenbr=cenpr-c08
                  zenr=zenr-zenbr
               endif   
            else   
               sele rs2
               skip
               loop 
            endif
            smrlzr=roun(kvpr*zenr,2) 
            if smrlzr#0
               sele tkplbon
               repl smrlz with smrlz+smrlzr
            endif
            sele rs2
            skip
         endd
      endif
      sele rs1
      skip
   endd
   nuse('rs1')
   nuse('rs2')
   sele cskl
   skip
endd
sele tkplbon
go top
do while !eof()
   kplr=kpl
   mkeepr=mkeep
   smrlzr=smrlz
   ostnr=0
   if select('kplbonp')#0
      ostnr=getfield('t1','kplr,mkeepr','kplbonp','smost') 
   endif
   sele kplbon
   if netseek('t1','kplr,mkeepr') 
      netrepl('smrlz,ostn','smrlzr,ostnr')
      netrepl('smrlzp','smrlz*prrlz/100')
      netrepl('small','ostn+smst+smrlzp')
   endif
   sele tkplbon
   skip
endd
use
*erase tklpbon.dbf
*erase tklpbon.cdx
if select('kplbonp')#0
   sele kplbonp
   use
endif
clea
retu .t.

*************
func kbost()
*************
sele kplbon
copy to tkplbon
sele 0
use tkplbon excl
repl all smbon with 0
inde on str(kpl,7)+str(mkeep,3) tag t1
set orde to tag t1

sele kplboe
copy to tkplboe
sele 0
use tkplboe excl
repl all sm with 0
inde on str(kpl,7)+str(mkeep,3)+str(sk,3)+str(ttn,6) tag t1
set orde to tag t1

sele cskl
go top
do while !eof()
   if ent#gnEnt
      skip
      loop
   endif 
   if rasc#1
      skip
      loop
   endif 
   pathr=gcPath_d+alltrim(path)
   if !netfile('rs1',1)
      sele cskl
      skip
      loop
   endif
   skr=sk
   mess(pathr)
   netuse('rs1',,,1)
   netuse('rs2',,,1)
   sele rs1
   go top
   do while !eof()
      if !(kop=174.or.kopi=174)
         skip
         loop
      endif 
      if empty(dfp)
         skip
         loop
      endif 
      kplr=nkkl
      if kplr=0
         kplr=kpl 
      endif
      ttnr=ttn
      sele rs2
      if netseek('t1','ttnr')
         do while ttn=ttnr
            if int(mntov/10000)<2
               skip
               loop 
            endif
            mntovr=mntov
            mkeepr=getfield('t1','mntovr','ctov','mkeep')
            sele tkplbon
            if !netseek('t1','kplr,mkeepr')
               sele rs2
               skip
               loop
            endif
            sele rs2
            kvpr=kvp
            zenr=zenp
            smbonr=roun(kvpr*zenr,2) 
            if smbonr#0
               sele tkplbon
               repl smbon with smbon+smbonr
               sele tkplboe
               if !netseek('t1','kplr,mkeep,skr,ttn')               
                  appe blank
                  repl kpl with kplr,;
                       mkeep with mkeepr,;
                       sk with skr,;
                       ttn with ttnr
               endif
               repl sm with sm+smbonr
            endif
            sele rs2
            skip
         endd
      endif
      sele rs1
      skip
   endd
   nuse('rs1')
   nuse('rs2')
   sele cskl
   skip
endd
sele tkplbon
go top
do while !eof()
   kplr=kpl
   mkeepr=mkeep
   smbonr=smbon
   sele kplbon
   if netseek('t1','kplr,mkeepr') 
      netrepl('smbon','smbonr')
      netrepl('smost','small-smbon')
   endif
   sele tkplbon
   skip
endd
use
*erase tklpbon.dbf
*erase tklpbon.cdx

sele tkplboe
go top
do while !eof()
   kplr=kpl
   mkeepr=mkeep
   sk=skr
   ttn=ttnr
   smr=sm
   sele kplboe
   if !netseek('t1','kplr,mkeepr,skr,ttnr') 
      netadd()
   endif
   netrepl('sm','smr')
   sele tkplboe
   skip
endd
sele kplboe
go top
do while !eof()
   kplr=kpl
   mkeepr=mkeep
   skr=sk
   ttnr=ttn
   if !netseek('t1','kplr,mkeepr,skr,ttnr','tkplboe')
      sele kplboe
      netdel()
   endif
   sele kplboe
   skip
endd
sele tkplboe
use
*erase tklpboe.dbf
*erase tklpboe.cdx
clea
retu .t.

****************
func sv()
* Супервайзеры
****************
clea
netuse('sv')
locate for ksv=0
if !foun()
   netadd()
   netrepl('ksv','0')   
endif
sele sv
set orde to tag t2
go top
rcsvr=recn()
forr='.t..and.ksv#0'
do while .t.
   sele sv
   set orde to tag t2
   go rcsvr 
   foot('Ins,Del,F4','Добавить,Удалить,Корр')
   rcsvr=slcf('sv',1,1,18,,"e:ksv h:'Код' c:n(4) e:nsv h:'ФИО' c:c(20)",,,1,,forr,,'Супервайзеры')
   if lastkey()=27
      exit
   endif
   sele sv
   go rcsvr
   ksvr=ksv
   nsvr=nsv
   do case
      case lastkey()=22.and.gnEntrm=0 && Добавить
           ksvins()
      case lastkey()=-3.and.gnEntrm=0 && Коррекция
           ksvins(1)
      case lastkey()=7.and.gnEntrm=0
           netdel()
           skip -1
           if bof()
              go top
           endif
           rcsvr=recn()
   endc
endd
nuse()
retu .t.

***************
func ksvins(p1)
***************
if empty(p1)
   sele sv
   set orde to tag t1
   go bott
   ksvr=ksv+1
   nsvr=space(20)   
endif
clkb=setcolor('gr+/b,n/w')
wkb=wopen(8,30,11,60)
wbox(1)
do while .t.
   if empty(p1)
      @ 0,1 say 'Код ' get ksvr pict '9999' 
      @ 1,1 say 'ФИО ' get nsvr 
   else
      @ 0,1 say 'Код '+' '+str(ksvr,4)
      @ 1,1 say 'ФИО ' get nsvr
   endif   
   read
   if lastkey()=27
      exit
   endif
   if lastkey()=13
      if empty(p1)
         sele sv
         if !netseek('t1','ksvr')
            netadd()
            netrepl('ksv','ksvr')
            rcsvr=recn()
         else
            wmess('Уже есть',2)
            loop
         endif   
      endif 
      netrepl('nsv','nsvr')
      exit
   endif
endd   
wclose(wkb)   
setcolor(clkb)
retu .t.

