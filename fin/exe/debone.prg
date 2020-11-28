#include "inkey.ch"
* Ñ•°•‚Æ‡™†
para p1
kkl_rr=p1
nuse('tdop')
nuse('kops')
nuse('dz')
nuse('kz')
nuse('deb')
nuse('bdoc')
nuse('skdoc')
erase tdop.dbf
erase kops.dbf
erase dz.dbf
erase dz.cdx
erase kz.dbf
erase kz.cdx
crtt('temp','f:kkl c:n(7) f:nkl c:c(30) f:pdz c:n(10,2) f:pdz1 c:n(10,2) f:pdz2 c:n(10,2) f:pdz3 c:n(10,2) f:dz c:n(10,2) f:kz c:n(10,2) f:ddk c:d(10) f:ddb c:d(10) f:bs_s c:n(10,2) f:bs_d c:n(3) f:sprz0 c:n(10,2) f:msk c:c(9)')
sele 0
use temp
copy stru to temp1 exte
use
erase temp.dbf
sele 0
use temp1
for i=1 to 40
    appe blank
    repl field_name with 'sdv'+alltrim(str(i,2)),;
         field_type with 'N',;
         field_len with 10,;
         field_dec with 2
    appe blank
    repl field_name with 'dop'+alltrim(str(i,2)),;
         field_type with 'D',;
         field_len with 8
next
use
create deb from temp1 new
use
erase temp1.dbf
sele 0
use deb excl
inde on str(kkl,7) tag t1

dt1r=ctod(stuff(dtoc(addmonth(gdTd,-1)),1,2,'01'))
yy1r=year(dt1r)
mm1r=month(dt1r)
dt2r=gdTd
yy2r=year(dt2r)
mm2r=month(dt2r)

netuse('kln')
netuse('opfh')
netuse('cskl')
netuse('dkkln')
netuse('dokk')
netuse('doks')
netuse('bs')
netuse('s_tag')
netuse('kpl')

rsdocone()
dzone()
*showdebone()

nuse('tdop')
nuse('kops')
nuse('dz')
nuse('kz')
nuse('deb')
nuse('bdoc')
nuse('skdoc')
erase tdop.dbf
erase kops.dbf
erase dz.dbf
erase dz.cdx
erase kz.dbf
erase kz.cdx
retu .t.

func rsdocone()

crtt('skdoc','f:kpl c:n(7) f:dop c:d(10) f:sdv c:n(10,2) f:prz c:n(1) f:kgp c:n(7) f:kta c:n(4) f:sk c:n(3) f:ttn c:n(6) f:kop c:n(3) f:nkkl c:n(7) f:nkta c:c(15) f:sdp c:n(10,2)')
sele 0
use skdoc excl
inde on str(kpl,7)+dtos(dop) tag t1

for y=yy1r to yy2r
    do case
       case yy1r=yy2r
            m1r=mm1r
            m2r=mm2r
       case y=yy1r
            m1r=mm1r
            m2r=12
       case y=yy2r
            m1r=1
            m2r=mm2r
       othe
            m1r=1
            m2r=12
    endc
    for m=m1r to m2r
        pathdr=gcPath_e+'g'+str(y,4)+'\m'+iif(m<10,'0'+str(m,1),str(m,2))+'\'
        sele cskl
        go top
        do while !eof()
           if !(rasc=1.and.ent=gnEnt)
              skip
              loop
           endif
           skr=sk
           pathr=pathdr+alltrim(path)
           if !netfile('soper',1)
              skip
              loop
           endif
           if gnArm#0
*              ?pathr
           endif
           netuse('soper',,,1)
           dkops()
           netuse('rs1',,,1)
           go top
           do while !eof()
              if !(y=yy2r.and.m=m2r)
                 if prz=0
                    skip
                    loop
                 endif
              endif
              if empty(dop)
                 skip
                 loop
              endif
              if kpl#kkl_rr
                 skip
                 loop
              endif
              kopr=kop
              kplr=kpl
              kgpr=kpv
              dopr=dop
              sdvr=sdv
              przr=prz
              ktar=kta
              nktar=getfield('t1','ktar','s_tag','fio')
              ttnr=ttn
              nkklr=nkkl
              sele kops
              locate for d0k1=0.and.kop=kopr
              if !foun()
                 sele rs1
                 skip
                 loop
              else
                 sele skdoc
                 netadd()
                 netrepl('ttn,kpl,kgp,dop,sdv,prz,kta,sk,kop,nkkl,nkta',;
                         'ttnr,kplr,kgpr,dopr,sdvr,przr,ktar,skr,kopr,nkklr,nktar')
              endif
              sele rs1
              skip
           endd
           nuse('rs1')
           nuse('soper')
           sele cskl
           skip
        endd
    next
next
crtt('tdop','f:nn c:n(2) f:dop c:d(10)')
sele 0
use tdop
dtr=date()+1
for i=1 to 40
    appe blank
    repl nn with i,dop with dtr-i
next
retu .t.

func dzone()
if select('dz')#0
   sele dz
   use
endif
erase dz.dbf
erase dz.cdx
crtt('dz','f:kkl c:n(7) f:dz c:n(12,2) f:ddb c:d(10)')
sele 0
use dz
inde on str(kkl,7) tag t1
if select('kz')#0
   sele kz
   use
endif
erase kz.dbf
crtt('kz','f:kkl c:n(7) f:kz c:n(12,2) f:ddb c:d(10)')
sele 0
use kz
inde on str(kkl,7) tag t1
sele dkkln
if netseek('t1','kkl_rr')
   do while kkl=kkl_rr
      ddbr=ddb
      if bs=361001
         dzr=dn-kn+db-kr
         sele dz
         netadd()
         netrepl('kkl,dz,ddb','kklr,dzr,ddbr')
      else
         if bs=631001
            kzr=dn-kn+db-kr
            if kzr<0
               sele kz
               netadd()
               netrepl('kkl,kz,ddb','kklr,kzr,ddbr')
            endif
         endif
      endif
      sele dkkln
      skip
   endd
endif
if select('tdop')=0
   sele 0
   use tdop
endif
if select('skdoc')=0
   sele 0
   use skdoc excl
   inde on str(kpl,7)+dtos(dop) tag t1
endif
sele skdoc
go top
do while !eof()
   if prz=1
      skip
      loop
   endif
   kklr=kpl
   dzr=sdv
   ddbr=dop
   sele dz
   seek str(kklr,7)
   if foun()
      netrepl('dz','dz+dzr')
   else
      netadd()
      netrepl('kkl,dz,ddb','kklr,dzr,ddbr')
   endif
   sele skdoc
   skip
endd

sele dz
go top
do while !eof()
   kklr=kkl
   dzr=dz
   if dzr<0
      skip
      loop
   endif
   ddbr=ddb
   sele deb
   seek str(kklr,7)
   if !foun()
      netadd()
      netrepl('kkl,dz,ddb','kklr,dzr,ddbr')
   endif
   sele skdoc
   seek str(kklr,7)
   if foun()
      do while kpl=kklr
         sdvr=sdv
         dopr=dop
         sele tdop
         locate for dop=dopr
         if foun()
            nnr=nn
            csdvr='sdv'+alltrim(str(nnr,2))
            cdopr='dop'+alltrim(str(nnr,2))
            sele deb
            repl &csdvr with &csdvr+sdvr,;
                 &cdopr with dopr
         endif
         sele skdoc
         skip
      endd
   endif
   sele dz
   skip
endd

crtt('bdoc','f:kkl c:n(7) f:ddk c:d(10) f:bs_d c:n(10,2) f:bs_s c:n(10,2) f:nplp c:n(6) f:osn c:c(30) f:rn c:n(6)')
sele 0
use bdoc excl
inde on str(kkl,7) tag t1
sele dokk
set orde to tag t5 && kkl,mn,rnd,rn
sele dz
go top
do while !eof()
   kklr=kkl
   sele dokk
   if netseek('t5','kklr')
      do while kkl=kklr
         if mn=0
            skip
            loop
         endif
         if prc
            skip
            loop
         endif
         if bs_k#361001
            skip
            loop
         endif
         ddkr=ddk
         bs_dr=bs_d
         bs_sr=bs_s
         nplpr=nplp
         rndr=rnd
         mnr=mn
         osnr=getfield('t1','mnr,rndr,kklr','doks','osn')
         sele bdoc
         netadd()
         netrepl('kkl,ddk,bs_d,bs_s,nplp,osn','kklr,ddkr,bs_dr,bs_sr,nplpr,osnr')
         sele dokk
         skip
      endd
   endif
   sele dz
   skip
endd

sele deb
go top
do while !eof()
     kklr=kkl
     nkler=getfield('t1','kklr','kln','nkle')
     opfhr=getfield('t1','kklr','kln','opfh')
     nsopfhr=getfield('t1','opfhr','opfh','nsopfh')
     nklr=alltrim(nsopfhr)+' '+alltrim(nkler)
     mskr=getfield('t1','kklr','kpl','crmsk')
     netrepl('nkl,msk','nklr,mskr')
     pdzr=dz
     pdz1r=dz
     pdz2r=dz
     pdz3r=dz

     for i=1 to 40
         csdvr='sdv'+alltrim(str(i,3))
         sdvr=&csdvr
         if i<8
            if pdzr>sdvr
               pdzr=pdzr-sdvr
            else
               sdvr=pdzr
               repl &csdvr with sdvr
               pdzr=0
            endif
         endif
         if i<15
            if pdz1r>sdvr
               pdz1r=pdz1r-sdvr
            else
               sdvr=pdz1r
               repl &csdvr with sdvr
               pdz1r=0
            endif
         endif
         if i<22
            if pdz3r>sdvr
               pdz3r=pdz3r-sdvr
            else
               sdvr=pdz3r
               repl &csdvr with sdvr
               pdz3r=0
            endif
         endif
         if pdz2r>sdvr
            pdz2r=pdz2r-sdvr
         else
            sdvr=pdz2r
            repl &csdvr with sdvr
            pdz2r=0
         endif
     next
     repl pdz with pdzr,pdz1 with pdz1r,pdz3 with pdz3r
     sele kz
     loca for kkl=kklr
     kzr=0
     if foun()
        kzr=abs(kz)
        sele deb
        repl kz with kzr
     endif
     sele bdoc
     seek str(kklr,7)
     if foun()
        ddkr=ddk
        bs_sr=bs_s
        bs_dr=int(bs_d/1000)
        sele deb
        repl bs_s with bs_sr,ddk with ddkr,bs_d with bs_dr
     endif
   sele deb
   skip
endd
nuse('deb')
nuse('skdoc')
nuse('bdoc')
retu .t.

func showdebone()
if select('bdoc')#0
   sele bdoc
   use
endif
sele 0
use bdoc share
set orde to tag t1
go top
if select('skdoc')#0
   sele skdoc
   use
endif
sele 0
use skdoc share
set orde to tag t1
go top
if select('deb')#0
   sele deb
   use
endif
sele 0
use deb share
set orde to tag t1
go top
rcdebr=recn()
fldnomr=1
forr='.t.'
for_r='.t.'
store space(20) to ctextr
store 0 to kkl_r,napr
store space(9) to msk_r
do while .t.
   sele deb
   go rcdebr
   rcdebr=slce('deb',1,1,18,,"e:kkl h:'äÆ§' c:n(7) e:nkl h:'ç†®¨•≠Æ¢†≠®•' c:c(30) e:kz h:'äá' c:n(10,2) e:dz h:'Ñá' c:n(10,2) e:pdz h:'èÑá>7' c:n(10,2) e:pdz1 h:'èÑá>14' c:n(10,2) e:pdz3 h:'èÑá>21' c:n(10,2) e:ddk h:'Ñèé' c:d(10) e:bs_s h:'ëèé' c:n(10,2) e:bs_d h:'Ç®§' c:n(3)",,,1,,forr,,'Ñ•°•‚Æ‡™†',1,2)
   go rcdebr
   do case
      case lastkey()=K_ESC
           exit
      case lastkey()=19 && Left
           fldnomr=fldnomr-1
           if fldnomr=0
              fldnomr=1
           endif
      case lastkey()=4 && Right
           fldnomr=fldnomr+1
   endc
endd
retu .t.

