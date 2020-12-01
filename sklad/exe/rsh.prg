#include "common.ch"
#include "inkey.ch"
******  РАСХОД (Товар) *************
LOCAL cTopHead_TOVAR
LOCAL lPere, aRecTRs2, ln_gcName
PRIVATE ZenPr, ln_who
lPere:=.F.
ZenPr:=0
SpoofMode := .F.

skr=gnSk
rmskr=gnRmsk
entr=gnEnt
ctovr=gnCtov


store 0 to pr13r,pr14r // Признаки налога на виноград
skttnr=0 // Переменная для сохранения set key

store 0 to nds_fr,pnds_fr,xnds_fr,kop_fr,prnn_fr,nof_fr,prdec_fr
store 0 to kpl_fr,nkklr,nkkl_fr,kgp_fr,kpv_fr
/*
*kpl_fr=0    // Предыдущий плательщик по документу (для корр шапки)
*nKklr=0     // Текущий клиент по документу (для корр шапки )
*nKkl_fr=0   // Предыдущий клиент по документу (для корр шапки)
*prdec_fr=0  // Предыдущий признак расчета (кол зн после запятой в цене)
*nds_fr=0    // Предыдущее отношение к НДС 1-й ц по документу (для корр шапки)
*pnds_fr=0   // Предыдущее отношение к НДС 2-й ц по документу (для корр шапки)
*xnds_fr=0   // Предыдущее отношение к НДС 3-й ц по документу (для корр шапки)
*kop_fr=0    // (kopir)Предыдущий КОП (для корр шапки)
*prnn_fr=0   // Предыдущее отношение к нал.накл.
*nof_fr=0    // Предыдущее отношение к НОФ
*/
 // Первый прайс(для корр шапки)

store 0 to kopir,tcenir,ndsir,ptcenir,pndsir,xtcenir,xndsir,cntrs2r,kpsbbr,prvzznr,;
           ttnprzr,ttnkplr,ttnktor,ttnppsfr,motchpr,ttnSdvr,ttn1ccr,;
           ttnkpkr,ttnktar,ttntmr,atrcr,symkl,vzz,bsr,rndsr,cntttnr,ddokr,;
           Sdvp3r,corsh,ktar,kecsr,ndsr,pndsr,pcor,ktasr,tmestor,pr361r,;
           ttnkpkpr,sdfr,ttndzr,kgprmr,kolposr,vsvr,vsvbr,ttnbsor,napr,docidr,ttnakcr
store 0 to mk174r,mnktr,ttnktr,skktr,dtktr,nndsktr,prAkcr,ttn177r,pr177r,ttnpr177r,;
           prdecr,katranr,ttn169r,pr169r,ttnpr169r,mk169r,ttn129r,pr129r,ttnpr129r,mk129r,;
           ttn139r,pr139r,ttnpr139r,mk139r,kopucr,PrnOprnr

store ctod('') to dnnktr
store 1 to prExter,tarar,ptr,Exter

store '' to cxoptir,coptir,cboptir,symklr,ntar,necs,totr,forkopr,forgkopr,nnapr,cnapr

store space(32) to docguidr

asz={}
anz={}
apr={}
apr90={}

ttndt1r=bom(gdTd)
if gdTd#date()
   ttndt2r=eom(gdTd)
else
   ttndt2r=gdTd
endif

do case
   case gnVo=0 // Автоматический расход
        ForTtn_r='.t..and.sks#0'
   case gnVo=1 // Возврат поставщику
        ForTtn_r='.t..and.vo=1'
   case gnVo=2 // Магазины
        ForTtn_r='.t..and.vo=2'
   case gnVo=5 // Акт
        ForTtn_r='.t..and.vo=5'
   case gnVo=6 // Переброска
        ForTtn_r='.t..and.vo=6'
   case gnVo=7 // Подотчет
        ForTtn_r='.t..and.vo=7'
   case gnVo=8 // Возврат из подотчета
        ForTtn_r='.t..and.vo=8'
   case gnVo=9 // Покупатели
        ForTtn_r='.t..and.vo=9'
   case gnVo=3 // 'Комиссионная торговля'
        ForTtn_r='.t..and.vo=3'
   case gnVo=4 // Протокол по возвратной таре
        ForTtn_r='.t..and.vo=4'
   case gnVo=10 // Аренда
        ForTtn_r='.t..and.vo=10'

endcase
if gnKto=782.or.gnKto=876
   ForTtn_r=ForTtn_r+'.and.!(kop=129.or.kop=139)'
endif
ForTtnr=ForTtn_r
go top


Do While .T.
   setcolor(fclr)
   sele sl
   zap

   prnppr=0 // Никаких действий с документом не было
   unlock all

   clea
   SayRs1_00_05()

   sele rs1
   if corsh=0

      store 0 to ttnr,ndr,mnr,qr,prZn,przr,kopr,kgpr,kplr,ttnkpsr,kpsr,kklr,sdfr,;
                 zcr,Sdvr,prnnr,sklr,przp,pprr,numbr,sktr,tcenr,ptcenr,xtcenr,pdrr,kklmr,;
                 mskltr,sktr,skltr,bprzr,bSdvr,pzenr,boptr,roptr,nKklr,nofr,ttnpr,ttncr,;
                 prModr,tskltr,entpr,kopir,tcenir,ndsir,ptcenir,pndsir,xtcenir,xndsir,;
                 prvzznr,prAkcr,pr177r,ttn177r,prdecr,katranr,PrnOprnr
      store 0 to pr169r,ttn169r,mk169r,;
                 pr129r,ttn129r,mk129r,;
                 pr139r,ttn139r,mk139r
      store 0 to sksr,sklsr,ktar,ktasr,kecsr,amnr,pStr,ptr,kpvr,bsor,bsonr,;
                 pr49r,doguslr,sktpr,skltpr,skspr,sklspr,amnpr,entpr,SkIdr,;
                 MZenr,ppsfr,ktospr,ktovttnr,nndsr,mrshr,pvtr,krspor,krspbr,;
                 krspnbr,krspr,krspsr,otnr,kgnr,ktofpr,prvxr,tmestor,pr361r,;
                 Exter,kolposr,ktovzttnr,napr,docidr,kpsbbr,mk174r,mnktr,;
                 nndsktr
      store 1 to prExter

      store '' to nvor,nopr,nvur,nkplr,nkgpr,nttnkpsr,nkpsr,coptr,ntcenr,;
                  nptcenr,nxtcenr,npdrr,nsklar,cboptr,croptr,cxoptr,nta,;
                  necs,tspr,tvttnr,pathepr,direpr,pathemr,pathecr,commr,;
                  firmr,nentpr,direpr,pathepr,coptir,cboptir,cxoptir,nnapr,cnapr,ztxtr

      // Первый прайс(для корр шапки)
      store ctod('') to dnzr,dotr,dtmodr,dopr,dspr,dfpr,dvttnr,dtotr,dtotsr,DtOplr,dvzttnr,dnnktr

      store space(5) to serr
      store space(6) to bsosr
      store space(8) to totr,topr,tspr,tfpr,tvttnr,tmmodr,tmotr,tvzttnr
      store space(9) to nnzr,ttn1cr
      store space(10) to atnomr
      store space(20) to notnr,ngnr
      store space(30) to npvr
      store space(32) to docguidr
      store space(60) to textr

      dgdtdr = gdTd
      dtror = date()+1  // Дата рекомендуемой отгрузки
      dvpr  = gdTd
      vvz   = 1
      vur=gnVu
      vor=gnVo

      @ 0,14 get ttnr pict'999999' when ttnw() valid ttnv()
      read
      if lastkey()=K_ESC
         set key K_SPACE to
         exit
      endif
      if ttnr=0.and.(who=1.or.who=0)
         exit
      endif
      if ttnr#0
         sele rs1
         netseek('t1','ttnr',,,1)
      endif
      if (ttnr=0.or.!FOUND())
         if !prdp()
            loop
         endif
         if !(month(gdTd)=month(date()).and.year(gdTd)=year(date()))
            ach:={'Нет','Да'}
            achr=0
            achr=alert('НОВЫЙ ДОКУМЕНТ.Это не текущий месяц.Продолжить?',ach)
            if achr#2
               loop
            endif
            if eom(gdTd)>=gdDec
               prdecr=1
            else
               prdecr=0
            endif
         else
            prdecr=1
         endif

         if ttnr=0
            sele cskl
            netseek('t1','gnSk',,,1) //  locate for sk=gnSk
            ttnr:=ttn - 999999
            //NextNumTtn('ttnr')

            /*
            reclock()
            do while .t.
               sele cskl
               ttnr = ttn
               sele rs1
               if !netseek('t1','ttnr',,,1)
                  exit
               endif
               sele cskl
               if ttn<999999
                  repl ttn with ttn+1
               else
                  repl ttn with 1
               endif
            enddo

            sele cskl
            netunlock()
            */
         endif
         @ 0,14 Say str(ttnr,6)+'<-НОВЫЙ'
         prZn=1
      else  // Найден
         prZn=0
         if !Reclock(1)
            wmess('Документ блокирован '+alltrim(getfield('t1','rs1->ktoblk','speng','fio')),3)
            loop
         endif
         prvxr=1
         przr=rs1->prz
         store vsv to oves,vsvr
         if fieldpos('vsvb')#0
            vsvbr=vsvb
         else
            vsvbr=0
         endif
         sdfr=sdf
         dvpr = DVP           //дата выписки
         dotr = DOT           // дата подверждения
         dgdtdr=dgdtd
         dtmodr=dtmod
         tmmodr=tmmod
         totr=  tot
         dopr = DOP  //дата отгрузки
         topr = top
         ddcr=  ddc
         tdcr  =tdc
         dtotr=dtot
         tmotr=tmot
         dtotsr=dtots
         tmestor=tmesto
         DtOplr=DtOpl
         ttnr = TTN           //номер документа
         rmskr=rmsk
         docguidr=docguid
         dspr =dsp        // дата сет печ
         tspr =tsp        // время сет печ
         dvttnr=dvttn     // дата возр ttn на склад экспедитором
         tvttnr=tvttn     // время
         ktovttnr=ktovttn
         dvzttnr=dvzttn     // дата возр ttn на склад экспедитором
         tvzttnr=tvzttn     // время
         ktovzttnr=ktovzttn
         ktospr=ktosp
         dfpr =dfp        // дата фин подтв
         tfpr =tfp        // время фин подтв
         ktofpr=ktofp
         if empty(dfpr).and.!empty(dopr) // Нет ДатыФК и ЕстьДатаОтгр
            dfpr =dop        // дата фин подтв
            tfpr =top        // время фин подтв
         endif
         if empty(rs1->dfp).and.!empty(dfpr)
            netrepl('dfp,tfp','dfpr,tfpr',1)
         endif
         pvtr=pvt
         krspor=krspo
         krspbr=krspb
         krspnbr=krspnb
         krspr=krsp
         krspsr=krsps
         bsor=bso
         bsosr=bsos
         bsonr=bson
         sktr=skt
 //            otnr=otn
         otnr=0
         notnr=getfield('t1','sktr,otnr','cskle','nai')
 //         kgnr=kgn
         kgnr=0
         if kgnr=0
            ngnr='Та же'
         else
            ngnr=getfield('t1','sktr,kgnr','cgrp','ngr')
         endif
         ttnpr=ttnp
         ttncr=ttnc
         pr49r=pr49
         kopir=kopi
         kop_fr=kopir
         pStr=pSt             //признак возвратной c/тары  0 - стеклотара возвратная, 1 - стеклотара невозвратная
         ptr=pt             //признак возвратной тары  0 - не возвратная, 1 - возвратная
         dtror=dtro
         amnr = amn           //Номер автом. док-та/номер документа источника
         sksr=sks
         kopr = KOP           //код операции


         if fieldpos('mntov177')#0
           mntov177r=mntov177
           prc177r=prc177
           if pr169rEQ2(ttnr) //  pr177=2.or.pr169=2.or.pr129=2.or.pr139=2
             if mntov177r=0.or.prc177r=0
               mntov177r:=mntov177r(gnEnt,rs1->(mk169 +  mk129 + mk139))
               prc177r=getfield('t1','mntov177r','ctov','cenpr')
               netrepl('mntov177,prc177','mntov177r,prc177r')
             endif
           endif
         else
            mntov177r=0
            prc177r=0
         endif
         if fieldpos('prdec')#0
            prdecr=prdec
         else
            prdecr=0
         endif
         if fieldpos('mnkt')#0
            mnktr=mnkt
         else
            mnktr=0
         endif
         if fieldpos('ttnkt')#0
            ttnktr=ttnkt
         else
            ttnktr=mnktr
         endif

         if fieldpos('katran')#0
            katranr=katran
         else
            katranr=0
         endif

         if fieldpos('nndskt')#0
            nndsktr=nndskt
            dnnktr=dnnkt
         else
            nndsktr=0
            dnnktr=ctod('')
         endif

         if fieldpos('prAkc')#0
            prAkcr=prAkc
 //            if gnEnt=20.and.(kopr=177.or.kopir=177)
 //               if prAkcr=0
 //                  prAkcr=1
 //                  netrepl('prAkc','prAkcr',1)
 //               endif
 //            endif
         else
            prAkcr=0
         endif

         mk174r=chk174() // tm для kop=174

         sele rs1
         nKKLr=rs1->nkkl
         nKkl_fr=nkklr
         kpvr=rs1->kpv
         kpv_fr=kpvr
         if fieldpos('prdec')#0
            prdec_fr=prdec
         else
            prdec_fr=0
         endif
         qr   = mod(kopr,100)
         vur  = gnVu
         ktor = KTO           //код инженера
         przr = prz
         pprr=ppr
         if empty(dot)
            przp=0
         else
            przp=1
         endif
         vor  = VO
         ppsfr=ppsf
         if sksr=0
            if vor#gnVo
               if vor#0
                  nvor=getfield('t1','vor','vo','nvo')
                  wmess('Этот документ - '+nvor,3)
                  loop
               else
                  wmess('Документ не имеет вида операции ',3)
                  loop
               endif
               loop
            endif
         endif
         bprzr=bprz
         kplr=kpl
         pr1ndsr=getfield('t1','kplr','kpl','pr1nds')
         kpsbbr=getfield('t1','kplr','kps','prbb')

         if kplr=20034
            tarar=0
         else
            if corsh=0
               tarar=1
            else
               ssf12r=getfield('t1','ttnr,12','rs3','ssf')
               if ssf12r#0
                  tarar=0
               else
                  tarar=1
               endif
            endif
         endif
         ssf19r=getfield('t1','ttnr,19','rs3','ssf')
         if ssf19r#0
            ptr=tarar
         endif
         kgpr= KGP
         kpvr=kpv
         kgprmr=getfield('t1','kpvr','kgp','rm')
         kpsr=kps
         ttnkpsr=kps
         npvr=npv
         Sdvr=Sdv
         nnzr = NNZ           //номер договора
         dnzr = DNZ           //дата договора
         ttn1cr=ttn1c
         sklr=skl
         textr=text
         serr=ser
         numbr=numb
         nsksr=getfield('t1','sksr','cskl','nskl')
         msklsr=getfield('t1','sksr','cskl','mskl')
         sklsr=skls
         if msklsr=0
            nsklsr=nsksr
         else
            nsklsr=getfield('t1','sklsr','kln','nkl')
         endif
         sktr=skt
         nskltr=getfield('t1','sktr','cskl','nskl')
         mskltr=getfield('t1','sktr','cskl','mskl')
         tskltr=getfield('t1','sktr','cskl','tskl')
         skltr=sklt
         sksr=sks
         sklsr=skls
         pdrr=pdr
         ktar=kta
         ktasr=ktas
         if ktasr=0
            ktasr=getfield('t1','ktar','s_tag','ktas')
         endif
         if gnEnt=20
            Exter=Exte(ktar)
         else
            if ktasr#0
               prExter=getfield('t1','ktasr','s_tag','prExte')
            else
               prExter=1
            endif
         endif
         sele rs1
         tmestor=tmesto
         tmesto_r=0
         if tmesto_r=0
            tmesto_r=getfield('t2','nkklr,kpvr','etm','tmesto')
            if tmesto_r=0
               tmesto_r=getfield('t2','nkklr,kpvr','tmesto','tmesto')
            endif
         endif
         if tmestor#tmesto_r
            netrepl('tmesto','tmesto_r',1)
            tmestor=tmesto
         endif
         kecsr=kecs
         amnpr=amnp

         entpr=entp
         sktpr=sktp
         skltpr=skltp
         skspr=sksp
         sklspr=sklsp
         kolposr=kolpos
         docidr=docid

         if fieldpos('ztxt')#0
            ztxtr=ztxt
         else
            ztxtr=space(200)
         endif

         napr=nap
         cnapr=cnap

         if fieldpos('ttn177')#0
            ttn177r=ttn177
            pr177r=pr177
         else
            ttn177r=0
            pr177r=0
         endif

         if fieldpos('ttn169')#0
            ttn169r=ttn169
            pr169r=pr169
            mk169r=mk169
         else
            ttn169r=0
            pr169r=0
            mk169r=0
         endif

         if fieldpos('pr129')#0
            pr129r=pr129
            mk129r=mk129
            ttn129r=ttn129

            pr139r=pr139
            mk139r=mk139
            ttn139r=ttn139
         else
            pr129r=0
            mk129r=0
            ttn129r=0

            pr139r=0
            mk139r=0
            ttn139r=0
         endif
         if napr=0.and.ddcr>=ctod('01.01.2010')
            if ktar#0
               napr=getfield('t1','ktar','ktanap','nap')
               if napr=0
                  if ktasr#0
                     napr=getfield('t1','ktasr','ktanap','nap')
                  endif
               endif
            endif
            netrepl('nap','napr',1)
         endif

         nnapr=getfield('t1','napr','nap','nnap')


         sele menent
         locate for ent=entpr
         if foun()
            commr=comm
            nentpr=uss
            direpr=alltrim(nent)+'\'
            if commr=0
               pathemr=gcPath_ini
            else
               pathemr=gcPath_ini+direpr
            endif
            pathepr=pathemr+direpr
            pathecr=pathemr+gcDir_c

            if commr=0
               nsktpr=getfield('t1','sktpr','cskl','nskl')
               mskltpr=getfield('t1','sktpr','cskl','mskl')
               nskspr=getfield('t1','skspr','cskl','nskl')
               msklspr=getfield('t1','skspr','cskl','mskl')
             else
               pathr=pathecr
               netuse('cskl','ecskl',,1)
               nsktpr=getfield('t1','sktpr','ecskl','nskl')
               mskltpr=getfield('t1','sktpr','ecskl','mskl')
               nskspr=getfield('t1','skspr','ecskl','nskl')
               msklspr=getfield('t1','skspr','ecskl','mskl')
               nuse('ecskl')
             endif
         endif

         sele soper
         if netseek('t1','0,gnVu,gnVo,kopir-100')
            tcenir=tcen
            ptcenir=ptcen
            xtcenir=xtcen
            sele tcen
            locate for tcen=tcenir
            if foun()
               coptir=alltrim(zen)
            endif
            locate for tcen=ptcenir
            if foun()
               cboptir=alltrim(zen)
            endif
            locate for tcen=xtcenir
            if foun()
               cxoptir=alltrim(zen)
            endif
         endif
         sele rs1
         atnomr=atnom
         nndsr=nnds
         if bom(gdTd)>=ctod('01.03.2011')
            if pr1ndsr=0
               if przr=1
                  nnds_r=getfield('t2','0,0,gnSk,ttnr,0','nnds','nnds')
                  if nndsr#nnds_r
                     sele rs1
                     netrepl('nnds','nnds_r',1)
                     nndsr=nnds_r
                  endif
               else
                  if nndsr#0
                     sele nnds
                     if netseek('t1','nndsr')
                        if rn#0
                           nndsr=0
                        endif
                     else
                        nndsr=0
                     endif
                     if nndsr=0
                        sele rs1
                        netrepl('nnds','nndsr',1)
                     endif
                  endif
               endif
            endif
         endif
         sele rs1
         mrshr=mrsh
         @ 0,14 Say str(ttnr,6)
      endif
   else  // corsh=1
      prZn=1
   endif

   Say_prz_1()


   if prZn=1
      @ 0,31 say 'Основание' get docguidr valid docgi()
      read
      If LastKey() = 27
         exit
      endif
      docguidr=upper(docguidr)
      if !empty(docguidr)
         @ 0,31 say 'Основание '+docguidr
      endif
   else
      if !empty(docguidr)
         @ 0,31 say 'Основание '+docguidr
      else
         @ 0,31 say 'Договор '+subs(nnzr,1,8)+' от  '+dtoc(dnzr)
      endif
   endif


   if prZn=1
      @ 1,14 get dvpr
      read
      if lastkey()=K_ESC
         if corsh=0
            loop
         else
            exit
         endif
      endif
      @ 1,14 say dtoc(dvpr)
   endif
   if prZn=1
      FKtor=gcName
      ktor=gnKto
   else
      sele speng
      locate for kgr=ktor
      if FOUND()
         FKtor=alltrim(fio)
      else
         FKtor='Вiдсутнiй в довiднидку'
      endif
   endif

   ln_FKtor:=FKtor
   If pr169rEQ2(ttnr) .and. ktor=117 // таранец pr169r=2
     FKtor:='Пинчук В.П.'
   EndIf

   @ 1,25  say 'Товаровед '+FKtor
   if prZn=1
      if kopr=188
         pvtr=1
      else
         if gnVo=9.or.gnVo=2
            @ 1,55 prom 'ЦЕНТРОЗАВОЗ'
            @ 2,55 prom 'САМОВЫВОЗ'
            menu to mpvt
            if lastkey()=K_ESC
               loop
            endif
            if mpvt=2
               pvtr=1
            else
               pvtr=0
            endif
         endif
      endif
   endif
   if pvtr=1
      @ 1,55 say 'САМОВЫВОЗ'
      @ 2,55 say space(12)
   else
      @ 1,55 say 'ЦЕНТРОЗАВОЗ'
      @ 2,55 say space(12)
   endif
   if prZn=1
      @ 1,70 get dtror
      read
      if lastkey()=K_ESC
         loop
      endif
   else
      @ 1,70 say dtoc(dtror)
   endif

   IF pStr=0
      @ 2,62 say 'С/Т' color 'r+/n'
   ELSE
      @ 2,62 say 'С/Т' color 'gr+/n'
   Endif

   IF ptr=1
      @ 2,col()+1 say 'Тара' color 'r+/n'
   ELSE
      @ 2,col()+1 say 'Тара' color 'gr+/n'
   Endif

   if kopr=129.or.kopr=139
      if kopr=129
         @ 2,76 say str(rs1->mk129,3) color 'bg/n'
      else
         @ 2,76 say str(rs1->mk139,3) color 'bg/n'
      endif
   else
     if bsor#0
         @ 2,col()+1 say 'БСО'+str(bsor,2) color 'w+/n'
      endif

      if subs(serr,2,1)='1'
         @ 2,76 say 'Серт' color 'r+/n'
      endif
   endif
   if prZn=1
      sele soper
      go top
      if gnEnt=20.and.corsh=1.and.(rs1->kopi=177.or.rs1->kopi=174);
        .or.gnEnt=21.and.corsh=1.and.rs1->kopi=177
         if gnAdm=1.or.gnKto=160.or.gnKto=71.or.gnKto=848.or.gnKto=28.or.gnKto=217.or.gnKto=786
            @ 2,14 get kopr pict '999'
            read
            if lastkey()=K_ESC
               loop
            endif
         else
            @ 2,14 say str(kopr,3)
         endif
         if kopr=0
            loop
         endif
         if !(kopr=177.or.kopr=169.or.kopr=169.or.kopr=174)
            loop
         endif
         if kopr=129.or.kopr=169.or.kopr=29.or.kopr=39
            loop
         endif
      else
         @ 2,14 get kopr pict '999'
         read
         if lastkey()=K_ESC
           loop
         endif
         // переворот на 139 с любого КОП gnKto=160 разрешен
         if corsh=1.and.(kopr=129.and.kop_fr#129.or.kopr=29.and.kop_fr#129;
          .or.kopr=39.and.iif(gnKto=160,.f.,kop_fr#39);
          .or.kopr=139.and.iif(gnKto=160,.f.,kop_fr#139))
            loop
         endif
         if kopr=0
            kopr=SLCf('soper',,,10,,"e:kop h:'Код' c:n(3) e:nop h:'Наименование' c:c(40)",'kop',0,,,'d0k1=gnD0k1.and.vu=gnVu.and.vo=gnVo')
            if lastkey()=K_ESC
               loop
            endif
         endif
         if kopr=0
            loop
         endif
         if kopr<100
            kopr=gnVu*100+kopr
         endif
 //         if gnEnt=20.and.corsh=1.and.kopr=177.and.kopir#177
         if kopr=177.and.kopir#177
            if !(gnAdm=1.or.gnKto=160.or.gnKto=71.or.gnKto=848.or.gnKto=28.or.gnKto=217.or.gnKto=786)
               loop
            endif
            if kopr=177.and.prAkcr=0
               prAkcr=1
               @ 2,18 say 'Акция' get prAkcr pict '99' range 1,1
               read
               if lastkey()=K_ESC
                  loop
               endif
            endif
         endif
         if gnEnt=20.and.corsh=1.and.kopr=174.and.kopir#174
            if !(gnAdm=1.or.gnKto=160.or.gnKto=71.or.gnKto=848.or.gnKto=28)
               loop
            endif
         endif
      endif
   endif
   sele rs1
   if corsh=1
      if kopr=196.and.gnEnt=20
         wmess('Запрещено - Директор',2)
         loop
      endif
      if (gnEnt=20.or.gnEnt=21).and.vor=6.and.!(kopr=188.or.kopr=189.or.kopr=180)
         if STR(gnSk,3) $ '238;239;703'// gnSk=239.or.gnSk=238
            wmess('Вн переброска только по 189 коду')
         else
            wmess('Вн переброска только по 188 или 189 коду')
         endif
         loop
      endif
   endif
   if prZn=1.and.corsh=0
      if kopr=196.and.gnEnt=20
        If .not. gnAdm=1
           wmess('Запрещено - Директор',2)
           loop
        EndIf
      endif
      if (gnEnt=20.or.gnEnt=21).and.vor=6.and.!(kopr=188.or.kopr=189.or.kopr=180)
         if STR(gnSk,3) $ '238;239;703'// gnSk=239.or.gnSk=238
            wmess('Вн переброска только по 189 коду')
         else
            wmess('Вн переброска только по 188 или 189 коду')
         endif
         loop
      endif
      kopir=kopr
      kop_fr=kopr
   endif
   qr=mod(kopr,100)
   store 0 to onofr,opbzenr,opxzenr,;
              otcenpr,otcenbr,otcenxr,;
              odecpr,odecbr,odecxr
   if !inikop(gnD0k1,gnVu,gnVo,qr)
      loop
   endif
   if gnCtov=1.and.gnVo=9.and.kopr=170 // Тарный документ
      if prZn=1
         if empty(docguidr)
            clttncr=setcolor('gr+/b,n/bg')
            wttncr=wopen(10,20,15,50)
            wbox(1)
            @ 0,1 say 'ТТН - Товар' get ttnpr pict '999999'
            read
            wclose(wttncr)
            setcolor(clttncr)
            if ttnpr=0
               loop
            endif
         endif
         sele rs1
         if !(bof().or.eof())
            rcttncr=recn()
         else
            rcttncr=1
         endif
         if !netseek('t1','ttnpr',,,1)
            wmess('Нет ТТН - Товар')
         else
           if .f..and.prz=1
              wmess('ТТН - Товар - подтверждена')
              go rcttncr
              reclock()
              loop
            endif
            if ttnc#0
               if ttnc#ttnr
                  wmess('Тара уже есть '+str(ttnc,6))
                  go rcttncr
                  reclock()
                  loop
               endif
               if !(kop=160.or.kop=161.or.kop=169.or.kopr=168.or.kop=191.or.kop=126.or.kop=177.or.kop=174)
                  wmess('Код ТТН - Товар -'+str(kop,3))
                  go rcttncr
                  reclock()
                  loop
               endif
            else
               ttnpr=ttn
            endif
            go rcttncr
            reclock()
         endif
      endif
   endif
   if prZn=1
       // Инициализация адресов по SOPER
       // Назначение
      if autor=1.or.autor=2.or.autor=5
         store skar to gnSkt,sktr
         store msklar to gnMsklt,mskltr
         if msklar=0
            store sklar to gnSklt,skltr
         else
            store 0 to gnSklt,skltr
         endif
         store nsklar to gnNsklt,nskltr
      else
         if autor=3
            store 0 to gnSkt,sktr
            store 0 to gnSklt,skltr
            store 0 to gnMsklt,mskltr
            store '' to gnNsklt,nskltr
         endif
      endif
   endif
   tskltr=getfield('t1','sktr','cskl','tskl')
   if gnEnt=20.and.(kopr=177.or.kopr=174).or.gnEnt=21.and.kopir=177
      @ 2,14 say str(kopr,3)+'('+str(kopir,3)+')'+' '+nopr color 'r+/n'
   else
      @ 2,14 say str(kopr,3)+'('+str(kopir,3)+')'+' '+nopr
   endif
   if gnCtov=1.and.gnVo=9
      if ttnpr#0
         @ 2,col()+1 say str(ttnpr,6)
      endif
      if ttncr#0
         @ 2,col()+1 say str(ttncr,6)
      endif
      if .t. //gnEnt=20
         if kopr=177.or.kopir=177
            if prAkcr=0
               @ 2,col()+1 say str(docidr,6) color 'r+/n'
            else
               @ 2,col()+1 say str(docidr,6)+' '+str(prAkcr,2) color 'r+/n'
            endif
         else
            if docidr#0
               if gnEnt=20.and.vor=9.and.kopr=168
                  @ 2,col()+1 say str(docidr,6) color 'r+/n'
               else // gnKt ???
                  @ 2,col()+1 say str(kpsr,7) color 'r+/n'
               endif
            endif
         endif
      endif
 //      if gnEnt=21
 //         if kopir=177
 //            if prAkcr=0
 //               @ 2,col()+1 say str(docidr,6) color 'r+/n'
 //            else
 //               @ 2,col()+1 say str(docidr,6)+' '+str(prAkcr,2) color 'r+/n'
 //            endif
 //         else
 //            if docidr#0
 //               @ 2,col()+1 say str(kpsr,7) color 'r+/n'
 //            endif
 //         endif
 //      endif
   endif
   if !rsshp()
      loop
   endif
   kpsbbr=getfield('t1','kplr','kps','prbb')
   pr1ndsr=getfield('t1','kplr','kpl','pr1nds')
   if prZn=1
      if gnMskl=0.and.gnTskl#3
         sklr=gnSkl
      endif
      r1=1
      if !((gnEnt=20.or.gnEnt=21).and.corsh=1.and.(rs1->kopi=177.or.rs1->kopi=174))
         @ 23,5     prompt 'ВСЕ ВЕРНО'
         @ 23,col()+1 prompt 'НЕ ВЕРНО'
         menu to r1
         @ 23,0 clear
         If LastKey() = 27
            clea
            exit
         Endif
      else
         r1=1
      endif
      if r1=2
         loop
      endif
      if okplr=20034
         tarar=0
      else
         if corsh=0
            tarar=1
         else
            ssf12r=getfield('t1','ttnr,12','rs3','ssf')
            if ssf12r#0
               tarar=0
            else
               tarar=1
            endif
         endif
      endif
   else
      ssf12r=getfield('t1','ttnr,12','rs3','ssf')
      if ssf12r#0
         tarar=0
      else
         tarar=1
      endif
   endif
   ptr=tarar

   sele rs1
   if prZn=1.and.prdp()
      if corsh=0

        sele cskl
        netseek('t1','gnSk',,,1) //  locate for sk=gnSk
        NextNumTtn('ttnr')

         sele rs1
         netAdd()
         netrepl('ttn,ddc,tdc,kto','ttnr,date(),time(),gnKto',1)
         netrepl('rmsk','gnRmsk',1)
         netrepl('RndSdv',;
         {getfield('t1','0,gnVu,gnVo,kopir-100','soper','RndSdv')};
         ,1)
         dbcommit(); DBSkip(0)
         @ 0,14 Say str(ttnr,6)+'<-НОВЫЙ'

      else
         sele rs1
         rso(10)
      endif
      sele rs1
      reclock()
      netrepl('kop,skl,npv,vo,dvp,pdr,NNZ,DNZ,text,skt,sklt,'+;
               'kta,kopi,entp,sktp,skltp,amnp,sksp,sklsp,ttn1c,pvt,'+;
               'otn,kgn,pr49',;
               {kopr,sklr,npvr,gnVo,dvpr,pdr,NNZr,DNZr,textr,sktr,skltr,;
                ktar,kopir,entpr,sktpr,skltpr,amnpr,skspr,sklspr,ttn1cr,pvtr,;
                0,0,pr49r},1)

      // процедура перехода в 139
      If kopr=139.and.kop_fr#139 // был другим
        MnTovr:=getfield('t1','rs1->ttn','rs2','MnTov')
        mkeepr:=getfield('t1','MnTovr','ctov','mkeep')
        netrepl('mk139',{mkeepr},1)
      endif

      netrepl('pt','tarar',1)
      netrepl('ktas','ktasr',1)
      if fieldpos('nap')#0
         netrepl('nap','napr',1)
         nnapr=getfield('t1','napr','nap','nnap')
      endif
      if gnVo=5.and.kopr=193
         netrepl('kecs','kecsr',1)
      endif
      if fieldpos('prdec')#0
         netrepl('prdec','prdecr',1)
      endif
      if gnKt=1
         if fieldpos('mnkt')#0
            netrepl('mnkt','mnktr',1)
         endif
         if fieldpos('ttnkt')#0
            netrepl('ttnkt','ttnktr',1)
         endif
         if fieldpos('nndskt')#0
            netrepl('nndskt,dnnkt','nndsktr,dnnktr',1)
         endif
      endif
      if okplr=0
         netrepl('kpl,nkkl','kplr,kplr',1)
      else
         netrepl('kpl,nkkl','okplr,kplr',1)
      endif
      if okklr=0
         netrepl('kgp,kpv','kgpr,kgpr',1)
      else
         netrepl('kgp,kpv','okklr,kgpr',1)
      endif
      nKklr=nkkl

      if corsh=0
         netrepl('dgdtd','dgdtdr',1)
      endif

      if dtror=date().and.time()>'10.00.00'
         dtror=date()+1
      endif
      netrepl('dtro','dtror',1)

      netrepl('docguid','docguidr',1)

      if prlkr=1
         netrepl('kps','ttnkpsr',1)
      endif
      dbcommit(); DBSkip(0)

      sele rs1
      kplr=kpl
      kgpr=kgp
      kpvr=kpv
      nkklr=nkkl

      if gnVo=9
         if select('kplkgp')#0
            sele kplkgp
            if !netseek('t1','nkklr,kpvr,ktar')
               if netseek('t1','nkklr,kpvr,0')
                  netrepl('kta','ktar')
               else
                  netadd()
                  netrepl('kpl,kgp,kta','nkklr,kpvr,ktar')
               endif
            endif
         endif
         if select('tmesto')#0
            sele tmesto
            if !netseek('t2','nkklr,kpvr')
               if nkklr#0.and.kpvr#0
                  sele cntcm
                  reclock()
                  tmestor=tmesto
                  netrepl('tmesto','tmesto+1')
                  sele tmesto
                  netadd()
                  netrepl('tmesto,kpl,kgp','tmestor,nkklr,kpvr')
               endif
            else
               if tmestor=0
                  tmestor=tmesto
               endif
            endif
         endif
      endif

      sele rs1
      netrepl('tmesto','tmestor',1)

      sele rs1
      if gnCtov=1.and.gnVo=9.and.kopr=170
         netrepl('ttnp','ttnpr',1)
         rcttncr=recn()
         sele rs1
         if netseek('t1','ttnpr',,,1)
            netrepl('ttnc','ttnr')
         endif
         go rcttncr
         reclock()
      endif
      pStr=1
      sele kpl
      netseek('t1','nKklr')

       // Признак наличия договорных условий
      if empty(dtnace).or.dtnace<gdTd //.or.empty(dtnacb).or.dtnacb>gdTd
         doguslr=0
         do case
 //            case empty(dtnacb)
 //                 wmess('Нет даты начала договорных условий',1)
            case empty(dtnace)
                 wmess('Нет даты окончания договорных условий',1)
            case dtnace<gdTd
               wmess('Договорные условия закочились '+dtoc(dtnace),1)
 //            case dtnacb>gdTd
 //               wmess('Договорные условия не начались '+dtoc(dtnacb),1)
         endcase
       else
         doguslr=1
      endif
      pStr=1
      sele rs1
      netrepl('pSt','pStr',1)
      netrepl('dtmod,tmmod','date(),time()',1)
      dbcommit(); DBSkip(0)
      prModr=1
   endif

   asz={}
   anz={}
   apr={}
   apr90={}

   sele soper
   qr=mod(kopr,100)
   netseek('t1','gnD0k1,vur,vor,qr')
   // добавил 04-10-19 03:56pm
   brprr=0
   if (fieldpos('brpr' )=0 )
     brprr=0
   else
     brprr=brpr
   endif
   //         //////////////////
   //brprr=0
   if brprr=1
      sele setup
      locate for ent=gnEnt
      Nbankr=OB2
      Bankr=KB2
      Schtr=NS2
   endif
   sele soper
   store 0 to pr13r,pr14r
   for i=1 to 20
       sele soper
       if i<10
          tt=str(i,1)
       else
          tt=str(i,2)
       endif
       dsz_r='dsz'+tt
       dszr=&dsz_r
       if dszr=0
          loop
       endif
       if dszr=13
          pr13r=1
       endif
       if dszr=14
          pr14r=1
       endif
       sele dclr
       if netseek('t1','dszr')
          aadd(asz,dszr)
          aadd(anz,nz)
          aadd(apr,pr)
          aadd(apr90,pr90)
       endif
   next
   sele kpl
   netseek('t1','nKklr')
    // Признак наличия договорных условий
   if empty(dtnace).or.dtnace<gdTd //.or.empty(dtnacb).or.dtnacb>gdTd
      doguslr=0
      do case
 //         case empty(dtnacb)
 //              wmess('Нет даты начала договорных условий',1)
         case empty(dtnace)
              wmess('Нет даты окончания договорных условий',1)
         case dtnace<gdTd
              wmess('Договорные условия закочились '+dtoc(dtnace),1)
 //         case dtnacb>gdTd
 //              wmess('Договорные условия не начались '+dtoc(dtnacb),1)
      endcase
   else
      doguslr=1
   endif

   if nKkl_fr#0.and.nKklr#nKkl_fr
      if nofr=1
         wmess('Внимание!Изменился клиент!',3)
      else
         if gnEnt=20
            sele rs1
            if !empty(dfp)
               dfpr=ctod('')
               netrepl('dfp','dfpr',1)
               wmess('Фин подтв снято!!!',3)
            endif
         endif
      endif
   endif
   if rs1->prz=0.and.(nKkl_fr#0.and.nKklr#nKkl_fr.or.nofr=0)
      sele rs3
      if netseek('t1','ttnr,49')
         netdel()
         sele rs1
         netrepl('pr49','0',1)
      endif
   endif
   if corsh=1
      rs2pzen(2)
       // Пересчет RS2 по прайсовым ценам документа новый
       //      apcenr=0
       //      if prdecr=0
       //         rs2prc(2) // Пересчет RS2 по прайсовым ценам документа
       //      else
       //         apcenr=3
       //         rs2pzen(2) // Пересчет RS2 по прайсовым ценам документа новый
       //      endif
      pere(3)   // Полный перерасчет RS3
      if !empty(dotr)
        sele rs1
        if empty(dvttn)
           netrepl('dvttn,tvttn,ktovttn','date(),time(),gnKto',1)
           prModr=1
        endif
      endif
      corsh=0
      sele rs1
   else
      sele rs2
      set orde to tag t1
      if netseek('t1','ttnr')
         do while ttn=ttnr
            zenr=zen
            zenpr=zenp
            prZenr=pzen
            if zenpr=0
               if prZenr=0
                  zenpr=zenr
               else
                  zenpr=roun(zenr*100/(100+prZenr),3)
               endif
               if ndsr=1.or.ndsr=4
                  zenpr=roun(zenpr/1.2,3)
               endif
            endif

            bzenr=bzen
            bzenpr=bzenp
            prBZenr=pbzen

            if pbzenr=1.and.bzenp=0
               bzenpr=zenpr
            endif
            if otv=0
               if zenp=0.or.(bzenp=0.and.bzenpr#0)
                  if gnSkotv=0
                     wmess('Коррекция 0 прайса в документе',0.5)
                  endif
                  netrepl('zenp,bzenp','zenpr,bzenpr')
               endif
            endif
            ktlpr=ktlp
            mntovpr=getfield('t1','sklr,ktlpr','tov','mntov')
            if mntovpr#0
               sele rs2
               netrepl('mntovp','mntovpr')
            endif
            sele rs2
            skip
         enddo
      endif
   endif
   @ 3,52 say str(sdfr,5,0)
   @ 3,62 say 'Вес: ' + str(vsvr,11,3)+'кг'
   @ 3,62 say 'Вес:' + str(vsvr,5,0)+'('+str(vsvbr,5,0)+')'+'кг'
   @ 5,43 say ' Итого                : ' + str(Sdvr,10,2)
   if corsh=1
      corsh=0
   endif
   forkopr=''
   forgkopr=''
   sele sgrp
   go top
   ckopr=str(kopr,3)
   do while !eof()
      ckgrr=alltrim(str(kgr,3))
      if at(ckopr,nokop)#0
         forkopr=forkopr+'.and.kg#'+ckgrr
         forgkopr=forgkopr+'.and.kgr#'+ckgrr
      endif
      skip
   enddo

   /****************************************************************/
   // Товар
   /***************************************************************/
  ln_who:=who
  If pr169rEQ2(ttnr)
    pr169r2Email('Beg',!(lastkey()=K_ENTER))
  Endif
  If pr169rEQ2(ttnr) .and. lastkey()=K_ENTER  //(gnAdm=1 .or.)
    // начали подмен
    SpoofMode:=.T.
    close rs2
    close rs2m

    sm10r=getfield('t1','ttnr,10','rs3','ssf') // сумма товара
    who:=0

    //getfield('t1','gnKto','speng','fio')

    lcrtt('t1rs2','rs2')
    lindx('t1rs2','rs2')
    lcrtt('t1rs2m','rs2')
    lindx('t1rs2m','rs2')

    Crt_trs2()
    // outlog(__FILE__,__LINE__,rs1->(mk169 +  mk129 + mk139))
      AddRec2Trs2(rs1->(mk169 +  mk129 + mk139)) // mk177 +
    aRecTRs2:=trs2->({npp,nat,ukt,upu,kod,kol,zen,sm})
    close trs2

    use t1rs2 alias rs2 new
    append from trs2

    netrepl('ttn,ktl',{ttnr,getfield('t5','Sklr,rs2->MnTov','tov','ktl')}) //mntov*100})
    netrepl('npp,nat,ukt,upu,kod,kvp,zen,svp',;
            aRecTRs2)
    copy to trs2m

    use t1rs2m alias rs2m new
    append from trs2m

    pere(3)   // Полный перерасчет RS3

  EndIf

   esc_r=0
   sele rs2
   if netseek('t3','ttnr')
      rcrs2r=recn()
   else
      rcrs2r=1
   endif
   if gnCtov=1
      sele rs2m
      if netseek('t3','ttnr')
         rcrs2mr=recn()
      else
         rcrs2mr=1
      endif
   endif

   do while esc_r=0
      prZen2r=0
      prNacr=0
      SkIdr=getfield('t1','kplr','kln','SkId')
      Sdvdopr=0
      SdvUchr=0
      if gnCtov=1
         if gnAdm=1.or.gnRrs2m=1
            rs2vidr=2
         else
            rs2vidr=2 //1
         endif
      else
         rs2vidr=2
      endif
      esc_rr=0
      do while .t.
         store 0 to cnttm2r,cntt2r
         if gnCtov=1
            sele rs2m
            set orde to tag t3
            if netseek('t3','ttnr')
               do while ttn=ttnr
                  cnttm2r++
                  skip
               enddo
            endif
            sele rs2m
            set orde to tag t3
            if prrs2mr=0
               if !netseek('t3','ttnr,mntovpr')
                  go top
               endif
            else
               if !netseek('t3','ttnr,mntovpr,ktlpr')
                  go top
               endif
            endif
            rcrs2mr=recn()
         endif
         sele rs2
         set orde to tag t3
         if netseek('t3','ttnr')
            do while ttn=ttnr
               cntt2r++
               skip
            enddo
         endif
         sele rs2
         set orde to tag t3
         if mntovr#0
            if !netseek('t2','ttnr,mntovr')
               go top
            endif
         else
            if !netseek('t3','ttnr')
               go top
            endif
         endif
         rcrs2r=recn()
         go rcrs2r
         SdvOtp_r=getfield('t1','ttnr,90','rs3','ssf')
         sele rs3
         Sdvp3_r=getfield('t1','ttnr,90','rs3','xssf')
         sele rs2
         SdvUchr=getfield('t1','ttnr,96','rs3','ssf')+;
                 iif(pStr=1,getfield('t1','ttnr,94','rs3','ssf'),0)+;
                 iif(tarar=0,getfield('t1','ttnr,97','rs3','ssf'),0)
         sele rs3
         Sdvp3_r=getfield('t1','ttnr,90','rs3','xssf')
         sele rs2
         do case
            case rs2vidr=1
                 nrs2r='По отпускным ценам'
                 if Sdvdopr#0
                    @ 4,43 say '                        '+str(Sdvdopr,10,2)
                 else
                    @ 4,43 say ' По закупочным ценам  : '+str(SdvUchr,10,2) color 'g/n,n/g'
                 endif
                 @ 5,43 say ' По отпускным ценам   : ' + str(SdvOtp_r,10,2)+' '+str(prdecr,1) color 'g/n,n/g'
                 @ 6,43 say ' Количество позиций   : ' + str(cnttm2r,3)
                 do case
                    case pr49r=0
                         @ 6,78 say ' ' color 'g/n,n/g'
                    case pr49r=1
                         @ 6,78 say str(pr49r+1,1) color 'gr+/n,n/g'
                    case pr49r=2
                         @ 6,78 say str(pr49r+1,1) color 'r+/n,n/g'
                 endcase
                 sele rs2m
                 go rcrs2mr
                 rs2m()
            case rs2vidr=2.or.gnCtov#1
                 sele rs1
                 nrs2r='По партиям'+' ('+str(rs1->nkkl,7)+')'
                 @ 4,43 say ' По закупочным ценам  : ' + str(SdvUchr,10,2) color 'g/n,n/g'
                 @ 5,43 say ' По отпускным ценам   : ' + str(SdvOtp_r,10,2)+' '+str(prdecr,1) color 'g/n,n/g'
                 @ 6,43 say ' Количество позиций   : ' + str(cntt2r,3) color 'g/n'
                 do case
                    case pr49r=0
                         @ 6,78 say ' ' color 'g/n,n/g'
                    case pr49r=1
                         @ 6,78 say str(pr49r+1,1) color 'gr+/n,n/g'
                    case pr49r=2
                         @ 6,78 say str(pr49r+1,1) color 'r+/n,n/g'
                 endcase
                 sele rs2
                 go rcrs2r
                 rs2()
         endcase
         if esc_r=1.or.esc_rr=1
            exit
         endif
      enddo
***************************************************************
      sele rs3
      if netseek('t1','ttnr')
         rcrs3r=recn()
      else
         rcrs3r=1
      endif
      prF1r=0
      do while .t.  // Денежная часть документа
          if rs1->prz=0
             tbl3oper()
          endif
          pere(2)  // Полный перерасчет
          if esc_r=1
             exit
          endif
          sele rs3
          if netseek('t1','ttnr')
              rcrs3r=recn()
          else
              rcrs3r=1
          endif
          go rcrs3r
          if prF1r=0
            do case
            case who=0.or.who=5
                foot('F9','Итоги')
            case gnArm=3 .and. (Who<>1.or.gnAdm=1).and.rs1->prz=0.and.tarar=1
              if pStr=0
                foot('INS,DEL,F4,F5,F6,F8,F9','Доб.,Уд,Корр.,Ст.возвр.,Подтв,Провести,Итоги')
              else
                foot('INS,DEL,F4,F5,F6,F8,F9','Доб.,Уд,Корр.,Ст.невоз.,Подтв,Провести,Итоги')
              endif
            othe
              foot('INS,DEL,F4,F9','Добавить,Удалить,Коррекция,Итоги')
            endcase
           else
             foota('F3,F5,F8','З/Экс,Тара,2Ц')
           endif
           IF pStr=0
              @ 2,62 say 'С/Т' color 'r+/n'
           ELSE
              @ 2,62 say 'С/Т' color 'gr+/n'
           Endif

           IF ptr=1
              @ 2,col()+1 say 'Тара' color 'r+/n'
           ELSE
              @ 2,col()+1 say 'Тара' color 'gr+/n'
           endif

           if bsor#0
              @ 2,col()+1 say 'БСО'+str(bsor,2) color 'w+/n'
           endif

           if subs(serr,2,1)='1'
              @ 2,76 say 'Серт' color 'r+/n'
           endif

          sele rs3
          set orde to tag t1
          if prZen2r=0
            kszr=slcf('rs3',8,,,,"e:ksz h:'Код' c:n(2) e:getfield('t1','rs3->ksz','dclr','nz') h:'Наименование' c:c(20) e:ssf h:'Сумма' c:n(10,2) e:pr h:'Проц.' c:n(6,2)",'ksz',0,,'ttn=ttnr','ksz<=91',,'ДЕНЬГИ')
          else
            kszr=slcf('rs3',8,,,,"e:ksz h:'Код' c:n(2) e:getfield('t1','rs3->ksz','dclr','nz') h:'Наименование' c:c(20) e:ssf h:'Сумма' c:n(10,2) e:pr h:'Проц.' c:n(6,2) e:bssf h:'Сумма2' c:n(10,2) e:bpr h:'Проц2.' c:n(6,2) e:xssf h:'Сумма3' c:n(10,2) e:xpr h:'Проц3.' c:n(6,2)",'ksz',0,,'ttn=ttnr','ksz<=91',,'ДЕНЬГИ')
          endif
          sele rs3
          netseek('t1','ttnr,kszr')
          rcrs3r=recn()
          do case
             case lastkey()=K_F1 // F1
                  if prF1r=0
                     prF1r=1
                  else
                     prF1r=0
                  endif
             case lastkey()=K_ALT_F8
                  if gnAdm=0
                     if prZen2r=0.and.pbzenr=1
                        prZen2r=1
                     else
                        prZen2r=0
                     endif
                  else
                     if prZen2r=0
                        prZen2r=1
                     else
                        prZen2r=0
                     endif
                  endif
                  loop
             case lastkey()=K_F6 //.and.gnAdm=1 // Подтверждение
                  sele kln
                  if netseek('t1','kplr')
                     if kln->nn#0 //.and.!empty(kln->nsv)
                        rspod(1)
                     else
                        wmess('Не плательщик НДС',2)
                     endif
                  endif
 //                  esc_r=1
 //                  exit
             case lastkey()=K_ESC // Выход
                  esc_r=1
                  exit
             case lastkey()=K_F8 // провести передать на ФинКотроль
               If empty(dfpr)
                 sele rs1
                 netrepl('ktofp',{-901},1)
               else
                 wmess('Уже проведен',2)
               endif
             case lastkey()=K_F9 // Итоги
                  exit
             case lastkey()=K_INS.and.prdp().and.(who=2.or.who=3.or.who=4).and.rs1->prz=0 .AND.;
               IIF(!EMPTY(Dopr),;//отгружен
                   gnCenR=1 .OR. gnAdm=1,;//редактирование розничной цены
                  .T.;
                    )
                  // // Добавить
                  tbl3oper()
             case lastkey()=K_F4.and.prdp().and.(who=2.or.who=3.or.who=4).and.rs1->prz=0.and. ;
               IIF(!EMPTY(Dopr),;//отгружен
                   gnCenR=1 .OR. gnAdm=1,;//редактирование розничной цены
                  .T.;
                    )
                 // // Коррекция
                  if kszr#49
                     if kszr=40
                        if gnCenr=1.or.gnAdm=1
                           rs3ssf()
                        endif
                     else
                        rs3ssf()
                     endif
                     if kszr=46
                        sele rs3
                        if ssf=0
                           rso(25)
                        endif
                     endif
                  else
                     if nofr=1 // prnnr=0
                        s492r=0
                        s493r=0
                        if pbzenr=1
                           sele rs3
                           if netseek('t1','ttnr,10')
                              s492r=bssf-ssf
                           endif
                        endif
                        if pxzenr=1
                           sele rs3
                           if netseek('t1','ttnr,10')
                              s493r=xssf-ssf
                           endif
                        endif
                        do case
                           case pr49r=0
                                pr49r=1
                                ssf_r=s492r
                                pr_r=0
                                wmess('По 2-й цене',1)
                           case pr49r=1
                                pr49r=2
                                ssf_r=s493r
                                pr_r=0
                                wmess('По 3-й цене',1)
                           case pr49r=2
                                pr49r=0
                                ssf_r=0
                                pr_r=0
                                wmess('Обнуление',1)
                         endcase
                         sele rs3
                         go rcrs3r
                         if ssf_r>0.and.pr49r#2
                            wmess('Низзя! Cкидка>0',1)
                            loop
                         endif
                         netrepl('ssf,pr','ssf_r,pr_r')
                         sele rs1
                         netrepl('pr49','pr49r',1)
                     endif
                     prModr=1
                  endif
                  pere(2)  // Полный перерасчет
             case lastkey()=K_DEL.and.prdp().and.(who=2.or.who=3.or.who=4).and.rs1->prz=0  .AND.;
               IIF(!EMPTY(Dopr),;//отгружен
                   gnCenR=1 .OR. gnAdm=1,;//редактирование розничной цены
                  .T.;
                    )
              // // Удалить
                  sele dclr
                  if netseek('t1','kszr')
                     if pr=0
                        sele rs3
                        if netseek('t1','ttnr,kszr')
                           netdel()
                           if kszr=46
                              rso(25)
                           endif
                           prModr=1
                        endif
                     endif
                  endif
                  sele rs3
             case lastkey()=K_ALT_F3 //ztxt
                  ztxt(1)
             case lastkey()=K_ALT_F5.and.przr=0; //возвратная тара
               .and.(gnAdm=1;
               .or.gnCenr=1.and.prdp().and.!(kopr=169.or.kopr=168).and.empty(rs1->dop))
                  sele rs1
                  if netseek('t1','ttnr',,,1)
                     iif(pt=0,netrepl('pt','1',1),netrepl('pt','0',1))
                     prModr=1
                     ptr=pt
                     tarar=ptr
                 endif
             case lastkey()=K_F5.and.prdp(); //возвратная c/тара
              .and.((who=2.or.who=3.or.who=4).and.tarar=1.and.IIF(!EMPTY(Dopr),gnCenR=1,.T.));
              .or.gnAdm=1
                  sele rs1
                  if netseek('t1','ttnr',,,1)
                     iif(pSt=0,netrepl('pSt','1',1),netrepl('pSt','0',1))
                     prModr=1
                     pStr=pSt
                 endif
         endcase
       enddo
       pere(3)  // Полный перерасчет
       if esc_r=1
          exit
       endif
       prF1r=0
       do while .t. // Итог документа
          if prF1r=0
    outlog(3,__FILE__,__LINE__,"gnArm who", gnArm,who)

             do case
                case gnArm=3.and.who=0
                     foot('F3,F9','Ф.с.,Товар')
                case gnVo=4
                     foot('F3,F4,F5,F6,F2,F7,F8,F9','Ф.с.,СПеч.,ЛПеч.,НДС,Печ.Т,СерТ,Шапка,Товар')
                othe
                     if rs1->prz=0
                        if gnSPech=1
                           if who=2.or.who=5
                              foot('F3,F4,F5,F6,F2,F7,F8,F9','Ф.с.,СПеч.,ЛПеч.,НДС,Печ.Т,СерТ,Шапка,Товар')
                           else
                              foot('F3,F4,F5,F6,F2,F7,F8,F9,F10','Ф.с.,СПеч.,ЛПеч.,НДС,Печ.Т,СерТ,Шапка,Товар,Возвр.')
                           endif
                        else
                           if who=2
                              foot('F3,F5,F6,F2,F7,F8,F9','Ф.с.,ЛПеч.,НДС,Печ.Т,СерТ,Шапка,Товар')
                           else
                              foot('F3,F5,F6,F2,F7,F8,F9,F10','Ф.с.,ЛПеч.,НДС,Печ.Т,СерТ,Шапка,Товар,Возвр.')
                           endif
                        endif
                     else
                       if gnSpech=1
                          if who=1
                             foot('F4,F5,F6,F2,F7,F8,F9','СПеч,Печ,НДС,Печ.Т,СерТ,Шапка,Товар')
                          endif
                          if who=2.or.who=5
                             foot('F3,F4,F5,F2,F7,F8,F9','Фин.сост,СПеч,Печ,Печ.Т,СерТ,Шапка,Товар')
                          endif
                          if who=3.or.who=4
                             foot('F3,F4,F5,F6,F2,F7,F8,F9','Фин.сост,СПеч,Печ,НДС,ПечТ,СерТ,Шапка,Товар')
                          endif
                       else
                           if who=1
                              foot('F5,F6,F2,F7,F8,F9','Печать,НДС,ПечТ,СерТ,Шапка,Товар')
                           endif
                           if who=2.or.who=5
                              foot('F3,F5,F2,F7,F8,F9','Фин.сост,Печать,ПечТ,СерТ,Шапка,Товар')
                           endif
                           if who=3.or.who=4
                              foot('F3,F5,F6,F2,F7,F8,F9','Фин.сост,Печать,НДС,ПечТ,СерТ,Шапка,Товар')
                           endif
                       endif
                     endif
             endcase
          else
             foota('F4,F5,F6,F7,F8,F10','СпечТ,ЛпечТ,Печ1ТН,ПечТТН,ПечТТН1,Серт')
          endif
          inkey(0)
          do case
             case lastkey()=K_F1 // F1
                  if prF1r=0
                     prF1r=1
                  else
                     prF1r=0
                  endif
             case lastkey()=K_F2.and.who#0.and.!(gnArm=2.or.gnArm=6) // Печать тары
                  vtar(kplr)
             case lastkey()=K_F3.and.gnArm#2.and.who#1 // Финансовое состояние клиента
                  rfinskl()
             case lastkey()=K_F4; // Сетевая печать/Фин подтв
              .and.(who#0) ; //.or.(who=0.and. pr169r=2));
              .and.gnArm=3
               If kopr=169 .and. !(Sdvr < 50000 ) //Sdv50000
                  wmess('Ограничение по сумме д-та 50000',2)
                  loop
               EndIf
                  gnScOut=0
                  if gnEnt=20 .or. gnEnt=21
                     if gnVo=9
                        if chkkgp()=0
                           loop
                        endif
                     endif
                  endif
                  if gnEnt=21
                     if !chklic()
                        loop
                     endif
                  endif
                  sele rs1
                  if fieldpos('fc')#0
                     if fc=1
                        wmess('Заблокированно финконтролем',2)
                        loop
                     endif
                     if fc=2
                        wmess('Заблокированно дебеторкой',2)
                        loop
                     endif
                  endif
                  if empty(rs1->docguid)
                     if gnRfp=1
                        if gnEnt=20.and.kplr#0.and.pr361r=1.and.!(kopr=169.or.kopr=168).and.gnVo=9
                           prfp_rr=0
                           codelistr=getfield('t1','kplr','kpl','codelist')
                           if !empty(codelistr)
                              ckopr=str(kopr,3)
                              if at(ckopr,codelistr)=0
 //                                 ach:={'Нет','Да'}
 //                                 achr=0
 //                                 achr=alert('Недопустимый код операции.Продолжить?',ach)
 //                                 if achr=2
 //                                    prfp_rr=1
 //                                 endif
                                wmess('Недопустимый код операции',1)
                                prfp_rr=0
                              else
                                prfp_rr=1
                              endif
                           else
 //                              ach:={'Нет','Да'}
 //                              achr=0
 //                              achr=alert('Нет привяз кодов опер.Продолжить?',ach)
 //                              if achr=2
 //                                 prfp_rr=1
 //                              endif
                              wmess('Нет привяз кодов опер',1)
                              prfp_rr=0
                           endif
                        else
                           prfp_rr=1
                        endif
                        if prfp_rr=1.and.!docblk()
                           dfpr=date()
                           tfpr=time()
                           sele rs1
                           if EmptyDFp(dfp)
                              prModr=1
                           endif
                        endif
                     endif
                  endif
                  if (gnSPech=1.or.gnAdm=1).and.!empty(dfpr).and.((pvtr=1.and.who=2.or.pvtr=0.and.who=5).or.(who=3.or.who=1.or.who=4))
                     gnOutr=gnOut
                     if gnAdm=0
                        gnOut=1
                     endif
                     ctovr=gnCtov
                     skr=gnSk
                     sele rs1
                     netseek('t1','ttnr',,,1)
                     if !empty(dspr) //.and.who=2
                        appsfr=2
                        appsf={'ДА ','НЕТ'}
                        appsfr=alert('СЧЕТ-КОПИЯ! Продолжить печать ?',appsf)
                        if appsfr=1
                           RsPrn(2)
                        endif
                     else
                        RsPrn(2)
                     endif
 //                     rprhp()
                     gnOut=gnOutr
                     sele rs1
                  endif
                  prModr=1
             case lastkey()=K_ALT_F4.and.who#0.and.gnArm=3 // Сетевая печать/Фин подтв
               If kopr=169 .and. !(Sdvr < 50000 ) //Sdv50000
                  wmess('Ограничение по сумме д-та 50000',2)
                  loop
               EndIf
                  if gnEnt=21
                     if !chklic()
                        loop
                     endif
                  endif
                  sele rs1
                  if fieldpos('fc')#0
                     if fc=1
                        wmess('Заблокированно финконтролем',2)
                        loop
                     endif
                     if fc=2
                        wmess('Заблокированно дебеторкой',2)
                        loop
                     endif
                  endif
                  if empty(rs1->docguid)
                     if gnRfp=1.and.!docblk()
                        dfpr=date()
                        tfpr=time()
                        sele rs1
                        if EmptyDfp(dFp)
                           prModr=1
                        endif
                     endif
                  endif
                  if (gnSPech=1.or.gnAdm=1).and.!empty(dfpr).and.((pvtr=1.and.who=2.or.pvtr=0.and.who=5).or.(who=3.or.who=1.or.who=4))
                     gnOutr=gnOut
                     gnOut=1
                     ctovr=gnCtov
                     skr=gnSk
                     sele rs1
                     netseek('t1','ttnr',,,1)
                     if !empty(dspr) //.and.who=2
                        appsfr=2
                        appsf={'ДА ','НЕТ'}
                        appsfr=alert('СЧЕТ-КОПИЯ! Продолжить печать ?',appsf)
                        if appsfr=1
                           RsPrnm(2)
                        endif
                     else
                        RsPrnm(2)
                     endif
 //                     rprhp()
                     gnOut=gnOutr
                     sele rs1
                  endif
                  prModr=1
             case lastkey()=K_F5.and.who#0 // Локальная печать
               If kopr=169 .and. !(Sdvr < 50000 ) //Sdv50000
                  wmess('Ограничение по сумме д-та 50000',2)
                  loop
               EndIf
                  if gnEnt=21
                     if !chklic()
                        loop
                     endif
                  endif
                  if ktasr#0
                  endif
                  sele rs1
                  if fieldpos('fc')#0
                     if fc=1
                        wmess('Заблокированно финконтролем',2)
                        loop
                     endif
                     if fc=2
                        wmess('Заблокированно дебеторкой',2)
                        loop
                     endif
                  endif
                  ctovr=gnCtov
                  skr=gnSk
                  sele rs1
                  netseek('t1','ttnr',,,1)
                  if gnCtov=1.and.gnRfp=1.and.!docblk().or.gnCtov#1
                     dfpr=date()
                     tfpr=time()
                     sele rs1
                     if EmptyDfp(dFp)
                        prModr=1
                     endif
                  endif
                  if gnCtov=1
                     if !empty(dfpr)
                         RsPrn(1)
                     else
                         wmess('Нет фин подтверждения',2)
                         loop
                     endif
                  endif
                  sele rs1
                  if gnCtov=1
 //                     rpaotv()
                  endif
                  prModr=1
             case lastkey()=K_ALT_F6.and.who#0 // Печ1ТН
                  sele rs1
                  if fieldpos('fc')#0
                     if fc=1
                        wmess('Заблокированно финконтролем',2)
                        loop
                     endif
                     if fc=2
                        wmess('Заблокированно дебеторкой',2)
                        loop
                     endif
                  endif
                  ctovr=gnCtov
                  skr=gnSk
                  sele rs1
                  netseek('t1','ttnr',,,1)
                  if gnRfp=1.and.!docblk()
                     dfpr=date()
                     tfpr=time()
                     sele rs1
                     if EmptyDfp(dFp)
                        prModr=1
                     endif
                  endif
                  if !empty(dfpr).or.gnCtov#1
                     RsPrn(3)
                  else
                      wmess('Нет фин подтверждения',2)
                      loop
                  endif
                  sele rs1
                  if gnCtov=1
 //                     rpaotv()
                  endif
                  prModr=1
             case lastkey()=K_ALT_F7.and.who#0 // ПечТНН
                  sele rs1
                  if fieldpos('fc')#0
                     if fc=1
                        wmess('Заблокированно финконтролем',2)
                        loop
                     endif
                     if fc=2
                        wmess('Заблокированно дебеторкой',2)
                        loop
                     endif
                  endif
                  ctovr=gnCtov
                  skr=gnSk
                  sele rs1
                  netseek('t1','ttnr',,,1)
                  if gnRfp=1.and.!docblk()
                     dfpr=date()
                     tfpr=time()
                     sele rs1
                     if EmptyDfp(dFp)
                        prModr=1
                     endif
                  endif
                  if !empty(dfpr).or.gnCtov#1
                    RsPrn(4)
                  else
                    wmess('Нет фин подтверждения',2)
                    loop
                  endif
                  sele rs1
                  if gnCtov=1
 //                     rpaotv()
                  endif
                  prModr=1
             case lastkey()=K_ALT_F5.and.who#0 // Локальная печать
               If kopr=169 .and. !(Sdvr < 50000 ) //Sdv50000
                  wmess('Ограничение по сумме д-та 50000',2)
                  loop
               EndIf
                  sele rs1
                  if fieldpos('fc')#0
                     if fc=1
                        wmess('Заблокированно финконтролем',2)
                        loop
                     endif
                     if fc=2
                        wmess('Заблокированно дебеторкой',2)
                        loop
                     endif
                  endif
                  ctovr=gnCtov
                  skr=gnSk
                  sele rs1
                  netseek('t1','ttnr',,,1)
                  if gnRfp=1.and.!docblk()
                     dfpr=date()
                     tfpr=time()
                     sele rs1
                     if EmptyDfp(dFp)
                        prModr=1
                     endif
                  endif
                  if !empty(dfpr).or.gnCtov#1
                     RsPrnm(1)
                  else
                      wmess('Нет фин подтверждения',2)
                      loop
                  endif
                  sele rs1
                  if gnCtov=1
                     //rpaotv()
                  endif
                  prModr=1
             case lastkey()=K_ALT_F8.and.who#0 // ПечТНН1
                  PrnOprnr=1
                  sele rs1
                  if fieldpos('fc')#0
                     if fc=1
                        wmess('Заблокированно финконтролем',2)
                        loop
                     endif
                     if fc=2
                        wmess('Заблокированно дебеторкой',2)
                        loop
                     endif
                  endif
                  ctovr=gnCtov
                  skr=gnSk
                  sele rs1
                  netseek('t1','ttnr',,,1)
                  if gnRfp=1.and.!docblk()
                     dfpr=date()
                     tfpr=time()
                     sele rs1
                     if EmptyDfp(dFp)
                        prModr=1
                     endif
                  endif
                  if !empty(dfpr).or.gnCtov#1
                     RsPrn(4)
                  else
                      wmess('Нет фин подтверждения',2)
                      loop
                  endif
                  sele rs1
                  if gnCtov=1
                    // rpaotv()
                  endif
                  prModr=1
             case lastkey()=K_F6.and.who#0.and.who#5.and.!empty(dopr) // НДС
                  if bom(gdTd)<ctod('01.03.2011')
                     if gnVo#4
                        if prnnr=1.and.who#0.and.!empty(rs1->dop)
                           prnnds()
                           prModr=1
                        endif
                     else
                        if rs1->prz=1
                           kplr=sklr
                           prnnr=1
                           prnnds()
                           prModr=1
                        endif
                     endif
                     if nndsr#0
                        sele rs1
                        if nnds#nndsr
                           netrepl('nnds','nndsr',1)
                           prModr=1
                        endif
                     endif
                  else
                    if rs1->dot<ctod('16.12.2011')
                       prnnn(0,0,gnSk,ttnr,0)
                    else
                       if pr1ndsr=0
                          prnds(0,0,gnSk,ttnr,0)
                       else
                          wmess('Только из Финансиста!',2)
                       endif
                    endif
                  endif
             case lastkey()=K_F7 // Серт.на тару
                  tsert()
             case lastkey()=K_F8.and.prdp().and.(who=2.or.who=3.or.who=4).and.rs1->prz=0.AND.;
                               IIF(!EMPTY(Dopr),gnCorsh=1 .OR. gnAdm=1,.T.)
              // Коррекция шапки
                  if rs1->pr177=2
                     wmess('НИЗЗЯ!!!',2)
                     loop
                  endif
                  if rs1->pr169=2.or.rs1->pr129=2.or.rs1->pr139=2
                     wmess('НИЗЗЯ!!!',2)
                     loop
                  endif
                  if rs1->mk129#0.or.rs1->mk139#0
                     wmess('НИЗЗЯ!!!',2)
                     loop
                  endif
                  if mk169r#0
                     wmess('Снимите признак уценки.НИЗЗЯ!!!',2)
                     loop
                  endif
                  if rs1->kopi=177.and.(kopr=169.or.kopr=168).and.!(gnAdm=1.or.gnKto=160.or.gnKto=71.or.gnKto=848.or.gnKto=28.or.gnKto=217.or.gnKto=786)
                     wmess('НИЗЗЯ!!!',2)
                     loop
                  endif
                  if gnEnt=20.and.rs1->kopi=174.and.(kopr=169.or.kopr=168).and.!(gnAdm=1.or.gnKto=160.or.gnKto=71.or.gnKto=848.or.gnKto=28)
                     wmess('НИЗЗЯ!!!',2)
                     loop
                  endif
                  if gnEnt=20.and.gnVo=9.and.gnCorsh=0
                     if !empty(rs1->dfp)
                         wmess('Фин.подтв.НИЗЗЯ!!!',2)
                         loop
                     endif
                  endif
                  if vor=9.and.gnAdm=0.and.kopr=169
                     pr169_r=0
                     sele rs2
                     mntov_r=0
                     if netseek('t1','ttnr')
                        do while ttn=ttnr
                           mntov_r=mntov
                           sele ctov
                           if fieldpos('pr169')#0
                              pr169_r=getfield('t1','mntov_r','ctov','pr169')
                              if pr169_r=1
                                 exit
                              endif
                           else
                           endif
                           sele rs2
                           skip
                        enddo
                     endif
                     if pr169_r=1
                        wmess(str(mntov_r,7)+' Только 169',2)
                        loop
                     endif
                  endif
                  corsh=1
                  kpl_fr=kplr
                  nKkl_fr=Nkklr
                  kgp_fr=kgpr
                  kpv_fr=kpvr
                  if fieldpos('prdec')#0
                     prdec_fr=prdec
                  else
                     prdec_fr=0
                  endif
                  nds_fr=ndsr
                  pnds_fr=pndsr
                  xnds_fr=xndsr
                  kop_fr=kopr
                  prnn_fr=prnnr
                  nof_fr=nofr
                  esc_r=1
                  netUse('dokk')
                  netUse('bs')
                  netUse('dkkln')
                  netUse('dknap')
                  netUse('s_tag')
                  sele rs1
                  exit
             case lastkey()=K_F9 // Товар
                  exit
             case lastkey()=-9.and.!(who=0.or.who=2.or.who=5) // Подтверждение возврата ТТН на склад
                  sele rs1
                  if empty(rs1->dvttn)
                     netrepl('dvttn,tvttn,ktovttn','date(),time(),gnKto',1)
                     prModr=1
                  endif
             case lastkey()=K_SH_F10.and.who#0 // SHIFT-F10 СНЯТИЕ K_ F 29
                  sele rs1
                  if !empty(rs1->dvttn)
                     netrepl('dvttn,tvttn,ktovttn','CTOD(""),time(),gnKto',1)
                     dvttnr=ctod('')
                     prModr=1
                  endif
             case lastkey()=K_ALT_F10.and.who#0.and.who#5 // (ALT-F10) печать сертификатов
                  RsSert()
             case lastkey()=K_ESC // Закончить
                  if prZn=0
                  endif
                  esc_r=1
                  exit
          endcase
       enddo
    enddo

    If SpoofMode //pr169rEQ2(ttnr) // возварат подмены
      SpoofMode := .F.
      SpoofModeOff()
    endif

    if prModr=1
       sele rs1
       netrepl('dtmod,tmmod','date(),time()')
       skr=gnSk
       rmskr=gnRmsk
       netuse('dkkln')
       netuse('dknap')
       netuse('dokko')
       if rs1->prz=1
          rsprv(1,0)
       else
          if !empty(dopr)
             rsprv(1,1)
          endif
       endif
    endif
    sele rs1
    bon174() // libfcne.prg
enddo
unlock all
nuse()
nuse('tovsrt')
if gnCtov=1
   nuse('tovmsrt')
endif
return

*************
func ztxt(p1)
  *************
  LOCAL getlist:={}, lAccDeb:=.F.
  LOCAL dDvp, nKta, nSdv, nRec, SdvTtn

  sele rs1
  if fieldpos('ztxt')=0
     retu .t.
  endif
  If file(gcPath_ew+"deb\accord_deb"+".dbf")
    netuse('dkkln')
    USE (gcPath_ew+"deb\accord_deb") ALIAS skdoc NEW SHARED READONLY
    SET ORDER TO TAG t1
    lAccDeb:=.T.
  endif


  // получим список задания дате в которой ТА и ТА
  sele rs1
  dDvp := rs1->dvp
  nKta := rs1->Kta
  nRec:=RECNO()

  // сумма заданий по ТА за сегодня
  tzvk_crt()
  sele rs1
  DBEval(;
  {||tzvk_ztxt(rs1->nkkl,rs1->kpv,rs1->ztxt,rs1->ttn)},;
  {||rs1->dvp = dDvp .and. !empty(rs1->ztxt) .and. nKta = rs1->Kta };
  )
  sele tzvk
  SUM Sdv TO nSdv
  copy to tzvk_kta

  sele rs1
  DBGoTo(nRec)
  sele tzvk
  SUM Sdv TO nSdvTtn FOR ttn2 = rs1->ttn



  sele rs1
  DBGoTo(nRec)
  if empty(dfp)
    // 4 read
    // все задания на за день тек ТТН    outlog(__FILE__,__LINE__,dDvp)
    sele tzvk
    zap
    sele rs1
    DBEval(;
    {||tzvk_ztxt(rs1->nkkl,rs1->kpv,rs1->ztxt,rs1->ttn)},;
    {||rs1->dvp = dDvp .and. !empty(rs1->ztxt) };
    )
    sele tzvk
    copy to tzvkfull
    use tzvkfull new
  endif

  sele rs1
  DBGoTo(nRec)

  cltxtr=setcolor('gr+/b,n/bg')
  wztxtr=wopen(9,10,17,66)
  wbox(1)
  ztxt1_r=subs(ztxtr,1,50)
  ztxt2_r=subs(ztxtr,51,50)
  ztxt3_r=subs(ztxtr,101,50)
  ztxt4_r=subs(ztxtr,151,50)
  @ 0,0 say 'ОБЩАЯ заявка экспедитору по ТА'+str(nKta,4) +' на СУММУ='+TRANSFORM(nSdv,"@R 999'999.99") color 'gr+/b'
  @ 5+1,0 say 'По выбраной ТТН СУММА='+TRANSFORM(nSdvTtn,"@R 999'999.99") color 'gr+/b'

  sele rs1
  if empty(dfp)

     @ 1+1,1 get ztxt1_r valid tzvkfull->(Chk_ztzt(ztxt1_r+ztxt2_r+ztxt3_r+ztxt4_r))
     @ 2+1,1 get ztxt2_r valid tzvkfull->(Chk_ztzt(ztxt1_r+ztxt2_r+ztxt3_r+ztxt4_r))
     @ 3+1,1 get ztxt3_r valid tzvkfull->(Chk_ztzt(ztxt1_r+ztxt2_r+ztxt3_r+ztxt4_r))
     @ 4+1,1 get ztxt4_r valid tzvkfull->(Chk_ztzt(ztxt1_r+ztxt2_r+ztxt3_r+ztxt4_r))

     read
     close tzvkfull
  else
     @ 1+1,1 say ztxt1_r
     @ 2+1,1 say ztxt2_r
     @ 3+1,1 say ztxt3_r
     @ 4+1,1 say ztxt4_r
     inkey(0)
  endif
  wbox(1)
  wclose(wztxtr)
  setcolor(cltxtr)
  if lastkey()=K_ENTER.and.empty(dfp)
     ztxtr=ztxt1_r+ztxt2_r+ztxt3_r+ztxt4_r
     sele rs1
     if !empty(p1)
        netrepl('ztxt','ztxtr',1)
     else
        netrepl('ztxt','ztxtr')
     endif
  endif
  If lAccDeb
    close skdoc
  endif
  close tzvk
  return .t.


/*****************************************************************
 
 FUNCTION:
 АВТОР..ДАТА..........С. Литовка  02-14-17 * 12:09:53pm
 НАЗНАЧЕНИЕ.........
 ПАРАМЕТРЫ..........
 ВОЗВР. ЗНАЧЕНИЕ....
 ПРИМЕЧАНИЯ.........
 */
FUNCTION Chk_ztzt(cZtxt)
  LOCAL nSel:=SELECT(), lRet:=.T.
  sele tzvk
  zap
  // выцепить строку с ТТН
  tzvk_ztxt(0,0,cZtxt,0)

  sele tzvk
  DBGoTop()
  Do While !EOF()
    sele tzvkfull
    locate for tzvk->ttn = tzvkfull->ttn
    If found()
      If rs1->ttn = tzvkfull->ttn2 // нашли саму себя
        Continue
      endif
      If found()
        wmess('TTН задания ' + str(tzvk->ttn) + ' найдена в ТТН ';
               + str(tzvkfull->ttn2),3)
        lRet:=.F.
      endif
    endif
    sele tzvk
    skip
  enddo

  RETURN (lRet )

/*****************************************************************
 
 FUNCTION:
 АВТОР..ДАТА..........С. Литовка  05-20-18 * 09:17:32pm
 НАЗНАЧЕНИЕ.........
 ПАРАМЕТРЫ..........
 ВОЗВР. ЗНАЧЕНИЕ....
 ПРИМЕЧАНИЯ.........
 */
STATIC FUNCTION pr169r2Email(xBeg,lFull)
  STATIC nRunTime, sFull
  LOCAL cMess, cFlMess, cMessErr,cPRINTER_CHARSET
  LOCAL cListEMail:="oleg_ta@rambler.ru,lista@bk.ru"
  if gnEnt=21
    cListEMail:='vadim_5@rambler.ru,lista@bk.ru'
  endif


  If (gnAdm=1 ) //.or.str(gnKto,4)$' 129; 160; 117' ) // Калюжный Таранец Ищенко 169
    return nil
  endif

  If Empty(xBeg)
    cMess:='Закончили работу с д-том'
  else
    cMess:='Начали работу с д-том'
    nRunTime:=Seconds()
    sFull:=lFull
  endif

  cFlMess:='uc_mess'+'.txt'

  cPRINTER_CHARSET:=set("PRINTER_CHARSET","koi8-u")
  set console off
  set print on
  set print to (cFlMess)

  ?cMess, date(), time(), Iif(sFull,'Развернутый','Свернутый')
  iif(Empty(xBeg),QQOUT(' время работы',nRunTime-Seconds(),'c'),NIL)
  ?
  ?'Склад:', gnSk, '"'+gcNskl+'"','ТТН N',ttnr, dvpr, kopr
  ?'Кто:', gnKto, gcName //getfield('t1','gnKto','speng','fio')
  ?
  ?'сетевое имя машины',gcNNETNAME,"Логин входа",atrepl('\',gcUname,'_')

  set print to
  set print off
  set("PRINTER_CHARSET",cPRINTER_CHARSET)

  cMessErr:=memoread(cFlMess )

  SendingJafa(cListEMail, {{ "","Нарушение ограничений ("+str(gnEnt,3);
  +") "+gcName_c+' '+DTOC(date(),"YYYYMMDD")}},;
  cMessErr,;
  228)

  RETURN (NIL )


/*****************************************************************
 
 FUNCTION:
 АВТОР..ДАТА..........С. Литовка  05-06-19 * 03:27:37pm
 НАЗНАЧЕНИЕ.........
 ПАРАМЕТРЫ..........
 ВОЗВР. ЗНАЧЕНИЕ....
 ПРИМЕЧАНИЯ.........
 */
STATIC FUNCTION EmptyDFp(dfp)
  LOCAL lRet:=.F.
  If Empty(dfp)
    If vo=9 // продажи
      netrepl('ktofp',{-000},1)
    Else
      netrepl('dfp,tfp,ktofp',{dfpr,tfpr,gnKto},1)
      rso(23)
      lRet:=.T.
    endif
  endif
  RETURN (lRet )

/*****************************************************************
 
 FUNCTION:
 АВТОР..ДАТА..........С. Литовка  11-20-19 * 00:42:51am
 НАЗНАЧЕНИЕ.........
 ПАРАМЕТРЫ..........
 ВОЗВР. ЗНАЧЕНИЕ....
 ПРИМЕЧАНИЯ.........
 */
STATIC FUNCTION SayRs1_00_05()
   @ 0,1 say  'Номер      '
   @ 0,63 say gcNskl
   if empty(docguidr)
      @ 0,31 say 'Договор '+space(9)+' от '
      @ 1,1 say  'Дата       '
   else
      @ 0,31 say 'Основание '
   endif
   @ 2,1 say  'Операция   '
   @ 3,1 say  'Источник   '
   @ 5,1 say  'Назначение '
  RETURN (NIL )


/*****************************************************************
 
 FUNCTION:
 АВТОР..ДАТА..........С. Литовка  11-20-19 * 00:27:09am
 НАЗНАЧЕНИЕ.........
 ПАРАМЕТРЫ..........
 ВОЗВР. ЗНАЧЕНИЕ....
 ПРИМЕЧАНИЯ.........
 */
STATIC FUNCTION Say_prz_1()
   if rs1->prz=1
      @ 0,14 say str(ttnr,6)+'->ПОДТВ    ' color 'r+/n'
      @ 1,14 say dtoc(dotr)
   else
      if !empty(dopr)
         @ 0,14 say str(ttnr,6)+ '->ОТГРУЖЕН ' color 'rb+/n'
         @ 1,14 say dtoc(dopr)
      else
         if empty(dfpr)
            if !empty(ddcr).or.corsh=1
              If empty(ktofpr) .or. ktofpr < 0 // авто ФП - не прошел
                @ 0,14 say str(ttnr,6)+'->ВЫПИСАН  ' color 'gr+/n'
              Else
                @ 0,14 say str(ttnr,6)+'->ПРОВЕДЕН ' color 'gb+/n'
              EndIf
            endif
            @ 1,14 say dtoc(dvpr)
         else
            if empty(dspr) .and. !empty(dfpr)
               @ 0,14 say str(ttnr,6)+'->Ф.ПОДТВ.' color 'w+/n'
               @ 1,14 say dtoc(dfpr)
            elseif !empty(dspr)
               @ 0,14 say str(ttnr,6)+'->ОТГРУЗКА' color 'bg+/n'
               @ 1,14 say dtoc(dspr)
            endif
         endif
      endif
   endif
   @ 23,1 Say 'Маршрут '+str(mrshr,6)+' '+'Экспедитор'+' '+str(kecsr,4)+' '+getfield('t1','kecsr','s_tag','fio')
   @ 23,70 say dtoc(dtmodr)
  RETURN (NIL )


/*****************************************************************
 
 FUNCTION:
 АВТОР..ДАТА..........С. Литовка  12-19-19 * 03:17:59pm
 НАЗНАЧЕНИЕ.........
 ПАРАМЕТРЫ..........
 ВОЗВР. ЗНАЧЕНИЕ....
 ПРИМЕЧАНИЯ.........
 */
STATIC FUNCTION SpoofModeOff()
  nuse('rs2')
  nuse('rs2m')

  netuse('rs2')
  netuse('rs2m')

  sele rs2
  set orde to tag t1
  netseek('t1','ttnr')

  sele rs2m
  set orde to tag t1
  netseek('t1','ttnr')

  who:=ln_who
  If gnKto=117 // таранец
    FKtor:=ln_FKtor
  endif
  pere(3)   // Полный перерасчет RS3
  pr169r2Email(NIL)
  RETURN (NIL )
