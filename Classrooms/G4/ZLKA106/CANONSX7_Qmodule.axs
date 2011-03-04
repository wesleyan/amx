MODULE_NAME='CANONSX7_Qmodule' (DEV dvreal , DEV vdvProxy, CHAR xmlout[50000] )


//MODULE_NAME='MTSeriesFinalTEST' (DEV dvreal, DEV vdvProxy)
(***********************************************************)
(*  FILE CREATED ON: 05/18/2004 AT: 14:09:13               *)
(***********************************************************)
(* System Type : Netlinx                                   *)
(***********************************************************)
(* REV HISTORY:                                            *)
(***********************************************************)
/* Basing CANON SX7 projector module on NEC1065_QModule_rev

*/

DEFINE_DEVICE 

#INCLUDE 'CANONSX7_queue_include'

DEFINE_CONSTANT

(********** COMMAND CHANNELS ***********)

VOLATILE INTEGER Proxy_ON = 1
VOLATILE INTEGER Proxy_OFF = 4
VOLATILE INTEGER Proxy_MUTEON = 5
VOLATILE INTEGER Proxy_MUTEOFF = 6

//*VOLATILE INTEGER MonitorDevice = 50

VOLATILE INTEGER ACTION_group[]=
{
  Proxy_ON,
  Proxy_OFF ,
  Proxy_MUTEON,
  Proxy_MUTEOFF
}

/*Following Remote Commands only work when projector is in REMOTE mode

*/

VOLATILE CHAR Real_Remote_PowerOn[] =  'POWER ON'
VOLATILE CHAR Real_Remote_PowerOff[] = 'POWER OFF'
VOLATILE CHAR Real_Remote_VidMuteOn[] = 'BLANK=ON'
VOLATILE CHAR Real_Remote_VidMuteOff[] = 'BLANK=OFF'


VOLATILE CHAR Real_Remote_CmdsList[4][10]=
{
  'POWER ON',              //on
  'POWER OFF',              //off
  'BLANK=ON',              //mute on
  'BLANK=OFF'              //mute off 
}

//Did not work when using this form of array, unsure as to the cause
VOLATILE CHAR RealRemote_CmdsList[][]=
{
  Real_Remote_PowerOn,              //on
  Real_Remote_PowerOff,              //off
  Real_Remote_VidMuteOn,              //mute on
  Real_Remote_VidMuteOff              //mute off 
}

/* RC (remote control) emulation commands work in Local mode

*/
/* Unused

VOLATILE CHAR Real_RC_Power[] = 'RC POWER'

VOLATILE CHAR Real_RC_cmds[][] =
{
    Real_RC_Power
}
*/


/* Projector Modes */

VOLATILE CHAR Real_Mode_REMOTE[] = 'REMOTE'
VOLATILE CHAR Real_Mode_LOCAL[]  = 'LOCAL'

VOLATILE CHAR dv_remote_modes[2][7]=
{
    Real_Mode_REMOTE,
    Real_Mode_LOCAL
}

//INPUT SOURCES
VOLATILE INTEGER Proxy_RGB1 =   7
VOLATILE INTEGER Proxy_RGB2 =   8
VOLATILE INTEGER Proxy_VID  =   9
VOLATILE INTEGER Proxy_SVID =   10
VOLATILE INTEGER Proxy_DIG  =   11
VOLATILE INTEGER Proxy_DIV  =   12
VOLATILE INTEGER Proxy_COMP =   13
VOLATILE INTEGER Proxy_SCART =  14

//Change to Proxy_InputList
VOLATILE INTEGER Proxy_InputList[] = //formerly input_type_input_channels[] =
{
	Proxy_RGB1,  //RGB1	
	Proxy_RGB2,	//RGB2
	Proxy_VID,	//VIDEO
	Proxy_SVID,	//SVIDEO
	Proxy_DIG,	//DIGITAL RGB
	Proxy_DIV,	//DIGITAL VIDEO
	Proxy_COMP,		//COMPONENT
	Proxy_SCART  //SCART
}

VOLATILE CHAR Real_Remote_RGB1[] =  'INPUT=A-RGB1'
VOLATILE CHAR Real_Remote_RGB2[] =  'INPUT=A-RGB2'
VOLATILE CHAR Real_Remote_VID[] =   'INPUT=VIDEO'
VOLATILE CHAR Real_Remote_SVID[] =  'INPUT=S-VIDEO'
VOLATILE CHAR Real_Remote_DIG[] =   'INPUT=D-RGB'
VOLATILE CHAR Real_Remote_DIV[] =   'INPUT=D-VIDEO'
VOLATILE CHAR Real_Remote_COMP[] =  'INPUT=COMP'
VOLATILE CHAR Real_Remote_SCART[] = 'INPUT=SCARTRGB'

VOLATILE CHAR Real_RemoteChanList[8][15] =
{
 'INPUT=A-RGB1',
 'INPUT=A-RGB2',
 'INPUT=VIDEO',
 'INPUT=S-VIDEO',
 'INPUT=D-RGB',
 'INPUT=D-VIDEO',
 'INPUT=COMP',
 'INPUT=SCARTRGB'
}

(******* END OF COMMAND CHANNELS ********)



(********** FEEDBACK CHANNELS ***********)

//STATUS
VOLATILE INTEGER Proxy_FB_ON = 101
VOLATILE INTEGER Proxy_FB_COOLING = 102
VOLATILE INTEGER Proxy_FB_MUTE = 120

//INPUT SOURCES
VOLATILE INTEGER Proxy_FB_RGB1 = 107
VOLATILE INTEGER Proxy_FB_RGB2 = 108
VOLATILE INTEGER Proxy_FB_VID = 109
VOLATILE INTEGER Proxy_FB_SVID = 110
VOLATILE INTEGER Proxy_FB_DIG = 111
VOLATILE INTEGER Proxy_FB_DIV = 112
VOLATILE INTEGER Proxy_FB_COMP = 113
VOLATILE INTEGER Proxy_FB_SCART = 114

VOLATILE INTEGER Proxy_FB_SourceList[] = //formerly input_type_feedback_channels[] = 
{
	Proxy_FB_RGB1,
	Proxy_FB_RGB2,
	Proxy_FB_VID,
	Proxy_FB_SVID,
	Proxy_FB_DIG,
	Proxy_FB_DIV,
	Proxy_FB_COMP,
	Proxy_FB_SCART
}

//Get Error codes from projector
VOLATILE CHAR ERR_NONE[] = 'NO_ERROR'
VOLATILE CHAR ERR_TEMP[] = 'ABNORMAL_TEMPERATUR' //might be truncated in specs
VOLATILE CHAR ERR_LAMP[] = 'FAULTY_LAMP'
VOLATILE CHAR ERR_LAMP_COVER[] = 'FAULTY_LAMP_COVER'
VOLATILE CHAR ERR_COOLING_FAN[] = 'FAULTY_COOLING_FAN'
VOLATILE CHAR ERR_PWR_SUPPLY[] = 'FAULTY_POWER_SUPPLY'
VOLATILE CHAR ERR_AK[] = 'FAULTY_AK'
VOLATILE CHAR ERR_ASC[] = 'FAULTY_ASC'
VOLATILE CHAR ERR_AF[] = 'FAULTY_AF'
VOLATILE CHAR ERR_POWER_ZOOM[] = 'FAULTY_POWER_ZOOM'
VOLATILE CHAR ERR_POWER_FOCUS[] = 'FAULTY_POWER_FOCUS'

//virtual device error channels
VOLATILE INTEGER Proxy_ERR_NONE = 201
VOLATILE INTEGER Proxy_ERR_TEMP = 202
VOLATILE INTEGER Proxy_ERR_LAMP = 203
VOLATILE INTEGER Proxy_ERR_LAMP_COVER = 204
VOLATILE INTEGER Proxy_ERR_COOLING_FAN = 205
VOLATILE INTEGER Proxy_ERR_PWR_SUPPLY = 206
VOLATILE INTEGER Proxy_ERR_AK = 207
VOLATILE INTEGER Proxy_ERR_ASC = 208
VOLATILE INTEGER Proxy_ERR_AF = 209
VOLATILE INTEGER Proxy_ERR_POWER_ZOOM = 210
VOLATILE INTEGER Proxy_ERR_POWER_FOCUS = 211

VOLATILE INTEGER Proxy_COMM_ACTIVE = 255 //Not sure of this

VOLATILE INTEGER Proxy_ERR_group[]=
{
	Proxy_ERR_NONE,
	Proxy_ERR_TEMP,
	Proxy_ERR_LAMP,
	Proxy_ERR_LAMP_COVER,
	Proxy_ERR_COOLING_FAN,
	Proxy_ERR_PWR_SUPPLY,
	Proxy_ERR_AK,
	Proxy_ERR_ASC,
	Proxy_ERR_AF,
	Proxy_ERR_POWER_ZOOM,
	Proxy_ERR_POWER_FOCUS
}

(******** END OF FEEDBACK CHANNELS *********)



(********** TIMELINE ID's ***********)

VOLATILE LONG	TL_NO_RESP = 3
VOLATILE LONG TL_XML = 4

(******* END OF TIMELINE ID's *******)



VOLATILE INTEGER PROJBUFF_LENGTH = 1000
VOLATILE INTEGER HEAD = 5 		//frame header length

(********* COMMAND STRINGS *********)
VOLATILE CHAR Proj_commands[][] =
{
  Real_Remote_PowerOn,        //on
  Real_Remote_PowerOff,       //off
  Real_Remote_VidMuteOn,      //mute on
  Real_Remote_VidMuteOff      //mute off
}
(******* END COMMAND STRINGS ********)

/******* RESPONSE CONSTANTS ********/

VOLATILE CHAR RESPONSE_TYPE_NACK = 'e'
VOLATILE CHAR RESPONSE_TYPE_ACK =  'i'
VOLATILE CHAR RESPONSE_TYPE_GET =  'g'

(*nack responses *)
//Supposed to be Hex symbols, must be changed
VOLATILE CHAR ERROR_LIST[25][6] =
{
   'e:0001',     
   'e:0002',     
   'e:0003',     
   'e:0004',     
   'e:0005',     
   'e:000A',     
   'e:000B',     
   'e:F001',     
   'e:F002',     
   'e:F004',     
   'e:F005',     
   'e:E0XX',
   'e:200X',
   'e:2010',
   'e:201X',
   'e:0801',
   'e:1001',
   'e:1002',
   'e:1003',
   'e:1004',
   'e:1005',
   'e:1006',
   'e:203X'   
}

//HENRY: Need to fix to correspond with above array
VOLATILE CHAR Err[25][100] =
{
  'Communication Sequence Error',
  'Command is Invalid',
  'Designated command cannot be Executed in this Mode',
  'Command Format is Incorrect', 
  'Power is Not being Supplied', 
  'Invalid Parameters',
  'SX50 internal processing has times out', //might not be here for SX7
  'Internal Error Occured',
  'Error Occurred in AUTOSETEXE=FOCUS',
  'Error Occurred in AUTOSETEXE=VKS',
  'Error Occurred in AUTOSETEXE=SCRN',
  'Communication Protocol Violation Occurred in the Projector',
  'This cannot be Executed with the Current Input Source',
  'There is No Signal Input',
  'This Cannot be Executed with the Current Input Signal',
  'Numerical Parameters are Invalid or Outside Range',
  'The Input cannot be Selected since the Terminal is set to Output',
  'Processing cannot be Executed since the User Image is not Registered',
  'IP conversion cannot be Performed',
  'DPON cannot be set to ON when PMM is OFF',
  'PMM cannot be set to OFF when DPON is ON',
  'AUTOSETEXE=FOCUS of SCRN cannot be executed since BLANK is ON',
  'The Input Signal Resolution is Not Correct'
}

VOLATILE INTEGER debug =1000
DEFINE_TYPE


//General information from GET command
/* Omitted values   
    -DOTS
    -TRACK
    -WB
    -WBRGB
    -RGBGAIN
    -RGBOFFSET
    -ACADJUST
    -MEMCADJ
    -6AXADJ
    -6AXR-6AXY
    -BVOL
    -PJON
    -LOGOPOS
    -GUIDE
    -LEDILLUMINATE
    -ERR      Parsed seperately
    -ROMVER
    -COMVER
*/

STRUCTURE get_settings
{
    CHAR MODE[6]
    CHAR POWER[6]
    CHAR BLANK[3]
    CHAR INPUT[8]
    INTEGER HPOS
    INTEGER VPOS
    INTEGER HPIX
    INTEGER VPIX
    CHAR SEL[7]       //Type of input signal, eg PAL, SECAM, NTSC...
    CHAR ASPECT[6]
    CHAR IMAGE[12]
    INTEGER BRIGHTNESS
    INTEGER CONTRAST
    INTEGER SHARPNESS
    INTEGER GAMMA
    INTEGER DGAMMA   //Dynamic gamma value
    INTEGER PROG     //Progressive value setting, 0 = off, 1 = on, 2 = auto
    INTEGER SAT      //Color Saturation value setting
    INTEGER HUE
    CHAR LAMP[6]     //NORMAL or SILENT cooling
    INTEGER VKS      //Vertical Keystone setting
    INTEGER HKS      //Horizontal Keystone setting
    INTEGER AVOL     //Audio Volume
    CHAR MUTE[3]     //Audio mute
    CHAR IMAGEFLIP[13]        //ie. NONE, CEILING, REAR, REAR_CEILING
    CHAR PMM[7]      //Power management setting
    CHAR NOSIG[5]    //Screen displayed when there is no signal
    CHAR NOSHOW[5]   //Display screen when nothing is shown
    CHAR LANG[3]     //Language
    CHAR TERMINAL[3] //Terminal setting, in or out
    CHAR KEYLOCK[4]
    INTEGER RCCH     //Remote control setting inquiry
    CHAR DPON[3]     //Direct power-on setting
    CHAR ERR[20]
    CHAR NOSHOWSTATE[3]      
    CHAR FREEZE[3]
    CHAR SIGNALSTATUS[10]
    CHAR LAMPCOUNTER[11]   //Strange non-numerical codes used by Canon
    CHAR PRODCODE[4]
}

DEFINE_VARIABLE
get_settings projSettings

(********** PROJECTOR COMMAND QUEUE VARIABLES ***********)
VOLATILE CHAR ID1

VOLATILE INTEGER COMMAND_INDEX

(********** TIMELINE ARRAYS ***********)

LONG lTL3_Array[1] =  //TL_NO_RESP
{
	30000
}
LONG lTL4_Array[1] =  //TL_XML
{
	10000
}

VOLATILE CHAR ProjBuff[PROJBUFF_LENGTH]
VOLATILE CHAR sXMLstring[50000]

(********** UDT's ************)

DEFINE_LATCHING

DEFINE_MUTUALLY_EXCLUSIVE
//Only one error returned at a time

([vdvproxy,Proxy_ERR_NONE], [vdvproxy,Proxy_ERR_TEMP], [vdvproxy,Proxy_ERR_LAMP], [vdvproxy,Proxy_ERR_LAMP_COVER],
 [vdvproxy,Proxy_ERR_COOLING_FAN], [vdvproxy,Proxy_ERR_PWR_SUPPLY], [vdvproxy,Proxy_ERR_AK],
 [vdvproxy,Proxy_ERR_ASC], [vdvproxy,Proxy_ERR_AF], [vdvproxy,Proxy_ERR_POWER_ZOOM], [vdvproxy,Proxy_ERR_POWER_FOCUS])

//Only one source possible at a time
([vdvProxy,Proxy_FB_COMP],[vdvProxy,Proxy_FB_DIG],[vdvProxy,Proxy_FB_DIV],[vdvProxy,Proxy_FB_RGB1],
 [vdvProxy,Proxy_FB_RGB2],[vdvProxy,Proxy_FB_SCART],[vdvProxy,Proxy_FB_SVID],[vdvProxy,Proxy_FB_VID] )

(***********************************************************)
(*        SUBROUTINE/FUNCTION DEFINITIONS GO BELOW         *)
(***********************************************************)

DEFINE_FUNCTION INTEGER SetBaud(integer inrate)
{
	//baudrate = inrate
	SEND_STRING 0, "'SET BAUD ',ITOA(inrate),',N,8,2 256 DISABLE'"
	SEND_COMMAND dvReal,"'SET BAUD ',ITOA(inrate),',N,8,2 256 DISABLE'"
	return 1
}

DEFINE_FUNCTION INTEGER  switchinputs(INTEGER sourceNum)
{
    // 1 - RGB1	2 - RGB2
    // 3 - VIDEO	4 - SVIDEO
    // 5 - DIG	6 - DIV
    // 7 - COMP	8 - SCART
	
  IF( sourceNum <= 8 )
  {
      SEND_STRING devicestrings, "Real_Mode_REMOTE"
      SEND_STRING devicestrings, "Real_RemoteChanList[sourceNum]"
      SEND_STRING devicestrings, "Real_Mode_LOCAL"
      RETURN (sourceNum)
  }
  ELSE	
      RETURN 0
}
/*
Compares input1 to input2 starting from the character that is 'offset'
number of characters from the left of input1 (input 2 starts at offset2)
*/

DEFINE_FUNCTION INTEGER isEqual(CHAR input1[], CHAR input2[], INTEGER offset1, INTEGER offset2) {
  STACK_VAR INTEGER iterator 
  FOR(iterator = 0; iterator < MIN_VALUE(LENGTH_ARRAY(input1), LENGTH_ARRAY(input2)); iterator++) {
    IF(input1[iterator+offset1] <> input2[iterator+offset2])
	RETURN FALSE
  }
  RETURN TRUE //Default
}

/*
Following calls are specific for the Canon.
Information is requested from the projector via the GET <TYPE> commands
This information is then saved into the corresponding field in projSettings

Preconditions : projBuff contains the correct information for the call
    e.g--- if parse_GET_MODE is called, the buffer starts with 'g:MODE=' and is followed by a valid mode
*/
DEFINE_CALL 'parse_GET_MODE'(CHAR projBuff[]) {
    REMOVE_STRING(projBuff, '=', 1)
    projSettings.MODE = projBuff
}
DEFINE_CALL 'parse_GET_POWER'(CHAR projBuff[]) {
    REMOVE_STRING(projBuff, '=', 1)
    projSettings.POWER = projBuff
    
    IF(isEqual(projSettings.POWER, 'OFF', 1, 1)) {
	OFF[vdvProxy,Proxy_FB_ON]
	OFF[vdvProxy,Proxy_FB_COOLING]
    } ELSE IF (isEqual(projSettings.POWER, 'ON', 1, 1)) {
	ON[vdvProxy, Proxy_FB_ON]
	OFF[vdvProxy,Proxy_FB_COOLING]
    } ELSE IF(isEqual(projSettings.POWER, 'ON2OFF', 1, 1)) {
	OFF[vdvProxy,Proxy_FB_ON]
	ON[vdvProxy,Proxy_FB_COOLING]
    }
}
DEFINE_CALL 'parse_GET_BLANK'(CHAR projBuff[]) {
    REMOVE_STRING(projBuff, '=', 1)
    projSettings.BLANK = projBuff
    
        IF(isEqual(projSettings.BLANK, 'ON', 1, 1)) {
	    ON[vdvProxy,Proxy_FB_MUTE]
	} ELSE {
	    OFF[vdvProxy,Proxy_FB_MUTE]
	}
}
DEFINE_CALL 'parse_GET_INPUT'(CHAR projBuff[]) {
    STACK_VAR INTEGER counter
    
    REMOVE_STRING(projBuff, '=', 1)
    projSettings.INPUT = projBuff
    
    FOR (counter = 1; counter < LENGTH_ARRAY(Real_RemoteChanList); counter++) {
	IF(isEqual(projSettings.INPUT, Real_RemoteChanList[counter], 1, 7)) {
	    ON[vdvProxy, Proxy_FB_SourceList]
	}
    }
}
DEFINE_CALL 'parse_GET_HPOS'(CHAR projBuff[]) {
    REMOVE_STRING(projBuff, '=', 1)
    projSettings.HPOS = ATOI(projBuff)
}
DEFINE_CALL 'parse_GET_VPOS'(CHAR projBuff[]) {
    REMOVE_STRING(projBuff, '=', 1)
    projSettings.VPOS = ATOI(projBuff)
}
DEFINE_CALL 'parse_GET_HPIX'(CHAR projBuff[]) {
    REMOVE_STRING(projBuff, '=', 1)
    projSettings.HPIX = ATOI(projBuff)
}
DEFINE_CALL 'parse_GET_VPIX'(CHAR projBuff[]) {
    REMOVE_STRING(projBuff, '=', 1)
    projSettings.VPIX = ATOI(projBuff)
}
DEFINE_CALL 'parse_GET_SEL'(CHAR projBuff[]) {
    REMOVE_STRING(projBuff, '=', 1)
    projSettings.SEL = projBuff
}
DEFINE_CALL 'parse_GET_ASPECT'(CHAR projBuff[]) {
    REMOVE_STRING(projBuff, '=', 1)
    projSettings.ASPECT = projBuff
}
DEFINE_CALL 'parse_GET_IMAGE'(CHAR projBuff[]) {
    REMOVE_STRING(projBuff, '=', 1)
    projSettings.IMAGE = projBuff
}
DEFINE_CALL 'parse_GET_BRIGHTNESS'(CHAR projBuff[]) {
    REMOVE_STRING(projBuff, '=', 1)
    projSettings.BRIGHTNESS = ATOI(projBuff)
}
DEFINE_CALL 'parse_GET_CONTRAST'(CHAR projBuff[]) {
    REMOVE_STRING(projBuff, '=', 1)
    projSettings.CONTRAST = ATOI(projBuff)
}
DEFINE_CALL 'parse_GET_SHARPNESS'(CHAR projBuff[]) {
    REMOVE_STRING(projBuff, '=', 1)
    projSettings.SHARPNESS = ATOI(projBuff)
}
DEFINE_CALL 'parse_GET_GAMMA'(CHAR projBuff[]) {
    REMOVE_STRING(projBuff, '=', 1)
    projSettings.GAMMA = ATOI(projBuff)
}
DEFINE_CALL 'parse_GET_DGAMMA'(CHAR projBuff[]) {
    REMOVE_STRING(projBuff, '=', 1)
    projSettings.DGAMMA = ATOI(projBuff)
}
DEFINE_CALL 'parse_GET_PROG'(CHAR projBuff[]) {
    REMOVE_STRING(projBuff, '=', 1)
    projSettings.PROG = ATOI(projBuff)
}
DEFINE_CALL 'parse_GET_SAT'(CHAR projBuff[]) {
    REMOVE_STRING(projBuff, '=', 1)
    projSettings.SAT = ATOI(projBuff)
}
DEFINE_CALL 'parse_GET_HUE'(CHAR projBuff[]) {
    REMOVE_STRING(projBuff, '=', 1)
    projSettings.HUE = ATOI(ProjBuff)
}
DEFINE_CALL 'parse_GET_LAMP'(CHAR projBuff[]) {
    REMOVE_STRING(projBuff, '=', 1)
    projSettings.LAMP = projBuff
}
DEFINE_CALL 'parse_GET_VKS'(CHAR projBuff[]) {
    REMOVE_STRING(projBuff, '=', 1)
    projSettings.VKS = ATOI(projBuff)
}
DEFINE_CALL 'parse_GET_HKS'(CHAR projBuff[]) {
    REMOVE_STRING(projBuff, '=', 1)
    projSettings.HKS = ATOI(projBuff)
}
DEFINE_CALL 'parse_GET_AVOL'(CHAR projBuff[]) {
    REMOVE_STRING(projBuff, '=', 1)
    projSettings.AVOL = ATOI(projBuff)
}
DEFINE_CALL 'parse_GET_MUTE'(CHAR projBuff[]) {
    REMOVE_STRING(projBuff, '=', 1)
    projSettings.MUTE = projBuff
}
DEFINE_CALL 'parse_GET_IMAGEFLIP'(CHAR projBuff[]) {
    REMOVE_STRING(projBuff, '=', 1)
    projSettings.IMAGEFLIP = projBuff
}
DEFINE_CALL 'parse_GET_PMM'(CHAR projBuff[]) {
    REMOVE_STRING(projBuff, '=', 1)
    projSettings.PMM = projBuff
}
DEFINE_CALL 'parse_GET_NOSIG'(CHAR projBuff[]) {
    REMOVE_STRING(projBuff, '=', 1)
    projSettings.NOSIG = projBuff
}
DEFINE_CALL 'parse_GET_NOSHOW'(CHAR projBuff[]) {
    REMOVE_STRING(projBuff, '=', 1)
    projSettings.NOSHOW = projBuff
}
DEFINE_CALL 'parse_GET_LANG'(CHAR projBuff[]) {
    REMOVE_STRING(projBuff, '=', 1)
    projSettings.LANG = projBuff
}
DEFINE_CALL 'parse_GET_TERMINAL'(CHAR projBuff[]) {
    REMOVE_STRING(projBuff, '=', 1)
    projSettings.TERMINAL = projBuff
}
DEFINE_CALL 'parse_GET_KEYLOCK'(CHAR projBuff[]) {
    REMOVE_STRING(projBuff, '=', 1)
    projSettings.KEYLOCK = projBuff
}
DEFINE_CALL 'parse_GET_RCCH'(CHAR projBuff[]) {
    REMOVE_STRING(projBuff, '=', 1)
    projSettings.RCCH = ATOI(projBuff)
}
DEFINE_CALL 'parse_GET_DPON'(CHAR projBuff[]) {
    REMOVE_STRING(projBuff, '=', 1)
    projSettings.DPON = projBuff
}
DEFINE_CALL 'parse_GET_NOSHOWSTATE'(CHAR projBuff[]) {
    REMOVE_STRING(projBuff, '=', 1)
    projSettings.NOSHOWSTATE = projBuff
}
DEFINE_CALL 'parse_GET_FREEZE'(CHAR projBuff[]) {
    REMOVE_STRING(projBuff, '=', 1)
    projSettings.FREEZE = projBuff
}
DEFINE_CALL 'parse_GET_SIGNALSTATUS'(CHAR projBuff[]) {
    REMOVE_STRING(projBuff, '=', 1)
    projSettings.SIGNALSTATUS = projBuff
}
DEFINE_CALL 'parse_GET_LAMPCOUNTER'(CHAR projBuff[]) {
    REMOVE_STRING(projBuff, '=', 1)
   projSettings.LAMPCOUNTER = projBuff
}
DEFINE_CALL 'parse_GET_PRODCODE'(CHAR projBuff[]) {
    REMOVE_STRING(projBuff, '=', 1)
    projSettings.PRODCODE = projBuff
}

DEFINE_CALL 'parse_GET_ERR'(CHAR projBuff[]) {
    REMOVE_STRING(projBuff, '=', 1)
    projSettings.ERR = projBuff
    
    //Errors are mutually exclusive (only most important one is returned)
    IF(isEqual(projSettings.ERR, ERR_NONE, 1, 1)) {
	ON[vdvProxy, PROXY_ERR_NONE]
    } ELSE IF (isEqual(projSettings.ERR, ERR_TEMP, 1, 1)) {
	ON[vdvProxy, PROXY_ERR_TEMP]
    } ELSE IF(isEqual(projSettings.ERR, ERR_LAMP, 1, 1)) {
	ON[vdvProxy, PROXY_ERR_LAMP]
    } ELSE IF(isEqual(projSettings.ERR, ERR_LAMP_COVER, 1, 1)) {
	ON[vdvProxy, PROXY_ERR_LAMP_COVER]
    } ELSE IF(isEqual(projSettings.ERR, ERR_COOLING_FAN, 1, 1)) {
	ON[vdvProxy, Proxy_ERR_COOLING_FAN]
    } ELSE IF(isEqual(projSettings.ERR, ERR_PWR_SUPPLY, 1, 1)) {
	ON[vdvProxy, Proxy_ERR_PWR_SUPPLY]
    } ELSE IF(isEqual(projSettings.ERR, ERR_AK, 1, 1)) {
	ON[vdvProxy, PROXY_ERR_AK]
    } ELSE IF(isEqual(projSettings.ERR, ERR_ASC, 1, 1)) {
	ON[vdvProxy, PROXY_ERR_ASC]
    } ELSE IF(isEqual(projSettings.ERR, ERR_AF, 1, 1)) {
	ON[vdvProxy, PROXY_ERR_AF]
    } ELSE IF(isEqual(projSettings.ERR, ERR_POWER_ZOOM, 1, 1)) {
	ON[vdvProxy, Proxy_ERR_POWER_ZOOM]
    } ELSE IF(isEqual(projSettings.ERR, ERR_POWER_FOCUS, 1, 1)) {
	ON[vdvProxy, Proxy_ERR_POWER_FOCUS]
    } ELSE {
	SEND_STRING 0, 'Unknown GET_ERR message, debug code'
    }
}

DEFINE_START

CREATE_BUFFER dvreal,ProjBuff
CLEAR_BUFFER ProjBuff


TIMELINE_CREATE(TL_NO_RESP,lTL3_Array,1,TIMELINE_RELATIVE,TIMELINE_REPEAT)
TIMELINE_CREATE(TL_XML,lTL4_Array,1,TIMELINE_RELATIVE,TIMELINE_REPEAT)


DEFINE_EVENT
DATA_EVENT[dvreal]

{ 
  ONLINE:
  {
    SEND_COMMAND dvreal,'SET BAUD 19200,N,8,2'
	//baudrate = 19200
	//SEND_COMMAND dvTP,"'TEXT2-CURRENT BAUD=| ',ITOA(baudrate)"
	
  } 
  
  STRING:
  { 
    WAIT 3
    //Debug: sends all strings received from projector to telnet console 
    {  
	SEND_STRING 0, "ProjBuff"
        TIMELINE_PAUSE(TL_NO_RESP)
        ON[vdvProxy,Proxy_COMM_ACTIVE]
	
	//Find the response category 
	SWITCH(ProjBuff[1])
	{
	    CASE RESPONSE_TYPE_NACK:
	    {
	    //NOT YET IMPLEMENTED
	    //Have to find out how to generate a Nack error to see actual feedback messages 
	    }
	    BREAK
	    CASE RESPONSE_TYPE_GET:
	    {   
	    //Place the returned value in appropriate projSettings field
	    IF(isEqual(projBuff, 'MODE=',3, 1)) {
	        CALL 'parse_GET_MODE'(projBuff)
	    } ELSE IF(isEqual(projBuff, 'POWER=', 3, 1)) {
		CALL 'parse_GET_POWER'(projBuff)
	    } ELSE IF(isEqual(projBuff, 'BLANK=', 3, 1)) {
		CALL 'parse_GET_BLANK'(projBuff)
	    } ELSE IF(isEqual(projBuff, 'INPUT=', 3, 1)) {
		CALL 'parse_GET_INPUT'(projBuff)
	    } ELSE IF(isEqual(projBuff, 'HPOS=', 3, 1)) {
		CALL 'parse_GET_HPOS'(projBuff)
	    } ELSE IF(isEqual(projBuff, 'VPOS=', 3, 1)) {
		CALL 'parse_GET_VPOS'(projBuff)
	    } ELSE IF(isEqual(projBuff, 'HPIX=', 3, 1)) {
		CALL 'parse_GET_HPIX'(projBuff)
	    } ELSE IF(isEqual(projBuff, 'VPIX=', 3, 1)) {
		CALL 'parse_GET_VPIX'(projBuff)
	    } ELSE IF(isEqual(projBuff, 'SEL=', 3, 1)) {
		CALL 'parse_GET_SEL'(projBuff)
	    } ELSE IF(isEqual(projBuff, 'ASPECT=', 3, 1)) {
		CALL 'parse_GET_ASPECT'(projBuff)
	    } ELSE IF(isEqual(projBuff, 'IMAGE=', 3, 1)) {
		CALL 'parse_GET_IMAGE'(projBuff)
	    } ELSE IF(isEqual(projBuff, 'BRI=', 3, 1)) {
		CALL 'parse_GET_BRIGHTNESS'(projBuff)
	    } ELSE IF(isEqual(projBuff, 'CONT=', 3, 1)) {
		CALL 'parse_GET_CONTRAST'(projBuff)
	    } ELSE IF(isEqual(projBuff, 'SHARP=', 3, 1)) {
		CALL 'parse_GET_SHARPNESS'(projBuff)
	    } ELSE IF(isEqual(projBuff, 'GAMMA=', 3, 1)) {
		CALL 'parse_GET_GAMMA'(projBuff)
	    } ELSE IF(isEqual(projBuff, 'DGAMMA=', 3, 1)) {
		CALL 'parse_GET_DGAMMA'(projBuff)
	    } ELSE IF(isEqual(projBuff, 'PROG=', 3, 1)) {
		CALL 'parse_GET_PROG'(projBuff)
	    } ELSE IF(isEqual(projBuff, 'SAT=', 3, 1)) {
		CALL 'parse_GET_SAT'(projBuff)
	    } ELSE IF(isEqual(projBuff, 'HUE=', 3, 1)) {
		CALL 'parse_GET_HUE'(projBuff)
	    } ELSE IF(isEqual(projBuff, 'LAMP=', 3, 1)) {
		CALL 'parse_GET_LAMP'(projBuff)
	    } ELSE IF(isEqual(projBuff, 'VKS=', 3, 1)) {
		CALL 'parse_GET_VKS'(projBuff)
	    } ELSE IF(isEqual(projBuff, 'HKS=', 3, 1)) {
		CALL 'parse_GET_HKS'(projBuff)
	    } ELSE IF(isEqual(projBuff, 'AVOL=', 3, 1)) {
		CALL 'parse_GET_AVOL'(projBuff)
	    } ELSE IF(isEqual(projBuff, 'MUTE=', 3, 1)) {
		CALL 'parse_GET_MUTE'(projBuff)
	    } ELSE IF(isEqual(projBuff, 'IMAGEFLIP=', 3, 1)) {
		CALL 'parse_GET_IMAGEFLIP'(projBuff)
	    } ELSE IF(isEqual(projBuff, 'PMM=', 3, 1)) {
		CALL 'parse_GET_PMM'(projBuff)
	    } ELSE IF(isEqual(projBuff, 'NOSIG=', 3, 1)) {
		CALL 'parse_GET_NOSIG'(projBuff)
	    } ELSE IF(isEqual(projBuff, 'NOSHOW=', 3, 1)) {
		CALL 'parse_GET_NOSHOW'(projBuff)
	    } ELSE IF(isEqual(projBuff, 'LANG=', 3, 1)) {
		CALL 'parse_GET_LANG'(projBuff)
	    } ELSE IF(isEqual(projBuff, 'TERMINAL=', 3, 1)) {
		CALL 'parse_GET_TERMINAL'(projBuff)
	    } ELSE IF(isEqual(projBuff, 'KEYLOCK=', 3, 1)) {
		CALL 'parse_GET_KEYLOCK'(projBuff)
	    } ELSE IF(isEqual(projBuff, 'RCCH=', 3, 1)) {
		CALL 'parse_GET_RCCH'(projBuff)
	    } ELSE IF(isEqual(projBuff, 'DPON=', 3, 1)) {
		CALL 'parse_GET_DPON'(projBuff)
	    } ELSE IF(isEqual(projBuff, 'NOSHOWSTATE=', 3, 1)) {
		CALL 'parse_GET_NOSHOWSTATE'(projBuff)
	    } ELSE IF(isEqual(projBuff, 'FREEZE=', 3, 1)) {
		CALL 'parse_GET_FREEZE'(projBuff)
	    } ELSE IF(isEqual(projBuff, 'SIGNALSTATUS=', 3, 1)) {
		CALL 'parse_GET_SIGNALSTATUS'(projBuff)
	    } ELSE IF(isEqual(projBuff, 'LAMPCOUNTER=', 3, 1)) {
		CALL 'parse_GET_LAMPCOUNTER'(projBuff)
	    } ELSE IF(isEqual(projBuff, 'PRODCODE=', 3, 1)) {
		CALL 'parse_GET_PRODCODE'(projBuff)
	    } ELSE IF(isEqual(projBuff, 'ERR=', 3, 1)) {
		CALL 'parse_GET_ERR'(projBuff)
	    } ELSE {
	      SEND_STRING 0, "'Unknown Buffer Message: ',projBuff"
	    }
	    }
	    BREAK
	    CASE RESPONSE_TYPE_ACK:
	    {
	    
	    IF(isEqual(projBuff, 'OK', 3, 1)) {
		//Command was sent and projector confirmed, do nothing
		SEND_STRING 0, 'Proj sends i:OK'
	    } ELSE IF(isEqual(projBuff, 'BUSY', 3, 1)) {
		SEND_STRING 0, 'Proj is BUSY'
	    }    
	    
	    }
	    DEFAULT:
	    {
	    SEND_STRING 0, "'Unknown Buffer Message: ',projBuff"
	    }
	    
	}
      CLEAR_BUFFER ProjBuff
      TIMELINE_SET(TL_NO_RESP,0)  
      TIMELINE_RESTART(TL_NO_RESP)
    }
  }
}

CHANNEL_EVENT[vdvProxy,ACTION_group]
{
	ON:
	{
	    //SEND_STRING 0, 'Turning projector on'
	    SEND_STRING devicestrings, "Real_Mode_REMOTE"
	    SEND_STRING devicestrings, "Real_Remote_CmdsList[GET_LAST(ACTION_group)]"
	    //SEND_STRING devicestrings, "Real_Mode_LOCAL" //Commenting to allow for blanking (vid mute)
	 /*   
	    SWITCH(CHANNEL) {
	    CASE Proxy_MUTEON: {
		SEND_STRING devicestrings, "'GET BLANK', $00"
//		[vdvProxy,Proxy_FB_MUTE] = ![vdvProxy, Proxy_FB_MUTE]
	    } 
	    }
	    */
	}
}


TIMELINE_EVENT[TL_NO_RESP]
{
  
  OFF[vdvproxy,Proxy_COMM_ACTIVE]	//online feedback
}


TIMELINE_EVENT[TL_XML]
{
	STACK_VAR	SLONG slReturn
	slReturn = VARIABLE_TO_XML(projSettings,sXMLstring,1,0)
	xmlout = sXMLstring;
}

CHANNEL_EVENT[vdvproxy,Proxy_InputList]
{
	ON:
	{
	    STACK_VAR INTEGER myinput
	    INTEGER result
	    myinput = GET_LAST(Proxy_InputList)
	    IF(![vdvproxy,Proxy_FB_SourceList[GET_LAST(Proxy_InputList)]])
		result = switchinputs(myinput)
	}
}

/*Special debug channel. Should see if this exists in main code and standardise across
the modules.
  Basic idea is to have a channel that can be pulsed to send general information to
  diagnostics.

*/
CHANNEL_EVENT[vdvproxy,debug]
{
	ON:
	{
	IF([vdvproxy,Proxy_FB_MUTE])
	    SEND_STRING 0, 'mute FB is on'
	
	IF([vdvproxy,PROXY_FB_ON])
	    SEND_STRING 0, 'Power FB is on'
	SEND_STRING 0, "'projSettings.power  ', projSettings.POWER"
	IF(isEqual(projSettings.POWER, 'ON', 1, 1))
	    SEND_STRING 0, 'Power settings is on'
	}
}
DEFINE_PROGRAM
