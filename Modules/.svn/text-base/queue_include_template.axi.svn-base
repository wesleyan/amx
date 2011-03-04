PROGRAM_NAME='queue_include_template'

DEFINE_DEVICE

devicestrings = (* ie 33200:3:0*)	(*1*)
//must be different from all other "devicestrings" virt devs in other queue_include files

DEFINE_VARIABLE

 INTEGER qpc = (*ie 105 *)		(*2*)
 //reserved channel on outside file's virtual device to control request queue power
  
 CHAR requests[50][50]=	(*3*)
 {
  (*ie
  'i',
  'status?',
  {$0D,$0A}
  *)
 }
 //"$0D,$0A" is default if no values assigned
 //max string length = 50; max list size = 50. 
 
 
 LONG queueinterval = (*ie 500 *)    (*4*)
 //shortest time strings can be sent to device(milliseconds)
 //default 1000, no less than 250
 
 LONG requestratio = (*ie 2 *)	(*5*)
 //rate at which requests are sent to queue in terms of queueinterval
 //default 3
 
 INTEGER queuepower = (*ie 1  *)		(*6*)
 // choose 1/0 for queuepower on/off


DEFINE_START

IF(queuepower)
{
  ON[(* ie vdvproxy *),qpc] (* 7 *)
  //enter outside file's virtual device to control request queue power
}
ELSE
{
  OFF[(*ie vdvproxy *),qpc] (* 8 *) 
  //enter outside file's virtual device to control request queue power
}

DEFINE_MODULE 'newQmodule' qcm1(dvreal,devicestrings,requests,queueinterval,requestratio,queuepower) //,rqlist,interval,ratio,RequestQueuePower)

DEFINE_EVENT

CHANNEL_EVENT[(*ie vdvproxy *),qpc] (* 9 *)
  //enter outside file's virtual device to control request queue power
{
  ON:
  {
	send_string 0, 'queue turned on'
	queuepower = 1
  }
  OFF:
  {
	send_string 0, 'queue turned off'
	queuepower = 0
  }
}