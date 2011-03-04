(*********************************************************************)
(*  AMX Corporation                                                  *)
(*  Copyright (c) 2005 AMX Corporation. All rights reserved.         *)
(*********************************************************************)
(*   please refer to EULA.TXT for software license agreement         *)
(*********************************************************************)
(*                                                                   *)
(*             AMX Resource Management Suite  (2.2.30)               *)
(*                                                                   *)
(*********************************************************************)
PROGRAM_NAME='RMSCommon'
(*{{PS_SOURCE_INFO(PROGRAM STATS)                          *)
(***********************************************************)
(*  ORPHAN_FILE_PLATFORM: 1                                *)
(***********************************************************)
(*}}PS_SOURCE_INFO                                         *)
(***********************************************************)
#IF_NOT_DEFINED __RMS_COMMON__
#DEFINE __RMS_COMMON__

(***********************************************************)
(*          DEVICE NUMBER DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_DEVICE

(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT

// Version For Code
CHAR __RMS_DEV_MON_NAME__[]      = 'RMSCommon'
CHAR __RMS_DEV_MON_VERSION__[]   = '2.2.30'

// Status Types
RMS_STAT_NOT_ASSIGNED        = 1
RMS_STAT_HELP_REQUEST        = 2
RMS_STAT_ROOM_COMM_ERR       = 3
RMS_STAT_CONTROLSYSTEM_ERR   = 4
RMS_STAT_MAINTENANCE         = 5
RMS_STAT_EQUIPMENT_USAGE     = 6
RMS_STAT_NETWORK_ERR         = 7
RMS_STAT_SECURITY_ERR        = 8

// Threshold Compare Operators
RMS_COMP_NONE                = 0
RMS_COMP_LESS_THAN           = 1
RMS_COMP_LESS_THAN_EQ_TO     = 2
RMS_COMP_GREATER_THAN        = 3
RMS_COMP_GREATER_THAN_EQ_TO  = 4
RMS_COMP_EQUAL_TO            = 5
RMS_COMP_NOT_EQUAL_TO        = 6
RMS_COMP_CONTAINS            = 7
RMS_COMP_DOES_NOT_CONTAIN    = 8

// Parameter Type
RMS_PARAM_TYPE_NUMBER        = 0
RMS_PARAM_TYPE_STRING        = 1

// Units
RMS_UNIT_MINS[]               = 'Minutes'
RMS_UNIT_HOURS[]              = 'Hours'

// Tracking
RMS_DO_NOT_TRACK_CHANGES      = 0
RMS_TRACK_CHANGES             = 1

// Parameter Operation
RMS_PARAM_SET                = 0
RMS_PARAM_INC                = 1
RMS_PARAM_DEC                = 2
RMS_PARAM_MULTIPLY           = 3
RMS_PARAM_DIVIDE             = 4
RMS_PARAM_RESET              = 5
RMS_PARAM_UNCHANGED          = 6
RMS_PARAM_INITIALIZE         = 7

// parameter Reset
RMS_PARAM_CANNOT_RESET       = 0
RMS_PARAM_CAN_RESET          = 1

// Parameter Status
RMS_PARAM_INVALID            = 0
RMS_PARAM_OK                 = 1
RMS_PARAM_TRIGGERED          = 2

// Boolean
FALSE                       = 0
TRUE                        = 1

// Common Status Messages
RMS_UNKNOWN_STR[]            = 'Unknown'

RMS_DEVICE_ONLINE[]          = 'Device Online'

RMS_DEVICE_COMMS[]           = 'Device Communicating'
RMS_DEVICE_STATUS_NO[]       = 'No'
RMS_DEVICE_STATUS_YES[]      = 'Yes'
RMS_DEVICE_TIMEOUT           = 600 // 60 seconds

RMS_DEVICE_POWER[]           = 'Power'
RMS_DEVICE_STATUS_ON[]       = 'On'
RMS_DEVICE_STATUS_OFF[]      = 'Off'

RMS_DEVICE_CTRL_FAIL[]       = 'Control Failure'
RMS_DEVICE_CTRL_FAIL_PASS[]  = 'OK'
RMS_DEVICE_CTRL_FAIL_FAIL[]  = 'Fail'
RMS_POWER_FAIL_TIMEOUT       = 200 // 20 seconds

RMS_DEVICE_IP[]              = 'IP Address'

// RMS Channels
RMS_CH_POWER_TOGGLE          = 9
RMS_CH_POWER_ON              = 27
RMS_CH_POWER_OFF             = 28
RMS_CH_RUN_PRESET            = 100
RMS_CH_SERVER_ONLINE         = 250
RMS_CH_SUPPORT_DI            = 251
RMS_CH_POWER_FAIL            = 254
RMS_CH_POWER_STATUS          = 255

// RMS Channels
RMS_LVL_CUR_APPT_IDX         = 1
RMS_LVL_MIN_REMAIN           = 2
RMS_LVL_NEXT_APPT_IDX        = 3
RMS_LVL_MIN_TILL_NEXT        = 4
RMS_LVL_FIRST_APPT_IDX       = 5
RMS_LVL_LAST_APPT_IDX        = 6
RMS_LVL_APPTS_REMAIN         = 7

// System Device Info
DEV RMS_SYSTEM_DPS           = { 0:1:0 }
DEV RMS_SRC_USAGE_DPS        = { 0:0:0 }
RMS_SYSTEM_DEVICE[]          = 'System'
RMS_SRC_USAGE_DEVICE[]       = 'Source Usage'
RMS_SYSTEM_MANUFACTURER[]    = 'AMX Corp.'
RMS_SYSTEM_MODEL[]           = 'RMS'

(***********************************************************)
(*              DATA TYPE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_TYPE

// Appointment
STRUCTURE _sRMSAppointment
{
  LONG    lAppointmentID
  CHAR    cStartDate[12]
  CHAR    cStartTime[10]
  CHAR    cEndDate[12]
  CHAR    cEndTime[10]
  CHAR    cSubject[100]
  CHAR    cDetails[100]
  CHAR    cScheduler[100]
  CHAR    cAttending[100]
  CHAR    cWelcomeImageFile[100]
  CHAR    cWelcomeMessage[1005] // Need room for 5 LF's
  CHAR    bOutdoorActivity
  CHAR    bAutoStart
}

(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE

// Little version check hack...
#IF_NOT_DEFINED bRMSReportedVersion
VOLATILE CHAR bRMSReportedVersion
#END_IF // bRMSReportedVersion

(***********************************************************)
(*           SUBROUTINE DEFINITIONS GO BELOW               *)
(***********************************************************)

(***********************************************************)
(*           General Help Calls - Common to RMSEngine      *)
(***********************************************************)
(**************************************)
(* Call Name: RMSDevToString          *)
(* Function:  convert Dev to String   *)
(* Params:    DPS                     *)
(* Return:    D:P:S                   *)
(**************************************)
DEFINE_FUNCTION CHAR[20] RMSDevToString(DEV dvDPS)
{
  RETURN "ITOA(dvDPS.Number),':',ITOA(dvDPS.Port),':',ITOA(dvDPS.System)"
}

(**************************************)
(* Call Name: RMSParseDPSFromString   *)
(* Function:  Parse string and        *)
(*            extract DPS             *)
(**************************************)
DEFINE_FUNCTION RMSParseDPSFromString(CHAR cCmd[], DEV dvDPS)
STACK_VAR
INTEGER nPos
{
  dvDPS.Number = ATOI(cCmd)
  dvDPS.Port = 1
  dvDPS.System = 0
  nPos = FIND_STRING(cCmd,':',1)
  IF (nPos)
  {
    nPos++
    dvDPS.Port = ATOI(MID_STRING(cCmd,nPos,LENGTH_STRING(cCmd)-nPos+1))
    nPos = FIND_STRING(cCmd,':',nPos)
    IF (nPos)
    {
      nPos++
      dvDPS.System = ATOI(MID_STRING(cCmd,nPos,LENGTH_STRING(cCmd)-nPos+1))
    }
  }
}

(**************************************)
(* Call Name: RMSParseCommaSepString  *)
(* Function:  Parse string and remove *)
(*            next parameter          *)
(**************************************)
DEFINE_FUNCTION CHAR[1000] RMSParseCommaSepString(CHAR cCmd[])
STACK_VAR
CHAR cArg[1000]
{
  // Assume the argument to be the command
  cArg = cCmd

  // If the command has a comma, remove up until this and set arg to it
  IF (FIND_STRING(cCmd,',',1))
  {
    cArg = REMOVE_STRING(cCmd,',',1)
    cArg = LEFT_STRING(cArg,LENGTH_STRING(cArg)-1)
  }
  ELSE
  {
    cCmd = ""
  }

  RETURN cArg;
}


(**************************************)
(* Call Name: RMSMidString            *)
(* Function:  Mid String Wrapper      *)
(* Param:     String, Start, Length   *)
(* Return:    String                  *)
(**************************************)
DEFINE_FUNCTION CHAR[2000] RMSMidString(CHAR cStr[], INTEGER nStart, SLONG slLen)
STACK_VAR
INTEGER nLen
{
  // All Of It?
  IF (slLen < 0)
    RETURN MID_STRING(cStr,nStart,LENGTH_STRING(cStr)-nStart+1)

  // Just Like Mid
  nLen = TYPE_CAST(slLen)
  RETURN MID_STRING(cStr,nStart,nLen)
}

(**************************************)
(* Call Name: RMSDecodeAppointment    *)
(* Function:  Decode Appoint from     *)
(*            String                  *)
(* Param:     Appointment, String     *)
(* Return:    >=0 - Good, <0 - Bad    *)
(**************************************)
DEFINE_FUNCTION SLONG RMSDecodeAppointmentString(_sRMSAppointment sAppt, CHAR sEncodedAppt[])
STACK_VAR
LONG lPos
{
  lPos = 1
  RETURN STRING_TO_VARIABLE(sAppt,sEncodedAppt,lPos)
}

(***********************************************************)
(*        Device Monitor Calls - Not Common To Engine      *)
(***********************************************************)
#IF_NOT_DEFINED RMS_DEV_MON_DEFS_ONLY
(**************************************)
(* Call Name: RMSSetServer            *)
(* Function:  Set Server              *)
(* Params:    Server                  *)
(* Return:    None                    *)
(**************************************)
DEFINE_FUNCTION SLONG RMSSetServer(CHAR cServer[])
{
  SEND_COMMAND vdvRMSEngine, "'SERVER-',cServer"
}

(**************************************)
(* Call Name: RMSSetServerAndPort     *)
(* Function:  Set Server and Port     *)
(* Params:    Server,Port             *)
(* Return:    None                    *)
(**************************************)
DEFINE_FUNCTION SLONG RMSSetServerAndPort(CHAR cServer[],INTEGER nPort)
{
  SEND_COMMAND vdvRMSEngine, "'SERVER-',cServer,':',ITOA(nPort)"
}

(**************************************)
(* Call Name: RMSDisableTimeSync      *)
(* Function:  Disable RMS Time Sync   *)
(* Params:    None                    *)
(* Return:    None                    *)
(**************************************)
DEFINE_FUNCTION SLONG RMSDisableTimeSync()
{
  SEND_COMMAND vdvRMSEngine, 'IGNORE SERVER TIME UPDATE'
}

(**************************************)
(* Call Name: RMSSetSystemPower       *)
(* Function:  Set System Power        *)
(* Params:    State                   *)
(* Return:    None                    *)
(**************************************)
DEFINE_FUNCTION SLONG RMSSetSystemPower(CHAR bState)
{
  SEND_STRING vdvRMSEngine, "'POWER=',ITOA(bState)"
}

(**************************************)
(* Call Name: RMSSetMultiSource       *)
(* Function:  Set MultiSource Tracking*)
(* Params:    State                   *)
(* Return:    None                    *)
(**************************************)
DEFINE_FUNCTION SLONG RMSSetMultiSource(CHAR bState)
{
  IF (bState)
    SEND_COMMAND vdvRMSEngine, 'MULTISOURCE-ON'
  ELSE
    SEND_COMMAND vdvRMSEngine, 'MULTISOURCE-OFF'
}

(**************************************)
(* Call Name: RMSNetLinxDeviceOnline  *)
(* Function:  Send Device Reg&Online  *)
(* Params:    DPS,Name                *)
(* Return:    0=Good, <0=Bad          *)
(**************************************)
DEFINE_FUNCTION SLONG RMSNetLinxDeviceOnline(DEV dvDPS, CHAR cName[])
{
  // Send Command
  // Online/Offline is automatically registered
  RMSRegisterDevice(dvDPS, cName, "", "")
  RETURN 0;
}

(**************************************)
(* Call Name: RMSNetLinxDeviceOffline *)
(* Function:  Send Offline            *)
(* Params:    DPS                     *)
(* Return:    None                    *)
(**************************************)
DEFINE_FUNCTION RMSNetLinxDeviceOffline(DEV dvDPS)
{
  // Send Command
  RMSChangeIndexParam(dvDPS, RMS_DEVICE_ONLINE, FALSE)
}

(**************************************)
(* Call Name: RMSSetDeviceInfo        *)
(* Function:  Send Device Info        *)
(* Params:    DPS,Name,Man,Model      *)
(* Return:    None                    *)
(**************************************)
DEFINE_FUNCTION RMSSetDeviceInfo(DEV dvDPS, CHAR cName[], CHAR cManufacturer[], CHAR cModel[])
{
  // Send Command
  SEND_COMMAND vdvRMSEngine,"'DEV INFO-',RMSDevToString(dvDPS),',',cName,',',cManufacturer,',',cModel"
}

(****************************************)
(* Call Name: RMSSetCommunicationTimeout*)
(* Function:  Send Comm Timeout         *)
(* Params:    DPS, Timeout              *)
(* Return:    None                      *)
(****************************************)
DEFINE_FUNCTION RMSSetCommunicationTimeout(DEV dvDPS,INTEGER nTimeout)
{
  // Send Command
  SEND_COMMAND vdvRMSEngine,"'COMM TO-',RMSDevToString(dvDPS),',',ITOA(nTimeout)"
}

(**************************************)
(* Call Name: RMSSetDevicePower       *)
(* Function:  Set Device Power        *)
(* Params:    State                   *)
(* Return:    None                    *)
(**************************************)
DEFINE_FUNCTION SLONG RMSSetDevicePower(DEV dvDPS, CHAR bState)
{
  SEND_COMMAND vdvRMSEngine,"'DEV PWR-',RMSDevToString(dvDPS),',',ITOA(bState)"
}

(**************************************)
(* Call Name: RMSSetLampHours         *)
(* Function:  Set Lamp Hours          *)
(* Params:    State                   *)
(* Return:    None                    *)
(**************************************)
DEFINE_FUNCTION SLONG RMSSetLampHours(DEV dvDPS, LONG lValue)
{
  SEND_COMMAND vdvRMSEngine,"'LAMP HOURS-',RMSDevToString(dvDPS),',',ITOA(lValue)"
}

(**************************************)
(* Call Name: RMSSetTransportState    *)
(* Function:  Set Transport State     *)
(* Params:    State                   *)
(* Return:    None                    *)
(**************************************)
DEFINE_FUNCTION SLONG RMSSetTransportState(DEV dvDPS, LONG lValue)
{
  SEND_COMMAND vdvRMSEngine,"'XPORT STATE-',RMSDevToString(dvDPS),',',ITOA(lValue)"
}

(**************************************)
(* Call Name: RMSEnablePowerFailure   *)
(* Function:  Send Power Fail On      *)
(* Params:    DPS                     *)
(* Return:    None                    *)
(**************************************)
DEFINE_FUNCTION RMSEnablePowerFailure(DEV dvDPS)
{
  // Send Command
  SEND_COMMAND vdvRMSEngine,"'PWRFAILON-',RMSDevToString(dvDPS)"
}

(**************************************)
(* Call Name: RMSRegisterDevice       *)
(* Function:  Send Device Registration*)
(* Params:    DPS,Name,Man,Model      *)
(* Return:    0=Good, <0=Bad          *)
(**************************************)
DEFINE_FUNCTION SLONG RMSRegisterDevice(DEV dvDPS, CHAR cName[], CHAR cManufacturer[], CHAR cModel[])
{
  // Must be online
  //IF (DEVICE_ID(dvDPS) == 0)
  //  RETURN -1;

  // Send Command
  SEND_COMMAND vdvRMSEngine,"'ADD DEV-',RMSDevToString(dvDPS),',',cName,',',cManufacturer,',',cModel"
  RETURN 0;
}

(**************************************)
(* Call Name: RMSRegisterDeviceParam  *)
(* Function:  Send Param Registration *)
(* Params:    DPS                     *)
(*            Name                    *)
(*            Type                    *)
(*            Threshold               *)
(*            Compare Operator        *)
(*            Can Reset               *)
(*            Reset Value             *)
(*            Initial Op              *)
(*            Initial Value           *)
(*            Enum List (Index&Enum)  *)
(*            Min (Number)            *)
(*            Max (Number)            *)
(* Return:    0=Good, <0=Bad          *)
(**************************************)
DEFINE_FUNCTION SLONG RMSRegisterDeviceParam(DEV dvDPS, CHAR cName[], CHAR chType, CHAR cThreshold[], INTEGER nThresholdCompare, INTEGER nThresholdStatus, CHAR bCanReset, CHAR cResetValue[], INTEGER nInitialOp, CHAR cInitial[], CHAR cEnumList[], SLONG slMin, SLONG slMax)
{
  RMSRegisterDeviceParam3(dvDPS, cName, FALSE, dvDPS, cName, chType, FALSE, "", 0, cThreshold, nThresholdCompare, nThresholdStatus, bCanReset, cResetValue, nInitialOp, cInitial, cEnumList, slMin, slMax)
}
DEFINE_FUNCTION SLONG RMSRegisterDeviceParam2(DEV dvDPS, CHAR cName[], CHAR chType, CHAR bStock, CHAR cUnits[], CHAR bTrackChanges, CHAR cThreshold[], INTEGER nThresholdCompare, INTEGER nThresholdStatus, CHAR bCanReset, CHAR cResetValue[], INTEGER nInitialOp, CHAR cInitial[], CHAR cEnumList[], SLONG slMin, SLONG slMax)
{
  RMSRegisterDeviceParam3(dvDPS, cName, FALSE, dvDPS, cName, chType, bStock, cUnits, bTrackChanges, cThreshold, nThresholdCompare, nThresholdStatus, bCanReset, cResetValue, nInitialOp, cInitial, cEnumList, slMin, slMax)
}
DEFINE_FUNCTION SLONG RMSRegisterDeviceParam3(DEV dvDPS, CHAR cName[], CHAR bMigrate, DEV dvOldDPS, CHAR cOldName[], CHAR chType, CHAR bStock, CHAR cUnits[], CHAR bTrackChanges, CHAR cThreshold[], INTEGER nThresholdCompare, INTEGER nThresholdStatus, CHAR bCanReset, CHAR cResetValue[], INTEGER nInitialOp, CHAR cInitial[], CHAR cEnumList[], SLONG slMin, SLONG slMax)
STACK_VAR
CHAR    cData[100]
CHAR    cEnd[200]
CHAR    cTempName[100]
{
  // Must be online
  //IF (DEVICE_ID(dvDPS) == 0)
  //  RETURN -1;

  // Send Command
  SELECT
  {
    // Enum
    ACTIVE (chType == RMS_PARAM_TYPE_STRING && LENGTH_STRING(cEnumList)):
    {
      cData = 'ADD E'
      cEnd = "',',cEnumList"
    }
    // String
    ACTIVE (chType == RMS_PARAM_TYPE_STRING):
    {
      cData = 'ADD S'
      cEnd = ""
    }
    // Index
    ACTIVE (LENGTH_STRING(cEnumList)):
    {
      cData = 'ADD I'
      cEnd = "',',cEnumList"
    }
    // Number
    ACTIVE (1):
    {
      cData = 'ADD N'
      cEnd = "',',ITOA(slMin),',',ITOA(slMax)"
    }
  }

  // Pick Stock, Old or New
  // Add DPS and Name, Stock, Units, Track Changes
  SELECT
  {
    // Stock
    ACTIVE (bStock):
      cData = "cData,'PARAMS-',RMSDevToString(dvDPS),',',cName,',',cUnits,',',ITOA(bTrackChanges),','"

    // New (if we must)
    ACTIVE (LENGTH_STRING(cUnits) || bTrackChanges):
      cData = "cData,'PARAM2-',RMSDevToString(dvDPS),',',cName,',',cUnits,',',ITOA(bTrackChanges),','"

    // Old (is fine for most...)
    ACTIVE (1):
      cData = "cData,'PARAM-',RMSDevToString(dvDPS),',',cName,','"
  }

  // Add threshold
  SWITCH (nThresholdCompare)
  {
    CASE RMS_COMP_NONE:                cData = "cData,','"
    CASE RMS_COMP_LESS_THAN:           cData = "cData,'<',cThreshold,','"
    CASE RMS_COMP_LESS_THAN_EQ_TO:     cData = "cData,'<=',cThreshold,','"
    CASE RMS_COMP_GREATER_THAN:        cData = "cData,'>',cThreshold,','"
    CASE RMS_COMP_GREATER_THAN_EQ_TO:  cData = "cData,'>=',cThreshold,','"
    CASE RMS_COMP_EQUAL_TO:            cData = "cData,'==',cThreshold,','"
    CASE RMS_COMP_NOT_EQUAL_TO:        cData = "cData,'!=',cThreshold,','"
    CASE RMS_COMP_CONTAINS:            cData = "cData,'(',cThreshold,'),'"
    CASE RMS_COMP_DOES_NOT_CONTAIN:    cData = "cData,')',cThreshold,'(,'"
  }

  // Add Status Type - We cheat here sine the module will take the enum value
  cData = "cData,ITOA(nThresholdStatus),','"

  // Add Reset
  IF (bCanReset)
    cData = "cData,cResetValue,','"
  ELSE
    cData = "cData,'NoReset,'"

  // Initial Value
  SWITCH (nInitialOp)
  {
    CASE RMS_PARAM_INC:        cData = "cData,'+=',cInitial"
    CASE RMS_PARAM_DEC:        cData = "cData,'-=',cInitial"
    CASE RMS_PARAM_MULTIPLY:   cData = "cData,'*=',cInitial"
    CASE RMS_PARAM_DIVIDE:     cData = "cData,'\=',cInitial"
    CASE RMS_PARAM_RESET:      cData = "cData,'Reset'"
    CASE RMS_PARAM_UNCHANGED:  cData = "cData,'NoChange'"
    CASE RMS_PARAM_INITIALIZE: cData = "cData,'Init=',cInitial"
    DEFAULT:                   cData = "cData,cInitial"
  }
	
	// Add migration info?
	IF (bMigrate == TRUE)
	{
	  cTempName = cOldName
	  IF (LENGTH_STRING(cTempName) = 0)
		  cTempName = cName
	  cEnd = "cEnd,',',RMSDevToString(dvOldDPS),',',cTempName"
	}

  // Send it
  SEND_COMMAND vdvRMSEngine,"cData,cEnd"
  RETURN 0;
}

(**************************************)
(* Call Name: RMSRegisterDeviceXXParam*)
(* Function:  Send Param Registration *)
(* Params:    DPS                     *)
(*            Name                    *)
(*            Threshold               *)
(*            Compare Operator        *)
(*            Can Reset               *)
(*            Reset Value             *)
(*            Initial Value           *)
(*            Min (Number)            *)
(*            Max (Number)            *)
(*            Enum List (Index&Enum)  *)
(* Return:    0=Good, <0=Bad          *)
(**************************************)
// Old Functions - Backwards compatible
DEFINE_FUNCTION SLONG RMSRegisterDeviceNumberParam(DEV dvDPS, CHAR cName[], SLONG slThreshold, INTEGER nThresholdCompare, INTEGER nThresholdStatus, CHAR bCanReset, SLONG slResetValue, INTEGER nInitialOp, SLONG slInitial, SLONG slMin, SLONG slMax)
{
  RETURN RMSRegisterDeviceParam(dvDPS, cName, RMS_PARAM_TYPE_NUMBER, ITOA(slThreshold), nThresholdCompare, nThresholdStatus, bCanReset, ITOA(slResetValue), nInitialOp, ITOA(slInitial), "", slMin, slMax);
}
DEFINE_FUNCTION SLONG RMSRegisterDeviceIndexParam(DEV dvDPS, CHAR cName[], INTEGER nThreshold, INTEGER nThresholdCompare, INTEGER nThresholdStatus, CHAR bCanReset, INTEGER nResetValue, INTEGER nInitialOp, INTEGER nInitial, CHAR cEnumList[])
{
  RETURN RMSRegisterDeviceParam(dvDPS, cName, RMS_PARAM_TYPE_NUMBER, ITOA(nThreshold), nThresholdCompare, nThresholdStatus, bCanReset, ITOA(nResetValue), nInitialOp, ITOA(nInitial), cEnumList, 0, 0);
}
DEFINE_FUNCTION SLONG RMSRegisterDeviceStringParam(DEV dvDPS, CHAR cName[], CHAR cThreshold[], INTEGER nThresholdCompare, INTEGER nThresholdStatus, CHAR bCanReset, CHAR cResetValue[], INTEGER nInitialOp, CHAR cInitial[])
{
  RETURN RMSRegisterDeviceParam(dvDPS, cName, RMS_PARAM_TYPE_STRING, cThreshold, nThresholdCompare, nThresholdStatus, bCanReset, cResetValue, nInitialOp, cInitial, "", 0, 0);
}
DEFINE_FUNCTION SLONG RMSRegisterDeviceEnumParam(DEV dvDPS, CHAR cName[], CHAR cThreshold[], INTEGER nThresholdCompare, INTEGER nThresholdStatus, CHAR bCanReset, CHAR cResetValue[], INTEGER nInitialOp, CHAR cInitial[], CHAR cEnumList[])
{
  RETURN RMSRegisterDeviceParam(dvDPS, cName, RMS_PARAM_TYPE_STRING, cThreshold, nThresholdCompare, nThresholdStatus, bCanReset, cResetValue, nInitialOp, cInitial, cEnumList, 0, 0);
}

// New Functions - Includes Units
DEFINE_FUNCTION SLONG RMSRegisterDeviceNumberParamWithUnits(DEV dvDPS, CHAR cName[], CHAR cUnits[], SLONG slThreshold, INTEGER nThresholdCompare, INTEGER nThresholdStatus, CHAR bCanReset, SLONG slResetValue, INTEGER nInitialOp, SLONG slInitial, SLONG slMin, SLONG slMax)
{
  RETURN RMSRegisterDeviceParam2(dvDPS, cName, RMS_PARAM_TYPE_NUMBER, FALSE, cUnits, RMS_DO_NOT_TRACK_CHANGES, ITOA(slThreshold), nThresholdCompare, nThresholdStatus, bCanReset, ITOA(slResetValue), nInitialOp, ITOA(slInitial), "", slMin, slMax);
}
DEFINE_FUNCTION SLONG RMSRegisterDeviceStringParamWithUnits(DEV dvDPS, CHAR cName[], CHAR cUnits[], CHAR cThreshold[], INTEGER nThresholdCompare, INTEGER nThresholdStatus, CHAR bCanReset, CHAR cResetValue[], INTEGER nInitialOp, CHAR cInitial[])
{
  RETURN RMSRegisterDeviceParam2(dvDPS, cName, RMS_PARAM_TYPE_STRING, FALSE, cUnits, RMS_DO_NOT_TRACK_CHANGES, cThreshold, nThresholdCompare, nThresholdStatus, bCanReset, cResetValue, nInitialOp, cInitial, "", 0, 0);
}

// Stock Params
DEFINE_FUNCTION SLONG RMSRegisterStockNumberParam(DEV dvDPS, CHAR cName[], CHAR cUnits[], CHAR bTrackChanges, SLONG slThreshold, INTEGER nThresholdCompare, INTEGER nThresholdStatus, CHAR bCanReset, SLONG slResetValue, INTEGER nInitialOp, SLONG slInitial, SLONG slMin, SLONG slMax)
{
  RETURN RMSRegisterDeviceParam2(dvDPS, cName, RMS_PARAM_TYPE_NUMBER, TRUE, cUnits, bTrackChanges, ITOA(slThreshold), nThresholdCompare, nThresholdStatus, bCanReset, ITOA(slResetValue), nInitialOp, ITOA(slInitial), "", slMin, slMax);
}
DEFINE_FUNCTION SLONG RMSRegisterStockIndexParam(DEV dvDPS, CHAR cName[], CHAR cUnits[], CHAR bTrackChanges, INTEGER nThreshold, INTEGER nThresholdCompare, INTEGER nThresholdStatus, CHAR bCanReset, INTEGER nResetValue, INTEGER nInitialOp, INTEGER nInitial, CHAR cEnumList[])
{
  RETURN RMSRegisterDeviceParam2(dvDPS, cName, RMS_PARAM_TYPE_NUMBER, TRUE, cUnits, bTrackChanges, ITOA(nThreshold), nThresholdCompare, nThresholdStatus, bCanReset, ITOA(nResetValue), nInitialOp, ITOA(nInitial), cEnumList, 0, 0);
}
DEFINE_FUNCTION SLONG RMSRegisterStockStringParam(DEV dvDPS, CHAR cName[], CHAR cUnits[], CHAR bTrackChanges, CHAR cThreshold[], INTEGER nThresholdCompare, INTEGER nThresholdStatus, CHAR bCanReset, CHAR cResetValue[], INTEGER nInitialOp, CHAR cInitial[])
{
  RETURN RMSRegisterDeviceParam2(dvDPS, cName, RMS_PARAM_TYPE_STRING, TRUE, cUnits, bTrackChanges, cThreshold, nThresholdCompare, nThresholdStatus, bCanReset, cResetValue, nInitialOp, cInitial, "", 0, 0);
}
DEFINE_FUNCTION SLONG RMSRegisterStockEnumParam(DEV dvDPS, CHAR cName[], CHAR cUnits[], CHAR bTrackChanges, CHAR cThreshold[], INTEGER nThresholdCompare, INTEGER nThresholdStatus, CHAR bCanReset, CHAR cResetValue[], INTEGER nInitialOp, CHAR cInitial[], CHAR cEnumList[])
{
  RETURN RMSRegisterDeviceParam2(dvDPS, cName, RMS_PARAM_TYPE_STRING, TRUE, cUnits, bTrackChanges, cThreshold, nThresholdCompare, nThresholdStatus, bCanReset, cResetValue, nInitialOp, cInitial, cEnumList, 0, 0);
}

// New Replace Functions
DEFINE_FUNCTION SLONG RMSReplaceDeviceNumberParamWithUnits(DEV dvDPS, CHAR cName[], DEV dvOldDPS, CHAR cOldName[], CHAR cUnits[], SLONG slThreshold, INTEGER nThresholdCompare, INTEGER nThresholdStatus, CHAR bCanReset, SLONG slResetValue, INTEGER nInitialOp, SLONG slInitial, SLONG slMin, SLONG slMax)
{
  RETURN RMSRegisterDeviceParam3(dvDPS, cName, TRUE, dvOldDPS, cOldName, RMS_PARAM_TYPE_NUMBER, FALSE, cUnits, RMS_DO_NOT_TRACK_CHANGES, ITOA(slThreshold), nThresholdCompare, nThresholdStatus, bCanReset, ITOA(slResetValue), nInitialOp, ITOA(slInitial), "", slMin, slMax);
}
DEFINE_FUNCTION SLONG RMSReplaceDeviceStringParamWithUnits(DEV dvDPS, CHAR cName[], DEV dvOldDPS, CHAR cOldName[], CHAR cUnits[], CHAR cThreshold[], INTEGER nThresholdCompare, INTEGER nThresholdStatus, CHAR bCanReset, CHAR cResetValue[], INTEGER nInitialOp, CHAR cInitial[])
{
  RETURN RMSRegisterDeviceParam3(dvDPS, cName, TRUE, dvOldDPS, cOldName, RMS_PARAM_TYPE_STRING, FALSE, cUnits, RMS_DO_NOT_TRACK_CHANGES, cThreshold, nThresholdCompare, nThresholdStatus, bCanReset, cResetValue, nInitialOp, cInitial, "", 0, 0);
}
DEFINE_FUNCTION SLONG RMSReplaceStockNumberParam(DEV dvDPS, CHAR cName[], DEV dvOldDPS, CHAR cOldName[], CHAR cUnits[], CHAR bTrackChanges, SLONG slThreshold, INTEGER nThresholdCompare, INTEGER nThresholdStatus, CHAR bCanReset, SLONG slResetValue, INTEGER nInitialOp, SLONG slInitial, SLONG slMin, SLONG slMax)
{
  RETURN RMSRegisterDeviceParam3(dvDPS, cName, TRUE, dvOldDPS, cOldName, RMS_PARAM_TYPE_NUMBER, TRUE, cUnits, bTrackChanges, ITOA(slThreshold), nThresholdCompare, nThresholdStatus, bCanReset, ITOA(slResetValue), nInitialOp, ITOA(slInitial), "", slMin, slMax);
}
DEFINE_FUNCTION SLONG RMSReplaceStockIndexParam(DEV dvDPS, CHAR cName[], DEV dvOldDPS, CHAR cOldName[], CHAR cUnits[], CHAR bTrackChanges, INTEGER nThreshold, INTEGER nThresholdCompare, INTEGER nThresholdStatus, CHAR bCanReset, INTEGER nResetValue, INTEGER nInitialOp, INTEGER nInitial, CHAR cEnumList[])
{
  RETURN RMSRegisterDeviceParam3(dvDPS, cName, TRUE, dvOldDPS, cOldName, RMS_PARAM_TYPE_NUMBER, TRUE, cUnits, bTrackChanges, ITOA(nThreshold), nThresholdCompare, nThresholdStatus, bCanReset, ITOA(nResetValue), nInitialOp, ITOA(nInitial), cEnumList, 0, 0);
}
DEFINE_FUNCTION SLONG RMSReplaceStockStringParam(DEV dvDPS, CHAR cName[], DEV dvOldDPS, CHAR cOldName[], CHAR cUnits[], CHAR bTrackChanges, CHAR cThreshold[], INTEGER nThresholdCompare, INTEGER nThresholdStatus, CHAR bCanReset, CHAR cResetValue[], INTEGER nInitialOp, CHAR cInitial[])
{
  RETURN RMSRegisterDeviceParam3(dvDPS, cName, TRUE, dvOldDPS, cOldName, RMS_PARAM_TYPE_STRING, TRUE, cUnits, bTrackChanges, cThreshold, nThresholdCompare, nThresholdStatus, bCanReset, cResetValue, nInitialOp, cInitial, "", 0, 0);
}
DEFINE_FUNCTION SLONG RMSReplaceStockEnumParam(DEV dvDPS, CHAR cName[], DEV dvOldDPS, CHAR cOldName[], CHAR cUnits[], CHAR bTrackChanges, CHAR cThreshold[], INTEGER nThresholdCompare, INTEGER nThresholdStatus, CHAR bCanReset, CHAR cResetValue[], INTEGER nInitialOp, CHAR cInitial[], CHAR cEnumList[])
{
  RETURN RMSRegisterDeviceParam3(dvDPS, cName, TRUE, dvOldDPS, cOldName, RMS_PARAM_TYPE_STRING, TRUE, cUnits, bTrackChanges, cThreshold, nThresholdCompare, nThresholdStatus, bCanReset, cResetValue, nInitialOp, cInitial, cEnumList, 0, 0);
}

(**************************************)
(* Call Name: RMSDeleteDeviceParam    *)
(* Function:  Send Param Delete       *)
(* Params:    DPS                     *)
(*            Name                    *)
(* Return:    None                    *)
(**************************************)
DEFINE_FUNCTION RMSDeleteDeviceParam(DEV dvDPS, CHAR cName[])
{
  // Send Command
  SEND_COMMAND vdvRMSEngine,"'DEL PARAM-',RMSDevToString(dvDPS),',',cName"
}

(**************************************)
(* Call Name: RMSChangeParam          *)
(* Function:  Set Param value         *)
(* Params:    DPS,Name,Operation,Val  *)
(* Return:    None                    *)
(**************************************)
DEFINE_FUNCTION RMSChangeParam(DEV dvDPS, CHAR cName[], INTEGER nOp, CHAR cValue[])
STACK_VAR
CHAR    cData[100]
{
  // Send Command
  cData = "'SET PARAM-',RMSDevToString(dvDPS),',',cName,','"
  SWITCH (nOp)
  {
    CASE RMS_PARAM_INC:       cData = "cData,'+=',cValue"
    CASE RMS_PARAM_DEC:       cData = "cData,'-=',cValue"
    CASE RMS_PARAM_MULTIPLY:  cData = "cData,'*=',cValue"
    CASE RMS_PARAM_DIVIDE:    cData = "cData,'\=',cValue"
    CASE RMS_PARAM_RESET:     cData = "cData,'Reset'"
    CASE RMS_PARAM_UNCHANGED: cData = "cData,'NoChange'"
    DEFAULT:                 cData = "cData,cValue"
  }
  SEND_COMMAND vdvRMSEngine,cData
}
DEFINE_FUNCTION RMSChangeNumberParam(DEV dvDPS, CHAR cName[], INTEGER nOp, SLONG slValue)
{
  RMSChangeParam(dvDPS, cName, nOp, ITOA(slValue))
}
DEFINE_FUNCTION RMSChangeIndexParam(DEV dvDPS, CHAR cName[], INTEGER nValue)
{
  RMSChangeParam(dvDPS, cName, RMS_PARAM_SET, ITOA(nValue))
}
DEFINE_FUNCTION RMSChangeStringParam(DEV dvDPS, CHAR cName[], INTEGER nOp, CHAR cValue[])
{
  RMSChangeParam(dvDPS, cName, nOp, cValue)
}
DEFINE_FUNCTION RMSChangeEnumParam(DEV dvDPS, CHAR cName[], CHAR cValue[])
{
  RMSChangeParam(dvDPS, cName, RMS_PARAM_SET, cValue)
}

(**************************************)
(* Call Name: RMSDeviceIsIR           *)
(* Function:  Is Device IR?           *)
(* Params:    DPS                     *)
(* Return:    0=No, 1=Yes             *)
(**************************************)
DEFINE_FUNCTION CHAR RMSDeviceIsIR(DEV dvDPS)
STACK_VAR
INTEGER nDeviceID
DEV_INFO_STRUCT sDevInfo
INTEGER nValue
{
  // Is this a master or socket?
  IF (dvDPS.NUMBER == 0)
    RETURN FALSE;

  // Is this an axlink device?
  nDeviceId = DEVICE_ID(dvDPS)
  IF (nDeviceId <= 255)
  {
    SWITCH (nDeviceId)
    {
      CASE 136: //IR/Serial/Data
      CASE 177: //TV Manager Box
      CASE 183: //TV Manager Box Coax
      CASE 187: //IR/Serial 4 Box
      CASE 194: //Television Controller Box
      CASE 200: //TV Manager W/Clock
      CASE 203: //TV Manager+
        RETURN TRUE;
    }
    RETURN FALSE;
  }

  // So it's NetLinx, huh?
  IF (dvDPS.Number)
  {
    DEVICE_INFO(dvDPS,sDevInfo)
    SWITCH (sDevInfo.DEVICE_ID)
    {
      // IRS4
      CASE 264:
        RETURN TRUE;

      // NXI
      CASE 257:
      {
        IF (dvDPS.PORT >= 8 && dvDPS.PORT <= 15)
          RETURN TRUE;
      }
      // NI-Series
      CASE 286:
      {
        nValue = FIND_STRING(sDevInfo.DEVICE_ID_STRING,'00',1)
        IF (nValue)
        {
          nValue = ATOI(MID_STRING(sDevInfo.DEVICE_ID_STRING,nValue-1,1))
          SWITCH (nValue)
          {
            CASE 2: // NI-2000
            {
              IF (dvDPS.PORT >= 5 && dvDPS.PORT <= 8)
                RETURN TRUE;
            }
            CASE 3: // NI-4000
            CASE 4: // NI-3000
            {
              IF (dvDPS.PORT >= 9 && dvDPS.PORT <= 16)
                RETURN TRUE;
            }
            CASE 7: // NI-700
            {
              IF (dvDPS.PORT == 3)
                RETURN TRUE;
            }
          }
        }
      }
    }

    // Taking a shot in the dark...
    IF (FIND_STRING(sDevInfo.DEVICE_ID_STRING,'IRS',1))
      RETURN TRUE;
  }
  RETURN FALSE;
}

(**************************************)
(* Call Name: RMSDeviceIsSerial       *)
(* Function:  Is Device Serial?       *)
(* Params:    DPS                     *)
(* Return:    0=No, 1=Yes             *)
(**************************************)
DEFINE_FUNCTION CHAR RMSDeviceIsSerial(DEV dvDPS)
STACK_VAR
INTEGER nDeviceID
DEV_INFO_STRUCT sDevInfo
INTEGER nValue
{
  // Is this the master?
  IF (dvDPS.NUMBER == 0 && dvDPS.PORT < FIRST_LOCAL_PORT)
    RETURN FALSE;

  // Is this a socket?
  IF (dvDPS.NUMBER == 0)
    RETURN TRUE;

  // Is this a virtual?
  IF (dvDPS.NUMBER >= FIRST_VIRTUAL_DEVICE)
    RETURN FALSE;

  // Is this an axlink device?
  nDeviceId = DEVICE_ID(dvDPS)
  IF (nDeviceId <= 255)
  {
    SWITCH (nDeviceId)
    {
      CASE 133: //RS-232/422/485
      CASE 137: //MIDI Interface
      CASE 142: //PA-422 Interface
      CASE 168: //RS232
      CASE 181: //RS-366 Interface
      CASE 186: //RS-232/422/485+ Box
      CASE 197: //MIDI Interface Box
      CASE 204: //RS-232/422/485++ Box
      CASE 205: //RS-232/422/485++ Card
        RETURN TRUE;
    }
    RETURN FALSE;
  }

  // So it's NetLinx, huh?
  IF (dvDPS.Number)
  {
    DEVICE_INFO(dvDPS,sDevInfo)
    SWITCH (sDevInfo.DEVICE_ID)
    {
      // COM-2
      CASE 263:
        RETURN TRUE;

      // NXI
      CASE 257:
      {
        IF (dvDPS.PORT >= 1 && dvDPS.PORT <= 6)
          RETURN TRUE;
      }
      // NI-Series
      CASE 286:
      {
        nValue = FIND_STRING(sDevInfo.DEVICE_ID_STRING,'00',1)
        IF (nValue)
        {
          nValue = ATOI(MID_STRING(sDevInfo.DEVICE_ID_STRING,nValue-1,1))
          SWITCH (nValue)
          {
            CASE 2: // NI-2000
            {
              IF (dvDPS.PORT >= 1 && dvDPS.PORT <= 3)
                RETURN TRUE;
            }
            CASE 3: // NI-4000
            CASE 4: // NI-3000
            {
              IF (dvDPS.PORT >= 1 && dvDPS.PORT <= 7)
                RETURN TRUE;
            }
            CASE 7: // NI-700
            {
              IF (dvDPS.PORT >= 1 && dvDPS.PORT <= 2)
                RETURN TRUE;
            }
          }
        }
      }
    }

    // Taking a shot in the dark...
    IF (FIND_STRING(sDevInfo.DEVICE_ID_STRING,'COM',1))
      RETURN TRUE;
  }
  RETURN FALSE;
}
#END_IF // RMS_DEV_MON_DEFS_ONLY

(******************************************)
(* Function: RMSDeviceMonitorPrintVersion *)
(* Purpose:  Print version                *)
(******************************************)
DEFINE_FUNCTION RMSDeviceMonitorPrintVersion()
{
  // What Version?
  SEND_STRING 0,"'  Running ',__RMS_DEV_MON_NAME__,', v',__RMS_DEV_MON_VERSION__"
  bRMSReportedVersion = TRUE
}

(********************************************)
(* Call Name: RMSDevMonRegisterCallbackProxy*)
(* Function:  My Version of Callback        *)
(* Param:     None                          *)
(* Return:    None                          *)
(* Note:      Caller must define this       *)
(********************************************)
#IF_NOT_DEFINED RMS_DEV_MON_DEFS_ONLY
#IF_NOT_DEFINED RMS_DEV_MON_CALLBACK_PROXIES
DEFINE_FUNCTION RMSDevMonRegisterCallbackProxy()
{
  // Application Function - Caller Must Implement This Function...
  RMSDevMonRegisterCallback()
  RETURN;
}
#END_IF // RMS_DEV_MON_CALLBACK_PROXIES
#END_IF // RMS_DEV_MON_DEFS_ONLY

(********************************************)
(* Call Name: RMSDevMonSetParamCallbackProxy *)
(* Function:  My Version of Callback        *)
(* Param:     None                          *)
(* Return:    None                          *)
(* Note:      Caller must define this       *)
(********************************************)
#IF_NOT_DEFINED RMS_DEV_MON_DEFS_ONLY
#IF_NOT_DEFINED RMS_DEV_MON_CALLBACK_PROXIES
DEFINE_FUNCTION RMSDevMonSetParamCallbackProxy(DEV dvDPS, CHAR cName[], CHAR cValue[])
{
  // Application Function - Caller Must Implement This Function...
  RMSDevMonSetParamCallback(dvDPS, cName, cValue)
  RETURN;
}
#END_IF // RMS_DEV_MON_CALLBACK_PROXIES
#END_IF // RMS_DEV_MON_DEFS_ONLY

(********************************************)
(* Call Name: RMSDevMonVersionCallbackProxy *)
(* Function:  My Version of Callback        *)
(* Param:     None                          *)
(* Return:    None                          *)
(* Note:      Caller must define this       *)
(********************************************)
#IF_DEFINED RMS_DEV_MON_VERSION_CALLBACK
#IF_NOT_DEFINED RMS_DEV_MON_CALLBACK_PROXIES
DEFINE_FUNCTION RMSDevMonVersionCallbackProxy()
{
  // Application Function - Caller Must Implement This Function...
  OFF[bRMSReportedVersion]
  RMSDevMonVersionCallback()

  // Did they call my version check function?
  IF (!bRMSReportedVersion)
    RMSDeviceMonitorPrintVersion()
  RETURN;
}
#END_IF // RMS_DEV_MON_CALLBACK_PROXIES
#END_IF // RMS_DEV_MON_VERSION_CALLBACK

(***********************************************************)
(*                STARTUP CODE GOES BELOW                  *)
(***********************************************************)
DEFINE_START

// What Version?
RMSDeviceMonitorPrintVersion()

// Disable time sync? Look for standard i!-TimeManager device name
// If you find it, tell RMS not to do time sync's
#IF_DEFINED vdvTmEvents
RMSDisableTimeSync()
SEND_STRING 0,"'RMS: Detected i!-TimeManager, disabling RMS Time Sync (RMSCommon.axi line ',ITOA(__LINE__),')'"
#END_IF

(***********************************************************)
(*                THE EVENTS GOES BELOW                    *)
(***********************************************************)
DEFINE_EVENT

(*******************************************)
(* DATA: Engine Virtual Device             *)
(*******************************************)
#IF_NOT_DEFINED RMS_DEV_MON_DEFS_ONLY
DATA_EVENT[vdvRMSEngine]
{
  // String coming in...
  STRING :
  {
    //*********************************************************
    // Register Params/Device
    //*********************************************************
    IF (LEFT_STRING(UPPER_STRING(DATA.TEXT),8) = 'REGISTER')
      RMSDevMonRegisterCallbackProxy()

    //*********************************************************
    // Register Params/Device
    //*********************************************************
    IF (LEFT_STRING(UPPER_STRING(DATA.TEXT),10) = 'SET PARAM-')
    {
      STACK_VAR
      CHAR  cCmd[200]
      CHAR  cTrash[10]
      DEV   dvDPS
      CHAR  cName[100]

      // Get Params
      cCmd = DATA.TEXT
      cTrash = GET_BUFFER_STRING(cCmd,10)
      RMSParseDPSFromString(RMSParseCommaSepString(cCmd),dvDPS)
      cName = RMSParseCommaSepString(cCmd)

      // Set
      RMSDevMonSetParamCallbackProxy(dvDPS, cName, cCmd)
    }
  }
  // Command coming in...
  COMMAND :
  {
    //*********************************************************
    // Version Info
    //*********************************************************
    #IF_DEFINED RMS_DEV_MON_VERSION_CALLBACK
    IF (LEFT_STRING(UPPER_STRING(DATA.TEXT),7) = 'VERSION')
      RMSDevMonVersionCallbackProxy()
    #END_IF // RMS_DEV_MON_VERSION_CALLBACK
  }
}
#END_IF // RMS_DEV_MON_DEFS_ONLY

(***********************************************************)
(*            THE ACTUAL PROGRAM GOES BELOW                *)
(***********************************************************)
DEFINE_PROGRAM

#END_IF // __RMS_COMMON__
(***********************************************************)
(*                     END OF PROGRAM                      *)
(*        DO NOT PUT ANY CODE BELOW THIS COMMENT           *)
(***********************************************************)