PROGRAM_NAME='G3withoutTP'

/* This include file contains code */

DEFINE_DEVICE

virtualprojector = 33001:4:0
virtualextron = 33001:1:0

DEFINE_CONSTANT

VOLATILE INTEGER vdvextron_error_feedback_channels[] =
{
	201,  //invalid channel number
	202,  //slave communication error
	203,  //projector is powered off
	204,  //projector communication error
	205,  //place holder - manual does not list an error 5
	206,  //VLB switch enabled & last input selected
	200   //default error to be thrown if unknown number reported
}

DEFINE_EVENT

CHANNEL_EVENT[virtualextron,vdvextron_error_feedback_channels]
{
    ON:
    {
	STACK_VAR INTEGER thelast
	thelast = 4
	
	SWITCH(thelast)
	{
	    CASE 4:
	    {
		IF([virtualprojector,101])
		    PULSE [virtualprojector,4]
		IF(![virtualprojector,101])
		    PULSE [virtualprojector,1]
	    }
	}
    }
}

