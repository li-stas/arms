#include "inkey.ch"
#include "common.ch"
#include "fisc.ch"
#define FISC_MAX_CONNECT 10
#define SERVER_ANSWER_MAXSIZE 8096
#define LF CHR( 10 )
#define CR CHR( 13 )

#ifdef TEST

LOCAL nBytes, cHost, nPort, nTimeOut
LOCAL nL
LOCAL nConnect,nFError, cFErrorStr
LOCAL ServerResponce

CLEAR SCREEN

cHost:="localhost"
nPort:=7654
nTimeOut:=60*10^3
nBytes:=1024

  QOUT("Test for fisc_client")

  nConnect := fisc_open_server( cHost, nPort, @ServerResponce, nTimeOut, SERVER_ANSWER_MAXSIZE )
        ?"nConnect",nConnect
        QOUT("Ответ",ServerResponce)
  IF nConnect >= 0
    fisc_write_to_server(nConnect,;
    "FSTART: MARIA_NULL"+LF+"loginqwer"+LF+"1111111111"+LF+"FEND:"+LF+"")

    //читаем, что пришло в буфере
    nL:=fisc_read_from_server(nConnect,@ServerResponce,nTimeOut,SERVER_ANSWER_MAXSIZE)
    IF nL>=0

      IF VAL(ServerResponce)=0
        ?"nConnect",nConnect
        QOUT("Ответ",ServerResponce)
      ELSE
        ?"nConnect",nConnect
        QOUT("Ответ",ServerResponce,fisc_Error_Maria(ServerResponce))
      ENDIF

    ELSE
      //расшифровывем ошибку
      @ MAXROW(), 0 SAY fisc_Error(nL)
    ENDIF

    fisc_close_server(nConnect)
    WAIT
    //RUN ("./mariq")
  ENDIF
#endif


/*****************************************************************
 
 FUNCTION: fisc_open_server()
 АВТОР..ДАТА..........С. Литовка   03-04-05 * 00:23:23am
 НАЗНАЧЕНИЕ.........
 ПАРАМЕТРЫ..........
 ВОЗВР. ЗНАЧЕНИЕ....
 ПРИМЕЧАНИЯ.........
 */
FUNCTION fisc_open_server(cHost,nPort,cBuf,nTimeOut,nBytes)
  LOCAL nConnect
  LOCAL nFError, cFErrorStr, nL, i
  LOCAL aTypeModel

  nFError:=0
  aTypeModel:={}
  nConnect:=-1

  FOR i:=1 TO FISC_MAX_CONNECT
    nConnect:=TCPCONNECT(cHost,nPort,nTimeOut) //22) //7654)
    IF nConnect > -1
      //добавить в массив общий соединений aAllCon
      EXIT
    ELSE
      nFError:=FERROR()
      cFErrorStr:=FERRORSTR()
      cBuf:=ALLTRIM(STR(nFError))+","+cFErrorStr
      outlog(__FILE__,__LINE__,"Connect error to host",nFError,cFErrorStr)
      outlog(__FILE__,__LINE__,cHost,nPort,nTimeOut)
ENDIF
  NEXT
  IF nConnect > -1
    cBuf:=SPACE(nBytes,.T.)
    nL:=TCPREAD(nConnect,@cBuf,nBytes,nTimeOut)
    IF nL = -1
      nConnect := nL
      outlog(__FILE__,__LINE__,"TCPREAD","Read from host error",nL,nFError, cFErrorStr)
      return FISC_ERROR_READ_DATA
    ELSE
      cBuf:=LEFT(cBuf,nL)
      IF ASC(RIGHT(cBuf,1))<=13
        cBuf:=LEFT(cBuf,nL-1)
      ENDIF
//проверим что прочитали
      IF "OK" $ cBuf
        TOKENINIT(@cBuf," ")
        TOKENNEXT()
        DO WHILE !TOKENEND()
          AADD(aTypeModel,{nConnect,TOKENNEXT()})
        ENDDO
      ELSE
        nConnect:=-1
      ENDIF
    ENDIF
  ELSE
    return FISC_ERROR_CONNECT_HOST
  ENDIF

  RETURN ( nConnect )

/*****************************************************************
 
 FUNCTION: fisc_write_to_server
 АВТОР..ДАТА..........С. Литовка  03-04-05 * 01:05:48am
 НАЗНАЧЕНИЕ.........
 ПАРАМЕТРЫ..........
 ВОЗВР. ЗНАЧЕНИЕ....
 ПРИМЕЧАНИЯ.........
 */
FUNCTION fisc_write_to_server(nConnect,cBuf)
  LOCAL nL
  //проверка на максимальное подключение КА
  //конетк зарегитрирован aAllCon
  IF !( nConnect >= 0)
    return FISC_ERROR_INVALID_HANDLE
  ELSE
    nL:=TCPWRITE( nConnect, cBuf )
    IF nL = -1
      outlog(3,__FILE__,__LINE__,"TCPWRITE",nL)
      return FISC_ERROR_SEND_HOST
    ELSE
      IF nL != LEN(cBuf)
        outlog(3,__FILE__,__LINE__,"Send to host error (data lost) ",nL)
        return FISC_ERROR_SEND_DATA
      ENDIF
    ENDIF
  ENDIF
  RETURN ( nL )

/*****************************************************************
 
 FUNCTION: fisc_read_from_server
 АВТОР..ДАТА..........С. Литовка  03-04-05 * 01:29:29am
 НАЗНАЧЕНИЕ.........
 ПАРАМЕТРЫ..........
 ВОЗВР. ЗНАЧЕНИЕ....
 ПРИМЕЧАНИЯ.........
 */
FUNCTION fisc_read_from_server(nConnect,cBuf,nTimeOut,nBytes)
  LOCAL nL
  LOCAL nFError, cFErrorStr

  //проверка на максимальное подключение КА
  //конетк зарегитрирован aAllCon
  IF !( nConnect >= 0)
    return FISC_ERROR_INVALID_HANDLE
  ELSE

    cBuf:=SPACE(nBytes) //,.T.)
    nL:=TCPREAD(nConnect,@cBuf,nBytes,nTimeOut)

    IF nL = -1
      nFError   :=FERROR()
      cFErrorStr:=FERRORSTR()
      outlog(3,__FILE__,__LINE__,"TCPREAD","Read from host error",nL,nFError, cFErrorStr)
      return FISC_ERROR_READ_DATA
    ELSE
      cBuf:=LEFT(cBuf,nL)
      IF ASC(RIGHT(cBuf,1))<=13
        cBuf:=LEFT(cBuf,nL-1)
      ENDIF
    ENDIF

  ENDIF
  RETURN ( nL )

/*****************************************************************
 
 FUNCTION: fisc_close_server
 АВТОР..ДАТА..........С. Литовка  03-04-05 * 01:44:17am
 НАЗНАЧЕНИЕ.........
 ПАРАМЕТРЫ..........
 ВОЗВР. ЗНАЧЕНИЕ....
 ПРИМЕЧАНИЯ.........
 */
FUNCTION fisc_close_server(nConnect)
  //проверка на максимальное подключение КА
  //конетк зарегитрирован aAllCon
  IF !( nConnect >= 0)
    return FISC_ERROR_INVALID_HANDLE
  ELSE
    fisc_write_to_server(nConnect,"FQUIT:"+LF)
    //удалить из массива общих подключений aAllCon
  ENDIF
  RETURN ( NIL )

/*****************************************************************
 
 FUNCTION: fisc_Error
 АВТОР..ДАТА..........С. Литовка  03-07-05 * 02:29:35pm
 НАЗНАЧЕНИЕ.........
 ПАРАМЕТРЫ..........
 ВОЗВР. ЗНАЧЕНИЕ....
 ПРИМЕЧАНИЯ.........
 */
FUNCTION fisc_Error(nError)
  LOCAL afisc_Error, nElem
  afisc_Error:={;
  {FISC_ERROR_NONE              ,[нет ошибок                                               ]},;//   0
  {FISC_ERROR_HOST_NOT_FOUND    ,[хост не найден                                           ]},;//  -1
  {FISC_ERROR_SERVICE_NOT_FOUND ,[нет такого номера порта                                  ]},;//  -2
  {FISC_ERROR_CREATE_SOCKET     ,[не может создать сокет                                   ]},;//  -3
  {FISC_ERROR_CONNECT_HOST      ,[не может соединиться с сервером                          ]},;//  -4
  {FISC_ERROR_SEND_HOST         ,[не смог послать данные                                   ]},;//  -5
  {FISC_ERROR_SEND_DATA         ,[во время посылки сообщения разорвалось сетевое соединение]},;//  -6
  {FISC_ERROR_READ_DATA         ,[не смог прочитаь данные                                  ]},;//  -7
  {FISC_ERROR_LARGE_BLOCK       ,[размер буфера для приема данных меньше чем необходимо    ]},;//  -8
  {FISC_ERROR_INVALID_HANDLE    ,[не отрыл сервер или неправильный дескриптор              ]},;//  -9
  {FISC_ERROR_NO_MORE_HANDLE    ,[при открытии сервера закончились дескрипторы             ]};// -10
  }

  IF !EMPTY(nElem:=ASCAN( afisc_Error, {|aElem| aElem[1] = nError }))
    outlog(__LINE__,__FILE__,nElem,afisc_Error[nElem,2])
    RETURN afisc_Error[nElem,2]
  ELSE
    outlog(__LINE__,__FILE__,nElem,[ошибка не определена])
    RETURN [ошибка не определена                                     ]
  ENDIF
  RETURN ( "" )

/*****************************************************************
 
 FUNCTION: fisc_Error_Maria
 АВТОР..ДАТА..........С. Литовка  03-08-05 * 03:25:39am
 НАЗНАЧЕНИЕ.........
 ПАРАМЕТРЫ..........
 ВОЗВР. ЗНАЧЕНИЕ....
 ПРИМЕЧАНИЯ.........
 */
FUNCTION fisc_Error_Maria(xBuf,cCmd)
  LOCAL afisc_Error_Maria, nElem, cBuf
  cBuf:=xBuf
  afisc_Error_Maria:=;
  {;
    {41, [HARDPAPER: Скiнчилась чекова або контрольна стрiчка]},;
    {42, [HARDSENSOR: Датчик крайнього положення друкуючої головки не працює]},;
    {43, [HARDPOINT: Позицiонер друкуючої головки не працює]},;
    {44, [HARDTXD: Помилка лiнiї зв'язку (контроль парностi)]},;
    {45, [HARDTIMER: Неприпустиме значення часу]},;
    {46, [HARDMEMORY: Помилка запису до фiскальної пам'ятi]},;
    {47, [HARDLCD: Несправний дисплей]},;
    {48, [SHUTDOWN: Апарат блоковано з технiчних причин]},;
    {49, [SOFTBLOCK: Задовгий блок даних]},;
    {50, [SOFTNREP: Необхiдно виконати Z-звiт]},;
    {51, [SOFTSYSLOCK: Неприпустиме положення ключа "ВIДКЛЮЧЕНО"]},;
    {52, [SOFTCOMMAN: Невiдома команда]},;
    {53, [SOFTPROTOC: Команда не вiдповiдає протоколу]},;
    {54, [SOFTZREPOR: Z-звiт не сформований через аварiю]},;
    {55, [SOFTMFULL: Переповнення фiскальної пам'ятi]},;
    {56, [SOFTTIMER: Неприпустимий час: менше останнього Z-звiту]},;
    {57, [SOFTPARAM: Неприпустимий параметр команди]},;
    {58, [SOFTUPAS: Необхiдна реєстрацiя касира]},;
    {59, [SOFTCHECK: Невiрнi значення параметрiв]},;
    {60, [SOFTFACT: Не знайдено реєстрацiйний номер]},;
    {61, [SOFTSLWORK: Необхiдно встановити ключ у положення "РОБОТА"]},;
    {62, [SOFTSLPROG: Необхiдно встановити ключ у положення "ПРОГРАМУВАННЯ"]},;
    {63, [SOFTSLZREP: Необхiдно встановити ключ у положення "X-ЗВIТ"]},;
    {64, [SOFTSLNREP: Необхiдно встановити ключ у положення "Z-ЗВIТ"]},;
    {65, [SOFTREPL: Значення вже запрограмовано]},;
    {66, [SOFTOVER: Переповнення розрядностi]},;
    {67, [SOFTNEED: Неприпустимий результат коригування вихiдного залишку]},;
    {68, [SOFTACTIVE: Неактивнi ТРК або резервуари]},;
    {69, [SOFTFMTEST: Пошкоджено основнi фiскальнi реквiзити]},;
    {70, [SOFTOPTEST: Пошкоджено деннi фiскальнi данi]},;
    {71, [SOFT24HOUR: Робота продовжується бiльше 24 годин]},;
    {72, [HARDUCCLOW: Низька напруга живлення]},;
    {73, [HARDCUTTER: Несправнiсть пристрою вiдрiзання стрiчки]},;
    {74, [HARDPCONTR: Несправнiсть контролера зв'язку з ТРК]},;
    {75, [SOFTDIFART: нелегальна спроба перепрограмування артикула]},;
    {76, [SOFTBADART: неприпустимий номер артикула]},;
    {77, [SOFTCOPY: завеликий чек]},;
    {78, [SOFTOVART: забагато команд FISC/ARFI для чека]},;
    {79, [SOFTNOTAV: помилка активiзацiї ТРК]},;
    {80, [SOFTBADDISC: сума знижки бiльша за суму обороту]},;
    {81, [SOFTINUSE  : попереднє замовлення не завершене]},;
    {82, [SOFTOVPIST: перевищено кiлькiсть активiзованих ТРК]},;
    {83, [SOFTBADCS: невiрна контрольна сума]},;
    {84, [SOFTARTMODE: неприпустима операцiя для даного режима артикульної таблицi]},;
    {85, [SOFTTHPAS: невiрний пароль функцiї технологiчного проливу]};
  }
  IF VALTYPE(xBuf)="C"
    xBuf:=VAL(ALLTRIM(xBuf))
  ENDIF
  IF !EMPTY(nElem:=ASCAN( afisc_Error_Maria, {|aElem| aElem[1] = xBuf }))
    outlog(__LINE__,__FILE__,nElem,afisc_Error_Maria[nElem,2],cCmd)
    RETURN afisc_Error_Maria[nElem,2]
  ELSE
    outlog(__LINE__,__FILE__,nElem,[ошибка не определена]+","+XTOC(cBuf),cCmd)
    RETURN [ошибка не определена ]+","+XTOC(cBuf)
  ENDIF
  RETURN ( NIL )

/*****************************************************************
 
 FUNCTION: fisc_cmd
 АВТОР..ДАТА..........С. Литовка  03-12-05 * 08:08:03pm
 НАЗНАЧЕНИЕ.........
 ПАРАМЕТРЫ..........
 ВОЗВР. ЗНАЧЕНИЕ....
 ПРИМЕЧАНИЯ.........
 */
FUNCTION fisc_cmd( nConnect, ServerResponce, cCmd, nTimeOut, nBytes, cHost,nPort, lShowError, nRowShow, nColShow)
  LOCAL  nL
  DEFAULT lShowError TO TRUE, nRowShow TO MAXROW()-1, nColShow TO 0

  nL:=fisc_write_to_server(nConnect,cCmd)
  //outlog(__FILE__,__LINE__,nl,cCmd)
  IF nL >= 0

    nL:=fisc_read_from_server(nConnect,@ServerResponce,nTimeOut,nBytes)
    //outlog(__FILE__,__LINE__,nl,ServerResponce)

    IF nL >= 0
      IF LEFT(ServerResponce,1)="0"
        nL:=0
        IF lShowError
          @ nRowShow, 0 SAY PADR("",MAXCOL()) COLOR "GR+/W"
        ENDIF
      ELSE
        IF LEFT(ServerResponce,2)="-2"
          outlog(__FILE__,__LINE__,nl,ServerResponce)
          //востановим поключение
          fisc_close_server(nConnect)
          nConnect:=fisc_open_server(cHost,nPort,@ServerResponce,nTimeOut,nBytes)
          IF ( !EMPTY( nConnect ) )
            @ nRowShow, nColShow SAY PADR( ServerResponce, MAXCOL() ) COLOR "N/W"
          ELSE
            @ nRowShow, nColShow SAY PADR( ServerResponce, MAXCOL() ) COLOR "W/R,N/W"
          ENDIF
          outlog(__FILE__,__LINE__,nl,ServerResponce)
        ELSE
          IF lShowError
            @ nRowShow, nColShow SAY PADR(ServerResponce+":"+fisc_Error_Maria(ServerResponce,cCmd),MAXCOL()) COLOR "GR+/W"
          ENDIF
        ENDIF
      ENDIF
    ELSE
      IF lShowError
        //расшифровывем ошибку
        @ nRowShow, nColShow SAY PADR(fisc_Error(nL,cCmd),MAXCOL()) COLOR "W/R"
      ENDIF
    ENDIF

  ELSE
    IF lShowError
      //расшифровывем ошибку
      @ nRowShow, nColShow SAY PADR(fisc_Error(nL,cCmd),MAXCOL()) COLOR "W/R"
    ENDIF
  ENDIF

  RETURN ( nL )
/*****************************************************************
 
 FUNCTION:
 АВТОР..ДАТА..........С. Литовка  03-13-05 * 09:22:41am
 НАЗНАЧЕНИЕ.........
 ПАРАМЕТРЫ..........
 ВОЗВР. ЗНАЧЕНИЕ....
 ПРИМЕЧАНИЯ.........
 */
FUNCTION MariaQ( nConnect, cCashMen, cMariaPasswd, nTimeOut, scHost, snPort )
  LOCAL aChoice, aChoiceLog, nChoice, nVibor
  LOCAL cScreen, cScr1
  LOCAL y1
  LOCAL nScrollType, nSumInOut, tTimeReal
  LOCAL dDataEnd,dDataBeg
  LOCAL nNumBeg, nNumEnd

  nScrollType:=0

  SET COLOR TO G/N, GR+/N,,, +G/N
  SAVE SCREEN TO cScreen
  CLEAR SCREEN

  aChoice:={                                              ;
             "1. Напечатать пустой чек",                  ;
             "2. Копия последнего чека",                  ;
             "3. Прогнать чековую ленту",                 ;
             "4. Служебный ввод/вывод наличности",        ;
             " ",                                         ;
             "5. Дневной отчет без обнуления (Х-отчет)",  ;
             "6. Периодические отчеты (даты или номера)", ;
             "7. Дневной отчет с обнулением (Z-отчет)",   ;
             " ",                                         ;
             "8. Получить дату и время",                  ;
             " ",                                         ;
             "9. Регистрационная информация о владельце", ;
             "0. Формирование внешнего вида чека",        ;
             "A. Запрограммировать налог",                ;
             "B. Характириска расчетной валюты",          ;
             "C. Подвести часы реального времени"         ;
           }
  aChoiceLog:={}
  AEVAL( aChoice, { || AADD( aChoiceLog, TRUE ) } )
  WHILE ( TRUE )
    aChoiceLog[ 5 ]:=FALSE
    aChoiceLog[ 9 ]:=FALSE
    aChoiceLog[ 11 ]:=FALSE

    y1:=1
    DispBox( y1, 3, y1+17, 47, "BG+/N", 2 )
    @ y1, 3+1 SAY "[ Программирование ЭККА ]" COLOR "+BG/N"
    nChoice:=ACHOICE( y1+1, 3+2, y1+16, 46, aChoice, aChoiceLog )
    //#endif

    SAVE SCREEN TO cScr1

    DO CASE
    CASE ( nChoice = 0 )
      RESTORE SCREEN FROM cScreen
      EXIT
    CASE ( nChoice = 1 )
      //"1. Напечатать пустой чек",;
      IF ( fisc_cmd( @nConnect,,                       ;
                     "FSTART: MARIA_NULL"+LF+        ;
                     cCashMen+LF+         ;
                     cMariaPasswd+LF+                  ;
                     "FEND:"+LF,                     ;
                     nTimeOut, SERVER_ANSWER_MAXSIZE, scHost, snPort ;
                   )#0                               ;
         )
        ALERT( "Ошибка выполнения команды", { "Для продолжения нажмите клавишу Enter..." }, "GR+/R,N/W" )
      ENDIF
      CLEAR TYPEAHEAD
    CASE ( nChoice = 2 )
      // "2. Копия последнего чека",                 ;
      IF ( fisc_cmd( @nConnect,,                       ;
                     "FSTART: MARIA_COPY"+LF+        ;
                     cCashMen+LF+         ;
                     cMariaPasswd+LF+                  ;
                     "FEND:"+LF,                     ;
                     nTimeOut, SERVER_ANSWER_MAXSIZE, scHost, snPort ;
                   )#0                               ;
         )
        ALERT( "Ошибка выполнения команды", { "Для продолжения нажмите клавишу Enter..." }, "GR+/R,N/W" )
      ENDIF
      CLEAR TYPEAHEAD

    CASE ( nChoice = 3 )
      //"3. Прогнать чековую ленту",;
      //SET COLOR TO "G/N, N/W"
      @ y1+16+2, 3+1 SAY "Прогнать чековую ленту на"         ;
       GET nScrollType PICT "99" COLOR "G/N, N/W" RANG 0, 30
      @ y1+16+2, COL()+1 SAY "мм"
      SET CURSOR ON; READ; SET CURSOR OFF
      IF ( LASTKEY()=K_ENTER .AND. nScrollType # 0 )
        IF ( fisc_cmd( @nConnect,,                            ;
                       "FSTART: MARIA_LINEFEED"+LF+         ;
                       cCashMen+LF+              ;
                       cMariaPasswd+LF+                       ;
                       LTRIM( STR( nScrollType*8, 3 ) )+LF+ ;
                       "FEND:"+LF,                          ;
                       nTimeOut, SERVER_ANSWER_MAXSIZE, scHost, snPort      ;
                     )#0                                    ;
           )
          ALERT( "Ошибка выполнения команды", { "Для продолжения нажмите клавишу Enter..." }, "GR+/R,N/W" )
        ENDIF

      ENDIF

    CASE ( nChoice = 4 )
      //"4. Служебный ввод/вывод наличности",;
      nSumInOut:=0
      @ y1+16+2, 3+1 SAY "Введите сумму"               ;
       GET nSumInOut PICT "999999.99" COLOR "G/N, N/W"
      @ y1+16+2, COL()+1 SAY " положительная - ВНЕСЕНИЕ, отрицательная - ИЗЪЯТИЕ"
      SET CURSOR ON; READ; SET CURSOR OFF
      IF ( LASTKEY()=K_ENTER .AND. nSumInOut # 0 )
        IF ( fisc_cmd( @nConnect,,                       ;
                       "FSTART: MARIA_SLUG"+LF+        ;
                       cCashMen+LF+         ;
                       cMariaPasswd+LF+                  ;
                       LTRIM( STR( nSumInOut ) )+LF+   ;
                       "FEND:"+LF,                     ;
                       nTimeOut, SERVER_ANSWER_MAXSIZE, scHost, snPort ;
                     )#0                               ;
           )
          ALERT( "Ошибка выполнения команды", { "Для продолжения нажмите клавишу Enter..." }, "GR+/R,N/W" )
        ENDIF

      ENDIF

    CASE ( nChoice = 5 )
    //  " ",;
    CASE ( nChoice = 6 )
      //"5. Дневной отчет без обнуления (Х-отчет)",;
      IF ( fisc_cmd( @nConnect,,                       ;
                     "FSTART: MARIA_DAY_REPORT"+LF+  ;
                     cCashMen+LF+         ;
                     cMariaPasswd+LF+                  ;
                     "0"+LF+                         ;
                     "FEND:"+LF,                     ;
                     nTimeOut, SERVER_ANSWER_MAXSIZE, scHost, snPort ;
                   )#0                               ;
         )
        ALERT( "Ошибка выполнения команды", { "Для продолжения нажмите клавишу Enter..." }, "GR+/R,N/W" )
      ENDIF

    CASE ( nChoice = 7 )
    //"6. Отчет за указанный период",;
      nVibor:=ALERT(                                         ;
                     "Периодические отчеты (даты или номера)", ;
                     { "по Датам", "по Номерам" }, "N/W,GR+/BG" ;
                   )
      DO CASE
      CASE nVibor = 1
        dDataBeg:=BOM(DATE())
        dDataEnd:=EOM(DATE())
        @ y1+16+2, 3+1 SAY "Дата начала периода"         ;
         GET dDataBeg COLOR "G/N, N/W" VALID !EMPTY(dDataBeg)
        @ y1+16+3, 3+1 SAY "Дата  конца периода"         ;
         GET dDataEnd COLOR "G/N, N/W" VALID !EMPTY(dDataEnd) .AND. dDataEnd>=dDataBeg
        SET CURSOR ON; READ; SET CURSOR OFF

        IF ( LASTKEY()=K_ENTER  )
          IF ( fisc_cmd( @nConnect,,                       ;
                         "FSTART: MARIA_DATE_REPORT"+LF+  ;
                         cCashMen+LF+         ;
                         cMariaPasswd+LF+                  ;
                         LTRIM(STR(  DAY(dDataBeg),2))+LF+ ;
                         LTRIM(STR(MONTH(dDataBeg),2))+LF+ ;
                         LTRIM(STR( YEAR(dDataBeg),4))+LF+ ;
                         LTRIM(STR(  DAY(dDataEnd),2))+LF+ ;
                         LTRIM(STR(MONTH(dDataEnd),2))+LF+ ;
                         LTRIM(STR( YEAR(dDataEnd),4))+LF+ ;
                         "FEND:"+LF,                     ;
                         nTimeOut, SERVER_ANSWER_MAXSIZE, scHost, snPort ;
                       )#0                               ;
             )
            ALERT( "Ошибка выполнения команды", { "Для продолжения нажмите клавишу Enter..." }, "GR+/R,N/W" )
          ENDIF
        ENDIF
      CASE nVibor = 2
        nNumBeg:=0
        nNumEnd:=1
        @ y1+16+2, 3+1 SAY "Номер начального отчета"         ;
         GET nNumBeg COLOR "G/N, N/W" PICT "@K 9999" VALID !EMPTY(nNumBeg) RANGE 0,9999
        @ y1+16+3, 3+1 SAY "Номер конечного отчета"         ;
         GET nNumEnd COLOR "G/N, N/W" PICT "@K 9999" VALID !EMPTY(nNumBeg) .AND. nNumEnd>=nNumBeg RANGE 0,9999
        SET CURSOR ON; READ; SET CURSOR OFF

        IF ( LASTKEY()=K_ENTER  )
          IF ( fisc_cmd( @nConnect,,                       ;
                         "FSTART: MARIA_NUM_REPORT"+LF+  ;
                         cCashMen+LF+         ;
                         cMariaPasswd+LF+                  ;
                         LTRIM(STR(nNumBeg,4))+LF+ ;
                         LTRIM(STR(nNumEnd,4))+LF+ ;
                         "FEND:"+LF,                     ;
                         nTimeOut, SERVER_ANSWER_MAXSIZE, scHost, snPort ;
                       )#0                               ;
             )
            ALERT( "Ошибка выполнения команды", { "Для продолжения нажмите клавишу Enter..." }, "GR+/R,N/W" )
          ENDIF
        ENDIF
      OTHERWISE

      ENDCASE

    CASE ( nChoice = 8 )
      //"7. Дневной отчет с обнулением (Z-отчет)",;
      nVibor:=ALERT(                                         ;
                     "Дневной отчет с обнулением (Z-отчет)", ;
                     { "Отменить", "Обнулить" }, "GR+/R,N/W" ;
                   )
      IF ( nVibor = 2 )
        IF ( fisc_cmd( @nConnect,,                       ;
                       "FSTART: MARIA_DAY_REPORT"+LF+  ;
                       cCashMen+LF+         ;
                       cMariaPasswd+LF+                  ;
                       "1"+LF+                         ;
                       "FEND:"+LF,                     ;
                       nTimeOut, SERVER_ANSWER_MAXSIZE, scHost, snPort ;
                     )#0                               ;
           )
          ALERT( "Ошибка выполнения команды", { "Для продолжения нажмите клавишу Enter..." }, "GR+/R,N/W" )
          FCREATE('MARIA_DAY_REPORT.txt')  
        ENDIF

      ENDIF

    CASE ( nChoice = 9 )
    //" ",;
    CASE ( nChoice = 10 )
    //"8. Получить дату и время",;
    CASE ( nChoice = 11 )
    //" ",;
    CASE ( nChoice = 12 )
    //"9. Регистрационная информация о владельце",;
    CASE ( nChoice = 13 )
    //"0. Формирование внешнего вида чека",;
    CASE ( nChoice = 14 )
    //"A. Запрограммировать налог",;
    CASE ( nChoice = 15 )
    //"B. Характириска расчетной валюты",;
    CASE ( nChoice = 16 )
    //"C. Подвести часы реального времени";
    tTimeReal:=TIME()
      @ y1+16+2, 3+1 SAY "Введите текущие время ЧЧ:ММ:СС"         ;
       GET tTimeReal PICT "99:99:99" COLOR "G/N, N/W" VALID TIMEVALID( tTimeReal )
      SET CURSOR ON; READ; SET CURSOR OFF

      IF ( LASTKEY()=K_ENTER  )
      nVibor:=ALERT(                                         ;
                     "Записать текуще время?;"+;
                     "ВНИМАНИЕ!;"+;
                     "Операцию возможно выполнить 1 раз сутки после Z-отчета;"+;
                     "Изменение времени может составлять не более чем +-90 мин.", ;
                     { "Отменить", "Записать" }, "GR+/R,N/W" ;
                   )
      IF ( nVibor = 2 )
        IF ( fisc_cmd( @nConnect,,                       ;
                       "FSTART: MARIA_TIME"+LF+  ;
                       cCashMen+LF+         ;
                       cMariaPasswd+LF+                  ;
                       SUBSTR(tTimeReal,1,2)+LF+       ;//часы
                       SUBSTR(tTimeReal,4,2)+LF+       ;//минуты
                       SUBSTR(tTimeReal,7,2)+LF+       ;//секунды
                       "FEND:"+LF,                     ;
                       nTimeOut, SERVER_ANSWER_MAXSIZE, scHost, snPort ;
                     )#0                               ;
           )
          ALERT( "Ошибка выполнения команды", { "Для продолжения нажмите клавишу Enter..." }, "GR+/R,N/W" )
        ENDIF
        ENDIF

      ENDIF
    ENDCASE

    RESTORE SCREEN FROM cScr1

  ENDDO

  RETURN ( NIL )

