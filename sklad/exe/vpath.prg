Local I
nuse()
netuse('cskl')
sele menskl
go top
if eof()
   save scre to scmess 
   mess('Нет доступных складов в этом месяце')
   rest scre from scmess
   retu   
endif

I = 1
stor 1 to poza
anskl:={}
anskls:={}
apath:={}
askl:={}
awho := {}
acenpr := {}
ask:={}
atcen:={}
aroz:={}
arp:={}
amskl:={}
acopt:={}
akklm:={}
actov:={}
aost0:={}
arasc:={}
abopt:={}
asnds ={}
avttn={}
armag:={}
aotv:={}
askotv:={}
ablk:={}
arm:={}
atpstpok:={}
aarnd:={}
atskl:={}
aarnd:={}
amerch:={}
anprd:={}
akt:={}
go top
do whil !eof()
   ctov_rr=ctov
   path_rr=alltrim(path)
   mskl_rr=mskl
   skr=sk 
*   if ctov_rr=0.and.mskl_rr=0
*      if file(gcPath_d+path_rr+'tovd.dbf')
*         ctov_rr=2 
*      endif 
*   endif 
   if gnAdm=0
      blkr=getfield('t1','skr','cskl','blk')
   else
      blkr=0
   endif 
   if blkr=1
      sele menskl
      skip
      loop     
   endif
   aadd(anskls,str(skr,3)+'│'+nskl+'│'+str(ctov_rr,1)+'│'+str(mskl_rr,1))
   aadd(anskl,nskl)
   aadd(apath,path)
   aadd(askl,skl)
   aadd(awho,WH)
   aadd(ask,sk)
   aadd(atcen,tcen)
   aadd(acenpr,cenpr)
   aadd(aroz,roz)
   aadd(arp,rp)
   aadd(amskl,mskl)
   aadd(acopt,copt)
   aadd(akklm,kkl)
   aadd(asnds,nds)
   aadd(avttn,vttn)
   aadd(armag,rmag)
   aadd(aotv,otv)
   aadd(askotv,skotv)
   aadd(arasc,rasc)
   aadd(actov,ctov)
   aadd(aost0,ost0)
   aadd(abopt,bopt)
   aadd(ablk,blkr)
   aadd(aarnd,arnd)
   aadd(arm,rm)
   aadd(atpstpok,tpstpok)
   aadd(atskl,tskl) 
   aadd(amerch,merch) 
   aadd(anprd,nprd) 
   aadd(akt,kt) 
   skip
   i++
endd
nuse('cskl')
if i>5
   i=10
endi
roww=row()
coll=col()
T := roww
L := coll
B := roww+i
R := coll+30
TENI(T, L, B, R)
SETCOLOR("gr+/bg,w+/n,,,")
DISPBOX(roww,coll,roww+i,coll+39, "")
DISPBOX(roww,coll,roww+i,coll+39, "╔═╗║╝═╚║")
poza=1
poza:=achoice(roww+1,coll+1,roww+i-1,coll+38,anskls) && 36
If  poza = 0
  Return .F.
EndIf

Nsklr = alltrim(anskl[poza])
gcNskl=Nsklr
gcNdir=alltrim(apath[poza])
gcDir_t=gcNdir
gnSk=ask[poza]
gcPath_t = gcPath_d+gcDir_t
store 0 to gnTovd,gnTovo
gnCtov=actov[poza]
* Режим работы АРМа
netuse('tov')
if fieldsize(fieldpos('ktl'))#9
   wmess('UPGRADE.Обратитесь к Администратору!!!',1)
   nuse('tov')
   retu .f.
endif
nuse('tov')
if file(gcPath_t+'tovd.dbf').and.gnMskl=0.and.gnCtov=0
   gnCtov=2 
endif

do case
   case gnCtov=0
        gcTovdop=''     && Обычный
   case gnCtov=1        && Общий справочник товара по MNTOV
        gcTovdop='ctov'
   case gnCtov=2        && Разделенный справочник товара 
        gcTovdop='tovd' 
   case gnCtov=3        && Общий справочник товара по KTL
        gcTovdop='ctovk' 
   othe
        gnCtov=0
        gcTovdop=''     && Обычный
endc
if file(gcPath_t+'tovo.dbf')
   gnTovo=1
else
   gnTovo=0
endif
if file (gcPath_t+'final.dbf')
   fnlr=1
   fnlrsay='Месяц закрыт'
else
   fnlr=0
   fnlrsay='            '
endif 



gcPath_tf=gcPath_df+gcDir_t

Sklr=askl[poza]
gnSkl=sklr
Who =awho[Poza]
cenprr=acenpr[poza]
gnCenpr=cenprr
gnTcen=atcen[poza]
gnRoz=aroz[poza]
gnRp=arp[poza]
gnMskl=amskl[poza]
gcCopt=acopt[poza]
gnKklm=akklm[poza]
gnOst0=aost0[poza]
gnRasc=arasc[poza]
gcBopt=abopt[poza]
gnSnds=asnds[poza]
gnVttn=avttn[poza]
gnRmag=armag[poza]
*gnOtv=aotv[poza]
gnSkotv=askotv[poza]
gnBlk=ablk[poza]
gnRm=arm[poza]
gnTpstpok=atpstpok[poza]
gnArnd=aarnd[poza]
gnTskl=atskl[poza]
gnMerch=amerch[poza]
gdNPrd=anprd[poza]
gnKt=akt[poza]
Pathr=gcPath_c
gnOtv=0
netuse('pr1')
if netseek('t3','1')
   gnOtv=1
endif

nuse('pr1')

@ 1,0 clea
return .T.

******************************
func pppppppppppppp()
menu3:={}
sizam[3]:=0
sele menskl
if recc()=0
   wmess('Нет доступных предприятий')
   retu
endif
go top
do while !eof()
   aadd(menu3,str(sk,3)+'│'+nskl+'')
   sizam[3]=sizam[3]+1
   sele menskl
   skip
endd
retu .t.



