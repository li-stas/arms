#include "common.ch"
#include "inkey.ch"
* Печать прайсов
if gnCtov#1
   retu
endif
clea
rswr=1
lstr=1
erase sprice.dbf
crtt('sprice','f:field_name c:c(10) f:field_type c:c(1) f:field_len c:n(3) f:field_dec c:n(3)')
sele 0
use sprice
appe blank
repl field_name with 'kg',;
     field_type with 'n',;
     field_len with 3,;
     field_dec with 0
appe blank
repl field_name with 'nat',;
     field_type with 'c',;
     field_len with 40,;
     field_dec with 0
netuse('tovm')
set orde to tag t2
go top
netuse('soper')
netuse('tcen')
pshhr='┌'+'───'+'┬'+repl('─',40)
pshdr='│'+'Гр '+'│'+space(14)+'Наименование'+space(14)
pshfr='┴'+'───'+'┴'+repl('─',40)
sele tcen
do while !eof()
   if ent#gnEnt
      skip
      loop
   endif
   tcenr=tcen
*   sele soper
*   locate for tcen=tcenr
*   if !foun()
*      sele tcen
*      skip
*      loop
*   endif
*   sele tcen
   ntcenr=ntcen
   zenr=alltrim(zen)
   sele sprice
   appe blank
   repl field_name with zenr,;
        field_type with 'n',;
        field_len with 15,;
        field_dec with 3
   appe blank
   repl field_name with 'c_'+zenr,;
        field_type with 'c',;
        field_len with 20,;
        field_dec with 0
   pshhr=pshhr+'┬'+repl('─',10)
   pshdr=pshdr+'│'+subs(ntcenr,1,10)
   pshfr=pshfr+'┴'+repl('─',10)
   sele tcen
   skip
endd
pshhr=pshhr+'┐'
pshdr=pshdr+'│'
pshfr=pshfr+'┘'
sele sprice
use
sele 0
create ('price'+alltrim(str(gnSk,3))) from sprice
use ('price'+alltrim(str(gnSk,3))) alias price
sele 0
use
sele tovm
do while !eof()
   kgr=kg
   natr=nat
   sele price
   appe blank
   repl kg with kgr,;
        nat with natr
   sele tcen
   go top
   do while !eof()
      if ent#gnEnt
         skip
         loop
      endif
      tcenr=tcen
*      sele soper
*      locate for tcen=tcenr
*      if !foun()
*         sele tcen
*         skip
*         loop
*      endif
*      sele tcen
      ntcenr=ntcen
      zenr=alltrim(zen)
      czenr='c_'+zenr
      sele tovm
      cenr=&zenr
      sele price
      repl &zenr with cenr,;
           &czenr with ntcenr
      sele tcen
      skip
   endd
   sele tovm
   skip
endd
do while .t.
   alpt={'lpt1','lpt2','lpt3','Файл'}
   vlpt=alert('ПЕЧАТЬ',alpt)
   if lastkey()=K_ESC
      exit
   endif
   set cons off
   do case
      case vlpt=1
           set prin to lpt1
           set prin on
           if empty(gcPrn)
              ??chr(27)+chr(80)+chr(15)
           else
              ??chr(27)+'E'+chr(27)+'&l1h26a1O'+chr(27)+'&k2S'+chr(27)+'&a20l'+chr(27)+'(3R'+chr(27)+'(s0p17.00h0s1b4102T'+chr(27)
           endif
      case vlpt=2.or.vlpt=3
           set prin to ('lpt'+str(vlpt,1))
           set prin on
           ??chr(27)+'E'+chr(27)+'&l1h26a1O'+chr(27)+'&k2S'+chr(27)+'&a20l'+chr(27)+'(3R'+chr(27)+'(s0p17.00h0s1b4102T'+chr(27)
      case vlpt=4
           set prin to ('price'+alltrim(str(gnSk,3))+'.txt')
           set prin on
           if empty(gcPrn)
              ??chr(27)+chr(80)+chr(15)
           else
              ??chr(27)+'E'+chr(27)+'&l1h26a1O'+chr(27)+'&k2S'+chr(27)+'&a20l'+chr(27)+'(3R'+chr(27)+'(s0p17.00h0s1b4102T'+chr(27)
           endif
   endc
   ?pshhr
   psle()
   ?pshdr
   psle()
   ?pshfr
   psle()
   sele price
   go top
   do while !eof()
      sss=' '+str(kg,3)+' '+nat
      sele tcen
      go top
      do while !eof()
         if ent#gnEnt
            skip
            loop
         endif
         tcenr=tcen
*         sele soper
*         locate for tcen=tcenr
*         if !foun()
*            sele tcen
*            skip
*            loop
*         endif
*         sele tcen
         zenr=alltrim(zen)
         sele price
         cenr=&zenr
         sss=sss+' '+iif(cenr#0,str(cenr,10,3),space(10))
         sele tcen
         skip
      endd
      ?sss
      psle()
      sele price
      skip
   endd
   set prin off
   if gnOut=1
      set prin to lpt1
   else
      set prin to txt.txt
   endif
endd
if select('price')#0
   sele price
   use
endif
if gnEnt=13.or.gnEnt=16
  copy file ('price'+alltrim(str(gnSk,3))+'.dbf') to ('j:\upgrade\price'+alltrim(str(gnSk,3))+'.dbf')
endif
*erase ('price'+alltrim(str(gnSk,3))+'.dbf')
set cons on
nuse()

proc psle(p1)
rswr++
rsw_r=40
if rswr>=rsw_r
   rswr=1
   lstr++
   eject
   if p1=nil
      wmess('Вставте лист и нажмите пробел',0)
      ?pshhr
      psle()
      ?pshdr
      psle()
      ?pshfr
      psle()
   endif
endif
retu

