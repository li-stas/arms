/*****************************************************************
 FUNCTION: Condget(oGet)
 АВТОР..............С. Литовка
 ДАТА...............27.01.96 * 12:24:54
 НАЗНАЧЕНИЕ.........ввод логических значение и изменений засчет пробела или букв
 ПАРАМЕТРЫ.......... oGet
 ВОЗВР. ЗНАЧЕНИЕ.... Variable  новый объект
 ПРИМЕЧАНИЯ......... из RGEN вызывается  путем ввода @..CONDGET см #Include "CondGet.ch"
 */

#include "Getexit.ch"
#Include "Common.ch"
#Include "InKey.ch"

STATIC slUpdated := .F.

/***********************************************************
 * Condget() -->
 *   Параметры :
 *   Возвращает:
 */
FUNCTION Condget(oGet)

  LOCAL vVar := oGet:Block
  LOCAL sStr := IIF(oGet:Varget(), "ДА ", "НЕТ")

  oGet:Block := { | _bUndef |                                          ;
                  sStr:=IIF(EVAL(vVar) .AND. sStr == "НЕТ",      ;//
                             "ДА ",                                 ;//
                             IIF(!EVAL(vVar) .AND. sStr == "ДА ",;// при повторном входе
                                  "НЕТ",                            ;// корретировка значений
                                  sStr                              ;// т. к . переменная GET может изменить свое значение
                               )                                   ;//
                          ),                                       ;//
                  IIF(PCOUNT() > 0,                                   ;
                       (EVAL(vVar, (sStr := _bUndef) == "ДА ")), ;
                       NIL                                             ;
                    ), sStr                                           ;
                }
  oGet:Reader := { | _bUndef |Condreader(_bUndef) }
  IF (oGet:changed)
    slUpdated := .T.
  ENDIF
  oGet:Display()

  RETURN (oGet)

/***********************************************************
 * Condreader
 *   Параметры: oGet
 */
STATIC PROCEDURE Condreader(oGet)

  LOCAL vVar := oGet:Exitstate()
  LOCAL nNum, _Undef

  IF (Getprevali(oGet))

    oGet:Setfocus()

    WHILE (oGet:Exitstate() == GE_NOEXIT)

      WHILE (oGet:Exitstate() == GE_NOEXIT)

        IF (_Undef := SetKey(nNum := Inkey(0))) <> NIL

          Getdosetke(_Undef, oGet)
          LOOP

        ENDIF

        IF (nNum == K_SPACE)

          oGet:VarPut(IF(oGet:VarGet() <> "ДА ", "ДА ", "НЕТ"))
          oGet:changed := TRUE

        ELSEIF (CHR(nNum) $ "YyTtДд")

          oGet:VarPut("ДА ")
          oGet:changed := TRUE

        ELSEIF (CHR(nNum) $ "NnFfНн")

          oGet:VarPut("НЕТ")
          oGet:changed := TRUE

        ELSEIF (nNum < 32 .OR. nNum > 255)

          GetApplyKey(oGet, nNum)

        ELSE

          LOOP

        ENDIF

        oGet:UpdateBuffer()

      ENDDO

      IF (!GetPostValidate(oGet))

        oGet:ExitState := GE_NOEXIT

      ENDIF

    ENDDO

    oGet:KillFocus()

  ENDIF

  RETURN

/***
*
*  Updated()
*
*/
FUNCTION UpdatedCondGet()
   RETURN slUpdated
