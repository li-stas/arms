/* Коррекция NDS */
return (.t.)
clea
/*sele setup
 *locate for ent=gnEnt
 *if gnEntrm=1
 *   if subs(str(nnds,10),1,3)#str(gnRmsk,1)+str(gnEnt,2)
 *      nndsr=(gnRmsk*100+gnEnt)*10000000+mod(nnds,10000000)
 *      netrepl('nnds','nndsr')
 *   endif
 *endif
 */
netuse('nds')
set orde to tag t3          // sk,ttn,d0k1
netuse('cskl')
while (!eof())
  if (ent#gnEnt)
    skip
    loop
  endif

  if (gnEntrm=0)
    if (rm#0)
      skip
      loop
    endif

  else
    if (rm=0)
      skip
      loop
    endif

  endif

  pathr=gcPath_d+alltrim(path)
  if (!netfile('tov', 1))
    sele cskl
    skip
    loop
  endif

  ?pathr
  skr=sk
  netuse('rs1',,, 1)
  sele rs1
  while (!eof())
    if (nnds=0)
      skip
      loop
    endif

    nndsr=nnds
    /*      if nndsr=157.or.nndsr=158.or.nndsr=159.or.nndsr=160
     *         wait
     *      endif
     */
    ttnr=ttn
    sele nds
    set orde to tag t1
    if (netseek('t1', 'nndsr',,, 1))
      if (d0k1=0.and.ttn=ttnr.and.sk=skr)
        sele rs1
        skip
        loop
      else
        sele nds
        set orde to tag t3
        if (netseek('t3', 'skr,ttnr,0',,, 1))
          nndsr=nomnds
          sele rs1
          netrepl('nnds', 'nndsr')
        else
          sele rs1
          netrepl('nnds', '0')
        endif

      endif

    else
      sele rs1
      netrepl('nnds', '0')
    endif

    sele rs1
    skip
  enddo

  nuse('rs1')
  sele cskl
  skip
enddo

nuse()
wmess('Проверка закончена', 0)

/****************** */
function crrs1kpk()
  /****************** */

  if (bom(gdTd)<ctod('01.07.2007'))
    wmess('Нет данных', 2)
    return (.t.)
  endif

  clea
  set prin to crrs1kpk.txt
  set prin on

  netuse('cskl')
  go top
  while (!eof())
    if (ent#gnEnt)
      skip
      loop
    endif

    /*   if merch=1
     *      skip
     *      loop
     *   endif
     */
    if (arnd#0)
      skip
      loop
    endif

    pathr=gcPath_d+alltrim(path)
    skr=sk
    dir_r=subs(pathr, 1, len(pathr)-1)
    if (dirchange(dir_r)#0)
      sele cskl
      skip
      loop
    endif

    dirchange(gcPath_l)
    netuse('rs1kpk',,, 1)
    netuse('rs2kpk',,, 1)
    netuse('rs1',,, 1)
    netuse('pr1kpk',,, 1)
    netuse('pr2kpk',,, 1)
    netuse('pr1',,, 1)
    sele rs1kpk
    go top
    while (!eof())
      ttnr=ttn
      ddcr=ddc
      sele rs1
      if (!netseek('t1', 'ttnr'))
        sele rs2kpk
        if (netseek('t1', 'ttnr'))
          while (ttn=ttnr)
            netdel()
            sele rs2kpk
            skip
          enddo

        endif

        sele rs1kpk
        netdel()
        ?str(skr, 3)+' '+str(ttnr, 6)+' '+dtoc(ddcr)+' '+'Уд'
      endif

      sele rs1kpk
      skip
    enddo

    sele pr1kpk
    go top
    while (!eof())
      mnr=mn
      ddcr=ddc
      sele pr1
      if (!netseek('t2', 'mnr'))
        sele pr2kpk
        if (netseek('t1', 'mnr'))
          while (mn=mnr)
            netdel()
            sele pr2kpk
            skip
          enddo

        endif

        sele pr1kpk
        netdel()
        ?str(skr, 3)+' '+str(mnr, 6)+' '+dtoc(ddcr)+' '+'Уд'
      endif

      sele pr1kpk
      skip
    enddo

    nuse('rs1')
    nuse('rs1kpk')
    nuse('rs2kpk')
    nuse('pr1')
    nuse('pr1kpk')
    nuse('pr2kpk')
    sele cskl
    skip
  enddo

  set prin off
  set prin to txt.txt
  return (.t.)

/*************** */
function crmerch()
  /*************** */
  clea
  if (bom(gdTd)<ctod('01.12.2006'))
    wmess('Нет данных', 2)
    return (.t.)
  endif

  set prin to crmerch.txt
  set prin on
  netuse('cskl')
  locate for ent=gnEnt.and.merch=1
  if (foun())
    pathtr=gcPath_e+gcDir_g+gcDir_d+alltrim(path)
    dtpr=bom(addmonth(gdTd, -1))
    ypr=year(dtpr)
    mpr=month(dtpr)
    pathpr=gcPath_e+'g'+str(ypr, 4)+'\m'+iif(mpr<10, '0'+str(mpr, 1), str(mpr, 2))+'\'+alltrim(path)
    pathr=pathtr
    if (netfile('rs1', 1))
      netuse('rs1',,, 1)
      netuse('rs2',,, 1)
      netuse('rs3',,, 1)
      netuse('rs2m',,, 1)
      netuse('tov',,, 1)
      netuse('tovm',,, 1)
      pathr=pathpr
      if (netfile('rs1', 1))
        netuse('rs1', 'rs1p',, 1)
        sele rs1
        go top
        while (!eof())
          sklr=skl
          ttnr=ttn
          ddcr=ddc
          if (netseek('t1', 'ttnr', 'rs1p'))
            sele rs2
            if (netseek('t1', 'ttnr'))
              while (ttn=ttnr)
                netdel()
                skip
                loop
              enddo

            endif

            sele rs2m
            if (netseek('t1', 'ttnr'))
              while (ttn=ttnr)
                netdel()
                skip
                loop
              enddo

            endif

            sele rs3
            if (netseek('t1', 'ttnr'))
              while (ttn=ttnr)
                netdel()
                skip
                loop
              enddo

            endif

            sele rs1
            netdel()
            ?str(ttnr, 6)+' '+dtoc(ddcr)+' '+'удалена есть в прошлом'
          endif

          sele rs1
          skip
        enddo

        nuse('rs1p')
      endif

      sele rs1
      go top
      while (!eof())
        ttnr=ttn
        ddcr=ddc
        if (ddcr<dtpr)
          sele rs2
          if (netseek('t1', 'ttnr'))
            while (ttn=ttnr)
              netdel()
              skip
              loop
            enddo

          endif

          sele rs2m
          if (netseek('t1', 'ttnr'))
            while (ttn=ttnr)
              netdel()
              skip
              loop
            enddo

          endif

          sele rs3
          if (netseek('t1', 'ttnr'))
            while (ttn=ttnr)
              netdel()
              skip
              loop
            enddo

          endif

          sele rs1
          netdel()
          ?str(ttnr, 6)+' '+dtoc(ddcr)+' '+'удалена не этого периода'
        endif

        sele rs1
        skip
      enddo

      ?'RS2'
      sele rs2
      go top
      while (!eof())
        ttnr=ttn
        if (!netseek('t1', 'ttnr', 'rs1'))
          sele rs2
          netdel()
          ?'RS2 '+str(ttnr, 6)+' '+'удалена нет в RS1'
        endif

        sele rs2
        skip
      enddo

      ?'RS2M'
      sele rs2m
      go top
      while (!eof())
        ttnr=ttn
        if (!netseek('t1', 'ttnr', 'rs1'))
          sele rs2m
          netdel()
          ?'RS2M '+str(ttnr, 6)+' '+'удалена нет в RS1'
        endif

        sele rs2m
        skip
      enddo

      sele tov
      ?'TOV'
      go top
      while (!eof())
        sklr=skl
        ktlr=ktl
        prdelr=1
        sele rs2
        set orde to tag t6
        if (netseek('t6', 'ktlr'))
          while (ktl=ktlr)
            ttnr=ttn
            skl_r=getfield('t1', 'ttnr', 'rs1', 'skl')
            if (sklr=skl_r)
              prdelr=0
              exit
            endif

            sele rs2
            skip
          enddo

        endif

        if (prdelr=1)
          sele tov
          netdel()
          ?str(sklr, 7)+' '+str(ktlr, 9)+' '+'удалена'
        endif

        sele tov
        skip
      enddo

      sele tovm
      go top
      ?'TOVM'
      while (!eof())
        sklr=skl
        mntovr=mntov
        if (!netseek('t5', 'sklr,mntovr', 'tov'))
          sele tovm
          netdel()
          ?str(sklr, 7)+' '+str(mntovr, 7)+' '+'удалена'
        endif

        sele tovm
        skip
      enddo

      nuse()
    endif

  endif

  set prin off
  set prin to txt.txt
  return (.t.)

/****************** */
function crprot()
  /****************** */

  if (bom(gdTd)<ctod('01.07.2007'))
    wmess('Нет данных', 2)
    return (.t.)
  endif

  clea
  set prin to crprot.txt
  set prin on


  nMax:=10
  IIF(gnScOut = 0, Termo((nCurent:=0),nMax,MaxRow(),4),)
  nMax:=0

  netuse('cskl')
  go top
  while (!eof())
    if (ent#gnEnt)
      skip
      loop
    endif

    if (merch=1)
      skip
      loop
    endif

    pathr=gcPath_d+alltrim(path)
    skr=sk
    dir_r=subs(pathr, 1, len(pathr)-1)
    if (dirchange(dir_r)#0)
      sele cskl
      skip
      loop
    endif

    dirchange(gcPath_l)
    netuse('rso1',,, 1); nMax+=LASTREC()
    netuse('rso2',,, 1); nMax+=LASTREC()
    netuse('pro1',,, 1); nMax+=LASTREC()
    netuse('pro2',,, 1); nMax+=LASTREC()
    netuse('pr1',,, 1)
    netuse('rs1',,, 1)
    ?__FILE__, __LINE__, 'Протокол расхода rso1',pathr

    sele rso1
    go top
    while (!eof())
      IIF(gnScOut = 0, Termo(nCurent++,nMax,MaxRow(),4),)
      ttnr=ttn
      sele rs1
      if (!netseek('t1', 'ttnr'))
        sele rso2
        set orde to tag t2
        if (netseek('t2', 'ttnr'))
          while (ttn=ttnr)
            netdel()
            sele rso2
            skip
          enddo

        endif

        sele rso1
        netdel()
        ?str(skr, 3)+' '+str(ttnr, 6)+' '+'Уд'
      endif

      sele rso1
      skip
    enddo

    ?"  ",__FILE__, __LINE__, 'Протокол расхода rso2'
    sele rso2
    set orde to tag t2
    go top
    while (!eof())
      IIF(gnScOut = 0, Termo(nCurent++,nMax,MaxRow(),4),)
      If deleted() .or. ttn = 0
          netdel()
      Else
        ttnr=ttn
        rcrso2r=recn()
        if (!netseek('t2', 'ttnr', 'rso1'))
          sele rso2
          while (ttn=ttnr)
            skip
          enddo
          rcrso2r=recn()

          ?str(skr, 3)+' '+str(ttnr, 6)+' '+'Уд в RSO2'
        endif

        sele rso2
        go rcrso2r
      EndIf
      skip
    enddo

    ?"  ",__FILE__, __LINE__, 'Протокол прихода pro1'
    sele pro1
    go top
    while (!eof())
      IIF(gnScOut = 0, Termo(nCurent++,nMax,MaxRow(),4),)
      mnr=mn
      sele pr1
      if (!netseek('t2', 'mnr'))
        sele pro2
        set orde to tag t2
        if (netseek('t2', 'mnr'))
          while (mn=mnr)
            netdel()
            sele pro2
            skip
          enddo

        endif

        sele pro1
        netdel()
        ?str(skr, 3)+' '+str(mnr, 6)+' '+'Уд'
      endif

      sele pro1
      skip
    enddo

    ?"  ",__FILE__, __LINE__, 'Протокол прихода pro2'
    sele pro2
    set orde to tag t2
    go top
    while (!eof())
      IIF(gnScOut = 0, Termo(nCurent++,nMax,MaxRow(),4),)

      If deleted() .or. mn = 0
          netdel()
      Else
        mnr=mn
        rcpro2r=recn()
        if (!netseek('t2', 'mnr', 'pro1'))
          sele pro2
          while (mn=mnr)
            netdel()
            skip
          enddo
          rcpro2r=recn()

          ?str(skr, 3)+' '+str(mnr, 6)+' '+'Уд в PRO2'
        endif

        sele pro2
        go rcpro2r
      EndIf
      skip
    enddo

    nuse('pr1')
    nuse('rs1')
    nuse('rso1')
    nuse('rso2')
    nuse('pro1')
    nuse('pro2')
    sele cskl
    skip
  enddo
  IIF(gnScOut = 0, Termo(nMax,nMax,MaxRow(),4),)

  set prin off
  set prin to txt.txt
  return (.t.)
