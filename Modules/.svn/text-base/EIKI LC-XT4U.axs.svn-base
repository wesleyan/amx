PROGRAM_NAME='EIKI LC-XT4U'
(***********************************************************)
(***********************************************************)
(*  FILE_LAST_MODIFIED_ON: 04/04/2006  AT: 11:33:16        *)
(***********************************************************)
(* System Type : NetLinx                                   *)
(***********************************************************)
(* REV HISTORY:                                            *)
(***********************************************************)
(*
    $History: $
*)    
(***********************************************************)
(*          DEVICE NUMBER DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_DEVICE
//All Devices need to be passed by main code.
vdvProxy = 33001:1:0
dvReal = 5001:1:57
#INCLUDE 'Eiki-LC-XT4U_queue_include'

(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT

CHAR chrProjectorInputs[] = 
{
    1,2,3,4
}

CHAR chrFunctionalCommands[38][3] =
{
    //The commands for the EIKI are as follows:
    //The letter "C", and then an ASCII representation of a Hex number
    //(not actual Hex). This is then followed by the Hex command for "Carriage Return)$0D
    //Using Line Feed ($0A) totally clears the buffer of any command. Beware!
    
    'C00', //Power On
    'C01', //Immediate Power Off
    'C05', //Input 1 Select
    'C06', //Input 2 Select
    'C07', //Input 3 Select
    'C08', //Input 4 Select
    'C0D', //Video Mute ON
    'C0E', //Video Mute OFF
    'C0F', //Aspect Ratio 4:3
    'C10', //Aspect ration 16:9
    'C1C', //Menu On
    'C1D', //Menu Off
    'C1E', //Display Clear
    'C27', //Switch Image setting (???)
    'C30', //Digital Zoom Increase
    'C31', //Digital Zoom Decrease
    'C3A', //Move Pointer Right
    'C3B', //Move Pointer Left
    'C3C', //Move Pointer Up
    'C3D', //Move Pointer Down
    'C3F', //Enter
    'C43', //Freeze On
    'C44', //Freeze Off
    'C46', //Zoom -
    'C47', //Zoom +
    'C4A', //Focus -
    'C4B', //Focus +
    'C5D', //Lens Shift + 
    'C5E', //Lens Shift -
    'C5F', //Lens Shift Right
    'C60', //Lens Shift Left
    'C70', //Set Full Lamp Mode
    'C71', //Set Half Lamp Mode 1
    'C72', //Set Half Lamp Mode 2
    'C89', //Auto PC Adjust
    'C8A', //Presentation Timer
    'C8E', //Keystone +
    'C8F' //Keystone -
    }
    
CHAR chrStatusReadCommands[8][3] =
{
    'CR0', //Status Read
    'CR1', //Input Mode Read
    'CR3', //Lamp Time Read
    'CR4', //Setting Read (Input Setting)
    'CR6', //Temperature Read
    'CR7', //Lamp Mode Read
    'CR9', //PC Type Read
    'CRA'  //Status 2 Read (Operating status of No Show)
}

CHAR  chrStatusReadFeedback[11][2] =
{
    '00', //Power ON
    '80', //Standby
    '40', //Countdown in Process
    '20', //Cooling Down in Process
    '10', //Power Failure
    '28', //Cooling down due to abnormal temperature(overheat)0
    '02', //Cannot accept RS-232 Commands
    '24', //Power Management Cooling Down
    '04', //Power Management Status
    '21', //Cooling down due to lamp failure
    '81' //Standby after cooling down due to lamp failure
}

CHAR chrStatusInputReadFeedback[4][1] =
{
    '1', //Input 1 Selected
    '2', //Input 2 Selected
    '3', //Input 3 Selected
    '4'  //Input 4 Selected
}

CHAR chrSettingReadFeedback[4][2] =
{
    '11', //Desktop
    '10', //Rear Ceiling Projection
    '01', //Rear Desktop Projection 
    '00'  //Ceiling Front 
}
//Module Input Channel Commands Begin here
VOLATILE INTEGER OnInput = 1  //Power On Input Channel
VOLATILE INTEGER OffInput = 2 //Immediate Power Off Input Channel
VOLATILE INTEGER SelectInput1Input = 3 //Input 1 Select Input Channel
VOLATILE INTEGER SelectInput2Input = 4 //Input 2 Select
VOLATILE INTEGER SelectInput3Input = 5 //Input 3 Select
VOLATILE INTEGER SelectInput4Input = 6 //Input 4 Select
VOLATILE INTEGER VideoMuteOnInput = 7 //Video Mute ON
VOLATILE INTEGER VideoMuteOffInput = 8 //Video Mute OFF
VOLATILE INTEGER StandardAspectRatioInput = 9 //Aspect Ratio 4:3
VOLATILE INTEGER WidescreenAspectRatioInput = 10 //Aspect ratio 16:9
VOLATILE INTEGER MenuOnInput = 11 //Menu On
VOLATILE INTEGER MenuOffInput = 12 //Menu Off
VOLATILE INTEGER DisplayClearInput = 13 //Display Clear
VOLATILE INTEGER SwitchImageInput = 14 //Switch Image setting (???)
VOLATILE INTEGER DigitalZoomIncreaseInput = 15 //Digital Zoom Increase
VOLATILE INTEGER DigitalZoomDecreaseInput = 16 //Digital Zoom Decrease
VOLATILE INTEGER MovePointerRightInput = 17    //Move Pointer Right
VOLATILE INTEGER MovePointerLeftInput = 18     //Move Pointer Left
VOLATILE INTEGER MovePointerUpInput = 19       //Move Pointer Up
VOLATILE INTEGER MovePointerDownInput = 20     //Move Pointer Down
VOLATILE INTEGER EnterButtonInput = 21         //Enter Button Input
VOLATILE INTEGER VideoFreezeOnInput = 22       //Video Freeze On
VOLATILE INTEGER VideoFreezeOffInput = 23      //Video Freeze Off
VOLATILE INTEGER VideoZoomDecreaseInput = 24        //Zoom -
VOLATILE INTEGER VideoZoomIncreaseInput = 25        //Zoom +
VOLATILE INTEGER VideoFocusDecreaseInput = 26       //Focus -
VOLATILE INTEGER VideoFocusIncreaseInput = 27       //Focus +
VOLATILE INTEGER VideoLensShiftUpInput = 28         //Lens Shift + 
VOLATILE INTEGER VideoLensShiftDownInput = 29       //Lens Shift -
VOLATILE INTEGER VideoLensShiftRightInput = 30      //Lens Shift Right
VOLATILE INTEGER VideoLensShiftLeftInput = 31       //Lens Shift Left
VOLATILE INTEGER SetFullLampModeInput = 32          //Set Full Lamp Mode
VOLATILE INTEGER SetHalfLampMode1Input = 33         //Set Half Lamp Mode 1
VOLATILE INTEGER SetHalfLampMode2Input = 34         //Set Half Lamp Mode 2
VOLATILE INTEGER AutoPCAdjustInput = 35             //Auto PC Adjust
VOLATILE INTEGER PresentationTimerToggleInput = 36  //Presentation Timer
VOLATILE INTEGER KeystoneIncreaseInput = 37         //Keystone +
VOLATILE INTEGER KeyStoneDecreaseInput = 38         //Keystone -
VOLATILE INTEGER OnFeedback = 101
VOLATILE INTEGER StandbyFeedback  = 102
VOLATILE INTEGER ProjectorInputChannels[38] = 
{
    OnInput,
    OffInput,
    SelectInput1Input,
    SelectInput2Input,
    SelectInput3Input,
    SelectInput4Input,
    VideoMuteOnInput,
    VideoMuteOffInput,
    StandardAspectRatioInput,
    WidescreenAspectRatioInput,
    MenuOnInput,
    MenuOffInput,
    DisplayClearInput,
    SwitchImageInput,
    DigitalZoomIncreaseInput,
    DigitalZoomDecreaseInput,
    MovePointerRightInput,
    MovePointerLeftInput,
    MovePointerUpInput,
    MovePointerDownInput,
    EnterButtonInput,
    VideoFreezeOnInput,
    VideoFreezeOffInput,
    VideoZoomDecreaseInput,
    VideoZoomIncreaseInput,
    VideoFocusDecreaseInput,
    VideoFocusIncreaseInput,
    VideoLensShiftUpInput,
    VideoLensShiftDownInput,
    VideoLensShiftRightInput,
    VideoLensShiftLeftInput,
    SetFullLampModeInput,
    SetHalfLampMode1Input,
    SetHalfLampMode2Input,
    AutoPCAdjustInput,
    PresentationTimerToggleInput,
    KeystoneIncreaseInput,
    KeystoneDecreaseInput    
}
(***********************************************************)
(*              DATA TYPE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_TYPE

(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE
CHAR ProjectorBuffer[1000]
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

DEFINE_FUNCTION CHAR funcPrepareCommand(CHAR chrCommand[100])
{
    LOCAL_VAR CHAR  chrReturnCharArray[100]
    LOCAL_VAR CHAR  chrEndOfLine[3]
    //Put the End-Of-Line command here:
    chrEndOfLine = "$0D"
    chrReturnCharArray = "chrCommand,chrEndOfLine"
}

(***********************************************************)
(*                STARTUP CODE GOES BELOW                  *)
(***********************************************************)
DEFINE_START
SEND_COMMAND dvReal, 'SET BAUD 19200,N,8,1,8'
CREATE_BUFFER dvReal, ProjectorBuffer
CLEAR_BUFFER ProjectorBuffer

(***********************************************************)
(*                THE EVENTS GO BELOW                      *)
(***********************************************************)
DEFINE_EVENT
CHANNEL_EVENT[vdvProxy,ProjectorInputChannels]
{
    ON:
    //SEND_STRING 0,"'SENDING COMMAND',chrFunctionalCommands[ProjectorInputChannels[GET_LAST(ProjectorInputChannels)]]"
    SEND_STRING devicestrings, chrFunctionalCommands[ProjectorInputChannels[GET_LAST(ProjectorInputChannels)]]
    
}

DATA_EVENT[dvReal]
{
    ONLINE: 
    SEND_COMMAND dvReal, 'SET BAUD 19200,N,8,1,8'
    
    
    STRING:
    {
	STACK_VAR CHAR cmd[100]
	
	SWITCH(ProjectorBuffer[1])
	{
	    CASE $06: //ACK
	    {
	     REMOVE_STRING(ProjectorBuffer,"$0D",1)//Pop the ACK off the buffer. (It will come through as $06$0D)
	    }
	    CASE $0D:
	    {
	     REMOVE_STRING(ProjectorBuffer,"$0D",1)//Pop the $0D off the buffer to remove any errant CRs
	    }
	    DEFAULT:
	    {
		cmd = REMOVE_STRING(ProjectorBuffer,"$0D",1)
		IF(LEFT_STRING(cmd,FIND_STRING(cmd,"$0D",1)) == '00')
		{
		    ON[vdvProxy,OnFeedback]
		}
		ELSE IF(LEFT_STRING(cmd,FIND_STRING(cmd,"$0D",1)) == '80')
		{
		    ON[vdvProxy,StandbyFeedback]
		}
	    }
	}
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
