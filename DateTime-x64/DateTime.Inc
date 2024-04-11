;==============================================================================
;
; DateTime Library x64 v1.0.0.4
;
; Copyright (c) 2024 by fearless
;
; All Rights Reserved
;
; http://github.com/mrfearless
;
;
; This software is provided 'as-is', without any express or implied warranty. 
; In no event will the author be held liable for any damages arising from the 
; use of this software.
;
; Permission is granted to anyone to use this software for any non-commercial 
; program. If you use the library in an application, an acknowledgement in the
; application or documentation is appreciated but not required. 
;
; You are allowed to make modifications to the source code, but you must leave
; the original copyright notices intact and not misrepresent the origin of the
; software. It is not allowed to claim you wrote the original software. 
; Modified files must have a clear notice that the files are modified, and not
; in the original state. This includes the name of the person(s) who modified 
; the code. 
;
; If you want to distribute or redistribute any portion of this package, you 
; will need to include the full package in it's original state, including this
; license and all the copyrights.  
;
; While distributing this package (in it's original state) is allowed, it is 
; not allowed to charge anything for this. You may not sell or include the 
; package in any commercial package without having permission of the author. 
; Neither is it allowed to redistribute any of the package's components with 
; commercial applications.
;
;==============================================================================


;------------------------------------------------------------------------------
; Useful links for gregorian, julian, millisec, unixtime topics & algorithms
;------------------------------------------------------------------------------
; 
; Perpetual Calendar Weekday computation in your head by lutz: 
; https://katzentier.de/_misc/perpetual_calendar.htm
; 
; Julian Day Numbers by William H. Jefferys:
; https://quasar.as.utexas.edu/BillInfo/JulianDatesG.html
; 
; Julian Day Numbers by Peter Meyer:
; https://www.hermetic.ch/cal_stud/jdn.htm
; 
; Julian Day Numbers Using Calgo #199 by Paul Myers:
; http://pmyers.pcug.org.au/General/JulianDates.htm
; 
; Julian Day Numbers for dates on the Gregorian and Julian Calendars by Kelley L. Ross:
; https://www.friesian.com/numbers.htm
; 
; How to calculate a Julian Date:
; https://aa.usno.navy.mil/faq/docs/JD_Formula.php (500 error)
; https://forum.arduino.cc/t/how-to-calculate-a-julian-date/606010
; 
; Time format conversions SYSTEMTIME to FILETIME to SQL time string to Unix time_t by John Stewien:
; https://johnstewien.wordpress.com/2008/05/01/time-format-conversions-systemtime-to-filetime-to-sql-time-string-to-unix-time_t/
; 
; Convert milliseconds to time:
; https://www.coderanch.com/t/378404/java/Convert-milliseconds-time
; 
; Convert to Unix Time:
; https://onlineconversion.vbulletin.net/forum/main-forums/convert-and-calculate/4721-convert-to-unix-time?t=8126
; 
; Calendar Converter by John Walker:
; https://www.fourmilab.ch/documents/calendar/
; 
; Gregorian calendar:
; https://en.wikipedia.org/wiki/Gregorian_calendar
;
; Unix Time Stamp - Epoch Converter
; https://www.unixtimestamp.com/index.php

;------------------------------------------------------------------------------
; DateTime Prototypes
;------------------------------------------------------------------------------
; Get current Date & Time in specified format
DTGetDateTime                       PROTO lpszDateTimeString:QWORD, DateFormat:QWORD

; Format SYSTEMTIME as Date & Time
DTDateFormat                        PROTO lpSystermtimeStruct:QWORD, lpszDateTimeString:QWORD, DateFormat:QWORD

DTDateTimeStringToDateTimeString    PROTO lpszDateTimeStringIn:QWORD, DateFormatIn:QWORD, lpszDateTimeStringOut:QWORD, DateFormatOut:QWORD

; DateTime String <=> QWORD DateTime Functions
DTDateTimeStringToQwordDateTime     PROTO lpszDateTimeString:QWORD, DateFormat:QWORD
DTQwordDateTimeToDateTimeString     PROTO qwDate:QWORD, qwTime:QWORD, lpszDateTimeString:QWORD, DateFormat:QWORD

; Dword Date <=> Julian Date Functions
DTQwordDateToJulianDate             PROTO qwDate:QWORD
DTJulianDateToQwordDate             PROTO JulianDate:QWORD

; DateTime String <=> Julian Date & Millisec Functions
DTDateTimeStringToJulianMillisec    PROTO lpszDateTimeString:QWORD, DateFormat:QWORD
DTJulianMillisecToDateTimeString    PROTO JulianDate:QWORD, Milliseconds:QWORD, lpszDateTimeString:QWORD, DateFormat:QWORD

; Dword DateTime <=> Julian Date & Millisec Functions
DTQwordDateTimeToJulianMillisec     PROTO qwDate:QWORD, qwTime:QWORD
DTJulianMillisecToQwordDateTime     PROTO JulianDate:QWORD, Milliseconds:QWORD

; DateTime String <=> UnixTime Functions
DTDateTimeStringToUnixTime          PROTO lpszDateTimeString:QWORD, DateFormat:QWORD
DTUnixTimeToDateTimeString          PROTO UnixTime:QWORD, lpszDateTimeString:QWORD, DateFormat:QWORD

; Dword DateTime <=> UnixTime Functions
DTQwordDateTimeToUnixTime           PROTO qwDate:QWORD, qwTime:QWORD
DTUnixTimeToQwordDateTime           PROTO UnixTime:QWORD

; Dword Time <=> Millisec Functions
DTQwordTimeToMillisec               PROTO qwTime:QWORD
DTMillisecToQwordTime               PROTO Milliseconds:QWORD

; Misc Date Functions
DTDayOfWeek                         PROTO lpszDateTimeString:QWORD, DateFormat:QWORD
DTIsLeapYear                        PROTO qwYear:QWORD
DTDay                               PROTO lpszDateTimeString:QWORD, DateFormat:QWORD
DTMonth                             PROTO lpszDateTimeString:QWORD, DateFormat:QWORD
DTYear                              PROTO lpszDateTimeString:QWORD, DateFormat:QWORD

; Date and Date & Time Comparison Functions
DTDateStringsCompare                PROTO lpszDateTimeString1:QWORD, lpszDateTimeString2:QWORD, DateFormat:QWORD
DTDateStringsDifference             PROTO lpszDateTimeString1:QWORD, lpszDateTimeString2:QWORD, DateFormat:QWORD
DTDateTimeStringsDifference         PROTO lpszDateTimeString1:QWORD, lpszDateTimeString2:QWORD, DateFormat:QWORD

;------------------------------------------------------------------------------
; Function Groupings
;------------------------------------------------------------------------------

; DateTime String Conversion Grouping:
DTDateTimeStringToQwordDateTime     PROTO lpszDateTimeString:QWORD, DateFormat:QWORD
DTDateTimeStringToJulianMillisec    PROTO lpszDateTimeString:QWORD, DateFormat:QWORD
DTDateTimeStringToUnixTime          PROTO lpszDateTimeString:QWORD, DateFormat:QWORD

; Dword DateTime Conversion Grouping:
DTQwordDateTimeToDateTimeString     PROTO dwDate:QWORD, dwTime:QWORD, lpszDateTimeString:QWORD, DateFormat:QWORD
DTQwordDateTimeToJulianMillisec     PROTO dwDate:QWORD, dwTime:QWORD
DTQwordDateTimeToUnixTime           PROTO dwDate:QWORD, dwTime:QWORD

; Julian Date & Millisec Conversion Grouping:
DTJulianMillisecToDateTimeString    PROTO JulianDate:QWORD, Milliseconds:QWORD, lpszDateTimeString:QWORD, DateFormat:QWORD
DTJulianMillisecToQwordDateTime     PROTO JulianDate:QWORD, Milliseconds:QWORD



.CONST
DATETIME_ALIGN                      TEXTEQU <ALIGN 16>
DATETIME_STRING                     EQU 24 ; Minimum size required of a DateTime string buffer
;-----------------------------------------------------------------------------------------
; DateFormat:
;-----------------------------------------------------------------------------------------
; Constants: CC=Century, YY=Year, MM=Month, DD=Day, HH=Hours, MM=Minutes, DOW=Day Of Week 

; Reverse Date Formats
CCYYMMDDHHMMSSMS                    EQU 1  ; Example 1974/03/27 14:53:01:00
CCYYMMDDHHMMSS                      EQU 2  ; Example 1974/03/27 14:53:01
CCYYMMDDHHMM                        EQU 3  ; Example 1974/03/27 14:53
CCYYMMDDHH                          EQU 4  ; Example 1974/03/27 14:53
CCYYMMDD                            EQU 5  ; Example 1974/03/27
CCYYMM                              EQU 6  ; Example 1974/03
YEAR                                EQU 7  ; Example 1974

; British Date Formats              
DDMMCCYYHHMMSSMS                    EQU 8  ; Example 27/03/1974 14:53:01:00
DDMMCCYYHHMMSS                      EQU 9  ; Example 27/03/1974 14:53:01
DDMMCCYYHHMM                        EQU 10 ; Example 27/03/1974 14:53
DDMMCCYY                            EQU 11 ; Example 27/03/1974
DDMM                                EQU 12 ; Example 27/03
DAY                                 EQU 13 ; Example 27

; American Date Formats             
MMDDCCYYHHMMSSMS                    EQU 14 ; Example 03/27/1974 14:53:01:00
MMDDCCYYHHMMSS                      EQU 15 ; Example 03/27/1974 14:53:01                
MMDDCCYYHHMM                        EQU 16 ; Example 03/27/1974 14:53                   
MMDDCCYY                            EQU 17 ; Example 03/27/1974                     
MMDD                                EQU 18 ; Example 03/27          
MONTH                               EQU 19 ; Example 03

; Reverse Without Century Date Formats
YYMMDDHHMMSSMS                      EQU 20 ; Example 74/03/27 14:53:01:00
YYMMDDHHMMSS                        EQU 21 ; Example 74/03/27 14:53:01
YYMMDDHHMM                          EQU 22 ; Example 74/03/27 14:53
YYMMDD                              EQU 23 ; Example 74/03/27
YYMM                                EQU 24 ; Example 74/03
YY                                  EQU 25 ; Example 74

; Other Date Formats                
MMDDYY                              EQU 26 ; Example 03/27/74
DDMMYY                              EQU 27 ; Example 27/03/74
DAYOFWEEK                           EQU 28 ; Example Monday

; Time Formats                      
HHMMSSMS                            EQU 29 ; Example 14:53:01
HHMMSS                              EQU 30 ; Example 14:53:01       
HHMM                                EQU 31 ; Example 14:53
HH                                  EQU 32 ; Example 14

; UnixTimeStamp string
UNIXTIMESTAMP                       EQU 33 ; Example "1276278420"

; Useful Named Constants            
TODAY                               EQU DDMMCCYYHHMMSS
NOW                                 EQU DDMMCCYYHHMMSS
TIME                                EQU HHMM

; Named Date Constants              
AMERICAN                            EQU MMDDYY
BRITISH                             EQU DDMMYY
FRENCH                              EQU DDMMYY
JAPAN                               EQU YYMMDD
TAIWAN                              EQU YYMMDD
MDY                                 EQU MMDDYY
DMY                                 EQU DDMMYY  
YMD                                 EQU YYMMDD

