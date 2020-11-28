/***********************************************************
 * Модуль    : msklad.prg
 * Версия    : 0.0
 * Автор     :
 * Дата      : 02/25/19
 * Изменен   :
 * Примечание: Текст обработан утилитой CF версии 2.02
 */

#include "common.ch"
#include "inkey.ch"

/************************************ */
//Главное меню
//(c) 1998 Harry B. Dubrovin
/************************************ */
przvr=0                     // Признак заявки
if (Lastkey()=K_ENTER)
  setcolor("g/n,n/g,,,")
  do case
  case (I = 3)            //Справочники menu3[]
    do case
    case (pozicion=1)     //Смена склада
      VPATH()
    case (pozicion=2)     //OPER
      if (alltrim(uprlr)=gcSprl.or.gnEnt=21.and.gnKto=786)
        s_soper()
      else
        wmess('НИЗЗЗЯ !!!')
      endif

    case (pozicion=3)     // Справочник групп по изготовителю
      if (gnAdm=1.or.dkklnr=1)//alltrim(uprlr)=gcSprl
        s_sgrp()
      else
        wmess('НЕТ ДОСТУПА !!!')
      endif

    case (pozicion=4)     //Сертификаты
      if (gnCtov=1)
        sert()
      endif

    case (pozicion=5)     //Печать сертификатов
      if (gnCtov=1)
        PSert()
      endif

    case (pozicion=6)     //Передача
      if (gnAdm=1.or.gnRrm=1)
        rmmain(1)
      endif

    case (pozicion=7)     //Прием
      if (gnAdm=1.or.gnRrm=1)
        rmmain(2)
      endif

    case (pozicion=8)     //Прием
      rmprot()
    case (pozicion=9)     //Аренда
      if (gnEnt=21)
        //                     #ifdef __CLIP__
        //                       lpos()
        //                     #else
        lposd()
      //                     #endif
      else
        netuse("ctov")
        netuse("tovm")
        netuse("tov")
        netuse("sgrp")
        netuse("mkeep")
        netuse("kspovo")
        ctov()
        nuse("mkeep")
        nuse("sgrp")
        nuse("tov")
      endif

    case (pozicion=10)    //КСПОВО
      skspovo()             // vost.prg
    case (pozicion=11)    //Коды продукции
      kprod()               // vost.prg
    endcase

  case (I = 4)            //.and.who#0   //Приход menu4[]
    gnRegrs=0
    gnD0k1=1
    gnVo=0
    crpro()                 // Создание pro1,pro2
    NdOtvr=0
    do case
    case (pozicion=1.and.who#0)//Поставщики
      gnVo=9
      fornd_r='vo=9'
      PrhRsh()
    case (pozicion=2.and.who#0)//Магазины
      gnVo=2
      fornd_r='vo=2'
      PrhRsh()
    case (pozicion=3.and.who#0)//Возврат от покупателей
      gnVo=1
      fornd_r='vo=1'
      PrhRsh()
    case (pozicion=4.and.who#0)//Переброска
      gnVo=6
      fornd_r='vo=6'
      PrhRsh()
    case (pozicion=5.and.who#0)//Аренда
      gnVo=10
      fornd_r='vo=10'
      PrhRsh()
    case (pozicion=6)          //Ведомость прихода Ok
      PRVED()
    case (pozicion=7.and.who#0)//Удаление прихода Ok
      PUDL()
    case (pozicion=8)
      pprot()                    // Протокол прихода
    case (pozicion=9.and.who#0)
      gnVo=0
      fornd_r='sks#0'
      PrhRsh()                   // Автоматические приходы
    case (pozicion=10.and.who#0)// Ценник
      etic()
    case (pozicion=11.and.who#0)//Комиссия
      gnVo=3
      fornd_r='vo=3'
      PrhRsh()
    case (pozicion=12.and.who#0)//Протокол продаж по отв.хр.
      if (gnSkotv#0)
        wmess('Этот склад не имеет таких протоколов', 2)
        return
      endif

      gnVo=9
      fornd_r='vo=9'
      NdOtvr=2
      PrhRsh()
    case (pozicion=13.and.who#0)//Приходы(отчеты) c отв.хр.
      if (gnSkOtv#0)
        wmess('Этот склад не имеет таких приходов', 2)
        return
      endif

      gnVo=9
      fornd_r='vo=9'
      NdOtvr=3
      PrhRsh()
    case (pozicion=14 .and.gnAdm=1)//.and.who#0    //Приходы(отчеты) c отв.хр.
      if (gnSkOtv#0)
        wmess('Этот склад не имеет таких приходов', 2)
        return
      endif

      gnVo=9
      fornd_r='vo=9'
      NdOtvr=4
      PrhRsh()
    case (pozicion=15.and.gnAdm=1)//Ост по дням
      mkotchd()
    case (pozicion=16)            // Остатки комиссионеров
      ostkt()                       // ost/tov.ptg
    case (pozicion=17)            // Прот передачи отв хр
      prtotv()                      // pr/paotv.ptg
    case (pozicion=18 .and. gnEnt=21) // MENU4[18] := "Заказ СОХ (Лодис)"
      MkSoh2()
    endcase

  case (I = 5)            // Расход menu5[]
    prnnpr=0                // Никаких действий с документом не было
    gnD0k1=0
    crrso()                 // Создание rso1,rso2
    do case
    case (pozicion=1)     //Покупатели
      gnVo=9
      gnRegrs=0
      PrhRsh()
      //              case pozicion=2.and.(gnAdm=1.or.(gnRp=1.and.who#1))
      //                   gnVo=9       //Покупатели б/п Ok
      //                  gnRegrs=1
    //                  PrhRsh()
    case (pozicion=2)     //Магазины
      gnVo=2
      gnRegrs=0
      PrhRsh()
      //              case pozicion=4.and.(gnAdm=1.or.(gnRp=1.and.who#1))
      //                   gnVo=2       //Магазины б/п Ok
      //                  gnRegrs=1
    //                   PrhRsh()
    case (pozicion=3)     //Накладная подотчет
      gnVo=7
      gnRegrs=0
      vor=7
      PrhRsh()
    case (pozicion=4)     //Возврат из подотчета
      gnVo=8
      gnRegrs=0
      vor=7
      PrhRsh()
    case (pozicion=5)     //Внутренняя переброска
      gnVo=6
      gnRegrs=0
      PrhRsh()
    case (pozicion=6)     //Акт на списание
      prlkr=0
      gnRegrs=0
      gnVo=5
      store space(60) to kom1r, kom2r, kom3r, zak1r, zak2r, zak3r
      PrhRsh()
    case (pozicion=7)     //Возврат поставщику
      gnRegrs=0
      gnVo=1
      PrhRsh()
    case (pozicion=8)     //Аренда
      gnRegrs=0
      gnVo=10
      PrhRsh()
    case (pozicion=9.and.who#2)//Подтверждение    Ok
      if (.t.)
        if (!(month(gdTd)=month(date()).and.year(gdTd)=year(date())))
          ach:={ 'Нет', 'Да' }
          achr=0
          achr=alert('Это не текущий месяц.Продолжить?', ach)
          if (achr#2)
            return
          endif

        endif

        RFAKT()
      else
        wmess('НИЗЗЗЯ !!!')
      endif

    case (pozicion=10)    //Удаление расхода Ok
      if (.t.)
        RUDL()
      else
        wmess('НИЗЗЗЯ !!!')
      endif

    case (pozicion=11)    //Ведомость расхода  Ok
      RSVED()
    case (pozicion=12)    //Ведомость текущего дня
      RSVEDTD()
    case (pozicion=13)    //Комиссионная торговля
      gnRegrs=0
      gnVo=3
      PrhRsh()
    case (pozicion=14)    //Отчеты комиссионеров
      rvedvGR()
    case (pozicion=15)
      rprot()               // Протокол расхода
    case (pozicion=16)    //Автоматические
      gnVo=0
      fornd_r='sks#0'
      PrhRsh()
    case (pozicion=17)    // Протокол по возвратной таре
      prlkr=0
      gnRegrs=0
      gnVo=4
      PrhRsh()
    case (pozicion=18)    //Поиск по docguid bso2.prg
      if (gnEnt=21)
        pskguid()
      endif

    /*
    *                   if gnCtov=3.and.gnMskl=0  // Лимитная карта
    *                      prlkr=1
    *                      gnRegrs=0
    *                      gnVo=5
    *                      store space(60) to kom1r,kom2r,kom3r,zak1r,zak2r,zak3r
    *                      PrhRsh()
    *                   endif
    */
    case (pozicion=19)    //Загрузка продаж
      if (empty(gcPath_pm))
        wmess('PATH_PM в SHRIFT пустой', 1)
        return
      endif

      przvr=1               // Признак заявки
      prnnpr=0              // Никаких действий с документом не было
      gnD0k1=0
      gnVo=9
      gnRegrs=0
      PrhRsh()
      przvr=0
    case (pozicion=20.and.gnEnt=20.and.prdp().and.gnAdm=1)//Подтверждение списком
      lstfakt()             // rfakt
    case (pozicion=21)    //Отчеты комиссионеров
      otkms()               // rvedvgr.prg
                            //                    rvedvGR()
    case (pozicion=22                    ; // Уценка
           .and.str(gnEnt, 3)$' 20; 21' ;
           .and.(gnAdm=1.or.str(gnKto, 4)$' 129; 160; 117') ;// Калюжный Таранец Ищенко 169
        )
      TtnUc()               // crrso.prg
    endcase

  case (I = 6)            // Остатки menu6[]
    do case
    case (pozicion=1)     //Просмотр остатков Ok
      kpsr=0
      gnD0k1=0
      if (gnCtov=1)
        tovm()
      else
        tov()
      endif

    case (pozicion=2)     //Ведомости остатков Ok
      vost()
    case (pozicion=3)     //Ведомости остатков по товару Ok
      vostm()
    case (pozicion=4)     //Оборотная ведомость Ok
      VOBR()
    case (pozicion=5)
      vcen()                //Ведомость цен
    case (pozicion=6)
      vinv()                //Ведомость инвентаризации
    case (pozicion=7)
      odkp()                //Карта покупателей
    case (pozicion=8)
      debn()                // Дебеторка
    /* //                  sctov()       //Переоценка */
    case (pozicion=9)
      gd_Td:=gdTd

      gdTd:=ADDMONTH(gdTd, -1)
      inipath()
      kssk(, 1)           // Контр сумма по складу debs.prg
      gdTd:=gd_Td
      inipath()
      kssk(-19)           // Контр сумма по складу debs.prg
                            // //                 debs()        //Дебеторка по супер
                            // //                 zagrat()
    case (pozicion=10)    // Контроль отгрузки
      chkotgr()             // sctov.prg
    case (pozicion=11)    // Контроль заявок КПК
      chkzvkpk()
    case (pozicion=12)    // Возврат тары
      vtara()
    case (pozicion=13)    //Печать прайсов
      prnprice()
    case (pozicion=14)    //Ост на день sctov.prg
      ostday()
    case (pozicion=15)    // Заявки КПК
      zvkpk()               //sctov.prg
    case (pozicion=16)    // Сбойные заявки КПК
      SbZvKpk()             //sctov.prg
    case (pozicion=17.and.gnEnt=20)// Оплата
      vzkpk()                        //sctov.prg
                                     // ktaopl()      //sctov.prg
    case (pozicion=18)             // Акции
      rsakc()                        // cen.prg
    case (pozicion=19.and.(gnAdm=1.or.gnRnap=1).and.gnEnt=20)// Оплата по направдениям
      OplNap()              //sctov.prg
    case (pozicion=20)    // акт верки по оборудованию
      if (gnCtov = 1)
        AktChkKpl()
      endif

    case (pozicion=21)    // акт верки по оборудованию
      if (gnCtov = 1)
        AktChkTa()
      endif

    endcase

  case (I = 7)            //Сервис menu7[]
    do case
    case (pozicion=1)     //Индексация
                            //                    BINDX()
      sindxns()
    case (pozicion=2)     //Переворот Ok
      if (Who = 3)
        if (alltrim(uprlr)=gcSprl.or.gnEnt=5)
          vbr=0
          avb:={ 'Да', 'Нет' }
          vbr=alert('Это переворот месяца.Вы уверены?', avb)
          if (vbr=1)
            pathtr=gcPath_t
            DOBNV()
          endif

        endif

      endif

    case (pozicion=3)     // Коррекция документов по opt  MENU7[3]
                            //                      wmess('Отключено',2)
      if (gnAdm=1)
        vbr=1
        avb:={ 'Нет', 'Да' }
        vbr=alert('Это перерасчет документов.Вы уверены?', avb)
        if (vbr=2)
          CDocOpt()
        endif

      else
        wmess('НИЗЗЯ!!!', 2)
      endif

    case (pozicion=4)     // Остатки нач
                            //                  if gnAdm=1
      if (gnTpstpok=2.and.bom(gdTd)=ctod('01.09.2006').and.gnEnt=21)
      else
        path_tr=gcPath_t
        dtpr=bom(gdTd)-1
        yyr=year(dtpr)
        mmr=month(dtpr)
        path_pr=gcPath_e+'g'+str(yyr, 4)+'\m'+iif(mmr<10, '0'+str(mmr, 1), str(mmr, 2))+'\'+gcDir_t
        ctov_r=gnCtov
        nost()
      endif

      //                  else
      //                      wmess('НИЗЗЯ!!!',2)
    //                  endif
    case (pozicion=5)     // Текущие остатки
                            //                   if gnAdm=1
      path_tr=gcPath_t
      ctov_r=gnCtov
      skr=gnSk
      sklr=gnSkl
      entr=gnEnt
      arndr=gnArnd
      //                      #ifdef __CLIP__
      tost()
      //                      #else
      //                        tost1()
      //                      #endif
      //                   else
      //                      wmess('НИЗЗЯ!!!',2)
    //                   endif
    case (pozicion=6)     // Приходы отв хран
      if (gnAdm=1)
        //                     cropl() // psert.prg
      //                     crotvosv()
      endif

      //                  if gnOtv#0
      //                     if gnAdm=1
      //                        path_tr=gcPath_t
      //                        ctov_r=gnCtov
      //                        p rvotv() //  protv.prg
      //                     else
      //                        wmess('НИЗЗЯ!!!',2)
      //                     endif
      //                 else
      //                     wmess('Этот склад не имеет ответхранения',2)
    //                endif
    case (pozicion=7)     // Отв хр корр
                            // Отпускные цены
                            //                 if gnAdm=1
      path_tr=gcPath_t
      dtpr=bom(gdTd)-1
      yyr=year(dtpr)
      mmr=month(dtpr)
      path_pr=gcPath_e+'g'+str(yyr, 4)+'\m'+iif(mmr<10, '0'+str(mmr, 1), str(mmr, 2))+'\'+gcDir_t
      ctov_r=gnCtov
      OtvPrv()              // protv.prg
                            //                  scen()
                            //                 else
                            //                   wmess('НИЗЗЯ!!!',2)
                            //                endif
    case (pozicion=8)     // Коррекция RS2M
      if (gnAdm=1)
        path_tr=gcPath_t
        ctov_r=gnCtov
        if (gnCtov=1)
          crs2m()
        endif

      else
        wmess('НИЗЗЯ!!!', 2)
      endif

    case (pozicion=9)     // Пересортица
      if (gnAdm=1)
        psort()
      else
        wmess('НИЗЗЯ!!!', 2)
      endif

    case (pozicion=10)    // S92
      s92()
    case (pozicion=11)    // Документы по времени
      tdoc()
    case (pozicion=12)    // Автоматы
                            // Коррекция маршрутов текущих
      if (gnAdm=1)
        autodoc()
      endif

    //                   adoc()
    case (pozicion=13)    // OSN OSF пер Прайсы архив
                            //                   if gnAdm=1
                            //                      frarh()
                            //                  endif
      ostprd()
    case (pozicion=14)    // Поиск документа
      docsrch()
    case (pozicion=15)    // Корр возв тары
      CorVt()
    case (pozicion=16)    // Корр rs1.tmesto, ktas /serv/scen.prg
      cortm()
    case (pozicion=17)    // Модиф док  /serv/scen.prg
      mdglkn()
    case (pozicion=18)    // 361
      s361()
    case (pozicion=19)    // Модиф док 361 /serv/scen.prg
      md361()
    case (pozicion=20)    // Дв DOCGUID /serv/scen.prg
      dvid()
    endcase

  case (I = 8)            //Доставка menu8[]
    do case
    case (pozicion=1)
      cmrsh()               //Маршрутные листы
    case (pozicion=2)
      kgpsk()               //Доставка
    case (pozicion=3)
      vmrsh()               //Маршруты
    case (pozicion=4)
      if (gnAdm=1)
        crmrshn()           //Корр нач
      endif

    case (pozicion=5)
      if (gnAdm=1)
        crmrsht()           //Корр тек
      endif

    case (pozicion=6)
      vzttn()
    case (pozicion=7)
      shvzttn()
    endcase

  endcase

  keyboard chr(5)
endif

return (.T.)
