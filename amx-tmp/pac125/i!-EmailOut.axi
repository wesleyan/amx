PROGRAM_NAME='i!-EmailOut'
(*{{PS_SOURCE_INFO(PROGRAM STATS)                          *)
(***********************************************************)
(*  FILE CREATED ON: 08/03/2001 AT: 10:42:21               *)
(***********************************************************)
(*  FILE_LAST_MODIFIED_ON: 01/31/2003 AT: 16:04:09         *)
(***********************************************************)
(*  ORPHAN_FILE_PLATFORM: 1                                *)
(***********************************************************)
(*!!FILE REVISION: Rev 0                                   *)
(*  REVISION DATE: 08/19/2002                              *)
(*                                                         *)
(*  COMMENTS:                                              *)
(*                                                         *)
(***********************************************************)
(*!!FILE REVISION: Rev 0                                   *)
(*  REVISION DATE: 09/05/2001                              *)
(*                                                         *)
(*  COMMENTS:                                              *)
(*                                                         *)
(***********************************************************)
(*!!FILE REVISION: Rev 0                                   *)
(*  REVISION DATE: 08/26/2001                              *)
(*                                                         *)
(*  COMMENTS:                                              *)
(*                                                         *)
(***********************************************************)
(*}}PS_SOURCE_INFO                                         *)
(***********************************************************)

(***********************************************************)
(* Add this Line just above the Define_Device Section of   *)
(* your main program.                                      *)
(* #Include 'i!-EmailIn.axi'                               *)
(***********************************************************)
(* Use the Following list of Functions to Integrate this   *)
(* File into your program.                                 *)
(***********************************************************)

(*************************************************)
(*  Sets Your SMTP Server Name for your use.     *)
(*  use: SmtpSetServer('mail.amx.com')           *)
(*                                               *)
(* SmtpSetServer(CHAR Server[])                  *)
(*************************************************)
(**************************************************)
(*  Call this to send an email message            *)
(*  use: SmtpQueMessage('me@mydomain.com',        *)
(*                      'vmorrison@moondance.com' *)
(*                      'Wild Nights'             *)
(*                      'Are they calling?',      *)
(*                      '')                       *)
(*                                                *)
(* SmtpQueMessage(CHAR Source[],CHAR Dest[],      *)
(*                CHAR Subject[],CHAR Message[],  *)
(*                CHAR File[])                    *)
(**************************************************)

(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT

#IF_NOT_DEFINED dvSmtpSocket
DEV dvSmtpSocket  =  { 0:10:0 }
#END_IF

// AXI version
SMTP_VERSION[] = '2.01'

// These should not change
#IF_NOT_DEFINED IP_TCP
IP_TCP                = 1;
#END_IF
#IF_NOT_DEFINED SMTP_PORT
SMTP_PORT             = 25;
#END_IF

// Server stuff
#IF_NOT_DEFINED SMTP_SERVER_TO
SMTP_SERVER_TO   = 1200;
#END_IF
#IF_NOT_DEFINED SMTP_URL_MAX
SMTP_URL_MAX     = 1000;
#END_IF

// Max Sizes
#IF_NOT_DEFINED SMTP_USER_MAX
SMTP_USER_MAX    = 500;
#END_IF
#IF_NOT_DEFINED SMTP_LINE_MAX
SMTP_LINE_MAX    = 256;
#END_IF
#IF_NOT_DEFINED SMTP_MAX_EMAILS
SMTP_MAX_EMAILS  = 10;
#END_IF
#IF_NOT_DEFINED SMTP_MSG_MAX
SMTP_MSG_MAX     = 2000;
#END_IF

// nPop3DataMode
SMTPIdleMode    = 0;
SMTPLoginMode   = 1;
SMTPFromMode    = 2;
SMTPToMode      = 3;
SMTPDataMode    = 4;
SMTPMsgMode     = 5;
SMTPQuitMode    = 6;
SMTPCleanUp     = 7;

// Error Codes
SMTP_RESPONSE_ERROR  = 400;
SMTP_RESPONSE_OK     = 250;
SMTP_RESPONSE_START  = 354;
SMTP_TIMEOUT_ERROR   = 1000;
SMTP_SOCKET_ERROR    = 1001;

(***********************************************************)
(*              DATA TYPE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_TYPE

// Struct to hold emails
Structure _sSMTPMessage
{
  CHAR cDate[SMTP_LINE_MAX];
  CHAR cSource[SMTP_USER_MAX];
  CHAR cDest[SMTP_USER_MAX];
  CHAR cSubject[SMTP_LINE_MAX];
  CHAR cMessage[SMTP_MSG_MAX];
  CHAR cFile[SMTP_LINE_MAX];
}

(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE

// These must be set, since these are volatile they are zeroed on reboot
VOLATILE CHAR           cSmtpServer[SMTP_URL_MAX]
VOLATILE CHAR           cSmtpMyName[] = 'NetLinx'// i!-Smtp'
VOLATILE CHAR           bSmtpActive
VOLATILE INTEGER        nSmtpState
VOLATILE CHAR           bSmtpDebug
VOLATILE CHAR           bSmtpNextState

// Queue Variables, since these are volatile they are zeroed on reboot
VOLATILE _sSMTPMessage  sSmtpQueue[SMTP_MAX_EMAILS]
VOLATILE INTEGER        nSmtpQueueHead
VOLATILE INTEGER        nSmtpQueueTail
VOLATILE INTEGER        nSmtpMessageToSend

(***********************************************************)
(*        SUBROUTINE/FUNCTION DEFINITIONS GO BELOW         *)
(***********************************************************)
(* EXAMPLE: DEFINE_FUNCTION <RETURN_TYPE> <NAME> (<PARAMETERS>) *)
(* EXAMPLE: DEFINE_CALL '<NAME>' (<PARAMETERS>) *)

// User Set/Get Functions
(***********************************************************)
(*************************************************)
(*  Sets Your SMTP Server Name for your use.     *)
(*  use: SmtpSetServer('mail.amx.com')           *)
(*************************************************)
DEFINE_FUNCTION SmtpSetServer(CHAR Server[])
{
  cSmtpServer = Server
  nSmtpQueueHead = 1
  nSmtpQueueTail = 1
  nSmtpState     = SMTPIdleMode
  OFF[bSmtpActive]
  IF (LENGTH_STRING(Server))
    ON[bSmtpActive]
}

(**************************************************)
(*  Call this to send an email message            *)
(*  use: SmtpQueMessage('me@mydomain.com',        *)
(*                      'vmorrison@moondance.com' *)
(*                      'Wild Nights'             *)
(*                      'Are they calling?',      *)
(*                      '')                       *)
(**************************************************)
DEFINE_FUNCTION SLONG SmtpQueMessage(CHAR Source[],CHAR Dest[],CHAR Subject[],CHAR Message[],CHAR File[])
{
  // Debug
  IF (bSmtpDebug)
    SEND_STRING 0,'Smtp Que'

  // Are we full?
  If ((nSmtpQueueHead - nSmtpQueueTail) == 1)
  {
    SEND_STRING 0,'Smtp Que is full...skipping message'
    Return -1;
  }

  // Que up message to be sent...
  sSmtpQueue[nSmtpQueueTail].cSource   = Source
  sSmtpQueue[nSmtpQueueTail].cDest     = Dest
  sSmtpQueue[nSmtpQueueTail].cSubject  = Subject
  sSmtpQueue[nSmtpQueueTail].cMessage  = Message
  sSmtpQueue[nSmtpQueueTail].cFile     = File

  // Inc. tail and go
  nSmtpQueueTail++
  IF (nSmtpQueueTail > SMTP_MAX_EMAILS)
    nSmtpQueueTail = 1
  Return nSmtpQueueTail;
}

// OutGoing Command Sets
(***********************************************************)
(*************************************************)
(* Send all SMTP commands                        *)
(* use: SMTPCommandSet(dvPop3Socket,2,1,"")      *)
(*************************************************)
DEFINE_FUNCTION CHAR SMTPCommandSet(Dev dvSmtpSocket,Integer Func, Integer MsgNum, Char Str[])
STACK_VAR
CHAR cCmd[SMTP_LINE_MAX];
SLONG slHandle;
SLONG slReturn;
LOCAL_VAR
CHAR cTo[SMTP_LINE_MAX];
CHAR cNiceTo[SMTP_LINE_MAX];
CHAR cDate[SMTP_LINE_MAX];
{
  cCmd = "";
  Switch (Func)
  {
    CASE SMTPLoginMode:
    {
      cCmd = "'HELO ',Str"
      cTo = ""
    }

    CASE SMTPFromMode:
      cCmd = "'MAIL FROM: ',sSmtpQueue[MsgNum].cSource";

    CASE SMTPToMode:
    {
      // Multiples
      If (Length_String(cTo) = 0)
      {
        cTo = sSmtpQueue[MsgNum].cDest
        cNiceTo = ""
      }
      cCmd = Remove_String(cTo,';',1)
      If (Length_String(cCmd))
        Set_Length_String(cCmd,Length_String(cCmd)-1)
      Else
        cCmd = Get_Buffer_String(cTo,Length_string(cTo))
      cNiceTo = "cNiceTo,'<',cCmd,'>,',13,10,9"
      cCmd = "'RCPT TO: <',cCmd,'>'";
    }

    CASE SMTPDataMode:
      cCmd = "'DATA'";

    CASE SMTPMsgMode:
    {
      // Debug
      IF (bSmtpDebug)
        SEND_STRING 0,"'SMTP Sending Message'"

      // Build message header
      cNiceTo = Left_String(cNiceTo,Length_string(cNiceTo)-3)
      cDate = "Lower_String(DAY),', ',ITOA(DATE_TO_DAY(LDATE)),' ',SMTPShortMonthName(DATE_TO_MONTH(LDATE)),
               ' ',ITOA(DATE_TO_YEAR(LDATE)),' ',TIME"
      cDate[1] = cDate[1] - $20 // Upper case the first letter of Day of week
      cCmd = "'From: ',sSmtpQueue[MsgNum].cSource,13,10,
              'To: ',cNiceTo,13,10,
              'Subject: ',sSmtpQueue[MsgNum].cSubject,13,10,
              'Date: ',cDate,13,10,
              'MIME-Version: 1.0',13,10,
              'X-Mailer: i!-Email ',SMTP_VERSION,13,10"

      // Attachement?
      If (Length_String(sSmtpQueue[MsgNum].cFile) > 0)
      {
        SEND_STRING dvSmtpSocket,"cCmd"
        cCmd = "'Content-Type: multipart/mixed;',13,10,
                09,'boundary="----=_NextPart_000_0000_00000000.00000000"',13,10,13,10,
                'This is a multi-part message in MIME format.',13,10,13,10"
        SEND_STRING dvSmtpSocket,"cCmd"
        cCmd = "'------=_NextPart_000_0000_00000000.00000000',13,10,
                'Content-Type: text/plain;',13,10,
                09,'charset="iso-8859-1"',13,10,
                'Content-Transfer-Encoding: 7bit',13,10"
      }

      // Send it
      SEND_STRING dvSmtpSocket,"cCmd,13,10"

      // Send message
      While (Length_String(sSmtpQueue[MsgNum].cMessage) > SMTP_LINE_MAX)
      {
        cCmd = Get_Buffer_String(sSmtpQueue[MsgNum].cMessage,SMTP_LINE_MAX)
        SEND_STRING dvSmtpSocket,"cCmd"
      }
      cCmd = sSmtpQueue[MsgNum].cMessage
      SEND_STRING dvSmtpSocket,"cCmd,13,10"

      // Attached file?
      If (Length_String(sSmtpQueue[MsgNum].cFile) > 0)
      {
        // Debug
        IF (bSmtpDebug)
          SEND_STRING 0,"'SMTP Sending File-',sSmtpQueue[MsgNum].cFile"

        // Open file
        slHandle = File_Open(sSmtpQueue[MsgNum].cFile,1);
        IF (slHandle < 0) Send_String 0,"'SMTP File Open Error ',ITOA(slHandle),':"',sSmtpQueue[MsgNum].cFile,'"'"
        If (slHandle > 0)
        {
          // Send attachment break
          cCmd = "13,10,'------=_NextPart_000_0000_00000000.00000000',13,10,
                        'Content-Type: application/octet-stream;',13,10,
                        09,'name="',sSmtpQueue[MsgNum].cFile,'"'"
          SEND_STRING dvSmtpSocket,"cCmd,13,10"
          cCmd =       "'Content-Transfer-Encoding: quoted-printable',13,10,
                        'Content-Disposition: attachment;',13,10,
                        09,'filename="',sSmtpQueue[MsgNum].cFile,'"',13,10"
          SEND_STRING dvSmtpSocket,"cCmd,13,10"

          // Send file line by line, max line size is SMTP_LINE_MAX
          slReturn = 0;
          While (slReturn >= 0)
          {
            slReturn = File_Read_Line(slHandle,cDate,SMTP_LINE_MAX);
            IF (slReturn < 0 && slReturn <> -9) Send_String 0,"'SMTP File Read Error ',ITOA(slReturn),':"',sSmtpQueue[MsgNum].cFile,'"'"
            While (Length_String(cDate) > SMTP_LINE_MAX)
            {
               cCmd = Get_Buffer_String(cDate,SMTP_LINE_MAX)
               SEND_STRING dvSmtpSocket,"cCmd"
            }
            SEND_STRING dvSmtpSocket,"cDate,13,10"
          }
        }

        // Send attachment break
        cCmd = "13,10,'------=_NextPart_000_0000_00000000.00000000'"
        SEND_STRING dvSmtpSocket,"cCmd,13,10"

        // Close file
        slReturn = File_Close(slHandle);
        IF (slReturn < 0) Send_String 0,"'SMTP File Close Error ',ITOA(slHandle),':"',sSmtpQueue[MsgNum].cFile,'"'"
      }

      // Done - send this below
      cCmd = "13,10,'.'";
    }

    CASE SMTPQuitMode:
      cCmd = 'QUIT'
  }

  // Debug
  If (Length_String(cCmd))
  {
    IF (bSmtpDebug)
      SEND_STRING 0,"'SMTP Sending-',cCmd"
    SEND_STRING dvSmtpSocket,"cCmd,13,10"
  }

  // More receipients
  If (Func == SMTPToMode && Length_String(cTo))
    Return 0;
  Return 1;
}

(*************************************************)
(* Get IP error text for a given error number    *)
(* use: SMTPGetIpError(Error)                    *)
(*************************************************)
DEFINE_FUNCTION SMTPReset()
{
  // Clean up
  Cancel_wait 'Smtp Timeout'
  nSmtpState = SMTPIdleMode
  nSmtpMessageToSend = 0
}

(*************************************************)
(*  Call this to send an email message           *)
(*  use: SmtpSendMessage(1)                      *)
(*************************************************)
DEFINE_FUNCTION SmtpSendMessage(Integer MsgNum)
{
  // Debug
  IF (bSmtpDebug)
    SEND_STRING 0,'Smtp Send'

  // Check address
  If (LENGTH_STRING(sSmtpQueue[MsgNum].cSource) = 0)
  {
    SEND_STRING 0,'Smtp Error-Email must be from someone'
    Return;
  }
  If (LENGTH_STRING(sSmtpQueue[MsgNum].cDest) = 0)
  {
    SEND_STRING 0,'Smtp Error-Email must be to someone'
    Return;
  }
  IF (!bSmtpActive)
  {
    SEND_STRING 0,'Smtp has not been initialized'
    Return;
  }
  IF (nSmtpState <> SMTPIdleMode)
  {
    IF (bSmtpDebug)
      SEND_STRING 0,'Smtp is busy - cannot send right now'
    Return;
  }

  // Open connection
  nSmtpMessageToSend = MsgNum
  IP_CLIENT_OPEN(dvSmtpSocket.Port,cSmtpServer,SMTP_PORT,IP_TCP)
  nSmtpState = SMTPLoginMode
  // Debug
  IF (bSmtpDebug)
     SEND_STRING 0,"'Smtp Connecting-',cSmtpServer,':',ITOA(SMTP_PORT),' on ',ITOA(dvSmtpSocket.Port)"

  WAIT SMTP_SERVER_TO 'Smtp Timeout'
  {
     IP_CLIENT_CLOSE(dvSmtpSocket.Port)
     nSmtpState = SMTPIdleMode
     // Debug
     IF (bSmtpDebug)
        SEND_STRING 0,'Smtp Timeout'
  }
}

// Helper Functions
(***********************************************************)
(*************************************************)
(* Get IP error text for a given error number    *)
(* use: SMTPGetIpError(Error)                    *)
(*************************************************)
DEFINE_FUNCTION CHAR[100] SMTPGetIpError (LONG lERR)
{
  Switch (lERR)
  {
    Case 0:
      RETURN "";
    Case 2:
      RETURN "'IP ERROR (',ITOA(lERR),'): General Failure (IP_CLIENT_OPEN/IP_SERVER_OPEN)'";
    Case 4:
      RETURN "'IP ERROR (',ITOA(lERR),'): unknown host (IP_CLIENT_OPEN)'";
    Case 6:
      RETURN "'IP ERROR (',ITOA(lERR),'): connection refused (IP_CLIENT_OPEN)'";
    Case 7:
      RETURN "'IP ERROR (',ITOA(lERR),'): connection timed out (IP_CLIENT_OPEN)'";
    Case 8:
      RETURN "'IP ERROR (',ITOA(lERR),'): unknown connection error (IP_CLIENT_OPEN)'";
    Case 14:
      RETURN "'IP ERROR (',ITOA(lERR),'): local port already used (IP_CLIENT_OPEN/IP_SERVER_OPEN)'";
    Case 16:
      RETURN "'IP ERROR (',ITOA(lERR),'): too many open sockets (IP_CLIENT_OPEN/IP_SERVER_OPEN)'";
    Case 10:
      RETURN "'IP ERROR (',ITOA(lERR),'): Binding error (IP_SERVER_OPEN)'";
    Case 11:
      RETURN "'IP ERROR (',ITOA(lERR),'): Listening error (IP_SERVER_OPEN)'";
    Case 15:
      RETURN "'IP ERROR (',ITOA(lERR),'): UDP socket already listening (IP_SERVER_OPEN)'";
    Case 9:
      RETURN "'IP ERROR (',ITOA(lERR),'): Already closed (IP_CLIENT_CLOSE/IP_SERVER_CLOSE)'";
    Default:
      RETURN "'IP ERROR (',ITOA(lERR),'): Unknown'";
  }
}

(*****************************)
(* FUNCTION: LONG_MONTH_NAME*)
(***********************************************************)
(***********************************************************)
DEFINE_FUNCTION CHAR[20] SMTPShortMonthName (SINTEGER snMONTH)
{
  SWITCH (snMonth)
  {
    CASE 1:  RETURN 'Jan';
    CASE 2:  RETURN 'Feb';
    CASE 3:  RETURN 'Mar';
    CASE 4:  RETURN 'Apr';
    CASE 5:  RETURN 'May';
    CASE 6:  RETURN 'Jun';
    CASE 7:  RETURN 'Jul';
    CASE 8:  RETURN 'Aug';
    CASE 9:  RETURN 'Sep';
    CASE 10: RETURN 'Oct';
    CASE 11: RETURN 'Nov';
    CASE 12: RETURN 'Dec';
  }
  RETURN "";
}
(***********************************************************)
(*                STARTUP CODE GOES BELOW                  *)
(***********************************************************)
DEFINE_START

IF (bSmtpDebug)
  SEND_STRING 0,"'i!-EmailOut (Smtp) Version ',SMTP_VERSION"

(***********************************************************)
(*                THE EVENTS GOES BELOW                    *)
(***********************************************************)
DEFINE_EVENT

(*************************************************)
(*  Data event for SMTP socket for your use.     *)
(*************************************************)
DATA_EVENT[dvSmtpSocket]
{
  ONLINE:
  {
    // Debug
    IF (bSmtpDebug)
      SEND_STRING 0,'Smtp ONLINE'
  }

  OFFLINE:
  {
    // Debug
    IF (bSmtpDebug)
      SEND_STRING 0,'Smtp OFFLINE'
    SMTPReset();
  }

  ONERROR:
  {
    // Print error
    IF (Data.Number <> 9)
      SEND_STRING 0,"'Smtp OnError-',SMTPGetIpError(Data.Number)"
    SWITCH (Data.Number)
    {
      (* STUFF WE CANNOT DO MUCH ABOUT! *)
      CASE 14: {} (* local port already used (IP_CLIENT_OPEN/IP_SERVER_OPEN) *)
      CASE 16: {} (* too many open sockets (IP_CLIENT_OPEN/IP_SERVER_OPEN) *)
      CASE 10: {} (* Binding error (IP_SERVER_OPEN) *)
      CASE 11: {} (* Listening error (IP_SERVER_OPEN) *)
      CASE 15: {} (* UDP socket already listening (IP_SERVER_OPEN) *)
      CASE  9: {} (* Already closed (IP_CLIENT_CLOSE/IP_SERVER_CLOSE) *)
      CASE  8: {} (* unknown connection error (IP_CLIENT_OPEN) *)
      CASE  2: {} (* General Failure (IP_CLIENT_OPEN/IP_SERVER_OPEN) *)
      CASE  4:    (* unknown host (IP_CLIENT_OPEN) *)
        SEND_STRING 0,'Things To Try:  Make sure the DNS entries are entered for this master.'
      CASE  6:    (* connection refused (IP_CLIENT_OPEN) *)
        SEND_STRING 0,"'Things To Try:  The server does not appear to be a SMTP server (i.e. not listening at port ',ITOA(SMTP_PORT),')'"
      CASE  7:    (* connection timed out (IP_CLIENT_OPEN) *)
        SEND_STRING 0,'Things To Try:  The server appears to be offline.'
    }
    SMTPReset();
  }

  STRING:
  {
    // Debug
    IF (bSmtpDebug)
      SEND_STRING 0,"'Smtp Receive-',Data.Text"

    // Any errors
    IF (ATOI(Data.Text) >= SMTP_RESPONSE_ERROR)
    {
      IP_CLIENT_CLOSE(dvSmtpSocket.Port)
      nSmtpState = SMTPIdleMode
    }
    ELSE
    {
      SWITCH (nSmtpState)
      {
        // Idle, do nothing
        CASE SMTPIdleMode:  {}
        // Login, send my host name
        CASE SMTPLoginMode: bSmtpNextState = SMTPCommandSet(dvSmtpSocket,SMTPLoginMode,0,cSmtpMyName)
        // From mode, send from
        CASE SMTPFromMode:  bSmtpNextState = SMTPCommandSet(dvSmtpSocket,SMTPFromMode,nSmtpMessageToSend,"")
        // Send to address(es)
        CASE SMTPToMode:    bSmtpNextState = SMTPCommandSet(dvSmtpSocket,SMTPToMode,nSmtpMessageToSend,"")
        // Send data command
        CASE SMTPDataMode:  bSmtpNextState = SMTPCommandSet(dvSmtpSocket,SMTPDataMode,nSmtpMessageToSend,"")
        // Sned message body
        CASE SMTPMsgMode:   bSmtpNextState = SMTPCommandSet(dvSmtpSocket,SMTPMsgMode,nSmtpMessageToSend,"")
        // Send quit command
        CASE SMTPQuitMode:  bSmtpNextState = SMTPCommandSet(dvSmtpSocket,SMTPQuitMode,nSmtpMessageToSend,"")
        // Reset server for next send
        CASE SMTPCleanUp:   SMTPReset();
      }
      // Increment state if not idle
      If (nSmtpState <> SMTPIdleMode && bSmtpNextState) nSmtpState++
    }
  }
}


(***********************************************************)
(*            THE ACTUAL PROGRAM GOES BELOW                *)
(***********************************************************)
DEFINE_PROGRAM

// If an email in the Q send it
IF (nSmtpQueueHead != nSmtpQueueTail)
{
  IF (nSmtpState = SMTPIdleMode)
  {
    // Send it
    SmtpSendMessage(nSmtpQueueHead)
    // Bump que
    nSmtpQueueHead++
    IF (nSmtpQueueHead > SMTP_MAX_EMAILS) nSmtpQueueHead=1
  }
}

(***********************************************************)
(*                     END OF PROGRAM                      *)
(*        DO NOT PUT ANY CODE BELOW THIS COMMENT           *)
(***********************************************************)

