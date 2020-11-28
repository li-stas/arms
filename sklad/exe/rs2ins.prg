/***********************************************************
 * Модуль    : rs2ins.prg
 * Версия    : 0.0
 * Автор     :
 * Дата      : 11/24/17
 * Изменен   :
 * Примечание: Текст обработан утилитой CF версии 2.02
 */

#include "common.ch"
#include "inkey.ch"
#define ZEN_PRACE

/* Отбор товара в расходный документ,коррекция,удаление */
para corr, prw
local rccr, alssr
/*if autor=3.and.gnSk=sktr.and.(int(ktlr/1000000)=kgnr.or.kgnr=0).and przr=1
 *   wmess('Операция запрещена',2)
 *   retu
 *endif
 */
alssr=alias()
rccr=recn()
if (corr=nil)
  corr=1
endif

if (prw=nil)
  prowr=1
else
  prowr=0
endif

if (corr#2.and.!(gnVo=5.or.gnVo=6).and.gnArm=3.and.!(gnEnt=20.and.vor=9.and.kopr=168).and.!(kopr=169.or.kopr=151))
  sele sgrp
  if (fieldpos('lic')#0)
    licr=getfield('t1', 'int(ktlr/1000000)', 'sgrp', 'lic')
    if (licr#0)
      sele klnlic
      if (netseek('t1', 'kplr,kgpr'))
        lic_r=0
        while (kkl=kplr.and.kgp=kgpr)
          if (lic#licr)
            skip
            loop
          endif

          if (!(gdTd>=dnl.and.gdTd<=dol))
            skip
            loop
          else
            lic_r=1
            exit
          endif

          skip
        enddo

        if (lic_r=0)
          wmess('У этого клиента истек срок лицензии')
          return
        endif

      else
        wmess('У этого клиента нет лицензий')
        return
      endif

    endif

  endif

endif

cor_r=corr                  // Действие : Отобрать - 0 Коррекция - 1  Удаление  - 2

/*prowr=1 // Признак открытия окна при коррекции,отборе */
if (cor_r=2)
  prowr=0
endif

if (prowr=1)
  cltovkol=setcolor('w+/rb+,n/w')
  ww=wopen(5, 1, 20, 78, .t.)
  wbox(1)
  prowr=1
endif

rvkvpr=0

store 0 to ktl_r, k1t_r     //,ppt_r

if (cor_r=2)
  ppt_r=pptr
  if (ktlr#ktlpr)
    prptr=1
  else
    prptr=0
  endif

else
  ktlpr=ktlr
  ppt_r=0
  prptr=0
endif

zenbutr=0
if (gnCtov=1)
  sele ctov
  if (fieldpos('akc')#0)
    tovakcr=getfield('t1', 'mntovr', 'ctov', 'akc')
    if (gnEnt=21)
      if (tovakcr=2)
        tovakcr=0
      endif

    endif

  else
    tovakcr=0
  endif

else
  tovakcr=0
endif

sele rs2
if (PozKtl(ktlr, ktlpr))
  sele rs2
  rcrs2r=recn()
  while (k1t_r#0.and.!(kopr=161.or.kopr=169.or.kopr=168.or.kopr=191.or.kopr=126).or.int(k1t_r/1000000)>0.and.(kopr=161.or.kopr=169.or.kopr=168.or.kopr=191.or.kopr=126).or.k1t_r#0.and.gnAdm=1) //  .and. udtar#1
    if (prptr=1)
      exit
    endif

    if (autor=3.or.autor=1.or.autor=4)
      exit
    endif

    ppt_r=1
    if (!pozktl(k1t_r, ktlr))
      exit
    endif

  enddo

endif

if (gnEnt=21.and.tovakcr=1)
  /* Акция */
  if (cor_r#2.and.lastkey()=K_ENTER.and.tovakcr=1)//zenbutr#0
    if (bonr=0)
      /*         bonr=0.20 */
      bonr=0
    endif

    @ rvkvpr, 1 say 'Акция количество' get kvpbonr pict '999999.999'
    if (gnAdm=1.or.gnKto=46.or.gnKto=217.or.gnKto=786)
      @ rvkvpr, col()+1 say 'Доп Скидка' get bonr pict '999999.999'
    else
      @ rvkvpr, col()+1 say 'Доп Скидка'+' '+str(bonr, 10, 3)
    endif

    read
    if (lastkey()=K_ENTER)
      sele rs2
      if (prdecr=0)
        rdecpr=3
      else
        if (decp=0)
          rdecpr=3
        else
          rdecpr=decp
        endif

      endif

      go rcrs2r
      /*         if zenbutr#0 */
      if (tovakcr#0)
        if (fieldpos('kvpbon')#0)
          netrepl('kvpbon,bon', 'kvpbonr,bonr')
        endif

        if (fieldpos('skbon')#0)
          naclr=getfield('t1', 'nkklr', 'kpl', 'nacl')
          if (naclr=0)
            /*                  skbonr=roun((zen+zenbutr+bon)*kvpbon,2)
             *                  skbonr=roun((zen+bon)*kvpbon,2)
             */
            skbonr=roun(zen*kvpbon, 2)
          else
            zen_rr=zen+roun(zen*naclr/100, rdecpr)
            /*                  skbonr=roun((zen_rr+zenbutr+bon)*kvpbon,2)
             *                  skbonr=roun((zen_rr+bon)*kvpbon,2)
             */
            skbonr=roun(zen_rr*kvpbon, 2)
          endif

          netrepl('skbon', 'skbonr')
        endif

      else
        /*            netrepl('kvpbon,bon,skbon','0,0,0') */
        netrepl('kvpbon,skbon', '0,0')
      endif

    endif

  else
    if (cor_r=2)
      sele rs2
      go rcrs2r
      netrepl('kvpbon,bon,skbon', '0,0,0')
    endif

  endif

endif

if (prowr=1)
  wclose(ww)
  setcolor(cltovkol)
endif

/*sele rs2
 *go rcrs2r
 *if tovakcr=1.and.gnEnt=21
 *   if zenbutr#0
 *      if fieldpos('kvpbon')#0
 *         netrepl('kvpbon,bon','kvpbonr,bonr')
 *      endif
 *      if fieldpos('skbon')#0
 *         skbonr=roun((zen+zenbutr+bon)*kvpbon,2)
 *         netrepl('skbon','skbonr')
 *      endif
 *   else
 *      netrepl('kvpbon,bon,skbon','0,0,0')
 *   endif
 *endif
 */
sele (alssr)
go rccr

/*************************************************************************** */
function PozKtl(p1, p2)
  /*stat func pozktl(p1,p2)
   * p1 - код товара
   * p2 - код родителя
   ***************************************************************************
   */
  local nzap
  ktl_r=p1
  ktlp_r=p2
  store 0 to osv_r, osvo_r, osfm_r, rcn_r1, kvp_r, kol_rr, amnp_r, kpsr, Otv_r, osfo_r, minosvo_r
  MinZen1r=0
  if (rs2vidr=2)
    store 0 to zenr, bzenr, xzenr, cenbbr, cenbtr
  endif

  if (prowr=1.or.cor_r=2)
    kol_r=0
  endif



  store '' to nat_r
  mntov_r=getfield('t1', 'sklr,ktl_r', 'tov', 'mntov')

  if (gnCtov=1)
    sele mkeep
    if (fieldpos('BlkMk')#0)
      mkeep_r=getfield('t1', 'mntov_r', 'ctov', 'mkeep')
      if (mkeep_r#0)
        BlkMk_r=getfield('t1', 'mkeep_r', 'mkeep', 'BlkMk')
        if (BlkMk_r=1)
          if gnAdm=1.or.gnKto=71.or.gnKto=28
            //gnKto=160.or..or.gnKto=848.or.gnKto=217.or.gnKto=786
            // этим можно
          else
            wmess('МД '+str(mkeep_r, 3)+' блокирован', 2)
            return (.t.)
          endif
        endif

      endif

    endif

  endif


  if (ktl_r=ktlp_r)
    mntovp_r=mntov_r
  else
    mntovp_r=getfield('t1', 'sklr,ktlp_r', 'tov', 'mntov')
  endif

  if (gnCtov=1)
    sele tovm
    rctovm_r=recn()
    if (!netseek('t1', 'sklr,mntov_r',,, 1))
      wmess(str(sklr, 7)+' '+str(mntov_r, 7)+' Не наден в TOVM', 1)
      return (.f.)
    endif

    /* Блокировка карточки TOVM */
    if (!reclock(1))
      avib=alert('Запись занята', { 'Ждать', 'Пропустить' })
      if (avib=1)
        reclock()
      else
        if (prowr=1)
          wselect(ww)
        endif

        return (.f.)
      endif

      if (prowr=1)
        wselect(ww)
      endif

    endif

    if (rs2vidr=1)
      rs2sert_r=0           //rs2sert_mr
    else
      rs2sert_r=0
    endif

  else
    rs2sert_r=0
  endif

  sele tov
  rcn_r1=recn()
  if (!netseek('t1', 'sklr,ktl_r'))
    if (rs2vidr=2.and.gnCtov=1)
      sele tovm
      netunlock()
    endif

    wmess(str(sklr, 7)+' '+str(ktl_r, 9)+' Не наден в TOV', 1)
    return (.f.)
  endif

  /* Блокировка карточки TOV */
  if (!reclock(1))
    avib=alert('Запись занята', { 'Ждать', 'Пропустить' })
    if (avib=1)
      reclock()
    else
      return (.f.)
    endif

  endif

  opt_r=opt
  if (fieldpos('skkt')#0)
    skkt_t=skkt
    ttnkt_r=ttnkt
    dtkt_r=dtkt
    ktlkt_r=ktlkt
    cenkt_r=cenkt
  else
    skkt_t=0
    ttnkt_r=0
    dtkt_r=ctod('')
    ktlkt_r=0
    cenkt_r=0
  endif

  if (fieldpos('mnkt')#0)
    mnkt_r=mnkt
  else
    mnkt_r=0
  endif

  if (fieldpos('cenbb')#0)
    cenbb_r=cenbb
    cenbt_r=cenbt
  else
    cenbb_r=0
    cenbt_r=0
  endif

  post_r=post
  osvo_r=osvo
  osfm_r=osfm

  if (fieldpos('osfo')#0)
    osfo_r=osfo
  else
    osfo_r=0
  endif

  if (fieldpos('minosvo')#0)
    minosvo_r=minosvo
  else
    minosvo_r=0
  endif

  Otvr=Otv

  /* Блокировка прихода с ответхранения */
  if (Otvr=1)
    BlkOtv()
  endif

  sele tov
  mntov_r=mntov
  nat_r=alltrim(nat)
  upak_r=upak
  upakp_r=upakp
  k1t_r=k1t
  kg_r=kg

  if (gnVo=1.and.kpsbbr=1.and.cenbb_r#0.and.cenbt_r#0)
    prbb_r=getfield('t1', 'kg_r', 'cgrp', 'prbb')
  else
    prbb_r=0
  endif

  osv_r=osv
  nei_r=nei
  kge_r=kge
  izg_r=izg
  if (Otvr=1.and.gnBlk=2.and.gnAdm=0)
    if (rs2vidr=2.and.gnCtov=1)
      sele tovm
      netunlock()
    endif

    nuse('pr1')
    nuse('pr2')
    sele tov
    netunlock()
    return (.f.)
  endif
  ves_r=ves
  if (upakp_r=0.and.Otvr=1.and.gnSkOtv#0)
    wmess('Нет упаковки поставщика', 1)
    if (rs2vidr=2.and.gnCtov=1)
      sele tovm
      netunlock()
    endif

    sele tov
    netunlock()
    nuse('pr1')
    nuse('pr2')
    return (.f.)
  endif

  kpsr=post
  cenpr_r=cenpr
  if (prowr=1)
    @ rvkvpr, 1 say subs(str(ktl_r, 9)+' '+alltrim(getfield('t1', 'kge_r', 'GrpE', 'nge'))+' '+nat_r+iif(upak_r#0, ' 1/'+kzero(upak_r, 10, 3), '')+iif(upakp_r#0, '/'+kzero(upakp_r, 10, 3), ''), 1, 73)
    rvkvpr++
  endif

  sele rs2
  store 0 to kol_rr, svpcr, sr_rr, svp_rr, bsvp_rr, xsvp_rr
  if (rs2vidr=2)
  /*   store 0 to zenr,bzenr,xzenr,xzenpr */
  endif

  //  есть ли такая строка в расходе
  if (netseek('t3', 'ttnr,ktlp_r,ppt_r,ktl_r'))
    if (cor_r=0)
      cor_r=1 // коррекция
    endif

    zenr=zen
    prZenr=pzen
    zenpr=zenp
    prZenpr=prZenp

    bzenr=bzen
    prBZenr=pbzen
    bzenpr=bzenp
    prBZenpr=prBZenp

    xzenr=xzen
    prXZenr=pxzen
    xzenpr=xzenp
    prXZenpr=prXZenp

    MZenr=MZen

    if (fieldpos('tcenp')#0)
      tcenpr=tcenp
    else
      tcenpr=0
    endif

    if (fieldpos('tcenb')#0)
      rdecpr=decp
      rtcenbr=tcenb
      rdecbr=decb
      rtcenxr=tcenx
      rdecxr=decb
    else
      rdecpr=0
      rtcenbr=0
      rdecbr=0
      rtcenxr=0
      decxr=0
    endif

    if (prdecr=0)
      rdecpr=3
      rdecbr=3
      rdecxr=3
    else
      if (rdecpr=0)
        rdecpr=3
      else
        rdecpr=decp
      endif

      if (rdecbr=0)
        rdecbr=3
      else
        rdecbr=decb
      endif

      if (rdecxr=0)
        rdecxr=3
      else
        rdecxr=decx
      endif

    endif

    /*   if tovakcr=1
     *      if fieldpos('bon')#0
     *         kvpbonr=kvpbon
     *         bonr=bonr
     *      else
     *         kvpbonr=kvpbon
     *         bonr=bonr
     *      endif
     *   endif
     */

    if (gnKt=0)
      if (cor_r#2)
        zenrs2(1, ktl_r, mntov_r)// Использовать скидки по документу
        /*         zen(1,ktl_r,mntov_r) // Использовать скидки по документу */
        if (gnVo=1.and.prbb_r=1)
        /*         zenr=cenbb_r */
        endif

      endif

    endif

    sele rs2
    if (prowr=1)
      kol_r=kvp
    endif

    kol_rr=kvp              // До коррекции
    sr_rr=sr                // До коррекции
    svp_rr=svp              // До коррекции
    bsvp_rr=bsvp            // До коррекции
    xsvp_rr=xsvp            // До коррекции

    if (rs2vidr=2)
    /*      zenr=zen     // Первая цена по rs2
     *      bzenr=bzen   // Вторая цена по rs2
     *      if fieldpos('xzen')#0
     *         xzenr=xzen   // Третья цена по rs2
     *      else
     *         xzenr=0
     *      endif
     */
    endif

    rs2sert_r=sert
    Otv_r=Otv
    if (Otv_r=1.and.Otvr=1)
      Otv_r=2
    endif

    amnp_r=amnp             // # протокола или отчета
    kvpo_r=kvpo             // Отправлено в отчет отв.хр.
    /* Если Otv=0 и amnp_r=0 - норма                           (Корр/Уд)
     * Если Otv=0 и amnp_r#0 - норма(Товар с ценой отв.хр.)    (Корр/Уд)
     * Не исп.  * Если Otv=1 и amnp_r=0 - товар с отв.хр.      (Корр/Уд) ???
     * Если Otv=2 и amnp_r#0 - товар в протоколе продаж        (Коррекция)
     * Если Otv=3 и amnp_r#0 - товар в неподтв.отчете          (Низзя!!!)
     */
    if (Otv_r=3)          //.or.Otv_r=1
      nuse('pr1')
      nuse('pr2')
      if (rs2vidr=2.and.gnCtov=1)
        sele tovm
        netunlock()
      endif

      outlog(__FILE__,__LINE__,'Если Otv=3 и amnp_r#0 - товар в неподтв.отчете          (Низзя!!!)')
      return (.f.)
    endif

    if (cor_r=2.and.gnArm=3)
      /*      rso(5,ktl_r,ktlp_r) */
      kol_r=0
    endif

  else
    rtcenpr=0
    rdecpr=0
    rtcenbr=0
    rdecbr=0
    rtcenxr=0
    rdecxr=0
    if (gnKt=0)
      ZenRs2(0, ktl_r, mntov_r)// Использовать скидки по условиям новые
    /*      if prdecr=0
     *         zen(0,ktl_r,mntov_r) // Использовать скидки по условиям старые
     *      else
     *         zenrs2(0,ktl_r,mntov_r) // Использовать скидки по условиям новые
     *      endif
     */
    else
      if (kopr=136)            // Возврат
        zenr=opt_r
        zenpr=cenkt_r
        bzenr=cenkt_r
      else                       // 137 Продажа
        zenr=cenkt_r
        zenpr=cenkt_r
        bzenr=0
        xzenr=zenr
        xzenpr=zenpr
      endif

      bzenpr=0
      prZenpr=0
      prBZenpr=0
    endif

    if (gnVo=1.and.prbb_r=1)
      if (cvzbbr=0.and.cenbb_r#0)
        cvzbbr=cenbb_r
      endif

      if (cvzbtr=0.and.cenbt_r#0)
        cvzbtr=cenbt_r
      endif

    endif

    sele rs2
    if (Otvr=1)
      Otv_r=2
    else
      Otv_r=0
    endif

  endif

  if (gnCtov=1)
    KolAkcr=getfield('t1', 'mntov_r', 'ctov', 'KolAkc')
  else
    KolAkcr=0
  endif

  if (rs2vidr=2)
    if (zenr=0)
    /*      zenr=zen_r */
    endif

    if (bzenr=0)
    /*      bzenr=bzen_r */
    endif

    if (xzenr=0)
    /*      xzenr=xzen_r */
    endif

  endif

  zen_r=zenr                // До коррекции
  bzen_r=bzenr              // До коррекции
  xzen_r=xzenr              // До коррекции

  if (cor_r#2.and.prowr=1)
    do case
    case (gnArm=3.and.przr=0)// Склад
      while (lastkey()#27)
        if (Otvr=0)
          if (gnEnt=21.and.gnVo=1.and.prbb_r=1)
            @ rvkvpr, 1 say 'Ост '+allt(str(osv_r, 10, 3))
          else
            @ rvkvpr, 1 say 'Ост '+str(osv_r, 10, 3)
          endif

        else
          @ rvkvpr, 1 say 'Ост '+str(osvo_r, 10, 3)
        endif

        if (gnEnt=20.or.gnEnt=21).and.gnVo=9 .and.(empty(dfpr).or.who=1);
           .or.gnVo#9.or.gnAdm=1
          if (who#0.and.gnCenr=1.or.gnAdm=1.or.empty(dfpr).or.gnVo#9)
            @ rvkvpr, col()+1 say 'Кол-во' get kol_r pict '999999.999' when wkol() valid vkol()
          else
            @ rvkvpr, col()+1 say 'Кол-во'+' '+str(kol_r, 10, 3)
          endif

        else
          if (who=0)
            @ rvkvpr, col()+1 say 'Кол-во'+' '+str(kol_r, 10, 3)
          else
            if who#0.and.gnCenr=1 // 05-17-18 05:06pm Ищенко
               @ rvkvpr, col()+1 say 'Кол-во' get kol_r pict '999999.999'
            endif
          endif

        endif

        col_rr=col()
        if (gnVo=9.and.KolAkcr#0)
          read
          ZenAk(mntov_r, kol_r)
        endif

        if (gnVo#6.and.(gnCenr=1.and.who#0.or.gnAdm=1))
          zen_r=zenr        // До коррекции
          bzen_r=bzenr      // До коррекции
          xzen_r=xzenr      // До коррекции
          do case
          case (prZen2r=0)
            if (gnEnt=21.and.gnVo=1.and.prbb_r=1)
              /*                         @ rvkvpr,col()+1 say 'ЦВх' get zenr pict '99999.999' valid  chkzen1(ktl_r) */
              @ rvkvpr, col_rr+1 say 'ЦВх' get zenr pict '99999.999' valid chkzen1(ktl_r)
            else
              if (gnKt=1)
                if (kopr=137)
                  @ rvkvpr, col_rr+1 say 'Цена1' get zenr pict '999999.999' valid chkzen1(ktl_r)
                else
                  @ rvkvpr, col_rr+1 say 'Цена1 '+str(zenr, 9, 3)
                endif

                @ rvkvpr, col_rr+1 say 'ЦВзНДС '+str(bzenr, 9, 3)
              else
                @ rvkvpr, col_rr+1 say 'Цена1' get zenr pict '999999.999' valid chkzen1(ktl_r)
              endif

            endif

          case (prZen2r=1)
            @ rvkvpr, col_rr+1 say 'Цена2' get bzenr pict '999999.999' valid chkzen2()
          case (prZen2r=2)
            @ rvkvpr, col_rr+1 say 'Цена3' get xzenr pict '999999.999' valid chkzen3()
          endcase

        else
          @ rvkvpr, col_rr+1 say 'Цена '+str(zenr, 10, 3)
        endif

        colprZenr=col()+1
        if (int(ktl_r/1000000)>1)
          if (gnCenr=1.and.who#0.or.gnAdm=1)
            do case
            case (prZen2r=0)
              if (!(gnVo=1.and.prbb_r=1.and.gnEnt=21))
                if (gnKt=0)
                  @ rvkvpr, col()+1 say 'Скидка '+str(prZenr, 6, 2)
                endif

              else
                @ rvkvpr, col()+1 say 'ЦТ' get cvzbbr pict '99999.999'
                @ rvkvpr, col()+1 say 'ЦБ' get cvzbtr pict '99999.999'
              endif

            case (prZen2r=1)
              @ rvkvpr, col()+1 say 'Скидка2 '+str(prBZenr, 6, 2)
            case (prZen2r=2)
              @ rvkvpr, col()+1 say 'Скидка3 '+str(prXZenr, 6, 2)
            endcase

          else
            if (gnKt=0)
              @ rvkvpr, col()+1 say 'Скидка '+str(prZenr, 6, 2)
            endif

          endif

        endif

        rvkvpr++
        if (empty(getlist))
          if (gnVo=9.and.!empty(dfpr))
            wmess('Снимите фин подтв', 0)
          else
            wmess('Для продолжения нажмите Пробел', 0)
          endif

        else
          read
          if (gnKt=1)
            if (kopr=137)
              bzenr=zenr-zenpr
            endif

            if (kopr=136)
              bzenr=zenpr
            endif

          endif

          if (!(gnVo=1.and.prbb_r=1.and.gnEnt=21))
            @ rvkvpr-1, colprZenr say 'Скидка '+str(prZenr, 6, 2)
          endif

        endif

        if (tovakcr=1)
          if (int(ktl_r/1000000)=1.and.kol_r#0)
            zenbutr=zenr
          endif

        endif

        if (kol_r<0.and.Otv_r#0)
          loop
        endif

#ifndef __CLIP__
  // проверка    min OSVO
          outlog(__FILE__,__LINE__,osvo_r, kol_r, minosvo_r)
          if (osvo_r - kol_r - minosvo_r <= 0)
            outlog(__FILE__,__LINE__,osvo_r, minosvo_r)
            if (osvo_r-minosvo_r<0)
              wmess('Доступно '+str(0, 12, 3), 1)
            else
              wmess('Доступно '+str(osvo_r-minosvo_r, 12, 3), 1)
            endif

            if (rs2vidr=2.and.gnCtov=1)
              sele tovm
              netunlock()
            endif

            sele tov
            netunlock()
            nuse('pr1')
            nuse('pr2')
            set key K_SPACE to
            return (.F.) // .F.
          endif

#endif
        if (zenr=0.and.rs2vidr=2)
          wmess('ВНИМАНИЕ!!! Цена нулевая', 1)
        endif

        if (zenr#0.and.zenr<opt_r.and.rs2vidr=2)
          wmess('ВНИМАНИЕ!!! Цена меньше закупочной', 1)
        endif

        /*           if zenr#0.and.gnCenr=0.and.zenr<zen_r.and.gnVo#1.and.gnAdm#1.and.who#1
         *              wmess('ВНИМАНИЕ!!! Цена меньше допустимой',1)
         *              zenr=zen_r
         *              loop
         *           endif
         *           if tcenr=ptcenr
         *              bzenr=zenr
         *           endif
         */
        exit
      enddo

      rvkvpr++

      if (lastkey()=K_ESC)
        if (rs2vidr=2.and.gnCtov=1)
          sele tovm
          netunlock()
        endif

        sele tov
        netunlock()
        nuse('pr1')
        nuse('pr2')
        set key K_SPACE to
        return (.f.)
      endif

    endcase

  endif

  /********************************** */
  if (Otvr=1)
    osvo_r=osvo_r+kol_rr-kol_r
    osv_r=0
    osfm_r=0
    osfo_r=0
  else
    osvo_r=0
    osv_r=osv_r+kol_rr-kol_r
    osfm_r=osfm_r+kol_rr-kol_r
    if (!empty(dopr))
      osfo_r=osfo_r+kol_rr-kol_r
    endif

  endif

  if (gnArm=3)
    if (iif(Otvr=0, osv_r<0, osvo_r<0).and.gnRegrs=0.and.cor_r#2.and.kol_rr<kol_r.and.przr=0.and.!gnRoz=1.and.!gnOst0=1)
      wmess('Остатка недостаточно', 1)
      if (rs2vidr=2.and.gnCtov=1)
        sele tovm
        netunlock()
      endif

      sele tov
      netunlock()
      nuse('pr1')
      nuse('pr2')
      return (.f.)
    else
      sele tov
      netrepl('osv,osfm,osvo', 'osv_r,osfm_r,osvo_r', 1)
      if (fieldpos('osfo')#0)
        if (!empty(dopr))
          netrepl('osfo', 'osfo_r', 1)
        endif

      endif

      if (gnCtov=1)
        sele tovm
        if (netseek('t1', 'sklr,mntov_r'))
          osfm_r=osfm
          osv_r=osv
          osvo_r=osvo
          if (fieldpos('osfo')#0)
            osfo_r=osfo
          else
            osfo_r=0
          endif

          do case
          case (cor_r=1.or.cor_r=0.or.cor_r=2)// Коррекция
            if (Otvr=1)
              osvo_r=osvo_r+kol_rr-kol_r
            else
              osv_r=osv_r+kol_rr-kol_r
              osfm_r=osfm_r+kol_rr-kol_r
              if (!empty(dopr))
                osfo_r=osfo_r+kol_rr-kol_r
              endif

            endif

          endcase

          netrepl('osv,osfm,osvo', 'osv_r,osfm_r,osvo_r', 1)
          if (fieldpos('osfo')#0)
            if (!empty(dopr))
              netrepl('osfo', 'osfo_r', 1)
            endif

          endif

        endif

      endif

    endif

  endif

  svp_r=ROUND(zenr*kol_r, 2)
  sr_r=ROUND(opt_r*kol_r, 2)

  if (pbzenr=1)
    bsvpr=ROUND(bzenr*kol_r, 2)
  endif

  if (pxzenr=1)
    xsvpr=ROUND(xzenr*kol_r, 2)
  endif

  if (vor=2)
    svpcr=ROUND(cenpr_r*kol_r, 2)
  endif

  if (gnKt=0.and.zenr#zen_r.or.bzenr#bzen_r)
    rso(18, ktl_r, ktlp_r)
  endif

  if (kol_rr#0.and.kol_rr#kol_r.and.kol_r#0)
    rso(4, ktl_r, ktlp_r)
  endif

  if (kol_rr#0.and.kol_r=0)//.and. !empty(dotr)
    rso(5, ktl_r, ktlp_r)
  /*   rso(14,ktl_r,ktlp_r) */
  endif

  /*if cor_r=2.and.gnArm=3
   *   rso(5,ktl_r,ktlp_r)
   *endif
   */

  sele rs2
  /* RS2 */
  prinsrs2r=0
  prdelrs2r=0
  if (gnCtov=1)
    nooptr=getfield('t1', 'mntov_r', 'ctov', 'noopt')
  else
    nooptr=0
  endif

  if (!netseek('t3', 'ttnr,ktlp_r,ppt_r,ktl_r'))//.and.ktlp_r#ktl_rr
    if (kol_r#0)
      netadd()
      prinsrs2r=1
      netrepl('ttn,mntov,ktl,ktlp,kvp,svp,sr,sert,ppt,izg,svpc,Otv,ktlm,ktlmp,tn',                               ;
               'ttnr,mntov_r,ktl_r,ktlp_r,kol_r,svp_r,sr_r,rs2sert_r,ppt_r,izg_r,svpcr,Otv_r,ktl_r,ktlp_r,nooptr' ;
            )
      if (fieldpos('mntovp')#0)
        netrepl('mntovp', 'mntovp_r')
      endif

      netrepl('zen,zenp,pzen,prZenp', 'zenr,zenpr,prZenr,prZenpr')
      if (roun(prZenpr, 2)=roun(prBZenpr, 2).and.prZen2r=0.and.nofr=1)
        netrepl('bzen,bzenp,pbzen,prBZenp', 'zenr,zenpr,prZenr,prZenpr')
      else
        netrepl('bzen,bzenp,pbzen,prBZenp', 'bzenr,bzenpr,prBZenr,prBZenpr')
      endif

      /*      netrepl('bzen,bzenp,pbzen,prBZenp','bzenr,bzenpr,prBZenr,prBZenpr') */
      netrepl('xzen,xzenp,pxzen,prXZenp', 'xzenr,xzenpr,prXZenr,prXZenpr')
      if (fieldpos('MZen')#0)
        netrepl('MZen', 'MZenr')
      endif

      if (fieldpos('tcenp')#0)
        netrepl('tcenp', 'rtcenpr')
      endif

      if (fieldpos('tcenb')#0)
        netrepl('decp,tcenb,decb,tcenx,decx', 'rdecpr,rtcenbr,rdecbr,rtcenxr,rdecxr')
      endif

      if (fieldpos('bsvp')#0)
        netrepl('bsvp,xsvp', 'bsvpr,xsvpr')
      endif

      if (fieldpos('cvzbb')#0)
        netrepl('cvzbb,cvzbt', 'cvzbbr,cvzbtr')
      endif

      if (fieldpos('ktlkt')#0)
        netrepl('ktlkt', 'ktlkt_r')
      endif

      if (prinsrs2r=1.and.(ddcr#date().and.empty(docguidr).or.!empty(docguidr)))
        rso(19, ktl_r, ktlp_r)
      endif

      if (Otvr=1)
        crprotp()
      endif

    endif

  else
    netrepl('kvp,svp,sr,sert,svpc', 'kol_r,svp_r,sr_r,rs2sert_r,svpcr')
    netrepl('zen,zenp,pzen,prZenp', 'zenr,zenpr,prZenr,prZenpr')
    if (roun(prZenpr, 2)=roun(prBZenpr, 2).and.prZen2r=0.and.nofr=1)
      netrepl('bzen,bzenp,pbzen,prBZenp', 'zenr,zenpr,prZenr,prZenpr')
      bzenr=zenr
      bzenpr=zenpr
      prBZenr=prZenr
      prBZenpr=prZenpr
    else
      netrepl('bzen,bzenp,pbzen,prBZenp', 'bzenr,bzenpr,prBZenr,prBZenpr')
    endif

    netrepl('xzen,xzenp,pxzen,prXZenp', 'xzenr,xzenpr,prXZenr,prXZenpr')
    if (fieldpos('MZen')#0)
      if (round(MZen, 3)#round(MZenr, 3))
        netrepl('MZen', 'MZenr')
      endif

    endif

    if (fieldpos('tcenp')#0)
      netrepl('tcenp', 'rtcenpr')
    endif

    if (fieldpos('tcenb')#0)
      netrepl('decp,tcenb,decb,tcenx,decx', 'rdecpr,rtcenbr,rdecbr,rtcenxr,rdecxr')
    endif

    if (fieldpos('bsvp')#0)
      netrepl('bsvp,xsvp', 'bsvpr,xsvpr')
    endif

    if (fieldpos('cvzbb')#0)
      netrepl('cvzbb,cvzbt', 'cvzbbr,cvzbtr')
    endif

    if (fieldpos('ktlkt')#0)
      netrepl('ktlkt', 'ktlkt_r')
    endif

    if (Otvr=1)
      crprotp()
    endif

    sele rs2
    if (kvp=0)
      prdelrs2r=1
      if (ppt_r=1)
        prdelrs2r=1
        netdel()
      endif

    endif

  endif

  rcrs2m_r=0
  if (gnCtov=1)
    if (rs1->vo=9.and.(rs1->kop=174.or.rs1->kopi=174).and.mk174r=0.and.int(mntov_r/10000)>1)
      mk174r=getfield('t1', 'mntov_r', 'ctov', 'mkeep')
    endif

    /* RS2M */
    sele rs2m
    if (!netseek('t3', 'ttnr,mntovp_r,ppt_r,mntov_r'))
      if (kol_r#0)
        netadd()
        /*         netrepl('ttn,mntov,mntovp,kvp,svp,sr,sert,ppt,izg,mntovm,mntovmp,Otv','ttnr,mntov_r,mntovp_r,kol_r,svp_r,sr_r,rs2sert_r,ppt_r,izg_r,mntov_r,mntovp_r,1') */
        netrepl('ttn,mntov,mntovp,kvp,svp,sr,sert,ppt,izg,Otv', 'ttnr,mntov_r,mntovp_r,kol_r,svp_r,sr_r,rs2sert_r,ppt_r,izg_r,1')
        netrepl('zen,zenp,pzen,prZenp', 'zenr,zenpr,prZenr,prZenpr')
        if (roun(prZenpr, 2)=roun(prBZenpr, 2).and.prZen2r=0.and.nofr=1)
          netrepl('bzen,bzenp,pbzen,prBZenp', 'zenr,zenpr,prZenr,prZenpr')
        else
          netrepl('bzen,bzenp,pbzen,prBZenp', 'bzenr,bzenpr,prBZenr,prBZenpr')
        endif

        netrepl('xzen,xzenp,pxzen,prXZenp', 'xzenr,xzenpr,prXZenr,prXZenpr')
        if (fieldpos('MZen')#0)
          if (round(MZen, 3)#round(MZenr, 3))
            netrepl('MZen', 'MZenr')
          endif

        endif

        if (fieldpos('bsvp')#0)
          netrepl('bsvp,xsvp', 'bsvpr,xsvpr')
        endif

      endif

    else
      cntmr=Otv
      if (prinsrs2r=1)
        cntmr=cntmr+1
      endif

      if (prdelrs2r=1)
        cntmr=cntmr-1
      endif

      if (cntmr<0)
        cntmr=0
      endif

      if (cntmr>9)
        cntmr=0
      endif

      netrepl('kvp,svp,sert,Otv,sr',                                            ;
               'kvp-kol_rr+kol_r,svp-svp_rr+svp_r,rs2sert_r,cntmr,sr-sr_rr+sr_r' ;
            )
      if (fieldpos('bsvp')#0)
        netrepl('bsvp,xsvp', 'bsvp-bsvp_rr+bsvpr,xsvp-xsvp_rr+xsvpr')
      endif

      zenmr=zenr
      prZenmr=prZenr
      bzenmr=bzenr
      prBZenmr=prBZenr
      xzenmr=xzenr
      prXZenmr=prXZenr
      if (cntmr>1)
        if (ndsr=2.or.ndsr=3.or.ndsr=5)
          zenmr=ROUND(svp/kvp, 3)
        else
          zenmr=ROUND(svp/kvp, 2)
        endif

        prZenmr=roun((zenmr/zenpr-1)*100, 2)
        if (abs(prZenmr)>9990)
          prZenmr=0
        endif

        if (fieldpos('bsvp')#0)
          if (pndsr=2.or.pndsr=3.or.pndsr=5)
            bzenmr=ROUND(bsvp/kvp, 3)
          else
            bzenmr=ROUND(bsvp/kvp, 2)
          endif

          if (xndsr=2.or.xndsr=3.or.xndsr=5)
            xzenmr=ROUND(xsvp/kvp, 3)
          else
            xzenmr=ROUND(xsvp/kvp, 2)
          endif

          prBZenmr=roun((bzenmr/bzenpr-1)*100, 2)
          if (abs(prBZenmr)>999)
            prBZenmr=0
          endif

          prXZenmr=roun((xzenmr/xzenpr-1)*100, 2)
          if (abs(prXZenmr)>999)
            prXZenmr=0
          endif

        endif

      endif

      netrepl('zen,zenp,pzen,prZenp', 'zenmr,zenpr,prZenmr,prZenpr')
      netrepl('bzen,bzenp,pbzen,prBZenp', 'bzenmr,bzenpr,prBZenmr,prBZenpr')
      netrepl('xzen,xzenp,pxzen,prXZenp', 'xzenmr,xzenpr,prXZenmr,prXZenpr')
      if (fieldpos('MZen')#0)
        if (round(MZen, 3)#round(MZenr, 3))
          netrepl('MZen', 'MZenr')
        endif

      endif

      if (roun(kvp, 0)=0.and.ppt_r=1)
        netdel()
      endif

    endif

    rcrs2m_r=recn()
  endif

  /* Удаление позиции с привязанным товаром */
  sele rs2
  if (kol_r=0.and.ppt_r=0)
    set order to tag t3
    while (ktlp=ktlp_r.and.ttn=ttnr)
      ppt_rr=ppt
      ktl_rr=ktl
      ktlp_rr=ktlp
      mntov_rr=mntov
      kvp_rr=kvp
      svp_rr=svp
      sr_rr=sr
      zen_rr=zen
      if (ktl_rr=ktlp_rr)
        mntovp_rr=mntov_rr
      else
        if (fieldpos('mntovp')#0)
          mntovp_rr=mntovp
        endif

        if (mntovp_rr=0)
          mntovp_rr=getfield('t1', 'sklr,ktlp_rr', 'tov', 'mntov')
        endif

      endif

      if (ppt_rr#0)       // Привязанный товар
        sele tov
        if (netseek('t1', 'sklr,ktl_rr'))
          Otv_rr=Otv
          if (Otv_rr=0)
            netrepl('osv,osfm', 'osv+kvp_rr,osfm+kvp_rr', 1)
            if (!empty(dopr))
              if (fieldpos('osfo')#0)
                netrepl('osfo', 'osfo+kvp_rr', 1)
              endif

            endif

          else
            netrepl('osvo', 'osvo+kvp_rr', 1)
          endif

        endif

        if (gnCtov=1)
          sele tovm
          if (netseek('t1', 'sklr,mntov_rr'))
            if (Otv_rr=0)
              netrepl('osv,osfm', 'osv+kvp_rr,osfm+kvp_rr', 1)
              if (!empty(dopr))
                if (fieldpos('osfo')#0)
                  netrepl('osfo', 'osfo+kvp_rr', 1)
                endif

              endif

            else
              netrepl('osvo', 'osvo+kvp_rr', 1)
            endif

          endif

        endif

      endif

      if (gnCtov=1)
        if (ppt_rr#0)
          sele rs2m
          if (prrs2mr=0)
            if (netseek('t3', 'ttnr,mntovp_rr,ppt_rr,mntov_rr'))
              netrepl('kvp,Otv,svp,sr', {kvp-kvp_rr,Otv-1,round(kvp*zen,2),sr-sr_rr})
            endif

            if (kvp=0)
              netdel()
            endif

          else
            if (netseek('t3', 'ttnr,mntovp_rr,ktlp_rr,ppt_rr,mntov_rr,ktl_rr'))
              netrepl('kvp,Otv,svp,sr', {kvp-kvp_rr,Otv-1,round(kvp*zen,2),sr-sr_rr})
            else
              if (netseek('t3', 'ttnr,mntovp_rr,ppt_rr,mntov_rr'))
                netrepl('kvp,Otv,svp,sr', {kvp-kvp_rr,Otv-1,round(kvp*zen,2),sr-sr_rr})
              endif

            endif

            if (kvp=0)
              netdel()
            endif

          endif

        endif

      endif

      sele rs2
      if (ppt_rr=0.and.recn()=rcrs2r)
        netdel()
      else
        if (ppt_rr#0)
          netdel()
        endif

      endif

      skip
    enddo

    sele rs2
    set order to tag t1
    k1t_r=0
  endif

  if (gnCtov=1)
    sele rs2m
    if (rcrs2m_r#0)
      go rcrs2m_r
      if (kvp=0.and.ppt=0)
        netdel()
      endif

    endif

  endif

  prModr=1
  nuse('pr1')
  nuse('pr2')
  sele tov
  netunlock()
  if (rs2vidr=2.and.gnCtov=1)
    sele tovm
    netunlock()
  endif

  set key K_SPACE to
  return (.t.)

/***********************************************************
 * wkol() -->
 *   Параметры :
 *   Возвращает:
 */
static function wkol()
  /*if gnVo=6 */
  set key K_SPACE to rs2kol()
  /*endif */
  return (.t.)

/***********************************************************
 * vkol() -->
 *   Параметры :
 *   Возвращает:
 */
static function vkol()
  set key K_SPACE to
  return (.t.)

/***********************************************************
 * rs2kol() -->
 *   Параметры :
 *   Возвращает:
 */
static function rs2kol()
  if (kol_r=0)
    kol_r=osv_r
  endif

  set key K_SPACE to
  return (kol_r)

/***************************************************************************** */
function sndsdoc()
/* Загрузка товара  из отгр неподтв ТТН по клиенту с очичткой ТТН источников
 *****************************************************************************
 */
#ifndef __CLIP__
    if (gnEnt=21.and.kplr=3048721.and.vor=9.and.kopr#169)
      ttnndsr=ttnr
      sele rs1
      go top
      while (!eof())
        if (kpl#3048721)
          skip
          loop
        endif

        if (prz=1)
          skip
          loop
        endif

        if (empty(dop))
          skip
          loop
        endif

        ttnsr=ttn
        sele rs2
        while (netseek('t1', 'ttnsr'))
          netrepl('ttn,ttns', 'ttnndsr,ttnsr')
        enddo

        sele rs1
        netrepl('ttnt', 'ttnndsr')
        sele rs1
        skip
      enddo

      nuse('rs2nds')
    endif

#endif
  return (.t.)
