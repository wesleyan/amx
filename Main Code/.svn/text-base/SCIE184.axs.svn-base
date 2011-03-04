PROGRAM_NAME='ModeroDanceEast'
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
-------------------------------------------------------------------------
Commenting Rules: 
// for one line comments
/* */ "C-style" comments for multi-line comments.
(* *) Computer-generated code comments.

Constant Naming Convention:
Names should make context-sense. No single letters(i.e. 'a' or 'i') should be used.
Constants should follow camelCase systems hungarian notation.(i.e. intNumberOfHours)
Acronym Clarification: Where the word is an Acronym and in all caps(i.e. "DVD" or "VCR") you may use the whole word in caps
Example: intDVDButtonSelect

List of variable type prefixes:
Format:
<abbreviation> = <name of type> (<data type call>)
Numerals:
int = integer (INTEGER)
sint = signed integer (SINTEGER)
flt = floating point number (FLOAT)
dbl = double precision number (DOUBLE)
long = Long Integer (LONG)
slong = Signed Long Integer (SLONG)
Devices:
dv = Device:Port:System (DEV)
vdv= Virtual Device:Port:System (DEV)
dvch = Device/Channel Combination (DEVCHAN)
dvlv = Device/Level Combination (DEVLEV)
Characters:
char = character (CHAR)
str = String (STRING)

All AMX reserved words should be all CAPS. 

White Space should be created using spaces, not tabs. 

*/
(***********************************************************)
(*          DEVICE NUMBER DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_DEVICE
/******** NETLINX Integrated Controller Ports **********/
dvRelay         = 5001:8:0
dvTouchPanel    = 10011:1:0

dvVideoSwitcher = 5001:1:0     //Video switcher goes on port1	
//dvProjector2  = 5001:2:0     //Port 2 is used for alternate projector
//dvKVM         = 5001:3:0     //Port 3 is used for Keyboard Video Mouse(KVM) switching
dvProjector     = 5001:4:0     //Port 4 is used for primary projector
dvDVD           = 5001:5:0     //Port 5 is used for DVD Player(RS232 Controlled)
//volume        = 150:1:0      //Volume is controlled by the MLS506MA in this codebase
dvCombo	        = 5001:9:0     //VCR uses IR Port 9

/********* Video Switching Virtual Devices **********/
vdvVSMod        = 33001:1:0    
vdvGainMod      = 33001:2:0
vdvTrebleMod    = 33001:3:0
vdvBassMod      = 33001:4:0
vdvVolumeMod    = 33001:5:0

/********** Projector Virtual Devices ***********/
//vdvProjector2 = 33002:1:0     //No alternate projector in use for this codebase. 
				//See forked code for multiple-projector code.
vdvProjector    = 33004:1:0
/********** Media Transport Virtual Devices ***********/
vdvDVD          = 33005:5:0    //DVD Player Virtual Device
vdvKVM          = 33003:3:0    //Keyboard Video Mouse Virtual Device
(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT



VOLATILE INTEGER intSourceButton[]=
{
    3, //DVD/VCR Combo Unit-DVD controls
    4, //
    0, //VCR Combo Unit-VCR controls
    2, //PC
    5, //Table VGA
    6  //Table Video
} 

VOLATILE INTEGER intExtronSourceInputs_sub[] =  //device input configuration of the extron in the room
{
    1,	//DVD
    2,  //VCR
    0,	//Not Used
    4,	//Mac
    5,  //Table VGA
    3   //Table RCA
}
(*
    intSourceButton[] corresponds to the following media sources:
    intSourceButton[1]= DVD/VCR Combo Unit: DVD
    intSourceButton[2]= Nothing
    intSourceButton[3]= DVD/VCR Combo Unit: VCR
    intSourceButton[4]= PC
    intSourceButton[5]= Table VGA
    intSourceButton[6]= Table RCA
*)

VOLATILE INTEGER intSourcePC        = 4
VOLATILE INTEGER intSourceDVD       = 1
VOLATILE INTEGER intSourceVCR       = 3
VOLATILE INTEGER intSourceAuxVideo  = 5
VOLATILE INTEGER intSourceAuxLaptop = 6


/************** DVD Transport Channels ******************/
//  G4 dvd pop-up page buttons numerically match Denon RS232 module input channels
//-- Tito's Note: While this makes it easier to code in the short-term, 
//-- this should probably be cleaned up and reorganized. 
VOLATILE INTEGER intTransportInputButtons[]=	//****NC****
{
    14,//Play
    15,//PAUSE
    16,//Stop
    17,//FF
    18,//REW
    38,//skip fwd
    37 //skip rev
    
}
VOLATILE INTEGER intVSModVidSignalType[] = 
{
  30,31,32,33,34,35
}
VOLATILE INTEGER intDVDMenuNavigationButtons[] =    //menu nav TP buttons //****NC****
{
    7,  //UP
    8,  //LEFT	
    9,  //MENU	
    10, //RIGHT
    11, //DOWN
    12  //ENTER
    
    //Note: 13  EJECT was removed. 
}
//added arrays for DVD/VCR combo device
VOLATILE INTEGER combo_tp_controls[] = {14,16,15,37,38,17,18,9,7,11,8,10,12,1,3}
VOLATILE INTEGER combo_channels[] = {1,2,3,4,5,6,7,44,45,46,47,48,49,111,112}



(************************************ TIMELINES ****************************)

VOLATILE LONG longTimelineFeedbackID = 1

(***********************************************************)
(*              DATA TYPE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_TYPE

(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE

INTEGER intCurrentSource = 0
INTEGER intTransportButtonIndex=0
CHAR charProjectorStatsXMLString[5000]
//****CHANGE?****

VOLATILE LONG longTimelineFeedbackArray[1] //init longTimelineFeedbackID interval (ms)

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
//#INCLUDE 'MLS506MAVideoSwitcher.axi'
#INCLUDE 'NP2000VideoProjectorInclude.axi'
#INCLUDE 'MLS506MAVideoSwitcher.axi'
DEFINE_FUNCTION INTEGER intConvertLevelToExtronVolume(INTEGER amxval)
{

    STACK_VAR FLOAT floatconvert 
    STACK_VAR INTEGER decimalplace
    STACK_VAR INTEGER myrounded
    
    floatconvert = amxval*intVolumeMaxValue/255
    decimalplace = FIND_STRING( FTOA(floatconvert) ,'.',1)

    IF(decimalplace)
	myrounded = ATOI(LEFT_STRING( FTOA(floatconvert), decimalplace))
    ELSE
	myrounded = ATOI( FTOA(floatconvert) ) 

    send_string 0, "'AMX = ', ITOA(amxval),'. Set Extron volume to ',ITOA(myrounded)"
    
    RETURN myrounded


}

DEFINE_FUNCTION INTEGER intConvertExtronVolumeToLevel(INTEGER exval)
{

    STACK_VAR FLOAT floatconvert 
    STACK_VAR INTEGER decimalplace
    STACK_VAR INTEGER myrounded
    
    floatconvert = exval*255/intVolumeMaxValue
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

//CREATE_LEVEL volume,1,intVolumeLevel

intVolumeMaxValue = intMaximumVolumeLevel

WAIT 300{
longTimelineFeedbackArray[1] = 500
TIMELINE_CREATE(longTimelineFeedbackID,longTimelineFeedbackArray,1,TIMELINE_RELATIVE,TIMELINE_REPEAT)
}

DEFINE_MODULE 'ExtronMLS506MA_mod' vs1 (dvVideoSwitcher,vdvVSMod,vdvGainMod,vdvTrebleMod,vdvBassMod,vdvVolumeMod) //Extron 506 Module
DEFINE_MODULE 'NEC1065_Qmodule_rev' prmod1 (dvProjector,vdvProjector,charProjectorStatsXMLString) //Projector #2 Module
DEFINE_MODULE 'DenonDVD-DNV300' dvd1	 (dvDVD,vdvDVD) //DVD control module-no feedback channels implemented yet.


(***********************************************************)
(*                THE EVENTS GO BELOW                      *)
(***********************************************************)
DEFINE_EVENT
BUTTON_EVENT[dvTouchPanel,intSourceButton]// Sources
{
    PUSH:
    {
	  PULSE[vdvVSMod,intExtronSourceInputs_sub[GET_LAST(intSourceButton)]]
	  intCurrentSource = intExtronSourceInputs_sub[GET_LAST(intSourceButton)]
	
	  SEND_STRING 0, "'cs = ',ITOA(intCurrentSource),'. I will switch proj to ',strExtronSourceInputsType[GET_LAST(intSourceButton)]"

	  //catch composite video sources
	  SEND_STRING 0, "'ExtronSourceInputType is ',strExtronSourceInputsType[intCurrentSource]"
	  If(strExtronSourceInputsType[intCurrentSource] == 'VID')
	  { 
	    PULSE[vdvProjector,intProjectorVideoInputChannel]
	    SEND_STRING 0,"'Attempting to switch to video!'"
	    If((intCurrentSource == intSourceButton[1]) || (intCurrentSource == intSourceButton[2]))
	    {
		
		  For(intTransportButtonIndex=14; intTransportButtonIndex <= 18; intTransportButtonIndex++)//Clears the playback transport buttons
		  {
		    [dvTouchPanel,intTransportButtonIndex] = 0
		  }
	    }
	    
	    ELSE
	    {
	     // Do nothing
	    }
	    SEND_COMMAND dvTouchPanel,'^SHO-7,1'
	  }
	  ELSE //assume RGB source
	  {
	    PULSE[vdvProjector,intProjectorRGB1InputChannel]
	    SEND_COMMAND dvTouchPanel,'^SHO-7,0'
	  }
    }
}


BUTTON_EVENT[dvTouchPanel,24]//SHUTDOWN BUTTON		//****NC?****
{
    PUSH:
    {
	SEND_COMMAND dvTouchPanel,"'^SHO-5,0'"
	SEND_COMMAND dvTouchPanel,"'^SHO-6,0'"
	If([vdvProjector,intProjectorOnFeedbackChannel])
	{
	    WAIT 10
	    {
		PULSE[vdvProjector,intProjectorOffInput]
	    }
	    SEND_COMMAND dvTouchPanel,"'^ANI-3,2,2'"
	    
	    WAIT 1000
	    {
		WAIT_UNTIL(NOT([vdvProjector,intProjectorCoolingFeedbackChannel]))
		{
		    SEND_COMMAND dvTouchPanel,"'^ANI-3,3,3'"
		
		    WAIT 50
		    {
			SEND_COMMAND dvTouchPanel,"'^ANI-3,1,1'"
			SEND_COMMAND dvTouchPanel,"'^SHO-5,1'"
			SEND_COMMAND dvTouchPanel,"'^SHO-6,1'"
			SEND_COMMAND dvTouchPanel,"'@PPK-Shutdown Confirm'"	    
			SEND_COMMAND dvTouchPanel,"'PAGE-Wesleyan University Page'"
		    }
		}
	    }
	}
	ELSE
	{
	    SEND_COMMAND dvTouchPanel,"'^ANI-3,3,3'"
		
		WAIT 50
		{
		    SEND_COMMAND dvTouchPanel,"'^SHO-5,1'"
		    SEND_COMMAND dvTouchPanel,"'^SHO-6,1'"
		    SEND_COMMAND dvTouchPanel,"'^ANI-3,1,1'"
		    SEND_COMMAND dvTouchPanel,"'@PPK-Shutdown Confirm'"	    
		    SEND_COMMAND dvTouchPanel,"'PAGE-Wesleyan University Page'"
		    
		}
	
	}
    }

}
BUTTON_EVENT[dvTouchPanel,25] //Projector On		//****NC****
{
    PUSH:
    {
	PULSE[vdvProjector,intProjectorOnInput]
	OFF[vdvProjector,50]
	IF(NOT([vdvProjector,intProjectorOnFeedbackChannel]))
	{
	    SEND_COMMAND dvTouchPanel,"'^ANI-2,5,5'"
	
	    WAIT 200
	    {
		ON[vdvProjector,50]
	    }
	}
    }
}

BUTTON_EVENT[dvTouchPanel,26] // Projector Off		//****NC****
{
    PUSH:
    {
	PULSE[vdvProjector,intProjectorOffInput]

	
    }
}
BUTTON_EVENT[dvTouchPanel,27] //Video Mute Button		//****NC****
{
    PUSH:
    {
	If([vdvProjector,120])
	{
	    PULSE[vdvProjector,intProjectorMuteOffInput]
	   
	}
	Else
	{
	   PULSE[vdvProjector,intProjectorMuteOnInput]
	}
    }
}


//BUTTON_EVENT[dvTouchPanel,intDVDMenuNavigationButtons]//RS232 DVD Menu Navigation Controls   //****NC****
//{
//  PUSH: 
//    {
//	PULSE[vdvDVD,(GET_LAST(intDVDMenuNavigationButtons)+6)]   //6 is the index offset
//	TO [dvTouchPanel,BUTTON.INPUT.CHANNEL]
//    }
//}
//Added for 
BUTTON_EVENT[dvTouchPanel,combo_tp_controls]
{
    PUSH:
    {
	
	PULSE[dvCombo,combo_channels[GET_LAST(combo_tp_controls)]]
    } 
}
// BUTTON_EVENT[dvTouchPanel,intTransportInputButtons]//DVD/VCR Naigation inputs.		//****NC****
//{
//   PUSH:
//    {
//    	SWITCH(intCurrentSource)
//	{
//	    CASE intSourceDVD:
//	    {
//		PULSE[vdvDVD,(GET_LAST(intTransportInputButtons)+13)]
//		// VCR/DVD transport and DVD Menu Control feedback
//		TO [dvTouchPanel,BUTTON.INPUT.CHANNEL]
//	    }
//	    CASE intSourceVCR:
//	    {
//		SYSTEM_CALL 'VCR1'(dvVCR,dvTouchPanel,14,16,15,17,18,0,0,0,0)
//		//Note: TO is not needed here because SYS_CALL handles the feedback on the buttons.
//	    }
//	}
//	
//	(*
//	If(intCurrentSource == 3)
//	{
//	    PULSE[vdvDVD,(GET_LAST(intTransportInputButtons)+13)]
//	   // VCR/DVD transport and DVD Menu Control feedback
//	    TO [dvTouchPanel,BUTTON.INPUT.CHANNEL]
//	
//	}
//	Else
//	{
//	    SYSTEM_CALL 'VCR1'(dvVCR,dvTouchPanel,14,16,15,17,18,0,0,0,0)
//	    //Note: TO is not needed here because SYS_CALL handles the feedback on the buttons.
//	}
//	*)
//	
//
//  }
//    
//}


BUTTON_EVENT[dvTouchPanel,30] //Volume Up
{
    PUSH:
    {
		TO[dvTouchPanel,30]
		IF(intVolumeLevel < VOLUME_MAX)
		{
			intVolumeLevel = intVolumeLevel + intVolumeStep
		}
		ELSE
		{
			intVolumeLevel = 255
		}
		PULSE[vdvVolumeMod,intConvertLevelToExtronVolume(intVolumeLevel)+1]
	}
  HOLD[5,REPEAT]:
  {
		IF(intVolumeLevel < VOLUME_MAX)
		{
			intVolumeLevel = intVolumeLevel + intVolumeStep
		}
		ELSE
		{
			intVolumeLevel = 255
		}
		PULSE[vdvVolumeMod,intConvertLevelToExtronVolume(intVolumeLevel)+1]
  }
}

BUTTON_EVENT[dvTouchPanel,31] //Volume Down
{
	PUSH:
	{
		TO[dvTouchPanel,31]
		IF(intVolumeLevel > VOLUME_MIN)
		{
			intVolumeLevel = intVolumeLevel - intVolumeStep
		}
		ELSE
		{
				intVolumeLevel = 0
		}
		PULSE[vdvVolumeMod,intConvertLevelToExtronVolume(intVolumeLevel)+1]
	}
	HOLD[5,REPEAT]:
	{
		IF(intVolumeLevel > VOLUME_MIN)
		{
			intVolumeLevel = intVolumeLevel - intVolumeStep
		}
		ELSE
		{
			intVolumeLevel = 0
		}
		PULSE[vdvVolumeMod,intConvertLevelToExtronVolume(intVolumeLevel)+1]
	}
}

BUTTON_EVENT[dvTouchPanel,32] //Volume Mute
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

BUTTON_EVENT[dvTouchPanel,34] // Video Fill Button		//****NC****
{
    RELEASE:
    {
	SEND_COMMAND dvTouchPanel,"'PAGE-Full Screen Video'"
    }
}
BUTTON_EVENT[dvTouchPanel,35] // Exit Full Screen Video	//****NC****
{
    PUSH:
    {
	SEND_COMMAND dvTouchPanel,"'PAGE-Main Page'"
    }
}

TIMELINE_EVENT[longTimelineFeedbackID]
{

	[dvTouchPanel,2] = [vdvVSMod,114]
	[dvTouchPanel,3] = [vdvVSMod,111]
	[dvTouchPanel,4] = [vdvVSMod,112]
	[dvTouchPanel,5] = [vdvVSMod,115]
//	[dvTouchPanel,6] = [vdvVSMod,113]

	[dvTouchPanel,32]= [vdvVolumeMod,230]
  
	//Check status of Video Mute button
    
    [dvTouchPanel,27]=[vdvProjector,intProjectorMuteFeedbackChannel]
    
    //Projector Status Monitoring
    //This set of IF-ELSE statements checks to see the status of the projector.
    //Note that for the Proxima series projectors, this monitoring will only tell us the "ON"
    //and "OFF" status of the projectors- we may have to use a "WAIT" to simulate the cool-down phase.
    
    //****NC****
    IF([vdvProjector,intProjectorOnFeedbackChannel] && NOT([vdvProjector,intProjectorMuteFeedbackChannel]) && NOT([vdvProjector,intProjectorCoolingFeedbackChannel]))
    {
      SEND_COMMAND dvTouchPanel,"'^ANI-2,1,1'"//Animate Variable Text 2 from state 1-1, 1=ON
    }
    ELSE IF([vdvProjector,intProjectorCoolingFeedbackChannel])
    {
	SEND_COMMAND dvTouchPanel,"'^ANI-2,2,2'" //Animate Variable Text 2 from state 2-2
    }
    ELSE IF([vdvProjector,intProjectorMuteFeedbackChannel])
    {
	SEND_COMMAND dvTouchPanel,"'^ANI-2,3,3'"//Animate Variable Text 2 from state 3-3
    }
    ELSE IF([vdvProjector,50])
    {
	
	SEND_COMMAND dvTouchPanel,"'^ANI-2,4,4'"//the "off" state
    }
    ELSE
    {
	;//do nothing-used to keep the "warm up" cycle on.
    }
    
    
}
CHANNEL_EVENT[dvRelay,9] // Cheap Hack! 
{
    ON:
    {
    intVolumeMaxValue = 100
    }
    OFF:
    {
    intVolumeMaxValue = intMaximumVolumeLevel
    }
}
CHANNEL_EVENT[vdvVolumeMod,intVSModVolumeChannelFeedback]//real time feedback for extron volume display on bargraph
{
    ON:
    {
	STACK_VAR INTEGER activevolume
	activevolume = GET_LAST(intVSModVolumeChannelFeedback) - 1 
	IF (activevolume >= (intVolumeMaxValue))
	{
	    PULSE[vdvVolumeMod,intVolumeMaxValue]
	}
	SEND_LEVEL dvTouchPanel,3,intConvertExtronVolumeToLevel(activevolume)
	send_string 0,"'VOlume is now ', ITOA(intConvertExtronVolumeToLevel(activevolume))"
	SEND_LEVEL dvTouchPanel,3,intConvertExtronVolumeToLevel(activevolume)
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