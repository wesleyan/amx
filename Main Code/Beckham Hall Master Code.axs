PROGRAM_NAME='Beckham Hall Master Code'
(***********************************************************)
(***********************************************************)
(*  FILE_LAST_MODIFIED_ON: 04/05/2006  AT: 09:00:25        *)
(***********************************************************)
(* System Type : NetLinx                                   *)
(***********************************************************)
(* REV HISTORY:                                            *)
(***********************************************************)
(*
    $History: $
*)
(***********************************************************)
(*          DEVICE NUMBER DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_DEVICE
dv_relay = 5001:8:0 //Channel 1- Up, Channel 2-Down
dvTouchPanel = 10011:1:0
dvVolume = 2001:1:0
dvMics = 2001:2:0
dvProjector = 5001:9:0
vdvProjector = 33001:1:0
dvRS232Proj = 5001:1:0
(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT
VOLATILE INTEGER volume_step = 5
(***********************************************************)
(*              DATA TYPE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_TYPE

(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE
INTEGER intVolumeLevel1 = 127
INTEGER intVolumeLevel2 = 127
INTEGER intVolumeLevel3 = 127
INTEGER intVolumeLevel4 = 127
PERSISTENT INTEGER volume 
VOLATILE INTEGER volume_mute
VOLATILE INTEGER volume_mute_level
VOLATILE INTEGER max_volume = 255 - volume_step
VOLATILE INTEGER min_volume = volume_step
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
SEND_COMMAND dvProjector, "'SET BAUD 9600,N,8,1 485 DISABLE'"
CREATE_LEVEL dvVolume,1,intVolumeLevel1
CREATE_LEVEL dvVolume,2,intVolumeLevel2
CREATE_LEVEL dvVolume,3,intVolumeLevel3
CREATE_LEVEL dvVolume,4,intVolumeLevel4


(***********************************************************)
(*                THE EVENTS GO BELOW                      *)
(***********************************************************)
DEFINE_EVENT
BUTTON_EVENT[dvTouchPanel,30]              //volume up
{
    PUSH:
    {
	IF(volume_mute_level <= max_volume && volume_mute == 1)
	{
	    volume = volume_mute_level
	    volume_mute = 0
	    SEND_LEVEL dvVolume,1,volume
	    SEND_LEVEL dvVolume,2,volume
	    SEND_LEVEL dvTouchPanel,3,volume
	}
	ELSE IF(volume <= max_volume && volume_mute == 0)
	{
	    volume = volume + volume_step
	    SEND_LEVEL dvVolume,1,volume
	    SEND_LEVEL dvVolume,2,volume
	    SEND_LEVEL dvTouchPanel,3,volume
	}
    }
    
    HOLD[1,REPEAT]:
    {
	IF(volume_mute_level <= max_volume && volume_mute == 1)
	{
	    volume = volume_mute_level
	    volume_mute = 0
	    SEND_LEVEL dvVolume,1,volume
	    SEND_LEVEL dvVolume,2,volume
	    SEND_LEVEL dvTouchPanel,3,volume
	}
	ELSE IF(volume <= max_volume && volume_mute == 0)
	{
	    volume = volume + volume_step
	    SEND_LEVEL dvVolume,1,volume
	    SEND_LEVEL dvVolume,2,volume
	    SEND_LEVEL dvTouchPanel,3,volume
	}
    }
}
BUTTON_EVENT[dvTouchPanel,31]              //volume down
{
    PUSH:
    {
	IF(volume_mute_level >= min_volume && volume_mute == 1)
	{
	    volume = volume_mute_level
	    volume_mute = 0
	    SEND_LEVEL dvVolume,1,volume
	    SEND_LEVEL dvVolume,2,volume
            SEND_LEVEL dvTouchPanel,3,volume
	}
	ELSE IF(volume >= min_volume && volume_mute == 0)
	{
	    volume = volume - volume_step
	    SEND_LEVEL dvVolume,1,volume
	    SEND_LEVEL dvVolume,2,volume
            SEND_LEVEL dvTouchPanel,3,volume
	}
    }
    
    HOLD[1,REPEAT]:
    {
	IF(volume_mute_level >= min_volume && volume_mute == 1)
	{
	    volume = volume_mute_level
	    volume_mute = 0
	    SEND_LEVEL dvVolume,1,volume
	    SEND_LEVEL dvVolume,2,volume
            SEND_LEVEL dvTouchPanel,3,volume
	}
	ELSE IF(volume >= min_volume && volume_mute == 0)
	{
	    volume = volume - volume_step
	    SEND_LEVEL dvVolume,1,volume
	    SEND_LEVEL dvVolume,2,volume
            SEND_LEVEL dvTouchPanel,3,volume
	}
    }
}
BUTTON_EVENT[dvTouchPanel,32]              //volume mute
{
    RELEASE:
    {
	IF(volume_mute == 0)
	{
	  volume_mute = 1
	  volume_mute_level = volume
	  volume = 0
	  SEND_LEVEL dvVolume,1,volume
	  SEND_LEVEL dvVolume,2,volume
	  SEND_LEVEL dvTouchPanel,3,volume
	}
	
	ELSE
	{
	  volume_mute = 0
	  volume = volume_mute_level
	  SEND_LEVEL dvVolume,1,volume
	  SEND_LEVEL dvVolume,2,volume
	  SEND_LEVEL dvTouchPanel,3,volume
	}
	
    }
}

BUTTON_EVENT[dvTouchPanel,1]
{
    PUSH:
    {
    PULSE[dvProjector,9]
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

