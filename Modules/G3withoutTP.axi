PROGRAM_NAME='G3withoutTP'

/* This include file contains code */

DEFINE_DEVICE

virtualprojector = 33001:4:0  //matches NEC projector virtual device in FINALnewtest.axs
virtualextron = 33001:1:0     //matches Extron switcher virtual device in FINALnewtest.axs

DEFINE_CONSTANT

VOLATILE INTEGER vdvextron_error_feedback_channels[] = //system8 virtualdevice error feedback channels
{
	201,  //invalid channel number
	202,  //slave communication error
	203,  //projector is powered off
	204,  //projector communication error
	205,  //place holder - manual does not list an error 5
	206,  //VLB switch enabled & last input selected
	200   //default error to be thrown if unknown number reported
}


VOLATILE INTEGER vdvextron_input_feedback_channels[] =  // system8 virtualdevice input feedbackchannels
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

//to make array below more readable
PROJ_RGB1_IN    = 7
PROJ_RGB2_IN    = 8
PROJ_VID_IN     = 9
PROJ_SVID_IN    = 10


VOLATILE INTEGER dac300_extron_inputs[]=  // arrary index = physical extron input number
					  // index value = nec1065 f virtual device input source inputchannel
{
    PROJ_RGB1_IN, //input 1 - pc
    PROJ_RGB1_IN, //input 2 - mac
    PROJ_SVID_IN , //input 3 - dvd
    PROJ_VID_IN, //input 4 - vcr
    PROJ_VID_IN, //input 5 -
    PROJ_VID_IN, //input 6 - 
    PROJ_RGB1_IN, //input 7 -
    PROJ_VID_IN, //input 8 -
    PROJ_RGB1_IN, //input 9 - 
    PROJ_VID_IN //input 10 - Aux rca
}



DEFINE_EVENT

CHANNEL_EVENT[virtualextron,vdvextron_error_feedback_channels]
{
    ON:  //toggle the projector power
    {
	STACK_VAR INTEGER thelast 
	thelast = GET_LAST(vdvextron_error_feedback_channels)
	
	SWITCH(thelast)
	{
	    CASE 3:
	    {
		IF([virtualprojector,101])
		    PULSE [virtualprojector,4]
		IF(![virtualprojector,101])
		    PULSE [virtualprojector,1]
	    }
	}
    }
}

CHANNEL_EVENT[virtualextron,vdvextron_input_feedback_channels]
{
    ON:  //switch input type on the projector (RBG/vid/svid)
    {
	PULSE [virtualprojector,dac300_extron_inputs[GET_LAST(vdvextron_input_feedback_channels)]]
    }
}

