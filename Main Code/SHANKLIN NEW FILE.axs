PROGRAM_NAME='SHANKLIN 107 NEW'
(***********************************************************)
(* System Type : NetLinx                                   *)
(***********************************************************)
(* REV HISTORY:                                            *)
(***********************************************************)

(***********************************************************)
(*          DEVICE NUMBER DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_DEVICE
dvExtron       = 5001:3:0
vdvExtron      = 33001:3:0

dvVol          = 150:1:0
vdvVol	       = 33150:0:1


dvVCR          = 5001:8:0
dvDVD          = 5001:9:0
dvRelay        = 5001:7:0

dvTp           = 10011:1:0

dvProjSide     = 5001:2:0
vdvProjSide    = 33502:2:0

dvProjCenter   = 5001:1:0
vdvProjCenter  = 33501:1:0



#INCLUDE 'TechPage.axi'
(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT
VOLATILE INTEGER ON_in_proj = 1
VOLATILE INTEGER OFF_in_proj = 4
VOLATILE INTEGER MUTEON_in = 5
VOLATILE INTEGER MUTEOFF_in = 6
VOLATILE INTEGER RGB1_in = 7
VOLATILE INTEGER VID_in = 9

VOLATILE INTEGER MUTE = 0
VOLATILE INTEGER volume_step = 5

VOLATILE LONG TL_Feedback = 1
VOLATILE LONG TL_AutoShutDown = 2

VOLATILE INTEGER PC = 1
VOLATILE INTEGER MAC = 2
VOLATILE INTEGER Laptop1 = 3
VOLATILE INTEGER Laptop2 = 4
VOLATILE INTEGER VCR = 5
VOLATILE INTEGER VCR_CC = 6
VOLATILE INTEGER DVD = 7
VOLATILE INTEGER DocCamera = 8
VOLATILE INTEGER AuxVideo = 9

VOLATILE INTEGER extron_input_channels[] = {1,2,6,7,9,4,5,3,8}
//pc,mac,laptop1,laptop2,doc camera,dvd,vcr,vcr cc,aux video

VOLATILE INTEGER extron_output_channels[] = {51,52,53,54,55,56,57,58}

VOLATILE INTEGER SourceCenter[] = {21,22,23,24,25,26,27,28,29}
VOLATILE INTEGER SourceSide[]   = {1,2,3,4,5,6,7,8,9}
//Sources: PC,MAC,Laptop1,Laptop2,DocCamera,VCR,VCR_CC,DVD,AuxVideo


VOLATILE INTEGER RGBSourceCenter[] = {1,2,3,4,5}
VOLATILE INTEGER VIDSourceCenter[] = {6,7,8,9}
VOLATILE INTEGER RGBSourceSide[]   = {21,22,23,24,25}
VOLATILE INTEGER VIDSourceSide[]   = {26,27,28,29}



VOLATILE DEV Projectors[] = {vdvProjSide, vdvProjCenter}

VOLATILE INTEGER VCRButtons[] = {40,41,42,43,44}
VOLATILE INTEGER DVDButtons[] = {50,51,52,53,54,56,55}
VOLATILE INTEGER DVDPulse_Buttons[] = {1,2,3,4,5,6,7}
VOLATILE INTEGER DVDControls[] = {57,58,59,60,61,62}
VOLATILE INTEGER DVDPulse_Controls[] = {45,46,47,48,50,49}

VOLATILE INTEGER ON_fb = 101
VOLATILE INTEGER COOLING_fb = 102
VOLATILE INTEGER MUTE_fb = 120

VOLATILE INTEGER RGB1_fb = 107
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
(***********************************************************)
(*                THE EVENTS GO BELOW                      *)
(***********************************************************)
DEFINE_EVENT

BUTTON_EVENT [dvTp,SourceCenter] 		//view source center
{  
    PUSH:
    {
	  current_source_center = GET_LAST(SourceCenter)
	  IF(current_source_center <= 5)   	//RGB sources have values less than 5.
	  {
		ON[vdvExtron,extron_input_channels[current_source_center]]
		ON[vdvExtron,51]	   	 	//RGB center projector
		ON[vdvExtron,58]		 	//computer screen
		PULSE[vdvExtron,102]
		
		PULSE[vdvProjCenter,RGB1_in]
		
		SEND_STRING dvExtron, "ITOA (extron_input_channels[current_source_center]),'*1$'"		
	  }
	  ELSE 				 	//all sources greater than 5 are VID sources
	  {
	    ON[vdvExtron,extron_input_channels[current_source_center]]
	    ON[vdvExtron,53]	         	//VID center projector
	    ON[vdvExtron,57]		 	//touch panel video button
	    PULSE[vdvExtron,103]
		
	    PULSE[vdvProjCenter,VID_in]
	    SEND_STRING dvExtron, "ITOA (extron_input_channels[current_source_center]),'*1$'"
	  }
	  (*
	  IF(module_fb_array_audio[1] != current_source_center)
	  {
		ON[vdvExtron,extron_input_channels[current_source_center]]
		ON[vdvExtron,51]
		PULSE[vdvExtron,104]
	  }
	  *)
    }
	
}
BUTTON_EVENT [dvTp,SourceSide]			//view source side
{  
    PUSH:
    {
	  current_source_side = GET_LAST(SourceSide)
	  IF(current_source_side <= 5)		//RGB sources have values less than 5
	  {
	    ON[vdvExtron,extron_input_channels[current_source_side]]
	    ON[vdvExtron,54]			//RGB side projector
	    ON[vdvExtron,58]	   	    //computer screen 
	    PULSE[vdvExtron,102]
		
	    PULSE[vdvProjSide,RGB1_in]
	    
		SEND_STRING dvExtron, "ITOA (extron_input_channels[current_source_side]),'*1$'"
	  }
       ELSE					//all sources greater than 5 are VID sources 
      {
		ON[vdvExtron,extron_input_channels[current_source_side]]
		ON[vdvExtron,56]			//VID side
		ON[vdvExtron,57]			//touch panel video button
		PULSE[vdvExtron,103]
		
		PULSE[vdvProjSide,VID_in]
		
		SEND_STRING dvExtron, "ITOA (extron_input_channels[current_source_side]),'*1$'"
      }
	  
	  (*
	  IF(module_fb_array_audio[1] != current_source_side)
	  {
		ON[vdvExtron,extron_input_channels[current_source_side]]
		ON[vdvExtron,51]
		PULSE[vdvExtron,104]
	  }
	  *)
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
	TO[dvTp,current_dvd_button]
	PULSE[dvDVD,DVDPulse_Buttons[GET_LAST(DVDButtons)]]
    }
}
BUTTON_EVENT[dvTp,DVDControls]					//dvd controls
{
    PUSH:
    {
	current_dvd_control = GET_LAST(DVDControls)
	TO[dvTp,current_dvd_control]
	PULSE[dvDVD,DVDPulse_Controls[GET_LAST(DVDControls)]]
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
		//TIMELINE_CREATE(TL_AutoShutDown,TL_PrAutoOff,2,TIMELINE_ABSOLUTE,TIMELINE_ONCE)
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
  
	[dvTp,1] = (module_fb_array_video[4] == 1 && [vdvProjSide,RGB1_fb])
	[dvTp,2] = (module_fb_array_video[4] == 2 && [vdvProjSide,RGB1_fb])
	[dvTp,3] = (module_fb_array_video[4] == 6 && [vdvProjSide,RGB1_fb])
	[dvTp,4] = (module_fb_array_video[4] == 7 && [vdvProjSide,RGB1_fb])
	[dvTp,5] = (module_fb_array_video[4] == 9 && [vdvProjSide,RGB1_fb])
  
	[dvTp,6] = (module_fb_array_video[6] == 4 && [vdvProjSide,VID_fb])
	[dvTp,7] = (module_fb_array_video[6] == 5 && [vdvProjSide,VID_fb])
	[dvTp,8] = (module_fb_array_video[6] == 3 && [vdvProjSide,VID_fb])
	[dvTp,9] = (module_fb_array_video[6] == 8 && [vdvProjSide,VID_fb])
   
  
  
	[dvTp,21] = (module_fb_array_video[1] == 1 && [vdvProjCenter,RGB1_fb])
	[dvTp,22] = (module_fb_array_video[1] == 2 && [vdvProjCenter,RGB1_fb])
	[dvTp,23] = (module_fb_array_video[1] == 6 && [vdvProjCenter,RGB1_fb])
	[dvTp,24] = (module_fb_array_video[1] == 7 && [vdvProjCenter,RGB1_fb])
	[dvTp,25] = (module_fb_array_video[1] == 9 && [vdvProjCenter,RGB1_fb])
	
	[dvTp,26] = (module_fb_array_video[3] == 4 && [vdvProjCenter,VID_fb])
	[dvTp,27] = (module_fb_array_video[3] == 5 && [vdvProjCenter,VID_fb])
	[dvTp,28] = (module_fb_array_video[3] == 3 && [vdvProjCenter,VID_fb])
	[dvTp,29] = (module_fb_array_video[3] == 8 && [vdvProjCenter,VID_fb])
  
  (*
  IF ([vdvProjSide,RGB1_fb])
  {
	OFF[VIDSourceSide]
	[dvTp,1] = (module_fb_array_video[4] == 1)
	[dvTp,2] = (module_fb_array_video[4] == 2)
	[dvTp,3] = (module_fb_array_video[4] == 6)
	[dvTp,4] = (module_fb_array_video[4] == 7)
	[dvTp,5] = (module_fb_array_video[4] == 9)
  }
  IF ([vdvProjSide,VID_fb])
  {
	OFF[RGBSourceSide]
	[dvTp,6] = (module_fb_array_video[6] == 4)
	[dvTp,7] = (module_fb_array_video[6] == 5)
	[dvTp,8] = (module_fb_array_video[6] == 3)
	[dvTp,9] = (module_fb_array_video[6] == 8)
  }
  IF ([vdvProjCenter,RGB1_fb])
  {
	OFF[VIDSourceCenter]
	[dvTp,21] = (module_fb_array_video[1] == 1)
	[dvTp,22] = (module_fb_array_video[1] == 2)
	[dvTp,23] = (module_fb_array_video[1] == 6)
	[dvTp,24] = (module_fb_array_video[1] == 7)
	[dvTp,25] = (module_fb_array_video[1] == 9)
  }
  IF ([vdvProjCenter,VID_fb])
  {
	OFF[RGBSourceCenter]
	[dvTp,26] = (module_fb_array_video[3] == 4)
	[dvTp,27] = (module_fb_array_video[3] == 5)
	[dvTp,28] = (module_fb_array_video[3] == 3)
	[dvTp,29] = (module_fb_array_video[3] == 8)
  }
  *)
}
(***********************************************************)
(*            THE ACTUAL PROGRAM GOES BELOW                *)
(***********************************************************)
DEFINE_PROGRAM

(***********************************************************)
(*                     END OF PROGRAM                      *)
(*        DO NOT PUT ANY CODE BELOW THIS COMMENT           *)
(***********************************************************)
