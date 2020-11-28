/***********************************************************
 * Модуль    : protv.prg
 * Версия    : 0.0
 * Автор     :
 * Дата      : 08/09/17
 * Изменен   :
 * Примечание: Текст обработан утилитой CF версии 2.02
 */

#include "common.ch"
#include "inkey.ch"

/************** */
function PrvOtv()
  /************** */
  //if gnArm#0.and.pozicion=6
  //   clea
  //   aqstr=1
  //   aqst:={"Просмотр","Коррекция"}
  //   aqstr:=alert(" ",aqst)
  //   if lastkey()=K_ESC
  //      retu
  //   endif
  //else
  //   aqstr=2
  //endif
  set prin to crotvv.txt
  set prin on
  pathr=path_tr
  netuse('pr1',,, 1)
  locate for otv=1
  if (!foun())
    nuse('pr1')
    wmess('Этот склад не имеет ответхранения', 1)
    return (.t.)
  endif

  netuse('cskl')
  pathr=path_tr
  netuse('tov',,, 1)
  netuse('tovm',,, 1)
  netuse('rs1',,, 1)
  netuse('rs2',,, 1)
  netuse('pr1',,, 1)
  netuse('pr2',,, 1)
  //dtr=bom(gdTd)-1
  //mmr=month(dtr)
  //yyr=year(dtr)
  //pathpr=gcPath_e+'g'+str(yyr,4)+'\m'+iif(mmr<10,'0'+str(mmr,1),str(mmr,2))+'\'+gcDir_t
  ?__FILE__,__LINE__,'qkps.'

  filedelete('qkps.*')
  crtt('qkps', 'f:mn c:n(6) f:kps c:n(7) f:skl c:n(7)')
  sele 0
  use qkps

  // Доки Прихода для ОтвХр otv=1
  sele pr1
  while (!eof())
    if (otv#1)
      skip
      loop
    endif

    mnr=mn
    kpsr=kps
    sklr=skl
    sele qkps
    appe blank
    netrepl('mn,kps,skl', 'mnr,kpsr,sklr')
    sele pr1
    skip
  enddo

  sele qkps
  go top
  while (!eof())
    kpsr=kps
    mnr=mn
    sklr=skl
    sele pr1
    locate for kps=kpsr.and.otv=1
    SkSpr=SkSp
    //     pathr=pathpr
    pathr=path_pr
    ?__FILE__,__LINE__,'pathr',pathr
    if (select('totchp')#0)
      sele totchp
      CLOSE
    endif

    if (netfile('tov', 1))
      netuse('pr1', 'pr1p',, 1)
      netuse('pr2', 'pr2p',, 1)
      netuse('tov', 'tovp',, 1)
      // Остаток на конец месяца
      if (select('tOstP')#0)
        sele tOstP
        CLOSE
      endif

      filedelete('tOstP.*')
      crtt('tOstP', 'f:ktl c:n(9) f:kfo c:n(12,3)')
      sele 0
      use tOstP
      sele pr2p
      if (netseek('t1', 'mnr'))
        while (mn=mnr)
          ktlr=ktl
          kfor=kfo
          sele tOstP
          appe blank
          netrepl('ktl,kfo', 'ktlr,kfor')
              If ktl=507277354
                ?__FILE__,__LINE__,'ktlr,kfor',ktlr,kfor
              EndIf

          if (kfor#0)
            sele pr2
            if (!netseek('t1', 'mnr,ktlr'))
              ?str(mnr, 6)+' '+str(ktlr, 9)+' нет в текущем'
              if (aqstr=2)
                sele pr2p
                arec:={}
                getrec()
                sele pr2
                netadd()
                putrec()
              endif

            endif

          endif

          //              endif
          sele pr2p
          skip
        enddo

      endif

      sele tovp
      go top
      while (!eof())
        if (otv#1)
          skip
          loop
        endif

        sklr=skl
        ktlr=ktl
        osvor=osvo
        sele tOstP
        locate for ktl=ktlr
        if (!foun())
          if (osvor#0)
            sele tov
            if (!netseek('t1', 'sklr,ktlr'))
              ?str(sklr, 7)+' '+str(ktlr, 9)+' нет в текущем'
              if (aqstr=2)
                sele tovp
                arec:={}
                getrec()
                sele tov
                netadd()
                putrec()
              endif

            endif

          endif

        endif

        sele tovp
        skip
      enddo

      ?'Коррекция KfN текущего'
      sele tOstP
      go top
      while (!eof())
        arec:={}
        getrec()
        ktlr=ktl
        KfNr=kfo
        sele pr2
        if (netseek('t1', 'mnr,ktlr'))
          if (KfN#KfNr)
            ?__FILE__,__LINE__,str(mnr, 6)+' '+str(ktlr, 9)+' Тек '+str(KfN, 12, 3)+' Расч '+str(KfNr, 12, 3)
            if (aqstr=2)
              netrepl('KfN', {KfNr})
            endif

          endif

        else
          //                ?str(mnr,6)+' '+str(ktlr,9)+' Нет в тек '
          //                if aqstr=2
          //                   netadd()
          //                  putrec()
          //                  netrepl('KfN,kfo,kf','KfNr,0,0')
          //               endif
        endif

        sele tOstP
        skip
      enddo

      //обратная проверка
      sele tOstP
      index on ktl to t1

      sele pr2
      ordsetfocus('t1')
      netseek('t1', 'mnr')
      Do While pr2->mn = mnr

        If !empty(KfN)

          If !tOstP->(DBSeek(pr2->Ktl))
            ?str(mnr, 6)+' '+str(pr2->ktl, 9)+' Тек '+str(KfN, 12, 3)+' Расч '+str(0, 12, 3)
            if (aqstr=2)
              netrepl('KfN', {0})
            endif

          EndIf

        EndIf
        DBSkip()
      EndDo

      close tOstP
      //filedelete('tOstP.*')
      nuse('pr1p')
      nuse('pr2p')
      nuse('tovp')
    endif

    ?'Коррекция KFO,KF текущего,SkSpr',SkSpr
    sele cskl
    locate for sk=SkSpr
    if (foun())
      pathr=gcPath_d+alltrim(path)// Склад ответхранения
      ?__FILE__,__LINE__,'// Склад ответхранения  pathr',pathr

      netuse('pr1', 'pr1o',, 1)
      netuse('pr2', 'pr2o',, 1)
      netuse('rs1', 'rs1o',, 1)
      netuse('rs2', 'rs2o',, 1)
      netuse('tov', 'tovo',, 1)
      if (select('qPrO')#0)
        sele qPrO
        CLOSE
      endif

      filedelete('qPrO.*')
      crtt('qPrO', 'f:ktl c:n(9) f:upakp c:n(12,3) f:kf c:n(12,3)')
      sele 0
      use qPrO excl
      inde on str(ktl, 9) tag t1
      sele pr1o
      while (!eof())
        if (prz=0)
          skip
          loop
        endif

        if (kps#kpsr)
          skip
          loop
        endif

        if (sktp#gnSk)
          skip
          loop
        endif

        skl_r=skl
        mn_r=mn
        sele pr2o
        if (netseek('t1', 'mn_r'))
          while (mn=mn_r)
            ktlr=ktl
            mntovr=mntov
            kfr=kf
            upakpr=getfield('t1', 'skl_r,ktlr', 'tovo', 'upakp')
            sele qPrO
            if (!netseek('t1', 'ktlr'))
              netadd()
              netrepl('ktl,upakp,kf', 'ktlr,upakpr,kfr')
            else
              netrepl('kf', 'kf+kfr')
            endif

            sele pr2o
            skip
          enddo

        endif

        sele pr1o
        skip
      enddo

      if (select('qPsO')#0)
        sele qPsO
        CLOSE
      endif

      filedelete('qPsO.*')
      crtt('qPsO', 'f:ktl c:n(9) f:kvp c:n(12,3)')
      sele 0
      use qPsO excl
      inde on str(ktl, 9) tag t1
      sele rs1o
      while (!eof())
        if (amnp#0)
          skip
          loop
        endif

        if (prz=0)
          skip
          loop
        endif

        skl_r=skl
        ttn_r=ttn
        sele rs2o
        if (netseek('t1', 'ttn_r'))
          while (ttn=ttn_r)
            ktlr=ktl
            mntovr=mntov
            kvpr=kvp
            sele qPsO
            if (!netseek('t1', 'ktlr'))
              netadd()
              netrepl('ktl,kvp', 'ktlr,kvpr')
            else
              netrepl('kvp', 'kvp+kvpr')
            endif

            sele rs2o
            skip
          enddo

        endif

        sele rs1o
        skip
      enddo

      filedelete('qOsFoO.*')
      crtt('qOsFoO', 'f:MnTov c:n(7) f:ktl c:n(9) f:osfo c:n(12,3) f:kfo c:n(12,3) f:kf c:n(12,3) f:delta c:n(12,3)')
      use qOsFoO new Exclusive
      inde on str(ktl, 9) tag t1
      sele TovO
      copy to tmpOsFo field mntov, ktl, osfo for osfo#0
      sele qOsFoO
      append from tmpOsFo


      nuse('pr1o')
      nuse('pr2o')
      nuse('rs1o')
      nuse('rs2o')
      nuse('tovo')

      ?'Ручные приходы с отв хр'
      if (select('qOtchRp')#0)
        sele qOtchRp
        CLOSE
      endif

      filedelete('qOtchRp.*')
      crtt('qOtchRp', 'f:ktlm c:n(9) f:kf c:n(12,3)')
      sele 0
      use qOtchRp excl
      inde on str(ktlm, 9) tag t1
      sele pr1
      go top
      while (!eof())
        if (otv#4)
          skip
          loop
        endif

        if (kps#kpsr)
          skip
          loop
        endif

        mn_r=mn
        amnpr=mn
        sele pr2
        if (netseek('t1', 'mn_r'))
          while (mn=mn_r)
            ktlmr=ktlm
            ktlr=ktl
            kfr=kf
            sele qOtchRp
            if (!netseek('t1', 'ktlmr'))
              netadd()
              netrepl('ktlm,kf', 'ktlmr,kfr')
            else
              netrepl('kf', 'kf+kfr')
            endif

            sele pr2
            skip
          enddo

        endif

        sele pr1
        skip
      enddo

      ?'Подтвержденные отчеты'
      if (select('qOtchP')#0)
        sele qOtchP
        CLOSE
      endif

      filedelete('qOtchP.*')
      crtt('qOtchP', 'f:ktlm c:n(9) f:kf c:n(12,3) f:ktl c:n(9)')
      use qOtchP new excl
      inde on str(ktlm, 9) tag t1

      sele pr1
      go top
      while (!eof())
        if (prz=0)
          skip
          loop
        endif

        if (otv#3)
          skip
          loop
        endif

        if (kps#kpsr)
          skip
          loop
        endif

        mn_r=mn
        amnpr=mn
        sele pr2
        if (netseek('t1', 'mn_r'))
          while (mn=mn_r)
            ktlmr=ktlm
            ktlr=ktl
            kfr=kf
            sele qOtchP
            if (!netseek('t1', 'ktlmr'))
              netadd()
              netrepl('ktlm,kf,ktl', 'ktlmr,kfr,ktlr')
            else
              netrepl('kf', 'kf+kfr')
            endif

            sele pr2
            skip
          enddo

          ?'Отчет '+str(amnpr, 6)
          sele qOtchP
          go top
          while (!eof())
            ktlmr=ktlm
            ktlr=ktl
            sele rs2
            set orde to tag t5// amnp,ktl
            while (.t.)
              sele rs2
              if (netseek('t5', 'amnpr,ktlmr'))
                ?str(ttn, 6)+' '+str(ktl, 9)+' '+' -> '+str(ktlr, 9)
                if (aqstr=2)
                  netrepl('ktl,ktlp,otv', 'ktlr,ktlr,0')
                else
                  exit
                endif

              else
                exit
              endif

            enddo

            sele qOtchP
            skip
          enddo

        endif

        sele pr1
        skip
      enddo

      /****************** */
      sele pr1
      go top
      while (!eof())
        if (prz=0)
          skip
          loop
        endif

        if (otv#3)
          skip
          loop
        endif

        if (kps#kpsr)
          skip
          loop
        endif

        mn_r=mn
        amnpr=mn
        sele pr2
        if (netseek('t1', 'mn_r'))
          while (mn=mn_r)
            ktlmr=ktlm
            ktlr=ktl
            sele rs2
            set orde to tag t7// amnp,ktlm
            if (netseek('t7', 'amnpr,ktlmr'))
              while (amnp=amnpr.and.ktlm=ktlmr)
                if (ktl#ktlr)
                  ?'TTN '+str(ttn, 6)+' '+str(ktl, 9)+' MN '+str(amnp, 6)+' '+str(ktlr, 9)+' KTLM '+str(ktlmr, 9)
                  if (aqstr=2)
                    netrepl('ktl', 'ktlr')
                  endif

                endif

                sele rs2
                skip
              enddo

            endif

            sele pr2
            skip
          enddo

        endif

        sele pr1
        skip
      enddo

      /****************** */
      ?'Неподтвержденные отчеты'
      if (select('qOtchN')#0)
        sele qOtchN
        CLOSE
      endif

      filedelete('qOtchN.*')
      crtt('qOtchN', 'f:ktlm c:n(9) f:kf c:n(12,3) f:ktl c:n(9) f:zen c:n(10,3)')
      sele 0
      use qOtchN excl
      inde on str(ktlm, 9) tag t1
      sele pr1
      go top
      while (!eof())
        if (prz=1)
          skip
          loop
        endif

        if (otv#3)
          skip
          loop
        endif

        if (kps#kpsr)
          skip
          loop
        endif

        mn_r=mn
        amnpr=mn
        sele pr2
        if (netseek('t1', 'mn_r'))
          while (mn=mn_r)
            ktlmr=ktlm
            ktlr=ktl
            kfr=kf
            zenr=zen
            sele qOtchN
            if (!netseek('t1', 'ktlmr'))
              netadd()
              netrepl('ktlm,kf,ktl,zen', 'ktlmr,kfr,ktlr,zenr')
            else
              netrepl('kf', 'kf+kfr')
            endif

            sele pr2
            skip
          enddo

          ?'Отчет '+str(amnpr, 6)
          sele qOtchN
          go top
          while (!eof())
            ktlmr=ktlm
            ktlr=ktl
            if (zen=0)    // Пропуск неперекодированных
              skip
              loop
            endif

            sele rs2
            set orde to tag t5// amnp,ktl  // t7 amnp,ktlm
            while (.t.)
              sele rs2
              if (netseek('t5', 'amnpr,ktlmr'))
                ?str(ttn, 6)+' '+str(ktl, 9)+' '+' -> '+str(ktlr, 9)
                if (aqstr=2)
                  netrepl('ktl,ktlp,otv', 'ktlr,ktlr')
                else
                  exit
                endif

              else
                exit
              endif

            enddo

            sele qOtchN
            skip
          enddo

        endif

        sele pr1
        skip
      enddo

      ?'Протоколы'
      if (select('qPrOt')#0)
        sele qPrOt
        CLOSE
      endif

      filedelete('qPrOt.*')
      crtt('qPrOt', 'f:ktl c:n(9) f:kf c:n(12,3)')
      sele 0
      use qPrOt excl
      inde on str(ktl, 9) tag t1
      sele pr1
      go top
      while (!eof())
        if (prz=1)
          skip
          loop
        endif

        if (otv#2)
          skip
          loop
        endif

        if (kps#kpsr)
          skip
          loop
        endif

        mn_r=mn
        sele pr2
        if (netseek('t1', 'mn_r'))
          while (mn=mn_r)
            ktlr=ktl
            kfr=kf
            sele qPrOt
            if (!netseek('t1', 'ktlr'))
              netadd()
              netrepl('ktl,kf', 'ktlr,kfr')
            else
              netrepl('kf', 'kf+kfr')
            endif

            sele pr2
            skip
          enddo

        endif

        sele pr1
        skip
      enddo

      ?__FILE__,__LINE__,'Коррекция '
      sele pr2
      set orde to tag t1
      if (netseek('t1', 'mnr'))

        /////// обнулим обороты  //////
        Do While mn=mnr
          if (aqstr=2)
            netrepl('kf,kfo', '0,0')
          endif
          DBSkip()
        EndDo
        /////////////////////

        netseek('t1', 'mnr')
        while (mn=mnr)
          mntovr=mntov
          ktlr=ktl
          upakpr=getfield('t1', 'gnSkl,ktlr', 'tov', 'upakp')
          KfNr=KfN          // начальные
          kfr=kf            // Тек kf // По подтв док
          kfor=kfo          // Тек kfo // По подтв док -прот-неподтв отчет (osvo)
          kfPor=0           // Приходов с отв
          kvpr=0            // Расходы не авт отв хр
          KfOtchPr=0        // Подтв. отч.
          KfOtchNr=0        // Неподтв. отч.
          KfProtr=0         // Протокол
          kfRPr=0           // Ручные отчеты
          sele qPrO
          locate for ktl=ktlr
          if (foun())
            kfpor=kf
          endif

          sele qPsO
          locate for ktl=ktlr
          if (foun())
            kvpr=kvp
          endif

          sele qOtchP
          locate for ktlm=ktlr
          if (foun())
            KfOtchPr=kf
          endif

          sele qOtchRp
          locate for ktlm=ktlr
          if (foun())
            kfrpr=kf
          endif

          sele qOtchN
          locate for ktlm=ktlr
          if (foun())
            KfOtchNr=kf
          endif

          sele qPrOt
          locate for ktl=ktlr
          if (foun())
            KfProtr=kf
          endif

          if (KfNr=0.and.kfpor=0.and.KfOtchPr=0.and.KfOtchNr=0.and.KfProtr=0.and.kfrpr=0.and.kvpr=0)
            prdelr=1
          else
            prdelr=0
          endif

          sele pr2
          mntovr=mntov

          kfo_r = KfNr;
          + kfpor;    // Приходов с отв
          - KfOtchPr; // Подтв. отч.
          - kfrpr;    // Ручные отчеты
          - kvpr      // Расходы не авт отв хр


          kf_r =KfNr;
          + kfpor;     // Приходов с отв
          - KfOtchPr;  // Подтв. отч.
          - kfrpr;     // Ручные отчеты
          - kvpr       // Расходы не авт отв хр
          kf_r = kf_r;
          - KfOtchNr;  // Неподтв. отч.
          - KfProtr    // Протокол


          if (kfor#kfo_r.or.kfr#kf_r)
            if (kfor#KfNr+kfpor-KfOtchPr-kvpr)
              ?str(mnr, 6)+' '+str(ktlr, 9)+' Коррекция KFO '+str(kfor, 10, 3)+' -> '+str(kfo_r, 10, 3)
              If ktl=507277354
                ?__FILE__,__LINE__,KfNr,kfpor,KfOtchPr,kvpr,'KfNr,kfpor,KfOtchPr,kvpr'
              EndIf
            else
              ?str(mnr, 6)+' '+str(ktlr, 9)+' Коррекция KF  '+str(kfr, 10, 3)+' -> '+str(kf_r, 10, 3)
            endif

            if (aqstr=2)
              netrepl('kf,kfo', {kf_r,kfo_r})

              // для сверки остатков
              sele qOsFoO
              locate for ktl=ktlr
              If !found()
                append blank
                repl ktl with ktlr
              EndIf
              netrepl('MnTov,kf,kfo,delta', {MnTovr,kf_r,kfo_r,osfo-kfo_r})

            endif

          endif

          sele tov
          if (netseek('t1', 'sklr,ktlr'))
            if (osvo#kf_r)
              ?str(sklr, 7)+' '+str(ktlr, 9)+' '+' PR2->KF '+str(kf_r, 10, 3)+' '+' TOV->OSVO '+str(osvo, 10, 3)
              if (aqstr=2)
                netrepl('osvo', 'kf_r')
              endif

            endif

            if (otv#1)    //.or.opt#0
              ?str(sklr, 7)+' '+str(ktlr, 9)+' '+str(opt, 10.3)+' TOV->OTV=0'
              if (aqstr=2)
                netrepl('opt,otv', '0.01,1')
              endif

            endif

            if (osn#0.or.osv#0.or.osf#0.or.osfm#0)
              ?str(sklr, 7)+' '+str(ktlr, 9)+' '+'osn#0.or.osv#0.or.osf#0.or.osfm#0'
              if (aqstr=2)
                netrepl('osn,osv,osf,osfm', '0,0,0,0')
              endif

            endif

            /*                   #ifndef __CLIP__ */
            if (prdelr=1)
              ?str(sklr, 7)+' '+str(ktlr, 9)+' '+str(otv, 1)+' '+str(osvo, 12, 3)+' TOV удален'
              if (aqstr=2)
                netdel()
              endif

            endif

          /*                   #endif */
          else
            ?str(sklr, 7)+' '+str(ktlr, 9)+' '+' Нет в TOV'
          endif

          sele pr2
          /*                #ifndef __CLIP__ */
          if (prdelr=1)
            ?str(mnr, 6)+' '+str(ktlr, 9)+' '+str(KfN, 12, 3)+' '+str(kf, 12, 3)+' '+str(kfo, 12, 3)+' PR2 удален'
            if (aqstr=2)
              netdel()
            endif

          endif

          /*                #endif */
          skip
        enddo

        ?'TOVM'
        sele tovm
        go top
        while (!eof())
          sklr=skl
          mntovr=mntov
          if (!netseek('t5', 'sklr,mntovr', 'tov'))
            ?str(sklr, 7)+' '+str(mntovr, 7)+' '+subs(nat, 1, 40)+' нет в TOV удален'
            if (aqstr=2)
              sele tovm
              netdel()
            endif

          endif

          sele tovm
          skip
        enddo

        sele qOsFoO
        close

        sele qPrOt
        CLOSE
        //erase qPrOt.dbf
        //erase qPrOt.cdx
        sele qOtchN
        CLOSE
        //erase qOtchN.dbf
        //erase qOtchN.cdx
        sele qOtchRp
        CLOSE
        //erase qOtchRp.dbf
        //erase qOtchRp.cdx
        sele qOtchP
        CLOSE
        //erase qOtchP.dbf
        //erase qOtchP.cdx
        sele qPrO
        CLOSE
        //erase qPrO.dbf
        //erase qPrO.cdx
        sele qPsO
        CLOSE
        //erase qPsO.dbf
        //erase qPsO.cdx

      endif

    endif

    sele qkps
    skip
  enddo

  if (select('qkps')#0)
    sele qkps
    CLOSE
  endif

  //erase qkps.dbf
  nuse()
  nuse('pr1p')
  nuse('pr2p')
  set prin off
  set prin to
  return (.t.)

/************** */
function OtvPrv()
  /************** */
  if (gnArm#0)
    clea
    aqstr=1
    aqst:={ "Просмотр", "Коррекция" }
    aqstr:=alert(" ", aqst)
    if (lastkey()=K_ESC)
      return (.t.)
    endif

  else
    aqstr=2
  endif

  set prin to crotv.txt
  set prin on
  if (gnSkotv#0)
    CarsOtv()
    return (.t.)
  endif

  pathr=path_tr
  netuse('pr1',,, 1)
  locate for otv=1
  if (!foun())
    nuse('pr1')
    wmess('Этот склад не имеет ответхранения', 1)
    return
  endif

  netuse('cskl')
  pathr=path_tr
  netuse('tov',,, 1)
  netuse('tovm',,, 1)
  netuse('rs1',,, 1)
  netuse('rs2',,, 1)
  netuse('pr1',,, 1)
  netuse('pr2',,, 1)
  // dtr=bom (gdTd)-1
  // mr=month(dtr)
  // yyr=year(dtr)
  // pathpr=gcPath_e+'g'+str(yyr,4)+'\m'+iif(mmr<10,'0'+str(mmr,1),str(mmr,2))+'\'+gcDir_t
  pathr=path_pr
  if (!netfile('tov', 1))
    nuse()
    return (.t.)
  endif

  netuse('tov', 'tovp',, 1)
  netuse('pr1', 'pr1p',, 1)
  netuse('pr2', 'pr2p',, 1)
  netuse('rs1', 'rs1p',, 1)
  netuse('rs2', 'rs2p',, 1)

  if (.f.)                // gnArm#0.and.gnAdm=1
    acrdcr=0
    if (aqstr=1)
      acrdcr=1
    else
      if (bom(gdTd)=bom(date()))
        acrdc:={ "Просмотр", "Коррекция" }
        acrdcr:=alert("Корр только для завершения переворота ", acrdc)
      else
        acrdcr=1
      endif

    endif

    if (acrdcr=2)
      ?'Коррекция TTN по отчетам прошлого месяца'
    else
      ?'Просмотр TTN по отчетам прошлого месяца'
    endif

    sele pr1p
    go top
    while (!eof())
      if (otv#3)
        skip
        loop
      endif

      mnr=mn
      sele pr2p
      if (netseek('t1', 'mnr'))
        while (mn=mnr)
          if (ktlm=0)
            ?str(mnr, 6)+' ktlm=0'
            skip
            loop
          endif

          if (ktl=ktlm)
            ?str(mnr, 6)+' ktl=ktlm'
            skip
            loop
          endif

          ktlr=ktl
          ktlpr=ktlp
          ktlmr=ktlm
          ktlmpr=ktlmp
          sele rs2p
          set orde to tag t5// amnp,ktl,ktlp
          if (netseek('t5', 'mnr,ktlr,ktlpr'))
            while (amnp=mnr.and.ktl=ktlr.and.ktlp=ktlpr)
              ttnr=ttn
              ktlm_r=ktlm
              ktlmp_r=ktlmp
              otvr=otv
              sele rs2
              set orde to tag t1
              if (netseek('t1', 'ttnr'))
                while (ttn=ttnr)
                  if (ktlm=ktlm_r.and.ktlmp=ktlmp_r)//.or.ktlm=0.and.ktl=ktlmr.and.ktlp=ktlmpr
                    if (ktl#ktlr.or.amnp#mnr.or.otv#otvr)
                      ?str(ttnr, 6)+' KTL '+str(ktl, 9)+'->'+str(ktlr, 9)+' AMNP '+str(amnp, 6)+'->'+str(mnr, 6)+' OTV '+str(otv, 1)+'->'+str(otvr, 1)
                      if (acrdcr=2)
                        netrepl('amnp,ktl,ktlp,ktlm,ktlmp,otv', 'mnr,ktlr,ktlpr,ktlmr,ktlmpr,otvr')
                      endif

                    endif

                  endif

                  sele rs2
                  skip
                enddo

              endif

              sele rs2p
              skip
            enddo

          endif

          sele pr2p
          skip
        enddo

      endif

      sele pr1p
      skip
    enddo

  endif

  if (.f.)                // В rs2 может быть коррекция на 0 - некорректная проверка
    ?'Коррекция отчетов текущего месяца'
    sele pr1
    go top
    while (!eof())
      if (otv#3)
        skip
        loop
      endif

      mnr=mn
      sele rs2
      set orde to tag t5
      if (!netseek('t5', 'mnr'))
        sele pr2
        if (netseek('t1', 'mnr'))
          while (mn=mnr)
            ?str(mnr, 6)+' '+str(ktlr, 9)+' уд'
            if (aqstr=2)
              netdel()
            endif

            sele pr2
            skip
          enddo

        endif

        sele pr1
        ?str(mnr, 6)+' уд'
        if (aqstr=2)
          netdel()
        endif

      endif

      sele pr1
      skip
    enddo

  endif

  /*#ifndef __CLIP__ */
  acrdc1r=0
  if (.f.)                // gnArm#0.and.gnAdm=1
    if (aqstr=1)
      acrdc1r=1
    else
      acrdc:={ "Просмотр", "Коррекция" }
      acrdc1r:=alert("Коррекция подтвержденных расходов ОТВ", acrdc)
    endif

    if (acrdc1r=2)
      ?'Коррекция подтвержденных расходов ОТВ'
    else
      ?'Проверка подтвержденных расходов ОТВ'
    endif

  endif

  sele cskl
  go top
  while (!eof())
    if (skotv#gnSk)
      skip
      loop
    endif

    sk_r=sk
    pathr=gcPath_d+alltrim(path)// Склад ответхранения
    netuse('rs1', 'rs1o',, 1)
    netuse('rs2', 'rs2o',, 1)
    ?'Расход->Приход'
    sele rs1o
    go top
    while (!eof())
      ttnr=ttn
      mnr=amnp
      SkSpr=SkSp
      ?str(sk_r, 3)+' '+'TTN'+' '+str(ttnr, 6)+' -> MN '+str(mnr, 6)
      if (SkSpr=gnSk)
        sele pr1
        if (netseek('t2', 'mnr'))
          sele rs2o
          if (netseek('t1', 'ttnr'))
            while (ttn=ttnr)
              ktlr=ktl
              ktlmr=ktlm
              kvpr=kvp
              kfr=0
              sele pr2
              if (netseek('t1', 'mnr,ktlmr'))
                prfnd_r=0
                while (mn=mnr.and.ktl=ktlmr)
                  if (ktlm=ktlr)
                    kfr=kf
                    if (kvpr#kfr)
                      ?str(sk_r, 3)+' TTN '+str(ttnr, 6)+' '+str(ktlr, 9)+' kvpr '+str(kvpr, 12, 3)+' MN '+str(mnr, 6)+' '+str(ktlmr, 9)+' kfr '+str(kfr, 12, 3)
                      if (acrdc1r=2)
                        sele rs2o
                        netrepl('kvp', 'kfr')
                      endif

                    endif

                    prfnd_r=1
                  endif

                  sele pr2
                  skip
                enddo

                if (prfnd_r=0)
                  ?str(sk_r, 3)+' TTN '+str(ttnr, 6)+' '+str(ktlr, 9)+' kvpr '+str(kvpr, 12, 3)+' MN '+str(mnr, 6)+' '+str(ktlmr, 9)+' kfr '+str(kfr, 12, 3)+' не найден'
                endif

              else
                ?str(sk_r, 3)+' TTN '+str(ttnr, 6)+' '+str(ktlr, 9)+' kvpr '+str(kvpr, 12, 3)+' MN '+str(mnr, 6)+' '+str(ktlmr, 9)+' не найден'
                if (acrdc1r=2)
                  sele rs2o
                  netdel()
                endif

              endif

              sele rs2o
              skip
            enddo

          endif

        else
          ?str(sk_r, 3)+' '+' TTN '+str(ttnr, 6)+' MN '+str(mnr, 6)+' не найден'
        endif

      endif

      sele rs1o
      skip
    enddo

    ?'Приход->Расход'
    sele pr1
    go top
    while (!eof())
      if (prz#1)
        skip
        loop
      endif

      if (otv#3)
        skip
        loop
      endif

      mn_r=mn
      ttn_r=amnp
      ?'MN'+' '+str(mn_r, 6)+' -> TTN '+str(ttn_r, 6)
      sele pr2
      if (netseek('t1', 'mn_r'))
        while (mn=mn_r)
          ktl_r=ktl
          ktlm_r=ktlm
          kf_r=kf
          sele rs2o
          if (netseek('t1', 'ttn_r,ktlm_r'))
            prfnd_r=0
            while (ttn=ttn_r.and.ktl=ktlm_r)
              kvp_r=kvp
              if (ktlm=ktl_r)
                if (kf_r#kvp_r)
                  ?'MN'+' '+str(mn_r, 6)+' KTL '+str(ktl_r, 9)+' '+str(kf_r, 12, 3)+' TTN '+str(ttn_r, 6)+' KTL '+str(ktlm_r, 9)+' '+str(kvp_r, 12, 3)
                endif

                prfnd_r=1
              endif

              sele rs2o
              skip
            enddo

            if (prfnd_r=0)
              ?'MN'+' '+str(mn_r, 6)+' KTL '+str(ktl_r, 9)+' '+str(kf_r, 12, 3)+' TTN '+str(ttn_r, 6)+' KTL '+str(ktlm_r, 9)+' '+str(kvp_r, 12, 3)+' не найден'
            endif

          else
            ?'MN'+' '+str(mn_r, 6)+' KTL '+str(ktl_r, 9)+' '+str(kf_r, 12, 3)+' TTN '+str(ttn_r, 6)+' KTL '+str(ktlm_r, 9)+' не найден'
          endif

          sele pr2
          skip
        enddo

      endif

      sele pr1
      skip
    enddo

    nuse('rs1o')
    nuse('rs2o')
    sele cskl
    skip
  enddo

  /*#endif */

  CrPrOto()
  nuse('tovp')
  nuse('pr1p')
  nuse('pr2p')
  nuse('rs1p')
  nuse('rs2p')
  nuse()

  cukach()
  cadrot()
  PrvOtv()
  wait
  return (.t.)

/*************** */
function cukach()
  /*************** */
  pathr=path_tr
  netuse('pr1',,, 1)
  netuse('pr2',,, 1)
  sele pr1
  set orde to tag t3        // otv,kps
  if (!netseek('t3', '1'))
    nuse('pr1')
    nuse('pr2')
    wmess('Этот склад не имеет ответхранения', 1)
    return (.t.)
  endif

  ?'Коррекция качественных'
  filedelete('lkpssk.*')
  crtt('lkpssk', 'f:kps c:n(7) f:sk c:n(3)')
  sele 0
  use lkpssk
  sele pr1
  while (otv=1)
    kpsr=kps
    skr=SkSp
    sele lkpssk
    locate for kps=kpsr.and.sk=skr
    if (!foun())
      appe blank
      repl kps with kpsr, sk with skr
    endif

    sele pr1
    skip
  enddo

  netuse('cskl')
  pathr=path_tr
  netuse('tov',,, 1)
  sele lkpssk
  go top
  while (!eof())
    skr=sk
    sele cskl
    if (netseek('t1', 'skr'))
      pathr=gcPath_d+alltrim(path)
      if (netfile('tov', 1))
        netuse('tov', 'tovotv',, 1)
        while (!eof())
          ktlr=ktl
          ksertr=ksert
          kukachr=kukach
          if (ksertr#0.and.kukachr#0)
            sele tov
            if (netseek('t1', 'gnSkl,ktlr'))
              if (ksertr#ksert.or.kukachr#kukach)
                ?str(ktl, 9)+' KSERT '+str(ksert, 6)+'->'+str(ksertr, 6)+' KUKACH '+str(kukach, 6)+'->'+str(kukachr, 6)
                if (aqstr=2)
                  netrepl('ksert,kukach', 'ksertr,kukachr')
                endif

              endif

            endif

          endif

          sele tovotv
          skip
        enddo

        nuse('tovotv')
      endif

    endif

    sele lkpssk
    skip
  enddo

  sele lkpssk
  CLOSE
  sele pr1
  if (netseek('t3', '3'))
    while (otv=3)
      mnr=mn
      sele pr2
      if (netseek('t1', 'mnr'))
        while (mn=mnr)
          ktlr=ktl
          ktlmr=ktlm
          if (ktlr=ktlmr)
            skip
            loop
          endif

          sele tov
          if (netseek('t1', 'gnSkl,ktlmr'))
            ksertr=ksert
            kukachr=kukach
            if (ksertr#0.and.kukachr#0)
              sele tov
              if (netseek('t1', 'gnSkl,ktlr'))
                if (ksertr>ksert.or.kukachr>kukach)
                  ?str(ktlmr, 9)+'->'+str(ktl, 9)+' KSERT '+str(ksert, 6)+'->'+str(ksertr, 6)+' KUKACH '+str(kukach, 6)+'->'+str(kukachr, 6)
                  if (aqstr=2)
                    netrepl('ksert,kukach', 'ksertr,kukachr')
                  endif

                endif

              endif

            endif

          endif

          sele pr2
          skip
        enddo

      endif

      sele pr1
      skip
    enddo

  endif

  nuse()
  return (.t.)

/*****************************************************************
 
 FUNCTION:
 АВТОР..ДАТА.......... update С. Литовка  09-13-19 * 11:32:28am
 НАЗНАЧЕНИЕ.........
 ПАРАМЕТРЫ..........
 ВОЗВР. ЗНАЧЕНИЕ....
 ПРИМЕЧАНИЯ.........
 */
function CrProtO(p1, lx_mnr)

  if (!empty(p1))
    set cons off
  endif

  ?'Коррекция протокола'
  if (select('lprot')#0)
    sele lprot
    CLOSE
  endif

  filedelete('lprot.*')
  crtt('lprot', 'f:amnp c:n(6) f:mntov c:n(7) f:ktl c:n(9) f:kf c:n(15,3)')
  sele 0
  use lprot shared
  sele rs2
  go top
  while (!eof())
    if (otv#2)
      skip
      loop
    endif

    if (amnp=0)
      skip
      loop
    endif

    ttnr=ttn
    przr=getfield('t1', 'ttnr', 'rs1', 'prz')
    if (przr=0)
      amnpr=amnp
      mntovr=mntov
      ktlr=ktl
      ktlpr=ktlp
      kvpr=kvp
      sele lprot
      locate for amnp=amnpr.and.ktl=ktlr
      if (!foun())
        appe blank
        repl ktl with ktlr, ;
         mntov with mntovr, ;
         amnp with amnpr
      endif

      reclock()
      repl kf with kf+kvpr
      netunlock()
    else
      ?str(ttnr, 6)+' '+str(ktlr, 9)+' PRZ= 1'
    endif

    sele rs2
    skip
  enddo

  sele lprot
  go top
  while (!eof())
    amnpr=amnp
    mntovr=mntov
    ktlr=ktl
    kfr=kf
    sele pr2
    if (netseek('t1', 'amnpr,ktlr,ktlr'))
      if (kf#kfr)
        ?str(amnpr, 6)+' '+str(ktlr, 9)+' '+str(kf, 15, 3)+'->'+str(kfr, 15, 3)
        if (aqstr=2)
          netrepl('kf,kfo', 'kfr,kfr')
        endif

      endif

    else
      ?str(amnpr, 6)+' '+str(ktlr, 9)+' не найден '+'->'+str(kfr, 15, 3)
      if (aqstr=2)
        netadd()
        netrepl('mn,mntov,mntovp,ktl,ktlp,kf,kfo,ktlm,ktlmp', 'amnpr,mntovr,mntovr,ktlr,ktlr,kfr,kfr,ktlr,ktlr')
      endif

    endif

    sele lprot
    skip
  enddo

  sele rs2
  set orde to tag t5        // amnp,ktl,ktlp
  sele pr1
  go top
  while (!eof())
    if (otv#2)
      skip
      loop
    endif
    If !Empty(lx_mnr) .and. lx_mnr # mn
      skip
      loop
    EndIf

    mnr=mn
    sele pr2
    if (netseek('t1', 'mnr'))
      while (mn=mnr)
        ktlr=ktl
        sele rs2
        if (!netseek('t5', 'mnr,ktlr'))
          sele pr2
          ?str(mnr, 6)+' '+str(ktlr, 9)+' '+str(kf, 15, 3)+' '+str(kfo, 15, 3)+' нет в rs2'
          if (aqstr=2)
            netdel()
          /*               netrepl('kf,kfo','0,0') */
          endif

        endif

        sele pr2
        skip
      enddo

    endif

    sele pr1
    skip
  enddo

  sele lprot
  CLOSE
  if (!empty(p1))
    set cons on
  endif

  // востановление
  If !Empty(lx_mnr)
    mnr:=lx_mnr
  EndIf

  return (.t.)

/************* */
function cadrot()
  /* Коррекция skt,sklt,amn,sktp,skltp,amnp
   *************
   */
  ?'Коррекция skt,sklt,amn,sktp,skltp,amnp'
  pathr=path_tr
  netuse('pr1',,, 1)
  set orde to tag t3
  if (!netseek('t3', '1'))
    nuse('pr1')
    wmess('Этот склад не имеет ответхранения', 1)
    return (.t.)
  endif

  netuse('soper',,, 1)
  sele pr1
  set orde to tag t3        // otv,kps
  if (!netseek('t3', '3'))
    nuse('pr1')
    nuse('soper')
    wmess('Нет отчетов', 1)
    return (.t.)
  endif

  while (otv=3)
    kpsr=kps
    sktr=skt
    skltr=sklt
    amnr=amn
    sktpr=sktp
    skltpr=skltp
    amnpr=amnp
    kopr=kop
    vor=vo
    mnr=mn
    if (sktpr=0.and.sktr#0)
      ?str(mnr, 6)+' '+'AMNP'+' '+str(amnpr, 6)+'->'+str(amnr, 6)+' '+'SKTP'+' '+str(sktpr, 3)+'->'+str(sktr, 3)+' '+'SKLTP'+' '+str(skltpr, 7)+'->'+str(skltr, 7)
      if (aqstr=2)
        netrepl('sktp,skltp,amnp,amn', 'sktr,skltr,amnr,0')
      endif

    endif

    qr=mod(kopr, 100)
    sele soper
    netseek('t1', '1,1,vor,qr')
    skt_r=ska
    sklt_r=kpsr

    sele pr1
    if (skt_r#0)
      if (sktr#skt_r)
        ?str(mnr, 6)+' '+'SKT'+' '+str(sktr, 3)+'->'+str(skt_r, 3)+' '+'SKLT'+' '+str(skltr, 7)+'->'+str(sklt_r, 7)
        if (aqstr=2)
          netrepl('skt,sklt', 'skt_r,sklt_r')
        endif

      endif

    endif

    sele pr1
    skip
  enddo

  nuse()
  return (.t.)

/************* */
function CarsOtv()
  /************** */
  pathr=path_tr
  netuse('rs1',,, 1)
  go top
  while (!eof())
    ttnr=ttn
    amnpr=amnp
    amnr=amn
    if (amnpr=0.and.amnr#0)
      ?'TTN'+' '+str(ttnr, 6)+' AMNP '+str(amnpr, 6)+'->'+str(amnr, 6)
      if (aqstr=2)
        netrepl('amnp,amn', 'amnr,0')
      endif

    endif

    sele rs1
    skip
  enddo

  nuse()
  return (.t.)

/****************** */
function ChkOtO()
  /****************** */
  mnprotr=val(nnzr)
  /*wmess('ChkOtO') */
  netuse('rs2', 'rs2co')
  filedelete('ChkOtO.*')
  crtt('ChkOtO', 'f:ktl c:n(9) f:otv c:n(1) f:ktlm c:n(9) f:otvm c:n(1) f:kf c:n(12,3) f:rs c:n(12,3) f:rsm c:n(12,3) f:pr c:n(12,3) f:prm c:n(12,3) f:prot c:n(12,3) f:osvo c:n(12,3)')
  sele 0
  use ChkOtO excl
  sele pr2
  set orde to tag t1
  if (netseek('t1', 'mnr'))
    while (mn=mnr)
      ktlr=ktl
      ktlmr=ktlm
      kfr=kf
      otvr=getfield('t1', 'gnSkl,ktlr', 'tov', 'otv')
      otvmr=getfield('t1', 'gnSkl,ktlmr', 'tov', 'otv')
      sele ChkOtO
      netadd()
      netrepl('ktl,otv,ktlm,otvm,kf', 'ktlr,otvr,ktlmr,otvmr,kfr')
      sele pr2
      skip
    enddo

  endif

  sele pr2
  set orde to tag t1
  if (netseek('t1', 'mnprotr'))
    while (mn=mnprotr)
      ktlr=ktl
      kfr=kf
      osvor=getfield('t1', 'gnSkl,ktlr', 'tov', 'osvo')
      sele ChkOtO
      locate for ktl=ktlr
      if (foun())
        netrepl('prot,osvo', 'prot+kfr,osvo+osvor')
      endif

      sele pr2
      skip
    enddo

  endif

  sele ChkOtO
  go top
  while (!eof())
    ktlr=ktl
    ktlmr=ktlm
    sele rs2co
    set orde to tag t5      // amnp,ktl,ktlp
    rsmr=0
    if (netseek('t5', 'mnr'))
      while (amnp=mnr)
        if (ktlm=ktlmr)
          rsmr=rsmr+kvp
        endif

        sele rs2co
        skip
      enddo

    endif

    rsr=0
    if (ktlr#ktlmr)
      sele rs2co
      set orde to tag t6    // ktl,
      if (netseek('t6', 'ktlr'))
        while (ktl=ktlr)
          ttn_r=ttn
          if (ktlm=ktlmr.and.amnp=0)
            rsr=rsr+kvp
          endif

          sele rs2co
          skip
        enddo

      endif

    endif

    sele pr2
    set orde to tag t6      // ktl,
    prmr=0
    if (netseek('t6', 'ktlmr'))
      while (ktl=ktlmr)
        mn_r=mn
        otv_r=getfield('t2', 'mn_r', 'pr1', 'otv')
        if (ktl=ktlmr.and.mn_r#mnr.and.!(otv_r=1.or.otv_r=2))
          prmr=prmr+kf
        endif

        sele pr2
        skip
      enddo

    endif

    sele pr2
    prr=0
    if (netseek('t6', 'ktlr'))
      while (ktl=ktlr)
        mn_r=mn
        otv_r=getfield('t2', 'mn_r', 'pr1', 'otv')
        if (ktl=ktlr.and.mn_r#mnr.and.!(otv_r=1.or.otv_r=2))
          prr=prr+kf
        endif

        sele pr2
        skip
      enddo

    endif

    sele ChkOtO
    netrepl('rs,rsm,pr,prm', 'rsr,rsmr,prr,prmr')
    skip
  enddo

  aqstr=1
  if (przr=0)
    aqst:={ "Просмотр", "Коррекция" }
    aqstr:=alert(" ", aqst)
    if (lastkey()=K_ESC)
      aqstr=0
    endif

  else
    aqstr=1
  endif

  if (aqstr=2)
    sele ChkOtO
    go top
    while (!eof())
      ktlr=ktl
      ktlmr=ktlm
      kfr=rsm
      sele pr2
      if (netseek('t1', 'mnr,ktlr'))
        if (kfr#0)
          netrepl('kf', 'kfr')
        else
          netdel()
        endif

      endif

      sele ChkOtO
      skip
    enddo

  endif

  if (aqstr=1)
    sele ChkOtO
    go top
    rcchkr=recn()
    fldnomr=1
    while (.t.)
      sele ChkOtO
      go rcchkr
      rcchkr=slce('ChkOtO',,,,, "e:ktl h:'ktl' c:n(9) e:otv h:'otv' c:n(1) e:ktlm h:'ktlm' c:n(9) e:otvm h:'otvm' c:n(1) e:kf h:'kf' c:n(12,3) e:rsm h:'rsm' c:n(12,3) e:rs h:'rs' c:n(12,3) e:pr h:'pr' c:n(12,3) e:prm h:'prm' c:n(12,3) e:prot h:'prot' c:n(12,3) e:osvo h:'osvo' c:n(12,3)")
      sele ChkOtO
      go rcchkr
      if (lastkey()=K_ESC)
        exit
      endif

      do case
      case (lastkey()=19) // Left
        fldnomr=fldnomr-1
        if (fldnomr=0)
          fldnomr=1
        endif

      case (lastkey()=4)  // Right
        fldnomr=fldnomr+1
      endcase

    enddo

  endif

  sele ChkOtO
  CLOSE
  nuse('rs2co')
  return (.t.)

