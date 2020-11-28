/***********************************************************
 * Модуль    : ViewFileText.prg
 * Версия    : 0.0
 * Автор     :
 * Дата      : 03/13/95
 * Изменен   :
 * Примечание: Текст обработан утилитой CF версии 2.02
 */

#include "fileio.ch"

//#define CR chr(13)
//#define LF chr(10)
//#define CRLF chr(13)+chr(10)

//Текущая позиция в файле
#define FTELL(handle) fseek(handle, 0, FS_RELATIVE)

STATIC nHandle              //Дескриптор открываемого файла
STATIC cLine                //Текущая строка
//STATIC nFileSize            //Размер файла
STATIC nPos := 1

/***********************************************************
 * ViewFileText() -->
 *   Параметры : имя файла
 *   Возвращает:
 */
FUNCTION ViewFileText(fname)
  LOCAL oTbr, oTbc ,cScr
  LOCAL nMAXROW, nMAXCOL, nSetColor
  nMAXROW:=MAXROW()-1
  nMAXCOL:=MAXCOL()
  nSetColor:=SETCOLOR(("BG+/B,BG+/B"))

  IF (lFileInit(fname))
    SAVE SCREEN TO cScr
    //CLEAR SCREEN
    @ 0, 0 CLEAR TO nMAXROW, nMAXCOL
    @ 0, 0 TO nMAXROW, nMAXCOL
    SETPOS(0, 1)
    //DISPOUT("[ "+fName+" ]", "RG+/B")
    oTbr := tbrowsenew(1, 1, nMAXROW-1, nMAXCOL-1)
    oTbc := tbColumnNew(, { || SUBSTR(cCurLine(), nPos) })
    oTbc:width := nMAXCOL-1 //78
    oTbr:addcolumn(oTbc)
    oTbr:colorSpec := "BG+/B,BG+/B"
    oTbr:goTopBlock := { || GetFirst() }
    oTbr:goBottomBlock := { || GetLast() }
    oTbr:skipBlock := { | n | skipper(n) }
    myBrowse(oTbr)
    CLEAR SCREEN
    RESTORE SCREEN FROM cScr
    SETCOLOR(nSetColor)

  ENDIF

  RETURN (NIL)

/***********************************************************
 * cCurLine() -->  Возврат текущей строки
 *   Параметры :
 *   Возвращает:
 */
STATIC FUNCTION cCurLine
  RETURN (cLine)
#define MAX_LINE_LEN 256

/***********************************************************
 * lFileInit() -->
 *   Подпрограмма инициализации - открытие файла, установка
 *   nFileSize
 *   и прием первой строки
 *   Параметры :
 *   Возвращает:
 */
STATIC FUNCTION lFileInit(nFname)

  IF (nHandle := fopen(nFname, 0)) # 0
    fseek(nHandle, 0, FS_END)
    //nFileSize := FTELL(nHandle)
    GetFirst()
  ENDIF

  RETURN (nHandle != 0)

/***********************************************************
 * GetFirst() --> Чтение первой строки и запись ее в переменную cline
 *   Параметры :
 *   Возвращает:
 */
STATIC FUNCTION GetFirst
  fseek(nHandle, 0, FS_SET)
  lfreadln(nHandle, @cline)
  fseek(nHandle, 0, FS_SET)

  RETURN (NIL)

/***********************************************************
 * lfreadln() -->
 *   Параметры :
 *   Возвращает:
 */
STATIC FUNCTION lfreadln(nHandle, cBuffer)

  LOCAL nEol, nRead, nSavePos

  cBuffer := space(MAX_LINE_LEN)

  //Сначала сохраним текущий указатель файла
  nSavePos = FTELL(nHandle)
  nRead = fread(nHandle, @cBuffer, MAX_LINE_LEN)

  IF (nEol := at(CRLF, substr(cBuffer, 1, nRead))) = 0
    //Переполнение строки или конец файла (EOF)
  //Cline содержит интересующую нас строку
  ELSE
    //Копируем вплоть до конца строки
    cBuffer := substr(cBuffer, 1, nEol - 1)
    //Устанавливаем указатель файла на следующую строку
    fseek(nHandle, nSavePos + nEol + 1, FS_SET)
  ENDIF

  RETURN (nRead != 0)

/***********************************************************
 * GetLast() -->
 * Чтение последней строки файла и запись ее в переменную
 *  cline
 *   Параметры :
 *   Возвращает:
 */
STATIC FUNCTION GetLast

  fseek(nHandle, 0, FS_END)
  lGoPrevLn()

  RETURN (NIL)

/***********************************************************
 * skipper() -->
 *   Параметры :
 *   Возвращает:
 */
STATIC FUNCTION skipper(n)
  //Пропуск n строк файла. n может быть как положительным, так
  //и отрицательным числом

  LOCAL nSkipped := 0

  IF (n > 0)
    WHILE (nSkipped != n .AND. lGoNextLn())
      nSkipped++
    ENDDO

  ELSE
    WHILE (nSkipped != n .AND. lGoPrevLn())
      nSkipped--
    ENDDO

  ENDIF

  RETURN (nSkipped)

/***********************************************************
 * lGoNextLn() -->
 *   Параметры :
 *   Возвращает:
 */
STATIC FUNCTION lGoNextLn()
  //Пытается перейти к следующей строке файла

  //Возвращает .T. если попытка удалась и .F. в противном случае

  LOCAL nSavePos := FTELL(nHandle), cBuff := "", lMoved, nNewPos

  fseek(nHandle, len(cLine) + 2, FS_RELATIVE)
  nNewPos := FTELL(nHandle)
  IF (lfreadLn(nHandle, @cBuff))
    lMoved := .T.
    cLine := cBuff
    fseek(nHandle, nNewPos, FS_SET)
  ELSE
    lMoved := .F.
    fseek(nHandle, nSavePos, FS_SET)
  ENDIF

  RETURN (lMoved)

/***********************************************************
 * lGoPrevLn() -->
 *   Параметры :
 *   Возвращает:
 */
STATIC FUNCTION lGoPrevLn()
  //Пытается перейти к предыдущей строке файла
  //Возвращает .T. если попытка удалась и .F. в противном случае

  LOCAL nOrigPos := FTELL(nHandle), nMaxRead, nNewPos, ;
   lMoved, cBuff, nWhereCrLf, nPrev, cTemp
  cTemp := "  "
  IF (nOrigPos == 0)
    lMoved := .F.
  ELSE
    lMoved := .T.
    //Проверим CR/LF в предыдущих двух символах
    fseek(nHandle, -2, FS_RELATIVE)
    fread(nHandle, @cTemp, 2)
    IF (cTemp == CRLF)
      fseek(nHandle, -2, FS_RELATIVE)
    ENDIF

    nMaxRead := MIN(MAX_LINE_LEN, FTELL(nHandle))
    cBuff := space(nMaxRead)
    nNewPos := fseek(nHandle, -nMaxRead, FS_RELATIVE)
    fread(nHandle, @cBuff, nMaxRead)
    nWhereCrLf := rat(CRLF, cBuff)
    IF (nWhereCrLf = 0)
      nPrev := nNewPos
      cLine := cBuff
    ELSE
      nPrev := nNewPos + nWhereCrLf + 1
      cline := substr(cBuff, nWhereCrLf + 2)
    ENDIF

    fseek(nHandle, nPrev, FS_SET)
  ENDIF

  RETURN (lMoved)

#include "inkey.ch"

/***********************************************************
 * myBrowse() -->
 *   Параметры :
 *   Возвращает:
 */
STATIC FUNCTION myBrowse(oTbr)
//По умолчанию управление находится в данной подпрограмме,
//пока пользователь не нажмет Esc и Enter

LOCAL nKey, lExitRequested := .F., bAction

WHILE (!lExitRequested)
  WHILE (nextkey() == 0 .AND. !oTbr:stabilize())
  ENDDO

  nKey := inkey(0)
  IF (!stdMeth(nKey, oTbr))
    DO CASE
    CASE (bAction := SETKEY(nKey)) != NIL
      EVAL(bAction, PROCNAME(), PROCLINE(), READVAR())
    CASE (nKey == K_ESC .OR. nKey == K_ENTER)
      lExitRequested := .T.

    ENDCASE

  ENDIF
ENDDO
  RETURN (NIL)

/***********************************************************
 * stdMeth() -->
 *   Параметры :
 *   Возвращает:
 */
STATIC FUNCTION stdMeth(nKey, oTbr)

  LOCAL lKeyHandled := .T.

  DO CASE
  CASE  nKey == K_DOWN
     oTbr:down()
  CASE  nKey == K_UP
     oTbr:up()
CASE  nKey == K_PGDN
    oTbr:pagedown()
CASE  nKey == K_PGUP
     oTbr:pageup()
CASE  nKey == K_CTRL_PGUP
    oTbr:gotop()
CASE  nKey == K_CTRL_PGDN
    oTbr:gobottom()
  CASE  nKey == K_RIGHT
    oTbr:right()
    MovePos(nKey, oTbr)
  CASE (nKey == K_LEFT)
    oTbr:left()
    MovePos(nKey, oTbr)
CASE  nKey == K_HOME
    oTbr:home()
    MovePos(nKey, oTbr)
CASE  nKey == K_END
    oTbr:END()
    MovePos(nKey, oTbr)
CASE  nKey == K_CTRL_LEFT
    oTbr:panleft()
CASE  nKey == K_CTRL_RIGHT
    oTbr:panright()
CASE  nKey == K_CTRL_HOME
    oTbr:panhome()
CASE  nKey == K_CTRL_END
    oTbr:panend()
  OTHERWISE; lKeyHandled := .F.
  ENDCASE

  RETURN (lKeyHandled)

/***********************************************************
 * MovePos() -->
 *   Параметры :
 *   Возвращает:
 */
STATIC FUNCTION MovePos(nKey, oTbr)
  DO CASE
  CASE (nKey == K_LEFT)
    IF (nPos > 1)
      nPos--
      oTbr:refreshAll()
    ENDIF

  CASE (nKey == K_RIGHT)
    IF (nPos < len(cCurLine()))
      nPos++
      oTbr:refreshAll()
    ENDIF

  CASE (nKey == K_HOME)
    nPos := 1
    oTbr:refreshAll()
  CASE (nKey == K_END)
    nPos := len(cCurLine())
    oTbr:refreshAll()
  ENDCASE

  RETURN (nPos)

