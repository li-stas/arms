* Коррекция kodst1,vesst1,kza,ves в CTOV
clea
if select('sl')=0
   sele 0
   use _slct alias sl
endif
forr='.t.'
store 0 to prksr,prvsr,prkzar,prvr,prkrstatr,prkustatr
netuse('cgrp')
netuse('ctov')
set orde to tag t2
fldnomr=1
do while .t.
   sele ctov
   foot('F3,F4,F8','Фильтр,Коррекция,Группа')
   rcctovr=slce('ctov',1,1,18,,"e:mntov h:'Код' c:n(7) e:nat h:'Наименование' c:c(36) e:nei h:'Изм' c:c(4) e:kodst1 h:'КодС' c:n(4) e:vesst1 h:'ВесС' c:n(8,3) e:kza h:'КЗА' c:n(4,2) e:ves h:'Вес' c:n(8,3) e:krstat h:'КодР' c:n(4) e:kustat h:'ВесР' c:n(15,6)",,,1,,forr,,'Общий справочник предприятия')
   go rcctovr
   mntovr=mntov
   natr=nat
   kodst1r=kodst1
   vesst1r=vesst1
   kzar=kza
   vesr=ves
   krstatr=krstat
   kustatr=kustat
   do case
      case lastkey()=27
           exit
      case lastkey()=19 && Left
           fldnomr=fldnomr-1
           if fldnomr=0
              fldnomr=1
           endif
      case lastkey()=4 && Right
           fldnomr=fldnomr+1
      case lastkey()=-2
           ctovflts()
      case lastkey()=-3
           ctovins()
      case lastkey()=-7
           sele cgrp
           set order to tag t2
           go top
           rcn_gr=recn()
           do while .t.
              sele cgrp
              set order to tag t2
              rcn_gr=recno()
              kg_r=slcf('cgrp',,,,,"e:kgr h:'Код' c:n(3) e:ot h:'От' c:n(2) e:ngr h:'Наименование' c:c(20)",'kgr',,,,)
              do case
                 case lastkey()=13
                      sele ctov
                      if !netseek('t2','kg_r')
                         go rcctovr
                      endif
                      exit
                 case lastkey()=27
                      exit
                 case lastkey()>32.and.lastkey()<255
                      sele cgrp
                      lstkr=upper(chr(lastkey()))
                      if !netseek('t2','lstkr')
                         go rcn_gr
                      endif
                      loop
                 othe
                      loop
              endc
           enddo
      case lastkey()>32.and.lastkey()<255
           sele ctov
           lstkr=upper(chr(lastkey()))
           if !netseek('t2','int(mntovr/10000),lstkr')
              go rcctovr
           endif
   endc
endd
nuse()

func ctovflts()
clctovi=setcolor('gr+/b,n/w')
wctovi=wopen(10,20,18,60)
wbox(1)
sele ctov
do while .t.
   @ 0,1 say '0 Код стат ' get prksr pict '9'
   @ 1,1 say '0 Вес стат ' get prvsr pict '9'
   @ 2,1 say '0 Коэф.загр' get prkzar pict '9'
   @ 3,1 say '0 Вес      ' get prvr pict '9'
   @ 4,1 say '0 Код Р    ' get prkrstatr pict '9'
   @ 5,1 say '0 Вес Р    ' get prkustatr pict '9'
   read
   if lastkey()=27
      exit
   endif
   @ 6,1 prom 'Верно'
   @ 6,col()+1 prom 'Не Верно'
   menu to vn
   if lastkey()=27
      exit
   endif
   if vn=1
      forr='.t.'+iif(prksr=1,'.and.kodst1=0','')+;
           iif(prvsr=1,'.and.vesst1=0','')+;
           iif(prkzar=1,'.and.kza=0','')+;
           iif(prkrstatr=1,'.and.krstat=0','')+;
           iif(prkustatr=1,'.and.kustat=0','')+;
           iif(prvr=1,'.and.ves=0','')
      exit
   endif   
enddo
wclose(wctovi)
setcolor(clctovi)
retu .t.

func ctovins()
clctovf=setcolor('gr+/b,n/w')
wctovf=wopen(10,20,18,60)
wbox(1)
sele ctov
do while .t.
   @ 0,1 say 'Код      ' get kodst1r pict '9999'
   @ 1,1 say 'Вес стат.' get vesst1r pict '999999.999'
   @ 2,1 say 'Коэф.загр' get kzar pict '9.99'
   @ 3,1 say 'Вес      ' get vesr pict '999999.999'
   @ 4,1 say 'Код Р    ' get krstatr pict '9999'
   @ 5,1 say 'Вес Р    ' get kustatr pict '99999999.999999'
   read
   if lastkey()=27
      exit
   endif
   @ 6,1 prom 'Верно'
   @ 6,col()+1 prom 'Не Верно'
   menu to vn
   if lastkey()=27
      exit
   endif
   if vn=1
      netrepl('kodst1,vesst1,kza,ves,krstat,kustat',;
              'kodst1r,vesst1r,kzar,vesr,krstatr,kustatr')  
      exit
   endif   
enddo
wclose(wctovf)
setcolor(clctovf)
retu .t.