.. _DTDateTimeStringToUnixTime_x64:

===================================
DTDateTimeStringToUnixTime 
===================================

Converts a formatted date & time string to a ``QWORD`` value containing a unix time integer value.
    
::

   DTDateTimeStringToUnixTime PROTO lpszDateTimeString:QWORD, DateFormat:QWORD


**Parameters**

* ``lpszDateTimeString`` - Pointer to a buffer containing the date & time string to convert to a ``QWORD`` value containing a unix time integer value. The format of the date & time string is determined by the ``DateFormat`` parameter.
* ``DateFormat`` - Value indicating the date & time format used in the buffer pointed to by ``lpszDateTimeString`` parameter.  The parameter can contain one of the following constants as listed in the :ref:`DateTime Formats<DateTime Formats>` page and as defined in the ``DateTime.inc`` include file.


**Returns**

On return ``RAX`` contains the unix time as a ``QWORD`` value.

**Notes**

Some information may be unavailable to convert if the passed DateTime string does not contain enough information. For example if only year information is in the DateTime string, then the UnixTime will be based only on that.

To prevent this, always pass a full date time string of ``CCYYMMDDHHMMSSMS`` format or similar (``DDMMCCYYHHMMSSMS`` or ``MMDDCCYYHHMMSSMS``)

Unix time is defined as the number of seconds elapsed since 00:00 Universal time on January 1, 1970 in the Gregorian calendar (Julian day 2440587.5)

The ``UNIXTIMESTAMP`` format is a **string** representation of the unix time in integer format if used as the ``DateFormat`` value.


**Example**

::

   .data
   DateTimeStringValue db "2008/03/21 16:21:01:00",0
   
   .data?
   UnixTime dq ?
   
   .code
   Invoke DTDateTimeStringToUnixTime, Addr DateTimeStringValue, CCYYMMDDHHMMSSMS
   mov UnixTime, rax ; save unix time value to data variable which should contain 1206116461


**Example**

::

   .data
   UnixTimeAsAStringValue db "1656241202",0 ; Sun Jun 26 2022 11:00
   
   .data?
   UnixTime dq ?
   
   .code
   Invoke DTDateTimeStringToUnixTime, Addr UnixTimeAsAStringValue, UNIXTIMESTAMP
   mov UnixTime, rax ; save unix time value to data variable which should contain 1656241202



**See Also**

:ref:`DTUnixTimeToDateTimeString<DTUnixTimeToDateTimeString_x64>`, :ref:`DTUnixTimeToQwordDateTime<DTUnixTimeToQwordDateTime_x64>`, :ref:`DateTime Formats<DateTime Formats>`

