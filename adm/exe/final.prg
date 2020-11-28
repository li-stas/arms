clea
netuse('cskl')
if select('sl')=0
   sele 0
   use _slct alias sl excl
endif
store 0 to skr,entr,sklr
store space(30) to nsklr,path_r
sele sl
zap
sele cskl
go top
rccskr=recn()
do while !eof()
   if ent#gnEnt
      skip
      loop
   endif
   skr=sk
   pathr=gcPath_d+alltrim(path)
   if file(pathr+'final.dbf')
      sele sl
      appe blank
      repl kod with str(skr,12)
   endif
   sele cskl
   skip
endd

do while .t.
   sele cskl
   go rccskr
   skr=slcf('cskl',1,,18,,"e:sk h:'SK' c:n(3) e:ent h:'П' c:n(1) e:path h:'Путь' c:c(10) e:nskl h:'Наименование' c:c(20) e:kkl h:'Магазин' c:n(7)",'sk',1,,,"ent=gnEnt.and.file(gcPath_d+alltrim(path)+'tprds01.dbf')")
   sele cskl
   locate for sk=skr
   rccskr=recn()
   if lastkey()=13.or.lastkey()=27 && 
      exit
   endif
enddo

if lastkey()=13
   fnl()
endif
nuse()

stat func fnl()
sele sl
go top
do while !eof()
   sele sl
   skr=val(kod)
   sele cskl
   locate for sk=skr
   pathr=gcPath_d+alltrim(path)
   if !file(pathr+'final.dbf')
      crtt(pathr+'final','f:fdt c:d(8)')
      sele 0
      use (pathr+'final.dbf')
      appe blank
      repl fdt with date()
      use
   endif 
   sele sl
   skip
endd 
