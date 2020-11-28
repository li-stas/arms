********* Добавление,коррекция пользователей **************
para corr
save scre to scktoins
sele speng
if corr=1
   locate for kgr=ktor
   fior=fio
   prlr=prl
   admr=adm
   mlr=ml
   kto_r=ktor
   dkklnr=dkkln
   spechr=spech
   cenpr=cenp
   cenrr=cenr
   kartr=kart
   atmrshr=atmrsh
   rspor=rspo
   rspbr=rspb
   rspnbr=rspnb
   rspr=rsp
   rspsr=rsps
   rdspr=rdsp
   rbsor=rbso
   rbsor=0
   rfpr=rfp
   rrs2mr=rrs2m
   rlicr=rlic
   rmlr=rml
   rmlor=rmlo
   faccr=facc
   rrmr=rrm
   corshr=corsh
   rupr=rup
   eotr=eot
   rprdr=rprd
   rnapr=rnap
   if fieldpos('rkln')#0
      rklnr=rkln
   else
      rklnr=0
   endif
   if fieldpos('rks')#0
      rksr=rks
   else
      rksr=0
   endif
   if fieldpos('ent')#0
      entr=ent
   else
      entr=0
   endif
   if fieldpos('rvz')#0
      rvzr=rvz
   else
      rvzr=0
   endif
   if fieldpos('rkpl')#0
      rkplr=rkpl
   else
      rkplr=0
   endif
   if fieldpos('rfc')#0
      rfcr=rfc
   else
      rfcr=0
   endif
else
   set orde to tag t1
   go bott
   kto_r=kgr+1
   set orde to tag t2
   store 0 to ktor
   admr=0
   dkklnr=0
   spechr=0
   store 0.0 to cenpr,cenrr
   fior=space(40)
   prlr=space(10)
   kartr=0
   atmrshr=0
   rspor=0
   rspbr=0
   rspr=0
   rspsr=0
   rspnbr=0
   rdspr=0
   rbsor=0
   rfpr=0
   rrs2mr=0
   rlicr=0
   rmlr=0
   rmlor=0
   faccr=0
   rrmr=0
   corshr=0
   rupr=0
   eotr=space(10)
   rprdr=0
   rklnr=0
   entr=0
   rvzr=0
   rksr=0
   rkplr=0
   rfcr=0
   rnapr=0
endif
oldcolor=setcolor('w/b,n/w')
ww=wopen(1,0,24,79,.t.)
wbox(1)
@  0,1 say 'Код     '+str(kto_r,4) get entr pict '99'
@  1,1 say 'Ф.И.О. ' get fior
@  2,1 say 'Пароль ' get prlr
@  3,1 say 'Пр.Адм.         ' get admr
@  4,1 say 'Доступ спр.     ' get dkklnr
@  5,1 say 'Сетевая печать  ' get spechr
@  6,1 say 'Цена в приходе  ' get cenpr
@  7,1 say 'Цена в расходе  ' get cenrr
@  8,1 say 'Доступ к цен.   ' get kartr
@  9,1 say 'Подтв.маршр.л   ' get atmrshr
@ 10,1 say 'Разр.сн.под.отд ' get rspor  pict '9'
@ 11,1 say 'Разр.сн.под.бух ' get rspbr  pict '9'
@ 12,1 say 'Разр.сн.под.нбух' get rspnbr pict '9'
@ 13,1 say 'Разр.сн.под.скл.' get rspsr pict '9'
@ 14,1 say 'Разр.сн.под.    ' get rspr pict '9'
@ 15,1 say 'Разр.сн.аттрибут' get rdspr pict '9'
@ 16,1 say 'Разр.печати БСО ' get rbsor pict '9'
@ 17,1 say 'Разр.Фин.подтв. ' get rfpr pict '9'
@ 18,1 say  'Разр.RS2M       ' get rrs2mr pict '9'
@  3,20 say 'Лицензии        ' get rlicr pict '9'
@  4,20 say 'Уровень         ' get faccr pict '9'
@  5,20 say 'Корр.машр.листа ' get rmlr pict '9'
@  6,20 say 'Только.машр.лист' get rmlor pict '9'
@  7,20 say 'Удаленные склады' get rrmr pict '9'
@  8,20 say 'Коррекция шапки ' get corshr pict '9'
@  9,20 say 'Разр сн под прих' get rupr pict '9'
@  10,20 say 'Маска отделов   ' get eotr
@  11,20 say '(1-Скл;2-Бух;3-Лог;4-Аг;5-SW;6-Упр)'
@  12,20 say 'Закр период     ' get rprdr pict '9'
@  13,20 say 'Справ клиентов  ' get rklnr pict '9'
@  14,20 say 'Возвраты        ' get rvzr pict '9'
@  15,20 say 'Кассир          ' get rksr pict '9'
@  16,20 say 'Спр плательщиков' get rkplr pict '9'
@  17,20 say 'Фин контроль     ' get rfcr pict '9'
@  18,20 say 'Направления      ' get rnapr pict '9'
read
if lastkey()#27
   @ 21,64 prom 'Верно'
   @ 21,col()+1 prom 'Не верно'
   menu to vn
   if vn=1
      sele speng
      if corr=1
         reclock()
         repl fio with fior,prl with prlr,adm with admr,dkkln with dkklnr,spech with spechr,cenp with cenpr,cenr with cenrr,kart with kartr,atmrsh with atmrshr
      else
         netadd()
         repl kgr with kto_r,fio with fior,prl with prlr,adm with admr,spech with spechr,dkkln with dkklnr,cenp with cenpr,cenr with cenrr,kart with kartr,atmrsh with atmrshr
      endif
      netunlock()
      netrepl('rspo,rspb,rspnb,rsp,rdsp,rsps','rspor,rspbr,rspnbr,rspr,rdspr,rspsr')
      netrepl('rbso','rbsor')
      netrepl('rfp','rfpr')
      netrepl('rrs2m','rrs2mr')
      netrepl('rlic','rlicr')
      netrepl('rml','rmlr')
      netrepl('rmlo','rmlor')
      netrepl('facc','faccr')
      netrepl('rrm','rrmr')
      netrepl('corsh','corshr')
      netrepl('rup','rupr')
      netrepl('eot','eotr')
      netrepl('rprd','rprdr')
      if fieldpos('rkln')#0
         netrepl('rkln','rklnr')
      endif
      if fieldpos('rkpl')#0
         netrepl('rkpl','rkplr')
      endif
      if fieldpos('rks')#0
         netrepl('rks','rksr')
      endif
      if fieldpos('rfc')#0
         netrepl('rfc','rfcr')
      endif
      if fieldpos('ent')#0
         netrepl('ent,rvz','entr,rvzr')
      endif
      if fieldpos('rnap')#0
         netrepl('rnap','rnapr')
      endif
   endif
endif
wclose()
setcolor(oldcolor)
rest scre from scktoins
retu
