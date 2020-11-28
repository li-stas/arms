* Автоматы по таре и внутреннему перемещению,комиссия
* autor=3 без привязки тары
* autor=5 комиссия
netuse('rs1')
netUse('rs3')
netuse('rs2')
if !netseek('t1','ttnr')
   retu
endif
netuse('cskle')
sele rs1
netseek('t1','ttnr',,,1)
pSTr=pST
mnr=amn
ndr=ttnr
sktr=skt
skltr=sklt

if fieldpos('rmsk')#0
   rmskr=rmsk
else
   rmskr=0
endif

store 0 to prTr,prSTr // Признак НДС на тару\ст.тару
store 0 to prkTr,prkSTr // Призн налич т\ст в док (18,19,pr2)

if mode=1.and.autor=2 // Определение формирования автомата по таре
   sele rs2
   if netseek('t1','ttnr')
     // по строкам товара
      do while ttn=ttnr.and.int(ktl/1000000)<2
           if int(ktl/1000000)=0
              if kf#0
                 prkTr=1
              endif
           endif
           if int(ktl/1000000)=1
              if kf#0
                 prkSTr=1
              endif
           endif
         skip
      enddo
   endif
   // по суммам
   if getfield('t1','ttnr,19','rs3','ssf')#0 // Есть тара
      prkTr=1
   endif
   if prkTr=1
      if getfield('t1','ttnr,12','rs3','ssf')#0
         prTr=1 // Не возвратная тара
      endif
   endif
   if getfield('t1','ttnr,18','rs3','ssf')#0 // Есть стеклотара
      prkSTr=1
   endif
   if prkSTr=1.and.pSTr=1
      prSTr=1 // Не возвратная стеклотара
   endif

   prfDocr=0 // Признак формирования документа
   do case
   case prkTr=1.and.prTr=0
     prfDocr=1
   case prkSTr=1.and.prSTr=0
     prfDocr=1
   endcase
   // outlog(__FILE__,__LINE__,'prkTr,prTr',prkTr,prTr,'prkSTr,prSTr',prkSTr,prSTr)
   if prfDocr=0
     If prkTr=1 .or. prkSTr=1 // Ст/Тара  - есть к-во
       wmess('Нет автомата. Ст/Тара - "не возвратная - НДС"',3)
     EndIf
     return
   endif
endif

netUse('tov')
netuse('sgrp')

Pathr=gcPath_tt
netUse('pr1',,,1)

if mode=1
   sele cskl
   netseek('t1','sktr')
   Reclock()
   mnr=mn
   sele pr1
   do while netseek('t2','mnr')
      mnr=mnr+1
   enddo
   sele cskl
   netrepl('mn',{mnr+1})
   netunlock()
   sele pr1
   if netseek('t1','ndr')
      ndr=mnr
   endif
endif

netUse('pr2',,,1)
netUse('pr3',,,1)
netUse('tov','tovt',,1)
if gnCtov=1
   if !netfile('tovm',1)
      copy file (gcPath_a+'tov.dbf') to (pathr+'tovm.dbf')
      netind('tovm',1)
   endif
   netUse('tovm','tovmt',,1)
endif
netUse('sgrp','sgrpt',,1)
if mskltr=1
   netUse('sGrpE','sGrpEt',,1)
endif

*** Данные с rs1 , записать в pr1 *******************
If mode = 1  // Формирование
   SELE RS1
   if netseek('t1','ttnr',,,1)
      netrepl('amn',{mnr},1)
      sklr=skl
      kplr=kpl
      dotr=dot
      vor=vo
      kopr=kop
      pSTr=pST
      dvpr=dvp
      sdvr=sdv
      ktar=kta
      if fieldpos('otn')#0
         otnr=0
         kgnr=0
      else
         otnr=0
         kgnr=0
      endif
      sele pr1
      NetAdd()
      if autor=2.or.autor=1.or.autor=5 // Учет возвратной тары,накладная в подотчет,аренда,комиссия
         if koppr=0
            netrepl('mn,nd,dvp,ddc,tdc,kop,dpr,prz,sdv,skl,kps,sks,skls,kto,amn,vo,pST',;
            {mnr,ndr,dvpr,date(),time(),kopr,dotr,1,sdvr,skltr,gnKkl_c,gnSk,sklr,gnKto,ttnr,vor,pSTr})
         else
            netrepl('mn,nd,dvp,ddc,tdc,kop,dpr,prz,sdv,skl,kps,sks,skls,kto,amn,vo,pST',;
            {mnr,ndr,dvpr,date(),time(),koppr,dotr,1,sdvr,skltr,gnKkl_c,gnSk,sklr,gnKto,ttnr,vor,pSTr})
         endif
         if fieldpos('rmsk')#0
            netrepl('rmsk',{rmskr})
         endif
         if gnVo=10
            netrepl('kta',{ktar})
         endif
      else  // autor=3 Внутренний автомат
         netrepl('nd,mn,ddc,tdc,dvp,vo,kop,prz,sdv,skl,kps,sks,skls,amn,kto,dpr,tpr,pST',;
                 {ndr,mnr,date(),time(),dvpr,vor,koppr,1,sdvr,skltr,gnKkl_c,gnSk,sklr,ttnr,gnKto,dotr,totr,pSTr})
         if fieldpos('rmsk')#0
            netrepl('rmsk',{rmskr})
         endif
      endif
      if fieldpos('dtmod')#0
         netrepl('dtmod,tmmod',{date(),time()})
      endif
   endi
else      //Удаление mode <> 1
   SELE PR1
   if netseek('t2','mnr')
      if amn=ttnr
         netdel()
         prdlr=1
      else
         prdlr=0
      endif
   else
      prdlr=0
   endif
endi

*** Данные с rs3 , записать в pr3 ********************
if mode=1
   SELE RS3
   s905r=0
   netseek('t1','ttnr')
   do whil ttn=ttnr
      kszr=ksz
      if autor=2
         if !(kszr=18.or.kszr=19.or.kszr=90)
            skip
            loop
         endif
         if kszr=18
            if !(prkSTr=1.and.prSTr=0)
               skip
               loop
            endif
         endif
         if kszr=19
            if !(prkTr=1.and.prTr=0)
               skip
               loop
            endif
         endif
      endif
      if autor=5
         if gnKt=0.and.!(kszr=96.or.kszr=97)
            skip
            loop
         endif
         if gnKt=1
            if ksz>90
               skip
               loop
            endif
         endif
      endif
      SELE PR3
      if autor#5.or.autor=5.and.gnKt=1
         NetAdd()
         Replace mn with mnr,ksz with rs3->ksz,ssf with rs3->ssf
      else
         do case
            case kszr=96
                 s905r=s905r+rs3->ssf
                 NetAdd()
                 Replace mn with mnr,ksz with 10,ssf with rs3->ssf
            case kszr=97
                 s905r=s905r+rs3->ssf
                 NetAdd()
                 Replace mn with mnr,ksz with 19,ssf with rs3->ssf
         endc
      endif
      SELE RS3
      skip
   enddo
   if autor=5.and.gnKt=0
      sele pr3
      NetAdd()
      Replace mn with mnr,ksz with 90,ssf with s905r
   endif
else
   if prdlr=1
      SELE PR3
      If netseek('t1','mnr')
         Do while mn=mnr
            netdel()
            skip
         Enddo
      Endif
   endif
endif

*** Данные с rs2 , записать в pr2 ********************
if mode=1
   SELE RS2
   netseek('t1','ttnr')
   do whil ttn=ttnr
      mntovr=mntov
      prktlr=0
      ktlr=ktl
      if fieldpos('ktlkt')#0
         ktlktr=ktlkt
      else
         ktlktr=0
      endif
      ktlpr=ktlr
      pptr=0
      mntovpr=mntovr
      kg_r=int(ktlr/1000000)
      if autor=2
         if !(kg_r=0.or.kg_r=1)
            skip
            loop
         endif
         if kg_r=0.and.prTr=1
            skip
            loop
         endif
         if kg_r=1.and.prSTr=1
            skip
            loop
         endif
      endif
      kfr=kvp
      sfr=svp
      optr=zen
      zenr=zen
      bzenpr=bzenp
      cenktr=zen  // Прайс для комиссии
      if zenr=0
         skip
         loop
      endif

      if autor#3.or.autor=3.and.kgnr=0 // Группа не изменяется
         kgn_r=kg_r
         mntovnr=mntovr
         ktlnr=ktlr
         ktlpnr=ktlpr
         mntovpnr=mntovpr
         if autor=5
            if ktlktr#0
               ktlnr=ktlktr
               ktlpnr=ktlktr
            else
               ktlnr=0
               ktlpnr=0
            endif
         endif
      else
         kgn_r=kgnr
         mntovnr=0
         ktlnr=0
         mntovpnr=0
         ktlpnr=0
      endif

      sele sgrpt
      if !netseek('t1','kgn_r')
         * Добавление новой группы в SGRPT
         if gnCtov=1
            sele cgrp
         else
            sele cgrpk
         endif
         if netseek('t1','kgn_r')
            if int(mntov/10000)#kgn_r
               netrepl('mntov',{kgn_r*10000+1})
            endif
            if int(ktl/1000000)#kgn_r
               netrepl('ktl',{kgn_r*1000000+1})
            endif
            arec:={}
            getrec()
            sele sgrpt
            netadd()
            putrec()
            if otnr#0
               netrepl('ot',{otnr})
            endif
         endif
      endif

      if gnCtov=1
         otr=getfield('t1','sklr,ktlr','tov','ot')
         if otnr=0
            otn_r=otr
         else
            otn_r=otnr
         endif
         sele cskle
         if !netseek('t1','sktr,otn_r')
            * Добавление нового отдела в CSKLE
            if netseek('t1','gnSk,otr')
               arec:={}
               getrec()
               netadd()
               putrec()
               netrepl('sk,ot',{sktr,otn_r})
            endif
         endif
      else
         otr=getfield('t1','sklr,ktlr','tov','ot')
         if otnr=0
            otn_r=otr
         else
            otn_r=otnr
         endif
      endif

      * Присваивание новых кодов
      sele tov
      netseek('t1','sklr,ktlr')
      natr=nat
      izgr=izg
      mntovr=mntov
      opt_rr=opt
      arec:={}
      getrec()
      if ktlnr=0
         * Новые коды
         if autor#5
            if gnCtov=1
               sele ctov
               set orde to tag t5
               if netseek('t5','natr')
                  do while nat=natr
                     if int(mntov/10000)=kgn_r
                        mntovnr=mntov
                        exit
                      endif
                      sele ctov
                      skip
                  enddo
               else
                  mntovnr=0
               endif
               if mntovnr=0
                  sele cgrp
                  if netseek('t1','kgn_r')
                     if int(mntov/10000)#kgn_r
                        netrepl('mntov',{kgn_r*10000+1})
                     endif
                     if int(ktl/1000000)#kgn_r
                        netrepl('ktl',{kgn_r*1000000+1})
                     endif
                     reclock()
                     mntovnr=mntov
                     netrepl('mntov',{mntov+1})
                  endif
               endif
               sele ctov
               if !netseek('t1','mntovnr')
                  netadd()
                  putrec()
                  netrepl('kg,mntov,ot,ktl,osn,osv,osf,osfm,osvo',;
                  {kgn_r,mntovnr,otn_r,0,0,0,0,0,0})
               endif
               sele tovmt
               if !netseek('t1','skltr,mntovnr')
                  netadd()
                  putrec()
                  netrepl('skl,kg,mntov,ot,ktl,osn,osv,osf,osfm,osvo',;
                  {skltr,kgn_r,mntovnr,otn_r,0,0,0,0,0,0})
               endif
            endif
         else // autor=5
            sele cgrp
            if netseek('t1','kgn_r')
               reclock()
               ktlnr=ktl
               netrepl('ktl',{ktl+1})
            endif
         endif
         sele tovt
         if !netseek('t1','skltr,ktlnr')
            if autor=5
               sele tov
               arec:={}
               getrec()
               sele tovt
               netadd()
               putrec()
               netrepl('opt,cenkt',{opt_rr,cenktr})
            else
               netadd()
               putrec()
            endif
            netrepl('skl,kg,mntov,ot,ktl,osn,osv,osf,osfm,osvo',;
            {skltr,kgn_r,mntovnr,otn_r,ktlnr,0,0,0,0,0})
            if gnVo=10.and.gnEnt=21
               netrepl('krstat',{ktar})
            endif
         endif
         if gnCtov=1
            sele tovmt
            if !netseek('t1','skltr,mntovnr')
               netadd()
               putrec()
               netrepl('skl,kg,mntov,ot,ktl,osn,osv,osf,osfm,osvo',;
               {skltr,kgn_r,mntovnr,otn_r,0,0,0,0,0,0})
               if gnVo=10.and.gnEnt=21
                  netrepl('krstat',{ktar})
               endif
            endif
         endif
         ktlpnr=ktlnr
         mntovpnr=mntovnr
      else
         sele tovt
         if !netseek('t1','skltr,ktlnr')
            if autor=5
               sele tov
               arec:={}
               getrec()
               sele tovt
               netadd()
               putrec()
               netrepl('opt,cenkt',{opt_rr,cenktr})
            else
               netadd()
               putrec()
            endif
            netrepl('skl,kg,mntov,ot,ktl,osn,osv,osf,osfm,osvo',;
            {skltr,kgn_r,mntovnr,otn_r,ktlnr,0,0,0,0,0})
            if gnVo=10.and.gnEnt=21
               netrepl('krstat',{ktar})
            endif
         else
            if autor=5
               netrepl('opt,cenkt',{opt_rr,cenktr})
            endif
         endif
      endif
      *** Коpекция остатков **************************************
      sele tovt
      if netseek('t1','skltr,ktlnr')
         osn_rr=osn
         osv_rr=osv+kfr
         osf_rr=osf+kfr
         osfm_rr=osfm+kfr
         osfo_rr=osfo+kfr
         if koppr=188
            if fieldpos('osfop')#0
               osfop_rr=osfop+kfr
            else
               osfop_rr=0
            endif
         else
            osfop_rr=0
         endif
         netrepl('osn,osv,osf,osfm,osfo,skl',;
         {osn_rr,osv_rr,osf_rr,osfm_rr,osfo_rr,skltr})
         if fieldpos('osfop')#0
            netrepl('osfop',{osfop_rr})
         endif
         if gnKt=0.and.autor=5
            if fieldpos('skkt')#0
               netrepl('skkt,ttnkt,dtkt,ktlkt',{skr,ttnr,dotr,ktlr})
            endif
            if fieldpos('mnkt')#0
               netrepl('mnkt',{mnr})
            endif
         endif
         if gnVo=10.and.gnEnt=21
            netrepl('krstat',{ktar})
         endif
      else
         netadd()
         putrec()
         netrepl('skl,kg,mntov,ot,ktl,osn,osv,osf,osfm,osvo,osfo',;
         {skltr,kgn_r,mntovnr,otn_r,ktlnr,0,kfr,kfr,kfr,0,kfr})
         if autor=5
            if fieldpos('skkt')#0
               netrepl('skkt,ttnkt,dtkt,ktlkt,cenkt',;
               {skr,ttnr,dotr,ktlr,cenktr})
            endif
            if fieldpos('mnkt')#0
               netrepl('mnkt',{mnr})
            endif
         endif
         if koppr=188
            if fieldpos('osfop')#0
               netrepl('osfop',{kfr})
            endif
         endif
         if gnVo=10.and.gnEnt=21
            netrepl('krstat',{ktar})
         endif
      endif
      if dpp<dotr
         netrepl('dpp',{dotr})
      endif
      if gnCtov=1
         sele tovm
         netseek('t1','sklr,mntovr')
         arec:={}
         getrec()
         sele tovmt
         if netseek('t1','skltr,mntovnr')
            osn_rr=osn
            osv_rr=osv+kfr
            osf_rr=osf+kfr
            osfm_rr=osfm+kfr
            osfo_rr=osfo+kfr
            reclock()
            if koppr=188
               if fieldpos('osfop')#0
                  osfop_rr=osfop+kfr
               else
                  osfop_rr=0
               endif
            else
               osfop_rr=0
            endif
            putrec()
            netrepl('osn,osv,osf,osfm,osfo,skl',{osn_rr,osv_rr,osf_rr,osfm_rr,osfo_rr,skltr})
            if fieldpos('osfop')#0
               netrepl('osfop',{osfop_rr})
            endif
         else
            netadd()
            putrec()
            netrepl('osn,osv,osf,osfm,osfo,skl',{0,kfr,kfr,kfr,kfr,skltr})
            if koppr=188
               if fieldpos('osfop')#0
                  netrepl('osfop',{kfr})
               endif
            endif
         endif
         if dpp<dotr
            netrepl('dpp',{dotr})
         endif
         ** Обновление цен ***
         if autor#5
            sele ctov
            if netseek('t1','mntovr')
               sele tcen
               go top
               do while !eof()
                  if ent#gnEnt
                     sele tcen
                     skip
                     loop
                  endif
                  czenr=alltrim(zen)
                  sele ctov
                  zen_r=&czenr
                  sele tovt
                  netrepl(czenr,{zen_r})
                  sele tovmt
                  netrepl(czenr,{zen_r})
                  sele tcen
                  skip
               enddo
            endif
         endif
         ******************
      endif

      * Приход
      sele pr2
      set orde to tag t3
      if !netseek('t3','mnr,ktlpnr,pptr,ktlnr')
         netadd()
         netrepl('mn,mntov,ktlp,ppt,ktl,kf,sf,zen,izg',;
                 {mnr,mntovnr,ktlpnr,pptr,ktlnr,kfr,sfr,zenr,izgr})
         if gnKt=0.and.autor=5
            netrepl('zen',{opt_rr})
            sfr=roun(kf*zen,2)
            netrepl('sf',{sfr})
         endif
      else
         netrepl('kf,sf',;
                 {kf+kfr,sf+sfr})
         if gnKt=0.and.autor=5
            netrepl('zen',{opt_rr})
            sfr=roun(kf*zen,2)
            netrepl('sf',{sfr})
         endif
      endif
      sele rs2
      if fieldpos('ktlkt')#0
         netrepl('ktlkt',{ktlnr})
      endif
      skip
   enddo
else
   if prdlr=1
      SELE PR2 // Удаление
      If netseek('t1','mnr')
         do while mn=mnr
            mntovr=mntov
            ktlr=ktl
            kfr=kf
            netdel()
            SELE tovt
            if netseek('t1','skltr,ktlr')
               netrepl('osv,osf,osfm,osfo',{osv-kfr,osf-kfr,osfm-kfr,osfo-kfr})
               if koppr=188
                  if fieldpos('osfop')#0
                     netrepl('osfop',{osfop-kfr})
                  endif
               endif
            endif
            if gnCtov=1
               sele tovmt
               if netseek('t1','skltr,mntovr')
                  netrepl('kg,osv,osf,osfm,osfo',{int(mntovr/10000),osv-kfr,osf-kfr,osfm-kfr,osfo-kfr})
                  if koppr=188
                     if fieldpos('osfop')#0
                        netrepl('osfop',{osfop-kfr})
                     endif
                  endif
               endif
            endif
            SELE PR2
            skip
         enddo
      EndIf
   endif
endif
unlock all
nuse('pr1')
nuse('pr2')
nuse('pr3')
nuse('tovt')
nuse('tovmt')
nuse('sgrpt')
nuse('sGrpEt')
retu

