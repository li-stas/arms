#include "common.ch"
#include "inkey.ch"
// *(UDL) 22-04-89 // удал прих докум
if !prdp()
   retu
endif
set colo to g/n,n/g,,,
CLEAR
store CTOD(' ') to ddcr,dvpr,dnzr,dopr,dprr
STOR 0 TO N2,KPSR,N1,kpsr,nnzr,kopr,bsr,rnr,sopr,ktor,przr,;
          sdvr,sdfr,prNppr
store 1 to tarar
store 1 to vur,ndr
KLR=SPAC(7)

STOR 1 TO K1,K2,UD,DOK
STOR 0.000 TO OST1,OST2
skr=gnSk
rmskr=gnRmsk
if !netUse('PR1')
   nuse()
   retu
endif
if !netUse('PR2')
   nuse()
   retu
endif
if !netUse('PR3')
   nuse()
   retu
endif
if !netUse('tov')
   nuse()
   retu
endif
if gnCtov=2
   if !netuse('tovd')
      nuse()
      retu
   endif
endif
if gnCtov=1
   if !netuse('ctov')
      nuse()
      retu
   endif
   if !netuse('tovm')
      nuse()
      retu
   endif
endif
if !netUse('soper')
   nuse()
   retu
endif
if !netuse('kln')
   nuse()
   retu
endif
if !netuse('s_tag')
   nuse()
   retu
endif
if !netuse('stagm')
   nuse()
   retu
endif
if !netuse('speng')
   nuse()
   retu
endif
if !netuse('tmesto')
   nuse()
   retu
endif
if !netuse('moddoc')
   nuse()
   retu
endif
if !netuse('mdall')
   nuse()
   retu
endif
if !netuse('dknap')
   nuse()
   retu
endif
ex=0
*#ifdef __CLIP__
  // if !(netUse('dokk').AND.netuse('aninf').AND.netuse('aninfl').AND.netuse('DokA'))
  //    nuse()
  //    retu
  // endif
*#else
  if !netUse('dokk')
     nuse()
     retu
  endif
*#endif

if !netUse('bs')
   nuse()
   retu
endif
if !netUse ('dkkln')
   nuse()
   retu
endif
if !netUse ('dkklns')
   nuse()
   retu
endif
if !netUse ('dkklna')
   nuse()
   retu
endif
if !netUse ('vop')
   nuse()
   retu
endif
if !netUse ('cskl')
   nuse()
   retu
endif
if !netUse ('nnds')
   nuse()
   retu
endif
if !netUse ('kpl')
   nuse()
   retu
endif
if !netUse ('cntm')
   nuse()
   retu
endif
if gnCtov=3
   if !netUse('ctovk')
      nuse()
      retu
   endif
   if !netUse('cgrpk')
      nuse()
      retu
   endif
endif
 // netuse('tovpt')
DO WHILE ndr>0
   prNppr=0
   otvr=0
   clea
   ndr=0
   @ 5,5 SAY 'Номер документа : ' GET ndr PICT '999999' RANGE 0,999999
   READ
   if lastkey()=K_ESC
      exit
   endif
   IF ndr=0
      sele pr1
      rcpr1r=recn()
      do case
      case who=2
        rcpr1r=slcf('pr1',,,,,"e:nd h:'N док.' c:n(6) e:prz h:'П' c:n(1) e:dvp h:'Дата В' c:d(10) e:dpr h:'Дата П' c:d(10) e:sdv h:'Сумма' c:n(10,2) e:getfield('t1','pr1->kps','kln','nkl') h:'Поставщик' c:c(23) e:getfield('t1','pr1->kto','speng','fio') h:'Товаровед' c:c(15)",,,,,'prz=0')
      case who=3
        rcpr1r=slcf('pr1',,,,,"e:nd h:'N док.' c:n(6) e:prz h:'П' c:n(1) e:dvp h:'Дата В' c:d(10) e:dpr h:'Дата П' c:d(10) e:sdv h:'Сумма' c:n(10,2) e:getfield('t1','pr1->kps','kln','nkl') h:'Поставщик' c:c(23) e:getfield('t1','pr1->kto','speng','fio') h:'Товаровед' c:c(15)")
      endc
      sele pr1
      go rcpr1r
      ndr=nd
      mnr=mn
      otvr=otv
      if lastkey()=K_ESC .or. ndr=0
         exit
      endif
   ENDIF
   SELE pr1
   IF !netseek('t1','ndr')
      wmess('Документ отсутствует',1)
      LOOP
   ENDIF
   if gnEntrm=0.and.pr1->rmsk#0.or.gnEntrm=1.and.pr1->rmsk=0
      wmess('Чужой документ НИЗЗЯ!!!',3)
      ndr=0
      LOOP
   endif
   mnr=mn
   ndr=nd
   przr=prz
   amnpr=amnp
   amnr=amn
   otvr=otv
   sktpr=sktp
   if sks#0.or.sksp#0.and.entp=0.and.otvr=0
      wmess('Это приход - автомат',1)
      LOOP
   endif
   if entp#0.and.prz=0
      wmess('Удалите расход '+str(amnpr,6),3)
      LOOP
   endif
   nskltpr=getfield('t1','sktpr','cskl','nskl')
   nskltpr=alltrim(nskltpr)
   if otvr#0 //.and.przr=0
      if gnAdm=1.and.przr=1
      else
        if otvr#4
           wmess('Приходы(отчеты)/протоколы отв.хр. нельзя удалять ',2)
           loop
        endif
      endif
   endif
   CLEAR
   DVPR=DVP
   DDCR=DDC
   tdcr=tdc
   vor=vo
   pstr=pst
   nvor=getfield('t1','vor','vop','nvo')
   KPsR=KPs
   if vor=5
      nkpsr=getfield('t1','kpsr','bs','nbs')
   else
      nkpsr=getfield('t1','kpsr','kln','nkl')
   endif
   SKLR=SKL
   NNZR=NNZ
   DNZR=DNZ
   KOPR=KOP
   DprR=Dpr
   tprr=tpr
   KTOR=KTO
   fktor=getfield('t1','ktor','speng','fio')
   ktar=kta
   ktasr=ktas
   if ktasr=0
      ktasr=getfield('t1','ktar','s_tag','ktas')
   endif
   PRZR=PRZ
   SDVR=SDV
   sktr=skt
   mskltr=getfield('t1','sktr','cskl','mskl')
   skltr=sklt
   sksr=sks
   sklsr=skls
   amnr=amn
   kopr=kop
   qr=mod(kopr,100)
   vur=int(kopr/100)
   sele soper
   netseek('t1','gnD0k1,gnVu,vor,qr')
   nopr=nop
   autor=auto
   sele pr1
   entpr=entp
   skspr=sksp
   sklspr=sklsp
   amnpr=amnp
   entpr=entp
   rmskr=rmsk
   if autor#0
      if amnr#0
         sele cskl
         if netseek('t1','sktr')
            gcPath_tt=gcPath_d+alltrim(path)
         endif
      endif
   endif
   PRZAG1()
   UD=1
   N1=24
   STREL()
   @ 24,6 prom 'Документ  НЕ удалять'
   @ 24,col()+2 prom 'Документ удалить'
   menu to ud
   IF UD=2
      DDCR=DDC
      KPSR=KPS
      dprr=dpr
      Przr = prz
      if (przr = 1 .And. !(Who = 3.or.gnRup=1)) .Or. (przr = 0 .And. (Who = 1 .or. who=4))
         if gnRup=2.and.dprr=date()
              //Можно
         else
            d_udlll=savescreen(11,30,13,50)
            @ 11,30 say "┌──────────────────┐"
            @ 12,30 say "│Удаление запpещено│"
            @ 13,30 say "└──────────────────┘"
            inkey(4)
            restscreen(d_udlll,11,30,13,50)
            RETURN
         endif
      endif
      sele pr1
      mode=2
      if przr=1
         prprv(2)
         if autor#0.and.amnr#0.and.otvr=0
            pprh()
         endif
         if gnSkotv#0 //gnOtv=1
            paotv()
         endif
         prModr=1
      endif
      if przr=0
         pro(1)
      else
         pro(3)
      endif
      SELE pr2
      netseek('t1','mnr')
      DO WHILE mn=mnr
         mntov_r=0
         ktlr=ktl
         ktlpr=ktlp
         kfr=kf
         if przr=1
            SELE tov
            if netSEEK('t1','sklr,KTLr')
               mntov_r=mntov
               osvr=osv-kfr
               osfr=osf-kfr
               osfor=osfo-kfr
               if fieldpos('osfop')#0.and.kopr=188
                  osfopr=osfop+kfr
               else
                  osfopr=0
               endif
               osfmr=osfm-osv+kfr+osvr
               netrepl('osf,osv,osfm','osfr,osvr,osfmr')
               netrepl('osfo','osfor')
               if fieldpos('osfop')#0.and.kopr=188
                  netrepl('osfop','osfopr')
               endif
            endif
            if gnCtov=1.and.mntov_r#0
               SELE tovm
               if netSEEK('t1','sklr,mntov_r')
                  osvr=osv-kfr
                  osfr=osf-kfr
                  osfor=osfo-kfr
                  if fieldpos('osfop')#0.and.kopr=188
                     osfopr=osfop+kfr
                  else
                     osfopr=0
                  endif
                  osfmr=osfm-osv+kfr+osvr
                  netrepl('osf,osv,osfm','osfr,osvr,osfmr')
                  netrepl('osfo','osfor')
                  if fieldpos('osfop')#0.and.kopr=188
                     netrepl('osfop','osfopr')
                  endif
               endif
            endif
         else
            reclock()
            DELE
            netunlock()
            SELE tov
            if netSEEK('t1','sklr,KTLr')
               mntov_r=mntov
               netrepl('osfm','osfm-kfr')
               if fieldpos('osfop')#0.and.kopr=188
                  netrepl('osfop','osfop-kfr')
               endif
            endif
            if gnCtov=1.and.mntov_r#0
               SELE tovm
               if netSEEK('t1','sklr,mntov_r')
                  netrepl('osfm','osfm-kfr')
                  if fieldpos('osfop')#0.and.kopr=188
                     netrepl('osfop','osfop-kfr')
                  endif
                  prtrydel(ktlr,ktlpr)
               endif
            endif
            if gnCtov=2
               prtrydel(ktlr,ktlpr)
            endif
         endif
         sele pr2
         skip
      ENDDO

      K2=1
      SELE pr3
      netseek('t1','mnr')
      DO WHIL mn=mnr
         netdel()
         skip
      ENDD
      SELE pr1
      if przr=0
         netrepl('sdv,dtmod,tmmod','0,date(),time()')
         if otvr=4
            netdel()
         endif
         if entpr#0 // Внешний автомат
            sele setup
            locate for ent=entpr
            dir_er=alltrim(nent)+'\'
            path_er=gcPath_m+dir_er
            sele cskl
            locate for ent=entpr.and.sk=skspr
            pathr=path_er+gcDir_g+gcDir_d+alltrim(path)
            if netfile('tov',1)
               netuse('rs1','rs1p',,1)
               if netseek('t1','amnpr')
                  netrepl('entp,sktp,skltp,amnp','0,0,0,0')
               endif
               nuse('rs1p')
            endif
         endif
      else
         if otvr=3.or.otvr=4
            PrAOtv()
         endif
         sele pr1
         if otvr#3
            netrepl('prz,amn,dtmod,tmmod','0,0,date(),time()')
         else
            netrepl('prz,dtmod,tmmod','0,date(),time()')
         endif
         przr=0
      endif
   ENDIF

ENDDO
nuse()
set colo to g/n,n/g,,,
CLEAR
RETU

Function PRZAG1
sele pr1
NDR=ND
DVPR=DVP
DDCR=DDC
KPR=KPS
SKLR=SKL
NNZR=NNZ
DNZR=DNZ
KOPR=KOP
BSR=BS
RNR=RN
DOPR=DOP
SOPR=SOP
KTOR=KTO
DPRR=DPR
PRZR=PRZ
SDVR=SDV
SDFR=SDV
@ 3,0,4,48 BOX " "
@ 5,0 CLEAR
@ 3,10 SAY 'I. Заголовочная часть'
@ 4,10 SAY '====================='
@ 5,0 SAY ' 1. Номер документа     : '+STR(NDR,6,0)
@ 6,0 SAY ' 2. Дата выписки        : '+DTOC(DVPR)
@ 7,0 SAY ' 3. Дата документа      : '+DTOC(DDCR)
@ 8,0 SAY ' 4. Код поставщика      : '+STR(KPR,7,0)
@ 9,0 SAY ' 5. Код склада          : '+STR(SKLR,4,0)
@ 10,0 SAY ' 6. N договора          : '+NNZR
@ 11,0 SAY ' 7. Дата договора       : '+DTOC(DNZR)
@ 12,0 SAY ' 8. Код операции        : '+STR(KOPR,3,0)
@ 13,0 SAY ' 9. Балансовый счет     : '+STR(BSR,6,0)
@ 14,0 SAY '10. Рег. N плат. док.   : '+STR(RNR,6,0)
@ 15,0 SAY '11. Дата оплаты         : '+DTOC(DOPR)
@ 16,0 SAY '12. Сумма оплаты        : '+STR(SOPR,15,2)
@ 17,0 SAY '13. Код инженера        :'+STR(KTOR,3)
@ 18,0 SAY '14. Дата прихода        : '+DTOC(DPRR)
@ 19,0 SAY '15. Признак документа   : '+STR(PRZR,1,0)
if przr=0
   oclr=setcolor('w/b')
   saw='НЕ подтвержден !'
else
   oclr=setcolor('w/b')
   saw='Подтвержден !'
endi
*setcolor('n/w')
oclr=setcolor(oclr)
@ 17,50,19,67 box ''
@ 17,50,19,67 box frame
@ 18,51 say saw
*setcolor('w/b')
@ 20,0 SAY '16. Сумма по документу  : '+STR(SDVR,15,2)
VUR=INT(KOPR/100)

RETU
