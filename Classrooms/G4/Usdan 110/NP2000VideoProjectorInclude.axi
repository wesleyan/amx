PROGRAM_NAME='NP2000VideoProjectorInclude'
DEFINE_CONSTANT
VOLATILE INTEGER intProjectorOnInput = 1
VOLATILE INTEGER intProjectorOffInput = 4
VOLATILE INTEGER intProjectorMuteOnInput = 5
VOLATILE INTEGER intProjectorMuteOffInput = 6

VOLATILE INTEGER intMonitorDeviceStatus = 50

VOLATILE INTEGER ACTION_group[]=
{
	intProjectorOnInput,
	intProjectorOffInput,
	intProjectorMuteOnInput,
	intProjectorMuteOffInput
}
//Controls for intput sources on the projector.
VOLATILE INTEGER intProjectorRGB1InputChannel     = 7
VOLATILE INTEGER intProjectorRGB2InputChannel     = 8
VOLATILE INTEGER intProjectorVideoInputChannel    = 9
VOLATILE INTEGER intProjectorSVideoInputChannel   = 10
VOLATILE INTEGER intProjectorDigitalInputChannel  = 11
VOLATILE INTEGER intProjectorViewerInputChannel   = 12
VOLATILE INTEGER intProjectorComputerInputChannel = 13
VOLATILE INTEGER intProjectorLANInputChannel      = 14

/**********    STATUS & Feedback      **************/

VOLATILE INTEGER intProjectorOnFeedbackChannel      = 101
VOLATILE INTEGER intProjectorCoolingFeedbackChannel = 102
VOLATILE INTEGER intProjectorMuteFeedbackChannel    = 120

VOLATILE INTEGER intProjectorStatusArray[]= 
{
    intProjectorOnFeedbackChannel,
    intProjectorCoolingFeedbackChannel,
    intProjectorMuteFeedbackChannel
}
VOLATILE INTEGER intTouchPanelProjectorStatusIndicatorStates[]=
{
    //These numbers correspond to the various active states of the Projector Status text on the touchpanel
    1,//Projector is On
    2,//Projector is Cooling
    3,//Projector is Muted
    4 //Projector is Off
}



//INPUT SOURCES feedback
VOLATILE INTEGER intProjectorRGB1FeedbackChannel     = 107
VOLATILE INTEGER intProjectorRGB2FeedbackChannel     = 108
VOLATILE INTEGER intProjectorVideoFeedbackChannel    = 109
VOLATILE INTEGER intProjectorSVideoFeedbackChannel   = 110
VOLATILE INTEGER intProjectorDigitalFeedbackChannel  = 111
VOLATILE INTEGER intProjectorViewerFeedbackChannel   = 112
VOLATILE INTEGER intProjectorComputerFeedbackChannel = 113
VOLATILE INTEGER intProjectorLANFeedbackChannel      = 114

VOLATILE INTEGER source_type_fbchan[] = //formerly input_type_feedback_channels[] = 
{
	intProjectorRGB1FeedbackChannel,
	intProjectorRGB2FeedbackChannel,
	intProjectorVideoFeedbackChannel,
	intProjectorSVideoFeedbackChannel,
	intProjectorDigitalFeedbackChannel,
	intProjectorViewerFeedbackChannel,
	intProjectorComputerFeedbackChannel,
	intProjectorLANFeedbackChannel
}

VOLATILE INTEGER intProjectorErrorCoverOpenFeedbackChannel = 201
VOLATILE INTEGER intProjectorErrorTemperatureFaultFeedbackChannel = 202
VOLATILE INTEGER intProjectorErrorFanStopFeedbackChannel = 203
VOLATILE INTEGER intProjectorErrorPowerSupplyFeedbackChannel = 204
VOLATILE INTEGER intProjectorErrorLampFailureFeedbackChannel = 205
VOLATILE INTEGER intProjectorCommunicationsActiveFeedbackChannel = 255

VOLATILE INTEGER ERR_group[]=
{
	intProjectorErrorCoverOpenFeedbackChannel,
	intProjectorErrorTemperatureFaultFeedbackChannel,
	intProjectorErrorFanStopFeedbackChannel,
	intProjectorErrorPowerSupplyFeedbackChannel,
	intProjectorErrorLampFailureFeedbackChannel,
	intProjectorCommunicationsActiveFeedbackChannel
}


VOLATILE INTEGER intProjectorClosedCaptionDetailFeedbackChannels[] = 
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
