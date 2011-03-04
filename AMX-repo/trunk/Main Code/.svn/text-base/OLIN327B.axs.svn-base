PROGRAM_NAME='ModeroDanceEast'
(***********************************************************)
(* System Type : NetLinx                                   *)
(***********************************************************)
(* REV HISTORY:                                            *)
(***********************************************************)
/* Modifications made for OLIN327b
 *
 *
 */

//This is the base Modero Source Code for Generation 4 rooms.
//This file relies on the folowing modules:
//DataSwitch_mod
//DVD-DNV300
//NEC1065_f-Note: There are two NEC1065_f modules.
//VideoSwitch_mod
//IR Files required:SamsungSV500W VCR
/* Change Log: 
This is the base Modero touchpanel. The touchpanel file 
has been revamped from the original design to make the buttons "bigger".
There are two forks for this code- as of 1-20-06.



*/
(***********************************************************)
(*          DEVICE NUMBER DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_DEVICE
dv_relay    =5001:8:0
dv_tp7500   =10011:1:0

dv_extron   =5001:1:0			//System 8 plus	
//dv_proj1    =5001:2:0
dv_proj2    =5001:4:0

//extron virtual devs
vdvVSMod = 33001:1:0

/*  Using old System8 extron.
vdvGainMod = 33001:2:0
vdvTrebleMod = 33001:3:0
vdvBassMod = 33001:4:0
vdvVolumeMod = 33001:5:0
*/
//projector virtual devs
vdv_proj1   =33002:1:0
vdv_proj2   =33004:1:0

dvDVD           = 5001:9:0       // DVD PLAYER
vdv_dvd     =33005:5:0
dvVolume      =150:1:0			//not controlled by extron
dv_vcr	    =5001:8:0

dv_switch   =5001:3:0
vdv_switch  =33003:3:0
(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT

VOLATILE INTEGER VSMod_Volume_chn_fb[] = //0% - 100%
{
125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,145,146,147,148,
149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,166,167,168,169,170,171,172,173,174,
175,176,177,178,179,180,181,182,183,184,185,186,187,188,189,190,191,192,193,194,195,196,197,198,199,200,201,
202,203,204,205,206,207,208,209,210,211,212,213,214,215,216,217,218,219,220,221,222,223,224,225
}

VOLATILE INTEGER SourceButton[]=
{
    1, //PC
    2, //MAC
    3, //DVD
    4, //VCR
    5, //AUX lap
    6,  //AUX vid
    //No more channel space, using smallest available channel numbers
    39,	//Rack Vid
    40	//MyCad
} 

VOLATILE INTEGER extron_source_inputs[] =  //device input configuration of the extron in the room
{
    1,	//pc
    2,	//Mac
    3,	//dvd
    4,	//vcr
    6,  //aux lap
    7,  //aux vid
    5,	//rack vid
    8	//Mycad, not sure what this is.
}

//Correspond to types for extron_source_inputs
VOLATILE CHAR extron_source_inputs_type[8][4]=
{
    'RGB',
    'RGB',
    'SVID',
    'VID',
    'RGB',
    'SVID',
    'SVID',
    'SVID'
}

VOLATILE INTEGER extron_video_fb_chn[] = //axi
{
    111,
    112,
    113,
    114,
    115,
    116,
    117,
    118
}

(*
    SourceButton[] corresponds to the following media sources:
    SourceButton[1]= PC
    SourceButton[2]= Mac
    SourceButton[3]= DVD
    SourceButton[4]= VCR
    SourceButton[5]= Aux Laptop
    SourceButton[6]= Aux Video
    SourceButton[7]= Rack Vid
    SourceButton[8]= MyCad
*)

VOLATILE INTEGER source_pc = 1
VOLATILE INTEGER source_dvd = 3
VOLATILE INTEGER source_vcr = 4
VOLATILE INTEGER source_auxvid = 7
VOLATILE INTEGER source_auxlap = 6


/************** DVD Transport Channels ******************/
//  G4 dvd ppage buttons numerically match Denon RS232 module input channels

VOLATILE INTEGER transport_inputs[]=	//****NC****
{
    14,//Play
    15,//PAUSE
    16,//Stop
    17,//FF
    18,//REW
    38,//skip fwd
    37 //skip rev
}

VOLATILE INTEGER TP_TO_DVD_NAV[] =
{
    45, //UP
    47,	//LEFT
    44,	//MENU
    48,	//RIGHT
    46,	//DOWN
    49	//ENTER
}


VOLATILE INTEGER DVD_MENU_NAV[] =    //menu nav TP buttons //NC****
{
    7,  //UP
    8,  //LEFT	
    9,  //MENU	
    10, //RIGHT
    11, //DOWN
    12  //ENTER
    //13  //EJECT		//removed as of rev 1
}

(* VCR TRANSPORT CONTROLS *)

VCR_PLAY        = 14
VCR_STOP        = 16
VCR_PAUSE       = 15
VCR_FFWD        = 17
VCR_REW         = 18
VCR_SFWD        = 38
VCR_SREV        = 37
VCR_REC         = 47

VOLATILE INTEGER VCR_TRANSPORT_BUTTONS[] =
{
	VCR_PLAY,      
	VCR_STOP,       
	VCR_PAUSE,      
	VCR_FFWD,       
	VCR_REW,        
	VCR_SFWD,       
	VCR_SREV,       
	VCR_REC        
}


(* DVD TRANSPORT CONTROL BUTTONS *)

DVD_PLAY        = 14
DVD_STOP        = 16
DVD_PAUSE       = 15
DVD_FSCAN       = 17
DVD_RSCAN       = 18
DVD_FSKIP       = 38
DVD_RSKIP       = 37
/*
DVD_MENU        = 70
DVD_ENTER       = 71
DVD_UP          = 72
DVD_DOWN        = 73
DVD_LEFT        = 74
DVD_RIGHT       = 75
*/

VOLATILE INTEGER DVD_TRANSPORT_BUTTONS[] =
{
	DVD_PLAY,
	DVD_STOP,
	DVD_PAUSE,      
	DVD_FSCAN,       
	DVD_RSCAN,
	DVD_FSKIP, 
	DVD_RSKIP
}


(**************************PROJECTOR CONSTANTS ****************************)
//****NC****
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
//Controls for intput sources on the projector.
VOLATILE INTEGER RGB1_in = 7
VOLATILE INTEGER RGB2_in = 8
VOLATILE INTEGER VID_in = 9
VOLATILE INTEGER SVID_in = 10
VOLATILE INTEGER DIG_in = 11
VOLATILE INTEGER VIEWER_in = 12
VOLATILE INTEGER COMP_in = 13
VOLATILE INTEGER LAN_in = 14
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
VOLATILE INTEGER tp_projector_status_button[]=
{
    1,//ON
    2,//COOLING
    3,//Muted
    4 //OFF
}



//INPUT SOURCES feedback
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

(********************************* EXTRON CONSTANTS *******************************)

//CHANGE MOST - CONSIDER AXI
VOLATILE INTEGER extron_input_channels[] = 
{
  1,2,3,4,5,6,7,8,9,10,   //all
  11,12,13,14,15,16,17,18,19,20,   //audio
  21,22,23,24,25,26,27,28,29,30    //video   
}

VOLATILE INTEGER extron_feedback_channels[] = 
{
  111,112,113,114,115,116,117,118,119,120
}


(************************************ VOLUME CONSTANTS ****************************)
//****CHANGE****
VOLATILE INTEGER VOLUME_STEP = 20
//VOLATILE DEVCHAN FB_AUD_MUTE = {vdvVolumeMod,230}


(************************************ TIMELINES ****************************)

VOLATILE LONG TL_FEEDBACK = 1

(***********************************************************)
(*              DATA TYPE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_TYPE

(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE
INTEGER vmax
INTEGER vmaxset
INTEGER CurrentSource = 0
INTEGER i=0

//****CHANGE?****
VOLATILE INTEGER VOL_LVL	//hold dvVolume Level
VOLATILE INTEGER volume_level=0
VOLATILE INTEGER prev_volume_level = 0
VOLATILE VOLUME_MAX = 150 - VOLUME_STEP
VOLATILE VOLUME_MIN = VOLUME_STEP

VOLATILE LONG tl_feedback_ar[1] //init TL_FEEDBACK interval (ms)
CHAR charProjectorStatsXMLString[5000]


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
DEFINE_FUNCTION INTEGER level_to_extron_volume(INTEGER amxval)
{

    STACK_VAR FLOAT floatconvert 
    STACK_VAR INTEGER decimalplace
    STACK_VAR INTEGER myrounded
    
    floatconvert = amxval*vmax/255
    decimalplace = FIND_STRING( FTOA(floatconvert) ,'.',1)

    IF(decimalplace)
	myrounded = ATOI(LEFT_STRING( FTOA(floatconvert), decimalplace))
    ELSE
	myrounded = ATOI( FTOA(floatconvert) ) 

    send_string 0, "'AMX = ', ITOA(amxval),'. Set Extron volume to ',ITOA(myrounded)"
    
    RETURN myrounded


}

DEFINE_FUNCTION INTEGER extron_volume_to_level(INTEGER exval)
{

    STACK_VAR FLOAT floatconvert 
    STACK_VAR INTEGER decimalplace
    STACK_VAR INTEGER myrounded
    
    floatconvert = exval*255/vmax
    decimalplace = FIND_STRING( FTOA(floatconvert) ,'.',1)

    IF(decimalplace)
	myrounded = ATOI(LEFT_STRING( FTOA(floatconvert), decimalplace))
    ELSE
	myrounded = ATOI( FTOA(floatconvert) ) 

    send_string 0, "'Extron = ', ITOA(exval),'. Set AMX Level to ',ITOA(myrounded)"
    
    RETURN myrounded


}
(***********************************************************)
(*                STARTUP CODE GOES BELOW                  *)
(***********************************************************)
DEFINE_START
//Volume level creation to control audio level on the touchpanel and interface 
//with the card device.

CREATE_LEVEL dvVolume,1,VOL_LVL

//vmax = 50
//vmaxset=vmax

WAIT 300{
tl_feedback_ar[1] = 250
TIMELINE_CREATE(TL_FEEDBACK,tl_feedback_ar,1,TIMELINE_RELATIVE,TIMELINE_REPEAT)
}

DEFINE_MODULE 'VideoSwitch_mod' ex1(dv_Extron,vdvVSMod)
//DEFINE_MODULE 'MLS506MA_modrevAnnie' vs1 (dv_extron,vdvVSMod,vdvGainMod,vdvTrebleMod,vdvBassMod,vdvVolumeMod) //Extron 506 Module
DEFINE_MODULE 'NEC1065_Qmodule_rev' prmod1 (dv_proj2,vdv_proj2, charProjectorStatsXMLString) //Projector #2 Module
//DEFINE_MODULE 'DenonDVD-DNV300' dvd1 (dv_dvd,vdv_dvd) //DVD control module-no feedback channels implemented yet.


(***********************************************************)
(*                THE EVENTS GO BELOW                      *)
(***********************************************************)
DEFINE_EVENT
BUTTON_EVENT[dv_tp7500,SourceButton]// Sources
{
    PUSH:
    {				

	  PULSE[vdvVSMod,extron_source_inputs[GET_LAST(SourceButton)]]
	  CurrentSource = extron_source_inputs[GET_LAST(SourceButton)]
	
	  SEND_STRING 0, "'cs = ',ITOA(CurrentSource),'. I will switch proj to ',extron_source_inputs_type[GET_LAST(SourceButton)]"

	  //catch composite video sources
	  If(extron_source_inputs_type[GET_LAST(SourceButton)] == 'SVID')
	  { 
	    PULSE[vdv_proj2,SVID_in]
	    If((CurrentSource == SourceButton[3]))
	    {
		  For(i=14; i <= 18; i++)//Clears the playback transport buttons
		  {
		    [dv_tp7500,i] = 0
		  }
	    }
	    SEND_COMMAND dv_tp7500,'^SHO-7,1'
	  }
	  ELSE IF(extron_source_inputs_type[GET_LAST(SourceButton)] == 'VID')
	  { 
	    PULSE[vdv_proj2,VID_in]
	    If((CurrentSource == SourceButton[4]))
	    {
		  For(i=14; i <= 18; i++)//Clears the playback transport buttons
		  {
		    [dv_tp7500,i] = 0
		  }
	    }
	    SEND_COMMAND dv_tp7500,'^SHO-7,1'
	  }
	  ELSE //assume RGB source
	  {
	    PULSE[vdv_proj2,RGB1_in]
	    SEND_COMMAND dv_tp7500,'^SHO-7,0'
	  }
    }
}


BUTTON_EVENT[dv_tp7500,24]//SHUTDOWN BUTTON		//****NC?****
{
    PUSH:
    {
	SEND_COMMAND dv_tp7500,"'^SHO-5,0'"
	SEND_COMMAND dv_tp7500,"'^SHO-6,0'"
	If([vdv_proj2,On_fb])
	{
	    WAIT 10
	    {
		PULSE[vdv_proj2,OFF_in]
	    }
	    SEND_COMMAND dv_tp7500,"'^ANI-3,2,2'"
	    
	    WAIT 1000
	    {
		WAIT_UNTIL(NOT([vdv_proj2,COOLING_fb]))
		{
		    SEND_COMMAND dv_tp7500,"'^ANI-3,3,3'"
		
		    WAIT 50
		    {
			SEND_COMMAND dv_tp7500,"'^ANI-3,1,1'"
			SEND_COMMAND dv_tp7500,"'^SHO-5,1'"
			SEND_COMMAND dv_tp7500,"'^SHO-6,1'"
			SEND_COMMAND dv_tp7500,"'@PPK-Shutdown Confirm'"	    
			SEND_COMMAND dv_tp7500,"'PAGE-Wesleyan University Page'"
		    }
		}
	    }
	}
	ELSE
	{
	    SEND_COMMAND dv_tp7500,"'^ANI-3,3,3'"
		
		WAIT 50
		{
		    SEND_COMMAND dv_tp7500,"'^SHO-5,1'"
		    SEND_COMMAND dv_tp7500,"'^SHO-6,1'"
		    SEND_COMMAND dv_tp7500,"'^ANI-3,1,1'"
		    SEND_COMMAND dv_tp7500,"'@PPK-Shutdown Confirm'"	    
		    SEND_COMMAND dv_tp7500,"'PAGE-Wesleyan University Page'"
		    
		}
	
	}
    }

}
BUTTON_EVENT[dv_tp7500,25] //Projector On		//****NC****
{
    PUSH:
    {
	PULSE[vdv_proj2,ON_in]
	OFF[vdv_proj2,50]
	IF(NOT([vdv_proj2,ON_fb]))
	{
	    SEND_COMMAND dv_tp7500,"'^ANI-2,5,5'"
	
	    WAIT 200
	    {
		ON[vdv_proj2,50]
	    }
	}
    }
}

BUTTON_EVENT[dv_tp7500,26] // Projector Off		//****NC****
{
    PUSH:
    {
	PULSE[vdv_proj2,OFF_in]

	
    }
}
BUTTON_EVENT[dv_tp7500,27] //Video Mute Button		//****NC****
{
    PUSH:
    {
	If([vdv_proj2,120])
	{
	    PULSE[vdv_proj2,MUTEOFF_in]
	   
	}
	Else
	{
	   PULSE[vdv_proj2,MUTEON_in]
	}
    }
}


BUTTON_EVENT[dv_tp7500,DVD_MENU_NAV]//IR DVD Menu Navigation Controls   //NC****
{
    PUSH: 
    {
	PULSE[dvDVD,TP_TO_DVD_NAV[GET_LAST(DVD_MENU_NAV)]]
	TO [dv_tp7500,BUTTON.INPUT.CHANNEL]
    }
}

BUTTON_EVENT[dv_tp7500,transport_inputs]//DVD/VCR Naigation inputs.		//****NC****
{
    PUSH:
    {
    	SWITCH(CurrentSource)
	{
	    CASE source_dvd:
	    {
	    
		SYSTEM_CALL[1] 'DVD1' (dvDVD,dv_tp7500,DVD_PLAY,DVD_STOP,DVD_PAUSE,DVD_FSKIP,DVD_RSKIP,DVD_FSCAN,DVD_RSCAN ,0)
		//PULSE[vdv_dvd,(GET_LAST(transport_inputs)+13)]
		// VCR/DVD transport and DVD Menu Control feedback
		//TO [dv_tp7500,BUTTON.INPUT.CHANNEL]
	    }
	    CASE source_vcr:
	    {
		SYSTEM_CALL 'VCR1'(dv_vcr,dv_tp7500,14,16,15,17,18,0,0,0,0)
		//Note: TO is not needed here because SYS_CALL handles the feedback on the buttons.
	    }
	}
	
	(*
	If(CurrentSource == 3)
	{
	    PULSE[vdv_dvd,(GET_LAST(transport_inputs)+13)]
	   // VCR/DVD transport and DVD Menu Control feedback
	    TO [dv_tp7500,BUTTON.INPUT.CHANNEL]
	
	}
	Else
	{
	    SYSTEM_CALL 'VCR1'(dv_vcr,dv_tp7500,14,16,15,17,18,0,0,0,0)
	    //Note: TO is not needed here because SYS_CALL handles the feedback on the buttons.
	}
	*)
	

    }
    
}
/*
BUTTON_EVENT[dv_tp7500,30] //Volume Up
{
    PUSH:
    {
		TO[dv_tp7500,30]
		IF(volume_level < VOLUME_MAX)
		{
			volume_level = volume_level + VOLUME_STEP
		}
		ELSE
		{
			volume_level = 255
		}
		PULSE[vdvVolumeMod,level_to_extron_volume(volume_level)+1]
	}
  HOLD[5,REPEAT]:
  {
		IF(volume_level < VOLUME_MAX)
		{
			volume_level = volume_level + VOLUME_STEP
		}
		ELSE
		{
			volume_level = 255
		}
		PULSE[vdvVolumeMod,level_to_extron_volume(volume_level)+1]
  }
}
*/
/*
BUTTON_EVENT[dv_tp7500,31] //Volume Down
{
	PUSH:
	{
		TO[dv_tp7500,31]
		IF(volume_level > VOLUME_MIN)
		{
			volume_level = volume_level - VOLUME_STEP
		}
		ELSE
		{
				volume_level = 0
		}
		PULSE[vdvVolumeMod,level_to_extron_volume(volume_level)+1]
	}
	HOLD[5,REPEAT]:
	{
		IF(volume_level > VOLUME_MIN)
		{
			volume_level = volume_level - VOLUME_STEP
		}
		ELSE
		{
			volume_level = 0
		}
		PULSE[vdvVolumeMod,level_to_extron_volume(volume_level)+1]
	}
}
*/
/*
BUTTON_EVENT[dv_tp7500,32] //Volume Mute
{
	PUSH:
	{
		//NOTE: For Revision 2, I may want to go back and put in a 
		//second level so that I can combine the two levels, then separate them
		//when the mute button is pressed so that you can manipulate the audio level free
		//of the mute.
	
		IF([vdvVolumeMod,230])   //audio mute 
		{
			PULSE[vdvVolumeMod,106]  //mute audio
		}
		ELSE
		{
			PULSE[vdvVolumeMod,105]  //unmute audio
		}
	}
}
*/
BUTTON_EVENT[dv_tp7500,34] // Video Fill Button		//****NC****
{
    RELEASE:
    {
	SEND_COMMAND dv_tp7500,"'PAGE-Full Screen Video'"
    }
}
BUTTON_EVENT[dv_tp7500,35] // Exit Full Screen Video	//****NC****
{
    PUSH:
    {
	SEND_COMMAND dv_tp7500,"'PAGE-Main Page'"
    }
}

TIMELINE_EVENT[TL_FEEDBACK]
{

	[dv_tp7500,1] = [vdvVSMod,111]
	[dv_tp7500,2] = [vdvVSMod,112]
	[dv_tp7500,3] = [vdvVSMod,113]
	[dv_tp7500,4] = [vdvVSMod,114]
	[dv_tp7500,5] = [vdvVSMod,116]
	[dv_tp7500,6] = [vdvVSMod,117]
	[dv_tp7500,39] = [vdvVSMod,115]
	[dv_tp7500,40] = [vdvVSMod,118]

//	[dv_tp7500,32]= [vdvVolumeMod,230]
  
	//Check status of Video Mute button
    
    [dv_tp7500,27]=[vdv_proj2,MUTE_fb]
    
    //Projector Status Monitoring
    //This set of IF-ELSE statements checks to see the status of the projector.
    //Note that for the Proxima series projectors, this monitoring will only tell us the "ON"
    //and "OFF" status of the projectors- we may have to use a "WAIT" to simulate the cool-down phase.
    
    //****NC****
    IF([vdv_proj2,On_fb] && NOT([vdv_proj2,MUTE_fb]) && NOT([vdv_proj2,COOLING_fb]))
    {
      SEND_COMMAND dv_tp7500,"'^ANI-2,1,1'"//Animate Variable Text 2 from state 1-1, 1=ON
    }
    ELSE IF([vdv_proj2,COOLING_fb])
    {
	SEND_COMMAND dv_tp7500,"'^ANI-2,2,2'" //Animate Variable Text 2 from state 2-2
    }
    ELSE IF([vdv_proj2,MUTE_fb])
    {
	SEND_COMMAND dv_tp7500,"'^ANI-2,3,3'"//Animate Variable Text 2 from state 3-3
    }
    ELSE IF([vdv_proj2,50])
    {
	
	SEND_COMMAND dv_tp7500,"'^ANI-2,4,4'"//the "off" state
    }
    ELSE
    {
	;//do nothing-used to keep the "warm up" cycle on.
    }
    
    
}
CHANNEL_EVENT[dv_relay,9]
{
    ON:
    {
    vmax = 100
    }
    OFF:
    {
    vmax = vmaxset
    }
}
/*
CHANNEL_EVENT[vdvVolumeMod,VSMod_Volume_chn_fb]//real time feedback for extron volume display on bargraph
{
    ON:
    {
	STACK_VAR INTEGER activevolume
	activevolume = GET_LAST(VSMod_Volume_chn_fb) - 1 
	IF (activevolume >= (vmax))
	{
	    PULSE[vdvVolumeMod,vmax]
	}
	SEND_LEVEL dv_tp7500,3,extron_volume_to_level(activevolume)
	send_string 0,"'VOlume is now ', ITOA(extron_volume_to_level(activevolume))"
	SEND_LEVEL dv_tp7500,3,extron_volume_to_level(activevolume)
    }
}
*/

// Following 1 is code ported from FINALnewtest
DATA_EVENT[dvDVD]
{
  ONLINE:
  {
    WAIT 30
    {
      SEND_COMMAND dvDVD,"'SET MODE IR'" 
      SEND_COMMAND dvDVD,"'CARON'"
    }
  }
}
(***********************************************************)
(*            THE ACTUAL PROGRAM GOES BELOW                *)
(***********************************************************)
DEFINE_PROGRAM
(* VOLUME CONTROLS *)

SYSTEM_CALL 'VOL1' (dv_tp7500,30,31,32,dvVOLUME,1,2,3)
//SEND_LEVEL dv_tp7500,3,extron_volume_to_level(VOL_LVL)
SEND_LEVEL dv_tp7500,3,VOL_LVL

(***********************************************************)
(*                     END OF PROGRAM                      *)
(*        DO NOT PUT ANY CODE BELOW THIS COMMENT           *)
(***********************************************************)