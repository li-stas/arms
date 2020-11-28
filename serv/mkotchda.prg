* Отчет по маркодержателю на день ОСТАТКИ и РЕАЛИЗАЦИЮ и ПРИХОД и Корреция остатки дня
* по списоку маркодержателей
#include 'common.ch'
para p1,p2
* p1 - дата
* p2 - список маркодержателей через запятую

if select('sl')#0
   sele sl
   use
endif
sele 0
use _slct alias sl excl
zap

if gnEnt=20
   ktacrmr=714
else
   ktacrmr=0
endif

if gnArm=25 && SERV
   clea
   netuse('mkeep')
   netuse('mkeepe')
   netuse('mkeepg')
   netuse('ctov')
   netuse('cgrp')
   netuse('kln')
   netuse('brand')
   netuse('cskl')
   netuse('ctov')
   netuse('klnnac')
   netuse('mkcros')
else
   if empty(p2).and.gnArm=0
      retu
   endif
   netuse('cskl')
   netuse('ctov')
   netuse('klnnac')
endif

if empty(p1)
   dtr=gdTd
else
   dtr=p1
endif



if gnArm#0
   scdt_r=setcolor('gr+/b,n/w')
   wdt_r=wopen(8,20,13,60)
   wbox(1)
   @ 0,1 say 'Дата     ' get dtr
   read
   wclose(wdt_r)
   setcolor(scdt_r)
   if lastkey()=27
      retu
   endif
endif

pathdr=gcPath_e+'g'+str(year(dtr),4)+'\m'+iif(month(dtr)<10,'0'+str(month(dtr),1),str(month(dtr),2))+'\'

if select('tmkeep')#0
   sele tmkeep
   use
endif
crtt('tmkeep',"f:mkeep c:n(3) f:cmkeep c:c(3)")
sele 0
use tmkeep
if gnArm#0
   sele mkeep
   set orde to tag t2
   for_r='.t.'

   if gnEnt=20
      forr=for_r+'.and.lv20=1'
   endif
   if gnEnt=21
      forr=for_r+'.and.lv21=1'
   endif

   go top
   rcmkeepr=recn()
   do while .t.
      sele mkeep
      go rcmkeepr
      foot('','')
      rcmkeepr=slcf('mkeep',1,1,18,,"e:mkeep h:'Код' c:n(3) e:nmkeep h:'Наименование' c:с(20) e:lv20 h:'20' c:n(1) e:lv21 h:'21' c:n(1)",,1,1,,forr,,'Маркодержатели')
      sele mkeep
      go rcmkeepr
      mkeepr=mkeep
      nmkeepr=nmkeep
      lv20r=lv20
      lv21r=lv21
      do case
         case lastkey()=27
              exit
         case lastkey()=13
           sele sl
           go top
           do while !eof()
              rcmkeep_r=val(kod)
              sele mkeep
              go rcmkeep_r
              mkeep_r=mkeep
              sele tmkeep
              appe blank
              repl mkeep with mkeep_r
              sele sl
              skip
           endd
           exit
      endc
   endd
else
   cmkeepsr=alltrim(p2)
   cmkeepr=''
   for i=1 to len(cmkeepr)
       if subs(cmkeepsr,i,1)=','
          mkeep_r=val(cmkeepr)
          sele tmkeep
          appe blank
          repl mkeep with mkeep_r
          cmkeepr=''
       else
         cmkeepr=cmkeepr+subs(cmkeepsr,i,1)
       endif
   next
   if !empty(cmkeepr)
      mkeep_r=val(cmkeepr)
      sele tmkeep
      appe blank
      repl mkeep with mkeep_r
      cmkeepr=''
   endif
endif


sele tmkeep
if recc()=0
   retu
endif

sele tmkeep
go top
do while !eof()
   mkeepr=mkeep
   do case
      case mkeepr<10
           cmkeepr='00'+str(mkeepr,1)
      case mkeepr<100
           cmkeepr='0'+str(mkeepr,2)
      othe
           cmkeepr=str(mkeepr,3)
   endc
   sele tmkeep
   repl cmkeep with cmkeepr
   skip
endd

dirostr=gcPath_ew+'ost'
sele tmkeep
go top
do while !eof()
   cmkeepr=cmkeep
   dirmkr=gcPath_ew+'ost\mk'+cmkeepr
   diryyr=dirmkr+'\g'+str(year(dtr),4)
   dirmmr=diryyr+'\m'+iif(month(dtr)<10,'0'+str(month(dtr),1),str(month(dtr),2))
   pathddr=dirmmr+'\d'+iif(day(dtr)<10,'0'+str(day(dtr),1),str(day(dtr),2))+'\'

   * Хранимые остатки на конец дня
   if dirchange(dirostr)#0
      dirmake(dirostr)
   endif
   if dirchange(dirmkr)#0
      dirmake(dirmkr)
   endif
   if dirchange(diryyr)#0
      dirmake(diryyr)
   endif
   if dirchange(dirmmr)#0
      dirmake(dirmmr)
   endif
   pathsvostr=dirmmr+'\'
   for i=1 to 31
       dirddr=dirmmr+'\d'+iif(i<10,'0'+str(i,1),str(i,2))
       if dirchange(dirddr)#0
          dirmake(dirddr)
       endif
   next

   dirchange(gcPath_l)
   if !file(pathsvostr+'svost.dbf')
      sele dbft
      copy stru to stmp exte
      sele 0
      use stmp excl
      zap
      appe blank
      repl field_name with 'sk',;
           field_type with 'n',;
           field_len with 3
      appe blank
      repl field_name with 'mntov',;
           field_type with 'n',;
           field_len with 7
      appe blank
      repl field_name with 'dt',;
           field_type with 'd',;
           field_len with 8
      for i=1 to 31
          appe blank
          repl field_name with 'ost'+alltrim(str(i,2)),;
               field_type with 'n',;
               field_len with 12,;
               field_dec with 3
          appe blank
          repl field_name with 'dcost'+alltrim(str(i,2)),;
               field_type with 'n',;
               field_len with 12,;
               field_dec with 3
      endf
      use
      create (pathsvostr+'svost') from stmp
      use
      sele 0
      use (pathsvostr+'svost') excl
      inde on str(sk,3)+str(mntov,7) tag t1
      use
      erase stmp.dbf
   else
      sele 0
      use (pathsvostr+'svost') excl
      inde on str(sk,3)+str(mntov,7) tag t1
      use
   endif
   sele tmkeep
   skip
endd

* Расходы
flr='mkrs'
if select('mkrs')#0
   sele mkrs
   use
endif
crtt(flr,'f:mkeep c:n(3) f:sk c:n(3) f:dop c:d(10) f:dtot c:d(10) f:ttn c:n(7) f:vo c:n(2) f:kop c:n(3) f:kpl c:n(7) f:kgp c:n(7) f:kta c:n(4) f:mntov c:n(7) f:kvp c:n(11,3) f:zen c:n(10,3) f:zencrm c:n(10,3) f:tcen c:n(2) f:dcl c:n(10,3) f:docguid c:c(36) f:ddc c:d(10) f:tdc c:c(8)')
sele 0
use mkrs excl
inde on str(mkeep,3)+str(sk,3)+str(ttn,7)+str(mntov,7) tag t1

* Приходы
flr='mkpr'
if select('mkpr')#0
   sele mkpr
   use
endif
crtt(flr,'f:mkeep c:n(3) f:sk c:n(3) f:dpr c:d(10) f:nd c:n(7) f:mn c:n(7) f:vo c:n(2) f:kop c:n(3) f:kps c:n(7) f:kgp c:n(7) f:kta c:n(4) f:mntov c:n(7) f:kf c:n(10,3) f:zen c:n(10,3) f:dcl c:n(10,3) f:ddc c:d(10) f:tdc c:c(8) f:docguid c:c(36)')
sele 0
use mkpr  excl
zap
inde on str(mkeep,3)+str(sk,3)+str(mn,7)+str(mntov,7) tag t1

* Остатки
flr='mkost'
if select('mkost')#0
   sele mkost
   use
endif
crtt(flr,'f:mkeep c:n(3) f:sk c:n(3) f:mntov c:n(7) f:nat c:c(60) f:kei c:n(4) f:nei c:c(4) f:vesp c:n(12,3) f:keip c:n(4) f:cenpr c:n(10,3) f:c08 c:n(10,3) f:cenbb c:n(10,3) f:upak c:n(10,3) f:kfc c:n(10,3) f:osn c:n(12,3) f:prpp c:n(12,3) f:rspp c:n(12,3) f:osfon c:n(12,3) f:prdd c:n(12,3) f:rsdd c:n(12,3) f:osfondch c:n(12,3) f:osfond c:n(12,3) f:prc c:n(12,3) f:rsc c:n(12,3) f:pr c:n(12,3) f:rs c:n(12,3) f:osfotd c:n(12,3) f:prpd c:n(12,3) f:rspd c:n(12,3) f:osfoch c:n(12,3) f:osfodb c:n(12,3) f:dcosn c:n(12,3) f:dcprpp c:n(12,3) f:dcrspp c:n(12,3) f:dcosfon c:n(12,3) f:dcprdd c:n(12,3) f:dcrsdd c:n(12,3)  f:dcosfondch c:n(12,3) f:dcosfond c:n(12,3) f:dcprc c:n(12,3) f:dcrsc c:n(12,3) f:dcpr c:n(12,3) f:dcrs c:n(12,3) f:dcosfotd c:n(12,3) f:dcprpd c:n(12,3) f:dcrspd c:n(12,3) f:dcosfoch c:n(12,3) f:dcosfodb c:n(12,3) f:mkcros c:n(7) f:bar c:n(13)')
sele 0
use mkost excl
inde on str(mkeep,3)+str(sk,3)+str(mntov,7) tag t1

dtpdr=dtr-1
sele tmkeep
go top
do while !eof()
   mkeepr=mkeep
   cmkeepr=cmkeep
   pathsvostr=gcPath_ew+'ost\mk'+cmkeepr+'\g'+str(year(dtpdr),4)+'\m'+iif(month(dtpdr)<10,'0'+str(month(dtpdr),1),str(month(dtpdr),2))+'\'
   if file(pathsvostr+'svost.dbf')
      costr='ost'+alltrim(str(day(dtpdr),2))
      cdcostr='dcost'+alltrim(str(day(dtpdr),2))
      sele 0
      use (pathsvostr+'svost') excl
      inde on str(sk,3)+str(mntov,7) tag t1
      set orde to tag t1
      go top
      do while !eof()
         skr=sk
         mntovr=mntov
         ostr=&costr
         dcostr=&cdcostr
         sele ctov
         netseek('t1','mntovr')
         natr=nat
         keir=kei
         keipr=keip
         neir=nei
         vespr=vesp
         keipr=keip
         cenprr=cenpr
         mkcrosr=mkcros
         barr=bar
         c08r=c08
         if c08r=0
            c08r=cenprr
         endif
         cenbbr=cenprr-c08r
         upakr=upak
         if int(mntovr/10000)=334
            if keir=800
               neir='шт'
               kfcr=upak
            else
               kfcr=1
            endif
         else
            kfcr=1
         endif
         sele mkost
         appe blank
         repl sk with skr,;
              mkeep with mkeepr,;
              mntov with mntovr,;
              nat with natr,;
              kei with keir,;
              nei with neir,;
              vesp with vespr,;
              keip with keipr,;
              cenpr with cenprr,;
              c08 with c08r,;
              upak with upakr,;
              kfc with kfcr,;
              cenbb with cenbbr,;
              mkcros with mkcrosr,;
              osfond with ostr,;
              dcosfond with dcostr,;
              bar with barr
        sele svost
        skip
      endd
      sele svost
      use
   endif
   sele tmkeep
   skip
endd

netuse('etm')

if gnArm=25 && SERV
   * Открытые таблицы :mkeep,mkeepe,mkeepg,ctov,cgrp,kln,brand
else
   netuse('mkeep')
   netuse('mkeepe')
   netuse('kln')
   netuse('ctov')
   netuse('mkeepg')
   netuse('cgrp')
   netuse('brand')
   netuse('mkcros')
endif

sele cskl
go top
do while !eof()
   if !(ent=gnEnt.and.rasc=1)
      skip
      loop
   endif
   pathr=pathdr+alltrim(path)
   skr=sk
   sklr=skl
   nskr=nskl
   rmr=rm
   do case
      case gnEnt=20
           do case
              case rmr=0
                   kkl_r=gnKKL_c
              case rmr=3
                   kkl_r=3000000
              case rmr=4
                   kkl_r=4000000
              case rmr=5
                   kkl_r=5000000
              case rmr=6
                   kkl_r=6000000
           endc
      case gnEnt=21
           kkl_r=9000000
      othe
           kkl_r=0
   endc

   if !netfile('tov',1)
      skip
      loop
   endif
   netuse('tov',,,1)
   netuse('rs1',,,1)
   netuse('rs2',,,1)
   netuse('pr1',,,1)
   netuse('pr2',,,1)

   * Товар
   sele tov
   go top
   do while !eof()
      mntovr=mntov
      osnr=osn
      osfodbr=osfo
      sele ctov
      if netseek('t1','mntovr')
         mkeepr=mkeep
         sele tmkeep
         locate for mkeep=mkeepr
         if !foun()
            sele tov
            skip
            loop
         endif
         sele ctov
         if mntovt#0
            mntovr=mntovt
         endif
         sele mkost
         if !netseek('t1','mkeepr,skr,mntovr')
            sele ctov
            natr=nat
            keir=kei
            keipr=keip
            neir=nei
            vespr=vesp
            keipr=keip
            cenprr=cenpr
            mkcrosr=mkcros
            barr=bar
            c08r=c08
            if c08r=0
               c08r=cenprr
            endif
            cenbbr=cenprr-c08r
            upakr=upak
            if int(mntovr/10000)=334
               if keir=800
                  neir='шт'
                  kfcr=upak
               else
                  kfcr=1
               endif
            else
               kfcr=1
            endif
            sele mkost
            appe blank
            repl sk with skr,;
                 mkeep with mkeepr,;
                 mntov with mntovr,;
                 nat with natr,;
                 kei with keir,;
                 nei with neir,;
                 vesp with vespr,;
                 keip with keipr,;
                 cenpr with cenprr,;
                 c08 with c08r,;
                 upak with upakr,;
                 kfc with kfcr,;
                 cenbb with cenbbr,;
                 mkcros with mkcrosr,;
                 bar with barr,;
                 osfond with 9999
         endif
         repl osn with osn+osnr,;
              osfon with osfon+osnr,;
              osfondch with osfondch+osnr,;
              osfodb with osfodb+osfodbr
      endif
      sele tov
      skip
   endd

   * Расход
   sele rs1
   do while !eof()
      if empty(dop)
         skip
         loop
      endif
      dopr=dop
      dtotr=dtot
      ttnr=ttn
      vor=vo
      kopr=kop
      ktar=kta
      docguidr=docguid
      docidr=docid
      rcrs1_r=recn()
      if empty(docguidr)
         if kopr=177.or.kopr=168
            if docidr#0
               docguid_r=getfield('t1','docidr','rs1','docguid')
               sele rs1
               go rcrs1_r
               if subs(docguid_r,1,2)='SV'
                  docguidr=docguid_r
               endif
            endif
         endif
      endif
      sele rs1
      ddcr=ddc
      tdcr=tdc
      if vor=6
         kplr=kkl_r
         do case
            case skt=300
                 kgpr=3000000
            case skt=400
                 kgpr=4000000
            case skt=500
                 kgpr=5000000
            case skt=600
                 kgpr=6000000
            othe
                 kgpr=gnKKL_c
         endc
      else
         if nkkl#0
            kplr=nkkl
         else
            kplr=kpl
         endif
         if kpv#0
            kgpr=kpv
         else
            kgpr=kgp
         endif
      endif

      sele rs2
      if netseek('t1','ttnr')
         do while ttn=ttnr
            mntovr=mntov
            mkeepr=getfield('t1','mntovr','ctov','mkeep')
            sele tmkeep
            locate for mkeep=mkeepr
            if !foun()
               sele rs2
               skip
               loop
            endif
            mntovtr=getfield('t1','mntovr','ctov','mntovt')
            if !empty(mntovtr)
               mntovr=mntovtr
            endif
            sele mkost
            if !netseek('t1','mkeepr,skr,mntovr')
               sele rs2
               skip
               loop
            endif

            kfcr=kfc
            vespr=vesp

            sele rs2
            kvpr=kvp
            if int(mntov/10000)=334
               kvp_r=kvp/kfcr
               dclr=ROUND(round(kvp_r*vespr,3)/10,3)
            else
               dclr=0
            endif
            zenr=zen
            zencrmr=getfield('t1','mntovr','ctov','c12')
            sele mkrs
            if !netseek('t1','mkeepr,skr,ttnr,mntovr')
               netadd()
               netrepl('mkeep,sk,dop,dtot,ttn,vo,kop,kpl,kgp,kta,mntov,zen,docguid,ddc,tdc,zencrm',;
                       'mkeepr,skr,dopr,dtotr,ttnr,vor,kopr,kplr,kgpr,ktar,mntovr,zenr,docguidr,ddcr,tdcr,zencrmr')
            endif
            netrepl('kvp,dcl','kvp+kvpr,dcl+dclr')
            sele mkost
            do case
               case dopr<bom(dtr)
                    repl rspp with rspp+kvpr,;
                         osfon with osfon-kvpr,;
                         osfondch with osfondch-kvpr
               case dopr<dtr
                    repl rsdd with rsdd+kvpr,;
                         osfondch with osfondch-kvpr
               case dopr=dtr
                    repl rs with rs+kvpr
               case dopr>dtr
                    repl rspd with rspd+kvpr
            endc
            sele rs2
            skip
         endd
      endif
      sele rs1
      skip
   endd

   * Приход
   sele pr1
   do while !eof()
      if prz=0
         skip
         loop
      endif
      dprr=dpr
      ndr=nd
      mnr=mn
      vor=vo
      kopr=kop
      kpsr=kps
      kzgr=kzg
      ktar=kta
      ddcr=ddc
      tdcr=tdc
      if fieldpos('docguid')#0
         docguidr=docguid
      else
         docguidr=''
      endif
      if vor#6
         if kzgr#0
            kgpr=kzgr
         else
            kgpr=getfield('t2','kpsr','etm','kgp')
            if kgpr=0
               kgpr=kpsr
            endif
         endif
      else
         kgpr=kkl_r
         do case
            case sks=300
                 kpsr=3000000
            case sks=400
                 kpsr=4000000
            case sks=500
                 kpsr=5000000
            case sks=600
                 kpsr=6000000
            othe
                 kpsr=gnKKL_c
          endc
      endif
      sele pr2
      if netseek('t1','mnr')
         do while mn=mnr
            mntovr=mntov
            mkeepr=getfield('t1','mntovr','ctov','mkeep')
            sele tmkeep
            locate for mkeep=mkeepr
            if !foun()
               sele pr2
               skip
               loop
            endif
            mntovtr=getfield('t1','mntovr','ctov','mntovt')
            if !empty(mntovtr)
              mntovr=mntovtr
            endif
            sele mkost
            if !netseek('t1','mkeepr,skr,mntovr')
               sele pr2
               skip
               loop
            endif
            kfcr=kfc
            vespr=vesp
            sele pr2
            kfr=kf
            if int(mntov/10000)=334
               kf_r=kf/kfcr
               dclr=ROUND(round(kf_r*vespr,3)/10,3)
            else
               dclr=0
            endif
            zenr=zen
            sele mkpr
            if !netseek('t1','mkeepr,skr,mnr,mntovr')
               netadd()
               netrepl('mkeep,sk,dpr,nd,mn,vo,kop,kps,kgp,kta,mntov,zen,ddc,tdc,docguid',;
                       'mkeepr,skr,dprr,ndr,mnr,vor,kopr,kpsr,kgpr,ktar,mntovr,zenr,ddcr,tdcr,docguidr')
            endif
            netrepl('kf,dcl','kf+kfr,dcl+dclr')
            sele mkost
            do case
               case dprr<bom(dtr)
                    repl prpp with prpp+kfr,;
                         osfon with osfon+kfr,;
                         osfondch with osfondch+kfr
               case dprr<dtr
                    repl prdd with prdd+kfr,;
                         osfondch with osfondch+kfr
               case dprr=dtr
                    repl pr with pr+kfr
               case dprr>dtr
                    repl prpd with prpd+kfr
            endc
            sele pr2
            skip
         endd
      endif
      sele pr1
      skip
   endd
   nuse('tov')
   nuse('rs1')
   nuse('rs2')
   nuse('pr1')
   nuse('pr2')
   sele cskl
   skip
endd
**********
costr='ost'+alltrim(str(day(dtr),2))
cdcostr='dcost'+alltrim(str(day(dtr),2))
*********
sele tmkeep
go top
do while !eof()
   cmkeepr=cmkeep
   pathsvostr=gcPath_ew+'ost\mk'+cmkeepr+'\g'+str(year(dtr),4)+'\m'+iif(month(dtr)<10,'0'+str(month(dtr),1),str(month(dtr),2))+'\'
   if file(pathsvostr+'svost.dbf')
      sele 0
      use (pathsvostr+'svost') alias ('svost'+cmkeepr) excl
      set orde to tag t1
   endif
   sele tmkeep
   skip
endd

*flr='mkdoc'
*crtt(flr,'f:mkeep c:n(3) f:vo c:n(2) f:kgp c:n(7) f:kpl c:n(7) f:okpo c:n(10) f:ngp c:c(40) f:npl c:c(40) f:agp c:c(40) f:DocGUID c:c(36) f:sk c:n(3) f:ttn c:n(7) f:kop c:n(3) f:dttn c:d(10) f:mntov c:n(7) f:mntovt c:n(7) f:ktl c:n(9) f:nat c:c(60)  f:zen c:n(10,3) f:zen_n_but c:n(10,3)  f:kvp c:n(11,3) f:apl c:c(40) f:kta c:n(3) f:ddc c:d(10) f:tdc c:c(8) f:nnz c:c(9) f:dcl c:n(10,3) f:mkid c:c(20) f:nmkid c:c(90) f:ttnc c:n(7)')
*sele 0
*use mkdoc excl
*inde on str(mkeep,3)+str(sk,3)+str(ttn,7)+str(mntovt,7) tag t1

sele mkost
go top
do while !eof()
   mkeepr=mkeep
   skr=sk
   mntovr=mntov
   vespr=vesp
   zenr=cenpr
   if osfond=9999
      repl osfond with osfondch,;
           dcosfond with dcosfondch
   endif

   if roun(osfond,3)#roun(osfondch,3)
#ifdef __CLIP__
   outlog(__FILE__,__LINE__,"osfond osfondch",mkost->osfond,mkost->osfondch)
#endif
      sldr=osfond-osfondch
      if sldr>0 && Расход
         ttnr=skr*10000
         sele mkrs
         seek str(mkeepr,3)+str(skr,3)+str(ttnr,7)+str(mntovr,7)
         if !foun()
            appe blank
            repl mkeep with mkeepr,sk with skr,dop with dtr,;
                 ttn with ttnr,;
                 mntov with mntovr,;
                 ddc with dtr,tdc with time(),;
                 vo with 6,kop with 188,;
                 zen with zenr
            do case
               case sk=228.or.sk=232
                    repl kpl with gnKkl_c,;
                         kgp with gnKkl_c
               case sk=300
                    repl kpl with 3000000,;
                         kgp with 3000000
               case sk=400
                    repl kpl with 4000000,;
                         kgp with 4000000
               case sk=500
                    repl kpl with 5000000,;
                         kgp with 5000000
               case sk=600
                    repl kpl with 6000000,;
                         kgp with 6000000
               case sk=700
                    repl kpl with 9000000,;
                        kgp with 9000000
            endc
         endif
         repl kvp with kvp+sldr
         dcl_r=ROUND(round(kvp*vespr,3)/10,3)
         repl dcl with dcl_r
         sele mkost
         repl rsc with rsc+sldr
      endif
      if sldr<0 && Приход
         mnr=skr*10000
         sele mkpr
         seek str(mkeepr,3)+str(skr,3)+str(mnr,7)+str(mntovr,7)
         if !foun()
            appe blank
            repl sk with skr,dpr with dtr,;
                 mn with mnr,nd with mnr,;
                 mntov with mntovr,;
                 ddc with dtr,tdc with time(),;
                 vo with 6,kop with 188,;
                 zen with zenr
            do case
               case sk=228.or.sk=232
                    repl kps with gnKkl_c,;
                         kgp with gnKkl_c
               case sk=300
                    repl kps with 3000000,;
                         kgp with 3000000
               case sk=400
                    repl kps with 4000000,;
                         kgp with 4000000
               case sk=500
                    repl kps with 5000000,;
                         kgp with 5000000
               case sk=600
                    repl kps with 6000000,;
                         kgp with 6000000
               case sk=700
                    repl kps with 9000000,;
                         kgp with 9000000
            endc
         endif
         repl kf with kf+abs(sldr)
         dcl_r=ROUND(round(kf*vespr,3)/10,3)
         repl dcl with dcl_r
         sele mkost
         repl prc with prc+abs(sldr)
      endif
   endif
   sele mkost
   skip
endd

sele mkost
go top
do while !eof()
   skr=sk
   mntovr=mntov
   repl osfotd with osfond+pr+prc-rs-rsc,;
        osfoch with osfotd+prpd-rspd
   dcl('osn')
   dcl('prpp')
   dcl('rspp')
   dcl('osfon')
   dcl('prdd')
   dcl('rsdd')
   dcl('osfond')
   dcl('osfondch')
   dcl('prc')
   dcl('rsc')
   dcl('pr')
   dcl('rs')
   dcl('osfotd')
   dcl('prpd')
   dcl('rspd')
   dcl('osfoch')
   dcl('osfodb')
   skip
endd

sele cskl
locate for sk=228
reclock()
sele tmkeep
go top
do while !eof()
   cmkeepr=cmkeep
   cttnr='t228'+cmkeepr+'r'
   sele cskl
   &cttnr=ttn
   repl ttn with ttn+1
   cttnr='t300'+cmkeepr+'r'
   sele cskl
   &cttnr=ttn
   repl ttn with ttn+1
   cttnr='t400'+cmkeepr+'r'
   sele cskl
   &cttnr=ttn
   repl ttn with ttn+1
   cttnr='t500'+cmkeepr+'r'
   sele cskl
   &cttnr=ttn
   repl ttn with ttn+1
   cttnr='t600'+cmkeepr+'r'
   sele cskl
   &cttnr=ttn
   repl ttn with ttn+1
   sele tmkeep
   skip
endd
sele cskl
dbcommit()
dbunlock()

sele mkrs
go top
do while !eof()
   if dop#dtr
      skip
      loop
   endif
   vor=vo
   if vor=1
      skip
      loop
   endif
   mkeepr=mkeep
   sele tmkeep
   locate for mkeep=mkeepr
   cmkeepr=cmkeep
   sele mkrs
   kopr=kop
   kgpr=kgp
   kplr=kpl
   docguidr=docguid
   skr=sk
   ttnr=ttn
   ttn_r=ttn
   if ttnr>999999
      vor=9
      kopr=169
      kplr=20034
      do case
         case skr=228
              cttnr='t228'+cmkeepr+'r'
              ttnr=&cttnr
              kgpr=22012
         case skr=300
              cttnr='t300'+cmkeepr+'r'
              ttnr=&cttnr
              kgpr=22014
         case skr=400
              cttnr='t400'+cmkeepr+'r'
              ttnr=&cttnr
              kgpr=22044
         case skr=500
              cttnr='t500'+cmkeepr+'r'
              ttnr=&cttnr
              kgpr=22013
         case skr=600
              cttnr='t600'+cmkeepr+'r'
              ttnr=&cttnr
              kgpr=22045
      endc
   endif
   nplr=getfield('t1','kplr','kln','nkl')
   ngpr=getfield('t1','kgpr','kln','nkl')
   okpor=getfield('t1','kplr','kln','kkl1')
   if okpor=0
      okpor=getfield('t1','gnKkl_c','kln','kkl1')
   endif
   agpr=getfield('t1','kgpr','kln','adr')
   sele mkrs
   mntovr=mntov
   mntovtr=mntov
   zenr=zen
   zencrmr=zencrm
   sele mkost
   netseek('t1','mkeepr,skr,mntovr')
   natr=nat
   cenbbr=cenbb
   mkcrosr=mkcros
   upakr=upak
   mkidr=getfield('t1','mkcrosr','mkcros','mkid')
   nmkidr=getfield('t1','mkcrosr','mkcros','nmkid')
   tcenr=getfield('t1','kplr,377512,999','klnnac','tcen')
   sele mkrs
   repl tcen with tcenr
   zen_n_butr=zenr-cenbbr
   if vor=6
      kvpr=-kvp
      dclr=-dcl
   else
      kvpr=kvp
      dclr=dcl
   endif
   aplr=getfield('t1','kplr','kln','adr')
   ktar=kta
   ddcr=ddc
   tdcr=tdc
   dttnr=dop
*   sele mkdoc
*   seek str(mkeepr,3)+str(skr,3)+str(ttnr,7)+str(mntovr,7)
*   if !foun()
*      appe blank
*      repl mkeep with mkeepr,;
*           vo with vor,;
*           kgp with kgpr,;
*           kpl with kplr,;
*           okpo with okpor,;
*           npl with nplr,;
*           ngp with ngpr,;
*           agp with agpr,;
*           docguid with docguidr,;
*           sk with skr,;
*           ttn with ttnr,;
*           mntov with mntovr,;
*           mntovt with mntovtr,;
*           nat with natr,;
*           zen with zenr,;
*           zen_n_but with zen_n_butr,;
*           kvp with kvpr,;
*           apl with aplr,;
*           kta with ktar,;
*           dcl with dclr,;
*           mkid with mkidr,;
*           nmkid with nmkidr,;
*           ddc with ddcr,;
*           tdc with tdcr,;
*           kop with kopr,;
*           dttn with dttnr
*      if ttn_r>999999
*           repl ttnc with ttn_r
*      endif
*      if tcenr=0
*         repl zen with zencrmr,;
*         zen_n_but with zencrmr-cenbbr
*      endif
*   else
*      repl kvp with kvp+kvpr,;
*           dcl with dcl+dclr
*   endif
   sele mkrs
   skip
endd

sele mkpr
go top
do while !eof()
   if dpr#dtr
      skip
      loop
   endif
   vor=vo
   if vor=9
      skip
      loop
   endif
   mkeepr=mkeep
   sele tmkeep
   locate for mkeep=mkeepr
   cmkeepr=cmkeep
   sele mkpr
   kopr=kop
   kgpr=kgp
   kplr=kps
   if fieldpos('docguid')#0
      docguidr=docguid
   else
      docguidr=''
   endif
   skr=sk
   ttnr=mn
   ttn_r=mn
   if ttnr>999999
      vor=9
      kopr=169
      kplr=20034
      do case
         case skr=228
              cttnr='t228'+cmkeepr+'r'
              ttnr=&cttnr
              kgpr=22012
         case skr=300
              cttnr='t300'+cmkeepr+'r'
              ttnr=&cttnr
              kgpr=22014
         case skr=400
              cttnr='t400'+cmkeepr+'r'
              ttnr=&cttnr
              kgpr=22044
         case skr=500
              cttnr='t500'+cmkeepr+'r'
              ttnr=&cttnr
              kgpr=22013
         case skr=600
              cttnr='t600'+cmkeepr+'r'
              ttnr=&cttnr
              kgpr=22045
      endc
   endif
   nplr=getfield('t1','kplr','kln','nkl')
   okpor=getfield('t1','kplr','kln','kkl1')
   if okpor=0
      okpor=getfield('t1','gnKkl_c','kln','kkl1')
   endif
   ngpr=getfield('t1','kgpr','kln','nkl')
   agpr=getfield('t1','kgpr','kln','adr')
   mntovr=mntov
   mntovtr=mntov
   zenr=zen
   sele mkost
   netseek('t1','mkeepr,skr,mntovr')
   natr=nat
   cenbbr=cenbb
   mkcrosr=mkcros
   upakr=upak
   mkidr=getfield('t1','mkcrosr','mkcros','mkid')
   nmkidr=getfield('t1','mkcrosr','mkcros','nmkid')
   sele mkpr
   zen_n_butr=zenr-cenbbr
   if vor=6
      kvpr=kf
      dclr=dcl
   else
      kvpr=-kf
      dclr=-dcl
   endif
   aplr=getfield('t1','kplr','kln','adr')
   ktar=kta
   ddcr=ddc
   tdcr=tdc
   dttnr=dpr
*   sele mkdoc
*   seek str(mkeepr,3)+str(skr,3)+str(ttnr,7)+str(mntovr,7)
*   if !foun()
*      appe blank
*      repl mkeep with mkeepr,;
*           vo with vor,;
*           kgp with kgpr,;
*           kpl with kplr,;
*           npl with nplr,;
*           ngp with ngpr,;
*           okpo with okpor,;
*           agp with agpr,;
*           docguid with docguidr,;
*           sk with skr,;
*           ttn with ttnr,;
*           mntov with mntovr,;
*           mntovt with mntovtr,;
*           nat with natr,;
*           zen with zenr,;
*           zen_n_but with zen_n_butr,;
*           kvp with kvpr,;
*           apl with aplr,;
*           kta with ktar,;
*           dcl with dclr,;
*           mkid with mkidr,;
*           nmkid with nmkidr,;
*           ddc with ddcr,;
*           tdc with tdcr,;
*           kop with kopr,;
*           dttn with dttnr
*      if ttn_r>999999
*           repl ttnc with ttn_r
*      endif
*   else
*      repl kvp with kvp+kvpr,;
*           dcl with dcl+dclr
*   endif
   sele mkpr
   skip
endd

*flr='mktov'
*crtt(flr,'f:mkeep c:n(3) f:sk c:n(3) f:nsk c:c(30) f:mntov c:n(7) f:mntovt c:n(7) f:nat c:c(60) f:nei c:c(4) f:opt c:n(10,3) f:cenpr c:n(10,3) f:pr_n_but c:n(10,3)  f:upak c:n(10,3) f:osfo c:n(12,3) f:osfo_upak c:n(6) f:osv c:n(12,3) f:osv_upak c:n(6) f:dt c:d(10) f:tm c:c(8) f:dcl c:n(10,3) f:mkid c:c(20) f:nmkid c:c(90)')
*sele 0
*use mktov excl
*inde on str(mkeep,3)+str(sk,3)+str(mntov,7) tag t1
*inde on str(mkeep,3)+str(sk,3)+str(mntovt,7) tag t2

sele mkost
go top
do while !eof()
   mkeepr=mkeep
   sele tmkeep
   locate for mkeep=mkeepr
   cmkeepr=cmkeep
   sele mkost
   skr=sk
   mntovr=mntov
   osfotdr=osfotd
   dcosfotdr=dcosfotd
   if select('svost'+cmkeepr)#0
      sele ('svost'+cmkeepr)
      seek str(skr,3)+str(mntovr,7)
      if !foun()
         appe blank
         repl sk with skr,;
              mntov with mntovr
      endif
      repl &costr with osfotdr,;
           &cdcostr with dcosfotdr
      if empty(dt)
         repl dt with dtr
      endif
   endif
   sele mkost
   nskr=getfield('t1','skr','cskl','nskl')
   mntovtr=mntov
   natr=nat
   neir=nei
   cenprr=cenpr
   pr_n_butr=cenprr-cenbb
   upakr=upak
   osfor=osfotd
   if upakr#0
      osfo_upakr=roun(osfor/upakr,0)
   else
      osfo_upakr=0
   endif
   dclr=dcosfotd
   mkcrosr=mkcros
   sele mkcros
   netseek('t1','mkcrosr')
   mkidr=mkid
   nmkidr=nmkid
*   sele mktov
*   appe blank
*   repl mkeep with mkeepr,;
*        sk with skr,;
*        nsk with nskr,;
*        mntov with mntovr,;
*        mntovt with mntovtr,;
*        nat with natr,;
*        nei with neir,;
*        cenpr with cenprr,;
*        pr_n_but with pr_n_butr,;
*        upak with upakr,;
*        osfo with osfor,;
*        dcl with dclr,;
*        mkid with mkidr,;
*        nmkid with nmkidr,;
*        osfo_upak with osfo_upakr,;
*        dt with date(),;
*        tm with time()
   sele mkost
   skip
endd

if gnArm=25 && SERV
   * Открытые таблицы :mkeep,mkeepe,mkeepg,ctov,cgrp,kln,brand,cskl
else
   nuse('')
endif

sele tmkeep
go top
do while !eof()
   mkeepr=mkeep
   cmkeepr=cmkeep
   dirmkr=gcPath_ew+'ost\mk'+cmkeepr
   diryyr=dirmkr+'\g'+str(year(dtr),4)
   dirmmr=diryyr+'\m'+iif(month(dtr)<10,'0'+str(month(dtr),1),str(month(dtr),2))
   pathddr=dirmmr+'\d'+iif(day(dtr)<10,'0'+str(day(dtr),1),str(day(dtr),2))+'\'
   sele mkrs
   copy to (pathddr+'mkrs') for mkeep=mkeepr
   sele 0
   use (pathddr+'mkrs') alias rs excl
   inde on str(sk,3)+str(ttn,7)+str(mntov,7) tag t1
   use
   sele mkpr
   copy to (pathddr+'mkpr') for mkeep=mkeepr
   sele 0
   use (pathddr+'mkpr') alias pr excl
   inde on str(sk,3)+str(mn,7)+str(mntov,7) tag t1
   use
   sele mkost
   copy to (pathddr+'mkost') for mkeep=mkeepr
   sele 0
   use (pathddr+'mkost') alias ost excl
   inde on str(sk,3)+str(mntov,7) tag t1
   use
*   sele mktov
*   copy to (pathddr+'mktov') for mkeep=mkeepr
*   sele mkdoc
*   copy to (pathddr+'mkdoc') for mkeep=mkeepr
   sele tmkeep
   skip
endd

nuse('mkrs')
nuse('mkpr')
nuse('mkost')

sele tmkeep
go top
do while !eof()
   cmkeepr=cmkeep
   if select('svost'+cmkeepr)#0
      sele ('svost'+cmkeepr)
      use
   endif
   sele tmkeep
   skip
endd

*nuse('mktov')
*nuse('mkdoc')
nuse('tmkeep')

