* ��ᬮ�� �������� ���㬥�⮢
netuse('netrs1')
netuse('speng')
netuse('cskl')
sele netrs1
go top
rcr=recn()

do while .t.
   sele netrs1
   go rcr
   rcr=slcf('netrs1',,,,,"e:kto h:'���' c:n(4) e:uname h:'���.���' c:c(10) e:getfield('t1','netrs1->kto','speng','fio') h:'���짮��⥫�' c:c(20) e:sk h:'���' c:n(3) e:getfield('t1','netrs1->sk','cskl','nskl') h:'�����' c:c(19) e:ttn h:'���' c:n(6) e:dt h:'���' c:d(10)")
   if lastkey()=27
      exit
   endif 
endd
nuse('')
