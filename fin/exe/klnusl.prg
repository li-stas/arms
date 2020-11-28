/*****************************************************************
 
 FUNCTION: Uslovia()
 €‚’Ž..„€’€..........‘. ‹¨â®¢ª   11.05.04 * 09:28:29
 €‡€—…ˆ…......... ¢¢®¤ ãá«®¢¨© à ¡®âë
 €€Œ…’›..........
 ‚Ž‡‚. ‡€—…ˆ…....
 ˆŒ…—€ˆŸ.........
 */
#Include "Common.ch"
#Include "CondGet.ch"
MEMVAR GetLiSt
FUNCTION  Uslovia(lReadDopUsl, lRead)
  LOCAL nSelectOld
  PUBLIC   Zat61_Pr,  Zat61_Sumr,  Zat46_Lr, Zat46_Pr,  Zat46_Sumr,  Pst_Lr, Tov_Othr, Tov_Oth1r,  Dt_BEGr, Dt_ENDr, ChkNZenr

  DEFAULT  lRead TO FALSE
  nSelectOld:=SELECT()

  Kln->(NetSeek("T1", "Kklr"))
  SELECT kln

  MEMVAR->Zat61_Pr   := _FIELD->Zat61_P
  MEMVAR->Zat61_Sumr := _FIELD->Zat61_Sum
  MEMVAR->Zat46_Pr   := _FIELD->Zat46_P
  MEMVAR->Zat46_Lr   := _FIELD->Zat46_L
  MEMVAR->Zat46_Sumr := _FIELD->Zat46_Sum
  MEMVAR->Pst_Lr     := _FIELD->Pst_L
  MEMVAR->ChkNZenr   := _FIELD->ChkNZen
  MEMVAR->Tov_Othr   := _FIELD->Tov_Oth
  if fieldpos('tov_oth1')#0
     MEMVAR->Tov_Oth1r   := _FIELD->Tov_Oth1
  else
     MEMVAR->Tov_Oth1r   := 0
  endif
  MEMVAR->Dt_BEGr    := _FIELD->Dt_BEG //IIF(EMPTY(_FIELD->Dt_BEG),      DATE(), _FIELD->Dt_BEG)
  MEMVAR->Dt_ENDr    := _FIELD->Dt_END //IIF(EMPTY(_FIELD->Dt_END), ADDMONTH(1), _FIELD->Dt_END)

  @ 13, 20+20 SAY "’à ­á¯®àâ­ë¥    "     GET Zat61_Pr WHEN  lReadDopUsl .AND. Zat61_Sumr = 0 VALID Zat61_Pr >= 0
  @ ROW(), COL()+1 SAY "%"         GET Zat61_Sumr     WHEN  lReadDopUsl .AND. Zat61_Pr = 0 VALID  Zat61_Sumr>= 0
  //@ 14, 20+20 SAY "Žä®à¬«¥­¨¥ ¤®ªã¬"  GET Zat46_Pr WHEN  lReadDopUsl .AND. Zat46_Sumr = 0 VALID Zat46_Pr >= 0
  //@ ROW(), COL()+1 SAY "%"         GET Zat46_Sumr  WHEN  lReadDopUsl .AND. Zat46_Pr = 0 VALID  Zat46_Sumr >= 0
  @ 14, 20+20 SAY "Žä®à¬«¥­¨¥ ¤®ªã¬" CONDGET Zat46_Lr WHEN  lReadDopUsl
  @ 15, 20+20  SAY "‘â¥ª«®â à  ¢®§¢" CONDGET MEMVAR->Pst_Lr WHEN  lReadDopUsl
  @ 16, 20+20  SAY "à®¢¥àïâì min æ¥­ã" CONDGET MEMVAR->ChkNZenr WHEN  lReadDopUsl
  @ 17, 20+20  SAY "Žáâ «ì­®© â®¢ à ­ æ "  GET Tov_Othr WHEN  lReadDopUsl;
  VALID  (;
  Kln->(NetSeek("T1", "Kklr")),;
            MEMVAR->Dt_BEGr:=IIF(EMPTY(Kln->Dt_BEG),      DATE(), Kln->Dt_BEG),;
            MEMVAR->Dt_ENDr:=IIF(EMPTY(Kln->Dt_END), ADDMONTH(1), Kln->Dt_END),;
            TRUE  ;
           )
  @ 17, col()+1  GET Tov_Oth1r WHEN  lReadDopUsl;
  VALID  (;
  Kln->(NetSeek("T1", "Kklr")),;
            MEMVAR->Dt_BEGr:=IIF(EMPTY(Kln->Dt_BEG),      DATE(), Kln->Dt_BEG),;
            MEMVAR->Dt_ENDr:=IIF(EMPTY(Kln->Dt_END), ADDMONTH(1), Kln->Dt_END),;
            TRUE  ;
           )
  @ ROW(), COL()+1 SAY "%"
  @ 18, 20+20  SAY "„¥©áâ ãá«®¢ á"     GET Dt_BEGr WHEN  lReadDopUsl //VALID !EMPTY(Dt_BEGr)
  @ ROW(), COL()+1 SAY " ¯®"           GET Dt_ENDr WHEN  lReadDopUsl VALID Dt_ENDr >= Dt_BEGr // .AND. !EMPTY(Dt_ENDr)

  IF lRead
    SET CURSOR ON; READ; SET CURSOR OFF
  ENDIF
  SELECT (nSelectOld)

  RETURN (NIL)

