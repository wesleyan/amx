MODULE_NAME='TouchscreenModule' (dev dvTouchPanel, dev vdvProjectorFeedback, dev vdvProjector, dev vdvRoomSpecific, INTEGER buttons_used[], INTEGER extra_buttons_used[][])
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
SOURCE_MAC = 1
SOURCE_PC = 2
SOURCE_LAPTOP = 3
SOURCE_DVD = 4
SOURCE_VCR = 5
SOURCE_AUX = 6
SOURCE_COMPUTER = 7

//extra sources
SOURCE_LAPTOP_RACK   = 7
SOURCE_LAPTOP_PODIUM = 8
SOURCE_AUX_RACK      = 9
SOURCE_AUX_PODIUM    = 10


//buttons to change sources on the touch panel:
INTEGER SOURCE_BUTTONS[] = {1, 2, 3, 4, 5}
INTEGER EXTRA_BUTTONS[] = {6, 7, 8, 9, 10}

INTEGER SOURCE_TYPES[] = {
    SOURCE_MAC,
    SOURCE_PC,
    SOURCE_LAPTOP,
    SOURCE_VCR,
    SOURCE_DVD,
    SOURCE_AUX,
    SOURCE_COMPUTER
}

INTEGER EXTRA_SOURCES[] = {
    SOURCE_LAPTOP_RACK,
    SOURCE_LAPTOP_PODIUM,
    SOURCE_AUX_RACK,
    SOURCE_AUX_PODIUM,
    SOURCE_MAC,
    SOURCE_PC
}

CHAR SOURCE_IMAGES[8][15] = {
    'MacButton',
    'PCButton',
    'LaptopButton',
    'DVDButton',
    'VCRButton',
    'AuxButton',
    'PCButton'
}

CHAR EXTRA_IMAGES[10][20] = {
    'LaptopRack',
    'LaptopPodium',
    'AuxRack',
    'AuxPodium',
    'MacButton',
    'PCButton'
}

PROJECTOR_ONOFF_CONTROL = 25
PROJECTOR_ONOFF_DISPLAY   = 26

VIDEO_MUTE_ONOFF_CONTROL = 27
VIDEO_MUTE_ONOFF_DISPLAY = 28

INTEGER ONOFF_BUTTON_CONTROLS[] = {PROJECTOR_ONOFF_CONTROL, VIDEO_MUTE_ONOFF_CONTROL}
INTEGER ONOFF_BUTTON_DISPLAYS[] = {PROJECTOR_ONOFF_DISPLAY, VIDEO_MUTE_ONOFF_DISPLAY}

INTEGER TOTAL_ONOFF_STATES = 32

//volume control constants
VOLUME_MAX = 255
VOLUME_MIN = 0
VOLUME_STEP = 6


(***********************************************************)
(*              DATA TYPE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_TYPE

(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE

INTEGER iterator = 0
INTEGER index = 0
INTEGER start = 0

//this holds the extra buttons that have last been displayed
INTEGER current_extra_buttons_index = 0
//this is the button index (from EXTRA_BUTTONS) that corresponds to index 0 of current_extra_buttons
INTEGER top_index = 0
//this is the regular button that has the extra button
INTEGER main_source = 0

CHAR currentState[30] = ''

INTEGER ONOFF_STATES[] = {0,0} //These states correspond to the indices of the ONOFF_BUTTONS array
INTEGER ONOFF_LEVELS[] = {100,100}

INTEGER cooling = false
INTEGER muted = false

INTEGER projectorSwitchedToSource = true
INTEGER currentSource = 0
VOLATILE INTEGER currentSourceButton = 0
INTEGER intTransportButtonIndex = 0


VOLATILE LONG longTimelineFeedbackArray[1]

//the volume -- persistent so rebooting the netlinx does not affect volume level
PERSISTENT INTEGER volume
PERSISTENT INTEGER volumeIsMuted = 0

VOLATILE LONG longTimelineFeedbackID = 1

LONG updateTPTimeline[] = {1000}

//These integers hold whether or not to "protect" a button from being changed.
INTEGER protectOnOffButtons[] = {false, false}
INTEGER onOffProtectCounter[] = {0,0}

/*	Include Statements
 */
//dvProjector functions
#INCLUDE 'NP2000VideoProjectorInclude.axi'
//use one of the following
//#INCLUDE 'MLS506MAVideoSwitcher.axi'
//#INCLUDE 'ExtronSystem10Include.axi'



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



//updates the volume shown on the touchpanel
DEFINE_CALL 'update display volume' (INTEGER vol) {
    if(volumeIsMuted) SEND_LEVEL dvTouchPanel, 33, 0
    else SEND_LEVEL dvTouchPanel, 33, vol
}

DEFINE_CALL 'update amp volume' (INTEGER vol) {
    if(volumeIsMuted) SEND_STRING vdvRoomSpecific, 'volume=0'
    else SEND_STRING vdvRoomSpecific, "'volume=', itoa(vol)"
}


/*	Calls for button presses
 */
//turns the projector on if it is not already
DEFINE_CALL 'projector power on' {
    SEND_STRING 0, 'On button pushed'
    PULSE[33020:1:0, 1]
    //SEND_COMMAND vdvProjector, 'POWER=1'
}

//turns the projector off
DEFINE_CALL 'projector power off' {
    LOCAL_VAR INTEGER counter
    counter = 0
    SEND_STRING 0, 'off button pushed'
    SEND_COMMAND vdvProjector, 'POWER=0'
    WHILE(!cooling)
    {
	counter++
	WAIT(50)
	{
	    SEND_COMMAND vdvProjector, 'POWER=0'
	}
	if(counter > 10)break
    }
}

//turns video mute on
DEFINE_CALL 'video mute on' {
    SEND_COMMAND vdvProjector, 'MUTE_PICTURE=1'
}

DEFINE_CALL 'video mute off' {
    SEND_COMMAND vdvProjector, 'MUTE_PICTURE=0'
}

DEFINE_CALL 'touchpanel shutdown' {

    //turn dvProjector off if it's on
    CALL 'projector power off'

}

DEFINE_CALL 'increase volume' {
    //unmute
    volumeIsMuted = false
    [dvTouchPanel, 32] = false

    //increase the volume by one step
    volume = volume + VOLUME_STEP
    IF(volume > VOLUME_MAX) volume = VOLUME_MAX

    //update the touchpanel volume display
    CALL 'update display volume' (volume)
    CALL 'update amp volume' (volume)
}

DEFINE_CALL 'decrease volume' {
    //unmute
    volumeIsMuted = false
    [dvTouchPanel, 32] = false

    //if the volume is not at the minimum already
    //decrease the volume by one step
    volume = volume - VOLUME_STEP
    IF (volume < VOLUME_MIN || volume >=  500) volume = VOLUME_MIN

    //update the touchpanel volume display
    CALL 'update display volume' (volume)
    CALL 'update amp volume' (volume)
}

DEFINE_CALL 'mute volume' {
    volumeIsMuted = !volumeIsMuted
    if(volumeIsMuted)
    {
	CALL 'update amp volume' (0)
	CALL 'update display volume'(0)
    }
    else
    {
	CALL 'update amp volume' (volume)
	CALL 'update display volume' (volume)
    }
}

DEFINE_CALL 'switch source'(INTEGER source_index)
{
    SEND_STRING 0, "'Last source is ', itoa(source_index)"
    if(source_index > 5)SEND_STRING vdvRoomSpecific, "'source=', itoa(main_source), ',', itoa(source_index - top_index + 1)"
    else if(LENGTH_ARRAY(extra_buttons_used[source_index]) < 2) SEND_STRING vdvRoomSpecific, "'source=', itoa(source_index)"
    PULSE[vdvProjectorFeedback, source_index]
    currentSource = source_index
    //if(currentState <> 'on')projectorSwitchedToSource = false
}

DEFINE_CALL 'switch button'(INTEGER isOn, INTEGER button)
{
    LOCAL_VAR INTEGER index
    index = 1
    if(button = VIDEO_MUTE_ONOFF_DISPLAY)index = 2
    if(!protectOnOffButtons[index])
    {
	if(isOn)
	{
	    ON[vdvProjectorFeedback, button]
	}
	else
	{
	    OFF[vdvProjectorFeedback, button]
	}
    }
}

/***********************************************************\
|*                STARTUP CODE GOES BELOW                  *|
\***********************************************************/
DEFINE_START

TIMELINE_CREATE(1, updateTPTimeline, 1, TIMELINE_RELATIVE, TIMELINE_REPEAT)

/***********************************************************\
|*                THE EVENTS GO BELOW                      *|
\***********************************************************/
DEFINE_EVENT

DATA_EVENT[dvTouchPanel]
{
    ONLINE:
    {
	CALL 'update amp volume'(volume)
	CALL 'update display volume'(volume)
    
	//First, we hide all of the buttons we're not using
	SEND_COMMAND dvTouchPanel,"'^SHO-', itoa(LENGTH_ARRAY(buttons_used)+1),'.', itoa(LENGTH_ARRAY(source_buttons)), ',0'"
	
	//And show the ones we are
	SEND_COMMAND dvTouchPanel, "'^SHO-1.', itoa(LENGTH_ARRAY(buttons_used)), ',1'"
	
	//then we go through each button and assign the correct images
	for(iterator = 1; iterator <= LENGTH_ARRAY(buttons_used); iterator++)
	{
	    //clear all page flips
	    SEND_COMMAND dvTouchPanel, "'^CPF-', iterator"
	
	    //set the off image
	    SEND_COMMAND dvTouchPanel,"'^BMP-', itoa(iterator), ',1,', SOURCE_IMAGES[buttons_used[iterator]],'Off.png'"
	    //and the on image
	    SEND_COMMAND dvTouchPanel,"'^BMP-', itoa(iterator), ',2,', SOURCE_IMAGES[buttons_used[iterator]],'On.png'"
	    
	    //and the page flips
	    if(buttons_used[iterator] == SOURCE_DVD)SEND_COMMAND dvTouchPanel,"'^APF-', itoa(iterator), ',Show,DVD Controls'"
	    else SEND_COMMAND dvTouchPanel,"'^APF-', itoa(iterator), ',Hide,DVD Controls'"
	    
	    if(buttons_used[iterator] == SOURCE_VCR)SEND_COMMAND dvTouchPanel,"'^APF-', itoa(iterator), ',Show,VCR Controls'"
	    else SEND_COMMAND dvTouchPanel,"'^APF-', itoa(iterator), ',Hide,VCR Controls'"
	    
	    //If the button leads to more than one sub-button, we add the relevant page flip
	    if(LENGTH_ARRAY(extra_buttons_used[iterator]) > 1)
	    {
		SEND_COMMAND dvTouchPanel, "'^APF-', itoa(iterator), ',Show,extra sources'"
	    }
	    else
	    {
		SEND_COMMAND dvTouchPanel, "'^APF-', itoa(iterator), ',Hide,extra sources'"
	    }
	}
    }
}

CHANNEL_EVENT[vdvProjectorFeedback, SOURCE_BUTTONS] //channel events are used to set sources
{
    ON:
    {
	index = GET_LAST(SOURCE_BUTTONS)
	if(LENGTH_ARRAY(extra_buttons_used[index]) > 1)
	{
	    start = index
	    if(start + LENGTH_ARRAY(extra_buttons_used[index]) + 4 > 10)start = 5 - LENGTH_ARRAY(extra_buttons_used[index]) + 1
	    
	    //If there are fewer than 2 sources, use the small background image
	    if(LENGTH_ARRAY(extra_buttons_used[index]) <= 2)
	    {
		SEND_COMMAND dvTouchPanel, "'^BMP-11,1,two extra sources.png'"
		SEND_COMMAND dvTouchPanel, "'^JSB-11,0,-2,', itoa((start-1)*(65 + 7) + 7 - 2)"
	    }
	    else
	    {
		SEND_COMMAND dvTouchPanel, "'^BMP-11,1,extra_sources.png'"
		SEND_COMMAND dvTouchPanel, "'^JSB-11,0,5'"
	    }
	
	    //hide all of the buttons
	    SEND_COMMAND dvTouchPanel, "'^SHO-6.10,0'"
	    //show the ones we are using
	    SEND_COMMAND dvTouchPanel, "'^SHO-', itoa(start + 5), '.', itoa(LENGTH_ARRAY(extra_buttons_used[index]) + 5 + start - 1),',1'"
	    
	    for(iterator = 1; iterator <= LENGTH_ARRAY(extra_buttons_used[index]); iterator++)
	    {
		SEND_COMMAND dvTouchPanel, "'^BMP-', ITOA(4 + iterator + start), ',1,', EXTRA_IMAGES[extra_buttons_used[index][iterator]], 'Off.png'"
		SEND_COMMAND dvTouchPanel, "'^BMP-', ITOA(4 + iterator + start), ',2,', EXTRA_IMAGES[extra_buttons_used[index][iterator]], 'On.png'"
		
		if([dvTouchPanel, SOURCE_BUTTONS[index]] = false)
		{
		    [dvTouchPanel, 4 + iterator + start] = false
		}
	    }
	    main_source = index
	    current_extra_buttons_index = index
	    top_index = start + 5
	}

	if([dvTouchPanel, SOURCE_BUTTONS[index]] = false)
	{
	    //first we de-select all of the sources
	    for(iterator = 1; iterator <= LENGTH_ARRAY(SOURCE_BUTTONS); iterator++)
	    {
		[dvTouchPanel, SOURCE_BUTTONS[iterator]] = false
	    }
	    //then we select the source we want
	    [dvTouchPanel, SOURCE_BUTTONS[index]] = true
	    
	    
	}
    }
}

CHANNEL_EVENT[vdvProjectorFeedback, extra_buttons]
{
    ON:
    {
	SEND_STRING 0, 'Extra buttons toggled'
	for(iterator = 1; iterator <= LENGTH_ARRAY(extra_buttons); iterator++)
	{
	    [dvTouchPanel, extra_buttons[iterator]] = false
	}
	[dvTouchPanel, extra_buttons[GET_LAST(extra_buttons)]] = true
	WAIT(2)
	{
	    SEND_COMMAND dvTouchPanel, "'@PPF-extra sources'"
	}
	//SEND_COMMAND dvTouchPanel, "'^BMP-', ITOA(index), ',1,', EXTRA_IMAGES[current_extra_buttons[GET_LAST(extra_buttons)-top_index]], 'Off.png'"
	//SEND_COMMAND dvTouchPanel, "'^BMP-', ITOA(index), ',1,', EXTRA_IMAGES[current_extra_buttons[GET_LAST(extra_buttons)-top_index]], 'On.png'"
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
	SEND_LEVEL dvTouchPanel, ONOFF_BUTTON_CONTROLS[GET_LAST(ONOFF_BUTTON_DISPLAYS)], 0
	SEND_COMMAND dvTouchPanel, "'^ani-', itoa(ONOFF_BUTTON_DISPLAYS[GET_LAST(ONOFF_BUTTON_DISPLAYS)]), ',1,',itoa(TOTAL_ONOFF_STATES),',2'"
	ONOFF_STATES[GET_LAST(ONOFF_BUTTON_DISPLAYS)] = total_onoff_states
    }
    OFF:
    {
	SEND_COMMAND dvTouchPanel, "'^ani-', ITOA(ONOFF_BUTTON_DISPLAYS[GET_LAST(ONOFF_BUTTON_DISPLAYS)]), ',', itoa(TOTAL_ONOFF_STATES) ,',1,2'"
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
    RELEASE:
    {
	LOCAL_VAR INTEGER currentOnOffCounter
	currentOnOffCounter = onOffProtectCounter[GET_LAST(ONOFF_BUTTON_CONTROLS)]
	if(ONOFF_LEVELS[GET_LAST(ONOFF_BUTTON_CONTROLS)] <= 50)
	{
	    SEND_STRING 0, 'On off button on'
	    ON[vdvProjectorFeedback, ONOFF_BUTTON_DISPLAYS[GET_LAST(ONOFF_BUTTON_CONTROLS)]];
	    ON[dvTouchPanel, ONOFF_BUTTON_DISPLAYS[GET_LAST(ONOFF_BUTTON_CONTROLS)]];
	}
	else
	{
	    SEND_STRING 0, 'On off button off'
	    OFF[vdvProjectorFeedback, ONOFF_BUTTON_DISPLAYS[GET_LAST(ONOFF_BUTTON_CONTROLS)]];
	    OFF[dvTouchPanel, ONOFF_BUTTON_DISPLAYS[GET_LAST(ONOFF_BUTTON_CONTROLS)]];
	}

	protectOnOffButtons[GET_LAST(ONOFF_BUTTON_CONTROLS)] = true
	onOffProtectCounter[GET_LAST(ONOFF_BUTTON_CONTROLS)]++
	WAIT 50
	{
	    //this is a crude mechanism to allow the protect time to be extended by each new button press
	    protectOnOffButtons[GET_LAST(ONOFF_BUTTON_CONTROLS)] = false
	}

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
		    currentState = 'on'
		    SEND_COMMAND dvTouchPanel, '^ANI-50,2,2'
		    
		    CALL 'switch button'(true, PROJECTOR_ONOFF_DISPLAY)
		    cooling = false
		    
		    //enable the mute on/off button
		    SEND_COMMAND dvTouchPanel, '^BOP-27,0,0'
		    SEND_COMMAND dvTouchPanel, '^ENA-27,1'
		    SEND_COMMAND dvTouchPanel, '^BOP-34,0,255'
		    
		    /*if(!projectorSwitchedToSource)
		    {
			CALL 'switch source'(currentSource)
		    }*/
		}
		case 'Projector Off':
		{
		    currentState = 'off'
		    SEND_COMMAND dvTouchPanel, '^ANI-50,1,1'
		    
		    CALL 'switch button'(false, PROJECTOR_ONOFF_DISPLAY)
		    //OFF[vdvProjectorFeedback, VIDEO_MUTE_ONOFF_DISPLAY]
		    cooling = false
		    
		    //enable the on/off button
		    SEND_COMMAND dvTouchPanel, '^BOP-25,0,0'
		    SEND_COMMAND dvTouchPanel, '^ENA-25,1'
		    SEND_COMMAND dvTouchPanel, '^BOP-29,0,255'
		}
		case 'Projector Warming Up':
		{
		    currentState = 'warming'
		    SEND_COMMAND dvTouchPanel, '^ANI-50,4,4'
		    CALL 'switch button'(true, PROJECTOR_ONOFF_DISPLAY)
		    cooling = false
		}
		case 'Projector Cooling Down':
		{
		    currentState = 'cooling'
		    SEND_COMMAND dvTouchPanel, '^ANI-50,5,5'
		    CALL 'switch button'(false, PROJECTOR_ONOFF_DISPLAY)
		    //disable the on/off button, both visually and functionally
		    SEND_COMMAND dvTouchPanel, '^BOP-25,0,200'
		    SEND_COMMAND dvTouchPanel, '^ENA-25,0'
		    SEND_COMMAND dvTouchPanel, '^BOP-29,0,0'
		    
		    //disable the mute on/off button
		    SEND_COMMAND dvTouchPanel, '^BOP-27,0,200'
		    SEND_COMMAND dvTouchPanel, '^ENA-27,0'
		    SEND_COMMAND dvTouchPanel, '^BOP-34,0,0'
		}
	    }
	    if(DATA.TEXT = 'Video Mute On')
	    {
		SEND_COMMAND dvTouchPanel, '^ANI-50,3,3'
		CALL 'switch button'(true, VIDEO_MUTE_ONOFF_DISPLAY)
		muted = true
	    }
	    else
	    {
		CALL 'switch button'(false, VIDEO_MUTE_ONOFF_DISPLAY)
		muted = false
	    }
	}
    }
}

TIMELINE_EVENT[1]
{
    switch(currentSource)
    {
	case 'on':
	{
	    SEND_COMMAND dvTouchPanel, '^ANI-50,2,2'
	    CALL 'switch button'(true, PROJECTOR_ONOFF_DISPLAY)
	    //enable the mute on/off button
	    SEND_COMMAND dvTouchPanel, '^BOP-27,0,0'
	    SEND_COMMAND dvTouchPanel, '^ENA-27,1'
	    SEND_COMMAND dvTouchPanel, '^BOP-34,0,255'
	}
	case 'off':
	{
	    SEND_COMMAND dvTouchPanel, '^ANI-50,1,1'
	    CALL 'switch button'(false, PROJECTOR_ONOFF_DISPLAY)
	    
	    //enable the on/off button
	    SEND_COMMAND dvTouchPanel, '^BOP-25,0,0'
	    SEND_COMMAND dvTouchPanel, '^ENA-25,1'
	    SEND_COMMAND dvTouchPanel, '^BOP-29,0,255'
	}
	case 'warming':
	{
	    SEND_COMMAND dvTouchPanel, '^ANI-50,4,4'
	    CALL 'switch button'(true, PROJECTOR_ONOFF_DISPLAY)
	}
	case 'cooling':
	{
	    SEND_COMMAND dvTouchPanel, '^ANI-50,5,5'
	    CALL 'switch button'(false, PROJECTOR_ONOFF_DISPLAY)
	    
	    //disable the on/off button, both visually and functionally
	    SEND_COMMAND dvTouchPanel, '^BOP-25,0,200'
	    SEND_COMMAND dvTouchPanel, '^ENA-25,0'
	    SEND_COMMAND dvTouchPanel, '^BOP-29,0,0'
	    
	    //disable the mute on/off button
	    SEND_COMMAND dvTouchPanel, '^BOP-27,0,200'
	    SEND_COMMAND dvTouchPanel, '^ENA-27,0'
	    SEND_COMMAND dvTouchPanel, '^BOP-34,0,0'
	}
    }
    if(muted)
    {
	CALL 'switch button'(true, VIDEO_MUTE_ONOFF_DISPLAY)
    }
    else
    {
	CALL 'switch button'(false, VIDEO_MUTE_ONOFF_DISPLAY)
    }
}


/////////////////////////////
//// Touchscreen Buttons ////
/////////////////////////////

//Get the level set by dragging the bar graph
DATA_EVENT[dvTouchPanel] {
    STRING: {
	SEND_STRING 0, DATA.TEXT
    }
}

//sign out of the touch panel
BUTTON_EVENT[dvTouchPanel,24] {
    PUSH: 
    {
	CALL 'touchpanel shutdown'
    }
}

//the projector on/off button
CHANNEL_EVENT[vdvProjectorFeedback,PROJECTOR_ONOFF_DISPLAY] {
    ON: 
    {
	SEND_STRING 0, 'Projector turned on'
	CALL 'projector power on'
    }
    OFF:
    {
	SEND_STRING 0, 'Projector turned off'
	CALL 'projector power off'
    }
}


//the video mute on/off button
CHANNEL_EVENT[vdvProjectorFeedback,VIDEO_MUTE_ONOFF_DISPLAY] {
    ON: 
    {
	CALL 'video mute on'
    }
    OFF:
    {
	CALL 'video mute off'
    }
}

//source switching buttons
BUTTON_EVENT[dvTouchPanel,source_buttons] {
    PUSH: { CALL 'switch source' (GET_LAST(source_buttons)) }
}

BUTTON_EVENT[dvTouchPanel, extra_buttons] {
    PUSH: { CALL 'switch source' (5+GET_LAST(extra_buttons)) }
}
/* Volume buttons
 */
//volume increase button
BUTTON_EVENT[dvTouchPanel, 30] {
    PUSH: {
	CALL 'increase volume'
    }
    HOLD[1, REPEAT]: {
	CALL 'increase volume'
    }
}
//volume decrease button
BUTTON_EVENT[dvTouchPanel, 31] {
    PUSH: {
	CALL 'decrease volume'
    }
    HOLD[1, REPEAT]: {
	CALL 'decrease volume'
    }
}

//Volume mute button
BUTTON_EVENT[dvTouchPanel, 32] {
    PUSH: {
	CALL 'mute volume'
	[dvTouchPanel, 32] = ![dvTouchPanel, 32]
	//SEND_LEVEL, dvTouchPanel
    }
}

//Dragging on the volume bar
LEVEL_EVENT[dvTouchPanel, 33] {
    if(!volumeIsMuted)volume = LEVEL.VALUE;
    CALL 'update amp volume'(volume)
}

BUTTON_EVENT[dvTouchPanel, 150]
{
    PUSH: {
	SEND_COMMAND dvTouchPanel, '^BOP-151,0,255'
	WAIT(20)
	{
	    SEND_COMMAND dvTouchPanel, '^BOP-151,0,0'
	}
    }
}

////////////////////////////////////////
/////        DVD Controls         //////
////////////////////////////////////////


(***********************************************************)
(*            THE ACTUAL PROGRAM GOES BELOW                *)
(***********************************************************)
DEFINE_PROGRAM


(***********************************************************)
(*                     END OF PROGRAM                      *)
(*        DO NOT PUT ANY CODE BELOW THIS COMMENT           *)
(***********************************************************)
