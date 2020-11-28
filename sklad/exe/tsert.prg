sele tara
netseek('t1','kplr')
if !FOUND()
   save scre to scmess
   mess('Этот клиент не отслеживается по таре',3)
   rest scre from scmess
   retu
endif
tkdayr=tkday
if empty(dotr)
   save scre to scmess
   mess('Сначала распечатайте документ',3)
   rest scre from scmess
   retu
endif
sele rs2
set orde to tag t1
seek str(ttnr,6)+space(3)
if !FOUND()
   save scre to scmess
   mess('В этой ТТН нет тары',3)
   rest scre from scmess
   retu
endif
dtsertr=dotr
netuse('tsert',,'s')
set orde to tag t2
seek str(gnSk,3)+str(ttnr,6)
if !FOUND()
   set orde to tag t1
   go bott
   tsertr=tsert+1
   netadd()
   netrepl('tsert,sk,ttn,dtsert','tsertr,gnSk,ttnr,dtsertr')
else
   tsertr=tsert
   dtsertr=dtsert
endif
sele tsert
use
sele kln
netseek('t1','kplr')
if FOUND()
   if !empty(kkl1)
      kkl1r=kkl1
   else
      kkl1r=kplr
   endif
   adrr=alltrim(adr)
   nklr=alltrim(nkl)
   setprc(0,0)
   set devi to prin
   @ 1,1 say'                                Сертификат N '+alltrim(str(tsertr,6))
   @ prow()+1,1 say '                на сдачу тары, отгруженной '+dtoc(dtsertr)
   @ prow()+1,1 say '          по ТТН N '+str(ttnr,6)+' в адрес '+nklr+' '+adrr
   @ prow()+1,1 say  ''
   @ prow()+1,1 say '┌──────────────────────────────┬──────────┬──────────┬─────┬──────────┬────────┐'
   @ prow()+1,1 say '│       Наименование           │   Цена   │Количество│Ед.из│   Сумма  │  Дата  │'
   @ prow()+1,1 say '│          тары                │          │          │     │          │возврата│'
   @ prow()+1,1 say '├──────────────────────────────┼──────────┼──────────┼─────┼──────────┼────────┤'
   sele rs2
   netseek('t1','ttnr')
   do while ttn=ttnr
      if int(ktl/1000000)#0
         skip
         loop
      endif
      ktlr=ktl
      kvpr=kvp
      zenr=zen
      svpr=svp
      sele tov
      netseek('t1','sklr,ktlr')
      if FOUND()
         dvozr=dtsertr+tkdayr
         @ prow()+1,1 say '│'+nat+'│'+str(zenr,10,3)+'│'+str(kvpr,10,3)+'│'+nei+'│'+str(svpr,10,2)+'│'+dtoc(dvozr)+'│'
      endif
      sele rs2
      skip
   enddo
   @ prow()+1,1 say '└──────────────────────────────┴──────────┴──────────┴─────┴──────────┴────────┘'
   @ prow()+1,1 say ''
   @ prow()+1,1 say '   Тара подлежит возврату '+alltrim(gcName_c)+' ,находящемуся по адресу '
   @ prow()+1,1 say alltrim(gcAdr_c)+' ,в течение '+alltrim(str(tkdayr,3))+' дней с момента '
   @ prow()+1,1 say 'получения товара.'
   @ prow()+1,1 say '   За просрочку возврата тары до 15 дней,"ПОКУПАТЕЛЬ" уплачивает "ТАРОПОЛУЧАТЕЛЮ"'
   @ prow()+1,1 say ' штраф в размере 150 процентов стоимости не возвращенной в срок тары,'
   @ prow()+1,1 say 'а свыше 15 дней - 300 процентов.'
   @ prow()+1,1 say '   При возврвте тары в комплекте с отгрузочными документами обязательно '
   @ prow()+1,1 say 'представление настоящего сертификата.В противном случае, расчеты за'
   @ prow()+1,1 say 'невозвращенную тару производятся по ценам, существующим на момент образования'
   @ prow()+1,1 say 'первоначальной задолженности данного "ПОКУПАТЕЛЯ".'
   @ prow()+1,1 say ''
   @ prow()+1,1 say ''
   @ prow()+1,1 say '                                                      -------------------------- '
   @ prow()+1,1 say '                                                               подпись'
   set devi to scre
endif

