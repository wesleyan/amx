MODULE_NAME='MLS506MA_modrevB'(DEV dvreal, DEV vdvVSMod, DEV vdvGainMod, DEV vdvTrebleMod, DEV vdvBassMod,DEV vdvVolumeMod)
//PROGRAM_NAME='MLS506MA_modrevBNOMOD'
//MODULE_NAME='MLS506MA_modrevB'(DEV dvreal, DEV vdvVSMod, DEV vdvGainMod, DEV vdvTrebleMod, DEV vdvBassMod,DEV vdvVolumeMod)
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

(*
vdvVSMod = 33001:1:0
vdvGainMod = 33001:2:0
vdvTrebleMod = 33001:3:0
vdvBassMod = 33001:4:0
vdvVolumeMod = 33001:5:0
dvreal = 5001:1:0
*)

(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT
VOLATILE INTEGER VSMod_aud_vid_input[] =
{
  1,2,3,4,5,6,7
}
VOLATILE INTEGER VSMod_vid_only_input[] =
{
  11,12,13,14,15,16
}

VOLATILE INTEGER VSMod_aud_only_input[] = 
{
  21,22,23,24,25,26,27
}
VOLATILE INTEGER VSMOD_vid_signal_type[] = 
{
  30,31,32,33,34,35
}
VOLATILE INTEGER VSMod_Exec_Mode_Lock = 40
VOLATILE INTEGER VSMod_Exec_Mode_Unlock = 41

VOLATILE INTEGER VSMod_RGB_Delay_Time[] =
{
  50,51,52,53,54,55,56,57,58,59,60
}

VOLATILE INTEGER VSMod_video_fb_chn[]=
{
    111,
    112,
    113,
    114,
    115,
    116
}

VOLATILE INTEGER VSMod_audio_fb_chn[]=
{
    121,
    122,
    123,
    124,
    125,
    126,
    127
}

(*
VOLATILE INTEGER VSMod_Vid_Type_fb[] =
{
  100,101,102,103,104,105,111,112,113,114,115,116,117,118,119,120,121
}
*)
//Note: The Audio channels act as feedback and control- If a channel is "on", the system currently reflects that status.
VOLATILE INTEGER VSMod_Volume_chn[] = //0% - 100%
{
1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,
25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,
51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,
78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101
}
VOLATILE INTEGER VSMod_Volume_chn_fb[] = //0% - 100%
{
125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,145,146,147,148,
149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,166,167,168,169,170,171,172,173,174,
175,176,177,178,179,180,181,182,183,184,185,186,187,188,189,190,191,192,193,194,195,196,197,198,199,200,201,
202,203,204,205,206,207,208,209,210,211,212,213,214,215,216,217,218,219,220,221,222,223,224,225
}


VOLATILE INTEGER VSMod_Gain_chn[] = 
{
1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,
25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,
51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,
78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101
}
VOLATILE SINTEGER VSMod_Treble_chn[] = 
{
1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
}

VOLATILE INTEGER VSMod_Bass_chn[] = 
{
1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
}

VOLATILE SINTEGER VSMod_db_levels[] = 
{
-14,-12,-10,-8,-6,-5,-4,-2,0,2,4,6,8,10,12,14
}

VOLATILE INTEGER VSMod_Gain_fb[] = 
{
102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,
126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,145,146,147,148,149,150,151,
152,153,154,155,156,157,158,159,160,161,162,163,164,165,166,167,168,169,170,171,172,173,174,175,176,177,178,
179,180,181,182,183,184,185,186,187,188,189,190,191,192,193,194,195,196,197,198,199,200,201,202
}

VOLATILE INTEGER mlsnoresp = 1
VOLATILE INTEGER mlspoll = 2
VOLATILE CHAR errorResponses[4][3] = 
{
  'E01', //Invalid Input Channel Number
  'E10', //Invalid command
  'E13', //Invalid Value(Out of range)
  'E14' //Invalid for this configuration
  
}

VOLATILE CHAR mlsMultipleResCodes[2][2] =
{
  'Vi',
  'In'
}

VOLATILE CHAR mlsSingleResCodes[15][9] =
{
  'Chn',
  'Aud',
  'Vid',
  'Typ',
  'Amt',
  'Vol',
  'Exe',
  'Ver',
  'Zap',
  'RGBDly',
  'PreAmpMod',
  'EffectIn',
  'Balance',
  'SpkrLoad'
}

VOLATILE CHAR mlsAudioResponses[3][3] =
{
  'Aud',
  'Trb',
  'Bas'
}

VOLATILE CHAR mlsInformationResponseCodes[7][4] =
{
  'G',
  '>',
  '<',
  'Z',
  'V',
  'X',
  'I'
}
CHAR eq_commands[] = 
{
    'G',
    '>',
    '<'
}
CHAR boolean_commands[] = 
{
   'Z',
   'X'
}

VOLATILE LONG TL_PROJ_QUEUE = 3   //TL to clear queues
VOLATILE LONG TL_PROJ_REQUEST = 4 //TL to add fill request queue


(********** TIMELINE ARRAYS ***********)
LONG lTL1_Array[1] =  //TL_PROJ_QUEUE
{
	250
}

LONG lTL2_Array[1] =  // TL_PROJ_REQUEST
{
	1000
}
LONG lTL3_Array[1] =  //TL_NO_RESP
{
	30000
}


VOLATILE INTEGER AMute_ON_chn = 105
VOLATILE INTEGER AMute_OFF_chn = 106
VOLATILE INTEGER AMute_fb_chn = 230

(***********************************************************)
(*              DATA TYPE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_TYPE

//main structure to hold all Extron variables
STRUCTURE Extron
{
  INTEGER videoSource
  INTEGER audioSource
  INTEGER audioLevelSource
  INTEGER videotype
  INTEGER audioMute
  INTEGER rgbMute
  INTEGER rgbDelayTime
  INTEGER error
  INTEGER response
  FLOAT Switcher_comm_ver
  Integer MaxChannel
  CHAR part_number[15]
  CHAR projector_config[20]
  INTEGER volumeLevel
  SINTEGER bassLevel
  SINTEGER trebleLevel
  INTEGER gainLevel
  INTEGER audioClip
  INTEGER executiveMode
  INTEGER effectIn
  INTEGER preAmpMod
  INTEGER balance
}

//command and request queues
STRUCTURE queueitem
{
	CHAR sCommand[15]
	CHAR cQtype
}


//dont know
STRUCTURE debugVars
{
  CHAR debugChar[20]
  INTEGER debugInt
}

(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE

INTEGER vol

INTEGER count

VOLATILE CHAR mlsBuff[100]

VOLATILE LONG mlsnoresptime[1]
VOLATILE LONG mlspolltime[1]

  
VOLATILE LONG cmd_cycle_time = 500
VOLATILE INTEGER cmd_req_ratio = 3

INTEGER marker_checkqueue

queueitem _CommandQ[50]	//commands sent (user created)
queueitem _RequestQ[50] //requests made (sent at interval for status updates)
INTEGER QueuePower

Extron mls506ma

debugVars deBug1

(*
VOLATILE CHAR command_queue[5][20] = {'','','','',''}
VOLATILE INTEGER queue_clear = 1 
VOLATILE LONG mlsInfoCount
*)


(***********************************************************)
(*               LATCHING DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_LATCHING

(***********************************************************)
(*       MUTUALLY EXCLUSIVE DEFINITIONS GO BELOW           *)
(***********************************************************)
DEFINE_MUTUALLY_EXCLUSIVE
//([vdvVolumeMod,1]..[vdvVolumeMod,101])
//([vdvVolumeMod,102],[vdvVolumeMod,103])
//([vdvVolumeMod,104],[vdvVolumeMod,105])
//([vdvVolumeMod,201],[vdvVolumeMod,202])
([vdvGainMod,1]..[vdvGainMod,101])
([vdvGainMod,203]..[vdvGainMod,204])
([vdvTrebleMod,1]..[vdvTrebleMod,15])
([vdvTrebleMod,203],[vdvTrebleMod,204])
([vdvTrebleMod,101],[vdvTrebleMod,115])
([vdvBassMod,1]..[vdvBassMod,15])
([vdvBassMod,203],[vdvBassMod,204])
([vdvBassMod,101]..[vdvBassMod,115])


(***********************************************************)
(*        SUBROUTINE/FUNCTION DEFINITIONS GO BELOW         *)
(***********************************************************)
(* EXAMPLE: DEFINE_FUNCTION <RETURN_TYPE> <NAME> (<PARAMETERS>) *)
(* EXAMPLE: DEFINE_CALL '<NAME>' (<PARAMETERS>) *)

DEFINE_FUNCTION video_switch(INTEGER switch_type,INTEGER input)
{
  //Switch type = 0,1,2 - 0=both audio and video, 1=audio only, 2=video only.
  SWITCH(switch_type)
  {
    CASE 0:
    {
			putqueue("ITOA(input),'!'",'c')
      (*command_queue[LENGTH_ARRAY(command_queue)+1] = "ITOA(input),'!'"
      SET_LENGTH_ARRAY(command_queue,LENGTH_ARRAY(command_queue)+1)*)
    }
    CASE 1:
    {
			putqueue("ITOA(input),'$'",'c')
     (* command_queue[LENGTH_ARRAY(command_queue)+1] = "ITOA(input),'$'"
      SET_LENGTH_ARRAY(command_queue,LENGTH_ARRAY(command_queue)+1)*)
    }
    CASE 2:
    {
			putqueue("ITOA(input),'&'",'c')
      (*command_queue[LENGTH_ARRAY(command_queue)+1] = "ITOA(input),'&'"
			SET_LENGTH_ARRAY(command_queue,LENGTH_ARRAY(command_queue)+1)*)
    }
  }
}

DEFINE_FUNCTION set_video_configuration(INTEGER source, INTEGER vid_type)
{
  IF(vid_type > 30 && vid_type < 33)
  {
		putqueue("ITOA(source),'*0\'",'c')
    (*command_queue[LENGTH_ARRAY(command_queue)+1] = "ITOA(source),'*0\'"
    SET_LENGTH_ARRAY(command_queue,LENGTH_ARRAY(command_queue)+1)*)
  }
  ELSE IF(vid_type >= 33 && vid_type <= 35)
  {
		putqueue("ITOA(source),'*1\'",'c')
    (*command_queue[LENGTH_ARRAY(command_queue)+1] = "ITOA(source),'*1\'"
    SET_LENGTH_ARRAY(command_queue,LENGTH_ARRAY(command_queue)+1)*)
  }
}


DEFINE_FUNCTION set_audio_eq_level(INTEGER input, INTEGER type, INTEGER value)
{
  //type 1 = gain, type 2 =Treble, type 3 = Bass 
  
	putqueue("ITOA(input),'*',ITOA(value),ITOA(eq_commands[type])",'c')
      (*command_queue[LENGTH_ARRAY(command_queue)+1] = "ITOA(input),'*',ITOA(value),ITOA(eq_commands[type])"
      SET_LENGTH_ARRAY(command_queue,LENGTH_ARRAY(command_queue)+1)*)

}

DEFINE_FUNCTION increment_eq_level(INTEGER input, INTEGER type)
{
//type 1 = gain, type 2 =Treble, type 3 = Bass 
  
	putqueue("ITOA(input),'*+',ITOA(eq_commands[type])",'c')
      (*SET_LENGTH_ARRAY(command_queue,LENGTH_ARRAY(command_queue)+1)
      command_queue[LENGTH_ARRAY(command_queue)] = "ITOA(input),'*+',ITOA(eq_commands[type])"*)
      

}
DEFINE_FUNCTION decrement_eq_level(INTEGER input, INTEGER type)
{
//type 1 = gain, type 2 =Treble, type 3 = Bass 

	putqueue("ITOA(input),'*-',ITOA(eq_commands[type])",'c')
(*      command_queue[LENGTH_ARRAY(command_queue)+1] = "ITOA(input),'*-',ITOA(eq_commands[type])"
      SET_LENGTH_ARRAY(command_queue,LENGTH_ARRAY(command_queue)+1)*)

}
DEFINE_FUNCTION boolean_inputs(INTEGER type, INTEGER status)
{
  //Type: 1-Audio Mute, 2-executive mode
  //Status: 0= off, 1=on
	putqueue("ITOA(status),boolean_commands[type]",'c')
	(*  command_queue[LENGTH_ARRAY(command_queue)+1] = "ITOA(status),boolean_commands[type]"
  SET_LENGTH_ARRAY(command_queue,LENGTH_ARRAY(command_queue)+1)*)
  
  
}

DEFINE_FUNCTION set_volume_level(INTEGER value)
{
	putqueue("ITOA(value),'V'",'c')
(* SET_LENGTH_ARRAY(command_queue,LENGTH_ARRAY(command_queue)+1)
 command_queue[LENGTH_ARRAY(command_queue)] = "ITOA(value),'V'"*)

}
DEFINE_FUNCTION increment_volume_level()
{
	putqueue('+V','c')
(*  SET_LENGTH_ARRAY(command_queue,LENGTH_ARRAY(command_queue)+1)
  command_queue[LENGTH_ARRAY(command_queue)] = '+V'*)
  
}

DEFINE_FUNCTION decrement_volume_level()
{
	putqueue('-V','c')
(*  SET_LENGTH_ARRAY(command_queue,LENGTH_ARRAY(command_queue)+1)
  command_queue[LENGTH_ARRAY(command_queue)] = '-V'*)
  
}

(*
DEFINE_FUNCTION information_request()(**)
{
	putqueue(,'c')
(**)   SET_LENGTH_ARRAY(command_queue,LENGTH_ARRAY(command_queue)+1)
   command_queue[LENGTH_ARRAY(command_queue)] = 'IZ'
  WAIT 50
  {
	putqueue(,'c')
(**)    SET_LENGTH_ARRAY(command_queue,LENGTH_ARRAY(command_queue)+1)
    command_queue[LENGTH_ARRAY(command_queue)] = 'V'
  }
  WAIT 100
  {  
	putqueue(,'c')
(**)   SET_LENGTH_ARRAY(command_queue,LENGTH_ARRAY(command_queue)+1)
   command_queue[LENGTH_ARRAY(command_queue)] = 'G'
  }
  WAIT 125
  {
	putqueue(,'c')
(**)   SET_LENGTH_ARRAY(command_queue,LENGTH_ARRAY(command_queue)+1)
   command_queue[LENGTH_ARRAY(command_queue)] = 'I'
  }
  WAIT 150
  { 
	putqueue(,'c')
(**)   SET_LENGTH_ARRAY(command_queue,LENGTH_ARRAY(command_queue)+1)
   command_queue[LENGTH_ARRAY(command_queue)] = '<'
  }
  WAIT 200
  {
	putqueue(,'c')
(**)    SET_LENGTH_ARRAY(command_queue,LENGTH_ARRAY(command_queue)+1)
    command_queue[LENGTH_ARRAY(command_queue)] = '>'
  }
  WAIT 225
  {
	putqueue(,'c')
(**)    SET_LENGTH_ARRAY(command_queue,LENGTH_ARRAY(command_queue)+1)
    command_queue[LENGTH_ARRAY(command_queue)] = 'I'
  }
  WAIT 250
  {
	putqueue(,'c')
(**)    SET_LENGTH_ARRAY(command_queue,LENGTH_ARRAY(command_queue)+1)
    command_queue[LENGTH_ARRAY(command_queue)] = 'X'
  }
  
}
*)

DEFINE_FUNCTION LONG putqueue (CHAR stringin[],CHAR queuetype)
//call to add string(stringin) to one of the queues 
//for command queue, queuetype = 'c' or 'C'. 
//for request queue, queuetype = 'r' or 'R'.
{
	STACK_VAR queueitem newqitem
	INTEGER result
	
	//newqitem.cID2 = stringin[2]
	newqitem.sCommand = stringin
	//newqitem.cQID = (RANDOM_NUMBER(2000)+1) * (TIME_TO_SECOND(TIME)+1) * (TIME_TO_MINUTE(TIME)+1)
	newqitem.cQtype = queuetype

	SWITCH(queuetype)
	{
		CASE 'c':
		CASE 'C':
		{
			result = 1 //insertintoqueue(newqitem, _CommandQ)
			_CommandQ[LENGTH_ARRAY(_CommandQ)+1] = newqitem
			SET_LENGTH_ARRAY(_CommandQ,LENGTH_ARRAY(_CommandQ)+1)
		
		}
		CASE 'r':
		CASE 'R':
		{
			result = 2 //insertintoqueue(newqitem, _RequestQ)
			_RequestQ[LENGTH_ARRAY(_RequestQ)+1] = newqitem
			SET_LENGTH_ARRAY(_RequestQ,LENGTH_ARRAY(_RequestQ)+1)
		}
	}
	
	RETURN(result)
	
}

DEFINE_FUNCTION LONG popQueue(queueitem queueitem_in[])
//sends first queued string to device.
//removes and shortens queue.
{
	STACK_VAR queueitem thisitem
		INTEGER qcount
	
	IF(LENGTH_ARRAY(queueitem_in))
	{
		thisitem = queueitem_in[1]
		SEND_STRING dvreal, "thisitem.sCommand"
		
		SWITCH(thisitem.cQtype)
		{
			CASE 'c':
			CASE 'C':
			{
				FOR(qcount = 2; qcount <= LENGTH_ARRAY(_CommandQ); qcount++)
				{
					_CommandQ[qcount-1] = _CommandQ[qcount]
				}
				SET_LENGTH_ARRAY(_CommandQ,LENGTH_ARRAY(_CommandQ)-1)
			}
			CASE 'r':
			CASE 'R':
			{
				FOR(qcount = 2; qcount <= LENGTH_ARRAY(_RequestQ); qcount++)
				{
					_RequestQ[qcount-1] = _RequestQ[qcount]
				}
				SET_LENGTH_ARRAY(_RequestQ,LENGTH_ARRAY(_RequestQ)-1)
			}
		}
		RETURN(LENGTH_ARRAY(queueitem_in)-1)
	}
	ELSE
	{
		RETURN(0)
	}
}



(***********************************************************)
(*                STARTUP CODE GOES BELOW                  *)
(***********************************************************)
DEFINE_START

CREATE_BUFFER dvreal, mlsBuff
CLEAR_BUFFER mlsBuff

(*mlsnoresptime[1] = 30000
TIMELINE_CREATE(mlsnoresp,mlsnoresptime,1,TIMELINE_RELATIVE,TIMELINE_REPEAT)*)

(*mlspolltime[1] = 2000
TIMELINE_CREATE(mlspoll,mlspolltime,1,TIMELINE_RELATIVE,TIMELINE_REPEAT)*)

TIMELINE_CREATE(TL_PROJ_QUEUE,lTL1_Array,1,TIMELINE_RELATIVE,TIMELINE_REPEAT)

TIMELINE_CREATE(TL_PROJ_REQUEST,lTL2_Array,1,TIMELINE_RELATIVE,TIMELINE_REPEAT)

QueuePower = TRUE

(***********************************************************)
(*                THE EVENTS GO BELOW                      *)
(***********************************************************)
DEFINE_EVENT

CHANNEL_EVENT[vdvVolumeMod,VSMod_Volume_chn]
{
  ON:
  {
  //  SEND_STRING vdvVolumeMod,'Channel Request Sent'
    //SEND_STRING vdvVolumeMod,"'The last Channel pulsed was:',ITOA(GET_LAST(VSMod_Volume_chn))"
    set_volume_level(GET_LAST(VSMod_Volume_chn)-1)
  }
  OFF:
  {
   //Do nothing
  }
}
CHANNEL_EVENT[vdvVolumeMod,102] //Volume up by 5
{

  
  ON:
  {
    //OFF[vdvVolumeMod,103]
    increment_volume_level()
  }
  
  OFF:
  {
    //Do nothing
  }
}

CHANNEL_EVENT[vdvVolumeMod,103] //Volume down by 5
{
  ON:
  {
    //OFF[vdvVolumeMod,102]
    decrement_volume_level()
    
  }
  
  OFF:
  {
    //Do nothing
  }
}

CHANNEL_EVENT[vdvVolumeMod,AMute_ON_chn] // Mute on
{
  ON: 
  {
		boolean_inputs(1,1)
  }
  
  OFF:
  {
  // Do nothing
  }
}
CHANNEL_EVENT[vdvVolumeMod,AMute_OFF_chn] //Mute off
{

  ON:
  {
    boolean_inputs(1, 0)
  }
  
  OFF:
  {
   //Do nothing.
  }
}

(***************************** GAIN CHANNELS *****************)

CHANNEL_EVENT[vdvGainMod,VSMod_Gain_chn]
{
  ON:
  {
    set_audio_eq_level(mls506ma.audioSource,1,GET_LAST(VSMod_Gain_chn)-1)
    On[vdvGainMod,VSMod_Gain_fb[GET_LAST(VSMod_Gain_chn)+100]]
  }
  
  OFF:
  {
  //Do nothing
  }
}

CHANNEL_EVENT[vdvGainMod,203]
{
  ON:
  {
    increment_eq_level(mls506ma.audioSource,1)
  }
  OFF:
  {
   // Do nothing
  }
}

CHANNEL_EVENT[vdvGainMod,204]
{
  ON:
  {
    decrement_eq_level(mls506ma.audioSource,1)
  }
  OFF:
  {
    //Do nothing.
  }
}

(***********TREBLE MOD CHANNELS*************)

CHANNEL_EVENT[vdvTrebleMod,VSMod_Treble_chn]
{
  ON:
  {
    set_audio_eq_level(mls506ma.audioSource,2,GET_LAST(VSMod_Treble_chn))
    ON[vdvTrebleMod,GET_LAST(VSMod_Treble_chn)+100]
  }
  OFF:
  {
    //Do nothing
  }
}

CHANNEL_EVENT[vdvTrebleMod,203]
{
  ON:
  {
    increment_eq_level(mls506ma.audioSource,2)
  }
  OFF:
  {
    //Do nothing 
  }
}

CHANNEL_EVENT[vdvTrebleMod,204]
{
  ON:
  {
    decrement_eq_level(mls506ma.audioSource,2)
  }
}

(*********** BASS MOD CHANNELS********)
CHANNEL_EVENT[vdvBassMod,VSMod_Bass_chn]
{  
  ON:
  {
    set_audio_eq_level(mls506ma.audioSource,3,GET_LAST(VSMod_Bass_chn))
  }
  
  OFF:
  {
     // Do nothing
  }
}

CHANNEL_EVENT[vdvBassMod,203] //Bass up
{
  ON:
  {
    increment_eq_level(mls506ma.audioSource,3)
  }
  OFF:
  {
    // Do nothing
  }
}

CHANNEL_EVENT[vdvBassMod,204] //Base down
{
  ON:
  {
     decrement_eq_level(mls506ma.audioSource,3) 
  }
  OFF:
  {
    // Do nothing
  }
}

(*********** VIDEO SWITCHING ***********)
CHANNEL_EVENT[vdvVSMod,VSMod_aud_vid_input]
{
  ON:
  {
    video_switch(0,GET_LAST(VSMod_aud_vid_input))
  }
  OFF:
  {
   // Do nothing
  }

}

CHANNEL_EVENT[vdvVSMod,VSMod_aud_only_input]
{
  ON:
  {
    (*video_switch(1,GET_LAST(VSMod_aud_only_input)-20)*)
    video_switch(1,GET_LAST(VSMod_aud_only_input))
  }
  OFF:
  {
    //Do nothing
  }
}

CHANNEL_EVENT[vdvVSMod,VSMod_vid_only_input]
{
  ON:
  {
    (*video_switch(2,GET_LAST(VSMod_vid_only_input)-10)*)
    video_switch(2,GET_LAST(VSMod_vid_only_input))
  }
  OFF:
  {
    //Do nothing
  }
}

CHANNEL_EVENT[vdvVSMod,VSMOD_vid_signal_type]
{
  ON:
  {
    set_video_configuration(mls506ma.audioSource,GET_LAST(VSMOD_vid_signal_type))
  }
  OFF:
  {
    // Do nothing
  }
}







DATA_EVENT[dvreal]
{
  ONLINE:
  {
    SEND_COMMAND dvreal,'SET BAUD 9600,N,8,1 485 DISABLE' //moved to here from def_start
    (*information_request()		//moved to here from def_start.ensures serial port is ready to go*)
		putqueue('I','r');
		putqueue('V','r');
  }
  
  STRING:
  {
    STACK_VAR INTEGER stringlength
    STACK_VAR INTEGER crloc
    STACK_VAR INTEGER switcharray[3]
    STACK_VAR CHAR tempstr[20]
	
    ON[vdvVSMod,255]
    ON[vdvGainMod,255]
    ON[vdvBassMod,255]
    ON[vdvTrebleMod,255]
    ON[vdvVolumeMod,255]
		
    stringlength = LENGTH_STRING(mlsBuff)
     
    //The following product will use the CR/LF('$0D$0A') at the end of every response as a way of parsing the output.
    //Since every response is terminated with a CR/LF, we search for a $0D$0A string. We then take the number of characters from the beginning of $0D$0A and handle them accordingly.
    crloc = FIND_STRING(mlsBuff,"$0D,$0A",1)
    tempstr = LEFT_STRING(mlsBuff,(crloc + 6))
		
		WHILE(LENGTH_ARRAY(mlsBuff) <> 0)
		{
			IF( FIND_STRING(tempstr,' ',1) <> 0 )
			{
			//INFORMATION RESPONSE or AUDIO RESPONSE
				FOR(count = 1; count <= LENGTH_ARRAY(mlsMultipleResCodes);count++)
				{
					IF( FIND_STRING(tempstr,mlsMultipleResCodes[count],1) )
					{
						debug1.debugChar = LEFT_STRING(tempstr,2)
						SWITCH( LEFT_STRING(tempstr,2) )
						{
							CASE 'Vi':
							{
								mls506ma.videoSource = ATOI( MID_STRING(tempstr,4,1) )
								mls506ma.audioSource = ATOI( MID_STRING(tempstr,9,1) )
								
								IF ( ![vdvVSMod,VSMod_video_fb_chn[mls506ma.videoSource]] )
								{//turn off all and turn on active if level has changed
									OFF[vdvVSMod,VSMod_video_fb_chn]
									ON [vdvVSMod,VSMod_video_fb_chn[mls506ma.videoSource] ]
								}

								IF ( ![vdvVSMod,VSMod_audio_fb_chn[mls506ma.audioSource]] )
								{//turn off all and turn on active if level has changed
									OFF[vdvVSMod,VSMod_audio_fb_chn]
									ON [vdvVSMod,VSMod_audio_fb_chn[mls506ma.audioSource] ]
								}									
								
								mls506ma.audioClip = ATOI( MID_STRING(tempstr,14,1) )
							}
							CASE 'In':
							{
								deBug1.debugChar = MID_STRING(tempstr,3,1)
								mls506ma.audioLevelSource = ATOI( MID_STRING(tempstr,3,1) )
								IF( MID_STRING(tempstr,5,3) == 'Trb' )
								{
									mls506ma.trebleLevel = ATOI( MID_STRING(tempstr,9,3) )
								}
								ELSE IF( MID_STRING(tempstr,5,3) == 'Bas' )
								{
									mls506ma.bassLevel = ATOI( MID_STRING(tempstr,9,3) )
								}
								ELSE 
								{
									mls506ma.gainLevel = ATOI( MID_STRING(tempstr,9,3) )
								}
							}
							DEFAULT:
							{
								//Do nothing...the string will be cleared and information will be re-sent at the next polling response.
							}
						}//End Switch Statement
					}//End If Statement
				}//End For Loop
			}//End If Statement(parses for spaces)
      ELSE
      {
				//Volume or Video source/Administrative Response
				FOR(count = 1; count <= LENGTH_ARRAY(mlsSingleResCodes);count++)
				{
					IF( FIND_STRING(tempstr, mlsSingleResCodes[count],1) )
					{
						SWITCH( LEFT_STRING(tempstr,3) )
						{
							CASE 'Chn':
							{
								mls506ma.videoSource = ATOI( MID_STRING(tempstr,4,1) )
								IF ( ![vdvVSMod,VSMod_video_fb_chn[mls506ma.videoSource]] )
								{//turn off all and turn on active if level has changed
									OFF[vdvVSMod,VSMod_video_fb_chn]
									ON [vdvVSMod,VSMod_video_fb_chn[mls506ma.videoSource] ]
								}		 
									
								mls506ma.audioSource = ATOI( MID_STRING(tempstr,4,1) )
								IF ( ![vdvVSMod,VSMod_audio_fb_chn[mls506ma.audioSource]] )
								{//turn off all and turn on active if level has changed
									OFF[vdvVSMod,VSMod_audio_fb_chn]
									ON [vdvVSMod,VSMod_audio_fb_chn[mls506ma.audioSource] ]
								}	
							}
							 
							CASE 'Aud':
							{
								mls506ma.audioSource = ATOI( MID_STRING(tempstr,4,1) )
								(*IF ( ![vdvVolumeMod,VSMod_audio_fb_chn[mls506ma.audioSource]] )
								{//turn off all an d turn on active if level has changed
									OFF[vdvVSMod,VSMod_audio_fb_chn]
									ON [vdvVolumeMod,VSMod_audio_fb_chn[mls506ma.audioSource] ]
								}	*)
							}
							
							CASE 'Vid':
							{
								mls506ma.videoSource = ATOI( MID_STRING(tempstr,4,1) )
								(*IF ( ![vdvVolumeMod,VSMod_video_fb_chn[mls506ma.videoSource]] )
								{//turn off all and turn on active if level has changed
									OFF[vdvVSMod,VSMod_video_fb_chn]
									ON [vdvVolumeMod,VSMod_video_fb_chn[mls506ma.videoSource] ]
								}*)
							}
							CASE 'Typ': 
							{
								mls506ma.videotype = ATOI( MID_STRING(tempstr,4,1) )
								//This case suffers from a lack of information in the response about the selected input.
								//Possible fix:  modify an external variable when the source is switched to keep track of which source got switched.
							 }
							CASE 'Amt':
							{
								//Note: Universal mute, no specific audio or video source.
								(* mls506ma.rgbMute = ATOI( MID_STRING(tempstr,4,1) ) *)
								mls506ma.audioMute = ATOI( MID_STRING(tempstr,4,1) )
								[vdvVolumeMod,AMute_fb_chn] = ATOI( MID_STRING(tempstr,4,1) )
							 }
							CASE 'Vol':
							{
								//STACK_VAR INTEGER vol
								vol = ATOI( MID_STRING(tempstr,4,3) )
								mls506ma.volumeLevel = vol
								send_string 0,"'I want to turn on channel ' , ITOA(vol) "
								IF ( ![vdvVolumeMod,VSMod_Volume_chn_fb[vol+1]] )
								{//turn off all and turn on active if level has changed
									OFF[vdvVolumeMod,VSMod_Volume_chn_fb]
									ON [vdvVolumeMod,VSMod_Volume_chn_fb[vol+1] ]
								}
							}
							CASE 'Exe':
							{
								mls506ma.executiveMode = ATOI( MID_STRING(tempstr,4,1) )
							}
							CASE 'Ver':
							{
								mls506ma.Switcher_comm_ver = ATOI( MID_STRING(tempstr,4,4) )
							}
							CASE 'Zap':
							{
								//Do nothing
							}
							CASE 'RGB':
							{
								mls506ma.rgbDelayTime = ATOI( MID_STRING(tempstr,8,2) )
							}
							CASE 'Eff':
							{
								mls506ma.effectIn = ATOI( MID_STRING(tempstr,10,1) )
							}
							CASE 'Pre':
							{
								//Not supported in mls506ma
							}
							CASE 'Bal':
							{
								//Balance not supported in mls506ma, will throw error code.
							}
							CASE 'Spk':
							{
							 // Speaker Load not supported in mls506ma, will throw error code.
							}
						}
					}
				}
			}
      //Clears the tempstr buffer and mlsBuff for the next round.
      REMOVE_STRING(tempstr,"$0D,$0A",1)
      REMOVE_STRING(mlsBuff,"$0D,$0A",1)
      (*CAUSES 100V string to be sent...
      ON[vdvVolumeMod,mls506ma.volumeLevel + 100]
      *)
      //ON[vdvBassMod,(mls506ma.bassLevel + 100) ]
      //ON[vdvGainMod,(mls506ma.gainLevel+100) ]
      //ON[vdvVolumeMod,(mls506ma.audioMute + 201)]
    }//End While Loop

  }	
}
TIMELINE_EVENT[mlsnoresp](**)
{
  (*information_request()*)
}

(*
TIMELINE_EVENT[mlspoll]
{
    STACK_VAR INTEGER qcount
    
    WHILE(LENGTH_ARRAY(command_queue) > 0)
    {
	queue_clear = 0
	SEND_STRING dvreal, "command_queue[1]"
	FOR(qcount = 1;qcount <= LENGTH_ARRAY(command_queue);qcount++)
	{
	  command_queue[(qcount-1)] = command_queue[qcount]
	}
	SET_LENGTH_ARRAY(command_queue,LENGTH_ARRAY(command_queue)-1)
	queue_clear = 1
	
        
    }
    
}
*)

TIMELINE_EVENT[TL_PROJ_QUEUE]
{
	//send_string 0,"'Queue Length = ',ITOA(LENGTH_ARRAY(ProjQueue))"
	//CALL 'CHECK PROJ QUEUE'
	
	IF(LENGTH_ARRAY(_CommandQ))
	{
		popqueue(_CommandQ);
	}
	ELSE
	IF(LENGTH_ARRAY(_RequestQ) && QueuePower)
	{
		send_string 0,'popping request q'
		popqueue(_RequestQ);
	}
	
}

TIMELINE_EVENT[TL_PROJ_REQUEST]
{
		//putqueue('V','R')
    //putqueue('I','R')

	send_string 0,'adding to queue'
//    IF(TIMELINE.REPETITION == 0 OR TIMELINE.REPETITION % 2 == 0)
//    {
//	    putqueue("Proj_setting_commands[2]",'R')
//    }
//    ELSE //IF (marker_checkqueue != 19)
//    {
//	    putqueue("Proj_setting_commands[marker_checkqueue]",'R')
//	    marker_checkqueue++
//	    IF(marker_checkqueue > 19)
//	     marker_checkqueue = 1
//    }
}

(***********************************************************)
(*            THE ACTUAL PROGRAM GOES BELOW                *)
(***********************************************************)
DEFINE_PROGRAM


(***********************************************************)
(*                     END OF PROGRAM                      *)
(*        DO NOT PUT ANY CODE BELOW THIS COMMENT           *)
(***********************************************************)

