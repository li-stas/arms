#include "common.ch"
#include "inkey.ch"
* Возврат ТТН на склад
clea
netuse('czg')
netuse('rs1')
netuse('soper')
netuse('kln')
netuse('s_tag')
netuse('moddoc')
netuse('mdall')
store 0 to ttnr
do while .t.
   clea
   @ 2,1 say 'ТТН' get ttnr pict '999999'
   read
   if lastkey()=K_ESC
      exit
   endif
   if lastkey()=K_ENTER
      sele rs1
      if netseek('t1','ttnr')
         vor=vo
         kopr=kop
         kplr=kpl
         if kopr#126
            wmess('Не 126 КОП',3)
            loop
         else
            if kplr=20034
               wmess('126 КОП клиент 20034',3)
               loop
            endif
         endif
         kop_r=mod(kopr,100)
         nopr=getfield('t1','0,1,vor,kop_r','soper','nop')
         sdvr=sdv
         nplr=getfield('t1','kplr','kln','nkl')
         kgpr=kgp
         ngpr=getfield('t1','kgpr','kln','nkl')
         ktasr=ktas
         nktasr=getfield('t1','ktasr','s_tag','fio')
         ktar=kta
         nktar=getfield('t1','ktar','s_tag','fio')
         kecsr=kecs
         nkecsr=getfield('t1','kecsr','s_tag','fio')
         dvzttnr=dvzttn
         mrshr=mrsh
         dopr=dop
         if fieldpos('tvzttn')#0
            tvzttnr=tvzttn
         else
            tvzttnr=space(8)
         endif
         @ 2,15 say 'Сумма'+' '+str(sdvr,12,2)
         @ 3,1 say 'КОП        '+' '+str(kopr,3)+' '+subs(nopr,1,20)+' '+'Дата возврата'+' '+dtoc(dvzttnr)+' '+tvzttnr
         @ 4,1 say 'Отгрузка   '+' '+dtoc(dopr)+' '+'Маршрут'+' '+str(mrshr,6)
         @ 5,1 say 'Плательщик '+' '+str(kplr,7)+' '+nplr
         @ 6,1 say 'Получатель '+' '+str(kgpr,7)+' '+ngpr
         @ 7,1 say 'Супервайзер'+' '+str(ktasr,4)+' '+nktasr
         @ 8,1 say 'Агент      '+' '+str(ktar,4)+' '+nktar
         @ 9,1 say 'Экспедитор '+' '+str(kecsr,4)+' '+nkecsr
         mvzttnr=1
         @ 22,40 prom 'Подтверждение возврата'
         @ 22,col()+1 prom 'Отмена'
         menu to mzttnr
         if lastkey()=K_ESC.or.mvzttnr#1
            ttnr=0
            loop
         else
            sele rs1
            netrepl('dvzttn','date()')
            if fieldpos('tvzttn')#0
               netrepl('tvzttn','time()')
            endif
            if fieldpos('ktovzttn')#0
               netrepl('ktovzttn','gnKto')
            endif
            sele czg
            if mrshr#0
               if netseek('t1','mrshr,gnEnt,gnSk,ttnr')
                  netrepl('dvzttn','date()')
               endif
            endif
            sele moddoc
            if netseek('t1','0,0,ttnr,gnSk,0')
               if fieldpos('dtmodvz')#0
                  netrepl('dtmodvz,tmmodvz','date(),str(seconds(),8,2)')
               endif
            endif
            ttnr=0
            loop
         endif
      else
         wmess('ТТН '+str(ttnr,6)+' Не найдена',2)
         ttnr=0
         loop
      endif
   endif
endd
nuse()

************************
func shvzttn()
* Просмотр возврата TTN
************************
clea
store 0 to ttn_r,ndtr,kpv_r,kta_r,prz_r,sm0_r,ekop_r
store bom(gdTd) to dt1r
store gdTd to dt2r
netuse('dokk')
netuse('kln')
netuse('s_tag')
netuse('speng')
netuse('rs1')
if select('sl')=0
   sele 0
   use _slct alias sl excl
endif
sele sl
zap
sele rs1
go top
rcrs1r=recn()
forr='.t.'
for_r='.t.'
fldnomr=1
do while .t.
   foot('Space,F3,F4,F5,F6','Отбор,Фильтр,Просмотр,Печать,Протокол')
   sele rs1
   go rcrs1r
   rcrs1r=slce('rs1',1,0,18,,"e:ttn h:'ТТН' c:n(6) e:prz h:'П' c:n(1) e:kop h:'КОП' c:n(3) e:sdv h:'СУММА' c:n(12,2) e:dvp h:'ВЫП' c:d(10) e:dfp h:'ФИНП' c:d(10) e:dop h:'ОТГР' c:d(10) e:dvzttn h:'Возвр' c:d(10) e:kpv h:'ГР/ПОЛ' c:n(7) e:getfield('t1','rs1->kpv','kln','nkl') h:'НаиГ' c:c(20) e:kta h:'КОДА' c:n(4) e:getfield('t1','rs1->kta','s_tag','fio') h:'НаиА' c:c(15)",,1,1,,forr,,'Возвраты ТТН')
   if lastkey()=K_ESC
      exit
   endif
   go rcrs1r
   ttnr=ttn
   do case
      case lastkey()=19 // Left
           fldnomr=fldnomr-1
           if fldnomr=0
              fldnomr=1
           endif
      case lastkey()=4 // Right
           fldnomr=fldnomr+1
      case lastkey()=K_F3 // Фильтр
            clttncr=setcolor('gr+/b,n/bg')
            wttncr=wopen(9,10,19,70)
            wbox(1)
            store 0 to ttn_r,ndtr,kpv_r,kta_r,prz_r,sm0_r,ekop_r
            store bom(gdTd) to dt1r
            store gdTd to dt2r
            @ 0,1 say 'ТТН        ' get ttn_r pict '999999'
            @ 1,1 say 'Подтвержден' get prz_r pict '9'
            @ 1,col()+1 say '0-Все;1-НП;2-П'
            @ 2,1 say 'Дата       ' get ndtr pict '9'
            @ 3,1 say '0-DVP;1-DFP;2-DOP;3-DVZTTN'
            @ 4,1 say 'Период' get dt1r
            @ 4,col()+1 get dt2r
            @ 5,1 say 'Получатель' get kpv_r pict '9999999'
            @ 6,1 say 'Агент     ' get kta_r pict '9999'
            @ 7,1 say 'Сумма=0   ' get sm0_r pict '9'
            @ 8,1 say 'Кроме 170 ' get ekop_r pict '9'
            read
            wclose(wttncr)
            setcolor(clttncr)
            if lastkey()=K_ESC
               forr=for_r
               sele rs1
               go top
               rcrs1r=recn()
            endif
            if lastkey()=K_ENTER
               if ttn_r#0
                  sele rs1
                  if netseek('t1','ttn_r')
                     rcrs1r=recn()
                  else
                     wmess('Не найдена',2)
                  endif
               else
                  forr=for_r
                  if prz_r#0
                     if prz_r=1
                        forr=forr+'.and.prz=0'
                     else
                        forr=forr+'.and.prz=1'
                     endif
                  endif
                  if kpv_r#0
                     forr=forr+'.and.kpv=kpv_r'
                  endif
                  if kta_r#0
                     forr=forr+'.and.kta=kta_r'
                  endif
                  if sm0_r#0
                     forr=forr+'.and.sdv=0'
                  endif
                  if ekop_r#0
                     forr=forr+'.and.kop#170'
                  endif
                  do case
                     case ndtr=0
                          forr=forr+'.and.dvp>=dt1r.and.dvp<=dt2r'
                     case ndtr=1
                          forr=forr+'.and.dfp>=dt1r.and.dfp<=dt2r'
                     case ndtr=2
                          forr=forr+'.and.dop>=dt1r.and.dop<=dt2r'
                     case ndtr=3
                          forr=forr+'.and.dvzttn>=dt1r.and.dvzttn<=dt2r'
                  endc
                  sele rs1
                  go top
                  rcrs1r=recn()
               endif
            endif
      case lastkey()=K_F4 // Просмотр
            clshr=setcolor('gr+/b,n/bg')
            wshr=wopen(1,0,24,79)
            wbox(1)
            sele rs1
            @ 0,1 say 'ТТН'+' '+str(rs1->ttn,6)+' КОП '+str(rs1->kop,3)+'('+str(rs1->kopi,3)+')'+' Сумма'+str(rs1->sdv,12,2)+' Маршрут '+str(rs1->mrsh,6)
            @ 1,1 say 'Плательщик'+' '+str(rs1->kpl,7)+' '+alltrim(getfield('t1','rs1->kpl','kln','nkl'))+' XXX '+str(rs1->nkkl,7)+' '+alltrim(getfield('t1','rs1->nkkl','kln','nkl'))
            @ 2,1 say 'Получатель'+' '+str(rs1->kgp,7)+' '+alltrim(getfield('t1','rs1->kgp','kln','nkl'))+' XXX '+str(rs1->kpv,7)+' '+alltrim(getfield('t1','rs1->kpv','kln','nkl'))
            @ 3,1 say 'Супервайзер'+' '+str(rs1->ktas,4)+' '+alltrim(getfield('t1','rs1->ktas','s_tag','fio'))+' Агент '+str(rs1->kta,4)+' '+alltrim(getfield('t1','rs1->kta','s_tag','fio'))
            @ 4,1 say 'Создан'+' '+dtoc(rs1->ddc)+' '+rs1->tdc+' '+getfield('t1','rs1->kto','speng','fio')
            @ 5,1 say 'Выписан'+' '+dtoc(rs1->dvp)
            @ 6,1 say 'Фин подтв'+' '+dtoc(rs1->dfp)+' '+rs1->tfp+' '+getfield('t1','rs1->ktofp','speng','fio')
            @ 7,1 say 'Счет-Фактура'+' '+dtoc(rs1->dsp)+' '+rs1->tsp+' '+getfield('t1','rs1->ktosp','speng','fio')
            @ 8,1 say 'Отгружен'+' '+dtoc(rs1->dop)+' '+rs1->top+' Первично '+dtoc(rs1->dtot)
            if rs1->prz=1
               ktootr=getfield('t1','0,0,rs1->kpl,rs1->ttn,0,gnSk','dokk','kg')
               @ 9,1 say 'Подтвержден'+' '+dtoc(rs1->dot)+' '+getfield('t1','ktootr','speng','fio')
            endif
            @ 10,1 say 'Возврат'+' '+dtoc(rs1->dvzttn)+' '+rs1->tvzttn+' '+getfield('t1','rs1->ktovzttn','speng','fio')
            inkey(0)
            wclose(wshr)
            setcolor(clshr)
      case lastkey()=K_F5 // Печать
           prnvz()
      case lastkey()=K_F6 // Протокол
           rcrs1_r=rcrs1r
           for_rr=forr
           rs2prot()
           rcrs1r=rcrs1_r
           forr=for_rr
   endc
endd
nuse()
if select('sl')#0
   sele sl
   use
endif
retu .t.

*************
func prnvz()
*************
aprntdr=1
aprntd={'LPT1','LPT2','LPT3','Файл'}
aprntdr=alert('Печать',aprntd)
do case
   case lastkey()=K_ESC
        retu .t.
   case aprntdr=1
        set print to lpt1
   case aprntdr=2
        set print to lpt2
   case aprntdr=3
        set print to lpt3
   case aprntdr=4
        set print to rsvz.txt
endc

aotbr=1
aotb={'Все','Отобранные'}
aotbr=alert('Печатать',aotb)
if lastkey()=K_ESC
   retu .t.
endif
set cons off
set prin on
if aprntdr=1.or.aprntdr=4
   if empty(gcPrn).or.aprntdr=4
      ?chr(27)+chr(80)+chr(15)
   else
      ? chr(27)+'E'+chr(27)+'&l1h26a0O'+chr(27)+chr(27)+'(3R'+chr(27)+'(s0p20.00h0s1b4102T'+chr(27)  // Книжная А4
   endif
else
      ? chr(27)+'E'+chr(27)+'&l1h26a0O'+chr(27)+chr(27)+'(3R'+chr(27)+'(s0p20.00h0s1b4102T'+chr(27)  // Книжная А4
endif
lstr=1
rwvzr=1
rwendr=62
set cent off
vzsh()
if aotbr=1
   sele rs1
   go top
   do while !eof()
      if !(&forr)
         skip
         loop
      endif
      sele rs1
      ?' '+str(ttn,6)+' '+str(kop,3)+' '+str(sdv,10,2)+' '+dtoc(ddc)+' '+dtoc(dvp)+' '+dtoc(dfp)+' '+dtoc(dop)+' '+dtoc(dvzttn)+' '+subs(getfield('t1','rs1->kta','s_tag','fio'),1,15)+' '+subs(getfield('t1','rs1->kpv','kln','nkl'),1,40)
      rwvz()
      sele rs1
      skip
   endd
else
   sele sl
   go top
   do while !eof()
      rcr=val(kod)
      sele rs1
      go rcr
      ?' '+str(ttn,6)+' '+str(kop,3)+' '+str(sdv,10,2)+' '+dtoc(ddc)+' '+dtoc(dvp)+' '+dtoc(dfp)+' '+dtoc(dop)+' '+dtoc(dvzttn)+' '+subs(getfield('t1','rs1->kta','s_tag','fio'),1,15)+' '+subs(getfield('t1','rs1->kpv','kln','nkl'),1,40)
      rwvz()
      sele sl
      skip
   endd
endif
eject
set prin off
set cons on
set print to
set cent on
retu .t.

func vzsh()
if lstr=1
   ?'Ведомость возврвщенных документов на '+dtoc(date())+' '+time()
   ?'по '+alltrim(gcNskl)
*   ?hdttnr
   rwvzr=8
else
   rwvzr=5
endif
?'                                                                          Лист '+str(lstr,2)
?'┌──────┬───┬──────────┬────────┬────────┬────────┬────────┬────────┬───────────────┬─────────────────────────────────────────┐'
?'│ ТТН  │КОП│  СУММА   │ ДатаС  │ ДатаВ  │ ДатаФ  │ ДатаО  │ ДатаВ  │    Агент      │            Грузополучатель              │'
?'├──────┼───┼──────────┼────────┼────────┼────────┼────────┼────────┼───────────────┼─────────────────────────────────────────┤'

func rwvz()
rwvzr++
if rwvzr=rwendr
   eject
   lstr++
   rwvzr=1
   vzsh()
endif
retu .t.
