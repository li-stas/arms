If Lastkey()=13
   Do Case
      Case I = 3   //Агенты
           Do case
              case pozicion=1
                   stag()  //Агенты
              case pozicion=2
                   smarsh()  //Маршруты
              case pozicion=3
                   kgpcat()  //Категории ГП stag.prg
              case pozicion=4
                   agcor() && sprod.prg
*                   focus()  //Фокусные группы
              case pozicion=5
                   amplan()  //Месячные планы агентов
              case pozicion=6
                   sprod()   //Структура продаж
              case pozicion=7
                   nap()   //napprod.prg Направления
              case pozicion=8
                   if gnEnt=20
                      bon()
                   endif
              case pozicion=9
                   svplan() && amplan.prg
              case pozicion=10
                   if gnKto=160.or.gnAdm=1
                      users()  && adm/comm/users.prg
                   endif
              case pozicion=11
                   sv() && agent\bon.prg
           endc
      Case I = 4   //Изготовители
           do case
              case pozicion=1
                   mkeep()  //Маркодержатели
              case pozicion=2
                   brnac()  //Нац.на бренды
              case pozicion=3
                   mmplan()  //Месячные планы маркодержателей
              case pozicion=4
                   #ifndef __CLIP__
*                   mkostd() &&mkcros()  //кросс таблица товара
                   #endif
              case pozicion=5
                   mkdt()
*                   mkd()
*                   if gnAdm=1
*                      mkotchda()
*                   endif
              case pozicion=6
                   crjost() && mkotchd.prg
              case pozicion=7
                   mkkplkgp(27)
              case pozicion=8
                   tpokkeg()
              case pozicion=9
                   tpokkegk()
           endc
      Case I = 5   //Клиенты
           do case
              case pozicion=1
                   klnnac()  //Наценки
              case pozicion=2
                   kgp()  //Грузополучатели
              case pozicion=3
                   tmesto()
              case pozicion=4
*                   if gnAdm=1
                      s_kln()  //Справочник
*                   endif
              case pozicion=5
                   kps()
              case pozicion=6
                   s_krn()
              case pozicion=7
                   kgpnet()  // kgp.prg
              case pozicion=8.and.(gnAdm=1.or.gnKto=848)
                   skidlst()  // kps.prg
              case pozicion=9.and.(gnAdm=1.or.gnKto=848)
                   skidusl()  // kps.prg
              case pozicion=10
                   chst()  // kgp.prg
              case pozicion=11
                   a_IdAct()  //
              case pozicion=12
                   a_Prod() //
              case pozicion=13
                   a_TT()  //
           endc
      Case I = 6   //Товар
           do case
              case pozicion=1
                   vid()     //Виды продукции
              case pozicion=2
                   sinctov() //CROSID
              case pozicion=3
*                   if gnAdm=1
                      qtost() && sklad/rs/sp_ttn && Бысрая корр ост недоделано
*                      analitp()   //Аналитика(Подготовка)
*                   endif
              case pozicion=4
                   s_ctov()
              case pozicion=5
                   posbrn()
*                   if gnAdm=1
*                      analit()   //Аналитика(Настройка)
*                   endif
              case pozicion=6
                   posid()
           endc
      Case I = 7   //Статистика
           do case
              case pozicion=1
                   sstat()   //Коды статистики
              case pozicion=2
                   crctov()  //Коррекция CTOV
              case pozicion=3
                   krstat()  //Коды строк
           endc
      Case I = 8   //Доставка
           do case
              case pozicion=1
                   cmrsh()      //Маршрутные листы
              case pozicion=2
                   kgpsk()      //Доставка
              case pozicion=3
                   vmrsh()      //Маршруты   
              case pozicion=4
                   if gnAdm=1 
                      crmrshn()   //Корр нач
                   endif
              case pozicion=5
                   if gnAdm=1
                      crmrsht()   //Корр тек
                   endif  
              case pozicion=6.and.gnEnt=20 && atsl.prg
                   slto()
              case pozicion=7.and.gnEnt=20 && atsl.prg
                   slo()
              case pozicion=8.and.gnEnt=20 && atsl.prg
                   slp() 
              case pozicion=9.and.gnEnt=20 && atsl.prg
                   sltxt() 
              case pozicion=10.and.gnEnt=20 && atsl.prg
                   routes() 
              case pozicion=11.and.gnEnt=20 && atsl.prg
                   slord() 
              case pozicion=12.and.gnEnt=20 && atsl.prg
                   slrout() 
           endc
    EndCase
    keyboard chr(5)
EndIf
Return .T.
