* MENU[1],MENU[2]
if lastkey()=13
   do case
      case i=1
           ent() 
      case i=2   
           periodn() 
  endc
  keyboard chr(5)
endi
Return .T.
