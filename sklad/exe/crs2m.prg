#include "common.ch"
#include "inkey.ch"
* Коррекция RS2M
clea
aqstr=1
aqst:={"Просмотр","Корр"}
aqstr:=alert(" ",aqst)
if lastkey()=K_ESC
   retu
endif
set prin to crs2m.txt
set prin on
pathr=path_tr
netuse('rs1',,,1)
netuse('rs2',,,1)
netuse('tov',,,1)
netuse('soper',,,1)
netuse('rs2m',,,1)
set orde to tag t3
copy stru to trs2
set orde to tag t3
sele 0
use trs2 excl

?'RS2 -> RS2M'
if .t.
sele rs1
  nMax:=LASTREC();  Termo((nCurent:=0),nMax,MaxRow(),4)
do while !eof()
   if !reclock(1)
      if aqstr=2
         ?str(ttnr,6)+' Блокирован'
      endif
      sele rs1
      skip
      Termo((++nCurent),nMax,MaxRow(),4)
      loop
   endif
   rccr=space(10)
   sklr=skl
   ttnr=ttn
   if aqstr=2
      // ?str(ttnr,6)
   endif
   vor=vo
   qr=kop-100
   sele soper
   if netseek('t1','0,1,vor,qr')
      nofr=nof
      ndsr=nds
      pndsr=pnds
      xndsr=xnds
      if nofr=1
         pndsr=nds
         xndsr=nds
      else
         if pndsr=0
            pndsr=ndsr
         endif
         if xndsr=0
            xndsr=ndsr
         endif
      endif
   else
      if aqstr=2
         ?str(ttnr,6)+' Не найден soper.kop'
      endif
      sele rs1
      skip
      Termo((++nCurent),nMax,MaxRow(),4)
      loop
   endif
   sele trs2
   zap
   sele rs2
   if netseek('t1','ttnr')
      do while ttn=ttnr
         kvpr=kvp
         if kvpr=0
            sele rs2
            skip
            loop
         endif
         mntovr=mntov
         mntovpr=mntovp
         ktlr=ktl
         ktlpr=ktlp
         pptr=ppt

         zenr=zen
         prZenr=pzen
         zenpr=zenp
         prZenpr=prZenp

         MZenr=MZen

         bzenr=bzen
         prBZenr=pbzen
         bzenpr=bzenp
         prBZenpr=prBZenp

         xzenr=xzen
         prXZenr=pxzen
         xzenpr=xzenp
         prXZenpr=prXZenp

         svpr=svp
         bsvpr=bsvp
         xsvpr=xsvp
         srr=sr
         kfr=kf
         sfr=sf

         sele trs2
         locate for mntov=mntovr.and.ppt=pptr.and.mntovp=mntovpr
         if !foun()
            appe blank
            repl mntov with mntovr,;
                 ppt with pptr,;
                 mntovp with mntovpr,;
                 kvp with kvpr,;
                 zen with zenr,;
                 pzen with prZenr,;
                 zenp with zenpr,;
                 prZenp with prZenpr,;
                 bzen with bzenr,;
                 pbzen with prBZenr,;
                 bzenp with bzenpr,;
                 prBZenp with prBZenpr,;
                 xzen with xzenr,;
                 pxzen with prXZenr,;
                 xzenp with xzenpr,;
                 prXZenp with prXZenpr,;
                 svp with svpr,;
                 sr with srr,;
                 bsvp with bsvpr,;
                 xsvp with xsvpr,;
                 MZen with MZenr,;
                 otv with 1
         else
            repl kvp with kvp+kvpr,;
                 svp with svp+svpr,;
                 sr with sr+srr,;
                 bsvp with bsvp+bsvpr,;
                 xsvp with xsvp+xsvpr,;
                 otv with otv+1
         endif
         sele rs2
         skip
      enddo
      sele trs2
      rccr=str(recc(),10)
      go top
      do while !eof()
         mntovr=mntov
         pptr=ppt
         mntovpr=mntovp
         ktlr=ktl
         ktlpr=ktlp
         kvpr=kvp

         zenr=zen
         prZenr=pzen
         zenpr=zenp
         prZenpr=prZenp

         bzenr=bzen
         prBZenr=pbzen
         bzenpr=bzenp
         prBZenpr=prBZenp

         xzenr=xzen
         prXZenr=pxzen
         xzenpr=xzenp
         prXZenpr=prXZenp

         svpr=svp

         bsvpr=bsvp
         xsvpr=xsvp

         srr=sr

         MZenr=MZen

         zenmr=zenr
         prZenmr=prZenr
         bzenmr=bzenr
         prBZenmr=prBZenr
         xzenmr=xzenr
         prXZenmr=prXZenr

         otvr=otv

         if otvr>1 // Больше 1 парт позиции расчет ср значений
            if (ndsr=2.or.ndsr=3.or.ndsr=5)
               zenmr=ROUND(svpr/kvpr,3)
            else
               zenmr=ROUND(svpr/kvpr,2)
            endif
            if zenpr#0
               prZenmr=roun((zenmr/zenpr-1)*100,2)
               if abs(prZenmr)>999
                  prZenmr=0
               endif
            else
               prZenmr=0
            endif
            if (pndsr=2.or.pndsr=3.or.pndsr=5)
               bzenmr=ROUND(bsvpr/kvpr,3)
            else
               bzenmr=ROUND(bsvpr/kvpr,2)
            endif
            if (xndsr=2.or.xndsr=3.or.xndsr=5)
               xzenmr=ROUND(xsvpr/kvpr,3)
            else
               xzenmr=ROUND(xsvpr/kvpr,2)
            endif
            if bzenpr#0
               prBZenmr=roun((bzenmr/bzenpr-1)*100,2)
               if abs(prBZenmr)>999
                  prBZenmr=0
               endif
            else
               prBZenmr=0
            endif
            if xzenpr#0
               prXZenmr=roun((xzenmr/xzenpr-1)*100,2)
               if abs(prXZenmr)>999
                  prXZenmr=0
               endif
            else
               prXZenmr=0
            endif
         endif

         sele rs2m
         if netseek('t3','ttnr,mntovpr,pptr,mntovr')
            if round(kvp,3)#round(kvpr,3)
               ?str(ttnr,6)+' '+str(mntovr,7)+' KVP '+' RS2M '+str(kvp,10,3)+' RS2 '+str(kvpr,10,3)
               if aqstr=2
                  netrepl('kvp','kvpr')
               endif
            endif
            if round(zen,3)#round(zenr,3).or.round(bzen,3)#round(bzenr,3).or.round(xzen,3)#round(xzenr,3)
               ?str(ttnr,6)+' '+str(mntovr,7)+' Ц1 '+str(zen,8,3)+' '+str(zenr,8,3)+' Ц2 '+str(bzen,8,3)+' '+str(bzenr,8,3)+' Ц3 '+str(xzen,8,3)+' '+str(xzenr,8,3)
               if aqstr=2
                  netrepl('zen,bzen,xzen','zenr,bzenr,xzenr')
               endif
            endif
            if round(MZen,3)#round(MZenr,3)
               ?str(ttnr,6)+' '+str(mntovr,7)+' MZen '+str(MZen,10,3)+' '+str(MZenr,10,3)+' Мин.Цена '
               if aqstr=2
                  netrepl('MZen','MZenr')
               endif
            endif
            if round(svp,2)#round(svpr,2)
               ?str(ttnr,6)+' '+str(mntovr,7)+' SVP '+' RS2M '+str(svp,10,3)+' RS2 '+str(svpr,10,3)
               if aqstr=2
                  netrepl('svp','svpr')
               endif
            endif
            if round(sr,2)#round(srr,2)
               ?str(ttnr,6)+' '+str(mntovr,7)+' SR '+' RS2M '+str(sr,10,3)+' RS2 '+str(srr,10,3)
               if aqstr=2
                  netrepl('sr','srr')
               endif
            endif
            if round(bsvp,2)#round(bsvpr,2)
               ?str(ttnr,6)+' '+str(mntovr,7)+' BSVP '+' RS2M '+str(bsvp,10,3)+' RS2 '+str(bsvpr,10,3)
               if aqstr=2
                  netrepl('bsvp','bsvpr')
               endif
            endif
            if round(xsvp,2)#round(xsvpr,2)
               ?str(ttnr,6)+' '+str(mntovr,7)+' XSVP '+' RS2M '+str(xsvp,10,3)+' RS2 '+str(xsvpr,10,3)
               if aqstr=2
                  netrepl('xsvp','xsvpr')
               endif
            endif
            if otv#otvr
               if aqstr=2
                  netrepl('otv','otvr')
               endif
            endif
            if round(pzen,2)#round(prZenmr,2).or.round(pbzen,2)#round(prBZenmr,2).or.round(pxzen,2)#round(prXZenmr,2)
               ?str(ttnr,6)+' '+str(mntovr,7)+' C1 '+str(pzen,5,2)+' '+str(prZenmr,5,2)+' C2 '+str(pbzen,5,2)+' '+str(prBZenmr,5,2)+' C3 '+str(pxzen,5,2)+' '+str(prXZenmr,5,2)
               if aqstr=2
                  netrepl('pzen,pbzen,pxzen','prZenmr,prBZenmr,prXZenmr')
               endif
            endif
            if round(prZenp,2)#round(prZenpr,2).or.round(prBZenp,2)#round(prBZenpr,2).or.round(prXZenp,2)#round(prXZenpr,2)
               ?str(ttnr,6)+' '+str(mntovr,7)+' CП1 '+str(prZenp,5,2)+' '+str(prZenpr,5,2)+' CП2 '+str(prBZenp,5,2)+' '+str(prBZenpr,5,2)+' CП3 '+str(prXZenp,5,2)+' '+str(prXZenpr,5,2)
               if aqstr=2
                  netrepl('prZenp,prBZenp,prXZenp','prZenpr,prBZenpr,prXZenpr')
               endif
            endif
         else
            ?str(ttnr,6)+' '+str(mntovr,7)+' Нет в RS2M'
            if aqstr=2
               netadd()
               netrepl('ttn,mntov,ppt,mntovp,ktl,ktlp,kvp,svp,sr,otv','ttnr,mntovr,pptr,mntovpr,ktlr,ktlpr,kvpr,svpr,srr,otvr')
               netrepl('zen,bzen,xzen','zenr,bzenr,xzenr')
               netrepl('pzen,pbzen,pxzen,prZenp,prBZenp,prXZenp','prZenmr,prBZenmr,prXZenmr,prZenpr,prBZenpr,prXZenpr')
               netrepl('bsvp,xsvp,MZen','bsvpr,xsvpr,MZenr')
            endif
         endif
         sele trs2
         skip
      enddo
      sele rs2m
      if netseek('t3','ttnr')
         do while ttn=ttnr
            mntovr=mntov
            mntovpr=mntovp
            pptr=ppt
            sele trs2
            locate for mntov=mntovr.and.ppt=pptr.and.mntovp=mntovpr
            if !foun()
                ?str(ttnr,6)+' '+str(mntovr,7)+' Нет в TRS2'
               sele rs2m
               if aqstr=2
                  sele rs2m
                  netdel()
               endif
            endif
            sele rs2m
            skip
         enddo
      endif
   endif

   sele rs1
   skip
   Termo((++nCurent),nMax,MaxRow(),4)
enddo
sele trs2
use
erase trs2.dbf
endif


?'RS2M -> RS2'
sele rs2m
set orde to tag t3
go top
  nMax:=LASTREC();  Termo((nCurent:=0),nMax,MaxRow(),4)
do while !eof()
   ttnr=ttn
   mntovr=mntov
   if !netseek('t2','ttnr,mntovr','rs2')
      sele rs2m
      ?str(ttnr,6)+' '+str(mntovr,7)+' Нет в RS2'
      if aqstr=2
         netdel()
      endif
   endif
   sele rs2m
   skip
   Termo((++nCurent),nMax,MaxRow(),4)
enddo

nuse()
set prin off
set prin to
wmess('Проверка закончена',0)



