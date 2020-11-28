* Загрузка продаж (КПК)
lcrtt('lrs1','rs1')
lindx('lrs1','rs1')
lcrtt('lrs2','rs2')
lindx('lrs2','rs2')
luse('lrs1')
luse('lrs2')
cDelim=CHR(13) + CHR(10)
hzvr=fopen('to1c.xml')
store 0 to pragr,prdocr
ttnr=1
do while !feof(hzvr)
   aaa=FReadLn(hzvr, 1,600, cDelim)
   do case
      case subs(aaa,1,10)='<AgentPlus'
           pragr=1
           colr=at('AgentID',aaa)
           cktar=subs(aaa,colr+len('AgentID')+2,36)
           ktar=val(right(cktar,3))
      case subs(aaa,1,10)='</AgentPlus'
           pragr=0
           prdocr=0
           prorder=0
      case subs(aaa,1,4)='<Doc'
           prdocr=1
           if subs(aaa,15,5)='Order'
              prorder=1
              colr=at('ClientID',aaa)
              ckplr=subs(aaa,colr+len('ClientID')+2,36)
              colr=at('C',ckplr)
              ckplr=subs(ckplr,colr+1)
              kplr=val(ckplr)
              colr=at('TPointID',aaa)
              ckgpr=subs(aaa,colr+len('TPointID')+2,36)
              colr=at('C',ckgpr)
              ckgpr=subs(ckgpr,colr+1)
              kgpr=val(ckgpr)
              colr=at('PmntType',aaa)
              ckopr=subs(aaa,colr+len('PmntType')+2,3)
              kopr=val(ckopr)
              sele lrs1
              netadd()
              netrepl('ttn,vo,kop,kpl,kgp,kta,ddc,tdc','ttnr,9,kopr,kplr,kgpr,ktar,date(),time()')
           else
              prorder=0
           endif
      case subs(aaa,1,5)='</Doc"'
           prdocr=0
           if prorder=1
              prorder=0
              ttnr=ttn+1
           endif
      case subs(aaa,1,5)='<Attr'
           if prorder=1
           endif
      case subs(aaa,1,5)='<Line'
           if prorder=1
              colr=at('GdsID',aaa)
              cmntovr=subs(aaa,colr+len('GdsID')+2,36)
              colr=at('A',cmntovr)
              cmntovr=subs(cmntovr,colr+1)
              mntovr=val(cmntovr)

              colr=at('Amnt',aaa)+len('Amnt')+2
              ckvpr=''
              for i=colr to len(aaa)
                  bbb=subs(aaa,i,1)
                  if bbb='"'
                     exit
                  else
                     ckvpr=ckvpr+bbb
                  endif
              next
              kvpr=val(ckvpr)

              colr=at('Price',aaa)+len('Price')+2
              czenr=''
              for i=colr to len(aaa)
                  bbb=subs(aaa,i,1)
                  if bbb='"'
                     exit
                  else
                     czenr=czenr+bbb
                  endif
              next
              zenr=val(czenr)

              sele lrs2
              netadd()
              netrepl('ttn,mntov,kvp,zen','ttnr,mntovr,kvpr,zenr',)
           endif
   endc
endd
fclose(hzvr)
clea
nuse('lrs1')
nuse('lrs2')
retu

rs2vidr=1
apcenr=0
kopr=160
prZen2r=0
prNacr=0
qr=mod(kopr,100)
if !inikop(gnD0k1,gnVu,gnVo,qr)
   nuse()
   retu
endif
sklr=gnSkl
if select('fttn')#0
   sele fttn
   use
endif
crtt('fttn','f:npp c:n(2) f:mntov c:n(7) f:kvp c:n(12,3) f:ttn c:n(6)')
sele 0
use fttn excl
inde on str(npp,2) tag t1
adir(gcPath_pm+"z*.dbf",az)
for i=1 to len(az)
    fff=lower(az[i])
    kkk=lower(subs(az[i],1,len(az[i])-4))
    kplr=val(strtran(kkk,'z',''))
    nkklr=kplr
    ?str(kplr,7)+' '+getfield('t1','kplr','kln','nkl')
    * Признак наличия договорных условий
    sele klndog
    netseek('t1','kplr')
    nnzr=str(ndog,6)
    dnzr=dtdogb
    if kplr=20034
       tarar=0
    else
       tarar=1
    endif
*    sele tara
*    if netseek('t1','kplr').and.ddog<=dvpr.and.!empty(ddog).and.pd=0
*       tarar:=1
*    else
*       tarar:=0
*    endif
    if tarar=0
       pstr=1
    else
       pstr=0
    endif
*    sele kln
*    netseek('t1','kplr')
*    if empty(Dt_End).or.Dt_End<gdTd
*       doguslr=0
*       if empty(Dt_End)
*          wmess('Нет договорных условий',1)
*       else
*          if Dt_End<gdTd
*             wmess('Договорные условия закочились '+dtoc(Dt_End),1)
*          endif
*       endif
*     else
*       doguslr=1
*       pstr=IIF(Kln->Pst_L,0,1)
*    endif
    sele kpl
    netseek('t1','kplr')
    if empty(dtnace).or.dtnace<gdTd
       doguslr=0
       if empty(dtnace)
          wmess('Нет договорных условий',1)
       else
          if dtnace<gdTd
             wmess('Договорные условия закочились '+dtoc(dtnace),1)
          endif
       endif
     else
       doguslr=1
       pstr=pst
    endif
    sele fttn
    zap
    sele 0
    use &kkk alias in
    do while !eof()
       nppr=1
       mntovr=mntov
       kg_r=int(mntovr/10000)
       if gnEnt=13
          if kg_r=350.or.kg_r=351.or.kg_r=353
             sele in
             skip
             loop
          endif
       endif
       if gnEnt=16
          if !(kg_r=350.or.kg_r=351.or.kg_r=353)
             sele in
             skip
             loop
          endif
       endif
       if kg_r=350.or.kg_r=351.or.kg_r=353
          nppr=2 && Табак
       endif
       tgrpr=getfield('t1','kg_r','cgrp','tgrp')
       if tgrpr=1
          nppr=3 && Алкоголь
       endif
       kvpr=kvp
       sele tovm
       if netseek('t1','gnSkl,mntovr')
          if osv>0.or.osvo>0
             if kvpr>osv+osvo
                kvpr=osv+osvo
             endif
             sele fttn
             appe blank
             repl mntov with mntovr,kvp with kvpr,npp with nppr
          endif
       endif
       sele in
       skip
    endd
    sele in
    use
*    erase (fff)
    * Формирование документов по клиенту
    sele fttn
    go top
    npp_rr=0
    ttnr=0
    do while !eof()
       nppr=npp
       mntovr=mntov
       kvpr=kvp
       kol_mr=kvpr

       store 0 to zenr,zenpr,prZenr,prZenpr,;
               bzenr,bzenpr,prBZenr,prBZenpr,;
               xzenr,xzenpr,prXZenr,prXZenpr,MZenr,optr

       if nppr#npp_rr
          sele rs1
          dbunlock()
          sele cskl
          netseek('t1','gnSk')
          if foun()
             reclock()
             ttnr=ttn
             if ttn>999999
                netrepl('ttn','ttn+1')
             else
                netrepl('ttn','1')
             endif
          endif
          if ttnr#0
             sele rs1
             if !netseek('t1','ttnr')
                dtr=date()
                tmr=time()
                netadd()
                netrepl('ttn,skl,kpl,vo,kop,nkkl,nnz,dnz,kopi,ddc,tdc,dvp',;
                'ttnr,gnSkl,kplr,gnVo,kopr,nkklr,nnzr,dnzr,kopr,dtr,tmr,dtr',1)
             endif
          endif
          npp_rr=nppr
       endif
       if ttnr#0
*wmess('aaa',0)
          rs2mins(0,1)
       endif
       sele fttn
       repl ttn with ttnr
       skip
       loop
    endd
next

sele fttn
use
*erase fttn.dbf
*erase fttn.cdx
*wmess('Ok')
nuse()
retu
