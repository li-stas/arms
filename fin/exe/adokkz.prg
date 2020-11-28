#include "inkey.ch"
* adokkz // Для дебеторки аккорда
netuse('dokkz')
sele dokkz
set orde to tag t12
if !netseek('t12','mnr,rndr,0,rnr')
   sele dokk
   arec:={}; getrec()
   sele dokkz
   netadd(); putrec()
   netunlock()
endif
rcdokkz0r=recn()
rcdokkzr=recn()
do while .t.
   sele dokkz
   set orde to tag t12
   fldnomr=1
   go rcdokkzr
   foot('INS,DEL,F4','Добавить,Удалить,Коррекция')
   rcdokkzr=slcf('dokkz',,,,,"e:dokksk h:'Скл' c:n(3) e:dokkttn h:'ТТН' c:n(6) e:kop h:'КОП' c:n(4) e:dop h:'Отгр' c:d(10) e:ddk h:'Подтв' c:d(10) e:bs_s h:'Сумма' c:n(10,2) e:kta h:'KTA' c:n(4) e:ktas h:'KTAS' c:n(4)",,,,'mn=mnr.and.rnd=rndr',,,'По ТТН')
   if lastkey()=K_ESC
      exit
   endif
   sele dokkz
   go rcdokkzr
   kop_r=kop
   ddk_r=ddk
   kta_r=kta
   ktas_r=ktas
   dokkttn_r=dokkttn
   dokksk_r=dokksk
   bs_s_r=bs_s
   dop_r=dop
   do case
      case lastkey()=19 // Left
           fldnomr=fldnomr-1
           if fldnomr=0
              fldnomr=1
           endif
      case lastkey()=4 // Right
           fldnomr=fldnomr+1
      case lastkey()=22 // Добавить
           adokkzins(0)
      case lastkey()=7  // Удалить
           sele dokkz
           if recn()#rcdokkz0r
              go rcdokkz0r
              netrepl('bs_s','bs_s+bs_s_r')
              go rcdokkzr
              docmod('D уд',1)
              netdel()
              skip -1
              rcdokkzr=recn()
           endif
      case lastkey()=-3.and.nchekr=0 // Коррекция
           adokkzins(1)
      case lastkey()=K_ESC // Выход
           exit
      othe
           loop
   endc
endd
nuse('dokkz')
retu

*****************
func adokkzins(p1)
*****************
cldokkz=setcolor('n/w,n/bg')
wdokkz=wopen(5,2,13,78)
wbox(1)
if p1=0
   store 0 to kop_r,kta_r,ktas_r,dokksk_r,dokkttn_r,bs_s_r
   store ctod('') to ddk_r
endif
sum1_r=bs_sr // остаток
sele dokkz
ddk_r=ctod('')
do while .t.
   @ 0,1 say 'Склад' get dokksk_r pict '999' valid dsk(wdokkz)
   @ 1,1 say 'ТТН  ' get dokkttn_r pict '999999'  valid dttn(wdokkz)
   keyboard ''
   read
   if lastkey()=K_ESC
      exit
   endif
   @ 1,14 say dtoc(ddk_r)
   @ 4,1 say  'Сумма        '+str(bs_s_r,12,2)
   @ 6,1 prom 'Верно'
   @ 6,col()+1 prom 'Не верно'
   menu to mdokkz
   if lastkey()=K_ESC
      exit
   endif
   if mdokkz=1
      if p1=0
         sele dokkz
         go rcdokkz0r
         if bs_s-bs_s_r>0
            sele dokk
            arec:={}
            getrec()
            sele dokkz
            netadd()
            putrec()
            netrepl('ddk,bs_s,kop,kta,ktas,dokksk,dokkttn,dop','ddk_r,bs_s_r,kop_r,kta_r,ktas_r,dokksk_r,dokkttn_r,dop_r')
            rcdokkzr=recn()
            sele dokkz
            go rcdokkz0r
            netrepl('bs_s','bs_s-bs_s_r')
            go rcdokkzr
            docmod('Dдоб',1)
         else
            wmess('Нехватает остатка',2)
         endif
      endif
      exit
   endif
endd
wclose(wdokkz)
setcolor(cldokkz)
retu .t.
**********
func dkta()
**********
sele s_tag
set orde to tag t1
if ktar#0
   if !netseek('t1','ktar')
      ktar=0
   else
      if ktasr#0
         if ktas#ktasr
            ktar=0
         endif
      endif
   endif
   if ent#gnEnt
      ktar=0
   endif
endif
if ktar=0
   do case
      case bsr=301001
           ktaforr='iif(ktasr#0,ktas=ktasr,agsk<300).and.ent=gnEnt'
      case bsr=301003
           ktaforr='iif(ktasr#0,ktas=ktasr,agsk=300).and.ent=gnEnt'
      case bsr=301004
           if gnEnt=20
              ktaforr='iif(ktasr#0,ktas=ktasr,agsk=400).and.ent=gnEnt'
           endif
           if gnEnt=21
              ktaforr='iif(ktasr#0,ktas=ktasr,agsk=700).and.ent=gnEnt'
           endif
      case bsr=301005
           ktaforr='iif(ktasr#0,ktas=ktasr,agsk=500).and.ent=gnEnt'
      case bsr=301006
           ktaforr='iif(ktasr#0,ktas=ktasr,agsk=600).and.ent=gnEnt'
      other
           crmskr=getfield('t1','kklr','kpl','crmsk')
           ktaforr='.t.'
           do case
              case subs(crmskr,3,1)='1'
                   ktaforr=ktaforr+'.and.iif(ktasr#0,ktas=ktasr,agsk=500)'
              case subs(crmskr,4,1)='1'
                   if gnEnt=20
                      ktaforr=ktaforr+'.and.iif(ktasr#0,ktas=ktasr,agsk=400)'
                   endif
                   if gnEnt=21
                      ktaforr=ktaforr+'.and.iif(ktasr#0,ktas=ktasr,agsk=700)'
                   endif
              case subs(crmskr,5,1)='1'
                   ktaforr=ktaforr+'.and.iif(ktasr#0,ktas=ktasr,agsk=500)'
              case subs(crmskr,6,1)='1'
                   ktaforr=ktaforr+'.and.iif(ktasr#0,ktas=ktasr,agsk=600)'
              othe
                   ktaforr=ktaforr+'.and.iif(ktasr#0,ktas=ktasr,agsk<300)'
           endc
   endc
   wselect(0)
   set orde to tag t3
   go top
   ktar=slcf('s_tag',1,,18,,"e:kod h:'КТА' c:n(4) e:fio h:'ФИО' c:c(15) e:ktas h:'KTAS' c:n(4)",'kod',,,,ktaforr,,'Агенты')
   wselect(wdokk)
endif
@ 2,51 say alltrim(getfield('t1','ktar','s_tag','fio'))
retu .t.
**********
func dktas()
**********
sele s_tag
set orde to tag t1
if ktasr#0
   if !netseek('t1','ktasr')
      ktasr=0
   else
      if kod#ktas
         ktasr=0
      endif
   endif
   if ent#gnEnt
      ktasr=0
   endif
endif
if ktasr=0
   do case
      case bsr=301001
           ktaforr='kod=ktas.and.ent=gnEnt.and.agsk<300'
      case bsr=301003
           ktaforr='kod=ktas.and.ent=gnEnt.and.agsk=300'
      case bsr=301004
           if gnEnt=20
              ktaforr='kod=ktas.and.ent=gnEnt.and.agsk=400'
           endif
           if gnEnt=21
              ktaforr='kod=ktas.and.ent=gnEnt.and.agsk=700'
           endif
      case bsr=301005
           ktaforr='kod=ktas.and.ent=gnEnt.and.agsk=500'
      case bsr=301006
           ktaforr='kod=ktas.and.ent=gnEnt.and.agsk=600'
      other
           crmskr=getfield('t1','kklr','kpl','crmsk')
           ktaforr='.t.'
           do case
              case subs(crmskr,3,1)='1'
                   ktaforr=ktaforr+'.and.kod=ktas.and.agsk=300'
              case subs(crmskr,4,1)='1'
                   if gnEnt=20
                      ktaforr=ktaforr+'.and.kod=ktas.and.agsk=400'
                   endif
                   if gnEnt=21
                      ktaforr=ktaforr+'.and.kod=ktas.and.agsk=700'
                   endif
              case subs(crmskr,5,1)='1'
                   ktaforr=ktaforr+'.and.kod=ktas.and.agsk=500'
              case subs(crmskr,6,1)='1'
                   ktaforr=ktaforr+'.and.kod=ktas.and.agsk=600'
              othe
                   ktaforr=ktaforr+'.and.kod=ktas.and.agsk<300'
           endc
   endc
   wselect(0)
   set orde to tag t3
   go top
   ktasr=slcf('s_tag',1,,18,,"e:kod h:'КТА' c:n(4) e:fio h:'ФИО' c:c(15) e:ktas h:'KTAS' c:n(4)",'kod',,,,ktaforr,,'Супервайзеры')
   if lastkey()=K_ESC
      ktasr=0
   endif
   wselect(wdokk)
endif
@ 3,18 say alltrim(getfield('t1','ktasr','s_tag','fio'))
retu .t.
************
func dsk(p1)
************
* p1 - дескриптор окна
if dokksk_r#0
   sele cskl
   if !netseek('t1','dokksk_r','cskl')
      dokksk_r=0
      retu .f.
   else
      if ent#gnEnt
         dokksk_r=0
         retu .f.
      endif
      if rasc=0
         dokksk_r=0
         retu .f.
      endif
   endif
endif
if dokksk_r=0
   wselect(0)
   sele cskl
   go top
   rccsklr=recn()
   do while .t.
      sele cskl
      go rccsklr
      rccsklr=slcf('cskl',,,,,"e:sk h:'Склад' c:n(3) e:nskl h:'Наименование' c:c(20)",,,,,'ent=gnEnt.and.rasc=1',,'Склады')
      if lastkey()=K_ESC
         skr=0
         exit
      endif
      if lastkey()=13
         go rccsklr
         dokksk_r=sk
         exit
      endif
   endd
   wselect(p1)
endif
retu .t.

************
func dttn(p1)
************
prfndr=0
ddk_r=ctod('')
for yyr=year(gdTd) to 2006 step -1
    do case
       case yyr=year(gdTd)
            mm1r=month(gdTd)
            mm2r=1
       case yyr=2006
            mm1r=12
            mm2r=9
       othe
            mm1r=12
            mm2r=1
    endc
    for mmr=mm1r to mm2r step -1
        pathr=gcPath_e+'g'+str(yyr,4)+'\m'+iif(mmr<10,'0'+str(mmr,1),str(mmr,2))+'\bank\'
        if !netfile('dokk',1)
           loop
        endif
        netuse('dokk','dokkfnd',,1)
        set orde to tag t12
        if netseek('t12','0,0,dokksk_r,dokkttn_r,0')
           bs_s_rr=0
           do while mn=0.and.rnd=0.and.sk=dokksk_r.and.rn=dokkttn_r.and.mnp=0
              ddk_r=ddk
              if int(bs_d/1000)=361
                 bs_s_rr=bs_s_rr+bs_s
                 kta_r=kta
                 ktas_r=ktas
                 dop_r=dop
                 kop_r=kop
                 if empty(dop_r)
                    dop_r=ddk
                 endif
              endif
              skip
           endd
           prfndr=1
           bs_s_r=bs_s_rr
        endif
        nuse('dokkfnd')
        if prfndr=1
           exit
        endif
    next
    if prfndr=1
       exit
    endif
next
retu .t.

