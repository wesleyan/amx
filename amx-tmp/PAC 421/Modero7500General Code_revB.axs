PROGRAM_NAME='Modero7500GeneralCode_revB'
(***********************************************************)
(* System Type : NetLinx                                   *)
(***********************************************************)
(* REV HISTORY:                                            *)
(***********************************************************)
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
dv_extron   =5001:1:0
dv_blackbox =5001:3:0
dv_proj1    =5001:2:0
dv_proj2    =5001:4:0
vdv_extron  =33001:1:0
vdv_blackbox=33001:3:0
vdv_proj1   =33001:2:0
vdv_proj2   =33001:4:0
dv_dvd      =5001:5:0
vdv_dvd     =33001:5:0
volume      =150:1:0
dv_vcr	    =5001:9:0
dv_switch   =5001:3:0
vdv_switch  =33001:3:0
(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT
VOLATILE INTEGER SourceButton[]= {1,2,3,4,5,6} 

(*
    SourceButton[] corresponds to the following media sources:
    SourceButton[1]= PC
    SourceButton[2]= Mac
    SourceButton[3]= DVD
    SourceButton[4]= VCR
    SourceButton[5]= Aux Laptop
    SourceButton[6]= Document Camera
*)

VOLATILE INTEGER source_pc = 1
VOLATILE INTEGER source_mac = 2
VOLATILE INTEGER source_dvd = 3
VOLATILE INTEGER source_vcr = 4
VOLATILE INTEGER source_auxlap = 5

VOLATILE INTEGER SrcButtonLookup[] = { 
  source_pc,
  source_mac,
  source_dvd,
  source_vcr,
  source_auxlap,
  0
  }

/************** DVD Transport Channels ******************/
//  G4 dvd ppage buttons numerically match Denon RS232 module input channels

VOLATILE INTEGER transport_inputs[]=
{
    14,//Play
    15,//PAUSE
    16,//Stop
    17,//FF
    18,//REW
    38,//skip fwd
    37 //skip rev
    
}

VOLATILE INTEGER DVD_MENU_NAV[] =    //menu nav TP buttons
{
    7,  //UP
    8,  //LEFT	
    9,  //MENU	
    10, //RIGHT
    11, //DOWN
    12  //ENTER
    //13  //EJECT		//removed as of rev 1
}



(**************************PROJECTOR CONSTANTS ****************************)

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

VOLATILE INTEGER VOLUME_STEP = 5

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

INTEGER CurrentSource = 0
INTEGER i=0
VOLATILE INTEGER volume_level=0
VOLATILE INTEGER prev_volume_level = 0
VOLATILE VOLUME_MAX = 255 - VOLUME_STEP
VOLATILE VOLUME_MIN = VOLUME_STEP

VOLATILE LONG tl_feedback_ar[1] //init TL_FEEDBACK interval (ms)

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
//Volume level creation to control audio level on the touchpanel and interface 
//with the card device.

CREATE_LEVEL volume,1,volume_level

WAIT 300{
tl_feedback_ar[1] = 250
TIMELINE_CREATE(TL_FEEDBACK,tl_feedback_ar,1,TIMELINE_RELATIVE,TIMELINE_REPEAT)
}

DEFINE_MODULE 'VideoSwitch_mod' vs1 (dv_extron,vdv_extron) //Extron Module
// NOT WORKING!!! DEFINE_MODULE 'NEC1065_f' pr1 (dv_proj2,vdv_proj2)
DEFINE_MODULE 'NEC1065_f' prmod1 (dv_proj2,vdv_proj2) //Projector #2 Module
DEFINE_MODULE 'DVD-DNV300' dvd1	 (dv_dvd,vdv_dvd) //DVD control module-no feedback channels implemented yet.
//DEFINE_MODULE 'DataSwitch_mod' km1 (dv_switch,vdv_switch) //KVM Switcher Module

(***********************************************************)
(*                THE EVENTS GO BELOW                      *)
(***********************************************************)
DEFINE_EVENT
BUTTON_EVENT[dv_tp7500,SourceButton]// Sources
{
    PUSH:
    {
	//switch extron input
		PULSE[vdv_extron,extron_input_channels[SrcButtonLookup[GET_LAST(SourceButton)]]]
	
	//store extron input number in variable
	CurrentSource = GET_LAST(SourceButton)
	
	//catch composite video sources
	If((CurrentSource == SourceButton[3]) || (CurrentSource == SourceButton[4]))
	{
	    PULSE[vdv_proj2,VID_in]
	    If((CurrentSource == SourceButton[3]))
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
	
	//handle KVM switching - DEPRICATE!
	IF(CurrentSource == 1)
	{
	    PULSE[vdv_switch,1]
	}
	IF(CurrentSource == 2)
	{
	    PULSE[vdv_switch,2]
	}
    }
}


BUTTON_EVENT[dv_tp7500,24]//SHUTDOWN BUTTON
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
BUTTON_EVENT[dv_tp7500,25] //Projector On
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

BUTTON_EVENT[dv_tp7500,26] // Projector Off
{
    PUSH:
    {
	PULSE[vdv_proj2,OFF_in]

	
    }
}
BUTTON_EVENT[dv_tp7500,27] //Video Mute Button
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


BUTTON_EVENT[dv_tp7500,DVD_MENU_NAV]//RS232 DVD Menu Navigation Controls
{
    PUSH: 
    {
	PULSE[vdv_dvd,(GET_LAST(DVD_MENU_NAV)+6)]   //6 is the index offset
	TO [dv_tp7500,BUTTON.INPUT.CHANNEL]
    }
}

BUTTON_EVENT[dv_tp7500,transport_inputs]//DVD/VCR Naigation inputs.
{
    PUSH:
    {
    	SWITCH(CurrentSource)
	{
	    CASE source_dvd:
	    {
		PULSE[vdv_dvd,(GET_LAST(transport_inputs)+13)]
		// VCR/DVD transport and DVD Menu Control feedback
		TO [dv_tp7500,BUTTON.INPUT.CHANNEL]
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
    }
    HOLD[1,REPEAT]:
    {
	IF(volume_level < VOLUME_MAX)
	{
	    volume_level = volume_level + VOLUME_STEP
	}
	ELSE
	{
	    volume_level = 255
	}
    }
}
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
    }
    HOLD[1,REPEAT]:
    {
	IF(volume_level > VOLUME_MIN)
	{
	    volume_level = volume_level - VOLUME_STEP
	}
	ELSE
	{
	    volume_level = 0
	}
    }
}

BUTTON_EVENT[dv_tp7500,32] //Volume Mute
{
    PUSH:
    {
	//NOTE: For Revision 2, I may want to go back and put in a 
	//second level so that I can combine the two levels, then separate them
	//when the mute button is pressed so that you can manipulate the audio level free
	//of the mute.
	
	IF(volume_level == 0)
	{
	    
	    volume_level = prev_volume_level
	}
	ELSE
	{
	    prev_volume_level = volume_level
	    volume_level = 0
	}
	
    }
}

BUTTON_EVENT[dv_tp7500,34] // Video Fill Button
{
    RELEASE:
    {
	SEND_COMMAND dv_tp7500,"'PAGE-Full Screen Video'"
    }
}
BUTTON_EVENT[dv_tp7500,35] // Exit Full Screen Video
{
    PUSH:
    {
	SEND_COMMAND dv_tp7500,"'PAGE-Main Page'"
    }
}

TIMELINE_EVENT[TL_FEEDBACK]
{
//This section of code will reset the previous source selection button state
//if a new source is selected.

    FOR(i=1; i <= MAX_LENGTH_ARRAY(SourceButton); i++)
    { 
	
	    [dv_tp7500,SourceButton[i]] = [vdv_extron,extron_feedback_channels[i]]
	    If([vdv_extron,extron_feedback_channels[i]])
	    {
		CurrentSource = SourceButton[i]
	    }
    }
    
    //Check status of Video Mute button
    
    [dv_tp7500,27]=[vdv_proj2,MUTE_fb]
    
    //Projector Status Monitoring
    //This set of IF-ELSE statements checks to see the status of the projector.
    //Note that for the Proxima series projectors, this monitoring will only tell us the "ON"
    //and "OFF" status of the projectors- we may have to use a "WAIT" to simulate the cool-down phase.
    
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
    
    //Volume Control feedback response to the touch panel and master. I'm not sure if this is really necessary.
    SEND_LEVEL dv_tp7500,3,volume_level
    SEND_LEVEL volume,1,volume_level
}
(***********************************************************)
(*            THE ACTUAL PROGRAM GOES BELOW                *)
(***********************************************************)
DEFINE_PROGRAM


(***********************************************************)
(*                     END OF PROGRAM                      *)
(*        DO NOT PUT ANY CODE BELOW THIS COMMENT           *)
(***********************************************************)