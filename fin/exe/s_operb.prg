#include "common.ch"
#include "inkey.ch"
clea
netuse('dokk')
netuse('operb')
store 0 to kopr,dbr,krr
do while .t.
   nopr=nop
   dbr=db
   krr=kr
   maskr=mask
   pdr=pd
   zdr=zd
   bdr=bd
   pkr=pk
   zkr=zk
   bkr=bk
   foot('INS,DEL,F4,F7,ESC','Добавить,Удалить,Коррекция,Фильтр,Выход')
   kopr=slcf('operb',1,,18,,"e:kop h:'КОП' c:n(4) e:nop h:'Наименование' c:c(27) e:db h:'Дб' c:n(6) e:kr h:'Кр' c:n(6) e:mask h:'Маска' c:c(6) e:pd h:'PD' c:n(1) e:zd h:'ZD' c:n(1) e:bd h:'BD' c:n(1) e:pk h:'PK' c:n(1) e:zk h:'ZK' c:n(1) e:bk h:'BK' c:n(1)",'kop')
   netseek('t1','kopr')
   nopr=nop
   dbr=db
   krr=kr
   maskr=mask
   pdr=pd
   zdr=zd
   bdr=bd
   pkr=pk
   zkr=zk
   bkr=bk
   do case
      case lastkey()=22 .and. (dkklnr=1.or.gnadm=1)
           operbins(0)
      case lastkey()=7 .and. (dkklnr=1.or.gnadm=1)
           if netseek('t1','kopr')
              if kopr<9000
                 sele dokk
                 if netseek('t2','dbr,krr')
                    save screen to operbins
                    mess('Проводка используется! Удалять нельзя!',2)
                    rest screen from operbins
                    sele operb
                    loop
                 endif
              endif
              sele operb
              netdel()
              skip-1
           endif
      case lastkey()=-3 .and. (dkklnr=1.or.gnadm=1)
           operbins(1)
      case lastkey()=-6
           operbflt()
      case lastkey()=K_ESC
           exit
   endc
enddo
nuse('dokk')
nuse('operb')

func operbins(p1)
local pkor
pkor=0
if p1=0
   store 0 to kopr,dbr,krr,pdr,zdr,bdr,pkr,zkr,bkr
   maskr=space(6)
   nopr=space(20)
else
   if kopr<9000
      sele dokk
      if netseek('t2','dbr,krr')
         save scre to scoperbins
         mess('Проводка используется! Дебет и Кредит не корректируются!',2)
         rest scre from scoperbins
         pkor=1
         sele operb
         netseek('t1','kopr')
      endif
         sele operb
         netseek('t1','kopr')

   endif
endif

cloperbins=setcolor('gr+/b,n/w')
woperbins=wopen(5,20,19,60)
wbox(1)
do while .t.
   if p1=0
      sele operb
      go bott
      kopr=kop+1
      @ 0,1 say 'Код         ' get kopr pict '9999'
   else
      @ 0,1 say 'Код          '+str(kopr,4)
   endif
   @ 1,1 say 'Наименование' get nopr
   if pkor=1
      @ 2,1 say 'Дебет       ' + str(dbr,6)
      @ 3,1 say 'Кредит      ' + str(krr,6)
   else
      @ 2,1 say 'Дебет       ' get dbr pict '999999'
      @ 3,1 say 'Кредит      ' get krr pict '999999'
   endif
   @ 4,1 say 'Маска       ' get maskr
   @ 5,1 say 'Признак Дб  ' get pdr pict '9'
   @ 6,1 say 'Знак    Дб  ' get zdr pict '9'
   @ 7,1 say 'Замена  Дб  ' get bkr pict '9'
   @ 8,1 say 'Признак Кр  ' get pkr pict '9'
   @ 9,1 say 'Знак    Кр  ' get zkr pict '9'
   @ 10,1 say 'Замена  Кр  ' get bkr pict '9'
  @ 12,1 prom '<Верно>'
   @ 12,col()+1 prom '<Не верно>'
   read
   if lastkey()=K_ESC
      sele operb
      exit
   endif
   menu to minsr
   if minsr=1
      if p1=0
         if !netseek('t1','kopr')
            locate for db=dbr.and.kr=krr
            if !found()
               netadd()
               netrepl('kop,db,kr,mask,nop,pd,zd,bd,pk,zk,bk,pl','kopr,dbr,krr,maskr,nopr,pdr,zdr,bdr,pkr,zkr,bkr,0')
               exit
            else
               wmess('Такая проводка в KOP='+str(kop,4),2)
            endif
         else
            wselect(0)
            save scre to scoperbins
            mess('Такой код уже есть',1)
            rest scre from scoperbins
            wselect(woperbins)
         endif
      else
         if netseek('t1','kopr')
            if db#dbr.or.kr#krr.or.mask#maskr.or.nop#nopr.or.pd#pdr.or.zd#zdr.or.bd#bdr.or.pk#pkr.or.zk#zkr.or.bk#bkr
               netrepl('pl','0')
            endif
            netrepl('db,kr,mask,nop,pd,zd,bd,pk,zk,bk','dbr,krr,maskr,nopr,pdr,zdr,bdr,pkr,zkr,bkr')
         endif
      endif
      exit
   endif
   sele operb
enddo
wclose(woperbins)
setcolor(cloperbins)
retu

proc operbflt
priv kopr,dbr,krr
cloperbflt=setcolor('gr+/b,n/w')
woperbflt=wopen(10,20,15,50)
wbox(1)
do while .t.
   stor 0 to kopr,dbr,krr
   @ 0,1 say 'Код         ' get kopr pict '9999'
   @ 1,1 say 'Дебет       ' get dbr pict '999999'
   @ 2,1 say 'Кредит      ' get krr pict '999999'
   read
   do case
      case lastkey()=K_ESC
           exit
      case lastkey()=13
           if kopr=0.and.dbr=0.and.krr=0
              set filt to
              go top
           else
              sele operb
              do case
                 case kopr#0
                      set filt to
                      go top
                      if !netseek('t1','kopr')
                         go top
                      endif
                 case kopr=0
                      do case
                         case dbr#0.and.krr#0
                              set filt to db=dbr.and.kr=krr
                              go top
                         case dbr#0.and.krr=0
                              set filt to db=dbr
                              go top
                         case dbr=0.and.krr#0
                              set filt to kr=krr
                              go top
                      endc
                      if bof().and.eof()
                         set filt to
                         go top
                      endif
              endc
           endif
           exit
   endc
enddo
wclose(woperbflt)
setcolor(cloperbflt)
retu
