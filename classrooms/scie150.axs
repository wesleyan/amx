PROGRAM_NAME='scie150'
(***********************************************************)
(* System Type : NetLinx                                   *)
(***********************************************************)
(* REV HISTORY:						   *)
(* 10/16/2007 -- Audio problems for Mic and Prog volume    *)
(*   control interference fixed in this version. Fixed last*)
(*	but was not properly uploaded			   *)
(*---------------------------------------------------------*)
/* 8/Nov/2008 -- Adding in extra TP (dvTpOffice) to code for
    Heric's Open House. Should not cause problems even if the
    TP is disconnected. Will be left in code for future use
    unless it causes unforseen problems.
*/   
(***********************************************************)

(***********************************************************)
(*          DEVICE NUMBER DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_DEVICE
//wired devices
dvNecLeft     =    5001:1:0
dvNecCenter       =    5001:2:0
dvNecRight    =    5001:3:0
dvLutron          =    5001:4:0
dvExtron          =    5001:5:0
dvAudioProc       =    5001:6:0
dvDvdBooth        =    5001:7:0
dvRelay           =    5001:8:0
dvVcrFront        =    5001:9:0
dvVcrBooth        =    5001:13:0
dvTpFront         =    128:1:0
dvTpBooth         =    132:1:0
dvTpOffice         =    10001:1:0 //Special Edit for Heric's 12/Nov/2008 Open House
dvScaler1         =    1106:1:0
dvSonyCam         =    1105:1:0
dvScaler2         =    1105:2:0
dvProgVol4        =    1107:1:0
dvProgVol41       =    1107:2:0
dvProgVol42       =    1108:1:0
//dvProgVol43       =    1107:4:0

dvMicVol4         =    1108:2:0 
//dvDocCamera       =    1109:2:0
dvDvdFront        =    1109:1:0
dvWolfVision      =    1109:2:0

   
//proxy devices
vdvNecLeft         =    33500:1:0
vdvNecCenter           =    33501:1:0
vdvNecRight        =    33502:1:0
vdvLutron              =    33503:1:0
vdvAudioProc           =    33504:1:0
vdvDvdBooth            =    33505:1:0
vdvDvdFront            =    33506:1:0
vdvSonyCam             =    33507:1:0 
vdvWebTp               =    10128:1:0  
vdvWebTP1              =    10132:1:0
vdvBogusTP             =    33900:1:0          

(***********************************************************)
(*               INCLUDE FILES GO BELOW                    *)
(***********************************************************)
#INCLUDE 'i!-EmailOut.axi'      // INCLUDE TO SEND EMAIL

(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT
//Video Types
RGB    =    3
YUV    =    4
VID    =    5

Dev leftrightnec[] =
{
    vdvNecRight,
    vdvNecLeft
}

volatile Integer WolfVision[]=
{
    125,    //zoom in
    126,    //zoom out
    127,    //iris open
    128,    //iris close
    129,    //focus+
    130,    //focus-
    131,    //auto focus 
    150,    //arm light
    151,    //boxlight
    152    //image turn  
}
volatile Integer WolfVisionCapture[]=
{
    154,
    155,
    156
}
volatile Integer WolfVisionShow[]=
{
    157,
    158,
    159
}
volatile Integer WolfVisionCommands[]=
{
    $82,
    $81,
    $85,
    $86,
    $84,
    $83,
    $F9,
    $B2,
    $B3,
    $84
}
volatile Integer ProgVol4[]=
{
    234,
    235,
    236
}
volatile Integer MicVol4[]=
{
    231,
    232,
    233
}
volatile Integer screens[]= 
{
    223,    //left screen up
    224,    //left screen down
    221,    //middle screen up
    222,    //middle screen down
    225,    //right screen up
    226,    //right screen down
    101,    //up
    102     //down
}

volatile devchan screencontrol[] =
{
    {dvRelay,2},
    {dvRelay,1},
    {dvRelay,6},
    {dvRelay,5},
    {dvRelay,4},
    {dvRelay,3},
    {dvRelay,7},
    {dvRelay,8}
}
 
volatile Integer inputlookup[]=
{
 //   17,    //PC    
    1,    //PC    
    2,    //Mac
    4,    //Front Laptop 1
    7,    //Front Laptop 2
    3,    //Document Camera
    6,    //VCR
    5,    //DVD Player
    11,   //Aux video in
    9,    //Booth laptop 1
    10,   //Booth laptop 2
    13,   //Booth DVD
    12,   //Booth VCR
    14,    //Back Video     
    20    //Camera
}
volatile Integer inputtypelookup[]=
{
    RGB,
    RGB,
    RGB,
    RGB,
    RGB,
    VID,
    YUV,
    VID,
    RGB,
    RGB,
    YUV,
    VID,
    VID,
    VID
}
volatile Char popuppages[13][4]=
{
    'COMP',
    'COMP',
    'COMP',
    'COMP',
    'DOC',
    'VCR',
    'DVD',
    'COMP',
    'COMP',
    'COMP',
    'DVD',
    'VCR',
    'COMP'    
}

//Timelines
updatetextwindow = 1
frontvcr         = 2
TL_feedback = 3 //NEW STUFF!!!!

//projector response index
ProjectorPower    =    1
ProjectorOff      =    2
ProjectorWarming  =    3
ProjectorCooling  =    4
ProjectorInput1   =    7
ProjectorInput2   =    8
ProjectorInput3   =    9
ProjectorMuteOn   =    10
ProjectorMuteOff  =    11


volatile dev dvTps[]=
{
    vdvWebTp1,
    //vdvWebTp,
    dvTpFront,
    dvTpBooth,
    dvTpOffice
    
}

volatile integer VCRTransportLevel1[] =
{
    120,
    121,
    122,
    123,
    124
}
volatile integer VCRTransportLevel3[]=
{
    190,
    191,
    192,
    193,
    194
}

//Should delete following Array
volatile integer DVDFrontTransport[]=
{
    135,    //PLAY
    136,    //STOP
    137,    //PAUSE
    138,    //Forward
    139,    //Reverse
    140,    //Next
    141,    //Previous
    143,    //UP
    145,    //Left
    142,    //Menu
    146,    //Right
    144,    //Down
    147     //Enter 
}

VOLATILE INTEGER DVD_MENU_NAV[] =   //TP buttons for DVD Denon Player in front rack
{
    143,  //UP
    145,  //LEFT	
    142,  //MENU	
    146, //RIGHT
    144, //DOWN
    147 //ENTER
}

VOLATILE INTEGER DVDfront_transport_inputs[]=	//TP buttons
{
    135,//Play
    137,//PAUSE
    136,//Stop
    138,//FF
    139,//REW
    140,//skip fwd (next)
    141 //skip rev (previous)
    
}
volatile integer DVDBoothTransport[] =
{
    107,
    108,
    109,
    112,
    113,
    110,
    111,
    114,
    115,
    116,
    117,
    118,
    119
}
volatile char DVDTransportLookup[13][30]=
{
    'TRANSPORT=PLAY',            //PLAY
    'TRANSPORT=STOP',            //STOP
    'TRANSPORT=PAUSE',           //PAUSE
    'SCAN=+32',                  //FORWARD
    'SCAN=-32',                  //Reverse
    'TRANSPORT=NEXT',            //Next
    'TRANSPORT=PREVIOUS',        //Previous
    'MENU',                      //MENU
    'CURSOR=UP',                 //UP
    'CURSOR=DOWN',               //Down
    'CURSOR=LEFT',               //Left
    'CURSOR=RIGHT',              //RIGHT
    'ENTER'                      //Enter
}

volatile integer level1rgbinputs[] =
{
    1,
    2,
    4,
    7,
    3
}

volatile integer level1videoinputs[]=
{
    5,
    6,
    11
}

volatile integer level1inputs[]=
{
    1,    //PC
    2,    //MAC
    4,    //Laptop 1
    7,    //Laptop 2
    3,    //Document Camera
    6,    //VCR
    5,    //DVD
    11    //Aux Video
}
volatile integer level2inputs[] =
{
    25,    //PC
    26,    //MAC
    28,    //Laptop 1
    31,    //Laptop 2
    27,    //Document Camera
    30,    //VCR
    29,    //DVD
    35     //Aux Video
}
volatile integer level3inputs[] =
{
    49,    //PC
    50,    //Mac
    52,    //Desk Laptop1
    55,    //Desk Laptop2
    51,    //Document Camera
    54,    //Desk VCR
    53,    //Desk DVD
    59,    //Desk Aux Video
    57,    //Booth Laptop 1
    58,    //Booth Laptop 2
    61,    //Booth DVD
    60,    //Booth VCR
    63,    //Booth AUX
    65    //Sony Camera
}

volatile char updatetextbox[14][50]=
{
    'PC',
    'MAC',
    'Desk Laptop1',
    'Desk Laptop2',
    'Doc Camera',
    'Desk VCR',
    'Desk DVD',
    'Desk Aux Video',
    'Booth Laptop1',
    'Booth Laptop2',
    'Booth DVD',
    'Booth VCR',
    'Booth Aux',
    'Booth Camera'
}

volatile integer level3projectors[] =
{
    215,    //center screen
    216,    //left screen
    217     //right screen
}

Volatile integer lighting[]=
{
       
    241,   //Preset 1
    242,
    243,
    244,   //Preset 4
    240    //All off
}
volatile integer extronrgboutput[]=
{
    10,   //touch screen(front)
    11,   //touch screen(back)
    12,   //monitor
    17,   //ADA listening
    18,   //center plate
    19    //Scan converter
}

volatile integer previewbuttons[]=
{
    205,    //CenterProj
    206,    //Left Proj
    207,    //Right Proj
    208     //Both Proj
}
volatile integer levellookup[] =
{
    1,        //level1
    45,       //professorpage
    46,       //controls page
    2,        //level2
    3,        //level3
    77        //shutdown
    
}
volatile integer pageflipbuttons[] =
{
    171,        //flips to level1
    172,        //flips to professor
    173,        //flips to controls
    174,        //flips to level2
    175         //flips to level3 
}

volatile char pageflippages[5][40] =
{
    'LEVEL1',
    'PROFESSOR',
    'CONTROLS',
    'LEVEL2',                                                                           
    'LEVEL3'
}
volatile integer projectormoduleresponse [] =
{
    21,            //power on            
    22,            //power off                     
    23,            //projector warming
    24,            //projector cooling
    25,            //projector power error
    26,            //projector abnormal temp
    27,            //input 1
    28,            //input 2
    29,            //input 3
    30,            //muteonback
    31             //muteoffback
}
volatile char projectorfeedbackstatements[11][254] =
{
    'Projector is On',
    'Projector is Off',
    'Projector is Warming',
    'Projector is Cooling',
    'Projector Power on Error',
    'Projector at abnormal Temp',
    'Projector on Input1',
    'Projector on Input2',
    'Projector on Input3',
    'Projector Muted',
    'Projector Unmuted'
}

volatile integer NecLeftinputs[] = 
{
    350,
    351,
    354,
    355,
    352,
    353,
    356,
    357   
}

volatile integer necinputs[] = 
{
    371,
    372,
    375,
    376,
    373,
    374,
    377,
    378
}

volatile integer NecRightinputs[] = 
{
    392,
    393,
    396,
    397,
    394,
    395,
    398,
    399
}

(***********************************************************)
(*              DATA TYPE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_TYPE


Structure ReadableProjectorStatus
{
    Char PowerState[254]
    Char InputState[254]
    Char MuteState[254]
    Char LampTime[254] 
}
Structure ProjectorStatus
{
    Integer PowerState
    Integer WarmingState
    Integer CoolingState
    Integer InputState
    Integer CurrentInput
    Integer CurrentInputType
    Integer MuteState
    Integer WaitingInput
    Integer FireOnce
    Integer CoolOnce
    Char poppage[34]
}

Structure ProjectorInputs
{
    Integer rgbin
    Integer yuvin
    Integer vidin
    devchan screen[2]
    devchan lift[2]
}

Structure MatrixInputs
{
    Integer inputs[24]
    Integer inputtypes[24]
}
Structure DocumentCamera
{
    Integer BlueNegativeState
}
(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE
long lTimeArray[1]
ReadableProjectorStatus ReadableNecLeft
ProjectorStatus NecLeft
ReadableProjectorStatus ReadableNecRight
ProjectorStatus NecRight
ReadableProjectorStatus ReadableNecCenter
ProjectorStatus NecCenter
ProjectorInputs NecLeftIns
ProjectorInputs NecRightIns
ProjectorInputs NecCenterIns
MatrixInputs Extroninputs
DocumentCamera wolf
volatile integer currentlevel
volatile integer pagelevel
volatile integer frontvcrstatus
volatile integer input
volatile integer inputtype
volatile dev selectedprojector
volatile integer fireonce //switched projector after warmup
volatile integer test //test variable
volatile integer VolLvl
volatile integer MicVolLvl
volatile integer ProgVol4Mute
volatile integer premutevol
volatile integer MicVol4Mute
volatile integer micpremutevol
volatile integer popupindexkeeper
volatile char poppage3[35]
volatile integer level3index
volatile integer CoolOnce
volatile integer CamZoomLvl
volatile integer thousandth
volatile integer hundreth
volatile integer tenth
volatile integer ones
volatile integer zoomlevel
volatile integer CamYaxis
volatile integer CamXaxis

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

Define_Call 'TouchScreenPreview' (ProjectorStatus ps)
{
    Switch(ps.CurrentInputType)
    {
        Case RGB:
        {
            Stack_Var Integer loopcontrol
            for(loopcontrol=1;loopcontrol<=Max_Length_Array(extronrgboutput);loopcontrol++)
             {
                 Send_String dvExtron,"ITOA(ps.currentinput),'*',ITOA(extronrgboutput[loopcontrol]),'&'"
             }
              
        }
        Case YUV:
        {
            Stack_Var Integer scaledinput
            Send_String dvScaler2,"'2!'"
            Send_String dvExtron,"ITOA(ps.currentinput),'*20&'"    //sends video to scaler1 
            scaledinput = 21
            Send_String dvExtron,"ITOA(scaledinput),'*10&'" //front tp
            Send_String dvExtron,"ITOA(scaledinput),'*11&'" //rear tp
            Send_String dvExtron,"ITOA(scaledinput),'*18&'" //center plate
        }
        Case VID:
        {
            Stack_Var Integer scaledinput
            Send_String dvScaler1,"'1!'"
            Send_String dvExtron,"ITOA(ps.currentinput),'*23&'"    //sends video to scaler1 
            scaledinput = 22
            Send_String dvExtron,"ITOA(scaledinput),'*10&'" //front tp
            Send_String dvExtron,"ITOA(scaledinput),'*11&'" //rear tp
            Send_String dvExtron,"ITOA(scaledinput),'*18&'" //center plate
            
        }
    }//end switch
    Send_Command dvTps,"ps.poppage"

}
Define_Call 'ExtronRGBSwitch' (dev vdvProj,integer input,integer sourcetype,ProjectorInputs pi,ProjectorStatus ps)
//this method takes care of switching the projector to the appropriate input....as well as the 
//extron to appropripate output video channels
{
      
    ps.CurrentInput = input
    ps.CurrentInputType = sourcetype
    if(ps.PowerState == 1)
    {
        Pulse[vdvProj,sourcetype]
    }
    Switch(sourcetype)
    {
        Case RGB:
        {
             Stack_var integer loopcontrol
             Stack_var integer scannedinput
             Send_String dvExtron,"ITOA(input),'*',ITOA(pi.rgbin),'&'"
             for(loopcontrol=1;loopcontrol<=Max_Length_Array(extronrgboutput);loopcontrol++)
             {
                 Send_String dvExtron,"ITOA(input),'*',ITOA(extronrgboutput[loopcontrol]),'&'"
             }
             scannedinput = 23
             Send_String dvExtron,"ITOA(scannedinput),'*15&'"  //to RF
             //Send_String dvExtron,"ITOA(scannedinput),'*24&'" //recording VCR

              
        }
        Case YUV:
        {
            Stack_var integer scaledinput
            Stack_var integer scannedinput
            Send_String dvExtron,"ITOA(input),'*',ITOA(pi.yuvin),'&'"
            Send_String dvScaler2,"'2!'"
            Send_String dvExtron,"ITOA(input),'*20&'"    //sends video to scaler1 
            scaledinput = 21
            Send_String dvExtron,"ITOA(scaledinput),'*10&'" //front tp
            Send_String dvExtron,"ITOA(scaledinput),'*11&'" //rear tp
            Send_String dvExtron,"ITOA(scaledinput),'*18&'" //center plate
            Send_String dvExtron,"ITOA(scaledinput),'*17&'" //center plate
            Send_String dvExtron,"ITOA(scaledinput),'*19&'"//to scanconverter 
            scannedinput = 23
            //Send_String dvExtron,"ITOA(scannedinput),'*24&'" //recording VCR
            Send_String dvExtron,"ITOA(scannedinput),'*15&'" //to RF
        }
        Case VID:
        {
            Stack_var integer scaledinput
            Send_String dvExtron,"ITOA(input),'*',ITOA(pi.vidin),'&'"
            Send_String dvExtron,"ITOA(input),'*15&'"     //to RF
            Send_String dvScaler1,"'1!'"
            //Send_String dvExtron,"ITOA(input),'*24&'"     //recording VCR
            Send_String dvExtron,"ITOA(input),'*23&'"    //sends video to scaler1 
            scaledinput = 22
            Send_String dvExtron,"ITOA(scaledinput),'*10&'" //front tp
            Send_String dvExtron,"ITOA(scaledinput),'*11&'" //rear tp
            Send_String dvExtron,"ITOA(scaledinput),'*18&'" //center plate
            Send_String dvExtron,"ITOA(scaledinput),'*17&'" //center plate
                    
        }
    }//end switch
}//end call

Define_Call 'ExtronAudioSwitch' (integer input)
//this method adjusts the audio outputs appropriately
{
    Send_String dvExtron,"ITOA(input),'*1$'"
    Send_String dvExtron,"ITOA(input),'*23$'"
    Send_String dvExtron,"ITOA(input),'*24$'"
    Send_Command dvTps,"'TEXT4-',updatetextbox[level3index],10,13"
}

Define_Call 'SetProjectors' (Dev Proj,ProjectorStatus ps,ReadableProjectorStatus rps,integer value)
{
//this subroutine sets the appropriate projector environment states to be used later in the program
        Select
        {
            Active(value<5):     
            {     
                  rps.PowerState = projectorfeedbackstatements[value]
                  Switch(value)
                  {
                      Case ProjectorPower:
                      {
                          ps.PowerState = 1
                          ps.WarmingState = 0
                          if(ps.fireonce)
                          {
                              ps.fireonce = 0
                              Pulse[Proj,ps.WaitingInput]
                              ps.WaitingInput = 2
                          }
                      }
                      Case ProjectorOff:
                      {
                          ps.PowerState = 0
                          ps.CoolingState = 0
                          //Send_Command dvTPs,"'PPOF-SHUTDOWN1'"
                          //Send_COmmand dvTPs,"'PPOF-SHUTDOWN2'"
                          //Wait 30
                          //{
                          //    Send_Command dvTPs,"'PPOF-COOLING'"
                          //}
                      }
                      Case ProjectorWarming:
                      {
                          ps.WarmingState = 1
                          if(currentlevel<2)
                          {
                              Send_Command dvTps,"'PPON-WARMING'"
                          }
                          ps.CoolingState = 0
                      }
                      Case ProjectorCooling:
                      {
                          ps.CoolingState = 1
                          ps.WarmingState = 0 
                          //if(CoolOnce)
                          //{
                           //   CoolOnce = 0
                           //   Send_Command dvTps,"'PPON-COOLING'"
                              
                          //}
                      }   
                  }  
            }//end active
            Active((6<value) && (value<10)):
            {
                rps.InputState = projectorfeedbackstatements[get_last(projectormoduleresponse)]
            }//end active
            //Active((10<=value) && (value <=11)):
            //{
            //    rps.MuteState = projectorfeedbackstatements[get_last(projectormoduleresponse)]
            //    Switch(get_last(projectormoduleresponse))
            //    {
            //        Case ProjectorMuteOn:
            //        {
            //            ps.MuteState = 1    
            //        }
            //        Case ProjectorMuteOff:
            //        {
            //            ps.MuteState = 0
            //        }
            //    }
            //}//end active
        }//end select
}//end call

Define_Call 'ProjectorIns'
//this method assigns projector their appropriate input values in the matrix switcher 
{
    Stack_var integer up
    Stack_var integer down
    
    up = 1
    down = 2
    
    NecLeftIns.rgbin             = 1
    NecLeftIns.yuvin             = 2
    NecLeftIns.vidin             = 3
    
    NecLeftIns.screen[up]        = {dvRelay,257} 
    NecLeftIns.screen[down]      = {dvRelay,257}
    NecLeftIns.Lift[up]          = {dvRelay,257}    //this projector has no lift
    NecLeftIns.Lift[down]        = {dvRelay,257}
    
    NecCenterIns.rgbin               = 4
    NecCenterIns.yuvin               = 5
    NecCenterIns.vidin               = 6
    
    NecCenterIns.screen[up]          = {dvRelay,6}
    NecCenterIns.screen[down]        = {dvRelay,5}
    NecCenterIns.Lift[up]            = {dvRelay,7}
    NecCenterIns.Lift[down]          = {dvRelay,8}
    
    NecRightIns.rgbin            = 7                                              
    NecRightIns.yuvin            = 8
    NecRightIns.vidin            = 9
    
    NecRightIns.Screen[up]       = {dvRelay,257}
    NecRightIns.Screen[down]     = {dvRelay,257}
    NecRightIns.Lift[up]         = {dvRelay,257}
    NecRightIns.Lift[down]       = {dvRelay,257} 

}

Define_Call 'ProjPower' (dev vdvProj,ProjectorInputs pi,ProjectorStatus ps,integer sourcetype)
{
    Stack_var integer down
    down   = 2 
    if(ps.PowerState == 0)
    {
        Pulse[vdvProj,ProjectorPower]
        ps.WaitingInput = sourcetype
        ps.fireonce = 1
        //Wait_Until (ps.PowerState == 1) 'ChangeSource' 
        //{    
        //    test = 4
        //    Pulse[vdvProj,sourcetype]
        //}
        Pulse[pi.screen[down]]
        On[pi.lift[down]]
        Wait 390 
        {
            Off[dvRelay,8]
        }    
    //Wait 20
    //{
    //    if(ps.WarmingState == 0)
    //    {
    //        Call 'ProjPower'(vdvProj,pi,ps,sourcetype)
    //    }
    //}
    }//end if
}//end call

Define_Call 'SetFeedback' (integer activebutton,integer buttons[])
{
    Stack_var integer loopcontrol
    for(loopcontrol = 1;loopcontrol<=Max_Length_Array(buttons);loopcontrol++)
    {
        if(buttons[loopcontrol] != activebutton)
        {
            Off[dvTps,buttons[loopcontrol]]
        }
        else
        {
            On[dvTps,buttons[loopcontrol]]
        }
    }
}

Define_Call 'SetOffFeedback' (integer activebutton,integer buttons[])
{
    Stack_var integer loopcontrol
    for(loopcontrol = 1;loopcontrol<=Max_Length_Array(buttons);loopcontrol++)
    {
        if(loopcontrol != activebutton)
        {
            Off[dvTps,buttons[loopcontrol]]
        }
    }
}

Define_Call 'CameraZoom' (integer zoomlevel)
{
    thousandth = (zoomlevel/1000)
    hundreth = ((zoomlevel % 1000)/100)
    tenth = (((zoomlevel % 1000) % 100)/10) 
    ones = ((((zoomlevel % 1000) % 100) %10))
    
    Send_String dvSonyCam,"$81,$01,$04,$47,itohex(thousandth),itohex(hundreth),itohex(tenth),itohex(ones),$FF"
}
Define_Call 'PanCamera' (integer x,integer levelvalue)
{
    local_var integer xlevel
    local_var integer ylevel
    local_var integer xpanspeed
    local_var integer ypanspeed
    local_var integer xdead
    local_var integer ydead
    if(x == 1)
    {
        xlevel = levelvalue
    }
    else
    {
        ylevel = levelvalue
    }
    
    //business logic for speed
    Select
    {
        Active (((0<=xlevel)&&(xlevel<=10)) || ((100>=xlevel) && (xlevel>=91))):
        {
            xpanspeed = $0E
        }
        Active (((11<=xlevel)&&(xlevel<=20)) || ((90>=xlevel) && (xlevel>=81))):
        {
            xpanspeed = $0A
        }
        Active (((21<=xlevel)&&(xlevel<=30)) || ((80>=xlevel) && (xlevel>=71))):
        {
            xpanspeed = $05
        }
        Active (((31<=xlevel)&&(xlevel<=40)) || ((70>=xlevel) && (xlevel>=61))):
        {
            xpanspeed = $02
        }
        Active((41<=xlevel) && (xlevel<=60)):
        {
            xpanspeed = $00
            xdead = 1
        }
    }
    Select
    {
        Active (((0<=ylevel)&&(ylevel<=12)) || ((100>=ylevel) && (ylevel>=88))):
        {
            ypanspeed = $09
        }
        Active (((13<=ylevel)&&(ylevel<=25)) || ((87>=ylevel) && (ylevel>=75))):
        {
            ypanspeed = $05
        }
        Active (((26<=ylevel)&&(ylevel<=38)) || ((74>=ylevel) && (ylevel>=62))):
        {
            ypanspeed = $02
        }
        Active((39<=ylevel) && (ylevel<=61)):
        {
            ypanspeed = 0
            ydead = 0
        }
    }//end select
    
    if(xlevel < 40)
    {
        if(ylevel>62)
        {
            Send_String dvSonyCam,"$81,$01,$06,$01,xpanspeed,ypanspeed,$01,$02,$FF"
        }
        else if(ylevel < 26)
        {
            send_string dvSonyCam,"$81,$01,$06,$01,xpanspeed,ypanspeed,$01,$01,$FF"
        }
        else
        {
            send_string dvSonyCam,"$81,$01,$06,$01,xpanspeed,ypanspeed,$01,$03,$FF"    
        }
    }
    else if(xlevel > 60)
    {
        if(ylevel>62)
        {
            Send_String dvSonyCam,"$81,$01,$06,$01,xpanspeed,ypanspeed,$02,$02,$FF"    
        }
        else if(ylevel<26)
        {
            Send_String dvSonyCam,"$81,$01,$06,$01,xpanspeed,ypanspeed,$02,$01,$FF"
        }
        else
        {
            send_string dvSonyCam,"$81,$01,$06,$01,xpanspeed,ypanspeed,$02,$03,$FF"
        }
    }
    else if(ylevel<26)
    {
        Send_string dvSonyCam,"$81,$01,$06,$01,xpanspeed,ypanspeed,$03,$01,$FF"
    }
    else if(ylevel >62)
    {
        Send_String dvSonyCam,"$81,$01,$06,$01,xpanspeed,ypanspeed,$03,$02,$FF"
    }
    else if((xlevel <= 60) && (xlevel >= 40) && (26<=ylevel) && (ylevel<=62))
    {
        send_string dvSonyCam,"$81,$01,$06,$01,xpanspeed,ypanspeed,$03,$03,$FF"
    }// end else
    
    
    
    
}
(***********************************************************)
(*                STARTUP CODE GOES BELOW                  *)
(***********************************************************)
DEFINE_START 
SmtpSetServer('panja.post.wesleyan.edu')       // SET SMTP SERVER ADDRESS EMAIL

CREATE_LEVEL dvProgVol4,2,VolLvl
CREATE_LEVEL dvMicVol4,1,MicVolLvl 
CREATE_LEVEL dvTPs,5,CamZoomLvl
CREATE_LEVEL dvTps,3,CamXaxis
CREATE_LEVEL dvTps,4,CamYaxis
ProgVol4Mute = 0
wolf.BlueNegativeState = 0 
Send_Command dvProgVol4,"'POL40'"
Send_Command dvMicVol4,"'POL40'"
Send_Level dvTPs,1,40
Send_Level dvTps,1,40  
Send_Command dvTPs,"'@PPX'"
Send_Command dvTps,"'PAGE-WELCOME'"
//Send_Command dvTps,"'TPAGEON'"
Call 'ProjectorIns'
(*timelines below do the following:
   1. Updatetextwindow: updates the projector environment values to their proper states
   2. frontvcr takes care of front vcr feedback.
   3. handles feedback previously sitting in DEFINE_PROGRAM section //NEW STUFF!!!!!!
*)
lTimeArray[1] = 1000
Timeline_create(updatetextwindow,lTimeArray,1,Timeline_Relative,Timeline_Repeat)
lTimeArray[1] = 300
Timeline_Create(frontvcr,lTimeArray,1,Timeline_Relative,Timeline_Repeat)

lTimeArray[1] = 400
TIMELINE_CREATE(TL_feedback,lTimeArray,1,TIMELINE_RELATIVE,TIMELINE_REPEAT)


Define_Module 'NecLeft'   necl(dvNecLeft,vdvNecLeft)
Define_Module 'NECmodule' nec(dvNecCenter,vdvNecCenter)
Define_Module 'NecRight' necr(dvNecRight,vdvNecRight)
//Define_Module 'MarantzProUI' mdlMarantzPro_APP(vdvDvdFront,dvTPs,nBUTTON_ARRAY)
Define_Module 'DenonDVD-DNV300' mdldvdDenon(dvDvdFront,vdvDvdFront)
Define_Module 'MarantzProComm' mdlMarantz(dvDVDBooth,vdvDVDBooth)
Define_Module 'SonyEVI' sony(dvSonyCam,vdvSonyCam)

(***********************************************************)
(*                THE EVENTS GO BELOW                      *)
(***********************************************************)
DEFINE_EVENT
//-------------------------------------------------------------------------------------------------------------------

Data_Event[dvLutron]
{
  Online :
  {
    Send_Command Data.Device,"'SET BAUD 9600,N,8,1 485 DISABLED'"
    Send_Command Data.Device,"'HSOFF'"
  }
  String:
  {
      Select
      {
          Active(Data.Text[5] == '1'):
          {
              On[dvTps,lighting[1]]
              Call 'SetOffFeedback'(1,lighting)
          }
          Active(Data.Text[5] == '2'):
          {
              On[dvTps,lighting[2]]
              Call 'SetOffFeedback'(2,lighting)
          }
          Active(Data.Text[5] == '3'):
          {
              On[dvTps,lighting[3]]
              Call 'SetOffFeedback'(3,lighting)
          }
          Active(Data.Text[5] == '4'):
          {
              On[dvTps,lighting[4]]
              Call 'SetOffFeedback'(4,lighting)
          }
          Active(Data.Text[5] == '0'):
          {
              On[dvTps,lighting[5]]
              Call 'SetOffFeedback'(5,lighting)
          }
      }//end select
    }//string
}

Data_Event[dvProgVol4]
{
    Online:
    {
        //Send_Command dvProgVol4,"'P0R50'"
    }
}

Level_Event[dvProgVol4,2]
{
    VolLvl = Level.Value
    Send_Level dvTps,2,VolLvl
}

Level_Event[dvMicVol4,2]
{
    MicVolLvl = Level.Value
    Send_Level dvTps,1,MicVolLvl
}
Level_Event[dvTps,5]
{
    zoomlevel = level.value
    Call 'CameraZoom' (level.value)    
}
Level_Event[dvTPs,3]
{
    Call 'PanCamera' (1,level.value)
}
Level_Event[dvTps,4]
{
    Call 'PanCamera' (2,level.value)
}
Button_Event[dvTps,238] //fine zoom in
{
    Push:
    {
        if(zoomlevel >= 5500)
        {
            zoomlevel = 5500
        }
        else
        {
            zoomlevel = zoomlevel + 10
        }
        Send_level dvTps,5,zoomlevel
        Call 'CameraZoom' (zoomlevel)   
    }
    Release:
    {
    }
    Hold[1,Repeat]:
    {
        if(zoomlevel >= 5500)
        {
            zoomlevel = 5500
        }
        else
        {
            zoomlevel = zoomlevel + 10   
        }
        Send_level dvTps,5,zoomlevel
        Call 'CameraZoom' (zoomlevel)
    }//end push
}
Button_Event[dvTps,239] //fine zoom out
{
    Push:
    {
        if(zoomlevel <= 0)
        {
            zoomlevel = 0
        }
        else
        {
            zoomlevel = zoomlevel -10
        }
        Send_level dvTps,5,zoomlevel
        Call 'CameraZoom' (zoomlevel)
    }
    Release:
    {
    } 
    Hold[1,Repeat]:
    {
        if(zoomlevel <= 0)
        {
            zoomlevel = 0
        }
        else
        {
            zoomlevel = zoomlevel -10
        }
        Send_level dvTps,5,zoomlevel
        Call 'CameraZoom' (zoomlevel)
    }//end push
} 
Timeline_Event[updatetextwindow]
{
    //Send_Command dvTps,"'TEXT1-',ReadableNecLeft.PowerState"
    //Send_Command dvTps,"'TEXT2-',ReadableNecLeft.InputState"
    //Send_Command dvTps,"'TEXT3-',ReadableNecCenter.PowerState" 
    //Send_Command dvTps,"'TEXT4-',ReadableNecCenter.InputState"
    //Send_Command dvTps,"'TEXT5-',ReadableNecRight.PowerState"
    //Send_Command dvTps,"'TEXT6-',ReadableNecRight.InputState"
}
Timeline_Event[frontvcr]
{
    Stack_var integer loopcontrol
    for(loopcontrol = 1;loopcontrol<=Max_Length_Array(VCRTransportLevel1);loopcontrol++)
    {
        if(loopcontrol != frontvcrstatus)
        {
            Off[dvTps,VCRTransportLevel1[loopcontrol]]
            
        }
        else
        {
            On[dvTps,VCRTransportLevel1[loopcontrol]]
        }
    }
}
//----------------------------------------------------------------------------------------------------------------------
Channel_Event[vdvNecCenter,projectormoduleresponse]
{
    On:
    {
        Call 'SetProjectors' (vdvNecCenter,NecCenter,ReadableNecCenter,get_last(projectormoduleresponse)) 
    }//end on
}

Channel_Event[vdvNecLeft,projectormoduleresponse]
{
    On:
    {
        Call 'SetProjectors' (vdvNecLeft,NecLeft,ReadableNecLeft,get_last(projectormoduleresponse))
    }
}

Channel_Event[vdvNecRight,projectormoduleresponse]
{
    On:
    {
        Call 'SetProjectors' (vdvNecRight,NecRight,ReadableNecRight,get_last(projectormoduleresponse))
    }
}
//--------------------------------------------------------------------------------------------------------------------


Button_Event[dvTps,screens]
{
    Push:
    {
          min_to[screencontrol[get_last(screens)]]
          Call 'SetFeedback' (button.input.channel,screens)
          switch(get_last(screens))
          {
              Case 3:
              {
                  Off[dvTps,227]
              }
              Case 4:
              {
                  Off[dvTps,227]
              } 
          }//end switch
    }//end push
}

Button_Event[dvTps,227]
{
    Push:
    {
        Pulse[dvRelay,5]
        Pulse[dvRelay,6]
        On[dvTps,button.input.channel]
        off[dvTps,221]
        off[dvTps,222]
    }
}

Button_Event[dvTps,pageflipbuttons]
{
//This block of code takes care of all page flips that will need to be called
    Push:
    {
        stack_var char it[100]
        it = pageflippages[get_last(pageflipbuttons)]
        Send_Command dvTps,"'PAGE-',pageflippages[get_last(pageflipbuttons)]" 
        currentlevel = levellookup[get_last(pageflipbuttons)]
    }
}
Button_Event[dvTps,NecLeftinputs]
{
    Push:
    {
        Pulse[vdvNecLeft,get_last(NecLeftinputs)]
    }
}
Button_Event[dvTps,NecRightinputs]
{
    Push:
    {
        Pulse[vdvNecRight,get_last(NecRightinputs)]
    }
}
Button_Event[dvTps,necinputs]
{
    Push:
    {
        Pulse[vdvNecCenter,get_last(necinputs)]
    }
}

Button_Event[dvTps,level1inputs]
{
    Push:
    {
        level3index = get_last(level1inputs)
        input = inputlookup[get_last(level1inputs)]
        inputtype = inputtypelookup[get_last(level1inputs)]
        Call 'ExtronRGBSwitch' (vdvNecCenter,input,inputtype,NecCenterIns,NecCenter)
        Call 'ExtronAudioSwitch' (input)
        Call 'ProjPower' (vdvNecCenter,NecCenterIns,NecCenter,inputtype)
        Send_Command dvTps,"'PPON-',popuppages[get_last(level1inputs)],itoa(currentlevel)" 
        NecCenter.poppage = "popuppages[get_last(level1inputs)]"
        Call 'SetFeedback'(button.input.channel,level1inputs)
    }
}

Button_Event[dvTps,level2inputs]
{
    Push:
    {
        
        //Pulse[vdvNecRight,1]
        //Pulse[vdvNecLeft,1]
        level3index = get_last(level2inputs)
        input = inputlookup[get_last(level2inputs)]
        inputtype = inputtypelookup[get_last(level2inputs)]
        Call 'ExtronRGBSwitch' (vdvNecLeft,input,inputtype,NecLeftIns,NecLeft)
        Call 'ExtronRGBSwitch' (vdvNecRight,input,inputtype,NecRightIns,NecRight)
        Call 'ExtronAudioSwitch' (input)
        Call 'ProjPower' (vdvNecLeft,NecLeftIns,NecLeft,inputtype)
        Call 'ProjPower' (vdvNecRight,NecRightIns,NecRight,inputtype)
        Send_Command dvTps,"'PPON-',popuppages[get_last(level2inputs)],'2'"
        NecLeft.poppage = popuppages[get_last(level2inputs)]
        NecRight.poppage = popuppages[get_last(level2inputs)]
        Call 'SetFeedback'(button.input.channel,level2inputs)   
    }
}

Button_Event[dvTPs,level3inputs]
{
    Push:
    {
        
        stack_var integer theit
        theit = button.input.channel
        level3index = get_last(level3inputs)
        input = inputlookup[get_last(level3inputs)]
        inputtype = inputtypelookup[get_last(level3inputs)]
        if(input == 20)
        {
            Send_String dvExtron,"'20*24&'"
        }
        Call 'SetFeedback'(button.input.channel,level3inputs)
        //SmtpQueMessage("'panja@wesleyan.edu'","'apatel@wesleyan.edu'","'SC150 email test'","'This is a message'","")
        Select
        {
            Active(button.input.channel == 61):
            {
                Send_Command dvTps,"'PPON-DVD3BOOTH'"
                poppage3 = "'PPON-DVD3BOOTH'"
            }
            Active(button.input.channel == 53):
            {
                Send_Command dvTPs,"'PPON-DVD3FRONT'"
                poppage3 = "'PPON-DVD3FRONT'"
            }
            Active(button.input.channel == 60):
            {
                Send_Command dvTps,"'PPON-VCR3BOOTH'"
                poppage3 = "'PPON-VCR3BOOTH'"
            }
            Active(button.input.channel == 54):
            {
                Send_Command dvTPs,"'PPON-VCR3FRONT'"
                poppage3 = "'PPON-VCR3FRONT'"
            }
            Active(button.input.channel == 51):
            {
                Send_Command dvTPs,"'PPON-DOC3'"
                poppage3 = "'PPON-DOC3'"
            }
            Active(button.input.channel == 65):
            {
                Send_Command dvTps,"'PPON-CAMERA3'"
                poppage3 = "'PPON-CAMERA3'"
            }
            Active(1):
            {
                Send_Command dvTPs,"'PPON-COMP3'"
                poppage3 = "'PPON-COMP3'"
            }
        }//end switch
    }//end push
}//end button event
Button_Event[dvTPs,level3projectors]
{
    Push:
    {
	Send_String 0, "'Main-TP channel:',ITOA(get_last(level3projectors))"
        if(input == 20)
        {
            Send_String dvExtron,"ITOA(input),'*24&'"
        }
        else
        {
            Call 'ExtronAudioSwitch' (input)
        }
        Switch(get_last(level3projectors))
        {
            Case 1:
            {
                Call 'ExtronRGBSwitch'(vdvNecCenter,input,inputtype,NecCenterIns,NecCenter)
                Call 'ProjPower'(vdvNecCenter,NecCenterIns,NecCenter,inputtype)
                Send_Command dvTPs,"'TEXT2-',updatetextbox[level3index],10,13" 
                NecCenter.poppage = poppage3
            }
            Case 2:
            {                    
                Call 'ExtronRGBSwitch'(vdvNecLeft,input,inputtype,NecLeftIns,NecLeft)
                Call 'ProjPower' (vdvNecLeft,NecLeftIns,NecLeft,inputtype)
                Send_Command dvTPs,"'TEXT1-',updatetextbox[level3index],10,13"
                NecLeft.poppage = poppage3
            }
            Case 3:
            {
                Call 'ExtronRGBSwitch'(vdvNecRight,input,inputtype,NecRightIns,NecRight)
                Call 'ProjPower' (vdvNecRight,NecRightIns,NecRight,inputtype)
                Send_Command dvTPs,"'TEXT3-',updatetextbox[level3index],10,13"
                NecRight.poppage = poppage3
            }
        }//end switch
    }//end push
}

Button_Event[dvTps,lighting]
{
    Push:
    {
        if(button.input.channel != 240)
        {
            Send_String dvLutron,"':A',ITOA(get_last(lighting)),'1',$0D"
        }
        else
        {
            Send_String dvLutron,"':A01',$0D"
        }
        //Call 'SetFeedback'(button.input.channel,lighting)
    }
}

Button_Event[dvTps,previewbuttons]
{
    Push:
    {
        Switch(button.input.channel)
        {
            Case 205:
            {
                Call 'TouchScreenPreview'(NecCenter)
            }
            Case 206:
            {
                Call 'TouchScreenPreview'(NecLeft)
            }
            Case 207:
            {
                Call 'TouchScreenPreview'(NecRight)
            }
            Case 208:
            {
                Call 'TouchScreenPreview'(NecLeft)
            }
        }
    }
}
Button_Event[dvTps,WolfVision]
{
    Push:
    {        
        Send_String dvWolfVision,"$30"
        Wait 10
        {
        Send_String dvWolfVision,"WolfVisionCommands[get_last(WolfVision)]"
        }
        To[dvTps,button.input.channel]
    }
    Release:
    {
        if(button.input.channel != 131)
        {    
            Send_String dvWolfVision,"$80"
        }
    }
}
Button_Event[dvTPs,254]
{
    Push:
    {
        Send_Command dvTps,"'PPON-SHUTDOWN1'"
    }
}
Button_Event[dvTps,250]
{
    Push:
    {
        if((currentlevel == 3) or (currentlevel ==2))
        {
            Send_Command dvTps,"'PPOF-SHUTDOWN2'"
        }
        else
        {
            Send_Command dvTps,"'PPOF-SHUTDOWN1'"
        }
    }
}
Button_Event[dvTps,251]
{
//turning side screen off
    Push:
    {
        Pulse[vdvNecRight,2]
        Pulse[vdvNecLeft,2]
        Send_Command dvTps,"'PAGE-LEVEL1'"
        CoolOnce = 1
    }
}
Button_Event[dvTps,253]
{//shutdown all projectors
    Push:
    {
        Pulse[vdvNecCenter,ProjectorOff]
        Pulse[vdvNecRight,ProjectorOff]
        Pulse[vdvNecLeft,ProjectorOff]
        Wait 40
        {
            if(NecCenter.CoolingState == 0)
            {
                Pulse[vdvNecCenter,ProjectorOff]
            }
        }
        On[dvRelay,6]
        if(NecCenter.Powerstate != 0)
        {
            On[dvRelay,7]
        }
        Wait 250
        {
            Off[dvRelay,6]
            Off[dvRelay,7]
        }
        Send_Command dvTPs,"'PPOF-SHUTDOWN1'"
        Send_Command dvTps,"'PPOF-SHUTDOWN2'"
        Send_Command dvTPs,"'PAGE-WELCOME'" 
        Send_Command dvTps,"'PPON-COOLING'"
        CoolOnce = 1
    }
}
Button_Event[dvTPs,255]
{//send you to shutdown from level 3
    Push:
    {
        Send_Command dvTps,"'PPON-SHUTDOWN2'"    
    }
}
Button_Event[dvTPs,VCRTransportLevel1]
{
    Push:
    {
        frontvcrstatus = get_last(VCRTransportLevel1)
        Pulse[dvVcrFront,get_last(VCRTransportLevel1)]
    }                                                         
}

Button_Event[dvTPs,VCRTransportLevel3]
{
    Push:
    {
        //frontvcrstatus = get_last(VCRTransportLevel1)
        Pulse[dvVcrFront,get_last(VCRTransportLevel1)]
        Call 'SetFeedback'(button.input.channel,VCRTransportLevel3)
    }
}
//Should delete following button event
(*Button_Event[dvTps,DVDFrontTransport]
{
    Push:
    {
        Stack_Var Integer activebutton
        Send_Command vdvDvdFront,"DVDTransportLookup[get_last(DVDFrontTransport)]"
        if(get_last(DVDFrontTransport)<6)
        {
             activebutton = button.input.channel
             Call 'SetFeedback' (activebutton,DVDFrontTransport)   
        }
        else
        {
            Pulse[dvTps,button.input.channel]
        }
    }
}*)

//Should delete following button event
(*BUTTON_EVENT[dvTps,DVDFrontTransport]  //added for DVD Denon player in front rack
{
    PUSH:
    {
	PULSE[vdvDvdFront,DVDFront_inputs[GET_LAST(DVDFrontTransport)]]
    }
}*)

BUTTON_EVENT[dvTps,DVD_MENU_NAV] // added for DVD Denon player in front rack
{
    PUSH: 
    {
	PULSE[vdvDvdFront,(GET_LAST(DVD_MENU_NAV)+6)]  
	TO [dvTpFront,BUTTON.INPUT.CHANNEL]
    }
}
BUTTON_EVENT[dvTps,DVDfront_transport_inputs]//added for DVD Denon player navigation inputs in front rack		
{
    PUSH:
    {
	PULSE[vdvDvdFront,(GET_LAST(DVDfront_transport_inputs)+13)]
	TO [dvTps,BUTTON.INPUT.CHANNEL]
    }
}

Button_Event[dvTps,DVDBoothTransport]
{
    Push:
    {
        Stack_Var Integer activebutton
        Send_Command vdvDvdBooth,"DVDTransportLookup[get_last(DVDBoothTransport)]"
        if(get_last(DVDBoothTransport)<6)
        {
             activebutton = button.input.channel
             Call 'SetFeedback' (activebutton,DVDBoothTransport)   
        }
        else
        {
            Pulse[dvTps,button.input.channel]
        }
    }
} 
//All Projector Mute buttons will be found below
Button_Event[dvTps,201]
{
    Push:
    {
        
        if(NecCenter.MuteState)
        {
            Pulse[vdvNecCenter,8]    //turns mute off
        }
        else
        {
            Pulse[vdvNecCenter,7]    //mutes projector
        }
        NecCenter.MuteState = Not(NecCenter.MuteState)
            }
} 
Button_Event[dvTps,202]
{
    Push:
    {
        if(NecLeft.MuteState)
        {
            Pulse[vdvNecLeft,8]
        }
        else
        {
            Pulse[vdvNecLeft,7]
        }
        NecLeft.MuteState = Not(NecLeft.MuteState)
    }
}
Button_Event[dvTps,203]
{
    Push:
    {
        if(NecRight.MuteState)
        {
            Pulse[vdvNecRight,8]
        }
        else
        {
            Pulse[vdvNecRight,7]
        }
        NecRight.MuteState = Not(NecRight.MuteState)
    }
}
Button_Event[dvTps,204]
{
    Push:
    {
        
        if(NecLeft.MuteState)
        {
            Pulse[vdvNecLeft,8]    //turns mute off
            Pulse[vdvNecRight,8]
        }
        else
        {
            Pulse[vdvNecLeft,7]
            Pulse[vdvNecRight,7]    //mutes projector
        }
        NecLeft.MuteState = Not(NecLeft.MuteState)
     }//end push
} 
Button_Event[dvTps,ProgVol4]
{
    Push:
    {
         if(get_last(ProgVol4) != 3)
         {
             if(ProgVol4Mute)
             {
                 ProgVol4Mute = 0
                 Send_Command dvProgVol4,"'POL',ITOA(premutevol),'T10'"
                 Send_Command dvProgVol41,"'POL',ITOA(premutevol),'T10'"
                 Send_Command dvProgVol42,"'POL',ITOA(premutevol),'T10'"
		 SEND_COMMAND dvMicVol4,"'P1L',ITOA(premutevol),'T10'"
             }
             To[dvProgVol4,get_last(ProgVol4)]
             To[dvProgVol41,get_last(ProgVol4)]
             To[dvProgVol42,get_last(ProgVol4)]
	     TO[dvMicVol4,get_last(ProgVol4)+3]
             
             
         }
         else
         {
             if(ProgVol4Mute)
             {
                 Send_Command dvProgVol4,"'P0L',ITOA(premutevol),'T10'"
                 Send_Command dvProgVol41,"'POL',ITOA(premutevol),'T10'"
                 Send_Command dvProgVol42,"'POL',ITOA(premutevol),'T10'"
		 SEND_COMMAND dvMicVol4,"'P1L',ITOA(premutevol),'T10'"
                 ProgVol4Mute = 0
             }
             else
             {
                 premutevol = VolLvl
                 Send_Command dvProgVol4,"'P0L0T10'"
                 Send_Command dvProgVol41,"'P0L0T10'"
                 Send_Command dvProgVol42,"'P0L0T10'"
		 SEND_COMMAND dvMicVol4,"'P1L0T10'"
                 ProgVol4Mute = 1
             }
         }
    }
}

Button_Event[dvTps,MicVol4]
{
    Push:
    {
         if(get_last(MicVol4) != 3)
         {
             if(MicVol4Mute)
             {
                 MicVol4Mute = 0
                 Send_Command dvMicVol4,"'P2L',ITOA(micpremutevol),'T10'"
             }
             To[dvMicVol4,get_last(MicVol4)+6]
         }
         else
         {
             if(MicVol4Mute)
             {
                 Send_Command dvMicVol4,"'P2L',ITOA(micpremutevol),'T10'"
                 MicVol4Mute = 0
             }                    
             else
             {
                 micpremutevol = MicVolLvl
                 Send_Command dvMicVol4,"'P2L0T10'"
                 MicVol4Mute = 1
             }
         }
    }
}
Button_Event[dvTPs,153]
{
    Push:
    {
        if(wolf.BlueNegativeState)
        {
            Send_String dvWolfVision,"$31"
            Wait 10
            {
                Send_String dvWolfVision,"$97"
            }
        }
        else
        {
            Wait 10
            { 
                Send_String dvWolfVision,"$99"
            }
        }
    }
}

Button_Event[dvTps,WolfVisionCapture]
{
    Push:
    {
        Send_String dvWolfVision,"$31"
        Pulse[dvTps,Button.input.channel]
        Wait 10
        {
            Send_String dvWolfVision,"$8C"
            Wait 10
            {
                Send_String dvWolfVision,"ITOA(get_last(WolfVisionCapture))"
            }
        }//end outer wait
    }
}
Button_Event[dvTps,WolfVisionShow]
{
    Push:
    {
        Pulse[dvTps,Button.input.channel]
        Wait 10
        {
            Send_String dvWolfVision,"$8D"
            Wait 10
            {
                Send_String dvWolfVision,"ITOA(get_last(WolfVisionShow))"
            }
        }
    }
}

Button_Event[dvTps,189]
//16mm audio button
{
    Push:
    {
        Call 'ExtronAudioSwitch' (19)
    }
}
Button_Event[dvTPs,230]
//Back Button
{
    Push:
    {
        Send_Command dvTps,"'PAGE-WELCOME'"
    }
}
Button_Event[dvTps,246]
{//board lights off
    Push:
    {
        Send_String dvLutron,"':D1567',$0D"
        on[button.input.channel]
        off[dvTps,245]
    }
}
Button_Event[dvTps,245]
{//boards lights on
    Push:
    {
        Send_String dvLutron,"':B1567',$0D"
        on[button.input.channel]
        off[dvTps,246]
    }
}

/* New stuff to be able to telnet in*/

TIMELINE_EVENT[TL_feedback]
{
    
    if(TIME == '02:00:00')
    {
	pulse[vdvNecLeft,2]
	pulse[vdvNecRight,2]
	pulse[vdvNecCenter,2]    
    }
    
    [dvTPs,201] = (NecCenter.MuteState)
    [dvTps,202] = (NecLeft.MuteState)
    [dvTps,203] = (NecRight.MuteState)
    [dvTPs,204] = (NecLeft.MuteState)
    [dvTps,236] = (ProgVol4Mute)
    [dvTps,233] = (MicVol4Mute)
    //SYSTEM_CALL 'VOL1' (vdvBogusTP,234,235,236,dvProgVol4,1,2,3)
    [dvTps,153] = wolf.BlueNegativeState
    
    if(((NecLeft.PowerState == 0) || (NecRight.PowerState == 0)) && (NecCenter.PowerState == 0))
    {
	Send_Command dvTPs,"'PPOF-COOLING'"
    }
    if((NecLeft.WarmingState == 0) && (NecCenter.WarmingState == 0) && (NecRight.WarmingState == 0))
    {
	Send_Command dvTps,"'PPOF-WARMING'"
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

