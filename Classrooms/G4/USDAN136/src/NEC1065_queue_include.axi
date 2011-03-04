PROGRAM_NAME='NEC1065_queue_include'

DEFINE_DEVICE

devicestrings = 33200:3:0	(*1*)
//must be different from all other "devicestrings" virt devs in other queue_include files

DEFINE_VARIABLE

 INTEGER qpc = 50		(*2*)
 //reserved channel on outside file's virtual device to control request queue power
  
 CHAR requests[50][50]= (*3*)
 
 {
  {$00,$81,$00,$00,$00,$81},              //1 running sense	
	{$00,$C0,$00,$00,$00,$C0},              //2 commom data request		
  {$00,$81,$00,$00,$00,$81},              //1 running sense	
	{$00,$88,$00,$00,$00,$88},              //3 ERROR STATUS REQUEST		
  {$00,$81,$00,$00,$00,$81},              //1 running sense	
	{$03,$8A,$00,$00,$00,$8D}, 
  {$00,$81,$00,$00,$00,$81},              //1 running sense
	{$03,$8C,$00,$00,$00,$8F},              //5 LAMP INFORMATION REQUEST 		037-1
  {$00,$81,$00,$00,$00,$81},              //1 running sense
	{$03,$94,$00,$00,$00,$97},              //6 AMP INFORMATION REQUEST 2	037-2
  {$00,$81,$00,$00,$00,$81},              //1 running sense
	{$03,$95,$00,$00,$00,$98}, 	
  {$00,$81,$00,$00,$00,$81},              //1 running sense
	{$03,$B0,$00,$00,$01,$07,$BB},         	//8 lamp mode request
  {$00,$81,$00,$00,$00,$81},              //1 running sense
	{$03,$8D,$00,$00,$00,$90},              //9 lamp cooling time request
  {$00,$81,$00,$00,$00,$81},              //1 running sense
	{$03,$B0,$00,$00,$01,$08,$BC},          //10 idle mode request
  {$00,$81,$00,$00,$00,$81},              //1 running sense
	{$03,$B0,$00,$00,$01,$09,$BD},          //11 closed caption request 
  {$00,$81,$00,$00,$00,$81},              //1 running sense
	{$03,$96,$00,$00,$02,$00,$01,$9C},	//lampinfo3 - 1
  {$00,$81,$00,$00,$00,$81},              //1 running sense
	{$03,$96,$00,$00,$02,$00,$04,$9F},	//lampinfo3 - 2
  
  {$00,$81,$00,$00,$00,$81},              //1 running sense
	{$03,$96,$00,$00,$02,$00,$08,$A3},	//lampinfo3 - 3
  
  {$00,$81,$00,$00,$00,$81},              //1 running sense
	{$03,$96,$00,$00,$02,$00,$09,$A4},	//lampinfo3 - 4
  {$00,$81,$00,$00,$00,$81},              //1 running sense
	{$03,$96,$00,$00,$02,$00,$0A,$A5},	//lampinfo3 - 5
  {$00,$81,$00,$00,$00,$81},              //1 running sense
	{$03,$96,$00,$00,$02,$00,$10,$AB},	//lampinfo3 - 6
  {$00,$81,$00,$00,$00,$81},              //1 running sense
	{$03,$96,$00,$00,$02,$00,$11,$AC},	//lampinfo3 - 7
  {$00,$81,$00,$00,$00,$81},              //1 running sense
	{$03,$96,$00,$00,$02,$00,$12,$AD},		//lampinfo3 - 8
  {$00,$81,$00,$00,$00,$81}              //1 running sense
 }
 

 //"$0D,$0A" is default if no values assigned
 //max string length = 50; max list size = 50. 
 
 
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

DEFINE_MODULE 'newQmodule' qcm1 (dvreal,devicestrings,requests,queueinterval,requestratio,queuepower) //,rqlist,interval,ratio,RequestQueuePower)

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