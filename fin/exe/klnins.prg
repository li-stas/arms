#include "inkey.ch"

*#define FUN_USL
para p1, lOnlyDopUsl, lReadDopUsl
corr=p1
if p1=nil
   corr=0
endif

IF lOnlyDopUsl=NIL
  lOnlyDopUsl:=.F.
ENDIF
IF lReadDopUsl=NIL
  lReadDopUsl:=.F.
ENDIF

save scre to scklnins
clklnins=setcolor('gr+/b,n/w')
clea
@ 0,0,MAXROW()-1,79 box frame
set key -2 to licc()

*setkey(-34, { || KlnNac(M->kklr, .F.) })
*setkey(-4, { || KlnNac(M->kklr) })

*foot('F3, F5','Лицензии, Наценки')
foot('F3','Лицензии')

netuse('KlnNac')
netuse('mkeep')
netuse('mkeepE')

netuse('kobl')
netuse('kfs')
netuse('opfh')
netuse('knasp')
netuse('kgos')
netuse('kulc')
netuse('krn')
netuse('banks')
netuse('lic')
netuse('lice')
netuse('klnlic')
netuse('atvm')
netuse('atvme')
netuse('kgpcat')
sele kln
if corr=1
   prir:=pri
   kklr=kkl
   kkl1r=kkl1
   kklpr:=kklp
   nklpr:=getfield('t1','kklpr','kln','nkl')
*   nklr=upper(nkl)
   nklr=nkl
   nklr=alltrim(nklr)
*   nkler=upper(nkle)
   nkler=nkle
   nklsr=lower(nkls)
   dtbsvr=dtbsv
   dtesvr=dtesv
   adrr=adr
   tlfr=tlf
   kb1r=kb1
   nmfo1r=getfield('t1','kb1r','banks','otb')
   kb2r=kb2
   nmfo2r=getfield('t1','kb2r','banks','otb')
   ns1r=ns1
   ns2r=ns2
   ns1ndsr=ns1nds
   ns2ndsr=ns2nds
   nnr=nn
   cnnr=cnn
   rstr=rst
   nsvr=nsv
   koblr=kobl
   noblr=getfield('t1','koblr','kobl','nobl')
   kfsr=kfs
   nfsr=getfield('t1','kfsr','kfs','nfs')
   if kkl1r#0
      opfhr=opfh
   else
      opfhr=0
   endif
   nopfhr=getfield('t1','opfhr','opfh','nopfh')
   nsopfhr=getfield('t1','opfhr','opfh','nsopfh')
   knaspr=knasp
   nnaspr=getfield('t1','knaspr','knasp','nnasp')
   kgosr=kgos
   ngosr=getfield('t1','kgosr','kgos','ngos')
   kulcr=kulc
   nulcr=getfield('t1','kulcr','kulc','nulc')
   krnr=krn
   nrnr=getfield('t1','krnr','krn','nrn')
   skidr=skid
   nklprnr=nklprn
   vmrshr=vmrsh
   nvmrshr=getfield('t1','vmrshr','atvm','nvmrsh')
   klnnpvr=klnnpv
   kgpcatr=kgpcat
   nkgpcatr=getfield('t1','kgpcatr','kgpcat','nkgpcat')
   tabnor=tabno
   grndsr=grnds
   psser=psse
   psnr=psn
   psdtvr=psdtv
   pskvr=pskv
   dtbsvr=dtbsv
   dtesvr=dtesv
   avtokklr=avtokkl
   GpsLatr:= GpsLat
   GpsLonr:= GpsLon
   EMailr:= EMail

else
   store 0 to kklpr,kklr,kkl1r,nnr,rstr,kobr,kfsr,opfhr,knaspr,kgosr,kulcr,krnr,;
              koblr,skidr,vmrshr,prir,kgpcatr,tabnor,psnr,grndsr,avtokklr
   store space(30) to nmfo1r,nmfo2r,nopfhr,klnnpvr
   store space(80) to adrr
   store space(120) to nklpr,nklprnr
   store space(120) to nklr,pskvr
   store space(110) to nkler
   store space(20) to nklsr,nsvr,ns1r,ns2r,ns1ndsr,ns2ndsr,noblr,nfsr,nnaspr,ngosr,;
                      nulcr,nrnr,nvmrshr,nkgpcatr
   store space(10) to nklsr,tlfr,nsopfhr
   store space(50) to nopfhr
   kb1r=space(15)
   kb2r=space(15)
   cnnr=space(12)
   pser=space(2)
   store ctod('') to psdtvr,dtbsvr,dtesvr
   GpsLatr:= space(10)
   GpsLonr:= space(10)
   EMailr:= space(90)

endif

do while .t.
   @ 1,1 say 'Код 7 знаков'
   @ 3,26 say nklpr

   if corr=0
      @ 1,14 get kklr pict '9999999' valid kkl() //valid IIF(kkl(), (kklpr:=kklr,.T.), .F.) WHEN !lOnlyDopUsl
   else
      @ 1,14 say ' '+str(kklr,7)
   endif
   @ 1,16+8 say nklr
   if corr=1
      @ 2,1  SAY 'Код плательщика' get kklpr pict '9999999' valid kkl_p() WHEN !lOnlyDopUsl
   else
      @ 2,1  SAY 'Код плательщика' get kklpr pict '9999999'
   endif
   sele kln
   @ 2,col()+1 say 'Таб N' get tabnor pict '999999'
*   @ 2,col()+1 say 'Перевозчик  ' get avtokklr pict '9999999'
*   if kklr>=2000.and.kklr<3000
*   else
*   endif
   @ 3,1  say 'Код ОКП     '
   @ 3,14 get kkl1r pict '9999999999'  WHEN !lOnlyDopUsl valid kkl1()
*   @ 2, 14+8+3 say  "Приоритет" GET  prir PICT "9" WHEN !lOnlyDopUsl
*   @ 2, 40 say  "Категория ГП" GET  kgpcatr PICT "99" valid kgpcat()
*   @ 2, 60 say  nkgpcatr

   @ 4,1  say 'Наим' get nkler  WHEN !lOnlyDopUsl pict '@S72'
   @ 5,1  say 'Наим.коротк.' get nklsr WHEN !lOnlyDopUsl
   @ 5, 12+20  say 'Телефон     ' get tlfr  WHEN !lOnlyDopUsl


   @ 6,1  say 'Адрес       ' get adrr  WHEN !lOnlyDopUsl pict '@S64'
   @ 7,30 say nmfo1r
   @ 7,1  say 'MФО1        ' get kb1r valid mfo1()  WHEN !lOnlyDopUsl
   @ 8,1  say 'Расч. счет1 ' get ns1r  WHEN !lOnlyDopUsl
   @ 8,col()+1  say 'Счет НДС1' get ns1ndsr  WHEN !lOnlyDopUsl
   @ 9,30 say nmfo2r
   @ 9,1  say 'MФО2        ' get kb2r valid mfo2()  WHEN !lOnlyDopUsl
   @ 10,1  say 'Расч. счет2 ' get ns2r              WHEN !lOnlyDopUsl
   @ 10,col()+1  say 'Счет НДС2' get ns2ndsr        WHEN !lOnlyDopUsl
   @ 11,1  say 'Налоговый N ' get nnr pict '999999999999'  WHEN !lOnlyDopUsl
   @ 11,col()+1  get cnnr
   @ 11,col()+1 say 'ДтНачСв' get dtbsvr
   @ 11,col()+1 say 'ДтОконч' get dtesvr
   @ 12,1 say 'Номер свидет' get nsvr                      WHEN !lOnlyDopUsl
   @ 12,col()+1 say 'Группа НДС' get grndsr pict '9'
//   @ 13,19 say nfsr
//   @ 13,1 say 'Фин.структ. ' get kfsr   pict '9999' valid kfs()  WHEN !lOnlyDopUsl
//   @ 14,19 say nopfhr
   @ 14,1 say 'Тип предпр. ' get opfhr  pict '9999' valid opfh()  WHEN !lOnlyDopUsl
   @ 14,19 say nopfhr PICT REPLICATE("X",20)
   @ 15,19 say ngosr
   @ 15,1 say 'Государство ' get kgosr  pict '9999' valid kgos()  WHEN !lOnlyDopUsl
   @ 16,19 say noblr
   @ 16,1 say 'Область     ' get koblr  pict '9999' valid kobl()   WHEN !lOnlyDopUsl
   @ 17,19 say nrnr
   @ 17,1 say 'Район       ' get krnr   pict '9999' valid krn()    WHEN !lOnlyDopUsl
   @ 18,19 say nnaspr
   @ 18,1 say 'Нас.пункт   ' get knaspr pict '9999' valid knasp()  WHEN !lOnlyDopUsl
   @ 19,19 say nulcr
   @ 19,1 say 'Улица       ' get kulcr  pict '9999' valid kulc()   WHEN !lOnlyDopUsl
   @ 20,1 say 'Расстояние  ' get rstr  pict '99999'                WHEN !lOnlyDopUsl
   @  row(), col()+1 say'Широта'  get GpsLatr pict '99.9999999' WHEN !lOnlyDopUsl
   @  row(), col()+1 say'Долгота' get GpsLonr pict '99.9999999' WHEN !lOnlyDopUsl
   @ 21,1 say subs(nklprnr,1,77)
   @ 22,1 say subs(nklprnr,78)
   @ 14,40 say 'Паспорт'
   @ 15,40 say 'Серия       ' get psser
   @ 16,40 say 'Номер       ' get psnr pict '999999'+iif(empty(psser),'999','')
   @ 17,40 say 'Дата выписки' get psdtvr
   @ 18,40 say 'Кем выписан ' get pskvr  pict '@S26'
   @ 19,40 say 'E-mail      ' get EMailr pict '@S26'

/*   if gnAdm=1
*      @ 21,1 say 'Разр.скидки ' get skidr  pict '9'                WHEN !lOnlyDopUsl
*      @ 21,col()+1 say '1-до зак/мин.;2-до % цены в GRPIZG'
*   endif
*   @ 22,1 say 'Рег.маршр.  ' get vmrshr pict '999' valid atvm()    WHEN !lOnlyDopUsl
*   @ MAXROW()-2,col()+1 say nvmrshr
*   #ifdef FUN_USL
*     Uslovia(lReadDopUsl)
*   #endif
*/
   read
//   nklr=upper(nklr)
   nklr=nklr
   nklsr=lower(nklsr)
   if lastkey()=K_ESC
      exit
   endif
   @ MAXROW()-2,60 prom 'Верно'
   @ MAXROW()-2,col()+1 prom 'Не верно'
   menu to vn
   if lastkey()=K_ESC
      exit
   endif
   nkler=alltrim(nkler)
   if !empty(nsopfhr)
      nklr=alltrim(nsopfhr)+' '+nkler
   else
      nklr=nkler
   endif
   if vn=1
      sele kln
      if corr=1
         netrepl('pri,nkle,kklp,kkl1,nkl,nkls,adr,tlf,kb1,kb2,ns1,ns2,nn,nsv,rst,kgos,kobl,krn,knasp,kulc,kfs,opfh,cnn,GpsLat,GpsLon,EMail',;
                 {prir,nkler,kklpr,kkl1r,nklr,nklsr,adrr,tlfr,kb1r,kb2r,ns1r,ns2r,nnr,nsvr,rstr,kgosr,koblr,krnr,knaspr,kulcr,kfsr,opfhr,cnnr,GpsLatr,GpsLonr,EMailr})
      endif
      if corr=0
         if !netseek('t1','kklr')
            netadd()
            netrepl('pri,nkle,kklp,kkl,kkl1,nkl,nkls,adr,tlf,kb1,kb2,ns1,ns2,nn,nsv,rst,kgos,kobl,krn,knasp,kulc,kfs,opfh,kto,cnn,GpsLat,GpsLon,EMail',;
                    'prir,nkler,kklpr,kklr,kkl1r,nklr,nklsr,adrr,tlfr,kb1r,kb2r,ns1r,ns2r,nnr,nsvr,rstr,kgosr,koblr,krnr,knaspr,kulcr,kfsr,opfhr,gnKto,cnnr,GpsLatr,GpsLonr,EMailr')
         endif
      endif

      netrepl('skid','skidr')
      if kkl#kklp
         netrepl('kkl1','0')
      endif
      #ifdef FUN_USL
        netrepl('Zat61_P,Zat61_Sum,Zat46_L,Zat46_P,Zat46_Sum,Pst_L,Tov_Oth,Dt_BEG,Dt_END,ChkNZen','Zat61_Pr,Zat61_Sumr,Zat46_Lr,Zat46_Pr,Zat46_Sumr,Pst_Lr,Tov_Othr,Dt_BEGr,Dt_ENDr,ChkNZenr')
        if fieldpos('tov_oth1')#0
           netrepl('tov_oth1','tov_oth1r')
        endif
      #endif

      if fieldpos('kto')#0
         netrepl('kto','gnKto')
      endif
      netrepl('grnds','grndsr')
      netrepl('dtbsv,dtesv','dtbsvr,dtesvr')
      if fieldpos('nklprn')#0
         nklprnr=alltrim(nopfhr)+' '+alltrim(nkler)
         netrepl('nklprn','nklprnr')
      endif
      if fieldpos('vmrsh')#0
         netrepl('vmrsh','vmrshr')
      endif
      if fieldpos('klnnpv')#0
         netrepl('klnnpv','klnnpvr')
      endif
      if fieldpos('kgpcat')#0
         netrepl('kgpcat','kgpcatr')
      endif
      if fieldpos('tabno')#0
         netrepl('tabno','tabnor')
      endif
      netrepl('psse,psn,psdtv,pskv,avtokkl','psser,psnr,psdtvr,pskvr,avtokklr')
      exit
   endif
   sele kln
endd
set key -2 to
*setkey(-34, NIL)
*setkey(-4,  NIL)
setcolor(clklnins)
rest scre from scklnins

stat func mfo1()
save scre to scmfo
foot('INS,DEL,F4','Добавить,Удалить,Коррекция')
sele banks
if empty(kb1r).or.!netseek('t1','kb1r')
   go top
   do while .t.
      kb1r=slcf('banks',,,,,"e:kob h:'Код' c:c(15) e:otb h:'Наименование' c:c(40)",'kob',,1,,,,'МФО')
      if lastkey()=K_ESC
         kb1r=space(15)
      endif
      sele banks
      netseek('t1','kb1r')
      nmfor=otb
      do case
         case lastkey()=K_ESC.or.lastkey()=13
              exit
         case lastkey()=22 // INS
              mfoins1()
         case lastkey()=7  // DEL
              netdel()
              skip -1
         case lastkey()=-3 // F4
              mfoins1(1)
      endc
   enddo
endif
rest scre from scmfo
sele banks
netseek('t1','kb1r')
nmfo1r=otb
@ 7,30 say nmfo1r
retu .t.

stat func mfo2()
save scre to scmfo
foot('INS,DEL,F4','Добавить,Удалить,Коррекция')
sele banks
if empty(kb2r).or.!netseek('t1','kb2r')
   go top
   do while .t.
      kb2r=slcf('banks',,,,,"e:kob h:'Код' c:c(15) e:otb h:'Наименование' c:c(40)",'kob',,1,,,,'МФО')
      if lastkey()=K_ESC
         kb2r=space(15)
      endif
      sele banks
      netseek('t1','kb2r')
      nmfor=otb
      do case
         case lastkey()=K_ESC.or.lastkey()=13
              exit
         case lastkey()=22 // INS
              mfoins2()
         case lastkey()=7  // DEL
              netdel()
              skip -1
         case lastkey()=-3 // F4
              mfoins2(1)
      endc
   enddo
endif
rest scre from scmfo
sele banks
netseek('t1','kb2r')
nmfo2r=otb
@ 9,30 say nmfo2r
retu .t.

stat func mfoins1(p1)
local getlist:={}
if p1=nil
   kb1r=space(15)
   nmfo1r=space(40)
endif
do while .t.
   if p1=nil
      @ 0,1 say 'МФО' get kb1r valid kb1()
   else
      @ 0,1 say 'МФО'+' '+kb1r
   endif
   @ 1,1 say 'Наименование' get nmfo1r
   read
   if lastkey()=K_ESC
      exit
   endif
   @ 2,40 prom 'Верно'
   @ 2,col()+1 prom 'Не верно'
   menu to vn
   if lastkey()=K_ESC
      exit
   endif
   if vn=1
      sele banks
      if p1=nil
         netadd()
         netrepl('kob,otb','kb1r,nmfo1r')
      else
         netrepl('otb','nmfo1r')
      endif
   endif
   exit
endd
wclose(wmfoins)
retu .t.

stat func mfoins2(p1)
local getlist:={}
wmfoins=nwopen(10,10,14,70,1,'gr+/b')
if p1=nil
   kb2r=space(15)
   nmfo2r=space(40)
endif
do while .t.
   if p1=nil
      @ 0,1 say 'МФО' get kb2r valid kb2()
   else
      @ 0,1 say 'МФО'+' '+kb2r
   endif
   @ 1,1 say 'Наименование' get nmfo2r
   read
   if lastkey()=K_ESC
      exit
   endif
   @ 2,40 prom 'Верно'
   @ 2,col()+1 prom 'Не верно'
   menu to vn
   if lastkey()=K_ESC
      exit
   endif
   if vn=1
      sele banks
      if p1=nil
         netadd()
         netrepl('kob,otb','kb2r,nmfo2r')
      else
         netrepl('otb','nmfo2r')
      endif
   endif
   exit
endd
wclose(wmfoins)
retu .t.

stat func kb1()
if netseek('t1','kb1r')
   wselect(0)
   save scre to scmess
   mess('Такой банк уже существует',1)
   rest scre from scmess
   wselect(wmfoins)
   retu .f.
endif
retu .t.

stat func kb2()
if netseek('t1','kb2r')
   wselect(0)
   save scre to scmess
   mess('Такой банк уже существует',1)
   rest scre from scmess
   wselect(wmfoins)
   retu .f.
endif
retu .t.

stat func kfs()
save scre to sckfs
foot('INS,DEL,F4','Добавить,Удалить,Коррекция')
sele kfs
if kfsr=0.or.!netseek('t1','kfsr')
   go top
   do while .t.
      kfsr=slcf('kfs',,,,,"e:kfs h:'Код' c:n(4) e:nfs h:'Наименование' c:c(20)",'kfs',,,,,,'Фин.структ.')
      netseek('t1','kfsr')
      nfsr=nfs
      do case
         case lastkey()=K_ESC.or.lastkey()=13
              exit
         case lastkey()=22
              kfsins()
         case lastkey()=7
              netdel()
              skip -1
         case lastkey()=-3
              kfsins(1)
      endc
   endd
endif
rest scre from sckfs
@ 13,19 say nfsr PICT REPLICATE("X",20)
retu .t.

stat func atvm()
save scre to sckfs
sele atvm
if vmrshr=0.or.!netseek('t1','vmrshr')
   go top
   do while .t.
      vmrshr=slcf('atvm',,,,,"e:vmrsh h:'Код' c:n(3) e:nvmrsh h:'Наименование' c:c(20)",'vmrsh',,,,,,'Рег.маршр.')
      netseek('t1','vmrshr')
      nvmrshr=nvmrsh
      do case
         case lastkey()=K_ESC
              exit
         case lastkey()=13
              sele atvme
              if netseek('t2','kklr')
                 if vmrshr#vmrsh
                    netrepl('vmrsh','vmrshr')
                 endif
              else
                 netadd()
                 netrepl('vmrsh,kkl','vmrshr,kklr')
              endif
              exit
      endc
   endd
else
   sele atvme
   if netseek('t2','kklr')
      if vmrshr#vmrsh
         netrepl('vmrsh','vmrshr')
      endif
   else
       netadd()
       netrepl('vmrsh,kkl','vmrshr,kklr')
   endif
endif
rest scre from sckfs
@ MAXROW()-2,18 say nvmrshr
retu .t.

stat func kfsins(p1)
local getlist:={}
wkfsins=nwopen(10,10,14,70,1,'gr+/b')
if p1=nil
   kfsr=0
   nkfsr=space(20)
endif
do while .t.
   if p1=nil
      @ 0,1 say 'Код' get kfsr pict '9999' valid kfsi()
   else
      @ 0,1 say 'Код'+' '+str(kfsr,4)
   endif
   @ 1,1 say 'Наименование' get nfsr
   read
   if lastkey()=K_ESC
      exit
   endif
   @ 2,40 prom 'Верно'
   @ 2,col()+1 prom 'Не верно'
   menu to vn
   if lastkey()=K_ESC
      exit
   endif
   if vn=1
      sele kfs
      if p1=nil
         netadd()
         netrepl('kfs,nfs','kfsr,nfsr')
      else
         netrepl('nfs','nfsr')
      endif
   endif
   exit
endd
wclose(wkfsins)
retu .t.

stat func kfsi()
if netseek('t1','kfsr')
   wselect(0)
   save scre to scmess
   mess('Такой код уже существует',1)
   rest scre from scmess
   wselect(wkfsins)
   retu .f.
endif
retu .t.

stat func opfh()
if kkl1r=0
   opfhr=0
   nopfhr=''
   nsopfhr=''
   retu .t.
endif
save scre to sckfs
foot('INS,DEL,F4','Добавить,Удалить,Коррекция')
sele opfh
if opfhr=0.or.!netseek('t1','opfhr')
   go top
   do while .t.
      opfhr=slcf('opfh',,,,,"e:opfh h:'Код' c:n(4) e:nopfh h:'Наименование' c:c(50) e:nsopfh h:'Абб' c:c(10)",'opfh',,,,,,'Тип предпр.')
      netseek('t1','opfhr')
      nopfhr=nopfh
      nsopfhr=nsopfh
      do case
         case lastkey()=K_ESC.or.lastkey()=13
              exit
         case lastkey()=22
              opfhins()
         case lastkey()=7
              netdel()
              skip -1
         case lastkey()=-3
              opfhins(1)
      endc
   endd
else
  nopfhr:=nopfh
  nsopfhr:=nsopfh
endif
rest scre from sckfs
@ 14,19 say nopfhr PICT REPLICATE("X",20)
retu .t.

stat func opfhins(p1)
local getlist:={}
wopfhins=nwopen(10,10,15,70,1,'gr+/b')
if p1=nil
   opfhr=0
   nopfhr=space(50)
   nsopfhr=space(10)
endif
do while .t.
   if p1=nil
      @ 0,1 say 'Код' get opfhr pict '9999' valid opfhi()
   else
      @ 0,1 say 'Код'+' '+str(opfhr,4)
   endif
   @ 1,1 say 'Наименование'
   @ 2,1 get nopfhr
   @ 3,1 say 'Аббревиатура' get nsopfhr
   read
   if lastkey()=K_ESC
      exit
   endif
   @ 3,40 prom 'Верно'
   @ 3,col()+1 prom 'Не верно'
   menu to vn
   if lastkey()=K_ESC
      exit
   endif
   if vn=1
      sele opfh
      if p1=nil
         netadd()
         netrepl('opfh,nopfh,nsopfh','opfhr,nopfhr,nsopfhr')
      else
         netrepl('nopfh,nsopfh','nopfhr,nsopfhr')
      endif
   endif
   exit
endd
wclose(wopfhins)
retu .t.

stat func opfhi()
if netseek('t1','opfhr')
   wselect(0)
   save scre to scmess
   mess('Такой код уже существует',1)
   rest scre from scmess
   wselect(wopfhins)
   retu .f.
endif
retu .t.

stat func kgos()
save scre to sckfs
foot('INS,DEL,F4','Добавить,Удалить,Коррекция')
sele kgos
if kgosr=0.or.!netseek('t1','kgosr')
   go top
   do while .t.
      kgosr=slcf('kgos',,,,,"e:kgos h:'Код' c:n(4) e:ngos h:'Наименование' c:c(20)",'kgos',,,,,,'Государства')
      netseek('t1','kgosr')
      ngosr=ngos
      do case
         case lastkey()=K_ESC.or.lastkey()=13
              exit
         case lastkey()=22
              gosins()
         case lastkey()=7
              netdel()
              skip -1
         case lastkey()=-3
              gosins(1)
      endc
   endd
endif
rest scre from sckfs
ngosr=getfield('t1','kgosr','kgos','ngos')
@ 15,19 say ngosr PICT REPLICATE("X",20)
retu .t.

stat func gosins(p1)
local getlist:={}
wopfhins=nwopen(10,10,14,70,1,'gr+/b')
if p1=nil
   kgosr=0
   ngosr=space(20)
endif
do while .t.
   if p1=nil
      @ 0,1 say 'Код' get kgosr pict '9999' valid gosi()
   else
      @ 0,1 say 'Код'+' '+str(kgosr,4)
   endif
   @ 1,1 say 'Наименование' get ngosr
   read
   if lastkey()=K_ESC
      exit
   endif
   @ 2,40 prom 'Верно'
   @ 2,col()+1 prom 'Не верно'
   menu to vn
   if lastkey()=K_ESC
      exit
   endif
   if vn=1
      sele kgos
      if p1=nil
         netadd()
         netrepl('kgos,ngos','kgosr,ngosr')
      else
         netrepl('ngos','ngosr')
      endif
   endif
   exit
endd
wclose(wopfhins)
retu .t.

stat func gosi()
if netseek('t1','kgosr')
   wselect(0)
   save scre to scmess
   mess('Такой код уже существует',1)
   rest scre from scmess
   wselect(wopfhins)
   retu .f.
endif
retu .t.


stat func kobl()
if kgosr=0
   save scre to scmess
   mess('Нет кода государства',2)
   rest scre from scmess
   retu .t.
endif
save scre to sckfs
foot('INS,DEL,F4','Добавить,Удалить,Коррекция')
sele kobl
if koblr=0.or.!netseek('t1','koblr')
   go top
   do while .t.
      koblr=slcf('kobl',,,,,"e:kobl h:'Код' c:n(4) e:nobl h:'Наименование' c:c(20) e:numobl h:'Номер' c:n(2)",'kobl',,,,'kgos=kgosr',,'Области')
      netseek('t1','koblr')
      noblr=nobl
      numoblr=numobl
      do case
         case lastkey()=K_ESC.or.lastkey()=13
              exit
         case lastkey()=22
              oblins()
         case lastkey()=7
              netdel()
              skip -1
         case lastkey()=-3
              oblins(1)
      endc
   enddo
endif
noblr=getfield('t1','koblr','kobl','nobl')
rest scre from sckfs
@ 16,19 say noblr PICT REPLICATE("X",20)
retu .t.

stat func oblins(p1)
local getlist:={}
wopfhins=nwopen(10,10,14,70,1,'gr+/b')
if p1=nil
   koblr=0
   noblr=space(20)
endif
do while .t.
   if p1=nil
      @ 0,1 say 'Код' get koblr pict '9999' valid obli()
   else
      @ 0,1 say 'Код'+' '+str(koblr,4)
   endif
   @ 1,1 say 'Наименование' get noblr
   @ 2,1 say 'Номер       ' get numoblr
   read
   if lastkey()=K_ESC
      exit
   endif
   @ 2,40 prom 'Верно'
   @ 2,col()+1 prom 'Не верно'
   menu to vn
   if lastkey()=K_ESC
      exit
   endif
   if vn=1
      sele kobl
      if p1=nil
         netadd()
         netrepl('kobl,nobl,kgos,numobl','koblr,noblr,kgosr,numoblr')
      else
         netrepl('nobl,numobl','noblr,numoblr')
      endif
   endif
   exit
endd
wclose(wopfhins)
retu .t.

stat func obli()
if netseek('t1','koblr')
   wselect(0)
   save scre to scmess
   mess('Такой код уже существует',1)
   rest scre from scmess
   wselect(wopfhins)
   retu .f.
endif
retu .t.

stat func krn()
if koblr=0
   save scre to scmess
   mess('Нет кода области',2)
   rest scre from scmess
   retu .t.
endif
save scre to sckfs
foot('INS,DEL,F4','Добавить,Удалить,Коррекция')
sele krn
if krnr=0.or.!netseek('t1','krnr')
   go top
   do while .t.
      krnr=slcf('krn',,,,,"e:krn h:'Код' c:n(4) e:nrn h:'Наименование' c:c(20)",'krn',,,,'kobl=koblr',,'Районы')
      netseek('t1','krnr')
      nrnr=nrn
      do case
         case lastkey()=K_ESC.or.lastkey()=13
              exit
         case lastkey()=22
              rnins()
         case lastkey()=7
              netdel()
              skip -1
         case lastkey()=-3
              rnins(1)
      endc
   enddo
endif
rest scre from sckfs
nrnr=getfield('t1','krnr','krn','nrn')
@ 17,19 say nrnr PICT REPLICATE("X",20)
retu .t.

stat func rnins(p1)
local getlist:={}
wopfhins=nwopen(10,10,14,70,1,'gr+/b')
if p1=nil
   rnr=0
   nrnr=space(20)
endif
do while .t.
   if p1=nil
      @ 0,1 say 'Код' get krnr pict '9999' valid rni()
   else
      @ 0,1 say 'Код'+' '+str(krnr,4)
   endif
   @ 1,1 say 'Наименование' get nrnr
   read
   if lastkey()=K_ESC
      exit
   endif
   @ 2,40 prom 'Верно'
   @ 2,col()+1 prom 'Не верно'
   menu to vn
   if lastkey()=K_ESC
      exit
   endif
   if vn=1
      sele krn
      if p1=nil
         netadd()
         netrepl('krn,nrn,kobl','krnr,nrnr,koblr')
      else
         netrepl('nrn','nrnr')
      endif
   endif
   exit
endd
wclose(wopfhins)
retu .t.

stat func rni()
if netseek('t1','krnr')//   netseek('t1','koblr')
   wselect(0)
   save scre to scmess
   mess('Такой код уже существует',1)
   rest scre from scmess
   wselect(wopfhins)
   retu .f.
endif
retu .t.

stat func knasp()
if krnr=0
   save scre to scmess
   mess('Нет кода района',2)
   rest scre from scmess
   retu .t.
endif
save scre to sckfs
foot('INS,DEL,F4','Добавить,Удалить,Коррекция')
sele knasp
if knaspr=0.or.!netseek('t1','knaspr')
   go top
   do while .t.
      knaspr=slcf('knasp',,,,,"e:knasp h:'Код' c:n(4) e:nnasp h:'Наименование' c:c(20) e:rasst h:'Расст.' c:n(4) e:problc h:'O' c:n(1) e:prrnc h:'P' c:n(1)",'knasp',,,,'krn=krnr',,'Нас.пункты')
      netseek('t1','knaspr')
      nnaspr=nnasp
      rasstr=rasst
      problcr=problc
      prrncr=prrnc
      do case
         case lastkey()=K_ESC.or.lastkey()=13
              exit
         case lastkey()=22
              naspins()
         case lastkey()=7.and.gnAdm=1
              netdel()
              skip -1
              if bof()
                 go top
              endif
         case lastkey()=-3
              naspins(1)
      endc
   enddo
endif
rest scre from sckfs
nnaspr=getfield('t1','knaspr','knasp','nnasp')
@ 18,19 say nnaspr
retu .t.

stat func naspins(p1)
local getlist:={}
wopfhins=nwopen(10,10,17,70,1,'gr+/b')
if p1=nil
   knaspr=0
   nnaspr=space(20)
   rasstr=0
endif
do while .t.
   if p1=nil
      @ 0,1 say 'Код' get knaspr pict '9999' valid naspi()
   else
      @ 0,1 say 'Код'+' '+str(knaspr,4)
   endif
   @ 1,1 say 'Наименование' get nnaspr
   @ 2,1 say 'Расстояние  ' get rasstr pict '9999'
   @ 3,1 say 'Обл. центр  ' get problcr pict '9'
   @ 4,1 say 'Райцентр    ' get prrncr pict '9'

   read
   if lastkey()=K_ESC
      exit
   endif
   @ 5,40 prom 'Верно'
   @ 5,col()+1 prom 'Не верно'
   menu to vn
   if lastkey()=K_ESC
      exit
   endif
   if vn=1
      sele knasp
      if p1=nil
         netadd()
         netrepl('knasp,nnasp,krn,rasst,problc,prrnc','knaspr,nnaspr,krnr,rasstr,problcr,prrncr')
      else
         netrepl('nnasp,rasst,problc,prrnc','nnaspr,rasstr,problcr,prrncr')
      endif
   endif
   exit
endd
wclose(wopfhins)
retu .t.

stat func naspi()
if netseek('t1','knaspr')
   wselect(0)
   save scre to scmess
   mess('Такой код уже существует',1)
   rest scre from scmess
   wselect(wopfhins)
   retu .f.
endif
retu .t.

stat func kulc()
if knaspr=0
   save scre to scmess
   mess('Нет кода нас.пункта',2)
   rest scre from scmess
   retu .t.
endif
save scre to sckfs
foot('INS,DEL,F4','Добавить,Удалить,Коррекция')
sele kulc
if kulcr=0.or.!netseek('t1','kulcr')
   go top
   do while .t.
      kulcr=slcf('kulc',,,,,"e:kulc h:'Код' c:n(4) e:nulc h:'Наименование' c:c(20)",'kulc',,,,'knasp=knaspr',,'Улицы')
      netseek('t1','kulcr')
      nulcr=nulc
      do case
         case lastkey()=K_ESC.or.lastkey()=13
              exit
         case lastkey()=22
              ulcins()
         case lastkey()=7
              netdel()
              skip -1
         case lastkey()=-3
              ulcins(1)
      endc
   enddo
endif
rest scre from sckfs
nulcr=getfield('t1','kulcr','kulc','nulc')
@ 19,19 say nulcr
retu .t.

stat func ulcins(p1)
local getlist:={}
wopfhins=nwopen(10,10,14,70,1,'gr+/b')
if p1=nil
   kulcr=0
   nulcr=space(20)
endif
do while .t.
   if p1=nil
      @ 0,1 say 'Код' get kulcr pict '9999' valid ulci()
   else
      @ 0,1 say 'Код'+' '+str(kulcr,4)
   endif
   @ 1,1 say 'Наименование' get nulcr
   read
   if lastkey()=K_ESC
      exit
   endif
   @ 2,40 prom 'Верно'
   @ 2,col()+1 prom 'Не верно'
   menu to vn
   if lastkey()=K_ESC
      exit
   endif
   if vn=1
      sele kulc
      if p1=nil
         netadd()
         netrepl('kulc,nulc,knasp','kulcr,nulcr,knaspr')
      else
         netrepl('nulc','nulcr')
      endif
   endif
   exit
endd
wclose(wopfhins)
retu .t.

stat func ulci()
if netseek('t1','kulcr')
   wselect(0)
   save scre to scmess
   mess('Такой код уже существует',1)
   rest scre from scmess
   wselect(wopfhins)
   retu .f.
endif
retu .t.

stat func kkl()
sele kln
if corr=0
   if netseek('t1','kklr') .or. kklr=0
      save scre to scmess
      mess('Такой код уже существует',1)
      rest scre from scmess
      retu .f.
   endif
endif
retu .t.

func kkl_p
LOCAL nRec
kkl_rrr=kklr
nRec:=kln->(RECNO())
sele kln
if kklpr=0
// *   wdoks:=wselect(0)
// *   wselect(0)
   kklpr=slct_kl(10,1,12)
// *   wselect(wdoks)
//  *   wselect(wdokk)
endif
// *if kklpr=0
// *   kln->(DBGOTO(nRec))
// *   return.f.
// *endif
if netseek('t1','kklpr')
   nklpr=nkl
else
   kklpr=0
   kln->(DBGOTO(nRec))
// *   return.f.
endif
@ 3,26 say nklpr
kln->(DBGOTO(nRec))
kklr=kkl_rrr
retu .t.

func kgpcat()
sele kgpcat
if kgpcatr#0
   if !netseek('t1','kgpcatr')
      kgpcatr=0
      nkgpcatr=space(20)
   else
      nkgpcatr=nkgpcat
   endif
endif
if kgpcatr=0
   go top
   kgpcatr=slcf('kgpcat',,,,,"e:kgpcat h:'Код' c:n(2) e:nkgpcat h:'Наименование' c:c(20)",'kgpcat',,,,,,'Категории ГП')
   nkgpcatr=getfield('t1','kgpcatr','kgpcat','nkgpcat')
endif
if !empty(nkgpcatr)
   @ 2,60 say nkgpcatr
else
   @ 2,60 say space(20)
endif
retu .t.

func kkl1()
if kkl1r#0
   kkl_rr=getfield('t5','kkl1r','kln','kkl')
   if kkl_rr#0.and.kkl_rr#kklr
      wmess('Плательщик '+str(kkl_rr,7),0)
      kkl1r=0
      retu .f.
   endif
endif
retu .t.
