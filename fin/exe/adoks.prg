#include "inkey.ch"
// adoks
sele doks
set orde to tag t1
if !netseek('t1','mnr')
   go top
endif
rcdoksr=recn()
fldnomr=1
fords_r='.t.'
fordsr='.t.'
do while .t.
   sele doks
   set orde to tag t1
   go rcdoksr
   store 0 to kklr,nplr,rndr,pobr,ssdr,penr,tipr,przr,ktor,lstr,tzdocr,nnds1r
   store '' to osnr,nklr
   if int(bsr/1000)=301
      foot('F2,F3,F4,F5,F6,F7,F8,F9','160,Фильтр,Корр,Чек,Переместить,Сеанс,169,169 сп')
   else
      if int(bsr/1000)=311
         foot('F4','Коррекция')
      else
         foot('F4','Коррекция')
      endif
   endif
   set cent off
   if fieldpos('cnplp')=0
      rcdoksr=slce('doks',,,,,"e:rnd h:'Рег.N' c:n(6) e:ssd h:'Сумма' c:n(10,2) e:asum(doks->prz,doks->mn,doks->rnd) h:'СуммаП' c:n(10,2) e:nplp h:'N док.' c:n(6) e:ddc  h:'Дата' c:d(8) e:getfield('t1','doks->kkl','kln','nkl') h:'Клиент' c:c(30) e:kkl h:'Код' c:n(7) e:auto h:'A' c:n(1) e:nchek h:'Чек' c:n(6) e:bosn h:'Основание' c:c(70)",,,1,'mn=mnr',fordsr,,'Суммы(Чеки)',,1)
   else
      if int(bsr/1000)#301
         rcdoksr=slce('doks',,,,,"e:rnd h:'Рег.N' c:n(6) e:ssd h:'Сумма' c:n(10,2) e:asum(doks->prz,doks->mn,doks->rnd) h:'СуммаП' c:n(10,2) e:nplp h:'N док.' c:n(6) e:ddc  h:'Дата' c:d(8) e:getfield('t1','doks->kkl','kln','nkl') h:'Клиент' c:c(30) e:kkl h:'Код' c:n(7) e:auto h:'A' c:n(1) e:nchek h:'Чек' c:n(6) e:bosn h:'Основание' c:c(70) e:cnplp h:'Платежка' c:c(20)",,,1,'mn=mnr',fordsr,,'Суммы(Чеки)',,1)
      else
         if fieldpos('snc')=0
            rcdoksr=slce('doks',,,,,"e:rnd h:'Рег.N' c:n(6) e:ssd h:'Сумма' c:n(10,2) e:asum(doks->prz,doks->mn,doks->rnd) h:'СуммаП' c:n(10,2) e:nplp h:'N док.' c:n(6) e:ddc  h:'Дата' c:d(8) e:getfield('t1','doks->kkl','kln','nkl') h:'Клиент' c:c(30) e:kkl h:'Код' c:n(7) e:auto h:'A' c:n(1) e:nchek h:'Чек' c:n(6) e:bosn h:'Основание' c:c(70) e:cnplp h:'Платежка' c:c(20)",,,1,'mn=mnr',fordsr,,'Суммы(Чеки)',,1)
         else
            if fieldpos('nxot')=0
               rcdoksr=slce('doks',,,,,"e:rnd h:'Рег.N' c:n(6) e:ssd h:'Сумма' c:n(10,2) e:asum(doks->prz,doks->mn,doks->rnd) h:'СуммаП' c:n(10,2) e:snc h:'СНС' c:n(3) e:nplp  h:'N док.' c:n(6) e:getfield('t1','doks->kkl','kln','nkl') h:'Клиент' c:c(30) e:kkl h:'Код' c:n(7) e:auto h:'A' c:n(1) e:nchek h:'Чек' c:n(6) e:bosn h:'Основание' c:c(70) e:cnplp h:'Платежка' c:c(20)",,,1,'mn=mnr',fordsr,,'Суммы(Чеки)',,1)
            else
               rcdoksr=slce('doks',,,,,"e:rnd h:'Рег.N' c:n(6) e:ssd h:'Сумма' c:n(10,2) e:asum(doks->prz,doks->mn,doks->rnd) h:'СуммаП' c:n(10,2) e:snc h:'СНС' c:n(3) e:nplp  h:'N док.' c:n(6) e:getfield('t1','doks->kkl','kln','nkl') h:'Клиент' c:c(30) e:kkl h:'Код' c:n(7) e:auto h:'A' c:n(1) e:nchek h:'Чек' c:n(6) e:bosn h:'Основание' c:c(70) e:cnplp h:'Платежка' c:c(20) e:nxot h:'Xотч' c:n(6) e:nzot h:'Zотч' c:n(6) e:ktas h:'KTAS' c:n(4) e:nap h:'NAP' c:n(4)",,,1,'mn=mnr',fordsr,,'Суммы(Чеки)',,1)
            endif
         endif
      endif
   endif
   set cent on
   if lastkey()=K_ESC
      exit
   endif
   sele doks
   go rcdoksr
   rndr=rnd
   kklr=kkl
   nplpr=nplp
   pobr=pob
   ssdr=ssd
   osnr=osn
   penr=pen
   tipr=tip
   przr=prz
   ktor=kto
   bosnr=bosn
   ktasr=ktas
   if fieldpos('cnplp')#0
      cnplpr=cnplp
   else
      cnplpr=space(20)
   endif
   if fieldpos('nkkl')#0
      nkklr=nkkl
      nnkklr=getfield('t1','nkklr','kln','nkl')
   else
      nkklr=0
      nnkklr=''
   endif
   if fieldpos('prFrm')#0
      prFrmr=prFrm
      nchekr=nchek
   else
      prFrmr=0
      nchekr=0
   endif
   if fieldpos('snc')#0
      sncr=snc
   else
      sncr=0
   endif
   if fieldpos('nap')#0
      napr=nap
   else
      napr=0
   endif
   if fieldpos('ktapl')#0
      ktaplr=ktapl
   else
      ktaplr=0
   endif
   tzdocr=getfield('t1','kklr','kpl','tzdoc')
 //   pr1ndsr=getfield('t1','kklr','kpl','pr1nds')
   pr1ndsr=0
   nktaplr=getfield('t1','ktaplr','s_tag','fio')
   nnapr=getfield('t1','napr','nap','nnap')
   nklr=getfield('t1','kklr','kln','nkl')
   sele tipd
   if netseek('t1','tipor,tipr')
      ndokr=ndok
      przr=prz
   endif
   do case
      case lastkey()=19 // Left
           fldnomr=fldnomr-1
           if fldnomr=0
              fldnomr=1
           endif
      case lastkey()=4 // Right
           fldnomr=fldnomr+1
      case lastkey()=K_ENTER // Выбор
           if rndr=0
              loop
           endif
           ssumd_r=asum(0,mnr,rndr)
           ssumk_r=asum(1,mnr,rndr)
           @ 2,40 say '  Дебет'+str(ssumd_r,10,2) + space(3)+'  Кредит'+str(ssumk_r,10,2)
           @ 3,1 say 'Pег.N '+str(rndr,6)
           @ 4,1 say 'Клиент '+str(kklr,7)
           @ 5,1 say 'Тип документа : '+ndokr
           @ 3,61 say 'Сумма  '+str(ssdr,10,2)
 //           if prFrmr=0
              if przr=0
                 @ 4,61 say 'Остаток'+str(ssdr-ssumd_r,10,2)
              else
                 @ 4,61 say 'Остаток'+str(ssdr-ssumk_r,10,2)
              endif
 //           endif
           adokk()
           @ 3,0 clea
      case lastkey()=K_INS.and.prrmbsr=0.and.prdp() // Добавить
           adoksins(0)
      case lastkey()=K_DEL.and.prrmbsr=0.and.prdp().and.nchekr=0  // Удалить
           sele dokk
           set orde to tag t1
           store 0 to sumd_r,sumk_r
           if netseek('t1','mnr,rndr')
              sele dokk
              do while mn=mnr.and.rnd=rndr
                 sele dokk
                 if !(prc.or.bs_d=0.or.bs_k=0)
                    sele dokk
                    docmod('уд',1)
                    mdall('уд')
                    msk(0,0)
                 else
                    docmod('уд',1)
                    netdel()
                    skip
                    loop
                 endif
                 sele dokk
                 if bs_d=bsr
                    sumd_r=sumd_r+bs_s
                 endif
                 if bs_k=bsr
                    sumk_r=sumk_r+bs_s
                 endif
                 dokkttnr=dokkttn
                 dokkskr=dokksk
                 docprdr=docprd
                 bs_srr=bs_s
                 if dokkttnr#0.and.dokkskr#0.and.!empty(docprdr)
                   pathmr=gcPath_e+'g'+str(year(docprdr),4)+'/m'+iif(month(docprdr)<10,'0'+str(month(docprdr),1),str(month(docprdr),2))+'\'
                   sele cskl
                   locate for sk=dokkskr
                   pathr=pathmr+alltrim(path)
                   if netfile('rs1',1)
                      netuse('rs1','rs1opl',,1)
                      if fieldpos('sdo')#0
                         if netseek('t1','dokkttnr')
                            netrepl('sdo','sdo-bs_srr')
                            sdor=sdo
                         endif
                      endif
                      nuse('rs1opl')
                   endif
                 endif
                 sele dokk
                 netdel()
                 skip
              enddo
           endif
           sele doks
           netrepl('ssd','0')
           sele dokz
           sumdr=sumd-sumd_r
           sumkr=sumk-sumk_r
           netrepl('sumd,sumk','sumdr,sumkr')
           @ 1,40 say ' Дебет '+str(sumdr,10,2)+space(3)+' Кредит '+str(sumkr,10,2)
           ssumd_r=asum(0,mnr,rndr)
           ssumk_r=asum(1,mnr,rndr)
           @ 3,61 say 'Сумма  '+str(ssdr,10,2)
           if prFrmr=0
              if przr=0
                 @ 4,61 say 'Остаток'+str(ssdr-ssumd_r,10,2)
              else
                 @ 4,61 say 'Остаток'+str(ssdr-ssumk_r,10,2)
              endif
           endif
      case lastkey()=K_F2.and.prdp() // 160
           wmess('Этот режим недоступен',3)
           loop
           kop160()
      case lastkey()=K_F4 // Коррекция
           adoksins(1)
           ssumd_r=asum(0,mnr,rndr)
           ssumk_r=asum(1,mnr,rndr)
           @ 3,61 say 'Сумма  '+str(ssdr,10,2)
           if prFrmr=0
              if przr=0
                 @ 4,61 say 'Остаток'+str(ssdr-ssumd_r,10,2)
              else
                 @ 4,61 say 'Остаток'+str(ssdr-ssumk_r,10,2)
              endif
           endif
      case lastkey()=-34.and.int(bsr/1000)=301 // Чек
           if gnAdm=1.or.gnRks=1
              #ifdef __CLIP__
                 if nchekr=0
                    chekds(,ssdr)
                 else
                    wmess('Уже распечатан',2)
                 endif
              #else
                 chekds(,ssdr)
              #endif
           endif
      case lastkey()=K_F5 .and. int(bsr/1000)=301 // Новый Чек
           if gnAdm=1.or.gnRks=1
              #ifdef __CLIP__
                 if nchekr=0
                    chekds(1,ssdr)
                 else
                    wmess('Уже распечатан',2)
                 endif
              #else
                 chekds(1,ssdr)
              #endif
           endif
      case lastkey()=-35.and.int(bsr/1000)=301.and.(gnAdm=1.or.gnRks=1.or.gnKto=782) // Коррекция чека
           cldsflt=setcolor('n/w,n/bg')
           wdsflt=wopen(8,20,11,60)
           wbox(1)
           if gnAdm=1.or.gnRks=1
              @ 0,1 say 'N чека' get nchekr pict '999999'
              read
           else
              @ 0,1 say 'N чека'+' '+str(nchekr,6)
           endif
           dokkttn_r=0
           dokkttnr=0
           if prFrmr=1.and.(gnAdm=1.or.gnKto=782)
              dokkttn_r=getfield('t1','mnr,rndr','dokk','dokkttn') // Старая
              dokkttnr=dokkttn_r                                   // Новая
              @ 1,1 say 'ТТН   ' get dokkttnr pict '999999'
              read
           endif
           wclose(wdsflt)
           setcolor(cldsflt)
           if lastkey()=13
              sele dokk
              if netseek('t1','mnr,rndr')
                 do while mn=mnr.and.rnd=rndr
                    netrepl('nchek,nplp','nchekr,nchekr')
                    sele dokk
                    skip
                 endd
              endif
              sele doks
              netrepl('nchek,nplp','nchekr,nchekr')
              crdokkttn(dokkttn_r,dokkttnr)
           endif
      case lastkey()=-5.and.(int(bsr/1000)=301.or.int(bsr/1000)=311) // Переместить
           nddcr=gdTd
           cldsflt=setcolor('n/w,n/bg')
           wdsflt=wopen(8,20,11,60)
           wbox(1)
           @ 0,1 say 'В дату' get nddcr
           read
           wclose(wdsflt)
           setcolor(cldsflt)
           if lastkey()=13.and.!empty(nddcr).and.nddcr#ddcr.and.nddcr>=bom(gdTd).and.nddcr<=eom(gdTd)
              sele dokz
              if netseek('t1','bsr,nddcr')
                 nmnr=mn
                 nrcdokzr=recn()
                 sele doks
                 if netseek('t1','nmnr')
                    do while mn=nmnr
                       nrndr=rnd
                       skip
                       if eof()
                          exit
                       endif
                    endd
                    nrndr=nrndr+1
                 else
                    nrndr=1
                 endif
                 sele doks
                 go rcdoksr
                 netrepl('mn,rnd,ddc','nmnr,nrndr,nddcr')
                 do while .t.
                    sele dokk
                    if netseek('t1','mnr,rndr')
                       docmod('уд',1)
                       netrepl('mn,rnd,ddk','nmnr,nrndr,nddcr')
                       docmod('доб',1)
                       bs_sr=bs_s
                       sele dokz
                       go rcdokzr
                       netrepl('sumd','sumd-bs_sr')
                       go nrcdokzr
                       netrepl('sumd','sumd+bs_sr')
                    else
                       exit
                    endif
                 endd
              endif
           endif
           sele doks
           if netseek('t1','mnr')
              rcdoksr=recn()
           endif
      case lastkey()=-6.and.int(bsr/1000)=301 // Сумма сеанса
           wmess(smsnc(),0)
      case lastkey()=K_F3.and.int(bsr/1000)=301 // Фильтр
           pr169_r=0
           sncr=0
           nplpr=0
           cldsflt=setcolor('n/w,n/bg')
           wdsflt=wopen(8,20,12,60)
           wbox(1)
           @ 0,1 say 'Неподтв 169' get pr169_r pict '9'
           @ 1,1 say 'Ном сеанса ' get sncr pict '999'
           @ 2,1 say 'Ном платежа' get nplpr pict '999999'
           read
           wclose(wdsflt)
           setcolor(cldsflt)
           if pr169_r#0
              fordsr=fords_r+'.and.np169()'
           else
              fordsr=fords_r
           endif
           sele doks
           if fieldpos('snc')#0
              if sncr#0
                 fordsr=fordsr+'.and.snc=sncr'
              endif
           endif
           if nplpr#0
              fordsr=fords_r+'.and.nplp=nplpr'
           else
              fordsr=fords_r
           endif
      case lastkey()=-7.and.prdp() // 169
           wmess('Этот режим недоступен',3)
           loop
           kop169()
      case lastkey()=-8.and.prdp().and.gnEnt=20.and.gnAdm=1 // 169 сп
           wmess('Этот режим недоступен',3)
           loop
           lstr=1
           kop169l()
      case lastkey()=K_ESC // Выход
           exit
      othe
           loop
   endc
endd

******************
func adoksins(p1)
******************
cldoks=setcolor('n/w,n/bg')
wdoks=wopen(6,10,19,70)
wbox(1)
if p1=0
   store 0 to kklr,nplpr,ssdr,tipr,ktor,ssdr,przr
   store 0 to nchekr,nkklr,sncr,ktasr,napr,ktaplr
   store 1 to prFrmr
   store '' to nklr,ndokr,nnkklr,nnapr,nktaplr
   store space(100) to bosnr
   store space(20) to osnr,cnplpr
   sele doks
   if netseek('t1','mnr')
      do while mn=mnr
         rndr=rnd
         skip
         if eof()
            exit
         endif
      endd
      rndr=rndr+1
   else
      rndr=1
   endif
endif

do while .t.
 //   foot('ESC', 'Выход')
   @ 0, 1 SAY 'Рег.N док.'+' '+str(rndr, 6)
   if netseek('t1','doks->mn,doks->rnd','dokk')
      prprovr=1
   else
      prprovr=0
   endif
   if prdp().and.prrmbsr=0
      if p1=0.or.prprovr=0 // Добавить или нет проводок

         //if (int(bsr/1000)=301.or.int(bsr/1000)=311.or.int(bsr/1000)=361) //.and.gnEntrm=0
         if (str(int(bsr/1000),3)$'301,311,361') //.and.gnEntrm=0
            @ 1,1  say 'Формирован' get prFrmr pict '9' valid aprFrm()
            @ 1,col()+1 say '0 - по сумме; 1 - по ТТН'
            read
            if lastkey()=K_ESC
               exit
            endif
         else
            prFrmr=0
         endif
 //         if gnEnt=21
 //            prFrmr=1
 //         endif
         if prFrmr=1
            ssdr=0
         endif
         @ 2, 1 SAY 'Клиент    ' GET kklr pict '9999999' valid akkl()
         read
         if lastkey()=K_ESC
            exit
         endif
         do case
            case prFrmr=0
                 osnr='По сумме'
            case prFrmr=1
                 osnr='По ТТН'
            case prFrmr=2
                 osnr='По 160 касса'
            case prFrmr=3
                 osnr='Авто'
         endc
         if int(bsr/1000)=301
            @ 3,1  say 'Ном сеанса' get sncr pict '999'
            read
            if lastkey()=K_ESC
               exit
            endif
         endif
         if prFrmr=0
            if p1=0
               tipr=1
            endif
            @ 4, 1 SAY 'Тип докум.' GET tipr pict '999' valid atipd()
            @ 4,col()+2 say getfield('t1','tipor,tipr','tipd','ndok')
            read
            if lastkey()=K_ESC
               exit
            endif
         else
            tipr=1
         endif
      else    // Коррекция
         @ 1,1  say 'Формирован'+' '+str(prFrmr,1)
         @ 1,col()+1 say '0 - по сумме; 1 - по ТТН'
         if prFrmr=0
            @ 2, 1 SAY 'Клиент    ' GET kklr pict '9999999' valid akkl()
            read
            if lastkey()=K_ESC
               exit
            endif
         else
            @ 2, 1 SAY 'Клиент    '+' '+str(kklr,7)
         endif
         if int(bsr/1000)=301
            @ 3,1  say 'Ном сеанса' get sncr pict '999'
            read
            if lastkey()=K_ESC
               exit
            endif
         endif
         if prFrmr=0 //.and.int(bsr/1000)#301
            @ 4, 1 SAY 'Тип докум.' GET tipr pict '999' valid atipd()
            @ 4,col()+2 say getfield('t1','tipor,tipr','tipd','ndok')
            read
            if lastkey()=K_ESC
               exit
            endif
         else //
            @ 4, 1 SAY 'Тип докум.'+' '+str(tipr,3)
            @ 4,col()+2 say getfield('t1','tipor,tipr','tipd','ndok')
         endif
      endif
      if prFrmr=0 //.or.prFrmr=3
         @ 5, 1 SAY 'Nдок(плат)' GET nplpr pict '999999'
         @ 5,col()+1 SAY alltrim(cnplpr)
         @ 6, 1 SAY 'Сумма     ' GET ssdr pict '9999999.99'
         @ 7, 1 SAY 'Основание ' GET osnr
         read
         if lastkey()=K_ESC
            exit
         endif

         //ASCAN({301,311,361},int(bsr/1000))#0
         //(int(bsr/1000)=301.or.int(bsr/1000)=311.or.int(bsr/1000)=361)

         if (str(int(bsr/1000),3)$'301,311,361').and.tipr=1 //.and.gnentrm=0
            if fieldpos('nap')=0 // нет поля
              @ 8, 1 say 'Супервайзер' get ktasr pict '9999' valid chkas(ktasr)
            else
              tzdocr=getfield('t1','kklr','kpl','tzdoc')
              if tzdocr=0
                @ 8, 1 say 'Супервайзер' get ktasr pict '9999' valid chkas(ktasr)
              else
                @ 8, 1 say 'Направление' get napr pict '9999' valid adoksnap('napr')
              endif
            endif
            read
            if lastkey()=K_ESC
                exit
            endif
         endif
      else
         @ 7, 1 SAY 'Основание '+' '+osnr
      endif
      sele doks
      if fieldpos('ktapl')#0
         if int(bsr/1000)=301.and.tipr=1 //.and.gnEntrm=0
            @ 9,1 say 'Кто внес' get ktaplr pict '9999' valid ktapl(ktaplr,9)
            @ 9,col()+1 say nktaplr
            read
            if lastkey()=K_ESC
               exit
            endif
         endif
      endif
   else
      @ 1,1  say 'Формирован'+' '+str(prFrmr,1)
      @ 1,col()+1 say '0 - по сумме; 1 - по ТТН'
      @ 2, 1 SAY 'Клиент    '+' '+str(kklr,7)
      @ 2,col()+1 say getfield('t1','kklr','kln','nkl')

      //if (int(bsr/1000)=301.or.int(bsr/1000)=311.or.int(bsr/1000)=361) //.and.gnEntrm=0
      if (str(int(bsr/1000),3)$'301,311,361') //.and.gnEntrm=0
         if int(bsr/1000)=301
            @ 3,1  say 'Ном сеанса'+' '+str(sncr,3)+' N чека '+str(nchekr,6)
         endif
      endif
      @ 4, 1 SAY 'Тип докум.'+' '+str(tipr,3)
      @ 4,col()+2 say getfield('t1','tipor,tipr','tipd','ndok')
      @ 5, 1 SAY 'Nдок(плат)'+' '+str(nplpr,6)
      @ 5,col()+1 SAY alltrim(cnplpr)
      @ 6, 1 SAY 'Сумма     '+' '+str(ssdr,10,2)
      @ 7, 1 SAY 'Основание '+' '+osnr
      if (int(bsr/1000)=301.or.int(bsr/1000)=311).and.tipr=1 //.and.gnEntrm=0
         if fieldpos('nap')=0
            @ 8, 1 say 'Супервайзер'+' '+str(ktasr,4)
         else
            if empty(nap)
               @ 8, 1 say 'Супервайзер'+' '+str(ktasr,4)
            else
               @ 8, 1 say 'Направление'+' '+str(napr,4)
            endif
         endif
      endif
   endif
   if int(bsr/1000)=311 //.and.gnEntrm=0
      if !empty(bosnr)
         @ 9,1 say subs(bosnr,1,50) color 'r/w'
         @ 10,1 say subs(bosnr,51,50) color 'r/w'
      endif
   endif
   if int(bsr/1000)=301.and.tipr=1 //.and.gnEntrm=0
      @ 9,1 say 'Кто внeс'+' '+str(ktaplr,4)+' '+nktaplr
   endif
   @ 11,1 prom 'Верно'
   @ 11,col()+1 prom 'Не верно'
   menu to mdoks
   if lastkey()=K_ESC
      exit
   endif
   if mdoks=1.and.prdp().and.prrmbsr=0
      sele doks
      if p1=0 // Добавить
         if !netseek('t1','mnr,rndr')
            netadd()
            netrepl('mn,rnd,kkl,nplp,ddc,osn,tipo,tip,kto,ssd,prz,ktas','mnr,rndr,kklr,nplpr,ddcr,osnr,tipor,tipr,gnKto,ssdr,przr,ktasr')
            if fieldpos('prFrm')#0
               netrepl('prFrm,nkkl','prFrmr,nkklr')
            endif
            if fieldpos('snc')#0
               netrepl('snc','sncr')
            endif
            if fieldpos('nap')#0
               netrepl('nap','napr')
            endif
            if fieldpos('ktapl')#0
               netrepl('ktapl','ktaplr')
            endif
            rcdoksr=recn()
            if prFrmr=3 // Автопроводки
            endif
         else
            wmess('Этот номер уже занят,повторите',1)
         endif
      else   // Коррекция
         if netseek('t1','mnr,rndr')
            if reclock(1)
               netrepl('kkl,nplp,ddc,osn,tipo,tip,ssd,prz,ktas','kklr,nplpr,ddcr,osnr,tipor,tipr,ssdr,przr,ktasr',1)
               if fieldpos('prFrm')#0
                  netrepl('prFrm,nkkl','prFrmr,nkklr')
               endif
               if fieldpos('snc')#0
                  netrepl('snc','sncr')
               endif
               if fieldpos('nap')#0
                  netrepl('nap','napr')
               endif
               if fieldpos('ktapl')#0
                  netrepl('ktapl','ktaplr')
               endif
               sele dokk
               set orde to tag t12
               if netseek('t12','mnr,rndr')
                  do while mn=mnr.and.rnd=rndr
                     sele dokk
                     docmod('корр',1)
                     msk(0,0)
                     adokk1:={}
                     getrec('adokk1')
                     netrepl('kkl,tip,prz,nplp','kklr,tipr,przr,nplpr',1)
                     netrepl('dtmod,tmmod','date(),time()',1)
                     if fieldpos('nap')#0
                        netrepl('nap','napr',1)
                     endif
                     if fieldpos('ktapl')#0
                        netrepl('ktapl','ktaplr',1)
                     endif
                     netrepl('nchek,nkkl','nchekr,nkklr')
                     msk(1,0)
                     adokk2:={}
                     getrec('adokk2')
                     lfldr=''
                     prmdcorr=0
                     for iput=1 to len(adokk1)
                         if !(field(iput)='BS_D';
                            .or.field(iput)='BS_K';
                            .or.field(iput)='BS_S';
                            .or.field(iput)='DOKKTTN';
                            .or.field(iput)='DOKKSK';
                            .or.field(iput)='KOP';
                            .or.field(iput)='KKL';
                            .or.field(iput)='KTA';
                            .or.field(iput)='NKKL';
                            .or.field(iput)='KTAS')
                            loop
                         endif
                         if adokk1[iput]#adokk2[iput]
                            prmdcorr=1
                            lfldr=field(iput)
                            exit
                         endif
                     next
                     if prmdcorr=1
                        if empty(lfldr)
                           mdall('корр')
                        else
                           mdall(lfldr)
                        endif
                     endif
                     skip
                  enddo
               endif
               sele dokk
               set orde to tag t1
            endif
            sele doks
            netunlock()
         endif
      endif
      exit
   endif
endd
wclose(wdoks)
setcolor(cldoks)
retu .t.
************
func akkl()
************
sele kln
if kklr#0
   if !netseek('t1','kklr')
      kklr=0
   endif
   if kkl1=0
      kklr=0
   endif
endif
if kklr=0
   wselect(0)
   sele kln
   go top
   rcklnr=recn()
   txtr=space(30)
   forklnr='kln->kkl1#0'
   forkln_r=forklnr
   do while .t.
      sele kln
      go rcklnr
      foot('F3','Фильтр')
      rcklnr=slcf('kln',1,,18,,"e:kkl h:'Код' c:n(7) e:nkl h:'Наименование' c:c(30)",,,,,forklnr)
      if lastkey()=K_ESC
         kklr=0
         exit
      endif
      go rcklnr
      kklr=kkl
      if lastkey()=13
         exit
      endif
      do case
         case lastkey()=K_F3 // Фильтр
              aklnflt()
      endc
   endd
   wselect(wdoks)
endif
nklr=getfield('t1','kklr','kln','nkl')
@ 2,20 say nklr
if kklr=0
   retu .f.
else
   retu .t.
endif
*************
func atipd()
*************
prtipr=1
if tipr#0
   sele dokk
   if netseek('t1','mnr,rndr')
      do while mn=mnr.and.rnd=rndr
         if tip#tipr
            prtipr=0
            exit
         endif
         sele dokk
         skip
      endd
   endif
endif
if prtipr=0
   wmess('Удалите проводки',2)
   retu .f.
endif
sele tipd
if tipr#0
   if !netseek('t1','tipor,tipr')
      tipr=0
   endif
endif
if tipr=0
   sele tipd
   go top
   wselect(0)
   tipr=slcf('tipd',,,,,"e:tipo h:'ТО' c:n(2) e:tip h:'Тип' c:n(3) e:ndok h:'Наименование' c:c(30)",'tip',,,,'tipo=tipor')
   wselect(wdoks)
   if lastkey()=K_ESC
      tipr=0
      retu .f.
   endif
endif
if netseek('t1','tipor,tipr')
   ndokr=ndok
   przr=prz
endif
if tipr#0
   sele dokk
   if netseek('t1','mnr,rndr')
      do while mn=mnr.and.rnd=rndr
         if tip#tipr
            prtipr=0
            exit
         endif
         sele dokk
         skip
      endd
   endif
endif
if prtipr=0
   wmess('Удалите проводки',2)
   retu .f.
endif
@ 4,17 say ndokr
retu .t.
**************
func np169()
**************
sele dokk
prnpdocr=0
if netseek('t1','doks->mn,doks->rnd')
   do while mn=doks->mn.and.rnd=doks->rnd
      rcdokkr=recn()
      if dokkttn=0
         skip
         loop
      endif
      dokkttnr=dokkttn
      skr=sk
      if !netseek('t13','skr,dokkttnr,0')
         prnpdocr=1
         exit
      endif
      sele dokk
      go rcdokkr
      skip
   endd
endif
sele doks
if prnpdocr=0
   retu .f.
else
   retu .t.
endif
**************
func kop160()
**************
tipr=1
prFrmr=0
ktasr=0
ktar=0
sncr=0
ktaplr=0
nktaplr=''
prnchkr=0
cl160=setcolor('gr+/b,n/w')
w160=wopen(8,10,15,70)
wbox(1)
sele doks
if gnEntRm=0
   @ 0,1 say 'Без чека' get prnchkr pict '9'
   read
   if lastkey()=K_ESC
      wclose(w160)
      setcolor(cl160)
      retu .t.
   endif
else
   prnchkr=1
   @ 0,1 say 'Без чека'+' '+str(prnchkr,1)
endif
if fieldpos('ktapl')#0
   @ 1,1 say 'Кто внес' get ktaplr pict '9999' valid ktapl(ktaplr,1)
   @ 1,20 say nktaplr
endif
@ 2,1 say 'Ном сеанса ' get sncr pict '999'
read
if lastkey()=K_ESC
   wclose(w160)
   setcolor(cl160)
   retu .t.
endif
if prnchkr=0
   @ 3,1 say 'Агент      ' get ktar pict '9999' valid chkas(ktar)
   read
   if lastkey()=K_ESC
      wclose(w160)
      setcolor(cl160)
      retu .t.
   endif
   @ 3,20 say getfield('t1','ktar','s_tag','fio')
   if ktar#0
      ktasr=getfield('t1','ktar','s_tag','ktas')
      napr=getfield('t1','ktar','ktanap','nap')
      if napr=0.and.ktasr#0
         napr=getfield('t1','ktasr','ktanap','nap')
      endif
   endif

   if ktasr#0
      @ 4,1 say 'Супервайзер'+' '+str(ktasr,4)
      @ 4,20 say getfield('t1','ktasr','s_tag','fio')
   else
      if gnEnt=20
         @ 4,1 say 'Супервайзер' get ktasr pict '9999' valid chkas(ktasr)
         read
         if lastkey()=K_ESC
            wclose(w160)
            setcolor(cl160)
            retu .t.
         endif
         @ 4,20 say getfield('t1','ktasr','s_tag','fio')
         if ktasr#0
            napr=getfield('t1','ktasr','ktanap','nap')
         endif
      endif
   endif
endif
if gnEnt=20
   if napr#0
      @ 5,1 say 'Направление'+' '+str(napr,4)
      @ 5,20 say getfield('t1','napr','nap','nnap')
   else
      @ 5,1 say 'Направление' get napr pict '9999'
      read
      if lastkey()=K_ESC
         wclose(w160)
         setcolor(cl160)
         retu .t.
      endif
      @ 5,20 say getfield('t1','napr','nap','nnap')
   endif
endif
inkey(0)
wclose(w160)
setcolor(cl160)
if lastkey()=K_ESC
   retu .t.
endif

if !(prFrmr=0.or.prFrmr=3)
   wmess('Недопустимый признак формирования',2)
   retu .t.
endif

if select('kop160')#0
   sele kop160
   use
endif
erase kop160.dbf
crtt('kop160','f:kkl c:n(7) f:nkkl c:c(40) f:sm c:n(12,2) f:ktas c:n(4) f:kta c:n(4) f:snc c:n(3) f:nap c:n(4) f:nplp c:n(6)')
sele 0
use kop160
rckop160r=recn()
smir=0
do while .t.
   go rckop160r
   foot('INS,DEL,F4,F6','Добавить,Удалить,Коррекция,Запись')
   if prnchkr=0
      rckop160r=slcf('kop160',,,,,"e:kkl h:'Код' c:n(7) e:nkkl h:'Клиент' c:c(40) e:sm h:'Сумма' c:n(12,2) e:kta h:'Агент' c:n(4) e:ktas h:'Супер' c:n(4) e:nap h:'Напр' c:n(4)",,,1,,,,'Сумма '+str(smir,12,2))
   else
      rckop160r=slcf('kop160',,0,,,"e:kkl h:'Код' c:n(7) e:nkkl h:'Клиент' c:c(40) e:sm h:'Сумма' c:n(12,2) e:nplp h:'N чека' c:n(6) e:nap h:'Напр' c:n(4)",,,1,,,,'Сумма '+str(smir,12,2))
   endif
   if lastkey()=K_ESC
      exit
   endif
   go rckop160r
   kklr=kkl
   nkklr=nkkl
   smr=sm
   ktas_r=ktas
   kta_r=kta
   nap_r=nap
   nplp_r=nplp
   do case
      case lastkey()=22 // Добавить
           netadd()
           rckop160r=recn()
           cr160()
      case lastkey()=7  // Удалить
           netdel()
           skip -1
           if bof()
              go top
           endif
           rckop160r=recn()
           smir=smir-smr
      case lastkey()=-3 // Коррекция
           cr160(1)
      case lastkey()=-5 // Запись
           kop160i()
           exit
   endc
endd
keyboard ''
sele kop160
use
erase kop160.dbf
retu .t.

*************
func cr160(p1)
*************
if empty(p1)
   sm_r=0
   kklr=0
   nkklr=space(40)
   smr=0
   if ktasr#0
      ktas_r=ktasr
   endif
   if ktar#0
      kta_r=ktar
   endif
   if napr#0
      nap_r=napr
   endif
   nplp_r=0
   trwr=row()+1
else
   sm_r=smr
   trwr=row()
endif
do while .t.
   @ trwr,1 get kklr pict '9999999' color 'r/w'
   read
   if lastkey()=K_ESC
      exit
   endif
   if kklr=20034
      exit
   endif
   if getfield('t1','kklr','kln','kkl1')=0
      wmess('Это не плательщик',2)
      kklr=0
      loop
   endif
   nkklr=getfield('t1','kklr','kln','nkl')
   nkklr=subs(nkklr,1,40)
   tzdocr=getfield('t1','kklr','kpl','tzdoc')
   if tzdocr=0
      nap_r=0
   else
      nap_r=napr
   endif
   @ trwr,9 say nkklr color 'r/w'
   if prnchkr=0
      @ trwr,64 say str(kta_r,4)  color 'n/w'
      @ trwr,70 say str(ktas_r,4) color 'n/w'
      @ trwr,75 say str(nap_r,4)  color 'n/w'
      @ trwr,50 get sm_r pict '999999999.99' color 'r/w'
   else
      @ trwr,50 get sm_r pict '999999999.99' color 'r/w'
      @ trwr,63 say str(nplp_r,6)  color 'n/w'
      @ trwr,70 say str(nap_r,4)  color 'n/w'
   endif
   read
   if lastkey()=K_ESC
      exit
   endif
   if prnchkr=0
      if tzdocr=0
         if gnEnt=21
            @ trwr,64 get kta_r valid chkas(kta_r) pict '9999' color 'r/w'
            read
            if lastkey()=K_ESC
               exit
            endif
            @ trwr,64 say str(kta_r,4)  color 'n/w'
            ktas_r=getfield('t1','kta_r','s_tag','ktas')
            @ trwr,70 say str(ktas_r,4) color 'n/w'
         endif
 //      @ trwr,70 get ktas_r valid chkas(ktas_r) pict '9999' color 'r/w'
 //      read
 //      nap_r=0
 //      if lastkey()=K_ESC
 //         exit
 //      endif
      else
         @ trwr,64 get kta_r valid chkas(kta_r) pict '9999' color 'r/w'
         read
         if lastkey()=K_ESC
            exit
         endif
         nap_r=getfield('t1','kta_r','ktanap','nap')
         ktas_r=getfield('t1','kta_r','s_tag','ktas')
         if nap_r=0
            nap_r=getfield('t1','ktas_r','ktanap','nap')
         endif
         if ktas_r=0
            @ trwr,70 get ktas_r valid chkas(ktas_r) pict '9999' color 'r/w'
            read
            if lastkey()=K_ESC
               exit
            endif
            @ trwr,70 say str(ktas_r,4) color 'n/w'
         else
            @ trwr,70 say str(ktas_r,4) color 'n/w'
         endif
         if nap_r=0
            @ trwr,75 get nap_r pict '9999' color 'r/w' valid adoksnap('nap_r')
            read
            if lastkey()=K_ESC
               exit
            endif
            @ trwr,75 say str(nap_r,4)  color 'n/w'
         else
            @ trwr,75 say str(nap_r,4)  color 'n/w'
         endif
      endif
   else
      @ trwr,63 get nplp_r pict '999999' color 'r/w'
      @ trwr,70 get nap_r pict '9999' color 'r/w'
      read
      if lastkey()=K_ESC
         exit
      endif
      @ trwr,64 say str(nplp_r,6)
      @ trwr,70 say str(nap_r,4)
   endif
   sele kop160
   if lastkey()=13
      if prnchkr=0
         if gnEnt=20
            if nap_r#0
               netrepl('kkl,nkkl,sm,snc,kta,ktas,nap','kklr,nkklr,sm_r,sncr,kta_r,ktas_r,nap_r')
            else
               netrepl('kkl,nkkl,sm,snc','kklr,nkklr,sm_r,sncr')
            endif
         else
            netrepl('kkl,nkkl,sm,snc,kta,ktas','kklr,nkklr,sm_r,sncr,kta_r,ktas_r')
         endif
      else
         netrepl('kkl,nkkl,sm,snc,kta,ktas,nplp,nap','kklr,nkklr,sm_r,sncr,kta_r,ktas_r,nplp_r,nap_r')
      endif
      smir=smir-smr+sm_r
      smr=sm_r
      exit
   endif
endd
retu .t.
****************
func kop160i()
****************
if prFrmr=0
   sele kop160
   go top
   frcr=0
   do while !eof()
      kklr=kkl
      if kklr=0
         skip
         loop
      endif
      ktasr=ktas
      ktar=kta
      smr=sm
      napr=nap
      nplpr=nplp
      sele doks
      if netseek('t1','mnr')
         do while mn=mnr
            rndr=rnd
            skip
            if eof()
               exit
            endif
         endd
         rndr=rndr+1
      else
         rndr=1
      endif
      if prnchkr=0
         nplpr=0
      endif
      osnr='Касса 160 сумма'
      ssdr=smr
      tipr=1
      sele tipd
      if netseek('t1','tipor,tipr')
         przr=prz
      endif
      sele doks
      netadd()
      if frcr=0
         frcr=1
         rcdoksr=recn()
      endif
      netrepl('mn,rnd,kkl,nplp,ddc,osn,tipo,tip,kto,ssd,prz,ktas','mnr,rndr,kklr,nplpr,ddcr,osnr,tipor,tipr,gnKto,ssdr,przr,ktasr')
      if fieldpos('snc')#0
         netrepl('snc,prFrm','sncr,prFrmr')
      endif
      if fieldpos('nap')#0
         netrepl('nap','napr')
      endif
      if fieldpos('ktapl')#0
         netrepl('ktapl','ktaplr')
      endif
      sele dokk
      if netseek('t1','mnr,rndr,kklr')
         do while mn=mnr.and.rnd=rndr.and.kkl=kklr
            rnr=rn
            skip
            if eof()
               exit
            endif
         endd
         rnr=rnr+1
      else
         rnr=1
      endif
      do case
         case gnRmsk=0
              bs_dr=301001
              sklr=83
         case gnRmsk=3
              bs_dr=301003
              sklr=83
         case gnRmsk=4
              bs_dr=301004
              sklr=83
         case gnRmsk=5
              bs_dr=301005
              sklr=83
         case gnRmsk=6
              bs_dr=301006
              sklr=83
      endc
      bs_kr=361001
      sele operb
      locate for db=bs_dr.and.kr=bs_kr
      kopr=kop
      dokkmskr=mask
      bs_sr=smr
      sele dokk
      netadd()
      netrepl('rn,nplp,ddk,bs_d,bs_k,bs_s,skl,kop,kg,tdc,ddc',;
              'rnr,nplpr,ddcr,bs_dr,bs_kr,bs_sr,sklr,kopr,gnKto,time(),date()',1)
      if gnEntrm=1
         netrepl('rmsk','gnRmsk',1)
      endif
      netrepl('dokkmsk','dokkmskr',1)
      netrepl('dtmod,tmmod','date(),time()',1)
      netrepl('mn,rnd,kkl','mnr,rndr,kklr',1)
      netrepl('bs_o,ddo,tip','bsr,ddcr,tipr',1)
      if fieldpos('nap')#0
         netrepl('nap','napr',1)
      endif
      if fieldpos('ktapl')#0
         netrepl('ktapl','ktaplr',1)
      endif
      netrepl('tipo,prz,ktas,kta','tipor,przr,ktasr,ktar')
      if bs_dr=bsr.or.bs_kr=bsr
         sele dokz
         if netseek('t1','bsr,ddcr')
            if bs_dr=bsr.or.bs_kr=bsr
               if bs_dr=bsr
                  netrepl('sumd','sumd+bs_sr')
               endif
               if bs_kr=bsr
                  netrepl('sumk','sumk+bs_sr')
               endif
               sumdr=sumd
               sumkr=sumk
            endif
         endif
      endif
      sele dokk
      docmod('доб',1)
      mdall('доб')
      msk(1,0)
      sele kop160
      skip
   endd
else // prFrmr=3
   sele kop160
   go top
   frcr=0
   do while !eof()
      kklr=kkl
      ktasr=ktas
      smr=sm
      sele doks
      if netseek('t1','mnr')
         do while mn=mnr
            rndr=rnd
            skip
            if eof()
               exit
            endif
         endd
         rndr=rndr+1
      else
         rndr=1
      endif
      nplpr=0
      osnr='Касса 160 ТТН авто'
      ssdr=smr
      tipr=1
      sele tipd
      if netseek('t1','tipor,tipr')
         przr=prz
      endif
      sele doks
      netadd()
      if frcr=0
         frcr=1
         rcdoksr=recn()
      endif
      netrepl('mn,rnd,kkl,nplp,ddc,osn,tipo,tip,kto,ssd,prz','mnr,rndr,kklr,nplpr,ddcr,osnr,tipor,tipr,gnKto,ssdr,przr')
      if fieldpos('snc')#0
         netrepl('snc,prFrm','sncr,prFrmr')
      endif
      if fieldpos('ktapl')#0
         netrepl('ktapl','ktaplr')
      endif
      sele kop160
      skip
   endd
endif
retu .t.

func smsnc()
sele doks
rc_r=recn()
if fieldpos('snc')=0
   retu ''
else
   if snc=0
      retu ''
   else
      if netseek('t1','mnr')
         sm_r=0
         do while mn=mnr
            if snc#sncr
               skip
               loop
            endif
            sm_r=sm_r+ssd
            sele doks
            skip
         endd
         if sm_r=0
            go rc_r
            retu ''
         else
            go rc_r
            retu str(sm_r,12,2)
         endif
      else
         retu ''
      endif
   endif
endif
retu ''

******************************************
func adokki(p1)
 // Добавление в DOKK по готовым переменным
 // p1=1 Коррекция всех
******************************************

if int(bsr/1000)=301.and.(prrmbsr=0.or.!empty(p1)).or.int(bsr/1000)#301.or.int(bsr/1000)#361
   sele dokk
   if netseek('t1','mnr,rndr,kklr')
      do while mn=mnr.and.rnd=rndr.and.kkl=kklr
          rnr=rn
          skip
      endd
      rnr=rnr+1
   else
      rnr=1
   endif
   sele dokk
   netadd(1)
   rcdokkr=recn()
   netrepl('rn,nplp,ddk,bs_d,bs_k,bs_s,skl,kop,kg,tdc,ddc',;
           'rnr,nplpr,ddcr,bs_dr,bs_kr,bs_sr,sklr,kopr,gnKto,time(),date()',1)
   if p1==nil
      if gnEntrm=1
         netrepl('rmsk','gnRmsk',1)
      endif
   else
      netrepl('rmsk','rmskr',1)
   endif
 //   netrepl('ndspst,ndspstc,dndspst','ndspstr,ndspstcr,dndspstr',1)
   netrepl('dokkmsk','dokkmskr',1)
   netrepl('dtmod,tmmod','date(),time()',1)
   netrepl('mn,rnd,kkl','mnr,rndr,kklr',1)
   netrepl('bs_o,ddo,tip','bsr,ddcr,tipr',1)
   netrepl('tipo,prz,kta,ktas,sk,dokkttn,nkkl','tipor,przr,ktar,ktasr,skr,dokkttnr,nkklr')
   docmod('доб',1)
   mdall('доб')
   if bs_dr=bsr.or.bs_kr=bsr
      sele dokz
      if netseek('t1','bsr,ddcr')
         if bs_dr=bsr.or.bs_kr=bsr
            if bs_dr=bsr
               netrepl('sumd','sumd+bs_sr')
            endif
            if bs_kr=bsr
               netrepl('sumk','sumk+bs_sr')
            endif
            sumdr=sumd
            sumkr=sumk
         endif
         sele dokk
         msk(1,0)
      endif
   endif
   sele doks
endif
retu .t.

**************
func aprFrm()
  **************
  if int(bsr/1000)=301
    if prFrmr>1
        prFrmr=0
        retu .f.
    endif
  endif
  if int(bsr/1000)=311
    if prFrmr>1.or.prFrmr>3
        prFrmr=0
        retu .f.
    endif
  endif
  #ifdef __CLIP__
  // if gnEntrm=0
      if prFrmr>1
         prFrmr=0
         retu .f.
      endif
  // else
  //    if prFrmr#0
  //       prFrmr=0
  //       retu .f.
  //    endif
  // endif
  #else
   if prFrmr=2
      prFrmr=0
      retu .f.
   endif
  #endif
  retu .t.

****************
func adoksnap(p1)
****************
cnapr=p1
if tzdocr=0
   &cnapr=0
   retu .t.
endif
widr=wselect()
wselect(0)
if &cnapr#0
   if !netseek('t1',cnapr,'nap')
      &cnapr=0
   endif
endif
ret_r=.t.
if &cnapr=0
   sele nap
   go top
   rcnapr=recn()
   do while .t.
      sele nap
      go rcnapr
      foot('','')
      rcnapr=slcf('nap',,,,,"e:nap h:'Код' c:n(4) e:nnap h:'Наименование' c:c(20)",,,,,,,'Направления')
      if lastkey()=K_ESC
         wmess('Нет направления',2)
         ret_r=.f.
         exit
      endif
      go rcnapr
      &cnapr=nap
      nnapr=nnap
      do case
         case lastkey()=13
              ret_r=.t.
              exit
      endc
   endd
endif
wselect(widr)
keyboard ''
retu ret_r

**************************************

**************
func kop169()
**************
do case
   case gnEnt=20
        do case
           case bsr=301001
                skr=228
           case bsr=301003
                skr=300
           case bsr=301004
                skr=400
           case bsr=301005
                skr=500
           case bsr=301006
                skr=600
        endc
   case gnEnt=21
        do case
           case bsr=301001
                skr=232
           case bsr=301004
                skr=700
        endc
endc
sklr=83
dokkskr=skr
tipr=1
prFrmr=1
kklr=20034
ktasr=0
ktar=0
sncr=0
dokkttnr=0
ktaplr=0
nktaplr=''
bs_kr=361001
bs_dr=bsr
sele operb
locate for db=bs_dr.and.kr=bs_kr
kopr=kop
nopr=nop
dokkmskr=mask

cl169=setcolor('gr+/b,n/w')
w169=wopen(8,15,16,65)
wbox(1)
*@ 0,1 say 'Супервайзер' get ktasr pict '9999' valid chkas(ktasr)
sele doks
if fieldpos('ktapl')#0
   @ 0,1 say 'Кто внес' get ktaplr pict '9999' valid ktapl(ktaplr,0)
   @ 0,col()+1 say nktaplr
endif
@ 1,1 say 'КОП        '+' '+str(kopr,4)+' '+nopr
@ 2,1 say 'Ном сеанса ' get sncr pict '999'
if gnEnt=20
   @ 3,1 say 'Направление' get napr pict '9999'
   if gnAdm=1
      @ 4,1 say 'Из списка  ' get lstr pict '9'
   endif
   read
   if gnAdm=1.and.lstr=1
      @ 4,1 say 'Файл       ' get aflr
      read
   endif
endif
wclose(w169)
setcolor(cl169)
if lastkey()=K_ESC
   retu .t.
endif

if select('kop169')#0
   sele kop169
   use
endif
erase kop169.dbf
crtt('kop169','f:dokksk c:n(3) f:dokkttn c:n(6) f:sm c:n(12,2) f:ktas c:n(4) f:kta c:n(4) f:nkta c:c(15) f:snc c:n(3) f:nap c:n(4)')
sele 0
use kop169 excl
inde on str(dokksk,3)+str(dokkttn,6) tag t1
set orde to
rckop169r=recn()
smir=0
do while .t.
   sele kop169
   set orde to
   go rckop169r
   foot('INS,DEL,F6','Добавить,Удалить,Запись')
   rckop169r=slcf('kop169',,0,,,"e:dokkttn h:'ТТН' c:n(6) e:sm h:'Сумма' c:n(12,2) e:ktas h:'Супер' c:n(4) e:kta h:'Агент' c:n(4) e:nkta h:'Фамилия' c:c(15) e:nap h:'Напр' c:n(4)",,,1,,,,'Сумма '+str(smir,12,2))
   if lastkey()=K_ESC
      exit
   endif
   go rckop169r
   smr=sm
   do case
      case lastkey()=22 // Добавить
           rckop169r=recn()
           cr169()
      case lastkey()=7  // Удалить
           netdel()
           skip -1
           if bof()
              go top
           endif
           rckop169r=recn()
           smir=smir-smr
      case lastkey()=-5 // Запись
           kop169i()
           exit
   endc
endd
keyboard ''
sele kop169
use
erase kop169.dbf
retu .t.

*************
func cr169(p1)
*************
if empty(p1)
   dokkttnr=0
   smr=0
   ktasr=ktasr
   ktar=ktar
   nktar=space(15)
   if napr#0
      nap_r=napr
   endif
   trwr=row()+1
else
   smr=smr
   trwr=row()
endif
do while .t.
   @ trwr,1 get dokkttnr pict '999999' valid attn169i() color 'r/w'
   read
   if lastkey()=K_ESC
      exit
   endif
   tzdocr=getfield('t1','kklr','kpl','tzdoc')
 //   if tzdocr=0
 //      nap_r=0
 //   else
      nap_r=napr
 //   endif
   @ trwr,8 say str(smr,12,2)  color 'n/w'
   @ trwr,22 say str(ktasr,4) color 'n/w'
   @ trwr,28 say str(ktar,4)  color 'n/w'
   @ trwr,33 say subs(nktar,1,15)  color 'n/w'
   if tzdocr=0
      @ trwr,49 say str(nap_r,4)  color 'n/w'
   else
      if nap_r=0
         @ trwr,49 get nap_r pict '9999' color 'r/w' valid adoksnap('nap_r')
         read
         if lastkey()=K_ESC
            exit
         endif
      else
         @ trwr,49 say str(nap_r,4)  color 'n/w'
      endif
   endif
   sele kop169
   if lastkey()=13
      netadd()
      netrepl('dokksk,dokkttn,sm,snc,ktas,kta,nkta,nap','dokkskr,dokkttnr,smr,sncr,ktasr,ktar,nktar,nap_r')
      rckop169r=recn()
      smir=smir+smr
      exit
   endif
endd
retu .t.

****************
func kop169i()
****************
sele kop169
set orde to
go top
frcr=0
do while !eof()
   dokkttnr=dokkttn
   dokkskr=dokksk
   bs_sr=sm
   ssdr=sm
   ktar=kta
   ktasr=ktas
   napr=nap
   rnr=1
   sele doks
   if netseek('t1','mnr')
      do while mn=mnr
         rndr=rnd
         skip
         if eof()
            exit
         endif
      endd
      rndr=rndr+1
   else
      rndr=1
   endif
   nplpr=0
   osnr='По ТТН'
   sele tipd
   if netseek('t1','tipor,tipr')
      przr=prz
   endif
   sele doks
   netadd()
   if frcr=0
      frcr=1
      rcdoksr=recn()
   endif
   netrepl('mn,rnd,kkl,nplp,ddc,osn,tipo,tip,kto,ssd,prz','mnr,rndr,kklr,nplpr,ddcr,osnr,tipor,tipr,gnKto,ssdr,przr')
   netrepl('snc,prFrm','sncr,prFrmr')
   if fieldpos('ktapl')#0
      netrepl('ktapl','ktaplr')
   endif
   sele dokk
   netadd()
   netrepl('rn,nplp,ddk,bs_d,bs_k,bs_s,skl,kop,kg,tdc,ddc',;
           'rnr,nplpr,ddcr,bs_dr,bs_kr,bs_sr,sklr,kopr,gnKto,time(),date()',1)
   if gnEntrm=1
      netrepl('rmsk','gnRmsk',1)
   endif
   netrepl('dokkmsk','dokkmskr',1)
   netrepl('dtmod,tmmod','date(),time()',1)
   netrepl('mn,rnd,rn,kkl','mnr,rndr,rnr,kklr',1)
   netrepl('bs_o,ddo,tip','bsr,ddcr,tipr',1)
   netrepl('nap,dokksk,dokkttn,sk','napr,dokkskr,dokkttnr,dokkskr',1)
   if fieldpos('ktapl')#0
      netrepl('ktapl','ktaplr',1)
   endif
   netrepl('tipo,prz,ktas,kta','tipor,przr,ktasr,ktar')
   if bs_dr=bsr.or.bs_kr=bsr
      sele dokz
      if netseek('t1','bsr,ddcr')
         if bs_dr=bsr.or.bs_kr=bsr
            if bs_dr=bsr
               netrepl('sumd','sumd+bs_sr')
            endif
            if bs_kr=bsr
               netrepl('sumk','sumk+bs_sr')
            endif
            sumdr=sumd
            sumkr=sumk
         endif
      endif
   endif
   sele dokk
   docmod('доб',1)
   mdall('доб')
   msk(1,0)
   sele kop169
   skip
endd
retu .t.

*****************
func attn169i()
*****************
if skr=0
   wmess('Не удалось определить склад',2)
   retu .f.
else
   dirdr=alltrim(getfield('t1','skr','cskl','path'))
   ggr=0
   prfndr=0
   if dokkttnr#0
      if kklr=20034
         gg2r=year(gdTd)
      else
         gg2r=2006
      endif
      for ggr=year(gdTd) to gg2r step -1
          do case
             case ggr=year(gdTd)
                  mm1r=month(gdTd)
                  mm2r=1
             case ggr=2006
                  mm1r=12
                  mm2r=9
             othe
                  mm1r=12
                  mm2r=1
          endc
          for mmr=mm1r to mm2r step -1
              pathr=gcPath_e+'g'+str(ggr,4)+'\m'+iif(mmr<10,'0'+str(mmr,1),str(mmr,2))+'\'+dirdr
              if !netfile('rs1',1)
                 loop
              endif
              netuse('rs1',,,1)
              if !netseek('t1','dokkttnr')
                 nuse('rs1')
                 loop
              else
                 prfndr=1
                 exit
              endif
          next
          if prfndr=1
             exit
          endif
      next
   endif

   if select('rs1')=0
      ggr=0
      dokkttnr=0
      pathr=gcPath_d+dirdr
      if !netfile('rs1',1)
         wmess('Нет склада '+pathr,2)
         retu .f.
      else
         netuse('rs1',,,1)
      endif
   endif

   if dokkttnr#0
      if !netseek('t1','dokkttnr')
         wmess('ТТН '+str(dokkttnr,6)+' Нет в складе',2)
         dokkttnr=0
      else
         if kpl#kklr
            wmess(str(dokkttnr,6)+' '+'Не совпадает клиент',2)
            dokkttnr=0
         else
            sele dokk
            if !netseek('t9','skr,dokkttnr')
               sele kop169
               if !netseek('t1','skr,dokkttnr')
                  sele rs1
                  ktar=kta
                  ktasr=ktas
                  smr=sdv
 //                  if lstr=1
                     napr=nap
                     if napr=0
                        napr=dfnap(ktar)
                     endif
 //                  endif
               else
                  wmess('ТТН '+str(dokkttnr,6)+' Уже отобрана',2)
                  dokkttnr=0
               endif
            else
               if dokkttnr=dokk->dokkttn.and.int(bsr/1000)#361
                  wmess('ТТН '+str(dokkttnr,6)+' Уже оплачена '+dtoc(dokk->ddk)+' '+alltrim(str(dokk->rnd,6)),3)
                  dokkttnr=0
               endif
            endif
         endif
      endif
   endif

   if dokkttnr=0.and.lstr=0
      wselect(0)
      sele rs1
      go top
      rcrs1r=recn()
      do while .t.
         sele rs1
         go rcrs1r
         zagr='ТТН'+' '+iif(ggr=0,dtos(gdTd),str(ggr,4)+iif(mmr<10,'0'+str(mmr,1)+'01',str(mmr,2)+'01'))
         rcrs1r=slcf('rs1',,,,,"e:ttn h:'ТТН' c:n(6) e:kop h:'КОП' c:n(3) e:prz h:'П' c:n(1) e:dop h:'ДатаО' c:d(10) e:sdv h:'Сумма' c:n(10,2) e:kta h:'КодА' c:n(4) e:getfield('t1','rs1->kta','s_tag','fio') h:'ФИО' c:c(15) e:ktas h:'КодC' c:n(4) e:nap h:'Напр' c:n(4)",,,,,"kpl=kklr.and.sdv#0.and.!netseek('t1','skr,rs1->ttn','kop169').and.!netseek('t9','skr,rs1->ttn','dokk').and.!empty(dop).and.rs1->kop=169.and.rs1->kpl=kklr",,zagr)
         if lastkey()=K_ESC
            dokkttnr=0
            exit
         endif
         if lastkey()=13
            go rcrs1r
            dokkttnr=ttn
            ktar=kta
            ktasr=ktas
            smr=sdv
            napr=nap
            exit
        endif
      endd
      wselect(p1)
      if dokkttnr=0
         nuse('rs1')
         retu .f.
      endif
   else
      if lstr=0
         nuse('rs1')
 //         retu .f.
      endif
   endif
   nktar=getfield('t1','ktar','s_tag','fio')
   nuse('rs1')
endif
retu .t.

********************
func ktapl(p1,p2)
********************
ktaplr=p1
nktaplr=getfield('t1','ktaplr','s_tag','fio')
@ p2,1 say 'Кто внес'+' '+str(ktaplr,4)+' '+nktaplr
retu .t.

**************
func kop169l()
**************
do case
   case gnEnt=20
        do case
           case bsr=301001
                skr=228
                aflr='zensdva0'
           case bsr=301003
                skr=300
                aflr='zensdva3'
           case bsr=301004
                skr=400
                aflr='zensdva4'
           case bsr=301005
                skr=500
                aflr='zensdva5'
           case bsr=301006
                skr=600
                aflr='zensdva6'
        endc
   case gnEnt=21
        do case
           case bsr=301001
                skr=232
           case bsr=301004
                skr=700
        endc
endc
sklr=83
dokkskr=skr
tipr=1
prFrmr=0
kklr=20034
ktasr=0
ktar=0
sncr=0
dokkttnr=0
ktaplr=0
nktaplr=''
bs_kr=361001
bs_dr=bsr
sele operb
locate for db=bs_dr.and.kr=bs_kr
kopr=kop
nopr=nop
dokkmskr=mask

cl169=setcolor('gr+/b,n/w')
w169=wopen(8,15,16,65)
wbox(1)
sele doks
if fieldpos('ktapl')#0
   @ 0,1 say 'Кто внес' get ktaplr pict '9999' valid ktapl(ktaplr,0)
   @ 0,col()+1 say nktaplr
endif
@ 1,1 say 'КОП        '+' '+str(kopr,4)+' '+nopr
@ 2,1 say 'Ном сеанса ' get sncr pict '999'
if gnEnt=20
   @ 3,1 say 'Направление' get napr pict '9999'
   @ 4,1 say 'Файл       ' get aflr
   read
endif
wclose(w169)
setcolor(cl169)
if lastkey()=K_ESC
   retu .t.
endif

if select('kop169')#0
   sele kop169
   use
endif
erase kop169.dbf
if !file(aflr+'.dbf')
   wmess('Нет файла',2)
   retu .t.
endif
sele 0
use (aflr) alias zensdv
crtt('kop169','f:dokksk c:n(3) f:dokkttn c:n(6) f:sm c:n(12,2) f:ktas c:n(4) f:kta c:n(4) f:nkta c:c(15) f:snc c:n(3) f:nap c:n(4)')
sele 0
use kop169 excl
inde on str(dokksk,3)+str(dokkttn,6) tag t1
smir=0
cr169l()
sele kop169
set orde to
go top
rckop169r=recn()
do while .t.
   sele kop169
   set orde to
   go rckop169r
   foot('DEL,F6','Удалить,Запись')
   rckop169r=slcf('kop169',,0,,,"e:dokkttn h:'ТТН' c:n(6) e:sm h:'Сумма' c:n(12,2) e:ktas h:'Супер' c:n(4) e:kta h:'Агент' c:n(4) e:nkta h:'Фамилия' c:c(15) e:nap h:'Напр' c:n(4)",,,1,,,,'Сумма '+str(smir,12,2))
   if lastkey()=K_ESC
      exit
   endif
   go rckop169r
   smr=sm
   do case
      case lastkey()=22 // Добавить
      case lastkey()=7  // Удалить
           netdel()
           skip -1
           if bof()
              go top
           endif
           rckop169r=recn()
           smir=smir-smr
      case lastkey()=-5 // Запись
           kop169il()
           exit
   endc
endd
if select('zensdv')#0
   sele zensdv
   use
endif
keyboard ''
sele kop169
use
erase kop169.dbf
retu .t.

*************
func cr169l()
 // По сумме
*************
dokkttnr=0
smr=0
ktasr=0
ktar=0
nktar=space(15)
sele zensdv
go top
do while !eof()
   if nsdv=0
      skip
      loop
   endif
   dokkttnr=ttn
   if attn169i()
      sele kop169
      if recc()=0
         netadd()
 //         netrepl('dokksk,dokkttn,sm,snc,ktas,kta,nkta,nap','dokkskr,dokkttnr,smr,sncr,ktasr,ktar,nktar,napr')
         netrepl('sm,snc','smr,sncr')
      else
         go top
         netrepl('sm','sm+smr')
      endif
      smir=smir+smr
   endif
   sele zensdv
   skip
endd
retu .t.

****************
func kop169il()
****************
sele doks
if netseek('t1','mnr')
   do while mn=mnr
      rndr=rnd
      skip
      if eof()
         exit
      endif
   endd
   rndr=rndr+1
else
   rndr=1
endif
ssdr=smir
nplpr=0
osnr='По Сумме'
sele tipd
if netseek('t1','tipor,tipr')
   przr=prz
endif
sele doks
netadd()
rcdoksr=recn()
netrepl('mn,rnd,kkl,nplp,ddc,osn,tipo,tip,kto,ssd,prz','mnr,rndr,kklr,nplpr,ddcr,osnr,tipor,tipr,gnKto,ssdr,przr')
netrepl('snc,prFrm','sncr,prFrmr')
if fieldpos('ktapl')#0
   netrepl('ktapl','ktaplr')
endif

sele kop169
set orde to
go top
rnr=1
do while !eof()
   dokkttnr=dokkttn
   dokkskr=dokksk
   bs_sr=sm
   ktar=kta
   ktasr=ktas
   napr=nap
   sele dokk
   netadd()
   netrepl('rn,nplp,ddk,bs_d,bs_k,bs_s,skl,kop,kg,tdc,ddc',;
           'rnr,nplpr,ddcr,bs_dr,bs_kr,bs_sr,sklr,kopr,gnKto,time(),date()',1)
   if gnEntrm=1
      netrepl('rmsk','gnRmsk',1)
   endif
   netrepl('dokkmsk','dokkmskr',1)
   netrepl('dtmod,tmmod','date(),time()',1)
   netrepl('mn,rnd,rn,kkl','mnr,rndr,rnr,kklr',1)
   netrepl('bs_o,ddo,tip','bsr,ddcr,tipr',1)
   netrepl('nap,dokksk,dokkttn,sk','napr,dokkskr,dokkttnr,dokkskr',1)
   if fieldpos('ktapl')#0
      netrepl('ktapl','ktaplr',1)
   endif
   netrepl('tipo,prz,ktas,kta','tipor,przr,ktasr,ktar')
   rnr=rnr+1
   if bs_dr=bsr.or.bs_kr=bsr
      sele dokz
      if netseek('t1','bsr,ddcr')
         if bs_dr=bsr.or.bs_kr=bsr
            if bs_dr=bsr
               netrepl('sumd','sumd+bs_sr')
            endif
            if bs_kr=bsr
               netrepl('sumk','sumk+bs_sr')
            endif
            sumdr=sumd
            sumkr=sumk
         endif
      endif
   endif
   sele dokk
   docmod('доб',1)
   mdall('доб')
   msk(1,0)
   sele kop169
   skip
endd
retu .t.

**********************
func crdokkttn(p1,p2)
 // p1 - старая ТТН dokkttn_r
 // p2 - новая  ТТН dokkttnr
**********************
local ttnor,ttnnr
ttnor=p1
ttnnr=p2
 // Найти новую
do case
   case gnEnt=20
        do case
           case bsr=301001.or.bsr=361001.or.bsr=361002
                skr=228
           case bsr=301003
                skr=300
           case bsr=301004
                skr=400
           case bsr=301005
                skr=500
           case bsr=301006
                skr=600
        endc
   case gnEnt=21
        do case
           case bsr=301001.or.bsr=361001.or.bsr=361002
                skr=232
           case bsr=301004
                skr=700
        endc
endc

dokkskr=skr
if skr=0
   wmess('Не удалось определить склад',2)
   retu .f.
else
   dirdr=alltrim(getfield('t1','skr','cskl','path'))
   ggr=0
   prfndr=0
   docprdr=ctod('')
   if dokkttnr#0
      if kklr=20034
         gg2r=year(gdTd)
      else
         gg2r=2006
      endif
      for ggr=year(gdTd) to gg2r step -1
          do case
             case ggr=year(gdTd)
                  mm1r=month(gdTd)
                  mm2r=1
             case ggr=2006
                  mm1r=12
                  mm2r=9
             othe
                  mm1r=12
                  mm2r=1
          endc
          for mmr=mm1r to mm2r step -1
              pathr=gcPath_e+'g'+str(ggr,4)+'\m'+iif(mmr<10,'0'+str(mmr,1),str(mmr,2))+'\'+dirdr
              if !netfile('rs1',1)
                 loop
              endif
              netuse('rs1','rs1opl',,1)
              if !netseek('t1','dokkttnr')
                 nuse('rs1opl')
                 loop
              else
                 prfndr=1
                 docprdr=ctod('01.'+iif(mmr<10,'0'+str(mmr,1),str(mmr,2))+'.'+str(ggr,4))
                 exit
              endif
          next
          if prfndr=1
             exit
          endif
      next
   endif

   if select('rs1opl')=0
      wmess('Нет найдена ',2)
      retu .f.
   endif
   if rs1opl->kpl#kklr
      wmess('Не совпадает клиент',2)
      retu .f.
   endif
   sdor=getfield('t1','mnr,rndr','dokk','bs_s')
   docprd_r=getfield('t1','mnr,rndr','dokk','docprd')
   sele rs1opl
   netrepl('sdo','sdo+sdor')

   if bom(docprd_r)=bom(docprdr)
      sele rs1opl
      if netseek('t1','dokkttn_r')
         netrepl('sdo','sdo-sdor')
      endif
   else
      nuse('rs1opl')
      pathmr=gcPath_e+'g'+str(year(docprd_r),4)+'\m'+iif(month(docprd_r)<10,'0'+str(month(docprd_r),1),str(month(docprd_r),2))+'\'
      sele cskl
      locate for sk=dokkskr
      pathr=pathmr+alltrim(path)
      if netfile('rs1',1)
         netuse('rs1','rs1opl',,1)
         if netseek('t1','dokkttn_r')
            netrepl('sdo','sdo-sdor')
         endif
      endif
   endif
   nuse('rs1opl')
   sele dokk
   if netseek('t1','mnr,rndr')
      netrepl('dokkttn,docprd','dokkttnr,docprdr')
   endif
endif
retu .t.
