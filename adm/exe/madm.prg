/***********************************************************
 * �����    : madm.prg
 * �����    : 0.0
 * ����     :
 * ���      : 02/14/20
 * �������   :
 * �ਬ�砭��: ����� ��ࠡ�⠭ �⨫�⮩ CF ���ᨨ 2.02
 */

if ( Lastkey()=13 )
  if ( gnAdm#1 )
    save scre to scmess
    mess( '� ��� ��� �ࠢ ��� ࠡ��� � �⨬ �����', 1 )
    rest scre from scmess
    return
  endif

  do case
  case ( I = 3 )            //Cthdbc
    do case
    case ( pozicion=1 )
      ABINDX( 1 )           //��������
    case ( pozicion=2 )
      abindx( 2 )           //��������
    case ( pozicion=3 )
      abindx( 3 )           //CP866
    case ( pozicion=4 )
      prvm()                //��ॢ���
    case ( pozicion=5 )
      vpath()               //�롮� ᪫���
    case ( pozicion=6 )
      crdbc()               // ���� ��
                            //                 ctov()      //��騩 �ࠢ�筨� ctov
    case ( pozicion=7 )
      abindx( 7 )           //���४�� �����ᮢ
    case ( pozicion=8 )
      indxst()              // �������� Stop mcrdbc.prg
    case ( pozicion=9 )
      indxcm()              // �������� comm Stop mcrdbc.prg
                            //                 abindx(4)   //��� 6 ������
    case ( pozicion=10 )
      indxnst()             // �������� NStop mcrdbc.prg
      abindx( 5 )           //���⥫�騪 �/�
    case ( pozicion=11 )
      indxcmnst()           // �������� comm NStop mcrdbc.prg
                            //                 abindx(6)   //12 �� �����
    case ( pozicion=12 )
    //                 final()   // ������� �����
    case ( pozicion=13 )
    //                 netrs1()  // ������� ���㬥���
    case ( pozicion=14 )
      ctov()                //��騩 �ࠢ�筨� ctov
                            //                 corvt()   // ���४�� ���㬥�⮢ �� �����.�� (tpokb,tpstb)
    endcase

  case ( I = 4 )            //���������
    do case
    case ( pozicion=1 )
      users()               //���짮��⥫�
    case ( pozicion=2 )
      s_gru()               //���稪�
    case ( pozicion=3 )
      setup()               //setup
    case ( pozicion=4 )
      s_cskl()              //������
    case ( pozicion=5 )
      s_dbft()              //dbft
    case ( pozicion=6 )
      s_cgrp()              //cgrp
    case ( pozicion=7 )
      s_tskl()              //s_cskl
    case ( pozicion=8 )
      setks()               //setks
    case ( pozicion=9 )
      arms()                //setup
    endcase

  case ( I = 5 )            //�����
    do case
    case ( pozicion=1 )
      //                 podg()    //�����⮢��
      ctovmerch()
    case ( pozicion=2 )
      indall()
    case ( pozicion=3 )
      corauto()
    //                 ee()
    case ( pozicion=4 )
      corrch()
    case ( pozicion=5 )
      crarnd()              // sinctov.prg
                            //                 sinctov()
    case ( pozicion=6 )
      cpfls()
    case ( pozicion=7 )
      crmerch()             // corrnds.prg
                            //                 dkklnsc() // kplkgp.prg
    case ( pozicion=8 )
      ctovpk()
    case ( pozicion=9 )
      //                 kplif() // ���������� SDV
      zensdva()             // ���� �� SDV ����
    case ( pozicion=10 )
      corrnds()
    case ( pozicion=11 )    // "���� ���� ��� "
      corvt()
    case ( pozicion=12 )
      if ( gnEntrm=1 )
        skclea()
      endif

    case ( pozicion=13 )
      test()
    case ( pozicion=14 )
      CrRs1Kpk()            // corrnds.prg
      CrProt()              // corrnds.prg PRO,RSO
    case ( pozicion=15 )
      crdop()               // skclea.prg
    case ( pozicion=16 )
      chkdo()               // skclea.prg
    case ( pozicion=17 )
      cment()               // skclea.prg
    case ( pozicion=18 )
      rskolpos()            // skclea.prg
    case ( pozicion=19 )
      docnap()              // skclea.prg
    case ( pozicion=20 )
      dokkdv()              // skclea.prg
    case ( pozicion=21 )
      delrs102()            // skclea.prg
    endcase

  case ( I = 6 )            //�������� ᫠��
    do case
    case ( pozicion=1 )     // SEND
      rmmain( 1, 0 )        // rmsdrc
    case ( pozicion=2 )     // RECIEVE
      rmmain( 2, 0 )        // rmsdrc
    case ( pozicion=3 )     // ����ன��
      rmset()
    case ( pozicion=4 )     // RECIEVE ARC ext
      rmmain( 2, 1 )        // rmsdrc
    case ( pozicion=5 )     // RECIEVE ARC loc
      rmmain( 2, 4 )        // rmsdrc
    case ( pozicion=6 )     // ��।�� 䠩���
      rmmain( 1, 2 )        // rmsdrc
    case ( pozicion=7 )     // �ਥ� 䠩���
      rmmain( 2, 2 )        // rmsdrc
    case ( pozicion=8 )     // ���ઠ �ਥ�
      rmmain( 2, 3 )
    case ( pozicion=9 )     // ��⮪��
      rmprot()
    endcase

  endcase

  keyboard chr( 5 )
endif

return ( .T. )
