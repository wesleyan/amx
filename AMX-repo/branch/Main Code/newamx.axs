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
 */
 
 
/*	Device Number Definitions:
 */
DEFINE_DEVICE
//NETLINX Integrated Controller Ports:
dvTouchPanel = 10011:1:0
dvVideoSwitcher = 5001:1:0
dvProjector = 5001:4:0
dvDVDPlayer = 5001:5:0 //formerly dvDVD
dvVolumeDevice = 150:1:0 //formerly dvVol
dvVCR = 5001:9:0
 
//virtual devices:
vdvVideoSwitcher = 33001:1:0 //formerly vdvVideoSwitcher
vdvProjector = 33004:1:0 //formerly vdvProjector
vdvDVDPlayer = 33005:5:0 //formerly vdvDVD


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
VOLUME_MAX = 255
VOLUME_MIN = 0
VOLUME_STEP = 5


//DVD control channels/buttons (not sure on term...)
// G4 dvDVDPlayer pop-up buttons numerically match Denon RS232 module input channels
VOLATILE INTEGER dvDVDPlayerButtons[] = {
    //Play, Pause, Stop, FF, Rewind, skip forward, skip back
    14, 15, 16, 17, 18, 38, 37
}


/*	Variables
 */
DEFINE_VARIABLE
 
INTEGER currentSource = 0
VOLATILE INTEGER currentSourceButton = 0
INTEGER intTransportButtonIndex = 0
CHAR charProjectorStatsXMLString[5000]

VOLATILE LONG longTimelineFeedbackArray[1]

//the volume -- persistent so rebooting the netlinx does not affect volume level
PERSISTENT INTEGER volume
VOLATILE INTEGER volumeIsMuted = 0

VOLATILE LONG longTimelineFeedbackID = 1


/*	Include Statements
 */
//dvProjector functions
#INCLUDE 'NP2000VideoProjectorInclude.axi'
//use one of the following
//#INCLUDE 'MLS506MAVideoSwitcher.axi'
#INCLUDE 'ExtronSystem10Include.axi'

/*	Calls and Functions
 *	(encapsulation is a *good* thing)
 *   --calls have no return value: "DEFINE_CALL <'name'> (param1, param2) {}"
 *   --functions do: "DEFINE_FUNCTION <return type> <name> (param1, param2) {}"
 */
 
/*	Projector Status
 */ 
//returns 1 (true) if dvProjector is on, 0 (false) otherwise
DEFINE_FUNCTION INTEGER projectorIsOn {
    return [vdvProjector, intProjectorOnFeedbackChannel]
}

//returns true if dvProjector is cooling, false otherwise
DEFINE_FUNCTION INTEGER projectorIsCooling {
    return [vdvProjector, intProjectorCoolingFeedbackChannel]
}


/*	Calls for button presses
 */
//turns the projector on if it is not already
DEFINE_CALL 'projector power on' {
    PULSE[vdvProjector, intProjectorOnInput]
    OFF[dvProjector, 50]
    //if the projector is not on, turn it on
    IF ( NOT ( projectorIsOn() ) ) {
	//button animation
	SEND_COMMAND dvTouchPanel,"'^ANI-2,5,5'"
	
	WAIT 200 {
	    ON[dvProjector,50]
	}
    }
}

//turns the projector off
DEFINE_CALL 'projector power off' {
    PULSE[vdvProjector, intProjectorOffInput]
}

//toggles the video mute on or off
DEFINE_CALL 'toggle video mute' {
    //if the projector is muted, unmute it
    IF ( [vdvProjector,120] ) {
	PULSE[vdvProjector,intProjectorMuteOffInput]
    }
    Else { //if not, mute it
	PULSE[vdvProjector,intProjectorMuteOnInput]
    }
}

DEFINE_CALL 'projector to video input' {
    PULSE[vdvProjector, intProjectorVideoInputChannel]
}

DEFINE_CALL 'projector to rgb2 input' {
    PULSE[vdvProjector, intProjectorRGB2InputChannel]
}

//switch sources
DEFINE_CALL 'switch source' (INTEGER source[]) {
    currentSourceButton = GET_LAST(source)
    currentSource = input_Channels[currentSourceButton]
    //tell the Extron switcher to switch sources
    PULSE[vdvVideoSwitcher, currentSource]
    
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
    //hide buttons
    SEND_COMMAND dvTouchPanel, "'^SHO-5,0'"
    SEND_COMMAND dvTouchPanel, "'^SHO-5,0'"
    
    //turn dvProjector off if it's on
    IF ( projectorIsOn() ) {  
	WAIT 10 { CALL 'projector power off' }
	//button animation
	SEND_COMMAND dvTouchPanel, "'^ANI-3,2,2'"
    }
    
    WAIT 1000 {
	//once the projector is done cooling down (if it was just turned off),
	// return to the home screen
	WAIT_UNTIL ( NOT (projectorIsCooling()) ) {
	    //button animation
	    SEND_COMMAND dvTouchPanel, "'^ANI-3,3,3'"
	    
	    WAIT 50 {
		//button animation
		SEND_COMMAND dvTouchPanel, "'^ANI-3,1,1'"
		//show buttons
		SEND_COMMAND dvTouchPanel, "'^SHO-5,1'"
		SEND_COMMAND dvTouchPanel, "'^SHO-6,1'"
		//popup the shutdown confirmation page
		SEND_COMMAND dvTouchPanel, "'@PPK-Shutdown Confirm'"
		//'flip' to the Wesleyan University page
		SEND_COMMAND dvTouchPanel, "'PAGE-Wesleyan University Page'"
	    }
	}	
    }
}


DEFINE_CALL 'increase volume' {
    //if the volume is not at the maximum already
    IF ( (volume + VOLUME_STEP) <= VOLUME_MAX ) {
	//increase the volume by one step
	volume = volume + VOLUME_STEP
	//update the touchpanel volume display
	CALL 'update display volume' (volume)
	//if the volume is not muted, update the amplfier volume
	IF ( NOT(volumeIsMuted) ) {
		CALL 'update amp volume' (volume)
	}
    }
}

DEFINE_CALL 'decrease volume' {
    //if the volume is not at the minimum already
    IF ( (volume - VOLUME_STEP) >= VOLUME_MIN ) {
	//decrease the volume by one step
	volume = volume - VOLUME_STEP
	//update the touchpanel volume display
	CALL 'update display volume' (volume)
	//if the volume is not muted, update the amplifier volume
	IF ( NOT(volumeIsMuted) ) {
	    CALL 'update amp volume' (volume)
	}
    }
}

DEFINE_CALL 'mute volume' {
    IF ( NOT(volumeIsMuted) ) {
	volumeIsMuted = 1
    }
    ELSE IF ( volumeIsMuted ) {
	volumeIsMuted = 0
	CALL 'update amp volume' (volume)
    }
}

//update the volume of the actual sound device
DEFINE_CALL 'update amp volume' (INTEGER vol) {
    SEND_LEVEL dvVolumeDevice, 1, vol
    SEND_LEVEL dvVolumeDevice, 2, vol
}

//updates the volume shown on the touchpanel
DEFINE_CALL 'update display volume' (INTEGER vol) {
    SEND_LEVEL dvTouchPanel, 3, vol
}


/*	Startup Code
 */
DEFINE_START

CREATE_LEVEL volume, 1, intVolumeLevel

//get maximum volume level from the extron system 10 switcher file
intVolumeMaxValue = intMaximumVolumeLevel

WAIT 300 {
    longTimelineFeedbackArray[1] = 500
    TIMELINE_CREATE (longTimelineFeedbackID, longTimelineFeedbackArray, 1,
					TIMELINE_RELATIVE, TIMELINE_REPEAT )
}


//Extron System 10 Module
DEFINE_MODULE 'ExtronSystem10VideoSwitchMod' vs1 (dvVideoSwitcher,vdvVideoSwitcher) 
//Projector #2 Module
DEFINE_MODULE 'NEC1065_Qmodule_rev' prmod1 (dvProjector,vdvProjector,charProjectorStatsXMLString) 
//DVD control module-no feedback channels implemented yet.
DEFINE_MODULE 'DenonDVD-DNV300' dvDVDPlayer1 (dvDVDPlayer, vdvDVDPlayer) 


/*	Events
 */
DEFINE_EVENT

//sign out of the touch panel
BUTTON_EVENT[dvTouchPanel,24]

//the on button
BUTTON_EVENT[dvTouchPanel,25] {
    PUSH: { CALL 'projector power on' }
}

//the off button
BUTTON_EVENT[dvTouchPanel,26] {
    PUSH: { CALL 'projector power off' }
}

//the video mute button
BUTTON_EVENT[dvTouchPanel,27] {
    PUSH: { CALL 'toggle video mute' }
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
BUTTON_EVENT[dvTouchPanel, 30] {
    PUSH: {
	CALL 'decrease volume'
    }
    HOLD[5, REPEAT]: {
	CALL 'decrease volume'
    }
}