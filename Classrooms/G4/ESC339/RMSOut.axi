(*********************************************************************)
(*  AMX Corporation                                                  *)
(*  Copyright (c) 2000 - 2002 AMX Corporation. All rights reserved.  *)
(*********************************************************************)
(*  please refer to EULA.TXT for software license agreement          *)
(*********************************************************************)
(*                                                                   *)
(*              AMX Resource Management Suite (2.2.30)               *)
(*                                                                   *)
(*********************************************************************)

PROGRAM_NAME='RMSOut'

(*{{PS_SOURCE_INFO(PROGRAM STATS)                          *)
(***********************************************************)
(*  ORPHAN_FILE_PLATFORM: 1                                *)
(***********************************************************)
(*}}PS_SOURCE_INFO                                         *)
(***********************************************************)

(***********************************************************)
(*           DEVICE NUMBER DEFINITIONS GO BELOW            *)
(***********************************************************)
DEFINE_DEVICE

// vdvRMSEngine
vdvRMSEngine             = 33002:1:0

// dvRMSSocket
dvRMSSocket              = 0:3:0

// vdvCLActions
vdvCLActions             = 33002:1:0

// These Devices Need to be Defined in your Main Program:
// Core Devices:
// vdvRMSEngine
#IF_NOT_DEFINED vdvRMSEngine
#WARN 'RMS: This Device Needs to be Defined in your Main Program: vdvRMSEngine'
#END_IF

// dvRMSSocket
#IF_NOT_DEFINED dvRMSSocket
#WARN 'RMS: This Device Needs to be Defined in your Main Program: dvRMSSocket'
#END_IF

// vdvCLActions
#IF_NOT_DEFINED vdvCLActions
#WARN 'RMS: This Device Needs to be Defined in your Main Program: vdvCLActions'
#END_IF

(***********************************************************)
(*              CONSTANT DEFINITIONS GO BELOW              *)
(***********************************************************)
DEFINE_CONSTANT

// RMS Server IP
CHAR RMS_SERVER_IP[100]   = 'balukonis1.wesad.wesleyan.edu'

// Max String/Enum Param Length
RMS_MAX_PARAM_LEN         = 100

(***********************************************************)
(*                 INCLUDE FILES GO BELOW                  *)
(***********************************************************)
#INCLUDE 'RMSCommon.axi'

(***********************************************************)
(*              VARIABLE DEFINITIONS GO BELOW              *)
(***********************************************************)
DEFINE_VARIABLE

///////////////////////////////////////////////////////
// Devices
///////////////////////////////////////////////////////
// i-ConnectLinx paramater storage
VOLATILE SLONG   asnNumberLevelArgValues[3]
VOLATILE CHAR    acStringEnumArgValues[3][50]


// dv_proj2
VOLATILE SLONG      slRMSProjectorProjectorOn  // Projector On

// dv_proj2
VOLATILE SLONG      slRMSProjectorVideoMute  // Video Mute

// dv_proj2
VOLATILE SLONG      slRMSProjectorCoverOpen  // Cover Open

// dv_proj2
VOLATILE SLONG      slRMSProjectorTemperatureFault  // Temperature Fault

// dv_proj2
VOLATILE SLONG      slRMSProjectorFanOperation  // Fan Operation

// dv_proj2
VOLATILE SLONG      slRMSProjectorPowerSupply  // Power Supply

// dv_proj2
VOLATILE SLONG      slRMSProjectorLampFailure  // Lamp Failure

// dv_extron
CHAR                acRMSExtronSourceSelect[RMS_MAX_PARAM_LEN]  // Source Select

(***********************************************************)
(*             SUBROUTINE DEFINITIONS GO BELOW             *)
(***********************************************************)

(***************************************)
(* Call Name: RMSDevMonRegisterCallback*)
(* Function:  time to register devices *)
(* Param:     None                     *)
(* Return:    None                     *)
(* Note:      Caller must define this  *)
(***************************************)
DEFINE_FUNCTION RMSDevMonRegisterCallback()
{
  //Named NetLinx Devices
  RMSNetLinxDeviceOnline(dv_tp7500,'G4 Tp')

  RMSRegisterDevice(dv_proj2,'Projector','NEC ','MT1065')
  RMSRegisterDeviceNumberParam(dv_proj2,'Projector On',
      0,RMS_COMP_GREATER_THAN,RMS_STAT_EQUIPMENT_USAGE,
      FALSE,0,
      RMS_PARAM_SET,slRMSProjectorProjectorOn,0,0)
  RMSRegisterDeviceNumberParam(dv_proj2,'Video Mute',
      0,RMS_COMP_GREATER_THAN,RMS_STAT_CONTROLSYSTEM_ERR,
      FALSE,0,
      RMS_PARAM_SET,slRMSProjectorVideoMute,0,0)
  RMSRegisterDeviceNumberParam(dv_proj2,'Cover Open',
      0,RMS_COMP_GREATER_THAN,RMS_STAT_MAINTENANCE,
      FALSE,0,
      RMS_PARAM_SET,slRMSProjectorCoverOpen,0,0)
  RMSRegisterDeviceNumberParam(dv_proj2,'Temperature Fault',
      0,RMS_COMP_GREATER_THAN,RMS_STAT_MAINTENANCE,
      FALSE,0,
      RMS_PARAM_SET,slRMSProjectorTemperatureFault,0,0)
  RMSRegisterDeviceNumberParam(dv_proj2,'Fan Operation',
      0,RMS_COMP_GREATER_THAN,RMS_STAT_MAINTENANCE,
      FALSE,0,
      RMS_PARAM_SET,slRMSProjectorFanOperation,0,0)
  RMSRegisterDeviceNumberParam(dv_proj2,'Power Supply',
      0,RMS_COMP_GREATER_THAN,RMS_STAT_MAINTENANCE,
      FALSE,0,
      RMS_PARAM_SET,slRMSProjectorPowerSupply,0,0)
  RMSRegisterDeviceNumberParam(dv_proj2,'Lamp Failure',
      0,RMS_COMP_GREATER_THAN,RMS_STAT_NOT_ASSIGNED,
      FALSE,0,
      RMS_PARAM_SET,slRMSProjectorLampFailure,0,0)

  RMSRegisterDevice(dv_extron,'Extron','Extron Electronics, Inc.','System 8 Plus')
  RMSRegisterDeviceEnumParam(dv_extron,'Source Select',
      '',RMS_COMP_NONE,RMS_STAT_NOT_ASSIGNED,
      FALSE,'',
      RMS_PARAM_SET,acRMSExtronSourceSelect,
      '111|112|113|114|115|116|117|118|119|120')
}

(***************************************)
(* Call Name: RMSDevMonSetParamCallback*)
(* Function:  Reset parameters         *)
(* Param:     DPS, Name, Value         *)
(* Return:    None                     *)
(* Note:      Caller must define this  *)
(***************************************)
DEFINE_FUNCTION RMSDevMonSetParamCallback(DEV dvDPS, CHAR cName[], CHAR cValue[])
{
}


(**************************************************************)
(* Call Name: RMSSetProjectorProjectorOn                      *)
(* Function:  Set Projector On                                *)
(* Param:     Value                                           *)
(* Return:    None                                            *)
(**************************************************************)
DEFINE_FUNCTION RMSSetProjectorProjectorOn(SLONG slValue)
LOCAL_VAR
CHAR bInit
{
  IF (slRMSProjectorProjectorOn <> slValue || bInit = FALSE)
    RMSChangeNumberParam(dv_proj2,'Projector On',RMS_PARAM_SET,slValue)
  slRMSProjectorProjectorOn = slValue
  bInit = TRUE
}


(**************************************************************)
(* Call Name: RMSSetProjectorVideoMute                        *)
(* Function:  Set Video Mute                                  *)
(* Param:     Value                                           *)
(* Return:    None                                            *)
(**************************************************************)
DEFINE_FUNCTION RMSSetProjectorVideoMute(SLONG slValue)
LOCAL_VAR
CHAR bInit
{
  IF (slRMSProjectorVideoMute <> slValue || bInit = FALSE)
    RMSChangeNumberParam(dv_proj2,'Video Mute',RMS_PARAM_SET,slValue)
  slRMSProjectorVideoMute = slValue
  bInit = TRUE
}


(**************************************************************)
(* Call Name: RMSSetProjectorCoverOpen                        *)
(* Function:  Set Cover Open                                  *)
(* Param:     Value                                           *)
(* Return:    None                                            *)
(**************************************************************)
DEFINE_FUNCTION RMSSetProjectorCoverOpen(SLONG slValue)
LOCAL_VAR
CHAR bInit
{
  IF (slRMSProjectorCoverOpen <> slValue || bInit = FALSE)
    RMSChangeNumberParam(dv_proj2,'Cover Open',RMS_PARAM_SET,slValue)
  slRMSProjectorCoverOpen = slValue
  bInit = TRUE
}


(**************************************************************)
(* Call Name: RMSSetProjectorTemperatureFault                 *)
(* Function:  Set Temperature Fault                           *)
(* Param:     Value                                           *)
(* Return:    None                                            *)
(**************************************************************)
DEFINE_FUNCTION RMSSetProjectorTemperatureFault(SLONG slValue)
LOCAL_VAR
CHAR bInit
{
  IF (slRMSProjectorTemperatureFault <> slValue || bInit = FALSE)
    RMSChangeNumberParam(dv_proj2,'Temperature Fault',RMS_PARAM_SET,slValue)
  slRMSProjectorTemperatureFault = slValue
  bInit = TRUE
}


(**************************************************************)
(* Call Name: RMSSetProjectorFanOperation                     *)
(* Function:  Set Fan Operation                               *)
(* Param:     Value                                           *)
(* Return:    None                                            *)
(**************************************************************)
DEFINE_FUNCTION RMSSetProjectorFanOperation(SLONG slValue)
LOCAL_VAR
CHAR bInit
{
  IF (slRMSProjectorFanOperation <> slValue || bInit = FALSE)
    RMSChangeNumberParam(dv_proj2,'Fan Operation',RMS_PARAM_SET,slValue)
  slRMSProjectorFanOperation = slValue
  bInit = TRUE
}


(**************************************************************)
(* Call Name: RMSSetProjectorPowerSupply                      *)
(* Function:  Set Power Supply                                *)
(* Param:     Value                                           *)
(* Return:    None                                            *)
(**************************************************************)
DEFINE_FUNCTION RMSSetProjectorPowerSupply(SLONG slValue)
LOCAL_VAR
CHAR bInit
{
  IF (slRMSProjectorPowerSupply <> slValue || bInit = FALSE)
    RMSChangeNumberParam(dv_proj2,'Power Supply',RMS_PARAM_SET,slValue)
  slRMSProjectorPowerSupply = slValue
  bInit = TRUE
}


(**************************************************************)
(* Call Name: RMSSetProjectorLampFailure                      *)
(* Function:  Set Lamp Failure                                *)
(* Param:     Value                                           *)
(* Return:    None                                            *)
(**************************************************************)
DEFINE_FUNCTION RMSSetProjectorLampFailure(SLONG slValue)
LOCAL_VAR
CHAR bInit
{
  IF (slRMSProjectorLampFailure <> slValue || bInit = FALSE)
    RMSChangeNumberParam(dv_proj2,'Lamp Failure',RMS_PARAM_SET,slValue)
  slRMSProjectorLampFailure = slValue
  bInit = TRUE
}


(**************************************************************)
(* Call Name: RMSSetExtronSourceSelect                        *)
(* Function:  Set Source Select                               *)
(* Param:     Value                                           *)
(* Return:    None                                            *)
(**************************************************************)
DEFINE_FUNCTION RMSSetExtronSourceSelect(CHAR cValue[])
LOCAL_VAR
CHAR bInit
{
  IF (acRMSExtronSourceSelect <> cValue || bInit = FALSE)
    RMSChangeEnumParam(dv_extron,'Source Select',cValue)
  acRMSExtronSourceSelect = cValue
  bInit = TRUE
}


(***********************************************************)
(*                 STARTUP CODE GOES BELOW                 *)
(***********************************************************)
DEFINE_START

(***********************************************************)
(*                 MODULE CODE GOES BELOW                  *)
(***********************************************************)

// RMSSrcUsageMod - Tracks equipment usage
DEFINE_MODULE 'RMSSrcUsageMod' mdlSrcUsage(vdvRMSEngine,
                                           vdvCLActions)

// Extron
DEFINE_MODULE 'RMSTransportMod' mdlXport01(vdv_extron,
                                           dv_extron,
                                           vdvRMSEngine)

// Projector
DEFINE_MODULE 'RMSProjectorMod' mdlProj01(vdv_proj2,
                                          dv_proj2,
                                          vdvRMSEngine)

// RMSEngineMod - The RMS engine. Requires i!-ConnectLinxEngineMod.
DEFINE_MODULE 'RMSEngineMod' mdlRMSEng(vdvRMSEngine,
                                       dvRMSSocket,
                                       vdvCLActions)

(***********************************************************)
(*                  THE EVENTS GOES BELOW                  *)
(***********************************************************)
DEFINE_EVENT

(*******************************************)
(* DATA: RMS Engine                        *)
(*******************************************)
DATA_EVENT[vdvRMSEngine]
{
  ONLINE:
  {
    // Configure RMS Server Address
    RMSSetServer(RMS_SERVER_IP)

    // Projector
    RMSSetDeviceInfo(dv_proj2,'Projector','NEC ','MT1065')
    RMSSetCommunicationTimeout(dv_proj2,300)
    RMSEnablePowerFailure(dv_proj2)

    // Extron
    RMSSetDeviceInfo(dv_extron,'Extron','Extron Electronics, Inc.','System 8 Plus')
    RMSSetCommunicationTimeout(dv_extron,300)
  }
}

(*******************************************)
(* DATA: G4 Tp                             *)
(*******************************************)
DATA_EVENT [dv_tp7500]
{
  ONLINE:
    RMSNetLinxDeviceOnline(dv_tp7500,'G4 Tp')
  OFFLINE:
    RMSNetLinxDeviceOffline(dv_tp7500)
}

(*******************************************)
(* LEVEL: i!-ConnectLinx Engine            *)
(*******************************************)
LEVEL_EVENT[vdvCLActions,0]
{
  //Store it if we have room
  IF (MAX_LENGTH_ARRAY(asnNumberLevelArgValues) >= LEVEL.INPUT.LEVEL)
    asnNumberLevelArgValues [LEVEL.INPUT.LEVEL] = LEVEL.Value
}

(*******************************************)
(* CHANNEL: vdv_extron                     *)
(*******************************************)
CHANNEL_EVENT [vdv_extron,0]
{
  // Channel On
  ON:
  {
    SWITCH (CHANNEL.CHANNEL)
    {
      CASE 111:
        RMSSetExtronSourceSelect('1')
        break

    }
  }

  // Channel Off
  OFF:
  {
    SWITCH (CHANNEL.CHANNEL)
    {
      CASE 111:
        RMSSetExtronSourceSelect('0')
        break

    }
  }
}

(*******************************************)
(* CHANNEL: vdv_proj2                      *)
(*******************************************)
CHANNEL_EVENT [vdv_proj2,0]
{
  // Channel On
  ON:
  {
    SWITCH (CHANNEL.CHANNEL)
    {
      CASE 101:
        RMSSetProjectorProjectorOn(1)
        break

    }
  }

  // Channel Off
  OFF:
  {
    SWITCH (CHANNEL.CHANNEL)
    {
      CASE 101:
        RMSSetProjectorProjectorOn(0)
        break

    }
  }
}

(*******************************************)
(* CHANNEL: vdv_proj2                      *)
(*******************************************)
CHANNEL_EVENT [vdv_proj2,0]
{
  // Channel On
  ON:
  {
    SWITCH (CHANNEL.CHANNEL)
    {
      CASE 120:
        RMSSetProjectorVideoMute(1)
        break

    }
  }

  // Channel Off
  OFF:
  {
    SWITCH (CHANNEL.CHANNEL)
    {
      CASE 120:
        RMSSetProjectorVideoMute(0)
        break

    }
  }
}

(*******************************************)
(* CHANNEL: vdv_proj2                      *)
(*******************************************)
CHANNEL_EVENT [vdv_proj2,0]
{
  // Channel On
  ON:
  {
    SWITCH (CHANNEL.CHANNEL)
    {
      CASE 201:
        RMSSetProjectorCoverOpen(1)
        break

    }
  }

  // Channel Off
  OFF:
  {
    SWITCH (CHANNEL.CHANNEL)
    {
      CASE 201:
        RMSSetProjectorCoverOpen(0)
        break

    }
  }
}

(*******************************************)
(* CHANNEL: vdv_proj2                      *)
(*******************************************)
CHANNEL_EVENT [vdv_proj2,0]
{
  // Channel On
  ON:
  {
    SWITCH (CHANNEL.CHANNEL)
    {
      CASE 202:
        RMSSetProjectorTemperatureFault(1)
        break

    }
  }

  // Channel Off
  OFF:
  {
    SWITCH (CHANNEL.CHANNEL)
    {
      CASE 202:
        RMSSetProjectorTemperatureFault(0)
        break

    }
  }
}

(*******************************************)
(* CHANNEL: vdv_proj2                      *)
(*******************************************)
CHANNEL_EVENT [vdv_proj2,0]
{
  // Channel On
  ON:
  {
    SWITCH (CHANNEL.CHANNEL)
    {
      CASE 203:
        RMSSetProjectorFanOperation(1)
        break

    }
  }

  // Channel Off
  OFF:
  {
    SWITCH (CHANNEL.CHANNEL)
    {
      CASE 203:
        RMSSetProjectorFanOperation(0)
        break

    }
  }
}

(*******************************************)
(* CHANNEL: vdv_proj2                      *)
(*******************************************)
CHANNEL_EVENT [vdv_proj2,0]
{
  // Channel On
  ON:
  {
    SWITCH (CHANNEL.CHANNEL)
    {
      CASE 204:
        RMSSetProjectorPowerSupply(1)
        break

    }
  }

  // Channel Off
  OFF:
  {
    SWITCH (CHANNEL.CHANNEL)
    {
      CASE 204:
        RMSSetProjectorPowerSupply(0)
        break

    }
  }
}

(*******************************************)
(* CHANNEL: vdv_proj2                      *)
(*******************************************)
CHANNEL_EVENT [vdv_proj2,0]
{
  // Channel On
  ON:
  {
    SWITCH (CHANNEL.CHANNEL)
    {
      CASE 205:
        RMSSetProjectorLampFailure(1)
        break

    }
  }

  // Channel Off
  OFF:
  {
    SWITCH (CHANNEL.CHANNEL)
    {
      CASE 205:
        RMSSetProjectorLampFailure(0)
        break

    }
  }
}


(*******************************************)
(* DATA: i!-ConnectLinx Engine             *)
(*******************************************)
DATA_EVENT[vdvCLActions]
{
  STRING:
  {
    STACK_VAR
    CHAR    cTemp[1000]
    CHAR    cTrash[10]
    INTEGER nId

    // Look for arguments
    IF (LEFT_STRING(DATA.TEXT,3) = 'ARG')
    {
      // Get arg ID
      cTemp = DATA.Text
      cTrash = REMOVE_STRING(cTemp,'ARG',1)
      nId = ATOI(cTemp)
      cTrash = REMOVE_STRING(cTemp,'-',1)

      // Store it if we have room
      IF (MAX_LENGTH_ARRAY(acStringEnumArgValues) >= nId)
        acStringEnumArgValues [nId] = cTemp
    }
  }

  ONLINE:
  {
    // Set Room Info
    SEND_COMMAND DATA.DEVICE,'SET ROOM INFO-SC339,Science Center,Tito'

  }
}

(***********************************************************)
(*              THE ACTUAL PROGRAM GOES BELOW              *)
(***********************************************************)
DEFINE_PROGRAM

(***********************************************************)
(*                     END OF PROGRAM                      *)
(*         DO NOT PUT ANY CODE BELOW THIS COMMENT          *)
(***********************************************************)
