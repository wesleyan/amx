PROGRAM_NAME='crosspoint_queue_include'

devicestrings = 33200:2:0	(*1*)

DEFINE_VARIABLE

 INTEGER qpc = 105		(*2*)
 CHAR cmdTerminator[] = {13,10} //Decimal ASCII numbers for CRLF, 13=CR 10=LF
 CHAR requests[50][50]=	(*3*)
 {
  'I'
 }
 
 LONG queueinterval = 500 (*4*)
 LONG requestratio = 4		(*5*)
 INTEGER queuepower = 1		(*6*)

DEFINE_START

IF(queuepower)
{
  ON[vdvproxy,qpc]
}
ELSE
{
  OFF[vdvproxy,qpc]
}

DEFINE_MODULE 'newQmodule' qcm1(dvreal,devicestrings,requests,queueinterval,requestratio,queuepower,cmdTerminator) //,rqlist,interval,ratio,RequestQueuePower)

DEFINE_EVENT

CHANNEL_EVENT[vdvproxy,qpc]
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