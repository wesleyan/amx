PROGRAM_NAME='c460_queue_include'

DEFINE_DEVICE

devicestrings = 33201:3:0
//must be different from all other "devicestrings" virt devs in other queue_include files

DEFINE_VARIABLE
 
 //Fake terminator, may have to change
 CHAR cmdTerminator[] = ''

 INTEGER qpc = 105
 //reserved channel on outside file's virtual device to control request queue power
  
 CHAR requests[50][50]=	(*3*)
 {
 	'(PWR?)',
	'(BLK?)',
	'(SRC?)',
	'(LMP?)'
 }
 //"$0D,$0A" is default if no values assigned
 //max string length = 50; max list size = 50. 
 
 
 LONG queueinterval = 1500
 //shortest time strings can be sent to device(milliseconds)
 //default 1000, no less than 250
 
 LONG requestratio = 3
 //rate at which requests are sent to queue in terms of queueinterval
 //default 3
 
 INTEGER queuepower = 1
 // choose 1/0 for queuepower on/off


DEFINE_START

IF(queuepower)
{
  ON[vdvproxy,qpc]
  //enter outside file's virtual device to control request queue power
}
ELSE
{
  OFF[vdvproxy,qpc]
  //enter outside file's virtual device to control request queue power
}

DEFINE_MODULE 'newQmodule' qcm1(dvreal,devicestrings,requests,queueinterval,requestratio,queuepower, cmdTerminator) //,rqlist,interval,ratio,RequestQueuePower)

DEFINE_EVENT

CHANNEL_EVENT[vdvproxy,qpc]
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