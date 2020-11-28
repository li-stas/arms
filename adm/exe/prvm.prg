save scre to scprvm
clea
sele dbft
copy to ldbft for dir=3
sele 0
use ldbft
netuse('cskl')
if select('sl')=0
   sele 0
   use _slct alia sl excl
endif
sele sl
zap

do while .t.
   // outlog(__FILE__,__LINE__,'gdTd',gdTd,addmonth(gdTd,-1))
   dtr=addmonth(gdTd,-1)
   yr='g'+str(year(dtr),4)+'\'
   mr=month(dtr)
   if mr<10
      mr='m0'+str(mr,1)+'\'
   else
      mr='m'+str(mr,2)+'\'
   endif
   pathtr=gcPath_d
   pathsr=strtran(pathtr,gcDir_g,yr)
   pathsr=strtran(pathsr,gcDir_d,mr)

   forr="ent=gnEnt.and.file(pathsr+alltrim(path)+'tprds01.dbf')"

   skr=slcf('cskl',,,,,"e:sk h:'SK' c:n(3) e:nskl h:'Наименование' c:c(30)",'sk',1,,,forr)

   gnOst0=getfield('t1','skr','cskl','ost0')
   gnArnd=getfield('t1','skr','cskl','arnd')
   gnMerch=getfield('t1','skr','cskl','merch')
   gnCtov=getfield('t1','skr','cskl','ctov')
   pathr=getfield('t1','skr','cskl','path')

   Pathr=gcPath_d+alltrim(path)
   pathctr=gcPath_d
   pathtr=pathr
   dtr=addmonth(gdTd,-1)
   yr='g'+str(year(dtr),4)+'\'
   mr=month(dtr)
   if mr<10
      mr='m0'+str(mr,1)+'\'
   else
      mr='m'+str(mr,2)+'\'
   endif
   pathsr=strtran(pathtr,gcDir_g,yr)
   pathsr=strtran(pathsr,gcDir_d,mr)
   pathctr=strtran(pathctr,gcDir_g,yr)
   pathctr=strtran(pathctr,gcDir_d,mr)
   pathr=pathtr
   if file(pathsr+'tovd.dbf').and.!gnCtov=1
      gnCtov=2
   endif
*   if gnCtov=1
*      if !file(gcPath_d+'ctov.dbf')
*          copy file (pathctr+'ctov.dbf') to (gcPath_d+'ctov.dbf')
*      endif
*   endif

   do case
      case lastkey()=27
           exit
      case lastkey()=13
           prv()
   endc

   sele cskl
   if !netseek('t1','skr')
      go top
   endif

enddo

nuse()
sele ldbft
use
erase ldbft.dbf
rest scre from scprvm

stat func prv()
sele sl
go top
do while !eof()
   skr=val(kod)
   sele cskl
   if netseek('t1','skr')
      pathmr=subs(gcPath_d,1,len(gcPath_d)-1)
      Pathr=gcPath_d+alltrim(path)
      gnOst0=getfield('t1','skr','cskl','ost0')
      gnCtov=getfield('t1','skr','cskl','ctov')
      gnMerch=getfield('t1','skr','cskl','merch')
      Pathctr=pathctr+alltrim(path)
      if file(pathctr+'tovd.dbf').and.!gnCtov=1
         gnCtov=2
      endif
      ?Pathr
      pathdr=subs(pathr,1,len(pathr)-1)
      prvr=2
      if dirchange(pathmr)#0 //=-3
         dirmake(pathmr)
      endif
      dirchange(gcPath_l)
//      if dirchange(pathdr)=-3 .or. dirchange(pathdr)=-5
      if dirchange(pathdr)#0
         dirmake(pathdr)
      endif
      dirchange(gcPath_l)
      if file(pathr+'tprds01.dbf')
         aoptr:={'Отмена','Продолжить'}
         prvr=alert('В '+pathr+' есть данные',aoptr)
         if lastkey()=27
            prvr=1
         endif
      endif
      if prvr#2
         sele sl
         skip
         loop
      endif
   endif
   pathtr=pathr
   dtr=addmonth(gdTd,-1)
   yr='g'+str(year(dtr),4)+'\'
   mr=month(dtr)
   if mr<10
      mr='m0'+str(mr,1)+'\'
   else
      mr='m'+str(mr,2)+'\'
   endif
   pathsr=strtran(pathtr,gcDir_g,yr)
   pathsr=strtran(pathsr,gcDir_d,mr)
   pathr=pathtr
   sele ldbft
   go top
   save scre to scobn
   do while !eof()
      als_rr=als
      als_r=alltrim(als)
      fnamer=alltrim(fname)
      if !file(pathsr+fnamer+'.dbf')
         skip
         loop
      endif
      mess('Копирование '+als_rr)
      copy file (pathsr+fnamer+'.dbf') to (pathtr+fnamer+'.dbf')
*      if file(pathsr+fnamer+'.cdx')
*         copy file (pathsr+fnamer+'.cdx') to (pathtr+fnamer+'.cdx')
*      endif
      mess('Индексация  '+als_rr)
*      netuse(als_r,,'e',1)
      netind(als_r,pathtr)
*      nuse(als_r)
      sele ldbft
      skip
   endd

   rest scre from scobn
   dobnv()
   ??' Ok'
   sele sl
   skip
endd
clea
retu

