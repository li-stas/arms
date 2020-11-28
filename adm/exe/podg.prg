* Подготовка
retu
clea
if gnOut=1
  set prin to txt.txt   
endif
set print on
copy file (gcPath_a+'dokk.dbf') to (gcPath_l+'\dok_k.dbf')
copy file (gcPath_a+'dokk.dbf') to (gcPath_l+'\dokk100.dbf')
copy file (gcPath_a+'dkkln.dbf') to (gcPath_l+'\dkkln.dbf')
copy file (gcPath_a+'bs.dbf') to (gcPath_l+'\bs.dbf')
copy file (gcPath_a+'dokz.dbf') to (gcPath_l+'\dok_z.dbf')
copy file (gcPath_a+'doks.dbf') to (gcPath_l+'\dok_s.dbf')

store 0 to mnr,rndr,rnr,bs_dr,bs_kr,bs_sr,kopr,vor,kklr,mnpr,nplpr,;
           kgr,pdrr,konr,kszr,skr,prnnr,ndsr,sklr 
store ctod('') to ddkr           

store 0 to bsr,dnr,knr,dbr,krr,dpr,kpr,spvr
store ctod('') to dkrr,ddbr           

store 0 to tipor,bsmr
store space(20) to nbsr,obsr

sele 0
use dok_k alias dokk excl
inde on str(mn,6)+str(rnd,6)+str(kkl,7)+str(rn,6) to dokk
sele 0
use dokk100 excl
inde on str(mn,6)+str(rnd,6)+str(kkl,7)+str(rn,6) to dokk100
sele 0
use dkkln excl
save scre to scmess
mess('Остатки на начало DKKLN')
appe from (gcPath_d+'bank\dkkln.dbf') fields kkl,skl,bs,dn,kn,spvr
inde on str(kkl,7)+str(bs,6)+str(skl,7) to dkkln
sele 0
use bs excl
mess('Остатки на начало BS   ')
appe from (gcPath_d+'bank\bs.dbf') fields bs,nbs,dn,kn,tipo,obs,bsm,uchr
inde on str(bs,6) to bs
rest scre from scmess
aa=1
if aa=1
save scre to scmess
?'Документы бухгалтерии'
mess('Документы бухгалтерии')
pathr=gcPath_d+'bank\'
netuse('dokk','dokks',,1)
netuse('operb',,,1)
sele dokks
set softseek on
seek str(1,6)
set softseek off
do while !eof()
   if mn=0
      skip
      loop   
   endif
   mnr=mn
   rndr=rnd
   rnr=rn
   bs_dr=bs_d
   bs_kr=bs_k
   bs_sr=bs_s
   kopr=kop
   vor=vo
   kklr=kkl
   mnpr=mnp
   nplpr=nplp
   kgr=kg
   pdrr=pdr
   konr=kon
   kszr=ksz
   skr=sk
   prnnr=prnn
   ndsr=nds
   sklr=skl      
   ddkr=ddk
   sele operb
   if netseek('t1','kopr')
      if bs_dr#db.or.bs_kr#kr
         ?str(kopr,4)+' DOKK '+str(bs_dr,6)+' '+str(bs_kr,6)+' OPERB '+str(db,6)+' '+str(kr,6)
         wmess('Несовпадение проводок')
      else          
         maskr=mask
         prv(1) && Добавление бухпроводки 
      endif
   else
      ?str(kopr,4)
      wmess('Не найдена операция')   
   endif
   sele dokks
   skip
enddo
sele dokks
use
nuse('operb')
rest scre from scmess
endif

?'Документы складов'
netuse('cskl')
go top
do while !eof()
   if ent#gnEnt
      sele cskl
      skip
      loop
   endif
   pathr=gcPath_d+alltrim(path)
   if !netfile('tov',1)
      sele cskl
      skip
      loop 
   endif
   skr=sk
   save scre to scmess
   mess(pathr)
   netuse('soper',,,1)

*  ПРИХОД

   netuse('pr1',,,1)
   netuse('pr3',,,1)
   sele pr1
   do while !eof()
      if prz=0
         sele pr1
         skip
         loop
      endif
      if sks#0
         sele pr1
         skip
         loop
      endif
      prov(1,1) 
      sele pr1
      skip
   endd 
   nuse('pr1')
   nuse('pr3')

* РАСХОД

   netuse('rs1',,,1)
   netuse('rs3',,,1)
   sele rs1
   do while !eof()
      if prz=0
         sele rs1
         skip
         loop
      endif
      if sks#0
         sele rs1
         skip
         loop 
      endif
      prov(0,1) 
      sele rs1
      skip
   endd 
   nuse('rs1')
   nuse('rs3')
   nuse('soper')
   rest scre from scmess
   sele cskl
   skip
endd
if gnArm=1
   sele dokk100
   if recc()#0
      use
      sele dokk
      appe from (gcPath_l+'\dokk100.dbf')
   endif
endif

set prin off
if gnOut=1
  set prin to    
endif

nuse()
erase(gcPath_l+'\dokk100.dbf')
erase(gcPath_l+'\dokk.ntx')
erase(gcPath_l+'\dkkln.ntx')
erase(gcPath_l+'\bs.ntx')







