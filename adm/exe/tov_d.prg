para p1
if gnCtov=0
   return
endif
// p1 - 1 - режим "Hard"
// netuse('tov',,'e',1)
save scre to scmess
// mess('Индексация tov')
// netind('tov',1)
netuse('tov',,'e',1)
rest scre from scmess
sele tov
crtovr=recc()
set orde to tag t1
go top
if gnCtov=2
   if !file(pathr+'tovd.dbf')
      sele tov
      copy stru to (pathr+'tovd')
   endif
   save scre to scmess
   mess('Индексация tovd')
   netind('tovd',1)
   netuse('tovd',,'e',1)
   rest scre from scmess
   set orde to tag t1
endif
netuse('rs1',,,1)
netuse('rs2',,,1)
// set orde to tag t2
set orde to tag t6
netuse('pr1',,,1)
netuse('pr2',,,1)
// set orde to tag t2
set orde to tag t6

@ 3,40 say 'Всего записей  '+str(crtovr,10)
@ 4,40 say 'Оставлено      '+space(10)
@ 5,40 say 'Удалено        '+space(10)
set curs off

nrc_rr=0
drcr=0
sele tov
go top
do while !eof()
   ktlr=ktl
   if otv=1
      skip
      loop
   endif
   if (abs(osn)+abs(osf)+abs(osv)+abs(osvo))#0
      skip
      nrc_rr++
      @ 4,55 say str(nrc_rr,10)+' '+str(ktlr,9)
      loop
   endif

   mntovr=mntov
   sklr=skl
   ktlr=ktl
   k1tr=k1t
   prDelr=1
   rec_tov=recno()

   // найти КТЛ в строках расхода
   sele rs2
   set orde to tag t6
   if netseek('t6','ktlr').and.ktlr#0
      @ 5,55+20 say ' SRs2+'
      do while ktl=ktlr
         ttnr=ttn
         skl_r=getfield('t1','ttnr','rs1','skl')
         if skl_r=sklr
            prDelr=0
            exit
         endif
         skip
         if ktl#ktlr.or.eof()
            exit
         endif
      enddo
      @ 5,55+20 say ' SRs2-'
   else // не найден КТЛ в строках расхода
      @ 5,55+20 say '!SRs2+'
      // если тара или ст.тара
      if (int(ktlr/1000000)=0.or.int(ktlr/1000000)=1).and.k1tr#0
         do while .t. // k1tr#0
            sele rs2
//            seek str(k1tr,9) //            dbseek(str(k1tr,9)) //           if foun() &&.and.ktlr#0
            if netseek('t6','k1tr').and.ktlr#0
               do while ktl=k1tr
                  ttnr=ttn
                  skl_r=getfield('t1','ttnr','rs1','skl')
                  if skl_r=sklr
                     prDelr=0
                     exit
                  endif
                  skip
                  if ktl#k1tr.or.eof()
                     exit
                  endif
               enddo
               exit
            else
               sele tov
               if netseek('t1','sklr,k1tr')
                  if (abs(osn)+abs(osf)+abs(osv)+abs(osvo))#0
                     prDelr=0
                     exit
                  endif
                  k1tr=k1t
                  sele rs2
                  loop
               endif
            endif
            sele tov
            go rec_tov
            exit
         enddo
      endif
      @ 5,55+20 say '!SRs2-'
   endif

   sele tov
   k1tr=k1t
   if prDelr=1
      sele pr2
      set orde to tag t6
      if netseek('t6','ktlr').and.ktlr#0
         @ 5,55+20 say ' SPr2+'
         do while ktl=ktlr
            mnr=mn
            skl_r=getfield('t2','mnr','pr1','skl')
            if skl_r=sklr
               prDelr=0
               exit
            endif
            skip
         enddo
         @ 5,55+20 say ' SPr2-'
      else
         @ 5,55+20 say '!SPr2+'
       if (int(ktlr/1000000)=0.or.int(ktlr/1000000)=1).and.k1tr#0
          do while .t.
             sele pr2
             if netseek('t6','k1tr').and.ktlr#0
                do while ktl=k1tr
                   mnr=mn
                   skl_r=getfield('t2','mnr','pr1','skl')
                   if skl_r=sklr
                      prDelr=0
                      exit
                   endif
                   skip
                enddo
                exit
            else
                sele tov
                if netseek('t1','sklr,k1tr')
                   if (abs(osn)+abs(osf)+abs(osv)+abs(osvo))#0
                      prDelr=0
                      exit
                   endif
                   k1tr=k1t
                   sele pr2
                   loop
                endif
            endif
            sele tov
            go rec_tov
            exit
            enddo
       endif
       @ 5,55+20 say '!SPr2-'
      endif
   endif

   sele tov
   k1tr=k1t
   if prDelr=1
      if ktlr#0
         arec:={}
         sele tov
         getrec()
         if gnCtov=2
            sele tovd
            if !netseek('t1','ktlr')
               sele tovd
               netadd()
               putrec()
               netrepl('skl,osn,osf,osv',{0,0,0,0})
            endif
         endif
         if gnCtov=1   // Общий
            sele ctov
            if netseek('t1','mntovr')
               if p1=nil  // Soft
//                  netrepl('cnt','cnt-1')
               endif
            endif
         endif
         if gnCtov=3   // Общий по KTL
            sele ctovk
            if netseek('t1','ktlr')
               if p1=nil  // Soft
                  netrepl('cnt',{cnt-1})
               endif
            endif
         endif
      endif
      sele tov
      netdel()
      drcr++
      @ 5,55 say str(drcr,10)+' '+str(ktlr,9)
   else
      nrc_rr++
      @ 4,55 say str(nrc_rr,10)+' '+str(ktlr,9)
   endif
   sele tov
   go rec_tov
   skip
enddo
set curs on
// pack
nuse('tov')
nuse('tovd')
nuse('rs1')
nuse('rs2')
nuse('pr1')
nuse('pr2')
retu
