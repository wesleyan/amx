PROGRAM_NAME='Eiki-LC-XT4U_queue_include'

DEFINE_DEVICE

devicestrings = 33201:1:0	(*1*)
//must be different from all other "devicestrings" virt devs in other queue_include files

DEFINE_VARIABLE


 INTEGER qpc = 50		(*2*)
 //reserved channel on outside file's virtual device to control request queue power
CHAR cmdTerminator = 13 //The command terminator, usually CRLF. In this case, 13 is the decimal equivalent of $0D in binary.

CHAR requests[50][50]= (*3*)
{
   'CR0', //General Status
   'CR1', //Current Input Mode
   'CR3', //Lamp Read Time Command
   'CR4', //Projection Setting(Desk Rear, Ceiling Front, etc.)
   'CR6', //Temperature Reading inside Projector Box
   'CR7', //Current Lamp Mode
   'CR9', //Current PC Type Read command
   'CRA' //Gets the NO SHOW setting for current input.
 //"$0D,$0A" is default if no values assigne
 //max string length = 50; max list size = 50. 
 }
 
 LONG queueinterval = 500    (*4*)
 //shortest time strings can be sent to device(milliseconds)
 //default 1000, no less than 250
 
 LONG requestratio = 2	(*5*)
 //rate at which requests are sent to queue in terms of queueinterval
 //default 3
 
 INTEGER queuepower = 1		(*6*)
 // choose 1/0 for queuepower on/off


DEFINE_START

IF(queuepower)
{
  ON[vdvProxy,qpc] (* 7 *)
  //enter outside file's virtual device to control request queue power
}
ELSE
{
  OFF[vdvProxy,qpc] (* 8 *) 
  //enter outside file's virtual device to control request queue power
}

DEFINE_MODULE 'newQmodule' qcm1 (dvreal,devicestrings,requests,queueinterval,requestratio,queuepower,cmdTerminator) //,rqlist,interval,ratio,RequestQueuePower)

DEFINE_EVENT

CHANNEL_EVENT[vdvProxy,qpc] (* 9 *)
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