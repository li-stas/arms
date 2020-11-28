clea
aqstr=1
aqst:={"Просмотр","Коррекция"}
aqstr:=alert(" ",aqst)
if lastkey()=27
   retu
endif
set prin to txt.txt
set prin on

sele dir
copy to tdir
sele 0
use tdir
do while .t.
   sele tdir
   rcdirr=slcf('tdir',,,,,"e:dir h:'Д' c:n(1) e:ndirc h:'Директория' c:c(20)")
   go rcdirr
   dir_r=dir
   do case
      case lastkey()=27
           exit
      case lastkey()=13
           iall()
   endc
endd
sele tdir
use
erase tdir.dbf
nuse()
set prin off
set prin to

**************
func iall()
**************
clea
sele dbft
if select('tdbft')#0
   sele tdbf
   use
endif

sele dbft
copy to tdbft for dir=dir_r
sele 0
use tdbft
do while !eof()
     sele tdbft
     fflr=alltrim(als)
     if !netfile(fflr)
        sele tdbft
        skip
        loop
     endif
     if !netuse(fflr)
        sele tdbft
        skip
        loop
     endif
     ?fflr
     for ij=1 to 18
         sele tdbft
         cttr='t'+alltrim(str(ij,2))
         tgr=cttr
         ttr=&cttr
         if empty(ttr)
            loop
         endif
         sele (fflr)
         if empty(ordkey(tgr))
            ?'Нет '+tgr+' '+ttr
            loop
         endif
         indr1=alltrim(ttr)
         indr=indr1
         ?tgr+' ' +indr1
         if indr1='deleted()'
            loop
         endif
         n=1
         k=1
         for ii=1 to len(indr1) && Определение к-ва элементов Тэга
             if subs(indr1,ii,1)='+'
                k=k+1
             endif
         endf
         ll=0
         for ii=1 to len(indr1)
             if subs(indr1,ii,1)='+'
                ll=ll+1
                if ll=k
                   exit
                endif
             endif
         endf
         indr1=subs(indr1,1,ii)
         jj=1
         ll=1
//         dime atag(k,4)
         atag:=array(k,4)
         for ii=1 to k && разделение индексного выражения на составляющие
             ar=''
             for j=jj to len(indr1)
                 if subs(indr1,j,1)='+'
                    jj=j+1
                    exit
                 endif
                 ar=ar+subs(indr1,j,1)
              endf
              atag[ii,1]=ar && элемент индексного выражения
              if ii=k.and.right(atag[ii,1],1)='+'
                 atag[ii,1]=subs(atag[ii,1],1,len(atag[ii,1])-1)
              endif
              br=''
              er=0
              for l=1 to len(ar)
*                  if isalpha(subs(ar,l,1)).or.subs(ar,l,1)='_'
*                     br=br+subs(ar,l,1)
*                  endif
                  do case
                     case subs(ar,l,1)='('
                          br=''
                          er=1
                     case subs(ar,l,1)=')'
                          exit
                     othe
                          br=br+subs(ar,l,1)
                  endc
              endf
              atag[ii,2]=br       && поле элемента
              atag[ii,3]=type(br) && тип поля элемента
              atag[ii,4]=er       && признак выражения
         endf
         sele (fflr)
         set orde to
         go top
         do while !eof()
              ind_r=''
              rcnr=recn()
              jjj=''
              for ii=1 to k
*                  if ii=1.and.fflr='ukach'.and.ij=4
*                     jjj=&(atag[ii,1])
*                  endif
                  if atag[ii,4]=1
                     ind_r=ind_r+&(atag[ii,1])
                  else
                     ind_rr=atag[ii,2]
                     if atag[ii,3]='C'
                        ind_r=ind_r+&ind_rr
                     else
                        ind_r=&ind_rr
                     endif
                  endif
              endf
              set orde to tag &tgr &&ij
              seek ind_r
              if !found()
                  seek ind_r
              endif
              if !foun()
                 do case
                    case valtype(ind_r)='C'
                         ?tgr+' '+ind_r+' '+str(rcnr,10)
                    case valtype(ind_r)='N'
                         ?tgr+' '+str(ind_r,10)+' '+str(rcnr,10)
                    case valtype(ind_r)='D'
                         ?tgr+' '+dtoc(ind_r)+' '+str(rcnr,10)
                    case valtype(ind_r)='L'
                         ?tgr+' '+trans(ind_r,'L')+' '+str(rcnr,10)
                    othe
                         ?tgr+' '+ind_r+' '+str(rcnr,10)
                 endc
                 if aqstr=2
                    set orde to
                    go rcnr
                    if reclock(1)
                       arec:={}
                       getrec()
                       netblank()
                       dbcommit()
                       putrec()
                       dbcommit()
                       netunlock()
                       set orde to tag &tgr
                       seek ind_r
                       if !foun()
                          ?tgr+' '+ind_r+' FAULT'
                       else
                          ?tgr+' '+ind_r+' Ok'
                       endif
                    else
                       ?tgr+' '+ind_r+' '+str(rcnr,10)+' блокирован'
                    endif
                 endif
              else
                 if dir_r=3.and.tgr=='t1'.and.recn()#rcnr.and.fflr#'rso2'.and.fflr#'pro2'
                    do case
                       case valtype(ind_r)='C'
                            ?tgr+' '+ind_r+' '+str(rcnr,10)+' '+str(recn(),10)
                       case valtype(ind_r)='N'
                            ?tgr+' '+str(ind_r,10)+' '+str(rcnr,10)+' '+str(recn(),10)
                       case valtype(ind_r)='D'
                            ?tgr+' '+dtoc(ind_r)+' '+str(rcnr,10)+' '+str(recn(),10)
                       case valtype(ind_r)='L'
                            ?tgr+' '+trans(ind_r,'L')+' '+str(rcnr,10)+' '+str(recn(),10)
                       othe
                            ?tgr+' '+ind_r+' '+str(rcnr,10)+' '+str(recn(),10)
                 endc
                 endif
              endif
              set orde to
              go rcnr
              skip
         endd
     endf
     nuse(fflr)
     sele tdbft
     skip
endd
sele tdbft
use
erase tdbft.dbf
*set esca off
