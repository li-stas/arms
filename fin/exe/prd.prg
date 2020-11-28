#include "common.ch"
#include "inkey.ch"
func prdzo()
* Закрытие/открытие периода
if !(gnAdm=1.or.gnRprd=1)
   return .t.
endif
clea
sele prd
go top
rcprdr=recn()
do while .t.
   foot('Пробел,ESC','Изменить,Выход')
   sele prd
   go rcprdr
   if fieldpos('dto')#0
      rcprdr=slcf('prd',1,,18,,"e:god h:'Год' c:n(4) e:mes h:'Мес' c:n(2) e:prd h:'ЗО' c:n(1) e:dto h:'ДатаО' c:d(10) e:dtz h:'ДатаЗ' c:d(10) e:ktoo h:'КтоО' c:n(4) e:ktoz h:'КтоЗ' c:n(4)",,,,,,,'ПЕРИОДЫ')
   else
      rcprdr=slcf('prd',1,,18,,"e:god h:'Год' c:n(4) e:mes h:'Мес' c:n(2) e:prd h:'ЗО' c:n(1)",,,,,,,'ПЕРИОДЫ')
   endif
   if lastkey()=K_ESC
      exit
   endif
   do case
      case lastkey()=32
           sele prd
           go rcprdr
           if prd=1
              netrepl('prd','0')
              if fieldpos('dto')#0
                 netrepl('dto,ktoo','date(),gnKto')
              endif
           else
              netrepl('prd','1')
              if fieldpos('dto')#0
                 netrepl('dtz,ktoz','date(),gnKto')
              endif
           endif
   endc
enddo
return .t.
****************
func showprov()
****************
clea
store 0 to bskr,kklr,bs_dr,bs_kr,mnr,rndr,rnr,mnpr,kszr,kopr,prkklr,skr
store ctod('') to ddkr
netuse('dokk')
go top
rcdokkr=recn()
fldnomr=1
for_r='.t.'
forr=for_r
sum bs_s to sumr for &forr
do while .t.
   @ 23,59 say str(sumr,15,2)
   sele dokk
   go rcdokkr
   foot('F3','Фильтр')
   if prkklr=0
      rcdokkr=slce('dokk',1,,18,,"e:rnd h:'RND' c:n(6) e:rn h:'RN' c:n(6) e:mnp h:'MNP' c:n(6) e:ddk h:'Дата' c:d(10) e:kkl h:'KKL' c:n(7) e:bs_d  h:'DB' c:n(6) e:bs_k  h:'KR' c:n(6) e:bs_s  h:'SM' c:n(12,2) e:ksz h:'SZ' c:n(2) e:kop h:'Коп' c:n(4)",,,1,,forr,,'ПРОВОДКИ')
   else
      rcdokkr=slce('dokk',1,,18,,"e:rnd h:'RND' c:n(6) e:rn h:'RN' c:n(6) e:mnp h:'MNP' c:n(6) e:ddk h:'Дата' c:d(10) e:nkkl h:'KKL' c:n(7) e:bs_d  h:'DB' c:n(6) e:bs_k  h:'KR' c:n(6) e:bs_s  h:'SM' c:n(12,2) e:ksz h:'SZ' c:n(2) e:kop h:'Коп' c:n(4)",,,1,,forr,,'ПРОВОДКИ')
   endif
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
      case lastkey()=-2 // Фильтр
           cldi=setcolor('gr+/b,n/w')
           wdi=wopen(8,15,16,60)
           wbox(1)
           do while .t.
              @ 0,1 say '0-все;1-бух;2-скл' get bskr pict '9'
              @ 0,col()+1 say 'Склад' get skr pict '999'
              @ 1,1 say 'Дата             ' get ddkr
              @ 2,1 say 'Клиент           ' get kklr pict '9999999'
              @ 2,col()+1 get prkklr pict '9'
              @ 3,1 say 'Дебет            ' get bs_dr pict '999999'
              @ 4,1 say 'Кредит           ' get bs_kr pict '999999'
              @ 5,1 say 'Ст затрат(склад) ' get kszr pict '99'
              @ 6,1 say 'Код операции     ' get kopr pict '9999'
              read
              if lastkey()=13
                 forr=for_r
                 do case
                    case bskr=0
                    case bskr=1
                         forr=forr+'.and.mn#0'
                    case bskr=2
                         forr=forr+'.and.mn=0'
                         if skr#0
                            forr=forr+'.and.mn=0.and.sk=skr'
                         endif
                 endc
                 if !empty(ddkr)
                    forr=forr+'.and.ddk=ddkr'
                 endif
                 if kklr#0
                    if prkklr=0
                       forr=forr+'.and.kkl=kklr'
                    else
                       forr=forr+'.and.nkkl=kklr'
                    endif
                 endif
                 if bs_dr#0
                    forr=forr+'.and.bs_d=bs_dr'
                 endif
                 if bs_kr#0
                    forr=forr+'.and.bs_k=bs_kr'
                 endif
                 if kszr#0
                    forr=forr+'.and.ksz=kszr'
                 endif
                 if kopr#0
                    forr=forr+'.and.kop=kopr'
                 endif
                 sele dokk
                 go top
                 sum bs_s to sumr for &forr
                 go top
                 rcdokkr=recn()
                 exit
              endif
              if lastkey()=K_ESC
                 exit
              endif
           enddo
           wclose(wdi)
           setcolor(cldi)
  endc
enddo
nuse()
return .t.

***************
func entnnp()
***************
clea
mess('Ждите...')
netuse('dokk')
netuse('kln')
crtt('nndsp','f:dt c:d(10) f:mn c:n(6) f:rnd c:n(6) f:rn c:n(6) f:kkl c:n(7) f:ndspst c:c(15) f:ndspstc c:c(15) f:nn c:n(12) f:sm c:n(12,2)')
sele 0
use nndsp excl
inde on dt tag t1
sele dokk
go top
do while !eof()
   if empty(ndspst)
      skip
      loop
   endif
   dtr=ddk
   mnr=mn
   rndr=rnd
   rnr=rn
   kklr=kkl
   smr=bs_s
   ndspstr=alltrim(ndspst)
   ndspstcr=alltrim(ndspstc)
   nnr=getfield('t1','kklr','kln','nn')
   sele nndsp
   appe blank
   repl dt with dtr,;
        mn with mnr,;
        rnd with rndr,;
        rn with rnr,;
        kkl with kklr,;
        sm with smr,;
        ndspst with ndspstr,;
        ndspstc with ndspstcr,;
        nn with nnr
   sele dokk
   skip
enddo
sele nndsp
go top
rcr=recn()
fldnomr=1
do while .t.
   sele nndsp
   go rcr
   foot('F7','По дням')
   rcr=slce('nndsp',1,1,18,,"e:dt h:'Дата' c:d(10) e:mn h:'mn' c:n(6) e:rnd h:'rnd' c:n(6) e:rn h:'rn' c:n(6) e:kkl h:'kkl' c:n(7) e:sm h:'sm' c:n(12,2) e:ndspst h:'ndspst' c:c(10) e:ndspstc h:'ndspstc' c:c(10) e:nn h:'nn' c:n(12)",,,1,,,,'НН полученные',fldnomr,1)
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
      case lastkey()=-6 // Right
           ndspday()
   endc
enddo
nuse()
nuse('nndsp')
return .t.

**************
func ndspday()
**************
if select('ndspday')#0
   sele ndspday
   use
endif
erase ndspday.dbf
crtt('ndspday','f:dt c:c(8) f:dn c:c(2) f:kolv c:n(4) f:kolnp c:n(4) f:kolp c:n(4) f:kole c:n(4) f:smnp c:n(12,2) f:smp c:n(12,2)')
sele 0
use ndspday
dtr=bom(gdTd)
set cent off
cdtr=dtoc(dtr)
set cent on
dt_r=dtr
for i=1 to 31
    dayr=dow(dtr)
    do case
       case dayr=1
            dnr='Вс'
       case dayr=2
            dnr='Пн'
       case dayr=3
            dnr='Вт'
       case dayr=4
            dnr='Ср'
       case dayr=5
            dnr='Чт'
       case dayr=6
            dnr='Пн'
       case dayr=7
            dnr='Сб'
    endc
    appe blank
    repl dt with cdtr,dn with dnr
    dtr=dtr+1
    set cent off
    cdtr=dtoc(dtr)
    set cent on
    if month(dtr)#month(dt_r)
       exit
    endif
next
store 0 to ismnpr,ismpr
sele nndsp
go top
do while !eof()
   dtr=dt
   set cent off
   cdtr=dtoc(dtr)
   set cent on
   smr=sm
   sele ndspday
   locate for dt=cdtr
   if foun()
      repl kolv with kolv+1
      if nndsp->rn#0
         if nndsp->nn=0
            repl kolnp with kolnp+1 ,;
                 smnp with smnp+smr
           ismnpr=ismnpr+smr
         else
           repl kolp with kolp+1,;
                smp with smp+smr
           ismpr=ismpr+smr
         endif
      endif
   endif
   if nndsp->rn=0
      repl kole with kole+1
   endif
   sele nndsp
   skip
enddo
sele ndspday
appe blank
repl dt with 'Итого',;
     smnp with ismnpr,;
     smp with ismpr
go top
rcndsdr=recn()
do while .t.
   sele ndspday
   go rcndsdr
   foot('','')
   rcndsdr=slcf('ndspday',,,,,"e:dt h:'Дата' c:c(8) e:dn h:'Дн' c:c(2) e:kolv h:'Всего' c:n(4) e:kolnp h:'Не пл' c:n(4) e:kolp h:'Плат' c:n(4) e:kole h:'Проп' c:n(4) e:smnp h:'См не пл' c:n(10,2) e:smp h:'См плат' c:n(10,2)",,,,,,,'По дням')
   if lastkey()=K_ESC
      exit
   endif
enddo
sele ndspday
use
return .t.

******************
func oapa(lcrtt)
  * Формы 1-оа,1-ра
  ******************
  LOCAL nCurent,nMax
  LOCAL osnr,osfr

  IF ISNIL(lcrtt)
    lcrtt:=.T.
  ENDIF
    lcrtt:=.T.
  clea
  netuse('cskl')
  netuse('ctov')
  netuse('KProd')
  netuse('kln')
  netuse('kobl')
  /**********************************************
  *ОПТ
  **********************************************/
  // Товар
  IF lcrtt
    crtt('oa1','f:KProd c:n(10) f:vid c:c(60) f:osn c:n(12,6) f:PrAll c:n(12,6) f:PrIzg c:n(12,6) f:propt c:n(12,6) f:primp c:n(12,6) f:RsAll c:n(12,6) f:RsRoz c:n(12,6) f:RsOpt c:n(12,6) f:rsexp c:n(12,6) f:vtr_in c:n(12,6) f:osf c:n(12,6) f:prim c:c(60)')
  ENDIF
  sele 0
  use oa1 excl
  // Контрагенты закупки
  IF lcrtt
    crtt('oa2','f:dt c:d(10) f:numobl c:n(2) f:nklprn c:c(120) f:adr c:c(130) f:ckod c:c(30) f:KProd c:n(10) f:tdlall c:n(12,6)')
  ENDIF
  sele 0
  use oa2 excl
  // Контрагенты продажи
  IF lcrtt
    crtt('oa3','f:dt c:d(10) f:numobl c:n(2) f:nklprn c:c(120) f:adr c:c(130) f:ckod c:c(30) f:KProd c:n(10) f:tdlall c:n(12,6)')
  ENDIF
  sele 0
  use oa3 excl
  /**********************************************
  *РОЗНИЦА
  **********************************************/
  IF lcrtt
  crtt('pa','f:KProd c:n(10) f:vid c:c(60) f:osn c:n(12,6) f:pr c:n(12,6) f:rs c:n(12,6) f:osf c:n(12,6) f:prim c:c(60)')
  ENDIF
  sele 0
  use pa excl

  oPr:=map()
  oRs:=map()

  IF lcrtt
    // **********************************************
    nMax:=10
    IIF(gnScOut = 0, Termo((nCurent:=0),nMax,MaxRow(),4),)
    nMax:=0
    sele cskl
    go top
    do while !eof()
      if ent#gnEnt
        skip;        loop
      endif
      if rasc#1
        skip;        loop
      endif
      If str(sk, 3)$"263;705"
        skip;        loop
      EndIf

      pathr=gcPath_d+alltrim(path)
      if !netfile('tov',1)
        skip
        loop
      endif

      mess(pathr)


      netuse('tov',,,1); nMax+=LASTREC()
      netuse('rs1',,,1); nMax+=LASTREC()
      netuse('rs2',,,1)
      netuse('pr1',,,1); nMax+=LASTREC()
      netuse('pr2',,,1)

      sele tov
      go top
      do while !eof()
         IIF(gnScOut = 0, Termo(nCurent++,nMax,MaxRow(),4),)

         sele tov
         ktlr:=ktl
         MnTovr:=MnTov
         IF INT(MnTovr/10^4)=354 // пиво без алкогольое
           sele tov; skip
           loop
         ENDIF
         osnr=osn
         osfr=osf

         sele ctov
         netseek('t1','MnTovr')
         if MnTovT # 0 .and. MnTovT # MnTovr
            MnTovr:=MnTovT
            netseek('t1','MnTovr')
         endif
         if empty(ukt)
            sele tov;  skip
            loop
         endif
         VesPr=VesP
         osnr:=ROUND(osnr*VesPr/10^1,6)
         osfr:=ROUND(osfr*VesPr/10^1,6)

         uktr=ukt
         KProdr=0;          vidr=''
         KProd->(KProd_KodVid(uktr,@KProdr,@vidr))

         if KProdr=0
           sele tov;  skip
           loop
         endif

         If allt(uktr) = "2206005100" //сидр
           outlog(3,__FILE__,__LINE__,mntovr,  osnr,  osfr, VesPr)
         EndIf

         sele oa1
         locate for KProd=KProdr
         if !foun()
            appe blank
            repl KProd with KProdr, vid with vidr

         endif
         repl osn with osn+osnr,;
              osf with osf+osfr

         /*If allt(uktr) = "2206005100"
           outlog(__FILE__,__LINE__,"  osn, osf", osn, osf)
         EndIf*/

         sele tov;  skip
      enddo

      // Приходы
      sele pr1
      go top
      do while !eof()
         IIF(gnScOut = 0, Termo(nCurent++,nMax,MaxRow(),4),)
         if prz=0
            skip
            loop
         endif
         if !(vo=9 .or. (vo=1.and.(str(kop,3) $ "107;108")) .or. (vo=6.and.kop=111))
           key:='vo='+str(vo)+';'+'kop='+str(kop)
           iIf(key $ oPr, NIL, oPr[key]:=key)
            skip
            loop
         endif
         vor=vo
         mnr=mn
         kopr=kop
         kklr=kps
         dtr=dpr
         ckodr=''
         numoblr=0
         adrr=''
         nklprnr=''
         sele kln
         if netseek('t1','kklr')
            koblr=kobl
            nnr=nn
            cnnr=cnn
            psser=psse
            psnr=psn
            adrr=alltrim(adr)
            nklprnr=alltrim(nklprn)
            kkl1r=kkl1
            if empty(nklprnr)
               nklprnr=alltrim(nkl)
            endif
            if kkl1r#0
               ckodr=alltrim(str(kkl1r,10))
            else
               ckodr=passpr(psser,psnr)
            endif
            numoblr=getfield('t1','koblr','kobl','numobl')
         endif
         If empty(ckodr)
           outlog(3,__FILE__,__LINE__,'mnr',mnr,'kklr:=kps',kklr,'kkl1,psse,psn',kkl1,psse,psn)
         EndIf
         sele pr2
         if netseek('t1','mnr')
            do while mn=mnr
               ktlr:=ktl
               MnTovr:=MnTov
               kfr:=kf
               IF INT(MnTovr/10^4)=354 // пиво без алкогольое
                 skip; loop
               ENDIF

               VesPr:=uktr:=KProdr:=vidr:='' // в функции переопределятся
               lSkip:=VesPrUktrKProdrVidr(@VesPr, @uktr, @KProdr, @vidr)

               If lSkip
                 sele pr2;     skip
                 loop
               EndIf

               kfr:=ROUND(kfr*VesPr/10^1,6)

               sele oa1
               locate for KProd=KProdr
               if !foun()
                  appe blank
                  repl KProd with KProdr, vid with vidr
               endif
               if vor=9 // Поставка
                  repl PrAll with PrAll+kfr,;
                       PrIzg with PrIzg+kfr
                  sele oa2
                  locate for dt=dtr.and.ckod=ckodr.and.KProd=KProdr
                  if !foun()
                     appe blank
                     repl dt with dtr,;
                          ckod with ckodr,;
                          KProd with KProdr,;
                          nklprn with nklprnr,;
                          adr with adrr,;
                          numobl with numoblr
                  endif
                  repl tdlall with tdlall+kfr
               else // vor=1.and.kop=108 Возврат от покупателя
                  repl RsAll with RsAll-kfr,;
                       RsOpt with RsOpt-kfr
                  sele oa3
                  locate for dt=dtr.and.ckod=ckodr.and.KProd=KProdr
                  if !foun()
                     appe blank
                     repl dt with dtr,;
                          ckod with ckodr,;
                          KProd with KProdr,;
                          nklprn with nklprnr,;
                          adr with adrr,;
                          numobl with numoblr
                  endif
                  repl tdlall with tdlall-kfr
               endif
               sele pr2;     skip
            enddo
         endif
         sele pr1
         skip
      enddo

      // Расходы
      sele rs1
      go top
      do while !eof()
         IIF(gnScOut = 0, Termo(nCurent++,nMax,MaxRow(),4),)
         if prz=0 // провод
            skip;    loop
         endif
         if !(vo=9 .or. (vo=1 .and. kop=154) .or. vo=5)
           // "продажи" или "возрат постащику" или "списание"
           key:='vo='+str(vo)+';'+'kop='+str(kop)
           iIf(key $ oRs, NIL, oRs[key]:=key)
            skip;  loop
         endif
         kklr=kpl
         vor=vo
         kopr=kop
         ttnr=ttn
         dtr=dot
         ckodr=''
         numoblr=0
         adrr=''
         nklprnr=''
         sele kln
         if netseek('t1','kklr')
            koblr=kobl
            nnr=nn
            cnnr=cnn
            psser=psse
            psnr=psn
            adrr=alltrim(adr)
            nklprnr=alltrim(nklprn)
            kkl1r=kkl1
            if empty(nklprnr)
               nklprnr=alltrim(nkl)
            endif
            if kkl1r#0
               ckodr=alltrim(str(kkl1r,10))
            else
               ckodr=passpr(psser,psnr)
            endif
            numoblr=getfield('t1','koblr','kobl','numobl')
         endif
         If empty(ckodr)
           outlog(3,__FILE__,__LINE__,'ttn',ttnr,'kklr:=kps',kklr,'kkl1,psse,psn',kkl1,psse,psn)
         EndIf
         sele rs2
         if netseek('t1','ttnr')
            do while ttn=ttnr
               ktlr:=ktl
               MnTovr:=MnTov
               kvpr:=kvp
               IF INT(MnTovr/10^4)=354 // пиво без алкогольое
                 skip; loop
               ENDIF
               sele ctov
               netseek('t1','MnTovr')
               if MnTovT # 0 .and. MnTovT # MnTovr
                  MnTovr:=MnTovT
                  netseek('t1','MnTovr')
               endif
               if empty(ukt)
                  sele rs2; skip
                  loop
               endif
               VesPr=VesP

               uktr=ukt
               KProdr=0;   vidr=''
               KProd->(KProd_KodVid(uktr,@KProdr,@vidr))

               if KProdr=0
                 sele rs2;     skip
                 loop
               endif

               kvpr:=ROUND(kvpr*VesPr/10^1,6)

               if kopr=169 .or. vor=5 // Розница

                  sele pa
                  locate for KProd=KProdr
                  if !foun()
                     appe blank
                     repl KProd with KProdr, vid with vidr
                  endif
                  repl pr with pr+kvpr,;
                       rs with rs+kvpr

                  sele oa1
                  locate for KProd=KProdr
                  if !foun()
                     appe blank
                     repl KProd with KProdr,  vid with vidr
                  endif
                  repl RsAll with RsAll+kvpr,;
                       RsRoz with RsRoz+kvpr

               else // ОПТ
                  sele oa1
                  locate for KProd=KProdr
                  if !foun()
                     appe blank
                     repl KProd with KProdr, vid with vidr
                  endif
                  if vor=9 // Продажа
                     sele oa1
                     repl RsAll with RsAll+kvpr,;
                          RsOpt with RsOpt+kvpr

                     sele oa3
                     locate for dt=dtr.and.ckod=ckodr.and.KProd=KProdr
                     if !foun()
                        appe blank
                        repl dt with dtr,;
                             ckod with ckodr,;
                             KProd with KProdr,;
                             nklprn with nklprnr,;
                             adr with adrr,;
                             numobl with numoblr
                     endif
                     repl tdlall with tdlall+kvpr
                  else // Возврат поставщику и списание
                     sele oa1
                     repl PrAll with PrAll-kvpr,;
                          PrIzg with PrIzg-kvpr
                     sele oa2
                     locate for dt=dtr.and.ckod=ckodr.and.KProd=KProdr
                     if !foun()
                        appe blank
                        repl dt with dtr,;
                             ckod with ckodr,;
                             KProd with KProdr,;
                             nklprn with nklprnr,;
                             adr with adrr,;
                             numobl with numoblr
                     endif
                     repl tdlall with tdlall-kvpr
                  endif
               endif
               sele rs2
               skip
            enddo
         endif
         sele rs1
         skip
      enddo
      nuse('tov')
      nuse('rs1')
      nuse('rs2')
      nuse('pr1')
      nuse('pr2')

       sele oa1
       DBEVAL({||;
       outlog(3,__FILE__,__LINE__, KProd, osn + PrAll - RsAll -  osf, vid);
        })

      sele cskl
      skip
    enddo
    IIF(gnScOut = 0, Termo(nMax,nMax,MaxRow(),4),)
    //outlog(__FILE__,__LINE__,gcPath_mxml+'oa1.dbf')
  ENDIF
    //outlog(__FILE__,__LINE__,gcPath_mxml+'oa1.dbf')
  outlog(__FILE__,__LINE__,"oPr=", oPr)
  outlog(__FILE__,__LINE__,"oRs=", oRs)


  sele oa1
  DBEVAL({||;
  outlog(__FILE__,__LINE__, KProd, osn + PrAll - RsAll -  osf, vid);
   })
  copy to (gcPath_mxml+'oa1.dbf')

  sele oa2
  index on ckod+str(KProd) to tmpoa2
  total on ckod+str(KProd) field tdlall to tmpoa2
  close oa2
  USE tmpoa2 ALIAS oa2 NEW
  copy to (gcPath_mxml+'oa2.dbf')

  sele oa3
  copy to (gcPath_mxml+'oa3.dbf')
  index on ckod+str(KProd) to tmpoa3
  total on ckod+str(KProd) field tdlall to tmpoa3
  close oa3
  USE tmpoa3 ALIAS oa3 NEW
  copy to (gcPath_mxml+'oa3.dbf')

  sele pa
  copy to (gcPath_mxml+'pa.dbf')
  //перенос в oa3

  //kklr:=34451762
  sele kln
  if kln->(netseek("t1","gnKkl_c"))
    //netseek('t1','kklr')
    psnr := psn
    psser := psse
    kkl1r := kkl1
    if kkl1r#0
      ckodr := alltrim(str(kkl1r,10))
    else
      ckodr := passpr(psser,psnr)
    endif
    nklprnr := alltrim(nklprn)
    adrr := alltrim(adr)
    koblr := kobl
    numoblr := getfield('t1','koblr','kobl','numobl')


    sele pa
    DBGOTOP()
    DO WHILE !EOF()
      sele oa3
      appe blank
      repl dt with gdTd,;
            ckod with ckodr,;
            KProd with pa->KProd,;
            nklprn with nklprnr,;
            adr with adrr,;
            numobl with numoblr
      repl tdlall with pa->rs

      sele pa
      DBSKIP()
    enddo
  endif
  nuse()
  //вывол ХМЛ
  OutXml1oa()
  OutXml1pa()

  nuse('oa1')
  nuse('oa2')
  nuse('oa3')
  nuse('pa')
  return .t.

/*****************************************************************
 
 FUNCTION:
 АВТОР..ДАТА..........С. Литовка  05-05-16 * 11:57:12am
 НАЗНАЧЕНИЕ.........
 ПАРАМЕТРЫ..........
 ВОЗВР. ЗНАЧЕНИЕ....
 ПРИМЕЧАНИЯ.........
 */
FUNCTION OutXml1oa()
  LOCAL cCodePrint, ifl_r
  LOCAL i, n
  cTIN:="34451762"
  cC_REG:="18"
  cC_RAJ:="19"
  cC_DOC:="J02"
  cC_DOC_SUB="082"
  //nC_DOC_VER:=5 ;   cC_DOC_VER:=LTRIM(STR(nC_DOC_VER))
  nC_DOC_VER:=6 ;   cC_DOC_VER:=LTRIM(STR(nC_DOC_VER))
  cC_DOC_STAN:="1"
  nC_DOC_TYPE:=0 ;  cC_DOC_TYPE:=LTRIM(STR(nC_DOC_TYPE))
  nC_DOC_CNT:=3 ;   cC_DOC_CNT:=LTRIM(STR(nC_DOC_CNT))
  nPERIOD_TYPE:=1 ; cPERIOD_TYPE:=LTRIM(STR(nPERIOD_TYPE))
  //(1 - месяц 2 квартал 3 полугод 4 - девять мес 5 год)
  nPERIOD_MONTH:=MONTH(gdTd) ; cPERIOD_MONTH:=LTRIM(STR(MONTH(gdTd)))
  cPERIOD_YEAR:=LTRIM(STR(YEAR(gdTd)))
  cD_FILL:=strtran(dtoc(date()),'.','')



  ifl_r:=cC_REG+cC_RAJ;// "1819"; //1-4
  + PADL(cTIN,10,"0"); //5-14
  + cC_DOC; // 15 - 17
  + cC_DOC_SUB; // 18 20
  + PADL(LTRIM(STR(nC_DOC_VER)),2,"0"); // 21-22
  + cC_DOC_STAN; //23
  + PADL(LTRIM(STR(nC_DOC_TYPE)),2,"0"); //24-25
  + PADL(LTRIM(STR(nC_DOC_CNT)),7,"0");//счетчик 26 -32
  + cC_DOC_TYPE; // 33
  + PADL(LTRIM(STR(nPERIOD_MONTH)),2,"0");// 34 - 35;
  + cPERIOD_YEAR; //2016 36-39
  + cC_REG + cC_RAJ //40 - 43
  outlog(__FILE__,__LINE__,gcPath_mxml+ifl_r+'.xml')
  outlog(__FILE__,__LINE__,gdTd)

  #ifdef __CLIP__
      cCodePrint:= set("PRINTER_CHARSET","cp1251")
      set prin to (gcPath_mxml+ifl_r+'.xml')
  #else
      set prin to (gcPath_mxml+'n'+subs(ifl_r,26,7)+'.xml')
  #endif
  set prin on
  set cons off
  ??'<?xml version="1.0" encoding="windows-1251"?>'
  TEXT
  <DECLAR xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="J0208205.XSD">
    <DECLARHEAD>
      <TIN>&cTIN.</TIN>
      <C_DOC>&cC_DOC.</C_DOC>
      <C_DOC_SUB>&cC_DOC_SUB.</C_DOC_SUB>
      <C_DOC_VER>&cC_DOC_VER.</C_DOC_VER>
      <C_DOC_TYPE>&cC_DOC_TYPE.</C_DOC_TYPE>
      <C_DOC_CNT>&cC_DOC_CNT.</C_DOC_CNT>
      <C_REG>&cC_REG.</C_REG>
      <C_RAJ>&cC_RAJ.</C_RAJ>
      <PERIOD_MONTH>&cPERIOD_MONTH.</PERIOD_MONTH>
      <PERIOD_TYPE>&cPERIOD_TYPE.</PERIOD_TYPE>
      <PERIOD_YEAR>&cPERIOD_YEAR.</PERIOD_YEAR>
      <C_STI_ORIG>&cC_REG.&cC_RAJ</C_STI_ORIG>
      <C_DOC_STAN>&cC_DOC_STAN.</C_DOC_STAN>
      <LINKED_DOCS xsi:nil="true" />
      <D_FILL>&cD_FILL.</D_FILL>
      <SOFTWARE>LISTA Lista(at)bk.ru</SOFTWARE>
    </DECLARHEAD>
    <DECLARBODY>
      <HZM>&cPERIOD_MONTH</HZM>
      <HZY>&cPERIOD_YEAR.</HZY>
      <HSTI>ДПI У М.СУМАХ ГУ ДФС У СУМСЬКIЙ ОБЛАСТI</HSTI>
      <HTIN>&cTIN.</HTIN>
      <HNAME>ТОВАРИСТВО З ОБМЕЖЕНОЮ ВIДПОВIДАЛЬНIСТЮ "ЛОДIС-СУМИ"</HNAME>
      <HLOC>вулиця Скрябiна, буд. 7, м. СУМИ, СУМСЬКА обл., 40022</HLOC>
      <R00G1S />
  ENDTEXT
  /*
  // Товар
  crtt('oa1','  f:KProd c:n(10)  f:vid c:c(60)  f:osn c:n(12,6)  f:PrAll c:n(12,6)
  f:PrIzg c:n(12,6)  f:propt c:n(12,6)  f:primp c:n(12,6)  f:RsAll c:n(12,6)
  f:RsRoz c:n(12,6)  f:RsOpt c:n(12,6)  f:rsexp c:n(12,6)
  f:vtr_in c:n(12,6) f:osf c:n(12,6)  f:prim c:c(60)')
  */
  SELE oa1
  i:=1
    OutXml_TxR('T1RXXXXG1',i);i++
    OutXml_TxR('T1RXXXXG2S',i);i++
    OutXml_TxR('T1RXXXXG3',{||ltrim(str(FieldGet(i),10,3))},i);i++
    OutXml_TxR('T1RXXXXG4',{||ltrim(str(FieldGet(i),10,3))},i);i++
    OutXml_TxR('T1RXXXXG5',{||ltrim(str(FieldGet(i),10,3))},i);i++
    OutXml_TxR('T1RXXXXG6',{||ltrim(str(FieldGet(i),10,3))},i);i++
    OutXml_TxR('T1RXXXXG7',{||ltrim(str(FieldGet(i),10,3))},i);i++
    OutXml_TxR('T1RXXXXG8',{||ltrim(str(FieldGet(i),10,3))},i);i++
    OutXml_TxR('T1RXXXXG9',{||ltrim(str(FieldGet(i),10,3))},i);i++
    OutXml_TxR('T1RXXXXG10',{||ltrim(str(FieldGet(i),10,3))},i);i++
    OutXml_TxR('T1RXXXXG11',{||ltrim(str(FieldGet(i),10,3))},i);i++
    OutXml_TxR('T1RXXXXG12',{||ltrim(str(FieldGet(i),10,3))},i);i++
    OutXml_TxR('T1RXXXXG13',{||ltrim(str(FieldGet(i),10,3))},i);i++
    OutXml_TxR('T1RXXXXG14S',i);i++

  /*
    DBGoTop()
    outlog(__FILE__,__LINE__,i,FieldName(i),FieldGet(i),ltrim(str(FieldGet(i),10,3)))
    outlog(__FILE__,__LINE__,FieldGet(i),str(FieldGet(i),10,3)),;
  // Контрагенты закупки
  crtt('oa2',     'f:dt c:d(10)   f:numobl c:n(2)   f:nklprn c:c(120)   f:adr c:c(130)
   f:ckod c:c(30)   f:KProd c:n(10)   f:tdlall c:n(12,6)')  */
  SELE oa2
    //OutXml_TxR('T2RXXXXG1',{|| LTRIM(STR(MONTH(FieldGet(1)))) },1)
  i:=2
    OutXml_TxR('T2RXXXXG1',i);i++
    OutXml_TxR('T2RXXXXG2S',i);i++
    i++ //OutXml_TxR('T2RXXXXG4S',i);i++
    OutXml_TxR('T2RXXXXG3S',i);i++
    OutXml_TxR('T2RXXXXG4',i);i++
    OutXml_TxR('T2RXXXXG5',{||ltrim(str(FieldGet(i),10,3))},i);i++

  /*
  // Контрагенты продажи
  crtt('oa3','f:dt c:d(10) f:numobl c:n(2) f:nklprn c:c(120) f:adr c:c(130) f:ckod c:c(30) f:KProd c:n(10) f:tdlall c:n(12,6)')
  */
  SELE oa3
    //OutXml_TxR('T3RXXXXG1',{|| LTRIM(STR(MONTH(FieldGet(1)))) },1)
  i:=2
    OutXml_TxR('T3RXXXXG1',i);i++
    OutXml_TxR('T3RXXXXG2S',i);i++
    i++ //OutXml_TxR('T3RXXXXG4S',i);i++
    OutXml_TxR('T3RXXXXG3S',i);i++
    OutXml_TxR('T3RXXXXG4',i);i++
    OutXml_TxR('T3RXXXXG5',{||ltrim(str(FieldGet(i),10,3))},i);i++

  TEXT
      <HBOS>Калюжний Вадим Юрiйович</HBOS>
      <HBUH>Сiдаш Катерина Василiвна</HBUH>
    </DECLARBODY>
  </DECLAR>
  ENDTEXT

  #ifdef __CLIP__
      set("PRINTER_CHARSET",cCodePrint)
  #endif
  set prin off
  set prin to
  RETURN (NIL)




/*****************************************************************
 
 FUNCTION:
 АВТОР..ДАТА..........С. Литовка  05-15-16 * 12:18:01pm
 НАЗНАЧЕНИЕ.........
 ПАРАМЕТРЫ..........
 ВОЗВР. ЗНАЧЕНИЕ....
 ПРИМЕЧАНИЯ.........
 */
FUNCTION OutXml1pa()
  LOCAL cCodePrint, ifl_r
  LOCAL i, n

  cTIN:="34451762"
  cC_REG:="18"
  cC_RAJ:="19"
  cC_DOC:="J02"
  cC_DOC_SUB="101"
  nC_DOC_VER:=1 ;   cC_DOC_VER:=LTRIM(STR(nC_DOC_VER))
  cC_DOC_STAN:="1"
  nC_DOC_TYPE:=0 ;   cC_DOC_TYPE:=LTRIM(STR(nC_DOC_TYPE))
  nC_DOC_CNT:=3 ;    cC_DOC_CNT:=LTRIM(STR(nC_DOC_CNT))
  nPERIOD_TYPE:=1 ;  cPERIOD_TYPE:=LTRIM(STR(nPERIOD_TYPE))
  //(1 - месяц 2 квартал 3 полугод 4 - девять мес 5 год)
  nPERIOD_MONTH:=MONTH(gdTd) ; cPERIOD_MONTH:=LTRIM(STR(MONTH(gdTd)))
  cPERIOD_YEAR:=LTRIM(STR(YEAR(gdTd)))
  cD_FILL:=strtran(dtoc(date()),'.','')



  ifl_r:=cC_REG+cC_RAJ;// "1819"; //1-4
  + PADL(cTIN,10,"0"); //5-14
  + cC_DOC; // 15 - 17
  + cC_DOC_SUB; // 18 20
  + PADL(LTRIM(STR(nC_DOC_VER)),2,"0"); // 21-22
  + cC_DOC_STAN; //23
  + PADL(LTRIM(STR(nC_DOC_TYPE)),2,"0"); //24-25
  + PADL(LTRIM(STR(nC_DOC_CNT)),7,"0");//счетчик 26 -32
  + cC_DOC_TYPE; // 33
  + PADL(LTRIM(STR(nPERIOD_MONTH)),2,"0");// 34 - 35;
  + cPERIOD_YEAR; //2016 36-39
  + cC_REG + cC_RAJ //40 - 43
  outlog(__FILE__,__LINE__,gcPath_mxml+ifl_r+'.xml')
  outlog(__FILE__,__LINE__,gdTd)

  #ifdef __CLIP__
      cCodePrint:= set("PRINTER_CHARSET","cp1251")
      set prin to (gcPath_mxml+ifl_r+'.xml')
  #else
      set prin to (gcPath_mxml+'n'+subs(ifl_r,26,7)+'.xml')
  #endif
  set prin on
  set cons off
  ??'<?xml version="1.0" encoding="windows-1251"?>'
  TEXT
  <DECLAR xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="J0210101.XSD">
    <DECLARHEAD>
      <TIN>&cTIN.</TIN>
      <C_DOC>&cC_DOC.</C_DOC>
      <C_DOC_SUB>&cC_DOC_SUB.</C_DOC_SUB>
      <C_DOC_VER>&cC_DOC_VER.</C_DOC_VER>
      <C_DOC_TYPE>&cC_DOC_TYPE.</C_DOC_TYPE>
      <C_DOC_CNT>&cC_DOC_CNT.</C_DOC_CNT>
      <C_REG>&cC_REG.</C_REG>
      <C_RAJ>&cC_RAJ.</C_RAJ>
      <PERIOD_MONTH>&cPERIOD_MONTH.</PERIOD_MONTH>
      <PERIOD_TYPE>&cPERIOD_TYPE.</PERIOD_TYPE>
      <PERIOD_YEAR>&cPERIOD_YEAR.</PERIOD_YEAR>
      <C_STI_ORIG>&cC_REG.&cC_RAJ</C_STI_ORIG>
      <C_DOC_STAN>&cC_DOC_STAN.</C_DOC_STAN>
      <LINKED_DOCS xsi:nil="true" />
      <D_FILL>&cD_FILL.</D_FILL>
      <SOFTWARE>LISTA Lista(at)bk.ru</SOFTWARE>
    </DECLARHEAD>
    <DECLARBODY>
      <HZM>&cPERIOD_MONTH</HZM>
      <HZY>&cPERIOD_YEAR.</HZY>
      <HSTI>ДПI У М.СУМАХ ГУ ДФС У СУМСЬКIЙ ОБЛАСТI</HSTI>
      <HTIN>&cTIN.</HTIN>
      <HNAME>ТОВАРИСТВО З ОБМЕЖЕНОЮ ВIДПОВIДАЛЬНIСТЮ "ЛОДIС-СУМИ"</HNAME>
      <HLOC>вулиця Скрябiна, буд. 7, м. СУМИ, СУМСЬКА обл., 40022</HLOC>
      <R00G1S>151819642047</R00G1S>
      <R00G2D>01072015</R00G2D>
      <R00G3D>30062016</R00G3D>
  ENDTEXT

  /*
  // РОЗНИЦА
  crtt('pa','f:KProd c:n(10) f:vid c:c(60) f:osn c:n(12,6) f:pr c:n(12,6) f:rs c:n(12,6) f:osf c:n(12,6) f:prim c:c(60)')
  */
    sele pa
    DBGOTOP()
  i:=1
    OutXml_TxR('T1RXXXXG1',i);i++
    OutXml_TxR('T1RXXXXG2S',i);i++
    OutXml_TxR('T1RXXXXG3',i);i++
    OutXml_TxR('T1RXXXXG4',i);i++
    OutXml_TxR('T1RXXXXG5',i);i++
    OutXml_TxR('T1RXXXXG6',i);i++
    OutXml_TxR('T1RXXXXG7S',i);i++

  TEXT
      <HBOS>Калюжний Вадим Юрiйович</HBOS>
      <HBUH>Сiдаш Катерина Василiвна</HBUH>
    </DECLARBODY>
  </DECLAR>
  ENDTEXT

  #ifdef __CLIP__
      set("PRINTER_CHARSET",cCodePrint)
  #endif
  set prin off
  set prin to
  RETURN (NIL)

/*****************************************************************
 
 FUNCTION:
 АВТОР..ДАТА..........С. Литовка  05-05-16 * 01:19:18pm
 НАЗНАЧЕНИЕ.........
 ПАРАМЕТРЫ..........
 ВОЗВР. ЗНАЧЕНИЕ....
 ПРИМЕЧАНИЯ.........
 */
FUNCTION OutXml_TxR(h1,xField,nFieldPos)
  LOCAL cVlTp, nFlPos, bOut_TxR

  IF ISBLOCK(xField)
    bOut_TxR := xField
    nFlPos:=nFieldPos
  ELSE

    cVlTp:=VALTYPE(xField)
    DO CASE
    CASE cVlTp = "N"
      nFlPos:=xField
    CASE cVlTp = "C"
      nFlPos:=FIELDPOS(xField)
    ENDCASE

    cVlTp:=VALTYPE(FIELDGET(nFlPos))
    DO CASE
    CASE cVlTp = "N"
      bOut_TxR:={||ALLTRIM(STR(FIELDGET(nFlPos)))}
    CASE cVlTp = "C"
      bOut_TxR:={||ALLTRIM(FIELDGET(nFlPos))}
    CASE cVlTp = "D"
      bOut_TxR:={||strtran(dtoc(FIELDGET(nFlPos)),'.','')}
    ENDCASE
    //OUTLOG(__FILE__,__LINE__,cVlTp,xField,nFlPos)
  ENDIF

  DBGOTOP()
  DO WHILE !EOF()
    IF EMPTY(FIELDGET(nFlPos))
      QOUT(;
        '<'+h1+' ROWNUM="';
        +ALLTRIM(STR(RECNO()));
        +'"';
        +' xsi:nil="true" ';
        +'/>';
        )

    ELSE
      QOUT(;
        '<'+h1+' ROWNUM="';
        +ALLTRIM(STR(RECNO()));
        +'">')
      QQOUT('';
        +EVAL(bOut_TxR);
        +'</'+h1+'>';
        )
    ENDIF
    DBSKIP()
  enddo
  RETURN (NIL)

/*****************************************************************
 
 FUNCTION:
 АВТОР..ДАТА..........С. Литовка  06-07-18 * 03:06:38pm
 НАЗНАЧЕНИЕ.........
 ПАРАМЕТРЫ..........
 ВОЗВР. ЗНАЧЕНИЕ....
 ПРИМЕЧАНИЯ.........
 */
FUNCTION VesPrUktrKProdrVidr(VesPr, uktr, KProdr, vidr)
  LOCAL lSkip:=.F.
  ////// определение VesPr uktr KProdr vidr /////
  sele ctov
  netseek('t1','MnTovr')
  // найдем родителя
  if MnTovT # 0 .and. MnTovT # MnTovr
      MnTovr:=MnTovT
      netseek('t1','MnTovr')
  endif
  if empty(ukt)
    lSkip:=.T.
  endif
  If !lSkip
    VesPr=VesP

    uktr=ukt
    KProdr=0;   vidr=''
    KProd->(KProd_KodVid(uktr,@KProdr,@vidr))

    if KProdr=0
      lSkip:=.T.
    endif
  EndIf
  // end
  RETURN (lSkip)
