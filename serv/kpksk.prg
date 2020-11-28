func kpkoutsk()
retu
wait
opendir(1) && comm
opendir(2) && buh
opendir(4) && ent

lindx('lrs1','rs1')
luse('lrs1')
lindx('lrs2','rs2')
luse('lrs2')

sele lrs1
go top
do while !eof()
   ttn_r=ttn
   docguid_r=docguid
   skr=skl
   sele cskl
   if !netseek('t1','skr')
      exit
   endif
   sklr=skl
   msklr=mskl
   pathr=gcPath_d+alltrim(path)

   opendir(3,1) && sklad

   sele lrs1
   arec:={}
   getrec()
   sele rs1
   locate for docguid=docguid_r
   ttncor=0
   ttnr=0 //!!
   if .t. &&!foun()
      sele cskl
      reclock()
      ttnr=ttn
      if ttn<999999
         netrepl('ttn','ttn+1')
      else
         netrepl('ttn','1')
      endif
      sele rs1
      netadd()
      putrec()
      netrepl('ttn,skl,ddc,dvp','ttnr,sklr,date(),date()',1)
      sele lrs2
      if netseek('t1','ttn_r')
         do while ttn=ttn_r
            mntovr=mntov
            kvpr=kvp
            sele tovm
            if netseek('t1','sklr,mntovr')
               reclock()
               sele tov
               set orde to tag t5
               if netseek('t5','sklr,mntovr')
                  do while skl=sklr.and.mntov=mntovr
                     if osv<=0
                        sele tov
                        skip
                        loop
                     endif
                     reclock()
                     ktlr=ktl
                     osvr=osv
                     optr=opt
                     izgr=izg
                     if osvr<kvpr
                        kvp_r=osvr
                        kvpr=kvpr-osvr
                     else && osvr>=kvpr
                        kvp_r=kvpr
                        kvpr=0
                     endif
                     netrepl('osv','osv-kvp_r')
                     sele tovm
                     netrepl('osv','osv-kvp_r',1)
                     sele rs2
                     if !netseek('t3','ttnr,ktlr,0,ktlr')
                        netadd()
                        netrepl('ttn,ktl,ktlp,mntov,izg','ttnr,ktlr,ktlr,mntovr,izgr')
                     endif
                     netrepl('kvp','kvp+kvp_r')
                     sele lrs2
                     netrepl('kvpo','kvpo+kvp_r')
                     if kvpr=0
                        exit
                     endif
                     sele tov
                     skip
                  endd
               endif
               sele tovm
               dbunlock()
            endif
            sele lrs2
            skip
         endd
      endif
   endif
   closedir(3)
   sele lrs1
   nnzr=str(ttnr,6)
   netrepl('nnz','nnzr')
   skip
   loop
endd
nuse('lrs1')
nuse('lrs2')
nuse()
retu .t.






