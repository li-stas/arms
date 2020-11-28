#include "common.ch"
#include "inkey.ch"
#Define ZEN_PRACE
* Отбор товара в расходный документ,коррекция,удаление
para corr,prw
local rccmr,alssmr
alssmr=''
rccmr=0
if autor=3.and.gnSk=sktr.and.(int(mntovr/10000)=kgnr.or.kgnr=0)
   wmess('Операция запрещена',2)
   retu
endif

alssmr=alias()
rccmr=recn()

if corr=nil
   corr=1
endif

prowr=0     // Для pozktl()
alssr='RS2' // Для pozktl()

if corr#2.and.!(gnVo=5.or.gnVo=6).and.gnArm=3.and.!(kopr=169.or.kopr=151)
   sele sgrp
   if fieldpos('lic')#0
      licr=getfield('t1','int(mntovr/10000)','sgrp','lic')
      if licr#0
         sele klnlic
         if netseek('t1','kplr')
            lic_mr=0
            do while kkl=kplr
               if lic#licr
                  skip
                  loop
               endif
               if !(gdTd>=dnl.and.gdTd<=dol)
                  skip
                  loop
               else
                  lic_mr=1
                  exit
               endif
               skip
            enddo
            if lic_mr=0
               wmess('У этого клиента истек срок лицензии')
               retu
            endif
         else
            wmess('У этого клиента нет лицензий')
            retu
         endif
      endif
   endif
endif

cor_r=corr // Действие : Отобрать - 0 Коррекция - 1  Удаление  - 2
if prw=nil
   prowmr=1 // Признак открытия окна при коррекции,отборе
else
   prowmr=0 // Признак открытия окна при коррекции,отборе
endif

if cor_r=2
   prowmr=0
endif

if prowmr=1
   cltovkol=setcolor('w+/rb+,n/w')
   ww=wopen(5,1,20,78,.t.)
   wbox(1)
   prowmr=1
endif

rvkvpmr=0
store 0 to mntov_mr,m1t_mr,ppt_mr

if PozKtlM(mntovr,mntovr)
   sele rs2m
   rcrs2mr=recn()
   if int(mntovr/10000)>1
      do while m1t_mr#0
         ppt_mr=1
         if !PozKtlM(m1t_mr,mntovr)
            exit
         endif
      enddo
   endif
endif

if prowmr=1
   wclose(ww)
   setcolor(cltovkol)
endif
sele (alssmr)
go rccmr

***************************************************************************
static function PozKtlM(p1,p2)
* p1 - код товара
* p2 - код родителя
***************************************************************************
local nzap
mntov_mr=p1
mntovp_mr=p2
store 0 to osv_mr,osvo_mr,osfm_mr,osfo_mr,kvp_mr,koll_mr,;
        zen_mr,bzen_mr,xzen_mr,zenr,bzenr,xzenr
if prowr=1
   kol_mr=0
else
   if cor_r=2
      kol_mr=0
   endif
endif
store '' to nat_mr
sele tovm
if !netseek('t1','sklr,mntov_mr',,,1)
   wmess(str(sklr,7)+' '+str(mntov_mr,7)+' Не найден в TOVM',1)
   retu .f.
endif
* Блокировка карточки TOVM
sele tovm
if !reclock(1)
   avib=alert('Запись занята',{'Ждать','Пропустить'})
   if avib=1
      reclock()
   else
      retu .f.
   endif
endif
osvo_mr=osvo
osfm_mr=osfm
osv_mr=osv
osf_mr=osf
osfo_mr=osfo
nat_mr=alltrim(nat)
upak_mr=upak
upakp_mr=upakp
m1t_mr=m1t
nei_mr=nei
kge_mr=kge
izg_mr=izg
ves_mr=ves

cenpr_mr=cenpr

zen_mr=&coptr        // Первая цена по OPER

if pbzenr=1
   bzen_mr=&cboptr   // Вторая цена по OPER
endif

if pxzenr=1.and.!empty(cxoptr)
   xzen_mr=&cxoptr   // Вторая цена по OPER
endif

if prowmr=1
   @ rvkvpmr,1 say subs(str(mntov_mr,7)+' '+alltrim(getfield('t1','kge_mr','GrpE','nge'))+' '+nat_mr+iif(upak_mr#0,' 1/'+kzero(upak_mr,10,3),'')+iif(upakp_mr#0,'/'+kzero(upakp_mr,10,3),''),1,73)
   rvkvpmr++
endif

sele rs2m
store 0 to zenr,bzenr,xzenr,koll_mr,rs2sert_mr,svpcr

if prowr=1
   kol_mr=0
else
   if cor_r=2
      kol_mr=0
   endif
endif

if netseek('t3','ttnr,mntovp_mr,0,ppt_mr,mntov_mr,0')
   if cor_r=0
      cor_r=1
   endif
   kol_mr=kvp
   koll_mr=kvp   // До коррекции
   zenr=zen     // Первая цена по rs2m
   bzenr=bzen   // Вторая цена по rs2m
   if fieldpos('xzen')#0
      xzenr=xzen
   endif
   rs2sert_mr=sert
endif

if zenr=0
   zenr=zen_mr
endif

if bzenr=0
   bzenr=bzen_mr
endif

if xzenr=0
   xzenr=xzen_mr
endif

if cor_r#2.and.prowr=1
   do while lastkey()#27
      if empty(dotr)
         @ rvkvpmr,1 say 'Остаток '+str(osv_mr+osvo_mr,10,3)
         if ppsfr=0.or.(ppsfr#0.and.who#2)
            @ rvkvpmr,col()+1 say 'Количество' get kol_mr pict '999999.999'
         else
            @ rvkvpmr,col()+1 say 'Количество'+' '+str(kol_mr,10,3)
         endif
      else
         if who=2
            @ rvkvpmr,1 say 'Остаток '+str(osv_mr+osvo_mr,10,3)+'Количество '+str(kol_mr,10,3)
         else
            @ rvkvpmr,1 say 'Остаток '+str(osv_mr+osvo_mr,10,3)
            if ppsfr=0.or.(ppsfr#0.and.who#2)
               @ rvkvpmr,col()+1 say 'Количество' get kol_mr pict '999999.999'
            else
               @ rvkvpmr,col()+1 say 'Количество'+' '+str(kol_mr,10,3)
            endif
         endif
      endif
      if gnCenr=1.and.(who=2.or.who=3.or.who=4).or.gnAdm=1
         do case
            case prZen2r=0
                 @ rvkvpmr,col()+1 say 'Цена1' get zenr pict '999999.999' valid  chkzen1(mntov_mr*100)
            case prZen2r=1
                 @ rvkvpmr,col()+1 say 'Цена2' get bzenr pict '999999.999' valid chkzen2(mntov_mr*100)
            case prZen2r=2
                 @ rvkvpmr,col()+1 say 'Цена3' get xzenr pict '999999.999' valid chkzen3(mntov_mr*100)
         endc
      else
         @ rvkvpr,col()+1 say 'Цена '+str(zenr,10,3)
      endif
      colprZenr=col()+1
      if int(mntov_mr/10000)>1
         if gnCenr=1.and.(who=2.or.who=3.or.who=4).or.gnAdm=1
            do case
               case prZen2r=0
                    @ rvkvpmr,col()+1 say 'Скидка1 '+str(prZenr,6,2)
               case prZen2r=1
                    @ rvkvpmr,col()+1 say 'Скидка2 '+str(prBZenr,6,2)
               case prZen2r=2
                    @ rvkvpmr,col()+1 say 'Скидка3 '+str(prXZenr,6,2)
            endc
         else
            @ rvkvpmr,col()+1 say 'Скидка '+str(prZenr,6,2)
         endif
      endif
      if empty(getlist)
         wmess('Для продолжения нажмите Пробел',0)
      else
         read
         @ rvkvpmr-1,colprZenr say 'Скидка '+str(prZenr,6,2)
      endif
      read
      rvkvpmr++
      if kol_mr<0
         zenr=zen_mr
         loop
      endif
      if zenr=0
         wmess('ВНИМАНИЕ!!! Цена нулевая',1)
      endif
      exit
   enddo
   rvkvpmr++

   if lastkey()=K_ESC
      sele tovm
      netunlock()
      retu .f.
   endif
endif

if (osv_mr+osvo_mr+koll_mr-kol_mr)<0
   wmess('Остатка недостаточно',1)
   sele tovm
   netunlock()
   retu .f.
else
   kollr=kol_mr
   if ppt_mr=0
      sele tov
      set orde to tag t5
      if netseek('t5','sklr,mntov_mr')
         do while skl=sklr.and.mntov=mntov_mr
            rctvr=recn()
            ktl_mr=ktl
            sele rs2
            if netseek('t3','ttnr,ktl_mr,ppt_mr,ktl_mr')
               kvp_mr=kvp
               rccr=recn() // Для pozktl()
               rcrs2r=recn()
            else
               kvp_mr=0
               rccr=1      // Для pozktl()
            endif
            sele tov
            if osv+osvo+kvp_mr-kollr>=0
               kol_r=kollr
               kollr=0
            else
               kol_r=kvp_mr+osv+osvo
               kollr=kollr-osv-osvo-kvp_mr
            endif
            if kollr>0.and.(kol_r=0.or.kol_r=kvp_mr).and.cor_r#2
               sele tov
               skip
               loop
            endif
            ppt_r=0
            pozktl(ktl_mr,ktl_mr)
            sele tov
            go rctvr
            skip
         endd
      endif
   else
      ppt_r=1
      sele rs2
      set orde to tag t2
      if netseek('t2','ttnr,mntovp_mr')
         do while ttn=ttnr.and.mntov=mntovp_mr
            rcrs2_mrr=recn()
            ktlp_mr=ktl
            sele tov
            set orde to tag t5
            if netseek('t5','sklr,mntov_mr')
               do while skl=sklr.and.mntov=mntov_mr
                  rctvr=recn()
                  ktl_mr=ktl
                  sele rs2
                  if netseek('t3','ttnr,ktlp_mr,ppt_mr,ktl_mr')
                     kvp_mr=kvp
                     rccr=recn() // Для pozktl()
                  else
                     kvp_mr=0
                     rccr=1      // Для pozktl()
                  endif
                  sele tov
                  if osv+osvo+kvp_mr-kollr>=0
                     kol_r=kollr
                     kollr=0
                  else
                     kol_r=osv
                     kollr=kollr-kol_r
                  endif
                  ppt_r=1
                  PozKtl(ktl_mr,ktlp_mr)
                  sele tov
                  go rctvr
                  skip
               endd
            endif
            sele rs2
            set orde to tag t2
            go rcrs2_mrr
            skip
         endd
      endif
   endif
endif
sele tovm
netunlock()
retu .t.


