MODULE_NAME='ProximaRight'  (dev dvProj,dev vdvProj)
(***********************************************************)
(* System Type : NetLinx                                   *)
(***********************************************************)
(* REV HISTORY:                                            *)
(***********************************************************)

(***********************************************************)
(*          DEVICE NUMBER DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_DEVICE

dvdProj = Dynamic_Virtual_Device

(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT

volatile integer Proj_Powerback				    =    21
volatile integer Proj_Standbyback				=    22
volatile integer Proj_Warmingback				=    23
volatile integer Proj_Coolingback				=    24    
volatile integer Proj_Power_Errorback			=    25
volatile integer Proj_Abnormal_Tempback			=    26
volatile integer Input1back					    =    27
volatile integer Input2back					    =    28 
volatile integer Input3back					    =    29
volatile integer Proj_MuteOnback                =    30                
volatile integer Proj_MuteOffback               =    31

PROJ_ON     = 1
PROJ_OFF    = 2
PROJ_RGB1   = 3
PROJ_RGB2   = 4
PROJ_VID    = 5
PROJ_SVID   = 6
PROJ_MUTE   = 7
PROJ_UNMUTE = 8

volatile integer poweron[] =
{
    1,    //power on
    2     //power off
}

volatile integer inputswitch[] =
{
    3,    //rgb1
    4,    //rgb2
    5,    //video1
    6     //s-video
}

volatile integer mute[] =
{
    7,
    8,
    9,
    10,
    11,
    12
    
}

volatile integer projectorcommand[][] =
{
    {$43,$30,$30},             //POWER ON
    {$43,$30,$31},             //FORCE POWER OFF
    {$43,$30,$35},             //INPUT 1 ANALOG MODE SET
    {$43,$30,$36},             //INPUT 2 RGB(for component in)
    {$43,$30,$37},             //INPUT 2 VideoMode(for VCR's and such)
    {$43,$32,$36},             //INPUT 3 COMPONENT MODE
    {$43,$30,$44},             //muteon
    {$43,$30,$45},             //mute off
    {$43,$52,$30},             //power status
    {$43,$52,$31},             //input mode status
    {$43,$52,$33},             //lamp running time
    {$43,$52,$34}              //Setting Status
}
//timelines
volatile integer feedback1 = 1
volatile integer Proj_Poll1 = 2
(***********************************************************)
(*              DATA TYPE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_TYPE

(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE

Long lTimeArray[1]        //used to store time for timeline

volatile integer Proj_Power
volatile integer Proj_Standby
volatile integer Proj_Warming
volatile integer Proj_Cooling
volatile integer Proj_Power_Error
volatile integer Proj_Abnormal_Temp
volatile integer Input1
volatile integer Input2
volatile integer Input3
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

Define_Function Char[1000] PrintHex(Char cString[])
{
  Stack_Var Char cTString[100],cHexString[1000],cChar;
  
  cTString = cString
  cHexString = '"'
  While(Length_String(cTString))
  {
    cChar = Get_Buffer_Char(cTString);
    cHexString = "cHexString,'$',Itohex(cChar/$10),Itohex(cChar%$10),','"
  }
  Set_Length_String(cHexString,Length_String(cHexString)-1);
  cHexString = "cHexString,'"'";
  Return cHexString;
}
(***********************************************************)
(*                STARTUP CODE GOES BELOW                  *)
(***********************************************************)
DEFINE_START

Translate_Device(dvdProj,vdvProj)
lTimeArray[1] = 1000
TIMELINE_CREATE(FEEDBACK1,lTimeArray,1,TIMELINE_RELATIVE,TIMELINE_REPEAT)
lTimeArray[1] = 5000 // POLL STATUS EVERY 5 SECONDS
TIMELINE_CREATE(PROJ_POLL1,lTimeArray,1,TIMELINE_RELATIVE,TIMELINE_REPEAT)
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
Timeline_Event[PROJ_POLL1]  // EVERY 5 SECONDS
{
  // POWER STATUS POLL
  Send_String dvProj,"$43,$52,$30,$0D" // POLL SYSTEM STATUS
}
Timeline_Event[feedback1]
{
    Select
    {
        Active(Proj_Power):
        {
            Pulse[dvdProj,Proj_Powerback]
        }
        Active(Proj_Standby):
        {
            Pulse[dvdProj,Proj_Standbyback]
        }
        Active(Proj_Warming):
        {
            Pulse[dvdProj,Proj_Warmingback]
        }
        Active(Proj_Cooling):
        {
            Pulse[dvdProj,Proj_Coolingback]
        }
    }// end select
    
    Select
    {
        Active(Input1):
        {
            Pulse[dvdProj,Input1back]
        }
        Active(Input2):
        {
            Pulse[dvdProj,Input2back]
        }
        Active(Input3):
        {
            Pulse[dvdProj,Input3back]
        }
    }
}

Data_Event[dvProj]
{
    Online:
    {
        Send_Command Data.Device,"'SET BAUD 19200 N,8,1 485 DISABLE'"
    }
    String:
    {
        //Send_String vdvWebTP1,"'TEXT7-',DATA.TEXT" 
        //Send_Command vdvWebTp1,"'TEXT7-SOMETHING JUST CAME IN'"
        //Send_Command vdvWebTp1,"'TEXT3-',Data.Text"
        //Send_Command vdvWebTp1,"'TEXT1-Something Just came in'"
        //Send_Command vdvWebTp1,"'TEXT8-',PrintHex(Data.Text)"
        Select
        {
            Active(Length_String(Data.Text) == 3):
            {
                Select
                {
                    Active((Data.Text[1] == $30) && (Data.Text[2] == $30)):
                    {
                        On[Proj_Power]
                        Off[Proj_Warming]
                        //Send_Command vdvWebTp1,"'TEXT7-Projector is on and normal'"
                    }
                    Active((Data.Text[1] == $38) && (Data.Text[2] == $30)):
                    {
                        On[Proj_Standby]
                        Off[Proj_Cooling]
                        //Send_Command vdvWebTp1,"'TEXT7-Projector is in Stand by mode'"
                    }
                    Active((Data.Text[1] == $34) && (Data.Text[2] == $30)):
                    {
                        On[Proj_Warming]
                        Off[Proj_Standby]
                        //Send_Command vdvWebTp1,"'TEXT7-Projector is warming up'"
                    }
                    Active((Data.Text[1] == $32) && (Data.Text[2] == $30)):
                    {
                        On[Proj_Cooling]
                        Off[Proj_Power]
                        //Send_Command vdvWebTp1,"'TEXT7-Projector is cooling down'"
                    }
                    Active((Data.Text[1] == $31) && (Data.Text[2] == $30)):
                    {
                        On[Proj_Power_Error]
                        //Send_Command vdvWebTp1,"'TEXT7-Projector powering up failed'"
                    }                 
                    Active((Data.Text[1] == $32) && (Data.Text[2] == $38)):
                    {
                        //Send_Command vdvWebTp1,"'TEXT7-Projector in cooling down after failed power'"
                    }
                    Active((Data.Text[1] == $30) && (Data.Text[2] == $38)):
                    {
                        On[Proj_Abnormal_Temp]
                        //Send_Command vdvWebTp1,"'TEXT7-Abnormal Temparature'"
                    }                             
                    Active((Data.Text[1] == $38) && (Data.Text[2] == $38)):
                    {
                        Off[Proj_Abnormal_Temp]
                        //Send_Command vdvWebTp1,"'TEXT7-Return to Normal after Abnormal Temp'"
                    }           
                }//end inner huge switch(there has to be a better way)
            }//end master switch active 1
            Active(Length_String(Data.Text) == 2):
            {
                 Select
                 {
                     Active(Data.Text[1] == $30):
                     {
                         On[Input1]
                         Off[Input2]
                         Off[Input3]
                         //Send_Command vdvWebTp1,"'TEXT7-Projector on Input 1'"
                     }                                                        
                     Active(Data.Text[2] == $31):
                     {
                         Off[Input1]
                         On[Input2]
                         Off[Input3]
                         //Send_Command vdvWebTp1,"'TEXT7-Projector on Input 2'"
                     }
                     Active(Data.Text[1] == $32):
                     {
                         Off[Input1]
                         Off[Input2]
                         On[Input3]
                         //Send_Command vdvWebTp1,"'TEXT7-Projector on Input 3'"
                     }
                 }//end inner switch   
            }//end master switch active case 2
        }//end switch
        //ParseResponse(PrintHex(DATA.TEXT))
    }
}//end data event

Channel_Event[dvdProj,poweron]
{
    On:
    {
        Timeline_Pause(Proj_Poll1)
        Send_String dvProj,"projectorcommand[channel.channel],$0D"
        Timeline_Restart(PROJ_POLL1)
    }        
} 

Channel_Event[dvdProj,inputswitch]
{
    On:
    {
        Timeline_Pause(Proj_Poll1)
        Send_String dvProj,"projectorcommand[channel.channel],$0D" 
        Timeline_Restart(PROJ_POLL1)
    }
}

Channel_Event[dvdProj,mute]
{
    On:
    {
        Timeline_Pause(Proj_Poll1)
        Send_String dvProj,"projectorcommand[channel.channel],$0D" 
        Timeline_Restart(PROJ_POLL1)
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


