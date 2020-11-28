#include "common.ch"

***********
func slto()
  ***********
  clea
  netuse('slto')
  sele slto
  go top
  rctipr=recn()
  do while .t.
     foot('','')
     sele slto
     go rctipr
     rctipr=slcf('slto',,,,,"e:idtip h:'Тип' c:n(6) e:ntip h:'Наименование' c:с(30) e:fzt h:'Ф.З.' c:n(11,4) e:pzt h:'П.З.' c:n(11,4) e:gp h:'ГП' c:n(4,1) e:kup h:'КУп' c:n(6)",,,,,,,'Типы грузовиков')
     if lastkey()=27
        exit
     endif
     sele slto
     go rctipr
     idtipr=idtip
     ntipr=ntip
     fztr=fzt
     pztr=pzt
     gpr=gp
     kupr=kup
     do case
        case lastkey()=22 && Добавить
             sltoi()
        case lastkey()=-3 && Коррекция
             sltoi(1)
        case lastkey()= 7.and.gnAdm=1 && Удалить
             netdel()
             skip -1
             if bof()
                go top
             endif
             rctipr=recn()
     endc
  endd
  nuse()
  retu .t.
***************
func sltoi(p1)
  ***************
  if empty(p1)
     store 0 to idtipr
     store 0 to fztr,pztr,gpr,kupr
     store space(30) to ntipr
  endif
  clslto=setcolor('gr+/b,n/w')
  wslto=wopen(10,10,19,70)
  wbox(1)
  @ 0,1 say 'Тип грузовика'+' '+str(idtipr,10)
  @ 1,1 say 'Наименование ' get ntipr
  @ 2,1 say 'Фикс.затраты ' get fztr pict '999999.9999'
  @ 3,1 say 'Перем.затраты' get pztr pict '999999.9999'
  @ 4,1 say 'Грузоподъемн.' get gpr pict '99.9'
  @ 5,1 say 'К-во упаковок' get kupr pict '999999'
  read
  wclose(wslto)
  setcolor(clslto)
  if lastkey()=13
     if empty(p1)
        sele setup
        locate for ent=gnEnt
        if foun()
           if slto=0
              netrepl('slto','1')
           endif
           reclock()
           idtipr=slto
           netrepl('slto','slto+1')
           sele slto
           netadd()
           netrepl('idtip','idtipr')
           rctipr=recn()
        endif
     endif
     sele slto
     netrepl('ntip,fzt,pzt,gp,kup','ntipr,fztr,pztr,gpr,kupr')
  endif
  retu .t.

***********
func slo()
  ***********
  clea
  netuse('slo')
  netuse('kln')
  sele slo
  go top
  rcslor=recn()
  do while .t.
     sele slo
     go rcslor
     rcslor=slcf('slo',,,,,"e:ido h:'ID Груз' c:n(6) e:nido h:'Наименование' c:с(30) e:idtip h:'Тип' c:n(6) e:skod h:'КодПр' c:n(7)",,,,,,,'Грузовики')
     if lastkey()=27
        exit
     endif
     sele slo
     go rcslor
     idor=ido
     nidor=nido
     idtipr=idtip
     skodr=skod
     do case
        case lastkey()=22 && Добавить
             sloi()
        case lastkey()=-3 && Коррекция
             sloi(1)
        case lastkey()= 7.and.gnAdm=1 && Удалить
             netdel()
             skip -1
             if bof()
                go top
             endif
             rcslor=recn()
     endc
  endd
  nuse()
  retu .t.
***************
func sloi(p1)
  ***************
  if empty(p1)
     store 0 to idor,idtipr
     store space(30) to nidor
     skodr=0
  endif
  clslto=setcolor('gr+/b,n/w')
  wslto=wopen(10,10,16,70)
  wbox(1)
  @ 0,1 say 'ID Грузовика'+' '+str(idor,10)
  @ 1,1 say 'Описание    ' get nidor
  @ 2,1 say 'Тип         ' get idtipr pict '9999999999'
  @ 3,1 say 'Код предприят' get skodr pict '9999999'
  @ 4,1 say getfield('t1','skodr','kln','nkl')
  read
  wclose(wslto)
  setcolor(clslto)
  if lastkey()=13
     if empty(p1)
        sele setup
        locate for ent=gnEnt
        if foun()
           if slo=0
              netrepl('slo','1')
           endif
           reclock()
           idor=slo
           netrepl('slo','slo+1')
           sele slo
           netadd()
           netrepl('ido','idor')
           rcslor=recn()
        endif
     endif
     sele slo
     netrepl('nido,idtip,skod','nidor,idtipr,skodr')
  endif
  retu .t.

***********
func slp()
  ***********
  clea
  netuse('slp')
  netuse('s_tag')
  sele slp
  go top
  rcslpr=recn()
  do while .t.
     sele slp
     go rcslpr
     rcslpr=slcf('slp',,,,,"e:idp h:'ID Сотруд' c:n(6) e:nidp h:'ФИО' c:с(30) e:iif(tidp=1,'экспедитор','водитель') h:'Тип' c:c(10) e:skod h:'КодПр' c:n(7)",,,,,,,'Водители,Экспедиторы')
     if lastkey()=27
        exit
     endif
     sele slp
     go rcslpr
     idpr=idp
     nidpr=nidp
     tidpr=tidp
     skodr=skod
     do case
        case lastkey()=22 && Добавить
             slpi()
        case lastkey()=-3 && Коррекция
             slpi(1)
        case lastkey()= 7.and.gnAdm=1 && Удалить
             netdel()
             skip -1
             if bof()
                go top
             endif
             rcslpr=recn()
     endc
  endd
  nuse()
  retu .t.
***************
func slpi(p1)
  ***************
  if empty(p1)
     store 0 to idpr
     tidpr=0
     skodr=0
     store space(30) to nidpr
  endif
  clslto=setcolor('gr+/b,n/w')
  wslto=wopen(10,10,16,70)
  wbox(1)
  @ 0,1 say 'ID сотрудника'+' '+str(idpr,10)
  @ 1,1 say 'ФИО          ' get nidpr
  @ 2,1 say '0-Вод;1-Эксп ' get tidpr pict '9'
  @ 3,1 say 'Код предприят' get skodr pict '9999999'
  @ 3,col()+1 say getfield('t1','skodr','s_tag','fio')
  read
  wclose(wslto)
  setcolor(clslto)
  if lastkey()=13
     if empty(p1)
        sele setup
        locate for ent=gnEnt
        if foun()
           if slp=0
              netrepl('slp','1')
           endif
           reclock()
           idpr=slp
           netrepl('slp','slp+1')
           sele slp
           netadd()
           netrepl('idp','idpr')
           rcslpr=recn()
        endif
     endif
     sele slp
     netrepl('nidp,tidp,skod','nidpr,tidpr,skodr')
  endif
  retu .t.
*************
func sltxt()
  *************
  local ii, i
  IF !(UPPER("/nomake") $ UPPER(DosParam()))
    clea
    set cons off
    #ifdef __CLIP__
       cpr=set("PRINTER_CHARSET","cp1251")
    #endif
    *
    cDelim=CHR(13) + CHR(10)
    set prin to vtype.txt
    set prin on
    netuse('slto')
    nn_r=1
    go top
    do while !eof()
       cidtipr=alltrim(str(idtip,10))
       ntipr=ntip
       cfztr=alltrim(str(fzt,11,4))
       cpztr=alltrim(str(pzt,11,4))
       cgpr=alltrim(str(gp*1000))
       ckupr=alltrim(str(kup,6))
       aaa=padr(cidtipr,15)+ntipr+padr(cfztr,11)+padr(cpztr,11)+padr(cgpr,11)+padr(ckupr,11)
       if nn_r=1
          ??aaa
          nn_r=0
       else
          ?aaa
       endif
       sele slto
       skip
    endd
    ??cDelim
    nuse('slto')
    set prin off
    set prin to

    set prin to vehicles.txt
    set prin on
    netuse('slo')
    go top
    nn_r=1
    do while !eof()
       cidor=alltrim(str(ido,10))
       cidtipr=alltrim(str(idtip,10))
       nidor=nido
       aaa=padr(cidor,15)+padr(cidtipr,15)+padr(nidor,50)
       if nn_r=1
          ??aaa
          nn_r=0
       else
          ?aaa
       endif
       sele slo
       skip
    endd
    nuse('slo')
    set prin off
    set prin to

    set prin to drivers.txt
    set prin on
    netuse('slp')
    nn_r=1
    go top
    do while !eof()
       cidpr=alltrim(str(idp,10))
       nidpr=nidp
       if tidp=0
          ctidpr='D'
       else
          ctidpr='H'
       endif
       aaa=padr(cidpr,15)+padr(nidpr,30)+padr(ctidpr,1)
       if nn_r=1
          ??aaa
          nn_r=0
       else
          ?aaa
       endif
       sele slp
       skip
    endd

    nuse('slp')
    netuse('cskl')
    netuse('slord')
    netuse('ctov')
    netuse('mkcros')
    netuse('kln')

    skr:=chk_EntRm(gnEntRm,gnRmSk)

    sele setup
    locate for ent=gnEnt
    reclock()
    if slsnc=0
       netrepl('slsnc','1')
    endif
    sncr=slsnc
    netrepl('slsnc','slsnc+1')
    dtsncr=date()
    tmsncr=time()
    sele cskl
    locate for sk=skr
    if foun()
       sklr=skl
       pathr=gcPath_d+alltrim(path)
       if netfile('rs1',1)
          netuse('rs1',,,1)
          netuse('rs2',,,1)
          netuse('pr1',,,1)
          netuse('pr2',,,1)
          netuse('tov',,,1)
          d0k1r=0
          sele rs1
          go top
          do while !eof()
             rcrs1_r=recn()
             ttnpr=ttnp
             docidr=docid
             kopr=kop
             docguidr=docguid
*if ttn=544309
*wait
*endif
             if subs(docguidr,1,2)#'SV'
                if kopr=170
                   sele rs1
                   skip
                   loop
*                   if ttnpr#0
*                      docguid_r=getfield('t1','ttnpr','rs1','docguid')
*                      sele rs1
*                      go rcrs1_r
*                      if subs(docguid_r,1,2)#'SV'
*                         sele rs1
*                         skip
*                         loop
*                      else
*                         docguidr=docguid_r
*                      endif
*                   else
*                      sele rs1
*                      skip
*                      loop
*                   endif
                else
                   if kopr=177.or.kopr=168
                      if docidr#0
                         docguid_r=getfield('t1','docidr','rs1','docguid')
                         sele rs1
                         go rcrs1_r
                         if subs(docguid_r,1,2)#'SV'
                            sele rs1
                            skip
                            loop
                         else
                            docguidr=docguid_r
                         endif
                      else
                         sele rs1
                         skip
                         loop
                      endif
                   else
                      sele rs1
                      skip
                      loop
                   endif
                endif
             endif
             if prz=1
                sele rs1
                skip
                loop
             endif
             if empty(dfp)
                sele rs1
                skip
                loop
             endif
             if !empty(dop)
                sele rs1
                skip
                loop
             endif
             if mrsh#0
                sele rs1
                skip
                loop
             endif
             kplr=nkkl
             kgpr=kpv
             docr=ttn
             vesr=vsvb
             dtror=dtro
*             docguidr=docguid
             kolr=0
             kupr=0
             sele rs2
             if netseek('t1','docr')
                do while ttn=docr
                   mntovr=mntov
                   mntovtr=getfield('t1','mntovr','ctov','mntovt')
                   if mntovtr#0
                      mntovr=mntovtr
                   endif
                   mkcrosr=getfield('t1','mntovr','ctov','mkcros')
                   if mkcrosr#0
                      skur=getfield('t1','mkcrosr','mkcros','mkid')
                   else
                      skur=''
                   endif
                   ktlr=ktl
                   kvpr=kvp
*                   if int(mntov/10000)>1
                      kolr=kvpr
                      upakr=getfield('t1','sklr,ktlr','tov','upak')
                      k1tr=getfield('t1','sklr,ktlr','tov','k1t')
                      if upakr#0
                         kupr=kvpr/upakr
                      else
                         kupr=0
                      endif
                      ves_r=getfield('t1','sklr,ktlr','tov','ves')
                      vesr=roun(kvpr*ves_r,3)
                      if k1tr#0
                         vest_r=getfield('t1','sklr,k1tr','tov','ves')
                      else
                         vest_r=0
                      endif
                      if vest_r#0
*                         vestr=roun(kvpr*vest_r,3)
                         vestr=roun(kupr*vest_r,3)
                      else
                         vestr=0
                      endif
                      vesr=vesr+vestr
                      sele slord
                      netadd()
                      netrepl('snc,dtsnc,tmsnc,d0k1,sk,doc,kpl,kgp,kol,ves,dtro,kup,docguid,mntov,sku',;
                      'sncr,dtsncr,tmsncr,d0k1r,skr,docr,kplr,kgpr,kolr,vesr,dtror,kupr,docguidr,mntovr,skur')
*                   endif
                   sele rs2
                   skip
                endd
             endi
             sele rs1
             skip
          endd
          d0k1r=1
          sele pr1
          go top
          do while !eof()
             if subs(docguid,1,2)#'SV'
                sele pr1
                skip
                loop
             endif
             if prz=1
                sele pr1
                skip
                loop
             endif
             if mrsh#0
                sele pr1
                skip
                loop
             endif
             kplr=kps
             kgpr=kzg
             docr=mn
             vesr=0
             dtror=ddc+1
             docguidr=docguid
             kolr=0
             kupr=0
             sele pr2
             if netseek('t1','docr')
                do while mn=docr
                   ktlr=ktl
                   kvpr=kf
                   mntovr=mntov
                   mntovtr=getfield('t1','mntovr','ctov','mntovt')
                   if mntovtr#0
                      mntovr=mntovtr
                   endif
                   mkcrosr=getfield('t1','mntovr','ctov','mkcros')
                   if mkcrosr#0
                      skur=getfield('t1','mkcrosr','mkcros','mkid')
                   else
                      skur=''
                   endif
*                   if int(mntov/10000)>1
                      kolr=kvpr
                      upakr=getfield('t1','sklr,ktlr','tov','upak')
                      if upakr#0
                         kupr=roun(kvpr/upakr,0)
                      else
                         kupr=0
                      endif
                      ves_r=getfield('t1','sklr,ktlr','tov','ves')
                      vesr=roun(kvpr*ves_r,3)
                      k1tr=getfield('t1','sklr,ktlr','tov','k1t')
                      if k1tr#0
                         vest_r=getfield('t1','sklr,k1tr','tov','ves')
                      else
                         vest_r=0
                      endif
                      if vest_r#0
*                         vestr=roun(kvpr*vest_r,3)
                         vestr=roun(kupr*vest_r,3)
                      else
                         vestr=0
                      endif
                      vesr=vesr+vestr
                      sele slord
                      netadd()
                      netrepl('snc,dtsnc,tmsnc,d0k1,sk,doc,kpl,kgp,kol,ves,dtro,kup,docguid,mntov,sku',;
                      'sncr,dtsncr,tmsncr,d0k1r,skr,docr,kplr,kgpr,kolr,vesr,dtror,kupr,docguidr,mntovr,skur')
*                   endif
                   sele pr2
                   skip
                endd
             endi
             sele pr1
             skip
          endd
          nuse('rs1')
          nuse('rs2')
          nuse('pr1')
          nuse('pr2')
          nuse('tov')
       endif
    endif
    if select('sl')=0
       sele 0
       use _slct alias sl excl
    endif
    sele sl
    zap
*    if gnAdm=1
       crtt('tslord',"f:d0k1 c:n(1) f:doc c:n(6) f:kop c:n(3) f:dtro c:d(10) f:docguid c:c(36) f:ot c:n(1) f:kgp c:n(7)")
       sele 0
       use tslord excl
       inde on str(d0k1,1)+str(doc,6) tag t1
       inde on dtos(dtro) tag t2
       use
       sele 0
       use tslord shared
       set orde to tag t1
       sele slord
       if netseek('t1','sncr')
          do while snc=sncr
             d0k1r=d0k1
             docr=doc
             dtror=dtro
             docguidr=docguid
             kgpr=kgp
             sele tslord
             if !netseek('t1','d0k1r,docr')
                netadd()
                netrepl('d0k1,doc,dtro,docguid,kgp','d0k1r,docr,dtror,docguidr,kgpr')
             endif
             sele slord
             skip
          endd
       endif
       sele tslord
       set orde to tag t2
       go top
       rcslordr=recn()
       do while .t.
          foot('','')
          sele tslord
          go rcslordr
          rcslordr=slcf('tslord',1,0,18,,"e:d0k1 h:'V' c:n(1) e:doc h:'Докум.' c:n(6) e:dtro h:'ДатаРО' c:d(10) e:docguid h:'Док Слав' c:c(15) e:getfield('t1','tslord->kgp','kln','nkl') h:'Грузополучатель' c:c(40)",,1,,,,,'Экспорт сеанс '+alltrim(str(sncr,10))+'  skr '+str(skr,3))
          if lastkey()=27
             exit
          endif
          sele tslord
          go rcslordr
          do case
             case lastkey()=13
                  sele sl
                  go top
                  do while !eof()
                     rcdocr=val(kod)
                     sele tslord
                     go rcdocr
                     netrepl('ot','1')
                     sele sl
                     skip
                  endd
                  exit
          endc
       endd
*    endif
    clslto=setcolor('gr+/b,n/w')
    wslto=wopen(10,20,12,60)
    wbox(1)
    gdtror=date()+1
    do while .t.
       @ 0,1 say 'Дата отгрузки' get gdtror
       read
       if lastkey()=27
          wclose(wslto)
          setcolor(clslto)
          retu .t.
       endif
       if lastkey()=13
          exit
       endif
    endd
    wclose(wslto)
    setcolor(clslto)
    sele tslord
    set orde to tag t1
    set prin to orders.txt
    set prin on
    sele slord
    if netseek('t1','sncr')
       nn_r=1
       do while snc=sncr
          d0k1r=d0k1
          docr=doc
          netrepl('dtro','gdtror')
          sele tslord
          seek str(d0k1r)+str(docr,6)
          if ot=0
             sele slord
             netdel()
             skip
             loop
          endif
          sele slord
          ckplr=alltrim(str(kpl,7)) && Id места нахожд1(Код орг ТТ)
          ckgpr=alltrim(str(kgp,7)) && Id места нахожд2(Код адр ТТ)
          cdocr=alltrim(str(doc,6)) && N заказа (TTN)
          if d0k1=0 && Селектор заказа
             opr='O'
          else
             opr='P'
          endif

          cmntovr=alltrim(str(mntov,7)) && ID пункта

          ckolr=alltrim(str(kol,10)) && Итого SKU1 шт
          cvesr=alltrim(str(ves,10,3)) && Итого SKU2 кг
          ckupr=alltrim(str(kup,10)) && Итого SKU3 упак
          cuser1r='cuser1r' && Поле польз1
    *      cspir=space(255) && Спец инстр
          cspir=sku+' '+'сеанс'+' '+str(sncr,10)+' '+'дата'+' '+dtoc(dtsnc) && Спец инстр
    *      canzr=space(1) && Аннулировать заказ
          canzr='0' && Аннулировать заказ
    *      cfsrr=space(1) && Фактор срочности
          cfsrr='0' && Фактор срочности
          #ifdef __CLIP__
             cdtror=dtoc(gdtror,'dd.mm.yy') && Дата отгрузки
          #else
             cdtror=dtos(gdtror) && Дата отгрузки
          #endif
    *      cdtzr=space(15) && Дата заказа
          #ifdef __CLIP__
             cdtzr=dtoc(date(),'dd.mm.yy') && Дата заказа
          #else
             cdtzr=dtos(date()) && Дата заказа
          #endif
          cdocguidr=alltrim(docguid) && Код заказа
    *      cbutr=space(16) && К-во бут возврата
    *      ctarr=space(16) && К-во ящиков возврата
    *      ckegr=space(16) && К-во кег возврата
          cbutr='100' && К-во бут возврата
          ctarr='20' && К-во ящиков возврата
          ckegr='3' && К-во кег возврата

          aaa=padr(ckplr,15)+padr(ckgpr,15)+padr(cdocr,15)+padr(opr,1)+padr(cmntovr,10)+padr(ckolr,16)+padr(cvesr,16)+padr(ckupr,16)+padr(cuser1r,16)+padr(cspir,255)+padr(canzr,1)+padr(cfsrr,1)+padr(cdtror,15)+padr(cdtzr,15)+padr(cdocguidr,20)+padr(cbutr,16)+padr(ctarr,16)+padr(ckegr,16)
          if nn_r=1
             ??aaa
             nn_r=0
          else
             ?aaa
          endif
          sele slord
          skip
       endd
    endif
    sele tslord
    use
    set prin off
    set prin to

    #ifdef __CLIP__
       set("PRINTER_CHARSET",cpr)
    #endif
    copy file orders.txt to (gcPath_ew+'ups\orders.txt')
    copy file vtype.txt to (gcPath_ew+'ups\vtype.txt')
    copy file vehicles.txt to (gcPath_ew+'ups\vehicles.txt')
    copy file drivers.txt to (gcPath_ew+'ups\drivers.txt')
    nuse()

    set cons on
    set prin to txt.txt

  endif

  set device to print
  set print to clvrt.log
  //aFile:={"orders.txt","vtype.txt","vehicles.txt","drivers.txt"}
  aFile:={;
  {"orders.txt","Orders"},;
  {"vehicles.txt","Vehicles"},;
  {"drivers.txt","Drivers"},;
  {"vtype.txt","VehiclesType"};
  }
  //aFile:={"vehicles.zip","drivers.zip","orders.zip","vtype.zip"}


  if chk_EntRm(gnEntRm,gnRmSk)=228
    ii:=LEN(aFile)
  else
    ii:=1
  endif

  #ifdef __CLIP__
  FOR i:=1 TO ii
    SendingUps({aFile[i]}, gcPath_ew+'ups', chk_EntRm(gnEntRm,gnRmSk))
  NEXT i
  #endif

  ?

  set cons on
  set prin to txt.txt
  set device to screen

  #ifdef __CLIP__
  memoedit(memoread("clvrt.log"))
  if file(gcPath_ew+'ups'+"\"+"ups_mail.log")
    memowrit(gcPath_ew+'ups'+"\"+"ups_mail.log",;
    memoread("clvrt.log") + memoread(gcPath_ew+'ups'+"\"+"ups_mail.log"))
  else
    memowrit(gcPath_ew+'ups'+"\"+"ups_mail.log",memoread("clvrt.log"))
  endif
  //fileappend("clvrt.log",gcPath_ew+'ups'+"\"+"ups_mail.log")
  #endif

  retu .t.

**************
func slord()
**************
  clea
  netuse('slord')
  sele slord
  go top
  rcordr=recn()
  fldnomr=1
  ordfor_r='.t.'
  ordforr='.t.'
  store gdTd to dt_r
  snc_r=0
  ttn_r=0
  docguid_r=space(15)
  do while .t.
     foot('F3','Фильтр')
     sele slord
     go rcordr
     rcordr=slce('slord',1,0,18,,"e:snc h:'Сеанс' c:n(10) e:d0k1 h:'П' c:n(1) e:sk h:'Скл' c:n(3) e:doc h:'N Док ' c:n(6) e:kpl h:'Плат' c:n(7) e:kgp h:'Получ' c:n(7) e:kol h:'КолШт' c:n(10) e:ves h:'ВесБр' c:n(10,3) e:kup h:'КолУп' c:n(10) e:dtro h:'РДатаО' c:d(10) e:docguid h:'Заявка' c:c(36) e:mntov h:'MNTOV' c:n(7) e:sku h:'SKU' c:c(16) e:dtsnc h:'Дата' c:d(10) e:tmsnc h:'Время' c:c(8)",,,,,ordforr,,'Сеансы Экспорт')
     if lastkey()=27
        exit
     endif
     do case
        case lastkey()=19 && Left
             fldnomr=fldnomr-1
             if fldnomr=0
                fldnomr=1
             endif
        case lastkey()=4 && Right
             fldnomr=fldnomr+1
        case lastkey()=-2 && filt
             clslto=setcolor('gr+/b,n/w')
             wslto=wopen(10,20,16,60)
             wbox(1)
             @ 0,1 say 'Дата ' get dt_r
             @ 1,1 say 'Сеанс' get snc_r pict '9999999999'
             @ 2,1 say 'ТТН  ' get ttn_r pict '999999'
             @ 3,1 say 'SV   ' get docguid_r
             read
             if lastkey()=13
                docguid_r=upper(docguid_r)
                if ttn_r=0.and.empty(docguid_r)
                   if snc_r#0
                      ordforr=ordfor_r+'.and.snc=snc_r'
                   else
                      ordforr=ordfor_r+'.and.dtsnc=dt_r'
                   endif
                else
                   if ttn_r#0
                      ordforr=ordfor_r+'.and.doc=ttn_r'
                   else
                      ordforr=ordfor_r+'.and.docguid=docguid_r'
                   endif
                endif
             endif
             wclose(wslto)
             setcolor(clslto)
             sele slord
             go top
             rcordr=recn()
     endc
  endd
  nuse()
  retu .t.

**************
func slrout()
**************
clea
netuse('slrout')
sele slrout
go top
rcroutr=recn()
fldnomr=1
routfor_r='.t.'
routforr='.t.'
store gdTd to dt_r
snc_r=0
store space(6) to ttn_r
store space(15) to docguid_r
do while .t.
   foot('F3','Фильтр')
   sele slrout
   go rcroutr
   rcroutr=slce('slrout',1,0,18,,"e:snc h:'СеансИ' c:n(10) e:f26 h:'Дата' c:c(10) e:f18 h:'idmrsh' c:c(10) e:f2 h:'TTN' c:c(6) e:f19 h:'N Ост' c:c(5) e:dtsnc h:'ДтСнсИ' c:d(10) e:tmsnc h:'ВрСнсИ' c:c(8) e:subs(f9,28,6) h:'СеансЭ' c:c(6) e:f36 h:'Склад' c:c(15) e:f5 h:'mrsh' c:c(6) e:f6 h:'Действие' c:c(16)",,,,,routforr,,'Сеансы Импорт')
   if lastkey()=27
      exit
   endif
   do case
      case lastkey()=19 && Left
           fldnomr=fldnomr-1
           if fldnomr=0
              fldnomr=1
           endif
      case lastkey()=4 && Right
           fldnomr=fldnomr+1
      case lastkey()=-2 && filt
           clslto=setcolor('gr+/b,n/w')
           wslto=wopen(10,20,16,60)
           wbox(1)
           @ 0,1 say 'Дата ' get dt_r
           @ 1,1 say 'Сеанс' get snc_r pict '9999999999'
           @ 2,1 say 'ТТН  ' get ttn_r
           @ 3,1 say 'SV   ' get docguid_r
           read
           if lastkey()=13
              docguid_r=upper(docguid_r)
              if empty(ttn_r).and.empty(docguid_r)
                 if snc_r#0
                    routforr=routfor_r+'.and.snc=snc_r'
                 else
                    routforr=routfor_r+'.and.dtsnc=dt_r'
                 endif
              else
                 if !empty(ttn_r)
                    routforr=routfor_r+'.and.alltrim(f2)=alltrim(ttn_r)'
                 else
                    routforr=routfor_r+'.and.alltrim(f14)=alltrim(docguid_r)'
                 endif
              endif
           endif
           wclose(wslto)
           setcolor(clslto)
           sele slrout
           go top
           rcroutr=recn()
   endc
endd
nuse()
retu .t.

**************
func routes()
  **************
  netuse('slo')   && Грузовики
  netuse('slto')  && Типы грузовиков
  netuse('slp')   && Персонал
  netuse('kln')
  netuse('slrout')
  netuse('cmrsh')
  netuse('czg')
  netuse('cskl')
  netuse('atvme')
  netuse('s_tag')
  netuse('atran')
  netuse('etm')
  store '' to crm_r

*  sele dbft
*  copy stru to srout exte
*  sele 0
*  use srout excl
*  zap
*  for i=1 to 2
*      appe blank
*      repl field_name with 'f'+alltrim(str(i,2)),;
*           field_type with 'C',;
*           field_len with 15
*  next
*  appe blank
*  repl field_name with 'f'+alltrim(str(3,2)),;
*       field_type with 'C',;
*       field_len with 1
*  appe blank
*  repl field_name with 'f'+alltrim(str(4,2)),;
*       field_type with 'C',;
*       field_len with 15
*  for i=5 to 8
*      appe blank
*      repl field_name with 'f'+alltrim(str(i,2)),;
*           field_type with 'C',;
*           field_len with 16
*  next
*  appe blank
*  repl field_name with 'f'+alltrim(str(9,2)),;
*       field_type with 'C',;
*       field_len with 255
*  for i=10 to 11
*      appe blank
*      repl field_name with 'f'+alltrim(str(i,2)),;
*           field_type with 'C',;
*           field_len with 1
*  next
*  appe blank
*  repl field_name with 'f'+alltrim(str(12,2)),;
*       field_type with 'C',;
*       field_len with 15
*  appe blank
*  repl field_name with 'f'+alltrim(str(13,2)),;
*       field_type with 'C',;
*       field_len with 15
*  appe blank
*  repl field_name with 'f'+alltrim(str(14,2)),;
*       field_type with 'C',;
*       field_len with 20
*  for i=15 to 17
*      appe blank
*      repl field_name with 'f'+alltrim(str(i,2)),;
*           field_type with 'C',;
*           field_len with 16
*  next
*  appe blank
*  repl field_name with 'f'+alltrim(str(18,2)),;
*       field_type with 'C',;
*       field_len with 10
*  appe blank
*  repl field_name with 'f'+alltrim(str(19,2)),;
*       field_type with 'C',;
*       field_len with 5
*  for i=20 to 24
*      appe blank
*      repl field_name with 'f'+alltrim(str(i,2)),;
*           field_type with 'C',;
*           field_len with 10
*  next
*  appe blank
*  repl field_name with 'f'+alltrim(str(25,2)),;
*       field_type with 'C',;
*       field_len with 30
*  for i=26 to 27
*      appe blank
*      repl field_name with 'f'+alltrim(str(i,2)),;
*           field_type with 'C',;
*           field_len with 10
*  next
*  for i=28 to 37
*      appe blank
*      repl field_name with 'f'+alltrim(str(i,2)),;
*           field_type with 'C',;
*           field_len with 15
*  next
*  for i=38 to 50
*      appe blank
*      repl field_name with 'f'+alltrim(str(i,2)),;
*           field_type with 'C',;
*           field_len with 10
*  next
*  appe blank
*  repl field_name with 'f'+alltrim(str(51,2)),;
*       field_type with 'C',;
*       field_len with 1
*  appe blank
*  repl field_name with 'f'+alltrim(str(52,2)),;
*       field_type with 'C',;
*       field_len with 9
*  appe blank
*  repl field_name with 'f'+alltrim(str(53,2)),;
*       field_type with 'C',;
*       field_len with 10
*  use
*
*  crea lrout from srout
*  use
*  sele 0
*  use lrout excl
*  inde on f18+f2 tag t1

  cDelim=CHR(13) + CHR(10)
  if file(gcPath_ew+'ups\ROUTES.txt')
*#ifdef __CLIP__
*   outlog(gcPath_ew)
*#endif
     sele setup
     locate for ent=gnEnt
     reclock()
     if slrsnc=0
        netrepl('slrsnc','1')
     endif
     sncr=slrsnc
     netrepl('slrsnc','slrsnc+1')
     dtsncr=date()
     tmsncr=time()
     hzvr=fopen(gcPath_ew+'ups\ROUTES.txt')
     do while !feof(hzvr)
        aaa=FReadLn(hzvr, 1, 900, cDelim)
        #ifdef __CLIP__
           aaa := translate_charset("cp866",host_charset(),aaa)
        #else
           aaa=win_to_dos(aaa)
        #endif
        sele slrout
        netadd()
        netrepl('snc,dtsnc,tmsnc','sncr,dtsncr,tmsncr',1)
        n=1
        for i=4 to fcount()
            cfldr='f'+alltrim(str(i-3,2))
            lnr=fieldsize(i)
            vfldr=subs(aaa,n,lnr)
            n=n+lnr
            repl &cfldr with vfldr
        next
        dbcommit()
        dbunlock()
     endd
     fclose(hzvr)
*     copy file (gcPath_a+'cmrsh.dbf') to lcmrsh.dbf
*     sele 0
*     use lcmrsh excl
*     zap
*     inde on idmrsh tag t1
*     copy file (gcPath_a+'czg.dbf') to lczg.dbf
*     sele 0
*     use lczg excl
*     zap
*     inde on idmrsh+str(sk,3)+str(d0k1,1)+str(ttn,6) tag t1
     sele slrout
     sk_rr=0
     if netseek('t1','sncr')
        do while snc=sncr
           ttnr=val(alltrim(f2))
           if f3='P'
              d0k1r=1
           else
              d0k1r=0
           endif
           crm_r=f1
           idmrshr=f18
           nmrshr=alltrim(f25)
           skr=val(subs(f36,4,3))
           dmrshr=ctod(subs(f26,9,2)+'.'+subs(f26,6,2)+'.'+subs(f26,1,4))
*           cdtpoer=dtos(dmrshr)
           iddrvr=val(alltrim(f28))
           idecsr=val(alltrim(f29))
           idobr=val(alltrim(f30))
           idtobr=val(alltrim(f31))
           nppr=val(f19)
           delttnr=val(f10)
           katranr=getfield('t1','idobr,idtobr','slo','skod')
           natranr=getfield('t1','katranr','kln','nkl')
           anomr=getfield('t1','katranr','kln','nkle')
           ogrpodr=val(getfield('t1','katranr','kln','tlf'))
           kmr=val(getfield('t1','katranr','kln','ns1'))
           dfior=getfield('t1','katranr','kln','adr')
           kecsr=getfield('t1','idecsr','slp','skod')
           if sk_rr#skr
              nuse('rs1')
              nuse('pr1')
              sele cskl
              locate for sk=skr
              pathr=gcPath_d+alltrim(path)
              netuse('rs1',,,1)
              netuse('pr1',,,1)
           endif
           sele cmrsh
           if delttnr=0
              if !netseek('t5','dmrshr,idmrshr')
                 sele setup
                 locate for ent=gnEnt
                 reclock()
                 if nmrsh=0
                    repl nmrsh with 1
                 endif
                 mrshr=nmrsh
                 do while .t.
                    sele cmrsh
                    if netseek('t2','mrshr')
                       mrshr=mrshr+1
                       loop
                    endif
                    sele setup
                    netrepl('nmrsh','mrshr+1')
                    exit
                 endd
                 sele cmrsh
                 netadd()
                 netrepl('idmrsh,dtpoe,atrc,nmrsh,mrsh,dmrsh','idmrshr,dmrshr,4,nmrshr,mrshr,date()')
              else
                 mrshr=mrsh
              endif
             netrepl('katran,anom,dfio,kecs,ogrpod','katranr,anomr,dfior,kecsr,ogrpodr')
           else
              if !netseek('t5','dmrshr,idmrshr')
                 dstvr='не найден'
                 sele slrout
                 netrepl('f6','dstvr')
                 sele slrout
                 skip
                 loop
              else
                 mrshr=mrsh
              endif
           endif
           sele czg
           if delttnr=0
              if !netseek('t6','mrshr,gnEnt,skr,d0k1r,ttnr')
                 netadd()
                 netrepl('mrsh,ent,sk,d0k1,ttn,npp,idmrsh','mrshr,gnEnt,skr,d0k1r,ttnr,nppr,idmrshr')
                 if d0k1r=0
                    sele rs1
                    if netseek('t1','ttnr')
                       sdvr=sdv
                       vsvr=vsv
                       vsvbr=vsvb
                       kklr=kpv
                       gpr=kpv
                       plr=nkkl
                       kplr=nkkl
                       kopr=kop
                       dopr=dop
                       topr=top
                       ktar=kta
                       ttnpr=ttnp
                       ttncr=ttnc
                       ztxtr=ztxt
                       tmestor=tmesto
                       vmrshr=getfield('t2','kklr','atvme','vmrsh')
                       sele czg
                       netrepl('sdv,vsv,vsvb,kkl,gp,pl,kpl,kop,dop,top,kta,ttnp,ttnc,ztxt,vmrsh',;
                       'sdvr,vsvr,vsvbr,kklr,gpr,plr,kplr,kopr,dopr,topr,ktar,ttnpr,ttncr,ztxtr,vmrshr')
                       sele rs1
                       netrepl('mrsh','mrshr')
                       if !empty(crm_r)
                          if fieldpos('tmcrm')#0
                             netrepl('tmcrm','crm_r')
                          endif
                          sele etm
                          if fieldpos('crm')#0
                             if netseek('t1','tmestor')
                                netrepl('crm','crm_r')
                             endif
                          endif
                       endif
                       if ttncr#0
                          sele rs1
                          if netseek('t1','ttncr')
                             if kop=170.and.ttnp=ttnr
                                ttnr=ttncr
                                sdvr=sdv
                                vsvr=vsv
                                vsvbr=vsvb
                                kklr=kpv
                                gpr=kpv
                                plr=nkkl
                                kplr=nkkl
                                kopr=kop
                                dopr=dop
                                topr=top
                                ktar=kta
                                ttnpr=ttnp
                                ttncr=ttnc
                                ztxtr=ztxt
                                tmestor=tmesto
                                vmrshr=getfield('t2','kklr','atvme','vmrsh')
                                sele czg
                                if !netseek('t6','mrshr,gnEnt,skr,d0k1r,ttnr')
                                   netadd()
                                   netrepl('mrsh,ent,sk,d0k1,ttn,npp,idmrsh','mrshr,gnEnt,skr,d0k1r,ttnr,nppr,idmrshr')
                                endif
                                netrepl('sdv,vsv,vsvb,kkl,gp,pl,kpl,kop,dop,top,kta,ttnp,ttnc,ztxt,vmrsh',;
                                        'sdvr,vsvr,vsvbr,kklr,gpr,plr,kplr,kopr,dopr,topr,ktar,ttnpr,ttncr,ztxtr,vmrshr')
                                sele rs1
                                netrepl('mrsh','mrshr')
                             endif
                          endif
                       endif
                    endif
                 else
                    sele pr1
                    if !netseek('t2','ttnr')
                       kklr=kzg
                       kplr=kps
                       ktar=kta
                       vmrshr=getfield('t2','kklr','atvme','vmrsh')
                       sele czg
                       netrepl('kkl,gp,pl,kpl,kop,kta,vmrsh',;
                       'kklr,kklr,kplr,kplr,108,ktar,vmrshr')
                       sele pr1
                       netrepl('mrsh','mrshr')
                    endif
                 endif
                 cmrshr=padr(alltrim(str(mrshr,6)),16)
                 dstvr='добавлен'
                 sele slrout
                 netrepl('f5,f6','cmrshr,dstvr')
              else
                 cmrshr=padr(alltrim(str(mrshr,6)),16)
                 dstvr='существует'
                 sele slrout
                 netrepl('f5,f6','cmrshr,dstvr')
              endif
           else
              if !netseek('t6','mrshr,gnEnt,skr,d0k1r,ttnr')
                 cmrshr=padr(alltrim(str(mrshr,6)),16)
                 dstvr='не найден'
                 sele slrout
                 netrepl('f5,f6','cmrshr,dstvr')
              else
                 cmrshr=padr(alltrim(str(mrshr,6)),16)
                 dstvr='удален'
                 sele slrout
                 netrepl('f5,f6','cmrshr,dstvr')
              endif
           endif
           sele slrout
           skip
        endd
        nuse('rs1')
        nuse('pr1')
     endif
  endif
  nuse()
  retu .t.

/*****************************************************************
 
 FUNCTION:
 АВТОР..ДАТА..........С. Литовка   11-18-10 * 10:25:50am
 НАЗНАЧЕНИЕ.........
 ПАРАМЕТРЫ..........
 ВОЗВР. ЗНАЧЕНИЕ....
 ПРИМЕЧАНИЯ.........
 */
FUNCTION SendingUps(aFile,cPath,l_skr)
  LOCAL cSmtpServ, cSmtpTo, cSmtpFrom
  LOCAL oSmtp
  LOCAL cFileNameArc, dDt, lError, i, cSubject

  lError:=NO

  dDt:=DATE()

  IF UPPER("/support") $ UPPER(DosParam())
    cSmtpServ:="relay.ukrpost.ua"
    cSmtpFrom:="pro@agrarnik.sumy.ua"     // for kbmxas.bbhua.com
    cSmtpTo:="lista@bk.ru"
  ELSE
    cSmtpServ:="mailx.slavutich.com"
    cSmtpFrom:="UPSExc_042@slavutich.com"     // for mailx.slavutich.com
    cSmtpTo:="Logistic.Support@slavutich.com" +;
    ;//",Natalya.Gavrilenko@slavutich.com"+;
    ;//",Yulia.Tychinskaya@slavutich.com"+;
    ",CrmExc_042@slavutich.com"
    //",lista@bk.ru,CrmExc_042@bbhua.com"
  ENDIF


  cFileNameArc:=cPath+"\"+aFile[1,1]


  set print to clvrt.log ADDI
  //set print to (aFile[1,2]+".log")
  qout(cFileNameArc,filesize(cFileNameArc),;
  cSmtpFrom, gcUname, gcNNETNAME)

  oSmtp:=smtp():new(cSmtpServ)
  oSmtp:EOL:= "&\r&\n"
  oSmtp:LF:= CHR(13)+CHR(10)
  oSmtp:timeout := 6000*10 //6000 - default
  #ifdef __CLIP__
  IF MySmtpConnect(@oSmtp) // oSmtp:connect()

    IF oSmtp:Hello(SUBSTR(cSmtpFrom,AT("@",cSmtpFrom)+1))
      cSubject:="042_"+str(l_skr,3)+" "+aFile[1,2]+" "+DTOC(dDt,"YYYYMMDD")
      IF oSmtp:addField("Subject",cSubject)
          //? oSmtp:error,"oSmtp:addField"
        lOk:=YES

          IF oSmtp:attach(cFileNameArc)
            //
          ELSE
            lOk:=NO
          ENDIF

          IF lOk //все приатачили
            //? oSmtp:error,"oSmtp:attach"
            lOk:=YES

            set print to clvrt.log ADDI
            //set print to (aFile[1,2]+".log") ADDI
            qout(DATE(),TIME())

            aSmtpTo:=split(cSmtpTo,",")

            FOR i:=1 TO LEN(aSmtpTo)

              cSmtpTo:=aSmtpTo[i]

              IF oSmtp:send(cSmtpFrom,cSmtpTo,"body of letter "+cFileNameArc)
                //
              ELSE
                lOk:=NO
              ENDIF

              IF lOk
                 //set print to (aFile[1,2]+".log") ADDI
                 set print to clvrt.log ADDI
                 qout("==oSmtp:send() OK!====",cSmtpTo)
                 //qout(cFileNameArc,"===============oSmtp:send() OK!=========",cSmtpFrom,cSmtpTo)
                 //outlog("===============oSmtp:send() OK!=========",cSmtpFrom,cSmtpTo)
                 //qout("oSmtp:send() OK!")
              ELSE
                #ifdef __CLIP__
                   outlog("Error ",cFileNameArc,"oSmtp:send()",oSmtp:error)
                   outlog("    Subject",cSubject)
                   //outlog(oSmtp)
                #endif
                lError:=TRUE
              ENDIF

            NEXT i
            oSmtp:close()

          ELSE
             #ifdef __CLIP__
                outlog("Error ","oSmtp:attach()",oSmtp:error)
             #endif
              lError:=TRUE
          ENDIF
        ELSE
        #ifdef __CLIP__
           outlog("Error ","oSmtp:addField()",oSmtp:error)
        #endif
            lError:=TRUE
      ENDIF
    ELSE
      #ifdef __CLIP__
         outlog("Error ","oSmtp:Hello()",oSmtp:error)
      #endif
            lError:=TRUE
    ENDIF
  ELSE
    #ifdef __CLIP__
       outlog("Error ","oSmtp:connect()",cSmtpServ,oSmtp:port,oSmtp:error)
    #endif
          lError:=TRUE
  ENDIF
  #endif
  IF !EMPTY(lError)
    //oSmtp:reset()
    oSmtp:close()
  ENDIF



  RETURN (NIL)

/*****************************************************************
 
 FUNCTION:
 АВТОР..ДАТА..........  12-09-10 * 02:16:41pm
 НАЗНАЧЕНИЕ.........  kakoj sklad
 ПАРАМЕТРЫ..........
 ВОЗВР. ЗНАЧЕНИЕ....
 ПРИМЕЧАНИЯ.........
 */
FUNCTION chk_EntRm(l_gnEntRm,l_gnRmSk)
    local l_skr
    if l_gnEntRm=0
       l_skr:=228
    else
       do case
          case l_gnRmSk=3
               l_skr:=300
          case l_gnRmSk=4
               l_skr:=400
          case l_gnRmSk=5
               l_skr:=500
          case l_gnRmSk=6
               l_skr:=600
       ends
    endif
  RETURN (l_skr)
