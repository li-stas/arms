* ���稪�
if !netfile('gru')
   copy file (gcPath_a+'gru.dbf') to (gcPath_e+'gru.dbf')
   netind('gru')
endif
netuse('gru')
clea
do while .t.
   foot('INS,DEL,F4','��������,�������,���४��')
   rckgrur=slcf('gru',,,,,"e:kgru h:'���' c:n(7) e:ngru h:'�.�.�.' c:c(15) ",,,1,,,,'���稪�') 
   sele gru
   go rckgrur
   kgrur=kgru
   ngrur=ngru
   do case
      case lastkey()=22 
           gruins(0) 
      case lastkey()=7 
           netdel()
           skip -1
           if bof()
              go top 
           endif  
      case lastkey()=-3 
           gruins(1) 
      case lastkey()=27
           exit
   endc
endd
nuse()

funct gruins(p1)
if p1=0
   store 0 to kgrur
   store space(15) to ngrur
endif
clbs=setcolor('gr+/b,n/w')
wbs=wopen(10,20,14,60)
wbox(1)
do while .t.
   @ 0,1 say '���   '+str(kgrur,7)  
   @ 1,1 say '�.�.�.' get ngrur
   @ 2,1 prom '<��୮>'
   @ 2,col()+1 prom '<�� ��୮>'
   read
   if lastkey()=27
      exit
   endif
   menu to mgrur
   if mgrur=1
      if p1=0
         go bott
         kgrur=kgru+1
         if !netseek('t1','kgrur')
            netadd()
            netrepl('kgru,ngru','kgrur,ngrur')
            exit 
         else
            wmess('�訡�� ���������� ����',1)
            exit 
         endif
      else
         if netseek('t1','kgrur')
            netrepl('ngru','ngrur')
            exit
         endif
      endif 
   endif
enddo
wclose(wbs)
setcolor(clbs)
retu