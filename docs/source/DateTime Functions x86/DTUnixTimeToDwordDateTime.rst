.. _DTUnixTimeToDwordDateTime:

===================================
DTUnixTimeToDwordDateTime 
===================================

Converts a unix time ``UNIXTIMESTAMP`` value to ``DWORD`` values containing date and time information.
    
::

   DTUnixTimeToDwordDateTime PROTO UnixTime:DWORD


**Parameters**

* ``UnixTime`` - Unix timestamp value ``UNIXTIMESTAMP`` to convert to ``DWORD`` date & time values.


**Returns**

On return ``EAX`` will contain the **date** information in the following format:

``EAX`` Register Bits:

 ::
 
    +------------------------+------------+-----------+
    | WORD                   | BYTE       | BYTE      |
    +------------------------+------------+-----------+
    | Bits 31-16             | Bits 15-8  | Bits 7-0  |
    +------------------------+------------+-----------+
    | Century Year           | Month      | Day       |
    +------------------------+------------+-----------+
    | CCCCYY                 | MM         | DD        |
    +------------------------+------------+-----------+
   

On return ``EDX`` will contain the **time** information in the following format:

``EDX`` Register Bits:

   ::
 
    +------------+------------+-----------+-----------+
    | BYTE       | BYTE       | BYTE      | BYTE      |
    +------------+------------+-----------+-----------+
    | Bits 31-23 | Bits 23-16 | Bits 15-8 | Bits 7-0  |
    +------------+------------+-----------+-----------+
    | Hour       | Minute     | Second    | Millisec  |
    +------------+------------+-----------+-----------+
    | HH         | MM         | SS        | MS        |
    +------------+------------+-----------+-----------+


**Notes**

Unix time is defined as the number of seconds elapsed since 00:00 Universal time on January 1, 1970 in the Gregorian calendar (Julian day 2440587.5)



**Example**

::

   .data?
   dwDate dd ?
   dwTime dd ?
   Year dw ?
   Month db ?
   Day db ?
   Hours db ?
   Minutes db ?
   Seconds db ?
   Millisec db ?
   
   .code
   Invoke DTUnixTimeToDwordDateTime, 1276278420
   mov dwDate, eax ; eax contains the date information
   mov dwTime, edx ; edx contains the time information
    
   mov eax, dwDate
   shr eax, 16 ; move year into upper word of eax 
   mov Year,  ax ; year
   mov eax, dwDate
   mov Month, ah ; month
   mov Day, al ; day
    
   mov eax, dwTime
   shr eax, 16 ; move hour and minute into upper word of eax 
   mov Hours, ah ; hours
   mov Minutes, al ; minutes
   mov eax, dwTime
   mov Seconds, ah ; seconds
   mov Millisec, al ; millseconds


**See Also**

:ref:`DTDwordDateTimeToUnixTime<DTDwordDateTimeToUnixTime>`, :ref:`DTDateTimeStringToUnixTime<DTDateTimeStringToUnixTime>`, :ref:`DTUnixTimeToDateTimeString<DTUnixTimeToDateTimeString>`

