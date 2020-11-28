* Формирование неподтвержденного прихода автомата в предприятиях SETUPа
* ttnr определяется в вызывающей подпрограмме
* Исходный документ может формировать :
* Один внешний автомат (RPRHP) в чужом предприятии
* ctov=1
*******************************
* Определение адреса назначения
*******************************

sele menent
locate for ent=entpr
if !FOUND()  // Предприятие не описано в SETUP
   wmess('Предприятие не описано в SETUP')
   retu
endif
commr=comm
nentpr=uss
direpr=alltrim(nent)+'\'
if commr=0
   pathemr=gcPath_ini
else
   pathemr=gcPath_ini+direpr
endif
pathepr=pathemr+direpr
pathecr=pathemr+gcDir_c

pathr=pathecr
netuse('cskl','ecskl',,1)
*sele 0
*use (pathecr+'cskl') alias ecskl

coptpr='opt'+iif(entpr<10,'0'+str(entpr,1),str(entpr,2))
cdoptpr='dopt'+iif(entpr<10,'0'+str(entpr,1),str(entpr,2))
cmntovpr='mntov'+iif(entpr<10,'0'+str(entpr,1),str(entpr,2))

* ECSKL
sele ecskl
locate for sk=sktpr
if !FOUND() // Не описан склад-назначение в CSKL
    wmess('Не описан склад-назначение в CSKL')
    retu
endif
if ctov#1
    wmess('CTOV склада-назначения # 1')
    retu
endif

dirtpr=alltrim(path)
pathtpr=pathepr+gcDir_g+gcDir_d+dirtpr

if !file(pathtpr+'tprds01.dbf') // Нет директории назначения
   wmess('Нет склада назначения')
   retu
endif

mskltpr=mskl
if mskltpr=0
   skltpr=skl
else
   skltpr=kgpr
endif


****************************
* Открытие таблиц назначения
****************************

pathr=pathtpr
netuse('pr1',,,1)
netuse('pr2',,,1)
netuse('pr3',,,1)
netuse('tov','tovp',,1)
netuse('tovm','tovmp',,1)
netuse('sgrp','sgrpp',,1)
netuse('soper','soperp',,1)

sele dbft
locate for als=='ctov'

if dir=1
   prctovr=1 // Общий спр.товара для всех предпр лок.сети с ctov=1
else
   prctovr=0
endif

if prctovr=0
   pathr=pathepr
   netuse('ctov','ctovp',,1)
   netuse('cgrp','cgrpp',,1)
endif

********************************************************************
* cor1_r=nil // Сформировать документ
********************************************************************
if mode=1

** Сформировать PR1

   * Поля для PR1
   praddpr1r=1
   prndr=0
   sele pr1
   if netseek('t1','ttnr')
      if amnp=ttnr
         amnpr=mn
         mnr=mn
         ndr=ttnr
         praddpr1r=0
      else
         prndr=1
      endif
   endif

   dprr=dotr

   if praddpr1r=1
      store mn to mnr,amnpr

      sele ecskl
      netseek('t1','sktpr')
      reclock()
      if prndr=0
         ndr=ttnr
      else
         ndr=mnr
      endif
      if mn<999999
         netrepl('mn',{mn+1})
      else
         netrepl('mn',{1})
      endif

   endif

   sele pr1
   if praddpr1r=1
      netadd()
      netrepl('mn,nd,skl,kps,dpr,entp,sksp,sklsp,amnp',;
           'mnr,ndr,skltpr,gnKkl_c,dotr,gnEnt,gnSk,sklr,ttnr')
   else
      netrepl('kps,dpr,entp,sksp,sklsp',;
           'gnKkl_c,dotr,gnEnt,gnSk,sklr')
   endif
   netrepl('kop,vo','koppr,vor')

   sele rs1
   netrepl('amnp','amnpr',1)

** Сформировать PR3
   sele rs3
   if netseek('t1','ttnr')
      do whil ttn=ttnr
         kszr=ksz
         ssfr=ssf
         bssfr=bssf
         prr=pr
         bprr=bpr
         sele pr3
         if !netseek('t1','mnr,kszr')
            netadd()
            netrepl('mn,ksz,ssf,pr,bssf,bpr','mnr,kszr,ssfr,prr,bssfr,bprr')
         endif
         sele rs3
         skip
      endd
   endif
** Сформировать PR2,TOVP,TOVMP,CTOVP
   sele rs2
   if netseek('t1','ttnr')
      do while ttn=ttnr
         mntovr=mntov
         mntovpr=mntovp
         ktlr=ktl
         ktlpr=ktlp
         pptr=ppt
         kfr=kvp
         sfr=svp
         zenr=zen
         bzenr=bzen
         srr=sr
         kgrr=int(ktlr/1000000)
         otr=getfield('t1','sklr,ktlr','tov','ot')
         if kgrr>1 // Товар
            if kgnr=0 // В ту же группу товара
               kgnr=kgrr
               if prctovr=0
                  sele cgrpp
                  if !netseek('t1','kgnr')
                     sele cgrp
                     netseek('t1','kgrr')
                     arec:={}
                     getrec()
                     sele cgrpp
                     netadd()
                     putrec()
                  endif
               endif
               sele sgrpp
               if !netseek('t1','kgnr')
                  sele sgrp
                  netseek('t1','kgrr')
                  arec:={}
                  getrec()
                  sele sgrpp
                  netadd()
                  putrec()
               endif
            endif
         else
            kgnr=kgrr
         endif
         if otnr=0
            otnr=otr
         endif

         if prctovr=0.or.kgnr#kgrr.and.kgrr>1
            * Сформировать новые MNTOV,KTL
            sele tov
            if netseek('t1','sklr,ktlr')
               natr=nat
               mntovr=mntov
               izgr=izg
               * Синхронизация CTOV<->CTOVP
               sele ctov
               netseek('t1','mntovr')
               if mntovr#0.and.mntov#mntovr
                  wmess('Индекс CTOV',3)
                  quit
               endif
               arec:={}
               getrec()
               nmntovr=&cmntovpr
               if prctovr=0
                  sele ctovp
               else
                  sele ctov
               endif
               if empty(nmntovr) // Нет связи с CTOVP
                  set orde to tag t5
                  if netseek('t5','natr')
                     if nat#natr
                        wmess('Индекс CTOVP',3)
                        quit
                     endif
                     do while nat=natr
                        if int(mntov/10000)=kgnr
                           nmntovr=mntov
                           exit
                        endif
                        skip
                     endd
                  else
                     nmntovr=0
                  endif
                  set orde to tag t1
               else
                  if !netseek('t1','nmntovr')
                     nmntovr=0
                  else
                     if mntov#nmntovr
                        wmess('Индекс CTOVP',3)
                        quit
                     else
                        if nat#natr
                           nmntovr=0
                        endif
                     endif
                  endif
               endif
                if !empty(nmntovr)
                   sele ctov
                   netrepl(cmntovpr,'nmntovr')
                endif
                if prctovr=0
                   sele cgrpp
                else
                   sele cgrp
                endif
                netseek('t1','kgnr')
                if nmntovr=0
                   if mntov<kgr*10000
                      netrepl('mntov','kgr*10000+1')
                   endif
                   reclock()
                   nmntovr=mntov
                   netrepl('mntov','mntov+1')
                   sele ctovp
                   netadd()
                   putrec()
                   netrepl('mntov','nmntovr')
                   netrepl(cmntovpr,'nmntovr')
                   netrepl(gcMntov,'mntovr')
                   sele ctov
                   netrepl(cmntovpr,'nmntovr')
                endif
             endif
         else  // Общий спр.товара для всех предпр лок.сети с ctov=1
            nmntovr=mntovr
         endif
         sele tovmp
         if !netseek('t1','skltpr,nmntovr')
            netadd()
            putrec()
            netrepl('skl,mntov,osn,osv,osf,osvo,osfm','skltpr,nmntovr,0,0,0,0,kfr')
         else
            netrepl('osfm','osfm+kfr')
         endif
         sele ctov
         netrepl(cmntovpr,'mntovpr')
         if prctovr=0.or.kgnr#kgrr.and.kgrr>1
            sele cgrpp
            if ktl<kgr*1000000
               netrepl('ktl','kgr*1000000+1')
            endif
            reclock()
            ktlnr=ktl
            netrepl('ktl','ktl+1')
         else
            ktlnr=ktlr
         endif
         sele tov
         netseek('t1','sklr,ktlr')
         arec:={}
         getrec()
         sele tovp
         if !netseek('t1','skltpr,ktlnr')
            netadd()
            putrec()
            netrepl('skl,ktl,mntov,osn,osv,osf,osvo,osfm,prsk,prmn,prktl,post,opt','skltpr,ktlnr,nmntovr,0,0,0,0,kfr,sktpr,mnr,ktlnr,gnKkl_c,zenr')
         endif
         sele pr2
         if !netseek('t1','mnr,ktlnr')
            netadd()
            netrepl('mn,ktl,mntov,kf,sf,zen,bzen,ktlp,ppt,sr,izg,ktlm,ktlmp',;
                    'mnr,ktlnr,nmntovr,kfr,sfr,zenr,bzenr,ktlnr,pptr,srr,izgr,ktlr,ktlr')
         endif
         sele rs2
         netrepl('ktlm,ktlmp','ktlnr,ktlnr')
         skip
      endd
   endif
endif
********************************************************************
* mode=2 // Удалить документ
********************************************************************
if mode=2
   sele pr3
   if netseek('t1','amnpr')
      do while mn=amnpr
         netdel()
         skip
      enddo
   endif
   sele pr2
   if netseek('t1','amnpr')
      do while mn=amnpr
         ktlnr=ktl
         mntovpr=mntov
         kfr=kf
         sele tovp
         if netseek('t1','skltpr,ktlnr')
            netrepl('osfm','0')
         endif
         sele tovmp
         if netseek('t1','skltpr,mntovpr')
            netrepl('osfm','osfm-kfr')
         endif
         sele pr2
         netdel()
         skip
      enddo
   endif
   sele pr1
   if netseek('t1','amnpr')
      netdel()
   endif
   sele rs1
   netrepl('amnp','0')
endif
********************************************************************
nuse('pr1')
nuse('pr2')
nuse('pr3')
nuse('tovp')
nuse('tovmp')
nuse('sgrpp')
nuse('sGrpEp')
nuse('ctovp')
nuse('cgrpp')
nuse('soperp')
if select('ecskl')#0
   sele ecskl
   use
endif
retu
