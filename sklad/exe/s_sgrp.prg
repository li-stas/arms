#include "common.ch"
#include "inkey.ch"
clea
netuse('cskle')
netuse('cskl')
netuse('lic')
netuse('grp')
netuse('nei')
netuse('cgrp')
msser=1
@ 24,1 prom 'По складам'
@ 24,col()+1 prom 'По предприятию'
menu to msser
if lastkey()=K_ESC
   retu
endif
*do while .t.
   if msser=1
      do while .t.
         skr=slcf('cskl',1,1,18,,"e:sk h:'SK' c:n(3) e:nskl h:'Наименование' c:c(20)",'sk',,1,,"file(gcPath_d+alltrim(path)+'tprds01.dbf').and.ent=gnEnt")
         if lastkey()=K_ESC
            exit
         endif
         if lastkey()=K_ENTER
            save scre to scskr
            sele cskl
            LOCATE FOR sk=skr
            nsklr=nskl
            Pathr=gcPath_d+alltrim(path)
            netuse('sgrp',,,1)
            store 0 to kgrr,otr,markr,svkeyr,knalr,wsgrpins,grpr,;
                       grkeir,indloptr,indlrozr,indhoptr,indhrozr
            store space(20) to ngrr
            store space(20) to nalr
            store space(5) to grneir
            foot('INS,DEL,F4,ESC','Добавить,Удалить,Коррекция,Выход')
            do while .t.
               kgrr=slcf('sgrp',,,,,"e:kgr h:'Код' c:n(3) e:ngr h:'Наименование' c:c(20) e:ot h:'От' c:n(2) e:mark h:'М' c:n(1) e:nal h:'Налоги' c:c(20) e:getfield('t1','sgrp->lic','lic','nlic') h:'Лицензия' c:c(20)",'kgr',,1)
               if lastkey()=K_ESC
                  exit
               endif
               sele sgrp
               netseek('t1','kgrr')
               ngrr=ngr
               otr=ot
               notr=getfield('t1','Skr,otr','cskle','nai')
               markr=mark
               licr=lic
               grpr=grp
               grkeir=grkei
               indloptr=indlopt
               indlrozr=indlroz
               indhoptr=indhopt
               indhrozr=indhroz
               grneir=getfield('t1','grkeir','nei','nei')
               nlicr=getfield('t1','licr','lic','nlic')
               ngrpr=getfield('t1','grpr','grp','ng')
               if markr=0
                  nmarkr='Обычный'
               else
                  nmarkr='Автомат'
               endif
               nalr=nal
               nokopr=space(20)
               if fieldpos('nokop')#0
                  nokopr=nokop
               endif
               if fieldpos('prbb')#0
                  prbbr=prbb
               else
                  prbbr=0
               endif
               do case
                  case lastkey()=K_INS .and. (dkklnr=1.or.gnadm=1)  // Добавить
                       sgrpins()
                  case lastkey()=K_DEL .and. (dkklnr=1.or.gnadm=1)  // Удалить
                       if netseek('t1','kgrr')
                          netdel()
                          skip -1
                       endif
                  case lastkey()=-3 .and. (dkklnr=1.or.gnadm=1) // Коррекция
                       sgrpins(1)
               endc
            endd
            nuse('sgrp')
            rest scre from scskr
         endif
      enddo
   else // cgrp
      do while .t.
         foot('INS,DEL,F4,ESC','Добавить,Удалить,Коррекция,Выход')
         if fieldpos('kovs')=0
            rccgrpr=slcf('cgrp',,,,,"e:kgr h:'Код' c:n(3) e:ngr h:'Наименование' c:c(20) e:ot h:'От' c:n(2) e:mark h:'М' c:n(1) e:tgrp h:'БСО' c:n(1) e:prpcen h:'%' c:n(1) e:kov h:'КОВ' c:n(10,3)",,,1)
         else
            rccgrpr=slcf('cgrp',,,,,"e:kgr h:'Код' c:n(3) e:ngr h:'Наименование' c:c(20) e:ot h:'От' c:n(2) e:mark h:'М' c:n(1) e:tgrp h:'БСО' c:n(1) e:prpcen h:'%' c:n(1) e:kov h:'КОВ' c:n(10,3) e:kovs h:'КОВC' c:n(10,3) e:tgrp h:'А' c:n(1)",,,1)
         endif
         if lastkey()=K_ESC
            exit
         endif
         sele cgrp
         go rccgrpr
         kgrr=kgr
         ngrr=ngr
         otr=ot
*         notr=getfield('t1','Skr,otr','cskle','nai')
         markr=mark
         licr=lic
         grpr=grp
         nlicr=getfield('t1','licr','lic','nlic')
         ngrpr=getfield('t1','grpr','grp','ng')
         if markr=0
            nmarkr='Обычный'
         else
            nmarkr='Автомат'
         endif
         nalr=nal
         tgrpr=tgrp
         if fieldpos('prpcen')#0
            prpcenr=prpcen
         else
            prpcenr=0
         endif
         kovr=kov
         if fieldpos('kovs')=0
            kovsr=1
         else
            kovsr=kovs
         endif
         if fieldpos('prbb')#0
            prbbr=prbb
         else
            prbbr=0
         endif
         do case
            case lastkey()=K_INS .and. (dkklnr=1.or.gnadm=1)  // Добавить
                 cgins()
            case lastkey()=K_DEL .and. (dkklnr=1.or.gnadm=1)  // Удалить
                 netdel()
                 skip -1
                 if bof()
                    go top
                 endif
            case lastkey()=-3 .and. (dkklnr=1.or.gnadm=1) // Коррекция
                 cgins(1)
         endc
      endd
   endif
*enddo
nuse()

stat func sgrpins(p1)
cor_r=p1
if cor_r=nil
   store 0 to kgrr,otr,markr,svkeyr,licr,grpr,;
              grkeir,indloptr,indlrozr,indhoptr,indhrozr,prbbr
   store space(20) to ngrr,notr,nlicr,nokopr
   store space(10) to nalr
   store space(5) to grneir
endif
foot('','')
clsgrpins=setcolor('gr+/b,n/w')
wsgrpins=wopen(7,18,21,65)
wbox(1)

do while .t.
   if cor_r=nil
      @ 0,1 say 'Код группы  ' get kgrr pict '999' valid kgr()
   else
      @ 0,1 say 'Код группы  '+' '+str(kgrr,3)
   endif
   @ 1,1 say 'Наименование' get ngrr
   ngrr=upper(ngrr)
   @  2,17 say notr
   @  2,1 say 'Отдел       ' get otr  pict '99' valid ot()
   @  3,17 say nmarkr
   @  3,1 say 'Пр.форм.наим' get markr pict '9' valid mark()
   @  4,1 say 'Налоги      ' get nalr when wnal() valid vnal()
   @  5,17 say nlicr
   @  5,1 say 'Лицензия    ' get licr valid lic1()
   @  6,18 say ngrpr
   @  6,1 say 'Группа по ум' get grpr pict '999' valid grp()
   @  7,1 say 'Ед.изм.индик' get grkeir valid grkei() pict '9999'
   @  7,col()+1 say grneir
   @  8,1 say 'Min.инд.опта' get indloptr pict '999999.999'
   @  9,1 say 'Min.инд.розн' get indlrozr pict '999999.999'
   @ 10,1 say 'Max.инд.опта' get indhoptr pict '999999.999'
   @ 11,1 say 'Max.инд.розн' get indhrozr pict '999999.999'
   @ 12,1 say 'Приход без б' get prbbr pict '9'
   read
   if lastkey()=K_ESC
      exit
   endif
   @ 12,30 prom 'Верно'
   @ 12,col()+1 prom 'Не верно'
   menu to vn
   if lastkey()=K_ESC
      exit
   endif
   if vn=1
      sele sgrp
      if cor_r=nil
         netadd()
         netrepl('kgr,ngr,ot,mark,nal,lic,grp','kgrr,ngrr,otr,markr,nalr,licr,grpr')
      else
         if netseek('t1','kgrr')
            netrepl('ngr,ot,mark,nal,lic,grp','ngrr,otr,markr,nalr,licr,grpr')
         endif
      endif
      if fieldpos('nokop')#0
         netrepl('nokop','nokopr')
      endif
      if fieldpos('prbb')#0
         netrepl('prbb','prbbr')
      endif
      if fieldpos('grkei')#0
         netrepl('grkei,indlopt,indlroz,indhopt,indhroz','grkeir,indloptr,indlrozr,indhoptr,indhrozr')
      endif
      exit
   endif
endd
wclose(wsgrpins)
setcolor(clsgrpins)
retu .t.

stat func kgr()
if cor_r=nil
   if msser=1
      sele sgrp
   else
      sele cgrp
   endif
   rc_r=recn()
   if netseek('t1','kgrr')
      wselect(0)
      save scre to scmess
      mess('Такой код существует',1)
      rest scre from scmess
      wselect(wsgrpins)
      go rc_r
      retu .f.
   endif
endif
retu .t.

stat func ot()
if !netseek('t1','Skr,otr','cskle').or.otr=0
   go top
   wselect(0)
   otr=slcf('cskle',,,,,"e:ot h:'Код' c:n(2) e:nai h:'Наименование' c:c(20)",'ot',,,,'sk=skr',)
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
      case lastkey()=K_ESC
           exit
      case lastkey()=K_ENTER
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
   nmarkr='Обычный'
else
   nmarkr='Автомат'
endif
@ 3,17 say nmarkr
retu .t.

stat func lic1
sele lic
if !netseek('t1','licr').or.licr=0
   go top
   wselect(0)
   licr=slcf('lic',,,,,"e:lic h:'Код' c:n(1) e:nlic h:'Наименование' c:c(20)",'lic',,,,,,'ЛИЦЕНЗИИ')
   wselect(wsgrpins)
   if lastkey()#K_ESC
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
********************
stat func cgins(p1)
********************
cor_r=p1
if cor_r=nil
   store 0 to kgrr,otr,markr,svkeyr,licr,grpr,tgrpr,prpcenr,kovr,prbbr
   store space(20) to ngrr,notr,nlicr
   store space(10) to nalr
endif
foot('','')
clcgrpins=setcolor('gr+/b,n/w')
wcgrpins=wopen(7,18,18,65)
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
*   @  3,17 say nmarkr
*   @  3,1 say 'Пр.форм.наим' get markr pict '9' valid mark()
*   @  4,1 say 'Налоги      ' get nalr when wnal() valid vnal()
*   @  5,17 say nlicr
*   @  5,1 say 'Лицензия    ' get licr valid lic1()
*   @  6,18 say ngrpr
*   @  6,1 say 'Акциз       ' get tgrpr pict '9'
   @  7,1 say 'БСО(Акциз)   ' get tgrpr pict '9'
   @  8,1 say 'Авторасценка' get prpcenr pict '9'
   @  9,1 say 'Приход без б' get prbbr pict '9'
   read
   if lastkey()=K_ESC
      exit
   endif
   @ 9,30 prom 'Верно'
   @ 9,col()+1 prom 'Не верно'
   menu to vn
   if lastkey()=K_ESC
      exit
   endif
   if vn=1
      sele cgrp
      if cor_r=nil
         netadd()
 *        netrepl('kgr,ngr,ot,mark,nal,lic,grp,tgrp','kgrr,ngrr,otr,markr,nalr,licr,grpr,tgrpr')
         netrepl('kgr,ngr,tgrp,kov','kgrr,ngrr,tgrpr,kovr')
      else
*         netrepl('ngr,ot,mark,nal,lic,grp,tgrp','ngrr,otr,markr,nalr,licr,grpr,tgrpr')
         netrepl('ngr,tgrp,kov','ngrr,tgrpr,kovr')
      endif
      if fieldpos('prpcen')#0
         netrepl('prpcen','prpcenr')
      endif
      if fieldpos('kovs')#0
         netrepl('kovs','kovsr')
      endif
      if fieldpos('prbb')#0
         netrepl('prbb','prbbr')
      endif
      exit
   endif
endd
wclose(wcgrpins)
setcolor(clcgrpins)
retu .t.
