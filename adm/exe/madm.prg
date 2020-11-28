/***********************************************************
 * Модуль    : madm.prg
 * Версия    : 0.0
 * Автор     :
 * Дата      : 02/14/20
 * Изменен   :
 * Примечание: Текст обработан утилитой CF версии 2.02
 */

if ( Lastkey()=13 )
  if ( gnAdm#1 )
    save scre to scmess
    mess( 'У Вас нет прав для работы с этим АРМом', 1 )
    rest scre from scmess
    return
  endif

  do case
  case ( I = 3 )            //Cthdbc
    do case
    case ( pozicion=1 )
      ABINDX( 1 )           //Индексация
    case ( pozicion=2 )
      abindx( 2 )           //Структуры
    case ( pozicion=3 )
      abindx( 3 )           //CP866
    case ( pozicion=4 )
      prvm()                //Переворот
    case ( pozicion=5 )
      vpath()               //Выбор склада
    case ( pozicion=6 )
      crdbc()               // Корр БД
                            //                 ctov()      //Общий справочник ctov
    case ( pozicion=7 )
      abindx( 7 )           //Коррекция индексов
    case ( pozicion=8 )
      indxst()              // Индексация Stop mcrdbc.prg
    case ( pozicion=9 )
      indxcm()              // Индексация comm Stop mcrdbc.prg
                            //                 abindx(4)   //счет 6 знаков
    case ( pozicion=10 )
      indxnst()             // Индексация NStop mcrdbc.prg
      abindx( 5 )           //Плательщик б/с
    case ( pozicion=11 )
      indxcmnst()           // Индексация comm NStop mcrdbc.prg
                            //                 abindx(6)   //12 ст затрат
    case ( pozicion=12 )
    //                 final()   // Закрыть месяц
    case ( pozicion=13 )
    //                 netrs1()  // Локальные документы
    case ( pozicion=14 )
      ctov()                //Общий справочник ctov
                            //                 corvt()   // Коррекция документов по возвр.таре (tpokb,tpstb)
    endcase

  case ( I = 4 )            //Регистрация
    do case
    case ( pozicion=1 )
      users()               //Пользователи
    case ( pozicion=2 )
      s_gru()               //Грузчики
    case ( pozicion=3 )
      setup()               //setup
    case ( pozicion=4 )
      s_cskl()              //Склады
    case ( pozicion=5 )
      s_dbft()              //dbft
    case ( pozicion=6 )
      s_cgrp()              //cgrp
    case ( pozicion=7 )
      s_tskl()              //s_cskl
    case ( pozicion=8 )
      setks()               //setks
    case ( pozicion=9 )
      arms()                //setup
    endcase

  case ( I = 5 )            //Тесты
    do case
    case ( pozicion=1 )
      //                 podg()    //Подготовка
      ctovmerch()
    case ( pozicion=2 )
      indall()
    case ( pozicion=3 )
      corauto()
    //                 ee()
    case ( pozicion=4 )
      corrch()
    case ( pozicion=5 )
      crarnd()              // sinctov.prg
                            //                 sinctov()
    case ( pozicion=6 )
      cpfls()
    case ( pozicion=7 )
      crmerch()             // corrnds.prg
                            //                 dkklnsc() // kplkgp.prg
    case ( pozicion=8 )
      ctovpk()
    case ( pozicion=9 )
      //                 kplif() // Разделение SDV
      zensdva()             // Цена из SDV акция
    case ( pozicion=10 )
      corrnds()
    case ( pozicion=11 )    // "Корр возв тары "
      corvt()
    case ( pozicion=12 )
      if ( gnEntrm=1 )
        skclea()
      endif

    case ( pozicion=13 )
      test()
    case ( pozicion=14 )
      CrRs1Kpk()            // corrnds.prg
      CrProt()              // corrnds.prg PRO,RSO
    case ( pozicion=15 )
      crdop()               // skclea.prg
    case ( pozicion=16 )
      chkdo()               // skclea.prg
    case ( pozicion=17 )
      cment()               // skclea.prg
    case ( pozicion=18 )
      rskolpos()            // skclea.prg
    case ( pozicion=19 )
      docnap()              // skclea.prg
    case ( pozicion=20 )
      dokkdv()              // skclea.prg
    case ( pozicion=21 )
      delrs102()            // skclea.prg
    endcase

  case ( I = 6 )            //Удаленные слады
    do case
    case ( pozicion=1 )     // SEND
      rmmain( 1, 0 )        // rmsdrc
    case ( pozicion=2 )     // RECIEVE
      rmmain( 2, 0 )        // rmsdrc
    case ( pozicion=3 )     // Настройка
      rmset()
    case ( pozicion=4 )     // RECIEVE ARC ext
      rmmain( 2, 1 )        // rmsdrc
    case ( pozicion=5 )     // RECIEVE ARC loc
      rmmain( 2, 4 )        // rmsdrc
    case ( pozicion=6 )     // Передача файлов
      rmmain( 1, 2 )        // rmsdrc
    case ( pozicion=7 )     // Прием файлов
      rmmain( 2, 2 )        // rmsdrc
    case ( pozicion=8 )     // Сверка прием
      rmmain( 2, 3 )
    case ( pozicion=9 )     // Протокол
      rmprot()
    endcase

  endcase

  keyboard chr( 5 )
endif

return ( .T. )
