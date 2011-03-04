MODULE_NAME='Eiki-LC-XT4' (DEV dvProj , DEV vdvProj)
(***********************************************************)
(***********************************************************)
(*  FILE_LAST_MODIFIED_ON: 04/04/2006  AT: 11:33:16        *)
(***********************************************************)
(* System Type : NetLinx                                   *)
(***********************************************************)
(* REV HISTORY:                                            *)
(***********************************************************)

(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT

//clears the cmd buffer--use if the projector becomes unresponsive
VOLATILE CHAR LINE_FEED[] = '0A'
//projector reads cmds only after a carriage return
VOLATILE CHAR CARRIAGE_RETURN[] = '0D'

//commands--should be self explanatory
VOLATILE CHAR PROJ_ON[] = '00'
VOLATILE CHAR PROJ_OFF[] = '01'

VOLATILE CHAR PROJ_MUTE_ON[] = '0D'
VOLATILE CHAR PROJ_MUTE_OFF[] = '0E'

VOLATILE CHAR PROJ_AUTOADJUST[] = '89'

VOLATILE CHAR PROJ_INPUT_1[] = '05' //PC input in beckham hall
VOLATILE CHAR PROJ_INPUT_2[] = '06'
VOLATILE CHAR PROJ_INPUT_3[] = '07'
VOLATILE CHAR PROJ_INPUT_4[] = '08'



(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE

(***********************************************************)
(*        SUBROUTINE/FUNCTION DEFINITIONS GO BELOW         *)
(***********************************************************)
(* EXAMPLE: DEFINE_FUNCTION <RETURN_TYPE> <NAME> (<PARAMETERS>) *)
(* EXAMPLE: DEFINE_CALL '<NAME>' (<PARAMETERS>) *)
DEFINE_CALL 'send command' (CHAR cmd[]) {
    SEND_STRING vdvProj, "'C',cmd,'$',CARRIAGE_RETURN"
}

DEFINE_CALL 'clear projector buffer' {
    SEND_STRING vdvProj, "'$',LINE_FEED"
}

(***********************************************************)
(*                THE EVENTS GO BELOW                      *)
(***********************************************************)
DEFINE_EVENT

//there has to be a better way to do this...
CHANNEL_EVENT[vdvProj,'projector on']
{
    ON: {
	CALL 'send command' (PROJ_ON)
    }
}
CHANNEL_EVENT[vdvProj,'projector off'] {
    ON: {
	CALL 'send command' (PROJ_OFF)
    }
}
CHANNEL_EVENT[vdvProj,'projector mute'] {
    ON: {
	CALL 'send command' (PROJ_MUTE_ON)
    }
}
CHANNEL_EVENT[vdvProj,'projector unmute'] {
    ON: {
	CALL 'send command' (PROJ_MUTE_OFF)
    }
}
CHANNEL_EVENT[vdvProj,'projector autoadjust'] {
    ON: {
	CALL 'send command' (PROJ_AUTOADJUST)
    }
}
CHANNEL_EVENT[vdvProj,'projector input 1'] {
    ON: {
	CALL 'send command' (PROJ_INPUT_1)
    }
}
CHANNEL_EVENT[vdvProj,'projector input 2'] {
    ON: {
	CALL 'send command' (PROJ_INPUT_2)
    }
}
CHANNEL_EVENT[vdvProj,'projector input 3'] {
    ON: {
	CALL 'send command' (PROJ_INPUT_3)
    }
}
CHANNEL_EVENT[vdvProj,'projector input 4'] {
    ON: {
	CALL 'send command' (PROJ_INPUT_4)
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
















