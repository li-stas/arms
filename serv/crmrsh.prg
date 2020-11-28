* Коррекция маршрутов

func crmrshn()
if year(gdTd)=2006.and.month(gdTd)=3
   wmess('НИЗЗЯ!!!')
   retu .t.
endif
dtpr=bom(gdTd)-1
ypr=year(dtpr)
mpr=month(dtpr)
pathpr=gcPath_e+'g'+str(ypr,4)+'\m'+iif(mpr<10,'0'+str(mpr,1),str(mpr,2))+'\'
if !file(pathpr+'cmrsh.dbf')
   retu 
endif
clea
aqstr=1
aqst:={"Просмотр","Коррекция"}
aqstr:=alert(" ",aqst)
if lastkey()=27
   retu
endif
set prin to cmrshn.txt
set prin on
netuse('cskl')
netuse('ctov')
netuse('atvm')
netuse('kln')
netuse('speng')
set orde to tag t2
netuse('cmrsh')
netuse('czg')
pathr=pathpr
netuse('cmrsh','cmrshp',,1)
netuse('czg','czgp',,1)
sele cmrshp
do while !eof()
   mrshr=mrsh
   sele cmrsh
   if !netseek('t2','mrshr')  
      sele czgp
      if netseek('t1','mrshr')
         prcopyr=0 && Признак восстановления
         sk_r=0
         do while mrsh=mrshr
            entr=ent
            skr=sk
            ttnr=ttn
            if sk_r#skr
               nuse('rs1')
               sele setup
               loca for ent=entr
               pathdr=gcPath_m+alltrim(nent)+'\'+gcDir_g+gcDir_d
               sele cskl
               loca for sk=skr
               pathr=pathdr+alltrim(path)
               if netfile('rs1',1)
                  netuse('rs1',,,1)
               else
                  exit
               endif   
               sk_r=skr
            endif
            if netseek('t1','ttnr','rs1',,1)
               prcopyr=1
               exit
            endif
            sele czgp
            skip
         endd
         nuse('rs1')
         if prcopyr=1
            ?str(mrshr,6)
            if aqstr=2
               sele czgp
               if netseek('t1','mrshr')
                  do while mrsh=mrshr
                     skr=sk
                     entr=ent
                     ttnr=ttn
                     arec:={}
                     getrec()
                     sele czg
                     if !netseek('t1','mrshr,entr,skr,ttnr')
                        netadd()
                        putrec()
                     endif
                     sele czgp
                     skip
                  endd
               endif
               sele cmrshp
               arec:={}
               getrec()
               sele cmrsh
               if !netseek('t2','mrshr')
                  netadd()
                  putrec()
               endif
            endif   
         endif
      endif
   endif
   sele cmrshp
   skip
endd
nuse()
nuse('cmrshp')
nuse('czgp')
set prin off
set prin to txt.txt
retu .t.

func crmrsht()
clea
aqstr=1
aqst:={"Все","Коррекция","Чистка"}
aqstr:=alert(" ",aqst)
if lastkey()=27
   retu
endif
set prin to cmrsht.txt
set prin on
netuse('cskl')
netuse('atvm')
netuse('kln')
netuse('cmrsh')
set orde to tag t2
netuse('czg')
if aqstr=1.or.aqstr=2
   mttn()
   cmz()
endif
if aqstr=1.or.aqstr=3
   delmrsh()
endif
nuse()
set prin off
set prin to txt.txt
retu .t.

func mttn()
sele cskl
go top
do while !eof()
   pathdr=''
   entr=ent
   if entr#gnEnt
      skip
      loop
   endif
   sele setup
   loca for ent=entr
   if !foun()
      sele cskl
      skip
      loop 
   else
      pathdr=gcPath_m+alltrim(nent)+'\'+gcDir_g+gcDir_d
      if nmrsh=0
         sele cskl
         skip
         loop 
      endif
   endif   
   sele cskl
   skr=sk
   nsklr=nskl
   pathr=pathdr+alltrim(path)
   if !netfile('rs1',1)
      sele cskl &&czg
      skip
      loop
   endif   
   netuse('rs1',,,1)
   do while !eof()
      if mrsh=0
         sele rs1
         skip
         loop
      endif 
      ttnr=ttn
      kgpr=kpv
      if kgpr=0
         kgpr=kgp
      endif
      dopr=dop
      topr=top
      dmrshr=dfp
      sdvr=sdv
      vsvr=vsv
      kopr=kop
      vor=vo
      ktar=kta
      kecsr=kecs
      przr=prz  
      mrshr=mrsh
      vmrshr=getfield('t1','kgpr','kln','vmrsh')
      atrcr=getfield('t1','vmrshr','atvm','atrc')
      if vor=6.and.(kopr=101.or.kopr=181.or.kopr=121)
         atrcr=1 
      endif   
      sele cmrsh
      if !netseek('t2','mrshr')
         ?str(mrshr,6)  
         netadd()
         netrepl('mrsh,kecs,atrc,vmrsh,dtpoe','mrshr,kecsr,atrcr,vmrshr,dopr')
      else
         if atrc#atrcr
            netrepl('atrc','atrcr') 
         endif 
         if empty(dmrsh)
            netrepl('dmrsh','dmrshr') 
         endif
      endif
      sele czg
      if !netseek('t1','mrshr,entr,skr,ttnr')
         ?str(mrshr,6)+' '+str(entr,2)+' '+str(skr,3)+' '+str(ttnr,6)  
         netadd()
         netrepl('mrsh,ent,sk,ttn','mrshr,entr,skr,ttnr')
         netrepl('dop,top,sdv,vsv,kop,kta','dopr,topr,sdvr,vsvr,kopr,ktar')
      endif
      sele rs1
      skip
   endd
   nuse('rs1')
   sele cskl
   skip
endd
retu .t.

func cmz()
sele cmrsh
go top
do while !eof()
   mrshr=mrsh
   kecsr=kecs
   sele czg
   if netseek('t1','mrshr')
      sk_r=0
      do while mrsh=mrshr
         skr=sk
         entr=ent
         if entr#gnEnt
            netdel()
            skip
            loop     
         endif  
         ttnr=ttn
         dopr=dop
         topr=top
         dvzttnr=dvzttn
         sdvr=sdv
         vsvr=vsv
         kopr=kop
         kklr=kkl  
         if fieldpos('kta')#0
            ktar=kta
         else
            ktar=0   
         endif
         if fieldpos('vz')#0
            vzr=vz
         else
            vzr=0   
         endif
         if vzr#0
            sele czg
            skip
            loop
         endif
         if sk_r#skr
            nuse('rs1')
            sele setup
            loca for ent=entr
            pathdr=gcPath_m+alltrim(nent)+'\'+gcDir_g+gcDir_d
            sele cskl
            loca for sk=skr
            pathr=pathdr+alltrim(path)
            if !netfile('rs1',1)
               sele czg
               skip
               loop
            endif   
            netuse('rs1',,,1)
            sk_r=skr
          endif
          sele rs1
          if netseek('t1','ttnr',,,1)
             dop_r=dop
             top_r=top
             dvzttn_r=dvzttn
             sdv_r=sdv
             vsv_r=vsv
             kop_r=kop
             mrsh_r=mrsh
             kecs_r=kecs
             kta_r=kta  
             kgp_r=kpv
             if kgp_r=0
                kgp_r=kgp
             endif 
             if dopr#dop_r.or.kopr#kop_r.or.dvzttnr#dvzttn_r.or.ktar#kta_r.or.kklr#kgp_r;
                .or.sdvr#sdv_r.or.vsvr#vsv_r.or.mrshr#mrsh_r.or.(kecsr#0.and.kecsr#kecs_r)
                ?str(mrshr,6)+' '+str(skr,3)+' '+str(ttnr,6)
                netrepl('mrsh,kecs,dvzttn','mrshr,kecsr,dvzttnr')  
                sele czg
                netrepl('dop,top,sdv,vsv,kop,kkl','dop_r,top_r,sdv_r,vsv_r,kop_r,kgp_r')
                if fieldpos('kta')#0
                   netrepl('kta','kta_r') 
                endif 
                ?'M '+dtoc(dopr)+' '+dtoc(dvzttnr)+' '+str(kopr,3)+' '+str(sdvr,12,2)+' '+str(vsvr,12,3)
                ?'S '+dtoc(dop_r)+' '+dtoc(dvzttn_r)+' '+str(kop_r,3)+' '+str(sdv_r,12,2)+' '+str(vsv_r,12,3)
             endif   
          else  
             sele czg
             netdel() 
          endif
          sele czg
          skip
      endd
      nuse('rs1')
   endif
   sele cmrsh
   if !netseek('t1','mrshr','czg')
      sele cmrsh
      ?str(mrsh,6)+' '+dtos(dmrsh)+' удален'  
      netdel()  
   endif 
   sele cmrsh
   skip
endd
sele cmrsh
go top
do while !eof()
   mrshr=mrsh
   premr=prem
   if premr=0
      sele czg
      if !netseek('t1','mrshr')
          sele cmrsh    
          netdel()
      endif 
   endif   
   sele cmrsh
   skip    
endd
retu .t.

func delmrsh()
sele cmrsh
go top
do while !eof()
   if bom(dmrsh)=bom(gdTd)  
      skip
      loop
   endif
   mrshr=mrsh
   sele czg
   if netseek('t1','mrshr')
      sk_r=0
      do while mrsh=mrshr
         entr=ent
         if entr#gnEnt
            netdel()
            skip
            loop     
         endif
         skr=sk
         ttnr=ttn
         if sk_r#skr
            nuse('rs1')
            sele cskl
            loca for sk=skr
            pathr=gcPath_d+alltrim(path)
            if !netfile('rs1',1)
               sk_r=0
               sele czg
               skip
               loop
            endif   
            netuse('rs1',,,1)
            sk_r=skr
          endif
          sele rs1
          if !netseek('t1','ttnr')
             sele czg
             netdel() 
          endif
          sele czg
          skip
      endd
      nuse('rs1')
   endif
   if !netseek('t1','mrshr','czg')
      sele cmrsh
      ?str(mrsh,6)+' '+dtos(dmrsh)+' удален'  
      netdel()  
   endif 
   sele cmrsh
   skip
endd
retu .t.
