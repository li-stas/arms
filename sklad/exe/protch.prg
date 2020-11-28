/***********************************************************
 * Модуль    : protch.prg
 * Версия    : 0.0
 * Автор     :
 * Дата      : 09/17/19
 * Изменен   :
 * Примечание: Текст обработан утилитой CF версии 2.02
 */

#include "common.ch"
#include "inkey.ch"
//Формирование отчета по продажам(прихода)
//Формирование расхода для снятия остатка с OSFM otv=2
//Если к-во упаковок<1,округляется до 1
//Для формирования нужен эксклюзив
// pr1  - протокол              mnr (pr1.amnp=ttntr - корр расх отмена)
// pr1t - отчет                 mntr
// rs1t - корректирующий расход ttntr
//
//nuse('sgrp')
//if !netuse('sgrp','','e')
//  netuse('sgrp')
//  wmess('Выгоните всех с '+alltrim(gcNskl),3)
//  retu
//endif
//nuse('sgrp')
//netuse('sgrp')
//sele pr1
//if !netseek('t2','mnr')
//  retu
//endif

sele pr2
if (!netseek('t1', 'mnr'))
  wmess('Протокол пустой', 3)
  return
else
  while (mn=mnr)
    if (kf<0)
      wmess('Ошибка в протоколе', 3)
      return
    endif

    if (kf=0)
      netdel()
    endif

    skip
  enddo

endif

prOtchr=1                   // Разрешение создания отчета

dtpr=addmonth(gdTd, -1)
pathr=gcPath_e+'g'+str(year(dtpr), 4)+'\m'+iif(month(dtpr)<10, '0'+str(month(dtpr), 1), str(month(dtpr), 2))+'\'+gcDir_t
if (netfile('tov', 1))
  netUse('pr1', 'pr1p',, 1)
  netUse('pr2', 'pr2p',, 1)
  netUse('tov', 'tovp',, 1)
  sele pr1p
  set orde to tag t3
  if (netseek('t3', '4,kpsr'))
    while (otv=4.and.kps=kpsr)
      if (prz=0)
        prOtchr=0
        mn_r=mn
        exit
      endif

      skip
      if (eof())
        exit
      endif

    enddo

  endif

  if (prOtchr=0)
    nuse('pr1p')
    nuse('pr2p')
    nuse('tovp')
    wmess('Подтвердите ручной отчет прошлого месяца'+str(mn_r, 6), 2)
    return (.t.)
  endif

  sele pr1p
  set orde to tag t3
  if (netseek('t3', '3,kpsr'))
    while (otv=3.and.kps=kpsr)
      if (val(nnz)=mnr.and.prz=0)
        prOtchr=0
        mn_r=mn
        exit
      endif

      skip
      if (eof())
        exit
      endif

    enddo

  endif

  if (prOtchr=0)
    nuse('pr1p')
    nuse('pr2p')
    nuse('tovp')
    wmess('Подтвердите отчет автомат прошлого месяца'+str(mn_r, 6), 2)
    return (.t.)
  endif

  sele pr1p
  set orde to tag t1
  go top
  while (!eof())
    if (prz=0)
      skip
      loop
    endif

    if (kps#kpsr)
      skip
      loop
    endif

    mn_r=mn
    sele pr2p
    if (netseek('t1', 'mn_r'))
      while (mn=mn_r)
        ktl_r=ktl
        sele tovp
        if (netseek('t1', 'gnSkl,ktl_r'))
          if (osf#0)
            sele tov
            if (!netseek('t1', 'gnSkl,ktl_r'))
              wmess('Сделайте корр на нач,тек остатков и корр отв хр', 3)
              nuse('pr1p')
              nuse('pr2p')
              nuse('tovp')
              return (.t.)
            endif

          endif

        endif

        sele pr2p
        skip
      enddo

    endif

    sele pr1p
    skip
  enddo

  nuse('pr1p')
  nuse('pr2p')
  nuse('tovp')
endif

netUse('pr1', 'pr1t')
sele pr1t
set orde to tag t3
if (netseek('t3', '4,kpsr'))
  while (otv=4.and.kps=kpsr)
    if (prz=0)
      prOtchr=0
      mn_r=mn
      nd_r=nd
      exit
    endif

    skip
    if (eof())
      exit
    endif

  enddo

endif

if (prOtchr=0)
  nuse('pr1t')
  wmess('Подтвердите ручной отчет nd='+str(nd_r, 6)+'('+str(mn_r, 6)+')', 2)
  return
endif

sele pr1t
set orde to tag t3
if (netseek('t3', '3,kpsr'))
  while (otv=3.and.kps=kpsr)
    if (val(nnz)=mnr.and.prz=0)
      prOtchr=0
      mn_r=mn
      exit
    endif

    skip
    if (eof())
      exit
    endif

  enddo

endif

if (prOtchr=0)
  nuse('pr1t')
  wmess('Подтвердите отчет автомат '+str(mn_r, 6), 2)
  return
endif

sele pr1t
set orde to tag t1

netUse('pr2', 'pr2t')
netUse('rs1', 'rs1t')
netUse('rs2', 'rs2t')

netuse('rs1')
netuse('rs2')
aqstr=2
CrProtO(1, mnr)
nuse('rs1')
nuse('rs2')

/*** Данные из pr1 , записать в pr1t,rs1t ******************* */
sele cskl
netseek('t1', 'gnSk')
Reclock()
mntr=mn                     // Новый отчет
if (mn<999999)
  Replace mn with mn+1
else
  Replace mn with 1
endif

netunlock()

sele pr1
if (netseek('t2', 'mnr'))
  sklr=skl
  reclock()
  arec:={}
  getrec()
  /*
  *   if prttntr=0
  *      sele rs1t
  *      netadd()
  *      netrepl('ttn,skl,kpl,otv','ttntr,sklr,kpsr,2')
  *   else
  *      sele rs2t
  *      if netseek('t1','ttntr')
  *         wmess('Коректирующий расход не пустой',2)
  *         nuse('pr1t')
  *         nuse('pr2t')
  *         nuse('rs1t')
  *         nuse('rs2t')
  *         retu
  *      endif
  *   endif
    */
  sele pr1t
  NetAdd()
  putrec()
  nnzr=str(mnr, 6)        // Запомнить в nnz отчета номер протокола
  dnzr=date()
  // *   * Записать в amnp отчета номер корректирующего расхода
  netrepl('nd,mn,otv,nnz,dnz,dvp,ddc,tdc', 'mntr,mntr,3,nnzr,dnzr,date(),date(),time()')

  sele soper
  qr=mod(kopr, 100)
  sele soper
  netseek('t1', 'gnD0k1,gnVu,gnVo,qr')
  sktr=ska
  skltr=kpsr
  sele pr1t
  netrepl('skt,sklt', 'sktr,skltr')
  sele rs1t
  // * Записать в amnp корректирующего расхода номер отчета
  // *   netrepl('amnp','mntr')

  // *** Данные из протокола, записать в отчет,корр.расход
  sele pr2
  set orde to tag t1
  netseek('t1', 'mnr')
  while (mn=mnr)
    prcn_rr=recn()
    ktlr=ktl
    ktlpr=ktlp
    pptr=ppt
    mntovr=mntov
    store 0 to kfr, kfor, kfotchr, kfcorr
    if (fieldpos('kfto')#0)// Отгруженное к-во
      if (fullor=0)
        kfr=kfto               // Количество в расходах
        if (kfr=0)
          skip
          loop
        endif

        kfor=kfto           // Количество в расходах для отчета
      else
        kfr=kf              // Количество в расходах
        kfor=kfr            // Количество в расходах для отчета
        if (kfr=0)
          skip
          loop
        endif

      endif

    else
      kfr=kf                // Количество в расходах
      kfor=kfr              // Количество в расходах для отчета
    endif

    zen=zenr                // zenr=0
    upakpr=getfield('t1', 'sklr,ktlr', 'tov', 'upakp')
    kupakpr=int(kfr/upakpr)+iif(mod(kfr, upakpr)#0, 1, 0)// К-во упак в отчет
    if (gnVotv=2)
      kfotchr=kupakpr*upakpr// Количество товара в отчет
      kfcorr=kfotchr-kfr    // Количество товара в корр.расход
    else
      kfotchr=kfr
      kfcorr=0
    endif

    arec:={}
    getrec()
    // Разделение прихода с отв.хр
    sele pr2t
    netadd()
    putrec()
    //     #ifndef __CLIP__
    //         //для отладки
    //       kg_r=int(pr2->mntov/10000)
    //       sele cgrp
    //       netseek('t1','kg_r')
    //       reclock()
    //       ktl_r=ktl
    //       netrepl('ktl','ktl+1')
    //       sele tov
    //       netseek('t1','gnSkl,ktlr')
    //       arec:={}
    //       getrec()
    //       netadd()
    //       putrec()
    //       netrepl('ktl,otv','ktl_r,0')
    //       sele pr2t
    //       netrepl('ktl,zen,sf','ktl_r,1,kfotchr')
    //     #endif
    //Добавить в новый
    netrepl('mn,kf,kfo', 'mntr,kfotchr,kfor')
    if (kfcorr#0)
      //Добавить в корр.расход разницу (kfcorr)
      sele rs2t
      netadd()
      netrepl('ttn,mntov,ktl,ppt,ktlp,kvp,amnp,zen', 'ttntr,mntovr,ktlr,pptr,ktlpr,kfcorr,mntr,zenr')
      //Снять с ответ хран.корр.расход
      sele pr1
      set orde to tag t3
      if (netseek('t3', '1,kpsr'))
        mn_r=mn
        sele pr2
        if (netseek('t1', 'mn_r,ktlr,ktlpr'))
          netrepl('kf', 'kf-kfcorr')
        endif

      endif

      //Коррекция остатков TOV,TOVM на кол_во в корр. расх (kfcorr)
      sele tov
      if (netseek('t1', 'sklr,ktlr'))
        //           netrepl('osv,osfm','osv-kfcorr,osfm-kfcorr')
        //           netrepl('osv,osfm,osvo','osv-kfcorr,osfm-kfcorr,osvo-kfcorr')
        netrepl('osvo', 'osvo-kfcorr')
      endif

      sele tovm
      if (netseek('t1', 'sklr,mntovr'))
        //           netrepl('osv,osfm','osv-kfcorr,osfm-kfcorr')
        //           netrepl('osv,osfm,osvo','osv-kfcorr,osfm-kfcorr,osvo-kfcorr')
        netrepl('osvo', 'osvo-kfcorr')
      endif

    endif

    //     sele rs2t
    //     set orde to tag t5
    //     if netseek('t5','mnr,ktlr,ktlpr')
    //        do while amnp=mnr.and.ktl=ktlr.and.ktlp=ktlpr
    //           ttnr=ttn
    //           dopr=getfield('t1','ttnr','rs1t','dop')
    //           if dopr<gdTd
    //              netrepl('amnp,otv','mntr,3')
    //           endif
    //           sele rs2t
    //           skip
    //        endd
    //     else
    //        wmess('Ошибка создания отчета',3)
    //        quit
    //     endif
    //     set orde to tag t1
    sele pr2
    set orde to tag t1
    go prcn_rr
    //Удалить из протокола
    netrepl('kf,kfo', 'kf-kfr,kfo-kfr')
    if (kf=0)
      netdel()
    endif

    skip
    //     if eof()
    //        exit
  //     endif
  enddo

  //Коррекция OTV и AMNP в расходах
  sele lrs2otv
  go top
  while (!eof())
    rcnr=rcn
    kolr=kol
    ktlr=ktl
    ktlmr=ktlm
    if (fullor=0)         // Отчет по условиям
      if (kolr=0)
        sele lrs2otv
        skip
        loop
      endif

    endif

    sele rs2t
    go rcnr
    netrepl('amnp,otv,ktlm', 'mntr,3,ktlr')
    sele pr2
    if (netseek('t1', 'mnr,ktlr,ktlr'))
      netrepl('kfto', 'kfto-kolr')
    endif

    sele lrs2otv
    skip
  enddo

  //    //Коррекция OTV и AMNP в расходах
  //  sele rs2t
  //  set orde to tag t5
  //  do while netseek('t5','mnr')
  //      netrepl('amnp,otv','mntr,3')
  //  enddo
  //  set orde to tag t1
  //  locate for otv=2.and.amnp=mnr
  //  if FOUND()
  //     wmess('Ошибка создания отчета',3)
  //     netuse('cskl')
  //     sele cskl
  //     locate for sk=gnSk
  /*  //     netrepl('blk','1') */
  //     nuse('cskl')
  //     quit
//  endif
endif

unlock all
nuse('pr1t')
nuse('pr2t')
nuse('rs1t')
nuse('rs2t')
return

/************** */
function pratt()
  //свойства pr1
  /************** */
  clrdsp=setcolor('gr+/b,n/bg')
  wrdsp=wopen(8, 15, 19, 70)
  wbox(1)
  @ 0, 1 say 'Cоздан'+' '+dtoc(pr1->ddc)+' '+pr1->tdc
  if (przr=1.and.gnAdm=0)
    @ 1, 1 say 'NNDS  '+' '+str(nndsr, 10)
    inkey(0)
  else
    @ 1, 1 say 'NNDS  ' get nndsr pict '9999999999' valid chknn()
    read
    if (lastkey()=K_ENTER)
      sele pr1
      netrepl('nnds', 'nndsr', 1)
    endif

  endif

  wclose(wrdsp)
  setcolor(clrdsp)
  return (.t.)
