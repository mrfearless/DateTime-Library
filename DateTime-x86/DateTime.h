/*=============================================================================

 DateTime Library v1.0.0.3
 
 Copyright (c) 2022 by fearless
 
 All Rights Reserved
 
 http://github.com/mrfearless
 
 
 This software is provided 'as-is', without any express or implied warranty. 
 In no event will the author be held liable for any damages arising from the 
 use of this software.
 
 Permission is granted to anyone to use this software for any non-commercial 
 program. If you use the library in an application, an acknowledgement in the
 application or documentation is appreciated but not required. 
 
 You are allowed to make modifications to the source code, but you must leave
 the original copyright notices intact and not misrepresent the origin of the
 software. It is not allowed to claim you wrote the original software. 
 Modified files must have a clear notice that the files are modified, and not
 in the original state. This includes the name of the person(s) who modified 
 the code. 
 
 If you want to distribute or redistribute any portion of this package, you 
 will need to include the full package in it's original state, including this
 license and all the copyrights.  
 
 While distributing this package (in it's original state) is allowed, it is 
 not allowed to charge anything for this. You may not sell or include the 
 package in any commercial package without having permission of the author. 
 Neither is it allowed to redistribute any of the package's components with 
 commercial applications.
 
=============================================================================*/



#ifdef __cplusplus
extern "C" {
#endif

#ifdef _MSC_VER     // MSVC compiler
#define DT_EXPORT __declspec(dllexport) __stdcall
#else
#define DT_EXPORT
#endif

/*------------------------------------------
; DateTime Library Typedefs
;-----------------------------------------*/
// DateTime Typedefs
typedef size_t DATEFORMAT;          // Typedef for use of DateFormat parameter
typedef size_t JULIANDATE;          // Typedef for JulianDate
typedef size_t DATE;                // Typedef for Date
typedef size_t TIME;                // Typedef for Time
typedef size_t UNIXTIME;            // Typedef for UnixTime
typedef size_t MILLISECONDS;        // Typedef for Milliseconds
typedef size_t POINTER;             // Typedef for DWORD in x86, QWORD in x64



#define DATETIME_STRING             24 // Minimum size required of a DateTime buffer


/*-----------------------------------------------------------------------------
 DateFormat:
 ------------------------------------------------------------------------------
 Constants: CC=Century, YY=Year, MM=Month, DD=Day, HH=Hours, MM=Minutes, 
 SS=Seconds, MS=Milliseconds, DOW=Day Of Week 
-----------------------------------------------------------------------------*/

// Reverse Date Formats
#define CCYYMMDDHHMMSSMS                    1  // 1974/03/27 14:53:01:00
#define CCYYMMDDHHMMSS                      2  // 1974/03/27 14:53:01
#define CCYYMMDDHHMM                        3  // 1974/03/27 14:53
#define CCYYMMDDHH                          4  / 1974/03/27 14:53
#define CCYYMMDD                            5  // 1974/03/27
#define CCYYMM                              6  // 1974/03
#define YEAR                                7  // 1974

// British Date Formats              
#define DDMMCCYYHHMMSSMS                    8  // 27/03/1974 14:53:01:00
#define DDMMCCYYHHMMSS                      9  // 27/03/1974 14:53:01
#define DDMMCCYYHHMM                        10 // 27/03/1974 14:53
#define DDMMCCYY                            11 // 27/03/1974
#define DDMM                                12 // 27/03
#define DAY                                 13 // 27

// American Date Formats             
#define MMDDCCYYHHMMSSMS                    14 // 03/27/1974 14:53:01:00
#define MMDDCCYYHHMMSS                      15 // 03/27/1974 14:53:01                
#define MMDDCCYYHHMM                        16 // 03/27/1974 14:53                   
#define MMDDCCYY                            17 // 03/27/1974                     
#define MMDD                                18 // 03/27          
#define MONTH                               19 // 03

// Reverse Without Century Date Formats
#define YYMMDDHHMMSSMS                      20 // 74/03/27 14:53:01:00
#define YYMMDDHHMMSS                        21 // 74/03/27 14:53:01
#define YYMMDDHHMM                          22 // 74/03/27 14:53
#define YYMMDD                              23 // 74/03/27
#define YYMM                                24 // 74/03
#define YY                                  25 // 74

// Other Date Formats                
#define MMDDYY                              26 // 03/27/74
#define DDMMYY                              27 // 27/03/74
#define DAYOFWEEK                           28 // Monday

// Time Formats                      
#define HHMMSSMS                            29 // 14:53:01
#define HHMMSS                              30 // 14:53:01       
#define HHMM                                31 // 14:53
#define HH                                  32 // 14

// UnixTimeStamp string
#define UNIXTIMESTAMP                       33 // "1276278420"

; Useful Named Constants            
#define TODAY                               DDMMCCYYHHMMSS
#define NOW                                 DDMMCCYYHHMMSS
#define TIME                                HHMM

// Named Date Constants              
#define AMERICAN                            MMDDYY
#define BRITISH                             DDMMYY
#define FRENCH                              DDMMYY
#define JAPAN                               YYMMDD
#define TAIWAN                              YYMMDD
#define MDY                                 MMDDYY
#define DMY                                 DDMMYY  
#define YMD                                 YYMMDD


/*-----------------------------------------------------------------------------
 DateTime Prototypes
-----------------------------------------------------------------------------*/

// Get current Date & Time in specified format
bool DT_EXPORT DTGetDateTime(LPCSTR *lpszDateTimeString, DATEFORMAT DateFormat);

// Format SYSTEMTIME as Date & Time
bool DT_EXPORT DTDateFormat(POINTER *lpSystermtimeStruct, LPCSTR *lpszDateTimeString, DATEFORMAT DateFormat);

// DateTime String <=> Dword DateTime Functions
DATE, TIME DT_EXPORT DTDateTimeStringToDwordDateTime(LPCSTR *lpszDateTimeString, DATEFORMAT DateFormat);
void DT_EXPORT DTDwordDateTimeToDateTimeString(DATE dwDate, TIME dwTime, LPCSTR *lpszDateTimeString, DATEFORMAT DateFormat);

// Dword Date <=> Julian Date Functions
JULIANDATE DT_EXPORT DTDwordDateToJulianDate(DATE dwDate);
DATE DT_EXPORT DTJulianDateToDwordDate(JULIANDATE JulianDate);

// DateTime String <=> Julian Date & Millisec Functions
JULIANDATE, MILLISECONDS DT_EXPORT DTDateTimeStringToJulianMillisec(LPCSTR *lpszDateTimeString, DATEFORMAT DateFormat);
void DT_EXPORT DTJulianMillisecToDateTimeString(JULIANDATE JulianDate, MILLISECONDS Milliseconds, LPCSTR *lpszDateTimeString, DATEFORMAT DateFormat);

// Dword DateTime <=> Julian Date & Millisec Functions
JULIANDATE, MILLISECONDS DT_EXPORT DTDwordDateTimeToJulianMillisec(DATE dwDate, TIME dwTime);
DATE, TIME DT_EXPORT DTJulianMillisecToDwordDateTime(JULIANDATE JulianDate, MILLISECONDS Milliseconds);

// DateTime String <=> UnixTime Functions
UNIXTIME DT_EXPORT DTDateTimeStringToUnixTime(LPCSTR *lpszDateTimeString, DATEFORMAT DateFormat);
void DT_EXPORT DTUnixTimeToDateTimeString(UNIXTIME UnixTime, LPCSTR *lpszDateTimeString, DATEFORMAT DateFormat);

// Dword DateTime <=> UnixTime Functions
UNIXTIME DT_EXPORT DTDwordDateTimeToUnixTime(DATE dwDate, TIME dwTime);
DATE, TIME DT_EXPORT DTUnixTimeToDwordDateTime(UNIXTIME UnixTime);

// Dword Time <=> Millisec Functions
MILLISECONDS DT_EXPORT DTDwordTimeToMillisec(TIME dwTime);
TIME DT_EXPORT DTMillisecToDwordTime(MILLISECONDS Milliseconds);

// Misc Date Functions
int DT_EXPORT DTDayOfWeek(LPCSTR *lpszDateTimeString, DATEFORMAT DateFormat);
bool DT_EXPORT DTIsLeapYear(DWORD dwYear);
int DT_EXPORT DTDay(LPCSTR *lpszDateTimeString, DATEFORMAT DateFormat);
int DT_EXPORT DTMonth(LPCSTR *lpszDateTimeString, DATEFORMAT DateFormat);
int DT_EXPORT DTYear(LPCSTR *lpszDateTimeString, DATEFORMAT DateFormat);

// Date and Date & Time Comparison Functions
int DT_EXPORT DTDateStringsCompare(LPCSTR *lpszDateTimeString1, LPCSTR *lpszDateTimeString2, DATEFORMAT DateFormat);
int DT_EXPORT DTDateStringsDifference(LPCSTR *lpszDateTimeString1, LPCSTR *lpszDateTimeString2, DATEFORMAT DateFormat);
int DT_EXPORT DTDateTimeStringsDifference(LPCSTR *lpszDateTimeString1, LPCSTR *lpszDateTimeString2, DATEFORMAT DateFormat);



#ifdef __cplusplus
}
#endif
