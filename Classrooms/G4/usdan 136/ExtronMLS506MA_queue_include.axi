PROGRAM_NAME='mls506_queue_include'

devicestrings = 33200:1:0	(*1*)

DEFINE_VARIABLE

 INTEGER qpc = 45		(*2*)

 CHAR requests[50][50]=	(*3*)
 {
	'I','V'
 }
 
 
 LONG queueinterval = 400   (*4*)
 LONG requestratio = 2		(*5*)
 INTEGER queuepower = 1		(*6*)

DEFINE_START

IF(queuepower)
{
  ON[vdvVSmod,qpc]		(*7*)
}
ELSE
{
  OFF[vdvVSmod,qpc]		(*8*)
}

DEFINE_MODULE 'newQmoduleExtron' qcm1 (dvreal,devicestrings,requests,queueinterval,requestratio,queuepower) //,rqlist,interval,ratio,RequestQueuePower)

DEFINE_EVENT

CHANNEL_EVENT[vdvVSmod,qpc] (*9*)
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