#include "common.ch"
#include "inkey.ch"
STATIC kkl_store
clodkp=setcolor('g/n,n/g')
save scree to scodkp
clea

store 0 to kklr, mnr1,kop_rr //, kkl_store
store '' to nklr
IF !ISNIL(kkl_store);  kklr:=kkl_store; ENDIF

netUse('dkkln')
netUse('dknap')
netUse('kln')
netUse('klndog')
netuse('bs')
netuse('dokk')
netuse('doks')
netuse('dokz')
netuse('mfochk')
netuse('banks')
netuse('cskl')
netuse('s_tag')

do while .t.
  clea
  //kklr=0

  IF !ISNIL(kkl_store)
    kklr:=kkl_store
  ENDIF

  @ 0,1 say 'Код клиента' get kklr pict '@K 9999999'
  read
  if lastkey()=K_ESC
     exit
  endif
  if kklr=0
     kklr=slct_kl(10,1,12)
   endif
   if kklr=0
      loop
   endif
   kkl_store:=kklr
   pathdebr=gcPath_ew+'deb\s361001\'
   if file(pathdebr+'pdeb.dbf')
      dflr=filedate(pathdebr+'pdeb.dbf')
      tflr=filetime(pathdebr+'pdeb.dbf')
      sele 0
      use (pathdebr+'pdeb')
      locate for kkl=kklr
      if found()
         dzr=dz
         kzr=kz
         pdzr=pdz
         pdz1r=pdz1
         pdz3r=pdz3
      else
         dzr=0
         kzr=0
         pdzr=0
         pdz1r=0
         pdz3r=0
      endif
      use
   else
      dflr=ctod('')
      tflr=space(8)
      dzr=0
      kzr=0
      pdzr=0
      pdz1r=0
      pdz3r=0
   endif
   @ 16,1 say 'Товар 361001 актуально на:'+dtoc(dflr)+' '+tflr
   @ 17,1 say 'Дебеторская задолж  '+str(dzr,10,2)+' Кредиторская задолж '+str(kzr,10,2)
   @ 18,1 say ' >7дн  '+str(pdzr,10,2)+' >14дн  '+str(pdz1r,10,2)+' >21дн  '+str(pdz3r,10,2)
   pathdebr=gcPath_ew+'deb\s361002\'
   if file(pathdebr+'pdeb.dbf')
      dflr=filedate(pathdebr+'pdeb.dbf')
      tflr=filetime(pathdebr+'pdeb.dbf')
      sele 0
      use (pathdebr+'pdeb')
      locate for kkl=kklr
      if found()
         dzr=dz
         kzr=kz
         pdzr=pdz
         pdz1r=pdz1
         pdz3r=pdz3
      else
         dzr=0
         kzr=0
         pdzr=0
         pdz1r=0
         pdz3r=0
      endif
      use
   else
      dflr=ctod('')
      tflr=space(8)
      dzr=0
      kzr=0
      pdzr=0
      pdz1r=0
      pdz3r=0
   endif
   @ 19,1 say 'Тара 361002 актуально на:'+dtoc(dflr)+' '+tflr
   @ 20,1 say 'Дебеторская задолж  '+str(dzr,10,2)+' Кредиторская задолж '+str(kzr,10,2)
   @ 21,1 say ' >7дн  '+str(pdzr,10,2)+' >14дн  '+str(pdz1r,10,2)+' >21дн  '+str(pdz3r,10,2)
   netuse('dknap') // Добавлено
   netuse('dkkln') // Добавлено
   if gnEnt=21.and.gnArm=2
      sele dokk
      sum bs_s to nds_kr for kkl=kklr.and.bs_k=641002
      @ 22,1 say 'Кр 641002'+' '+str(nds_kr,10,2)
   endif

   sele dkkln
   if select('ldkkln')#0
      sele ldkkln
      use
   endif
   sele dkkln
   netseek('t1','kklr')
   copy to ldkkln while kkl=kklr
   sele 0
   use ldkkln excl
   repl all dp with 0,kp with 0
   go top
   store 0 to dnr,knr,dbr,krr,dbkr,krkr,sumr
   do while !eof()
      sumr=dn-kn+db-kr
      if sumr>0
         repl dp with sumr
      endif
      if sumr<0
         repl kp with abs(sumr)
      endif
      dnr=dnr+dn
      knr=knr+kn
      dbr=dbr+db
      krr=krr+kr
      skip
   enddo
   aa=dn
   sumr=dnr-knr+dbr-krr
   if sumr>0
      dbkr=sumr
   endif
   if sumr<0
      krkr=abs(sumr)
   endif
   sumr=dnr-knr
   if sumr>0
      dnr=sumr
      knr=0
   endif
   if sumr<0
      knr=abs(sumr)
      dnr=0
   endif
   @ 14,0 say space(80) color 'n/w'
   //   @ 14,1 say 'Итого'+space(5)+'│'+str(dnr,10,2)+'│'+str(knr,10,2)+'│'+str(dbr,10,2)+'│'+str(krr,10,2)+'│'+str(dbkr,10,2)+'│'+str(krkr,10,2)+'│' color 'n/w'
   @ 14,1 say 'Итого  '+'│'+str(dnr,10,2)+'│'+str(knr,10,2)+'│'+str(dbr,12,2)+'│'+str(krr,12,2)+'│'+str(dbkr,10,2)+'│'+str(krkr,10,2)+'│' color 'n/w'
   sele kln
   if !netseek('t1','kklr')
      save scre to scdkln
      mess('Нет клиента в справочнике',1)
      rest scre from scdkln
      loop
   endif
   nklr=alltrim(nkl)
   adrr=adr
   tlfr=tlf
   nnr=nn
   nsvr=nsv
   kkl1r=kkl1
   sele klndog
   if netseek('t1','kklr,7')
      ndogr=ndog
      dtdogbr=dtdogb
      dtdoger=dtdoge
   else
      ndogr=0
      dtdogbr=ctod('')
      dtdoger=ctod('')
   endif
   @ 0,20 say ' '+'Договор '+iif(ndogr#0,str(ndogr,6),space(6))+' c '+dtoc(dtdogbr)+' по '+dtoc(dtdoger)
   @ 1,1 Say 'Клиент '+str(kkl1r,8)+'('+str(kklr,7)+') '+nklr
   @ 2,1 Say 'Адрес   '+alltrim(adrr)
   @ 2,col()+1 Say 'Телефон '+tlfr
   @ 3,1 Say 'Налог.N '+str(nnr,14)
   @ 3,col()+1 Say 'Сертиф. '+nsvr
   esc_r=0
   set cent off
   do while esc_r=0
      sele ldkkln
      go top
      foot('ENTER,F3,F4,F5,F6,F7','Проводки,Банк,Товар подтв,Товар вып,Печать,Докум')
*      rcdklnr=slcf('ldkkln',4,,5,,"e:bs h:'Счет' c:n(6) e:skl h:'Скл.' c:n(4) e:dn h:'Дб на нач.' c:n(10,2) e:kn h:'Кр на нач.' c:n(10,2) e:db h:'Дебет' c:n(10,2) e:kr h:'Кредит' c:n(10,2) e:dp h:'Дб на кон' c:n(10,2) e:kp h:'Кр на кон' c:n(10,2)",,,,'kkl=kklr')
      rcdklnr=slcf('ldkkln',4,,5,,"e:bs h:'Счет' c:n(7) e:dn h:'Дб на нач.' c:n(10,2) e:kn h:'Кр на нач.' c:n(10,2) e:db h:'Дебет' c:n(12,2) e:kr h:'Кредит' c:n(12,2) e:dp h:'Дб на кон' c:n(10,2) e:kp h:'Кр на кон' c:n(10,2)",,,,'kkl=kklr')
      sele ldkkln
      go rcdklnr
      dn_r=dn
      kn_r=kn
      db_r=db
      kr_r=kr
      dk_r=dp
      kk_r=kp
      bsr=bs
      sklr=skl
      do case
         case lastkey()=13
              sele dokk
              set orde to tag t10
              if netseek('t10','kklr')
                 if gnArm=2
                    rcdokkr=slcf('dokk',4,,15,,"e:mn h:'Маш.N' c:n(6) e:rnd h:'Рег.N' c:n(6) e:nplp h:'NПлат' c:n(6) e:rn h:'N пров' c:n(6) e:bs_d h:'Дб' c:n(6) e:bs_k h:'Кр' c:n(6) e:bs_s h:'Сумма' c:n(10,2) e:ddk h:'Дата' c:d(10) e:skl h:'Скл' c:n(4) e:sk h:'Sk' c:n(3) e:kop h:'КОП' c:n(4) e:ksz h:'СЗ' c:n(2)",,,,;
                    'kkl=kklr','(bs_d=bsr.or.bs_k=bsr).and.!prc')
                 else
                    rcdokkr=slcf('dokk',4,,15,,"e:rnd h:'Рег.N' c:n(6) e:iif(dokk->bs_k=bsr,bs_d,bs_k) h:'Дб' c:n(6) e:iif(dokk->bs_k=bsr,getfield('t1','dokk->bs_d','bs','nbs'),getfield('t1','dokk->bs_k','bs','nbs')) h:'Счет' c:c(20) e:bs_s h:'Сумма' c:n(10,2) e:ddk h:'Дата' c:d(10) e:getfield('t1','dokk->mn,dokk->rnd','doks','osn') h:'Супервайзер' c:c(15)",,,,;
                    'kkl=kklr','(bs_d=bsr.or.bs_k=bsr).and.!prc.and.rnd#0')
                 endif
                IF lastkey()=-32 // просмотреть все ALT-F3
                 netseek('t10','kklr')
                 rcdokkr=slcf('dokk',4,,15,,;
                 "e:TRANSFORM(prc,[Y]) h:' ' c:c(1) "+;
                 "e:kg   h:'КТО'        c:n(4,0) "+;
                 "e:mn h:'Маш.N' c:n(6) "+;
                 "e:rnd h:'Рег.N' c:n(6) "+;
                 "e:rn h:'N док.' c:n(6) "+;
                 "e:bs_d h:'Дб' c:n(6) "+;
                 "e:bs_k h:'Кр' c:n(6) "+;
                 "e:bs_s h:'Сумма' c:n(10,2) "+;
                 "e:ddk h:'Дата' c:d(10) "+;
                 "e:skl h:'Скл' c:n(4) "+;
                 "e:sk h:'Sk' c:n(3) "+;
                 "e:kop h:'КОП' c:n(4) "+;
                 "e:ksz h:'СЗ' c:n(2)",,,,;
                 'kkl=kklr','(bs_d=bsr.or.bs_k=bsr)')

                ENDIF
              endif
         case lastkey()=-3
              tovar()
         case lastkey()=-4
              tovarv()
         case lastkey()=-5
              kop_rr=0
              cldoks=setcolor('n/w,n/bg')
              wdoks=wopen(8,20,10,60)
              wbox(1)
              @ 0,1 say 'Код операции' get kop_rr pict '999'
              @ 0,col()+1 say '0-Все'
              read
              wclose(wdoks)
              setcolor(cldoks)
              tovarv(1)
              tovar(1)
         case lastkey()=-6
              kklob()
         case lastkey()=K_ESC
              esc_r=1
         case lastkey()=K_F3 // Банк
              klbank()
*         case lastkey()=-6 // Деб
*              debone(kklr)
*              sele 0
*              use deb
*              kzr=kz
*              dzr=dz
*              pdzr=pdz
*              pdz1r=pdz1
*              pdz3r=pdz3
*              set cent on
*              @ 16,1 say dtoc(date())+' '+time()
*              @ 17,1 say 'Кредиторская задолженность '+str(kzr,10,2)
*              @ 18,1 say 'Дебеторская задолженность  '+str(dzr,10,2)
*              @ 19,1 say ' >7дн  '+str(pdzr,10,2)+' >14дн  '+str(pdz1r,10,2)+' >21дн  '+str(pdz3r,10,2)
*              use
      endc
   enddo
enddo
set cent on
if select('ldkkln')#0
   sele ldkkln
   use
   erase ldkkln.dbf
endif
nuse()
rest scre from scodkp
setcolor(clodkp)

func tovar(p2)
netuse('cskl')
crtt('ldokk','f:sk c:n(3) f:ttn c:n(6) f:sdv c:n(10,2) f:mnp c:n(6) f:naid c:c(10) f:kop c:n(3) f:ddk  c:d(10) f:nnz c:c(9) f:dop c:d(10) f:fio c:c(20) f:sdv2 c:n(10,2) f:sdv3 c:n(10,2) f:nkkl c:n(7) f:ttn1c c:c(9) f:kta c:n(4) f:ktas c:n(4)')
sele 0
use ldokk
inde on str(sk,3)+str(ttn,6) tag t1
inde on fio+str(sk,3)+str(ttn,6) tag t2
set orde to tag t1
sele dokk
*set order to tag t5
set order to tag t10
go top
rnr=0
mnr1=0
mnpr=0
skr=0
*netseek('t5','kklr,mnr1')
netseek('t10','kklr')
save scre to sctovar
set cons on
wmess('Подтвержденный...')
set cons off
*do while kkl=kklr .and. mn=0 //   !eof()
do while kkl=kklr
   if mn#0
      skip
      loop
   endif
   sele dokk
   if prc
      skip
      loop
   endif
   if mn#0
      skip
      loop
   endif
   if kkl=447126.and.mnp=0.and.rn=630006
      a=1
   endif
   if bs_d=99.or.bs_k=99
      skip
      loop
   endif
   if !(mn=0.and.kkl=kklr.and.(bs_d=bsr.or.bs_k=bsr))
      skip
      loop
   endif
   skr=sk
   rnr=rn
   sele ldokk
*   if rnr#rn.or.(rnr=rn .and. mnpr#mnp).or.(rnr=rn .and. skr#sk)
   if !netseek('t1','skr,rnr')
      sele dokk
      mnpr=mnp
      kopr=kop
      if kop_rr#0
         if kopr#kop_rr
            skip
            loop
         endif
      endif
      ddkr=ddk
      dopr=ctod('')
      ktasr=ktas
      sele ldokk
      appe blank
      repl sk with skr,ttn with rnr,mnp with mnpr,kop with kopr,ddk with ddkr,ktas with ktasr
      if mnpr=0
         repl naid with 'Расход'
      else
         repl naid with 'Приход'
      endif
   endif
   sele dokk
   skip
enddo
sele ldokk
go top
sk_r=0
do while !eof()
   if sk#sk_r
      skr=sk
      nuse('rs1')
      nuse('rs3')
      nuse('pr1')
      path_tr=getfield('t1','skr','cskl','path')
      pathr=gcPath_d+alltrim(path_tr)
      if !netfile('rs1',1)
         sele ldokk
         skip
         loop
      endif
      netuse('rs1',,,1)
      netuse('rs3',,,1)
      netuse('pr1',,,1)
   endif
   sele ldokk
   ttnr=ttn
   ttn1cr=space(9)
   mnpr=mnp
   dopr=ctod('')
   store 0 to sdvr,sdv2r,sdv3r,ktar,nkklr
   store '' to nnzr,fior
   if mnpr=0
      sele rs1
      if netseek('t1','ttnr')
         sdvr=sdv
         nnzr=nnz
         dopr=dop
         ktar=kta
         ktasr=ktas
         if fieldpos('nkkl')#0
            nkklr=nkkl
         else
            nkklr=0
         endif
         if nkklr=kklr
            nkklr=0
         endif
         if fieldpos('ttn1c')#0
            ttn1cr=ttn1c
         else
            ttn1cr=space(9)
         endif
         fior=getfield('t1','ktar','s_tag','fio')
         sdv2r=getfield('t1','ttnr,90','rs3','bssf')
         sdv3r=getfield('t1','ttnr,90','rs3','xssf')
      endif
   else
      ttn1cr=space(9)
      sele pr1
      if netseek('t1','ttnr')
         sdvr=sdv
         nnzr=nnz
         ktar=0
         ktasr=0
         fior=''
      endif
   endif
   sele ldokk
   repl sdv with sdvr,nnz with nnzr,dop with dopr,fio with fior,ktas with ktasr,;
        sdv2 with sdv2r,sdv3 with sdv3r,nkkl with nkklr,ttn1c  with ttn1cr,kta with ktar
   if sdv=0
      netdel()
   endif
   sele ldokk
   skip
endd
nuse('rs1')
nuse('rs3')
nuse('pr1')
rest scre from sctovar
ccp=1
do while .t.
sele ldokk
set orde to tag t2
go top
if empty(p2)
   @ MAXROW()-1,5  prompt' ПРОСМОТР '
   @ MAXROW()-1,25 prompt'  ПЕЧАТЬ  '
   menu to ccp
   if lastkey()=K_ESC
      exit
   endif
else
   ccp=2
endif
   if ccp=1
      sele ldokk
      go top
      if gnArm=2
         slcf('ldokk',,,,,"e:sk h:'SK' c:n(3) e:getfield('t1','ldokk->sk','cskl','nskl') h:'Наименование' c:c(19) e:ttn h:'Докум' c:n(6) e:dop h:'Дата отгр.' c:d(10) e:ddk h:'Дата подтв' c:d(10) e:sdv h:'Сумма' c:n(10,2) e:naid h:'Документ'  c:c(10) e:kop h:'КОП' c:n(3)")
      else
         if month(gdTd)=12.and.year(gdTd)=2005
            if kklr=20034.or.kklr=20540
               slcf('ldokk',,,,,"e:sk h:'SK' c:n(3) e:ttn h:'Докум' c:n(6) e:nkkl h:'Клиент' c:n(7) e:dop h:'Дата отгр.' c:d(8) e:ddk h:'Дата подтв' c:d(8) e:sdv h:'Сумма' c:n(10,2) e:sdv2 h:'Сумма2' c:n(10,2) e:naid h:'Д'  c:c(1) e:kop h:'КОП' c:n(3) e:kta h:'KTA' c:n(4) e:ttn1c h:'TTN1C' c:c(9)")
            else
               slcf('ldokk',,,,,"e:sk h:'SK' c:n(3) e:ttn h:'Докум' c:n(6) e:dop h:'Дата отгр.' c:d(8) e:ddk h:'Дата подтв' c:d(8) e:sdv h:'Сумма' c:n(10,2) e:sdv2 h:'Сумма2' c:n(10,2) e:naid h:'Д'  c:c(1) e:kop h:'КОП' c:n(3)  e:kta h:'KTA' c:n(4) e:ttn1c h:'TTN1C' c:c(9)")
            endif
         else
            if kklr=20034.or.kklr=20540
               slcf('ldokk',,,,,"e:sk h:'SK' c:n(3) e:ttn h:'Докум' c:n(6) e:nkkl h:'Клиент' c:n(7) e:dop h:'Дата отгр.' c:d(8) e:ddk h:'Дата подтв' c:d(8) e:sdv h:'Сумма' c:n(10,2) e:sdv2 h:'Сумма2' c:n(10,2) e:naid h:'Д'  c:c(1) e:kop h:'КОП' c:n(3) e:fio h:'Агент' c:c(14)")
            else
               slcf('ldokk',,,,,"e:sk h:'SK' c:n(3) e:ttn h:'Докум' c:n(6) e:dop h:'Дата отгр.' c:d(8) e:ddk h:'Дата подтв' c:d(8) e:sdv h:'Сумма' c:n(10,2) e:sdv2 h:'Сумма2' c:n(10,2) e:naid h:'Д'  c:c(1) e:kop h:'КОП' c:n(3) e:fio h:'Агент' c:c(14)")
            endif
         endif
      endif
   else
      if empty(p2)
         vedprn(1)
      else
         vedprn(5)
         exit
      endif
   endif
enddo
rest scre from sctovar
if select('ldokk')#0
   sele ldokk
   use
endif
erase ldokk.dbf
erase ldokk.cdx
retu .t.


proc tovarv(p2)
save scre to sctovar
netuse('cskl')
crtt('ldokk','f:sk c:n(3) f:ttn c:n(6) f:sdv c:n(10,2) f:mnp c:n(6) f:naid c:c(10) f:kop c:n(3) f:dvp  c:d(10) f:dot c:d(10) f:dop c:d(10) f:fio c:c(20) f:sdv2 c:n(10,2) f:sdv3 c:n(10,2) f:nkkl c:n(7) f:ttn1c c:c(9) f:kta c:n(4) f:ktas c:n(4)')
sele 0
use ldokk
inde on str(sk,3)+str(ttn,6) tag t1
inde on fio+str(sk,3)+str(ttn,6) tag t2
set orde to tag t1
sele cskl
go top
set cons on
wmess('Выписанный...')
set cons off
do while !eof()
   sele cskl
   if ent#gnEnt.or.tpstpok#0.or.merch#0.or.arnd#0
      skip
      loop
   endif
   skr=sk
   pathr=gcPath_d+alltrim(path)
   if !file(pathr+'tprds01.dbf')
      sele cskl
      skip
      loop
   endif
   netuse('rs1',,,1)
   netuse('rs3',,,1)
   sele rs1
   set order to tag t2
   go top
*   netseek('t2','kklr')
   do while !eof() // kpl=kklr
     if prz=1
        skip
        loop
     endif
     if kop_rr#0
        if kop#kop_rr
           skip
           loop
        endif
     endif
     if kpl#kklr
        if fieldpos('nkkl')#0
           if nkkl#kklr
              skip
              loop
           endif
        else
           skip
           loop
        endif
     endif
     ttnr=ttn
     if fieldpos('ttn1c')#0
        ttn1cr=ttn1c
     else
        ttn1cr=space(9)
     endif
     sdvr=sdv
     if sdvr=0
        skip
        loop
     endif
     kopr=kop
     naidr='Расход'
     dvpr=dvp
     dotr=dot
     dopr=dop
     ktar=kta
     ktasr=ktas
     kplr=kpl
     if fieldpos('nkkl')#0
        nkklr=nkkl
     else
        nkklr=0
     endif
     if nkklr=kklr.and.nkklr#kplr
        nkklr=kplr
     endif
     if nkklr=kklr.and.nkklr=kplr
        nkklr=0
     endif
     fior=getfield('t1','ktar','s_tag','fio')
     sdv2r=getfield('t1','ttnr,90','rs3','bssf')
     sdv3r=getfield('t1','ttnr,90','rs3','xssf')
     sele ldokk
     appe blank
     repl sk with skr,ttn with ttnr,sdv with sdvr,dvp with dvpr,ktas with ktasr,;
          dot with dotr,naid with naidr,kop with kopr,dop with dopr,fio with fior,;
          sdv2 with sdv2r,sdv3 with sdv3r,nkkl with nkklr,ttn1c with ttn1cr,kta with ktar
     sele rs1
     skip
   endd
   nuse('rs1')
   nuse('rs3')

   netuse('pr1',,,1)
   sele pr1
   go top
   set order to tag t3
   netseek('t3','0,kklr')
   do while otv=0.and.kps=kklr  //   !eof()
     if kps#kklr.or.prz=1
        skip
        loop
     endif
     ttnr=nd
     mnpr=mn
     sdvr=sdv
     if sdvr=0
        skip
        loop
     endif
     kopr=kop
     naidr='Приход'
     dvpr=dvp
     sele ldokk
     appe blank
     repl sk with skr,ttn with ttnr,mnp with mnpr,sdv with sdvr,dvp with dvpr,;
          naid with naidr,kop with kopr
     sele pr1
     skip
   endd
   nuse('pr1')

   sele cskl
   skip
endd
nuse('rs1')
nuse('pr1')

rest scre from sctovar
ccp=1
do while .t.
   sele ldokk
   set orde to tag t2
   go top
   if empty(p2)
      @ MAXROW()-1,5  prompt' ПРОСМОТР '
      @ MAXROW()-1,col()+1 prompt'  ПЕЧАТЬ  '
      menu to ccp
      if lastkey()=K_ESC
         exit
      endif
   else
      @ MAXROW()-1,5  prompt' ПРОСМОТР '
      @ MAXROW()-1,col()+1 prompt'  ПЕЧАТЬ  '
      @ MAXROW()-1,col()+1 prompt' C ПЕЧАТЬ  '
      menu to ccp
      if lastkey()=K_ESC
         exit
      endif
   endif
   if ccp=1
      sele ldokk
      go top
      if gnArm=2
         slcf('ldokk',,,,,"e:sk h:'SK' c:n(3) e:getfield('t1','ldokk->sk','cskl','nskl') h:'Наим' c:c(18) e:ttn h:'Докум' c:n(6) e:dvp h:'Дата вып' c:d(10) e:dop h:'Дата от.' c:d(10) e:sdv h:'Сумма' c:n(10,2) e:naid h:'Докум'  c:c(6) e:kop h:'КОП' c:n(3)")
      else
*         slcf('ldokk',,,,,"e:sk h:'SK' c:n(3) e:getfield('t1','ldokk->sk','cskl','nskl') h:'Наим' c:c(8) e:ttn h:'Докум' c:n(6) e:dvp h:'Дата вып' c:d(10) e:dop h:'Дата от.' c:d(10) e:sdv h:'Сумма' c:n(10,2) e:naid h:'Докум'  c:c(6) e:kop h:'КОП' c:n(3) e:fio h:'Агент' c:c(14)")
*         if kklr=20034.or.kklr=20540
         if gnArm=3
            if month(gdTd)=12.and.year(gdTd)=2005
               slcf('ldokk',,,,,"e:sk h:'SK' c:n(3) e:ttn h:'Докум' c:n(6) e:nkkl h:'Клиент' c:n(7) e:dvp h:'Дата вып' c:d(8) e:dop h:'Дата от.' c:d(8) e:sdv h:'Сумма' c:n(10,2) e:sdv2 h:'Сумма2' c:n(10,2) e:naid h:'Д'  c:c(1) e:kop h:'КОП' c:n(3)  e:kta h:'KTA' c:n(4) e:ttn1c h:'TTN1C' c:c(9)")
            else
               slcf('ldokk',,,,,"e:sk h:'SK' c:n(3) e:ttn h:'Докум' c:n(6) e:nkkl h:'Клиент' c:n(7) e:dvp h:'Дата вып' c:d(8) e:dop h:'Дата от.' c:d(8) e:sdv h:'Сумма' c:n(10,2) e:sdv2 h:'Сумма2' c:n(10,2) e:naid h:'Д'  c:c(1) e:kop h:'КОП' c:n(3) e:fio h:'Агент' c:c(14)")
            endif
         else
            slcf('ldokk',,,,,"e:sk h:'SK' c:n(3) e:ttn h:'Докум' c:n(6) e:dvp h:'Дата вып' c:d(8) e:dop h:'Дата от.' c:d(8) e:sdv h:'Сумма' c:n(10,2) e:sdv2 h:'Сумма2' c:n(10,2) e:naid h:'Д'  c:c(1) e:kop h:'КОП' c:n(3) e:fio h:'Агент' c:c(14)")
         endif
      endif
   else
      if ccp=2
         if empty(p2)
            vedprn(0)
         else
            vedprn(4)
            exit
         endif
      else
         if empty(p2)
            vedprn(0,1)
         else
            vedprn(4,1)
            exit
         endif
      endif
   endif
enddo
rest scre from sctovar
if select('ldokk')#0
   sele ldokk
   use
endif
erase ldokk.dbf
erase ldokk.cdx
retu .t.

proc vedprn
para p1,p2
*p1=1    - Подтвержденный товар
*p1=0    - Выписанный товар
lstr=1
rswr=1
set cons on
wmess(' Вставте лист и нажмите пробел',0)
set cons off
if p1#5
   set cons off
   if gnOut=2
      set print to txt.txt
      set print on
      if empty(gcPrn)
         ??chr(27)+chr(77)+chr(15)
      else
         ??chr(27)+'E'+chr(27)+'&l26a0O'+chr(27)+chr(27)+'(3R'+chr(27)+'(s0p15.00h0s1b4102T'+chr(27)  // Книжная А4
      endif
   else
      if empty(p2)
         set print to lpt1
         set print on
         if empty(gcPrn)
            ??chr(27)+chr(77)+chr(15)
         else
            ??chr(27)+'E'+chr(27)+'&l26a0O'+chr(27)+chr(27)+'(3R'+chr(27)+'(s0p15.00h0s1b4102T'+chr(27)  // Книжная А4
         endif
      else
         set print to lpt2
         set print on
         ??chr(27)+'E'+chr(27)+'&l26a0O'+chr(27)+chr(27)+'(3R'+chr(27)+'(s0p15.00h0s1b4102T'+chr(27)  // Книжная А4
      endif
   endif
endif

if p1=1.or.p1=5
   if p1=5
      ?' '
      ?' '
      ?'┌──────────┬──────────┬─────────┬──────────┬──────────┬──────────┐'
      ?'│ Дебет Н  │ Кредит Н │  Дебет  │  Кредит  │ Дебет К  │ Кредит К │'
      ?'├──────────┼──────────┼─────────┼──────────┼──────────┼──────────┤ '
      ?str(dn_r,10,2)+' '+str(kn_r,10,2)+' '+str(db_r,10,2)+' '+str(kr_r,10,2)+' '+str(dk_r,10,2)+' '+str(kk_r,10,2)
      ?' '
   endif
   ?space(20)+'Ведомость подтвержденного товара'
endif

if p1=0.or.p1=4
   ?space(20)+'Ведомость   выписанного   товара'
endif

rsle1()

if p1#5
   ?'Клиент '+str(kkl1r,8)+'('+str(kklr,7)+') '+nklr
   rsle1()
   ?'Адрес   '+adrr
   rsle1()
   ?'Телефон '+tlfr
   rsle1()
   ?'Налог.N '+str(nnr,14)
   rsle1()
   ?'Сертиф. '+nsvr+space(35)+dtoc(date())+' '+time()
   ?'По счету'+'  '+str(bsr,6)
   rsle1()
endif
if p1=1.or.p1=5
   sh(1)
endif
if p1=0.or.p1=4
   sh(0)
endif
go top
sdvpr=0
sdvrr=0
sdv2pr=0
sdv2rr=0
do while !eof()
   if p1=1.or.p1=5
*      ?str(sk,3)+' '+substr(getfield('t1','ldokk->sk','cskl','nskl'),1,20)+' '+str(ttn,6)+' '+dtoc(dop)+' '+dtoc(ddk)+' '+str(sdv,10,2)+' '+str(sdv2,10,2)+' '+ naid+' '+str(kop,3)+' '+fio
*      ?str(sk,3)+' '+substr(fio,1,20)+' '+str(ttn,6)+' '+dtoc(dop)+' '+dtoc(ddk)+' '+str(sdv,10,2)+' '+str(sdv2,10,2)+' '+ left(naid,1)+' '+str(kop,3)
*      ?' '+substr(fio,1,20)+' '+str(sk,3)+' '+str(ttn,6)+' '+ left(naid,1)+' '+str(kop,3)+' '+dtoc(dop)+' '+dtoc(ddk)+' '+str(sdv,10,2)+' '+str(sdv2,10,2)
      ?' '+substr(fio,1,20)+' '+str(sk,3)+' '+str(ttn,6)+' '+ left(naid,1)+' '+str(kop,3)+' '+dtoc(dop)+' '+dtoc(ddk)+' '+str(sdv,10,2)+' '+ttn1c
   endif
   if p1=0.or.p1=4
*      ?str(sk,3)+' '+substr(getfield('t1','ldokk->sk','cskl','nskl'),1,20)+' '+ str(ttn,6)+' '+dtoc(dvp)+' '+ dtoc(dop)+' '+str(sdv,10,2)+' '+str(sdv2,10,2)+' '+naid+' '+str(kop,3)+' '+fio
*      ?str(sk,3)+' '+substr(fio,1,20)+' '+ str(ttn,6)+' '+dtoc(dvp)+' '+ dtoc(dop)+' '+str(sdv,10,2)+' '+str(sdv2,10,2)+' '+left(naid,1)+' '+str(kop,3)+' '+fio
      ?' '+substr(fio,1,20)+' '+str(sk,3)+' '+str(ttn,6)+' '+ left(naid,1)+' '+str(kop,3)+' '+dtoc(dvp)+' '+dtoc(dop)+' '+str(sdv,10,2)+' '+str(sdv2,10,2)+' '+ttn1c
   endif
   if left(naid,1)='Р'
      sdvrr=sdvrr+sdv
      sdv2rr=sdv2rr+sdv2
   else
      sdvpr=sdvpr+sdv
      sdv2pr=sdv2pr+sdv2
   endif
   rsle1()
   skip
enddo
?' '+'Итого расход'+space(8)+' '+space(3)+' '+space(6)+' '+space(1)+' '+space(3)+' '+space(8)+' '+space(8)+' '+str(sdvrr,10,2)+' '+str(sdv2rr,10,2)
rsle1()
?' '+'Итого приход'+space(8)+' '+space(3)+' '+space(6)+' '+space(1)+' '+space(3)+' '+space(8)+' '+space(8)+' '+str(sdvpr,10,2)+' '+str(sdv2pr,10,2)
rsle1()

if p1=5
   ?' '
   rsle1()

   ?' Проплаты'
   rsle1()
   sele dokk
*   set orde to tag t5
   set orde to tag t10

*   if netseek('t5','kklr')
   if netseek('t10','kklr')
      do while kkl=kklr
         if !(bs_k=bsr.and.prc=.f.).or.bs_d=99.or.bs_k=99
            sele dokk
            skip
            loop
         endif
         if rnd=0
            skip
            loop
         endif
         ktasr=ktas
         if ktasr#0
            nktar=str(ktasr,4)+' '+getfield('t1','ktasr','s_tag','fio')
         else
            osnr=getfield('t1','dokk->mn,dokk->rnd','doks','osn')
            posr=at(':',osnr)
            if posr#0
               ktar=val(subs(osnr,posr+1,3))
               nktar=str(ktar,3)+' '+getfield('t1','ktar','s_tag','fio')
            else
               nktar=osnr
            endif
         endif
         ?str(rnd,6)+' '+str(bs_d,6)+' '+getfield('t1','dokk->bs_d','bs','nbs')+' '+str(bs_s,10,2)+' '+dtoc(ddk)+' '+nktar
         rsle1()
         sele dokk
         skip
      endd
   endif
endif

if p1#4
   eject
/*
set print off
set print to
set devi to screen
*/
   ClosePrintFile()
endif
retu

proc rsle1(p2)
rswr++
if rswr>=60
   rswr=1
   lstr++
   eject
   if p2=nil
*      set devi to scre
*      save scre to scmess
      set cons on
      wmess('Вставте лист и нажмите пробел',0)
      set cons off
*      rest scre from scmess
*      set devi to print
      sh(p1)
   endif
endif
retu

proc sh
para p1
   ?'                                                                        Лист'+str(lstr)
if p1=1
   ?'┌────────────────────┬───┬──────┬─┬───┬────────┬────────┬──────────┬──────────┐'
   ?'│       Агент        │Скл│ Докум│Д│КОП│Дата отг│Дата под│   Сумма  │  Сумма2  │'
   ?'└────────────────────┴───┴──────┴─┴───┴────────┴────────┴──────────┴──────────┘'
else
   ?'┌────────────────────┬───┬──────┬─┬───┬────────┬────────┬──────────┬──────────┐'
   ?'│       Агент        │Скл│ Докум│Д│КОП│Дата вып│Дата отг│   Сумма  │  Сумма2  │'
   ?'└────────────────────┴───┴──────┴─┴───┴────────┴────────┴──────────┴──────────┘'
endif

*if p1=1
*   ?'┌──┬────────────────────┬──────┬──────────┬──────────┬──────────┬──────────┬─┬───┐'
*   ?'│SK│       Агент        │ Докум│Дата отгр.│Дата подтв│   Сумма  │  Сумма2  │Д│КОП│'
*   ?'└──┴────────────────────┴──────┴──────────┴──────────┴──────────┴──────────┴─┴───┘'
*else
*   ?'┌──┬────────────────────┬──────┬──────────┬──────────┬──────────┬──────────┬─┬───┐'
*   ?'│SK│       Агент        │ Докум│Дата вып. │ Дата от. │   Сумма  │  Сумма2  │Д│КОП│'
*   ?'└──┴────────────────────┴──────┴──────────┴──────────┴──────────┴──────────┴─┴───┘'
*endif
return

func vodkp
* Выписаный
* Подтвержденный
* Деньги
retu .t.

func klbank()
crtt('klbank','f:ddc c:d(10) f:mfo c:c(6) f:nmfo c:c(12) f:nplp c:n(6) f:ssd c:n(12,2) f:bosn c:c(100) f:rnd c:n(6)')
sele 0
use klbank excl
inde on dtos(ddc)+str(rnd,6) tag t1
store 0 to ssdor
sele doks
go top
do while !eof()
   if kkl#kklr
      skip
      loop
   endif
   mnr=mn
   ddcr=ddc
   ssdr=ssd
   if fieldpos('bosn')#0
      bosnr=bosn
   else
      bosnr=space(80)
   endif
   nplpr=nplp
   rndr=rnd
   sele dokz
   if !netseek('t2','mnr')
      sele doks
      skip
      loop
   endif
   bsr=bs
   sele mfochk
   if netseek('t1','gnKln_c,bsr')
      mfor=mfo
   else
      sele doks
      skip
      loop
   endif
   cmfor='000'+mfor
   nmfor=getfield('t1','cmfor','banks','otb')
   sele klbank
   loca for ddc=ddcr.and.mfo=mfor.and.rnd=rndr
   if !foun()
      appe blank
      repl ddc with ddcr,mfo with mfor,nmfo with nmfor,rnd with rndr,;
           nplp with nplpr,ssd with ssdr,bosn with bosnr
      ssdor=ssdor+ssdr
   endif
   sele doks
   skip
endd
save scre to scklbank
sele klbank
go top
rcklbankr=recn()
fldnomr=1
do while .t.
   foot('','')
   sele klbank
   go rcklbankr
   rcklbankr=slce('klbank',1,1,18,,"e:ddc h:'Дата' c:d(10) e:nmfo h:'Наименование' c:с(12) e:nplp h:'ПП' c:n(6) e:ssd h:'Сумма' c:n(12,2) e:bosn h:'Основание' c:c(80)",,,,,,,'Банки'+' '+str(ssdor,12,2),0,0)
   if lastkey()=K_ESC
      exit
   endif
   sele klbank
   go rcklbankr
   do case
      case lastkey()=19 // Left
           fldnomr=fldnomr-1
           if fldnomr=0
              fldnomr=1
           endif
      case lastkey()=4 // Right
           fldnomr=fldnomr+1
   endc
endd
rest scre from scklbank
sele klbank
use
erase klbank.dbf
erase klbank.cdx
retu .t.

func odkpg()
netuse('bs')
netuse('kln')
sele dir
copy stru to stemp exte
sele 0
use stemp excl
zap
appe blank
repl field_name with 'BS',;
     field_type with 'C',;
     field_len with 6,;
     field_dec with 0
appe blank
repl field_name with 'NBS',;
     field_type with 'C',;
     field_len with 30,;
     field_dec with 0
for i=1 to 12
    appe blank
    repl field_name with 'DB'+alltrim(str(i,2)),;
         field_type with 'N',;
         field_len with 12,;
         field_dec with 2
    appe blank
    repl field_name with 'KR'+alltrim(str(i,2)),;
         field_type with 'N',;
         field_len with 12,;
         field_dec with 2
    appe blank
    repl field_name with 'nprd'+alltrim(str(i,2)),;
         field_type with 'C',;
         field_len with 6,;
         field_dec with 0
next
use
create odkpg from stemp
use
erase stemp.dbf
sele 0
use odkpg excl
inde on bs tag t1

if month(gdTd)=12
   gg1=year(gdTd)
   gg2=gg1
else
   gg1=year(gdTd)-1
   gg2=year(gdTd)
endif


do while .t.
   sele odkpg
   zap
   clea
   kklr=0
   @ 0,1 say 'Код клиента' get kklr pict '9999999'
   read
   if lastkey()=K_ESC
      exit
   endif
   if kklr=0
      kklr=slct_kl(10,1,12)
   endif
   if kklr=0
      loop
   endif
   nklr=getfield('t1','kklr','kln','nkl')
   nklr=alltrim(nklr)
   kk=0
   for g=gg1 to gg2
       do case
          case gg1=gg2
               mm1=1
               mm2=12
          case g=gg2
               mm1=1
               mm2=month(gdTd)
          case g=gg1
               mm1=month(gdTd)+1
               mm2=12
       endc
       for m=mm1 to mm2
           kk=kk+1
           nprdr=g*100+m
           cdbr='db'+alltrim(str(kk,2))
           ckrr='kr'+alltrim(str(kk,2))
           cnprdr='nprd'+alltrim(str(kk,2))
           sele odkpg
           loca for bs='ИТОГО:'
           if !foun()
               appe blank
               repl bs with 'ИТОГО:'
           endif
           repl &cnprdr with str(nprdr,6)
           nuse('dkkln')
           nuse('dknap')
           pathr=gcPath_e+'g'+str(g,4)+'\m'+iif(m<10,'0'+str(m,1),str(m,2))+'\bank\'
           if !netfile('dkkln',1)
              loop
           endif
           mess(pathr)
           netuse('dknap',,,1)
           netuse('dkkln',,,1)
           if netseek('t1','kklr')
              do while kkl=kklr
                 bsr=bs
                 dbr=db
                 krr=kr
                 sele odkpg
                 loca for bs=str(bsr,6)
                 if !foun()
                    appe blank
                    repl bs with str(bsr,6)
                 endif
                 repl &cdbr with dbr,;
                      &ckrr with krr,;
                      &cnprdr with str(nprdr,6)
                 sele dkkln
                 skip
              endd
           endif
           nuse('dkkln')
           nuse('dknap')
       next
   next
   sele odkpg
   loca for bs='ИТОГО:'
   rcnr=recn()
   for i=1 to 12
       cdbr='db'+alltrim(str(i,2))
       ckrr='kr'+alltrim(str(i,2))
       cnprdr='nprd'+alltrim(str(i,2))
       go rcnr
       nprdr=&cnprdr
       go top
       store 0 to dbr,krr
       do while !eof()
          if bs#'ИТОГО:'
             dbr=dbr+&cdbr
             krr=krr+&ckrr
             repl &cnprdr with nprdr
          else
             repl &cdbr with dbr,;
                  &ckrr with krr
          endif
          skip
       endd
   next
   clea
   sele odkpg
   go top
   do while !eof()
      if isdigit(subs(bs,1,1))
         bsr=val(bs)
         nbsr=getfield('t1','bsr','bs','nbs')
         sele odkpg
         repl nbs with nbsr
      endif
      sele odkpg
      skip
   endd
   go top
   fldnomr=1
   rcodkpgr=recn()
   do while .t.
      sele odkpg
      go rcodkpgr
*      rcodkpgr=slce('odkpg',,,,,"e:bs h:'СЧЕТ' c:c(6) e:nbs h:'Наименование' c:c(30) e:db1 h:'Дб '+odkpg->nprd1 c:n(12,2) e:kr1 h:'Кр '+odkpg->nprd1 c:n(12,2) e:db2 h:'Дб '+odkpg->nprd2 c:n(12,2) e:kr2 h:'Кр '+odkpg->nprd2 c:n(12,2) e:db3 h:'Дб '+odkpg->nprd3 c:n(12,2) e:kr3 h:'Кр '+odkpg->nprd3 c:n(12,2) e:db4 h:'Дб '+odkpg->nprd4 c:n(12,2) e:kr4 h:'Кр '+odkpg->nprd4 c:n(12,2) e:db5 h:'Дб '+odkpg->nprd5 c:n(12,2) e:kr5 h:'Кр '+odkpg->nprd5 c:n(12,2) e:db6 h:'Дб '+odkpg->nprd6 c:n(12,2) e:kr6 h:'Кр '+odkpg->nprd6 c:n(12,2) e:db7 h:'Дб '+odkpg->nprd7 c:n(12,2) e:kr7 h:'Кр '+odkpg->nprd7 c:n(12,2) e:db8 h:'Дб '+odkpg->nprd8 c:n(12,2) e:kr8 h:'Кр '+odkpg->nprd8 c:n(12,2) e:db9 h:'Дб '+odkpg->nprd9 c:n(12,2) e:kr9 h:'Кр '+odkpg->nprd9 c:n(12,2) e:db10 h:'Дб '+odkpg->nprd10 c:n(12,2) e:kr10 h:'Кр '+odkpg->nprd10 c:n(12,2) e:db11 h:'Дб '+odkpg->nprd11 c:n(12,2) e:kr11 h:'Кр '+odkpg->nprd11 c:n(12,2) e:db12 h:'Дб '+odkpg->nprd12 c:n(12,2) e:kr12 h:'Кр '+odkpg->nprd12 c:n(12,2)",,,,,,,,1,2)
      rcodkpgr=slce('odkpg',1,1,18,,"e:bs h:'СЧЕТ' c:c(6) e:nbs h:'Наименование' c:c(30) e:db1 h:'Дб '+odkpg->nprd1 c:n(12,2) e:kr1 h:'Кр '+odkpg->nprd1 c:n(12,2) e:db2 h:'Дб '+odkpg->nprd2 c:n(12,2) e:kr2 h:'Кр '+odkpg->nprd2 c:n(12,2) e:db3 h:'Дб '+odkpg->nprd3 c:n(12,2) e:kr3 h:'Кр '+odkpg->nprd3 c:n(12,2) e:db4 h:'Дб '+odkpg->nprd4 c:n(12,2) e:kr4 h:'Кр '+odkpg->nprd4 c:n(12,2) e:db5 h:'Дб '+odkpg->nprd5 c:n(12,2) e:kr5 h:'Кр '+odkpg->nprd5 c:n(12,2) e:db6 h:'Дб '+odkpg->nprd6 c:n(12,2) e:kr6 h:'Кр '+odkpg->nprd6 c:n(12,2) e:db7 h:'Дб '+odkpg->nprd7 c:n(12,2) e:kr7 h:'Кр '+odkpg->nprd7 c:n(12,2) e:db8 h:'Дб '+odkpg->nprd8 c:n(12,2) e:kr8 h:'Кр '+odkpg->nprd8 c:n(12,2) e:db9 h:'Дб '+odkpg->nprd9 c:n(12,2) e:kr9 h:'Кр '+odkpg->nprd9 c:n(12,2) e:db10 h:'Дб '+odkpg->nprd10 c:n(12,2) e:kr10 h:'Кр '+odkpg->nprd10 c:n(12,2) e:db11 h:'Дб '+odkpg->nprd11 c:n(12,2) e:kr11 h:'Кр '+odkpg->nprd11 c:n(12,2) e:db12 h:'Дб '+odkpg->nprd12 c:n(12,2) e:kr12 h:'Кр '+odkpg->nprd12 c:n(12,2)",,,,,,,nklr,1,1)
      if lastkey()=K_ESC
         exit
      endif
      go rcodkpgr
      do case
         case lastkey()=19 // Left
              fldnomr=fldnomr-1
              if fldnomr=0
                 fldnomr=1
              endif
         case lastkey()=4 // Right
              fldnomr=fldnomr+1
      endc
   endd
endd
nuse()
nuse('odkpg')
erase odkpg.dbf
erase odkpg.cdx
retu .t.


**************
func kklopl()
**************
clea
netuse('dokz')
netuse('doks')
netuse('dokk')
netuse('kln')
netuse('kpl')
netuse('nap')
netuse('s_tag')
sele dbft
copy stru to skklopl exte
sele 0
use skklopl excl
zap
appe blank
repl field_name with 'BS',;
     field_type with 'N',;
     field_len with 6,;
     field_dec with 0
appe blank
repl field_name with 'KKL',;
     field_type with 'N',;
     field_len with 7,;
     field_dec with 0
appe blank
repl field_name with 'NKL',;
     field_type with 'C',;
     field_len with 40,;
     field_dec with 0
appe blank
repl field_name with 'SSD',;
     field_type with 'N',;
     field_len with 10,;
     field_dec with 2
appe blank
repl field_name with 'RND',;
     field_type with 'N',;
     field_len with 6,;
     field_dec with 0
appe blank
repl field_name with 'DDC',;
     field_type with 'D',;
     field_len with 10,;
     field_dec with 0
appe blank
repl field_name with 'nap',;
     field_type with 'N',;
     field_len with 1,;
     field_dec with 0
appe blank
repl field_name with 'bosn',;
     field_type with 'C',;
     field_len with 100,;
     field_dec with 0
appe blank
repl field_name with 'osn',;
     field_type with 'C',;
     field_len with 20,;
     field_dec with 0
sele nap
go top
do while !eof()
   napr=nap
   nnapr=nnap
   sele skklopl
   appe blank
   repl field_name with 'SM'+str(napr,1),;
        field_type with 'N',;
        field_len with 12,;
        field_dec with 2
   sele nap
   skip
endd
sele skklopl
use
create kklopl from skklopl
use
sele 0
use kklopl excl
inde on str(bs,6)+str(kkl,7)+str(rnd,6) tag t1
store gdTd to ddc1r,ddc2r
bs_r=0
nrzr=0
do while .t.
   cldoks=setcolor('n/w,n/bg')
   wdoks=wopen(8,20,12,60)
   wbox(1)
   @ 0,1 say 'Период с' get ddc1r
   @ 0,col()+1 say 'по' get ddc2r
   @ 1,1 say 'Счет    ' get bs_r pict '999999'
   @ 2,1 say 'Неразн. ' get nrzr pict '9'
   read
   wclose(wdoks)
   setcolor(cldoks)
   if lastkey()=K_ESC
      exit
   endif
   sele kklopl
   zap
   sele dokz
   go top
   do while !eof()
      if !(int(bs/1000)=301.or.int(bs/1000)=311)
         skip
         loop
      endif
      if ddc<ddc1r.or.ddc>ddc2r
         skip
         loop
      endif
      if bs_r#0
         if bs#bs_r
            skip
            loop
         endif
      endif
      mnr=mn
      bsr=bs
      ddcr=ddc
      sele doks
      if netseek('t1','mnr')
         do while mn=mnr
            if prz#0
               skip
               loop
            endif
            if !(prfrm=0.and.getfield('t1','doks->kkl','kpl','tzdoc')#0)
               skip
               loop
            endif
            kklr=kkl
            nklr=getfield('t1','kklr','kln','nkl')
            ssdr=ssd
            napr=nap
            rndr=rnd
            bosnr=bosn
            osnr=osn
            sele kklopl
            appe blank
            repl bs with bsr,;
                 kkl with kklr,;
                 nkl with nklr,;
                 nap with napr,;
                 ssd with ssdr,;
                 rnd with rndr,;
                 ddc with ddcr,;
                 bosn with bosnr,;
                 osn with osnr
            sele dokk
            if netseek('t1','mnr,rndr')
               do while mn=mnr.and.rnd=rndr
                  if bs_k#361001
                     skip
                     loop
                  endif
                  napr=nap
                  smr=bs_s
                  csmr='sm'+str(napr,1)
                  sele kklopl
                  netrepl(csmr,'smr')
                  sele dokk
                  skip
               endd
            endif
            sele doks
            skip
         endd
      endif
      sele dokz
      skip
   endd
   sele kklopl
   go top
   rckor=recn()
   fldnomr=1
   do while .t.
      sele kklopl
      go rckor
      foot('F4,F5','Корр,Печать')
      rckor=slce('kklopl',,,,,"e:kkl h:'Код' c:n(7) e:nkl h:'Наименование' c:c(20) e:nap h:'Н'c:n(1) e:ssd h:'Сумма' c:n(10,2) e:sm0 h:'Сумма0' c:n(10,2) e:sm1 h:'Сумма1' c:n(10,2) e:sm2 h:'Сумма2' c:n(10,2) e:sm3 h:'Сумма3' c:n(10,2) e:bs h:'Счет' c:n(6) e:rnd h:'Рег.N' c:n(6) e:ddc h:'Дата' c:d(10) e:bosn h:'Банк Осн' c:c(100) e:osn h:'Бух Осн' c:c(20)",,,,,"(sm0+sm1+sm2+sm3#0).and.iif(nrzr#0,ssd=sm0,.t.)",,'Оплаты',,1)
      if lastkey()=K_ESC
         exit
      endif
      go rckor
      sm0r=sm0
      sm1r=sm1
      sm2r=sm2
      sm3r=sm3
      ssdr=ssd
      do case
         case lastkey()=19 // Left
              fldnomr=fldnomr-1
              if fldnomr=0
                 fldnomr=1
              endif
         case lastkey()=4 // Right
              fldnomr=fldnomr+1
         case lastkey()=-3
              clcr=setcolor('n/w,n/bg')
              wcr=wopen(8,20,16,60)
              wbox(1)
              @ 0,1 say 'Всего '+' '+str(ssdr,10,2)
              @ 1,1 say 'Сумма0' get sm0r pict '9999999.99'
              @ 1,col()+1 say 'Неопределено'
              @ 2,1 say 'Сумма1' get sm1r pict '9999999.99'
              @ 2,col()+1 say 'Гастрономия'
              @ 3,1 say 'Сумма2' get sm2r pict '9999999.99'
              @ 3,col()+1 say 'Славутич'
              @ 4,1 say 'Сумма3' get sm3r pict '9999999.99'
              @ 4,col()+1 say 'Козацкая розвага'
              read
              wclose(wcr)
              setcolor(clcr)
              if lastkey()=13
                 if ssdr#sm0r+sm1r+sm2r+sm3r
                    wmess('Несовпадение сумм',2)
                 else
                    netrepl('sm0,sm1,sm2,sm3','sm0r,sm1r,sm2r,sm3r')
                 endif
              endif
         case lastkey()=-4 // Печать
              prnopl()
      endc
   endd
endd
nuse()
nuse('kklopl')
retu .t.

**************
func prnopl()
**************
if gnOut=1
   alpt={'lpt1','lpt2','lpt3','Файл'}
   vlpt=alert('Принтер',alpt)
   if lastkey()=K_ESC
      retu .t.
   endif
   if vlpt<4
      cvlptr='lpt'+str(vlpt,1)
      set prin to &cvlptr
   else
      set prin to kklopl.txt
   endif
else
   set prin to kklopl.txt
endif
set cons off
set prin on
if !empty(gcPrn)
   ?chr(27)+'E'+chr(27)+'&l1h26a0O'+chr(27)+chr(27)+'(3R'+chr(27)+'(s0p21.00h0s0b4099T'+chr(27)  // Книжная А4
else
   ?chr(27)+chr(77)+chr(15)
endif

sele kklopl
go top
?'┌──────┬───────┬────────────────────┬──────────┬────────────┬────────────┬────────────┬────────────┬──────┐'
?'│'+' Счет '+'│'+'  Код  '+'│'+'    Наименование    '+'│'+'   Дата   '+'│'+'Неопределено'+'│'+'Гастрономия '+'│'+'  Славутич  '+'│'+'Коз розвага '+'│'+'Рег.N '+'│'
?'├──────┼───────┼────────────────────┼──────────┼────────────┼────────────┼────────────┼────────────┼──────┤'

do while !eof()
   if sm0+sm1+sm2+sm3=0
      skip
      loop
   endif
   if bs_r#0
      if bs#bs_r
         skip
         loop
      endif
   endif
   ?'│'+str(bs,6)+'│'+str(kkl,7)+'│'+subs(nkl,1,20)+'│'+dtoc(ddc)+'│'+str(sm0,12,2)+'│'+str(sm1,12,2)+'│'+str(sm2,12,2)+'│'+str(sm3,12,2) +'│'+str(rnd,6)+'│'
   skip
endd

set prin off
set cons on
set prin to txt.txt
retu .t.


func cghj()
sele doks
set orde to tag t1
if netseek('t1','mnr')
   do while mn=mnr
      kklr=kkl
      nklr=getfield('t1','kklr','kln','nkl')
      ssdr=ssd
      ddcr=ddc
      sele doks
      skip
   endd
endif

sele doks
if netseek('t1','mnr')
   rcdoksr=recn()
   fldnomr=1
   do while .t.
      sele doks
      go rcdoksr
      set cent off
      foot('F5','Печать')
      rcdoksr=slce('doks',,,,,"e:rnd h:'Рег.N' c:n(6) e:ssd h:'Сумма' c:n(10,2) e:asum(doks->prz,doks->mn,doks->rnd) h:'СуммаП' c:n(10,2) e:nplp h:'N док.' c:n(6) e:ddc  h:'Дата' c:d(8) e:getfield('t1','doks->kkl','kln','nkl') h:'Клиент' c:c(30) e:kkl h:'Код' c:n(7) e:nap h:'Напр' c:n(4) e:auto h:'A' c:n(1) e:nchek h:'Чек' c:n(6) e:bosn h:'Основание' c:c(70)",,,,'mn=mnr',"prfrm=0.and.getfield('t1','doks->kkl','kpl','tzdoc')#0",,'Оплаты',,1)
      set cent on
      if lastkey()=K_ESC
         exit
      endif
      do case
         case lastkey()=19 // Left
              fldnomr=fldnomr-1
              if fldnomr=0
                 fldnomr=1
              endif
         case lastkey()=4 // Right
              fldnomr=fldnomr+1
      endc
   endd
endif
retu .t.
**************
func kklob()
**************
crtt('tkklob','f:ddk c:d(10) f:mn c:n(6) f:rnd c:n(6) f:sk c:n(3) f:rn c:n(6) f:mnp c:n(6) f:bs_s c:n(12,2) f:osn c:c(40) f:grp c:n(1)')
sele 0
use tkklob
inde on str(mn,6)+str(rnd,6) tag t1
inde on str(sk,3)+str(rn,6)+str(mnp,6) tag t2
inde on str(grp,1)+str(rnd,6)+dtos(ddk) tag t3
sele dokk
set orde to tag t10
if netseek('t10','kklr')
   do while kkl=kklr
      if !(bs_d=bsr.or.bs_k=bsr)
         skip
         loop
      endif
      mnr=mn
      rndr=rnd
      skr=sk
      rnr=rn
      mnpr=mnp
      ddkr=ddk
      bs_sr=bs_s
      bs_dr=bs_d
      bs_kr=bs_k
      nplpr=nplp
      kopr=kop
      osnr=''
      ktar=kta
      ktasr=ktas
      if mnr#0
         if int(bs_d/1000)=301.or.int(bs_d/1000)=311
            if int(bs_k/1000)=301
               osnr=getfield('t1','mnr,rndr','doks','osn')
            else
               osnr=getfield('t1','mnr,rndr','doks','bosn')
            endif
         endif
         sele tkklob
         if !netseek('t1','mnr,rndr')
            appe blank
            repl mn with mnr,;
                 rnd with bs_dr,;
                 rn with nplpr,;
                 ddk with ddkr,;
                 bs_s with bs_sr,;
                 osn with osnr,;
                 grp with 1
         endif
         repl bs_s with bs_s+bs_sr
      else
         osnr=str(kopr,3)+' '+alltrim(getfield('t1','ktasr','s_tag','fio'))
         sele tkklob
         if !netseek('t2','skr,rnr,mnpr')
            appe blank
            repl sk with skr,;
                 rn with rnr,;
                 mnp with mnpr,;
                 ddk with ddkr,;
                 bs_s with bs_sr,;
                 osn with osnr
            if mnpr=0
               repl grp with 2
            else
               repl grp with 3
            endif
         endif
         repl bs_s with bs_s+bs_sr
      endif
      sele dokk
      skip
   endd
endif
sele tkklob
set orde to tag t3
go top
rctkklobr=recn()
do while .t.
    sele tkklob
    go rctkklobr
    rctkklobr=slcf('tkklob',4,,15,,"e:rnd h:'Счет' c:n(6) e:ddk h:'Дата' c:d(10) e:sk h:'Скл' c:n(3) e:rn h:'Докум' c:n(6) e:mnp h:'Приход' c:n(6) e:bs_s h:'Сумма' c:n(10,2) e:osn h:'Основание' c:c(30)",,,,,,,str(bsr,6))
    if lastkey()=K_ESC
       exit
    endif
endd
sele tkklob
use
retu .t.
