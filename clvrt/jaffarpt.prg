/*****************************************************************
 
 FUNCTION:
 АВТОР..ДАТА..........С. Литовка  10-17-12 * 08:07:31pm
 НАЗНАЧЕНИЕ.........
 ПАРАМЕТРЫ..........
 ВОЗВР. ЗНАЧЕНИЕ....
 ПРИМЕЧАНИЯ.........
 */
FUNCTION JafaReport(nRm,losfon,lJoin,dMkDt,cMailTo)
  return
#ifdef __CLIP__
  DEFAULT losfon TO .F.
#endif
  //
   nVat:=20
   cListNoSaleSk:="254 256 255 "+STR(ngMerch_Sk241,3)
   IF nRm = -1
     bRmSkl:={||.T.}
     cEDRPU:="34012600_***"
   ELSE

    /*
    bRmSkl:={||;
               n_Sk:=_FIELD->Sk,;
               cskl->(__dblocate({|| cskl->Sk = n_Sk  })),;
               cskl->Rm = nRm;
             }
    */

    bRmSkl:={||.T.}  //!!ALL
    IF nRm = 0
      cEDRPU:="34012600"
    ELSE

      RETURN        //!!ALL

      cEDRPU:="34012600_"+STR(nRm*100,3)
    ENDIF
   ENDIF
   /*
Оплаты,Pay,,,,
   */
    crtt("Pay",'f:EDRPOU c:c(15)  f:TTID c:c(15) f:Date c:c(15)  f:PayType c:c(2) f:Summa c:c(15)  f:SummaVAT c:c(15)')
    use pay new

    USE (gcPath_ew+"deb\accord_deb") ALIAS skdoc NEW SHARED READONLY
    SET ORDER TO TAG t1
    DO WHILE skdoc->(!EOF())
      IF skdoc->Nap=4  .and. skdoc->(EVAL(bRmSkl))

         SELE skdoc
         nRec:=RECNO()
         nTTN:=TTN
         sum Sdp to nSdp WHILE nTTN = TTN
         DBGOTO(nRec)


         pay->(DBAPPEND())
         //Код Продавца,Код ЕДРПОУ,EDRPOU,,*,
         pay->EDRPOU:= cEDRPU
         //Код торговой точки,Идентификатор торговой точки,TTID,Строка,*,
         pay->TTID  := str(skdoc->kgp)
         //Дата оплаты,Дата оплаты,Date,Строка (дд.мм.гггг),*,
         DtOplr:=IIF(EMPTY(skdoc->DtOpl),skdoc->DOP,skdoc->DtOpl)
         //Дата оплаты,Дата оплаты,Date,Строка (дд.мм.гггг),*,
  #ifdef __CLIP__
         pay->Date  := DTOC(DtOplr,"DD.MM.YYYY")
  #endif
         //Код формы оплаты,"1-Безнал, 2-Нал",PayType,Строка,*,безнал
         pay->PayType := "1"
         //Сумма,Сумма оплаты без НДС,Summa,Строка,*,
         pay->Summa   := str((nSdp/(100+nVat)*100),15,2)
         //СуммаНДС,Сумма НДС,SummaVAT,Строка,*,
         pay->SummaVAT:= str(nSdp/(100+nVat)*nVat,15,2)

          sele skdoc
          DO WHILE nTTN = TTN
            DBSkip()
          ENDDO
          loop

      ENDIF
      skdoc->(DBSKIP())
    ENDDO
    close pay
    close skdoc

     IF EMPTY(SELECT("mkdoc"))

       use mkpr102 new Exclusive
       copy stru to tmpmkpr
       use tmpmkpr Exclusive
       append from  mkpr102 for kop=108
       repl all kvp with kvp*(-1)
       close

       use mkdoc102 alias mkdoc new
       copy stru to  tmpmkdoc
       use tmpmkdoc alias mkdoc Exclusive
       append from mkdoc102
       append from tmpmkpr

      aMessErr:={}
      DBGOTOP()
      DO WHILE !EOF()
        IF empty(bar)
          IF EMPTY(LEN(aMessErr))
            AADD(aMessErr,CHR(10)+CHR(13))
            AADD(aMessErr,STR(_FIELD->mntovt)+" код без ШК "+alltrim(Nat)+CHR(10)+CHR(13))
          ELSE
            IF ASCAN(aMessErr,{|cElem|STR(_FIELD->mntovt)$cElem})=0
              AADD(aMessErr,STR(_FIELD->mntovt)+" код без ШК "+alltrim(Nat)+CHR(10)+CHR(13))
            ENDIF
          ENDIF
          _FIELD->Bar:=_FIELD->mntovt
        ENDIF

        DBSKIP()
      ENDDO
      #ifdef __CLIP__
      IF .F. .AND. !EMPTY(aMessErr)
        cMessErr:=""
        AEVAL(aMessErr,{|cElem|cMessErr += cElem })
        SendingJafa("oleg_ta@rambler.ru,lista@bk.ru",{{ "","Error Jaffa-ProdResSumy"+" "+DTOC(DATE(),"YYYYMMDD")}},;
        cMessErr,;
        228)

      ENDIF
      #endif

     ELSE
     ENDIF

      /*
Заказы,Orders,,,,
      Наименованеие поля,Описание,Имя в таблице выгрузки,Тип поля,Возможность предоставления,
      */
      crtt("Orders",'f:EDRPOU c:c(15)  f:TTID c:c(15) f:BAR c:c(15)  f:OrderDate c:c(15) f:DelivDate c:c(15)  f:Cnt c:c(15) f:Price c:c(15) f:Summa c:c(15)  f:SummaVAT c:c(15)  f:TAID c:c(15)  f:OrderID c:c(36)  f:MPID c:c(15) f:SummaDisc c:c(15)')
      use Orders new

     sele mkdoc
     DBGoTop()
     //DBGOBOTTOM();     DBSKIP()
     Do While !mkdoc->(eof())
       If (mkdoc->vo=9 .and. mkdoc->D0K1=0) ; //!! "0" - продажи
          .and. !(STR(mkdoc->Sk,3) $ cListNoSaleSk) ;
          .and.  mkdoc->(EVAL(bRmSkl))

        Orders->(DBAppend())
        //Код Продавца,Код ЕДРПОУ,EDRPOU,Строка,*,
        Orders->EDRPOU := cEDRPU
        //Код торговой точки,Идентификатор торговой точки,TTID,Строка,*,
        Orders->TTID := str(mkdoc->kgp)
        //Код номенклатуры, Штрих-код,BAR,Строка,*,
        Orders->BAR  := str(mkdoc->bar)
  #ifdef __CLIP__
        //Дата заказа,Период получения заказа в ТТ,OrderDate,Строка (дд.мм.гггг),*?,Дата создания док. в КПК или выписки
        cOrderDate:=GetDataField(mkdoc->Sk,"rs1","_rs1","t1","mkdoc->ttn","_rs1->TimeCrtFrm")
        dOrderDate:=CTOD(LEFT(cOrderDate,10),"YYYY-MM-DD")
        dOrderDate:=IIF(empty(dOrderDate),mkdoc->DTtn,dOrderDate)
        Orders->OrderDate:= DTOC(dOrderDate,"DD.MM.YYYY")
        //Планируемая дата доставки,Планируемый период доставки товара в ТТ,DelivDate,Строка (дд.мм.гггг),*?,Дата планируемой доставки в комп. - центразавоз
        dDelivDate:=GetDataField(mkdoc->Sk,"rs1","_rs1","t1","mkdoc->ttn","_rs1->DtRo")
        dDelivDate:=IIF(empty(dDelivDate),mkdoc->DTtn+1,dDelivDate)
        Orders->DelivDate:= DTOC(dDelivDate,"DD.MM.YYYY")
  #endif
        //Количество ,Количество заказанного товара в шт,Cnt,Строка,*,
        Orders->Cnt := str(mkdoc->kvp)
        //Цена,Цена товара,Price,Строка,* какая?,которую передавали и раньше
        Orders->Price := str(mkdoc->zenn)
        //Сумма,Стоимость заказанного товара без НДС,Summa,Строка,* в каких ценах,которую передавали и раньше
        Orders->Summa := str(mkdoc->kvp*mkdoc->zenn,15,2)
        //СуммаНДС,Сумма НДС,SummaVAT,Строка,*,
        Orders->SummaVAT := str((VAL(Orders->Summa)/100)*nVat,15,2)
        //Маршрут,Маршрут торгового агента,TAID,Строка,*?,нет (передавать не надо)
        Orders->TAID := str(mkdoc->kta)
        //Идентификатор заказа,Номер заказа. Необходимо для анализа выполнения заказов. По данному идентификатору будут сопоставляться заказы с доставками,OrderID,Строка,*?,№ ТТН в комп.
        cDocGuId:=IIF(empty(mkdoc->DocGuId),GUID_KPK("F",ALLTRIM(LTRIM(STR(mkdoc->SK))+PADL(LTRIM(STR(mkdoc->TTN)),7,"0"))),mkdoc->DocGuId)
        Orders->OrderID := cDocGuId
        //КодМаректинговойПрограммы,В случае отгрузки со скидкой код акционной программы,MPID,Строка,?,нет
        Orders->MPID := ""
        //СуммаСкидки,Сумма скидки от прайс-листа,SummaDisc,Строка,*?,нет
        Orders->SummaDisc := ""
       EndIf

       mkdoc->(DBSkip())
     EndDo
    close Orders


  /*
Доставка/Продажа,Sale
  Наименованеие поля,Описание,Имя в таблице выгрузки,Тип поля,Возможность предоставления
  Продажи
  */
  crtt("Sale",'f:EDRPOU c:c(15)  f:TTID c:c(15) f:Chanel c:c(15) f:BAR c:c(15) f:Date c:c(15) f:Cnt c:c(15) f:Price c:c(15) f:Summa c:c(15) f:SummaVAT c:c(15) f:Forwarder c:c(15) f:TAID c:c(15) f:SVID c:c(15) f:OrderID c:c(36)  f:SaleID c:c(15) '+;
  'f:Delay c:c(15) f:SummaDisc c:c(15)')
  crtt("SaleIn",'f:EDRPOU c:c(15)  f:TTID c:c(15) f:Chanel c:c(15) f:BAR c:c(15) f:Date c:c(15) f:Cnt c:c(15) f:Price c:c(15) f:Summa c:c(15) f:SummaVAT c:c(15) f:Forwarder c:c(15) f:TAID c:c(15) f:SVID c:c(15) f:OrderID c:c(36)  f:SaleID c:c(15) '+;
  'f:Delay c:c(15) f:SummaDisc c:c(15)')
  use Sale new Exclusive
  use SaleIn new Exclusive

   mkdoc->(DBGoTop())
   If Empty(mkdoc->(LastRec()))
    /*
      cSale:="Sale"

      (cSale)->(DBAppend())
      //Код Продавца,Код ЕДРПОУ,EDRPOU,Строка,*
      (cSale)->EDRPOU := cEDRPU
      // первое число следующего месяча текущего момента
      (cSale)->Date := DTOC(EOM(dMkDt)+1,"DD.MM.YYYY")
      (cSale)->Cnt := ATREPL(".",str(0),".")
      (cSale)->Price := ATREPL(".",str(0),".")
      (cSale)->Summa := ATREPL(".",str(0),".")
    */
   Else

     Do While !mkdoc->(eof())
        IF mkdoc->vo=9 .and. mkdoc->D0K1=1 //приход
          mkdoc->(DBSKIP())
          loop
        ENDIF
       If !(STR(mkdoc->Sk,3) $ cListNoSaleSk) .and. ;
        mkdoc->(EVAL(bRmSkl))

         IF mkdoc->vo=9 .and. mkdoc->D0K1=0 .OR. mkdoc->KOP=108
           TTIDr:=str(mkdoc->kgp)
           //sele Sale
           cSale:="Sale"
         ELSE
           TTIDr:="ВНУТР. ОПЕР."
           //sele SaleIn
           cSale:="SaleIn"
           //mkdoc->(DBSkip())
           //LOOP
         ENDIF

         (cSale)->(DBAppend())
         //Код Продавца,Код ЕДРПОУ,EDRPOU,Строка,*
         (cSale)->EDRPOU := cEDRPU
         //Код торговой точки,Идентификатор торговой точки,TTID,Строка,*
         (cSale)->TTID := TTIDr
         //Канал продаж,"Канал продаж (Хорека, Розница, VIP и т.д)",Chanel,Строка,*
         kgpcatr:=getfield("t1","mkdoc->kgp","kgp","kgpcat")
         nkgpcatr:=getfield("t1","kgpcatr","kgpcat","nkgpcat")
         (cSale)->Chanel    := nkgpcatr        //Канал (Розница,VIP,Horeca, Киоск)
         //Код номенклатуры,Штрих-код,BAR,Строка,*
         (cSale)->BAR := str(mkdoc->bar)           //Штрих-Код продукции;
         //Дата доставки,Дата фактической доставки товара в ТТ,Date,Строка (дд.мм.гггг),*

         //d_dop:=GetDataField(mkdoc->Sk,"rs1","_rs1","t1","mkdoc->ttn","_rs1->dop")
         If .F. .AND. BOM(dtEndr) # BOM(mkdoc->dttn)
           (cSale)->TTID := "ВНУТР. ОПЕР."
           d_dop:=BOM(dtEndr)
           cAddPrefNdoc:=SUBSTR(DTOS(mkdoc->dttn),3,4) //20140301
         Else
           d_dop:=NIL
           cAddPrefNdoc:=""
         EndIf

         d_dop:=Iif(Empty(d_dop),mkdoc->dttn,d_dop)
         #ifdef __CLIP__
         (cSale)->Date := DTOC(d_dop,"DD.MM.YYYY")
         #endif
         //Количество ,Количество доставленного товара в шт,Cnt,Строка,*
         (cSale)->Cnt := ATREPL(".",str(mkdoc->kvp),".")
         //Цена,Цена товара,Price,Строка,*какая?,которую передавали и раньше
         nPriceSale:=;
         IIF(mkdoc->KOP=177, 0, mkdoc->zen) //zenn - расчетаная, zen- c ТТН

         (cSale)->Price:= ATREPL(".",str(nPriceSale),".")
         //Сумма,"Стоимость доставленного товара без НДС (Если возврат, то сумма с знаком минус)",Summa,Строка,* в каких ценах,которую передавали и раньше
         nSummma:=mkdoc->kvp*nPriceSale
         (cSale)->Summa := ATREPL(".",str(nSummma,15,2),".")
         //СуммаНДС,Сумма НДС доставленного товара,SummaVAT,Строка,*
         (cSale)->SummaVAT :=ATREPL(".", str((nSummma/100)*nVat,15,2),".")
         //Экспедитор,ФИО Экспедитора/водителя доставившего заказ,Forwarder,Строка,*
         KECSr:=GetDataField(mkdoc->Sk,"rs1","_rs1","t1","mkdoc->ttn","_rs1->KECS")
         (cSale)->Forwarder := getfield('t1','KECSr','s_tag','fio')
         //Маршрут,Маршрут торгового агента,TAID,Строка,*
         (cSale)->TAID:=str(mkdoc->kta)
         //Супервайзер,Код супервайзера,SVID,Строка,*
         //(cSale)->SVID := str(getfield('t1','mkdoc->kta','s_tag','ktas'))
         (cSale)->SVID := str(getfield('t1','mkdoc->kta','s_tag','ksv'))

         //Идентификатор заказа,Ссылка на заказ согласно которого осуществлены продажи,OrderID,Строка,*?,№ ТТН в комп.
         cDocGuId:=IIF(empty(mkdoc->DocGuId),GUID_KPK("F",cAddPrefNdoc+ALLTRIM(LTRIM(STR(mkdoc->SK))+PADL(LTRIM(STR(mkdoc->TTN)),7,"0"))),mkdoc->DocGuId)
         (cSale)->OrderID := cDocGuId
         //Идентификатор отгрузки,Номер накладной согласно которой осуществляется отгрузка клиенту. Необходимо для анализа дебиторской задолженности,SaleID,Строка,*,
         (cSale)->SaleID:=cAddPrefNdoc+ALLTRIM(LTRIM(STR(mkdoc->SK))+PADL(LTRIM(STR(mkdoc->TTN)),7,"0"))
         //Отсрочка платежа,Отсрочка платежа после отгрузки,Delay,Строка,*,
         d_DtOpl:=GetDataField(mkdoc->Sk,"rs1","_rs1","t1","mkdoc->ttn","_rs1->DtOpl")
                  IF EMPTY(d_DtOpl)
                    DtOplr:=d_dop+14
                  ELSEIF d_DtOpl = mkdoc->DTtn
                    DtOplr:=d_dop+14
                  ELSE
                    DtOplr:=d_DtOpl
                  ENDIF
         //outlog(__FILE__,__LINE__,DtOplr - d_dop)
         (cSale)->Delay:= str(DtOplr - d_dop)
         //СуммаСкидки,Сумма скидки от прайс-листа,SummaDisc,Строка,*?,нет
         (cSale)->SummaDisc:="0"

       EndIf

       mkdoc->(DBSkip())
     EndDo
   EndIf

   cSale:="Sale"
   If Empty((cSale)->(LastRec()))
      cSale:="Sale"

      (cSale)->(DBAppend())
      //Код Продавца,Код ЕДРПОУ,EDRPOU,Строка,*
      (cSale)->EDRPOU := cEDRPU
      // первое число следующего месяча текущего момента
      (cSale)->Date := DTOC(EOM(dMkDt)+1,"DD.MM.YYYY")
      (cSale)->Cnt := ATREPL(".",str(0),".")
      (cSale)->Price := ATREPL(".",str(0),".")
      (cSale)->Summa := ATREPL(".",str(0),".")
  EndIf
  close Sale
  close SaleIn

  /*
Склад/Остатки,Rest,,,,
  Наименованеие поля,Описание,Имя в таблице выгрузки,Тип поля,Возможность предоставления,
  */
  crtt("Rest",'f:Date c:c(15) f:WHID c:c(15) f:Bar c:c(15) f:Cnt c:c(15) f:nat c:c(60) f:sk c:c(6)')

    use mktov102 alias  mktov new Exclusive
    set index to
    repl bar  with mntovt for empty(bar)
    index on str(bar,13)+str(mntovt,7)+str(sk,3) to tmpbar

  total on str(bar,13)+str(mntovt,7)+str(sk,3) ;
  field osn, osfo, osfon to tmpmktov ;
  for .T.  ;
    .and. EVAL(bRmSkl) ;
    .and. mntovt >= 10^6 ;
    .and. ngMerch_Sk241 # mktov->Sk  //остаки только без Мерча !(STR(Sk,3) $ cListNoSaleSk)
  close mktov

  use tmpmktov alias  mktov new

  use Rest new Exclusive
  mktov->(DBGoTop())
  Do While !mktov->(eof())
     Rest->(DBAppend())
     //Идентификатор склада,"Основной склад - 1, СОХ - 2",WHID,Строка,*,по складам
     IF nRm = 0 .or. nRm = -1
       DO CASE
       CASE mktov->Sk = 254
         Rest->WHID:="2" //СОХ
       CASE mktov->Sk = 256
         Rest->WHID:="3" //основной БОЙ
       CASE mktov->Sk = 255
         Rest->WHID:="4" //СОХ БОЙ
       OTHERWISE
         Rest->WHID:="1" //основной
       ENDCASE
     ELSE
       Rest->WHID:="1"
     ENDIF
     //Код номенклатуры,Штрих-код,BAR,Строка,*,
     Rest->Bar := str(mktov->Bar)
     IF lJoin
     ELSE
     ENDIF
     //Количество,Кличество на остатках,Cnt,Строка,*,
     IF (UPPER("/osfon") $ UPPER(DosParam())) .OR. !EMPTY(lOsfon)
           //Дата остатков,Дата,Date,Строка (дд.мм.гггг),*,
      #ifdef __CLIP__
           Rest->Date := DTOC(dMkDt,"DD.MM.YYYY") //osfon на НАЧАЛО дня
      #endif
       nQt:=mktov->osfon //mktov->osn
     ELSE
           //Дата остатков,Дата,Date,Строка (дд.мм.гггг),*,
      #ifdef __CLIP__
           Rest->Date := DTOC(dMkDt + 1,"DD.MM.YYYY") //+1 тк на НАЧАЛО следующего
      #endif
       nQt:=mktov->osfo //mktov->osn
     ENDIF

     IF (.T. .AND.  nQt < 0)
       Rest->Cnt := ATREPL(".",str(0),".")
     ELSE
       Rest->Cnt := ATREPL(".",str(nQt),".")
     ENDIF
     Rest->Nat := mktov->nat
     Rest->Sk := str(mktov->sk,3)
     mktov->(DBSkip())
  EndDo
  close Rest
  close mktov

  /*
Контрагенты,Custom ,,,,
  Наименованеие поля,Описание,Имя в таблице выгрузки,Тип поля,Возможность предоставления,
  */
  crtt("Custom",'f:ID c:c(15) f:Descr c:c(15) f:FullDescr c:c(45) f:LegalAddr c:c(35) f:RealAddr c:c(35) f:PayType c:c(1)  f:Delay c:c(5)')

  use Custom new
  sele mkdoc
  set index to
  index on kpl to tmpkpl
  total on kpl to tmpkpl ;
  for .T.  ;
    .and. EVAL(bRmSkl) ;
    .and. mkdoc->vo=9  ;
    .and. !(STR(mkdoc->Sk,3) $ cListNoSaleSk)

  IF nRm = -1 .OR. nRm = 0
    COPY FILE tmpkpl.dbf TO tmpkpl1.dbf
    USE tmpkpl1 NEW
    APPEND FROM  sbarost //добавим точки с ОБОРУДОВНИЯ
    index on str(kgp)+str(kpl) to tmpkpl1
    total on str(kgp)+str(kpl) to tmpkpl
    CLOSE tmpkpl1
  ENDIF

  use tmpkpl new

  Do While tmpkpl->(!eof())
    Custom->(DBAppend())
    //Код контрагента,Код контрагента из справочника,ID,Строка,*?,код плательщика
    Custom->ID := str(tmpkpl->kpl)
    //Наименование,Сокращенное наименование Контрагента,Descr,Строка,*,
    Custom->Descr := tmpkpl->NPL
    //Наименование полное,Полное наименование контрагента,FullDescr,Строка,*,
    Custom->FullDescr := tmpkpl->NPL
    //Юридический адрес контрагента,Юридический адрес контрагента,LegalAddr,Строка,*,
    Custom->LegalAddr := tmpkpl->APl
    //Фактический адрес контрагента,Местонахождения центрального офиса контрагента,RealAddr,Строка,*,
    Custom->RealAddr := tmpkpl->APl
    //Вид оплаты,"1-Безнал, 2-Нал",PayType,Строка,*,
    Custom->PayType:="1"
    //Дни отсрочки платежа,Отсрочка платежа после отгрузки,Delay,Строка,?*,отсрочка в карточке плательщика (на бренд или по умолч.))
    kdoplr:=kdopl("102",tmpkpl->kpl)
    /*
    izgr:=getfield("t1","102","mkeepe","izg")
    kdoplr:=getfield("t1","tmpkpl->kpl,999,izgr","klnnac","kdopl")
    kdoplr:=Iif(empty(kdoplr),getfield("t1","tmpkpl->kpl","klndog","kdopl"),kdoplr)
    */
    Custom->Delay := str(kdoplr)

    tmpkpl->(DBSkip())
  EndDo
  close Custom
  close tmpkpl



  /*
Торговые точки
  Торговые точки ,TO,,,,
  Наименованеие поля,Описание,Имя в таблице выгрузки,Тип поля,Возможность предоставления,

  */
  crtt("TO",'f:ID c:c(15)  f:Desr c:c(35)  f:Region c:c(15)  f:District c:c(15) f:City c:c(15)  f:Street c:c(25)  f:House c:c(15) f:Chanel c:c(15) f:TAID c:c(15) f:SVID c:c(15) f:RouteDay c:c(15) f:Period c:c(15) f:CustID c:c(15) '+;
  'f:SkuLen c:c(15) f:PetLen c:c(15)')
  use ("to") ALIAS TradeOutlet new
  sele mkdoc
  set index to
  index on str(kgp)+str(kpl) to tmpkgp
  total on str(kgp)+str(kpl) to tmpkgp ;
  for .T.  ;
    .and. EVAL(bRmSkl) ;
    .and. mkdoc->vo=9  ;
    .and. !(STR(mkdoc->Sk,3) $ cListNoSaleSk)

  IF nRm = -1 .OR. nRm = 0
    COPY FILE tmpkgp.dbf TO tmpkgp1.dbf
    USE tmpkgp1 NEW
    APPEND FROM  sbarost //добавим точки с ОБОРУДОВНИЯ
    APPEND FROM  mkkplkgp //добавим точки с ВСЕ от Джафы
    index on str(kgp)+str(kpl) to tmpkgp1
    total on str(kgp)+str(kpl) to tmpkgp
    CLOSE tmpkgp1
  ENDIF


  use tmpkgp new
  Do While tmpkgp->(!eof())

    TradeOutlet->(DBAppend())

    kln->(netseek("t1","tmpkgp->kgp"))
    //Код точки,Код точки,ID,Строка,*,
    TradeOutlet->ID := str(tmpkgp->kgp)
    //Наименование торговой точки,Наименование торговой точки,Desr,Строка,*,
    TradeOutlet->Desr := kln->Nkl
    //Область,Область,Region,Строка,*,
    TradeOutlet->Region := "Сумская"
    //Район,Район,District,Строка,*,
    TradeOutlet->District := getfield("t1","kln->krn","krn","nrn")
    //Населенный пункт (город),Населенный пункт (город),City,Строка,*,
    TradeOutlet->City := getfield("t1","kln->knasp","knasp","nnasp")
    //Улица,Улица,Street,Строка,*,
    TradeOutlet->Street := kln->adr
    //Дом,Дом,House,Строка,*,
    TradeOutlet->House := ""
    //Канал продаж,Канал продаж,Chanel,Строка,*,
       kgpcatr:=getfield("t1","tmpkgp->kgp","kgp","kgpcat")
       nkgpcatr:=getfield("t1","kgpcatr","kgpcat","nkgpcat")
    TradeOutlet->Chanel := nkgpcatr        //Канал (Розница,VIP,Horeca, Киоск)
    //Маршрут торгового агента,Маршрут торгового агента,TAID,Строка,*?,код торгового агента к кому превязан грузополучатель
    TradeOutlet->TAID := str(tmpkgp->kta)
    //Супервайзер,Супервайзер,SVID,Строка,*,код СВ к которуму привязан торговый агент
    //TradeOutlet->SVID := str(getfield('t1','tmpkgp->kta','s_tag','ktas'))
    TradeOutlet->SVID := str(getfield('t1','tmpkgp->kta','s_tag','ksv'))
    //День посещения торговым агентом,"1- понедельник и т.д. Если несколько дней, то через запятую",RouteDay,Строка,*,
    nDow:=dow(tmpkgp->dTtn)
    IF EMPTY(nDow)
      nDow:=1
    ENDIF
    TradeOutlet->RouteDay := str({7,1,2,3,4,5,6}[nDow])
    //aDow:={7,1,2,3,4,5,6} ;    //TradeOutlet->RouteDay := str(aDow[dow(dTtn)])
    //Периодичность посещения,"Количество недель между плановыми визитами (1 - каждую неделю, 2 -через неделю и т.д)",Period,Строка,*?, 1 раз в неделю - все
    TradeOutlet->Period := "1"
    //Код Контрагента,Ссылка на справчоник контрагентов,CustID,Строка,*,код плательщика
    TradeOutlet->CustID := str(tmpkgp->kpl)
    //Длина полки для соков (в количестве упаковок),Длина полки для соков (в количестве упаковок),SkuLen,Строка,?,нет
    TradeOutlet->SkuLen :=""
    //Длина полки для ПЭТ (в количестве шт),Длина полки для ПЭТ (в количестве шт),PetLen,Строка,?,нет
    TradeOutlet->PetLen :=""

    tmpkgp->(DBSkip())
  EndDo
  close TradeOutlet

  crtt("ToFlags",'f:ID c:c(15)  f:Flag c:c(15)')

  IF nRm = -1 .OR. nRm = 0
    use ("ToFlags") ALIAS ToFlags new

    sele tmpkgp
    tmpkgp->(DBGoTop())
    Do While tmpkgp->(!eof())
      ToFlags->(DBAPPEND())
      ToFlags->ID := str(tmpkgp->kgp)
      ToFlags->Flag := str(getfield('t1','tmpkgp->kgp','kgp','prtt102'))

      DO WHILE  VAL(LTRIM(ToFlags->ID)) = tmpkgp->kgp
        tmpkgp->(DBSkip())
      ENDDO
    EndDo
    close ToFlags
  ENDIF

  close tmpkgp

  /*
Маршруты,Route,,,,
  Наименованеие поля,Описание,Имя в таблице выгрузки,Тип поля,Возможность предоставления,
  */
  crtt("Route",'f:TAID c:c(15) f:Descr c:c(35) f:TaName c:c(15) f:Channel c:c(15) f:Excl c:c(1) f:SVID c:c(25)')
  use Route new
  sele mkdoc
  set index to
  index on kta to tmpkta
  total on kta to tmpkta ;
  for .T.  .and. EVAL(bRmSkl);
   .and. mkdoc->vo=9  ;
   .and. !(STR(mkdoc->Sk,3) $ cListNoSaleSk)

  use tmpkta new
  Do While tmpkta->(!eof())
    Route->(DBAppend())
    //Код маршрута,Идентификатор маршрута,TAID,Строка,*?,нет
    Route->TAID:=str(tmpkta->kta)
    //Наименование маршрута,Наименование,Descr,Строка,*?,нет
    Route->Descr := str(tmpkta->kta)+" "+getfield('t1','tmpkta->kta','s_tag','fio')
    //ФИО торгового агента,ФИО торгового агента,TaName,Строка,*,нет
    Route->TaName := getfield('t1','tmpkta->kta','s_tag','fio')
    //Канал продвижения,Ссылка на справочник каналов продвижения,Channel,Строка,?,нет
       kgpcatr:=getfield("t1","tmpkta->kgp","kgp","kgpcat")
       nkgpcatr:=getfield("t1","kgpcatr","kgpcat","nkgpcat")
    Route->Channel:=    nkgpcatr        //Канал (Розница,VIP,Horeca, Киоск)
    //Признак эксклюзивности,"Занимается данный сотрудник только продукцией компании Витмарк или нет (1,0)",excl,Строка,?,нет
    Route->Excl:="0"
    //Код супервайзера,Ссылка на справочник супервайзеров,SVID,Строка,*?,нет
    //Route->SVID:= str(getfield('t1','tmpkta->kta','s_tag','ktas'))
    Route->SVID:= str(getfield('t1','tmpkta->kta','s_tag','ksv'))
    tmpkta->(DBSkip())
  EndDo
  close route
  close tmpkta

  /*
  Супервайзера,SV,,,,
  Наименованеие поля,Описание,Имя в таблице выгрузки,Тип поля,Возможность предоставления,
  */
  crtt("SV",'f:SVID c:c(15) f:Descr c:c(35) f:Channel c:c(15)')
  use sv new alias SVID
  sele mkdoc
  set index to
  //index on getfield('t1','mkdoc->kta','s_tag','ktas') to tmpskta
  index on mkdoc->kta to tmpskta
  total on mkdoc->kta to tmpskta ;
   for .T.  .and. EVAL(bRmSkl) ;
   .and. mkdoc->vo=9  ;
   .and. !(STR(mkdoc->Sk,3) $ cListNoSaleSk)
  use tmpskta new EXCLUSIVE
  index on getfield('t1','tmpskta->kta','s_tag','ksv') to tmpskta1
  total on getfield('t1','tmpskta->kta','s_tag','ksv') to tmpskta1
  CLOSE
  //     (cSale)->SVID := str(getfield('t1','mkdoc->kta','s_tag','ksv'))


  use tmpskta1 ALIAS tmpskta new EXCLUSIVE
  Do While tmpskta->(!eof())
    svid->(DBAppend())
    /*
    //Код супервайзера,Идентификатор,SVID,Строка,*,
    svid->SVID := str(getfield('t1','tmpskta->kta','s_tag','ktas'))
    //Наименование ,Наименование,Descr,Строка,*,
    svid->Descr := getfield('t1','val(alltrim(svid->SVID))','s_tag','fio')
    */
    //Код супервайзера,Идентификатор,SVID,Строка,*,
    svid->SVID := str(getfield('t1','tmpskta->kta','s_tag','ksv'))
    //Наименование ,Наименование,Descr,Строка,*,
    svid->Descr := getfield('t1','val(alltrim(svid->SVID))','svjafa','nsv')
    //Канал продвижения,Ссылка на справочник каналов продвижения,Channel,Строка,*?,нет
    svid->Channel := ""
    tmpskta->(DBSkip())
  EndDo
  close svid
  close tmpskta


  /*
План продаж
  План продаж,TradePlan,,,,
  Наименованеие поля,Описание,Имя в таблице выгрузки,Тип поля,Возможность предоставления,
  Период Планирования,Дата (первое число месяца),Date,Строка (дд.мм.гггг),?,нет
  Маршрут торгового агента,Маршрут торгового агента,TAID,Строка,?,нет
  Супервайзер,Код супервайзера,SVID,Строка,?,нет
  "Номенклатурная группа. бренд (код , наименование) ",Указывается штрих-код  номенклатуры из номенклатурной группы (любая) ,BAR,Строка,?,нет
  Сумма план,План продаж в суммовом выражении,PlanSumma,Строка,?,нет
  Количество плана,План продаж в количественном выражении,PlanCnt,Строка,?,нет
  План активации торговых точек,План активации торговых точек,ActTO,Строка,?,нет
  План по выставлению холодильников,План по выставлению холодильников,XOCnt,Строка,?,нет
  */
  crtt("TradePlan",'f:Date c:c(15) f:TAID c:c(15) f:SVID c:c(15) f:Bar c:c(15) f:PlanSumma c:c(15) f:PlanCnt c:c(15) f:ActTO c:c(15) f:XOcnt c:c(15)')


  use sbarost new

  /*
Холодильное и торговое оборудование (фирменные полки)
   ХО (Оборудование),Equip,,,,
  Наименованеие поля,Описание,Имя в таблице выгрузки,Тип поля,Возможность предоставления,
  */
  crtt("Equip",'f:ID c:c(15) f:Descr c:c(45)  f:Type c:c(15)')
  IF nRm = -1 .OR. nRm = 0
    sele sbarost
    set index to
    index on ktl to tmpktl
    total on ktl to tmpktl
    use tmpktl new
    use Equip new

    Do While tmpktl->(!eof())
      If "ХОЛ" $ UPPER(tmpktl->nat)
        Equip->(DBAppend())
        //ИдентификаторХО,Идентификатор ,ID,Строка,?,код товара
        Equip->ID    := ALLTRIM(str(tmpktl->ktl))
        //Наименование ,Наименование,Descr,Строка,?,намиенование
        Equip->Descr := tmpktl->nat
        //Тип холодильника,"Описание одно/двух дверный, витрина, ?хоречный?, защита холодильника",Type,Строка,?,нет
        Equip->Type  := ""
      EndIf
      tmpktl->(DBSkip())
    EndDo
    close tmpktl
    close Equip
  ENDIF

   /*
  Местоположение ХО,EqPlace,,,,
  Наименованеие поля,Описание,Имя в таблице выгрузки,Тип поля,Возможность предоставления,
   */
  sele sbarost
  set index to
    index on str(ktl)+str(kgp) to tmpktlgp
    total on str(ktl)+str(kgp) field osf to tmpktlgp
  close sbarost
  //use tmpktlgp Alias sbarost new Exclusive
  use tmpktl Alias sbarost new Exclusive

  crtt("EqPlace",'f:Date c:c(15) f:PlaceType c:c(1) f:Place c:c(7)  f:EqId c:c(15)')
  IF nRm = -1 .OR. nRm = 0
    use EqPlace new
    sbarost->(DBGoTop())
    Do While sbarost->(!eof())
      If "ХОЛ" $ UPPER(sbarost->nat) //.and. sbarost->osf > 0
        EqPlace->(DBAppend())
        //Дата,Дата движения,Date,Строка (дд.мм.гггг),?,из ТТН отргузки
    #ifdef __CLIP__
           dArDt:=IIF(EMPTY(sbarost->ArDt),DATE(),DATE()) //sbarost->ArDt)
           EqPlace->Date       :=DTOC(dArDt,"DD.MM.YYYY")
    #endif
        //Тип местонахождения,
        //"1 - контрагент , 2 - склад дистрибутора",PlaceType,Строка,?,из программы Субаренда
        EqPlace->PlaceType      := ALLTRIM(iif(sbarost->ArNd = 2,str(2),str(1)))
        //Местонахождение ХО,"Ссылка на справочник ТТ или на Склад в зависимости
        //от поля Тип местонахождения.
        //Если склад, то 1 -основной, 2 - СОХ",Place,Строка,?,адрес грузополучателя
        EqPlace->Place  := (iif(sbarost->ArNd = 2,str(1),str(sbarost->kgp)))
        //ИдентификаторХО,Ссылка на справочник ХО,EqId,Строка,?,код товара
        EqPlace->EqId       := ALLTRIM(str(sbarost->ktl))
      EndIf
      sbarost->(DBSkip())
    EndDo
    close EqPlace
  ENDIF
  CLOSE sbarost

  crtt("Report_W",'f:C1R1 c:c(15) f:C1R2 c:c(15)  f:C1R3 c:c(15) f:C1R4 c:c(15)')
  IF .t. //nRm = -1
    use Report_W ALIAS Report new
    Report->(DBAppend())
    Report->C1R1:="Отчет за"
    Report->C1R2:=DMY(dtBegr)+" по "
    Report->C1R3:=DMY(dtEndr)
    Report->C1R4:=" "+cEDRPU

    Report->(DBAppend())
    Report->C1R1:="итоги"
    Report->C1R2:="сумма прод, грн"
    Report->C1R3:="к-во ТТ, шт"
    Report->C1R4:="сумма ост, шт"

    Report->(DBAppend())
    Report->C1R1:=" JAFFA"

    use sale new
    nSumSale:=0
    DBEVAL({|| nSumSale+=(VAL(sale->Summa)+VAL(sale->SummaVAT)) })
    Report->C1R2:=STR(nSumSale)
    close

    use ("to") ALIAS TradeOutlet new
    Report->C1R3:=STR(LASTREC())
    close

    use Rest new
    nCntRest:=0
    DBEVAL({|| nCntRest+=VAL(Rest->Cnt) })
    Report->C1R4:=STR(nCntRest)
    close

    close Report
  ENDIF

  IF nSumSale = 0 .and.  nCntRest = 0
    cFileNameArc:="jf"+IIF((UPPER("/osfon") $ UPPER(DosParam())),"n","")+;
    DTOS(dtBegr)+;
    IIF(dtBegr=dtEndr,"","-"+DTOS(dtEndr))+;
    IIF(nRm=-1,"_",STR(nRm,1))+;
    ".zip"
    qout(__FILE__,__LINE__,"cFileNameArc, nSumSale = 0,  nCntRest = 0",cFileNameArc,nSumSale = 0,  nCntRest = 0)

    RETURN (NIL)
  ENDIF

  crtt("Report_M",'f:C1R1 c:c(15) f:C1R2 c:c(15)  f:C1R3 c:c(15) f:C1R4 c:c(45)')
  IF .t. //nRm = -1
    use Report_M ALIAS Report new
    Report->(DBAppend())
    Report->C1R1:="Отчет за"
    Report->C1R2:=DMY(dtBegr)+" по "
    Report->C1R3:=DMY(dtEndr)
    Report->C1R4:=" "+cEDRPU

    Report->(DBAppend())
    Report->C1R1:="SKU - ШК"
    Report->C1R2:="к-во, шт"
    Report->C1R3:="сумма прод, грн"
    Report->C1R4:="Наименование"

    use tmpmktov alias  mktov new
    use sale new
    index on BAR to t1 for val(Cnt) # 0
    DBGOTOP()
    DO WHILE sale->(!EOF())
      Report->(DBAppend())
      Report->C1R1:=sale->Bar

      nSumSale:=0
      nCntRest:=0
      DO WHILE Report->C1R1 = sale->Bar
        nSumSale += (VAL(sale->Summa)+VAL(sale->SummaVAT))
        nCntRest += VAL(sale->Cnt)
        sale->(DBSKIP())
      ENDDO
      Report->C1R2:=STR(nCntRest)
      Report->C1R3:=STR(nSumSale)

      SELE mktov ; locate for  ALLTRIM(Report->C1R1) = ALLTRIM(str(mktov->Bar))
      Report->C1R4:=mktov->NAT

    ENDDO
    close sale
    close mktov

    close Report
  ENDIF

    cLogSysCmd:=""
  #ifdef __CLIP__
    cRunZip:="/usr/bin/zip"

     IF lJoin
        cFileNameArc:="j"+IIF((UPPER("/osfon") $ UPPER(DosParam())),"n","")+;
        SUBSTR(DTOS(dtBegr),3)+;
        IIF(dtBegr=dtEndr,"","-"+DTOS(dtEndr))+;
        IIF(nRm=-1,"_",STR(nRm,1))+;
        ".zip"
     ELSE
        cFileNameArc:="j"+IIF((UPPER("/osfon") $ UPPER(DosParam())),"n","")+;
        SUBSTR(DTOS(dMkDt),3)+;
        IIF(nRm=-1,"_",STR(nRm,1))+;
        ".zip"
     ENDIF


    cFileList:="pay.dbf orders.dbf sale.dbf  salein.dbf rest.dbf "+;
    "custom.dbf to.dbf toflags.dbf route.dbf sv.dbf tradeplan.dbf "+;
    "equip.dbf eqplace.dbf report_m.dbf report_w.dbf"


    SYSCMD(cRunZip+" "+cFileNameArc+" "+ cFileList,"",@cLogSysCmd)

    //qout(__FILE__,__LINE__,cLogSysCmd)

    SendingJafa(cMailTo,{{ cFileNameArc,cEDRPU+" _JaffSumy"+cFileNameArc}},"./",228)
  #endif
  return
