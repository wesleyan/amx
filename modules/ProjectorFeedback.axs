MODULE_NAME='ProjectorFeedback' (dev vdvProjector, dev vdvTouchPanel)
(***********************************************************)
(***********************************************************)
(*  FILE_LAST_MODIFIED_ON: 04/04/2006  AT: 11:33:16        *)
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

(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT

(***********************************************************)
(*              DATA TYPE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_TYPE

(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE

VOLATILE INTEGER power = 0
VOLATILE INTEGER mute = 0
VOLATILE INTEGER cooling = 0
VOLATILE INTEGER warming = 0

VOLATILE INTEGER last = -1

CONSTANT LONG update_timeline = 1

LONG times[] = {1000,2000,3000,4000}

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

SEND_COMMAND vdvProjector, 'BAUD=9600'

TIMELINE_CREATE(update_timeline, times, 4, TIMELINE_RELATIVE, TIMELINE_REPEAT)

(***********************************************************)
(*                THE EVENTS GO BELOW                      *)
(***********************************************************)
DEFINE_EVENT

DATA_EVENT[vdvProjector]
{
    STRING:
    {
        STACK_VAR CHAR cCMD[35]
        
        SEND_STRING 0, "'UI RECEIVED FROM COMM: ',DATA.TEXT"
        IF(FIND_STRING(DATA.TEXT, '=', 1)) { cCMD = REMOVE_STRING(DATA.TEXT, '=', 1) }        
        ELSE { cCMD = DATA.TEXT }
        SWITCH(cCMD)
        {

            CASE 'COOLDOWNTIME=': {}
            CASE 'COOLING=':
            {
		//TODO: DATA.TEXT holds the cooling time left. Maybe integrate it with interface?
		cooling = ATOI(DATA.TEXT)
            }
            CASE 'MUTE_PICTURE=':
	    { 
		mute = ATOI(DATA.TEXT)
	    }
            CASE 'POWER=': 
	    { 
		power = ATOI(DATA.TEXT)
	    }
            CASE 'WARMING=':
            {
                warming = ATOI(DATA.TEXT)
            }
            CASE 'WARMUP_COOLDOWN_ENABLE=': {}
            CASE 'WARMUPTIME=': {}
        }// END SWITCH(cCMD)
    }// END STRING
}// END DATA_EVENT[vdvDEV]

TIMELINE_EVENT[update_timeline]
{
    if(warming <> 0)
    {
	SEND_STRING vdvTouchPanel, 'Projector Warming Up'
    }
    else if(cooling <> 0)
    {
	SEND_STRING vdvTouchPanel, 'Projector Cooling Down'
    }
    else if(power = 0)
    {
	SEND_STRING vdvTouchPanel, 'Projector Off'
    }
    else if(mute <> 0)
    {
	SEND_STRING vdvTouchPanel, 'Video Mute On'
    }
    else
    {
	SEND_STRING vdvTouchPanel, 'Projector On'
    }
}

(***********************************************************)
(*            THE ACTUAL PROGRAM GOES BELOW                *)
(***********************************************************)
DEFINE_PROGRAM


if(warming <> 0)
{
    if(last <> 0)SEND_STRING vdvTouchPanel, 'Projector Warming Up'
    last = 0
}
else if(cooling <> 0)
{
    if(last <> 1)SEND_STRING vdvTouchPanel, 'Projector Cooling Down'
    last = 1
}
else if(power = 0)
{
    if(last <> 2)SEND_STRING vdvTouchPanel, 'Projector Off'
    last = 2
}
else if(mute <> 0)
{
    if(last <> 3)SEND_STRING vdvTouchPanel, 'Video Mute On'
    last = 3
}
else
{
    if(last <> 4)SEND_STRING vdvTouchPanel, 'Projector On'
    last = 4
}
(***********************************************************)
(*                     END OF PROGRAM                      *)
(*        DO NOT PUT ANY CODE BELOW THIS COMMENT           *)
(***********************************************************)
