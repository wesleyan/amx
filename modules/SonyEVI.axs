MODULE_NAME='SonyEVI' (dev dvCam,dev vdvCam)
(***********************************************************)
(* System Type : NetLinx                                   *)
(***********************************************************)
(* REV HISTORY:                                            *)
(***********************************************************)

(***********************************************************)
(*          DEVICE NUMBER DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_DEVICE

dvdCam = Dynamic_Virtual_Device

(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT
volatile integer ZoomMode = 1
volatile integer commands[]=
{
    1,    //power on
    2,    //power off
    3,    //zoom stop
    4,    //zoom in
    5     //zoom out
}
volatile integer cameracommand[][] = 
{
    {$81,$01,$04,$00,$02,$FF},    //power on
    {$81,$01,$04,$00,$03,$FF},    //power off
    {$81,$01,$04,$07,$02,$FF},    //zoom stop
    {$81,$01,$04,$07,$02,$FF},    //zoom in
    {$81,$01,$04,$07,$03,$FF}    //zoom out

}
(***********************************************************)
(*              DATA TYPE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_TYPE

(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE

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

(***********************************************************)
(*                STARTUP CODE GOES BELOW                  *)
(***********************************************************)
DEFINE_START
Translate_Device(dvdCam,vdvCam)

(***********************************************************)
(*                THE EVENTS GO BELOW                      *)
(***********************************************************)
DEFINE_EVENT

Data_Event[dvCam]
{
    Online:
    {
        Send_Command Data.Device,"'SET BAUD 9600 N,8,1 485 DISABLE'"
    }
    (*String:
    {
           local_var char key
           local_var integer keynumber
           key = get_buffer_char(data.text)
           keynumber = atoi(key)
           switch(keynumber)
           {
               case ZoomMode:
               {
                   Send_String dvCam,
               }
           }
           
    }//end string *)
}     
Channel_Event[dvdCam,commands]
{
    On:
    {
        Send_String dvCam,"cameracommand[channel.channel]"
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
