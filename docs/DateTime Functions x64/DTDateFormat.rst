.. _DTDateFormat_x64:

===================================
DTDateFormat 
===================================

Converts a SYSTEMTIME structure, pointed to by the ``lpSystermtimeStruct`` parameter, to a date & time string, into the buffer pointed to by the ``lpszDateTimeString`` parameter and returns it formatted as specified by the ``DateFormat`` parameter.
   
::

   DTDateFormat PROTO lpSystermtimeStruct:QWORD, lpszDateTimeString:QWORD, DateFormat:QWORD



**Parameters**

* ``lpSystermtimeStruct`` - Pointer to a `SYSTEMTIME <https://docs.microsoft.com/en-us/windows/win32/api/minwinbase/ns-minwinbase-systemtime>`_ type that contains date & time information to convert.
* ``lpszDateTimeString`` - Pointer to a buffer to store the date & time string. The format of the date & time string is determined by the ``DateFormat`` parameter.
* ``DateFormat`` - Value indicating the date & time format to return in the buffer pointed to by ``lpszDateTimeString`` parameter. The parameter can contain one of the following constants as listed in the :ref:`DateTime Formats<DateTime Formats>` page and as defined in the ``DateTime.inc`` include file:


   ::
   
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
   
   
   .. note:: Constants: CC=Century, YY=Year, MM=Month, DD=Day, HH=Hours, MM=Minutes, SS=Seconds, MS=Milliseconds, DOW=Day Of Week 
   
   
**Returns**

Returns in ``RAX`` ``TRUE`` if succesful, or ``FALSE`` otherwise.

**Notes**

The user is responsible for ensuring the buffer pointed to by the ``lpszDateTimeString`` parameter is large enought to hold the date & time string value. Recommeneded minimum size for the buffer is ``24`` bytes long as defined by the ``DATETIME_STRING`` constant.

**Example**

::

   .data
   LocalDateTime SYSTEMTIME <>
   szDataAndTimeString DB DATETIME_STRING DUP (0)
   
   .code
   Invoke GetLocalTime, Addr LocalDateTime
   Invoke DTDateFormat, Addr LocalDateTime, Addr szDataAndTimeString, DDMMYY


**See Also**

:ref:`DTGetDateTime<DTGetDateTime_x64>`, :ref:`DateTime Formats<DateTime Formats>`

