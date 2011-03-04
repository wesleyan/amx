PROGRAM_NAME='van vleck revision 4'
(***********************************************************)
(* System Type : NetLinx                                   *)
(***********************************************************)
(* REV HISTORY:                                            *)
(***********************************************************)

(***********************************************************)
(*          DEVICE NUMBER DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_DEVICE

dvTP = 128:1:0

dvExtron 	= 5001:1:0
vdvExtron	= 33001:1:0


dvLeftProj 	= 5001:2:0
vdvLeftProj	= 33001:2:0

dvRightProj 	= 5001:4:0
vdvRightProj	= 33001:4:0

dvBB		= 5001:3:0
vdvBB		= 33001:3:0

dvRelay 	= 5001:7:0
dvVCR		= 5001:8:0
dvDVD		= 5001:9:0

dvVol		= 150:1:0
(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT

VOLATILE INTEGER Screen_Left_Channels[]=
{
    3, //up
    4  //down
}

VOLATILE INTEGER Screen_Right_Channels[]=
{
    1, //up
    2  //down
}

VOLATILE INTEGER LeftProj_Source_Buttons[]=
{
    2, 	//MacPriMon
    4, 	//MacSecMon
    6, 	//PcPriMon 
    8, 	//PcSecMon 
    10, //DVD	  
    12, //VCR	  
    14, //RackAux  
    16, //PodLap	  
    18,	//DocCam	  
    20 	//PodAux    
}

VOLATILE INTEGER RightProj_Source_Buttons[] =
{
    1, 	//MacPriMon
    3, 	//MacSecMon
    5,	//PcPriMon 
    7, 	//PcSecMon 
    9, //DVD	  
    11, //VCR	  
    13, //RackAux  
    15, //PodLap	  
    17,	//DocCam	  
    29 	//PodAux    
}

//TP Source Button Order
VOLATILE INTEGER MacPriMon = 1
VOLATILE INTEGER MacSecMon = 2
VOLATILE INTEGER PcPriMon  = 3
VOLATILE INTEGER PcSecMon  = 4
VOLATILE INTEGER DVD	   = 5
VOLATILE INTEGER VCR	   = 6
VOLATILE INTEGER RackAux   = 7
VOLATILE INTEGER PodLap	   = 8
VOLATILE INTEGER DocCam	   = 9
VOLATILE INTEGER PodAux    = 10






VOLATILE CHAR Extron_Video_Input_Type[10][4]=
{
    'RGB',	//MacPriMon 
    'RGB',	//MacSecMon 
    'RGB',	//PcPriMon  
    'RGB',	//PcSecMon  
    'VID',	//DVD	  
    'SVID',	//VCR	  
    'VID',	//RackAux   
    'RGB',	//PodLap	  
    'RGB',	//DocCam	  
    'VID'	//PodAux
}

//OUTPUTS
LeftProj_RGB_out	= 52
LeftProj_VID_out	= 56
LeftProj_SVID_out	= 54
RightProj_RGB_out	= 51
RightProj_VID_out	= 55
RightProj_SVID_out	= 53
LocalMonitor_out	= 57


VOLATILE INTEGER Screen_Left_Buttons[] =
{  61, //up
   63  //down
}

VOLATILE INTEGER Screen_Right_Buttons[] =
{  60, //up
   62  //down
}

VOLATILE INTEGER Keyboard_Buttons[] =
{
    86,  //pc
    87	 //mac
}

VOLATILE INTEGER Shutdown_Button = 150

VOLATILE INTEGER Volume_Buttons[] = 
{
    90,  //up
    91	 //down
}

VOLATILE INTEGER VCR_Buttons[]=
{
    40,	//play
    42, //stop
    41, //pause
    43, //FF
    44  //RW
}

VOLATILE INTEGER DVD_Buttons[]=
{
    50,	//play
    51, //stop 
    52, //pause
    53, //skipF
    54, //skipB
    55, //scanF
    56  //scanB
}

VOLATILE INTEGER LProj_Power_Buttons[]=
{
    70, //on
    71  //off
}

VOLATILE INTEGER LProj_Mute_Buttons[]=
{
    84, //on
    85  //off
}

VOLATILE INTEGER LProj_Video_Buttons[]=
{
    72,	//rgb
    73, //rgb2
    74, //video
    75  //svid
}

VOLATILE INTEGER RProj_Power_Buttons[]=
{
    78, //on
    79  //off
}

VOLATILE INTEGER RProj_Mute_Buttons[]=
{
    76, //on
    77  //off
}

VOLATILE INTEGER RProj_Video_Buttons[]=
{
    80, //rgb
    81, //rgb2
    82, //video
    83  //svid
}

VOLATILE LONG TL_FEEDBACK = 1



VOLATILE INTEGER volume_step = 5
VOLATILE INTEGER max_volume = 255
VOLATILE INTEGER min_volume = 0

VOLATILE DEVLEV volumecard = {dvVol,1}
(***********************************************************)
(*              DATA TYPE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_TYPE

(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE

VOLATILE LONG TL_FEEDBACK_ar[] = 
{
    250
}	

VOLATILE INTEGER switch_ties[50]

PERSISTENT INTEGER volume

VOLATILE INTEGER extron_input[10]

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

Extron_Input[MacPriMon] = 3
Extron_Input[MacSecMon] = 0
Extron_Input[PcPriMon] 	= 1
Extron_Input[PcSecMon] 	= 0
Extron_Input[DVD] 	= 5
Extron_Input[VCR] 	= 6
Extron_Input[RackAux] 	= 7
Extron_Input[PodLap] 	= 8
Extron_Input[DocCam] 	= 0
Extron_Input[PodAux] 	= 0


TIMELINE_CREATE(TL_FEEDBACK,TL_FEEDBACK_ar,1,TIMELINE_RELATIVE,TIMELINE_REPEAT)

//CREATE_LEVEL dvVol,1,volume

SEND_COMMAND dvTP,'@PPK-shutdown'
SEND_COMMAND dvTP,'PAGE-Title Page'

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

DEFINE_MODULE 'NEC1065_f' lproj (dvLeftProj,vdvLeftProj)
DEFINE_MODULE 'NEC1065_f' rproj (dvRightProj,vdvRightProj)
DEFINE_MODULE 'crosspoint_mod' extron (dvExtron,vdvExtron,switch_ties)
DEFINE_MODULE 'DataSwitch_mod' bb (dvBB,vdvBB)
(***********************************************************)
(*                THE EVENTS GO BELOW                      *)
(***********************************************************)
DEFINE_EVENT


BUTTON_EVENT[dvTP,Keyboard_Buttons]
{
    PUSH:
    {
	PULSE[vdvBB,GET_LAST(Keyboard_Buttons)]
    }
}

BUTTON_EVENT[dvTP,Screen_Left_Buttons]
{
    PUSH:
    {
	PULSE[dvRelay,Screen_Left_Channels[GET_LAST(Screen_Left_Buttons)]]
	WAIT(5)
	PULSE[dvRelay,Screen_Left_Channels[GET_LAST(Screen_Left_Buttons)]]
	//SYSTEM_CALL 'SCREEN1'(dvTP,Screen_Left_Buttons[1],Screen_Left_Buttons[2],0,dvRelay,Screen_Left_Channels[1],Screen_Left_Channels[2],0,0)
	//SCREEN1 (PANEL,UPB,DNB,STOPB,CARD,UPR,DNR,STOPR,FIRST)
    }
}

BUTTON_EVENT[dvTP,Screen_Right_Buttons]
{

    PUSH:
    {
	PULSE[dvRelay,Screen_Right_Channels[GET_LAST(Screen_Right_Buttons)]]
	WAIT(5)
	PULSE[dvRelay,Screen_Right_Channels[GET_LAST(Screen_Right_Buttons)]]
	//SYSTEM_CALL 'SCREEN1'(dvTP,Screen_Right_Buttons[1],Screen_Right_Buttons[2],0,dvRelay,Screen_Right_Channels[1],Screen_Right_Channels[2],0,0)
	//SCREEN1 (PANEL,UPB,DNB,STOPB,CARD,UPR,DNR,STOPR,FIRST)
    }
}

BUTTON_EVENT[dvTP,Volume_Buttons]
{
    
    PUSH:
    {
	SWITCH(GET_LAST(Volume_Buttons))
	{
	    CASE 1: //vol up
	    {
	    	IF(volume < max_volume)
		{
		    volume = volume + volume_step
		}
	    }
	    CASE 2: //vol down
	    {
		IF(volume > min_volume)
		{
		    volume = volume - volume_step
		}
	    }
	}
	SEND_LEVEL volumecard,volume
    }
    HOLD[1,REPEAT]:
    {
	SWITCH(GET_LAST(Volume_Buttons))
	{
	    CASE 1: //vol up
	    {
	    	IF(volume < max_volume)
		{
		    volume = volume + volume_step
		}
	    }
	    CASE 2: //vol down
	    {
		IF(volume > min_volume)
		{
		    volume = volume - volume_step
		}
	    }
	}
	SEND_LEVEL volumecard,volume
    }    
}

BUTTON_EVENT[dvTP,VCR_Buttons]
{

    PUSH:
    {
	SET_PULSE_TIME(2)
	SYSTEM_CALL 'VCR7'(dvVCR,dvTP,VCR_Buttons[1],VCR_Buttons[2],VCR_Buttons[3],VCR_Buttons[4],VCR_Buttons[5],0,0,0,0)
	SET_PULSE_TIME(5)
    }
}

BUTTON_EVENT[dvTP,DVD_Buttons]
{

    PUSH:
    {
	SET_PULSE_TIME(2)
	SYSTEM_CALL 'DVD1'(dvDVD,dvTP,DVD_Buttons[1],DVD_Buttons[2],DVD_Buttons[3],DVD_Buttons[4],DVD_Buttons[5],DVD_Buttons[6],DVD_Buttons[7],0)
	//DVD1 (DECK,PANEL,PLAYB,STOPB,PAUSEB,FFWDB,REWB,SFWDB,SREVB,FIRST)
	SET_PULSE_TIME(5)
    }
}

BUTTON_EVENT[dvTP,LProj_Power_Buttons]
{
    
    PUSH:
    {
	SWITCH(GET_LAST(LProj_Power_Buttons))
	{	//in NEC1065_f... Chan1 = on, Chan4 = off
	    CASE 1:
	    {
		PULSE[vdvLeftProj,1]
	    }
	    CASE 2:
	    {
		PULSE[vdvLeftProj,4]
	    }
	}
    }
}

BUTTON_EVENT[dvTP,RProj_Power_Buttons]
{

    PUSH:
    {
	SWITCH(GET_LAST(RProj_Power_Buttons))
	{	//in NEC1065_f... Chan1 = on, Chan4 = off
	    CASE 1://on button
	    {
		PULSE[vdvRightProj,1]
	    }
	    CASE 2://off button
	    {
		PULSE[vdvRightProj,4]
	    }
	}
    }
}

BUTTON_EVENT[dvTP,LProj_Mute_Buttons]
{	//in NEC1065_f... MuteOn = Chan5, Muteoff = Chan6
    PUSH:
    {
	PULSE[vdvLeftProj,GET_LAST(LProj_Mute_Buttons)+4]
    }
}

BUTTON_EVENT[dvTP,RProj_Mute_Buttons]
{

    PUSH:
    {
	PULSE[vdvRightProj,GET_LAST(RProj_Mute_Buttons)+4]
    }
}

BUTTON_EVENT[dvTP,LProj_Video_Buttons]
{
    PUSH:
    {
	PULSE[vdvLeftProj,GET_LAST(LProj_Video_Buttons)+6]
    }
}

BUTTON_EVENT[dvTP,RProj_Video_Buttons]
{
    PUSH:
    {
	PULSE[vdvRightProj,GET_LAST(RProj_Video_Buttons)+6]
    }
}


BUTTON_EVENT[dvTP,LeftProj_Source_Buttons]
{

    PUSH:
    {
	STACK_VAR INTEGER button_index
	STACK_VAR INTEGER button_pushed
	STACK_VAR CHAR vid_type[4] 
	
	button_index = GET_LAST(LeftProj_Source_Buttons)
	button_pushed = BUTTON.INPUT.CHANNEL
	vid_type = Extron_Video_Input_Type[button_index]
	
	IF(button_index==MacPriMon)
	    PULSE[vdvBB,2]
	IF(button_index==PcPriMon)
	    PULSE[vdvBB,1]
	    
	//turn on proj and screens down if not already on
	IF(![vdvLeftProj,101])
	{
	    SET_PULSE_TIME (10)
	    PULSE[vdvLeftProj,1]
	    PULSE[dvRelay,Screen_Left_Channels[2]]
	    WAIT(11)
		PULSE[dvRelay,Screen_Left_Channels[2]]
	    
	    SET_PULSE_TIME (5)
	}
	
	ON[vdvExtron,extron_input[button_index]]
	
	SWITCH(vid_type)
	{
	    CASE 'RGB':
	    {
		ON[vdvExtron,52]
		ON[vdvExtron,57]
		PULSE[vdvExtron,101]
		PULSE[vdvLeftProj,7]
	    }
	    CASE 'VID':
	    {
		ON[vdvExtron,56]
		PULSE[vdvExtron,101]
		PULSE[vdvLeftProj,9]
	    }
	    CASE 'SVID':
	    {
		ON[vdvExtron,54]
		PULSE[vdvExtron,101]
		PULSE[vdvLeftProj,10]
	    }
	}
	
	//tie to audio output 8 always
	ON[vdvExtron,extron_input[button_index]]
	ON[vdvExtron,58]
	PULSE[vdvExtron,104]
    }
}

BUTTON_EVENT[dvTP,RightProj_Source_Buttons]
{

    PUSH:
    {
	STACK_VAR INTEGER button_index
	STACK_VAR INTEGER button_pushed
	STACK_VAR CHAR vid_type[4] 
	
	button_index = GET_LAST(RightProj_Source_Buttons)
	button_pushed = BUTTON.INPUT.CHANNEL
	vid_type = Extron_Video_Input_Type[button_index]

	IF(button_index==MacPriMon)
	    PULSE[vdvBB,2]
	IF(button_index==PcPriMon)
	    PULSE[vdvBB,1]
	    
	//turn on proj and screens down if not already on
	IF(![vdvRightProj,101])
	{
	    SET_PULSE_TIME (10)
	    PULSE[vdvRightProj,1]
	    PULSE[dvRelay,Screen_Right_Channels[2]]
	    WAIT(11)
		PULSE[dvRelay,Screen_Right_Channels[2]]
	    SET_PULSE_TIME (5)
	}
	
	ON[vdvExtron,extron_input[button_index]]
	
	SWITCH(vid_type)
	{
	    CASE 'RGB':
	    {
		ON[vdvExtron,51]
		ON[vdvExtron,57]
		PULSE[vdvExtron,101]
		PULSE[vdvRightProj,7]
	    }
	    CASE 'VID':
	    {
		ON[vdvExtron,55]
		PULSE[vdvExtron,101]
		PULSE[vdvRightProj,9]
	    }
	    CASE 'SVID':
	    {
		ON[vdvExtron,53]
		PULSE[vdvExtron,101]
		PULSE[vdvRightProj,10]
	    }
	}
	//tie to audio output 8 always
	ON[vdvExtron,extron_input[button_index]]
	ON[vdvExtron,58]
	PULSE[vdvExtron,104]
    }
}




TIMELINE_EVENT[TL_FEEDBACK]
{
    [dvTP,Keyboard_Buttons[1]] = [vdvBB,101]
    [dvTP,Keyboard_Buttons[2]] = [vdvBB,102]

    [dvTP,LProj_Power_Buttons[1]] = [vdvLeftProj,101]
    [dvTP,LProj_Power_Buttons[2]] = ![vdvLeftProj,101]

    [dvTP,RProj_Power_Buttons[1]] = [vdvRightProj,101]
    [dvTP,RProj_Power_Buttons[2]] = ![vdvRightProj,101]
    
    
    [dvTP,LProj_Mute_Buttons[1]] = [vdvLeftProj,120]
    [dvTP,LProj_Mute_Buttons[2]] = ![vdvLeftProj,120]

    [dvTP,RProj_Mute_Buttons[1]] = [vdvRightProj,120]
    [dvTP,RProj_Mute_Buttons[2]] = ![vdvRightProj,120]
    
    [dvTP,LProj_Video_Buttons[1]] = [vdvLeftProj,107]
    [dvTP,LProj_Video_Buttons[2]] = [vdvLeftProj,108]
    [dvTP,LProj_Video_Buttons[3]] = [vdvLeftProj,109]
    [dvTP,LProj_Video_Buttons[4]] = [vdvLeftProj,110]
   
    [dvTP,RProj_Video_Buttons[1]] = [vdvRightProj,107]
    [dvTP,RProj_Video_Buttons[2]] = [vdvRightProj,108]
    [dvTP,RProj_Video_Buttons[3]] = [vdvRightProj,109]
    [dvTP,RProj_Video_Buttons[4]] = [vdvRightProj,110]   
}

BUTTON_EVENT[dvTP,Shutdown_Button]
{

    PUSH:
    {
	DO_PUSH(dvTP,LProj_Power_Buttons[2])
	DO_PUSH(dvTP,RProj_Power_Buttons[2])
    
	SET_PULSE_TIME (10)
	PULSE[dvRelay,Screen_Left_Channels[1]]
	PULSE[dvRelay,Screen_Right_Channels[1]]

	WAIT(11)
	{
	    PULSE[dvRelay,Screen_Left_Channels[1]]
	    PULSE[dvRelay,Screen_Right_Channels[1]]
	}
	SET_PULSE_TIME (5)	
	SEND_COMMAND dvTP,'@PPK-shutdown'
	PULSE[vdvExtron,127]
	SEND_STRING dvExtron,'0*7!'
    }
}
(***********************************************************)
(*            THE ACTUAL PROGRAM GOES BELOW                *)
(**********************************************************)
DEFINE_PROGRAM

(***********************************************************)
(*                     END OF PROGRAM                      *)
(*        DO NOT PUT ANY CODE BELOW THIS COMMENT           *)
(***********************************************************)

