PROGRAM_NAME='MAIN SOURCE,REV 3 with DVD menu,mhe,Rev 0'
(*{{PS_SOURCE_INFO(PROGRAM STATS)                          *)
(***********************************************************)
(*  FILE CREATED ON: 08/15/2001 AT: 16:43:56               *)
(***********************************************************)
(*  FILE_LAST_MODIFIED_ON: 09/01/2004  AT: 13:00:10        *)
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
(*  corrected problem with "cooling" popup not closing     *)
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
dvROUTER        = 5001:1:0       // EXTRON  8/10 9600 N,8,1
                                 
dvPROJ2         = 5001:4:0       // NEC MT1045 38400 N,8,1 FOR SYS 1-5 NEC MT1050 FOR THE REST
dvPCSWITCH      = 5001:3:0       // BLACKBOX SERVSWITCH ULTRA 9600 N,8,1 KEYBRD MOUSE SWITCH

dvProj          = 5001:2:0       // NEC MT1045/50 38400 N,8,1 PROJECTOR 1 FOR ANY SYS

LIGHTS          = 5001:5:0       //lUTRON GRAPHIC EYE
//dvProj = 20:1:10  //!!LOCAL TESTING
vdvProj         = 33001:1:0      // VIRTUAL DEVICE FOR ABOVE PROJECTOR'S MODULE
vdvProj2        = 33001:2:0      // VIRTUAL DEVICE FOR ABOVE PROJECTOR'S MODULE

dvRELAY         = 5001:7:0       // 3 SCREENS RELAYS 1-6 MOMENTARY 'SCREEN2' NOT IN ALL SYSTEMS
dvVCR           = 5001:8:0       // PANASONIC AG1970 CAR:ON IR PANASO51.IRL FOR SYS 1-5
                                 // PANASONIC PV-VS4821 FOR THE REST PANAS102.IRL???

dvDVD           = 5001:9:0       // SONY DVP-S560 CAR:ON  IR SONY0403.IRL FOR SYS 1-5
                                 // SONY DVRNS400D FOR THE REST SONY0357.IRL??????

dvDVDEBUG       = 0:0:0          // DEBUG DEVICE

(* AXLINK DEVICES *)
vdvTP           = 33000:1:0      // VIRTUAL TOUCH PANEL
dv16		= 85:1:0      
dvTP1           = 128:1:0        // AXT-MLC IN PAC001, PAC004        
dvTP2           = 132:1:0        // AXT-CA10 JUDD116, SC509A
dvTP3           = 136:1:0        // AXT-MCP DAC100
dvRADIO         = 140:1:0        // AXR-RF VIEW POINT VPT-GS IN PAC125, PAC002, PAC107
                                 // VPT-CP IN ROOM SC509A
dvWEB1          = 10001:1:0      // WEBPNL IN NETLINX USE CA10 FILE AND CONVERT TO HTML
                                 // FTP TO NETLINX MASTERS...IN ALL SYSTEMS          

dvVOLUME        = 150:1:0        // AXB-VOL3 OR NXC-VOL4

DEFINE_COMBINE
(vdvTP,dvTP1,dvWEB1,dvTP2,dvTP3,dvRADIO)
//DEFINE_CONNECT_LEVEL
//(dvVOLUME,1,dvVOLUME,2,vdvTP,1)

(***********************************************************)
(*               INCLUDE FILES GO BELOW                    *)
(***********************************************************)
#INCLUDE 'i!-EmailOut.axi'      // INCLUDE TO SEND EMAIL

(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT

// TIMELINES
TL_VCR_TIMEOUT  = 1
TL_DVD_TIMEOUT  = 2
TL_CAS_TIMEOUT  = 3
TL_TTB_TIMEOUT  = 4
TL_DISP_REFRESH = 5
TL_AUTO_OFF     = 6

TRUE            = 1
FALSE           = 0

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

(* PROJECTOR COMMANDS *)
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
PROJ_COVER_OPEN = 51
PROJ_TEMP_FAULT = 52
PROJ_FAN_STOP   = 53
PROJ_PWR_SUPPLY = 54
PROJ_LAMP_FAIL  = 55
PROJ_COMM_ACTIVE = 250

PON             = 1
POF             = 2
MON             = 3
MOF             = 4
RGB1            = 5
RGB2            = 6
VIDEO           = 7
SVIDEO          = 8

(* VCR TRANSPORT CONTROLS *)

VCR_PLAY        = 40
VCR_STOP        = 41
VCR_PAUSE       = 42
VCR_FFWD        = 43
VCR_REW         = 44
VCR_SFWD        = 45
VCR_SREV        = 46
VCR_REC         = 47

(* DVD TRANSPORT CONTROLS *)

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



(* PROJECTOR STATUS SHANNELS *)
POWER_STAT      = 200
COOL_WARM_STAT  = 201
MUTE_STAT       = 202
IN1             = 211
IN2             = 212
IN3             = 213
IN4             = 214
IN5             = 215
IN6             = 216
IN7             = 217
IN8             = 218
IN9             = 219
IN10            = 220
IN11            = 221

// EMAIL RECIPIENT ADDRESSES...SEPERATE ADDRESSES WITH AN ASCII ";"
EmailToWho = 'panja@wesleyan.edu' 

(***********************************************************)
(*              DATA TYPE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_TYPE

(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE

INTEGER mailsent

VOLATILE BLINK
DEBUG
DACPC
(* EMAIL MESSAGES *)
ProjOneEmailFirstWarn[255]  // LAMP EMAIL WARNING MESSAGES
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

CHAR SystemName[34][15] =
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
    'ANTHRO 6MM',   // SYSTEM 17 ** !!REV1 ADDED SYSTEMS 17-26
    'EAC MF+',      // SYSTEM 18
    'FISK 210',     // SYSTEM 19
    'FISK 305',     // SYSTEM 20
    'FISK 314',     // SYSTEM 21
    'FISK 404',     // SYSTEM 22
    'FISK 413',     // SYSTEM 23
    'FISK 414',     // SYSTEM 24
    'HALL ATWATER', // SYSTEM 25
    'ZILKHA 106',   // SYSTEM 26
    'SC 121',       // SYSTEM 27
    'FISK 115',     // SYSTEM 28
    'SC 309',       // SYSTEM 29
    'SC 405',       // SYSTEM 30
    'SC 58',        // SYSTEM 31
    'SHANKLIN 201', // SYSTEM 32
    'DOWNEY 113',   // SYSTEM 33
    'DOWNEY 100'    // SYSTEM 34
    
}

DEVCHAN dcINPUTS[] =  // SYSTEM 8/10 ROUTER INPUT DIRECT BUTTONS
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

DEVCHAN dcSource[] =
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
    {vdvTP,16}//,              // SELECT VCR W/CC 
    //{vdvTP,17}               // SELECT LASER DISK
}

DEVCHAN dcSource2[] =
{
    {dv16,5},               // SELECT RACK PC
    {dv16,9},               // SELECT RACK MAC
    {dv16,2},               // SELECT DVD
    {dv16,6},               // SELECT VCR
    {dv16,10},              // SELECT VCR W/CC 
    {dv16,13},              // SELECT RACK LAPTOP
    {dv16,14}               // SELECT RACK AUX VIDEO
}

DEVCHAN dcDowneyTransportControl[] =
{
    {dv16,7},                //PLAY 
    {dv16,12},               //STOP 
    {dv16,4},                //PAUSE 
    {dv16,11},               //FAST FORWARD 
    {dv16,3}                 //REWIND 
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

DEVCHAN dcDvdSkip[] =
{
    {vdvTP,53},               // DVD FORWARD SKIP
    {vdvTP,54}                // DVD REV SKIP
}

//LIGHTING VARIABLE
NEAR_BOARD
FAR_BOARD

(* SETUP VARIABLE TEXT AND POPUPS *)
VOL_LVL
SOURCE
SOURCE_D100
SOURCE_BUTTON
SOURCE_BUTTON_DOWNEY_100
ROUTER_BUFFER[255]
PROJ2_BUFFER[255]
TP_BUFFER[255]
TP_MSG[100]
TRASH[100]
LOOKUP[20]
TXT_LOOKUP[20][20]
POP_LOOKUP[40][50]
POP_FDBK
ENVIRONMENT
DOWNEY_VCR_FLAG
TRANSPORT

RTR_RESPONSE[100]

vdvProjBuffer[20]
vdvProj2Buffer[20]

PROJ1_PWR

PROJ2_PWR
PROJ2_MUTE
PROJ2_MSG[100]

PROJ2_CMD[10][30]

PERSISTENT Passwords[2][4] // 2 levels: tech, supertech

PERSISTENT LAMP_SECONDS2   
PERSISTENT LAMP_MINUTES2
PERSISTENT LAMP_HOURS2
SENT_WARNING2
TEMP_TIME2[8]
LAMP_MAX2
LAMP_FIRST_WARNING2
SENT_FINAL_WARNING2

TEMP_TIME[8]
PERSISTENT LAMP_HOURS
PERSISTENT LAMP_MINUTES
PERSISTENT LAMP_SECONDS
LAMP_MAX
LAMP_FIRST_WARNING
SENT_WARNING
SENT_FINAL_WARNING
SystemEmailAddress[40]


LONG lTimeArray[1]
LONG lAutoTimes[2]

LONG GOING_ON_MIDNIGHT

PERSISTENT LONG AUDIT_VCR_SEC
PERSISTENT LONG AUDIT_DVD_SEC
PERSISTENT LONG AUDIT_CAS_SEC
PERSISTENT LONG AUDIT_TTB_SEC
LONG VCR_START
LONG DVD_START
LONG CAS_START
LONG TTB_START

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
(*               LATCHING DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_LATCHING

(***********************************************************)
(*       MUTUALLY EXCLUSIVE DEFINITIONS GO BELOW           *)
(***********************************************************)
DEFINE_MUTUALLY_EXCLUSIVE
([dvROUTER,211]..[dvROUTER,220])            // IN 1 - 10
([dv16,1],[dv16,3],[dv16,4],[dv16,7],[dv16,11],[dv16,12]) // Downey house push button panel TRANSPORT
([dv16,1],[dv16,2],[dv16,5],[dv16,6],[dv16,9],[dv16,10],[dv16,13],[dv16,14]) // Downey house push button panel input select
(***********************************************************)
(*        SUBROUTINE/FUNCTION DEFINITIONS GO BELOW         *)
(***********************************************************)
(* EXAMPLE: DEFINE_FUNCTION <RETURN_TYPE> <NAME> (<PARAMETERS>) *)
(* EXAMPLE: DEFINE_CALL '<NAME>' (<PARAMETERS>) *)

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
    (* PROJECTOR 1 TIMER *)
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

DEFINE_CALL 'PARSE SYS10' (MSG[100])
{
  IF(FIND_STRING(MSG,"10",1))
  {    
    IF(DEBUG)
      SEND_STRING dvDVDEBUG,"'RESPONSE - ',MSG,13,10"
      
    RTR_RESPONSE = REMOVE_STRING(MSG,"10",1)
    SELECT
    {
      ACTIVE(FIND_STRING(RTR_RESPONSE,'PR',1)):        // DISPLAY PWR IS ON OR OFF
      {
        [dvROUTER,POWER_STAT] = ATOI(RTR_RESPONSE)
      }
      ACTIVE(FIND_STRING(RTR_RESPONSE,'MUT',1)):      // MUTE ON OR OFF
      {
        [dvROUTER,MUTE_STAT] = ATOI(RTR_RESPONSE)
      }
      ACTIVE(FIND_STRING(RTR_RESPONSE,'C',1)):        // SET SOURCE 
      {
        SOURCE = ATOI(RTR_RESPONSE)
      }
    }   
  }
  ELSE
  {
    CLEAR_BUFFER ROUTER_BUFFER
  }
}


// SETUP VARIABLE TEXT AND POPUPS BASED ON SYSTEM NAME
DEFINE_CALL 'SETUP' (CHAR SYSTEM[])
{
    SWITCH(SYSTEM)
    {
        CASE 'PAC 001':
        {
             LOOKUP[RACK_PC]     = 1
             LOOKUP[RACK_MAC]    = 2
             LOOKUP[DVD]         = 3
             LOOKUP[VCR]         = 4
             LOOKUP[RACK_LAP]    = 5
             LOOKUP[RACK_VID]    = 6
             LOOKUP[VCR_CC]      = 7
             LOOKUP[FB_LAP]     = 8
             LOOKUP[FB_VID]      = 9
             LOOKUP[DOC_CAM]     = 10
             LOOKUP[WB_LAP]      = 11
             
             TXT_LOOKUP[LOOKUP[RACK_PC]] = 'RACK PC'
             TXT_LOOKUP[LOOKUP[RACK_MAC]] = 'RACK MAC'
             TXT_LOOKUP[LOOKUP[RACK_LAP]] = 'RACK LAPTOP'
             TXT_LOOKUP[LOOKUP[FB_LAP]] = 'FLOOR BOX LAPTOP'
             TXT_LOOKUP[LOOKUP[VCR]] = 'VCR CONTROLS'
             TXT_LOOKUP[LOOKUP[DVD]] = 'DVD CONTROLS'
             TXT_LOOKUP[LOOKUP[RACK_VID]] = 'RACK A / V'
             TXT_LOOKUP[LOOKUP[FB_VID]] = 'PODIUM A / V'  
             TXT_LOOKUP[LOOKUP[FB_LAP]] = 'PODIUM LAPTOP'
             TXT_LOOKUP[LOOKUP[DOC_CAM]] = 'DOC CAM'
             TXT_LOOKUP[LOOKUP[VCR_CC]] = 'VCR CONTROLS w/CC'
             TXT_LOOKUP[11] = '11'
             TXT_LOOKUP[12] = '12'
 
             POP_LOOKUP[1] = 'PPON-Use Local Controls'
             POP_LOOKUP[2] = 'PPON-Use Local Controls'
             POP_LOOKUP[3] = 'PPON-DVD Controls'
             POP_LOOKUP[4] = 'PPON-VCR Controls'
             POP_LOOKUP[5] = 'PPON-Use Local Controls'
             POP_LOOKUP[6] = 'PPON-Use Local Controls'
             POP_LOOKUP[7] = 'PPON-VCR Controls'
             POP_LOOKUP[8] = 'PPON-Use Local Controls'
             POP_LOOKUP[9] = 'PPON-Use Local Controls'
             POP_LOOKUP[10] = 'PPON-Use Local Controls'
             POP_LOOKUP[11] = 'PPON-DVD Controls'
             POP_LOOKUP[12] = 'PPON-Use Local Controls'
             POP_LOOKUP[13] = 'PPON-Lamp Hours Reset'

             POP_LOOKUP[14] = 'PPON-PC Sources 10'
             POP_LOOKUP[15] = 'PPON-Video Sources 8'
             POP_LOOKUP[16] = 'PPON-Environment'
             POP_LOOKUP[17] = 'PPON-Utilities'
             POP_LOOKUP[18] = 'PPON-PC Sources 3'
             POP_LOOKUP[19] = 'PPON-PC Sources 2'
             POP_LOOKUP[20] = 'PPON-Lighting Controls'
             POP_LOOKUP[21] = 'PPON-Screen Controls X2'
             POP_LOOKUP[22] = 'PPON-Volume Controls'
             POP_LOOKUP[23] = 'PPON-Shutdown'
             POP_LOOKUP[24] = 'PPON-Projector Controls'
             POP_LOOKUP[25] = 'PAGE-Logo Page'
             POP_LOOKUP[26] = 'PPOF-Shutdown'
             POP_LOOKUP[27] = 'PPON-Protected Projector Controls'
             POP_LOOKUP[28] = 'PPON-Reset Lamp Hours'
             POP_LOOKUP[29] = ''
             POP_LOOKUP[30] = 'PAGE-Main Page'
             POP_LOOKUP[31] = 'PPON-EXTRON10'
             POP_LOOKUP[32] = ''
        }
        CASE 'PAC 002':
        {
             (* ROUTER TABLE *)

             LOOKUP[RACK_PC]     = 1
             LOOKUP[RACK_MAC]    = 2
             LOOKUP[RACK_LAP]    = 5
             LOOKUP[FB_LAP]      = 7
             LOOKUP[WB_LAP]      = 11
             LOOKUP[POD_LAP]     = 0
             LOOKUP[DOC_CAM]     = 10
             LOOKUP[VCR]         = 4
             LOOKUP[DVD]         = 3
             LOOKUP[RACK_VID]    = 6
             LOOKUP[FB_VID]      = 8 
             
             TXT_LOOKUP[LOOKUP[RACK_PC]] = 'RACK PC'
             TXT_LOOKUP[LOOKUP[RACK_MAC]] = 'RACK MAC'
             TXT_LOOKUP[LOOKUP[RACK_LAP]] = 'RACK LAPTOP'
             TXT_LOOKUP[LOOKUP[FB_LAP]] = 'FLOOR BOX LAPTOP'
             TXT_LOOKUP[LOOKUP[VCR]] = 'VCR CONTROLS'
             TXT_LOOKUP[LOOKUP[DVD]] = 'DVD CONTROLS'
             TXT_LOOKUP[LOOKUP[RACK_VID]] = 'RACK A / V'
             TXT_LOOKUP[LOOKUP[FB_VID]] = 'FLOOR BOX  A / V'
             TXT_LOOKUP[LOOKUP[POD_LAP]] = 'PODIUM LAPTOP'
             TXT_LOOKUP[LOOKUP[DOC_CAM]] = 'DOC CAM'
             TXT_LOOKUP[11] = '11'
             TXT_LOOKUP[12] = '12'
 
             POP_LOOKUP[1] = 'PPON-Use Local Controls'
             POP_LOOKUP[2] = 'PPON-Use Local Controls'
             POP_LOOKUP[3] = 'PPON-DVD Controls'
             POP_LOOKUP[4] = 'PPON-VCR Controls'
             POP_LOOKUP[5] = 'PPON-Use Local Controls'
             POP_LOOKUP[6] = 'PPON-Use Local Controls'
             POP_LOOKUP[7] = 'PPON-Use Local Controls'
             POP_LOOKUP[8] = 'PPON-Use Local Controls'
             POP_LOOKUP[9] = 'PPON-Use Local Controls'
             POP_LOOKUP[10] = 'PPON-Use Local Controls'
             POP_LOOKUP[11] = 'PPON-DVD Controls'
             POP_LOOKUP[12] = 'PPON-Use Local Controls'
             POP_LOOKUP[13] = 'PPON-Lamp Hours Reset'

             POP_LOOKUP[14] = 'PPON-PC Sources 4'
             POP_LOOKUP[15] = 'PPON-Video Sources'
             POP_LOOKUP[16] = 'PPON-Environment'
             POP_LOOKUP[17] = 'PPON-Utilities'
             POP_LOOKUP[18] = 'PPON-PC Sources 3'
             POP_LOOKUP[19] = 'PPON-PC Sources 2'
             POP_LOOKUP[20] = 'PPON-Lighting Controls'
             POP_LOOKUP[21] = 'PPON-Screen Controls X3'
             POP_LOOKUP[22] = 'PPON-Volume Controls'
             POP_LOOKUP[23] = 'PPON-Shutdown'
             POP_LOOKUP[24] = 'PPON-Projector Controls X2'
             POP_LOOKUP[25] = 'PAGE-Logo Page'
             POP_LOOKUP[26] = 'PPOF-Shutdown'
             POP_LOOKUP[27] = 'PPON-Protected Projector Controls 2'
             POP_LOOKUP[28] = 'PPON-Reset Proj1 Lamp Hours'
             POP_LOOKUP[29] = 'PPON-Reset Proj2 Lamp Hours'
             POP_LOOKUP[30] = 'PAGE-Main Page'
             POP_LOOKUP[31] = 'PPON-EXTRON10'
             POP_LOOKUP[32] = ''
        }
        CASE 'PAC 004':
        {
             LOOKUP[RACK_PC]     = 1
             LOOKUP[RACK_MAC]    = 2
             LOOKUP[DVD]         = 3
             LOOKUP[VCR]         = 4
             LOOKUP[RACK_LAP]    = 5
             LOOKUP[RACK_VID]    = 6
             LOOKUP[VCR_CC]      = 7
             LOOKUP[FB_LAP]     = 8
             LOOKUP[FB_VID]      = 9
             LOOKUP[DOC_CAM]     = 10
             LOOKUP[WB_LAP]      = 11
             
             TXT_LOOKUP[LOOKUP[RACK_PC]] = 'RACK PC'
             TXT_LOOKUP[LOOKUP[RACK_MAC]] = 'RACK MAC'
             TXT_LOOKUP[LOOKUP[RACK_LAP]] = 'RACK LAPTOP'
             TXT_LOOKUP[LOOKUP[FB_LAP]] = 'FLOOR BOX LAPTOP'
             TXT_LOOKUP[LOOKUP[VCR]] = 'VCR CONTROLS'
             TXT_LOOKUP[LOOKUP[DVD]] = 'DVD CONTROLS'
             TXT_LOOKUP[LOOKUP[RACK_VID]] = 'RACK A / V'
             TXT_LOOKUP[LOOKUP[FB_VID]] = 'PODIUM A / V'  
             TXT_LOOKUP[LOOKUP[FB_LAP]] = 'PODIUM LAPTOP'
             TXT_LOOKUP[LOOKUP[DOC_CAM]] = 'DOC CAM'
             TXT_LOOKUP[LOOKUP[VCR_CC]] = 'VCR CONTROLS w/CC'
             TXT_LOOKUP[11] = '11'
             TXT_LOOKUP[12] = '12'
 
             POP_LOOKUP[1] = 'PPON-Use Local Controls'
             POP_LOOKUP[2] = 'PPON-Use Local Controls'
             POP_LOOKUP[3] = 'PPON-DVD Controls'
             POP_LOOKUP[4] = 'PPON-VCR Controls'
             POP_LOOKUP[5] = 'PPON-Use Local Controls'
             POP_LOOKUP[6] = 'PPON-Use Local Controls'
             POP_LOOKUP[7] = 'PPON-VCR Controls'
             POP_LOOKUP[8] = 'PPON-Use Local Controls'
             POP_LOOKUP[9] = 'PPON-Use Local Controls'
             POP_LOOKUP[10] = 'PPON-Use Local Controls'
             POP_LOOKUP[11] = 'PPON-DVD Controls'
             POP_LOOKUP[12] = 'PPON-Use Local Controls'
             POP_LOOKUP[13] = 'PPON-Lamp Hours Reset'

             POP_LOOKUP[14] = 'PPON-PC Sources 10'
             POP_LOOKUP[15] = 'PPON-Video Sources 8'
             POP_LOOKUP[16] = 'PPON-Environment'
             POP_LOOKUP[17] = 'PPON-Utilities'
             POP_LOOKUP[18] = 'PPON-PC Sources 3'
             POP_LOOKUP[19] = 'PPON-PC Sources 2'
             POP_LOOKUP[20] = 'PPON-Lighting Controls'
             POP_LOOKUP[21] = 'PPON-Screen Controls X2'
             POP_LOOKUP[22] = 'PPON-Volume Controls'
             POP_LOOKUP[23] = 'PPON-Shutdown'
             POP_LOOKUP[24] = 'PPON-Projector Controls'
             POP_LOOKUP[25] = 'PAGE-Logo Page'
             POP_LOOKUP[26] = 'PPOF-Shutdown'
             POP_LOOKUP[27] = 'PPON-Protected Projector Controls'
             POP_LOOKUP[28] = 'PPON-Reset Lamp Hours'
             POP_LOOKUP[29] = ''
             POP_LOOKUP[30] = 'PAGE-Main Page'
             POP_LOOKUP[31] = 'PPON-EXTRON10'
             POP_LOOKUP[32] = ''
                           
              (*         Ron's code unmodified
              LOOKUP[RACK_PC]     = 1
              LOOKUP[RACK_MAC]    = 2
              LOOKUP[RACK_LAP]    = 5
              LOOKUP[FB_LAP]      = 7
              LOOKUP[WB_LAP]      = 11
              LOOKUP[POD_LAP]     = 8
              LOOKUP[DOC_CAM]     = 10
              LOOKUP[VCR]         = 4
              LOOKUP[DVD]         = 3
              LOOKUP[RACK_VID]    = 6
              LOOKUP[FB_VID]      = 9

              TXT_LOOKUP[LOOKUP[RACK_PC]] = 'RACK PC'
              TXT_LOOKUP[LOOKUP[RACK_MAC]] = 'RACK MAC'
              TXT_LOOKUP[LOOKUP[RACK_LAP]] = 'RACK LAPTOP'
              TXT_LOOKUP[LOOKUP[FB_LAP]] = 'FLOOR BOX LAPTOP'
              TXT_LOOKUP[LOOKUP[VCR]] = 'VCR CONTROLS'
              TXT_LOOKUP[LOOKUP[DVD]] = 'DVD CONTROLS'
              TXT_LOOKUP[LOOKUP[RACK_VID]] = 'RACK A / V'
              TXT_LOOKUP[LOOKUP[FB_VID]] = 'PODIUM A / V'
              TXT_LOOKUP[LOOKUP[POD_LAP]] = 'PODIUM LAPTOP'
              TXT_LOOKUP[LOOKUP[DOC_CAM]] = 'DOC CAM'
              TXT_LOOKUP[11] = '11'
              TXT_LOOKUP[12] = '12'

              POP_LOOKUP[1] = 'PPON-Use Local Controls'
              POP_LOOKUP[2] = 'PPON-Use Local Controls'
              POP_LOOKUP[3] = 'PPON-DVD Controls'
              POP_LOOKUP[4] = 'PPON-VCR Controls'
              POP_LOOKUP[5] = 'PPON-Use Local Controls'
              POP_LOOKUP[6] = 'PPON-Use Local Controls'
              POP_LOOKUP[7] = 'PPON-Use Local Controls'
              POP_LOOKUP[8] = 'PPON-Use Local Controls'
              POP_LOOKUP[9] = 'PPON-Use Local Controls'
              POP_LOOKUP[10] = 'PPON-Use Local Controls'
              POP_LOOKUP[11] = 'PPON-DVD Controls'
              POP_LOOKUP[12] = 'PPON-Use Local Controls'
              POP_LOOKUP[13] = 'PPON-Lamp Hours Reset'

              POP_LOOKUP[14] = 'PPON-PC Sources 2'
              POP_LOOKUP[15] = 'PPON-Video Sources 3'
              POP_LOOKUP[16] = 'PPON-Environment'
              POP_LOOKUP[17] = 'PPON-Utilities'
              POP_LOOKUP[18] = 'PPON-PC Sources 3'
              POP_LOOKUP[19] = 'PPON-PC Sources 2'
              POP_LOOKUP[20] = 'PPON-Lighting Controls'
              POP_LOOKUP[21] = 'PPON-Screen Controls X2'
              POP_LOOKUP[22] = 'PPON-Volume Controls'
              POP_LOOKUP[23] = 'PPON-Shutdown'
              POP_LOOKUP[24] = 'PPON-Projector Controls'
              POP_LOOKUP[25] = 'PAGE-Logo Page'
              POP_LOOKUP[26] = 'PPOF-Shutdown'
              POP_LOOKUP[27] = 'PPON-Protected Projector Controls'
              POP_LOOKUP[28] = 'PPON-Reset Lamp Hours'
              POP_LOOKUP[29] = ''
              POP_LOOKUP[30] = 'PAGE-Main Page'
              POP_LOOKUP[31] = 'PPON-EXTRON10'
              POP_LOOKUP[32] = ''*)
        }
        CASE 'PAC 107':
        {
              (* ROUTER TABLE *)

              LOOKUP[RACK_PC]     = 1
              LOOKUP[RACK_MAC]    = 2
              LOOKUP[RACK_LAP]    = 5
              LOOKUP[FB_LAP]      = 0
              LOOKUP[WB_LAP]      = 7       // WALL BOX AUX 
              LOOKUP[POD_LAP]     = 0
              LOOKUP[DOC_CAM]     = 0
              LOOKUP[VCR]         = 4
              LOOKUP[DVD]         = 3
              LOOKUP[RACK_VID]    = 6
              // LOOKUP[FB_VID]      = 8       // WALL BOX AUX
              LOOKUP[VCR_CC]      = 8     
              
              TXT_LOOKUP[LOOKUP[RACK_PC]] = 'RACK PC'
              TXT_LOOKUP[LOOKUP[RACK_MAC]] = 'RACK MAC'
              TXT_LOOKUP[LOOKUP[RACK_LAP]] = 'RACK LAPTOP'
              TXT_LOOKUP[LOOKUP[WB_LAP]] = 'WALL BOX LAPTOP'
              TXT_LOOKUP[LOOKUP[VCR]] = 'VCR CONTROLS'
              TXT_LOOKUP[LOOKUP[DVD]] = 'DVD CONTROLS'
              TXT_LOOKUP[LOOKUP[RACK_VID]] = 'RACK A / V'
              // TXT_LOOKUP[LOOKUP[FB_VID]] = 'WALL BOX A / V'
              TXT_LOOKUP[LOOKUP[POD_LAP]] = 'PODIUM LAPTOP'
              TXT_LOOKUP[LOOKUP[DOC_CAM]] = 'DOC CAM'
              TXT_LOOKUP[LOOKUP[VCR_CC]] = 'VCR CONTROLS w/CC'
              TXT_LOOKUP[11] = '11'
              TXT_LOOKUP[12] = '12'

              POP_LOOKUP[1] = 'PPON-Use Local Controls'
              POP_LOOKUP[2] = 'PPON-Use Local Controls'
              POP_LOOKUP[3] = 'PPON-DVD Controls'
              POP_LOOKUP[4] = 'PPON-VCR Controls'
              POP_LOOKUP[5] = 'PPON-Use Local Controls'
              POP_LOOKUP[6] = 'PPON-Use Local Controls'
              POP_LOOKUP[7] = 'PPON-Use Local Controls'
              POP_LOOKUP[8] = 'PPON-VCR Controls'
              // POP_LOOKUP[8] = 'PPON-Use Local Controls'
              POP_LOOKUP[9] = 'PPON-Use Local Controls'
              POP_LOOKUP[10] = 'PPON-Use Local Controls'
              POP_LOOKUP[11] = 'PPON-DVD Controls'
              POP_LOOKUP[12] = 'PPON-Use Local Controls'
              POP_LOOKUP[13] = 'PPON-Lamp Hours Reset'

              POP_LOOKUP[14] = 'PPON-PC Sources 1'
              POP_LOOKUP[15] = 'PPON-Video Sources 10'
              POP_LOOKUP[16] = 'PPON-Environment'
              POP_LOOKUP[17] = 'PPON-Utilities'
              POP_LOOKUP[18] = 'PPON-PC Sources 3'
              POP_LOOKUP[19] = 'PPON-PC Sources 2'
              POP_LOOKUP[20] = 'PPON-Lighting Controls'
              POP_LOOKUP[21] = 'PPON-Screen Controls'
              POP_LOOKUP[22] = 'PPON-Volume Controls'
              POP_LOOKUP[23] = 'PPON-Shutdown'
              POP_LOOKUP[24] = 'PPON-Projector Controls'
              POP_LOOKUP[25] = 'PAGE-Logo Page'
              POP_LOOKUP[26] = 'PPOF-Shutdown'
              POP_LOOKUP[27] = 'PPON-Protected Projector Controls'
              POP_LOOKUP[28] = 'PPON-Reset Lamp Hours'
              POP_LOOKUP[29] = ''
              POP_LOOKUP[30] = 'PAGE-Main Page'
              POP_LOOKUP[31] = 'PPON-EXTRON10'
              POP_LOOKUP[32] = ''

        }
        CASE 'PAC 125':
        {
        
              (* ROUTER TABLE *)

              LOOKUP[RACK_PC]     = 1
              LOOKUP[RACK_MAC]    = 2
              LOOKUP[RACK_LAP]    = 5
              LOOKUP[FB_LAP]      = 0
              LOOKUP[WB_LAP]      = 7       // WALL BOX AUX 
              LOOKUP[POD_LAP]     = 0
              LOOKUP[DOC_CAM]     = 0
              LOOKUP[VCR]         = 4
              LOOKUP[DVD]         = 3
              LOOKUP[RACK_VID]    = 6
              // LOOKUP[FB_VID]      = 8       // WALL BOX AUX
              LOOKUP[VCR_CC]      = 8     
              
              TXT_LOOKUP[LOOKUP[RACK_PC]] = 'RACK PC'
              TXT_LOOKUP[LOOKUP[RACK_MAC]] = 'RACK MAC'
              TXT_LOOKUP[LOOKUP[RACK_LAP]] = 'RACK LAPTOP'
              TXT_LOOKUP[LOOKUP[WB_LAP]] = 'WALL BOX LAPTOP'
              TXT_LOOKUP[LOOKUP[VCR]] = 'VCR CONTROLS'
              TXT_LOOKUP[LOOKUP[DVD]] = 'DVD CONTROLS'
              TXT_LOOKUP[LOOKUP[RACK_VID]] = 'RACK A / V'
              // TXT_LOOKUP[LOOKUP[FB_VID]] = 'WALL BOX A / V'
              TXT_LOOKUP[LOOKUP[POD_LAP]] = 'PODIUM LAPTOP'
              TXT_LOOKUP[LOOKUP[DOC_CAM]] = 'DOC CAM'
              TXT_LOOKUP[LOOKUP[VCR_CC]] = 'VCR CONTROLS w/CC'
              TXT_LOOKUP[11] = '11'
              TXT_LOOKUP[12] = '12'

              POP_LOOKUP[1] = 'PPON-Use Local Controls'
              POP_LOOKUP[2] = 'PPON-Use Local Controls'
              POP_LOOKUP[3] = 'PPON-DVD Controls'
              POP_LOOKUP[4] = 'PPON-VCR Controls'
              POP_LOOKUP[5] = 'PPON-Use Local Controls'
              POP_LOOKUP[6] = 'PPON-Use Local Controls'
              POP_LOOKUP[7] = 'PPON-Use Local Controls'
              POP_LOOKUP[8] = 'PPON-VCR Controls'
              // POP_LOOKUP[8] = 'PPON-Use Local Controls'
              POP_LOOKUP[9] = 'PPON-Use Local Controls'
              POP_LOOKUP[10] = 'PPON-Use Local Controls'
              POP_LOOKUP[11] = 'PPON-DVD Controls'
              POP_LOOKUP[12] = 'PPON-Use Local Controls'
              POP_LOOKUP[13] = 'PPON-Lamp Hours Reset'

              POP_LOOKUP[14] = 'PPON-PC Sources 1'
              POP_LOOKUP[15] = 'PPON-Video Sources 10'
              POP_LOOKUP[16] = 'PPON-Environment'
              POP_LOOKUP[17] = 'PPON-Utilities'
              POP_LOOKUP[18] = 'PPON-PC Sources 3'
              POP_LOOKUP[19] = 'PPON-PC Sources 2'
              POP_LOOKUP[20] = 'PPON-Lighting Controls'
              POP_LOOKUP[21] = 'PPON-Screen Controls'
              POP_LOOKUP[22] = 'PPON-Volume Controls'
              POP_LOOKUP[23] = 'PPON-Shutdown'
              POP_LOOKUP[24] = 'PPON-Projector Controls'
              POP_LOOKUP[25] = 'PAGE-Logo Page'
              POP_LOOKUP[26] = 'PPOF-Shutdown'
              POP_LOOKUP[27] = 'PPON-Protected Projector Controls'
              POP_LOOKUP[28] = 'PPON-Reset Lamp Hours'
              POP_LOOKUP[29] = ''
              POP_LOOKUP[30] = 'PAGE-Main Page'
              POP_LOOKUP[31] = 'PPON-EXTRON10'
              POP_LOOKUP[32] = ''

        (*
            Ron's code unmodified
              (* ROUTER TABLE *)
              LOOKUP[RACK_PC]     = 1
              LOOKUP[RACK_MAC]    = 2
              LOOKUP[RACK_LAP]    = 5
              LOOKUP[FB_LAP]      = 0
              LOOKUP[WB_LAP]      = 7
              LOOKUP[POD_LAP]     = 0
              LOOKUP[DOC_CAM]     = 0
              LOOKUP[VCR]         = 4
              LOOKUP[DVD]         = 3
              LOOKUP[RACK_VID]    = 6
              LOOKUP[FB_VID]      = 8     
              
              TXT_LOOKUP[LOOKUP[RACK_PC]] = 'RACK PC'
              TXT_LOOKUP[LOOKUP[RACK_MAC]] = 'RACK MAC'
              TXT_LOOKUP[LOOKUP[RACK_LAP]] = 'RACK LAPTOP'
              TXT_LOOKUP[LOOKUP[WB_LAP]] = 'WALL BOX LAPTOP'
              TXT_LOOKUP[LOOKUP[VCR]] = 'VCR CONTROLS'
              TXT_LOOKUP[LOOKUP[DVD]] = 'DVD CONTROLS'
              TXT_LOOKUP[LOOKUP[RACK_VID]] = 'RACK A / V'
              TXT_LOOKUP[LOOKUP[FB_VID]] = 'WALL BOX A / V'
              TXT_LOOKUP[LOOKUP[POD_LAP]] = 'PODIUM LAPTOP'
              TXT_LOOKUP[LOOKUP[DOC_CAM]] = 'DOC CAM'
              TXT_LOOKUP[11] = '11'
              TXT_LOOKUP[12] = '12'

              POP_LOOKUP[1] = 'PPON-Use Local Controls'
              POP_LOOKUP[2] = 'PPON-Use Local Controls'
              POP_LOOKUP[3] = 'PPON-DVD Controls'
              POP_LOOKUP[4] = 'PPON-VCR Controls'
              POP_LOOKUP[5] = 'PPON-Use Local Controls'
              POP_LOOKUP[6] = 'PPON-Use Local Controls'
              POP_LOOKUP[7] = 'PPON-Use Local Controls'
              POP_LOOKUP[8] = 'PPON-Use Local Controls'
              POP_LOOKUP[9] = 'PPON-Use Local Controls'
              POP_LOOKUP[10] = 'PPON-Use Local Controls'
              POP_LOOKUP[11] = 'PPON-DVD Controls'
              POP_LOOKUP[12] = 'PPON-Use Local Controls'
              POP_LOOKUP[13] = 'PPON-Lamp Hours Reset'

              POP_LOOKUP[14] = 'PPON-PC Sources 1'
              POP_LOOKUP[15] = 'PPON-Video Sources 2'
              POP_LOOKUP[16] = 'PPON-Environment'
              POP_LOOKUP[17] = 'PPON-Utilities'
              POP_LOOKUP[18] = 'PPON-PC Sources 3'
              POP_LOOKUP[19] = 'PPON-PC Sources 2'
              POP_LOOKUP[20] = 'PPON-Lighting Controls'
              POP_LOOKUP[21] = 'PPON-Screen Controls'
              POP_LOOKUP[22] = 'PPON-Volume Controls'
              POP_LOOKUP[23] = 'PPON-Shutdown'
              POP_LOOKUP[24] = 'PPON-Projector Controls'
              POP_LOOKUP[25] = 'PAGE-Logo Page'
              POP_LOOKUP[26] = 'PPOF-Shutdown'
              POP_LOOKUP[27] = 'PPON-Protected Projector Controls'
              POP_LOOKUP[28] = 'PPON-Reset Lamp Hours'
              POP_LOOKUP[29] = ''
              POP_LOOKUP[30] = 'PAGE-Main Page'
              POP_LOOKUP[31] = 'PPON-EXTRON10'
              POP_LOOKUP[32] = ''
        *)
        }
        CASE 'JUDD 116':
        {
              (* ROUTER TABLE *)
              LOOKUP[RACK_PC]     = 1
              LOOKUP[RACK_MAC]    = 2
              LOOKUP[RACK_LAP]    = 0
              LOOKUP[FB_LAP]      = 0
              LOOKUP[VCR_CC]      = 9 // !!NEW
              LOOKUP[POD_LAP]     = 6
              LOOKUP[DOC_CAM]     = 7
              LOOKUP[VCR]         = 4
              LOOKUP[DVD]         = 3
              LOOKUP[RACK_VID]    = 5
              LOOKUP[FB_VID]      = 8     
              
              TXT_LOOKUP[LOOKUP[RACK_PC]] = 'RACK PC'
              TXT_LOOKUP[LOOKUP[RACK_MAC]] = 'RACK MAC'
              TXT_LOOKUP[LOOKUP[RACK_LAP]] = 'RACK LAPTOP'
              TXT_LOOKUP[LOOKUP[FB_LAP]] = 'FLOOR BOX LAPTOP'
              TXT_LOOKUP[LOOKUP[VCR]] = 'VCR CONTROLS'
              TXT_LOOKUP[LOOKUP[DVD]] = 'DVD CONTROLS'
              TXT_LOOKUP[LOOKUP[RACK_VID]] = 'RACK A / V'
              TXT_LOOKUP[LOOKUP[FB_VID]] = 'PODIUM A / V'
              TXT_LOOKUP[LOOKUP[POD_LAP]] = 'PODIUM LAPTOP'
              TXT_LOOKUP[LOOKUP[DOC_CAM]] = 'DOC CAM'
              TXT_LOOKUP[LOOKUP[VCR_CC]] = 'VCR CONTROLS W/CC' // !!NEW
              TXT_LOOKUP[12] = '12'

              POP_LOOKUP[1] = 'PPON-Use Local Controls'
              POP_LOOKUP[2] = 'PPON-Use Local Controls'
              POP_LOOKUP[3] = 'PPON-DVD Controls'
              POP_LOOKUP[4] = 'PPON-VCR Controls'
              POP_LOOKUP[5] = 'PPON-Use Local Controls'
              POP_LOOKUP[6] = 'PPON-Use Local Controls'
              POP_LOOKUP[7] = 'PPON-Use Local Controls'
              POP_LOOKUP[8] = 'PPON-Use Local Controls'
              POP_LOOKUP[9] = 'PPON-VCR Controls'
              POP_LOOKUP[10] = 'PPON-Use Local Controls'
              POP_LOOKUP[11] = 'PPON-DVD Controls'
              POP_LOOKUP[12] = 'PPON-Use Local Controls'
              POP_LOOKUP[13] = 'PPON-Lamp Hours Reset'

              POP_LOOKUP[14] = 'PPON-PC Sources 5'
              POP_LOOKUP[15] = 'PPON-Video Sources 9'// !!NEW
              POP_LOOKUP[16] = 'PPON-Environment'
              POP_LOOKUP[17] = 'PPON-Utilities'
              POP_LOOKUP[18] = 'PPON-PC Sources 3'
              POP_LOOKUP[19] = 'PPON-PC Sources 2'
              POP_LOOKUP[20] = 'PPON-Lighting Controls'
              POP_LOOKUP[21] = 'PPON-Screen Controls X2'
              POP_LOOKUP[22] = 'PPON-Volume Controls'
              POP_LOOKUP[23] = 'PPON-Shutdown'
              POP_LOOKUP[24] = 'PPON-Projector Controls'
              POP_LOOKUP[25] = 'PAGE-Logo Page'
              POP_LOOKUP[26] = 'PPOF-Shutdown'
              POP_LOOKUP[27] = 'PPON-Protected Projector Controls'
              POP_LOOKUP[28] = 'PPON-Reset Lamp Hours'
              POP_LOOKUP[29] = ''
              POP_LOOKUP[30] = 'PAGE-Main Page'
              POP_LOOKUP[31] = 'PPON-EXTRON10'
              POP_LOOKUP[32] = ''
        }
        CASE 'DAC 100':
        {
              (* ROUTER TABLE *)
              LOOKUP[RACK_PC]     = 1
              LOOKUP[RACK_MAC]    = 1
              LOOKUP[RACK_LAP]    = 0
              LOOKUP[FB_LAP]      = 0
              LOOKUP[WB_LAP]      = 0
              LOOKUP[POD_LAP]     = 4               // CHANGED DUE TO CONDUIT ISSUE
              LOOKUP[DOC_CAM]     = 5               // HAD TO MAKE WORK WITH WHAT 
              LOOKUP[VCR]         = 3               // THEY HAD
              LOOKUP[DVD]         = 2               
              LOOKUP[RACK_VID]    = 6               
              LOOKUP[FB_VID]      = 7                    
              
              TXT_LOOKUP[LOOKUP[RACK_PC]] = 'RACK PC'
              TXT_LOOKUP[LOOKUP[RACK_MAC]] = 'RACK MAC'
              TXT_LOOKUP[LOOKUP[RACK_LAP]] = 'RACK LAPTOP'
              TXT_LOOKUP[LOOKUP[FB_LAP]] = 'FLOOR BOX - LAPTOP'
              TXT_LOOKUP[LOOKUP[VCR]] = 'VCR CONTROLS'
              TXT_LOOKUP[LOOKUP[DVD]] = 'DVD CONTROLS'
              TXT_LOOKUP[LOOKUP[RACK_VID]] = 'RACK A / V'
              TXT_LOOKUP[LOOKUP[FB_VID]] = 'PODIUM A / V'
              TXT_LOOKUP[LOOKUP[POD_LAP]] = 'PODIUM LAPTOP'
              TXT_LOOKUP[LOOKUP[DOC_CAM]] = 'DOC CAM'
              TXT_LOOKUP[11] = 'RACK PC'
              TXT_LOOKUP[12] = 'RACK MAC'

              POP_LOOKUP[1] = 'PPON-Use Local Controls'
              POP_LOOKUP[2] = 'PPON-DVD Controls'
              POP_LOOKUP[3] = 'PPON-VCR Controls'
              POP_LOOKUP[4] = 'PPON-Use Local Controls'
              POP_LOOKUP[5] = 'PPON-Use Local Controls'
              POP_LOOKUP[6] = 'PPON-Use Local Controls'
              POP_LOOKUP[7] = 'PPON-Use Local Controls'
              POP_LOOKUP[8] = 'PPON-Use Local Controls'
              POP_LOOKUP[9] = 'PPON-Use Local Controls'
              POP_LOOKUP[10] = 'PPON-Use Local Controls'
              POP_LOOKUP[11] = 'PPON-DVD Controls'
              POP_LOOKUP[12] = 'PPON-Use Local Controls'
              POP_LOOKUP[13] = 'PPON-Lamp Hours Reset'

              POP_LOOKUP[14] = 'PPON-PC Sources 5'
              POP_LOOKUP[15] = 'PPON-Video Sources 3'
              POP_LOOKUP[16] = 'PPON-Environment 2'
              POP_LOOKUP[17] = 'PPON-Utilities'
              POP_LOOKUP[18] = 'PPON-PC Sources 3'
              POP_LOOKUP[19] = 'PPON-PC Sources 2'
              POP_LOOKUP[20] = 'PPON-Lighting Controls'
              POP_LOOKUP[21] = 'PPON-Screen Controls'
              POP_LOOKUP[22] = 'PPON-Volume Controls'
              POP_LOOKUP[23] = 'PPON-Shutdown'
              POP_LOOKUP[24] = 'PPON-Projector Controls'
              POP_LOOKUP[25] = 'PAGE-Logo Page'
              POP_LOOKUP[26] = 'PPOF-Shutdown'
              POP_LOOKUP[27] = 'PPON-Protected Projector Controls'
              POP_LOOKUP[28] = 'PPON-Reset Lamp Hours'
              POP_LOOKUP[29] = ''
              POP_LOOKUP[30] = 'PAGE-Main Page 2'
              POP_LOOKUP[31] = 'PPON-EXTRON10'
              POP_LOOKUP[32] = ''
        }
        CASE 'SC 509A':
        {
              (* ROUTER TABLE *)
              LOOKUP[RACK_PC]     = 1
              LOOKUP[RACK_MAC]    = 2
              LOOKUP[RACK_LAP]    = 6
              LOOKUP[FB_LAP]      = 7       // REMOTE VGA
              LOOKUP[WB_LAP]      = 0
              LOOKUP[POD_LAP]     = 0
              LOOKUP[DOC_CAM]     = 0
              LOOKUP[VCR]         = 4
              LOOKUP[DVD]         = 3
              LOOKUP[RACK_VID]    = 5
              LOOKUP[FB_VID]      = 8      // REMOTE VID
              
              TXT_LOOKUP[LOOKUP[RACK_PC]] = 'RACK PC'
              TXT_LOOKUP[LOOKUP[RACK_MAC]] = 'RACK MAC'
              TXT_LOOKUP[LOOKUP[RACK_LAP]] = 'RACK LAPTOP'
              TXT_LOOKUP[LOOKUP[FB_LAP]] = 'REMOTE VGA'
              TXT_LOOKUP[LOOKUP[VCR]] = 'VCR CONTROLS'
              TXT_LOOKUP[LOOKUP[DVD]] = 'DVD CONTROLS'
              TXT_LOOKUP[LOOKUP[RACK_VID]] = 'RACK A / V'
              TXT_LOOKUP[LOOKUP[FB_VID]] = 'REMOTE A / V'
              TXT_LOOKUP[LOOKUP[POD_LAP]] = 'PODIUM LAPTOP'
              TXT_LOOKUP[LOOKUP[DOC_CAM]] = 'DOC CAM'
              TXT_LOOKUP[11] = '11'
              TXT_LOOKUP[12] = '12'

              POP_LOOKUP[1] = 'PPON-Use Local Controls'
              POP_LOOKUP[2] = 'PPON-Use Local Controls'
              POP_LOOKUP[3] = 'PPON-DVD Controls'
              POP_LOOKUP[4] = 'PPON-VCR Controls'
              POP_LOOKUP[5] = 'PPON-Use Local Controls'
              POP_LOOKUP[6] = 'PPON-Use Local Controls'
              POP_LOOKUP[7] = 'PPON-Use Local Controls'
              POP_LOOKUP[8] = 'PPON-Use Local Controls'
              POP_LOOKUP[9] = 'PPON-Use Local Controls'
              POP_LOOKUP[10] = 'PPON-Use Local Controls'
              POP_LOOKUP[11] = 'PPON-DVD Controls'
              POP_LOOKUP[12] = 'PPON-Use Local Controls'
              POP_LOOKUP[13] = 'PPON-Lamp Hours Reset'

              POP_LOOKUP[14] = 'PPON-PC Sources 8'
              POP_LOOKUP[15] = 'PPON-Video Sources 4'
              POP_LOOKUP[16] = 'PPON-Environment 2'
              POP_LOOKUP[17] = 'PPON-Utilities'
              POP_LOOKUP[18] = 'PPON-PC Sources 3'
              POP_LOOKUP[19] = 'PPON-PC Sources 2'
              POP_LOOKUP[20] = 'PPON-Lighting Controls'
              POP_LOOKUP[21] = 'PPON-Screen Controls'
              POP_LOOKUP[22] = 'PPON-Volume Controls'
              POP_LOOKUP[23] = 'PPON-Shutdown'
              POP_LOOKUP[24] = 'PPON-Projector Controls'
              POP_LOOKUP[25] = 'PAGE-Logo Page'
              POP_LOOKUP[26] = 'PPOF-Shutdown'
              POP_LOOKUP[27] = 'PPON-Protected Projector Controls'
              POP_LOOKUP[28] = 'PPON-Reset Lamp Hours'
              POP_LOOKUP[29] = ''
              POP_LOOKUP[30] = 'PAGE-Main Page 2'
              POP_LOOKUP[31] = 'PPON-EXTRON10'
              POP_LOOKUP[32] = ''
        }
        CASE 'JUDD 214':
        {
              (* ROUTER TABLE *)
              LOOKUP[RACK_PC]     = 1
              LOOKUP[RACK_MAC]    = 2
              LOOKUP[RACK_LAP]    = 6
              LOOKUP[FB_LAP]      = 7       // REMOTE VGA
              LOOKUP[WB_LAP]      = 0
              LOOKUP[POD_LAP]     = 0
              LOOKUP[DOC_CAM]     = 0
              LOOKUP[VCR]         = 4
              LOOKUP[DVD]         = 3
              LOOKUP[RACK_VID]    = 5
              LOOKUP[FB_VID]      = 8      // REMOTE VID
              
              TXT_LOOKUP[LOOKUP[RACK_PC]] = 'RACK PC'
              TXT_LOOKUP[LOOKUP[RACK_MAC]] = 'RACK MAC'
              TXT_LOOKUP[LOOKUP[RACK_LAP]] = 'RACK LAPTOP'
              TXT_LOOKUP[LOOKUP[FB_LAP]] = 'REMOTE VGA'
              TXT_LOOKUP[LOOKUP[VCR]] = 'VCR CONTROLS'
              TXT_LOOKUP[LOOKUP[DVD]] = 'DVD CONTROLS'
              TXT_LOOKUP[LOOKUP[RACK_VID]] = 'RACK A / V'
              TXT_LOOKUP[LOOKUP[FB_VID]] = 'REMOTE A / V'
              TXT_LOOKUP[LOOKUP[POD_LAP]] = 'PODIUM LAPTOP'
              TXT_LOOKUP[LOOKUP[DOC_CAM]] = 'DOC CAM'
              TXT_LOOKUP[11] = '11'
              TXT_LOOKUP[12] = '12'

              POP_LOOKUP[1] = 'PPON-Use Local Controls'
              POP_LOOKUP[2] = 'PPON-Use Local Controls'
              POP_LOOKUP[3] = 'PPON-DVD Controls'
              POP_LOOKUP[4] = 'PPON-VCR Controls'
              POP_LOOKUP[5] = 'PPON-Use Local Controls'
              POP_LOOKUP[6] = 'PPON-Use Local Controls'
              POP_LOOKUP[7] = 'PPON-Use Local Controls'
              POP_LOOKUP[8] = 'PPON-Use Local Controls'
              POP_LOOKUP[9] = 'PPON-Use Local Controls'
              POP_LOOKUP[10] = 'PPON-Use Local Controls'
              POP_LOOKUP[11] = 'PPON-DVD Controls'
              POP_LOOKUP[12] = 'PPON-Use Local Controls'
              POP_LOOKUP[13] = 'PPON-Lamp Hours Reset'

              POP_LOOKUP[14] = 'PPON-PC Sources 8'
              POP_LOOKUP[15] = 'PPON-Video Sources 4'
              POP_LOOKUP[16] = 'PPON-Environment 2'
              POP_LOOKUP[17] = 'PPON-Utilities'
              POP_LOOKUP[18] = 'PPON-PC Sources 3'
              POP_LOOKUP[19] = 'PPON-PC Sources 2'
              POP_LOOKUP[20] = 'PPON-Lighting Controls'
              POP_LOOKUP[21] = 'PPON-Screen Controls'
              POP_LOOKUP[22] = 'PPON-Volume Controls'
              POP_LOOKUP[23] = 'PPON-Shutdown'
              POP_LOOKUP[24] = 'PPON-Projector Controls'
              POP_LOOKUP[25] = 'PAGE-Logo Page'
              POP_LOOKUP[26] = 'PPOF-Shutdown'
              POP_LOOKUP[27] = 'PPON-Protected Projector Controls'
              POP_LOOKUP[28] = 'PPON-Reset Lamp Hours'
              POP_LOOKUP[29] = ''
              POP_LOOKUP[30] = 'PAGE-Main Page 2'
              POP_LOOKUP[31] = 'PPON-EXTRON10'
              POP_LOOKUP[32] = ''
        }
        CASE 'PAC 422':
        {
              (* ROUTER TABLE *)
              LOOKUP[RACK_PC]     = 1
              LOOKUP[RACK_MAC]    = 2
              LOOKUP[RACK_LAP]    = 0
              LOOKUP[FB_LAP]      = 6       // TABLE LAPTOP VGA
              LOOKUP[WB_LAP]      = 0
              LOOKUP[POD_LAP]     = 0
              LOOKUP[DOC_CAM]     = 7       
              LOOKUP[VCR]         = 4
              LOOKUP[DVD]         = 3
              LOOKUP[RACK_VID]    = 5
              LOOKUP[FB_VID]      = 8      // TABLE VID
              
              TXT_LOOKUP[LOOKUP[RACK_PC]] = 'RACK PC'
              TXT_LOOKUP[LOOKUP[RACK_MAC]] = 'RACK MAC'
              TXT_LOOKUP[LOOKUP[RACK_LAP]] = 'RACK LAPTOP'
              TXT_LOOKUP[LOOKUP[FB_LAP]] = 'TABLE LAPTOP'
              TXT_LOOKUP[LOOKUP[VCR]] = 'VCR CONTROLS'
              TXT_LOOKUP[LOOKUP[DVD]] = 'DVD CONTROLS'
              TXT_LOOKUP[LOOKUP[RACK_VID]] = 'RACK A / V'
              TXT_LOOKUP[LOOKUP[FB_VID]] = 'TABLE A / V'
              TXT_LOOKUP[LOOKUP[POD_LAP]] = 'PODIUM LAPTOP'
              TXT_LOOKUP[LOOKUP[DOC_CAM]] = 'DOC CAM'
              TXT_LOOKUP[11] = '11'
              TXT_LOOKUP[12] = '12'

              POP_LOOKUP[1] = 'PPON-Use Local Controls'
              POP_LOOKUP[2] = 'PPON-Use Local Controls'
              POP_LOOKUP[3] = 'PPON-DVD Controls'
              POP_LOOKUP[4] = 'PPON-VCR Controls'
              POP_LOOKUP[5] = 'PPON-Use Local Controls'
              POP_LOOKUP[6] = 'PPON-Use Local Controls'
              POP_LOOKUP[7] = 'PPON-Use Local Controls'
              POP_LOOKUP[8] = 'PPON-Use Local Controls'
              POP_LOOKUP[9] = 'PPON-Use Local Controls'
              POP_LOOKUP[10] = 'PPON-Use Local Controls'
              POP_LOOKUP[11] = 'PPON-DVD Controls'
              POP_LOOKUP[12] = 'PPON-Use Local Controls'
              POP_LOOKUP[13] = 'PPON-Lamp Hours Reset'

              POP_LOOKUP[14] = 'PPON-PC Sources 6'
              POP_LOOKUP[15] = 'PPON-Video Sources 7'
              POP_LOOKUP[16] = 'PPON-Environment 2'
              POP_LOOKUP[17] = 'PPON-Utilities'
              POP_LOOKUP[18] = 'PPON-PC Sources 3'
              POP_LOOKUP[19] = 'PPON-PC Sources 2'
              POP_LOOKUP[20] = 'PPON-Lighting Controls'
              POP_LOOKUP[21] = 'PPON-Screen Controls'
              POP_LOOKUP[22] = 'PPON-Volume Controls'
              POP_LOOKUP[23] = 'PPON-Shutdown'
              POP_LOOKUP[24] = 'PPON-Projector Controls'
              POP_LOOKUP[25] = 'PAGE-Logo Page'
              POP_LOOKUP[26] = 'PPOF-Shutdown'
              POP_LOOKUP[27] = 'PPON-Protected Projector Controls'
              POP_LOOKUP[28] = 'PPON-Reset Lamp Hours'
              POP_LOOKUP[29] = ''
              POP_LOOKUP[30] = 'PAGE-Main Page 2'
              POP_LOOKUP[31] = 'PPON-EXTRON10'
              POP_LOOKUP[32] = ''
        }
        CASE 'JUDD 113':
        {
              (* ROUTER TABLE *)
              LOOKUP[RACK_PC]     = 1
              LOOKUP[RACK_MAC]    = 2
              LOOKUP[RACK_LAP]    = 0
              LOOKUP[FB_LAP]      = 0
              LOOKUP[WB_LAP]      = 0
              LOOKUP[POD_LAP]     = 6
              LOOKUP[DOC_CAM]     = 7       
              LOOKUP[VCR]         = 4
              LOOKUP[DVD]         = 3
              LOOKUP[RACK_VID]    = 5
              LOOKUP[FB_VID]      = 8      // PODIUM VID
              
              TXT_LOOKUP[LOOKUP[RACK_PC]] = 'RACK PC'
              TXT_LOOKUP[LOOKUP[RACK_MAC]] = 'RACK MAC'
              TXT_LOOKUP[LOOKUP[RACK_LAP]] = 'RACK LAPTOP'
              TXT_LOOKUP[LOOKUP[FB_LAP]] = 'TABLE LAPTOP'
              TXT_LOOKUP[LOOKUP[VCR]] = 'VCR CONTROLS'
              TXT_LOOKUP[LOOKUP[DVD]] = 'DVD CONTROLS'
              TXT_LOOKUP[LOOKUP[RACK_VID]] = 'RACK A / V'
              TXT_LOOKUP[LOOKUP[FB_VID]] = 'PODIUM A / V'
              TXT_LOOKUP[LOOKUP[POD_LAP]] = 'PODIUM LAPTOP'
              TXT_LOOKUP[LOOKUP[DOC_CAM]] = 'DOC CAM'
              TXT_LOOKUP[11] = '11'
              TXT_LOOKUP[12] = '12'

              POP_LOOKUP[1] = 'PPON-Use Local Controls'
              POP_LOOKUP[2] = 'PPON-Use Local Controls'
              POP_LOOKUP[3] = 'PPON-DVD Controls'
              POP_LOOKUP[4] = 'PPON-VCR Controls'
              POP_LOOKUP[5] = 'PPON-Use Local Controls'
              POP_LOOKUP[6] = 'PPON-Use Local Controls'
              POP_LOOKUP[7] = 'PPON-Use Local Controls'
              POP_LOOKUP[8] = 'PPON-Use Local Controls'
              POP_LOOKUP[9] = 'PPON-Use Local Controls'
              POP_LOOKUP[10] = 'PPON-Use Local Controls'
              POP_LOOKUP[11] = 'PPON-DVD Controls'
              POP_LOOKUP[12] = 'PPON-Use Local Controls'
              POP_LOOKUP[13] = 'PPON-Lamp Hours Reset'

              POP_LOOKUP[14] = 'PPON-PC Sources 5'
              POP_LOOKUP[15] = 'PPON-Video Sources 3'
              POP_LOOKUP[16] = 'PPON-Environment 2'
              POP_LOOKUP[17] = 'PPON-Utilities'
              POP_LOOKUP[18] = 'PPON-PC Sources 3'
              POP_LOOKUP[19] = 'PPON-PC Sources 2'
              POP_LOOKUP[20] = 'PPON-Lighting Controls'
              POP_LOOKUP[21] = 'PPON-Screen Controls'
              POP_LOOKUP[22] = 'PPON-Volume Controls'
              POP_LOOKUP[23] = 'PPON-Shutdown'
              POP_LOOKUP[24] = 'PPON-Projector Controls'
              POP_LOOKUP[25] = 'PAGE-Logo Page'
              POP_LOOKUP[26] = 'PPOF-Shutdown'
              POP_LOOKUP[27] = 'PPON-Protected Projector Controls'
              POP_LOOKUP[28] = 'PPON-Reset Lamp Hours'
              POP_LOOKUP[29] = ''
              POP_LOOKUP[30] = 'PAGE-Main Page 2'
              POP_LOOKUP[31] = 'PPON-EXTRON10'
              POP_LOOKUP[32] = ''
        }
        CASE 'SC 109':
        {
              (* ROUTER TABLE *)
              LOOKUP[RACK_PC]     = 1
              LOOKUP[RACK_MAC]    = 2
              LOOKUP[RACK_LAP]    = 0
              LOOKUP[FB_LAP]      = 0
              LOOKUP[WB_LAP]      = 0
              LOOKUP[POD_LAP]     = 6
              LOOKUP[DOC_CAM]     = 7       
              LOOKUP[VCR]         = 4
              LOOKUP[DVD]         = 3
              LOOKUP[RACK_VID]    = 5
              LOOKUP[FB_VID]      = 8      // PODIUM VID
              
              TXT_LOOKUP[LOOKUP[RACK_PC]] = 'RACK PC'
              TXT_LOOKUP[LOOKUP[RACK_MAC]] = 'RACK MAC'
              TXT_LOOKUP[LOOKUP[RACK_LAP]] = 'RACK LAPTOP'
              TXT_LOOKUP[LOOKUP[FB_LAP]] = 'TABLE LAPTOP'
              TXT_LOOKUP[LOOKUP[VCR]] = 'VCR CONTROLS'
              TXT_LOOKUP[LOOKUP[DVD]] = 'DVD CONTROLS'
              TXT_LOOKUP[LOOKUP[RACK_VID]] = 'RACK A / V'
              TXT_LOOKUP[LOOKUP[FB_VID]] = 'PODIUM A / V'
              TXT_LOOKUP[LOOKUP[POD_LAP]] = 'PODIUM LAPTOP'
              TXT_LOOKUP[LOOKUP[DOC_CAM]] = 'DOC CAM'
              TXT_LOOKUP[11] = '11'
              TXT_LOOKUP[12] = '12'

              POP_LOOKUP[1] = 'PPON-Use Local Controls'
              POP_LOOKUP[2] = 'PPON-Use Local Controls'
              POP_LOOKUP[3] = 'PPON-DVD Controls'
              POP_LOOKUP[4] = 'PPON-VCR Controls'
              POP_LOOKUP[5] = 'PPON-Use Local Controls'
              POP_LOOKUP[6] = 'PPON-Use Local Controls'
              POP_LOOKUP[7] = 'PPON-Use Local Controls'
              POP_LOOKUP[8] = 'PPON-Use Local Controls'
              POP_LOOKUP[9] = 'PPON-Use Local Controls'
              POP_LOOKUP[10] = 'PPON-Use Local Controls'
              POP_LOOKUP[11] = 'PPON-DVD Controls'
              POP_LOOKUP[12] = 'PPON-Use Local Controls'
              POP_LOOKUP[13] = 'PPON-Lamp Hours Reset'

              POP_LOOKUP[14] = 'PPON-PC Sources 5'
              POP_LOOKUP[15] = 'PPON-Video Sources 3'
              POP_LOOKUP[16] = 'PPON-Environment 2'
              POP_LOOKUP[17] = 'PPON-Utilities'
              POP_LOOKUP[18] = 'PPON-PC Sources 3'
              POP_LOOKUP[19] = 'PPON-PC Sources 2'
              POP_LOOKUP[20] = 'PPON-Lighting Controls'
              POP_LOOKUP[21] = 'PPON-Screen Controls'
              POP_LOOKUP[22] = 'PPON-Volume Controls'
              POP_LOOKUP[23] = 'PPON-Shutdown'
              POP_LOOKUP[24] = 'PPON-Projector Controls'
              POP_LOOKUP[25] = 'PAGE-Logo Page'
              POP_LOOKUP[26] = 'PPOF-Shutdown'
              POP_LOOKUP[27] = 'PPON-Protected Projector Controls'
              POP_LOOKUP[28] = 'PPON-Reset Lamp Hours'
              POP_LOOKUP[29] = ''
              POP_LOOKUP[30] = 'PAGE-Main Page 2'
              POP_LOOKUP[31] = 'PPON-EXTRON10'
              POP_LOOKUP[32] = ''
        }
        CASE 'OLIN 327B':
        {
              (* ROUTER TABLE *)
              LOOKUP[RACK_PC]     = 1
              LOOKUP[RACK_MAC]    = 2
              LOOKUP[RACK_LAP]    = 0
              LOOKUP[FB_LAP]      = 6     // TABLE LAPTOP
              LOOKUP[WB_LAP]      = 0
              LOOKUP[POD_LAP]     = 0
              LOOKUP[DOC_CAM]     = 7       
              LOOKUP[VCR]         = 4
              LOOKUP[DVD]         = 3
              LOOKUP[RACK_VID]    = 5
              LOOKUP[FB_VID]      = 8      // TABLE VID
              LOOKUP[CASS]        = 9
              LOOKUP[TURNTABLE]   = 10
              
              TXT_LOOKUP[LOOKUP[RACK_PC]] = 'RACK PC'
              TXT_LOOKUP[LOOKUP[RACK_MAC]] = 'RACK MAC'
              TXT_LOOKUP[LOOKUP[RACK_LAP]] = 'RACK LAPTOP'
              TXT_LOOKUP[LOOKUP[FB_LAP]] = 'TABLE LAPTOP'
              TXT_LOOKUP[LOOKUP[VCR]] = 'VCR CONTROLS'
              TXT_LOOKUP[LOOKUP[DVD]] = 'DVD CONTROLS'
              TXT_LOOKUP[LOOKUP[RACK_VID]] = 'RACK A / V'
              TXT_LOOKUP[LOOKUP[FB_VID]] = 'TABLE A / V'
              TXT_LOOKUP[LOOKUP[POD_LAP]] = 'PODIUM LAPTOP'
              TXT_LOOKUP[LOOKUP[DOC_CAM]] = 'DOC CAM'
              TXT_LOOKUP[LOOKUP[CASS]] = 'CASSETTE'
              TXT_LOOKUP[LOOKUP[TURNTABLE]] = 'TURNTABLE'
              TXT_LOOKUP[11] = '11'
              TXT_LOOKUP[12] = '12'

              POP_LOOKUP[1] = 'PPON-Use Local Controls'
              POP_LOOKUP[2] = 'PPON-Use Local Controls'
              POP_LOOKUP[3] = 'PPON-DVD Controls'
              POP_LOOKUP[4] = 'PPON-VCR Controls'
              POP_LOOKUP[5] = 'PPON-Use Local Controls'
              POP_LOOKUP[6] = 'PPON-Use Local Controls'
              POP_LOOKUP[7] = 'PPON-Use Local Controls'
              POP_LOOKUP[8] = 'PPON-Use Local Controls'
              POP_LOOKUP[9] = 'PPON-Use Local Controls'
              POP_LOOKUP[10] = 'PPON-Use Local Controls'    
              POP_LOOKUP[11] = 'PPON-DVD Controls'
              POP_LOOKUP[12] = 'PPON-Use Local Controls'
              POP_LOOKUP[13] = 'PPON-Lamp Hours Reset'

              POP_LOOKUP[14] = 'PPON-PC Sources 6'
              POP_LOOKUP[15] = 'PPON-Video Sources 5'
              POP_LOOKUP[16] = 'PPON-Environment 2'
              POP_LOOKUP[17] = 'PPON-Utilities'
              POP_LOOKUP[18] = 'PPON-PC Sources 3'
              POP_LOOKUP[19] = 'PPON-PC Sources 2'
              POP_LOOKUP[20] = 'PPON-Lighting Controls'
              POP_LOOKUP[21] = 'PPON-Screen Controls'
              POP_LOOKUP[22] = 'PPON-Volume Controls'
              POP_LOOKUP[23] = 'PPON-Shutdown'
              POP_LOOKUP[24] = 'PPON-Projector Controls'
              POP_LOOKUP[25] = 'PAGE-Logo Page'
              POP_LOOKUP[26] = 'PPOF-Shutdown'
              POP_LOOKUP[27] = 'PPON-Protected Projector Controls'
              POP_LOOKUP[28] = 'PPON-Reset Lamp Hours'
              POP_LOOKUP[29] = ''
              POP_LOOKUP[30] = 'PAGE-Main Page 2'
              POP_LOOKUP[31] = 'PPON-EXTRON10'
              POP_LOOKUP[32] = ''
        } 
        CASE 'RH 003':
        {
              (* ROUTER TABLE *)
              LOOKUP[RACK_PC]     = 1
              LOOKUP[RACK_MAC]    = 2
              LOOKUP[RACK_LAP]    = 0
              LOOKUP[FB_LAP]      = 6     // REMOTE LAPTOP
              LOOKUP[WB_LAP]      = 0
              LOOKUP[POD_LAP]     = 0
              LOOKUP[DOC_CAM]     = 7       
              LOOKUP[VCR]         = 4
              LOOKUP[DVD]         = 3
              LOOKUP[RACK_VID]    = 5
              LOOKUP[FB_VID]      = 8      // REMOTE VID
              LOOKUP[CASS]        = 9      // TEAC PAD 500
              LOOKUP[TURNTABLE]   = 0
              
              TXT_LOOKUP[LOOKUP[RACK_PC]] = 'RACK PC'
              TXT_LOOKUP[LOOKUP[RACK_MAC]] = 'RACK MAC'
              TXT_LOOKUP[LOOKUP[RACK_LAP]] = 'RACK LAPTOP'
              TXT_LOOKUP[LOOKUP[FB_LAP]] = 'REMOTE LAPTOP'
              TXT_LOOKUP[LOOKUP[VCR]] = 'VCR CONTROLS'
              TXT_LOOKUP[LOOKUP[DVD]] = 'DVD CONTROLS'
              TXT_LOOKUP[LOOKUP[RACK_VID]] = 'RACK A / V'
              TXT_LOOKUP[LOOKUP[FB_VID]] = 'REMOTE A / V'
              TXT_LOOKUP[LOOKUP[POD_LAP]] = 'PODIUM LAPTOP'
              TXT_LOOKUP[LOOKUP[DOC_CAM]] = 'DOC CAM'
              TXT_LOOKUP[LOOKUP[CASS]] = 'CASSETTE'         // MAY BE A CD/CAS COMBO?? WAITING FOR ANSWER
              TXT_LOOKUP[LOOKUP[TURNTABLE]] = 'TURNTABLE'
              TXT_LOOKUP[11] = '11'
              TXT_LOOKUP[12] = '12'

              POP_LOOKUP[1] = 'PPON-Use Local Controls'
              POP_LOOKUP[2] = 'PPON-Use Local Controls'
              POP_LOOKUP[3] = 'PPON-DVD Controls'
              POP_LOOKUP[4] = 'PPON-VCR Controls'
              POP_LOOKUP[5] = 'PPON-Use Local Controls'
              POP_LOOKUP[6] = 'PPON-Use Local Controls'
              POP_LOOKUP[7] = 'PPON-Use Local Controls'
              POP_LOOKUP[8] = 'PPON-Use Local Controls'
              POP_LOOKUP[9] = 'PPON-Use Local Controls'
              POP_LOOKUP[10] = 'PPON-Use Local Controls'    
              POP_LOOKUP[11] = 'PPON-DVD Controls'
              POP_LOOKUP[12] = 'PPON-Use Local Controls'
              POP_LOOKUP[13] = 'PPON-Lamp Hours Reset'

              POP_LOOKUP[14] = 'PPON-PC Sources 7'
              POP_LOOKUP[15] = 'PPON-Video Sources 6'
              POP_LOOKUP[16] = 'PPON-Environment 2'
              POP_LOOKUP[17] = 'PPON-Utilities'
              POP_LOOKUP[18] = 'PPON-PC Sources 3'
              POP_LOOKUP[19] = 'PPON-PC Sources 2'
              POP_LOOKUP[20] = 'PPON-Lighting Controls'
              POP_LOOKUP[21] = 'PPON-Screen Controls'
              POP_LOOKUP[22] = 'PPON-Volume Controls'
              POP_LOOKUP[23] = 'PPON-Shutdown'
              POP_LOOKUP[24] = 'PPON-Projector Controls'
              POP_LOOKUP[25] = 'PAGE-Logo Page'
              POP_LOOKUP[26] = 'PPOF-Shutdown'
              POP_LOOKUP[27] = 'PPON-Protected Projector Controls'
              POP_LOOKUP[28] = 'PPON-Reset Lamp Hours'
              POP_LOOKUP[29] = ''
              POP_LOOKUP[30] = 'PAGE-Main Page 2'
              POP_LOOKUP[31] = 'PPON-EXTRON10'
              POP_LOOKUP[32] = ''
        }  
        CASE 'DAC 300':
        {
              (* ROUTER TABLE *)
              LOOKUP[RACK_PC]     = 1
              LOOKUP[RACK_MAC]    = 2
              LOOKUP[RACK_LAP]    = 0
              LOOKUP[FB_LAP]      = 6       // TABLE LAPTOP VGA
              LOOKUP[WB_LAP]      = 0
              LOOKUP[POD_LAP]     = 0
              LOOKUP[DOC_CAM]     = 7       
              LOOKUP[VCR]         = 4
              LOOKUP[DVD]         = 3
              LOOKUP[RACK_VID]    = 5
              LOOKUP[FB_VID]      = 8      // TABLE VID
              
              TXT_LOOKUP[LOOKUP[RACK_PC]] = 'RACK PC'
              TXT_LOOKUP[LOOKUP[RACK_MAC]] = 'RACK MAC'
              TXT_LOOKUP[LOOKUP[RACK_LAP]] = 'RACK LAPTOP'
              TXT_LOOKUP[LOOKUP[FB_LAP]] = 'TABLE LAPTOP'
              TXT_LOOKUP[LOOKUP[VCR]] = 'VCR CONTROLS'
              TXT_LOOKUP[LOOKUP[DVD]] = 'DVD CONTROLS'
              TXT_LOOKUP[LOOKUP[RACK_VID]] = 'RACK A / V'
              TXT_LOOKUP[LOOKUP[FB_VID]] = 'TABLE  A / V'
              TXT_LOOKUP[LOOKUP[POD_LAP]] = 'PODIUM LAPTOP'
              TXT_LOOKUP[LOOKUP[DOC_CAM]] = 'DOC CAM'
              TXT_LOOKUP[11] = '11'
              TXT_LOOKUP[12] = '12'

              POP_LOOKUP[1] = 'PPON-Use Local Controls'
              POP_LOOKUP[2] = 'PPON-Use Local Controls'
              POP_LOOKUP[3] = 'PPON-DVD Controls'
              POP_LOOKUP[4] = 'PPON-VCR Controls'
              POP_LOOKUP[5] = 'PPON-Use Local Controls'
              POP_LOOKUP[6] = 'PPON-Use Local Controls'
              POP_LOOKUP[7] = 'PPON-Use Local Controls'
              POP_LOOKUP[8] = 'PPON-Use Local Controls'
              POP_LOOKUP[9] = 'PPON-Use Local Controls'
              POP_LOOKUP[10] = 'PPON-Use Local Controls'
              POP_LOOKUP[11] = 'PPON-DVD Controls'
              POP_LOOKUP[12] = 'PPON-Use Local Controls'
              POP_LOOKUP[13] = 'PPON-Lamp Hours Reset'

              POP_LOOKUP[14] = 'PPON-PC Sources 6'
              POP_LOOKUP[15] = 'PPON-Video Sources 7'
              POP_LOOKUP[16] = 'PPON-Environment 2'
              POP_LOOKUP[17] = 'PPON-Utilities'
              POP_LOOKUP[18] = 'PPON-PC Sources 3'
              POP_LOOKUP[19] = 'PPON-PC Sources 2'
              POP_LOOKUP[20] = 'PPON-Lighting Controls'
              POP_LOOKUP[21] = 'PPON-Screen Controls'
              POP_LOOKUP[22] = 'PPON-Volume Controls'
              POP_LOOKUP[23] = 'PPON-Shutdown'
              POP_LOOKUP[24] = 'PPON-Projector Controls'
              POP_LOOKUP[25] = 'PAGE-Logo Page'
              POP_LOOKUP[26] = 'PPOF-Shutdown'
              POP_LOOKUP[27] = 'PPON-Protected Projector Controls'
              POP_LOOKUP[28] = 'PPON-Reset Lamp Hours'
              POP_LOOKUP[29] = ''
              POP_LOOKUP[30] = 'PAGE-Main Page 2'
              POP_LOOKUP[31] = 'PPON-EXTRON10'
              POP_LOOKUP[32] = ''
        }   
        CASE 'MS 301':
        {
              (* ROUTER TABLE *)
              LOOKUP[RACK_PC]     = 1
              LOOKUP[RACK_MAC]    = 2
              LOOKUP[RACK_LAP]    = 0
              LOOKUP[FB_LAP]      = 6       // REMOTE VGA
              LOOKUP[WB_LAP]      = 0
              LOOKUP[POD_LAP]     = 0
              LOOKUP[DOC_CAM]     = 7
              LOOKUP[VCR]         = 4
              LOOKUP[DVD]         = 3
              LOOKUP[RACK_VID]    = 5
              LOOKUP[FB_VID]      = 8      // REMOTE VID
              
              TXT_LOOKUP[LOOKUP[RACK_PC]] = 'RACK PC'
              TXT_LOOKUP[LOOKUP[RACK_MAC]] = 'RACK MAC'
              TXT_LOOKUP[LOOKUP[RACK_LAP]] = 'RACK LAPTOP'
              TXT_LOOKUP[LOOKUP[FB_LAP]] = 'REMOTE - VGA'
              TXT_LOOKUP[LOOKUP[VCR]] = 'VCR CONTROLS'
              TXT_LOOKUP[LOOKUP[DVD]] = 'DVD CONTROLS'
              TXT_LOOKUP[LOOKUP[RACK_VID]] = 'RACK A / V'
              TXT_LOOKUP[LOOKUP[FB_VID]] = 'REMOTE A / V'
              TXT_LOOKUP[LOOKUP[POD_LAP]] = 'PODIUM LAPTOP'
              TXT_LOOKUP[LOOKUP[DOC_CAM]] = 'DOC CAM'
              TXT_LOOKUP[11] = '11'
              TXT_LOOKUP[12] = '12'

              POP_LOOKUP[1] = 'PPON-Use Local Controls'
              POP_LOOKUP[2] = 'PPON-Use Local Controls'
              POP_LOOKUP[3] = 'PPON-DVD Controls'
              POP_LOOKUP[4] = 'PPON-VCR Controls'
              POP_LOOKUP[5] = 'PPON-Use Local Controls'
              POP_LOOKUP[6] = 'PPON-Use Local Controls'
              POP_LOOKUP[7] = 'PPON-Use Local Controls'
              POP_LOOKUP[8] = 'PPON-Use Local Controls'
              POP_LOOKUP[9] = 'PPON-Use Local Controls'
              POP_LOOKUP[10] = 'PPON-Use Local Controls'
              POP_LOOKUP[11] = 'PPON-DVD Controls'
              POP_LOOKUP[12] = 'PPON-Use Local Controls'
              POP_LOOKUP[13] = 'PPON-Lamp Hours Reset'

              POP_LOOKUP[14] = 'PPON-PC Sources 7'
              POP_LOOKUP[15] = 'PPON-Video Sources 4'
              POP_LOOKUP[16] = 'PPON-Environment 2'
              POP_LOOKUP[17] = 'PPON-Utilities'
              POP_LOOKUP[18] = 'PPON-PC Sources 3'
              POP_LOOKUP[19] = 'PPON-PC Sources 2'
              POP_LOOKUP[20] = 'PPON-Lighting Controls'
              POP_LOOKUP[21] = 'PPON-Screen Controls'
              POP_LOOKUP[22] = 'PPON-Volume Controls'
              POP_LOOKUP[23] = 'PPON-Shutdown'
              POP_LOOKUP[24] = 'PPON-Projector Controls'
              POP_LOOKUP[25] = 'PAGE-Logo Page'
              POP_LOOKUP[26] = 'PPOF-Shutdown'
              POP_LOOKUP[27] = 'PPON-Protected Projector Controls'
              POP_LOOKUP[28] = 'PPON-Reset Lamp Hours'
              POP_LOOKUP[29] = ''
              POP_LOOKUP[30] = 'PAGE-Main Page 2'
              POP_LOOKUP[31] = 'PPON-EXTRON10'
              POP_LOOKUP[32] = ''
        }
        CASE 'ANTHRO 6MM':
        {
              (* ROUTER TABLE *)
              LOOKUP[RACK_PC]     = 1
              LOOKUP[RACK_MAC]    = 2
              LOOKUP[DVD]         = 3
              LOOKUP[VCR]         = 4
              LOOKUP[VCR_CC]      = 5  // CC FROM VCR
              LOOKUP[RACK_LAP]    = 6  // RACK VGA
              LOOKUP[RACK_VID]    = 7
              LOOKUP[FB_LAP]      = 8
              LOOKUP[FB_VID]      = 9
              LOOKUP[DOC_CAM]     = 10

              TXT_LOOKUP[LOOKUP[RACK_PC]] = 'RACK PC'
              TXT_LOOKUP[LOOKUP[RACK_MAC]] = 'RACK MAC'
              TXT_LOOKUP[LOOKUP[RACK_LAP]] = 'RACK - VGA'
              TXT_LOOKUP[LOOKUP[FB_LAP]] = 'REMOTE - VGA'
              TXT_LOOKUP[LOOKUP[VCR]] = 'VCR CONTROLS'
              TXT_LOOKUP[LOOKUP[DVD]] = 'DVD CONTROLS'
              TXT_LOOKUP[LOOKUP[RACK_VID]] = 'RACK A / V'
              TXT_LOOKUP[LOOKUP[FB_VID]] = 'REMOTE A / V'
              TXT_LOOKUP[LOOKUP[VCR_CC]] = 'VCR CONTROLS w/CC'
              TXT_LOOKUP[LOOKUP[DOC_CAM]] = 'DOC CAM'
              TXT_LOOKUP[11] = '11'
              TXT_LOOKUP[12] = '12'

              POP_LOOKUP[1] = 'PPON-Use Local Controls'
              POP_LOOKUP[2] = 'PPON-Use Local Controls'
              POP_LOOKUP[3] = 'PPON-DVD Controls'
              POP_LOOKUP[4] = 'PPON-VCR Controls'
              POP_LOOKUP[5] = 'PPON-VCR Controls'
              POP_LOOKUP[6] = 'PPON-Use Local Controls'
              POP_LOOKUP[7] = 'PPON-Use Local Controls'
              POP_LOOKUP[8] = 'PPON-Use Local Controls'
              POP_LOOKUP[9] = 'PPON-Use Local Controls'
              POP_LOOKUP[10] = 'PPON-Use Local Controls'
              POP_LOOKUP[11] = 'PPON-Use Local Controls'
              POP_LOOKUP[12] = 'PPON-Use Local Controls'
              POP_LOOKUP[13] = 'PPON-Lamp Hours Reset'

              POP_LOOKUP[14] = 'PPON-PC Sources 9'
              POP_LOOKUP[15] = 'PPON-Video Sources 8'
              POP_LOOKUP[16] = 'PPON-Environment'
              POP_LOOKUP[17] = 'PPON-Utilities'
              POP_LOOKUP[18] = 'PPON-PC Sources 9'
              POP_LOOKUP[19] = 'PPON-PC Sources 2'
              POP_LOOKUP[20] = 'PPON-Lighting Controls'
              POP_LOOKUP[21] = 'PPON-Screen Controls'
              POP_LOOKUP[22] = 'PPON-Volume Controls'
              POP_LOOKUP[23] = 'PPON-Shutdown'
              POP_LOOKUP[24] = 'PPON-Projector Controls'
              POP_LOOKUP[25] = 'PAGE-Logo Page'
              POP_LOOKUP[26] = 'PPOF-Shutdown'
              POP_LOOKUP[27] = 'PPON-Protected Projector Controls'
              POP_LOOKUP[28] = 'PPON-Reset Lamp Hours'
              POP_LOOKUP[29] = ''
              POP_LOOKUP[30] = 'PAGE-Main Page'
              POP_LOOKUP[31] = 'PPON-EXTRON10'
              POP_LOOKUP[32] = ''
              
        }
        CASE 'EAC MF+':
        {
              (* ROUTER TABLE *)
              LOOKUP[RACK_PC]     = 1
              LOOKUP[RACK_MAC]    = 2
              LOOKUP[DVD]         = 3
              LOOKUP[VCR]         = 4
              LOOKUP[VCR_CC]      = 5  // CC FROM VCR
              LOOKUP[RACK_LAP]    = 6  // RACK VGA
              LOOKUP[RACK_VID]    = 7
              LOOKUP[FB_LAP]      = 8
              LOOKUP[FB_VID]      = 9
              LOOKUP[DOC_CAM]     = 10

              TXT_LOOKUP[LOOKUP[RACK_PC]] = 'RACK PC'
              TXT_LOOKUP[LOOKUP[RACK_MAC]] = 'RACK MAC'
              TXT_LOOKUP[LOOKUP[RACK_LAP]] = 'RACK - VGA'
              TXT_LOOKUP[LOOKUP[FB_LAP]] = 'REMOTE - VGA'
              TXT_LOOKUP[LOOKUP[VCR]] = 'VCR CONTROLS'
              TXT_LOOKUP[LOOKUP[DVD]] = 'DVD CONTROLS'
              TXT_LOOKUP[LOOKUP[RACK_VID]] = 'RACK A / V'
              TXT_LOOKUP[LOOKUP[FB_VID]] = 'REMOTE A / V'
              TXT_LOOKUP[LOOKUP[VCR_CC]] = 'VCR CONTROLS w/CC'
              TXT_LOOKUP[LOOKUP[DOC_CAM]] = 'DOC CAM'
              TXT_LOOKUP[11] = '11'
              TXT_LOOKUP[12] = '12'

              POP_LOOKUP[1] = 'PPON-Use Local Controls'
              POP_LOOKUP[2] = 'PPON-Use Local Controls'
              POP_LOOKUP[3] = 'PPON-DVD Controls'
              POP_LOOKUP[4] = 'PPON-VCR Controls'
              POP_LOOKUP[5] = 'PPON-VCR Controls'
              POP_LOOKUP[6] = 'PPON-Use Local Controls'
              POP_LOOKUP[7] = 'PPON-Use Local Controls'
              POP_LOOKUP[8] = 'PPON-Use Local Controls'
              POP_LOOKUP[9] = 'PPON-Use Local Controls'
              POP_LOOKUP[10] = 'PPON-Use Local Controls'
              POP_LOOKUP[11] = 'PPON-Use Local Controls'
              POP_LOOKUP[12] = 'PPON-Use Local Controls'
              POP_LOOKUP[13] = 'PPON-Lamp Hours Reset'

              POP_LOOKUP[14] = 'PPON-PC Sources 10'
              POP_LOOKUP[15] = 'PPON-Video Sources 9'
              POP_LOOKUP[16] = 'PPON-Environment 2'
              POP_LOOKUP[17] = 'PPON-Utilities'
              POP_LOOKUP[18] = 'PPON-PC Sources 9'
              POP_LOOKUP[19] = 'PPON-PC Sources 2'
              POP_LOOKUP[20] = 'PPON-Lighting Controls'
              POP_LOOKUP[21] = 'PPON-Screen Controls'
              POP_LOOKUP[22] = 'PPON-Volume Controls'
              POP_LOOKUP[23] = 'PPON-Shutdown'
              POP_LOOKUP[24] = 'PPON-Projector Controls'
              POP_LOOKUP[25] = 'PAGE-Logo Page'
              POP_LOOKUP[26] = 'PPOF-Shutdown'
              POP_LOOKUP[27] = 'PPON-Protected Projector Controls'
              POP_LOOKUP[28] = 'PPON-Reset Lamp Hours'
              POP_LOOKUP[29] = ''
              POP_LOOKUP[30] = 'PAGE-Main Page 2'
              POP_LOOKUP[31] = 'PPON-EXTRON10'
              POP_LOOKUP[32] = ''
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
              (* ROUTER TABLE *)
              LOOKUP[RACK_PC]     = 1
              LOOKUP[RACK_MAC]    = 2
              LOOKUP[DVD]         = 3
              LOOKUP[VCR]         = 4
              LOOKUP[VCR_CC]      = 5  // CC FROM VCR
              LOOKUP[RACK_LAP]    = 6  // RACK VGA
              LOOKUP[RACK_VID]    = 7
              LOOKUP[FB_LAP]      = 8
              LOOKUP[FB_VID]      = 9
              LOOKUP[DOC_CAM]     = 10

              TXT_LOOKUP[LOOKUP[RACK_PC]] = 'RACK PC'
              TXT_LOOKUP[LOOKUP[RACK_MAC]] = 'RACK MAC'
              TXT_LOOKUP[LOOKUP[RACK_LAP]] = 'RACK - VGA'
              TXT_LOOKUP[LOOKUP[FB_LAP]] = 'REMOTE - VGA'
              TXT_LOOKUP[LOOKUP[VCR]] = 'VCR CONTROLS'
              TXT_LOOKUP[LOOKUP[DVD]] = 'DVD CONTROLS'
              TXT_LOOKUP[LOOKUP[RACK_VID]] = 'RACK A / V'
              TXT_LOOKUP[LOOKUP[FB_VID]] = 'REMOTE A / V'
              TXT_LOOKUP[LOOKUP[VCR_CC]] = 'VCR CONTROLS w/CC'
              TXT_LOOKUP[LOOKUP[DOC_CAM]] = 'DOC CAM'
              TXT_LOOKUP[11] = '11'
              TXT_LOOKUP[12] = '12'

              POP_LOOKUP[1] = 'PPON-Use Local Controls'
              POP_LOOKUP[2] = 'PPON-Use Local Controls'
              POP_LOOKUP[3] = 'PPON-DVD Controls'
              POP_LOOKUP[4] = 'PPON-VCR Controls'
              POP_LOOKUP[5] = 'PPON-VCR Controls'
              POP_LOOKUP[6] = 'PPON-Use Local Controls'
              POP_LOOKUP[7] = 'PPON-Use Local Controls'
              POP_LOOKUP[8] = 'PPON-Use Local Controls'
              POP_LOOKUP[9] = 'PPON-Use Local Controls'
              POP_LOOKUP[10] = 'PPON-Use Local Controls'
              POP_LOOKUP[11] = 'PPON-Use Local Controls'
              POP_LOOKUP[12] = 'PPON-Use Local Controls'
              POP_LOOKUP[13] = 'PPON-Lamp Hours Reset'

              POP_LOOKUP[14] = 'PPON-PC Sources 10'
              POP_LOOKUP[15] = 'PPON-Video Sources 9'
              POP_LOOKUP[16] = 'PPON-Environment'
              POP_LOOKUP[17] = 'PPON-Utilities'
              POP_LOOKUP[18] = 'PPON-PC Sources 3'
              POP_LOOKUP[19] = 'PPON-PC Sources 2'
              POP_LOOKUP[20] = 'PPON-Lighting Controls'
              POP_LOOKUP[21] = 'PPON-Screen Controls'
              POP_LOOKUP[22] = 'PPON-Volume Controls'
              POP_LOOKUP[23] = 'PPON-Shutdown'
              POP_LOOKUP[24] = 'PPON-Projector Controls'
              POP_LOOKUP[25] = 'PAGE-Logo Page'
              POP_LOOKUP[26] = 'PPOF-Shutdown'
              POP_LOOKUP[27] = 'PPON-Protected Projector Controls'
              POP_LOOKUP[28] = 'PPON-Reset Lamp Hours'
              POP_LOOKUP[29] = ''
              POP_LOOKUP[30] = 'PAGE-Main Page'
              POP_LOOKUP[31] = 'PPON-EXTRON10'
              POP_LOOKUP[32] = ''
        }
        CASE 'SC 121':
        {
              (* ROUTER TABLE *)
              LOOKUP[RACK_PC]     = 1
              LOOKUP[RACK_MAC]    = 2
              LOOKUP[DVD]         = 3
              LOOKUP[VCR]         = 4
              LOOKUP[VCR_CC]      = 5  // CC FROM VCR
              LOOKUP[RACK_LAP]    = 6  // RACK VGA
              LOOKUP[RACK_VID]    = 7
              LOOKUP[FB_LAP]      = 8
              LOOKUP[FB_VID]      = 9
              //LOOKUP[DOC_CAM]     = 10

              TXT_LOOKUP[LOOKUP[RACK_PC]] = 'RACK PC'
              TXT_LOOKUP[LOOKUP[RACK_MAC]] = 'RACK MAC'
              TXT_LOOKUP[LOOKUP[RACK_LAP]] = 'RACK - VGA'
              TXT_LOOKUP[LOOKUP[FB_LAP]] = 'REMOTE - VGA'
              TXT_LOOKUP[LOOKUP[VCR]] = 'VCR CONTROLS'
              TXT_LOOKUP[LOOKUP[DVD]] = 'DVD CONTROLS'
              TXT_LOOKUP[LOOKUP[RACK_VID]] = 'LASER DISK'
              TXT_LOOKUP[LOOKUP[FB_VID]] = 'REMOTE A / V'
              TXT_LOOKUP[LOOKUP[VCR_CC]] = 'VCR CONTROLS w/CC'
              TXT_LOOKUP[LOOKUP[DOC_CAM]] = 'DOC CAM'
              TXT_LOOKUP[LOOKUP[RACK_LD]] = 'LASER DISK'
              TXT_LOOKUP[11] = '11'
              TXT_LOOKUP[12] = '12'

              POP_LOOKUP[1] = 'PPON-Use Local Controls'
              POP_LOOKUP[2] = 'PPON-Use Local Controls'
              POP_LOOKUP[3] = 'PPON-DVD Controls'
              POP_LOOKUP[4] = 'PPON-VCR Controls'
              POP_LOOKUP[5] = 'PPON-VCR Controls'
              POP_LOOKUP[6] = 'PPON-Use Local Controls'
              POP_LOOKUP[7] = 'PPON-Use Local Controls'
              POP_LOOKUP[8] = 'PPON-Use Local Controls'
              POP_LOOKUP[9] = 'PPON-Use Local Controls'
              POP_LOOKUP[10] = 'PPON-Use Local Controls'
              POP_LOOKUP[11] = 'PPON-Use Local Controls'
              POP_LOOKUP[12] = 'PPON-Use Local Controls'
              POP_LOOKUP[13] = 'PPON-Lamp Hours Reset'

              POP_LOOKUP[14] = 'PPON-PC Sources 11'
              POP_LOOKUP[15] = 'PPON-Video Sources 11'
              POP_LOOKUP[16] = 'PPON-Environment'
              POP_LOOKUP[17] = 'PPON-Utilities'
              POP_LOOKUP[18] = 'PPON-PC Sources 9'
              POP_LOOKUP[19] = 'PPON-PC Sources 2'
              POP_LOOKUP[20] = 'PPON-Lighting Controls'
              POP_LOOKUP[21] = 'PPON-Screen Controls'
              POP_LOOKUP[22] = 'PPON-Volume Controls'
              POP_LOOKUP[23] = 'PPON-Shutdown'
              POP_LOOKUP[24] = 'PPON-Projector Controls'
              POP_LOOKUP[25] = 'PAGE-Logo Page'
              POP_LOOKUP[26] = 'PPOF-Shutdown'
              POP_LOOKUP[27] = 'PPON-Protected Projector Controls'
              POP_LOOKUP[28] = 'PPON-Reset Lamp Hours'
              POP_LOOKUP[29] = ''
              POP_LOOKUP[30] = 'PAGE-Main Page'
              POP_LOOKUP[31] = 'PPON-EXTRON10'
              POP_LOOKUP[32] = ''
              
        }       
        CASE 'FISK 115':
        {
              (* ROUTER TABLE *)
              LOOKUP[RACK_PC]     = 1
              LOOKUP[RACK_MAC]    = 2
              LOOKUP[DVD]         = 3
              LOOKUP[VCR]         = 4
              LOOKUP[VCR_CC]      = 5  // CC FROM VCR
              LOOKUP[RACK_LAP]    = 6  // RACK VGA
              LOOKUP[RACK_VID]    = 7
              //LOOKUP[FB_LAP]      = 8
              //LOOKUP[FB_VID]      = 9
              //LOOKUP[DOC_CAM]     = 10

              TXT_LOOKUP[LOOKUP[RACK_PC]] = 'RACK PC'
              TXT_LOOKUP[LOOKUP[RACK_MAC]] = 'RACK MAC'
              TXT_LOOKUP[LOOKUP[RACK_LAP]] = 'RACK - VGA'
              TXT_LOOKUP[LOOKUP[FB_LAP]] = 'REMOTE - VGA'
              TXT_LOOKUP[LOOKUP[VCR]] = 'VCR CONTROLS'
              TXT_LOOKUP[LOOKUP[DVD]] = 'DVD CONTROLS'
              TXT_LOOKUP[LOOKUP[RACK_VID]] = 'RACK A / V'
              TXT_LOOKUP[LOOKUP[FB_VID]] = 'REMOTE A / V'
              TXT_LOOKUP[LOOKUP[VCR_CC]] = 'VCR CONTROLS w/CC'
              TXT_LOOKUP[LOOKUP[DOC_CAM]] = 'DOC CAM'
              TXT_LOOKUP[LOOKUP[RACK_LD]] = 'LASER DISK'
              TXT_LOOKUP[11] = '11'
              TXT_LOOKUP[12] = '12'

              POP_LOOKUP[1] = 'PPON-Use Local Controls'
              POP_LOOKUP[2] = 'PPON-Use Local Controls'
              POP_LOOKUP[3] = 'PPON-DVD Controls'
              POP_LOOKUP[4] = 'PPON-VCR Controls'
              POP_LOOKUP[5] = 'PPON-VCR Controls'
              POP_LOOKUP[6] = 'PPON-Use Local Controls'
              POP_LOOKUP[7] = 'PPON-Use Local Controls'
              POP_LOOKUP[8] = 'PPON-Use Local Controls'
              POP_LOOKUP[9] = 'PPON-Use Local Controls'
              POP_LOOKUP[10] = 'PPON-Use Local Controls'
              POP_LOOKUP[11] = 'PPON-Use Local Controls'
              POP_LOOKUP[12] = 'PPON-Use Local Controls'
              POP_LOOKUP[13] = 'PPON-Lamp Hours Reset'

              POP_LOOKUP[14] = 'PPON-PC Sources 12'
              POP_LOOKUP[15] = 'PPON-Video Sources 10'
              POP_LOOKUP[16] = 'PPON-Environment'
              POP_LOOKUP[17] = 'PPON-Utilities'
              POP_LOOKUP[18] = 'PPON-PC Sources 9'
              POP_LOOKUP[19] = 'PPON-PC Sources 2'
              POP_LOOKUP[20] = 'PPON-Lighting Controls'
              POP_LOOKUP[21] = 'PPON-Screen Controls'
              POP_LOOKUP[22] = 'PPON-Volume Controls'
              POP_LOOKUP[23] = 'PPON-Shutdown'
              POP_LOOKUP[24] = 'PPON-Projector Controls'
              POP_LOOKUP[25] = 'PAGE-Logo Page'
              POP_LOOKUP[26] = 'PPOF-Shutdown'
              POP_LOOKUP[27] = 'PPON-Protected Projector Controls'
              POP_LOOKUP[28] = 'PPON-Reset Lamp Hours'
              POP_LOOKUP[29] = ''
              POP_LOOKUP[30] = 'PAGE-Main Page'
              POP_LOOKUP[31] = 'PPON-EXTRON10'
              POP_LOOKUP[32] = ''
              
        }
        CASE 'SC 309':
        {
              (* ROUTER TABLE *)
              LOOKUP[RACK_PC]     = 1
              LOOKUP[RACK_MAC]    = 2
              LOOKUP[DVD]         = 3
              LOOKUP[VCR]         = 4
              LOOKUP[VCR_CC]      = 5  // CC FROM VCR
              LOOKUP[RACK_LAP]    = 6  // RACK VGA
              LOOKUP[RACK_VID]    = 7
              LOOKUP[FB_LAP]      = 8
              LOOKUP[FB_VID]      = 9
              LOOKUP[DOC_CAM]     = 10

              TXT_LOOKUP[LOOKUP[RACK_PC]] = 'RACK PC'
              TXT_LOOKUP[LOOKUP[RACK_MAC]] = 'RACK MAC'
              TXT_LOOKUP[LOOKUP[RACK_LAP]] = 'RACK - VGA'
              TXT_LOOKUP[LOOKUP[FB_LAP]] = 'REMOTE - VGA'
              TXT_LOOKUP[LOOKUP[VCR]] = 'VCR CONTROLS'
              TXT_LOOKUP[LOOKUP[DVD]] = 'DVD CONTROLS'
              TXT_LOOKUP[LOOKUP[RACK_VID]] = 'RACK A / V'
              TXT_LOOKUP[LOOKUP[FB_VID]] = 'REMOTE A / V'
              TXT_LOOKUP[LOOKUP[VCR_CC]] = 'VCR CONTROLS w/CC'
              TXT_LOOKUP[LOOKUP[DOC_CAM]] = 'DOC CAM'
              TXT_LOOKUP[11] = '11'
              TXT_LOOKUP[12] = '12'

              POP_LOOKUP[1] = 'PPON-Use Local Controls'
              POP_LOOKUP[2] = 'PPON-Use Local Controls'
              POP_LOOKUP[3] = 'PPON-DVD Controls'
              POP_LOOKUP[4] = 'PPON-VCR Controls'
              POP_LOOKUP[5] = 'PPON-VCR Controls'
              POP_LOOKUP[6] = 'PPON-Use Local Controls'
              POP_LOOKUP[7] = 'PPON-Use Local Controls'
              POP_LOOKUP[8] = 'PPON-Use Local Controls'
              POP_LOOKUP[9] = 'PPON-Use Local Controls'
              POP_LOOKUP[10] = 'PPON-Use Local Controls'
              POP_LOOKUP[11] = 'PPON-Use Local Controls'
              POP_LOOKUP[12] = 'PPON-Use Local Controls'
              POP_LOOKUP[13] = 'PPON-Lamp Hours Reset'

              POP_LOOKUP[14] = 'PPON-PC Sources 9'
              POP_LOOKUP[15] = 'PPON-Video Sources 8'
              POP_LOOKUP[16] = 'PPON-Environment'
              POP_LOOKUP[17] = 'PPON-Utilities'
              POP_LOOKUP[18] = 'PPON-PC Sources 9'
              POP_LOOKUP[19] = 'PPON-PC Sources 2'
              POP_LOOKUP[20] = 'PPON-Lighting Controls'
              POP_LOOKUP[21] = 'PPON-Screen Controls'
              POP_LOOKUP[22] = 'PPON-Volume Controls'
              POP_LOOKUP[23] = 'PPON-Shutdown'
              POP_LOOKUP[24] = 'PPON-Projector Controls'
              POP_LOOKUP[25] = 'PAGE-Logo Page'
              POP_LOOKUP[26] = 'PPOF-Shutdown'
              POP_LOOKUP[27] = 'PPON-Protected Projector Controls'
              POP_LOOKUP[28] = 'PPON-Reset Lamp Hours'
              POP_LOOKUP[29] = ''
              POP_LOOKUP[30] = 'PAGE-Main Page'
              POP_LOOKUP[31] = 'PPON-EXTRON10'
              POP_LOOKUP[32] = ''
              
        } 
	CASE 'SC 405':
        {
              (* ROUTER TABLE *)
              LOOKUP[RACK_PC]     = 1
              LOOKUP[RACK_MAC]    = 2
              LOOKUP[DVD]         = 3
              LOOKUP[VCR]         = 4
              LOOKUP[VCR_CC]      = 5  // CC FROM VCR
              LOOKUP[RACK_LAP]    = 6  // RACK VGA
              LOOKUP[RACK_VID]    = 7
              LOOKUP[FB_LAP]      = 8
              LOOKUP[FB_VID]      = 9
              LOOKUP[DOC_CAM]     = 10

              TXT_LOOKUP[LOOKUP[RACK_PC]] = 'RACK PC'
              TXT_LOOKUP[LOOKUP[RACK_MAC]] = 'RACK MAC'
              TXT_LOOKUP[LOOKUP[RACK_LAP]] = 'RACK - VGA'
              TXT_LOOKUP[LOOKUP[FB_LAP]] = 'REMOTE - VGA'
              TXT_LOOKUP[LOOKUP[VCR]] = 'VCR CONTROLS'
              TXT_LOOKUP[LOOKUP[DVD]] = 'DVD CONTROLS'
              TXT_LOOKUP[LOOKUP[RACK_VID]] = 'RACK A / V'
              TXT_LOOKUP[LOOKUP[FB_VID]] = 'REMOTE A / V'
              TXT_LOOKUP[LOOKUP[VCR_CC]] = 'VCR CONTROLS w/CC'
              TXT_LOOKUP[LOOKUP[DOC_CAM]] = 'DOC CAM'
              TXT_LOOKUP[11] = '11'
              TXT_LOOKUP[12] = '12'

              POP_LOOKUP[1] = 'PPON-Use Local Controls'
              POP_LOOKUP[2] = 'PPON-Use Local Controls'
              POP_LOOKUP[3] = 'PPON-DVD Controls'
              POP_LOOKUP[4] = 'PPON-VCR Controls'
              POP_LOOKUP[5] = 'PPON-VCR Controls'
              POP_LOOKUP[6] = 'PPON-Use Local Controls'
              POP_LOOKUP[7] = 'PPON-Use Local Controls'
              POP_LOOKUP[8] = 'PPON-Use Local Controls'
              POP_LOOKUP[9] = 'PPON-Use Local Controls'
              POP_LOOKUP[10] = 'PPON-Use Local Controls'
              POP_LOOKUP[11] = 'PPON-Use Local Controls'
              POP_LOOKUP[12] = 'PPON-Use Local Controls'
              POP_LOOKUP[13] = 'PPON-Lamp Hours Reset'

              POP_LOOKUP[14] = 'PPON-PC Sources 9'
              POP_LOOKUP[15] = 'PPON-Video Sources 8'
              POP_LOOKUP[16] = 'PPON-Environment'
              POP_LOOKUP[17] = 'PPON-Utilities'
              POP_LOOKUP[18] = 'PPON-PC Sources 9'
              POP_LOOKUP[19] = 'PPON-PC Sources 2'
              POP_LOOKUP[20] = 'PPON-Lighting Controls'
              POP_LOOKUP[21] = 'PPON-Screen Controls'
              POP_LOOKUP[22] = 'PPON-Volume Controls'
              POP_LOOKUP[23] = 'PPON-Shutdown'
              POP_LOOKUP[24] = 'PPON-Projector Controls'
              POP_LOOKUP[25] = 'PAGE-Logo Page'
              POP_LOOKUP[26] = 'PPOF-Shutdown'
              POP_LOOKUP[27] = 'PPON-Protected Projector Controls'
              POP_LOOKUP[28] = 'PPON-Reset Lamp Hours'
              POP_LOOKUP[29] = ''
              POP_LOOKUP[30] = 'PAGE-Main Page'
              POP_LOOKUP[31] = 'PPON-EXTRON10'
              POP_LOOKUP[32] = ''
              
        }
	CASE 'SC 58':
        {
              (* ROUTER TABLE *)
              LOOKUP[RACK_PC]     = 1
              LOOKUP[RACK_MAC]    = 2
              LOOKUP[DVD]         = 3
              LOOKUP[VCR]         = 4
              LOOKUP[VCR_CC]      = 5  // CC FROM VCR
              LOOKUP[RACK_LAP]    = 6  // RACK VGA
              LOOKUP[RACK_VID]    = 7
              LOOKUP[FB_LAP]      = 0
              LOOKUP[FB_VID]      = 0
              LOOKUP[DOC_CAM]     = 8

              TXT_LOOKUP[LOOKUP[RACK_PC]] = 'RACK PC'
              TXT_LOOKUP[LOOKUP[RACK_MAC]] = 'RACK MAC'
              TXT_LOOKUP[LOOKUP[RACK_LAP]] = 'CUBBY - VGA'
              TXT_LOOKUP[LOOKUP[FB_LAP]] = 'REMOTE - VGA'
              TXT_LOOKUP[LOOKUP[VCR]] = 'VCR CONTROLS'
              TXT_LOOKUP[LOOKUP[DVD]] = 'DVD CONTROLS'
              TXT_LOOKUP[LOOKUP[RACK_VID]] = 'CUBBY A / V'
              TXT_LOOKUP[LOOKUP[FB_VID]] = 'REMOTE A / V'
              TXT_LOOKUP[LOOKUP[VCR_CC]] = 'VCR CONTROLS w/CC'
              TXT_LOOKUP[LOOKUP[DOC_CAM]] = 'DOC CAM'
              TXT_LOOKUP[11] = '11'
              TXT_LOOKUP[12] = '12'

              POP_LOOKUP[1] = 'PPON-Use Local Controls'
              POP_LOOKUP[2] = 'PPON-Use Local Controls'
              POP_LOOKUP[3] = 'PPON-DVD Controls'
              POP_LOOKUP[4] = 'PPON-VCR Controls'
              POP_LOOKUP[5] = 'PPON-VCR Controls'
              POP_LOOKUP[6] = 'PPON-Use Local Controls'
              POP_LOOKUP[7] = 'PPON-Use Local Controls'
              POP_LOOKUP[8] = 'PPON-Use Local Controls'
              POP_LOOKUP[9] = 'PPON-Use Local Controls'
              POP_LOOKUP[10] = 'PPON-Use Local Controls'
              POP_LOOKUP[11] = 'PPON-Use Local Controls'
              POP_LOOKUP[12] = 'PPON-Use Local Controls'
              POP_LOOKUP[13] = 'PPON-Lamp Hours Reset'

              POP_LOOKUP[14] = 'PPON-PC Sources 6'
              POP_LOOKUP[15] = 'PPON-Video Sources 10'
              POP_LOOKUP[16] = 'PPON-Environment'
              POP_LOOKUP[17] = 'PPON-Utilities'
              POP_LOOKUP[18] = 'PPON-PC Sources 6'
              POP_LOOKUP[19] = 'PPON-PC Sources 6'
              POP_LOOKUP[20] = 'PPON-Lighting Controls'
              POP_LOOKUP[21] = 'PPON-Screen & Lights'
              POP_LOOKUP[22] = 'PPON-Volume Controls'
              POP_LOOKUP[23] = 'PPON-Shutdown'
              POP_LOOKUP[24] = 'PPON-Projector Controls'
              POP_LOOKUP[25] = 'PAGE-Logo Page'
              POP_LOOKUP[26] = 'PPOF-Shutdown'
              POP_LOOKUP[27] = 'PPON-Protected Projector Controls'
              POP_LOOKUP[28] = 'PPON-Reset Lamp Hours'
              POP_LOOKUP[29] = ''
              POP_LOOKUP[30] = 'PAGE-Main Page with screens and lights'
              POP_LOOKUP[31] = 'PPON-EXTRON10'
              POP_LOOKUP[32] = ''
              
        }
	CASE 'SHANKLIN 201':
	        {
              (* ROUTER TABLE *)
              LOOKUP[RACK_PC]     = 1
              LOOKUP[RACK_MAC]    = 2
              LOOKUP[DVD]         = 3
              LOOKUP[VCR]         = 4
              LOOKUP[VCR_CC]      = 5  // CC FROM VCR
              LOOKUP[RACK_LAP]    = 6  // RACK VGA
              LOOKUP[RACK_VID]    = 7
              LOOKUP[FB_LAP]      = 8
              LOOKUP[FB_VID]      = 0
              LOOKUP[DOC_CAM]     = 10

              TXT_LOOKUP[LOOKUP[RACK_PC]] = 'RACK PC'
              TXT_LOOKUP[LOOKUP[RACK_MAC]] = 'RACK MAC'
              TXT_LOOKUP[LOOKUP[RACK_LAP]] = 'RACK - VGA'
              TXT_LOOKUP[LOOKUP[FB_LAP]] = 'PODIUM - VGA'
              TXT_LOOKUP[LOOKUP[VCR]] = 'VCR CONTROLS'
              TXT_LOOKUP[LOOKUP[DVD]] = 'DVD CONTROLS'
              TXT_LOOKUP[LOOKUP[RACK_VID]] = 'RACK A / V'
              TXT_LOOKUP[LOOKUP[FB_VID]] = 'REMOTE A / V'
              TXT_LOOKUP[LOOKUP[VCR_CC]] = 'VCR CONTROLS w/CC'
              TXT_LOOKUP[LOOKUP[DOC_CAM]] = 'DOCUMENT CAMERA'
              TXT_LOOKUP[11] = '11'
              TXT_LOOKUP[12] = '12'

              POP_LOOKUP[1] = 'PPON-Use Local Controls'
              POP_LOOKUP[2] = 'PPON-Use Local Controls'
              POP_LOOKUP[3] = 'PPON-DVD Controls'
              POP_LOOKUP[4] = 'PPON-VCR Controls'
              POP_LOOKUP[5] = 'PPON-VCR Controls'
              POP_LOOKUP[6] = 'PPON-Use Local Controls'
              POP_LOOKUP[7] = 'PPON-Use Local Controls'
              POP_LOOKUP[8] = 'PPON-Use Local Controls'
              POP_LOOKUP[9] = 'PPON-Use Local Controls'
              POP_LOOKUP[10] = 'PPON-Use Local Controls'
              POP_LOOKUP[11] = 'PPON-Use Local Controls'
              POP_LOOKUP[12] = 'PPON-Use Local Controls'
              POP_LOOKUP[13] = 'PPON-Lamp Hours Reset'

              POP_LOOKUP[14] = 'PPON-PC Sources 10'
              POP_LOOKUP[15] = 'PPON-Video Sources 10'
              POP_LOOKUP[16] = 'PPON-Environment'
              POP_LOOKUP[17] = 'PPON-Utilities'
              POP_LOOKUP[18] = 'PPON-PC Sources 10'
              POP_LOOKUP[19] = 'PPON-PC Sources 10'
              POP_LOOKUP[20] = 'PPON-Lighting Controls'
              POP_LOOKUP[21] = 'PPON-Screen Controls X2'
              POP_LOOKUP[22] = 'PPON-Volume Controls'
              POP_LOOKUP[23] = 'PPON-Shutdown'
              POP_LOOKUP[24] = 'PPON-Projector Controls'
              POP_LOOKUP[25] = 'PAGE-Logo Page'
              POP_LOOKUP[26] = 'PPOF-Shutdown'
              POP_LOOKUP[27] = 'PPON-Protected Projector Controls'
              POP_LOOKUP[28] = 'PPON-Reset Lamp Hours'
              POP_LOOKUP[29] = ''
              POP_LOOKUP[30] = 'PAGE-Main Page with screens'
              POP_LOOKUP[31] = 'PPON-EXTRON10'
              POP_LOOKUP[32] = ''
              
        }
	CASE 'DOWNEY 113':
        {
              (* ROUTER TABLE *)
              LOOKUP[RACK_PC]     = 1
              LOOKUP[RACK_MAC]    = 2
              LOOKUP[DVD]         = 3
              LOOKUP[VCR]         = 4
              LOOKUP[VCR_CC]      = 5  // CC FROM VCR
              LOOKUP[RACK_LAP]    = 6  // RACK VGA
              LOOKUP[RACK_VID]    = 7
              LOOKUP[FB_LAP]      = 8
              LOOKUP[FB_VID]      = 9
              LOOKUP[DOC_CAM]     = 10

              TXT_LOOKUP[LOOKUP[RACK_PC]] = 'PC'
              TXT_LOOKUP[LOOKUP[RACK_MAC]] = 'MAC'
              TXT_LOOKUP[LOOKUP[RACK_LAP]] = 'RACK - VGA'
              TXT_LOOKUP[LOOKUP[FB_LAP]] = 'PODIUM - VGA'
              TXT_LOOKUP[LOOKUP[VCR]] = 'VCR CONTROLS'
              TXT_LOOKUP[LOOKUP[DVD]] = 'DVD CONTROLS'
              TXT_LOOKUP[LOOKUP[RACK_VID]] = 'RACK A / V'
              TXT_LOOKUP[LOOKUP[FB_VID]] = 'REMOTE A / V'
              TXT_LOOKUP[LOOKUP[VCR_CC]] = 'VCR CONTROLS w/CC'
              TXT_LOOKUP[LOOKUP[DOC_CAM]] = 'DOCUMENT CAMERA'
              TXT_LOOKUP[11] = '11'
              TXT_LOOKUP[12] = '12'

              POP_LOOKUP[1] = 'PPON-Use Local Controls'
              POP_LOOKUP[2] = 'PPON-Use Local Controls'
              POP_LOOKUP[3] = 'PPON-DVD Controls'
              POP_LOOKUP[4] = 'PPON-VCR Controls'
              POP_LOOKUP[5] = 'PPON-VCR Controls'
              POP_LOOKUP[6] = 'PPON-Use Local Controls'
              POP_LOOKUP[7] = 'PPON-Use Local Controls'
              POP_LOOKUP[8] = 'PPON-Use Local Controls'
              POP_LOOKUP[9] = 'PPON-Use Local Controls'
              POP_LOOKUP[10] = 'PPON-Use Local Controls'
              POP_LOOKUP[11] = 'PPON-Use Local Controls'
              POP_LOOKUP[12] = 'PPON-Use Local Controls'
              POP_LOOKUP[13] = 'PPON-Lamp Hours Reset'

              POP_LOOKUP[14] = 'PPON-PC Sources 13'
              POP_LOOKUP[15] = 'PPON-Video Sources 8'
              POP_LOOKUP[16] = 'PPON-Environment'
              POP_LOOKUP[17] = 'PPON-Utilities'
              POP_LOOKUP[18] = 'PPON-PC Sources 13'
              POP_LOOKUP[19] = 'PPON-PC Sources 13'
              POP_LOOKUP[20] = 'PPON-Lighting Controls'
              POP_LOOKUP[21] = 'PPON-Screen & Lights 2'
              POP_LOOKUP[22] = 'PPON-Volume Controls'
              POP_LOOKUP[23] = 'PPON-Shutdown'
              POP_LOOKUP[24] = 'PPON-Projector Controls'
              POP_LOOKUP[25] = 'PAGE-Logo Page'
              POP_LOOKUP[26] = 'PPOF-Shutdown'
              POP_LOOKUP[27] = 'PPON-Protected Projector Controls'
              POP_LOOKUP[28] = 'PPON-Reset Lamp Hours'
              POP_LOOKUP[29] = ''
              POP_LOOKUP[30] = 'PAGE-Main Page with screens and lights'
              POP_LOOKUP[31] = 'PPON-EXTRON10'
              POP_LOOKUP[32] = ''
              
        }
	CASE 'DOWNEY 100':
        {
              (* ROUTER TABLE *)
              LOOKUP[RACK_PC]     = 1
              LOOKUP[RACK_MAC]    = 2
              LOOKUP[DVD]         = 3
              LOOKUP[VCR]         = 4
              LOOKUP[VCR_CC]      = 5  // CC FROM VCR
              LOOKUP[RACK_LAP]    = 6  // RACK VGA
              LOOKUP[RACK_VID]    = 7
              LOOKUP[FB_LAP]      = 8
              LOOKUP[FB_VID]      = 0
              LOOKUP[DOC_CAM]     = 10

              TXT_LOOKUP[LOOKUP[RACK_PC]] = 'RACK PC'
              TXT_LOOKUP[LOOKUP[RACK_MAC]] = 'RACK MAC'
              TXT_LOOKUP[LOOKUP[RACK_LAP]] = 'RACK - VGA'
              TXT_LOOKUP[LOOKUP[FB_LAP]] = 'PODIUM - VGA'
              TXT_LOOKUP[LOOKUP[VCR]] = 'VCR CONTROLS'
              TXT_LOOKUP[LOOKUP[DVD]] = 'DVD CONTROLS'
              TXT_LOOKUP[LOOKUP[RACK_VID]] = 'RACK A / V'
              TXT_LOOKUP[LOOKUP[FB_VID]] = 'REMOTE A / V'
              TXT_LOOKUP[LOOKUP[VCR_CC]] = 'VCR CONTROLS w/CC'
              TXT_LOOKUP[LOOKUP[DOC_CAM]] = 'DOCUMENT CAMERA'
              TXT_LOOKUP[11] = '11'
              TXT_LOOKUP[12] = '12'

              POP_LOOKUP[1] = 'PPON-Use Local Controls'
              POP_LOOKUP[2] = 'PPON-Use Local Controls'
              POP_LOOKUP[3] = 'PPON-DVD Controls'
              POP_LOOKUP[4] = 'PPON-VCR Controls'
              POP_LOOKUP[5] = 'PPON-VCR Controls'
              POP_LOOKUP[6] = 'PPON-Use Local Controls'
              POP_LOOKUP[7] = 'PPON-Use Local Controls'
              POP_LOOKUP[8] = 'PPON-Use Local Controls'
              POP_LOOKUP[9] = 'PPON-Use Local Controls'
              POP_LOOKUP[10] = 'PPON-Use Local Controls'
              POP_LOOKUP[11] = 'PPON-Use Local Controls'
              POP_LOOKUP[12] = 'PPON-Use Local Controls'
              POP_LOOKUP[13] = 'PPON-Lamp Hours Reset'

              POP_LOOKUP[14] = 'PPON-PC Sources 10'
              POP_LOOKUP[15] = 'PPON-Video Sources 10'
              POP_LOOKUP[16] = 'PPON-Environment'
              POP_LOOKUP[17] = 'PPON-Utilities'
              POP_LOOKUP[18] = 'PPON-PC Sources 10'
              POP_LOOKUP[19] = 'PPON-PC Sources 10'
              POP_LOOKUP[20] = 'PPON-Lighting Controls'
              POP_LOOKUP[21] = 'PPON-Screen Controls X2'
              POP_LOOKUP[22] = 'PPON-Volume Controls'
              POP_LOOKUP[23] = 'PPON-Shutdown'
              POP_LOOKUP[24] = 'PPON-Projector Controls'
              POP_LOOKUP[25] = 'PAGE-Logo Page'
              POP_LOOKUP[26] = 'PPOF-Shutdown'
              POP_LOOKUP[27] = 'PPON-Protected Projector Controls'
              POP_LOOKUP[28] = 'PPON-Reset Lamp Hours'
              POP_LOOKUP[29] = ''
              POP_LOOKUP[30] = 'PAGE-Main Page with screens'
              POP_LOOKUP[31] = 'PPON-EXTRON10'
              POP_LOOKUP[32] = ''
              
        }        
    } 
}
(***********************************************************)
(*                STARTUP CODE GOES BELOW                  *)
(***********************************************************)
DEFINE_START
GOING_ON_MIDNIGHT = 86400

SmtpSetServer('panja.post.wesleyan.edu')       // SET SMTP SERVER ADDRESS EMAIL

ProjOneEmailFirstWarn = "'The Lamp Hours for the Main Projector in this Room have reached the limit set for the first warning.',
                          13,10,'You may want to order a new lamp at this time.'"

ProjOneEmailFinalWarn = "'The Lamp Hours for the Main Projector in this Room have reached the limit set for the FINAL warning.',
                          13,10,'Please replace the lamp at this time to avoid losing the use of this projector.'"

ProjTwoEmailFirstWarn = "'The Lamp Hours for the Second Projector in this Room have reached the limit set for the first warning.',
                          13,10,'You may want to order a new lamp at this time.'"

ProjTwoEmailFinalWarn = "'The Lamp Hours for the Second Projector in this Room have reached the limit set for the FINAL warning.',
                          13,10,'Please replace the lamp at this time to avoid losing the use of this projector.'"

ProjOneCoverWarn      = "'The cover has been opened on the Main Projector in this room.',
                          13,10,'Please verify that this is due to scheduled maintenance or contact Security.'"
ProjOneCoverWarnOff   = "'The cover has been closed on the Main Projector in this room.'"
ProjOneTempWarn       = "'The Main Projector in this room is reporting a high temperature condition.',
                          13,10,'If this condition persists, please contact service personnel.'"
ProjOneTempWarnOff    = "'The Main Projector in this room is no longer reorting a high temperature condition.'"
ProjOneFanWarn        = "'The Main Projector in this room is reporting a fan stoppage.',
                          13,10,'If this condition persists, please contact service personnel.'"  
ProjOneFanWarnOff     = "'The Main Projector in this room is no longer reporting a fan stoppage.'"
ProjOnePowerSupplyWarn    = "'The Main Projector in this room is reporting a power supply failure.',
                          13,10,'If this condition persists, please contact service personnel.'"
ProjOnePowerSupplyWarnOff = "'The Main Projector in this room is no longer reorting a power supply failure.'"
ProjOneLampFail       = "'The Main Projector in this room is reporting that a lamp has failed to light.',
                          13,10,'This could indicate imminent or current bulb failure.',
                          13,10,'If this condition persists, please contact service personnel.'"  
ProjOneCommFail       = "'The communications link, to the Main Projector in this room, has been interrupted.',
                          13,10,'Please verify that this is due to scheduled maintenance or contact Security.'"
ProjOneCommFailOff    = "'The communications link, to the Main Projector in this room, has been restored.'"

ProjTwoCoverWarn      = "'The cover has been opened on the Second Projector in this room.',
                          13,10,'Please verify that this is due to scheduled maintenance or contact Security.'"
ProjTwoCoverWarnOff   = "'The cover has been closed on the Second Projector in this room.'"
ProjTwoTempWarn       = "'The Second Projector in this room is reporting a high temperature condition.',
                          13,10,'If this condition persists, please contact service personnel.'"
ProjTwoTempWarnOff    = "'The Second Projector in this room is no longer reorting a high temperature condition.'"
ProjTwoFanWarn        = "'The Second Projector in this room is reporting a fan stoppage.',
                          13,10,'If this condition persists, please contact service personnel.'"  
ProjTwoFanWarnOff     = "'The Second Projector in this room is no longer reporting a fan stoppage.'"
ProjTwoPowerSupplyWarn    = "'The Second Projector in this room is reporting a power supply failure.',
                          13,10,'If this condition persists, please contact service personnel.'"
ProjTwoPowerSupplyWarnOff = "'The Second Projector in this room is no longer reorting a power supply failure.'"
ProjTwoLampFail       = "'The Second Projector in this room is reporting that a lamp has failed to light.',
                          13,10,'This could indicate imminent or current bulb failure.',
                          13,10,'If this condition persists, please contact service personnel.'"  
ProjTwoCommFail       = "'The communications link, to the Second Projector in this room, has been interrupted.',
                          13,10,'Please verify that this is due to scheduled maintenance or contact Security.'"
ProjTwoCommFailOff    = "'The communications link, to the Second Projector in this room, has been restored.'"

CREATE_LEVEL dvVOLUME,1,VOL_LVL

CREATE_BUFFER vdvTP,TP_BUFFER
CREATE_BUFFER dvROUTER,ROUTER_BUFFER
// CREATE_BUFFER dvPROJ2,PROJ2_BUFFER
// CREATE_BUFFER dvPCSWITCH,PcSwitchBuff
Passwords[1] = "'1513'"
Passwords[2] = "'5625'"

DEBUG = 0

SEND_COMMAND vdvTP,"'@PPX'"
SEND_COMMAND vdvTP,"'PAGE-Logo Page'"
SYSTEM_CALL 'FUNCTION' (dvVCR,2,0)     
SYSTEM_CALL 'FUNCTION' (dvDVD,2,0)
//SEND_STRING dvROUTER,"PROJ1_CMD[POF]"

WAIT 80
  SEND_COMMAND vdvProj,'POF'
  
CREATE_BUFFER vdvProj,vdvProjBuffer
  
WAIT 80
  SEND_COMMAND vdvProj2,'POF'
  
CREATE_BUFFER vdvProj2,vdvProj2Buffer
  
//SEND_STRING dvPROJ2,"PROJ2_CMD[POF]"
//OFF[dvPROJ2,POWER_STAT]

SEND_COMMAND vdvTP,"'TEXT2-PROJECTOR IS COOLING DOWN'"

CALL 'SETUP' (SystemName[SYSTEM_NUMBER])

LAMP_MAX = 1500
LAMP_FIRST_WARNING = 1200
LAMP_MAX2 = 1500
LAMP_FIRST_WARNING2 = 1200    

(* !!OLD EXTRON PROJECTOR COMMANDS 

PROJ1_CMD[PON]  = "$5B"
PROJ1_CMD[POF]  = "$5D"
PROJ1_CMD[MON]  = "$28"
PROJ1_CMD[MOF]  = "$29"  *)

(* NEC PROJECTOR COMMANDS *)

PROJ2_CMD[PON]     = "$02,$00,$00,$00,$00,$02"
PROJ2_CMD[POF]     = "$02,$01,$00,$00,$00,$03"
PROJ2_CMD[MON]     = "$02,$10,$00,$00,$00,$12"
PROJ2_CMD[MOF]     = "$02,$11,$00,$00,$00,$13"
PROJ2_CMD[RGB1]    = "$02,$03,$00,$00,$02,$01,$01,$09"
PROJ2_CMD[RGB2]    = "$02,$03,$00,$00,$02,$01,$02,$0A"
PROJ2_CMD[VIDEO]   = "$02,$03,$00,$00,$02,$01,$06,$0E"
PROJ2_CMD[SVIDEO]  = "$02,$03,$00,$00,$02,$01,$0B,$13"

lTimeArray[1] = 60000  // UPDATE AUDIT DISPLAY DATA EVERY MIN
TIMELINE_CREATE(TL_DISP_REFRESH,lTimeArray,1,TIMELINE_RELATIVE,TIMELINE_REPEAT)

DVD_START=0
VCR_START=0

SEND_COMMAND vdvTP,"'TEXT13-',ITOA(AUDIT_VCR_SEC/3600),' Hrs|',ITOA((AUDIT_VCR_SEC%3600)/60),' Mins'" // VCR TIME
SEND_COMMAND vdvTP,"'TEXT14-',ITOA(AUDIT_DVD_SEC/3600),' Hrs|',ITOA((AUDIT_DVD_SEC%3600)/60),' Mins'" // DVD TIME
SEND_COMMAND vdvTP,"'TEXT15-|',ITOA(AUDIT_CAS_SEC/3600),' Hrs ',ITOA((AUDIT_CAS_SEC%3600)/60),' Mins'" // CAS TIME
SEND_COMMAND vdvTP,"'TEXT16-|',ITOA(AUDIT_TTB_SEC/3600),' Hrs ',ITOA((AUDIT_TTB_SEC%3600)/60),' Mins'" // TTB TIME

(***********************************************************)
(*                 THE MODULES GO BELOW                    *)
(***********************************************************)

DEFINE_MODULE 'NEC MT 1055 SERIES' mdlProj(dvProj,vdvProj)
DEFINE_MODULE 'NEC MT 1055 SERIES' mdlProj2(dvProj2,vdvProj2)

(***********************************************************)
(*                 THE EVENTS GO BELOW                     *)
(***********************************************************)
DEFINE_EVENT
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
CHANNEL_EVENT[vdvProj,PROJ_COVER_OPEN]
{
  ON:
  {
    SystemEmailAddress = "'panja@wesleyan.edu'"
  // SmtpQueMessage('from', 'to', 'subject', 'message','attach file')
    SmtpQueMessage(SystemEmailAddress,EmailToWho,"'IMPORTANT MESSAGE! ',SystemName[SYSTEM_NUMBER],
                  ' Projector 1 cover open'","'Room: ',SystemName[SYSTEM_NUMBER],13,10,13,10,
                    ProjOneCoverWarn,13,10,13,10",'')
  }
  OFF:
  {
    SystemEmailAddress = "'panja@wesleyan.edu'"
  // SmtpQueMessage('from', 'to', 'subject', 'message','attach file')
    SmtpQueMessage(SystemEmailAddress,EmailToWho,"'IMPORTANT MESSAGE! ',SystemName[SYSTEM_NUMBER],
                  ' Projector 1 cover closed'","'Room: ',SystemName[SYSTEM_NUMBER],13,10,13,10,
                    ProjOneCoverWarnOff,13,10,13,10",'')
  }
}
CHANNEL_EVENT[vdvProj,PROJ_TEMP_FAULT]
{
  ON:
  {
    SystemEmailAddress = "'panja@wesleyan.edu'"
 // SmtpQueMessage('from', 'to', 'subject', 'message','attach file')
    SmtpQueMessage(SystemEmailAddress,EmailToWho,"'URGENT!!!!!! ',SystemName[SYSTEM_NUMBER],
                  ' Projector 1 Temperature Error'","'Room: ',SystemName[SYSTEM_NUMBER],13,10,13,10,
                  ProjOneTempWarn,13,10,13,10",'')
  }
  OFF:
  {
    SystemEmailAddress = "'panja@wesleyan.edu'"
 // SmtpQueMessage('from', 'to', 'subject', 'message','attach file')
    SmtpQueMessage(SystemEmailAddress,EmailToWho,"'IMPORTANT MESSAGE! ',SystemName[SYSTEM_NUMBER],
                  ' Projector 1 temperature resolved'","'Room: ',SystemName[SYSTEM_NUMBER],13,10,13,10,
                  ProjOneTempWarnOff,13,10,13,10",'')
  }
}
CHANNEL_EVENT[vdvProj,PROJ_FAN_STOP]
{
  ON:
  {
    SystemEmailAddress = "'panja@wesleyan.edu'"
 // SmtpQueMessage('from', 'to', 'subject', 'message','attach file')
    SmtpQueMessage(SystemEmailAddress,EmailToWho,"'URGENT!!!!!! ',SystemName[SYSTEM_NUMBER],
                  ' Projector 1 fan stopped'","'Room: ',SystemName[SYSTEM_NUMBER],13,10,13,10,
                  ProjOneFanWarn,13,10,13,10",'')
  }
  OFF:
  {
    SystemEmailAddress = "'panja@wesleyan.edu'"
 // SmtpQueMessage('from', 'to', 'subject', 'message','attach file')
    SmtpQueMessage(SystemEmailAddress,EmailToWho,"'IMPORTANT MESSAGE! ',SystemName[SYSTEM_NUMBER],
                  ' Projector 1 fan resolved'","'Room: ',SystemName[SYSTEM_NUMBER],13,10,13,10,
                  ProjOneFanWarnOff,13,10,13,10",'')
  }
}
CHANNEL_EVENT[vdvProj,PROJ_PWR_SUPPLY]
{
  ON:
  {
    SystemEmailAddress = "'panja@wesleyan.edu'"
 // SmtpQueMessage('from', 'to', 'subject', 'message','attach file')
    SmtpQueMessage(SystemEmailAddress,EmailToWho,"'URGENT!!!!!! ',SystemName[SYSTEM_NUMBER],
                  ' Projector 1 power supply failed'","'Room: ',SystemName[SYSTEM_NUMBER],13,10,13,10,
                  ProjOnePowerSupplyWarn,13,10,13,10",'')
  }
  OFF:
  {
    SystemEmailAddress = "'panja@wesleyan.edu'"
 // SmtpQueMessage('from', 'to', 'subject', 'message','attach file')
    SmtpQueMessage(SystemEmailAddress,EmailToWho,"'IMPORTANT MESSAGE! ',SystemName[SYSTEM_NUMBER],
                  ' Projector 1 power supply resolved'","'Room: ',SystemName[SYSTEM_NUMBER],13,10,13,10,
                  ProjOnePowerSupplyWarnOff,13,10,13,10",'')
  }
}
CHANNEL_EVENT[vdvProj,PROJ_LAMP_FAIL]
{
  ON:
  {
    SystemEmailAddress = "'panja@wesleyan.edu'"
 // SmtpQueMessage('from', 'to', 'subject', 'message','attach file')
    SmtpQueMessage(SystemEmailAddress,EmailToWho,"'URGENT!!!!!! ',SystemName[SYSTEM_NUMBER],
                  ' Projector 1 Lamp Fail'","'Room: ',SystemName[SYSTEM_NUMBER],13,10,13,10,
                  ProjOneLampFail,13,10,13,10",'')
  }
}
CHANNEL_EVENT[vdvProj,PROJ_COMM_ACTIVE]
{
  ON:
  {
    SystemEmailAddress = "'panja@wesleyan.edu'"
 // SmtpQueMessage('from', 'to', 'subject', 'message','attach file')
    SmtpQueMessage(SystemEmailAddress,EmailToWho,"'IMPORTANT MESSAGE! ',SystemName[SYSTEM_NUMBER],
                  ' Projector 1 Comm Fail'","'Room: ',SystemName[SYSTEM_NUMBER],13,10,13,10,
                  ProjOneCommFail,13,10,13,10",'')
  }
  OFF:
  {
    SystemEmailAddress = "'panja@wesleyan.edu'"
 // SmtpQueMessage('from', 'to', 'subject', 'message','attach file')
    SmtpQueMessage(SystemEmailAddress,EmailToWho,"'IMPORTANT MESSAGE! ',SystemName[SYSTEM_NUMBER],
                  ' Projector 1 Comm Restored'","'Room: ',SystemName[SYSTEM_NUMBER],13,10,13,10,
                  ProjOneCommFailOff,13,10,13,10",'')
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
CHANNEL_EVENT[vdvProj2,PROJ_COVER_OPEN]
{
  ON:
  {
    SystemEmailAddress = "'panja@wesleyan.edu'"
  // SmtpQueMessage('from', 'to', 'subject', 'message','attach file')
    SmtpQueMessage(SystemEmailAddress,EmailToWho,"'IMPORTANT MESSAGE! ',SystemName[SYSTEM_NUMBER],
                  ' Projector 2 cover open'","'Room: ',SystemName[SYSTEM_NUMBER],13,10,13,10,
                    ProjTwoCoverWarn,13,10,13,10",'')
  }
  OFF:
  {
    SystemEmailAddress = "'panja@wesleyan.edu'"
  // SmtpQueMessage('from', 'to', 'subject', 'message','attach file')
    SmtpQueMessage(SystemEmailAddress,EmailToWho,"'IMPORTANT MESSAGE! ',SystemName[SYSTEM_NUMBER],
                  ' Projector 2 cover closed'","'Room: ',SystemName[SYSTEM_NUMBER],13,10,13,10,
                    ProjTwoCoverWarnOff,13,10,13,10",'')
  }
}
CHANNEL_EVENT[vdvProj2,PROJ_TEMP_FAULT]
{
  ON:
  {
    SystemEmailAddress = "'panja@wesleyan.edu'"
 // SmtpQueMessage('from', 'to', 'subject', 'message','attach file')
    SmtpQueMessage(SystemEmailAddress,EmailToWho,"'URGENT!!!!!! ',SystemName[SYSTEM_NUMBER],
                  ' Projector 2 Temperature Error'","'Room: ',SystemName[SYSTEM_NUMBER],13,10,13,10,
                  ProjTwoTempWarn,13,10,13,10",'')
  }
  OFF:
  {
    SystemEmailAddress = "'panja@wesleyan.edu'"
 // SmtpQueMessage('from', 'to', 'subject', 'message','attach file')
    SmtpQueMessage(SystemEmailAddress,EmailToWho,"'IMPORTANT MESSAGE! ',SystemName[SYSTEM_NUMBER],
                  ' Projector 2 temperature resolved'","'Room: ',SystemName[SYSTEM_NUMBER],13,10,13,10,
                  ProjTwoTempWarnOff,13,10,13,10",'')
  }
}
CHANNEL_EVENT[vdvProj2,PROJ_FAN_STOP]
{
  ON:
  {
    SystemEmailAddress = "'panja@wesleyan.edu'"
 // SmtpQueMessage('from', 'to', 'subject', 'message','attach file')
    SmtpQueMessage(SystemEmailAddress,EmailToWho,"'URGENT!!!!!! ',SystemName[SYSTEM_NUMBER],
                  ' Projector 2 fan stopped'","'Room: ',SystemName[SYSTEM_NUMBER],13,10,13,10,
                  ProjTwoFanWarn,13,10,13,10",'')
  }
  OFF:
  {
    SystemEmailAddress = "'panja@wesleyan.edu'"
 // SmtpQueMessage('from', 'to', 'subject', 'message','attach file')
    SmtpQueMessage(SystemEmailAddress,EmailToWho,"'IMPORTANT MESSAGE! ',SystemName[SYSTEM_NUMBER],
                  ' Projector 2 fan resolved'","'Room: ',SystemName[SYSTEM_NUMBER],13,10,13,10,
                  ProjTwoFanWarnOff,13,10,13,10",'')
  }
}
CHANNEL_EVENT[vdvProj2,PROJ_PWR_SUPPLY]
{
  ON:
  {
    SystemEmailAddress = "'panja@wesleyan.edu'"
 // SmtpQueMessage('from', 'to', 'subject', 'message','attach file')
    SmtpQueMessage(SystemEmailAddress,EmailToWho,"'URGENT!!!!!! ',SystemName[SYSTEM_NUMBER],
                  ' Projector 2 power supply failed'","'Room: ',SystemName[SYSTEM_NUMBER],13,10,13,10,
                  ProjTwoPowerSupplyWarn,13,10,13,10",'')
  }
  OFF:
  {
    SystemEmailAddress = "'panja@wesleyan.edu'"
 // SmtpQueMessage('from', 'to', 'subject', 'message','attach file')
    SmtpQueMessage(SystemEmailAddress,EmailToWho,"'IMPORTANT MESSAGE! ',SystemName[SYSTEM_NUMBER],
                  ' Projector 2 power supply resolved'","'Room: ',SystemName[SYSTEM_NUMBER],13,10,13,10,
                  ProjTwoPowerSupplyWarnOff,13,10,13,10",'')
  }
}
CHANNEL_EVENT[vdvProj2,PROJ_LAMP_FAIL]
{
  ON:
  {
    SystemEmailAddress = "'panja@wesleyan.edu'"
 // SmtpQueMessage('from', 'to', 'subject', 'message','attach file')
    SmtpQueMessage(SystemEmailAddress,EmailToWho,"'URGENT!!!!!! ',SystemName[SYSTEM_NUMBER],
                  ' Projector 2 Lamp Fail'","'Room: ',SystemName[SYSTEM_NUMBER],13,10,13,10,
                  ProjTwoLampFail,13,10,13,10",'')
  }
}
CHANNEL_EVENT[vdvProj2,PROJ_COMM_ACTIVE]
{
  ON:
  {
    SystemEmailAddress = "'panja@wesleyan.edu'"
 // SmtpQueMessage('from', 'to', 'subject', 'message','attach file')
    SmtpQueMessage(SystemEmailAddress,EmailToWho,"'IMPORTANT MESSAGE! ',SystemName[SYSTEM_NUMBER],
                  ' Projector 2 Comm Fail'","'Room: ',SystemName[SYSTEM_NUMBER],13,10,13,10,
                  ProjTwoCommFail,13,10,13,10",'')
  }
  OFF:
  {
    SystemEmailAddress = "'panja@wesleyan.edu'"
 // SmtpQueMessage('from', 'to', 'subject', 'message','attach file')
    SmtpQueMessage(SystemEmailAddress,EmailToWho,"'IMPORTANT MESSAGE! ',SystemName[SYSTEM_NUMBER],
                  ' Projector 2 Comm Restored'","'Room: ',SystemName[SYSTEM_NUMBER],13,10,13,10,
                  ProjTwoCommFailOff,13,10,13,10",'')
  }
}

(*DATA_EVENT[dvPROJ2]
{
  ONLINE:
  {
    WAIT 30
    {
      SEND_COMMAND dvPROJ2,"'SET BAUD 38400,N,8,1'"
    }
  }
}*)

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

Data_Event[LIGHTS]
{
  Online :
  {
    Send_Command Data.Device,"'SET BAUD 9600,N,8,1 485 DISABLED'"
    Send_Command Data.Device,"'HSOFF'"
  }
}

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
  PUSH:
  {
    SEND_COMMAND vdvTP,"'@PPX'"
  }    
}
BUTTON_EVENT[dv16,1]			// STACKED SYSTEM SHUTDOWN FOR DOWNEY 100
BUTTON_EVENT[vdvTP,91]                  // EXIT YES BUTTON
{
  PUSH:
  {
    //SEND_STRING dvROUTER,"PROJ1_CMD[POF]"
    SEND_COMMAND vdvProj,'POF'
    SEND_COMMAND vdvProj2,'POF'
    //SEND_STRING dvPROJ2,"PROJ2_CMD[POF]"
    //OFF[dvPROJ2,POWER_STAT]
    IF (![vdvProj,PROJ_POW_OFF])
    {
      SEND_COMMAND vdvTP,"'TEXT2-PROJECTOR IS COOLING DOWN'"
      WAIT 4
      {
        SEND_COMMAND vdvTP,"'PPON-PROJ WAIT'"
        WAIT_UNTIL ([vdvProj,PROJ_POW_OFF]) 'PROJ COOL'
        {
          SEND_COMMAND vdvTP,"'PPOF-PROJ WAIT'"
        }
      }
    }
    CANCEL_WAIT_UNTIL 'PROJ WARM'
    IF(SystemName[SYSTEM_NUMBER] = 'DOWNEY 100')
    {
       PULSE[dv16,1]   // SCREEN2 IS DOWN
    }

    SYSTEM_CALL[1] 'SCREEN2' (0,1,0,0,dvRELAY,2,1,0,0)      // SCREEN1 IS DOWN
    IF(SystemName[SYSTEM_NUMBER] = 'PAC 002')
    {
       SYSTEM_CALL[3] 'SCREEN2' (0,1,0,0,dvRELAY,6,5,0,0)   // SCREEN2 IS DOWN
    }
    SYSTEM_CALL[1] 'FUNCTION' (dvVCR,2,0)
    SYSTEM_CALL[2] 'FUNCTION' (dvDVD,2,0)
    SEND_COMMAND vdvTP,"'@PPX'"
    POP_FDBK = 0
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
      
      VCR_START = 0 // THIS WILL CAUSE A BUG IF THE OPERATOR HITS A TRANSPORT COMMAND AT EXACTLY MIDNIGHT
    }
    IF(TIMELINE_ACTIVE(TL_VCR_TIMEOUT)) // KILL THE TIMEOUT TOO
    {
      TIMELINE_KILL(TL_VCR_TIMEOUT)
    }

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
      
      DVD_START = 0 // THIS WILL CAUSE A BUG IF THE OPERATOR HITS A TRANSPORT COMMAND AT EXACTLY MIDNIGHT
    }
    
    IF(TIMELINE_ACTIVE(TL_DVD_TIMEOUT)) // KILL THE TIMEOUT TOO
    {
      TIMELINE_KILL(TL_DVD_TIMEOUT)
    }
    IF(SystemName[SYSTEM_NUMBER] = 'DOWNEY 113')
    {
	SEND_STRING LIGHTS,"':PS,0,1',13"
	SEND_STRING LIGHTS,"':PS,1,1',13"
	SEND_STRING LIGHTS,"':PS,2,1',13"
	SEND_STRING LIGHTS,"':PS,3,1',13"
	SEND_STRING LIGHTS,"':PS,4,1',13"
	SEND_STRING LIGHTS,"':PS,5,1',13"
    }
  }     
}

(******************************)
(**** SELECT SOURCES **********)
(******************************)

BUTTON_EVENT[dcSource]
{
    PUSH:
    {
	SOURCE = LOOKUP[GET_LAST(dcSource)] 
	
	SEND_COMMAND vdvTP,"POP_LOOKUP[SOURCE]"
	
	IF((GET_LAST(dcSource) = 8) OR (GET_LAST(dcSource) = 14))
	{
	    PULSE[dvVCR,27]       // POWER ON
	}
	IF(SOURCE_BUTTON <> BUTTON.INPUT.CHANNEL)  // IF WE JUST SWITCHED SOURCES - THEN TIMEOUT ALL COUNTERS
	{
	    //VCR
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
		VCR_START = 0 // THIS WILL CAUSE A BUG IF THE OPERATOR HITS A TRANSPORT COMMAND AT EXACTLY MIDNIGHT
	    }
	    
	    IF(TIMELINE_ACTIVE(TL_VCR_TIMEOUT)) // KILL THE TIMEOUT TOO
	    {
		TIMELINE_KILL(TL_VCR_TIMEOUT)
	    }
	    
	    //DVD
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
		DVD_START = 0 // THIS WILL CAUSE A BUG IF THE OPERATOR HITS A TRANSPORT COMMAND AT EXACTLY MIDNIGHT
	    }
	    IF(TIMELINE_ACTIVE(TL_DVD_TIMEOUT)) // KILL THE TIMEOUT TOO
	    {
		TIMELINE_KILL(TL_DVD_TIMEOUT)
	    }
	    
	    //CASSETTE
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
	    IF(TIMELINE_ACTIVE(TL_CAS_TIMEOUT)) // KILL THE CAS TIMEOUT TOO
	    {
		
		TIMELINE_KILL(TL_CAS_TIMEOUT)
	    }
	    
	    //TURNTABLE
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
	    IF(TIMELINE_ACTIVE(TL_TTB_TIMEOUT)) // KILL THE TTB TIMEOUT TOO
	    {
		
		TIMELINE_KILL(TL_TTB_TIMEOUT)
	    }
	}
	IF(BUTTON.INPUT.CHANNEL = 14) // SOURCE IS CASSETTE
	{
	    CAS_START = TOD_IN_SECONDS()
	    lTimeArray[1] = 7200000  // 2 HOUR TIMEOUT
	    TIMELINE_CREATE(TL_CAS_TIMEOUT,lTimeArray,1,TIMELINE_ABSOLUTE,TIMELINE_ONCE)
	}
	IF(SOURCE = 7) // SOURCE IS CASSETTE
	{
	    SEND_STRING dvROUTER,"'10!'"
	    PULSE[vdvProj,PROJ_RGB1_IN]     
	}
	IF(BUTTON.INPUT.CHANNEL = 15) // SOURCE IS TURNTABLE
	{
	    TTB_START = TOD_IN_SECONDS()
	    lTimeArray[1] = 7200000  // 2 HOUR TIMEOUT
	    TIMELINE_CREATE(TL_TTB_TIMEOUT,lTimeArray,1,TIMELINE_ABSOLUTE,TIMELINE_ONCE)
	}
	SOURCE_BUTTON = BUTTON.INPUT.CHANNEL
	
	IF((SystemName[SYSTEM_NUMBER] = 'DAC 100') && (GET_LAST(dcSource) = 1 || GET_LAST(dcSource) = 2)) // FOR FEEDBACK IN DAC100
	{
	    SEND_COMMAND vdvTP,"'TEXT1-',TXT_LOOKUP[GET_LAST(dcSource) + 10]"
	}  
	ELSE
	{
	    SEND_COMMAND vdvTP,"'TEXT1-',TXT_LOOKUP[SOURCE]"
	}
	IF((BUTTON.INPUT.CHANNEL = 3) OR (BUTTON.INPUT.CHANNEL = 4)) // FOR KEYBRD MOUSE SWITCH 
	{
	    SEND_STRING dvPCSWITCH,"ITOA(BUTTON.INPUT.CHANNEL - 2),$0D"
	    DACPC = BUTTON.INPUT.CHANNEL                             // FOR ROUTER FEEDBACK IN DAC 100
	}
	IF ((![vdvProj,PROJ_POW_ON] && (BUTTON.INPUT.CHANNEL <> 14) && (BUTTON.INPUT.CHANNEL <> 15))) // IF PROJ IS OFF AND SOURCE IS NOT CASSETTE OR TURNTABLE
	{
	    //SEND_STRING dvROUTER,"PROJ1_CMD[PON]"                    // TURN IT ON
	    SEND_COMMAND vdvProj,'PON'
	    
	    SEND_COMMAND vdvTP,"'PPON-PROJ WAIT'"
	    SEND_COMMAND vdvTP,"'TEXT2-PROJECTOR IS WARMING UP'"
	    
	    SYSTEM_CALL[1] 'SCREEN2' (0,0,1,0,dvRELAY,2,1,0,0)       // SCREEN1 IS DOWN
	    
	    CANCEL_WAIT_UNTIL 'PROJ COOL'
	    
	    WAIT_UNTIL ([vdvProj,PROJ_POW_ON]=1) 'PROJ WARM'   // WAIT UNTIL PROJECTOR IS ON - BUT NOT LONGER THAN 48 SECS
	    {
		SEND_COMMAND vdvTP,"'PPOF-PROJ WAIT'"
		SEND_STRING dvROUTER,"ITOA(SOURCE),'!'"
		
		IF(SOURCE_BUTTON<=9) // IF SOURCE IS RGB
		{
		    PULSE[vdvProj,PROJ_RGB1_IN]
		    IF(SystemName[SYSTEM_NUMBER] = 'DOWNEY 113')
		    {
			SEND_STRING LIGHTS,"':PS,0,2',13"
			SEND_STRING LIGHTS,"':PS,1,2',13"
			SEND_STRING LIGHTS,"':PS,2,2',13"
			SEND_STRING LIGHTS,"':PS,3,2',13"
			SEND_STRING LIGHTS,"':PS,4,2',13"
			SEND_STRING LIGHTS,"':PS,5,2',13"
		    }
		}
		ELSE // SOURCE IS VID
		{
		    PULSE[vdvProj,PROJ_VID_IN]
		    IF(SystemName[SYSTEM_NUMBER] = 'DOWNEY 113')
		    {
			SEND_STRING LIGHTS,"':PS,0,3',13"
			SEND_STRING LIGHTS,"':PS,1,3',13"
			SEND_STRING LIGHTS,"':PS,2,3',13"
			SEND_STRING LIGHTS,"':PS,3,3',13"
			SEND_STRING LIGHTS,"':PS,4,3',13"
			SEND_STRING LIGHTS,"':PS,5,3',13"
		    }

		}
	    }
	}
	ELSE IF([dvROUTER,MUTE_STAT])
	{
	    //SEND_STRING dvROUTER,"PROJ1_CMD[MOF]"                    // TURN MUTE OFF
	    OFF[vdvProj,PROJ_MUTE]
	    WAIT 20
	    {
		SEND_STRING dvROUTER,"ITOA(SOURCE),'!'"
		IF(SOURCE_BUTTON<=9) // IF SOURCE IS RGB
		{
		    PULSE[vdvProj,PROJ_RGB1_IN]
		    IF(SystemName[SYSTEM_NUMBER] = 'DOWNEY 113')
		    {
			SEND_STRING LIGHTS,"':PS,0,2',13"
			SEND_STRING LIGHTS,"':PS,1,2',13"
			SEND_STRING LIGHTS,"':PS,2,2',13"
			SEND_STRING LIGHTS,"':PS,3,2',13"
			SEND_STRING LIGHTS,"':PS,4,2',13"
			SEND_STRING LIGHTS,"':PS,5,2',13"
		    }
		}
		ELSE // SOURCE IS VID
		{
		    PULSE[vdvProj,PROJ_VID_IN]
		    IF(SystemName[SYSTEM_NUMBER] = 'DOWNEY 113')
		    {
			SEND_STRING LIGHTS,"':PS,0,3',13"
			SEND_STRING LIGHTS,"':PS,1,3',13"
			SEND_STRING LIGHTS,"':PS,2,3',13"
			SEND_STRING LIGHTS,"':PS,3,3',13"
			SEND_STRING LIGHTS,"':PS,4,3',13"
			SEND_STRING LIGHTS,"':PS,5,3',13"
		    }
		}
	    }
	}
	ELSE
	{
	    SEND_STRING dvROUTER,"ITOA(SOURCE),'!'"
	    IF(SOURCE_BUTTON<=9) // IF SOURCE IS RGB
	    {
		PULSE[vdvProj,PROJ_RGB1_IN]
		IF(SystemName[SYSTEM_NUMBER] = 'DOWNEY 113')
		{
		    SEND_STRING LIGHTS,"':PS,0,2',13"
		    SEND_STRING LIGHTS,"':PS,1,2',13"
		    SEND_STRING LIGHTS,"':PS,2,2',13"
		    SEND_STRING LIGHTS,"':PS,3,2',13"
		    SEND_STRING LIGHTS,"':PS,4,2',13"
		    SEND_STRING LIGHTS,"':PS,5,2',13"
		}
	    }
	    ELSE // SOURCE IS VID
	    {
		PULSE[vdvProj,PROJ_VID_IN]
		IF(SystemName[SYSTEM_NUMBER] = 'DOWNEY 113')
		{
		    SEND_STRING LIGHTS,"':PS,0,3',13"
		    SEND_STRING LIGHTS,"':PS,1,3',13"
		    SEND_STRING LIGHTS,"':PS,2,3',13"
		    SEND_STRING LIGHTS,"':PS,3,3',13"
		    SEND_STRING LIGHTS,"':PS,4,3',13"
		    SEND_STRING LIGHTS,"':PS,5,3',13"
		}
	    }
	}
	IF ((![vdvProj2,PROJ_POW_ON] && (BUTTON.INPUT.CHANNEL <> 14) && (SystemName[SYSTEM_NUMBER] = 'PAC 002') && (BUTTON.INPUT.CHANNEL <> 15))) // IF PROJ2 IS OFF AND SOURCE IS NOT CASSETTE OR TURNTABLE
	{
	    SEND_COMMAND vdvProj2,'PON'
	    //SEND_STRING dvPROJ2,"PROJ2_CMD[PON]"
	    //ON[dvPROJ2,POWER_STAT]
	    SYSTEM_CALL[3] 'SCREEN2' (0,0,1,0,dvRELAY,6,5,0,0)     // SCREEN2 IS DOWN
	    WAIT_UNTIL ([vdvProj2,PROJ_POW_ON]=1) 'PROJ2 WAIT'
	    {    (* VIDEO SOURCES *)
		IF((SOURCE = 3) || (SOURCE = 4) || (SOURCE = 6) || (SOURCE = 8))
		PULSE[vdvProj2,PROJ_RGB1_IN]
		//SEND_STRING dvPROJ2,"PROJ2_CMD[SVIDEO]"
		ELSE
		PULSE[vdvProj2,PROJ_RGB1_IN]
		//SEND_STRING dvPROJ2,"PROJ2_CMD[RGB1]"
	    }
	}
	ELSE
	{
	    OFF[vdvProj2,PROJ_MUTE]
	    //SEND_STRING dvPROJ2,"PROJ2_CMD[MOF]"
	    //PROJ2_MUTE = FALSE
	    WAIT 20
	    {
		IF((SOURCE = 3) || (SOURCE = 4) || (SOURCE = 6) || (SOURCE = 8))
		PULSE[vdvProj2,PROJ_RGB1_IN]
		//SEND_STRING dvPROJ2,"PROJ2_CMD[SVIDEO]"
		ELSE
		PULSE[vdvProj2,PROJ_RGB1_IN]
		//SEND_STRING dvPROJ2,"PROJ2_CMD[RGB1]"
	    }
	}
    }
}
BUTTON_EVENT[dcSource2]			//DOWNEY 100 PUSH PANEL CONTROLS
{
    PUSH:
    {
	SOURCE_D100 = GET_LAST(dcSource2)
	ON[dv16,BUTTON.INPUT.CHANNEL]
      
	IF((GET_LAST(dcSource2) = 4) OR (GET_LAST(dcSource2) = 5))
	{
	    PULSE[dvVCR,27]       // POWER ON
	    DOWNEY_VCR_FLAG=1
	}
	IF(GET_LAST(dcSource2) = 3)
	{
	    DOWNEY_VCR_FLAG=0
	}
	SOURCE_BUTTON_DOWNEY_100 = BUTTON.INPUT.CHANNEL
        
	IF (![vdvProj,PROJ_POW_ON])
	{
	    SEND_COMMAND vdvProj,'PON'
	    //SEND_COMMAND vdvTP,"'PPON-PROJ WAIT'"
	    //SEND_COMMAND vdvTP,"'TEXT2-PROJECTOR IS WARMING UP'"
	    //SYSTEM_CALL[1] 'SCREEN2' (0,0,1,0,dvRELAY,2,1,0,0)       // SCREEN1 IS DOWN
	    
	    CANCEL_WAIT_UNTIL 'PROJ COOL'
	    
	    WAIT_UNTIL ([vdvProj,PROJ_POW_ON]=1) 'PROJ WARM'   // WAIT UNTIL PROJECTOR IS ON - BUT NOT LONGER THAN 48 SECS
	    {
		//SEND_COMMAND vdvTP,"'PPOF-PROJ WAIT'"
		SEND_STRING dvROUTER,"ITOA(SOURCE_D100),'!'"
		
		IF((SOURCE_D100 = 1) || (SOURCE_D100 = 2) || (SOURCE_D100 = 6)) // IF SOURCE IS RGB
		{
		    PULSE[vdvProj,PROJ_RGB1_IN]
		}
		ELSE // SOURCE IS VID
		{
		    PULSE[vdvProj,PROJ_VID_IN]
		}
	    }
	}
	ELSE IF([dvROUTER,MUTE_STAT])
	{		
	    //SEND_STRING dvROUTER,"PROJ1_CMD[MOF]"                    // TURN MUTE OFF
	    OFF[vdvProj,PROJ_MUTE]
	    WAIT 20
	    {
		SEND_STRING dvROUTER,"ITOA(SOURCE_D100),'!'"
		IF((SOURCE_D100 = 1) || (SOURCE_D100 = 2) || (SOURCE_D100 = 6)) // IF SOURCE IS RGB
		{
		    PULSE[vdvProj,PROJ_RGB1_IN]
		}
		ELSE // SOURCE IS VID
		{
		    PULSE[vdvProj,PROJ_VID_IN]
		}
	    }
	}
	ELSE
	{
	    SEND_STRING dvROUTER,"ITOA(SOURCE_D100),'!'"
	    IF((SOURCE_D100 = 1) || (SOURCE_D100 = 2) || (SOURCE_D100 = 6)) // IF SOURCE IS RGB
	    {
		PULSE[vdvProj,PROJ_RGB1_IN]
	    }
	    ELSE // SOURCE IS VID
	    {
		PULSE[vdvProj,PROJ_VID_IN]
	    }
	}
    }
}

BUTTON_EVENT[dcDowneyTransportControl]
{
    PUSH:
    {
	TRANSPORT = GET_LAST(dcDowneyTransportControl)
	ON[dv16,BUTTON.INPUT.CHANNEL]
	
	IF(DOWNEY_VCR_FLAG=1)
	{
	    PULSE[dvVCR,TRANSPORT]
	}
	ELSE
	{
	    PULSE[dvDVD,TRANSPORT]
	}
    }
}
BUTTON_EVENT[dcPopUp]                           // THESE BUTTONS ARE FOR SYNCHRONIZATION OF THE POPUPS ON THE WEB PAGES
{
    PUSH:
    {
        SEND_COMMAND vdvTP,"POP_LOOKUP[BUTTON.INPUT.CHANNEL - 66]"
        ENVIRONMENT = BUTTON.INPUT.CHANNEL
        IF((BUTTON.INPUT.CHANNEL >= 80) && (BUTTON.INPUT.CHANNEL <= 83))
        {
            POP_FDBK = GET_LAST(dcPopUp)
            SOURCE = 0
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
    // SEND_STRING dvROUTER,"PROJ1_CMD[PON]"
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
    
    WAIT_UNTIL ([vdvProj,PROJ_POW_OFF]) 'PROJ COOL'
    {
      SEND_COMMAND vdvTP,"'PPOF-PROJ WAIT'"
    }
  }
}

BUTTON_EVENT[dv16,8]				// STACKED PROJ MUTE FOR DOWNEY 100
BUTTON_EVENT[vdvTP,120]                         // PROJ1 TOGGLE MUTE
{
  PUSH:
  {
    [vdvProj,PROJ_MUTE] = ![vdvProj,PROJ_MUTE]
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
    
    WAIT_UNTIL ([vdvProj2,PROJ_POW_OFF]) 'PROJ COOL'
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

BUTTON_EVENT[dcDvdSkip]                         // DVD FORWARD & REVERSE SKIP CHANNELS 4 & 5
{
    PUSH:
    {
        SET_PULSE_TIME(2)
        PULSE[dvDVD,(GET_LAST(dcDvdSkip) + 3)]
        PULSE[dvDVD,(GET_LAST(dcDvdSkip) + 243)]
        SET_PULSE_TIME(5)
    }    
}

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

BUTTON_EVENT[vdvTP,VCR_FFWD]
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

BUTTON_EVENT[vdvTP,VCR_REW]
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

TIMELINE_EVENT[TL_VCR_TIMEOUT]  // IT'S BEEN 2 HOURS - THE TAPE/CLASS SHOULD HAVE BEEN DONE ALREADY
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

TIMELINE_EVENT[TL_DVD_TIMEOUT]  // IT'S BEEN 2 HOURS - THE DVD/CLASS SHOULD HAVE BEEN DONE ALREADY
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

TIMELINE_EVENT[TL_CAS_TIMEOUT]
{
  //CASSETTE
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

TIMELINE_EVENT[TL_TTB_TIMEOUT]
{
  //TURNTABLE
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
TIMELINE_EVENT[TL_DISP_REFRESH]
{
  SEND_COMMAND vdvTP,"'TEXT13-', ITOA(AUDIT_VCR_SEC/3600),' Hrs|',ITOA((AUDIT_VCR_SEC%3600)/60),' Mins'" // VCR TIME
  SEND_COMMAND vdvTP,"'TEXT14-', ITOA(AUDIT_DVD_SEC/3600),' Hrs|',ITOA((AUDIT_DVD_SEC%3600)/60),' Mins'" // DVD TIME
  SEND_COMMAND vdvTP,"'TEXT15-|',ITOA(AUDIT_CAS_SEC/3600),' Hrs ',ITOA((AUDIT_CAS_SEC%3600)/60),' Mins'" // CAS TIME
  SEND_COMMAND vdvTP,"'TEXT16-|',ITOA(AUDIT_TTB_SEC/3600),' Hrs ',ITOA((AUDIT_TTB_SEC%3600)/60),' Mins'" // TTB TIME
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
    SEND_STRING dvROUTER,"ITOA(SOURCE),'!'"
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
        TIMELINE_RELOAD(TL_AUTO_OFF,lAutoTimes,2)
      }
      case 4:
      {
        lAutoTimes[1] = 1800000               // 30 min
        TIMELINE_RELOAD(TL_AUTO_OFF,lAutoTimes,2)
      }
      case 5:
      {
        lAutoTimes[1] = 3600000               // 60 min
        TIMELINE_RELOAD(TL_AUTO_OFF,lAutoTimes,2)
      }
      case 6:
      {
        lAutoTimes[2] = 300000                // 5 min
        TIMELINE_RELOAD(TL_AUTO_OFF,lAutoTimes,2)
      }
      case 7:
      {
        lAutoTimes[2] = 600000                // 10 min
        TIMELINE_RELOAD(TL_AUTO_OFF,lAutoTimes,2)
      }
      case 8:
      {
        lAutoTimes[2] = 900000                // 15 min
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

(* DVD TRANSPORT CONTROLS
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
*)

BUTTON_EVENT[vdvTP,DVD_MENU]
{
    PUSH:
    {
        SET_PULSE_TIME(2)
        PULSE[dvDVD,44]
        SET_PULSE_TIME(5)
    }//END PUSH
}//END BUTTON EVENT

BUTTON_EVENT[vdvTP,DVD_up]
{
    PUSH:
    {
        SET_PULSE_TIME(2)
        PULSE[dvDVD,45]
        SET_PULSE_TIME(5)
    }//END PUSH
}//END BUTTON EVENT

BUTTON_EVENT[vdvTP,DVD_down]
{
    PUSH:
    {
        SET_PULSE_TIME(2)
        PULSE[dvDVD,46]
        SET_PULSE_TIME(5)
    }//END PUSH
}//END BUTTON EVENT

BUTTON_EVENT[vdvTP,DVD_left]
{
    PUSH:
    {
        SET_PULSE_TIME(2)
        PULSE[dvDVD,47]
        SET_PULSE_TIME(5)
    }//END PUSH
}//END BUTTON EVENT

BUTTON_EVENT[vdvTP,DVD_right]
{
    PUSH:
    {
        SET_PULSE_TIME(2)
        PULSE[dvDVD,48]
        SET_PULSE_TIME(5)
    }//END PUSH
}//END BUTTON EVENT

BUTTON_EVENT[vdvTP,DVD_enter]
{
    PUSH:
    {
        SET_PULSE_TIME(2)
        PULSE[dvDVD,49]
        SET_PULSE_TIME(5)
    }//END PUSH
}//END BUTTON EVENT

BUTTON_EVENT[vdvTP,151]
{
    PUSH:
    {
        IF(SystemName[SYSTEM_NUMBER] = 'DOWNEY 113')
	{
	    NEAR_BOARD=!NEAR_BOARD
	    IF(NEAR_BOARD)
	    SEND_STRING LIGHTS,"'XC,1,100',$0D"
	    ELSE
	    SEND_STRING LIGHTS,"'XC,1,0',$0D"
	}
	ELSE
	{
	    SEND_STRING LIGHTS,"':A11',$0D"
	}    
    }
}

BUTTON_EVENT[vdvTP,152]
{
    PUSH:
    {
        IF(SystemName[SYSTEM_NUMBER] = 'DOWNEY 113')
	{
	    SEND_STRING LIGHTS,"':BSTP,2,RAISE',13"
	}
	ELSE
	{
	    SEND_STRING LIGHTS,"':A21',$0D"
	}    
    }
    RELEASE:
    {
	IF(SystemName[SYSTEM_NUMBER] = 'DOWNEY 113')
	{
	    SEND_STRING LIGHTS,"':ESTP',13"
	}
    }
}

BUTTON_EVENT[vdvTP,153]
{
    PUSH:
    {
        IF(SystemName[SYSTEM_NUMBER] = 'DOWNEY 113')
	{
	    SEND_STRING LIGHTS,"':BSTP,2,LOWER',13"
	}
	ELSE
	{
	    SEND_STRING LIGHTS,"':A31',$0D"
	}    
    }
    RELEASE:
    {
	IF(SystemName[SYSTEM_NUMBER] = 'DOWNEY 113')
	{
	    SEND_STRING LIGHTS,"':ESTP',13"
	}
    }
}

BUTTON_EVENT[vdvTP,154]
{
    PUSH:
    {
        
	IF(SystemName[SYSTEM_NUMBER] = 'DOWNEY 113')
	{
	    FAR_BOARD=!FAR_BOARD
	    IF(FAR_BOARD)
	    SEND_STRING LIGHTS,"'XC,0,100',$0D"
	    ELSE
	    SEND_STRING LIGHTS,"'XC,0,0',$0D"
	}
	ELSE
	{
	    SEND_STRING LIGHTS,"':A41',$0D"
	}    
    }
}

BUTTON_EVENT[vdvTP,155]
{
    PUSH:
    {
        SEND_STRING LIGHTS,"':A01',$0D"
    }
}


(***********************************************************)
(*            THE ACTUAL PROGRAM GOES BELOW                *)
(***********************************************************)
DEFINE_PROGRAM
(***********************************************************************************)
(******************************FEEDBACK*********************************************)
(***********************************************************************************)

[vdvTP,nAutoTimeAdjust[3]] = lAutoTimes[1] = 900000
[vdvTP,nAutoTimeAdjust[4]] = lAutoTimes[1] = 1800000
[vdvTP,nAutoTimeAdjust[5]] = lAutoTimes[1] = 3600000
[vdvTP,nAutoTimeAdjust[6]] = lAutoTimes[2] = 300000
[vdvTP,nAutoTimeAdjust[7]] = lAutoTimes[2] = 600000
[vdvTP,nAutoTimeAdjust[8]] = lAutoTimes[2] = 900000

[dcINPUTS[1]]   = SOURCE = 1
[dcINPUTS[2]]   = SOURCE = 2
[dcINPUTS[3]]   = SOURCE = 3
[dcINPUTS[4]]   = SOURCE = 4
[dcINPUTS[5]]   = SOURCE = 5
[dcINPUTS[6]]   = SOURCE = 6
[dcINPUTS[7]]   = SOURCE = 7
[dcINPUTS[8]]   = SOURCE = 8
[dcINPUTS[9]]   = SOURCE = 9
[dcINPUTS[10]]  = SOURCE = 10

[vdvTP,27] = [vdvProj,PROJ_POW_ON]                  // FEEDBACK FOR PROJ1 PWR ON
[vdvTP,55] = [vdvProj,PROJ_POW_OFF]                 // FEEDBACK FOR PROJ1 PWR OFF
[vdvTP,29] = [vdvProj,PROJ_MUTE]                    // FEEDBACK FOR PROJ1 MUTE ON
[dv16,8] = [vdvProj,PROJ_MUTE]                    // FEEDBACK FOR PROJ1 MUTE ON
[vdvTP,30] = ![vdvProj,PROJ_MUTE]                   // FEEDBACK FOR PROJ1 MUTE OFF
[vdvTP,120] = ([vdvProj,PROJ_MUTE] AND BLINK)       // FEEDBACK FOR PROJ 1 TOGGLE MUTE
[vdvTP,31] = [vdvProj2,PROJ_POW_ON]                   // FEEDBACK FOR PROJ2 PWR ON
[vdvTP,56] = [vdvProj2,PROJ_POW_OFF]                  // FEEDBACK FOR PROJ2 PWR OFF
[vdvTP,33] = [vdvProj2,PROJ_MUTE]                    // FEEDBACK FOR PROJ2 MUTE ON
[vdvTP,34] = ![vdvProj2,PROJ_MUTE]                   // FEEDBACK FOR PROJ2 MUTE OFF

[vdvTP,80] = (POP_FDBK = 1)                         // FEEDBACK FOR SELECT BUTTONS
[vdvTP,81] = (POP_FDBK = 2)
[vdvTP,82] = (POP_FDBK = 3)
[vdvTP,83] = (POP_FDBK = 4)

[vdvTP,87] = (ENVIRONMENT = 87)                     // FEEDBACK FOR SCREEN BUTTON
[vdvTP,88] = (ENVIRONMENT = 88)                     // FEEDBACK FOR VOLUME BUTTON
[vdvTP,90] = (ENVIRONMENT = 90)                     // FEEDBACK FOR PROJECTOR BUTTON

IF(SystemName[SYSTEM_NUMBER] <> 'DAC 100')
{  
  [vdvTP,3] = (SOURCE = LOOKUP[1])                  // FEEDBACK FOR PC SELECTS
  [vdvTP,4] = (SOURCE = LOOKUP[2])
}
ELSE
{
  [vdvTP,3] = ((SOURCE = LOOKUP[1]) && (DACPC = 3)) // FEEDBACK FOR PC SELECTS IN DAC 100
  [vdvTP,4] = ((SOURCE = LOOKUP[2]) && (DACPC = 4))
}    
[vdvTP,5] = (SOURCE = LOOKUP[3])
[vdvTP,6] = (SOURCE = LOOKUP[4])
[vdvTP,7] = (SOURCE = LOOKUP[5])
[vdvTP,8] = (SOURCE = LOOKUP[6])
[vdvTP,9] = (SOURCE = LOOKUP[7])
[vdvTP,10] = (SOURCE = LOOKUP[8])
[vdvTP,11] = (SOURCE = LOOKUP[9])
[vdvTP,12] = (SOURCE = LOOKUP[10])
[vdvTP,13] = (SOURCE = LOOKUP[11])
[vdvTP,14] = (SOURCE = LOOKUP[CASS])
[vdvTP,15] = (SOURCE = LOOKUP[TURNTABLE])
[vdvTP,16] = (SOURCE = LOOKUP[VCR_CC])

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

(* VOLUME CONTROLS *)

SYSTEM_CALL 'VOL1' (vdvTP,35,36,37,dvVOLUME,1,2,3)
SYSTEM_CALL 'VOL1' (dv16,15,16,0,dvVOLUME,1,2,0)
SEND_LEVEL vdvTP,1,VOL_LVL
SEND_LEVEL dv16,2,VOL_LVL

(* SCREEN CONTROLS *)

SYSTEM_CALL[1] 'SCREEN2' (vdvTP,20,22,21,dvRELAY,2,1,0,0)
SYSTEM_CALL[2] 'SCREEN2' (vdvTP,23,25,24,dvRELAY,4,3,0,0)
SYSTEM_CALL[3] 'SCREEN2' (vdvTP,17,19,18,dvRELAY,6,5,0,0)

(******************************)
(**** DEVICE CONTROLS *********)
(******************************)
(*
(* VCR TRANSPORT CONTROLS *)
VCR_PLAY        = 40
VCR_STOP        = 41
VCR_PAUSE       = 42
VCR_FFWD        = 43
VCR_REW         = 44
VCR_SFWD        = 45
VCR_SREV        = 46
VCR_REC         = 47
*)
(* VCR *)
SYSTEM_CALL[dvVCR] 'VCR1' (dvVCR,vdvTP,VCR_PLAY,VCR_STOP,VCR_PAUSE,0,0,
                            0,0,VCR_REC,0)
PUSH[vdvTP,VCR_PLAY]
PUSH[vdvTP,VCR_PAUSE]
PUSH[vdvTP,VCR_FFWD]
PUSH[vdvTP,VCR_REW]
PUSH[vdvTP,VCR_SFWD]
PUSH[vdvTP,VCR_SREV]
PUSH[vdvTP,VCR_REC]
{
  IF(!VCR_START) // START COUNTING SECONDS, IF WE AREN'T ALREADY
  {
    VCR_START = TOD_IN_SECONDS()
  }
  
  IF(TIMELINE_ACTIVE(TL_VCR_TIMEOUT)) // RESET TIMOUT TIMELINE, IF IT'S RUNNING
  {
    TIMELINE_SET(TL_VCR_TIMEOUT,0)
  }
  ELSE // OTHERWISE, START THE TIMEOUT TIMELINE
  {
    lTimeArray[1] = 7200000  // 2 HOUR TIMEOUT
    TIMELINE_CREATE(TL_VCR_TIMEOUT,lTimeArray,1,TIMELINE_ABSOLUTE,TIMELINE_ONCE)
  }
}
PUSH[vdvTP,VCR_STOP]
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
    
    VCR_START = 0 // THIS WILL CAUSE A BUG IF THE OPERATOR HITS A TRANSPORT COMMAND AT EXACTLY MIDNIGHT
  }
  IF(TIMELINE_ACTIVE(TL_VCR_TIMEOUT)) // KILL THE TIMEOUT TOO
  {
    TIMELINE_KILL(TL_VCR_TIMEOUT)
  }
}

(* DVD TRANSPORT CONTROLS
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
*)

(* DVD *)
SYSTEM_CALL[dvDVD] 'DVD1' (dvDVD,vdvTP,DVD_PLAY,DVD_STOP,DVD_PAUSE,0,0,DVD_FSCAN,DVD_RSCAN ,0)
PUSH[vdvTP,DVD_PLAY]
PUSH[vdvTP,DVD_PAUSE]
PUSH[vdvTP,DVD_FSCAN]
PUSH[vdvTP,DVD_RSCAN]
PUSH[vdvTP,DVD_FSKIP]
PUSH[vdvTP,DVD_RSKIP]
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
PUSH[vdvTP,DVD_STOP]
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
    
    DVD_START = 0 // THIS WILL CAUSE A BUG IF THE OPERATOR HITS A TRANSPORT COMMAND AT EXACTLY MIDNIGHT
  }
  IF(TIMELINE_ACTIVE(TL_DVD_TIMEOUT)) // KILL THE TIMEOUT TOO
  {
    TIMELINE_KILL(TL_DVD_TIMEOUT)
  }
}

IF(LENGTH_STRING(TP_BUFFER))
{
    CALL 'PARSE TP'
}

IF(LENGTH_STRING(ROUTER_BUFFER))
{
    CALL 'PARSE SYS10' (ROUTER_BUFFER)
}

IF(LENGTH_STRING(PROJ2_BUFFER))
{
    IF(DEBUG)
    {
        SEND_STRING dvDVDEBUG,"'PROJECTOR RESPONSE - ',PROJ2_BUFFER,13,10"
    }    
    CLEAR_BUFFER PROJ2_BUFFER
}

IF ((TOD_IN_SECONDS() + (lAutoTimes[1]/1000) + (lAutoTimes[2]/1000)) % GOING_ON_MIDNIGHT = lAutoTime)
{
  TIMELINE_CREATE(TL_AUTO_OFF,lAutoTimes,2,TIMELINE_RELATIVE,TIMELINE_ONCE)
}

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


(*(* PROJECTOR 2 TIMER *)
IF(TEMP_TIME2 <> TIME)
{
    TEMP_TIME2 = TIME
    IF([dvPROJ2,POWER_STAT])
    {
        LAMP_SECONDS2 = (LAMP_SECONDS2 + 1)
        IF(LAMP_SECONDS2 = 60)
        {
            LAMP_SECONDS2 = 0
            LAMP_MINUTES2 = LAMP_MINUTES2 + 1
            SEND_COMMAND vdvTP,"'TEXT12-Hrs: ',ITOA(LAMP_HOURS2),'  Mins: ',ITOA(LAMP_MINUTES2)"
            IF(LAMP_MINUTES2 = 60)
            {
                LAMP_MINUTES2 = 0
                LAMP_HOURS2 = LAMP_HOURS2 + 1
            }
        }
    }
}*)

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

WAIT 3
{
  BLINK = !BLINK
}

[vdvtp,107] = mailsent


(***********************************************************)
(*                     END OF PROGRAM                      *)
(*        DO NOT PUT ANY CODE BELOW THIS COMMENT           *)
(***********************************************************)

