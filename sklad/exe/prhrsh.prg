setcolor('g/n,n/g')
fclr=setcolor()
clear
store 0 to mrshr,mrshNppr,prvzznr

przn=0    // Признак нового документа
corsh=0   // Признак коррекции шапки
pptr=0    // Признак привязанной тары
tarar=1   // Признак возвратной тары
prinstr=0 // Признак "запись добавлена в TOV,TOVD,CTOV"
mrshNppr=0
mrshr=0
pr49r=0
store 0 to onofr,opbzenr,opxzenr,;
           otcenpr,otcenbr,otcenxr,;
           odecpr,odecbr,odecxr,prdecr,prc177r,mntov177r

*fnlr=0   // Признак закрытия месяца
*if file(gcpath_t+"final.dbf")
  //  fnlr=1
*endif
Nppr=0   // Регистрационный номер протокола
prNppr=0 // Код действия регистрируемого в протоколе
store date() to dNpp
store space(8) to tNpp

  //Формат А5 портрет пика сжатый
  //высота 43
  //ширина 95

str_lst=43

  //Инициализация SOPER
store 0 to d0k1r,kopr,koppr,qr,ndsr,pndsr,grtcenr,tcenr,ptcenr,xndsr,xtcenr,pxzenr,;
           skar,sklar,msklar,zcr,prnnr,ttor,vpr,autor,okklr,okplr,pbzenr,rtcenr,nofr
store '' to cuchr,cotpr,cdopr,cxotpr
vur=gnVu
vor=gnVo
store 0 to gnSkt,gnSklt,gnMsklt // Х-ки назн.по SOPER

store space(40) to NOPr
store '' to nvur,nvor,nopr,nndsr,npndsr,ntcenr,nptcenr,nsklar,;
            nokklr,nrtcenr,nttor,nxtcenr
store '' to coptr,cboptr,croptr,cxoptr
store 0 to optr,boptr,roptr,xoptr
for i=1 to 20
    if i<10
       ir=str(i,1)
    else
       ir=str(i,2)
    endif
    cdszr='dsz'+ir+'r'
    cddbr='ddb'+ir+'r'
    cdkrr='dkr'+ir+'r'
    cprzr='prz'+ir+'r'
    &cdszr=0
    &cddbr=0
    &cdkrr=0
    &cprzr=space(6)
next

if !netuse('kspovo')
   nuse()
   wmess('Не удалось открыть KSPOVO',3)
   retu
endif
if !netuse('soper')
   nuse()
   wmess('Не удалось открыть SOPER',3)
   retu
endif
if !netseek('t1','gnD0k1,gnVu,gnVo').and.gnVo#0
   wmess('Нет операций для этого режима',3)
   nuse()
   retu
endif
  //Инициализация S_TAG
  store 0 to ktar,kecsr
if !netuse('s_tag')
   nuse()
   wmess('Не удалось открыть S_TAG',3)
   retu
endif
if !netuse('stagm')
   nuse()
   wmess('Не удалось открыть STAGM',3)
   retu
endif
  //Инициализация CZG
if !netuse('czg')
   nuse()
   wmess('Не удалось открыть CZG',3)
   retu
endif
  //Инициализация CMRSH
if !netuse('cmrsh')
   nuse()
   wmess('Не удалось открыть CMRSH',3)
   retu
endif
  //Инициализация SGRP
  store 0 to kgrr,otr,kgrsr,markr,licr,grpr
  store space(20) to ngrr,ngrsr,nalr
if !netuse('sgrp')
   nuse()
   wmess('Не удалось открыть SGRP',3)
   retu
endif
netuse('atvm')
netuse('atvme')
if gnCtov=1
     //Инициализация CGRP
     store 0 to kgrr,otr,kgrsr,markr,licr,grpr,tgrpr
     store space(20) to ngrr,ngrsr,nalr
   if !netuse('cgrp')
      nuse()
      wmess('Не удалось открыть CGRP',3)
      retu
   endif
   if !netuse('crosid')
      nuse()
      wmess('Не удалось открыть CROSID',3)
      retu
   endif

endif
  //Инициализация grpizg
*if !netuse('grpizg')
  //  nuse()
  //  wmess('Не удалось открыть GRPIZG',3)
  //  retu
*endif

  //Инициализация fop
if !netuse('fop')
   nuse()
   wmess('Не удалось открыть FOP',3)
   retu
endif
fopr=0
nfopr=space(20)
if !netUse('dokk')
   nuse()
   retu
endif
if !netUse('bs')
   nuse()
   retu
endif
if !netUse('dkkln')
   nuse()
   retu
endif
if !netUse('knasp')
   nuse()
   retu
endif
if !netUse('dknap')
   nuse()
   retu
endif

if !netUse('dkklns')
   nuse()
   retu
endif

if !netUse('dkklna')
   nuse()
   retu
endif

if !netUse('dokko')
   nuse()
   retu
endif

if !netUse('moddoc')
   nuse()
   retu
endif
if !netUse('mdall')
   nuse()
   retu
endif

if !netUse('nap')
   nuse()
   retu
endif
if !netUse('naptm')
   nuse()
   retu
endif
if !netUse('kplnap')
   nuse()
   retu
endif
if !netUse('ktanap')
   nuse()
   retu
endif

*netuse('opfh')

  //Инициализация klnnac
if !netuse('klnnac')
   nuse()
   wmess('Не удалось открыть KLNNAC',3)
   retu
endif

  //Инициализация brnac
if !netuse('brnac')
   nuse()
   wmess('Не удалось открыть BRNAC',3)
   retu
endif
  //Инициализация mnnac
if !netuse('mnnac')
   nuse()
   wmess('Не удалось открыть MNNAC',3)
   retu
endif

  //Инициализация klndog
if !netuse('klndog')
   nuse()
   wmess('Не удалось открыть KLNDOG',3)
   retu
endif
*****************
netuse('kplkgp')
*****************
*****************
netuse('kpl')
*****************
*****************
netuse('kps')
*****************
*****************
netuse('kgp')
*****************
*****************
netuse('kgpcat')
*****************
*****************
netuse('etm')
*****************
*****************
netuse('stagtm')
*****************
*****************
netuse('edz')
*****************
*****************
netuse('tmesto')
*****************
*****************
netuse('atran')
*****************
*****************
netuse('nnds')
*****************
*****************
netuse('posid')
*****************
*****************
netuse('posbrn')
*****************
*****************
netuse('cntm')
if recc()=0
   netadd()
endif
*****************
  //Инициализация mkeep
if !netuse('MKeep')
   nuse()
   wmess('Не удалось открыть MKeep',3)
   retu
endif

  //Инициализация mkeepe
if !netuse('MKeepE')
   nuse()
   wmess('Не удалось открыть MKeepE',3)
   retu
endif
if !netuse('brand')
   nuse()
   wmess('Не удалось открыть brand',3)
   retu
endif

if !netuse('kgptm')
   nuse()
   wmess('Не удалось открыть KGPTM',3)
   retu
endif

if !netuse('krntm')
   nuse()
   wmess('Не удалось открыть KRNTM',3)
   retu
endif

if !netuse('nasptm')
   nuse()
   wmess('Не удалось открыть NASPTM',3)
   retu
endif

if !netuse('rntm')
   nuse()
   wmess('Не удалось открыть RNTM',3)
   retu
endif

if !netuse('kplbon')
   nuse()
   wmess('Не удалось открыть KPLBON',3)
   retu
endif

if !netuse('kplboe')
   nuse()
   wmess('Не удалось открыть KPLBOE',3)
   retu
endif

  //Инициализация TOV
store 0 to k1tr,kger,mntovr,kgr,mnntovr,osfr,osvr,osnr,vupackr,keir,kachr,;
           keipr,vesr,postr,izgr,vespr,upakr,sertr,srealr,kodst1r,vesst1r,;
           kodst2r,vesst2r,osfmr,keurr,keur1r,keur2r,keur3r,keur4r,keuhr,;
           optr,optzr,cenprr,cenpsr,rozprr,rozpsr,rozmgr,roz05r,kgnr,ktlnr,;
           kgsr,ktlsr,barr,loc,ksertr,kukachr,kspovor
store '' to neir,neipr,tovdopr,namr,upur
store space(60) to natr,nair
store ctod('') to dppr,dpor,drlzr
for i=1 to 30
    if i<10
       ir='0'+str(i,1)
    else
       ir=str(i,2)
    endif
    ccr='c'+ir+'r'
    &ccr=0
next

if !netUse('tov')
   nuse()
   wmess('Не удалось открыть TOV',3)
   retu
endif
set orde to tag t1
if fieldsize(fieldpos('ktl'))#9
   wmess('UPGRADE.Обратитесь к Администратору!!!',1)
   nuse()
   retu
endif
*******************************************
*netuse('tovpt') //для провекрки работы в совместном доступе
*******************************************
*******************************************
if gnCtov=1
   netUse('tovm','tovmsrt')
endif
netUse('tov','tovsrt')
netuse('kprod')
*******************************************
do case
   case gnCtov=0                       // Обычный режим
   case gnCtov=1
        if !netUse('ctov')             // Общий справочник
           nuse()
           wmess('Не удалось открыть CTOV',3)
           retu
        endif
        set orde to tag t1
        if !netfile('tovm')
           copy file (gcPath_a+'tov.dbf') to (gcPath_t+'tovm.dbf')
           netind('tovm')
        endif
        if !netuse('tovm')
           nuse()
           wmess('Не удалось открыть TOVM',3)
           retu
        endif
        *******************************************
        netUse('tovm','tovmsrt')
        *******************************************
        if !netfile('rs2m')
           copy file (gcPath_a+'rs2.dbf') to (gcPath_t+'rs2m.dbf')
           netind('rs2m')
        endif
        if !netuse('rs2m')
           nuse()
           wmess('Не удалось открыть RS2M',3)
           retu
        endif
        set orde to tag t3
        if lower(indexkey())='str(ttn,6)+str(mntovp,7)+str(ktlp,9)+str(ppt,1)+str(mntov,7)+str(ktl,9)'
           prrs2mr=1
        else
           prrs2mr=0
        endif
        set orde to tag t1
        store 0 to mntovr,mntovpr
   case gnCtov=2
        if !netUse('tovd')             // Разделенный
           nuse()
           wmess('Не удалось открыть TOVD',3)
           retu
        endif
        set orde to tag t1
   case gnCtov=3
        if !netUse('ctovk')             // Общий внутренний справочник KTL
           nuse()
           wmess('Не удалось открыть CTOVK',3)
           retu
        endif
        set orde to tag t1
        if !netUse('cgrpk')             // Общий внутренний справочник групп
           nuse()
           wmess('Не удалось открыть CGRPK',3)
           retu
        endif
        set orde to tag t1
endc
  //Инициализация GRU
if !netfile('gru')
   copy file (gcPath_a+'gru.dbf') to (gcPath_E+'gru.dbf')
   netind('gru')
endif
if !netuse('gru')
   nuse()
   wmess('Не удалось открыть GRU',3)
   retu
endif
  //Инициализация PR1,RS1
   store ctod('') to dvpr,ddcr,dnzr,dopr
   store space(8) to tdcr
   store 0 to kplr,ktor,sdvr,sksr,sklsr,sktr,skltr,sdv2r,pr49r
   stor space(10) to nnzr,atnomr
   store space(60) to textr
  //Инициализация PR2,RS2
  store 0 to ktlr,kplr,zenr,kfr,sfr,bzenr,xzenr,srr,seur
  //Инициализация PR3,RS3
  store 0 to kszr,ssfr,bssfr,xssfr,prr,bprr,xprr
  //Инициализация GrpE
if !netuse('GrpE')
   nuse()
   wmess('Не удалось открыть GrpE',3)
   retu
endif
  //Инициализация SL
if select('sl')=0
   sele 0
   use _slct alia sl excl     //s_slct
else
   sele sl
endif
zap
  //Инициализация SPENG
if !netUse('speng')
   nuse()
   wmess('Не удалось открыть SPENG',3)
   retu
endif
  //Инициализация SERT
if !netUse('sert')
   nuse()
   wmess('Не удалось открыть SERT',3)
   retu
endif
  //Инициализация UKACH
if !netUse('ukach')
   nuse()
   wmess('Не удалось открыть UKACH',3)
   retu
endif
  //Инициализация KLN
if !netUse('kln')
   nuse()
   wmess('Не удалось открыть KLN',3)
   retu
endif
  //Инициализация BANKS
if !netUse('banks')
   nuse()
   wmess('Не удалось открыть BANKS',3)
   retu
endif
  //Инициализация NEI
if !netUse('nei')
   nuse()
   wmess('Не удалось открыть NEI',3)
   retu
endif
  //Инициализация TARA
if !netUse('tara')
   nuse()
   wmess('Не удалось открыть TARA',3)
   retu
endif
  //Инициализация DCLR
if !netUse('dclr')
   nuse()
   wmess('Не удалось открыть DCLR',3)
   retu
endif
  //Инициализация CSKLE
if !netuse('cskle')
   nuse()
   wmess('Не удалось открыть CSKLE',3)
   retu
endif
  //Инициализация CSKL
if !netuse('cskl')
   nuse()
   wmess('Не удалось открыть CSKL',3)
   retu
endif
  //Инициализация TCEN
if !netuse('tcen')
   nuse()
   wmess('Не удалось открыть TCEN',3)
   retu
endif
  //Инициализация PODR
if !netuse('podr')
   nuse()
   wmess('Не удалось открыть PODR',3)
   retu
endif
netuse('skl')
if gnKt=1
   netuse('otkt')
   netuse('otkte')
endif
******************************************************************
  //Подключение мультигрупп
*******************************************************************
if gnMskl=1.and.gnCtov#3
   if !netfile('sGrpE')
      mess('Создание SGrpE')
      copy file (gcPath_a+'sGrpE.dbf') to (gcPath_t+'sGrpE.dbf')
      netind('sGrpE')
      netuse('sGrpE')
      netuse('tov')
      do while !eof()
         sklr=skl
         ktlr=ktl
         kgr=int(ktlr/1000000)
         sele sGrpE
         if !netseek('t1','sklr,kgr')
            netadd()
            netrepl('skl,kg,ktl','sklr,kgr,ktlr')
         else
            if ktlr>ktl
               netrepl('ktl','ktlr')
            endif
         endif
         sele tov
         skip
      enddo
      nuse('tov')
   endif
   if !netuse('sGrpE')
      nuse()
      wmess('Не удалось открыть SGrpE',3)
      retu
   endif
   clea
endif
********************************************************************
  //Конец подключения мультигрупп
********************************************************************
netuse('pr1')
if netseek('t3','1')
   gnOtv=1 // Склад работает с ответхранением
else
   gnOtv=0
endif
nuse('pr1')
if gnD0k1=1
   tbl1r='pr1'
   tbl2r='pr2'
   tbl3r='pr3'
   mdocr='mnr'
   fdocr='mn'
   fkolr='kf'
   fsumr='sf'
   fprr='prp'
   mprr='prpr'
     //Инициализация pr1
   store 0 to ndr,mnr,kpsr,bsr,sopr,rnr
   bprzr=0
   store ctod('') to dprr
   store space(8) to tprr
   if !netUse('pr1')
      nuse()
      wmess('Не удалось открыть PR1',3)
      retu
   endif
     //Инициализация pr1g
   if !netfile('pr1g')
      copy file (gcPath_a+'pr1g.dbf') to (gcPath_t+'pr1g.dbf')
      netind('pr1g')
   endif
   if !netuse('pr1g')
      nuse()
      wmess('Не удалось открыть PR1G',3)
      retu
   endif
     //Инициализация pr2
   if !netUse('pr2')
      nuse()
      wmess('Не удалось открыть PR2',3)
      retu
   endif
     //Инициализация pr3
   if !netUse('pr3')
      nuse()
      wmess('Не удалось открыть PR3',3)
      retu
   endif
     //Инициализация VOP
   if !netUse('vop')
      nuse()
      wmess('Не удалось открыть VOP',3)
      retu
   endif
   netuse('nds')
   prh()
else
   tbl1r='rs1'
   tbl2r='rs2'
   tbl3r='rs3'
   mdocr='ttnr'
   fdocr='ttn'
   fkolr='kvp'
   fsumr='svp'
   fprr='pr'
   mprr='prr'
     //Инициализация rs1
   store 0 to ttnr,kgpr,spdr,bprzr,sdfr,vsvr,pdrr,konr,pprr,serr,numbr,vzz
   store ctod('') to dotr,dopr
   store space(8) to totr
   store '' to notr
   if !netUse('rs1')
      nuse()
      wmess('Не удалось открыть RS1',3)
      retu
   endif
     //Инициализация rs1g
   if !netfile('rs1g')
      copy file (gcPath_a+'rs1g.dbf') to (gcPath_t+'rs1g.dbf')
      netind('rs1g')
   endif
   if !netuse('rs1g')
      nuse()
      wmess('Не удалось открыть RS1G',3)
      retu
   endif
     //Инициализация rs2
   store 0 to kvpr,svpr,tnr,svr,sertr
   if !netUse('rs2')
      nuse()
      wmess('Не удалось открыть RS2',3)
      retu
   endif
     //Инициализация rs3
   store 0 to sszr,postr
   if !netUse('rs3')
      nuse()
      wmess('Не удалось открыть RS3',3)
      retu
   endif
   lcrtt('lrs3','rs3')
   lindx('lrs3','rs3')
   luse('lrs3')
   if !netuse('lic')
      nuse()
      wmess('Не удалось открыть LIC',3)
      retu
   endif
   if !netuse('lice')
      nuse()
      wmess('Не удалось открыть LICE',3)
      retu
   endif
   if !netuse('klnlic')
      nuse()
      wmess('Не удалось открыть KLNLIC',3)
      retu
   endif
   if gnVo=5 .or.gnVo=4
      if !netuse('bs')
         nuse()
         wmess('Не удалось открыть BS',3)
         retu
      endif
   endif
     //Инициализация VO
   if !netUse('vo')
      nuse()
      wmess('Не удалось открыть VO',3)
      retu
   endif
   netuse('nds')
   netUse('mkcros')
   if przvr=0
      rsh()
   else
      rszg()
   endif
   if select('lrs3')#0
      sele lrs3
      use
      erase lrs3.dbf
      erase lrs3.cdx
   endif
endif

store 0 to entpr,sktpr,skltpr,otpr,kgpr,amnpr
store '' to nentpr,nsktpr,nskltpr,notpr,ngpr
store '' to pathepr,direpr,pathtpr,pathbpr

