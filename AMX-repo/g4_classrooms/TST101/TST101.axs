PROGRAM_NAME='TST101'
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
dvDVDPlayer     = 5001:5:0 //formerly dvDVD
dvVCR           = 5001:9:0

//we;re using channel two because channel one appears to be broken in this room
dvVolume        = 150:1:0
 
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
    SOURCE_PC,
    SOURCE_LAPTOP,
    SOURCE_VCR,
    SOURCE_DVD
}

//extra sources
SOURCE_LAPTOP_RACK   = 1
SOURCE_LAPTOP_PODIUM = 2
SOURCE_AUX_RACK      = 3
SOURCE_AUX_PODIUM    = 4

INTEGER EXTRA_BUTTONS[][] = {
    {0},
    {0},
    {0},
    {0},
    {0}
}

//gives the port on the extron for the sources above
INTEGER EXTRON_PORTS[][] =
{
    {2},
    {1},
    {5},
    {4},
    {3}
}

//gives the input on the projector for the above sources
CHAR SOURCE_INPUT[10][4] = {
    'RGB1',
    'RGB1',
    'RGB1',
    'VID',
    'VID'
}

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
    73, //ENTER
    99  //EJECT
}

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

INTEGER vcr_buttons[] =
{
    80, //play
    81, //
    82,
    83,
    84,
    85,
    86
}

/*	Variables
 */
DEFINE_VARIABLE
 
//switch sources
DEFINE_CALL 'switch source' (INTEGER source, INTEGER extra) {

    //tell the Extron switcher to switch sources
    PULSE[vdvVideoSwitcher, extron_ports[source][extra]]
    
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
    //PULSE[vdvVolumeMod,vol]
    SEND_LEVEL dvVolume, 2, vol
    SEND_LEVEL dvVolume, 1, vol
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

//DVD control module-no feedback channels implemented yet.
DEFINE_MODULE 'DenonDVD-DNV300' dvDVDPlayer1 (dvDVDPlayer, vdvDVDPlayer, transport_inputs, dvd_menu_nav)

DEFINE_MODULE 'TouchscreenModule' touchscreenModule(dvTouchPanel, vdvTouchPanel, vdvProjector, vdvRoomSpecific, buttons_used, extra_buttons)


/*	Events
 */
DEFINE_EVENT


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
		IF(FIND_STRING(DATA.TEXT,',',1) == 0)
		{
		    CALL 'switch source'(ATOI(DATA.TEXT), 1)
		}
		else
		{
		    SEND_STRING 0, "'LEFT: ', LEFT_STRING(DATA.TEXT, FIND_STRING(DATA.TEXT,',',1)-1)"
		    SEND_STRING 0, "'RIGHT: ', RIGHT_STRING(DATA.TEXT, FIND_STRING(DATA.TEXT,',',1)-1)"
		    CALL 'switch source'(ATOI(LEFT_STRING(DATA.TEXT, FIND_STRING(DATA.TEXT,',',1)-1)), ATOI(RIGHT_STRING(DATA.TEXT, FIND_STRING(DATA.TEXT,',',1)-1)))
		}
	    }
	    ACTIVE (FIND_STRING (DATA.TEXT,'volume=',1)):
	    {
		REMOVE_STRING (DATA.TEXT,'volume=',1)
		SEND_STRING 0, "'Volume is ', ITOA(ATOI(DATA.TEXT))"
		CALL 'update amp volume'(ATOI(DATA.TEXT))
	    }
	}
    }
}


/*BUTTON_EVENT[dvTouchPanel, transport_inputs]
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
}*/

BUTTON_EVENT[dvTouchPanel, transport_inputs]
{
    PUSH:
    {
	SEND_STRING dvDVDPlayer,"'[PC,RC,',ITOA(TRANSPORT_RC_CODES[GET_LAST(transport_inputs)]),']',13"
    }
}
BUTTON_EVENT[dvTouchPanel, dvd_menu_nav]
{
    PUSH:
    {
	SEND_STRING dvDVDPlayer,"'[PC,RC,',ITOA(DVD_MENU_NAV_RC_CODES[GET_LAST(dvd_menu_nav)]),']',13"
    }
}

BUTTON_EVENT[dvTouchPanel, vcr_buttons]
{
    PUSH: {
	SYSTEM_CALL 'VCR1'(dvVCR, dvTouchPanel, 80, 85, 84, 82, 81, 68, 83, 0, 0)
    }
}


/* The main program loop. This should be empty or nearly so.
 *
 */
DEFINE_PROGRAM