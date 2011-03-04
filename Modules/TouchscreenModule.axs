MODULE_NAME='TouchscreenModule' (dev dvTouchPanel, dev vdvProjectorFeedback)
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
//these correspond to sources in sourceButtons[]--names are for convenience
SOURCE_MAC = 2
SOURCE_PC = 1
SOURCE_LAPTOP = 5
SOURCE_DVD = 3
SOURCE_VCR = 4

//buttons to change sources on the touch panel:
INTEGER SOURCE_BUTTONS[] = {
    SOURCE_MAC,
    SOURCE_PC,
    SOURCE_LAPTOP,
    SOURCE_VCR,
    SOURCE_DVD
}

INTEGER VNC_SOURCES[] = {SOURCE_MAC, SOURCE_PC} //these are sources that use VNC
INTEGER NON_VNC_SOURCES[] = {SOURCE_LAPTOP, SOURCE_VCR, SOURCE_DVD}

INTEGER AUDIO_CONTROLS[] = {30, 31, 33}

PROJECTOR_ONOFF_CONTROL = 25
PROJECTOR_ONOFF_DISPLAY   = 26

VIDEO_MUTE_ONOFF_CONTROL = 27
VIDEO_MUTE_ONOFF_DISPLAY = 28

INTEGER ONOFF_BUTTON_CONTROLS[] = {PROJECTOR_ONOFF_CONTROL, VIDEO_MUTE_ONOFF_CONTROL}
INTEGER ONOFF_BUTTON_DISPLAYS[] = {PROJECTOR_ONOFF_DISPLAY, VIDEO_MUTE_ONOFF_DISPLAY}

INTEGER TOTAL_ONOFF_STATES = 32

(***********************************************************)
(*              DATA TYPE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_TYPE

(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE

INTEGER iterator = 0

CHAR currentState[30] = ''

INTEGER ONOFF_STATES[] = {0,0} //These states correspond to the indices of the ONOFF_BUTTONS array
INTEGER ONOFF_LEVELS[] = {100,100}


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

(***********************************************************)
(*                THE EVENTS GO BELOW                      *)
(***********************************************************)
DEFINE_EVENT

CHANNEL_EVENT[vdvProjectorFeedback, SOURCE_BUTTONS] //channel events are used to set sources
{
    ON:
    {
	if([dvTouchPanel, SOURCE_BUTTONS[GET_LAST(SOURCE_BUTTONS)]] = false)
	{
	    //first we de-select all of the sources
	    for(iterator = 1; iterator <= LENGTH_ARRAY(SOURCE_BUTTONS); iterator++)
	    {
		[dvTouchPanel, SOURCE_BUTTONS[iterator]] = false
	    }
	    //then we select the source we want
	    [dvTouchPanel, SOURCE_BUTTONS[GET_LAST(SOURCE_BUTTONS)]] = true
	}
    }
}

CHANNEL_EVENT[vdvProjectorFeedback, 51]
{
    OFF:
    {
	SEND_COMMAND dvTouchPanel, "'^BOP-51,0,150'"
    }
    ON:
    {
	SEND_COMMAND dvTouchPanel, "'^BOP-51,0,255'"
    }
}

CHANNEL_EVENT[vdvProjectorFeedback, ONOFF_BUTTON_DISPLAYS]
{
    ON:
    {
	SEND_COMMAND dvTouchPanel, "'^ani-', ONOFF_BUTTON_DISPLAYS[GET_LAST(ONOFF_BUTTON_DISPLAYS)], ',', TOTAL_ONOFF_STATES ,',1'"
	SEND_LEVEL dvTouchPanel, ONOFF_BUTTON_CONTROLS[GET_LAST(ONOFF_BUTTON_DISPLAYS)], 0
	ONOFF_STATES[GET_LAST(ONOFF_BUTTON_DISPLAYS)] = total_onoff_states
    }
    OFF:
    {
	SEND_STRING 0, 'BUTTON TURNED OFF'
	SEND_COMMAND dvTouchPanel, "'^ani-', ONOFF_BUTTON_DISPLAYS[GET_LAST(ONOFF_BUTTON_DISPLAYS)], ',1,',TOTAL_ONOFF_STATES,',1'"
	SEND_LEVEL dvTouchPanel, ONOFF_BUTTON_CONTROLS[GET_LAST(ONOFF_BUTTON_DISPLAYS)], 100
	ONOFF_STATES[GET_LAST(ONOFF_BUTTON_DISPLAYS)] = 1
    }
}

LEVEL_EVENT[dvTouchPanel, ONOFF_BUTTON_CONTROLS]
{
    ONOFF_LEVELS[GET_LAST(ONOFF_BUTTON_CONTROLS)] = LEVEL.VALUE
}

BUTTON_EVENT[dvTouchPanel, ONOFF_BUTTON_CONTROLS]
{
    HOLD[3,REPEAT]:
    {
	SEND_STRING 0, "'^ani-', itoa(ONOFF_BUTTON_DISPLAYS[GET_LAST(ONOFF_BUTTON_CONTROLS)]), ',', itoa(ONOFF_STATES[GET_LAST(ONOFF_BUTTON_CONTROLS)]), ',', itoa((ONOFF_LEVELS[GET_LAST(ONOFF_BUTTON_CONTROLS)]*TOTAL_ONOFF_STATES)/100)"
	SEND_COMMAND dvTouchPanel, "'^ani-', itoa(ONOFF_BUTTON_DISPLAYS[GET_LAST(ONOFF_BUTTON_CONTROLS)]), ',', itoa(ONOFF_STATES[GET_LAST(ONOFF_BUTTON_CONTROLS)]), ',', itoa((ONOFF_LEVELS[GET_LAST(ONOFF_BUTTON_CONTROLS)]*TOTAL_ONOFF_STATES)/100)"
	ONOFF_STATES[GET_LAST(ONOFF_BUTTON_CONTROLS)] = (ONOFF_LEVELS[GET_LAST(ONOFF_BUTTON_CONTROLS)]*TOTAL_ONOFF_STATES)/100
    }
    RELEASE:
    {
	if(ONOFF_LEVELS[GET_LAST(ONOFF_BUTTON_CONTROLS)] <= 50)
	{
	    ON[vdvProjectorFeedback, ONOFF_BUTTON_DISPLAYS[GET_LAST(ONOFF_BUTTON_CONTROLS)]];
	    ON[dvTouchPanel, ONOFF_BUTTON_DISPLAYS[GET_LAST(ONOFF_BUTTON_CONTROLS)]];
	}
	else
	{
	    OFF[vdvProjectorFeedback, ONOFF_BUTTON_DISPLAYS[GET_LAST(ONOFF_BUTTON_CONTROLS)]];
	    OFF[dvTouchPanel, ONOFF_BUTTON_DISPLAYS[GET_LAST(ONOFF_BUTTON_CONTROLS)]];
	}
    }
}

/*BUTTON_EVENT[dvTouchPanel, 51]
BUTTON_EVENT[dvTouchPanel, VNC_SOURCES]
{
    PUSH:
    {
	OFF[vdvProjectorFeedback, 51]
    }
}

BUTTON_EVENT[dvTouchPanel, NON_VNC_SOURCES]
{
    PUSH:
    {
	ON[vdvProjectorFeedback, 51]
    }
}*/

BUTTON_EVENT[dvTouchPanel, VIDEO_MUTE_ONOFF_CONTROL]
BUTTON_EVENT[dvTouchPanel, PROJECTOR_ONOFF_CONTROL]
BUTTON_EVENT[dvTouchPanel, AUDIO_CONTROLS]
{
    PUSH:
    {
	//TO[vdvProjectorFeedback, 51]
    }
}

DATA_EVENT[vdvProjectorFeedback]  //virtual device to receive commands from outside
{
    STRING:
    {
	if(currentState <> DATA.TEXT)
	{
	    //SEND_STRING 0, DATA.TEXT
	    switch(Data.TEXT)
	    {
		case 'Projector On':
		{
		    SEND_COMMAND dvTouchPanel, '^ANI-50,2,2'
		    ON[vdvProjectorFeedback, PROJECTOR_ONOFF_DISPLAY]
		}
		case 'Projector Off':
		{
		    SEND_COMMAND dvTouchPanel, '^ANI-50,1,1'
		    OFF[vdvProjectorFeedback, PROJECTOR_ONOFF_DISPLAY]
		    OFF[vdvProjectorFeedback, VIDEO_MUTE_ONOFF_DISPLAY]
		}
		case 'Projector Warming Up':
		{
		    SEND_COMMAND dvTouchPanel, '^ANI-50,4,4'
		    ON[vdvProjectorFeedback, PROJECTOR_ONOFF_DISPLAY]
		}
		case 'Projector Cooling Down':
		{
		    SEND_COMMAND dvTouchPanel, '^ANI-50,5,5'
		    ON[vdvProjectorFeedback, PROJECTOR_ONOFF_DISPLAY]
		}
		case 'Video Mute On':
		{
		    SEND_COMMAND dvTouchPanel, '^ANI-50,3,3'
		    ON[vdvProjectorFeedback, VIDEO_MUTE_ONOFF_DISPLAY]
		}
	    }
	    currentState = DATA.TEXT
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
