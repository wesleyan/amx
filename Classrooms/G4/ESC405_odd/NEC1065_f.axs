MODULE_NAME='NEC1065_f' (DEV dvreal , DEV vdvProxy )

//MODULE_NAME='MTSeriesFinalTEST' (DEV dvreal, DEV vdvProxy)
(***********************************************************)
(*  FILE CREATED ON: 05/18/2004 AT: 14:09:13               *)
(***********************************************************)
(* System Type : Netlinx                                   *)
(***********************************************************)
(* REV HISTORY:                                            *)
(***********************************************************)

DEFINE_DEVICE


DEFINE_CONSTANT

(********** COMMAND CHANNELS ***********)

VOLATILE INTEGER ON_in = 1
VOLATILE INTEGER OFF_in = 4
VOLATILE INTEGER MUTEON_in = 5
VOLATILE INTEGER MUTEOFF_in = 6

VOLATILE INTEGER MonitorDevice = 50

VOLATILE INTEGER ACTION_group[]=
{
	ON_in,
	OFF_in,
	MUTEON_in,
	MUTEOFF_in
}

VOLATILE INTEGER ACTION_hex_cmds[][]=
{
  {$02,$00,$00,$00,$00,$02},              //on
  {$02,$01,$00,$00,$00,$03},              //off
  {$02,$10,$00,$00,$00,$12},              //mute on
  {$02,$11,$00,$00,$00,$13}              //mute off 
}



//INPUT SOURCES
VOLATILE INTEGER RGB1_in = 7
VOLATILE INTEGER RGB2_in = 8
VOLATILE INTEGER VID_in = 9
VOLATILE INTEGER SVID_in = 10
VOLATILE INTEGER DIG_in = 11
VOLATILE INTEGER VIEWER_in = 12
VOLATILE INTEGER COMP_in = 13
VOLATILE INTEGER LAN_in = 14


VOLATILE INTEGER source_type_cmdchan[] = //formerly input_type_input_channels[] =
{
	RGB1_in,  //RGB1	
	RGB2_in,	//RGB2
	VID_in,	//VIDEO
	SVID_in,	//SVIDEO
	DIG_in,	//DIGITAL
	VIEWER_in,	//VIEWER
	COMP_in,
	LAN_in  //LAN
}


VOLATILE CHAR Proj_setting_commands[][] = 
{
  {$00,$81,$00,$00,$00,$81},              //1 running sense								006
  {$00,$C0,$00,$00,$00,$C0},              //2 commom data request					007
  {$00,$88,$00,$00,$00,$88},              //3 ERROR STATUS REQUEST				009
	{$03,$8A,$00,$00,$00,$8D}, 							//4 INFORMATION REQUEST 				037
  {$03,$8C,$00,$00,$00,$8F},              //5 LAMP INFORMATION REQUEST 		037-1
	{$03,$94,$00,$00,$00,$97},              //6 AMP INFORMATION REQUEST 2	037-2
	{$03,$95,$00,$00,$00,$98}, 							//7 FILTER INFORMATION REQUEST	037-3
	{$03,$B0,$00,$00,$01,$07,$BB},         	//8 lamp mode request
	{$03,$8D,$00,$00,$00,$90},              //9 lamp cooling time request
	{$03,$B0,$00,$00,$01,$08,$BC},          //10 idle mode request
	{$03,$B0,$00,$00,$01,$09,$BD},          //11 closed caption request  
	{$03,$96,$00,$00,$02,$00,$01,$9C},	//lampinfo3 - 1
	{$03,$96,$00,$00,$02,$00,$04,$9F},	//lampinfo3 - 2
	{$03,$96,$00,$00,$02,$00,$08,$A3},	//lampinfo3 - 3
	{$03,$96,$00,$00,$02,$00,$09,$A4},	//lampinfo3 - 4
	{$03,$96,$00,$00,$02,$00,$0A,$A5},	//lampinfo3 - 5
	{$03,$96,$00,$00,$02,$00,$10,$AB},	//lampinfo3 - 6
	{$03,$96,$00,$00,$02,$00,$11,$AC},	//lampinfo3 - 7
	{$03,$96,$00,$00,$02,$00,$12,$AD}		//lampinfo3 - 8
}


VOLATILE INTEGER closed_caption_cmdchan[] =
{
	//30 - maybe should be off?
	31, //cc1
	32, // |
	33, // |
	34, //cc4
	35, //txt1
	36, // |
	37, // |
	38, //txt4
	39	//off
}
(******* END OF COMMAND CHANNELS ********)



(********** FEEDBACK CHANNELS ***********)

//STATUS
VOLATILE INTEGER ON_fb = 101
VOLATILE INTEGER COOLING_fb = 102
VOLATILE INTEGER MUTE_fb = 120

//INPUT SOURCES
VOLATILE INTEGER RGB1_fb = 107
VOLATILE INTEGER RGB2_fb = 108
VOLATILE INTEGER VID_fb = 109
VOLATILE INTEGER SVID_fb = 110
VOLATILE INTEGER DIG_fb = 111
VOLATILE INTEGER VIEWER_fb = 112
VOLATILE INTEGER COMP_fb = 113
VOLATILE INTEGER LAN_fb = 114

VOLATILE INTEGER source_type_fbchan[] = //formerly input_type_feedback_channels[] = 
{
	RGB1_fb,
	RGB2_fb,
	VID_fb,
	SVID_fb,
	DIG_fb,
	VIEWER_fb,
	COMP_fb,
	LAN_fb
}

VOLATILE INTEGER ERR_COVER_OPEN = 201
VOLATILE INTEGER ERR_TEMP_FAULT = 202
VOLATILE INTEGER ERR_FAN_STOP = 203
VOLATILE INTEGER ERR_PWR_SUPPLY = 204
VOLATILE INTEGER ERR_LAMP_FAIL = 205
VOLATILE INTEGER COMM_ACTIVE = 255

VOLATILE INTEGER ERR_group[]=
{
	ERR_COVER_OPEN,
	ERR_TEMP_FAULT,
	ERR_FAN_STOP,
	ERR_PWR_SUPPLY,
	ERR_LAMP_FAIL,
	COMM_ACTIVE
}


VOLATILE INTEGER closed_caption_detail_fbchan[] = 
{
	191,
	192,
	193,
	194,
	195,
	196,
	197,
	198
}

(******** END OF FEEDBACK CHANNELS *********)



(********** TIMELINE ID's ***********)
VOLATILE INTEGER TL_PROJ_QUEUE = 1
VOLATILE INTEGER TL_PROJ_REQUEST = 2
VOLATILE LONG	TL_NO_RESP = 3
VOLATILE LONG TL_XML = 4

(******* END OF TIMELINE ID's *******)



VOLATILE INTEGER PROJBUFF_LENGTH = 1000
VOLATILE INTEGER HEAD = 5 		//frame header length
VOLATILE INTEGER ProjQueueMAX = 10





(********* COMMAND STRINGS *********)
VOLATILE CHAR Proj_commands[][] =
{
  {$02,$00,$00,$00,$00,$02},              //on
  {$02,$01,$00,$00,$00,$03},              //off
  {$02,$10,$00,$00,$00,$12},              //mute on
  {$02,$11,$00,$00,$00,$13},              //mute off 
	{$02,$12,$00,$00,$00,$14},							//SOUND MUTE ON
	{$02,$13,$00,$00,$00,$15},							//SOUND MUTE OFF
	{$02,$14,$00,$00,$00,$16},							//ONSCREEN MUTE ON
	{$02,$15,$00,$00,$00,$17},							//ONSCREEN MUTE OFF
	{$03,$B1,$00,$00,$02,$0C,$00,$C2},							//SET 4:3
	{$03,$B1,$00,$00,$02,$0C,$01,$C3}							//SET 16:9
}
(******* END COMMAND STRINGS ********)


(*nack responses *)
VOLATILE INTEGER nack_errors_hex[22][2] =
{
   { $00, $00 },     
   { $00, $01 },     
   { $01, $00 },     
   { $01, $01 },     
   { $01, $02 },     
   { $01, $03 },     
   { $02, $00 },     
   { $02, $02 },     
   { $02, $03 },     
   { $02, $04 },     
   { $02, $06 },     
   { $02, $07 },     
   { $02, $08 },     
   { $02, $09 },     
   { $02, $0A },     
   { $02, $0C },     
   { $02, $0D },     
   { $02, $0E },     
   { $02, $0F },     
   { $03, $00 },     
   { $03, $01 },     
   { $03, $02 }     
}
VOLATILE CHAR nack_errors_readable[22][56] =
{
  'Unknown command',                      
  'The current model does not support this function',
  'Unvalid values specified',            
  'Specified terminal is unavailable or cannot be selected', 
  'Selected language is not available',  
  'specified terminal is not installed',  
  'Available memory reservation error',   
  'Operating memory',                     
  'Setting not possible',                 
  'On Forced on-screen mute mode',
  'Displaying a signal other than PC Viewer',
  '-No signal-',                          
  'Displaying a test pattern or PC Card Files screen',
  'No PC card is inserted',               
  'Memory operation failed',              
  'Displaying the Entry List',            
  'Power Off inhibited',                  
  'Execution error',                      
  'No operation authority',               
  'Specified gain number is wrong',       
  'Selected gain is not available',      
  'Adjustment failed'                    
}

(* ack responses *)
VOLATILE CHAR ack_Responses_Hex[19] =    //ID2's
{
$81,    //'RUNNING SENSE'             
$C0,    //'DATA REQUEST'              
$88,    //'ERROR REQUEST'             
$00,    //'POWER ON'                  
$01,    //'POWER OFF'                 
$03,    //'INPUT CHANGE'              
$10,    //'PICTURE MUTE ON'           
$11,    //'PICTURE MUTE OFF'          
$14,    //'ONSCREEN MUTE ON'          
$15,    //'ONSCREEN MUTE OFF'         
$8A,    //'INFORMATION REQUEST'       
$8C,    //'LAMP INFORMATION REQUEST'  
$94,    //'LAMP INFORMATION REQUEST 2'
$95,    //'FILTER INFORMATION REQUEST'
$96,    //'LAMP INFORMATION REQUEST 3'
$8D,    //'LAMP COOLING TIME REQUEST' 
$B0,    //'B0REQUEST'                 
$32,    //'FACTORY DEFAULT SET'       
$92     //'SLEEP TIMER REQUEST'      
}

(* NEW SHIT!!! *)
VOLATILE CHAR ID2_table[19] =    //ID2's
{
$81,    //'RUNNING SENSE'             
$C0,    //'DATA REQUEST'              
$88,    //'ERROR REQUEST'             
$00,    //'POWER ON'                  
$01,    //'POWER OFF'                 
$03,    //'INPUT CHANGE'              
$10,    //'PICTURE MUTE ON'           
$11,    //'PICTURE MUTE OFF'          
$14,    //'ONSCREEN MUTE ON'          
$15,    //'ONSCREEN MUTE OFF'         
$8A,    //'INFORMATION REQUEST'       
$8C,    //'LAMP INFORMATION REQUEST'  
$94,    //'LAMP INFORMATION REQUEST 2'
$95,    //'FILTER INFORMATION REQUEST'
$96,    //'LAMP INFORMATION REQUEST 3'
$8D,    //'LAMP COOLING TIME REQUEST' 
$B0,    //'B0REQUEST'                 
$32,    //'FACTORY DEFAULT SET'       
$92     //'SLEEP TIMER REQUEST'      
}

//NEW SHIT!!! - ID2_table command array indexes
VOLATILE INTEGER RUNNING_SENSE				= 1
VOLATILE INTEGER COMMON_DATA_REQUEST	= 2
VOLATILE INTEGER ERROR_STATUS_REQUEST	= 3
VOLATILE INTEGER POWER_ON							= 4
VOLATILE INTEGER POWER_OFF						= 5
VOLATILE INTEGER INPUT_CHANGE					= 6
VOLATILE INTEGER PICTURE_MUTE_ON			= 7
VOLATILE INTEGER PICTURE_MUTE_OFF			= 8
VOLATILE INTEGER ONSCREEN_MUTE_ON            = 9
VOLATILE INTEGER ONSCREEN_MUTE_OFF           = 10
VOLATILE INTEGER INFORMATION_REQUEST         = 11
VOLATILE INTEGER LAMP_INFORMATION_REQUEST    = 12
VOLATILE INTEGER LAMP_INFORMATION_REQUEST_2  = 13
VOLATILE INTEGER FILTER_INFORMATION_REQUEST  = 14
VOLATILE INTEGER LAMP_INFORMATION_REQUEST_3  = 15
VOLATILE INTEGER LAMP_COOLING_TIME_REQUEST   = 16
VOLATILE INTEGER B0_REQUEST                   = 17
VOLATILE INTEGER FACTORY_DEFAULT_SET         = 18
VOLATILE INTEGER SLEEP_TIMER_REQUEST         = 19


VOLATILE CHAR ack_Responses_Readable[19][30] = 
{
'RUNNING SENSE',             
'DATA REQUEST',              
'ERROR REQUEST',             
'POWER ON',                  
'POWER OFF',                 

'INPUT SW CHANGE',              
'PICTURE MUTE ON',           
'PICTURE MUTE OFF',          
'ONSCREEN MUTE ON',          
'ONSCREEN MUTE OFF',         

'INFORMATION REQUEST',       
'LAMP INFORMATION REQUEST',  
'LAMP INFORMATION REQUEST 2',
'FILTER INFORMATION REQUEST',
'LAMP INFORMATION REQUEST 3',
'LAMP COOLING TIME REQUEST', 

'B0REQUEST',                 
'FACTORY DEFAULT SET',       
'SLEEP TIMER REQUEST'      
}
DEFINE_TYPE


STRUCTURE projector_stats
{
  LONG lamp_seconds_used
  LONG filter_seconds_used
	LONG panel_seconds_used
  LONG projector_seconds_used
  INTEGER lamp_pct_remaining
  LONG seconds_til_warn_norm
  LONG seconds_til_warn_eco
  LONG seconds_til_inhib_norm
  LONG seconds_til_inhib_eco
	INTEGER pct_til_lamp_warn
	LONG lamp_seconds_used_info3
	LONG timer_seconds_remaining
}

STRUCTURE projector_settings
{
    CHAR projector_name[50]
    LONG lamp_cool_seconds
    LONG lamp_warn_start_seconds
    LONG lamp_prohib_start_seconds
    LONG filter_warn_seconds
}

STRUCTURE frame
{
  CHAR ID1[2]
  CHAR ID2[2]
  CHAR ProjID[2]
  CHAR Model[2]
  CHAR DataLength[10]
  LONG DataPortionSize
  char frametype[10]
  char frameresult[10]
  char fname[30]
}

STRUCTURE runningsense
{
  INTEGER proj_status
  INTEGER ex_control
  INTEGER cooling_processing
  INTEGER selecting_signal
  INTEGER power_processing
}

STRUCTURE datarequest
{
  INTEGER proj_status
  INTEGER cooling_processing
  INTEGER active_input
  INTEGER picture_mute
  INTEGER sound_mute 
  INTEGER forced_onscreen_mute 
  INTEGER onscreen_display  
  INTEGER selecting_signal  
  INTEGER operation_status    
  INTEGER onscreen_mute
  INTEGER indicate_contents 
}

STRUCTURE errorrequest
{
  INTEGER lamp_cover_err
  INTEGER temp_err_bimetal
  INTEGER fan_err
  INTEGER power_err
  INTEGER lamp1_err
  INTEGER lamp1_eol
  INTEGER lamp1_limit
  INTEGER dmd_err
  INTEGER lamp2_err
  INTEGER fpga_err
  INTEGER temp_err_sensor                
  INTEGER lamp1_housing_err
  INTEGER lamp1_data_err
  INTEGER mirror_err
  INTEGER lamp2_eol
  INTEGER lamp2_limit
  INTEGER lamp2_housing_err
  INTEGER lamp2_data_err
  INTEGER temp_err_dust
  INTEGER foreign_object_err
} 

STRUCTURE informationrequest
{
  LONG lamp_hr_norm 
  LONG filter_usage
  LONG panel_usage
  LONG projector_usage
  CHAR projname[50]
}

STRUCTURE lampinformationrequest
{
  LONG lamp_hr_norm
  LONG warning_start_time_norm
  LONG prohibit_use_time_norm
}

STRUCTURE lampinformationrequest2
{
  INTEGER lamp_percent_remaining
}

STRUCTURE filterinformationrequest
{
  LONG filter_usage
  LONG warning_start_time
}

STRUCTURE lampinformationrequest3
{
  LONG lamp1_usage
  LONG lamp1_percent_remaining
  LONG lamp1_warning_start_spec_remaining
  LONG lamp1_warning_start_norm_remaining
  LONG lamp1_warning_start_eco_remaining
  LONG lamp1_inhibit_spec_remaining
  LONG lamp1_inhibit_norm_remaining
  LONG lamp1_inhibit_eco_remaining
}

STRUCTURE  otherstats
{
  LONG lampcoolingtime
  INTEGER message
  INTEGER eco
  INTEGER idlemode
  INTEGER closedcaption                  //cc//00H : OFF, 01H : Caption 1, 02H : Caption 2,  03H : Caption 3 , 04H : Caption 4
  LONG sleeptimer
}

STRUCTURE error
{
  INTEGER etype
  INTEGER edesc
	INTEGER id1
	INTEGER command_hex
	CHAR command_text[30]
  CHAR message[56]
}

STRUCTURE queueitem
{
	CHAR cID2
	CHAR sCommand[15]
	LONG cQID
	CHAR cQtype
}

DEFINE_VARIABLE

(********** PROJECTOR COMMAND QUEUE VARIABLES ***********)

//CHAR ProjQueue[ProjQueueMAX][20]
//INTEGER ProjQueueHead
//INTEGER ProjQueueTail
//INTEGER ProjQueueIsReady
//INTEGER ProjQueueHasItems

INTEGER QueuePower
//INTEGER CheckQueuePower

VOLATILE LONG cmd_cycle_time = 500
VOLATILE INTEGER cmd_req_ratio = 3


//INTEGER marker_lampinfo3
INTEGER marker_checkqueue


VOLATILE CHAR ID1
VOLATILE CHAR ID2_cmd
VOLATILE CHAR ID2_resp


VOLATILE INTEGER RESP_ACK
VOLATILE INTEGER COMMAND_INDEX

(********** TIMELINE ARRAYS ***********)
LONG lTL1_Array[1] =  //TL_PROJ_QUEUE
{
	1000
}

LONG lTL2_Array[1] =  // TL_PROJ_REQUEST
{
	1500
}
LONG lTL3_Array[1] =  //TL_NO_RESP
{
	7500
}
LONG lTL4_Array[1] =  //TL_XML
{
	10000
}

VOLATILE CHAR ProjBuff[PROJBUFF_LENGTH]
VOLATILE CHAR sXMLstring[50000]


VOLATILE INTEGER processing
VOLATILE INTEGER commandfound



(********** UDT's ************)
FRAME frame1
runningsense runsense
datarequest datreq
errorrequest errreq
informationrequest inforeq
lampinformationrequest lampinforeq 
lampinformationrequest2 lampinforeq2
filterinformationrequest filterinforeq 
lampinformationrequest3 lampinforeq3 
otherstats other
error err1
projector_stats projector_stats1
projector_settings projector_settings1
queueitem _CommandQ[50]
queueitem _RequestQ[50]

DEFINE_LATCHING

DEFINE_MUTUALLY_EXCLUSIVE



(***********************************************************)
(*        SUBROUTINE/FUNCTION DEFINITIONS GO BELOW         *)
(***********************************************************)

DEFINE_FUNCTION INTEGER find_checksum(char in1[PROJBUFF_LENGTH]) 
{(*checksum is the last byte of a data frame, 
  it is equal the LOWER 8 BITS of the sum of the rest of the frame *)
  
  STACK_VAR
  INTEGER chksum	//last byte of frame (checksum)
  INTEGER frmsum	//sum of all bits in header and dataportion 
  INTEGER x  //count//
  INTEGER length
  
  length = LENGTH_STRING(in1)
  
  IF (length < 6)  //return FALSE if only header and cks found (no data)
    RETURN 0
    
  chksum = in1[length] //SET chksum
  
  FOR(x=1; x < length ; x++) //calc frmsum
    frmsum = frmsum + in1[x]
    
  IF( (frmsum BAND $FF) == chksum)  //return TRUE if lower 8 bits of frmsum == checksum
    RETURN length
  ELSE
    RETURN 0
}

DEFINE_FUNCTION INTEGER SetBaud(integer inrate)
{
	//baudrate = inrate
	SEND_STRING 0, "'SET BAUD ',ITOA(inrate),',N,8,1 485 DISABLE'"
	SEND_COMMAND dvreal,"'SET BAUD ',ITOA(inrate),',N,8,1 485 DISABLE'"
	//SEND_COMMAND dvTP,"'TEXT2-BAUD RATE: ',ITOA(38000)"
	return 1
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

DEFINE_FUNCTION INTEGER calc_checksum(char input[PROJBUFF_LENGTH-1])
{ (*this function calculates the cks value when sending strings to projector. 
   returns the value of the last byte of a dataframe  *)

  STACK_VAR 
  INTEGER cks
  INTEGER x //count
  
  FOR(x=1; x <= LENGTH_STRING(input); x++)
    cks = cks + input[x]
  
  RETURN (cks BAND $FF)
}

DEFINE_FUNCTION LONG seconds_used (char str[PROJBUFF_LENGTH], INTEGER start, INTEGER end, INTEGER offset)
{ (*this function converts an n byte string used for reporting usage times to a integer 
	start is the first byte of the dataportion, end is the last byte (end-start = n). 
	offset is the header length
	the postconversion figure is E[i=1 -> x](i lshift i bytes)      *)
  STACK_VAR 
  INTEGER x  //count
  LONG seconds
  seconds = 0
  
  FOR (x = 0; x <= end - start; x++)
    seconds = seconds + str[start+x+offset] << (8*x) 

  RETURN seconds
}
DEFINE_FUNCTION INTEGER find_ack_response(INTEGER nHexValIn)
{
	STACK_VAR INTEGER z
	FOR (z=1; z <= LENGTH_ARRAY(ack_Responses_Hex); z++)
	{
    IF ( (nHexValIn == ack_Responses_Hex[z]) )
		{
			BREAK
		}
	}
	IF( z < LENGTH_ARRAY(ack_Responses_Hex) )
    RETURN z
  ELSE
    RETURN 0 

}




DEFINE_FUNCTION CHAR[30] Get_Nack_Readable_Error(CHAR in1[PROJBUFF_LENGTH])
{

  STACK_VAR 
  INTEGER x
  CHAR errtype
  CHAR errdesc
  
  errtype = in1[1+HEAD]
  errdesc = in1[2+HEAD]
  
  FOR (x=1; x <= LENGTH_ARRAY(nack_Errors_Hex); x++)
  {
    IF ( (errtype == nack_Errors_Hex[x][1]) AND (errdesc == nack_Errors_Hex[x][2]) )
    {
 //     err1.message = errors_readable[x]
      BREAK
    }  
  }
  IF( x < LENGTH_ARRAY(nack_Errors_Hex) )
    RETURN nack_errors_readable[x]
  ELSE
    RETURN 0 
}

DEFINE_FUNCTION INTEGER  switchinputs(INTEGER var1)
{
	// 1 - RGB1					2 - RGB2
	// 3 - VIDEO				4 - SVIDEO
	// 5 - DVI					6 - VIEWER
	// 7 - LAN
	
IF( var1 <= 7 )
{
  STACK_VAR 
  CHAR ar_commands[7]
  CHAR str_output[7]
  
  ar_commands = "$01,$02,$06,$0B,$1A,$1F,$20"
  str_output = "$02,$03,$00,$00,$02,$01,ar_commands[var1]"
  
  //SEND_STRING dvreal,"str_output,calc_checksum(str_output)"
	//CALL 'ADD TO PROJ QUEUE'("str_output,calc_checksum(str_output)")
	putqueue("str_output,calc_checksum(str_output)",'C')
	//send_string vdvQUEUE,"str_output,calc_checksum(str_output)"

	RETURN (var1)
}
  ELSE	
		RETURN 0
}

DEFINE_FUNCTION INTEGER closedcaption_set (INTEGER var1)
{
	IF (var1 <= 9)
	{
		STACK_VAR 
		CHAR ar_commands[9]
		CHAR str_output[7]
  
		ar_commands = "$00,$01,$02,$03,$04,$05,$06,$07,$08"
		str_output = "$03,$B1,$00,$00,$02,$09,ar_commands[var1]"
  
		//SEND_STRING dvreal,"str_output,calc_checksum(str_output)"
		//CALL 'ADD TO PROJ QUEUE'("str_output,calc_checksum(str_output)")
		putqueue("str_output,calc_checksum(str_output)",'c')
		RETURN(1)
	}
	ELSE
		RETURN(0)
}

DEFINE_FUNCTION INTEGER lampinfo3 (INTEGER var1)
{
	IF (var1 > 0 && var1 <= 8 )
	{
		STACK_VAR
		CHAR ar_commands[8]
		CHAR str_output[7]			
		ar_commands = "$01,$04,$08,$09,$0A,$10,$11,$12" 
		
		//ar_commands = "$01,$04,$09,$0A,$11,$12" 

		//IF(var1 == 0) 
	//var1 = 8
		str_output = "$03,$96,$00,$00,$02,$00,ar_commands[var1]"
		//SEND_STRING dvreal,"str_output,calc_checksum(str_output)"
		//CALL 'ADD TO PROJ QUEUE'("str_output,calc_checksum(str_output)")
		putqueue("str_output,calc_checksum(str_output)",'r')
		RETURN(1)
	}
	ELSE
	{
		send_string 0, "'Function LampInfo3 received inappropriate param! ... ',ITOA(var1)"
		
		RETURN(0)
	}
}

DEFINE_FUNCTION INTEGER table_index (CHAR valin, CHAR tablein[])
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

DEFINE_FUNCTION LONG putqueue (CHAR stringin[],CHAR queuetype)
{
	STACK_VAR queueitem newqitem
	INTEGER result
	
	newqitem.cID2 = stringin[2]
	newqitem.sCommand = stringin
	newqitem.cQID = (RANDOM_NUMBER(2000)+1) * (TIME_TO_SECOND(TIME)+1) * (TIME_TO_MINUTE(TIME)+1)
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
	


(*
DEFINE_CALL 'CHECK PROJ QUEUE'
{
	IF(QueuePower)
	{
		STACK_VAR CHAR val[20]
						INTEGER qcount
						
		val=''
		IF( LENGTH_ARRAY(ProjQueue) )
		{
			OFF[ProjQueueIsReady]
			val = ProjQueue[1]
			ID2_cmd = ProjQueue[1][2]
			send_string 0,"'ID2 sent: ', ITOA(GET_TIMER)"
			
			FOR(qcount = 2; qcount <= LENGTH_ARRAY(ProjQueue); qcount++)
			{
				ProjQueue[qcount-1] = ProjQueue[qcount]
			}
			SET_LENGTH_ARRAY(ProjQueue,LENGTH_ARRAY(ProjQueue)-1)
			SEND_STRING dvreal, "val"
		}
		ON[ProjQueueIsReady]
	//	RETURN(val)
	}
}

//DEFINE_FUNCTION INTEGER push_queue(CHAR valin[20])
DEFINE_CALL 'ADD TO PROJ QUEUE' (CHAR cCMD[])
{
	IF( LENGTH_ARRAY(ProjQueue) == ProjQueueMAX)
		OFF[ProjQueueIsReady]
		//RETURN 0
	IF(ProjQueueIsReady)
	{
		ProjQueue[(LENGTH_ARRAY(ProjQueue)+1)] = cCMD
		SET_LENGTH_ARRAY(ProjQueue,LENGTH_ARRAY(ProjQueue)+1)
		//RETURN(LENGTH_ARRAY(ProjQueue)
	}
//	ELSE
//	{
//		WAIT_UNTIL ProjQueueIsReady
//		{
//			CALL 'ADD TO PROJ QUEUE'(cCmd)
//		}
//	}
}


DEFINE_CALL 'CHECK PROJ QUEUEOLD'
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

    SEND_STRING 0,"'Head: ',"ITOA(ProjQueueHead)",' Tail:',"ITOA(ProjQueueTail)",' ...Head/tail difference = ',ITOA(ProjQueueHead-ProjQueueTail)"
    SEND_STRING dvreal, ProjQueue[ProjQueueTail]
    
    WAIT 5 'PROJ QUEUE'
      ON[ProjQueueIsReady]
  }
}

DEFINE_CALL 'ADD TO PROJ QUEUEold' (CHAR cCMD[])
{
  IF (ProjQueueHead = ProjQueueMAX) 
  {  
    IF (ProjQueueTail <> 1)	//IF PQHEAD AT END OF ARRAY PQTAIL NOT FIRST ELEMENT OF ARRAY
    {
      ProjQueueHead = 1		//PUT PQHEAD AT  FIRST ELEMENT OF ARRAY
      ProjQueue[ProjQueueHead] = cCMD   //ADD CMD TO FIRST ELEMENT OF ARRAY
      
      ON[ProjQueueHasItems]
    }
  }
  ELSE IF (ProjQueueTail <> ProjQueueHead + 1) //IF PQHEAD NOT AT END OF ARRAY AND PQTAIL IS NOT 1 ELEMENT AFTER PQHEAD
  {
    ProjQueueHead = ProjQueueHead + 1 //MOVE PQHEAD 1 ELEMENT AHEAD
    ProjQueue[ProjQueueHead] = cCMD
   
    ON[ProjQueueHasItems]
  }
}
*)


DEFINE_CALL 'RUNNING SENSE' (CHAR in1)
{
	runsense.proj_status        = in1 BAND $02         //PROJECTOR STATUS
	[vdvproxy,ON_fb] = in1 BAND $02
	
	runsense.ex_control         = in1 BAND $10         //EXTERNAL_CONTROL
	[vdvproxy,127] = in1 BAND $10
	
	runsense.cooling_processing = in1 BAND $20         //PROJECTOR COOLING
	[vdvproxy,COOLING_fb] = in1 BAND $20 
	
	runsense.selecting_signal   = in1 BAND $40         //INPUT CHANGING
	[vdvproxy,126] = in1 BAND $40
	
	runsense.power_processing   = in1 BAND $80         //POWER PROCESSING !!!!!!!!!!!!CHANGE!!!!!!!!!!!!
	[vdvproxy,114] = in1 BAND $80
}

DEFINE_CALL 'DATA REQUEST' (CHAR in1[PROJBUFF_LENGTH])
{
  //DATA04 - Projector status
  datreq.proj_status          = in1[4+HEAD]          //PROJECTOR STATUS
  [vdvproxy,ON_fb] = in1[4+HEAD]  
  
  //DATA05 - Cooling processing
  datreq.cooling_processing   = in1[5+HEAD]          //PROJECTOR COOLING
  [vdvproxy,COOLING_fb] = in1[5+HEAD] 
  
  SWITCH (in1[7+HEAD]) //DATA07 - Type 1 of input terminal to be selected
  {
    CASE $01:
    {
      SWITCH (in1[8+HEAD]) //DATA08 - Type 2 of input terminal to be selected
      {
        CASE $01:
          datreq.active_input = RGB1_fb 		//RGB1'
        CASE $02:
          datreq.active_input = VID_fb 		//VIDEO'
        CASE $03:
          datreq.active_input = SVID_fb 		//S-VIDEO'
        CASE $06:
          datreq.active_input = DIG_fb	//DIGITAL'
        CASE $07:
          datreq.active_input = VIEWER_fb 		//VIEWER'
      }      
    }
    CASE $02:
    {
      SWITCH (in1[8+HEAD]) //DATA08 - Type 2 of input terminal to be selected
      {
        CASE $01:
          datreq.active_input = RGB2_in //RGB2'
        //CASE $04:
//          datreq.active_input = COMPONENT  	//COMPONENT'
        CASE $07:
          datreq.active_input = LAN_fb        	//LAN'
      }
    }
  }
  
  IF ( ![vdvproxy,source_type_fbchan[datreq.active_input-106]] )
  {//IF input source type has just changed
	OFF[vdvproxy,source_type_fbchan]
	ON [vdvproxy,source_type_fbchan[datreq.active_input-106] ]
  }
  
  datreq.picture_mute         = in1[29+HEAD]
  [vdvproxy,MUTE_fb] = in1[29+HEAD] 
  
  datreq.sound_mute           = in1[30+HEAD]
  [vdvproxy,121] = in1[30+HEAD]
  
  datreq.forced_onscreen_mute = in1[66+HEAD]
  [vdvproxy,122] = in1[66+HEAD]
  
  datreq.onscreen_display     = in1[67+HEAD] //i.e. RGB/RGB2
  [vdvproxy,125] = in1[67+HEAD]
  
  datreq.selecting_signal     = in1[68+HEAD]
  [vdvproxy,126] = in1[68+HEAD]
  
  datreq.operation_status     = in1[69+HEAD]
  //[vdvproxy,69] = in1[69+HEAD]    //4 different possible vals
  
  datreq.onscreen_mute        = in1[83+HEAD]
  [vdvproxy,123] = in1[83+HEAD]
  
  datreq.indicate_contents    = in1[85+HEAD]
  //[vdvproxy,69] = in1[85+HEAD]		//5 different possible vals
}



DEFINE_CALL 'ERROR REQUEST' (CHAR in1[PROJBUFF_LENGTH])
{
errreq.lamp_cover_err = 		in1[1+HEAD] BAND $01   
	[vdvproxy,201]		=  in1[1 +HEAD] BAND $01   					//V51 (PROJ_COVER_OPEN)

	errreq.temp_err_bimetal	=		in1[1 +HEAD] BAND $02   //V52 (PROJ_TEMP_FAULT)
	[vdvproxy,202]	=  in1[1 +HEAD] BAND $02 

	errreq.fan_err       		=  in1[1 +HEAD] BAND $10   
	[vdvproxy,203]      		=  in1[1 +HEAD] BAND $10     //V53 (PROJ_FAN_STOP - $08 (incorrect) in Valley Module

	errreq.power_err     		=  in1[1 +HEAD] BAND $20   
	[vdvproxy,204]    		=  in1[1 +HEAD] BAND $20   	   //V54 (PROJ_PWR_SUPPLY)

	errreq.lamp1_err     		=  in1[1 +HEAD] BAND $40   
	[vdvproxy,205]     		=  in1[1 +HEAD] BAND $40    //V55 (PROJ_LAMPFAIL)
	
	errreq.lamp1_eol     		=  in1[1 +HEAD] BAND $80   
	[vdvproxy,206]    		=  in1[1 +HEAD] BAND $80   
	//--
	errreq.lamp1_limit   		=  in1[2 +HEAD] BAND $01   
	[vdvproxy,207]  		=  in1[2 +HEAD] BAND $01   
	
	errreq.dmd_err       		=  in1[2 +HEAD] BAND $02   
	[vdvproxy,208]       		=  in1[2 +HEAD] BAND $02   
	
	errreq.lamp2_err     		=  in1[2 +HEAD] BAND $04   
	[vdvproxy,209]    		=  in1[2 +HEAD] BAND $04   
	//--
	errreq.fpga_err      		=  in1[3 +HEAD] BAND $02   
	[vdvproxy,210]     		=  in1[3 +HEAD] BAND $02   
	
	errreq.temp_err_sensor		=  in1[3 +HEAD] BAND $04   
	[vdvproxy,211]		=  in1[3 +HEAD] BAND $04   

	errreq.lamp1_housing_err	=  in1[3 +HEAD] BAND $08 
	[vdvproxy,212]	=  in1[3 +HEAD] BAND $08 
	
	errreq.lamp1_data_err 		=  in1[3 +HEAD] BAND $10   
	[vdvproxy,213] 		=  in1[3 +HEAD] BAND $10   
	
	errreq.mirror_err    		=  in1[3 +HEAD] BAND $20   
	[vdvproxy,214]    		=  in1[3 +HEAD] BAND $20   
	
	errreq.lamp2_eol     		=  in1[3 +HEAD] BAND $30   
	[vdvproxy,215]   		=  in1[3 +HEAD] BAND $30   
	
	errreq.lamp2_limit   		=  in1[3 +HEAD] BAND $40   
	[vdvproxy,216]  		=  in1[3 +HEAD] BAND $40   
	//--
	errreq.lamp2_housing_err  		=  in1[4 +HEAD] BAND $01   
	[vdvproxy,217] 		=  in1[4 +HEAD] BAND $01   
	
	errreq.lamp2_data_err     		=  in1[4 +HEAD] BAND $02   
	[vdvproxy,218]    		=  in1[4 +HEAD] BAND $02   
	
	errreq.temp_err_dust		=  in1[4 +HEAD] BAND $04    
	[vdvproxy,219]		=  in1[4 +HEAD] BAND $04    
	
	errreq.foreign_object_err 	=  in1[4 +HEAD] BAND $08
	[vdvproxy,220] 	=  in1[4 +HEAD] BAND $08
}




DEFINE_CALL 'INFORMATION REQUEST' (CHAR in1[PROJBUFF_LENGTH])
{
  STACK_VAR x //count
  
  FOR(x = 1; x < 50; x++)  //get projector name
    projector_settings1.projector_name = "projector_settings1.projector_name,in1[x+HEAD]"
  
  inforeq.lamp_hr_norm    = seconds_used(in1,83,86,HEAD)/3600 
  projector_stats1.lamp_seconds_used = seconds_used(in1,83,86,HEAD)
  
  inforeq.filter_usage    = seconds_used(in1,87,90,HEAD)/3600 
  projector_stats1.filter_seconds_used = seconds_used(in1,87,90,HEAD)
  
  inforeq.panel_usage     = seconds_used(in1,91,94,HEAD)/3600 
  projector_stats1.panel_seconds_used = seconds_used(in1,91,94,HEAD)
  
  inforeq.projector_usage = seconds_used(in1,95,98,HEAD)/3600
  projector_stats1.projector_seconds_used = seconds_used(in1,95,98,HEAD)
} 

DEFINE_CALL 'LAMP INFORMATION REQUEST' (CHAR in1[PROJBUFF_LENGTH])
{
	lampinforeq.lamp_hr_norm            = seconds_used(in1,1,4,HEAD)/3600  
  projector_stats1.lamp_seconds_used  = seconds_used(in1,1,4,HEAD)
  
  lampinforeq.warning_start_time_norm = seconds_used(in1,9,12,HEAD)/3600 
  projector_settings1.lamp_warn_start_seconds = seconds_used(in1,9,12,HEAD)
  
  lampinforeq.prohibit_use_time_norm  = seconds_used(in1,13,16,HEAD)/3600
  projector_settings1.lamp_prohib_start_seconds = seconds_used(in1,13,16,HEAD)
}

DEFINE_CALL 'LAMP INFORMATION REQUEST 2' (CHAR in1)
{
  lampinforeq2.lamp_percent_remaining = in1
  projector_stats1.lamp_pct_remaining = TYPE_CAST(in1)
}

DEFINE_CALL 'LAMP INFORMATION REQUEST 3'(CHAR in1[PROJBUFF_LENGTH])
{
  STACK_VAR LONG secs
  secs = seconds_used(in1,3,6,HEAD)

  SWITCH (in1[1+HEAD])
  {
    CASE $00:
    {
      SWITCH (in1[2+HEAD])
      {
        CASE $01:
				{
        lampinforeq3.lamp1_usage                        =  seconds_used(in1,3,6,HEAD) /3600
				projector_stats1.lamp_seconds_used_info3 = secs
        }
				CASE $04:
				{
					lampinforeq3.lamp1_percent_remaining            = seconds_used(in1,3,6,HEAD)
          projector_stats1.pct_til_lamp_warn = TYPE_CAST(secs)
				}
				CASE $08:
				{
					lampinforeq3.lamp1_warning_start_spec_remaining = seconds_used(in1,3,6,HEAD) /3600      
        }
				CASE $09:
				{
					lampinforeq3.lamp1_warning_start_norm_remaining = seconds_used(in1,3,6,HEAD) /3600      
					projector_stats1.seconds_til_warn_norm = secs
        }
				CASE $0A:
				{
					lampinforeq3.lamp1_warning_start_eco_remaining  = seconds_used(in1,3,6,HEAD) /3600      
					projector_stats1.seconds_til_warn_eco = secs
        }
				CASE $10:
				{
					lampinforeq3.lamp1_inhibit_spec_remaining       = seconds_used(in1,3,6,HEAD) /3600 		 
				}
        CASE $11:      
				{
					lampinforeq3.lamp1_inhibit_norm_remaining       = seconds_used(in1,3,6,HEAD) /3600      
					projector_stats1.seconds_til_inhib_norm = secs
				}
        CASE $12:
				{
					lampinforeq3.lamp1_inhibit_eco_remaining        = seconds_used(in1,3,6,HEAD) /3600      
					projector_stats1.seconds_til_inhib_eco = secs
				}
      }
    }
  }
}

DEFINE_CALL 'FILTER INFORMATION REQUEST'(CHAR in1[PROJBUFF_LENGTH])
{
	filterinforeq.filter_usage       = seconds_used(in1,1,4,HEAD)/3600
  projector_stats1.filter_seconds_used = seconds_used(in1,1,4,HEAD)
  
	filterinforeq.warning_start_time = seconds_used(in1,5,8,HEAD)/3600
  projector_settings1.filter_warn_seconds = seconds_used(in1,5,8,HEAD)
}

DEFINE_CALL 'LAMP COOLING TIME REQUEST'(CHAR in1[PROJBUFF_LENGTH])
{
	other.lampcoolingtime = seconds_used(in1,1,2,HEAD)
  projector_settings1.lamp_cool_seconds = seconds_used(in1,1,2,HEAD)
}

DEFINE_CALL 'B0REQUEST'(CHAR in1[PROJBUFF_LENGTH])
{  
  SWITCH (in1[1+HEAD])
  {
//    CASE $06: //MESSAGE REQUEST
//    {
//      other.message = in1[2+HEAD]
//      frame1.fname =  'msg'
//    }
    CASE $07: //ECO MODE?
    {
    other.eco = in1[2+HEAD]
    frame1.fname = "frame1.fname,'-eco'"
	  [vdvproxy,115] = in1[2+HEAD] 
    }
    CASE $08: //IDLE MODE?
    { 
    other.idlemode = in1[2+HEAD]
    frame1.fname = "frame1.fname,'-idle'"
		[vdvproxy,116] = in1[2+HEAD]
    }
    CASE $09: //CLOSED CAP
    {
	  other.closedcaption =  in1[2+HEAD]
		frame1.fname = "frame1.fname,'-cc'"
	
		//send_string 0,"'caption value = ',ITOA(in1[2+HEAD])"
		//send_string 0,"'feedback channel = ',closed_caption_detail_fbchan[in1[2+HEAD]]"
		[vdvproxy,117] = in1[2+HEAD]
	
		IF ( in1[2+HEAD] == $00 )
		{
			OFF[vdvproxy,closed_caption_detail_fbchan]
		}
		ELSE
		{
			IF ( ![ vdvproxy,closed_caption_detail_fbchan[in1[2+HEAD]] ] )
			{
				OFF[vdvproxy,closed_caption_detail_fbchan]
				ON[ vdvproxy,closed_caption_detail_fbchan[in1[2+HEAD]] ]
			}
		}
	}
  }
}


DEFINE_CALL 'SLEEP TIMER REQUEST'(CHAR in1[PROJBUFF_LENGTH])
{
  other.sleeptimer = seconds_used(in1,1,2,HEAD)
  projector_stats1.timer_seconds_remaining = seconds_used(in1,1,2,HEAD)
  ON[vdvproxy,118]
  
}


DEFINE_CALL 'SLEEP TIMER SET'(INTEGER nminutes)
{
  STACK_VAR
  INTEGER nseconds 
  CHAR str_output[7]
  
  nseconds = nminutes * 60
  str_output = "$03,$93,$00,$00,$02,(nseconds BAND $FF),(nseconds BAND $FF00)"
  //SEND_STRING dvreal,"str_output,calc_checksum(str_output)"
	//CALL 'ADD TO PROJ QUEUE'("str_output,calc_checksum(str_output)")
	putqueue("str_output,calc_checksum(str_output)",'c')
	//SEND_STRING vdvQUEUE,"str_output,calc_checksum(str_output)"
  //SEND_STRING 0,"'TIMER SET FOR ',ITOA(nseconds), ' SECONDS'"  
}

DEFINE_CALL 'INPUT SW CHANGE' (CHAR in1)
{
	IF (in1 == $00)
		//send_string 0,'projector input switch ok'
		on[vdvproxy,255]
	ELSE
		//send_string 0,'projector input switch error'
		on[vdvproxy,255]
}



DEFINE_CALL 'PROCESS ERROR'(CHAR in1[PROJBUFF_LENGTH])
{
  STACK_VAR
  CHAR errtype
  CHAR errdesc
	INTEGER id1val
	INTEGER id2val
  
	id1val = in1[1]
	id2val = in1[2]
  errtype = in1[1+HEAD]
  errdesc = in1[2+HEAD]
	
	//err1.message
	err1.id1 = id1val
	err1.command_hex = id2val

	if(find_ack_response(id2val))
		err1.command_text = ack_Responses_Readable[find_ack_response(id2val)]
}



DEFINE_START

CREATE_BUFFER dvreal,ProjBuff
CLEAR_BUFFER ProjBuff

//marker_lampinfo3 = 1
marker_checkqueue = 1
//ProjQueueHead     = 1
//ProjQueueTail     = 1
//ProjQueueIsReady  = 1
//ProjQueueHasItems = 0
QueuePower = TRUE
//CheckQueuePower = TRUE

lTL1_Array[1] = cmd_cycle_time

lTL2_Array[1] = cmd_cycle_time * cmd_req_ratio



TIMELINE_CREATE(TL_PROJ_QUEUE,lTL1_Array,1,TIMELINE_RELATIVE,TIMELINE_REPEAT)
TIMELINE_CREATE(TL_PROJ_REQUEST,lTL2_Array,2,TIMELINE_RELATIVE,TIMELINE_REPEAT)
TIMELINE_CREATE(TL_NO_RESP,lTL3_Array,1,TIMELINE_RELATIVE,TIMELINE_REPEAT)
TIMELINE_CREATE(TL_XML,lTL4_Array,1,TIMELINE_RELATIVE,TIMELINE_REPEAT)

ON[vdvProxy,MonitorDevice]


DEFINE_EVENT

(*
DATA_EVENT[vdvQUEUE]
{
	STRING:
	{
		STACK_VAR CHAR mystring[400]
		mystring = DATA.TEXT
	
		send_string 0, "'string sent to queue: ', PRINT_HEX(mystring)"
	
	}



}
*)
DATA_EVENT[dvreal]

{ 
  ONLINE:
  {
    SEND_COMMAND dvreal,'SET BAUD 9600,N,8,1 485 DISABLE'
		//baudrate = 9600
		//SEND_COMMAND dvTP,"'TEXT2-CURRENT BAUD=| ',ITOA(baudrate)"
  } 
  
  STRING:
  { 
		WAIT 3
		{
    IF ( find_checksum(ProjBuff) )
    {    
			//flag to indicate string is being processed...how long does this take?...remove?
      ON[processing]
			TIMELINE_PAUSE(TL_NO_RESP)
			ON[vdvproxy,COMM_ACTIVE]
		
      //SEND_STRING 0,"'checksumfound: ', ITOA(find_checksum(ProjBuff))"  //DEBUG
			
			//set frame members
      frame1.ID1 = ITOHEX(ProjBuff[1])
      frame1.ID2 = ITOHEX(ProjBuff[2])
      frame1.ProjID = ITOHEX (ProjBuff[3])
      frame1.Model = ITOHEX(ProjBuff[4] RSHIFT 4)
      frame1.DataLength = ITOHEX( ( (ProjBuff[4] & $0F) LSHIFT 8 ) BOR ProjBuff[5] )
      frame1.DataPortionSize = LENGTH_STRING(ProjBuff) - 6
      
			//NEW SHIT!!!!!
			ID1 = ProjBuff[1]
			ID2_resp = ProjBuff[2]
			
			send_string 0,"'ID2 recd: ',ITOA(GET_TIMER)"
			if(ID2_resp == ID2_cmd)
				send_string 0, 'MATCH!'
			else
				send_string 0, 'NO MATCH!!!!!!!!!!!!!!!!'
				
      SWITCH( ID1 >> 4)
      {
        CASE $0A:
          RESP_ACK  = 0
        CASE $02:
          RESP_ACK = 1
      }
			
			
			
			COMMAND_INDEX = table_index(ID2_resp,ID2_table)
			//send_string 0,"'Command index = ', ITOA(COMMAND_INDEX)"
			
			IF(RESP_ACK)
			{
				SWITCH(COMMAND_INDEX)
				{
					CASE RUNNING_SENSE:
					{
						CALL 'RUNNING SENSE'(ProjBuff[6])
					}
					CASE COMMON_DATA_REQUEST:
					{
						CALL 'DATA REQUEST'(ProjBuff)
					}
					CASE ERROR_STATUS_REQUEST:
					{
						CALL 'ERROR REQUEST' (ProjBuff)
					}
					CASE POWER_ON:
					{
						//ON[vdvproxy,ON_fb] //POWER FEEDBACK
						SEND_STRING 0, 'proj received ON cmd'
					}
					CASE POWER_OFF:
					{
						OFF[vdvproxy,ON_fb] //PROJECTOR GOES INTO OFF STATE
						ON[vdvproxy,COOLING_fb] //PROJECTOR GOES INTO COOLING STATE
						OFF[vdvProxy,MonitorDevice]
						wait 50
							on[vdvProxy,MonitorDevice]
						SEND_STRING 0, 'proj received OFF cmd'
					}
					CASE INPUT_CHANGE:
					{
						SEND_STRING 0, 'proj received input switch cmd'
					}
					CASE PICTURE_MUTE_OFF:
					{
						OFF[vdvproxy,MUTE_fb]
						SEND_STRING 0, 'proj received MUTE OFF cmd'
					}
					CASE PICTURE_MUTE_ON:
					{
						ON[vdvproxy,MUTE_fb]
						SEND_STRING 0, 'proj received MUTE ON cmd'
					}
					CASE ONSCREEN_MUTE_ON:
					{
					
					}
					CASE ONSCREEN_MUTE_OFF:
					{
					
					}
					CASE INFORMATION_REQUEST:
					{
						CALL 'INFORMATION REQUEST'(ProjBuff)				
					}
					CASE LAMP_INFORMATION_REQUEST:
					{
						CALL 'LAMP INFORMATION REQUEST'(ProjBuff)
					}
					CASE LAMP_INFORMATION_REQUEST_2:
					{
						CALL 'LAMP INFORMATION REQUEST 2'(ProjBuff[5+HEAD]) 
					}
					CASE FILTER_INFORMATION_REQUEST:
					{
						CALL 'FILTER INFORMATION REQUEST'(ProjBuff)
					}
					CASE LAMP_INFORMATION_REQUEST_3:
					{
						CALL 'LAMP INFORMATION REQUEST 3'(ProjBuff)           
					}
					CASE LAMP_COOLING_TIME_REQUEST:
					{
						CALL 'LAMP COOLING TIME REQUEST'(ProjBuff)
					}
					CASE B0_REQUEST:
					{
						CALL 'B0REQUEST'(ProjBuff)
					}
					CASE FACTORY_DEFAULT_SET:
					{
					
					}
					CASE SLEEP_TIMER_REQUEST:
					{
					
					}
					
				}
			}
			ELSE
			{
					err1.message = Get_Nack_Readable_Error(ProjBuff)
					CALL 'PROCESS ERROR'(ProjBuff)
			}
			
			
			
			
			
			//find out if command was recognized (ACK) or not (NACK)
      SWITCH( ProjBuff[1] >> 4) //send 
      {
        CASE $0A:
          frame1.frameresult = 'nack'
        CASE $02:
          frame1.frameresult = 'ack'
      }
      
			//my own categories -- might need to be modified - GET RID OF THEM?
      SWITCH( ProjBuff[1] & $0F)
      {
        CASE $00:
        {
          frame1.frametype = 'baser'
        }
        CASE $02:
        {
          frame1.frametype = 'basew'
        }
        CASE $03:
        {
          frame1.frametype = 'advanced'
        }   
      }
      
      {
				//the second byte of the response code indicated what command was sent...regardless of ACK or NACK
(*				STACK_VAR INTEGER mycount
        FOR(mycount = 1; mycount <= LENGTH_ARRAY(ack_Responses_Hex); mycount ++)
        //set frame function name
        {
          IF ( ProjBuff[2] == ack_Responses_Hex[mycount]) //HexFunctions[mycount] )
          {
            frame1.fname = ack_Responses_Readable[mycount]// 'RUNNING SENSE'//
						ON[commandfound]
            BREAK 
          }
        }*)
			}
      IF(commandfound)
			{
				IF (frame1.frameresult == 'ack')
				{
					SWITCH (frame1.fname)
					{
						CASE 'RUNNING SENSE':
						{
							CALL 'RUNNING SENSE'(ProjBuff[6])
						}
						CASE 'DATA REQUEST':
						{
							CALL 'DATA REQUEST'(ProjBuff)
						}
						CASE 'ERROR REQUEST':
						{
							CALL 'ERROR REQUEST' (ProjBuff)
						}
						CASE 'INFORMATION REQUEST':
						{
							CALL 'INFORMATION REQUEST'(ProjBuff)
						}
						CASE 'LAMP INFORMATION REQUEST':
						{
							CALL 'LAMP INFORMATION REQUEST'(ProjBuff)
						}
						CASE 'LAMP INFORMATION REQUEST 2':
						{
							CALL 'LAMP INFORMATION REQUEST 2'(ProjBuff[5+HEAD]) 
						}
						CASE 'FILTER INFORMATION REQUEST':
						{
							CALL 'FILTER INFORMATION REQUEST'(ProjBuff)
						}
						CASE 'LAMP INFORMATION REQUEST 3':
						{
							CALL 'LAMP INFORMATION REQUEST 3'(ProjBuff)           
						}
						CASE 'LAMP COOLING TIME REQUEST':
						{
							CALL 'LAMP COOLING TIME REQUEST'(ProjBuff)
						}
						CASE 'B0REQUEST':
						{
							CALL 'B0REQUEST'(ProjBuff)
						}
						CASE 'SLEEP TIMER REQUEST':
						{
							CALL 'SLEEP TIMER REQUEST'(ProjBuff)
						}
						CASE 'INPUT SW CHANGE':
						{
							CALL 'INPUT SW CHANGE'(ProjBuff[1+HEAD])
						}
					}
				}      
				ELSE // (frame1.frameresult == 'nack')
				{
					err1.message = Get_Nack_Readable_Error(ProjBuff)
					CALL 'PROCESS ERROR'(ProjBuff)
				}
				
				//WAIT 10 'clear frame'
				{
					frame1.ID1 = ''
					frame1.ID2 = ''
					frame1.ProjID = ''
					frame1.Model = ''
					frame1.DataLength = ''
					frame1.DataPortionSize = 0
					frame1.fname = ''
					frame1.frameresult = ''
					frame1.frametype = ''
				}
			}
      
      CLEAR_BUFFER ProjBuff
      OFF[processing]
			OFF[commandfound]
			TIMELINE_SET(TL_NO_RESP,0)  
			TIMELINE_RESTART(TL_NO_RESP)
    }
		ELSE
		{
			send_string 0,"'no checksum found in buffer'" 
		  CLEAR_BUFFER ProjBuff
      OFF[processing]
			OFF[commandfound]
			//TIMELINE_SET(TL_NO_RESP,0)  
			//TIMELINE_RESTART(TL_NO_RESP)
    }
  }
	}
}

CHANNEL_EVENT[vdvproxy,ACTION_group]
{
	ON:
	{
		//SEND_STRING dvreal,"Proj_commands[GET_LAST(Proj_Command_Channels)]"
		//CALL 'ADD TO PROJ QUEUE'("ACTION_hex_cmds[GET_LAST(ACTION_group)]")
		putqueue("ACTION_hex_cmds[GET_LAST(ACTION_group)]",'C')
		//SEND_STRING vdvQUEUE,"ACTION_hex_cmds[GET_LAST(ACTION_group)]"
	}
}

CHANNEL_EVENT[vdvproxy,MonitorDevice]
{
	ON:
	{
		//ON[QueuePower]
		IF(TIMELINE_ACTIVE(TL_PROJ_REQUEST))
		{
			TIMELINE_RESTART(TL_PROJ_REQUEST)
		}
		ELSE
		{
			TIMELINE_CREATE(TL_PROJ_REQUEST,lTL2_Array,1,TIMELINE_ONCE,TIMELINE_REPEAT)
		}
	}
	
	OFF:
	{
		//OFF[QueuePower]
		
		IF(TIMELINE_ACTIVE(TL_PROJ_REQUEST))
			TIMELINE_PAUSE(TL_PROJ_REQUEST)
		SET_LENGTH_ARRAY(_RequestQ,0)
	}
}



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
		popqueue(_RequestQ);
	}
	
}

TIMELINE_EVENT[TL_PROJ_REQUEST]
{
		IF(TIMELINE.REPETITION == 0 OR TIMELINE.REPETITION % 2 == 0)
		{
			//CALL 'ADD TO PROJ QUEUE'("Proj_setting_commands[2]")
			putqueue("Proj_setting_commands[2]",'R')
		}
		ELSE //IF (marker_checkqueue != 19)
		{
			//CALL 'ADD TO PROJ QUEUE'("Proj_setting_commands[marker_checkqueue]")
			putqueue("Proj_setting_commands[marker_checkqueue]",'R')
			marker_checkqueue++
			IF(marker_checkqueue > 19)
			 marker_checkqueue = 1
		}
		//ELSE
//		{
//			marker_checkqueue = 1;
//			lampinfo3(marker_lampinfo3);
//			IF(marker_lampinfo3 == 8)
//				marker_lampinfo3 = 1
//			ELSE
//				marker_lampinfo3++;
//		}
			
	(*
	STACK_VAR LONG x
	CHAR thestring[10]
	
	
	x = (TIMELINE.REPETITION/2)%MAX_LENGTH_ARRAY(Proj_setting_commands)+1
	
	send_string 0,"'x = ',ITOA(x)"
	//callsequence = x
	IF (CheckQueuePower)
	{
		IF (TIMELINE.REPETITION % 2 == 0 || TIMELINE.REPETITION == 0 ) 
		{
			CALL 'ADD TO PROJ QUEUE'("Proj_setting_commands[2]")
			SEND_STRING vdvQUEUE,"Proj_setting_commands[2]"
		}
		ELSE	IF (x != MAX_LENGTH_ARRAY(Proj_setting_commands))
		{
			CALL 'ADD TO PROJ QUEUE'("Proj_setting_commands[x]")
			SEND_STRING vdvQUEUE,"Proj_setting_commands[x]"
			}
		ELSE
		{
				//send_string 0,"'LI3 = ',lampinfo3(marker_lampinfo3)"
				lampinfo3(marker_lampinfo3)
				IF(marker_lampinfo3 == 8)
					marker_lampinfo3 = 1
				ELSE
					marker_lampinfo3++;
			
			//CALL 'ADD TO PROJ QUEUE'("lampinfo3((((TIMELINE.REPETITION/2)+1)/MAX_LENGTH_ARRAY(Proj_setting_commands)) % 8)")
			//send_string 0,"'In lampinfo3 with param ',ITOA(((TIMELINE.REPETITION/2+1)%8))";
			//CALL 'ADD TO PROJ QUEUE'("lampinfo3((TIMELINE.REPETITION/2+1)%8)");
			//CALL 'ADD TO PROJ QUEUE'("lampinfo3((TIMELINE.REPETITION/2+1)%8)");
			
			//SEND_STRING vdvQUEUE,"lampinfo3((((TIMELINE.REPETITION/2)+1)/MAX_LENGTH_ARRAY(Proj_setting_commands)) % 8)"
			//CALL 'ADD TO PROJ QUEUE'("lampinfo3(3)")
			//callsequence = (TIMELINE.REPETITION/ MAX_LENGTH_ARRAY(Proj_setting_commands)) %6
			//send_string 0,"'Repetition = ',ITOA(TIMELINE.REPETITION)"
			//send_string 0,"'Maxlength = ',ITOA(MAX_LENGTH_ARRAY(Proj_setting_commands))"
			//send_string 0,"'lampinfo3 param = ',ITOA((((TIMELINE.REPETITION/2)+1)/MAX_LENGTH_ARRAY(Proj_setting_commands)) % 9)"
		}
	}
	*)
}

TIMELINE_EVENT[TL_NO_RESP]
{
  
  OFF[vdvproxy,COMM_ACTIVE]	//online feedback
  //OFF[vdvproxy,in1]
  //OFF[vdvproxy,in2]
}

TIMELINE_EVENT[TL_XML]
{
	STACK_VAR	SLONG slReturn
	slReturn = VARIABLE_TO_XML(projector_stats1,sXMLstring,1,0)

}

CHANNEL_EVENT[vdvproxy,source_type_cmdchan]
{
	ON:
	{

		STACK_VAR INTEGER myinput
		INTEGER result
		myinput = GET_LAST(source_type_cmdchan)
		IF(![vdvproxy,source_type_fbchan[GET_LAST(source_type_cmdchan)]])
			result = switchinputs(myinput)
		
		
				//PULSE[vdvProj,SUBNAV_INPUT_SIGNAL[GET_LAST(dcSource)]]
//	    send_String 0,"'switch command received...input number ',ITOA(myinput)"
//		send_string 0,"switchinputs(myinput),calc_checksum(switchinputs(myinput))"
		//send_string 0,"'result = ',ITOA(result)"
	}
}

CHANNEL_EVENT[vdvproxy,closed_caption_cmdchan]
{
	ON:
	{
		STACK_VAR INTEGER myinput
		INTEGER result
		myinput = GET_LAST(closed_caption_cmdchan)
		result = closedcaption_set(myinput)
	}
}




(*
BUTTON_EVENT[dvTP,87]
{
	PUSH:
	{
		putqueue("Proj_setting_commands[3]",'C')
	}
}

BUTTON_EVENT[dvTP,88]
{
	PUSH:
	{
		putqueue("ACTION_hex_cmds[3]",'c');
	}
	HOLD[10]:
	{
		putqueue("ACTION_hex_cmds[4]",'C');
	}
}
*)
DEFINE_PROGRAM
