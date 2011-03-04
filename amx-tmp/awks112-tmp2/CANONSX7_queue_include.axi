PROGRAM_NAME='CANONSX7_queue_include'

DEFINE_DEVICE

devicestrings = 33300:3:0	(*1*)
//must be different from all other "devicestrings" virt devs in other queue_include files

DEFINE_VARIABLE

 INTEGER qpc = 150		(*2*)
 //reserved channel on outside file's virtual device to control request queue power
 CHAR cmdTerminator[] = {$00}
  
/* Request modification 1 */
//String literals do not sit well with hex characters in arrays so the following tedious
//method was used

//*NOTE TO CODERS* Recoding this array as such:
// "'REMOTE',$00" or "'REMOTE'$00" should work. 
//CHAR requests[12][25] =
// {
//    {'R','E','M','O','T','E'},
//    {'G','E','T',' ','P','O','W','E','R'},
//    {'G','E','T',' ','E','R','R'},
//    {'G','E','T',' ','M','O','D','E'},
//    {'R','E','M','O','T','E'},
//    {'G','E','T',' ','B','L','A','N','K'},
//    {'G','E','T',' ','I','N','P','U','T'},
//    {'L','O','C','A','L'},
  //  {'G','E','T',' ','H','P','O','S',$00},
  //  {'G','E','T',' ','V','P','O','S',$00},
  //  {'G','E','T',' ','H','P','I','X',$00},
  //  {'G','E','T',' ','V','P','I','X',$00},
  //  {'G','E','T',' ','E','R','R',$00},
  //  {'G','E','T',' ','S','E','L',$00},
  //  {'G','E','T',' ','A','S','P','E','C','T',$00},
  //  {'G','E','T',' ','I','M','A','G','E',$00},
  //  {'G','E','T',' ','B','R','I',$00},
  //  {'G','E','T',' ','C','O','N','T',$00},
  //  {'G','E','T',' ','S','H','A','R','P',$00},
  //  {'G','E','T',' ','G','A','M','M','A',$00},
  //  {'G','E','T',' ','E','R','R',$00},
  //  {'G','E','T',' ','P','R','O','G',$00},
  //  {'G','E','T',' ','S','A','T',$00},
  //  {'G','E','T',' ','H','U','E',$00},
  //  {'G','E','T',' ','L','A','M','P',$00},
  //  {'G','E','T',' ','E','R','R',$00},
  //  {'G','E','T',' ','V','K','S',$00},
  //  {'G','E','T',' ','H','K','S',$00},
  //  {'G','E','T',' ','A','V','O','L',$00},
  //  {'G','E','T',' ','M','U','T','E',$00},
  //  {'G','E','T',' ','I','M','A','G','E','F','L','I','P',$00},
  // {'G','E','T',' ','P','M','M',$00},
  //  {'G','E','T',' ','N','O','S','I','G',$00},
  //  {'G','E','T',' ','N','O','S','H','O','W',$00},
  // {'G','E','T',' ','E','R','R',$00},
  //  {'G','E','T',' ','L','A','N','G',$00},
  //  {'G','E','T',' ','T','E','R','M','I','N','A','L',$00},
  //  {'G','E','T',' ','K','E','Y','L','O','C','K',$00},
  //  {'G','E','T',' ','R','C','C','H',$00},
  //  {'G','E','T',' ','D','P','O','N',$00},
  //  {'G','E','T',' ','E','R','R',$00},
  //  {'G','E','T',' ','N','O','S','H','O','W','S','T','A','T','E',$00},
  //  {'G','E','T',' ','F','R','E','E','Z','E',$00},
  //  {'G','E','T',' ','S','I','G','N','A','L','S','T','A','T','U','S',$00},
  //  {'G','E','T',' ','L','A','M','P','C','O','U','N','T','E','R',$00}
  //  {'G','E','T',' ','P','R','O','D','C','O','D','E',$00}
// }
 
 
 
 
 CHAR requests[12][50]= (*3*)
 
 {
    'GET POWER', //Get power status
    'GET ERR', //11 possible error statuses, refer to Realis manual
    'GET MODE',
    'GET BLANK',
    'GET INPUT'
    }

 //"$0D,$0A" is default if no values assigned
 //max string length = 50; max list size = 50. 
 
 
 LONG queueinterval = 1000    (*4*)
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