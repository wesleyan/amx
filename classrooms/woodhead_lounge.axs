PROGRAM_NAME='woodhead_lounge'
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
dvVolume        = 150:2:0
 
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
    SOURCE_VCR,
    SOURCE_DVD,
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
INTEGER EXTRON_PORTS[][] =
{
    {4},
    {5},
    {2},
    {1},
    {3}
}

//gives the input on the projector for the above sources
CHAR SOURCE_INPUT[10][4] = {
    'RGB1',
    'RGB1',
    'VID',
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

//DVD control module-no feedback channels implemented yet.
DEFINE_MODULE 'DenonDVD-DNV300' dvDVDPlayer1 (dvDVDPlayer, vdvDVDPlayer, transport_inputs, dvd_menu_nav)

DEFINE_MODULE 'TouchscreenModule' touchscreenModule(dvTouchPanel, vdvTouchPanel, vdvProjector, vdvRoomSpecific, buttons_used, extra_buttons)


/*	Events
 */
DEFINE_EVENT

DATA_EVENT[dvTouchPanel]
{
    ONLINE:
    {
	//Hide the volume controls, as they don't actually control anything in this room
	SEND_COMMAND dvTouchPanel, '^SHO-30.33,0'
	
	//set the background images of both the main page and the welcome page to the usdan one
	//SEND_COMMAND dvTouchPanel, '^BMP-130,1,Usdan_Panoramic.jpg'
	//SEND_COMMAND dvTouchPanel, '^BMP-131,1,Usdan_Panoramic.jpg'
	
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