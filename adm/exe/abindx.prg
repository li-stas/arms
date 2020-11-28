para p1
* p1=1 Индексация
* p1=2 Структуры
* p1=3 CP866
* p1=4 Корр индексов
if gnComm=1
   pathmr=gcPath_ini
   pathcsr=pathmr+'comm\'
   pathasr=pathmr+'astru\'
   pathctr=gcPath_m+'comm\'
   pathatr=gcPath_m+'astru\'
   afl:=directory(pathmr+'astru\*.dbf')
   for i=1 to len(afl) 
       flr=lower(afl[i,1]) 
       copy file (pathasr+flr) to (pathatr+flr)
       fflr=strtran(flr,'.dbf','.fpt')    
       if file(pathasr+fflr)
          copy file (pathasr+fflr) to (pathatr+fflr)
       endif    
   next
endif 
p1_r=p1
oclr=setcolor('w/n,n/w')
@ 1,0 clea
if select('sl')=0
   sele 0
   use _slct alias sl excl
else
   sele sl
endif
zap

nuse('setup')
nuse('cntcm')
nuse('prd')
erase dbftt.dbf
erase dbftt.cdx

sele dbft
copy to dbftt for iif(p1_r=1.or.p1_r=3,.t.,file(gcPath_a+alltrim(dbft->als)+'.dbf').or.!empty(dbft->parent))
sele 0
use dbftt excl
inde on str(dir,1) tag t1
go top
dir_r=1
do while .t.
   sele dbftt
   go top
   @ 1,0 clea
   sele dir
   go top
   zz=10
   dir_r=slcf('dir',,,,,"e:dir h:'Д' c:n(1) e:ndirc h:'Директория' c:c(20) ",'dir')
   if lastkey()=27
      exit
   endif
   @ 1,0 clea
   sele dir
   locate for dir=dir_r
   ndir_r=alltrim(ndir)
   pathfr=&ndir_r
   @ 1,1 say ndirc
   go top
   do while .t.
      if dir_r#3 &&p1_r=2.and.dir_r#3
         sele dbftt
         dbfttrcnr=recn()
         go top
         do while !eof()
            if dir#dir_r
               skip
               loop
            endif
            als_rr=alltrim(als)
            nf_rr=nf
            pa_r=pathfr+alltrim(fname)+'.dbf'
            pf_r=pathfr+alltrim(fname)+'.fpt'
            parentfr=alltrim(parent)
            if !file(pa_r)
               if empty(parentfr)
                  if file(gcPath_a+als_rr+'.dbf') 
                     copy file (gcPath_a+als_rr+'.dbf') to (pa_r)
                  endif
                  if file(gcPath_a+als_rr+'.fpt')
                     copy file (gcPath_a+als_rr+'.fpt') to (pf_r)
                  endif
               else   
               endif   
            endif
            if file(gcPath_a+als_rr+'.fpt')
               sele dbftt
               skip   
               loop 
            endif
            if !file(pa_r)
               sele dbftt
               skip   
               loop 
            endif
            if p1_r=2
               if !nstru(als_rr)
                  sele sl
                  appe blank
                  repl kod with str(nf_rr,fieldsize(fieldnum('kod')))
               endif
            endif  
            sele dbftt
            skip
         endd
         sele dbftt
         go dbfttrcnr
      endif
      @ 2,0 clea
      foot('SPACE,ALT-F10,ENTER,ESC','Отбор,Отбор страницы,Выполнить,Выход')
      nfr=slcf('dbftt',2,1,17,,"e:dir h:'Д' c:n(1) e:nf h:'N' c:n(3) e:als h:'Алиас ' c:c(6) e:fname h:'Полн.имя' c:c(8)",'nf',1,1,,'dir=dir_r',,iif(p1_r=1,'ИНДЕКСАЦИЯ','СТРУКТУРЫ'))
      sele dbftt
      locate for nf=nfr
      do case
         case lastkey()=13
              ind()
         case lastkey()=27
              sele sl
              zap
              exit
      endc
   endd
endd
sele dbftt
use
erase dbftt.dbf
erase dbftt.cdx
netuse('setup')
netuse('cntcm')
netuse('prd')
nuse()
retu

stat func ind()
sele sl
go top
if eof()
   retu
endif
if p1_r=2
   do while !eof()
      rcslr=recn()
      nfr=val(kod)
      sele dbft
      locate for nf=nfr
      alsr=alltrim(als)
      parentr=alltrim(parent)
      if empty(parentr)  && Добавить дочерние базы,если они не помечены
         locate for alltrim(parent)==alsr
         do while !eof()
            nf_r=nf
            if dir#dir_r
               cont
               loop
            endif
            sele sl
            locate for val(kod)=nf_r
            if !FOUND()
               appe blank
               repl kod with str(nf_r,fieldsize(fieldnum('kod')))
            endif
            sele dbft
            cont
         endd
      else              && Добавить родительские базы,если они не помечены
         locate for alltrim(als)==parentr
         do while !eof()
            nf_r=nf
            if dir#dir_r
               cont
               loop
            endif
            sele sl
            locate for val(kod)=nf_r
            if !FOUND()
               appe blank
               repl kod with str(nf_r,fieldsize(fieldnum('kod')))
            endif
            sele dbft
            cont
         endd
      endif
      sele sl
      go rcslr
      skip
   enddo
endif
if dir_r=3
   sele sl
   copy to sl1  && Сохранить файлы в sl1
   zap
   netuse('cskl')
   sele cskl
   go top
   do while .t.
      sele cskl
      sk_r=slcf('cskl',2,30,17,,"e:sk h:'SK' c:n(3) e:nskl h:'Наименование' c:c(20)",'sk',1,1,,'ent=gnEnt.and.file(gcPath_d+alltrim(path)+"tprds01.dbf")')
      sele cskl
      locate for sk=sk_r
      do case
         case lastkey()=27
              exit
         case lastkey()=13
              sele sl
              copy to sl2 && Сохранить директории в sl2
              zap
              appe from sl1 && Восстановить файлы из sl1
              sele 0
              use sl2
              go top
              do while !eof()
                 skr=val(kod)
                 nsklr=alltrim(getfield('t1','skr','cskl','nskl'))
                 path_rr=gcPath_d+alltrim(getfield('t1','skr','cskl','path'))
                 do case
                    case p1_r=1
                         indx(skr)
                         * Удаление незарегистрированных файлов
                         pathr=path_rr
                         aall:=directory(pathr+'*.*')
                         for i=1 to len(aall)
                             ffnamer=lower(aall[i,1])
                             #ifdef __CLIP__
                                extr=right(ffnamer,3)
                                fnamer=subs(ffnamer,1,len(ffnamer)-4)
                             #else
                                if at('.',ffnamer)#0 
                                   lextr=len(ffnamer)-at('.',ffnamer)
                                   extr=lower(right(ffnamer,lextr))
                                   fnamer=subs(ffnamer,1,len(ffnamer)-lextr-1)
                                else
                                   extr='' 
                                   fnamer=ffnamer
                                endif  
                             #endif
                             sele dbft
                             locate for alltrim(fname)==fnamer
                             if !FOUND()
                                erase (pathr+ffnamer)
                             else
                                if !(extr='dbf'.or.extr='cdx'.or.extr='fpt').or.dir#dir_r
                                   erase (pathr+ffnamer)
                                endif
                             endif
                         next
                    case p1_r=2
                         stru(skr)
                    case p1_r=3
                         fcp866(skr)
                    case p1_r=4
                         bs6(skr)
                    case p1_r=5
                         kpl(skr)
                    case p1_r=6
                         oper6(skr)
                    case p1_r=7
                         cindx(skr)
                endc
                 sele sl2
                 skip
              endd
              sele sl2
              use
              sele sl
              zap
              appe from sl2  && Восстановить директории из sl2
              @ 23,1 say space(60)
      endc
      sele cskl
      netseek('t1','sk_r')
   endd
   nuse('cskl')
   if select('sl2')#0
      sele sl2
      use
   endif
   erase sl2.dbf
   if select('sl1')#0
     sele sl1
     use
   endif
   sele sl
   zap
   appe from sl1 && Восстановить файлы из sl1
   go top
   erase sl1.dbf
else
   do case
      case p1_r=1
           indx()
           * Удаление незарегистрированных файлов
           pathr=&ndir_r
           aall:=directory(pathr+'*.*')
           for i=1 to len(aall)
               ffnamer=lower(aall[i,1])
               #ifdef __CLIP__
                  extr=right(ffnamer,3)
                  fnamer=subs(ffnamer,1,len(ffnamer)-4)
               #else
                  if at('.',ffnamer)#0 
                     lextr=len(ffnamer)-at('.',ffnamer)
                     extr=lower(right(ffnamer,lextr))
                     fnamer=subs(ffnamer,1,len(ffnamer)-lextr-1)
                  else
                     extr='' 
                     fnamer=ffnamer
                  endif  
               #endif
               if fnamer='dbft'.or.fnamer='dir'.or.fnamer='cntcm'.or.fnamer='prd'
                  loop
               endif
               sele dbft
               locate for alltrim(fname)==fnamer
               if !FOUND()
                  erase (pathr+ffnamer)
               else
                  if !(extr='dbf'.or.extr='cdx'.or.extr='fpt').or.dir#dir_r
                     erase (pathr+ffnamer)
                  endif
               endif
           next
      case p1_r=2
           stru()
      case p1_r=3
           fcp866()
      case p1_r=4
           bs6()
      case p1_r=5
           kpl()
      case p1_r=6
           oper6()
      case p1_r=7
           cindx()
   endc
endif
retu
*******
stat func bs6(p1)
sk_r=p1
save scre to scabindx
sele sl
go top
do while !eof()
   nfr=val(kod)
   sele dbftt
   locate for nf=nfr
   poler=pole
   fil=alltrim(als)
   fill=alltrim(fname)
   dirr=dir
   if sk_r=nil
      netuse(fil,,'e')
   else
      pathr=gcPath_d+alltrim(getfield('t1','sk_r','cskl','path'))
      netuse(fil,,'e',1)
   endif
   if select(fil)#0
      dbclearindex()
      save scre to scmess
      if dir_r=3
         mess(nsklr+' '+fil)
      else
         mess(fil)
      endif
      if poler<>nil
         for s=1 to numat(';',poler)
             polerr=token(poler,';',s)
             go top
             do while .not.eof()
                if len(alltrim(str(&polerr)))=4
                   repl &polerr with val(substr(str(&polerr,4),1,2)+'00'+substr(str(&polerr,4),3,2))
                endif
                if len(alltrim(str(&polerr)))=3
                   repl &polerr with val(substr(str(&polerr,3),1,1)+'00'+substr(str(&polerr,3),2,2))
                endif
                if .not. eof()
                   skip
                endif
             enddo
         next
      endif
      use
      rest scre from scmess
   else
      @ 23,40 say fil colo 'r/w'
   endif
   sele sl
   skip
endd
rest scre from scabindx
*******
stat func kpl(p1)
sk_r=p1
save scre to scabindx
sele sl
go top
do while !eof()
   nfr=val(kod)
   sele dbftt
   locate for nf=nfr
   poler=pole
   fil=alltrim(als)
   fill=alltrim(fname)
   dirr=dir
   if sk_r=nil
      netuse(fil,,'e')
   else
      pathr=gcPath_d+alltrim(getfield('t1','sk_r','cskl','path'))
      netuse(fil,,'e',1)
   endif
   if select(fil)#0
      dbclearindex()
      save scre to scmess
      if dir_r=3
         mess(nsklr+' '+fil)
      else
         mess(fil)
      endif
**********************
      go top
      do while .not.eof()
         if vo=5
            if len(alltrim(str(kpl)))=4
               repl kpl with val(substr(str(kpl,4),1,2)+'00'+substr(str(kpl,4),3,2))
            endif
            if len(alltrim(str(kpl)))=3
               repl kpl with val(substr(str(kpl,3),1,1)+'00'+substr(str(kpl,3),2,2))
            endif
         endif
         skip
      enddo
************
      use
      rest scre from scmess
   else
      @ 23,40 say fil colo 'r/w'
   endif
   sele sl
   skip
endd
rest scre from scabindx
******************
stat func oper6(p1)
sk_r=p1
save scre to scabindx
sele sl
go top
do while !eof()
   nfr=val(kod)
   sele dbftt
   locate for nf=nfr
   poler=pole
   fil=alltrim(als)
   fill=alltrim(fname)
   dirr=dir
   if sk_r=nil
      netuse(fil,,'e')
   else
      pathr=gcPath_d+alltrim(getfield('t1','sk_r','cskl','path'))
      netuse(fil,,'e',1)
   endif
   if select(fil)#0
      dbclearindex()
      save scre to scmess
      if dir_r=3
         mess(nsklr+' '+fil)
      else
         mess(fil)
      endif
**********************
go top
do while .not.eof()
   for i=1 to 20
       if i<10
          tt=str(i,1)
       else
          tt=str(i,2)
       endif
       dsz_r='dsz'+tt
       dszr=&dsz_r
       if dszr=97
          ddb_r='ddb'+tt
          ddb=&ddb_r
          dkr_r='dkr'+tt
          dkr=&dkr_r
          prz_r='prz'+tt
          prz=&prz_r
          for j=i to 20
              if j<10
                 tt1=str(j,1)
              else
                 tt1=str(j,2)
              endif
              dsz_p='dsz'+tt1
              dszp=&dsz_p
                if dszp=0
                   ddb_p='ddb'+tt1
                   dkr_p='dkr'+tt1
                   prz_p='prz'+tt1
                   repl dsz&tt1 with 94
                   repl &ddb_p with ddb,&dkr_p with dkr,&prz_p with prz
                   exit
                endif
          next
        endif
   next
skip
enddo
************
      use
      rest scre from scmess
   else
      @ 23,40 say fil colo 'r/w'
   endif
   sele sl
   skip
endd
rest scre from scabindx



*********************
stat func indx(p1)
sk_r=p1
save scre to scabindx
sele sl
go top
do while !eof()
   nfr=val(kod)
   sele dbftt
   locate for nf=nfr
   fil=alltrim(als)
   fill=alltrim(fname)
   dirr=dir
   parentr=alltrim(parent)
   save scre to scmess
   if dir_r=3
      mess(nsklr+' '+fil)
   else
      mess(fil)
   endif
   if sk_r=nil
      if netfile(fil)
         if !netind(fil)
            @ 23,40 say fil colo 'r/w'
         endif
      endif
   else
      pathr=gcPath_d+alltrim(getfield('t1','sk_r','cskl','path'))
      if !netfile(fil,1)
         als_rr=fil
         pa_r=pathr+alltrim(fill)+'.dbf'
         parentfr=parentr
         if !file(pa_r)
            if empty(parentfr)
               if file(gcPath_a+als_rr+'.dbf') 
                  copy file (gcPath_a+als_rr+'.dbf') to (pa_r)
               endif
            else   
            endif   
         endif
      endif    
      if !netfile(fil,1)
         sele sl
         skip   
         loop 
      endif
      if !nstru(fil,1)
         sele sl
         skip   
         loop 
      endif
      if !netind(fil,1)
         @ 23,40 say fil colo 'r/w'
      endif
   endif
   rest scre from scmess
   sele sl
   skip
endd
rest scre from scabindx


stat func stru(p1)
sk_r=p1
save scre to scabindx
sele sl
go top
do while !eof()
   sele sl
   nfr=val(kod)
   sele dbft
   locate for nf=nfr
   fil=alltrim(als)
   fill=alltrim(fname)
   dirr=dir
   parentr=alltrim(parent)
   dopr=alltrim(dop)
   rcdbfttr=recn()
   sele dir
   locate for dir=dirr
   if dirr=3
      pathor=gcPath_d+alltrim(getfield('t1','sk_r','cskl','path'))
   else
      pathor=&(alltrim(ndir))
   endif
   pathrr=pathr
   pathr=pathor
   if !netfile(fil,1)
      sele sl
      skip
      loop
   endif
   if file(pathr+fill+'.fpt')
      sele sl
      skip
      loop
   endif
   if nstru(fil,1)
      sele sl
      skip
      loop
   endif
   erase(fill+'.cdx') 
   if !netuse(fil,,'e',1)
      wmess('Файл '+pathr+fil+' ЗАНЯТ',2)
      sele sl
      skip
      loop
   else
      use   
   endif
   pathr=pathrr
   if empty(parentr)  && Основные базы
      pathsr=gcPath_a+fil
      if file(pathsr+'.dbf')
         sele 0
         use (pathsr) alias str_u
         copy stru to (gcPath_l+'\'+fil)
         use
         sele 0
         use (fil) alias in
         if file(pathor+fill+'.dbf')
            save scre to scmess
            if dir_r=3
               mess(nsklr+' '+fil)
            else
               mess(fil)
            endif
            appe from (pathor+fill+'.dbf')
            copy to (pathor+fill+'.dbf')
            rest scre from scmess
         endif
         sele in
         use
         erase (fil+'.dbf')
      endif
      sele sl
      skip
      loop
   else   && Дочерние базы
      adop:={}
      dfil_r=fill
      sele dbft
      do while .t.
         locate for alltrim(als)==dfil_r
         if !empty(dop)
            aadd(adop,dop)
         endif
         if !empty(parent)
            dfil_r=alltrim(parent)
         else
            aadd(adop,alltrim(als))
            exit
         endif
      enddo

      for i=1 to len(adop)
          fil_r=alltrim(adop[i])
          sele 0
          use (gcPath_a+fil_r)
          copy to (gcPath_l+'\stemp'+str(i,1)+'.dbf') stru exte
          use
      next

      k=0
      for i=len(adop) to 1 step -1
          fil_r=gcPath_l+'\stemp'+str(i,1)
          if k=0
             sele 0
             use (fil_r) alias stemp
             k=1
          else
             sele stemp
             appe from (fil_r+'.dbf')
             erase (fil_r+'.dbf')
          endif
      next
      k=len(adop)
      sele stemp
      use
      crea in from ('stemp'+str(k,1)+'.dbf')
      erase ('stemp'+str(k,1)+'.dbf')
      if file(pathor+fill+'.dbf')
         save scre to scmess
         if dir_r=3
            mess(nsklr+' '+fil)
         else
            mess(fil)
         endif
         appe from (pathor+fill+'.dbf')
         copy to (pathor+fill+'.dbf')
         rest scre from scmess
      endif
      sele in
      use
      erase in.dbf
      erase in.fpt
   endif
   sele sl
   skip
endd
rest scre from scabindx



stat func fcp866(p1)
sk_r=p1
save scre to scabindx
sele sl
go top
do while !eof()
   nfr=val(kod)
   sele dbft
   locate for nf=nfr
   fil=alltrim(als)
   fill=alltrim(fname)
   dirr=dir
   rcdbfttr=recn()
   sele dir
   locate for dir=dirr
   if dirr=3
      pathor=gcPath_d+alltrim(getfield('t1','sk_r','cskl','path'))
   else
      pathor=&(alltrim(ndir))
   endif
   if file(pathor+fill+'.dbf')
      path_rr=pathr
      pathr=pathor
      cp866(fil,1)
      pathr=path_rr
   endif   
   sele sl
   skip
endd
rest scre from scabindx


*********************
func cindx(p1)
*********************
sk_r=p1
save scre to scabindx
sele sl
go top
do while !eof()
   nfr=val(kod)
   sele dbftt
   locate for nf=nfr
   cifilr=alltrim(als)
   cidirr=dir
   save scre to scmess
   if cidirr=3
      mess(nsklr+' '+cifilr)
   else
      mess(cifilr)
   endif
   if sk_r=nil
      netuse(cifilr)
      netcind(cifilr)
      nuse(cifilr)
   else
      pathr=gcPath_d+alltrim(getfield('t1','sk_r','cskl','path'))
      netuse(cifilr,,,1)
      netcind(cifilr)
      nuse(cifilr)
   endif
   rest scre from scmess
   sele sl
   skip
endd
rest scre from scabindx
