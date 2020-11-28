*Бланк строгой отчетности 1-й лист
  save scre to scbso
  mess('Вставте бланк строгой отчетности в принтер',1)
  rest scre from scbso
  set cons off
  set prin to
  set prin on
  ??chr(27)+chr(18)
  *??chr(27)+chr(67)+chr(33)
  ??chr(27)+chr(77)
  ??chr(27)+chr(51)+chr(43)
  ??chr(27)+chr(56)
  ??chr(27)+chr(74)+chr(15)
  set devi to prin
  @ 1,5 say gcName_c
  @ 4,20 say gnKln_c
  @ 8,55 say iif(!empty(dotr),dtous(dotr,4,8,1),dtous(dvpr,4,8,1))
  ??chr(27)+chr(74)+chr(25)
  ??chr(27)+chr(51)+chr(65)

  ??chr(27)+chr(15)
  @ 9,40 say alltrim(gcName_c)+' '+alltrim(gcAdr_c)+' МФО-'+Right(gnBank_c,6)+;
          ' '+alltrim(gcNbank_c)+' p/p '+alltrim(gcScht_c)
  ??chr(27)+chr(18)
  @ 9,1 say ''
  @ 9,120 say str(gnKln_c,8)


  private nkplr,nkgpr,pladrr,gpadrr,plbankr,gpbankr,plnbankr,gpnbankr,;
          plschtr,gpschtr
  store 0 to plbankr,gpbankr
  store '' to nkplr,nkgpr,pladrr,gpadrr,plnbankr,gpnbankr,plschtr,gpschtr

  sele kln
  if netseek('t1','kplr')
     nkplr=nkl
     pladrr=adr
     plbankr=kb1
     plschtr=ns1
     sele banks
     if netseek('t1','plbankr')
        plnbankr=otb
     endif
  endif
  if kplr=kgpr
     nkgpr=nkplr
     gpadrr=pladrr
     gpbankr=plbankr
     gpschtr=plschtr
     gpnbankr=plnbankr
  else
     sele kln
     if netseek('t1','kgpr')
        nkgpr=nkl
        gpadrr=adr
        gpbankr=kb1
        gpschtr=ns1
        sele banks
        if netseek('t1','gpbankr')
           gpnbankr=otb
        endif
     endif
  endif
  ??chr(27)+chr(15)
  @ 10,35 say alltrim(nkplr)+' '+alltrim(pladrr)+' МФО-'+alltrim(plbankr)+;
          ' '+alltrim(plnbankr)+' p/p '+alltrim(plschtr)
  ??chr(27)+chr(18)
  @ 10,1 say ''
  @ 10,120 say str(kplr,7)

  ??chr(27)+chr(15)
  @ 11,35 say alltrim(nkgpr)+' '+alltrim(gpadrr)+' МФО-'+alltrim(gpbankr)+;
          ' '+alltrim(gpnbankr)+' p/p '+alltrim(gpschtr)
  ??chr(27)+chr(18)
  @ 11,1 say ''
  @ 11,120 say str(kgpr,7)


  @ 12,12 say 'рахунок - фактура N '+str(ttnr,6)+' вiд '+dtoc(dvpr)
  @ 13,12 say textr
  @ 16,1 say ''
  ??chr(27)+chr(74)+chr(50)
  ??chr(27)+chr(51)+chr(43)
  sele rs2
  netseek('t1','ttnr')
  n_r=17
  do while ttn=ttnr.and.n_r<33        //34
     ktlr=ktl
     kvpr=kvp
     zenr=zen
     svpr=svp
     sele tov
     netseek('t1','sklr,ktlr')
     natr=nat
     keir=kei
     neir=nei
     @ n_r,14 say natr
     @ n_r,61 say str(ktlr,7)
     @ n_r,72 say str(kei,4)
     @ n_r,82 say nei
     @ n_r,85 say str(kvpr,10,3)
     @ n_r,94 say str(kvpr,10,3)
     @ n_r,106 say str(zenr,10,3)
     @ n_r,123 say str(svpr,10,2)
     n_r++
     sele rs2
     skip
  enddo
  @ 0,0 say ''
  ??chr(27)+chr(57)
  @ 0,0 say ''
  set cons on
  set devi to scre
  mess('Переверните бланк и нажмите пробел',1)
  rest scre from scbso
  return

**************
func BsoLod()
  **************
  ??chr(27)+'E'
  ??chr(27)+"&l1X" //количество копий
  ??chr(27)+"&l2S" //Дуплекс
  ??chr(27)+chr(56)         // Вырубить конец бумаги
  //??chr(27)+'&l4h' // выбор лотка
  ??chr(27)+'&l26a1O'+chr(27)+'&l6E'+chr(27)+'&l14.3C'+chr(27)+'&l5D'+chr(27)+'(3R'+chr(27)+'(s0p18.00h0s3b4099T'+chr(27)
  // 1-й лист ccr=14.3  ddr=5

  flst()
  slst()

  return .t.

***********
func flst()
  * 1-й лист
  ***********

  // ?space(57)+repl('d',4)+space(4)+''+repl('m',18)+space(3)+repl('g',4)
  ?space(57)+padc(str(day(dotr),2),4,' ')+' '+space(4)+''+padr(umonth(dotr,1),15,' ')+space(5)+padr(subs(dtos(dotr),3,2),4,' ')+space(33)+str(rs1->mrsh,6)
  // ?space(27)+repl('a',60)+space(26)+repl('p',20)
  atranr=getfield('t2','rs1->mrsh','cmrsh','atran')
  natranr=alltrim(getfield('t1','atranr','atran','natran'))
  ?space(27)+padr(natranr+' '+getfield('t2','rs1->mrsh','cmrsh','anom'),60,'')+space(26)+space(20) //repl('p',20)
  // ?space(27)+repl('x',40)+space(26)+''+repl('y',40)+space(10)+repl('v',30)
  ?space(27)+repl(' ',40)+space(26)+' '+subs(getfield('t1','kplr','kln','nkl'),1,40)+space(10)+getfield('t2','rs1->mrsh','cmrsh','dfio')
  // ?space(27)+repl('ot',20)
  ?space(27)+alltrim(gcName_c)+' '+alltrim(getfield('t1','gnKkl_c','kln','adr'))+' МФО '+alltrim(getfield('t1','gnKkl_c','kln','kb1'))+' р/р '+alltrim(getfield('t1','gnKkl_c','kln','ns1'))+' ОКПО '+str(getfield('t1','gnKkl_c','kln','kkl1'),12)
  // ?space(27)+repl('ot',20)

  cKlnLic:=cKlnLic('gnKkl_c,gnKkl_c')
  ?space(27)+'Лицензия N '+cKlnLic+' '+dtoc(getfield('t1','gnKkl_c,gnKkl_c','klnlic','dnl'))
  // *?space(27)+repl('pol',20)
  ?space(27)+alltrim(getfield('t1','kplr','kln','nkl'))+' '+alltrim(getfield('t1','kplr','kln','adr'))+' МФО '+alltrim(getfield('t1','kplr','kln','kb1'))+' р/р '+alltrim(getfield('t1','kplr','kln','ns1'))+' ОКПО '+str(getfield('t1','kplr','kln','kkl1'),12)
  // *?space(27)+repl('pol',20)
  cKlnLic:=cKlnLic('kplr,kgpr')
  ?space(27)+'Лицензия N '+cKlnLic+' '+dtoc(getfield('t1','kplr,kgpr','klnlic','dnl'))
  // *?space(38)+repl('pz',30)+space(28)+repl('pr',30)
  ?space(38)+iif(gnEntRm=0,subs(getfield('t1','gnKkl_c','kln','nkl'),1,20)+' '+subs(getfield('t1','gnKkl_c','kln','adr'),1,39),subs(getfield('t1','gnKklrm','kln','nkl'),1,20)+' '+subs(getfield('t1','gnKklrm','kln','nkl'),1,39))+space(24)+alltrim(getfield('t1','kgpr','kln','nkl'))+' '+alltrim(getfield('t1','kgpr','kln','adr'))

  ??chr(27)+'&l12.5C'+chr(27)+'&l5D'

  for i=1 to 6
      ?''
  next

  ??chr(27)+'&l16.0C'+chr(27)+'&l6D'

  // ?space(45)+repl('m',34)
  // просчет док-та
  kvpr:=0
  svpr:=0
  vesr:=0
  kvpLic0:=0
  nRecSumMax:=1

  sele prs2
  Calc_prs2()
  outlog(3,__FILE__,__LINE__,'kvpLic0',kvpLic0)
  If kvpLic0 = 0 // нет лицензионного товара

    sm43r=getfield('t1', 'rs1->ttn,43', 'rs3', 'ssf')// округление
    sele prs2
    DBGoTo(nRecSumMax)

    outlog(3,__FILE__,__LINE__,sm43r,'sm43r',svp)

    repl svp with svp + sm43r
    svpr += sm43r

    outlog(3,__FILE__,__LINE__,'svp',svp)
  EndIf

  ?space(45)+padc(str(vesr,11,3),34,' ')
  ?'' //space(45)+repl('m',34)

  ??chr(27)+'&l13.7C'+chr(27)+'&l5D'

  // ?space(47)+repl('k',34)+space(22)+repl('s',60)
  // ?space(47)+space(34)+space(22)+numstr(svpr)
  ndssvpr=roun(svpr*1.2,2)
  ?space(47)+padc(str(kvpr,10,0),34,' ')+space(22)+numstr(ndssvpr)
  // ?space(26)+repl('n',97)+space(19)+repl('s',40)
  akzr=svpr*0.01
  ?space(26)+padr(str(roun(svpr*1.2,2)-svpr,10,2),97,' ')+space(19)+str(akzr,10,2)+' грн'
  // ?space(55)+repl('h',65)
  ?space(55)+space(65)+space(40)+' ТТН '+str(rs1->ttn,6)
  // ?space(33)+repl('b',68)
  ?space(33)+str(vesr,11,3)
  // ?space(35)+repl('e',84)
  kecsr=getfield('t2','rs1->mrsh','cmrsh','kecs')
  ?space(35)+getfield('t1','kecsr','s_tag','fio')

  ??chr(27)+'&l9.5C'+chr(27)+'&l5D'
  for i=1 to 5
      ?''
  next
  return .t.

***********
func slst()
  * 2-й лист
  ***********
  ??chr(27)+'&l9.5C'+chr(27)+'&l5D'
  for i=1 to 4
      ?''
  next
  sele prs2
  prs2i=1
  go top
  do while !eof()
     if int(mntov/10000)>1
        ktlr=ktl
        mntovr=mntov
        kg_r=int(mntovr/10000)
        licr=getfield('t1','kg_r','sgrp','lic')
        if licr=0
           sele prs2
           skip
           loop
        endif
        sele prs2
        kvp_r=kvp
        svp_r=svp
        zenr=zen
        sele tov
        netseek('t1','sklr,ktlr')
        upakr=upak
        vespr=vesp
        ksertr=ksert
        if ksertr=0
           ksertr=getfield('t1','sklr,mntovr','tovm','ksert')
        endif
        if ksertr=0
           ksertr=getfield('t1','mntovr','ctov','ksert')
        endif
        nsertr=getfield('t1','ksertr','sert','nsert')
        dtsertr=getfield('t1','ksertr','sert','dt1')
        ?space(12)+' '+str(prs2i,4,0)+' '+subs(nat,1,29)+' '+str(vespr,11,3)+' '+padr(nsertr,21,' ')+' '+padc(dtoc(dtsertr),14)+' '+str(upakr,10,3)+' '+str(kvp_r,10)+' '+padc(str(zenr,10,3),14,' ')+' '+padc(str(roun(svp_r*1.2,2),10,2),13)+' '+repl(' ',13)+' '+repl(' ',11)+' '+repl(' ',9)
        prs2i=prs2i+1
     endif
     sele prs2
     skip
  enddo
  for i=prs2i to 21
      ?''
  *    ?space(12)+' '+repl('a',4)+' '+repl('b',29)+' '+repl('c',11)+' '+repl('d',21)+' '+repl('e',14)+' '+repl('m',10)+' '+repl('f',10)+' '+repl('j',14)+' '+repl('h',13)+' '+repl('k',13)+' '+repl('l',11)+' '+repl('n',9)
  next
  ?space(12)+' '+repl(' ',4)+' '+repl(' ',29)+' '+repl(' ',11)+' '+repl(' ',21)+' '+repl(' ',14)+' '+repl(' ',10)+' '+str(kvpr,10)+' '+repl(' ',14)+' '+str(roun(svpr*1.2,2),13,2)+' '+repl(' ',13)+' '+repl(' ',11)+' '+repl(' ',9)
  ?space(12)+' '+repl(' ',4)+' '+repl(' ',29)+' '+repl(' ',11)+' '+repl(' ',21)+' '+repl(' ',14)+' '+repl(' ',10)+' '+repl(' ',10)+' '+repl(' ',14)+' '+str(roun(svpr*1.2,2)-svpr,13,2)+' '+repl(' ',13)+' '+repl(' ',11)+' '+repl(' ',9)
  return .t.

**************
func bso1tn()
  **************
  ??chr(27)+'E'
  ??chr(27)+"&l1X" //количество копий
  ??chr(27)+"&l2S" //Дуплекс
  ??chr(27)+chr(56)         // Вырубить конец бумаги
  // ??chr(27)+'&l4h26a1O'+chr(27)+'&l6E'+chr(27)+'&l14.3C'+chr(27)+'&l5D'+chr(27)+'(3R'+chr(27)+'(s0p18.00h0s3b4099T'+chr(27)  // 1-й лист ccr=14.3  ddr=5
  // ??chr(27)+'&l4h26a1O'+chr(27)+'&l6E'+chr(27)+'&l14.3C'+chr(27)+'&l8D'+chr(27)+'(3R'+chr(27)+'(s0p18.00h0s3b4099T'+chr(27)  // 1-й лист ccr=14.3  ddr=5
  // ??chr(27)+'&l4h
  ??chr(27)+'&l26a1O'+chr(27)+'&l1E'+chr(27)+'&l14.3C'+chr(27)+'&l8D'+chr(27)+'(3R'+chr(27)+'(s0p16.00h0s3b4099T'+chr(27)+'&a1L'+chr(27)  // 1-й лист ccr=14.3  ddr=5

  flst1()
  slst1()

  return .t.

***********
func flst1()
  * 1-й лист
  ***********
  LOCAL   cSerlic,  cKlnLic


  ?'1 прим.-вiдправнику'+space(50)+'ТОВАРО-ТРАНСПОРТНА НАКЛАДНА      '+space(38)+'Затведжено наказом Мiнiстерства'
  ?'2 прим.-одержувачу '+space(50)+'НА ПЕРЕМIЩЕННЯ АЛКОГОЛЬНИХ НАПОЇВ '+space(38)+'транспорту та звязку України'
  dddr='"'+padc(str(day(dotr),2),2,' ')+'"'+' '+''+padr(umonth(dotr,1),11,' ')+' '+str(year(dotr),4)+'р                       '+space(5)+space(21)+'вiд 28 квiтня 2005р. N154'
  // dddr='"'+padc(str(day(dotr),2),2,' ')+'"'+' '+''+padr(umonth(dotr,1),11,' ')+' '+str(year(dotr),4)+'р.до дорожнього листа N '+str(mrshr,6)+space(21)+'вiд 28 квiтня 2005р. N154'
  ?'3 прим.-перевизнику'+space(50)+dddr
  ?'4 прим.-перевизнику'+space(30)+space(33)+space(58)+'Форма N 1-ТН /алкогольнi напої/'
  // ?'N '+str(rs1->ttn,6)
  ?''
  // ?'Серия 00 АААА N000 000'

  navtokklr=''
  avtokkl1r=0
  avtokklr=0
  svczr=0
  if mrshr#0
     sele cmrsh
     if netseek('t2','mrshr')
        dfior=alltrim(dfio)
        katranr=katran
        vsvbr=vsvb
        kecsr=kecs
        if fieldpos('svcz')#0
           svczr=svcz
        else
           svczr=0
        endif
        if gnEnt=20.and.(kopr=169.or.gnEntRm=1.and.svczr=0)
           dfior=''
           atnomr=''
           vsvbr=0
           anomr=''
           avtokklr=0
           navtokklr=''
           avtokkl1r=0
           mrshr=0
           necsr=''
        else
           if katranr#0
              sele kln
              if netseek('t1','katranr')
                 natranr=alltrim(nkl)
                 dfior=alltrim(adr)
                 anomr=alltrim(nkls)
                 atnomr=natranr+' '+anomr
                 avtokklr=kklp
                 navtokklr=''
                 avtokkl1r=0
              else
                 dfior=''
                 atnomr=''
                 vsvbr=0
                 anomr=''
                 avtokklr=0
                 navtokklr=''
                 avtokkl1r=0
              endif
           endif
        endif
     else
        dfior=''
        atnomr=''
        vsvbr=0
        anomr=''
        avtokklr=0
        navtokklr=''
        avtokkl1r=0
     endif
  else
     if gnArnd#0
        kecsr=rs1->kecs
        if katranr=0
           dfior=''
           atnomr=rs1->atnom
           vsvbr=0
           anomr=''
           avtokklr=0
           navtokklr=''
           avtokkl1r=0
        else
           sele kln
           if netseek('t1','katranr')
              natranr=alltrim(nkl)
              dfior=alltrim(adr)
              anomr=alltrim(nkls)
              atnomr=natranr+' '+anomr
              avtokklr=kklp
              navtokklr=''
              avtokkl1r=0
           else
              dfior=''
              atnomr=''
              vsvbr=0
              anomr=''
              avtokklr=0
              navtokklr=''
              avtokkl1r=0
           endif
        endif
     else
        dfior=''
        atnomr=''
        vsvbr=0
        kecsr=0
        anomr=''
        avtokklr=0
        navtokklr=''
        avtokkl1r=0
     endif
  endif

  ?'Автомобiль '+padc(atnomr,40)+' '+'Причiп/напивпричiп'+' вiдсутнiй'+space(45) //+' '+'Вид перевезень'+' '+'за кiлометровим тарифом'
  if kplr=3048721
     ?space(11)+repl('─',40)+' '+space(18)+' '+repl('─',40)
     ?space(11)+padc('(марка,державний номер,тип)',40)+' '+space(18)+' '+padc('(марка,державний номер,тип)',40)
  else
     ?''
     ?''
  endif
  if empty(navtokklr)
     ?'Перевiзник'+' '+subs(gcName_c,1,30)+' '+'Замовник(плaтник)'+' '+alltrim(gcName_c)+' '+'Водiй'+' '+dfior
     if kplr=3048721
        ?space(10)+' '+repl('─',len(subs(gcName_c,1,30)))+' '+space(17)+' '+repl('─',len(alltrim(gcName_c)))+' '+space(5)+' '+repl('─',len("(призвiще,iм'я,по батьковi,номер посвiдчення)"))
        ?space(10)+' '+padc('(найменування)',len(subs(gcName_c,1,30)))+' '+space(17)+' '+padc('(найменування)',len(alltrim(gcName_c)))+' '+space(5)+' '+"(призвiще,iм'я,по батьковi,номер посвiдчення)"
     else
  //      ?''
        ?''
     endif
  else
     if kplr=3048721
        ?'Перевiзник'+' '+subs(gcName_c,1,30)+' '+'Замовник(плaтник)'+alltrim(navtokklr)+' '+'Водiй'+' '+dfior
        ?space(10)+' '+repl('─',len(subs(gcName_c,1,30)))+' '+space(17)+' '+repl('─',len(alltrim(navtokklr)))+' '+space(5)+' '+repl('─',len("(призвiще,iм'я,по батьковi,номер посвiдчення)"))
        ?space(10)+' '+padc('(найменування)',len(subs(gcName_c,1,30)))+' '+space(17)+' '+padc('(найменування)',len(alltrim(navtokklr)))+' '+space(5)+' '+"(призвiще,iм'я,по батьковi,номер посвiдчення)"
     else
  //      ?''
        ?''
     endif
  endif
  *?''
  ?'Вiдправник'+' '+alltrim(getfield('t1','gnKkl_c','kln','nklprn'))+' '+alltrim(getfield('t1','gnKkl_c','kln','adr'))
  if kplr=3048721
     ?space(10)+' '+repl('─',166)
     ?space(10)+' '+"(повне найменування,мiсцезнаходження,банкiвськi реквiзити,iдентiфiкацiйний код,номер i дата видачi лiцензiї на провадження певного виду дiяльностi)"
  else
     ?''
  //    ?''
  endif
  ?'          '+' МФО '+alltrim(getfield('t1','gnKkl_c','kln','kb1'));
  +' р/р '+alltrim(getfield('t1','gnKkl_c','kln','ns1'));
  +' ОКПО '+str(getfield('t1','gnKkl_c','kln','kkl1'),12)+' '

  // лицензия поиск
  numlicr:=getfield('t1','gnKkl_c,gnKkl_c','klnlic','numlic')
  serlicr:=getfield('t1','gnKkl_c,gnKkl_c','klnlic','serlic')
  dnlr:=getfield('t1','gnKkl_c,gnKkl_c','klnlic','dnl')

  cKlnLic:=cKlnLic1(numlicr,serlicr)

  ??'Лицензия N '+ cKlnLic +' '+dtoc(dnlr)


  if kplr=3048721
     ?space(10)+' '+repl('─',166)
  else
     ?''
  endif
  ?'Одержувач '+' '+alltrim(getfield('t1','kplr','kln','nklprn'))+alltrim(getfield('t1','kplr','kln','adr'))
  if kplr=3048721
     ?space(10)+' '+repl('─',166)
     ?space(10)+' '+"(повне найменування,мiсцезнаходження,банкiвськi реквiзити,iдентiфiкацiйний код,номер i дата видачi лiцензiї на провадження певного виду дiяльностi)"
  else
  *   ?''
     ?''
  endif
  ?'          '+' МФО '+alltrim(getfield('t1','kplr','kln','kb1'));
  +' р/р '+alltrim(getfield('t1','kplr','kln','ns1'));
  +' ОКПО '+str(getfield('t1','kplr','kln','kkl1'),12)+' '


  // лицензия поиск последней
  sele klnlic
  if netseek('t1','kplr,kgpr')
     do while kkl=kplr.and.kgp=kgpr
        numlicr=numlic;        serlicr=serlic;        dnlr=dnl
        skip
     enddo
  endif

  cKlnLic:=cKlnLic1(numlicr,serlicr)

  ??'Лицензия N '+ cKlnLic +' '+dtoc(dnlr)

  if kplr=3048721
     ?space(10)+' '+repl('─',166)
  else
     ?''
  endif
  ?'Пункт навантаження'+' '+iif(gnEntRm=0,subs(getfield('t1','gnKkl_c','kln','nkl'),1,20)+' '+subs(getfield('t1','gnKkl_c','kln','adr'),1,39),subs(getfield('t1','gnKklrm','kln','nkl'),1,20)+' '+subs(getfield('t1','gnKklrm','kln','nkl'),1,39))+' '+'Пункт розвантаження'+' '+alltrim(getfield('t1','kgpr','kln','nkl'))+' '+alltrim(getfield('t1','kgpr','kln','adr'))
  if kplr=3048721
     ?space(18)+' '+repl('─',60)+' '+space(19)+' '+repl('─',len(alltrim(getfield('t1','kgpr','kln','nkl'))+' '+alltrim(getfield('t1','kgpr','kln','adr'))))
     ?space(18)+' '+padc('(назва,мiсце знаходження)',60)+' '+space(19)+' '+padc('(назва,мiсце знаходження)',len(alltrim(getfield('t1','kgpr','kln','nkl'))+' '+alltrim(getfield('t1','kgpr','kln','adr'))))
  else
  //   ?''
     ?''
  endif
  ?'Вiдпуск за довiренiстю одержувача серiя_________________N________________вiд "______"________________20_____р.'
  ?''
  ?'виданою_________________________________________________________________________________________________________________________________________________________________________'
  ?''
  ?'Вантаж одержав__________________________________________________________________________________________________________________________________________________________________'
  ?space(50)+'(посада,П.I.П.,пiдпис)'

  sele prs2
  kvpr:=0
  svpr:=0
  vesr:=0
  kvpLic0:=0
  nRecSumMax:=1

  Calc_prs2()
  outlog(3,__FILE__,__LINE__,'kvpLic0',kvpLic0)
  If kvpLic0 = 0 // нет лицензионного товара
    sm43r=getfield('t1', 'rs1->ttn,43', 'rs3', 'ssf')// округление
    sele prs2
    DBGoTo(nRecSumMax)

    outlog(3,__FILE__,__LINE__,sm43r,'sm43r',svp)

    repl svp with svp + sm43r
    svpr += sm43r

    outlog(3,__FILE__,__LINE__,'svp',svp)
  EndIf

  vesr=roun(rs1->vsv,0)
  akzr=svpr*0.01
  ndssvpr=roun(svpr*1.2,2)
  ?''
  ?space(70)+'ВАНТАЖНО-РОЗВАНТАЖУВАЛЬНI ОПЕРАЦIЇ'
  if kplr=3048721
  else
     ?''
  endif
  ?'┌─────────────────────┬───────────────────┬─────────────────────────────────────────────────────────────────┬───────────────────────────────────────────────────────────────────┐'
  ?'│                     │                   │                      Час (год.,хв.)                             │                                                                   │'
  ?'│       Операцiя      │    Маса бруто, кг ├───────────────────┬─────────────────────────┬───────────────────┤                   Пiдпис вiдповiдальної особи                     │'
  ?'│                     │                   │    прибуття       │        вибуття          │     простою       │                                                                   │'
  ?'├─────────────────────┼───────────────────┼───────────────────┼─────────────────────────┼───────────────────┼───────────────────────────────────────────────────────────────────┤'
  ?'│          1          │         2         │         3         │            4            │         5         │                              6                                    │'
  ?'├─────────────────────┼───────────────────┼───────────────────┼─────────────────────────┼───────────────────┼───────────────────────────────────────────────────────────────────┤'
  ?'│   Навантаження      │'+str(vesr,19,0)+'│       08:00       │         08:20           │                   │                                                                   │'
  ?'├─────────────────────┼───────────────────┼───────────────────┼─────────────────────────┼───────────────────┼───────────────────────────────────────────────────────────────────┤'
  ?'│   Розвантаження     │                   │                   │                         │                   │                                                                   │'
  ?'└─────────────────────┴───────────────────┴───────────────────┴─────────────────────────┴───────────────────┴───────────────────────────────────────────────────────────────────┘'
   // ?''
  /*
  *??chr(27)+'&l12.5C'+chr(27)+'&l5D'
  *
  *for i=1 to 6
  *    ?''
  *next
  *
  *??chr(27)+'&l16.0C'+chr(27)+'&l6D'
   */
  kecsr=getfield('t2','rs1->mrsh','cmrsh','kecs')
  ?'Усього вiдпущено в кiлькостi'+' '+padc(str(kvpr,10,0),34,' ')+' '+'на загальну суму'+' '+numstr(ndssvpr)
  if kplr=3048721
     ?space(28)+' '+repl('─',len(padc(str(kvpr,10,0),34,' ')))+' '+space(16)+' '+repl('─',len(numstr(ndssvpr)))
     ?space(28)+' '+space(len(padc(str(kvpr,10,0),34,' ')))+' '+space(16)+' '+padc('(словами з урахуванням суми ПДВ та АЗ)',len(numstr(ndssvpr)))
  else
     ?''
  endif
  ?'у т.ч. ПДВ'+' '+str(roun(svpr*1.2,2)-svpr,10,2)+' '+',акцизний податок'+' '+str(getfield('t1','ttnr,13','rs3','ssf'),10,2)
  if kplr=3048721
     ?space(10)+' '+repl('─',len(str(roun(svpr*1.2,2)-svpr,10,2)))+' '+space(17)+' '+repl('─',len(str(getfield('t1','ttnr,13','rs3','ssf'),10,2)))
  else
     ?''
  endif
  aaa=numstr(kvpr,1)
  bbb=82-34-len(aaa)-2
  ?'Вантаж (пломба N),кiлькiсть мiсць'+space(10)+','+aaa+space(87-len('Вантаж (пломба N),кiлькiсть мiсць'+space(10)+','+aaa))+'Супровiднi документи'+' Видаткова накладна N '+str(rs1->ttn,6)+' '+dtoc(rs1->dop)+repl('_',31)
  if kplr=3048721
     if len(aaa)<9
        ?space(33)+repl('─',10)+' '+repl('─',9)
        ?space(33)+' '+space(10)+' '+padc('(словами)',9)
     else
        ?space(33)+repl('─',10)+' '+repl('─',len(aaa))
        ?space(33)+' '+space(10)+' '+padc('(словами)',len(aaa))
     endif
  else
     ?''
  endi
  vvv=numstr(int(vesr),1) //+','+lower(numstr(mod(vesr,1)*100,1))+' сотих'
  ?'масою брутто,кг'+' '+vvv+space(87-len('масою брутто,кг'+' '+vvv))+'для перевезення'+repl('_',75)
  if kplr=3048721
     ?space(15)+' '+repl('─',len(vvv))
     ?space(15)+' '+padc('(словами)',len(vvv))
  else
     ?''
     ?''
  endif
  necsr=alltrim(getfield("t1","kecsr","s_tag","fio"))
  lnecsr=len(necsr)
  ?'Водiй - eкспедитор'+' '+necsr+repl('_',62-lnecsr)+space(6)+repl('_',90)
  if kplr=3048721
     ?space(30)+'(посада,ПIБ,пiдпис)'
  else
     ?space(50)+'(пiдпис)'
  endif
  ?'Бухгалтер (вiдповiдальна особа)'+repl('_',50)+space(6)+repl('_',90)
  ?space(50)+'(пiдпис)'
  ?'Вiдпуск дозволив '+repl('_',64)+space(6)+repl('_',90)
  ?space(50)+'(пiдпис,печатка)'
  if kplr#3048721
     for i=1 to 7
         ?''
     next
  endif
  /*
  *?space(55)+space(65)+space(40)+' ТТН '+str(rs1->ttn,6)

  *?space(45)+padc(str(vesr,11,3),34,' ')
  *?'' //space(45)+repl('m',34)

  *??chr(27)+'&l13.7C'+chr(27)+'&l5D'

  *?space(47)+repl('k',34)+space(22)+repl('s',60)
  *?space(47)+space(34)+space(22)+numstr(svpr)
  *?space(47)+padc(str(kvpr,10,0),34,' ')+space(22)+numstr(ndssvpr)
  *?space(26)+repl('n',97)+space(19)+repl('s',40)
  *?space(26)+padr(str(roun(svpr*1.2,2)-svpr,10,2),97,' ')+space(19)+str(akzr,10,2)+' грн'
  *?space(55)+repl('h',65)
  *?space(33)+repl('b',68)
  *?space(33)+str(vesr,11,3)
  *?space(35)+repl('e',84)
  *kecsr=getfield('t2','rs1->mrsh','cmrsh','kecs')
  *?space(35)+getfield('t1','kecsr','s_tag','fio')

  *??chr(27)+'&l9.5C'+chr(27)+'&l5D'
  *for i=1 to 5
  *    ?''
  *next
  */
  return .t.

***********
func slst1()
  * 2-й лист
  ***********
  ??chr(27)+'(s0p18.00h0s3b4099T'+chr(27)  // 1-й лист ccr=14.3  ddr=5
  *??chr(27)+'&l9.5C'+chr(27)+'&l5D'
  *??chr(27)+'&l9.5C'+chr(27)+'&l5D'
  *for i=1 to 4
  *    ?''
  *next
  ?space(135)+'Зворотнiй бiк форми N 1-ТН /алкогольнi напоиї/'
  ?space(90)+'BIДОМОСТI ПРО ВАНТАЖ'
  ?space(12)+'┌────┬─────────────────────────────┬───────────┬─────────────────────┬────────────────┬──────────┬──────────┬────────────┬─────────────┬─────────────┬───────────┬────────┐'
  ?space(12)+'│ N  │     Назва продукцiї         │ Мiсткiсть │ Рєєстрацiйний номер │  Дата видачи   │Кiлькiсть │ Загальна │Цiна без ПДВ│  Вартiсть   │Бiй,нестача, │ Фактично  │Складенi│'
  ?space(12)+'│з/п │                             │  одиницi  │     сертифiката     │  сертифiката   │  мiсць   │кiлькiсть │за одиницю  │  вантажу    │некондицiя   │ отримано  │  акти  │'
  ?space(12)+'│    │                             │   (тари)  │  вiдповiдaльностi   │вiдповiдальности│          │ одиниць  │   грн      │  з ПДВ,грн  │(кiлькiсть   │ вантажу,  │        │'
  ?space(12)+'│    │                             │           │                     │                │          │          │            │             │ одиниць)    │ одиниць   │        │'
  ?space(12)+'├────┼─────────────────────────────┼───────────┼─────────────────────┼────────────────┼──────────┼──────────┼────────────┼─────────────┼─────────────┼───────────┼────────┤'
  ?space(12)+'│  7 │             8               │     9     │        10           │       11       │   12     │    13    │     14     │     15      │     16      │     17    │  18    │'
  ?space(12)+'├────┼─────────────────────────────┼───────────┼─────────────────────┼────────────────┼──────────┼──────────┼────────────┼─────────────┼─────────────┼───────────┼────────┤'
  sele prs2
  prs2i=1
  go top
  do while !eof()
     if int(mntov/10000)>1
        ktlr=ktl
        mntovr=mntov
        kg_r=int(mntovr/10000)
        licr=getfield('t1','kg_r','sgrp','lic')
        if licr=0
           sele prs2
           skip
           loop
        endif
        sele prs2
        kvp_r=kvp
        svp_r=svp
        zenr=zen
        sele tov
        netseek('t1','sklr,ktlr')
        upakr=upak
        vespr=vesp
        ksertr=ksert
        if ksertr=0
           ksertr=getfield('t1','sklr,mntovr','tovm','ksert')
        endif
        if ksertr=0
           ksertr=getfield('t1','mntovr','ctov','ksert')
        endif
        nsertr=getfield('t1','ksertr','sert','nsert')
        dtsertr=getfield('t1','ksertr','sert','dt1')
        //            prs2i           nat                  vesp           nsertr             dtsertr        upakr      kvp_r      zenr        svp_r            13            11           9
        ?space(12)+'│'+str(prs2i,4,0)+'│'+subs(nat,1,29)+'│'+str(vespr,11,3)+'│'+padr(nsertr,21,' ')+'│'+padc(dtoc(dtsertr),16)+'│'+str(upakr,10,3)+'│'+str(kvp_r,10)+'│'+padc(str(zenr,10,3),12,' ')+'│'+padc(str(roun(svp_r*1.2,2),10,2),13)+'│'+repl(' ',13)+'│'+repl(' ',11)+'│'+repl(' ',8)+'│'
        ?space(12)+'├────┼─────────────────────────────┼───────────┼─────────────────────┼────────────────┼──────────┼──────────┼────────────┼─────────────┼─────────────┼───────────┼────────┤'
        prs2i=prs2i+1
     endif
     sele prs2
     skip
  enddo
  for i=prs2i to 15
      ?space(12)+'│    │                             │           │                     │                │          │          │            │             │             │           │        │'
      if i#21
         ?space(12)+'├────┼─────────────────────────────┼───────────┼─────────────────────┼────────────────┼──────────┼──────────┼────────────┼─────────────┼─────────────┼───────────┼────────┤'
      else
         ?space(12)+'├────┴─────────────────────────────┼───────────┼─────────────────────┼────────────────┼──────────┼──────────┼────────────┼─────────────┼─────────────┼───────────┼────────┤'
      endif
  next
  ?space(12)+'│'+'Усього:'+space(27)+'│'+repl(' ',11)+'│'+repl(' ',21)+'│'+repl(' ',16)+'│'+repl(' ',10)+'│'+str(kvpr,10)+'│'+repl(' ',12)+'│'+str(roun(svpr*1.2,2),13,2)+'│'+repl(' ',13)+'│'+repl(' ',11)+'│'+repl(' ',8)+'│'
  ?space(12)+'├──────────────────────────────────┼───────────┼─────────────────────┼────────────────┼──────────┼──────────┼────────────┼─────────────┼─────────────┼───────────┼────────┤'
  ?space(12)+'│'+'У т.ч. ПДВ'+space(24)+'│'+repl(' ',11)+'│'+repl(' ',21)+'│'+repl(' ',16)+'│'+repl(' ',10)+'│'+repl(' ',10)+'│'+repl(' ',12)+'│'+str(roun(svpr*1.2,2)-svpr,13,2)+'│'+repl(' ',13)+'│'+repl(' ',11)+'│'+repl(' ',8)+'│'
  ?space(12)+'└──────────────────────────────────┴───────────┴─────────────────────┴────────────────┴──────────┴──────────┴────────────┴─────────────┴─────────────┴───────────┴────────┘'
  ?''
  necs_r=subs(necsr,1,12)
  if kplr=3048721
     ?space(12)+'Здав(вiдповiдальна особа вiдправника)'+space(17)+'Прийняв водiй-експедитор'+space(17)+'Здав водiй-експедитор'+space(17)+'Прийняв(вiдповiдальна особа одержевача)'
     ?''
     ?''
     ?space(12)+'_____________________________________'+space(17)+'Експедитор '+necs_r+'_____________'+space(7)+'Експедитор '+necs_r+'__________'+space(7)+'_______________________________________'
     ?space(12)+'             (пiдпис)                '+space(17)+'           (посада,ПIБ,пiдпис)    '+space(17)+'(посада,ПIБ,пiдпис) '+space(7)+'                (пiдпис,печатка)'
  else
     ?space(12)+'Здав(вiдповiдальна особа вiдправника)'+'    '+'Прийняв водiй-експедитор'+'   '+'Здав водiй-експедитор'+'    '+'Прийняв(вiдповiдальна особа одержевача)'
     ?''
     ?''
     ?space(12)+'_____________________________________'+'    '+necs_r+'_____________'+'   '+necs_r+'__________'+'    '+'_______________________________________'
     ?space(12)+'                       (пiдпис)      '+'    '+' (посада,ПIБ,пiдпис)    '+'   '+'(посада,ПIБ,пiдпис) '+'    '+'                (пiдпис,печатка)'
  endif
  return .t.

/*****************************************************************
 
 FUNCTION:
 АВТОР..ДАТА..........С. Литовка  08-23-18 * 02:41:09pm
 НАЗНАЧЕНИЕ.........
 ПАРАМЕТРЫ..........
 ВОЗВР. ЗНАЧЕНИЕ....
 ПРИМЕЧАНИЯ.........
 */
STATIC FUNCTION cKlnLic(cKeySeek)

  cKlnLic:=LTRIM(STR(getfield('t1',cKeySeek,'klnlic','numlic'),13))
  cSerLic:=allt(getfield('t1',cKeySeek,'klnlic','serlic'))

  Do Case
  Case LEN(cKlnLic) <= 6 // лиц с серией
    cKlnLic:=cKlnLic+' Серия '+cSerLic
  Case LEN(cKlnLic) > 6 .and. LEN(cKlnLic) <= 12 // без серии, 12 цифр
    If val(cSerLic)=0 // буквы
      cKlnLic:=TRANSFORM(cKlnLic,"@R 9999-9999-9999")
    Else
      cKlnLic:=cSerLic+'0'+cKlnLic
    EndIf
  OtherWise
    cKlnLic:=cSerLic+cKlnLic
  EndCase

  RETURN (cKlnLic)


/*****************************************************************
 
 FUNCTION:
 АВТОР..ДАТА..........С. Литовка  08-23-18 * 02:50:19pm
 НАЗНАЧЕНИЕ.........
 ПАРАМЕТРЫ..........
 ВОЗВР. ЗНАЧЕНИЕ....
 ПРИМЕЧАНИЯ.........
 */
STATIC FUNCTION cKlnLic1(numlicr,serlicr)
  // лицензия
  LOCAL cSerlic:=allt(serlicr)
  LOCAL cKlnLic:=allt(STR(numlicr))
  // outlog(3,__FILE__,__LINE__,cKlnLic,cSerlic)

  IF !EMPTY(cSerlic)
    If val(cSerlic)=0 // буквы
      cKlnLic:=PADL(cKlnLic,6,'0')
      cKlnLic += ' Серия'+' '+ cSerlic
    Else
      cKlnLic:=PADL(cKlnLic,13,'0')
      cKlnLic:=cSerlic+cKlnLic
    EndIf
  ELSE
    cKlnLic:=PADL(cKlnLic,12,'0')
    cKlnLic:=TRANSFORM(cKlnLic,"@R 9999-9999-9999")
  ENDIF
  // outlog(3,__FILE__,__LINE__,cKlnLic,cSerlic)
  RETURN (cKlnLic)

/*****************************************************************
 
 FUNCTION:
 АВТОР..ДАТА..........С. Литовка  12-13-19 * 12:59:33pm
 НАЗНАЧЕНИЕ.........
 ПАРАМЕТРЫ..........
 ВОЗВР. ЗНАЧЕНИЕ....
 ПРИМЕЧАНИЯ.........
 */
STATIC FUNCTION Calc_prs2()
  LOCAL nSumMax:=prs2->Svp
  go top
  do while !eof()
     if int(mntov/10000)>1
        mntovr=mntov
        kg_r=int(mntovr/10000)
        licr=getfield('t1','kg_r','sgrp','lic')
        if licr=0
          kvpLic0 += kvpr
          sele prs2
          skip
          loop
        endif
        sele prs2
        ktlr=ktl
        kvpr=kvpr+kvp
        svpr=svpr+svp
        ves_r=getfield('t1','sklr,ktlr','tov','ves')
        ves_r=ves_r*kvpr
        vesr=vesr+ves_r
        If prs2->Svp > nSumMax
          nSumMax:=prs2->Svp
          nRecSumMax:=RecNo()
        EndIf
     endif
     skip
  enddo

  RETURN (NIL)
