 // Переворот месяца
set colo to g/n,n/g
CLEAR

pathr=pathtr

if !netuse ('pr1',,'e',1)
   if gnArm=1
      nuse(,'cskl')
   else
      nuse()
   endif
   return
endi

if netfile('pr1g',1)
   netuse('pr1g',,'e',1)
endif

if netfile('rs1g',1)
   netuse('rs1g',,'e',1)
endif

if !netuse('rs1',,'e',1)
   if gnArm=1
      nuse(,'cskl')
   else
      nuse()
   endif
   return
endi


if !netuse('sgrp',,'e',1)
   if gnArm=1
      nuse(,'cskl')
   else
      nuse()
   endif
   return
endi

if gnCtov=1
   if !netuse('ctov')
      if gnArm=1
         nuse(,'cskl')
      else
         nuse()
      endif
      return
   endif

   if !netuse('cgrp')
      if gnArm=1
         nuse(,'cskl')
      else
         nuse()
      endif
      return
   endif
endif

if gnCtov=3
   if !netuse('ctovk')
      if gnArm=1
         nuse(,'cskl')
      else
         nuse()
      endif
      return
   endif
   if netuse('cgrpk')
      if gnArm=1
         nuse(,'cskl')
      else
         nuse()
      endif
      return
   endif
endif


prObnvr=1 // Установка признака разрешения переворота
sele pr1
locate for prz=1.and.bom(dpr)=bom(gdTd)

if !FOUND() // Не найден подтвержденный приход в текущем месяце
   sele rs1
   locate for prz=1.and.bom(dot)=bom(gdTd)
   if !FOUND() // Не найден подтвержденный расход в текущем месяце
      sele pr1
      locate for prz=1.and.dpr<bom(gdTd)
      if !FOUND() // Не найден подтвержденный приход прошлых периодов
         sele rs1
         locate for prz=1.and.dot<bom(gdTd)
         if !FOUND() // Не найден подтвержденный расход прошлых периодов
            prObnvr=0
         endif
      endif
   else
      prObnvr=0
   endif
else
   prObnvr=0
endif

if prObnvr=0.and.gnMerch=0
   wmess('Переворот месяца уже был сделан')
   if gnArm=1
      nuse(,'cskl')
   else
      nuse()
   endif
   return
endif

pathr=pathtr

store 0 to osfr,osvr,osnr,ktlr,MNR,otv,R10
save scre to scmess
mess('Идет формирование остатков,Ждите - tov')
netUse('tov',,'e',1)
if gnMerch=0
   repl all osn with osf
else
   Delete all
 //   pack
 //   zap
endif
mess('Идет формирование остатков,Ждите - tovm')
if gnCtov=1
   netUse('tovm',,'e',1)
   if gnMerch=0
      repl all osn with osf
   else
      Delete all
 //      pack
 //      zap
   endif
endif
rest scre from scmess

save scre to scmess
mess('Идет обновление,Ждите - PrX')

netUse('pr2',,'e',1)
netUse('pr3',,'e',1)
if gnMerch=0
   sele pr1
   go top
   do while !eof()
      mnr=mn
      otvr=otv
      if prz=1
        sele pr2
        If netseek('t1','mnr')
          Delete all while mn=mnr
        EndIf
        sele pr3
        If netseek('t1','mnr')
          Delete all while mn=mnr
        EndIf
        if select('pr1g')#0
           sele pr1g
           if netseek('t1','mnr')
             Delete all while mn=mnr
           endif
        endif
        sele pr1
        Delete
        skip
      else
         sele pr2
         if !netseek('t1','mnr')
            sele pr3
            if netseek('t1','mnr')
              Delete all while mn=mnr
            endif
            sele pr1
            if otvr#2
               Delete
            endif
         else
            if otvr=1
               do while mn=mnr
                  netrepl('kfn',{kfo})
                  skip
               enddo
            endif
         endif
         sele pr1
         skip
      endif
   enddo
   sele pr1
 //   pack
   sele pr2
 //   pack
   sele pr3
 //   pack
else
   sele pr1
   Delete all
 //   pack
 //   zap
   sele pr2
   Delete all
 //   pack
 //   zap
   sele pr3
   Delete all
 //   pack
 //   zap
endif

mess('Идет обновление,Ждите - RsX')
netUse('rs2',,'e',1)
if gnCtov=1
   netUse('rs2m',,'e',1)
endif
netUse('rs3',,'e',1)
if gnMerch=0
   sele rs1
   go top
   do while !eof()
      ttnr=ttn
      if prz=1
         sele rs2
         if netseek('t1','ttnr')
           Delete All while ttn=ttnr
         endif
         if gnCtov=1
            sele rs2m
            if netseek('t1','ttnr')
              Delete All while ttn=ttnr
            endif
         endif
         sele rs3
         if netseek('t1','ttnr')
           Delete All while ttn=ttnr
         endif
         if select('rs1g')#0
            sele rs1g
            if netseek('t1','ttnr')
              Delete All while ttn=ttnr
            endif
         endif
         sele rs1
         Delete
         skip
      else
         sele rs2
         if !netseek('t1','ttnr')
            sele rs3
            if netseek('t1','ttnr')
              Delete All while ttn=ttnr
            endif
            sele rs1
            Delete
         endif
         sele rs1
         skip
      endif
   enddo
   sele rs1
 //   pack
   sele rs2
 //   pack
   if gnCtov=1
      sele rs2m
 //      pack
   endif
   sele rs3
 //   pack
else
   sele rs1
   Delete all
 //   pack
 //   zap
   sele rs2
  Delete all
 //   pack
 //   zap
   if gnCtov=1
     sele rs2m
     Delete all
 //     pack
 //     zap
   endif
   sele rs3
   Delete all
 //   pack
 //   zap
endif
rest scre from scmess

save scre to scmess
mess('Сжатие протокола расхода')
if netfile('rso1',1)
   netuse('rso1',,'e',1)
   netuse('rso2',,'e',1)
   if str(gnEnt,3) $ ' 20; 21'
      sele rso1
      go top
      do while !eof()
         ttnr=ttn
         nppr=npp
         if !netseek('t1','ttnr','rs1')
            sele rso2
            if netseek('t1','nppr,ttnr')
              Delete All while npp=nppr.and.ttn=ttnr
            endif
            sele rso1
            Delete
         endif
         sele rso1
         skip
      enddo
      sele rso2
      go top
      do while !eof()
         ttnr=ttn
         if !netseek('t1','ttnr','rs1')
            sele rso2
            Delete
         endif
         sele rso2
         skip
      enddo
   else
      sele rso1
      Delete all
      sele rso2
      Delete all
   endif
   nuse('rso1')
   nuse('rso2')
endif

mess('Сжатие протокола прихода')
if netfile('pro1',1)
   netuse('pro1',,'e',1)
   netuse('pro2',,'e',1)
   sele pro1
   go top
   do while !eof()
      mnr=mn
      nppr=npp
      if !netseek('t2','mnr','pr1')
         sele pro2
         if netseek('t1','nppr,mnr')
           Delete  while npp=nppr.and.mn=mnr
         endif
         sele pro1
         Delete
      endif
      sele pro1
      skip
   enddo
   sele pro2
   go top
   do while !eof()
      mnr=mn
      if !netseek('t2','mnr','pr1')
         sele pro2
         Delete
      endif
      sele pro2
      skip
   enddo
   nuse('pro1')
   nuse('pro2')
endif

mess('Обнуление протокола цен')
if netfile('tovo',1)
   netuse('tovo',,'e',1)
   Delete all
 //   zap
   use
endif

mess('Обнуление протокола КПК')
if netfile('rs1kpk',1)
   netuse('rs1kpk',,'e',1)
   Delete all
 //   zap
   use
endif
if netfile('rs2kpk',1)
   netuse('rs2kpk',,'e',1)
   Delete all
 //   zap
   use
endif

rest scre from scmess

clea
if gnMerch=0
   tov_d()
else
endif

if gnCtov=1.or.gnCtov=3.or.gnCtov=0
   erase (pathr+'tovd.dbf')
   erase (pathr+'tovd.cdx')
endif

if gnCtov=2
   netuse('tovd',,'e',1)
   repl all drlz with ctod('')
   nuse('tovd')
endif

if gnOst0=1.and.gnMerch=0
   save scre to scmess
   mess('Обнуление остатков')
   netuse('tov',,'e',1)
   repl all osn with 0,osv with 0,osf with 0,osfo with 0,osfm with 0,osfop with 0 //for !(kg=0 .or. kg=1)
   if gnCtov=1
      netuse('tovm',,'e',1)
      repl all osn with 0,osv with 0,osf with 0,osfo with 0,osfm with 0,osfop with 0 //for !(kg=0 .or. kg=1)
   endif
   rest scre from scmess
endif

if gnCtov=1.and.gnMerch=0
   mess('Сжатие TOVM')
   netuse('tov',,'e',1)
 //   netuse('tov',,,1)
   sele tovm
   go top
   do while !eof()
      sklr=skl
      mntovr=mntov
      sele tov
      if !netseek('t5','sklr,mntovr')
         sele tovm
         Delete
      endif
      sele tovm
      skip
   enddo
   sele tovm
 //   pack
endif

if gnArm=1
   nuse(,'cskl')
else
   nuse()
endif

clea
