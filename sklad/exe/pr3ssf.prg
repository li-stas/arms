#include "common.ch"
#include "inkey.ch"
store 0 to ssz_r,ssf_r,pr_r,sz40kr
store '' to nz_r
sele dclr
******
netseek('t1','kszr')
******
if prp=1
   wmess('Эта статья не корректируется',1)
   retu
endif
clpr3ssf=setcolor('w+/rb+,n/w')
wpr3ssf=wopen(10,10,13,57,.t.)
wbox(1)
nz_r=nz
@ 0,1 say '       Наименование   Процент    Сумма'
sele pr3
if netseek('t1','mnr,kszr')
   ssf_r=ssf
   pr_r=pr
   if kszr#90
      if kszr=11.and.pr_r=0
         pr_r=gnNds
      endif
      @ 1,1 say str(kszr,2)+' '+nz_r get pr_r pict '9999.99'
      @ 1,col()+1 say ssf_r pict '99999999.999'
   endif
   read
   if lastkey()=K_ESC
      wclose(wpr3ssf)
      setcolor(clpr3ssf)
      retu
   endif
   if pr_r=0
      @ 1,1 say str(kszr,2)+' '+nz_r+' '+str(pr_r,6,2) get ssf_r pict '99999999.999' when sz40w() valid sz40v()
      read
      if lastkey()=K_ESC
         wclose(wpr3ssf)
         setcolor(clpr3ssf)
         retu
      endif
   endif
   sele pr3
   netrepl('ssf,pr','ssf_r,pr_r')
   prModr=1
endif
wclose(wpr3ssf)
setcolor(clpr3ssf)
retu

************
func sz40w()
************
sz40kr=savesetkey()
set key K_SPACE to sz32
retu .t.
************
func sz40v()
************
set key K_SPACE to
restsetkey(sz40kr)
retu .t.
*****************
func sz32()
*****************
if vor=1.and.(str(kopr, 3)$"108;107").and.kszr=40.and.przr=0

   ssf_r=0
   sele pr2
   if netseek('t1','mnr')
      do while mn=mnr
         if ozen#0
 //            ssf_r=ssf_r+roun(kf*(ozen-zen),2)
            ssf_r=ssf_r+roun(kf*ozen,2)-roun(kf*zen,2)
         endif
         sele pr2
         skip
      endd
   endif
endif
retu .t.
