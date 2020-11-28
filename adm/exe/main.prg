FUNCTION Main(cParm)

#ifdef __CLIP__
   CLEAR SCREEN
   set(_SET_DISPBOX, .F.)
   set("PRINTER_CHARSET","cp866")

   //set("C:","/home/itk/hd1")
   cHomeDir:=GETENV("HOME")
   set("C:",cHomeDir+"/hd1.drdos")
   set("D:",cHomeDir+"/hd2")
  /*
   DIRMAKE("asdf")


   SET_FILECREATEMODE:=set(_SET_FILECREATEMODE)//, 664)
   SET_DIRCREATEMODE:=set(_SET_DIRCREATEMODE)//, 775)
   outlog(__FILE__,__LINE__,SET_FILECREATEMODE,VALTYPE(SET_FILECREATEMODE))
   outlog(__FILE__,__LINE__,SET_DIRCREATEMODE,VALTYPE(SET_DIRCREATEMODE))
   outlog(__FILE__,__LINE__,ntoc(SET_FILECREATEMODE,8,10),VALTYPE(SET_FILECREATEMODE))
   outlog(__FILE__,__LINE__,ntoc(SET_DIRCREATEMODE,8,10),VALTYPE(SET_DIRCREATEMODE))

   set(_SET_FILECREATEMODE, "664")
   set(_SET_DIRCREATEMODE, "775")
   SET_FILECREATEMODE:=set(_SET_FILECREATEMODE)
   SET_DIRCREATEMODE:=set(_SET_DIRCREATEMODE)
   outlog(__FILE__,__LINE__,SET_FILECREATEMODE)
   outlog(__FILE__,__LINE__,SET_DIRCREATEMODE)
   outlog(__FILE__,__LINE__,ntoc(SET_FILECREATEMODE,8,10))
   outlog(__FILE__,__LINE__,ntoc(SET_DIRCREATEMODE,8,10))

   DIRMAKE("qwert")
   */

  set(_SET_FILECREATEMODE, "664")
  set(_SET_DIRCREATEMODE, "775")

   set translate path on
   set autopen on
   set optimize off
   SetTxlat(CHR(16),">")
   set(_SET_ESC_DELAY, 99)
   //outlog(__FILE__,__LINE__, SET("C:"))
   //outlog(__FILE__,__LINE__, SET("D:"))
#endif

rddSetDefault("DBFCDX")
KSETNUM(.T.)
adm(cParm)

RETURN

#ifdef __CLIP__
FUNCTION ISAT()
  RETURN (.T.)

FUNCTION ISVGA()
RETURN .F.

FUNCTION ISEGA()
RETURN .F.

FUNCTION netdisk()
RETURN .F.

FUNCTION NNETNAME()
RETURN ""

FUNCTION NETNAME()
RETURN ""

FUNCTION NNETSDATE()
RETURN .T.

FUNCTION PRINTREADY()
RETURN .T.

FUNCTION SETDATE()
RETURN .T.

#endif

