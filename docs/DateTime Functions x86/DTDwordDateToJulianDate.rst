.. _DTDwordDateToJulianDate:

===================================
DTDwordDateToJulianDate 
===================================

Converts a ``DWORD`` value containing date information to a Julian date integer. On return ``EAX`` contains the date information in Julian Date format.
    
::

   DTDwordDateToJulianDate PROTO dwDate:DWORD


**Parameters**

* ``dwDate`` - ``DWORD`` value containing **Date** information to convert to a Julian date integer.

 The format for the value containing the **date** information is as follows:
 
 **date** ``DWORD`` Register Bits:
 
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


**Returns**

On return ``EAX`` contains Julian date integer value representing the date specified.

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
   DateValue dd 0
   
   .code
   xor eax, eax
   mov ax, CentYear
   shl eax, 16 ; move year into upper word of eax
   mov ah, Month ; move month into ah
   mov al, Day ; move day into al
   mov DateValue, eax
   
   Invoke DTDwordDateToJulianDate, DateValue
   ; EAX now contains 2299161 which is the Julian Date for 1582 October 15

**See Also**

:ref:`DTJulianDateToDwordDate<DTJulianDateToDwordDate>`, :ref:`DTMillisecToDwordTime<DTMillisecToDwordTime>`, :ref:`DTDwordDateTimeToJulianMillisec<DTDwordDateTimeToJulianMillisec>`, :ref:`DTJulianMillisecToDwordDateTime<DTJulianMillisecToDwordDateTime>`

