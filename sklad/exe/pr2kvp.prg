#include "common.ch"
#include "inkey.ch"
#translate  uktr() => iif(!empty(uktr),' /'+alltrim(uktr)+' / '+LTRIM(STR(kprodr)),'')
#define SOX_DATE_CORR STOD('20191002') // дал коррекцию СОХ,Коррекция
//  Кол-во,цена товара в приходном документе,коррекция,удаление
//  Перекодировка отв.хр.
//
**********************************************************************
// Если количество равно 0 ,делается попытка удаления из основного.
**********************************************************************
para corr
local rccr,alssr
alssr=alias()
rccr=recn()
cor_r=corr // Действие : Отобрать - 0 Коррекция - 1  Удаление  - 2

if cor_r=0
   cor_r=1
endif

prowr=1 // Признак открытия окна при коррекции,отборе
if cor_r=2
   if NdOtvr#0
      return
   endif
   prowr=0 // Не открывать окно при удалении позиции
endif
if prowr=1
   cltovkol=setcolor('w+/rb+,n/w')
   ww=wopen(5,1,20,78,.t.)
   wbox(1)
   prowr=1
endif
if NdOtvr=3
   netuse('rs1')
   netuse('rs2')
endif
do while .t.
   rvkvpr=0
   store 0 to ktl_r,k1t_r,ppt_r,mnotvr
   if !PozKtl(ktlr,ktlr)
      exit
   endif
   sele pr2
   rcpr2_r=recn()
   do while k1t_r#0 //.and.!(gnVo=9.or.gnVo=6.and.((kopr=168.or.kopr=185).and.(gnEnt=14.or.gnEnt=15.or.gnEnt=17).or.kopr=120.and.gnEnt=16))
      ppt_r=1
      if !PozKtl(k1t_r,ktlr)
         exit
      endif
   enddo
   exit
enddo

sele tov
netunlock()

if prowr=1
   wclose()
   setcolor(cltovkol)
endif
if NdOtvr=3
   nuse('rs1')
   nuse('rs2')
endif

sele (alssr)
go rccr
return

***************************************************************************
static function PozKtl(p1,p2)  // Редактирование позиции
  // p1 - код товара
  // p2 - код родителя
  ***************************************************************************
  ktl_r=p1
  ktlp_r=p2
  mntov_r=getfield('t1','sklr,ktl_r','tov','mntov')
  if pr1->otv=0.and.gnCtov=1
     sele mkeep
     if fieldpos('blkmk')#0
        mkeep_r=getfield('t1','mntov_r','ctov','mkeep')
        if mkeep_r#0
           blkmk_r=getfield('t1','mkeep_r','mkeep','blkmk')
           if blkmk_r=1.and.!(kopr=111.and.vor=6)
              wmess('МД '+str(mkeep_r,3)+' блокирован',2)
              return .t.
           endif
        endif
     endif
  endif

  mntovp_r=getfield('t1','sklr,ktlp_r','tov','mntov')

  store 0 to kol_r,osv_r,rcn_r1,kf_r,sf_r,kol_rr,zen_r,bzen_r,sr_r,zenr,bzenr,;
          prpcoder
  store '' to nat_r

  if gnCtov=2.and.cor_r=0 // Отбор из TOVD
  //   otbe(ktl_r)          // Добавление в основной из TOVD
     cor_r=1
  endif

  if gnCtov=1
     sele tovm
     rcTovmr=recn()
     if !netseek('t1','sklr,mntov_r')
       wmess('tovm->(sklr,mntov_r)'+' не найден',2)
       return .f.
     endif
     if !reclock(1)
       wmess('tovm->(sklr,mntov_r)'+' блокирован',2)
       return .f.
     endif
  endif
  sele tov
  rcn_r1=recn()
  if !netseek('t1','sklr,ktl_r')
     wmess('tov->(sklr,ktl_r)'+' не найден',2)
     return .f.
  endif
  if !reclock(1)
     wmess('tov->(sklr,ktl_r)'+' блокирован',2)
     return .f.
  endif
  if fieldpos('blkkpk')#0
     blkkpk_r=blkkpk
  else
     blkkpk_r=0
  endif
  mntov_r=mntov
  kg_r=int(mntov_r/10000)
  mntovp_r=getfield('t1','sklr,ktlp_r','tov','mntov')
  nat_r=alltrim(nat)
  upak_r=upak
  upakp_r=upakp
  if upakp_r=0.and.gnSkotv#0
     wselect(0)
     save scre to scmess
     mess('Нет упаковки поставщика',1)
     rest scre from scmess
     wselect(ww)
     return .f.
  endif
  k1t_r=k1t

  if gnVo=9.and.kpsbbr=1.and.int(k1t_r/1000000)#1
     prbb_r=getfield('t1','kg_r','cgrp','prbb')
  else
     prbb_r=0
  endif

  osv_r=osv
  osf_r=osf
  osfm_r=osfm
  osvo_r=osvo
  nei_r=nei
  kge_r=kge
  optr_r=opt
  if fieldpos('cenbb')#0
     cenbb_r=cenbb
     cenbt_r=cenbt
  else
     cenbb_r=0
     cenbt_r=0
  endif
  otv_r=otv           // Признак отв хран
  zen_r=&coptr        // Первая цена по OPER->TOV
  izg_r=izg
  post_r=post
  if pbzenr=1
     bzen_r=&cboptr   // Вторая цена по OPER->TOV
  endif
  if prowr=1
    uktr=getfield('t1','mntov_r','ctov','ukt')
    // поиск кода продукции fin/prd.prg
    kprodr:=0 ;  vidr:=""
    kprod->(KProd_KodVid(uktr,@kprodr,@vidr))

     @ rvkvpr,1 say subs(str(ktl_r,9);
     + ' ' + alltrim(getfield('t1','kge_r','GrpE','nge'));
     + ' ' + nat_r+iif(upak_r#0,' 1/'+kzero(upak_r,10,3),' 1/');
     + iif(upakp_r#0,'/'+kzero(upakp_r,10,3),'');
     + uktr(),1,73)
     rvkvpr++
  endif

  if gnCtov=1
  sele tovm
  if fieldpos('cenbb')#0
     cenbb_r=cenbb
     cenbt_r=cenbt
  else
     sele ctov
     if netseek('t1','mntov_r')
        if fieldpos('cenbb')#0
           cenbb_r=cenbb
           cenbt_r=cenbt
        else
           cenbb_r=0
           cenbt_r=0
        endif
     else
        cenbb_r=0
        cenbt_r=0
     endif
  endif
  endif

  sele pr2
  store 0 to zenr,bzenr,ozenr,zenbbr,zenbtr

  if netseek('t3','mnr,ktlp_r,ppt_r,ktl_r')
     kf_r=kf      // Количество
     kol_r=kf     // Количество первоначальное
     ktlmr=ktlm   // Товар - источник
     ktlmpr=ktlmp // Привязка - источник
     zenr=zen     // Первая цена по pr2
     if fieldpos('kfttn')#0
        zenprr=zenpr
        zenttnr=zenttn
        kfttnr=kfttn
     else
        zenprr=0
        zenttnr=0
        kfttnr=0
     endif
     zen_rr=zen   // Цена первоначальноя
     bzenr=bzen   // Вторая цена по pr2
     ozenr=ozen
     kfor=kfo     // Реальный расход в отчете отв.хр.(NdOtv=3)
     if fieldpos('zenbb')#0
        zenbbr=zenbb // цена по pr2 без бутылки
        zenbtr=zenbt // цена по pr2 бутылки
     else
        zenbbr=0
        zenbtr=0
     endif
  endif

  if zenr=0.and.prVzznr=0
     zenr=zen_r
  endif

  if prbb_r=1
     if zenbbr=0
        zenbbr=cenbb_r
     endif
     if zenbtr=0
        zenbtr=cenbt_r
     endif
  endif

  if pbzenr=1
     if bzenr=0
        bzenr=bzen_r
     endif
  endif

  //if gnSkotv#0 //gnOtv=1
  //   zenr=0.01
  //   bzenr=0.01
  //endif

  if cor_r=2.and.gnArm=3
     pro(5,ktl_r,ktlp_r)
     kf_r=0
  endif

  if cor_r#2
     if prVzznr=0
        if NdOtvr=4
           @ rvkvpr,1 say 'Остаток '+str(osvo_r,10,3)
        else
           @ rvkvpr,1 say 'Остаток '+str(osf_r,10,3)
        endif
        if ((NdOtvr=0.or.NdOtvr=4).and.prVzznr=0) ;
          .or. (NdOtvr=3 .and. date() = SOX_DATE_CORR) // дал коррекцию
           @ rvkvpr,col()+1 say 'Количество ' GET kf_r valid OtvKf() pict '999999.999'
        else
           if prVzznr=0
              @ rvkvpr,col()+1 say 'Количество '+' '+str(kf_r,10,3)
           else
              @ rvkvpr,col()+1 say 'Количество '+' '+str(kfttnr,10,3)
           endif
        endif
     else
        if kopr=110
           @ rvkvpr,1 say 'Количество ' GET kfttnr pict '999999.999'
        else
           @ rvkvpr,1 say 'Цена Поставки '+str(zenttnr,10,3)
        endif
     endif
     if who#1
        sele tov
        if gnCtov=0
           if month(dpo)=month(gdTd).and.year(dpo)=year(gdTd).or.osn#0;
              .or.month(dpp)=month(gdTd).and.year(dpp)=year(gdTd)
              @ rvkvpr,col()+1 say 'Цена '+str(zenr,10,3)
           else
              if gnAdm=1
                 @ rvkvpr,col()+1 say 'Цена' get zenr pict '999999.999'
              else
                 @ rvkvpr,col()+1 say 'Цена '+str(zenr,10,3)
              endif
           endif
        else
           if NdOtvr#3 //otvr=0.or.otvr=1.or.otvr=2
              if gnVo=9 //.or.gnVo=6.and.((kopr=168.or.kopr=185).and.(gnEnt=14.or.gnEnt=15.or.gnEnt=17.or.gnEnt=20.or.gnEnt=21).or.kopr=120.and.gnEnt=16)
                 if ktlp_r=ktl_r //.and.int(ktl_r/1000000)>1
                    if prbb_r=0
                       @ rvkvpr,col()+1 say 'Цена' get zenr pict '999999.999' valid bcen()
                    else
                       @ rvkvpr,col()+1 say 'ЦТов' get zenbbr pict '9999.999'
                       @ rvkvpr,col()+1 say 'ЦБут' get zenbtr pict '9999.999'
                    endif
                 else
                    @ rvkvpr,col()+1 say 'Цена '+str(zenr,10,3)
                 endif
              else
                 if prinstr=0.and.prVzznr=0
                    @ rvkvpr,col()+1 say 'Цена '+str(zenr,10,3)
                 else
                    if prVzznr=0
                       @ rvkvpr,col()+1 say 'Цена' get zenr pict '999999.999'
                    else
                       @ rvkvpr,col()+1 say 'Цена Закупки' get zenprr pict '999999.999'
                    endif
                 endif
              endif
           else
              @ rvkvpr,col()+1 say 'Цена' get zenr pict '999999.999'
           endif
           if (gnVo=1.or.gnVo=2).and.prVzznr=0
              rvkvpr++
              @ rvkvpr,1 say 'Цена отгр' get ozenr pict '999999.999'
              if gnVo=1.and.int(ktl_r/1000000)>1.and.gnCtov=1
                 @ rvkvpr,col()+1 say 'БЛК КПК' get blkkpk_r pict '9'
              endif
           endif
        endif
     endif
     rvkvpr++
     read
     if lastkey()=K_ESC
         sele tov
         go rcn_r1
         netunlock()
         return .f.
     endif
  endif

  if prbb_r=1.and.prVzznr=0
     zenr=zenbbr+zenbtr
  endif

  if prVzznr=1
     zenr=zenttnr-zenprr
  endif

  if zenr=0
     if NdOtvr#3
        wmess('ВНИМАНИЕ!!! Цена нулевая',1)
     else
        return .f.
     endif
  endif

  if prVzznr=0
     if kf_r#0
        sf_r=ROUND(zenr*kf_r,2)
        sr_r= ROUND(bzenr*kf_r,2)
        if kf_r#kol_r.and.!empty(dprr)
           pro(4,ktl_r,ktlp_r)
        endif
     endif
  else
     sf_r=ROUND(zenr*kfttnr,2)
     sr_r= ROUND(zenr*kfttnr,2)
  endif

  sele pr2
  if NdOtvr=0.or.NdOtvr=4 ;  // Только для обычного прихода(NdOtvr из pr1)
          .or. (NdOtvr=3 .and. date() = SOX_DATE_CORR) // дал коррекцию СОХ,Коррекция

     if !netseek('t3','mnr,ktlp_r,ppt_r,ktl_r').and.kf_r#0 // Добавить
        netadd(1)
        if pbzenr=0
           if fieldpos('izg')<>0
              netrepl('mn,mntov,ktl,ktlp,kf,zen,ozen,sf,sr,ppt,izg','mnr,mntov_r,ktl_r,ktlp_r,kf_r,zenr,ozenr,sf_r,sr_r,ppt_r,izg_r')
           else
              netrepl('mn,mntov,ktl,ktlp,kf,zen,ozen,sf,sr,ppt','mnr,mntov_r,ktl_r,ktlp_r,kf_r,zenr,ozenr,sf_r,sr_r,ppt_r')
           endif
        else
           if fieldpos('izg')<>0
              netrepl('mn,mntov,ktl,ktlp,kf,zen,ozen,sf,sr,bzen,ppt,izg','mnr,mntov_r,ktl_r,ktlp_r,kf_r,zenr,ozenr,sf_r,sr_r,bzenr,ppt_r,izg_r')
           else
              netrepl('mn,mntov,ktl,ktlp,kf,zen,ozen,sf,sr,bzen,ppt','mnr,mntov_r,ktl_r,ktlp_r,kf_r,zenr,ozenr,sf_r,sr_r,bzenr,ppt_r')
           endif
        endif
        if fieldpos('kfttn')#0
           if prVzznr=1
              netrepl('zenpr','zenprr')
           endif
        endif
        if fieldpos('mntovp')#0
           netrepl('mntovp','mntovp_r')
        endif
        if fieldpos('zenbb')#0
           netrepl('zenbb,zenbt','zenbbr,zenbtr')
        endif
        if prVzznr=1
           netrepl('zenpr,kfttn','zenprr,kfttnr')
        endif
        if prVzznr=0
           sele tov
           if netseek('t1','sklr,ktl_r')
              if gnVo=9.or.gnVo=6.and.((gnEnt=14.or.gnEnt=15.or.gnEnt=17).and.(kopr=168.or.kopr=185).or.kopr=120.and.gnEnt=16)
                 netrepl('osfm,prmn,&coptr','osfm-kol_r+kf_r,mnr,zenr')
                 if fieldpos('prktl')#0
                    netrepl('prsk,prktl','gnSk,ktl_r')
                 endif
                 if fieldpos('cenbb')#0
                    if gnVo=9
                       netrepl('cenbb,cenbt','zenbbr,zenbtr')
                    endif
                 endif
              else
                 if prinstr=0
                    netrepl('osfm,&coptr','osfm-kol_r+kf_r,zenr')
                 else   // Новая карточка
                    netrepl('osfm,prmn,&coptr','osfm-kol_r+kf_r,0,zenr')
                    if fieldpos('prktl')#0
                       netrepl('prsk,prktl','gnSk,ktl_r')
                    endif
                 endif
              endif
              if !empty(cboptr)
                  if coptr#cboptr
                     netrepl('&cboptr','bzenr')
                  endif
              endif

           endif
           if gnCtov=1
              sele tovm
              if netseek('t1','sklr,mntov_r')
                 netrepl('osfm,&coptr','osfm-kol_r+kf_r,zenr')
                 if !empty(cboptr)
                    if coptr#cboptr
                       netrepl('&cboptr','bzenr')
                    endif
                 endif
                 if fieldpos('cenbb')#0
                    if gnVo=9
                       netrepl('cenbb,cenbt','zenbbr,zenbtr')
                    endif
                 endif
              endif
              sele ctov
              if netseek('t1','mntov_r')
                 netrepl('&coptr','zenr')
                 if !empty(cboptr)
                    if coptr#cboptr
                       netrepl('&cboptr','bzenr')
                    endif
                 endif
                 if fieldpos('cenbb')#0
                    if gnVo=9
                       netrepl('cenbb,cenbt','zenbbr,zenbtr')
                    endif
                 endif
              endif
           endif
        endif
     else // Обычный приход (коррекция количества,цены)
        if pbzenr=0
           netrepl('kf,zen,ozen,sf,sr','kf_r,zenr,ozenr,sf_r,sr_r')
        else
           netrepl('kf,zen,ozen,sf,sr,bzen','kf_r,zenr,ozenr,sf_r,sr_r,bzenr')
        endif
        if fieldpos('zenbb')#0
           netrepl('zenbb,zenbt','zenbbr,zenbtr')
        endif
        if prVzznr=1
           netrepl('zenpr,kfttn','zenprr,kfttnr')
        endif
        if prVzznr=0
           if kf=0
              netdel()
           endif
        else
           if cor_r=2
              netdel()
           endif
        endif
        if prVzznr=0
           sele tov
           if netseek('t1','sklr,ktl_r')
              netrepl('osfm,&coptr','osfm-kol_r+kf_r,zenr')
              if !empty(cboptr)
                  if coptr#cboptr
                     netrepl('&cboptr','bzenr')
                  endif
              endif
              if fieldpos('cenbb')#0
                 if gnVo=9
                    netrepl('cenbb,cenbt','zenbbr,zenbtr')
                 endif
              endif
           endif
           if gnCtov=1
              if gnVo=1
                 sele tov
                 if fieldpos('blkkpk')#0
                    netrepl('blkkpk','blkkpk_r')
                 endif
              endif
              sele tovm
              if netseek('t1','sklr,mntov_r')
                 netrepl('osfm,&coptr','osfm-kol_r+kf_r,zenr')
                 if !empty(cboptr)
                    if coptr#cboptr
                       netrepl('&cboptr','bzenr')
                    endif
                 endif
                 if fieldpos('cenbb')#0
                    if gnVo=9
                       netrepl('cenbb,cenbt','zenbbr,zenbtr')
                    endif
                 endif
              endif
              sele ctov
              if netseek('t1','mntov_r')
                 netrepl('&coptr','zenr')
                 if !empty(cboptr)
                    if coptr#cboptr
                       netrepl('&cboptr','bzenr')
                    endif
                 endif
                 if fieldpos('cenbb')#0
                    if gnVo=9
                       netrepl('cenbb,cenbt','zenbbr,zenbtr')
                    endif
                 endif
              endif
           endif
           if kf_r=0
              sele pr2
              netdel()
              prTryDel(ktl_r,ktlp_r)
           endif
        endif
        sele tov
        netunlock()
     endif
  endif
  prModr=1
  if NdOtvr=3  // Отчет отв.хран.
     prpcoder=0 // Признак необходимости перекодировки
     if zen_rr#zenr // zenr#0
        prpcoder=1  // Признак перекодировки по цене
     else
        prpcoder=0
     endif
     if prpcoder=1
        // Новый KTL
        sele tov
        netseek('t1','sklr,ktl_r')
        arec:={}
        getrec()
        ksert_r=ksert
        kukach_r=kukach
        prmn_r=prmn
        upakp_r=upakp
  //      if netseek('t5','sklr,mntov_r,zenr,kpsr,upakp_r')
  //         ktlnr=ktl  // KTL с новой ценой существует
  //      else // Новая карточка
           kgn_r=int(ktl_r/1000000)
           if gnCtov=1
              sele cgrp
              if !netseek('t1','kgn_r')
                 sele sgrp
                 if netseek('t1','kgn_r')
                    ngr_r=ngr
                    sele cgrp
                    netadd()
                    netrepl('kgr,ngr','kgn_r,ngr_r')
                    reclock()
                 else
                    wmess('Нет группы'+str(kgn_r,3)+' в SGRP',3)
                    quit
                 endif
              endif
              cmaxktlr=ktl
              sele sgrp
              netseek('t1','kgn_r')
              reclock()
              smaxktlr=ktl
              if smaxktlr>cmaxktlr
                 sele cgrp
                 netrepl('ktl','smaxktlr',1)
              endif
              if smaxktlr<cmaxktlr
                 sele sgrp
                 netrepl('ktl','cmaxktlr',1)
              endif
           endif
           sele sgrp
           if netseek('t1','kgn_r')
              reclock()
              ktlnr=ktl
              netrepl('ktl','ktl+1')
              if gnCtov=1
                 sele cgrp
                 netrepl('ktl','ktl+1')
              endif
              sele tov
              netadd()
              putrec()
              netrepl('ktl,opt,osn,osv,osf,osfm,osvo,otv','ktlnr,zenr,0,0,0,0,0,0')
           endif
  //      endif
        sele tov
        set orde to tag t1
        // Перекодировка прихода
        sele pr2
        if netseek('t1','mnr,ktl_r')
           if pbzenr=0
              netrepl('ktl,ktlp,kf,zen,ozen,sf,sr,ktlm,ktlmp','ktlnr,ktlnr,kf_r,zenr,ozenr,sf_r,sr_r,ktlmr,ktlmpr')
           else
              netrepl('ktl,ktlp,kf,zen,ozen,sf,sr,bzen,ktlm,ktlmp','ktlnr,ktlnr,kf_r,zenr,ozenr,sf_r,sr_r,bzenr,ktlmr,ktlmpr')
           endif
        endif
        // Удаление позиции привязанного расхода
        kfcorr=0 // К-во в корр.расх.
        sele rs2
        if netseek('t1','amnpr,ktl_r')
           kfcorr=kvp
           netdel()
        endif
        // Коррекция остатков
        // kfr    - К-во в приходе (kfr=kfor+kfcorr)
        // kfor   - К-во в расходах (NdOtv=3)
        // kfcorr - К-во в корр расх
        sele tov
        // Снять расход со старой (kfr) с 0 ценой
  //      if netseek('t1','sklr,ktl_r')
  //         netrepl('osv,osfm','osv+kfor+kfcorr,osfm+kfor+kfcorr')
  //      endif
        // Повесить на новую с ценой остаток
        if netseek('t1','sklr,ktlnr')
           reclock()
           netrepl('osv,osfm','osv-kfor,osfm-kfor+kfr')
  //         netrepl('osv,osfm','osv-kfr,osfm+kfr')
        endif
        // Перекодировка расхода
        sele rs2
        set orde to tag t5
        do while .t.
           srr=0
           sele rs2
           if netseek('t5','mnr,ktl_r')
              ttn_r=ttn
              mntov_r=mntov
              ppt_r=ppt
              if ktl=ktlp
                 mntovp_r=mntov
              else
                 if fieldpos('mntovp')#0
                    mntovp_r=mntovp
                 endif
                 if mntovp_r=0
                    mntovp_r=getfield('t1','sklr,ktl_r','tov','mntov')
                 endif
              endif
              kvp_r=kvp
              srr=ROUND(kvp*zenr,2)
              netrepl('ktl,ktlp,sr','ktlnr,ktlnr,srr')
              if gnCtov=1
                 sele rs2m
                 if netseek('t3','ttn_r,mntovp_r,ppt_r,mntov_r')
                    netrepl('sr','sr+srr')
                 endif
              endif
           else
              exit
           endif
        enddo
        if gnCtov=1
           // Посл зак цена в CTOV
           sele ctov
           if netseek('t1','mntov_r')
              netrepl('opt','zenr')
           endif
           // Посл зак цена в TOVM
           sele tovm
           if netseek('t1','sklr,mntov_r')
  //            netrepl('opt,osv,osfm','zenr,osv-kfr,osfm+kfr')
  //            netrepl('opt,osv,osfm','zenr,osv-kfr,osfm+kfr')
              netrepl('opt,osv,osfm','zenr,osv-kfor,osfm-kfor+kfr')
           endif
        endif
     endif
  endif

  sele pr2
  return .t.

****************************************************************
stat func otbe3(p1)  // Добавление в основной из дополнительного
  ****************************************************************
  ktl_ir=p1
  sele tovd
  rctov_r=recn()
  do while ktl_ir#0
     sele tovd
     if !netseek('t1','ktl_ir')
        exit
     endif
     k1tr=k1t
     reclock()
     sele tov
     if !netseek('t1','sklr,ktl_ir')
        sele tovd
        arec={}
        getrec()
        netdel()
        skip
        sele tov
        netadd()
        reclock()
        putrec()
        netrepl('skl','sklr',1)
     endif
     ktl_ir=k1tr
  enddo
  return

************************************************************************
func prTryDel(p1,p2) // Попытка убрать карточку из основного справочника
************************************************************************
local pr2rcr,pr1rcr
// p1 Код удаляемого товара
// p2 Код родителя
ktl_rr=p1
ktlp_rr=p2
prSRs2r=0
if select('rs2')#0
   prSRs2r=1
else
   netuse('rs2')
endif
sele tov
prUdlTovr=1
if netseek('t1','sklr,ktl_rr')
   skl_rr=skl
   if abs(osn)+abs(osf)+abs(osv)+abs(osfm)+abs(osvo)+abs(osfo)=0
      sele pr2
      oldpr2ind=indexord()
      pr2rcr=recn()
      set orde to tag t6
      if netseek('t6','ktl_rr')
         prUdlTovr=0
      endif
      go pr2rcr
      set orde to oldpr2ind
      sele rs2
      oldrs2ind=indexord()
      rs2rcr=recn()
      set orde to tag t6
      if netseek('t6','ktl_rr')
         prUdlTovr=0
      endif
      go rs2rcr
      set orde to oldrs2ind
   else
      prUdlTovr=0
   endif
else
   prUdlTovr=0
endif
if prSRs2r=0
   nuse('rs2')
endif
if prUdlTovr=1
   sele tov
   mntov_r=mntov
   arec:={}
   getrec()
   netdel()
   skip
   if gnCtov=2
      sele tovd
      if !netseek('t1','ktl_rr')
         netadd()
         set orde to tag t2
         reclock()
         putrec()
         netrepl('skl,osn,osv,osf,osfm','0,0,0,0,0')
      endif
   else
      if gnCtov=3
         sele ctovk
         if netseek('t1','ktl_rr')
            netrepl('cnt','cnt-1')
         endif
      endif
   endif
endif
return .t.

**********************************************************************************
static func OtvKf()
  return .t.
  if gnSkotv=0
     return .t.
  endif
  if mod(kf_r,upakp_r)#0
     wmess('Не целая упаковка',2)
     return .f.
  else
     return .t.
  endif

static func bcen()
  return .t.
  // Проверка на базовую цену
  if gnCtov=1
     bcenr=getfield('t1','mntov_r','ctov','c29')
  else
     bcenr=0
  endif
  if bcenr#0
     if zenr<bcenr
        wmess('Цена ниже базовой '+str(bcenr,10,3),3)
  //      return .f.
     endif
  endif
  return .t.

