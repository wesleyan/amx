MODULE_NAME='DVDIRModule'(dev dvDVD, dev vdvDVD, INTEGER transport_inputs[], INTEGER dvd_menu_nav[])

(***********************************************************)
(***********************************************************)
(*  FILE_LAST_MODIFIED_ON: 04/04/2006  AT: 11:33:16        *)
(***********************************************************)
(* System Type : NetLinx                                   *)
(***********************************************************)
(* REV HISTORY:                                            *)
(***********************************************************)
(*
    $History: $
*)    
(***********************************************************)
(*          DEVICE NUMBER DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_DEVICE

(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT

VOLATILE INTEGER TRANSPORT_RC_CODES[]=
{
    1, //Play
    3, //Pause
    2, //Stop
    6, //FF
    7, //REW
    4, //skip fwd
    5  //skip rev
}

VOLATILE INTEGER DVD_MENU_NAV_RC_CODES[] =
{
    45, //UP
    47, //LEFT
    44, //MENU
    48, //RIGHT
    46,	//DOWN
    49, //ENTER
    80,  //EJECT
    51 //Top menu
}

(***********************************************************)
(*              DATA TYPE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_TYPE

(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE

(***********************************************************)
(*               LATCHING DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_LATCHING

(***********************************************************)
(*       MUTUALLY EXCLUSIVE DEFINITIONS GO BELOW           *)
(***********************************************************)
DEFINE_MUTUALLY_EXCLUSIVE

(***********************************************************)
(*        SUBROUTINE/FUNCTION DEFINITIONS GO BELOW         *)
(***********************************************************)
(* EXAMPLE: DEFINE_FUNCTION <RETURN_TYPE> <NAME> (<PARAMETERS>) *)
(* EXAMPLE: DEFINE_CALL '<NAME>' (<PARAMETERS>) *)

(***********************************************************)
(*                STARTUP CODE GOES BELOW                  *)
(***********************************************************)
DEFINE_START

PULSE[dvDVD, 9] //turn the DVD player on

(***********************************************************)
(*                THE EVENTS GO BELOW                      *)
(***********************************************************)
DEFINE_EVENT

CHANNEL_EVENT[vdvDVD,transport_inputs]
{
    ON:
    {
	PULSE[dvDVD, transport_rc_codes[get_last(transport_inputs)]]
    }
}

CHANNEL_EVENT[vdvDVD,DVD_MENU_NAV]
{
    ON:
    {
	PULSE[dvDVD, dvd_menu_nav_rc_codes[get_last(dvd_menu_nav)]]
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
