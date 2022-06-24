.. _DTDateTimeStringToUnixTime:

===================================
DTDateTimeStringToUnixTime 
===================================

Converts a formatted date & time string to a unix time ``UNIXTIMESTAMP`` value.
    
::

   DTDateTimeStringToUnixTime PROTO lpszDateTimeString:DWORD, DateFormat:DWORD


**Parameters**

* ``lpszDateTimeString`` - Pointer to a buffer containing the date & time string to convert to a ``UNIXTIMESTAMP`` value. The format of the date & time string is determined by the ``DateFormat`` parameter.
* ``DateFormat`` - Value indicating the date & time format used in the buffer pointed to by ``lpszDateTimeString`` parameter. The parameter can contain one of the following constants as listed in the :ref:`DateTime Formats<DateTime Formats>` page and as defined in the ``DateTime.inc`` include file.


**Returns**

On return ``EAX`` contains the unix time as a ``UNIXTIMESTAMP`` value.

**Notes**

Some information may be unavailable to convert if the passed DateTime string does not contain enough information. For example if only year information is in the DateTime string, then the UnixTime will be based only on that.

To prevent this, always pass a full date time string of ``CCYYMMDDHHMMSSMS`` format or similar (``DDMMCCYYHHMMSSMS`` or ``MMDDCCYYHHMMSSMS``)

Unix time is defined as the number of seconds elapsed since 00:00 Universal time on January 1, 1970 in the Gregorian calendar (Julian day 2440587.5)


**Example**

::

   .data
   DateTimeStringValue db "2008/03/21 16:21:01:00",0
   
   .data?
   UnixTime dd ?
   
   .code
   Invoke DTDateTimeStringToUnixTime, Addr DateTimeStringValue, CCYYMMDDHHMMSSMS
   mov UnixTime, eax ; save unix time value to data variable which should contain 1206116461


**See Also**

:ref:`DTUnixTimeToDateTimeString<DTUnixTimeToDateTimeString>`, :ref:`DTUnixTimeToDwordDateTime<DTUnixTimeToDwordDateTime>`, :ref:`DateTime Formats<DateTime Formats>`

