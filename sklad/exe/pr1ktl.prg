  //Просмотр прихода по коду
save scre to scpr1ktl
ss=select()
store 0 to prpr1r,prpr2r
if select('pr1')=0
   netuse('pr1')
   prpr1r=1
endif
if select('pr2')=0
   netuse('pr2')
   prpr2r=1
endif
@ 0,1 say str(ktlr,9)+' '+natr
sele pr1
rpr1r=recn()
opr1r=indexord()
set orde to tag t2
sele pr2
rpr2r=recn()
opr2r=indexord()
set cent off
if tov_r=='tovm'.or.tov_r=='ctov'
   nazvr=str(mntovr,7)+' '+alltrim(natr)
   set orde to tag t4
   go top
   netseek('t4','mntovr')
   if gnMskl=1
      mn_r=slcf('pr2',,,,,"e:getfield('t2','pr2->mn','pr1','nd') h:'N док.' c:n(6) e:mn h:'Маш.N' c:n(6) e:getfield('t2','pr2->mn','pr1','kop') h:'КОП' c:n(3) e:getfield('t2','pr2->mn','pr1','amn') h:'Расход' c:n(6) e:iif(getfield('t2','pr2->mn','pr1','prz')=0,getfield('t2','pr2->mn','pr1','dvp'),getfield('t2','pr2->mn','pr1','dpr')) h:'Дата'  c:d(8) e:getfield('t2','pr2->mn','pr1','prz') h:'П' c:n(1) e:kf h:'Количество' c:n(10,3) e:zen h:'Цена' c:n(9,3) e:sf h:'Сумма' c:n(10,2) e:getfield('t2','pr2->mn','pr1','kps') h:'Поставщ' c:n(7)",'mn',,,'mntov=mntovr',"getfield('t2','pr2->mn','pr1','skl')=sklr",,nazvr)
   else
      mn_r=slcf('pr2',,,,,"e:getfield('t2','pr2->mn','pr1','nd') h:'N док.' c:n(6) e:mn h:'Маш.N' c:n(6) e:getfield('t2','pr2->mn','pr1','kop') h:'КОП' c:n(3) e:getfield('t2','pr2->mn','pr1','nnz') h:'Договор' c:c(6) e:iif(getfield('t2','pr2->mn','pr1','prz')=0,getfield('t2','pr2->mn','pr1','dvp'),getfield('t2','pr2->mn','pr1','dpr')) h:'Дата'  c:d(8) e:getfield('t2','pr2->mn','pr1','prz') h:'П' c:n(1) e:kf h:'Количество' c:n(10,3) e:zen h:'Цена' c:n(9,3) e:sf h:'Сумма' c:n(10,2) e:getfield('t2','pr2->mn','pr1','kps') h:'Поставщ' c:n(7)",'mn',,,'mntov=mntovr',,,nazvr)
   endif
else
   nazvr=str(ktlr,9)+' '+alltrim(natr)
   set orde to tag t6
   go top
   netseek('t6','ktlr')
   if gnMskl=1
      mn_r=slcf('pr2',,,,,"e:getfield('t2','pr2->mn','pr1','nd') h:'N док.' c:n(6) e:mn h:'Маш.N' c:n(6) e:getfield('t2','pr2->mn','pr1','kop') h:'КОП' c:n(3) e:getfield('t2','pr2->mn','pr1','nnz') h:'Договор' c:c(6) e:iif(getfield('t2','pr2->mn','pr1','prz')=0,getfield('t2','pr2->mn','pr1','dvp'),getfield('t2','pr2->mn','pr1','dpr')) h:'Дата'  c:d(8) e:getfield('t2','pr2->mn','pr1','prz') h:'П' c:n(1) e:getfield('t2','pr2->mn','pr1','otv') h:'O' c:n(1) e:kf h:'Количество' c:n(10,3) e:zen h:'Цена' c:n(9,3) e:sf h:'Сумма' c:n(10,2) e:getfield('t2','pr2->mn','pr1','kps') h:'Поставщ' c:n(7)",'mn',,,'ktl=ktlr',"getfield('t2','pr2->mn','pr1','skl')=sklr",,nazvr)
   else
      mn_r=slcf('pr2',,,,,"e:getfield('t2','pr2->mn','pr1','nd') h:'N док.' c:n(6) e:mn h:'Маш.N' c:n(6) e:getfield('t2','pr2->mn','pr1','kop') h:'КОП' c:n(3) e:getfield('t2','pr2->mn','pr1','nnz') h:'Договор' c:c(6) e:iif(getfield('t2','pr2->mn','pr1','prz')=0,getfield('t2','pr2->mn','pr1','dvp'),getfield('t2','pr2->mn','pr1','dpr')) h:'Дата'  c:d(8) e:getfield('t2','pr2->mn','pr1','prz') h:'П' c:n(1) e:getfield('t2','pr2->mn','pr1','otv') h:'O' c:n(1) e:kf h:'Количество' c:n(10,3) e:zen h:'Цена' c:n(9,3) e:sf h:'Сумма' c:n(10,2) e:getfield('t2','pr2->mn','pr1','kps') h:'Поставщ' c:n(7)",'mn',,,'ktl=ktlr',,,nazvr)
   endif
endif
set cent on
sele pr1
go rpr1r
set orde to (opr1r)
sele pr2
go rpr2r
set orde to (opr2r)

if prpr1r=1
   nuse('pr1')
endif
if prpr2r=1
   nuse('pr2')
endif

sele (ss)
rest scre from scpr1ktl

***************
func pr1ktla()
***************
*dppr=getfield('t5','sklr,mntovr','tov','dpp')
pathmr=gcPath_e+'g'+str(year(dppr),4)+'\m'+iif(month(dppr)<10,'0'+str(month(dppr),1),str(month(dppr),2))+'\'
pathr=pathmr+gcDir_t
if netfile('pr1',1)
   netuse('pr1',,,1)
   netuse('pr2',,,1)
   sele pr2
   if netseek('t4','mntovr')
      mnr=mn
      ktl_r=ktl
      sele pr1
      if netseek('t2','mnr')
         ndr=nd
         sksr=sks
         ttnr=amn
         nsksr=getfield('t1','sksr','cskl','nskl')
         sele cskl
         locate for sk=sksr
         skl_r=skl
         if foun()
            pathr=pathmr+alltrim(path)
            netuse('tov','tovfst',,1)
            dpp_r=getfield('t1','skl_r,ktl_r','tovfst','dpp')
            nuse('tovfst')
         else
            dpp_r=ctod('')
         endif
         wa=wopen(10,5,15,75)
         wbox(1)
         @ 0,1 say 'Дата прихода '+' '+dtoc(dppr)
         @ 1,1 say 'Со склада    '+' '+str(sksr,4)+' '+nsksr
         @ 2,1 say 'ТТН родитель '+' '+str(ttnr,6)
         @ 3,1 say 'Дата карточки'+' '+dtoc(dpp_r)
         inkey(0)
         wclose(wa)
      endif
   else
      wmess('Не найден',3)
   endif
   nuse('pr1')
   nuse('pr2')
endif
retu .t.
