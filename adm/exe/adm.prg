* MENU[1],MENU[2] зарезервировано
*
para exer
clea
if empty(exer)
   ?'Запустите START.BAT'
   inkey(3)
   retu
endif
if upper(exer)#'S'
   ?'Запустите START.BAT'
   inkey(3)
   retu
endif


gnArm=1

priv menu[6]

MENU[3] := "Сервис"
MENU[4] := "Регистрация"
MENU[5] := "Тесты"
MENU[6] := "Уд.склады"

lmenur=len(menu)  && Количество pad
priv CL_L[lmenur]  && Позиция pad 
priv sizam[lmenur] && Количество bar


priv menu3[11]
MENU3[1] := "Индексация        "
MENU3[2] := "Структуры         "
MENU3[3] := "CP866             "
MENU3[4] := "Переворот         "
MENU3[5] := "Выбор склада      "
MENU3[6] := "Корр БД(период)   "
MENU3[7] := "Корр индексов     "
MENU3[8] := "Корр БД+Пр(Stop)  "
MENU3[9] := "Корр Общ(Stop)    "
MENU3[10] := "Корр БД+Пр(NStop)"
MENU3[11] := "Корр Общ(NStop)  "

priv menu4[9]
MENU4[1] := "Пользователи"
MENU4[2] := "Грузчики    "
MENU4[3] := "SETUP       "
MENU4[4] := "CSKL        "
MENU4[5] := "DBFT        "
MENU4[6] := "CGRP        "
MENU4[7] := "TSKL        "
MENU4[8] := "КАССЫ       "
MENU4[9] := "АРМы        "

priv menu5[21]
MENU5[1] := "CTOV merch    "
MENU5[2] := "Пров индексов " 
menu5[3] := "Коррекция авт "
menu5[4] := "Корр.счетчиков"
menu5[5]:= "Корр авт.аренды"
menu5[6]:=  "Перемещение   "
menu5[7]:= "Корр MERCH     "
menu5[8]:= "Сжатие CTOV    "
menu5[9]:= "Пакет изм ттн  "
menu5[10]:= "Корр NDS       "
menu5[11]:= "Корр возв тары "
menu5[12]:= "Чистка уд скл  "
menu5[13]:= "Тест           "
menu5[14]:= "Корр RS1KPK    "
menu5[15]:= "DOKK(O)->DOP   "
menu5[16]:= "DOKKO          "
menu5[17]:= "COMM->ENT      "
menu5[18]:= "RS1->KOLPOS    "
menu5[19]:= "NAP            "
menu5[20]:= "Двойники Dokk  "
menu5[21]:= "Уд рсх Джаффа  "

priv menu6[9]
MENU6[1] := "SEND           " 
menu6[2] := "RECIEVE        "
MENU6[3] := "Настройка      "
MENU6[4] := "Прием Арх(уд)  " 
MENU6[5] := "Прием Арх(лок) " 
menu6[6] := "Передача файлов"
menu6[7] := "Прием файлов   "
menu6[8] := "Сверка         "
menu6[9] := "Протокол       "

SIZAM[3] := len(menu3)
SIZAM[4] := len(menu4)
SIZAM[5] := len(menu5)
SIZAM[6] := len(menu6)

maine()