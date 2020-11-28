/***********************************************************
 * Модуль    : psert.prg
 * Версия    : 0.0
 * Автор     :
 * Дата      : 07/09/18
 * Изменен   :
 * Примечание: Текст обработан утилитой CF версии 2.02
 */

#include "common.ch"
#include "inkey.ch"
//Печать сертификатов
clea
if (select('sl')#0)
  sele sl
  CLOSE
endif

sele 0
use _slct alias sl excl
zap

sele 0
use shrift
// if fieldpos('path_bi')=0
//  use
//  retu
// endif
ptsertr=alltrim(shrift->shr2)
ptacdr=alltrim(shrift->shr3)
ptbir=alltrim(shrift->path_bi)// IN BAT  (J:\budinf\sert\in\)
ptbor=alltrim(shrift->path_bo)// OUT BAT (J:\budinf\sert\out\)
CLOSE

if (empty(ptsertr))
  ptsertr=gcPath_l+'\'+'sert\'
endif

if (select('lsert')#0)
  sele lsert
  CLOSE
  erase lsert.dbf
endif

FileDelete('lsert.*')
crtt('lsert', 'f:ksert c:n(6) f:kukach c:n(6) f:dtukach c:d(10) f:izg c:n(7) f:ot c:n(1)')

sele 0
use lsert excl
// inde on str(ksert,6)+str(kukach,6) tag t1
inde on str(kukach, 6) tag t1

netuse('sert')
netuse('nap')
netuse('ukach')
netuse('kln')
netuse('s_tag')
netuse('tov')
// netuse('tovpt')
netuse('rs1')
netuse('rs2')
netuse('rs3')
sklr=gnSkl
sele rs1
// for_r="(vo=9.or.vo=2.or.vo=6.and.(kop=181.or.kop=101)).and.getfield('t1','rs1->ttn,46','rs3','ssf')#0"
for_r=".t..and.(vo=9.and.kop#177.and.kop#169.or.vo=2.or.vo=6.and.(kop=181.or.kop=101.or.kop=188))"
forr=for_r
ttndt1r=bom(gdTd)
ttndt2r=gdTd
ttnprzr=0
ttnkplr=0
ttnkecsr=0
ttn_r=0
mrsh_r=0
go top
while (.t.)
  foot('F3,SPACE,ENTER', 'Фильтр,Отбор,Печать')
  rcrs1r=slcf('rs1',,,,, "e:ttn h:'TTН' c:n(6) e:mrsh h:'М.Лист' c:n(6) e:iif(rs1->kpv#0,getfield('t1','rs1->kpv','kln','nkl'),getfield('t1','rs1->kpl','kln','nkl')) h:'Покупатель' c:c(20) e:getfield('t1','rs1->kecs','s_tag','fio') h:'Экспедитор' c:c(11) e:dsp h:'Дата СФ' c:d(10)  e:dsert h:'Дата Пч' c:d(10) e:iif(subs(rs1->ser,2,1)='1','Да','  ') h:'ОД' c:c(2) e:getfield('t1','rs1->nap','nap','nnap') h:'Напр' c:c(4)",, 1,,, forr,, alltrim(gcNskl)+' Печать сертификатов')
  sele rs1
  go rcrs1r
  do case
  case (lastkey()=K_ESC)
    exit
  case (lastkey()=K_ENTER.and.!empty(ptacdr))// Печать
    sele sl
    go top
    while (!eof())
      sele sl
      rcrs1_r=val(kod)
      sele rs1
      go rcrs1_r
      ttnr=ttn
      mrshr=mrsh
      kplr=kpl
      nkplr=getfield('t1', 'kplr', 'kln', 'nkl')
      kgpr=kgp
      ngpr=getfield('t1', 'kgpr', 'kln', 'nkl')
      kpvr=kpv
      nkpvr=getfield('t1', 'kpvr', 'kln', 'nkl')
      npvr=npv

      PrnSert()

      sele rs1
      sert_r=sert+1
      if (sert_r>9)
        sert_r=1
      endif

      netrepl('dsert,tsert,sert', 'date(),time(),sert_r')
      sele sl
      skip
    enddo

    sele sl
    zap
  case (lastkey()=K_F3)   // Фильтр
    clttnr=setcolor('gr+/b,n/bg')
    wttnr=wopen(10, 15, 20, 70)
    wbox(1)
    @ 0, 1 say 'Период    ' get ttndt1r
    @ 0, col()+1 get ttndt2r
    @ 1, 1 say 'Признак   ' get ttnprzr pict '9'
    @ 1, col()+1 say '0-Все;1-Не Пч'
    @ 2, 1 say 'Плательщик' get ttnkplr pict '9999999'
    @ 3, 1 say 'Экспедитор' get ttnkecsr pict '999'
    @ 4, 1 say 'ТТН       ' get ttn_r pict '999999'
    @ 5, 1 say 'Маршр.Лист' get mrsh_r pict '999999'
    read
    if (lastkey()=K_ESC)
      wclose(wttnr)
      setcolor(clttnr)
      loop
    endif

    if (!empty(ttndt1r))
      if (empty(ttndt2r))
        forr=for_r+'.and.dsp=ttndt1r'
      else
        forr=for_r+'.and.dsp>=ttndt1r.and.dsp<=ttndt2r'
      endif

    endif

    do case
    case (ttnprzr=0)      // Все
      forr=forr+'.and..t.'
    case (ttnprzr=1)      // Не распечатанные
      forr=forr+'.and.empty(dsert)'
    endcase

    if (ttnkplr#0)
      forr=forr+'.and.kpl=ttnkplr'
    endif

    if (ttnkecsr#0)
      forr=forr+'.and.kecs=ttnkecsr'
    endif

    if (ttn_r#0)
      forr=forr+'.and.ttn=ttn_r'
    endif

    if (mrsh_r#0)
      forr=forr+'.and.mrsh=mrsh_r'
    endif

    wclose(wttnr)
    setcolor(clttnr)
    sele rs1
    go top
    rcrs1r=recn()
  endcase

enddo

nuse()
sele sl
CLOSE
sele lsert
CLOSE

/***********************************************************
 * PrnSert
 *   Параметры:
 */
procedure PrnSert
  //Печать сертификатов
  prscanr=0
  while (.t.)
    if (file(ptbor+'nsert.dbf'))
      wmess('Ждите,идет печать', 5)
      if (lastkey()=K_ESC)
        exit
      endif

    else
      prscanr=1
      exit
    endif

  enddo

  if (prscanr=0)
    return
  endif

  //
  if (!file(ptbor+'nsert.dbf'))
    crtt(ptbor+'nsert', 'f:izg c:n(7) f:ksert c:n(6) f:kukach c:n(6) f:dtukach c:d(10) f:tp c:n(1) f:kolekz c:n(2) f:sp c:n(1) f:ttn c:n(6) f:nkpl c:c(40) f:ngp c:c(40) f:nkpv c:c(40) f:npv c:c(40) f:nsert c:c(30) f:nukach c:c(60) f:mrsh c:n(6)')
  endif

  sele 0
  use (ptbor+'nsert') excl
  zap
  sele lsert
  zap

  // s46r=getfield('t1','ttnr,46','rs3','ssf')
  sele rs2
  set orde to tag t1
  if (netseek('t1', 'ttnr'))
    while (ttn=ttnr)
      //     if sert=0.and.s46r=0
      //        skip
      //        loop
      //     endif
      ktlr=ktl
      izgr=izg
      ksertr=getfield('t1', 'sklr,ktlr', 'tov', 'ksert')
      kukachr=getfield('t1', 'sklr,ktlr', 'tov', 'kukach')
      dtukachr=getfield('t2', 'kukachr', 'ukach', 'dtukach')
      //     if ksertr=0.and.kukachr=0
      if (kukachr=0)
        skip
        loop
      endif

      sele lsert
      //     if !netseek('t1','ksertr')
      //        netadd()
      //        netrepl('ksert,kukach,izg,ot','ksertr,kukachr,izgr,1')
      //     else
      //        if !netseek('t1','ksertr,kukachr')
      //           if !netseek('t1','0,kukachr')
      //              netadd()
      //              netrepl('kukach,izg,ot','kukachr,izgr,1')
      //           endif
      //        endif
      //     endif
      if (!netseek('t1', 'kukachr'))
        netadd()
        netrepl('kukach,dtukach,izg,ot', 'kukachr,dtukachr,izgr,1')
      endif

      sele rs2
      skip
    enddo

  endif

  sele lsert
  prskr=0
  if (recc()#0)
    go top
    while (!eof())
      sele lsert
      //     ksertr=ksert
      kukachr=kukach
      dtukachr=dtukach
      if (kukachr=0)
        skip
        loop
      endif

      izgr=izg
      //     dpaths_r=ptsertr+alltrim(str(izgr,7))
      //     nsertr=getfield('t1','ksertr','sert','nsert')
      nukachr=getfield('t2', 'kukachr', 'ukach', 'nukach')
      sele nsert
      netadd()
      //Печать только качественных
      netrepl('izg,kukach,dtukach,tp,sp,kolekz,ttn,nkpl,ngp,nkpv,npv,nukach,mrsh', 'izgr,kukachr,dtukachr,2,2,1,ttnr,nkplr,ngpr,nkpvr,npvr,nukachr,mrshr')
      // формирование бат для печати, перенесено в ФоКС
      sele lsert
      skip
    enddo

    sele nsert
    copy to nsert
    CLOSE
    if (file(ptbor+'nsert.dbf'))
      wmess('Печать ТТН N '+str(ttnr, 6), 1)
    endif

  // печать ярлыка сертификата - высено в ФоКС
  else                      // recc()=0
    sele nsert
    CLOSE
    erase(ptbor+'nsert.dbf')
  endif

  // формирование бат для печати, перенесено в ФоКС
  //     if ksertr#0
  //        for i=1 to 9
  //            if file(dpaths_r+'\s'+strtran(str(ksertr,6),' ','0')+str(i,1)+'.jpg')
  //               erase sert2.bat
  //               ffr=fcreate('sert2.bat')
  //               fwrite(ffr,'@echo off '+chr(13)+chr(10))
  //               fwrite(ffr,'c:'+chr(13)+chr(10))
  //               fwrite(ffr,'cd '+ptacdr+' '+chr(13)+chr(10))
  //               fwrite(ffr,'start /B /I /WAIT acdsee  '+dpaths_r+'\s'+strtran(str(ksertr,6),' ','0')+str(i,1)+'.jpg /p!')
  //               fclose(ffr)
  //               !sert1.bat
  //               prskr=1
  //           endif
  //       next
  //       d irchange(gcPath_l)
  //    endif
  //    if kukachr#0
  //       for i=1 to 9
  //           if file(dpaths_r+'\u'+strtran(str(kukachr,6),' ','0')+str(i,1)+'.jpg')
  //              erase sert2.bat
  //              ffr=fcreate('sert2.bat')
  //              fwrite(ffr,'@echo off '+chr(13)+chr(10))
  //              fwrite(ffr,'c:'+chr(13)+chr(10))
  //              fwrite(ffr,'cd '+ptacdr+' '+chr(13)+chr(10))
  //              fwrite(ffr,'start /B /I /WAIT acdsee  '+dpaths_r+'\u'+strtran(str(kukachr,6),' ','0')+str(i,1)+'.jpg /p!')
  //              fclose(ffr)
  //              !sert1.bat
  //              prskr=1
  //           endif
  //       next
  //       d irchange(gcPath_l)
  //    endif

  // печать ярлыка сертификата - высено в ФоКС
  /*
  *  if gnOut=1
  *     set prin to lpt1
  *  else
  *     set prin to sert.txt
  *  endif
  *  set prin on
  *  set cons off
  *  if !empty(gcPrn)
  *     ??chr(27)+'E'+chr(27)+'&l4h25a0O'+chr(27)+'&k0S'+chr(27)+'&a1l'+chr(27)+'(3R'+chr(27)+'(s0p10.00h0s0b4099T'+chr(27)
  *  else
  *     ?? chr(27)+chr(77)+chr(15)
  *  endif
  *  ?'ТТН '+str(ttnr,6)
  *  ?'Плательщик '+nkplr
  *  ?'Получатель '+ngpr
  *  ?'Назначение '+nkpvr
  *  ?'           '+npvr
  *  if !empty(gcPrn)
  *     ??chr(27)+'E'+chr(27)+'&l0h' // Напечатать и извлечь страницу
  *  endif
  *  set cons on
  *  set prin off
  *  set prin to
  */

RETURN
