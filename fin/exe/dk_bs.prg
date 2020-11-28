/***********************************************************
 * Модуль    : dk_bs.prg
 * Версия    : 0.0
 * Автор     :
 * Дата      : 12/11/19
 * Изменен   :
 * Примечание: Текст обработан утилитой CF версии 2.02
 */

#include "inkey.ch"
netuse("dkkln")
netuse("kln")
netuse("bs")

clea

store 0 to bsr, kklr, dnr, knr, dbr, krr, dk_r, kk_r, mdkr, rcslr, nnn, ochr, bdr, psnr
store '' to nbsr, nklr, schr, psser, passpr
sumr=100

if (select('sl')=0)
  sele 0
  use _slct alias sl excl
endif

sele sl
zap

filedelete('bskl.*')
sele 0
crtt('bskl', 'f:bs c:n(6)')
use bskl excl
inde on str(bs, 6) tag t1

filedelete("dkout.*")
sele 0
crtt('dkout', "f:bs c:n(6) f:nbs c:c(20) f:kkl c:n(7) f:nkl c:c(30) f:dn c:n(12,2) f:kn c:n(12,2) f:db c:n(12,2) f:kr c:n(12,2) f:dk c:n(12,2) f:kk c:n(12,2) f:dkr c:d(10) f:ddb c:d(10)")
use dkout excl
inde on str(kkl, 7)+str(bs, 6) tag t1

sele dkkln
save scre to sckl
mess('Ждите,идет отбор счетов...')
while (!eof())
  bsr=bs
  kklr=kkl
  sele bskl
  netseek('t1', 'bsr')
  if (!FOUND())
    netadd()
    netrepl('bs', 'bsr')
  endif

  sele dkkln
  skip
enddo

rest scre from sckl
sele bskl
go top
while (.t.)
  sele bskl
  if (bsr=0)
    go top
  endif

  bsr=slcf('bskl',,,,, "e:bs h:'Счет' c:n(6) e:getfield('t1','bskl->bs','bs','nbs') h:'Наименование' c:c(20)", 'bs', 1)
  sele bskl
  netseek('t1', 'bsr')
  do case
  case (lastkey()=K_ESC)
    exit
  case (lastkey()=13)
    sele sl
    if (select('sl1')#0)
      sele sl1
      CLOSE
    endif

    copy to sl1
    sele 0
    use sl1
    if (select('lbs')#0)
      sele lbs
      CLOSE
    endif

    crtt('lbs', 'f:bs c:n(6)')
    sele 0
    use lbs
    sele sl
    go top
    rcslr=0
    while (!eof())
      bsr=val(kod)
      sele lbs
      appe blank
      repl bs with bsr
      rcslr++
      sele sl
      skip
    enddo

    /*           sele 0
     *           use lbs
     */
    sele lbs
    dkzapr()
    sele sl
    zap
    if (select('sl1')#0)
      sele sl1
      CLOSE
    endif

    sele sl
    appe from sl1
  endcase

  sele bskl
  LOCATE for bs=bsr
enddo

sele bskl
CLOSE
//erase bskl.dbf
//erase bskl.cdx

if (select('lbs')#0)
  sele lbs
  CLOSE
endif

erase lbs.dbf

if (select('sl1')#0)
  sele sl1
  CLOSE
endif

erase sl1.dbf

sele sl
zap
CLOSE

if (select('dkout')#0)
  sele dkout
  CLOSE
endif

//erase dkout.dbf
//erase dkout.cdx

nuse()
return

/***********************************************************
 * dkzapr
 *   Параметры:
 */
procedure dkzapr
  cldkzapr=setcolor('gr+/b,r/w')
  wdkzapr=wopen(10, 15, 18, 67)
  wbox(1)
  mdkr=1
  while (.t.)
    bsr=0
    @ 0, 1 say 'Отобранные счета : '
    col1_r=col()
    @ 0, col1_r clea to 1, maxcol()-1
    sele sl1
    go top
    sochr=''
    while (!eof())
      sochr=sochr+alltrim(kod)+','
      col1_r=col()
      skip
    enddo

    sochr=subs(sochr, 1, len(sochr)-1)
    @ 0, col1_r say sochr
    @ 1, 1 say '=>' color 'w+/b'
    @ 1, col()+1 say 'Клиенты :'
    @ 1, col()+1 prom 'Все'
    @ 1, col()+1 prom 'Дебеторы '
    @ 1, col()+1 prom 'Кредиторы'
    menu to mdkr
    @ 1, 1 say '  '
    if (lastkey()=K_ESC)
      exit
    endif

    @ 2, 1 say 'По счетам: '
    col_r=col()
    @ 2, col_r clea to 1, maxcol()-1
    if (!bsr())
      loop
    endif

    sele sl
    go top
    nnn=0
    schr=''
    while (!eof())
      schr=schr+alltrim(kod)+','
      col_r=col()
      nnn++
      skip
    enddo

    schr=subs(schr, 1, len(schr)-1)
    @ 2, col_r say schr
    if (nnn=0)
      exit
    endif

    @ 3, 1 say 'Показать конеч. сальдо большее ' get sumr pict '9999'
    @ 3, col()+6 say 'грн'
    @ 6, 1 say 'Без дат' get bdr pict '9'
    read
    ochr=0
    if (rcslr#nnn)
      ochr=1
      @ 4, 1 say 'Показывать состояние по остальным счетам?'
      @ 5, 1 say '=>' color 'w+/b'
      @ 5, col()+1 prom 'Да'
      @ 5, col()+1 prom 'Нет'
      menu to ochr
      @ 5, 1 say '  '
      if (lastkey()=K_ESC)
        loop
      endif

    endif

    /** */
    @ 5, 35 prom 'Полностью'
    @ 5, col()+1 prom 'Итоги'
    menu to pir
    if (lastkey()=K_ESC)
      exit
    endif

    /** */
    psr=1
    pssr=0
    while (.t.)
      @ 6, 27 say '=>' color 'w+/b'
      @ 6, 30 prom 'ЛПеч'
      @ 6, col()+1 prom 'Экран'
      @ 6, col()+1 prom 'ЛPCL'
      @ 6, col()+1 prom 'CПеч'
      menu to psr
      if (lastkey()=K_ESC)
        exit
      endif

      set cons off
      do case
      case (psr=1)
        if (gcPrn='PCL')
          if (gnOut=1)
            set prin to lpt1
            set prin on
            ?chr(27)+'E'+chr(27)+'&l1h26a0O'+chr(27)+chr(27)+'(3R'+chr(27)+'(s0p21.00h0s0b4099T'+chr(27)// Книжная А4
          else
            set prin to dk_bs.txt
          endif

        else
          if (gnOut=1)
            set prin to lpt1
            set prin on
            ?chr(27)+chr(77)+chr(15)
          else
            set prin to dk_bs.txt
          endif

        endif

      case (psr=2)
        set prin to dk_bs.txt
      case (psr=3)
        set prin to lpt1
        set prin on
        ?chr(27)+'E'+chr(27)+'&l1h26a0O'+chr(27)+chr(27)+'(3R'+chr(27)+'(s0p21.00h0s0b4099T'+chr(27)// Книжная А4
      case (psr=4)
        set prin to lpt2
        set prin on
        ?chr(27)+'E'+chr(27)+'&l1h26a0O'+chr(27)+chr(27)+'(3R'+chr(27)+'(s0p21.00h0s0b4099T'+chr(27)// Книжная А4
      endcase

      if (pir=1)
        prndk(psr, pssr)
      else
        prndki(psr, pssr)
      endif

      set cons on
      pssr=1
    enddo

    @ 6, 33 say '  '
  enddo

  wclose(wdkzapr)
  setcolor(cldkzapr)
  return

/***********************************************************
 * bsr() -->
 *   Параметры :
 *   Возвращает:
 */
function bsr()
  local GetList:={}
  wselect(0)
  while (.t.)
    sele lbs
    go top
    bsr=slcf('lbs',,,,, "e:bs h:'Счет' c:n(6) e:getfield('t1','lbs->bs','bs','nbs') h:'Наименование' c:c(20)", 'bs', 1)
    sele lbs
    LOCATE for bs=bsr
    if (lastkey()=13)
      exit
    endif

    if (lastkey()=K_ESC)
      wselect(wdkzapr)
      return (.f.)
    endif

  enddo

  wselect(wdkzapr)
  return (.t.)

/***********************************************************
 * prndk
 *   Параметры:
 */
procedure prndk
  para p1, p2
  /* p1 - 1-Печать;2-Экран
   * p2 - 0-Подготовка;1-Нет
   */
  if (p2=0)               // Подготовка
    wselect(0)
    save scre to scmess
    mess('Ждите,идет подготовка...')
    sele dkout
    zap
    sele dkkln
    go top
    while (!eof())
      /*      nnr=0 */
      kklr=kkl
      bsr=bs
      dnr=dn
      knr=kn
      dbr=db
      krr=kr
      dk_r=0
      kk_r=0
      ddbr=ddb
      dkrr=dkr
      sele sl1
      LOCATE for val(kod)=bsr
      if (!FOUND())
        sele dkkln
        skip
        loop
      endif

      sele dkout
      if (!netseek('t1', 'kklr,bsr'))
        salr=dnr-knr+dbr-krr
        if (salr>0)
          dk_r=salr
        endif

        if (salr<0)
          kk_r=abs(salr)
        endif

        appe blank
        repl kkl with kklr, bs with bsr, ;
         dn with dnr, kn with knr,       ;
         db with dbr, kr with krr,       ;
         dk with dk_r, kk with kk_r,     ;
         ddb with ddbr, dkr with dkrr
      else
        salr=dn-kn+dnr-knr
        store 0 to dnr, knr
        if (salr>0)
          dnr=salr
        endif

        if (salr<0)
          knr=abs(salr)
        endif

        dbr=db+dbr
        krr=kr+krr

        salr=dnr-knr+dbr-krr
        store 0 to dk_r, kk_r
        if (salr>0)
          dk_r=salr
        endif

        if (salr<0)
          kk_r=abs(salr)
        endif

        repl dn with dnr, ;
         kn with knr,     ;
         db with dbr,     ;
         kr with krr,     ;
         dk with dk_r,    ;
         kk with kk_r
        if (ddbr>ddb)
          repl ddb with ddbr
        endif

        if (dkrr>dkr)
          repl dkr with dkrr
        endif

      endif

      sele dkkln
      skip
    enddo

    rest scre from scmess
    mess('Печать...')
    store 0 to sdn, skn, sdb, skr, skk, sdk
    sele dkout
    dele all for dn=0.and.kn=0.and.db=0.and.kr=0
    go top
    /*   set prin to dk.txt */
    set prin on
    set cons off
    store 0 to kklr
    bsr=1
    colstr=0
    lstr=1
    colstr0()
    pkklr=0
    store 0 to kdnr, kknr, kdbr, kkrr, kdkr, kkkr
    while (!eof())
      if (kkl#kklr)
        if (abs(dk+kk)<sumr)
          kklr=kkl
          while (kkl=kklr)
            skip
          enddo

          loop
        endif

        do case
        case (mdkr=1)     // Все
        case (mdkr=2)     // Дебеторы
          if (kk>0)
            kklr=kkl
            while (kkl=kklr)
              skip
            enddo

            loop
          endif

        case (mdkr=3)     // Кредиторы
          if (dk>0)
            kklr=kkl
            while (kkl=kklr)
              skip
            enddo

            loop
          endif

        endcase

        if (pkklr>1)
          ?'Итого по клиенту :'+space(26)+iif(kdnr#0, str(kdnr, 10, 2), space(10))+' '+iif(kknr#0, str(kknr, 10, 2), space(10))+' '+iif(kdbr#0, str(kdbr, 10, 2), space(10))+' '+iif(kkrr#0, str(kkrr, 10, 2), space(10))+' '+iif(kdkr#0, str(kdkr, 10, 2), space(10))+' '+iif(kkkr#0, str(kkkr, 10, 2), space(10))
          colstr()
        /*            ?' ' */
        endif

        kdnr=dn
        kknr=kn
        kdbr=db
        kkrr=kr
        kdkr=dk
        kkkr=kk
        nklr=getfield('t1', 'dkout->kkl', 'kln', 'nkl')
        kkl1r=getfield('t1', 'dkout->kkl', 'kln', 'kkl1')
        if (dkout->kkl=kkl1r)
          psserr=upper(getfield('t1', 'dkout->kkl', 'kln', 'psse'))
          psnr=getfield('t1', 'dkout->kkl', 'kln', 'psn')
          if (psnr#0)
            passpr=passpr(psserr, psnr)
          else
            passpr=''
          endif

        else
          passpr=''
        endif

        nklr=subs(nklr, 1, 30)
        pkklr=0
      else
        if (ochr=2)
          skip
          loop
        endif

        salr=kdnr+dn-kknr-kn
        store 0 to kdnr, kknr
        if (salr>0)
          kdnr=salr
        endif

        if (salr<0)
          kknr=abs(salr)
        endif

        kdbr=kdbr+db
        kkrr=kkrr+kr
        salr=kdnr-kknr+kdbr-kkrr
        store 0 to kdkr, kkkr
        if (salr>0)
          kdkr=salr
        endif

        if (salr<0)
          kkkr=abs(salr)
        endif

      /*         pkklr++ */
      endif

      kklr=kkl
      /*     if pkklr=0.and.bs#0
       *        sele dkout
       *        skip
       *        loop
       *     endif
       */
      if (bs#bsr)
        pbsr=0
      else
        pbsr=1
      endif

      bsr=bs
      if (pkklr=0)
        ?' '+str(kkl, 7)+' '+subs(nklr, 1, 28)
        if (nnn#1)
          ??str(bsr, 6)+' '+iif(dn#0, str(dn, 10, 2), space(10))+' '+iif(kn#0, str(kn, 10, 2), space(10))+' '+iif(db#0, str(db, 10, 2), space(10))+' '+iif(kr#0, str(kr, 10, 2), space(10))+' '+iif(dk#0, str(dk, 10, 2), space(10))+' '+iif(kk#0, str(kk, 10, 2), space(10))+' '+iif(empty(ddb).or.bdr=1, space(10), dtoc(ddb))+' '+iif(empty(dkr).or.bdr=1, space(10), dtoc(dkr))
        else
          ??space(6)+' '+iif(dn#0, str(dn, 10, 2), space(10))+' '+iif(kn#0, str(kn, 10, 2), space(10))+' '+iif(db#0, str(db, 10, 2), space(10))+' '+iif(kr#0, str(kr, 10, 2), space(10))+' '+iif(dk#0, str(dk, 10, 2), space(10))+' '+iif(kk#0, str(kk, 10, 2), space(10))+' '+iif(empty(ddb).or.bdr=1, space(10), dtoc(ddb))+' '+iif(empty(dkr).or.bdr=1, space(10), dtoc(dkr))
        endif

        ??' '+passpr
        colstr()
      else
        if (pbsr=0)
          ?space(37)+str(bsr, 6)+' '+iif(dn#0, str(dn, 10, 2), space(10))+' '+iif(kn#0, str(kn, 10, 2), space(10))+' '+iif(db#0, str(db, 10, 2), space(10))+' '+iif(kr#0, str(kr, 10, 2), space(10))+' '+iif(dk#0, str(dk, 10, 2), space(10))+' '+iif(kk#0, str(kk, 10, 2), space(10))+' '+iif(empty(ddb).or.bdr=1, space(10), dtoc(ddb))+' '+iif(empty(dkr).or.bdr=1, space(10), dtoc(dkr))
          colstr()
        else
          ?space(37)+space(6)+' '+iif(dn#0, str(dn, 10, 2), space(10))+' '+iif(kn#0, str(kn, 10, 2), space(10))+' '+iif(db#0, str(db, 10, 2), space(10))+' '+iif(kr#0, str(kr, 10, 2), space(10))+' '+iif(dk#0, str(dk, 10, 2), space(10))+' '+iif(kk#0, str(kk, 10, 2), space(10))+' '+iif(empty(ddb).or.bdr=1, space(10), dtoc(ddb))+' '+iif(empty(dkr).or.bdr=1, space(10), dtoc(dkr))
          colstr()
        endif

        ??' '+passpr
      endif

      pkklr++
      sdn=sdn+dn; skn=skn+kn; sdb=sdb+db; skr=skr+kr; sdk=sdk+dk; skk=skk+kk
      sele dkout
      skip
    enddo

    if (nnn=1)
      colstr()
      ?'Итого по счету:'+space(26)+' '+iif(sdn#0, str(sdn, 11, 2), space(11))+' '+iif(skn#0, str(skn, 11, 2), space(11))+' '+iif(sdb#0, str(sdb, 11, 2), space(11))+' '+iif(skr#0, str(skr, 11, 2), space(11))+' '+iif(sdk#0, str(sdk, 11, 2), space(11))+' '+iif(skk#0, str(skk, 11, 2), space(11))
    endif

    ?'   Всего      :'+space(26)+' '+iif(sdn#0, str(sdn, 11, 2), space(11))+' '+iif(skn#0, str(skn, 11, 2), space(11))+' '+iif(sdb#0, str(sdb, 11, 2), space(11))+' '+iif(skr#0, str(skr, 11, 2), space(11))+' '+iif(sdk#0, str(sdk, 11, 2), space(11))+' '+iif(skk#0, str(skk, 11, 2), space(11))
    set prin off
    set prin to txt.txt
    set cons on
    rest scre from scmess
    wselect(wdkzapr)
  endif

  if (p1=2)
    wselect(0)
    edfile('dk_bs.txt')
    wselect(wdkzapr)
  endif

  /*do case
   *   case p1=1  // Печать
   *        if gnOut=1 // Принтер
   *           !copy dk.txt prn >nul
   *        else       // Файл
   *           Уже есть dk.txt
   *        endif
   *   case p1=2  // Экран
   *        wselect(0)
   *        edfile('dk_bs.txt')
   *        wselect(wdkzapr)
   *endc
   */
  return

/***********************************************************
 * prndki
 *   Параметры:
 */
procedure prndki
  para p1, p2
  /* p1 - 1-Печать;2-Экран
   * p2 - 0-Подготовка;1-Нет
   */
  if (p2=0)               // Подготовка
    wselect(0)
    save scre to scmess
    mess('Ждите,идет подготовка...')
    sele dkout
    zap
    sele dkkln
    go top
    while (!eof())
      nnr=0
      kklr=kkl
      bsr=bs
      dnr=dn
      knr=kn
      dbr=db
      krr=kr
      dk_r=0
      kk_r=0
      ddbr=ddb
      dkrr=dkr
      sele sl1
      LOCATE for val(kod)=bsr
      if (!FOUND())
        sele dkkln
        skip
        loop
      endif

      sele sl
      LOCATE for val(kod)=bsr
      if (FOUND())
        nnr=0
      else
        nnr=bsr
      endif

      sele dkout
      if (nnr=0)
        if (!netseek('t1', 'kklr,nnr'))
          salr=dnr-knr+dbr-krr
          if (salr>0)
            dk_r=salr
          endif

          if (salr<0)
            kk_r=abs(salr)
          endif

          appe blank
          repl kkl with kklr, bs with nnr, ;
           dn with dnr, kn with knr,       ;
           db with dbr, kr with krr,       ;
           dk with dk_r, kk with kk_r,     ;
           ddb with ddbr, dkr with dkrr
        else
          salr=dn-kn+dnr-knr
          store 0 to dnr, knr
          if (salr>0)
            dnr=salr
          endif

          if (salr<0)
            knr=abs(salr)
          endif

          dbr=db+dbr
          krr=kr+krr

          salr=dnr-knr+dbr-krr
          store 0 to dk_r, kk_r
          if (salr>0)
            dk_r=salr
          endif

          if (salr<0)
            kk_r=abs(salr)
          endif

          repl dn with dnr, ;
           kn with knr,     ;
           db with dbr,     ;
           kr with krr,     ;
           dk with dk_r,    ;
           kk with kk_r
          if (ddbr>ddb)
            repl ddb with ddbr
          endif

          if (dkrr>dkr)
            repl dkr with dkrr
          endif

        endif

      else
        salr=dnr-knr+dbr-krr
        store 0 to dk_r, kk_r
        if (salr>0)
          dk_r=salr
        endif

        if (salr<0)
          kk_r=abs(salr)
        endif

        appe blank
        repl kkl with kklr, bs with nnr, ;
         dn with dnr, kn with knr,       ;
         db with dbr, kr with krr,       ;
         dk with dk_r, kk with kk_r
      endif

      sele dkkln
      skip
    enddo

    rest scre from scmess
    mess('Печать...')
    sele dkout
    go top
    /*   set prin to dk.txt */
    set prin on
    set cons off
    store 0 to kklr
    bsr=1
    colstr=0
    lstr=1
    colstr0()
    pkklr=0
    store 0 to kdnr, kknr, kdbr, kkrr, kdkr, kkkr, sdn, skn, sdb, skr, sdk, skk
    while (!eof())
      if (kkl#kklr)
        if (abs(dk+kk)<sumr)
          kklr=kkl
          while (kkl=kklr)
            skip
          enddo

          loop
        endif

        do case
        case (mdkr=1)     // Все
        case (mdkr=2)     // Дебеторы
          if (kk>0)
            kklr=kkl
            while (kkl=kklr)
              skip
            enddo

            loop
          endif

        case (mdkr=3)     // Кредиторы
          if (dk>0)
            kklr=kkl
            while (kkl=kklr)
              skip
            enddo

            loop
          endif

        endcase

        if (pkklr>1)
          ?'Итого по клиенту :'+space(22)+space(6)+' '+iif(kdnr#0, str(kdnr, 10, 2), space(10))+' '+iif(kknr#0, str(kknr, 10, 2), space(10))+' '+iif(kdbr#0, str(kdbr, 10, 2), space(10))+' '+iif(kkrr#0, str(kkrr, 10, 2), space(10))+' '+iif(kdkr#0, str(kdkr, 10, 2), space(10))+' '+iif(kkkr#0, str(kkkr, 10, 2), space(10))
          colstr()
          ?' '
          colstr()
        endif

        kdnr=dn
        kknr=kn
        kdbr=db
        kkrr=kr
        kdkr=dk
        kkkr=kk
        nklr=getfield('t1', 'dkout->kkl', 'kln', 'nkl')
        nklr=subs(nklr, 1, 30)
        kkl1r=getfield('t1', 'dkout->kkl', 'kln', 'kkl1')
        if (dkout->kkl=kkl1r)
          psserr=upper(getfield('t1', 'dkout->kkl', 'kln', 'psse'))
          psnr=getfield('t1', 'dkout->kkl', 'kln', 'psn')
          if (psnr#0)
            passpr=passpr(psserr, psnr)
          else
            passpr=''
          endif

        else
          passpr=''
        endif

        pkklr=0
      else
        if (ochr=2)
          skip
          loop
        endif

        salr=kdnr+dn-kknr-kn
        store 0 to kdnr, kknr
        if (salr>0)
          kdnr=salr
        endif

        if (salr<0)
          kknr=abs(salr)
        endif

        kdbr=kdbr+db
        kkrr=kkrr+kr
        salr=kdnr-kknr+kdbr-kkrr
        store 0 to kdkr, kkkr
        if (salr>0)
          kdkr=salr
        endif

        if (salr<0)
          kkkr=abs(salr)
        endif

      /*         pkklr++ */
      endif

      kklr=kkl
      if (pkklr=0.and.bs#0)
        sele dkout
        skip
        loop
      endif

      if (bs#bsr)
        /*         nbsr=getfield('t1','dkout->bs','bs','nbs') */
        pbsr=0
      else
        pbsr=1
      endif

      bsr=bs
      if (bsr=0)
        bsr=1
      endif

      if (pkklr=0)
        ?' '+str(kkl, 7)+' '+nklr
        ??' '+iif(bsr#1, str(bsr, 6), space(6))+' '+iif(dn#0, str(dn, 10, 2), space(10))+' '+iif(kn#0, str(kn, 10, 2), space(10))+' '+iif(db#0, str(db, 12, 2), space(12))+' '+iif(kr#0, str(kr, 12, 2), space(12))+' '+iif(dk#0, str(dk, 10, 2), space(10))+' '+iif(kk#0, str(kk, 10, 2), space(10))+' '+iif(empty(ddb).or.bdr=1, space(8), dtoc(ddb))+' '+iif(empty(dkr).or.bdr=1, space(8), dtoc(dkr))
        /*     sdn=sdn+dn; skn=skn+kn; sdb=sdb+db; skr=skr+kr; sdk=sdk+dk; skk=skk+kk */

        ??' '+passpr
        colstr()
      else
        if (pbsr=0)
          ?space(40)+iif(bsr#1, str(bsr, 6), space(6))+' '+iif(dn#0, str(dn, 10, 2), space(10))+' '+iif(kn#0, str(kn, 10, 2), space(10))+' '+iif(db#0, str(db, 12, 2), space(12))+' '+iif(kr#0, str(kr, 12, 2), space(12))+' '+iif(dk#0, str(dk, 10, 2), space(10))+' '+iif(kk#0, str(kk, 10, 2), space(10))
          ??' '+passpr
          colstr()
        else
          ?space(40)+space(6)+' '+iif(dn#0, str(dn, 10, 2), space(10))+' '+iif(kn#0, str(kn, 10, 2), space(10))+' '+iif(db#0, str(db, 12, 2), space(12))+' '+iif(kr#0, str(kr, 12, 2), space(12))+' '+iif(dk#0, str(dk, 10, 2), space(10))+' '+iif(kk#0, str(kk, 10, 2), space(10))
          ??' '+passpr
          colstr()
        endif

      endif

      sdn=sdn+dn; skn=skn+kn; sdb=sdb+db; skr=skr+kr; sdk=sdk+dk; skk=skk+kk

      pkklr++
      sele dkout
      skip
    enddo

    ?'   Всего      :'+space(26)+' '+iif(sdn#0, str(sdn, 12, 2), space(12))+' '+iif(skn#0, str(skn, 12, 2), space(12))+' '+iif(sdb#0, str(sdb, 12, 2), space(12))+' '+iif(skr#0, str(skr, 12, 2), space(12))+' '+iif(sdk#0, str(sdk, 12, 2), space(12))+' '+iif(skk#0, str(skk, 12, 2), space(12))
    set prin off
    set prin to txt.txt
    set cons on
    rest scre from scmess
    wselect(wdkzapr)
  endif

  if (p1=2)
    wselect(0)
    edfile('dk_bs.txt')
    wselect(wdkzapr)
  endif

  /*do case
   *   case p1=1  // Печать
   *        if gnOut=1 // Принтер
   *           !copy dk.txt prn >nul
   *        else       // Файл
   *           Уже есть dk.txt
   *        endif
   *   case p1=2  // Экран
   *        wselect(0)
   *        edfile('dk.txt')
   *        wselect(wdkzapr)
   *endc
   */
  return

/***********************************************************
 * colstr
 *   Параметры:
 */
procedure colstr
  colstr++
  if (colstr=56)
    colstr=0
    ?'--------------------------------------------------------------------------------------------------------'
    lstr++
    eject
    colstr0()
  endif

RETURN

/***********************************************************
 * colstr0
 *   Параметры:
 */
procedure colstr0
  do case
  case (mdkr=1)
    ?'                                       Ведомость Дебеторов - Кредиторов '+upper(gcNent)
  case (mdkr=2)
    ?'                                              Ведомость Дебеторов '+upper(gcNent)
  case (mdkr=3)
    ?'                                              Ведомость Кредиторов '+upper(gcNent)
  endcase

  ?'                                              по счету(счетам) '+schr
  ?dtoc(gdTd)+' Конечное сальдо больше '+str(sumr, 4)+' грн                                                                 '+dtoc(gdTd)+'  Лист '+str(lstr, 2)
  if (bdr=0)
    ?'┌───────┬───────────────────────────────┬─────┬──────────┬──────────┬──────────┬──────────┬──────────┬──────────┬──────────┬──────────┐'
    ?'│  Код  │         Наименование          │ Счет│ Дебет на │ Кредит на│   Дебет  │  Кредит  │ Дебет на │ Кредит на│    Дата  │    Дата  │'
    ?'│       │                               │     │  начало  │  начало  │          │          │  конец   │   конец  │   дебет  │   кредит │'
    ?'├───────┼───────────────────────────────┼─────┼──────────┼──────────┼──────────┼──────────┼──────────┼──────────┼──────────┼──────────┤'
  else
    ?'┌───────┬───────────────────────────────┬─────┬──────────┬──────────┬──────────┬──────────┬──────────┬──────────┐'
    ?'│  Код  │         Наименование          │ Счет│ Дебет на │ Кредит на│   Дебет  │  Кредит  │ Дебет на │ Кредит на│'
    ?'│       │                               │     │  начало  │  начало  │          │          │  конец   │   конец  │'
    ?'├───────┼───────────────────────────────┼─────┼──────────┼──────────┼──────────┼──────────┼──────────┼──────────┤'
  endif

  colstr++

RETURN

/*****************************************************************
 
 FUNCTION:
 АВТОР..ДАТА..........С. Литовка  04-23-19 * 07:52:08pm
 НАЗНАЧЕНИЕ.........
 ПАРАМЕТРЫ..........
 ВОЗВР. ЗНАЧЕНИЕ....
 ПРИМЕЧАНИЯ.........
 */
function passpr(psserr, psnr)
  if (Empty(psserr))
    return (padl(allt(str(psnr, 9)), 9, '0'))
  else
    return (allt(psserr)+' '+allt(str(psnr, 9)))
  endif

  return (nil)
