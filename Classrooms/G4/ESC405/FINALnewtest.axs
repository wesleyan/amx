PROGRAM_NAME='MAIN SOURCE,REV 3 with DVD menu,mhe,Rev 0'
(*{{PS_SOURCE_INFO(PROGRAM STATS)                          *)
(***********************************************************)
(*  FILE CREATED ON: 08/15/2001 AT: 16:43:56               *)
(***********************************************************)
(*  FILE_LAST_MODIFIED_ON: 10/22/2003 AT: 09:01:44         *)
(***********************************************************)
(*  ORPHAN_FILE_PLATFORM: 1                                *)
(***********************************************************)
(***********************************************************)
(*!!FILE REVISION: Rev 0                                   *)
(*  REVISION DATE: 01/31/2003                              *)
(*                                                         *)
(*  COMMENTS:                                              *)
(*                                                         *)
(***********************************************************)
(*!!FILE REVISION: REV 2,mhe                               *)
(*  REVISION DATE: 09/12/2002                              *)
(*                                                         *)
(*  COMMENTS:                                              *)
(*  corrected     problem with "cooling" popup not closing     *)
(*  implemented use of projector module for second proj    *)
(*  added auto email for misc projector errors             *)
(*  added auto email for loss of proj communication        *)
(*  changed proj bulb warning times to 1200 and 1500 hrs   *)
(*  added user-configurable auto shutdown with snooze      *)
(*  added code-driven password access to audit page        *)
(***********************************************************)
(*!!FILE REVISION: REV 1                                   *)
(*  REVISION DATE: 08/12/2002                              *)
(*                                                         *)
(*  COMMENTS:                                              *)
(*  ADDED 10 MORE ROOM DEFINITIONS, DIRECT BULB LIFE       *)
(*  READING AND DEVICE USAGE AUDITING.  MADE SLIGHT UI     *)
(*  CHANGES                                                *)
(***********************************************************)
(*!!FILE REVISION: REV 0                                   *)
(*  REVISION DATE: 01/16/2002                              *)
(*                                                         *)
(*  COMMENTS:                                              *)
(*                                                         *)
(***********************************************************)
(*!!FILE REVISION: REV 00 BETA                             *)
(*  REVISION DATE: 09/05/2001                              *)
(*                                                         *)
(*  COMMENTS:                                              *)
(*                                                         *)
(***********************************************************)
(*}}PS_SOURCE_INFO                                         *)
(***********************************************************)

(***********************************************************)
(* System Type : Netlinx                                   *)
(***********************************************************)
(* REV HISTORY:                                            *)
(***********************************************************)

(***********************************************************)
(*          DEVICE NUMBER DEFINITIONS GO BELOW             *)
(***********************************************************)

DEFINE_DEVICE

(* LOCAL DEVICES *)
dvROUTER        = 5001:1:0       //Video Switcher - EXTRON  8/10 9600 N,8,1
vdvROUTER			  = 33001:1:0			 //Video Switcher Virtual Device

dvPROJ2         = 5001:2:0       // Projector 2 - NEC MT 38400 N,8,1 F
vdvProj2        = 33001:2:0      // Projector 2 Virtual Device

dvPCSWITCH      = 5001:3:0       // KVM Switch - BLACKBOX SERVSWITCH ULTRA 9600 N,8,1
vdvPCSWITCH			= 33001:3:0			 // KVM Switch Virtual Device

dvProj          = 5001:4:0       // Projector 1 - NEC MT 38400 N,8,1
vdvProj         = 33001:4:0      // Projector 1 Virtual Device

vdvProjtest     = 33002:1:0				//testing my module

dvRELAY         = 5001:7:0       // 3 SCREENS RELAYS 1-6 MOMENTARY 'SCREEN2' NOT IN ALL SYSTEMS

dvVCR           = 5001:8:0       // VCR 

dvDVD           = 5001:9:0       // DVD PLAYER

LIGHTS          = 5001:5:0       //lUTRON GRAPHIC EYE FOR SC 58

dvDVDEBUG       = 0:0:0          // DEBUG DEVICE



vdvALERTER			= 33002:2:0

(* AXLINK DEVICES *)

dvVOLUME        = 150:1:0        // VOLUME CARD

vdvTP           = 33000:1:0      // VIRTUAL TOUCH PANEL      
dvTP1           = 128:1:0        // AXT-MLC IN PAC001, PAC004        
dvTP2           = 132:1:0        // AXT-CA10 JUDD116, SC509A
dvTP3           = 136:1:0        // AXT-MCP DAC100
dvRADIO         = 140:1:0        // AXR-RF VIEW POINT VPT-GS IN PAC125, PAC002, PAC107
                                 // VPT-CP IN ROOM SC509A
dvWEB1          = 10001:1:0      // WEBPNL IN NETLINX USE CA10 FILE AND CONVERT TO HTML
//dvMVP						= 10010:1:0			//MVP-7500
                                 // FTP TO NETLINX MASTERS...IN ALL SYSTEMS          


//DEFINE_COMBINE  PUT IN DEFINE_START!!!!!!!!!!!!!
//(vdvTP,dvTP1,dvWEB1,dvTP2,dvTP3,dvRADIO)

//DEFINE_CONNECT_LEVEL
//(dvVOLUME,1,dvVOLUME,2,vdvTP,1)

(***********************************************************)
(*               INCLUDE FILES GO BELOW                    *)
(***********************************************************)
#INCLUDE 'i!-EmailOut.axi'      // INCLUDE TO SEND EMAIL
#INCLUDE 'SystemNumbers.axi'
#INCLUDE 'G3withoutTP.axi'

//#INCLUDE 'TimeManager_inc.axi'
(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT

VOLATILE LONG GOING_ON_MIDNIGHT = 86400   //seconds in a day

// TIMELINES
VOLATILE LONG TL_VCR_TIMEOUT  = 1
VOLATILE LONG TL_DVD_TIMEOUT  = 2
VOLATILE LONG TL_CAS_TIMEOUT  = 3
VOLATILE LONG TL_TTB_TIMEOUT  = 4
VOLATILE LONG TL_DISP_REFRESH = 5
VOLATILE LONG TL_AUTO_OFF     = 6
VOLATILE LONG TL_TEST					= 7
VOLATILE LONG TL_BLINK				= 8

TRUE            = 1
FALSE           = 0

VOLATILE INTEGER NONE = 0 //fill for projector source lookup table where source does not use video


(* SOURCES *)
RACK_PC         = 1
RACK_MAC        = 2
RACK_LAP        = 3
FB_LAP          = 4
WB_LAP          = 5
POD_LAP         = 6
DOC_CAM         = 7
VCR             = 8
DVD             = 9
RACK_VID        = 10
FB_VID          = 11
CASS            = 12
TURNTABLE       = 13
VCR_CC          = 14
RACK_LD         = 15

(* PROJECTOR COMMANDS 
PROJ_POW_ON     = 1
PROJ_COOLING    = 2
PROJ_WARMING    = 3
PROJ_POW_OFF    = 4
PROJ_MUTE       = 5
PROJ_LAMP_RESET = 6
PROJ_RGB1_IN    = 7
PROJ_RGB2_IN    = 8
PROJ_VID_IN     = 9
PROJ_SVID_IN    = 10
*)

//new changes I MADE
PROJ_POW_ON     = 1
PROJ_WARMING    = 3
PROJ_POW_OFF    = 4
PROJ_MUTE_ON    = 5
PROJ_MUTE_OFF		= 6
PROJ_LAMP_RESET = 66

PROJ_RGB1_IN    = 7
PROJ_RGB2_IN    = 8
PROJ_VID_IN     = 9
PROJ_SVID_IN    = 10

PROJ_POWER			= 101
PROJ_COOLING    = 102
PROJ_MUTE				=	120

//error feedback channels
PROJ_COVER_OPEN = 201
PROJ_TEMP_FAULT = 202
PROJ_FAN_STOP   = 203
PROJ_PWR_SUPPLY = 204
PROJ_LAMP_FAIL  = 205
PROJ_COMM_ACTIVE = 255


(* VCR TRANSPORT CONTROLS *)

VCR_PLAY        = 40
VCR_STOP        = 41
VCR_PAUSE       = 42
VCR_FFWD        = 43
VCR_REW         = 44
VCR_SFWD        = 45
VCR_SREV        = 46
VCR_REC         = 47

VOLATILE INTEGER VCR_TRANSPORT_BUTTONS[] =
{
	VCR_PLAY,      
	VCR_STOP,       
	VCR_PAUSE,      
	VCR_FFWD,       
	VCR_REW,        
	VCR_SFWD,       
	VCR_SREV,       
	VCR_REC        
}


(* DVD TRANSPORT CONTROL BUTTONS *)

DVD_PLAY        = 48
DVD_STOP        = 49
DVD_PAUSE       = 50
DVD_FSCAN       = 51
DVD_RSCAN       = 52
DVD_FSKIP       = 53
DVD_RSKIP       = 54
DVD_MENU        = 70
DVD_ENTER       = 71
DVD_UP          = 72
DVD_DOWN        = 73
DVD_LEFT        = 74
DVD_RIGHT       = 75


VOLATILE INTEGER DVD_TRANSPORT_BUTTONS[] =
{
	DVD_PLAY,
	DVD_STOP,
	DVD_PAUSE,      
	DVD_FSCAN,       
	DVD_RSCAN,
	DVD_FSKIP, 
	DVD_RSKIP
}

VOLATILE CHAR NECerror_ON[6][255]=
{
	'The cover has been opened on a projector in this room. Please verify that this is due to scheduled maintenance or contact security!', //COVER
	'A projector in this room is reporting a high temperature condition.', //TEMP
	'A projector in this room is reporting a fan stoppage.', //FAN
	'A projector in this room is reporting a power supply failure.', //PS
	'A projector in this room is reporting that a lamp has failed to light. This could indicate imminent or current bulb failure.',  //LAMP
	'The communications link to the projector in this room has been restored.'
}

VOLATILE CHAR NECerror_OFF[6][255]=
{
	'The cover has been closed on the projector in this room.', //COVER
	'The projector in this room is no longer reorting a high temperature condition.', //TEMP
	'The projector in this room is no longer reporting a fan stoppage.', //FAN
	'The projector in this room is no longer reorting a power supply failure.', //PS
	'The lamp of the projector in this room is now operating normally.', //LAMP
	'The communications link to the projector in this room has been interrupted. Please verify that this is due to scheduled maintenance or contact Security.'
}

VOLATILE INTEGER NECerror_fbchannels[]=
{
	PROJ_COVER_OPEN,
	PROJ_TEMP_FAULT,
	PROJ_FAN_STOP,
	PROJ_PWR_SUPPLY,
	PROJ_LAMP_FAIL,
	PROJ_COMM_ACTIVE
}

(*this table links the projector module source input channels 
	with the sources on the tp *)
VOLATILE INTEGER SUBNAV_INPUT_SIGNAL[]=
{
	PROJ_RGB1_IN,	//'RACK PC',      // 1
	PROJ_RGB1_IN,	//'RACK MAC',      // 2
	PROJ_RGB1_IN,	//'RACK LAPTOP',      // 3
	PROJ_RGB1_IN,	//'FLOOR BOX LAPTOP',      // 4
	PROJ_RGB1_IN,	//'WALL BOX LAPTOP',      // 5
	PROJ_RGB1_IN,	//'PODIUM LAPTOP',      // 6
	PROJ_RGB1_IN,	//'DOCUMENT CAMERA',      // 7
	PROJ_VID_IN,	//'VCR',      // 8
	PROJ_VID_IN,	//'DVD',      // 9
	PROJ_VID_IN,	//'RACK AUX VIDEO',      // 10
	PROJ_VID_IN,	//'FLOOR BOX AUX VIDEO',      // 11
	NONE,	//'CASSETTE PLAYER',      // 12
	NONE,	//'TURNTABLE',      // 13
	PROJ_VID_IN,	//'VCR w/CC',      // 14
	PROJ_VID_IN		//'LASERDISK'      // 15
}


VOLATILE CHAR SUBNAV_TXT[15][20]=
{
'RACK PC',      // 1
'RACK MAC',      // 2
'RACK LAPTOP',      // 3
'FLOOR BOX LAPTOP',      // 4
'WALL BOX LAPTOP',      // 5
'PODIUM LAPTOP',      // 6
'DOCUMENT CAMERA',      // 7
'VCR',      // 8
'DVD',      // 9
'RACK AUX VIDEO',      // 10
'FLOOR BOX AUX VIDEO',      // 11
'CASSETTE PLAYER',      // 12
'TURNTABLE',      // 13
'VCR w/CC',      // 14
'LASERDISK'      // 15
}

VOLATILE CHAR SUBNAV_PPAGE[15][25] = 
{
	'PPON-Use Local Controls',		//1
	'PPON-Use Local Controls',		//2
	'PPON-Use Local Controls',		//3
	'PPON-Use Local Controls',		//4
	'PPON-Use Local Controls',		//5
	'PPON-Use Local Controls',		//6
	'PPON-Use Local Controls',		//7
	'PPON-VCR Controls',					//8
	'PPON-DVD Controls',					//9
	'PPON-Use Local Controls',		//10
	'PPON-Use Local Controls',		//11
	'PPON-Use Local Controls',		//12
	'PPON-Use Local Controls',		//13
	'PPON-VCR Controls',					//14
	'PPON-Use Local Controls'			//15
}

VOLATILE INTEGER vswitch_input_fb[] =
{
	121,
	122,
	123,
	124,
	125,
	126,
	127,
	128,
	129,
	130
}

VOLATILE INTEGER proj_signal_fb[]=  //rgb1,rgb2,video,etc feedback
{
	107,
	108,
	109,
	110,
	111,
	112,
	113,
	114
}


//----REMOVED - MUST BE VARIABLE
// EMAIL RECIPIENT ADDRESSES...SEPERATE ADDRESSES WITH AN ASCII ";"
//EmailToWho = 'ccaesar@wesleyan.edu;cjcwes@excite.com' 

(***********************************************************)
(*              DATA TYPE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_TYPE

(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE

VOLATILE INTEGER extron_inputs[][] = 
{
	1, //1
	2, //2
	5, //3,
	7, //4
	0,	//5,
	0,	//6,
	10,	//7,
	4,	//8,
	3,	//9,
	6,	//10,
	8,	//11,
	0,	//12,
	0,	//13,
	9,	//14,
	0		//15
}





// EMAIL RECIPIENT ADDRESSES...SEPERATE ADDRESSES WITH AN ASCII ";"
VOLATILE CHAR EmailToWho[1000]  = 'hello' 

VOLATILE CHAR ProjectorXML[50000] = ''

VOLATILE CHAR emaillist_1[20][50]=  //email list from xml file
{
'mofo@wesleyan.edu',
'mofo2@wesleyan.edu'
}
VOLATILE CHAR emaillist_default[20][50]=
{
'caesar@wesleyan.edu'
}

VOLATILE SLONG slReturn
VOLATILE SLONG s1File
VOLATILE INTEGER test = 0
VOLATILE INTEGER testres = 0


PERSISTENT INTEGER PCSOURCEPAGE   //SET 'PC SOURCES x' POPUP PAGE (x=1-12)
PERSISTENT INTEGER VIDSOURCEPAGE  //SET 'VID SOURCES x' POPUP PAGE (x=1-11)


VOLATILE INTEGER TOTALSCREENS = 1	 //NUMBER OF SCREEN BEING CONTROLLED

VOLATILE INTEGER mailsent

VOLATILE INTEGER BLINK	//controls blinking of proj mute button

VOLATILE INTEGER DEBUG  // who knows????

VOLATILE INTEGER DACPC

(* EMAIL MESSAGES  - REPLACED BY ARRAYS ABOVE					
ProjOneEmailFirstWarn[255] 
ProjOneEmailFinalWarn[255]
ProjTwoEmailFirstWarn[255]
ProjTwoEmailFinalWarn[255]
ProjOneCoverWarn[255]
ProjOneCoverWarnOff[255]
ProjOneTempWarn[255]
ProjOneTempWarnOff[255]
ProjOneFanWarn[255]
ProjOneFanWarnOff[255]
ProjOnePowerSupplyWarn[255]
ProjOnePowerSupplyWarnOff[255]
ProjOneLampFail[255]
ProjOneCommFail[255]
ProjOneCommFailOff[255]
ProjTwoCoverWarn[255]
ProjTwoCoverWarnOff[255]
ProjTwoTempWarn[255]
ProjTwoTempWarnOff[255]
ProjTwoFanWarn[255]
ProjTwoFanWarnOff[255]
ProjTwoPowerSupplyWarn[255]
ProjTwoPowerSupplyWarnOff[255]
ProjTwoLampFail[255]
ProjTwoCommFail[255]
ProjTwoCommFailOff[255]
*)
(*
VOLATILE CHAR SystemName[39][15] =
{
'PAC 001',      // SYSTEM 1
'PAC 002',      // SYSTEM 2
'PAC 004',      // SYSTEM 3
'PAC 107',      // SYSTEM 4
'PAC 125',      // SYSTEM 5
'JUDD 116',     // SYSTEM 6
'DAC 100',      // SYSTEM 7
'SC 509A',      // SYSTEM 8
'JUDD 214',     // SYSTEM 9
'PAC 422',      // SYSTEM 10
'JUDD 113',     // SYSTEM 11
'SC 109',       // SYSTEM 12
'OLIN 327B',    // SYSTEM 13
'RH 003',       // SYSTEM 14
'DAC 300',      // SYSTEM 15
'MS 301',       // SYSTEM 16
'ANTHRO 6MM',   // SYSTEM 17 ** !!REV1 ADDED SYSTEMS 17-26           //CHANGE THIS
'FISK 302',     // SYSTEM 18
'FISK 210',     // SYSTEM 19
'FISK 305',     // SYSTEM 20
'FISK 314',     // SYSTEM 21
'FISK 404',     // SYSTEM 22
'FISK 413',     // SYSTEM 23
'FISK 414',     // SYSTEM 24
'HALL ATWATER', // SYSTEM 25  		//CHANGE THIS
'ZILKHA 106',   // SYSTEM 26      //CHANGE THIS
'SC 121',       // SYSTEM 27
'FISK 115',     // SYSTEM 28
'FISK 116',     // SYSTEM 29
'FISK 101',     // SYSTEM 30
'SCIE 137',     // SYSTEM 31
'SCIE 139',     // SYSTEM 32
'SCIE 141',     // SYSTEM 33
'SCIE 309',			// SYSTEM 34
'SCIE 405',     // SYSTEM 35
'SCIE 58' ,     // SYSTEM 36
'SHAN 201',     // SYSTEM 37
'TEST 000',   	// SYSTEM 38
'SHAN 107'			// SYSTEM 39
}
*)

DEV darPROJECTORS[] = {vdvProj, vdvProj2}

VOLATILE DEVCHAN dcINPUTS[] =  // SYSTEM 8/10 ROUTER INPUT DIRECT BUTTONS
{
  {vdvTP,57},  // INPUT 1
  {vdvTP,58},
  {vdvTP,59},
  {vdvTP,60},
  {vdvTP,61},
  {vdvTP,62},
  {vdvTP,63},
  {vdvTP,64},
  {vdvTP,65},
  {vdvTP,66}   // INPUT 10
}

VOLATILE DEVCHAN dcSource[] =
{
    {vdvTP,3},               // SELECT RACK PC
    {vdvTP,4},               // SELECT RACK MAC
    {vdvTP,5},               // SELECT RACK LAPTOP
    {vdvTP,6},               // SELECT FLOOR BOX LAPTOP
    {vdvTP,7},               // SELECT WALL BOX LAPTOP
    {vdvTP,8},               // SELECT PODIUM LAPTOP
    {vdvTP,9},               // SELECT DOC CAM
    {vdvTP,10},              // SELECT VCR
    {vdvTP,11},              // SELECT DVD
    {vdvTP,12},              // SELECT RACK AUX VIDEO
    {vdvTP,13},              // SELECT FLOOR BOX AUX VIDEO
    {vdvTP,14},              // SELECT CASSETTE AUDIO
    {vdvTP,15},              // SELECT TURNTABLE AUDIO
    {vdvTP,16}               // SELECT VCR W/CC
}

DEVCHAN dcPopUp[] =          // THESE BUTTONS ARE FOR SYNCHRONIZATION OF THE POPUPS ON THE WEB PAGES
{
    {vdvTP,80},              // PC
    {vdvTP,81},              // VIDEO
    {vdvTP,82},              // ENVIRONMEN
    {vdvTP,83},              // UTILITIES 
    {vdvTP,84},              // MORE #1 
    {vdvTP,85},              // RETURN 
    {vdvTP,86},              // LIGHTS 
    {vdvTP,87},              // SCREEN 
    {vdvTP,88},              // VOLUME 
    {vdvTP,89},              // EXIT 
    {vdvTP,90},              // PROJECTOR CONTROLS
    {vdvTP,91},              // SHUTDOWN YES 
    {vdvTP,92},              // SHUTDOWN NO
    {vdvTP,93},              // PROTECTED PROJ SETUP 
    {vdvTP,94},              // LAMP HOUR RESET
    {vdvTP,95},              // LAMP HOUR RESET 2
    {vdvTP,96},              // MAIN PAGE ENTRY
    {vdvTP,97}               // EXTRON TECH ROUTER PAGES
}


(* NOT USED ANYMORE - REPLACED WITH SYS CALL
DEVCHAN dcDvdSkip[] =
{
    {vdvTP,53},               // DVD FORWARD SKIP
    {vdvTP,54}                // DVD REV SKIP
}
*)
VOLATILE INTEGER VSWITCH_LOOKUP[20]				//holds Video Switcher input lookup table

VOLATILE CHAR POP_LOOKUP[30][50] =
{
	'PPON-PC Sources ',   //1
	'PPON-Video Sources ', //2
	'PPON-Environment',		//3
	'PPON-Utilities',			//4
	'PPON-PC Sources 3',		//5
	'PPON-PC Sources 2',
	'PPON-Lighting Controls',
	'PPON-Screen Controls X2', //x
	'PPON-Volume Controls',
	'PPON-Shutdown',				//10
	'PPON-Projector Controls',
	'PAGE-Logo Page',
	'PPOF-Shutdown',
	'PPON-Protected Projector Controls',
	'PPON-Reset Lamp Hours',	//15
	'',
	'PAGE-Main Page',	//17
	'PPON-EXTRON10',
	'',
	'',			//20
	'PPON-Screen & Lights',			
	'',			
	'',			
	'',			
	'',			
	'',			
	'',			
	'',	
	'',
	'PAGE-Main Page with screens and lights'
}


(* SETUP VARIABLE TEXT AND POPUPS *)
VOLATILE INTEGER VOL_LVL	//hold dvVolume Level

VOLATILE INTEGER SOURCE 				//holds current extron input
VOLATILE INTEGER SOURCE_BUTTON  //holds dcSource button.input.channel (3-15)
VOLATILE INTEGER POP_FDBK				//holds getLast dcPopUp
VOLATILE INTEGER ENVIRONMENT		//holds dcPopUp button.input.channel

VOLATILE CHAR TP_BUFFER[255]
VOLATILE CHAR TP_MSG[100]
VOLATILE CHAR TRASH[100]

VOLATILE CHAR vdvProjBuffer[20] //used in ProcessProjectorString function
VOLATILE CHAR vdvProj2Buffer[20] //used in ProcessProjectorString function
VOLATILE CHAR vdvALERTERBuffer[30]
//VOLATILE CHAR TXT_LOOKUP[20][20]	//NOT USED ANYMORE - replaced with SUBNAV_TXT
//POP_LOOKUP[40][50]

//RTR_RESPONSE[100]
//ROUTER_BUFFER[255]
//PROJ2_BUFFER[255]


//PROJ1_PWR

//PROJ2_PWR
//PROJ2_MUTE
//PROJ2_MSG[100]

//PROJ2_CMD[10][30]

PERSISTENT Passwords[2][4] // 2 levels: tech, supertech

//proj1 usage time variables
PERSISTENT LAMP_HOURS
PERSISTENT LAMP_MINUTES
PERSISTENT LAMP_SECONDS

//proj2 usage time variables
PERSISTENT LAMP_HOURS2
PERSISTENT LAMP_MINUTES2
PERSISTENT LAMP_SECONDS2

//device usage time variables
PERSISTENT LONG AUDIT_VCR_SEC
PERSISTENT LONG AUDIT_DVD_SEC
PERSISTENT LONG AUDIT_CAS_SEC
PERSISTENT LONG AUDIT_TTB_SEC

//proj1 event flags
VOLATILE LAMP_FIRST_WARNING
VOLATILE LAMP_MAX
VOLATILE SENT_WARNING
VOLATILE SENT_FINAL_WARNING

//proj2 event flags
VOLATILE LAMP_FIRST_WARNING2
VOLATILE LAMP_MAX2
VOLATILE SENT_WARNING2
VOLATILE SENT_FINAL_WARNING2


VOLATILE CHAR SystemEmailAddress[40]


LONG lTimeArray[1]
LONG lAutoTimes[2] = {0,0}
LONG lAutoTimes2[2] = {1,2}



//device usage start time of day (seconds)
VOLATILE LONG VCR_START
VOLATILE LONG DVD_START
VOLATILE LONG CAS_START
VOLATILE LONG TTB_START


LONG TL6TIME

INTEGER nAutoTimeAdjust[] = {
          131,    // up; this code as vt will display set time
          132,    // down
          133,    // snooze off
          134,    // snooze :15
          135,    // snooze :30
          136,    // snooze :60
          137,    // warn :05
          138,    // warn :10
          139     // warn :15
          }
          
   //  - - -+-------------------+------------------!
   //    snooze                warn               off
   //        <- lAutoTimes[1] ->
   //                            <- lAutoTimes[2] ->

PERSISTENT LONG lAutoTime
 
(***********************************************************)
(*        SUBROUTINE/FUNCTION DEFINITIONS GO BELOW         *)
(***********************************************************)

DEFINE_FUNCTION CHAR[1000] SetEmailList(CHAR listin[20][50])
{
	STACK_VAR 
	INTEGER x
	CHAR str1[1000]
	str1=''
	FOR(x=1;x<=LENGTH_ARRAY(listin);x++)
	{
		str1 = "str1,listin[x],';'"
	}
	RETURN str1
}

DEFINE_FUNCTION SLONG writeXMLfile (CHAR strFilename[30], CHAR strXML[50000]) //convert Netlinx XML string variable to XML file
{
	STACK_VAR
	SLONG svFile
	SLONG svReturn
	
	svFile = FILE_OPEN("strFilename,'.xml'", 2)
	svReturn = FILE_WRITE(svFile, strXML, LENGTH_STRING(strXML))
	svReturn = FILE_CLOSE(svFIle)
	
	RETURN svReturn
}

DEFINE_FUNCTION CHAR[50000] getXMLfile (CHAR strFilename[100]) //convert XML file to Netlinx XML string variable
{
	STACK_VAR
	SLONG svFile
	SLONG svResult
	CHAR strXML[50000]
	
	svFile = FILE_OPEN("strFilename,'.xml'",1)
	svResult = FILE_READ(svFile,strXML,MAX_LENGTH_STRING(strXML))
	svResult = FILE_CLOSE(svFile)
	
	RETURN strXML
}


DEFINE_FUNCTION INTEGER start_counter(LONG counterid)
{
	SWITCH(counterid)
	{
		CASE TL_VCR_TIMEOUT:
		{
			IF(!VCR_START) // START COUNTING SECONDS, IF WE AREN'T ALREADY
			{
				VCR_START = TOD_IN_SECONDS()
			}
			
			IF(TIMELINE_ACTIVE(TL_VCR_TIMEOUT)) // RESET TIMEOUT TIMELINE, IF IT'S RUNNING
			{
				TIMELINE_SET(TL_VCR_TIMEOUT,0)
			}
			ELSE // OTHERWISE, START THE TIMEOUT TIMELINE
			{
				lTimeArray[1] = 7200000  // 2 HOUR TIMEOUT
				TIMELINE_CREATE(TL_VCR_TIMEOUT,lTimeArray,1,TIMELINE_ABSOLUTE,TIMELINE_ONCE)
  		}
		}
		
		CASE TL_DVD_TIMEOUT:
		{		  
			IF(!DVD_START) // START COUNTING SECONDS, IF WE AREN'T ALREADY
			{
				DVD_START = TOD_IN_SECONDS()
			}
			IF(TIMELINE_ACTIVE(TL_DVD_TIMEOUT)) // RESET TIMOUT TIMELINE, IF IT'S RUNNING
			{
				TIMELINE_SET(TL_DVD_TIMEOUT,0)
			}
			ELSE // OTHERWISE, START THE TIMEOUT TIMELINE
			{
				lTimeArray[1] = 7200000  // 2 HOUR TIMEOUT
				TIMELINE_CREATE(TL_DVD_TIMEOUT,lTimeArray,1,TIMELINE_ABSOLUTE,TIMELINE_ONCE)
			}
		}
		
		CASE TL_CAS_TIMEOUT:
		{
			IF(!CAS_START) // START COUNTING SECONDS, IF WE AREN'T ALREADY
			{
				CAS_START = TOD_IN_SECONDS()
			}
			IF(TIMELINE_ACTIVE(TL_CAS_TIMEOUT)) // RESET TIMOUT TIMELINE, IF IT'S RUNNING
			{
				TIMELINE_SET(TL_CAS_TIMEOUT,0)
			}
			ELSE // OTHERWISE, START THE TIMEOUT TIMELINE
			{
				lTimeArray[1] = 7200000  // 2 HOUR TIMEOUT
				TIMELINE_CREATE(TL_CAS_TIMEOUT,lTimeArray,1,TIMELINE_ABSOLUTE,TIMELINE_ONCE)
			}
		
		}
		CASE TL_TTB_TIMEOUT:
		{
			IF(!TTB_START) // START COUNTING SECONDS, IF WE AREN'T ALREADY
			{
				TTB_START = TOD_IN_SECONDS()
			}
			IF(TIMELINE_ACTIVE(TL_TTB_TIMEOUT)) // RESET TIMOUT TIMELINE, IF IT'S RUNNING
			{
				TIMELINE_SET(TL_TTB_TIMEOUT,0)
			}
			ELSE // OTHERWISE, START THE TIMEOUT TIMELINE
			{
				lTimeArray[1] = 7200000  // 2 HOUR TIMEOUT
				TIMELINE_CREATE(TL_TTB_TIMEOUT,lTimeArray,1,TIMELINE_ABSOLUTE,TIMELINE_ONCE)
			}		
		}
		
	}
}

DEFINE_FUNCTION INTEGER stop_counter(LONG counterid, INTEGER tlstop)
{
	SWITCH(counterid)
	{
		CASE TL_VCR_TIMEOUT:
		{
			IF(VCR_START)
			{
				IF( VCR_START <= TOD_IN_SECONDS() )
				{
					AUDIT_VCR_SEC = AUDIT_VCR_SEC + TOD_IN_SECONDS() - VCR_START
				}
				ELSE
				{
					AUDIT_VCR_SEC = AUDIT_VCR_SEC + TOD_IN_SECONDS() + (GOING_ON_MIDNIGHT - VCR_START)
				}
				VCR_START=0
			}	
		}
		CASE TL_DVD_TIMEOUT:
		{
			IF(DVD_START)
			{
				IF( DVD_START <= TOD_IN_SECONDS() )
				{
					AUDIT_DVD_SEC = AUDIT_DVD_SEC + TOD_IN_SECONDS() - DVD_START
				}
				ELSE
				{
					AUDIT_DVD_SEC = AUDIT_DVD_SEC + TOD_IN_SECONDS() + (GOING_ON_MIDNIGHT - DVD_START)
				}
				DVD_START=0
			}
		}
		CASE TL_CAS_TIMEOUT:
		{
			IF(CAS_START)
			{
				IF( CAS_START <= TOD_IN_SECONDS() )
				{
					AUDIT_CAS_SEC = AUDIT_CAS_SEC + TOD_IN_SECONDS() - CAS_START
				}
				ELSE
				{
					AUDIT_CAS_SEC = AUDIT_CAS_SEC + TOD_IN_SECONDS() + (GOING_ON_MIDNIGHT - CAS_START)
				}
				CAS_START = 0 // THIS WILL CAUSE A BUG IF THE OPERATOR HITS A TRANSPORT COMMAND AT EXACTLY MIDNIGHT
			}
		}
		CASE TL_TTB_TIMEOUT:
		{
			IF(TTB_START)
			{
				IF( TTB_START <= TOD_IN_SECONDS() )
				{
					AUDIT_TTB_SEC = AUDIT_TTB_SEC + TOD_IN_SECONDS() - TTB_START
				}
				ELSE
				{
					AUDIT_TTB_SEC = AUDIT_TTB_SEC + TOD_IN_SECONDS() + (GOING_ON_MIDNIGHT - TTB_START)
				}
				TTB_START = 0 // THIS WILL CAUSE A BUG IF THE OPERATOR HITS A TRANSPORT COMMAND AT EXACTLY MIDNIGHT
			}
		}
	}
	IF (tlstop)
	{
		IF(TIMELINE_ACTIVE(counterid))
			TIMELINE_KILL(counterid)
	}
}


DEFINE_FUNCTION CHAR ProcessProjectorString(DEV Proj)
{
  IF (Proj = vdvProj)
  {
    (* PROJECTOR 1 TIMER *)
    LAMP_SECONDS = ATOI(vdvProjBuffer)%60
    LAMP_MINUTES = (ATOI(vdvProjBuffer)/60)%60
    LAMP_HOURS   = ATOI(vdvProjBuffer)/3600
    
    SEND_COMMAND vdvTP,"'TEXT10-',ITOA(LAMP_HOURS),' Hrs|',ITOA(LAMP_MINUTES),' Mins'"
  }
  ELSE
  {
    (* PROJECTOR 2 TIMER *)
    LAMP_SECONDS2 = ATOI(vdvProj2Buffer)%60
    LAMP_MINUTES2 = (ATOI(vdvProj2Buffer)/60)%60
    LAMP_HOURS2   = ATOI(vdvProj2Buffer)/3600
    
    SEND_COMMAND vdvTP,"'TEXT12-',ITOA(LAMP_HOURS2),' Hrs|',ITOA(LAMP_MINUTES2),' Mins'"
  }
}

DEFINE_FUNCTION LONG TOD_IN_SECONDS()
{
  RETURN (TYPE_CAST(TIME_TO_HOUR(TIME))*3600 + TYPE_CAST(TIME_TO_MINUTE(TIME))*60 + TYPE_CAST(TIME_TO_SECOND(TIME)))
}

DEFINE_FUNCTION CHAR[300] PRINT_HEX(CHAR TSTRING[100])
{
 LOCAL_VAR CHAR TEMP_STR[100]
 LOCAL_VAR CHAR RETURN_STR[200]
 LOCAL_VAR CHAR HOLDER
 TEMP_STR = TSTRING
 RETURN_STR = "34"
 FOR (;LENGTH_STRING(TEMP_STR);)
 {
   HOLDER = GET_BUFFER_CHAR(TEMP_STR)
   IF ((HOLDER >= 65 AND HOLDER <=90)||(HOLDER >= 97 AND HOLDER <=122))
       RETURN_STR = "RETURN_STR,HOLDER,','"
   ELSE
       RETURN_STR = "RETURN_STR,ITOHEX(HOLDER),','"
 }
 SET_LENGTH_STRING(RETURN_STR,LENGTH_STRING(RETURN_STR)-1)
 RETURN_STR = "RETURN_STR,34"
 RETURN RETURN_STR
}

DEFINE_FUNCTION INTEGER send_projector_mail(INTEGER inchannel, CHAR flip[3])
{
	
	STACK_VAR CHAR msg[1000]
	
	SystemEmailAddress = "'panja@wesleyan.edu'"
	SWITCH(flip)
	{
		CASE 'ON':
		{
			msg = NECerror_ON[GET_LAST(NECerror_fbchannels)]
		}
		
		CASE 'OFF':
		{
			msg = NECerror_OFF[GET_LAST(NECerror_fbchannels)]
		}
	}
}

DEFINE_CALL 'PARSE TP'
{
  TP_MSG = TP_BUFFER
  CLEAR_BUFFER TP_BUFFER
  IF(DEBUG)
     SEND_STRING dvDVDEBUG,"'TP MSG - ',TP_MSG,13,10"
  SELECT
  {
    ACTIVE(FIND_STRING(TP_MSG,'PAGE-',1)):
    {
      SEND_COMMAND vdvTP,"TP_MSG"
    }
    ACTIVE(FIND_STRING(TP_MSG,'PPON-',1)):
    {
      SEND_COMMAND vdvTP,"TP_MSG"
    }
    ACTIVE(FIND_STRING(TP_MSG,'PPOF-',1)):
    {
      SEND_COMMAND vdvTP,"TP_MSG"
    }
    ACTIVE(FIND_STRING(TP_MSG,'KEYP-',1)):
    {
      TRASH = REMOVE_STRING(TP_MSG,'KEYP-',1)
      IF ((TP_MSG = "Passwords[1]") ||
          (TP_MSG = "Passwords[2]"))
      {
        SEND_COMMAND vdvTP,"'PAGE-Tech Page'"
        IF (TP_MSG = "Passwords[2]")
        {
          SEND_COMMAND vdvTP,"'@SHO',103,1"
          SEND_COMMAND vdvTP,"'@SHO',104,1"
          SEND_COMMAND vdvTP,"'@SHO',105,1"
          SEND_COMMAND vdvTP,"'@SHO',106,1"
          SEND_COMMAND vdvTP,"'@SHO', 94,1"
          SEND_COMMAND vdvTP,"'@SHO', 95,1"
          SEND_COMMAND vdvTP,"'@SHO',171,1"
        }
      }
      ELSE
      {
        SEND_COMMAND vdvTP,"'AKEYR'"
        SEND_COMMAND vdvTP,"'ADBEEP'"
      }
    }
  }
}


// SETUP SOURCE LOCATION OF EXTRON INPUTS
DEFINE_CALL 'SETUP' (CHAR SYSTEM[])
{
	SWITCH(SYSTEM)
	{
		CASE 'PAC 001':
		CASE 'TEST 000':
		{
		VSWITCH_LOOKUP[RACK_PC]     = 1
		VSWITCH_LOOKUP[RACK_MAC]    = 2
		VSWITCH_LOOKUP[DVD]         = 3
		VSWITCH_LOOKUP[VCR]         = 4
		VSWITCH_LOOKUP[RACK_LAP]    = 5
		VSWITCH_LOOKUP[RACK_VID]    = 6
		VSWITCH_LOOKUP[VCR_CC]      = 7
		VSWITCH_LOOKUP[FB_LAP]     = 8
		VSWITCH_LOOKUP[FB_VID]      = 9
		VSWITCH_LOOKUP[DOC_CAM]     = 10
		VSWITCH_LOOKUP[WB_LAP]      = 11
		}
		CASE 'PAC 002':
		{
		VSWITCH_LOOKUP[RACK_PC]     = 1
		VSWITCH_LOOKUP[RACK_MAC]    = 2
		VSWITCH_LOOKUP[RACK_LAP]    = 5
		VSWITCH_LOOKUP[FB_LAP]      = 7
		VSWITCH_LOOKUP[WB_LAP]      = 11
		VSWITCH_LOOKUP[POD_LAP]     = 0
		VSWITCH_LOOKUP[DOC_CAM]     = 10
		VSWITCH_LOOKUP[VCR]         = 4
		VSWITCH_LOOKUP[DVD]         = 3
		VSWITCH_LOOKUP[RACK_VID]    = 6
		VSWITCH_LOOKUP[FB_VID]      = 8 
		}
		CASE 'PAC 004':
		{
		VSWITCH_LOOKUP[RACK_PC]     = 1
		VSWITCH_LOOKUP[RACK_MAC]    = 2
		VSWITCH_LOOKUP[DVD]         = 3
		VSWITCH_LOOKUP[VCR]         = 4
		VSWITCH_LOOKUP[RACK_LAP]    = 5
		VSWITCH_LOOKUP[RACK_VID]    = 6
		VSWITCH_LOOKUP[VCR_CC]      = 7
		VSWITCH_LOOKUP[FB_LAP]     = 8
		VSWITCH_LOOKUP[FB_VID]      = 9
		VSWITCH_LOOKUP[DOC_CAM]     = 10
		VSWITCH_LOOKUP[WB_LAP]      = 11
		}
		CASE 'PAC 107':
		{
		VSWITCH_LOOKUP[RACK_PC]     = 1
		VSWITCH_LOOKUP[RACK_MAC]    = 2
		VSWITCH_LOOKUP[RACK_LAP]    = 5
		VSWITCH_LOOKUP[FB_LAP]      = 0
		VSWITCH_LOOKUP[WB_LAP]      = 7       // WALL BOX AUX 
		VSWITCH_LOOKUP[POD_LAP]     = 0
		VSWITCH_LOOKUP[DOC_CAM]     = 0
		VSWITCH_LOOKUP[VCR]         = 4
		VSWITCH_LOOKUP[DVD]         = 3
		VSWITCH_LOOKUP[RACK_VID]    = 6
		// VSWITCH_LOOKUP[FB_VID]      = 8       // WALL BOX AUX
		VSWITCH_LOOKUP[VCR_CC]      = 8     
		}
		CASE 'PAC 125':
		{
		VSWITCH_LOOKUP[RACK_PC]     = 1
		VSWITCH_LOOKUP[RACK_MAC]    = 2
		VSWITCH_LOOKUP[RACK_LAP]    = 5
		VSWITCH_LOOKUP[FB_LAP]      = 0
		VSWITCH_LOOKUP[WB_LAP]      = 7       // WALL BOX AUX 
		VSWITCH_LOOKUP[POD_LAP]     = 0
		VSWITCH_LOOKUP[DOC_CAM]     = 0
		VSWITCH_LOOKUP[VCR]         = 4
		VSWITCH_LOOKUP[DVD]         = 3
		VSWITCH_LOOKUP[RACK_VID]    = 6
		// VSWITCH_LOOKUP[FB_VID]      = 8       // WALL BOX AUX
		VSWITCH_LOOKUP[VCR_CC]      = 8     
		}
		CASE 'JUDD 116':
		{
		VSWITCH_LOOKUP[RACK_PC]     = 1
		VSWITCH_LOOKUP[RACK_MAC]    = 2
		VSWITCH_LOOKUP[RACK_LAP]    = 0
		VSWITCH_LOOKUP[FB_LAP]      = 0
		VSWITCH_LOOKUP[VCR_CC]      = 9 // !!NEW
		VSWITCH_LOOKUP[POD_LAP]     = 6
		VSWITCH_LOOKUP[DOC_CAM]     = 7
		VSWITCH_LOOKUP[VCR]         = 4
		VSWITCH_LOOKUP[DVD]         = 3
		VSWITCH_LOOKUP[RACK_VID]    = 5
		VSWITCH_LOOKUP[FB_VID]      = 8     
		}
		CASE 'DAC 100':
		{
		VSWITCH_LOOKUP[RACK_PC]     = 1
		VSWITCH_LOOKUP[RACK_MAC]    = 1
		VSWITCH_LOOKUP[RACK_LAP]    = 0
		VSWITCH_LOOKUP[FB_LAP]      = 0
		VSWITCH_LOOKUP[WB_LAP]      = 0
		VSWITCH_LOOKUP[POD_LAP]     = 4               // CHANGED DUE TO CONDUIT ISSUE
		VSWITCH_LOOKUP[DOC_CAM]     = 5               // HAD TO MAKE WORK WITH WHAT 
		VSWITCH_LOOKUP[VCR]         = 3               // THEY HAD
		VSWITCH_LOOKUP[DVD]         = 2               
		VSWITCH_LOOKUP[RACK_VID]    = 6               
		VSWITCH_LOOKUP[FB_VID]      = 7                    
		}
		CASE 'SC 509A':
		{
		VSWITCH_LOOKUP[RACK_PC]     = 1
		VSWITCH_LOOKUP[RACK_MAC]    = 2
		VSWITCH_LOOKUP[RACK_LAP]    = 6
		VSWITCH_LOOKUP[FB_LAP]      = 7       // REMOTE VGA
		VSWITCH_LOOKUP[WB_LAP]      = 0
		VSWITCH_LOOKUP[POD_LAP]     = 0
		VSWITCH_LOOKUP[DOC_CAM]     = 0
		VSWITCH_LOOKUP[VCR]         = 4
		VSWITCH_LOOKUP[DVD]         = 3
		VSWITCH_LOOKUP[RACK_VID]    = 5
		VSWITCH_LOOKUP[FB_VID]      = 8      // REMOTE VID
		}
		CASE 'JUDD 214':
		{
		VSWITCH_LOOKUP[RACK_PC]     = 1
		VSWITCH_LOOKUP[RACK_MAC]    = 2
		VSWITCH_LOOKUP[RACK_LAP]    = 6
		VSWITCH_LOOKUP[FB_LAP]      = 7       // REMOTE VGA
		VSWITCH_LOOKUP[WB_LAP]      = 0
		VSWITCH_LOOKUP[POD_LAP]     = 0
		VSWITCH_LOOKUP[DOC_CAM]     = 0
		VSWITCH_LOOKUP[VCR]         = 4
		VSWITCH_LOOKUP[DVD]         = 3
		VSWITCH_LOOKUP[RACK_VID]    = 5
		VSWITCH_LOOKUP[FB_VID]      = 8      // REMOTE VID
		}
		CASE 'PAC 422':
		{
		VSWITCH_LOOKUP[RACK_PC]     = 1
		VSWITCH_LOOKUP[RACK_MAC]    = 2
		VSWITCH_LOOKUP[RACK_LAP]    = 0
		VSWITCH_LOOKUP[FB_LAP]      = 6       // TABLE LAPTOP VGA
		VSWITCH_LOOKUP[WB_LAP]      = 0
		VSWITCH_LOOKUP[POD_LAP]     = 0
		VSWITCH_LOOKUP[DOC_CAM]     = 7       
		VSWITCH_LOOKUP[VCR]         = 4
		VSWITCH_LOOKUP[DVD]         = 3
		VSWITCH_LOOKUP[RACK_VID]    = 5
		VSWITCH_LOOKUP[FB_VID]      = 8      // TABLE VID
		}
		CASE 'JUDD 113':
		{
		VSWITCH_LOOKUP[RACK_PC]     = 1
		VSWITCH_LOOKUP[RACK_MAC]    = 2
		VSWITCH_LOOKUP[RACK_LAP]    = 0
		VSWITCH_LOOKUP[FB_LAP]      = 0
		VSWITCH_LOOKUP[WB_LAP]      = 0
		VSWITCH_LOOKUP[POD_LAP]     = 6
		VSWITCH_LOOKUP[DOC_CAM]     = 7       
		VSWITCH_LOOKUP[VCR]         = 4
		VSWITCH_LOOKUP[DVD]         = 3
		VSWITCH_LOOKUP[RACK_VID]    = 5
		VSWITCH_LOOKUP[FB_VID]      = 8      // PODIUM VID
		}
		CASE 'SC 109':
		CASE 'SCIE 137':
		CASE 'SCIE 139':
		CASE 'SCIE 141':
		{
		VSWITCH_LOOKUP[RACK_PC]     = 1
		VSWITCH_LOOKUP[RACK_MAC]    = 2
		VSWITCH_LOOKUP[RACK_LAP]    = 0
		VSWITCH_LOOKUP[FB_LAP]      = 0
		VSWITCH_LOOKUP[WB_LAP]      = 0
		VSWITCH_LOOKUP[POD_LAP]     = 6
		VSWITCH_LOOKUP[DOC_CAM]     = 7       
		VSWITCH_LOOKUP[VCR]         = 4
		VSWITCH_LOOKUP[DVD]         = 3
		VSWITCH_LOOKUP[RACK_VID]    = 5
		VSWITCH_LOOKUP[FB_VID]      = 8      // PODIUM VID
		}
		CASE 'OLIN 327B':
		{
		VSWITCH_LOOKUP[RACK_PC]     = 1
		VSWITCH_LOOKUP[RACK_MAC]    = 2
		VSWITCH_LOOKUP[RACK_LAP]    = 0
		VSWITCH_LOOKUP[FB_LAP]      = 6     // TABLE LAPTOP
		VSWITCH_LOOKUP[WB_LAP]      = 0
		VSWITCH_LOOKUP[POD_LAP]     = 0
		VSWITCH_LOOKUP[DOC_CAM]     = 7       
		VSWITCH_LOOKUP[VCR]         = 4
		VSWITCH_LOOKUP[DVD]         = 3
		VSWITCH_LOOKUP[RACK_VID]    = 5
		VSWITCH_LOOKUP[FB_VID]      = 8      // TABLE VID
		VSWITCH_LOOKUP[CASS]        = 9
		VSWITCH_LOOKUP[TURNTABLE]   = 10
		} 
		CASE 'RH 003':
		{
		VSWITCH_LOOKUP[RACK_PC]     = 1
		VSWITCH_LOOKUP[RACK_MAC]    = 2
		VSWITCH_LOOKUP[RACK_LAP]    = 0
		VSWITCH_LOOKUP[FB_LAP]      = 6     // REMOTE LAPTOP
		VSWITCH_LOOKUP[WB_LAP]      = 0
		VSWITCH_LOOKUP[POD_LAP]     = 0
		VSWITCH_LOOKUP[DOC_CAM]     = 7       
		VSWITCH_LOOKUP[VCR]         = 4
		VSWITCH_LOOKUP[DVD]         = 3
		VSWITCH_LOOKUP[RACK_VID]    = 5
		VSWITCH_LOOKUP[FB_VID]      = 8      // REMOTE VID
		VSWITCH_LOOKUP[CASS]        = 9      // TEAC PAD 500
		VSWITCH_LOOKUP[TURNTABLE]   = 0
		}  
		CASE 'DAC 300':
		{
		VSWITCH_LOOKUP[RACK_PC]     = 1
		VSWITCH_LOOKUP[RACK_MAC]    = 2
		VSWITCH_LOOKUP[RACK_LAP]    = 0
		VSWITCH_LOOKUP[FB_LAP]      = 6       // TABLE LAPTOP VGA
		VSWITCH_LOOKUP[WB_LAP]      = 0
		VSWITCH_LOOKUP[POD_LAP]     = 0
		VSWITCH_LOOKUP[DOC_CAM]     = 7       
		VSWITCH_LOOKUP[VCR]         = 4
		VSWITCH_LOOKUP[DVD]         = 3
		VSWITCH_LOOKUP[RACK_VID]    = 5
		VSWITCH_LOOKUP[FB_VID]      = 8      // TABLE VID
		}   
		CASE 'MS 301':
		{
		VSWITCH_LOOKUP[RACK_PC]     = 1
		VSWITCH_LOOKUP[RACK_MAC]    = 2
		VSWITCH_LOOKUP[RACK_LAP]    = 0
		VSWITCH_LOOKUP[FB_LAP]      = 6       // REMOTE VGA
		VSWITCH_LOOKUP[WB_LAP]      = 0
		VSWITCH_LOOKUP[POD_LAP]     = 0
		VSWITCH_LOOKUP[DOC_CAM]     = 7
		VSWITCH_LOOKUP[VCR]         = 4
		VSWITCH_LOOKUP[DVD]         = 3
		VSWITCH_LOOKUP[RACK_VID]    = 5
		VSWITCH_LOOKUP[FB_VID]      = 8      // REMOTE VID
		}
		CASE 'ANTHRO 6MM':
		CASE 'SCIE 309':
		CASE 'SCIE 405':
		{
		VSWITCH_LOOKUP[RACK_PC]     = 1
		VSWITCH_LOOKUP[RACK_MAC]    = 2
		VSWITCH_LOOKUP[DVD]         = 3
		VSWITCH_LOOKUP[VCR]         = 4
		VSWITCH_LOOKUP[VCR_CC]      = 5  // CC FROM VCR
		VSWITCH_LOOKUP[RACK_LAP]    = 6  // RACK VGA
		VSWITCH_LOOKUP[RACK_VID]    = 7
		VSWITCH_LOOKUP[FB_LAP]      = 8
		VSWITCH_LOOKUP[FB_VID]      = 9
		VSWITCH_LOOKUP[DOC_CAM]     = 10
		}
		CASE 'EAC MF+':
		{
		VSWITCH_LOOKUP[RACK_PC]     = 1
		VSWITCH_LOOKUP[RACK_MAC]    = 2
		VSWITCH_LOOKUP[DVD]         = 3
		VSWITCH_LOOKUP[VCR]         = 4
		VSWITCH_LOOKUP[VCR_CC]      = 5  // CC FROM VCR
		VSWITCH_LOOKUP[RACK_LAP]    = 6  // RACK VGA
		VSWITCH_LOOKUP[RACK_VID]    = 7
		VSWITCH_LOOKUP[FB_LAP]      = 8
		VSWITCH_LOOKUP[FB_VID]      = 9
		VSWITCH_LOOKUP[DOC_CAM]     = 10
		}
		CASE 'FISK 210':
		CASE 'FISK 305':
		CASE 'FISK 314':
		CASE 'FISK 404':
		CASE 'FISK 413':
		CASE 'FISK 414':
		CASE 'HALL ATWATER':
		CASE 'ZILKHA 106':
		{
		VSWITCH_LOOKUP[RACK_PC]     = 1
		VSWITCH_LOOKUP[RACK_MAC]    = 2
		VSWITCH_LOOKUP[DVD]         = 3
		VSWITCH_LOOKUP[VCR]         = 4
		VSWITCH_LOOKUP[VCR_CC]      = 5  // CC FROM VCR
		VSWITCH_LOOKUP[RACK_LAP]    = 6  // RACK VGA
		VSWITCH_LOOKUP[RACK_VID]    = 7
		VSWITCH_LOOKUP[FB_LAP]      = 8
		VSWITCH_LOOKUP[FB_VID]      = 9
		VSWITCH_LOOKUP[DOC_CAM]     = 10
		}
		CASE 'SC 121':
		{
		VSWITCH_LOOKUP[RACK_PC]     = 1
		VSWITCH_LOOKUP[RACK_MAC]    = 2
		VSWITCH_LOOKUP[DVD]         = 3
		VSWITCH_LOOKUP[VCR]         = 4
		VSWITCH_LOOKUP[VCR_CC]      = 5  // CC FROM VCR
		VSWITCH_LOOKUP[POD_LAP]    = 8  // RACK VGA
		VSWITCH_LOOKUP[RACK_LD]     = 7
		VSWITCH_LOOKUP[FB_LAP]      = 8
		VSWITCH_LOOKUP[FB_VID]      = 9
		//VSWITCH_LOOKUP[DOC_CAM]     = 10
		VSWITCH_LOOKUP[RACK_LD]     = 10
		}
		CASE 'SCIE 58':
		{
			VSWITCH_LOOKUP[RACK_PC]     = 1
      VSWITCH_LOOKUP[RACK_MAC]    = 2
			VSWITCH_LOOKUP[DVD]         = 3
			VSWITCH_LOOKUP[VCR]         = 4
			VSWITCH_LOOKUP[VCR_CC]      = 5  // CC FROM VCR
			VSWITCH_LOOKUP[RACK_LAP]    = 6  // RACK VGA
			VSWITCH_LOOKUP[RACK_VID]    = 7
			VSWITCH_LOOKUP[FB_LAP]      = 6   //FBLAP
			VSWITCH_LOOKUP[FB_VID]      = 0
			VSWITCH_LOOKUP[DOC_CAM]     = 8
		}
	} 
}
(***********************************************************)
(*                STARTUP CODE GOES BELOW                  *)
(***********************************************************)
DEFINE_START

COMBINE_DEVICES(vdvTP,dvTP1,dvWEB1,dvTP2,dvTP3,dvRADIO)

lAutoTimes2[1] = 23
lAutoTimes2[2] = 69

{
		STACK_VAR CHAR XMLstring[50000]
		LONG lPosition
		CHAR elist[20][50]
		
		XMLstring = getXMLfile('emaillist')
		lPosition = 1
		IF( LENGTH_STRING(XMLstring) )
		{
			slReturn = XML_TO_VARIABLE(elist, XMLstring, lPosition,0)
			EmailToWho = SetEmailList(elist) 
		}
		ELSE EmailToWho = SetEmailList(emaillist_default)
}


SmtpSetServer('panja.post.wesleyan.edu')       // SET SMTP SERVER ADDRESS EMAIL


CREATE_LEVEL dvVOLUME,1,VOL_LVL

CREATE_BUFFER vdvTP,TP_BUFFER
CREATE_BUFFER vdvProj,vdvProjBuffer  
CREATE_BUFFER vdvProj2,vdvProj2Buffer
CREATE_BUFFER vdvALERTER,vdvALERTERBuffer
(*xxxxxx CREATE_BUFFER dvROUTER,ROUTER_BUFFER xxxxxxxxx *)
// CREATE_BUFFER dvPROJ2,PROJ2_BUFFER
// CREATE_BUFFER dvPCSWITCH,PcSwitchBuff

Passwords[1] = "'1513'"
Passwords[2] = "'5625'"

DEBUG = 0



SEND_COMMAND vdvTP,"'@PPX'"
SEND_COMMAND vdvTP,"'PAGE-Logo Page'"

//send STOP to VCR/DVD
SYSTEM_CALL 'FUNCTION' (dvVCR,2,0)     
SYSTEM_CALL 'FUNCTION' (dvDVD,2,0)



//TURN OFF PROJECTORS
WAIT 80
	PULSE [vdvProj,PROJ_POW_OFF]
  //SEND_COMMAND vdvProj,'POF'
  
WAIT 80
	PULSE[vdvProj2,PROJ_POW_OFF]
  //SEND_COMMAND vdvProj2,'POF'



  
//SEND_STRING dvPROJ2,"PROJ2_CMD[POF]"
//OFF[dvPROJ2,POWER_STAT]

SEND_COMMAND vdvTP,"'TEXT2-PROJECTOR IS COOLING DOWN'"

CALL 'SETUP' (SystemName[SYSTEM_NUMBER])

POP_LOOKUP[1] = "POP_LOOKUP[1],ITOA(PCSOURCEPAGE)"
POP_LOOKUP[2] = "POP_LOOKUP[2],ITOA(VIDSOURCEPAGE)"

IF(SystemName[SYSTEM_NUMBER] == 'SCIE 58')
{
	POP_LOOKUP[17] = 'PAGE-Main Page with screens and lights'
	POP_LOOKUP[8] = 'PPON-Screen & Lights'
}
LAMP_MAX = 1500
LAMP_FIRST_WARNING = 1200
LAMP_MAX2 = 1500
LAMP_FIRST_WARNING2 = 1200    

// UPDATE AUDIT DISPLAY DATA EVERY MIN
lTimeArray[1] = 60000  
TIMELINE_CREATE(TL_DISP_REFRESH,lTimeArray,1,TIMELINE_RELATIVE,TIMELINE_REPEAT)

lTimeArray[1] = 10000
//TIMELINE_CREATE(TL_TEST,lTimeArray,1,TIMELINE_RELATIVE,TIMELINE_REPEAT)


lTimeArray[1]= 1500
TIMELINE_CREATE(TL_BLINK,lTimeArray,1,TIMELINE_RELATIVE,TIMELINE_REPEAT)

lTimeArray[1] = 60000
DVD_START=0
VCR_START=0

SEND_COMMAND vdvTP,"'TEXT13-',ITOA(AUDIT_VCR_SEC/3600),' Hrs|',ITOA((AUDIT_VCR_SEC%3600)/60),' Mins'" // VCR TIME
SEND_COMMAND vdvTP,"'TEXT14-',ITOA(AUDIT_DVD_SEC/3600),' Hrs|',ITOA((AUDIT_DVD_SEC%3600)/60),' Mins'" // DVD TIME
SEND_COMMAND vdvTP,"'TEXT15-|',ITOA(AUDIT_CAS_SEC/3600),' Hrs ',ITOA((AUDIT_CAS_SEC%3600)/60),' Mins'" // CAS TIME
SEND_COMMAND vdvTP,"'TEXT16-|',ITOA(AUDIT_TTB_SEC/3600),' Hrs ',ITOA((AUDIT_TTB_SEC%3600)/60),' Mins'" // TTB TIME

(***********************************************************)
(*                 THE MODULES GO BELOW                    *)
(***********************************************************)
//DEFINE_MODULE 'NEC MT 1055 SERIES' mdlProj(dvProj,vdvProj)
//DEFINE_MODULE 'NEC MT 1055 SERIES' mdlProj2(dvProj2,vdvProj2)
DEFINE_MODULE 'DataSwitch_mod' bb1(dvPCSWITCH,vdvPCSWITCH)
DEFINE_MODULE 'VideoSwitch_mod' ex1(dvROUTER,vdvROUTER)
//DEFINE_MODULE 'MTmoduleFINAL' ptest1(dvProj,vdvProj,ProjectorXML)
//DEFINE_MODULE 'MTSeriesFinalTEST' ptest1(dvProj,vdvProj)
//DEFINE_MODULE 'MTSeriesFinalTEST' ptest2(dvProj2,vdvProj2)
//DEFINE_MODULE 'MTmoduleFINAL' ptest2(dvProj2,vdvProj2,ProjectorXML)
DEFINE_MODULE 'NEC1065_f' ptest1(dvProj,vdvProj)
DEFINE_MODULE 'NEC1065_f' ptest1(dvProj2,vdvProj2)


(***********************************************************)
(*                 THE EVENTS GO BELOW                     *)
(***********************************************************)
DEFINE_EVENT

DATA_EVENT[vdvALERTER]
{

	ONLINE:
	{
		SEND_STRING 0,'ALERTER ONLINE!'
	}
	STRING:
	{
		
		send_string 0, "'msg received by alerter -',vdvALERTERBuffer"
		
		IF(FIND_STRING(vdvALERTERBuffer,'PCSOURCE=',1))
		{
			REMOVE_STRING(vdvALERTERBuffer,'PCSOURCE=',1)
			PCSOURCEPAGE = ATOI(vdvALERTERBuffer)
			send_string 0, "'PCSOURCE change -',ITOA(PCSOURCEPAGE)"
			POP_LOOKUP[1] = "'PPON-PC Sources ',ITOA(PCSOURCEPAGE)"
		}
		IF(FIND_STRING(vdvALERTERBuffer,'VIDSOURCE=',1))
		{
			REMOVE_STRING(vdvALERTERBuffer,'VIDSOURCE=',1)
			VIDSOURCEPAGE = ATOI(vdvALERTERBuffer)
			send_string 0, "'PPON-Video Sources ',ITOA(VIDSOURCEPAGE)"

			POP_LOOKUP[2] = "'PPON-Video Sources ',ITOA(VIDSOURCEPAGE)"
		}	
	}
}

DATA_EVENT[dvTP1]
{
  ONLINE:
  {
    WAIT 30
    {
      SEND_COMMAND dvTP1,"'TEXT11-',SystemName[SYSTEM_NUMBER]"
    }
  }
}

DATA_EVENT[dvWEB1]
{
  ONLINE:
  {
    WAIT 30
    {
      SEND_COMMAND dvWEB1,"'TEXT11-',SystemName[SYSTEM_NUMBER]"
    }
  }
}

DATA_EVENT[dvTP2]
{
  ONLINE:
  {
    WAIT 30
    {
      SEND_COMMAND dvTP2,"'TEXT11-',SystemName[SYSTEM_NUMBER]"
    }
  }
}

DATA_EVENT[dvTP3]
{
  ONLINE:
  {
    WAIT 30
    {
      SEND_COMMAND dvTP3,"'TEXT11-',SystemName[SYSTEM_NUMBER]"
    }
  }
}

(*xxxxxxxxxxxxxxxxx   handled in module
DATA_EVENT[dvROUTER]
{
  ONLINE:
  {
    WAIT 30
    {
      SEND_COMMAND dvROUTER,"'SET BAUD 9600,N,8,1'"
    }
  }
}
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx*)


DATA_EVENT[vdvProj]
{
  STRING:
  {
    IF (FIND_STRING(DATA.TEXT,"10",1))
    {
      ProcessProjectorString(vdvProj)
    }
  }
}
DATA_EVENT[vdvProj2]
{
  STRING:
  {
    IF (FIND_STRING(DATA.TEXT,"10",1))
    {
      ProcessProjectorString(vdvProj2)
    }
  }
}


(*xxxxxxxxxxxxxxxxx   handled in module
DATA_EVENT[dvPCSWITCH]
{
  ONLINE:
  {
    WAIT 30
    {
      SEND_COMMAND dvPCSWITCH,"'SET BAUD 9600,N,8,1'"
    }
  }
}
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx*)


DATA_EVENT[dvVCR]
{
  ONLINE:
  {
    WAIT 30
    {
      SEND_COMMAND dvVCR,"'SET MODE IR'"      
      SEND_COMMAND dvVCR,"'CARON'"
    }
  }
}

DATA_EVENT[dvDVD]
{
  ONLINE:
  {
    WAIT 30
    {
      SEND_COMMAND dvDVD,"'SET MODE IR'" 
      SEND_COMMAND dvDVD,"'CARON'"
    }
  }
}

DATA_EVENT[dvRELAY]
{
  ONLINE:
  {
    WAIT 30
    {
      SYSTEM_CALL[1] 'SCREEN2' (0,1,0,0,dvRELAY,2,1,0,0)   // SCREEN1 IS UP
      SYSTEM_CALL[2] 'SCREEN2' (0,1,0,0,dvRELAY,4,3,0,0)   // SCREEN1 IS UP
      SYSTEM_CALL[3] 'SCREEN2' (0,1,0,0,dvRELAY,6,5,0,0)   // SCREEN1 IS UP
    }
  }
}

Data_Event[LIGHTS]
{
  Online :
  {
    Send_Command Data.Device,"'SET BAUD 9600,N,8,1 485 DISABLE'"
    Send_Command Data.Device,"'HSOFF'"
  }
}

CHANNEL_EVENT[vdvALERTER,69]
{
	ON:
	{
		STACK_VAR CHAR XMLstring[50000]
		LONG lPosition
		CHAR elist[20][50]
		
		XMLstring = getXMLfile('emaillist')
		lPosition = 1
		IF( LENGTH_STRING(XMLstring) )
		{
			slReturn = XML_TO_VARIABLE(elist, XMLstring, lPosition,0)
			EmailToWho = SetEmailList(elist) 
		}
		ELSE EmailToWho = SetEmailList(emaillist_default)
	}
}

CHANNEL_EVENT[dvRELAY,12]
{
	ON:
	{
		STACK_VAR CHAR XMLstring[50000]
		LONG lPosition
		CHAR elist[20][50]
		
		XMLstring = getXMLfile('emaillist')
		lPosition = 1
		IF( LENGTH_STRING(XMLstring) )
		{
			slReturn = XML_TO_VARIABLE(elist, XMLstring, lPosition,0)
			EmailToWho = SetEmailList(elist) 
		}
		ELSE EmailToWho = SetEmailList(emaillist_default)
	}
}

CHANNEL_EVENT[darPROJECTORS,NECerror_fbchannels]
{
	ON:
	{
		//SystemEmailAddress = "'panja@wesleyan.edu'"
    //SmtpQueMessage(SystemEmailAddress,EmailToWho,"'IMPORTANT MESSAGE! ',SystemName[SYSTEM_NUMBER]",
		//							 "' Room: ',SystemName[SYSTEM_NUMBER],13,10,13,10,NECerror_ON[GET_LAST(NECerror_fbchannels)],13,10,13,10",'') 
									 //send_projector_mail(GET_LAST(NECerror_fbchannels),'ON')
		SmtpQueMessage('amx@wesleyan.edu',EmailToWho,
									 "'AMX Alert - ',SystemName[SYSTEM_NUMBER]",
									 "NECerror_ON[GET_LAST(NECerror_fbchannels)],13,10,
									 'Room: ',SystemName[SYSTEM_NUMBER],13,10,
									 'Time: ',TIME,13,10",'')
	
	}
	OFF:
	{
		//send_projector_mail(GET_LAST(NECerror_fbchannels),'OFF')
		//SystemEmailAddress = "'panja@wesleyan.edu'"
    //SmtpQueMessage(SystemEmailAddress,EmailToWho,"'IMPORTANT MESSAGE! ',SystemName[SYSTEM_NUMBER]",
		//							 "' Room: ',SystemName[SYSTEM_NUMBER],13,10,13,10,NECerror_OFF[GET_LAST(NECerror_fbchannels)],13,10,13,10",'') 
				SmtpQueMessage('amx@wesleyan.edu',
									 EmailToWho,
									 "'AMX Alert - ',SystemName[SYSTEM_NUMBER]",
									 "NECerror_OFF[GET_LAST(NECerror_fbchannels)],13,10,
									 'Room: ',SystemName[SYSTEM_NUMBER],13,10,
									 'Time: ',TIME,13,10",
									 '')
	}
	
	
(*	SmtpQueMessage('me@mydomain.com',        *)
(*                      'vmorrison@moondance.com' *)
(*                      'Wild Nights'             *)
(*                      'Are they calling?',      *)
(*                      '') *)
	
}


CHANNEL_EVENT[vdvROUTER,vswitch_input_fb]
{
  ON:
  {
		SOURCE = GET_LAST(vswitch_input_fb)
  }
}





BUTTON_EVENT[vdvTP,240]                   // LOGO PAGE HIDDEN TECH BUTTON
{
  PUSH:
  {
    SEND_COMMAND vdvTP,"'@SHO',103,0"
    SEND_COMMAND vdvTP,"'@SHO',104,0"
    SEND_COMMAND vdvTP,"'@SHO',105,0"
    SEND_COMMAND vdvTP,"'@SHO',106,0"
    SEND_COMMAND vdvTP,"'@SHO', 94,0"
    SEND_COMMAND vdvTP,"'@SHO', 95,0"
    SEND_COMMAND vdvTP,"'@SHO',171,0"
  }    
}

BUTTON_EVENT[vdvTP,96]                   // LOGO BUTTON
{
  PUSH: //GOTO MAIN PAGE
  {
    SEND_COMMAND vdvTP,"'@PPX'"
  }    
}

BUTTON_EVENT[vdvTP,91]                  // EXIT YES BUTTON
{
  PUSH:
  {
    //IF (![vdvProj,PROJ_POW_OFF])
		IF ([vdvProj,PROJ_POWER]) //CHANGE THE CODE!!!
    {
		
				(*
			OFF[vdvProj,50]	
			OFF[vdvProj2,50]	
			
			WAIT 50
			{
				OFF[vdvProj,50]	
				OFF[vdvProj2,50]
			}
		
		  SEND_COMMAND vdvProj,'POF'
			SEND_COMMAND vdvProj2,'POF'
*)


			PULSE[vdvProj,PROJ_POW_OFF]		//CHANGE THE CODE!!!
			PULSE[vdvProj2,PROJ_POW_OFF] 	//CHANGE THE CODE!!!
			
			
				
      WAIT_UNTIL([vdvProj,PROJ_COOLING])
      {
				SEND_COMMAND vdvTP,"'TEXT2-PROJECTOR IS COOLING DOWN'"
        SEND_COMMAND vdvTP,"'PPON-PROJ WAIT'"
        //WAIT_UNTIL ([vdvProj,PROJ_POW_OFF]) 'PROJ COOL'
				WAIT_UNTIL (![vdvProj,PROJ_COOLING]) 'PROJ COOL'//CHANGE THE CODE!!!
        {
          SEND_COMMAND vdvTP,"'PPOF-PROJ WAIT'"
        }
      }
    }
    CANCEL_WAIT_UNTIL 'PROJ WARM'

    SYSTEM_CALL[1] 'SCREEN2' (0,1,0,0,dvRELAY,2,1,0,0)      // SCREEN1 IS DOWN
    IF(SystemName[SYSTEM_NUMBER] = 'PAC 002')
    {
       SYSTEM_CALL[3] 'SCREEN2' (0,1,0,0,dvRELAY,6,5,0,0)   // SCREEN2 IS DOWN
    }

		//stop dvd/vcr
    SYSTEM_CALL[1] 'FUNCTION' (dvVCR,2,0)
    SYSTEM_CALL[2] 'FUNCTION' (dvDVD,2,0)
		
    SEND_COMMAND vdvTP,"'@PPX'"
    POP_FDBK = 0

		stop_counter(TL_VCR_TIMEOUT,1)
		stop_counter(TL_DVD_TIMEOUT,1)
  }     
}

(******************************)
(**** SELECT SOURCES **********)
(******************************)

BUTTON_EVENT[dcSource] (* GET_LAST = 1 - 15 *)
{
  PUSH:
  {
    SOURCE = VSWITCH_LOOKUP[GET_LAST(dcSource)] 
    //PULSE[vdvROUTER,SOURCE]
		//display corresponding central ppage on TP for source
		SEND_COMMAND vdvTP,"SUBNAV_PPAGE[GET_LAST(dcSource)]" 
		
		
		// IF WE JUST SWITCHED SOURCES - THEN TIMEOUT ALL COUNTERS
    IF(SOURCE_BUTTON <> BUTTON.INPUT.CHANNEL)  
    {
      stop_counter(TL_VCR_TIMEOUT,1)
      stop_counter(TL_DVD_TIMEOUT,1)
      stop_counter(TL_CAS_TIMEOUT,1)
      stop_counter(TL_TTB_TIMEOUT,1)
    }
		
		//discretely power on vcr if it was selected
    IF( GET_LAST(dcSource) == 8 OR GET_LAST(dcSource) == 14 )
    {
      PULSE[dvVCR,27]       // POWER ON
    }
		
		IF( GET_LAST(dcSource) == CASS )
		{
      start_counter(TL_CAS_TIMEOUT)
		}
		
		IF( GET_LAST(dcSource) == TURNTABLE )
		{
			start_counter(TL_TTB_TIMEOUT)
		}
		
    SOURCE_BUTTON = BUTTON.INPUT.CHANNEL
		
		//display corresponding text over center ppage on TP for source
		SEND_COMMAND vdvTP,"'TEXT1-',SUBNAV_TXT[GET_LAST(dcSource)]"
 
	
		//change kvm switch if source is pc or mac
		IF( BUTTON.INPUT.CHANNEL == 3 OR BUTTON.INPUT.CHANNEL == 4 ) // FOR KEYBRD MOUSE SWITCH 
		//IF( GET_LAST(dcSource) == RACK_PC OR GET_LAST(dcSource) == RACK_MAC)
		{
			PULSE [vdvPCSWITCH,GET_LAST(dcSource)]
			DACPC = BUTTON.INPUT.CHANNEL // FOR ROUTER FEEDBACK IN DAC 100- don't think this is necessary anymore
    }
    IF ((![vdvProj,PROJ_POWER] && (BUTTON.INPUT.CHANNEL <> 14) && (BUTTON.INPUT.CHANNEL <> 15))) // IF PROJ IS OFF AND SOURCE IS NOT CASSETTE OR TURNTABLE
    {
      SEND_COMMAND vdvProj,'PON'
			PULSE[vdvProj,PROJ_POW_ON]		//CHANGE THE CODE!!!
      
      SEND_COMMAND vdvTP,"'PPON-PROJ WAIT'"
      SEND_COMMAND vdvTP,"'TEXT2-PROJECTOR IS WARMING UP'"
      
      SYSTEM_CALL[1] 'SCREEN2' (0,0,1,0,dvRELAY,2,1,0,0)       // SCREEN1 IS DOWN
      
      CANCEL_WAIT_UNTIL 'PROJ COOL' //???????
      
      WAIT_UNTIL ([vdvProj,PROJ_POWER]=1) 'PROJ WARM'   // WAIT UNTIL PROJECTOR IS ON - BUT NOT LONGER THAN 48 SECS <-WHERE IS THIS SET??
      {
        SEND_COMMAND vdvTP,"'PPOF-PROJ WAIT'"
				PULSE[vdvROUTER,SOURCE]
				IF(![vdvproj,SUBNAV_INPUT_SIGNAL[GET_LAST(dcSource)]+100])
					PULSE[vdvProj,SUBNAV_INPUT_SIGNAL[GET_LAST(dcSource)]]
				//PULSE[vdvProj,SUBNAV_INPUT_SIGNAL[GET_LAST(dcSource)]]
      }
    }
    ELSE
    {
			PULSE[vdvROUTER,SOURCE]
      //PULSE[vdvProj,SUBNAV_INPUT_SIGNAL[GET_LAST(dcSource)]]
			IF(![vdvproj,SUBNAV_INPUT_SIGNAL[GET_LAST(dcSource)]+100])
				PULSE[vdvProj,SUBNAV_INPUT_SIGNAL[GET_LAST(dcSource)]]
		}
    
    IF ((![vdvProj2,PROJ_POWER] && (BUTTON.INPUT.CHANNEL <> 14) && (SystemName[SYSTEM_NUMBER] = 'PAC 002') && (BUTTON.INPUT.CHANNEL <> 15))) // IF PROJ2 IS OFF AND SOURCE IS NOT CASSETTE OR TURNTABLE
    {
      SEND_COMMAND vdvProj2,'PON'
			PULSE[vdvProj2,PROJ_POW_ON]	//CHANGE THE CODE!!!
      SYSTEM_CALL[3] 'SCREEN2' (0,0,1,0,dvRELAY,6,5,0,0)     // SCREEN2 IS DOWN
      WAIT_UNTIL ([vdvProj2,PROJ_POWER]=1) 'PROJ2 WAIT'
      {
			IF(![vdvproj2,SUBNAV_INPUT_SIGNAL[GET_LAST(dcSource)]+100])
				PULSE[vdvProj2,SUBNAV_INPUT_SIGNAL[GET_LAST(dcSource)]]
      }
    }
    ELSE
    {
			//CHANGE THE CODE!!!!
      //OFF[vdvProj2,PROJ_MUTE]	//what the pho?
      //WAIT 20
      {
			IF(![vdvproj2,SUBNAV_INPUT_SIGNAL[GET_LAST(dcSource)]+100])
				PULSE[vdvProj2,SUBNAV_INPUT_SIGNAL[GET_LAST(dcSource)]]
      }
    }
  }
}

BUTTON_EVENT[dcPopUp]                           // THESE BUTTONS ARE FOR SYNCHRONIZATION OF THE POPUPS ON THE WEB PAGES
{
	PUSH:
	{
		ENVIRONMENT = BUTTON.INPUT.CHANNEL
		//SEND_COMMAND vdvTP,"POP_LOOKUP[BUTTON.INPUT.CHANNEL - 66]"
		SEND_COMMAND vdvTP,"POP_LOOKUP[BUTTON.INPUT.CHANNEL-79]"
	
		IF((BUTTON.INPUT.CHANNEL >= 80) && (BUTTON.INPUT.CHANNEL <= 83))
		{
			POP_FDBK = GET_LAST(dcPopUp)
			SEND_COMMAND vdvTP,"'PPON-BLANK'"
		}
	}     
}

(* PROJECTOR CONTROLS *)
// PROJ1
BUTTON_EVENT[vdvTP,27]                          // PROJ1 POWER ON
{
  PUSH:
  {
    SEND_COMMAND vdvProj,'PON'
    SEND_COMMAND vdvTP,"'PPON-PROJ WAIT'"
    IF(SystemName[SYSTEM_NUMBER] = 'PAC002')
    {
        SEND_COMMAND vdvTP,"'TEXT2-PROJECTOR1 IS WARMING UP'"
    }
    ELSE
    {
        SEND_COMMAND vdvTP,"'TEXT2-PROJECTOR IS WARMING UP'"
    }
    
    CANCEL_WAIT_UNTIL 'PROJ COOL'
    
    WAIT_UNTIL ([vdvProj,PROJ_POW_ON]=1) 'PROJ WARM'
    {
      SEND_COMMAND vdvTP,"'PPOF-PROJ WAIT'"
    }
  }
}

BUTTON_EVENT[vdvTP,28]                          // PROJ1 POWER OFF
{
  PUSH:
  {
    //SEND_STRING dvROUTER,"PROJ1_CMD[POF]"
    SEND_COMMAND vdvProj,'POF'
    SEND_COMMAND vdvTP,"'PPON-PROJ WAIT'"
    IF(SystemName[SYSTEM_NUMBER] = 'PAC002')
    {
      SEND_COMMAND vdvTP,"'TEXT2-PROJECTOR1 IS COOLING DOWN'"
    }
    ELSE
    {
      SEND_COMMAND vdvTP,"'TEXT2-PROJECTOR IS COOLING DOWN'"
    }
    
    CANCEL_WAIT_UNTIL 'PROJ WARM'
    
    //WAIT_UNTIL ([vdvProj,PROJ_POW_OFF]) 'PROJ COOL'
		WAIT_UNTIL (![vdvProj,PROJ_POW_ON]) 'PROJ COOL'//CHANGE THE CODE!!!
    {
      SEND_COMMAND vdvTP,"'PPOF-PROJ WAIT'"
    }
  }
}

BUTTON_EVENT[vdvTP,120]                         // PROJ1 TOGGLE MUTE
{
  PUSH:
  {
	//    [vdvProj,PROJ_MUTE] = ![vdvProj,PROJ_MUTE]
		IF([vdvProj,PROJ_MUTE])  					//CHANGE THE CODE!!!
			PULSE[vdvProj,PROJ_MUTE_OFF] 	//CHANGE THE CODE!!!
		ELSE
		{//CHANGE THE CODE!!!
			ON[BLINK]
			PULSE[vdvProj,PROJ_MUTE_ON]		//CHANGE THE CODE!!!
		}
		
				IF([vdvProj2,PROJ_MUTE])  					//CHANGE THE CODE!!!
			PULSE[vdvProj2,PROJ_MUTE_OFF] 	//CHANGE THE CODE!!!
		ELSE
		{//CHANGE THE CODE!!!
			ON[BLINK]
			PULSE[vdvProj2,PROJ_MUTE_ON]		//CHANGE THE CODE!!!
		}
  }
}

BUTTON_EVENT[vdvTP,29]                          // PROJ1 MUTE ON
{
    PUSH:
    {
        //SEND_STRING dvROUTER,"PROJ1_CMD[MON]"
        ON[vdvProj,PROJ_MUTE]
    }    
}

BUTTON_EVENT[vdvTP,30]                          // PROJ1 MUTE OFF
{
    PUSH:
    {
        //SEND_STRING dvROUTER,"PROJ1_CMD[MOF]"
        OFF[vdvProj,PROJ_MUTE]
    }    
}

// PROJ2
BUTTON_EVENT[vdvTP,31]                          // PROJ2 POWER ON
{
  PUSH:
  {
    // SEND_STRING dvROUTER,"PROJ1_CMD[PON]"
    SEND_COMMAND vdvProj2,'PON'
    SEND_COMMAND vdvTP,"'PPON-PROJ WAIT'"
    SEND_COMMAND vdvTP,"'TEXT2-PROJECTOR2 IS WARMING UP'"
    
    CANCEL_WAIT_UNTIL 'PROJ COOL'
    
    WAIT_UNTIL ([vdvProj2,PROJ_POW_ON]=1) 'PROJ WARM'
    {
      SEND_COMMAND vdvTP,"'PPOF-PROJ WAIT'"
    }
  }
}

BUTTON_EVENT[vdvTP,32]                          // PROJ2 POWER OFF
{
  PUSH:
  {
    //SEND_STRING dvROUTER,"PROJ1_CMD[POF]"
    SEND_COMMAND vdvProj2,'POF'
    SEND_COMMAND vdvTP,"'PPON-PROJ WAIT'"
    SEND_COMMAND vdvTP,"'TEXT2-PROJECTOR2 IS COOLING DOWN'"
    
    CANCEL_WAIT_UNTIL 'PROJ WARM'
    
    //WAIT_UNTIL ([vdvProj2,PROJ_POW_OFF]) 'PROJ COOL'
		WAIT_UNTIL (![vdvProj2,PROJ_POW_ON]) 'PROJ COOL'//CHANGE THE CODE!!!
    {
      SEND_COMMAND vdvTP,"'PPOF-PROJ WAIT'"
    }
  }
}

BUTTON_EVENT[vdvTP,33]                          // PROJ2 MUTE ON
{
    PUSH:
    {
        //SEND_STRING dvROUTER,"PROJ1_CMD[MON]"
        ON[vdvProj2,PROJ_MUTE]
    }    
}

BUTTON_EVENT[vdvTP,34]                          // PROJ2 MUTE OFF
{
    PUSH:
    {
        //SEND_STRING dvROUTER,"PROJ1_CMD[MOF]"
        OFF[vdvProj2,PROJ_MUTE]
    }    
}
(*BUTTON_EVENT[vdvTP,31]                          // PROJ2 POWER ON
{
    PUSH:
    {
        SEND_STRING dvPROJ2,"PROJ2_CMD[PON]"
        SEND_COMMAND vdvTP,"'TEXT2-PROJECTOR2 IS WARMING UP'"
        ON[dvPROJ2,POWER_STAT]
    }    
}


BUTTON_EVENT[vdvTP,32]                          // PROJ2 POWER OFF
{
    PUSH:
    {
        SEND_STRING dvPROJ2,"PROJ2_CMD[POF]"
        SEND_COMMAND vdvTP,"'TEXT2-PROJECTOR2 IS COOLING DOWN'"
        OFF[dvPROJ2,POWER_STAT]
    }    
}

BUTTON_EVENT[vdvTP,33]                          // PROJ2 MUTE ON
{
    PUSH:
    {
        SEND_STRING dvPROJ2,"PROJ2_CMD[MON]"
        ON[dvPROJ2,MUTE_STAT]
    }    
}

BUTTON_EVENT[vdvTP,34]                          // PROJ2 MUTE OFF
{
    PUSH:
    {
        SEND_STRING dvPROJ2,"PROJ2_CMD[MOF]"
        OFF[dvPROJ2,MUTE_STAT]
    }    
}*)

(*
BUTTON_EVENT[dcDvdSkip]                         // DVD FORWARD & REVERSE SKIP CHANNELS 4 & 5
{
    PUSH:
    {
        SELECT
        {
            ACTIVE([dvDVD,241] || [dvDVD,242] || [dvDVD,244] || [dvDVD,245]):
            {
                CANCEL_WAIT 'DVD'
                SET_PULSE_TIME(2)
                PULSE[dvDVD,GET_LAST(dcDvdSkip) + 3]
                SET_PULSE_TIME(5)
            }  
            ACTIVE([dvDVD,243]):
            {
                CANCEL_WAIT 'DVD'
                SET_PULSE_TIME(2)
                PULSE[dvDVD,GET_LAST(dcDvdSkip) + 3]
                SET_PULSE_TIME(5)
                WAIT 5 'DVD'
                {
                    SYSTEM_CALL 'FUNCTION' (dvDVD,1,0)
                    WAIT 5 'DVD'
                    {
                        SYSTEM_CALL 'FUNCTION' (dvDVD,3,0)
                    }
                }    
            }
            ACTIVE([dvDVD,246] || [dvDVD,247]):
            {
                CANCEL_WAIT 'DVD'
                SYSTEM_CALL 'FUNCTION' (dvDVD,2,0)
                WAIT 5 'DVD'
                {
                    SET_PULSE_TIME(2)
                    PULSE[dvDVD,GET_LAST(dcDvdSkip) + 3]
                    SET_PULSE_TIME(5)
                }    
            }
        }
    }    
}
*)

BUTTON_EVENT[vdvTP,79]                          // RESET LAMP HOURS PROJ 1
{
    PUSH:
    {
        LAMP_SECONDS = 0   
        LAMP_MINUTES = 0
        LAMP_HOURS = 0
        OFF[SENT_WARNING]
        OFF[SENT_FINAL_WARNING]
        SEND_COMMAND vdvTP,"'PPON-Lamp Hours Reset'"
        SEND_COMMAND vdvTP,"'TEXT10-',ITOA(LAMP_HOURS),' Hrs|',ITOA(LAMP_MINUTES),' Mins'"
        PULSE[vdvProj,PROJ_LAMP_RESET]
    }    
}

BUTTON_EVENT[vdvTP,100]                          // RESET LAMP HOURS PROJ 2
{
    PUSH:
    {
        LAMP_SECONDS2 = 0   
        LAMP_MINUTES2 = 0
        LAMP_HOURS2 = 0
        OFF[SENT_WARNING2]
        OFF[SENT_FINAL_WARNING2]
        SEND_COMMAND vdvTP,"'PPON-Lamp Hours Reset 2'"
        SEND_COMMAND vdvTP,"'TEXT12-',ITOA(LAMP_HOURS2),' Hrs|',ITOA(LAMP_MINUTES2),' Mins'"
        PULSE[vdvProj2,PROJ_LAMP_RESET]
    }    
}




BUTTON_EVENT[vdvTP,103]  // RESET VCR
{
  PUSH:
  {
    AUDIT_VCR_SEC = 0
    SEND_COMMAND vdvTP,"'TEXT13-0 Hrs|0 Mins'" // VCR TIME
  }
}
BUTTON_EVENT[vdvTP,104]  // RESET DVD
{
  PUSH:
  {
    AUDIT_DVD_SEC = 0
    SEND_COMMAND vdvTP,"'TEXT14-0 Hrs|0 Mins'" // DVD TIME
  }
}
BUTTON_EVENT[vdvTP,105]  // RESET CAS
{
  PUSH:
  {
    AUDIT_CAS_SEC = 0
    SEND_COMMAND vdvTP,"'TEXT15-|0 Hrs 0 Mins'" // CAS TIME
  }
}
BUTTON_EVENT[vdvTP,106]  // RESET TURNTABLE
{
  PUSH:
  {
    AUDIT_TTB_SEC = 0
    SEND_COMMAND vdvTP,"'TEXT16-|0 Hrs 0 Mins'" // TTB TIME
  }
}
BUTTON_EVENT[vdvTP,107]  // SEND AUDIT REPORT
{
  PUSH:
  {
    min_to[mailsent]
    SystemEmailAddress = "'panja@wesleyan.edu'"
 // SmtpQueMessage('from', 'to', 'subject', 'message','attach file')
    SmtpQueMessage(SystemEmailAddress,EmailToWho,"'Audit report for',SystemName[SYSTEM_NUMBER]",
       "13,10,'System device usage report.',13,10,'Room: ',SystemName[SYSTEM_NUMBER],13,10,13,10,
       'Projector1 Lamp Hours: ',ITOA(LAMP_HOURS),'  Minutes: ',ITOA(LAMP_MINUTES),13,10,
       'Projector2 Lamp Hours: ',ITOA(LAMP_HOURS2),'  Minutes: ',ITOA(LAMP_MINUTES2),13,10,
       13,10,
       '  VCR Transport Hours: ',ITOA(AUDIT_VCR_SEC/3600),' Minutes: ',ITOA((AUDIT_VCR_SEC%3600)/60),13,10,
       '  DVD Transport Hours: ',ITOA(AUDIT_DVD_SEC/3600),' Minutes: ',ITOA((AUDIT_DVD_SEC%3600)/60),13,10,
       '   Cassette Use Hours: ',ITOA(AUDIT_CAS_SEC/3600),' Minutes: ',ITOA((AUDIT_CAS_SEC%3600)/60),13,10,
       '  Turntable Use Hours: ',ITOA(AUDIT_TTB_SEC/3600),' Minutes: ',ITOA((AUDIT_TTB_SEC%3600)/60),13,10",'')
  }
}

BUTTON_EVENT[dcINPUTS]
{
  PUSH:
  {
    SOURCE = GET_LAST(dcINPUTS)
    (*xxxxxxxxxxxxxx SEND_STRING dvROUTER,"ITOA(SOURCE),'!'" xxxxxxxxxxxxxx*)
		PULSE[vdvROUTER,SOURCE]

  }
}

BUTTON_EVENT[vdvTP,121]
{
  PUSH:
  {
    SEND_COMMAND vdvTP,"'PPOF-VCR TRANSPORT'"
    SEND_COMMAND vdvTP,"'PPOF-DVD TRANSPORT'"
    SEND_COMMAND vdvTP,"'PPOF-POPVOL'"
  }
}

BUTTON_EVENT [vdvTP,nAutoTimeAdjust]
{
  PUSH:
  {
		IF(TIMELINE_ACTIVE(TL_AUTO_OFF))
			TIMELINE_SET(TL_AUTO_OFF,0)
    switch(get_last(nAutoTimeAdjust))
    {
      case 1:     // up
      {
        lAutoTime = (lAutoTime + 1800) % GOING_ON_MIDNIGHT
      }
      case 2:     // down
      {
        lAutoTime = (lAutoTime + GOING_ON_MIDNIGHT - 1800) % GOING_ON_MIDNIGHT
      }
      case 3:
      {
        lAutoTimes[1] = 900000                // 15 min
				lAutoTimes2[1] = 900000
				IF(TIMELINE_ACTIVE(TL_AUTO_OFF))
					TIMELINE_RELOAD(TL_AUTO_OFF,lAutoTimes,2)
      }
      case 4:
      {
        lAutoTimes[1] = 1800000               // 30 min
				lAutoTimes2[1] = 1800000
				IF(TIMELINE_ACTIVE(TL_AUTO_OFF))
					TIMELINE_RELOAD(TL_AUTO_OFF,lAutoTimes,2)
      }
      case 5:
      {
        lAutoTimes[1] = 3600000               // 60 min
				lAutoTimes2[1] = 3600000
				IF(TIMELINE_ACTIVE(TL_AUTO_OFF))
					TIMELINE_RELOAD(TL_AUTO_OFF,lAutoTimes,2)
      }
      case 6:
      {
        lAutoTimes[2] = 300000   				// 5 min
				lAutoTimes2[2] = 300000
				IF(TIMELINE_ACTIVE(TL_AUTO_OFF))
					TIMELINE_RELOAD(TL_AUTO_OFF,lAutoTimes,2)
      }
      case 7:
      {
        lAutoTimes[2] = 600000                // 10 min
				lAutoTimes2[2] = 600000
				IF(TIMELINE_ACTIVE(TL_AUTO_OFF))
					TIMELINE_RELOAD(TL_AUTO_OFF,lAutoTimes,2)
      }
      case 8:
      {
        lAutoTimes[2] = 900000                // 15 min
				lAutoTimes2[2] = 900000
				IF(TIMELINE_ACTIVE(TL_AUTO_OFF))
				  TIMELINE_RELOAD(TL_AUTO_OFF,lAutoTimes,2)
      }
    }
    select
    {
      active(lAutoTime < 3600):       // 12:?? a.m.
      {
        send_command vdvTP,"'!T',nAutoTimeAdjust[1],format('12:%02d a.m.',(lAutoTime/60)%60)"
      }
      active(lAutoTime < 43200):  // up to 11:59 a.m.
      {
        send_command vdvTP,"'!T',nAutoTimeAdjust[1],format('%2d',lAutoTime/3600),format(':%02d a.m.',(lAutoTime/60)%60)"
      }
      active(lAutoTime < 46800):  // up to 12:59 p.m.
      {
        send_command vdvTP,"'!T',nAutoTimeAdjust[1],format('12:%02d p.m.',(lAutoTime/60)%60)"
      }
      active(1):  // up to 11:59 p.m.
      {
        send_command vdvTP,"'!T',nAutoTimeAdjust[1],format('%2d',(lAutoTime/3600)%12),format(':%02d p.m.',(lAutoTime/60)%60)"
      }
    }
  }
}



BUTTON_EVENT[vdvTP,VCR_TRANSPORT_BUTTONS]
{
	PUSH:
	{
		SYSTEM_CALL[1] 'VCR1' (dvVCR,vdvTP,VCR_PLAY,VCR_STOP,VCR_PAUSE,VCR_FFWD,VCR_REW,VCR_SFWD,VCR_SREV,VCR_REC,0)
		IF(button.input.channel != VCR_STOP)
			start_counter(TL_VCR_TIMEOUT)
		ELSE
			stop_counter(TL_VCR_TIMEOUT,1)
	}
}


(*xxxxxxx  some vcr model incapatabilities with searchf/b and ffw/rew
BUTTON_EVENT[vdvTP,VCR_FFWD]  //43
{
  PUSH:
  {
    IF([dvVCR,241] OR [dvVCR,247])
    {
      SYSTEM_CALL 'FUNCTION' (dvVCR,6,0)
    }
    ELSE
    {
      SYSTEM_CALL 'FUNCTION' (dvVCR,4,0)
    }
  }  
}

BUTTON_EVENT[vdvTP,VCR_REW]  //44
{
  PUSH:
  {
    IF([dvVCR,241] OR [dvVCR,246])
    {
      SYSTEM_CALL 'FUNCTION' (dvVCR,7,0)
    }
    ELSE
    {
      SYSTEM_CALL 'FUNCTION' (dvVCR,5,0)
    }
  }  
}
*)


BUTTON_EVENT[vdvTP,DVD_TRANSPORT_BUTTONS]
{
	PUSH:
	{
		SYSTEM_CALL[1] 'DVD1' (dvDVD,vdvTP,DVD_PLAY,DVD_STOP,DVD_PAUSE,DVD_FSKIP,DVD_RSKIP,DVD_FSCAN,DVD_RSCAN ,0)
		IF(button.input.channel != DVD_STOP)
			start_counter(TL_DVD_TIMEOUT)
		ELSE
			stop_counter(TL_DVD_TIMEOUT,1)
	}
}

(*
BUTTON_EVENT[dcDvdSkip] //53, 54                // DVD FORWARD & REVERSE SKIP CHANNELS 4 & 5
{
    PUSH:
    {
        SET_PULSE_TIME(2)
        PULSE[dvDVD,(GET_LAST(dcDvdSkip) + 3)]
        PULSE[dvDVD,(GET_LAST(dcDvdSkip) + 243)]
        SET_PULSE_TIME(5)
    }    
}
*)

BUTTON_EVENT[vdvTP,DVD_MENU] //70
{
    PUSH:
    {
        SET_PULSE_TIME(2)
        PULSE[dvDVD,44]
        SET_PULSE_TIME(5)
    }//END PUSH-=}//END BUTTON EVENT
}
BUTTON_EVENT[vdvTP,DVD_up] //72
{
    PUSH:
    {
        SET_PULSE_TIME(2)
        PULSE[dvDVD,45]
        SET_PULSE_TIME(5)
    }//END PUSH
}//END BUTTON EVENT

BUTTON_EVENT[vdvTP,DVD_down] //73
{
    PUSH:
    {
        SET_PULSE_TIME(2)
        PULSE[dvDVD,46]
        SET_PULSE_TIME(5)
    }//END PUSH
}//END BUTTON EVENT

BUTTON_EVENT[vdvTP,DVD_left] //74
{
    PUSH:
    {
        SET_PULSE_TIME(2)
        PULSE[dvDVD,47]
        SET_PULSE_TIME(5)
    }//END PUSH
}//END BUTTON EVENT

BUTTON_EVENT[vdvTP,DVD_right] //75
{
    PUSH:
    {
        SET_PULSE_TIME(2)
        PULSE[dvDVD,48]
        SET_PULSE_TIME(5)
    }//END PUSH
}//END BUTTON EVENT

BUTTON_EVENT[vdvTP,DVD_ENTER] //71
{
    PUSH:
    {
        SET_PULSE_TIME(2)
        PULSE[dvDVD,49]
        SET_PULSE_TIME(5)
    }//END PUSH
}//END BUTTON EVENT


(*LIGHTS CONTROL FOR SC58*)
BUTTON_EVENT[vdvTP,151]
{
    PUSH:
    {
        SEND_STRING LIGHTS,"':A11',$0D"
    }
}

BUTTON_EVENT[vdvTP,152]
{
    PUSH:
    {
        SEND_STRING LIGHTS,"':A21',$0D"
    }
}

BUTTON_EVENT[vdvTP,153]
{
    PUSH:
    {
        SEND_STRING LIGHTS,"':A31',$0D"
    }
}

BUTTON_EVENT[vdvTP,154]
{
    PUSH:
    {
        SEND_STRING LIGHTS,"':A41',$0D"
    }
}

BUTTON_EVENT[vdvTP,155]
{
    PUSH:
    {
        SEND_STRING LIGHTS,"':A01',$0D"
    }
}
(* END LIGHT CODE FOR SC 58*)

TIMELINE_EVENT[TL_VCR_TIMEOUT]  // IT'S BEEN 2 HOURS - THE TAPE/CLASS SHOULD HAVE BEEN DONE ALREADY
{
  stop_counter(TL_VCR_TIMEOUT,0)
}

TIMELINE_EVENT[TL_DVD_TIMEOUT]  // IT'S BEEN 2 HOURS - THE DVD/CLASS SHOULD HAVE BEEN DONE ALREADY
{
  stop_counter(TL_VCR_TIMEOUT,0)
}

TIMELINE_EVENT[TL_CAS_TIMEOUT]
{
  stop_counter(TL_VCR_TIMEOUT,0)
}

TIMELINE_EVENT[TL_TTB_TIMEOUT]
{
  stop_counter(TL_VCR_TIMEOUT,0)
}

TIMELINE_EVENT[TL_DISP_REFRESH]
{
  SEND_COMMAND vdvTP,"'TEXT13-', ITOA(AUDIT_VCR_SEC/3600),' Hrs|',ITOA((AUDIT_VCR_SEC%3600)/60),' Mins'" // VCR TIME
  SEND_COMMAND vdvTP,"'TEXT14-', ITOA(AUDIT_DVD_SEC/3600),' Hrs|',ITOA((AUDIT_DVD_SEC%3600)/60),' Mins'" // DVD TIME
  SEND_COMMAND vdvTP,"'TEXT15-|',ITOA(AUDIT_CAS_SEC/3600),' Hrs ',ITOA((AUDIT_CAS_SEC%3600)/60),' Mins'" // CAS TIME
  SEND_COMMAND vdvTP,"'TEXT16-|',ITOA(AUDIT_TTB_SEC/3600),' Hrs ',ITOA((AUDIT_TTB_SEC%3600)/60),' Mins'" // TTB TIME
}

TIMELINE_EVENT[TL_AUTO_OFF]
{
  SWITCH(TIMELINE.SEQUENCE)
  {
    CASE 1: // WARN
    {
      send_command vdvTP,"'@PPN-Shutdown Warning'"
      send_command vdvTP,"'ADBEEP'"
    }
    CASE 2: // SYSTEM OFF
    {
      do_push (vdvTP,91)
      TIMELINE_KILL (TL_AUTO_OFF)
    }
  }
}

TIMELINE_EVENT[TL_BLINK]
{
	BLINK = !BLINK
}

TIMELINE_EVENT[TL_TEST]
{
	
	IF(![vdvProj,PROJ_POWER])
		SEND_STRING 0, "'Projector 1 POWER OFF -', TIME"
	IF([vdvProj,PROJ_POWER])
		SEND_STRING 0, "'Projector 1 POWER ON -',TIME"
	IF([vdvProj,PROJ_COOLING])
		SEND_STRING 0, "'Projector 1 COOLING -',TIME"
	IF([vdvProj,PROJ_WARMING])
		SEND_STRING 0, "'Projector 1 WARMING -',TIME"
	IF([vdvProj,PROJ_MUTE])
		SEND_STRING 0, "'Projector 1 MUTE ON -',TIME"
	IF (!([vdvProj,PROJ_MUTE]))
		SEND_STRING 0, "'Projector 1 MUTE OFF -',TIME"
		
	IF(![vdvProj2,PROJ_POW_ON])
		SEND_STRING 0, "'Projector 2 POWER OFF -', TIME"
	IF([vdvProj2,PROJ_POW_ON])
		SEND_STRING 0, "'Projector 2 POWER ON -',TIME"
	IF([vdvProj2,PROJ_COOLING])
		SEND_STRING 0, "'Projector 2 COOLING -',TIME"
	IF([vdvProj2,PROJ_WARMING])
		SEND_STRING 0, "'Projector 2 WARMING -',TIME"
	IF([vdvProj2,PROJ_MUTE])
		SEND_STRING 0, "'Projector 2 MUTE ON -',TIME"
	IF (!([vdvProj2,PROJ_MUTE]))
		SEND_STRING 0, "'Projector 2 MUTE OFF -',TIME"

	SEND_STRING 0, "'TestVar = ',ITOA(test)"
}


//ADDED
//BUTTON_EVENT[vdvTP,88] //VOL BUTTON
//{
//  PUSH:
//  {
//		STACK_VAR CHAR XMLstring[50000]
//		LONG lPosition
//		
//		XMLstring = getXMLfile('emaillist')
//		lPosition = 1
//		IF( LENGTH_STRING(XMLstring) )
//		{
//			slReturn = XML_TO_VARIABLE(emaillist_1, XMLstring, lPosition,0)
//		} 
//  }
//	HOLD[20]:
//	{
//		STACK_VAR CHAR XMLstring[50000]
//		LONG lPosition
//    lPosition = 1
//    slReturn = VARIABLE_TO_XML(emaillist_old, XMLstring, lPosition, 0)
//    SEND_STRING 0,"'POSITION=',ITOA(lPosition),' – Result = ',ITOA(slReturn)"
//    slReturn = writeXMLfile('emaillist',XMLstring)
//    IF (slReturn >= 0)
//			SEND_STRING 0,"'XML file created!'"
//	}
//}



(***********************************************************)
(*            THE ACTUAL PROGRAM GOES BELOW                *)
(***********************************************************)
DEFINE_PROGRAM

test = [vdvProj,PROJ_MUTE]
(***********************************************************************************)
(******************************FEEDBACK*********************************************)
(***********************************************************************************)

(*
[vdvTP,nAutoTimeAdjust[3]] = lAutoTimes[1] == 900000
[vdvTP,nAutoTimeAdjust[4]] = lAutoTimes[1] == 1800000
[vdvTP,nAutoTimeAdjust[5]] = lAutoTimes[1] == 3600000
[vdvTP,nAutoTimeAdjust[6]] = lAutoTimes[2] == 300000
[vdvTP,nAutoTimeAdjust[7]] = lAutoTimes[2] == 600000
[vdvTP,nAutoTimeAdjust[8]] = lAutoTimes[2] == 900000
*)
{ 
	STACK_VAR cnt;    //FEEDBACK FOR EXTRON PAGE
	FOR(cnt = 1;cnt <= MAX_LENGTH_ARRAY(dcINPUTS);cnt++)
	{
		[dcINPUTS[cnt]]   = (SOURCE == cnt)
	}
}
{ 
	STACK_VAR cnt1;    //FEEDBACK FOR SOURCE BUTTONS
	
	IF(SystemName[SYSTEM_NUMBER] == 'DAC 100')
	{
		FOR(cnt1 = 1;cnt1 <= MAX_LENGTH_ARRAY(dcSource);cnt1++)
		{
			[dcSource[cnt1]] = (SOURCE != 0 && SOURCE == VSWITCH_LOOKUP[cnt1] && cnt1+2 == DACPC)
		}
	}
	ELSE
	{
			FOR(cnt1 = 1;cnt1 <= MAX_LENGTH_ARRAY(dcSource);cnt1++)
		{
			[dcSource[cnt1]] = (SOURCE != 0 && SOURCE == VSWITCH_LOOKUP[cnt1])
		}
	}
	
}

[vdvTP,27] = [vdvProj,PROJ_POW_ON]                  // FEEDBACK FOR PROJ1 PWR ON
//[vdvTP,55] = [vdvProj,PROJ_POW_OFF]                 // FEEDBACK FOR PROJ1 PWR OFF
[vdvTP,55] = ![vdvProj,PROJ_POW_ON]//CHANGE THE CODE!!!                 // FEEDBACK FOR PROJ1 PWR OFF
[vdvTP,29] = [vdvProj,PROJ_MUTE]                    // FEEDBACK FOR PROJ1 MUTE ON
[vdvTP,30] = ![vdvProj,PROJ_MUTE]                   // FEEDBACK FOR PROJ1 MUTE OFF
[vdvTP,120] = ([vdvProj,PROJ_MUTE] AND BLINK)       // FEEDBACK FOR PROJ 1 TOGGLE MUTE
[vdvTP,31] = [vdvProj2,PROJ_POW_ON]                   // FEEDBACK FOR PROJ2 PWR ON
//[vdvTP,56] = [vdvProj2,PROJ_POW_OFF]                  // FEEDBACK FOR PROJ2 PWR OFF
[vdvTP,56] = ![vdvProj2,PROJ_POW_ON]//CHANGE THE CODE!!!                 // FEEDBACK FOR PROJ1 PWR OFF

[vdvTP,33] = [vdvProj2,PROJ_MUTE]                    // FEEDBACK FOR PROJ2 MUTE ON
[vdvTP,34] = ![vdvProj2,PROJ_MUTE]                   // FEEDBACK FOR PROJ2 MUTE OFF

[vdvTP,80] = (POP_FDBK == 1)                         // FEEDBACK FOR SELECT BUTTONS
[vdvTP,81] = (POP_FDBK == 2)
[vdvTP,82] = (POP_FDBK == 3) //NOT USED ON TP
[vdvTP,83] = (POP_FDBK == 4) //NOT USED ON TP

[vdvTP,87] = (ENVIRONMENT == 87)                     // FEEDBACK FOR SCREEN BUTTON
[vdvTP,88] = (ENVIRONMENT == 88)                     // FEEDBACK FOR VOLUME BUTTON
[vdvTP,90] = (ENVIRONMENT == 90)                     // FEEDBACK FOR PROJECTOR BUTTON

(*xxxxxxxxxxxxxxxxxx
IF(SystemName[SYSTEM_NUMBER] <> 'DAC 100')
{  
  [vdvTP,3] = (SOURCE = VSWITCH_LOOKUP[1])                  // FEEDBACK FOR PC SELECTS
  [vdvTP,4] = (SOURCE = VSWITCH_LOOKUP[2])
}
ELSE
{
  [vdvTP,3] = ((SOURCE = VSWITCH_LOOKUP[1]) && (DACPC = 3)) // FEEDBACK FOR PC SELECTS IN DAC 100
  [vdvTP,4] = ((SOURCE = VSWITCH_LOOKUP[2]) && (DACPC = 4))
}
xxxxxxxxxxxxxxxxxxxxx*)



(*
[vdvTP,3] = ((SOURCE == VSWITCH_LOOKUP[1]) && (SOURCE_BUTTON == 3)) // FEEDBACK FOR PC SELECTS IN DAC 100
[vdvTP,4] = ((SOURCE == VSWITCH_LOOKUP[2]) && (SOURCE_BUTTON == 4))  
[vdvTP,5] = (SOURCE == VSWITCH_LOOKUP[3])
[vdvTP,6] = (SOURCE == VSWITCH_LOOKUP[4])
[vdvTP,7] = (SOURCE == VSWITCH_LOOKUP[5])
[vdvTP,8] = (SOURCE == VSWITCH_LOOKUP[6])
[vdvTP,9] = (SOURCE == VSWITCH_LOOKUP[7])
[vdvTP,10] = (SOURCE == VSWITCH_LOOKUP[8])
[vdvTP,11] = (SOURCE == VSWITCH_LOOKUP[9])
[vdvTP,12] = (SOURCE == VSWITCH_LOOKUP[10])
[vdvTP,13] = (SOURCE == VSWITCH_LOOKUP[11])
[vdvTP,14] = (SOURCE == VSWITCH_LOOKUP[CASS])
[vdvTP,15] = (SOURCE == VSWITCH_LOOKUP[TURNTABLE])
[vdvTP,16] = (SOURCE == VSWITCH_LOOKUP[VCR_CC])
*)

(*
[vdvTP,DVD_FSKIP] = [dvDVD,4]                       // FEEDBACK FOR FSKIP
[vdvTP,DVD_RSKIP] = [dvDVD,5]                       // FEEDBACK FOR RSKIP
[vdvTP,DVD_MENU]  = [dvDVD,44]  
[vdvTP,DVD_UP]    = [dvDVD,45]
[vdvTP,DVD_DOWN]  = [dvDVD,46]
[vdvTP,DVD_LEFT]  = [dvDVD,47]
[vdvTP,DVD_RIGHT] = [dvDVD,48]
[vdvTP,DVD_ENTER] = [dvDVD,49]

[vdvTP,VCR_FFWD] = ([dvVCR,244] OR [dvVCR,246])
[vdvTP,VCR_REW] = ([dvVCR,245] OR [dvVCR,247])
*)


(* VOLUME CONTROLS *)

SYSTEM_CALL 'VOL1' (vdvTP,35,36,37,dvVOLUME,1,2,3)
SEND_LEVEL vdvTP,1,VOL_LVL

(* SCREEN CONTROLS *)

SYSTEM_CALL[1] 'SCREEN2' (vdvTP,20,22,21,dvRELAY,2,1,0,0)
SYSTEM_CALL[2] 'SCREEN2' (vdvTP,23,25,24,dvRELAY,4,3,0,0)
SYSTEM_CALL[3] 'SCREEN2' (vdvTP,17,19,18,dvRELAY,6,5,0,0)

(******************************)
(**** DEVICE CONTROLS *********)
(******************************)

(* VCR *)
//SYSTEM_CALL[4] 'VCR1' (dvVCR,vdvTP,VCR_PLAY,VCR_STOP,VCR_PAUSE,VCR_FFWD,VCR_REW,VCR_SFWD,VCR_SREV,VCR_REC,0)

(*xxxxxxxxxxxxxx converted to button event
PUSH[vdvTP,VCR_PLAY] //40
PUSH[vdvTP,VCR_PAUSE] //42
PUSH[vdvTP,VCR_FFWD] //43
PUSH[vdvTP,VCR_REW]  //44
PUSH[vdvTP,VCR_SFWD] //45
PUSH[vdvTP,VCR_SREV] //46
PUSH[vdvTP,VCR_REC]  //47
{
  start_counter(TL_VCR_TIMEOUT)
}

PUSH[vdvTP,VCR_STOP]  //41
{
  stop_counter(TL_VCR_TIMEOUT,1)
}
xxxxxxxxxxxxxxxxxxxxxxxxxxxx*)

(* DVD *)
//SYSTEM_CALL[5] 'DVD1' (dvDVD,vdvTP,DVD_PLAY,DVD_STOP,DVD_PAUSE,0,0,DVD_FSCAN,DVD_RSCAN ,0)

(*xxxxxxxxxx replaced with button event on INT array
PUSH[vdvTP,DVD_PLAY] //48
PUSH[vdvTP,DVD_PAUSE] //50
PUSH[vdvTP,DVD_FSCAN] //51
PUSH[vdvTP,DVD_RSCAN] //52
PUSH[vdvTP,DVD_FSKIP] //53
PUSH[vdvTP,DVD_RSKIP] //54
{
  start_counter(TL_DVD_TIMEOUT)
}
PUSH[vdvTP,DVD_STOP] //41
{
  stop_counter(TL_DVD_TIMEOUT,1)
}
xxxxxxxxxxxxxxxxxxxxxxxxx*)
IF(LENGTH_STRING(TP_BUFFER))
{
    CALL 'PARSE TP'
}

(*xxxxxxxxxxxxxxxx  This should not be done in code --- used in database
IF(LENGTH_STRING(PROJ2_BUFFER))
{
    IF(DEBUG)
    {
        SEND_STRING dvDVDEBUG,"'PROJECTOR RESPONSE - ',PROJ2_BUFFER,13,10"
    }    
    CLEAR_BUFFER PROJ2_BUFFER
}
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx*)



IF ((TOD_IN_SECONDS() + (lAutoTimes[1]/1000) + (lAutoTimes[2]/1000)) % GOING_ON_MIDNIGHT = lAutoTime && TIMELINE_ACTIVE(TL_AUTO_OFF) == 0   )
{
  TIMELINE_CREATE(TL_AUTO_OFF,lAutoTimes,2,TIMELINE_RELATIVE,TIMELINE_ONCE)
}

(*TEST CODE!!!!!!!!
DACPC = TIMELINE_ACTIVE(TL_AUTO_OFF)

IF(DACPC)
TL6TIME = TIMELINE_GET(TL_AUTO_OFF)
*)

(*xxxxxxxxxxxxxxxx  This should not be done in code --- used in database
IF((LAMP_HOURS = LAMP_FIRST_WARNING) && (!SENT_WARNING))
{
    SystemEmailAddress = "'panja@wesleyan.edu'"
 // SmtpQueMessage('from', 'to', 'subject', 'message','attach file')
    SmtpQueMessage(SystemEmailAddress,EmailToWho,"'IMPORTANT MESSAGE! ',SystemName[SYSTEM_NUMBER],
                   ' Projector Lamp Warning'","'Room: ',SystemName[SYSTEM_NUMBER],13,10,13,10,
                   ProjOneEmailFirstWarn,13,10,13,10,'Hours: ',ITOA(LAMP_HOURS),
                   '  Minutes: ',ITOA(LAMP_MINUTES)",'')

    ON[SENT_WARNING]
}
ELSE IF((LAMP_HOURS = LAMP_MAX) && (!SENT_FINAL_WARNING))
{
    SystemEmailAddress = "'panja@wesleyan.edu'"
 // SmtpQueMessage('from', 'to', 'subject', 'message','attach file')
    SmtpQueMessage(SystemEmailAddress,EmailToWho,"'URGENT!!!!!! ',SystemName[SYSTEM_NUMBER],
                   ' Projector Final Lamp Warning'","'Room: ',SystemName[SYSTEM_NUMBER],13,10,
                   13,10,ProjOneEmailFinalWarn,13,10,13,10,'Hours: ',ITOA(LAMP_HOURS),
                   '  Minutes: ',ITOA(LAMP_MINUTES)",'')

    ON[SENT_FINAL_WARNING]
}
********************)

(*xxxxxxxxxxxxxxxx  This should not be done in code --- used in database
IF((LAMP_HOURS2 = LAMP_FIRST_WARNING2) && (!SENT_WARNING2))
{
    SystemEmailAddress = "'panja@wesleyan.edu'"
 // SmtpQueMessage('from', 'to', 'subject', 'message','attach file')
    SmtpQueMessage(SystemEmailAddress,EmailToWho,"'IMPORTANT MESSAGE! ',SystemName[SYSTEM_NUMBER],
                  ' Projector 2 Lamp Warning'","'Room: ',SystemName[SYSTEM_NUMBER],13,10,13,10,
                  ProjTwoEmailFirstWarn,13,10,13,10,'Hours: ',ITOA(LAMP_HOURS2),
                  '  Minutes: ',ITOA(LAMP_MINUTES2)",'')

    ON[SENT_WARNING2]
}
ELSE IF((LAMP_HOURS2 = LAMP_MAX2) && (!SENT_FINAL_WARNING2))
{
    SystemEmailAddress = "'panja@wesleyan.edu'"
 // SmtpQueMessage('from', 'to', 'subject', 'message','attach file')
    SmtpQueMessage(SystemEmailAddress,EmailToWho,"'URGENT!!!!!! ',SystemName[SYSTEM_NUMBER],
                  ' Projector 2 Final Lamp Warning'","'Room: ',SystemName[SYSTEM_NUMBER],13,10,13,10,
                  ProjTwoEmailFinalWarn,13,10,13,10,'Hours: ',ITOA(LAMP_HOURS2),
                  '  Minutes: ',ITOA(LAMP_MINUTES2)",'')

    ON[SENT_FINAL_WARNING2]
}
xxxxxxxxxxxxxxxxxxxxxxxxxxxxx*)

//momentary feedback for "Email Info" button on Audit Page
[vdvtp,107] = mailsent


(***********************************************************)
(*                     END OF PROGRAM                      *)
(*        DO NOT PUT ANY CODE BELOW THIS COMMENT           *)
(***********************************************************)

