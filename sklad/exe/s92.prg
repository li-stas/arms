#include "common.ch"
#include "inkey.ch"
* Коррекция ksz92 в приходах,расходах
aprrsr=1
aprrs:={"Приход","Расход"}
aprrsr:=alert(" ",aprrs)
if lastkey()=K_ESC
   retu
endif
if aprrsr=1
   if !(gnRoz=1.and.gnCtov=1)
      retu
   endif
   flr='pr'
   docr='mn'
else
   flr='rs'
   docr='ttn'
endif
clea
aqstr=1
aqst:={"Просмотр","Коррекция"}
aqstr:=alert(" ",aqst)
if lastkey()=K_ESC
   retu
endif
set prin to s92.txt
set prin on
netuse(flr+'1')
netuse(flr+'2')
netuse(flr+'3')
netuse('ctov')
sele (flr+'1')
do while !eof()
   if prz=0
      skip
      loop
   endif
   sklr=skl
   if aprrsr=1
      mnr=mn
      dprr=dpr
   else
      mnr=ttn
      dprr=dot
   endif
   sele (flr+'2')
   if netseek('t1','mnr')
      s92r=0
      s92_r=0
      do while &docr=mnr
         ktlr=ktl
         mntovr=mntov
         s92_r=s92_r+seu
         sele ctov
         if netseek('t1','mntovr')
            keurr=keur
            keur1r=keur1
            keur2r=keur2
            keur3r=keur3
            keur4r=keur4
            keuhr=keuh
            do case
               case month(dprr)>2.and.month(dprr)<6
                    keu_r=keur1r
               case month(dprr)>5.and.month(dprr)<9
                    keu_r=keur2r
               case month(dprr)>8.and.month(dprr)<12
                    keu_r=keur3r
               othe
                    keu_r=keur4r
            endc
            if keu_r=0
               keu_r=keurr
            endif
            sele (flr+'2')
            if aprrsr=1
               seur=ROUND(sf*keu_r/100,2)
            else
               seur=ROUND(svp*keu_r/100,2)
            endif
            s92r=s92r+seur
            if seu#seur
               ?str(mnr,6)+' '+str(ktlr,9)+' Т '+str(seu,10,2)+' Р '+str(seur,10,2)
               if aqstr=2
                  netrepl('seu','seur')
               endif
            endif
         endif
         sele (flr+'2')
         skip
      endd
      sele (flr+'3')
      if netseek('t1','mnr,92')
         if round(ssf,2)-round(s92r,2)#0
            ?str(mnr,6)+' '+str(92,2)+' Т '+str(ssf,10,2)+' Р '+str(s92r,10,2)
            if aqstr=2
               netrepl('ssf','s92r')
            endif
         endif
      else
        if aqstr=2
            netadd()
            netrepl(docr+',ksz,ssf','mnr,92,s92r')
            ?str(mnr,6)+' '+str(92,2)+' '+str(s92r,10,2)+' Добавлено '
         endif
      endif
   endif
   sele (flr+'1')
   skip
endd
nuse()
set prin off
set prin to
wmess('Проверка закончена',0)

