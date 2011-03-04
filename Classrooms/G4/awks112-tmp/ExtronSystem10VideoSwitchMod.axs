MODULE_NAME='ExtronSystem10VideoSwitchMod' (DEV dvreal, DEV vdvproxy)
(***********************************************************)
(* System Type : NetLinx                                   *)
(***********************************************************)
(* REV HISTORY:                                            *)
(***********************************************************)

(***********************************************************)
(*          DEVICE NUMBER DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_DEVICE

(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT

VOLATILE INTEGER SYS10_channels[] =
{     
    31,32,33,
	41,42,43,
	51,52,53,
	61,62,63,
	71,72,73
}

VOLATILE INTEGER input_channels[] = 
{
  1,  2, 3, 4, 5, 6, 7, 8, 9,10,   //all
  11,12,13,14,15,16,17,18,19,20,   //audio
  21,22,23,24,25,26,27,28,29,30    //video   
}

VOLATILE INTEGER input_feedback_channels[] =
{
	111,
	112,
	113,
	114,
	115,
	116,
	117,
	118,
	119,
	120,
	
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

VOLATILE INTEGER video_feedback_channels[] =
{
	111,
	112,
	113,
	114,
	115,
	116,
	117,
	118,
	119,
	120
}

VOLATILE INTEGER audio_feedback_channels[] =
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

VOLATILE INTEGER status_feedback_channels[] =
{
	131, //RGB Mute
	141, //Audio Mute
	151, //Executive Mode
	161, //Projector Mute
	171, //Projector Power
	181, //Projector Initializing
	191  //Projector Ending

}	

VOLATILE INTEGER video_type_feedback_channels[] =
{
	196,
	197,
	198,
	199
}

VOLATILE CHAR SYS10_response[16][25] = 
{

  'BLK',  					//RGB MUTE                                 
  'AMUT', 					//AUDIO MUTE                               
  'MUT',  					//DISPLAY MUTE                             
  'PR',   					//PROJECTOR POWER                          
  'PW',   					//PROJECTOR WAIT                           
  'UNLOCKED FRONT PANEL',  	//EXEC ON                 
  'LOCKED OUT FRONT PANEL',	//EXEC OFF                
  'RS-232 OPERATION ONLY',  //PROJECTOR CONFIGURATION
  'N',						//Part Number
  'QSC',					//SWITCHER COMM SOFTWARE VERSION                                      
  'QPC',                    //PROJECTOR COMM SOFTWARE VERSION                         
  'E',                      //ERROR NUMBER                         
  'INVALID CHANNEL NUMBER', //ERROR
  'C',						//channel select - audio/video                
  'A',  					//channel select - audio only                
  'V' 					//channel select - video only 
}

VOLATILE CHAR SYS10_commands[][][] = 
{                         //[5][3][1]
  //  OFF    ON   tog
  {  {$62},{$42},{$52} },    //RGB Mute
  {  {$2D},{$2B},{$5A} },    //Audio Mute
  {  {$3B},{$3A},{$58} },    //Executive Mode 
  {  {$29},{$28},{$53} },    //Projector Mute
  {  {$5D},{$5B},{$6F} }    //Projector Power
}

VOLATILE CHAR SYS10_status_request_commands[] =
{
	$69,
	$63,
	$6E,
	$71  
}

VOLATILE INTEGER SYS10_status_request_channels[4] =
{
80,81,82,83
}



//VOLATILE CHAR ReadableCommands[6][4]=
//{
//  'RMUT',
//  'AMUT',
//  'STAT',
//  'EXEC',
//  'PMUT',
//  'PPOW'
//}

//VOLATILE CHAR ReadableOperators[3][3]=
//{
//  'OFF',
//  'ON',
//  'TOG'
//}

VOLATILE INTEGER S10noresp = 1 
VOLATILE INTEGER S10poll   = 2


(***********************************************************)
(*              DATA TYPE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_TYPE

STRUCTURE Extron{
  INTEGER video
  INTEGER audio
  INTEGER videotype
  INTEGER AudioMute
  INTEGER RGBMute
  INTEGER ProjPower
  INTEGER ProjMute
  INTEGER ProjInit
  INTEGER ProjEnd
  INTEGER Exec
  INTEGER error
  INTEGER response
  FLOAT Switcher_comm_ver
  FLOAT Projector_comm_ver
  INTEGER MaxChannel
  CHAR part_number[15]
  CHAR projector_config[20]
}  
(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE

INTEGER count    
VOLATILE CHAR s10Buff[100]
Extron sys10 
VOLATILE LONG S10noresptime[1] 
VOLATILE LONG S10polltime[1] 

VOLATILE char mycommand[50]
integer countx
integer county
integer countz
CHAR part1[4]
CHAR part2[3]
INTEGER ChanType
INTEGER theinput   


DEFINE_LATCHING
DEFINE_MUTUALLY_EXCLUSIVE
DEFINE_FUNCTION selectinput (INTEGER chan, INTEGER type)
{  
  // ! = all, $ = audio, & = video
  STACK_VAR CHAR cmd[3]
  cmd  = '!$&'
 
  SEND_STRING dvreal,"ITOA(chan),cmd[type]"
}

DEFINE_CALL 'change_inputs'(char in1[4], char type)
{
	STACK_VAR INTEGER selectedchan
	selectedchan = ATOI(in1)

	IF ( type == 'C' OR type == 'V' )
	{
	    IF( ![vdvproxy,video_feedback_channels[selectedchan]])
	    {
		OFF[vdvproxy,video_feedback_channels]
		ON[vdvproxy,selectedchan+110]
	    }
	}
	IF ( type == 'C' OR type == 'A' )
	{
	    IF( ![vdvproxy,audio_feedback_channels[selectedchan]])
	    {
		OFF[vdvproxy,audio_feedback_channels]
		ON[vdvproxy,selectedchan+120]
	    }
	}
}


(***********************************************************)
(*                STARTUP CODE GOES BELOW                  *)
(***********************************************************)
DEFINE_START

CREATE_BUFFER dvreal,s10Buff
CLEAR_BUFFER s10Buff

S10noresptime[1] = 30000
TIMELINE_CREATE(S10noresp,S10noresptime,1,TIMELINE_RELATIVE,TIMELINE_REPEAT)

S10polltime[1] = 10000
TIMELINE_CREATE(S10poll,S10polltime,1,TIMELINE_RELATIVE,TIMELINE_REPEAT)
(***********************************************************)
(*                THE EVENTS GO BELOW                      *)
(***********************************************************)
DEFINE_EVENT

DATA_EVENT[dvreal]
{
  ONLINE:
  {
    SEND_COMMAND dvreal,'SET BAUD 9600,N,8,1 485 DISABLE'
  }
  STRING:
  {
    STACK_VAR INTEGER stringlength
    STACK_VAR INTEGER whitespaceloc
    STACK_VAR INTEGER switcharray[7]
    STACK_VAR CHAR tempstr[10]
    stringlength = LENGTH_STRING(s10Buff)   
    
		ON[vdvproxy,255]
    
    IF( (LEFT_STRING(s10Buff,2)=="$0D,$0A") && (RIGHT_STRING(s10Buff,2)=="$0D,$0A") ) //ALL responses begin and end with CR/LF
    {  //-------------------------STRING FOUND----------------------------------------------//     
			
			REMOVE_STRING(s10Buff,"$0D,$0A",1) //remove CR/LF
			IF( LENGTH_STRING(s10Buff) > 40 )  // 
      {  //......................INFORMATION RESPONSE ..................................//
        FOR(count = 1; count < 8 ; count++)
        {
					whitespaceloc = FIND_STRING(s10Buff,' ',1)
					tempstr = MID_STRING(s10Buff,1,whitespaceloc)
					switcharray[count] = ATOI(tempstr)
					REMOVE_STRING(s10Buff,tempstr,1)
				}     
				//transfer switcharrayelement to struct values          
				sys10.video = switcharray[1]    
				sys10.audio = switcharray[2]    
				sys10.videotype = switcharray[3]
				sys10.ProjPower = switcharray[4]
				sys10.ProjMute = switcharray[5] 
				sys10.AudioMute = switcharray[6]
				sys10.RGBMute = switcharray[7]
				
				IF( ![vdvproxy,video_feedback_channels[sys10.video]])
				{
					OFF[vdvproxy,video_feedback_channels]
					ON[vdvproxy,sys10.video+110]
				}
				
				IF( ![vdvproxy,audio_feedback_channels[sys10.audio]])
				{
					OFF[vdvproxy,audio_feedback_channels]
					ON[vdvproxy,sys10.audio+120]
				}
				
				IF ( ![vdvproxy,video_type_feedback_channels[sys10.videotype]] )
				{
					OFF[vdvproxy,video_type_feedback_channels]
					ON[vdvproxy,video_type_feedback_channels[sys10.videotype]]
				}
				
				IF (sys10.RGBMute)
					ON[vdvproxy,131]
				ELSE
					OFF[vdvproxy,131]
				
				IF (sys10.AudioMute)
					ON[vdvproxy,141]
				ELSE
					OFF[vdvproxy,141]
				
				IF (sys10.ProjPower)
					ON[vdvproxy,171]
				ELSE
					OFF[vdvproxy,171]
				
				IF (sys10.ProjMute)
					ON[vdvproxy,161]
				ELSE
					OFF[vdvproxy,161]
				
				whitespaceloc = FIND_STRING(s10Buff,' ',1)
				tempstr = MID_STRING(s10Buff,1,whitespaceloc)
				sys10.Switcher_comm_ver = ATOF(tempstr)
				REMOVE_STRING(s10Buff,tempstr,1)
				
				whitespaceloc = FIND_STRING(s10Buff,' ',1)
				tempstr = MID_STRING(s10Buff,1,whitespaceloc)
				sys10.Projector_comm_ver = ATOF(tempstr)
				REMOVE_STRING(s10Buff,tempstr,1)
				
				sys10.MaxChannel = ATOI(s10Buff)
				
				ON[sys10.response]
				TIMELINE_SET(S10noresp,0)  
				TIMELINE_RESTART(S10noresp)
			}
			ELSE
			{  //.....................NOT INFORMATION RESPONSE .............................//
				STACK_VAR INTEGER count
				FOR(count=1; count <= MAX_LENGTH_ARRAY(SYS10_response) ; count++)
				{
					IF ( FIND_STRING(s10Buff,"SYS10_response[count]",1) )
					{  //$$$$$$$$$$$$$$$ IF RECOGNIZED RESPONSE$$$$$$$$$$$$$$$$$$$$$$$$$$$$$//
						SWITCH (SYS10_response[count])
						{ //*****************ALTER EXTRON KEY VALUES*********************//        
							CASE 'BLK':
							{
								STACK_VAR INTEGER num
								num = ATOI(s10Buff)						
								sys10.RGBMute = num
								IF (num == 0)
									OFF[vdvproxy,131]
								ELSE
									ON[vdvproxy,131]						}
							CASE 'AMUT': //AMUT
							{
								STACK_VAR INTEGER num
								num = ATOI(s10Buff)
								sys10.AudioMute = num
								IF (num == 0)
									OFF[vdvproxy,141]
								ELSE
									ON[vdvproxy,141]
							}
							CASE 'MUT': //MUTE
							{
								STACK_VAR INTEGER num
								num = ATOI(s10Buff)						
								sys10.ProjMute = num
								IF (num == 0)
									OFF[vdvproxy,161]
								ELSE
									ON[vdvproxy,161]							
							}
							CASE 'PR': //PR
							{
								SWITCH( ATOI(s10Buff) )
								{
									CASE 0:
									{
										sys10.ProjPower = 0
										sys10.ProjInit = 0
										sys10.ProjEnd = 0
									}
									CASE 1:
									{ 
										sys10.ProjPower = 1
										sys10.ProjInit = 0
										sys10.ProjEnd = 0
									}
								}
							}
							CASE 'PW': //PW
							{    
								SWITCH( MID_STRING(s10Buff,4,1) )
								{
									CASE '1':
									{
										sys10.ProjPower = 0
										sys10.ProjInit = 1
										sys10.ProjEnd = 0
									}
									CASE 'E':
									{
										sys10.ProjPower = 0
										sys10.ProjInit = 0
										sys10.ProjEnd = 1
									}                     
								}    
							}
							CASE 'UNLOCKED FRONT PANEL': //UNLOCKED FRONT PANEL
							{
								sys10.Exec = 1
								ON[vdvproxy,151]
								
							}
							CASE 'LOCKED OUT FRONT PANEL': //LOCKED OUT FRONT PANEL
							{
								sys10.Exec = 0
								OFF[vdvproxy,151]
							}
							CASE 'RS-232 OPERATION ONLY':
							{
								sys10.projector_config = s10Buff
							}
							CASE 'N':
							{
								sys10.part_number = s10Buff
							}
							CASE 'E':  //ERROR
							{
								sys10.error = 1
							}
							CASE 'C':
							{
								CALL 'change_inputs'(s10Buff,'C')
							}
							CASE 'A':
							{
								CALL 'change_inputs'(s10Buff,'A')
							}
							CASE 'V':
							{
								CALL 'change_inputs'(s10Buff,'V')
							}	
						} //*****************************************************************//
						BREAK
					}  //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$//
				}
      } //..............................................................//     
      CLEAR_BUFFER s10Buff
    }
  }//STRING
}//EVENT

CHANNEL_EVENT[vdvproxy,input_channels]
{
  ON:
  {
   //STACK_VAR INTEGER ChanType
   //STACK_VAR INTEGER theinput   
   ChanType = ((GET_LAST(input_channels)-1)/10)+1  //1 = all, 2 = aud, 3 = vid
   theinput =  GET_LAST(input_channels) - ((ChanType-1)*10) 
       
   selectinput( theinput, ChanType )
  }
}

CHANNEL_EVENT[vdvproxy,SYS10_channels]
{
	ON:
	{
		SEND_STRING dvreal,"SYS10_commands[(channel.channel/10)-2][channel.channel%10][1]"
//		SEND_STRING dvreal, "'shit'"
	}
}

TIMELINE_EVENT[S10noresp]
{
  OFF[sys10.response]
  OFF[vdvproxy,255]
}

TIMELINE_EVENT[S10poll]
{
  SEND_STRING dvreal,"$69"
}
(***********************************************************)

DEFINE_PROGRAM
