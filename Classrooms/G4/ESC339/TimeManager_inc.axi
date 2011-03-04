(*********************************************************************)
(*  AMX Corporation                                                  *)
(*  Copyright (c) 2000 - 2002 AMX Corporation. All rights reserved.  *)
(*********************************************************************)
(*   please refer to EULA.TXT for software license agreement         *)
(*********************************************************************)
(*                                                                   *)
(*                      i!-TimeManager  (1.0.10)                     *)
(*                                                                   *)
(*********************************************************************)
PROGRAM_NAME='TimeManager_inc'

DEFINE_DEVICE

vdvTmEvents       = 34001:4:0
dvTmTimeSync      = 0:4:0

DEFINE_CONSTANT

(* Timeserver protocols *)
nProtoNone        = 0
nProtoDaytime     = 1
nProtoTime        = 2
nProtoSNTP        = 3
nProtoSNTPBCast   = 4

(* Channels *)
nTmSunriseChannel     = 1
nTmSunsetChannel      = 2
nTmDstChannel         = 3
nTmTimeChangeChannel  = 4

(* Levels *)
nTmGmtEffLevel        = 1
nTmGmtLevel           = 2
nTmLongLevel          = 3
nTmLatLevel           = 4





DEFINE_VARIABLE

(* Timezone *)
CHAR    dTmTzName[100]
CHAR    dTmTzDesc[10]
DOUBLE  dTmTzGmtOffset
CHAR    strTmTzDstRules[1000]

(* Location *)
CHAR    strTmLocName[100]
DOUBLE  dTmLocLong
DOUBLE  dTmLocLat

(* Timeserver *)
INTEGER nTmTsProtocol
INTEGER nTmTsCheckTime
CHAR    strTmTsServer[100]


(*           SUBROUTINE DEFINITIONS       *)

DEFINE_START

(***********************************************************)
(* Step 1 - Configure the timezone:                        *)
(***********************************************************)

// Configure Timezone
// Parameter 1: Timezone Name.  ex: "Eastern"
// Parameter 2: Timezone description.  ex: "E%sT"
// Parameter 3: Timezone GMT offset in hours.  ex: -5.0
dTmTzName     = 'Eastern'
dTmTzDesc     = 'E%sT'
dTmTzGmtOffset = -5.0

// Configure Timezone Rules *)
// Parameter 1: Daylight savings string.  ex: "None", "US" or custom.
// Custom string: "Month" "DayDescription" "Time" "Offset From Std" "Descrption"
//                "Month":          Month name ex: "Apr"
//                "Time"            Time to activate (hh:mm:ss, 24 hour).  ex: "02:00:00"
//                "Offset From Std" Time to offset from GMT (hh:mm:ss, 24 hour).  ex: "01:00:00"
//                "Description"     String to replace "%s" with in Timezone description.  ex: 'D'
//                "DayDescription"  Day Description. Fixed Date, Last Day Of Week or
//                                  First Day of Week Before/After Date
//                                  Fixed ex: "15"
//                                  Last Day of Week ex: "LastSunday"
//                                  First Day of Week Beforer DATE-ex: "Sun<=24"
//                                  First Day of Week After DATE-ex: "Sun>=1"
strTmTzDstRules = 'US'

(***********************************************************)
(* Step 2 - Configure Physical Location:                   *)
(***********************************************************)

// Configure Physical Location
// Parameter 1: Location Name.  ex: 'Seattle'
// Parameter 2: Location Longitude.  ex: -122.33 (>0 == East, < 0 == West)
// Parameter 3: Location Latitude.  ex: 47.6 (>0 == North, < 0 == South)
strTmLocName   = 'Middletown'
dTmLocLong = -72.66
dTmLocLat =  41.55

// You can find longitude/latitude values and descriptions at: 
// http://geography.about.com/cs/latitudelongitude/
// http://www.census.gov/cgi-bin/gazetteer
// http://www.njdxa.org/landl-lookup-dx.shtml

(***********************************************************)
(* Step 3 - Configure Time servers:                        *)
(***********************************************************)

// Configure Time servers
// Parameter 1: Protocol, 0=Disbaled, 1=DayTime(13/udp, 13/tcp), 2=Time(37/udp, 37/tcp), 3=SNTP(123/udp), 4=SNTP Broadcast (137/udp).  ex: 2
// Parameter 3: Default Server.  ex: 'mytimeserver.mydomain.com'.  Leave blank to read from time sevrer file (time/nist_svr.lst)
// Parameter 2: Check Time interval in seconds.  Use 0 for default (2 hours).  ex: 3600
// Parameter 4: Prefered Index of Timeservers in list.  ex: 2
// Notes:       If parameters 3 is supplied, parameter 4 is ignored
//              If paramater 3 is an empty string and parameter 4 is 0, a default will be picked from the list is possible

//nProtoNone       = 0
//nProtoDaytime    = 1
//nProtoTime       = 2
//nProtoSNTP       = 3
//nProtoSNTPBCast  = 4
nTmTsProtocol   = nProtoSNTP
nTmTsCheckTime  = 60
strTmTsServer   = ''

(***********************************************************)
(* Alternate Manual Timezone configurations:               *)
(***********************************************************)

// These are shown for example purposes and represent information that is not guaranteed to be correct!

// Here is an exmaple configuration for Santiago, Chile which is -4 hours behind GMT and observes Daylight savings starting
// on the Saturday on or after October 9th at midnight (jump ahead 1 hour) and the Saturday on or after the 9th of March at midnight (jump back 1 hour)
// and describes the time as "hh:mm:ss CST" or "hh:mm:ss CDT" depending on Daylight savings and is located at "33s27, 70w40":
//
//dTmTzName     = 'Santiago'
//dTmTzDesc     = 'C%sT'
//dTmTzGmtOffset = -4.0
//strTmTzDstRules = "'Oct Sat>=9 00:00:00 01:00:00 D',$FF,'Mar Sat>=9 00:00:00 00:00:00 S'"
//
// AND
//
//strTmLocName  = 'Santiago'
//dTmLocLong = -70.67
//dTmLocLat = -33.45

// Here is an exmaple configuration for Sydney, Australia which is +10 hours ahead of GMT and observes Daylight savings starting
// on the Last Sunday in October 2:00 AM (jump ahead 1 hour) and the Last Sunday in March at 3:00 AM (jump back 1 hour)
// and describes the time as "hh:mm:ss EST" regardless of Daylight savings and is located at "33s52, 151e13":
//
//dTmTzName     = 'Sydney'
//dTmTzDesc     = 'EST'
//dTmTzGmtOffset = 10.0
//strTmTzDstRules = "'Oct LastSun 02:00:00 01:00:00 X',$FF,'Mar LastSun 03:00:00 00:00:00 X'"
//
// AND
//
//strTmLocName  = 'Sydney'
//dTmLocLong = 151.22
//dTmLocLat = -33.86

// Here is the example configuration for London, England which uses GMT and observes Daylight savings starting
// on the last Sunday in March at 1:00 AM (jump ahead 1 hour) and the Last Sunday in October at 2:00 AM (jump back 1 hour)
// and describes the time as "hh:mm:ss BST" or "hh:mm:ss GMT" depending on Daylight savings and is located at "51n30, 0w10":
//
//dTmTzName     = 'London'
//dTmTzDesc     = '%s'
//dTmTzGmtOffset = 0.0
//strTmTzDstRules = "'Mar LastSun 01:00:00 01:00:00 BST',$FF,'Oct LastSun 02:00:00 00:00:00 GMT'"
//
// AND
//
//strTmLocName  = 'London'
//dTmLocLong = -0.16
//dTmLocLat = 51.50

(***********************************************************)
(*            THE MODULE CODE GOES BELOW                   *)
(***********************************************************)
DEFINE_MODULE 'i!-TimeManagerMod' mdlTM(vdvTmEvents,
                                        dvTmTimeSync,
                                        (* Timezone *)
                                        dTmTzName,
                                        dTmTzDesc,
                                        dTmTzGmtOffset,
                                        strTmTzDstRules,
                                        (* Location *)
                                        strTmLocName,
                                        dTmLocLong,
                                        dTmLocLat,
                                        (* Timeserver *)
                                        nTmTsProtocol,
                                        nTmTsCheckTime,
                                        strTmTsServer)

(***********************************************************)
(*                THE EVENTS GOES BELOW                    *)
(***********************************************************)
DEFINE_EVENT
(*
(***********************************************************)
(* BUTTON_EVENT: Sunrise Channel                           *)
(* PURPOSE:      Channel is pushed (and turned on) when    *)
(*               the Sunrise occurs                        *)
(***********************************************************)
BUTTON_EVENT[vdvTmEvents,nTmSunriseChannel]
{
  PUSH:
  {
    SEND_STRING 0,"'Sunrise occured at ',TIME"
  }
}

(***********************************************************)
(* BUTTON_EVENT: Sunset Channel                            *)
(* PURPOSE:      Channel is pushed (and turned on) when    *)
(*               the Sunset occurs                         *)
(***********************************************************)
BUTTON_EVENT[vdvTmEvents,nTmSunsetChannel]
{
  PUSH:
  {
    SEND_STRING 0,"'Sunset occured at ',TIME"
  }
}

(***********************************************************)
(* BUTTON_EVENT: DST Activity Channel                      *)
(* PURPOSE:      Channel is pushed (and turned on) when    *)
(*               the DST rules affect a time change with   *)
(*               a non-zero time offset (DST Active)       *)
(*               Channel is release (and turned off) when  *)
(*               the DST rules affect a time change with   *)
(*               a zero time offset (DST Inactive)         *)
(***********************************************************)
BUTTON_EVENT[vdvTmEvents,nTmDstChannel]
{
  PUSH:
  {
    SEND_STRING 0,"'DST is now active: ',TIME"
  }
  RELEASE:
  {
    SEND_STRING 0,"'DST is now inactive: ',TIME"
  }
}

(***********************************************************)
(* BUTTON_EVENT: Time Change Channel                       *)
(* PURPOSE:      Channel is pushed (and pulsed) when       *)
(*               the Time is changed by a communication    *)
(*               with a time server.                       *)
(***********************************************************)

*)
BUTTON_EVENT[vdvTmEvents,nTmTimeChangeChannel]
{
  PUSH:
  {
    SEND_STRING 0,"'Time adjusted by time server.  New Time is ',TIME"
  }
}

(***********************************************************)
(* LEVEL_EVENT:  Effective GMT Offset                      *)
(* PURPOSE:      Level is sent whenever the effective GMT  *)
(*               offset is changed.  The effective offset  *)
(*               is the real GMT offset with DLS correction*)
(***********************************************************)
LEVEL_EVENT[vdvTmEvents,nTmGmtEffLevel]
{
  SEND_STRING 0,"'Effective GMT Offset=',FTOA(LEVEL.VALUE)"
}

(***********************************************************)
(* LEVEL_EVENT:  GMT Offset                                *)
(* PURPOSE:      Level is sent whenever the GMT            *)
(*               offset is changed.                        *)
(***********************************************************)
LEVEL_EVENT[vdvTmEvents,nTmGmtLevel]
{
  SEND_STRING 0,"'GMT Offset=',FTOA(LEVEL.VALUE)"
}

(***********************************************************)
(* LEVEL_EVENT:  Longitude                                 *)
(* PURPOSE:      Level is sent whenever the longitude is   *)
(*               changed.                                  *)
(***********************************************************)
LEVEL_EVENT[vdvTmEvents,nTmLongLevel]
{
  SEND_STRING 0,"'Longitude=',FTOA(LEVEL.VALUE)"
}

(***********************************************************)
(* LEVEL_EVENT:  Latitude                                  *)
(* PURPOSE:      Level is sent whenever the Latitude is    *)
(*               changed.                                  *)
(***********************************************************)
LEVEL_EVENT[vdvTmEvents,nTmLatLevel]
{
  SEND_STRING 0,"'Latitude=',FTOA(LEVEL.VALUE)"
}

(***********************************************************)
(* DATA_EVENT:   Strings for Sunrise/Sunset                *)
(* PURPOSE:      parse strings for sunrise and sunset      *)
(***********************************************************)
DATA_EVENT[vdvTmEvents]
{
  STRING:
  {
    STACK_VAR
    CHAR strUpper[30]
    CHAR strTemp[30]
    CHAR strTrash[30]
    
    strUpper = UPPER_STRING(DATA.TEXT)
    strTemp = DATA.TEXT
    strTrash = REMOVE_STRING(strTemp,'-',1)
    SELECT
    {
      (* SUNRISE *)
      ACTIVE (FIND_STRING(strUpper,'SUNRISE-',1)):
        SEND_STRING 0,"'Sunrise Time=',strTemp"
      (* SUNSET *)
      ACTIVE (FIND_STRING(strUpper,'SUNSET-',1)):
        SEND_STRING 0,"'Sunset Time=',strTemp"
      (* TIME ZONE NAME *)
      ACTIVE (FIND_STRING(strUpper,'TIMEZONE-',1)):
        SEND_STRING 0,"'Timezone=',strTemp"
      (* TIME DESCRPTION *)
      ACTIVE (FIND_STRING(strUpper,'TIMEDESC-',1)):
        SEND_STRING 0,"'Time Description=',strTemp"
      (* LOCATION *)
      ACTIVE (FIND_STRING(strUpper,'LOCATION-',1)):
        SEND_STRING 0,"'Location=',strTemp"
    }
  }
}

(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT


(***********************************************************)
(*            THE ACTUAL PROGRAM GOES BELOW                *)
(***********************************************************)
DEFINE_PROGRAM

(***********************************************************)
(*                     END OF PROGRAM                      *)
(*        DO NOT PUT ANY CODE BELOW THIS COMMENT           *)
(***********************************************************)












