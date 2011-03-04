MODULE_NAME='newQmodule'(DEV dvreal, DEV vdvstringin, CHAR rqlist[50][50], LONG interval, LONG ratio, INTEGER RequestQueuePower,CHAR commandTerminator[100])
(***********************************************************)
(* System Type : NetLinx                                   *)
(***********************************************************)
(* REV HISTORY:                                            *)
(***********************************************************)

(***********************************************************)
(*          DEVICE NUMBER DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_DEVICE

(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT
LONG TL_SENDSTRING  	= 1000
LONG TL_FILLREQUESTQ 	= 1001	

DEFINE_TYPE			
STRUCTURE queueitem
{
	SINTEGER cQID
	CHAR sCommand[15]
	CHAR cQtype
}
(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE
LONG TL_SENDSTRING_interval[1]
LONG TL_FILLREQUESTQ_interval[1]

INTEGER marker_requestqueue = 1 //requestfill loop counter

queueitem _CommandQ[50]  //queue objects
queueitem _RequestQ[50]	 //queue objects


DEFINE_FUNCTION LONG putqueue (CHAR stringin[],CHAR queuetype)
{
	STACK_VAR queueitem newqitem
	STACK_VAR INTEGER result
					  result = 0;
	
	newqitem.cQID = (RANDOM_NUMBER(2000)+1) * (TIME_TO_SECOND(TIME)+1) * (TIME_TO_MINUTE(TIME)+1)
	newqitem.sCommand = stringin
	newqitem.cQtype = queuetype

	IF( !(LENGTH_STRING(stringin)) )
	  RETURN result //0
  
	SWITCH(queuetype)
	{
		CASE 'c':
		CASE 'C':
		{
		  result = 1
		  _CommandQ[LENGTH_ARRAY(_CommandQ)+1] = newqitem
		  SET_LENGTH_ARRAY(_CommandQ,LENGTH_ARRAY(_CommandQ)+1)		
		}
		CASE 'r':
		CASE 'R':
		{
		  result = 2
		  _RequestQ[LENGTH_ARRAY(_RequestQ)+1] = newqitem
		  SET_LENGTH_ARRAY(_RequestQ,LENGTH_ARRAY(_RequestQ)+1)
		}
	}	
	RETURN(result)	//0 - error
}


DEFINE_FUNCTION LONG popQueue(queueitem queueitem_in[])
{
	STACK_VAR queueitem thisitem
	STACK_VAR INTEGER qcount
	
	IF(LENGTH_ARRAY(queueitem_in))
	{
		thisitem = queueitem_in[1]
		Send_string 0, "'CMD- :',thisitem.sCommand,commandTerminator"
		SEND_STRING dvreal, "thisitem.sCommand,commandTerminator"
		
		SWITCH(thisitem.cQtype)
		{
			CASE 'c':
			CASE 'C':
			{
				FOR(qcount = 2; qcount <= LENGTH_ARRAY(_CommandQ); qcount++)
				{
					_CommandQ[qcount-1] = _CommandQ[qcount]
				}
				SET_LENGTH_ARRAY(_CommandQ,LENGTH_ARRAY(_CommandQ)-1)
			}
			CASE 'r':
			CASE 'R':
			{
				FOR(qcount = 2; qcount <= LENGTH_ARRAY(_RequestQ); qcount++)
				{
					_RequestQ[qcount-1] = _RequestQ[qcount]
				}
				SET_LENGTH_ARRAY(_RequestQ,LENGTH_ARRAY(_RequestQ)-1)
			}
		}
		RETURN(LENGTH_ARRAY(queueitem_in)-1)
	}
	ELSE //length 0
	{
		RETURN(0)
	}
}

DEFINE_START

(* use defaults if no values given *)
IF(!(LENGTH_ARRAY(rqlist)))
{
  SET_LENGTH_ARRAY(rqlist,1)
  rqlist[1] = "$0D,$0A"
}

IF(!(interval) OR (interval < 0))
{
  interval = 1000
}

IF(!(ratio) OR (ratio < 0))
{
  ratio = 3
}


//STRING TIMING
TL_SENDSTRING_interval[1] = interval
TL_FILLREQUESTQ_interval[1] = interval * ratio


//create timelines
TIMELINE_CREATE(TL_SENDSTRING,TL_SENDSTRING_interval,1,TIMELINE_RELATIVE,TIMELINE_REPEAT)
TIMELINE_CREATE(TL_FILLREQUESTQ,TL_FILLREQUESTQ_interval,2,TIMELINE_RELATIVE,TIMELINE_REPEAT)

(***********************************************************)
(*                THE EVENTS GO BELOW                      *)
(***********************************************************)
DEFINE_EVENT

DATA_EVENT[vdvstringin]  //virtual device to receive commands from outside
{
  STRING:
  {
	putqueue(DATA.TEXT,'C');
  }
}

TIMELINE_EVENT[TL_SENDSTRING]
{
	//***command queue always has priority over the request queue
	//***request are sent only if there are no commands waiting to be sent

	IF(LENGTH_ARRAY(_CommandQ))
	{
		popqueue(_CommandQ);
	}
	ELSE
	{
	  IF(LENGTH_ARRAY(_RequestQ) && RequestQueuePower)
	  {
		popqueue(_RequestQ);
	  }
	}
}

TIMELINE_EVENT[TL_FILLREQUESTQ]
{
  //fills request queue with Xth item in requestlist and then increments X
  IF(RequestQueuePower)
  {
	putqueue(rqlist[marker_requestqueue],'R');
  
	marker_requestqueue++;
  
	IF(marker_requestqueue > LENGTH_ARRAY(rqlist))		//reset at tail of array
	  marker_requestqueue = 1
  }
}
