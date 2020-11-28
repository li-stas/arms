#include "common.ch"
#include "inkey.ch"

setcolor('g/n,n/g')

clea
sel=select()
lstbcolr=space(14)
lstbrowr=1
lstcintr=space(17)
lstrintr=3

*if gnRmag#1
*   wmess('Этот склад не печатает ценники',2)
*   retu
*endif
netuse('pr1')
netuse('pr2')
netuse('GrpE')
netuse('tov')
netuse('kln')
netuse('speng')
netuse('soper')
netuse('tcen')
go top
do while !eof()
   sele tcen
   if alltrim(zen)='opt'
      skip
      loop
   endif
   if ent#gnEnt
      skip
      loop
   endif
   if zen='cenpr'
      czenmr1=alltrim(zen)
   endif
   if zen='c01'
      czenmr2=alltrim(zen)
   endif
   if zen='c04'
      czenmr3=alltrim(zen)
   else
      czenmr3=''
   endif
   skip
enddo
nuse('tcen')

if select('sl')=0
   sele 0
   use _slct alias sl excl
   zap
else
   sele sl
   use
   use _slct alias sl excl
   zap
endif

store 0 to ndr,ndkpsr,ndprzr
store '' to skndr
store '.t.' to forndr,fornd_r
store ctod('') to nddt1r,nddt2r

do while .t.
   clea
   @ 0,1 say 'Приход N'
   @ 0,65 say gcNskl
   @ 0,32 say 'Договор '+space(9)+' от '
   @ 1,1 say  'Дата       '
   @ 2,1 say  'Операция   '
   @ 3,1 say  'Поставщик  '
   @ 0,10 get ndr pict'999999' when mndw() valid mndv()
   read
   if lastkey()=K_ESC
      set key K_SPACE to
      exit
   endif
   @ 24,0 clea
   sele pr1
   netseek('t1','ndr')
   mnr=mn
   sklr=skl
   nnzr=nnz
   dnzr=dnz
   dprr=dpr
   if empty(dprr)
      dprr=dvp
   endif
   @ 0,40 say nnzr
   @ 0,53 say dtoc(dnzr)
   dvpr=dvp
   @ 1,13 say dtoc(dvpr)
   vor=vo
   kopr=kop
   qr=mod(kopr,100)
   nopr=getfield('t1','1,1,vor,qr','soper','nop')
   @ 2,13 say  str(kopr,3)+' '+nopr
   kpsr=kps
   nkpsr=getfield('t1','kpsr','kln','nkl')
   @ 3,13 say str(kpsr,7)+' '+nkpsr
   sele pr2
   netseek('t1','mnr')
   do while .t.
      foot('SPACE,F5','Отбор,Печать')
      rcpr2r=slcf('pr2',7,1,12,,"e:ktl h:'Код' c:n(9) e:getfield('t1','sklr,pr2->ktl','tov','nat') h:'Наименование' c:c(30) e:getfield('t1','sklr,pr2->ktl','tov','nei') h:'Ед' c:c(3) e:kf h:'Количество' c:n(9,3) e:getfield('t1','sklr,pr2->ktl','tov','c01') h:'Цена розн.' c:n(8,3) e:sr h:'Сумма' c:n(8,2)",,1,1,'mn=mnr')
      sele pr2
      go rcpr2r
      do case
         case lastkey()=K_ESC
              mnr=0
              exit
         case lastkey()=K_F5 // Печать
              prnetic()
      endc
   endd
endd
nuse()
sele sl
use
select(sel)
return

func mndw()
skndr=savesetkey()
set key K_SPACE to mnd
retu .t.

func mndv()
set key K_SPACE to
restsetkey(skndr)
retu .t.

func mnd()
local getList:={}
do while .t.
   sele pr1
   go top
   foot('F3','Фильтр')
   rcpr1r=slcf('pr1',1,,18,,"e:nd h:'N док.' c:n(6) e:nnz h:' ТТН  ' c:c(6) e:prz h:'П' c:n(1) e:dvp h:'Дата В' c:d(10) e:dpr h:'Дата П' c:d(10) e:sdv h:'Сумма' c:n(10,2) e:getfield('t1','pr1->kps','kln','nkl') h:'Поставщик' c:c(16) e:getfield('t1','pr1->kto','speng','fio') h:'Товаровед' c:c(11)",,,,,forndr)
   if lastkey()=K_F3
      clndr=setcolor('gr+/b,n/bg')
      wndr=wopen(10,20,20,60)
      wbox(1)
      @ 0,1 say 'Период    ' get nddt1r
      @ 0,col()+1 get nddt2r
      @ 1,1 say 'Признак   ' get ndprzr pict '9'
      @ 1,col()+1 say ' 2 - Все'
      @ 2,1 say 'Поставщик' get ndkpsr pict '9999999'
      read
      if !empty(nddt1r)
         if empty(nddt2r)
            forndr=fornd_r+'.and.dvp=nddt1r'
         else
            forndr=fornd_r+'.and.dvp>=nddt1r.and.dvp<=nddt2r'
         endif
      endif
      if ndprzr#2
         forndr=forndr+'.and.prz=ndprzr'
      endif
      if ndkpsr#0
         forndr=forndr+'.and.kps=ndkpsr'
      endif
      wclose(wndr)
      setcolor(clndr)
   else
      exit
   endif
endd
sele pr1
go rcpr1r
ndr=nd
set key K_SPACE to
retu .t.

func prnetic()
store 1 to mlstr,mbcolr,mbrowr,mnomr
if !file('cennik.dbf')
   crtt('cennik','f:mntov c:n(7) f:nat c:c(50) f:nge c:c(20) f:zen1 c:n(15,3) f:zen2 c:n(15,3) f:zen3 c:n(15,3) f:nei c:c(5) f:mn c:n(6) f:dvp c:d(10)')
else
   erase cennik.dbf
   crtt('cennik','f:mntov c:n(7) f:nat c:c(50) f:nge c:c(20) f:zen1 c:n(15,3) f:zen2 c:n(15,3) f:zen3 c:n(15,3) f:nei c:c(5) f:mn c:n(6) f:dvp c:d(10)')
endif
sele 0
use cennik
sele sl
go top
do while !eof()
   sele sl
   rcn_r=val(kod)
   sele pr2
   go rcn_r
 //   ktlmr=getfield('t1','sklr,pr2->ktl','tov','mntov')
   sele tov
   if netseek('t1','sklr,pr2->ktl')
      mntovr=mntov
      natr=nat
      neir=nei
      zenr=&czenmr1
      zenr1=&czenmr2
      if !empty(czenmr3)
         zenr3=&czenmr3
      else
         zenr3=0
      endif
      kger=kge
      nger=getfield('t1','kger','GrpE','nge')
      nger=alltrim(nger)
  //      natr=nger+' '+natr
  //      nat_r=natr
      sele cennik
      locate for mntov=mntovr
      if !foun()
         appe blank
         repl mntov with mntovr
         repl nat with natr
         repl nge with nger
         repl zen1 with zenr*1.2
         repl zen2 with zenr1
         repl zen3 with zenr3
         repl nei  with neir
         repl mn  with mnr
         repl dvp  with dvpr
      endif
   endif
   sele sl
   skip
endd
sele cennik
use
retu .t.
