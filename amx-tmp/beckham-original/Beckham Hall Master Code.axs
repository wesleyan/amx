PROGRAM_NAME='Beckham Hall Master Code'
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
dvVolume = 32003:1:57
dvVideoSwitcher = 5001:2:57
dvProjector = 5001:1:57
dvTouchPanel = 10001:1:57

vdvProjector = 33001:1:0
(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT

VOLATILE INTEGER volume_step = 1

SOURCE_DVD = 1
SOURCE_SIDE_VGA = 2
SOURCE_STAGE_VGA = 3
SOURCE_SIDE_SVIDEO = 4
SOURCE_STAGE_SVIDEO = 5
SOURCE_SIDE_COMPOSITE = 6
SOURCE_STAGE_COMPOSITE = 7
SOURCE_AUX_VGA = 9
SOURCE_AUX_RCA = 10

//***these will likely need updating once someone can go and see what stuff is hooked up to
//buttons to change sources on the touch panel:
INTEGER SOURCE_BUTTONS[10] = {
    SOURCE_DVD,
    SOURCE_SIDE_VGA, //BNC RGBHV cables, not an actual vga connector
    SOURCE_STAGE_VGA,
    SOURCE_SIDE_SVIDEO,
    SOURCE_STAGE_SVIDEO,
    SOURCE_SIDE_COMPOSITE,
    SOURCE_STAGE_COMPOSITE,
    8, //not used
    SOURCE_AUX_VGA,
    SOURCE_AUX_RCA
}
CHAR SOURCE_TYPE[15][6] = {
'SVID',
'RGB',
'RGB',
'SVID',
'SVID',
'VID',
'VID',
'',
'RGB',
'VID'
}

(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE

persistent integer volume = 0

(***********************************************************)
(*        SUBROUTINE/FUNCTION DEFINITIONS GO BELOW         *)
(***********************************************************)
(* EXAMPLE: DEFINE_FUNCTION <RETURN_TYPE> <NAME> (<PARAMETERS>) *)
(* EXAMPLE: DEFINE_CALL '<NAME>' (<PARAMETERS>) *)
//using send_string stuff for now
DEFINE_CALL 'projector power on' {
    send_string dvProjector, "'C00',$0D"
}
DEFINE_CALL 'projector power off' {
    send_string dvProjector, "'C01',$0D"
}
DEFINE_CALL 'switch source' (INTEGER source[]) {
    STACK_VAR currentButton, currentSource
    CHAR sourceType[3]
    currentButton = get_last(source)
    currentSource = source_buttons[currentButton]
    sourceType = source_type[currentSource]
    SEND_STRING 0, "'Switching to ', sourceType, ' which is a ',itoa(currentSource)"

    //switch the projector input
    if ( sourceType == 'VID' ) {
	send_string dvProjector, "'C08',$0D"
    }
    else if ( sourceType == 'RGB' ) {
	send_string dvProjector, "'C05',$0D"
    }
    else if ( sourceType == 'SVI' ) {
	//note that SVI (without the D) is correct; I don't know why, but this is what works
	SEND_STRING 0, 'SOURCE TYPE IS SVID'
	send_string dvProjector, "'C07',$0D"
    }
    //switch the extron system 10 source
    send_string dvVideoSwitcher, "itoa(currentSource),'!'"
}
DEFINE_CALL 'projector autoadjust' {
    send_string dvProjector, "'C05',$0D"
}

DEFINE_CALL 'raise volume' {
    volume = volume + 10
    if(volume > 100)volume = 100
    SEND_STRING 0,  "'Setting volume to ', itoa(volume)"
    SEND_COMMAND dvVolume, "'P0L', itoa(volume), '%'"
    SEND_LEVEL dvTouchPanel, 50, volume
}
DEFINE_CALL 'lower volume' {
    //doing it this way saves us from overflow problems with unsigned ints
    if(volume <= 10)volume = 0
    else volume = volume - 10
    SEND_STRING 0, "'Setting volume to ', itoa(volume)"
    SEND_COMMAND dvVolume, "'P0L', itoa(volume), '%'"
    SEND_LEVEL dvTouchPanel, 50, volume
}


DEFINE_CALL 'focus near' {
    send_string dvProjector, "'C5F',$0D"
}
DEFINE_CALL 'focus far' {
    send_string dvProjector, "'C60',$0D"
}

DEFINE_CALL 'video mute on' {
    send_string dvProjector, "'C0D', $0D"
}

DEFINE_CALL 'video mute off' {
    send_string dvProjector, "'C0E',$0D"
}

DEFINE_CALL 'PC Auto Adjust' {
    SEND_STRING dvProjector, "'C89',$0D"
}

(***********************************************************)
(*                STARTUP CODE GOES BELOW                  *)
(***********************************************************)
DEFINE_START

(***********************************************************)
(*                THE EVENTS GO BELOW                      *)
(***********************************************************)
DEFINE_EVENT

//on button
BUTTON_EVENT[dvTouchPanel,20] {
    PUSH: { call 'projector power on' }
}
//off button
BUTTON_EVENT[dvTouchPanel,21] {
    PUSH: { call 'projector power off' }
}

//source buttons
BUTTON_EVENT[dvTouchPanel,SOURCE_BUTTONS] {
    PUSH: { CALL 'switch source' (SOURCE_BUTTONS) }
}

//volume up
BUTTON_EVENT[dvTouchPanel,30] {
    PUSH: { CALL 'raise volume' }
    HOLD[5,REPEAT]:
    {
	CALL 'raise volume'
    }
}
//volume down
BUTTON_EVENT[dvTouchPanel,31] {
    PUSH: { CALL 'lower volume' }
    HOLD[5,REPEAT]:
    {
	CALL 'lower volume'
    }
}

//Dragging on the volume bar
LEVEL_EVENT[dvTouchPanel, 50] {
    SEND_STRING 0, "'Level: ', itoa(LEVEL.VALUE)"
    volume = LEVEL.VALUE;
    SEND_COMMAND dvVolume, "'P0L', itoa(volume), '%'"
}

//video mute on
BUTTON_EVENT[dvTouchPanel,32] {
    PUSH: 
    { 
	CALL 'video mute on'
    }
}
//video mute off
BUTTON_EVENT[dvTouchPanel,33] {
    PUSH: 
    { 
	CALL 'video mute off'
    }
}

BUTTON_EVENT[dvTouchPanel, 34] {
    PUSH:
    {
	CALL 'PC Auto Adjust'
    }
}


DATA_EVENT[dvProjector] {
    STRING:
    {
	SEND_STRING 0, DATA.TEXT
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

