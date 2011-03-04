PROGRAM_NAME='ExtronSystem10Include'
DEFINE_CONSTANT
VOLATILE INTEGER input_channels[] = 
{
  1,  2, 3, 4, 5, 6, 7, 8, 9,10,   //all
  11,12,13,14,15,16,17,18,19,20,   //audio
  21,22,23,24,25,26,27,28,29,30    //video   
}

VOLATILE INTEGER input_feedback_channels[] =
{
	111,
	112,
	113,
	114,
	115,
	116,
	117,
	118,
	119,
	120,
	
	121,
	122,
	123,
	124,
	125,
	126,
	127,
	128,
	129,
	130
}

VOLATILE INTEGER video_feedback_channels[] =
{
	111,
	112,
	113,
	114,
	115,
	116,
	117,
	118,
	119,
	120
}

VOLATILE INTEGER audio_feedback_channels[] =
{	
	121,
	122,
	123,
	124,
	125,
	126,
	127,
	128,
	129,
	130
}

VOLATILE INTEGER status_feedback_channels[] =
{
	131, //RGB Mute
	141, //Audio Mute
	151, //Executive Mode
	161, //Projector Mute
	171, //Projector Power
	181, //Projector Initializing
	191  //Projector Ending

}	

VOLATILE INTEGER video_type_feedback_channels[] =
{
	196,
	197,
	198,
	199
}

VOLATILE CHAR strExtronSourceInputsType[10][3] =
{
//Input 1: Mac Mini
//Input 2: Podium Laptop
//Input 3: Laptop Rack
//Input 4: DVD
//Input 5: VCR
//Input 6: RCA Podium
//Input 7: RCA Rack
  'RGB',
  'RGB',
  'VID',
  'VID',
  'VID',
  'VID',
  'VID',
  'RGB',
  'RGB',
  'RGB'

}
INTEGER intVolumeStep = 5
DEFINE_VARIABLE
VOLATILE INTEGER intVolumeLevel=0
VOLATILE INTEGER intPreviousVolumeLevel = 0
VOLATILE INTEGER VOLUME_MAX = 150 - intVolumeStep
VOLATILE INTEGER VOLUME_MIN = intVolumeStep
INTEGER intVolumeMaxValue
INTEGER intMaximumVolumeLevel = 100
