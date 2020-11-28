******* Добавление доступа пользователю ****************
para corr
save scre to scktoe
if select('sl')=0
   sele 0
   use _slct alia sl excl
endif
sele sl
zap
sele cskl
go top
rec_r=recn()
do while .t.
   foot('SPACE,ESC','Отбор,Отмена')
   skr=slcf('cskl',1,39,19,,"e:sk h:'SK' c:n(3) e:ent h:'П' c:n(2) e:nskl h:'Наименование' c:c(30)",'sk',1,1,,'ent=gnEnt')
   netseek('t1','skr')
   rec_r=recn()
   do case
      case lastkey()=27
           exit
      case lastkey()=22
           go rec_r
           loop
   endc
enddo
rest scre from scktoe
retu
