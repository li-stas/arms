/*****************************************************************
 FUNCTION: Condget(oGet)
 ............... ¨â®¢ª 
 ...............27.01.96 * 12:24:54
 .........¢¢®¤ «®£¨ç¥áª¨å §­ ç¥­¨¥ ¨ ¨§¬¥­¥­¨© § áç¥â ¯à®¡¥«  ¨«¨ ¡ãª¢
 .......... oGet
 . .... Variable  ­®¢ë© ®¡ê¥ªâ
 ......... ¨§ RGEN ¢ë§ë¢ ¥âáï  ¯ãâ¥¬ ¢¢®¤  @..CONDGET á¬ #Include "CondGet.ch"
 */

#include "Getexit.ch"
#Include "Common.ch"
#Include "InKey.ch"

STATIC slUpdated := .F.

/***********************************************************
 * Condget() -->
 *    à ¬¥âàë :
 *   ®§¢à é ¥â:
 */
FUNCTION Condget(oGet)

  LOCAL vVar := oGet:Block
  LOCAL sStr := IIF(oGet:Varget(), " ", "")

  oGet:Block := { | _bUndef |                                          ;
                  sStr:=IIF(EVAL(vVar) .AND. sStr == "",      ;//
                             " ",                                 ;//
                             IIF(!EVAL(vVar) .AND. sStr == " ",;// ¯à¨ ¯®¢â®à­®¬ ¢å®¤¥
                                  "",                            ;// ª®àà¥â¨à®¢ª  §­ ç¥­¨©
                                  sStr                              ;// â. ª . ¯¥à¥¬¥­­ ï GET ¬®¦¥â ¨§¬¥­¨âì á¢®¥ §­ ç¥­¨¥
                               )                                   ;//
                          ),                                       ;//
                  IIF(PCOUNT() > 0,                                   ;
                       (EVAL(vVar, (sStr := _bUndef) == " ")), ;
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
 *    à ¬¥âàë: oGet
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

          oGet:VarPut(IF(oGet:VarGet() <> " ", " ", ""))
          oGet:changed := TRUE

        ELSEIF (CHR(nNum) $ "YyTt¤")

          oGet:VarPut(" ")
          oGet:changed := TRUE

        ELSEIF (CHR(nNum) $ "NnFf­")

          oGet:VarPut("")
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
