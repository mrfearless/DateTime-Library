.. _DTUnixTimeToDateTimeString:

===================================
DTUnixTimeToDateTimeString 
===================================

Converts a unix time ``UNIXTIMESTAMP`` value to a formatted date & time string as specified by the ``DateFormat`` parameter.

    
::

   DTUnixTimeToDateTimeString PROTO UnixTime:DWORD, lpszDateTimeString:DWORD, DateFormat:DWORD


**Parameters**

* ``UnixTime`` - Unix timestamp value ``UNIXTIMESTAMP`` to convert to a date & time string.
* ``lpszDateTimeString`` - Pointer to a buffer to store the date & time string. The format of the date & time string is determined by the ``DateFormat`` parameter.
* ``DateFormat`` - Value indicating the date & time format to return in the buffer pointed to by ``lpszDateTimeString`` parameter. The parameter can contain one of the following constants as listed in the :ref:`DateTime Formats<DateTime Formats>` page and as defined in the ``DateTime.inc`` include file.


**Returns**

There is no return value, the date & time string will contain the date & time as specified by the ``DateFormat`` specified.

**Notes**

Unix time is defined as the number of seconds elapsed since 00:00 Universal time on January 1, 1970 in the Gregorian calendar (Julian day 2440587.5)


**Example**

::

   .data
   DateTimeStringValue db DATETIME_STRING dup (0)
   
   .code
   Invoke DTUnixTimeToDateTimeString, 1276278420, Addr szDateTimeString, DDMMCCYYHHMMSSMS
   ; DateTimeString should now contain the string "11/06/2010 17:47:00:00"



**See Also**

:ref:`DTDateTimeStringToUnixTime<DTDateTimeStringToUnixTime>`, :ref:`DTDwordDateTimeToUnixTime<DTDwordDateTimeToUnixTime>`, :ref:`DateTime Formats<DateTime Formats>` 

