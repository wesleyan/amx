PROGRAM_NAME='Chapel NI-700 Temporary Master Code'
(***********************************************************)
(***********************************************************)
(*  FILE_LAST_MODIFIED_ON: 04/05/2006  AT: 09:00:25        *)
(***********************************************************)
(* System Type : NetLinx                                   *)
(***********************************************************)
(* REV HISTORY:                                            *)
(***********************************************************)
(*
    $History: $
*)
(***********************************************************)
(*          DEVICE NUMBER DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_DEVICE

dv_crestron = 5001:1:0
dv_nec = 5001:2:0
vdv_nec = 33001:2:0

(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT
CHAR crestronStrings[6][8] = {
'POWR   1', // Power on
'POWR   0', // Power off
'IMBK   1', // Projector Mute On
'IMBK   0', // Projector Mute Off
'IVED   1', // Change to Video Input
'IRGB   1'  // Change to RGBHV 
}

INTEGER NEC_Projector_Commands[6] = 
{

1, // On
4, // Off
5, // Proj Mute On
6, // Proj Mute Off
9, // Proj Video Input
7  // RGB 2 Input
}
(***********************************************************)
(*              DATA TYPE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_TYPE

(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE
CHAR testVar[36] = ""
INTEGER testInt = 0
CHAR testChar[8] = ""
CHAR charProjectorStatsXMLString[5000]
INTEGER arrayIndex = 0
(***********************************************************)
(*               LATCHING DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_LATCHING

(***********************************************************)
(*       MUTUALLY EXCLUSIVE DEFINITIONS GO BELOW           *)
(***********************************************************)
DEFINE_MUTUALLY_EXCLUSIVE

(***********************************************************)
(*        SUBROUTINE/FUNCTION DEFINITIONS GO BELOW         *)
(***********************************************************)
(* EXAMPLE: DEFINE_FUNCTION <RETURN_TYPE> <NAME> (<PARAMETERS>) *)
(* EXAMPLE: DEFINE_CALL '<NAME>' (<PARAMETERS>) *)
#INCLUDE 'NP2000VideoProjectorInclude.axi'
(***********************************************************)
(*                STARTUP CODE GOES BELOW                  *)
(***********************************************************)
DEFINE_START
SEND_STRING dv_crestron,"'SET BAUD 9600,N,8,1 485 DISABLE'"
SEND_STRING dv_nec,"'SET BAUD 9600,N,8,1 485 DISABLE'"
(***********************************************************)
(*                THE EVENTS GO BELOW                      *)
(***********************************************************)
DEFINE_MODULE 'NEC1065_Qmodule_rev' prmod1 (dv_nec,vdv_nec,charProjectorStatsXMLString) //Projector #2 Module
DEFINE_EVENT
DATA_EVENT[dv_crestron]
{
    STRING: 
    {
      //testVar = DATA.TEXT
      //IF(COMPARE_STRING(DATA.TEXT,crestronStrings[1]))
      testChar = LEFT_STRING(DATA.TEXT,8)
      FOR(arrayIndex=1; arrayIndex <= 6; arrayIndex++)
      {
        IF(COMPARE_STRING(testChar,CrestronStrings[arrayIndex]))
        {
           PULSE [vdv_nec,NEC_Projector_Commands[arrayIndex]]
        }
      }
    }
}
(***********************************************************)
(*            THE ACTUAL PROGRAM GOES BELOW                *)
(***********************************************************)
DEFINE_PROGRAM

(***********************************************************)
(*                     END OF PROGRAM                      *)
(*        DO NOT PUT ANY CODE BELOW THIS COMMENT           *)
(***********************************************************)

