#include "common.ch"
#include "inkey.ch"
  //Ž¡®à®â­ ï ¢¥¤®¬®áâì ¯® ¯à®¨§¢®¤áâ¢ã
  //”®à¬ â A4 ¨ª  á¦ âë©
  //h=62 w=140

set colo to g/n,n/g,,,
CLEAR

netuse('tcen')
*locate for tcen=gnTcen
coptr=gcCopt
*use
if !empty(gcCopt)
   coptr=alltrim(gcCopt)
else
   coptr='opt'
endif
netUse('tov')
set orde to tag t1
netuse('rs1')
netuse('rs2')
netuse('pr1')
netuse('pr2')
netuse('kln')
netuse('sgrp')

dtr1=bom(gdTd)
dtr2=date()
if gnMskl=0
  skl_r=gnSkl
else
  if gnSk=106 .or. gnSk=107
     skl_r=9998
     sklr=9998
  else
     skl_r=9998
  endif
endif
kg_r=999
ktl_r=9999999
store 1 to pir,psr
store '' to ng_r,nat_r,nskl_r
oclr=setcolor('gr+/b,n/w')
wobr=wopen(5,20,15,60)
wbox(1)

do while .t.
   @ 0,1 say '¥à¨®¤ c ' get dtr1
   @ 0,20 say ' ¯® ' get dtr2

   if gnMskl=0
      @ 1,1 say '‘ª« ¤ '+str(skl_r,7)+' '+gcNskl
   else
      if gnSk=106 .or. gnSk=107
          @ 1,1 say 'Š®¤ ª«¨¥­â  ' get sklr pict '9999999' valid skltar()
          @ 2,1 say '9999998 - ¯® ¢á¥¬'
      else
          @ 1,1 say '®¤®âç¥â­¨ª' get skl_r pict '9999999' valid skl()
          @ 2,1 say '9998 - ¯® ¢á¥¬'
      endif
   endif

   @ 3,1 say 'ƒàã¯¯ ' get kg_r pict '999' valid kg()
   @ 4,1 say '999 - ¯® ¢á¥¬'
   read
   if gnSk=106 .or. gnSk=107
      skl_r=sklr
   endif
   if lastkey()=K_ESC
      exit
   endif

   if kg_r#999
      @ 5,1 say '’®¢ à' get ktl_r pict '9999999' valid ktl()
      @ 6,1 say '9999999 - ¯® ¢á¥¬'
   else
      ktl_r=9999999
   endif
   read
   if lastkey()=K_ESC
      exit
   endif

   @ 7,1 prom '®«­®áâìî'
   @ 7,col()+1 prom 'ˆâ®£¨'
   menu to pir
   if lastkey()=K_ESC
      exit
   endif

   @ 8,1 prom '¥ç âì'
   @ 8,col()+1 prom 'ªà ­'
   if gnSpech=1 .or. gnAdm=1
      @ 8,col()+1 prom '‘¥â. ¯¥ç âì'
   endif
   menu to psr
   if lastkey()=K_ESC
      exit
   endif

   if psr#0
      wselect(0)
  //     save scre to scmess
  //     mess('†¤¨â¥,¨¤¥â ¯®¤£®â®¢ª ...')
      if select('obor')#0
         sele obor
         use
         erase obor.dbf
         erase oborp.cdx
         erase oborr.cdx
      endif
      if file('obor.dbf')
         erase obor.dbf
         erase oborp.cdx
         erase oborr.cdx
      endif

      crtt('obor',"f:skl c:n(7) f:ktl c:n(7) f:nd c:n(6) f:mn c:n(6) f:dpr c:d(8) f:kf c:n(10,3) f:sf c:n(10,2) f:ttn c:n(6) f:dot c:d(8) f:kvp c:n(10,3) f:svp c:n(10,2) f:ss c:n(10,2) f:opt c:n(10,3)")
      sele 0
      use obor excl
      inde on str(skl,7)+str(ktl,7)+str(nd,6)+str(ttn,6) to oborp
      inde on str(skl,7)+str(ktl,7)+str(ttn,6)+str(nd,6) to oborr
      set inde to oborp,oborr
      set orde to 1
  //     rest scre from scmess
      wselect(wobr)
      obrpr()
   endif
enddo

wclose(wobr)
setcolor(oclr)
if select('obor')#0
   sele obor
   use
   erase obor.dbf
   erase oborp.cdx
   erase oborr.cdx
endif
nuse()

**************************************************************************
static function skl()
**************************************************************************
if skl_r#9998
   sele kln
   if !netseek('t1','skl_r')
      go top
   endif
   wselect(0)
   skl_r=slcf('kln',,,,,"e:kkl h:'Š®¤' c:n(4) e:nkl h:'®¤®âç¥â­¨ª' c:c(20)",'kkl',,,'kkl>8000','kkl<10000')
   sele tov
   if !netseek('t2','skl_r')
      save scre to scmess
      mess('¥â â ª®£® áª« ¤ ',1)
      rest scre from scmess
   endif
   wselect(wobr)
   nskl_r=getfield('t1','skl_r','kln','nkl')
   @ 1,18 say nskl_r
else
   nskl_r='¯® ¢á¥¬'
endif
retu .t.
**************************************************************************
static function kg()
**************************************************************************
if kg_r#999
   sele sgrp
   if !netseek('t1','kg_r')
      go top
   endif
   wselect(0)
   kg_r=slcf('sgrp',,,,,"e:kgr h:'Š®¤' c:n(3) e:ngr h:' ¨¬¥­®¢ ­¨¥' c:c(20)",'kgr')
   sele tov
   if !netseek('t1','skl_r,kg_r*10000',,'3')
      save scre to scmess
      mess('¥â â ª®© £àã¯¯ë',1)
      rest scre from scmess
   endif
   wselect(wobr)
   ng_r=getfield('t1','kg_r','sgrp','ngr')
   @ 3,12 say ng_r
endif
retu .t.
**************************************************************************
static function ktl()
**************************************************************************
if ktl_r#9999999
   sele tov
   wselect(0)
   if !netseek('t1','skl_r,ktl_r')
      netseek('t1','skl_r,kg_r*10000',,'3')
      ktl_r=slcf('tov',,,,,"e:ktl h:'Š®¤' c:n(7) e:nat h:' ¨¬¥­®¢ ­¨¥' c:c(50)",'ktl',,,'skl=skl_r.and.vu=gnVu.and.int(ktl/10000)=kg_r')
   endif
   wselect(wobr)
   nat_r=getfield('t1','skl_r,ktl_r','tov','nat')
endif
retu .t.
**************************************************************************
proc obrpr
**************************************************************************
set prin to
if psr#3
   if gnOut=1
      set prin to lpt1
   else
      set prin to txt.txt
   endif
else
   set print to lpt2
endif
set prin on
set cons off
if psr=3
  //  ?chr(27)+'E'+chr(27)+'&l1h26a0O'+chr(27)+chr(27)+'(3R'+chr(27)+'(s0p18.00h0s1b4102T'+chr(27)  // Š­¨¦­ ï €4
   ??chr(27)+'E'+chr(27)+'&l1h26a0O'+chr(27)+chr(27)+'(3R'+chr(27)+'(s0p18.00h0s0b4099T'+chr(27)  // Š­¨¦­ ï €4
else
   if empty(gcPrn)
      ??chr(27)+chr(80)+chr(15)
   else
      ??chr(27)+'E'+chr(27)+'&l1h26a0O'+chr(27)+chr(27)+'(3R'+chr(27)+'(s0p18.00h0s0b4099T'+chr(27)  // Š­¨¦­ ï €4
   endif
endif
set devi to print
lstr=1
obrwr=1

if gnOut=2.and.psr#3
   set devi to scre
   wselect(0)
   save scre to scmess
   mess('†¤¨â¥,¨¤¥â ¯¥ç âì...')
endif

obrshpr()

onesklpr()

eject
if gnOut=2.and.psr#3
   rest scre from scmess
   wselect(wobr)
endif
set cons on
set prin off
set prin to
set devi to screen

if psr=2
   wselect(0)
   edfile('txt.txt')
   wselect(wobr)
endif
retu
****************************************************************************
proc onesklpr()
  ****************************************************************************
  sele tov
  set orde to tag t1
  go top
  if gnMskl=0.or.gnMskl=1.and.skl_r#9998
     do case
        case ktl_r#9999999
             netseek('t1','skl_r,ktl_r')
             wlr='skl=skl_r.and.ktl=ktl_r'
        case kg_r#999
             netseek('t1','skl_r,kg_r*10000',,'3')
  //           netseek('t2',str(skl_r,7)+str(gnVu,1)+iif(kg_r#0,str(kg_r,3),space(3)),,1)
             wlr='skl=skl_r.and.int(ktl/10000)=kg_r'
        othe
             if gnMskl=0
                go top
                wlr='!eof()'
             else
                netseek('t1','skl_r')
                wlr='skl=skl_r'
             endif
     endc
  else
     go top
     wlr='!eof()'
  endif

  store 0 to prsklr,prkgr,prktlr       // à¨§­ ª¨ £àã¯¯¨à®¢ª¨
  store 0 to sosntr,sprtr,srstr,sosftr,ssstr // ‚á¥£® â®¢ à
  store 0 to sosngr,sprgr,srsgr,sosfgr,sssgr // ‚á¥£® £àã¯¯ 
  store 0 to sosnsr,sprsr,srssr,sosfsr,ssssr // ‚á¥£® áª« ¤
  store 0 to sosnir,sprir,srsir,sosfir,sssir // ˆâ®£®
  store 0 to osnr,osfr,kfr,sfr,kvpr,svpr,ssr,optr,opt_r
  if gnMskl#0
     skl_rr=9997
  else
     skl_rr=gnSkl
  endif
  kg_rr=998
  ktl_rr=9999998
  //tttt=seconds()
  sele tov
  skp_r=0
  do while &wlr
     sklr=skl
     ktlr=ktl
     kgr=int(ktlr/10000)
     if skp_r=0
        opt_r=optr
     endif
     optr=&coptr
     if !(month(dpo)=month(gdTd).and.year(dpo)=year(gdTd).or.(osn+osv+osf)#0;
       .or.month(dpp)=month(gdTd).and.year(dpp)=year(gdTd))
        sele obor
        if !netseek('t1','sklr,ktlr')
           sele tov
           skip
           skp_r=1
           loop
        endif
     endif
     if ktl_rr#ktlr.or.skl_rr#sklr
        if prktlr=1  // ‡ ªàëâì ¯à¥¤ë¤ãé¨© â®¢ à
           t_end()
           prktlr=0
        endif
        ktl_rr=ktlr
     endif
     if kg_rr#kgr.or.skl_rr#sklr
        if prkgr=1 //  ‡ ªàëâì ¯à¥¤ë¤ãéãî £àã¯¯ã
           g_end()
           prkgr=0
        endif
        kg_rr=kgr
     endif
     if gnMskl#0
        if skl_rr#sklr   // ‘¬¥­  ¬ã«ìâ¨áª« ¤ 
           if prsklr=1 // ‡ ªàëâì ¯à¥¤ë¤ãé¨© ¬ã«ìâ¨áª« ¤
              s_end()
              prsklr=0
           endif
           skl_rr=sklr
        endif
     endif
     if gnMskl#0
        if prsklr=0 // Žâªàëâì ­®¢ë© ¬ã«ìâ¨áª« ¤
           if gnOut=2.and.psr#3
             @ 24,1 say str(sklr,7)+' '+getfield('t1','sklr','kln','nkl') color 'g/n'
           endif
           ?space(20)+str(sklr,7)+' '+getfield('t1','sklr','kln','nkl')
           obrlepr()
           prsklr=1
        endif
     endif
     if prkgr=0 // Žâªàëâì ­®¢ãî £àã¯¯ã
        kg_rrr=kgr
        if gnOut=2.and.psr#3
     @ 24,40 say str(kgr,4)+' '+getfield('t1','kg_rrr','sgrp','ngr') color 'g/n'
        endif
        if gnMskl=0
           ?str(kgr,4)+' '+getfield('t1','kg_rrr','sgrp','ngr')
           obrlepr()
        endif
        prkgr=1
     endif
     sele tov
     if prktlr=0  // Žâªàëâì ­®¢ë© â®¢ à
        if pir=1
           ?str(ktlr,7)+' '+nat
           obrlepr()
        endif
        prktlr=1
     endif
     optr=&coptr
     osnr=osn
    //  osndr=ROUND(osnr*optr,2)
     kfr=0
     kvpr=0
     sfr=0
     svpr=0
     ssr=0
     prrspr()
     osndr=ROUND(osnr*optr,2)

     sosntr=osndr
     sosngr=sosngr+osndr
     sosnsr=sosnsr+osndr
     sosnir=sosnir+osndr

     ssstr=ssr
     sssgr=sssgr+ssr
     ssssr=ssssr+ssr
     sssir=sssir+ssr

     osfr=osnr+kfr-kvpr
     osfdr=osndr+sfr-svpr

     sosftr=sosntr+sprtr-srstr
     sosfgr=sosngr+sprgr-srsgr
     sosfsr=sosnsr+sprsr-srssr
     sosfir=sosnir+sprir-srsir

    //  sosftr=osfdr
    //  sosfgr=sosfgr+osfdr
    //  sosfsr=sosfsr+osfdr
    //  sosfir=sosfir+osfdr

     skp_r=0

     sele tov
     skip
  endd
  t_end()
  g_end()
  if gnMskl#0
     s_end()
  endif
  i_end()
  ///tttt=str(seconds()-tttt,10,2)
  // mess(tttt,1)
  retu

*****************************************************************************
proc obrlepr()
  *****************************************************************************
  obrwr++
  if obrwr>63
     obrwr=1
     lstr++
     eject
     if gnOut=1.and.psr#3
        set devi to scre
        wselect(0)
        save scre to scmess
        mess('‚áâ ¢ìâ¥ «¨áâ ¨ ­ ¦¬¨â¥ ¯à®¡¥«',1)
        rest scre from scmess
        wselect(wobr)
     endif
     obrshpr()
  endif
  retu
*****************************************************************************
proc obrshpr()
  *****************************************************************************
  if gnMskl=0
     ?'Ž¡®à®â­ ï ¢¥¤®¬®áâì '+alltrim(gcNskl)+' c '+dtoc(dtr1)+' ¯® '+dtoc(dtr2)+' '+iif(pir=1,'','(¨â®£¨)')
     obrlepr()
  else
     if skl_r=9998
     ?'Ž¡®à®â­ ï ¢¥¤®¬®áâì '+alltrim(gcNskl)+' c '+dtoc(dtr1)+' ¯® '+dtoc(dtr2)+' '+iif(pir=1,'','(¨â®£¨)')
        obrlepr()
     else
        ?'Ž¡®à®â­ ï ¢¥¤®¬®áâì '+alltrim(nskl_r)+' c '+dtoc(dtr1)+' ¯® '+dtoc(dtr2)+' '+iif(pir=1,'','(¨â®£¨)')
        obrlepr()
     endif
  endif
  if kg_r#999
     ?'ƒàã¯¯  '+str(kg_r,3)+' '+ng_r
     obrlepr()
  endif
  if ktl_r#9999999
     ?'’®¢ à '+str(ktl_r,7)+' '+nat_r
     obrlepr()
  endif
  ?space(112)+'‹¨áâ '+str(lstr,2)
  obrlepr()
  ?'ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
  obrlepr()
  ?'³          ³    ­ ç «® ¬¥áïæ    ³              à¨å®¤                 ³               áå®¤                 ³       Žáâ âª¨       ³'
  obrlepr()
  ?'³  –¥­     ÃÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´'
  obrlepr()
  ?'³          ³Š®«¨ç¥áâ¢®³  ‘ã¬¬    ³N ¤®ª.³  „ â   ³Š®«¨ç¥áâ¢®³  ‘ã¬¬    ³N ¤®ª.³  „ â   ³Š®«¨ç¥áâ¢®³  ‘ã¬¬    ³Š®«¨ç¥áâ¢®³  ‘ã¬¬    ³'
  obrlepr()
  ?'ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄ´'
  obrlepr()
  retu
************************************************************************
stat func s_end()
************************************************************************
?'‚á¥£® ¯® áª« ¤ã :'
obrlepr()
?' '+space(10)+' '+space(10)+' '+iif(sosnsr#0,str(sosnsr,10,2),space(10))+' '+space(6)+' '+space(8)+' '+space(10)+' '+iif(sprsr#0,str(sprsr,10,2),space(10))+' '+space(6)+' '+space(8)+' '+space(10)+' '+iif(srssr#0,str(srssr,10,2),space(10))+' '+space(10)+' '+iif(sosfsr+ssssr#0,str(sosfsr+ssssr,10,2),space(10))
obrlepr()
if ssssr#0
   ?' '+space(10)+' '+space(10)+' '+space(10)+' '+space(6)+' '+space(8)+' '+space(10)+' '+space(10)+' '+space(6)+' '+space(8)+' '+'‘®¡. áà-¢ '+' '+str(ssssr,10,2)+' '+space(10)+' '+space(10)
   obrlepr()
endif
store 0 to sosnsr,sprsr,srssr,sosfsr,ssssr // ‚á¥£® áª« ¤
retu
************************************************************************
stat func g_end()
************************************************************************
if gnMskl=0
   ?'‚á¥£® ¯® £àã¯¯¥ :'
   obrlepr()
   ?' '+space(10)+' '+space(10)+' '+iif(sosngr#0,str(sosngr,10,2),space(10))+' '+space(6)+' '+space(8)+' '+space(10)+' '+iif(sprgr#0,str(sprgr,10,2),space(10))+' '+space(6)+' '+space(8)+' '+space(10)+' '+iif(srsgr#0,str(srsgr,10,2),space(10))+' '+space(10)+' '+iif(sosfgr+sssgr#0,str(sosfgr+sssgr,10,2),space(10))
   obrlepr()
   if sssgr#0
      ?' '+space(10)+' '+space(10)+' '+space(10)+' '+space(6)+' '+space(8)+' '+space(10)+' '+space(10)+' '+space(6)+' '+space(8)+' '+'‘®¡. áà-¢ '+' '+str(sssgr,10,2)+' '+space(10)+' '+space(10)
      obrlepr()
   endif
endif
store 0 to sosngr,sprgr,srsgr,sosfgr,sssgr // ‚á¥£® £àã¯¯ 
retu
************************************************************************
stat func t_end()
************************************************************************
if pir=1
   ?'‚á¥£® ¯® â®¢ àã :'
   obrlepr()
   ?' '+str(opt_r,10,3)+' '+iif(osnr#0,str(osnr,10,3),space(10))+' '+iif(sosntr#0,str(sosntr,10,2),space(10))+' '+space(6)+' '+space(8)+' '+iif(kfr#0,str(kfr,10,3),space(10))+' '+iif(sprtr#0,str(sprtr,10,2),space(10))+' '+space(6)+' '+space(8)+' '+iif(kvpr#0,str(kvpr,10,3),space(10))+' '+iif(srstr#0,str(srstr,10,2),space(10))+' '+iif(osfr#0,str(osfr,10,3),space(10))+' '+iif(sosftr+ssstr#0,str(sosftr+ssstr,10,2),space(10))
   obrlepr()
   if ssstr#0
      ?' '+space(10)+' '+space(10)+' '+space(10)+' '+space(6)+' '+space(8)+' '+space(10)+' '+space(10)+' '+space(6)+' '+space(8)+' '+'‘®¡. áà-¢ '+' '+str(ssstr,10,2)+' '+space(10)+' '+space(10)
      obrlepr()
   endif
endif
store 0 to sosntr,sprtr,srstr,sosftr,ssstr // ‚á¥£® â®¢ à
retu

************************************************************************
stat func i_end()
  ************************************************************************
  ?'ˆâ®£® :'
  obrlepr()
  ?' '+space(10)+' '+space(10)+' '+iif(sosnir#0,str(sosnir,10,2),space(10))+' '+space(6)+' '+space(8)+' '+space(10)+' '+iif(sprir#0,str(sprir,10,2),space(10))+' '+space(6)+' '+space(8)+' '+space(10)+' '+iif(srsir-sssir#0,str(srsir-sssir,10,2),space(10))+' '+space(10)+' '+iif(sosfir+sssir#0,str(sosfir+sssir,10,2),space(10))
  obrlepr()
  if sssir#0
     ?' '+space(10)+' '+space(10)+' '+space(10)+' '+space(6)+' '+space(8)+' '+space(10)+' '+space(10)+' '+space(6)+' '+space(8)+' '+'‘®¡. áà-¢ '+' '+str(sssir,10,2)+' '+space(10)+' '+space(10)
     obrlepr()
  endif
  store 0 to sosnir,sprir,srsir,sosfir,sssir // ˆâ®£®
  retu
************************************************************************
proc prrspr()
************************************************************************
osn=osnr
sele pr2
set orde to tag t2
if netseek('t2','ktlr')
   do while ktl=ktlr
      mnr=mn
      kfr=kf
      if empty(gcCopt)
         sfr=sf
      else
         sfr=sr
      endif
      sele pr1
      set orde to tag t2
      if netseek('t2','mnr')
         if skl#sklr
            sele pr2
            skip
            loop
         endif
         ndr=nd
         if prz=1
            dprr=dpr
            if dpr>=bom(dtr1).and.dpr<=dtr1
               osnr=osnr+kfr
            endif
            if dpr>dtr1 .and. dpr<dtr2
               sele obor
               set orde to 1
               if !netseek('t1','sklr,ktlr,0')
                  netadd()
                  repl skl with sklr,ktl with ktlr,nd with ndr,mn with mnr,dpr with dprr,kf with kfr,sf with sfr
               else
                  repl nd with ndr,mn with mnr,dpr with dprr,kf with kfr,sf with sfr
               endif
            endif
         endif
      endif
      sele pr2
      skip
   enddo
endif
sele rs2
set orde to tag t2
if netseek('t2','ktlr')
   do while ktl=ktlr
      ttnr=ttn
      kvpr=kvp
      svpr=svp
      srr=ROUND(optr*kvp,2) //sr
      ssr=svpr-srr
      sele rs1
      set orde to tag t1
      if netseek('t1','ttnr')
         if skl#sklr
            sele rs2
            skip
            loop
         endif
         if prz=1
            dotr=dot
            if dotr>=bom(dtr1).and.dotr<=dtr1
               osnr=osnr-kvpr
            endif
            if dotr>dtr1 .and.dotr<dtr2
               sele obor
               ordsetfocus("t2") //               set orde to 2
               if !netseek('t2','sklr,ktlr,0')
                  netadd()
                  repl skl with sklr,ktl with ktlr,ttn with ttnr,dot with dotr,kvp with kvpr,svp with svpr,ss with ssr
               else
                  repl ttn with ttnr,dot with dotr,kvp with kvpr,svp with svpr,ss with ssr
               endif
            endif
         endif
      endif
      sele rs2
      skip
   enddo
endif
store 0 to kfr,sfr,kvpr,svpr,ssr
sele obor
set orde to 1
if netseek('t1','sklr,ktlr')
   do while skl=sklr.and.ktl=ktlr
      if pir=1
         ?' '+space(10)+' '+space(10)+' '+space(10)+' '+iif(nd#0,str(nd,6),space(6))+' '+iif(!empty(dpr),dtoc(dpr),space(8))+' '+iif(kf#0,str(kf,10,3),space(10))+' '+iif(sf#0,str(sf,10,2),space(10))+' '+iif(ttn#0,str(ttn,6),space(6))+' '+iif(!empty(dot),dtoc(dot),space(8))+' '+iif(kvp#0,str(kvp,10,3),space(10))+' '+iif(svp#0,str(svp,10,2),space(10))+' '+space(10)+' '+space(10)
         obrlepr()
      endif
      kfr=kfr+kf
      sfr=sfr+sf
      sprtr=sprtr+sf
      sprgr=sprgr+sf
      sprsr=sprsr+sf
      sprir=sprir+sf

      kvpr=kvpr+kvp
      svpr=svpr+svp
      ssr=ssr+ss
      srstr=srstr+svp
      srsgr=srsgr+svp
      srssr=srssr+svp
      srsir=srsir+svp
      skip
   endd
endif
sele obor
zap
retu

