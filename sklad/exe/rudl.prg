#include "common.ch"
#include "inkey.ch"
****************************************************************************
** RUDL удалить расход                                                     *
****************************************************************************
if !prdp()
   retu
endif
set colo to g/n,n/g,,,
CLEAR
store 0 to VUR,N2,NDR,KPLR,VOR,N1,ttnr,prunnr,prNppr,prdecr
tarar=1
DDCR=CTOD(' ')
N2=PROW()+3
store 1 to K1,UD,DOK
OST1 = 0.000
OST2 = 0.000
*******************************
@ 1,49,4,79 BOX FRAME
@ 2,50 SAY 'Удаление расходного документа'
@ 3,60 SAY DTOC(DATE())
*** Откpытие баз данных ***********************************************
@ 15,1 clear to 19,40
Pathr=gcPath_t
skr=gnSk
rmskr=gnRmsk
*******************************
if !netUse('rs1')
   nuse()
   retu
endif
*******************************
if !netUse('rs2')
   nuse()
   retu
endif
*******************************
if !netUse('rs3')
   nuse()
   retu
endif
*******************************
if !netUse('tov')
   nuse()
   retu
endif
if gnCtov=1
   if !netUse('ctov')
      nuse()
      retu
   endif
   if !netUse('tovm')
      nuse()
      retu
   endif
endif
*******************************
if !netUse('soper')
   nuse()
   retu
endif
*******************************
if !netUse('s_tag')
   nuse()
   retu
endif
if !netUse('stagm')
   nuse()
   retu
endif
if !netUse('kgp')
   nuse()
   retu
endif
if !netUse('kpl')
   nuse()
   retu
endif
if !netUse('tmesto')
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
*******************************
*#ifdef __CLIP__
*   if !(netUse('dokk').AND.netuse('aninf').AND.netuse('aninfl').AND.netuse('DokA'))
*      nuse()
*      retu
*   endif
*#else
   if !netUse('dokk')
      nuse()
      retu
   endif
*#endif
*******************************
if !netUse('bs')
   nuse()
   retu
endif
*******************************
if !netUse('dkkln')
   nuse()
   retu
endif
if !netUse('dknap')
   nuse()
   retu
endif
if !netUse('dokko')
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
if !netUse('moddoc')
   nuse()
   retu
endif
if !netUse('mdall')
   nuse()
   retu
endif
*******************************
if !netuse('nds')
   nuse()
   retu
endif
if !netuse('nnds')
   nuse()
   retu
endif
if !netuse('cntm')
   nuse()
   retu
endif
*******************************
if !netuse('kln')
   nuse()
   retu
endif
if !netuse('speng')
   nuse()
   retu
endif
if !netuse('vo')
   nuse()
   retu
endif
if !netuse('rso1')
   nuse()
   retu
endif
if !netuse('rso2')
   nuse()
   retu
endif
if !netuse('cskl')
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
*netuse('tovpt')
ttnr=1
DO WHILE ttnr#0
   prNppr=0
   ttnr=0
   @ 5,0 clea
   @ 5,5 SAY 'Номер документа : ' GET ttnr PICT '999999' RANGE 0,999999
   READ

   IF lastkey()=K_ESC
      exit
   ENDIF
   if ttnr=0
      do case
         case who=3
              skpr=nil
         case who=2
              skpr='prz=0'
         case who=1
              skpr='prz=1'
         other
              skpr='.t.'
      endc
      ttnr=slcf('rs1',,,,,"e:ttn h:'ТТН' c:n(6) e:prz h:'П' c:n(1) e:sdv h:'Сумма' c:n(10,2) e:dvp h:'Дата В' c:d(10) e:dot h:'Дата О' c:d(10) e:getfield('t1','rs1->kpl','kln','nkl') h:'Клиент' c:c(20) e:getfield('t1','rs1->kto','speng','fio') h:'Товаровед' c:c(17)",'ttn',,,,skpr)
      if lastkey()=K_ESC .or. ttnr=0
         loop
      endif
   endif
   SELE rs1
   IF !netseek('t1','ttnr',,,1)
      N1=23
      @ 23,0 CLEAR
      STREL()
      @ 23,6 SAY 'Документ отсутствует'
      WAIT '      Для продолжения нажмите любую клавишу ...'
      @ 5,0 CLEAR
      exit
   ENDIF
   if gnEntrm=0.and.rs1->rmsk#0.or.gnEntrm=1.and.rs1->rmsk=0
      wmess('Чужой документ НИЗЗЯ!!!',3)
      ttnr=0
      LOOP
   endif
   if who=1.and.prz=0
      wmess('Документ не подтвержден.Низзя!!!',2)
      exit
   endif
   ddcr=ddc
   if ddcr=date().and.prz=0.and.gnCtov=1.and.gnAdm=0
      if gnRasc#2
         wmess('Документ этого дня.Низзя!!!',2)
         exit
      endif
   endif
   pr177r=pr177
   if fieldpos('mntov177')#0
      mntov177r=mntov177
      prc177r=prc177
   else
      mntov177r=0
      prc177r=0
   endif
   if fieldpos('pr169')#0
      pr169r=pr169
      mk169r=mk169
      ttn169r=ttn169
   else
      pr169r=0
      mk169r=0
      ttn169r=0
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
   if gnRasc#2
      if prz=0
         do case
            case who=0
                 exit
            case who=1.and.gnCtov#1
                 exit
            case who=1.and.gnCtov=1.and.gnRsp=0.and.gnRspb=0.and.gnRspnb=0.and.gnRsp=0
                 exit
         endc
      endif
   else
      if who=0
         exit
      endif
   endif
   sele rs1
   if prz=1.and.amnp#0.and.entp=0
      amnpr=amnp
      amnp_r=val(nnz)
      sktpr=sktp
      sele cskl
      netseek('t1','sktpr')
      pathr=gcPath_d+alltrim(path)
      nskltpr=alltrim(nskl)
      netuse('rs1','rs1t',,1)
      if netseek('t1','amnpr')
         wmess('Удалите расход '+str(amnpr,6)+' '+nskltpr,3)
         nuse('rs1t')
         loop
      else
         sele rs1
         netrepl('amnp,sktp,skltp','amnp_r,gnSk,gnSkl')
      endif
      nuse('rs1t')
   endif
   if prz=1.and.amnp#0.and.entp#0
      entpr=entp
      sele menent
      locate for ent=entpr
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
      sele rs1
      amnpr=amnp
      sktpr=sktp
      if fieldpos('prdec')#0
         prdecr=prdec
      else
         prdecr=0
      endif
      sele cskl
      pathr=pathecr
      netuse('cskl','ecskl',,1)
      netseek('t1','sktpr')
      pathr=pathepr+gcDir_g+gcDir_d+alltrim(path)
      nskltpr=alltrim(nskl)
      nuse('ecskl')
      netuse('pr1','pr1t',,1)
      if netseek('t1','amnpr')
         if prz=1
            wmess('Снимите подтв. с прихода '+str(amnpr,6)+' '+nskltpr,3)
            nuse('pr1t')
            loop
         endif
      endif
      nuse('pr1t')
   endif
   sele rs1
   if otv#0
      wmess('Служебный документ отв.хр.Не удаляется ',3)
      loop
   endif
   if prz=0
      sele rs2
      if netseek('t1','ttnr')
         prudlr=1
         do while ttn=ttnr
            if otv=0
               skip
               loop
            else
               prudlr=0
               exit
            endif
         enddo
         if prudlr=0
            wmess('Документ с отв.хр.Только коррекция ',3)
            loop
         endif
      endif
   endif
   sele rs1
   reclock() // блокировка удаляемого док-та
   *** Удаление документа **************************************************
   ttnr=TTN
   if prz=1
      if gnCtov=1
         if fieldpos('krspo')#0
            if (gnRspo=1.or.gnRspo=2).and.krspo=0
               netrepl('krspo','gnKto')
            endif
            if gnRspb=1.and.krspb=0
               netrepl('krspb','gnKto')
            endif
            if gnRspnb=1.and.krspnb=0
               netrepl('krspnb','gnKto')
            endif
            if gnRsps=1.and.krsps=0
               netrepl('krsps','gnKto')
            endif
            if gnRasc#2
               if gnRspo=1.or.gnRspb=1.or.gnRspnb=1.or.gnRsps=1
                  wmess('Снятие подтверждения разрешено',2)
                  if !(gnRsp=1.or.gnAdm=1)
                     loop
                  endif
               endif
               if !(gnRsp=1.or.gnAdm=1.or.gnRspo=2)
                  wmess('Нет прав',1)
                  loop
               else
                  if dot#date()
                     if krspo=0
                        @ 6,5 say 'Нет разрешения администрации'
                     else
                        @ 6,5 say 'Администрация  '+getfield('t1','rs1->krspo','speng','fio')
                     endif
                     if krspb=0
                        @ 7,5 say 'Нет разрешения бухгалтера'
                     else
                        @ 7,5 say 'Бухгалтер      '+getfield('t1','rs1->krspb','speng','fio')
                     endif
                     if krspnb=0
                        @ 8,5 say 'Нет разрешения налогового бухгалтера'
                     else
                        @ 8,5 say 'Налоговый бухг.'+getfield('t1','rs1->krspnb','speng','fio')
                     endif
                     if krsps=0
                        @ 9,5 say 'Нет разрешения склада'
                     else
                        @ 9,5 say 'Склад          '+getfield('t1','rs1->krsps','speng','fio')
                     endif
                     inkey(0)
                     if lastkey()=K_ESC
                        loop
                     endif
                  endif
                  if dot#date()
                     if gnRsp=1.and.(krspo=0.or.krspb=0.or.krspnb=0.or.krsps=0)
                        loop
                     endif
                  endif
               endif
               if gnRspo=2
                  aqstr=1
                  aqst:={"Нет","Да"}
                  aqstr:=alert("Снять подтверждение? ",aqst)
                  if lastkey()=K_ESC.or.aqstr=1
                     loop
                  endif
               endif
            endif
         endif
      endif
   endif
   DVPR=DVP
   DDCR=DDC
   tdcr=tdc
   pstr=pst
   kpsr=kps
   vor=vo
   nvor=getfield('t1','vor','vo','nvo')
   KPLR=KPL
   if vor=5
      nkplr=getfield('t1','kplr','bs','nbs')
   else
      nkplr=getfield('t1','kplr','kln','nkl')
   endif
   KGPR=KGP
   nkgpr=getfield('t1','kgpr','kln','nkl')
   SKLR=SKL
   NNZR=NNZ
   DNZR=DNZ
   KOPR=KOP
   SPDR=SPD
   DOTR=DOT
   dopr=dop
   totr=tot
   KTOR=KTO
   fktor=getfield('t1','ktor','speng','fio')
   ktar=kta
   ktasr=ktas
   if ktar#0.and.ktasr=0
      ktasr=getfield('t1','ktar','s_tag','ktas')
   endif
   PRZR=PRZ
   bprzr=bprz
   SDVR=SDV
   VSVR=VSV
   pprr=ppr
   sktr=skt
   mskltr=getfield('t1','sktr','cskl','mskl')
   skltr=sklt
   sksr=sks
   sklsr=skls
   ztr = KON
   amnr=amn
   entpr=entp
   sktpr=sktp
   skltpr=skltp
   skspr=sksp
   sklspr=sklsp
   amnpr=amnp
*   otvr=otv
   kopr=kop
   qr=mod(kopr,100)
   vur=int(kopr/100)
   if kplr=20034
      tarar=0
   else
      tarar=1
   endif
*   netuse('tara')
*   if netseek('t1','kplr')
*      tarar=1
*   endif
*   nuse('tara')
   sele soper
   netseek('t1','gnD0k1,gnVu,vor,qr')
   ndsr=nds
   nopr=nop
   autor=auto
   koppr=kopp
   sele cskl
   if netseek('t1','sktr')
      gcPath_tt=gcPath_d+alltrim(path)
   endif
*   use
   if przr=0.and.!empty(dotr)
      if gnAdm=1.or.gnCtov=3 //.or.gnRsp=1
         apcenr=2
         apcenr=alert('Документ отгружен! Продолжить удаление?',{'ДА','НЕТ'})
         if apcenr=2.or.lastkey()=K_ESC
            return
         endif
      else
         wmess('Документ отгружен!',2)
         retu
      endif
   endif
   DO WHILE .T.
      @ 5,0 CLEAR
      RZAG()
      UD=1
      N1=24
      STREL()
      @ 24,6 prom 'Документ  НЕ удалять'
      @ 24,col()+2 prom 'Документ удалить'
      menu to ud
      IF UD = 2
         if gnRasc#2
            If Przr = 0 .And. (Who = 1 .or. Who=4)
               d_udlll=savescreen(11,30,13,50)
               @ 11,30 say "┌──────────────────┐"
               @ 12,30 say "│Удаление запpещено│"
               @ 13,30 say "└──────────────────┘"
               inkey(4)
               restscreen(d_udlll,11,30,13,50)
               nuse()
               RETURN
            EndIf
            If Przr = 1
               if gnCtov#1.and.who#3.or.gnCtov=1.and.(who#3.and.gnRsp=0.and.gnRspo#2)
                  d_udlll=savescreen(11,30,13,50)
                  @ 11,30 say "┌──────────────────┐"
                  @ 12,30 say "│Удаление запpещено│"
                  @ 13,30 say "└──────────────────┘"
                  inkey(4)
                  restscreen(d_udlll,11,30,13,50)
                  nuse()
                  RETURN
               endif
            endif
            sele rs1
            if gnRasc#2
               rsprv(2,0)
               rsprv(1,1)
            endif
            mode=2
            if gnSkotv#0 // gnOtv=1
               * Коррекция прихода-автомата в складе cskl.skotv
               pacotv()
            endif
            IF autor#0
               if autor#4
                  if amnr#0
                     RPRH()
                  endif
               else
*                  if amnpr#0
*                     RPRHP()
*                  endif
               endif
            endif
         EndIf
         if przr=0
            if gnRasc#2
               rsprv(2,1)
            endif
            IF !empty(rs1->dvttn)
               rs1->(netrepl('dvttn,tvttn,ktovttn',"ctod(''),time(),gnKto",1))
               prModr=1
            ENDIF
            if empty(dotr)
               rso(1)
            else
               rso(2)
            endif
         else
            rso(3)
         endif
         prpcoder=0
         if przr=0
         endif
      *** Удаление в trsho15 и tprds01 **********************************
         SELE RS2
         netseek('t1','ttnr')
         DO WHILE ttn=ttnr
            mntov_r=0
            rcrs2_r=recn()
            if deleted()
               skip
               loop
            endif
            ktlr=ktl
            ktlpr=ktlp
            kvpr=kvp
            ktlmr=ktlm
            kltmpr=ktlmp
            mntovr=mntov
            SELE tov
            netSEEK('t1','sklr,ktlr')
            mntov_r=mntov
            IF PRZr=1
               osfr=osf+kvpr
               netrepl('osf','osfr')
               if !(vor=9.or.vor=2.or.vor=6.and.(kopr=101.or.kopr=181.or.kopr=198))
                  if fieldpos('osfo')#0
                     netrepl('osfo','osfo+kvpr')
                  endif
               endif
               if gnCtov=1.and.mntov_r#0
                  sele tovm
                  if netseek('t1','sklr,mntov_r')
                     osfr=osf+kvpr
                     netrepl('osf','osfr')
                  endif
                  if !(vor=9.or.vor=2.or.vor=6.and.(kopr=101.or.kopr=181.or.kopr=198))
                     if fieldpos('osfo')#0
                        netrepl('osfo','osfo+kvpr')
                     endif
                  endif
               endif
            ELSE
               osvr=osv+kvpr
               osfmr=osfm+kvpr
               netrepl('osv,osfm','osvr,osfmr')
               if fieldpos('osfo')#0
                  if !empty(dopr)
                     netrepl('osfo','osfo+kvpr')
                  endif
               endif
               if gnCtov=1.and.mntov_r#0
                  sele tovm
                  if netseek('t1','sklr,mntov_r')
                     osvr=osv+kvpr
                     osfmr=osfm+kvpr
                     netrepl('osv,osfm','osvr,osfmr')
                     if fieldpos('osfo')#0
                        if !empty(dopr)
                           netrepl('osfo','osfo+kvpr')
                        endif
                     endif
                  endif
               endif
            ENDI
            SELE rs2
            if przr=1
               if !(vor=9.or.vor=2.or.vor=6.and.(kopr=101.or.kopr=181.or.kopr=198))
                  if fieldpos('prosfo')#0
                     netrepl('prosfo','0')
                  endif
               endif
            endif
            ktlmr=ktlm
            ktlmpr=ktlmp
            if przr=0
               netdel()
               if netseek('t1','ttnr')
                  do while ttn=ttnr
                     if ktlp=ktlr
                        netdel()
                     endif
                     skip
                  endd
               endif
            else
               netrepl('kf,sf','0,0')
            endif
            //netuse('pr2')
            //prtrydel(ktlr,ktlpr)
            //nuse('pr2')
            sele rs2
            go rcrs2_r
            skip
         ENDDO
         *** Удаление в trsho16 ****************************************
         if przr=0
            if prpcoder=0
               SELE rs3
               netseek('t1','ttnr')
               do while ttn=ttnr
                  netdel()
                  skip
               enddo
               @ 3,0,4,45 BOX " "
               @ 5,0 CLEAR
               *** Удаление в trsho14 *******************************************
               SELE rs1
               netrepl('sdv,dtmod,tmmod','0,date(),time()')
            else
               sele rs1
               netrepl('sktp,skltp,amnp','0,0,0',1)
               wmess('Расход перекодирован',1)
            endif
         else
            sele rs1
            netrepl('prz,bprz,amn,dtmod,tmmod','0,0,0,date(),time()',1)
            if fieldpos('rspo')#0
               if gnRsp=1
                  netrepl('krsp','gnKto',1)
               else
                  netrepl('krsp','9999',1)
               endif
            endif
            if !(vor=9.or.vor=2.or.vor=6.and.(kopr=101.or.kopr=181.or.kopr=198))
               edater=ctod('')
               netrepl('dop','edater',1)
            endif
         endif
         prModr=1
         sele nds
         set orde to tag t3
         if netseek('t3','gnSk,ttnr')
            nalnnr=0
            do while sk=gnSk.and.ttn=ttnr
               if month(dnn)#month(gdTd).and.year(dnn)#year(gdTd)
                  skip
                  loop
               else
                  nalnnr=1
                  exit
               endif
               skip
            enddo
            if nalnnr=1
               aprn={'НЕТ ',' ДА'}
               prunnr=alert('Удалить налоговые накладные ?',aprn)
            endif
         endif
         if prunnr=2
            sele nds
            set orde to tag t3
            if netseek('t3','gnSk,ttnr')
               do while sk=gnSk.and.ttn=ttnr
                  if month(dnn)#month(gdTd).and.year(dnn)#year(gdTd)
                     skip
                     loop
                  else
                     netdel()
                  endif
                  skip
               enddo
            endif
         endif
         if prModr=1
            sele rs1
            netrepl('dtmod,tmmod','date(),time()',1)
         endif
      ENDIF
      exit
   ENDDO
ENDDO
nuse()
CLEAR
RETU
