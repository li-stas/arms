#include "inkey.ch"
netuse('bs')
rcbsr=recn()
clea
do while .t.
   foot('INS,DEL,F3,F4,F6','Добавить,Удалить,Поиск,Коррекция,Нач')
   bsr=slcf('bs',1,,18,80,"e:bs h:'Счет' c:n(6) e:nbs h:'Наименование' c:c(15) e:dn h:'Дб.нач.' c:n(10,2) e:kn h:'Кр.нач.' c:n(10,2) e:db h:'Дебет' c:n(10,2) e:kr h:'Кредит' c:n(10,2) e:tipo h:'То' c:n(2) e:bsm h:'Сч.М' c:n(6) e:uchr h:'П' c:n(1)",'bs',,1)
*   bsr=slcf('bs',1,,18,,"e:bs h:'Счет' c:n(4) e:nbs h:'Наименование' c:c(19) e:dn h:'Дб.нач.' c:n(10,2) e:kn h:'Кр.нач.' c:n(10,2) e:db h:'Дебет' c:n(10,2) e:kr h:'Кредит' c:n(10,2) e:tipo h:'То' c:n(2) e:bsm h:'Сч.М' c:n(4)",'bs')
   sele bs
   netseek('t1','bsr')
   rcbsr=recn()
   nbsr=nbs
   dnr=dn
   knr=kn
   dbr=db
   krr=kr
   tipor=tipo
   bsmr=bsm
   uchrr=uchr
   tvedr=tved
   do case
    case lastkey()=22 .and. (dkklnr=1.or.gnadm=1)
          bsins(0)
    case lastkey()=7 .and. (dkklnr=1.or.gnadm=1)
          if netseek('t1','bsr')
             netdel()
          endi
    case lastkey()=-4 .and. (dkklnr=1.or.gnadm=1)
*       PereBsZap2(bsr)
    case lastkey()=-3 .and. (dkklnr=1.or.gnadm=1)
          bsins(1)
    case lastkey()=K_ESC
          exit
    case lastkey()=K_F3
          clbs=setcolor('gr+/b,n/w')
          wbs=wopen(10,30,12,50)
          wbox(1)
          stor 0 to bsr
          @ 0,1 say 'Счет ' get bsr pict '999999'
          read
          if lastkey()=13
            if bsr=0
                go top
            else
                netseek('t1','bsr')
            endif
          endi
          wclose(wbs)
          setcolor(clbs)
    case lastkey()=-5
*         bsn()
         sele bs
         go rcbsr
   endc
endd
nuse()

funct bsins(p1)
if p1=0
   store 0 to bsr,tipor,bsm,dnr,knr,bsmr,uchrr,tvedr
   nbsr=space(30)
endif
clbs=setcolor('gr+/b,n/w')
wbs=wopen(10,20,21,60)
wbox(1)
do while .t.
   if p1=0
      @ 0,1 say 'Счет        ' get bsr pict '999999'
   else
      @ 0,1 say 'Счет         '+str(bsr,6)
   endif
   @ 1,1 say 'Наименование' get nbsr
   @ 2,1 say 'Группа докум' get tipor pict '99'
   @ 3,1 say 'Счет М      ' get bsmr pict '999999'
   @ 4,1 say 'Дебет на нач' get dnr pict '9999999.99'
   @ 5,1 say 'Кред. на нач' get knr pict '9999999.99'
   @ 6,1 say 'Расч. клиент' get uchrr pict'9'
   @ 7,1 say 'Тип ведомост' get tvedr pict '9'
   @ 8,1 prom '<Верно>'
   @ 8,col()+1 prom '<Не верно>'
   read
   if lastkey()=K_ESC
      exit
   endif
   menu to mbsr
   if mbsr=1
      if p1=0
         if !netseek('t1','bsr')
            netadd()
            netrepl('bs,nbs,tipo,bsm,dn,kn,uchr,tved','bsr,nbsr,tipor,bsmr,dnr,knr,uchrr,tvedr')
            exit
         else
            wselect(0)
            save scre to scbsins
            mess('Такой счет существует',1)
            rest scre from scbsins
            wselect(wbs)
         endif
      else
         if netseek('t1','bsr')
            netrepl('nbs,tipo,bsm,dn,kn,uchr,tved','nbsr,tipor,bsmr,dnr,knr,uchrr,tvedr')
            exit
         endif
      endif
   endif
enddo
wclose()
setcolor(clbs)
retu


func bsn()
save scre to scbsn
clea
dtr=bom(gdTd)-1
yy_r=year(dtr)
mm_r=month(dtr)
pathr=gcPath_e+'g'+str(yy_r,4)+'\m'+iif(mm_r<10,'0'+str(mm_r,1),str(mm_r,2))+'\bank\'
netuse('bs','bsp',,1)
aqstr=1
aqst:={"Просмотр","Коррекция"}
aqstr:=alert(" ",aqst)
if lastkey()=K_ESC
   rest scre from scbsn
   nuse('bsp')
   retu .t.
endif
sele bsp
if gnOut=2
   set prin to bsn.txt
   set prin on
endif
do while !eof()
   bsr=bs
   dnr=dn
   knr=kn
   dbr=db
   krr=kr
   aaa=dnr-knr+dbr-krr
   store 0 to dn_r,kn_r
   if aaa>0
      dn_r=aaa
   endif
   if aaa<0
      kn_r=abs(aaa)
   endif
   sele bs
   if netseek('t1','bsr')
      if str(dn,12,2)#str(dn_r,12,2).or.str(kn,12,2)#str(kn_r,12,2)
         ?str(bsr,6)
         ?'П '+str(dn_r,12,2)+' '+str(kn_r,12,2)+' Т '+str(dn,12,2)+' '+str(kn,12,2)
         if aqstr=2
            netrepl('dn,kn','dn_r,kn_r')
         endif
      endif
   else
      if dn_r#0.or.kn_r#0
         netadd()
         ?'П '+str(dn_r,12,2)+' '+str(kn_r,12,2)+' Т нет'
      endif
   endif
   sele bsp
   skip
endd
nuse('bsp')
if gnOut=2
   set prin off
   set prin to txt.txt
endif
wmess('Коррекция закончена',0)
rest scre from scbsn
retu .t.
