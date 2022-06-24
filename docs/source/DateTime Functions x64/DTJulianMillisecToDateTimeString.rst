.. _DTJulianMillisecToDateTimeString_x64:

===================================
DTJulianMillisecToDateTimeString 
===================================

Converts a Julian date integer and millisec time to a formatted date & time string as specified by the ``DateFormat`` parameter.
    
::

   DTJulianMillisecToDateTimeString PROTO JulianDate:QWORD, Milliseconds:QWORD, lpszDateTimeString:QWORD, DateFormat:QWORD


**Parameters**

* ``JulianDate`` - A ``QWORD`` value containing the Julian date integer to convert to a gregorian date in the date & time string.
* ``Milliseconds`` - A ``QWORD`` value containting the total milliseconds to convert to hours, minutes, seconds and milliseconds in the date & time string.
* ``lpszDateTimeString`` - Pointer to a buffer to store the date & time string. The format of the date & time string is determined by the ``DateFormat`` parameter.
* ``DateFormat`` - Value indicating the date & time format to return in the buffer pointed to by ``lpszDateTimeString`` parameter.  The parameter can contain one of the following constants as listed in the :ref:`DateTime Formats<DateTime Formats>` page and as defined in the ``DateTime.inc`` include file.


**Returns**

There is no return value, the date & time string will contain the date & time as specified by the ``DateFormat`` parameter.

**Notes**

No time information is converted with the Julian date value, so if formatting outputs a time, it will be empty as in ``00:00:00:00``

**Example**

::

   .data
   DateTimeStringValue db DATETIME_STRING dup (0) ; buffer to store date and time as string
   
   .code
   Invoke DTJulianMillisecToDateTimeString, 2299161, 0, Addr DateTimeStringValue, CCYYMMDDHHMMSS
   ; DateTimeStringValue now contains: 1582/10/15 00:00:00


**See Also**

:ref:`DTDateTimeStringToJulianMillisec<DTDateTimeStringToJulianMillisec_x64>`, :ref:`DateTime Formats<DateTime Formats>` 

