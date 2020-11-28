* Маршруты
clea
netuse('reg')
netuse('klnreg')
netuse('kln')

sele reg
do while .t.
   foot('INS,DEL,F4,ENTER','Добавить,Удалить,Коррекция,Состав')
   rcregr=slcf('reg',1,1,18,,"e:reg h:'Код' c:n(3) e:nreg h:'Наименование' c:c(20)",,,1,,,,'Маршруты')
   go rcregr
   regr=reg
   nregr=nreg
   do case
      case lastkey()=27
           exit
      case lastkey()=22
           regins(0)
      case lastkey()=7
           sele klnreg
           go top
           do while !eof()
              if reg=regr
                 netdel()
              endif
              skip
           endd
           sele reg
           netdel()
           skip -1
           if bof()
              go top
           endif
      case lastkey()=-3
           regins(1)
      case lastkey()=13
           klnreg()
   endc
endd
nuse()

func regins(p1)
if p1=0
  store 0 to reg_r
  store space(20) to nreg_r
else
  reg_r=regr
  nreg_r=nregr
endif
clregi=setcolor('gr+/b,n/w')
wregi=wopen(10,20,14,60)
wbox(1)
do while .t.
   if p1=0
      @ 0,1 say 'Маршрут  ' get reg_r pict '999'
   else
      @ 0,1 say 'Маршрут  '+' '+str(reg_r,3)
   endif
   @ 1,1 say 'Наименование' get nreg_r
   read
   if lastkey()=27
      exit
   endif
   @ 2,1 prom 'Верно'
   @ 2,col()+1 prom 'Не Верно'
   menu to vn
   if lastkey()=27
      exit
   endif
   if vn=1
      if p1=0
         loca for reg=reg_r
         if foun()
            wmess('Такой маршрут уже есть',1)
         else
            netadd()
            netrepl('reg,nreg','reg_r,nreg_r')
         endif
      else
         netrepl('nreg','nreg_r')
      endif
      exit
   endif
enddo
wclose(wregi)
setcolor(clregi)
retu .t.

func klnreg()
sele klnreg
go top
do while .t.
   foot('INS,DEL','Добавить,Удалить')
   rckrgr=slcf('klnreg',1,29,18,,"e:kkl h:'Код' c:n(7) e:getfield('t1','klnreg->kkl','kln','nkl') h:'Наименование' c:c(40)",,,,,'reg=regr',,'Состав')
   go rckrgr
   kklr=kkl
   nklr=getfield('t1','kklr','kln','nkl')
   do case
      case lastkey()=27
           exit
      case lastkey()=22
           klnregi()
      case lastkey()=7
           netdel()
           skip -1
           if reg#regr.or.bof()
              go top
           endif
   endc
endd
retu .t.

func klnregi()
clkregi=setcolor('gr+/b,n/w')
wkregi=wopen(10,20,14,50)
wbox(1)
kkl_r=0
sele klnreg
do while .t.
   @ 0,1 say 'Клиент  ' get kkl_r pict '9999999'
   read
   if lastkey()=27
      exit
   endif
   @ 2,1 prom 'Верно'
   @ 2,col()+1 prom 'Не Верно'
   menu to vn
   if lastkey()=27
      exit
   endif
   if vn=1
      loca for reg=regr.and.kkl=kkl_r
      if foun()
         wmess('Такой клиент уже есть',1)
      else
         netadd()
         netrepl('reg,kkl','regr,kkl_r')
      endif
      exit
   endif
enddo
wclose(wkregi)
setcolor(clkregi)
retu .t.
