.. _DTUnixTimeToQwordDateTime_x64:

===================================
DTUnixTimeToQwordDateTime 
===================================

Converts a ``QWORD`` containing a unix time integer value to ``QWORD`` values containing date and time information.
    
::

   DTUnixTimeToQwordDateTime PROTO UnixTime:QWORD


**Parameters**

* ``UnixTime`` - ``QWORD`` containing a unix time integer value to convert to ``QWORD`` date & time values.


**Returns**

On return ``RAX`` will contain the **date** information in the following format:

``RAX`` Register Bits:

 ::
 
    +--------------------------------------------------+------------------------+------------+-----------+
    | DWORD                                            | WORD                   | BYTE       | BYTE      |
    +--------------------------------------------------+------------------------+------------+-----------+
    | Bits 63-32                                       | Bits 31-16             | Bits 15-8  | Bits 7-0  |
    +--------------------------------------------------+------------------------+------------+-----------+
    | Not used - Not applicable                        | Century Year           | Month      | Day       |
    +--------------------------------------------------+------------------------+------------+-----------+
    | N/A                                              | CCCCYY                 | MM         | DD        |
    +--------------------------------------------------+------------------------+------------+-----------+
 

On return ``RDX`` will contain the **time** information in the following format:

``RDX`` Register Bits:

 ::
 
    +--------------------------------------------------+------------+------------+-----------+-----------+
    | DWORD                                            | BYTE       | BYTE       | BYTE      | BYTE      |
    +--------------------------------------------------+------------+------------+-----------+-----------+
    | Bits 63-32                                       | Bits 31-23 | Bits 23-16 | Bits 15-8 | Bits 7-0  |
    +--------------------------------------------------+------------+------------+-----------+-----------+
    | Not used - Not applicable                        | Hour       | Minute     | Second    | Millisec  |
    +--------------------------------------------------+------------+------------+-----------+-----------+
    | N/A                                              | HH         | MM         | SS        | MS        |
    +--------------------------------------------------+------------+------------+-----------+-----------+
 

**Notes**

Unix time is defined as the number of seconds elapsed since 00:00 Universal time on January 1, 1970 in the Gregorian calendar (Julian day 2440587.5)



**Example**

::

   .data?
   qwDate dq ?
   qwTime dq ?
   Year dw ?
   Month db ?
   Day db ?
   Hours db ?
   Minutes db ?
   Seconds db ?
   Millisec db ?
   
   .code
   Invoke DTUnixTimeToQwordDateTime, 1276278420
   mov qwDate, rax ; rax contains the date information
   mov qwTime, rdx ; rdx contains the time information
    
   mov rax, qwDate
   shr rax, 16 ; move year into upper word of rax 
   mov Year,  ax ; year
   mov rax, qwDate
   mov Month, ah ; month
   mov Day, al ; day
    
   mov rax, qwTime
   shr eax, 16 ; move hour and minute into upper word of eax 
   mov Hours, ah ; hours
   mov Minutes, al ; minutes
   mov rax, qwTime
   mov Seconds, ah ; seconds
   mov Millisec, al ; millseconds


**See Also**

:ref:`DTQwordDateTimeToUnixTime<DTQwordDateTimeToUnixTime_x64>`, :ref:`DTDateTimeStringToUnixTime<DTDateTimeStringToUnixTime_x64>`, :ref:`DTUnixTimeToDateTimeString<DTUnixTimeToDateTimeString_x64>`

