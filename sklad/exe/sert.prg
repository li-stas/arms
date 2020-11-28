#include "common.ch"
#include "inkey.ch"
  // Сертификаты
local vn_r
save scre to scsert
clea
sele 0
use shrift
ptsertr=alltrim(shrift->shr2)   // SERT\   (D:\SERT local)
ptacdr=alltrim(shrift->shr3)    // acdsee  (C:\.... local)
ptbir=alltrim(shrift->path_bi)  // IN BAT  (J:\budinf\sert\in\)
ptbor=alltrim(shrift->path_bo)  // OUT BAT (J:\budinf\sert\out\)
use

if empty(ptsertr)
   ptsertr=gcPath_l+'\'+'sert\'
endif
dptsertr=subs(ptsertr,1,len(ptsertr)-1)

//if !empty(ptacdr).and.subs(ptacdr,2,1)=':'
  //   if d irchange(dptsertr)#0  //==-3
  //      dirmake(dptsertr)
  //   endif
  //   d irchange(gcPath_l)
//endif

//dptbir=subs(ptbir,1,len(ptbir)-1)
//if !empty(ptbir)
  //   if d irchange(dptbir)#0  //==-3
  //      dirmake(dptbir)
  //   endif
  //   d irchange(gcPath_l)
//endif

//if !file(ptbor+'sert1.bat')
  //   ffr=fcreate(ptbor+'sert1.bat')
  //   fwrite(ffr,'@echo off '+chr(13)+chr(10))
  //   fwrite(ffr,'cmd /Q /C sert2.bat')
  //   fclose(ffr)
//endif

if !netfile('sert')
   copy file (gcPath_a+'sert.dbf') to (gcPath_e+'sert.dbf')
   netind('sert')
endif
if !netuse('sert')
   nuse()
   wmess('Не удалось открыть SERT',3)
   retu
endif
if !netfile('ukach')
   copy file (gcPath_a+'ukach.dbf') to (gcPath_e+'ukach.dbf')
   netind('ukach')
   endif
if !netuse('ukach')
   nuse()
   wmess('Не удалось открыть UKACH',3)
   retu
endif
netuse('kln')
netuse('knasp')
netuse('tov')
netuse('setup')
locate for ent=gnEnt
if gnEnt#16
   netuse('tovm')
   set orde to tag t5
   go top
   izgr=0
   save scre to scsert
   mess('Ждите,обновление изготовителей '+gcNskl+'...')
   do while !eof()
  //      if izg=3606525
  //      wait
  //      endif
      if int(mntov/10000)=0.or.int(mntov/10000)=1
         skip
         loop
      endif
      if izg=0
         sele tovm
         skip
         loop
      endif
      if izgr#izg
         izgr=izg
         kkl1r=getfield('t1','izgr','kln','kkl1')
         mntovr=mntov
         sklr=skl
         if getfield('t5','sklr,mntovr','tov','ktl')=0
            sele tovm
            skip
            loop
         endif
         sele sert
         set orde to tag t5
         if !netseek('t5','izgr,0')
            netadd()
            netrepl('izg,kkl1','izgr,kkl1r')
         endif
         skip
         if izg#izgr.or.eof()
  //            sele setup
            sele cntcm
            reclock()
            if ksert=0
               ksertr=1
               netrepl('ksert','2')
            else
               ksertr=ksert
               netrepl('ksert','ksert+1')
            endif
            sele sert
            netadd()
            netrepl('ksert,izg,kkl1','ksertr,izgr,kkl1r')
         endif
  //      if !empty(ptacdr).and.subs(ptacdr,2,1)=':'
  //         if d irchange(ptsertr+alltrim(str(izgr,7)))#0 //==-3
  //            d irmake(ptsertr+alltrim(str(izgr,7)))
  //         endif
  //         d irchange(gcPath_l)
  //      endif
         sele ukach
         if !netseek('t3','0,izgr')
  //            sele setup
            sele cntcm
            reclock()
            if kukach=0
               kukachr=1
               netrepl('kukach','2')
            else
               kukachr=kukach
               netrepl('kukach','kukach+1')
            endif
            sele ukach
            netadd()
            netrepl('kukach,izg','kukachr,izgr')
         endif
      else
         sele tovm
         skip
         loop
      endif
      sele tovm
      skip
   enddo
   nuse('tovm')
   rest scre from scsert
   sele ukach
   go top
   do while !eof()
      if izg=0
         ksertr=ksert
         izgr=getfield('t1','ksertr','sert','izg')
         sele ukach
         netrepl('izg','izgr')
      endif
      skip
   endd
   sele sert
   go top
   do while !eof()
      izgr=izg
      kkl1r=getfield('t1','izgr','kln','kkl1')
      if kkl1r=0
         kkl1r=izgr
      endif
      sele sert
      if kkl1#kkl1r
         netrepl('kkl1','kkl1r')
      endif
      skip
   endd
   set orde to tag t3
   go top
else // gnEnt=16
  //   pathr=gcPath_m+'budinf\'
  //   netuse('sert','sertb',,1)
  //   netuse('ukach','ukachb',,1)
  //   sele sert
  //   set orde to tag t1
  //   sele sertb
  //   ?'Сертификаты'
  //   do while !eof()
  //      ksertr=ksert
  //      sele sert
  //      if !netseek('t1','ksertr')
  //         sele sertb
  //         arec:={}
  //         getrec()
  //         sele sert
  //         netadd()
  //         putrec()
  //         ?str(ksertr,6)
  //      endif
  //      sele sertb
  //      skip
  //   endd
  //   sele ukach
  //   set orde to tag t1
  //   sele ukachb
  //   ?'Качественные'
  //   do while !eof()
  //      ksertr=ksert
  //      kukachr=kukach
  //      sele ukach
  //      if !netseek('t1','ksertr,kukachr')
  //         sele ukachb
  //         arec:={}
  //         getrec()
  //         sele ukach
  //         netadd()
  //         putrec()
  //         ?str(ksertr,6)+' '+str(kukachr,6)
  //      endif
  //      sele ukachb
  //      skip
  //   endd
  //   nuse('sertb')
  //   nuse('ukachb')
  //   sele setup
  //   locate for ent=13
  //   ksertr=ksert
  //   kukachr=kukach
  //   locate for ent=16
  //   netrepl('ksert,kukach','ksertr,kukachr')
  //   sele sert
  //   set orde to tag t3
  //   go top
endif
clea
for_r='.t.'
forr=for_r
do while .t.
   sele sert
   foot('DEL,F3,F4,F5,F6,ENTER','Удалить,Поиск,Корр,Печать,Скан,Кач.удост.')
  //   set cent off
   rcsertr=slcf('sert',1,1,18,,"e:izg h:'Код' c:n(7) e:getfield('t1','sert->izg','kln','nkl') h:'Изготовитель' c:c(20) e:ksert h:'Код' c:n(6) e:nsert h:'Сертификат' c:c(20) e:dt1 h:'Дата Нач' c:d(10) e:dt2 h:'Дата Окон' c:d(10)",,,1,,forr,,'СЕРТИФИКАТЫ')
  //   rcsertr=slcf('sert',1,1,18,,"e:kkl1 h:'Код' c:n(8) e:getfield('t1','sert->izg','kln','nkl') h:'Изготовитель' c:c(20) e:ksert h:'Код' c:n(6) e:nsert h:'Сертификат' c:c(20) e:dt1 h:'Дата Нач' c:d(10) e:dt2 h:'Дата Окон' c:d(10)",,,1,,,,'СЕРТИФИКАТЫ')
  //   set cent on
   go rcsertr
   ksertr=ksert
   kukachr=0
   postr=post
   izgr=izg
   kkl1r=kkl1
   nsertr=nsert
   nprodr=nprod
   dt1sertr=dt1
   dt2sertr=dt2
   psr=ps
   npostr=getfield('t1','postr','kln','nkl')
   nizgr=getfield('t1','izgr','kln','nkl')
   kkl1r=kkl1
   konr=space(10)
   store 0 to ksert_rr,kukach_rr
   kkl_rr=0
   do case
      case lastkey()=K_ESC
           exit
      case lastkey()=K_DEL.and.ksertr#0  // Удалить
           sele ukach
           if netseek('t1','ksertr')
              do while ksert=ksertr
                 netdel()
                 skip
              endd
           endif
           sele sert
           netdel()
           skip -1
      case lastkey()=K_F3
           clprnr=setcolor('gr+/b,n/bg')
           wprnr=wopen(10,30,15,52)
           wbox(1)
           @ 0,1 say 'Код 7зн   ' get kkl_rr pict '9999999'
           @ 1,1 say 'Контекст  ' get konr
           @ 2,1 say 'Сертификат' get ksert_rr
           @ 3,1 say 'Кач. уд.  ' get kukach_rr
           read
           wclose(wprnr)
           if lastkey()=K_ESC
              loop
           endif
           if kkl_rr#0
              sele sert
              if !netseek('t3','kkl_rr')
                 go rcsertr
              endif
              forr=for_r
           else
              if !empty(konr)
                 konr=alltrim(konr)
                 forr=for_r+".and.at(konr,getfield('t1','sert->izg','kln','nkl'))#0"
              else
                 forr=for_r
              endif
              sele sert
              go top
           endif
           if ksert_rr#0
              forr=for_r+".and.ksert=ksert_rr"
           else
              forr=for_r
           endif
           if kukach_rr#0
              izg_rr=getfield('t2','kukach_rr','ukach','izg')
              ksert_rr=getfield('t2','kukach_rr','ukach','ksert')
              sele sert
              if ksert_rr#0
                 if !netseek('t1','ksert_rr')
                    go rcsertr
                 endif
                 forr=for_r
              else
                 if !netseek('t5','izg_rr,0')
                    go rcsertr
                 endif
                 forr=for_r
              endif
           endif
      case lastkey()=K_F4.and.ksertr#0 // Коррекция
           sertins()
      case lastkey()=K_F5 // Печать
           prscanr=0
           do while .t.
              if file(ptbor+'nsert.dbf')
                 wmess('Ждите,идет печать',5)
                 if lastkey()=K_ESC
                    exit
                 endif
              else
                 prscanr=1
                 exit
              endif
           endd
           if prscanr=0
              loop
           endif
           kolekzr=1
           clprnr=setcolor('gr+/b,n/bg')
           wprnr=wopen(10,32,12,48)
           wbox(1)
           @ 0,1 say 'Кол.экз.' get kolekzr pict '99'
           read
           wclose(wprnr)
           if lastkey()=K_ESC
              loop
           endif
           if !file(ptbor+'nsert.dbf')
              crtt(ptbor+'nsert','f:izg c:n(7) f:ksert c:n(6) f:kukach c:n(6) f:tp c:n(1) f:kolekz c:n(2) f:sp c:n(1) f:dtukach c:d(10)')
           endif
           sele 0
           use (ptbor+'nsert') excl
           zap
           netadd()
           netrepl('izg,ksert,kukach,tp,sp,kolekz','izgr,ksertr,kukachr,1,2,kolekzr')
           use
           dirchange(gcPath_l)
      case lastkey()=K_F6 // Сканировать
           prscanr=0
           do while .t.
              if file(ptbor+'nsert.dbf')
                 wmess('Закончите предыдущее сканирование',5)
                 if lastkey()=K_ESC
                    exit
                 endif
              else
                 prscanr=1
                 exit
              endif
           endd
           if prscanr=0
              loop
           endif
           if !file(ptbor+'nsert.dbf')
              crtt(ptbor+'nsert','f:izg c:n(7) f:ksert c:n(6) f:kukach c:n(6) f:tp c:n(1) f:kolekz c:n(2) f:sp c:n(1) f:dtukach c:d(10)')
           endif
           sele 0
           use (ptbor+'nsert') excl
           zap
           netadd()
           netrepl('izg,ksert,kukach,tp,sp','izgr,ksertr,kukachr,1,1')
           use
           dirchange(gcPath_l)
      case lastkey()=K_ENTER // Качественные удостоверения
           ukach()
   endc
endd
nuse()
rest screen from scsert

func sertins()
clsertr=setcolor('gr+/b,n/bg')
wsertr=wopen(10,9,18,71)
wbox(1)
do while .t.
   vn_r=1
   @ 0, 1 say 'Код сертификата '+str(ksertr,6)
   @ 1, 1 say 'Сертификат выдан' get postr pict '9999999'
   @ 1,26 say npostr
   @ 2,1  say 'Изготовитель    '+' '+str(izgr,7)+' '+str(kkl1r,8)
  //   @ 2,26 say nizgr
   @ 2,34 say nizgr
   @ 3,1 say 'Сертификат      ' get nsertr
   @ 4,1 say 'Прод' get nprodr
   @ 5,1 say 'Период          ' get dt1sertr
   @ 5,col()+1 get dt2sertr
   @ 6,36 prom 'Изменить'
   @ 6,col()+1 prom 'Добавить'
   read
   if lastkey()=K_ESC
      exit
   endif
   menu to vn_r
   if lastkey()=K_ESC
      exit
   endif
   nsertr=upper(alltrim(nsertr))
   if vn_r=1 // Изменить
      sele sert
      netrepl('post,izg,nsert,nprod,dt1,dt2','postr,izgr,nsertr,nprodr,dt1sertr,dt2sertr')
   else  // Добавить
      sele sert
      if !netseek('t4','nsertr')
  //         sele setup
         sele cntcm
         reclock()
         if ksert=0
            ksertr=1
            netrepl('ksert','2')
         else
            ksertr=ksert
            netrepl('ksert','ksert+1')
         endif
         sele sert
         netadd()
         netrepl('ksert,post,izg,nsert,nprod,dt1,dt2','ksertr,postr,izgr,nsertr,nprodr,dt1sertr,dt2sertr')
      endif
   endif
   exit
endd
wclose(wsertr)
setcolor(clsertr)
retu

func ukach
sele ukach
set orde to tag t5
netseek('t5','ksertr,izgr')
do while .t.
   foot('','')
   foot('INS,DEL,F4,F5,F6','Добавить,Удалить,Коррекция,Печать,Сканировать')
   rckachr=slcf('ukach',,,,,"e:kukach h:'Код уд' c:n(6) e:nukach h:'Наименование' c:c(60) e:dtukach h:'Дата уд.' c:d(10)",,,1,'ksert=ksertr','izg=izgr',,nsertr)
   go rckachr
   kukachr=kukach
   dtukachr=dtukach
   nukachr=nukach
   do case
      case lastkey()=K_ESC
           exit
      case lastkey()=K_INS // Добавить
           ukachins(0)
      case lastkey()=K_DEL  // Удалить
           sele ukach
           if netseek('t1','ksertr,kukachr')
              netdel()
              skip -1
           endif
      case lastkey()=K_F4 // Коррекция
           ukachins(1)
      case lastkey()=K_F5 // Печать
           prscanr=0
           do while .t.
              if file(ptbor+'nsert.dbf')
                 wmess('Закончите предыдущее сканирование',5)
                 if lastkey()=K_ESC
                    exit
                 endif
              else
                 prscanr=1
                 exit
              endif
           endd
           if prscanr=0
              loop
           endif
           kolekzr=1
           clprnr=setcolor('gr+/b,n/bg')
           wprnr=wopen(10,32,12,48)
           wbox(1)
           @ 0,1 say 'Кол.экз.' get kolekzr pict '99'
           read
           wclose(wprnr)
           if lastkey()=K_ESC
              loop
           endif
           if !file(ptbor+'nsert.dbf')
              crtt(ptbor+'nsert','f:izg c:n(7) f:ksert c:n(6) f:kukach c:n(6) f:tp c:n(1) f:kolekz c:n(2) f:sp c:n(1) f:dtukach c:d(10)')
           endif
           sele 0
           use (ptbor+'nsert') excl
           zap
           netadd()
           netrepl('izg,ksert,kukach,tp,sp,kolekz,dtukach','izgr,ksertr,kukachr,2,2,kolekzr,dtukachr')
           use
           dirchange(gcPath_l)
      case lastkey()=K_F6 // Сканировать
           prscanr=0
           do while .t.
              if file(ptbor+'nsert.dbf')
                 wmess('Закончите предыдущее сканирование',5)
                 if lastkey()=K_ESC
                    exit
                 endif
              else
                 prscanr=1
                 exit
              endif
           endd
           if prscanr=0
              loop
           endif
           if !file(ptbor+'nsert.dbf')
              crtt(ptbor+'nsert','f:izg c:n(7) f:ksert c:n(6) f:kukach c:n(6) f:tp c:n(1) f:kolekz c:n(2) f:sp c:n(1) f:dtukach c:d(10)')
           endif
           sele 0
           use (ptbor+'nsert') excl
           zap
           netadd()
           netrepl('izg,ksert,kukach,tp,sp','izgr,ksertr,kukachr,2,1')
           use
           dirchange(gcPath_l)
   endc
enddo
sele ukach
retu

func ukachins(p1)
cor_r=p1
if cor_r=0
   kukachr=0
   dtukachr=ctod('')
   nukachr=space(60)
endif
clukachr=setcolor('gr+/b,n/bg')
wukachr=wopen(10,9,15,71)
wbox(1)
do while .t.
   if cor_r=1
      @ 0,1 say 'Код уд.качества '+str(kukachr,6)
   else
      @ 0,1 say 'Код уд.качества ' get kukachr pict '999999'
      read
      if lastkey()=K_ESC
         exit
      endif
   endif
   sele ukach
   if !netseek('t2','kukachr')
      kukachr=0
   else
      dtukachr=dtukach
      nukachr=nukach
   endif
   if kukachr=0.or.cor_r=1
      @ 1,1 say 'Дата            ' get dtukachr
      @ 2,1 say 'Наим' get nukachr
      read
   else
      @ 1,1 say 'Дата            '+' '+dtoc(dtukachr)
      @ 2,1 say 'Наим'+' '+nukachr
   endif
   uvnr=1
   @ 3,1 prom 'Верно'
   @ 3,col()+1 prom 'НЕ Верно'
   menu to uvnr
   do case
      case lastkey()=K_ESC
           exit
      case uvnr=2
           loop
      case uvnr=1
           sele ukach
           if cor_r=0
              if kukachr=0
  //                 sele setup
                 sele cntcm
                 reclock()
                 if kukach=0
                    kukachr=1
                 else
                    kukachr=kukach
                 endif
                 netrepl('kukach','kukachr+1')
                 sele ukach
                 netadd()
                 netrepl('ksert,kukach,dtukach,nukach,izg',;
                         'ksertr,kukachr,dtukachr,nukachr,izgr')
              else
                 sele ukach
                 if !netseek('t3','ksertr,izgr,kukachr')
                    netadd()
                    netrepl('ksert,izg,kukach,dtukach,nukach',;
                            'ksertr,izgr,kukachr,dtukachr,nukachr')
                 else
                    wmess('Такое удостоверение уже существует',1)
                 endif
              endif
           else
              netrepl('dtukach,nukach','dtukachr,nukachr')
           endif
           exit
   endc
endd
wclose(wukachr)
setcolor(clukachr)
retu
