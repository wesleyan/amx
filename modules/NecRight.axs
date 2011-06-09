MODULE_NAME='NecRight'  (dev dvProj,dev vdvProj)
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

//timelines
volatile integer feedback1 = 1
volatile integer proj_poll1 = 2
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
    11
} 

volatile integer projectorcommand[][] =
{
    {$02,$00,$00,$00,$00,$02},              //on
    {$02,$01,$00,$00,$00,$03},              //off
    {$02,$03,$00,$00,$02,$01,$02,$0A},      //rgb2(PC)
    {$02,$03,$00,$00,$02,$01,$01,$09},      //rgb1(YUV)
    {$02,$03,$00,$00,$02,$01,$06,$0E},      //video1
    {$02,$03,$00,$00,$02,$01,$0B,$13},      //video2
    {$02,$10,$00,$00,$00,$12},              //muteon
    {$02,$11,$00,$00,$00,$13},              //mute off 
    {$00,$C0,$00,$00,$00,$C0},              //poll system status
    {$00,$88,$00,$00,$00,$88},              //poll errors
    {$03,$8C,$00,$00,$00,$8F}               //poll lamp time
}

(***********************************************************)
(*              DATA TYPE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_TYPE

(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE

long lTimeArray[1]

volatile integer test
volatile integer Proj_Power
volatile integer Proj_Standby
volatile integer Proj_Warming
volatile integer Proj_Cooling
volatile integer Proj_Power_Error
volatile integer Proj_Abnormal_Temp
volatile integer Input1
volatile integer Input2
volatile integer Input3
volatile integer Proj_Mute_On
volatile integer Proj_Mute_Off

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
Timeline_Event[feedback1]
{
    Select
    {
        Active(Proj_Power):
        {
            Pulse[dvdProj,Proj_Powerback]
        }
        Active(Proj_Cooling):
        {
            Pulse[dvdProj,Proj_Coolingback]
        }
        Active(Proj_Standby):
        {
            Pulse[dvdProj,Proj_Standbyback]
        }
        Active(Proj_Warming):
        {
            Pulse[dvdProj,Proj_Warmingback]
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
    Select
    {
        Active(Proj_Mute_On):
        {
            Pulse[dvdProj,Proj_MuteOnBack]
        }
        Active(Proj_Mute_Off):
        {
            Pulse[dvdProj,Proj_MuteOffBack]
        }
    }
}
TIMELINE_EVENT[PROJ_POLL1]  // EVERY 5 SECONDS
{
  // POWER STATUS POLL
  Send_String dvProj,"$00,$C0,$00,$00,$00,$C0" // POLL SYSTEM STATUS
}

Data_Event[dvProj]
{
    Online:
    {
        Send_Command Data.Device,"'SET BAUD 9600 N,8,1 485 DISABLE'"
    }
    String:
    {
        //Send_String vdvWebTP1,"'TEXT7-',DATA.TEXT" 
        //Send_Command vdvWebTp1,"'TEXT7-SOMETHING JUST CAME IN'"
        //Send_Command vdvWebTp1,"'TEXT3-',Data.Text"
        //Send_Command vdvWebTp1,"'TEXT1-Something Just came in'"
        //Send_Command vdvWebTp1,"'TEXT8-',Data.Text"
        //Send_Command vdvWebTp1,"'TEXT8-',PrintHex(Data.Text)" 
        
        
        Select
        {
          Active((Data.Text[1]=$20)&&(Data.Text[2]=$C0)): // SYSTEM STATUS POLL RESPONSE
          {
                //IF(!WARMING)
                //Proj_Power = Data.Text[9]
                //Proj_Cooling = Data.Text[10]
                //Proj_Mute = (Data.Text[34] & $0F)
                if(data.text[9])
                {
                    if(NOT(Proj_Warming))
                    {
                        On[Proj_Power]
                        Off[Proj_Standby]
                        test = 1
                    }    
                  //Send_command vdvWebTp1,"'TEXT8-Projector is on'"
                }
                if(data.text[10])
                {
                    On[Proj_Cooling]
                    Off[Proj_Power]
                    test = 2
                    //Send_command vdvWebTp1,"'TEXT8-Projector is cooling'"
                }
                if(!(data.text[10]))
                {
                    if(NOT(Proj_Warming))
                    {
                        Off[Proj_Cooling]
                        On[Proj_Standby]
                        test = 3
                    }
                }
                //if(((data.text[10])==$00) AND ((data.text[9]) == $00))
                //{
                //    Off[Proj_Cooling]
                //    Off[Proj_Power]
                //    On[Proj_Standby]
                //}
                //else
                //Select
                //{
                //    Active(Data.Text[9] == $01):
                 //   {
                //        On[Proj_Power]
                //        Off[Proj_Cooling]
                //        Off[Proj_Standby]
                //    }
                //    Active(Data.Text[10] == $01):
                //    {
                //        On[Proj_Cooling]
                //        Off[Proj_Power]
                //        Off[Proj_Standby]
                //    }
                //    Active((Data.Text[9] == $00) && (Data.Text[10] == $00)):
                //    {
                //        On[Proj_Standby]
                //        Off[Proj_Power]
                //        Off[Proj_Cooling]
                //    }       
                //}               
                
                if(data.text[34] & $0F)
                {
                    On[Proj_Mute_On]
                    //Off[Proj_Mute_Off]
                    //Send_command vdvWebTp1,"'TEXT8-Projector is muted'"
                }
                if(Data.Text[13]=$1)
                {
                    On[Input1]
                    //Send_command vdvWebTp1,"'TEXT7-Projector on RGB1'"
                }
                else if(Data.Text[13]=$2)
                {
                    On[Input2]
                    //Send_command vdvWebTp1,"'TEXT7-Projector on Video1'"    
                }
                   
                else if(Data.Text[13]=$3)
                {
                    On[Input3]
                    //Send_command vdvWebTp1,"'TEXT7-Projector on Svideo'"
                }       
          }//end active
          Active((Data.Text[1]=$20)&&(Data.Text[2]=$10)): // MUTE ON ACK
          {
                On[Proj_Mute_On]
                Off[Proj_Mute_Off]
                //Send_Command vdvWebTp1,"'TEXT7-Mute Acknowleged'"
          }
          Active((Data.Text[1]=$20)&&(Data.Text[2]=$11)): // MUTE OFF ACK
          {
                   On[Proj_Mute_Off]
                   Off[Proj_Mute_On]
                   //Send_Command vdvWebTp1,"'TEXT7-Mute off ack'"
          }
          ACTIVE((Data.Text[1]=$22)&&(Data.Text[2]=$00)): // POWER ON ACK
          {
                On[Proj_Warming]
                Off[Proj_Standby]
                Wait 600 'Kill Warm'
                {
                    Off[Proj_Warming]
                }
                //Send_command vdvWebTp1,"'TEXT7-Power on acknow'"
          }
          Active((Data.Text[1]=$A2)&&(Data.Text[2]=$01)): // POWER OFF NACK
          {
                On[Proj_Power_Error]
                //Send_command vdvWebTp1,"'TEXT7-Power on not acknow'"
          }
          //ACTIVE((Data.Text[1]=$23)&&(Data.Text[2]=$8C)): // LAMP TIME RESPONSE
          //{
          //  lLampSeconds = Data.Text[6] + Data.Text[7]*256 + Data.Text[8]*65536 + Data.Text[9]*16777216
           // lLampSeconds = lLampSeconds + Data.Text[10] + Data.Text[11]*256 + Data.Text[12]*65536 + Data.Text[13]*16777216
            //SEND_STRING vdProj,"ITOA(lLampSeconds),13,10"
          //}
          //ACTIVE((Data.Text[1]=$20)&&(Data.Text[2]=$88)): // ERROR RESPONSE
          //{
          //  COVER_OPEN = Data.Text[6] & $01
          //  TEMP_FAULT = Data.Text[6] & $02
          //  FAN_STOP   = Data.Text[6] & $08
           // PWR_SUPPLY = Data.Text[6] & $20
            //LAMP_FAIL  = Data.Text[6] & $40
          //}
        }//end switch    
    }//string
}//end data event

Channel_Event[dvdProj,poweron]
{
    On:
    {
        Timeline_Pause(PROJ_POLL1)
        Send_String dvProj,"projectorcommand[channel.channel]" 
        Timeline_Restart(PROJ_POLL1)
    }
}
Channel_Event[dvdProj,inputswitch]
{
    On:
    {
        Timeline_Pause(PROJ_POLL1)
        Send_String dvProj,"projectorcommand[channel.channel]" 
        Timeline_Restart(PROJ_POLL1)
    }
}
Channel_Event[dvdProj,mute]
{
    On:
    {
        Timeline_Pause(PROJ_POLL1)
        Send_String dvProj,"projectorcommand[channel.channel]" 
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

