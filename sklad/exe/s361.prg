#include "common.ch"
#include "inkey.ch"
* 361
store 0 to bsr
clea

netuse('zdz')
netuse('kln')
netuse('s_tag')
netuse('zopl')
netuse('zople')
netuse('zttn')
netuse('bs')
fldnomr=1
forr='.t.'
prvidr=0
sele zdz
levr=1
netseek('t1','levr')
rczdzr=recn()
zdzhdr='ëóÖíÄ'
do while .t.
   sele zdz
   go rczdzr
   foot('F3','ííç')
   do case
      case levr=1
           zdzhdr='ëÁ•‚†'
           forr='.t.'
           rczdzr=slce('zdz',1,1,18,,"e:bs h:'Åë' c:n(6) e:getfield('t1','zdz->bs','bs','nbs') h:'ëÁ•‚' c:·(20) e:dz h:'Ñá' c:n(10,2) e:dz7 h:'Ñß7' c:n(10,2) e:dz14 h:'Ñß14' c:n(10,2) e:dz21 h:'Ñß21' c:n(10,2) e:dz28 h:'Ñß28' c:n(10,2) e:dz99 h:'Ñß99' c:n(10,2) e:kddz h:'Ñ≠' c:n(5)",,,1,'lev=levr',forr,,zdzhdr)
      case levr=2
           foot('F3,F4','ííç,éØ´†‚Î ÇÆß¢‡ äÆ‡‡')
           forr='bs=bsr'
           zdzhdr=str(bsr,6)+' '+nbsr
           rczdzr=slce('zdz',1,1,18,,"e:kkl h:'KKL' c:n(7) e:getfield('t1','zdz->kkl','kln','nkl') h:'ä´®•≠‚' c:·(40) e:dz h:'Ñá' c:n(10,2) e:dz7 h:'Ñß7' c:n(10,2) e:dz14 h:'Ñß14' c:n(10,2) e:dz21 h:'Ñß21' c:n(10,2) e:dz28 h:'Ñß28' c:n(10,2) e:dz99 h:'Ñß99' c:n(10,2) e:kddz h:'Ñ≠' c:n(5)",,,1,'lev=levr',forr,,zdzhdr)
      case levr=3
           forr='bs=bsr.and.kkl=kklr'
           zdzhdr=str(bsr,6)+' '+nbsr+iif(kklr#0,' '+str(kklr,7)+' '+nklr,'')
           rczdzr=slce('zdz',1,1,18,,"e:ktas h:'KTAS' c:n(4) e:getfield('t1','zdz->ktas','s_tag','fio') h:'ë„Ø•‡' c:c(20) e:dz h:'Ñá' c:n(10,2) e:dz7 h:'Ñß7' c:n(10,2) e:dz14 h:'Ñß14' c:n(10,2) e:dz21 h:'Ñß21' c:n(10,2) e:dz28 h:'Ñß28' c:n(10,2) e:dz99 h:'Ñß99' c:n(10,2) e:kddz h:'Ñ≠' c:n(5)",,,1,'lev=levr',forr,,zdzhdr)
      case levr=4
           forr='bs=bsr.and.kkl=kklr.and.ktas=ktasr'
           zdzhdr=str(bsr,6)+' '+nbsr+iif(kklr#0,' '+str(kklr,7)+' '+nklr,'')+iif(ktasr#0,' '+str(ktasr,4)+' '+nktasr,'')
           rczdzr=slce('zdz',1,1,18,,"e:kta h:'KTA' c:n(4) e:getfield('t1','zdz->kta','s_tag','fio') h:'Ä£•≠‚' c:c(20) e:dz h:'Ñá' c:n(10,2) e:dz7 h:'Ñß7' c:n(10,2) e:dz14 h:'Ñß14' c:n(10,2) e:dz21 h:'Ñß21' c:n(10,2) e:dz28 h:'Ñß28' c:n(10,2) e:dz99 h:'Ñß99' c:n(10,2) e:kddz h:'Ñ≠' c:n(5)",,,1,'lev=levr',forr,,zdzhdr)
   endc
   sele zdz
   go rczdzr
   bsr=bs
   nbsr=alltrim(getfield('t1','bsr','bs','nbs'))
   kklr=kkl
   nklr=alltrim(getfield('t1','kklr','kln','nkl'))
   ktasr=ktas
   nktasr=alltrim(getfield('t1','ktasr','s_tag','fio'))
   ktar=kta
   nktar=alltrim(getfield('t1','ktar','s_tag','fio'))
   do case
      case lastkey()=19 // Left
           fldnomr=fldnomr-1
           if fldnomr=0
              fldnomr=1
           endif
      case lastkey()=4 // Right
           fldnomr=fldnomr+1
      case lastkey()=K_F3
           zdzttn()
      case lastkey()=K_F4.and.levr=2
           zdzopl()
      case lastkey()=K_F5
      case lastkey()=K_ENTER
           do case
              case levr=1
                   levr=2
                   rczdz1r=recn()
                   netseek('t1','levr')
                   rczdzr=recn()
              case levr=2
                   levr=3
                   rczdz2r=recn()
                   netseek('t1','levr')
                   rczdzr=recn()
              case levr=3
                   levr=4
                   rczdz3r=recn()
                   netseek('t1','levr')
                   rczdzr=recn()
              case levr=4
           endc
      case lastkey()=K_ESC
           do case
              case levr=1
                   exit
              case levr=2
                   levr=1
                   rczdzr=rczdz1r
              case levr=3
                   levr=2
                   rczdzr=rczdz2r
              case levr=4
                   levr=3
                   rczdzr=rczdz3r
           endc
           if levr#1
              go rczdzr
              bsr=bs
              nbsr=alltrim(getfield('t1','bsr','bs','nbs'))
              kklr=kkl
              nklr=alltrim(getfield('t1','kklr','kln','nkl'))
              ktasr=ktas
              nktasr=alltrim(getfield('t1','ktasr','s_tag','fio'))
              ktar=kta
              nktar=alltrim(getfield('t1','ktar','s_tag','fio'))
           endif
   endc
endd
nuse()

**************
func zdzflt()
**************
priv kklr,sklr,bsr
cldkklnlt=setcolor('gr+/b,n/w')
wdkklnlt=wopen(10,20,15,60)
wbox(1)
do while .t.
   stor 0 to kklr,sklr,bsr
   @ 0,1 say 'äÆ§         ' get kklr pict '9999999'
   @ 1,1 say 'ëÁ•‚        ' get bsr pict '999999'
   @ 2,1 say 'äÆ≠‚•™·‚    ' get txtr
   read
   do case
      case lastkey()=K_ESC
           exit
      case lastkey()=K_ENTER
           if kklr=0.and.empty(txtr).and.bsr=0
              set filt to
              go top
           else
              sele dkkln
              if empty(txtr)
                 do case
                    case kklr#0.and.bsr#0
                         set filt to
                         go top
                         if netseek('t1','kklr,bsr')
                            rcdkklnr=recn()
                         endif
                    case kklr#0.and.sklr=0
                         set filt to
                         go top
                         if netseek('t1','kklr')
                            rcdkklnr=recn()
                         endif
                    case kklr=0.and.bsr#0
                         set filt to bs=bsr
                         go top
                         rcdkklnr=recn()
                 endc
                 fordkr='.t.'
              else
                 sele dkkln
                 go top
                 rcdkklnr=recn()
                 txtr=upper(alltrim(txtr))
                 fordkr="at(txtr,upper(getfield('t1','dkkln->kkl','kln','nkl')))#0"
              endif
              if eof().and.bof()
                 set filt to
                 go top
                 rcdkklnr=recn()
              endif
           endif
           exit
   endc
enddo
wclose(wdkklnlt)
setcolor(cldkklnlt)
retu .t.

**************
func zdzttn()
**************
if levr#1
   do case
      case levr=2
           ttnforr='bs=bsr.and.kkl=kklr'
           ttnhdr=str(kklr,7)+' '+nklr
      case levr=3
           ttnforr='bs=bsr.and.kkl=kklr.and.ktasd=ktasr'
           ttnhdr=str(ktasr,4)+' '+nktasr
      case levr=4
           ttnforr='bs=bsr.and.kkl=kklr.and.ktasd=ktasr.and.ktad=ktar'
           ttnhdr=str(ktar,4)+' '+nktar
   endc
   sele zttn
   set orde to tag t3
   if netseek('t3','kklr,bsr')
      rczttnr=recn()
      do while .t.
         sele zttn
         go rczttnr
         foot('F4','éØ´†‚Î ÇÆß¢‡ äÆ‡‡')
         rczttnr=slce('zttn',5,1,10,,"e:skd h:'ë™´' c:n(3) e:rnd h:'ííç' c:n(6) e:prz h:'è' c:n(1) e:kopd h:'äéè' c:n(4) e:dop h:'Ñ‚é' c:d(10) e:db h:'Ñ°' c:n(9,2) e:dbc h:'Ñ°ä' c:n(9,2) e:kr h:'ä‡' c:n(9,2) e:krc h:'ä‡ä' c:n(9,2) e:krv h:'ä‡Ç' c:n(9,2)",,,1,,ttnforr,,ttnhdr)
         sele zttn
         go rczttnr
         skdr=skd
         rndr=rnd
         dbr=db
         dbcr=dbc
         krr=kr
         krcr=krc
         krvr=krv
         idzttnr=idzttn
         do case
            case lastkey()=19 // Left
                 fldnomr=fldnomr-1
                 if fldnomr=0
                    fldnomr=1
                 endif
            case lastkey()=4 // Right
                 fldnomr=fldnomr+1
            case lastkey()=K_F4
                 zdztopl()
            case lastkey()=K_ESC
                 exit
         endc
      endd
   endif
endif
retu .t.
**************
func zdzopl()
**************
sele zopl
set orde to tag t3
if netseek('t3','kklr,bsr')
   rczoplr=recn()
   do while .t.
      sele zopl
      go rczoplr
      foot('','')
      rczoplr=slce('zopl',5,1,10,,"e:ddk h:'Ñ†‚†' c:d(10) e:rndk h:'ê•£çÆ¨' c:n(6) e:skk h:'ë™´' c:n(3) e:rnk h:'çÆ¨ÑÆ™' c:n(6) e:dbc h:'Ñ°ä' c:n(9,2) e:kr h:'ä‡' c:n(9,2) e:krc h:'ä‡ä' c:n(9,2) e:krv h:'ä‡Ç' c:n(9,2) e:kopk h:'äéèä' c:n(4) e:kbs h:'äÆ‡ëÁ' c:n(6) e:bosn h:'é·≠Æ¢†≠®•' c:c(70)",,,,'kkl=kklr.and.bs=bsr',,,)
      sele zopl
      go rczoplr
      do case
         case lastkey()=19 // Left
              fldnomr=fldnomr-1
              if fldnomr=0
                 fldnomr=1
              endif
         case lastkey()=4 // Right
              fldnomr=fldnomr+1
         case lastkey()=K_F5
         case lastkey()=K_ESC
              exit
      endc
   endd
endif
retu .t.
***************
func zdztopl()
***************
sele zople
if netseek('t1','idzttnr')
   rczopler=recn()
   do while .t.
      sele zople
      go rczopler
      foot('','')
      rczopler=slce('zople',10,1,5,,"e:dbc h:'Ñ°ä' c:n(9,2) e:kr h:'ä‡' c:n(9,2) e:krc h:'ä‡ä' c:n(9,2) e:krv h:'ä‡Ç' c:n(9,2)",,,,'idzttn=idzttnr',,,)
      sele zople
      go rczopler
      do case
         case lastkey()=19 // Left
              fldnomr=fldnomr-1
              if fldnomr=0
                 fldnomr=1
              endif
         case lastkey()=4 // Right
              fldnomr=fldnomr+1
         case lastkey()=K_F5
         case lastkey()=K_ESC
              exit
      endc
   endd
endif
retu .t.
