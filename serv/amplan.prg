* ������ ����� �� 䮪��� ��㯯�,����⮢
clea
netuse('s_tag')
netuse('mkeep')
netuse('brand')
netuse('kplkgp')
netuse('fent')
netuse('fbr')
netuse('fag')
netuse('bmplan')

sele fent
forr='.t.'
rcfentr=recn()
do while .t.
   sele fent
   go rcfentr
   foot('ENTER,F2','������,���� �� �७���')
   rcfentr=slcf('fent',1,1,18,,"e:kfent h:'���' c:n(3) e:nfent h:'������������' c:c(20)",,,1,,,,'������ ��㯯�')
   if lastkey()=27
      exit
   endif
   go rcfentr
   kfentr=kfent
   nfentr=nfent
   do case
      case lastkey()=13 && ������
           save scre to scfagr
           fgag()
           rest scre from scfagr
      case lastkey()=-1 && �७��
           save scre to scfbrr
           fplan()
           rest scre from scfbrr
   endc
enddo
nuse()

**********
* �㭪樨
**********

func fgag()
sele fag
if netseek('t1','kfentr')
   do while kfent=kfentr
      ktar=kta
      sele fbr
      if netseek('t1','kfentr')
         do while kfent=kfentr
            brandr=brand
            sele bmplan
            if !netseek('t1','0,kfentr,ktar,brandr')
               netadd()
               netrepl('kfent,kta,brand','kfentr,ktar,brandr')
            endif
            sele fbr
            skip
         endd
      endif
      sele fag
      skip
   endd
endif
sele fag
netseek('t1','kfentr')
rcfagr=recn()
wlar='.t..and.kfent=kfentr'
do while .t.
   sele fag
   go rcfagr
   foot('ENTER','����')
   rcfagr=slcf('fag',1,28,18,,"e:kta h:'���' c:n(4) e:getfield('t1','fag->kta','s_tag','fio') h:'���' c:c(20)",,,1,wlar,,,alltrim(nfentr)+' (������)')
   if lastkey()=27
      exit
   endif
   sele fag
   go rcfagr
   ktar=kta
   nktar=getfield('t1','ktar','s_tag','fio')
   do case
      case lastkey()=13 && ���� �� ������
           save scre to scaplan
           aplan()
           rest scre from scaplan
   endc
endd
retu .t.

func fplan()
sele fbr
if netseek('t1','kfentr')
   do while kfent=kfentr
      brandr=brand
      sele bmplan
      if !netseek('t1','0,kfentr,0,brandr')
         netadd()
         netrepl('kfent,brand','kfentr,brandr')
      endif
      sele fbr
      skip
   endd
endif
sele bmplan
netseek('t1','0,kfentr,0')
rcbr=recn()
wlfr='.t..and.mkeep=0.and.kfent=kfentr.and.kta=0'
do while .t.
   sele bmplan
   go rcbr
   foot('ENTER','����')
   rcbr=slcf('bmplan',1,1,18,,"e:brand h:'���' c:n(10) e:getfield('t1','bmplan->brand','brand','nbrand') h:'������������' c:c(38) e:kol h:'����' c:n(12,3) e:kolk h:'����' c:n(12,3)",,,1,wlfr,,,'����᭠� ��㯯� '+alltrim(nfentr)+' (���� �� �७���)')
   if lastkey()=27
      exit
   endif
   sele bmplan
   go rcbr
   brandr=brand
   kolr=kol
   kolrr=kolr
   mkeepr=getfield('t1','brandr','brand','mkeep')
   if netseek('t1','mkeepr,0,0,brandr')
      kolmr=kol-kolk
   endif
   go rcbr
   do case
      case lastkey()=13 && ����
           @ row(),39 say str(kolmr,12,3) color 'r/bg'
           @ row(),52 get kolr pict '99999999.999' color 'r/bg'
           read
           if lastkey()=13
              netrepl('kol','kolr')
              if netseek('t1','mkeepr,0,0,brandr')
                 netrepl('kolk','kolk-kolrr+kolr')
              endif
              sele bmplan
              go rcbr
           endif
   endc
endd
retu .t.

func aplan()
sele bmplan
netseek('t1','0,kfentr,ktar')
rcbr=recn()
wlapr='.t..and.mkeep=0.and.kfent=kfentr.and.kta=ktar'
do while .t.
   sele bmplan
   go rcbr
   foot('ENTER','����')
   rcbr=slcf('bmplan',1,1,18,,"e:brand h:'���' c:n(10) e:getfield('t1','bmplan->brand','brand','nbrand') h:'������������' c:c(38) e:kol h:'����' c:n(12,3) e:kolk h:'����' c:n(12,3)",,,1,wlapr,,,alltrim(nktar)+' (���� �� �७���)')
   if lastkey()=27
      exit
   endif
   sele bmplan
   go rcbr
   kfentr=kfent
   brandr=brand
   kolr=kol
   kolrr=kolr
   mkeepr=getfield('t1','brandr','brand','mkeep')
   if netseek('t1','0,kfentr,0,brandr')
      kolfr=kol-kolk
   endif
   go rcbr
   do case
      case lastkey()=13 && ����
           @ row(),39 say str(kolfr,12,3) color 'r/bg'
           @ row(),52 get kolr pict '99999999.999' color 'r/bg'
           read
           if lastkey()=13
              netrepl('kol','kolr')
*              if netseek('t1','mkeepr,0,0,brandr')
*                 netrepl('kolk','kolk-kolrr+kolr')
*              endif
              if netseek('t1','0,kfentr,0,brandr')
                 netrepl('kolk','kolk-kolrr+kolr')
              endif
              sele bmplan
              go rcbr
           endif
   endc
endd
retu .t.

**************
func svplan()
**************
clea
netuse('s_tag')
netuse('stagm')
netuse('mkeep')
netuse('svplan')
netuse('agplan')
sele svplan
go top
rcsvr=recn()
do while .t.
   sele svplan
   go rcsvr
   foot('ENTER,INS,F4,DEL','������,��������,���४��,�������')
   rcsvr=slcf('svplan',1,1,18,,"e:ktas h:'���' c:n(4) e:nktas h:'������������' c:c(20) e:mkeep h:'TM' c:n(3) e:getfield('t1','svplan->mkeep','mkeep','nmkeep') h:'������������' c:c(20) e:kol h:'������⢮' c:n(10)",,,1,,,,'�㯥ࢠ�����')
   if lastkey()=27
      exit
   endif
   go rcsvr
   ktasr=ktas
   mkeepr=mkeep
   kolr=kol
   svkolr=kol
   nktasr=nktas
   do case
      case lastkey()=22
           svins(0)
      case lastkey()=7
           sele agplan
           if netseek('t1','ktasr,mkeepr')
              do while ktas=ktasr.and.mkeep=mkeepr
                 netdel()
                 skip
              endd
           endif
           sele svplan
           netdel()
           skip -1
           if bof()
              go top
           endif
           rcsvr=recn()
      case lastkey()=-3
           svins(1)
      case lastkey()=13
           agplan()
   endc
endd
nuse()
retu .t.

***************
func agplan()
***************
sele agplan
set orde to tag t1 && ktas,mkeep,kta
if netseek('t1','ktasr,mkeepr')
else
   go top
endif
rcagr=recn()
do while .t.
   sele agplan
   go rcagr
   foot('INS,DEL,F4','��������,�������,���४��')
   rcagr=slcf('agplan',10,10,8,,"e:kta h:'���' c:n(4) e:getfield('t1','agplan->kta','s_tag','fio') h:'������������' c:c(20) e:pr h:'���' c:n(3) e:kol h:'������⢮' c:n(10)",,,,'ktas=ktasr.and.mkeep=mkeepr',,,'������')
   if lastkey()=27
      exit
   endif
   sele agplan
   go rcagr
   prr=pr
   kolr=kol
   do case
      case lastkey()=22
           agi()
      case lastkey()=7
           netdel()
           skip -1
           if bof()
              go top
           endif
           rcagr=recn()
      case lastkey()=-3
           agcr()
   endc
endd
retu .t.
***************
func svins(p1)
***************
if empty(p1)
   ktasr=0
   mkeepr=0
   nktasr=space(20)
   kolr=0
endif
cler=setcolor('gr+/b,n/w')
wer=wopen(10,15,15,60)
wbox(1)
do while .t.
   if empty(p1)
      @ 0,1 say '���' get ktasr pict '9999' valid svi()
   else
      @ 0,1 say '���'+' '+str(ktasr,4)
   endif
   @ 1,1 say '������������' get nktasr
   if empty(p1)
      @ 2,1 say '��મ��ঠ⥫�' get mkeepr pict '999' valid mkeepi()
   else
      @ 2,1 say '��મ��ঠ⥫�'+' '+str(mkeepr,3)
   endif
   @ 3,1 say '������⢮' get kolr pict '9999999999'
   read
   if lastkey()=27
      exit
   endif
   if lastkey()=13
      sele svplan
      if empty(p1)
         if !netseek('t1','ktasr,mkeepr')
            netadd()
            netrepl('ktas,nktas,mkeep,kol','ktasr,nktasr,mkeepr,kolr')
            rcsvr=recn()
            exit
         else
            wmess('��� ����',2)
         endif
      else
         netrepl('nktas,kol','nktasr,kolr')
         exit
      endif
   endif
enddo
wclose(wer)
setcolor(cler)
retu .t.
*************
func svi()
*************
sele svplan
if netseek('t1','ktasr')
   nktasr=nktas
endif
retu .t.
**************
func mkeepi()
  **************
  wselect(0)
  if mkeepr#0
     if !netseek('t1','mkeepr','mkeep')
        mkeepr=0
     endif
  endi
  if mkeepr=0
     sele mkeep
     rcmkeepr=slcf('mkeep',1,1,18,,"e:mkeep h:'���' c:n(3) e:nmkeep h:'������������' c:�(20)",,,,,'lv20=1',,'��મ��ঠ⥫�')
     go rcmkeepr
     mkeepr=mkeep
  endi
  wselect(wer)
  retu .t.
**************
func agi()
**************
sele s_tag
rcagr=slcf('s_tag',1,1,18,,"e:kod h:'���' c:n(3) e:fio h:'������������' c:�(20)",,,,,'uvol=0.and.ent=gnEnt.and.kod#ktas',,'������')
go rcagr
ktar=kod
if lastkey()=13
   sele agplan
   if !netseek('t1','ktasr,mkeepr,ktar')
      netadd()
      netrepl('ktas,mkeep,kta','ktasr,mkeepr,ktar')
      rcagr=recn()
   else
      wmess('��� ����',2)
   endif
endif
retu .t.
***************
func agcr()
***************
cler=setcolor('gr+/b,n/w')
wer=wopen(10,15,13,60)
wbox(1)
do while .t.
   @ 0,1 say '��業�' get prr pict '999'
   @ 1,1 say '������⢮' get kolr pict '9999999999'
   read
   if lastkey()=27
      exit
   endif
   if lastkey()=13
      if prr#0
         kolr=svkolr*prr/100
      endif
      sele agplan
      if netseek('t1','ktasr,mkeepr')
         kol_r=0
         do while ktas=ktasr.and.mkeep=mkeepr
            if recn()=rcagr
               skip
               loop
            endif
            kol_r=kol_r+kol
            skip
         endd
         if kol_r+kolr>svkolr
            kolr=svkolr-kol_r
            prr=kolr*100/svkolr
         endif
      endif
      go rcagr
      netrepl('pr,kol','prr,kolr')
      exit
   endif
enddo
wclose(wer)
setcolor(cler)
retu .t.
