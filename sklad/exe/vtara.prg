/***********************************************************
 * Модуль    : vtara.prg
 * Версия    : 0.0
 * Автор     :
 * Дата      : 05/10/17
 * Изменен   :
 * Примечание: Текст обработан утилитой CF версии 2.02
 */

#include "common.ch"
#include "inkey.ch"
// Возврат тары
set colo to g/n, n/g,,,
clea
if (!netfile('vztara'))
  copy file (gcPath_a+'vztara.dbf') to (gcPath_d+'vztara.dbf')
  netind('vztara')
endif

netuse('vztara')
netuse('kln')
netuse('s_tag')
netuse('cskl')
locate for ent=gnEnt.and.tpstpok=2
pathr=gcPath_d+alltrim(path)
if (!netfile('tov', 1))
  nuse()
  return
endif

sele cskl
locate for ent=gnEnt.and.tpstpok=1
pathr=gcPath_d+alltrim(path)
netuse('tov',,, 1)
forr='.t.'
whlr='.t.'
sele vztara
while (.t.)
  foot('INS,DEL,F3,F4,F5', 'Добавить,Удалить,Фильтр,Коррекция,Печать')
  rcvztr=slcf('vztara', 1,, 18,, "e:nt h:' N' c:n(2) e:dfm h:'Дата ФМ' c:d(10) e:dzt h:'Дата ЗТ' c:d(10) e:getfield('t1','vztara->kkl','kln','nkl') h:'Клиент' c:c(30) e:getfield('t1','vztara->kecs','s_tag','fio') h:'Экспедитор' c:c(11) e:nnz h:'Накладная' c:c(9)",,, 1,, forr,, 'Маршруты по таре')
  go rcvztr
  ntr=nt
  dfmr=dfm
  dztr=dzt
  kklr=kkl
  nklr=getfield('t1', 'kklr', 'kln', 'nkl')
  kecsr=kecs
  necsr=getfield('t1', 'kecsr', 's_tag', 'fio')
  nnzr=nnz
  sele vztara
  do case
  case (lastkey()=K_ESC)
    exit
  case (lastkey()=K_INS)  // Добавить
    vztins(0)
  case (lastkey()=K_F4)   // Коррекция
    vztins(1)
  case (lastkey()= 7)     // Удалить
    sele vztara
    netdel()
    skip -1
    if (bof())
      go top
    endif

  case (lastkey()=K_F3)   // Фильтр
    if (forr='.t.')
      forr='empty(nnz)'
    else
      forr='.t.'
    endif

    sele vztara
    go top
  case (lastkey()=K_F5)   // Печать
    vztprn()
    sele vztara
    go rcvztr
  endcase

enddo

nuse()

/***********************************************************
 * vztins() -->
 *   Параметры :
 *   Возвращает:
 */
function vztins(p1)
  if (p1=0)
    store 0 to ntr, kecsr, kklr
    store space(9) to nnzr
    store date() to dfmr, dztr
  endif

  clvztins=setcolor('gr+/b,n/w')
  wvztins=wopen(7, 10, 15, 50)
  wbox(1)
  while (.t.)
    @ 0, 1 say 'Номер точки' get ntr pict '99'
    @ 1, 1 say 'Дата Формир' get dfmr
    @ 2, 1 say 'Дата Заявки' get dztr
    @ 3, 1 say 'Клиент     ' get kklr pict '9999999'
    @ 3, col()+1 say nklr
    @ 4, 1 say 'Экспедитор ' get kecsr pict '9999'
    @ 4, col()+1 say necsr
    @ 5, 1 say 'Накладная  ' get nnzr
    @ 6, 20 prom 'Верно'
    @ 6, col()+1 prom 'Не Верно'
    read
    if (lastkey()=K_ESC)
      exit
    endif

    menu to vnr
    if (lastkey()=K_ESC)
      exit
    endif

    if (vnr=1)
      sele vztara
      if (p1=0)
        netadd()
        netrepl('nt,dfm,dzt,kkl,kecs,nnz', 'ntr,dfmr,dztr,kklr,kecsr,nnzr')
      else
        netrepl('nt,dfm,dzt,kkl,kecs,nnz', 'ntr,dfmr,dztr,kklr,kecsr,nnzr')
      endif

      if (empty(nnz))
        netrepl('dfm', 'dzt')
      endif

      exit
    endif

  enddo

  wclose(wvztins)
  setcolor(clvztins)
  return

/***********************************************************
 * vztprn() -->
 *   Параметры :
 *   Возвращает:
 */
function vztprn()
  aprn:={ 'LPT1', 'LPT2', 'LPT3', 'Файл' }
  aprnr=alert('', aprn)
  set cons off
  set prin on
  do case
  case (aprnr=1)
    set prin to lpt1
    if (empty(gcPrn))
      ??chr(27)+chr(80)+chr(15)
    else
      ??chr(27)+'E'+chr(27)+'&l4h25a0O'+chr(27)+'&k2S'+chr(27)+'&a20l'+chr(27)+'(3R'+chr(27)+'(s0p17.00h0s0b4099T'+chr(27)
    endif

    rsw_r=43
  case (aprnr=2)
    set prin to lpt2
    ??chr(27)+'E'+chr(27)+'&l4h25a0O'+chr(27)+'&k2S'+chr(27)+'&a20l'+chr(27)+'(3R'+chr(27)+'(s0p17.00h0s0b4099T'+chr(27)
    rsw_r=92
  case (aprnr=3)
    set prin to lpt3
    ??chr(27)+'E'+chr(27)+'&l4h25a0O'+chr(27)+'&k2S'+chr(27)+'&a20l'+chr(27)+'(3R'+chr(27)+'(s0p17.00h0s0b4099T'+chr(27)
    rsw_r=92
  case (aprnr=4)
    set prin to txt.txt
    rsw_r=43
  endcase

  lstr=1
  vztsh()
  sele vztara
  if (netseek('t1', 'dfmr'))
    while (dfm=dfmr)
      kklr=kkl
      ?' '
      rwvzt()
      ?str(nt, 2)+' '+getfield('t1', 'kklr', 'kln', 'nkl')
      rwvzt()
      sele tov
      if (netseek('t1', 'kklr'))
        while (skl=kklr)
          if (osf=0)
            skip
            loop
          endif

          ?str(ktl, 9)+' '+subs(nat, 1, 30)+' '+str(opt, 10, 3)+' '+str(osf, 10, 3)+' '+nei
          rwvzt()
          sele tov
          skip
        enddo

      endif

      sele vztara
      skip
    enddo

  endif

  set prin off
  set cons on
  return

/***********************************************************
 * rwvzt
 *   Параметры:
 */
procedure rwvzt()
  rswr++
  if (rswr>=rsw_r)
    rswr=1
    lstr++
    eject
    if (aprnr=1.and.empty(gcPrn))
      wmess('Вставте лист и нажмите пробел', 0)
      vztsh()
    endif

  endif

  return

/***********************************************************
 * vztsh
 *   Параметры:
 */
procedure vztsh()
  ?''
  return
