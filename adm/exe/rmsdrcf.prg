********************************************
func rmmainf(p1)
********************************************
* p1 1-send;2-recieve
if p1=1
   sdrcfr=1
else
   sdrcfr=2
endif
clea
set prin to rmskf.txt
set prin on

netuse('rmsk')
if netseek('t1','gnEnt')
   rmdirr=alltrim(rmdir)
   rmbsr=rmbs
   srmskr=rmsk
   rmipr=alltrim(rmip)
   if gnEntrm=0
      rcrmskr=recn()
      do while .t.
         sele rmsk
         go rcrmskr
         foot('ENTER','Передать')
         rcrmskr=slcf('rmsk',,,,,"e:ent h:'ENT' c:n(2) e:rmdir h:'Дир' c:c(10) e:rmip h:'IP' c:c(15)",,,,,'ent=gnEnt',,'Уд.склады')
         if lastkey()=27
            exit
         endif
         sele rmsk
         go rcrmskr
         rmipr=alltrim(rmip)
         if lastkey()=13
            lfile()
            if sdrcfr=1  && SEND
               rmdirr='sum'
               #ifdef __CLIP__
                  pathinr=cHomeDir+'/hd2/exe/'+gcNarm+'/'
                  pathoutr=cHomeDir+'/hd2/exe/'+gcNarm+'/'+rmdirr+'/'
               #else
                  pathinr=gcPath_l+'/'+gcNarm+'/'
                  pathoutr=gcPath_l+'/'+gcNarm+'/'+rmdirr+'/'
               #endif
               sendf()
            else
            endif
         endif
      endd
   else
      srmskr=0
      sele rmsk
      locate for ent=gnEnt
      rmdirr=rmdir
      rmipr=alltrim(rmip)
      lfile()
      if sdrcfr=1  && SEND
         #ifdef __CLIP__
            pathinr=cHomeDir+'/hd2/exe/'+gcNarm+'/'
            pathoutr=cHomeDir+'/hd2/exe/'+gcNarm+'/'+rmdirr+'/'
         #else
            pathinr=gcPath_l+'/'+gcNarm+'/'
            pathoutr=gcPath_l+'/'+gcNarm+'/'+rmdirr+'/'
         #endif
         sendf()
      else
      endif
   endif
endif
nuse()
set prin off
set prin to
retu .t.

func gogof()
#ifdef __CLIP__
   cLogSysCmd:=""
   cCmd:="rm -f /home/itk/copy_scp_host/files.txt; "+;
   "cp ./files.txt /home/itk/copy_scp_host/files.txt"
   SYSCMD(cCmd,"",@cLogSysCmd)
   IF !EMPTY(cLogSysCmd)
     OUTLOG(__FILE__,__LINE__,cLogSysCmd,cCmd)
   ENDIF

   cLogSysCmd:=""
   cCmd:="rm -f /home/itk/copy_scp_host/hosts.txt; "+;
   "cp ./hosts.txt /home/itk/copy_scp_host/hosts.txt"
   SYSCMD(cCmd,"",@cLogSysCmd)
   IF !EMPTY(cLogSysCmd)
     OUTLOG(__FILE__,__LINE__,cLogSysCmd,cCmd)
   ENDIF

   cLogSysCmd:=""
   cCmd:="rm -f /home/itk/copy_scp_host/commands.txt; "+;
   "cp ./commands.txt /home/itk/copy_scp_host/commands.txt"
   SYSCMD(cCmd,"",@cLogSysCmd)
   IF !EMPTY(cLogSysCmd)
     OUTLOG(__FILE__,__LINE__,cLogSysCmd,cCmd)
   ENDIF

   cLogSysCmd:=""
   cCmd:="super scp_host" //nohup  выполнение без ожидания
   SYSCMD(cCmd,"",@cLogSysCmd)
   IF !EMPTY(cLogSysCmd)
     OUTLOG(__FILE__,__LINE__,cLogSysCmd,cCmd)
   ENDIF
#else
#endif

retu .t.

func lfile()
if select('lfile')#0
   sele lfile
   use
endif
erase lfile.dbf
erase lfile.cdx
crtt('lfile','f:fname c:c(12) f:fext c:c(3) f:fsize c:n(10) f:fdate c:d(10) f:ftime c:c(8)')
sele 0
use lfile excl
inde on fext+fname  tag t1
dirchange(gcPath_l)
alfile=directory('*.*')
for i=1 to len(alfile)
    fnamer=lower(alltrim(alfile[i,1]))
    fextr=right(fnamer,3)
    fsizer=alfile[i,2]
    fdater=alfile[i,3]
    ftimer=alltrim(alfile[i,4])
    if !(fextr='dbf'.or.fextr='txt')
       loop
    endif
    if fnamer='_slct.dbf'.or.fnamer='menent.dbf'.or.fnamer='menskl.dbf';
              .or.fnamer='shrift.dbf'.or.fnamer='lfile.dbf'
       loop
    endif
    sele lfile
    appe blank
    repl fname with fnamer,;
         fext with fextr,;
         fsize with fsizer,;
         fdate with fdater,;
         ftime with ftimer
next
retu .t.

func sendf()
if select('lfile')#0
   if select('sl')#0
      sele sl
      use
   endif
   sele 0
   use _slct alias sl excl
   zap
   sele lfile
   go top
   rclfiler=recn()
   do while .t.
      sele lfile
      go rclfiler
      foot('Пробел,ENTER','Отбор,Выполнить')
      rclfiler=slcf('lfile',,,,,"e:fname h:'Файл' c:c(12) e:fsize h:'Размер' c:n(10) e:fdate h:'Дата' c:d(10) e:ftime h:'Время' c:c(8)",,1,,,,,pathoutr)
      if lastkey()=27
         exit
      endif
      go rclfiler
      if lastkey()=13
         sele sl
         go top
         do while !eof()
            rclfile_r=val(kod)
            sele lfile
            go rclfile_r
            fnamer=lower(alltrim(fname))
*            cmdr='export TERM=linux-stelnet'
*            cLogSysCmd:=""
*            SYSCMD(cmdr,"",@cLogSysCmd)
*            IF !EMPTY(cLogSysCmd)
*                OUTLOG(__FILE__,__LINE__,cLogSysCmd,cmdr)
*            ENDIF
            cmdr='scp -P 2222 '+pathinr+fnamer+' '+gcUname+'@'+rmipr+':'+pathoutr+fnamer
            #ifdef __CLIP__
              cLogSysCmd:=""
              SYSCMD(cmdr,"",@cLogSysCmd)
              IF !EMPTY(cLogSysCmd)
                  OUTLOG(__FILE__,__LINE__,cLogSysCmd,cmdr)
              ENDIF
            #endif
*            cmdr='export TERM=linux-dos'
*            cLogSysCmd:=""
*            SYSCMD(cmdr,"",@cLogSysCmd)
*            IF !EMPTY(cLogSysCmd)
*                OUTLOG(__FILE__,__LINE__,cLogSysCmd,cmdr)
*            ENDIF
            sele sl
            skip
         endd
         exit
      endif
   endd
   sele lfile
   use
*   erase lfile.dbf
*   erase lfile.cdx
endif
retu .t.

