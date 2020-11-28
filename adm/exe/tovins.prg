/***********************************************************
 * Модуль    : tovins.prg
 * Версия    : 0.0
 * Автор     :
 * Дата      : 05/01/18
 * Изменен   :
 * Примечание: Текст обработан утилитой CF версии 2.02
Function TovIns()
  Return (Nil)
 */
#include "common.ch"
#include "inkey.ch"
/* Коррекция,просмотр,добавление карточки в TOV,TOVD,CTOV,CTOVK,TOVM
 * TOVM только просмотр
 */
para p1, p2, p3, p4

local oclr, wtinsr, mmenr, prwr, out_r
cor_r=p1                    // Режим
tov_r=p2                    // Имя таблицы ('TOV','TOVD','CTOV','CTOVK','TOVM')
mntov_r=p3                  // Для добавления в CTOV c конкретным кодом
/*prinstr=0  // Признак "запись добавлена в TOV" */
vn2 = p4                    // 1 - Не выводить на экран

if (p4#nil)
  vn2=1
endif

/* Определение допустимых режимов */
if (!(tov_r=='tov'.or.tov_r=='tovd'.or.tov_r=='ctov'.or.tov_r=='ctovk'.or.tov_r=='tovm'))
  sele (tov_r)
  netunlock()
  return
endif

if (cor_r>3)
  sele (tov_r)
  netunlock()
  return
endif

if (cor_r=1.or.cor_r=2).and.mntov_r#nil
  sele (tov_r)
  netunlock()
  return
endif

do case
case (gnCtov=0)           // С одним справочником
  if (!tov_r=='tov')
    sele (tov_r)
    netunlock()
    return
  endif

  if (mntov_r#nil)
    sele (tov_r)
    netunlock()
    return
  else
    kg_r=int(ktlr/1000000)
  endif

case (gnCtov=1)           // С общим справочником по MNTOV
  if (!(tov_r=='tov'.or.tov_r=='ctov'.or.tov_r='tovm'))
    sele (tov_r)
    netunlock()
    return
  endif

  if (cor_r=0.and.(tov_r=='tov').and.mntov_r=nil)
    sele (tov_r)
    netunlock()
    return
  endif

  if (mntov_r=nil)
    do case
    case (tov_r=='tov')
      kg_r=int(ktlr/1000000)
    otherwise
      kg_r=int(mntovr/10000)
    endcase

  endif

case (gnCtov=2)           // С дополнительным справочником по KTL
  if (!(tov_r=='tov'.or.tov_r=='tovd'))
    sele (tov_r)
    netunlock()
    return
  endif

  if (tov_r=='tovd'.and.mntov_r#nil)
    sele (tov_r)
    netunlock()
    return
  endif

  if (cor_r=0.and.tov_r=='tov'.and.mntov_r=nil)
    sele (tov_r)
    netunlock()
    return
  endif

  if (mntov_r=nil)
    kg_r=int(ktlr/1000000)
  endif

case (gnCtov=3)           // С общим справочником по KTL
  if (!(tov_r=='tov'.or.tov_r=='ctovk'))
    sele (tov_r)
    netunlock()
    return
  endif

  if (tov_r=='ctovk'.and.mntov_r#nil)
    sele (tov_r)
    netunlock()
    return
  endif

  if (cor_r=0.and.tov_r=='tov'.and.mntov_r=nil)
    sele (tov_r)
    netunlock()
    return
  endif

  if (mntov_r=nil)
    kg_r=int(ktlr/1000000)
  endif

endcase

private skndsr, skdrlzr
store 0 to vupakr, kachr, mntovtr, opt_tr, barr, locr, vupakpr, arvidr, ;
 arNppr, KolAkcr, minosvr, nooptr, minosvor, NoPrnr
store '' to nupakr, nkachr, ngrpr, nger, ntovr, nat_r, nizg_r, narvidr, ;
 ArPrimr, kobolr, ArModr, posidr, posbrnr, upur, posTPIdr, posTehcor, commentr
namr=space(14)
uktr=space(10)
vn2=0
if (p4=nil)
  save scre to sctins
  oclr=setcolor('w+/b,n/w')
  clea
endif

netuse('kln')
netuse('cskle')
netuse('nei')
netuse('grp')
netuse('GrpE')
netuse('ntov')
netuse('upak')
netuse('kach')
netuse('sert')
netuse('ukach')
netuse('ntovka')
netuse('ntovup')
netuse('ntovim')
netuse('ntovig')
netuse('sgrp')
netuse('tcen')
netuse('tcen')
netuse('st1sb')
netuse('kpsmk')
netuse('kps')
netuse('arvid')

if (mntov_r#nil)
  if (gnCtov=1)
    kg_r=int(mntov_r/10000)
  else
    kg_r=int(mntov_r/1000000)
  endif

endif

sele (tov_r)
rcins_r=recn()

do case
case (gnCtov=0.or.gnCtov=2)
  FullName=getfield('t1', 'kg_r', 'sgrp', 'mark')
case (gnCtov=1)
  if (tov_r=='tov'.or.tov_r=='tovm')
    FullName=getfield('t1', 'kg_r', 'sgrp', 'mark')
  else
    FullName=getfield('t1', 'kg_r', 'cgrp', 'mark')
  endif

case (gnCtov=3)
  if (tov_r=='tov')
    FullName=getfield('t1', 'kg_r', 'sgrp', 'mark')
  else
    FullName=getfield('t1', 'kg_r', 'cgrpk', 'mark')
  endif

endcase

/* Инициализация переменных памяти */
sele (tov_r)
if (cor_r=1.or.cor_r=2)   // Коррекция/Просмотр
  do case
  case (tov_r=='tov')
    netseek('t1', 'sklr,ktlr')
  case (tov_r=='tovm')
    netseek('t1', 'sklr,mntovr')
  case (tov_r=='tovd')
    netseek('t1', 'ktlr')
  case (tov_r=='ctovk')
    netseek('t1', 'ktlr')
  case (tov_r=='ctov')
    netseek('t1', 'mntovr')
  endcase

  if (FOUND())
    rcn_rr=recn()
    if (cor_r=1)
      if (!reclock(1))
        wmess('Запись занята !!!', 1)
        sele (tov_r)
        netunlock()
        return
      endif

    endif

    if (tov_r=='tovm'.and.gnCtov=1.and.gnEntrm=1)
    /*         obncen(mntovr,1) */
    endif

    for i=1 to fcount()
      tt=fieldname(i)
      tt1=tt+'r'
      if (tt=='SKL'.and.(tov_r=='tov'.or.tov_r=='tovm'))
        loop
      endif

      if (tt=='OT'.and.(tov_r=='tov').and.int(mntovr/10000)>1)
        &tt1=getfield('t1', 'kg_r', 'sgrp', 'ot')
        loop
      endif

      if (tt=='AKC'.and.(tov_r=='tov'.or.tov_r=='tovm').and.gnCtov=1)
        &tt1=getfield('t1', 'mntovr', 'ctov', 'akc')
        loop
      endif

      if (tt=='BLKSK'.and.(tov_r=='tov'.or.tov_r=='tovm').and.gnCtov=1)
        &tt1=getfield('t1', 'mntovr', 'ctov', 'blksk')
        loop
      endif

      if (tt=='NoPrn'.and.(tov_r=='tov'.or.tov_r=='tovm').and.gnCtov=1)
        &tt1=getfield('t1', 'mntovr', 'ctov', 'NoPrn')
        loop
      endif

      if (tt=='POST'.and.gnSkotv#0.and.kpsr#0)
        &tt1=kpsr
        loop
      endif

      if (tt=='UPAKP')
        &tt1=&tt
        if (upakpr=0)
          upakpr=upakr
        endif

        loop
      endif

      if (tt='DOP')
        tt1='tov'+tt+'r'
        &tt1=&tt
        loop
      endif

      &tt1=&tt
    next

    natfr=nat               // Наименование до коррекции
    ntovr=getfield('t1', 'MnNTovr', 'ntov', 'ntov')
    ntovr=subs(ntovr, 1, 23)
    nupakr=getfield('t1', 'vupakr', 'upak', 'nupak')
    nkachr=getfield('t1', 'kachr', 'kach', 'nkach')
    notr=getfield('t1', 'gnSk,otr', 'cskle', 'nai')
    nizgr=getfield('t1', 'izgr', 'kln', 'nkl')
    narvidr=getfield('t1', 'arvidr', 'arvid', 'narvid')
    if (gnCtov=1)
      nmkeepr=getfield('t1', 'mkeepr', 'mkeep', 'nmkeep')
    else
      nmkeepr=''
    endif

    npostr=getfield('t1', 'postr', 'kln', 'nkl')
    nsertr=getfield('t1', 'ksertr', 'sert', 'nsert')
    dtukachr=getfield('t1', 'ksertr,kukachr', 'ukach', 'dtukach')
    nizg_r=getfield('t1', 'izgr', 'kln', 'nkls')
    nizgsr=nizg_r
    if (empty(nizg_r))
      nizg_r=nizgr
    endif

    if (empty(neir))
      neir=getfield('t1', 'keir', 'nei', 'nei')
    endif

    if (empty(neipr))
      neipr=getfield('t1', 'keipr', 'nei', 'nei')
    endif

    if (empty(upur))
      upur=getfield('t1', 'kspovor', 'kspovo', 'upu')
    endif

    sele (tov_r)
    go rcn_rr
    if (cor_r=1)
      if (!reclock(1))
        sele (tov_r)
        netunlock()
        return
      endif

    endif

  else
    sele (tov_r)
    netunlock()
    return
  endif

else                        // Добавить
  natfr=''
  if (mntov_r=nil)        // Добавить с новым кодом
    sele (tov_r)
    for i=1 to fcount()
      tt=fieldname(i)
      if (tt=='SKL').and.(tov_r=='tov')
        loop
      endif

      if (tt==('OT').and.(tov_r=='tov').and.int(mntovr/10000)>1)
        tt1=tt+'r'
        &tt1=getfield('t1', 'kg_r', 'sgrp', 'ot')
        loop
      endif

      if (tt=='DOP').and.(tov_r=='tov')
        tt1='tov'+tt+'r'
        &tt1=&tt
        loop
      endif

      tt1=tt+'r'
      do case
      case (fieldtype(i)='N')
        &tt1=0
      case (fieldtype(i)='C')
        &tt1=space(fieldsize(i))
      case (fieldtype(i)='D')
        &tt1=ctod('')
      endcase

    next

    kgr=kg_r

    store '' to ntovr, nupakr, nkachr, nizgr, npostr, nizg_r, natfr
    if (tov_r=='tov')
      notr=getfield('t1', 'gnSk,otr', 'cskle', 'nai')
    else
      notr=''
    endif

    if (gnSk=242.or.gnSk=243)
      natr=space(60)
    else
      natr=space(60)
    endif

    tovdopr=space(10)
    if (tov_r=='ctovk'.or.tov_r=='tovd'.or.gnSkotv#0.or.gnVo=9.or.gnVo=6.and.((kopr=168.or.kopr=185).and.(gnEnt=14.or.gnEnt=15.or.gnEnt=17).or.kopr=120.and.gnEnt=16))
      postr=kpsr
    endif

  else                      // Добавить с конкректным кодом
    do case
    case (tov_r=='tov').and.gnCtov=1
      sele ctov
    case (tov_r=='tov'.and.gnCtov=2)
      sele tovd
    case (tov_r=='tov'.and.gnCtov=3)
      sele ctovk
    case (tov_r=='ctov')
      sele ctovp
    endcase

    netseek('t1', 'mntov_r')

    store '' to ntovr, nupakr, nkachr, notr, nizgr, npostr, nizg_r, nmkeepr

    for i=1 to fcount()
      tt=fieldname(i)
      tt1=tt+'r'
      if (tt=='SKL'.and.!tov_r=='ctov')
        loop
      endif

      if (tt=='OT')
        if (tov_r=='tov')
          if (int(mntovr/1000000)<2)
            &tt1=&tt
          else
            &tt1=getfield('t1', 'kg_r', 'sgrp', 'ot')
          endif

        else
          &tt1=getfield('t1', 'kg_r', 'sgrp', 'ot')
        endif

        loop
      endif

      if (tt=='POST'.and.gnSkotv#0)
        &tt1=kpsr
        loop
      endif

      if (tt=='UPAKP')
        &tt1=&tt
        if (upakpr=0)
          upakpr=upakr
        endif

        loop
      endif

      if (tt=='DOP')
        tt1='tov'+tt+'r'
        &tt1=&tt
        loop
      endif

      &tt1=&tt
    next

    /****** */
    drlzr=ctod('')
    dizgr=ctod('')
    /********* */
    kgr=kg_r
    ntovr=getfield('t1', 'MnNTovr', 'ntov', 'ntov')
    ntovr=subs(ntovr, 1, 23)
    nupakr=getfield('t1', 'vupakr', 'upak', 'nupak')
    nkachr=getfield('t1', 'kachr', 'kach', 'nkach')
    nsertr=getfield('t1', 'ksertr', 'sert', 'nsert')
    dtukachr=getfield('t1', 'ksertr,kukachr', 'ukach', 'dtukach')
    nizgr=getfield('t1', 'izgr', 'kln', 'nkl')
    if (gnCtov=1)
      nmkeepr=getfield('t1', 'mkeepr', 'mkeep', 'nmkeep')
    else
      nmkeepr=''
    endif

    nizg_r=getfield('t1', 'izgr', 'kln', 'nkls')
    nizgsr=nizg_r
    if (empty(nizg_r))
      nizg_r=nizgr
    endif

    npostr=''
    if (tov_r=='tov')
      notr=getfield('t1', 'gnSk,otr', 'cskle', 'nai')
    else
      notr=''
    endif

    if (gnVo=9.or.gnVo=6.and.((kopr=168.or.kopr=185).and.(gnEnt=14.or.gnEnt=15.or.gnEnt=17).or.kopr=120.and.gnEnt=16))
      postr=kpsr
    endif

  endif

endif

// Вывод на экран
while (.t.)
  if (p4=nil)
    sele (tov_r)
    store 0 to b2r, b3r, b4r, b5r, cb2r, cb3r, cb4r, cb5r
    do case
    case (tov_r=='tov'.or.tov_r=='tovm')
      do case
      case (gnCtov=0)
        foot('F2,F4,F5', 'Цены скл.,Приход,Расход')
        store 1 to b2r, b4r, b5r
        if (cor_r=1)
          store 1 to cb2r
        endif

      case (gnCtov=1)
        do case
        case (cor_r=0)
          foot('F3', 'Цены общ.')
          store 1 to b3r
          store 1 to cb2r
        case (cor_r=1)
          foot('F3,F2,F4,F5', 'Цены общ.,Цены скл.,Приход,Расход')
          store 1 to b2r, b3r, b4r, b5r
          store 1 to cb2r, cb3r, cb4r, cb5r
        case (cor_r=2)
          foot('F3,F2,F4,F5', 'Цены общ.,Цены скл.,Приход,Расход')
          store 1 to b2r, b3r, b4r, b5r
          store 1 to cb2r, cb3r, cb4r, cb5r
        endcase

      case (gnCtov=2)
        foot('F2,F4,F5', 'Цены скл.,Приход,Расход')
        store 1 to b2r, b4r, b5r
        if (cor_r=1)
          store 1 to cb2r
        endif

      case (gnCtov=3.or.gnCtov=2).and.cor_r#0
        foot('F2,F4,F5', 'Цены скл.,Приход,Расход')
        store 1 to b2r, b4r, b5r
        if (cor_r=1)      //.and.cntr=0
          store 1 to cb2r
        endif

      endcase

    case (tov_r=='tovd')
      foot('F2', 'Цены скл.')
      store 1 to b2r
      if (cor_r=1)
        store 1 to cb2r
      endif

    case (tov_r=='ctov')
      foot('F3', 'Цены общ.')
      store 1 to b3r
      if (cor_r=1)
        store 1 to cb3r
      endif

    case (tov_r=='ctovk')
      foot('F2', 'Цены скл.')
      store 1 to b2r
      if (cor_r=0.or.cor_r=1)//.and.cntr=0)
        store 1 to cb2r
      endif

    endcase

    if (b2r=1)
      if (gnEnt=21)
        set key -1 to cenl()
      else
        set key -1 to cen()
      endif

    else
      set key -1 to
    endif

    if (b3r=1)
      if (gnEnt=21)
        set key -2 to cenl()
      else
        set key -2 to cen()
      endif

    else
      set key -2
    endif

    if (b4r=1)
      set key -3 to pr1ktl()
    else
      set key -3 to
    endif

    if (b5r=1)
      set key -4 to rs1ktl()
    else
      set key -4 to
    endif

    if (cor_r=0)          // Добавить
      if (!(tov_r=='tov'))
        @ 0, 1 say str(kg_r*1000000, 9)
        if (FullName=0)
          @ 0, col()+1 get natr
        else
          if (mntov_r=nil)
            @ 0, col()+1 say space(35)
          else
            @ 0, col()+1 say natr
          endif

        endif

        if (tov_r=='tov'.and.(gnCtov=2.or.gnCtov=3))
          @ 0, 1 say str(ktlr, 9)
          @ 0, col()+1 get natr
        endif

      else
        @ 0, 1 say str(kg_r*1000000, 9)
        if (FullName=0)
          @ 0, col()+1 get natr
        else
          if (mntov_r=nil)
            @ 0, col()+1 say space(35)
          else
            @ 0, col()+1 say natr
          endif

        endif

      endif

    else                    // Коррекция,просмотр
      if (tov_r=='tov'.or.tov_r=='tovd'.or.tov_r=='ctovk')
        @ 0, 1 say str(ktlr, 9)
      else
        @ 0, 1 say str(mntovr, 7)
      endif

      if (FullName=0)
        if (cor_r=1)
          @ 0, col()+1 get natr
        else
          @ 0, col()+1 say natr
        endif

      else
        @ 0, col()+1 say natr
      endif

      if (opt#0)
        nacr=(cenpr/opt-iif(fieldpos('tsz60')#0, tsz60, 0)-1)*100
        @ 0, 69 say '%нац '+str(nacr, 6, 2) color 'gr+/b'
      endif

    endif

    @ 1, 0, 23, 79 box frame
    if (gnMskl#0)
      @ 1, 1 say str(sklr, 7)+' '+alltrim(nsklr) color 'r+/b'
    endif

    ngrr=getfield('t1', 'kg_r', 'sgrp', 'ngr')
    @ 2, 1 say 'Группа(товар)'+' '+str(kg_r, 3)+' '+getfield('t1', 'kg_r', 'sgrp', 'ngr')
    if (grpr=0.and.FullName=1)
      /*********** */
      if (tov_r=='tov'.or.tov_r=='tovd'.or.tov_r=='ctovk'.or.tov_r=='tovm')
        grpr=getfield('t1', 'kg_r', 'sgrp', 'grp')
      else
        grpr=getfield('t1', 'kg_r', 'cgrp', 'grp')
      endif

      /************** */
      if (grpr=0)
        grpr=kg_r
      endif

    endif
    outlog(3,__FILE__,__LINE__,"cor_r FullName",cor_r,FullName)
    /***************************************************************************** */
    if (cor_r=2)          // Просмотр
      /***************************************************************************** */
      if (FullName=1)
        @ 3, 1 say 'Группа(наим) '+' '+str(grpr, 3)+' '+getfield('t1', 'grpr', 'grp', 'ng')
        @ 4, 1 say 'Подгруппа    '+' '+str(kger, 6)+' '+getfield('t1', 'kger', 'GrpE', 'nge')
        @ 5, 1 say 'Наименование '+' '+str(MnNTovr, 6)+' '+subs(getfield('t1', 'MnNTovr', 'ntov', 'ntov'), 1, 23)
        @ 6, 1 say 'Кач.характер. '+' '+str(kachr, 3)+' '+getfield('t1', 'kachr', 'kach', 'nkach')
        @ 7, 1 say 'Вид упаковки  '+' '+str(vupakr, 3)+' '+getfield('t1', 'vupakr', 'upak', 'nupak')
      else
        if (OnGrpE4NotFullName())
          @ 3, 1 say 'Группа(наим) '+' '+str(grpr, 3)+' '+getfield('t1', 'grpr', 'grp', 'ng')
          @ 4, 1 say 'Подгруппа    '+' '+str(kger, 6)+' '+getfield('t1', 'kger', 'GrpE', 'nge')
        endif

      endif

      @ 8, 1 say 'Уч.ед.измер.  '+' '+str(keir, 3)+' '+neir
      @ 8, col()+6 say 'КСПОВО'+' '+str(kspovor, 4)+' '+subs(upur, 1, 8)
      @ 9, 1 say 'Ед.изм.фасовки'+' '+str(keipr, 3)+' '+neipr
      if (!(tov_r=='ctov'))
        @ 10, 1 say 'Кол-во в упак.'+' '+str(upakr, 10, 3)
        @ 10, col()+1 say str(upakpr, 10, 3)
      endif

      @ 11, 1 say 'Кол-во ед.фас.'+' '+str(vespr, 10, 3)
      @ 12, 1 say 'Вес брутто ед.'+' '+str(vesr, 10, 3) +' кг'
      @ 13, 1 say 'Изготовитель  '+' '+str(izgr, 7)+' '+getfield('t1', 'izgr', 'kln', 'nkl')
      @ 14, 1 say 'Торг Марка    '+' '+str(mkeepr, 3)+' '+getfield('t1', 'mkeepr', 'mkeep', 'nmkeep')
      if (tov_r=='tov')
        @ 15, 1 say 'Поставщик     '+' '+str(postr, 7)+' '+getfield('t1', 'postr', 'kln', 'nkl')
      endif

      if (gnRoz=0)
        @ 16, 1 say 'Доп.информация'+' '+tovdopr
        if (gnArnd=0)
          KoefSay()
        else
          if (tov_r=='tovm')
            if (gnEnt=20)
              @ 19, 1 say 'Вид оборуд.'+' '+str(arvidr, 3)+' '+narvidr
              @ 20, 1 say 'Примечание '+' '+ArPrimr
              @ 21, 1 say 'N п/п      '+' '+str(arNppr, 4)
              @ 22, 1 say 'Модель     '+' '+ArModr
            endif

          endif

          if (tov_r=='tov')
            @ 16, 1 say 'Зав.N изг. '+' '+subs(znr, 1, 30)
            @ 17, 1 say 'Инв.N пост.'+' '+subs(znomr, 1, 20)
            if (gnEnt=21)
              PosSay4Ent21()
            endif

          endif

        endif

      else
        if (gnArnd=0)
          KoefGet()
          read
        else
          if (tov_r=='tovm')
            if (gnEnt=20)
              @ 19, 17 say narvidr
              @ 19, 1 say 'Вид оборуд.' get arvidr pict '999' valid arvid()
              @ 20, 1 say 'Примечание ' get ArPrimr
              @ 21, 1 say 'N п/п      ' get arNppr pict '9999'
              @ 22, 1 say 'Модель     ' get ArModr
            endif

          endif

          if (tov_r=='tov')
            @ 16, 1 say 'Зав.N изг. ' get znr pict '@S30'
            @ 17, 1 say 'Инв.N пост.' get znomr pict '@S20'
            if (gnEnt=21)
              PosGet4Ent21()
            endif

          endif

        endif

      endif

      @ 2, 46 say 'К.загр.трансп'+' '+str(kzar, 4, 2)
      if (tov_r=='ctov'.or.tov_r=='tovm')
        @ 3, 46 say 'Привяз.тара'+' '+str(m1tr, 7)//+' Цена '+str(opt_tr,8,3)
        @ 4, 46 say 'УКТ ЗЕД    '+' '+uktr
        @ 5, 46 say 'Акц.кол-во '+' '+str(KolAkcr, 10, 3)
        @ 6, 46 say 'Min OSV'+' '+str(minosvr, 10, 3)
        @ 6, 65 say 'БлкВхЦ'+' '+str(nooptr, 1)
      else
        @ 3, 46 say 'Привяз.тара'+' '+str(k1tr, 9)//+' Цена '+str(opt_tr,8,3)
      endif

      if (!(tov_r=='ctov'.or.tov_r=='tovm'))
        @ 4, 46 say 'Сертификат '+' '+str(ksertr, 6)+' '+nsertr
        @ 5, 46 say 'Кач.удостов'+' '+str(kukachr, 6)+' '+dtoc(dtukachr)
        @ 6, 46 say 'Дата изгот. '+dtoc(dizgr)
        @ 7, 46 say 'Дата реализ.'+dtoc(drlzr)
        @ 8, 46 say 'Отдел       '+' '+str(otr, 2)+' '+notr
        @ 9, 46 say 'Бонус       '+' '+str(bonr, 2)
        @ 10, 46 say 'БЛК КПК     '+' '+str(blkkpkr, 1)
      else
        @ 7, 46 say 'Бонус       '+' '+str(bonr, 2)
        @ 8, 46 say 'Для КПК     '+' '+str(merchr, 1)
        @ 8, col()+1 say 'Только 169'+' '+str(pr169r, 1)
      endif

      /************ */
      natstr=getfield('t1', 'kodst1r', 'st1sb', 'natst')
      @ 9, 46 say 'Стат.группа '+str(kodst1r, 4)+' '+subs(natstr, 1, 15)
      @ 10, 46 say 'Стат.вес    '+str(vesst1r, 12, 6)
      @ 11, 46 say 'Наимен. чек '+ namr
      if (gnRmag=1)
        if (tov_r=='tovm'.or.tov_r=='ctov')
          if (keir#166)
            @ 12, 46 say 'Штрих-код    '+' '+str(barr, 13)
          else
            @ 12, 46 say 'Код кассы авт'+' '+str(lcoder, 5)
          endif

        endif

      else
        @ 12, 46 say 'Штрих-код    '+' '+str(barr, 13)
      endif

      @ 13, 46 say 'Код кассы    '+' '+str(locr, 5)
      @ 14, 46 say 'Эн.ценн.     '+' '+str(kalr, 12, 6)
      @ 15, 46 say 'На весы      '+' '+str(sendvr, 1)
      if (tov_r=='tov'.or.tov_r=='tovm')
        @ 16, 46 say 'Родитель Т '+str(mntovtr, 7)
        @ 17, 46 say 'Родитель Ц '+str(mntovcr, 7)
        @ 18, 46 say 'Акция      '+str(akcr, 1)
        @ 18, 60 say 'Блк.ск'+str(blkskr, 1)
        @ 18, 69 say 'Блк.печ'+str(NoPrnr, 1)
      endif

      Say19_46i21_46()

    /**************************************************************************** */
    else                    // Добавить,Коррекция
      /**************************************************************************** */
      do case
      case (tov_r=='ctov'.or.tov_r='tovm')
        if (FullName=1)
          @ 3, 1 say 'Группа(наим) ' get grpr pict '999' valid grpti()
          ngrpr=getfield('t1', 'grpr', 'grp', 'ng')
          @ 3, col() say ' '+ngrpr
          @ 4, 1 say 'Подгруппа    ' get kger pict '999999' valid kgeti()
          nger=getfield('t1', 'kger', 'GrpE', 'nge')
          @ 4, col() say ' '+nger
          @ 5, 1 say 'Наименование ' get MnNTovr pict '999999' valid MnNTov()
          ntovr=getfield('t1', 'MnNTovr', 'ntov', 'ntov')
          ntovr=subs(ntovr, 1, 23)
          @ 5, col() say ' '+ntovr
          nkachr=getfield('t1', 'kachr', 'kach', 'nkach')
          @ 6, 20 say nkachr
          @ 6, 1 say 'Кач.характер. ' get kachr pict '999' valid kach()
          nupakr=getfield('t1', 'vupakr', 'upak', 'nupak')
          @ 7, 20 say nupakr
          @ 7, 1 say 'Вид упаковки  ' get vupakr pict '999' valid vupak()
          @ 8, 1 say 'Уч.ед.измер.  ' get keir pict '999' valid keiti()
          @ 8, col()+6 say 'КСПОВО' get kspovor pict '9999' valid kspovo()
          @ 9, 1 say 'Ед.изм.фасовки'+' '+str(keipr, 3)+' '+neipr
        else
          if (OnGrpE4NotFullName())
            @ 3, 1 say 'Группа(наим) ' get grpr pict '999' valid grpti()
            ngrpr=getfield('t1', 'grpr', 'grp', 'ng')
            @ 3, col() say ' '+ngrpr
            @ 4, 1 say 'Подгруппа    ' get kger pict '999999' valid kgeti()
            nger=getfield('t1', 'kger', 'GrpE', 'nge')
            @ 4, col() say ' '+nger
          endif

          @ 8, 1 say 'Уч.ед.измер.  ' get keir pict '999' valid kei1()
          @ 8, col()+6 say 'КСПОВО' get kspovor pict '9999' valid kspovo()
          @ 9, 1 say 'Ед.изм.фасовки' get keipr pict '999' valid keip()
        endif

        @ 11, 1 say 'Кол-во ед.фас.' get vespr pict '999999.999'
        @ 12, 1 say 'Вес брутто ед.' get vesr pict '999999.999'+ ' кг'
        @ 14, 1 say 'Торг Марка    ' get mkeepr pict '999' valid tm()
        @ 14, 20 say getfield('t1', 'mkeepr', 'mkeep', 'nmkeep')
        if (FullName=1)
          @ 15, 1 say 'Изготовитель  ' get izgr pict '9999999' valid izg1()
        else
          @ 15, 1 say 'Изготовитель  ' get izgr pict '9999999' valid izg1()
        endif

        if (FullName=1)
          @ 16, 1 say 'Доп.информация' get tovdopr
        endif

        if (gnArnd=0)
          KoefGet(1)
          @ 2, 46 say 'К.загр.трансп' get kzar pict '9.99'
        else
          @ 16, 1 say 'Зав.N изг. ' get znr pict '@S30'
          @ 17, 1 say 'Инв.N пост.' get znomr pict '@S20'
          if (gnEnt=20)
            @ 19, 17 say narvidr
            @ 19, 1 say 'Вид оборуд.' get arvidr pict '999' valid arvid()
            @ 20, 1 say 'Примечание ' get ArPrimr
            @ 21, 1 say 'N п/п      ' get arNppr pict '9999'
            @ 22, 1 say 'Модель     ' get ArModr
          endif

          if (gnEnt=21)
            PosGet4Ent21()
          endif

        endif

        if (tov_r=='ctov'.or.tov_r=='tovm')
          @ 3, 46 say 'Прив.тара' get m1tr pict '9999999' valid mntvti()
          @ 4, 46 say 'УКТ ЗЕД  ' get uktr
          @ 5, 46 say 'Акц.кол-во' get KolAkcr pict '999999.999'
          @ 6, 46 say 'Min OSV' get minosvr pict '999999.999'
          @ 6, 65 say 'БлкВхЦ' get nooptr pict '9'
        else
          @ 3, 46 say 'Прив.тара'+' '+str(m1tr, 7)
        endif

        @ 7, 46 say 'Бонус       ' get bonr pict '9'
        @ 8, 46 say 'Для КПК     ' get merchr pict '9'
        @ 8, col()+1 say 'Только 169' get pr169r pict '9'
        @ 9, 46 say 'Стат.группа   ' get kodst1r pict'9999' valid kodstti()
        @ 10, 46 say 'Стат.вес      ' get vesst1r pict'99999.999999'
        @ 11, 46 say 'Наимен. чек  ' get namr
        if (keir#166)
          @ 12, 46 say 'Штрих-код     ' get barr pict'9999999999999' valid fbar()
        else
          @ 12, 46 say 'Код кассы авт.'+str(lcoder, 5)
        endif

        @ 13, 46 say 'Код кассы     ' get locr pict'99999' valid flocr()
        @ 14, 46 say 'Эн.ценн.      ' get kalr pict '999'
        @ 14, col()+1 say 'ккал'
        @ 15, 46 say 'На весы    ' get sendvr pict '9'
        @ 16, 46 say 'Родитель Т ' get mntovtr pict '9999999' valid mntovt()
        if (gnEnt=21.and.gnArnd=3)
          @ 17, 46 say 'Агент' get krstatr pict '9999'
        else
          @ 17, 46 say 'Родитель Ц ' get mntovcr pict '9999999' valid mntovc()
        endif

        @ 18, 46 say 'Акция      ' get akcr pict '9'
        @ 18, 60 say 'Блк.ск' get blkskr pict '9'
        @ 18, 69 say 'Блк.печ' get NoPrnr pict '9'
        Say19_46i21_46()
        @ 22, 46 say 'oДт-Кр_кДт-Кр'
        if (gnTpstpok=1)
          @ 22, 60 say (dkkln->(netseek('t1', 'tovm->Skl,631002'), str(631002, 6)))
        elseif (gnTpstpok=2)
          @ 22, 60 say (dkkln->(netseek('t1', 'tovm->Skl,361002'), str(361002, 6)))
        endif

      case (gnCtov=1.and.tov_r=='tov')
        @ 10, 1 say 'Кол-во в упак.' get upakr pict '999999.999'
        @ 10, col()+1 get upakpr pict '999999.999'
        @ 11, 1 say 'Кол-во ед.фас.' get vespr pict '999999.999'
        @ 12, 1 say 'Вес брутто ед.' get vesr pict '999999.999'+ ' кг'
        @ 13, 1 say 'Поставщик     '+' '+str(postr, 7)
        @ 13, 24 say getfield('t1', 'postr', 'kln', 'nkl')
        @ 14, 1 say 'Торг Марка    ' get mkeepr pict '999' valid tm()
        @ 14, 20 say getfield('t1', 'mkeepr', 'mkeep', 'nmkeep')
        if (FullName=1)
          @ 15, 1 say 'Изготовитель  ' get izgr pict '9999999' valid izg1()
        else
          @ 15, 1 say 'Изготовитель  ' get izgr pict '9999999' valid izg1()
        endif

        if (FullName=1)
          @ 16, 1 say 'Доп.информация' get tovdopr
        endif

        if (gnArnd=0)
          KoefSay()
        else
          @ 16, 1 say 'Зав.N изг. ' get znr pict '@S30'
          @ 17, 1 say 'Инв.N пост.' get znomr pict '@S20'
          if (gnEnt=21)
            PosGet4Ent21()
          endif

          if (gnEnt=20)
            @ 19, 17 say narvidr
            @ 19, 1 say 'Вид оборуд.' get arvidr pict '999' valid arvid()
            @ 20, 1 say 'Примечание ' get ArPrimr
            @ 21, 1 say 'N п/п      ' get arNppr pict '9999'
            @ 22, 1 say 'Модель     ' get ArModr
          endif

        endif

        if (otvr=1)
          @ 2, 46 say 'Min OSVO ' get minosvor pict '999999.999'
        endif

        @ 3, 46 say 'Прив.тара' get k1tr pict '999999999' valid mntvti()
        @ 4, 46 say 'Сертификат  '+' '+str(ksertr, 6)
        @ 5, 46 say 'Кач.удостов.'+' '+str(kukachr, 6)
        @ 6, 46 say 'Дата изгот. ' get dizgr
        @ 7, 46 say 'Дата реализ.'+' '+dtoc(drlzr)
        if (int(mntovr/10000)<2)
          @ 8, 46 say 'Отдел       ' get otr pict '99' valid otti()
        else
          @ 8, 46 say 'Отдел       '+str(otr, 2)
        endif

        @ 8, col()+3 say notr
        @ 9, 46 say 'Бонус       ' get bonr pict '9'
        @ 10, 46 say 'БЛК КПК     ' get blkkpkr pict '9'
        @ 17, 46 say 'Цена без бут   '+str(cenbbr, 10, 3)
        @ 18, 46 say 'Цена бутылки   '+str(cenbtr, 10, 3)
        Say19_46i21_46()
      // @ 22, 46 say 'oДт-Кр_кДт-Кр3' + str(cskl->TPstPok)
      case (gnCtov#1.and.(tov_r=='tov'.or.tov_r=='tovd'.or.tov_r=='ctovk'))
        @ 8, 1 say 'Уч.ед.измер.  ' get keir pict '999' valid kei1()
        @ 9, 1 say 'Ед.изм.фасовки' get keipr pict '999' valid keip()
        @ 10, 1 say 'Кол-во в упак.' get upakr pict '999999.999'
        @ 10, col()+1 get upakpr pict '999999.999'
        @ 11, 1 say 'Кол-во ед.фас.' get vespr pict '999999.999'
        @ 12, 1 say 'Вес брутто ед.' get vesr pict '999999.999'+ ' кг'
        @ 13, 1 say 'Поставщик     '+ str(postr, 7)
        if (gnCtov=1)
          @ 14, 1 say 'Торг Марка    ' get mkeepr pict '999' valid tm()
          @ 14, 20 say getfield('t1', 'mkeepr', 'mkeep', 'nmkeep')
        endif

        @ 15, 1 say 'Изготовитель  ' get izgr pict '9999999' valid izg1()
        @ 15, 24 say getfield('t1', 'postr', 'kln', 'nkl')
        if (gnArnd=0)
          KoefGet()
        else
          if (tov_r=='tovm')
            if (gnEnt=20)
              @ 19, 17 say narvidr
              @ 19, 1 say 'Вид оборуд.' get arvidr pict '999' valid arvid()
              @ 20, 1 say 'Примечание ' get ArPrimr
              @ 21, 1 say 'N п/п      ' get arNppr pict '9999'
              @ 22, 1 say 'Модель     ' get ArModr
            endif

          endif

          if (tov_r=='tov')
            @ 16, 1 say 'Зав.N изг. ' get znr pict '@S30'
            @ 17, 1 say 'Инв.N пост.' get znomr pict '@S20'
            if (gnEnt=21)
              PosGet4Ent21()
            endif

          endif

        endif

        @ 2, 46 say 'К.загр.трансп' get kzar pict '9.99'
        @ 3, 46 say 'Прив.тара' get k1tr pict '999999999' valid mntvti()
        @ 4, 46 say 'Сертификат  '+' '+str(ksertr, 6)
        @ 5, 46 say 'Кач.удостов.'+' '+str(kukachr, 6)
        @ 6, 46 say 'Дата изгот. ' get dizgr
        @ 7, 46 say 'Дата реализ.'+' '+dtoc(drlzr)
        @ 8, 46 say 'Отдел       '+' '+str(otr, 2)

        @ 8, col()+3 say notr
        @ 9, 46 say 'Стат.группа   ' get kodst1r pict'9999' valid kodstti()
        @ 10, 46 say 'Стат.вес      ' get vesst1r pict'99999.999999'
        if (keir#166)
          @ 12, 46 say 'Штрих-код     ' get barr pict'9999999999999' valid fbar()
        else
          @ 12, 46 say 'Код кассы авт.'+str(lcoder, 5)
        endif

        @ 13, 46 say 'Код кассы     ' get locr pict'99999' valid flocr()
        @ 14, 46 say 'Эн.ценн.      ' get kalr pict '999'
        @ 14, col()+1 say 'ккал'
        @ 15, 46 say 'На весы    ' get sendvr pict '9'
        Say19_46i21_46()
      //@ 22, 46 say 'oДт-Кр_кДт-Кр4' + str(cskl->TPstPok)
      endcase

    endif

    mmenr=0

    if (cor_r#2)
      if (!(cor_r=0.and.((gnCtov=2.or.gnCtov=3).and.tov_r=='tov')))
        read
      endif

      if (lastkey()=K_ESC)
        exit
      endif

    endif

    if (FullName=1)
      nat_r=alltrim(ntovr)+' '+iif(keir#keipr, iif(vespr#0, iif(keipr=800, str(vespr, 6, 3), kzero(vespr, 10, 3)), '')+iif(!empty(neipr), alltrim(neipr), '')+' ', '')+iif(!empty(nkachr), ' '+alltrim(nkachr), '')+iif(!empty(tovdopr), ' '+alltrim(tovdopr), '')+iif(!empty(nupakr), ' '+alltrim(nupakr), '')+' '+alltrim(nizg_r)
      /*         if keir#keipr
       *            nat_r=alltrim(ntovr)+iif(vespr#0,' '+kzero(vespr,10,3),'')+iif(!empty(neipr),alltrim(neipr),'')+iif(!empty(nkachr),' '+alltrim(nkachr),'')+iif(!empty(tovdopr),' '+alltrim(tovdopr),'')+iif(!empty(nupakr),' '+alltrim(nupakr),'')+' '+alltrim(nizg_r)  //+iif(upakr#0,' 1/'+kzero(upakr,10,3),'')
       *         else
       *            nat_r=alltrim(ntovr)+iif(!empty(nkachr),' '+alltrim(nkachr),'')+iif(!empty(tovdopr),' '+alltrim(tovdopr),'')+iif(!empty(nupakr),' '+alltrim(nupakr),'')+' '+alltrim(nizg_r)  //+iif(upakr#0,' 1/'+kzero(upakr,10,3),'')
       *         endif
       */
      @ 22, 1 say nat_r
      @ 23, 1 say '├'+repl('─', 38)+'┼'+repl('─', 18)+'┤'
    else
      @ 0, 11 say natr
    endif

    sele (tov_r)
    if (lastkey()=0)
      loop
    endif

    /***************************************************************************** */
    @ 22, 60 prom 'Верно'
    @ 22, col()+1 prom 'Не верно'
    menu to vn2
    /***************************************************************************** */
    if (lastkey()=K_ESC)
      exit
    endif

    if (cor_r=2.and.p4=nil)
      vn2=0
    endif

    if (vesst1r=0.and.gnEntrm=0.and.gnArnd=0.and.tov_r#'tov')
      wmess('Нет стат веса', 2)
    endif

    if (cor_r=0.and.((gnCtov=2.or.gnCtov=3).and.tov_r=='tov').and.p4=nil)
      vn2=1
    endif

  endif

  if (p4#nil)
    vn2=1
  endif

  if (gnSkotv#0.and.gnSkotv#0.and.!(tov_r=='ctov'))
    if (upakpr=0)
      vn2=2
      wmess('Нет кол-ва в упаковке поставщика', 2)
    endif

  endif

  if (gnRoz=1)
    vn2=1
  endif

  if (vn2=1)              // Верно
    if (FullName=1)
      if (p4=nil)
        natr=nat_r
        @ 0, 11 say natr
      else
        nat_r=natr
      endif

    endif

    if (cor_r=0)          // Добавить
      sele (tov_r)
      do case
      case (gnCtov=0)
      /* ADD в TOV NEW */
      case (gnCtov=1)
        /*  COPY в TOV из CTOV c ctov.mntov=mntov_r
         *  COPY в TOVM из CTOV c ctov.mntov=mntov_r
         */
        if (tov_r=='tov'.or.tov_r=='tovm').and.mntov_r#nil
        endif

        /*  COPY в TOVM из CTOV c ctov.mntov=mntov_r */
        if (tov_r=='tovm'.and.mntov_r#nil)
        endif

        /* ADD в CTOV NEW */
        if (tov_r=='ctov'.and.mntov_r=nil)
        endif

        /* COPY в CTOV из CTOVP c ctovp.mntov=mntov_r */
        if (tov_r=='ctov'.and.mntov_r#nil)
        endif

      case (gnCtov=2)
        /* MOVE в TOV из TOVD с tovd.ktl=mntov_r */
        if (tov_r=='tov')
        endif

        /* ADD в TOVD NEW */
        if (tov_r=='tovd')
        endif

      case (gnCtov=3)
        /* COPY в TOV из СTOVK с ctovk.ktl=mntov_r */
        if (tov_r=='tov')
        endif

        /* ADD в CTOVK NEW */
        if (tov_r=='ctovk')
        endif

      endcase

      do case
      case (tov_r=='tov').and.(mntov_r=nil.or.(mntov_r#nil.and.gnCtov=1))
        if (gnCtov=1)
          sele cgrp
          if (!netseek('t1', 'kg_r'))
            sele sgrp
            if (netseek('t1', 'kg_r'))
              ngr_r=ngr
              sele cgrp
              netadd()
              netrepl('kgr,ngr', 'kg_r,ngr_r')
              reclock()
            else
              wmess('Нет группы'+str(kg_r, 3)+' в SGRP', 3)
              quit
            endif

            cmaxktlr=kg_r*10000+1
          else
            cmaxktlr=ktl
          endif

          sele sgrp
          netseek('t1', 'kg_r')
          reclock()
          smaxktlr=ktl
          if (smaxktlr>cmaxktlr)
            sele cgrp
            netrepl('ktl', 'smaxktlr', 1)
          endif

          if (smaxktlr<cmaxktlr)
            sele sgrp
            netrepl('ktl', 'cmaxktlr', 1)
          endif

        else
          sele sgrp
          netseek('t1', 'kg_r')
          reclock()
        endif

        if (tov_r=='tov')
          ktlr=ktl
          if (int(ktlr/1000000)#kg_r)
            wmess('Переполнение кода гуппы '+str(kg_r, 3), 3)
            quit
          endif

        endif

        sele (tov_r)
        if (netseek('t1', 'sklr,ktlr'))
          wmess('Ошибка добавления нового кода '+tov_r, 3)
          quit
        endif

        sele sgrp
        netrepl('ktl', 'ktl+1')
        if (gnCtov=1)
          sele cgrp
          netrepl('ktl', 'ktl+1')
        endif

      case (tov_r=='tov'.and.mntov_r#nil.and.gnCtov#1)
        ktlr=mntov_r
        sele (tov_r)
        if (netseek('t1', 'sklr,ktlr'))
          wmess('Ошибка добавления нового кода '+tov_r, 3)
          quit
        endif

      case (tov_r=='tovd')
        sele sgrp
        netseek('t1', 'kg_r')
        reclock()
        ktlr=ktl
        if (int(ktlr/1000000)#kg_r)
          wmess('Переполнение кода гуппы '+str(kg_r, 3), 3)
          quit
        endif

        sele (tov_r)
        if (netseek('t1', 'ktlr'))
          wmess('Ошибка добавления нового кода '+tov_r, 3)
          quit
        endif

        sele sgrp
        netrepl('ktl', 'ktl+1')
      case (tov_r=='ctovk')
        sele cgrpk
        netseek('t1', 'kg_r')
        reclock()
        ktlr=ktl
        if (int(ktlr/1000000)#kg_r)
          wmess('Переполнение кода гуппы '+str(kg_r, 3), 3)
          quit
        endif

        sele (tov_r)
        if (netseek('t1', 'ktlr'))
          wmess('Ошибка добавления нового кода '+tov_r, 3)
          quit
        endif

        sele cgrpk
        netrepl('ktl', 'ktl+1')
      case (tov_r=='ctov')
        nat_rr=upper(natr)
        if (netseek('t2', 'kg_r,nat_rr'))
          wmess('Такая запись существует', 3)
          mntovr=mntov
          sele (tov_r)
          loop
        else
          sele cgrp
          netseek('t1', 'kg_r')
          reclock()
          mntovr=mntov
          if (int(mntovr/10000)#kg_r)
            wmess('Переполнение кода гуппы '+str(kg_r, 3), 3)
            quit
          endif

          sele (tov_r)
          if (netseek('t1', 'mntovr'))
            wmess('Ошибка добавления нового кода '+tov_r, 3)
            quit
          endif

          sele cgrp
          netrepl('mntov', 'mntovr+1')
        endif

      endcase

      if (m1tr=0.and.gnCtov=1)
        k1tr=0
      endif

      if (mntovtr=0)
        mntovtr=mntovr
      endif

      sele (tov_r)
      do case
      case (tov_r=='tov')
        if (!netseek('t1', 'sklr,ktlr'))
          netadd()
          for i=1 to fcount()
            tt=fieldname(i)
            if (tt='DOP')
              tt1='tov'+tt+'r'
              loop
            endif

            tt1=tt+'r'
            repl &tt with &tt1
          next

          netrepl('skl,ktl', 'sklr,ktlr')
          if (gnEnt=21.and.gnArnd=2.and.gnSk#243)
            ckobol_r=alltrim(getfield('t1', 'gnSk', 'cskl', 'kobol'))
            kobolr=ckobol_r+'18005_'+alltrim(str(tov->ktl, 9))
            netrepl('kobol', 'kobolr')
          endif

          prinstr=1
        endif

      case (tov_r=='tovd'.or.tov_r=='ctovk')
        if (!netseek('t1', 'ktlr'))
          netadd()
          netrepl('ktl', 'ktlr')
          prinstr=1
        endif

      case (tov_r=='ctov')
        if (!netseek('t1', 'mntovr'))
          netadd()
          netrepl('mntov', 'mntovr')
          prinstr=1
        endif

      endcase

      rcn_rr=recn()
      if (lcoder=0.and.kgr>2)
        sele cskl
        if (netseek('t1', 'gnSk'))
          lcoder=lcode
          netrepl('lcode', 'lcode+1')
        endif

      endif

      sele (tov_r)
      for i=1 to fcount()
        tt=fieldname(i)
        if (tt='DOP')
          tt1='tov'+tt+'r'
          loop
        endif

        tt1=tt+'r'
      next

      sele (tov_r)
      do case
      case (tov_r=='tov')
        if (otv=0)
          netrepl('skl,ktl,opt', 'sklr,ktlr,optr')
        else
          netrepl('skl,ktl', 'sklr,ktlr')
        endif

        if (mntov_r#nil)
          netrepl('mntov', 'mntovr')
        endif

      case (tov_r=='tovd')
        netrepl('ktl,skl', 'ktlr,sklr')
      case (tov_r=='ctovk')
        netrepl('ktl,skl', 'ktlr,0')
      case (tov_r=='ctov')
      endcase

      if (gnCtov=2.and.tov_r=='tov')
        sele tovd
        if (netseek('t1', 'ktlr'))
          netdel()
        endif

        sele (tov_r)
      endif

      if (gnCtov=3.and.tov_r=='tov')
        sele ctovk
        if (netseek('t1', 'ktlr'))
          netrepl('cnt', 'cnt+1')
        endif

        sele (tov_r)
      endif

    endif

    if (cor_r=1.or.cor_r=2)// Коррекция,просмотр
      sele (tov_r)
      do case
      case (tov_r=='tov')
        netseek('t1', 'sklr,ktlr')
      case (tov_r=='tovm')
        netseek('t1', 'sklr,mntovr')
      case (tov_r=='tovd')
        netseek('t1', 'ktlr')
      case (tov_r=='ctov')
        netseek('t1', 'mntovr')
        mnctovpr=0
      endcase

      reclock()
    endif

    sele (tov_r)
    outlog(3,__FILE__,__LINE__,"tov_r",tov_r)
    if (gnEntrm=0)
      if (FullName=1)
        netrepl('grp,kge,MnNTov,kach,vupak,vupakp,nat', {grpr,kger,MnNTovr,kachr,vupakr,vupakpr,nat_r}, 1)
      else
        netrepl('nat', 'natr', 1)
        if (OnGrpE4NotFullName())
          netrepl('grp,kge', {grpr,kger}, 1)
        EndIf
      endif

      netrepl('nat', 'natr', 1)
      netrepl('mntovc,mntovt', 'mntovcr,mntovtr', 1)
      netrepl('kg,kei,keip,nei,neip,kodst1,vesst1', 'kgr,keir,keipr,neir,neipr,kodst1r,vesst1r', 1)
      if (!(tov_r=='ctov'))
        netrepl('upak,upakp', 'upakr,upakpr', 1)
      endif

      netrepl('ves,vesp', 'vesr,vespr', 1)
      netrepl('izg,ksert,kukach,mkeep', 'izgr,ksertr,kukachr,mkeepr', 1)
      if (tov_r=='tov')
        netrepl('post,bon,blkkpk', 'postr,bonr,blkkpkr', 1)
        if (otvr=1)
          netrepl('minosvo', 'minosvor', 1)
        endif

      endif

      netrepl('akc,blksk,NoPrn,merch,pr169,kspovo,dop',             ;
               'akcr,blkskr,NoPrnr,merchr,pr169r,kspovor,tovdopr', 1 ;
            )
      netrepl('keur,keur1,keur2,keur3,keur4,keuh',         ;
               'keurr,keur1r,keur2r,keur3r,keur4r,keuhr', 1 ;
            )
      netrepl('zn,znom', 'znr,znomr', 1)
      netrepl('arvid,ArPrim,arNpp,ArMod', 'arvidr,ArPrimr,arNppr,ArModr', 1)
      netrepl('posid,posbrn,kza,posTehco,comment', 'posidr,posbrnr,kzar,posTehcor,commentr', 1)
      if (tov_r=='tov'.or.tov_r=='tovm')
        netrepl('drlz,sert,dizg,ot', 'drlzr,sertr,dizgr,otr', 1)
        if (gnEnt=21.and.gnArnd=3)
          netrepl('krstat', 'krstatr', 1)
        endif

      endif

    endif

    netrepl('m1t,k1t', 'm1tr,k1tr', 1)
    if (gnEntRm=0)
      netrepl('ukt', 'uktr', 1)
      netrepl('KolAkc', 'KolAkcr', 1)
      netrepl('minosv', 'minosvr', 1)
      netrepl('noopt', 'nooptr', 1)
      if (lcoder=0.and.kgr>2)
        sele cskl
        if (netseek('t1', 'gnSk'))
          if (lcode=0)
            netrepl('lcode', '1')
          endif

          lcoder=lcode
          netrepl('lcode', 'lcode+1')
        endif

      endif

      sele (tov_r)
      netrepl('nam,bar,lcode,kal,sendv,loc', 'namr,barr,lcode,kal,sendv,locr', 1)
    endif

    netunlock()
    mnctovpr=0
    if (gnCtov=1)
      if (tov_r=='tov'.or.tov_r=='tovm')
        /********************************************
         * Коррекция CTOV
         ********************************************
         */
        sele ctov
        if (netseek('t1', 'mntovr'))
          reclock()
          if (gnEntRm=0)
            if (FullName=1)
              netrepl('nat,kg,grp,kge,MnNTov,kach,vupak,vupakp', 'natr,kg_r,grpr,kger,MnNTovr,kachr,vupakr,vupakpr', 1)
            else
              netrepl('nat,kg,vupak,vupakp', 'natr,kg_r,vupakr,vupakpr', 1)
            endif

            netrepl('kei,keip,nei,neip,kodst1,vesst1', 'keir,keipr,neir,neipr,kodst1r,vesst1r', 1)
            netrepl('ves,vesp,m1t,otv', 'vesr,vespr,m1tr,0', 1)
            netrepl('izg,ksert,kukach,upak,upakp,dizg,drlz,mkeep', 'izgr,ksertr,kukachr,upakr,upakpr,dizgr,drlzr,mkeepr', 1)
            netrepl('dop', 'tovdopr', 1)
            netrepl('keur,keur1,keur2,keur3,keur4,keuh',         ;
                     'keurr,keur1r,keur2r,keur3r,keur4r,keuhr', 1 ;
                  )
            netrepl('zn,znom', 'znr,znomr', 1)
            netrepl('arvid,ArPrim,arNpp,ArMod', 'arvidr,ArPrimr,arNppr,ArModr', 1)
            netrepl('posid,posbrn,posTehco,comment', 'posidr,posbrnr,posTehcor,commentr', 1)
            netrepl('ukt', 'uktr', 1)
            netrepl('KolAkc', 'KolAkcr', 1)
            netrepl('minosv', 'minosvr', 1)
            netrepl('noopt', 'nooptr', 1)
            netrepl('kza', 'kzar', 1)
            netrepl('nam,bar,lcode,loc', 'namr,barr,lcoder,locr', 1)
            netrepl('merch,akc,blksk', 'merchr,akcr,blkskr', 1)
            netrepl('NoPrn', 'NoPrnr', 1)
            netrepl('pr169', 'pr169r', 1)
            netrepl('kspovo', 'kspovor', 1)
            netrepl('mntovc,mntovt', 'mntovcr,mntovtr', 1)
          endif

          netrepl('m1t,k1t', 'm1tr,k1tr', 1)
          netunlock()
        /********************************************
         * Конец коррекции CTOV
         ********************************************
         */
        endif

      endif

      if (tov_r=='tov'.or.tov_r=='ctov')
        /********************************************
         * Коррекция TOVM
         ********************************************
         */
        if (tov_r=='ctov'.and.gnMskl=0)
          sklr=gnSkl
        endif

        sele tovm
        if (!netseek('t1', 'sklr,mntovr'))
          netadd()
          sele ctov
          if (netseek('t1', 'mntovr'))
            arec:={}
            getrec()
            sele tovm
            putrec()
            netrepl('skl,osn,osv,osf,osfm,osvo,ktlm', 'sklr,0,0,0,0,0,0')
          else
            sele tovm
            netrepl('skl,mntov', 'sklr,mntovr')
          endif

        endif

        reclock()
        if (gnEntRm=0)
          if (FullName=1)
            netrepl('nat,kg,grp,kge,MnNTov,kach,vupak,vupakp', 'natr,kg_r,grpr,kger,MnNTovr,kachr,vupakr,vupakpr', 1)
          else
            netrepl('nat,kg,vupak,vupakp', 'natr,kg_r,vupakr,vupakpr', 1)
          endif

          netrepl('mntovc,mntovt', 'mntovcr,mntovtr', 1)
          netrepl('kei,keip,nei,neip,kodst1,vesst1', 'keir,keipr,neir,neipr,kodst1r,vesst1r', 1)
          netrepl('ves,vesp,m1t,otv', 'vesr,vespr,m1tr,0', 1)
          netrepl('izg,ksert,kukach,upak,upakp,dizg,drlz,mkeep', 'izgr,ksertr,kukachr,upakr,upakpr,dizgr,drlzr,mkeepr', 1)
          netrepl('dop', 'tovdopr', 1)
          netrepl('keur,keur1,keur2,keur3,keur4,keuh',         ;
                   'keurr,keur1r,keur2r,keur3r,keur4r,keuhr', 1 ;
                )
          netrepl('zn,znom', 'znr,znomr', 1)
          netrepl('posid,posbrn', 'posidr,posbrnr', 1)
          netrepl('arvid,ArPrim,arNpp,ArMod', 'arvidr,ArPrimr,arNppr,ArModr', 1)
          netrepl('ukt', 'uktr', 1)
          netrepl('KolAkc', 'KolAkcr', 1)
          netrepl('minosv', 'minosvr', 1)
          netrepl('noopt', 'nooptr', 1)
          netrepl('kza', 'kzar', 1)
          netrepl('nam,bar,lcode,loc', 'namr,barr,lcoder,locr', 1)
          netrepl('merch,akc,blksk', 'merchr,akcr,blkskr', 1)
          netrepl('NoPrn', 'NoPrnr', 1)
          netrepl('pr169', 'pr169r', 1)
          netrepl('kspovo', 'kspovor', 1)
        endif

        netrepl('m1t,k1t', 'm1tr,k1tr', 1)
        netunlock()
      /********************************************
       * Конец коррекции TOVM
       ********************************************
       */
      endif

      if (tov_r=='tovm'.or.tov_r=='ctov')
        /********************************************
         * Коррекция TOV
         ********************************************
         */
        sele tov
        tovordr=indexord()
        set orde to tag t5
        if (netseek('t5', 'sklr,mntovr'))
          while (skl=sklr.and.mntov=mntovr)
            reclock()
            if (gnEntRm=0)
              if (FullName=1)
                netrepl('nat,kg,grp,kge,MnNTov,kach,vupak,vupakp', 'natr,kg_r,grpr,kger,MnNTovr,kachr,vupakr,vupakpr', 1)
              else
                netrepl('nat,kg,vupak,vupakp', 'natr,kg_r,vupakr,vupakpr', 1)
              endif

              netrepl('kei,keip,nei,neip,kodst1,vesst1', 'keir,keipr,neir,neipr,kodst1r,vesst1r', 1)
              netrepl('ves,vesp', 'vesr,vespr', 1)
              netrepl('izg,mkeep,upak,upakp', 'izgr,mkeepr,upakr,upakpr', 1)
              netrepl('dop', 'tovdopr', 1)
              netrepl('kza', 'kzar', 1)
              netrepl('bon', 'bonr', 1)
              netrepl('merch,akc,blksk', 'merchr,akcr,blkskr', 1)
              netrepl('NoPrn', 'NoPrnr', 1)
              netrepl('nam,bar,lcode,loc', 'namr,barr,lcoder,locr')
              if (gnEnt=21.and.gnArnd=3)
                netrepl('krstat', 'krstatr')
              endif

              netrepl('mntovc,mntovt', 'mntovcr,mntovtr', 1)
              netrepl('ukt', 'uktr', 1)
              netrepl('KolAkc', 'KolAkcr', 1)
              netrepl('minosv', 'minosvr', 1)
              netrepl('noopt', 'nooptr', 1)
              netrepl('pr169', 'pr169r', 1)
              netrepl('kspovo', 'kspovor', 1)
              netrepl('arvid,ArPrim,arNpp,ArMod', 'arvidr,ArPrimr,arNppr,ArModr', 1)
            endif

            netrepl('m1t', 'm1tr', 1)
            sele tov
            skip
          enddo

        endif

        sele tov
        set orde to tovordr
      /********************************************
       * Конец коррекции TOV
       ********************************************
       */
      endif

    endif

    if (cor_r=0)
      cor_r=1               // После создания новой карточки она переходит в режим коррекции
      if (gnCtov=2.or.gnCtov=3).and.tov_r=='tov'
        exit
      endif

    endif

  endif

  if (p4#nil)
    exit
  endif

enddo

sele (tov_r)
unlock
set key -1 to
set key -2 to
set key -3 to
set key -4 to
set key K_SPACE to
if (p4=nil)
  setcolor(oclr)
  rest scre from sctins
endif

/**********************
 *  ФУНКЦИИ
 **********************
 */

static function kei1()
  sele nei
  if (!netseek('t1', 'keir').or.keir=0)
    go top
    keir=slcf('nei',,,,, "e:nei h:'Изм' c:c(5)", 'kei')
  endif

  neir=getfield('t1', 'keir', 'nei', 'nei')
  @ 8, 20 say neir
  return (.t.)

/***********************************************************
 * keip() -->
 *   Параметры :
 *   Возвращает:
 */
static function keip()
  sele nei
  if (!netseek('t1', 'keipr').or.keipr=0)
    go top
    keipr=slcf('nei',,,,, "e:nei h:'Изм' c:c(5)", 'kei')
  endif

  neipr=getfield('t1', 'keipr', 'nei', 'nei')
  /*wselect(wkeir) */
  @ 9, 20 say neipr
  return (.t.)

/***********************************************************
 * vupak() -->
 *   Параметры :
 *   Возвращает:
 */
static function vupak()
  asvkr=savesetkey()
  set key -1 to
  set key -2 to
  set key -3 to
  set key -4 to
  sele ntovup
  vupak_r=vupakr
  if (!netseek('t1', 'MnNTovr,vupakr').or.vupakr=0)
    netseek('t1', 'MnNTovr')
    while (.t.)
      foot('ENTER,INS,F4', 'Выбрать,Добавить,Коррекция')
      vupakr=slcf('ntovup',,,,, "e:upak h:'Код' c:n(3) e:getfield('t1','ntovup->upak','upak','nupak') h:'В.уп.' c:c(5)", 'upak',,, 'MnNTov=MnNTovr')
      do case
      case (lastkey()=K_ENTER)// Выбрать
        exit
      case (lastkey()=K_INS)  // Добавить
        ntovupins()
      case (lastkey()=K_F4)   // Коррекция
        ntovupins(1)
      case (lastkey()=K_ESC)  // Отмена
        vupakr=vupak_r
        exit
      endcase

    enddo

  endif

  restsetkey(asvkr)
  nupakr=getfield('t1', 'vupakr', 'upak', 'nupak')
  @ 7, 20 say nupakr
  return (.t.)

/***********************************************************
 * ntovupins
 *   Параметры:
 */
static procedure ntovupins(p1)
  local getlist:={}
  oclr=setcolor('gr+/b,n/w')
  wupak=wopen(10, 20, 14, 60)
  wbox(1)
  if (p1=nil)
    upakr=0
    upakpr=0
  endif

  while (.t.)
    @ 0, 1 say 'Упаковка1' get upakr pict '999' valid sntovup(1)
    @ 1, 1 say 'Упаковка2' get upakpr pict '999' valid sntovup(2)
    read
    if (lastkey()=K_ESC)
      exit
    endif

    @ 2, 20 prom 'Верно'
    @ 2, col()+1 prom 'Не верно'
    menu to vn
    if (vn=1)
      sele ntovup
      if (netseek('t1', 'MnNTovr,upakr'))
        wselect(0)
        save scre to scmess
        mess('Такая упаковка уже есть', 3)
        rest scre from scmess
        wselect(wupak)
        loop
      endif

      netadd()
      netrepl('MnNTov,upak', 'MnNTovr,upakr')
      exit
    endif

  enddo

  wclose(wupak)
  setcolor(oclr)
  return

/***********************************************************
 * kach() -->
 *   Параметры :
 *   Возвращает:
 */
static function kach()
  asvkr=savesetkey()
  set key -1 to
  set key -2 to
  set key -3 to
  set key -4 to
  sele ntovka
  kach_r=kachr
  if (!netseek('t1', 'MnNTovr,kachr').or.kachr=0)
    if (!netseek('t1', 'MnNTovr,0'))
      netadd()
      netrepl('MnNTov,kach', 'MnNTovr,0')
    endif

    rcntovkar=recn()
    while (.t.)
      sele ntovka
      go rcntovkar
      foot('ENTER,INS,F4', 'Выбрать,Добавить,Коррекция')
      rcntovkar=slcf('ntovka',,,,, "e:kach h:'Код' c:n(3) e:getfield('t1','ntovka->kach','kach','nkach') h:'Кач.хар-ка' c:c(10)",,,, 'MnNTov=MnNTovr')
      if (lastkey()=K_ESC)// Отмена
        kachr=kach_r
        exit
      endif

      go rcntovkar
      kachr=kach
      do case
      case (lastkey()=K_ENTER)// Выбрать
        exit
      case (lastkey()=K_INS)  // Добавить
        sntovka()
        sele ntovka
        if (!netseek('t1', 'MnNTovr,kachr'))
          netadd()
          netrepl('MnNTov,kach', 'MnNTovr,kachr')
          rcntovkar=recn()
        else
          wmess('Такой код уже есть', 1)
        endif

      /*              ntovkains() */
      case (lastkey()=K_F4)// Коррекция
      /*              ntovkains(1) */
      endcase

    enddo

  endif

  restsetkey(asvkr)
  nkachr=getfield('t1', 'kachr', 'kach', 'nkach')
  @ 6, 20 say nkachr
  return (.t.)

/***********************************************************
 * ntovkains
 *   Параметры:
 */
static procedure ntovkains(p1)
  local getlist:={}
  oclr=setcolor('gr+/b,n/w')
  wkach=wopen(10, 20, 14, 60)
  wbox(1)
  if (p1=nil)
    kachr=0
  endif

  while (.t.)
    @ 0, 1 say 'Кач.харак-ка' get kachr pict '999' valid sntovka()
    read
    if (lastkey()=K_ESC)
      exit
    endif

    @ 2, 20 prom 'Верно'
    @ 2, col()+1 prom 'Не верно'
    menu to vn
    if (vn=1)
      sele ntovka
      if (netseek('t1', 'MnNTovr,kachr'))
        wselect(0)
        save scre to scmess
        mess('Такие характеристика уже есть', 3)
        rest scre from scmess
        wselect(wkach)
        loop
      endif

      netadd()
      netrepl('MnNTov,kach', 'MnNTovr,kachr')
      exit
    endif

  enddo

  wclose(wkach)
  setcolor(oclr)
  return

/***********************************************************
 * drlzw() -->
 *   Параметры :
 *   Возвращает:
 */
static function drlzw()
  skdrlzr=savesetkey()
  set key 7 to drlz()
  return (.t.)

/***********************************************************
 * drlzv() -->
 *   Параметры :
 *   Возвращает:
 */
static function drlzv()
  set key 7 to
  restsetkey(skdrlzr)
  return (.t.)

/***********************************************************
 * drlz() -->
 *   Параметры :
 *   Возвращает:
 */
static function drlz()
  drlzr=ctod('')
  return

  /*stat funct drlz1()
   *drlz()
   *read
   *retu
   */

static function wpost()
  set key K_SPACE to w_post()
  return (.t.)

/***********************************************************
 * w_post() -->
 *   Параметры :
 *   Возвращает:
 */
static function w_post()
  postr=kpsr
  return (.t.)

/*****************************************************************
 
 FUNCTION:
 АВТОР..ДАТА..........С. Литовка  05-01-18 * 12:39:43pm
 НАЗНАЧЕНИЕ.........
 ПАРАМЕТРЫ..........
 ВОЗВР. ЗНАЧЕНИЕ....
 ПРИМЕЧАНИЯ.........
 */
static function say19_46i21_46()
  @ 19, 46 say 'Приход         '+str(prmnr, 6)
  @ 20, 46 say 'Дата прихода   '+dtoc(dppr)
  @ 21, 46 say 'Дата посл отгр '+dtoc(dpor)
  return (nil)

/*****************************************************************
 
 FUNCTION:
 АВТОР..ДАТА..........С. Литовка  04-15-19 * 12:18:32pm
 НАЗНАЧЕНИЕ.........
 ПАРАМЕТРЫ..........
 ВОЗВР. ЗНАЧЕНИЕ....
 ПРИМЕЧАНИЯ.........
 */
STATIC FUNCTION KoefSay()
  @ 17, 1 say 'Коэф.ест.уб '+' '+str(keurr, 5, 2)
  @ 18, 1 say 'К. ест.уб В '+' '+str(keur1r, 5, 2)
  @ 19, 1 say 'К. ест.уб Л '+' '+str(keur2r, 5, 2)
  @ 20, 1 say 'К. ест.уб О '+' '+str(keur3r, 5, 2)
  @ 22, 1 say 'К. ест.уб З '+' '+str(keur4r, 5, 2)
  @ 22, 1 say 'К.ест.уб Хр '+' '+str(keuhr, 5, 2)
  RETURN (NIL)

/*****************************************************************
 
 FUNCTION:
 АВТОР..ДАТА..........С. Литовка  04-15-19 * 12:21:31pm
 НАЗНАЧЕНИЕ.........
 ПАРАМЕТРЫ..........
 ВОЗВР. ЗНАЧЕНИЕ....
 ПРИМЕЧАНИЯ.........
 */
STATIC FUNCTION KoefGet(nAddRow)
  DEFAULT nAddRow TO 0
  @ 16+nAddRow, 1 say 'Коэф.ест.уб ' get keurr pict '99.99'
  @ 17+nAddRow, 1 say 'К. ест.уб В ' get keur1r pict '99.99'
  @ 18+nAddRow, 1 say 'К. ест.уб Л ' get keur2r pict '99.99'
  @ 19+nAddRow, 1 say 'К. ест.уб О ' get keur3r pict '99.99'
  @ 20+nAddRow, 1 say 'К. ест.уб З ' get keur4r pict '99.99'
  @ 21+nAddRow, 1 say 'К.ест.уб Хр ' get keuhr pict '99.99'
  RETURN (NIL)


/*****************************************************************
 
 FUNCTION:
 АВТОР..ДАТА..........С. Литовка  04-15-19 * 12:37:18pm
 НАЗНАЧЕНИЕ.........
 ПАРАМЕТРЫ..........
 ВОЗВР. ЗНАЧЕНИЕ....
 ПРИМЕЧАНИЯ.........
 */
STATIC FUNCTION PosGet4Ent21(lWhen)
  DEFAULT lWhen TO .T.
  //@ 19, 1 say 'Код Оболонь'+' '+kobolr
  @ 18, 1 say 'Pos ID     ' get posidr pict '9999999999' valid pid() when lWhen
    @ row(), col()+1 say 'ID SWE     '+' '+posTPIdr
  @ 19, 1 say 'Pos BRAND  ' get posbrnr pict '9999999999' valid pbrn() when lWhen
  @ 20, 1 say 'Вид оборуд.' get arvidr pict '999' valid arvid() when lWhen
    @ row(), col()+1 say 'К-во узлов.' get arnppr pict '999' when lWhen
  @ 21, 1 say 'Модель' get ArModr pict '@S10' when lWhen
    @ row(), col()+1 say 'Статус: SWE' get posTehcor pict '999' when lWhen
    @ row(), col()+1 say 'ТО' get ArPrimr pict 'XXX' when lWhen

  @ 22, 1 say 'Код поломки' get commentr pict '@S20' when lWhen

  RETURN (NIL)

/*****************************************************************
 
 FUNCTION:
 АВТОР..ДАТА..........С. Литовка  04-15-19 * 12:44:05pm
 НАЗНАЧЕНИЕ.........
 ПАРАМЕТРЫ..........
 ВОЗВР. ЗНАЧЕНИЕ....
 ПРИМЕЧАНИЯ.........
 */
STATIC FUNCTION PosSay4Ent21(lWhen)
  lWhen :=.F.
  PosGet4Ent21(lWhen)
  RETURN (NIL)
