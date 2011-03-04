PROGRAM_NAME='Usdan 104/136'
/*System type: NetLinx
 *	Summary:
 *		This is a code rewrite for Generation 4 touchpanels.
 *		It should be essentially the same as the old code, with
 *		much-improved readability and understandability.
 *		(and hopefully without any bugs that plagued the old code)
 *
 *	Authors:
 *		Sam DeFabbia-Kane
 *		(rewritten based on code by Catalino Cuadrado)
 *		
 *		Micah Wylde
 *		Rewrite based on Sam's code, summer 2009
 *		Amongst the many features of this rewrite, the most important
 *		are a generalization of projector code (through a conversion class)
 *		and a much greater degree of modularization, which removes from the main
 *		file (this one) almost everything that is generic to all of the 
 *		rooms, leaving only a small amount of stuff room-specific
 */
 
 
/*	Device Number Definitions:
 */
DEFINE_DEVICE
//NETLINX Integrated Controller Ports:
dvTouchPanel    = 10011:1:0
dvVideoSwitcher = 5001:1:0
dvProjector     = 5001:4:0
dvCombo	        = 5001:9:0 
 
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

//this is for room-specific stuff, to reduce the amount of code duplication
vdvRoomSpecific  = 33007:1:0

/* Constants:
 */
DEFINE_CONSTANT

SOURCE_MAC = 1
SOURCE_PC = 2
SOURCE_LAPTOP = 3
SOURCE_DVD = 4
SOURCE_VCR = 5
SOURCE_AUX = 6

//buttons to change sources on the touch panel:
INTEGER BUTTONS_USED[] = {
    SOURCE_MAC,
    SOURCE_LAPTOP,
    SOURCE_DVD,
    SOURCE_VCR,
    SOURCE_AUX
}

INTEGER EXTRA_BUTTONS[][] = {
    {0},
    {0},
    {0},
    {0},
    {0}
}


//gives the port on the extron for the sources above
INTEGER EXTRON_PORTS[] =
{
    6,
    5,
    1,
    1,
    3
}

//gives the input on the projector for the above sources
CHAR SOURCE_INPUT[7][4] = {
    'RGB2',
    'RGB2',
    'VID',
    'VID',
    'VID'
}


VOLATILE INTEGER combo_tp_controls[] = {61,67,66,68,65,62,60,63,69,72,71,70,73}
VOLATILE INTEGER combo_vcr_controls[] = {80, 85, 84, 68, 83, 82, 81}
VOLATILE INTEGER combo_channels[] = {1,2,3,4,5,6,7,44,45,46,47,48,49}

LONG updateTPTimeline[] = {1000}

/*	Variables
 */
DEFINE_VARIABLE

integer waitOnExtron = false 
integer volume = 0


//this is the most bizarre thing I've ever seen, but it works so I'm not touching it
DEFINE_FUNCTION INTEGER intConvertLevelToExtronVolume(INTEGER amxval)
{

    STACK_VAR FLOAT floatconvert 
    STACK_VAR INTEGER decimalplace
    STACK_VAR INTEGER myrounded
    
    floatconvert = amxval*100/255
    decimalplace = FIND_STRING( FTOA(floatconvert) ,'.',1)

    IF(decimalplace)
	myrounded = ATOI(LEFT_STRING( FTOA(floatconvert), decimalplace))
    ELSE
	myrounded = ATOI( FTOA(floatconvert) ) 

    send_string 0, "'AMX = ', ITOA(amxval),'. Set Extron volume to ',ITOA(myrounded)"
    
    RETURN myrounded


}

//switch sources
DEFINE_CALL 'switch source' (INTEGER source) {

    //tell the Extron switcher to switch sources
    PULSE[vdvVideoSwitcher, extron_ports[source]]
    
    //pulse the combo player to switch to the vcr or dvd part
    if(BUTTONS_USED[source] == SOURCE_VCR)PULSE[dvCombo,112]
    if(BUTTONS_USED[source] == SOURCE_DVD)Pulse[dvCombo,111]

    
    IF ( SOURCE_INPUT[source] = 'VID' ) {
	SEND_STRING 0, 'Source is VID'
	SEND_COMMAND vdvProjector, "'INPUT=9'"
    }
    ELSE IF (SOURCE_INPUT[source] = 'RGB1')
    {
	SEND_STRING 0, 'Source is RGB1'
	SEND_COMMAND vdvProjector, "'INPUT=7'"
    }
    ELSE IF ( SOURCE_INPUT[source] = 'RGB2' ) {
	SEND_COMMAND vdvProjector, "'INPUT=8'"
    }
}

//update the volume of the actual sound device
DEFINE_CALL 'update amp volume' (INTEGER vol) {
    //PULSE[vdvVolumeMod, intConvertLevelToExtronVolume(vol)+1]
    send_string dvVideoSwitcher, "ITOA(intConvertLevelToExtronVolume(vol)+1),'V'"
    //SEND_LEVEL dvVolume, 1, vol
}


/*	Startup Code
 */
DEFINE_START

//Extron 506MA module
DEFINE_MODULE 'ExtronMLS506MA_mod' vs1 (dvVideoSwitcher,vdvVSMod,vdvGainMod,vdvTrebleMod,vdvBassMod,vdvVolumeMod)

//DEFINE_MODULE 'VideoSwitch_mod' videoSwitchModule(dvVideoSwitcher, vdvVSMod)

//Projector Module
DEFINE_MODULE 'NECConversionModule' conversionModule(dvProjector, vdvProjector)

//Projector Feedback module--mediates between the projector and the touchpanel
DEFINE_MODULE 'ProjectorFeedback' projectorFeedback(vdvProjector, vdvTouchPanel)

DEFINE_MODULE 'TouchscreenModule' touchscreenModule(dvTouchPanel, vdvTouchPanel, vdvProjector, vdvRoomSpecific, buttons_used, extra_buttons)

//TIMELINE_CREATE(1, updateTPTimeline, 1, TIMELINE_RELATIVE, TIMELINE_REPEAT)

/*	Events
 */
DEFINE_EVENT

DATA_EVENT[dvTouchPanel]
{
    ONLINE:
    {
	SEND_COMMAND dvTouchPanel, '^BPP-140,2'
    }
}

DATA_EVENT[vdvRoomSpecific]
{
    STRING:
    {
	SELECT
	{
	    ACTIVE (FIND_STRING (DATA.TEXT,'source=',1)):
	    {
		REMOVE_STRING (DATA.TEXT,'source=',1)
		SEND_STRING 0, "'Source is ', DATA.TEXT"
		CALL 'switch source'(ATOI(DATA.TEXT))
	    }
	    ACTIVE (FIND_STRING (DATA.TEXT,'volume=',1)):
	    {
		REMOVE_STRING (DATA.TEXT,'volume=',1)
		SEND_STRING 0, "'Volume is ', ITOA(ATOI(DATA.TEXT))"
		CALL 'update amp volume'(ATOI(DATA.TEXT))
		volume = atoi(DATA.TEXT)
	    }
	}
    }
}

BUTTON_EVENT[dvTouchPanel,combo_vcr_controls]
{
    PUSH:
    {
	PULSE[dvCombo,combo_channels[GET_LAST(combo_vcr_controls)]]
    }
}
BUTTON_EVENT[dvTouchPanel,combo_tp_controls]
{
    PUSH:
    {
	PULSE[dvCombo,combo_channels[GET_LAST(combo_tp_controls)]]
    } 
}

/*TIMELINE_EVENT[1]
{
    [dvTouchPanel,1] = [vdvVSMod,111]
    [dvTouchPanel,3] = [vdvVSMod,111]
    [dvTouchPanel,4] = [vdvVSMod,114]
    [dvTouchPanel,5] = [vdvVSMod,115]
    [dvTouchPanel,6] = [vdvVSMod,113]
}*/


/* The main program loop. This should be empty or nearly so.
 *
 */
DEFINE_PROGRAM