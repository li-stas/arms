/*****************************************************************
 
 FUNCTION:
 �����..����..........�. ��⮢��  10-17-12 * 08:07:31pm
 ����������.........
 ���������..........
 �����. ��������....
 ����������.........
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
������,Pay,,,,
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
         //��� �த���,��� ������,EDRPOU,,*,
         pay->EDRPOU:= cEDRPU
         //��� �࣮��� �窨,�����䨪��� �࣮��� �窨,TTID,��ப�,*,
         pay->TTID  := str(skdoc->kgp)
         //��� ������,��� ������,Date,��ப� (��.��.����),*,
         DtOplr:=IIF(EMPTY(skdoc->DtOpl),skdoc->DOP,skdoc->DtOpl)
         //��� ������,��� ������,Date,��ப� (��.��.����),*,
  #ifdef __CLIP__
         pay->Date  := DTOC(DtOplr,"DD.MM.YYYY")
  #endif
         //��� ��� ������,"1-������, 2-���",PayType,��ப�,*,������
         pay->PayType := "1"
         //�㬬�,�㬬� ������ ��� ���,Summa,��ப�,*,
         pay->Summa   := str((nSdp/(100+nVat)*100),15,2)
         //�㬬����,�㬬� ���,SummaVAT,��ப�,*,
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
            AADD(aMessErr,STR(_FIELD->mntovt)+" ��� ��� �� "+alltrim(Nat)+CHR(10)+CHR(13))
          ELSE
            IF ASCAN(aMessErr,{|cElem|STR(_FIELD->mntovt)$cElem})=0
              AADD(aMessErr,STR(_FIELD->mntovt)+" ��� ��� �� "+alltrim(Nat)+CHR(10)+CHR(13))
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
������,Orders,,,,
      ������������� ����,���ᠭ��,��� � ⠡��� ���㧪�,��� ����,����������� �।��⠢�����,
      */
      crtt("Orders",'f:EDRPOU c:c(15)  f:TTID c:c(15) f:BAR c:c(15)  f:OrderDate c:c(15) f:DelivDate c:c(15)  f:Cnt c:c(15) f:Price c:c(15) f:Summa c:c(15)  f:SummaVAT c:c(15)  f:TAID c:c(15)  f:OrderID c:c(36)  f:MPID c:c(15) f:SummaDisc c:c(15)')
      use Orders new

     sele mkdoc
     DBGoTop()
     //DBGOBOTTOM();     DBSKIP()
     Do While !mkdoc->(eof())
       If (mkdoc->vo=9 .and. mkdoc->D0K1=0) ; //!! "0" - �த���
          .and. !(STR(mkdoc->Sk,3) $ cListNoSaleSk) ;
          .and.  mkdoc->(EVAL(bRmSkl))

        Orders->(DBAppend())
        //��� �த���,��� ������,EDRPOU,��ப�,*,
        Orders->EDRPOU := cEDRPU
        //��� �࣮��� �窨,�����䨪��� �࣮��� �窨,TTID,��ப�,*,
        Orders->TTID := str(mkdoc->kgp)
        //��� ������������, ����-���,BAR,��ப�,*,
        Orders->BAR  := str(mkdoc->bar)
  #ifdef __CLIP__
        //��� ������,��ਮ� ����祭�� ������ � ��,OrderDate,��ப� (��.��.����),*?,��� ᮧ����� ���. � ��� ��� �믨᪨
        cOrderDate:=GetDataField(mkdoc->Sk,"rs1","_rs1","t1","mkdoc->ttn","_rs1->TimeCrtFrm")
        dOrderDate:=CTOD(LEFT(cOrderDate,10),"YYYY-MM-DD")
        dOrderDate:=IIF(empty(dOrderDate),mkdoc->DTtn,dOrderDate)
        Orders->OrderDate:= DTOC(dOrderDate,"DD.MM.YYYY")
        //������㥬�� ��� ���⠢��,������㥬� ��ਮ� ���⠢�� ⮢�� � ��,DelivDate,��ப� (��.��.����),*?,��� ������㥬�� ���⠢�� � ����. - 業�ࠧ����
        dDelivDate:=GetDataField(mkdoc->Sk,"rs1","_rs1","t1","mkdoc->ttn","_rs1->DtRo")
        dDelivDate:=IIF(empty(dDelivDate),mkdoc->DTtn+1,dDelivDate)
        Orders->DelivDate:= DTOC(dDelivDate,"DD.MM.YYYY")
  #endif
        //������⢮ ,������⢮ ����������� ⮢�� � ��,Cnt,��ப�,*,
        Orders->Cnt := str(mkdoc->kvp)
        //����,���� ⮢��,Price,��ப�,* �����?,������ ��।����� � ࠭��
        Orders->Price := str(mkdoc->zenn)
        //�㬬�,�⮨����� ����������� ⮢�� ��� ���,Summa,��ப�,* � ����� 業��,������ ��।����� � ࠭��
        Orders->Summa := str(mkdoc->kvp*mkdoc->zenn,15,2)
        //�㬬����,�㬬� ���,SummaVAT,��ப�,*,
        Orders->SummaVAT := str((VAL(Orders->Summa)/100)*nVat,15,2)
        //�������,������� �࣮���� �����,TAID,��ப�,*?,��� (��।����� �� ����)
        Orders->TAID := str(mkdoc->kta)
        //�����䨪��� ������,����� ������. ����室��� ��� ������� �믮������ �������. �� ������� �����䨪���� ���� ᮯ��⠢������ ������ � ���⠢����,OrderID,��ப�,*?,� ��� � ����.
        cDocGuId:=IIF(empty(mkdoc->DocGuId),GUID_KPK("F",ALLTRIM(LTRIM(STR(mkdoc->SK))+PADL(LTRIM(STR(mkdoc->TTN)),7,"0"))),mkdoc->DocGuId)
        Orders->OrderID := cDocGuId
        //�����४⨭������ணࠬ��,� ��砥 ���㧪� � ᪨���� ��� ��樮���� �ணࠬ��,MPID,��ப�,?,���
        Orders->MPID := ""
        //�㬬�������,�㬬� ᪨��� �� �ࠩ�-����,SummaDisc,��ப�,*?,���
        Orders->SummaDisc := ""
       EndIf

       mkdoc->(DBSkip())
     EndDo
    close Orders


  /*
���⠢��/�த���,Sale
  ������������� ����,���ᠭ��,��� � ⠡��� ���㧪�,��� ����,����������� �।��⠢�����
  �த���
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
      //��� �த���,��� ������,EDRPOU,��ப�,*
      (cSale)->EDRPOU := cEDRPU
      // ��ࢮ� �᫮ ᫥���饣� ����� ⥪�饣� ������
      (cSale)->Date := DTOC(EOM(dMkDt)+1,"DD.MM.YYYY")
      (cSale)->Cnt := ATREPL(".",str(0),".")
      (cSale)->Price := ATREPL(".",str(0),".")
      (cSale)->Summa := ATREPL(".",str(0),".")
    */
   Else

     Do While !mkdoc->(eof())
        IF mkdoc->vo=9 .and. mkdoc->D0K1=1 //��室
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
           TTIDr:="�����. ����."
           //sele SaleIn
           cSale:="SaleIn"
           //mkdoc->(DBSkip())
           //LOOP
         ENDIF

         (cSale)->(DBAppend())
         //��� �த���,��� ������,EDRPOU,��ப�,*
         (cSale)->EDRPOU := cEDRPU
         //��� �࣮��� �窨,�����䨪��� �࣮��� �窨,TTID,��ப�,*
         (cSale)->TTID := TTIDr
         //����� �த��,"����� �த�� (��४�, ������, VIP � �.�)",Chanel,��ப�,*
         kgpcatr:=getfield("t1","mkdoc->kgp","kgp","kgpcat")
         nkgpcatr:=getfield("t1","kgpcatr","kgpcat","nkgpcat")
         (cSale)->Chanel    := nkgpcatr        //����� (������,VIP,Horeca, ����)
         //��� ������������,����-���,BAR,��ப�,*
         (cSale)->BAR := str(mkdoc->bar)           //����-��� �த�樨;
         //��� ���⠢��,��� 䠪��᪮� ���⠢�� ⮢�� � ��,Date,��ப� (��.��.����),*

         //d_dop:=GetDataField(mkdoc->Sk,"rs1","_rs1","t1","mkdoc->ttn","_rs1->dop")
         If .F. .AND. BOM(dtEndr) # BOM(mkdoc->dttn)
           (cSale)->TTID := "�����. ����."
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
         //������⢮ ,������⢮ ���⠢������� ⮢�� � ��,Cnt,��ப�,*
         (cSale)->Cnt := ATREPL(".",str(mkdoc->kvp),".")
         //����,���� ⮢��,Price,��ப�,*�����?,������ ��।����� � ࠭��
         nPriceSale:=;
         IIF(mkdoc->KOP=177, 0, mkdoc->zen) //zenn - ���⠭��, zen- c ���

         (cSale)->Price:= ATREPL(".",str(nPriceSale),".")
         //�㬬�,"�⮨����� ���⠢������� ⮢�� ��� ��� (�᫨ ������, � �㬬� � ������ �����)",Summa,��ப�,* � ����� 業��,������ ��।����� � ࠭��
         nSummma:=mkdoc->kvp*nPriceSale
         (cSale)->Summa := ATREPL(".",str(nSummma,15,2),".")
         //�㬬����,�㬬� ��� ���⠢������� ⮢��,SummaVAT,��ப�,*
         (cSale)->SummaVAT :=ATREPL(".", str((nSummma/100)*nVat,15,2),".")
         //��ᯥ����,��� ��ᯥ����/����⥫� ���⠢��襣� �����,Forwarder,��ப�,*
         KECSr:=GetDataField(mkdoc->Sk,"rs1","_rs1","t1","mkdoc->ttn","_rs1->KECS")
         (cSale)->Forwarder := getfield('t1','KECSr','s_tag','fio')
         //�������,������� �࣮���� �����,TAID,��ப�,*
         (cSale)->TAID:=str(mkdoc->kta)
         //�㯥ࢠ����,��� �㯥ࢠ����,SVID,��ப�,*
         //(cSale)->SVID := str(getfield('t1','mkdoc->kta','s_tag','ktas'))
         (cSale)->SVID := str(getfield('t1','mkdoc->kta','s_tag','ksv'))

         //�����䨪��� ������,��뫪� �� ����� ᮣ��᭮ ���ண� �����⢫��� �த���,OrderID,��ப�,*?,� ��� � ����.
         cDocGuId:=IIF(empty(mkdoc->DocGuId),GUID_KPK("F",cAddPrefNdoc+ALLTRIM(LTRIM(STR(mkdoc->SK))+PADL(LTRIM(STR(mkdoc->TTN)),7,"0"))),mkdoc->DocGuId)
         (cSale)->OrderID := cDocGuId
         //�����䨪��� ���㧪�,����� ��������� ᮣ��᭮ ���ன �����⢫���� ���㧪� �������. ����室��� ��� ������� ������᪮� ������������,SaleID,��ப�,*,
         (cSale)->SaleID:=cAddPrefNdoc+ALLTRIM(LTRIM(STR(mkdoc->SK))+PADL(LTRIM(STR(mkdoc->TTN)),7,"0"))
         //����窠 ���⥦�,����窠 ���⥦� ��᫥ ���㧪�,Delay,��ப�,*,
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
         //�㬬�������,�㬬� ᪨��� �� �ࠩ�-����,SummaDisc,��ப�,*?,���
         (cSale)->SummaDisc:="0"

       EndIf

       mkdoc->(DBSkip())
     EndDo
   EndIf

   cSale:="Sale"
   If Empty((cSale)->(LastRec()))
      cSale:="Sale"

      (cSale)->(DBAppend())
      //��� �த���,��� ������,EDRPOU,��ப�,*
      (cSale)->EDRPOU := cEDRPU
      // ��ࢮ� �᫮ ᫥���饣� ����� ⥪�饣� ������
      (cSale)->Date := DTOC(EOM(dMkDt)+1,"DD.MM.YYYY")
      (cSale)->Cnt := ATREPL(".",str(0),".")
      (cSale)->Price := ATREPL(".",str(0),".")
      (cSale)->Summa := ATREPL(".",str(0),".")
  EndIf
  close Sale
  close SaleIn

  /*
�����/���⪨,Rest,,,,
  ������������� ����,���ᠭ��,��� � ⠡��� ���㧪�,��� ����,����������� �।��⠢�����,
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
    .and. ngMerch_Sk241 # mktov->Sk  //��⠪� ⮫쪮 ��� ���� !(STR(Sk,3) $ cListNoSaleSk)
  close mktov

  use tmpmktov alias  mktov new

  use Rest new Exclusive
  mktov->(DBGoTop())
  Do While !mktov->(eof())
     Rest->(DBAppend())
     //�����䨪��� ᪫���,"�᭮���� ᪫�� - 1, ��� - 2",WHID,��ப�,*,�� ᪫����
     IF nRm = 0 .or. nRm = -1
       DO CASE
       CASE mktov->Sk = 254
         Rest->WHID:="2" //���
       CASE mktov->Sk = 256
         Rest->WHID:="3" //�᭮���� ���
       CASE mktov->Sk = 255
         Rest->WHID:="4" //��� ���
       OTHERWISE
         Rest->WHID:="1" //�᭮����
       ENDCASE
     ELSE
       Rest->WHID:="1"
     ENDIF
     //��� ������������,����-���,BAR,��ப�,*,
     Rest->Bar := str(mktov->Bar)
     IF lJoin
     ELSE
     ENDIF
     //������⢮,�����⢮ �� ���⪠�,Cnt,��ப�,*,
     IF (UPPER("/osfon") $ UPPER(DosParam())) .OR. !EMPTY(lOsfon)
           //��� ���⪮�,���,Date,��ப� (��.��.����),*,
      #ifdef __CLIP__
           Rest->Date := DTOC(dMkDt,"DD.MM.YYYY") //osfon �� ������ ���
      #endif
       nQt:=mktov->osfon //mktov->osn
     ELSE
           //��� ���⪮�,���,Date,��ப� (��.��.����),*,
      #ifdef __CLIP__
           Rest->Date := DTOC(dMkDt + 1,"DD.MM.YYYY") //+1 � �� ������ ᫥���饣�
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
����ࠣ����,Custom ,,,,
  ������������� ����,���ᠭ��,��� � ⠡��� ���㧪�,��� ����,����������� �।��⠢�����,
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
    APPEND FROM  sbarost //������� �窨 � �����������
    index on str(kgp)+str(kpl) to tmpkpl1
    total on str(kgp)+str(kpl) to tmpkpl
    CLOSE tmpkpl1
  ENDIF

  use tmpkpl new

  Do While tmpkpl->(!eof())
    Custom->(DBAppend())
    //��� ����ࠣ���,��� ����ࠣ��� �� �ࠢ�筨��,ID,��ப�,*?,��� ���⥫�騪�
    Custom->ID := str(tmpkpl->kpl)
    //������������,����饭��� ������������ ����ࠣ���,Descr,��ப�,*,
    Custom->Descr := tmpkpl->NPL
    //������������ ������,������ ������������ ����ࠣ���,FullDescr,��ப�,*,
    Custom->FullDescr := tmpkpl->NPL
    //�ਤ��᪨� ���� ����ࠣ���,�ਤ��᪨� ���� ����ࠣ���,LegalAddr,��ப�,*,
    Custom->LegalAddr := tmpkpl->APl
    //�����᪨� ���� ����ࠣ���,���⮭�宦����� 業�ࠫ쭮�� ��� ����ࠣ���,RealAddr,��ப�,*,
    Custom->RealAddr := tmpkpl->APl
    //��� ������,"1-������, 2-���",PayType,��ப�,*,
    Custom->PayType:="1"
    //��� ����窨 ���⥦�,����窠 ���⥦� ��᫥ ���㧪�,Delay,��ப�,?*,����窠 � ����窥 ���⥫�騪� (�� �७� ��� �� 㬮��.))
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
��࣮�� �窨
  ��࣮�� �窨 ,TO,,,,
  ������������� ����,���ᠭ��,��� � ⠡��� ���㧪�,��� ����,����������� �।��⠢�����,

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
    APPEND FROM  sbarost //������� �窨 � �����������
    APPEND FROM  mkkplkgp //������� �窨 � ��� �� �����
    index on str(kgp)+str(kpl) to tmpkgp1
    total on str(kgp)+str(kpl) to tmpkgp
    CLOSE tmpkgp1
  ENDIF


  use tmpkgp new
  Do While tmpkgp->(!eof())

    TradeOutlet->(DBAppend())

    kln->(netseek("t1","tmpkgp->kgp"))
    //��� �窨,��� �窨,ID,��ப�,*,
    TradeOutlet->ID := str(tmpkgp->kgp)
    //������������ �࣮��� �窨,������������ �࣮��� �窨,Desr,��ப�,*,
    TradeOutlet->Desr := kln->Nkl
    //�������,�������,Region,��ப�,*,
    TradeOutlet->Region := "��᪠�"
    //�����,�����,District,��ப�,*,
    TradeOutlet->District := getfield("t1","kln->krn","krn","nrn")
    //��ᥫ���� �㭪� (��த),��ᥫ���� �㭪� (��த),City,��ப�,*,
    TradeOutlet->City := getfield("t1","kln->knasp","knasp","nnasp")
    //����,����,Street,��ப�,*,
    TradeOutlet->Street := kln->adr
    //���,���,House,��ப�,*,
    TradeOutlet->House := ""
    //����� �த��,����� �த��,Chanel,��ப�,*,
       kgpcatr:=getfield("t1","tmpkgp->kgp","kgp","kgpcat")
       nkgpcatr:=getfield("t1","kgpcatr","kgpcat","nkgpcat")
    TradeOutlet->Chanel := nkgpcatr        //����� (������,VIP,Horeca, ����)
    //������� �࣮���� �����,������� �࣮���� �����,TAID,��ப�,*?,��� �࣮���� ����� � ���� �ॢ易� ��㧮�����⥫�
    TradeOutlet->TAID := str(tmpkgp->kta)
    //�㯥ࢠ����,�㯥ࢠ����,SVID,��ப�,*,��� �� � ������ �ਢ易� �࣮�� �����
    //TradeOutlet->SVID := str(getfield('t1','tmpkgp->kta','s_tag','ktas'))
    TradeOutlet->SVID := str(getfield('t1','tmpkgp->kta','s_tag','ksv'))
    //���� ���饭�� �࣮�� ����⮬,"1- �������쭨� � �.�. �᫨ ��᪮�쪮 ����, � �१ �������",RouteDay,��ப�,*,
    nDow:=dow(tmpkgp->dTtn)
    IF EMPTY(nDow)
      nDow:=1
    ENDIF
    TradeOutlet->RouteDay := str({7,1,2,3,4,5,6}[nDow])
    //aDow:={7,1,2,3,4,5,6} ;    //TradeOutlet->RouteDay := str(aDow[dow(dTtn)])
    //��ਮ��筮��� ���饭��,"������⢮ ������ ����� ������묨 ����⠬� (1 - ������ ������, 2 -�१ ������ � �.�)",Period,��ப�,*?, 1 ࠧ � ������ - ��
    TradeOutlet->Period := "1"
    //��� ����ࠣ���,��뫪� �� �ࠢ箭�� ����ࠣ��⮢,CustID,��ப�,*,��� ���⥫�騪�
    TradeOutlet->CustID := str(tmpkgp->kpl)
    //����� ����� ��� ᮪�� (� ������⢥ 㯠�����),����� ����� ��� ᮪�� (� ������⢥ 㯠�����),SkuLen,��ப�,?,���
    TradeOutlet->SkuLen :=""
    //����� ����� ��� ��� (� ������⢥ ��),����� ����� ��� ��� (� ������⢥ ��),PetLen,��ப�,?,���
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
��������,Route,,,,
  ������������� ����,���ᠭ��,��� � ⠡��� ���㧪�,��� ����,����������� �।��⠢�����,
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
    //��� �������,�����䨪��� �������,TAID,��ப�,*?,���
    Route->TAID:=str(tmpkta->kta)
    //������������ �������,������������,Descr,��ப�,*?,���
    Route->Descr := str(tmpkta->kta)+" "+getfield('t1','tmpkta->kta','s_tag','fio')
    //��� �࣮���� �����,��� �࣮���� �����,TaName,��ப�,*,���
    Route->TaName := getfield('t1','tmpkta->kta','s_tag','fio')
    //����� �த�������,��뫪� �� �ࠢ�筨� ������� �த�������,Channel,��ப�,?,���
       kgpcatr:=getfield("t1","tmpkta->kgp","kgp","kgpcat")
       nkgpcatr:=getfield("t1","kgpcatr","kgpcat","nkgpcat")
    Route->Channel:=    nkgpcatr        //����� (������,VIP,Horeca, ����)
    //�ਧ��� �᪫�����,"���������� ����� ���㤭�� ⮫쪮 �த�樥� �������� ��⬠� ��� ��� (1,0)",excl,��ப�,?,���
    Route->Excl:="0"
    //��� �㯥ࢠ����,��뫪� �� �ࠢ�筨� �㯥ࢠ���஢,SVID,��ப�,*?,���
    //Route->SVID:= str(getfield('t1','tmpkta->kta','s_tag','ktas'))
    Route->SVID:= str(getfield('t1','tmpkta->kta','s_tag','ksv'))
    tmpkta->(DBSkip())
  EndDo
  close route
  close tmpkta

  /*
  �㯥ࢠ����,SV,,,,
  ������������� ����,���ᠭ��,��� � ⠡��� ���㧪�,��� ����,����������� �।��⠢�����,
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
    //��� �㯥ࢠ����,�����䨪���,SVID,��ப�,*,
    svid->SVID := str(getfield('t1','tmpskta->kta','s_tag','ktas'))
    //������������ ,������������,Descr,��ப�,*,
    svid->Descr := getfield('t1','val(alltrim(svid->SVID))','s_tag','fio')
    */
    //��� �㯥ࢠ����,�����䨪���,SVID,��ப�,*,
    svid->SVID := str(getfield('t1','tmpskta->kta','s_tag','ksv'))
    //������������ ,������������,Descr,��ப�,*,
    svid->Descr := getfield('t1','val(alltrim(svid->SVID))','svjafa','nsv')
    //����� �த�������,��뫪� �� �ࠢ�筨� ������� �த�������,Channel,��ப�,*?,���
    svid->Channel := ""
    tmpskta->(DBSkip())
  EndDo
  close svid
  close tmpskta


  /*
���� �த��
  ���� �த��,TradePlan,,,,
  ������������� ����,���ᠭ��,��� � ⠡��� ���㧪�,��� ����,����������� �।��⠢�����,
  ��ਮ� �����஢����,��� (��ࢮ� �᫮ �����),Date,��ப� (��.��.����),?,���
  ������� �࣮���� �����,������� �࣮���� �����,TAID,��ப�,?,���
  �㯥ࢠ����,��� �㯥ࢠ����,SVID,��ப�,?,���
  "����������ୠ� ��㯯�. �७� (��� , ������������) ",����뢠���� ����-���  ������������ �� ����������୮� ��㯯� (��) ,BAR,��ப�,?,���
  �㬬� ����,���� �த�� � �㬬���� ��ࠦ����,PlanSumma,��ப�,?,���
  ������⢮ �����,���� �த�� � ������⢥���� ��ࠦ����,PlanCnt,��ப�,?,���
  ���� ��⨢�樨 �࣮��� �祪,���� ��⨢�樨 �࣮��� �祪,ActTO,��ப�,?,���
  ���� �� ���⠢����� 宫����쭨���,���� �� ���⠢����� 宫����쭨���,XOCnt,��ப�,?,���
  */
  crtt("TradePlan",'f:Date c:c(15) f:TAID c:c(15) f:SVID c:c(15) f:Bar c:c(15) f:PlanSumma c:c(15) f:PlanCnt c:c(15) f:ActTO c:c(15) f:XOcnt c:c(15)')


  use sbarost new

  /*
�������쭮� � �࣮��� ����㤮����� (�ଥ��� �����)
   �� (����㤮�����),Equip,,,,
  ������������� ����,���ᠭ��,��� � ⠡��� ���㧪�,��� ����,����������� �।��⠢�����,
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
      If "���" $ UPPER(tmpktl->nat)
        Equip->(DBAppend())
        //�����䨪�����,�����䨪��� ,ID,��ப�,?,��� ⮢��
        Equip->ID    := ALLTRIM(str(tmpktl->ktl))
        //������������ ,������������,Descr,��ப�,?,������������
        Equip->Descr := tmpktl->nat
        //��� 宫����쭨��,"���ᠭ�� ����/���� �����, ���ਭ�, ?����?, ���� 宫����쭨��",Type,��ப�,?,���
        Equip->Type  := ""
      EndIf
      tmpktl->(DBSkip())
    EndDo
    close tmpktl
    close Equip
  ENDIF

   /*
  ���⮯�������� ��,EqPlace,,,,
  ������������� ����,���ᠭ��,��� � ⠡��� ���㧪�,��� ����,����������� �।��⠢�����,
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
      If "���" $ UPPER(sbarost->nat) //.and. sbarost->osf > 0
        EqPlace->(DBAppend())
        //���,��� ��������,Date,��ப� (��.��.����),?,�� ��� ���㧪�
    #ifdef __CLIP__
           dArDt:=IIF(EMPTY(sbarost->ArDt),DATE(),DATE()) //sbarost->ArDt)
           EqPlace->Date       :=DTOC(dArDt,"DD.MM.YYYY")
    #endif
        //��� ���⮭�宦�����,
        //"1 - ����ࠣ��� , 2 - ᪫�� ����ਡ���",PlaceType,��ப�,?,�� �ணࠬ�� �㡠७��
        EqPlace->PlaceType      := ALLTRIM(iif(sbarost->ArNd = 2,str(2),str(1)))
        //���⮭�宦����� ��,"��뫪� �� �ࠢ�筨� �� ��� �� ����� � ����ᨬ���
        //�� ���� ��� ���⮭�宦�����.
        //�᫨ ᪫��, � 1 -�᭮����, 2 - ���",Place,��ப�,?,���� ��㧮�����⥫�
        EqPlace->Place  := (iif(sbarost->ArNd = 2,str(1),str(sbarost->kgp)))
        //�����䨪�����,��뫪� �� �ࠢ�筨� ��,EqId,��ப�,?,��� ⮢��
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
    Report->C1R1:="���� ��"
    Report->C1R2:=DMY(dtBegr)+" �� "
    Report->C1R3:=DMY(dtEndr)
    Report->C1R4:=" "+cEDRPU

    Report->(DBAppend())
    Report->C1R1:="�⮣�"
    Report->C1R2:="�㬬� �த, ��"
    Report->C1R3:="�-�� ��, ��"
    Report->C1R4:="�㬬� ���, ��"

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
    Report->C1R1:="���� ��"
    Report->C1R2:=DMY(dtBegr)+" �� "
    Report->C1R3:=DMY(dtEndr)
    Report->C1R4:=" "+cEDRPU

    Report->(DBAppend())
    Report->C1R1:="SKU - ��"
    Report->C1R2:="�-��, ��"
    Report->C1R3:="�㬬� �த, ��"
    Report->C1R4:="������������"

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
