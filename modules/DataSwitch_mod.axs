MODULE_NAME='DataSwitch_mod' (DEV dvreal, DEV vdvproxy)
(***********************************************************)
(* System Type : NetLinx                                   *)
(***********************************************************)
(* REV HISTORY:                                            *)
(***********************************************************)

(***********************************************************)
(*          DEVICE NUMBER DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_DEVICE

//dvdKMSwitch = DYNAMIC_VIRTUAL_DEVICE

(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT

VOLATILE INTEGER in1 = 101
VOLATILE INTEGER in2 = 102
VOLATILE INTEGER connect = 255

VOLATILE INTEGER BB_channels[] =
{
  1,    //PC
  2,    //Mac
  3     //Status Request
}

VOLATILE CHAR BB_commands[][] =
{
 {$31,$0D}, //PC
 {$32,$0D}, //Mac
 {$3F}  //Status Request
}

VOLATILE INTEGER BBnoresp = 1 
VOLATILE INTEGER BBpoll   = 2
(***********************************************************)
(*              DATA TYPE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_TYPE

STRUCTURE KMswitch{
  INTEGER response
  INTEGER source   //1 = pc, 2 = mac
}

(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE

INTEGER count    
VOLATILE CHAR sKMBuff[10]
KMSwitch KM1
VOLATILE LONG BBnoresptime[1] 
VOLATILE LONG BBpolltime[1] 

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

(***********************************************************)
(*                STARTUP CODE GOES BELOW                  *)
(***********************************************************)
DEFINE_START

//TRANSLATE_DEVICE(dvdKMSwitch,vdvKMSwitch)

KM1.source = 0
CREATE_BUFFER dvreal, sKMBuff
CLEAR_BUFFER sKMBuff

BBnoresptime[1] = 30000
TIMELINE_CREATE(BBnoresp,BBnoresptime,1,TIMELINE_RELATIVE,TIMELINE_REPEAT)

BBpolltime[1] = 10000
TIMELINE_CREATE(BBpoll,BBpolltime,1,TIMELINE_RELATIVE,TIMELINE_REPEAT)

(***********************************************************)
(*                THE EVENTS GO BELOW                      *)
(***********************************************************)
DEFINE_EVENT

DATA_EVENT[dvreal]
{
  ONLINE:
  {
    SEND_COMMAND dvreal,'SET BAUD 9600,N,8,1 485 DISABLE'
    SEND_STRING dvreal,"$3F"
  }
  OFFLINE:
  {
    OFF[vdvproxy,connect]
    OFF[vdvproxy,in1]
    OFF[vdvproxy,in2]
  }
  STRING:
  { 
    STACK_VAR CHAR leftchar1[1]
    TIMELINE_PAUSE(BBnoresp)
    ON[KM1.response]
    ON[vdvproxy,connect]
    IF(FIND_STRING(sKMBuff,"$0D",2))    //switcher response for input change on device
    {
      leftchar1 = LEFT_STRING(sKMBuff,1)
      SWITCH (leftchar1)
      {
        CASE '1' :
        {
		  KM1.source = 1
	      ON[vdvproxy,in1]
		  OFF[vdvproxy,in2]
		}
        CASE '2' :
		{
		  KM1.source = 2
		  ON[vdvproxy,in2]
		  OFF[vdvproxy,in1]
		}  
      }
      CLEAR_BUFFER sKMBuff     
    }
    ELSE				//switcher response for status request
    {
      IF(LEFT_STRING(sKMBuff,1) == "$00")
      {
          KM1.source = 1
	      ON[vdvproxy,in1]
		  OFF[vdvproxy,in2]
      }      
      IF(LEFT_STRING(sKMBuff,1) == "$01")
      {
          KM1.source = 2
	      ON[vdvproxy,in2]
		  OFF[vdvproxy,in1]
      }
      CLEAR_BUFFER sKMBuff
    }
    TIMELINE_SET(BBnoresp,0)  
    TIMELINE_RESTART(BBnoresp)
  }
}

TIMELINE_EVENT[BBnoresp]
{
  KM1.source = 0
  OFF[KM1.response]
  OFF[vdvproxy,connect]	//online feedback
  OFF[vdvproxy,in1]
  OFF[vdvproxy,in2]
}

TIMELINE_EVENT[BBpoll]
{
  SEND_STRING dvreal,"BB_commands[3]"
}

CHANNEL_EVENT[vdvproxy,BB_channels]
{
  ON:
  {
    SEND_STRING dvreal,"BB_commands[channel.channel]"
  }
}
(***********************************************************)
(*            THE ACTUAL PROGRAM GOES BELOW                *)
(***********************************************************)
DEFINE_PROGRAM

(***********************************************************)
(*                     END OF PROGRAM                      *)
(*        DO NOT PUT ANY CODE BELOW THIS COMMENT           *)
(***********************************************************)










