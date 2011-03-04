PROGRAM_NAME='MLS506MAVideoSwitcher'
DEFINE_CONSTANT
VOLATILE INTEGER intVSModVolumeChannelFeedback[] = //0% - 100%
{
125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,145,146,147,148,
149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,166,167,168,169,170,171,172,173,174,
175,176,177,178,179,180,181,182,183,184,185,186,187,188,189,190,191,192,193,194,195,196,197,198,199,200,201,
202,203,204,205,206,207,208,209,210,211,212,213,214,215,216,217,218,219,220,221,222,223,224,225
}

VOLATILE INTEGER intExtronSourceInputs[] =  //device input configuration of the extron in the room
{
    1,	//DVD
    0,  // Not used
    1,	//VCR
    4,	//PC
    5,  //Table VGA
    3   //Table RCA
}
VOLATILE CHAR strExtronSourceInputsType[6][3]=
{
    'VID',
    'VID',
    'VID',
    'RGB',
    'RGB',
    'VID'
}

VOLATILE INTEGER intExtronVideoFeedbackChannels[] = //axi
{
    111,
    112,
    113,
    114,
    115,
    116
}

(********************************* EXTRON CONSTANTS *******************************)

//CHANGE MOST - CONSIDER AXI
VOLATILE INTEGER intExtronSignalInputChannels[] = 
{
  1,2,3,4,5,6,7,8,9,10,   //all
  11,12,13,14,15,16,17,18,19,20,   //audio
  21,22,23,24,25,26,27,28,29,30    //video   
}

VOLATILE INTEGER intExtronSignalInputFeedbackChannels[] = 
{
  111,112,113,114,115,116,117,118,119,120
}
(************************************ VOLUME CONSTANTS ****************************)
//****CHANGE****
VOLATILE INTEGER intVolumeStep = 20
VOLATILE DEVCHAN dvchAudioMuteFeedback = {vdvVolumeMod,230}

DEFINE_VARIABLE
VOLATILE INTEGER intVolumeLevel=0
VOLATILE INTEGER intPreviousVolumeLevel = 0
VOLATILE INTEGER VOLUME_MAX = 150 - intVolumeStep
VOLATILE INTEGER VOLUME_MIN = intVolumeStep
INTEGER intVolumeMaxValue
INTEGER intMaximumVolumeLevel = 100
DEFINE_EVENT

/*CHANNEL_EVENT[dvRelay,9] // Cheap Hack! 
{
    ON:
    {
    intVolumeMaxValue = 100
    }
    OFF:
    {
    intVolumeMaxValue = intMaximumVolumeLevel
    }
}*/
/*CHANNEL_EVENT[vdvVolumeMod,intVSModVolumeChannelFeedback]//real time feedback for extron volume display on bargraph
{
    ON:
    {
	STACK_VAR INTEGER activevolume
	activevolume = GET_LAST(intVSModVolumeChannelFeedback) - 1 
	IF (activevolume >= 100)
	{
	    PULSE[vdvVolumeMod,100]
	}
	SEND_LEVEL dvTouchPanel,33,(activevolume*255)/100
	send_string 0,"'VOlume is now ', ITOA((activevolume*255)/100)"
	//SEND_LEVEL dvTouchPanel,3,intConvertExtronVolumeToLevel(activevolume)
    }
}*/

