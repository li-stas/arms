clea
netuse('cskle')
netuse('cskl')
netuse('lic')
netuse('grp')
netuse('nei')
netuse('cgrp')

**********
*if keir#keipr
*   nat_r=alltrim(ntovr)+iif(vespr#0,' '+kzero(vespr,10,3),'')+iif(!empty(neipr),alltrim(neipr),'')+iif(!empty(nkachr),' '+alltrim(nkachr),'')+iif(!empty(tovdopr),' '+alltrim(tovdopr),'')+iif(!empty(nupakr),' '+alltrim(nupakr),'')+' '+alltrim(nizg_r)
*else
*   nat_r=alltrim(ntovr)+iif(!empty(nkachr),' '+alltrim(nkachr),'')+iif(!empty(tovdopr),' '+alltrim(tovdopr),'')+iif(!empty(nupakr),' '+alltrim(nupakr),'')+' '+alltrim(nizg_r)  &&+iif(upakr#0,' 1/'+kzero(upakr,10,3),'')
*endif
**********

*if fieldpos('nmark')#0
*   do while !eof()
*      if mark=0
*         nmarkr=''
*      else
*         nmarkr="iif(vespr#0,' '+kzero(vespr,10,3),'')+iif(!empty(neipr),alltrim(neipr),'')+alltrim(ntovr)+iif(!empty(nkachr),' '+alltrim(nkachr),'')+iif(!empty(tovdopr),' '+alltrim(tovdopr),'')+iif(!empty(nupakr),' '+alltrim(nupakr),'')+' '+alltrim(nizg_r)"
*      endif
*      netrepl('nmark','nmarkr')
*   endd
*endif

go top   
rccgrpr=recn()
do while .t.
   sele cgrp
   go rccgrpr
   foot('INS,DEL,F4,ESC','Добавить,Удалить,Коррекция,Выход')
   rccgrpr=slcf('cgrp',1,,18,,"e:kgr h:'Код' c:n(3) e:ngr h:'Наименование' c:c(20) e:ot h:'От' c:n(2) e:mark h:'М' c:n(1) e:tgrp h:'БСО' c:n(1) e:prpcen h:'%' c:n(1) e:kov h:'КОВ' c:n(10,3) e:kovs h:'КОВC' c:n(10,3) e:tgrp h:'А' c:n(1) e:mntov h:'MNTOV' c:n(7) e:ktl h:'KTL' c:n(9)",,,1,,,,'ГРУППЫ ТОВАРА')
   if lastkey()=27
      exit
   endif   
   sele cgrp
   go rccgrpr
   kgrr=kgr
   ngrr=ngr
   otr=ot
   markr=mark
   if fieldpos('nmark')#0
      nmarkr=nmark
   else
      nmarkr=space(60)
   endif
   licr=lic
   grpr=grp
   nlicr=getfield('t1','licr','lic','nlic')
   ngrpr=getfield('t1','grpr','grp','ng')
   if markr=0
      nnmarkr='Обычный'
   else
      nnmarkr='Автомат'
   endif
   nalr=nal
   tgrpr=tgrp
   prpcenr=prpcen
   kovr=kov
   kovsr=kovs
   mntovr=mntov
   ktlr=ktl
   do case
      case lastkey()=22  && Добавить
           cgins()
      case lastkey()=7   && Удалить
           netdel()
           skip -1
           if bof()
              go top
           endif
           rccgrpr=recn()
      case lastkey()=-3 .and. (dkklnr=1.or.gnadm=1) && Коррекция
           cgins(1)
  endc
endd
nuse()

stat func kgr()
if cor_r=nil
   sele cgrp
   rc_r=recn()
   if netseek('t1','kgrr')
      wmess('Такой код существует',1)
      go rc_r
      retu .f.
   endif
endif
retu .t.

stat func ot()
if !netseek('t1','Skr,otr','cskle').or.otr=0
   go top
   wselect(0)
   otr=slcf('cskle',,,,,"e:ot h:'Код' c:n(2) e:nai h:'Наименование' c:c(20)",'ot')
   wselect(wsgrpins)
endif
notr=getfield('t1','Skr,otr','cskle','nai')
@ 2,17 say notr
retu .t.

stat func wnal()
svkeyr=savesetkey()
set key -3 to nal()
wselect(0)
foot('F4','Коррекция')
wselect(wsgrpins)
retu .t.

stat func vnal()
wselect(0)
foot('','')
wselect(wsgrpins)
set key -3 to
restsetkey(svkeyr)
retu .t.

stat func nal()
netuse('dclr')
wselect(0)
save scre to scnal
if select('sl')=0
   sele 0
   use _slct alias sl excl
endif
sele sl
zap
for i=1 to 20 step 2
    kszr=val(subs(nalr,i,2))
    if kszr#0
       sele dclr
       if netseek('t1','kszr')
          sele sl
          netadd()
          repl kod with str(kszr,12)
       endif
    endif
next
sele dclr
go top
foot('SPACE','Отбор')
do while .t.
   kzr=slcf('dclr',,,,,"e:kz h:'Код' c:n(2) e:nz h:'Наименование' c:c(20)",'kz',1,,,'nal=1')
   sele dclr
   netseek('t1','kzr')
   do case
      case lastkey()=27
           exit
      case lastkey()=13
           sele sl
           go top
           nalr=space(20)
           i=1
           do while !eof()
              ksz_r=val(kod)
              nalr=stuff(nalr,i,2,str(ksz_r,2))
              i=i+2
              skip
           endd
           exit
   endc
endd
rest scre from scnal
wselect(wsgrpins)
nuse('nal')
retu .t.

stat func mark()
if markr=0
   nnmarkr='Обычный'
else
   nnmarkr='Автомат'
endif
@ 3,17 say nnmarkr
retu .t.

stat func lic1
sele lic
if !netseek('t1','licr').or.licr=0
   go top
   wselect(0)
   licr=slcf('lic',,,,,"e:lic h:'Код' c:n(1) e:nlic h:'Наименование' c:c(20)",'lic',,,,,,'ЛИЦЕНЗИИ')
   wselect(wsgrpins)
   if lastkey()#27
      nlicr=getfield('t1','licr','lic','nlic')
      @ 5,17 say nlicr
   endif
endif
retu .t.

stat func grp()
sele grp
if grpr=0.or.!netseek('t1','grpr')
   wselect(0)
   grpr=slcf('grp',,,,,"e:kg h:'Код' c:n(3) e:ng h:'Наименование' c:c(20)",'kg')
   wselect(wsgrpins)
   ngrpr=getfield('t1','grpr','grp','ng')
   @ 6,18 say ngrpr
endif
retu .t.

stat func grkei()
sele nei
if !netseek('t1','grkeir').or.grkeir=0
   go top
   wselect(0)
   grkeir=slcf('nei',,,,,"e:nei h:'Изм' c:c(5)",'kei')
   wselect(wsgrpins)
endif
grneir=getfield('t1','grkeir','nei','nei')
@ 7,20 say grneir
retu .t.

stat func cgins(p1)
cor_r=p1
if cor_r=nil
   store 0 to kgrr,otr,markr,svkeyr,licr,grpr,tgrpr,prpcenr,kovr,mntovr,ktlr
   store space(20) to ngrr,notr,nlicr
   store space(10) to nalr
   store space(60) to nmarkr
endif
foot('','')
clcgrpins=setcolor('gr+/b,n/w')
wcgrpins=wopen(2,1,20,79)
wbox(1)

do while .t.
   if cor_r=nil
      @ 0,1 say 'Код группы  ' get kgrr pict '999' valid kgr()
   else
      @ 0,1 say 'Код группы  '+' '+str(kgrr,3)
   endif
   @ 1,1 say 'Наименование' get ngrr
   ngrr=upper(ngrr)
   @  2,1 say 'Коэф.об.веса' get kovr  pict '999999.999' 
   @  3,1 say 'КОВ склада  ' get kovsr  pict '999999.999' 
   @  4,1 say 'Тек.MNTOV   ' get mntovr pict '9999999'
   @  5,1 say 'Тек.KTL     ' get ktlr pict '999999999'
   @  6,1 say 'Автонаимен. ' get markr pict '9' 
   @  7,1 say 'АвтоФормула ' get nmarkr  
   @  8,1 say 'БСО(Акциз)  ' get tgrpr pict '9'
   @  9,1 say 'Авторасценка' get prpcenr pict '9'
   read
   if lastkey()=27
      exit
   endif
   @ 16,60 prom 'Верно'
   @ 16,col()+1 prom 'Не верно'
   menu to vn
   if lastkey()=27
      exit
   endif
   if vn=1
      sele cgrp
      if cor_r=nil
         netadd()
         netrepl('kgr,ngr,tgrp,kov,mntov,ktl,mark,kovs,prpcen','kgrr,ngrr,tgrpr,kovr,mntovr,ktlr,markr,kovsr,prpcenr')
         if fieldpos('nmarkr')#0
            netrepl('nmark','nmarkr')
         endif
         rccgrpr=recn()
      else
         netrepl('ngr,tgrp,kov,mntov,ktl,mark,kovs,prpcen','ngrr,tgrpr,kovr,mntovr,ktlr,markr,kovsr,prpcenr')
         if fieldpos('nmarkr')#0
            netrepl('nmark','nmarkr')
         endif
      endif
      exit
   endif
endd
wclose(wcgrpins)
setcolor(clcgrpins)
retu .t.
