MODULE_NAME='ProjectorFeedback' (dev vdvProjector, dev vdvTouchPanel)
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

(***********************************************************)
(*              DATA TYPE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_TYPE

(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE

VOLATILE INTEGER power = 0
VOLATILE INTEGER mute = 0
VOLATILE INTEGER cooling = 0
VOLATILE INTEGER warming = 0

VOLATILE INTEGER last = -1

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

SEND_COMMAND vdvProjector, 'BAUD=9600'

(***********************************************************)
(*                THE EVENTS GO BELOW                      *)
(***********************************************************)
DEFINE_EVENT

DATA_EVENT[vdvProjector]
{
    STRING:
    {
        STACK_VAR CHAR cCMD[35]
        
        SEND_STRING 0, "'UI RECEIVED FROM COMM: ',DATA.TEXT"
        IF(FIND_STRING(DATA.TEXT, '=', 1)) { cCMD = REMOVE_STRING(DATA.TEXT, '=', 1) }        
        ELSE { cCMD = DATA.TEXT }
        SWITCH(cCMD)
        {
            // FIND MATCHING STRING AND PARSE REST OF MESSAGE. PROVIDE FEEDBACK TO THE 
            // TOUCH PANEL.
            /*CASE 'ASPECT=':
            {
                STACK_VAR INTEGER nASPECT
                STACK_VAR CHAR cTYPE
                
                nASPECT = ATOI(DATA.TEXT)
                REMOVE_STRING(DATA.TEXT, ':', 1)
                cTYPE = GET_BUFFER_CHAR(DATA.TEXT)
                IF (cTYPE == 'I') { nASPECT_I = nASPECT }
                ELSE IF (cTYPE == 'D') { nASPECT_D = nASPECT }
            }
            CASE 'BACKGROUND=': { nBACKGROUND = ATOI(DATA.TEXT) }
            CASE 'BAUD=': { SEND_COMMAND dvTP, "'@TXT',1, DATA.TEXT" }
            CASE 'BRIGHTNESS=':
            {
                IF (nDEVICE_SCALE) { slBRIGHTNESS = ATOI(DATA.TEXT) }
                ELSE { slBRIGHTNESS = Scale_Range(ATOI(DATA.TEXT), 0, 100, 0, 255) }
                IF (nACTIVE_LEVEL1 == BRIGHTNESS)
                {
                    IF (nDEVICE_SCALE) { SEND_COMMAND dvTP, "'@TXT', 4, ITOA(slBRIGHTNESS)" }
                    ELSE { SEND_COMMAND dvTP, "'@TXT', 4, DATA.TEXT" }
                    SEND_LEVEL dvTP, 1, slBRIGHTNESS
                }
                nENABLE_LEVEL1 = 0
                CANCEL_WAIT 'ENABLE LEVEL 1'
                WAIT 3 'ENABLE LEVEL 1' { nENABLE_LEVEL1 = 1 } // REMOVES UNDESIRABLE ECHO FEEDBACK
            }
            CASE 'COLOR=':
            {
                IF (nDEVICE_SCALE) { nCOLOR = ATOI(DATA.TEXT) }
                ELSE { nCOLOR = TYPE_CAST(Scale_Range(ATOI(DATA.TEXT), 0, 100, 0, 95)) }
                IF (nACTIVE_LEVEL1 == COLOR)
                {
                    IF (nDEVICE_SCALE) { SEND_COMMAND dvTP, "'@TXT', 4, ITOA(nCOLOR)" }
                    ELSE { SEND_COMMAND dvTP, "'@TXT', 4, DATA.TEXT" }
                    SEND_LEVEL dvTP, 1, nCOLOR*255/95
                }
                nENABLE_LEVEL1 = 0
                CANCEL_WAIT 'ENABLE LEVEL 1'
                WAIT 3 'ENABLE LEVEL 1' { nENABLE_LEVEL1 = 1 } // REMOVES UNDESIRABLE ECHO FEEDBACK
            }
            CASE 'COLOR_TEMP=':
            {
                IF (nDEVICE_SCALE) { snCOLOR_TEMP = ATOI(DATA.TEXT) }
                ELSE { snCOLOR_TEMP = TYPE_CAST(Scale_Range(ATOI(DATA.TEXT), 0, 100, -7, 7)) }
                IF (nACTIVE_LEVEL2 == COLOR)
                {
                    IF (nDEVICE_SCALE) { SEND_COMMAND dvTP, "'@TXT', 5, ITOA(snCOLOR_TEMP)" }
                    ELSE { SEND_COMMAND dvTP, "'@TXT', 5, DATA.TEXT" }
                    SEND_LEVEL dvTP, 2, (snCOLOR_TEMP+7)*255/14
                }
                nENABLE_LEVEL2 = 0
                CANCEL_WAIT 'ENABLE LEVEL 2'
                WAIT 3 'ENABLE LEVEL 2' { nENABLE_LEVEL2 = 1 } // REMOVES UNDESIRABLE ECHO FEEDBACK
            }
            CASE 'CONTRAST=':
            {
                IF (nDEVICE_SCALE) { nCONTRAST = ATOI(DATA.TEXT) }
                ELSE { nCONTRAST = TYPE_CAST(Scale_Range(ATOI(DATA.TEXT), 0, 100, 0, 255)) }
                IF (nACTIVE_LEVEL1 == CONTRAST)
                {
                    IF (nDEVICE_SCALE) { SEND_COMMAND dvTP, "'@TXT', 4, ITOA(nCONTRAST)" }
                    ELSE { SEND_COMMAND dvTP, "'@TXT', 4, DATA.TEXT" }
                    SEND_LEVEL dvTP, 1, nCONTRAST
                }
                nENABLE_LEVEL1 = 0
                CANCEL_WAIT 'ENABLE LEVEL 1'
                WAIT 3 'ENABLE LEVEL 1' { nENABLE_LEVEL1 = 1 } // REMOVES UNDESIRABLE ECHO FEEDBACK
            }*/
            CASE 'COOLDOWNTIME=': {}
            CASE 'COOLING=':
            {
		//TODO: DATA.TEXT holds the cooling time left. Maybe integrate it with interface?
		cooling = ATOI(DATA.TEXT)
            }
            /*CASE 'DEBUG=': { nDEBUG = ATOI(DATA.TEXT) }
            CASE 'DEVICE_ID=': {}
            CASE 'DEVICE_SCALE=': { nDEVICE_SCALE = ATOI(DATA.TEXT) }
            CASE 'ERRORM=': { SEND_STRING 0, "'ERROR-',DATA.TEXT" }
            CASE 'FIRMWARE=': { SEND_COMMAND dvTP, "'@TXT', 7, DATA.TEXT" }
            CASE 'GAMMA=': { nGAMMA = ATOI(DATA.TEXT) }
            CASE 'HUE=':
            {
                IF (nDEVICE_SCALE) { nHUE = ATOI(DATA.TEXT) }
                ELSE { nHUE = TYPE_CAST(Scale_Range(ATOI(DATA.TEXT), 0, 100, 0, 60)) }
                IF (nACTIVE_LEVEL1 == HUE)
                {
                    IF (nDEVICE_SCALE) { SEND_COMMAND dvTP, "'@TXT', 4, ITOA(nHUE)" }
                    ELSE { SEND_COMMAND dvTP, "'@TXT', 4, DATA.TEXT" }
                    SEND_LEVEL dvTP, 1, nHUE*255/60
                }
                nENABLE_LEVEL1 = 0
                CANCEL_WAIT 'ENABLE LEVEL 1'
                WAIT 3 'ENABLE LEVEL 1' { nENABLE_LEVEL1 = 1 } // REMOVES UNDESIRABLE ECHO FEEDBACK
            }*/
            //CASE 'INPUT=': { nINPUT = ATOI(DATA.TEXT) }
            /*CASE 'KEYSTONE=': {}
            CASE 'LAMPTIME=': { SEND_COMMAND dvTP, "'@TXT', 8, DATA.TEXT" } TODO: Have code notify us if lamp time is too low
            CASE 'LANGUAGE=': { nLANGUAGE = ATOI(DATA.TEXT) }
            CASE 'LUMINANCE=':
            {
                IF (nDEVICE_SCALE) { nLUMINANCE = ATOI(DATA.TEXT) }
                ELSE { nLUMINANCE = TYPE_CAST(Scale_Range(ATOI(DATA.TEXT), 0, 100, 0, 3)) }
                IF (nACTIVE_LEVEL2 == HUE)
                {
                    IF (nDEVICE_SCALE) { SEND_COMMAND dvTP, "'@TXT', 5, ITOA(nLUMINANCE)" }
                    ELSE { SEND_COMMAND dvTP, "'@TXT', 5, DATA.TEXT" }
                    SEND_LEVEL dvTP, 2, nLUMINANCE*255/3
                }
                nENABLE_LEVEL2 = 0
                CANCEL_WAIT 'ENABLE LEVEL 2'
                WAIT 3 'ENABLE LEVEL 2' { nENABLE_LEVEL2 = 1 } // REMOVES UNDESIRABLE ECHO FEEDBACK
            } 
            CASE 'MUTE=': 
	    { 
		
	    }*/
            CASE 'MUTE_PICTURE=':
	    { 
		mute = ATOI(DATA.TEXT)
	    }
            //CASE 'ORIENTATION=': { nORIENTATION = ATOI(DATA.TEXT) }
            //CASE 'OVERSCAN=': { nOVERSCAN = ATOI(DATA.TEXT) }
            CASE 'POWER=': 
	    { 
		power = ATOI(DATA.TEXT)
	    }
            /*CASE 'SHARPNESS=':
            {
                IF (nDEVICE_SCALE) { nSHARPNESS = ATOI(DATA.TEXT) }
                ELSE { nSHARPNESS = TYPE_CAST(Scale_Range(ATOI(DATA.TEXT), 0, 100, 0, 15)) }
                IF (nACTIVE_LEVEL1 == SHARPNESS)
                {
                    IF (nDEVICE_SCALE) { SEND_COMMAND dvTP, "'@TXT', 4, ITOA(nSHARPNESS)" }
                    ELSE { SEND_COMMAND dvTP, "'@TXT', 4, DATA.TEXT" }
                    SEND_LEVEL dvTP, 1, nSHARPNESS*255/15
                }
                nENABLE_LEVEL1 = 0
                CANCEL_WAIT 'ENABLE LEVEL 1'
                WAIT 3 'ENABLE LEVEL 1' { nENABLE_LEVEL1 = 1 } // REMOVES UNDESIRABLE ECHO FEEDBACK
            }
            CASE 'VERSION=': { sVERSION = DATA.TEXT }
            CASE 'VOLUME=':
            {
                IF (nDEVICE_SCALE) { nVOLUME = ATOI(DATA.TEXT)*100/63 }
                ELSE { nVOLUME = ATOI(DATA.TEXT) }
            }*/
            CASE 'WARMING=':
            {
                warming = ATOI(DATA.TEXT)
            }
            CASE 'WARMUP_COOLDOWN_ENABLE=': {}
            CASE 'WARMUPTIME=': {}
        }// END SWITCH(cCMD)
    }// END STRING
}// END DATA_EVENT[vdvDEV]

(***********************************************************)
(*            THE ACTUAL PROGRAM GOES BELOW                *)
(***********************************************************)
DEFINE_PROGRAM


if(warming <> 0)
{
    if(last <> 0)SEND_STRING vdvTouchPanel, 'Projector Warming Up'
    last = 0
}
else if(cooling <> 0)
{
    if(last <> 1)SEND_STRING vdvTouchPanel, 'Projector Cooling Down'
    last = 1
}
else if(power = 0)
{
    if(last <> 2)SEND_STRING vdvTouchPanel, 'Projector Off'
    last = 2
}
else if(mute <> 0)
{
    if(last <> 3)SEND_STRING vdvTouchPanel, 'Video Mute On'
    last = 3
}
else
{
    if(last <> 4)SEND_STRING vdvTouchPanel, 'Projector On'
    last = 4
}
(***********************************************************)
(*                     END OF PROGRAM                      *)
(*        DO NOT PUT ANY CODE BELOW THIS COMMENT           *)
(***********************************************************)
