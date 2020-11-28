#include "common.ch"
#include "inkey.ch"
  //Коррекция цен в TOV,CTOV (по TCEN)
local oclr,sccen,rr,cc,i
  refr=0
  skndsr=savesetkey()
  if cor_r=0 // Цены доступны в режимах коррекции/просмотра
     retu
  endif
  cor_rr=2
  if gnKart=1.or.gnAdm=1
     cor_rr=1
  endif
  vn1=1
  save scre to sccen
  svgets=savegets()
  clea gets

  oclr=setcolor('gr+/b,n/w')
  @ 1,0 clea
  @ 1,0,24,79 box frame
  do case
     case tov_r=='tov'
          @ 23,1 say 'Справочник склада по учетным ценам  '
          sele tov
          netseek('t1','sklr,ktlr')
          obncen(mntovr,1)
     case tov_r=='tovm'
          @ 23,1 say 'Справочник склада по отпускным ценам '
          sele tovm
          netseek('t1','sklr,mntovr')
          obncen(mntovr,1)
  endc

  sele (tov_r)
  if opt#0
     nacr=(cenpr/opt-iif(fieldpos('tsz60')#0,tsz60,0)-1)*100
     @ 23,60 say '%нац '+str(nacr,6,2) color 'gr+/b'
  endif

  kgrr=int(ktlr/1000000)
    //  netuse('ctovo')
  **********
  prpcenr=1
  **********
  do while .t.
     acopt:={}
     sele tcen
     set orde to tag t2
     go top
     rr=2
     cc=1
     do while !eof()
        if sh=0
           sele tcen
           skip
           loop
        endif
        tt=alltrim(zen)+'r'
        tto=tt+'o'
        tt1=alltrim(zen)
        sele (tov_r)
        &tt=&tt1
        &tto=&tt1
        sele tcen
        zenr=alltrim(zen)
        tcenpr=tcenp
        decpr=dec
        if decpr=0
           decpr=3
        endif
        prtcenpr=prtcenp
        ntcenr=ntcen
        ntcen_r=subs(ntcenr,1,10)
        kndsr=knds
        if tcenpr#0
           rctcenr=recn()
           locate for tcen=tcenpr
           cpzenr=alltrim(zen)
           cpzen1r=alltrim(zen)+'r'
           pzenr=&cpzen1r // Цена родителя
           newzenr=pzenr+pzenr*prtcenpr/100
           if prtcenpr=gnNds
              newzenr=roun(newzenr,2)
           endif
           if &(zenr+'r')#newzenr
    //              netrepl(zenr,'newzenr',1)
              tt=alltrim(zenr)+'r'
              &tt=newzenr
           endif
           sele tcen
           go rctcenr
        endif
        if zenr='opt'.and.gnCtov=1
           if gnSkotv#0 //gnOtv=1
              &tt=0.01
           endif
           @ rr,cc say ntcen_r+' '+str(&tt,10,3)
        else
           if (cor_rr=1.and.gnCenp=1).or.gnAdm=1
              if gnKart=1 .or. gnKart=2 .or. gnAdm=1
                 if tcenpr=0
                    @ rr,cc say ntcen_r get &tt pict '999999.999' when wtt() valid vtt()
                 else
                    @ rr,cc say ntcen_r+' '+str(&tt,10,3)
                 endif
              else
                 @ rr,cc say ntcen_r+' '+str(&tt,10,3)
              endif
           else
              @ rr,cc say ntcen_r+' '+str(&tt,10,3)
           endif
        endif
        if kndsr=1
           @ rr,23 say str(decpr,1)+' '+iif(prtcenpr#0,str(prtcenpr,6,3),space(6))+' '+str(&tt*(100+gnNds)/100,10,3)+' '+str(((&tt/optr-1)*100),6,3)
        else
           @ rr,23 say str(decpr,1)+' '+ iif(prtcenpr#0,str(prtcenpr,6,3),'')
        endif
        rr=rr+1
        if rr=23
           rr=2
           cc=51
        endif
        aadd(acopt,zenr)
        sele tcen
        skip
     endd
     if ((cor_rr=1.and.gnArm#4).or.gnAdm=1) //.and.cntr=0.or.(cor_r=2.and.gnCtov=2)
        read
        if lastkey()=K_ESC
           exit
        endif
     else
        if tov_r=='tov'
           read
           if lastkey()=K_ESC
              exit
           endif
        endif
     endif
     if refr=1
        loop
     endif
     @ 23,60 prom 'Верно'
     @ 23,col()+1 prom 'Не верно'
     menu to vn1
     if lastkey()=K_ESC
        exit
     endif
     if vn1=1.and.(cor_r#2.or.cor_rr=1.or.tov_r=='tov')
        sele (tov_r)
        reclock()
        sele (tov_r)
        if tov_r=='tov'
           rctov_rr=recn()
           tovordr=ordsetfocus('t5')
           if netseek('t5','sklr,mntovr')
              do while skl=sklr.and.mntov=mntovr
                 reclock()
                 for i=1 to len(acopt)
                     tt=acopt[i]
                     tt1=alltrim(acopt[i])+'r'
                     if tt#'opt'
                        repl &tt with &tt1
                     else
                        if gnCtov#1
                           repl &tt with &tt1
                        endif
                     endif
                 next
                 netunlock()
                 skip
              endd
           endif
           ordsetfocus(tovordr)
           go rctov_rr
        endif
        mnctovpr=0
        if tov_r=='tovm'
           if gnEnt=21
              mntovtr=mntovt
              if mntovtr=0
                 mntovtr=mntovr
              endif
              sele ctov
              set orde to tag t10 // mntovt,mntov
              if netseek('t10','mntovtr')
                 do while mntovt=mntovtr
                    reclock()
                    for i=1 to len(acopt)
                         tt=acopt[i]
                         tt1=alltrim(acopt[i])+'r'
                         repl &tt with &tt1
                    next
                    netunlock()
                    sele ctov
                    skip
                 endd
              endif
              set orde to tag t1
           else
              sele ctov
              netseek('t1','mntovr')
              sele ctov
              reclock()
              for i=1 to len(acopt)
                  tt=acopt[i]
                  tt1=alltrim(acopt[i])+'r'
                  repl &tt with &tt1
              next
              netunlock()
           endif
           sele tov
           if gnEnt=21
              tovordr=ordsetfocus('t10') // skl,mntovt,otv,ktl
              if netseek('t10','sklr,mntovtr')
                 do while skl=sklr.and.mntovt=mntovtr
                    reclock()
                    for i=1 to len(acopt)
                        tt=acopt[i]
                        tt1=alltrim(acopt[i])+'r'
                        if tt#'opt'
                           repl &tt with &tt1
                        endif
                    next
                    netunlock()
                    skip
                 endd
              endif
           else
              tovordr=ordsetfocus('t5')
              if netseek('t5','sklr,mntovr')
                 do while skl=sklr.and.mntov=mntovr
                    reclock()
                    for i=1 to len(acopt)
                        tt=acopt[i]
                        tt1=alltrim(acopt[i])+'r'
                        if tt#'opt'
                           repl &tt with &tt1
                        endif
                    next
                    netunlock()
                    skip
                 endd
              endif
           endif
           ordsetfocus(tovordr)
        endif
        if tov_r=='tov'
           if gnCtov=1
              sele ctov
              netseek('t1','mntovr')
              sele ctov
              reclock()
              for i=1 to len(acopt)
                  tt=acopt[i]
                  tt1=alltrim(acopt[i])+'r'
                  repl &tt with &tt1
              next
              netunlock()
              sele tovm
              netseek('t1','sklr,mntovr')
              reclock()
              for i=1 to len(acopt)
                  tt=acopt[i]
                  tt1=alltrim(acopt[i])+'r'
                  repl &tt with &tt1
              next
              netunlock()
           endif
        endif
        sele (tov_r)
        exit
     endif
  endd
  set key -4 to
  restgets(svgets)
  rest scre from sccen
  setcolor(oclr)
  restsetkey(skndsr)
  setlastkey(0)
    //  nuse('ctovo')
  retu

****************
stat func wtt()
  ****************
  set key K_SPACE to wnds()
  if gnEnt=21
    setkeyAsc_a()
  endif
  retu .t.

*************
func vtt()
  *************
  sel=select()
  kkk= getfldvar()
  kkk1=getfldvar()
  kkk=&kkk
  sele tcen
  go top
  locate for substr(zen,1,len(zen))=substr(kkk1,1,(len(kkk1)-1))
  kndsr=knds
  tcen_rr=tcen
  zen_rr=alltrim(zen)
  sele (tov_r)
  tt=zen_rr+'r'
  tto=tt+'o'
  if &tt=&tto
     refr=0
  else
     &tto=&tt
  endif
  sele &sel
  if kkk#0.and.kkk<optr
    //  beeper()
     wmess('Цена меньше закупочной !!!')
  endif
  if &kkk1#0.and.gnSnds=5.and.kndsr=0
     if &kkk1<round((optr+optr*gnNds/100),3)
    //     beeper()
        wmess('Цена меньше закупочной с НДС !!!')
     endif
  endif
  set key K_SPACE to
  if gnEnt=21
     setkeyAsc_a()
  endif
  if refr=1
     clea gets
  endif
  retu .t.
*****************
stat func wnds()
  *****************
  cenr=getfldvar()
  #ifdef __CLIP__
     &cenr=ROUND(&(cenr)*100/(100+gnNds),3)
  #else
     &cenr=ROUND(&(cenr)*100/(100+gnNds),2)
  #endif
  retu .t.

*************
func rsakc()
  *************
  if gnEnt#20
     retu .t.
  endif

  if !(gnAdm=1.or.gnKto=160.or.gnKto=848)
     retu .t.
  endif

  clea
  if select('sl')#0
     sele sl
     use
  endif
  sele 0
  use _slct alias sl excl
  zap

  crtt('rsakc','f:ttn c:n(6) f:kpl c:n(7) f:npl c:c(40) f:kgp c:n(7) f:ngp c:c(40) f:sdv c:n(12,2) f:kta c:n(4) f:nkta c:c(15) f:ktas c:n(4) f:nktas c:c(15)')
  sele 0
  use rsakc excl

  netuse('tara')
  netuse('tcen')
  netuse('kln')
  netuse('kpl')
  netuse('kgp')
  netuse('kgptm')
  netuse('krntm')
  netuse('nasptm')
  netuse('rntm')
  netuse('ctov')
  netuse('stagm')
  netuse('tmesto')
  netuse('cskl')
  netuse('s_tag')
  netuse('vop')
  netuse('dclr')
  netuse('vo')
  netuse('dokk')
  netuse('dkkln')
  netuse('dknap')
  netuse('dkklns')
  netuse('dkklna')
  netuse('dokko')
  netuse('bs')
  netuse('moddoc')
  netuse('mdall')
  netuse('tov')
  netuse('sgrp')
  netuse('cgrp')
  netuse('tovm')
  netuse('soper')
  netuse('grpizg')
  netuse('nap')
  netuse('naptm')
  netuse('kplnap')
  netuse('ktanap')

  netuse('rs1')
  netuse('rs2')
  netuse('rs3')

  sele rs1
  go top
  rcrs1r=recn()
  for_r='kopi=177.and.prz=0'
  forr=for_r
  do while .t.
     foot('Space,Enter,F3','Отбор,Переворот,Фильтр')
     sele rs1
     go rcrs1r
     rcrs1r=slcf('rs1',1,0,18,,"e:ttn h:'TTN' c:n(6) e:prz h:'P' c:n(1) e:kop h:'KOP' c:n(3) e:kpl h:'KPL' c:n(7) e:getfield('t1','rs1->kpl','kln','nkl') h:'Клиент' c:c(30) e:kgp h:'KGP' c:n(7) e:sdv h:'SDV' c:n(10,2)",,1,1,,forr,,'АКЦИИ '+alltrim(gcNskl))
     if lastkey()=K_ESC
        exit
     endif
     sele rs1
     go rcrs1r
     do case
        case lastkey()=K_ENTER
             p177169()
             sele rs1
             go top
             rcrs1r=recn()
        case lastkey()=K_F3
             akcflt()
     endc
  endd
  nuse()
  nuse('sl')
  nuse('rsakc')
  retu .t.

**************
func akcflt()
  **************
  cldeb=setcolor('w/b,n/w')
  wdeb=wopen(10,30,15,50)
  wbox(1)
  store space(20) to ctextr
  store 0 to kkl_r,kta_r
  store space(9) to msk_r
  akcfltr=0
  do while .t.
     @ 0,1 say 'Фильтр' get akcfltr pict '9'
     @ 1,1 say '0 - Все'
     @ 2,1 say '1 - 177'
     @ 3,1 say '2 - 169'
     read
     if lastkey()=K_ESC
        forr=for_r
        sele rs1
        go top
        rcrs1r=recn()
        exit
     endif
     if lastkey()=K_ENTER
        forr=for_r
        do case
           case akcfltr=0
           case akcfltr=1
                forr=forr+'.and.rs1->kop=177'
           case akcfltr=2
                forr=forr+'.and.rs1->kop=169'
        endc
        sele rs1
        go top
        rcrs1r=recn()
        exit
     endif
  endd
  wclose(wdeb)
  setcolor(cldeb)
  retu .t.

***************
func p177169()
  ***************
  sele rsakc
  zap
  clea
  sele sl
  go top
  do while !eof()
     rcrs1_r=val(kod)
     sele rs1
     go rcrs1_r
     ttnr=ttn
     kopr=kop
     kplr=kpl
     kgpr=kgp
     nkklr=nkkl
     kpvr=kpv
     if kopr=177
        netrepl('kop,kpl,kgp,nkkl,kpv','169,20034,20034,kplr,kgpr')
     else
        netrepl('kop,kpl,kgp','177,nkklr,kpvr')
     endif
     dcpere(0,ttnr)
     sele rs1
     if kop=169
        ttnr=ttn
        kplr=nkkl
        kgpr=kpv
        sdvr=sdv
        ktar=kta
        ktasr=ktas
        nplr=getfield('t1','kplr','kln','nkl')
        ngpr=getfield('t1','kgpr','kln','nkl')
        nktar=getfield('t1','ktar','s_tag','fio')
        nktasr=getfield('t1','ktasr','s_tag','fio')
        sele rsakc
        appe blank
        repl ttn with ttnr,;
             kpl with kplr,;
             npl with nplr,;
             kgp with kgpr,;
             ngp with ngpr,;
             sdv with sdvr,;
             kta with ktar,;
             nkta with nktar,;
             ktas with ktasr,;
             nktas with nktasr
     endif
     sele sl
     skip
  endd
  if select('rsakc')#0
     sele rsakc
     #ifdef __CLIP__
       if dirchange('j:\vitaliyi')=0
          copy to ('j:\vitaliyi\rsakc.dbf')
       endif
     #else
       if dirchange('g:\work\upgrade\vitaliyi')=0
          copy to ('g:\work\upgrade\vitaliyi\rsakc.dbf')
       endif
     #endif
     dirchange(gcPath_l)
  endif
  retu .t.

*******************************************
func cenl()
    //Коррекция цен в TOV,CTOV (по TCEN) LODIS
  *******************************************
  local oclr,sccen,rr,cc,i
  refr=0
  skndsr=savesetkey()
  if cor_r=0 // Цены доступны в режимах коррекции/просмотра
     retu .t.
  endif
  cor_rr=2
  if gnKart=1.or.gnAdm=1
     cor_rr=1
  endif
  vn1=1
  save scre to sccen
  svgets=savegets()
  clea gets

  oclr=setcolor('gr+/b,n/w')
  @ 1,0 clea
  @ 1,0,24,79 box frame
  do case
     case tov_r=='tov'
          @ 23,1 say 'Справочник склада по учетным ценам  '
          sele tov
          netseek('t1','sklr,ktlr')
          obncen(mntovr,1)
     case tov_r=='tovm'
          @ 23,1 say 'Справочник склада по отпускным ценам '
          sele tovm
          netseek('t1','sklr,mntovr')
          obncen(mntovr,1)
  endc

  sele (tov_r)
  if opt#0
     nacr=(cenpr/opt-iif(fieldpos('tsz60')#0,tsz60,0)-1)*100
     @ 23,60 say '%нац '+str(nacr,6,2) color 'gr+/b'
  endif

  kgrr=int(ktlr/1000000)
    //  netuse('ctovo')
  **********
  prpcenr=1
  **********
  do while .t.
     acopt:={}
     sele tcen
     set orde to tag t2
     go top
     rr=2
     cc=1
     do while !eof()
        if sh=0
           sele tcen
           skip
           loop
        endif
        tt=alltrim(zen)+'r'
        tto=tt+'o'
        tt1=alltrim(zen)
        sele (tov_r)
        &tt=&tt1
        &tto=&tt1
        sele tcen
        zenr=alltrim(zen)
        tcenpr=tcenp
        decpr=dec
        if decpr=0
           decpr=3
        endif
        prtcenpr=prtcenp
        ntcenr=ntcen
        ntcen_r=subs(ntcenr,1,10)
        kndsr=knds
        prtcenp_r=0
        if tcenpr#0
           rctcenr=recn()
           locate for tcen=tcenpr
           cpzenr=alltrim(zen)
           cpzen1r=alltrim(zen)+'r'
           pzenr=&cpzen1r // Цена родителя
           if pzenr#0
              prtcenp_r=roun((&tt-pzenr)*100/pzenr,2)
           endif
    //        newzenr=roun(pzenr+pzenr*prtcenpr/100,decpr)
    //        if prtcenpr=gnNds
    //           newzenr=roun(newzenr,2)
    //        endif
    //        if &(zenr+'r')#newzenr
    //           sele (tov_r)
    //           netrepl(zenr,'newzenr',1)
    //           tt=alltrim(zenr)+'r'
    //           &tt=newzenr
    //        endif
           sele tcen
           go rctcenr
        endif
        if zenr='opt'.and.gnCtov=1
           if gnSkotv#0 //gnOtv=1
              &tt=0.01
           endif
           @ rr,cc say ntcen_r+' '+str(&tt,10,3)
        else
           if (cor_rr=1.and.gnCenp=1).or.gnAdm=1
              if gnKart=1 .or. gnKart=2 .or. gnAdm=1
    //              if tcenpr=0
                    @ rr,cc say ntcen_r get &tt pict '999999.999' when wtt() valid vtt()
    //              else
    //                 @ rr,cc say ntcen_r+' '+str(&tt,10,3)
    //              endif
              else
                 @ rr,cc say ntcen_r+' '+str(&tt,10,3)
              endif
           else
              @ rr,cc say ntcen_r+' '+str(&tt,10,3)
           endif
        endif
        if kndsr=1
           @ rr,23 say str(decpr,1)+' '+iif(prtcenp_r#0,str(prtcenp_r,6,3),space(6))+' '+str(&tt*(100+gnNds)/100,10,3)+' '+str(((&tt/optr-1)*100),6,3)
        else
           @ rr,23 say str(decpr,1)+' '+ iif(prtcenp_r#0,str(prtcenp_r,6,3),'')
        endif
        rr=rr+1
        if rr=23
           rr=2
           cc=51
        endif
        aadd(acopt,zenr)
        sele tcen
        skip
     endd
     if ((cor_rr=1.and.gnArm#4).or.gnAdm=1) //.and.cntr=0.or.(cor_r=2.and.gnCtov=2)
        read
        if lastkey()=K_ESC
           exit
        endif
     else
        if tov_r=='tov'
           read
           if lastkey()=K_ESC
              exit
           endif
        endif
     endif
     if refr=1
        loop
     endif
     @ 23,60 prom 'Верно'
     @ 23,col()+1 prom 'Не верно'
     menu to vn1
     if lastkey()=K_ESC
        exit
     endif
     if vn1=1.and.(cor_r#2.or.cor_rr=1.or.tov_r=='tov')
        sele (tov_r)
        reclock()
        sele (tov_r)
        if tov_r=='tov'
           rctov_rr=recn()
           tovordr=ordsetfocus('t5')
           if netseek('t5','sklr,mntovr')
              do while skl=sklr.and.mntov=mntovr
                 reclock()
                 for i=1 to len(acopt)
                     tt=acopt[i]
                     tt1=alltrim(acopt[i])+'r'
                     if tt#'opt'
                        repl &tt with &tt1
                     else
                        if gnCtov#1
                           repl &tt with &tt1
                        endif
                     endif
                 next
                 netunlock()
                 skip
              endd
           endif
           ordsetfocus(tovordr)
           go rctov_rr
        endif
        mnctovpr=0
        if tov_r=='tovm'
           if gnEnt=21
              mntovtr=mntovt
              if mntovtr=0
                 mntovtr=mntovr
              endif
              sele ctov
              set orde to tag t10 // mntovt,mntov
              if netseek('t10','mntovtr')
                 do while mntovt=mntovtr
                    reclock()
                    for i=1 to len(acopt)
                         tt=acopt[i]
                         tt1=alltrim(acopt[i])+'r'
                         repl &tt with &tt1
                    next
                    netunlock()
                    sele ctov
                    skip
                 endd
              endif
              set orde to tag t1
           else
              sele ctov
              netseek('t1','mntovr')
              sele ctov
              reclock()
              for i=1 to len(acopt)
                  tt=acopt[i]
                  tt1=alltrim(acopt[i])+'r'
                  repl &tt with &tt1
              next
              netunlock()
           endif
           sele tov
           if gnEnt=21
              tovordr=ordsetfocus('t10') // skl,mntovt,otv,ktl
              if netseek('t10','sklr,mntovtr')
                 do while skl=sklr.and.mntovt=mntovtr
                    reclock()
                    for i=1 to len(acopt)
                        tt=acopt[i]
                        tt1=alltrim(acopt[i])+'r'
                        if tt#'opt'
                           repl &tt with &tt1
                        endif
                    next
                    netunlock()
                    skip
                 endd
              endif
           else
              tovordr=ordsetfocus('t5')
              if netseek('t5','sklr,mntovr')
                 do while skl=sklr.and.mntov=mntovr
                    reclock()
                    for i=1 to len(acopt)
                        tt=acopt[i]
                        tt1=alltrim(acopt[i])+'r'
                        if tt#'opt'
                           repl &tt with &tt1
                        endif
                    next
                    netunlock()
                    skip
                 endd
              endif
           endif
           ordsetfocus(tovordr)
        endif
        if tov_r=='tov'
           if gnCtov=1
              sele ctov
              netseek('t1','mntovr')
              sele ctov
              reclock()
              for i=1 to len(acopt)
                  tt=acopt[i]
                  tt1=alltrim(acopt[i])+'r'
                  repl &tt with &tt1
              next
              netunlock()
              sele tovm
              netseek('t1','sklr,mntovr')
              reclock()
              for i=1 to len(acopt)
                  tt=acopt[i]
                  tt1=alltrim(acopt[i])+'r'
                  repl &tt with &tt1
              next
              netunlock()
           endif
        endif
        sele (tov_r)
        exit
     endif
  endd
  set key -4 to
  restgets(svgets)
  rest scre from sccen
  setcolor(oclr)
  restsetkey(skndsr)
  setlastkey(0)
  retu .t.

*****************
stat func wpar()
  *****************
  cenr=getfldvar()
  *rr=getfldrow()
  rr=getlist[currentget()]:row
  sele tcen
  locate for substr(zen,1,len(zen))=substr(cenr,1,(len(cenr)-1))
  tcenpr=tcenp
  kndsr=knds
  if gnEnt=21.and.kgr=341.and.tcenpr=22.and.prtcenpr#0
     prtcenpr=6 //prtcenp
  else
     prtcenpr=prtcenp
  endif
  if tcenpr#0
     rctcenr=recn()
     locate for tcen=tcenpr
     decr=dec
     cpzenr=alltrim(zen)
     cpzen1r=alltrim(zen)+'r'
     pzenr=&cpzen1r // Цена родителя
     &cenr=roun(pzenr+pzenr*prtcenpr/100,decr)
     tt=cenr
     prtcenp_r=roun((&tt-pzenr)*100/pzenr,2)
     sele tcen
     go rctcenr
     if kndsr=1
        @ rr,23 say str(decr,1)+' '+iif(prtcenp_r#0,str(prtcenp_r,6,3),space(6))+' '+str(&tt*(100+gnNds)/100,10,3)+' '+str(((&tt/optr-1)*100),6,3)
     else
        @ rr,23 say str(decr,1)+' '+ iif(prtcenp_r#0,str(prtcenp_r,6,3),'')
     endif
  endif
  retu .t.

/*****************************************************************
 
 FUNCTION:
 АВТОР..ДАТА..........С. Литовка  10-05-16   //04:49:18pm
 НАЗНАЧЕНИЕ.........
 ПАРАМЕТРЫ..........
 ВОЗВР. ЗНАЧЕНИЕ....
 ПРИМЕЧАНИЯ.........
 */
FUNCTION setkeyAsc_a()
     //set key 97 to wpar() // a - лат
     set key ASC('a') to wpar() // a - лат

     #ifdef __CLIP__
        //set key 198 to wpar() // ф - русская
        set key ASC('ф') to wpar()
     #else
        //set key 228 to wpar() // ф - русская
        set key ASC('ф') to wpar()
     #endif
  RETURN (NIL)
