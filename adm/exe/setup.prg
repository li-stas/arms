* setup
clea
netuse('setup')
netuse('kln')
sele setup
go top
rcsetr=recn()
do while .t.
   sele setup
   go rcsetr
   foot('INS,DEL,F4,F5','Добавить,Удалить,Коррекция,Создать')
   rcsetr=slcf('setup',1,,18,,"e:ent h:'ENT' c:n(2) e:nent h:'Наим.прог.' c:c(10) e:uss h:'Наим.меню' c:c(10) e:entfp h:'Род' c:n(2) e:entrm h:'R' c:n(1) e:entnpp h:'M' c:n(1) e:nnds h:'N нал' c:n(10)",,,1,,,,'Предприятия')
   if lastkey()=27 && Выход
      exit
   endif   
   sele setup
   go rcsetr
   entr=ent
   kb1r=kb1
   kb2r=kb2
   kklr=kkl
   kkl7r=kkl7
   if kklr=0
      kklr=getfield('t1','kkl7r','kln','kkl1')
   endif 
   nnr=nn
   ndsr=nds
   nmrshr=nmrsh
   entnppr=entnpp
   entfpr=entfp
   entrmr=entrm
   nentr=subs(nent,1,10)
   ussr=subs(uss,1,10)
   ns1r=ns1
   ns2r=ns2
   directr=direct
   buhgr=buhg
   nndsr=nnds
   nsvr=nsv 
   dokzmnr=dokzmn
   niddirr=niddir
   nidbuhr=nidbuh
   kodnir=kodni 
   skpkr=skpk
   do case
      case lastkey()=22  && Добавить
           entins()
      case lastkey()=7   && Удалить
           netdel()   
           skip -1
           if bof()
              go top  
           endif  
           rcsetr=recn()
      case lastkey()=-3 && Коррекция
           entins(1)
      case lastkey()=-4 && Создать
   endc
enddo
nuse()

stat func entins(p1)
if p1=nil
   store 0 to entr,kb1r,kb2r,kklr,kkl7r,nnr,ndsr,nmrshr,entfpr,;
              entrmr,nndsr,entnppr,dokzmnr,kodnir,niddirr,nidbuhr,skpkr
   store space(10) to nentr,ussr
   store space(20) to ns1r,ns2r,directr,buhgr,nsvr
endif
clentins=setcolor('gr+/b,n/w')
wentins=wopen(2,5,22,75)
wbox(1)
do while .t.
   if p1=nil
      @ 0,1   say 'Предприятие' get entr pict '99' valid ent()
      @ 1,1   say 'ОКПО              ' get kklr pict '9999999999' valid okpo()
      read
   else
      @ 0,1   say 'Предприятие'+' '+str(entr,2)
      @ 1,1   say 'ОКПО              ' get kklr pict '9999999999' valid okpo()
   endif
   @ 2,1   say 'Внутренний код    '+' '+str(kkl7r,7) 
   @ 3,1   say 'Налоговый код     '+' '+str(nnr,12) 
   @ 4,1   say 'N свидетельства   '+' '+nsvr
   @ 5,1   say 'Банк1             '+' '+str(kb1r,6) 
   @ 5,col()+1   say 'Счет1' +' '+ns1r
   @ 6,1   say 'Банк2             '+' '+str(kb2r,6) 
   @ 6,col()+1   say 'Счет2' +' '+ns2r
   @ 7,1   say 'Директор          ' get directr
   @ 8,1   say 'Бухгалтер         ' get buhgr
   @ 9,1   say 'НДС               ' get ndsr pict '99.99'
   @ 10,1  say 'Наименование прогр' get nentr 
   @ 11,1  say 'Наименование меню ' get ussr
   @ 12,1  say 'Порядок в меню    ' get entnppr pict '9' 
   @ 13,1  say 'Родитель          ' get entfpr pict '99' 
   @ 14,1  say 'Удаленное         ' get entrmr pict '9'
   @ 15,1  say 'Тек N налоговой   ' get nndsr pict '9999999999'
   @ 16,1  say 'Тек N маршрута    ' get nmrshr pict '999999'
   @ 17,1  say 'Тек N DOKZ        ' get dokzmnr pict '999999'
   @ 18,1  say 'Тек N сеанса КПК  ' get skpkr pict '9999999999'
*   @ 10,35  say 'Директор' get directr 
*   @ 11,35  say 'Бухгалтер' get buhgr
   @ 12,35  say 'NID директора ' get niddirr pict '999999999999999' 
   @ 13,35  say 'NID бухгалтера' get nidbuhr pict '999999999999999' 
   @ 14,35  say 'Код налоговой' get kodnir pict '9999'
   read
   if lastkey()=27
      exit
   endif
   @ 18,40 prom 'Верно'
   @ 18,col()+1 prom 'Не верно'
   menu to vn
   if lastkey()=27
      exit
   endif
   if vn=1
      sele setup
      if p1=nil
         netadd()
      endif
      netrepl('ent,kb1,kb2,kkl,kkl7,nn,nds,entnpp,entfp,entrm,nent,uss,ns1,ns2,direct,buhg,nnds,nmrsh,dokzmn,niddir,nidbuh,kodni,skpk',;
              'entr,kb1r,kb2r,kklr,kkl7r,nnr,ndsr,entnppr,entfpr,entrmr,nentr,ussr,ns1r,ns2r,directr,buhgr,nndsr,nmrshr,dokzmnr,niddirr,nidbuhr,kodnir,skpkr')
      rcskr=recn()
      exit
   endif
endd
sele setup
wclose(wentins)
setcolor(clentins)
retu

stat func ent()
sele setup
locate for ent=entr
if foun()
   wmess('Такое уже существует',1)
   retu .f.
endif
retu .t.

stat func okpo()
sele kln
set orde to tag t5
if !netseek('t5','kklr')
   wmess('Предприятия нет в справ.клиентов',1)
   retu .f.
else
   nnr=nn
   nsvr=nsv
   kb1r=val(kb1)
   ns1r=ns1
   kb2r=val(kb2)
   ns2r=ns2
endif
retu .t.

*************
func arms()
*************
clea
netuse('arms')
rcarmsr=recn()
do while .t. 
   sele arms
   go rcarmsr
   foot('INS,DEL,F4','Добавить,Удалить,Коррекция')
   rcarmsr=slcf('arms',1,,18,,"e:arm h:'Код' c:n(2) e:name h:'Имя' c:c(10) e:nai h:'Наименование' c:c(20) e:fox h:'FOX' c:n(1) e:na h:'NA' c:n(1)",,,1,,,,'АРМы')
   if lastkey()=27 && Выход
      exit
   endif  
   go rcarmsr
   armr=arm
   namer=name
   nair=nai
   foxr=fox
   nar=na
   do case
      case lastkey()=22  && Добавить
           armins(0)
      case lastkey()=7   && Удалить
           netdel()   
           skip -1
           if bof()
              go top  
           endif  
           rcarmsr=recn()
      case lastkey()=-3 && Коррекция
           armins(1)
   endc 
endd
nuse()
retu .t.
****************
func armins(p1)
****************
if p1=0
   store 0 to armr,foxr,nar
   store space(10) to namer
   store space(20) to nair
endif
clarms=setcolor('gr+/b,n/w')
warms=wopen(8,10,15,70)
wbox(1)
do while .t.
   if p1=0
      @ 0,1 say 'Код' get armr pict '99'
   else
      @ 0,1 say 'Код'+' '+str(armr,2)
   endif   
   @ 1,1 say 'Имя' get namer 
   @ 2,1 say 'Наименование' get nair 
   @ 3,1 say 'FOX' get foxr pict '9'
   @ 4,1 say 'Не активен' get nar pict '9'
   read
   if lastkey()=27
      exit
   endif
   if lastkey()=13
      if p1=0
         loca for arm=armr
         if foun()
            wmess('Уже есть',2)
         else
            netadd()
            netrepl('arm,name,nai,fox,na','armr,namer,nair,foxr,nar')   
            rcarmsr=recn()
         endif
      else
         netrepl('name,nai,fox,na','namer,nair,foxr,nar')   
      endif
      exit
   endif
endd
wclose(warms)
setcolor(clarms)
retu .t.
