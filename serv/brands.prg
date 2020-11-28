/***********************************************************
 * Модуль    : brands.prg
 * Версия    : 0.0
 * Автор     :
 * Дата      : 02/07/18
 * Изменен   :
 * Примечание: Текст обработан утилитой CF версии 2.02
 */

#include "inkey.ch"
// Бренды маркодержателей
save screen to svscbr
clea
/*
*sele brnac
*if recc()=0
*   netadd()
*endif
*/
sele brand
set orde to tag t2
if (!netseek('t2', 'mkeepr'))
  go top
/*
*   netadd()
*   netrepl('mkeep','mkeepr')
*/
endif

rcbrandr=recn()
while (.t.)
  sele brand
  set orde to tag t2
  go rcbrandr
  foot('ENTER,INS,DEL,F4', 'Состав,Доб.,Уд.,Корр')
  // rcbrandr=slcf('brand',1,1,18,,"e:brand h:'КодC' c:n(4) e:nbrand h:'Наименование' c:с(40) e:mkbrand h:'КодИзг' c:n(10) e:getfield('t1','brand->brand','brnac','nac') h:'Ск1' c:n(6,2) e:getfield('t1','brand->brand','brnac','nac1') h:'Ск2' c:n(6,2) e:getfield('t1','brand->brand','brnac','minzen1') h:'М' c:n(1)",,,1,'mkeep=mkeepr',,,alltrim(nmkeepr))
  rcbrandr:=slcf('brand', 1, 1, 18,, "e:brand h:'КодC' c:n(4) e:nbrand h:'Наименование' c:с(35) e:mkbrand h:'КодИзг' c:n(10) e:grbrand h:'Гр' c:n(2) e:codelist h:'Список статей' c:с(20)",,, 1, ;
                  'mkeep=mkeepr',,, alltrim(nmkeepr)                                                                                                                                            ;
               )
  if (lastkey()=K_ESC)
    exit
  endif

  sele brand
  go rcbrandr
  brandr=brand
  nbrandr=nbrand
  mkbrandr=mkbrand
  grbrandr=grbrand
  codelistr:=codelist
  /*
  *   sele brnac
  *   if !netseek('t1','brandr')
  *      netadd()
  *      netrepl('brandr')
  *   endif
  *   nacr=nac
  *   nac1r=nac1
  *   minzen1r=minzen1
  *   ftxtr=ftxt
  *   sele brand
  */
  do case
  case (lastkey()=K_INS)  // Добавить
    BrandIns(0)
  case (lastkey()=K_F4)   // Коррекция
    BrandIns(1)
  case (lastkey()=K_ENTER)// Cостав
    BrandBody()
  case (lastkey()=K_DEL)  // Удалить
    sele ctov
    set orde to tag t7
    while (netseek('t7', 'brandr'))
      netrepl('brand', '0')
    enddo

    sele brand
    netdel()
    skip -1
    if (bof().or.mkeep#mkeepr)
      if (!netseek('t2', 'mkeepr'))
        rcbrandr=recn()
      endif

    endif

    rcbrandr=recn()
  endcase

enddo

rest screen from svscbr

/***********************************************************
 * BrandIns() -->
 *   Параметры :
 *   Возвращает:
 */
function BrandIns(p1)
  //local getlist:={}
  if (p1=0)
    brandr=0
    grbrandr=0
    nbrandr=space(40)
    mkbrandr=0
    grbrandr=0
    nacr=0
    nac1r=0
    minzen1r=0
    ftxtr=space(20)
    codelistr:=space(64)
    //else
  //codelistr:=codelist
  endif

  scbrinsr=setcolor('gr+/b,n/w')
  wbrinsr=wopen(8, 10, 14, 70)
  wbox(1)
  while (.t.)
    if (empty(p1))
      @ 0, 1 say 'Код бренда свой '+' '+str(brandr, 10)
    else
      @ 0, 1 say 'Код бренда свой ' get brandr pict '9999999999'
    endif

    @ 1, 1 say 'Наименование    ' get nbrandr
    @ 2, 1 say 'Код бренда изг. ' get mkbrandr pict '9999999999'
    @ 3, 1 say 'Группа своя     ' get grbrandr pict '99' valid brgrbr()
    @ 4, 1 say 'Список код опер ' get codelistr pict '@S20 XXXXXXXXXXXXXXXXXXXX'
    /*
     *   @ 3,1 say 'Скидка1         '  get nacr pict '999.99'
     *   @ 4,1 say 'Скидка1         '  get nac1r pict '999.99'
     *   @ 5,1 say 'Мин. цена       '  get minzen1r pict '9'
     *   @ 6,1 say 'Основание       '  get ftxtr
     */
    read
    if (lastkey()=K_ESC)
      exit
    endif

    if (p1=0)
      sele cntcm
      go top
      if (brand=0)
        netrepl('brand', '1')
      endif

      while (.t.)
        reclock()
        brandr=brand
        netrepl('brand', 'brand+1')
        if (!netseek('t1', 'brandr', 'brand'))
          exit
        endif

        sele cntcm
      enddo

    endif

    sele brand
    if (p1=0)
      netadd()
      netrepl('mkeep,brand', 'mkeepr,brandr')
    endif

    netrepl('nbrand,mkbrand,grbrand,codelist', 'nbrandr,mkbrandr,grbrandr,codelistr')
    rcbrandr:=recn()
    exit
  enddo

  wclose(wbrinsr)
  setcolor(scbrinsr)
  return (.t.)

/***********************************************************
 * BrandBody() -->
 *   Параметры :
 *   Возвращает:
 */
function BrandBody()
  sele ctov
  set orde to tag t6
  if (netseek('t6', 'mkeepr'))
    rcctovr=recn()
  else
    rcctovr=1
  endif

  while (.t.)
    foot('INS,DEL', 'Доб.,Уд.')
    sele ctov
    go rcctovr
    rcctovr=slcf('ctov', 3, 5, 10,, "e:mntov h:'Код' c:n(7) e:nat h:'Наименование' c:с(40) e:merch h:'M' c:n(1)",,, 1, ;
                  'mkeep=mkeepr', 'brand=brandr',, str(brandr, 10)+' '+alltrim(nbrandr)                             ;
               )
    if (lastkey()=K_ESC)
      exit
    endif

    sele ctov
    go rcctovr
    do case
    case (lastkey()=K_INS)// Добавить
      if (select('sl')=0)
        sele 0
        use _slct alias sl excl
      endif

      sele sl
      zap
      sele ctov
      if (netseek('t6', 'mkeepr'))
        rcctovrr=recn()
      else
        rcctovrr=1
      endif

      foot('SPACE,ENTER,ESC', 'Отбор,Выполнить,Отмена')
      while (.t.)
        rcctovrr=slcf('ctov', 5, 10, 10,, "e:mntov h:'Код' c:n(7) e:nat h:'Наименование' c:c(40) e:merch h:'M' c:n(1) ",, 1,, 'mkeep=mkeepr', 'brand=0')
        sele ctov
        go rcctovrr
        if (lastkey()=K_ENTER)
          sele sl
          go top
          while (!eof())
            rcctovrr=val(kod)
            sele ctov
            go rcctovrr
            netrepl('brand', 'brandr')
            sele sl
            skip
          enddo

          exit
        endif

        if (lastkey()=K_ESC)
          exit
        endif

      enddo

      sele ctov
      if (netseek('t6', 'mkeepr'))
        rcctovr=recn()
      else
        rcctovr=1
      endif

    case (lastkey()=K_DEL)// Удалить
      netrepl('brand', '0')
      skip -1
      if (bof())
        go top
      endif

      rcctovr=recn()
    endcase

  enddo

  return (.t.)

/*************** */
function brgrbr()
  /*************** */
  oldwr=wselect(0)
  if (grbrandr#0)
    sele grbr
    if (!netseek('t1', 'mkeepr,grbrandr'))
      grbrandr=0
    endif

  endif

  if (grbrandr=0)
    sele grbr
    if (netseek('t1', 'mkeepr'))
      rcgrbrr=recn()
      while (.t.)
        sele grbr
        go rcgrbrr
        foot('ЕNTER', 'Выбор')
        rcgrbrr=slcf('grbr', 1, 30,,, "e:grbrand h:'Код' c:n(2) e:ngrbrand h:'Наименование' c:с(40)",,,, 'mkeep=mkeepr',,, 'Группы брендов')
        if (lastkey()=K_ESC)
          exit
        endif

        if (lastkey()=K_ENTER)
          go rcgrbrr
          grbrandr=grbrand
          exit
        endif

      enddo

    endif

  endif

  wselect(wbrinsr)
  return (.t.)
