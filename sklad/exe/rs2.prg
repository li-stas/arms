/***********************************************************
 * Модуль    : rs2.prg
 * Версия    : 0.0
 * Автор     :
 * Дата      : 09/24/19
 * Изменен   :
 * Примечание: Текст обработан утилитой CF версии 2.02
 */

#include "common.ch"
#include "inkey.ch"
sele tovsrt
set orde to tag t1
sele rs2
set rela to
set rela to str(sklr, 7)+str(ktlp, 9) into tovsrt
set orde to tag t1
netseek('t1', 'ttnr')
inde on str(int(rs2->ktlp/1000000))+tovsrt->nat+str(rs2->ktlp, 9)+str(rs2->ppt)+str(rs2->ktl) tag s1 to tnat for ttn=ttnr
go top
if (!bof())
  rcrs2r=recn()
else
  rcrs2r=1
endif
/******************************************* */
apcenr=0
prF1r=0
while (.t.)               // Товарная часть документа по партиям
  SELE rs2
  go rcrs2r
  if (ttn#ttnr)
    netseek('t1', 'ttnr')
    if (!bof())
      rcrs2r=recn()
    else
      rcrs2r=1
    endif

  endif

  if (prF1r=0)
    if (rs1->prz=0)
      if (gnArnd#0)
        foot('F2,F3,F4,F5,F6,F7,F8,F9,F10', 'Дог.ц,Д к,Корр,Акт,Лиц,Аттр,Вид,Ден,БСО')
      else
        if (gnEnt=21)
          foot('F2,F3,F4,F5,F6,F7,F8,F9,F10', 'Дог.ц,Д к,Корр,Об,Лиц,Аттр,Вид,Ден,БСО')
        else
          foot('F2,F3,F4,F5,F6,F7,F8,F9,F10', 'Дог.ц,Д к,Корр,СД,Лиц,Аттр,Вид,Ден,БСО')
        endif

      endif

    else
      foot('F5,F7,F8,F9,F10', 'Акт,Аттр,Вид,Деньги,БСО')
    endif

  else
    if (pr177r=2.or.pr169r=2.or.pr129r=2.or.pr139r=2)//pr169rEQ2(ttnr)
      foota('F2,F3,F4,F5,F6,F7,F8,F9,F10', 'Нац,Синхр,ПривТ,Было,DOKK,Серт,2Ц,Прот,ДтМод')
    else
      foota('F2,F3,F4,F5,F6,F7,F8,F9,F10', 'Нац,ЗаявКПК,ПривТ,Было,DOKK,Серт,2Ц,Прот,ДтМод')
    endif

  endif

  if (pstr=0)
    @ 2, 62 say 'С/Т' color 'r+/n'
  else
    @ 2, 62 say 'С/Т' color 'gr+/n'
  endif

  if (ptr=1)
    @ 2, col()+1 say 'Тара' color 'r+/n'
  else
    @ 2, col()+1 say 'Тара' color 'gr+/n'
  endif

  if (bsor#0)
    @ 2, col()+1 say 'БСО'+str(bsor, 2) color 'w+/n'
  endif

  if (subs(serr, 2, 1)='1')
    @ 2, 76 say 'Серт' color 'r+/n'
  endif

  if (gnOt=0)
    foror=nil
  else
    foror="getfield('t1','sklr,rs2->ktlp','tov','ot')=gnOt"
  endif

  if (!EMPTY(rs1->(FIELDPOS("KopI"))) .AND. !EMPTY(rs1->KopI))
    qIr:=mod(rs1->KopI, 100)
    tCen_r:=getfield('t1', 'gnD0k1,gnVu,gnVo,qIr', 'soper', 'tcen')
    cTopHead_TOVAR := nrs2r+"_"+IIF(.T.,;//rs1->Kop # rs1->KopI .AND. !EMPTY(rs1->KopI),;
                                     ALLTRIM(getfield('t1', 'tCen_r', 'tCen', 'ntcen')), ;
                                     ""                                                      ;
                                  )
  else
    cTopHead_TOVAR:= nrs2r
  endif

  cTopHead_TOVAR:=nrs2r+' '+alltrim(nnapr)

  sele rs2
  set orde to tag s1
  go rcrs2r
  //  wait ordsetfocus()
  // wait dbrelation()
  // #ifdef __CLIP__
  //   outlog(__FILE__,__LINE__,"tag",ordsetfocus())
  //   outlog(__FILE__,__LINE__,"rel",dbrelation(1))
  //  outlog(__FILE__,__LINE__,"relsel",dbrselect(1))
  // *#endif

  do case
  case (prZen2r=0)
    if (prNacr=0)
      if (gnEnt=21)
        rcrs2r=slcf('rs2', 8, 1, 10,, "e:ktl h:'Код' c:n(9) e:getfield('t1','sklr,rs2->ktl','tov','nat') h:'Наименование' c:c(26) e:iif(getfield('t1','sklr,rs2->ktl','tov','cenbt')#0,1,0) h:'Б' c:n(1) e:getfield('t1','sklr,rs2->ktl','tov','nei') h:'Изм' c:c(3) e:kvp h:'Количество' c:n(9,3) e:otv h:'O' c:n(1) e:iif((gnArm=2.or.gnArm=6),bzen,zen) h:'Цена' c:n(9,3) e:iif((gnArm=2.or.gnArm=6),ROUND(kvp*bzen,2),svp) h:'Сумма' c:n(10,2)",,, 1, 'ttn=ttnr', foror,, cTopHead_TOVAR)
      else
        rcrs2r=slcf('rs2', 8, 1, 10,, "e:ktl h:'Код' c:n(9) e:getfield('t1','sklr,rs2->ktl','tov','nat') h:'Наименование' c:c(29) e:getfield('t1','sklr,rs2->ktl','tov','nei') h:'Изм' c:c(3) e:kvp h:'Количество' c:n(9,3) e:otv h:'O' c:n(1) e:iif((gnArm=2.or.gnArm=6),bzen,zen) h:'Цена' c:n(9,3) e:iif((gnArm=2.or.gnArm=6),ROUND(kvp*bzen,2),svp) h:'Сумма' c:n(10,2)",,, 1, 'ttn=ttnr', foror,, cTopHead_TOVAR)
      endif

    else
      rcrs2r=slcf('rs2', 8, 1, 10,, "e:ktl h:'Код' c:n(9) e:getfield('t1','sklr,rs2->ktl','tov','nat') h:'Наименование' c:c(29) e:getfield('t1','sklr,rs2->ktl','tov','nei') h:'Изм' c:c(3) e:kvp h:'Количество' c:n(9,3) e:otv h:'O' c:n(1) e:iif((gnArm=2.or.gnArm=6),bzen,zen) h:'Цена' c:n(9,3) e:iif((gnArm=2.or.gnArm=6),pbzen,pzen) h:'Наценка' c:n(10,2)",,, 1, 'ttn=ttnr', foror,, cTopHead_TOVAR)
    endif

  case (prZen2r=1)
    if (prNacr=0)
      rcrs2r=slcf('rs2', 8, 1, 10,, "e:ktl h:'Код' c:n(9) e:getfield('t1','sklr,rs2->ktl','tov','nat') h:'Наименование' c:c(29) e:getfield('t1','sklr,rs2->ktl','tov','nei') h:'Изм' c:c(3) e:kvp h:'Количество' c:n(9,3) e:otv h:'O' c:n(1) e:bzen h:'Цена 2' c:n(9,3) e:ROUND(kvp*bzen,2) h:'Сумма 2' c:n(10,2)",,, 1, 'ttn=ttnr', foror,, cTopHead_TOVAR)
    else
      rcrs2r=slcf('rs2', 8, 1, 10,, "e:ktl h:'Код' c:n(9) e:getfield('t1','sklr,rs2->ktl','tov','nat') h:'Наименование' c:c(29) e:getfield('t1','sklr,rs2->ktl','tov','nei') h:'Изм' c:c(3) e:kvp h:'Количество' c:n(9,3) e:otv h:'O' c:n(1) e:bzen h:'Цена 2' c:n(9,3) e:pbzen h:'Наценка' c:n(10,2)",,, 1, 'ttn=ttnr', foror,, cTopHead_TOVAR)
    endif

  case (prZen2r=2)
    if (prNacr=0)
      rcrs2r=slcf('rs2', 8, 1, 10,, "e:ktl h:'Код' c:n(9) e:getfield('t1','sklr,rs2->ktl','tov','nat') h:'Наименование' c:c(29) e:getfield('t1','sklr,rs2->ktl','tov','nei') h:'Изм' c:c(3) e:kvp h:'Количество' c:n(9,3) e:otv h:'O' c:n(1) e:xzen h:'Цена 3' c:n(9,3) e:ROUND(kvp*xzen,2) h:'Сумма 3' c:n(10,2)",,, 1, 'ttn=ttnr', foror,, cTopHead_TOVAR)
    else
      rcrs2r=slcf('rs2', 8, 1, 10,, "e:ktl h:'Код' c:n(9) e:getfield('t1','sklr,rs2->ktl','tov','nat') h:'Наименование' c:c(29) e:getfield('t1','sklr,rs2->ktl','tov','nei') h:'Изм' c:c(3) e:kvp h:'Количество' c:n(9,3) e:otv h:'O' c:n(1) e:xzen h:'Цена 3' c:n(9,3) e:pxzen h:'Наценка' c:n(10,2)",,, 1, 'ttn=ttnr', foror,, cTopHead_TOVAR)
    endif

  endcase

  sele rs2
  set orde to tag t3
  go rcrs2r
  mntovr=mntov
  mntovpr=mntovp
  ktlr=ktl
  ktlpr=ktlp
  zenr=zen
  if (fieldpos('MZen')#0)
    MZenr=MZen
  else
    MZenr=0
  endif

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
  kvpr=kvp
  svpr=svp
  if (fieldpos('bsvp')#0)
    bsvpr=bsvp
  else
    bsvpr=0
  endif

  if (fieldpos('xsvp')#0)
    xsvpr=xsvp
  else
    xsvpr=0
  endif

  if (fieldpos('tcenp')#0)
    rtcenpr=tcenp
  else
    rtcenpr=0
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
    rdecxr=0
  endif

  srr=sr
  rs2sertr=sert
  pptr=ppt
  kfr=kf
  sfr=sf
  otvr=otv
  if (fieldpos('bon')#0)
    kvpbonr=kvpbon
    bonr=bon
  else
    kvpbonr=0
    bonr=0
  endif

  if (fieldpos('skbon')#0)
    skbonr=rs2->skbon
  else
    skbonr=0
  endif

  if (fieldpos('cvzbb')#0)
    cvzbbr=cvzbb
    cvzbtr=cvzbt
  else
    cvzbbr=0
    cvzbtr=0
  endif

  do case
  case (lastkey()=K_F1)   // F1
    if (prF1r=0)
      prF1r=1
    else
      prF1r=0
    endif

  case (lastkey()=K_ALT_F2)// Наценки/скидки
    if (prNacr=0)
      prNacr=1
    else
      prNacr=0
    endif

    loop
  case (lastkey()=K_F10.and.gnCtov=1.and.rs1->prz=0)// БСО
    rs2bso()
    prModr=1
  case (lastkey()=K_ALT_F8.and.(pbzenr=1.or.gnAdm=1))// По 2-й цене
    do case
    case (prZen2r=0)
      prZen2r=1
    case (prZen2r=1)
      prZen2r=2
    case (prZen2r=2)
      prZen2r=0
    endcase

    loop
  case (prdp().and.(lastkey()=K_ENTER.or.lastkey()=K_INS).and.rs1->prz=0.and.iif(gnVo=9, empty(dfpr), .t.).and.who#0)//.and.(who=2.or.who=3.or.who=4)   // Добавить из справочника
    rtovslc(ktlr, ktlpr)
    pere(1)               // Перерасчет без rs3
  case (lastkey()=K_F3.and.prdp().and.rs1->prz=0.and.iif(gnVo=9, empty(dfpr), .t.).and.who#0)//.and.(who=2.or.who=3.or.who=4)  // Добавить код
    @ 24, 0 clea
    ktlr=1
    while (ktlr#0)
      ktlr=0
      setcolor('g/n,n/g')
      @ 24, 1 say 'Введите код ' get ktlr pict '999999999' valid CheckGr350()
      read
      if (ktlr#0)
        if (gnEnt=20.and.kopr=169.and.int(ktlr/1000000)=340)
          wmess('АЛКОГОЛЬ на 169 НИЗЗЯ!!!', 2)
          loop
        endif

        if (gnEnt=20.and.kopr=168.and.int(ktlr/1000000)#340)
          wmess('Только АЛКОГОЛЬ на 168', 2)
          loop
        endif

        sele tov
        if (netseek('t1', 'sklr,ktlr'))
          mntovr=mntov
          if (gnVo=6.and.otv#0)
            wmess('Отв.хран.НЕЛЬЗЯ!', 2)
            loop
          endif

          if (gnEnt=20)
            if (kopr=177)
              if (getfield('t1', 'mntovr', 'ctov', 'akc')#prakcr)
                wmess('Только Акция!', 2)
                loop
              endif

            else
              if (getfield('t1', 'mntovr', 'ctov', 'akc')#0)
                wmess('Товар Акция НЕЛЬЗЯ!', 2)
                loop
              endif

              //                          if kopir=177
              //                             if getfield('t1','mntovr','ctov','akc')=2
              //                                 wmess('Товар Акция НЕЛЬЗЯ!',2)
              //                                loop
              //                             endif
            //                          endif
            endif

            if (rs1->vo=9.and.(rs1->kop=174.or.rs1->kopi=174))
              if (mk174r=0)
                if (int(mntovr/10000)>1)
                  mk174r=getfield('t1', 'mntovr', 'ctov', 'mkeep')
                endif

              else
                if (int(mntovr/10000)>1)
                  mk174_r=getfield('t1', 'mntovr', 'ctov', 'mkeep')
                  if (mk174r#mk174_r)
                    nmkeep_r=alltrim(getfield('t1', 'mk174r', 'mkeep', 'nmkeep'))
                    wmess('Только'+' '+nmkeep_r+' '+'НЕЛЬЗЯ!', 2)
                    loop
                  endif

                endif

              endif

            endif

          endif

          if (gnCtov=1.and.coptr#'opt'.and.&coptr=0)
            cenr=getfield('t1', 'mntovr', 'ctov', coptr)
            if (cenr#0.and.cenr#&coptr)
              netrepl(coptr, 'cenr')
            endif

          endif

          if (gnVo#6.and.&coptr=0)
            wmess('Нулевая цена в прайсе', 2)
            ktlr=0
            loop
          endif

          if (gnVo=6.and.kopr=189.and.int(ktlr/1000000)>1)
            wmess('Только тара')
            ktlr=0
            loop
          endif

          if (gnCtov=1)
            if (bsor#0.and.int(ktlr/1000000)>1)
              tgrpr=getfield('t1', 'int(ktlr/1000000)', 'cgrp', 'tgrp')
              if (tgrpr=0)
                wmess('БСО - Только АЛКОГОЛЬ!!!', 2)
                ktlr=0
                loop
              endif

            endif

            mntovr=mntov
          /*                       obncen(mntovr) */
          endif

          rs2ins(0)
          pere(1)         // Перерасчет без rs3
          prModr=1
          exit
        else
          wmess('Нет продукции с таким кодом', 2)
        endif

      endif

    enddo

  case (lastkey()=K_ALT_F3)// Просмотр заявки/Проверка 177 pr177=2 169 pr169=2
    do case
    case (pr177r=2)
      chkuc(177)
    case (pr169r=2)
      chkuc(169)
    case (pr129r=2)
      chkuc(129)
    case (pr139r=2)
      chkuc(139)
    case (rs1->ttnt=999999)
      chkuc(999)
    otherwise
      ttn_rrr=ttnr
      if (gnEnt=20.and.(kopr=177.or.kopr=168).and.docidr#0)
        ttnr=docidr
      endif

      if (gnEnt=21.and.kopir=177.and.docidr#0)
        ttnr=docidr
      endif

      if (netfile('rs1kpk'))
        netuse('rs1kpk')
        netuse('rs2kpk')
        sele rs1kpk
        if (netseek('t1', 'ttnr'))
          skpkr=skpk
          sele rs2kpk
          if (netseek('t1', 'ttnr,skpkr'))
            rcrs2kpkr=recn()
            while (.t.)
              foot('F2', 'Обновить')
              go rcrs2kpkr
              rcrs2kpkr=slcf('rs2kpk', 8, 1, 11,, "e:mntov h:'Код' c:n(7) e:getfield('t1','rs2kpk->mntov','ctov','nat') h:'Наименование' c:c(45) e:getfield('t1','rs2kpk->mntov','ctov','nei') h:'Изм' c:c(3) e:kvp h:'Кол заяв' c:n(9,3) e:kvpo h:'Кол пров' c:n(9,3) ",,,, 'skpk=skpkr.and.ttn=ttnr',, 'n/g,n/w', 'Заявка')
              if (lastkey()=K_ESC)
                exit
              endif

              do case
              case (lastkey()=K_F2.and.gnAdm=1)
                zvttno()
              endcase

            enddo

          endif

        endif

        nuse('rs1kpk')
        nuse('rs2kpk')
      endif

      ttnr=ttn_rrr
    endcase

  case (lastkey()=K_F2.and.(who=2.or.who=3.or.who=4).and.(gnVo=9.or.gnVo=2.or.gnVo=3.or.gnVo=6.or.gnVo=1.or.gnVo=5))
    // Скидка/Наценка в цену // .and.empty(dfpr)
    if (pr169r=2.or.pr129r=2.or.pr139r=2)
      wmess('Уценка', 1)
      loop
    endif

    if (gnCenR=1.or.gnAdm=1)// IIF(!EMPTY(Dopr),  gnCenR=1.or.gnAdm=1              ,.T.)
      if (!(gnVo=3.and.gnKt=1))
        RsDogZen()
      endif

    else
      wmess('Документ отгружен', 1)
    endif

  case (lastkey()=K_DEL.and.prdp().and.rs1->prz=0.and.((who=3.or.who=4).or.(empty(dfpr).and.who=2.or.!empty(dfpr).and.who=1).or.gnVo#9.and.who#0))//.and.ktlr=ktlpr // Удалить
    rs2ins(2)
    pere(1)               // Перерасчет без rs3
  case (lastkey()=K_F4.and.prdp().and.rs1->prz=0.and.ktlr=ktlpr.and.who#0)// Коррекция
    rs2ins(1)
    pere(1)               // Перерасчет без rs3
  case (lastkey()=K_ALT_F4.and.prdp().and.rs1->prz=0.and.int(ktlr/1000000)<2.and.who#0)// Коррекция привязки
    clprvz=setcolor('gr+/b,n/bg')
    wprvz=wopen(10, 15, 14, 70)
    wbox(1)
    while (.t.)
      @ 0, 1 say 'Товар   '+' '+str(ktlr, 9)
      @ 1, 1 say 'Родитель' get ktlpr pict '999999999'
      read
      if (lastkey()=K_ESC)
        exit
      endif

      @ 2, 1 prom 'Верно'
      @ 2, col()+1 prom 'Не Верно'
      menu to vnr
      if (vnr=1)
        if (ktlpr=0)
          ktlpr=ktlr
          mntovpr=mntovr
        endif

        sele rs2
        if (ktlpr#ktlr)
          if (!netseek('t1', 'ttnr,ktlpr'))
            go rcrs2r
            wmess('Нет родителя в документе', 1)
            exit
          else
            mntovpr=mntovp
          endif

        else
          mntovpr=mntovr
        endif

        go rcrs2r
        if (ktlr=ktlpr)
          pptr=0
        else
          pptr=1
        endif

        netrepl('mntovp,ktlp,ppt', 'mntovpr,ktlpr,pptr')
        exit
      endif

    enddo

    wclose(wprvz)
    setcolor(clprvz)
  case (lastkey()=K_F5)   // Отдел
    if (gnArnd#0)
      /*               #ifdef __CLIP__
       *                  aprem()
       *               #else
       */
      if (bom(gdTd)<ctod('01.01.2015'))
        aprem()
      else
        apremdu()
      endif

    /*               #endif */
    else
      if (gnEnt=21)
        if (rs1->prz=0.and.empty(rs1->prz).and.rs1->kop=193)
          ttnlist()         //  Объединить из ttnlist.dbf rso.prg
        else
          if (rs1->prz=1)
            wmess('Подтвержден', 2)
            loop
          endif

          if (!empty(rs1->dop))
            wmess('Отгружен', 2)
            loop
          endif

        endif

      else
        rotvpere()
      endif

    /*               sndsdoc()  // rs2ins.prg */
    endif

  /*            sele cskle
   *            if netseek('t1','gnSk')
   *               gnOt=slcf('cskle',,,,,"e:ot h:'От' c:n(2) e:nai h:'Наименование' c:c(20)",'ot',0,,'sk=gnSk')
   *               if netseek('t1','gnSk,gnOt')
   *                  gcNot=nai
   *                  @ 1,60 say gcNot color 'gr+/n'
   *               endif
   *            endif
   *            sele rs2
   */
  case (lastkey()=K_F6.and.who#0.and.!(gnArm=2.or.gnArm=6))// Лицензии
    licc(kplr, kgpr)
  case (lastkey()=K_F7)   //.and.prdp() //.and.rs2->prz=0.and.(gnAdm=1.or.gnRdsp=1.or.gnRdsp=2) // Аттрибуты
    rdsp()
  case (lastkey()=K_F8.and.gnCtov=1.and.(gnAdm=1.or.gnRrs2m=1))// Вид
    if (rs2vidr=1)
      rs2vidr=2
    else
      rs2vidr=1
    endif

    exit
  case (lastkey()=K_ALT_F6)// Проводки
    sele rs2
    prxmlr=0
    if (rs1->kop=160.or.rs1->kop=161)
      if (netseek('t1', 'ttnr'))
        while (ttn=ttnr)
          mntovr=mntov
          uktr=getfield('t1', 'mntovr', 'ctov', 'ukt')
          if (!empty(uktr))
            prxmlr=1
            exit
          endif

          sele rs2
          skip
        enddo

      endif

    endif

    if (rs1->prz=1)
      ttnprov(gnSk, ttnr, 0)
    else
      ttnprov(gnSk, ttnr, 1)
    endif

  case (lastkey()=K_ALT_F7)// Печать сертификатов
    sele rs1
    if (subs(serr, 2, 1)='1')
      serr=stuff(serr, 2, 1, ' ')
      netrepl('ser', 'serr', 1)
      @ 2, 76 say '    ' color 'gr/n'
    else
      serr=stuff(serr, 2, 1, '1')
      netrepl('ser', 'serr', 1)
      @ 2, 76 say 'Серт' color 'r+/n'
    endif

  case (lastkey()=K_ALT_F9)// Протокол
    rs2prot()
  case (lastkey()=K_ALT_F10)// Дата мод
    sele rs1
    netrepl('dtmod,tmmod', 'date(),time()', 1)
  case (lastkey()=K_ALT_F5) // Было  (Заявка)
    if (ttn177r#0)
      ttn177old()
    endif

    if (ttn169r#0)
      ttn169old(169)
    endif

    if (ttn129r#0)
      ttn169old(129)
    endif

    if (ttn139r#0)
      ttn169old(139)
    endif

  /*            if prdp()
   *               rpospere()
   **               zvk()
   *            endif
   */
  case (lastkey()=K_F9)   // Деньги
    esc_rr=1
    exit
  case (lastkey()=K_ESC)  // Выход
    esc_r=1
    exit
  endcase

  sele rs2
  set orde to tag t3
enddo

prZen2r=0
sele rs2
set rela to

/************ */
function rdsp()
  /************ */
  skr=gnSk
  rmskr=gnRmsk
  proplr=0
#ifdef __CLIP__
#else
    if (!empty(dopr))   //.and.rs1->prz=0
      proplr=chkopl(nkklr, 0, skr, ttnr)
    endif

#endif
  clrdsp=setcolor('gr+/b,n/bg')
  wrdsp=wopen(8, 15, 19, 70)
  wbox(1)
  while (.t.)
      if (gnKto=160.or.gnKto=117.or.gnKto=782.or.gnAdm=1.or.gnKto=848)
        @ 0, 1 say 'Оплата'+' ' get DtOplr range dotr, dotr+100
        @ 0, col()+1 say 'Просрочка'+' '+str(date()-DtOplr, 4)+' дней'
        if (rs1->prz=1)
          read
          if (lastkey()=K_ENTER)
            sele rs1
            if (rs1->DtOpl#DtOplr)
              netrepl('DtOpl', 'DtOplr', 1)
              prModr=1
            endif

          endif

        endif

      else
        if (!empty(DtOplr))
           @ 0, 1 say 'Оплата'+' '+dtoc(DtOplr)+' '+'Просрочка'+' '+str(date()-DtOplr, 4)+' дней'
         endif
      endif


    if (gnVo=9.and.rs1->prz=0.and.(gnAdm=1.or.gnRdsp=1.or.gnRdsp=2).and.proplr=0.or.rs1->prz=0.and.gnVo#9)
      @ 1, 1 say 'Фин.подтвержд' get dfpr
      @ 1, col()+1 say 'ENTER,INS,DEL,F2,F3,F4,F10'
      @ 2, 1 say 'Счет-фактура ' get dspr
      if (gnRdsp=1.or.gnAdm=1).and.prdp().or.gnVo#9
        @ 3, 1 say 'Отгрузка     ' get dopr                  ;
         VALID (                                            ;
                 BOM(dopr)=BOM(gdTd)                     ;
                 .OR. BOM(dopr)=BOM(ADDMONTH(gdTd, 1)) ;
                 .OR. EMPTY(dopr)                          ;
              )
      else
        @ 3, 1 say 'Отгрузка     '+' '+dtoc(dopr)
      endif

      @ 3, col()+1 say 'Деньги,Шапка'
      @ 4, 1 say 'Дата возврата'+' '+dtoc(dvzttnr)+' '+tvzttnr
      @ 5, 1 say 'Дата выписки '+' '+dtoc(dvpr)
      @ 6, 1 say 'Дата докум.  '+' '+dtoc(ddcr)+' '+tdcr
      @ 7, 1 say 'Дт отгр. Сист'+' '+dtoc(dtotsr)
      if (bom(gdTd)>=ctod('01.03.2011')                       ;
           .and.(gnAdm=1.or.gnKto=331.or.gnKto=847.or.gnKto=882) ;
        )
        @ 8, 1 say 'N НН         ' get nndsr pict '9999999999' valid chknn()
      endif

      read
      if (lastkey()=K_ESC)
        exit
      endif

      @ 9, 1 prom 'Верно'
      @ 9, col()+1 prom 'Не Верно'
      menu to vnr
      if (vnr=1.and.prdp())
        sele rs1
        do case
        case (!empty(dop).and.empty(dopr))
          // Снять отгрузку
          otgr(1)
          sele rs1
          netrepl('dop,dot,dsp,dvttn', 'dopr,dopr,dspr,dvttnr', 1)
          sele rs1
          rsprv(2, 1)
          rso(15)
        case (empty(dop).and.!empty(dopr))
          // Установить отгрузку
          otgr(2)
          sele rs1
          netrepl('dop,dot,dsp,dvttn', 'dopr,dopr,dspr,dvttnr', 1)
          sele rs1
          rsprv(1, 1)
          rso(16)
        case (!empty(dop).and.!empty(dopr).and.dop#dopr)
          // Изменение даты отгрузки
          sele rs1
          netrepl('dop,dot,dsp,dvttn', 'dopr,dopr,dspr,dvttnr', 1)
          sele rs1
          rsprv(1, 1)
          rso(20)
        otherwise
          sele rs1
          netrepl('dop,dot,dsp,dvttn', 'dopr,dopr,dspr,dvttnr', 1)
        endcase

        sele rs1
        netrepl('DtOpl', 'DtOplr', 1)
        if (gnAdm=1.or.gnKto=331.or.gnKto=847.or.gnKto=882)
          netrepl('nnds', 'nndsr', 1)
        endif

        sele rs1
        do case
        case (!empty(dfp).and.empty(dfpr))
          /* Снять ФП */
          sele rs1
          netrepl('dfp', 'dfpr', 1)
          rso(22)
        case (empty(dfp).and.!empty(dfpr).and.!docblk())
          /* Установить ФП */
          sele rs1
          netrepl('dfp', 'dfpr', 1)
          sele rs1
          rso(23)
        case (!empty(dfp).and.!empty(dfpr).and.dfp#dfpr.and.!docblk())
          /* Изменение ФП */
          sele rs1
          netrepl('dfp', 'dfpr', 1)
          rso(24)
        otherwise
          if (!docblk())
            sele rs1
            netrepl('dfp', 'dfpr', 1)
          endif

        endcase

        prModr=1
        exit
      endif

    else
      @ 1, 1 say 'Фин.подтвержд'+' '+dtoc(dfpr)+' '+tfpr
      @ 2, 1 say 'Счет-фактура '+' '+dtoc(dspr)+' '+tspr
      if (gnKto=160)
        @ 3, 1 say 'Отгрузка     ' get dopr                  ;
         VALID (BOM(dopr)=BOM(gdTd)                     ;
                 .OR. BOM(dopr)=BOM(ADDMONTH(gdTd, 1)) ;
                 .OR. EMPTY(dopr)                          ;
              )
      else
        @ 3, 1 say 'Отгрузка     '+' '+dtoc(dopr)+' '+topr
      endif

      @ 4, 1 say 'Дата возврата'+' '+dtoc(dvzttnr)+' '+tvzttnr
      @ 5, 1 say 'Дата выписки '+' '+dtoc(dvpr)
      @ 6, 1 say 'Дата докум.  '+' '+dtoc(ddcr)+' '+tdcr
      @ 7, 1 say 'Дт отгр.Сист '+' '+dtoc(dtotsr)
      if (bom(gdTd)>=ctod('01.03.2011').and.(gnAdm=1.or.gnKto=160))
        if (gnAdm=1)
          @ 8, 1 say 'N НН         ' get nndsr pict '9999999999' valid chknn()
        endif

        read
        if (lastkey()=K_ESC)
          exit
        endif

        vnr=0
        @ 9, 1 prom 'Верно'
        @ 9, col()+1 prom 'Не Верно'
        menu to vnr
        if (vnr=1.and.prdp())
          sele rs1
          netrepl('nnds', 'nndsr', 1)
          if (gnKto=160)
            netrepl('dop', 'dopr', 1)
            rso(20)
          endif

        endif

      else
        inkey(0)
        if (lastkey()=K_ESC)
          exit
        endif

      endif

    endif

  enddo

  wclose(wrdsp)
  setcolor(clrdsp)
  return

/***********************************************************
 * rs2bso() -->
 *   Параметры :
 *   Возвращает:
 */
function rs2bso()
  cntt21r=0
  sele rs2
  if (netseek('t3', 'ttnr'))
    while (ttn=ttnr)
      kg_r=int(ktl/1000000)
      prtgrpr=getfield('t1', 'kg_r', 'cgrp', 'tgrp')
      cntt21r=cntt21r+prtgrpr
      sele rs2
      skip
    enddo

  else
    cntt21r=1
  endif

  if (cntt21r#0)
    sele rs1
    if (fieldpos('bso')#0)
      if (bso#0)
        bsor=0
      else
        bsor=1
        if (cntt21r-10>0)
        /*            bsor=bsor+int(((cntt21r-10)/21)/1)+iif(mod((cntt21r-10)/21,1)#0,1,0) */
        endif

      endif

      netrepl('bso', 'bsor', 1)
      pere(2)
    else
      bsor=0
      pere(2)
    endif

  else
    sele rs1
    if (fieldpos('bso')#0)
      if (bso#0)
        netrepl('bso', '0', 1)
        pere(2)
      endif

    else
      bsor=0
      pere(2)
    endif

  endif

  if (bsor#0)
    @ 2, 71 say 'БСО'+str(bsor, 2) color 'w+/n'
  else
    @ 2, 71 say space(6)
  endif

  return (.t.)

/***********************************************************
 * otgr() -->
 *   Параметры :
 *   Возвращает:
 */
function otgr(p1)
  /* 1 - снять
   * 2 - установить
   */
  sele rs2
  if (netseek('t3', 'ttnr'))
    while (ttn=ttnr)
      mntovr=mntov
      ktlr=ktl
      kvpr=kvp
      sele tov
      if (netseek('t1', 'sklr,ktlr'))
        if (fieldpos('osfo')#0)
          if (p1=1)
            netrepl('osfo', 'osfo+kvpr')
          endif

          if (p1=2)
            netrepl('osfo', 'osfo-kvpr')
          endif

        endif

      endif

      if (gnCtov=1)
        sele tovm
        if (netseek('t1', 'sklr,mntovr'))
          if (fieldpos('osfo')#0)
            if (p1=1)
              netrepl('osfo', 'osfo+kvpr')
            endif

            if (p1=2)
              netrepl('osfo', 'osfo-kvpr')
            endif

          endif

        endif

      endif

      sele rs2
      if (fieldpos('prosfo')#0)
        if (p1=1)
          netrepl('prosfo', '0')
        else
          netrepl('prosfo', '1')
        endif

      endif

      skip
    enddo

  endif

  return (.t.)

/***********************************************************
 * rs2prot() -->
 *   Параметры :
 *   Возвращает:
 */
function rs2prot()
  local getlist:={}
  if (!file(gcPath_t+'rso1.dbf'))
    return (.t.)
  endif

  netuse('rso1')
  netuse('rso2')
  forr='ttn=ttnr'
  sele rso1
  set orde to tag t2
  if (!netseek('t2', 'ttnr'))
    return (.t.)
  endif

  FldNomr=1
  while (.t.)
    foot('ENTER', 'Просмотр')
    if (fieldpos('docip')#0)
      rcnppr=slce('rso1',,,,, "e:sdv h:'Сумма' c:n(10,2) e:pr49 h:'Ц' c:n(1) e:dnpp h:'  Дата  ' c:d(10) e:tnpp h:' Время  ' c:c(8) e:prnpp h:'В' c:n(2) e:nrs() h:'Операция' c:c(25) e:getfield('t1','rso1->ktonpp','speng','fio') h:'Исполнитель' c:c(12) e:docip h:'IP' c:c(15)",,,, 'ttn=ttnr')
    else
      rcnppr=slce('rso1',,,,, "e:sdv h:'Сумма' c:n(10,2) e:pr49 h:'Ц' c:n(1) e:dnpp h:'  Дата  ' c:d(10) e:tnpp h:' Время  ' c:c(8) e:prnpp h:'В' c:n(2) e:nrs() h:'Операция' c:c(25) e:getfield('t1','rso1->ktonpp','speng','fio') h:'Исполнитель' c:c(12)",,,, 'ttn=ttnr')
    endif

    go rcnppr
    nppr=npp
    do case
    case (lastkey()=K_ESC)
      exit
    case (lastkey()=K_LEFT)
      FldNomr=FldNomr-1
      if (FldNomr=0)
        FldNomr=1
      endif

    case (lastkey()=K_RIGHT)
      FldNomr=FldNomr+1
    case (lastkey()=K_ENTER)
      prosm()
    endcase

    sele rso1
    go rcnppr
  enddo

  return (.t.)

/*********** */
function zvk()
  /************ */
  sele rs2
  if (netseek('t3', 'ttnr'))
    wmess('Документ не пустой')
    return (.t.)
  endif

  /*netuse('crosid') */
  clzv=setcolor('gr+/b,n/bg')
  wzv=wopen(10, 30, 12, 50)
  wbox(1)
  zvr=space(10)
  @ 0, 1 say 'Заявка' get zvr
  read
  wclose(wzv)
  setcolor(clzv)

  crtt('zv', "f:id c:n(10) f:name c:c(40) f:kvp c:n(10,3) f:rkvp c:n(10,3) f:mntov c:n(7) f:nat c:c(40) f:tgrp c:n(1)")
  sele 0
  use zv
  cDelim=CHR(13) + CHR(10)
  hzvr=fopen(zvr)
  n=1
  while (!feof(hzvr))
    if (n<7)
      n=n+1
      aaa=FReadLn(hzvr, 1, 80, cDelim)
      loop
    endif

    aaa=FReadLn(hzvr, 1, 80, cDelim)
    namer=subs(aaa, 5, 40)
    ckolr=subs(aaa, 46, 10)
    cidr=subs(aaa, 59, 10)
    kvpr=val(ckolr)
    idr=val(cidr)
    sele zv
    if (idr#0)
      appe blank
      repl id with idr, name with namer, kvp with kvpr
    endif

  enddo

  fclose(hzvr)
  sele zv
  go top
  while (!eof())
    idr=id
    sele crosid
    locate for id21126515=idr
    if (foun())
      cnatr='n'+alltrim(str(gnKln_c, 8))
      natr=&cnatr
      mntovr=mntov
      sele zv
      repl mntov with mntovr, nat with natr
    endif

    sele zv
    skip
  enddo

  sele zv
  go top
  rczvr=recn()
  save scre to sczv
  while (.t.)
    foot('ENTER,INS', 'Продолжить,Справочник')
    sele zv
    go rczvr
    rczvr=slcf('zv', 1, 1, 18,, "e:name h:'SVOD' c:c(38) e:mntov h:'Код' c:n(7) e:nat h:'SELF' c:c(30)",,, 1)
    if (lastkey()=K_ESC)
      sele zv
      CLOSE
      return
    endif

    if (lastkey()=K_ENTER)
      exit
    endif

    if (lastkey()=K_INS)
      go rczvr
      namer=name
      @ 2, 2 say namer color 'r/w'
      sele tovm
      set orde to tag t2
      go top
      rctovmr=recn()
      while (.t.)
        foot('ENTER,F8', 'Выбрать,Группа')
        rctovmr=slcf('tovm', 1, 40, 18,, "e:mntov h:'Код' c:n(7) e:nat h:'Наименование' c:c(30)")
        if (lastkey()=K_ESC)
          exit
        endif

        do case
        case (lastkey()=K_ENTER)
          go rctovmr
          mntovr=mntov
          natr=nat
          sele zv
          netrepl('mntov,nat', 'mntovr,natr')
          exit
        case (lastkey()=K_F8)
          sele sgrp
          set orde to tag t2
          go top
          rcn_gr=recn()
          while (.t.)
            sele sgrp
            set orde to tag t2
            rcn_gr=recn()
            forgr='.T.'
            kg_r=slcf('sgrp',,,,, "e:kgr h:'Код' c:n(3) e:ngr h:'Наименование' c:c(20)", 'kgr',,,, forgr)
            do case
            case (lastkey()=K_ENTER)
              sele tovm
              if (!netseek('t2', 'sklr,kg_r'))
                go rctovmr
              else
                rctovmr=recn()
              endif

              exit
            case (lastkey()=K_ESC)
              exit
            case (lastkey()>32.and.lastkey()<255)
              sele sgrp
              lstkr=upper(chr(lastkey()))
              if (!netseek('t2', 'lstkr'))
                go rcn_gr
              endif

              loop
            otherwise
              loop
            endcase

          enddo

          sele tovm
          loop
        case (lastkey()>32.and.lastkey()<255)
          sele tovm
          lstkr=upper(chr(lastkey()))
          if (!netseek('t2', 'sklr,int(mntovr/10000),lstkr'))
            go rctovmr
          else
            rctovmr=recn()
          endif

        endcase

      enddo

    endif

  enddo

  rest scre from sczv
  sele zv
  go top
  while (!eof())
    if (mntov=0)
      netdel()
      skip
      if (eof())
        exit
      endif

      loop
    endif

    idr=id
    namer=name
    mntovr=mntov
    natr=nat
    sele crosid
    if (netseek('t1', 'mntovr'))
      netrepl('id21126515,n21126515', 'idr,namer')
      cnr='n'+alltrim(str(gnKln_c, 8))
      netrepl(cnr, 'natr')
    endif

    sele zv
    skip
  enddo

  crtt('tzv', 'f:tgrp c:n(1) f:ntgrp c:c(20)')
  sele 0
  use tzv
  sele 0
  sele zv
  go top
  while (!eof())
    mntovr=mntov
    kg_r=int(mntovr/10000)
    tgrpr=getfield('t1', 'kg_r', 'cgrp', 'tgrp')
    do case
    case (tgrpr=0)
      ntgrpr='Прочий'
    case (tgrpr=1)
      ntgrpr='Алкоголь'
    case (tgrpr=2)
      ntgrpr='Табак'
    endcase

    if (gnEnt=13.and.tgrpr=2)
      sele zv
      skip
      loop
    endif

    if (gnEnt=16.and.tgrpr#2)
      sele zv
      skip
      loop
    endif

    sele tzv
    locate for tgrp=tgrpr
    if (!foun())
      appe blank
      repl tgrp with tgrpr, ntgrp with ntgrpr
    endif

    sele zv
    repl tgrp with tgrpr
    skip
  enddo

  sele tzv
  if (recc()=0)
    wmess('Заявка оформлена')
    sele tzv
    CLOSE
    sele zv
    CLOSE
    return (.t.)
  endif

  while (.t.)
    rctzvr=slcf('tzv',,,,, "e:tgrp h:'Т' c:n(1) e:ntgrp h:'Товар' c:c(20)")
    if (lastkey()=K_ESC)
      sele tzv
      CLOSE
      sele zv
      CLOSE
      return (.t.)
    endif

    sele tzv
    go rctzvr
    dtgrpr=tgrp
    if (lastkey()=K_ENTER)
      exit
    endif

  enddo

  sele zv
  go top
  while (!eof())
    mntovr=mntov
    kol_mr=kvp
    kollr=0
    kg_r=int(mntovr/10000)
    tgrpr=tgrp
    if (dtgrpr#tgrpr)
      sele zv
      skip
      loop
    endif

    rs2mins(0, 1)
    sele zv
    repl rkvp with kollr
    if (rkvp=0)
      dele
    endif

    skip
  enddo

  sele tzv
  CLOSE
  sele zv
  CLOSE
  return (.t.)

/************** */
function aprem()
  /************** */
  dtpremr=gdTd
  dgpremr=0
  dtdgpremr=ctod('')
  claprem=setcolor('gr+/b,n/bg')
  aklr=2
  akldr=3
  waprem=wopen(8, 20, 17, 70)
  store space(15) to tvedr, mehr//,firmr
  mlptr=0
  wbox(1)
  while (.t.)
    @ 0, 1 say 'Фирма     ' get firmr
    @ 1, 1 say 'Дата      ' get dtpremr
    @ 2, 1 say 'Договор N ' get dgpremr pict '9999999999'
    @ 2, col()+1 say 'От  ' get dtdgpremr
    @ 3, 1 say 'Товаровед ' get tvedr
    @ 4, 1 say 'Механик   ' get mehr
    @ 5, 1 say 'К-во экз Д' get akldr pict '9'
    @ 6, 1 say 'К-во экз  ' get aklr pict '9'
    @ 7, 1 prom 'LPT1'
    @ 7, col()+1 prom 'LPT2'
    @ 7, col()+1 prom 'LPT3'
    @ 7, col()+1 prom 'Файл'
    read
    if (lastkey()=K_ESC)
      exit
    endif

    menu to mlptr
    if (lastkey()=K_ESC)
      exit
    endif

    exit
  enddo

  wclose(waprem)
  setcolor(claprem)
  if (mlptr#0)
    set cons off
    do case
    case (mlptr=1)
      set prin to lpt1
    case (mlptr=2)
      set prin to lpt2
    case (mlptr=3)
      set prin to lpt3
    case (mlptr=4)
      set prin to aprem.txt
      mlptr=1
    endcase

    set prin on
    /*   #ifdef __CLIP__
     *       ??chr(27)+'E'+chr(27)+'&l4h25a0O'+chr(27)+'&k2S'+chr(27)+'(3R'+chr(27)+'(s0p18.00h0s1b4102T'+chr(27)
     *   #else
     *     ??chr(27)+'E'+chr(27)+'&l4h25a0O'+chr(27)+'&k2S'+chr(27)+'(3R'+chr(27)+'(s0p29.00h0s1b4102T'+chr(27)
     *   sprnr=chr(27)+'E'+chr(27)+'&l1h25a0O'+chr(27)+'&l3C'+chr(27)+'(3R'+chr(27)+'(s0p29.00h0s1b4102T'+chr(27)
     */
    ??chr(27)+'E'+chr(27)+'&l1h25a0O'+chr(27)+'&l3C'+chr(27)+'(3R'+chr(27)+'(s0p29.00h0s1b4102T'+chr(27)// Книжная А4
    /*      ??chr(27)+'E'+chr(27)+'&l1h26a0O'+chr(27)+'&l5C'+chr(27)+'(3R'+chr(27)+'(s0p25.00h0s1b4102T'+chr(27)  // Книжная А4
     *   #endif
     *   #ifdef __CLIP__
     *      do while aklr>0
     *         araktpp()
     *         arsch()
     *         araktvr()
     *         aklr=aklr-1
     *      endd
     *   #else
     */
    if (gnArnd=2)
      while (akldr>0)
        ??chr(27)+'E'+chr(27)+'&l1h25a0O'+chr(27)+'&l3C'+chr(27)+'(3R'+chr(27)+'(s0p29.00h0s1b4102T'+chr(27)// Книжная А4
#ifdef __CLIP__
          arfrm()           // to
#else
          if (bom(gdTd)<ctod('01.01.2015'))
            arfrm()         // to
          else
            ardu()          // to
          endif

#endif
        akldr=akldr-1
      enddo

      while (aklr>0)
        ??chr(27)+'E'+chr(27)+'&l4h25a0O'+chr(27)+'&l5C'+chr(27)+'&k2S'+chr(27)+'(3R'+chr(27)+'(s0p20.00h0s1b4102T'+chr(27)
        arsch()
        araktvr()
        aklr=aklr-1
      enddo

    else
      while (aklr>0)
        ??chr(27)+'E'+chr(27)+'&l1h25a0O'+chr(27)+'&l3C'+chr(27)+'(3R'+chr(27)+'(s0p29.00h0s1b4102T'+chr(27)// Книжная А4
        /*            arfrmn() // from */
        arfrmn(1)         // from
        aklr=aklr-1
      enddo

    endif

    /*   #endif */
    set prin off
    set prin to
    set cons on
  endif

  return (.t.)

/************** */
function APrEmdu()
  /************** */
  dtpremr=gdTd
  dgpremr=0
  dtdgpremr=ctod('')
  claprem=setcolor('gr+/b,n/bg')
  akldr=2
  aklar=3
  aklor=2
  waprem=wopen(7, 20, 17, 70)
  store space(15) to tvedr, mehr//,firmr
  mlptr=0
  wbox(1)
  while (.t.)
    @ 0, 1 say 'Фирма     ' get firmr
    @ 1, 1 say 'Дата      ' get dtpremr
    @ 2, 1 say 'Договор N ' get dgpremr pict '9999999999'
    @ 2, col()+1 say 'От  ' get dtdgpremr
    @ 3, 1 say 'Товаровед ' get tvedr
    @ 4, 1 say 'Механик   ' get mehr
    @ 5, 1 say 'К-во экз Д' get akldr pict '9'
    @ 6, 1 say 'К-во экз A' get aklar pict '9'
    @ 7, 1 say 'К-во экз O' get aklor pict '9'
    @ 8, 1 prom 'LPT1'
    @ 8, col()+1 prom 'LPT2'
    @ 8, col()+1 prom 'LPT3'
    @ 8, col()+1 prom 'Файл'
    read
    if (lastkey()=K_ESC)
      exit
    endif

    menu to mlptr
    if (lastkey()=K_ESC)
      exit
    endif

    exit
  enddo

  wclose(waprem)
  setcolor(claprem)
  if (mlptr#0)
    set cons off
    do case
    case (mlptr=1)
      set prin to lpt1
    case (mlptr=2)
      set prin to lpt2
    case (mlptr=3)
      set prin to lpt3
    case (mlptr=4)
      set prin to apremdu.txt
      mlptr=1
    endcase

    set prin on
    // *   ??chr(27)+'E'+chr(27)+'&l1h25a0O'+chr(27)+'&l3C'+chr(27)+'(3R'+chr(27)+'(s0p29.00h0s1b4102T'+chr(27)  // Книжная А4
    if (gnArnd=2)
      while (akldr>0)
        ardu()              // to
        akldr=akldr-1
      enddo

      while (aklar>0)
        araktto()
        aklar=aklar-1
      enddo

      while (aklor>0)
        ??chr(27)+'E'+chr(27)+'&l4h25a0O'+chr(27)+'&l5C'+chr(27)+'&k2S'+chr(27)+'(3R'+chr(27)+'(s0p20.00h0s1b4102T'+chr(27)
        arsch()
        araktvr()
        aklor=aklor-1
      enddo

    else
      while (aklar>0)
        ??chr(27)+'E'+chr(27)+'&l1h25a0O'+chr(27)+'&l3C'+chr(27)+'(3R'+chr(27)+'(s0p29.00h0s1b4102T'+chr(27)// Книжная А4
        /*         araktfr() */
        arfrmn(1)         // from
        aklar=aklar-1
      enddo

    endif

    set prin off
    set prin to
    set cons on
  endif

  return (.t.)

/************************ */
function chkopl(p1, p2, p3, p4)
  /************************
   * p1 - kkl
   * p2 - bs
   * p3 - sk
   * p4 - ttn
   * aaa 0 - нет; 1-361001;2-361002;3-оба
   */
  local aaa, bbb, ccc
  aaa=0

  kkl_r=p1
  bs_r=p2
  sk_r=p3
  ttn_r=p4

  if (bs_r#0)
    aaa=0
  else
    store 0 to bbb, ccc
    do case
    case (bbb=0.and.ccc=0)
      aaa=0
    case (bbb#0.and.ccc#0)
      aaa=3
    case (bbb#0.and.ccc=0)
      aaa=1
    case (bbb=0.and.ccc#0)
      aaa=2
    endcase

  endif

  return (aaa)

/************* */
function araktpp()
  /************* */
  ?'                                        АКТ'
  ?'       прийому-передачи торгiвельного обладнання'+' '+alltrim(firmr)
  ?'м.Суми                                                '+dtoc(dtpremr)
  ?'На пiдставi договору N '+str(dgpremr, 10)+' вiд '+dtoc(dtdgpremr)
  ?'Мiж '+gcName_c+' та фiрмою '+getfield('t1', 'kplr', 'kln', 'nkl')
  ?''
  ?'Комiсiя у складi представникiв ОРЕНДОДАВЦЯ '+gcName_c+' :'
  ?'товарознавця '+alltrim(tvedr)+' та механiка '+alltrim(mehr)
  ?'здаэ в користування ОРЕНДАТОРУ '+alltrim(firmr)
  ?'1 шт '+alltrim(getfield('t1', 'mntovr', 'ctov', 'nat'))
  ?''
  ?'Адмiнiстрацiя фiрми ОРЕНДАТОРА '+getfield('t1', 'kplr', 'kln', 'nkl')
  ?'приймаэ в користування 1 шт. торгiвельного обладнання '
  ?'розташованого за адресою '+getfield('t1', 'kgpr', 'kln', 'adr')
  ?''
  ?'Обладнання передано та прийнято в повному комплектi та готове до експлуатацii'
  ?''
  ?''
  ?''
  ?''
  ?''
  ?'Представник                                  Представник'
  ?''
  ?gcName_c+'                             '+getfield('t1', 'kplr', 'kln', 'nkl')
  ?''
  ?'----------------/                /           -------------------/             /'
  ?''
  ?''
  ?'М.П.                                              М.П.'
  eject
  return (.t.)

/*************** */
function arsch()
  /*************** */
  ?gcName_c
  ?gcAdr_c
  ?gcTlf_c
  ?''
  ?'Розрахунковий рахунок '+gcScht_c+' в '+gcNbank_c
  ?'Код банку             '+Right(gnBank_c, 6)
  ?'Код                   '+str(gnKln_c, 10)
  ?'Номер платника ПДВ    '+str(gnKnal_c, 12)
  ?'Номер свiдотства      '+gcSvid_c
  ?replicate('-', 80)
  ?'                                     РАХУНОК N'+str(ttnr, 6)
  /*?'                                     вiд '+iif(bom(dvpr)=bom(date()),dtoc(dvpr),'') */
  ?'                                     вiд '+iif(.f., dtoc(dvpr), '')
  ?'Платник '+alltrim(firmr)+' '+str(rs1->kpl, 7)
  arrs2()
  ?''
  ?''
  ?''
  ?''
  ?'                                   ---------------                         М.П.'
  ?''
  eject
  return (.t.)

/*************** */
function araktvr()
  /*************** */
  ?'             ЗАМОВНИК                                           ВИКОНАВЕЦЬ'
  ?'       '+subs(nkplr, 1, 30)+space(25)+gcName_c
  ?''
  ?'код'+' '+str(getfield('t1', 'kplr', 'kln', 'kkl1'), 10)+space(48)+str(gnKln_c, 10)
  ?'р/р'+' '+getfield('t1', 'kplr', 'kln', 'ns1')+space(38)+gcScht_c
  ?'МФО'+' '+getfield('t1', 'kplr', 'kln', 'kb1')+space(43)+Right(gnBank_c, 6)
  ?''
  ?''
  ?'                      АКТ ПРО ВИКОНАННЯ РОБIТ N'+str(ttnr, 6)
  ?''
  ?'м.Суми                                                                '+dtoc(dvpr)
  ?''
  ?'Ми, що нижче пiдписалися'
  ?'представник ВИКОНАВЦЯ - '+gcName_c
  ?'i представник ЗАМОВНИКА - '+nkplr
  ?'склали даний акт про те, що перший виконав, а другий прийняв нижчеперерахованi работи:'
  arrs2()
  ?''
  ?''
  ?''
  ?'     Представник ЗАМОВНИКА                          Представник ВИКОНАВЦЯ'
  ?''
  ?''
  ?'     ---------------------                          ----------------------'
  ?''
  ?'                                                                      М.П.'
  eject
  return (.t.)

/************ */
function arrs2()
  /************ */
  ?'┌───┬───────────────────────────────────────────┬────┬────┬──────────┬───────────┐'
  ?'│NN │            Найменування                   │ Од │Кiль│   Цiна   │   Сума    │'
  ?'├───┼───────────────────────────────────────────┼────┼────┼──────────┼───────────┤'
  nn_r=1
  store 0 to svp_r, snds_r
  sele rs2
  if (netseek('t1', 'ttnr'))
    while (ttn=ttnr)
      nat_r='Оренда '+alltrim(getfield('t1', 'rs2->mntov', 'ctov', 'nat'))
      if (len(nat_r)>43)
        nat1_r=subs(nat_r, 1, 43)
        nat2_r=subs(nat_r, 44)
      else
        nat1_r=nat_r
        nat2_r=''
      endif

      ?' '+str(nn_r, 3)+' '+nat1_r+' '+' шт '+' '+str(rs2->kvp, 4)+' '+str(0.833, 10, 3)+'  '+str(roun(0.833*rs2->kvp, 2), 10, 2)
      if (!empty(nat2_r))
        ?' '+space(3)+' '+nat2_r
      endif

      svp_r=svp_r+roun(0.833*rs2->kvp, 2)
      /*      svp_r=svp_r+roun(8.330*rs2->kvp,2) */
      nds_r=roun(svp_r*1.2, 2)-roun(svp_r, 2)
      snds_r=snds_r+nds_r
      nn_r=nn_r+1
      sele rs2
      skip
    enddo

  endif

  ?'                                                      Вартiсть без ПДВ:'+str(svp_r, 10, 2)
  ?'                                                                   ПДВ:'+str(roun(svp_r*1.2-svp_r, 2), 10, 2)
  ?'                                                                        ----------'
  ?'                                                                 Разом:'+str(roun(svp_r*1.2, 2), 10, 2)
  ?''
  aaa=svp_r+snds_r
  ?'Усього до сплати: '+numstr(roun(svp_r*1.2, 2))
  return (.t.)

/*************************** */
function zvttno()
  /* Обновление ттн из заявки
   ***************************
   */
  if (rs1->prz=0.and.empty(rs1->dop))
    sele rs2kpk
    if (netseek('t1', 'ttnr,skpkr'))
      while (ttn=ttnr.and.skpk=skpkr)
        mntovr=mntov
        kvpr=kvp
        kvp_rr=0
        sele rs2
        if (netseek('t1', 'ttnr'))
          while (ttn=ttnr)
            if (mntov=mntovr)
              kvp_rr=kvp_rr+kvp
            endif

            sele rs2
            skip
          enddo

        endif

        if (kvpr>kvp_rr)
          kolr=kvpr-kvp_rr
          sele tov
          set orde to tag t5
          if (netseek('t5', 'sklr,mntovr'))
            while (skl=sklr.and.mntov=mntovr)
              sele tov
              skip
            enddo

          endif

        endif

        sele rs2kpk
        skip
      enddo

    endif

  endif

  return (.t.)

/***************** */
function rotvpere(p1)
  /***************** */
  if (!empty(p1))
    prscr=1
  else
    prscr=0
  endif

  if (przr=1)
    return (.t.)
  endif

  sele rs2
  set orde to tag t1
  if (netseek('t1', 'ttnr'))
    while (ttn=ttnr)
      rc_rr=recn()
      ktlr=ktl
      mntovr=mntov
      otvr=getfield('t1', 'gnSkl,ktlr', 'tov', 'otv')
      amnpr=amnp
      otvrsr=otv
      if (otvr=1)
        arec:={}
        getrec()
        kvpr=kvp
        sele tov
        set orde to tag t5  // skl,mntov,...
        if (netseek('t5', 'gnSkl,mntovr'))
          ktl_r=0
          while (mntov=mntovr)
            if (otv=1)
              skip
              loop
            endif

            if (osv>=kvpr)
              osv_r=osv
              if (prscr=1)
                ?str(mntovr, 7)+' '+str(ktlr, 9)+' TOV->OTV '+str(otvr, 1)+' OSV '+str(osvr, 5)+' KVP '+str(kvpr, 5)+' AMNP '+str(amnpr, 6)+' RS->OTV '+str(otvrsr, 1)+' DEL'
              endif

              netrepl('osv', 'osv-kvpr')
              ktl_r=ktl
              exit
            endif

            sele tov
            skip
          enddo

          sele rs2
          if (ktl_r#0)
            if (!netseek('t1', 'ttnr,ktl_r'))
              netadd()
              putrec()
              netrepl('ktl,ktlp,otv', 'ktl_r,ktl_r')
              aaa=' INS'
            else
              netrepl('kvp', 'kvp+kvpr')
              aaa=' ADD'
            endif

            if (prscr=1)
              ?str(mntovr, 7)+' '+str(ktl_r, 9)+' TOV->OTV '+str(0, 1)+' OSV '+str(osv_r, 5)+' KVP '+str(kvpr, 5)+' AMNP '+str(amnp, 6)+' RS->OTV '+str(otv, 1)+aaa
            endif

            go rc_rr
            netdel()
          endif

        endif

      endif

      sele rs2
      skip
    enddo

  endif

  return (.t.)

/***************** */
function rpospere(p1)
  /***************** */
  if (!empty(p1))
    prscr=1
  else
    prscr=0
  endif

  if (przr=1)
    return (.t.)
  endif

  sele rs2
  set orde to tag t1
  if (netseek('t1', 'ttnr'))
    while (ttn=ttnr)
      if (int(mntov/10000)#507)
        skip
        loop
      endif

      rc_rr=recn()
      ktlr=ktl
      mntovr=mntov
      kvpr=kvp
      otvr=getfield('t1', 'gnSkl,ktlr', 'tov', 'otv')
      osvr=getfield('t1', 'gnSkl,ktlr', 'tov', 'osv')
      amnpr=amnp
      otvrsr=otv
      if (otvr=0.and.osvr<kvpr)
        arec:={}
        getrec()
        kvpr=kvp
        sele tov
        set orde to tag t5  // skl,mntov,...
        if (netseek('t5', 'gnSkl,mntovr'))
          ktl_r=0
          while (mntov=mntovr)
            if (otv=1)
              skip
              loop
            endif

            if (osv>=kvpr)
              osv_r=osv
              if (prscr=1)
                ?str(mntovr, 7)+' '+str(ktlr, 9)+' TOV->OTV '+str(otvr, 1)+' OSV '+str(osvr, 5)+' KVP '+str(kvpr, 5)+' AMNP '+str(amnpr, 6)+' RS->OTV '+str(otvrsr, 1)+' DEL'
              endif

              netrepl('osv', 'osv-kvpr')
              ktl_r=ktl
              exit
            endif

            sele tov
            skip
          enddo

          sele rs2
          if (ktl_r#0)
            if (!netseek('t1', 'ttnr,ktl_r'))
              netadd()
              putrec()
              netrepl('ktl,ktlp', 'ktl_r,ktl_r')
              aaa=' INS'
            else
              netrepl('kvp', 'kvp+kvpr')
              aaa=' ADD'
            endif

            if (prscr=1)
              ?str(mntovr, 7)+' '+str(ktl_r, 9)+' TOV->OTV '+str(0, 1)+' OSV '+str(osv_r, 5)+' KVP '+str(kvpr, 5)+' AMNP '+str(amnp, 6)+' RS->OTV '+str(otv, 1)+aaa
            endif

            go rc_rr
            ktlr=ktl
            sele tov
            if (netseek('t1', 'gnSkl,ktlr'))
              netrepl('osv', 'osv+kvpr')
            endif

            sele rs2
            netdel()
          endif

        endif

      endif

      sele rs2
      skip
    enddo

  endif

  return (.t.)

/***************** */
function crotvosv()
  /***************** */
  clea
  /*set cons off */
  set prin to crosv.txt
  set prin on
  netuse('rs1')
  netuse('rs2')
  netuse('tov')
  netuse('pr1')
  crtt('ttrs1', 'f:prz c:n(1) f:ttn c:n(6) f:prz0 c:n(1) f:prz1 c:n(1)')
  sele 0
  use ttrs1 excl
  inde on str(prz, 1) tag t1
  CLOSE
  sele 0
  use ttrs1 shared
  set orde to tag t1
  sele rs2
  set orde to tag t6        // ktl
  if (netseek('t6', '507000000',, '3'))
    skip -1
    if (bof())
    else
      if (int(mntov/10000)=507)
        wmess('Oш seek'+' '+str(ktl, 9))
      endif

    endif

    skip
    while (int(mntov/10000)=507)
      ttnr=ttn
      ktlr=ktl
      /*if ktlr=507025787.and.ttnr=838259
       *wait
       *endif
       */
      amnpr=amnp
      sele tov
      probr=0
      if (netseek('t1', 'gnSkl,ktlr'))
        otvr=otv
        osvr=osv
        if (otvr=0.and.osvr<0)
          probr=1
        endif

        if (otvr=1)
          if (amnpr#0)
            otv_r=getfield('t1', 'amnpr,ktlr', 'pr1', 'otv')
            prz_r=getfield('t1', 'amnpr,ktlr', 'pr1', 'prz')
            if (otv_r=3.and.prz_r=1)
              probr=2
            endif

          endif

        endif

      endif

      sele rs2
      if (probr>0)
        przr=getfield('t1', 'ttnr', 'rs1', 'prz')
        if (.t.)          //przr=0
          sele ttrs1
          locate for ttn=ttnr
          if (!foun())
            netadd()
            netrepl('prz,ttn', 'przr,ttnr')
          endif

          if (probr=1)
            netrepl('prz0', '1')
          endif

          if (probr=2)
            netrepl('prz1', '1')
          endif

        endif

      endif

      sele rs2
      skip
    enddo

  endif

  ?'otv=1'
  sele ttrs1
  go top
  while (!eof())
    if (prz1=0)
      skip
      loop
    endif

    przr=0
    ttnr=ttn
    ?str(ttnr, 6)
    rotvpere(1)
    sele ttrs1
    skip
  enddo

  ?'otv=0'
  sele ttrs1
  go top
  while (!eof())
    if (prz0=0)
      skip
      loop
    endif

    ttnr=ttn
    przr=0
    ?str(ttnr, 6)
    rpospere(1)
    sele ttrs1
    skip
  enddo

  nuse()
  sele ttrs1
  CLOSE
  set prin off
  set prin to
  /*set cons on */
  return (.t.)

/**************************** */
function ttn177old()
  /* что было до объединения
   *****************************
   */
  if (ttn177r=0)
    wmess('Не объединялась', 2)
    return (.t.)
  endif

  pathr=gcPath_m177+gcDir_t+'t'+alltrim(str(ttn177r, 6))+'\'
  if (!netfile('rs2', 1))
    wmess('Нет данных', 2)
    return (.t.)
  endif

  netuse('rs2', 'rs2177',, 1)
  sele rs2177
  if (netseek('t1', 'ttnr'))
    while (.t.)
      foot('', '')
      rcrs2177r=slcf('rs2177', 8, 1, 11,, "e:ktl h:'Код' c:n(9) e:getfield('t1','rs2177->mntov','ctov','nat') h:'Наименование' c:c(45) e:getfield('t1','rs2177->mntov','ctov','nei') h:'Изм' c:c(3) e:kvp h:'Количество' c:n(12,3)",,,, 'ttn=ttnr',, 'n/g,n/w', 'В ТТН '+str(ttn177r, 6))
      if (lastkey()=K_ESC)
        exit
      endif

      go rcrs2177r
    enddo

  endif

  nuse('rs2177')
  return (.t.)

/**************************** */
function ttn169old(p1)
  /* что было до объединения
   *****************************
   */
  kop_r=p1
  do case
  case (kop_r=169)
    ttnucr=ttn169r
    pathr=gcPath_m169+gcDir_t+'t'+alltrim(str(ttn169r, 6))+'\'
  case (kop_r=129)
    ttnucr=ttn129r
    pathr=gcPath_m129+gcDir_t+'t'+alltrim(str(ttn129r, 6))+'\'
  case (kop_r=139)
    ttnucr=ttn139r
    pathr=gcPath_m139+gcDir_t+'t'+alltrim(str(ttn139r, 6))+'\'
  endcase

  if (ttnucr=0)
    wmess('Не объединялась', 2)
    return (.t.)
  endif

  if (!netfile('rs2', 1))
    wmess('Нет данных', 2)
    return (.t.)
  endif

  netuse('rs2', 'rs2uc',, 1)
  sele rs2uc
  if (netseek('t1', 'ttnr'))
    while (.t.)
      foot('', '')
      rcrs2ucr=slcf('rs2uc', 8, 1, 11,, "e:ktl h:'Код' c:n(9) e:getfield('t1','rs2uc->mntov','ctov','nat') h:'Наименование' c:c(45) e:getfield('t1','rs2uc->mntov','ctov','nei') h:'Изм' c:c(3) e:kvp h:'Количество' c:n(12,3)",,,, 'ttn=ttnr',, 'n/g,n/w', 'В ТТН '+str(ttnucr, 6))
      if (lastkey()=K_ESC)
        exit
      endif

      go rcrs2ucr
    enddo

  endif

  nuse('rs2uc')
  return (.t.)

/**************** */
function chk177()
  /**************** */
  pathr=gcPath_ew+'ttn177\'+gcDir_g+gcDir_d+gcDir_t+'t'+alltrim(str(ttnr, 6))+'\'
  if (netfile('rs2', 1))
    crtt('trs2177t', 'f:ktl c:n(9) f:kvp c:n(12,3) f:kf c:n(12,3)')
    sele 0
    use trs2177t
    netuse('rs2', 'rs2177',, 1)
    while (!eof())
      ktlr=ktl
      kvpr=kvp
      sele trs2177t
      locate for ktl=ktlr
      if (!foun())
        netadd()
        netrepl('ktl', 'ktlr')
      endif

      netrepl('kf', 'kf+kvpr')
      sele rs2177
      skip
    enddo

    nuse('rs2177')
    sele trs2177t
    go top
    pr177err=0
    while (!eof())
      ktlr=ktl
      kvpr=getfield('t1', 'ttnr,ktlr', 'rs2', 'kvp')
      sele trs2177t
      netrepl('kvp', 'kvpr')
      if (kvp#kf)
        pr177err=1
      endif

      skip
    enddo

    sele rs2
    if (netseek('t3', 'ttnr'))
      while (ttn=ttnr)
        ktlr=ktl
        kvpr=kvp
        sele trs2177t
        locate for ktl=ktlr
        if (!foun())
          netadd()
          netrepl('ktl,kvp', 'ktlr,kvpr')
          pr177err=1
        endif

        sele rs2
        skip
      enddo

    endif

    if (pr177err=1)
      sele trs2177t
      go top
      rc177r=recn()
      while (.t.)
        foot('ENTER,ESC', 'Коррекция,Отмена')
        rc177r=slcf('trs2177t',,,,, "e:ktl h:'Код' c:n(9) e:kvp h:'KVP' c:n(12,3) e:kf h:'KF' c:n(12,3)",,,,, 'kvp#kf')
        go rc177r
        if (lastkey()=K_ESC)
          exit
        endif

        if (lastkey()=K_ENTER)
          sele trs2177t
          go top
          while (!eof())
            ktlr=ktl
            if (kvp#kf)
              kfr=kf
              sele rs2
              if (netseek('t1', 'ttnr,ktlr'))
                netrepl('kvp', 'kfr')
                svpr=roun(kvp*zen, 2)
                netrepl('svp', 'svpr')
              endif

            endif

            sele trs2177t
            skip
          enddo

          exit
        endif

      enddo

    endif

    nuse('trs2177t')
  endif

  return (.t.)

/**************** */
function chk169()
  /**************** */
  pathr=gcPath_ew+'ttn169\'+gcDir_g+gcDir_d+gcDir_t+'t'+alltrim(str(ttnr, 6))+'\'
  if (netfile('rs2', 1))
    crtt('trs2169t', 'f:ktl c:n(9) f:kvp c:n(12,3) f:kf c:n(12,3)')
    sele 0
    use trs2169t
    netuse('rs2', 'rs2169',, 1)
    while (!eof())
      ktlr=ktl
      kvpr=kvp
      sele trs2169t
      locate for ktl=ktlr
      if (!foun())
        netadd()
        netrepl('ktl', 'ktlr')
      endif

      netrepl('kf', 'kf+kvpr')
      sele rs2169
      skip
    enddo

    nuse('rs2169')
    sele trs2169t
    go top
    pr169err=0
    while (!eof())
      ktlr=ktl
      kvpr=getfield('t1', 'ttnr,ktlr', 'rs2', 'kvp')
      sele trs2169t
      netrepl('kvp', 'kvpr')
      if (kvp#kf)
        pr169err=1
      endif

      skip
    enddo

    sele rs2
    if (netseek('t3', 'ttnr'))
      while (ttn=ttnr)
        ktlr=ktl
        kvpr=kvp
        sele trs2169t
        locate for ktl=ktlr
        if (!foun())
          netadd()
          netrepl('ktl,kvp', 'ktlr,kvpr')
          pr169err=1
        endif

        sele rs2
        skip
      enddo

    endif

    if (pr169err=1)
      sele trs2169t
      go top
      rc169r=recn()
      while (.t.)
        foot('ENTER,ESC', 'Коррекция,Отмена')
        rc169r=slcf('trs2169t',,,,, "e:ktl h:'Код' c:n(9) e:kvp h:'KVP' c:n(12,3) e:kf h:'KF' c:n(12,3)",,,,, 'kvp#kf')
        go rc169r
        if (lastkey()=K_ESC)
          exit
        endif

        if (lastkey()=K_ENTER)
          sele trs2169t
          go top
          while (!eof())
            ktlr=ktl
            if (kvp#kf)
              kfr=kf
              sele rs2
              if (netseek('t1', 'ttnr,ktlr'))
                netrepl('kvp', 'kfr')
                svpr=roun(kvp*zen, 2)
                netrepl('svp', 'svpr')
              endif

            endif

            sele trs2169t
            skip
          enddo

          exit
        endif

      enddo

    endif

    nuse('trs2169t')
  endif

  return (.t.)

/**************** */
function chkuc(p1)
  /**************** */
  do case
  case (p1=169)
    pathr=gcPath_ew+'ttn169\'+gcDir_g+gcDir_d+gcDir_t+'t'+alltrim(str(ttnr, 6))+'\'
  case (p1=177)
    pathr=gcPath_ew+'ttn177\'+gcDir_g+gcDir_d+gcDir_t+'t'+alltrim(str(ttnr, 6))+'\'
  case (p1=129)
    pathr=gcPath_ew+'ttn129\'+gcDir_g+gcDir_d+gcDir_t+'t'+alltrim(str(ttnr, 6))+'\'
  case (p1=139)
    pathr=gcPath_ew+'ttn139\'+gcDir_g+gcDir_d+gcDir_t+'t'+alltrim(str(ttnr, 6))+'\'
  case (p1=999)
    pathr=gcPath_ew+'ttnlist\'+gcDir_g+gcDir_d+gcDir_t+'t'+alltrim(str(ttnr, 6))+'\'
  endcase

  if (netfile('rs2', 1))
    crtt('trs2uct', 'f:ktl c:n(9) f:kvp c:n(12,3) f:kf c:n(12,3)')
    sele 0
    use trs2uct
    netuse('rs2', 'rs2uc',, 1)
    while (!eof())
      ttn_r=ttn
      ktlr=ktl
      kvpr=kvp
      sele rs2
      if (netseek('t1', 'ttn_r,ktlr'))
        arec:={}
        getrec()
        netdel()
        if (netseek('t1', 'ttnr,ktlr'))
          netrepl('kvp', 'kvp+kvpr',)
        else
          netadd()
          putrec()
          netrepl('ttn', 'ttnr')
        endif

      endif

      sele trs2uct
      locate for ktl=ktlr
      if (!foun())
        netadd()
        netrepl('ktl', 'ktlr')
      endif

      netrepl('kf', 'kf+kvpr')
      sele rs2uc
      skip
    enddo

    nuse('rs2uc')
    sele trs2uct
    go top
    prucerr=0
    while (!eof())
      ktlr=ktl
      kvpr=getfield('t1', 'ttnr,ktlr', 'rs2', 'kvp')
      sele trs2uct
      netrepl('kvp', 'kvpr')
      if (kvp#kf)
        prucerr=1
      endif

      skip
    enddo

    sele rs2
    if (netseek('t3', 'ttnr'))
      while (ttn=ttnr)
        ktlr=ktl
        kvpr=kvp
        sele trs2uct
        locate for ktl=ktlr
        if (!foun())
          netadd()
          netrepl('ktl,kvp', 'ktlr,kvpr')
          prucerr=1
        endif

        sele rs2
        skip
      enddo

    endif

    if (prucerr=1)
      sele trs2uct
      go top
      rcucr=recn()
      while (.t.)
        foot('ENTER,ESC', 'Коррекция,Отмена')
        rcucr=slcf('trs2uct',,,,, "e:ktl h:'Код' c:n(9) e:kvp h:'KVP' c:n(12,3) e:kf h:'KF' c:n(12,3)",,,,, 'kvp#kf')
        go rcucr
        if (lastkey()=K_ESC)
          exit
        endif

        if (lastkey()=K_ENTER.and.rs1->prz=0)
          sele trs2uct
          go top
          while (!eof())
            ktlr=ktl
            if (kvp#kf)
              kfr=kf
              sele rs2
              if (netseek('t1', 'ttnr,ktlr'))
                netrepl('kvp', 'kfr')
                svpr=roun(kvp*zen, 2)
                netrepl('svp', 'svpr')
              else
              endif

            endif

            sele trs2uct
            skip
          enddo

          exit
        endif

      enddo

    endif

    nuse('trs2uct')
  endif

  return (.t.)
