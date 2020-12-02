#include "inkey.ch"
#include "Common.ch"
/*FUNCTION Main()
  LOCAL nChoice
  CLEAR SCREEN

  WHILE (TRUE)
    SET COLOR TO +W/B, N/W
    nChoice:=ACHOICE(08, 30, 10+6+1, 30+40,                     ;
                      {                                          ;
                        "1. Создать базу       ", ;
                        "2. Заполнить базу     ", ;
                        "3. Сколько листов", ;
                        "4. Печать I-го листа", ;
                        "5. Печать II-го листа", ;
                        "6. Печать III-го листа ", ;
                        "Q. Выход в DOS                       "  ;
                      }                                          ;
                   )

    DO CASE
    CASE (nChoice == 1)
      sttn_create()
    CASE (nChoice == 2)
      sttn_add()
    CASE (nChoice == 3)
    CASE (nChoice == 4)
      sttn_pr_N1()
    CASE (nChoice == 5)
      sttn_pr_N2(2)
    CASE (nChoice == 6)
    CASE (nChoice == 7  .OR. nChoice == 0)
      EXIT
    ENDCASE

  ENDDO

  RETURN (NIL)
*/

/*****************************************************************
 
 FUNCTION:
 АВТОР..ДАТА..........С. Литовка   22.01.05 * 19:02:38
 НАЗНАЧЕНИЕ.........
 ПАРАМЕТРЫ..........
 ВОЗВР. ЗНАЧЕНИЕ....
 ПРИМЕЧАНИЯ.........
 */
FUNCTION sttn_create()
  IF !EMPTY(SELECT("sttn"))
    CLOSE sttn
  ENDIF
  DBCREATE("sttn",{;
  {"NDay",        "N", 2,0},;//дата
  {"CMonth",      "C", 9,0},;//месяц в символьной форме
  {"NYear",       "N", 4,0},;//месяц в символьной форме
  ;//
  {"Avto_Marka",  "C", 7,0},;//марка автомобиля
  {"Avto_GosN",   "C", 8,0},;//гос номер автомобиля
  {"Avto_ListN",  "C",12,0},;//номер дорожного листа
  ;//
  ;//
  {"Gr_Pere",     "C",15,0},;//грузоперевозщик
  ;//
  {"Vod_FIO", "C",25,0},;//водитель
  {"Vod_Udo", "C",25,0},;//номер удостоверения
  ;//
  {"Bid_Pere",    "C",25,0},;//вид перевозки
  ;//
  {"Gr_Ot_Name",  "C",25,0},;//грузоотправитель наименоване
  {"Gr_Ot_Adr",   "C",25,0},;//грузоотправитель адрес
  ;//
  ;//
  {"Punkt_Zagr",  "C",45,0},;//пунк загрузки
  ;//
  {"Gr_Od_Name",  "C",25,0},;//грузополучатель наименоване
  {"Gr_Od_Adr",   "C",35,0},;//грузополучатель адрес
  {"Gr_Od_Bank",  "C",70,0},;//грузополучатель банковские, идетификационный код
  {"Gr_Od_LzNm", "C",65,0},;//лицензии наименование
  {"Gr_Od_LzDt", "C",65,0},;//лицензии номер
  ;//
  {"Punkt_Razg",  "C",45,0},;//пунк разгрузки
  ;//
  {"Avto_Add",    "C",23,0},;//автоприцеп гос номер
  ;//
  {"CSum_Total",  "C",52,0},;//сумма с НДС и суммы Акциза
  {"Dok1_Add",    "C",25,0},;//сопроводительные документы 1
  {"Dok2_Add",    "C",65,0},;//сопроводительные документы 1
  {"Dok3_Add",    "C",65,0},;//сопроводительные документы 1
  ;//
  {"Sum_Nds",     "N", 9,2},;//сумма ндс втч
  {"Sum_Akz",     "N", 9,2},;//сумма Акциза
  ;//
  ;//
  {"STtn_Nom",    "C",20,2},;//номер ТТН
  ;// ведомости о грузе
  {"T_Nm",      "C",50,0},;//наименоване товара
  {"T_Volm",    "C", 6,0},;//емкость бутылки
  {"T_Jash",    "N", 6,0},;//к-во ящиков
  {"T_But_Jash","N", 6,0},;//к-во бутылок в ящике
  {"T_But",     "N", 6,0},;//к-во бутылок
  {"T_Tara",    "C", 6,0},;//тара
  {"T_Zena",    "N",10,3},;//цена
  {"T_Sum",     "N",10,2},;//сумма общая
  {"T_Nds",     "N",7,2}, ;//сумма ндс
  {"T_Akz",     "N",7,2} ;//сумма акциза
  })
  RETURN (NIL)


/*****************************************************************
 
 FUNCTION:
 АВТОР..ДАТА..........С. Литовка  23.01.05 * 07:38:47
 НАЗНАЧЕНИЕ.........
 ПАРАМЕТРЫ..........
 ВОЗВР. ЗНАЧЕНИЕ....
 ПРИМЕЧАНИЯ.........
 */
FUNCTION sttn_add()
  LOCAL i

  netuse('klnlic')
  set orde to tag t3
  netuse('atran')
  netuse('czg')
  set orde to tag t3
  netuse('cmrsh')
  set orde to tag t2

  bsosr=alltrim(rs1->bsos)
  bsonr=rs1->bson

*  sele czg
*  if netseek('t3','gnSk,ttnr')

  sele czg
  if netseek('t3','gnEnt,gnSk,ttnr')
     mrshr=mrsh
*     sele atmrsh
*     if netseek('t2','mrshr')
     sele cmrsh
     if netseek('t2','mrshr')
        dfior=alltrim(dfio)
        anomr=alltrim(anom)
        atranr=atran
        natranr=getfield('t1','atranr','atran','natran')
        kecsr=kecs
        necsr=getfield('t1','kecsr','s_tag','fio')
     else
        mrshr=0
     endif
  else
     mrshr=0
  endif
  if mrshr=0
     dfior=''
     anomr=''
     atranr=0
     natranr=''
     kecsr=0
     necsr=''
  endif
  if empty(anomr)
     anomr=alltrim(rs1->atnom)
  endif
  if kecsr=0
     kecsr=rs1->kecs
     necsr=getfield('t1','kecsr','s_tag','fio')
  endif
  ndayr=day(dotr)
  cmonthr=smes(month(dotr),1)
  nyearr=year(dotr)-2000
  cmarshr=str(mrshr,12)
  sele kln
  netseek('t1','rs1->kpl')
  nkplr=alltrim(nkl)
  akplr=alltrim(adr)
  kbr=kb1
  nsr=alltrim(ns1)
  obr=alltrim(getfield('t1','kbr','banks','otb'))
  kbr=alltrim(kbr)
  nnr=str(nn,12)

  sele kln
  netseek('t1','rs1->kgp')
  ngpr=alltrim(nkl)
  agpr=alltrim(adr)

  sele klnlic
  if netseek('t3','kplr,kgpr,2')
     do while kkl=kplr.and.kgp=kgpr.and.lic=2
        dnlr=dnl
        serlicr=alltrim(serlic)
        numlicr=numlic
        regnomr=regnom
        skip
     endd
  else
     dnlr=ctod('')
     serlicr=''
     numlicr=0
     regnomr=0
  endif


  USE sttn NEW

*  FOR i:=1 TO 26
ktlother=0
sele rs2
set orde to tag t3
if netseek('t3','ttnr')
   do while ttn=ttnr
      mntovr=mntov
      ktlr=ktl
      ktlpr=ktlp
      kg_r=int(ktlpr/1000000)
      kvpr=kvp
      if kg_r>1
         if getfield('t1','kg_r','cgrp','tgrp')=0
            ktlother=ktlother+1
            sele rs2
            skip
            loop
         endif
      endif
      pptr=ppt
      if pptr=0 // Товар
         sele sttn
         DBAPPEND()

         _FIELD->NDay        :=ndayr                                    // ",        "N", 2,0},;//дата
         _FIELD->CMonth      :=cmonthr //,      "C", 9,0},;//месяц в символьной форме
         _FIELD->NYear       :=nyearr                                  //",    "N"  , 1,0},;//месяц в символьной форме

         _FIELD->Avto_Marka  :=natranr //",  "C", 7,0},;//марка автомобиля
         _FIELD->Avto_GosN   :=anomr   // ,   "C", 8,0},;//гос номер автомобиля
         _FIELD->Avto_ListN  :=cmarshr //",  "C",12,0},;//номер дорожного листа

         _FIELD->Gr_Pere     :=necsr //",     "C",28,0},;//грузоперевозщик

         _FIELD->Vod_FIO :=dfior //", "C",20,0},;//водитель
         _FIELD->Vod_Udo :='' //", "C",15,0},;//номер удостоверения

         _FIELD->Bid_Pere    :='' //",    "C",25,0},;//вид перевозки

         _FIELD->Gr_Ot_Name  :=gcName_c //",  "C",15,0},;//грузоотправитель наименоване
         _FIELD->Gr_Ot_Adr   :=gcAdr_c //",   "C",15,0},;//грузоотправитель адрес

         _FIELD->Punkt_Zagr  :=gcAdr_c //",  "C",45,0},;//пунк загрузки

         _FIELD->Gr_Od_Name  :=nkplr // ",  "C",25,0},;//грузополучатель наименоване
         _FIELD->Gr_Od_Adr   :=akplr //",   "C",35,0},;//грузополучатель адрес
         _FIELD->Gr_Od_Bank  :=obr+' МФО '+kbr+' счет '+nsr+' нн '+nnr // ",  "C",65,0},;//грузополучатель банковские, идетификационный код
         _FIELD->Gr_Od_LzNm :='' //", "C",65,0},;//лицензии наименование
         _FIELD->Gr_Od_LzDt :=serlicr+' '+str(numlicr,6)+' '+str(regnomr,12)+' '+dtoc(dnlr) //", "C",65,0},;//лицензии номер

         _FIELD->Punkt_Razg  :=agpr //",  "C",45,0},;//пунк разгрузки

         _FIELD->Avto_Add    :='' // ",    "C",42,0},;//автоприцеп гос номер

         _FIELD->Dok1_Add    :=str(ttnr,6)+' '+subs(gcNskl,1,17) //",    "C",25,0},;//сопроводительные документы 1
         _FIELD->Dok2_Add    :='' //",    "C",65,0},;//сопроводительные документы 1
         _FIELD->Dok3_Add    :='' //",    "C",65,0},;//сопроводительные документы 1

         _FIELD->STtn_Nom    :=bsosr+' '+str(bsonr,6) //",    "C",20,2},;//номер БСО
  // ведомости о грузе                    // ведомости о грузе

         _FIELD->T_Nm      :=getfield('t1','sklr,ktlr','tov','nat') //",      "C",50,0},;//наименоване товара
         _FIELD->T_Zena    :=rs2->zen                               //",    "N",10,3},;//цена товара
         _FIELD->T_Sum     :=rs2->svp*1.2                           //",     "N",10,2},;//сумма общая
         _FIELD->T_Nds     :=rs2->svp*1.2-rs2->svp                  //",     "N",7,2}, ;//сумма ндс
         _FIELD->T_Akz     :=0                                  //",     "N",7,2} ;//сумма акциза
         _FIELD->T_But_Jash:=getfield('t1','sklr,ktlr','tov','upak')                                   //","N", 6,0},;//к-во бутылок в ящике
         _FIELD->T_Volm    :=str(getfield('t1','sklr,ktlr','tov','vesp'),6,3) //",    "C", 6,0},;//емкость бутылки
         _FIELD->T_Tara    :=getfield('t1','sklr,ktlr','tov','nei') //",    "C", 6,0},;//ед изм тары
         _FIELD->T_But     :=rs2->kvp                                   //",     "N", 6,0},;//к-во бутылок всего
      else // Тара
         sele sttn
         if int(mntovr/10000)=0 // Ящик
            _FIELD->T_Jash    :=rs2->kvp                                   //",    "N", 6,0},;//к-во ящиков
         else                   // Бутылка
*            _FIELD->T_But     :=rs2->kvp                                   //",     "N", 6,0},;//к-во бутылок всего
         endif
      endif
      sele rs2
      if prosfor=1
         if fieldpos('osfo')#0
            netrepl('osfo','osfo-kvpr')
            if gnCtov=1
               sele tovm
               if netseek('t1','sklr,mntovr')
                  netrepl('osfo','osfo-kvpr')
               endif
            endif
         endif
      endif
      sele rs2
      skip
   endd
endif

Dok2_Addr=''
Dok3_Addr=''
if ktlother#0
   sele sttn
   sum T_sum,T_nds to T_sumr,T_ndsr
else
   t_sumr=getfield('t1','ttnr,90','rs3','ssf')
   t_ndsr=getfield('t1','ttnr,11','rs3','ssf')
   t_40r=getfield('t1','ttnr,40','rs3','ssf')
   t_46r=getfield('t1','ttnr,46','rs3','ssf')
   //t_48r=getfield('t1','ttnr,48','rs3','ssf')
   t_61r=getfield('t1','ttnr,61','rs3','ssf')
   Dok2_Addr=iif(t_40r#0,'Скидка '+str(t_40r,10,2),'')+' '+iif(t_46r#0,'Оформл '+str(t_46r,10,2),'')
   Dok3_Addr=iif(t_61r#0,'Автоусл. '+str(t_61r,10,2),'') //+' '+iif(t_48r#0,'Оформл БСО '+str(t_48r,10,2),'')
endif
cT_sumr=numstr(T_sumr)+' грн '+right(str(T_sumr,10,2),2)+' коп'
sele sttn
repl all csum_total with cT_sumr,Sum_Nds with T_ndsr,;
         Dok2_Add with Dok2_Addr ,;
         Dok3_Add with Dok3_Addr

  RETURN (NIL)



/*****************************************************************
 
 FUNCTION:sttn_pr_N1()
 АВТОР..ДАТА..........С. Литовка  23.01.05 * 07:50:38
 НАЗНАЧЕНИЕ.........              23.01.05 16:11
 ПАРАМЕТРЫ..........
 ВОЗВР. ЗНАЧЕНИЕ....
 ПРИМЕЧАНИЯ.........
 */
FUNCTION sttn_pr_N1()
  LOCAL cChrIch, cTempPrn
  LOCAL aRow, i, n10
  LOCAL Y1, X1

  Y1:=  0
  X1:=  2

  IF EMPTY(SELECT("sttn"))
    USE sttn NEW
  ENDIF
  sttn->(DBGOTO(1))

  cChrIch:="15"
#ifdef __CLIP__
   set("PRINTER_CHARSET",host_charset())
#endif
  cTempPrn:=OpenPrintFile()
  SETPRC(0,0)


  ??CHR(27)+"&l1X" //количество копий
  ??CHR(27)+"&l4H" //какой лоток I
  ??CHR(27)+"&l26A" // размер бумаги A4
  ??CHR(27)+"&l1O"

  //2 - нормальная(1/6")  0 - 1/8"  1 - 7/72" - EPSON
  ??CHR(27)+"&f0S"// подготовка для установки интервала строк
    //??CHR(27)+"&l8D"// растояние между строк //ESC0
    ??CHR(27)+"&l12D"// растояние между строк //ESC1
    //??CHR(27)+"&l6D"// растояние между строк //ESC2
  ??CHR(27)+"&f1S"// подготовка для установки интервала строк

  ??CHR(27)+"(s"+cChrIch+"H"+CHR(27)+"&k7H"  //книга 15 сим/дюйм и индекс горизонтальног перемещения
  //??CHR(27)+"&k4S" ; //альбом 12 на дюйм
  //??CHR(27)+"&k0S"           // 10 на дюйм

  //?CHR(27)+"(s3B"  // Первичная толщина штриха - жирный

  /*
  CHR(27)+"&l12D" // растояние между строк //ESC1
  CHR(27)+"(s0S"  // Первичный стиль  - прямой

  //для наименования
  CHR(27)+"(s3B"  // Первичная толщина штриха - жирный
  CHR(27)+"(s20H" // Первичный питч - 20 символов на дюйм
  CHR(27)+"&k7H"  // Индекс гориз перемещения 1/120
  */


  @  14+Y1, 40+X1 SAY _FIELD->NDay
  @  14+Y1, 47+X1 SAY _FIELD->CMonth
  @  14+Y1, 67+X1 SAY _FIELD->NYear
  @  14+Y1, 97+X1 SAY ALLTRIM(_FIELD->Avto_Marka) +" "+ _FIELD->Avto_GosN
  @  14+Y1,159+X1 SAY _FIELD->Avto_ListN

  //грузоперевозщик
  @  19+Y1, 37+X1 SAY _FIELD->Gr_Pere
  @  19+Y1, 76+X1 SAY ALLTRIM(_FIELD->Vod_FIO) +" "+ _FIELD->Vod_Udo
  @  19+Y1,149+X1 SAY _FIELD->Bid_Pere

  //грузоотправитель
  @  22+Y1, 37+X1 SAY ALLTRIM(_FIELD->Gr_Ot_Name) +" "+ _FIELD->Gr_Ot_Adr

  //пунк загрузки
  @  26+Y1, 37+X1 SAY _FIELD->Punkt_Zagr

  //грузополучатель
  @  29+Y1, 37+X1 SAY ALLTRIM(_FIELD->Gr_Od_Name) +" "+_FIELD->Gr_Od_Adr
  //грузополучатель банковские, идетификационный код
  @  33+Y1, 37+X1 SAY _FIELD->Gr_Od_Bank
  //лицензии наименование
  @  36+Y1, 37+X1 SAY ALLTRIM(_FIELD->Gr_Od_LzNm) +" "+ _FIELD->Gr_Od_LzDt
  //пунк разгрузки
  @  39+Y1, 37+X1 SAY _FIELD->Punkt_Razg

  //автоприцеп гос номер
  @  43+Y1, 157+X1 SAY _FIELD->Avto_Add

//  aRow:={55+Y1,58+Y1,60+Y1,62+Y1,65+Y1}
  aRow:={55+Y1,56+Y1,57+Y1,58+Y1,59+Y1,60+Y1,61+Y1,62+Y1,63+Y1,64+Y1}
  FOR i:=1 TO 10
    DBGOTO(i)
    @  aRow[i], 15+X1 SAY ALLTRIM(STR(RECNO(),0))
    // ведомости о грузе
    //наименоване товара
    @  aRow[i], 18+X1 SAY ;
    CHR(27)+"(s3B"+;
    CHR(27)+"(s25H"+;
    CHR(27)+"&k5H"+;
    PADR(ALLTRIM(_FIELD->T_Nm),35)+;
    CHR(27)+"(s0B"+;
    CHR(27)+"(s15H"+;
    CHR(27)+"&k7H"

    SETPRC(aRow[i],35);n10:=-5 //+X1
    //емкость бутылки
    @  aRow[i], 50+n10 SAY _FIELD->T_Volm
    //к-во ящиков
    @  aRow[i], 65+n10 SAY _FIELD->T_Jash
    //к-во бутылок в ящике
    @  aRow[i], 82+n10 SAY _FIELD->T_But_Jash
    //к-во бутылок
    @  aRow[i], 97+n10 SAY _FIELD->T_But
    //тара
    @  aRow[i],110+n10 SAY _FIELD->T_Tara
    //цена
    @  aRow[i],120+n10 SAY _FIELD->T_Zena
    //сумма общая
    @  aRow[i],137+n10 SAY _FIELD->T_Sum
    //сумма ндс
    @  aRow[i],151+n10 SAY _FIELD->T_Nds
    //сумма акциза
    @  aRow[i],163+n10 SAY _FIELD->T_Akz

    DBSKIP()
    IF EOF()
      EXIT
    ENDIF
  NEXT

  go top
  //сумма с НДС и суммы Акциза
  @  68+Y1, 52+X1 SAY _FIELD->CSum_Total
  //сопроводительные документы 1
  @  68+Y1,149+X1 SAY _FIELD->Dok1_Add

  //сумма ндс втч
  @  71+Y1,50+X1 SAY _FIELD->Sum_Nds
  //сумма Акциза
  @  71+Y1,90+X1 SAY _FIELD->Sum_Akz
  //сопроводительные документы 2
  @  71+Y1,120+X1 SAY _FIELD->Dok2_Add


  //??CHR(27)+"(s0B"  // Первичная толщина штриха - нормальный
  ?CHR(27)+"&l0H"// завершение страницы

  ClosePrintFile()
#ifdef __CLIP__
   set("PRINTER_CHARSET","cp866")
#endif
/*
        //bar_code({"","","","","","","","Печат","Выход"} )
        SETKEY(K_F9,{|cTEMPFILE| FILECOPY(cTempPrn, (cTEMPFILE:=TEMPFILE(,"prn"))), MyPrintFile(cTEMPFILE, 1, 1)})
        SETKEY(K_F10,{|| __Keyboard(CHR(K_ESC))  })
        ViewFileText(cTempPrn)
        SETKEY(K_F10,NIL);    SETKEY(K_F9,NIL)
        //bar_code()
*/
  RETURN (cTempPrn)


/*****************************************************************
 
 FUNCTION:
 АВТОР..ДАТА..........С. Литовка  23.01.05 * 16:11:32
 НАЗНАЧЕНИЕ.........
 ПАРАМЕТРЫ..........
 ВОЗВР. ЗНАЧЕНИЕ....
 ПРИМЕЧАНИЯ.........
 */
FUNCTION sttn_pr_N2(nPage)
  LOCAL cChrIch, cTempPrn
  LOCAL aRow, i, n10
  LOCAL Y1, X1

  Y1:= 0
  X1:= 2

  IF EMPTY(SELECT("sttn"))
    USE sttn NEW
  ENDIF

//  sttn->(DBGOTO(6+21*(nPage-2)))
  sttn->(DBGOTO(11+21*(nPage-2)))

  cChrIch:="15"
#ifdef __CLIP__
   set("PRINTER_CHARSET",host_charset())
#endif
  cTempPrn:=OpenPrintFile()
  SETPRC(0,0)

  ??CHR(27)+"&l1X" //количество копий
  ??CHR(27)+"&l4H" //какой лоток I
  ??CHR(27)+"&l26A" // размер бумаги A4
  ??CHR(27)+"&l1O"  // ориентация

  //2 - нормальная(1/6")  0 - 1/8"  1 - 7/72" - EPSON
  ??CHR(27)+"&f0S"// подготовка для установки интервала строк
    //??CHR(27)+"&l8D"// растояние между строк //ESC0
    ??CHR(27)+"&l12D"// растояние между строк //ESC1
    //??CHR(27)+"&l6D"// растояние между строк //ESC2
  ??CHR(27)+"&f1S"// подготовка для установки интервала строк

  ??CHR(27)+"(s"+cChrIch+"H"+CHR(27)+"&k7H"  //книга 15 сим/дюйм и индекс горизонтальног перемещения
  ?""

  //??CHR(27)+"&k4S" ; //альбом 12 на дюйм
  //??CHR(27)+"&k0S"           // 10 на дюйм

  //?CHR(27)+"(s3B"  // Первичная толщина штриха - жирный

  /*
  CHR(27)+"&l12D" // растояние между строк //ESC1
  CHR(27)+"(s0S"  // Первичный стиль  - прямой

  //для наименования
  CHR(27)+"(s3B"  // Первичная толщина штриха - жирный
  CHR(27)+"(s20H" // Первичный питч - 20 символов на дюйм
  CHR(27)+"&k7H"  // Индекс гориз перемещения 1/120
  */


  //номер ТТН
  @  10+Y1,144+X1 SAY _FIELD->STtn_Nom

  aRow:={26+Y1,28+Y1,30+Y1,33+Y1,35+Y1,37+Y1,40+Y1,42+Y1,45+Y1,;
         47+Y1,49+Y1,52+Y1,54+Y1,56+Y1,59+Y1,61+Y1,63+Y1,66+Y1,;
         68+Y1,70+Y1,72+Y1}

/*  aRow:={26+Y1,27+Y1,28+Y1,29+Y1,30+Y1,31+Y1,32+Y1,33+Y1,34+Y1,;
         35+Y1,36+Y1,37+Y1,38+Y1,39+Y1,40+Y1,41+Y1,42+Y1,43+Y1,;
         44+Y1,45+Y1,46+Y1,47+Y1,48+Y1,49+Y1,50+Y1,51+Y1,52+Y1,;
         53+Y1,54+Y1,55+Y1,56+Y1,57+Y1,58+Y1,59+Y1,60+Y1,61+Y1,;
         62+Y1,63+Y1,64+Y1,65+Y1,66+Y1,67+Y1}
*/
  FOR i:=1 TO 21
    DBGOTO(i+10+21*(nPage-2))
    @  aRow[i], 15+X1 SAY ALLTRIM(STR(RECNO(),0))
           // ведомости о грузе
    //наименоване товара
    @  aRow[i], 18+X1 SAY ;
    CHR(27)+"(s3B"+;
    CHR(27)+"(s25H"+;
    CHR(27)+"&k5H"+;
    PADR(ALLTRIM(_FIELD->T_Nm),50)+;
    CHR(27)+"(s0B"+;
    CHR(27)+"(s15H"+;
    CHR(27)+"&k7H"

    SETPRC(aRow[i],35);n10:=-5 //+X1
    //емкость бутылки
    @  aRow[i], 50+n10 SAY _FIELD->T_Volm
    //к-во ящиков
    @  aRow[i], 65+n10 SAY _FIELD->T_Jash
    //к-во бутылок в ящике
    @  aRow[i], 82+n10 SAY _FIELD->T_But_Jash
    //к-во бутылок
    @  aRow[i], 97+n10 SAY _FIELD->T_But
    //тара
    @  aRow[i],109+n10 SAY _FIELD->T_Tara
    //цена
    @  aRow[i],118+n10 SAY _FIELD->T_Zena
    //сумма общая
    @  aRow[i],133+n10 SAY _FIELD->T_Sum
    //сумма ндс
    @  aRow[i],145+n10 SAY _FIELD->T_Nds
    //сумма акциза
    @  aRow[i],157+n10 SAY _FIELD->T_Akz

    DBSKIP()
    IF EOF()
      EXIT
    ENDIF
  NEXT

  ?CHR(27)+"&l0H"// завершение страницы

  ClosePrintFile()
#ifdef __CLIP__
   set("PRINTER_CHARSET","cp866")
#endif
/*
        //bar_code({"","","","","","","","Печат","Выход"} )
        SETKEY(K_F9,{|cTEMPFILE| FILECOPY(cTempPrn, (cTEMPFILE:=TEMPFILE(,"prn"))), MyPrintFile(cTEMPFILE, 1, 1)})
        SETKEY(K_F10,{|| __Keyboard(CHR(K_ESC))  })
        ViewFileText(cTempPrn)
        SETKEY(K_F10,NIL);    SETKEY(K_F9,NIL)
        //bar_code()
*/
  RETURN (cTempPrn)










/***********************************************************
 * OpenPrintFile() -->
 *   Параметры :
 *   Возвращает:
 */
*FUNCTION OpenPrintFile(cPathPrintFile, cTempPrn, lAdd)
*  DEFAULT cTempPrn TO TEMPFILE(cPathPrintFile, "PRN"), lAdd TO TRUE
*  IF !EMPTY(cPathPrintFile) .AND. !(LOWER(cPathPrintFile)$LOWER(cTempPrn))
*    cTempPrn:=cPathPrintFile+"\"+cTempPrn
*  ENDIF
*  Set(_SET_PRINTFILE, cTempPrn, lAdd)
*  SET DEVICE TO PRINT
*  SET PRINT ON
*  SET CONSOLE OFF
*  RETURN (cTempPrn)

/***********************************************************
 * ClosePrintFile() -->
 *   Параметры :
 *   Возвращает:
 */
*FUNCTION ClosePrintFile()
*  SET DEVICE TO SCREEN
*  SET PRINT OFF
*  SET CONSOLE ON
*  SET PRINT TO
*  RETURN (NIL)


FUNCTION MyPrintFile(cTempPrn, koln, xCurPrn)
      SET CONSOLE OFF
      SET PRINTER TO LPT1
      SET PRINT ON

      TYPE (cTempPrn) //TO PRINTER

      SET PRINT OFF
      SET PRINTER TO
      SET CONSOLE ON

  RETURN (NIL)
*****************************
func qtost
* Быстрая коррекция тек ост
*****************************
clea
netuse('cskl')
sele cskl
locate for ent=gnEnt.and.ctov=1.and.rasc=1
rccsklr=recn()
do while .t.
   sele cskl
   go rccsklr
   if gnAdm=1
      rccsklr=slcf('cskl',1,1,18,,"e:sk h:'SK' c:n(3) e:nskl h:'Наименование' c:c(20) e:nprd h:'Начало' c:d(10)",,,,,"ent=gnEnt.and.ctov=1.and.(rasc=1.or.tpstpok#0).and.file(gcPath_d+alltrim(path)+'tprds01.dbf')")
   else
      rccsklr=slcf('cskl',1,1,18,,"e:sk h:'SK' c:n(3) e:nskl h:'Наименование' c:c(20) e:nprd h:'Начало' c:d(10)",,,,,"ent=gnEnt.and.tpstpok#0.and.file(gcPath_d+alltrim(path)+'tprds01.dbf')")
   endif
   sele cskl
   go rccsklr
   dir_r=alltrim(path)
   msklr=mskl
   sklr=skl
   nprdr=nprd
   if lastkey()=K_ESC
      exit
   endif
   do case
      case lastkey()=K_ENTER
           qost()
   endc
endd
nuse()
retu .t.
************
func qost()
************
clea
if msklr=1
   sklr=0
endif
if !empty(nprdr)
   dt1r=nprdr
else
   dt1r=gdtd
endif
dt2r=gdTd
cltovkol=setcolor('w+/rb+,n/w')
ww=wopen(5,30,8,60,.t.)
wbox(1)
if msklr=1
  @ 0,1 say 'Склад' get sklr pict '9999999'
endif
if !empty(nprdr)
   @ 1,1 say 'С периода' get dt1r range nprdr,gdTd
else
   @ 1,1 say 'С периода' get dt1r
endif
read
wclose(ww)
setcolor(cltovkol)
if lastkey()=K_ESC
   retu .t.
endif
set prin to qost.txt
set prin on
for yyr=year(dt1r) to year(dt2r)
    pathgr=gcPath_e+'g'+str(yyr,4)+'\'
    do case
       case year(dt1r)=year(dt2r)
            mm1r=month(dt1r)
            mm2r=month(dt2r)
       case yyr=year(dt1r)
            mm1r=month(dt1r)
            mm2r=12
       case yyr=year(dt2r)
            mm1r=1
            mm2r=month(dt2r)
            mm1r=1
            mm2r=12
       other
    endc
    for mmr=mm1r to mm2r
        pathr=pathgr+'m'+iif(mmr<10,'0'+str(mmr,1),str(mmr,2))+'\'+dir_r
        cdtr='01.'+iif(mmr<10,'0'+str(mmr,1),str(mmr,2))+'.'+str(yyr,4)
        dtr=ctod(cdtr)
        dtspr=addmonth(dtr,1)
        ?pathr
        most()
    next
next
set prin off
set prin to
retu .t.
**************
func most()
**************
if !netfile('tov',1)
   retu .t.
endif
netuse('pr1',,,1)
netuse('pr2',,,1)
netuse('rs1',,,1)
netuse('rs2',,,1)
netuse('tov',,,1)
netuse('tovm',,,1)
if msklr=0.or.msklr=1.and.sklr=0
   sele tovm
   go top
   do while !eof()
      tvost()
      sele tovm
      skip
   endd
else
   sele tovm
   if netseek('t1','sklr')
      do while skl=sklr
         tvost()
         sele tovm
         skip
      endd
   endif
endif
mmspr=month(dtspr)
yyspr=year(dtspr)
pathgspr=gcPath_e+'g'+str(yyspr,4)+'\'
pathr=pathgspr+'m'+iif(mmspr<10,'0'+str(mmspr,1),str(mmspr,2))+'\'+dir_r
if netfile('tov',1)
   netuse('tov','tovsp',,1)
   sele tov
   if msklr=0.or.msklr=1.and.sklr=0
      go top
      do while !eof()
         skl_r=skl
         ktlr=ktl
         osnr=osf
         sele tovsp
         if netseek('t1','skl_r,ktlr')
            if roun(osn,3)#roun(osnr,3)
               ?str(skl_r,7)+' '+str(ktlr,9)+' OSNSP '+str(osn,10,3)+'->'+str(osnr,10,3)
               netrepl('osn','osnr')
            endif
         endif
         sele tov
         skip
      endd
   else
      if netseek('t1','sklr')
         do while skl=sklr
            skl_r=skl
            ktlr=ktl
            osnr=osf
            sele tovsp
            if netseek('t1','skl_r,ktlr')
               if roun(osn,3)#roun(osnr,3)
                  ?str(skl_r,7)+' '+str(ktlr,9)+' OSNSP '+str(osn,10,3)+'->'+str(osnr,10,3)
                  netrepl('osn','osnr')
               endif
            endif
            sele tov
            skip
         endd
      endif
   endif
   sele tovsp
   if msklr=0.or.msklr=1.and.sklr=0
      go top
      do while !eof()
         skl_r=skl
         ktlr=ktl
         osnr=osn
         sele tov
         if !netseek('t1','skl_r,ktlr')
            ?str(skl_r,7)+' '+str(ktlr,9)+' OSN#0'
            sele tovsp
            netrepl('osn','0')
         endif
         sele tovsp
         skip
      endd
   else
      if netseek('t1','sklr')
         do while skl=sklr
            skl_r=skl
            ktlr=ktl
            sele tov
            if !netseek('t1','skl_r,ktlr')
               ?str(skl_r,7)+' '+str(ktlr,9)+' нет прошлом OSN#0'
               sele tovsp
               netrepl('osn','0')
            endif
            sele tovsp
            skip
         endd
      endif
   endif
endif
nuse('pr1')
nuse('pr2')
nuse('rs1')
nuse('rs2')
nuse('tov')
nuse('tovsp')
nuse('tovm')
retu .t.
**************
func tvost()
**************
reclock()
skl_r=skl
mntovr=mntov
store 0 to mosnr,mosvr,mosfr,mosfor
sele tov
set orde to tag t5
if netseek('t5','skl_r,mntovr')
   do while skl=skl_r.and.mntov=mntovr
      if otv=1
         skip
         loop
      endif
      reclock()
      ktlr=ktl
      osnr=osn
      store 0 to prr,rsvr,rsor,rsfr
      sele pr2
      set orde to tag t6 // ktl
      if netseek('t6','ktlr')
         do while ktl=ktlr
            mnr=mn
            sele pr1
            if netseek('t2','mnr')
               if prz=0.or.skl#skl_r
                  sele pr2
                  skip
                  loop
               endif
               sele pr2
               prr=prr+kf
            endif
            sele pr2
            skip
         endd
      endif

      sele rs2
      set orde to tag t6 // ktl
      if netseek('t6','ktlr')
         do while ktl=ktlr
            ttnr=ttn
            sele rs1
            if netseek('t1','ttnr')
               if skl#skl_r
                  sele rs2
                  skip
                  loop
               endif
               do case
                  case prz=0.and.empty(dop)
                       sele rs2
                       rsvr=rsvr+kvp
                  case prz=0.and.!empty(dop)
                       sele rs2
                       rsor=rsor+kvp
                  case prz=1
                       sele rs2
                       rsfr=rsfr+kvp
               endc
            endif
            sele rs2
            skip
         endd
      endif
      osvr=osnr+prr-rsvr-rsor-rsfr
      osfor=osnr+prr-rsor-rsfr
      osfr=osnr+prr-rsfr
      mosnr=mosnr+osnr
      mosvr=mosvr+osvr
      mosfor=mosfor+osfor
      mosfr=mosfr+osfr
      sele tov
      if roun(osv,3)#roun(osvr,3).or.roun(osfo,3)#roun(osfor,3).or.roun(osf,3)#roun(osfr,3)
         ?'TOV '+str(skl_r,7)+' '+str(ktlr,9)+' OSV '+str(osv,10,3)+'->'+str(osvr,10,3),;
         +' OSFO '+str(osfo,10,3)+'->'+str(osfor,10,3),;
         +' OSF '+str(osf,10,3)+'->'+str(osfr,10,3)
         netrepl('osv,osf,osfo','osvr,osfr,osfor')
      endif
      skip
   endd
endif
sele tovm
if roun(osn,3)#roun(mosnr,3).or.roun(osv,3)#roun(mosvr,3).or.roun(osfo,3)#roun(mosfor,3).or.roun(osf,3)#roun(mosfr,3)
   ?'TOVM '+str(skl_r,7)+' '+str(mntov,7)+' OSN '+str(osn,10,3)+'->'+str(mosnr,10,3),;
   +' OSV '+str(osv,10,3)+'->'+str(mosvr,10,3),;
   +' OSFO '+str(osfo,10,3)+'->'+str(mosfor,10,3),;
   +' OSF '+str(osf,10,3)+'->'+str(mosfr,10,3)
   netrepl('osn,osv,osfo,osfo','mosnr,mosvr,mosfor,mosfor')
endif
retu .t.

