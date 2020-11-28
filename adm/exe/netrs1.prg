* Просмотр локальных документов
netuse('netrs1')
netuse('speng')
netuse('cskl')
sele netrs1
go top
rcr=recn()

do while .t.
   sele netrs1
   go rcr
   rcr=slcf('netrs1',,,,,"e:kto h:'Код' c:n(4) e:uname h:'Сет.имя' c:c(10) e:getfield('t1','netrs1->kto','speng','fio') h:'Пользователь' c:c(20) e:sk h:'Адр' c:n(3) e:getfield('t1','netrs1->sk','cskl','nskl') h:'Склад' c:c(19) e:ttn h:'ТТН' c:n(6) e:dt h:'Дата' c:d(10)")
   if lastkey()=27
      exit
   endif 
endd
nuse('')
