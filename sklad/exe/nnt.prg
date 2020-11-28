#include "common.ch"
#include "inkey.ch"
****************************************
* Налоговая накладная по товару
****************************************
*Private Ttnr,Men1,Tlfr,Nnr,Nsvr,Kkl1r,Nklr,Adrr,Dotr,Sdvr,Nopr
*Private Kopr,Vor,Sklr,Stri,Err,Rnds,Tar_kl,N_nds,prnnr,cntnttr,ddokr
if gnPnds=1 // Бухгалтер
else        // 2 - Склад
   skr=gnSk
endif
ddokr=ctod('')
prnnr=1  // По товару
save scre to scnnt
clnnt=setcolor('g/n,n/g')
clea
*Открытие баз данных
netuse('bs',,'s')
netuse('dokk',,'s')
netuse('dkkln',,'s')
netuse('dknap',,'s')
netuse('kln',,'s')
netuse('tara',,'s')
netuse('nds',,'s')
netuse('tovn')
netuse('klndog')
*netuse('opfh')
if select('sl')=0
   sele 0
   use _slct alia sl      //s_slct
   if !nota('Склад занят !  Подождите немного !')
      retu
   endi
else
   sele sl
endif
zap
if gnPnds#1
**************************
* Закрыть коррекцию
**************************
* Сохранить переменные
nop_rr=nopr
ttn_rr=ttnr
sr_rr=srr
kop_rr=kopr
vu_rr=vur
vo_rr=vor
skl_rr=sklr
rnds_rr=rndsr
nds_rr=ndsr
cntttn_rr=cntttnr
bs_rr=bsr
ddok_rr=ddokr
sdv_rr=sdvr
sk_rr=skr
*
sele nds
set orde to tag t2
if netseek('t2','kplr')
   store 0 to sndsdr,sndscr,korktlr,ndsdr
   store ctod('') to dnnr
   do while kkl=kplr
      if korktl#0
         korktlr=korktl
      endif
      if ndsd=0.and.ttn=0.and.sk=0 // НН под деньги
         ndsdr=nomnds
         sndsdr=sndsdr+sum
         dnnr=dnn
      else
         sndscr=sndscr+sumc
      endif
      skip
   endd
   szcorr=sndsdr-sndscr
   if szcorr>0
      sumcr=szcorr
      nopr='Отпуск ТМЦ по предоплате'
      ttnr=0
      srr=0
      kopr=0
      vur=0
      vor=0
      sklr=0
      rndsr=0
      ndsr=0
      cntttnr=1
      bsr=0
      if gnArm=3
         dtt=dopr
      else
         if month(gdTd)#month(date())
            dtt=eom(gdTd)
         else
            dtt=gdTd
         endif
      endif
      ddokr=dtt
      sele setup
      locate for ent=gnEnt
      reclock()
      nomndsr=nnds
      sele nds
      do while .t.
         if netseek('t1','nomndsr')
            nomndsr=nomndsr+1
            loop
         endif
         sele setup
         netrepl('nnds','nomndsr+1')
         exit
      endd
      sele nds
      netadd()
      netrepl('nomnds,sum,sumc,kkl,dnn,ttn,ndsd,d0k1,korktl,rmsk',;
              'nomndsr,sumcr,sumcr,kplr,dtt,0,ndsdr,d0k1r,korktlr,gnRmsk')
      korktlr=korktl
      kklr=kkl
      nklr=nkplr
      sele kln
      if netseek('t1','kplr')
         adrr=adr
         tlfr=tlf
         nsvr=nsv
         nnr=nn
         kkl1r=kkl1
      endif
      sumkr=sumcr
      aTtn:={}
      private aRab[1,5]
      aRab[1,1]=0 //ttnr
      aRab[1,2]=0
      aRab[1,3]=sumcr
      aRab[1,4]=sumcr
      aRab[1,5]=dtt
      PNN()
   endif
endif
**************************
* Конец закрытия коррекции
**************************
* Восстановить переменные
nopr=nop_rr
ttnr=ttn_rr
srr=sr_rr
kopr=kop_rr
vur=vu_rr
vor=vo_rr
sklr=skl_rr
rndsr=rnds_rr
ndsr=nds_rr
cntttnr=cntttn_rr
bsr=bs_rr
ddokr=ddok_rr
sdvr=sdv_rr
skr=sk_rr
*
endif
sele sl
zap
Do While .T.
  clea
  sele sl
  zap
  save scree to scnnt
  aKln={} // Массив клиентов с деньгами
  if gnPnds=1
     store 0 to ttnr,kplr
  endif
  store 0 to Tar_kl,Kkl1r,Nnr,err,sumdr,sumkr,sumtr,prcor,;
             sumcr,ndsdr,nomndsr,sumr,sumdtr,sumdcr,bsr
  store '' to Adrr,Nsvr,Tlfr
  knds=1
  sumcr=0.00
  Men1  = 1
  sele dkkln
  go top
  save scre to scmess
  mess('Ждите,идет подготовка...')
  if gnPnds=1
     do while !eof()
        bsr=bs
        if !(kn-dn+kr-db>0.and.kr>db).or.getfield('t1','bsr','bs','uchr')#2
           skip
           loop
        endif
        kklr=kkl
        if kn-dn>0
           sumdr=kr-db-dn
        else
           sumdr=kn-dn+kr-db
        endif
        sele kln
        seek str(kklr,7)
        if FOUND()
           nklr:=nkl //subs(nkl,1,30)
        else
           nklr='Нет в справочнике             '
        endif
        aadd(aKln,nklr+'│'+str(kklr,7)+'│'+str(sumdr,12,2))
        sele dkkln
        skip
     endd
  else
     netseek('t1','kplr')
     do while kkl=kplr
        bsr=bs
        if !(kn-dn+kr-db>0.and.kr>db).or.getfield('t1','bsr','bs','uchr')#2  // bs#6200
           skip
           if eof()
              exit
           endif
           loop
        endif
        kklr=kkl
        if kn-dn>0
           sumdr=kr-db-dn
        else
           sumdr=kn-dn+kr-db
        endif
        sele kln
        seek str(kklr,7)
        if FOUND()
           nklr:=nkl
        else
           nklr='Нет в справочнике             '
        endif
        aadd(aKln,nklr+'│'+str(kklr,7)+'│'+str(sumdr,12,2))
        sele dkkln
        skip
     endd
  endif
  rest scre from scmess
  @ 0,0,6,78 box frame
  Set Cursor On
  if gnArm=5
     Dtt = gdTd
  else
     Dtt = getfield('t1','ttnr','rs1','dop')
     if dtt=ctod(' ')
        dtt=gdTd
     endif
  endif
  wdtt=wopen(10,30,13,50)
  wbox(1)
  @ 0,1 say 'Дата' get dtt
  read
  wclose(wdtt)
  if gnPnds=1
     @ 1,1 Say 'Клиент' Get kplr Picture '9999999'
     Read
  endif
  If LastKey() = 27
    Exit
  EndIf
  if kplr=0.and.gnPnds=1
     save scre to scmess
     mess('Ждите,идет отбор клиентов...')
     sele kln
     copy stru to (gcPath_l+'\kln.dbf')
     use
     sele 0
     use (gcPath_l+'\kln.dbf') excl
     netuse('kln','kln1','s')
     store 0 to mnds1r,mnds2r,mnds3r
     sele dokk
     seek str(0,6)+str(0,6)
     if FOUND()
        kklr=0
        rnr=0
        do while mn=0.and.rnd=0
           if prnn=0
              skip
              loop
           endif
           if kkl=kklr
              skip
              loop
           endif
           do case
              case nds=0.or.nds=1.or.nds=5  // 03.04.2000
                   mnds1r=1
              case nds=2
                   mnds2r=1
              case nds=3.or.nds=4
                   mnds3r=1
           endc
           kklr=kkl
           rnr=rn
           sele kln1
           seek str(kklr,7)
           if FOUND()
              kkl1r=kkl1
              nklr=nkl
           else
              kkl1r=0
              nklr='Нет в справочнике'
           endif
           sele kln
           netadd()
           netrepl('kkl,kkl1,nkl','kklr,kkl1r,nklr')
           sele dokk
           skip
        enddo
     endif
     sele kln1
     use
     sele kln
     inde on nkl tag t1
     set orde to tag t1
     go top
     rest scre from scmess
*     kplr=slc('kln',,,,,'nkl c(30),kkl n(7,0)','Наименование,Код','kkl',0,1)
     kplr=slcf('kln',,,,,"e:nkl h:'Наименование' c:c(30) e:kkl h:'Код' c:n(7)",'kkl')
     sele kln
     use
     erase (gcPath_l+'\kln.dbf')
     erase (gcPath_l+'\kln.cdx')
     netuse('kln',,'s')
  endif
  if kplr=0
     exit
  endif
  sele kln
  seek str(kplr,7)
  if FOUND()
     nklr=alltrim(nkl)
     adrr=adr
     tlfr=tlf
     nnr=nn
     nsvr=nsv
     kkl1r=kkl1
  else
     nklr='Нет в справочнике'
     store '' to adrr,tlfr,nsvr
     nnr=0
  endif
  @ 1,1 Say 'Клиент '+str(kkl1r,8)+'('+str(kplr,7)+') '+nklr
  @ 2,1 Say 'Адрес   '+adrr
  @ 3,1 Say 'Телефон '+tlfr
  @ 4,1 Say 'Налог.N '+str(nnr,14)
  @ 5,1 Say 'Сертиф. '+nsvr
  kszrr=12
  netuse('rs3')
  sele rs3
  if netseek('t1','ttnr,kszrr')
     tarar=0
  else
     tarar=1
  endif
  *sele tara
  *seek kplr
  *if FOUND()
  *   tarar=1
  *else
  *   tarar=0
  *endif
  a=0
  for i=1 to len(aKln)
      sumkr=val(subs(aKln[i],40,12))
     if val(subs(aKln[i],32,7))=kplr
        a=1
        exit
     endif
  next
  if a#0
     @ 2,45 say 'Контрольная сумма   '+str(sumkr,12,2)
  else
     @ 2,45 say 'Оплаты нет                     '
  endif
  sele nds
  set orde to tag t2
  seek str(kplr,7)+str(0,10)+str(0,3)
  aNnd ={} // Массив НН под деньги
  aNndt={} // Массив НН+ТТН+ННД под деньги (коррекция)
  aNnt ={} // Массив НН+ТТН под товар
  prnndr=0
  sumdr=0
  if FOUND() // Найдена НН по деньгам
     prnndr=1
     do while kkl=kplr.and.ndsd=0.and.sk=0
        aadd(aNnd,str(nomnds,6)+'│'+str(sum,12,2))
        sumdr=sumdr+sum
        skip
     endd
     for i=1 to len(aNnd)
         ndsdr=val(subs(aNnd[i],1,6))
         seek str(kplr,7)+str(ndsdr,10)
         if FOUND()
            do while kkl=kplr.and.ndsd=ndsdr
*               if dnn>=bom(gdTd).and.dnn<=eom(gdTd)
                  aadd(aNndt,str(nomnds,6)+'│'+str(sk,3)+'│'+str(ttn,6)+'│'+str(ndsdr,6)) // Заполнение массива выписанных НН из NDS под деньги
                  sumdtr=sumdtr+sum
                  sumdcr=sumdcr+sumc
*               endif
               skip
            endd
         else
         endif
     next

*     sumcr=sumdr-sumdtr
     sumcr=sumdr-sumdcr


     if str(sumcr,10,2)>str(0.00,10,2).and.substr(alltrim(str(sumcr,10,2)),1,1)#'-'  // Коррекция
        prcor=1
     else
        prcor=0
     endif
  endif

  seek str(kplr,7)+str(0,10)
  if FOUND()
     do while kkl=kplr.and.ndsd=0
        if sk=0
           skip
           loop
        endif
        if dnn>=bom(gdTd).and.dnn<=eom(gdTd)
           aadd(aNnt,str(nomnds,6)+'│'+str(sk,3)+'│'+str(ttn,6)) // Заполнение массива выписанных НН из NDS под товар
           sumtr=sumtr+sum
        endif
        skip
     endd
  endif
  aTtn={}
  if gnPnds=2
     do case
        case p_nds=0.or.p_nds=1.or.p_nds=5 // 03.04.2000
             mndsr=1
             @ 3,45 say '     Ставка 20%     '
        case p_nds=2
             mndsr=2
             @ 3,45 say '     Ставка  0%     '
        case p_nds=3.or.p_nds=4
             mndsr=3
             @ 3,45 say 'Ставка 20% с наценки'
     endc
     aadd(aTtn,'√│'+str(ttnr,6)+'│'+str(skr,3)) // ttn,выписываемая складом
  else
     @ 3,45 prom '     Ставка 20%     '
     @ 3,45 prom '     Ставка  0%     '
     @ 3,45 prom 'Ставка 20% с наценки'
     menu to mndsr
     if lastkey()=K_ESC
        loop
     endif
     sele dokk
     seek str(0,6)+str(0,6)+str(kplr,7)
     if FOUND()
        rnr=0
        do while mn=0.and.rnd=0.and.kkl=kplr
           do case
              case mndsr=1
                   if !(nds=0.or.nds=1.or.nds=5)  // 03.04.2000
                      skip
                      loop
                   endif
              case mndsr=2
                   if nds#2
                      skip
                      loop
                   endif
              case mndsr=3
                   if !(nds=3.or.nds=4)
                      skip
                      loop
                   endif
           endc
           if prnn=0
              skip
              loop
           endif
           if rnr=rn
              skip
              loop
           endif
           rnr=rn
           skr=sk
           p_nds=nds
           a=0
           for i=1 to len(aNndt)
               sk_r=val(subs(aNndt[i],8,3))
               ttn_r=val(subs(aNndt[i],12,6))
               if sk_r=skr.and.ttn_r=rnr
                  a=1
                  exit
               endif
           next
           if a=0
              for i=1 to len(aNnt)
                  sk_r=val(subs(aNnt[i],8,3))
                  ttn_r=val(subs(aNnt[i],12,6))
                  if sk_r=skr.and.ttn_r=rnr
                     a=1
                     exit
                  endif
              next
           endif
           if a=0
              aadd(aTtn,'√│'+str(rnr,6)+'│'+str(skr,3)) // Заполнение массива ttn,отсутств. в NDS
           endif
           skip
        endd
     endif
  endif
  @ 4,45 say 'Сумма для коррекции '+str(sumcr,12,2)
  if len(aTtn)=0  // Нет ttn для выписки НН
     save scre to scmess
     mess('Нет TTН для выписки НН')
     inkey(3)
     rest scre from scmess
     nuse()
     retu
  endif
  if gnPnds=1
     netuse('cskl',,'s')
     sumsdvr=0
     for i=1 to len(aTtn)
         sele cskl
         ttnr=val(subs(aTtn[i],3,6))
         skr=val(subs(aTtn[i],10,3))
         seek str(skr,3)
         Pathr=gcPath_d+alltrim(path)
         netuse('soper',,'s',1)
         netuse('rs1',,'s',1)
         seek str(ttnr,6)
         if FOUND()
            sdvr=sdv
            kopr=kop
            vor=vo
         else
            sdvr=0
            kopr=0
            vor=0
         endif
         use
         sele soper
         seek str(int(kopr/100),1)+str(vor,1)+str(vor,1)+str(mod(kopr,100),2)
         if FOUND()
            p_nds=nds
            ndsr=nds
         else
            p_nds=0
            ndsr=0
         endif
         use
         aTtn[i]=aTtn[i]+'│'+str(sdvr,15,2)+'│'+str(ndsr,1) // добавление суммы по докум.
         sumsdvr=sumsdvr+sdvr
         sele sl
         appe blank
         repl kod with str(ttnr,6)
     next
     @ 5,45 say 'Сумма отобранных ТТН'+str(sumsdvr,12,2)


     save scre to sc1
     @ 7,1 say '     Коррекция              Под товар                  Не выписанные' color 'w/n'
     oclr=setcolor('gr+/b,gr+/r,,,')
     cyclr=0
     do while cyclr=0
*    Накладные коррекция
        @ 24,0 say space(80) color 'n/w'
        @ 24,1 say '"ENTER" - Продолжить' color 'n/w'
        fnnd()
*    Накладные под товар
        @ 24,0 say space(80) color 'n/w'
        @ 24,1 say '"ENTER" - Продолжить' color 'n/w'
        fnnt()
*    Невыписанные
        @ 24,0 say space(80) color 'n/w'
        @ 24,1 say '"ENTER" - Выписать ;  "->" или "<-"  -Продолжить ; Space - Отбор' color 'n/w'
        fttn()
     enddo
     if cyclr=1
        oclr=setcolor(oclr)
        rest scre from sc1
        loop
     endif
     oclr=setcolor(oclr)
  else
     aTtn[1]=aTtn[1]+'│'+str(sdvr,15,2)+'│'+str(p_nds,1) // добавление суммы по докум.
  endif
  nrab=0
  for i=1 to len(aTtn)
      if subs(aTtn[i],1,1)=' '
         loop
      endif
      nrab++
  next
  private aRab[nrab,5]
  n=1
  for i=1 to len(aTtn)
      if subs(aTtn[i],1,1)=' '
         loop
      endif
      ttn_r=val(subs(aTtn[i],3,6))
      sk_r=val(subs(aTtn[i],10,3))
      sdv_r=val(subs(aTtn[i],14,15))
      aRab[n,1]=ttn_r
      aRab[n,2]=sk_r
      aRab[n,3]=sdv_r
      aRab[n,4]=sdv_r
      aRab[n,5]=ctod('')   // Наверное дата ТТН
      n++
  next
  if prcor=0            // Коррекции нет
     for i=1 to len(aRab)
         ttn_r=aRab[i,1]
         sk_r=aRab[i,2]
         sdv_r=aRab[i,3]
         sele nds
         if i=1
            sele setup
            locate for ent=gnEnt
            reclock()
            nomndsr=nnds
            sele nds
            do while .t.
               if netseek('t1','nomndsr')
                  nomndsr=nomndsr+1
                  loop
               endif
               sele setup
               netrepl('nnds','nomndsr+1')
               exit
            endd
            nndsr=nomndsr
         endif
         sele nds
         netadd()
         netrepl('nomnds,kkl,sk,ttn,sum,dnn,d0k1,rmsk',;
                 'nomndsr,kplr,sk_r,ttn_r,sdv_r,dtt,d0k1r,gnRmsk')
     next
  else                   // Коррекция
     for j=1 to len(aNnd)
         ndsdr=val(subs(aNnd[j],1,6))
         sndsdr=val(subs(aNnd[j],8,12))
         sele nds
         set orde to tag t2
         seek str(kplr,7)+str(ndsdr,10)
         ktlrr=korktl
         sndsdtr=0
         if FOUND()
            do while kkl=kplr.and.ndsd=ndsdr
*               sndsdtr=sndsdtr+sum
               sumcr=sumc
               sndsdtr=sndsdtr+sumcr
               skip
            enddo
         endif
*         if sndsdr-sndsdtr>0 .and. sndsdr-sndsdtr#0.00    // Коррекция НН под деньги
         if str((sndsdr-sndsdtr),1)#'0'    // Коррекция НН под деньги
            for i=1 to len(aRab)
                if aRab[i,3]=0
                   loop
                endif
                ttn_r=aRab[i,1]
                sk_r=aRab[i,2]
                sdv_r=aRab[i,3]
                sele nds
                sele setup
                locate for ent=gnEnt
                reclock()
                nomndsr=nnds
                sele nds
                do while .t.
                   if netseek('t1','nomndsr')
                      nomndsr=nomndsr+1
                      loop
                   endif
                   sele setup
                   netrepl('nnds','nomndsr+1')
                   exit
                endd
                nndsr=nomndsr
                sele nds
                netadd()
                netrepl('nomnds,ndsd,ttn,dnn,sk,sum,kkl,d0k1,rmsk',;
                        'nomndsr,ndsdr,ttn_r,dtt,sk_r,sdv_r,kplr,d0k1r,gnRmsk')
                aaa=sndsdr-sndsdtr-sdvr
                if aaa>=0 // TTN полностью вошла в НН по деньгам
                   netrepl('sumc','sdv_r')
                   aRab[i,3]=0
                else   // Сумма ТТН больше остатка по деньгам
                   netrepl('sumc','sndsdr-sndsdtr')
                   aRab[i,3]=0
                   aRab[i,4]=sndsdr-sndsdtr
                endif
            next
         else
         endif
     next
     for i=1 to len(aRab) // Выписка оставшихся НН после коррекции
         if aRab[i,3]=0
            loop
         endif
         ttn_r=aRab[i,1]
         sk_r=aRab[i,2]
         sdv_r=aRab[i,3]
         sele setup
         locate for ent=gnEnt
         reclock()
         nomndsr=nnds
         sele nds
         do while .t.
            if netseek('t1','nomndsr')
               nomndsr=nomndsr+1
               loop
            endif
            sele setup
            netrepl('nnds','nomndsr+1')
            exit
         endd
         nndsr=nomndsr
         sele nds
         netadd()
         netrepl('nomnds,ttn,dnn,sk,sum,kkl,d0k1,rmsk',;
                 'nomndsr,ttn_r,dtt,sk_r,sdv_r,kplr,d0k1r,gnRmsk')
     next
  endif
  PNN()
  exit
enddo

if gnPnds=1
   nuse()
endif

rest scre from scnnt
clnnt=setcolor(clnnt)
clea
Return .T.


*******************************************************************
* FUNCTIONS
*******************************************************************

func oaTtn(p1,p2,p3)
loca ttnr,sdvr
ttnr=subs(aTtn[p2],3,6)
sdvr=val(subs(aTtn[p2],14,15))
if lastkey()=32
   if subs(aTtn[p2],1,1)='√'
      aTtn[p2]=stuff(aTtn[p2],1,1,' ')
      sele sl
      locate for kod=ttnr
      if FOUND()
         dele
         sumsdvr=sumsdvr-sdvr
         @ 5,45 say 'Сумма отобранных ТТН'+str(sumsdvr,12,2) color 'g/n'
      endif
   else
      aTtn[p2]=stuff(aTtn[p2],1,1,'√')
      sele sl
      locate for kod=ttnr
      if !FOUND()
         appe blank
         repl kod with ttnr
         sumsdvr=sumsdvr+sdvr
         @ 5,45 say 'Сумма отобранных ТТН'+str(sumsdvr,12,2) color 'g/n'
      endif
   endif
   retu 2
else
   do case
      case lastkey()=K_ESC
           cyclr=1
           retu 0
      case lastkey()=K_ENTER
           cyclr=2
           retu 1
      case lastkey()=19.or.lastkey()=4
           cyclr=0
           retu 0
   othe
      retu 2
   endc

endif
***********************************************************************
func fnnd()
* Накладные под деньги
  if len(aNndt)=0
     aadd(aNndt,'Нет')
  endif
  teni(8,1,22,18)
  @ 8,1,22,18 box frame+space(1)
  achoice(9,2,21,17,aNndt)
retu

func fnnt()
  // * Накладные,выписанные под товар
  if len(aNnt)=0
     aadd(aNnt,'Нет')
  endif
  teni(8,5,22,43+20)
  @ 8,5,22,43+20 box frame+space(1)
  achoice(9,6,21,42+20,aNnt)
retu

func fttn()
  //* Невыписанные
  teni(8,48,22,78)
  @ 8,48,22,78 box frame+space(1)
  kodr=achoice(9,49,21,77,aTtn,,'oaTtn')
retu
