* DBFT
clea
sele dbft
go top
rcdbftr=recn()
forr='.t.'
do while .t.
   sele dbft
   go rcdbftr
   foot('INS,DEL,F3,F4','Добавить,Удалить,Фильтр,Коррекция')
   if fieldpos('mt')=0
      rcdbftr=slcf('dbft',1,,18,,"e:nf h:'NPP' c:n(3) e:als h:'Алиас' c:c(6) e:fname h:'Имя' c:c(8) e:dir h:'D' c:n(1) e:dirn h:'DN' c:n(1) e:ind h:'ARMS' c:с(10) e:parent h:'PARENT' c:c(6) e:dop h:'DOP' c:c(6) e:fox h:'FOX' c:n(1) e:fctov h:'C' c:n(1) e:rmupdt h:'RM' c:n(1)",,,1,,forr,,'Таблицы')
   else
      rcdbftr=slcf('dbft',1,,18,,"e:nf h:'NPP' c:n(3) e:als h:'Алиас' c:c(6) e:fname h:'Имя' c:c(8) e:dir h:'D' c:n(1) e:dirn h:'DN' c:n(1) e:ind h:'ARMS' c:с(10) e:parent h:'PARENT' c:c(6) e:dop h:'DOP' c:c(6) e:fox h:'FOX' c:n(1) e:fctov h:'C' c:n(1) e:rmupdt h:'RM' c:n(1) e:sd0 h:'SD0' c:n(1) e:rc1 h:'RC1' c:n(1) e:sd1 h:'SD1' c:n(1) e:rc0 h:'RC0' c:n(1) e:mt h:'MT' c:c(2)",,,1,,forr,,'Таблицы')
   endif
   if lastkey()=27 && Выход
      exit
   endif   
   sele dbft
   go rcdbftr
   nfr=nf
   alsr=als
   fnamer=fname
   dirr=dir
   dirnr=dirn
   indr=ind
   parentr=parent
   dopr=dop
   foxr=fox
   fctovr=fctov
   rmupdtr=rmupdt
   poler=pole
   t1r=t1
   t2r=t2
   t3r=t3
   t4r=t4
   t5r=t5
   t6r=t6
   t7r=t7
   t8r=t8
   t9r=t9
   if fieldpos('t10')#0
      t10r=t10
      t11r=t11
      t12r=t12
      t13r=t13
      t14r=t14
      t15r=t15
      t16r=t16
      t17r=t17
      t18r=t18
   else
      t10r=space(90)
      t11r=space(90)
      t12r=space(90)
      t13r=space(90)
      t14r=space(90)
      t15r=space(90)
      t16r=space(90)
      t17r=space(90)
      t18r=space(90)
   endif 
   if fieldpos('mt')#0
      sd0r=sd0
      rc1r=rc1
      sd1r=sd1
      rc0r=rc0
      mtr=mt  
   else
      store 0 to sd0r,rc1r,sd1r,rc0r
      store '   ' to mtr
   endif 
   utr=ut
   if gnAdm=1
      do case
         case lastkey()=22  && Добавить
              dbftins()
         case lastkey()=7   && Удалить
              netdel()   
              skip -1
              if bof()
                 go top  
              endif  
              rcskr=recn()
         case lastkey()=-3 && Коррекция
              dbftins(1)
         case lastkey()=-2 && Фильтр
              sele dir
              go top 
              do while .t.
                 rcdirr=slcf('dir',,,,,"e:dir h:'NPP' c:n(2) e:ndirc h:'Наименование' c:c(20) e:ndir h:'Путь' c:c(20)",,,,,,,'Директория')  
                 if lastkey()=27
                    forr='.t.'
                    exit
                 endif
                 go rcdirr
                 dirr=dir
                 if lastkey()=13
                    forr='.t..and.dir=dirr' 
                    exit
                 endif
              endd   
              sele dbft
              go top
              rcdbftr=recn()
      endc
   endif   
enddo
nuse()

stat func dbftins(p1)
if p1=nil
   sele dbft
   go bott
   nfr=nf+1
   alsr=space(6)
   fnamer=space(8)
   dirr=0
   dirnr=0
   indr=space(10)
   parentr=space(6)
   dopr=space(6)
   foxr=0
   fctovr=0
   rmupdtr=0
   poler=space(250)
   t1r=space(90)
   t2r=space(90)
   t3r=space(90)
   t4r=space(90)
   t5r=space(90)
   t6r=space(90)
   t7r=space(90)
   t8r=space(90)
   t9r=space(90)
   t10r=space(90)
   t11r=space(90)
   t12r=space(90)
   t13r=space(90)
   t14r=space(90)
   t15r=space(90)
   t16r=space(90)
   t17r=space(90)
   t18r=space(90)
   store 0 to sd0r,rc1r,sd1r,rc0r
   store '   ' to mtr
endif
cldbftins=setcolor('gr+/b,n/w')
wdbftins=wopen(1,1,23,80)
wbox(1)
do while .t.
   if p1=nil
      @ 0,1   say 'Номер' get nfr pict '999' 
   else
      @ 0,1   say 'Номер'+' '+str(nfr,3)
   endif
   @ 1,1   say 'Алиас' get alsr 
   @ 1,col()+1   say 'Имя' get fnamer
   @ 2,1   say 'Дир' get dirr  pict '9'
   @ 2,col()+1   say 'Нов.дир.' get dirnr pict '9'
   @ 2,col()+1   say 'CTOV' get fctovr pict '9' 
   @ 2,col()+1  say 'Удаленный' get rmupdtr pict '9'
   @ 3,1   say 'Армы инд.' get indr 
   @ 4,1   say 'Родитель' get parentr 
   @ 4,col()+1   say 'Доп' get dopr 
   @ 4,col()+1   say 'FOX ' get foxr pict '9'

   @ 1,50 say 'Обмен с удаленными складами'   
   @ 2,50 say 'SD0' get sd0r pict '9'
   @ 2,60 say 'RC1' get rc1r pict '9'
   @ 3,50 say 'SD1' get sd1r pict '9'
   @ 3,60 say 'RC0' get rc0r pict '9'
   @ 4,50 say 'MT ' get mtr  
   @ 4,60 say 'UT ' get utr  

   @  5,0  say 'Т1 ' get t1r
   @  6,0  say 'Т2 ' get t2r
   @  7,0  say 'Т3 ' get t3r
   @  8,0  say 'Т4 ' get t4r
   @  9,0  say 'Т5 ' get t5r
   @ 10,0  say 'Т6 ' get t6r
   @ 11,0  say 'Т7 ' get t7r
   @ 12,0  say 'Т8 ' get t8r
   @ 13,0  say 'Т9 ' get t9r
   @ 14,0  say 'Т10' get t10r
   @ 15,0  say 'Т11' get t11r
   @ 16,0  say 'Т12' get t12r
   @ 17,0  say 'Т13' get t13r
   @ 18,0  say 'Т14' get t14r
   @ 19,0  say 'Т15' get t15r
   read
   if lastkey()=27
      exit
   endif
   @ 20,60 prom 'Верно'
   @ 20,col()+1 prom 'Не верно'
   menu to vn
   if lastkey()=27
      exit
   endif
   if vn=1
      sele dbft
      if p1=nil
         locate for alltrim(als)==alsr
         if !foun()
             netadd()
         endif    
      endif
      netrepl('nf,als,fname,dir,dirn,ind,parent,dop,fox,fctov,rmupdt,t1,t2,t3,t4,t5,t6,t7,t8,t9',;
              'nfr,alsr,fnamer,dirr,dirnr,indr,parentr,dopr,foxr,fctovr,rmupdtr,t1r,t2r,t3r,t4r,t5r,t6r,t7r,t8r,t9r')
      if fieldpos('mt')#0
         netrepl('sd0,rc1,sd1,rc0,mt','sd0r,rc1r,sd1r,rc0r,mtr')  
      endif      
      if fieldpos('t10')#0
         netrepl('t10,t11,t12,t13,t14,t15,t16,t17,t18',;
         't10r,t11r,t12r,t13r,t14r,t15r,t16r,t17r,t18r')  
      endif
      netrepl('ut','utr')   
      rcdbftr=recn()
      exit
   endif
endd
wclose(wdbftins)
setcolor(cldbftins)
retu

