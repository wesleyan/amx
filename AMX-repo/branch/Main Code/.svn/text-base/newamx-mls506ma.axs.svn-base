PROGRAM_NAME='NewAMX'
/*System type: NetLinx
 *	Summary:
 *		This is a code rewrite for Generation 4 touchpanels.
 *		It should be essentially the same as the old code, with
 *		much-improved readability and understandability.
 *		(and hopefully without any bugs that plagued the old code)
 *
 *	Author:
 *		Sam DeFabbia-Kane
 *		(rewritten based on code by Catalino Cuadrado)
 *
 *	Summer 2009, more extensive rewrite by Micah Wylde
 */
 
 
/*	Device Number Definitions:
 */
DEFINE_DEVICE
//NETLINX Integrated Controller Ports:
dvTouchPanel = 10001:1:0
dvVideoSwitcher = 5001:1:0
dvProjector = 5001:4:0
dvDVDPlayer = 5001:5:0 //formerly dvDVD
dvVCR = 5001:9:0
 
//virtual devices:
//for the MLS 506MA
vdvVideoSwitcher = 33001:1:0
vdvVSMod         = 33001:1:0    
vdvGainMod       = 33001:2:0
vdvTrebleMod     = 33001:3:0
vdvBassMod       = 33001:4:0
vdvVolumeMod     = 33001:5:0
//other stuff
vdvProjector     = 33004:1:0
vdvDVDPlayer     = 33005:5:0
vdvTouchPanel    = 33006:1:0


/* Constants:
 */
DEFINE_CONSTANT

//these correspond to sources in sourceButtons[]--names are for convenience
SOURCE_COMPUTER = 4
SOURCE_DVD = 1
SOURCE_VCR = 3
SOURCE_AUX_VGA = 5
SOURCE_AUX_RCA = 6

//buttons to change sources on the touch panel:
INTEGER SOURCE_BUTTONS[7] = {
    SOURCE_DVD,
    2,
    SOURCE_VCR,
    SOURCE_COMPUTER,
    SOURCE_AUX_VGA,
    SOURCE_AUX_RCA,
    7
}

//These are feedback numbers that are pulsed to vdvProjector
VOLATILE INTEGER ON_FB = 101
VOLATILE INTEGER COOLING_FB = 102
VOLATILE INTEGER WARMING_FB = 103
VOLATILE INTEGER MUTE_FB = 120

VOLATILE INTEGER Proxy_FB_RGB1 = 107
VOLATILE INTEGER Proxy_FB_RGB2 = 108
VOLATILE INTEGER Proxy_FB_VID = 109
VOLATILE INTEGER Proxy_FB_SVID = 110
VOLATILE INTEGER Proxy_FB_DIG = 111
VOLATILE INTEGER Proxy_FB_DIV = 112
VOLATILE INTEGER Proxy_FB_COMP = 113
VOLATILE INTEGER Proxy_FB_SCART = 114

//These are buttons that when when one presses them are highlighted until one stops pressing them
INTEGER TOGGLE[10] = {
    32    	   //mute
}

SOURCE_TYPE[7][3] = {
    'VID',
    '',
    'VID',
    'RGB',
    'RGB',
    'VID',
    ''
}

//volume control constants
VOLUME_MAX = 100
VOLUME_MIN = 0
VOLUME_STEP = 5

INTEGER transport_inputs[]=
{
    61,//Play
    66,//PAUSE
    67,//Stop
    62,//search FF
    60,//search REW
    68,//skip fwd
    65 //skip rev
}

INTEGER DVD_MENU_NAV[] =
{
    69,  //UP
    71,  //LEFT	
    63,  //MENU	
    70, //RIGHT
    72, //DOWN
    12, //ENTER
    99  //EJECT
}


/*	Variables
 */
DEFINE_VARIABLE
 
INTEGER currentSource = 0
VOLATILE INTEGER currentSourceButton = 0
INTEGER intTransportButtonIndex = 0


VOLATILE LONG longTimelineFeedbackArray[1]

//the volume -- persistent so rebooting the netlinx does not affect volume level
VOLATILE INTEGER volume = VOLUME_MIN
VOLATILE INTEGER volumeIsMuted = 0

VOLATILE LONG longTimelineFeedbackID = 1

/*	Include Statements
 */
//dvProjector functions
#INCLUDE 'NP2000VideoProjectorInclude.axi'
//use one of the following
//#INCLUDE 'MLS506MAVideoSwitcher.axi'
#INCLUDE 'ExtronSystem10Include.axi'


/*	Volume Translation
 */
//change from X/100 volume to X/255
DEFINE_FUNCTION INTEGER amxToExtronVolume(INTEGER vol) {
    STACK_VAR INTEGER converted 
    converted = (vol * VOLUME_MAX) / 255

    //sends to terminal for debugging
    send_string 0, "'	Converted Level = ', ITOA(converted), ', Original Level = ', ITOA(vol)"

    return converted
}

//change from X/255 volume to X/100
DEFINE_FUNCTION INTEGER extronToAMXVolume(INTEGER vol) {
    STACK_VAR INTEGER converted 
    converted = (vol * 255) / VOLUME_MAX

    //sends to terminal for debugging
    send_string 0, "'Converted Level = ', ITOA(converted), ', Original Level = ', ITOA(vol)"

    return converted
}


/*	Calls for button presses
 */
//turns the projector on if it is not already
DEFINE_CALL 'projector power on' {
    SEND_COMMAND vdvProjector, 'POWER=1'
}

//turns the projector off
DEFINE_CALL 'projector power off' {
    SEND_COMMAND vdvProjector, 'POWER=0'
}

//turns video mute on
DEFINE_CALL 'video mute on' {
    SEND_COMMAND vdvProjector, 'MUTE_PICTURE=1'
}

DEFINE_CALL 'video mute off' {
    SEND_COMMAND vdvProjector, 'MUTE_PICTURE=0'
}

DEFINE_CALL 'projector to video input' {
    SEND_COMMAND vdvProjector, "'INPUT=9'"
}

DEFINE_CALL 'projector to rgb2 input' {
    SEND_COMMAND vdvProjector, "'INPUT=8'"
}

//switch sources
DEFINE_CALL 'switch source' (INTEGER source[]) {
    currentSourceButton = GET_LAST(source)
    currentSource = input_Channels[currentSourceButton]
    //tell the Extron switcher to switch sources
    //PULSE[vdvVideoSwitcher, currentSource]
    PULSE[vdvTouchpanel, currentSource]
    
    IF ( SOURCE_TYPE[currentSourceButton] == 'VID' ) {
	CALL 'projector to video input'
	//I have no idea what this does...
	IF ( currentSource == SOURCE_DVD || currentSource == SOURCE_VCR ) {
	    INTEGER buttonIndex;
	    FOR (buttonIndex = 14; buttonIndex <= 18; buttonIndex++) {
		[dvTouchPanel, intTransportButtonIndex] = 0
	    }
	}
	//show DVD/VCR control buttons
	SEND_COMMAND dvTouchPanel, '^SHO-7,1'
    }
    ELSE IF ( SOURCE_TYPE[currentSourceButton] == ' RGB ' ) {
	CALL 'projector to rgb2 input'
	//hide DVD/VCR control buttons
	SEND_COMMAND dvTouchPanel, '^SHO-7,0'
    }
}

DEFINE_CALL 'touchpanel shutdown' {

    //turn dvProjector off if it's on
    WAIT 10 { CALL 'projector power off' }

}

DEFINE_CALL 'increase volume' {
    //increase the volume by one step
    volume = volume + VOLUME_STEP
    IF(volume > VOLUME_MAX) volume = VOLUME_MAX

    //update the touchpanel volume display
    CALL 'update display volume' (volume)
    CALL 'update amp volume' (volume)

    //if the volume is muted, we want to un-mute it
    IF (volumeIsMuted) {
	volumeIsMuted = 0;
    }
}

DEFINE_CALL 'decrease volume' {
    //if the volume is not at the minimum already
    //decrease the volume by one step
    volume = volume - VOLUME_STEP
    IF (volume < VOLUME_MIN || volume >=  65531) volume = VOLUME_MIN

    //update the touchpanel volume display
    CALL 'update display volume' (volume)
    CALL 'update amp volume' (volume)

    //if the volume is muted, we want to un-mute it
    IF (volumeIsMuted) {
	volumeIsMuted = 0;
    }
}

DEFINE_CALL 'mute volume' {
    IF ( NOT(volumeIsMuted) ) {
	volumeIsMuted = 1
	CALL 'update amp volume' (0)
	CALL 'update display volume' (0)
    }
    ELSE IF ( volumeIsMuted ) {
	volumeIsMuted = 0
	CALL 'update amp volume' (volume)
	CALL 'update display volume' (volume)
    }
}

//update the volume of the actual sound device
//for this code, that's an MLS 506MA
DEFINE_CALL 'update amp volume' (INTEGER vol) {
    PULSE[vdvVolumeMod,vol]
}

//updates the volume shown on the touchpanel
DEFINE_CALL 'update display volume' (INTEGER vol) {
    SEND_LEVEL dvTouchPanel, 33, vol
}

/*	Startup Code
 */
DEFINE_START

WAIT 300 {
    longTimelineFeedbackArray[1] = 500
    TIMELINE_CREATE (longTimelineFeedbackID, longTimelineFeedbackArray, 1,
					TIMELINE_RELATIVE, TIMELINE_REPEAT )
}

//Extron 506MA module
DEFINE_MODULE 'ExtronMLS506MA_mod' vs1 (dvVideoSwitcher,vdvVSMod,vdvGainMod,vdvTrebleMod,vdvBassMod,vdvVolumeMod)

//Projector Module
DEFINE_MODULE 'NECConversionModule' conversionModule(dvProjector, vdvProjector)

//Projector Feedback module--mediates between the projector and the touchpanel
DEFINE_MODULE 'ProjectorFeedback' projectorFeedback(vdvProjector, vdvTouchPanel)

//DVD control module-no feedback channels implemented yet.
DEFINE_MODULE 'DenonDVD-DNV300' dvDVDPlayer1 (dvDVDPlayer, vdvDVDPlayer, transport_inputs, dvd_menu_nav)

DEFINE_MODULE 'TouchscreenModule' touchscreenModule(dvTouchPanel, vdvTouchPanel)

/*	Events
 */
DEFINE_EVENT

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
/*BUTTON_EVENT[dvTouchPanel,25] {
    PUSH: { 
	//CALL 'projector power on'
	SEND_STRING vdvProjectorFeedback, 'Projector Warming'
	//pulse[vdvProjectorFeedback, 25]
    }
}*/

//the projector on/off button
CHANNEL_EVENT[dvTouchPanel,26] {
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
CHANNEL_EVENT[dvTouchPanel,28] {
    ON: 
    {
	SEND_STRING 0, 'Video mute turned on'
	CALL 'video mute on'
    }
    OFF:
    {
	SEND_STRING 0, 'Video mute turned off'
	CALL 'video mute off'
    }
}




//source switching buttons
BUTTON_EVENT[dvTouchPanel,SOURCE_BUTTONS] {
    PUSH: { CALL 'switch source' (SOURCE_BUTTONS) }
}

/* Volume buttons
 */
//volume increase button
BUTTON_EVENT[dvTouchPanel, 30] {
    PUSH: {
	CALL 'increase volume'
    }
    HOLD[5, REPEAT]: {
	CALL 'increase volume'
    }
}
//volume decrease button
BUTTON_EVENT[dvTouchPanel, 31] {
    PUSH: {
	CALL 'decrease volume'
    }
    HOLD[5, REPEAT]: {
	CALL 'decrease volume'
    }
}

//Volume mute button
BUTTON_EVENT[dvTouchPanel, 32] {
    PUSH: {
	CALL 'mute volume'
	//SEND_LEVEL, dvTouchPanel
    }
}

//Dragging on the volume bar
LEVEL_EVENT[dvTouchPanel, 33] {
    SEND_STRING 0, "'Level: ', itoa(LEVEL.VALUE)"
    volume = LEVEL.VALUE;
    CALL 'update amp volume'(volume)
}

BUTTON_EVENT[dvTouchPanel, TOGGLE]{
    PUSH: {
	//SEND_COMMAND dvTouchPanel, "'^ANI-',ITOA(TOGGLE[GET_LAST(TOGGLE)]),',1,2,10'"
	[dvTouchPanel,TOGGLE[GET_LAST(TOGGLE)]] = ![dvTouchPanel,TOGGLE[GET_LAST(TOGGLE)]]
    }
}

////////////////////////////////////////
/////        DVD Controls         //////
////////////////////////////////////////

BUTTON_EVENT[dvTouchPanel, transport_inputs]
{
    PUSH: {
	PULSE[vdvDVDPlayer, transport_inputs[GET_LAST(transport_inputs)]]
    }
}

BUTTON_EVENT[dvTouchPanel, dvd_menu_nav]
{
    PUSH: {
	PULSE[dvDVDPlayer, dvd_menu_nav[GET_LAST(dvd_menu_nav)]]
    }
}

/* The main program loop. This should be empty or nearly so.
 *
 */
DEFINE_PROGRAM