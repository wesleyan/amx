MODULE_NAME='NECConversionModule' (DEV dvProjector , DEV vdvProjector)

(***********************************************************)
(***********************************************************)
(*  FILE_LAST_MODIFIED_ON: 04/04/2006  AT: 11:33:16        *)
(***********************************************************)
(* System Type : NetLinx                                   *)
(***********************************************************)
(* REV HISTORY:                                            *)
(***********************************************************)
(*
    Created by Micah Wylde
    This module converts between the commands sent by the NEC1065_Qmodule
    and those expected by the ProjectorFeedback module
*)    
(***********************************************************)
(*          DEVICE NUMBER DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_DEVICE

vdvConverter = 33020:1:0

(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT
VOLATILE INTEGER ON_FB = 101
VOLATILE INTEGER COOLING_FB = 102
VOLATILE INTEGER WARMING_FB = 103
VOLATILE INTEGER MUTE_FB = 120


(***********************************************************)
(*              DATA TYPE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_TYPE

(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE

CHAR charProjectorStatsXMLString[5000]
VOLATILE INTEGER power = 0
VOLATILE INTEGER mute = 0
VOLATILE INTEGER cooling = 0
VOLATILE INTEGER warming = 0

#INCLUDE 'NP2000VideoProjectorInclude.axi'

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
DEFINE_MODULE 'NEC1065_Qmodule_rev' prmod1 (dvProjector,vdvConverter,charProjectorStatsXMLString) 


(***********************************************************)
(*                THE EVENTS GO BELOW                      *)
(***********************************************************)
DEFINE_EVENT

DATA_EVENT[vdvProjector]
{
   COMMAND:
    {
	STACK_VAR CHAR commandS[35]
	IF(FIND_STRING(DATA.TEXT, '=', 1)) { commandS = REMOVE_STRING(DATA.TEXT, '=', 1) }        
        ELSE { commandS = DATA.TEXT }
        SWITCH(commandS)
	{
	    CASE 'POWER=':
	    {
		SEND_STRING 0, "'POWER: ', ITOA(ATOI(DATA.TEXT))"
		if(ATOI(DATA.TEXT) == 0)
		{
		    SEND_STRING 0, 'Turning projector off'
		    PULSE[vdvConverter, intProjectorOffInput]
		}
		if(ATOI(DATA.TEXT) == 1)
		{
		    SEND_STRING 0, 'Turning projector on'
		    PULSE[vdvConverter, intProjectorOnInput]
		}
	    }
	    CASE 'MUTE_PICTURE=':
	    {
		if(ATOI(DATA.TEXT) == 0)
		{
		    PULSE[vdvConverter,intProjectorMuteOffInput]
		}
		else if(ATOI(DATA.TEXT) == 1)
		{
		    PULSE[vdvConverter,intProjectorMuteOnInput]
		}
		
	    }
	    CASE 'INPUT=':
	    {
		PULSE[vdvConverter, ATOI(DATA.TEXT)]
	    }
	}
    }
}

(***********************************************************)
(*            THE ACTUAL PROGRAM GOES BELOW                *)
(***********************************************************)
DEFINE_PROGRAM

if(power != ITOA([vdvConverter,ON_fb]))
{
    SEND_STRING vdvProjector, "'POWER=', ITOA([vdvConverter,ON_fb])"
    power = ITOA([vdvConverter,ON_fb])
}
if(warming != ITOA([vdvConverter,WARMING_fb]))
{
    SEND_STRING vdvProjector, "'WARMING=', ITOA([vdvConverter,WARMING_fb])"
    warming = ITOA([vdvConverter,WARMING_fb])
}
if(cooling != ITOA([vdvConverter,COOLING_fb]))
{
    SEND_STRING vdvProjector, "'COOLING=', ITOA([vdvConverter,COOLING_fb])"
    cooling = ITOA([vdvConverter,COOLING_fb])
}
if(mute != ITOA([vdvConverter,MUTE_fb]))
{
    SEND_STRING vdvProjector, "'MUTE_PICTURE=', ITOA([vdvConverter,MUTE_fb])"
    mute = ITOA([vdvConverter,MUTE_fb])
}

(***********************************************************)
(*                     END OF PROGRAM                      *)
(*        DO NOT PUT ANY CODE BELOW THIS COMMENT           *)
(***********************************************************)
