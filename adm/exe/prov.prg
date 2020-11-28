para p1,p2
* p1 :  1 - Приход; 0 - Расход
* p2 :  1 - Добавить ; 2 - удалить
* DOKK,DKKLN,BS
d0k1r=p1
udlr=p2
vur=1
store 0 to mnr,rndr
do case
   case d0k1r=1  && Приход
        sele pr1
        rnr=nd
        mnpr=mn
        mndokr=mn
        cmndokr='mn'
        kopr=kop
        kklr=kps
        ddkr=dpr 
        vor=0
        kgr=kto
        bprzr=0
   case d0k1r=0  && Расход
        sele rs1
        rnr=ttn
        mnpr=0
        mndokr=ttn
        cmndokr='ttn'
        kopr=kop
        ddkr=dot
        vor=vo
        kgr=kto
        bprzr=bprz
        do case
           case vor=5
                kplr=kpl 
                kklr=gnKkl_c
           othe
                kklr=kpl
        endc
        if vor=5.or.vor=7.or.vor=8
           sklr=kgp
        endif
endc
opr=mod(kopr,100)
sele soper
if !netseek('t1','d0k1r,vur,vor,opr')
   ?'SK '+str(skr,2)+' D0K1 '+str(d0k1r,1)+' VO '+str(vor,1)+' Док '+str(rnr,6)+' KOP '+str(kopr,3)+' Не найден КОП'
   retu
endif
prnnr=prnn
ndsr=nds

if d0k1r=1
   sele pr3
   ff3='pr3'
else
   sele rs3
   ff3='rs3'
endif

if !netseek('t1','mndokr')
   ?'SK '+str(skr,2)+' D0K1 '+str(d0k1r,1)+' VO '+str(vor,1)+' Док '+str(rnr,6)+' Нет денежной части'
   retu
endif

do while &cmndokr=mndokr
   kszr=ksz
   if bprzr=0
      bs_sr=ssf
   else
      bs_sr=bssf
   endif
   sele soper
   for i=1 to 20
       sele soper 
       nn=ltrim(str(i,2))
       ckszr='dsz'+nn
       cbs_dr='ddb'+nn
       cbs_kr='dkr'+nn
       cmaskr='prz'+nn
       if &ckszr#kszr
          loop
       endif
       bs_dr=&cbs_dr
       if bs_dr=440000.and.vor=5
          bs_dr=kplr       
       endif
       bs_kr=&cbs_kr
       maskr=&cmaskr
       prv(udlr)
   next
   sele (ff3)
   skip
endd

