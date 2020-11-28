****************Финансовое состояние клиента
para p1
* NIL-Вывод на экран
* 1  -Расчет  
local sllr,ecran1,oldc
sllr=sele()
if p1=NIL
   save screen to ecran 
   oldc=setcolor()
endif
store 0 to symkl
store '' to symklr
netUse('dkkln')
netUse('bs')

sele dkkln
if !netseek('t1','kplr')
   if p1=NIL
      wmess('Обороты по клиенту отсутствуют',3)
   endif
*   nuse('dkkln')
*   nuse('bs')
   select(sllr)
   retu
endif
do while kkl=kplr
   if getfield('t1','dkkln->bs','bs','uchr')#0
      symkl=symkl+dn-kn+db-kr+dp
   endif
   skip
enddo   
if symkl=0
   if p1=NIL
      wmess('Обороты по клиенту отсутствуют',3)
   endif
*   nuse('dkkln')
*   nuse('bs')
   select(sllr)
   retu
else
   if symkl>0
      symklr='дебет. задолж.  - '
   else
      symklr='кред. задолж.   - '
   endif
      if p1=NIL
         setcolor('n/w')
         @ 07,20 clea to 12,57
         @ 07,20 to 12,57 doubl 
         @ 07,25 say 'Финансовое состояние клиента:' color 'r/w'
         @ 09,25 say symklr+alltrim(str(symkl,14,2))
         inkey(0) 
         rest screen from ecran 
         setcolor(oldc) 
   endif
endif
*nuse('bs')
*nuse('dkkln')
select(sllr)
return



