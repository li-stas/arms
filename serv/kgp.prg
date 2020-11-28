#include "inkey.ch"
* Грузополучатели
clea
netuse('kobl')
netuse('kfs')
netuse('opfh')
netuse('knasp')
netuse('kgos')
netuse('kulc')
netuse('krn')
netuse('banks')
netuse('atvm')
netuse('atvme')
netuse('kgpcat')
netuse('mkeep')
netuse('KgpPst')
netuse('pstgpl')
netuse('kgp')
netuse('KgpTm')
netuse('kln')
netuse('kgpnet')
netuse('cskl')

kpsr=2243000

store 0 to wwr
store 0 to kgp_r,krn_r,knasp_r,kgpcat_r,rm_r,bza_r,knet_r
store space(20) to ngp_r,adr_r
kgpfor_r=".t." // Грузополучатели
kgpforr=kgpfor_r
sele kgp
go top
rckgpr=recn()
fldnomr=1
footar=0
do while .t.
   sele kgp
   go rckgpr
   if footar=0
      foot('INS,DEL,F3,F4,F5,F6,F9,ENTER','Доб,Уд,Фильтр,Корр,Обн из KLN,Обн в KLN,Обн ТМ,TM')
   else
      foota('F9','Обн TM')
   endif
   if gnEnt=20
      rckgpr=slce('kgp',1,1,18,,"e:kgp h:'Код' c:n(7) e:NGrPol h:'Наименование' c:c(30) e:rm h:'РП' c:n(1) e:getfield('t1','kgp->kgp','kln','adr') h:'Адрес' c:c(40)  e:getfield('t1','kgp->kgpcat','kgpcat','nkgpcat') h:'Категория' c:c(10) e:pri h:'П' c:n(1) e:msk h:'Маска' c:c(7) e:prTT102 h:'JF' c:n(1)",,,1,,kgpforr,,'Грузополучатели')
   else
      rckgpr=slce('kgp',1,1,18,,"e:kgp h:'Код' c:n(7) e:NGrPol h:'Наименование' c:c(30) e:rm h:'РП' c:n(1) e:getfield('t1','kgp->kgp','kln','adr') h:'Адрес' c:c(40)  e:getfield('t1','kgp->kgpcat','kgpcat','nkgpcat') h:'Категория' c:c(10) e:pri h:'П' c:n(1) e:msk h:'Маска' c:c(7)",,,1,,kgpforr,,'Грузополучатели')
   endif
   if lastkey()=K_ESC
      exit
   endif
   sele kgp
   go rckgpr
   dtkgpr=dtkgp
   if fieldpos('dtprp')#0
      dtprpr=dtprp
   else
      dtprpr=ctod('')
   endif
   kgpr=kgp
   ngpr=getfield('t1','kgpr','kln','nkl')
   rmr=rm
   vmrshr=vmrsh
   nvmrshr=getfield('t1','vmrshr','atvm','nvmrsh')
   prir=pri
   kgpcatr=kgpcat
   nkgpcatr=getfield('t1','kgpcatr','kgpcat','nkgpcat')
   if fieldpos('msk')=0
      mskr=space(7)
   else
      mskr=msk
   endif
   mkexclr=mkexcl
   oborr=obor
   topr=top
   primr=prim
   kgppr=kgpp
   NGrPolr=NGrPol
   NTrader=NTrade
   knetr=knet
   nnetr=getfield('t1','knetr','kgpnet','nnet')
   if fieldpos('prTT102')=0
      prTT102r=0
   else
      prTT102r=prTT102
   endif
   knetr=knet
   do case
      case lastkey()=19 // Left
           fldnomr=fldnomr-1
           if fldnomr=0
              fldnomr=1
           endif
      case lastkey()=4 // Right
           fldnomr=fldnomr+1
      case lastkey()=28 // foota
           if footar=0
              footar=1
           else
              footar=0
           endif
      case lastkey()=K_INS.and.gnEntrm=0.and.(gnAdm=1.or.iif(gnEnt=20,gnKto=160.or.gnKto=186.or.gnKto=848,.t.)) // INS
           kgpins()
      case lastkey()=K_F9.and.gnEntrm=0.and.(gnAdm=1.or.iif(gnEnt=20,gnKto=160.or.gnKto=186.or.gnKto=848,.t.)) // Обн ТМ
           KgpTmins()
      case lastkey()=K_DEL.and.gnEntrm=0.and.(gnAdm=1.or.iif(gnEnt=20,gnKto=160.or.gnKto=186.or.gnKto=848,.t.)) // DEL
           sele KgpTm
           set orde to tag t1
           if netseek('t1','kgpr')
              do while kgp=kgpr
                 netdel()
                 skip
              endd
           endif
           sele KgpPst
           if netseek('t1','kgpr,kpsr')
              netdel()
           endif
           sele kgp
           netdel()
           skip -1
           if bof()
              go top
           endif
           rckgpr=recn()
      case lastkey()=K_F3 // Фильтр
           kgpflt()
      case lastkey()=K_F4.and.gnEntrm=0.and.(gnAdm=1.or.iif(gnEnt=20,str(gnKto,3)$'160;782',.t.)) // Коррекция
           kgpins(1)
      case lastkey()=K_F5.and.gnEntrm=0.and.(gnAdm=1.or.iif(gnEnt=20,str(gnKto,3)$'160;782',.t.)) // Обновить из kln
*           kgpobn(1)
      case lastkey()=K_F6.and.gnEntrm=0.and.(gnAdm=1.or.iif(gnEnt=20,str(gnKto,3)$'160;782',.t.)) // Обновить в kln
*            klngobn(1)
      case lastkey()=-33.and.gnEntrm=0 // Коррекция KLN
           fortmpr=kgpforr
           sele kln
           if netseek('t1','kgpr')
              klnins(1)
           endif
           kgpforr=fortmpr
*           sele kgp
*           go top
*           rckgpr=recn()
      case lastkey()=-38 // Обновить
           obkgp()
      case lastkey()=K_ENTER // TM
           sele KgpTm
           set orde to tag t3
           if !netseek('t3','kgpr')
              go top
           endif
           forr=".t..and.getfield('t1','KgpTm->mkeep','mkeep','lv20')=1"
           rcKgpTmr=recn()
           do while .t.
              sele KgpTm
              go rcKgpTmr
              foot('INS,DEL,F4','Доб,Уд,Корр')
              if gnEnt=20
                 rcKgpTmr=slcf('KgpTm',,,,,"e:mkeep h:'Код' c:n(3) e:nmkeep h:'Наименование' c:c(20) e:tcen h:'ТЦ' c:n(2) e:nac h:'Нац' c:n(6,2) e:nac1 h:'Нац1' c:n(6,2)",,,,'kgp=kgpr',forr,,'Торг Марки')
              else
                 rcKgpTmr=slcf('KgpTm',,,,,"e:mkeep h:'Код' c:n(3) e:nmkeep h:'Наименование' c:c(20) e:tcen h:'ТЦ' c:n(2) e:nac h:'Нац' c:n(6,2) e:nac1 h:'Нац1' c:n(6,2)",,,,'kgp=kgpr',,,'Торг Марки')
              endif
              if lastkey()=K_ESC
                 exit
              endif
              sele KgpTm
              go rcKgpTmr
              mkeepr=mkeep
              tcenr=tcen
              nacr=nac
              nac1r=nac1
              do case
                 case lastkey()=K_INS.and.gnEntrm=0.and.(gnAdm=1.or.iif(gnEnt=20,gnKto=160.or.gnKto=186.or.gnKto=848,.t.)) // INS
                      KgpTmins()
                      sele KgpTm
                      if !netseek('t3','kgpr')
                         go top
                      endif
                      rcKgpTmr=recn()
                 case lastkey()=K_F4.and.gnEntrm=0.and.(gnAdm=1.or.iif(gnEnt=20,gnKto=160.or.gnKto=186.or.gnKto=848,.t.)) // INS
                      KgpTmins(1)
                 case lastkey()=K_DEL.and.gnEntrm=0.and.(gnAdm=1.or.iif(gnEnt=20,gnKto=160.or.gnKto=186.or.gnKto=848,.t.)) // DEL
                      netdel()
                      skip -1
                      if bof()
                         go top
                      endif
                      rcKgpTmr=recn()
              endc
           endd
   endc
endd

nuse()



func kgpins(p1)
scbrir=setcolor('gr+/b,n/w')
wbrir=wopen(1,10,21,70)
wbox(1)
if empty(p1)
   kgpr=0
   kgppr=0
   rmr=0
   knetr=0
   store ctod('') to dtprpr,dtkgpr
   NGrPolr=space(40)
   NTrader=space(40)
   nnetr=space(40)
   store 0 to lev1_r,lev2_r,lev3_r
   sndr=0
   prTT102r=0
else
   sele KgpPst
   if netseek('t1','kgpr,kpsr')
      lev1_r=lev1
      lev2_r=lev2
      lev3_r=lev3
      sndr=1
   else
      store 0 to lev1_r,lev2_r,lev3_r
      sndr=0
   endif
endif
do while .t.
   if empty(p1)
      @ 0,1 say 'Код грузополучателя' get kgpr  pict '9999999'
   else
      @ 0,1 say 'Код грузополучателя'+' '+str(kgpr,7)
   endif
   @ 1,1 say 'Регион продаж      ' get rmr pict '9'
   @ 2,1 say 'Рег.маршр.         ' get vmrshr pict '999' valid atvm()
   @ 3,1 say "Приоритет          " GET  prir PICT "9"
   @ 4,1 say "Категория ГП       " GET  kgpcatr PICT "99" valid kgpcat()
   @ 4,25 say nkgpcatr
   @ 5,1 say 'Маска              ' get mskr
   @ 6,1 say 'Запрет на МД       ' get mkexclr
   @ 7,1 say 'Оборудование       ' get oborr
   @ 8,1 say 'TOP 100            ' get topr
   @ 9,1 say 'Примечание         ' get primr
   @ 10,1 say 'Родитель           ' get kgppr pict '9999999'
   @ 11,1 say 'Наименование' get NGrPolr
   @ 12,1 say 'Трейд       ' get NTrader
   @ 13,1 say 'Сеть' get knetr valid knet()
   @ 13,12 say nnetr
   @ 14,1 say 'Дата создания'+' '+dtoc(dtkgpr)
   @ 15,1 say 'Дата переписи' get dtprpr
*   @ 14,1 say 'Сандора     ' get sndr pict '9'
*   @ 15,18 say getfield('t1','kpsr,lev1_r,0,0','pstgpl','nlev1')
*   @ 15,1 say 'Уровень1'+' '+str(lev1_r,4)
*   @ 16,18 say getfield('t1','kpsr,lev1_r,lev2_r,0','pstgpl','nlev2')
*   @ 16,1 say 'Уровень1'+' '+str(lev2_r,4)
*   @ 17,18 say getfield('t1','kpsr,lev1_r,lev2_r,lev3_r','pstgpl','nlev3')
*   @ 17,1 say 'Уровень1'+' '+str(lev3_r,4)
   @ 18,1 say 'Признак торг.точки(Jaffa)' get prTT102r  pict '9'
   read
   if lastkey()=K_ESC
      exit
   endif
*   if sndr#0
*      @ 15,18 say getfield('t1','kpsr,lev1_r,0,0','pstgpl','nlev1')
*      @ 15,1 say 'Уровень1' get lev1_r pict '99999' valid vpstlev(1,15,18,wbrir)
*      @ 16,18 say getfield('t1','kpsr,lev1_r,lev2_r,0','pstgpl','nlev2')
*      @ 16,1 say 'Уровень2' get lev2_r pict '99999' valid vpstlev(2,16,18,wbrir)
*      @ 17,18 say getfield('t1','kpsr,lev1_r,lev2_r,lev3_r','pstgpl','nlev3')
*      @ 17,1 say 'Уровень3' get lev3_r pict '99999' valid vpstlev(3,17,18,wbrir)
*      read
*      if lastkey()=K_ESC
*         exit
*      endif
*   endif
   if lastkey()=K_ENTER
      if kgppr=0
         kgppr=kgpr
      endif
      if empty(p1)
         sele kln
         if !netseek('t1','kgpr')
            wmess('Нет в справочнике клиентов',2)
            loop
         else
            if kkl1#0
               wmess('Это плательщик',2)
               loop
            endif
         endif
         NGrPolr=nkl
         sele kgp
         if netseek('t1','kgpr')
            rckgpr=recn()
         else
            netadd()
            netrepl('kgp,rm,vmrsh,pri,kgpcat','kgpr,rmr,vmrshr,prir,kgpcatr')
            netrepl('dtkgp','date()')
            netrepl('msk','mskr')
            netrepl('mkexcl','mkexclr')
            netrepl('kto,dtkto','gnKto,date()')
            netrepl('obor,top,prim','oborr,topr,primr')
            netrepl('kgpp','kgppr')
            netrepl('NGrPol','NGrPolr')
            netrepl('knet','knetr')
            netrepl('NTrade,nnet','NTrader,nnetr')
            if fieldpos('prTT102')#0
               netrepl('prTT102','prTT102r')
            endif
            if fieldpos('dtprp')#0
               netrepl('dtprp','dtprpr')
            endif
            rckgpr=recn()
         endif
      else
         sele kgp
         netrepl('rm,vmrsh,pri,kgpcat,','rmr,vmrshr,prir,kgpcatr')
         netrepl('msk','mskr')
         netrepl('mkexcl','mkexclr')
         netrepl('obor,top,prim','oborr,topr,primr')
         netrepl('kgpp','kgppr')
         netrepl('NGrPol','NGrPolr')
         netrepl('knet','knetr')
         netrepl('NTrade,nnet','NTrader,nnetr')
         if fieldpos('dtprp')#0
            netrepl('dtprp','dtprpr')
         endif
         if fieldpos('prTT102')#0
            netrepl('prTT102','prTT102r')
         endif
      endif
      if gnEnt=20.and.!empty(NGrPolr)
        sele kln
        if netseek('t1','kgpr')
           netrepl('nkl,nkle','NGrPolr,NGrPolr')
        endif
        // какую цену брать
        sele KgpTm
        if netseek('t1','kgpr,102')
          //
        else
          netadd()
          netrepl('kgp,mkeep','kgpr,102')
        endif
        if prTT102r=1
          netrepl('tcen','0') // '3') 01-09-18 04:17pm ищенко
        else
          netrepl('tcen','0')
        endif

        sele kgp
      endif
      sele KgpPst
      if !netseek('t1','kgpr,kpsr')
         netadd()
         netrepl('post,kgp','kpsr,kgpr')
      endif
      netrepl('lev1,lev2,lev3,kgpcat','lev1_r,lev2_r,lev3_r,kgpcatr')
      exit
   endif
endd
wclose(wbrir)
setcolor(scbrir)
retu .t.
**************
func kgpflt()
**************
scfltr=setcolor('gr+/b,n/w')
wfltr=wopen(7,10,17,70)
wbox(1)
store 0 to kgpr,krnr,knaspr,kgpcatr,rmr,bzar,knetr
store space(20) to ngpr,adrr
@ 0,1 say 'Грузополучатель' get kgpr pict '9999999'
@ 1,1 say 'Наименование   ' get ngpr
@ 2,1 say 'Адрес          ' get adrr
@ 3,1 say 'Район          ' get krnr pict '9999' valid vkrn(wfltr)
@ 4,1 say 'Населенный пунк' get knaspr pict '9999' valid vknasp(wfltr)
@ 5,1 say 'Категория      ' get kgpcatr pict '99' valid vkgpcat(wfltr)
@ 6,1 say 'Регион продаж  ' get rmr pict '9'
@ 7,1 say 'Без адреса     ' get bzar pict '9'
@ 8,1 say 'Код сети       ' get knetr pict '999' valid vkgpnet(wfltr)
read
kgp_r=kgpr
ngp_r=ngpr
adr_r=adrr
krn_r=krnr
knasp_r=knaspr
kgpcat_r=kgpcatr
rm_r=rmr
bza_r=bzar
knet_r=knetr
if lastkey()=K_ESC
   kgpforr=kgpfor_r
endif
*if lastkey()=K_ENTER
   kgpforr=kgpfor_r
   if kgp_r#0
      kgpforr=kgpfor_r+'.and.kgp=kgp_r'
   endif
   if !empty(ngp_r)
      ngp_r=alltrim(upper(ngp_r))
      if gnEnt#20
         kgpforr=kgpforr+".and.at(ngp_r,upper(getfield('t1','kgp->kgp','kln','nkl')))#0"
      else
         kgpforr=kgpforr+".and.at(ngp_r,upper(NGrPol))#0"
      endif
   endif
   if !empty(adr_r)
      adr_r=alltrim(upper(adr_r))
      kgpforr=kgpforr+".and.at(adr_r,upper(getfield('t1','kgp->kgp','kln','adr')))#0"
   endif
   if !empty(krn_r)
      kgpforr=kgpforr+".and.getfield('t1','kgp->kgp','kln','krn')=krn_r"
   endif
   if !empty(knasp_r)
      kgpforr=kgpforr+".and.getfield('t1','kgp->kgp','kln','knasp')=knasp_r"
   endif
   if !empty(kgpcat_r)
      kgpforr=kgpforr+'.and.kgpcat=kgpcat_r'
   endif
   if rm_r#0
      kgpforr=kgpforr+'.and.rm=rm_r'
   endif
   if bza_r#0
      kgpforr=kgpforr+".and.empty(getfield('t1','kgp->kgp','kln','adr'))"
   endif
   if knet_r#0
      kgpforr=kgpforr+'.and.knet=knet_r'
   endif
*endif
sele kgp
go top
rckgpr=recn()
wclose(wfltr)
setcolor(scfltr)

retu .t.

*******************
func tmesto()
*******************
clea
netuse('kpl')
netuse('kgp')
netuse('tmesto')
netuse('stagtm')
netuse('s_tag')
netuse('etm')
netuse('kgpcat')
netuse('cskl')
sele etm
if recc()=0
   sele tmesto
   go top
   do while !eof()
      tmestor=tmesto
      if netseek('t1','tmestor','etm')
         sele tmesto
         skip
         loop
      endif
      sele tmesto
      kgpr=kgp
      if !netseek('t1','kgpr','kgp')
         sele tmesto
         skip
         loop
      endif
      sele tmesto
      kplr=kpl
      if !netseek('t1','kplr','kpl')
         sele tmesto
         skip
         loop
      endif
      sele tmesto
      arec:={}
      getrec()
      sele etm
      netadd()
      putrec()
      sele tmesto
      skip
   endd
endif
netuse('kln')
netuse('kplkgp')
sele etm
go top
rcetmr=recn()
foretm_r='.t..and.uvol()'
foretmr=foretm_r
ntmesto_r=''
store 0 to kpl_r,kgp_r,uvol_r,dvktas_r,tmesto_r
*wait
do while .t.
   sele etm
   set orde to tag t1
   go rcetmr
   if gnEntrm=0
      foot('INS,F2,F3,F4,F6,F7,ENTER','Доб ID,Доб из СПР,Фильтр,Просм,Корр наим,КоррDPP,Агенты')
   else
      foot('INS,F2,F3,F4,F5,F6,ENTER','Доб ID,Доб из СПР,Фильтр,Просм,Синхр СПР,Корр наим,Агенты')
   endif
   rcetmr=slcf('etm',1,1,18,,"e:tmesto h:'ID' c:n(7) e:ntmesto h:'Наименование' c:c(68)",,,1,,foretmr,,'Торговые места '+alltrim(gcName_c))
   if lastkey()=K_ESC
      exit
   endif
   go rcetmr
   tmestor=tmesto
   kplr=kpl
   kgpr=kgp
   catr=cat
   kgpcatr=catr
   dppr=dpp
   nactr=nact
   do case
      case lastkey()=K_INS // INS в etm
           etmins()
      case lastkey()=K_F2 // INS из tmesto
           tmestoins()
      case lastkey()=K_DEL // DEL
           sele stagtm
           set orde to tag t2
           if netseek('t2','tmestor')
              do while tmesto=tmestor
                 netdel()
                 skip
              endd
           endif
           sele etm
           netdel()
           skip -1
           if bof()
              go top
           endif
           rcetmr=recn()
      case lastkey()=K_F3 // Фильтр
           etmflt()
      case lastkey()=K_F4 // Просмотр
           etmview()
      case lastkey()=-4 // Обновить tmesto
           if gnEntrm#0
              sele tmesto
              go top
              do while !eof()
                 tmestor=tmesto
                 kplr=kpl
                 kgpr=kgp
                 sele etm
                 if !netseek('t1','tmestor')
                    sele tmesto
                    netdel()
                 else
                    if !(kpl=kplr.and.kgp=kgpr)
                       sele tmesto
                       netdel()
                    endif
                 endif
                 sele tmesto
                 skip
              endd
           endif
      case lastkey()=-5 // Обновить наименование
           sele etm
           if fieldpos('ntmesto')#0
              go top
              do while !eof()
                 kgpr=kgp
                 kplr=kpl
                 ngpr=getfield('t1','kgpr','kln','nkle')
                 nplr=getfield('t1','kplr','kln','nkle')
                 ntmestor=alltrim(ngpr)+'('+lower(alltrim(nplr))+')'
                 sele etm
                 netrepl('ntmesto','ntmestor')
                 sele tmesto
                 set orde to tag t2
                 if netseek('t2','kplr,kgpr')
                    netrepl('ntmesto','ntmestor')
                 endif
                 sele etm
                 skip
              endd
           endif
      case lastkey()=K_ENTER // Агенты
           if gnEnt=20
              forstagtmr="tmesto=tmestor.and.getfield('t1','stagtm->kta','s_tag','ent')=gnEnt.and.getfield('t1','stagtm->kta','s_tag','uvol')=0"
           else
              forstagtmr="tmesto=tmestor.and.getfield('t1','stagtm->kta','s_tag','ent')#20.and.getfield('t1','stagtm->kta','s_tag','uvol')=0"
           endif
           sele stagtm
           set orde to tag t2
           if netseek('t2','tmestor')
              rcstagtmr=recn()
              do while .t.
                 sele stagtm
                 go rcstagtmr
                 rcstagtmr=slcf('stagtm',1,1,18,,"e:kta h:'Код' c:n(4) e:getfield('t1','stagtm->kta','s_tag','fio') h:'ФИО' c:c(20) e:getfield('t1','stagtm->kta','s_tag','ktas') h:'KTAS' c:n(4)",,,,,forstagtmr,,'Агенты')
                 if lastkey()=K_ESC
                    exit
                 endif
              endd
           endif
      case lastkey()=-6 // Коррекция dpp,nact,cat
           crdnc()
   endc
endd
if select('dv')#0
   sele dv
   use
endif
erase dv.dbf
erase dv.cdx
nuse()
retu .t.

func etmins()
*local getlist:={}
scbrir=setcolor('gr+/b,n/w')
wbrir=wopen(8,10,14,70)
wbox(1)
tmestor=0
kplr=0
kgpr=0
do while .t.
   @ 0,1 say 'Код плательщика    ' get kplr  pict '9999999' valid klnid('kkl1#0','kplr',wbrir)
   @ 1,1 say 'Код грузополучателя' get kgpr  pict '9999999' valid klnid('kkl1=0','kgpr',wbrir)
   read
   if lastkey()=K_ESC
      exit
   endif
   if lastkey()=K_ENTER
      sele kgp
      if !netseek('t1','kgpr')
         wmess('Грузополучателя нет в спр.',2)
         loop
      endif
      sele etm
      if netseek('t2','kplr,kgpr')
         wmess('Уже существует',2)
         rcetmr=recn()
         loop
      endif
      sele kln
      if !netseek('t1','kplr')
         wmess('Плательщика нет в справочнике клиентов',2)
         loop
      else
         if kklp=0.or.kkl1=0
            wmess('Это Не плательщик',2)
            loop
         endif
      endif
      sele kpl
      if !netseek('t1','kplr')
         netadd()
         netrepl('kpl','kplr')
      endif
      sele kln
      if !netseek('t1','kgpr')
         wmess('Грузополучателя в справочнике клиентов',2)
         loop
      endif
      sele kgp
      if !netseek('t1','kgpr')
         netadd()
         netrepl('kgp,kto,dtkto','kgpr,gnKto,date()')
      endif
      ngpr=getfield('t1','kgpr','kln','nkle')
      nplr=getfield('t1','kplr','kln','nkle')
      ntmestor=alltrim(ngpr)+'('+lower(alltrim(nplr))+')'
      sele tmesto
      set orde to tag t2
      if netseek('t2','kplr,kgpr')
         if fieldpos('ntmesto')#0
            netrepl('ntmesto','ntmestor')
         endif
         arec:={}
         getrec()
         sele etm
         netadd()
         putrec()
         if fieldpos('ntmesto')#0
            netrepl('ntmesto','ntmestor')
         endif
         rcetmr=recn()
         exit
      else
         sele cntcm
         reclock()
         tmestor=tmesto
         netrepl('tmesto','tmesto+1')
         sele tmesto
         netadd()
         netrepl('tmesto,kpl,kgp','tmestor,kplr,kgpr')
         if fieldpos('ntmesto')#0
            netrepl('ntmesto','ntmestor')
         endif
         sele etm
         netadd()
         netrepl('tmesto,kpl,kgp','tmestor,kplr,kgpr')
         if fieldpos('ntmesto')#0
            netrepl('ntmesto','ntmestor')
         endif
         rcetmr=recn()
         exit
      endif
   endif
endd
wclose(wbrir)
setcolor(scbrir)
retu .t.

func etmflt()
scfltr=setcolor('gr+/b,n/w')
wfltr=wopen(8,10,17,70)
wbox(1)
kgp_r=0
kpl_r=0
nokgp_r=0
dv_r=0
nag_r=0
ntmesto_r=space(40)
tmesto_r=0
@ 0,1 say 'Плательщик     ' get kpl_r pict '9999999' // valid klnid('kkl1#0')
@ 1,1 say 'Грузополучатель' get kgp_r pict '9999999' // valid klnid('kkl1=0')
@ 2,1 say 'Торг.место     ' get tmesto_r pict '9999999'
@ 3,1 say 'Непр грузополуч' get nokgp_r pict '9'
@ 4,1 say 'Двойники       ' get dv_r pict '9'
@ 5,1 say 'Нет агентов    ' get nag_r pict '9'
@ 6,1 say 'Только уволенн ' get uvol_r pict '9'
@ 7,1 say 'Дв.суперв.     ' get dvktas_r pict '9'
read
if lastkey()=K_ESC
   foretmr=foretm_r
endif
if lastkey()=K_ENTER
   if nokgp_r=0.and.dv_r=0.and.nag_r=0
      if kpl_r#0
         foretmr=foretm_r+'.and.kpl=kpl_r'
      endif
      if kgp_r#0
         foretmr=foretm_r+'.and.kgp=kgp_r'
      endif
      if tmesto_r#0
         foretmr=foretm_r+'.and.tmesto=tmesto_r'
      endif
   else
      if nokgp_r#0
         foretmr=foretm_r+".and.!netseek('t1','etm->kgp','kgp')"
      else
         foretmr=foretm_r
      endif
      do case
         case nag_r=1
              foretmr=foretmr+".and.!netseek('t2','etm->tmesto','stagtm')"
         case nag_r=2
              foretmr=foretmr+".and.netseek('t2','etm->tmesto','stagtm')"
      endc
      if dv_r#0
         if select('dv')#0
            sele dv
            use
         endif
         crtt('dv','f:tmesto c:n(7)')
         sele 0
         use dv excl
         inde on str(tmesto,7) tag t1
         sele etm
         set orde to tag t2
         go top
         do while !eof()
            kplr=kpl
            kgpr=kgp
            tmestor=tmesto
            rcr=recn()
            seek str(kplr,7)+str(kgpr,7)
            if recn()#rcr
               sele dv
               seek str(tmestor,7)
               if !foun()
                  appe blank
                  repl tmesto with tmestor
               endif
            endif
            sele etm
            go rcr
            skip
         endd
         foretmr=foretmr+".and.netseek('t1','etm->tmesto','dv')"
      endif
   endif
   if dvktas_r#0
      foretmr=foretm_r+'.and.dvktas()'
   endif
endif
sele etm
go top
rcetmr=recn()
wclose(wfltr)
setcolor(scfltr)
retu .t.

************
func dvktas()
************
local lretr
lretr=.f.
tm_rr=etm->tmesto
sele stagtm
aktas:={}
set orde to tag t2
if netseek('t2','tm_rr')
   do while tmesto=tm_rr
      kta_rr=kta
      sele s_tag
      if netseek('t1','kta_rr')
         if ent#gnEnt.or.uvol=1
            sele stagtm
            skip
            loop
         endif
         ktas_rr=ktas
         if ascan(aktas,ktas_rr)=0
            aadd(aktas,ktas_rr)
         else
            lretr=.t.
            exit
         endi
      endif
      sele stagtm
      skip
   endd
endif
sele etm
retu lretr

************
func uvol()
************
local retr
retr=.f.
if uvol_r=0
   retu .t.
endif
sele stagtm
set orde to tag t2
if netseek('t2','etm->tmesto')
   do while tmesto=etm->tmesto
      uvolr=getfield('t1','stagtm->kta','s_tag','uvol')
      if uvolr=1
         retr=.t.
      else
         retr=.f.
         exit
      endif
      skip
   endd
else
   sele etm
   retu retr
endif
sele etm
retu retr


func etmview()
*kgpcatr=getfield('t1','gpcatr','kgpcat','nkgpcat')
nkgpcatr=getfield('t1','kgpcatr','kgpcat','nkgpcat')
scetmvr=setcolor('gr+/b,n/w')
wetmvr=wopen(8,5,18,75)
wbox(1)
@ 0,1 say 'Плательщик'+' '+str(kplr,7)+' '+alltrim(getfield('t1','kplr','kln','nkl'))
@ 1,1 say 'Адрес     '+' '+alltrim(getfield('t1','kplr','kln','adr'))
@ 3,1 say 'Получатель'+' '+str(kgpr,7)+' '+alltrim(getfield('t1','kgpr','kln','nkl'))
@ 4,1 say 'Адрес     '+' '+alltrim(getfield('t1','kgpr','kln','adr'))
@ 5,25 say nkgpcatr
@ 5,1 say "Категория " GET  kgpcatr PICT "99" valid kgpcat(wetmvr)
@ 6,1 say "Посл.посещ" GET  dppr
@ 7,1 say "Не активн." GET  nactr pict '9'
read
if lastkey()=K_ENTER
   sele etm
   netrepl('cat,dpp,nact','kgpcatr,dppr,nactr')
endif

wclose(wetmvr)
setcolor(scetmvr)

retu .t.


func tmestoins()
  if select('sl')=0
     sele 0
     use _slct alias sl excl
  endif
  sele sl
  zap
  sele tmesto
  go top
  rctmestor=recn()
  fortm_r=".t..and.!netseek('t1','tmesto->tmesto','etm')"
  fortmr=fortm_r
  ntmesto_r=''
  kgp_r=0
  kpl_r=0
  do while .t.
     foot('F3,F4','Фильтр,Просмотр')
     sele tmesto
     go rctmestor
     rctmestor=slcf('tmesto',,,,,"e:tmesto h:'ID' c:n(7) e:kgp h:'Код' c:n(7) e:getfield('t1','tmesto->kgp','kln','nkle') h:'Грузополучатель' c:c(20) e:kpl h:'Код' c:n(7) e:getfield('t1','tmesto->kpl','kln','nkl') h:'Плательщик' c:c(30) ",,1,,,fortmr,,'Торговые места (Справочник)')
     sele tmesto
     go rctmestor
     kplr=kpl
     kgpr=kgp
     ntmestor=ntmesto
     if lastkey()=K_ESC
        fortmr=fortm_r
        exit
     endif
     do case
        case lastkey()=K_ENTER
             sele sl
             go top
             do while !eof()
                rcrr=val(kod)
                sele tmesto
                go rcrr
                arec:={};   getrec()
                kgpr=kgp
                kplr=kpl
                ngpr=getfield('t1','kgpr','kln','nkle')
                nplr=getfield('t1','kplr','kln','nkle')
                ntmestor=alltrim(ngpr)+'('+lower(alltrim(nplr))+')'
                sele etm
                netadd();  putrec()
                if fieldpos('ntmesto')#0
                  netrepl('ntmesto','ntmestor')
                endif
                sele sl
                skip
             endd
             exit
        case lastkey()=K_F3 // Фильтр
             tmestoflt()
        case lastkey()=K_F4 // Просмотр
             etmview()
     endc
  endd
  retu .t.

func tmestoflt()
scfltr=setcolor('gr+/b,n/w')
wfltr=wopen(8,10,13,70)
wbox(1)
kgp_r=0
kpl_r=0
ntmesto_r=space(40)
@ 0,1 say 'Плательщик     ' get kpl_r pict '9999999'
@ 1,1 say 'Грузополучатель' get kgp_r pict '9999999'
@ 2,1 say 'Контекст       ' get ntmesto_r
read
if lastkey()=K_ESC
   fortmr=fortm_r
endif
if lastkey()=K_ENTER
   if kpl_r#0
      fortmr=fortm_r+'.and.kpl=kpl_r'
   endif
   if kgp_r#0
      fortmr=fortm_r+'.and.kgp=kgp_r'
   endif
   if !empty(ntmesto_r)
      ntmesto_r=upper(alltrim(ntmesto_r))
      fortmr=fortm_r+'.and.at(ntmesto_r,upper(tmesto->ntmesto))#0'
   endif
endif
sele tmesto
go top
rctmestor=recn()
wclose(wfltr)
setcolor(scfltr)
retu .t.

func klnid(p1,p2,p3)
local getlist:={}
if !empty(p1)
   for_rr=p1
else
   for_rr='.t.'
endif
if empty(p2)
   retu .f.
endif
if !empty(p3)
   woldr=p3
else
   woldr=0
endif
rmr=9
kkl_rr=&p2
if kkl_rr=0
   wselect(0)
   for_rrr=for_rr
   klntxtr=space(40)
   sele kln
   go top
   rcklnr=recn()
   do while .t.
      wselect(0)
      foot('ENTER,F3','Отбор,Фильтр')
      sele kln
      go rcklnr
      rcklnr=slcf('kln',,,,,"e:kkl h:'Код' c:n(7) e:nkl h:'Наименование' c:c(60)",,,,,for_rrr,,'Клиенты (Справочник)')
      if lastkey()=K_ESC
         kkl_rr=0
         exit
      endif
      go rcklnr
      kkl_rr=kkl
      do case
         case lastkey()=K_ENTER
              exit
         case lastkey()=K_F3
              klntxtr=space(40)
              rmr=9
              scklnf=setcolor('gr+/b,n/w')
              wklnf=wopen(8,10,12,70)
              wbox(1)
              @ 0,1 say 'Контекст' get klntxtr
              if p2='kgpr'
                 @ 1,1 say 'Регион  ' get rmr pict '9'
                 @ 1,col()+1 say '9 - Все'
              endif
              if p2='kplr'
                 @ 1,1 say 'Регион  ' get rmr pict '9'
                 @ 1,col()+1 say '9 - Все'
              endif
              read
              wclose(wklnf)
              setcolor(scklnf)
              if lastkey()=K_ESC
                 for_rrr=for_rr
                 sele kln
                 go top
                 rcklnr=recn()
              endif
              if lastkey()=K_ENTER
                 if empty(klntxtr)
                    for_rrr=for_rr
                 else
                    for_rrr=for_rr+'.and.at(alltrim(upper(klntxtr)),upper(kln->nkl))#0'
                 endif
                 if p2='kgpr'
                    if rmr=9
                    else
                       for_rrr=for_rrr+".and.getfield('t1','kln->kkl','kgp','rm')=rmr "
                    endif
                 endif
                 if p2='kplr'
                    if rmr=9
                    else
                       for_rrr=for_rrr+".and.subs(getfield('t1','kln->kkl','kpl','crmsk'),rmr,1)='1'"
                    endif
                 endif
                 sele kln
                 go top
                 rcklnr=recn()
              endif
      endc
   endd
   &p2=kkl_rr
endif
wselect(woldr)
if kkl_rr#0
   retu .t.
else
   retu .f.
endif


stat func atvm()
wselect(0)
sele atvm
if vmrshr=0.or.!netseek('t1','vmrshr')
   go top
   do while .t.
      vmrshr=slcf('atvm',,,,,"e:vmrsh h:'Код' c:n(3) e:nvmrsh h:'Наименование' c:c(20)",'vmrsh',,,,,,'Рег.маршр.')
      netseek('t1','vmrshr')
      nvmrshr=nvmrsh
      do case
         case lastkey()=K_ESC
              exit
         case lastkey()=K_ENTER
              sele atvme
              if netseek('t2','kgpr')
                 if vmrshr#vmrsh
                    netrepl('vmrsh','vmrshr')
                 endif
              else
                 netadd()
                 netrepl('vmrsh,kkl','vmrshr,kgpr')
              endif
              exit
      endc
   endd
else
   sele atvme
   if netseek('t2','kgpr')
      if vmrshr#vmrsh
         netrepl('vmrsh','vmrshr')
      endif
   else
       netadd()
       netrepl('vmrsh,kkl','vmrshr,kgpr')
   endif
endif
wselect(wbrir)
retu .t.


stat func kgpcat(p1)
wselect(0)
sele kgpcat
if kgpcatr#0
   if !netseek('t1','kgpcatr')
      kgpcatr=0
      nkgpcatr=space(20)
   else
      nkgpcatr=nkgpcat
   endif
endif
if kgpcatr=0
   wwr=wselect(0)
   go top
   kgpcatr=slcf('kgpcat',,,,,"e:kgpcat h:'Код' c:n(2) e:nkgpcat h:'Наименование' c:c(20)",'kgpcat',,,,,,'Категории ГП')
   wselect(wwr)
   nkgpcatr=getfield('t1','kgpcatr','kgpcat','nkgpcat')
endif
if !empty(p1)
   wselect(p1)
else
   wselect(wbrir)
endif

if empty(p1)
   if !empty(nkgpcatr)
      @ 4,25 say nkgpcatr
   else
      @ 4,25 say space(20)
   endif
else
   if !empty(nkgpcatr)
      @ 5,25 say nkgpcatr
   else
      @ 5,25 say space(20)
   endif
endif

retu .t.
******************
stat func knet()
******************
wselect(0)
sele kgpnet
if knetr#0
   if !netseek('t1','knetr')
      knetr=0
      nnetr=space(40)
   else
      nnetr=nnet
   endif
endif
if knetr=0
   wwr=wselect(0)
   go top
   rcknetr=slcf('kgpnet',,,,,"e:knet h:'Код' c:n(3) e:nnet h:'Наименование' c:c(40)",,,,,,,'Сети ГП')
   go rcknetr
   knetr=knet
   nnetr=nnet
   wselect(wwr)
endif
wselect(wbrir)
if !empty(nnetr)
   @ 13,11 say nnetr
else
   @ 13,11 say space(40)
endif

retu .t.
*************
func obkgp()
*************

sele kgp
go top
do while !eof()
   kgpr=kgp
   KgpTmins()
   sele kgp
   skip
endd
retu .t.
***************
func vkgpcat(p1)
**************
wselect(0)
sele kgpcat
go top
rccatr=recn()
rccatr=slcf('kgpcat',,,,,"e:kgpcat h:'Код' c:n(2) e:nkgpcat h:'Наименование' c:c(20)",,,,,,,'Категории')
if lastkey()=K_ENTER
   go rccatr
   kgpcat_r=kgpcat
endif
wselect(p1)
retu .t.

***************
func vkgpnet(p1)
**************
wselect(0)
sele kgpnet
go top
rccatr=recn()
rccatr=slcf('kgpnet',,,,,"e:knet h:'Код' c:n(3) e:nnet h:'Наименование' c:c(40)",,,,,,,'Сети грузополучателей')
if lastkey()=K_ENTER
   go rccatr
   knetr=knet
endif
wselect(p1)
retu .t.

func kgpobn()
sele kgp
go top
do while !eof()
   if empty(NGrPol)
      kgpr=kgp
      NGrPolr=getfield('t1','kgpr','kln','nkl')
      sele kgp
      netrepl('NGrPol','NGrPolr')
   endif
   sele kgp
   skip
endd
retu .t.

func klngobn()
sele kgp
go top
do while !eof()
   if !empty(NGrPol)
      kgpr=kgp
      nklr=NGrPol
      sele kln
      if netseek('t1','kgpr')
         if kkl1=0
            netrepl('nkl,nkle','nklr,nklr')
         endif
      endif
   endif
   sele kgp
   skip
endd
retu .t.

****************
func KgpTmins(p1)
****************
if empty(p1)
   sele mkeep
   go top
   do while !eof()
*      if gnEnt=20
*         if lv20=0
*            skip
*            loop
*         endif
*      endif
      lvr=lv20
      mkeepr=mkeep
      nmkeepr=nmkeep
      prTT102_r=getfield('t1','kgpr','kgp','prTT102')
*      if val(subs(nmkeep,1,2))>0.and.val(subs(nmkeep,1,2))<15
         sele KgpTm
         if !netseek('t1','kgpr,mkeepr')
            if gnEnt=20
               if lvr=1
                  netadd()
                  netrepl('kgp,mkeep,nmkeep','kgpr,mkeepr,nmkeepr')
                  if prTT102_r=1.and.mkeepr=102
                     netrepl('tcen','3')
                  endif
               endif
            else
               netadd()
               netrepl('kgp,mkeep,nmkeep','kgpr,mkeepr,nmkeepr')
            endif
         else
            if gnEnt=20
               if lvr=0
                  netdel()
               else
                  if prTT102_r=1.and.mkeepr=102
                     netrepl('tcen','3')
                  else
                     netrepl('tcen','0')
                  endif
               endif
            endif
         endif
*      endif
      sele mkeep
      skip
   endd
else
   sctmr=setcolor('gr+/b,n/w')
   wtmr=wopen(10,20,14,60)
   wbox(1)
   @ 0,1 say 'Тип цены' get tcenr pict '99'
   @ 1,1 say 'Наценка ' get nacr pict '999.99'
   @ 2,1 say 'Наценка1' get nac1r pict '999.99'
   read
   if lastkey()=K_ENTER
      if fieldpos('tcen')#0
         netrepl('tcen,nac,nac1','tcenr,nacr,nac1r')
      endif
   endif
   wclose(wtmr)
   setcolor(sctmr)
endif
retu .f.

**************
func kgpnet()
**************
clea
netuse('kgpnet')
sele kgpnet
go top
rcgnr=recn()
do while .t.
   sele kgpnet
   go rcgnr
   foot('INS,DEL,F4','Доб,Уд,Корр')
   rcgnr=slcf('kgpnet',,,,,"e:knet h:'Код' c:n(3) e:nnet h:'Наименование' c:c(40)",,,,,,,'Сети грузополучателей')
   if lastkey()=K_ESC
      exit
   endif
   sele kgpnet
   go rcgnr
   knetr=knet
   nnetr=nnet
   do case
      case lastkey()=K_INS // INS
           kgpnins()
      case lastkey()=K_DEL.and.gnAdm=1 // DEL
           netdel()
           skip -1
           if bof()
              go top
           endif
           rcgnr=recn()
      case lastkey()=K_F4 // Коррекция
           kgpnins(1)
      case lastkey()=-31.and.gnAdm=1  // Корр KGP
           netuse('kgp')
           go top
           do while !eof()
              if empty(nnet)
                 skip
                 loop
              endif
              nnetr=alltrim(nnet)
              sele kgpnet
              locate for alltrim(nnet)=nnetr
              if foun()
                 knetr=knet
                 sele kgp
                 if fieldpos('knet')#0
                    netrepl('knet','knetr')
                 endif
              endif
              sele kgp
              skip
           endd
   endc
endd
nuse()
retu .t.
******************
func kgpnins(p1)
******************
scbrir=setcolor('gr+/b,n/w')
wbrir=wopen(10,10,14,70)
wbox(1)
if empty(p1)
   go bott
   knetr=knet+1
   nnetr=space(40)
endif
do while .t.
   if empty(p1)
      @ 0,1 say 'Код сети' get knetr  pict '999'
   else
      @ 0,1 say 'Код сети'+' '+str(knetr,3)
   endif
   @ 1,1 say 'Наименование сети' get nnetr
   read
   if lastkey()=K_ESC
      exit
   endif
   if lastkey()=K_ENTER
      if empty(p1)
         if netseek('t1','knetr')
            wmess('Уже есть',2)
            exit
         else
            netadd()
            netrepl('knet,nnet','knetr,nnetr')
            rcgnr=recn()
         endif
      else
         netrepl('nnet','nnetr')
      endif
      exit
   endif
endd
wclose(wbrir)
setcolor(scbrir)
retu .t.

********************
func crdnc()
* Корр dpp,nact,cat
********************
* DPP
dt1r=date()
*dt2r=addmonth(dt1r,-1)
dt2r=ctod('01.01.2006')
for yyr=year(dt1r) to year(dt2r) step-1
    do case
       case year(dt1r)=year(dt2r)
            m1r=month(dt1r)
            m2r=month(dt2r)
       case yyr=year(dt1r)
            m1r=month(dt1r)
            m2r=1
       case yyr=year(dt2r)
            m1r=12
            m2r=month(dt2r)
       othe
            m1r=12
            m2r=1
    endc
    for mmr=m1r to m2r step -1
        pathdr=gcPath_e+'g'+str(yyr,4)+'\m'+iif(mmr<10,'0'+str(mmr,1),str(mmr,2))+'\'
        sele cskl
        go top
        do while !eof()
           if ent#gnEnt
              skip
              loop
           endif
           if rasc#1
              skip
              loop
           endif
           pathr=pathdr+alltrim(path)
           mess('DPP '+pathr)
           if !netfile('rs1kpk',1)
              skip
              loop
           endif
           netuse('rs1kpk')
           do while !eof()
              kplr=kpl
              kgpr=kgp
              cdpp_r=subs(timecrtfrm,1,10)
              cdppr=subs(cdpp_r,9,2)+'.'+subs(cdpp_r,6,2)+'.'+subs(cdpp_r,1,4)
              dppr=ctod(cdppr)
              sele etm
              if netseek('t2','kplr,kgpr')
                 if dppr>dpp
                    netrepl('dpp','dppr')
                 endif
              endif
              sele rs1kpk
              skip
           endd
           nuse('rs1kpk')
           sele cskl
           skip
        endd
    endf
endf

mess('NACT')
sele etm
go top
do while !eof()
   tmestor=tmesto
   nactr=0
   sele stagtm
   set orde to tag t2
   if netseek('t2','tmestor')
      pruvolr=1
      do while tmesto=tmestor
         ktar=kta
         uvolr=getfield('t1','ktar','s_tag','uvol')
         if uvolr=0
            pruvolr=0
            exit
         endif
         sele stagtm
         skip
      endd
      if pruvolr=1
         nactr=1
      endif
   else
      nactr=1
   endif
   sele etm
   netrepl('nact','nactr')
   skip
endd
* CAT
mess('Cat')
sele kgp
go top
do while !eof()
   kgpr=kgp
   kgpcatr=kgpcat
   sele etm
   set orde to tag t3
   seek str(kgpr,7)
   if foun()
      rcr=recn()
      skip
      if kgp#kgpr.or.eof()
         go rcr
         netrepl('cat','kgpcatr')
      endif
   endif
   sele kgp
   skip
endd
retu .t.
**************
func chst()
**************
clea
netuse('chst')
sele chst
go top
rcgnr=recn()
do while .t.
   sele chst
   go rcgnr
   foot('INS,DEL,F4','Доб,Уд,Корр')
   rcgnr=slcf('chst',,,,,"e:chst h:'Код' c:n(4) e:nchst h:'Наименование' c:c(40)",,,,,,,'Сети плательщиков')
   if lastkey()=K_ESC
      exit
   endif
   sele chst
   go rcgnr
   chstr=chst
   nchstr=nchst
   do case
      case lastkey()=K_INS // INS
           chstins()
      case lastkey()=K_DEL.and.chstr#0    // .and.gnAdm=1 // DEL
           netdel()
           skip -1
           if bof()
              go top
           endif
           rcgnr=recn()
      case lastkey()=K_F4 // Коррекция
           chstins(1)
   endc
endd
nuse()
retu .t.
******************
func chstins(p1)
******************
scbrir=setcolor('gr+/b,n/w')
wbrir=wopen(10,10,14,70)
wbox(1)
if empty(p1)
   go bott
   chstr=chst+1
   nchstr=space(40)
endif
do while .t.
   if empty(p1)
      @ 0,1 say 'Код сети' get chstr  pict '9999'
   else
      @ 0,1 say 'Код сети'+' '+str(chstr,4)
   endif
   @ 1,1 say 'Наименование сети' get nchstr
   read
   if lastkey()=K_ESC
      exit
   endif
   if lastkey()=K_ENTER
      if empty(p1)
         if netseek('t1','chstr')
            wmess('Уже есть',2)
            exit
         else
            netadd()
            netrepl('chst,nchst','chstr,nchstr')
            rcgnr=recn()
         endif
      else
         netrepl('nchst','nchstr')
      endif
      exit
   endif
endd
wclose(wbrir)
setcolor(scbrir)
retu .t.
