* Настройки касс
clea
netuse('kassa')
netuse('kassae')
sele kassa
go top
rcksr=recn()
do while .t.
   sele kassa
   go rcksr
   foot('ENTER,F4','Пользователь,Коррекция')
   rcksr=slcf('kassa',2,,4,,"e:kassa h:'Код' c:n(2) e:nkassa h:'Наименование' c:c(15) e:host h:'HOST' c:c(15) e:ports h:'PORTS' c:n(5) e:artno h:'СчАрт' c:n(9) e:nchek h:'СчЧек' c:n(6) e:konds h:'NDS' c:n(1)",,,1,,,,'КАССЫ')
   if lastkey()=27
      exit
   endif
   sele kassa
   go rcksr
   kassar=kassa
   nkassar=nkassa
   artnor=artno
   hostr=host
   portsr=ports
   nchekr=nchek
   kondsr=konds
   do case
      case lastkey()=13
           kassae() 
      case lastkey()=22
           kassai()  
      case lastkey()=-3
           kassai(1)  
      case lastkey()=7
           sele kassae
           go top
           do while !eof()
              if kassa#kassar
                 skip
                 loop   
              endif
              netdel() 
              skip  
           endd   
           sele kassa
           netdel()
           skip -1
           if bof()
              go top
           endif      
           rcksr=recn()
   endc 
endd
nuse()

func kassae()
sele kassae
go top
rckser=recn()
do while .t.
   sele kassae
   go rckser  
   foot('F4','Коррекция')
   rckser=slcf('kassae',,,,,"e:remotehost h:'RemHost' c:c(15) e:ssh_client h:'SSH' c:c(15)",,,,,'kassa=kassar',,str(kassar,1)+' '+nkassar)
   if lastkey()=27
      exit
   endif
   sele kassae
   go rckser
   rmhr=remotehost
   sshclr=ssh_client
   do case
      case lastkey()=22
           kassaei()   
      case lastkey()=-3
           kassaei(1)   
      case lastkey()=7
           netdel()
           skip -1
           if bof()
              go top
           endif      
           rckser=recn()
   endc
endd 
retu .t.

func kassai(p1)
if p1=nil
   store 0 to kassar,artnor,nchekr,kondsr
   store space(15) to hostr
   store space(10) to nkassr
endif
clks=setcolor('gr+/b,n/w')
wks=wopen(9,10,17,70)
wbox(1)
do while .t.
   @ 0,1 say 'Касса       '+' '+str(kassar,2)
   @ 1,1 say 'Наименование' get nkassar
   @ 2,1 say 'Сч Арт      ' get artnor pict '999999999'
   @ 3,1 say 'Сч Чеков    ' get nchekr pict '999999'
   @ 4,1 say 'HOST        ' get hostr
   @ 5,1 say 'PORTS       ' get portsr pict '99999'
   @ 6,1 say 'Отнош. к НДС' get kondsr pict '9'
   read
   if lastkey()=27.or.lastkey()=13
      exit
   endif
endd
wclose(wks)
setcolor(clks)
if lastkey()=13
   if p1=nil
      sele kassa
      go bott
      kassar=kassa+1
      netadd()
      netrepl('kassa','kassar')
      rcksr=recn()
   endif
   netrepl('nkassa,artno,nchek,host,ports,konds','nkassar,artnor,nchekr,hostr,portsr,kondsr')
endif
retu .t.

func kassaei(p1)
if p1=nil
   store space(15) to rmhr,sshclr
endif
clks=setcolor('gr+/b,n/w')
wks=wopen(10,10,14,70)
wbox(1)
do while .t.
   @ 0,1 say 'RemoteHost' get rmhr
   @ 1,1 say 'SSH_Client' get sshclr
   read
   if lastkey()=27.or.lastkey()=13
      exit
   endif
endd
wclose(wks)
setcolor(clks)
if lastkey()=13
   if p1=nil
      sele kassae
      netadd()
      netrepl('kassa','kassar')
      rckser=recn()
   endif
   netrepl('remotehost,ssh_client','rmhr,sshclr')
endif
retu .t.
