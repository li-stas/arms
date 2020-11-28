* Виды продукции
clea
netuse('vid')
netuse('vide')
netuse('cgrp')
netuse('cskl')

sele vid
do while .t.
   foot('INS,DEL,F4,ENTER','Добавить,Удалить,Коррекция,Состав')
   rcvidr=slcf('vid',1,1,18,,"e:vid h:'Код' c:n(2) e:nvid h:'Наименование' c:c(20)",,,1,,,,'Виды товара')
   go rcvidr
   vidr=vid
   nvidr=nvid
   do case
      case lastkey()=27
           exit
      case lastkey()=22 // INS
           vidins(0)
      case lastkey()=7  // DEL
           sele vide
           go top
           do while !eof()
              if vid=vidr
                 netdel()
              endif
              skip
           endd
           sele vid
           netdel()
           skip -1
           if bof()
              go top
           endif
      case lastkey()=-3 // CORR
           vidins(1)
      case lastkey()=13 // Состав
           vide()
   endc
endd
nuse()

func vidins(p1)
if p1=0
   vid_r=0
   nvid_r=space(20)
else
   vid_r=vidr
   nvid_r=nvidr
endif
clvidi=setcolor('gr+/b,n/w')
wvidi=wopen(10,20,14,50)
wbox(1)
sele vid
do while .t.
   if p1=0
      @ 0,1 say 'Код         ' get vid_r pict '99'
   else
      @ 0,1 say 'Код         '+' '+str(vid_r,2)
   endif
   @ 1,1 say 'Наименование' get nvid_r
   read
   if lastkey()=27
      exit
   endif
   @ 2,1 prom 'Верно'
   @ 2,col()+1 prom 'Не Верно'
   menu to vn
   if lastkey()=27
      exit
   endif
   if vn=1
      if p1=0
         loca for vid=vid_r
         if foun()
            wmess('Такой код уже есть',1)
         else
            netadd()
            netrepl('vid,nvid','vid_r,nvid_r')
            exit
         endif
      else
         netrepl('nvid','nvid_r')
         exit
      endif
   endif
enddo
wclose(wvidi)
setcolor(clvidi)

retu .t.

func vide()
sele vide
go top
do while .t.
   foot('INS,DEL','Добавить,Удалить')
   rcvider=slcf('vide',1,29,18,,"e:sk h:'Код' c:n(3) e:getfield('t1','vide->sk','cskl','nskl') h:'Склад' c:c(20) e:grp h:'Код' c:n(3) e:getfield('t1','vide->grp','cgrp','ngr') h:'Группа' c:c(20)",,,,,'vid=vidr',,'Состав')
   go rcvider
   skr=sk
   nsklr=getfield('t1','skr','cskl','nskl')
   grpr=grp
   ngrpr=getfield('t1','grpr','cgrp','ngr')
   do case
      case lastkey()=27
           exit
      case lastkey()=22 // INS
           videins()
      case lastkey()=7  // DEL
           netdel()
           skip -1
           if vid#vidr.or.bof()
              go top
           endif
   endc
endd
retu .t.

func videins()
sk_r=0
nskl_r=space(20)
grp_r=0
ngrp_r=space(20)
clvidei=setcolor('gr+/b,n/w')
wvidei=wopen(10,20,16,50)
wbox(1)
sele vide
do while .t.
   @ 0,1 say 'Код  склада ' get sk_r pict '999'
   @ 2,1 say 'Код группы  ' get grp_r pict '999'
   read
   if lastkey()=27
      exit
   endif
   nskl_r=getfield('t1','sk_r','cskl','nskl')
   ngrp_r=getfield('t1','grp_r','cgrp','ngr')
   @ 1,1 say 'Склад   '+' '+nskl_r
   @ 3,1 say 'Группа  '+' '+ngrp_r
   @ 4,1 prom 'Верно'
   @ 4,col()+1 prom 'Не Верно'
   menu to vn
   if lastkey()=27
      exit
   endif
   if vn=1
      loca for vid=vidr.and.sk=sk_r.and.grp=grp_r
      if foun()
         wmess('Такая запись уже есть',1)
      else
         netadd()
         netrepl('vid,sk,grp','vidr,sk_r,grp_r')
         exit
      endif
   endif
enddo
wclose(wvidei)
setcolor(clvidei)
retu .t.

****************
func tpokkeg()
  *****************
  netuse('ctov')
  netuse('cskl')
  netuse('mkcros')
  netuse('kln')

  crtt('kegtov','f:mntov c:n(7) f:mntovt c:n(7) f:keg c:n(3) f:nat c:c(60) f:opt c:n(10,2)')
  sele 0
  use kegtov excl
  inde on str(mntov,7) tag t1
  *wait
  sele ctov
  set orde to tag t1
  go top
  do while int(mntov/10000)=0
     if mkeep#27
        skip
        loop
     endif
     if mkcros=0
        skip
        loop
     endif
     mntovr=mntov
     mntovtr=mntovt
     if mntovtr=0
        mntovtr=mntovr
     endif
     mkcrosr=mkcros
     natr=nat
     optr=opt
     sele mkcros
     if netseek('t1','mkcrosr')
        if keg>=30
           kegr=keg
           sele kegtov
           seek str(mntovr,7)
           if !foun()
              appe blank
              repl mntov with mntovr,;
                   mntovt with mntovtr,;
                   keg with kegr,;
                   nat with natr,;
                   opt with optr
           endif
        endif
     endif
     sele ctov
     skip
  endd

  crtt('kegkpl','f:kpl c:n(7) f:npl c:c(60) f:mntov c:n(7) f:mntovt c:n(7) f:keg c:n(3) f:nat c:c(60) f:osf c:n(12,3)')
  sele 0
  use kegkpl excl
  inde on str(kpl,7)+str(mntov,7) tag t1
  sele cskl
  locate for sk=234 // TPOK
  pathr=gcPath_d+alltrim(path)
  netuse('tov',,,1)
  go top
  do while !eof()
     if osf=0
        skip
        loop
     endif
     osfr=osf
     kplr=skl
     mntovr=mntov
     osfr=osf
     sele kegtov
     seek str(mntovr,7)
     if foun()
        mntovtr=mntovt
        natr=nat
        kegr=keg
        sele kegkpl
        seek str(kplr,7)+str(mntovr,7)
        if !foun()
           appe blank
           repl kpl with kplr,;
                mntov with mntovr,;
                mntovt with mntovtr,;
                nat with natr,;
                keg with kegr
           nplr=getfield('t1','kplr','kln','nkl')
           sele kegkpl
           repl npl with nplr
        endif
        repl osf with osf+osfr
     endif
     sele tov
     skip
  endd

  pathdebr=gcPath_ew+'deb\'
  sele kegkpl
  //copy file kegkpl.dbf to (pathdebr+'kegkpl.dbf')
  copy for osf <> 0 to (pathdebr+'kegkpl.dbf')
  IF FILE((pathdebr+'kegkpl.cdx'))
    erase (pathdebr+'kegkpl.cdx')
  ENDIF
  close
  use (pathdebr+'kegkpl.dbf') alias kegkpl NEW
  inde on str(kpl,7)+str(mntov,7) tag t1
  close
  //copy file kegkpl.cdx to (pathdebr+'kegkpl.cdx')

  nuse()
  nuse('kegtov')
  nuse('kegkpl')

  pathdebr=gcPath_ew+'deb\'
  copy file kegtov.dbf to (pathdebr+'kegtov.dbf')
  copy file kegtov.cdx to (pathdebr+'kegtov.cdx')


  retu .t.
****************
func tpokkegk()
  *****************
  netuse('ctov')
  netuse('cskl')
  netuse('mkcros')
  netuse('kln')

  crtt('kegtov','f:mntov c:n(7) f:mntovt c:n(7) f:keg c:n(3) f:nat c:c(60)')
  sele 0
  use kegtov excl
  inde on str(mntov,7) tag t1
  //wait
  sele ctov
  set orde to tag t1
  go top
  do while int(mntov/10000)=0
     if mkeep#27
        skip
        loop
     endif
     if mkcros=0
        skip
        loop
     endif
     mntovr=mntov
     mntovtr=mntovt
     if mntovtr=0
        mntovtr=mntovr
     endif
     mkcrosr=mkcros
     natr=nat
     optr=opt
     sele mkcros
     if netseek('t1','mkcrosr')
        if keg>=30
           kegr=keg
           sele kegtov
           seek str(mntovr,7)
           if !foun()
              appe blank
              repl mntov with mntovr,;
                   mntovt with mntovtr,;
                   keg with kegr,;
                   nat with natr
           endif
        endif
     endif
     sele ctov
     skip
  endd

  crtt('kegkpl','f:kpl c:n(7) f:npl c:c(60) f:mntov c:n(7) f:mntovt c:n(7) f:ktl c:n(9) f:keg c:n(3) f:nat c:c(60) f:osf c:n(12,3) f:opt c:n(10,3)')
  sele 0
  use kegkpl excl
  inde on str(kpl,7)+str(ktl,9) tag t1
  sele cskl
  locate for sk=234 // TPOK
  pathr=gcPath_d+alltrim(path)
  netuse('tov',,,1)
  go top
  do while !eof()
     if osf=0
        skip
        loop
     endif
     osfr=osf
     kplr=skl
     mntovr=mntov
     ktlr=ktl
     osfr=osf
     optr=opt
     sele kegtov
     seek str(mntovr,7)
     if foun()
        mntovtr=mntovt
        natr=nat
        kegr=keg
        sele kegkpl
        set orde to tag t1
        seek str(kplr,7)+str(ktlr,9)
        if !foun()
           appe blank
           repl kpl with kplr,;
                mntov with mntovr,;
                mntovt with mntovtr,;
                ktl with ktlr,;
                nat with natr,;
                keg with kegr,;
                opt with optr
           nplr=getfield('t1','kplr','kln','nkl')
           sele kegkpl
           repl npl with nplr
        endif
        repl osf with osf+osfr
     endif
     sele tov
     skip
  endd

  pathdebr=gcPath_ew+'deb\'
  sele kegkpl
  //copy file kegkpl.dbf to (pathdebr+'kegkpl.dbf')
  copy for osf <> 0 to (pathdebr+'kegkpl.dbf')
  IF FILE((pathdebr+'kegkpl.cdx'))
    erase (pathdebr+'kegkpl.cdx')
  ENDIF
  close
  use (pathdebr+'kegkpl.dbf') alias kegkpl NEW
  inde on str(kpl,7)+str(mntov,7) tag t1
  close
  //copy file kegkpl.cdx to (pathdebr+'kegkpl.cdx')

  nuse()
  nuse('kegtov')
  nuse('kegkpl')

  pathdebr=gcPath_ew+'deb\'
  copy file kegtov.dbf to (pathdebr+'kegtov.dbf')
  copy file kegtov.cdx to (pathdebr+'kegtov.cdx')


  retu .t.
