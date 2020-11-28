/***********************************************************
 * Модуль    : kgpsk.prg
 * Версия    : 0.0
 * Автор     :
 * Дата      : 08/15/18
 * Изменен   :
 * Примечание: Текст обработан утилитой CF версии 2.02
 */

#include "common.ch"
#include "inkey.ch"
/* Доставка со складов */
clea
netuse('kgpsk')
netuse('kln')
netuse('cskl')

forr='.t.'

sele kgpsk
go top
rckgpsk=recn()
while (.t.)
  sele kgpsk
  go rckgpsk
  foot('INS,DEL,F2,F3', 'Обновить,Удалить,Маска,Фильтр')
  rckgpsk=slcf('kgpsk', 1,, 18,, "e:kgp h:'КодГ' c:n(7) e:getfield('t1','kgpsk->kgp','kln','nkl') h:'Получатель' c:c(25) e:sk h:'SK' c:n(3) e:getfield('t1','kgpsk->sk','cskl','nskl') h:'Склад' c:c(25) e:mskw h:'ПВСЧПСВ' c:c(7)",,, 1,, forr)
  if (lastkey()=27)
    exit
  endif

  sele kgpsk
  go rckgpsk
  kgpr=kgp
  skr=sk
  mskwr=mskw
  do case
  case (lastkey()=K_INS)
    kgpskins()
    sele kgpsk
    go top
    rckgpsk=recn()
  case (lastkey()=K_DEL)
    netdel()
    skip -1
    if (bof())
      go top
    endif

    rckgpsk=recn()
  case (lastkey()=-1)     // Маска
    mskw()
  case (lastkey()=-2)     // Фильтр
    store 0 to skr, kgpr
    clkflt=setcolor('gr+/b,n/w')
    wkflt=wopen(10, 30, 13, 50)
    wbox(1)
    @ 0, 1 say 'Склад' get skr pict '999'
    @ 1, 1 say 'ГрПол' get kgpr pict '9999999'
    read
    wclose(wkflt)
    setcolor(clkflt)
    if (lastkey()=27)
      forr='.t.'
    endif

    if (lastkey()=13)
      forr='.t.'
      if (skr#0)
        forr=forr+'.and.sk=skr'
      endif

      if (kgpr#0)
        forr=forr+'.and.kgp=kgpr'
      endif

    endif

    go top
    rckgpsk=recn()
  /*      case lastkey()=-4 && Копировать
   *           ktacopy()
   */
  endcase

enddo

return (.t.)

/***********************************************************
 * kgpskins() -->
 *   Параметры :
 *   Возвращает:
 */
function kgpskins()
  dt1r=bom(gdTd)
  dt2r=gdTd
  clkpli=setcolor('gr+/b,n/w')
  wkpli=wopen(10, 10, 12, 70)
  wbox(1)
  @ 0, 1 say 'Период ' get dt1r
  @ 0, col()+1 get dt2r
  read
  if (lastkey()=13)
    for g=year(dt1r) to year(dt2r)
      if (year(dt1r)=year(dt2r))
        m1=month(dt1r)
        m2=month(dt2r)
      else
        do case
        case (g=year(dt1r))
          m1=month(dt1r)
          m2=12
        case (g=year(dt2r))
          m1=1
          m2=month(dt2r)
        otherwise
          m1=1
          m2=12
        endcase

      endif

      for m=m1 to m2
        path_d=gcPath_e+'g'+str(g, 4)+'\m'+iif(m<10, '0'+str(m, 1), str(m, 2))+'\'
        sele cskl
        while (!eof())
          if (!(ent=gnEnt.and.rasc=1))
            sele cskl
            skip
            loop
          endif

          pathr=path_d+alltrim(path)
          if (!netfile('rs1', 1))
            sele cskl
            skip
            loop
          endif

          skr=sk
          mess(pathr)
          netuse('rs1',,, 1)
          sele rs1
          while (!eof())
            if (vo#9)
              sele rs1
              skip
              loop
            endif

            kgpr=kpv
            sele kgpsk
            if (!netseek('t1', 'kgpr,skr'))
              netadd()
              netrepl('kgp,sk', 'kgpr,skr')
            endif

            sele rs1
            skip
          enddo

          nuse('rs1')
          sele cskl
          skip
        enddo

      next

    next

  endif

  wclose(wkpli)
  setcolor(clkpli)
  return (.t.)

/***********************************************************
 * mskw() -->
 *   Параметры :
 *   Возвращает:
 */
function mskw()
  store 0 to w1r, w2r, w3r, w4r, w5r, w6r, w7r, nwr
  aaa=''
  mskw_r=''
  cwr=''
  for ii=1 to 7
    cwr='w'+str(ii, 1)+'r'
    &cwr=val(subs(mskwr, ii, 1))
  next

  clmskw=setcolor('gr+/b,n/w')
  wmskw=wopen(10, 10, 13, 70)
  wbox(1)
  @ 0, 1 say 'Маска  Пн Вт Ср Чт Пт Сб Вс'
  @ 1, 9 get w1r pict '9'
  @ 1, col()+2 get w2r pict '9'
  @ 1, col()+2 get w3r pict '9'
  @ 1, col()+2 get w4r pict '9'
  @ 1, col()+2 get w5r pict '9'
  @ 1, col()+2 get w6r pict '9'
  @ 1, col()+2 get w7r pict '9'
  read
  wclose(wmskw)
  setcolor(clmskw)

  for ii=1 to 7
    cwr='w'+str(ii, 1)+'r'
    nwr=&cwr
    if (nwr>0)
      aaa='1'
    else
      aaa=' '
    endif

    mskw_r=mskw_r+aaa
  next

  sele kgpsk
  netrepl('mskw', 'mskw_r')
  return (.t.)
