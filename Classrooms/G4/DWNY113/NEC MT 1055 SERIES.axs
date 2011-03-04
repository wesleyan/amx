MODULE_NAME='NEC MT 1055 SERIES' (DEV dvProj, DEV vdvProj)
(*{{PS_SOURCE_INFO(PROGRAM STATS)                          *)
(***********************************************************)
(*  FILE CREATED ON: 08/14/2002 AT: 14:09:13               *)
(***********************************************************)
(*  FILE_LAST_MODIFIED_ON: 10/20/2003 AT: 16:15:50         *)
(***********************************************************)
(*  ORPHAN_FILE_PLATFORM: 1                                *)
(***********************************************************)
(*!!FILE REVISION: Rev 0                                   *)
(*  REVISION DATE: 09/27/2002                              *)
(*                                                         *)
(*  COMMENTS:                                              *)
(*                                                         *)
(***********************************************************)
(*!!FILE REVISION: Rev 0                                   *)
(*  REVISION DATE: 09/27/2002                              *)
(*                                                         *)
(*  COMMENTS:                                              *)
(*                                                         *)
(***********************************************************)
(*!!FILE REVISION: Rev 0                                   *)
(*  REVISION DATE: 08/14/2002                              *)
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

vdProj             = DYNAMIC_VIRTUAL_DEVICE

(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT
// CHANNEL COMMANDS
PROJ_POW_ON     = 1
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
// FEEDBACK CHANNELS ONLY
PROJ_COOLING    = 2
PROJ_WARMING    = 3

//TIMELINES
FEEDBACK1       = 1
PROJ_POLL1      = 2
PROJ_POLL2      = 3
PROJ_POLL3      = 4
PROJ_POLL4      = 5


ProjQueueMAX        = 10
MAX_PROJ_WARM_TIME  = 300 // 60 SECS MAX WARM TIME

(***********************************************************)
(*              DATA TYPE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_TYPE

(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE

CHAR ProjQueue[ProjQueueMAX][20]
INTEGER ProjQueueHead
INTEGER ProjQueueTail
INTEGER ProjQueueIsReady
INTEGER ProjQueueHasItems

CHAR cProjBuffer[1000]
CHAR MSG[255]
INTEGER LEN

LONG lTimeArray[1]

LONG lLampSeconds

INTEGER POWER
INTEGER COOLING
INTEGER WARMING
INTEGER MUTE
INTEGER COVER_OPEN
INTEGER TEMP_FAULT
INTEGER FAN_STOP
INTEGER PWR_SUPPLY
INTEGER LAMP_FAIL
INTEGER COMM_ACTIVE

(***********************************************************)
(*               LATCHING DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_LATCHING

(***********************************************************)
(*       MUTUALLY EXCLUSIVE DEFINITIONS GO BELOW           *)
(***********************************************************)
DEFINE_MUTUALLY_EXCLUSIVE

(***********************************************************)
(*        SUBROUTINE/FUNCTION DEFINITIONS GO BELOW         *)
(***********************************************************)
(* EXAMPLE: DEFINE_FUNCTION <RETURN_TYPE> <NAME> (<PARAMETERS>) *)
(* EXAMPLE: DEFINE_CALL '<NAME>' (<PARAMETERS>) *)

DEFINE_CALL 'CHECK PROJ QUEUE'
{
  IF (ProjQueueHasItems AND ProjQueueIsReady)
  {
    OFF[ProjQueueIsReady]
    IF (ProjQueueTail = ProjQueueMax)  
      ProjQueueTail = 1
    ELSE
      ProjQueueTail = ProjQueueTail + 1 
    IF (ProjQueueTail = ProjQueueHead)
      OFF[ProjQueueHasItems]
    
    SEND_STRING dvProj, ProjQueue[ProjQueueTail]
    
    WAIT 5 'PROJ QUEUE'
      ON[ProjQueueIsReady]
  }
}

DEFINE_CALL 'ADD TO PROJ QUEUE' (CHAR cCMD[])
{
  IF (ProjQueueHead = ProjQueueMAX) 
  {  
    IF (ProjQueueTail <> 1)
    {
      ProjQueueHead = 1
      ProjQueue[ProjQueueHead] = cCMD 
      
      ON[ProjQueueHasItems]
    }
  }
  ELSE IF (ProjQueueTail <> ProjQueueHead + 1)
  {
    ProjQueueHead = ProjQueueHead + 1
    ProjQueue[ProjQueueHead] = cCMD
   
    ON[ProjQueueHasItems]
  }
}

(***********************************************************)
(*                STARTUP CODE GOES BELOW                  *)
(***********************************************************)
DEFINE_START

ProjQueueHead     = 1
ProjQueueTail     = 1
ProjQueueIsReady  = 1
ProjQueueHasItems = 0

TRANSLATE_DEVICE(vdvProj,vdProj)

CREATE_BUFFER dvProj,cProjBuffer

lTimeArray[1] = 1000
TIMELINE_CREATE(FEEDBACK1,lTimeArray,1,TIMELINE_RELATIVE,TIMELINE_REPEAT)

lTimeArray[1] = 5000 // POLL STATUS EVERY 5 SECONDS
TIMELINE_CREATE(PROJ_POLL1,lTimeArray,1,TIMELINE_RELATIVE,TIMELINE_REPEAT)

lTimeArray[1] = 300000 // POLL LAMP USE EVERY 5 MINUTES
TIMELINE_CREATE(PROJ_POLL2,lTimeArray,1,TIMELINE_RELATIVE,TIMELINE_REPEAT)

lTimeArray[1] = 60000 // POLL FOR ERRORS EVERY 1 MINUTE
TIMELINE_CREATE(PROJ_POLL3,lTimeArray,1,TIMELINE_RELATIVE,TIMELINE_REPEAT)

lTimeArray[1] = 20000 // E-MAIL ALERT IF NO COMM FOR 20 SECONDS
TIMELINE_CREATE(PROJ_POLL4,lTimeArray,1,TIMELINE_RELATIVE,TIMELINE_REPEAT)

OFF[vdProj,PROJ_POW_OFF] // SET INITIAL STATES
OFF[vdProj,PROJ_COOLING]
OFF[vdProj,PROJ_WARMING]
OFF[vdProj,PROJ_POW_ON ]
OFF[vdProj,PROJ_MUTE]
OFF[vdProj,PROJ_COMM_ACTIVE]
MUTE    = 0
COOLING = 0
POWER   = 0
WARMING = 0
COMM_ACTIVE = 0


(***********************************************************)
(*                THE EVENTS GOES BELOW                    *)
(***********************************************************)
DEFINE_EVENT

TIMELINE_EVENT[FEEDBACK1]
{
  CALL 'CHECK PROJ QUEUE'
  IF(POWER && (NOT WARMING))
  {
    ON[vdProj,PROJ_POW_ON]
  }
  ELSE
  {
    OFF[vdProj,PROJ_POW_ON]
  }
  
  IF(COOLING)
  {
    ON[vdProj,PROJ_COOLING]
  }
  ELSE
  {
    OFF[vdProj,PROJ_COOLING]
  }
  
  IF(WARMING)
  {
    ON[vdProj,PROJ_WARMING]
  }
  ELSE
  {
    OFF[vdProj,PROJ_WARMING]
  }
  
  IF(NOT(POWER || COOLING || WARMING))
  {
    WAIT 300 'EXTRA COOLING'
    {
      ON[vdProj,PROJ_POW_OFF]
    }
  }
  ELSE
  {
    CANCEL_WAIT 'EXTRA COOLING'
    OFF[vdProj,PROJ_POW_OFF]
  }
  
  IF(MUTE)
  {
    ON[vdProj,PROJ_MUTE]
  }
  ELSE
  {
    OFF[vdProj,PROJ_MUTE]
  }
  IF (COVER_OPEN)
  {
    ON[vdProj,PROJ_COVER_OPEN]
  }
  ELSE
  {
    OFF[vdProj,PROJ_COVER_OPEN]
  }
  IF (TEMP_FAULT)
  {
    ON[vdProj,PROJ_TEMP_FAULT]
  }
  ELSE
  {
    OFF[vdProj,PROJ_TEMP_FAULT]
  }
  IF (FAN_STOP)
  {
    ON[vdProj,PROJ_FAN_STOP]
  }
  ELSE
  {
    OFF[vdProj,PROJ_FAN_STOP]
  }
  IF (PWR_SUPPLY)
  {
    ON[vdProj,PROJ_PWR_SUPPLY]
  }
  ELSE
  {
    OFF[vdProj,PROJ_PWR_SUPPLY]
  }
  IF (LAMP_FAIL)
  {
    ON[vdProj,PROJ_LAMP_FAIL]
  }
  ELSE
  {
    OFF[vdProj,PROJ_LAMP_FAIL]
  }
  IF (COMM_ACTIVE)
  {
    ON[vdProj,PROJ_COMM_ACTIVE]
  }
  ELSE
  {
    OFF[vdProj,PROJ_COMM_ACTIVE]
  }
}

TIMELINE_EVENT[PROJ_POLL1]  // EVERY 5 SECONDS
{
  // POWER STATUS POLL
  CALL 'ADD TO PROJ QUEUE' ("$00,$C0,$00,$00,$00,$C0") // POLL SYSTEM STATUS
}

TIMELINE_EVENT[PROJ_POLL2]  // EVERY 5 MIN
{
  // LAMP STATUS POLL
  CALL 'ADD TO PROJ QUEUE' ("$03,$8C,$00,$00,$00,$8F") // POLL LAMP TIME
}

TIMELINE_EVENT[PROJ_POLL3]  // EVERY 1 MIN
{
  // LAMP STATUS POLL
  CALL 'ADD TO PROJ QUEUE' ("$00,$88,$00,$00,$00,$88") // POLL ERRORS
}

TIMELINE_EVENT[PROJ_POLL4]  // EVERY 1 MIN
{
  OFF [COMM_ACTIVE]
  TIMELINE_PAUSE (PROJ_POLL4)
}

DATA_EVENT[dvProj]
{
  ONLINE:
  {
    SEND_COMMAND dvProj,"'SET BAUD 9600 N,8,1 485 DISABLE'"
    WAIT 15
    {
      CALL 'ADD TO PROJ QUEUE' ("$03,$8C,$00,$00,$00,$8F") // GET AN INITIAL LAMP VALUE ON START-UP
      CLEAR_BUFFER cProjBuffer
    }
  }
}

DATA_EVENT[vdProj]
{
  COMMAND:
  {
    SELECT
    {
      ACTIVE(FIND_STRING(DATA.TEXT,'PON',1)):
      {
        SEND_STRING 0,'GOT POWER ON TO PROJECTOR'
        CALL 'ADD TO PROJ QUEUE' ("$02,$00,$00,$00,$00,$02")
        ON[WARMING]
        WAIT MAX_PROJ_WARM_TIME 'PROJECTOR WARMING'
        {
          OFF[WARMING]
          ON[POWER]
        }
      }
      ACTIVE(FIND_STRING(DATA.TEXT,'POF',1)):
      {
        SEND_STRING 0,'GOT POWER OFF TO PROJECTOR'
        CALL 'ADD TO PROJ QUEUE' ("$02,$01,$00,$00,$00,$03")
      }
    }
  }
}

CHANNEL_EVENT[vdProj,0] // DO CHANNEL BASED COMMANDS
{
  ON:
  {
    SWITCH(CHANNEL.CHANNEL)
    {
      CASE PROJ_MUTE:
      {
        CALL 'ADD TO PROJ QUEUE' ("$02,$10,$00,$00,$00,$12")  // MUTE
        ON[vdProj,PROJ_MUTE]
        MUTE = 1
      }
      CASE PROJ_LAMP_RESET:
      {
        CALL 'ADD TO PROJ QUEUE' ("$03,$8B,$00,$00,$05,$02,$00,$00,$00,$00,$95") // SET REGULAR LAMP MODE TO 0
        CALL 'ADD TO PROJ QUEUE' ("$03,$8B,$00,$00,$05,$06,$00,$00,$00,$00,$99") // SET ECONO LAMP MODE TO 0
      }
      CASE PROJ_RGB1_IN:
      {
        CALL 'ADD TO PROJ QUEUE' ("$02,$03,$00,$00,$02,$01,$01,$09")  // RGB 1
        ON[vdProj,PROJ_RGB1_IN]
        OFF[vdProj,PROJ_RGB2_IN]
        OFF[vdProj,PROJ_VID_IN]
        OFF[vdProj,PROJ_SVID_IN]
      }
      CASE PROJ_RGB2_IN:
      {
        CALL 'ADD TO PROJ QUEUE' ("$02,$03,$00,$00,$02,$01,$02,$0A")  // RGB 2
        OFF[vdProj,PROJ_RGB1_IN]
        ON[vdProj,PROJ_RGB2_IN]
        OFF[vdProj,PROJ_VID_IN]
        OFF[vdProj,PROJ_SVID_IN]
      }
      CASE PROJ_VID_IN:
      {
        CALL 'ADD TO PROJ QUEUE' ("$02,$03,$00,$00,$02,$01,$06,$0E")  // VIDEO
        OFF[vdProj,PROJ_RGB1_IN]
        OFF[vdProj,PROJ_RGB2_IN]
        ON[vdProj,PROJ_VID_IN]
        OFF[vdProj,PROJ_SVID_IN]
      }
      CASE PROJ_SVID_IN:
      {
        CALL 'ADD TO PROJ QUEUE' ("$02,$03,$00,$00,$02,$01,$0B,$13")  // S-VIDEO
        OFF[vdProj,PROJ_RGB1_IN]
        OFF[vdProj,PROJ_RGB2_IN]
        OFF[vdProj,PROJ_VID_IN]
        ON[vdProj,PROJ_SVID_IN]
      }
    }
  }
  OFF:
  {
    IF(CHANNEL.CHANNEL = PROJ_MUTE)
    {
      CALL 'ADD TO PROJ QUEUE' ("$02,$11,$00,$00,$00,$13")  // UNMUTE
      OFF[vdProj,PROJ_MUTE]
      MUTE = 0
    }
  }
}

(***********************************************************)
(*            THE ACTUAL PROGRAM GOES BELOW                *)
(***********************************************************)
DEFINE_PROGRAM

IF(LENGTH_STRING(cProjBuffer)>5)
{
  LEN = LENGTH_STRING(cProjBuffer)
  IF(cProjBuffer[5] <= LEN-6) // DO WE HAVE THE WHOLE MESSAGE?
  {
    ON[COMM_ACTIVE]
    TIMELINE_SET (PROJ_POLL4,0)
    TIMELINE_RESTART (PROJ_POLL4)
    MSG = GET_BUFFER_STRING(cProjBuffer,cProjBuffer[5]+6)
    
    SELECT
    {
      ACTIVE((MSG[1]=$20)&&(MSG[2]=$C0)): // SYSTEM STATUS POLL RESPONSE
      {
        IF(!WARMING)
          POWER = MSG[9]
        COOLING = MSG[10]
        MUTE = (MSG[34] & $0F)
      }
      ACTIVE((MSG[1]=$20)&&(MSG[2]=$10)): // MUTE ON ACK
      {
        MUTE = 1
      }
      ACTIVE((MSG[1]=$20)&&(MSG[2]=$11)): // MUTE OFF ACK
      {
        MUTE = 0
      }
      ACTIVE((MSG[1]=$22)&&(MSG[2]=$00)): // POWER ON ACK
      {
        POWER = 1
      }
      ACTIVE((MSG[1]=$A2)&&(MSG[2]=$01)): // POWER OFF NACK
      {
        SEND_STRING 0,'POWER OFF NACK!'
      }
      ACTIVE((MSG[1]=$23)&&(MSG[2]=$8C)): // LAMP TIME RESPONSE
      {
        lLampSeconds = MSG[6] + MSG[7]*256 + MSG[8]*65536 + MSG[9]*16777216
        lLampSeconds = lLampSeconds + MSG[10] + MSG[11]*256 + MSG[12]*65536 + MSG[13]*16777216
        SEND_STRING vdProj,"ITOA(lLampSeconds),13,10"
      }
      ACTIVE((MSG[1]=$20)&&(MSG[2]=$88)): // ERROR RESPONSE
      {
        COVER_OPEN = MSG[6] & $01
        TEMP_FAULT = MSG[6] & $02
        FAN_STOP   = MSG[6] & $08
        PWR_SUPPLY = MSG[6] & $20
        LAMP_FAIL  = MSG[6] & $40
      }
    }
  }
}

(***********************************************************)
(*                     END OF PROGRAM                      *)
(*        DO NOT PUT ANY CODE BELOW THIS COMMENT           *)
(***********************************************************)

