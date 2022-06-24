.. _DTJulianDateToQwordDate_x64:

===================================
DTJulianDateToQwordDate 
===================================

Converts a Julian Date number to a ``QWORD`` value containing date information. Uses ``CCYYMMDD`` :ref:`DateTime Format<DateTime Formats>`

    
::

   DTJulianDateToQwordDate PROTO JulianDate:QWORD


**Parameters**

* ``JulianDate`` - A ``QWORD`` value containing the Julian date integer to convert to a ``QWORD`` format in ``RAX``


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
 

**Notes**

The Julian Day Count is a uniform count of days from a remote epoch in the past (-4712 January 1, 12 hours Greenwich Mean Time (Julian proleptic Calendar) = 4713 BCE January 1, 12 hours GMT (Julian proleptic Calendar) At this instant, the Julian Day Number is 0. 
 

The Julian Day Count has nothing to do with the Julian Calendar introduced by Julius Caesar. It is named for Julius Scaliger, the father of Josephus Justus Scaliger, who invented the concept. It can also be thought of as a logical follow-on to the old Egyptian civil calendar, which also used years of constant lengths.
 

Scaliger chose the particular date in the remote past because it was before recorded history and because in that year, three important cycles coincided with their first year of the cycle: The 19-year Metonic Cycle, the 15-year Indiction Cycle (a Roman Taxation Cycle) and the 28-year Solar Cycle (the length of time for the old Julian Calendar to repeat exactly).

**Example**

::

   .data
   Day db 0
   Month db 0
   CentYear dw 0
   
   .code
   Invoke DTJulianDateToQwordDate, 2299161 ; Gregorian date of this Julian Date value is 1582 October 15
   
   mov rdx, rax
   mov Month, ah
   mov Day, al
   shr rax, 16 ; move year info into lower word of eax
   mov CentYear, ax
   
   ; 1582 October 15 - CentYear now contains 1582, Month contains 10, Day contains 15


**See Also**

:ref:`DTQwordDateToJulianDate<DTQwordDateToJulianDate_x64>`

