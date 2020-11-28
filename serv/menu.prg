#include "common.ch"
#include "inkey.ch"
*************************************************************************
* Њ…Ќћ ЂђЊ 
*************************************************************************
@ 0,2 Say gcNskl
pzcr=1
I := 1
MEMO_I := I
MEMO_MNU := MNU
DO WHILE .T.
   SETCOLOR("gr+/g,,,,")
   clea
   @ 0,1 say alltrim(gcName_cc)+' '+menu2[pzcr]+' Џгвм '+gcPath_e+iif(gnEntrm=0,' ‘г¬л',' '+iif(gnRmsk=3,'ђ®¬­л',iif(gnRmsk=4,'Љ®­®в®Ї',iif(gnRmsk=5,'®бвЄ ','ЂевлаЄ '))))
   do case
      case gnArm=1 && Ђ¤¬Ё­Ёбва в®а
           sss='"‘Є« ¤ "'+ gcNskl
      case gnArm=2 && ”Ё­ ­бЁбв
           sss=''
           @12 + 1, 3 say "                     "
           @ROW() + 1, 3 say "                             ЮЫЫЫЭ  Ы  Ы  Ы  Ы  ЮЫЫЫ  Ы  Ы  ЮЫЫЭ  Ы    Ы"
           @ROW() + 1, 3 say "                             Ы Ы Ы  Ы  Ы  Ы  Ы  Ы  Ы  Ы  Ы  Ы  Ы  ЫЫЫЭ Ы"
           @ROW() + 1, 3 say "                             Ы Ы Ы  ЫЮЫЫ  Ы  Ы  Ы  Ы  Ы  Ы  Ы     Ы  Ы Ы"
           @ROW() + 1, 3 say "                             ЮЫЫЫЭ  ЫЫЭЫ  ЫЫЫЫ  ЫЫЫЫ  ЫЫЫЫ  Ы  Ы  Ы  Ы Ы"
           @ROW() + 1, 3 say "                               Ы    Ы  Ы  Ы  Ы  Ы  Ы  Ы  Ы  ЮЫЫЭ  ЮЫЫЭ Ы"
           @ROW() + 1, 3 say "                     "
           @ROW() + 1, 3 say "                     "
           @ROW() + 1, 3 say "                             “—…’ „…Ќ…†Ќ›• ‘ђ…„‘’‚ ЌЂ ЃЂ‹ЂЌ‘Ћ‚›• ‘—…’Ђ•"
           @ROW() + 1, 3 say "                     "
      case gnArm=3 && ‘Є« ¤
           sss='"‘Є« ¤ "'+str(gnSk)+' '+gcNskl
           @ 1,30 say fnlrsay
           @ 12,3      say "                    "
           @ row()+1,3 say "                                  ЫЫЫЭ ЮЫ ЮЫ  ЫЫЫЫ  ЫЫЫЫ  ЮЫЫЫЭ"
           @ row()+1,3 say "                                 ЮЫ ЮЫ ЮЫ ЫЭ ЮЫ ЮЫ ЮЫ ЮЫ  ЫЭ ЫЭ"
           @ row()+1,3 say "                                 ЮЫ    ЮЫЫЫ  ЮЫ ЮЫ ЮЫ ЮЫ  ЫЭ ЫЭ"
           @ row()+1,3 say "                                 ЮЫ ЮЫ ЮЫ ЫЭ ЮЫ ЮЫ ЮЫЫЫЫ  ЫЭ ЫЭ"
           @ row()+1,3 say "                                  ЫЫЫЭ ЮЫ ЮЫ ЫЫ ЮЫ ЮЫ ЮЫ ЫЫЫЫЫЫ"
           @ row()+1,3 say "                                                         Я    Я"
           @ row()+1,3 say "                    "
      case gnArm=4 && Њ аЄҐвЁ­Ј
           sss=''
           @ 12,3      say "                    "
           @ row()+1,3 say "      ЫЫЫ   ЫЫЫ  ЫЫЫЫЫ ЫЫЫЫЫ   ЫЫ   ЫЫ ЫЫЫЫЫ ЫЫЫЫЫЫ ЫЫ   ЫЫ ЫЫ    ЫЫ ЫЫЫЫЫ "
           @ row()+1,3 say "      ЫЫ Ы Ы ЫЫ ЫЫ  ЫЫ ЫЫ   ЫЫ ЫЫ  ЫЫ  ЫЫ      ЫЫ   ЫЫ   ЫЫ ЫЫ    ЫЫ ЫЫ    "
           @ row()+1,3 say "      ЫЫ Ы Ы ЫЫ ЫЫ  ЫЫ ЫЫ   ЫЫ ЫЫ ЫЫ   ЫЫ      ЫЫ   ЫЫ  ЫЫЫ ЫЫ    ЫЫ ЫЫ    "
           @ row()+1,3 say "      ЫЫ  Ы  ЫЫ ЫЫ  ЫЫ ЫЫ   ЫЫ ЫЫЫЫ    ЫЫЫЫЫ   ЫЫ   ЫЫ ЫЫЫЫ ЫЫЫЫЫЫЫЫ ЫЫ    "
           @ row()+1,3 say "      ЫЫ  Ы  ЫЫ ЫЫЫЫЫЫ ЫЫЫЫЫ   ЫЫ  ЫЫ  ЫЫ      ЫЫ   ЫЫЫЫ ЫЫ ЫЫ    ЫЫ ЫЫ    "
           @ row()+1,3 say "      ЫЫ     ЫЫ ЫЫ  ЫЫ ЫЫ      ЫЫ   ЫЫ ЫЫЫЫЫ   ЫЫ   ЫЫЫ  ЫЫ ЫЫ    ЫЫ ЫЫ    "
           @ row()+1,3 say "                    "
      case gnArm=5 && Ќ «®Ј®ўл© гзҐв
           sss=''
           @ 12,3      say "                Ы  Ы ЬЯЯЫ ЬЯЯЫ ЬЯЯЬ ЫЯЯ ЬЯЯЬ ЫЯЯЬ Ы   Ы Ы Я Ы"
           @ row()+1,3 say "                Ы  Ы Ы  Ы Ы  Ы Ы  Ы Ы   Ы  Ы ЫЬЬЯ ЫЬ  Ы Ы   Ы"
           @ row()+1,3 say "                ЫЯЯЫ ЫЯЯЫ Ы  Ы Ы  Ы Ы   Ы  Ы Ы  Ы Ы Ы Ы Ы ЬЯЫ"
           @ row()+1,3 say "                Ы  Ы Ы  Ы Ы  Ы ЯЬЬЯ Ы   ЯЬЬЯ ЫЬЬЯ ЫЬЯ Ы ЫЯ  Ы"
           @ row()+1,3 say ""
           @ row()+1,3 say "                               Ы  Ы Ы  Ы ЫЯЯ ЯЯЫЯЯ"
           @ row()+1,3 say "                               Ы  Ы Ы  Ы Ы     Ы  "
           @ row()+1,3 say "                                ЯЯЫ  ЯЯЫ ЫЯЯ   Ы  "
           @ row()+1,3 say "                                ЬЬЯ    Ы ЫЬЬ   Ы  "
      case gnArm=6 && Џ®ЄгЇ вҐ«Ё
           sss=''
           @ 12,3      say ""
           @ row()+1,3 say ""
           @ row()+1,3 say ""
           @ row()+1,3 say ""
           @ row()+1,3 say ""
           @ row()+1,3 say ""
           @ row()+1,3 say ""
           @ row()+1,3 say ""
           @ row()+1,3 say ""
      case gnArm=19 && Џ®бв ўйЁЄЁ
           sss='"‘Є« ¤ " '+ nsklr
           @ 12,3      say ""
           @ row()+1,3 say ""
           @ row()+1,3 say ""
           @ row()+1,3 say ""
           @ row()+1,3 say ""
           @ row()+1,3 say ""
           @ row()+1,3 say ""
           @ row()+1,3 say ""
           @ row()+1,3 say ""
           @ 21,3 say 'Џ®бв ўйЁЄ '+gcName_cp
      othe
           sss=''
           @ 12,3      say ""
           @ row()+1,3 say ""
           @ row()+1,3 say ""
           @ row()+1,3 say ""
           @ row()+1,3 say ""
           @ row()+1,3 say ""
           @ row()+1,3 say ""
           @ row()+1,3 say ""
           @ row()+1,3 say ""
   endcase
   @ 22,3 say sss + "   „ в  " + dtoc(date())+'   '+unamer+"  "+gcNNETNAME

   J := 1
   CL := 0
   CLL := 1
   TENI(2,1,4,78)
   SETCOLOR("gr+/b,w+/n,,,")
   DISPBOX(2, 1, 4, 78, "")
   DISPBOX(2, 1, 4, 78, "ЙН»єјНИє")
   DO WHILE J <= lmenur
      Cll := Cll + Cl + 2
      Cl_l[J] := Cll
      @ 3,cll say menu[j]
      Cl := LEN(MENU[J]) + 1
      IF J = lmenur
         EXIT
      ENDIF
      ++J
   ENDDO
   Scr1 := SAVESCREEN(0, 0, MAXROW(), MAXCOL())
   DO WHILE .T.
      RESTSCREEN(0, 0, MAXROW(), MAXCOL(), SCR1)
      Cll := Cl_l[I]
      SETCOLOR("w+/n,,,,")
*      @ 23,1 say str(gnScOut,1) color 'gr+/g'
      @ 3,cll say menu[i]
      If zz0 = 1
         zz0 := 0
      Else
         Key := 0
      EndIf

      #ifdef INKEY_OLD
        DO WHILE Key = 0
           Key := INKEY()
        ENDDO
      #else
        IF Key = 0
          Key:=inkey(0)
        ENDIF
      #endif

      do case
         case KEY = 19 && ў«Ґў®
              SETCOLOR("w/b")
              @ 3,cll say menu[i]
              IF i=1
                 i=lmenur
              ELSE
                 i--
              ENDIF
         case KEY = 4 && ўЇа ў®
              SETCOLOR("w/b")
              @ 3,cll say menu[i]
              IF i=lmenur
                 i=1
              ELSE
                 i++
              ENDIF
         case KEY = 13
              MNU=i
         case KEY = 27
              exit
      endcase
      RESTSCREEN(0, 0, MAXROW(), MAXCOL(), SCR1)
      CLL := CL_L[I]
      scllr=cl_l[i]
      SETCOLOR("w+/n,,,,")
      @ 3,cll say menu[i]
      IF MNU <> 0
         IC := STR(I,1)
         I1 := 1
         MENU_MAX := LEN((&("MENU&IC"))[1])
         if cl_l[i]+menu_max<80
         else
            scllr=cl_l[i]
            cl_l[i]=78-menu_max
         endif
         MNU1 := 0
         TENI(4,CL_L[I]-1,4+SIZAM[I]+1,CL_L[I]+MENU_MAX)
         SETCOLOR("gr+/bg,w+/n,,,")

         DISPBOX(4,CL_L[I]-1,4+SIZAM[I]+1,CL_L[I]+MENU_MAX,"")
         DISPBOX(4,CL_L[I]-1,4+SIZAM[I]+1,CL_L[I]+MENU_MAX,"ЙН»єјНИє")

         POZICION := 1
         POZICION := ACHOICE(5,CL_L[I],4+SIZAM[I],CL_L[I]+MENU_MAX-1,(&("MENU&IC")))

         do case
            case LASTKEY() = 13
                 SETCOLOR("w+/n,,,,")
                 @ POZICION+4,CL_L[I] say &("MENU&IC")[POZICION]
                 EXIT
            case lastkey()=K_ESC
                  key=0
                  mnu=0
            othe
                  key=lastkey()
         endcase
         zz0=1
      ENDIF
      cl_l[i]=scllr
   ENDD


   MEMO_I := I
   MEMO_MNU := MNU
   if lastkey()=K_ESC // i=lmenur
      EXIT
   ENDIF
   DBCOMMITAL()
   DBUNLOCKAL()
   I := MEMO_I
   MNU := MEMO_MNU
   m_i=i
   do case
      case i=1   //ЏаҐ¤Їа
           ussr=menu1[pozicion]
           sele menent
           locate for uss=ussr
           gnEnt=ent
           inient()
           inimes()
           iniskl()
           menskl()
           pzcr=1
           @ 0,1 say alltrim(gcName_cc)+' '+menu2[pzcr]+' Џгвм '+gcPath_e+iif(gnEntrm=0,' ‘г¬л',' '+iif(gnRmsk=3,'ђ®¬­л',iif(gnRmsk=4,'Љ®­®в®Ї','®бвЄ ')))
           @ 22,3 say sss + "   „ в  " + dtoc(date())+'   '+unamer
      case i=2   //ЏҐаЁ®¤
           pzcr=pozicion
           do case
              case menu2[pozicion]='џ­ў ам  '
                   mesr=1
              case menu2[pozicion]='”Ґўа «м '
                   mesr=2
              case menu2[pozicion]='Њ ав    '
                   mesr=3
              case menu2[pozicion]='ЂЇаҐ«м  '
                   mesr=4
              case menu2[pozicion]='Њ ©     '
                   mesr=5
              case menu2[pozicion]='€о­м    '
                   mesr=6
              case menu2[pozicion]='€о«м    '
                   mesr=7
              case menu2[pozicion]='ЂўЈгбв  '
                   mesr=8
              case menu2[pozicion]='‘Ґ­впЎам'
                   mesr=9
              case menu2[pozicion]='ЋЄвпЎам '
                   mesr=10
              case menu2[pozicion]='Ќ®пЎам  '
                   mesr=11
              case menu2[pozicion]='„ҐЄ Ўам '
                   mesr=12
           endcase
           godr=val(subs(menu2[pozicion],10,4))
           if godr=year(date()).and.mesr=month(date())
              gdTd=date()
           else
              gdTd=ctod('01.'+iif(mesr<10,'0'+str(mesr,1),str(mesr,2))+'.'+str(godr,4))
              gdTd=eom(gdTd)
           endif
           sele prd
           locate for god=godr.and.mes=mesr
           if found()
              gnPrd=prd
           else
              gnPrd=1
           endif
           inipath()
           iniskl()
           menskl()
           @ 0,1 say alltrim(gcName_cc)+' '+menu2[pzcr]+' Џгвм '+gcPath_e+iif(gnEntrm=0,' ‘г¬л',' '+iif(gnRmsk=3,'ђ®¬­л',iif(gnRmsk=4,'Љ®­®в®Ї','®бвЄ ')))
           @ 22,3 say sss + "   „ в  " + dtoc(date())+'   '+unamer
*      case i=3   //‘Є« ¤
*           gnSk=val(subs(menu3[pozicion],1,3))
*           inipath()
*           menskl()
*           @ 22,3 say sss + "   „ в  " + dtoc(date())+'   '+unamer

   endcase



   Do Case
   Case upper(gcNarm) = "SERV"
     mserv()
   Case upper(gcNarm) = "ADM"
     madm()
   Case upper(gcNarm) = "FIN"
     mfin()
   Case upper(gcNarm) = "SKLAD"
     msklad()
   OtherWise
     cmArmr='m'+gcNarm+'()'
     cmArmr="{||"+cmArmr+"}"
     bcmArmr:=&cmArmr
     EVAL(bcmArmr)
   EndCase

/*   do case
*      case gnArm=1
*           madm()
*      case gnArm=2
*           mfin()
*      case gnArm=3
*           msklad()
*      case gnArm=4
*           mmark()
*      case gnArm=5
*           mnds()
*      case gnArm=6
*           mcust()
*      case gnArm=19
*           mpost()
*      case gnArm=25
*           mserv()
*      case gnArm=32
*           magent()
*      case gnArm=34
*           msuper()
*   endcase
*/
   i=m_i
   SCR1 := SAVESCREEN(0, 0, MAXROW(), MAXCOL())
   if i=1.or.i=2 &&.or.i=3
      if pozicion#0.and.lastkey()=13
         mnu=0
         key=0
         zz0=0
      endif
   endif
ENDD

