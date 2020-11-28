*Выделение tovd из tov
gnCtov=2 && Обычный разделенный
@ 1,0 clea
netuse('cskl')
if select('sl')=0
   sele 0
   use _slct alias sl excl
else
   sele sl
endif
zap
do while .t.
   @ 1,0 clea    
   sele cskl 
   go top
   sk_r=slcf('cskl',2,1,17,,"e:sk h:'SK' c:n(2) e:nskl h:'Наименование' c:c(20)",'sk',1,1,,'ent=gnEnt.and.file(gcPath_d+alltrim(path)+"tprds01.dbf").and.ctov#1')
   do case
      case lastkey()=27
           exit
      case lastkey()=13 
           sele sl 
           go top
           do while !eof()
              skr=val(kod)
              nsklr=alltrim(getfield('t1','skr','cskl','nskl')) 
              @ 2,40 clea to 2,79
              @ 2,40 say nsklr
              pathr=gcPath_d+alltrim(getfield('t1','skr','cskl','path'))
              tov_d()
              sele sl
              skip 
           endd
   endc
endd
nuse()
