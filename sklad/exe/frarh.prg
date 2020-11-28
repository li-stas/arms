#include "common.ch"
#include "inkey.ch"
* Восстановление информации из архива
clea
set prin to frarh.txt
set prin on
clttncr=setcolor('gr+/b,n/bg')
wttncr=wopen(10,20,13,60)
patharhr=gcPath_ew+'arch\'
wbox(1)
@ 0,1 say 'Путь' get patharhr
read
wclose(wttncr)
setcolor(clttncr)
if lastkey()=K_ESC.or.empty(patharhr)
   retu
endif
netuse('rs1')
netuse('rs2')
netuse('soper')
netuse('tcen')
crtt('rs1tmp','f:ttn c:n(6) f:ddc c:d(10)')
sele 0
use rs1tmp excl
inde on dtos(ddc)+str(ttn,6) tag t1

crtt('tfrarh','f:ddc c:d(10) f:ttn c:n(6) f:mntov c:n(7) f:ktl c:n(9) f:zenp c:n(10,3) f:zenpa c:n(10,3) f:nat c:c(40)')
sele 0
use tfrarh excl
inde on dtos(ddc)+str(ttn,6) tag t1

sele rs1
go top
do while !eof()
   if vo#9
      skip
      loop
   endif
   ttnr=ttn
   ddcr=ddc
   sele rs1tmp
   appe blank
   repl ttn with ttnr,ddc with ddcr
   sele rs1
   skip
endd

sele rs1tmp
go top
ddcr=ctod('')
do while !eof()
   ttnr=ttn
   if ttnr=514587
*wait
   endif
   if ddc#ddcr
      ddcr=ddc
      sddcr=dtos(ddcr)
      pathfr=patharhr+'d'+subs(sddcr,3,2)+subs(sddcr,5,2)+subs(sddcr,7,2)+'\'
      if !file(pathfr+'ctov.dbf')
         sele rs1tmp
         do while ddc=ddcr
            skip
         endd
         loop
      endif
      if select('ctov')#0
         sele ctov
         use
      endif
      sele 0
      use (pathfr+'ctov') excl
      inde on str(mntov,7) tag t1
   endif
   sele rs1
   if netseek('t1','ttnr')
      kopr=kop
      kopir=kopi
      kop_r=kopr
      if kopr#kopir
         kop_r=kopir
      endif
      kplr=nkkl
      sele soper
      locate for d0k1=0.and.vo=9.and.kop=mod(kop_r,100)
      tcenr=tcen
      ptcenr=ptcen
      xtcenr=xtcen
      sele tcen
      locate for tcen=tcenr
      czenr=alltrim(zen)
*      locate for tcen=ptcenr
*      cbzenr=alltrim(zen)
*      locate for tcen=xtcenr
*      cxzenr=alltrim(zen)
      sele rs2
      if netseek('t1','ttnr')
         do while ttn=ttnr
            mntovr=mntov
            ktlr=ktl
            zenpr=zenp
*            bzenpr=bzenp
*            xzenpr=xzenp
            sele ctov
            if netseek('t1','mntovr')
               natr=nat
               zenp_r=&czenr
*               bzenp_r=&cbzenr
*               xzenp_r=&cxzenr
            else
               natr=''
               zenp_r=0
*               bzenp_r=0
*               xzenp_r=0
            endif
            if (zenpr#0.and.zenpr#zenp_r) //.or.(bzenpr#0.and.bzenpr#bzenp_r).or.(xzenpr#0.and.xzenpr#xzenp_r)
               ?str(ttnr,6)+' '+str(mntovr,7)+str(ktlr,9)+' '+str(zenpr,10,3)+' '+str(zenp_r,10,3)+' '+alltrim(natr) //+' 2 '+str(bzenpr,10,3)+' '+str(bzenp_r,10,3)+' 3 '+str(xzenpr,10,3)+' '+str(xzenp_r,10,3)
               sele tfrarh
               appe blank
               repl ddc with ddcr,;
                    ttn with ttnr,;
                    mntov with mntovr,;
                    ktl with ktlr,;
                    zenp with zenpr,;
                    zenpa with zenp_r,;
                    nat with subs(natr,1,40)
            endif
            sele rs2
            skip
         endd
      endif
   endif
   sele rs1tmp
   skip
endd
nuse()
sele rs1tmp
use
erase rs1.dbf
erase rs1.cdx
sele tfrarh
sort on ddc,ttn to frarh
use
erase tfrarh.dbf
erase tfrarh.cdx
set prin off
set prin to

