#include "common.ch"
#include "inkey.ch"
* Печать сертификатов
sele 0
use shrift
ptsertr=alltrim(shrift->shr2)
ptacdr=alltrim(shrift->shr3)
use

if empty(ptsertr)
   ptsertr=gcPath_l+'\'+'sert\'
endif

if select('lsert')#0
   sele lsert
   use
   erase lsert.dbf
endif
crtt('lsert','f:ksert c:n(6) f:kukach c:n(6) f:izg c:n(7) f:ot c:n(1)')
sele 0
use lsert excl
inde on str(ksert,6)+str(kukach,6) tag t1
sele rs2
set orde to tag t1
if netseek('t1','ttnr,ktlr')
   do while ttn=ttnr
      ktlr=ktl
      izgr=izg
      ksertr=getfield('t1','sklr,ktlr','tov','ksert')
      kukachr=getfield('t1','sklr,ktlr','tov','kukach')
      sele lsert
      if !netseek('t1','ksertr')
         netadd()
         netrepl('ksert,kukach,izg,ot','ksertr,kukachr,izgr,1')
      else
         if !netseek('t1','ksertr,kukachr')
            netadd()
            netrepl('kukach,izg,ot','kukachr,izgr,1')
         endif
      endif
      sele rs2
      skip
   endd
endif
sele lsert
if recc()#0
   prpr=0
   go top
   do while .t.
      rclsertr=slcf('lsert',,,,,"e:ksert h:'КодС' c:n(6) e:ksert h:'КодУ' c:n(6)",,1,,,,,'Сертификаты')
      go rclsertr
      do case
         case lastkey()=K_ESC
              exit
         case lastkey()=K_SPACE
              if ot=0
                 netrepl('ot','1')
              else
                 netrepl('ot','0')
              endif
         case lastkey()=K_ENTER
              prpr=1
              exit
      endc
  enddo
  if prpr=1
     sele lsert
     go top
     do while !eof()
        ksertr=ksert
        kukachr=kukach
        izgr=izg
        dpaths_r=ptsertr+alltrim(str(izgr,7))
        if ksertr#0
           for i=1 to 9
               if file(dpaths_r+'\s'+strtran(str(ksertr,6),' ','0')+str(i,1)+'.jpg')
                   erase sert2.bat
                   ffr=fcreate('sert2.bat')
                   fwrite(ffr,'@echo off '+chr(13)+chr(10))
                   fwrite(ffr,'c:'+chr(13)+chr(10))
                   fwrite(ffr,'cd '+ptacdr+' '+chr(13)+chr(10))
                   fwrite(ffr,'start /B /I /WAIT acdsee  '+dpaths_r+'\s'+strtran(str(ksertr,6),' ','0')+str(i,1)+'.jpg /p!')
                   fclose(ffr)
                   !sert1.bat
               endif
           next
           dirchange(gcPath_l)
        endif
        if kukachr#0
           for i=1 to 9
               if file(dpaths_r+'\u'+strtran(str(kukachr,6),' ','0')+str(i,1)+'.jpg')
                  erase sert2.bat
                  ffr=fcreate('sert2.bat')
                  fwrite(ffr,'@echo off '+chr(13)+chr(10))
                  fwrite(ffr,'c:'+chr(13)+chr(10))
                  fwrite(ffr,'cd '+ptacdr+' '+chr(13)+chr(10))
                  fwrite(ffr,'start /B /I /WAIT acdsee  '+dpaths_r+'\u'+strtran(str(kukachr,6),' ','0')+str(i,1)+'.jpg /p!')
                  fclose(ffr)
                  !sert1.bat
               endif
           next
           dirchange(gcPath_l)
        endif
        sele lsert
        skip
     endd
  endif
endif
save scre to scbat
rest scre from scbat
sele lsert
use
erase lsert.dbf
erase lsert.cdx
