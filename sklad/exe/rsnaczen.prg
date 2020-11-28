/***********************************************************
 * Модуль    : rsnaczen.prg
 * Версия    : 0.0
 * Автор     :
 * Дата      : 05/12/04
 * Изменен   :
 * Примечание: Текст обработан утилитой CF версии 2.02
 */

//*#define DEBUG
#define NEW_RSDOGZEN
#include "Common.ch"
#include "inkey.ch"
MEMVAR tarar, KpvR, KplR
MEMVAR GetList

*/*****************************************************************
* 
* FUNCTION: RsNacZen()
* АВТОР..ДАТА..........С. Литовка  12.05.04 * 11:02:56
* НАЗНАЧЕНИЕ......... расчет цен по фиксированным условиям
* ПАРАМЕТРЫ..........
* ВОЗВР. ЗНАЧЕНИЕ....
* ПРИМЕЧАНИЯ.........
* */

/*****************************************************************
 
 FUNCTION: UslovCheck()
 АВТОР..ДАТА..........С. Литовка  14.05.04 * 12:37:30
 НАЗНАЧЕНИЕ......... //проверим действия  условий
 ПАРАМЕТРЫ..........
 ВОЗВР. ЗНАЧЕНИЕ.... ДА НЕТ - действия условий
 ПРИМЕЧАНИЯ.........
 */
STATIC FUNCTION UslovCheck()
   LOCAL lRet
   lRet:=TRUE
   //проверим действия  условий
   DO CASE
   CASE (EMPTY(Kpl->dtnace))
      //нет условий для договорных цен
      wmess('Нет условий для договорных цен', 3)
      lRet:=FALSE
   CASE (.T. .AND. Kpl->dtnace < MEMVAR->gdTd)
      //срок условий закончился
      wmess('Срок условий с '+ DTOC(Kpl->dtnacb) +" по "+ DTOC(Kpl->dtnace)+' закончился', 3)
      lRet:=FALSE
   ENDCASE
   CLEAR TYPEAHEAD

   RETURN (lRet)

/*****************************************************************
 
 FUNCTION: Usl4Pst()
 АВТОР..ДАТА..........С. Литовка  14.05.04 * 11:38:10
 НАЗНАЧЕНИЕ......... получении дог условий на стеклотару
 ПАРАМЕТРЫ..........
 ВОЗВР. ЗНАЧЕНИЕ....
 ПРИМЕЧАНИЯ.........
 */
FUNCTION Usl4Pst(bReplOldPst)
   LOCAL nRecNo_Kln
   DEFAULT bReplOldPst TO { || _FIELD->pst:=IIF(tarar=0, 1, 0) }
   //условия для стеклотары
   //nKkl := IIF(KpvR = 0, KplR, KpvR)
   //найдем по нему данные
   nRecNo_Kln:=Kln->(RECNO())
*   Kln->(NetSeek('T1',iif(kpvr=0,'KplR','kpvr')))
*   Kln->(NetSeek('T1','nkklr'))
   Kpl->(NetSeek('T1','kplr'))
   IF (Kpl->(UslovCheck()))
      repl pst with Kpl->pst
      MEMVAR->pstr:= _FIELD->pst
   ELSE                        //условий нет или они закончились
      EVAL(bReplOldPst)
   /*
   if tarar=0
       repl pst with 1
   else
       repl pst with 0
   endif
   */
   ENDIF

   Kln->(DBGOTO(nRecNo_Kln))
   RETURN (NIL)

/*****************************************************************
 
 FUNCTION: Usl4Zat_61()
 АВТОР..ДАТА..........С. Литовка  14.05.04 * 12:45:49
 НАЗНАЧЕНИЕ......... добавление услуг по условиям
 ПАРАМЕТРЫ..........
 ВОЗВР. ЗНАЧЕНИЕ....
 ПРИМЕЧАНИЯ.........
 */
FUNCTION Usl4Zat_61(lUpdate)
   LOCAL nRecNo_Kln
   LOCAL nSelect
   MEMVAR ttnr

   DEFAULT lUpdate TO FALSE
   nSelect:=SELECT()
   //найдем по нему данные
   nRecNo_Kln:=Kln->(RECNO())

   ///////////   61 - статья затрат  /////////////
   rs3->(netseek('t1', 'ttnr'))
   SELECT rs3
   LOCATE FOR rs3->Ksz = 61 WHILE rs3->ttn = ttnr
   IF (!FOUND())
      netadd()
      netrepl('ttn,ksz,ssf,bssf,pr,bpr', 'ttnr,61,Kpl->smksz61,Kpl->smksz61,Kpl->prksz61,Kpl->prksz61')
   ELSE
      IF (lUpdate)
         netrepl('ttn,ksz,ssf,bssf,pr,bpr', 'ttnr,61,Kpl->smksz61,Kpl->smksz61,Kpl->prksz61,Kpl->prksz61')
      ENDIF

   ENDIF

   SELECT (nSelect)

   Kln->(DBGOTO(nRecNo_Kln))

   RETURN (NIL)


/*****************************************************************
 
 FUNCTION: Usl4Zat_46()
 АВТОР..ДАТА..........С. Литовка  28.05.04 * 08:53:00
 НАЗНАЧЕНИЕ......... расчет суммы оформления документов по цене 17коп за изготовителя
 ПАРАМЕТРЫ..........
 ВОЗВР. ЗНАЧЕНИЕ....
 ПРИМЕЧАНИЯ.........
 */
FUNCTION Usl4Zat_46(lUpdate)
   LOCAL nRecNo_Kln, aIzg
   LOCAL nSelect
   MEMVAR ttnr, Zat46_Sumr, Zat46_Pr
   PRIVATE  Zat46_Sumr, Zat46_Pr

   DEFAULT lUpdate TO FALSE
   nSelect:=SELECT()
   //найдем по нему данные
   nRecNo_Kln:=Kln->(RECNO())
*   Kln->(NetSeek('T1',iif(kpvr=0,'KplR','kpvr')))
   Kpl->(NetSeek('T1','nkklr'))

   ///////////   46 - статья затрат  /////////////
   Zat46_Sumr:=0
   Zat46_Pr:=0
   IF .T.
    IF Kpl->ksz46=1 //оформление документов (сертификаты  считать?)
       //подсчитаем к-во производителей или маркодержателей
       aIzg:={}
       rs2->(netseek('t1', 'ttnr'))
       rs2->(DBEVAL({ ||                                                          ;
                        IIF(EMPTY(aIzg) .OR. EMPTY(ASCAN(aIzg, rs2->Izg)),   ;
                              (AADD(aIzg, rs2->Izg)),                           ;
                              NIL                                                    ;
                           )                                                        ;
                      },;
                      {|| int(rs2->ktl/1000000) > 1 }, ;//только для товара
                      { || rs2->ttn = ttnr }                                     ;
                   )                                                                ;
           )


       //к-во умножим на 17коп и запишим
       Zat46_Sumr:=VAL("0.15") * LEN(aIzg)
       Zat46_Pr:=0
    ENDIF
   ELSE
     Zat46_Sumr:=Kpl->smksz46
     Zat46_Pr:=Kpl->prksz46
   ENDIF

   SELECT rs3
   rs3->(netseek('t1', 'ttnr'))
   LOCATE FOR rs3->Ksz = 46 WHILE rs3->ttn = ttnr
    IF (!FOUND())
      netadd()
      netrepl('ttn,ksz,ssf,bssf,pr,bpr', 'ttnr,46,Zat46_Sumr,Zat46_Sumr,Zat46_Pr,Zat46_Pr')
    ELSE
      IF (lUpdate)
          netrepl('ttn,ksz,ssf,bssf,pr,bpr', 'ttnr,46,Zat46_Sumr,Zat46_Sumr,Zat46_Pr,Zat46_Pr')
      ENDIF
    ENDIF

   SELECT (nSelect)

   Kln->(DBGOTO(nRecNo_Kln))

  RETURN (NIL)

/*****************************************************************
 
 FUNCTION: CreateFiltNamTov()
 АВТОР..ДАТА..........С. Литовка  10.06.04 * 08:57:24
 НАЗНАЧЕНИЕ......... получение фильтара по наименованию
 ПАРАМЕТРЫ..........
 ВОЗВР. ЗНАЧЕНИЕ....
 ПРИМЕЧАНИЯ.........
 */
FUNCTION CreateFiltNamTov(forNaT)
  LOCAL cChrSeek, cChrSeekNorm
  LOCAL aItem

  IF forNaT=".AND..T."
    forNaT:=SPACE(60)
  ELSE
    forNaT:=PADR(SUBSTR(forNaT,6),60)
  ENDIF

  cChrSeek:=forNaT

  aItem:=SaveRestImage()
  @ MAXROW()-1, 0 SAY "Условие фильтра:" GET  cChrSeek PICT "@K" COLOR "G/N,N/BG"
  SET CURSOR ON; READ; SET CURSOR OFF

  IF LASTKEY()=K_ENTER .AND. !EMPTY(cChrSeek)
    cChrSeek:=ALLTRIM(cChrSeek)
    DO CASE
    CASE LEN(cChrSeek) = 7 .AND. VAL(cChrSeek) # 0
      MakeBlockSeek(cChrSeek, @cChrSeekNorm, "str(mntov,7)")
    CASE .F.
      //
    OTHERWISE
      MakeBlockSeek(cChrSeek, @cChrSeekNorm, "UPPER(NaT)")
    ENDCASE
    @ MAXROW()-1, 0 SAY cChrSeekNorm
    forNaT:=".AND."+cChrSeekNorm
  ELSE
    forNaT:=".AND..T."
  ENDIF

  SaveRestImage(aItem)
  RETURN (NIL)

/*****************************************************************
 
 FUNCTION: MakeBlockSeek
 АВТОР..ДАТА..........С. Литовка  18.08.01 * 11:39:04
 НАЗНАЧЕНИЕ......... разборка введенной строки и создание блока поиска
 ПАРАМЕТРЫ.......... cChrSeek -строка поиска
                     cBlockSeek - разработанная строка поиска
 ВОЗВР. ЗНАЧЕНИЕ....
 ПРИМЕЧАНИЯ.........
 */
FUNCTION MakeBlockSeek(cChrSeek, cChrSeekNorm, cInclude)
  LOCAL bBlockSeek, cBlockSeek, nWord, cWord, lWordLocic
  LOCAL cSaveToken

  DEFAULT cInclude TO "UPPER(_FIELD->Name)"

  cSaveToken:=SAVETOKEN()

  lWordLocic:=FALSE

  //разборка введенной строки
  cBlockSeek:=""
  nWord:=0
  TOKENINIT(@cChrSeek, CHR(32)+[#/-№"'])
  // .# -№"'
  WHILE (!TOKENEND())
    cWord := TOKENNEXT(cChrSeek)
    nWord++
    DO CASE
    CASE (cWord="AND")
      //первыми не могут быть
      IF (nWord#1 .AND. !lWordLocic .AND. !lWordLocic_AND_OR)
        cBlockSeek+=".AND."
        lWordLocic_AND_OR:=TRUE
      ENDIF

    CASE (cWord="OR")
      //первыми не могут быть
      IF (nWord#1 .AND. !lWordLocic .AND. !lWordLocic_AND_OR)
        cBlockSeek+=".OR. "
        lWordLocic_AND_OR:=TRUE
      ENDIF

    CASE (cWord="NOT")
      cBlockSeek+=".NOT."
      lWordLocic:=TRUE
    OTHERWISE
      IF (nWord#1 .AND. !lWordLocic .AND. !lWordLocic_AND_OR)
        //если есть слова и нет лог связки то содимяем через И
        cBlockSeek+=".AND."
      ENDIF

      cBlockSeek+='"'+UPPER(cWord)+'"'+"$"+cInclude
      lWordLocic:=FALSE
      lWordLocic_AND_OR:=FALSE
    ENDCASE

  ENDDO

  IF (lWordLocic .OR. lWordLocic_AND_OR)
    cBlockSeek:=LEFT(cBlockSeek, LEN(cBlockSeek)-5)
  ENDIF

  cChrSeekNorm:=cBlockSeek
  cBlockSeek:="{||"+cBlockSeek+"}"
  //скомпилируем и произведем поиск
  bBlockSeek:=&cBlockSeek

  RESTTOKEN(cSaveToken)

  RETURN (bBlockSeek)

/*****************************************************************
 
 FUNCTION: SaveRestImage()
 АВТОР..ДАТА........  С. Литовка  09/04/97 * 10:22:34
 НАЗНАЧЕНИЕ.........
 */
FUNCTION SaveRestImage(aItem)
   IF (ISNIL(aItem))       //запись окружения
      aItem:={               ;
               SETCOLOR(),    ;//1
               SETCURSOR(),   ;//2
               SAVEGETS(),    ;//3
               SAVESETKEY(),  ;//4
               SELECT(),      ;//5
               ROW(),         ;//6
               COL()          ;//7
             }
   ELSE
      SETCOLOR(aItem[ 1 ])
      SETCURSOR(aItem[ 2 ])
      RESTGETS(aItem[ 3 ])
      RESTSETKEY(aItem[ 4 ])
      SELECT (aItem[ 5 ])
      DEVPOS(aItem[ 6 ], aItem[ 7 ])
   ENDIF

   RETURN (aItem)


