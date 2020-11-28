#include "common.ch"
#include "inkey.ch"
*Бланк строгой отчетности 2-й лист
set cons off
set prin to
set prin on
??chr(27)+chr(64)
??chr(27)+chr(18)
??chr(27)+chr(77)
??chr(27)+chr(51)+chr(43) // Шаг
??chr(27)+chr(56)         // Вырубить конец бумаги
??chr(27)+chr(74)+chr(15) // Перевод строки на 15/216 дюйма

set devi to prin
setprc(0,0)
if n_r=33 // 34
   n_r=0
   sele rs2
   do while ttn=ttnr.and.n_r<30
      ktlr=ktl
      kvpr=kvp
      zenr=zen
      svpr=svp
      sele tov
      netseek('t1','sklr,ktlr')
      natr=nat
      keir=kei
      neir=nei
      @ n_r,14 say natr
      @ n_r,61 say str(ktlr,7)
      @ n_r,72 say str(kei,4)
      @ n_r,82 say nei
      @ n_r,85 say str(kvpr,10,3)
      @ n_r,94 say str(kvpr,10,3)
      @ n_r,106 say str(zenr,10,3)
      @ n_r,123 say str(svpr,10,2)
      n_r++
      sele rs2
      skip
   endd
endif
@ n_r,1 say ''

sele rs3

@ 31,21 say 'Товар    '
if netseek('t1','ttnr,10')
   @ 31,pcol() say str(ssf,10,2)
endif
@ 31,51 say 'А/у      '
if netseek('t1','ttnr,61')
   @ 31,pcol() say str(ssf,10,2)
endif
@ 31,81 say 'Оформ.док'
if netseek('t1','ttnr,46')
   @ 31,pcol() say str(ssf,10,2)
endif

@ 32,21 say 'Тара     '
if netseek('t1','ttnr,19')
   @ 32,pcol() say str(ssf,10,2)
endif
@ 32,51 say 'Скидки   '
if netseek('t1','ttnr,40')
   @ 32,pcol() say str(ssf,10,2)
endif
@ 32,81 say 'НДС      '
if netseek('t1','ttnr,11')
   @ 32,pcol() say str(ssf,10,2)
endif

??chr(27)+chr(74)+chr(15) // Перевод строки на 15/216 дюйма

ssf90r=0
if netseek('t1','ttnr,90')
   ssf90r=ssf
endif
@ 33,24 say numstr(cntrs2r)
@ 33,112 say 'Bсего    '
@ 33,123 say str(ssf90r,10,2)

??chr(27)+chr(74)+chr(15) // Перевод строки на 15/216 дюйма

@ 34,14 say numstr(ssf90r)
@ 34,74 say str(mod(ssf90r,1)*100,2)




??chr(27)+chr(57)
??chr(27)+chr(80)+chr(15)
??chr(27)+chr(50)
eject
set cons on
set devi to scre
set prin off
if vv=2
  set prin to txt.txt
endif

retu
****************
func pskguid()
****************
docguidpr:=NIL
clea
netuse('rs1')
set orde to tag t2 // docguid
go top
rcrs1r=recn()
fldnomr=1
forr='!empty(docguid)'
for_r=forr
do while .t.
   sele rs1
   go rcrs1r
   foot('F3,F5','Фильтр,Очистить DOCGUID')
   rcrs1r=slce('rs1',1,,18,,"e:docguid h:'DOCGUID' c:c(36) e:ttn h:' ТТН  ' c:n(6) e:kop h:'КОП' c:n(3) e:prz h:'PRZ' c:n(1) e:dop h:'  ДатаO ' c:d(10) e:kta h:'KTA' c:n(4) e:kolpos h:'Кпоз' c:n(3)",,,1,,forr)
   sele rs1
   go rcrs1r
   dopr=dop
   do case
      case lastkey()=K_ESC
           exit
      case lastkey()=19 // Left
           fldnomr=fldnomr-1
           if fldnomr=0
              fldnomr=1
           endif
      case lastkey()=4 // Right
           fldnomr=fldnomr+1
      case lastkey()=K_F3 // Фильтр
           clprvz=setcolor('gr+/b,n/bg')
           wprvz=wopen(10,15,14,70)
           wbox(1)
           docguidpr:=IIF(docguidpr=NIL,space(12),PADR(docguidpr,12))
           @ 0,1 say 'DOCGUID' get docguidpr
           read
           wclose(wprvz)
           setcolor(clprvz)
           if lastkey()=K_ESC
              forr=for_r
              exit
           endif
           if lastkey()=K_ENTER
              docguidpr=alltrim(docguidpr)
              sele rs1
              locate for at(docguidpr,docguid)#0
              if foun()
                 rcrs1r=recn()
              else
                 wmess('Нет совпадений',2)
              endif
           endif
      case lastkey()=K_F5 // Очистить
           if empty(dopr)
              docguider=''
              netrepl('docguid','docguider')
           else
            outlog(__FILE__,__LINE__,'!empty(dopr)')
           endif
   endc
endd
nuse()
retu .t.
