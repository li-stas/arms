/***********************************************************
 * åÆ§„´Ï    : odkp.prg
 * Ç•‡·®Ô    : 0.0
 * Ä¢‚Æ‡     :
 * Ñ†‚†      : 11/16/17
 * àß¨•≠•≠   :
 Function odkp()
  Return ( Nil )
 */

#include "common.ch"
#include "inkey.ch"
static kkl_store
clodkp=setcolor('g/n,n/g')
save scree to scodkp
clea

store 0 to kklr, mnr1, kop_rr//, kkl_store
store '' to nklr
if (!ISNIL(kkl_store))
  kklr:=kkl_store
endif

netUse('dkkln')
netUse('dknap')
netUse('kln')
netUse('klndog')
netuse('bs')
netuse('dokk')
netuse('doks')
netuse('dokz')
netuse('mfochk')
netuse('banks')
netuse('cskl')
netuse('s_tag')

while (.t.)
  clea
  //kklr=0

  if (!ISNIL(kkl_store))
    kklr:=kkl_store
  endif

  @ 0, 1 say 'äÆ§ ™´®•≠‚†' get kklr pict '@K 9999999'
  read
  if (lastkey()=K_ESC)
    exit
  endif

  if (kklr=0)
    kklr=slct_kl(10, 1, 12)
  endif

  if (kklr=0)
    loop
  endif

  kkl_store:=kklr
  pathdebr=gcPath_ew+'deb\s361001\'
  if (file(pathdebr+'pdeb.dbf'))
    dflr=filedate(pathdebr+'pdeb.dbf')
    tflr=filetime(pathdebr+'pdeb.dbf')
    sele 0
    use (pathdebr+'pdeb')
    locate for kkl=kklr
    if (found())
      dzr=dz
      kzr=kz
      pdzr=pdz
      pdz1r=pdz1
      pdz3r=pdz3
    else
      dzr=0
      kzr=0
      pdzr=0
      pdz1r=0
      pdz3r=0
    endif

    CLOSE
  else
    dflr=ctod('')
    tflr=space(8)
    dzr=0
    kzr=0
    pdzr=0
    pdz1r=0
    pdz3r=0
  endif

  @ 16, 1 say 'íÆ¢†‡ 361001 '+dtoc(dflr)+' '+tflr
  @ 17, 1 say 'Ñ•°•‚Æ‡·™†Ô ß†§Æ´¶  '+str(dzr, 10, 2)+' ä‡•§®‚Æ‡·™†Ô ß†§Æ´¶ '+str(kzr, 10, 2)
  @ 18, 1 say ' >7§≠  '+str(pdzr, 10, 2)+' >14§≠  '+str(pdz1r, 10, 2)+' >21§≠  '+str(pdz3r, 10, 2)
  pathdebr=gcPath_ew+'deb\s361002\'
  if (file(pathdebr+'pdeb.dbf'))
    dflr=filedate(pathdebr+'pdeb.dbf')
    tflr=filetime(pathdebr+'pdeb.dbf')
    sele 0
    use (pathdebr+'pdeb')
    locate for kkl=kklr
    if (found())
      dzr=dz
      kzr=kz
      pdzr=pdz
      pdz1r=pdz1
      pdz3r=pdz3
    else
      dzr=0
      kzr=0
      pdzr=0
      pdz1r=0
      pdz3r=0
    endif

    CLOSE
  else
    dflr=ctod('')
    tflr=space(8)
    dzr=0
    kzr=0
    pdzr=0
    pdz1r=0
    pdz3r=0
  endif

  @ 19, 1 say 'í†‡† 361002 '+dtoc(dflr)+' '+tflr
  @ 20, 1 say 'Ñ•°•‚Æ‡·™†Ô ß†§Æ´¶  '+str(dzr, 10, 2)+' ä‡•§®‚Æ‡·™†Ô ß†§Æ´¶ '+str(kzr, 10, 2)
  @ 21, 1 say ' >7§≠  '+str(pdzr, 10, 2)+' >14§≠  '+str(pdz1r, 10, 2)+' >21§≠  '+str(pdz3r, 10, 2)
  netuse('dknap')         // ÑÆ°†¢´•≠Æ
  netuse('dkkln')         // ÑÆ°†¢´•≠Æ
  if (gnEnt=21.and.gnArm=2)
    sele dokk
    sum bs_s to nds_kr for kkl=kklr.and.bs_k=641002
    @ 22, 1 say 'ä‡ 641002'+' '+str(nds_kr, 10, 2)
  endif

  sele dkkln
  if (select('ldkkln')#0)
    sele ldkkln
    CLOSE
  endif

  sele dkkln
  netseek('t1', 'kklr')
  copy to ldkkln while kkl=kklr
  sele 0
  use ldkkln excl
  repl all dp with 0, kp with 0
  go top
  store 0 to dnr, knr, dbr, krr, dbkr, krkr, sumr
  while (!eof())
    sumr=dn-kn+db-kr
    if (sumr>0)
      repl dp with sumr
    endif

    if (sumr<0)
      repl kp with abs(sumr)
    endif

    dnr=dnr+dn
    knr=knr+kn
    dbr=dbr+db
    krr=krr+kr
    skip
  enddo

  aa=dn
  sumr=dnr-knr+dbr-krr
  if (sumr>0)
    dbkr=sumr
  endif

  if (sumr<0)
    krkr=abs(sumr)
  endif

  sumr=dnr-knr
  if (sumr>0)
    dnr=sumr
    knr=0
  endif

  if (sumr<0)
    knr=abs(sumr)
    dnr=0
  endif

  @ 14, 0 say space(80) color 'n/w'
  /*   @ 14,1 say 'à‚Æ£Æ'+space(5)+'≥'+str(dnr,10,2)+'≥'+str(knr,10,2)+'≥'+str(dbr,10,2)+'≥'+str(krr,10,2)+'≥'+str(dbkr,10,2)+'≥'+str(krkr,10,2)+'≥' color 'n/w' */
  @ 14, 1 say 'à‚Æ£Æ  '+'≥'+str(dnr, 10, 2)+'≥'+str(knr, 10, 2)+'≥'+str(dbr, 12, 2)+'≥'+str(krr, 12, 2)+'≥'+str(dbkr, 10, 2)+'≥'+str(krkr, 10, 2)+'≥' color 'n/w'
  sele kln
  if (!netseek('t1', 'kklr'))
    save scre to scdkln
    mess('ç•‚ ™´®•≠‚† ¢ ·Ø‡†¢ÆÁ≠®™•', 1)
    rest scre from scdkln
    loop
  endif

  nklr=alltrim(nkl)
  adrr=adr
  tlfr=tlf
  nnr=nn
  nsvr=nsv
  kkl1r=kkl1
  sele klndog
  if (netseek('t1', 'kklr,7'))
    ndogr=ndog
    dtdogbr=dtdogb
    dtdoger=dtdoge
  else
    ndogr=0
    dtdogbr=ctod('')
    dtdoger=ctod('')
  endif

  @ 0, 20 say ' '+'ÑÆ£Æ¢Æ‡ '+iif(ndogr#0, str(ndogr, 6), space(6))+' c '+dtoc(dtdogbr)+' ØÆ '+dtoc(dtdoger)
  @ 1, 1 say 'ä´®•≠‚ '+str(kkl1r, 8)+'('+str(kklr, 7)+') '+nklr
  @ 2, 1 say 'Ä§‡•·   '+alltrim(adrr)
  @ 2, col()+1 say 'í•´•‰Æ≠ '+tlfr
  @ 3, 1 say 'ç†´Æ£.N '+str(nnr, 14)
  @ 3, col()+1 say 'ë•‡‚®‰. '+nsvr
  esc_r=0
  set cent off
  while (esc_r=0)
    sele ldkkln
    go top
    foot('ENTER,F3,F4,F5,F6,F7', 'è‡Æ¢Æ§™®,Å†≠™,íÆ¢†‡ ØÆ§‚¢,íÆ¢†‡ ¢ÎØ,è•Á†‚Ï,ÑÆ™„¨')
    /*      rcdklnr=slcf('ldkkln',4,,5,,"e:bs h:'ëÁ•‚' c:n(6) e:skl h:'ë™´.' c:n(4) e:dn h:'Ñ° ≠† ≠†Á.' c:n(10,2) e:kn h:'ä‡ ≠† ≠†Á.' c:n(10,2) e:db h:'Ñ•°•‚' c:n(10,2) e:kr h:'ä‡•§®‚' c:n(10,2) e:dp h:'Ñ° ≠† ™Æ≠' c:n(10,2) e:kp h:'ä‡ ≠† ™Æ≠' c:n(10,2)",,,,'kkl=kklr') */
    rcdklnr=slcf('ldkkln', 4,, 5,, "e:bs h:'ëÁ•‚' c:n(7) e:dn h:'Ñ° ≠† ≠†Á.' c:n(10,2) e:kn h:'ä‡ ≠† ≠†Á.' c:n(10,2) e:db h:'Ñ•°•‚' c:n(12,2) e:kr h:'ä‡•§®‚' c:n(12,2) e:dp h:'Ñ° ≠† ™Æ≠' c:n(10,2) e:kp h:'ä‡ ≠† ™Æ≠' c:n(10,2)",,,, 'kkl=kklr')
    sele ldkkln
    go rcdklnr
    dn_r=dn
    kn_r=kn
    db_r=db
    kr_r=kr
    dk_r=dp
    kk_r=kp
    bsr=bs
    sklr=skl
    do case
    case (lastkey()=13)
      sele dokk
      set orde to tag t10
      if (netseek('t10', 'kklr'))
        if (gnArm=2)
          rcdokkr=slcf('dokk', 4,, 15,, "e:mn h:'å†Ë.N' c:n(6) e:rnd h:'ê•£.N' c:n(6) e:nplp h:'Nè´†‚' c:n(6) e:rn h:'N Ø‡Æ¢' c:n(6) e:bs_d h:'Ñ°' c:n(6) e:bs_k h:'ä‡' c:n(6) e:bs_s h:'ë„¨¨†' c:n(10,2) e:ddk h:'Ñ†‚†' c:d(10) e:skl h:'ë™´' c:n(4) e:sk h:'Sk' c:n(3) e:kop h:'äéè' c:n(4) e:ksz h:'ëá' c:n(2)",,,, ;
                        'kkl=kklr', '(bs_d=bsr.or.bs_k=bsr).and.!prc'                                                                                                                                                                                                                                                   ;
                     )
        else
          rcdokkr=slcf('dokk', 4,, 15,, "e:rnd h:'ê•£.N' c:n(6) e:iif(dokk->bs_k=bsr,bs_d,bs_k) h:'Ñ°' c:n(6) e:iif(dokk->bs_k=bsr,getfield('t1','dokk->bs_d','bs','nbs'),getfield('t1','dokk->bs_k','bs','nbs')) h:'ëÁ•‚' c:c(20) e:bs_s h:'ë„¨¨†' c:n(10,2) e:ddk h:'Ñ†‚†' c:d(10) e:getfield('t1','dokk->mn,dokk->rnd','doks','osn') h:'ë„Ø•‡¢†©ß•‡' c:c(15)",,,, ;
                        'kkl=kklr', '(bs_d=bsr.or.bs_k=bsr).and.!prc.and.rnd#0'                                                                                                                                                                                                                                                                                       ;
                     )
        endif

        if (lastkey()=-32)// Ø‡Æ·¨Æ‚‡•‚Ï ¢·• ALT-F3
          netseek('t10', 'kklr')
          rcdokkr=slcf('dokk', 4,, 15,,                      ;
                        "e:TRANSFORM(prc,[Y]) h:' ' c:c(1) "+ ;
                        "e:kg   h:'äíé'        c:n(4,0) "+    ;
                        "e:mn h:'å†Ë.N' c:n(6) "+             ;
                        "e:rnd h:'ê•£.N' c:n(6) "+            ;
                        "e:rn h:'N §Æ™.' c:n(6) "+            ;
                        "e:bs_d h:'Ñ°' c:n(6) "+              ;
                        "e:bs_k h:'ä‡' c:n(6) "+              ;
                        "e:bs_s h:'ë„¨¨†' c:n(10,2) "+        ;
                        "e:ddk h:'Ñ†‚†' c:d(10) "+            ;
                        "e:skl h:'ë™´' c:n(4) "+              ;
                        "e:sk h:'Sk' c:n(3) "+                ;
                        "e:kop h:'äéè' c:n(4) "+              ;
                        "e:ksz h:'ëá' c:n(2)",,,,             ;
                        'kkl=kklr', '(bs_d=bsr.or.bs_k=bsr)'  ;
                     )

        endif

      endif

    case (lastkey()=-3)
      tovar()
    case (lastkey()=-4)
      tovarv()
    case (lastkey()=-5)
      kop_rr=0
      cldoks=setcolor('n/w,n/bg')
      wdoks=wopen(8, 20, 10, 60)
      wbox(1)
      @ 0, 1 say 'äÆ§ ÆØ•‡†Ê®®' get kop_rr pict '999'
      @ 0, col()+1 say '0-Ç·•'
      read
      wclose(wdoks)
      setcolor(cldoks)
      tovarv(1)
      tovar(1)
    case (lastkey()=-6)
      kklob()
    case (lastkey()=K_ESC)
      esc_r=1
    case (lastkey()=-2)   // Å†≠™
      klbank()
    /*         case lastkey()=-6 // Ñ•°
     *              debone(kklr)
     *              sele 0
     *              use deb
     *              kzr=kz
     *              dzr=dz
     *              pdzr=pdz
     *              pdz1r=pdz1
     *              pdz3r=pdz3
     *              set cent on
     *              @ 16,1 say dtoc(date())+' '+time()
     *              @ 17,1 say 'ä‡•§®‚Æ‡·™†Ô ß†§Æ´¶•≠≠Æ·‚Ï '+str(kzr,10,2)
     *              @ 18,1 say 'Ñ•°•‚Æ‡·™†Ô ß†§Æ´¶•≠≠Æ·‚Ï  '+str(dzr,10,2)
     *              @ 19,1 say ' >7§≠  '+str(pdzr,10,2)+' >14§≠  '+str(pdz1r,10,2)+' >21§≠  '+str(pdz3r,10,2)
     *              use
     */
    endcase

  enddo

enddo

set cent on
if (select('ldkkln')#0)
  sele ldkkln
  CLOSE
  erase ldkkln.dbf
endif

nuse()
rest scre from scodkp
setcolor(clodkp)

/***********************************************************
 * tovar() -->
 *   è†‡†¨•‚‡Î :
 *   ÇÆß¢‡†È†•‚:
 */
function tovar(p2)
  netuse('cskl')
  crtt('ldokk', 'f:sk c:n(3) f:ttn c:n(6) f:sdv c:n(10,2) f:mnp c:n(6) f:naid c:c(10) f:kop c:n(3) f:ddk  c:d(10) f:nnz c:c(9) f:dop c:d(10) f:fio c:c(20) f:sdv2 c:n(10,2) f:sdv3 c:n(10,2) f:nkkl c:n(7) f:ttn1c c:c(9) f:kta c:n(4) f:ktas c:n(4)')
  sele 0
  use ldokk
  inde on str(sk, 3)+str(ttn, 6) tag t1
  inde on fio+str(sk, 3)+str(ttn, 6) tag t2
  set orde to tag t1
  sele dokk
  /*set order to tag t5 */
  set order to tag t10
  go top
  rnr=0
  mnr1=0
  mnpr=0
  skr=0
  /*netseek('t5','kklr,mnr1') */
  netseek('t10', 'kklr')
  save scre to sctovar
  set cons on
  wmess('èÆ§‚¢•‡¶§•≠≠Î©...')
  set cons off
  /*do while kkl=kklr .and. mn=0 //   !eof() */
  while (kkl=kklr)
    if (mn#0)
      skip
      loop
    endif

    sele dokk
    if (prc)
      skip
      loop
    endif

    if (mn#0)
      skip
      loop
    endif

    if (kkl=447126.and.mnp=0.and.rn=630006)
      a=1
    endif

    if (bs_d=99.or.bs_k=99)
      skip
      loop
    endif

    if (!(mn=0.and.kkl=kklr.and.(bs_d=bsr.or.bs_k=bsr)))
      skip
      loop
    endif

    skr=sk
    rnr=rn
    sele ldokk
    /*   if rnr#rn.or.(rnr=rn .and. mnpr#mnp).or.(rnr=rn .and. skr#sk) */
    if (!netseek('t1', 'skr,rnr'))
      sele dokk
      mnpr=mnp
      kopr=kop
      if (kop_rr#0)
        if (kopr#kop_rr)
          skip
          loop
        endif

      endif

      ddkr=ddk
      dopr=ctod('')
      ktasr=ktas
      sele ldokk
      appe blank
      repl sk with skr, ttn with rnr, mnp with mnpr, kop with kopr, ddk with ddkr, ktas with ktasr
      if (mnpr=0)
        repl naid with 'ê†·ÂÆ§'
      else
        repl naid with 'è‡®ÂÆ§'
      endif

    endif

    sele dokk
    skip
  enddo

  sele ldokk
  go top
  sk_r=0
  while (!eof())
    if (sk#sk_r)
      skr=sk
      nuse('rs1')
      nuse('rs3')
      nuse('pr1')
      path_tr=getfield('t1', 'skr', 'cskl', 'path')
      pathr=gcPath_d+alltrim(path_tr)
      if (!netfile('rs1', 1))
        sele ldokk
        skip
        loop
      endif

      netuse('rs1',,, 1)
      netuse('rs3',,, 1)
      netuse('pr1',,, 1)
    endif

    sele ldokk
    ttnr=ttn
    ttn1cr=space(9)
    mnpr=mnp
    dopr=ctod('')
    store 0 to sdvr, sdv2r, sdv3r, ktar, nkklr
    store '' to nnzr, fior
    if (mnpr=0)
      sele rs1
      if (netseek('t1', 'ttnr'))
        sdvr=sdv
        nnzr=nnz
        dopr=dop
        ktar=kta
        ktasr=ktas
        if (fieldpos('nkkl')#0)
          nkklr=nkkl
        else
          nkklr=0
        endif

        if (nkklr=kklr)
          nkklr=0
        endif

        if (fieldpos('ttn1c')#0)
          ttn1cr=ttn1c
        else
          ttn1cr=space(9)
        endif

        fior=getfield('t1', 'ktar', 's_tag', 'fio')
        sdv2r=getfield('t1', 'ttnr,90', 'rs3', 'bssf')
        sdv3r=getfield('t1', 'ttnr,90', 'rs3', 'xssf')
      endif

    else
      ttn1cr=space(9)
      sele pr1
      if (netseek('t1', 'ttnr'))
        sdvr=sdv
        nnzr=nnz
        ktar=0
        ktasr=0
        fior=''
      endif

    endif

    sele ldokk
    repl sdv with sdvr, nnz with nnzr, dop with dopr, fio with fior, ktas with ktasr,    ;
     sdv2 with sdv2r, sdv3 with sdv3r, nkkl with nkklr, ttn1c with ttn1cr, kta with ktar
    if (sdv=0)
      netdel()
    endif

    sele ldokk
    skip
  enddo

  nuse('rs1')
  nuse('rs3')
  nuse('pr1')
  rest scre from sctovar
  ccp=1
  while (.t.)
    sele ldokk
    set orde to tag t2
    go top
    if (empty(p2))
      @ MAXROW()-1, 5 prompt' èêéëåéíê '
      @ MAXROW()-1, 25 prompt'  èÖóÄíú  '
      menu to ccp
      if (lastkey()=K_ESC)
        exit
      endif

    else
      ccp=2
    endif

    if (ccp=1)
      sele ldokk
      go top
      if (gnArm=2)
        slcf('ldokk',,,,, "e:sk h:'SK' c:n(3) e:getfield('t1','ldokk->sk','cskl','nskl') h:'ç†®¨•≠Æ¢†≠®•' c:c(19) e:ttn h:'ÑÆ™„¨' c:n(6) e:dop h:'Ñ†‚† Æ‚£‡.' c:d(10) e:ddk h:'Ñ†‚† ØÆ§‚¢' c:d(10) e:sdv h:'ë„¨¨†' c:n(10,2) e:naid h:'ÑÆ™„¨•≠‚'  c:c(10) e:kop h:'äéè' c:n(3)")
      else
        if (month(gdTd)=12.and.year(gdTd)=2005)
          if (kklr=20034.or.kklr=20540)
            slcf('ldokk',,,,, "e:sk h:'SK' c:n(3) e:ttn h:'ÑÆ™„¨' c:n(6) e:nkkl h:'ä´®•≠‚' c:n(7) e:dop h:'Ñ†‚† Æ‚£‡.' c:d(8) e:ddk h:'Ñ†‚† ØÆ§‚¢' c:d(8) e:sdv h:'ë„¨¨†' c:n(10,2) e:sdv2 h:'ë„¨¨†2' c:n(10,2) e:naid h:'Ñ'  c:c(1) e:kop h:'äéè' c:n(3) e:kta h:'KTA' c:n(4) e:ttn1c h:'TTN1C' c:c(9)")
          else
            slcf('ldokk',,,,, "e:sk h:'SK' c:n(3) e:ttn h:'ÑÆ™„¨' c:n(6) e:dop h:'Ñ†‚† Æ‚£‡.' c:d(8) e:ddk h:'Ñ†‚† ØÆ§‚¢' c:d(8) e:sdv h:'ë„¨¨†' c:n(10,2) e:sdv2 h:'ë„¨¨†2' c:n(10,2) e:naid h:'Ñ'  c:c(1) e:kop h:'äéè' c:n(3)  e:kta h:'KTA' c:n(4) e:ttn1c h:'TTN1C' c:c(9)")
          endif

        else
          if (kklr=20034.or.kklr=20540)
            slcf('ldokk',,,,, "e:sk h:'SK' c:n(3) e:ttn h:'ÑÆ™„¨' c:n(6) e:nkkl h:'ä´®•≠‚' c:n(7) e:dop h:'Ñ†‚† Æ‚£‡.' c:d(8) e:ddk h:'Ñ†‚† ØÆ§‚¢' c:d(8) e:sdv h:'ë„¨¨†' c:n(10,2) e:sdv2 h:'ë„¨¨†2' c:n(10,2) e:naid h:'Ñ'  c:c(1) e:kop h:'äéè' c:n(3) e:fio h:'Ä£•≠‚' c:c(14)")
          else
            slcf('ldokk',,,,, "e:sk h:'SK' c:n(3) e:ttn h:'ÑÆ™„¨' c:n(6) e:dop h:'Ñ†‚† Æ‚£‡.' c:d(8) e:ddk h:'Ñ†‚† ØÆ§‚¢' c:d(8) e:sdv h:'ë„¨¨†' c:n(10,2) e:sdv2 h:'ë„¨¨†2' c:n(10,2) e:naid h:'Ñ'  c:c(1) e:kop h:'äéè' c:n(3) e:fio h:'Ä£•≠‚' c:c(14)")
          endif

        endif

      endif

    else
      if (empty(p2))
        vedprn(1)
      else
        vedprn(5)
        exit
      endif

    endif

  enddo

  rest scre from sctovar
  if (select('ldokk')#0)
    sele ldokk
    CLOSE
  endif

  erase ldokk.dbf
  erase ldokk.cdx
  return (.t.)

/***********************************************************
 * tovarv
 *   è†‡†¨•‚‡Î:
 */
procedure tovarv(p2)
  save scre to sctovar
  netuse('cskl')
  crtt('ldokk', 'f:sk c:n(3) f:ttn c:n(6) f:sdv c:n(10,2) f:mnp c:n(6) f:naid c:c(10) f:kop c:n(3) f:dvp  c:d(10) f:dot c:d(10) f:dop c:d(10) f:fio c:c(20) f:sdv2 c:n(10,2) f:sdv3 c:n(10,2) f:nkkl c:n(7) f:ttn1c c:c(9) f:kta c:n(4) f:ktas c:n(4)')
  sele 0
  use ldokk
  inde on str(sk, 3)+str(ttn, 6) tag t1
  inde on fio+str(sk, 3)+str(ttn, 6) tag t2
  set orde to tag t1
  sele cskl
  go top
  set cons on
  wmess('ÇÎØ®·†≠≠Î©...')
  set cons off
  while (!eof())
    sele cskl
    if (ent#gnEnt.or.tpstpok#0.or.merch#0.or.arnd#0)
      skip
      loop
    endif

    skr=sk
    pathr=gcPath_d+alltrim(path)
    if (!file(pathr+'tprds01.dbf'))
      sele cskl
      skip
      loop
    endif

    netuse('rs1',,, 1)
    netuse('rs3',,, 1)
    sele rs1
    set order to tag t2
    go top
    /*   netseek('t2','kklr') */
    while (!eof())        // kpl=kklr
      if (prz=1)
        skip
        loop
      endif

      if (kop_rr#0)
        if (kop#kop_rr)
          skip
          loop
        endif

      endif

      if (kpl#kklr)
        if (fieldpos('nkkl')#0)
          if (nkkl#kklr)
            skip
            loop
          endif

        else
          skip
          loop
        endif

      endif

      ttnr=ttn
      if (fieldpos('ttn1c')#0)
        ttn1cr=ttn1c
      else
        ttn1cr=space(9)
      endif

      sdvr=sdv
      if (sdvr=0)
        skip
        loop
      endif

      kopr=kop
      naidr='ê†·ÂÆ§'
      dvpr=dvp
      dotr=dot
      dopr=dop
      ktar=kta
      ktasr=ktas
      kplr=kpl
      if (fieldpos('nkkl')#0)
        nkklr=nkkl
      else
        nkklr=0
      endif

      if (nkklr=kklr.and.nkklr#kplr)
        nkklr=kplr
      endif

      if (nkklr=kklr.and.nkklr=kplr)
        nkklr=0
      endif

      fior=getfield('t1', 'ktar', 's_tag', 'fio')
      sdv2r=getfield('t1', 'ttnr,90', 'rs3', 'bssf')
      sdv3r=getfield('t1', 'ttnr,90', 'rs3', 'xssf')
      sele ldokk
      appe blank
      repl sk with skr, ttn with ttnr, sdv with sdvr, dvp with dvpr, ktas with ktasr,      ;
       dot with dotr, naid with naidr, kop with kopr, dop with dopr, fio with fior,        ;
       sdv2 with sdv2r, sdv3 with sdv3r, nkkl with nkklr, ttn1c with ttn1cr, kta with ktar
      sele rs1
      skip
    enddo

    nuse('rs1')
    nuse('rs3')

    netuse('pr1',,, 1)
    sele pr1
    go top
    set order to tag t3
    netseek('t3', '0,kklr')
    while (otv=0.and.kps=kklr)//   !eof()
      if (kps#kklr.or.prz=1)
        skip
        loop
      endif

      ttnr=nd
      mnpr=mn
      sdvr=sdv
      if (sdvr=0)
        skip
        loop
      endif

      kopr=kop
      naidr='è‡®ÂÆ§'
      dvpr=dvp
      sele ldokk
      appe blank
      repl sk with skr, ttn with ttnr, mnp with mnpr, sdv with sdvr, dvp with dvpr, ;
       naid with naidr, kop with kopr
      sele pr1
      skip
    enddo

    nuse('pr1')

    sele cskl
    skip
  enddo

  nuse('rs1')
  nuse('pr1')

  rest scre from sctovar
  ccp=1
  while (.t.)
    sele ldokk
    set orde to tag t2
    go top
    if (empty(p2))
      @ MAXROW()-1, 5 prompt' èêéëåéíê '
      @ MAXROW()-1, col()+1 prompt'  èÖóÄíú  '
      menu to ccp
      if (lastkey()=K_ESC)
        exit
      endif

    else
      @ MAXROW()-1, 5 prompt' èêéëåéíê '
      @ MAXROW()-1, col()+1 prompt'  èÖóÄíú  '
      @ MAXROW()-1, col()+1 prompt' C èÖóÄíú  '
      menu to ccp
      if (lastkey()=K_ESC)
        exit
      endif

    endif

    if (ccp=1)
      sele ldokk
      go top
      if (gnArm=2)
        slcf('ldokk',,,,, "e:sk h:'SK' c:n(3) e:getfield('t1','ldokk->sk','cskl','nskl') h:'ç†®¨' c:c(18) e:ttn h:'ÑÆ™„¨' c:n(6) e:dvp h:'Ñ†‚† ¢ÎØ' c:d(10) e:dop h:'Ñ†‚† Æ‚.' c:d(10) e:sdv h:'ë„¨¨†' c:n(10,2) e:naid h:'ÑÆ™„¨'  c:c(6) e:kop h:'äéè' c:n(3)")
      else
        /*         slcf('ldokk',,,,,"e:sk h:'SK' c:n(3) e:getfield('t1','ldokk->sk','cskl','nskl') h:'ç†®¨' c:c(8) e:ttn h:'ÑÆ™„¨' c:n(6) e:dvp h:'Ñ†‚† ¢ÎØ' c:d(10) e:dop h:'Ñ†‚† Æ‚.' c:d(10) e:sdv h:'ë„¨¨†' c:n(10,2) e:naid h:'ÑÆ™„¨'  c:c(6) e:kop h:'äéè' c:n(3) e:fio h:'Ä£•≠‚' c:c(14)")
         *         if kklr=20034.or.kklr=20540
         */
        if (gnArm=3)
          if (month(gdTd)=12.and.year(gdTd)=2005)
            slcf('ldokk',,,,, "e:sk h:'SK' c:n(3) e:ttn h:'ÑÆ™„¨' c:n(6) e:nkkl h:'ä´®•≠‚' c:n(7) e:dvp h:'Ñ†‚† ¢ÎØ' c:d(8) e:dop h:'Ñ†‚† Æ‚.' c:d(8) e:sdv h:'ë„¨¨†' c:n(10,2) e:sdv2 h:'ë„¨¨†2' c:n(10,2) e:naid h:'Ñ'  c:c(1) e:kop h:'äéè' c:n(3)  e:kta h:'KTA' c:n(4) e:ttn1c h:'TTN1C' c:c(9)")
          else
            slcf('ldokk',,,,, "e:sk h:'SK' c:n(3) e:ttn h:'ÑÆ™„¨' c:n(6) e:nkkl h:'ä´®•≠‚' c:n(7) e:dvp h:'Ñ†‚† ¢ÎØ' c:d(8) e:dop h:'Ñ†‚† Æ‚.' c:d(8) e:sdv h:'ë„¨¨†' c:n(10,2) e:sdv2 h:'ë„¨¨†2' c:n(10,2) e:naid h:'Ñ'  c:c(1) e:kop h:'äéè' c:n(3) e:fio h:'Ä£•≠‚' c:c(14)")
          endif

        else
          slcf('ldokk',,,,, "e:sk h:'SK' c:n(3) e:ttn h:'ÑÆ™„¨' c:n(6) e:dvp h:'Ñ†‚† ¢ÎØ' c:d(8) e:dop h:'Ñ†‚† Æ‚.' c:d(8) e:sdv h:'ë„¨¨†' c:n(10,2) e:sdv2 h:'ë„¨¨†2' c:n(10,2) e:naid h:'Ñ'  c:c(1) e:kop h:'äéè' c:n(3) e:fio h:'Ä£•≠‚' c:c(14)")
        endif

      endif

    else
      if (ccp=2)
        if (empty(p2))
          vedprn(0)
        else
          vedprn(4)
          exit
        endif

      else
        if (empty(p2))
          vedprn(0, 1)
        else
          vedprn(4, 1)
          exit
        endif

      endif

    endif

  enddo

  rest scre from sctovar
  if (select('ldokk')#0)
    sele ldokk
    CLOSE
  endif

  erase ldokk.dbf
  erase ldokk.cdx
  return (.t.)

/***********************************************************
 * vedprn
 *   è†‡†¨•‚‡Î:
 */
procedure vedprn
  para p1, p2
  /*p1=1    - èÆ§‚¢•‡¶§•≠≠Î© ‚Æ¢†‡
   *p1=0    - ÇÎØ®·†≠≠Î© ‚Æ¢†‡
   */
  lstr=1
  rswr=1
  set cons on
  wmess(' Ç·‚†¢‚• ´®·‚ ® ≠†¶¨®‚• Ø‡Æ°•´', 0)
  set cons off
  if (p1#5)
    set cons off
    if (gnOut=2)
      set print to txt.txt
      set print on
      if (empty(gcPrn))
        ??chr(27)+chr(77)+chr(15)
      else
        ??chr(27)+'E'+chr(27)+'&l26a0O'+chr(27)+chr(27)+'(3R'+chr(27)+'(s0p15.00h0s1b4102T'+chr(27)// ä≠®¶≠†Ô Ä4
      endif

    else
      if (empty(p2))
        set print to lpt1
        set print on
        if (empty(gcPrn))
          ??chr(27)+chr(77)+chr(15)
        else
          ??chr(27)+'E'+chr(27)+'&l26a0O'+chr(27)+chr(27)+'(3R'+chr(27)+'(s0p15.00h0s1b4102T'+chr(27)// ä≠®¶≠†Ô Ä4
        endif

      else
        set print to lpt2
        set print on
        ??chr(27)+'E'+chr(27)+'&l26a0O'+chr(27)+chr(27)+'(3R'+chr(27)+'(s0p15.00h0s1b4102T'+chr(27)// ä≠®¶≠†Ô Ä4
      endif

    endif

  endif

  if (p1=1.or.p1=5)
    if (p1=5)
      ?' '
      ?' '
      ?'⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø'
      ?'≥ Ñ•°•‚ ç  ≥ ä‡•§®‚ ç ≥  Ñ•°•‚  ≥  ä‡•§®‚  ≥ Ñ•°•‚ ä  ≥ ä‡•§®‚ ä ≥'
      ?'√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¥ '
      ?str(dn_r, 10, 2)+' '+str(kn_r, 10, 2)+' '+str(db_r, 10, 2)+' '+str(kr_r, 10, 2)+' '+str(dk_r, 10, 2)+' '+str(kk_r, 10, 2)
      ?' '
    endif

    ?space(20)+'Ç•§Æ¨Æ·‚Ï ØÆ§‚¢•‡¶§•≠≠Æ£Æ ‚Æ¢†‡†'
  endif

  if (p1=0.or.p1=4)
    ?space(20)+'Ç•§Æ¨Æ·‚Ï   ¢ÎØ®·†≠≠Æ£Æ   ‚Æ¢†‡†'
  endif

  rsle1()

  if (p1#5)
    ?'ä´®•≠‚ '+str(kkl1r, 8)+'('+str(kklr, 7)+') '+nklr
    rsle1()
    ?'Ä§‡•·   '+adrr
    rsle1()
    ?'í•´•‰Æ≠ '+tlfr
    rsle1()
    ?'ç†´Æ£.N '+str(nnr, 14)
    rsle1()
    ?'ë•‡‚®‰. '+nsvr+space(35)+dtoc(date())+' '+time()
    ?'èÆ ·Á•‚„'+'  '+str(bsr, 6)
    rsle1()
  endif

  if (p1=1.or.p1=5)
    sh(1)
  endif

  if (p1=0.or.p1=4)
    sh(0)
  endif

  go top
  sdvpr=0
  sdvrr=0
  sdv2pr=0
  sdv2rr=0
  while (!eof())
    if (p1=1.or.p1=5)
      /*      ?str(sk,3)+' '+substr(getfield('t1','ldokk->sk','cskl','nskl'),1,20)+' '+str(ttn,6)+' '+dtoc(dop)+' '+dtoc(ddk)+' '+str(sdv,10,2)+' '+str(sdv2,10,2)+' '+ naid+' '+str(kop,3)+' '+fio
       *      ?str(sk,3)+' '+substr(fio,1,20)+' '+str(ttn,6)+' '+dtoc(dop)+' '+dtoc(ddk)+' '+str(sdv,10,2)+' '+str(sdv2,10,2)+' '+ left(naid,1)+' '+str(kop,3)
       *      ?' '+substr(fio,1,20)+' '+str(sk,3)+' '+str(ttn,6)+' '+ left(naid,1)+' '+str(kop,3)+' '+dtoc(dop)+' '+dtoc(ddk)+' '+str(sdv,10,2)+' '+str(sdv2,10,2)
       */
      ?' '+substr(fio, 1, 20)+' '+str(sk, 3)+' '+str(ttn, 6)+' '+ left(naid, 1)+' '+str(kop, 3)+' '+dtoc(dop)+' '+dtoc(ddk)+' '+str(sdv, 10, 2)+' '+ttn1c
    endif

    if (p1=0.or.p1=4)
      /*      ?str(sk,3)+' '+substr(getfield('t1','ldokk->sk','cskl','nskl'),1,20)+' '+ str(ttn,6)+' '+dtoc(dvp)+' '+ dtoc(dop)+' '+str(sdv,10,2)+' '+str(sdv2,10,2)+' '+naid+' '+str(kop,3)+' '+fio
       *      ?str(sk,3)+' '+substr(fio,1,20)+' '+ str(ttn,6)+' '+dtoc(dvp)+' '+ dtoc(dop)+' '+str(sdv,10,2)+' '+str(sdv2,10,2)+' '+left(naid,1)+' '+str(kop,3)+' '+fio
       */
      ?' '+substr(fio, 1, 20)+' '+str(sk, 3)+' '+str(ttn, 6)+' '+ left(naid, 1)+' '+str(kop, 3)+' '+dtoc(dvp)+' '+dtoc(dop)+' '+str(sdv, 10, 2)+' '+str(sdv2, 10, 2)+' '+ttn1c
    endif

    if (left(naid, 1)='ê')
      sdvrr=sdvrr+sdv
      sdv2rr=sdv2rr+sdv2
    else
      sdvpr=sdvpr+sdv
      sdv2pr=sdv2pr+sdv2
    endif

    rsle1()
    skip
  enddo

  ?' '+'à‚Æ£Æ ‡†·ÂÆ§'+space(8)+' '+space(3)+' '+space(6)+' '+space(1)+' '+space(3)+' '+space(8)+' '+space(8)+' '+str(sdvrr, 10, 2)+' '+str(sdv2rr, 10, 2)
  rsle1()
  ?' '+'à‚Æ£Æ Ø‡®ÂÆ§'+space(8)+' '+space(3)+' '+space(6)+' '+space(1)+' '+space(3)+' '+space(8)+' '+space(8)+' '+str(sdvpr, 10, 2)+' '+str(sdv2pr, 10, 2)
  rsle1()

  if (p1=5)
    ?' '
    rsle1()

    ?' è‡ÆØ´†‚Î'
    rsle1()
    sele dokk
    /*   set orde to tag t5 */
    set orde to tag t10

    /*   if netseek('t5','kklr') */
    if (netseek('t10', 'kklr'))
      while (kkl=kklr)
        if (!(bs_k=bsr.and.prc=.f.).or.bs_d=99.or.bs_k=99)
          sele dokk
          skip
          loop
        endif

        if (rnd=0)
          skip
          loop
        endif

        ktasr=ktas
        if (ktasr#0)
          nktar=str(ktasr, 4)+' '+getfield('t1', 'ktasr', 's_tag', 'fio')
        else
          osnr=getfield('t1', 'dokk->mn,dokk->rnd', 'doks', 'osn')
          posr=at(':', osnr)
          if (posr#0)
            ktar=val(subs(osnr, posr+1, 3))
            nktar=str(ktar, 3)+' '+getfield('t1', 'ktar', 's_tag', 'fio')
          else
            nktar=osnr
          endif

        endif

        ?str(rnd, 6)+' '+str(bs_d, 6)+' '+getfield('t1', 'dokk->bs_d', 'bs', 'nbs')+' '+str(bs_s, 10, 2)+' '+dtoc(ddk)+' '+nktar
        rsle1()
        sele dokk
        skip
      enddo

    endif

  endif

  if (p1#4)
    eject
    /*
    set print off
    set print to
    set devi to screen
    */
    ClosePrintFile()
  endif

  return

/***********************************************************
 * rsle1
 *   è†‡†¨•‚‡Î:
 */
procedure rsle1(p2)
  rswr++
  if (rswr>=60)
    rswr=1
    lstr++
    eject
    if (p2=nil)
      /*      set devi to scre
       *      save scre to scmess
       */
      set cons on
      wmess('Ç·‚†¢‚• ´®·‚ ® ≠†¶¨®‚• Ø‡Æ°•´', 0)
      set cons off
      /*      rest scre from scmess
       *      set devi to print
       */
      sh(p1)
    endif

  endif

  return

/***********************************************************
 * sh
 *   è†‡†¨•‚‡Î:
 */
procedure sh
  para p1
  ?'                                                                        ã®·‚'+str(lstr)
  if (p1=1)
    ?'⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒ¬ƒƒƒƒƒƒ¬ƒ¬ƒƒƒ¬ƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø'
    ?'≥       Ä£•≠‚        ≥ë™´≥ ÑÆ™„¨≥Ñ≥äéè≥Ñ†‚† Æ‚£≥Ñ†‚† ØÆ§≥   ë„¨¨†  ≥  ë„¨¨†2  ≥'
    ?'¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒ¡ƒƒƒƒƒƒ¡ƒ¡ƒƒƒ¡ƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒŸ'
  else
    ?'⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒ¬ƒƒƒƒƒƒ¬ƒ¬ƒƒƒ¬ƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø'
    ?'≥       Ä£•≠‚        ≥ë™´≥ ÑÆ™„¨≥Ñ≥äéè≥Ñ†‚† ¢ÎØ≥Ñ†‚† Æ‚£≥   ë„¨¨†  ≥  ë„¨¨†2  ≥'
    ?'¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒ¡ƒƒƒƒƒƒ¡ƒ¡ƒƒƒ¡ƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒŸ'
  endif

  /*if p1=1
   *   ?'⁄ƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒ¬ƒƒƒø'
   *   ?'≥SK≥       Ä£•≠‚        ≥ ÑÆ™„¨≥Ñ†‚† Æ‚£‡.≥Ñ†‚† ØÆ§‚¢≥   ë„¨¨†  ≥  ë„¨¨†2  ≥Ñ≥äéè≥'
   *   ?'¿ƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¡ƒ¡ƒƒƒŸ'
   *else
   *   ?'⁄ƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒ¬ƒƒƒø'
   *   ?'≥SK≥       Ä£•≠‚        ≥ ÑÆ™„¨≥Ñ†‚† ¢ÎØ. ≥ Ñ†‚† Æ‚. ≥   ë„¨¨†  ≥  ë„¨¨†2  ≥Ñ≥äéè≥'
   *   ?'¿ƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¡ƒ¡ƒƒƒŸ'
   *endif
   */
  return

/***********************************************************
 * vodkp() -->
 *   è†‡†¨•‚‡Î :
 *   ÇÆß¢‡†È†•‚:
 */
function vodkp
  /* ÇÎØ®·†≠Î©
   * èÆ§‚¢•‡¶§•≠≠Î©
   * Ñ•≠Ï£®
   */
  return (.t.)

/***********************************************************
 * klbank() -->
 *   è†‡†¨•‚‡Î :
 *   ÇÆß¢‡†È†•‚:
 */
function klbank()
  crtt('klbank', 'f:ddc c:d(10) f:mfo c:c(6) f:nmfo c:c(12) f:nplp c:n(6) f:ssd c:n(12,2) f:bosn c:c(100) f:rnd c:n(6)')
  sele 0
  use klbank excl
  inde on dtos(ddc)+str(rnd, 6) tag t1
  store 0 to ssdor
  sele doks
  go top
  while (!eof())
    if (kkl#kklr)
      skip
      loop
    endif

    mnr=mn
    ddcr=ddc
    ssdr=ssd
    if (fieldpos('bosn')#0)
      bosnr=bosn
    else
      bosnr=space(80)
    endif

    nplpr=nplp
    rndr=rnd
    sele dokz
    if (!netseek('t2', 'mnr'))
      sele doks
      skip
      loop
    endif

    bsr=bs
    sele mfochk
    if (netseek('t1', 'gnKln_c,bsr'))
      mfor=mfo
    else
      sele doks
      skip
      loop
    endif

    cmfor='000'+mfor
    nmfor=getfield('t1', 'cmfor', 'banks', 'otb')
    sele klbank
    locate for ddc=ddcr.and.mfo=mfor.and.rnd=rndr
    if (!foun())
      appe blank
      repl ddc with ddcr, mfo with mfor, nmfo with nmfor, rnd with rndr, ;
       nplp with nplpr, ssd with ssdr, bosn with bosnr
      ssdor=ssdor+ssdr
    endif

    sele doks
    skip
  enddo

  save scre to scklbank
  sele klbank
  go top
  rcklbankr=recn()
  fldnomr=1
  while (.t.)
    foot('', '')
    sele klbank
    go rcklbankr
    rcklbankr=slce('klbank', 1, 1, 18,, "e:ddc h:'Ñ†‚†' c:d(10) e:nmfo h:'ç†®¨•≠Æ¢†≠®•' c:·(12) e:nplp h:'èè' c:n(6) e:ssd h:'ë„¨¨†' c:n(12,2) e:bosn h:'é·≠Æ¢†≠®•' c:c(80)",,,,,,, 'Å†≠™®'+' '+str(ssdor, 12, 2), 0, 0)
    if (lastkey()=K_ESC)
      exit
    endif

    sele klbank
    go rcklbankr
    do case
    case (lastkey()=19)   // Left
      fldnomr=fldnomr-1
      if (fldnomr=0)
        fldnomr=1
      endif

    case (lastkey()=4)    // Right
      fldnomr=fldnomr+1
    endcase

  enddo

  rest scre from scklbank
  sele klbank
  CLOSE
  erase klbank.dbf
  erase klbank.cdx
  return (.t.)

/***********************************************************
 * odkpg() -->
 *   è†‡†¨•‚‡Î :
 *   ÇÆß¢‡†È†•‚:
 */
function odkpg()
  netuse('bs')
  netuse('kln')
  sele dir
  copy stru to stemp exte
  sele 0
  use stemp excl
  zap
  appe blank
  repl field_name with 'BS', ;
   field_type with 'C',      ;
   field_len with 6,         ;
   field_dec with 0
  appe blank
  repl field_name with 'NBS', ;
   field_type with 'C',       ;
   field_len with 30,         ;
   field_dec with 0
  for i=1 to 12
    appe blank
    repl field_name with 'DB'+alltrim(str(i, 2)), ;
     field_type with 'N',                             ;
     field_len with 12,                               ;
     field_dec with 2
    appe blank
    repl field_name with 'KR'+alltrim(str(i, 2)), ;
     field_type with 'N',                             ;
     field_len with 12,                               ;
     field_dec with 2
    appe blank
    repl field_name with 'nprd'+alltrim(str(i, 2)), ;
     field_type with 'C',                               ;
     field_len with 6,                                  ;
     field_dec with 0
  next

  CLOSE
  create odkpg from stemp
  CLOSE
  erase stemp.dbf
  sele 0
  use odkpg excl
  inde on bs tag t1

  if (month(gdTd)=12)
    gg1=year(gdTd)
    gg2=gg1
  else
    gg1=year(gdTd)-1
    gg2=year(gdTd)
  endif

  while (.t.)
    sele odkpg
    zap
    clea
    kklr=0
    @ 0, 1 say 'äÆ§ ™´®•≠‚†' get kklr pict '9999999'
    read
    if (lastkey()=K_ESC)
      exit
    endif

    if (kklr=0)
      kklr=slct_kl(10, 1, 12)
    endif

    if (kklr=0)
      loop
    endif

    nklr=getfield('t1', 'kklr', 'kln', 'nkl')
    nklr=alltrim(nklr)
    kk=0
    for g=gg1 to gg2
      do case
      case (gg1=gg2)
        mm1=1
        mm2=12
      case (g=gg2)
        mm1=1
        mm2=month(gdTd)
      case (g=gg1)
        mm1=month(gdTd)+1
        mm2=12
      endcase

      for m=mm1 to mm2
        kk=kk+1
        nprdr=g*100+m
        cdbr='db'+alltrim(str(kk, 2))
        ckrr='kr'+alltrim(str(kk, 2))
        cnprdr='nprd'+alltrim(str(kk, 2))
        sele odkpg
        locate for bs='àíéÉé:'
        if (!foun())
          appe blank
          repl bs with 'àíéÉé:'
        endif

        repl &cnprdr with str(nprdr, 6)
        nuse('dkkln')
        nuse('dknap')
        pathr=gcPath_e+'g'+str(g, 4)+'\m'+iif(m<10, '0'+str(m, 1), str(m, 2))+'\bank\'
        if (!netfile('dkkln', 1))
          loop
        endif

        mess(pathr)
        netuse('dknap',,, 1)
        netuse('dkkln',,, 1)
        if (netseek('t1', 'kklr'))
          while (kkl=kklr)
            bsr=bs
            dbr=db
            krr=kr
            sele odkpg
            locate for bs=str(bsr, 6)
            if (!foun())
              appe blank
              repl bs with str(bsr, 6)
            endif

            repl &cdbr with dbr,          ;
             &ckrr with krr,              ;
             &cnprdr with str(nprdr, 6)
            sele dkkln
            skip
          enddo

        endif

        nuse('dkkln')
        nuse('dknap')
      next

    next

    sele odkpg
    locate for bs='àíéÉé:'
    rcnr=recn()
    for i=1 to 12
      cdbr='db'+alltrim(str(i, 2))
      ckrr='kr'+alltrim(str(i, 2))
      cnprdr='nprd'+alltrim(str(i, 2))
      go rcnr
      nprdr=&cnprdr
      go top
      store 0 to dbr, krr
      while (!eof())
        if (bs#'àíéÉé:')
          dbr=dbr+&cdbr
          krr=krr+&ckrr
          repl &cnprdr with nprdr
        else
          repl &cdbr with dbr, ;
           &ckrr with krr
        endif

        skip
      enddo

    next

    clea
    sele odkpg
    go top
    while (!eof())
      if (isdigit(subs(bs, 1, 1)))
        bsr=val(bs)
        nbsr=getfield('t1', 'bsr', 'bs', 'nbs')
        sele odkpg
        repl nbs with nbsr
      endif

      sele odkpg
      skip
    enddo

    go top
    fldnomr=1
    rcodkpgr=recn()
    while (.t.)
      sele odkpg
      go rcodkpgr
      /*      rcodkpgr=slce('odkpg',,,,,"e:bs h:'ëóÖí' c:c(6) e:nbs h:'ç†®¨•≠Æ¢†≠®•' c:c(30) e:db1 h:'Ñ° '+odkpg->nprd1 c:n(12,2) e:kr1 h:'ä‡ '+odkpg->nprd1 c:n(12,2) e:db2 h:'Ñ° '+odkpg->nprd2 c:n(12,2) e:kr2 h:'ä‡ '+odkpg->nprd2 c:n(12,2) e:db3 h:'Ñ° '+odkpg->nprd3 c:n(12,2) e:kr3 h:'ä‡ '+odkpg->nprd3 c:n(12,2) e:db4 h:'Ñ° '+odkpg->nprd4 c:n(12,2) e:kr4 h:'ä‡ '+odkpg->nprd4 c:n(12,2) e:db5 h:'Ñ° '+odkpg->nprd5 c:n(12,2) e:kr5 h:'ä‡ '+odkpg->nprd5 c:n(12,2) e:db6 h:'Ñ° '+odkpg->nprd6 c:n(12,2) e:kr6 h:'ä‡ '+odkpg->nprd6 c:n(12,2) e:db7 h:'Ñ° '+odkpg->nprd7 c:n(12,2) e:kr7 h:'ä‡ '+odkpg->nprd7 c:n(12,2) e:db8 h:'Ñ° '+odkpg->nprd8 c:n(12,2) e:kr8 h:'ä‡ '+odkpg->nprd8 c:n(12,2) e:db9 h:'Ñ° '+odkpg->nprd9 c:n(12,2) e:kr9 h:'ä‡ '+odkpg->nprd9 c:n(12,2) e:db10 h:'Ñ° '+odkpg->nprd10 c:n(12,2) e:kr10 h:'ä‡ '+odkpg->nprd10 c:n(12,2) e:db11 h:'Ñ° '+odkpg->nprd11 c:n(12,2) e:kr11 h:'ä‡ '+odkpg->nprd11 c:n(12,2) e:db12 h:'Ñ° '+odkpg->nprd12 c:n(12,2) e:kr12 h:'ä‡ '+odkpg->nprd12 c:n(12,2)",,,,,,,,1,2) */
      rcodkpgr=slce('odkpg', 1, 1, 18,, "e:bs h:'ëóÖí' c:c(6) e:nbs h:'ç†®¨•≠Æ¢†≠®•' c:c(30) e:db1 h:'Ñ° '+odkpg->nprd1 c:n(12,2) e:kr1 h:'ä‡ '+odkpg->nprd1 c:n(12,2) e:db2 h:'Ñ° '+odkpg->nprd2 c:n(12,2) e:kr2 h:'ä‡ '+odkpg->nprd2 c:n(12,2) e:db3 h:'Ñ° '+odkpg->nprd3 c:n(12,2) e:kr3 h:'ä‡ '+odkpg->nprd3 c:n(12,2) e:db4 h:'Ñ° '+odkpg->nprd4 c:n(12,2) e:kr4 h:'ä‡ '+odkpg->nprd4 c:n(12,2) e:db5 h:'Ñ° '+odkpg->nprd5 c:n(12,2) e:kr5 h:'ä‡ '+odkpg->nprd5 c:n(12,2) e:db6 h:'Ñ° '+odkpg->nprd6 c:n(12,2) e:kr6 h:'ä‡ '+odkpg->nprd6 c:n(12,2) e:db7 h:'Ñ° '+odkpg->nprd7 c:n(12,2) e:kr7 h:'ä‡ '+odkpg->nprd7 c:n(12,2) e:db8 h:'Ñ° '+odkpg->nprd8 c:n(12,2) e:kr8 h:'ä‡ '+odkpg->nprd8 c:n(12,2) e:db9 h:'Ñ° '+odkpg->nprd9 c:n(12,2) e:kr9 h:'ä‡ '+odkpg->nprd9 c:n(12,2) e:db10 h:'Ñ° '+odkpg->nprd10 c:n(12,2) e:kr10 h:'ä‡ '+odkpg->nprd10 c:n(12,2) e:db11 h:'Ñ° '+odkpg->nprd11 c:n(12,2) e:kr11 h:'ä‡ '+odkpg->nprd11 c:n(12,2) e:db12 h:'Ñ° '+odkpg->nprd12 c:n(12,2) e:kr12 h:'ä‡ '+odkpg->nprd12 c:n(12,2)",,,,,,, nklr, 1, 1)
      if (lastkey()=K_ESC)
        exit
      endif

      go rcodkpgr
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

  enddo

  nuse()
  nuse('odkpg')
  erase odkpg.dbf
  erase odkpg.cdx
  return (.t.)

/************** */
function kklopl()
  /************** */
  clea
  netuse('dokz')
  netuse('doks')
  netuse('dokk')
  netuse('kln')
  netuse('kpl')
  netuse('nap')
  netuse('s_tag')
  sele dbft
  copy stru to skklopl exte
  sele 0
  use skklopl excl
  zap
  appe blank
  repl field_name with 'BS', ;
   field_type with 'N',      ;
   field_len with 6,         ;
   field_dec with 0
  appe blank
  repl field_name with 'KKL', ;
   field_type with 'N',       ;
   field_len with 7,          ;
   field_dec with 0
  appe blank
  repl field_name with 'NKL', ;
   field_type with 'C',       ;
   field_len with 40,         ;
   field_dec with 0
  appe blank
  repl field_name with 'SSD', ;
   field_type with 'N',       ;
   field_len with 10,         ;
   field_dec with 2
  appe blank
  repl field_name with 'RND', ;
   field_type with 'N',       ;
   field_len with 6,          ;
   field_dec with 0
  appe blank
  repl field_name with 'DDC', ;
   field_type with 'D',       ;
   field_len with 10,         ;
   field_dec with 0
  appe blank
  repl field_name with 'nap', ;
   field_type with 'N',       ;
   field_len with 1,          ;
   field_dec with 0
  appe blank
  repl field_name with 'bosn', ;
   field_type with 'C',        ;
   field_len with 100,         ;
   field_dec with 0
  appe blank
  repl field_name with 'osn', ;
   field_type with 'C',       ;
   field_len with 20,         ;
   field_dec with 0
  sele nap
  go top
  while (!eof())
    napr=nap
    nnapr=nnap
    sele skklopl
    appe blank
    repl field_name with 'SM'+str(napr, 1), ;
     field_type with 'N',                     ;
     field_len with 12,                       ;
     field_dec with 2
    sele nap
    skip
  enddo

  sele skklopl
  CLOSE
  create kklopl from skklopl
  CLOSE
  sele 0
  use kklopl excl
  inde on str(bs, 6)+str(kkl, 7)+str(rnd, 6) tag t1
  store gdTd to ddc1r, ddc2r
  bs_r=0
  nrzr=0
  while (.t.)
    cldoks=setcolor('n/w,n/bg')
    wdoks=wopen(8, 20, 12, 60)
    wbox(1)
    @ 0, 1 say 'è•‡®Æ§ ·' get ddc1r
    @ 0, col()+1 say 'ØÆ' get ddc2r
    @ 1, 1 say 'ëÁ•‚    ' get bs_r pict '999999'
    @ 2, 1 say 'ç•‡†ß≠. ' get nrzr pict '9'
    read
    wclose(wdoks)
    setcolor(cldoks)
    if (lastkey()=K_ESC)
      exit
    endif

    sele kklopl
    zap
    sele dokz
    go top
    while (!eof())
      if (!(int(bs/1000)=301.or.int(bs/1000)=311))
        skip
        loop
      endif

      if (ddc<ddc1r.or.ddc>ddc2r)
        skip
        loop
      endif

      if (bs_r#0)
        if (bs#bs_r)
          skip
          loop
        endif

      endif

      mnr=mn
      bsr=bs
      ddcr=ddc
      sele doks
      if (netseek('t1', 'mnr'))
        while (mn=mnr)
          if (prz#0)
            skip
            loop
          endif

          if (!(prfrm=0.and.getfield('t1', 'doks->kkl', 'kpl', 'tzdoc')#0))
            skip
            loop
          endif

          kklr=kkl
          nklr=getfield('t1', 'kklr', 'kln', 'nkl')
          ssdr=ssd
          napr=nap
          rndr=rnd
          bosnr=bosn
          osnr=osn
          sele kklopl
          appe blank
          repl bs with bsr, ;
           kkl with kklr,   ;
           nkl with nklr,   ;
           nap with napr,   ;
           ssd with ssdr,   ;
           rnd with rndr,   ;
           ddc with ddcr,   ;
           bosn with bosnr, ;
           osn with osnr
          sele dokk
          if (netseek('t1', 'mnr,rndr'))
            while (mn=mnr.and.rnd=rndr)
              if (bs_k#361001)
                skip
                loop
              endif

              napr=nap
              smr=bs_s
              csmr='sm'+str(napr, 1)
              sele kklopl
              netrepl(csmr, 'smr')
              sele dokk
              skip
            enddo

          endif

          sele doks
          skip
        enddo

      endif

      sele dokz
      skip
    enddo

    sele kklopl
    go top
    rckor=recn()
    fldnomr=1
    while (.t.)
      sele kklopl
      go rckor
      foot('F4,F5', 'äÆ‡‡,è•Á†‚Ï')
      rckor=slce('kklopl',,,,, "e:kkl h:'äÆ§' c:n(7) e:nkl h:'ç†®¨•≠Æ¢†≠®•' c:c(20) e:nap h:'ç'c:n(1) e:ssd h:'ë„¨¨†' c:n(10,2) e:sm0 h:'ë„¨¨†0' c:n(10,2) e:sm1 h:'ë„¨¨†1' c:n(10,2) e:sm2 h:'ë„¨¨†2' c:n(10,2) e:sm3 h:'ë„¨¨†3' c:n(10,2) e:bs h:'ëÁ•‚' c:n(6) e:rnd h:'ê•£.N' c:n(6) e:ddc h:'Ñ†‚†' c:d(10) e:bosn h:'Å†≠™ é·≠' c:c(100) e:osn h:'Å„Â é·≠' c:c(20)",,,,, "(sm0+sm1+sm2+sm3#0).and.iif(nrzr#0,ssd=sm0,.t.)",, 'éØ´†‚Î',, 1)
      if (lastkey()=K_ESC)
        exit
      endif

      go rckor
      sm0r=sm0
      sm1r=sm1
      sm2r=sm2
      sm3r=sm3
      ssdr=ssd
      do case
      case (lastkey()=19) // Left
        fldnomr=fldnomr-1
        if (fldnomr=0)
          fldnomr=1
        endif

      case (lastkey()=4)  // Right
        fldnomr=fldnomr+1
      case (lastkey()=-3)
        clcr=setcolor('n/w,n/bg')
        wcr=wopen(8, 20, 16, 60)
        wbox(1)
        @ 0, 1 say 'Ç·•£Æ '+' '+str(ssdr, 10, 2)
        @ 1, 1 say 'ë„¨¨†0' get sm0r pict '9999999.99'
        @ 1, col()+1 say 'ç•ÆØ‡•§•´•≠Æ'
        @ 2, 1 say 'ë„¨¨†1' get sm1r pict '9999999.99'
        @ 2, col()+1 say 'É†·‚‡Æ≠Æ¨®Ô'
        @ 3, 1 say 'ë„¨¨†2' get sm2r pict '9999999.99'
        @ 3, col()+1 say 'ë´†¢„‚®Á'
        @ 4, 1 say 'ë„¨¨†3' get sm3r pict '9999999.99'
        @ 4, col()+1 say 'äÆß†Ê™†Ô ‡Æß¢†£†'
        read
        wclose(wcr)
        setcolor(clcr)
        if (lastkey()=13)
          if (ssdr#sm0r+sm1r+sm2r+sm3r)
            wmess('ç•·Æ¢Ø†§•≠®• ·„¨¨', 2)
          else
            netrepl('sm0,sm1,sm2,sm3', 'sm0r,sm1r,sm2r,sm3r')
          endif

        endif

      case (lastkey()=-4) // è•Á†‚Ï
        prnopl()
      endcase

    enddo

  enddo

  nuse()
  nuse('kklopl')
  return (.t.)

/************** */
function prnopl()
  /************** */
  if (gnOut=1)
    alpt={ 'lpt1', 'lpt2', 'lpt3', 'î†©´' }
    vlpt=alert('è‡®≠‚•‡', alpt)
    if (lastkey()=K_ESC)
      return (.t.)
    endif

    if (vlpt<4)
      cvlptr='lpt'+str(vlpt, 1)
      set prin to &cvlptr
    else
      set prin to kklopl.txt
    endif

  else
    set prin to kklopl.txt
  endif

  set cons off
  set prin on
  if (!empty(gcPrn))
    ?chr(27)+'E'+chr(27)+'&l1h26a0O'+chr(27)+chr(27)+'(3R'+chr(27)+'(s0p21.00h0s0b4099T'+chr(27)// ä≠®¶≠†Ô Ä4
  else
    ?chr(27)+chr(77)+chr(15)
  endif

  sele kklopl
  go top
  ?'⁄ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒø'
  ?'≥'+' ëÁ•‚ '+'≥'+'  äÆ§  '+'≥'+'    ç†®¨•≠Æ¢†≠®•    '+'≥'+'   Ñ†‚†   '+'≥'+'ç•ÆØ‡•§•´•≠Æ'+'≥'+'É†·‚‡Æ≠Æ¨®Ô '+'≥'+'  ë´†¢„‚®Á  '+'≥'+'äÆß ‡Æß¢†£† '+'≥'+'ê•£.N '+'≥'
  ?'√ƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒ¥'

  while (!eof())
    if (sm0+sm1+sm2+sm3=0)
      skip
      loop
    endif

    if (bs_r#0)
      if (bs#bs_r)
        skip
        loop
      endif

    endif

    ?'≥'+str(bs, 6)+'≥'+str(kkl, 7)+'≥'+subs(nkl, 1, 20)+'≥'+dtoc(ddc)+'≥'+str(sm0, 12, 2)+'≥'+str(sm1, 12, 2)+'≥'+str(sm2, 12, 2)+'≥'+str(sm3, 12, 2) +'≥'+str(rnd, 6)+'≥'
    skip
  enddo

  set prin off
  set cons on
  set prin to txt.txt
  return (.t.)

/***********************************************************
 * cghj() -->
 *   è†‡†¨•‚‡Î :
 *   ÇÆß¢‡†È†•‚:
 */
function cghj()
  sele doks
  set orde to tag t1
  if (netseek('t1', 'mnr'))
    while (mn=mnr)
      kklr=kkl
      nklr=getfield('t1', 'kklr', 'kln', 'nkl')
      ssdr=ssd
      ddcr=ddc
      sele doks
      skip
    enddo

  endif

  sele doks
  if (netseek('t1', 'mnr'))
    rcdoksr=recn()
    fldnomr=1
    while (.t.)
      sele doks
      go rcdoksr
      set cent off
      foot('F5', 'è•Á†‚Ï')
      rcdoksr=slce('doks',,,,, "e:rnd h:'ê•£.N' c:n(6) e:ssd h:'ë„¨¨†' c:n(10,2) e:asum(doks->prz,doks->mn,doks->rnd) h:'ë„¨¨†è' c:n(10,2) e:nplp h:'N §Æ™.' c:n(6) e:ddc  h:'Ñ†‚†' c:d(8) e:getfield('t1','doks->kkl','kln','nkl') h:'ä´®•≠‚' c:c(30) e:kkl h:'äÆ§' c:n(7) e:nap h:'ç†Ø‡' c:n(4) e:auto h:'A' c:n(1) e:nchek h:'ó•™' c:n(6) e:bosn h:'é·≠Æ¢†≠®•' c:c(70)",,,, 'mn=mnr', "prfrm=0.and.getfield('t1','doks->kkl','kpl','tzdoc')#0",, 'éØ´†‚Î',, 1)
      set cent on
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

  return (.t.)

/************** */
function kklob()
  /************** */
  crtt('tkklob', 'f:ddk c:d(10) f:mn c:n(6) f:rnd c:n(6) f:sk c:n(3) f:rn c:n(6) f:mnp c:n(6) f:bs_s c:n(12,2) f:osn c:c(40) f:grp c:n(1)')
  sele 0
  use tkklob
  inde on str(mn, 6)+str(rnd, 6) tag t1
  inde on str(sk, 3)+str(rn, 6)+str(mnp, 6) tag t2
  inde on str(grp, 1)+str(rnd, 6)+dtos(ddk) tag t3
  sele dokk
  set orde to tag t10
  if (netseek('t10', 'kklr'))
    while (kkl=kklr)
      if (!(bs_d=bsr.or.bs_k=bsr))
        skip
        loop
      endif

      mnr=mn
      rndr=rnd
      skr=sk
      rnr=rn
      mnpr=mnp
      ddkr=ddk
      bs_sr=bs_s
      bs_dr=bs_d
      bs_kr=bs_k
      nplpr=nplp
      kopr=kop
      osnr=''
      ktar=kta
      ktasr=ktas
      if (mnr#0)
        if (int(bs_d/1000)=301.or.int(bs_d/1000)=311)
          if (int(bs_k/1000)=301)
            osnr=getfield('t1', 'mnr,rndr', 'doks', 'osn')
          else
            osnr=getfield('t1', 'mnr,rndr', 'doks', 'bosn')
          endif

        endif

        sele tkklob
        if (!netseek('t1', 'mnr,rndr'))
          appe blank
          repl mn with mnr, ;
           rnd with bs_dr,  ;
           rn with nplpr,   ;
           ddk with ddkr,   ;
           bs_s with bs_sr, ;
           osn with osnr,   ;
           grp with 1
        endif

        repl bs_s with bs_s+bs_sr
      else
        osnr=str(kopr, 3)+' '+alltrim(getfield('t1', 'ktasr', 's_tag', 'fio'))
        sele tkklob
        if (!netseek('t2', 'skr,rnr,mnpr'))
          appe blank
          repl sk with skr, ;
           rn with rnr,     ;
           mnp with mnpr,   ;
           ddk with ddkr,   ;
           bs_s with bs_sr, ;
           osn with osnr
          if (mnpr=0)
            repl grp with 2
          else
            repl grp with 3
          endif

        endif

        repl bs_s with bs_s+bs_sr
      endif

      sele dokk
      skip
    enddo

  endif

  sele tkklob
  set orde to tag t3
  go top
  rctkklobr=recn()
  while (.t.)
    sele tkklob
    go rctkklobr
    rctkklobr=slcf('tkklob', 4,, 15,, "e:rnd h:'ëÁ•‚' c:n(6) e:ddk h:'Ñ†‚†' c:d(10) e:sk h:'ë™´' c:n(3) e:rn h:'ÑÆ™„¨' c:n(6) e:mnp h:'è‡®ÂÆ§' c:n(6) e:bs_s h:'ë„¨¨†' c:n(10,2) e:osn h:'é·≠Æ¢†≠®•' c:c(30)",,,,,,, str(bsr, 6))
    if (lastkey()=K_ESC)
      exit
    endif

  enddo

  sele tkklob
  CLOSE
  return (.t.)
