#include "common.ch"
#include "inkey.ch"
**************************************************************************
if pr1->vo=9.and.gnCtov=1
   sele pr2
   set orde to tag t1
   if netseek('t1','mnr')
      do while mn=mnr
         ktlr=ktl
         mntovr=mntov
         ktlpr=ktlp
         mntovpr=mntovp
         if ktlpr=0
            netrepl('ktlp','ktlr')
         endif
         if mntovpr=0
            netrepl('mntovp','mntovr')
         endif
         if izg=0
            izgr=pr1->kps
            netrepl('izg','izgr')
            sele tov
            if netseek('t1','sklr,ktlr')
               netrepl('izg','izgr')
            endif
            sele tovm
            if netseek('t1','sklr,mntovr')
               netrepl('izg','izgr')
            endif
            sele ctov
            if netseek('t1','mntovr')
               netrepl('izg','izgr')
            endif
         endif
         sele pr2
         skip
      enddo
   endif
endif

nDcl4Kf:= nDcl4KfTO:=0
sele pr2
set orde to tag t1
if netseek('t1','mnr')
  // просчет Литража и Веса
  sele ctov
  cOrdSF_ctov:=OrdSetFocus('t1')
  sele pr2
  set rela to Str(Mntov,7) into ctov
  rcPr2r:=RecNo()

  sum Kf*ctov->VesP, Kfto*ctov->VesP to nDcl4Kf, nDcl4KfTO ;
  for str(ctov->keip,3) $ '800;166;';
  while mn=mnr

  sele ctov
  OrdSetFocus(cOrdSF_ctov)
  sele pr2
  DBGoTo(rcPr2r)
  // ;"+str(nDcl4Kf,5)+"
  // ;"+str(nDcl4KfTO,5)+"
endif

sele tovsrt
set orde to tag t1
sele pr2
set rela to
set rela to str(sklr,7)+str(ktlp,9) into tovsrt
set orde to tag t1
netseek('t1','mnr')
inde on str(int(pr2->ktlp/1000000))+tovsrt->nat+str(pr2->ktlp,9)+str(pr2->ppt)+str(pr2->ktl) tag s1 to tnatp for mn=mnr
go top
if !bof()
   rcPr2r=recn()
else
   rcPr2r=1
endif
**************************************************************************
      ALT_F7r=0
      prF1r=0
      do while .t. // Товарная часть документа
         ccor_r=0
         SELE pr2
         go rcPr2r
         do while mn=mnr
            if deleted()
               skip -1
            else
               exit
            endif
         endd
         if mn#mnr
            netseek('t1','mnr')
         endif
         if prF1r=0
            do case
               case NdOtvr=0
                    if otpcr=0
                       if przr=0
                          if who#1
                             if gnRoz=1
                                foot('INS,DEL,F3,F4,F5,F6,F7,F9','Доб(С),Удал,Цены,Корр,Отд,Отп.цены,Серт,Деньги')
                             else
                                foot('F2,F3,F4,F5,F7,F8,F9,F10','Аттр,Цены,Корр,Отд,Серт,ШтрК,Деньги,Баз.цены')
                             endif
                          else
                             if gnRoz=1
                                foot('F4,F5,F6,F7,F9','Корр.,Отдел,Отп.цены,Серт,Деньги')
                             else
                                foot('F4,F5,F7,F9','Корр.,Отдел,Серт,Деньги')
                             endif
                          endif
                       else
                          if gnRoz=1
                             foot('F5,F6,F9','Отдел,Отп.цены,Деньги')
                          else
                             foot('F2,F5,F6,F9,F10','Аттр,Отдел,Отп.цены,Деньги,Баз.цены')
                          endif
                       endif
                    else
                       if przr=0
                          if who#1
                             if gnRoz=1
                                foot('INS,DEL,F3,F4,F5,F6,F7,F9','Доб(С),Удал,Цены,Корр,Отд,Зак.цены,Серт,Деньги')
                             else
                                foot('INS,DEL,F3,F4,F5,F7,F9','Доб(С),Удал,Цены,Корр,Отд,Серт,Деньги')
                             endif
                          else
                             if gnRoz=1
                                foot('F4,F5,F6,F7,F9','Корр.,Отдел,Зак.цены,Серт,Деньги')
                             else
                                foot('F4,F5,F7,F9','Корр.,Отдел,Серт,Деньги')
                             endif
                          endif
                      else
                          if gnRoz=1
                             foot('F5,F6,F9','Отдел,Зак.цены,Деньги')
                          else
                             foot('F5,F9','Отдел,Деньги')
                          endif
                       endif
                    endif
               case NdOtvr=3
                    if przr=0
                       foot('F3,F4,F5,F7,F8,F9','Отчет СОХ,Коррекция,Отдел,Серт,Пров,Деньги')
                    else
                       foot('F5,F9','Отдел,Деньги')
                    endif
               case NdOtvr=2
                 foot('F2,K1=,K2=','Создать отчет,'+str(nDcl4Kf,5)+','+str(nDcl4KfTO,5))

                  MnTovr=(pr2->(DBGoTo(rcPr2r), MnTov))
                  MnTovTr=getfield('t1','MnTovr','ctov','MnTovT')
                  mkeep_r=getfield('t1','MnTovTr','ctov','mkeep')
                  BlkMk_r=getfield('t1','mkeep_r','mkeep','BlkMk')
                  If BlkMk_r=1
                     foot('F2,F3,K1=,K2=','Создать отчет,Отч СОХ,'+str(nDcl4Kf,5)+','+str(nDcl4KfTO,5))
                  EndIf

               case NdOtvr=4
                    foot('INS,DEL,F3,F4,F5,F9','Доб(С),Удал,Отч СОХ,Корр,Отд,Деньги')
            endcase
         else
            foota('F2,F4,F5,F6,F7,F8,F10','ТТН пост,КоррПрив,Из файла,DOKK,Серт,Из ТТН,ДтМод')
         endif

         sele pr2
 //         set orde to tag t3
         set orde to tag s1
         if gnOt=0
            foror='.t.'
         else
            foror="getfield('t1','sklr,pr2->ktl','tov','ot')=gnOt"
         endif
         if gnVo=9
            pr2rowr=9
            pr2hr=10
         else
            pr2rowr=7
            pr2hr=12
         endif
         if kzgr=0
            prhdr=''
         else
            prhdr=str(kzgr,7)+' '+alltrim(nzgr)
         endif
         if prvzznr=0
            if ALT_F7r=0
               if NdOtvr=0.or.NdOtvr=3.or.NdOtvr=4 //.or.NdOtvr=2.and.gnVotv#2
                  if otpcr=0
                     rcPr2r=slcf('pr2',pr2rowr,1,pr2hr,,"e:ktl h:'Код' c:n(9) e:getfield('t1','sklr,pr2->ktl','tov','nat') h:'Наименование' c:c(27) e:getfield('t1','sklr,pr2->ktl','tov','nei') h:'Ед' c:c(4) e:kf h:'Количество' c:n(10,3) e:zen h:'Цена зак.' c:n(8,3) e:sf h:'Сумма' c:n(10,2) e:getfield('t1','sklr,pr2->ktl','tov','sendv') h:'П' c:n(1)",,,1,'mn=mnr',foror,,prhdr)
                  else
                     rcPr2r=slcf('pr2',pr2rowr,1,pr2hr,,"e:ktl h:'Код' c:n(9) e:getfield('t1','sklr,pr2->ktl','tov','nat') h:'Наименование' c:c(27) e:getfield('t1','sklr,pr2->ktl','tov','nei') h:'Ед' c:c(4) e:kf h:'Количество' c:n(10,3) e:bzen h:'Цена отп.' c:n(10,3) e:getfield('t1','sklr,pr2->ktl','tov',cboptr)*kf h:'Сумма' c:n(10,2)",,,1,'mn=mnr',foror)
                  endif
               else    // NdOtvr=2
                  if gnOtv=1
                     rcPr2r=slcf('pr2',pr2rowr,1,pr2hr,,"e:ktl h:'Код' c:n(9)";
                     +" e:getfield('t1','sklr,pr2->ktl','tov','nat') h:'Наименование' c:c(27)";
                     +" e:getfield('t1','sklr,pr2->ktl','tov','nei') h:'Ед' c:c(4)";
                     +" e:kf h:'Количество' c:n(10,3)";
                     +" e:kfto h:'К-во в отчет' c:n(10,3)";
                     +" e:kfc h:'Остальное' c:n(10,3)";
                     ,,,1,'mn=mnr',foror)
                  else
                     rcPr2r=slcf('pr2',pr2rowr,1,pr2hr,,"e:ktl h:'Код' c:n(9) e:getfield('t1','sklr,pr2->ktl','tov','nat') h:'Наименование' c:c(27) e:getfield('t1','sklr,pr2->ktl','tov','nei') h:'Ед' c:c(4) e:kf h:'Количество' c:n(10,3) e:getfield('t1','sklr,pr2->ktl','tov','upak') h:'В уп.' c:n(5) e:getfield('t1','sklr,pr2->ktl','tov','upakp') h:'В ящ.' c:n(5) e:kf/getfield('t1','sklr,pr2->ktl','tov','upakp') h:'К.ящик' c:n(8,2)",,,1,'mn=mnr',foror)
                  endif
               endif
            else
               rcPr2r=slcf('pr2',pr2rowr,1,pr2hr,,"e:ktl h:'Код' c:n(9) e:getfield('t1','sklr,pr2->ktl','tov','nat') h:'Наименование' c:c(40) e:getfield('t1','sklr,pr2->ktl','tov','nei') h:'Ед' c:c(4) e:izg h:'Изг' c:n(7) e:getfield('t1','pr2->izg','kln','nkle') h:'Наим' c:с(17)",,,1,'mn=mnr',foror)
            endif
         else
            if ALT_F7r=0
               if NdOtvr=0.or.NdOtvr=3 //.or.NdOtvr=2.and.gnVotv#2
                  if otpcr=0
                     rcPr2r=slcf('pr2',pr2rowr,1,pr2hr,,"e:ktl h:'Код' c:n(9) e:getfield('t1','sklr,pr2->ktl','tov','nat') h:'Наименование' c:c(27) e:kfttn h:'Кол.' c:n(4) e:zenttn h:'Ц Пост' c:n(7,3) e:zenpr h:'Ц Зак.' c:n(7,3) e:zen h:'Корр' c:n(7,3) e:sf h:'Сумма' c:n(8,2)",,,1,'mn=mnr',foror)
                   else
                     rcPr2r=slcf('pr2',pr2rowr,1,pr2hr,,"e:ktl h:'Код' c:n(9) e:getfield('t1','sklr,pr2->ktl','tov','nat') h:'Наименование' c:c(27) e:getfield('t1','sklr,pr2->ktl','tov','nei') h:'Ед' c:c(4) e:kfttn h:'Количество' c:n(10,3) e:bzen h:'Цена отп.' c:n(10,3) e:getfield('t1','sklr,pr2->ktl','tov',cboptr)*kf h:'Сумма' c:n(10,2)",,,1,'mn=mnr',foror)
                   endif
               else    // NdOtvr=2
                  rcPr2r=slcf('pr2',pr2rowr,1,pr2hr,,"e:ktl h:'Код' c:n(9) e:getfield('t1','sklr,pr2->ktl','tov','nat') h:'Наименование' c:c(27) e:getfield('t1','sklr,pr2->ktl','tov','nei') h:'Ед' c:c(4) e:kfttn h:'Количество' c:n(10,3) e:getfield('t1','sklr,pr2->ktl','tov','upak') h:'В уп.' c:n(5) e:getfield('t1','sklr,pr2->ktl','tov','upakp') h:'В ящ.' c:n(5) e:kf/getfield('t1','sklr,pr2->ktl','tov','upakp') h:'К.ящик' c:n(8,2)",,,1,'mn=mnr',foror)
               endif
            else
               rcPr2r=slcf('pr2',pr2rowr,1,pr2hr,,"e:ktl h:'Код' c:n(9) e:getfield('t1','sklr,pr2->ktl','tov','nat') h:'Наименование' c:c(40) e:getfield('t1','sklr,pr2->ktl','tov','nei') h:'Ед' c:c(4) e:izg h:'Изг' c:n(7) e:getfield('t1','pr2->izg','kln','nkle') h:'Наим' c:с(17)",,,1,'mn=mnr',foror)
            endif
         endif
         sele pr2
         go rcPr2r
         ktlr=ktl
         mntovr=mntov
         ktlpr=ktlp
         mntovpr=getfield('t1','sklr,ktlpr','tov','mntov')
         ksertr=getfield('t1','sklr,ktlr','tov','ksert')
         kukachr=getfield('t1','sklr,ktlr','tov','kukach')
         pnsotvr=getfield('t1','sklr,ktlr','tov','pnsotv')
         nsertr=getfield('t1','ksertr','sert','nsert')
         dtukachr=getfield('t1','ksertr,kukachr','ukach','dtukach')
         dizgr=getfield('t1','sklr,ktlr','tov','dizg')
         drlzr=getfield('t1','sklr,ktlr','tov','drlz')
         zenr=zen
         kfr=kf
         sfr=sf
         zenr=zen
         srr=sr
         seur=seu
         pptr=ppt
         izgr=izg
         natr=getfield('t1','sklr,ktlr','tov','nat')
         zenbbr=zenbb
         zenbtr=zenbt
         kfttnr=kfttn
         zenttnr=zenttn
         zenprr=zenpr
         do case
            case lastkey()=K_F1 // F1
                 if prF1r=0
                    prF1r=1
                 else
                    prF1r=0
                 endif
            case lastkey()=K_ALT_F2.and.(NdOtvr=0.or.NdOtvr=3) // Корр TTNPST
                 clprvz=setcolor('gr+/b,n/bg')
                 wPrVz=wopen(10,5,14+1,75)
                 wbox(1)
                 do while .t.
                   @ 0,1 say 'ТТН пост' get ttnpstr
                   @ 0,col()+1 say 'от' get dttnpstr
                   @ 1,1 say 'Опл' get dopr ;
                   when (dopr:=iif(empty(dopr),dvpr+getfield('t1','kpsr','klnDog','kdOpl'),dopr),.T.);
                     valid dopr >= dvpr
                   @ 1, col()+1 say 'Агент     : ' get ktar pict '999' valid (lKta:=kta(),WSelect(wPrVz),lKta)
                   @ 2,1 say 'НН  пост' get ndspstr
                   @ 2,col()+1 say 'Дата' get dndspstr
                   read
                   if lastkey()=K_ESC
                      exit
                   endif
                   @ 3,1 prom 'Верно'
                   @ 3,col()+1 prom 'Не Верно'
                   menu to vnr
                   if vnr=1
                      ktasr=getfield('t1','ktar','s_tag','ktas')
                      sele pr1
                      netrepl('ttnpst,dttnpst,dop,ndspst,dndspst',;
                              {ttnpstr,dttnpstr,dopr,ndspstr,dndspstr},1)
                      netrepl('ktas,kta',{ktasr,ktar},1)
                      exit
                   endif
                 enddo
                 wclose(wprvz)
                 setcolor(clprvz)
            case lastkey()=K_ALT_F5.and.NdOtvr=0.and.prdp() // Приход из файла
                 prfl()
            case lastkey()=K_ALT_F8.and.NdOtvr=0.and.gnVo=1.and.przr=0 // Приход из ТТН
                 if pr1ndsr=0 //.or.vor=1.and.kopr=108
                    PrTtn()
                 else
                    Pr1Nds()
                 endif
            case lastkey()=K_ALT_F9.and.NdOtvr=0.and.gnVo=1.and.przr=0 // Процент на изм цены
                 clprvz=setcolor('gr+/b,n/bg')
                 wprvz=wopen(10,5,14,75)
                 wbox(1)
                 do while .t.
                    @ 0,1 say 'Проц изм цены' get prizenr pict '999.99'
                    read
                    if lastkey()=K_ESC
                       exit
                    endif
                    @ 2,1 prom 'Верно'
                    @ 2,col()+1 prom 'Не Верно'
                    menu to vnr
                    if vnr=1
                       sele pr1
                       netrepl('prizen','prizenr',1)
                       exit
                    endif
                 endd
                 wclose(wprvz)
                 setcolor(clprvz)
                 sele pr2
                 set orde to tag t3
                 if netseek('t3','mnr')
                    do while mn=mnr
                       if int(mntov/10000)<2
                          skip
                          loop
                       endif
                       zenttnr=roun(zenttn,3)
                       mod_r=mod(zenttnr,1)*1000
                       if subs(str(mod_r,3),3,1)='0'
                          zenprr=zenttnr+roun(zenttnr*prizenr/100,2)
                       else
                          zenprr=zenttnr+roun(zenttnr*prizenr/100,3)
                       endif
                       kfttnr=roun(kfttn,3)
                       zenr=zenttnr-zenprr
                       sfr=roun(zenr*kfttnr,2)
                       netrepl('zen,zenpr,sf','zenr,zenprr,sfr')
                       sele pr2
                       skip
                    endd
                 endif
            case lastkey()=K_F2.and.prdp()
                 fullor=0
                 if gnVo=1
                    PrAtt() // свойства pr1 prootch.prg
                 else
                    if NdOtvr=2 // Создать отчет
                       if !(month(gdTd)=month(date()).and.year(gdTd)=year(date()))
                          ach:={'Нет','Да'}
                          achr=0
                          achr=alert('Это не текущий месяц.Продолжить?',ach)
                          if achr#2
                             loop
                          endif
                          PrOtch()
                       else
                          PrOtch()
                       endif
                    endif
                 endif
            case lastkey()=K_ALT_F2.and.prdp()
                 fullor=1
                 if gnVo=1
                    pratt() // свойства pr1 prootch.prg
                 else
                    if NdOtvr=2 //.and.gnAdm=1 // Создать отчет
                       if !(month(gdTd)=month(date()).and.year(gdTd)=year(date()))
                          ach:={'Нет','Да'}
                          achr=0
                          achr=alert('Это не текущий месяц.Продолжить?',ach)
                          if achr#2
                             loop
                          endif
                          PrOtch()
                       else
                          PrOtch()
                       endif
                    endif
                 endif
            case lastkey()=K_F3.and.(NdOtvr=3.or.NdOtvr=4.or.NdOtvr=2);
              .and.prdp() // Отчет СОХ (сформировать sox.dbf)
              BlkMk_r:=0 //можно делать все.
              If NdOtvr=2

                MnTovr=(pr2->(DBGoTo(rcPr2r), MnTov))
                MnTovTr=getfield('t1','MnTovr','ctov','MnTov')
                mkeep_r=getfield('t1','MnTovTr','ctov','mkeep')
                BlkMk_r=getfield('t1','mkeep_r','mkeep','BlkMk')
                If .not. BlkMk_r=1
                  wmess('МД '+str(mkeep_r,3)+'НЕ блокирован!',2)
                  loop // назад
                EndIf
              EndIf
              soxs(BlkMk_r)
            case lastkey()=K_F8.and.(NdOtvr=3.or.NdOtvr=4).and.prdp() // Проверка отчета
 //                 chkoto() // protv.prg
            case lastkey()=K_F3.and.who#1.and.gnCtov=1  // Цены
                 tov_r='tov'
                 cor_r=1
 //                 netuse('tovo')
                 cen()
            case lastkey()=K_INS.and.(NdOtvr=0.or.NdOtvr=4).and.przr=0.and.sksr=0.and.skspr=0.and.prdp() // Отбор из tov,ctov
                 if prvzznr=1
                    loop
                 endif
                 prinstr=0 // Признак новой записи в TOV
                 if gnCtov=1
                    if gnVo=9.or.gnVo=6.and.((gnEnt=14.or.gnEnt=15.or.gnEnt=17).and.(kopr=168.or.kopr=185).or.gnEnt=16.and.kopr=120).or.gnVo=10.and.gnArnd=2
                       if gnEntrm=0
                          if gnVo=9.and.NdOtvr=4
                             ptovslc()
                          else
                             ptovslcc()
                          endif
                       endif
                    else
                       ptovslc()
                    endif
                 else
                    ptovslc()
                 endif
                 pere(1)
                 chkvzt()
            case lastkey()=K_F8.and.NdOtvr=0.and.przr=0.and.sksr=0.and.skspr=0.and.prdp() // Добавить штрих код
                 @ 24,0 clea
                 barr=1
                 do while barr#0
                    barr=0
                    setcolor('g/n,n/g')
                    @ 24,1 say 'Введите штрих-код ' get barr pict '9999999999999'
                    read
                    if barr#0
                       sele ctov
                       if netseek('t4','barr')
                          mntovr=mntov
                          optr=opt
                          tovins(0, 'tov', mntovr, 1)
                          sele pr2
                          if !netseek('t3','mnr,ktlr,0,ktlr')
                             netadd()
                             netrepl('mn,ktlp,ppt,ktl,mntovp,mntov','mnr,ktlr,0,ktlr,mntovr,mntovr')
                          endif
                          rcPr2r=recn()
                          pr2kvp(1)
                          pere(1)
                          chkvzt()
                          exit
                       else
                          wmess('Нет продукции с таким штрих-кодом',2)
                       endif
                    endif
                 endd
            case lastkey()=K_DEL.and.przr=0.and.who#1.and.(NdOtvr=0.or.NdOtvr=4).and.sksr=0.and.skspr=0.and.prdp()   // Удалить
                 pr2kvp(2)
                 pere(1)
                 chkvzt()
           // case lastkey()=K_F4.and.przr=0.and.(NdOtvr=0.or.NdOtvr=3.or.NdOtvr=4).and.ktlr=ktlpr.and.sksr=0.and.skspr=0.and.prdp()  // Коррекция
            case lastkey()=K_F4.and.vor=9.and.ALT_F7r=1.and.gnEntRm=0  // Коррекция изготовителя
                 clprvz=setcolor('gr+/b,n/bg')
                 wprvz=wopen(10,15,14,70)
                 wbox(1)
                 do while .t.
                    @ 0,1 say 'Изг в Прайсе '+' '+str(getfield('t1','pr2->mntov','ctov','izg'),7)
                    @ 1,1 say 'Изг в Приходе' get izgr pict '9999999'
                    read
                    if lastkey()=K_ESC
                       exit
                    endif
                    @ 2,1 prom 'Верно'
                    @ 2,col()+1 prom 'Не Верно'
                    menu to vnr
                    if vnr=1
                       sele pr2
                       netrepl('izg','izgr')
                       exit
                    endif
                 endd
                 wclose(wprvz)
                 setcolor(clprvz)
            case lastkey()=K_F4;
              .and.przr=0.and.(NdOtvr=0.or.NdOtvr=3.or.NdOtvr=4);
              .and.pptr=0.and.sksr=0.and.skspr=0.and.prdp()  // Коррекция
                 prinstr=0
                 pr2kvp(1)
                 pere(1)
                 chkvzt()
                 sele pr2
                 go rcPr2r
            case lastkey()=K_ALT_F3 // Даты
                 pdsp()
            case lastkey()=K_ALT_F4.and.przr=0.and.int(ktlr/1000000)<2.and.who#0.and.prdp() // Коррекция привязки
                 clprvz=setcolor('gr+/b,n/bg')
                 wprvz=wopen(10,15,14,70)
                 wbox(1)
                 do while .t.
                    @ 0,1 say 'Товар   '+' '+str(ktlr,9)
                    @ 1,1 say 'Родитель' get ktlpr pict '999999999'
                    read
                    if lastkey()=K_ESC
                       exit
                    endif
                    @ 2,1 prom 'Верно'
                    @ 2,col()+1 prom 'Не Верно'
                    menu to vnr
                    if vnr=1
                       if ktlpr=0
                          ktlpr=ktlr
                          mntovpr=mntovr
                       endif
                       sele pr2
                       if ktlpr#ktlr
                          if !netseek('t1','mnr,ktlpr')
                             go rcPr2r
                             wmess('Нет родителя в документе',1)
                             exit
                          else
                             mntovpr=mntovp
                          endif
                       else
                          mntovpr=mntovr
                       endif
                       go rcPr2r
                       if ktlr=ktlpr
                          pptr=0
                       else
                          pptr=1
                       endif
                       if pptr=1
                          sele tov
                          if netseek('t1','sklr,ktlpr')
                             if int(ktlr/1000000)=int(k1t/1000000)
                                if k1t#ktlr
                                   netrepl('k1t,m1t','ktlr,mntovr')
                                   sele tovm
                                   if netseek('t1','sklr,mntovpr')
                                      netrepl('m1t','mntovr')
                                   endif
                                   sele ctov
                                   if netseek('t1','mntovpr')
                                      netrepl('m1t','mntovr')
                                   endif
                                endif
                             endif
                          endif
                       endif
                       sele pr2
                       netrepl('mntovp,ktlp,ppt','mntovpr,ktlpr,pptr')
                       exit
                    endif
                 endd
                 wclose(wprvz)
                 setcolor(clprvz)
            case lastkey()=K_F5.and.(NdOtvr=0.or.NdOtvr=3.or.NdOtvr=4)
                 sele cskle
                 if netseek('t1','gnSk')
                    gnOt=slcf('cskle',,,,,"e:ot h:'От' c:n(2) e:nai h:'Наименование' c:c(20)",'ot',0,,'sk=gnSk')
                    if netseek('t1','gnSk,gnOt')
                       gcNot=nai
                       @ 1,60 say gcNot color 'gr+/n'
                    endif
                 endif
                 sele pr2
            case lastkey()=K_F6.and.gnRoz=1.and.(NdOtvr=0.or.NdOtvr=3.or.NdOtvr=4) // Отпускные/Закупочные цены
                 if otpcr=0
                    otpcr=1
                 else
                    otpcr=0
                 endif
            case lastkey()=K_F7 //.and.przr=0 // Сертификаты
              nndsr:=pr1->nnds
                 clsertr=setcolor('gr+/b,n/bg')
                 wsertr=wopen(10,20,18,60)
                 wbox(1)
                 do while .t.
                    @ 0,1 say 'Сертификат  ' get ksertr pict '999999' valid prsert()
                    @ 0,21 say nsertr
                    @ 1,1 say 'Кач.удостов.' get kukachr pict '999999' valid prkach()
                    @ 1,21 say dtukachr
                    @ 2,1 say 'Дата изгот. ' get dizgr
                    @ 3,1 say 'Дата реализ.' get drlzr
                    @ 4,1 say 'Пр.не соотв.' get pnsotvr pict '9'

                    if bom(gdTd)>=ctod('01.03.2011');
                      .and.(gnAdm=1.or.gnKto=331.or.gnKto=847.or.gnKto=882)
                       @ 5,1 say 'N НН         ' ;
                       get nndsr pict '9999999999' ;
                       when przr=0 ;
                       valid chknn()
                    endif

                    @ 6,24 prom 'Верно'
                    @ 6,col()+1 prom 'Не Верно'
                    read
                    if lastkey()=K_ESC
                       exit
                    endif
                    menu to vn_r
                    if lastkey()=K_ESC
                       exit
                    endif
                    if vn_r=1
                       sele pr1
                       netrepl('nnds',{nndsr},1)
                       sele tov
                       if netseek('t1','sklr,ktlr')
                          netrepl('ksert,kukach,dizg,drlz,pnsotv','ksertr,kukachr,dizgr,drlzr,pnsotvr')
                          if gnCtov=1
                             sele tovm
                             if netseek('t1','sklr,mntovr')
                                netrepl('ksert,kukach,dizg,drlz','ksertr,kukachr,dizgr,drlzr')
                             endif
                             sele ctov
                             if netseek('t1','mntovr')
                                netrepl('ksert,kukach,dizg,drlz','ksertr,kukachr,dizgr,drlzr')
                             endif
                          endif
                       endif
                       exit
                    endif
                 enddo
                 wclose(wsertr)
                 setcolor(clsertr)
            case lastkey()=K_ALT_F10   // Дата мод
                 sele pr1
                 netrepl('dtmod,tmmod','date(),time()',1)
            case lastkey()=K_ALT_F7 //.and.przr=0 // Сертификаты Вид
                 if ALT_F7r=0
                    ALT_F7r=1
                 else
                    ALT_F7r=0
                 endif
            case lastkey()=K_ALT_F6.and.przr=1 // DOKK
                 sele pr2
                 prxmlr=0
                 if pr1->kop=108.or.pr1->kop=110
                    if netseek('t1','mnr')
                       do while mn=mnr
                          mntovr=mntov
                          uktr=getfield('t1','mntovr','ctov','ukt')
                          if !empty(uktr)
                             prxmlr=1
                             exit
                          endif
                          sele pr2
                          skip
                       endd
                    endif
                 endif
                 prprov(gnSk,ndr,mnr)
            case lastkey()=K_F9 // Деньги
                 exit
            case lastkey()=K_F10 .and. NdOtvr=0 .and. otpcr=0 .and. !(gnRoz=1)
              PrToRs()
            case lastkey()=K_F10 // Заявка
                 mn_rrr=mnr
                 if netfile('pr1kpk')
                    netuse('pr1kpk')
                    netuse('pr2kpk')
                    sele pr1kpk
                    if netseek('t1','mnr')
                       skpkr=skpk
                       sele pr2kpk
                       if netseek('t1','mnr,skpkr')
                          rcpr2kpkr=recn()
                          do while .t.
                             foot('','')
                             go rcpr2kpkr
                             rcpr2kpkr=slcf('pr2kpk',8,1,11,,"e:mntov h:'Код' c:n(7) e:getfield('t1','pr2kpk->mntov','ctov','nat') h:'Наименование' c:c(45) e:getfield('t1','pr2kpk->mntov','ctov','nei') h:'Изм' c:c(3) e:kf h:'Кол заяв' c:n(9,3) e:kfo h:'Кол пров' c:n(9,3) ",,,,'skpk=skpkr.and.mn=mnr',,'n/g,n/w','Заявка')
                             if lastkey()=K_ESC
                                exit
                             endif
                          endd
                       endif
                    endif
                    nuse('pr1kpk')
                    nuse('pr2kpk')
                 endif
                 mnr=mn_rrr
            case lastkey()=K_ENTER.and.prdp() // Перекодировка
                 // prpcod()
            case lastkey()=K_ESC // Выход
                 esc_r=1
                 exit

          endcase
          sele pr2
       enddo
sele pr2
set rela to


/*****************************************************************
 
 FUNCTION:
 АВТОР..ДАТА..........С. Литовка  06-20-20 * 01:41:06pm
 НАЗНАЧЕНИЕ.........
 ПАРАМЕТРЫ..........
 ВОЗВР. ЗНАЧЕНИЕ....
 ПРИМЕЧАНИЯ.........
 */
STATIC FUNCTION PrToRs()
  LOCAL l_pathr := pathr
  LOCAL l_gnD0k1 := gnD0k1
  LOCAL l_gnScout := gnScout
  LOCAL l_sklr := sklr
  LOCAL nSele := SELECT()

  gnScout :=1
  gnD0k1 := 0

  sele cskl
  netseek('t1', '254')
  pathr=gcPath_d+alltrim(path)


  lcrtt('lrs1','rs1')
  lindx('lrs1','rs1')

  lcrtt('lrs2','rs2')
  lindx('lrs2','rs2')

  lcrtt('lrs2m','rs2')
  lindx('lrs2m','rs2')


  lcrtt('lrs3','rs3')
  lindx('lrs3','rs3')

  luse('lrs1', 'rs1t')
  luse('lrs2', 'rs2t')
  luse('lrs2m', 'rs2mt')
  luse('lrs3', 'rs3t')

  netUse('tov', 'tovt',, 1)
  netUse('tovm', 'tovmt',, 1)
  netuse('sgrp', 'sgrpt',, 1)
  netuse('soper', 'sopert',, 1)

  pathr=  l_pathr

  ttnr:=-10000

  sele pr1
  if (netseek('t2', 'mnr'))
    reclock()
    mnr=mn
    dvpr=date()
    ddcr=date()
    tdcr=time()
    dprr=dpr

    vo_tr=9 // уст Вид опер
    kop_tr=151 // уст КОП
    g_tr=mod(kop_tr,100)
    outlog(3,__FILE__,__LINE__,'mnr',mnr)

    sele rs1t
    NetAdd()
    netrepl('ttn,skl,sksp,sklsp,amnp,kpl,dvp,ddc,tdc,kto,vo,kop,prz,dot',        ;
             {ttnr,skltpr,gnSk,sklr,mnr,gnKklm,dvpr,ddcr,tdcr,gnKto,vo_tr,kop_tr,1,dprr} ;
          )
    // признак 2-й цены
    pBZenr=getfield('t1', '0,1,vo_tr,g_tr','sopert','pBZen')
    // тип цены
    pTCenr=getfield('t1', '0,1,vo_tr,g_tr','sopert','pTCen')
    // отношение НДС
    pNdsr =getfield('t1', '0,1,vo_tr,g_tr','sopert','pNds')
    cBOptr=""
    If pBZenr#0
      //название поля в CTOV
      cBOptr=allt(getfield('t1', 'ptcenr', 'tcen', 'zen'))
    EndIf
    outlog(3,__FILE__,__LINE__,"pBZenr cBOptr",pBZenr,cBOptr)
  endif


  sele pr2
  netseek('t1', 'mnr')
  cOrdPr2:=ordsetfocus("t1")
  while (mn=mnr)
    ktlr=ktl
    mntovr=mntov
    ktlpr=ktlm
    ktlmr=ktlm
    ktlmpr=ktlmp
    pptr=ppt
    kgnr=int(ktlr/1000000)
    kvpr=kf
    zenr=zen
    svpr=ROUND(kvpr*zenr, 2)

    sele sgrpt
    if (!netseek('t1', 'kgnr'))
      sele sgrp
      if (netseek('t1', 'kg_r'))
        arec:={}
        getrec()
        sele sgrpt
        netadd()
        putrec()
        netrepl('ktl', 'kgnr*1000000+1')
      endif

    endif

    sele rs2t
    netadd()
    netrepl('ttn,mntov,mntovp,ktl,kvp,svp,zen,ktlp,ppt,ktlm,ktlmp,izg',           ;
             {ttnr,mntovr,mntovr,ktlmr,kvpr,svpr,zenr,ktlmpr,pptr,ktlr,ktlpr,izgr} ;
          )
    sele rs2mt
    netadd()
    netrepl('ttn,mntov,mntovp,ktl,kvp,svp,zen,ktlp,ppt,ktlm,ktlmp,izg',           ;
             {ttnr,mntovr,mntovr,ktlmr,kvpr,svpr,zenr,ktlmpr,pptr,ktlr,ktlpr,izgr} ;
          )
    If !Empty(cBOptr) // задана 2-ая цена
      BZenr=getfield('t1','mntovr','ctov',cBOptr)
      netrepl('BZen,BSvp',{BZenr,ROUND(kvpr*BZenr, 2)})
    EndIf

    sele pr2
    skip
    if (eof())
      exit
    endif

  enddo

  sele rs1t
  tbl1r='rs1t'
  tbl2r='rs2t'
  tbl3r='rs3t'
  mDocr='Ttnr'
  fDocr='ttn'
  fKolr='kvp'
  fPrr='pr'

  tbl2mr='rs2mt'
  DogUslr=0
  prDec_fr=prDecr
  pr61r=0

  sele rs1t
  DocPereRsRun()  //PereDoc()

  nUse('rs1t')
  nUse('rs2t')
  nUse('rs2mt')
  nUse('rs3t')
  nUse('tovt')
  nUse('tovmt')
  nuse('sgrpt')
  nuse('sopert')

  gnScout := l_gnScout
  gnD0k1 := l_gnD0k1
  pathr  := l_pathr
  sklr := l_sklr

  sele pr1
  netseek('t2', 'mnr')
  sele pr2
  ordsetfocus(cOrdPr2)
  netseek('t1', 'mnr')

  SELECT(nSele)

  RETURN ( NIL )
