/***********************************************************
 * Модуль    : rs3ssf.prg
 * Версия    : 0.0
 * Автор     :
 * Дата      : 12/01/20
 * Изменен   :
 * Примечание: Текст обработан утилитой CF версии 2.02
 */

#include "common.ch"
#include "inkey.ch"
clrs3ssf=setcolor('w+/rb+,n/w')
stkeyr=savesetkey()
store 0 to ssz_r, ssf_r, pr_r, bssf_r, bpr_r
store '' to nz_r
sele dclr
/****** */
netseek('t1', 'kszr')
/****** */
if (kszr=62.and.gnEnt=21)
  wmess('Эта статья не корректируется', 3)
  setcolor(clrs3ssf)
  return
endif

if (pr=1)
  wmess('Эта статья не корректируется', 3)
  setcolor(clrs3ssf)
  return
endif

if (pbzenr=1.and.bprzr=1)
  wmess('Эта статья не корректируется', 3)
  setcolor(clrs3ssf)
  return
endif

if ( kszr=40.and.gnEnt=20 .or. kszr=40.and.gnEnt=21.and.gnVo=9)
  if (gnKto#160)
    wmess('Эта статья не корректируется', 3)
    setcolor(clrs3ssf)
    return
  endif

endif

ww=wopen(10, 10, 13, 57, .t.)
wbox(1)
nz_r=nz
@ 0, 1 say '       Наименование   Процент    Сумма'
sele rs3
if (netseek('t1', 'ttnr,kszr'))
  ssf_r=ssf
  pr_r=pr
  bssf_r=bssf
  bpr_r=bpr
  if (fieldpos('xssf')#0)
    xssf_r=xssf
    xpr_r=xpr
  else
    xssf_r=0
    xpr_r=0
  endif

  @ 1, 1 say str(kszr, 2)+' '+nz_r get pr_r pict '9999.99'
  @ 1, col()+1 say ssf_r pict '99999999.999'
  read
  if (lastkey()=K_ESC)
    wclose()
    setcolor(clrs3ssf)
    return
  endif

  if (lastkey()=K_ENTER)
    if (pr_r=0)
      @ 1, 1 say str(kszr, 2)+' '+nz_r+' '+str(pr_r, 6, 2) get ssf_r pict '99999999.999'// when ws49() valid vs49()
      read
      if (lastkey()=K_ESC)
        wclose()
        setcolor(clrs3ssf)
        return
      endif

    endif

  endif

  /*   if pbzenr=1
   *      if kszr#49
   *         netrepl('ssz,ssf,pr,bssf,bpr','ssf_r,ssf_r,pr_r,ssf_r,pr_r')
   *      else
   *         netrepl('ssz,ssf,pr,bssf,bpr','ssf_r,ssf_r,pr_r,bssf_r,bpr_r')
   *      endif
   *   else
   *      netrepl('ssz,ssf,pr','ssf_r,ssf_r,pr_r')
   *   endif
   */

  netrepl('ssz,ssf,pr', 'ssf_r,ssf_r,pr_r')
  if (pbzenr=1.and.kszr#49)
    netrepl('bssf,bpr', 'ssf_r,pr_r')
  endif

  if (pxzenr=1.and.kszr#49)
    netrepl('xssf,xpr', 'ssf_r,pr_r')
  endif

  prModr=1
endif

wclose()
restsetkey(stkeyr)
setlastkey(0)
setcolor(clrs3ssf)
return

