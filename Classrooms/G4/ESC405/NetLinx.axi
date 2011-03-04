(*------------------------------------------------------------------------------------------------*)
(* NOTE: In the follow arrays with a size of 1 means that the size is set runtime  *)
(*       Size of 1 is just a place holder for the compiler to do type checking     *)
(*------------------------------------------------------------------------------------------------*)

(*------------------------------------------------------------------------------------------------*)
(* Set Netlinx System *)
(*------------------------------------------------------------------------------------------------*)
#DEFINE __NETLINX__

(*------------------------------------------------------------------------------------------------*)
(* Predefined Types *)
(*------------------------------------------------------------------------------------------------*)
DEFINE_TYPE
(*------------------------------------------------------------------------------------------------*)
STRUCTURE TBUTTON
{
  DEVCHAN INPUT;
  LONG    HOLDTIME;
  DEV     SOURCEDEV;
}
(*------------------------------------------------------------------------------------------------*)
STRUCTURE TCHANNEL
{
  DEV     DEVICE;
  INTEGER CHANNEL;
  DEV     SOURCEDEV;
}
(*------------------------------------------------------------------------------------------------*)
STRUCTURE TDATA
{
  DEV      DEVICE;
  LONG     NUMBER;
  CHAR     TEXT[2048];
  CHAR     SOURCEIP[32];
  INTEGER  SOURCEPORT;
  DEV      SOURCEDEV;
}
(*------------------------------------------------------------------------------------------------*)
STRUCTURE TLEVEL
{
  DEVLEV   INPUT;
  CHAR     VALUE;
  DEV      SOURCEDEV;
}
(*------------------------------------------------------------------------------------------------*)
STRUCTURE TTIMELINE
{
  INTEGER  ID;
  INTEGER  SEQUENCE;
  LONG     TIME;
  INTEGER  RELATIVE;
  LONG     REPETITION;
}
(*------------------------------------------------------------------------------------------------*)
STRUCTURE TCUSTOM
{
  DEV      DEVICE;
  INTEGER  ID;
  INTEGER  TYPE;
  INTEGER  FLAG;
  SLONG    VALUE1;
  SLONG    VALUE2;
  SLONG    VALUE3;
  CHAR     TEXT[2048];
  CHAR     ENCODE[2048];
  DEV      SOURCEDEV;
}
(*------------------------------------------------------------------------------------------------*)

(*------------------------------------------------------------------------------------------------*)
(* URL Manipulation structure *)
(*------------------------------------------------------------------------------------------------*)
STRUCTURE URL_STRUCT
{
  CHAR     Flags;           // Connection Type (normally 1)
  INTEGER  Port;            // TCP port (normally 1319)
  CHAR     URL[128];        // string: URL or IP address
}
(*------------------------------------------------------------------------------------------------*)
(* DNS Manipulation structure *)
(*------------------------------------------------------------------------------------------------*)
STRUCTURE DNS_STRUCT
{
  CHAR     DomainName[128];    // domain suffix (e.g. panja.com)
  CHAR     DNS1[32];           // IP address of 1st DNS server
  CHAR     DNS2[32];           // IP address of 2nd DNS server
  CHAR     DNS3[32];           // IP address of 3rd DNS server
}
(*------------------------------------------------------------------------------------------------*)
(* IP Address Manipulation structure *)
(*------------------------------------------------------------------------------------------------*)
STRUCTURE IP_ADDRESS_STRUCT
{
  CHAR     FLAGS;          // Configuration flags
  CHAR     HOSTNAME[128];  // Host name
  CHAR     IPADDRESS[32];  // IP address unit
  CHAR     SUBNETMASK[32]; // subnet mask
  CHAR     GATEWAY[32];    // IP address of gateway
}
(*------------------------------------------------------------------------------------------------*)
(* Device Info Structure *)
(*------------------------------------------------------------------------------------------------*)
STRUCTURE DEV_INFO_STRUCT
{
  CHAR     MANUFACTURER_STRING[128];
  INTEGER  MANUFACTURER;
  CHAR     DEVICE_ID_STRING[128];
  INTEGER  DEVICE_ID;
  CHAR     VERSION[32];
  INTEGER  FIRMWARE_ID;
  CHAR     SERIAL_NUMBER[32];
  INTEGER  SOURCE_TYPE;
  CHAR     SOURCE_STRING[32];
}
(*------------------------------------------------------------------------------------------------*)
(* End of Predefined Types *)
(*------------------------------------------------------------------------------------------------*)

(*------------------------------------------------------------------------------------------------*)
(* Predefined Constants *)
(*------------------------------------------------------------------------------------------------*)
DEFINE_CONSTANT
(*-- NetLinx.axi version -------------------------------------------------------------------------*)
CHAR NETLINX_AXI_VERSION[]    = '1.19'
(*-- URL Constants -------------------------------------------------------------------------------*)
CHAR URL_Flg_TCP              = 1;     // TCP connection
CHAR URL_Flg_Temp             = $10;   // Temp Connection
CHAR URL_Flg_Stat_PrgNetLinx  = $20;   // URL set by NetLinx Set_URL_List
CHAR URL_Flg_Stat_Mask        = $C0;   // status mask upper 2 bits
CHAR URL_Flg_Stat_Lookup      = $00;   // Looking up IP
CHAR URL_Flg_Stat_Connecting  = $40;   // connecting
CHAR URL_Flg_Stat_Waiting     = $80;   // waiting
CHAR URL_Flg_Stat_Connected   = $C0;   // connected
(*-- IP Address Flag Constants -------------------------------------------------------------------*)
CHAR IP_Addr_Flg_DHCP         = 1;     // Use DHCP
(*-- for user ------------------------------------------------------------------------------------*)
INTEGER  FIRST_VIRTUAL_DEVICE   = 32768;
INTEGER  FIRST_LOCAL_PORT       = 2;
DEV      DYNAMIC_VIRTUAL_DEVICE = 36864:1:0;
INTEGER  TIMELINE_ONCE          = 0;
INTEGER  TIMELINE_REPEAT        = 1;
INTEGER  TIMELINE_ABSOLUTE      = 0;
INTEGER  TIMELINE_RELATIVE      = 1;
INTEGER  DO_PUSH_TIMED_INFINITE = $FFFF;
(*-- for source type -----------------------------------------------------------------------------*)
INTEGER  SOURCE_TYPE_NO_ADDRESS          = $00;
INTEGER  SOURCE_TYPE_NEURON_ID           = $01;
INTEGER  SOURCE_TYPE_IP_ADDRESS          = $02;
INTEGER  SOURCE_TYPE_AXLINK              = $03;
INTEGER  SOURCE_TYPE_NEURON_SUBNODE_ICSP = $10;
INTEGER  SOURCE_TYPE_NEURON_SUBNODE_PL   = $11;
INTEGER  SOURCE_TYPE_IP_SOCKET_ADDRESS   = $12;
INTEGER  SOURCE_TYPE_RS232               = $13;
INTEGER  SOURCE_TYPE_INTERNAL            = $20;

(*------------------------------------------------------------------------------------------------*)
(* Added v1.17 *)
(*------------------------------------------------------------------------------------------------*)
CHAR INTERNAL_QUEUE_SIZE_INDEX_INTERPRETER    = 0;
CHAR INTERNAL_QUEUE_SIZE_INDEX_NOTIFICATION_MGR   = 1;
CHAR INTERNAL_QUEUE_SIZE_INDEX_CONNECTION_MGR     = 2;
CHAR INTERNAL_QUEUE_SIZE_INDEX_ROUTE_MGR          = 3;
CHAR INTERNAL_QUEUE_SIZE_INDEX_DEVICE_MGR         = 4;
CHAR INTERNAL_QUEUE_SIZE_INDEX_DIAGNOSTIC_MGR     = 5;
CHAR INTERNAL_QUEUE_SIZE_INDEX_TCP_TX             = 6;
CHAR INTERNAL_QUEUE_SIZE_INDEX_IPCONNECTION_MGR   = 7;
CHAR INTERNAL_QUEUE_SIZE_INDEX_MESSAGE_DISPATCHER = 8;
CHAR INTERNAL_QUEUE_SIZE_INDEX_AXLINK_TX          = 9;
CHAR INTERNAL_QUEUE_SIZE_INDEX_PHASTLINK_TX       = 10;
CHAR INTERNAL_QUEUE_SIZE_INDEX_ICSPLONTALK_TX     = 11;
CHAR INTERNAL_QUEUE_SIZE_INDEX_ICSP232_TX         = 12;
CHAR INTERNAL_QUEUE_SIZE_INDEX_ICSPIP_TX          = 13;
CHAR INTERNAL_QUEUE_SIZE_INDEX_NI_DEVICE          = 19;

CHAR INTERNAL_THRESHOLD_INDEX_INTERPRETER = 0;
CHAR INTERNAL_THRESHOLD_INDEX_LONTALK     = 1;
CHAR INTERNAL_THRESHOLD_INDEX_IP          = 2;

(*------------------------------------------------------------------------------------------------*)
(* Added v1.18 *)
(*------------------------------------------------------------------------------------------------*)
CHAR TRUE = 1
CHAR FALSE = 0

CHAR FILE_READ_ONLY = 1
CHAR FILE_RW_NEW = 2
CHAR FILE_RW_APPEND = 3

CHAR IP_TCP = 1
CHAR IP_UDP = 2
CHAR IP_UDP_2WAY = 3

CHAR XML_ENCODE_TYPES = $01
CHAR XML_ENCODE_CHAR_AS_LIST = $10
CHAR XML_ENCODE_LE = $20

CHAR XML_DECODE_TYPES = $01
CHAR XML_DECODE_NO_PRESERVE = $10

(*------------------------------------------------------------------------------------------------*)
(* End of Predefined Constants *)
(*------------------------------------------------------------------------------------------------*)

(*------------------------------------------------------------------------------------------------*)
(* System Variables *)
(*------------------------------------------------------------------------------------------------*)
DEFINE_SYSTEM_VARIABLE
INTEGER   PUSH_DEVICE     = $F001;
INTEGER   PUSH_CHANNEL    = $F002;
DEVCHAN   PUSH_DEVCHAN    = $F003;
INTEGER   RELEASE_DEVICE  = $F004;
INTEGER   RELEASE_CHANNEL = $F005;
DEVCHAN   RELEASE_DEVCHAN = $F006;
INTEGER   MASTER_SLOT     = $F007;
INTEGER   GET_PULSE_TIME  = $F008;
LONG      GET_TIMER       = $F009;
CHAR      DAY[1]          = $F00A;
CHAR      DATE[1]         = $F00B;
CHAR      TIME[1]         = $F00C;
CHAR      MASTER_SN[1]    = $F00D;
INTEGER   SYSTEM_NUMBER   = $F00E;
CHAR      LDATE[1]        = $F00F;
TBUTTON   BUTTON          = $F010;
DEVCHAN   DV_CHANNEL      = $F011;
TDATA     DATA            = $F012;
TLEVEL    LEVEL           = $F013;
TTIMELINE TIMELINE        = $F014;
TCHANNEL  CHANNEL         = $F015;
TCUSTOM   CUSTOM          = $F016;
(*------------------------------------------------------------------------------------------------*)
(* End of System Variables *)
(*------------------------------------------------------------------------------------------------*)

(*------------------------------------------------------------------------------------------------*)
(* Library Calls *)
(*------------------------------------------------------------------------------------------------*)
DEFINE_LIBRARY_FUNCTION CHAR      ATOI(CONSTANT CHAR A[])                                               = $F001;
DEFINE_LIBRARY_FUNCTION SINTEGER  ATOL(CONSTANT CHAR A[])                                               = $F002;
DEFINE_LIBRARY_FUNCTION FLOAT     ATOF(CONSTANT CHAR A[])                                               = $F003;
DEFINE_LIBRARY_FUNCTION SINTEGER  DATE_TO_DAY(CONSTANT CHAR A[])                                        = $F004;
DEFINE_LIBRARY_FUNCTION SINTEGER  DATE_TO_MONTH(CONSTANT CHAR A[])                                      = $F005;
DEFINE_LIBRARY_FUNCTION SINTEGER  DATE_TO_YEAR(CONSTANT CHAR A[])                                       = $F006;
DEFINE_LIBRARY_FUNCTION SINTEGER  DAY_OF_WEEK(CONSTANT CHAR A[])                                        = $F007;
DEFINE_LIBRARY_FUNCTION SINTEGER  FILE_CLOSE(CONSTANT VARIANT A)                                        = $F008;
DEFINE_LIBRARY_FUNCTION SINTEGER  FILE_COPY(CONSTANT CHAR A[],CONSTANT CHAR B[])                        = $F009;
DEFINE_LIBRARY_FUNCTION SINTEGER  FILE_CREATEDIR(CONSTANT CHAR A[])                                     = $F00A;
DEFINE_LIBRARY_FUNCTION SINTEGER  FILE_DELETE(CONSTANT CHAR A[])                                        = $F00B;
DEFINE_LIBRARY_FUNCTION SINTEGER  FILE_DIR(CONSTANT CHAR A[],CHAR B[],CONSTANT VARIANT C)               = $F00C;
DEFINE_LIBRARY_FUNCTION SINTEGER  FILE_GETDIR(CHAR A[])                                                 = $F00D;
DEFINE_LIBRARY_FUNCTION SINTEGER  FILE_OPEN(CONSTANT CHAR A[],CONSTANT LONG B)                          = $F00E;
DEFINE_LIBRARY_FUNCTION SINTEGER  FILE_READ(CONSTANT VARIANT A,CHAR B[],CONSTANT LONG C)                = $F00F;
DEFINE_LIBRARY_FUNCTION SINTEGER  FILE_READ_LINE(CONSTANT VARIANT A,CHAR B[],CONSTANT LONG C)           = $F010;
DEFINE_LIBRARY_FUNCTION SINTEGER  FILE_REMOVEDIR(CONSTANT CHAR A[])                                     = $F011;
DEFINE_LIBRARY_FUNCTION SINTEGER  FILE_RENAME(CONSTANT CHAR A[],CONSTANT CHAR B[])                      = $F012;
DEFINE_LIBRARY_FUNCTION SINTEGER  FILE_SEEK(CONSTANT VARIANT A,CONSTANT LONG B)                         = $F013;
DEFINE_LIBRARY_FUNCTION SINTEGER  FILE_SETDIR(CONSTANT CHAR A[])                                        = $F014;
DEFINE_LIBRARY_FUNCTION SINTEGER  FILE_WRITE(CONSTANT VARIANT A,CONSTANT CHAR B[],CONSTANT LONG C)      = $F015;
DEFINE_LIBRARY_FUNCTION SINTEGER  FILE_WRITE_LINE(CONSTANT VARIANT A,CONSTANT CHAR B[],CONSTANT LONG C) = $F016;
DEFINE_LIBRARY_FUNCTION CHAR      FIND_STRING(CONSTANT CHAR A[],CONSTANT CHAR B[],CONSTANT LONG C)      = $F017;
DEFINE_LIBRARY_FUNCTION CHAR[1]   FTOA(CONSTANT DOUBLE A)                                               = $F018;
DEFINE_LIBRARY_FUNCTION CHAR      HEXTOI(CONSTANT CHAR A[])                                             = $F019;
DEFINE_LIBRARY_FUNCTION SINTEGER  IP_CLIENT_CLOSE(CONSTANT LONG A)                                      = $F01A;
DEFINE_LIBRARY_FUNCTION SINTEGER  IP_CLIENT_OPEN(CONSTANT LONG A,CONSTANT CHAR B[],
                                                 CONSTANT LONG C,CONSTANT LONG D)                       = $F01B;
DEFINE_LIBRARY_FUNCTION SINTEGER  IP_SERVER_CLOSE(CONSTANT LONG A)                                      = $F01C;
DEFINE_LIBRARY_FUNCTION SINTEGER  IP_SERVER_OPEN(CONSTANT LONG A,CONSTANT  LONG B,CONSTANT  LONG C)     = $F01D;
DEFINE_LIBRARY_FUNCTION CHAR[1]   ITOA(CONSTANT VARIANT A)                                              = $F01E;
DEFINE_LIBRARY_FUNCTION CHAR[1]   ITOHEX(CONSTANT VARIANT A)                                            = $F01F;
DEFINE_LIBRARY_FUNCTION CHAR[1]   LEFT_STRING(CONSTANT CHAR A[],CONSTANT LONG B)                        = $F020;
DEFINE_LIBRARY_FUNCTION CHAR      LENGTH_ARRAY(CONSTANT VARIANTARRAY A)                                 = $F021;
DEFINE_LIBRARY_FUNCTION CHAR      LENGTH_STRING(CONSTANT VARIANTARRAY A)                                = $F022;
//Load object
DEFINE_LIBRARY_FUNCTION CHAR[1]   LOWER_STRING(CONSTANT CHAR A[])                                       = $F024;
DEFINE_LIBRARY_FUNCTION CHAR      MAX_LENGTH_ARRAY(CONSTANT VARIANTARRAY A)                             = $F025;
DEFINE_LIBRARY_FUNCTION CHAR      MAX_LENGTH_STRING(CONSTANT VARIANTARRAY A)                            = $F026;
DEFINE_LIBRARY_FUNCTION CHAR[1]   MID_STRING(CONSTANT CHAR A[],CONSTANT LONG B,CONSTANT LONG C)         = $F027;
DEFINE_LIBRARY_FUNCTION CHAR      RANDOM_NUMBER(CONSTANT LONG A)                                        = $F028;
DEFINE_LIBRARY_FUNCTION CHAR[1]   REMOVE_STRING(CHAR A[],CONSTANT CHAR B[],CONSTANT LONG C)             = $F029;
DEFINE_LIBRARY_FUNCTION CHAR[1]   RIGHT_STRING(CONSTANT CHAR A[],CONSTANT LONG B)                       = $F02A;
DEFINE_LIBRARY_FUNCTION CHAR      SET_LENGTH_ARRAY(VARIANTARRAY A,CONSTANT LONG B)                      = $F02B;
DEFINE_LIBRARY_FUNCTION CHAR      SET_LENGTH_STRING(VARIANTARRAY A,CONSTANT LONG B)                     = $F02C;
DEFINE_LIBRARY_FUNCTION SINTEGER  TIME_TO_HOUR(CONSTANT CHAR A[])                                       = $F02D;
DEFINE_LIBRARY_FUNCTION SINTEGER  TIME_TO_MINUTE(CONSTANT CHAR A[])                                     = $F02E;
DEFINE_LIBRARY_FUNCTION SINTEGER  TIME_TO_SECOND(CONSTANT CHAR A[])                                     = $F02F;
//Unload object
DEFINE_LIBRARY_FUNCTION CHAR[1]   UPPER_STRING(CONSTANT CHAR A[])                                       = $F031;
DEFINE_LIBRARY_FUNCTION CHAR      GET_LAST(CONSTANT VARIANTARRAY A)                                     = $F032;
DEFINE_LIBRARY_FUNCTION SINTEGER  COMPARE_STRING(CONSTANT CHAR A[],CONSTANT CHAR B[])                   = $F033;
DEFINE_LIBRARY_FUNCTION SINTEGER  IP_MC_SERVER_OPEN(CONSTANT LONG A,CONSTANT CHAR B[],CONSTANT LONG C)  = $F034;
DEFINE_LIBRARY_FUNCTION CHAR[1]   FORMAT(CONSTANT CHAR A[],CONSTANT VARIANT B)                          = $F035;
DEFINE_LIBRARY_FUNCTION CHAR      TIMELINE_CREATE(CONSTANT LONG A,CONSTANT VARIANT B[],CONSTANT LONG C,
                                                  CONSTANT LONG D,CONSTANT LONG E)                      = $F036;
DEFINE_LIBRARY_FUNCTION CHAR      TIMELINE_KILL(CONSTANT LONG A)                                        = $F037;
DEFINE_LIBRARY_FUNCTION CHAR      TIMELINE_RELOAD(CONSTANT LONG A,CONSTANT VARIANT B[],CONSTANT LONG C) = $F038;
DEFINE_LIBRARY_FUNCTION CHAR      TIMELINE_PAUSE(CONSTANT LONG A)                                       = $F039;
DEFINE_LIBRARY_FUNCTION CHAR      TIMELINE_RESTART(CONSTANT LONG A)                                     = $F03A;
DEFINE_LIBRARY_FUNCTION CHAR      TIMELINE_SET(CONSTANT LONG A,CONSTANT LONG B)                         = $F03B;
DEFINE_LIBRARY_FUNCTION CHAR      TIMELINE_GET(CONSTANT LONG A)                                         = $F03C;
DEFINE_LIBRARY_FUNCTION CHAR      TIMELINE_ACTIVE(CONSTANT LONG A)                                      = $F03D;
DEFINE_LIBRARY_FUNCTION CHAR      TIMELINE_DYNAMIC_ID()                                                 = $F03E;
//MISSING 3F
DEFINE_LIBRARY_FUNCTION CHAR      GET_BUFFER_CHAR(CHAR A[])                                             = $F040;
DEFINE_LIBRARY_FUNCTION CHAR      GET_MULTI_BUFFER_STRING(CHAR A[],CHAR B[])                            = $F041;
DEFINE_LIBRARY_FUNCTION CHAR[1]   GET_BUFFER_STRING(CHAR A[],CONSTANT LONG B)                           = $F042;
DEFINE_LIBRARY_FUNCTION CHAR      DEVICE_ID(CONSTANT DEV A)                                             = $F043;
DEFINE_LIBRARY_FUNCTION CHAR[1]   DEVICE_ID_STRING(CONSTANT DEV A)                                      = $F044;
DEFINE_LIBRARY_FUNCTION           DEVICE_INFO(CONSTANT DEV A,DEV_INFO_STRUCT B)                         = $F045;
DEFINE_LIBRARY_FUNCTION           DO_PUSH(CONSTANT DEV A,CONSTANT LONG B)                               = $F046;
DEFINE_LIBRARY_FUNCTION           DO_RELEASE(CONSTANT DEV A,CONSTANT LONG B)                            = $F047;
DEFINE_LIBRARY_FUNCTION           REDIRECT_STRING(CONSTANT LONG A,CONSTANT DEV B,CONSTANT DEV C)        = $F048;
DEFINE_LIBRARY_FUNCTION           SET_PULSE_TIME(CONSTANT LONG A)                                       = $F049;
DEFINE_LIBRARY_FUNCTION           SET_TIMER(CONSTANT LONG A)                                            = $F04A;
DEFINE_LIBRARY_FUNCTION SINTEGER  VARIABLE_TO_STRING(CONSTANT VARIANTARRAY A,CHAR B[], LONG C)          = $F04B;
DEFINE_LIBRARY_FUNCTION SINTEGER  STRING_TO_VARIABLE(VARIANTARRAY A,CONSTANT CHAR B[], LONG C)          = $F04C;
DEFINE_LIBRARY_FUNCTION CHAR      LENGTH_VARIABLE_TO_STRING(CONSTANT VARIANTARRAY A)                    = $F04D;
//MISSING 4E
//MISSING 4F
DEFINE_LIBRARY_FUNCTION CHAR[1]   GET_UNIQUE_ID()                                                       = $F050;
DEFINE_LIBRARY_FUNCTION SINTEGER  GET_SERIAL_NUMBER(CONSTANT DEV A,CHAR B[])                            = $F051;
DEFINE_LIBRARY_FUNCTION CHAR      GET_SYSTEM_NUMBER()                                                   = $F052;
DEFINE_LIBRARY_FUNCTION SINTEGER  SET_SYSTEM_NUMBER(CONSTANT LONG A)                                    = $F053;
//MISSING 54
//MISSING 55
DEFINE_LIBRARY_FUNCTION SINTEGER  GET_DNS_LIST(CONSTANT DEV A,DNS_STRUCT B)                             = $F056;
DEFINE_LIBRARY_FUNCTION SINTEGER  SET_DNS_LIST(CONSTANT DEV A,CONSTANT DNS_STRUCT B)                    = $F057;
DEFINE_LIBRARY_FUNCTION SINTEGER  GET_IP_ADDRESS(CONSTANT DEV A,IP_ADDRESS_STRUCT B)                    = $F058;
DEFINE_LIBRARY_FUNCTION SINTEGER  SET_IP_ADDRESS(CONSTANT DEV A,CONSTANT IP_ADDRESS_STRUCT B)           = $F059;
DEFINE_LIBRARY_FUNCTION SINTEGER  SET_VALIDATION_CODE(CONSTANT LONG A)                                  = $F05A;
DEFINE_LIBRARY_FUNCTION SINTEGER  GET_URL_LIST(CONSTANT DEV A,URL_STRUCT B[],CONSTANT LONG C)           = $F05B;
DEFINE_LIBRARY_FUNCTION SINTEGER  ADD_URL_ENTRY(CONSTANT DEV A,CONSTANT URL_STRUCT C)                   = $F05C;
DEFINE_LIBRARY_FUNCTION SINTEGER  DELETE_URL_ENTRY(CONSTANT DEV A,CONSTANT URL_STRUCT C)                = $F05D;
//MISSING 5E
DEFINE_LIBRARY_FUNCTION SINTEGER  REBOOT(CONSTANT DEV A)                                                = $F05F;
DEFINE_LIBRARY_FUNCTION           DO_PUSH_TIMED(CONSTANT DEV A,CONSTANT LONG B,CONSTANT LONG C)         = $F060;
// How do you spell temerature???
DEFINE_LIBRARY_FUNCTION           SET_OUTDOOR_TEMPATURE(CONSTANT LONG A)                                = $F061;
DEFINE_LIBRARY_FUNCTION           SET_OUTDOOR_TEMPERATURE(CONSTANT LONG A)                              = $F061;
DEFINE_LIBRARY_FUNCTION           SET_VIRTUAL_LEVEL_COUNT(CONSTANT DEV A,CONSTANT LONG B)               = $F062;
DEFINE_LIBRARY_FUNCTION           SET_VIRTUAL_CHANNEL_COUNT(CONSTANT DEV A,CONSTANT LONG B)             = $F063;
DEFINE_LIBRARY_FUNCTION           SET_VIRTUAL_PORT_COUNT(CONSTANT DEV A,CONSTANT LONG B)                = $F064;
DEFINE_LIBRARY_FUNCTION CHAR      TYPE_CAST(CONSTANT VARIANT A)                                         = $F065;
DEFINE_LIBRARY_FUNCTION CHAR      RAW_BE(CONSTANT VARIANT A)                                            = $F066;
DEFINE_LIBRARY_FUNCTION CHAR      RAW_LE(CONSTANT VARIANT A)                                            = $F067;
DEFINE_LIBRARY_FUNCTION SINTEGER  ASTRO_CLOCK(CONSTANT DOUBLE A,CONSTANT DOUBLE B,CONSTANT DOUBLE C,
                                              CONSTANT CHAR D[],CHAR E[],CHAR F[])                      = $F068;
DEFINE_LIBRARY_FUNCTION CHAR      ABS_VALUE(CONSTANT VARIANT A)                                         = $F069;
DEFINE_LIBRARY_FUNCTION CHAR      MAX_VALUE(CONSTANT VARIANT A,CONSTANT VARIANT B)                      = $F06A;
DEFINE_LIBRARY_FUNCTION CHAR      MIN_VALUE(CONSTANT VARIANT A,CONSTANT VARIANT B)                      = $F06B;

DEFINE_LIBRARY_FUNCTION SINTEGER  VARIABLE_TO_XML(CONSTANT VARIANTARRAY A,CHAR B[], LONG C, LONG D)     = $F06C;
DEFINE_LIBRARY_FUNCTION SINTEGER  XML_TO_VARIABLE(VARIANTARRAY A,CONSTANT CHAR B[], LONG C, LONG D)     = $F06D;
DEFINE_LIBRARY_FUNCTION CHAR      LENGTH_VARIABLE_TO_XML(CONSTANT VARIANTARRAY A, LONG B)               = $F06E;

DEFINE_LIBRARY_FUNCTION CHAR      INTERNAL_QUEUE_SIZE_SET(CONSTANT LONG A,CONSTANT LONG B)              = $F070;
DEFINE_LIBRARY_FUNCTION CHAR      INTERNAL_QUEUE_SIZE_GET(CONSTANT LONG A)                              = $F071;
DEFINE_LIBRARY_FUNCTION CHAR      INTERNAL_THRESHOLD_SET(CONSTANT LONG A,CONSTANT LONG B)               = $F072;
DEFINE_LIBRARY_FUNCTION CHAR      INTERNAL_THRESHOLD_GET(CONSTANT LONG A)                               = $F073;

DEFINE_LIBRARY_FUNCTION           REBUILD_EVENT()                                                       = $F074;
DEFINE_LIBRARY_FUNCTION           DO_CUSTOM_EVENT(CONSTANT DEV A,CONSTANT TCUSTOM B)                    = $F075;

(*------------------------------------------------------------------------------------------------*)
(* End of Library Calls *)
(*------------------------------------------------------------------------------------------------*)

(*------------------------------------------------------------------------------------------------*)
(* End of File *)
(*------------------------------------------------------------------------------------------------*)
