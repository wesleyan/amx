PROGRAM_NAME='Modero7500BuildingL'
(***********************************************************)
(* System Type : NetLinx                                   *)
(***********************************************************)
(* REV HISTORY:                                            *)
(***********************************************************)
//Update-3/09
//Code Update: Micah
//Added support for adjusting focus of canon projector on touch panel

//Update-8/17/05
//Code Update: Tito
//Revision Notes: Modified the base G4 panel code to work with 
//two projectors for Building L. There's another set of source code
//that works with only one projector. What I added was a virtual device called
//"vdv_active_proj" which takes the DPS assignment of the choice a user makes
//when activating the projector. Look in the comments for the Projector On
//button for more information. There is also a secondary TP file that explicitly goes along
//with this program containing graphics and a new page for projector selection.

//Update-8/17/05
//Code Update: Tito
//Revision Notes: Changed dv_proj2 to an inactive port, to temporarily fix a problem in AWK112.

(***********************************************************)
(*          DEVICE NUMBER DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_DEVICE
dv_relay    =5001:8:0
dv_tp7500   =10010:1:0
dv_extron   =5001:1:0
dv_blackbox =5001:3:0
dv_proj1    =5001:6:0
dv_proj2    =5001:4:0//Note: Temporarily changed from 33001:4:0 to avoid problems with two projectors turning on.
vdv_extron  =33001:1:0
vdv_blackbox=33001:3:0
vdv_proj1   =33001:6:0
vdv_proj2   =33001:4:0
dv_dvd      =5001:5:0
vdv_dvd     =33001:5:0
volumeleft  =150:1:0
volumeright =150:1:0
dv_vcr	    =5001:9:0
dv_switch   =5001:3:0
vdv_switch  =33001:3:0

(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT
VOLATILE INTEGER SourceButton[]={1,2,3,4,5,6} 

(*
    SourceButton[] corresponds to the following media sources:
    SourceButton[1]= PC
    SourceButton[2]= Mac
    SourceButton[3]= DVD
    SourceButton[4]= VCR
    SourceButton[5]= Aux Laptop
    SourceButton[6]= Document Camera
*)
//************** DVD Transport Devices ******************/
VOLATILE INTEGER transport_inputs[]=
{
    14,//Play
    15,//PAUSE
    16,//Stop
    17,//FF
    18,//REW
    38,//Skip Forward
    37//Skip Back
}
VOLATILE INTEGER DVD_MENU_NAV[] =
{
    7,  //UP
    8,  //LEFT	
    9,  //MENU	
    10, //RIGHT
    11, //DOWN
    12, //ENTER
    13  //EJECT
}

(**************************PROJECTOR CONSTANTS ****************************)
//Channel numbers for the NEC1065f module follow.
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


(********* BEGIN CANON SX7 Projector Channels **********)
(********** COMMAND CHANNELS ***********)

VOLATILE INTEGER Proxy_ON = 1
VOLATILE INTEGER Proxy_OFF = 4
VOLATILE INTEGER Proxy_MUTEON = 5
VOLATILE INTEGER Proxy_MUTEOFF = 6

//INPUT SOURCES
VOLATILE INTEGER Proxy_RGB1 =   7
VOLATILE INTEGER Proxy_RGB2 =   8
VOLATILE INTEGER Proxy_VID  =   9
VOLATILE INTEGER Proxy_SVID =   10
VOLATILE INTEGER Proxy_DIG  =   11
VOLATILE INTEGER Proxy_DIV  =   12
VOLATILE INTEGER Proxy_COMP =   13
VOLATILE INTEGER Proxy_SCART =  14

//*VOLATILE INTEGER MonitorDevice = 50

VOLATILE INTEGER CANON_ACTION_group[]=
{
  Proxy_ON,
  Proxy_OFF ,
  Proxy_MUTEON,
  Proxy_MUTEOFF
}
(********** FEEDBACK CHANNELS ***********)

//STATUS
VOLATILE INTEGER Proxy_FB_ON = 101
VOLATILE INTEGER Proxy_FB_COOLING = 102
VOLATILE INTEGER Proxy_FB_MUTE = 120

//INPUT SOURCES
VOLATILE INTEGER Proxy_FB_RGB1 = 107
VOLATILE INTEGER Proxy_FB_RGB2 = 108
VOLATILE INTEGER Proxy_FB_VID = 109
VOLATILE INTEGER Proxy_FB_SVID = 110
VOLATILE INTEGER Proxy_FB_DIG = 111
VOLATILE INTEGER Proxy_FB_DIV = 112
VOLATILE INTEGER Proxy_FB_COMP = 113
VOLATILE INTEGER Proxy_FB_SCART = 114

VOLATILE INTEGER Proxy_FB_SourceList[] = //formerly input_type_feedback_channels[] = 
{
	Proxy_FB_RGB1,
	Proxy_FB_RGB2,
	Proxy_FB_VID,
	Proxy_FB_SVID,
	Proxy_FB_DIG,
	Proxy_FB_DIV,
	Proxy_FB_COMP,
	Proxy_FB_SCART
}
//virtual device error channels
VOLATILE INTEGER Proxy_ERR_NONE = 201
VOLATILE INTEGER Proxy_ERR_TEMP = 202
VOLATILE INTEGER Proxy_ERR_LAMP = 203
VOLATILE INTEGER Proxy_ERR_LAMP_COVER = 204
VOLATILE INTEGER Proxy_ERR_COOLING_FAN = 205
VOLATILE INTEGER Proxy_ERR_PWR_SUPPLY = 206
VOLATILE INTEGER Proxy_ERR_AK = 207
VOLATILE INTEGER Proxy_ERR_ASC = 208
VOLATILE INTEGER Proxy_ERR_AF = 209
VOLATILE INTEGER Proxy_ERR_POWER_ZOOM = 210
VOLATILE INTEGER Proxy_ERR_POWER_FOCUS = 211

VOLATILE INTEGER Proxy_COMM_ACTIVE = 255 //Not sure of this

VOLATILE INTEGER Proxy_ERR_group[]=
{
	Proxy_ERR_NONE,
	Proxy_ERR_TEMP,
	Proxy_ERR_LAMP,
	Proxy_ERR_LAMP_COVER,
	Proxy_ERR_COOLING_FAN,
	Proxy_ERR_PWR_SUPPLY,
	Proxy_ERR_AK,
	Proxy_ERR_ASC,
	Proxy_ERR_AF,
	Proxy_ERR_POWER_ZOOM,
	Proxy_ERR_POWER_FOCUS
}

(******** END OF FEEDBACK CHANNELS *********)

(******** END OF PROJECTOR COMMANDS ********)

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
(***********************************************************)
(*              DATA TYPE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_TYPE

(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE
PERSISTENT INTEGER ACTIVE_PROJECTOR = 0 //Which Projector in Building L room do you want to use?
INTEGER CurrentSource = 0
INTEGER i=0
PERSISTENT INTEGER volume_level_left=0
PERSISTENT INTEGER volume_level_right=0
VOLATILE INTEGER prev_volume_level = 0
VOLATILE INTEGER VOLUME_MAX = 255 - VOLUME_STEP
VOLATILE INTEGER VOLUME_MIN = VOLUME_STEP
PERSISTENT DEV vdv_active_proj
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

(***********************************************************)
(*                STARTUP CODE GOES BELOW                  *)
(***********************************************************)
DEFINE_START
//Volume level creation to control audio level on the touchpanel and interface 
//with the card device.

CREATE_LEVEL volumeleft,1,volume_level_left
CREATE_LEVEL volumeright,2,volume_level_right

//Don't know what the hell this crap is....
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
DEFINE_MODULE 'ExtronSystem10VideoSwitchMod' vs1 (dv_extron,vdv_extron) //Extron Module
// NOT WORKING!!! DEFINE_MODULE 'NEC1065_f' pr1 (dv_proj2,vdv_proj2)
DEFINE_MODULE 'NEC1065_Qmodule_rev' prmod1 (dv_proj2,vdv_proj2, charProjectorStatsXMLString) //Projector #2 Module
DEFINE_MODULE 'DenonDVD-DNV300' dvd1	 (dv_dvd,vdv_dvd) //DVD control module-no feedback channels implemented yet.
//DEFINE_MODULE 'DataSwitch_mod' km1 (dv_switch,vdv_switch) //KVM Switcher Module
DEFINE_MODULE 'CANONSX7_Qmodule' prmod2 (dv_proj1,vdv_proj1,charProjectorStatsXMLString) //Second Projector Module
(***********************************************************)
(*                THE EVENTS GO BELOW                      *)
(***********************************************************)
DEFINE_EVENT
BUTTON_EVENT[dv_tp7500,SourceButton]// Sources
{
    PUSH:
    {
	SEND_STRING 0, 'I dont think the source buttons are getting pressed'
	PULSE[vdv_extron,extron_input_channels[GET_LAST(SourceButton)]]
	CurrentSource = GET_LAST(SourceButton)
	If((CurrentSource == SourceButton[3]) || (CurrentSource == SourceButton[4]))
	{
	    PULSE[vdv_proj1,Proxy_VID]
	    If((CurrentSource == SourceButton[3]))
	    {
		For(i=14; i <= 18; i++)
		{
		    [dv_tp7500,i] = 0
		}
	    }
	    SEND_COMMAND dv_tp7500,'^SHO-7,1' //Show The Video Page
	}
	ELSE
	{
	    PULSE[vdv_proj1,Proxy_RGB2]
	    SEND_COMMAND dv_tp7500,'^SHO-7,0'
	    
	}
	SWITCH(CurrentSource)
	{
	    CASE 1:
	    {
		PULSE[dv_switch,1]
	    }
	    CASE 2:
	    {
		PULSE[dv_switch,2]
	    }
	    DEFAULT:
	    {
		//Do nothing
	    }
	}

    }
    
    
}


BUTTON_EVENT[dv_tp7500,24]//SHUTDOWN BUTTON
{
    PUSH:
    {
	SEND_COMMAND dv_tp7500,"'^SHO-5,0'"
	SEND_COMMAND dv_tp7500,"'^SHO-6,0'"
	//TEMPORARY FIX-MUST DELETE AFTER, 'CAUSE THIS SHIT IS BAD PROGRAMMING
	
	PULSE [vdv_proj1,Off_in]
	PULSE [vdv_proj2,Proxy_OFF]
	
	//END TEMPORARY FIX....Or is it???
	
	If([vdv_proj1,On_fb] || [vdv_proj2,Proxy_FB_ON])			//Modified for general use:
	{
	    WAIT 10
	    {
		PULSE[vdv_proj1,OFF_in] 
		PULSE[vdv_proj2,Proxy_OFF]
	    }
	    SEND_COMMAND dv_tp7500,"'^ANI-3,2,2'" //Animates the "Projector is Cooling" button
						    //That's why you get the "Projector is cooling" flash before it actually cools.
	    
	    
	    WAIT 1000
	    {
		WAIT_UNTIL(NOT([vdv_proj1,COOLING_fb]) && NOT([vdv_proj2,Proxy_FB_ON]))
		{
		    SEND_COMMAND dv_tp7500,"'^ANI-3,3,3'" //CHanges from "Projector is Cooling" to "Projector is Off"
		
		    WAIT 50
		    {
			SEND_COMMAND dv_tp7500,"'^ANI-3,1,1'"//Resets the button to "Off"
			SEND_COMMAND dv_tp7500,"'^SHO-5,1'"//Resets the "OK" button
			SEND_COMMAND dv_tp7500,"'^SHO-6,1'"//Resets the "Cancel Button"(Note they were hidden earlier)
			SEND_COMMAND dv_tp7500,"'@PPK-Shutdown Confirm'"//Hides the "Confirm Shutdown" popup page.	    
			SEND_COMMAND dv_tp7500,"'PAGE-Wesleyan University Page'"//Displays the front splash page.
		    }
		}
	    }
	}
	ELSE
	{
	    //These commands just repeat the above steps without the projector on.
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
{ //NOTE: THIS CODE HAS CHANGED AND IS NOT THE SAME AS GENERIC 7" TOUCHPANELS. IT IS SPECIFIC TO BUILDING L
  //ROOM WITH TWO PROJECTOR SYSTEMS!
    PUSH:
    {	
	SEND_COMMAND dv_tp7500,"'PAGE-Projector Selection'" //Sends you to the Projector Selection screen
	
    }
}

BUTTON_EVENT[dv_tp7500,26] // Projector Off
{
    PUSH:
    {
	PULSE[vdv_proj1,OFF_in]
	PULSE[vdv_proj2,PROXY_OFF]
    }
}
BUTTON_EVENT[dv_tp7500,27] //Video Mute Button
{
    PUSH:
    {
	If([vdv_proj1,120] || [vdv_proj2,PROXY_FB_MUTE])
	{
	    PULSE[vdv_proj1,MUTEOFF_in]
	    PULSE[vdv_proj2,Proxy_MUTEOFF]
	   
	}
	Else
	{
	   PULSE[vdv_proj1,MUTEON_in]
	   PULSE[vdv_proj2,Proxy_MUTEOFF]
	}
    }
}

BUTTON_EVENT[dv_tp7500,DVD_MENU_NAV]//DVD Menu Navigation Controls
{
    PUSH: 
    {
	PULSE[vdv_dvd,(GET_LAST(DVD_MENU_NAV)+6)]
	TO [dv_tp7500,BUTTON.INPUT.CHANNEL]
    }
}

BUTTON_EVENT[dv_tp7500,transport_inputs]//DVD/VCR Naigation inputs.
{
    PUSH:
    {
	If(CurrentSource == 3)
	{
	    PULSE[vdv_dvd,(GET_LAST(transport_inputs)+13)]
	    //VCR/DVD transport and DVD Menu Control feedback
	    TO [dv_tp7500,BUTTON.INPUT.CHANNEL]
	}
	Else
	{
	    SYSTEM_CALL 'VCR1'(dv_vcr,dv_tp7500,14,16,15,17,18,0,0,0,0)
	    //Note: TO is not needed here because SYS_CALL handles the feedback on the buttons.
	}
	
	

    }
    
}
BUTTON_EVENT[dv_tp7500,30] //Volume Up
{
    PUSH:
    {
	IF(volume_level_left < VOLUME_MAX && volume_level_right < VOLUME_MAX)
	{
	    volume_level_left = volume_level_left + VOLUME_STEP
	    volume_level_right = volume_level_right + VOLUME_STEP
	}
	ELSE
	{
	    volume_level_left = 255
	    volume_level_right = 255
	}
    }
    HOLD[1,REPEAT]:
    {
	IF(volume_level_left < VOLUME_MAX && volume_level_right < VOLUME_MAX)
	{
	    volume_level_left = volume_level_left + VOLUME_STEP
	    volume_level_right = volume_level_right + VOLUME_STEP
	}
	ELSE
	{
	    volume_level_left = 255
	    volume_level_right = 255
	}
    }
}
BUTTON_EVENT[dv_tp7500,31] //Volume Down
{
    PUSH:
    {
	IF(volume_level_left > VOLUME_MIN && volume_level_right > VOLUME_MIN)
	{
	    volume_level_left = volume_level_left - VOLUME_STEP
	    volume_level_right = volume_level_right - VOLUME_STEP
	}
	ELSE
	{
	    volume_level_left = 0
	    volume_level_right = 0
	}
    }
    HOLD[1,REPEAT]:
    {
	IF(volume_level_left > VOLUME_MIN && volume_level_right > VOLUME_MIN)
	{
	   volume_level_left = volume_level_left - VOLUME_STEP
	   volume_level_right = volume_level_right - VOLUME_STEP
	}
	ELSE
	{
	   volume_level_left = 0
	   volume_level_right = 0
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
	
	//Otherwise, this code controls the function of the mute button.
	
	IF(volume_level_left == 0 && volume_level_right == 0)
	{
	    
	    volume_level_left = prev_volume_level
	    volume_level_right = prev_volume_level
	}
	ELSE
	{
	    prev_volume_level = volume_level_left
	    volume_level_left = 0
	    volume_level_right = 0
	}
	
    }
}

BUTTON_EVENT[dv_tp7500,33]//Projector Page: Proxima Projector Selection Button
{
    //NOTE: THIS CODE ONLY WORKS ON THE SPECIFIC BUILDING L PROJECTOR SETUP. DO NOT ATTEMPT WITH 
    //ANY OTHER TOUCHPANEL OR PROJECTOR SETUP. WE ARE PROFESSIONALS. WE KNOW WHAT WE ARE DOING. THANK YOU.
    PUSH:
    {
	SEND_COMMAND dv_tp7500,"'PAGE-Main Page'" //Goes back to the main page
	ACTIVE_PROJECTOR = 1 //Sets the variable ACTIVE_PROJECTOR to 1
	PULSE [vdv_proj1,ON_in]//Turns on the projector assigned to vdv_proj1
	
    }


}

BUTTON_EVENT[dv_tp7500,34]//Projector Page: NEC Projector Selection Button
{
    //NOTE: THIS CODE ONLY WORKS ON THE SPECIFIC BUILDING L PROJECTOR SETUP. DO NOT ATTEMPT
    //WITH ANY OTHER TOUCHPANEL OR PROJECTOR SETUP. WE *PROMISE* THAT WE ARE PROFESSIONALS. DO NOT ATTEMPT AT HOME.
    PUSH:
    {
	SEND_COMMAND dv_tp7500,"'PAGE-Main Page'" // Switches back to Main Page
	ACTIVE_PROJECTOR = 2 //sets Active Projector to Two
	PULSE [vdv_proj2,Proxy_ON] //Turns on the projector corresponding the vdv_proj2
    }



}
BUTTON_EVENT[dv_tp7500,35] // Video Fill Button
{
    RELEASE:
    {
	SEND_COMMAND dv_tp7500,"'PAGE-Full Screen Video'"
    }
}
BUTTON_EVENT[dv_tp7500,36] // Exit Full Screen Video
{
    PUSH:
    {
	SEND_COMMAND dv_tp7500,"'PAGE-Main Page'"
    }
}

BUTTON_EVENT[dv_tp7500,37]
{
    PUSH:
    {
	PULSE[vdv_dvd,37]
	TO [dv_tp7500,BUTTON.INPUT.CHANNEL]
    }
}
BUTTON_EVENT[dv_tp7500,38]
{
    PUSH:
    {
	PULSE[vdv_dvd,38]
	TO [dv_tp7500,BUTTON.INPUT.CHANNEL]
    }
}
BUTTON_EVENT[dv_tp7500, 60] //Focus Near coarse
{
    PUSH:
    {
	PULSE[vdv_proj1, 21]
    }
    /*RELEASE:
    {
	PULSE[vdv_proj1, 25]
    }*/
}
BUTTON_EVENT[dv_tp7500, 61] //Focus Far coarse
{
    PUSH:
    {
	PULSE[vdv_proj1, 20]
    }
    /*RELEASE:
    {
	PULSE[vdv_proj1, 25]
    }*/
}
BUTTON_EVENT[dv_tp7500, 62] //Focus Near fine
{
    PUSH:
    {
	PULSE[vdv_proj1, 23]
    }
    HOLD[1,REPEAT]:
    {
	PULSE[vdv_proj1, 27]
    }
    RELEASE:
    {
	PULSE[vdv_proj1, 28]
    }
}
BUTTON_EVENT[dv_tp7500, 63] //Focus Far fine
{
    PUSH:
    {
	PULSE[vdv_proj1, 22]
    }
    HOLD[1,REPEAT]:
    {
	PULSE[vdv_proj1, 26]
    }
    RELEASE:
    {
	PULSE[vdv_proj1, 28]
    }
}

BUTTON_EVENT[dv_tp7500, 64] //Auto focus
{
    PUSH:
    {
	PULSE[vdv_proj1, 24]
    }
}
(***********************************************************)
(*            THE ACTUAL PROGRAM GOES BELOW                *)
(***********************************************************)
DEFINE_PROGRAM

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

[dv_tp7500,27]=([vdv_proj1,MUTE_fb] || [vdv_proj2,PROXY_FB_MUTE])

//Projector Status Monitoring
//This set of IF-ELSE statements checks to see the status of the projector.
//Note that for the Proxima series projectors, this monitoring will only tell us the "ON"
//and "OFF" status of the projectors- we may have to use a "WAIT" to simulate the cool-down phase.

IF([vdv_active_proj,On_fb] && NOT([vdv_active_proj,MUTE_fb]) && NOT([vdv_active_proj,COOLING_fb]))
{
    SEND_COMMAND dv_tp7500,"'^ANI-2,1,1'" //Sets the state of the "button" text "Projector is On"
}
ELSE IF([vdv_active_proj,COOLING_fb])
{
    SEND_COMMAND dv_tp7500,"'^ANI-2,2,2'" //Displays the "Projector is Cooling" text
}
ELSE IF([vdv_active_proj,MUTE_fb])
{
    SEND_COMMAND dv_tp7500,"'^ANI-2,3,3'"// Displays the "Projector is Muted" Text
}
ELSE 
{
    SEND_COMMAND dv_tp7500,"'^ANI-2,4,4'" // Displays the "PRojector is Off" text.
}
//Volume Control feedback response to the touch panel and master. I'm not sure if this is really necessary.

SEND_LEVEL dv_tp7500,3,volume_level_left
SEND_LEVEL dv_tp7500,3,volume_level_right
SEND_LEVEL volumeleft,1,volume_level_left
SEND_LEVEL volumeright,2,volume_level_right

//CURRENT PROJECTOR MONITORING FEEDBACK HAS BEEN TURNED OFF IN THIS CODE
(***********************************************************)
(*                     END OF PROGRAM                      *)
(*        DO NOT PUT ANY CODE BELOW THIS COMMENT           *)
(***********************************************************)