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


gnArm=25

priv menu[9]

MENU[3] := "Агенты"
MENU[4] := "МД"
MENU[5] := "Клиенты"
MENU[6] := "Товар"
MENU[7] := "Статист"
MENU[8] := "Доставка"
MENU[9] := "ТМ"

lmenur=len(menu)   && Количество pad
priv CL_L[lmenur]  && Позиция pad
priv sizam[lmenur] && Количество bar



priv menu3[11]
MENU3[1]  := "Агенты          "
MENU3[2]  := "Маршруты        "
MENU3[3]  := "Категории ГП    "
MENU3[4]  := "Коррекция       "
MENU3[5]  := "Месячный план   "
MENU3[6]  := "Структура продаж"
MENU3[7]  := "Напрвления      "
MENU3[8]  := "Бонусы          "
MENU3[9]  := "План по SV      "
MENU3[10] := "Пользователи    "
MENU3[11] := "Супервайзеры    "

priv menu4[9]
MENU4[1] := "Маркодержатели"
MENU4[2] := "Наценки       "
MENU4[3] := "Месячный план "
MENU4[4] := "Остатки по мд "
MENU4[5] := "МД отч по дн. "
MENU4[6] := "Корр j:\ost   "
MENU4[7] := "mkkplkgp(27)  "
MENU4[8] := "TPOK(27) кеги "
MENU4[9] := "TPOK(27) кегиK"

priv menu5[13]
MENU5[1] := "Плательщики    "
MENU5[2] := "Грузополучатели"
MENU5[3] := "Торг.места (ТМ)"
MENU5[4] := "Справочник     "
MENU5[5] := "Поставщики     "
MENU5[6] := "Районы         "
MENU5[7] := "Сети грузополуч"
MENU5[8] := "Скидки списком "
MENU5[9] := "Скидки по усл. "
MENU5[10] := "Сети плательщ."
MENU5[11] := "Акции - список"
MENU5[12] := "Акции - товар "
MENU5[13] := "Акции - ТМ    "

priv menu6[6]
MENU6[1] := "Виды продукции"
MENU6[2] := "CROSID        "
MENU6[3] := "Ост быстро    "
MENU6[4] := "Товар(CTOV)   "
MENU6[5] := "POS BRAND     "
MENU6[6] := "POS ID        "

priv menu7[3]
MENU7[1] := "Коды статистики"
MENU7[2] := "Коррекция CTOV "
MENU7[3] := "Коды строк     "

priv menu8[12]
MENU8[1] := "Маршрутн листы"
MENU8[2] := "Доставка      "
MENU8[3] := "Маршруты      "
MENU8[4] := "Корр на начало"
MENU8[5] := "Корр текущая  "
MENU8[6] := "Сл.Типы Грузов"
MENU8[7] := "Сл.Грузовики  "
MENU8[8] := "Сл.Водит/Эксп "
MENU8[9] := "Сл.Экспорт    "
MENU8[10] := "Сл.Импорт     "
MENU8[11] := "Сл.Сеансы Эксп"
MENU8[12] := "Сл.Сеансы Имп."

priv menu9[1]
MENU9[1] := "Торговые марки"

SIZAM[3] := len(menu3)
SIZAM[4] := len(menu4)
SIZAM[5] := len(menu5)
SIZAM[6] := len(menu6)
SIZAM[7] := len(menu7)
SIZAM[8] := len(menu8)
SIZAM[9] := len(menu9)

maine()
