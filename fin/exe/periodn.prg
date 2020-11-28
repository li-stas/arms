yy=year(date())
mm=month(date())
pzcr=pozicion
do case
   case menu2[pozicion]='Январь  '
        monr='m01\'
   case menu2[pozicion]='Февраль '
        monr='m02\'
   case menu2[pozicion]='Март    '
        monr='m03\'
   case menu2[pozicion]='Апрель  '
        monr='m04\'
   case menu2[pozicion]='Май     '
        monr='m05\'
   case menu2[pozicion]='Июнь    '
        monr='m06\'
   case menu2[pozicion]='Июль    '
        monr='m07\'
   case menu2[pozicion]='Август  '
        monr='m08\'
   case menu2[pozicion]='Сентябрь'
        monr='m09\'
   case menu2[pozicion]='Октябрь '
        monr='m10\'
   case menu2[pozicion]='Ноябрь  '
        monr='m11\'
   case menu2[pozicion]='Декабрь '
        monr='m12\'
endc
godr=val(subs(menu2[pozicion],10,4))
mesr=val(subs(monr,2,2))
if godr=year(date()).and.mesr=month(date())
   gdTd=date()
else
   gdTd=ctod('01.'+subs(monr,2,2)+'.'+str(godr,4))
   gdTd=eom(gdTd)
endif
gdTdn=bom(gdTd)
gdTdk=eom(gdTd)
gcDir_g='g'+str(godr,4)+'\'
gcPath_g=gcPath_e+gcDir_g
gcPath_cg=gcPath_c+gcDir_g
gcDir_d=monr
gcPath_d=gcPath_g+gcDir_d
gcPath_cd=gcPath_cg+gcDir_d
gcPath_b=gcPath_d+'bank\'
gcPath_t = gcPath_d+gcDir_t  &&gcNdir
if file (gcPath_t+'final.dbf')
   fnlr=1
   fnlrsay='Месяц закрыт'
else
   fnlr=0
   fnlrsay='            '
endif 
dirgr='g'+str(year(gdTd),4)
if dirchange(gcPath_c+dirgr)#0
   dirmake(gcPath_c+dirgr)
endif
mr=month(gdTd)
dirmr='\m'+iif(mr<10,'0'+str(mr,1),str(mr,2))
if dirchange(gcPath_c+dirgr+dirmr)#0
   dirmake(gcPath_c+dirgr+dirmr)
endif
dirchange(gcPath_l)

