#include "common.ch"
#include "inkey.ch"
#define KK_GET
*************  печать ТТН ***************
para p1  // 1 - локальн,2- сетевая
*****************************************
prupr=0
lSeekError:=.F.
netuse('knasp')
netuse('opfh')
store 0 to kk,psp,kkr,prassor
filedelete('*.prn')
prosfor=0
vpr=1
kkr=1
kk=1
psp=1
notr=''
otr=0
vlpt1='lpt1'
do case
   case atrcr=0
        vlpt1='lpt1'
   case atrcr=1
        vlpt1='lpt3'
   case atrcr=2
        vlpt1='lpt2'
endc
if !netuse('nds')
   retu
endif

#ifndef KK_GET
  IF EMPTY(SELECT("Sl"))
    USE _slct ALIAS sl NEW
  ENDIF
  sele sl
  ZAP
  IF !FILE("RsPrn.dbf")
    DBCREATE("RsPrn",{ {"Name","C",10,0} })
    USE RsPrn NEW
    DBAPPEND();  _FIELD->Name:="Бухгалтерия"
    DBAPPEND();  _FIELD->Name:="Клиенту"
    DBAPPEND();  _FIELD->Name:="М-215"
    DBAPPEND();  _FIELD->Name:="Сертификаты"
  ELSE
    USE RsPrn NEW
  ENDIF
  DBGOTOP()
#endif

if gnVo=9.or.gnVo=2.or.gnVo=1.or.gnVo=3  // Покупатели,магазины
   if Who = 1
      Vzz = 1
   else
      Vzz = 2
   endif
   If (Who = 3.or.who=4)
      aprn={' ТТН ','Счет-фактура','Раскладка'}
      vzz=alert('Тип документа',aprn)
   endif
   if vzz=1.and.pvtr=0.and.mrshr=0
      amrsh={'Нет','Да'}
      amrshr=alert('Нет маршрута!Продолжить?',amrsh)
      if lastkey()=K_ESC.or.amrshr=1
         if select('rsprn')#0
            sele rsprn
            use
         endif
         retu
      endif
   endif
   if mrshr#0.and.pvtr=0
      mrshnppr=getfield('t1','mrshr,entr,skr,ttnr','czg','npp')
   else
      mrshnppr=0
   endif
   if vzz#3
      rsw_r=43
   else
      rsw_r=92
   endif
   prosfor=0
   do case
      case Vzz = 1
           n11='Товаро-транспортная накладная N '
           sele rs2m
           if netseek('t3','ttnr')
              do while ttn=ttnr
                 if int(mntov/10000)=350.or.;
                    int(mntov/10000)=343.or.;
                    int(mntov/10000)=338.or.;
                    int(mntov/10000)=344.or.;
                    int(mntov/10000)=346.or.;
                    int(mntov/10000)=348.or.;
                    int(mntov/10000)=345.or.;
                    int(mntov/10000)=339.or.;
                    int(mntov/10000)=342
                    prassor=1
                    exit
                  endif
                 skip
              endd
           endif
      case Vzz = 2.or.vzz=3
           n11='                 Счет-фактура N '
           sele rs2m
           if netseek('t3','ttnr')
              foot('Space,ENTER,ESC','Отбор,Печать,Отмена')
              aot:={}
              kolospr=0
              do while ttn=ttnr
                 pptr=ppt
                 mntovr=mntov
                 mntovpr=mntovp
                 if pptr=0
                    sele tovm
                    set orde to tag t1
                    if netseek('t1','sklr,mntovr')
                       otr=ot
                       if otr=0.and.int(mntovr/10000)>1
                          otr=getfield('t1','int(mntovr/10000)','sgrp','ot')
                          if otr#0
                             netrepl('ot','otr')
                          endif
                       endif
                       if ascan(aot,str(otr,2))=0
                          aadd(aot,str(otr,2))
                          kolospr=kolospr+1
                       endif
                    endif
                 endif
                 sele rs2m
                 skip
              endd
              sele rs1
              if fieldpos('kolosp')#0
                 netrepl('kolosp,kolpsp','kolospr,0',1)
              endif
              for i=1 to len(aot)
                  otr=val(aot[i])
                  sele cskle
                  if netseek('t1','skr,otr')
                     aot[i]=aot[i]+'│'+subs(nai,1,11)+'│√'
                  else
                     aot[i]=aot[i]+'│'+space(11)+'│√'
                  endif
              next
              asort(aot)
              if atrcr=0
                 clwot=setcolor('gr+/b')
                 wot=wopen(9,29,15,46)
                 wbox(1)
                 setcolor('n/w,n/bg')
                 nn=achoice(0,0,3,15,aot,,'faot')
                 if lastkey()=K_ESC
                     wclose(wot)
                     setcolor(clwot)
                     retu
                 endi
                 wclose(wot)
                 setcolor(clwot)
              else
                 nn=0
              endif
           else
              wmess('Нет товара',2)
              retu
           endif
   endc
endif
if gnVo=6.or.gnVo=8  // Переброска
   if Who = 1
      Vzz = 1
   else
      Vzz = 2
   endif
   if vzz#3
      rsw_r=43
   else
      rsw_r=92
   endif
   If Who = 3.or.who=4
      aprn={' ТТН ','Счет-фактура','Раскладка'}
      vzz=alert('Тип документа',aprn)
   endif
endif
if vzz#3
   rsw_r=43
else
   rsw_r=92
endif

if empty(dopr).and.vzz=1
   prosfor=1   // Признак коррекции OSFO
endif

if gnAdm=0.and.atrcr=0 //who#5
   if p1=2.and.(vzz=2.or.vzz=3).and.!EMPTY(dspr).and.gnCenR=0
      wmess('Счет-копия.Локальная печать F5!')
      retu
   endif
endif
if vzz=1.and.(who=1.or.who=3.or.who=4)
   @ 23,0 clea
   @ 23,1 say 'Экспедитор:'
   sele s_tag
   set order to tag t2
   go top
   @ 23,12 get kecsr pict '999'
   @ 23,col()+1 say getfield('t1','kecsr','s_tag','fio')
   @ 23,col()+1 say 'Номер автО' get atnomr
   read
   if kecsr=0
      foot('INS','Добавить запись')
      do while lastkey()<>27
         sele s_tag
         set orde to tag t2
         kecsr=slcf('s_tag',,,10,,"e:kod h:'Код' c:n(3)e:fio h:'  Ф.  И.  О. ' c:c(30)",'kod')
         rcn_ecs=recno()
         do case
            case lastkey()=K_INS
                 tagins(0)
                 kecsr=kod
            case lastkey()>32.and.lastkey()<255
                 lstkr=upper(chr(lastkey()))
                  netseek('t3','lstkr')
            case lastkey()=K_ENTER
                  exit
         endc
      endd
   endif
   if !netseek('t1','kecsr','s_tag')
      wmess('Отсутствует експедитор с кодом '+str(kecsr,3)+'  в s_tag.dbf',3)
      sele s_tag
      go top
      kecsr=SLCf('s_tag',,,10,,"e:kod h:'Код' c:n(3) e:fio h:'  Ф.  И.  О. ' c:c(30)",'kod')
   endif

   necs=getfield('t1','kecsr','s_tag','fio')
   @ 23,12 say str(kecsr,3)+'  '+alltrim(necs)
endif
if vzz#3.and.atrcr=0 //who#5
   @ 24,0 clea
   @ 24,1 say '= ' GET textr
   read
   if lastkey()=K_ESC
      retu
   endif
   sele rs1
   if netseek('t1','ttnr',,,1)
      netrepl('text,kecs','textr,kecsr',1)
      if fieldpos('atnom')#0
         netrepl('atnom','atnomr',1)
      endif
   endif
endif
if gnVo=5.and.prlkr=0   // Акт на списание
   save scre to scmess
   clea

   @ 1,1 say 'Заключение комисии :'
   @ 3,1 get zak1r
   @ 4,1 get zak2r
   @ 5,1 get zak3r

   @ 7,1 say 'Состав комисии :'
   @ 9,1 get kom1r
   @ 10,1 get kom2r
   @ 11,1 get kom3r

   read

   rest scre from scmess
endif


@ 24,0 clea

ccp=1
do while .t.
   if atrcr=0 //who#5
      @ 24,5  prompt' ПРОСМОТР '
      @ 24,25 prompt'  ПЕЧАТЬ  '
      menu to ccp
   else
      ccp=2
   endif
   if lastkey()=K_ESC
      set devi to scre
      exit
   endif
   @ 24,0 clea
   if (Who=1.or.who=3.or.who=4).and. Przr = 0.and.vzz#3
      Sele rs1
      sdvr=sdv
      sele nds
      if netseek('t2','kplr,0,skr,ttnr')
         netrepl('sum','sdvr')
      endif
      sele rs1
      if empty(dot).and.vzz=1.and.ccp=2
         dotr=dvpr
         @ 24,5 say 'Введите дату отгрузки' get dotr RANGE bom(gdTd),eom(ADDMONTH(gdTd,1))
         read
         @ 24,0 clea
         if lastkey()=K_ESC
            set devi to scre
            exit
         endif
         if przp=0
            rso(7)
            przp=1
         endif
         totr=time()
         topr=time()
         netrepl('DOT,DOP','dotr,dotr',1)
         dopr=dotr
         if fieldpos('tot')#0
            netrepl('tOT','totr',1)
         endif
         if fieldpos('top')#0
            netrepl('tOp','topr',1)
         endif
         #ifdef __CLIP__
         //lev!!
         //автоматически Подтверждение возврата ТТН на склад
         if fieldpos('dvttn')#0
  //           IF !EMPTY(rs1->dvttn) //удаляем старую аналитику т.к. может изменилась сумма докумета
  //             IF !EMPTY(rs1->(FIELDPOS("dgdTd"))) .AND. BOM(rs1->dgdTd)=BOM(gdTd)
  //               //не пустое дата периода, к которому относится документ и
  //               //периоды совпадают по началу месяца
  //               RProv({|| dokk->lev == 1  }, 2)//удалить проводки
  //             ELSE
  //               //генерируем удаление проводок
  //               RProv({|i| soper->(FIELDGET(FIELDPOS("lev"+LTRIM(STR(i,2))))) == 1  }, 1, .F.)//удалить проводки
  //             ENDIF
  //           ENDIF
  //           //добавить проводки
  //           RProv({|i| soper->(FIELDGET(FIELDPOS("lev"+LTRIM(STR(i,2))))) == 1  }, 1)//добавить проводки
            if empty(dvttn)
              netrepl('dvttn,tvttn,ktovttn','date(),time(),gnKto',1)
              prModr=1
            endif
         endif
         //end lev!
         #endif
      endif
      sele rs1
      if empty(dop).and.vzz=1.and.ccp=2
         dopr=dot
         topr=tot
         netrepl('DOP','dopr',1)
         if fieldpos('top')#0
            netrepl('tOp','topr',1)
         endif
      endif
      sele czg
      if !empty(dopr)
         if netseek('t3','entr,skr,ttnr')
            netrepl('dop,top','dopr,topr')
         endif
      endif
   endif
   aprnr=1
*****************************************************
   If !(who=2.or.who=5).and.bsor#0.and.vzz=1
      aprnr=1
      aprn={'ТТН','Бланк строгой отчетности'}
      aprnr=alert('Вид документа',aprn)
   endif
*****************************************************
   do case
      case aprnr = 2 // Бланк строгой отчетности
           clbsor=setcolor('gr+/b,n/bg')
           wbso=wopen(10,20,14,40)
           wbox(1)
           @ 0,1 say 'Серия ' get bsosr
           @ 1,1 say 'Номер ' get bsonr pict '999999'
           read
           if lastkey()=K_ESC.or.empty(bsosr).or.bsonr=0
              wclose(wbso)
              exit
           endif
           bsosr=alltrim(upper(bsosr))
           sele rs1
           if netseek('t1','ttnr',,,1)
              netrepl('bsos,bson','bsosr,bsonr',1)
           endif
           wclose(wbso)
           setcolor(clbsor)
  //          n_r=0
//созднание базы
//заполнение базы
//печать первого листа
//печать больше первого листа
           sttn_create()
           sttn_add()
           for i=1 to bsor
               if i=1
                  vbr=1
                  kekzr=4
                  clbor=setcolor('gr+/b,n/bg')
                  wbor=wopen(15,20,19,60)
                  wbox(1)
                  @ 0,1 say 'Печать 1-го бланка'
                  @ 1,1 say 'Количество экз' get kekzr pict '9' range 1,4
                  @ 2,1 prom 'НЕТ'
                  @ 2,col()+1 prom 'ДА'
                  read
                  if lastkey()=K_ESC
                     vbr=1
                  else
                     menu to vbr
                     if lastkey()=K_ESC
                        vbr=1
                     endif
                  endif
                  wclose(wbor)
                  setcolor(clbor)
                  if vbr=2
                     cfiler:=sttn_pr_n1()
                     set cons off
                     if gnOut=1
                        set prin to lpt1
                     else
                        set prin to bso1.txt
                        kekzr:=1
                     endif
                     set prin on
                     for j=1 to kekzr
                        type (cfiler)
                     next
                     set prin off
                     set prin to
                     set cons on
                  endif
               else
                  vbr=1
                  vbr=1
                  kekzr=4
                  clbor=setcolor('gr+/b,n/bg')
                  wbor=wopen(15,20,19,60)
                  wbox(1)
                  @ 0,1 say 'Печать '+str(i,1)+'-го бланка'
                  @ 1,1 say 'Количество экз' get kekzr pict '9' range 1,4
                  @ 2,1 prom 'НЕТ'
                  @ 2,col()+1 prom 'ДА'
                  read
                  if lastkey()=K_ESC
                     vbr=1
                  else
                     menu to vbr
                     if lastkey()=K_ESC
                        vbr=1
                     endif
                  endif
                  wclose(wbor)
                  setcolor(clbor)
                  if vbr=2
                     cfiler:=sttn_pr_n2(i)
                     set cons off
                     if gnOut=1
                        set prin to lpt1
                     else
                        set prin to ('bso'+str(i,1)+'.txt')
                        kekzr:=1
                     endif
                     set prin on
                     for j=1 to kekzr
                         type (cfiler)
                     next
                     set prin off
                     set prin to
                     set cons on
                  endif
               endif
           next
           sele rs1
           netrepl('krbso','gnKto',1)
  //          bso1()
  //          bso2()
           exit
      case aprnr = 1 // Обычний документ
           set devi to scre
           if atrcr=0 //who#5
              @ 24,11 say 'ЖДИТЕ РАБОТАЕТ ПЕЧАТЬ'
           endif
           if vzz=2
              rfinskl(1)
           endif
           If ccp = 1
              Set Prin To txt.TXT
           else
              set prin to
              if gnOut=1
                 if p1=1 // Локальная печать
                    set prin to lpt1
                    kk=1
                 endif    // Сетевая печать
                 if p1=2  //.and.(vzz=2.or.vzz=1)
                    if vzz=2
                       @ 24,0 say 'ПЕЧАТЬ НА СЕТЕВОЙ ПРИНТЕР        '
                       if pvtr=0 // Центрозавоз
                          do case
                             case atrcr=1
                                  vlpt1='lpt3'
                             case atrcr=2
                                  vlpt1='lpt2'
                          endc
                       else      // Самовывоз
                          vlpt1='lpt3'
                       endif
                    else
                       alpt={'lpt2','lpt3'}
                       vlpt=alert('ПЕЧАТЬ НА СЕТЕВОЙ ПРИНТЕР',alpt)
                       if vlpt=1
                          vlpt1='lpt2'
                       else
                          vlpt1='lpt3'
                       endif
                    endif
                    IF Vzz=1
                      kk:=4
                      IF kopr=161 .AND. kplr=2050040 .OR. ;
                         kopr=169 .AND. kplr=20034
                         kk:=4
                      ENDIF
                    ELSE
                       kk:=2
                       //найдем оформление докуметов
                       //rs3->(netseek('t1', 'ttnr'))
                       //rs3->(__dbLocate({||rs3->Ksz = 46 },{||rs3->ttn = ttnr}))
                       //IF rs3->(FOUND()) .AND. ROUND(rs3->ssf+rs3->bssf,0)#0
                       if kpvr=0
                          if kgpr=0
                             kkl_r=kplr
                          else
                             kkl_r=kgpr
                          endif
                       else
                          kkl_r=kpvr
                       endif
                       knaspr=getfield('t1','kkl_r','kln','knasp')
                       IF getfield("t1","ttnr,46","rs3","ssf")#0.and.knaspr#1701 //.or.pvtr=1
                         kk:=3
                       ENDIF
                    ENDIF
                    kkr=1 // Счетчик экземпляров
                    psp=2 // Признак сетевой печати для печати шапки
                    #ifdef KK_GET
                       if atrcr=0 //who#5
                          @ 24,36 say 'Количество  экз.'
                          @ 24,52 get kk pict '9' valid kk < 5
                          read
                       endif
                    #else
                      sele RsPrn
                      DO WHILE .T.
                        rcName=slcf('RsPrn',,,4,,"e:Name h:'Для кого?' c:с(15)",,1, , , ,"W+/RB+,N/W")
                        RsPrn->(DBGOTOP())
                        DO CASE
                        CASE LASTKEY()=K_ENTER .OR. LASTKEY()=K_ESC
                          EXIT
                        ENDCASE
                      ENDDO
                   #endif
                    // *                    set prin to lpt2
                    set prin to &vlpt1 //txt.TXT  //
                 endif
              else
                 Set Prin To txt.TXT
              endif
           EndIF
           ffff=val(subs(vlpt1,4,1))
           rrrr=0
           set prin on
           set cons off
           if p1=1.and.ccp=2 // Локальная печать
              alptl={'lpt1','lpt2'}
              vlptlr=alert('ПЕЧАТЬ',alptl)
              if vlptlr=1
                 clptlr='lpt1'
              else
                 clptlr='lpt2'
              endif
              if gnOut=1
                 set prin to &clptlr
              else
                 set prin to txt.txt
              endif
              if vlptlr=1
                 if empty(gcPrn)
                    ??chr(27)+chr(80)+chr(15)
                 else
  //                   if gnAdm=0
  //                      ??chr(27)+'E'+chr(27)+'&l4h2a0O'+chr(27)+'&k2S'+chr(27)+'&a20l'+chr(27)+'(3R'+chr(27)+'(s0p17.00h0s0b4099T'+chr(27)
  //                   else
                       ??chr(27)+'E'+chr(27)+'&l4h25a0O'+chr(27)+'&k2S'+chr(27)+'(3R'+chr(27)+'(s0p18.00h0s1b4102T'+chr(27)
  //                   endif
                    IF Vzz=1
                       kk=4
                       IF kopr=161 .AND. kplr=2050040 .OR. ;
                          kopr=169 .AND. kplr=20034
                          kk:=4
                       ENDIF
                    ELSE
                       kk=2
                       knaspr=getfield('t1','nKklr','kln','knasp')
                       IF getfield("t1","ttnr,46","rs3","ssf")#0.and.knaspr#1701
                          kk:=3
                        ENDIF
                    ENDIF
                    kkr=1 // Счетчик экземпляров
                    psp=2 // Признак сетевой печати для печати шапки
                    if atrcr=0 //who#5
                       @ 24,36 say 'Количество  экз.'
                       @ 24,52 get kk pict '9' valid kk < 5
                       read
                    endif
                 endif
              else // vlptlr=2
************************************************
  //                if gnAdm=0
  //                   ??chr(27)+'E'+chr(27)+'&l1h2a0O'+chr(27)+'&k2S'+chr(27)+'&a20l'+chr(27)+'(3R'+chr(27)+'(s0p17.00h0s1b4102T'+chr(27)
  //                else
                    ??chr(27)+'E'+chr(27)+'&l1h25a0O'+chr(27)+'&k2S'+chr(27)+'(3R'+chr(27)+'(s0p18.00h0s1b4102T'+chr(27)
  //                endif
************************************************
                 IF Vzz=1
                    kk=4
                    IF kopr=161 .AND. kplr=2050040 .OR. ;
                       kopr=169 .AND. kplr=20034
                       kk:=4
                    ENDIF
                 ELSE
                    kk=2
                    knaspr=getfield('t1','nKklr','kln','knasp')
                    IF getfield("t1","ttnr,46","rs3","ssf")#0.and.knaspr#1701
                       kk:=3
                    ENDIF
                 ENDIF
                 kkr=1 // Счетчик экземпляров
                 psp=2 // Признак сетевой печати для печати шапки
                 if atrcr=0 //who#5
                    @ 24,36 say 'Количество  экз.'
                    @ 24,52 get kk pict '9' valid kk < 5
                    read
                 endif
              endif
           endif
           if p1=2.and.ccp=2
              if vzz#3
  //                if gnAdm=0
  //                   ??chr(27)+'E'+chr(27)+'&l4h2a0O'+chr(27)+'&k2S'+chr(27)+'&a20l'+chr(27)+'(3R'+chr(27)+'(s0p17.00h0s1b4102T'+chr(27)
  //                else
                    ??chr(27)+'E'+chr(27)+'&l4h25a0O'+chr(27)+'&k2S'+chr(27)+'(3R'+chr(27)+'(s0p18.00h0s1b4102T'+chr(27)
  //                endif
              else
                 ??chr(27)+'E'+chr(27)+'&l1h26a0O'+chr(27)+'&k2S'+chr(27)+'&a20l'+chr(27)+'(3R'+chr(27)+'(s0p17.00h0s1b4102T'+chr(27)
              endif
           endif
           if vzz=1.or.!(gnVo=9.or.gnVo=2.or.gnVo=1.or.gnVo=3).or.vzz=3 // ТТН
              #ifdef KK_GET
                do while kkr<=kk
              #else
                sl->(DBGOTOP())
                DO WHILE  sl->(!EOF())
                    kkr:=VAL(sl->Kod)
              #endif
                 itogr=1
                 if p1=1
                    prndocm()
                    exit
                 else
                    prndocm()
                 endif
              #ifdef KK_GET
                 kkr=kkr+1
              #else
                 sl->(DBSKIP())
              #endif
              ENDDO
              if pprr=0
                 pprr=1
                 sele rs1
                 netrepl('ppr','pprr',1)
              endif
           else     // Счет-фактура
              kkk=len(aot)
              otkr=val(subs(aot[kkk],1,2))
              for ii_r=1 to len(aot)
                  if subs(aot[ii_r],16,1)='√'
                     otr=val(subs(aot[ii_r],1,2))
                     notr=subs(aot[ii_r],4,11)
                     if ii_r#kkk
                        itogr=0
                     else
                        itogr=1
                     endif
                     do while kkr<=kk
                        prndocm()
                        kkr=kkr+1
                     enddo
                     kkr=1
                  endif
                  kkr=1
              next
           endif

           set prin off
           set prin to

           if vzz=2.and.ccp=2
              sele rs1
              if ppsf=9
                 netrepl('ppsf','0',1)
              endif
              if !empty(dfp)
                 netrepl('ppsf,dsp,tsp,ktosp','ppsf+1,date(),time(),gnKto',1)
              else
                 netrepl('ppsf','ppsf+1',1)
              endif
              ppsfr=ppsf
              if p1=2.and.atrcr=0
                 rso(11)
              endif
              sele rs1
           endif
           set devi to scre
           @ 24,0 clea
           exit
   endc
enddo
#ifndef KK_GET
  CLOSE RsPrn
#endif

/*****************************************************************
 
 PROCEDURE: prndocm
 АВТОР..ДАТА........
 НАЗНАЧЕНИЕ.........  Печать
 ПАРАМЕТРЫ..........
 ПРИМЕЧАНИЯ.........
 */
PROCEDURE prndocm
  lnn=48
  lstr=1
  rswr=1
  if p1=1.and.atrcr=0 // Локальная печать 1 экз
     wmess(notr+' Вставте лист и нажмите пробел',0)
  endif
  rssh()
  vmestr=0
  ovesr=0
  if !file('ptara.dbf')
     sele 0
     crtt('ptara','f:mntov c:n(7) f:nat c:c(60) f:kol c:n(10)')
     use ptara excl
     inde on str(mntov,7) tag t1
     inde on str(int(mntov/10000),3)+nat tag t2
  else
     if select('ptara')#0
        sele ptara
        use
     endif
     erase ptara.dbf
     erase ptara.cdx
     sele 0
     crtt('ptara','f:mntov c:n(7) f:nat c:c(60) f:kol c:n(10)')
     use ptara excl
     inde on str(mntov,7) tag t1
     inde on str(int(mntov/10000),3)+nat tag t2
  endif
  sele ptara
  set orde to tag t1

  sele rs2m
  set orde to tag t3
  netseek('t3','ttnr')
  do while ttn=ttnr
     kgr=int(mntov/10000)
     mntovr=mntov
     mntovpr=mntovp
     kolr=kvp
     if kgr=0.or.kgr=1
        natr=getfield('t1','mntovr','ctov','nat')
        sele ptara
        if !netseek('t1','mntovr')
           appe blank
           netrepl('mntov,nat,kol','mntovr,natr,kolr')
        else
           netrepl('kol','kol+kolr')
        endif
     endif
     sele rs2m
     skip
  enddo
  svesr=0
  iotr=0
  sele rs2m
  set orde to tag t3
  netseek('t3','ttnr')
  rsrc_r=recn()
*******************************************
   set orde to tag t1
   sele rs2m
   set rela to str(sklr,7)+str(mntovp,7) into tovmsrt
   set orde to tag t1
   netseek('t1','ttnr')
   inde on STR(int(rs2m->mntovp/10000))+tovmsrt->nat+str(rs2m->mntovp,7)+str(rs2m->ppt)+str(rs2m->mntov) tag s1 to (gcPath_l+'\tnatm.cdx') for ttn=ttnr
   go top
*******************************************
  wll_r='ttn=ttnr'
  Do While ttn=ttnr
     pptr=ppt
     mntovr=mntov
     mntovpr=mntovp
     rcnr=recn()
     if fieldpos('sert')#0
        rs2sertr=sert
     else
        rs2sertr=0
     endif
     IF otr#0
        sele tovm
        if netseek('t1','sklr,mntovr')
           IF ot#otr
              SELE rs2m
              SKIP
              LOOP
           ENDIF
        ELSE
          lSeekError:=.T.
          #ifdef __CLIP__
            outlog(__FILE__,__LINE__,"SEEK_TOVM___",sklr,mntovpr)
          #endif
          sele rs2m
          ?str(mntovpr,7)+' Не найден в TOVM по OT'
          rsle()
          skip
          loop
        ENDIF
     ENDIF
     sele rs2m
     kvpr=kvp
     zenr=zen
     svpr=svp
     srr=sr
     vesr=0
     iotr=iotr+svpr
     sele tovm
     if netseek('t1','sklr,mntovr')
        kger=kge
        vespr=vesp
        upakr=upak
        if ctovr=1
           natr=getfield('t1','mntovr','ctov','nat')
        else
           natr=nat
        endif
        neir=nei
        sertr=sert
        srealr=sreal
        vesr=ves
        optr=&coptr
        mntovr=mntov
        drlzr=drlz
        dizgr=dizg
        ksertr=ksert
        nsertr=getfield('t1','ksertr','sert','nsert')
        nsertr=alltrim(nsertr)
        kukachr=kukach
        prmnr=prmn
        locr=loc
        kodst1r=kodst1
        vesst1r=vesst1
        if prosfor=1.and.ccp=2
           netrepl('osfo','osfo-kvpr')
           sele tovm
           if netseek('t1','sklr,mntovr')
              netrepl('osfo','osfo-kvpr')
           endif
           sele rs2m
           netrepl('prosfo','1')
        endif
        sele tovm
        if rtcenr#0
           roptr=&croptr
        endif
        opt_r=opt
        if getfield('t1','int(mntovr/10000)','sgrp','mark')=1
           nat_r=alltrim(getfield('t1','kger','GrpE','nge'))+' '+alltrim(natr)+iif(upakr#0,' 1/'+kzero(upakr,10,3),'')
        else
           nat_r=alltrim(natr)+iif(upakr#0,' 1/'+kzero(upakr,10,3),'')
        endif
        if vzz=1 // TTN
           nat_r=nat_r+iif(!empty(nsertr),' '+nsertr,'')
           if gnVo=6.and.(kopr=101.or.kopr=181.or.kopr=121)
              nat_r=nat_r //+iif(kodst1r#0,' '+str(kodst1r,4),'')+iif(vesst1r#0,' '+str(vesst1r,10,3),'')
           endif
        endif
        if locr#0
           lnn=44
        else
           lnn=48
        endif
        lnat_r=len(nat_r)
        if lnat_r<lnn //50
           if upakr=0
              nat_r=nat_r+space(lnn-lnat_r)
           else
              nat_r=iif(getfield('t1','int(mntovr/10000)','sgrp','mark')=1,alltrim(getfield('t1','kger','GrpE','nge'))+' '+alltrim(natr),alltrim(natr))+iif(vzz=1.and.!empty(nsertr),' '+nsertr,'')
              lnat_r=len(nat_r)
              cupakr=' 1/'+kzero(upakr,10,3)
              lcupakr=len(cupakr)
              nat_r=nat_r+space(lnn-lnat_r-lcupakr)+cupakr
              if vzz=1.and.gnVo=6.and.(kopr=101.or.kopr=181.or.kopr=121)
                 nat_r=nat_r //+iif(kodst1r#0,' '+str(kodst1r,4),'')+iif(vesst1r#0,' '+str(vesst1r,10,3),'')
              endif
           endif
        endif
        svesr=svesr+ROUND(kvpr*vesr,3)
        if len(nat_r)=lnn
           if zcr=0
              if vzz=3
                 ?str(mntovr,7)+iif(locr#0,str(locr,6),'')+' '+nat_r+' '+subs(neir,1,4)+' '+str(kvpr,10,3)+' '+str(zenr,9,3)+' '+iif(svpr<10000000,str(svpr,9,2),str(svpr,12,2))+' '+str(prmnr,6)+' '+dtoc(dizgr)+' '+dtoc(drlzr)+' '+iif(rs2sertr#0,'C','')
              else
                 ?str(mntovr,7)+iif(locr#0,str(locr,6),'')+' '+nat_r+' '+subs(neir,1,4)+' '+str(kvpr,10,3)+' '+str(zenr,9,3)+' '+iif(svpr<10000000,str(svpr,9,2),str(svpr,12,2))+' '+iif(rs2sertr#0,'C','')
              endif
              rsle()
           else
              if vzz=3
                 ?str(mntovr,7)+iif(locr#0,str(locr,6),'')+' '+nat_r+' '+subs(neir,1,4)+' '+str(kvpr,10,3)+' '+str(opt_r,9,3)+' '+iif(svpr<10000000,str(svpr,9,2),str(svpr,12,2))+' '+str(prmnr,6)+' '+dtoc(dizgr)+' '+dtoc(drlzr)+' '+iif(rs2sertr#0,'C','')
              else
                 ?str(mntovr,7)+iif(locr#0,str(locr,6),'')+' '+nat_r+' '+subs(neir,1,4)+' '+str(kvpr,10,3)+' '+str(opt_r,9,3)+' '+iif(svpr<10000000,str(svpr,9,2),str(svpr,12,2))+' '+iif(rs2sertr#0,'C','')
              endif
              rsle()
              ?space(9)+' '+space(48)+' '+space(4)+' '+space(9)+' '+str(zenr-opt_r,9,3)+' '
              rsle()
           endif
        else
           store '' to xxx,yyy
           for i=lnat_r to 1 step -1
               yyy=right(nat_r,lnat_r-i)
               xxx=subs(nat_r,1,i)
               if i<lnn.and.subs(nat_r,i,1)=' '
                  exit
               endif
           next
           if len(xxx)<lnn
              xxx=xxx+space(lnn-len(xxx))
           endif
           if vzz=3
              ?str(mntovr,7)+iif(locr#0,str(locr,6),'')+' '+xxx+' '+subs(neir,1,4)+' '+str(kvpr,10,3)+' '+str(zenr,9,3)+' '+iif(svpr<10000000,str(svpr,9,2),str(svpr,12,2))+' '+str(prmnr,6)+' '+dtoc(dizgr)+' '+dtoc(drlzr)+' '+iif(rs2sertr#0,'C','')
           else
              ?str(mntovr,7)+iif(locr#0,str(locr,6),'')+' '+xxx+' '+subs(neir,1,4)+' '+str(kvpr,10,3)+' '+str(zenr,9,3)+' '+iif(svpr<10000000,str(svpr,9,2),str(svpr,12,2))+' '+iif(rs2sertr#0,'C','')
           endif
           rsle()
           ?space(9)+' '+yyy
           rsle()
        endif
        if rtcenr#0.and.roptr#0.and.vzz=1
           ?space(9)+' '+space(48)+' '+space(5)+' '+space(9)+' '+str(roptr,9,3)+' '
           rsle()
        endif
        natdopr=''
        if sertr#0
           natdopr='Серт. '+ltrim(str(sertr,10))+' '
        endif
        if srealr#0
           natdopr=natdopr+'Ср.реал. '+ltrim(str(srealr,10))+' час'
        endif
        if !empty(natdopr)
           ?NATdopr
           rsle()
        endif
     else
        /*
          lSeekError:=.T.
          #ifdef __CLIP__
            outlog(__FILE__,__LINE__,"SEEK_TOV_M__",cKeySeek,LEN(cKeySeek),sklr,mntovr)
          #endif
        */
        ?str(mntovr,7)+' Не найден в TOV'
        rsle()
     endif
     if skr=157.and.vzz=1.and.(kopr=101.or.kopr=181.or.kopr=121)
        c19r=getfield('t1','sklr,mntovr','tovm','c19')
        c20r=getfield('t1','sklr,mntovr','tovm','c20')
        c21r=getfield('t1','sklr,mntovr','tovm','c21')
        c29r=getfield('t1','sklr,mntovr','tovm','c29')
        ?'Нац кл '+str(c19r,10,3)+' Мин опт '+str(c20r,10,3)+' Зоомаг '+str(c21r,10,3)+' Баз '+str(c29r,10,3)
        rsle()
     endif
     sele rs2m
     skip
  enddo
  if vzz=1
     prosfor=0
  endif
  if itogr=1
     if vzz=2
        ?'Итого по отделу '+str(otr,2)+space(65)+iif(iotr<10000000,str(iotr,10,2),str(iotr,12,2))
        rsle()
     else
        sele ptara
        if recc()#0
           ?'Итого тары:'
           set orde to 2
           go top
           do while !eof()
              ?str(mntov,7)+' '+subs(nat,1,40)+' '+str(kol,10)
              rsle()
              skip
           endd
           ?''
           rsle()
        endif
     endif
     ?''
     rsle()
     sele rs3
     naitr=' (Возвр) '
     if netseek('t1','ttnr,12').and.ssf#0
        naitr='(Не возвр)'
     endif
     netseek('t1','ttnr')
     Do Whil ttn=ttnr
        kszr=ksz
        if kszr>=90
           skip
           loop
        endif
        if vzz=4
           ssfr=bssf
        else
           ssfr=ssf
        endif
        if ssfr#0
           if vzz=4
              prr=bpr
           else
              prr=pr
           endif
           nszr=getfield('t1','kszr','dclr','nz')
           DO case
              CASE kszr=19
                    nszr=subs(nszr,1,10)+naitr
                    ?space(51)+str(kszr,2)+'-'+nszr+':'+' '+str(prr,5,2)+space(3)+iif(ssfr<10000000,str(ssfr,10,2),str(ssfr,12,2))
              CASE kszr=18
                 IF pstr=0
                    nszr=subs(nszr,1,10)+' (Возвр.) '
                 ELSE
                    nszr=subs(nszr,1,10)+'(Не возвр)'
                 ENDIF
                 ?space(51)+str(kszr,2)+'-'+nszr+':'+' '+str(prr,5,2)+space(3)+iif(ssfr<10000000,str(ssfr,10,2),str(ssfr,12,2))

              OTHERW

                 ?space(51)+str(kszr,2)+'-'+nszr+':'+' '+str(prr,5,2)+space(3)+iif(ssfr<10000000,str(ssfr,10,2),str(ssfr,12,2))
           ENDCASE
           rsle()
        ENDIF
        sele rs3
        skip
     endd
     rsle()
     IF vzz#3
        IF kecsr#0
           ?'Экспедитор  ' +getfield('t1','kecsr','s_tag','fio')
           rsle()
        ENDIF
        ?textr
        rsle()
     endif
     IF netseek('t1','ttnr,90')
        IF vzz=4
           ssfr=bssf
        ELSE
           ssfr=ssf
        ENDIF
        ?space(51)+'Итого по документу  '+space(8)+str(ssfr,15,2) //+' грн.'
        rsle()
     ENDIF
     IF vzz=1 .and. skr=113
        ?space(10)
        rsle()
        ?'Продукция проверена ______________    Час выхода с печи_____________'
     ENDIF

     rsfoot(1)
  ELSE
     IF vzz=2
        ?'Итого по отделу '+str(otr,2)+space(65)+iif(iotr<10000000,str(iotr,10,2),str(iotr,12,2))
        rsle()
     ENDIF
     ?'Итоги в счете-фактуре по отделу '+str(otkr,2)
     rsle()
     rsfoot()
  ENDIF
  RETU

