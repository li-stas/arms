* rm sklad
*******************************
*******************************
func rmset()
*******************************
netuse('rmsk')
clea
rcrmskr=recn()
do while .t.
   go rcrmskr
   foot('INS,DEL,F4','Добавить,Удалить,Коррекция')
   rcrmskr=slcf('rmsk',,,,,"e:ent h:'ENT' c:n(2) e:rmdir h:'Дир' c:c(10) e:rmsk h:'N' c:n(1) e:rmbs h:'Касса' c:n(6) e:rmip h:'IP' c:c(30) e:kkl h:'KGP' c:n(7)",,,1,,,,'Уд.склады')
   sele rmsk
   go rcrmskr
   entr=ent
   rmdirr=rmdir
   rmskr=rmsk
   rmbsr=rmbs
   rmipr=rmip
   kklr=kkl
   do case
      case lastkey()=22
           rmskins(0)
      case lastkey()=7
           netdel()
           skip -1
           if bof()
              go top
           endif
           rcrmskr=recn()
      case lastkey()=-3
           rmskins(1)
      case lastkey()=27
           exit
   endc
endd
nuse()
********************
funct rmskins(p1)
********************
if empty(p1)
   store 0 to entr,skr,kklr
   store space(10) to rmdirr
   store space(40) to rmipr
endif
clrmsk=setcolor('gr+/b,n/w')
wrmsk=wopen(9,10,17,70)
wbox(1)
do while .t.
   if empty(p1)
      @ 0,1 say 'ENT  ' get entr pict '99'
   else
      @ 0,1 say 'ENT  '+' '+str(entr,2)
   endif
   @ 1,1 say 'DIR  ' get rmdirr
   @ 2,1 say 'N    ' get rmskr pict '9'
   @ 3,1 say 'Касса' get rmbsr pict '999999'
   @ 4,1 say 'IP   ' get rmipr
   @ 5,1 say 'KGP  ' get kklr
   @ 6,1 prom '<Верно>'
   @ 6,col()+1 prom '<Не верно>'
   read
   if lastkey()=27
      exit
   endif
   rmdirr=lower(alltrim(rmdirr))
   menu to mrmskr
   if mrmskr=1
      if empty(p1)
         if !netseek('t1','entr,rmskr,rmdirr')
            netadd()
            netrepl('ent,rmdir,rmsk,rmbs,rmip,kkl','entr,rmdirr,rmskr,rmbsr,rmipr,kklr')
            rcrmskr=recn()
            exit
         else
            wmess('Уже есть',1)
            exit
         endif
      else
         netrepl('rmdir,rmsk,rmbs,rmip,kkl','rmdirr,rmskr,rmbsr,rmipr,kklr')
         exit
      endif
   endif
enddo
wclose(wrmsk)
setcolor(clrmsk)
retu
nuse()
retu .t.
********************************************
********************************************

********************************************
func rmupdt(p1)
********************************************
* p1 1-send;2-recieve
clea
set prin to rmsk.txt
set prin on

vsvbr=0
if p1=1
   if gnEntrm=0
      avsvb:={"Все","Выборочно"}
      vsvbr:=alert("Режим",avsvb)
      if lastkey()=27
         retu .t.
      endif
    else
    endif
else
   if gnEntrm=1
      avsvb:={"Все","Выборочно"}
      vsvbr:=alert("Режим",avsvb)
      if lastkey()=27
         retu .t.
      endif
      if vsvbr=1
         aqstr=1
         aqst:={"Нет","Да"}
         aqstr:=alert("Выгнали всех ?",aqst)
         if lastkey()=27.or.aqstr=1
            retu .t.
         endif
      else
      endif
   endif
endif

rmdirr=''
pathminr=''
pathmoutr=''

netuse('rmsk')
if netseek('t1','gnEnt')
   rmdirr=alltrim(rmdir)
   rmbsr=rmbs
   srmskr=rmsk
   if p1=1  && SEND
      pathminr=gcPath_m
      if gnEntrm=0
         rcrmskr=recn()
         do while .t.
            sele rmsk
            go rcrmskr
            foot('ENTER','Передать')
            rcrmskr=slcf('rmsk',,,,,"e:ent h:'ENT' c:n(2) e:rmdir h:'Дир' c:c(10) ",,,,,'ent=gnEnt',,'Уд.склады')
            if lastkey()=27
               rmdirr=''
               exit
            endif
            sele rmsk
            go rcrmskr
            rmbsr=rmbs
            rmdirr=alltrim(rmdir)
            srmskr=rmsk
            pathmoutr=gcPath_out+rmdirr+'\'
            if lastkey()=13
               rmcopy(1)
            endif
         endd
      else
         pathmoutr=gcPath_out+rmdirr+'\'
         rmcopy(1)
      endif
   else     && RECIEVE
      pathmoutr=gcPath_m
      if gnEntrm=0
         rcrmskr=recn()
         do while .t.
            sele rmsk
            go rcrmskr
            foot('ENTER','Загрузить')
            rcrmskr=slcf('rmsk',,,,,"e:ent h:'ENT' c:n(2) e:rmdir h:'Дир' c:c(10) ",,,,,'ent=gnEnt',,'Уд.склады')
            if lastkey()=27
               rmdirr=''
               exit
            endif
            sele rmsk
            go rcrmskr
            rmbsr=rmbs
            rmdirr=alltrim(rmdir)
            srmskr=rmsk
            pathminr=gcPath_in+rmdirr+'\'
            if lastkey()=13
               #ifdef __CLIP__
                  if file(gcPath_in+rmdirr+'.tgz')
                     cLogSysCmd:=""
                     dirinr=subs(gcPath_in,1,len(gcPath_in)-1)
                     dirchange(dirinr)
                     aaa="tar xpzvf ./"+rmdirr+".tgz ./"
                     SYSCMD(aaa,"",@cLogSysCmd)
                     dirchange(gcPath_l)
                  endif
               #endif
               if dirchange(gcPath_in+rmdirr)#0
                  wmess(gcPath_in+rmdirr+' Нет данных',2)
               else
                  rmcopy(2)
               endif
            endif
         endd
      else
         rmdirr=alltrim(rmdir)
         rmbsr=rmbs
         srmskr=rmsk
         pathminr=gcPath_in+rmdirr+'\'
         #ifdef __CLIP__
            if file(gcPath_in+rmdirr+'.tgz')
               cLogSysCmd:=""
               dirinr=subs(gcPath_in,1,len(gcPath_in)-1)
               dirchange(dirinr)
               aaa="tar xpzvf ./"+rmdirr+".tgz ./"
               SYSCMD(aaa,"",@cLogSysCmd)
               dirchange(gcPath_l)
            endif
         #endif
         if dirchange(gcPath_in+rmdirr)#0
            wmess(gcPath_in+rmdirr+' Нет данных',2)
         else
            dirchange(gcPath_l)
            if vsvbr=1 && Все
               rmcopy(2)
            else       && Выборочно
               rmvb()
            endif
         endif
      endif
   endif
endif

nuse()
set prin off
set prin to
retu .t.

********************************************
func rmcopy(p1)
********************************************
clea

if p1=1 && SEND
   akmesr=1
   akmes:={"1","2"}
   akmesr:=alert("Передать месяцев",akmes)
   if lastkey()=27
      retu .t.
   endif
   * Удаление каталогов out
   if dirchange(gcPath_out+rmdirr)=0
      #ifdef __CLIP__
         cLogSysCmd:=""
         bdr=subs(gcPath_out,1,2)
         ubdr=upper(bdr)
         lbdr=set(ubdr)
         dir_outr=strtran(gcPath_out+rmdirr,bdr,lbdr)
         dir_outr=strtran(dir_outr,'\','/')
         SYSCMD("rm -dr "+dir_outr ,"",@cLogSysCmd)
      #else
         do case
            case getenv('os')='Windows_NT'
                    tt='cmd /c rd '+gcPath_out+rmdirr+' /s/q >nul'
            case getenv('os')='Windows_98'
                    tt='deltree /y '+gcPath_out+rmdirr+' >nul'
            othe
                 wait getenv('os')
                 retu .f.
         endc
         !(tt)
      #endif
   endif
   * Создание каталогов out
   if gnEntrm=0
      dirmake(gcPath_out+rmdirr)
      dirmake(gcPath_out+rmdirr+'\comm')
      pathcr=gcPath_out+rmdirr+'\'+gcDir_c
      dirmake(gcPath_out+rmdirr+'\'+gcNent)
      pather=gcPath_out+rmdirr+'\'+gcDir_e
      dirmake(gcPath_out+rmdirr+'\'+'astru')
      pathar=gcPath_out+rmdirr+'\'+gcDir_a
   else
      dirmake(gcPath_out+rmdirr)
      dirmake(gcPath_out+rmdirr+'\comm')
      pathcr=gcPath_out+rmdirr+'\'+gcDir_c
      dirmake(gcPath_out+rmdirr+'\'+gcNent)
      pather=gcPath_out+rmdirr+'\'+gcDir_e
   endif
   if akmesr=1
      dt2r=gdTd
      dt1r=gdTd
   else
      dt2r=gdTd
      dt1r=bom(gdTd)-1
   endif
   yy1r=year(dt1r)
   yy2r=year(dt2r)
   for yy=yy1r to yy2r
       dirmake(pather+'g'+str(yy,4))
       dirmake(pathcr+'g'+str(yy,4))
       do case
          case yy1r=yy2r
               mm1r=month(dt1r)
               mm2r=month(dt2r)
          case yy=yy1r
               mm1r=month(dt1r)
               mm2r=12
          case yy=yy2r
               mm1r=1
               mm2r=month(dt2r)
       endc
       for mm=mm1r to mm2r
           dirmake(pather+'g'+str(yy,4)+'\m'+iif(mm<10,'0'+str(mm,1),str(mm,2)))
           dirmake(pathcr+'g'+str(yy,4)+'\m'+iif(mm<10,'0'+str(mm,1),str(mm,2)))
           dirmake(pather+'g'+str(yy,4)+'\m'+iif(mm<10,'0'+str(mm,1),str(mm,2))+'\bank')
           if gnEntrm=0
              dirmake(pather+'g'+str(yy,4)+'\m'+iif(mm<10,'0'+str(mm,1),str(mm,2))+'\glob')
           endif
           netuse('cskl')
           do while !eof()
              if ent#gnEnt
                 skip
                 loop
              endif
              if rm=0.or.rm#1.and.(rm#srmskr)
                 skip
                 loop
              endif
              path_r=pather+'g'+str(yy,4)+'\m'+iif(mm<10,'0'+str(mm,1),str(mm,2))+'\'+alltrim(path)
              path_rr=gcPath_e+'g'+str(yy,4)+'\m'+iif(mm<10,'0'+str(mm,1),str(mm,2))+'\'+alltrim(path)
              dir_r=subs(path_r,1,len(path_r)-1)
              if file(path_rr+'tprds01.dbf')
                 dirmake(dir_r)
              endif
              sele cskl
              skip
           endd
           nuse('cskl')
       next
   next
endif

* Копирование необновляемых файлов

*ASTRU
if gnEntrm=0
   pathinr=pathminr+gcDir_a
   pathoutr=pathmoutr+gcDir_a
   ?pathinr
   adirect=directory(pathinr+'*.*')
   if len(adirect)#0
       for i=1 to len(adirect)
           fl=adirect[i,1]
           fextr=lower(right(fl,3))
           if fextr='dbf'.or.fextr='fpt'
              copy file (pathinr+fl) to (pathoutr+fl)
           endif
       next
    endif
    ?pathoutr
else
   if p1=2
      pathinr=pathminr+gcDir_a
      pathoutr=pathmoutr+gcDir_a
      ?pathinr
      adirect=directory(pathinr+'*.*')
      if len(adirect)#0
         for i=1 to len(adirect)
             fl=adirect[i,1]
             fextr=lower(right(fl,3))
             if fextr='dbf'.or.fextr='fpt'
                copy file (pathinr+fl) to (pathoutr+fl)
             endif
         next
      endif
      ?pathoutr
   endif
endif

*COMM
pathinr=pathminr+gcDir_c
pathoutr=pathmoutr+gcDir_c
dirr=1
?pathinr
if p1=1
   copfl(1)
   copcomm()
else
   copfl(2)
endif
?pathoutr

*ENT
pathinr=pathminr+gcDir_e
pathoutr=pathmoutr+gcDir_e
dirr=4
?pathinr
if p1=1
   copfl(1)
   copent()
else
   copfl(2)
endif
?pathoutr

if p1=1
   if akmesr=1
      dt2r=gdTd
      dt1r=gdTd
   else
      dt2r=gdTd
      dt1r=bom(gdTd)-1
   endif
else
   dt2r=gdTd
   dt1r=bom(gdTd)-1
endif
yy1r=year(dt1r)
yy2r=year(dt2r)

for yy=yy1r to yy2r
    *YEAR
    pathinr=pathminr+gcDir_e+'g'+str(yy,4)+'\'
    pathoutr=pathmoutr+gcDir_e+'g'+str(yy,4)+'\'
    dirr=7
    ?pathinr
    if p1=1
       copfl(1)
    else
       copfl(2)
    endif
    ?pathoutr
    do case
       case yy1r=yy2r
            mm1r=month(dt1r)
            mm2r=month(dt2r)
       case yy=yy1r
            mm1r=month(dt1r)
            mm2r=12
       case yy=yy2r
            mm1r=1
            mm2r=month(dt2r)
    endc
    for mm=mm1r to mm2r
        *Month
        pathinr=pathminr+gcDir_e+'g'+str(yy,4)+'\m'+iif(mm<10,'0'+str(mm,1),str(mm,2))+'\'
        pathoutr=pathmoutr+gcDir_e+'g'+str(yy,4)+'\m'+iif(mm<10,'0'+str(mm,1),str(mm,2))+'\'
        diroutr=pathmoutr+gcDir_e+'g'+str(yy,4)+'\m'+iif(mm<10,'0'+str(mm,1),str(mm,2))
        dirinr=pathminr+gcDir_e+'g'+str(yy,4)+'\m'+iif(mm<10,'0'+str(mm,1),str(mm,2))
        if dirchange(dirinr)#0
           loop
        endif
        if dirchange(diroutr)#0
           loop
        endif
        dirr=5
        ?pathinr
        if p1=1
           copfl(1)
        else
           copfl(2)
        endif
        ?pathoutr
        *Month Comm
        pathinr=pathminr+gcDir_c+'g'+str(yy,4)+'\m'+iif(mm<10,'0'+str(mm,1),str(mm,2))+'\'
        pathoutr=pathmoutr+gcDir_c+'g'+str(yy,4)+'\m'+iif(mm<10,'0'+str(mm,1),str(mm,2))+'\'
        dirinr=pathminr+gcDir_c+'g'+str(yy,4)+'\m'+iif(mm<10,'0'+str(mm,1),str(mm,2))
        diroutr=pathmoutr+gcDir_c+'g'+str(yy,4)+'\m'+iif(mm<10,'0'+str(mm,1),str(mm,2))
        if dirchange(dirinr)#0
           loop
        endif
        if dirchange(diroutr)#0
           loop
        endif
        dirr=9
        ?pathinr
        if p1=1
           copfl(1)
        else
           copfl(2)
        endif
        ?pathoutr
        *BANK
        pathinr=pathminr+gcDir_e+'g'+str(yy,4)+'\m'+iif(mm<10,'0'+str(mm,1),str(mm,2))+'\'+gcDir_b
        pathoutr=pathmoutr+gcDir_e+'g'+str(yy,4)+'\m'+iif(mm<10,'0'+str(mm,1),str(mm,2))+'\'+gcDir_b
        dirinr=pathminr+gcDir_e+'g'+str(yy,4)+'\m'+iif(mm<10,'0'+str(mm,1),str(mm,2))+'\bank'
        diroutr=pathmoutr+gcDir_e+'g'+str(yy,4)+'\m'+iif(mm<10,'0'+str(mm,1),str(mm,2))+'\bank'
        if dirchange(dirinr)#0
           loop
        endif
        if dirchange(diroutr)#0
           loop
        endif
        dirr=2
        ?pathinr
        if p1=1
           copfl(1)
           copbank()
        else
           copfl(2)
        endif
        ?pathoutr
        if gnEntrm=0.and.p1=1
           *GLOB
           pathinr=pathminr+gcDir_e+'g'+str(yy,4)+'\m'+iif(mm<10,'0'+str(mm,1),str(mm,2))+'\'+gcDir_gl
           pathoutr=pathmoutr+gcDir_e+'g'+str(yy,4)+'\m'+iif(mm<10,'0'+str(mm,1),str(mm,2))+'\'+gcDir_gl
           diroutr=pathmoutr+gcDir_e+'g'+str(yy,4)+'\m'+iif(mm<10,'0'+str(mm,1),str(mm,2))+'\glob'
           if dirchange(diroutr)=0
              dirr=2
              ?pathinr
              copfl(1)
              ?pathoutr
           endif
        endif
        *SKLAD
        netuse('cskl')
        do while !eof()
           if ent#gnEnt
              skip
              loop
           endif
           if rm=0.or.rm#1.and.(rm#srmskr)
              skip
              loop
           endif
           tpstpokr=tpstpok
           if gnEntrm=0.and.p1=1.and.tpstpokr#0
              skip
              loop
           endif
           pathinr=pathminr+gcDir_e+'g'+str(yy,4)+'\m'+iif(mm<10,'0'+str(mm,1),str(mm,2))+'\'+alltrim(path)
           pathoutr=pathmoutr+gcDir_e+'g'+str(yy,4)+'\m'+iif(mm<10,'0'+str(mm,1),str(mm,2))+'\'+alltrim(path)
           dirinr=subs(pathinr,1,len(pathinr)-1)
           diroutr=subs(pathoutr,1,len(pathoutr)-1)
           if dirchange(dirinr)#0
              sele cskl
              skip
              loop
           endif
           if dirchange(diroutr)#0
              sele cskl
              skip
              loop
           endif
           dirr=3
           ?pathinr
           if p1=1
              copfl(1)
              copskl()
           else
              copfl(2)
           endif
           ?pathoutr
           sele cskl
           skip
        endd
        nuse('cskl')
    next
next
if p1=2
   * COMM
   pathinr=pathminr+gcDir_c
   pathoutr=pathmoutr+gcDir_c
   dirr=4
   if gnEntrm=1
      updtcomm()
   endif
   * ENT
   pathinr=pathminr+gcDir_e
   pathoutr=pathmoutr+gcDir_e
   dirr=4
   updtent()
   * Обновляемые файлы
   for yy=yy1r to yy2r
       do case
          case yy1r=yy2r
               mm1r=month(dt1r)
               mm2r=month(dt2r)
          case yy=yy1r
               mm1r=month(dt1r)
               mm2r=12
          case yy=yy2r
               mm1r=1
               mm2r=month(dt2r)
       endc
       for mm=mm1r to mm2r
           *BANK
           pathinr=pathminr+gcDir_e+'g'+str(yy,4)+'\m'+iif(mm<10,'0'+str(mm,1),str(mm,2))+'\'+gcDir_b
           pathoutr=pathmoutr+gcDir_e+'g'+str(yy,4)+'\m'+iif(mm<10,'0'+str(mm,1),str(mm,2))+'\'+gcDir_b
           dir_r=subs(pathinr,1,len(pathinr)-1)
           diroutr=subs(pathoutr,1,len(pathoutr)-1)
           if dirchange(diroutr)=0
              if dirchange(dir_r)=0
                 ?pathinr
                 updtbank()
                 ?pathoutr
              endif
           endif
           *SKLAD
           netuse('cskl')
           do while !eof()
              if ent#gnEnt
                 skip
                 loop
              endif
              if rm=0.or.rm#1.and.(rm#srmskr)
                 skip
                 loop
              endif
              tpstpokr=tpstpok
              pathinr=pathminr+gcDir_e+'g'+str(yy,4)+'\m'+iif(mm<10,'0'+str(mm,1),str(mm,2))+'\'+alltrim(path)
              pathoutr=pathmoutr+gcDir_e+'g'+str(yy,4)+'\m'+iif(mm<10,'0'+str(mm,1),str(mm,2))+'\'+alltrim(path)
              dir_r=subs(pathinr,1,len(pathinr)-1)
              if dirchange(dir_r)#0
                 sele cskl
                 skip
                 loop
              endif
              if !file(pathinr+'tprho11.dbf')
                 sele cskl
                 skip
                 loop
              endif
*              if !file(pathinr+'tovm.dbf')
*                 sele cskl
*                 skip
*                 loop
*              endif
              if !file(pathoutr+'tprds01.dbf')
                 sele cskl
                 skip
                 loop
              endif
              ?pathinr
              updtskl()
              ?pathoutr
              sele cskl
              skip
           endd
           nuse('cskl')
       next
   next
endif

if p1=1
   #ifdef __CLIP__
     diroutr=subs(gcPath_out,1,len(gcPath_out)-1)
     cLogSysCmd:=""
     dirchange(diroutr)
     aaa="tar czf ./"+rmdirr+".tgz ./"+rmdirr
     SYSCMD(aaa,"",@cLogSysCmd)
     dirchange(gcPath_l)
   #endif
   wmess('Передача окончена',0)
else
   * Удаление каталогов in
   if dirchange(gcPath_out+rmdirr)=0
      #ifdef __CLIP__
         bdr=subs(gcPath_in,1,2)
         ubdr=upper(bdr)
         lbdr=set(ubdr)
         cLogSysCmd:=""
         dir_inr=strtran(gcPath_in+rmdirr,bdr,lbdr)
         dir_inr=strtran(dir_inr,'\','/')
         SYSCMD("rm -dr "+dir_inr,"",@cLogSysCmd)
      #else
         do case
            case getenv('os')='Windows_NT'
                 tt='cmd /c rd '+gcPath_in+rmdirr+' /s/q >nul'
            case getenv('os')='Windows_98'
                 tt='deltree /y '+gcPath_in+rmdirr+' >nul'
            othe
                 wait getenv('os')
                 retu .f.
         endc
         !(tt)
      #endif
   endif

   * Создание каталогов in
   dirmake(gcPath_in+rmdirr)
   wmess('Прием окончен',0)
endif
retu .t.


func copfl(p1)
*p1 1-send;2-recieve
if p1=2
endif
if dirr=1
   if gnEntrm=0.and.p1=1
      sele dbft
      copy to (pathoutr+'dbft')
      sele dir
      copy to (pathoutr+'dir')
      sele cntcm
      copy to (pathoutr+'cntcm')
   endif
   if gnEntrm=1.and.p1=2
      sele dbft
      use
      copy file (pathinr+'dbft.dbf') to (pathoutr+'dbft.dbf')
      sele 0
      use (gcPath_c+'dbft')
      sele dir
      use
      copy file (pathinr+'dir.dbf') to (pathoutr+'dir.dbf')
      sele 0
      use (gcPath_c+'dir')
      if select('cntcm')#0
         sele cntcm
         use
         copy file (pathinr+'cntcm.dbf') to (pathoutr+'cntcm.dbf')
         sele 0
         use (gcPath_c+'cntcm')
      endif
   endif
endif
sele dbft
go top
do while !eof()
   if dirr#101.and.dir#dirr
      skip
      loop
   endif
   if p1=1 && Передача
      if gnEntrm=0.and.rmupdt=0
         skip
         loop
      endif
      if gnEntrm=1.and.(rmupdt=0.or.rmupdt=1.or.dirr=101)
         skip
         loop
      endif
   endif
   if p1=2 && Получение
      if gnEntrm=1.and.rmupdt#1.and.dirr#101
         skip
         loop
      endif
      if gnEntrm=1
         if alltrim(als)=='cntcm'
            skip
            loop
         endif
         if alltrim(als)=='ukach'
            skip
            loop
         endif
      endif
      if gnEntrm=0 &&.and.dirr=101
         skip
         loop
      endif
   endif
   if dirr#101
      fdr=alltrim(fname)+'.dbf'
      fcr=alltrim(fname)+'.cdx'
      fpr=alltrim(fname)+'.fpt'
   else
      fdr=alltrim(als)+'.dbf'
      fcr=alltrim(als)+'.cdx'
      fpr=alltrim(als)+'.fpt'
   endif
   if file(pathinr+fdr)
      copy file (pathinr+fdr) to (pathoutr+fdr)
   endif
   if file(pathinr+fcr).and.dirr#101
      copy file (pathinr+fcr) to (pathoutr+fcr)
   endif
   if file(pathinr+fpr)
      copy file (pathinr+fpr) to (pathoutr+fpr)
   endif
   skip
endd
retu .t.

func updtskl()
set cons off
     pathr=pathinr
     netuse('rs1','rs1in',,1)
     netuse('rs2','rs2in',,1)
     netuse('rs3','rs3in',,1)
     netuse('pr1','pr1in',,1)
     netuse('pr2','pr2in',,1)
     netuse('pr3','pr3in',,1)
     netuse('tov','tovin',,1)
     netuse('tovm','tovmin',,1)
     pathr=pathoutr
     netuse('rs1','rs1out',,1)
     netuse('rs2','rs2out',,1)
     netuse('rs3','rs3out',,1)
     netuse('pr1','pr1out',,1)
     netuse('pr2','pr2out',,1)
     netuse('pr3','pr3out',,1)
     netuse('tov','tovout',,1)
     netuse('tovm','tovmout',,1)
     if gnEntrm=1
        netuse('ctov')
     endif
     * Приход
     set cons on
     ?'Приход'
     set cons off
     sele pr1in
     do while !eof()
        mnr=mn
        przinr=prz
        sklinr=skl
        if mnr=0
           skip
           loop
        endif
        if gnEntrm=0.and.rmsk=0
           skip
           loop
        endif
        if gnEntrm=1.and.rmsk#0
           skip
           loop
        endif
        arec:={}
        getrec()
        sele pr1out
        if netseek('t2','mnr')
           arec1:={}
           getrec('arec1')
           skloutr=skl
           prcompr=1
           przoutr=prz
           for i=1 to len(arec)
               if arec[i]#arec1[i]
                  prcompr=0
                  exit
               endif
           next
           if prcompr=0
              sele pr2in
              if netseek('t1','mnr')
                 do while mn=mnr
                    ktlr=ktl
                    ktlpr=ktlp
                    pptr=ppt
                    sele pr2out
                    if !netseek('t3','mnr,ktlpr,pptr,ktlr')
                       prcompr=0
                       exit
                    endif
                    sele pr2in
                    skip
                 endd
              endif
           endif
           if prcompr=1
              sele pr1in
              skip
              loop
           else
              sele pr2out
              if netseek('t1','mnr')
                 do while mn=mnr
                    if przoutr=1
                       ktlr=ktl
                       mntovr=mntov
                       kfr=kf
                       sele tovout
                       if netseek('t1','skloutr,ktlr')
                          netrepl('osv,osf,osfo','osv-kfr,osf-kfr,osfo-kfr')
                       endif
                       sele tovmout
                       if netseek('t1','skloutr,mntovr')
                          netrepl('osv,osf,osfo','osv-kfr,osf-kfr,osfo-kfr')
                       endif
                    endif
                    sele pr2out
                    netdel()
                    skip
                 endd
              endif
              sele pr2in
              if netseek('t1','mnr')
                 do while mn=mnr
                    if przinr=1
                       ktlr=ktl
                       mntovr=mntov
                       kfr=kf
                    endif
                    arec:={}
                    getrec()
                    sele pr2out
                    netadd()
                    putrec()
                    if przinr=1
                       sele tovout
                       if netseek('t1','skloutr,ktlr')
                          netrepl('osv,osf,osfo','osv+kfr,osf+kfr,osfo+kfr')
                       endif
                       sele tovmout
                       if netseek('t1','skloutr,mntovr')
                          netrepl('osv,osf,osfo','osv+kfr,osf+kfr,osfo+kfr')
                       endif
                    endif
                    sele pr2in
                    skip
                 endd
              endif
              sele pr3out
              if netseek('t1','mnr')
                 do while mn=mnr
                    netdel()
                    skip
                 endd
                 sele pr3in
                 if netseek('t1','mnr')
                    do while mn=mnr
                       arec:={}
                       getrec()
                       sele pr3out
                       netadd()
                       putrec()
                       sele pr3in
                       skip
                    endd
                  endif
              endif
              sele pr1in
              arec:={}
              getrec()
              sele pr1out
              reclock()
              putrec()
              netunlock()
              ?str(mnr,6)+' '+'обновлена'
           endif
        else
           skloutr=sklinr
           sele pr2in
           if netseek('t1','mnr')
              do while mn=mnr
                 if przinr=1
                    ktlr=ktl
                    mntovr=mntov
                    kfr=kf
                 endif
                 arec:={}
                 getrec()
                 sele pr2out
                 netadd()
                 putrec()
                 if przinr=1
                    sele tovout
                    if netseek('t1','skloutr,ktlr')
                       netrepl('osv,osf,osfo','osv+kfr,osf+kfr,osfo+kfr')
                    else
*                       if gnRmsk=1
                          sele tovin
                          if netseek('t1','sklinr,ktlr')
                             arec:={}
                             getrec()
                             sele tovout
                             netadd()
                             putrec()
                             netrepl('osn,osv,osf,osfo','0,kfr,kfr,kfr')
                          endif
                       endif
*                    endif
                    sele tovmout
                    if netseek('t1','skloutr,mntovr')
                       netrepl('osv,osf,osfo','osv+kfr,osf+kfr,osfo+kfr')
                    else
*                       if gnRmsk=1
                          sele tovmin
                          if netseek('t1','sklinr,mntovr')
                             arec:={}
                             getrec()
                             sele tovmout
                             netadd()
                             putrec()
                             netrepl('osn,osv,osf,osfo','0,kfr,kfr,kfr')
                          endif
                       endif
*                    endif
                 else
*                    if gnRmsk=1
                       sele tovout
                       if !netseek('t1','skloutr,ktlr')
                          sele tovin
                          if netseek('t1','sklinr,ktlr')
                             arec:={}
                             getrec()
                             sele tovout
                             netadd()
                             putrec()
                             netrepl('osn,osv,osf,osfo','0,0,0,0')
                          endif
                       endif
*                    endif
                 endif
                 sele pr2in
                 skip
              endd
           endif
           sele pr3in
           if netseek('t1','mnr')
              do while mn=mnr
                 arec:={}
                 getrec()
                 sele pr3out
                 netadd()
                 putrec()
                 sele pr3in
                 skip
              endd
           endif
           sele pr1in
           arec:={}
           getrec()
           sele pr1out
           netadd()
           putrec()
           set cons on
           ?str(mnr,6)+' '+'добавлена'
           set cons off
        endif
        sele pr1in
        skip
     endd
     set cons on
     ?'Приход удаление'
     sele pr1out
     go top
     do while !eof()
        rmskr=rmsk
        if gnEntrm=0
           if rmskr=0
              skip
              loop
           endif
        else
           if rmskr#0
              skip
              loop
           endif
        endif
        mnr=mn
        skloutr=skl
        przoutr=prz
        sele pr1in
        if !netseek('t2','mnr')
           sele pr2out
           if netseek('t1','mnr')
              do while mn=mnr
                 if przoutr=1
                    ktlr=ktl
                    mntovr=mntov
                    kfr=kf
                    sele tovout
                    if netseek('t1','skloutr,ktlr')
                       netrepl('osv,osf,osfo','osv-kfr,osf-kfr,osfo-kfr')
                    endif
                    sele tovmout
                    if netseek('t1','skloutr,mntovr')
                       netrepl('osv,osf,osfo','osv-kfr,osf-kfr,osfo-kfr')
                    endif
                 endif
                 netdel()
                 sele pr2out
                 skip
              endd
           endif
           sele pr3out
           if netseek('t1','mnr')
              do while mn=mnr
                 netdel()
                 sele pr3out
                 skip
              endd
           endif
           sele pr1out
           netdel()
           ?str(mnr,6)+' '+str(rmskr,1)+' удален'
        endif
        sele pr1out
        skip
     endd
     * Расход
     ?'Расход'
     set cons off
     sele rs1in
     do while !eof()
        sklinr=skl
        przinr=prz
        ttnr=ttn
        dopinr=dop
        if ttnr=0
           skip
           loop
        endif
        if gnEntrm=0.and.rmsk=0
           skip
           loop
        endif
        if gnEntrm=1.and.rmsk#0
           skip
           loop
        endif
        arec:={}
        getrec()
        sele rs1out
        if netseek('t1','ttnr')
           skloutr=skl
           przoutr=prz
           dopoutr=dop
           arec1:={}
           getrec('arec1')
           prcompr=1
           for i=1 to len(arec)
               if arec[i]#arec1[i]
                  prcompr=0
                  exit
               endif
           next
           if prcompr=0
              sele rs2in
              if netseek('t1','ttnr')
                 do while ttn=ttnr
                    ktlr=ktl
                    ktlpr=ktlp
                    pptr=ppt
                    sele rs2out
                    if !netseek('t3','ttnr,ktlpr,pptr,ktlr')
                       prcompr=0
                       exit
                    endif
                    sele rs2in
                    skip
                 endd
              endif
           endif
           if prcompr=1
              sele rs1in
              skip
              loop
           else
              sele rs2out
              if netseek('t1','ttnr')
                 do while ttn=ttnr
                    ktlr=ktl
                    mntovr=mntov
                    kvpr=kvp
                    if przoutr=1
                       sele tovout
                       if netseek('t1','skloutr,ktlr')
                          netrepl('osv,osf,osfo','osv+kvpr,osf+kvpr,osfo+kvpr')
                       endif
                       sele tovmout
                       if netseek('t1','skloutr,mntovr')
                          netrepl('osv,osf,osfo','osv+kvpr,osf+kvpr,osfo+kvpr')
                       endif
                    else
                       if empty(dopoutr)
                          sele tovout
                          if netseek('t1','skloutr,ktlr')
                             netrepl('osv','osv+kvpr')
                          endif
                          sele tovmout
                          if netseek('t1','skloutr,mntovr')
                             netrepl('osv','osv+kvpr')
                          endif
                       else
                          sele tovout
                          if netseek('t1','skloutr,ktlr')
                             netrepl('osv,osfo','osv+kvpr,osfo+kvpr')
                          endif
                          sele tovmout
                          if netseek('t1','skloutr,mntovr')
                             netrepl('osv,osfo','osv+kvpr,osfo+kvpr')
                          endif
                       endif
                    endif
                    sele rs2out
                    netdel()
                    skip
                 endd
              endif
              sele rs2in
              if netseek('t1','ttnr')
                 do while ttn=ttnr
                    ktlr=ktl
                    mntovr=mntovr
                    kvpr=kvp
                    arec:={}
                    getrec()
                    sele rs2out
                    netadd()
                    putrec()
                    if przinr=1
                       sele tovout
                       if netseek('t1','skloutr,ktlr')
                          netrepl('osv,osf,osfo','osv-kvpr,osf-kvpr,osfo-kvpr')
                       endif
                       sele tovmout
                       if netseek('t1','skloutr,mntovr')
                          netrepl('osv,osf,osfo','osv-kvpr,osf-kvpr,osfo-kvpr')
                       endif
                    else
                       if empty(dopinr)
                          sele tovout
                          if netseek('t1','skloutr,ktlr')
                             netrepl('osv','osv-kvpr')
                          endif
                          sele tovmout
                          if netseek('t1','skloutr,mntovr')
                             netrepl('osv','osv-kvpr')
                          endif
                       else
                          sele tovout
                          if netseek('t1','skloutr,ktlr')
                             netrepl('osv,osfo','osv-kvpr,osfo-kvpr')
                          endif
                          sele tovmout
                          if netseek('t1','skloutr,mntovr')
                             netrepl('osv,osfo','osv-kvpr,osfo-kvpr')
                          endif
                       endif
                    endif
                    sele rs2in
                    skip
                 endd
              endif
              sele rs3out
              if netseek('t1','ttnr')
                 do while ttn=ttnr
                    netdel()
                    skip
                 endd
                 sele rs3in
                 if netseek('t1','ttnr')
                    do while ttn=ttnr
                       arec:={}
                       getrec()
                       sele rs3out
                       netadd()
                       putrec()
                       sele rs3in
                       skip
                    endd
                 endif
              endif
              sele rs1in
              arec:={}
              getrec()
              sele rs1out
              reclock()
              putrec()
              netunlock()
              ?str(ttnr,6)+' обновлена'
           endif
        else
           skloutr=sklinr
           sele rs2in
           if netseek('t1','ttnr')
              do while ttn=ttnr
                 ktlr=ktl
                 mntovr=mntov
                 kvpr=kvp
                 arec:={}
                 getrec()
                 sele rs2out
                 netadd()
                 putrec()
                 if przinr=1
                    sele tovout
                    if netseek('t1','skloutr,ktlr')
                       netrepl('osv,osf,osfo','osv-kvpr,osf-kvpr,osfo-kvpr')
                    endif
                    sele tovmout
                    if netseek('t1','skloutr,mntovr')
                       netrepl('osv,osf,osfo','osv-kvpr,osf-kvpr,osfo-kvpr')
                    endif
                 else
                    if empty(dopinr)
                       sele tovout
                       if netseek('t1','skloutr,ktlr')
                          netrepl('osv','osv-kvpr')
                       endif
                       sele tovmout
                       if netseek('t1','skloutr,mntovr')
                          netrepl('osv','osv-kvpr')
                       endif
                    else
                       sele tovout
                       if netseek('t1','skloutr,ktlr')
                          netrepl('osv,osfo','osv-kvpr,osfo-kvpr')
                       endif
                       sele tovmout
                       if netseek('t1','skloutr,mntovr')
                          netrepl('osv,osfo','osv-kvpr,osfo-kvpr')
                       endif
                    endif
                 endif
                 sele rs2in
                 skip
              endd
           endif
           sele rs3in
           if netseek('t1','ttnr')
              do while ttn=ttnr
                 arec:={}
                 getrec()
                 sele rs3out
                 netadd()
                 putrec()
                 sele rs3in
                 skip
              endd
           endif
           sele rs1in
           arec:={}
           getrec()
           sele rs1out
           netadd()
           putrec()
           set cons on
           ?str(ttnr,6)+' добавлена'
           set cons off
        endif
        sele rs1in
        skip
     endd
     set cons on
     ?'Расход удаление'
     sele rs1out
     go top
     do while !eof()
        rmskr=rmsk
        if gnEntrm=0
           if rmskr=0
              skip
              loop
           endif
        else
           if rmskr#0
              skip
              loop
           endif
        endif
        ttnr=ttn
        przoutr=prz
        skloutr=skl
        dopoutr=dop
        sele rs1in
        if !netseek('t1','ttnr')
           sele rs2out
           if netseek('t1','ttnr')
              do while ttn=ttnr
                 ktlr=ktl
                 pptr=ppt
                 ktlpr=ktlp
                 kvpr=kvp
                 netdel()
                 if przoutr=1
                    sele tovout
                    if netseek('t1','skloutr,ktlr')
                       netrepl('osv,osf,osfo','osv+kvpr,osf+kvpr,osfo+kvpr')
                    endif
                    sele tovmout
                    if netseek('t1','skloutr,mntovr')
                       netrepl('osv,osf,osfo','osv+kvpr,osf+kvpr,osfo+kvpr')
                    endif
                 else
                    if empty(dopinr)
                       sele tovout
                       if netseek('t1','skloutr,ktlr')
                          netrepl('osv','osv+kvpr')
                       endif
                       sele tovmout
                       if netseek('t1','skloutr,mntovr')
                          netrepl('osv','osv+kvpr')
                       endif
                    else
                       sele tovout
                       if netseek('t1','skloutr,ktlr')
                          netrepl('osv,osfo','osv+kvpr,osfo+kvpr')
                       endif
                       sele tovmout
                       if netseek('t1','skloutr,mntovr')
                          netrepl('osv,osfo','osv+kvpr,osfo+kvpr')
                       endif
                    endif
                 endif
                 sele rs2out
                 skip
              endd
           endif
           sele rs3out
           if netseek('t1','ttnr')
              do while ttn=ttnr
                 netdel()
                 sele rs3out
                 skip
              endd
           endif
           sele rs1out
           netdel()
           ?str(ttnr,6)+' '+str(rmskr,1)+' удален'
        endif
        sele rs1out
        skip
     endd
     * Остатки(Характеристики,Прайсы)
     set cons off
     if gnEntrm=1
        set cons on
        ?'TOV'
        set cons off
        sele tovin
        go top
        do while !eof()
           sklr=skl
           ktlr=ktl
           if ktlr=0
              skip
              loop
           endif
           arec:={}
           getrec()
           sele tovout
           if netseek('t1','sklr,ktlr')
              osnr=osn
              osvr=osv
              osfr=osf
              osfor=osfo
              osfmr=osfm
              if tpstpokr=0
                 reclock()
                 putrec()
                 netrepl('osn,osv,osf,osfo,osfm','osnr,osvr,osfr,osfor,osfmr')
                 ?str(sklr,7)+' '+str(ktlr,9)+' обновлена'
              endif
           else
              netadd()
              putrec()
              set cons on
              ?str(sklr,7)+' '+str(ktlr,9)+' добавлена'
              set cons off
           endif
           sele tovin
           skip
        endd
        set cons on
        ?'TOVM'
        set cons off
        sele tovmin
        go top
        do while !eof()
           sklr=skl
           mntovr=mntov
           if mntovr=0
              skip
              loop
           endif
           arec:={}
           getrec()
           sele tovmout
           if netseek('t1','sklr,mntovr')
              osnr=osn
              osvr=osv
              osfr=osf
              osfor=osfo
              osfmr=osfm
              if tpstpokr=0
                 reclock()
                 putrec()
                 netrepl('osn,osv,osf,osfo,osfm','osnr,osvr,osfr,osfor,osfmr')
                 ?'TOVM '+str(sklr,7)+' '+str(mntovr,7)+' обновлена'
              endif
           else
              netadd()
              putrec()
              set cons on
              ?'TOVM '+str(sklr,7)+' '+str(mntovr,7)+' добавлена'
              set cons off
           endif
           sele ctov
           if netseek('t1','mntovr')
              if tpstpokr=0
                 reclock()
                 putrec()
                 netrepl('skl,osn,osv,osf,osvo,osfo,osfm','0,0,0,0,0,0,0')
                 ?'CTOV '+str(mntovr,7)+' обновлена'
              endif
           else
              netadd()
              putrec()
              netrepl('skl,osn,osv,osf,osvo,osfo,osfm','0,0,0,0,0,0,0')
              set cons on
              ?'CTOV  '+str(mntovr,7)+' добавлена'
              set cons off
           endif
           sele tovmin
           skip
        endd
     endif
     nuse('rs1in')
     nuse('rs2in')
     nuse('rs3in')
     nuse('pr1in')
     nuse('pr2in')
     nuse('pr3in')
     nuse('tovin')
     nuse('tovmin')
     nuse('rs1out')
     nuse('rs2out')
     nuse('rs3out')
     nuse('pr1out')
     nuse('pr2out')
     nuse('pr3out')
     nuse('tovout')
     nuse('tovmout')
     if gnEntrm=1
        nuse('ctov')
     endif
set cons on
retu .t.

func updtent()
?'ENT'
dirinr=subs(pathinr,1,len(pathinr)-1)
if dirchange(dirinr)#0
   retu .t.
endif
diroutr=subs(pathoutr,1,len(pathoutr)-1)
if dirchange(diroutr)#0
   retu .t.
endif
?'NDS'
pathr=pathinr
netuse('nds','ndsin',,1)
pathr=pathoutr
netuse('nds','ndsout',,1)
sele ndsin
go top
do while !eof()
   nomndsr=nomnds
   if nomndsr=0
      skip
      loop
   endif
   arec:={}
   getrec()
   sele ndsout
   if !netseek('t1','nomndsr')
      netadd()
      putrec()
   else
      arec1:={}
      getrec('arec1')
      prupdtr=0
      for i=1 to len(arec)
          if arec[i]#arec1[i]
             prupdtr=1
             exit
          endif
      next
      if prupdtr=1
         sele ndsout
         reclock()
         putrec()
         netunlock()
         ?str(nomndsr,10)+' '+''
      endif
   endif
   sele ndsin
   skip
endd
nuse('ndsin')
nuse('ndsout')
retu .t.

func copskl()
pathr=pathoutr
netuse('rs1','rs1out','e',1)
netuse('rs2','rs2out','e',1)
netuse('rs3','rs3out','e',1)
netuse('pr1','pr1out','e',1)
netuse('pr2','pr2out','e',1)
netuse('pr3','pr3out','e',1)

sele pr1out
go top
do while !eof()
   if gnEntrm=0.and.rmsk=0
      skip
      loop
   endif
   if gnEntrm=1.and.rmsk#0
      skip
      loop
   endif
   mnr=mn
   sele pr2out
   if netseek('t1','mnr')
      do while mn=mnr
         dele
         sele pr2out
         skip
      endd
   endif
   sele pr3out
   if netseek('t1','mnr')
      do while mn=mnr
         dele
         sele pr3out
         skip
      endd
   endif
   sele pr1out
   dele
   skip
endd

sele rs1out
go top
do while !eof()
   if gnEntrm=0.and.rmsk=0
      skip
      loop
   endif
   if gnEntrm=1.and.rmsk#0
      skip
      loop
   endif
   ttnr=ttn
   sele rs2out
   if netseek('t1','ttnr')
      do while ttn=ttnr
         dele
         sele rs2out
         skip
      endd
   endif
   sele rs3out
   if netseek('t1','ttnr')
      do while ttn=ttnr
         dele
         sele rs3out
         skip
      endd
   endif
   sele rs1out
   dele
   skip
endd

sele rs1out
pack
use
sele rs2out
pack
use
sele rs3out
pack
use
sele pr1out
pack
use
sele pr2out
pack
use
sele pr3out
pack
use
retu .t.

func copbank()
pathr=pathoutr
netuse('dokz','dokzout','e',1)
netuse('doks','doksout','e',1)
netuse('dokk','dokkout','e',1)

sele dokkout
if gnEntrm=0
   dele all for prc.or.mn=0.or.rmsk#gnRmsk.or.bs_d=99.or.bs_k=99.or.bs_d=301001.or.bs_k=301001
else
   dele all for prc.or.mn=0.or.rmsk#gnRmsk.or.bs_d=99.or.bs_k=99
endif
pack

sele dokzout
go top
do while !eof()
   mnr=mn
   sele dokkout
   if !netseek('t1','mnr')
      sele dokzout
      netdel()
   endif
   sele dokzout
   skip
endd

sele doksout
go top
do while !eof()
   mnr=mn
   sele dokkout
   if !netseek('t1','mnr')
      sele doksout
      netdel()
   endif
   sele doksout
   skip
endd


sele dokzout
pack
use
sele doksout
pack
use
sele dokkout
pack
use
retu .t.

func updtbank()
pathr=pathinr
if !netfile('dokk',1)
   retu .t.
endif
pathr=pathoutr
if !netfile('dokk',1)
   retu .t.
endif
netuse('dokk','dokkout',,1)
netuse('doks','doksout',,1)
netuse('dokz','dokzout',,1)

sele dokzout
go top
do while !eof()
   if mn=0
      sele dokzout
      skip
      loop
   endif
   if gnEntrm=0.and.bs#rmbsr.or.gnEntrm=1.and.bs=gnRmbs
      sele dokzout
      skip
      loop
   endif
   mnr=mn
   sele doksout
   if netseek('t1','mnr')
      do while mn=mnr
         netdel()
         skip
      endd
   endif
   sele dokkout
   if netseek('t1','mnr')
      do while mn=mnr
         netdel()
         skip
      endd
   endif
   sele dokzout
   netdel()
   skip
endd

sele dokkout
?pathinr
appe from (pathinr+'dok_k')
sele doksout
appe from (pathinr+'dok_s')
sele dokzout
appe from (pathinr+'dok_z') for mn#0

nuse('dokkout')
nuse('doksout')
nuse('dokzout')
retu .t.

func rmvb()
if select('sl')=0
   sele 0
   use _slct alias sl excl
   zap
endif
crtt('rmvb','f:npp c:n(2) f:nnpp c:c(20)')
sele 0
use rmvb
appe blank
repl npp with 1,nnpp with 'ASTRU,DBFT,DIR'
appe blank
repl npp with 2,nnpp with 'Клиенты'
appe blank
repl npp with 3,nnpp with 'Скидки'
appe blank
repl npp with 4,nnpp with 'Прайсы'
appe blank
repl npp with 5,nnpp with 'Пользователи'
appe blank
repl npp with 6,nnpp with 'Агенты'
appe blank
repl npp with 7,nnpp with 'Склад новые'
appe blank
repl npp with 8,nnpp with 'Банк новые'
go top
rcrmvbr=recn()
do while .t.
   sele rmvb
   go rcrmvbr
   rcrmvbr=slcf('rmvb',,,,,"e:npp h:'nom' c:n(2) e:nnpp h:'Наименование' c:c(20)",,1,,,,,'Выбор')
   if lastkey()=27
      exit
   endif
   if lastkey()=13
      sele sl
      go top
      do while !eof()
         sele sl
         nppr=val(kod)
         sele rmvb
         locate for npp=nppr
         nnppr=nnpp
         @ 1,1 say str(nppr,2)+' '+nnppr
         @ 2,1 say 'Добавлено'
         @ 3,1 say 'Обновлено'
         @ 4,1 say 'Удалено  '
         do case
            case nppr=1 && ASTRU,DBFT,DIR
                 store 0 to kinsr,kupdtr
                 @ 2,15 say str(kinsr,4)
                 @ 3,15 say str(kupdtr,4)
                 pathinr=pathminr+gcDir_a
                 pathoutr=pathmoutr+gcDir_a
                 adirect=directory(pathinr+'*.*')
                 if len(adirect)#0
                    for i=1 to len(adirect)
                        fl=adirect[i,1]
                        fextr=lower(right(fl,3))
                        if fextr='dbf'.or.fextr='fpt'
                           copy file (pathinr+fl) to (pathoutr+fl)
                        endif
                    next
                 endif
                 pathinr=pathminr+gcDir_c
                 if file(pathinr+'dbft.dbf')
                    sele 0
                    use (pathinr+'dbft') alias dbftin
                    do while !eof()
                       nf_r=nf
                       arec:={}
                       getrec()
                       sele dbft
                       locate for nf=nf_r
                       if !foun()
                          netadd()
                       else
                          reclock()
                       endif
                       putrec()
                       netunlock()
                       sele dbftin
                       skip
                    endd
                    sele dbftin
                    use
                 endif
                 if file(pathinr+'dir.dbf')
                    sele 0
                    use (pathinr+'dir') alias dirin
                    do while !eof()
                       dir_r=dir
                       arec:={}
                       getrec()
                       sele dir
                       locate for dir=dir_r
                       if !foun()
                          netadd()
                       else
                          reclock()
                       endif
                       putrec()
                       netunlock()
                       sele dirin
                       skip
                    endd
                    sele dirin
                    use
                 endif
            case nppr=2 && KLN
                 store 0 to kinsr,kupdtr,kdelr,rccr,rcnr
                 @ 1,40 say space(20)
                 @ 2,15 say str(kinsr,4)
                 @ 3,15 say str(kupdtr,4)
                 @ 4,15 say str(kdelr,4)
                 pathinr=pathminr+gcDir_c
                 pathoutr=pathmoutr+gcDir_c
                 pathr=pathinr
                 if !netfile('kln',1)
                    sele sl
                    skip
                    loop
                 endif
                 netuse('kln','klnin',,1)
                 set orde to
                 rccr=recc()
                 @ 1,40 say str(rccr,10)
                 go top
                 pathr=pathoutr
                 if !netfile('kln',1)
                    nuse('klnin')
                    sele sl
                    skip
                    loop
                 endif
                 netuse('kln','klnout',,1)
                 sele klnin
                 do while !eof()
                    rcnr=recn()
                    @ 1,50 say str(rcnr,10)
                    kklr=kkl
                    nklr=nkl
                    arec:={}
                    getrec()
                    sele klnout
                    if netseek('t1','kklr')
                       reclock()
                       arec1:={}
                       getrec('arec1')
                       prcompr=1
                       for i=1 to len(arec)
                           if arec[i]#arec1[i]
                              prcompr=0
                              exit
                           endif
                       next
                       if prcompr=0
                          putrec()
                          kupdtr=kupdtr+1
                          @ 3,15 say str(kupdtr,4)
*                          ?str(kklr,7)+' '+subs(nklr,1,40)+' обновлен'
                       endif
                    else
                       netadd()
                       putrec()
                       kinsr=kinsr+1
                       @ 2,15 say str(kinsr,4)
*                       ?str(kklr,7)+' '+subs(nklr,1,40)+' добавлен'
                    endif
                    netunlock()
                    sele klnin
                    skip
                 endd
                 sele klnout
                 set orde to
                 rccr=recc()
                 @ 1,40 say str(rccr,10)
                 go top
                 sele klnin
                 set orde to tag t1
                 sele klnout
                 do while !eof()
                    rcnr=recn()
                    @ 1,50 say str(rcnr,10)
                    kklr=kkl
                    sele klnin
                    if !netseek('t1','kklr')
                       sele klnout
                       netdel()
                       kdelr=kdelr+1
                       @ 4,15 say str(kdelr,4)
                    endif
                    sele klnout
                    skip
                 endd
                 nuse('klnin')
                 nuse('klnout')
            case nppr=3 && KLNNAC,BRNAC
                 store 0 to kinsr,kupdtr,kdelr,rccr,rcnr
                 @ 2,15 say str(kinsr,4)
                 @ 3,15 say str(kupdtr,4)
                 @ 4,15 say str(kdelr,4)
                 pathinr=pathminr+gcDir_e
                 if !file(pathinr+'klnnac.dbf')
                    sele sl
                    skip
                    loop
                 endif
                 pathoutr=pathmoutr+gcDir_e
                 if !file(pathoutr+'klnnac.dbf')
                    sele sl
                    skip
                    loop
                 endif
                 pathr=pathinr
                 netuse('klnnac','klnin',,1)
                 set orde to
                 rccr=recc()
                 @ 1,40 say str(rccr,10)
                 go top
                 pathr=pathoutr
                 netuse('klnnac','klnout',,1)
                 sele klnin
                 do while !eof()
                    rcnr=recn()
                    @ 1,50 say str(rcnr,10)
                    kklr=kkl
                    izgr=izg
                    kgr=kg
                    arec:={}
                    getrec()
                    sele klnout
                    if netseek('t1','kklr,izgr,kgr')
                       reclock()
                       arec1:={}
                       getrec('arec1')
                       prcompr=1
                       for i=1 to len(arec)
                           if arec[i]#arec1[i]
                              prcompr=0
                              exit
                           endif
                       next
                       if prcompr=0
                          putrec()
                          kupdtr=kupdtr+1
                          @ 3,15 say str(kupdtr,4)
*                          ?str(kklr,7)+' '+str(izgr,7)+' '+str(kgr,3)+' обновлен'
                       endif
                    else
                       netadd()
                       putrec()
                       kinsr=kinsr+1
                       @ 2,15 say str(kinsr,4)
*                       ?str(kklr,7)+' '+str(izgr,7)+' '+str(kgr,3)+' добавлен'
                    endif
                    netunlock()
                    sele klnin
                    skip
                 endd
                 sele klnout
                 set orde to
                 rccr=recc()
                 @ 1,40 say str(rccr,10)
                 go top
                 sele klnin
                 set orde to tag t1
                 sele klnout
                 do while !eof()
                    rcnr=recn()
                    @ 1,50 say str(rcnr,10)
                    kklr=kkl
                    izgr=izg
                    kgr=kg
                    sele klnin
                    if !netseek('t1','kklr,izgr,kgr')
                       sele klnout
                       netdel()
                       kdelr=kdelr+1
                       @ 4,15 say str(kdelr,4)
                    endif
                    sele klnout
                    skip
                 endd
                 nuse('klnin')
                 nuse('klnout')
                 *BRNAC
                 store 0 to kinsr,kupdtr,kdelr,rccr,rcnr
                 @ 2,15 say str(kinsr,4)
                 @ 3,15 say str(kupdtr,4)
                 @ 4,15 say str(kdelr,4)
                 pathinr=pathminr+gcDir_e
                 if !file(pathinr+'brnac.dbf')
                    sele sl
                    skip
                    loop
                 endif
                 pathoutr=pathmoutr+gcDir_e
                 if !file(pathoutr+'brnac.dbf')
                    sele sl
                    skip
                    loop
                 endif
                 pathr=pathinr
                 netuse('brnac','klnin',,1)
                 set orde to
                 rccr=recc()
                 @ 1,40 say str(rccr,10)
                 go top
                 pathr=pathoutr
                 netuse('brnac','klnout',,1)
                 sele klnin
                 do while !eof()
                    rcnr=recn()
                    @ 1,50 say str(rcnr,10)
                    kklr=kkl
                    mkeepr=mkeep
                    brandr=brand
                    arec:={}
                    getrec()
                    sele klnout
                    if netseek('t1','kklr,mkeepr,brandr')
                       reclock()
                       arec1:={}
                       getrec('arec1')
                       prcompr=1
                       for i=1 to len(arec)
                           if arec[i]#arec1[i]
                              prcompr=0
                              exit
                           endif
                       next
                       if prcompr=0
                          putrec()
                          kupdtr=kupdtr+1
                          @ 3,15 say str(kupdtr,4)
*                          ?str(kklr,7)+' '+str(izgr,7)+' '+str(kgr,3)+' обновлен'
                       endif
                    else
                       netadd()
                       putrec()
                       kinsr=kinsr+1
                       @ 2,15 say str(kinsr,4)
*                       ?str(kklr,7)+' '+str(izgr,7)+' '+str(kgr,3)+' добавлен'
                    endif
                    netunlock()
                    sele klnin
                    skip
                 endd
                 sele klnout
                 set orde to
                 rccr=recc()
                 @ 1,40 say str(rccr,10)
                 go top
                 sele klnin
                 set orde to tag t1
                 sele klnout
                 do while !eof()
                    rcnr=recn()
                    @ 1,50 say str(rcnr,10)
                    kklr=kkl
                    mkeepr=mkeep
                    brandr=brand
                    sele klnin
                    if !netseek('t1','kklr,mkeepr,brandr')
                       sele klnout
                       netdel()
                       kdelr=kdelr+1
                       @ 4,15 say str(kdelr,4)
                    endif
                    sele klnout
                    skip
                 endd
                 nuse('klnin')
                 nuse('klnout')
                 *MNNAC
                 store 0 to kinsr,kupdtr,kdelr,rccr,rcnr
                 @ 2,15 say str(kinsr,4)
                 @ 3,15 say str(kupdtr,4)
                 @ 4,15 say str(kdelr,4)
                 pathinr=pathminr+gcDir_e
                 if !file(pathinr+'mnnac.dbf')
                    sele sl
                    skip
                    loop
                 endif
                 pathoutr=pathmoutr+gcDir_e
                 if !file(pathoutr+'mnnac.dbf')
                    sele sl
                    skip
                    loop
                 endif
                 pathr=pathinr
                 netuse('mnnac','klnin',,1)
                 set orde to
                 rccr=recc()
                 @ 1,40 say str(rccr,10)
                 go top
                 pathr=pathoutr
                 netuse('mnnac','klnout',,1)
                 sele klnin
                 do while !eof()
                    rcnr=recn()
                    @ 1,50 say str(rcnr,10)
                    kklr=kkl
                    brandr=brand
                    mntovr=mntov
                    arec:={}
                    getrec()
                    sele klnout
                    if netseek('t1','kklr,brandr,mntovr')
                       reclock()
                       arec1:={}
                       getrec('arec1')
                       prcompr=1
                       for i=1 to len(arec)
                           if arec[i]#arec1[i]
                              prcompr=0
                              exit
                           endif
                       next
                       if prcompr=0
                          putrec()
                          kupdtr=kupdtr+1
                          @ 3,15 say str(kupdtr,4)
*                          ?str(kklr,7)+' '+str(izgr,7)+' '+str(kgr,3)+' обновлен'
                       endif
                    else
                       netadd()
                       putrec()
                       kinsr=kinsr+1
                       @ 2,15 say str(kinsr,4)
*                       ?str(kklr,7)+' '+str(izgr,7)+' '+str(kgr,3)+' добавлен'
                    endif
                    netunlock()
                    sele klnin
                    skip
                 endd
                 sele klnout
                 set orde to
                 rccr=recc()
                 @ 1,40 say str(rccr,10)
                 go top
                 sele klnin
                 set orde to tag t1
                 sele klnout
                 do while !eof()
                    rcnr=recn()
                    @ 1,50 say str(rcnr,10)
                    kklr=kkl
                    brandr=brand
                    mntovr=mntov
                    sele klnin
                    if !netseek('t1','kklr,brandr,mntovr')
                       sele klnout
                       netdel()
                       kdelr=kdelr+1
                       @ 4,15 say str(kdelr,4)
                    endif
                    sele klnout
                    skip
                 endd
                 nuse('klnin')
                 nuse('klnout')
            case nppr=4 && CTOV
                 store 0 to kinsr,kupdtr,rccr,rcnr
                 @ 2,15 say str(kinsr,4)
                 @ 3,15 say str(kupdtr,4)
                 pathinr=pathminr+gcDir_e
                 if !file(pathinr+'ctov.dbf')
                    sele sl
                    skip
                    loop
                 endif
                 pathoutr=pathmoutr+gcDir_e
                 if !file(pathoutr+'ctov.dbf')
                    sele sl
                    skip
                    loop
                 endif
                 pathr=pathinr
                 netuse('ctov','ctovin',,1)
                 set orde to
                 rccr=recc()
                 @ 1,40 say str(rccr,10)
                 go top
                 pathr=pathoutr
                 netuse('ctov','ctovout',,1)
                 sele ctovin
                 do while !eof()
                    rcnr=recn()
                    @ 1,50 say str(rcnr,10)
                    mntovr=mntov
                    arec:={}
                    getrec()
                    sele ctovout
                    if netseek('t1','mntovr')
                       reclock()
                       arec1:={}
                       getrec('arec1')
                       prcompr=1
                       for i=1 to len(arec)
                           if fieldname(i)='KTOBLK'
                              loop
                           endif
                           if arec[i]#arec1[i]
                              prcompr=0
                              exit
                           endif
                       next
                       if prcompr=0
                          putrec()
                          kupdtr=kupdtr+1
                          @ 3,15 say str(kupdtr,4)
*                          ?str(kklr,7)+' '+str(izgr,7)+' '+str(kgr,3)+' обновлен'
                       endif
                    else
                       netadd()
                       putrec()
                       kinsr=kinsr+1
                       @ 2,15 say str(kinsr,4)
*                       ?str(kklr,7)+' '+str(izgr,7)+' '+str(kgr,3)+' добавлен'
                    endif
                    netunlock()
                    sele ctovin
                    skip
                 endd
                 nuse('ctovin')
                 nuse('ctovout')
            case nppr=5 && SPENG
                 store 0 to kinsr,kupdtr,rccr,rcnr
                 @ 2,15 say str(kinsr,4)
                 @ 3,15 say str(kupdtr,4)
                 pathinr=pathminr+gcDir_c
                 if !file(pathinr+'speng.dbf')
                    sele sl
                    skip
                    loop
                 endif
                 pathoutr=pathmoutr+gcDir_c
                 if !file(pathoutr+'speng.dbf')
                    sele sl
                    skip
                    loop
                 endif
                 pathr=pathinr
                 netuse('speng','spengin',,1)
                 set orde to
                 rccr=recc()
                 @ 1,40 say str(rccr,10)
                 go top
                 netuse('spenge','spengein',,1)
                 pathr=pathoutr
                 netuse('speng','spengout',,1)
                 netuse('spenge','spengeout',,1)
                 sele spengin
                 do while !eof()
                    rcnr=recn()
                    @ 1,50 say str(rcnr,10)
                    kgrr=kgr
                    arec:={}
                    getrec()
                    sele spengout
                    if netseek('t1','kgrr')
                       reclock()
                       arec1:={}
                       getrec('arec1')
                       prcompr=1
                       for i=1 to len(arec)
                           if arec[i]#arec1[i]
                              prcompr=0
                              exit
                           endif
                       next
                       if prcompr=0
                          putrec()
                          kupdtr=kupdtr+1
                          @ 3,15 say str(kupdtr,4)
*                          ?str(kklr,7)+' '+str(izgr,7)+' '+str(kgr,3)+' обновлен'
                       endif
                    else
                       netadd()
                       putrec()
                       kinsr=kinsr+1
                       @ 2,15 say str(kinsr,4)
*                       ?str(kklr,7)+' '+str(izgr,7)+' '+str(kgr,3)+' добавлен'
                    endif
                    netunlock()
                    sele spengein
                    if netseek('t1','kgrr')
                       do while kgr=kgrr &&!eof()
                          skr=sk
                          arec:={}
                          getrec()
                          sele spengeout
                          if netseek('t1','kgrr,skr')
                             reclock()
                             arec1:={}
                             getrec('arec1')
                             prcompr=1
                             for i=1 to len(arec)
                                 if arec[i]#arec1[i]
                                    prcompr=0
                                    exit
                                 endif
                             next
                             if prcompr=0
                                putrec()
                             endif
                          else
                             netadd()
                             putrec()
                          endif
                          netunlock()
                          sele spengein
                          skip
                          if eof()
                             exit
                          endif
                       endd
                    endif
                    sele spengin
                    skip
                 endd
                 nuse('spengin')
                 nuse('spengein')
                 nuse('spengout')
                 nuse('spengeout')
            case nppr=6 && S_TAG
                 store 0 to kinsr,kupdtr,rccr,rcnr
                 @ 2,15 say str(kinsr,4)
                 @ 3,15 say str(kupdtr,4)
                 pathinr=pathminr+gcDir_c
                 if !file(pathinr+'s_tag.dbf')
                    sele sl
                    skip
                    loop
                 endif
                 pathoutr=pathmoutr+gcDir_c
                 if !file(pathoutr+'s_tag.dbf')
                    sele sl
                    skip
                    loop
                 endif
                 pathr=pathinr
                 netuse('s_tag','s_tagin',,1)
                 set orde to
                 rccr=recc()
                 @ 1,40 say str(rccr,10)
                 go top
                 pathr=pathoutr
                 netuse('s_tag','s_tagout',,1)
                 sele s_tagin
                 do while !eof()
                    rcnr=recn()
                    @ 1,50 say str(rcnr,10)
                    kod_r=kod
                    arec:={}
                    getrec()
                    sele s_tagout
                    if netseek('t1','kod_r')
                       reclock()
                       arec1:={}
                       getrec('arec1')
                       prcompr=1
                       for i=1 to len(arec)
                           if arec[i]#arec1[i]
                              prcompr=0
                              exit
                           endif
                       next
                       if prcompr=0
                          putrec()
                          kupdtr=kupdtr+1
                          @ 3,15 say str(kupdtr,4)
*                          ?str(kklr,7)+' '+str(izgr,7)+' '+str(kgr,3)+' обновлен'
                       endif
                    else
                       netadd()
                       putrec()
                       kinsr=kinsr+1
                       @ 2,15 say str(kinsr,4)
*                       ?str(kklr,7)+' '+str(izgr,7)+' '+str(kgr,3)+' добавлен'
                    endif
                    netunlock()
                    sele s_tagin
                    skip
                 endd
                 nuse('s_tagin')
                 nuse('s_tagout')
            case nppr=7 && Склад новые
                 *SKLAD
                 netuse('cskl')
                 do while !eof()
                    if ent#gnEnt
                       skip
                       loop
                    endif
                    if rm=0 &&.or.rm#1.and.(rm#srmskr)
                       skip
                       loop
                    endif
                    tpstpokr=tpstpok
                    yy=year(gdTd)
                    mm=month(gdTd)
                    pathinr=pathminr+gcDir_e+'g'+str(yy,4)+'\m'+iif(mm<10,'0'+str(mm,1),str(mm,2))+'\'+alltrim(path)
                    pathoutr=pathmoutr+gcDir_e+'g'+str(yy,4)+'\m'+iif(mm<10,'0'+str(mm,1),str(mm,2))+'\'+alltrim(path)
                    dir_r=subs(pathinr,1,len(pathinr)-1)
                    if dirchange(dir_r)#0
                       sele cskl
                       skip
                       loop
                     endif
                     if !file(pathinr+'tprho11.dbf')
                        sele cskl
                        skip
                        loop
                     endif
                     if !file(pathoutr+'tprds01.dbf')
                        sele cskl
                        skip
                        loop
                     endif
                     updtskln()
                     sele cskl
                     skip
                 endd
                 nuse('cskl')
            case nppr=8 && Банк новые
                 *BANK
                 yy=year(gdTd)
                 mm=month(gdTd)
                 pathinr=pathminr+gcDir_e+'g'+str(yy,4)+'\m'+iif(mm<10,'0'+str(mm,1),str(mm,2))+'\'+gcDir_b
                 pathoutr=pathmoutr+gcDir_e+'g'+str(yy,4)+'\m'+iif(mm<10,'0'+str(mm,1),str(mm,2))+'\'+gcDir_b
                 dirinr=subs(pathinr,1,len(pathinr)-1)
                 if dirchange(dirinr)#0
                    sele sl
                    skip
                    loop
                 endif
                 diroutr=subs(pathoutr,1,len(pathoutr)-1)
                 if dirchange(diroutr)#0
                    sele sl
                    skip
                    loop
                 endif
                 updtbankn()
         endc
         sele sl
         skip
      endd
   endif
endd
sele rmvb
use
sele sl
use
retu .t.

func copent()
*KLNNAC
pathr=pathoutr
if netfile('klnnac',1)
   netuse('klnnac',,'e',1)
   dele all for nac=0.and.nac1=0 &&.and.kg#999
   pack
   use
endif
*BRNNAC
pathr=pathoutr
if netfile('brnac',1)
   netuse('brnac',,'e',1)
   dele all for nac=0.and.nac1=0 &&.and.kg#999
   pack
   use
endif
*MNNNAC
pathr=pathoutr
if netfile('mnnac',1)
   netuse('mnnac',,'e',1)
   dele all for nac=0.and.nac1=0 &&.and.kg#999
   pack
   use
endif
retu .t.


func updtskln()
set cons off
pathr=pathinr
netuse('rs1','rs1in',,1)
netuse('rs2','rs2in',,1)
netuse('rs3','rs3in',,1)
netuse('pr1','pr1in',,1)
netuse('pr2','pr2in',,1)
netuse('pr3','pr3in',,1)
netuse('tov','tovin',,1)
netuse('tovm','tovmin',,1)
pathr=pathoutr
netuse('rs1','rs1out',,1)
netuse('rs2','rs2out',,1)
netuse('rs3','rs3out',,1)
netuse('pr1','pr1out',,1)
netuse('pr2','pr2out',,1)
netuse('pr3','pr3out',,1)
netuse('tov','tovout',,1)
netuse('tovm','tovmout',,1)
netuse('ctov')
* Приход
store 0 to kinsr,kupdtr,kdelr,rccr,rcnr
@ 2,15 say str(kinsr,4)
@ 3,15 say str(kupdtr,4)
@ 4,15 say str(kdelr,4)
sele pr1in
rccr=recc()
@ 1,30 say space(49)
@ 1,30 say 'Приход'
@ 1,40 say str(rccr,10)
go top
do while !eof()
   rcnr=recn()
   @ 1,50 say str(rcnr,10)
   if prz=0
      skip
      loop
   endif
   if gnEntrm=1.and.rmsk#0
      skip
      loop
   endif
   if mn=0
      skip
      loop
   endif
   mnr=mn
   sele pr1out
   if netseek('t2','mnr')
      sele pr1in
      skip
      loop
   endif
   sele pr2out
   if netseek('t1','mnr')
      do while mn=mnr
         netdel()
         skip
      endd
   endif
   sele pr3out
   if netseek('t1','mnr')
      do while mn=mnr
         netdel()
         skip
      endd
   endif
   sele pr1in
   sklinr=skl
   skloutr=sklinr
   arec:={}
   getrec()
   sele pr2in
   if netseek('t1','mnr')
      do while mn=mnr
         ktlr=ktl
         mntovr=mntov
         kfr=kf
         arec:={}
         getrec()
         sele pr2out
         netadd()
         putrec()
         sele tovout
         if netseek('t1','skloutr,ktlr')
            netrepl('osv,osf,osfo','osv+kfr,osf+kfr,osfo+kfr')
         else
            sele tovin
            if netseek('t1','sklinr,ktlr')
               arec:={}
               getrec()
               sele tovout
               netadd()
               putrec()
               netrepl('osn,osv,osf,osfo','0,kfr,kfr,kfr')
            endif
         endif
         sele tovmout
         if netseek('t1','skloutr,mntovr')
            netrepl('osv,osf,osfo','osv+kfr,osf+kfr,osfo+kfr')
         else
            sele tovmin
            if netseek('t1','sklinr,mntovr')
               arec:={}
               getrec()
               sele tovmout
               netadd()
               putrec()
               netrepl('osn,osv,osf,osfo','0,kfr,kfr,kfr')
            endif
         endif
         sele pr2in
         skip
      endd
   endif
   sele pr3in
   if netseek('t1','mnr')
      do while mn=mnr
         arec:={}
         getrec()
         sele pr3out
         netadd()
         putrec()
         sele pr3in
         skip
      endd
   endif
   sele pr1in
   arec:={}
   getrec()
   sele pr1out
   netadd()
   putrec()
   kinsr=kinsr+1
   @ 2,15 say str(kinsr,4)
   sele pr1in
   skip
endd
* Расход
store 0 to kinsr,kupdtr,kdelr,rccr,rcnr
@ 2,15 say str(kinsr,4)
@ 3,15 say str(kupdtr,4)
@ 4,15 say str(kdelr,4)
sele rs1in
rccr=recc()
@ 1,30 say space(49)
@ 1,30 say 'Расход'
@ 1,40 say str(rccr,10)
go top
sele rs1in
do while !eof()
   rcnr=recn()
   @ 1,50 say str(rcnr,10)
   if gnEntrm=1.and.rmsk#0
      skip
      loop
   endif
   if ttn=0
      skip
      loop
   endif
   ttnr=ttn
   sele rs1out
   if netseek('t1','ttnr')
      sele rs1in
      skip
      loop
   endif
   sele rs2out
   if netseek('t1','ttnr')
      do while ttn=ttnr
         netdel()
         skip
      endd
   endif
   sele rs3out
   if netseek('t1','ttnr')
      do while ttn=ttnr
         netdel()
         skip
      endd
   endif
   sele rs1in
   sklinr=skl
   skloutr=sklinr
   przinr=prz
   dopinr=dop
   arec:={}
   getrec()
   sele rs2in
   if netseek('t1','ttnr')
      do while ttn=ttnr
         ktlr=ktl
         mntovr=mntov
         kvpr=kvp
         arec:={}
         getrec()
         sele rs2out
         netadd()
         putrec()
         if przinr=1
            sele tovout
            if netseek('t1','skloutr,ktlr')
               netrepl('osv,osf,osfo','osv-kvpr,osf-kvpr,osfo-kvpr')
            endif
            sele tovmout
            if netseek('t1','skloutr,mntovr')
               netrepl('osv,osf,osfo','osv-kvpr,osf-kvpr,osfo-kvpr')
            endif
         else
            if empty(dopinr)
               sele tovout
               if netseek('t1','skloutr,ktlr')
                  netrepl('osv','osv-kvpr')
               endif
               sele tovmout
               if netseek('t1','skloutr,mntovr')
                  netrepl('osv','osv-kvpr')
               endif
            else
               sele tovout
               if netseek('t1','skloutr,ktlr')
                  netrepl('osv,osfo','osv-kvpr,osfo-kvpr')
               endif
               sele tovmout
               if netseek('t1','skloutr,mntovr')
                  netrepl('osv,osfo','osv-kvpr,osfo-kvpr')
               endif
            endif
         endif
         sele rs2in
         skip
      endd
   endif
   sele rs3in
   if netseek('t1','ttnr')
      do while ttn=ttnr
         arec:={}
         getrec()
         sele rs3out
         netadd()
         putrec()
         sele rs3in
         skip
      endd
   endif
   sele rs1in
   arec:={}
   getrec()
   sele rs1out
   netadd()
   putrec()
   kinsr=kinsr+1
   @ 2,15 say str(kinsr,4)
   sele rs1in
   skip
endd
nuse('rs1in')
nuse('rs2in')
nuse('rs3in')
nuse('pr1in')
nuse('pr2in')
nuse('pr3in')
nuse('tovin')
nuse('tovmin')
nuse('rs1out')
nuse('rs2out')
nuse('rs3out')
nuse('pr1out')
nuse('pr2out')
nuse('pr3out')
nuse('tovout')
nuse('tovmout')
nuse('ctov')
retu .t.


func updtbankn()

store 0 to kinsr,kupdtr,kdelr,rccr,rcnr
@ 2,15 say str(kinsr,4)
@ 3,15 say str(kupdtr,4)
@ 4,15 say str(kdelr,4)
@ 1,30 say space(49)

pathr=pathinr
if !netfile('dokk',1)
   retu .t.
endif
netuse('dokk','dokkin',,1)
set orde to
netuse('doks','doksin',,1)
netuse('dokz','dokzin',,1)

pathr=pathoutr
if !netfile('dokk',1)
   nuse('dokkin')
   nuse('doksin')
   nuse('dokzin')
   retu .t.
endif
netuse('dokk','dokkout',,1)
netuse('doks','doksout',,1)
netuse('dokz','dokzout',,1)

sele dokkin
rccr=recc()
@ 1,30 say 'Банк  '
@ 1,40 say str(rccr,10)
go top
do while !eof()
   rcnr=recn()
   @ 1,50 say str(rcnr,10)
   mnr=mn
   rndr=rnd
   kklr=kkl
   rnr=rn
   mnpr=mnp
   skr=sk
   arec:={}
   getrec()
   sele dokkout
   prinsr=1
   if netseek('t1','mnr,rndr,kklr,rnr,mnpr,skr')
      do while mn=mnr.and.rnd=rndr.and.kkl=kklr.and.rn=rnr.and.mnp=mnpr.and.sk=skr
         netdel()
         skip
      endd
      prinsr=0
   endif
   netadd()
   putrec()
   netunlock()
   if prinsr=1
      kinsr=kinsr+1
      @ 2,15 say str(kinsr,4)
   else
      kupdtr=kupdtr+1
      @ 3,15 say str(kupdtr,4)
   endif
   sele doksout
   if !netseek('t1','mnr,rndr,kklr')
      sele doksin
      if netseek('t1','mnr,rndr,kklr')
         arec:={}
         getrec()
         sele doksout
         netadd()
         putrec()
         netunlock()
      endif
   endif
   sele dokzout
   if !netseek('t2','mnr')
      sele dokzin
      if netseek('t2','mnr')
         arec:={}
         getrec()
         sele dokzout
         netadd()
         putrec()
         netunlock()
      endif
   endif
   sele dokkin
   skip
endd

nuse('dokkin')
nuse('doksin')
nuse('dokzin')
nuse('dokkout')
nuse('doksout')
nuse('dokzout')
retu .t.

func copcomm()
if gnEntrm=0
   pathr=pathoutr
   netuse('ukach','ukachout','e',1)
   dele all for year(dtukach)<year(gdTd)
   pack
   use
endif
retu .t.

func updtcomm()
?'COMM'
dirinr=subs(pathinr,1,len(pathinr)-1)
if dirchange(dirinr)#0
   retu .t.
endif
diroutr=subs(pathoutr,1,len(pathoutr)-1)
if dirchange(diroutr)#0
   retu .t.
endif
?'UKACH'
pathr=pathinr
netuse('ukach','ukachin',,1)
pathr=pathoutr
netuse('ukach','ukachout',,1)
set orde to tag t2
sele ukachin
do while !eof()
   kukachr=kukach
   sele ukachout
   if !netseek('t2','kukachr')
      sele ukachin
      arec:={}
      getrec()
      sele ukachout
      netadd()
      putrec()
      netunlock()
   endif
   sele ukachin
   skip
endd
retu .t.
