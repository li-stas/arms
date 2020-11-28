#include "common.ch"
#include "inkey.ch"
  //Справочник TOV
netuse('tov')
netuse('sert')
netuse('ukach')
cntr=0
sele tov
set orde to tag t5
if !netseek('t5','sklr,mntovr')
   go top
endif
rctovr=recn()
prvid_r=2
nsklr=''
if gnMskl=1
   nsklr=alltrim(getfield('t1','sklr','kln','nkle'))
endif
prF1r=0
do while .t.
   if prF1r=0
      foot('F2,F4,F5,F9,F10','ВидFO,Просмотр,Вид,Приход,Расход')
   else
      foota('F4,F8,F9,F10','Ост на нач,ПСортВсе,ПСортПод,ПСорт!Под')
   endif
   sele tov
   set order to tag t5
   go rctovr
   set cent off
   if prvid_r=1
      rctovr=slcf('tov',1,0,8,,"e:ktl h:'Код' c:n(9) e:ksert h:'Код Сф' c:n(6) e:getfield('t1','tov->ksert','sert','nsert') h:'Сертификат' c:c(20) e:kukach h:'Кач.уд' c:n(6) e:getfield('t2','tov->kukach','ukach','dtukach') h:'Дата К' c:d(8) e:dizg h:'Изготов' c:d(8) e:drlz h:'Реализ' c:d(8) e:prmn h:'Приход' c:n(6)",;
                ,,1,'skl=sklr.and.mntov=mntovr',,,str(mntovr,7)+' '+alltrim(natr)+' '+nsklr)
   else
      if tovmvidr=1
         if gnKt=1
            rctovr=slcf('tov',1,0,8,,"e:ktl h:'Код' c:n(9) e:nei h:'Изм' c:c(3) e:opt h:'Цена уч' c:n(8,3) e:osn h:'Ост.нач.' c:n(9,2) e:osv h:'Ост.вып.' c:n(9,2) e:osf h:'Ост.факт' c:n(9,2) e:skkt h:'SkК' c:n(3) e:ttnkt h:'TTН Kт' c:n(6) e:dtkt h:'ДатаК' c:d(8) e:mnkt h:'ПрихКт' c:n(6)",;
                           ,,1,'skl=sklr.and.mntov=mntovr',,,str(mntovr,7)+' '+alltrim(natr)+' '+nsklr)
         else
            if prjfr=0
               rctovr=slcf('tov',1,0,8,,"e:ktl h:'Код' c:n(9) e:nei h:'Изм' c:c(3) e:opt h:'Цена уч' c:n(8,3) e:cenpr h:'Цена Пр' c:n(8,3) e:osn h:'Ост.нач.' c:n(9,2) e:osv h:'Ост.вып.' c:n(9,2) e:osf h:'Ост.факт' c:n(9,2) e:osvo h:'Ост.ОТВ.' c:n(9,3) e:(cenpr/opt-tsz60-1)*100 h:'Нац' c:n(6,2)",;
                              ,,1,'skl=sklr.and.mntov=mntovr',,,str(mntovr,7)+' '+alltrim(natr)+' '+nsklr)
            else
               rctovr=slcf('tov',1,0,8,,"e:ktl h:'Код' c:n(9) e:nei h:'Изм' c:c(3) e:opt h:'Цена уч' c:n(8,3) e:cenpr h:'Цена Пр' c:n(8,3) e:osn h:'Ост.нач.' c:n(9,2) e:osv h:'Ост.вып.' c:n(9,2) e:iif(tov->otv=0,osf,getfield('t1','skljfr,tov->ktl','tovj','osf')) h:'Ост.факт' c:n(9,2) e:osvo h:'Ост.ОТВ.' c:n(9,3) e:(cenpr/opt-tsz60-1)*100 h:'Нац' c:n(6,2)",;
                              ,,1,'skl=sklr.and.mntov=mntovr',,,str(mntovr,7)+' '+alltrim(natr)+' '+nsklr)
            endif
         endif
      else
         rctovr=slcf('tov',1,0,8,,"e:ktl h:'Код' c:n(9) e:nei h:'Изм' c:c(3) e:opt h:'Цена уч' c:n(8,3) e:cenpr h:'Цена Пр' c:n(8,3) e:osn h:'Ост.нач.' c:n(9,2) e:osv h:'Ост.вып.' c:n(9,2) e:osfo h:'Ост.отгр' c:n(9,2) e:osvo h:'Ост.ОТВ.' c:n(9,3) e:(cenpr/opt-tsz60-1)*100 h:'Нац' c:n(6,2)",;
                           ,,1,'skl=sklr.and.mntov=mntovr',,,str(mntovr,7)+' '+alltrim(natr)+' '+nsklr)
      endif
   endif
   set cent on
   sele tov
   go rctovr
   ktlr=ktl
   sklr=skl
   mntovr=mntov
   kg_r=int(ktlr/1000000)
   do case
      case lastkey()=K_ESC
           exit
      case lastkey()=K_F1 // F1
           if prF1r=0
              prF1r=1
           else
              prF1r=0
           endif
      case lastkey()=K_F2
           if tovmvidr=1
              tovmvidr=2
           else
              tovmvidr=1
           endif
      case lastkey()=K_F4
           if gnAdm=0
              if gnArnd#0.or.gnCenp=1
                 tovins(1, 'tov')
              else
                 tovins(2, 'tov')
              endif
           else
              tovins(1, 'tov')
           endif
           sele tov
           go rctovr
//      case lastkey()=K_ALT_F4 .and.gnTpstPok=2.and.bom(gdTd)=ctod('01.09.2007').and.gnEnt=21 // Ост на нач
//      case lastkey()=K_ALT_F4 .and.gnTpstPok#0.and.bom(gdTd)=bom(gdNPrd).and.(gnEnt=21.or.gnEnt=20) // Ост на нач
      case lastkey()=K_ALT_F4 .and. bom(gdTd)=bom(gdNPrd).and.(gnEnt=21.or.gnEnt=20) // Ост на нач
           store osn to osnr,osn_r
           cltt=setcolor('gr+/b,n/bg')
           wtt=wopen(10,20,12,50)
           wbox(1)
           @ 0,1 say 'Ост на нач' get osnr pict '99999999.999'
           read
           wclose(wtt)
           setcolor(cltt)
           if lastkey()=K_ESC
             loop
           endif
           sele tov
           netrepl('osn','osn-osn_r+osnr')
           if gnCtov=1
              sele tovm
              if netseek('t1','sklr,mntovr')
                 netrepl('osn','osn-osn_r+osnr')
              endif
              sele tov
           endif
      case lastkey()=K_F5
           if prvid_r=1
              prvid_r=2
           else
              prvid_r=1
           endif
      case lastkey()=K_F9 // Приход
           tov_r='tov'
           pr1ktl()
      case lastkey()=K_F10 // Расход
           tov_r='tov'
           rs1ktl()
      case lastkey()=K_ALT_F8 // ВСЕ пересчет красного остатка
        PSort(sklr,mntovr)
      case lastkey()=K_ALT_F9 //  ПОДВЕРЖ PRZ=1 (П) пересчет красного остатка
        PSort(sklr,mntovr,3)
      case lastkey()=K_ALT_F10 //  НЕ ПОДВЕРЖ PRZ=0 (П) пересчет красного остатка
        PSort(sklr,mntovr,2)
      case lastkey()=K_ALT_F3 //
        If RLock()
          Browse()
        EndIf
        dbrunLock(RecNo())
   endcase
enddo

