* MENU[1],MENU[2] ��१�ࢨ஢���
*
para exer
clea
if empty(exer)
   ?'������� START.BAT'
   inkey(3)
   retu
endif
if upper(exer)#'S'
   ?'������� START.BAT'
   inkey(3)
   retu
endif


gnArm=1

priv menu[6]

MENU[3] := "��ࢨ�"
MENU[4] := "���������"
MENU[5] := "�����"
MENU[6] := "��.᪫���"

lmenur=len(menu)  && ������⢮ pad
priv CL_L[lmenur]  && ������ pad 
priv sizam[lmenur] && ������⢮ bar


priv menu3[11]
MENU3[1] := "��������        "
MENU3[2] := "��������         "
MENU3[3] := "CP866             "
MENU3[4] := "��ॢ���         "
MENU3[5] := "�롮� ᪫���      "
MENU3[6] := "���� ��(��ਮ�)   "
MENU3[7] := "���� �����ᮢ     "
MENU3[8] := "���� ��+��(Stop)  "
MENU3[9] := "���� ���(Stop)    "
MENU3[10] := "���� ��+��(NStop)"
MENU3[11] := "���� ���(NStop)  "

priv menu4[9]
MENU4[1] := "���짮��⥫�"
MENU4[2] := "���稪�    "
MENU4[3] := "SETUP       "
MENU4[4] := "CSKL        "
MENU4[5] := "DBFT        "
MENU4[6] := "CGRP        "
MENU4[7] := "TSKL        "
MENU4[8] := "�����       "
MENU4[9] := "����        "

priv menu5[21]
MENU5[1] := "CTOV merch    "
MENU5[2] := "�஢ �����ᮢ " 
menu5[3] := "���४�� ��� "
menu5[4] := "����.���稪��"
menu5[5]:= "���� ���.�७��"
menu5[6]:=  "��६�饭��   "
menu5[7]:= "���� MERCH     "
menu5[8]:= "���⨥ CTOV    "
menu5[9]:= "����� ��� ��  "
menu5[10]:= "���� NDS       "
menu5[11]:= "���� ���� ��� "
menu5[12]:= "���⪠ � ᪫  "
menu5[13]:= "����           "
menu5[14]:= "���� RS1KPK    "
menu5[15]:= "DOKK(O)->DOP   "
menu5[16]:= "DOKKO          "
menu5[17]:= "COMM->ENT      "
menu5[18]:= "RS1->KOLPOS    "
menu5[19]:= "NAP            "
menu5[20]:= "�������� Dokk  "
menu5[21]:= "�� ��� �����  "

priv menu6[9]
MENU6[1] := "SEND           " 
menu6[2] := "RECIEVE        "
MENU6[3] := "����ன��      "
MENU6[4] := "�ਥ� ���(�)  " 
MENU6[5] := "�ਥ� ���(���) " 
menu6[6] := "��।�� 䠩���"
menu6[7] := "�ਥ� 䠩���   "
menu6[8] := "���ઠ         "
menu6[9] := "��⮪��       "

SIZAM[3] := len(menu3)
SIZAM[4] := len(menu4)
SIZAM[5] := len(menu5)
SIZAM[6] := len(menu6)

maine()