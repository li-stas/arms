*
if gnScOut=0
   clea
   aqstr=1
   aqst:={"Просмотр","Коррекция"}
   aqstr:=alert("aaa",aqst)
   if lastkey()=27
      retu
   endif
else
   aqstr=2
endif   

set prin to dokz.txt

if gnScout=0
   set prin on
else
   set prin off
endif   

sele 0
use (gcPath_a+'doks')
copy stru to sdoks exte
use
sele 0
use sdoks
appe blank
repl field_name with 'ssd1',;
     field_type with 'N',;
     field_len with 13,;
     field_dec with 2
use
crea tdoks from sdoks
use
erase sdoks.dbf
sele 0
use tdoks excl
inde on str(mn,6)+str(rnd,6)+str(kkl,7) tag t1
sele 0
use (gcPath_a+'dokz')
copy stru to sdokz exte
use
sele 0
use sdokz.dbf
appe blank
repl field_name with 'sumd1',;
     field_type with 'N',;
     field_len with 15,;
     field_dec with 2
appe blank
repl field_name with 'sumk1',;
     field_type with 'N',;
     field_len with 15,;
     field_dec with 2
use
crea tdokz from sdokz
use
erase sdokz
sele 0
use tdokz excl
inde on str(bs,6)+dtos(ddc) tag t1

netuse('dokk')
netuse('doks')
netuse('dokz')
netuse('bs')
netuse('tipd')
netuse('speng')

sele dokk
n_nnnn=recc()
n_nnn=0
n_nn=0
set orde to tag t12
go top
if gnScout=0
   @ 1,60 say str(n_nnnn,10) 
endif
do while !eof()
   if gnScout=0
      if n_nn=1000
         n_nnn=n_nnn+1000
         @ 2,60 say str(n_nnn,10) 
         n_nn=0
      endif    
      n_nn=n_nn+1
   endif   
   if prc
      skip
      loop 
   endif  
   if mn=0
      skip
      loop 
   endif  
   if bs_d=99.or.bs_k=99
      skip
      loop 
   endif  
   mnr=mn
   rndr=rnd
   kklr=kkl
   bs_sr=bs_s
   bs_or=bs_o
   bs_dr=bs_d
   bs_kr=bs_k
   nplpr=nplp
   ddkr=ddk
   tipr=tip
   tipor=tipo
   rmskr=rmsk
   bs_or=bs_o
   nchekr=nchek
   sele doks
   if netseek('t1','mnr,rndr')  
      kkl_r=kkl
      nplp_r=nplp  
      sele dokk
      netrepl('kkl,nplp','kkl_r,nplp_r')   
   else
      netadd()
      netrepl('mn,kkl,nplp,rnd,ddc,tipo,tip,nchek','mnr,kklr,nplpr,rndr,ddkr,tipor,tipr,nchekr')
      ?str(mnr,6)+' '+str(rndr,6)+' '+'Добавлен в DOKS'
   endif 
   sele dokz
   if netseek('t2','mnr')
      ddcr=ddc
   else
      if !netseek('t1','bso_r,ddkr')
         netadd()
         netrepl('mn,ddc,bs','mnr,ddkr,bs_or')
         ?str(mnr,6)+' '+'Добавлен в DOKZ'
      else
         ?dtoc(dokz->ddc)+' '+str(dokz->mn,6)+'->DOKZ'+' '+str(mnr,6)+'->DOKK'
      endif   
      ddcr=ctod('')  
   endif
   sele dokk 
   if !empty(ddcr).and.ddcr#ddkr
      sele doks
      if netseek('t1','mnr,rndr')
         if ddc#ddcr
            netrepl('ddc','ddcr')  
         endif  
      endif
      sele dokk
      netrepl('ddk','ddcr')    
      ddkr=ddk
   endif
   tipor=tipo
   ktor=kg
   kopr=kop
   tipr=tip
   if tipr=0
      if kopr=22.or.kopr=5461.or.kopr=5464.or.kopr=5467.or.kopr=5482
         tipr=1
         netrepl('tip','tipr')
      endif
   endif 
   sele tipd
   seek str(tipor,2)+str(tipr,3)
   przr=prz
   sele dokk   
   netrepl('prz','przr')
   sele doks
   seek str(mnr,6)+str(rndr,6)+str(kklr,7)
   osnr=osn
   ssd1r=ssd
   netrepl('tipo,tip,prz','tipor,tipr,przr')
   sele tdoks
   seek str(mnr,6)+str(rndr,6)+str(kklr,7)
   if !foun()
      netadd()
      netrepl('mn,rnd,kkl,ssd,tipo,kto,tip,osn,nplp,ddc,ssd1,prz',;
              'mnr,rndr,kklr,bs_sr,tipor,ktor,tipr,osnr,nplpr,ddkr,ssd1r,przr') 
   else
      netrepl('ssd','ssd+bs_sr')  
   endif
   sele dokz
   seek str(bs_or,6)+dtos(ddkr)
   knsdr=knsd
   sumd1r=sumd
   knskr=knsk
   sumk1r=sumk
   sele tdokz
   if !netseek('t1','bs_or,ddkr')
      netadd()
      if bs_dr=bs_or
         netrepl('mn,bs,ddc,sumd,knsd,sumd1','mnr,bs_or,ddkr,bs_sr,knsdr,sumd1r')
      else
         netrepl('mn,bs,ddc,sumk,knsk,sumk1','mnr,bs_or,ddkr,bs_sr,knskr,sumk1r')
      endif  
   else   
      if mn=mnr   
         if bs_dr=bs_or
            netrepl('sumd','sumd+bs_sr')
         else
            netrepl('sumk','sumk+bs_sr')
         endif  
      else
      endif      
   endif   
   sele dokk
   skip
endd

?'DOKS'
sele tdoks
go top
do while !eof()
   mnr=mn
   rndr=rnd
   kklr=kkl
   ssdr=ssd
   ssd1r=ssd1
   sele doks
   if netseek('t1','mnr,rndr,kklr')
      if round(ssd,2)#round(ssdr,2)
         ?str(mnr,6)+' '+str(rndr,6)+' '+str(kklr,7)+' Н '+str(ssdr,12,2)+' Т '+str(ssd,12,2)
         if aqstr=2
            netrepl('ssd','ssdr')
         endif
      endif
   else
      ?str(mnr,6)+' '+str(rndr,6)+' '+str(kklr,7)+' Нет в текущем'
      if aqstr=2
         arec:={}
         sele tdoks
         getrec()
         sele doks
         netadd()
         putrec()
      endif
   endif
   sele tdoks
   skip
endd

sele doks
go top
do while !eof()
   mnr=mn
   rndr=rnd
   kklr=kkl
   ssdr=ssd
   sele tdoks
   if !netseek('t1','mnr,rndr,kklr')
      if ssdr#0
         ?str(mnr,6)+' '+str(rndr,6)+' '+str(kklr,7)+' '+str(ssdr,12,2)+' Нет в новом '
      endif   
      if aqstr=2
         sele doks
         netrepl('ssd','0')
      endif
   endif
   sele doks
   skip
endd

?'DOKZ'
sele tdokz
go top
do while !eof()
   bsr=bs   
   mnr=mn
   ddcr=ddc
   sumdr=sumd
   sumkr=sumk
   sumd1r=sumd1
   sumk1r=sumk1
   sele dokz
   if netseek('t1','bsr,ddcr')
      if round(sumdr,2)-round(sumd,2)#0.or.round(sumkr,2)-round(sumk,2)#0
         ?str(bsr,6)+' '+str(mnr,6)+' '+dtoc(ddcr)+' НД '+str(sumdr,12,2)+' ТД '+str(sumd,12,2)+' НК '+str(sumkr,12,2)+' ТК '+str(sumk,12,2)
         if aqstr=2
               netrepl('sumd,sumk','sumdr,sumkr')
         endif
      endif
   else
      ?str(bsr,6)+' '+str(mnr,6)+' '+dtoc(ddcr)+' '+str(sumdr,12,2)+' '+str(sumkr,12,2)+' Не найден в текущем'
      if aqstr=2
         arec:={}
         sele tdokz
         getrec()
         sele dokz
         netadd()
         putrec()
      endif
   endif
   sele tdokz
   skip
endd

sele dokz
go top
do while !eof()
   if mn=0
      netdel()
      skip
      loop       
   endif 
   bsr=bs   
   mnr=mn
   ddcr=ddc
   sumdr=sumd
   sumkr=sumk
   sele tdokz
   if !netseek('t1','bsr,ddcr')
      if sumdr#0.or.sumkr#0   
         ?str(bsr,6)+' '+str(mnr,6)+' '+dtoc(ddcr)+' '+str(sumdr,12,2)+' '+str(sumkr,12,2)+' Не найден в новом'
      endif  
      if aqstr=2
         sele doks
         if netseek('t1','mnr')    
            do while mn=mnr
               rndr=rnd
               kklr=kkl
               sele dokk
               if netseek('t1','mnr,rndr,kklr')
                  do while mn=mnr.and.rnd=rndr.and.kkl=kklr
                     netdel()
                     skip
                  endd 
               endif
               sele doks
               netrepl('ssd','0')
               sele doks
               skip
            endd
         endif
         sele dokz 
*         netdel()  
         netrepl('sumd,sumk','0,0')
      endif
   endif
   sele dokz
   skip
endd
sele tdoks
use
erase tdoks.dbf
erase tdoks.cdx
sele tdokz
use
*erase tdokz.dbf
*erase tdokz.cdx
nuse()
set prin off
set prin to
wmess('Проверка закончена',0)

func peredokz()

if gnEntrm=0
   retu .t.
endif

clea
aqstr=1
aqst:={"Просмотр","Коррекция"}
aqstr:=alert("aaa",aqst)
if lastkey()=27
   retu .t.
endif

crtt('crmn','f:mnold c:n(6) f:mnnew c:n(6)') 
sele 0
use crmn

netuse('dokz')  
netuse('doks')  
netuse('dokk')  

sele setup

locate for ent=gnEnt

sele dokk
go top
do while !eof()
   if mn=0
      sele dokk
      skip
      loop      
   endif
   if rmsk=0
      sele dokk
      skip
      loop      
   endif 
   if rmsk#gnRmsk
      sele dokk
      skip
      loop      
   endif
   mnr=mn 
   if int(mnr/100000)#gnRmsk
      sele crmn
      locate for mnold=mnr
      if !foun()
         appe blank
         repl mnold with mnr    
      endif           
   endif
   sele dokk
   skip
endd
sele crmn
go top
do while !eof()
   sele crmn 
   sele setup
   reclock()
   if int(dokzmn/100000)#gnRmsk
      repl dokzmn with gnRmsk*100000+dokzmn 
   endif 
   mnnewr=dokzmn
   sele dokk
   do while netseek('t1','mnnewr')
      mnnewr=mnnewr+1
   endd 
   sele setup
   netrepl('dokzmn','mnnewr+1')  
   sele crmn 
   netrepl('mnnew','mnnewr')
   skip
endd

?'DOKZ'
sele dokz
set orde to
go top
do while !eof()
   mnr=mn
   sele crmn
   locate for mnold=mnr
   if !foun()
      sele dokz
      skip
      loop  
   else
      mnnewr=mnnew
      sele dokz
      netrepl('mn','mnnewr')  
   endif
   sele dokz
   skip
endd
?'DOKS'
sele doks
set orde to
go top
do while !eof()
   mnr=mn
   sele crmn
   locate for mnold=mnr
   if !foun()
      sele doks
      skip
      loop  
   else
      mnnewr=mnnew
      sele doks
      netrepl('mn','mnnewr')  
   endif
   sele doks
   skip
endd
?'DOKK'
sele dokk
set orde to
go top
do while !eof()
   if mn=0
      sele dokk
      skip
      loop    
   endif
   mnr=mn
   sele crmn
   locate for mnold=mnr
   if !foun()
      sele dokk
      skip
      loop  
   else
      mnnewr=mnnew
      sele dokk
      netrepl('mn','mnnewr')  
   endif
   sele dokk
   skip
endd
nuse()
sele crmn
use
wmess('Проверка закончена',0)
retu .t.
