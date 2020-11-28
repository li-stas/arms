#include "common.ch"
#include "inkey.ch"
netUse('bs')
do while .t.
   set color to w+/n
   clear
   do while .t.
      clear gets
      set color to w+/n
      @ 0,0 to MAXROW(),79 double
      @ 2,27 say 'Режим просмотра остатков'
      @ 3,1 say '──────────────────────────────────────────────────────────────────────────────'
      @ MAXROW()-2,1 say '──────────────────────────────────────────────────────────────────────────────'
      @ MAXROW()-1,15 say '<ESC> - Выход        - Просмотр счета на экране'
      set color to gr+/n
      @ 4,26 say 'Остатки по оборотам по б/с'
      *показ справочника балансовых счетов
      @ 5,10 say 'Выберите счет : '
      bsr=0
      do whil bsr=0
         sele 1
         @ 5,28 get bsr pict '999999'
         read
         if lastkey()=K_ESC
            nuse('bs')
            return
         endi
         if bsr#0
            exit
         else
*            bsr=slct_bs(10,30,12)
            bsr=slcf('bs',,,,,"e:bs h:'Счет' c:n(6) e:nbs h:'Наименование' c:c(20)",'bs')
         endi
         exit
      endd
      if bsr=0
         nuse('bs')
         retu
      endi
      set color to r+/n,n/gr+,,,
      sele bs
      if !netseek('t1','bsr')
         @ MAXROW()-1,20
         wait 'Баллансового счета с этим кодом нет! Нажмите любую клавишу...'
         @ MAXROW()-1,0 clear
         set color to g/n,n/g,,,
         loop
      endi
      otch=obs
      nbsr=nbs
      nb=str(bsr,6)

      cod=readkey()
      if cod=12.or.cod=268
         nuse('bs')
         retu
      endif

      exit
   enddo
   set color to gr+/n
   @  5,28 clear to 5,78
   @  5,10 clea to 5,28
   @  5,28 say nb+' '+nbs
   @  6,1 say '──┬─────────────────────────┬─────────────────────────┬───────────────────────'
   @  7,1 say '  │     Входящее сальдо     │          Обороты        │    Исходящее сальдо   '
   @  8,1 say '  ├────────────┬────────────┼────────────┬────────────┼────────────┬──────────'
   @  9,1 say '  │    Дебет   │   Кредит   │    Дебет   │    Кредит  │     Дебет  │  Кредит  '
   @ 10,1 say '──┼────────────┼────────────┼────────────┼────────────┼────────────┼──────────'
   y=11
   bs2=-1
   d1=0
   d2=0
   d3=0
   d4=0
   kkk=1
   declare hh[1000]
   i=1
   do while i#1001
      hh[i]='0'
      i=i+1
   enddo
   j=1
   y=11
   do while .not.EOF()
      bs1=str(bs,6)
      bs2=substr(bs1,1,3)
      bs3=substr(bs1,4,3)
      bs1=val(bs2)
      d1=d1+dn
      d2=d2+kn
      d3=d3+db
      d4=d4+kr
      dnn=str(dn,12,2)
      if dn=0
         dnn=space(12)
      endif
      ff=bs3
      ff=ff+'│'+dnn
      knn=str(kn,12,2)
      if kn=0
         knn=space(12)
      endif
      ff=ff+'│'+knn
      dbb=str(db,12,2)
      if db=0
         dbb=space(12)
      endif
      ff=ff+'│'+dbb
      krr=str(kr,12,2)
      if kr=0
         krr=space(12)
      endif
      ff=ff+'│'+krr
      ras=(dn+db)-(kn+kr)
      if ras>0
         ff=ff+'│'+str(abs(ras),12,2)+'│          '
      endif
      if ras<0
*         ff=ff+'│            │'+str(abs(ras),12,2)
         ff=ff+'│            │'+str(abs(ras),11,2)
      endif
      if ras=0
         ff=ff+'│            │          '
      endif
      hh[j]=ff
      if y<22
         @ y,0 say ff
      endif
      skip
      kkk=kkk+1
      if eof()
         exit
      endif
      bs4=substr(str(bs,6),1,3)
      if val(bs4)#val(bs2)
         exit
      endif
      j=j+1
      y=y+1
   enddo
   if kkk>2
      j=j+1
      hh[j]='Итого по счету : '
      if y<22
         y=y+1
         @ y,1 say hh[j]
      endif
      kop=(d1+d3)-(d2+d4)
      f='   │'
      if (d2-d1)>0
         f=f+space(12)+'│'+str(abs(d2-d1),12,2)+'│'+str(d3,12,2)+'│'+str(d4,12,2)+'│'
      endif
      if (d2-d1)<0
         f=f+str(abs(d2-d1),12,2)+'│'+space(12)+'│'+str(d3,12,2)+'│'+str(d4,12,2)+'│'
      endif
      if (d2-d1)=0
         f=f+space(12)+'│'+space(12)+'│'+str(d3,12,2)+'│'+str(d4,12,2)+'│'
      endif
      if kop>0
         f=f+str(abs(kop),12,2)+'│'
      endif
      if kop<0
         f=f+space(12)+'│'+str(abs(kop),10,2)
      endif
      j=j+1
      hh[j]=f
      if y<22
         y=y+1
         @ y,0 say f
      endif
   endif
   if y>21
     j=12
     eo=0
     do while .t.
        asdf=inkey(0)
        do case
           case asdf=5
                eo=0
                k=k-10
                j=k
                if k<1
                   j=1
                endif
                @ 11,0 clear to 21,78
                y=11
                do while .t.
                   if len(hh[j])=1
                      eo=1
                      exit
                   endif
                   @ y,0 say hh[j]
                   y=y+1
                   j=j+1
                   if y=22
                      exit
                   endif
                enddo
                loop
           case asdf=27
                exit
           case asdf=24
                if eo#1
                   @ 11,0 clear to 21,78
                   y=11
                   do while .t.
                      if len(hh[j])=1
                         eo=1
                         exit
                      endif
                      @ y,0 say hh[j]
                      y=y+1
                      j=j+1
                      if y=22
                         exit
                      endif
                   enddo
                   k=j
                endif
                loop
        endcase
     enddo
   endif
   if y<22
      set color to w+/n
      @ MAXROW()-1,1 clear to MAXROW()-1,78
      @ MAXROW()-1,14 say 'КОНЕЦ СПИСКА : Для выхода нажмите любую клавишу ...'
      asdf=inkey(0)
   endif
enddo
nuse()
