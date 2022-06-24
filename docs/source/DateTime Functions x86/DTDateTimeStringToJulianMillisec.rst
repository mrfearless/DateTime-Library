.. _DTDateTimeStringToJulianMillisec:

===================================
DTDateTimeStringToJulianMillisec 
===================================

Converts a formatted date & time string to a Julian date integer in ``EAX`` and milliseconds in ``EDX``
    
::

   DTDateTimeStringToJulianMillisec PROTO lpszDateTimeString:DWORD, DateFormat:DWORD


**Parameters**

* ``lpszDateTimeString`` - Pointer to a buffer containing the date & time string to convert to Julian date integer and millisec values. The format of the date & time string is determined by the ``DateFormat`` parameter.
* ``DateFormat`` - Value indicating the date & time format used in the buffer pointed to by ``lpszDateTimeString`` parameter. The parameter can contain one of the following constants as listed in the :ref:`DateTime Formats<DateTime Formats>` page and as defined in the ``DateTime.inc`` include file.


**Returns**

On return ``EAX`` contains Julian date integer value representing the date specified and ``EDX`` will contain the total time in milliseconds.


**Notes**

Some information may be unavailable to convert if the passed DateTime string does not contain enough information. For example if only year information is in the DateTime string, then the Julian date and millisec time will be based only on that.

To prevent this, always pass a full date time string of ``CCYYMMDDHHMMSSMS`` format or similar (``DDMMCCYYHHMMSSMS`` or ``MMDDCCYYHHMMSSMS``)

The Julian Day Count is a uniform count of days from a remote epoch in the past (-4712 January 1, 12 hours Greenwich Mean Time (Julian proleptic Calendar) = 4713 BCE January 1, 12 hours GMT (Julian proleptic Calendar) At this instant, the Julian Day Number is 0. 

The Julian Day Count has nothing to do with the Julian Calendar introduced by Julius Caesar. It is named for Julius Scaliger, the father of Josephus Justus Scaliger, who invented the concept. It can also be thought of as a logical follow-on to the old Egyptian civil calendar, which also used years of constant lengths.

Scaliger chose the particular date in the remote past because it was before recorded history and because in that year, three important cycles coincided with their first year of the cycle: The 19-year Metonic Cycle, the 15-year Indiction Cycle (a Roman Taxation Cycle) and the 28-year Solar Cycle (the length of time for the old Julian Calendar to repeat exactly).


**Example**

::

   .data
   DateTimeStringValue db "2008/03/21 16:21:01:00",0
   
   .data?
   JulianDateValue dd ?
   TotalMilliseconds dd ?
   
   .code
   Invoke DTDateTimeStringToJulianMillisec, Addr DateTimeStringValue
   mov JulianDateValue, eax ; save julian date value to data variable
   mov TotalMilliseconds, edx ; save total milliseconds to data variable


**Example**

::

   .data?
   dwDate1 dd ?
   dwDate2 dd ?
   
   .code
   ;==========================================================================================
   ; Example to calculate difference in 2 date values over month boundary
   Invoke DTDateTimeStringToJulianMillisec, CTEXT("27/02/2009"), DDMMCCYY
   mov dwDate1, eax ; save dword date portion to variable, ignore edx which contains time info
    
   Invoke DTDateTimeStringToJulianMillisec, CTEXT("03/03/2009"), DDMMCCYY
   mov dwDate2, eax ; save dword date portion to variable, ignore edx which contains time info
    
   mov ebx, dwDate1 ; Place date1 in ebx
   sub eax, ebx ; subtract date2 from date1, eax = 4 days
    
   ;==========================================================================================
   ; Another example to calculate difference in weeks between 2 date values
   Invoke DTDateTimeStringToJulianMillisec, CTEXT("03/01/2009"), DDMMCCYY
   mov dwDate1, eax ; save dword date portion to variable, ignore edx which contains time info
    
   Invoke DTDateTimeStringToJulianMillisec, CTEXT("10/01/2009"), DDMMCCYY
   mov dwDate2, eax ; save dword date portion to variable, ignore edx which contains time info
    
   mov ebx, dwDate1 ; Place date1 in ebx
   sub eax, ebx ; subtract date2 from date1, eax = 7 days
   xor edx, edx ; clear edx for division
   mov ecx, 7d ; Divisor is 7 in ecx
   div ecx ; divide eax by 7, eax = 1 


**See Also**

:ref:`DTJulianMillisecToDateTimeString<DTJulianMillisecToDateTimeString>`

