#include "inkey.ch"
clea
store 0 to bsr,bsr1,mvidr,kkl_r
rnd_rr=0
if select('sl')=0
   sele 0
   use _slct alias sl excl
endif
sele sl
zap
netuse('kln')
netuse('dokk')
netuse('bs')
netuse('dkkln')
netuse('dknap')

sele 0
crtt('bskl','f:bs c:n(6)')
use bskl excl
inde on str(bs,6) to bskl

sele 0
crtt('bkln','f:kkl c:n(7)')
use bkln excl
inde on str(kkl,7) to bkln

sele dkkln
save scre to sckl
mess('Ждите,идет отбор счетов...')
do while !eof()
   bsr=bs
   kklr=kkl
   sele bskl
   if !netseek('t1','bsr')
      netadd()
      netrepl('bs','bsr')
   endif
   sele dkkln
   skip
enddo
rest scre from sckl
sele bskl
go top
do while .t.
   bsr=slcf('bskl',,,,,"e:bs h:'Счет' c:n(6) e:getfield('t1','bskl->bs','bs','nbs') h:'Наименование' c:c(20)",'bs',1)
   do case
      case lastkey()=K_ESC
           exit
      case lastkey()=13
           sele dkkln
           go top
           kkl_r=0
           @ 1,1 say 'Клиент' get kkl_r pict '9999999'
           read
           if lastkey()=13
              prnokl()
           endif
   endc
   sele bskl
   LOCATE FOR bs=bsr
endd
sele bskl
use
erase bskl.dbf
erase bskl.ntx
nuse()

proc prnokl

mess('Подготовка данных...')
crtt('tokl','f:skl c:n(4) f:kkl c:n(7) f:nkl c:c(30) f:bs c:n(6) f:dn c:n(10,2) f:kn c:n(10,2) f:rn_d c:n(6) f:ddk_d c:d f:bs_sd c:n(10,2) f:bs_d c:n(6) f:rn_k c:n(6) f:ddk_k c:d f:bs_sk c:n(10,2) f:bs_k c:n(6)')
sele 0
use tokl excl
inde on str(kkl,7)+str(bs,6)+str(rn_d,6) to tokld
inde on str(kkl,7)+str(bs,6)+str(rn_k,6) to toklk
set inde to tokld,toklk
sele dokk
set orde to tag t5
go top
do while !eof()
   if kkl_r#0.and.kkl_r#kkl
      skip
      loop
   endif
   sele dokk
   dokkdbr=bs_d
   dokkkrr=bs_k
   sele sl
   LOCATE FOR val(kod)=dokkdbr
   if !FOUND()
      LOCATE FOR val(kod)=dokkkrr
      if !FOUND()
         sele dokk
         skip
         loop
      else
         bsr=dokkkrr
      endif
   else
      bsr=dokkdbr
      LOCATE FOR val(kod)=dokkkrr
      if FOUND()
         bsr1=dokkkrr
      else
         bsr1=0
      endif
   endif
   sele dokk
   kklr=kkl
   sklr=skl
   sele dkkln
   if netseek('t1','kklr,bsr')
      dnr=dn
      knr=kn
   else
      dnr=0
      knr=0
   endif
   sele kln
   if netseek('t1','kklr')
      nklr=nkl
   else
      nklr=''
   endif
   sele dokk
   store 0 to bs_sdr,bs_skr,bs_dr,bs_kr,rn_dr,rn_kr,bs_skr1,bs_dr1,rn_kr1,ddk_kr1
   store ctod('') to ddk_dr,ddk_kr
   if bs_d=bsr
      bs_sdr=bs_s
      bs_kr=bs_k
      rn_dr=rn
      ddk_dr=ddk
   else
      bs_skr=bs_s
      bs_dr=bs_d
      rn_kr=rn
      ddk_kr=ddk
   endif
   if bsr1#0
      bs_skr1=bs_s
      bs_dr1=bsr
      rn_kr1=rn
      ddk_kr1=ddk
   endif

   @ MAXROW(),1 say str(kklr,7)+' '+nklr+' '+str(bsr,6)+' '+str(rn,6)+' '+dtoc(ddk)
   sele tokl
   if rn_dr#0
      if !netseek('t1','kklr,bsr,rnd_rr')
         netadd()
         netrepl('kkl,nkl,skl,bs,dn,kn,rn_d,ddk_d,bs_sd,bs_d,rn_k,ddk_k,bs_sk,bs_k',;
                 'kklr,nklr,sklr,bsr,dnr,knr,rn_dr,ddk_dr,bs_sdr,bs_kr,rn_kr,ddk_kr,bs_skr,bs_dr')
      else
         netrepl('rn_d,ddk_d,bs_sd,bs_d','rn_dr,ddk_dr,bs_sdr,bs_kr')
      endif
      if bsr1#0
*         if !netseek('t2','',str(kklr,7)+str(bsr1,6)+str(0,6),1)
         if !netseek('t2','kklr,bsr1,rnd_rr')
            netadd()
            netrepl('kkl,nkl,skl,bs,dn,kn,rn_k,ddk_k,bs_sk,bs_k',;
                   'kklr,nklr,sklr,bsr1,dnr,knr,rn_kr1,ddk_kr1,bs_skr1,bs_dr1')
         else
            netrepl('rn_k,ddk_k,bs_sk,bs_k','rn_kr,ddk_kr,bs_skr,bs_dr')
         endif
      endif
   else
      if !netseek('t2','kklr,bsr,rnd_rr')
         netadd()
         netrepl('kkl,nkl,skl,bs,dn,kn,rn_d,ddk_d,bs_sd,bs_d,rn_k,ddk_k,bs_sk,bs_k',;
                 'kklr,nklr,sklr,bsr,dnr,knr,rn_dr,ddk_dr,bs_sdr,bs_kr,rn_kr,ddk_kr,bs_skr,bs_dr')
      else
         netrepl('rn_k,ddk_k,bs_sk,bs_k','rn_kr,ddk_kr,bs_skr,bs_dr')

      endif
   endif
   sele dokk
   skip


enddo
sele dkkln
go top
do while !eof()
   bsr=bs
   sele sl
   LOCATE FOR val(kod)=bsr
   if !FOUND()
      sele dkkln
      skip
      loop
   endif
   sele dkkln
   if db+kr#0
      skip
      loop
   endif
   if kkl_r#0.and.kkl_r#kkl
      skip
      loop
   endif
   kklr=kkl
   bsr=bs
   dnr=dn
   knr=kn
   sklr=skl
   sele kln
   if netseek('t1','kklr')
      nklr=nkl
   else
      nklr=''
   endif
   sele tokl
*   seek str(kklr,7)+str(bsr,4)
*   if !netseek('t1',str(kklr,7)+str(bsr,6),,1)
   if !netseek('t1','kklr,bsr')
      netadd()
      netrepl('kkl,nkl,skl,bs,dn,kn','kklr,nklr,sklr,bsr,dnr,knr')
   endi
   sele dkkln
   skip
endd
rest scre from sckl

clvid=setcolor('gr+/b,n/w,n/bg')
wvid=wopen(10,20,15,60)
wbox(1)
mvidr=0
@ 1,1 prom 'Итоги'
@ 1,col()+1 prom 'Полностью'
menu to mvidr
wclose(wvid)
setcolor(clvid)
if mvidr=0
   retu
endif


mess('Печать...')
set devi to prin
erase dkkln.txt
if gnOut=2
  set prin to dkkln.txt
else
  set prin to
endif
set prin on
set cons off
if !empty(gcPrn)
   ?chr(27)+'E'+chr(27)+'&l1h26a0O'+chr(27)+chr(27)+'(3R'+chr(27)+'(s0p21.00h0s0b4099T'+chr(27)  // Книжная А4
else
   ?chr(27)+chr(77)+chr(15)
endif
sele tokl
set orde to 1
go top
lstr=0
rwr=0
kklr=0
bsr=0
store 0 to bs_sdsr,bs_sksr // Счет
store 0 to bs_sdkr,bs_skkr // Клиент
store 0 to bs_sdvr,bs_skvr // Всего
store 0 to dnsr,knsr,dnkr,knkr,dnvr,knvr,dkvr,kkvr
store '' to nklr,nbsr
do while !eof()
   if rwr=0
      lstr++
      rwr=54
      toklshap()
   endif
   if kkl#kklr
      toklkkl()
      kklr=kkl
      ?' '+str(kkl,7) +' '+nkl
      rwr--
      if mvidr=2
         ?' '+str(bs,6) //+' '+nbsr
         rwr--
      endif
      bsr=bs
   else
      if bs#bsr
         toklbs()
         if mvidr=2
            ?' '+str(bs,6) //+' '+nbsr
            rwr--
         endif
         bsr=bs
      endif
   endif
   kklr=kkl
   sklr=skl
   bs_sdr=bs_sd
   bs_dr=bs_d
   rn_dr=rn_d
   ddk_dr=ddk_d

   bs_skr=bs_sk
   bs_kr=bs_k
   rn_kr=rn_k
   ddk_kr=ddk_k
   if mvidr=2
      ?space(39)+' '+str(skl,4)+' '+space(10)+' '+space(10)+' '+iif(rn_dr#0,str(rn_dr,6),space(6))+' '+iif(!empty(ddk_dr),dtoc(ddk_dr),space(8))+' '+iif(bs_sdr#0,str(bs_sdr,10,2),space(10))+' '+iif(bs_dr#0,str(bs_dr,6),space(6))+;
       ' '+iif(rn_kr#0,str(rn_kr,6),space(6))+' '+iif(!empty(ddk_kr),dtoc(ddk_kr),space(8))+' '+iif(bs_skr#0,str(bs_skr,10,2),space(10))+' '+iif(bs_kr#0,str(bs_kr,6),space(6))

      rwr--
   endif

   dnsr=dn
   knsr=kn

   bs_sdsr=bs_sdsr+bs_sdr
   bs_sksr=bs_sksr+bs_skr

   bs_sdkr=bs_sdkr+bs_sdr
   bs_skkr=bs_skkr+bs_skr

   bs_sdvr=bs_sdvr+bs_sdr
   bs_skvr=bs_skvr+bs_skr

   skip
endd
toklkkl()
?repl('-',154)
?'Итого'+space(39)+' '+iif(dnvr#0,str(dnvr,10,2),space(10))+' '+iif(knvr#0,str(knvr,10,2),space(10))+' '+space(6)+' '+space(8)+' '+iif(bs_sdvr#0,str(bs_sdvr,10,2),space(10))+' '+space(4)+;
 ' '+space(6)+' '+space(8)+' '+iif(bs_skvr#0,str(bs_skvr,10,2),space(10))+' '+space(4)+' '+iif(dkvr#0,str(dkvr,10,2),space(10))+' '+iif(kkvr#0,str(kkvr,10,2),space(10))
?''
eject
sele tokl
use
erase tokl.dbf
erase tokld.ntx
erase toklk.ntx
if select('bkln')#0
   sele bkln
   use
endif
erase bkln.dbf
erase bkln.ntx
set prin off
*set prin to 'txt.txt'
set cons on
set devi to scre
rest scre from sckl
retu

proc toklshap
setprc(0,0)

?'                                                         Оборотная ведомость '
?dtoc(gdTd)+'                                                                                                                                 Лист '+str(lstr,3)
?'-----------------------------------------------------------------------------------------------------------------------------------------------------------------'
?'|       |                              | C  |  Входящий  остаток  |             Дебет                 |             Кредит                |  Исходящий остаток  |'
?'|       |                              | к  |--------------------------------------------------------------------------------------------------------------------'
?'|  Код  |           Клиент             | л  |          |          |Номер | Дата   |  Сумма   |  Корр  | Номер|  Дата  |  Сумма   |  Корр  |          |          |'
?'|       |                              | а  |  ДЕБЕТ   |  КРЕДИТ  |докум.| докум. |          |  счет  |докум.| докум. |          |  счет  |  ДЕБЕТ   |  КРЕДИТ  |'
?'|       |                              | д  |          |          |      |        |          |        |      |        |          |        |          |          |'
?'-----------------------------------------------------------------------------------------------------------------------------------------------------------------'
retu

proc toklkkl
if kklr#0
   if bsr#0
      toklbs()
   endif
   store 0 to dkkr,kkkr
   aa=dnkr-knkr+bs_sdkr-bs_skkr
   if aa>0
      dkkr=aa
   endif
   if aa<0
      kkkr=abs(aa)
   endif
   ?'Всего по клиенту'+space(28)+' '+iif(dnkr#0,str(dnkr,10,2),space(10))+' '+iif(knkr#0,str(knkr,10,2),space(10))+' '+space(6)+' '+space(8)+' '+iif(bs_sdkr#0,str(bs_sdkr,10,2),space(10))+' '+space(4)+;
    ' '+space(6)+' '+space(8)+' '+iif(bs_skkr#0,str(bs_skkr,10,2),space(10))+' '+space(4)+' '+iif(dkkr#0,str(dkkr,10,2),space(10))+' '+iif(kkkr#0,str(kkkr,10,2),space(10))
   rwr--

   dkvr=dkvr+dkkr
   kkvr=kkvr+kkkr

   dnvr=dnvr+dnkr
   knvr=knvr+knkr

   store 0 to dnkr,knkr,bs_sdkr,bs_skkr
endif
retu

proc toklbs
if bsr#0
   store 0 to dksr,kksr
   aa=dnsr-knsr+bs_sdsr-bs_sksr
   if aa>0
      dksr=aa
   endif
   if aa<0
      kksr=abs(aa)
   endif
   if mvidr=2
      ?'Всего по счету'+space(30)+' '+iif(dnsr#0,str(dnsr,10,2),space(10))+' '+iif(knsr#0,str(knsr,10,2),space(10))+' '+space(6)+' '+space(8)+' '+iif(bs_sdsr#0,str(bs_sdsr,10,2),space(10))+' '+space(4)+;
       ' '+space(6)+' '+space(8)+' '+iif(bs_sksr#0,str(bs_sksr,10,2),space(10))+' '+space(4)+' '+iif(dksr#0,str(dksr,10,2),space(10))+' '+iif(kksr#0,str(kksr,10,2),space(10))
      rwr--
   endif
   dnkr=dnkr+dnsr
   knkr=knkr+knsr
   aa=dnkr-knkr
   if aa>0
      dnkr=aa
      knkr=0
   endif
   if aa<0
      knkr=abs(aa)
      dnkr=0
   endif
   store 0 to dnsr,knsr,bs_sdsr,bs_sksr
endif
retu
