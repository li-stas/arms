* Статистика
clea
netuse('st1sb')
netuse('stkg')
netuse('kgst')
netuse('krstat')
netuse('cgrp')

sele stkg
do while .t.
   sele stkg
   foot('INS,DEL,F4,F5,ENTER','Добавить,Удалить,Коррекция,Гр.склад,Состав')
   rcstkgr=slcf('stkg',1,1,18,,"e:kg h:'Код' c:n(3) e:ng h:'Группа' c:c(20) e:krstat h:'КодР' c:n(4)",,,1,,,,'Группы стат')
   go rcstkgr
   kgstr=kg
   ngstr=ng
   krstatr=krstat
   do case
      case lastkey()=27
           exit 
      case lastkey()=22 && INS
           stkgins(0)
      case lastkey()=7  && DEL
           sele st1sb
           go top
           do while !eof()
              if kg=kgstr
                 netdel() 
              endif  
              skip
           endd
           sele  kgst
           go top
           do while !eof()
              if kgn=kgstr
                 netdel() 
              endif  
              skip
           endd
           sele stkg
           netdel()
           skip -1
           if bof()
              go top 
           endif        
      case lastkey()=-3 && CORR
           stkgins(1)
      case lastkey()=-4 && Гр.склад
           grskl() 
      case lastkey()=13 && Состав
           st1sb()   
   endc
endd
nuse()

func stkgins(p1)
if p1=0
   kgst_r=0
   ngst_r=space(30)
   krstat_r=0
else
   kgst_r=kgstr
   ngst_r=ngstr
   krstat_r=krstatr
endif
clstkgi=setcolor('gr+/b,n/w')
wstkgi=wopen(10,20,15,60)
wbox(1)
sele stkg
do while .t.
   if p1=0
      @ 0,1 say 'Код         ' get kgst_r pict '999'
   else
      @ 0,1 say 'Код         '+' '+str(kgst_r,3)
   endif   
   @ 1,1 say 'Наименование' get ngst_r 
   @ 2,1 say 'КодР        ' get krstat_r pict '9999'
   read
   if lastkey()=27
      exit
   endif
   @ 3,1 prom 'Верно'
   @ 3,col()+1 prom 'Не Верно'
   menu to vn
   if lastkey()=27
      exit
   endif
   if vn=1
      if p1=0
         locate for kg=kgst_r
         if foun()
            wmess('Такая группа уже есть',1)
         else
            netadd()
            netrepl('kg,ng,krstat','kgst_r,ngst_r,krstat_r')  
            sele stkg
            exit
         endif        
      else
         netrepl('ng,krstat','ngst_r,krstat_r')  
         sele stkg
         exit  
      endif   
   endif   
enddo
wclose(wstkgi)
setcolor(clstkgi)
retu .t.


func st1sb()
sele st1sb
go top
do while .t.
   foot('INS,DEL,F4','Добавить,Удалить,Коррекция')
   rcst1r=slcf('st1sb',1,29,18,,"e:kodst h:'Код' c:n(4) e:natst h:'Наименование' c:c(25) e:neist h:'Ед.изм' c:c(6) e:kves h:'Вес' c:n(4,2) e:krstat h:'КодР' c:n(4)",,,,,'kg=kgstr',,alltrim(ngstr))
   go rcst1r
   kodstr=kodst
   natstr=natst
   neistr=neist
   kvesr=kves
   krstatr=krstat 
   nstatr=getfield('t1','krstatr','krstat','nstat')
   do case
      case lastkey()=27
           exit 
      case lastkey()=22 && INS
           st1ins(0)
      case lastkey()=7  && DEL
           netdel()
           skip -1
           if bof()
              go top 
           endif
      case lastkey()=-3 && CORR
           st1ins(1)
   endc
endd
retu .t.

func grskl()
sele kgst
go top
rckgstr=recn()
do while .t.
   go rckgstr
   
   foot('INS,DEL','Добавить,Удалить')
   rckgstr=slcf('kgst',,,,,"e:kg h:'Код' c:n(3) e:getfield('t1','kgst->kg','cgrp','ngr') h:'Группа' c:с(30)",,,,,'kgn=kgstr',,'Группы склада')
   go rckgstr
   
   do case
      case lastkey()=27
           exit
      case lastkey()=22 && INS
           clstkgi=setcolor('gr+/b,n/w')
           wstkgi=wopen(10,20,13,60)
           wbox(1)
           kg_r=0 
           do while .t.
              @ 0,1 say 'Код         ' get kg_r pict '999'
              read
              if lastkey()=27
                 exit
              endif
              @ 1,1 prom 'Верно'
              @ 1,col()+1 prom 'Не Верно'
              menu to vn
              if lastkey()=27
                 exit
              endif
              if vn=1
                 sele kgst
                 locate for kgn=kgstr.and.kg=kg_r
                 if foun()
                    wmess('Такая группа уже есть',1)
                 else
                    netadd()
                    netrepl('kg,kgn','kg_r,kgstr')  
                    rckgstr=recn()
                    exit
                 endif        
              endif
           enddo
           wclose(wstkgi)
           setcolor(clstkgi)
      case lastkey()=7  && DEL 
           netdel()
           skip -1
           if bof()
              go bott 
           endif
           rckgstr=recn()
   endc
endd
retu .t.

func st1ins(p1)
if p1=0
   kodst_r=0
   natst_r=space(30)
   neist_r=space(10)
   kves_r=0
   krstat_r=0
   nstatr=space(40)
else
   kodst_r=kodstr
   natst_r=natstr
   neist_r=neistr
   kves_r=kvesr
   krstat_r=krstatr
endif
clst1i=setcolor('gr+/b,n/w')
wst1i=wopen(9,20,16,60)
wbox(1)
sele st1sb
do while .t.
   if p1=0
      @ 0,1 say 'Код         ' get kodst_r pict '9999'
   else
      @ 0,1 say 'Код         '+' '+str(kodst_r,4)
   endif   
   @ 1,1 say 'Наименование' get natst_r 
   @ 2,1 say 'Единица изм.' get neist_r
   @ 3,1 say 'Вес         ' get kves_r
   @ 4,1 say 'КодР        ' get krstat_r pict '9999'
   @ 4,20 say nstatr
   read
   nstatr=getfield('t1','krstat_r','krstat','nstat')
   @ 4,20 say nstatr
   if lastkey()=27
      exit
   endif
   @ 5,1 prom 'Верно'
   @ 5,col()+1 prom 'Не Верно'
   menu to vn
   if lastkey()=27
      exit
   endif
   if vn=1
      if p1=0
         locate for kodst=kodst_r
         if foun()
            wmess('Такой код уже есть',1)
         else
            netadd()
            netrepl('kg,kodst,natst,neist,kves,krstat','kgstr,kodst_r,natst_r,neist_r,kves_r,krstat_r')  
            sele st1sb
            exit
         endif        
      else
         netrepl('natst,neist,kves,krstat','natst_r,neist_r,kves_r,krstat_r')  
         sele st1sb
         exit  
      endif   
   endif   
enddo
wclose(wst1i)
setcolor(clst1i)
retu .t.


