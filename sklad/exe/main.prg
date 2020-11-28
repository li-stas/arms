FUNCTION Main(cParm)
#ifdef __CLIP__
   CLEAR SCREEN
   set(_SET_DISPBOX, .F.)
   set("PRINTER_CHARSET","cp866")
      //set("C:","/home/itk/hd1")
   cHomeDir:=GETENV("HOME")
   set("C:",cHomeDir+"/hd1.drdos")
   set("D:",cHomeDir+"/hd2")
   set(_SET_FILECREATEMODE, "664")
   set(_SET_DIRCREATEMODE , "775")

   set translate path on
   set autopen on
   set optimize off//n
   SetTxlat(CHR(16),">")
   set(_SET_ESC_DELAY, 99)
   //outlog(__FILE__,__LINE__, SET("C:"))
   //outlog(__FILE__,__LINE__, SET("D:"))
#endif
rddSetDefault("DBFCDX")
IF FILE("tnat.cdx")
  ERASE tnat.cdx
ENDIF
KSETNUM(.T.)

sklad(cParm)

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
  LOCAL cNNETNAME
  cNNETNAME:="" //GETENV("HOST")
  SYSCMD("loginfo -O","",@cNNETNAME)
  //outlog(__FILE__,__LINE__,cNNETNAME)
RETURN cNNETNAME

FUNCTION NETNAME()
  RETURN NNETNAME()

FUNCTION NNETSDATE()
RETURN .T.

FUNCTION PRINTREADY()
RETURN .T.

FUNCTION SETDATE()
RETURN .T.
#endif

/*
set print on
set device to print
  set prin to lpt1
TEXT








                          è ê à Ç Ö í,  Ç ë Ö å !



                                 \\|//
                                 (o o)
                        ----oOOO--(_)--OOOo----
                           set prin to lpt1
ENDTEXT
set print off
set device to screen

set print on
set device to print
  set prin to lpt2
TEXT








                          è ê à Ç Ö í,  Ç ë Ö å !



                                 \\|//
                                 (o o)
                        ----oOOO--(_)--OOOo----
                           set prin to lpt2
ENDTEXT

set print off
set device to screen

set print on
set device to print
  set prin to lpt3
TEXT








                          è ê à Ç Ö í,  Ç ë Ö å !



                                 \\|//
                                 (o o)
                        ----oOOO--(_)--OOOo----
                           set prin to lpt3
ENDTEXT
set print off
set device to screen

*/

