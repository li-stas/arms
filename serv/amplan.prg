* Месячные планы на фокусные группы,агентов
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
   foot('ENTER,F2','Агенты,План по брендам')
   rcfentr=slcf('fent',1,1,18,,"e:kfent h:'Код' c:n(3) e:nfent h:'Наименование' c:c(20)",,,1,,,,'Фокусные группы')
   if lastkey()=27
      exit
   endif
   go rcfentr
   kfentr=kfent
   nfentr=nfent
   do case
      case lastkey()=13 && Агенты
           save scre to scfagr
           fgag()
           rest scre from scfagr
      case lastkey()=-1 && Бренды
           save scre to scfbrr
           fplan()
           rest scre from scfbrr
   endc
enddo
nuse()

**********
* Функции
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
   foot('ENTER','План')
   rcfagr=slcf('fag',1,28,18,,"e:kta h:'Код' c:n(4) e:getfield('t1','fag->kta','s_tag','fio') h:'ФИО' c:c(20)",,,1,wlar,,,alltrim(nfentr)+' (Агенты)')
   if lastkey()=27
      exit
   endif
   sele fag
   go rcfagr
   ktar=kta
   nktar=getfield('t1','ktar','s_tag','fio')
   do case
      case lastkey()=13 && План по агенту
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
   foot('ENTER','План')
   rcbr=slcf('bmplan',1,1,18,,"e:brand h:'Код' c:n(10) e:getfield('t1','bmplan->brand','brand','nbrand') h:'Наименование' c:c(38) e:kol h:'КолП' c:n(12,3) e:kolk h:'КолР' c:n(12,3)",,,1,wlfr,,,'Фокусная группа '+alltrim(nfentr)+' (План по брендам)')
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
      case lastkey()=13 && План
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
   foot('ENTER','План')
   rcbr=slcf('bmplan',1,1,18,,"e:brand h:'Код' c:n(10) e:getfield('t1','bmplan->brand','brand','nbrand') h:'Наименование' c:c(38) e:kol h:'КолП' c:n(12,3) e:kolk h:'КолР' c:n(12,3)",,,1,wlapr,,,alltrim(nktar)+' (План по брендам)')
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
      case lastkey()=13 && План
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
   foot('ENTER,INS,F4,DEL','Агенты,Добавить,Коррекция,Удалить')
   rcsvr=slcf('svplan',1,1,18,,"e:ktas h:'Код' c:n(4) e:nktas h:'Наименование' c:c(20) e:mkeep h:'TM' c:n(3) e:getfield('t1','svplan->mkeep','mkeep','nmkeep') h:'Наименование' c:c(20) e:kol h:'Количество' c:n(10)",,,1,,,,'Супервайзеры')
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
   foot('INS,DEL,F4','Добавить,Удалить,Коррекция')
   rcagr=slcf('agplan',10,10,8,,"e:kta h:'Код' c:n(4) e:getfield('t1','agplan->kta','s_tag','fio') h:'Наименование' c:c(20) e:pr h:'Проц' c:n(3) e:kol h:'Количество' c:n(10)",,,,'ktas=ktasr.and.mkeep=mkeepr',,,'Агенты')
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
      @ 0,1 say 'Код' get ktasr pict '9999' valid svi()
   else
      @ 0,1 say 'Код'+' '+str(ktasr,4)
   endif
   @ 1,1 say 'Наименование' get nktasr
   if empty(p1)
      @ 2,1 say 'Маркодержатель' get mkeepr pict '999' valid mkeepi()
   else
      @ 2,1 say 'Маркодержатель'+' '+str(mkeepr,3)
   endif
   @ 3,1 say 'Количество' get kolr pict '9999999999'
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
            wmess('Уже есть',2)
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
     rcmkeepr=slcf('mkeep',1,1,18,,"e:mkeep h:'Код' c:n(3) e:nmkeep h:'Наименование' c:с(20)",,,,,'lv20=1',,'Маркодержатели')
     go rcmkeepr
     mkeepr=mkeep
  endi
  wselect(wer)
  retu .t.
**************
func agi()
**************
sele s_tag
rcagr=slcf('s_tag',1,1,18,,"e:kod h:'Код' c:n(3) e:fio h:'Наименование' c:с(20)",,,,,'uvol=0.and.ent=gnEnt.and.kod#ktas',,'Агенты')
go rcagr
ktar=kod
if lastkey()=13
   sele agplan
   if !netseek('t1','ktasr,mkeepr,ktar')
      netadd()
      netrepl('ktas,mkeep,kta','ktasr,mkeepr,ktar')
      rcagr=recn()
   else
      wmess('Уже есть',2)
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
   @ 0,1 say 'Процент' get prr pict '999'
   @ 1,1 say 'Количество' get kolr pict '9999999999'
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
