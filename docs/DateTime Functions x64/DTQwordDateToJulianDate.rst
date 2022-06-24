.. _DTQwordDateToJulianDate_x64:

===================================
DTQwordDateToJulianDate 
===================================

Converts a ``QWORD`` value containing date information to a Julian date integer. On return ``RAX`` contains the date information in Julian Date format.
    
::

   DTQwordDateToJulianDate PROTO qwDate:QWORD


**Parameters**

* ``qwDate`` - ``QWORD`` value containing **Date** information to convert to a Julian date integer.

 The format for the value containing the **date** information is as follows:
 
 **date** ``QWORD`` Register Bits:
 
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


**Returns**

On return ``RAX`` contains Julian date integer value representing the date specified.

**Notes**

The Julian Day Count is a uniform count of days from a remote epoch in the past (-4712 January 1, 12 hours Greenwich Mean Time (Julian proleptic Calendar) = 4713 BCE January 1, 12 hours GMT (Julian proleptic Calendar) At this instant, the Julian Day Number is 0. 
 

The Julian Day Count has nothing to do with the Julian Calendar introduced by Julius Caesar. It is named for Julius Scaliger, the father of Josephus Justus Scaliger, who invented the concept. It can also be thought of as a logical follow-on to the old Egyptian civil calendar, which also used years of constant lengths.
 

Scaliger chose the particular date in the remote past because it was before recorded history and because in that year, three important cycles coincided with their first year of the cycle: The 19-year Metonic Cycle, the 15-year Indiction Cycle (a Roman Taxation Cycle) and the 28-year Solar Cycle (the length of time for the old Julian Calendar to repeat exactly).



**Example**

::

   .data
   Day db 15
   Month db 10
   CentYear dw 1582
   DateValue dq 0
   
   .code
   xor rax, rax
   mov ax, CentYear
   shl rax, 16 ; move year into upper word of rax
   mov ah, Month ; move month into ah
   mov al, Day ; move day into al
   mov DateValue, rax
   
   Invoke DTQwordDateToJulianDate, DateValue
   ; EAX now contains 2299161 which is the Julian Date for 1582 October 15

**See Also**

:ref:`DTJulianDateToQwordDate<DTJulianDateToQwordDate_x64>`, :ref:`DTMillisecToQwordTime<DTMillisecToQwordTime_x64>`, :ref:`DTQwordDateTimeToJulianMillisec<DTQwordDateTimeToJulianMillisec_x64>`, :ref:`DTJulianMillisecToQwordDateTime<DTJulianMillisecToQwordDateTime_x64>`

