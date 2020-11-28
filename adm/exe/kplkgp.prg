* 
func dkklnsc()
if gnEnt#20
   retu
endif
clea
netuse('s_tag')
netuse('kplkgp')
netuse('cskl')
netuse('kpl')
netuse('kgp')
netuse('rmsk')
netuse('ctov')
netuse('stagm')
netuse('kln')
ktasr=0

kkl_rr=0 && По клиенту

aqstr=2
dt1r=ctod('01.09.2006')
dt2r=gdTd
clkpli=setcolor('gr+/b,n/w')
wkpli=wopen(10,10,12,70)
wbox(1)
@ 0,1 say 'Период ' get dt1r
@ 0,col()+1 get dt2r
read
wclose(wkpli)
setcolor(clkpli)
clea
if lastkey()=13
   for g=year(dt1r) to year(dt2r)
       if year(dt1r)=year(dt2r)
          m1=month(dt1r)
          m2=month(dt2r)
       else
          do case
             case g=year(dt1r)
                  m1=month(dt1r)
                  m2=12
             case g=year(dt2r)
                  m1=1
                  m2=month(dt2r)
             othe
                  m1=1
                  m2=12
          endc
       endif
       for m=m1 to m2
           path_dr=gcPath_e+'g'+str(g,4)+'\m'+iif(m<10,'0'+str(m,1),str(m,2))+'\'
           pathr=path_dr+'bank\'
           dirr=path_dr+'bank'
           if dirchange(dirr)#0
              loop
           endif
           tdtr=ctod('01.'+iif(m<10,'0'+str(m,1),str(m,2))+'.'+str(g,4))
           pdtr=addmonth(tdtr,-1)
           pathpbr=gcPath_e+'g'+str(year(pdtr),4)+'\m'+iif(month(pdtr)<10,'0'+str(month(pdtr),1),str(month(pdtr),2))+'\bank\'
           if !file(pathpbr+'dkklns.dbf') 
              pathpbr=''    
           endif   
           @ 1,1 say pathr  
           netuse('dkklns',,,1)
           netuse('dokk',,,1)
           set filt to !prc.and.(int(bs_d/1000)=361.or.int(bs_k/1000)=361).and.val(subs(dokkmsk,3,2))#0.and.bs_s#0.and.iif(kkl_rr=0,.t.,kkl=kkl_rr)
           go top   
           netuse('doks',,,1)
           if !empty(pathpbr)  
              ndkklns()
              pathr=path_dr+'bank\'
           endif  
           fdkklns()
           nuse('dkklns')
           nuse('dokk')
           nuse('doks')
       next
   next
   nuse('')
endif
nuse()
erase lstag.dbf 
wmess ('Проверка закончена',0)
retu .t.

func ndkklns()
pathr=pathpbr
netuse('dkklns','dkklnsp',,1)
sele dkklnsp
go top
do while !eof()
   if kkl=0
      skip
      loop  
   endif
   if skl=0
      skip
      loop  
   endif
   kklr=kkl
   if kkl_rr#0
      if kkl#kkl_rr
         skip
         loop  
      endif
   endif 
   bsr=bs
   sklr=skl
   store 0 to dnr,knr
   sldr=dn-kn+db-kr
   if sldr>0
      dnr=sldr   
   endif      
   if sldr<0
      knr=abs(sldr)   
   endif      
   sele dkklns
   if sldr#0 
      if netseek('t1','kklr,bsr,sklr') 
         netrepl('dn,kn','dnr,knr')
      else
         netadd()
         netrepl('kkl,bs,skl,dn,kn','kklr,bsr,sklr,dnr,knr')
      endif 
   endif
   sele dkklnsp
   skip
endd
sele dkklns
go top
do while !eof()
   if kkl=0
      netdel()
      skip
      loop
   endif
   if skl=0
      netdel()
      skip
      loop
   endif
   kklr=kkl
   if kkl_rr#0
      if kkl#kkl_rr
         skip
         loop  
      endif
   endif 
   bsr=bs
   sklr=skl
   sele dkklnsp
   if !netseek('t1','kklr,bsr,sklr')
      sele dkklns
      netdel() 
   endif
   sele dkklns
   skip
endd
nuse('dkklnsp')
retu .t.

func fdkklns()
* Коррекция DKKLNS
sele dkklns
if kkl_rr=0
   copy to ldkklns for skl#999.and.skl#0 
else
   copy to ldkklns for skl#999.and.skl#0.and.kkl=kkl_rr 
endif
sele 0
use ldkklns excl
go top
sele ldkklns
repl all dp with db,kp with kr,db with 0,kr with 0
inde on str(kkl,7)+str(bs,6)+str(skl,7) tag t1
store ctod('') to ddkr,ddbr
sele dokk
count to nnn
set orde to tag t4 && ddc
if gnScOut=0
   @ 2,1 say str(nnn,10)
endif
go top
n_nnn=0
n_nn=0
do while !eof()
   if gnScOut=0
*      if n_nn=1000
*         n_nnn=n_nnn+1000  
*         @ 3,1 say str(n_nnn,10)+' '+str(dokk->kkl,7)
*         n_nn=0 
*      endif
      @ 3,1 say str(n_nn,10)+' '+str(dokk->kkl,7)+' '+str(dokk->sk,3)
*      @ 3,1 say str(n_nnn,10)
      n_nn=n_nn+1
   endif
   ktasr=0 
   kkl_r=kkl
   nkkl_r=nkkl
   kpv_r=tab_n
   db_r=bs_d 
   kr_r=bs_k
   sum_r=bs_s
   ddkr=ddk
   mask_r=dokkmsk
   skl_r=skl
   mn_r=mn
   rnd_r=rnd
   kta_r=kta
   sk_r=sk 
   rn_r=rn  
   mnp_r=mnp
*if db_r=361002
*wait
*endif

  if subs(mask_r,3,1)='1'
      if mn_r=0    
         pathr=path_dr+alltrim(getfield('t1','sk_r','cskl','path'))     
         netuse('soper',,,1) 
         if mnp_r=0  
            netuse('rs1',,,1) 
            netuse('rs2',,,1) 
            cktasr=schkktas(0,sk_r,rn_r)
            nuse('rs1')  
            nuse('rs2')
         else
            netuse('pr1',,,1) 
            netuse('pr2',,,1) 
            cktasr=schkktas(1,sk_r,mnp_r)
            nuse('pr1')  
            nuse('pr2')
         endif 
         nuse('soper')
      else  
         cktasr=dchkktas(db_r,1,0,1)
      endif   
      ktasr=val(subs(cktasr,1,4))   
      ktar=val(subs(cktasr,5,4))   
      sele ldkklns
      if !netseek('t1','kkl_r,db_r,ktasr')
         netadd()
         netrepl('kkl,bs,skl,db,ddb,skl','kkl_r,db_r,0,sum_r,ddkr,ktasr')
      else
         ddbr=ddb
         netrepl('db,ddb','db+sum_r,iif(ddkr>ddbr,ddkr,ddbr)')
      endif
   endif   
   if subs(mask_r,4,1)='1'
      if mn_r=0    
         pathr=path_dr+alltrim(getfield('t1','sk_r','cskl','path'))     
         netuse('soper',,,1) 
         if mnp_r=0  
            netuse('rs1',,,1) 
            netuse('rs2',,,1) 
            cktasr=schkktas(0,sk_r,rn_r)
            nuse('rs1')  
            nuse('rs2')
         else
            netuse('pr1',,,1) 
            netuse('pr2',,,1) 
            cktasr=schkktas(1,sk_r,mnp_r)
            nuse('pr1')  
            nuse('pr2')
         endif 
         nuse('soper')
      else  
         cktasr=dchkktas(kr_r,2,0,1)
      endif   
      ktasr=val(subs(cktasr,1,4))   
      ktar=val(subs(cktasr,5,4))   
      sele ldkklns
      if !netseek('t1','kkl_r,kr_r,ktasr')
         netadd()
         netrepl('kkl,bs,skl,kr,dkr,skl','kkl_r,kr_r,0,sum_r,ddkr,ktasr')
      else
         dkrr=dkr
         netrepl('kr,dkr','kr+sum_r,iif(ddkr>dkrr,ddkr,dkrr)')
      endif
   endif   
   if ktasr#0
      sele doks 
      if netseek('t1','dokk->mn,dokk->rnd,dokk->kkl')
         if subs(osn,1,1)#'*'  
            if ktasr#0
               if ktasr#val(osn) 
*wait
               endif 
            endif      
         endif 
         netrepl('ktas','ktasr')
         if len(alltrim(osn))>10
            osnr=subs(osn,13,3)
            netrepl('osn','osnr') 
         endif 
      endif
   endif   
   sele dokk
   netrepl('mol,tab_n','ktasr,ktar')
   skip
endd

sele ldkklns
go top
do while !eof()
   if kkl_rr#0
      if kkl#kkl_rr
         skip
         loop  
      endif
   endif 
   kklr=kkl
   bsr=bs
   sklr=skl
   dnr=dn
   knr=kn
   dbr=db
   krr=kr
   dpr=dp
   kpr=kp
   ddbr=ddb
   dkrr=dkr
   sele dkklns
   seek str(kklr,7)+str(bsr,6)+str(sklr,7)
   if foun()
      netrepl('db,kr,ddb,dkr','dbr,krr,ddbr,dkrr') 
   else   
      netadd() 
      netrepl('kkl,bs,db,kr,skl,ddb,dkr,ktas','kklr,bsr,dbr,krr,sklr,ddbr,dkrr,ktasr') 
   endif 
   sele ldkklns
   skip
enddo
sele dkklns
go top
do while !eof()
   if kkl_rr#0
      if kkl#kkl_rr
         skip
         loop  
      endif
   endif 
   kklr=kkl
   bsr=bs
   sklr=skl
   dnr=dn
   knr=kn
   dbr=db
   krr=kr
   if !(dnr=0.and.knr=0)
      skip
      loop  
   endif 
   sele ldkklns
   seek str(kklr,7)+str(bsr,6)+str(sklr,7)
   if !foun()
      sele dkklns
      netdel()
   endif
   sele dkklns
   skip
   loop
endd
sele ldkklns
use
erase ldkklns.dbf
erase ldkklns.cdx
retu .t.


func nzdoc()
if gnEnt#20
   retu
endif
clea
netuse('s_tag')
netuse('kplkgp')
netuse('cskl')
netuse('kpl')
netuse('kgp')
netuse('rmsk')
netuse('ctov')
netuse('stagm')
netuse('kln')
netuse('nzdok')

kkl_rr=0 && По клиенту

aqstr=2
dt1r=ctod('01.09.2006')
dt2r=gdTd
clkpli=setcolor('gr+/b,n/w')
wkpli=wopen(10,10,12,70)
wbox(1)
@ 0,1 say 'Период ' get dt1r
@ 0,col()+1 get dt2r
read
wclose(wkpli)
setcolor(clkpli)
clea
if lastkey()=13
   for g=year(dt1r) to year(dt2r)
       if year(dt1r)=year(dt2r)
          m1=month(dt1r)
          m2=month(dt2r)
       else
          do case
             case g=year(dt1r)
                  m1=month(dt1r)
                  m2=12
             case g=year(dt2r)
                  m1=1
                  m2=month(dt2r)
             othe
                  m1=1
                  m2=12
          endc
       endif
       for m=m1 to m2
           path_dr=gcPath_e+'g'+str(g,4)+'\m'+iif(m<10,'0'+str(m,1),str(m,2))+'\'
           pathr=path_dr+'bank\'
           dirr=path_dr+'bank'
           if dirchange(dirr)#0
              loop
           endif
           @ 1,1 say pathr  
           netuse('dokk',,,1)
           set filt to !prc.and.(int(bs_d/1000)=361.or.int(bs_k/1000)=361).and.val(subs(dokkmsk,3,2))#0.and.bs_s#0.and.iif(kkl_rr=0,.t.,kkl=kkl_rr)
           go top   
           fnzdoc()
           nuse('dokk')
           nuse('doks')
       next
   next
   nuse('')
endif
nuse()
erase lstag.dbf 
wmess ('Проверка закончена',0)
retu .t.

func fnzdoc()
retu .t.



