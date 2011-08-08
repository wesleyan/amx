PROGRAM_NAME='TechPage'
(***********************************************************)
(* System Type : NetLinx                                   *)
(***********************************************************)
(* REV HISTORY:                                            *)
(***********************************************************)

(***********************************************************)
(*          DEVICE NUMBER DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_DEVICE
dv_Extron       = 5001:3:0	//Video Switcher - EXTRON 8/10 9600 N,8,1
vdv_Extron      = 33001:3:0	//Video Switcher Virtual Device

dv_Vol	       = 1107:1:0
dv_VCR          = 5001:8:0
dv_DVD          = 5001:9:0
dv_Relay        = 5001:7:0

dv_Tp           = 10011:1:0	//NXD-CV10 User
dvTp_tech      = 10011:2:0	//NXD-CV10 Tech

dv_ProjSide     = 5001:2:0	//Side Projector
vdv_ProjSide    = 33502:2:0	//Side Projector Virtual Device

dv_ProjCenter   = 5001:1:0	//Center Projector - NEC MT 38400 N,8,1 F
vdv_ProjCenter  = 33501:1:0	//Center Projector Virtual Device

(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT
//*********PROJECTOR CONSTANTS*********/
VOLATILE INTEGER ON_in_proj = 1
VOLATILE INTEGER OFF_in_proj = 4
//*****Feedback Timeline Constant******/
VOLATILE INTEGER TL1 = 100
(***********************************************************)
(*              DATA TYPE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_TYPE

(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE

VOLATILE INTEGER EXTRON_TP_Buttons[] = {1,2,3,4,5,6,7,8,9,10}
VOLATILE INTEGER EXTRON_MODULE_input_channels[] = {1,2,3,4,5,6,7,8,9,10}

VOLATILE INTEGER EXTRON_TP_BUTTONS_RGB_Mute[] = {11,12}
VOLATILE INTEGER EXTRON_MODULE_RGB_Mute[] = {31,32}

VOLATILE INTEGER EXTRON_TP_BUTTONS_Audio_Mute[] = {13,14}
VOLATILE INTEGER EXTRON_MODULE_Audio_Mute[] = {41,42}

VOLATILE INTEGER EXTRON_TP_BUTTONS_Center_Proj_Mute[] = {15,16}
VOLATILE INTEGER EXTRON_TP_BUTTONS_Side_Proj_Mute[] = {38,39}
VOLATILE INTEGER EXTRON_MODULE_Proj_Mute[] = {61,62}

VOLATILE INTEGER EXTRON_TP_BUTTONS_Center_Proj_Power[] = {17,18}
VOLATILE INTEGER EXTRON_TP_BUTTONS_Side_Proj_Power[] = {40,41}
VOLATILE INTEGER EXTRON_MODULE_Proj_Power[] = {71,72}

VOLATILE INTEGER EXTRON_TP_BUTTONS_Executive_Mode[] = {19,20}
VOLATILE INTEGER EXTRON_MODULE_Executive_Mode[] = {52,51}

VOLATILE INTEGER PROJ_TP_BUTTONS_ON_OFF_Center[] = {21,22,35,36} 
VOLATILE INTEGER PROJ_TP_BUTTONS_ON_OFF_Side[] = {71,72,85,86}   
VOLATILE INTEGER PROJ_MODULE_input_Channels_ON_OFF[] = {1,4,5,6}
VOLATILE INTEGER PROJ_Feedback_ON_OFF[] = {101,0,120,0} 

VOLATILE INTEGER PROJ_TP_BUTTONS_Video_Center[] = {23,24,25,26}
VOLATILE INTEGER PROJ_TP_BUTTONS_Video_Side[] = {73,74,75,76}
VOLATILE INTEGER PROJ_MODULE_input_Channels_Video[] = {7,8,9,10}
VOLATILE INTEGER PROJ_Feedback_Video[] = {107,108,109,110}

VOLATILE INTEGER PROJ_TP_BUTTONS_CC_Center[] = {27,28,29,30,31,32,33,34,37}
VOLATILE INTEGER PROJ_TP_BUTTONS_CC_Side[] = {77,78,79,80,81,82,83,84,87}
VOLATILE INTEGER PROJ_MODULE_input_Channels_CC[] = {31,32,33,34,35,36,37,38,30}
VOLATILE INTEGER PROJ_Feedback_CC[] = {191,192,193,194,195,196,197,198,190}

VOLATILE INTEGER VCR_TP_BUTTONS[] = {61,62,63,64,65,66}

VOLATILE INTEGER DVD_Buttons[] = {51,52,53,57,56,55,54}
VOLATILE INTEGER DVD_Pulse_Buttons[] = {1,2,3,4,5,6,7}
VOLATILE INTEGER DVD_Controls[] = {58,60,59,88,90,89}
VOLATILE INTEGER DVD_Pulse_Controls[] = {45,46,47,48,49,50}

VOLATILE LONG TL1_ar[1]
VOLATILE INTEGER current_control
VOLATILE INTEGER current_button
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
WAIT 10 
{
    TL1_ar[1] = 300
    TIMELINE_CREATE(TL1, TL1_ar, 1, TIMELINE_RELATIVE, TIMELINE_REPEAT)
}
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
//DEFINE_MODULE 'VideoSwitch_mod' ex1(dv_EXTRON, vdv_EXTRON)
//DEFINE_MODULE 'NEC1065_f' ptestCenter (dv_ProjCenter, vdv_ProjCenter)
//DEFINE_MODULE 'NEC1065_f' ptestSide (dv_ProjSide, vdv_ProjSide)
(***********************************************************)
(*                THE EVENTS GO BELOW                      *)
(***********************************************************)
DEFINE_EVENT

BUTTON_EVENT[dvTP_tech,EXTRON_TP_Buttons]  //button events refer to TPS only, so the device must be the touchpanel
{
    PUSH: 
    {		
	PULSE[vdv_EXTRON,EXTRON_MODULE_input_channels[GET_LAST(EXTRON_TP_Buttons)]]
    }
}

BUTTON_EVENT[dvTP_tech,EXTRON_TP_BUTTONS_RGB_Mute]
{
    PUSH:
    {
	PULSE[vdv_EXTRON,EXTRON_MODULE_RGB_Mute[GET_LAST(EXTRON_TP_BUTTONS_RGB_Mute)]]
    }
}
BUTTON_EVENT[dvTP_tech,EXTRON_TP_BUTTONS_Audio_Mute]
{
    PUSH:
    {
	PULSE[vdv_EXTRON,EXTRON_MODULE_Audio_Mute[GET_LAST(EXTRON_TP_BUTTONS_Audio_Mute)]]
    }
}
BUTTON_EVENT[dvTP_tech,EXTRON_TP_BUTTONS_Center_Proj_Mute]
{
    PUSH:
    {
	PULSE[vdv_EXTRON,EXTRON_MODULE_Proj_Mute[GET_LAST(EXTRON_TP_BUTTONS_Center_Proj_Mute)]]
    }
}
BUTTON_EVENT[dvTP_tech,EXTRON_TP_BUTTONS_Side_Proj_Mute]
{
    PUSH:
    {
	PULSE[vdv_EXTRON,EXTRON_MODULE_Proj_Mute[GET_LAST(EXTRON_TP_BUTTONS_Side_Proj_Mute)]]
    }
}
BUTTON_EVENT[dvTP_tech,EXTRON_TP_BUTTONS_Center_Proj_Power]
{
    PUSH:
    {
	PULSE[vdv_EXTRON,EXTRON_MODULE_Proj_Power[GET_LAST(EXTRON_TP_BUTTONS_Center_Proj_Power)]]
    }
}
BUTTON_EVENT[dvTP_tech,EXTRON_TP_BUTTONS_Side_Proj_Power]
{
    PUSH:
    {
	PULSE[vdv_EXTRON,EXTRON_MODULE_Proj_Power[GET_LAST(EXTRON_TP_BUTTONS_Side_Proj_Power)]]
    }
}
BUTTON_EVENT[dvTP_tech,EXTRON_TP_BUTTONS_Executive_Mode]
{
    PUSH:
    {
	PULSE[vdv_EXTRON,EXTRON_MODULE_Executive_Mode[GET_LAST(EXTRON_TP_BUTTONS_Executive_Mode)]]
    }
}
BUTTON_EVENT[dvTP_tech,PROJ_TP_BUTTONS_ON_OFF_Center]
{
    PUSH:
    {
	PULSE[vdv_ProjCenter,PROJ_MODULE_input_Channels_ON_OFF[GET_LAST(PROJ_TP_BUTTONS_ON_OFF_Center)]]
    }
}
BUTTON_EVENT[dvTP_tech, PROJ_TP_BUTTONS_Video_Center]
{
    PUSH:
    {
	PULSE[vdv_ProjCenter,PROJ_MODULE_input_Channels_Video[GET_LAST(PROJ_TP_BUTTONS_Video_Center)]]
    }
}
BUTTON_EVENT[dvTP_tech, PROJ_TP_BUTTONS_Video_Side]
{
    PUSH:
    {
	PULSE[vdv_ProjSide,PROJ_MODULE_input_Channels_Video[GET_LAST(PROJ_TP_BUTTONS_Video_Side)]]
    }
}
BUTTON_EVENT[dvTP_tech,PROJ_TP_BUTTONS_CC_Center]
{
    PUSH:
    {
	PULSE[vdv_ProjCenter,PROJ_MODULE_input_Channels_CC[GET_LAST(PROJ_TP_BUTTONS_CC_Center)]]
    }
}
BUTTON_EVENT[dvTP_tech,PROJ_TP_BUTTONS_CC_Side]
{
    PUSH:
    {
	PULSE[vdv_ProjSide,PROJ_MODULE_input_Channels_CC[GET_LAST(PROJ_TP_BUTTONS_CC_Side)]]
    }
}
BUTTON_EVENT[dvTP_tech,VCR_TP_BUTTONS]
{
    PUSH:
    {
	SYSTEM_CALL 'VCR2'(dv_VCR,dvTP_tech,61,63,62,65,64,0,0,0,0)
    }
}
BUTTON_EVENT[dvTp_tech,DVD_Buttons]	
{
    PUSH:
    {
	current_button = GET_LAST(DVD_Buttons)
	TO[dvTp_tech,current_button]
	PULSE[dv_DVD,DVD_Pulse_Buttons[GET_LAST(DVD_Buttons)]]
    }
}
BUTTON_EVENT[dvTp_tech,DVD_Controls]
{
    PUSH:
    {
	current_control = GET_LAST(DVD_Controls)
	TO[dvTp_tech,current_control]
	PULSE[dv_DVD,DVD_Pulse_Controls[GET_LAST(DVD_Controls)]]
    }
}
TIMELINE_EVENT[TL1]

    {
	STACK_VAR cnt;
	FOR(cnt = 1;cnt <= 10; cnt++)
	{ [dvTP_tech,cnt] = [vdv_EXTRON,cnt+120]}

    [dvTP_tech, 11] = ![vdv_EXTRON,131]
    [dvTP_tech, 12] = [vdv_EXTRON,131]
    [dvTP_tech, 13] = ![vdv_EXTRON, 141]
    [dvTP_tech, 14] = [vdv_EXTRON, 141]
    [dvTP_tech, 15] = ![vdv_EXTRON, 161]
    [dvTP_tech, 16] = [vdv_EXTRON, 161]
    [dvTP_tech, 17] = ![vdv_EXTRON, 171]
    [dvTP_tech, 18] = [vdv_EXTRON, 171]
    [dvTP_tech, 19] = ![vdv_EXTRON, 151]
    [dvTP_tech, 20] = [vdv_EXTRON, 151]

//********Feedback for Projector Tech Page*********/

{
	STACK_VAR cnt1;
	FOR(cnt1 = 1;cnt1 <= MAX_LENGTH_ARRAY(PROJ_TP_BUTTONS_Video_Center);cnt1++)
	{ [dvTP_tech, PROJ_TP_BUTTONS_Video_Center[cnt1]] = [vdv_ProjCenter, PROJ_Feedback_Video[cnt1]]}
}
{
	STACK_VAR cnt2;
	FOR(cnt2 = 1;cnt2 <= MAX_LENGTH_ARRAY(PROJ_TP_BUTTONS_Video_Side);cnt2++)
	{ [dvTP_tech, PROJ_TP_BUTTONS_Video_Side[cnt2]] = [vdv_ProjSide, PROJ_Feedback_Video[cnt2]]}
}
{
    [dvTP_tech, 21] = [vdv_ProjCenter,PROJ_Feedback_ON_OFF[1]]
    [dvTP_tech, 22] = ![vdv_ProjCenter,PROJ_Feedback_ON_OFF[1]]
    [dvTP_tech, 35] = [vdv_ProjCenter, PROJ_Feedback_ON_OFF[3]]
    [dvTP_tech, 36] = ![vdv_ProjCenter, PROJ_Feedback_ON_OFF[3]]
    [dvTP_tech, 37] = [vdv_ProjCenter, 190]
    
    [dvTP_tech, 71] = [vdv_ProjSide,PROJ_Feedback_ON_OFF[1]]
    [dvTP_tech, 72] = ![vdv_ProjSide,PROJ_Feedback_ON_OFF[1]]
    [dvTP_tech, 85] = [vdv_ProjSide, PROJ_Feedback_ON_OFF[3]]
    [dvTP_tech, 86] = ![vdv_ProjSide, PROJ_Feedback_ON_OFF[3]]
    [dvTP_tech, 87] = [vdv_ProjSide, 190]
}
/*
{  
	STACK_VAR cnt1;
	FOR(cnt1 = 1;cnt1 <= max_length_array(PROJ_TP_BUTTONS_ON_OFF[]);cnt1++)
	{ [dvTP_tech, PROJ_TP_BUTTONS_ON_OFF[cnt1]] = [vdvProj, PROJ_Feedback_ON_OFF[cnt1]]}

}
*/

{
	STACK_VAR cnt3;
	FOR(cnt3 = 1;cnt3 <=MAX_LENGTH_ARRAY(PROJ_TP_BUTTONS_CC_Side);cnt3++)
	{ [dvTP_tech, PROJ_TP_BUTTONS_CC_Center[cnt3]] = [vdv_ProjCenter, PROJ_Feedback_CC[cnt3]]}
}
{
	STACK_VAR cnt4;
	FOR(cnt4 = 1;cnt4 <=MAX_LENGTH_ARRAY(PROJ_TP_BUTTONS_CC_Side);cnt4++)
	{ [dvTP_tech, PROJ_TP_BUTTONS_CC_Side[cnt4]] = [vdv_ProjSide, PROJ_Feedback_CC[cnt4]]}
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

