MODULE_NAME='DenonDVD-DNV300' (dev dv_real,dev vdv_proxy, INTEGER transport_inputs[], INTEGER dvd_menu_nav[])
(***********************************************************)
(* System Type : NetLinx                                   *)
(***********************************************************)
(* REV HISTORY:                                            *)
(* 7/05 Revision 0       *)
(* 1/06 Revision 1       *)

(***********************************************************)

(***********************************************************)
(*          DEVICE NUMBER DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_DEVICE

(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT

VOLATILE INTEGER comm_active = 255

VOLATILE INTEGER TRANSPORT_RC_CODES[]=
{
    44,//Play
    48,//Pause
    49,//Stop
    40,//FF
    41,//REW
    246,//skip fwd
    245 //skip rev
}

VOLATILE INTEGER DVD_MENU_NAV_RC_CODES[] =
{
    88, //UP
    90, //LEFT
    113,//MENU
    91, //RIGHT
    89,	//DOWN
    92, //ENTER
    66  //EJECT
}

VOLATILE LONG TL_POLL   = 1
VOLATILE LONG TL_NORESP = 2

(***********************************************************)
(*              DATA TYPE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_TYPE

(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE

VOLATILE CHAR DVDBUFF[50]

VOLATILE LONG TL_POLL_ar[] = 
{
    10000
}


VOLATILE LONG TL_NORESP_ar[] =
{
    30000
} 
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

CREATE_BUFFER dv_real,DVDBUFF
CLEAR_BUFFER DVDBUFF

TIMELINE_CREATE(TL_NORESP,TL_NORESP_ar,1,TIMELINE_RELATIVE,TIMELINE_REPEAT)
TIMELINE_CREATE(TL_POLL,TL_POLL_ar,1,TIMELINE_RELATIVE,TIMELINE_REPEAT)


(***********************************************************)
(*                THE EVENTS GO BELOW                      *)
(***********************************************************)
DEFINE_EVENT
DATA_EVENT[dv_real]
{
    ONLINE:
    {
	SEND_COMMAND dv_real,'SET BAUD 9600,N,8,1 485 DISABLE'
	ON[vdv_proxy,COMM_ACTIVE]
    }
    STRING:
    {
    
    
    
    }
}
CHANNEL_EVENT[vdv_proxy,transport_inputs]
{
    ON:
    {
	SEND_STRING dv_real,"'[PC,RC,',ITOA(TRANSPORT_RC_CODES[GET_LAST(transport_inputs)]),']',13"
    }
}

CHANNEL_EVENT[vdv_proxy,DVD_MENU_NAV]
{
    ON:
    {
	SEND_STRING dv_real,"'[PC,RC,',ITOA(DVD_MENU_NAV_RC_CODES[GET_LAST(DVD_MENU_NAV)]),']',13"
    }
}

TIMELINE_EVENT[TL_POLL]
{
    
    IF([vdv_proxy,COMM_ACTIVE])
	ON[vdv_proxy,COMM_ACTIVE]
   //send status pulse to real device
}

TIMELINE_EVENT[TL_NORESP]
{
    OFF[vdv_proxy,COMM_ACTIVE]
}

(***********************************************************)
(*            THE ACTUAL PROGRAM GOES BELOW                *)
(***********************************************************)
DEFINE_PROGRAM

(***********************************************************)
(*                     END OF PROGRAM                      *)
(*        DO NOT PUT ANY CODE BELOW THIS COMMENT           *)
(***********************************************************)
