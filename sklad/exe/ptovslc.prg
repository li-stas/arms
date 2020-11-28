#include "common.ch"
#include "inkey.ch"
  // Отбор товара из TOV в приходе
local rcn_rr
rcn_rr=0
save scre to sctovslc
oclr1=setcolor('w+/b')
if select('sl')=0
   sele 0
   use _slct alias sl excl
   zap
endif
if gnEnt=20.and.gnSk=239
   sele cskl
   locate for sk=236
   pathr=gcPath_d+alltrim(path)
   netuse('tov','tovpok','',1)
   set orde to tag t1
   go top
endif
sele pr2
if netseek('t1','mnr')
   set orde to tag t1
   do while mn=mnr
      ktl_r=ktl
      sele tov
      if netseek('t1','sklr,ktl_r')
         rcn_rr=recn()
      endif
      sele sl
      appe blank
      repl kod with str(ktl_r,9),kol with rcn_rr
      sele pr2
      skip
   enddo
endif
sele tov
set orde to tag t2
go top
ktlr=ktl
do while .t.
   if gnCtov=1
      if indexord()=2
         foot('SPACE,F4,F5,F6,F8,ESC','Отбор,Просм,Отдел,Изгот,Группа,Закон.')
      else
         foot('SPACE,F4,F5,F6,F8,ESC','Отбор,Просм,Отдел,Норм,Группа,Закон.')
      endif
   else
      if indexord()=2
         foot('SPACE,INS,F4,F5,F6,F8,ESC','Отбор,Доб,Просм,Отдел,Изгот,Группа,Закон.')
      else
         foot('SPACE,INS,F4,F5,F6,F8,ESC','Отбор,Доб,Просм,Отдел,Норм,Группа,Закон.')
      endif
   endif
   rcn_r=recn()
   if gnOt=0
      tovskpr='skl=sklr.and.opt#0'
  //      tovskpr='skl=sklr'
   else
      tovskpr='skl=sklr.and.ot=gnOt.and.opt#0'
  //      tovskpr='skl=sklr.and.ot=gnOt'
   endif
   if gnSkotv#0 //gnOtv=1
  //      tovskpr=tovskpr+'.and.post=gnKklm'
      tovskpr=tovskpr+'.and.post=kpsr'
   endif
   if NdOtvr=4
      tovskpr=tovskpr+'.and.otv=1.and.post=kpsr.and.osvo#0'
   else
      tovskpr=tovskpr+'.and.otv=0'
   endif
   if gnCtov=1
      if gnRoz=0
         if gnEnt=20.and.gnSk=239
            ktlr=slcf('tov',7,1,12,,"e:ktl h:'Код' c:n(9) e:nat h:'Наименование' c:c(33) e:upak_s() h:'Упк' c:c(4) e:nei h:'Изм' c:c(3) e:iif(opt=0,'',' ') h:'0' c:c(1) e:&coptr h:'Зак.цена' c:n(7,3) e:osf h:'Ост.Ф' c:n(5,0) e:getfield('t1','kpsr,tov->ktl','tovpok','osf') h:'Ост.П' c:n(4,0)",'ktl',1,1,,tovskpr,'g/n,n/g','Справочник склада по партиям')
         else
            if NdOtvr=4
               ktlr=slcf('tov',7,1,12,,"e:ktl h:'Код' c:n(9) e:nat h:'Наименование' c:c(33) e:upak_s() h:'Упк' c:c(4) e:nei h:'Изм' c:c(3) e:iif(opt=0,'',' ') h:'0' c:c(1) e:&coptr h:'Зак.цена' c:n(7,3) e:osvo h:'Ост.ОтвХр' c:n(9,3)",'ktl',1,1,,tovskpr,'g/n,n/g','Справочник склада по партиям')
            else
               If gnSk=238 .and. SkVzr=234
                 // поключить партии возвратного склада
                 cPthSkVz:=alltrim(getfield('t1','skvzr','cskl','path'))
                 pathr=gcPath_e + pathYYYYMM(gdTd)+ '\' + cPthSkVz

                 tovskpr:=NIL

                  netuse('tov','TovVz',,1)
                  set orde to tag t5
                  if netseek('t5','KPsr')
                    ktlr=slcf('TovVz',7,1,12,,"e:ktl h:'Код' c:n(9) e:nat h:'Наименование' c:c(33) e:upak_s() h:'Упк' c:c(4) e:nei h:'Изм' c:c(3) e:iif(opt=0,'',' ') h:'0' c:c(1) e:&coptr h:'Зак.цена' c:n(7,3) e:osf h:'Ост.Ф' c:n(9,3)",'ktl',1,1,;
                    {|| skl = KPsr},;
                    tovskpr,'g/n,n/g','Справочник склада по партиям '+str(KPsr,7))

                     arec:={}; getrec()
                  else
                    // нет данных
                    ktlr=slcf('tov',7,1,12,,"e:ktl h:'Код' c:n(9) e:nat h:'Наименование' c:c(33) e:upak_s() h:'Упк' c:c(4) e:nei h:'Изм' c:c(3) e:iif(opt=0,'',' ') h:'0' c:c(1) e:&coptr h:'Зак.цена' c:n(7,3) e:osf h:'Ост.Ф' c:n(9,3)",'ktl',1,1,,tovskpr,'g/n,n/g','Справочник склада по партиям')
                  endif

                 nuse('TovVz')
               Else
                 ktlr=slcf('tov',7,1,12,,"e:ktl h:'Код' c:n(9) e:nat h:'Наименование' c:c(33) e:upak_s() h:'Упк' c:c(4) e:nei h:'Изм' c:c(3) e:iif(opt=0,'',' ') h:'0' c:c(1) e:&coptr h:'Зак.цена' c:n(7,3) e:osf h:'Ост.Ф' c:n(9,3)",'ktl',1,1,,tovskpr,'g/n,n/g','Справочник склада по партиям')
               EndIf
            endif
         endif
      else
         ktlr=slcf('tov',7,1,12,,"e:ktl h:'Код' c:n(9) e:nat h:'Наименование' c:c(35) e:upak_s() h:'Упк' c:c(4) e:nei h:'Изм' c:c(3) e:&coptr h:'Зак.цена' c:n(7,3) e:getfield('t1','tov->mntov','ctov',cboptr) h:'Отп.цена' c:n(9,3)",'ktl',1,1,,tovskpr,'g/n,n/g','Справочник склада по партиям')
      endif
   else
         ktlr=slcf('tov',7,1,12,,"e:ktl h:'Код' c:n(9) e:zv() h:'Д' c:c(2) e:nat h:'Наименование' c:c(32) e:upak_s() h:'Упк' c:c(4) e:nei h:'Изм' c:c(3) e:&coptr h:'Зак.цена' c:n(9,3) e:osf h:'Ост.Ф' c:n(9,3)",'ktl',1,1,,tovskpr,'g/n,n/g','Справочник склада по партиям')
   endif

   sele tov
   netseek('t1','sklr,ktlr')
   tovrcnr=recn()
   izgrr=izg
   natr=nat
   if gnCtov=1
      mntovr=mntov
      kg_r=int(mntovr/10000)
   else
      mntovr=ktlr
      kg_r=int(mntovr/1000000)
   endif
   ktlpr=0
   sele sgrp
   if netseek('t1','kg_r')
      grmr=mark
   endif
   if gnCtov=2.or.gnCtov=3
      cntr=1
   else
      cntr=0
   endif
   sele tov
   exxr=0
   do case
      case lastkey()=K_SPACE // Отбор
           if gnCtov=1
  //              obncen(mntovr)
           endif
  //           pr2kvp(1)
           pr2kvp(0)
           pere(1)
      case lastkey()=K_INS.and.gnEntRm=0 // Добавить
        do case
        case gnCtov=0
          tovins(0, 'tov')
        case gnCtov=1
          if gnVo=9 .or. str(gnSk,3)$'263;705' // склад 169
            ptovslcc()
          else
            wmess('Только от поставщика',2)
            loop
          endif
        case gnCtov=2
          ptovslcd()
        case gnCtov=3
          ptovslc3()
        endcase
        sele tov
        if lastkey()=K_ESC
          go tovrcnr
        else
          if !netseek('t1','sklr,ktlr')
              go tovrcnr
          else
              tovrcnr=recn()
          endif
        endif
      case lastkey()=K_F4 // Коррекция/Просмотр
           if gnCtov#1    //.and.gnAdm=1
              do case
                 case gnCtov=0.or.gnCtov=2
                      tovins(1, 'tov')
                 case gnCtov=3
                      tovins(2, 'tov')
              endc
           else
  //              obncen(mntovr)
              if gnKart#0 .or. gnAdm=1
                 tovins(1, 'tov')
              else
                 tovins(2, 'tov')
              endif
           endif
      case lastkey()=K_F5 // Отдел
           sele cskle
           if netseek('t1','gnSk')
              gnOt=slcf('cskle',,,,,"e:ot h:'От' c:n(2) e:nai h:'Наименование' c:c(20)",'ot',0,,'sk=gnSk')
              if netseek('t1','gnSk,gnOt')
                 gcNot=nai
                 @ 1,60 say gcNot color 'gr+/n'
              endif
           endif
           sele tov
           go top
           loop
      case lastkey()=K_F8 // Группа
           foot('','')
           sele sgrp
           set orde to tag t2
           go top
           rcn_gr=recn()
           do while .t.
              sele sgrp
              set orde to tag t2
              rcn_gr=recn()
              kg_r=slcf('sgrp',,,,,"e:kgr h:'Код' c:n(3) e:ngr h:'Наименование' c:c(20)",'kgr',,1)
              sele sgrp
              do case
                 case lastkey()=K_ENTER
                      sele tov
                      if !netseek('t2','sklr,kg_r')
                         if gnMskl=1.and.gnCtov#3
                            sele sGrpE
                            if !netseek('t1','sklr,kg_r')
                               netadd()
                               netrepl('skl,kg,ktl','sklr,kg_r,kg_r*1000000+2')
                               ktlr=kg_r*1000000+1
                            else
                               reclock()
                               ktlr=ktl
                               netrepl('ktl','ktl+1')
                            endif
                         else
                            sele sgrp
                            netseek('t1','kg_r')
                            reclock()
                            ktlr=ktl
                            netrepl('ktl','ktl+1')
                         endif
                         sele tov
                         netadd()
                         netrepl('skl,kg,ktl','sklr,kg_r,ktlr')
                         tovrcnr=recn()
                      endif
                      exit
                 case lastkey()=K_ESC
                      exit
                 case lastkey()>32.and.lastkey()<255
                 //case lastkey()>=65.and.lastkey()<=90.or.lastkey()>=97.and.lastkey()<=122.or.lastkey()>=128.and.lastkey()<=175.or.lastkey()>=224.and.lastkey()<=239
                      sele sgrp
                      lstkr=upper(chr(lastkey()))
                      if !netseek('t2','lstkr')
                         go rcn_gr
                      endif
                      loop
                 othe
                      loop
              endc
           endd
           sele tov
           loop
      case lastkey()=K_F6
           if indexord()=4
              set order to tag t2
              foot('SPACE,INS,F4,F5,F6,F8,ESC','Отбор,Доб,Просм,Отдел,Изгот,Группа,Закон.')
           else
              set order to tag t4
              foot('SPACE,INS,F4,F5,F6,F8,ESC','Отбор,Доб,Просм,Отдел,Норм,Группа,Закон.')
           endif
           loop
      case lastkey()=K_ESC //
           exit
      case lastkey()>32.and.lastkey()<255
      //case lastkey()>=65.and.lastkey()<=90.or.lastkey()>=97.and.lastkey()<=122.or.lastkey()>=128.and.lastkey()<=175.or.lastkey()>=224.and.lastkey()<=239
           sele tov
           lstkr=upper(chr(lastkey()))
           if !netseek('t2','sklr,int(ktlr/1000000),lstkr')
              go rcn_r
           endif
   othe
      loop
   endc
enddo
nuse('tovpok')
setcolor(oclr1)
rest scre from sctovslc

func zv()
do case
   case gnCtov=0
        if month(dpo)=month(gdTd).and.year(dpo)=year(gdTd).or.osn#0;
           .or.month(dpp)=month(gdTd).and.year(dpp)=year(gdTd)
            retu ' *'
        else
             retu ' '
        endif
   case gnCtov=1
        retu str(getfield('t1','tov->mntov','ctov','cnt'),2)
   othe
        retu ' *'
endc
**************
func osfpok()
**************
retu getfield('t1','kpsr,tov->ktl','tovpok','osf')
