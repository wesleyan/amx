PROGRAM_NAME='usdantest1'
(***********************************************************)
(* System Type : NetLinx                                   *)
(***********************************************************)
(* REV HISTORY:                                            *)
(***********************************************************)

(***********************************************************)
(*          DEVICE NUMBER DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_DEVICE
dvExtron       = 5001:1:0  
vdvExtron      = 33001:3:0

dvVol          = 150:1:0
vdvVol	       = 33150:0:1

dvVCR          = 5001:9:0   //now NI3000

dvDVD          = 5001:5:0   //now rs232
vdvDVD         = 33505:5:0

dvRelay        = 5001:7:0
dvTp           = 10011:1:0

dvProjSide     = 5001:2:0   //south
vdvProjSide    = 33502:2:0

dvProjCenter   = 5001:3:0   //west
vdvProjCenter  = 33501:3:0

#INCLUDE 'TechPage.axi'
(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT

//NEC1065_f virtual device input channels
VOLATILE INTEGER ON_in_proj = 1
VOLATILE INTEGER OFF_in_proj = 4
VOLATILE INTEGER MUTEON_in = 5
VOLATILE INTEGER MUTEOFF_in = 6
VOLATILE INTEGER RGB1_in = 7
VOLATILE INTEGER RGB2_in = 8
VOLATILE INTEGER VID_in = 9

VOLATILE INTEGER MUTE = 0
VOLATILE INTEGER volume_step = 5

VOLATILE LONG TL_Feedback = 1
VOLATILE LONG TL_AutoShutDown = 2


//Extron Crosspoint ties channels
VOLATILE INTEGER RGB = 102
VOLATILE INTEGER VID = 103

//physical inputs to extron, using vdvExtron module 
VOLATILE INTEGER ComputerFB = 1
VOLATILE INTEGER LaptopFB = 2
VOLATILE INTEGER AuxVideoFB = 3
VOLATILE INTEGER VCR = 4
VOLATILE INTEGER DVD = 5
VOLATILE INTEGER ComputerRack = 6
VOLATILE INTEGER LaptopRack = 7
VOLATILE INTEGER AuxVideoRack = 8

(*
VOLATILE INTEGER extron_input_signal_type[] = {
    RGB,  //ComputerFB
    RGB,  //LaptopFB
    VID,  //AuxVideoFB
    VID,  //VCR
    VID,  //DVD
    RGB,  //ComputerRack
    RGB,  //LaptopRack
    VID   //AuxVideoRack
    }
*)

//TP button address channel codes for center screen
VOLATILE INTEGER SourceCenter[] = {
    21, //ComputerFB
    22, //ComputerRack
    23, //LaptopFB
    24, //LaptopRack
    25, //VCR
    26, //AuxVideoFB
    27, //AuxVideoRack
    28  //DVD
}

VOLATILE INTEGER SourceCenterInputs[] =
{
    ComputerFB, //ComputerFB
    ComputerRack, //ComputerRack
    LaptopFB, //LaptopFB
    LaptopRack, //LaptopRack
    VCR, //VCR
    AuxVideoFB, //AuxVideoFB
    AuxVideoRack, //AuxVideoRack
    DVD  //DVD
}

VOLATILE INTEGER SourceCenterSignalTypes[] =
{
    RGB, //ComputerFB
    RGB, //ComputerRack
    RGB, //LaptopFB
    RGB, //LaptopRack
    VID, //VCR
    VID, //AuxVideoFB
    VID, //AuxVideoRack
    VID  //DVD
}

//TP button address channel codes for side screen
VOLATILE INTEGER SourceSide[]   = {
    1, //comp fb
    2,  //comp rack
    3, //lap fb
    4,  //lab rack
    5,  //aux fb
    6,  //aux rack
    7,  //dvd
    8  //vcr
}

VOLATILE INTEGER SourceSideInputs[] = //the order of these integers corresponds with Source Side address channels
{               //the comments are directly copied from SourceSide to aid in understanding of relationship
    ComputerFB, //comp fb
    ComputerRack,  //comp rack
    LaptopFB, //lap fb
    LaptopRack,  //lab rack
    AuxVideoFB,  //aux fb
    AuxVideoRack,  //aux rack
    DVD,  //dvd
    VCR  //vcr
}

VOLATILE INTEGER SourceSideSignalTypes[]=
{
    RGB, //comp fb
    RGB,  //comp rack
    RGB, //lap fb
    RGB,  //lab rack
    VID,  //aux fb
    VID,  //aux rack
    VID,  //dvd
    VID  //vcr
}

VOLATILE INTEGER extron_input_channels[] = {1,2,6,7,9,4,5,3,8}
//pc,mac,laptop1,laptop2,doc camera,dvd,vcr,vcr cc,aux video

VOLATILE INTEGER extron_output_channels[] = {51,52,53,54,55,56,57,58}

(*
VOLATILE INTEGER RGBSourceCenter[] = {1,2,3,4}
VOLATILE INTEGER VIDSourceCenter[] = {5,6,7,8}
VOLATILE INTEGER RGBSourceSide[]   = {21,22,23,24}
VOLATILE INTEGER VIDSourceSide[]   = {25,26,27,28,29}
*)

VOLATILE DEV Projectors[] = {vdvProjSide, vdvProjCenter}


VOLATILE INTEGER VCRButtons[] = {40,41,42,43,44}
VOLATILE INTEGER DVDButtons[] = {   //transport controls
    50,  //play
    51,  //stop
    52,  //pause
    53,  //skip b
    54,  //skip f
    55, //rev
    56  //ff
    }
    
VOLATILE INTEGER DVDmoduleinputchannels[] = { //values of elements are Denon dnv300 module transport input channels  
    14,  //play
    16,  //stop
    15,  //pause
    20,  //skip b
    19,  //skip f
    18, //rev
    17  //ff
    } 
    
VOLATILE INTEGER DVDControls[] = {  //menu and nav buttons
    57,  //up
    58,  //down
    59,  //left
    60,  //right
    61,  //menu
    62  //enter
    }
    
VOLATILE INTEGER DVDmodulemenuinputchannels[]= { //values of elemtns are Denon dnv300 module transport input channels
    7,  //up
    11,  //down
    8,  //left
    10,  //right
    9,  //menu
    12  //enter
    }
    
VOLATILE INTEGER DVDPulse_Buttons[] = {1,2,3,5,4,7,6}
VOLATILE INTEGER DVDPulse_Controls[] = {45,46,47,48,44,49}

VOLATILE INTEGER ON_fb = 101
VOLATILE INTEGER COOLING_fb = 102
VOLATILE INTEGER MUTE_fb = 120

VOLATILE INTEGER RGB1_fb = 107
VOLATILE INTEGER RGB2_fb = 108
VOLATILE INTEGER VID_fb = 109


(***********************************************************)
(*              DATA TYPE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_TYPE

(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE
VOLATILE INTEGER current_source_side = 0
VOLATILE INTEGER current_source_center = 0
PERSISTENT INTEGER volume 
VOLATILE INTEGER volume_mute
VOLATILE INTEGER volume_mute_level
VOLATILE INTEGER max_volume = 255 - volume_step
VOLATILE INTEGER min_volume = volume_step
// Not used to control volumes.
//VOLATILE DEVLEV devlev_volume = {vdvVol,1} 
//VOLATILE DEVLEV devlev_mute[]= {{dvTp,1}}
//VOLATILE DEVLEV devlev_unmute[]= {{dvTp,1},{dvVol,1}}

VOLATILE INTEGER current_dvd_control
VOLATILE INTEGER current_dvd_button

VOLATILE LONG TL1ar[1]
VOLATILE LONG TL_PrAutoOff[2]

VOLATILE INTEGER module_fb_array_video[50]
VOLATILE INTEGER module_fb_array_audio[50]

(***********************************************************)
(*               LATCHING DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_LATCHING

(***********************************************************)
(*       MUTUALLY EXCLUSIVE DEFINITIONS GO BELOW           *)
(***********************************************************)

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
    TL1ar[1] = 250
    TIMELINE_CREATE(TL_Feedback,TL1ar,1,TIMELINE_RELATIVE,TIMELINE_REPEAT)
    SEND_COMMAND dvTp, "'@PPN-Welcome Page;Main Page'"
}

CREATE_LEVEL dvVol, 1, volume

SEND_LEVEL dvVol,1,volume
SEND_LEVEL dvVol,2,volume
SEND_LEVEL dvTP,1,volume


TL_PrAutoOff[1] = (4*60*60*1000)	
TL_PrAutoOff[2] = (4*60*60*1000+15*60*1000)



DEFINE_MODULE 'crosspoint_mod' vs1 (dvExtron,vdvExtron,module_fb_array_video,module_fb_array_audio) //Extron Module
DEFINE_MODULE 'NEC1065_f' prmodSide (dvProjSide,vdvProjSide) //Side Projector Module
DEFINE_MODULE 'NEC1065_f' prmodCenter (dvProjCenter,vdvProjCenter) //Center Projector Module
DEFINE_MODULE 'DenonDVD-DNV300' dvd1 (dvDVD,vdvDVD)  //rs232 dvd module
(***********************************************************)
(*                THE EVENTS GO BELOW                      *)
(***********************************************************)
DEFINE_EVENT

BUTTON_EVENT [dvTp,SourceCenter] 		//view source south
{  
    PUSH:
    {
	current_source_center = GET_LAST(SourceCenter)
	
	ON[vdvExtron,SourceCenterInputs[current_source_center]]

	PULSE[vdvExtron,SourceCenterInputs[current_source_center]]
	
	IF(SourceCenterSignalTypes[current_source_center] == RGB)
	{
	    ON[vdvExtron,52]  //rgb south	
	    PULSE[vdvProjCenter,RGB2_in]
	}
	ELSE
	{
	    ON[vdvExtron,54]  //VID south
	    PULSE[vdvProjCenter,VID_in]
	}
	
	PULSE[vdvExtron,SourceCenterSignalTypes[current_source_center]]
	SEND_STRING dvExtron, "ITOA (SourceCenterInputs[current_source_center]),'*1$'"	
    }	
}	

BUTTON_EVENT [dvTp,SourceSide]			//south projector
{  
    PUSH:
    {
	current_source_side = GET_LAST(SourceSide)

	ON[vdvExtron,SourceSideInputs[current_source_side]]
	
	IF(SourceSideSignalTypes[current_source_side] == RGB)
	{
	    ON[vdvExtron,51]			//RGB south projector
	    PULSE[vdvProjSide,RGB2_in]
	}
	ELSE
	{
	    ON[vdvExtron,53]    //VID south projector
	    PULSE[vdvProjSide,VID_in]
	}
	PULSE[vdvExtron,SourceSideSignalTypes[current_source_side]]
	SEND_STRING dvExtron, "ITOA (SourceSideInputs[current_source_side]),'*1$'"
    }
}
BUTTON_EVENT[dvTP,30] 						//video mute center
{
    PUSH:
    {
	IF([vdvProjCenter,MUTE_fb])
	{
	    PULSE[vdvProjCenter,MUTEOFF_in]
	}
	ELSE
	{
	   PULSE[vdvProjCenter,MUTEON_in]
	}
    }
}
BUTTON_EVENT[dvTP,10] 						//video mute side
{
    PUSH:
    {
	IF([vdvProjSide,MUTE_fb])
	{
	    PULSE[vdvProjSide,MUTEOFF_in]
	}
	ELSE
	{
	   PULSE[vdvProjSide,MUTEON_in]
	}
    }
}
BUTTON_EVENT[dvTp,11]  						//turn side projector on
{
    PUSH:
    {
	PULSE[vdvProjSide,ON_in_proj]
	SEND_COMMAND dvTp, "'^ANI-1,2,2'"        		//'...warming.' 
	
	WAIT_UNTIL ([vdvProjSide,ON_fb])         
	SEND_COMMAND dvTp, "'^ANI-1,3,3'"        		//'...on.'
	
	WAIT 400
	    IF (NOT[vdvProjSide,ON_fb])
	    SEND_COMMAND dvTp, "'^ANI-1,5,5'"    		//'...error turning on.'
    }
}
BUTTON_EVENT[dvTp,12]   					//turn side projector off
{
    PUSH:
    {
	  PULSE[vdvProjSide,OFF_in_proj]
	  WAIT 40
	{
	    IF([vdvProjSide,COOLING_fb]) 
	    {
		SEND_COMMAND dvTp, "'^ANI-1,4,4'"  	    	//'...cooling.'
		WAIT_UNTIL ((NOT[vdvProjSide,COOLING_fb])) 'wait side for not cooling' 
		{
		    SEND_COMMAND dvTp, "'^ANI-1,1,1'"   	//'...off.'
		}
	    }
	}
	WAIT 400
	    IF ([vdvProjSide,ON_fb])       			//'...error turning off.'
	    SEND_COMMAND dvTp, "'^ANI-1,6,6'"
    }
}
BUTTON_EVENT[dvTp,31]  						//turn center projector on
{
    PUSH:
    {
	PULSE[vdvProjCenter,ON_in_proj]
	SEND_COMMAND dvTp, "'^ANI-2,2,2'"         		//'...warming.'
	
	WAIT_UNTIL ([vdvProjCenter,ON_fb])
	SEND_COMMAND dvTp, "'^ANI-2,3,3'"         		//'...on.'
	    
	WAIT 400
	    IF (NOT[vdvProjCenter,ON_fb])
	    SEND_COMMAND dvTp, "'^ANI-2,5,5'"     		//'...error turning on.'
    }
}
BUTTON_EVENT[dvTp,32]  						//turn center projector off
{
    PUSH:
    {
	PULSE[vdvProjCenter,OFF_in_proj]
	WAIT 40			
	{
	    IF([vdvProjCenter,COOLING_fb]) 
	    {
		SEND_COMMAND dvTp, "'^ANI-2,4,4'"  	    	//'...cooling.'
		WAIT_UNTIL ((NOT[vdvProjCenter,COOLING_fb])) 'wait center for not cooling' 
		{
		    SEND_COMMAND dvTp, "'^ANI-2,1,1'"   	//'...off.'
		}
	    }
	}
	WAIT 400
	IF ([vdvProjCenter,ON_fb])
	SEND_COMMAND dvTp, "'^ANI-2,6,6'"       		//'...error turning off.'
    }
}
BUTTON_EVENT[dvTP,VCRButtons]  					//vcr
{
    PUSH:
    {
	SYSTEM_CALL 'VCR2'(dvVCR,dvTP,40,42,41,44,43,0,0,0,0)
    }
}
BUTTON_EVENT[dvTp,DVDButtons]					//dvd buttons
{
    PUSH:
    {
	current_dvd_button = GET_LAST(DVDButtons)
 	TO[dvTp,button.input.channel]
	//PULSE[dvDVD,DVDPulse_Buttons[GET_LAST(DVDButtons)]]
	PULSE [vdvDVD,DVDmoduleinputchannels[current_dvd_button]]
    }
}
BUTTON_EVENT[dvTp,DVDControls]					//dvd controls
{
    PUSH:
    {
	current_dvd_control = GET_LAST(DVDControls)
	TO[dvTp,button.input.channel]
	//PULSE[dvDVD,DVDPulse_Controls[GET_LAST(DVDControls)]]
	PULSE[vdvDVD,DVDmodulemenuinputchannels[current_dvd_control]]
    }
}
BUTTON_EVENT[dvTp,80] //shut down button
{
    PUSH:
    {
	    IF([vdvProjSide,ON_fb])
		{
		PULSE[vdvProjSide,OFF_in_proj]
		WAIT 40
		WAIT_UNTIL ((NOT[vdvProjSide,COOLING_fb])) 'wait side for not cooling' 
		{
		    SEND_COMMAND dvTp, "'^ANI-1,1,1'"   	//'...off.'
		}
		}
	    IF([vdvProjCenter,ON_fb])
		{
		PULSE[vdvProjCenter,OFF_in_proj]
		WAIT 40
		WAIT_UNTIL ((NOT[vdvProjCenter,COOLING_fb])) 'wait center for not cooling' 
		    {
			SEND_COMMAND dvTp, "'^ANI-2,1,1'"   	//'...off.'
		    }
		}
	    (*WAIT 40
	    {
	    IF([vdvProjSide,COOLING_fb]) 
	    {
		SEND_COMMAND dvTp, "'^ANI-1,4,4'"  	    	//'...cooling.'
		WAIT_UNTIL ((NOT[vdvProjSide,COOLING_fb])) 'wait side for not cooling' 
		{
		    SEND_COMMAND dvTp, "'^ANI-1,1,1'"   	//'...off.'
		}
	    }
	    IF([vdvProjCenter,COOLING_fb]) 
	    {
		    SEND_COMMAND dvTp, "'^ANI-2,4,4'"  	    	//'...cooling.'
		    WAIT_UNTIL ((NOT[vdvProjCenter,COOLING_fb])) 'wait center for not cooling' 
		    {
			SEND_COMMAND dvTp, "'^ANI-2,1,1'"   	//'...off.'
		    }
	    }
	    WAIT 400
	    {
		IF ([vdvProjSide,ON_fb])       			//'...error turning off.'
		    SEND_COMMAND dvTp, "'^ANI-1,6,6'"
		IF ([vdvProjCenter,ON_fb])
		    SEND_COMMAND dvTp, "'^ANI-2,6,6'"       		//'...error turning off.'
	    }
	    }
      	
	(*SEND_COMMAND dvTp, "'^SHO-80,0'"
	SEND_COMMAND dvTp, "'^SHO-4,0'"
	SEND_COMMAND dvTp, "'^SHO-8,0'"
	SEND_COMMAND dvTp, "'^ANI-7,2,2'"
	*)
	*)
	{
	    PULSE[dvRelay,3]			// side screen up
	}
	
	{
	    PULSE[dvRelay,1]          		// center screen up
	}
    }
}
	(*
	IF([vdvProjSide,ON_fb])			//side projector off
	{
	    PULSE[vdvProjSide,OFF_in_proj]
	    WAIT 40
	    {
		IF([vdvProjSide,COOLING_fb]) 
		{
		    SEND_COMMAND dvTp, "'^ANI-1,4,4'"  	    	//'...cooling.'
		    WAIT_UNTIL ((NOT[vdvProjSide,COOLING_fb])) 'wait side for not cooling' 
		    {
			SEND_COMMAND dvTp, "'^ANI-1,1,1'"   	//'...off.'
			SEND_COMMAND dvTp, "'@PPA-Main Page'"
			SEND_COMMAND dvTp, "'@PPN-Welcome Page;Main Page'"
			SEND_STRING 0, 'inside side wait until'
		    }
		}
	    }
	    WAIT 400
	    IF ([vdvProjSide,ON_fb])       		//'...error turning off.'
	    SEND_COMMAND dvTp, "'^ANI-1,6,6'"
	}
	
	IF([vdvProjCenter,ON_fb])
	{
	    PULSE[vdvProjCenter,OFF_in_proj]
	    WAIT 40			
	    {
		IF([vdvProjCenter,COOLING_fb]) 
		{
		    SEND_COMMAND dvTp, "'^ANI-2,4,4'"  	   	 //'...cooling.'
		    WAIT_UNTIL ((NOT[vdvProjCenter,COOLING_fb])) 'wait center for not cooling' 
		    {
			SEND_COMMAND dvTp, "'^ANI-2,1,1'"   	//'...off.'
			SEND_COMMAND dvTp, "'@PPA-Main Page'"
			SEND_COMMAND dvTp, "'@PPN-Welcome Page;Main Page'"
			SEND_STRING 0, 'inside center wait until'
		    }
		}
	    }
	    WAIT 400
	    IF ([vdvProjCenter,ON_fb])       	//'...error turning off.'
	    SEND_COMMAND dvTp, "'^ANI-2,6,6'"
	}
	
	ELSE
	{
	    SEND_COMMAND dvTp, "'@PPA-Main Page'"
	    SEND_COMMAND dvTp, "'@PPN-Welcome Page;Main Page'"
	}
	SEND_COMMAND dvTp, "'^SHO-80,1'"
	SEND_COMMAND dvTp, "'^SHO-4,1'"
	SEND_COMMAND dvTp, "'^SHO-8,1'"
	SEND_COMMAND dvTp, "'^ANI-7,1,1'"
	*)


BUTTON_EVENT[dvTp,13]    	//side screen down
{
    PUSH:
    {
        PULSE[dvRelay,4]
	[dvTp,14] = 0
	[dvTp,13] = 1
	WAIT 170
	[dvTp,13] = 0
    }
}
BUTTON_EVENT[dvTp,14]     	   //side screen up
{
    PUSH:
    {
	PULSE[dvRelay,3]
	[dvTp,13] = 0
	[dvTp,14] = 1
	WAIT 170
	[dvTp,14] = 0
    }
}
BUTTON_EVENT[dvTp,33]		   //center screen down
{
    PUSH:
    {
	PULSE[dvRelay,2]
	[dvTp,34] = 0
	[dvTp,33] = 1
	WAIT 200
	[dvTp,33] = 0
    }
}
BUTTON_EVENT[dvTp,34]		   //center screen up
{
    PUSH:
    {
	PULSE[dvRelay,1]
	[dvTp,33] = 0
	[dvTp,34] = 1
	WAIT 200
	[dvTp,34] = 0
    }
}
BUTTON_EVENT[dvTp,70]              //volume up
{
    PUSH:
    {
	IF(volume_mute_level <= max_volume && volume_mute == 1)
	{
	    volume = volume_mute_level
	    volume_mute = 0
	    SEND_LEVEL dvVol,1,volume
	    SEND_LEVEL dvVol,2,volume
	    SEND_LEVEL dvTP,1,volume
	}
	ELSE IF(volume <= max_volume && volume_mute == 0)
	{
	    volume = volume + volume_step
	    SEND_LEVEL dvVol,1,volume
	    SEND_LEVEL dvVol,2,volume
	    SEND_LEVEL dvTp,1,volume
	}
    }
    
    HOLD[1,REPEAT]:
    {
	IF(volume_mute_level <= max_volume && volume_mute == 1)
	{
	    volume = volume_mute_level
	    volume_mute = 0
	    SEND_LEVEL dvVol,1,volume
	    SEND_LEVEL dvVol,2,volume
	    SEND_LEVEL dvTP,1,volume
	}
	ELSE IF(volume <= max_volume && volume_mute == 0)
	{
	    volume = volume + volume_step
	    SEND_LEVEL dvVol,1,volume
	    SEND_LEVEL dvVol,2,volume
	    SEND_LEVEL dvTp,1,volume
	}
    }
}
BUTTON_EVENT[dvTp,71]              //volume down
{
    PUSH:
    {
	IF(volume_mute_level >= min_volume && volume_mute == 1)
	{
	    volume = volume_mute_level
	    volume_mute = 0
	    SEND_LEVEL dvVol,1,volume
	    SEND_LEVEL dvVol,2,volume
            SEND_LEVEL dvTP,1,volume
	}
	ELSE IF(volume >= min_volume && volume_mute == 0)
	{
	    volume = volume - volume_step
	    SEND_LEVEL dvVol,1,volume
	    SEND_LEVEL dvVol,2,volume
            SEND_LEVEL dvTP,1,volume
	}
    }
    
    HOLD[1,REPEAT]:
    {
	IF(volume_mute_level >= min_volume && volume_mute == 1)
	{
	    volume = volume_mute_level
	    volume_mute = 0
	    SEND_LEVEL dvVol,1,volume
	    SEND_LEVEL dvVol,2,volume
            SEND_LEVEL dvTP,1,volume
	}
	ELSE IF(volume >= min_volume && volume_mute == 0)
	{
	    volume = volume - volume_step
	    SEND_LEVEL dvVol,1,volume
	    SEND_LEVEL dvVol,2,volume
            SEND_LEVEL dvTP,1,volume
	}
    }
}
BUTTON_EVENT[dvTp,72]              //volume mute
{
    RELEASE:
    {
	IF(volume_mute == 0)
	{
	  volume_mute = 1
	  volume_mute_level = volume
	  volume = 0
	  SEND_LEVEL dvVol,1,volume
	  SEND_LEVEL dvVol,2,volume
	  SEND_LEVEL dvVol,1,volume
	}
	
	ELSE
	{
	  volume_mute = 0
	  volume = volume_mute_level
	  SEND_LEVEL dvVol,1,volume
	  SEND_LEVEL dvVol,2,volume
	  SEND_LEVEL dvVol,1,volume
	}
	
    }
}
CHANNEL_EVENT[Projectors,ON_fb]      //create timeline projector auto off
{
    ON:
    {
	  IF(!(TIMELINE_ACTIVE(TL_AutoShutDown)))
	  {
		//commented to hopefully fix shut down issue from 10/10/2006
		TIMELINE_CREATE(TL_AutoShutDown,TL_PrAutoOff,2,TIMELINE_ABSOLUTE,TIMELINE_ONCE)
	  }
	}
    OFF:
    {
	  IF(TIMELINE_ACTIVE(TL_AutoShutDown))
	  {
		TIMELINE_KILL(TL_AutoShutDown)
	  }
    }
}

BUTTON_EVENT[dvTp,0]           	//cancel projector auto off
{
    PUSH:
    {
	  IF(TIMELINE_ACTIVE(TL_AutoShutDown))
		TIMELINE_SET(TL_AutoShutDown,0)
    }
}
TIMELINE_EVENT[TL_AutoShutDown]      //projector auto off
{
    STACK_VAR INTEGER side_sequence
    side_sequence = TIMELINE.SEQUENCE
    
    SWITCH(side_sequence)
    {
	CASE 1:         //warn
	{
	    SEND_COMMAND dvTp,"'@PPN-Projector Auto Off;Main Page'"
	    SEND_COMMAND dvTp,"'ADBEEP'"
	}
	CASE 2:        //turn off side projector
	{
	    SEND_COMMAND dvTp,"'@PPK-Projector Auto Off'"
	    DO_PUSH(dvTP,80)
	}
    }
}
TIMELINE_EVENT[TL_Feedback]       //Feedback
{
  [dvTp,11] = [vdvProjSide,ON_fb]
  [dvTp,12] = ![vdvProjSide,ON_fb]
  
  [dvTp,31] = [vdvProjCenter,ON_fb]
  [dvTp,32] = ![vdvProjCenter,ON_fb]
  
  [dvTp,10] = [vdvProjSide,MUTE_fb]
  [dvTp,30] = [vdvProjCenter,MUTE_fb]

  IF (volume_mute == 1)
  {
	SEND_COMMAND dvTp, '^ANI-72,2,2'
  }
  ELSE
  {
	SEND_COMMAND dvTp, '^ANI-72,1,1'
  }

  IF([vdvProjSide,ON_fb])
  {
	SEND_COMMAND dvTp,"'^ANI-1,3,3'"
  }
  ELSE
  {
	IF(([vdvProjSide,COOLING_fb]))
	{
	  SEND_COMMAND dvTp,"'^ANI-1,4,4'"
	}
  }

  IF([vdvProjCenter,ON_fb])
  {
	SEND_COMMAND dvTp, "'^ANI-2,3,3'"
  }
  ELSE
  {
	IF([vdvProjCenter,COOLING_fb])
	{
	  SEND_COMMAND dvTp, "'^ANI-2,4,4'"
	}
  }

  //FOR SOUTH SCREEN TP SOURCE BUTTON FEEDBACK
	[dvTp,1] = (module_fb_array_video[1] == ComputerFB && ![vdvProjSide,VID_fb])
	[dvTp,2] = (module_fb_array_video[1] == ComputerRack && ![vdvProjSide,VID_fb])
	[dvTp,3] = (module_fb_array_video[1] == LaptopFB && ![vdvProjSide,VID_fb])
	[dvTp,4] = (module_fb_array_video[1] == LaptopRack && ![vdvProjSide,VID_fb])

	[dvTp,5] = (module_fb_array_video[3] == AuxVideoFB && [vdvProjSide,VID_fb])  
	[dvTp,6] = (module_fb_array_video[3] == AuxVideoRack && [vdvProjSide,VID_fb])
	[dvTp,7] = (module_fb_array_video[3] == DVD && [vdvProjSide,VID_fb])
	[dvTp,8] = (module_fb_array_video[3] == VCR && [vdvProjSide,VID_fb])
   
    //FOR WEST SCREEN TP SOURCE BUTTON FEEDBACK
	[dvTp,21] = (module_fb_array_video[2] == ComputerFB && ![vdvProjCenter,VID_fb])
	[dvTp,22] = (module_fb_array_video[2] == ComputerRack && ![vdvProjCenter,VID_fb])
	[dvTp,23] = (module_fb_array_video[2] == LaptopFB && ![vdvProjCenter,VID_fb])
	[dvTp,24] = (module_fb_array_video[2] == LaptopRack && ![vdvProjCenter,VID_fb])
	
	[dvTp,25] = (module_fb_array_video[4] == VCR && [vdvProjCenter,VID_fb])
	[dvTp,26] = (module_fb_array_video[4] == AuxVideoFB && [vdvProjCenter,VID_fb])
	[dvTp,27] = (module_fb_array_video[4] == AuxVideoRack && [vdvProjCenter,VID_fb])
	[dvTp,28] = (module_fb_array_video[4] == DVD && [vdvProjCenter,VID_fb])
	

}
(***********************************************************)
(*            THE ACTUAL PROGRAM GOES BELOW                *)
(***********************************************************)
DEFINE_PROGRAM

(***********************************************************)
(*                     END OF PROGRAM                      *)
(*        DO NOT PUT ANY CODE BELOW THIS COMMENT           *)
(***********************************************************)
