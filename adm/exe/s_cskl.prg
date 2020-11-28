clea
netuse('cskl')
netuse('setup')
netuse('kln')
store 0 to skr,entr,sklr,cenprr,tcenr,rozr,rpr,msklr,kklr,tsklr,otvr
store space(30) to nsklr,path_r
store space(3) to kbolr
store ctod('') to nprdr
whr=3
o_r=' '
ncoptr=space(10)
coptr=space(5)
boptr=space(5)
sele cskl
go top
rcskr=recn()
do while .t.
   sele cskl
   go rcskr
   foot('INS,DEL,F4,F5','Добавить,Удалить,Коррекция,Создать')
   if fieldpos('arnd')=0
      rcskr=slcf('cskl',1,,18,,"e:sk h:'SK' c:n(3) e:path h:'Путь' c:c(10) e:skl h:'Скл.' c:n(4) e:nskl h:'Наименование' c:c(19) e:tpstpok h:'T' c:n(1) e:rasc h:'Пр' c:n(1) e:rp h:'-O' c:n(1) e:rmag h:'M' c:n(1) e:kkl h:'Магазин' c:n(7) e:skotv h:'Отв' c:n(3) e:mskl h:'Ms' c:n(1) e:rm h:'R' c:n(1) e:tskl h:'Т' c:n(1) e:blk h:'Блк' c:n(1)",,,1,,'ent=gnEnt',,'СКЛАДЫ')
   else
      rcskr=slcf('cskl',1,,18,,"e:sk h:'SK' c:n(3) e:path h:'Путь' c:c(10) e:skl h:'Скл.' c:n(4) e:nskl h:'Наименование' c:c(19) e:tpstpok h:'T' c:n(1) e:rasc h:'Пр' c:n(1) e:rp h:'-O' c:n(1) e:rmag h:'M' c:n(1) e:kkl h:'Магазин' c:n(7) e:skotv h:'Отв' c:n(3) e:mskl h:'Ms' c:n(1) e:rm h:'R' c:n(1) e:tskl h:'Т' c:n(1) e:arnd h:'A' c:n(1) e:blk h:'Блк' c:n(1)",,,1,,'ent=gnEnt',,'СКЛАДЫ')
   endif
   if lastkey()=27 && Выход
      exit
   endif   
   sele cskl
   go rcskr
   skr=sk
   entr=ent
   sklr=skl
   nsklr=nskl
   path_r=path
   tpstpokr=tpstpok
   whr=wh
   cenprr=cenpr
   o_r=o
   tcenr=tcen
   rozr=roz
   rpr=rp
   msklr=mskl
   kklr=kkl
   ncoptr=ncopt
   coptr=copt
   ctovr=ctov
   ost0r=ost0
   boptr=bopt
   raznr=razn
   rascr=rasc
   magr=mag
   ndsr=nds
   skpr=skp
   vttnr=vttn
   rmagr=rmag
   otvr=otv
   skotvr=skotv
   blkr=blk
   ttnr=ttn
   mnr=mn
   rmr=rm
   tsklr=tskl
   arndr=arnd
   kpsr=kps
   nprdr=nprd
   if fieldpos('kt')#0
      ktr=kt
   else
      ktr=0 
   endif
   if fieldpos('kobol')#0
      kobolr=kobol
   else
      kobolr=space(3)
   endif
   if gnAdm=1
      do case
         case lastkey()=22  && Добавить
              skins()
         case lastkey()=7   && Удалить
              netdel()   
              skip -1
              if bof()
                 go top  
              endif  
              rcskr=recn()
         case lastkey()=-3 && Коррекция
              skins(1)
         case lastkey()=-4 && Создать
              dirr=subs(alltrim(path_r),1,len(alltrim(path_r))-1) 
              if dirchange(gcPath_d+dirr)#0
                 dirmake(gcPath_d+dirr)  
              endif
              dirchange(gcPath_l)    
              if file(gcPath_d+alltrim(path_r)+'tprds01.dbf')
                 aqstr=1
                 aqst:={"Нет","Да"}
                 aqstr:=alert("Перезаписать?",aqst)
              else
                 aqstr=2
              endif   
              if aqstr=2
                 sele dbft
                 go top
                 do while !eof()
                    rcdbftr=recn()
                    if dir#3
                       skip
                       loop
                    endif
                    alsr=alltrim(als)
                    fnamer=alltrim(fname)
                    parentr=alltrim(parent)
                    if empty(parent).and.empty(dop) 
                       if file(gcPath_a+alsr+'.dbf')    
                          copy file (gcPath_a+alsr+'.dbf') to (gcPath_d+alltrim(path_r)+fnamer+'.dbf')
                          sele dbft
                          skip
                          loop
                       endif 
                    endif   
                    if !empty(parentr) 
                       if file(gcPath_a+parentr+'.dbf')    
                          copy file (gcPath_a+parentr+'.dbf') to (gcPath_d+alltrim(path_r)+fnamer+'.dbf')
                          sele dbft
                          skip
                          loop
                        endif 
                    endif
                    if !empty(dop) 
                       pathr=gcPath_d+alltrim(path_r)  
                       crddop(alsr,1) 
                       sele dbft
                       go rcdbftr 
                       skip
                       loop
                    endif
                    sele dbft 
                    skip
                 endd 
                 sele cskl
              endif
      endc
   endif   
enddo
nuse()

stat func skins(p1)
sk_r=skr
if p1=nil
   store 0 to skr,entr,sklr,cenprr,tcenr,rozr,rpr,msklr,kklr,ctovr,ttnr,mnr,;
              ost0r,otvr,skotvr,rmagr,blkr,ndsr,skpr,magr,rascr,tpstpokr,rmr,;
              tsklr,arndr,kpsr,ktr
   store ctod('') to nprdr
   store space(30) to nsklr,path_r
   store space(3) to kobolr
   whr=3
   o_r=' '
   store space(10) to ncoptr,nentr
   coptr=space(5)
   nklr=''
   nentr=''
else
   nentr=getfield('t1','entr','setup','nent')
   nklr=getfield('t1','kklr','kln','nkl')
endif
clskins=setcolor('gr+/b,n/w')
wskins=wopen(2,10,21,70)
wbox(1)
do while .t.
   if p1=nil
      @ 0,1   say 'Адрес' get skr pict '999' valid sk()
   else
      @ 0,1   say 'Адрес'+' '+str(skr,3)
   endif
   @ 1,1   say 'Склад               ' get sklr pict '9999'
   @ 2,1   say 'Наименование        ' get nsklr
   @ 3,1   say 'Директория          ' get path_r
   @ 4,1   say 'Общий справочник' get ctovr pict '9'
   @ 5,1   say 'Продажи ' get rascr pict '9'
   @ 6,1   say 'Отношение к НДС склада' get ndsr pict '9'
   @ 7,1   say 'Мультисклад      ' get msklr pict '9'
   @ 8,1   say 'Mагазин' get rmagr pict '9'
   if gnEnt=21
      @ 8,25  say 'Код Обо' get kobolr 
   endif   
   @ 9,25  say nklr
   @ 9,1   say 'Магазин/Отв клиент' get kklr pict '9999999' valid kkl()
   @ 10,1  say 'Признак разр.расх.без прих.' get rpr pict '9'
   @ 11,1  say 'Признак обнуления остатков при перевороте' get ost0r
   @ 12,1  say 'Склад - родитель отв.хран.' get skotvr pict '999'
   @ 12,col()+1  say 'Вид отв.хран.' get otvr pict '9'
   @ 13,1  say 'Блокировка склада' get blkr pict '9'
   @ 14,1  say 'Возв.тара пост/пок' get tpstpokr pict '9' 
   @ 15,1  say 'Удаленный склад' get rmr pict '9'
   @ 16,1  say 'Учет остатков  ' get tsklr pict '9' valid tskl()
   @ 16,col()+1 say '0-skl,1-kpl,2-kgp,3-tmesto'
   @ 17,1  say 'Аренда         ' get arndr pict '9' 
   @ 17,col()+1  say 'Коммисс' get ktr pict '9' 
   @ 5,40  say 'Тек.ТТН ' get ttnr pict '999999'
   @ 6,40  say 'Тек.MN  ' get mnr pict '999999'
   @ 8,40  say 'Владелец' get kpsr pict '9999999'
   @ 10,40  say 'Ост нач ' get nprdr 
   read
   if lastkey()=27
      exit
   endif
   @ 17,40 prom 'Верно'
   @ 17,col()+1 prom 'Не верно'
   menu to vn
   if lastkey()=27
      exit
   endif
   if vn=1
      sele cskl
      if p1=nil
         netadd()
      endif
      sele cskl
      netrepl('sk,ent,skl,nskl,path,wh,cenpr,o,tcen,roz,rp,mskl,ncopt,copt,kkl,ctov,ost0,nds,mag,skotv,blk,rasc,tpstpok,rmag,rm,ttn,mn,otv';
             ,'skr,gnEnt,sklr,nsklr,path_r,whr,cenprr,o_r,tcenr,rozr,rpr,msklr,ncoptr,coptr,kklr,ctovr,ost0r,ndsr,magr,skotvr,blkr,rascr,tpstpokr,rmagr,rmr,ttnr,mnr,otvr')
      netrepl('tskl','tsklr') 
      netrepl('arnd','arndr') 
      netrepl('kps','kpsr') 
      netrepl('nprd','nprdr') 
      if fieldpos('kt')#0
         netrepl('kt','ktr') 
      endif
      if fieldpos('kobol')#0
         netrepl('kobol','kobolr') 
      endif
      rcskr=recn()
      exit
   endif
endd
wclose(wskins)
setcolor(clskins)
retu

stat func sk()
sele cskl
rccskl=recn()
if netseek('t1','skr')
   wmess('Такой адрес уже есть',1)
   go rcskr
endif
retu .t.

*stat func ent()
*sele setup
*if entr=0.or.!netseek('t1','entr')
*   wselect(0)
*   entr=slcf('setup',,,,,"e:ent h:'П' c:n(2) e:uss h:'Наименов.' c:c(10)",'ent')
*   wselect(wskins)
*endif
*nentr=getfield('t1','entr','setup','nent')
*   @ 1,16 say nentr
*retu .t.

stat func kkl()
sele kln
if rozr=1.and.(kklr=0.or.!netseek('t1','kklr'))
   wselect(0)
   kklr=slcf('kln',,,,,"e:kkl h:'Код' c:n(7) e:nkl h:'Наименование' c:c(30)",'kkl')
   wselect(wskins)
endif
nklr=getfield('t1','kklr','kln','nkl')
@ 9,25 say nklr
retu .t.

func tskl()
netuse('tskl')
wselect(0)
do while .t.
   rctsklr=slcf('tskl',,,,,"e:tskl h:'Тип' c:n(1) e:ntskl h:'Наименование' c:c(10) e:ndbf h:'Таблица' c:c(10)")
   if lastkey()=27
      exit 
   endif
   go rctsklr
   tsklr=tskl
   if lastkey()=13
      exit 
   endif
endd   
wselect(wskins)
nuse('tskl')
retu .t.

func s_tskl
clea
netuse('tskl')
rctsklr=recn()
do while .t.
   foot('INS,DEL,F4','Доб.,Уд.,Корр.')
   sele tskl
   go rctsklr
   rctsklr=slcf('tskl',,,,,"e:tskl h:'Тип' c:n(1) e:ntskl h:'Наименование' c:c(10) e:ndbf h:'Таблица' c:c(10)")
   if lastkey()=27
      exit 
   endif
   go rctsklr
   tsklr=tskl
   ntsklr=ntskl
   ndbfr=ndbf
   do case
      case lastkey()=22  && Добавить
           tsklins()
      case lastkey()=7   && Удалить
           netdel()   
           skip -1
           if bof()
              go top  
           endif  
           rctsklr=recn()
      case lastkey()=-3 && Коррекция
           tsklins(1)
   endc   
endd   
nuse('tskl')
retu .t.

func tsklins(p1)
if p1=nil
   tsklr=0
   ntsklr=space(10)
   ndbfr=space(10)
endif
cltsklins=setcolor('gr+/b,n/w')
wtsklins=wopen(10,20,15,60)
wbox(1)
do while .t.
   @ 0,1 say 'Тип         ' get tsklr pict '9'    
   @ 1,1 say 'Наименование' get ntsklr
   @ 2,1 say 'Справочник  ' get ndbfr
   @ 3,1 prom 'Верно'
   @ 3,col()+1 prom 'Не Верно'
   read
   if lastkey()=27
      exit  
   endif
   menu to vnr
   if lastkey()=27
      exit  
   endif
   if vnr=1
      if p1=nil
         netadd()    
      endif  
      netrepl('tskl,ntskl,ndbf','tsklr,ntsklr,ndbfr')  
      rctsklr=recn()
      exit 
   endif
endd
setcolor(cltsklins)
wclose(wtsklins)
retu .t.
