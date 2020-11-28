********************
func nap()
********************
* Направления продаж
clea
netuse('nap')
if !netseek('t1','0')
   netadd()
   napr=0
   nnapr='Неопределено' 
   netrepl('nap,nnap','napr,nnapr') 
   go top
endif
netuse('naptm')
netuse('mkeep')
sele nap
rcnapr=recn()
do while .t.
   sele nap
   go rcnapr
   foot('INS,DEL,ENTER,F4','Добавить,Удалить,ТМ,Коррекция')
   rcnapr=slcf('nap',1,1,18,,"e:nap h:'Код' c:n(4) e:nnap h:'Наименование' c:c(20)",,,1,,,,'Напрвления')
   if lastkey()=27
      exit
   endif 
   go rcnapr
   napr=nap
   nnapr=nnap
   prnapr=prnap
   do case
      case lastkey()=22 && INS
           napins()
      case lastkey()=-3 && CORR
           napins(1)
      case lastkey()=7.and.napr#0.and.gnAdm=1  && DEL
           sele naptm
           if netseek('t1','napr')  
              do while nap=napr
                 netdel()
                 skip     
              endd 
           endif
           sele nap
           netdel()
           skip -1
           if bof()
              go top 
           endif    
           rcnapr=recn()   
      case lastkey()=13.and.napr#0 && ТМ
           save screen to scff   
           naptm()   
           rest screen from scff
   endc
endd
nuse()
retu .t.

func napins(p1)
if p1=nil
   store 0 to napr,prnapr
   nnapr=space(20)
   sele nap
   go bott
   if !eof()
      napr=nap+1
   else
      napr=1
   endif   
   if netseek('t1','napr')
      wmess('Ошибка добавления нового кода')
      retu .t.
   endif
endif
cler=setcolor('gr+/b,n/w')
wer=wopen(10,15,15,60)
wbox(1)
do while .t.
   @ 0,1 say 'Код'+' '+str(napr,4)
   @ 1,1 say 'Наименование' get nnapr 
   @ 2,1 say 'Процент     ' get prnapr pict '999.99'
   @ 3,1 prom '<Верно>'
   @ 3,col()+1 prom '<Не верно>'
   read
   if lastkey()=27
      exit
   endif
   nnapr=upper(nnapr)
   menu to mer
   if mer=1
      if p1=nil
         if !netseek('t1','napr')
            netadd()
            netrepl('nap,nnap,prnap','napr,nnapr,prnapr')
            rcnapr=recn()
            exit
         else
            wselect(0)
            save scre to scer
            mess('Такой код существует',1)
            rest scre from scer
            wselect(wer)
         endif
      else
         if netseek('t1','napr')
            netrepl('nnap,prnap','nnapr,prnapr')
            exit
         endif
      endif
   endif
enddo
wclose(wer)
setcolor(cler)
retu .t.

func naptm()
sele naptm
if !netseek('t1','napr')
   go top
endif
rcnaptmr=recn()
do while .t.
   sele naptm
   go rcnaptmr
   foot('INS,DEL,F4','Добавить,Удалить,Коррекция')
   rcnaptmr=slcf('naptm',1,30,18,,"e:mkeep h:'Код' c:n(3) e:getfield('t1','naptm->mkeep','mkeep','nmkeep') h:'Наименование' c:c(20)",,,1,'nap=napr',,,'Торговые марки')
   if lastkey()=27
      exit
   endif 
   go rcnaptmr
   mkeepr=mkeep
   do case
      case lastkey()=22 && INS
           naptmins()
      case lastkey()=-3 && CORR
           naptmins(1)
      case lastkey()=7  && DEL
           netdel()
           skip -1
           if bof()
              go top 
           endif    
           rcnaptmr=recn()   
   endc        
endd
retu .t.

func naptmins()
if select('sl')#0
   sele sl
   use
endif
sele 0
use _slct alias sl excl
zap
sele mkeep
set orde to tag t2
go top
rcmkr=recn()
formker=".t..and.mkeep->mkeep#0"
do while .t.
   foot('SPACE,ENTER','Отбор,Выполнить')
   sele mkeep
   go rcmkr
   mkeepr=slcf('mkeep',,,,,"e:mkeep h:'Код' c:n(3) e:nmkeep h:'Наименование' c:c(30)",'mkeep',1,,,formker,,'Маркодержатели')
   if lastkey()=27
      exit
   endif
   sele mkeep
   locate for mkeep=mkeepr
   rcmkr=recn()
   if lastkey()=13
      sele sl
      go top
      do while !eof()
         mkeepr=val(kod) 
         sele naptm
         if !netseek('t1','napr,mkeepr')
            netadd()
            netrepl('nap,mkeep','napr,mkeepr')    
            rcnaptmr=recn()   
         endif 
         sele sl
         skip
      endd
      exit
   endif
endd
sele sl
zap
use
retu .t.

