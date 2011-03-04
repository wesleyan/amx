MODULE_NAME='crosspoint_mod' (DEV dvreal, DEV vdvproxy, INTEGER switcher_Vties[50],INTEGER switcher_Aties[50])

DEFINE_DEVICE

#INCLUDE 'crosspoint_queue_include.axi'


(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT

//create input inputs 1- 50
 INTEGER input_inputs[] = 
{
     1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,
    26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50
}

//create output inputs 1 - 50
 INTEGER output_inputs[] = 
{
    51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,
    76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100
}    

//other channels
 INTEGER tie_all = 101
 INTEGER tie_rgbhv = 102
 INTEGER tie_video = 103
 INTEGER tie_audio = 104
 
 INTEGER tietypechannels[] =
 {
  tie_all,
  tie_rgbhv,
  tie_video,
  tie_audio
 }


//timelines
 LONG TL_poll = 1



(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE

 INTEGER outputarray[50]
 
 
//create feedback array
 INTEGER ties_out[50]

//create buffer
 CHAR switcher_buff[5000]
 

DEFINE_FUNCTION INTEGER get_input_input()
{
    STACK_VAR INTEGER count
    STACK_VAR INTEGER chosen_input
    chosen_input = 0;
    
    FOR(count = 1; count <= MAX_LENGTH_ARRAY(input_inputs);count++)
    {
	//check to see if input_input channel turned on
	IF([vdvproxy,input_inputs[count]])
	{
	    //can't have more than 1 input_input channel selected
	    IF(chosen_input)
		RETURN 0
	    chosen_input = count
	}
    }
    RETURN chosen_input

}

DEFINE_FUNCTION INTEGER[50] get_output_input()
{
    STACK_VAR INTEGER count
    STACK_VAR INTEGER chosen_outputs[50]
    SET_LENGTH_ARRAY(chosen_outputs,0)
    
    
    FOR(count = 1; count <= MAX_LENGTH_ARRAY(output_inputs);count++)
    {
	//check to see if input_input channel turned on
	IF([vdvproxy,output_inputs[count]])
	{
	    SET_LENGTH_ARRAY(chosen_outputs,LENGTH_ARRAY(chosen_outputs)+1)
	    chosen_outputs[LENGTH_ARRAY(chosen_outputs)] = count
	}
    }
    RETURN chosen_outputs

}

DEFINE_FUNCTION INTEGER get_output_input2()
{
    STACK_VAR INTEGER count
   
    
    FOR(count = 1; count <= MAX_LENGTH_ARRAY(output_inputs);count++)
    {
	//check to see if input_input channel turned on
	IF([vdvproxy,output_inputs[count]])
	{
	    outputarray[LENGTH_ARRAY(outputarray)+1] = count
	    SET_LENGTH_ARRAY(outputarray,LENGTH_ARRAY(outputarray)+1)
	} 
    }
    RETURN 1

}


DEFINE_FUNCTION INTEGER reset_input_inputs() //set all input_inputs to OFF
{

    STACK_VAR INTEGER count
    FOR(count = 1;count <= MAX_LENGTH_ARRAY(input_inputs);count++)
	OFF[vdvproxy,input_inputs[count]]
    
    RETURN 0
}

DEFINE_FUNCTION INTEGER reset_output_inputs() //set all output_inputs to OFF
{
    STACK_VAR INTEGER count
    FOR(count = 1;count <= MAX_LENGTH_ARRAY(output_inputs);count++)
	OFF[vdvproxy,output_inputs[count]]
    
    RETURN 0
}

DEFINE_FUNCTION make_tie(INTEGER input, INTEGER output,INTEGER tietype)
{
	SWITCH (tietype)
	{
	  CASE tie_all:
	  {
	  	send_string devicestrings, "ITOA(input),'*',ITOA(output),'!'"
	  }
	  CASE tie_rgbhv:
	  {
		send_string devicestrings, "ITOA(input),'*',ITOA(output),'&'"
	  }
	  CASE tie_video:
	  {
		send_string devicestrings, "ITOA(input),'*',ITOA(output),'%'"
	  }
	  CASE tie_audio:
	  {
		send_string devicestrings, "ITOA(input),'*',ITOA(output),'$'"
	  }
	  DEFAULT:
	  {
		send_string 0, 'tie type error '
	  }
	}
	
}

(***********************************************************)
(*                STARTUP CODE GOES BELOW                  *)
(***********************************************************)
DEFINE_START


    
    CREATE_BUFFER dvreal,switcher_buff

(***********************************************************)

(*                THE EVENTS GO BELOW                      *)
(***********************************************************)
DEFINE_EVENT

CHANNEL_EVENT [vdvproxy,input_inputs] //DEBUG
{
    ON:
    {
	send_string 0,"'input selected: ',ITOA(GET_LAST(input_inputs))"
    }
    OFF:
    {
	send_string 0,"'input UNselected: ',ITOA(GET_LAST(input_inputs))"
    }
}

CHANNEL_EVENT [vdvproxy,output_inputs] //DEBUG
{
    ON:
    {
	send_string 0,"'ouput selected: ',ITOA(GET_LAST(output_inputs))"
    }
    OFF:
    {
	send_string 0,"'output UNselected: ',ITOA(GET_LAST(output_inputs))"
    }
}

CHANNEL_EVENT[vdvproxy,tietypechannels]
{
    ON:
    {
	  stack_var integer test1
	  
	  get_output_input2()
	  
	  //make sure ONLY 1 input_inputs selected, more than 0 output_inputs
	  IF(get_input_input() && LENGTH_ARRAY(outputarray))
	  {
		  //send tie string to switcher for each input/output combo
		  FOR(test1 = 1;test1<=LENGTH_ARRAY(outputarray);test1++)
		  {
		  send_string 0,"'tying input ',ITOA(get_input_input()),' to output ',ITOA(outputarray[test1])"
		  make_tie(get_input_input(),outputarray[test1],CHANNEL.CHANNEL)
		  }
	  }
	  ELSE
	  {
		  send_string 0,'Input/output tie misconfig...resetting...please try again'
	  }
	  
	  //clear input/output inputs
	  reset_input_inputs();
	  reset_output_inputs();
	  SET_LENGTH_STRING(outputarray,0)
    }
}

DATA_EVENT[dvreal]
{
  ONLINE:	//set baud rate
  {
	send_command dvreal,'SET BAUD 9600,N,8,1 485 DISABLE'
  }
  STRING:
  {
	STACK_VAR INTEGER end
	STACK_VAR CHAR tempstr[20]
	

	IF(FIND_STRING(switcher_buff,"$0D,$0A",1) ) //find response
	{
	  send_string 0, "'response found: ',switcher_buff"
	  IF(FIND_STRING(switcher_buff,'Out',1) && FIND_STRING(switcher_buff,'In',1) )
	  {	//basic tie response
		STACK_VAR INTEGER whitespace
		STACK_VAR INTEGER ninput
		STACK_VAR INTEGER noutput
		STACK_VAR CHAR switchtype[3]
		
		whitespace = FIND_STRING(switcher_buff,"$20",1)
		noutput = ATOI(REMOVE_STRING(switcher_buff,MID_STRING(switcher_buff,1,whitespace),1))
		whitespace = FIND_STRING(switcher_buff,"$20",1)
		ninput  = ATOI(REMOVE_STRING(switcher_buff,MID_STRING(switcher_buff,1,whitespace),1))
		
		switchtype = LEFT_STRING(switcher_buff,3)
		
		SWITCH(switchtype)
		{
		  CASE 'All':
		  {
			switcher_Vties[noutput] = ninput
			switcher_Aties[noutput] = ninput
		  }
		  CASE 'Vid':
		  CASE 'RGB':
		  {
			switcher_Vties[noutput] = ninput
		  }
		  CASE 'Aud':
		  {
			switcher_Aties[noutput] = ninput
		  }
		}
		send_string 0, "'Input ',ITOA(ninput), ' should go to ', ITOA(noutput), ' . '"
		send_string 0, "'And maybe switch type was ', switchtype"
	  }
	  ELSE
	  {
		send_string 0, 'Dont know what to do with it'
	  }
	  clear_buffer switcher_buff
	}
	ELSE
	{
	  send_string 0,'No recognized response found'
	  CLEAR_BUFFER switcher_buff
	}
  }
}

(***********************************************************)
(*            THE ACTUAL PROGRAM GOES BELOW                *)
(***********************************************************)
DEFINE_PROGRAM

(***********************************************************)
(*                     END OF PROGRAM                      *)
(*        DO NOT PUT ANY CODE BELOW THIS COMMENT           *)
(***********************************************************)

