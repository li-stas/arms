#include "common.ch"
#include "inkey.ch"
// XMLNDS()
LOCAL cMemReadFile
LOCAL nNomGrCorr, nKtl

if (!(gnEnt=20.or.gnEnt=21))
  return
endif

if (nnds->mn#0)           // Бух проводка
  return
endif

PERIOD_MONTHr=alltrim(str(month(nnds->dnn), 2))
PERIOD_YEARr=str(year(nnds->dnn), 4)
D_FILLr=subs(dtos(nnds->dnn), 7, 2)+subs(dtos(nnds->dnn), 5, 2)+subs(dtos(nnds->dnn), 1, 4)

sele nnds
mnr=mn
rndr=rnd
skr=sk
rnr=rn
mnpr=mnp
kklr=kkl
pr1ndsr=getfield('t1', 'kklr', 'kpl', 'pr1nds')
if (rnr#0.and.pr1ndsr=1)
  pr1ndsr=0
endif

dnnr=dnn
nndsr=nnds
nnds1r=nnds1
okpor=getfield('t1', 'gnKkl_c', 'kln', 'kkl1')
prxmlr=prxml
PathNXmlr=gcPath_mxml+'d'+iif(day(dnnr)<10, '0'+str(day(dnnr), 1), str(day(dnnr), 2))+'\'
prprnr=prprn

Crt_trs2()

if (select('tpr2')#0)
  sele tpr2
  CLOSE
endif

crtt('tpr2', 'f:Npp c:n(3) f:prich c:c(20) f:nat c:c(60) f:ukt c:c(10) f:upu c:c(20) f:kod c:n(4) f:kolc c:n(12,3) f:ozen c:n(10,2) f:izen c:n(10,2) f:kol c:n(12,3) f:sm c:n(12,2) f:zenttn c:n(10,2) f:ktl c:n(9)')
sele 0
use tpr2 excl
if (nnds->rn#0.and.nnds->mnp=0)
  //     .or.nnds->rn=0.and.nnds->mnp=0.and.nnds->nnds1=0  // ПН
  if (nnds->rn#0)         // Нормальная
    pathr=gcPath_d+alltrim(getfield('t1', 'nnds->sk', 'cskl', 'path'))
    ttnr=rnr
    netuse('rs1',,, 1)
    netuse('rs2',,, 1)
    netuse('rs3',,, 1)
  else                      // Свернутая за месяц
    /* */
    ttnr=0
    if (select('lnndoc')#0)
      sele lnndoc
      CLOSE
      erase lnndoc.dbf
    endif

    crtt('lnndoc', 'f:sk c:n(3) f:doc c:n(6) f:sm c:n(12,2)')
    sele 0
    use lnndoc
    if (select('lnnsk')#0)
      sele lnnsk
      CLOSE
      erase lnnsk.dbf
    endif

    crtt('lnnsk', 'f:sk c:n(3)')
    sele 0
    use lnnsk
    sele dokk
    set orde to tag t15
    if (netseek('t15', 'nndsr'))
      while (nnds=nndsr)
        if (mnp#0)
          skip
          loop
        endif

        skr=sk
        docr=rn
        smr=bs_s
        sele lnndoc
        appe blank
        repl sk with skr, ;
         doc with docr,   ;
         sm with smr
        sele lnnsk
        locate for sk=skr
        if (!foun())
          appe blank
          repl sk with skr
        endif

        sele dokk
        skip
      enddo

    endif

    sele lnnsk
    go top
    while (!eof())
      skr=sk
      sele cskl
      locate for sk=skr
      pathr=gcPath_d+alltrim(path)
      netuse('rs2', 'rs2'+str(skr, 3),, 1)
      netuse('rs3', 'rs3'+str(skr, 3),, 1)
      sele lnnsk
      skip
    enddo

    copy file(gcPath_a+'rs1.dbf') to lrs1.dbf
    copy file(gcPath_a+'rs2.dbf') to lrs2.dbf
    copy file(gcPath_a+'rs3.dbf') to lrs3.dbf

    sele 0
    use lrs1 alias rs1 excl
    inde on str(ttn, 6) tag t1
    set orde to tag t1
    appe blank
    repl skl with 3

    sele 0
    use lrs2 alias rs2 excl
    inde on str(ttn, 6)+str(mntov, 7)+str(zen, 15, 3) tag t1
    set orde to tag t1

    sele 0
    use lrs3 alias rs3 excl
    inde on str(ttn, 6)+str(ksz, 2) tag t1
    set orde to tag t1

    sele lnndoc
    go top
    while (!eof())
      skr=sk
      docr=doc
      smr=sm
      sele ('rs2'+str(skr, 3))
      if (netseek('t1', 'docr'))
        while (ttn=docr)
          mntovr=mntov
          kvpr=kvp
          zenr=zen
          svpr=svp
          sele rs2
          seek str(ttnr, 6)+str(mntovr, 7)+str(zenr, 15, 3)
          if (!foun())
            appe blank
            repl mntov with mntovr, ;
             zen with zenr
          endif

          repl kvp with kvp+kvpr, ;
           svp with svp+svpr
          sele ('rs2'+str(skr, 3))
          skip
        enddo

        sele ('rs3'+str(skr, 3))
        if (netseek('t1', 'docr'))
          while (ttn=docr)
            kszr=ksz
            ssfr=ssf
            sele rs3
            locate for ksz=kszr
            if (!foun())
              appe blank
              repl ksz with kszr
            endif

            repl ssf with ssf+ssfr
            sele ('rs3'+str(skr, 3))
            skip
          enddo

        endif

      endif

      sele lnndoc
      skip
    enddo

    sele lnnsk
    go top
    while (!eof())
      skr=sk
      sele cskl
      nuse('rs2'+str(skr, 3))
      nuse('rs3'+str(skr, 3))
      sele lnnsk
      skip
    enddo

  endif

  sm12r=getfield('t1', 'ttnr,12', 'rs3', 'ssf')// ндс на тару
  sm10r=getfield('t1', 'ttnr,10', 'rs3', 'ssf')// сумма товара
  sm43r=getfield('t1', 'ttnr,43', 'rs3', 'ssf')// округление

  sele rs1
  netseek('t1', 'ttnr')
  sklr=skl
  pr177r=pr177
  pr169r=pr169
  pr129r=pr129
  pr139r=pr139
  if (fieldpos('mntov177')#0)
    mntov177r=mntov177
    prc177r=prc177
  else
    mntov177r=0
    prc177r=0
  endif

  if pr169rEQ2(ttnr) //(pr177r=2.or.pr169r=2.or.pr129r=2.or.pr139r=2)
    sele nnds
    if (fieldpos('prPrn')#0)
      netrepl('prPrn', {1})
    endif

  endif

  if pr169rEQ2(ttnr) //(pr177r=2.or.pr169r=2.or.pr129r=2.or.pr139r=2)
    nRecSumMax:=1
    AddRec2Trs2(rs1->(mk169 +  mk129 + mk139)) // mk177 +
  else
    sele rs2
    if (netseek('t1', 'ttnr'))
      Nppr=1
      nSumMax:=rs2->Svp
      nRecSumMax:=1
      while (ttn=ttnr)
        mntovr=mntov
        ktlr=ktl
        kg_r=int(mntovr/10000)
        if (kg_r=0.and.sm12r=0)
          sele rs2
          skip
          if (eof())
            exit
          endif

          loop
        endif

        sele ctov
        if (netseek('t1', 'mntovr'))
          natr=natr(alltrim(nat),rs1->Dvp)
          uktr=ukt
          kodr=kspovo
          kger=kge
        else
          natr=''
          uktr=space(10)
          kodr=0
          kger=0
        endif

        markr=getfield('t1', 'kg_r', 'cgrp', 'mark')
        if (markr=1)
          if (kger#0)
            natr=alltrim(getfield('t1', 'kger', 'grpe', 'nge'))+' '+natr
          endif

        else
          if (gnEnt=21.and.(kg_r=342.or.kg_r=343.or.kg_r=338.or.kg_r=339))
            natr=alltrim(getfield('t1', 'kger', 'grpe', 'nge'))+' '+natr
          endif

        endif

        upur=getfield('t1', 'kodr', 'kspovo', 'upu')
        sele rs2
        kolr=kvp
        zenr=zen
        smr=round(kolr*zenr, 2)
        sele trs2
        netadd()
        netrepl('Npp,nat,ukt,upu,kod,kol,zen,sm,ktl',         ;
                 {Nppr,natr,uktr,upur,kodr,kolr,zenr,smr,ktlr} ;
              )

        If rs2->Svp > nSumMax
          nSumMax:=rs2->Svp
          nRecSumMax:=Nppr
        EndIf

        sele rs2
        skip
        if (eof())
          exit
        endif

        Nppr=Nppr+1
      enddo

    endif

  endif

  // добавим к самой большой сумме разницу
  sele trs2
  DBGoTo(nRecSumMax)
  netrepl("sm",{sm + sm43r})

  nuse('rs1')
  nuse('rs2')
  nuse('rs3')
else                        //  Коригування
  mnr=getfield('t15', 'nndsr', 'dokk', 'mnp')
  skr=getfield('t15', 'nndsr', 'dokk', 'sk')
  pathr=gcPath_d+alltrim(getfield('t1', 'skr', 'cskl', 'path'))
  netuse('pr1',,, 1)
  netuse('pr2',,, 1)
  netuse('pr3',,, 1)
  sele pr1
  if (netseek('t2', 'mnr'))
    SkVzr=SkVz
    ttnVzr=ttnVz
    dtVzr=dtVz
    nndsVzr=nndsVz
    dnnVzr=dnnVz
    kopr=kop
    if (str(kopr,3)$'108;107')
      //prichr='Змiна кiлькостi' // 'повернення товару'
      //prichr='Змўна кўлькостў' // 'повернення товару'
      prichr='102' //'Зм│на к│лькост│' // 'повернення товару' c179->│
    else                    // kopr=110
      //prichr='Змiна цiни'
      //prichr='Змўна цўни'
      prichr='102' //'Зм│на ц│ни'
    endif

    sele pr2
    set orde to tag t3
    if (netseek('t3', 'mnr'))
      Nppr=0
      while (mn=mnr)
        mntovr=mntov
        ktlr=ktl
        kg_r=int(mntovr/10000)
        sele ctov
        if (netseek('t1', 'mntovr'))
          natr=natr(alltrim(nat),dtVzr)
          uktr=ukt
          kodr=kspovo
          kger=kge
        else
          natr=''
          uktr=space(10)
          kodr=0
          kger=0
        endif

        markr=getfield('t1', 'kg_r', 'cgrp', 'mark')
        if (markr=1)
          if (kger#0)
            natr=alltrim(getfield('t1', 'kger', 'grpe', 'nge'))+' '+natr
          endif

        else
          if (gnEnt=21.and.(kg_r=342.or.kg_r=343.or.kg_r=338.or.kg_r=339))
            natr=alltrim(getfield('t1', 'kger', 'grpe', 'nge'))+' '+natr
          endif

        endif

        upur=getfield('t1', 'kodr', 'kspovo', 'upu')
        sele pr2
        if (str(kopr,3) $ '108;107')
          kolcr=-round(kf, 3)
          ozenr=round(ozen, 2)
          kolr=0
          izenr=0
          smr=round(kolcr*ozenr, 2)
          zenttnr=0
        else
          kolcr=0
          ozenr=0
          zenttnr=round(zenttn, 2)
          kolr=round(kfttn, 3)
          izenr=-round(zen, 2)
          smr=round(kolr*izenr, 2)
        endif

        if (nnds->rn#0)   // Нормальная
          if (str(kopr,3) $ '108;107')
            sele tpr2
            locate for ktl=ktlr
            if (!foun())
              netadd()
              netrepl('Npp,prich,nat,ukt,upu,kod,kolc,ozen,kol,izen,sm,zenttn,ktl',             ;
                       'Nppr,prichr,natr,uktr,upur,kodr,kolcr,ozenr,kolr,izenr,smr,zenttnr,ktlr' ;
                    )
            else
              kolcr=kolc+kolcr
              smr=round(ozenr*kolcr, 2)
              netrepl('kolc,sm', 'kolcr,smr')
            endif

          else              // 110
            sele tpr2
            locate for ktl=ktlr
            if (!foun())
              netadd()
              netrepl('Npp,prich,nat,ukt,upu,kod,kolc,ozen,kol,izen,sm,zenttn',            ;
                       'Nppr,prichr,natr,uktr,upur,kodr,kolcr,ozenr,kolr,izenr,smr,zenttnr' ;
                    )
            else
              kolr=kol+kolr
              smr=round(izenr*kolr, 2)
              netrepl('kol,sm', 'kolr,smr')
            endif

          endif

        else                // Свернутая
          if (str(kopr,3) $ '108;107')
            sele tpr2
            locate for nat=natr.and.ozen=ozenr
            if (!foun())
              netadd()
              netrepl('Npp,prich,nat,ukt,upu,kod,kolc,ozen,kol,izen,sm,zenttn,ktl',             ;
                       'Nppr,prichr,natr,uktr,upur,kodr,kolcr,ozenr,kolr,izenr,smr,zenttnr,ktlr' ;
                    )
            else
              kolcr=kolc+kolcr
              smr=round(ozenr*kolcr, 2)
              netrepl('kolc,sm', 'kolcr,smr')
            endif

          else              // 110
            sele tpr2
            locate for nat=natr.and.zenttn=zenttnr.and.izen=izenr
            if (!foun())
              netadd()
              netrepl('Npp,prich,nat,ukt,upu,kod,kolc,ozen,kol,izen,sm,zenttn',            ;
                       'Nppr,prichr,natr,uktr,upur,kodr,kolcr,ozenr,kolr,izenr,smr,zenttnr' ;
                    )
            else
              kolr=kol+kolr
              smr=round(izenr*kolr, 2)
              netrepl('kol,sm', 'kolr,smr')
            endif

          endif

        endif

        sele pr2
        skip
        if (eof())
          exit
        endif

      enddo

    endif


    if (nnds->rn#0)       // Нормальная

      if (!empty(skVzr))
        cPthSkVz:=alltrim(getfield('t1', 'skVzr', 'cskl', 'path'))
      else
        cPthSkVz:=alltrim(getfield('t1', 'nnds->sk', 'cskl', 'path'))
      endif

      pathr=gcPath_e+pathYYYYMM(dnnVzr)+'\'+cPthSkVz
      outlog(3,__FILE__,__LINE__,'pathr,ttnVzr',pathr,ttnVzr)
      netuse('rs1',,, 1)
      netuse('rs2',,, 1)
      sele rs1
      if (netseek('t1', 'ttnVzr'))
        sele rs2
        if (netseek('t1', 'ttnVzr'))
          // воставливание последовательно НН
          Nppr=1
          while (ttn=ttnVzr)
            mntovr=mntov
            ktlr=ktl
            kg_r=int(mntovr/10000)
            if (kg_r=0.and.sm12r=0)
              sele rs2
              skip
              if (eof())
                exit
              endif

              loop
            endif

            sele ctov
            if (netseek('t1', 'mntovr'))
              natr=natr(alltrim(nat),rs1->dvp)
              uktr=ukt
              kodr=kspovo
              kger=kge
            else
              natr=''
              uktr=space(10)
              kodr=0
              kger=0
            endif

            markr=getfield('t1', 'kg_r', 'cgrp', 'mark')
            if (markr=1)
              if (kger#0)
                natr=alltrim(getfield('t1', 'kger', 'grpe', 'nge'))+' '+natr
              endif

            else
              if (gnEnt=21.and.(str(kg_r,3)$'342;343;338;339'))
                natr=alltrim(getfield('t1', 'kger', 'grpe', 'nge'))+' '+natr
              endif

            endif

            upur=getfield('t1', 'kodr', 'kspovo', 'upu')
            sele rs2
            kolr=kvp
            zenr=zen
            smr=round(kolr*zenr, 2)
            sele trs2
            netadd()
            outlog(3,__FILE__,__LINE__,"natr",len(natr),natr)
            netrepl('Npp,nat,ukt,upu,kod,kol,zen,sm,ktl',         ;
                     {Nppr,natr,uktr,upur,kodr,kolr,zenr,smr,ktlr} ;
                  )
            sele rs2
            skip
            if (eof())
              exit
            endif

            Nppr++
          enddo

        endif

      endif

      nuse('rs1')
      nuse('rs2')
    else                    // nnds->rn=0  Свернутая
      ttnr=0
      if (select('lnndoc')#0)
        sele lnndoc
        CLOSE
        erase lnndoc.dbf
      endif

      crtt('lnndoc', 'f:sk c:n(3) f:doc c:n(6) f:sm c:n(12,2)')
      sele 0
      use lnndoc
      if (select('lnnsk')#0)
        sele lnnsk
        CLOSE
        erase lnnsk.dbf
      endif

      crtt('lnnsk', 'f:sk c:n(3)')
      sele 0
      use lnnsk
      sele dokk
      set orde to tag t15
      if (netseek('t15', 'nnds1r'))
        while (nnds=nnds1r)
          if (mnp#0)
            skip
            loop
          endif

          skr=sk
          docr=rn
          smr=bs_s
          sele lnndoc
          appe blank
          repl sk with skr, ;
           doc with docr,   ;
           sm with smr
          sele lnnsk
          locate for sk=skr
          if (!foun())
            appe blank
            repl sk with skr
          endif

          sele dokk
          skip
        enddo

      endif

      sele lnnsk
      go top
      while (!eof())
        skr=sk
        sele cskl
        locate for sk=skr
        pathr=gcPath_d+alltrim(path)
        netuse('rs2', 'rs2'+str(skr, 3),, 1)
        netuse('rs3', 'rs3'+str(skr, 3),, 1)
        sele lnnsk
        skip
      enddo

      copy file(gcPath_a+'rs1.dbf') to lrs1.dbf
      copy file(gcPath_a+'rs2.dbf') to lrs2.dbf
      copy file(gcPath_a+'rs3.dbf') to lrs3.dbf

      sele 0
      use lrs1 alias rs1 excl
      inde on str(ttn, 6) tag t1
      set orde to tag t1
      appe blank
      repl skl with 3

      sele 0
      use lrs2 alias rs2 excl
      inde on str(ttn, 6)+str(mntov, 7)+str(zen, 15, 3) tag t1
      set orde to tag t1

      sele 0
      use lrs3 alias rs3 excl
      inde on str(ttn, 6)+str(ksz, 2) tag t1
      set orde to tag t1

      sele lnndoc
      go top
      while (!eof())
        skr=sk
        docr=doc
        smr=sm
        sele ('rs2'+str(skr, 3))
        if (netseek('t1', 'docr'))
          while (ttn=docr)
            mntovr=mntov
            kvpr=kvp
            zenr=zen
            svpr=svp
            sele rs2
            seek str(ttnr, 6)+str(mntovr, 7)+str(zenr, 15, 3)
            if (!foun())
              appe blank
              repl mntov with mntovr, ;
               zen with zenr
            endif

            repl kvp with kvp+kvpr, ;
             svp with svp+svpr
            sele ('rs2'+str(skr, 3))
            skip
          enddo

          sele ('rs3'+str(skr, 3))
          if (netseek('t1', 'docr'))
            while (ttn=docr)
              kszr=ksz
              ssfr=ssf
              sele rs3
              locate for ksz=kszr
              if (!foun())
                appe blank
                repl ksz with kszr
              endif

              repl ssf with ssf+ssfr
              sele ('rs3'+str(skr, 3))
              skip
            enddo

          endif

        endif

        sele lnndoc
        skip
      enddo

      Nppr=1
      sele rs2
      go top
      while (!eof())
        mntovr=mntov
        kg_r=int(mntovr/10000)
        if (kg_r=0.and.sm12r=0)
          sele rs2
          skip
          if (eof())
            exit
          endif

          loop
        endif

        sele ctov
        if (netseek('t1', 'mntovr'))
          natr=alltrim(nat)
          uktr=ukt
          kodr=kspovo
          kger=kge
        else
          natr=''
          uktr=space(10)
          kodr=0
          kger=0
        endif

        markr=getfield('t1', 'kg_r', 'cgrp', 'mark')
        if (markr=1)
          if (kger#0)
            natr=alltrim(getfield('t1', 'kger', 'grpe', 'nge'))+' '+natr
          endif

        else
          if (gnEnt=21.and.(kg_r=342.or.kg_r=343.or.kg_r=338.or.kg_r=339))
            natr=alltrim(getfield('t1', 'kger', 'grpe', 'nge'))+' '+natr
          endif

        endif

        upur=getfield('t1', 'kodr', 'kspovo', 'upu')
        sele rs2
        kolr=kvp
        zenr=zen
        smr=round(kolr*zenr, 2)
        sele trs2
        netadd()
        netrepl('Npp,nat,ukt,upu,kod,kol,zen,sm',        ;
                 'Nppr,natr,uktr,upur,kodr,kolr,zenr,smr' ;
              )
        sele rs2
        skip
        if (eof())
          exit
        endif

        Nppr=Nppr+1
      enddo

      sele lnnsk
      go top
      while (!eof())
        skr=sk
        sele cskl
        nuse('rs2'+str(skr, 3))
        nuse('rs3'+str(skr, 3))
        sele lnnsk
        skip
      enddo

    endif

    // проставляем номера строк из НН на оснвании trs2
    sele tpr2

    copy stru to _tpr2 // пустая для накопления
    copy to tPr21
    copy to tPr22
    USE _tpr2 NEW
    USE tPr21 NEW
    USE tPr22 NEW


    sele tpr2
    go top
    while (!eof())
      ktlr=ktl
      natr=nat
      uktr=ukt
      if (ozen#0)
        zenr=ozen
      else
        zenr=zenttn
      endif

      sele trs2
      if (nnds->rn#0)     // Нормальная
        locate for ktl=ktlr
        If !found() // может не найти, если приход (возврать) в другой склад
          locate for nat=natr.and.ukt=uktr.and.zen=zenr
        EndIf
      else
        locate for nat=natr.and.ukt=uktr.and.zen=zenr
      endif

      if (foun())
        Nppr=Npp
        sele tpr2
        repl Npp with Nppr

        //новое
        sele tPr21
        DBGoTo(tpr2->(RecNo()))
        repl Npp with Nppr,;
        KolC with trs2->Kol * (-1), sm with KolC * oZen  // из расхода послностью сторно

        sele tPr22
        DBGoTo(tpr2->(RecNo()))
        repl Npp with trs2->(LASTREC()) + tpr2->(RECNO()), ; //Nppr,;
        KolC with trs2->Kol + _FIELD->KolC, sm with KolC * oZen  // из расхода послностью сторно

      endif

      sele tpr2
      skip
      if (eof())
        exit
      endif

    enddo

    close tPr21
    close tPr22
    // собрали
    sele  _tpr2
    append from tPr21
    append from tPr22
    SORT TO tPr20 ON  nat, Npp
    close _tpr2

    If nnds->DNn >= STOD('20180301')
      // двумя строками
      sele tpr2
      copy to ('tpr2-') // старый вариант
      ZAP
      append from tPr20
    EndIf


  endif

  nuse('pr1')
  nuse('pr2')
  nuse('pr3')
endif


// HBOS   инициали та призвище
// HKBOS  рег ном обл картки або ном пасп
do case
case (gnEnt=20)
  hbosr='К.М.ОБУХОВСЬКА' // 'Н.Ф.ЛЕБЕДЄВА'
  hkbosr='2714412148' ///'1974415049'
case (gnEnt=21)
  hbosr='К.В.СIДАШ'
  hkbosr='2338905321'
endcase

do case
case (nnds->dnn>=ctod('16.11.2018').and.date()>=ctod('16.11.2018'))//.or.gnAdm=1 // !!!! Убрать
                            //        if nnds->nnds1=0
  if (nnds->rn#0.and.nnds->mnp=0.or.nnds->rn=0.and.nnds->mnp=0.and.nnds->nnds1=0)// ПН


    // J1201010 податкова

    // R003G10S код пильги

    R003G10Sr=''

    // H03    звед пн
    H03r=''
    // H02    скл на опер зв в опод
    H02r=''

    // HORIG1 не пидл отр
    HORIG1r=''
    // HTYPR  тип прич
    HTYPRr=''
    // HFILL  дата
    HFILLr=subs(dtos(nnds->dnn), 7, 2)+subs(dtos(nnds->dnn), 5, 2)+subs(dtos(nnds->dnn), 1, 4)
    // HNUM   пор номер
    HNUMr=alltrim(str(nnds->nnds, 10))
    // HNUM1  код виду дияльн
    HNUM1r=''
    // HNAMESEL наим продавця
    // HKSEL    инд подат номер
    sele kln
    netseek('t1', 'gnKkl_c')
    HNAMESELr=alltrim(nklprn)
    if (!empty(cnn))
      HKSELr=cnn
    else
      HKSELr=alltrim(str(nn, 12))
    endif

    // HNUM2    ном филии
    HNUM2r=''
    // HNAMEBUY наим покуп
    // HKBUY    инд подат номер
    sele kln
    netseek('t1', 'nnds->kkl')
    HNAMEBUYr=alltrim(nklprn)
    if (kln->nn#0)
      if (!empty(cnn))
        HKBUYr=cnn
      else
        HKBUYr=alltrim(str(nn, 12))
      endif
      HTINBUYr=eval({|cK| cK:=allt(str(cK,10)), cK:=iif(len(cK)=10,cK,padl(cK,8,'0')), cK },kkl1)
      HORIG1r=''
      HTYPRr=''
    else
      HKBUYr='100000000000'
      HNAMEBUYr='Неплатник'
      HTINBUYr=''
      HORIG1r='1'
      HTYPRr='02'
    endif

    // HFBUY    ном филии
    HFBUYr=''

    sele trs2
    SUM sm to sm10r         // сумма без ндс

    s11r=round(sm10r/5, 2)// ндс
    s90r=sm10r+s11r         // сумма с ндс

    /* A */
    /* R04G11    I */
    R04G11r=alltrim(str(s90r, 12, 2))
    // R03G11   II
    R03G11r=alltrim(str(s11r, 12, 2))
    // R03G7   III
    R03G7r=alltrim(str(s11r, 12, 2))
    // R03G109  IV
    R03G109r=''
    // R01G7     V
    R01G7r=alltrim(str(sm10r, 12, 2))
    // R01G109  VI
    R01G109r=''
    // R01G9   VII
    R01G9r=''
    // R01G8  VIII
    R01G8r=''
    // R01G10   IX
    R01G10r=''
    // R02G11    X
    R02G11r=''
    // Б
    //              1 нпп
    // RXXXXG3S     2 номенкл
    // RXXXXG4      3 укт зед
    // RXXXXD4S     4 наим ед изм
    // RXXXXG32S    3.2 озн импорта
    // RXXXXG33S    3.3 код послуги
    // RXXXXG105_2S 5 код ед изм
    // RXXXXG5      6 к-во
    // RXXXXG6      7 цена
    // RXXXXG008    8 код ставки
    // RXXXXG009    9 код пильги
    // RXXXXG010   10 сумма(обсяг постач)

    sele nnds
    if (pr1ndsr=0)
      ifl_r='1819'+lzero(okpor, 10)+'j12'+iif(mnp=0, '010', '012')+'10'+'1'+'00'+lzero(nnds, 7)+'1'+lzero(month(dnn), 2)+str(year(dnn), 4)+'1819'
    else
      ifl_r='1819'+lzero(okpor, 10)+'j12'+iif(nnds1=0, '010', '012')+'10'+'1'+'00'+lzero(nnds, 7)+'1'+lzero(month(dnn), 2)+str(year(dnn), 4)+'1819'
    endif

    if (!empty(ifl_r))
#ifdef __CLIP__
        cCodePrint:= set("PRINTER_CHARSET", "cp1251")
        set prin to (PathNXmlr+ifl_r+'.xml')
#else
        set prin to (PathNXmlr+'n'+subs(ifl_r, 26, 7)+'.xml')
#endif
      set prin on
      set cons off
    endif

    // Шапка
    ??'<?xml version="1.0" encoding="windows-1251"?>'
    ?'<DECLAR xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="J1201009.xsd">'

    ?'<DECLARHEAD>'

    ?'<TIN>'+alltrim(str(okpor, 10))+'</TIN>'
    ?'<C_DOC>J12</C_DOC>'
    ?'<C_DOC_SUB>010</C_DOC_SUB>'
    ?'<C_DOC_VER>10</C_DOC_VER>'
    ?'<C_REG>18</C_REG>'
    ?'<C_RAJ>19</C_RAJ>'
    ?'<PERIOD_MONTH>'+PERIOD_MONTHr+'</PERIOD_MONTH>'
    ?'<PERIOD_TYPE>1</PERIOD_TYPE>'
    ?'<PERIOD_YEAR>'+PERIOD_YEARr+'</PERIOD_YEAR>'
    ?'<C_STI_ORIG>1819</C_STI_ORIG>'
    ?'<C_DOC_STAN>1</C_DOC_STAN>'
    ?'<LINKED_DOCS xsi:nil="true"></LINKED_DOCS>'
    ?'<D_FILL>'+D_FILLr+'</D_FILL>'
    ?'<SOFTWARE xsi:nil="true"></SOFTWARE>'

    ?'</DECLARHEAD>'

    ?'<DECLARBODY>'
    ?'<H03>'+H03r+'</H03>'
    ?'<H02>'+H02r+'</H02>'
    ?'<HORIG1>'+HORIG1r+'</HORIG1>'
    ?'<HTYPR>'+HTYPRr+'</HTYPR>'

    ?'<HFILL>'+HFILLr+'</HFILL>'
    ?'<HNUM>'+HNUMr+'</HNUM>'
    ?'<HNUM1>'+HNUM1r+'</HNUM1>'

    ?'<HNAMESEL>'+HNAMESELr+'</HNAMESEL>'
    ?'<HKSEL>'+HKSELr+'</HKSEL>'
    ?'<HNUM2>'+HNUM2r+'</HNUM2>'
    ?'<HTINSEL>'+alltrim(str(okpor, 10))+'</HTINSEL>'

    ?'<HNAMEBUY>'+HNAMEBUYr+'</HNAMEBUY>'
    ?'<HKBUY>'+HKBUYr+'</HKBUY>'
    ?'<HFBUY>'+HFBUYr+'</HFBUY>'
    If EMPTY(HTINBUYr)
      ?'<HTINBUY xsi:nil="true"></HTINBUY>'
    Else
      ?'<HTINBUY>'+HTINBUYr+'</HTINBUY>'
    EndIf

    ?'<R04G11>'+R04G11r+'</R04G11>'
    ?'<R03G11>'+R03G11r+'</R03G11>'
    ?'<R03G7>'+R03G7r+'</R03G7>'
    ?'<R03G109>'+R03G109r+'</R03G109>'
    ?'<R01G7>'+R01G7r+'</R01G7>'
    ?'<R01G109>'+R01G109r+'</R01G109>'
    ?'<R01G9>'+R01G9r+'</R01G9>'
    ?'<R01G8>'+R01G8r+'</R01G8>'
    ?'<R01G10>'+R01G10r+'</R01G10>'
    ?'<R02G11>'+R02G11r+'</R02G11>'
    for i=1 to 14
      sele trs2
      go top
      RowNumr=1
      do case
      case (i=1)          // Npp n()3
      case (i=2)          // nat c(60)
        while (!eof())
          natr:=DeleChrWd_AKZ(nat)
          ?'<RXXXXG3S ROWNUM="'+alltrim(str(RowNumr, 3))+'">' ;
           +XmlCharTran(natr)+'</RXXXXG3S>'
          RowNumr=RowNumr+1
          sele trs2; skip
        enddo

      case (i=3)          // ukt c(10)
        while (!eof())
          ?'<RXXXXG4 ROWNUM="'+alltrim(str(RowNumr, 3))+'">' ;
           +alltrim(ukt)+'</RXXXXG4>'
          RowNumr=RowNumr+1
          sele trs2; skip
        enddo

      case (i=4)          //     3.2 озн импорта
        OutXml_TxR('RXXXXG32S', 0)
      case (i=5)          //    3.3 код послуги
        OutXml_TxR('RXXXXG33S', 0)
      case (i=6)          // upu c(20)
        while (!eof())
          ?'<RXXXXG4S ROWNUM="'+alltrim(str(RowNumr, 3))+'">' ;
           +alltrim(upu)+'</RXXXXG4S>'
          RowNumr=RowNumr+1
          sele trs2; skip
        enddo

      case (i=7)          // kod n(4)
        while (!eof())
          ?'<RXXXXG105_2S ROWNUM="'+alltrim(str(RowNumr, 3))+'">'  ;
           +padl(alltrim(str(kod, 4)), 4, '0')+'</RXXXXG105_2S>'
          RowNumr=RowNumr+1
          sele trs2; skip
        enddo

      case (i=8)          // kol n(12,3)
        while (!eof())
          ?'<RXXXXG5 ROWNUM="'+alltrim(str(RowNumr, 3))+'">' ;
           +alltrim(str(kol, 12, 3))+'</RXXXXG5>'
          RowNumr=RowNumr+1
          sele trs2; skip
        enddo

      case (i=9)          // zen n(10,2)
        while (!eof())
          ?'<RXXXXG6 ROWNUM="'+alltrim(str(RowNumr, 3))+'">' ;
           +alltrim(str(zen, 10, 2))+'</RXXXXG6>'
          RowNumr=RowNumr+1
          sele trs2; skip
        enddo

      case (i=10)         // 20
        while (!eof())
          ?'<RXXXXG008 ROWNUM="'+alltrim(str(RowNumr, 3))+'">' ;
           +str(gnNDS, 2)+'</RXXXXG008>'
          RowNumr=RowNumr+1
          sele trs2; skip
        enddo

      case (i=11)         // ''
        while (!eof())
          ?'<RXXXXG009 ROWNUM="'+alltrim(str(RowNumr, 3))+'">' ;
           +R003G10Sr+'</RXXXXG009>'
          RowNumr=RowNumr+1
          sele trs2; skip
        enddo

      case (i=12)         // sm n(12,2)
        while (!eof())
          ?'<RXXXXG010 ROWNUM="'+alltrim(str(RowNumr, 3))+'">' ;
           +alltrim(str(sm, 12, 2))+'</RXXXXG010>'
          RowNumr=RowNumr+1
          sele trs2; skip
        enddo

      case (i=13)         // sm n(12,2)
        while (!eof())
          ?'<RXXXXG11_10 ROWNUM="'+alltrim(str(RowNumr, 3))+'">' ;
           +alltrim(str(sm * round(gnNDS/100, 2), 12, 3))+'</RXXXXG11_10>'
          RowNumr=RowNumr+1
          sele trs2; skip
        enddo

      case (i=14)         // sm n(12,2)
        OutXml_TxR('RXXXXG011', 0)
      endcase

    next

    ?'<HBOS>'+HBOSr+'</HBOS>'
    ?'<HKBOS>'+HKBOSr+'</HKBOS>'

    ?'</DECLARBODY>'

    ?'</DECLAR>'

    /******************** */
    // J1201108 додаток1
    /******************** */

    // HPODFILL  дата
    // HPODNUM   пор ном
    // HPODNUM1

    //               1 нпп
    // RXXXXG3S      2 номенклат
    // RXXXXG4       3 укт зед
    // RXXXXG32S    3.2 озн импорта
    // RXXXXG33S    3.3 код послуги
    // RXXXXG4S      4 наим ед изм
    // RXXXXG105_2S  5 код ед изм
    // RXXXXG5       6 цена
    // RXXXXG6       7 к-во
    // RXXXXG7       8 сумма без ндс
    // RXXXXG9S      9 ед изм скоко поставлено
    // RXXXXGG10    10 к-во скоко поставлено
    // RXXXXG12S    11 ед изм скоко осталось поставить
    // RXXXXG13     12 к-во скоко осталось поставить
    // R01G7        13 сумма без ндс всего

  else
    /******************************************* */
    // J1201208 розрахунок коригування додаток2
    /******************************************* */
    R003G10Sr=''
    // HERPN0 пидл реестр пост
    HERPN0r=''
    // HERPN   пидл реестр отрим
    HERPNr=''
    // H03     до звед под накл
    H03r=''
    // H02     до пн звильн вид опер оподатк
    H02r=''
    // HORIG1  не пидл наданню отримувачу
    HORIG1r=''
    // HTYPR   причина
    HTYPRr=''

    // HFILL     дата розр
    HFILLr=subs(dtos(nnds->dnn), 7, 2)+subs(dtos(nnds->dnn), 5, 2)+subs(dtos(nnds->dnn), 1, 4)
    // HNUM   пор номер
    HNUMr=alltrim(str(nnds->nnds, 10))
    // HNUM1     код виду дияльн
    HNUM1r=''
    // HPODFILL  дата пнн
    HPODFILLr=subs(dtos(nnds->dnn1), 7, 2)+subs(dtos(nnds->dnn1), 5, 2)+subs(dtos(nnds->dnn1), 1, 4)
    // HPODNUM   ном пнн
    HPODNUMr=alltrim(str(nnds->nnds1, 10))
    // HPODNUM1  ном пнн1
    HPODNUM1r=''
    // HPODNUM2  ном пнн2
    HPODNUM2r=''

    // HNAMESEL наим продавця
    // HKSEL    инд подат номер
    sele kln
    netseek('t1', 'gnKkl_c')
    HNAMESELr=alltrim(nklprn)
    if (!empty(cnn))
      HKSELr=cnn
    else
      HKSELr=alltrim(str(nn, 12))
    endif

    // HNUM2    ном филии
    HNUM2r=''

    // HNAMEBUY наим покуп
    // HKBUY    инд подат номер
    sele kln
    netseek('t1', 'nnds->kkl')
    HNAMEBUYr=alltrim(nklprn)
    if (kln->nn#0)
      if (!empty(cnn))
        HKBUYr=cnn
      else
        HKBUYr=alltrim(str(nn, 12))
      endif
      HTINBUYr=eval({|cK| cK:=allt(str(cK,10)), cK:=iif(len(cK)=10,cK,padl(cK,8,'0')), cK },kkl1)
      //HTINBUYr=padl(alltrim(str(kkl1, 10)),8,'0')

      HERPN0r=''
      HERPNr='1'
    else
      HKBUYr='100000000000'
      HNAMEBUYr='Неплатник'
      HTINBUYr=''
      HORIG1r='1'
      HTYPRr='02'
      HERPN0r='1'
      HERPNr=''
    endif

    // HFBUY    ном филии
    HFBUYr=''

    sele tpr2
    SUM sm to sm10r         // сумма без ндс

    s11r=round(sm10r/5, 2)// ндс
    s90r=sm10r+s11r         // сумма с ндс

    /* A */
    /* R001G03     I сума корр */
    R001G03r=alltrim(str(s11r, 12, 2))
    // R02G9      II сума корр осн ставка
    R02G9r=alltrim(str(s11r, 12, 2))
    // R02G111   III сума корр  7
    R02G111r=''
    // R01G9      IV сума корр ставка 20
    R01G9r=alltrim(str(sm10r, 12, 2))
    // R01G111     V сума корр ставка  7
    R01G111r=''
    // R006G03    VI сума корр ставка 901
    R006G03r=''
    // R007G03   VII сума корр ставка 902
    R007G03r=''
    // R01G11   VIII сума корр ставка  903
    R01G11r=''

    // Б
    // RXXXXG001      1 номер рядка пнн що кориг
    // RXXXXG2S       2 причина кориг
    // RXXXXG3S       3 номенкл
    // RXXXXG4        4 укт зед
    // RXXXXG4S       5 наим ед изм
    // RXXXXG105_2S   6 код ед изм
    // RXXXXG5        7 изм к-ва
    // RXXXXG6        8 цена поставки
    // RXXXXG7        9 изм цены
    // RXXXXG8       10 к-во
    // RXXXXG008     11 код ставки
    // RXXXXG009     12 код пильги
    // RXXXXG010     13 сумма

    sele nnds
    ifl_r='1819'+lzero(okpor, 10);
    +'j1201210'+'1'+'00';
    +lzero(nnds, 7);
    +'1'+lzero(month(dnn), 2)+str(year(dnn), 4);
    +'1819'
    if (!empty(ifl_r))
#ifdef __CLIP__
        cCodePrint:= set("PRINTER_CHARSET", "cp1251")
        set prin to (PathNXmlr+ifl_r+'.xml')
#else
        set prin to (PathNXmlr+'n'+subs(ifl_r, 26, 7)+'.xml')
#endif
      set prin on
      set cons off
    endif

    //  Шапка
    ??'<?xml version="1.0" encoding="windows-1251"?>'
    ?'<DECLAR xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="J1201209.xsd">'

    ?'<DECLARHEAD>'

    ?'<TIN>'+alltrim(str(okpor, 10))+'</TIN>'
    ?'<C_DOC>J12</C_DOC>'
    ?'<C_DOC_SUB>012</C_DOC_SUB>'
    ?'<C_DOC_VER>10</C_DOC_VER>'
    ?'<C_REG>18</C_REG>'
    ?'<C_RAJ>19</C_RAJ>'
    ?'<PERIOD_MONTH>'+PERIOD_MONTHr+'</PERIOD_MONTH>'
    ?'<PERIOD_TYPE>1</PERIOD_TYPE>'
    ?'<PERIOD_YEAR>'+PERIOD_YEARr+'</PERIOD_YEAR>'
    ?'<C_STI_ORIG>1819</C_STI_ORIG>'
    ?'<C_DOC_STAN>1</C_DOC_STAN>'
    ?'<LINKED_DOCS xsi:nil="true"></LINKED_DOCS>'
    ?'<D_FILL>'+D_FILLr+'</D_FILL>'
    ?'<SOFTWARE xsi:nil="true"></SOFTWARE>'

    ?'</DECLARHEAD>'

    ?'<DECLARBODY>'
    ?'<HERPN0>'+HERPN0r+'</HERPN0>'
    ?'<HERPN>'+HERPNr+'</HERPN>'
    ?'<H03>'+H03r+'</H03>'
    ?'<H02>'+H02r+'</H02>'
    ?'<HORIG1>'+HORIG1r+'</HORIG1>'
    ?'<HTYPR>'+HTYPRr+'</HTYPR>'

    ?'<HFILL>'+HFILLr+'</HFILL>'
    ?'<HNUM>'+HNUMr+'</HNUM>'
    ?'<HNUM1>'+HNUM1r+'</HNUM1>'

    ?'<HPODFILL>'+HPODFILLr+'</HPODFILL>'
    ?'<HPODNUM>'+HPODNUMr+'</HPODNUM>'
    ?'<HPODNUM1>'+HPODNUM1r+'</HPODNUM1>'
    ?'<HPODNUM2>'+HPODNUM2r+'</HPODNUM2>'

    ?'<HNAMESEL>'+HNAMESELr+'</HNAMESEL>'
    ?'<HKSEL>'+HKSELr+'</HKSEL>'
    ?'<HNUM2>'+HNUM2r+'</HNUM2>'
    ?'<HTINSEL>'+alltrim(str(okpor, 10))+'</HTINSEL>'

    ?'<HNAMEBUY>'+HNAMEBUYr+'</HNAMEBUY>'
    ?'<HKBUY>'+HKBUYr+'</HKBUY>'
    ?'<HFBUY>'+HFBUYr+'</HFBUY>'
    If EMPTY(HTINBUYr)
      ?'<HTINBUY xsi:nil="true"></HTINBUY>'
    Else
      ?'<HTINBUY>'+HTINBUYr+'</HTINBUY>'
    EndIf

    ?'<R001G03>'+R001G03r+'</R001G03>'
    ?'<R02G9>'+R02G9r+'</R02G9>'
    ?'<R02G111>'+R02G111r+'</R02G111>'
    ?'<R01G9>'+R01G9r+'</R01G9>'
    ?'<R01G111>'+R01G111r+'</R01G111>'
    ?'<R006G03>'+R006G03r+'</R006G03>'
    ?'<R007G03>'+R007G03r+'</R007G03>'
    ?'<R01G11>'+R01G11r+'</R01G11>'
    for i=1 to 18
      RowNumr=1
      sele tpr2
      go top
      do case
      case (i=1)          // Npp n(3)
        while (!eof())
          ?'<RXXXXG001 ROWNUM="'+alltrim(str(RowNumr, 3))+'">' ;
           +alltrim(str(Npp, 3))+'</RXXXXG001>'
          RowNumr=RowNumr+1
          sele tpr2; skip
        enddo

      case (i=2)          // prich c(20)
        while (!eof())
          ?'<RXXXXG21 ROWNUM="'+alltrim(str(RowNumr, 3))+'">' ;
           +alltrim(prich)+'</RXXXXG21>'
          RowNumr=RowNumr+1
          sele tpr2; skip
        enddo

      case (i=3)          // nat c(60)
        while (!eof())
          natr:=DeleChrWd_AKZ(nat)
          ?'<RXXXXG3S ROWNUM="'+alltrim(str(RowNumr, 3))+'">' ;
           +XmlCharTran(natr)+'</RXXXXG3S>'
          RowNumr=RowNumr+1
          sele tpr2; skip
        enddo

      case (i=4)          // ukt c(10)
        while (!eof())
          ?'<RXXXXG4 ROWNUM="'+alltrim(str(RowNumr, 3))+'">' ;
           +alltrim(ukt)+'</RXXXXG4>'
          RowNumr=RowNumr+1
          sele tpr2; skip
        enddo

      case (i=5)          //     3.2 озн импорта
        OutXml_TxR('RXXXXG32S', 0)
      case (i=6)          //    3.3 код послуги
        OutXml_TxR('RXXXXG33S', 0)
      case (i=7)          // upu c(20)
        while (!eof())
          ?'<RXXXXG4S ROWNUM="'+alltrim(str(RowNumr, 3))+'">' ;
           +alltrim(upu)+'</RXXXXG4S>'
          RowNumr=RowNumr+1
          sele tpr2; skip
        enddo

      case (i=8)          // kod n(4)
        while (!eof())
          ?'<RXXXXG105_2S ROWNUM="'+alltrim(str(RowNumr, 3))+'">'  ;
           +padl(alltrim(str(kod, 4)), 4, '0')+'</RXXXXG105_2S>'
          RowNumr=RowNumr+1
          sele tpr2; skip
        enddo

      case (i=9)          // kolc n(12,3)
        if (str(kopr,3) $ '108;107')
          while (!eof())
            ?'<RXXXXG5 ROWNUM="'+alltrim(str(RowNumr, 3))+'">' ;
             +alltrim(str(kolc, 12, 3))+'</RXXXXG5>'
            RowNumr=RowNumr+1
            sele tpr2; skip
          enddo

        else
          while (!eof())
            ?'<RXXXXG5 ROWNUM="'+alltrim(str(RowNumr, 3))+'"></RXXXXG5>'
            RowNumr=RowNumr+1
            sele tpr2; skip
          enddo

        endif

      case (i=10)
        if (str(kopr,3) $ '108;107')     // ozen n(10,2)
          while (!eof())
            ?'<RXXXXG6 ROWNUM="'+alltrim(str(RowNumr, 3))+'">' ;
             +alltrim(str(ozen, 10, 2))+'</RXXXXG6>'
            RowNumr=RowNumr+1
            sele tpr2; skip
          enddo

        else
          while (!eof())
            ?'<RXXXXG6 ROWNUM="'+alltrim(str(RowNumr, 3))+'"></RXXXXG6>'
            RowNumr=RowNumr+1
            sele tpr2; skip
          enddo

        endif

      case (i=11)         // izen n(10,2)
        if (kopr=110)
          while (!eof())
            ?'<RXXXXG7 ROWNUM="'+alltrim(str(RowNumr, 3))+'">' ;
             +alltrim(str(izen, 10, 2))+'</RXXXXG7>'
            RowNumr=RowNumr+1
            sele tpr2; skip
          enddo

        else
          while (!eof())
            ?'<RXXXXG7 ROWNUM="'+alltrim(str(RowNumr, 3))+'"></RXXXXG7>'
            RowNumr=RowNumr+1
            sele tpr2; skip
          enddo

        endif

      case (i=12)         // kol n(12,3)
        if (kopr=110)
          while (!eof())
            ?'<RXXXXG8 ROWNUM="'+alltrim(str(RowNumr, 3))+'">'+ ;
             alltrim(str(kol, 12, 3))+'</RXXXXG8>'
            RowNumr=RowNumr+1
            sele tpr2; skip
          enddo

        else
          while (!eof())
            ?'<RXXXXG8 ROWNUM="'+alltrim(str(RowNumr, 3))+'"></RXXXXG8>'
            RowNumr=RowNumr+1
            sele tpr2; skip
          enddo

        endif

      case (i=13)         // 20
        while (!eof())
          ?'<RXXXXG008 ROWNUM="'+alltrim(str(RowNumr, 3))+'">' ;
           +str(20, 2)+'</RXXXXG008>'
          RowNumr=RowNumr+1
          sele tpr2; skip
        enddo

      case (i=14)         // ''
        while (!eof())
          ?'<RXXXXG009 ROWNUM="'+alltrim(str(RowNumr, 3))+'">' ;
           +R003G10Sr+'</RXXXXG009>'
          RowNumr=RowNumr+1
          sele tpr2; skip
        enddo

      case (i=15)         // sm n(12,2)
        while (!eof())
          ?'<RXXXXG010 ROWNUM="'+alltrim(str(RowNumr, 3))+'">' ;
           +alltrim(str(sm, 12, 2))+'</RXXXXG010>'
          RowNumr=RowNumr+1
          sele tpr2; skip
        enddo
      case (i=16)         // sm n(12,2)
        while (!eof())
          ?'<RXXXXG11_10 ROWNUM="'+alltrim(str(RowNumr, 3))+'">' ;
           +alltrim(str(sm * round(gnNDS/100, 2), 12, 3))+'</RXXXXG11_10>'
          RowNumr=RowNumr+1
          sele tpr2; skip
        enddo

      case (i=17)
        OutXml_TxR('RXXXXG011', 0)
      case (i=18)          // prich c(20)
        nNomGrCorr:=1
        nKtl:=Ktl
        while (!eof())
          Do While nKtl = Ktl
            ?'<RXXXXG22 ROWNUM="'+alltrim(str(RowNumr, 3))+'">' ;
             +alltrim(str(nNomGrCorr,3))+'</RXXXXG22>'
            RowNumr=RowNumr+1
            sele tpr2; skip
          EndDo
          nNomGrCorr++
          nKtl:=Ktl

        enddo
      endcase

    next

    ?'<HBOS>'+HBOSr+'</HBOS>'
    ?'<HKBOS>'+HKBOSr+'</HKBOS>'

    ?'</DECLARBODY>'

    ?'</DECLAR>'

  endif

case (nnds->dnn>=ctod('16.03.2017').and.date()>=ctod('16.03.2017'))//.or.gnAdm=1 // !!!! Убрать
                            //        if nnds->nnds1=0
  if (nnds->rn#0.and.nnds->mnp=0.or.nnds->rn=0.and.nnds->mnp=0.and.nnds->nnds1=0)// ПН
    /********************* */
                            // J1201009 податкова
    /********************* */
                            // R003G10S код пильги
    R003G10Sr=''

    // H03    звед пн
    H03r=''
    // H02    скл на опер зв в опод
    H02r=''

    // HORIG1 не пидл отр
    HORIG1r=''
    // HTYPR  тип прич
    HTYPRr=''
    // HFILL  дата
    HFILLr=subs(dtos(nnds->dnn), 7, 2)+subs(dtos(nnds->dnn), 5, 2)+subs(dtos(nnds->dnn), 1, 4)
    // HNUM   пор номер
    HNUMr=alltrim(str(nnds->nnds, 10))
    // HNUM1  код виду дияльн
    HNUM1r=''
    // HNAMESEL наим продавця
    // HKSEL    инд подат номер
    sele kln
    netseek('t1', 'gnKkl_c')
    HNAMESELr=alltrim(nklprn)
    if (!empty(cnn))
      HKSELr=cnn
    else
      HKSELr=alltrim(str(nn, 12))
    endif

    // HNUM2    ном филии
    HNUM2r=''
    // HNAMEBUY наим покуп
    // HKBUY    инд подат номер
    sele kln
    netseek('t1', 'nnds->kkl')
    HNAMEBUYr=alltrim(nklprn)
    if (kln->nn#0)
      if (!empty(cnn))
        HKBUYr=cnn
      else
        HKBUYr=alltrim(str(nn, 12))
      endif

      HORIG1r=''
      HTYPRr=''
    else
      HKBUYr='100000000000'
      HNAMEBUYr='Неплатник'
      HORIG1r='1'
      HTYPRr='02'
    endif

    // HFBUY    ном филии
    HFBUYr=''

    sele trs2
    SUM sm to sm10r         // сумма без ндс

    s11r=round(sm10r/5, 2)// ндс
    s90r=sm10r+s11r         // сумма с ндс

    /* A */
    /* R04G11    I */
    R04G11r=alltrim(str(s90r, 12, 2))
    // R03G11   II
    R03G11r=alltrim(str(s11r, 12, 2))
    // R03G7   III
    R03G7r=alltrim(str(s11r, 12, 2))
    // R03G109  IV
    R03G109r=''
    // R01G7     V
    R01G7r=alltrim(str(sm10r, 12, 2))
    // R01G109  VI
    R01G109r=''
    // R01G9   VII
    R01G9r=''
    // R01G8  VIII
    R01G8r=''
    // R01G10   IX
    R01G10r=''
    // R02G11    X
    R02G11r=''
    // Б
    //              1 нпп
    // RXXXXG3S     2 номенкл
    // RXXXXG4      3 укт зед
    // RXXXXD4S     4 наим ед изм
    // RXXXXG32S    3.2 озн импорта
    // RXXXXG33S    3.3 код послуги
    // RXXXXG105_2S 5 код ед изм
    // RXXXXG5      6 к-во
    // RXXXXG6      7 цена
    // RXXXXG008    8 код ставки
    // RXXXXG009    9 код пильги
    // RXXXXG010   10 сумма(обсяг постач)

    sele nnds
    if (pr1ndsr=0)
      ifl_r='1819'+lzero(okpor, 10)+'j12'+iif(mnp=0, '010', '012')+'09'+'1'+'00'+lzero(nnds, 7)+'1'+lzero(month(dnn), 2)+str(year(dnn), 4)+'1819'
    else
      ifl_r='1819'+lzero(okpor, 10)+'j12'+iif(nnds1=0, '010', '012')+'09'+'1'+'00'+lzero(nnds, 7)+'1'+lzero(month(dnn), 2)+str(year(dnn), 4)+'1819'
    endif

    if (!empty(ifl_r))
#ifdef __CLIP__
        cCodePrint:= set("PRINTER_CHARSET", "cp1251")
        set prin to (PathNXmlr+ifl_r+'.xml')
#else
        set prin to (PathNXmlr+'n'+subs(ifl_r, 26, 7)+'.xml')
#endif
      set prin on
      set cons off
    endif

    // Шапка
    ??'<?xml version="1.0" encoding="windows-1251"?>'
    ?'<DECLAR xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="J1201009.xsd">'

    ?'<DECLARHEAD>'

    ?'<TIN>'+alltrim(str(okpor, 10))+'</TIN>'
    ?'<C_DOC>J12</C_DOC>'
    ?'<C_DOC_SUB>010</C_DOC_SUB>'
    ?'<C_DOC_VER>9</C_DOC_VER>'
    ?'<C_REG>18</C_REG>'
    ?'<C_RAJ>19</C_RAJ>'
    ?'<PERIOD_MONTH>'+PERIOD_MONTHr+'</PERIOD_MONTH>'
    ?'<PERIOD_TYPE>1</PERIOD_TYPE>'
    ?'<PERIOD_YEAR>'+PERIOD_YEARr+'</PERIOD_YEAR>'
    ?'<C_STI_ORIG>1819</C_STI_ORIG>'
    ?'<C_DOC_STAN>1</C_DOC_STAN>'
    ?'<LINKED_DOCS xsi:nil="true"></LINKED_DOCS>'
    ?'<D_FILL>'+D_FILLr+'</D_FILL>'
    ?'<SOFTWARE xsi:nil="true"></SOFTWARE>'

    ?'</DECLARHEAD>'

    ?'<DECLARBODY>'
    ?'<H03>'+H03r+'</H03>'
    ?'<H02>'+H02r+'</H02>'
    ?'<HORIG1>'+HORIG1r+'</HORIG1>'
    ?'<HTYPR>'+HTYPRr+'</HTYPR>'

    ?'<HFILL>'+HFILLr+'</HFILL>'
    ?'<HNUM>'+HNUMr+'</HNUM>'
    ?'<HNUM1>'+HNUM1r+'</HNUM1>'

    ?'<HNAMESEL>'+HNAMESELr+'</HNAMESEL>'
    ?'<HKSEL>'+HKSELr+'</HKSEL>'
    ?'<HNUM2>'+HNUM2r+'</HNUM2>'

    ?'<HNAMEBUY>'+HNAMEBUYr+'</HNAMEBUY>'
    ?'<HKBUY>'+HKBUYr+'</HKBUY>'
    ?'<HFBUY>'+HFBUYr+'</HFBUY>'

    ?'<R04G11>'+R04G11r+'</R04G11>'
    ?'<R03G11>'+R03G11r+'</R03G11>'
    ?'<R03G7>'+R03G7r+'</R03G7>'
    ?'<R03G109>'+R03G109r+'</R03G109>'
    ?'<R01G7>'+R01G7r+'</R01G7>'
    ?'<R01G109>'+R01G109r+'</R01G109>'
    ?'<R01G9>'+R01G9r+'</R01G9>'
    ?'<R01G8>'+R01G8r+'</R01G8>'
    ?'<R01G10>'+R01G10r+'</R01G10>'
    ?'<R02G11>'+R02G11r+'</R02G11>'
    for i=1 to 13
      sele trs2
      go top
      RowNumr=1
      do case
      case (i=1)          // Npp n()3
      case (i=2)          // nat c(60)
        while (!eof())
          natr:=DeleChrWd_AKZ(nat)
          ?'<RXXXXG3S ROWNUM="'+alltrim(str(RowNumr, 3))+'">' ;
           +XmlCharTran(natr)+'</RXXXXG3S>'
          RowNumr=RowNumr+1
          sele trs2; skip
        enddo

      case (i=3)          // ukt c(10)
        while (!eof())
          ?'<RXXXXG4 ROWNUM="'+alltrim(str(RowNumr, 3))+'">' ;
           +alltrim(ukt)+'</RXXXXG4>'
          RowNumr=RowNumr+1
          sele trs2; skip
        enddo

      case (i=4)          //     3.2 озн импорта
        OutXml_TxR('RXXXXG32S', 0)
      case (i=5)          //    3.3 код послуги
        OutXml_TxR('RXXXXG33S', 0)
      case (i=6)          // upu c(20)
        while (!eof())
          ?'<RXXXXG4S ROWNUM="'+alltrim(str(RowNumr, 3))+'">' ;
           +alltrim(upu)+'</RXXXXG4S>'
          RowNumr=RowNumr+1
          sele trs2; skip
        enddo

      case (i=7)          // kod n(4)
        while (!eof())
          ?'<RXXXXG105_2S ROWNUM="'+alltrim(str(RowNumr, 3))+'">'  ;
           +padl(alltrim(str(kod, 4)), 4, '0')+'</RXXXXG105_2S>'
          RowNumr=RowNumr+1
          sele trs2; skip
        enddo

      case (i=8)          // kol n(12,3)
        while (!eof())
          ?'<RXXXXG5 ROWNUM="'+alltrim(str(RowNumr, 3))+'">' ;
           +alltrim(str(kol, 12, 3))+'</RXXXXG5>'
          RowNumr=RowNumr+1
          sele trs2; skip
        enddo

      case (i=9)          // zen n(10,2)
        while (!eof())
          ?'<RXXXXG6 ROWNUM="'+alltrim(str(RowNumr, 3))+'">' ;
           +alltrim(str(zen, 10, 2))+'</RXXXXG6>'
          RowNumr=RowNumr+1
          sele trs2; skip
        enddo

      case (i=10)         // 20
        while (!eof())
          ?'<RXXXXG008 ROWNUM="'+alltrim(str(RowNumr, 3))+'">' ;
           +str(20, 2)+'</RXXXXG008>'
          RowNumr=RowNumr+1
          sele trs2; skip
        enddo

      case (i=11)         // ''
        while (!eof())
          ?'<RXXXXG009 ROWNUM="'+alltrim(str(RowNumr, 3))+'">' ;
           +R003G10Sr+'</RXXXXG009>'
          RowNumr=RowNumr+1
          sele trs2; skip
        enddo

      case (i=12)         // sm n(12,2)
        while (!eof())
          ?'<RXXXXG010 ROWNUM="'+alltrim(str(RowNumr, 3))+'">' ;
           +alltrim(str(sm, 12, 2))+'</RXXXXG010>'
          RowNumr=RowNumr+1
          sele trs2; skip
        enddo

      case (i=13)         // sm n(12,2)
        OutXml_TxR('RXXXXG011', 0)
      endcase

    next

    ?'<HBOS>'+HBOSr+'</HBOS>'
    ?'<HKBOS>'+HKBOSr+'</HKBOS>'

    ?'</DECLARBODY>'

    ?'</DECLAR>'

    /******************** */
    // J1201108 додаток1
    /******************** */

    // HPODFILL  дата
    // HPODNUM   пор ном
    // HPODNUM1

    //               1 нпп
    // RXXXXG3S      2 номенклат
    // RXXXXG4       3 укт зед
    // RXXXXG32S    3.2 озн импорта
    // RXXXXG33S    3.3 код послуги
    // RXXXXG4S      4 наим ед изм
    // RXXXXG105_2S  5 код ед изм
    // RXXXXG5       6 цена
    // RXXXXG6       7 к-во
    // RXXXXG7       8 сумма без ндс
    // RXXXXG9S      9 ед изм скоко поставлено
    // RXXXXGG10    10 к-во скоко поставлено
    // RXXXXG12S    11 ед изм скоко осталось поставить
    // RXXXXG13     12 к-во скоко осталось поставить
    // R01G7        13 сумма без ндс всего

  else
    /******************************************* */
    // J1201208 розрахунок коригування додаток2
    /******************************************* */
    R003G10Sr=''
    // HERPN0 пидл реестр пост
    HERPN0r=''
    // HERPN   пидл реестр отрим
    HERPNr=''
    // H03     до звед под накл
    H03r=''
    // H02     до пн звильн вид опер оподатк
    H02r=''
    // HORIG1  не пидл наданню отримувачу
    HORIG1r=''
    // HTYPR   причина
    HTYPRr=''

    // HFILL     дата розр
    HFILLr=subs(dtos(nnds->dnn), 7, 2)+subs(dtos(nnds->dnn), 5, 2)+subs(dtos(nnds->dnn), 1, 4)
    // HNUM   пор номер
    HNUMr=alltrim(str(nnds->nnds, 10))
    // HNUM1     код виду дияльн
    HNUM1r=''
    // HPODFILL  дата пнн
    HPODFILLr=subs(dtos(nnds->dnn1), 7, 2)+subs(dtos(nnds->dnn1), 5, 2)+subs(dtos(nnds->dnn1), 1, 4)
    // HPODNUM   ном пнн
    HPODNUMr=alltrim(str(nnds->nnds1, 10))
    // HPODNUM1  ном пнн1
    HPODNUM1r=''
    // HPODNUM2  ном пнн2
    HPODNUM2r=''

    // HNAMESEL наим продавця
    // HKSEL    инд подат номер
    sele kln
    netseek('t1', 'gnKkl_c')
    HNAMESELr=alltrim(nklprn)
    if (!empty(cnn))
      HKSELr=cnn
    else
      HKSELr=alltrim(str(nn, 12))
    endif

    // HNUM2    ном филии
    HNUM2r=''

    // HNAMEBUY наим покуп
    // HKBUY    инд подат номер
    sele kln
    netseek('t1', 'nnds->kkl')
    HNAMEBUYr=alltrim(nklprn)
    if (kln->nn#0)
      if (!empty(cnn))
        HKBUYr=cnn
      else
        HKBUYr=alltrim(str(nn, 12))
      endif

      HERPN0r=''
      HERPNr='1'
    else
      HKBUYr='100000000000'
      HNAMEBUYr='Неплатник'
      HORIG1r='1'
      HTYPRr='02'
      HERPN0r='1'
      HERPNr=''
    endif

    // HFBUY    ном филии
    HFBUYr=''

    sele tpr2
    SUM sm to sm10r         // сумма без ндс

    s11r=round(sm10r/5, 2)// ндс
    s90r=sm10r+s11r         // сумма с ндс

    /* A */
    /* R001G03     I сума корр */
    R001G03r=alltrim(str(s11r, 12, 2))
    // R02G9      II сума корр осн ставка
    R02G9r=alltrim(str(s11r, 12, 2))
    // R02G111   III сума корр  7
    R02G111r=''
    // R01G9      IV сума корр ставка 20
    R01G9r=alltrim(str(sm10r, 12, 2))
    // R01G111     V сума корр ставка  7
    R01G111r=''
    // R006G03    VI сума корр ставка 901
    R006G03r=''
    // R007G03   VII сума корр ставка 902
    R007G03r=''
    // R01G11   VIII сума корр ставка  903
    R01G11r=''

    // Б
    // RXXXXG001      1 номер рядка пнн що кориг
    // RXXXXG2S       2 причина кориг
    // RXXXXG3S       3 номенкл
    // RXXXXG4        4 укт зед
    // RXXXXG4S       5 наим ед изм
    // RXXXXG105_2S   6 код ед изм
    // RXXXXG5        7 изм к-ва
    // RXXXXG6        8 цена поставки
    // RXXXXG7        9 изм цены
    // RXXXXG8       10 к-во
    // RXXXXG008     11 код ставки
    // RXXXXG009     12 код пильги
    // RXXXXG010     13 сумма

    sele nnds
    ifl_r='1819'+lzero(okpor, 10);
    +'j1201209'+'1'+'00';
    +lzero(nnds, 7);
    +'1'+lzero(month(dnn), 2)+str(year(dnn), 4);
    +'1819'
    if (!empty(ifl_r))
#ifdef __CLIP__
        cCodePrint:= set("PRINTER_CHARSET", "cp1251")
        set prin to (PathNXmlr+ifl_r+'.xml')
#else
        set prin to (PathNXmlr+'n'+subs(ifl_r, 26, 7)+'.xml')
#endif
      set prin on
      set cons off
    endif

    //  Шапка
    ??'<?xml version="1.0" encoding="windows-1251"?>'
    ?'<DECLAR xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="J1201209.xsd">'

    ?'<DECLARHEAD>'

    ?'<TIN>'+alltrim(str(okpor, 10))+'</TIN>'
    ?'<C_DOC>J12</C_DOC>'
    ?'<C_DOC_SUB>012</C_DOC_SUB>'
    ?'<C_DOC_VER>9</C_DOC_VER>'
    ?'<C_REG>18</C_REG>'
    ?'<C_RAJ>19</C_RAJ>'
    ?'<PERIOD_MONTH>'+PERIOD_MONTHr+'</PERIOD_MONTH>'
    ?'<PERIOD_TYPE>1</PERIOD_TYPE>'
    ?'<PERIOD_YEAR>'+PERIOD_YEARr+'</PERIOD_YEAR>'
    ?'<C_STI_ORIG>1819</C_STI_ORIG>'
    ?'<C_DOC_STAN>1</C_DOC_STAN>'
    ?'<LINKED_DOCS xsi:nil="true"></LINKED_DOCS>'
    ?'<D_FILL>'+D_FILLr+'</D_FILL>'
    ?'<SOFTWARE xsi:nil="true"></SOFTWARE>'

    ?'</DECLARHEAD>'

    ?'<DECLARBODY>'
    ?'<HERPN0>'+HERPN0r+'</HERPN0>'
    ?'<HERPN>'+HERPNr+'</HERPN>'
    ?'<H03>'+H03r+'</H03>'
    ?'<H02>'+H02r+'</H02>'
    ?'<HORIG1>'+HORIG1r+'</HORIG1>'
    ?'<HTYPR>'+HTYPRr+'</HTYPR>'

    ?'<HFILL>'+HFILLr+'</HFILL>'
    ?'<HNUM>'+HNUMr+'</HNUM>'
    ?'<HNUM1>'+HNUM1r+'</HNUM1>'

    ?'<HPODFILL>'+HPODFILLr+'</HPODFILL>'
    ?'<HPODNUM>'+HPODNUMr+'</HPODNUM>'
    ?'<HPODNUM1>'+HPODNUM1r+'</HPODNUM1>'
    ?'<HPODNUM2>'+HPODNUM2r+'</HPODNUM2>'

    ?'<HNAMESEL>'+HNAMESELr+'</HNAMESEL>'
    ?'<HKSEL>'+HKSELr+'</HKSEL>'
    ?'<HNUM2>'+HNUM2r+'</HNUM2>'

    ?'<HNAMEBUY>'+HNAMEBUYr+'</HNAMEBUY>'
    ?'<HKBUY>'+HKBUYr+'</HKBUY>'
    ?'<HFBUY>'+HFBUYr+'</HFBUY>'

    ?'<R001G03>'+R001G03r+'</R001G03>'
    ?'<R02G9>'+R02G9r+'</R02G9>'
    ?'<R02G111>'+R02G111r+'</R02G111>'
    ?'<R01G9>'+R01G9r+'</R01G9>'
    ?'<R01G111>'+R01G111r+'</R01G111>'
    ?'<R006G03>'+R006G03r+'</R006G03>'
    ?'<R007G03>'+R007G03r+'</R007G03>'
    ?'<R01G11>'+R01G11r+'</R01G11>'
    for i=1 to 16
      RowNumr=1
      sele tpr2
      go top
      do case
      case (i=1)          // Npp n(3)
        while (!eof())
          ?'<RXXXXG001 ROWNUM="'+alltrim(str(RowNumr, 3))+'">' ;
           +alltrim(str(Npp, 3))+'</RXXXXG001>'
          RowNumr=RowNumr+1
          sele tpr2; skip
        enddo

      case (i=2)          // prich c(20)
        while (!eof())
          ?'<RXXXXG2S ROWNUM="'+alltrim(str(RowNumr, 3))+'">' ;
           +alltrim(prich)+'</RXXXXG2S>'
          RowNumr=RowNumr+1
          sele tpr2; skip
        enddo

      case (i=3)          // nat c(60)
        while (!eof())
          natr:=DeleChrWd_AKZ(nat)
          ?'<RXXXXG3S ROWNUM="'+alltrim(str(RowNumr, 3))+'">' ;
           +XmlCharTran(natr)+'</RXXXXG3S>'
          RowNumr=RowNumr+1
          sele tpr2; skip
        enddo

      case (i=4)          // ukt c(10)
        while (!eof())
          ?'<RXXXXG4 ROWNUM="'+alltrim(str(RowNumr, 3))+'">' ;
           +alltrim(ukt)+'</RXXXXG4>'
          RowNumr=RowNumr+1
          sele tpr2; skip
        enddo

      case (i=5)          //     3.2 озн импорта
        OutXml_TxR('RXXXXG32S', 0)
      case (i=6)          //    3.3 код послуги
        OutXml_TxR('RXXXXG33S', 0)
      case (i=7)          // upu c(20)
        while (!eof())
          ?'<RXXXXG4S ROWNUM="'+alltrim(str(RowNumr, 3))+'">' ;
           +alltrim(upu)+'</RXXXXG4S>'
          RowNumr=RowNumr+1
          sele tpr2; skip
        enddo

      case (i=8)          // kod n(4)
        while (!eof())
          ?'<RXXXXG105_2S ROWNUM="'+alltrim(str(RowNumr, 3))+'">'  ;
           +padl(alltrim(str(kod, 4)), 4, '0')+'</RXXXXG105_2S>'
          RowNumr=RowNumr+1
          sele tpr2; skip
        enddo

      case (i=9)          // kolc n(12,3)
        if (str(kopr,3) $ '108;107')
          while (!eof())
            ?'<RXXXXG5 ROWNUM="'+alltrim(str(RowNumr, 3))+'">' ;
             +alltrim(str(kolc, 12, 3))+'</RXXXXG5>'
            RowNumr=RowNumr+1
            sele tpr2; skip
          enddo

        else
          while (!eof())
            ?'<RXXXXG5 ROWNUM="'+alltrim(str(RowNumr, 3))+'"></RXXXXG5>'
            RowNumr=RowNumr+1
            sele tpr2; skip
          enddo

        endif

      case (i=10)
        if (str(kopr,3) $ '108;107')     // ozen n(10,2)
          while (!eof())
            ?'<RXXXXG6 ROWNUM="'+alltrim(str(RowNumr, 3))+'">' ;
             +alltrim(str(ozen, 10, 2))+'</RXXXXG6>'
            RowNumr=RowNumr+1
            sele tpr2; skip
          enddo

        else
          while (!eof())
            ?'<RXXXXG6 ROWNUM="'+alltrim(str(RowNumr, 3))+'"></RXXXXG6>'
            RowNumr=RowNumr+1
            sele tpr2; skip
          enddo

        endif

      case (i=11)         // izen n(10,2)
        if (kopr=110)
          while (!eof())
            ?'<RXXXXG7 ROWNUM="'+alltrim(str(RowNumr, 3))+'">' ;
             +alltrim(str(izen, 10, 2))+'</RXXXXG7>'
            RowNumr=RowNumr+1
            sele tpr2; skip
          enddo

        else
          while (!eof())
            ?'<RXXXXG7 ROWNUM="'+alltrim(str(RowNumr, 3))+'"></RXXXXG7>'
            RowNumr=RowNumr+1
            sele tpr2; skip
          enddo

        endif

      case (i=12)         // kol n(12,3)
        if (kopr=110)
          while (!eof())
            ?'<RXXXXG8 ROWNUM="'+alltrim(str(RowNumr, 3))+'">'+ ;
             alltrim(str(kol, 12, 3))+'</RXXXXG8>'
            RowNumr=RowNumr+1
            sele tpr2; skip
          enddo

        else
          while (!eof())
            ?'<RXXXXG8 ROWNUM="'+alltrim(str(RowNumr, 3))+'"></RXXXXG8>'
            RowNumr=RowNumr+1
            sele tpr2; skip
          enddo

        endif

      case (i=13)         // 20
        while (!eof())
          ?'<RXXXXG008 ROWNUM="'+alltrim(str(RowNumr, 3))+'">' ;
           +str(20, 2)+'</RXXXXG008>'
          RowNumr=RowNumr+1
          sele tpr2; skip
        enddo

      case (i=14)         // ''
        while (!eof())
          ?'<RXXXXG009 ROWNUM="'+alltrim(str(RowNumr, 3))+'">' ;
           +R003G10Sr+'</RXXXXG009>'
          RowNumr=RowNumr+1
          sele tpr2; skip
        enddo

      case (i=15)         // sm n(12,2)
        while (!eof())
          ?'<RXXXXG010 ROWNUM="'+alltrim(str(RowNumr, 3))+'">' ;
           +alltrim(str(sm, 12, 2))+'</RXXXXG010>'
          RowNumr=RowNumr+1
          sele tpr2; skip
        enddo

      case (i=16)
        OutXml_TxR('RXXXXG011', 0)
      endcase

    next

    ?'<HBOS>'+HBOSr+'</HBOS>'
    ?'<HKBOS>'+HKBOSr+'</HKBOS>'

    ?'</DECLARBODY>'

    ?'</DECLAR>'

  endif

case (nnds->dnn>=ctod('16.03.2016').and.date()>=ctod('01.04.2016'))//.or.gnAdm=1 // !!!! Убрать
                            //        if nnds->nnds1=0
  if (nnds->rn#0.and.nnds->mnp=0.or.nnds->rn=0.and.nnds->mnp=0.and.nnds->nnds1=0)// ПН
    /********************* */
                            // J1201008 податкова
    /********************* */
                            // R003G10S код пильги
    R003G10Sr=''

    // H03    звед пн
    H03r=''
    // H02    скл на опер зв в опод
    H02r=''

    // HORIG1 не пидл отр
    HORIG1r=''
    // HTYPR  тип прич
    HTYPRr=''
    // HFILL  дата
    HFILLr=subs(dtos(nnds->dnn), 7, 2)+subs(dtos(nnds->dnn), 5, 2)+subs(dtos(nnds->dnn), 1, 4)
    // HNUM   пор номер
    HNUMr=alltrim(str(nnds->nnds, 10))
    // HNUM1  код виду дияльн
    HNUM1r=''
    // HNAMESEL наим продавця
    // HKSEL    инд подат номер
    sele kln
    netseek('t1', 'gnKkl_c')
    HNAMESELr=alltrim(nklprn)
    if (!empty(cnn))
      HKSELr=cnn
    else
      HKSELr=alltrim(str(nn, 12))
    endif

    // HNUM2    ном филии
    HNUM2r=''
    // HNAMEBUY наим покуп
    // HKBUY    инд подат номер
    sele kln
    netseek('t1', 'nnds->kkl')
    HNAMEBUYr=alltrim(nklprn)
    if (kln->nn#0)
      if (!empty(cnn))
        HKBUYr=cnn
      else
        HKBUYr=alltrim(str(nn, 12))
      endif

      HORIG1r=''
      HTYPRr=''
    else
      HKBUYr='100000000000'
      HNAMEBUYr='Неплатник'
      HORIG1r='1'
      HTYPRr='02'
    endif

    // HFBUY    ном филии
    HFBUYr=''

    sele trs2
    SUM sm to sm10r         // сумма без ндс

    s11r=round(sm10r/5, 2)// ндс
    s90r=sm10r+s11r         // сумма с ндс

    /* A */
    /* R04G11    I */
    R04G11r=alltrim(str(s90r, 12, 2))
    // R03G11   II
    R03G11r=alltrim(str(s11r, 12, 2))
    // R03G7   III
    R03G7r=alltrim(str(s11r, 12, 2))
    // R03G109  IV
    R03G109r=''
    // R01G7     V
    R01G7r=alltrim(str(sm10r, 12, 2))
    // R01G109  VI
    R01G109r=''
    // R01G9   VII
    R01G9r=''
    // R01G8  VIII
    R01G8r=''
    // R01G10   IX
    R01G10r=''
    // R02G11    X
    R02G11r=''
    // Б
    //              1 нпп
    // RXXXXG3S     2 номенкл
    // RXXXXG4      3 укт зед
    // RXXXXD4S     4 наим ед изм
    // RXXXXG105_2S 5 код ед изм
    // RXXXXG5      6 к-во
    // RXXXXG6      7 цена
    // RXXXXG008    8 код ставки
    // RXXXXG009    9 код пильги
    // RXXXXG010   10 сумма(обсяг постач)

    sele nnds
    if (pr1ndsr=0)
      ifl_r='1819'+lzero(okpor, 10)+'j12'+iif(mnp=0, '010', '012')+'08'+'1'+'00'+lzero(nnds, 7)+'1'+lzero(month(dnn), 2)+str(year(dnn), 4)+'1819'
    else
      ifl_r='1819'+lzero(okpor, 10)+'j12'+iif(nnds1=0, '010', '012')+'08'+'1'+'00'+lzero(nnds, 7)+'1'+lzero(month(dnn), 2)+str(year(dnn), 4)+'1819'
    endif

    if (!empty(ifl_r))
#ifdef __CLIP__
        cCodePrint:= set("PRINTER_CHARSET", "cp1251")
        set prin to (PathNXmlr+ifl_r+'.xml')
#else
        set prin to (PathNXmlr+'n'+subs(ifl_r, 26, 7)+'.xml')
#endif
      set prin on
      set cons off
    endif

    // Шапка
    ??'<?xml version="1.0" encoding="windows-1251"?>'
    ?'<DECLAR xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="J1201008.xsd">'

    ?'<DECLARHEAD>'

    ?'<TIN>'+alltrim(str(okpor, 10))+'</TIN>'
    ?'<C_DOC>J12</C_DOC>'
    ?'<C_DOC_SUB>010</C_DOC_SUB>'
    ?'<C_DOC_VER>8</C_DOC_VER>'
    ?'<C_REG>18</C_REG>'
    ?'<C_RAJ>19</C_RAJ>'
    ?'<PERIOD_MONTH>'+PERIOD_MONTHr+'</PERIOD_MONTH>'
    ?'<PERIOD_TYPE>1</PERIOD_TYPE>'
    ?'<PERIOD_YEAR>'+PERIOD_YEARr+'</PERIOD_YEAR>'
    ?'<C_STI_ORIG>1819</C_STI_ORIG>'
    ?'<C_DOC_STAN>1</C_DOC_STAN>'
    ?'<LINKED_DOCS xsi:nil="true"></LINKED_DOCS>'
    ?'<D_FILL>'+D_FILLr+'</D_FILL>'
    ?'<SOFTWARE xsi:nil="true"></SOFTWARE>'

    ?'</DECLARHEAD>'

    ?'<DECLARBODY>'
    ?'<H03>'+H03r+'</H03>'
    ?'<H02>'+H02r+'</H02>'
    ?'<HORIG1>'+HORIG1r+'</HORIG1>'
    ?'<HTYPR>'+HTYPRr+'</HTYPR>'

    ?'<HFILL>'+HFILLr+'</HFILL>'
    ?'<HNUM>'+HNUMr+'</HNUM>'
    ?'<HNUM1>'+HNUM1r+'</HNUM1>'

    ?'<HNAMESEL>'+HNAMESELr+'</HNAMESEL>'
    ?'<HKSEL>'+HKSELr+'</HKSEL>'
    ?'<HNUM2>'+HNUM2r+'</HNUM2>'

    ?'<HNAMEBUY>'+HNAMEBUYr+'</HNAMEBUY>'
    ?'<HKBUY>'+HKBUYr+'</HKBUY>'
    ?'<HFBUY>'+HFBUYr+'</HFBUY>'

    ?'<R04G11>'+R04G11r+'</R04G11>'
    ?'<R03G11>'+R03G11r+'</R03G11>'
    ?'<R03G7>'+R03G7r+'</R03G7>'
    ?'<R03G109>'+R03G109r+'</R03G109>'
    ?'<R01G7>'+R01G7r+'</R01G7>'
    ?'<R01G109>'+R01G109r+'</R01G109>'
    ?'<R01G9>'+R01G9r+'</R01G9>'
    ?'<R01G8>'+R01G8r+'</R01G8>'
    ?'<R01G10>'+R01G10r+'</R01G10>'
    ?'<R02G11>'+R02G11r+'</R02G11>'
    for i=1 to 10
      do case
      case (i=1)          // Npp n()3
      case (i=2)          // nat c(60)
        sele trs2
        go top
        RowNumr=1
        while (!eof())
          natr:=DeleChrWd_AKZ(nat)
          ?'<RXXXXG3S ROWNUM="'+alltrim(str(RowNumr, 3))+'">';
          +XmlCharTran(natr)+'</RXXXXG3S>'
          RowNumr=RowNumr+1
          sele trs2
          skip
        enddo

      case (i=3)          // ukt c(10)
        sele trs2
        go top
        RowNumr=1
        while (!eof())
          ?'<RXXXXG4 ROWNUM="'+alltrim(str(RowNumr, 3))+'">'+alltrim(ukt)+'</RXXXXG4>'
          RowNumr=RowNumr+1
          sele trs2
          skip
        enddo

      case (i=4)          // upu c(20)
        sele trs2
        go top
        RowNumr=1
        while (!eof())
          ?'<RXXXXG4S ROWNUM="'+alltrim(str(RowNumr, 3))+'">'+alltrim(upu)+'</RXXXXG4S>'
          RowNumr=RowNumr+1
          sele trs2
          skip
        enddo

      case (i=5)          // kod n(4)
        sele trs2
        go top
        RowNumr=1
        while (!eof())
          ?'<RXXXXG105_2S ROWNUM="'+alltrim(str(RowNumr, 3))+'">'+padl(alltrim(str(kod, 4)), 4, '0')+'</RXXXXG105_2S>'
          RowNumr=RowNumr+1
          sele trs2
          skip
        enddo

      case (i=6)          // kol n(12,3)
        sele trs2
        go top
        RowNumr=1
        while (!eof())
          ?'<RXXXXG5 ROWNUM="'+alltrim(str(RowNumr, 3))+'">'+alltrim(str(kol, 12, 3))+'</RXXXXG5>'
          RowNumr=RowNumr+1
          sele trs2
          skip
        enddo

      case (i=7)          // zen n(10,2)
        sele trs2
        go top
        RowNumr=1
        while (!eof())
          ?'<RXXXXG6 ROWNUM="'+alltrim(str(RowNumr, 3))+'">'+alltrim(str(zen, 10, 2))+'</RXXXXG6>'
          RowNumr=RowNumr+1
          sele trs2
          skip
        enddo

      case (i=8)          // 20
        sele trs2
        go top
        RowNumr=1
        while (!eof())
          ?'<RXXXXG008 ROWNUM="'+alltrim(str(RowNumr, 3))+'">'+str(20, 2)+'</RXXXXG008>'
          RowNumr=RowNumr+1
          sele trs2
          skip
        enddo

      case (i=9)          // ''
        sele trs2
        go top
        RowNumr=1
        while (!eof())
          ?'<RXXXXG009 ROWNUM="'+alltrim(str(RowNumr, 3))+'">'+R003G10Sr+'</RXXXXG009>'
          RowNumr=RowNumr+1
          sele trs2
          skip
        enddo

      case (i=10)         // sm n(12,2)
        sele trs2
        go top
        RowNumr=1
        while (!eof())
          ?'<RXXXXG010 ROWNUM="'+alltrim(str(RowNumr, 3))+'">'+alltrim(str(sm, 12, 2))+'</RXXXXG010>'
          RowNumr=RowNumr+1
          sele trs2
          skip
        enddo

      endcase

    next

    ?'<HBOS>'+HBOSr+'</HBOS>'
    ?'<HKBOS>'+HKBOSr+'</HKBOS>'

    ?'</DECLARBODY>'

    ?'</DECLAR>'

    /******************** */
    // J1201108 додаток1
    /******************** */

    // HPODFILL  дата
    // HPODNUM   пор ном
    // HPODNUM1

    //               1 нпп
    // RXXXXG3S      2 номенклат
    // RXXXXG4       3 укт зед
    // RXXXXG4S      4 наим ед изм
    // RXXXXG105_2S  5 код ед изм
    // RXXXXG5       6 цена
    // RXXXXG6       7 к-во
    // RXXXXG7       8 сумма без ндс
    // RXXXXG9S      9 ед изм скоко поставлено
    // RXXXXGG10    10 к-во скоко поставлено
    // RXXXXG12S    11 ед изм скоко осталось поставить
    // RXXXXG13     12 к-во скоко осталось поставить
    // R01G7        13 сумма без ндс всего

  else
    /******************************************* */
    // J1201208 розрахунок коригування додаток2
    /******************************************* */
    R003G10Sr=''
    // HERPN0 пидл реестр пост
    HERPN0r=''
    // HERPN   пидл реестр отрим
    HERPNr=''
    // H03     до звед под накл
    H03r=''
    // H02     до пн звильн вид опер оподатк
    H02r=''
    // HORIG1  не пидл наданню отримувачу
    HORIG1r=''
    // HTYPR   причина
    HTYPRr=''

    // HFILL     дата розр
    HFILLr=subs(dtos(nnds->dnn), 7, 2)+subs(dtos(nnds->dnn), 5, 2)+subs(dtos(nnds->dnn), 1, 4)
    // HNUM   пор номер
    HNUMr=alltrim(str(nnds->nnds, 10))
    // HNUM1     код виду дияльн
    HNUM1r=''
    // HPODFILL  дата пнн
    HPODFILLr=subs(dtos(nnds->dnn1), 7, 2)+subs(dtos(nnds->dnn1), 5, 2)+subs(dtos(nnds->dnn1), 1, 4)
    // HPODNUM   ном пнн
    HPODNUMr=alltrim(str(nnds->nnds1, 10))
    // HPODNUM1  ном пнн1
    HPODNUM1r=''
    // HPODNUM2  ном пнн2
    HPODNUM2r=''

    // HNAMESEL наим продавця
    // HKSEL    инд подат номер
    sele kln
    netseek('t1', 'gnKkl_c')
    HNAMESELr=alltrim(nklprn)
    if (!empty(cnn))
      HKSELr=cnn
    else
      HKSELr=alltrim(str(nn, 12))
    endif

    // HNUM2    ном филии
    HNUM2r=''

    // HNAMEBUY наим покуп
    // HKBUY    инд подат номер
    sele kln
    netseek('t1', 'nnds->kkl')
    HNAMEBUYr=alltrim(nklprn)
    if (kln->nn#0)
      if (!empty(cnn))
        HKBUYr=cnn
      else
        HKBUYr=alltrim(str(nn, 12))
      endif

      HERPN0r=''
      HERPNr='1'
    else
      HKBUYr='100000000000'
      HNAMEBUYr='Неплатник'
      HORIG1r='1'
      HTYPRr='02'
      HERPN0r='1'
      HERPNr=''
    endif

    // HFBUY    ном филии
    HFBUYr=''

    sele tpr2
    SUM sm to sm10r         // сумма без ндс

    s11r=round(sm10r/5, 2)// ндс
    s90r=sm10r+s11r         // сумма с ндс

    /* A */
    /* R001G03     I сума корр */
    R001G03r=alltrim(str(s11r, 12, 2))
    // R02G9      II сума корр осн ставка
    R02G9r=alltrim(str(s11r, 12, 2))
    // R02G111   III сума корр  7
    R02G111r=''
    // R01G9      IV сума корр ставка 20
    R01G9r=alltrim(str(sm10r, 12, 2))
    // R01G111     V сума корр ставка  7
    R01G111r=''
    // R006G03    VI сума корр ставка 901
    R006G03r=''
    // R007G03   VII сума корр ставка 902
    R007G03r=''
    // R01G11   VIII сума корр ставка  903
    R01G11r=''

    // Б
    // RXXXXG001      1 номер рядка пнн що кориг
    // RXXXXG2S       2 причина кориг
    // RXXXXG3S       3 номенкл
    // RXXXXG4        4 укт зед
    // RXXXXG4S       5 наим ед изм
    // RXXXXG105_2S   6 код ед изм
    // RXXXXG5        7 изм к-ва
    // RXXXXG6        8 цена поставки
    // RXXXXG7        9 изм цены
    // RXXXXG8       10 к-во
    // RXXXXG008     11 код ставки
    // RXXXXG009     12 код пильги
    // RXXXXG010     13 сумма

    sele nnds
    ifl_r='1819'+lzero(okpor, 10)+'j1201208'+'1'+'00'+lzero(nnds, 7)+'1'+lzero(month(dnn), 2)+str(year(dnn), 4)+'1819'
    if (!empty(ifl_r))
#ifdef __CLIP__
        cCodePrint:= set("PRINTER_CHARSET", "cp1251")
        set prin to (PathNXmlr+ifl_r+'.xml')
#else
        set prin to (PathNXmlr+'n'+subs(ifl_r, 26, 7)+'.xml')
#endif
      set prin on
      set cons off
    endif

    //  Шапка
    ??'<?xml version="1.0" encoding="windows-1251"?>'
    ?'<DECLAR xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="J1201208.xsd">'

    ?'<DECLARHEAD>'

    ?'<TIN>'+alltrim(str(okpor, 10))+'</TIN>'
    ?'<C_DOC>J12</C_DOC>'
    ?'<C_DOC_SUB>012</C_DOC_SUB>'
    ?'<C_DOC_VER>8</C_DOC_VER>'
    ?'<C_REG>18</C_REG>'
    ?'<C_RAJ>19</C_RAJ>'
    ?'<PERIOD_MONTH>'+PERIOD_MONTHr+'</PERIOD_MONTH>'
    ?'<PERIOD_TYPE>1</PERIOD_TYPE>'
    ?'<PERIOD_YEAR>'+PERIOD_YEARr+'</PERIOD_YEAR>'
    ?'<C_STI_ORIG>1819</C_STI_ORIG>'
    ?'<C_DOC_STAN>1</C_DOC_STAN>'
    ?'<LINKED_DOCS xsi:nil="true"></LINKED_DOCS>'
    ?'<D_FILL>'+D_FILLr+'</D_FILL>'
    ?'<SOFTWARE xsi:nil="true"></SOFTWARE>'

    ?'</DECLARHEAD>'

    ?'<DECLARBODY>'
    ?'<HERPN0>'+HERPN0r+'</HERPN0>'
    ?'<HERPN>'+HERPNr+'</HERPN>'
    ?'<H03>'+H03r+'</H03>'
    ?'<H02>'+H02r+'</H02>'
    ?'<HORIG1>'+HORIG1r+'</HORIG1>'
    ?'<HTYPR>'+HTYPRr+'</HTYPR>'

    ?'<HFILL>'+HFILLr+'</HFILL>'
    ?'<HNUM>'+HNUMr+'</HNUM>'
    ?'<HNUM1>'+HNUM1r+'</HNUM1>'

    ?'<HPODFILL>'+HPODFILLr+'</HPODFILL>'
    ?'<HPODNUM>'+HPODNUMr+'</HPODNUM>'
    ?'<HPODNUM1>'+HPODNUM1r+'</HPODNUM1>'
    ?'<HPODNUM2>'+HPODNUM2r+'</HPODNUM2>'

    ?'<HNAMESEL>'+HNAMESELr+'</HNAMESEL>'
    ?'<HKSEL>'+HKSELr+'</HKSEL>'
    ?'<HNUM2>'+HNUM2r+'</HNUM2>'

    ?'<HNAMEBUY>'+HNAMEBUYr+'</HNAMEBUY>'
    ?'<HKBUY>'+HKBUYr+'</HKBUY>'
    ?'<HFBUY>'+HFBUYr+'</HFBUY>'

    ?'<R001G03>'+R001G03r+'</R001G03>'
    ?'<R02G9>'+R02G9r+'</R02G9>'
    ?'<R02G111>'+R02G111r+'</R02G111>'
    ?'<R01G9>'+R01G9r+'</R01G9>'
    ?'<R01G111>'+R01G111r+'</R01G111>'
    ?'<R006G03>'+R006G03r+'</R006G03>'
    ?'<R007G03>'+R007G03r+'</R007G03>'
    ?'<R01G11>'+R01G11r+'</R01G11>'
    for i=1 to 13
      do case
      case (i=1)          // Npp n(3)
        RowNumr=1
        sele tpr2
        go top
        while (!eof())
          ?'<RXXXXG001 ROWNUM="'+alltrim(str(RowNumr, 3))+'">'+alltrim(str(Npp, 3))+'</RXXXXG001>'
          RowNumr=RowNumr+1
          sele tpr2
          skip
        enddo

      case (i=2)          // prich c(20)
        RowNumr=1
        sele tpr2
        go top
        while (!eof())
          ?'<RXXXXG2S ROWNUM="'+alltrim(str(RowNumr, 3))+'">'+alltrim(prich)+'</RXXXXG2S>'
          RowNumr=RowNumr+1
          sele tpr2
          skip
        enddo

      case (i=3)          // nat c(60)
        RowNumr=1
        sele tpr2
        go top
        while (!eof())
          natr:=DeleChrWd_AKZ(nat)
          ?'<RXXXXG3S ROWNUM="'+alltrim(str(RowNumr, 3))+'">';
          +XmlCharTran(natr)+'</RXXXXG3S>'
          RowNumr=RowNumr+1
          sele tpr2
          skip
        enddo

      case (i=4)          // ukt c(10)
        RowNumr=1
        sele tpr2
        go top
        while (!eof())
          ?'<RXXXXG4 ROWNUM="'+alltrim(str(RowNumr, 3))+'">'+alltrim(ukt)+'</RXXXXG4>'
          RowNumr=RowNumr+1
          sele tpr2
          skip
        enddo

      case (i=5)          // upu c(20)
        RowNumr=1
        sele tpr2
        go top
        while (!eof())
          ?'<RXXXXG4S ROWNUM="'+alltrim(str(RowNumr, 3))+'">'+alltrim(upu)+'</RXXXXG4S>'
          RowNumr=RowNumr+1
          sele tpr2
          skip
        enddo

      case (i=6)          // kod n(4)
        RowNumr=1
        sele tpr2
        go top
        while (!eof())
          ?'<RXXXXG105_2S ROWNUM="'+alltrim(str(RowNumr, 3))+'">'+padl(alltrim(str(kod, 4)), 4, '0')+'</RXXXXG105_2S>'
          RowNumr=RowNumr+1
          sele tpr2
          skip
        enddo

      case (i=7)          // kolc n(12,3)
        RowNumr=1
        if (str(kopr,3) $ '108;107')
          sele tpr2
          go top
          while (!eof())
            ?'<RXXXXG5 ROWNUM="'+alltrim(str(RowNumr, 3))+'">'+alltrim(str(kolc, 12, 3))+'</RXXXXG5>'
            RowNumr=RowNumr+1
            sele tpr2
            skip
          enddo

        else
          sele tpr2
          go top
          while (!eof())
            ?'<RXXXXG5 ROWNUM="'+alltrim(str(RowNumr, 3))+'"></RXXXXG5>'
            RowNumr=RowNumr+1
            sele tpr2
            skip
          enddo

        endif

      case (i=8)
        RowNumr=1
        if (str(kopr,3) $ '108;107')     // ozen n(10,2)
          sele tpr2
          go top
          while (!eof())
            ?'<RXXXXG6 ROWNUM="'+alltrim(str(RowNumr, 3))+'">'+alltrim(str(ozen, 10, 2))+'</RXXXXG6>'
            RowNumr=RowNumr+1
            sele tpr2
            skip
          enddo

        else
          sele tpr2
          go top
          while (!eof())
            ?'<RXXXXG6 ROWNUM="'+alltrim(str(RowNumr, 3))+'"></RXXXXG6>'
            RowNumr=RowNumr+1
            sele tpr2
            skip
          enddo

        endif

      case (i=9)          // izen n(10,2)
        RowNumr=1
        if (kopr=110)
          sele tpr2
          go top
          while (!eof())
            ?'<RXXXXG7 ROWNUM="'+alltrim(str(RowNumr, 3))+'">'+alltrim(str(izen, 10, 2))+'</RXXXXG7>'
            RowNumr=RowNumr+1
            sele tpr2
            skip
          enddo

        else
          sele tpr2
          go top
          while (!eof())
            ?'<RXXXXG7 ROWNUM="'+alltrim(str(RowNumr, 3))+'"></RXXXXG7>'
            RowNumr=RowNumr+1
            sele tpr2
            skip
          enddo

        endif

      case (i=10)         // kol n(12,3)
        RowNumr=1
        if (kopr=110)
          sele tpr2
          go top
          while (!eof())
            ?'<RXXXXG8 ROWNUM="'+alltrim(str(RowNumr, 3))+'">'+alltrim(str(kol, 12, 3))+'</RXXXXG8>'
            RowNumr=RowNumr+1
            sele tpr2
            skip
          enddo

        else
          sele tpr2
          go top
          while (!eof())
            ?'<RXXXXG8 ROWNUM="'+alltrim(str(RowNumr, 3))+'"></RXXXXG8>'
            RowNumr=RowNumr+1
            sele tpr2
            skip
          enddo

        endif

      case (i=11)         // 20
        RowNumr=1
        sele tpr2
        go top
        while (!eof())
          ?'<RXXXXG008 ROWNUM="'+alltrim(str(RowNumr, 3))+'">'+str(20, 2)+'</RXXXXG008>'
          RowNumr=RowNumr+1
          sele tpr2
          skip
        enddo

      case (i=12)         // ''
        RowNumr=1
        sele tpr2
        go top
        while (!eof())
          ?'<RXXXXG009 ROWNUM="'+alltrim(str(RowNumr, 3))+'">'+R003G10Sr+'</RXXXXG009>'
          RowNumr=RowNumr+1
          sele tpr2
          skip
        enddo

      case (i=13)         // sm n(12,2)
        RowNumr=1
        sele tpr2
        go top
        while (!eof())
          ?'<RXXXXG010 ROWNUM="'+alltrim(str(RowNumr, 3))+'">'+alltrim(str(sm, 12, 2))+'</RXXXXG010>'
          RowNumr=RowNumr+1
          sele tpr2
          skip
        enddo

      endcase

    next

    ?'<HBOS>'+HBOSr+'</HBOS>'
    ?'<HKBOS>'+HKBOSr+'</HKBOS>'

    ?'</DECLARBODY>'

    ?'</DECLAR>'

  endif

endcase

nuse('trs2')
nuse('tpr2')

#ifdef __CLIP__
  set("PRINTER_CHARSET", cCodePrint)
#endif
set prin off
set prin to
set cons on

PathNXmlr+ifl_r+'.xml'

sele nnds
#ifdef __CLIP__
  if (file(PathNXmlr+ifl_r+'.xml'))

    // cMemReadFile:=MemoRead(PathNXmlr+ifl_r+'.xml')
    // CharRepl(chr(129),@cMemReadFile,chr(179))
    // MemoWrit(PathNXmlr+ifl_r+'.xml',cMemReadFile)

    // перекодировка укр-i из СР866 -> СР1251
    MemoWrit(PathNXmlr+ifl_r+'.xml',;
      CharRepl(;
                chr(129),;
                MemoRead(PathNXmlr+ifl_r+'.xml'),;
                chr(179));
              )


    sele nnds
    if (fieldpos('ifl')#0)
      netrepl('ifl', 'ifl_r')
    endif

    if (fieldpos('difl')#0)
      difl_r=date()
      tifl_r=time()
      netrepl('difl,tifl', 'difl_r,tifl_r')
    endif

    if (fieldpos('kto')#0)
      if (gnEnt=20)
        netrepl('kto', '882')
      endif

      if (gnEnt=21)
        netrepl('kto', '331')
      endif

    endif

  else
    ifl_rr=''
    sele nnds
    if (fieldpos('ifl')#0)
      netrepl('ifl', 'ifl_rr')
    endif

    if (fieldpos('difl')#0)
      difl_r=ctod('')
      tifl_r=space(8)
      netrepl('difl,tifl', 'difl_r,tifl_r')
    endif

    if (fieldpos('kto')#0)
      netrepl('kto', '0')
    endif

  endif

#else
  if (file(PathNXmlr+'n'+subs(ifl_r, 26, 7)+'.xml'))
    sele nnds
    if (fieldpos('ifl')#0)
      netrepl('ifl', 'ifl_r')
    endif

    if (fieldpos('difl')#0)
      difl_r=date()
      tifl_r=time()
      netrepl('difl,tifl', 'difl_r,tifl_r')
    endif

    if (gnEnt=20)
      netrepl('kto', '882')
    endif

    if (gnEnt=21)
      netrepl('kto', '331')
    endif

  else
    ifl_rr=''
    sele nnds
    if (fieldpos('ifl')#0)
      netrepl('ifl', 'ifl_rr')
    endif

    if (fieldpos('difl')#0)
      difl_r=ctod('')
      tifl_r=space(8)
      netrepl('difl,tifl', 'difl_r,tifl_r')
    endif

    if (fieldpos('kto')#0)
      netrepl('kto', '0')
    endif

  endif

#endif
/*****************************************************************
 
 FUNCTION:
 АВТОР..ДАТА..........С. Литовка  11-22-18 * 01:27:27pm
 НАЗНАЧЕНИЕ......... если есть слово 'АКЦ', то удалеем
                   c позиции "N" до первого пробела
 ПАРАМЕТРЫ..........
 ВОЗВР. ЗНАЧЕНИЕ....
 ПРИМЕЧАНИЯ.........
 */
STATIC FUNCTION DeleChrWd_AKZ(cNat)
  LOCAL nPos, natr
  Natr:=CHARONE(' ',cNat)

  If UPPER('АКЦ') $ UPPER(cNat)
    nPos:=AT('N',cNat)
    natr:=LEFT(cNat,nPos-1) // до Номера

    cNat:=SUBSTR(cNat,nPos) // остаток с учетом номера

    nPos := 1
    If substr(cNat,2,1)=' ' // провека на Пробем после номера
      nPos += 2
    EndIf

    cNat:=SUBSTR(cNat,nPos) //

    nPos:=AT(' ',cNat) // поиск первого пробела
    natr+=SUBSTR(cNat,nPos+1)

  EndIf
  RETURN (natr)


/*****************************************************************
 
 FUNCTION:
 АВТОР..ДАТА..........С. Литовка  02-10-20 * 02:45:00pm
 НАЗНАЧЕНИЕ.........
 ПАРАМЕТРЫ..........
 ВОЗВР. ЗНАЧЕНИЕ....
 ПРИМЕЧАНИЯ.........
 */
STATIC FUNCTION natr(natr, dvpr)
  If gnEnt = 20
    If "/NatCros" $ DOSPARAM() .or. dvpr >= STOD("20200701")
      MnTovr=_FIELD->mntov
      MnTovTr:=getfield('t1','MnTovr','ctov','MnTovT')
      mkcrosr:=getfield('t1','MnTovTr','ctov','mkcros')
      If !Empty(mkcrosr)
        natr:=getfield('t1','mkcrosr','mkcros','NmKId')
      EndIf
    Else
      //
    EndIf
  Else
    //
  EndIf

  RETURN (allt(Upper(natr)))
