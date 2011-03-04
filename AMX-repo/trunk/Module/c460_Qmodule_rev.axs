MODULE_NAME='c460_QModule_rev' (dev dvreal, dev vdvProxy)
(***********************************************************)
(* System Type : NetLinx                                   *)
(***********************************************************)
(* REV HISTORY:                                            *)
(***********************************************************)
(* 04/26/07						   *)
(* Integrated QModule code. Axed alot of old code.	   *)
(* Include c460_queue_include.axi			   *)
(***********************************************************)
(* REV HISTORY:                                            *)
(***********************************************************)
//1/11/06 - added vdv power and mute fb
(***********************************************************)
(*          DEVICE NUMBER DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_DEVICE

#INCLUDE 'c460_queue_include'
(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT

//VOLATILE LONG TL2 = 2
VOLATILE LONG TL3	= 3

VOLATILE INTEGER ON_in = 1
VOLATILE INTEGER OFF_in = 4
VOLATILE INTEGER MUTEON_in = 5
VOLATILE INTEGER MUTEOFF_in = 6
VOLATILE INTEGER MonitorDevice = 50
VOLATILE INTEGER qpc = 105

VOLATILE INTEGER CommActive = 255

VOLATILE INTEGER ACTION_group[]=
{
	ON_in,
	OFF_in,
	MUTEON_in,
	MUTEOFF_in
}

read_response = 1
write_response = 2
error_response = 3

VOLATILE INTEGER RGB1_in = 7
VOLATILE INTEGER RGB2_in = 8
VOLATILE INTEGER VID_in = 9
VOLATILE INTEGER SVID_in = 10
VOLATILE INTEGER DIG_in = 11
VOLATILE INTEGER VIEWER_in = 12
VOLATILE INTEGER COMP_in = 13
VOLATILE INTEGER LAN_in = 14

VOLATILE INTEGER projector_input_channels[]=
{
    RGB2_in,
    VID_in,
    SVID_in,
    COMP_in
}

VOLATILE CHAR proj_action_command_group[4][4]=
{
    'PWR1', //Power On
    'PWR0', //Power Off
    'BLK1', //Video Mute(Blank) On
    'BLK0'  //VIDEO Mute Off
}
VOLATILE CHAR proj_input_command_group[4][4] = 
{
    'SRC1', // VGA Input 2(RGB1)
    'SRC4', // VID_in
    'SRC3', // SVID_in
    'SRC5'  // BNC Connector Cables
}

//STATUS & Feedback
VOLATILE INTEGER ON_fb = 101
VOLATILE INTEGER COOLING_fb = 102
VOLATILE INTEGER MUTE_fb = 120

VOLATILE INTEGER projector_status_array[]= 
{
    ON_fb,
    COOLING_fb,
    MUTE_fb
}

VOLATILE CHAR command_table[][3] =
{
	'PWR',		//power
	'BLK',    //pic mute
	'ARZ',		//aspect ration
	'ACE',		//chime
	'LMP',		//lamp hours
	'LML',		//lamp lit
	'LRT',		//lamp reset
	'PSV',		//power save
	'SRC'			//source
}

VOLATILE INTEGER projpwr 	= 1
VOLATILE INTEGER picmute 	= 2
VOLATILE INTEGER aspectrat= 3
VOLATILE INTEGER chime		= 4
VOLATILE INTEGER lamphours= 5
VOLATILE INTEGER lamplit	= 6
VOLATILE INTEGER lampreset= 7
VOLATILE INTEGER pwrsave	= 8
VOLATILE INTEGER source		= 9

/*
VOLATILE CHAR Proj_setting_commands[][3] =
{
	'PWR',
	'BLK',
	'SRC',
	'LMP'
}
*/

(***********************************************************)
(*              DATA TYPE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_TYPE

/*
STRUCTURE queueitem
{
	CHAR sCommand[15]
	LONG cQID
	CHAR cQtype
}
*/
STRUCTURE projresponse
{
	LONG range_low
	LONG range_high
	LONG val
}

STRUCTURE projfeedback
{
	INTEGER fbtype
	CHAR sCommand[10]
	projresponse response
}

STRUCTURE projstatus
{
	INTEGER proj_power
	INTEGER pic_mute
	INTEGER aspect_ratio
	INTEGER chimeon
	LONG lamp_hours
	INTEGER lamp_lit
	INTEGER proj_source
}


(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE

VOLATILE CHAR ProjBuff[50]

VOLATILE INTEGER marker_checkqueue
//VOLATILE INTEGER QueuePower = 0

VOLATILE projfeedback fb1

/*
VOLATILE LONG lTL2_Array[1] =  // TL_PROJ_REQUEST
{
	1500
}
*/
VOLATILE LONG lTL3_Array[1] =	//no response
{
	10000
}

projstatus myprojstatus

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



DEFINE_FUNCTION INTEGER table_index (CHAR valin[], CHAR tablein[][])
{
	STACK_VAR INTEGER mycount
  
	FOR(mycount = 1; mycount <= LENGTH_ARRAY(tablein); mycount ++)
	{
		IF ( valin == tablein[mycount])
		{
			RETURN(mycount)
		}
	}
	RETURN 0
}

DEFINE_FUNCTION LONG parse_write(CHAR stringin[]){
	STACK_VAR INTEGER nVal
	
	nVal = ATOL(stringin)
	
	return(nVal)
}

DEFINE_FUNCTION LONG parse_read(CHAR stringin[]){
	
	REMOVE_STRING(ProjBuff,'?)',1)
	fb1.response.range_low  = ATOL( REMOVE_STRING(ProjBuff,'-',1))
	fb1.response.range_high = ATOL( REMOVE_STRING(ProjBuff,',',1))
	fb1.response.val = ATOL(ProjBuff)
	
	RETURN (fb1.response.val)
}

(***********************************************************)
(*                STARTUP CODE GOES BELOW                  *)
(***********************************************************)
DEFINE_START

CREATE_BUFFER dvreal,ProjBuff
CLEAR_BUFFER ProjBuff

//TIMELINE_CREATE(TL2,lTL2_Array,1,TIMELINE_RELATIVE,TIMELINE_REPEAT)
TIMELINE_CREATE(TL3,lTL3_Array,1,TIMELINE_RELATIVE,TIMELINE_REPEAT)

ON[vdvProxy,MonitorDevice]

(* System Information Strings ******************************)
(* Use this section if there is a TP in the System!        *)
(*
    SEND_COMMAND TP,"'!F',250,'1'"
    SEND_COMMAND TP,"'TEXT250-',__NAME__"
    SEND_COMMAND TP,"'!F',251,'1'"
    SEND_COMMAND TP,"'TEXT251-',__FILE__,', ',S_DATE,', ',S_TIME"
    SEND_COMMAND TP,"'!F',252,'1'"
    SEND_COMMAND TP,"'TEXT252-',__VERSION__"
    SEND_COMMAND TP,"'!F',253,'1'"
    (* Must fill this (Master Ver) *)
    SEND_COMMAND TP,'TEXT253-'
    SEND_COMMAND TP,"'!F',254,'1'"
    (* Must fill this (Panel File) *)
    SEND_COMMAND TP,'TEXT254-'
    SEND_COMMAND TP,"'!F',255,'1'"
    (* Must fill this (Dealer Info) *)
    SEND_COMMAND TP,'TEXT255-'
*)
(***********************************************************)
(*                THE EVENTS GO BELOW                      *)
(***********************************************************)
DEFINE_EVENT

DATA_EVENT[dvreal]
{
	ONLINE:
	{
		SEND_COMMAND dvreal,'SET BAUD 19200,N,8,1 485 DISABLE'
	}
	OFFLINE:
	{
		OFF[vdvProxy,CommActive]
	}
	STRING:
	{
	
	//reset commactive TL
		STACK_VAR INTEGER command_index
		STACK_VAR INTEGER count
		STACK_VAR CHAR thestring[10]
		
		SEND_STRING 0,"'Resp: ',ProjBuff"
		
		
		IF( FIND_STRING(ProjBuff,')?',1) ) //error_response
			fb1.fbtype = error_response
		ELSE IF (FIND_STRING(ProjBuff,'?)',1))
			fb1.fbtype = read_response
		ELSE IF (FIND_STRING(ProjBuff,'(',1) && FIND_STRING(ProjBuff,')',2))
			fb1.fbtype = write_response
		ELSE
			fb1.fbtype = 69


		IF(fb1.fbtype = error_response)
		{
	
	
		}
		ELSE IF(fb1.fbtype = read_response)
		{
			command_index = table_index( MID_STRING(ProjBuff,2,3),command_table)
			
			SWITCH (command_index)
			{
				CASE 0:
				{
					send_string 0,'some error'
				}
				CASE projpwr:
				{
					myprojstatus.proj_power = parse_read(ProjBuff)
					[vdvproxy,ON_fb] = myprojstatus.proj_power
				}
				CASE picmute:
				{
					myprojstatus.pic_mute = parse_read(ProjBuff)
					[vdvproxy,MUTE_fb] = myprojstatus.pic_mute
				}
				CASE aspectrat:
				{
					myprojstatus.aspect_ratio = parse_read(ProjBuff)
				}
				CASE chime:
				{
					myprojstatus.chimeon = parse_read(ProjBuff)
				}
				CASE lamphours:
				{
					myprojstatus.lamp_hours = parse_read(ProjBuff)
				}
				CASE lamplit:
				{
					myprojstatus.lamp_lit = parse_read(ProjBuff)
				}
				CASE lampreset:
				{
				
				}
				CASE pwrsave:
				{
				
				}
				CASE source:
				{
					myprojstatus.proj_source = parse_read(ProjBuff)
				}			
			}
		}
		ELSE IF(fb1.fbtype = write_response)
		{
			command_index = table_index( MID_STRING(ProjBuff,2,3),command_table)
			
			IF(command_index > 0)
			SEND_STRING devicestrings, "'(',command_table[command_index],'?)'" //HEX Change to QModule
			//putqueue("'(',command_table[command_index],'?)'",'C') 

			(*
			SWITCH (command_index)
			{
				CASE 0:
				{
					send_string 0,'some error'
				}
				CASE projpwr:
				{
					putqueue("'(',command_table[projpwr],'?)'",'C')
				}
				CASE picmute:
				{
					putqueue("'(',command_table[picmute],'?)'",'C')
				}
				CASE aspectrat:
				{
				
				}
				CASE chime:
				{
				
				}
				CASE lamphours:
				{
				
				}
				CASE lamplit:
				{
				
				}
				CASE lampreset:
				{
				
				}
				CASE pwrsave:
				{
				
				}
				CASE source:
				{
					putqueue("'(',command_table[source],'?)'",'C')
				}			
			} *)
		}
(*
		SWITCH (fb1.fbtype)
		{
			CASE error_response:
			{
			
			
			}
			CASE read_response:
			{
				command_index = 
				REMOVE_STRING(ProjBuff,'?)',1)
				fb1.response.range_low  = ATOL( REMOVE_STRING(ProjBuff,'-',1))
				fb1.response.range_high = ATOL( REMOVE_STRING(ProjBuff,',',1))
				fb1.response.val = ATOL(ProjBuff)
			}
			CASE write_response:
			{
				
			}
			CASE 69:
			{
			
			
			}
		}
		
		
		
		
		
		
		
		
		
		FOR(count = 1; count <= LENGTH_ARRAY(command_table); count++)
		{
		
			IF( FIND_STRING(ProjBuff,command_table[count],1) )
			{
			
			  fb1.sCommand = REMOVE_STRING(ProjBuff, MID_STRING(ProjBuff,FIND_STRING(ProjBuff,'(',1),FIND_STRING(ProjBuff,')',1)),1)
				//thestring = MID_STRING(ProjBuff,FIND_STRING(ProjBuff,'(',1),FIND_STRING(ProjBuff,')',1) )
				
				IF( FIND_STRING(ProjBuff,'(',1) && FIND_STRING(ProjBuff,')',1)    )
				{
					fb1.response.range_low  = ATOL( REMOVE_STRING(ProjBuff,'-',1))
					fb1.response.range_high = ATOL( REMOVE_STRING(ProjBuff,',',1))
					fb1.response.val = ATOL(ProjBuff)
				
				}
				
				TIMELINE_PAUSE(TL3)
				//SEND_STRING 0,"'Command found at point ', ITOA(table_index(command_table[count],command_table)), '. It is /',command_table[count],'/'";
				//SEND_STRING 0,"'The string found is: ',thestring,'/'";
			}
		
		}
		
		*)
		wait 5 
		clear_buffer ProjBuff
		
		TIMELINE_SET(TL3,0)  
		TIMELINE_RESTART(TL3)
	}
}

CHANNEL_EVENT[vdvProxy,ACTION_group]
{
	ON:
	{
		SEND_STRING devicestrings,"'(',proj_action_command_group[GET_LAST(ACTION_group)],')'" //HEX CHANGEDto QModule
	}
}




CHANNEL_EVENT[vdvProxy,projector_input_channels]
{
	ON:
		{
			SEND_STRING devicestrings,"'(',proj_input_command_group[GET_LAST(projector_input_channels)],')'" //HEX Changed to qModule

		}

}

CHANNEL_EVENT[vdvProxy,MonitorDevice]
{
	ON:
	{
		  ON[vdvproxy,qpc]
	}
	OFF:
	{
		  OFF[vdvproxy,qpc]
	}
	
}



CHANNEL_EVENT[vdvProxy,69]
{
	ON:
	{
		SEND_STRING devicestrings,"'(PWR?)'" //HEX CHANGED to QModule
	}
}
/*
TIMELINE_EVENT[TL2]		//setting request
{
		IF(TIMELINE.REPETITION == 0 OR TIMELINE.REPETITION % 2 == 0)
		{
			//CALL 'ADD TO PROJ QUEUE'("Proj_setting_commands[2]")
			putqueue("'(',Proj_setting_commands[1],'?)'",'R') //Hex Change to QModule
		}
		ELSE //IF (marker_checkqueue != 19)
		{
			//CALL 'ADD TO PROJ QUEUE'("Proj_setting_commands[marker_checkqueue]")
			putqueue("'(',Proj_setting_commands[marker_checkqueue],'?)'",'R') //HEX Change to QModule
			marker_checkqueue++
			IF(marker_checkqueue > LENGTH_ARRAY(Proj_setting_commands))
			 marker_checkqueue = 1
		}
}
*/

TIMELINE_EVENT[TL3]
{

	ON[vdvProxy,CommActive]

}
(***********************************************************)
(*            THE ACTUAL PROGRAM GOES BELOW                *)
(***********************************************************)
DEFINE_PROGRAM

(***********************************************************)
(*                     END OF PROGRAM                      *)
(*        DO NOT PUT ANY CODE BELOW THIS COMMENT           *)
(***********************************************************)

