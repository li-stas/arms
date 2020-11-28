/***********************************************************
 * Модуль    : prh.prg
 * Версия    : 0.0
 * Автор     :
 * Дата      : 07/20/19
 * Изменен   :
 * Примечание: Текст обработан утилитой CF версии 2.02
  FUNCTION prh()
  RETURN ( NIL)
 */

#include "common.ch"
#include "inkey.ch"
/********  ПРИХОД (Товар) *************  10-11-92 */
// Если kopp#0 а auto=0 - это приход-автомат
prce=.f.
optrr=.f.
ndprzr=2
ndkpsr=0
ndkopr=0
ccor_r=0
otvr=0

Skr=gnSk
rmSkr=gnRmSk
entr=gnEnt
ctovr=gnCtov

nddt1r=bom(gdTd)
if (gdTd#date())
  nddt2r=eom(gdTd)
else
  nddt2r=gdTd
endif

do case
case (gnVo=0.and.NdOtvr=0)// Автоматический приход
  fornd_r='Sks#0.and.otv=0'
case (gnVo=1.and.NdOtvr=0)// Возврат от покупателей
  fornd_r='vo=1.and.otv=0'
case (gnVo=2.and.NdOtvr=0)// Возврат от магазинов
  fornd_r='vo=2.and.otv=0'
case (gnVo=3.and.NdOtvr=0)// Возврат комиссинный
  fornd_r='vo=3.and.otv=0'
case (gnVo=6.and.NdOtvr=0)// Переброска
  fornd_r='vo=6.and.otv=0'
case (gnVo=9.and.NdOtvr=0)// Приход от поставщика
  fornd_r='vo=9.and.otv=0'
case (gnVo=9.and.NdOtvr=1)// Приходы со склада отв.хр.
  fornd_r='vo=9.and.otv=1'
case (gnVo=9.and.NdOtvr=2)// Отчет по отв.хр.
  fornd_r='vo=9.and.otv=2'
case (gnVo=9.and.NdOtvr=3)// Приходы от поставщика с отв.хр.
  fornd_r='vo=9.and.otv=3'
case (gnVo=9.and.NdOtvr=4)// Приходы от поставщика с отв.хр.ручные
  fornd_r='vo=9.and.otv=4'
case (gnVo=10.and.NdOtvr=0)// Аренда
  fornd_r='vo=10.and.otv=0'
endcase

ForNdr=fornd_r

while (.T.)
  setcolor(fclr)
  sele sl
  zap
  prNppr=0                  // Никаких действий с документом не было
  unlock all
  sele pr1
  if (corsh=0)
    Pr1IniMemVar()
  else
    sele pr1
    netseek('t1', 'ndr')
    reclock()
  endif

  clea
  @ 0, 1 say 'Номер      '
  @ 0, 65 say gcNSkl

  if (str(gnSk, 3)$'263;705')// брак 169 второй формы
    @ 0, 32 say 'Основание'
  else
    @ 0, 32 say 'Договор '+space(9)+' вiд '
  endif

  @ 1, 1 say 'Дата       '
  @ 2, 1 say 'Операция   '
  @ 3, 1 say 'Источник   '
  @ 5, 1 say 'Назначение '

  if (corsh=0)
    @ 0, 14 get ndr pict'999999' when ndw() valid ndv()
    read
    if (lastkey()=K_ESC)
      set key K_SPACE to
      exit
    endif

  endif

  sele pr1
  netseek('t1', 'ndr')
  if (!FOUND().and.(NdOtvr=2.or.NdOtvr=3))
    wmess('Нельзя создать документ для этого режима', 2)
    loop
  endif

  if (ndr=0.and.who=1.and.NdOtvr=0)//.or.NdOtvr=1.or.NdOtvr=2
    exit
  endif

  if (foun().and.vo#gnVo)
    if (vo=0)
      wmess('Это автомат', 2)
    else
      nvor=getfield('t1', 'pr1->vo', 'vop', 'nvo')
      wmess('Это '+nvor, 2)
    endif

    loop
  endif

  if (ndr=0.or.!FOUND().or.corsh=1)
    if (ndr=0.or.!FOUND()).and.corsh=0
      if (!prdp())
        loop
      endif

      if (!(month(gdTd)=month(date()).and.year(gdTd)=year(date())))
        ach:={ 'Нет', 'Да' }
        achr=0
        achr=alert('НОВЫЙ ДОКУМЕНТ.Это не текущий месяц.Продолжить?', ach)
        if (achr#2)
          loop
        endif

      endif

      sele cSkl
      netseek('t1', 'gnSk',,, 1)
      reclock()
      while (.t.)
        sele cSkl
        mnr:=mn
        if (netseek('t2', 'mnr', 'pr1'))
          if (mn<999999)
            netrepl('mn', { mn+1 }, 1)
          else
            netrepl('mn', { 1 }, 1)
          endif

        else
          //sele cSkl
          //netunlock()

          // получен новый номер МашНом, поствим счетчик на следующий
          sele cSkl
          if (mn<999999)
            netrepl('mn', { mn+1 })
          else
            netrepl('mn', { 1 })
          endif

          exit
        endif

      enddo

      if (ndr=0)
        ndr = mnr
      endif

    endif

    go top
    if (corsh=0)
      nt = '<-НОВЫЙ'
    else
      przn=1
      netseek('t1', 'ndr')
    endif

    @ 0, 14 say str(ndr, 6)+nt

    if (str(gnSk, 3)$'263;705')// брак 169 второй формы
      @ 0, 40 get docguidr
    else
      @ 0, 40 get nnzr; @ 0, 46 say ' от '; @ 0, 50 get dnzr
    endif

    Read
    if (LastKey() = 27)
      if (corsh=0)
        loop
      else
        exit
      endif

    endif

    if (str(gnSk, 3)$'263;705')// брак 169 второй формы
      @ 0, 40 say docguidr
    else
      @ 0, 40 say nnzr+' от  '+dtoc(dnzr)
    endif

    @ 1, 14 get dvpr
    read
    if (lastkey()=K_ESC)
      loop
    endif

    @ 1, 14 say dtoc(dvpr)

    @ 1, 25 say 'Товаровед '+gcName
    fktor=gcName
    ktor=gnKto

    if (gnVo=9 .or. gnVo=1 .or. gnVo=3)
      @ 1, 55 prom 'САМОВЫВОЗ'
      @ 2, 55 prom 'ЦЕНТРОЗАВОЗ'
      menu to mpvt
      if (mpvt=1)
        @ 1, 55 say 'САМОВЫВОЗ'
        @ 2, 55 say space(12)
        pvtr=1
      else
        @ 1, 55 say 'ЦЕНТРОЗАВОЗ'
        @ 2, 55 say space(12)
        pvtr=0
      endif

    endif

    sele soper
    go top
    @ 2, 14 get kopr pict '999'
    read
    if (kopr#0)
      if (kopr<100)
        kopr=gnVu*100+kopr
      endif

      if (vor=6.and.kopr#111)
        if (gnCtov=1)
          kopr=0
        endif

      endif

      qr=mod(kopr, 100)
      Autor=getfield('t1', 'gnD0k1,gnVu,gnVo,qr', 'soper', 'auto')
      if (Autor=3)
        kopr=0
      endif

    endif

    if (kopr=0)
      if (Autor#0)
        kopr=SLCf('soper',,, 10,, "e:kop h:'Код' c:n(3) e:nop h:'Наименование' c:c(40)", 'kop', 0,,, ;
                   'd0k1=gnD0k1.and.vu=gnVu.and.vo=gnVo.and.auto#3'                                   ;
                )
      else
        kopr=SLCf('soper',,, 10,, "e:kop h:'Код' c:n(3) e:nop h:'Наименование' c:c(40)", 'kop', 0,,, ;
                   'd0k1=gnD0k1.and.vu=gnVu.and.vo=gnVo.and.kopp=0'                                   ;
                )
      endif

    endif

    if (kopr=0)
      loop
    endif

    if (kopr<100)
      kopr=gnVu*100+kopr
    endif

    if (gnEnt#21)
      if (vor=6.and.kopr#111.and.gnAdm=0.and.gnKto#969)
        if (gnCtov=1)
          wmess('Только 111 КОП')
          kopr=0
          loop
        endif

      endif

    endif

    prVzznr=0
    if (gnEnt=20.or.gnEnt=21).and.kopr=110.and.vor=1
      sele pr2
      prVzznr=1
    endif

    sele pr1
    qr=mod(kopr, 100)

    store 0 to onofr, opbzenr, opxzenr, ;
     otcenpr, otcenbr, otcenxr,         ;
     odecpr, odecbr, odecxr
    if (!inikop(gnD0k1, gnVu, gnVo, qr))
      loop
    endif

    // Инициализация адресов по SOPER
    // Назначение
    if (Autor#0)
      store Skar to gnSkt, Sktr
      store Sklar to gnSklt, Skltr
      store mSklar to gnMSklt, mSkltr
      store nSklar to gnNSklt, nSkltr
    else
      store 0 to gnSkt, Sktr
      store 0 to gnSklt, Skltr
      store 0 to gnMSklt, mSkltr
      store '' to gnNSklt, nSkltr
    endif

    @ 2, 14 say str(kopr, 3)+' '+nopr
    @ 2, col()+1 say 'Кат.разгр' get katgrr pict '99'
    read

    Sklr=gnSkl

    do case
    case (gnVo=2)         // Возврат от магазинов
      kpsr=okklr
      if (kpsr=0)
        wmess('Нет кода поставщика(магазина) в SOPER', 3)
        loop
      endif

      if (Autor#0)
        if (mSkltr#0)
          Skltr=kpsr
        endif

      endif

      nkpsr=nokklr
      @ 3, 1 say 'Источник  : '+str(kpsr, 7)+' '+alltrim(nkpsr)
      @ 4, 1 say 'Агент     : ' get ktar pict '999' valid kta()
      @ 4, 18 say subs(nktar, 1, 15) get prvzr pict '9'
      @ 5, 1 say 'Назначение: '+gcNSkl//10
      read
      nktar=getfield('t1', 'ktar', 's_tag', 'fio')
      @ 4, 18 say subs(nktar, 1, 15)
    case (gnVo=6)                   // Переброска
      if (Autor=0)                  // Приход с Будинформа
        if (gnEnt#13)
          if (gnEnt=14.or.gnEnt=15.or.gnEnt=17).and.kopr=168.or.gnEnt=16.and.kopr=120
            kpsr=1402041
          endif

          if (gnEnt=14.or.gnEnt=15.or.gnEnt=17).and.kopr=185
            kpsr=3338990
          endif

          if (gnSk=254)   // Отв хр jaffa
            kpsr=2248008
          endif

          if (gnMSkl=0)
            if (gnSk=254)
              @ 3, 1 say 'Подотчетник:'+str(kpsr, 7)+' '+alltrim(getfield('t1', 'kpsr', 'kln', 'nkl'))
            else
              @ 3, 1 say 'Источник  : '+str(kpsr, 7)+' '+alltrim(getfield('t1', 'kpsr', 'kln', 'nkl'))
            endif

          else
            @ 6, 1 say 'Подотчетник:' get Sklr pict '9999999' valid Sklkln()
            read
            if (lastkey()=K_ESC.or.Sklr=0)// Обязательный выбор мультисклада
              loop
            endif

            nSklr=getfield('t1', 'Sklr', 'kln', 'nkl')
            @ 6, 14 say str(Sklr, 7)+' '+alltrim(nSklr)
          endif

        else
          kpsr=gnKkl_c
          @ 3, 1 say 'Источник  : '+str(kpsr, 7)+' '+gcName_c
        endif

      else                  // Приход со склада
        @ 3, 1 say 'Источник  : '+str(kpsr, 7)+' '+nSkltr
        if (mSkltr#0)
          @ 4, 1 say 'Подотчетник:' get kplr pict '9999999' valid kplpkln()
          read
          Skltr=kplr
          if (lastkey()=K_ESC)
            loop
          endif

          nkplr=getfield('t1', 'kplr', 'kln', 'nkl')
          @ 4, 14 say str(kplr, 7)+' '+alltrim(nkplr)
        endif

        @ 5, 1 say 'Назначение:   '+gcNSkl
        if (gnMSkl=1)
          @ 6, 1 say 'Подотчетник:' get Sklr pict '9999999' valid Sklkln()
          read
          if (lastkey()=K_ESC.or.Sklr=0)// Обязательный выбор мультисклада
            loop
          endif

          nSklr=getfield('t1', 'Sklr', 'kln', 'nkl')
          @ 6, 14 say str(Sklr, 7)+' '+alltrim(nSklr)
        endif

      endif

    case (gnVo=1.or.gnVo=9 .or. gnVo=3)// Поставщики/Возврат от покупателя
      if (gnVo=1)
        if (STR(gnSk, 3) $ '238;239;703;;262;263;704;705')//gnSk=238.or.gnSk=239.or.
          @ 3, 1 say 'Покупатель:  ' get kpsr pict '9999999' valid kpSkln()
        else
          if (gnEnt=21.and.vor=1.and.kopr=110)
            @ 3, 1 say 'Покупатель:  ' get kpsr pict '9999999'
          endif

        endif

      else
        @ 3, 1 say 'Поставщик :  ' get kpsr pict '9999999' valid kpSkln()
      endif

      if (gnVo=1)
        if (STR(gnSk, 3) $ '238;239;703;262;263;704;705')// gnSk=238.or.gnSk=239
          @ 4, 1 say 'Агент     :  ' get ktar pict '999' valid kta()
        endif

        @ 4, 18 say subs(nktar, 1, 15) get PrVzr pict '9'
      endif

      read
      nktar=getfield('t1', 'ktar', 's_tag', 'fio')
      @ 4, 18 say subs(nktar, 1, 15)
      if (Autor#0.and.mSkltr=1)
        Skltr=kpsr
      endif

      if (lastkey()=K_ESC)
        loop
      endif

      nkpsr=getfield('t1', 'kpsr', 'kln', 'nkl')
      pr1ndsr=getfield('t1', 'kpsr', 'kpl', 'pr1nds')
      if (kopr#110)
        pr1ndsr=0
      endif

      @ 3, 14 say str(kpsr, 7)+' '+alltrim(nkpsr)
      if (gnVo=1.and.gnEnt=21.and. STR(gnSk, 3) $ '238;239;703;263')
        @ 5, 1 say 'Грузополучатель :' get kzgr pict '9999999'
        read
        if (lastkey()=K_ESC)
          loop
        endif

        nzgr=getfield('t1', 'kzgr', 'kln', 'nkl')
        @ 5, 1 say 'Грузополучатель : '+str(kzgr, 7)+' '+subs(nzgr, 1, 24)
      else
        @ 5, 1 say 'Назначение:    '+gcNSkl//10
      endif

      if (gnMSkl=1)
        @ 6, 1 say 'Подотчетник:' get Sklr pict '9999999' valid Sklkln()
        read
        if (lastkey()=K_ESC.or.Sklr=0)// Обязательный выбор мультисклада
          loop
        endif

        nSklr=getfield('t1', 'Sklr', 'kln', 'nkl')
        @ 6, 14 say str(Sklr, 7)+' '+alltrim(nSklr)
      else
        if (gnVo=1)
          // провекра на взр. ТТН
          if (!(STR(gnSk, 3) $ '239;703;263;705'))// 238;
                            //!(gnSk=238.or.gnSk=239)   // if gnSk=239 // тара Ресурс
            sele pr1
            if (pr1ndsr=0)//.or.vor=1.and.kopr=108
                            //@ 5,1 say 'Назначение:  '+str(Sktr,3)+' '+nSkltr
              nl_Autor := Autor; nl_mSkltr := mSkltr
              @ 5, 1 say 'Склад  ВЗР:' get Skvzr pict '999'                     ;
               valid Skvzr=gnSk .or. (nl_Sktr:=Sktr, Sktr:=Skvzr, lRet:=Skt(), ;
                                       Skvzr:=Sktr, Sktr:=nl_Sktr, lRet         ;
                                    )

              @ 6, 1 say 'ТТН' get ttnvzr pict '999999'
              @ 6, 12 say 'Дата' get dtvzr valid TtnVz()
              read
              Autor := nl_Autor; mSkltr := nl_mSkltr
            else
              if (!ndsvz())
                loop
              endif

            endif

            if (lastkey()=K_ESC)
              loop
            endif

            @ 3, 1 say 'Покупатель:  '+' '+str(kpsr, 7)+' '+nkpsr
            @ 4, 1 say 'Агент     :  '+' '+str(ktar, 4)+'('+str(ktasr, 4)+')'+' '+nktar

            //if iif(.t., ((Skt(Sktr),.T.) .and. Autor#0 .and. mSkltr=1), .f.)
            if (Autor#0 .and. mSkltr=1)
              Skltr=kpsr
            endif

          endif

        endif

      endif

      if (gnVo=9)
        @ 7, 1 say 'Док пост' get ttnpstr//PICT 'S35'
        @ 7, col()+1 say 'от' get dttnpstr
        @ 7, col()+1 say 'Опл' get dopr                                                                   ;
         when (dopr:=iif(empty(dopr), dvpr+getfield('t1', 'kpsr', 'klnDog', 'kdOpl'), dopr), .T.) ;
         valid dopr >= dvpr
        @ 8, 1 say 'НН  пост' get ndspstr
        @ 8, col()+1 say 'Дата' get dndspstr
        read
        if (lastkey()=K_ESC)
          loop
        endif

      endif

    case (gnVo=10)        // Аренда
      if (gnArnd=2)
        if (okplr#0)
          kpsr=okplr
        endif

        @ 3, 1 say 'Владелец:      ' get kpsr pict '9999999' valid kpSkln()
        read
        if (lastkey()=K_ESC)
          loop
        endif

        nkpsr=getfield('t1', 'kpsr', 'kln', 'nkl')
        @ 3, 14 say str(kpsr, 7)+' '+alltrim(nkpsr)
        @ 5, 1 say 'Назначение:    '+gcNSkl//10
        Sklr=gnSkl
      endif

      if (gnArnd=3)       // (Автомат 193)
        @ 3, 1 say 'Владелец:      ' get kpsr pict '9999999' valid kpSkln()
        read
        if (lastkey()=K_ESC)
          loop
        endif

        nkpsr=getfield('t1', 'kpsr', 'kln', 'nkl')
        @ 3, 14 say str(kpsr, 7)+' '+alltrim(nkpsr)
        @ 5, 1 say 'Назначение:    '+gcNSkl//10
        Sklr=gnSkl
      endif

    endcase

    kpsbbr=getfield('t1', 'kpsr', 'kps', 'prbb')
    /************************************** */
    r1=1
    @ 23, 5 prompt 'ВСЕ ВЕРНО'
    @ 23, col()+1 prompt 'НЕ ВЕРНО'
    menu to r1
    @ 23, 0 clear
    if (LastKey() = 27)
      clea
      exit
    endif

    if (r1=2)
      loop
    endif

  else                      // Найден !!!
                            // outlog(__FILE__,__LINE__,Autor,Skar,'Autor,Skar')
    if (!FOUND().or.ndr=0)
      wmess('Документ не найден', 3)
      loop
    endif

    //      if otv#0
    //         do case
    //            case otv=1
    //                 messr='Отв.хран.служебный'
    //            case otv=2
    //                 messr='Отв.хран.протокол'
    //            case otv=3
    //                 messr='Отв.хран.отчет'
    //         endcase
    //         wmess(messr,3)
    //         loop
    //      endif
    if (!Reclock(1))    //Блокировка документа для работы одного польз.
      wmess('Документ блокирован '+alltrim(getfield('t1', 'pr1->ktoblk', 'speng', 'fio')), 3)
      //         wmess('Документ блокирован другим пользователем,попробуйте позже',3)
      loop
    endif

    nt='<- НАЙДЕН'

    Pr1ToMemVar()

    if (Sksr=0)
      if (vor#gnVo)
        nvor=getfield('t1', 'vor', 'vop', 'nvo')
        if (vor#0)
          wmess('Этот документ - '+nvor, 3)
          loop
        else
          wmess('Документ не имеет вида операции ', 3)
          loop
        endif

        loop
      endif

    endif

    if (bom(gdTd)>=ctod('01.03.2011'))
      if (prZr=1.and.pr1ndsr=0)
        nnds_r=getfield('t2', '0,0,gnSk,ndr,mnr', 'nnds', 'nnds')
        if (nndsr#nnds_r)
          sele pr1
          netrepl('nnds', 'nnds_r', 1)
          nndsr=nnds_r
        endif

      else
        //            if nndsr#0
        //               sele nnds
        //               if netseek('t1','nndsr')
        //                  if !(mn=0.and.Sk=gnSk.and.rn=ndr.and.mnp=mnr)
        //                     nndsr=0
        //                  endif
        //               else
        //                  nndsr=0
        //               endif
        //               if nndsr=0
        //                  sele pr1
        //                  netrepl('nnds','nndsr',1)
        //               endif
      //            endif
      endif

    endif

    if (bom(gdTd)<ctod('01.03.2011'))
      if (nndsr#0.and.ttnvzr#0)
        if (select('nds')=0)
          netuse('nds')
        endif

        sele nds
        set orde to tag t3
        if (netseek('t3', 'gnSk,mnr,1'))
          nndsr=nomnds
          nomndsvzr=nomndsvz
          dnnvzr=dnnvz
          if (nomndsvzr=0)
            nomndsvzr=getfield('t3', 'gnSk,ttnvzr,0', 'nds', 'nomnds')
            dnnvzr=getfield('t3', 'gnSk,ttnvzr,0', 'nds', 'dnn')
            netrepl('nomndsvz,dnnvz,ttnvz', 'nomndsvzr,dnnvzr,ttnvzr')
          endif

        endif

      endif

    else
      if (ttnvzr#0)
        ttnvz()
        sele pr1
        netrepl('nndsvz,dnnvz', 'nndsvzr,dnnvzr', 1)
      endif

      if (pr1ndsr=1)
        if (nndsr#0)
          netrepl('nnds,nndsvz,dnnvz', 'nndsr,nndsvzr,dnnvzr', 1)
        endif

      endif

    endif

    sele pr1

    @ 0, 14 say str(ndr, 6)
    if (prZr=1)
      @ 0, 20 say '->ПОДТВ    ' color 'r/n'
    else
      @ 0, 20 say '->НЕ ПОДТВ ' color 'gr+/n'
    endif

    if (!empty(docguidr))
      @ 0, 32 say alltrim(docguidr)
    else
      @ 0, 40 say nnzr+' от  '+dtoc(dnzr)+' '+gcNSkl
    endif

    if (prZr=0)
      @ 1, 14 say dtoc(dvpr)
    else
      @ 1, 14 say dtoc(dprr)
    endif

    sele speng
    locate for kgr=ktor
    if (FOUND())
      fktor=alltrim(fio)
    else
      fktor='Вiдсутнiй в довiднидку'
    endif

    @ 1, 25 say 'Товаровед '+fktor

    if (gnVo=9 .or. gnVo=1 .or. gnVo=3)
      if (pvtr=1)
        @ 1, 55 say 'САМОВЫВОЗ'
      else
        @ 1, 55 say 'ЦЕНТРОЗАВОЗ'
      endif

    endif

    if (Sksr=0)
      sele soper
      store 0 to onofr, opbzenr, opxzenr, ;
       otcenpr, otcenbr, otcenxr,         ;
       odecpr, odecbr, odecxr
      inikop(gnD0k1, vur, vor, qr)
      gnSkt=Skar
      gnSklt=Sklar
      gnMSklt=mSklar
      mSkltr=mSklar
      @ 2, 14 say str(kopr, 3)+' '+nopr
      @ 2, col()+1 say 'Кат.разгр'+' '+str(katgrr, 2)
      do case
      case (gnVo=2)       // Магазины
        nkpsr=getfield('t1', 'kpsr', 'kln', 'nkl')
        @ 3, 1 say 'Источник  : '+str(kpsr, 7)+' '+alltrim(nkpsr)
        @ 4, 1 say 'Агент     :  '+str(ktar, 4)+' '+subs(nktar, 1, 15)
        @ 4, col()+1 say str(prvzr, 1)
        @ 5, 1 say 'Назначение: '+gcNSkl//10
      case (gnVo=6)                   // Переброска
        if (entpr=0)
          if (Sktr#0)
            @ 3, 1 say 'Источник  : '+str(kpsr, 7)+' '+nSkltr
            if (mSkltr=1)
              @ 4, 1 say 'Подотчетник:'
              nkplr=getfield('t1', 'kplr', 'kln', 'nkl')
              @ 4, 14 say str(kplr, 7)+' '+alltrim(nkplr)
            endif

          else
            if (gnEnt=14.or.gnEnt=15.or.gnEnt=17).and.(kopr=168.or.kopr=185).or.gnEnt=16.and.kopr=120
              @ 3, 1 say 'Источник  : '+str(kpsr, 7)+' '+alltrim(getfield('t1', 'kpsr', 'kln', 'nkl'))
            else
              @ 3, 1 say 'Источник  : '+str(kpsr, 7)+' '+gcName_c
            endif

          endif

          @ 5, 1 say 'Назначение:   '+gcNSkl//10
          if (gnMSkl=1)
            @ 6, 1 say 'Подотчетник:'
            nSklr=getfield('t1', 'Sklr', 'kln', 'nkl')
            @ 6, 14 say str(Sklr, 7)+' '+alltrim(nSklr)
          endif

        else
          @ 3, 1 say 'Источник  : '+str(entpr, 2)+' '+nentpr
          @ 4, 1 say 'Склад     : '+str(Skspr, 7)+' '+nSkspr
          @ 5, 1 say 'Назначение:   '+gcNSkl//10
        endif

      case (gnVo=1.or.gnVo=9 .or. gnVo=3)// Поставщики/Возврат от покупателя

        sdf_r:=vsv_r:=rvsv_r:=0
        VesFullSh(mnr,@sdf_r, @vsv_r, @rvsv_r)

        @ 3, 56 say str(sdf_r, 5, 0) color 'g/n,n/g'
        @ 3, 62 say 'Вес:' + str(vsv_r, 5, 0)+'('+str(rvsv_r, 5, 0)+')'+'кг' color 'g/n,n/g'

        if (gnVo=1)       // Изм.возв.
          @ 3, 1 say 'Покупатель:'
        else
          @ 3, 1 say 'Поставщик :  '
        endif

        if (gnVo=1)
          @ 4, 1 say 'Агент     :  '+str(ktar, 4)+'('+str(ktasr, 4)+')'+' '+subs(nktar, 1, 15)
          @ 4, col()+1 say str(prvzr, 1)
        endif

        read
        if (lastkey()=K_ESC)
          loop
        endif

        nkpsr=getfield('t1', 'kpsr', 'kln', 'nkl')
        @ 3, 12 say str(kpsr, 7)+' '+alltrim(nkpsr) + iif(pr1->TtnVz#0, '<-из ТТН ВЗР', '')
        if (gnVo=1.and.gnEnt=21.and.STR(gnSk, 3) $ '238;239;703')//gnSk=238
          @ 5, 1 say 'Грузополучатель :'+' '+subs(nzgr, 1, 24)
        else
          @ 5, 1 say 'Назначение:    '+gcNSkl//10
        endif

        if (gnMSkl=1)
          @ 6, 1 say 'Подотчетник:'
          nSklr=getfield('t1', 'Sklr', 'kln', 'nkl')
          @ 6, 14 say str(Sklr, 7)+' '+alltrim(nSklr)
        else
          if (gnVo=1)
            nzgr=getfield('t1', 'kzgr', 'kln', 'nkl')
            @ 6, 1 say 'ТТН:'+STR(SkVzr, 3)+'_'+str(ttnvzr, 6)+' '+dtoc(dtvzr)+' '+str(nndsvzr, 10)+' '+dtoc(dnnvzr)
            @ 6, 69 say str(nndsr, 10)
          endif

        endif

        if (gnVo=9)
          @ 7, 1 say 'ТТН пост'+' '+ttnpstr
          @ 7, col()+1 say 'от'+' '+dtoc(dttnpstr)
          @ 7, col()+1 say 'Опл'+' '+dtoc(dopr)
          @ 8, 1 say 'НН  пост'+' '+ndspstr
          @ 8, col()+1 say 'Дата'+' '+dtoc(dndspstr)
        endif

      case (gnVo=10)      // Аренда
        if (gnArnd=2)
          @ 3, 1 say 'Владелец:      '
          nkpsr=getfield('t1', 'kpsr', 'kln', 'nkl')
          @ 3, 14 say str(kpsr, 7)+' '+alltrim(nkpsr)
          @ 5, 1 say 'Назначение:    '+gcNSkl//10
          Sklr=gnSkl
        endif

        if (gnArnd=3)     // (Автомат 193)
          @ 3, 1 say 'Владелец:      '
          nkpsr=getfield('t1', 'kpsr', 'kln', 'nkl')
          @ 3, 14 say str(kpsr, 7)+' '+alltrim(nkpsr)
          @ 5, 1 say 'Назначение:    '+gcNSkl//10
          Sklr=gnSkl
        endif

      endcase

    else                    // Автоматический приход
      if (gnKt=0.and.!(kopr=136.or.kopr=137))
        //nopr='Автоматический приход'
        nopr='Автоматичний прибуток'
        @ 2, 14 say str(kopr, 3)+' '+nopr
        @ 3, 1 say 'Источник  : '+alltrim(nSksr)
        mSklsr=getfield('t1', 'Sksr', 'cSkl', 'mSkl')
        if (mSklsr=1)
          nsklsr=getfield('t1', 'sklsr', 'kln', 'nkl')
          @ 4, 1 say 'Подотчетник '+alltrim(nSklsr)
        endif

        if (gnVo=10.and.gnEnt=21)
          nktar=getfield('t1', 'ktar', 's_tag', 'fio')
          @ 4, 1 say 'Агент'+' '+str(ktar, 4)+' '+nktar
        endif

        @ 5, 1 say 'Назначение: '+gcNSkl//10
        if (gnMSkl=1)
          nSklr=getfield('t1', 'Sklr', 'kln', 'nkl')
          @ 6, 1 say 'Подотчетник '+alltrim(nSklr)
        endif

      else
        qr=mod(kopr, 100)
        nopr= getfield('t1', '1,1,gnVo,qr', 'soper', 'nop')
        @ 2, 14 say str(kopr, 3)+' '+nopr
        @ 3, 1 say 'Источник  : '+str(Sksr, 3)+' '+alltrim(nSksr)+' ТТН '+str(amnr, 6)
        if (gnKt=1)
          @ 4, 1 say 'Кому        '+str(Sklr, 7)+' '+getfield('t1', 'Sklr', 'kln', 'nkl')
        else
          @ 4, 1 say 'От кого     '+str(Sklsr, 7)+' '+getfield('t1', 'Sklsr', 'kln', 'nkl')
        endif

        @ 5, 1 say 'Назначение: '+gcNSkl//10
      endif

    endif

  endif

  if (kpsr=20034)
    tarar=0
  else
    tarar=1
  endif

  sele pr1
  if (przn=0.and.prdp())
    netAdd()
    netrepl('kop,Skl,kps,nd,mn,ddc,dvp,kto,nnz,dnz,text,vo,Skt,Sklt,tdc,pvt,kta,prvz',                                              ;
             { kopr, Sklr, kpsr, ndr, mnr, date(), dvpr, gnKto, nnzr, dnzr, textr, gnVo, Sktr, Skltr, time(), pvtr, ktar, prvzr }, 1 ;
          )
    netrepl('docguid', { docguidr }, 1)
    netrepl('rmSk', { gnRmSk }, 1)
    if (tarar=1)
      netrepl('pSt', { 0 }, 1)
    else
      netrepl('pSt', { 1 }, 1)
    endif

    netrepl('katgr', { katgrr }, 1)
    netrepl('dgdtd', { dgdtdr }, 1)
    netrepl('kzg', { kzgr }, 1)
    netrepl('dtmod,tmmod', { date(), time() }, 1)
    netrepl('ktas,kta', { ktasr, ktar }, 1)
    netrepl('Skvz,ttnvz,dtvz', { Skvzr, ttnvzr, dtvzr }, 1)
    netrepl('nnds,nndsvz,dnnvz', { nndsr, nndsvzr, dnnvzr }, 1)
    netrepl('ttnpst,dttnpst,dop,ndspst,dndspst', { ttnpstr, dttnpstr, dopr, ndspstr, dndspstr }, 1)
    if (otvr=4)
      netrepl('Sktp,Skltp,otv', { Sktpr, Skltpr, otvr }, 1)
    endif

  endif

  rcpr1r=recn()
  if (corsh=1.and.prdp()) // Был проход по новому документу
    sele pr1
    pro(10)
    sele pr1
    netrepl('kop,kps,dvp,nnz,dnz,pvt,Skt,Sklt,Skl',                      ;
             { kopr, kpsr, dvpr, nnzr, dnzr, pvtr, Sktr, Skltr, Sklr }, 1 ;
          )
    netrepl('docguid', { docguidr }, 1)
    if (tarar=1)
      netrepl('pSt', { 0 }, 1)
    else
      netrepl('pSt', { 1 }, 1)
    endif

    netrepl('katgr', { katgrr }, 1)
    netrepl('kzg', { kzgr }, 1)
    netrepl('dtmod,tmmod', { date(), time() }, 1)
    netrepl('ktas,kta', { ktasr, ktar }, 1)
    netrepl('Skvz,ttnvz,dtvz', { Skvzr, ttnvzr, dtvzr }, 1)
    netrepl('nnds,nndsvz,dnnvz', { nndsr, nndsvzr, dnnvzr }, 1)
    netrepl('ttnpst,dttnpst,dop,ndspst,dndspst', { ttnpstr, dttnpstr, dopr, ndspstr, dndspstr }, 1)

    if (gnCtov=1.and.NdOtvr=0)
      apcen={ 'ДА ', 'НЕТ' }
      apcenr=alert('Пересчитать цены ?', apcen)
      if (apcenr=1)
        sele pr2
        if (netseek('t1', 'mnr'))
          while (mn=mnr)
            ktlr=ktl
            kfr=kf
            zenr=zen
            bzenr=bzen
            sele tov
            if (netseek('t1', 'Sklr,ktlr'))
              zenr=&coptr
              if (zenr=0)
                zenr=opt
              endif

              optr=opt
              sfr=ROUND(kfr*zenr, 2)
              if (pbzenr=1)
                bzenr=&cboptr
              else
                bzenr=0
              endif

              sele pr2
              if (pbzenr=0)
                netrepl('zen,sf', 'zenr,sfr')
              else
                netrepl('zen,sf,bzen', 'zenr,sfr,bzenr')
              endif

            endif

            sele pr2
            Skip
          enddo

        endif

      endif

      pere(3)
      chkvzt()
    endif

    pere(3)
    chkvzt()
  endif

  @ 5, 43 say ' По закупочным ценам : ' + str(sdvr, 10, 2)
  if (corsh=1)
    corsh=0
  endif

  if (mrshr#0)
    @ 23, 1 say 'Маршрут '+str(mrshr, 6)
  endif

  @ 23, 70 say dtoc(dtmodr)
  esc_r=0
  if (NdOtvr=2)
    netuse('rs1', 'rs1otv')
    netuse('rs2', 'rs2otv')
    sele rs2otv
    set orde to
    go top
    while (!eof())
      if (otv#2)
        Skip
        loop
      endif

      if (AMnP=0)
        netrepl('AMnP', 'mnr')
      endif

      sele rs2otv
      Skip
    enddo

    sele rs2otv
    set orde to tag t5
    if (select('lrs2otv')#0)
      sele lrs2otv
      CLOSE
    endif

    crtt('lrs2otv', 'f:ttn c:n(6) f:ktl c:n(9) f:ktlm c:n(9) f:kol c:n(12,3) f:kolo c:n(12,3) f:rcn c:n(10)')
    sele 0
    use lrs2otv shared
  endif

  while (esc_r=0)

    SELE pr2
    set orde to tag t3
    if (!netseek('t3', 'mnr'))
      go top
    endif

    rcpr2r=recn()
    while (mn=mnr)
      ktlpr=ktlp
      ktlr=ktl
      ktlmr=ktlm
      mntovpr=getfield('t1', 'Sklr,ktlpr', 'tov', 'mntov')
      if (mntovpr#0)
        netrepl('mntovp', 'mntovpr')
      endif

      if (NdOtvr=2)
        postr=getfield('t1', 'Sklr,ktlpr', 'tov', 'post')
        if (postr=kpsr)
          sele rs2otv
          set orde to tag t5
          if (netseek('t5', 'mnr,ktlr,ktlpr'))
            kftor=0
            kfostr=0
            while (AMnP=mnr.and.ktl=ktlr.and.ktlp=ktlpr)
              ttn_r=ttn
              otv_r=otv
              sele rs1otv
              if (netseek('t1', 'ttn_r'))
                kop_r=kop
                dop_r=dop
                dvp_r=dvp
                //                        if prz=0.and.(!empty(dop_r).and.!(kop_r=169.or.kop_r=161.or.kop_r=188).and.dop_r<gdTd.or.;
                //                           empty(dop_r).and.(kop_r=169.or.kop_r=161.or.kop_r=188).and.!empty(dvp_r).and.dvp_r<=gdTd.or.;
                //                           !empty(dop_r).and.(kop_r=169.or.kop_r=161.or.kop_r=188).and.dop_r<=gdTd)
                if (prz=0.and.(!empty(dop_r).and.!(kop_r=169.or.kop_r=161.or.kop_r=188).and.dop_r<date().or.                    ;
                                 empty(dop_r).and.(kop_r=169.or.kop_r=161.or.kop_r=188).and.!empty(dvp_r).and.dvp_r<=date().or. ;
                                 !empty(dop_r).and.(kop_r=169.or.kop_r=161.or.kop_r=188).and.dop_r<=date()                        ;
                              )                                                                                                      ;
                  )
                  if (otv_r=2)
                    sele rs2otv
                    kvp_r=kvp
                    rcn_r=recn()
                    kftor=kftor+kvp_r
                    sele lrs2otv
                    netadd()
                    netrepl('ttn,ktl,ktlm,kol,rcn', 'ttn_r,ktlr,ktlmr,kvp_r,rcn_r')
                  endif

                else
                  if (prz=0)
                    sele rs2otv
                    kvp_r=kvp
                    rcn_r=recn()
                    kfostr=kfostr+kvp_r
                    sele lrs2otv
                    netadd()
                    netrepl('ttn,ktl,ktlm,kolo,rcn', 'ttn_r,ktlr,ktlmr,kvp_r,rcn_r')
                  endif

                endif

                sele rs2otv
                Skip
              endif

            enddo

            sele pr2
            netrepl('kfto,kfc', 'kftor,kfostr')
          endif

        endif

      endif

      sele pr2
      Skip
    enddo

    /************************************************************************** */
    // Открытие CTOVP
    /************************************************************************** */
    if (select('ctovp')#0)
      sele ctovp
      CLOSE
    endif

    sele setup
    locate for setup->kkl7=kpsr
    if (FOUND())
      //         if !empty(cotp)
      //            gnEntp=ent
      //            gcPath_ep=gcPath_m+alltrim(nent)+'\'
      //            gcDir_ep=alltrim(nent)+'\'
      //            gcNentp=alltrim(nent)
      //            gcCotpp=alltrim(cotp) // Отпускная цена Поставщика
      //            gcOptp='opt'+iif(gnEntp<10,'0'+str(gnEntp,1),str(gnEntp,2))
      //            gcDoptp='dopt'+iif(gnEntp<10,'0'+str(gnEntp,1),str(gnEntp,2))
      //            pathr=gcPath_ep
      //            if netfile('ctov','1')
      //               netuse('ctov','ctovp',,1)
      //            endif
      //         else
      gnEntp=0
      gcPath_ep=' '
      gcDir_ep=' '
      gcNentp=' '
      gcCotpp=' '
      gcOptp=' '
      gcDoptp=' '
      gcMntovp=''
      //            pathr=' '
      //            if netfile('ctov','1')
      //               nuse('ctov','ctovp',,1)
      //            endif
    //         endif
    endif

    pr2()
    sele pr2
    if (esc_r=1)
      exit
    endif

    if (NdOtvr=2)
      loop
    endif

    scpr3=savescreen(7, 0, 24, 79)
    while (.t.)           // Денежная часть документа


      if (prZr=0)
        Tbl3Oper()
        pere(2)
        ChkVzt()
      endif

      SELE pr3
      if (!netseek('t1', 'mnr,90'))
        netadd()
        netrepl('mn,ksz', 'mnr,90')
      endif

      sele pr3
      netseek('t1', 'mnr')
      rcPr3r=recn()
      if (prZr=0)
        if (Who<>1.and.tarar=1.and.pStr=0)
          foot('INS,DEL,F4,F5,F6,F9', 'Доб.,Удалить,Корр.,Стекл.возв.,Просчет108(107),Итоги')
          dispbox(1, 64, 3, 77, 1, "gr+/n")
          @2, 65 say 'С/Т ВОЗВР' color 'gr+/n'
        endif

        if (Who<>1.and.tarar=1.and.pStr=1)
          foot('INS,DEL,F4,F5,F6,F9', 'Доб.,Удалить,Корр.,Стекл.невозв.,Просчитать 108,Итоги')
          dispbox(1, 64, 3, 77, 1, "gr+/n")
          @2, 65 say 'С/Т НЕ ВОЗВР' color 'gr+/n'
        endif

        if ((Who=2.or.Who=3.or.Who=4).and.tarar=0).or.who=1
          foot('INS,DEL,F4,F9', 'Доб.,Удалить,Корр.,Итоги')
        endif

      else
        foot('F9', 'Итоги')
      endif

      sele pr3
      set orde to tag t1
      kszr=slcf('pr3',,,,, "e:ksz h:'Код' c:n(2,0) e:getfield('t1','pr3->ksz','dclr','nz') h:'Наименование' c:c(20) e:pr h:'Проц.'c:n(5,2) e:ssf h:'Сумма' c:n(12,2)", 'ksz', 0, 1, 'mn=mnr')
      do case
      case (lastkey()=K_ESC)// Выход
        esc_r=1
        exit
      case (lastkey()=K_F9) // Итоги
        exit
      case (lastkey()=K_INS.and.prZr=0.and.prdp())// Добавить
        Tbl3Oper()
      case (lastkey()=K_F4.and.prZr=0.and.prdp())// Коррекция
        pr3ssf()
        pere(2)
        chkvzt()
      case (lastkey()=K_F6.and.prZr=0.and.vor=1.and.prdp())// Просчитать 108
        If str(kopr,3) $ '107;108'
          if (pr1->ttnvz#0)
            pr3108({||vor=1.and.(str(kopr,3) $ '107;108').and.prZr=0})
          else
            wmess('Нет ссылки на ТТН', 2)
          endif
        EndIf

      case (lastkey()=K_DEL.and.prZr=0.and.prdp())// Удалить
        sele dclr
        if (netseek('t1', 'kszr'))
          if (pr=0)
            sele pr3
            if (netseek('t1', 'mnr,kszr'))
              netdel()
              prModr=1
            endif

          endif

        endif

        sele pr3
      case (lastkey()=K_F5.and.tarar=1.and.prdp())
        sele pr1
        if (netseek('t2', 'mnr'))
          iif(pSt=0, netrepl('pSt', { 1 }, 1), netrepl('pSt', { 0 }, 1))
          prModr=1
          pStr=pSt
        endif

      endcase

    enddo

    restscreen(7, 0, 24, 79, scpr3)
    if (prZr=0)
      pere(3)
      chkvzt()
    endif

    if (esc_r=1)
      exit
    endif

    while (.t.)           // Итог документа
      if (gnSpech=1 .or. gnAdm=1)
        if (prZr=0)
          foot('F2,F3,F4,F5,F6,F7,F8,F9,F10', 'Грузч,Печ.цен,СПеч,ЛПеч,Подтв,НДС,Корр.шап,Товар,ТТН.воз')
        else
          if (gnVo=1.or.gnVo=2)
            foot('F3,F4,F5,F7,F9', 'Печ.цен,СПеч,Печать,НДС,Товар')
          else
            foot('F3,F4,F5,F9', 'Печ.цен,СПеч,Печать,Товар')
          endif

        endif

      else
        if (prZr=0)
          foot('F2,F3,F5,F8,F9', 'Грузчики,Печ.цен,Печать,Корр.шапки,Товар')
        else
          foot('F3,F5,F9', 'Печ.цен,Печать,Товар')
        endif

      endif

      inkey(0)
      do case
      case (lastkey()=K_F2)// Грузчики
        clgrur=setcolor('gr+/b,n/bg')
        wgrur=wopen(10, 20, 14, 60)
        wbox(1)
        while (.t.)
          @ 0, 1 say 'Начало' get hngr pict '99' range 0, 23
          @ 0, col()+1 say 'чч' get mngr pict '99' range 0, 59
          @ 0, col()+1 say 'мм'
          @ 1, 1 say 'Оконч.' get hogr pict '99' range 0, 23
          @ 1, col()+1 say 'чч' get mogr pict '99' range 0, 59
          @ 1, col()+1 say 'мм'
          read
          if (lastkey()=K_ESC)
            exit
          endif

          sele pr1g
          netseek('t1', 'mnr')
          wselect(0)
          while (.t.)
            sele pr1g
            foot('INS,DEL', 'Добавить,Удалить')
            rcpr1gr=SLCf('pr1g',, 5,,, "e:kgru h:'Код' c:n(7) e:getfield('t1','pr1g->kgru','gru','ngru') h:'Ф.И.О' c:c(15)",,,, 'mn=mnr',,, 'Грузчики')
            go rcpr1gr
            do case
            case (lastkey()=K_ESC.or.lastkey()=K_ENTER)
              exit
            case (lastkey()=K_INS)// Добавить
              sele gru
              go top
              rcgrur=SLCf('gru',, 45,,, "e:kgru h:'Код' c:n(7) e:ngru h:'Ф.И.О' c:c(15)")
              go rcgrur
              kgrur=kgru
              do case
              case (lastkey()=K_ENTER)
                sele pr1g
                if (!netseek('t1', 'mnr,kgrur'))
                  netadd()
                  netrepl('mn,kgru', 'mnr,kgrur')
                endif

              endcase

            case (lastkey()=K_DEL)// Удалить
              netdel()
              Skip -1
              if (bof())
                if (!netseek('t1', 'mnr'))
                  go top
                endif

              endif

            endcase

          enddo

          wselect(wgrur)
          @ 2, 1 prom 'Верно'
          @ 2, col()+1 prom 'Не Верно'
          menu to mpgrur
          if (mpgrur=1)
            sele pr1
            netrepl('hng,mng,hog,mog', 'hngr,mngr,hogr,mogr', 1)
            exit
          endif

        enddo

        wclose(wgrur)
        setcolor(clgrur)
      case (lastkey()=K_F3)//печать цен
        prce=.t.
        pechcen()
        prce=.f.
      case (lastkey()=K_F4 .and.(gnSpech=1 .or. gnAdm=1))// Печать сетевая
        prprn(2)
      case (lastkey()=K_F5)// Печать локальная
        prprn(1)
      case (lastkey()=K_F6.and.prZr=0.and.prdp())// Подтверждение
        if (!(month(gdTd)=month(date()).and.year(gdTd)=year(date())))
          ach:={ 'Нет', 'Да' }
          achr=0
          achr=alert('Это не текущий месяц.Продолжить?', ach)
          if (achr#2)
            loop
          endif

        endif

        if (gnEntrm=0.and.pr1->rmSk#0.or.gnEntrm=1.and.pr1->rmSk=0)
          wmess('Чужой документ НИЗЗЯ!!!', 3)
        else
          PFakt()
        endif

      case (lastkey()=K_F7 .and. (gnVo=1 .or. gnVo=2) .and. (gnSpech=1 .or.gnAdm=1))// НДС
        sel=select()
        pcor=2
        d0k1r=gnD0k1
        Skr=gnSk
        kklr=kpsr
        ttnr=mnr
        sele kln
        if (netseek('t1', 'kklr'))
          if (!empty(nklprn))
            nklr=alltrim(nklprn)
          else
            nklr=alltrim(nkl)
          endif

          adrr=adr
          tlfr=tlf
          nnr=nn
          cnnr=cnn
          nsvr=nsv
          kkl1r=kkl1
        else
          nklr='Вiдсутнiй в довiднидку'
          store '' to adrr, tlfr, nsvr
          nnr=0
          cnnr=''
        endif

        nomndsr=pr1->nnds
        if (bom(gdTd)<ctod('01.03.2011'))
          netuse('nds')
          sele nds
          set orde to tag t3
          if (netseek('t3', 'Skr,mnr,d0k1r'))
            nomndsr=nomnds
            if (ttnvzr#0)
              nndsr=nomndsr
              nomndsvzr=getfield('t3', 'gnSk,ttnvzr,0', 'nds', 'nomnds')
              dnnvzr=getfield('t3', 'gnSk,ttnvzr,0', 'nds', 'dnn')
              netrepl('nomndsvz,dnnvz,ttnvz', 'nomndsvzr,dnnvzr,ttnvzr')
            endif

          else
            sele setup
            locate for ent=gnEnt
            reclock()
            nomndsr=nnds
            sele nds
            set orde to tag t1
            while (.t.)
              if (netseek('t1', 'nomndsr'))
                nomndsr=nomndsr+1
                loop
              endif

              sele setup
              netrepl('nnds', 'nomndsr+1')
              exit
            enddo

            sele nds
            netadd()
            netrepl('nomnds,ttn,dnn,Sk,sum,kkl,d0k1,rmSk',         ;
                     'nomndsr,ttnr,dvpr,Skr,sdvr,kklr,d0k1r,gnRmSk' ;
                  )
            if (ttnvzr#0)
              nndsr=nomnds
              nomndsvzr=getfield('t3', 'gnSk,ttnvzr,0', 'nds', 'nomnds')
              dnnvzr=getfield('t3', 'gnSk,ttnvzr,0', 'nds', 'dnn')
              netrepl('nomndsvz,dnnvz,ttnvz', 'nomndsvzr,dnnvzr,ttnvzr')
            endif

          endif

          sele nds
          set orde to tag t1
          prnnr=1
          pnnv()
          sele pr1
          if (nnds=0.and.nomndsr#0)
            netrepl('nnds', 'nomndsr', 1)
          endif

        else
          if (pr1->dpr<ctod('16.12.2011'))
            prnnn(0, 0, gnSk, ndr, mnr)
          else
            if (pr1ndsr=0)
              prnds(0, 0, gnSk, ndr, mnr)
            else
              wmess('Только из Финансиста!', 2)
            endif

          endif

          //                     sele nnds
          //                     if netseek('t2','0,0,Skr,ndr,mnr')
          //                        nomndsr=nnds
          //                        nomndsvzr=nndsp
          //                        dnnvzr=dnnp
          //                        prnnr=1
          //                        pnnv()
          //                        sele pr1
          //                        if nnds=0.and.nomndsr#0
          //                           netrepl('nnds','nomndsr',1)
          //                        endif
        //                     endif
        endif

        select(sel)
      case (lastkey()=K_F8.and.(prZr=0.and.who#1.or.uprlr=gcSprl).and.prdp().and.vor#6)// Коррекция шапки
        if (Sksr=0.and.Skspr=0)
          corsh=1
          esc_r=1
          exit
        endif

      case (lastkey()=K_F9)// Товар
        exit
      case (lastkey()=K_F10.and.gnAdm=1)// Печ ттн возврат
        set cons off
        set prin off
        set prin to
        set prin to prrsvz.txt
        set prin on
        ??chr(27)+'E'+chr(27)+'&l4h25a0O'+chr(27)+'&k2S'+chr(27)+'(3R'+chr(27)+'(s0p18.00h0s1b4102T'+chr(27)
        PrnPrRs()
        set prin off
        set prin to
        set cons on
      case (lastkey()=K_ESC)            // Закончить
        if (przn=0)
        endif

        esc_r=1
        exit
      endcase

    enddo

    if (prModr=1)
      sele pr1
      netrepl('dtmod,tmmod', 'date(),time()')
    endif

  enddo

  nuse('rs1otv')
  nuse('rs2otv')
  if (prVzznr=1)
    sele pr2
    set orde to tag t1
    if (netseek('t1', 'mnr'))
      while (mn=mnr)
        if (zenttn=zenpr)
          netdel()
        endif

        sele pr2
        Skip
      enddo

    endif

  endif

enddo

unlock all
nuse()
nuse('tovsrt')
nuse('ctovp')
return

/***********************************************************
 * prprn
 *   Параметры:
 */
procedure prprn()           // Печать
  para p1
  /*p1=1 Локальная печать
   *p1=2 Сетевая печать
   */
  kk=1
  kkr=1
  psp=1
  @ 24, 0 clea
  @ 24, 1 say '= ' get textr
  read
  if (lastkey()=K_ESC)
    return
  endif

  sele pr1
  if (netseek('t1', 'ndr'))
    netrepl('text', 'textr', 1)
  endif

  @ 24, 0 clear

  ccp=1
  @ 24, 5 prompt' ПРОСМОТР '
  @ 24, 25 prompt'  ПЕЧАТЬ  '
  menu to ccp
  @ 24, 0 clea

  SELE kln
  if (netseek('t1', 'kpsr'))
    Tlfr = TLF
  else
    Tlfr = ''
  endif

  @ 24, 15 say 'ЖДИТЕ РАБОТАЕТ ПЕЧАТЬ'
  if (ccp = 1)
    set prin to
    Set Prin to txt.txt
  else
    /*************** */
    if (p1=1)
      if (gnOut=1)
        if (gnEnt=21)
          set prin to lpt2
        else
          set prin to lpt1
        endif

      else
        set prin to txt.txt
      endif

      if (gnVttn=1)
        kk=2
        kkr=1               // Счетчик экземпляров
        psp=2               // Признак сетевой печати для печати шапки
        @ 24, 40 say 'Количество  экз.'
        @ 24, 52 get kk pict '9' valid kk<4
        read
      endif

    else
      //     @ 24,0 say 'ПЕЧАТЬ НА СЕТЕВОЙ ПРИНТЕР           '
      vlpt1='lpt2'
      alpt={ 'lpt2', 'lpt3' }
      vlpt=alert('ПЕЧАТЬ НА СЕТЕВОЙ ПРИНТЕР', alpt)
      if (vlpt=1)
        vlpt1='lpt2'
      else
        vlpt1='lpt3'
      endif

      kk=2
      kkr=1                 // Счетчик экземпляров
      psp=2                 // Признак сетевой печати для печати шапки
      @ 24, 40 say 'Количество  экз.'
      @ 24, 52 get kk pict '9' valid kk<4
      read
      set prin to &vlpt1
    endif

  /*************** */
  endif

  set cons off
  set prin on
  set devi to print
  if (p1=1)
    //   if gnEnt=14
    //      apr={'Epson','HP'}
    //      vpr=alert('Выбор принтера',apr)
    //      if empty(gcPrn)
    //         ??chr(27)+chr(80)+chr(15)
    //      else
    //         ??chr(27)+'E'+chr(27)+'&l4h2a0O'+chr(27)+'&k2S'+chr(27)+'&a20l'+chr(27)+'(3R'+chr(27)+'(s0p17.00h0s0b4099T'+chr(27)
    //      endif
    //   else
    if (empty(gcPrn))
      ??chr(27)+chr(80)+chr(15)
    else
      ??chr(27)+'E'+chr(27)+'&l4h25a0O'+chr(27)+'&k2S'+chr(27)+'(3R'+chr(27)+'(s0p18.00h0s1b4102T'+chr(27)
    //         ??chr(27)+'E'+chr(27)+'&l4h2a0O'+chr(27)+'&k2S'+chr(27)+'&a20l'+chr(27)+'(3R'+chr(27)+'(s0p17.00h0s0b4099T'+chr(27)
    endif

  //   endif
  else
    //   if gnEnt=14
    //      ??chr(27)+'E'+chr(27)+'&l4h2a0O'+chr(27)+'&k2S'+chr(27)+'&a20l'+chr(27)+'(3R'+chr(27)+'(s0p17.00h0s0b4099T'+chr(27)
    //   else
    ??chr(27)+'E'+chr(27)+'&l4h25a0O'+chr(27)+'&k2S'+chr(27)+'(3R'+chr(27)+'(s0p18.00h0s1b4102T'+chr(27)
    //      ??chr(27)+'E'+chr(27)+'&l4h2a0O'+chr(27)+'&k2S'+chr(27)+'&a20l'+chr(27)+'(3R'+chr(27)+'(s0p17.00h0s1b4102T'+chr(27)
  //   endif
  endif

  while (kkr<=kk)
    pechpr()
    kkr=kkr+1
  enddo

  set prin off
  set print to
  set cons on
  set devi to scre
  @ 24, 0 clea
  /*unlock */
  return

/***********************************************************
 * ndw() -->
 *   Параметры :
 *   Возвращает:
 */
function ndw()
  Skndr=savesetkey()
  set key K_SPACE to nd
  return (.t.)

/***********************************************************
 * ndv() -->
 *   Параметры :
 *   Возвращает:
 */
function ndv()
  set key K_SPACE to
  restsetkey(Skndr)
  return (.t.)

/***********************************************************
 * nd() -->
 *   Параметры :
 *   Возвращает:
 */
function nd()
  local getList:={}
  while (.t.)
    sele pr1
    go top
    foot('F3', 'Фильтр')
    set cent off
    if (at('otv=3', ForNdr)=0)
      if (gnKt=0)
        if (gnVo=9)
          rcpr1r=slcf('pr1', 1,, 18,, "e:nd h:'N док.' c:n(6) e:ttnpst h:'ТТНпст' c:c(8) e:prz h:'П' c:n(1) e:kop h:'КОП' c:n(3) e:dvp h:'Дата В' c:d(8) e:dpr h:'Дата П' c:d(8) e:sdv h:'Сумма' c:n(10,2) e:getfield('t1','pr1->kps','kln','nkl') h:'Поставщик' c:c(16) e:getfield('t1','pr1->kto','speng','fio') h:'Товаровед' c:c(9)",,,,, ForNdr)
        else
          rcpr1r=slcf('pr1', 1,, 18,, "e:nd h:'N док.' c:n(6) e:iif(entp#0,AMnP,amn) h:' ТТН  ' c:n(6) e:prz h:'П' c:n(1) e:kop h:'КОП' c:n(3) e:dvp h:'Дата В' c:d(8) e:dpr h:'Дата П' c:d(8) e:sdv h:'Сумма' c:n(10,2)";
          +" e:getfield('t1','pr1->kps','kln','nkl') h:'Поставщик' c:c(16) e:getfield('t1','pr1->kto','speng','fio') h:'Товаровед' c:c(11)",,,,, ForNdr)
        endif

      else
        rcpr1r=slcf('pr1', 1,, 18,, "e:nd h:'N док.' c:n(6) e:mn h:'MN' c:n(6) e:Sks h:'Скл' c:n(3) e:amn h:' ТТН  ' c:n(6) e:prz h:'П' c:n(1) e:kop h:'КОП' c:n(3) e:dpr h:'Дата П' c:d(8) e:sdv h:'Сумма' c:n(10,2) e:Skl h:'КодК' c:n(7) e:getfield('t1','pr1->Skl','kln','nkl') h:'Комиссионер' c:c(16) ",,,,, ForNdr)
      endif
    else
      // for VesFullSh
      Sklr=gnSkl
      sdf_r:=vsv_r:=rvsv_r:=0

      rcpr1r=slcf('pr1', 1,, 18,, "e:nd h:'N док.' c:n(6) e:ttnpst h:' ТТНпст' c:c(20) e:prz h:'П' c:n(1) e:dvp h:'Дата В' c:d(8) e:dpr h:'Дата П' c:d(8)";
      +" e:sdv h:'Сумма' c:n(10,2)";
      +" e:pr2->(VesFullSh(pr1->mn, sdf_r, vsv_r, rvsv_r)) h:'Объем' c:n(5,0)";
      +" e:getfield('t1','pr1->kps','kln','nkl') h:'Поставщик' c:c(16) e:getfield('t1','pr1->kto','speng','fio') h:'Товаровед' c:c(11)",,,,, ForNdr)
    endif
    set cent on

    if (lastkey()=K_F3)
      clndr=setcolor('gr+/b,n/bg')
      wndr=wopen(10, 20, 20, 60)
      wbox(1)
      @ 0, 1 say 'Период    ' get nddt1r
      @ 0, col()+1 get nddt2r
      @ 1, 1 say 'Признак   ' get ndprZr pict '9'
      @ 1, col()+1 say ' 2 - Все'
      @ 2, 1 say 'Поставщик' get ndkpsr pict '9999999'
      @ 3, 1 say 'Код опер.' get ndkopr pict '999'
      read
      if (!empty(nddt1r))
        if (empty(nddt2r))
          ForNdr=fornd_r+'.and.dvp=nddt1r'
        else
          ForNdr=fornd_r+'.and.dvp>=nddt1r.and.dvp<=nddt2r'
        endif

      endif

      if (ndprzr#2)
        ForNdr=ForNdr+'.and.prz=ndprzr'
      endif

      if (ndkpsr#0)
        ForNdr=ForNdr+'.and.kps=ndkpsr'
      endif

      if (ndkopr#0)
        ForNdr=ForNdr+'.and.kop=ndkopr'
      endif

      wclose(wndr)
      setcolor(clndr)
    elseif (lastkey()=K_ALT_F6)
      // 03-24-17 05:49pm
      // простчет док-тов возвра 108 в ценах покупателя
      sele pr1
      go top
      while (!eof())
        mnr=mn
        vor=vo; kopr=kop; prZr=prz
        pr3108({||vor=1.and.(str(kopr,3) $ '107;108').and.prZr=1.and.gnAdm=1})
        //pr3108({||vor=1.and.kopr=108.and.prZr=1.and.gnAdm=1})

        sele pr1
        DBSkip()
      enddo

    else
      exit
    endif

  enddo

  sele pr1
  go rcpr1r
  ndr=nd
  set key K_SPACE to
  return (.t.)

/***********************************************************
 * kpSkln() -->
 *   Параметры :
 *   Возвращает:
 */
function kpSkln()
  sele kln
  if (!netseek('t1', 'kpsr'))
    sele kln
    go top
  endif

  kklr=kpsr
  kpsr=slct_kl(10, 1, 12)
  if (kpsr=0)
    return (.f.)
  else
    kkl1r=getfield('t1', 'kpsr', 'kln', 'kkl1')
    if (kkl1r=0)
      wmess('Это не юридическое лицо', 2)
      return (.f.)
    endif

  endif

  if (NdOtvr=4)
    sele pr1
    set orde to tag t3
    if (!netseek('t3', '1,kpsr'))
      wmess('Нет склада отв хр', 2)
      return (.f.)
    else
      otvr=4
      Sktpr=Sksp
      Skltpr=Sklsp
    endif

    set orde to tag t1
  endif

  return (.t.)

/***********************************************************
 * ctovopt() -->
 *   Параметры :
 *   Возвращает:
 */
function ctovopt
  if (optr=0.and.int(mntovr/10000)#0)
    return (.f.)
  endif

  return (.t.)

/***********************************************************
 * prsert() -->
 *   Параметры :
 *   Возвращает:
 */
function prsert()
  sele sert
  if (ksertr#0)
    if (!netseek('t5', 'izgr,ksertr'))
      ksertr=0
    endif

  endif

  if (ksertr=0)
    set orde to tag t3
    if (netseek('t3', 'izgr'))
      wselect(0)
      while (.t.)
        rcsertr=SLCf('sert',,, 10,, "e:ksert h:'Код' c:n(6) e:nsert h:'Сертификат' c:c(20) e:nprod h:'Продукция' c:c(40)",,,,, 'izg=izgr')
        sele sert
        go rcsertr
        ksertr=ksert
        nsertr=nsert
        nprodr=nprod
        do case
        case (lastkey()=K_ESC)
          exit
        case (lastkey()=K_ENTER)
          exit
        endcase

      enddo

      wselect(wsertr)
      @ 0, 21 say nsertr
    endif

  endif

  return (.t.)

/***********************************************************
 * prkach() -->
 *   Параметры :
 *   Возвращает:
 */
function prkach()
  sele ukach
  if (kukachr#0)
    if (!netseek('t3', 'ksertr,izgr,kukachr'))
      kukachr=0
    endif

  endif

  if (kukachr=0)
    set order to tag t3
    if (netseek('t3', 'ksertr,izgr'))
      wselect(0)
      while (.t.)
        rcukachr=SLCf('ukach',,, 10,, "e:kukach h:'Код' c:n(6) e:nukach h:'Уд.качества' c:c(60) e:dtukach h:'Дата' c:d(10)",,,, 'ksert=ksertr', 'izg=izgr')
        sele ukach
        go rcukachr
        kukachr=kukach
        nukachr=nukach
        dtukachr=dtukach
        do case
        case (lastkey()=K_ESC)
          exit
        case (lastkey()=K_ENTER)
          exit
        endcase

      enddo

      wselect(wsertr)
      @ 1, 21 say dtukachr
    endif

  endif

  return (.t.)

/************* */
function PrTtn()
  /************* */
  if (!empty(Skvzr))
    cPthSkVz:=alltrim(getfield('t1', 'Skvzr', 'cSkl', 'path'))
  else
    cPthSkVz:=gcDir_t
  endif

  if (ttnvzr#0)
    if (!empty(dtvzr))
      pathr=gcPath_e + pathYYYYMM(dtvzr)+ '\' + cPthSkVz
      if (!netfile('rs1', 1))
        wmess('Нет '+pathr+'rs1', 3)
        return (.t.)
      else
        netuse('rs1', 'rs1vz',, 1)
        if (!netseek('t1', 'ttnvzr'))
          wmess('Не найдена ТТН '+str(ttnvzr, 6), 3)
          return (.t.)
        else
          netuse('rs2', 'rs2vz',, 1)
          netuse('tov', 'tovvz',, 1)
          netuse('tovm', 'tovmvz',, 1)
          PrTtnI()
          nuse('rs2vz')
          nuse('tovvz')
          nuse('tovmvz')
        endif

        nuse('rs1vz')
      endif

    else
      dtvzr=ctod('')
    endif

    if (empty(dtvzr))
      for yyr=year(gdTd) to 2006 step -1
        do case
        case (yyr=year(gdTd))
          mm1r=month(gdTd)
          mm2r=1
        case (yyr=2006)
          mm1r=12
          mm2r=9
        otherwise
          mm1r=12
          mm2r=1
        endcase

        for mmr=mm1r to mm2r step -1
          cdtvzr='01.'+iif(mmr<10, '0'+str(mmr, 1), str(mmr, 2))+'.'+str(yyr, 4)
          dtvzr=ctod(cdtvzr)
          pathr=gcPath_e + pathYYYYMM(dtvzr) + '\' + cPthSkVz
          if (!netfile('rs1', 1))
            loop
          endif

          netuse('rs1', 'rs1vz',, 1)
          if (netseek('t1', 'ttnvzr'))
            netuse('rs2', 'rs2vz',, 1)
            netuse('tov', 'tovvz',, 1)
            netuse('tovm', 'tovmvz',, 1)
            PrTtnI()
            nuse('rs2vz')
            nuse('tovvz')
            nuse('tovmvz')
            prttnvzr=1
            exit
          endif

          nuse('rs1vz')
        next

        if (prttnvzr=1)
          exit
        endif

      next

    endif

  endif

  return (.t.)

/*****************************************************************
 
 FUNCTION:
 АВТОР..ДАТА..........С. Литовка  02-10-17 * 12:29:02pm
 НАЗНАЧЕНИЕ......... вставка данных из ТТН возварата
 ПАРАМЕТРЫ..........
 ВОЗВР. ЗНАЧЕНИЕ....
 ПРИМЕЧАНИЯ.........
 */
function PrTtnI()
  sele rs2vz
  if (netseek('t1', 'ttnvzr'))
    while (ttn=ttnvzr)
      mntovr=mntov
      ktlr=ktl
      pptr=ppt
      mntovpr=mntovp
      ktlpr=ktlp
      kfr=kvp
      zenr=getfield('t1', 'Sklr,ktlr', 'tovvz', 'opt')
      ozenr=zen
      sfr=roun(zenr*kfr, 2)
      sele tov
      if (!netseek('t1', 'Sklr,ktlr'))
        sele tovvz
        if (netseek('t1', 'Sklr,ktlr'))
          arec:={}
          getrec()
          sele tov
          netadd()
          putrec()
          netrepl('osn,osv,osf,osfo,osvo', '0,0,0,0,0')
        endif

      endif

      sele tovm
      if (!netseek('t1', 'Sklr,mntovr'))
        sele tovmvz
        if (netseek('t1', 'Sklr,mntovr'))
          arec:={}
          getrec()
          sele tovm
          netadd()
          putrec()
          netrepl('osn,osv,osf,osfo,osvo', '0,0,0,0,0')
        endif

      endif

      sele pr2
      if (!netseek('t3', 'mnr,ktlpr,pptr,ktlr'))
        netadd()
        if (prVzznr=0)
          netrepl('mn,mntov,ktl,ppt,mntovp,ktlp,kf,zen,ozen,sf', 'mnr,mntovr,ktlr,pptr,mntovpr,ktlpr,kfr,zenr,ozenr,sfr')
        else
          netrepl('mn,mntov,ktl,ppt,mntovp,ktlp,kf,zen,ozen,sf,kfttn,zenttn,zenpr', ;
                   'mnr,mntovr,ktlr,pptr,mntovpr,ktlpr,0,0,0,0,kfr,ozenr,ozenr'      ;
                )
        endif

      endif

      sele rs2vz
      Skip
    enddo

  else
    wmess('ТТН '+str(ttnvzr, 6)+' нет товара', 3)
  endif

  return (.t.)

/*************** */
function pr1nds()
  /*************** */
  crtt('tmn1vz', "f:Sk c:n(3) f:ttn c:n(6) f:mn c:n(6)")
  sele 0
  use tmn1vz excl
  crtt('tmn2vz', "f:ktl c:n(9) f:kf c:n(12,3)")
  sele 0
  use tmn2vz excl
  crtt('tttnvz', "f:Sk c:n(3) f:ttn c:n(6) f:ktl c:n(9) f:zen c:n(12,3) f:kvp c:n(12,3) f:prvzzn c:n(1)")
  sele 0
  use tttnvz excl
  /*inde on str(Sk,3)+str(ttn,6)+str(ktl,9)+str(zen,12,3) tag t1 */
  sele cSkl
  go top
  while (!eof())
    if (ent#gnEnt)
      Skip
      loop
    endif

    if (rasc#1)
      Skip
      loop
    endif

    Skr=Sk
    pathr=gcPath_d+alltrim(path)
    nuse('rs1vz')
    nuse('rs2vz')
    nuse('pr1vz')
    nuse('pr2vz')
    nuse('tovvz')
    netuse('rs1', 'rs1vz',, 1)
    netuse('rs2', 'rs2vz',, 1)
    netuse('pr1', 'pr1vz',, 1)
    netuse('pr2', 'pr2vz',, 1)
    netuse('tov', 'tovvz',, 1)
    netuse('tovm', 'tovmvz',, 1)
    sele rs1vz
    set orde to tag t7
    if (netseek('t7', 'nndsvzr'))
      while (nnds=nndsvzr)
        if (prz=0)
          Skip
          loop
        endif

        sele rs1vz
        ttnvzr=ttn
        if (.f.)
#ifndef __CLIP

            sele tmn2vz
            zap

            sele pr1vz
            set filt to ttnvz=ttnvzr
            go top
            while (!eof())
              if (prz=1)
                mn_r=mn
                sele tmn1vz
                appe blank
                repl ttn with ttnvzr, ;
                 mn with mn_r
                sele pr2vz
                set orde to tag t1
                if (netseek('t1', 'mn_r'))
                  while (mn=mn_r)
                    ktl_r=ktl
                    kf_r=kf
                    sele tmn2vz
                    locate for ktl=ktl_r
                    if (!foun())
                      appe blank
                      repl ktl with ktl_r
                    endif

                    repl kf with kf+kf_r
                    sele pr2vz
                    Skip
                  enddo

                endif

              endif

              sele pr1vz
              Skip
            enddo

#endif
        endif

        sele rs1vz
        prndsi()
        sele rs1vz
        Skip
      enddo

    endif

    nuse('rs1vz')
    nuse('rs2vz')
    nuse('pr1vz')
    nuse('pr2vz')
    nuse('tovvz')
    nuse('tovmvz')
    sele cSkl
    Skip
  enddo

  sele tmn1vz
  CLOSE
  /*erase tmn1vz.dbf */
  sele tmn2vz
  CLOSE
  /*erase tmn2vz.dbf */
  sele tttnvz
  CLOSE
  /*erase tttnvz.dbf */
  return (.t.)

/************** */
function prndsi()
  /************** */
  sele rs2vz
  if (netseek('t1', 'ttnvzr'))
    while (ttn=ttnvzr)
      mntovr=mntov
      ktlr=ktl
      pptr=ppt
      mntovpr=mntovp
      ktlpr=ktlp
      kfr=kvp
      kftor=kvp
      kvp_r=kvp
      zen_r=zen
      /*
            sele tmn2vz
            locate for ktl=ktlr
            if foun()
               kf_r=kf
            else
               kf_r=0
            endif
            if kfr-kf_r>=0
               kfr=kfr-kf_r
            endif
      */
      sele rs2vz
      if (kfr>0)
        zenr=getfield('t1', 'Sklr,ktlr', 'tovvz', 'opt')
        ozenr=zen
        sfr=roun(zenr*kfr, 2)
        sele tov
        if (!netseek('t1', 'Sklr,ktlr'))
          sele tovvz
          if (netseek('t1', 'Sklr,ktlr'))
            arec:={}
            getrec()
            sele tov
            netadd()
            putrec()
            netrepl('osn,osv,osf,osfo,osvo', '0,0,0,0,0')
          endif

        endif

        sele tovm
        if (!netseek('t1', 'Sklr,mntovr'))
          sele tovmvz
          if (netseek('t1', 'Sklr,mntovr'))
            arec:={}
            getrec()
            sele tovm
            netadd()
            putrec()
            netrepl('osn,osv,osf,osfo,osvo', '0,0,0,0,0')
          endif

        endif

        sele tttnvz
        netadd()
        netrepl('Sk,ttn,ktl,zen,kvp,prvzzn', 'Skr,ttnvzr,ktlr,zen_r,kvp_r,prVzznr')
        sele pr2
        if (!netseek('t7', 'mnr,ktlr,ozenr'))
          netadd()
          if (prVzznr=0)
            netrepl('mn,mntov,ktl,ppt,mntovp,ktlp,kf,zen,ozen,sf',          ;
                     'mnr,mntovr,ktlr,pptr,mntovpr,ktlpr,kfr,zenr,ozenr,sfr' ;
                  )
          else
            netrepl('mn,mntov,ktl,ppt,mntovp,ktlp,kf,zen,ozen,sf,kfttn,zenttn,zenpr,kfto', ;
                     'mnr,mntovr,ktlr,pptr,mntovpr,ktlpr,0,0,0,0,kfr,ozenr,ozenr,kftor'     ;
                  )
          endif

        else
          if (prVzznr=0)
            netrepl('kf,sf', 'kf+kfr,sf+sfr')
          else
            netrepl('kfttn,kfto', 'kfttn+kfr,kfto+kftor')
          endif

        endif

      endif

      sele rs2vz
      Skip
    enddo

  else
    wmess('ТТН '+str(ttnvzr, 6)+' нет товара', 3)
  endif

  return (.t.)

/************ */
function pdsp()
  /************ */
  Skr=gnSk
  rmSkr=gnRmSk
  proplr=0
  clrdsp=setcolor('gr+/b,n/bg')
  wrdsp=wopen(10, 14, 19, 70)
  wbox(1)
  while (.t.)
    @ 1, 1 say 'Создан     '+' '+dtoc(pr1->ddc)+' '+pr1->tdc
    @ 2, 1 say 'Выписан    '+' '+dtoc(pr1->dvp)
    @ 3, 1 say 'Подтвержден'+' '+dtoc(pr1->dpr)+' '+pr1->tpr
    @ 4, 1 say 'Модификация'+' '+dtoc(pr1->dtmod)+' '+pr1->tmmod
    inkey(0)
    if (lastkey()=K_ESC)
      exit
    endif

  enddo

  wclose(wrdsp)
  setcolor(clrdsp)
  return (.t.)

/*************** */
function pr3108(bFor)
  /*************** */
  store 0 to ssf40r, ssf11r, ssf90r, ssf10r
  if (EVAL(bFor))       //vor=1.and.kopr=108.and.prZr=0 //.and.gnAdm=1
    sele pr2
    if (netseek('t1', 'mnr'))
      while (mn=mnr)
        if (ozen#0)
          ssf10r=ssf10r+roun(kf*ozen, 2)
          ssf40r=ssf40r+roun(kf*ozen, 2)-roun(kf*zen, 2)
        endif

        sele pr2
        Skip
      enddo

      if (ssf10r#0)
        ssf90r=roun(ssf10r*1.2, 2)
        ssf11r=roun(ssf10r*0.2, 2)

        sele pr3
        if (!netseek('t1', 'mnr,40'))
          netadd(); netrepl('mn,ksz', { mnr, 40 })
        endif

        netrepl('ssf', { ssf40r })

        if (!netseek('t1', 'mnr,11'))
          netadd(); netrepl('mn,ksz', { mnr, 11 })
        endif

        netrepl('ssf', { ssf11r })

        if (netseek('t1', 'mnr,90'))
          netrepl('ssf', { ssf90r })
        endif

      endif

    endif

  endif

  return (.t.)


/*****************************************************************
 
 FUNCTION:
 АВТОР..ДАТА..........С. Литовка  08-26-20 * 05:03:26pm
 НАЗНАЧЕНИЕ......... просчет веса
 ПАРАМЕТРЫ..........
 ВОЗВР. ЗНАЧЕНИЕ....
 ПРИМЕЧАНИЯ.........
 */
FUNCTION VesFullSh(ln_mnr, sdf_r, vsv_r, rvsv_r)
  STATIC sn_mnr:=0, sn_sdf_r:=0
  PRIVATE mnr:=ln_mnr

  // выведи из STATIC
  If sn_mnr = ln_mnr
    RETURN (sn_sdf_r)
  EndIf

  sele pr2; set orde to tag t3
  netseek('t3', 'mnr')
  while (mn=mnr)

    kol_r:=kf
    ktl_r:=ktl
    kg_r:=int(ktl_r/1000000)

    sele tov          // коеф веса
    ves_r=0; vesp_r=0; keip_r=0
    if (netseek('t1', 'Sklr,ktl_r'))
      ves_r=ves; vesp_r=vesp; keip_r=keip
    endif

    kovs_r=1          // коеф объемного веса склад с группы
    if (gnCtov=1)
      kovs_r=getfield('t1', 'kg_r', 'cgrp', 'kovs')
    endif

    sele pr2
    VesFull(ktl_r, kol_r, kovs_r, ves_r, vesp_r, keip_r, ;
              @sdf_r, @vsv_r, @rvsv_r                      ;
          )

    sele pr2; DBSkip()
  enddo

  /*If mnr = 63196
    wmess("sdf_r")
    outlog(3,__FILE__,__LINE__,"sdf_r",sdf_r)
  EndIf*/

  // запомнили в STATIC
  sn_mnr:=mnr
  sn_sdf_r:=sdf_r

  RETURN ( sdf_r )
