.. _DTDay:

===================================
DTDay 
===================================

Get the day part of a date & time string.
    
::

   DTDay PROTO lpszDateTimeString:DWORD, DateFormat:DWORD


**Parameters**

* ``lpszDateTimeString`` - Pointer to a buffer containing the date & time string to retrieve the **day** portion from. The format of the date & time string is determined by the ``DateFormat`` parameter.
* ``DateFormat`` - Value indicating the date & time format used in the buffer pointed to by ``lpszDateTimeString`` parameter. The parameter can contain one of the following constants as listed in the :ref:`DateTime Formats<DateTime Formats>` page and as defined in the ``DateTime.inc`` include file.


**Returns**

Returns the day value in ``EAX``


**Example**

::

   .data
   DateTimeStringValue db "2008/03/21 16:21:01:00",0
   
   .data?
   DayValue dd ?
   
   .code
   Invoke DTDay, Addr DateTimeStringValue, CCYYMMDDHHMMSSMS
   mov DayValue, eax ; save day part of date value to data variable
   ; eax should contain 21


**See Also**

:ref:`DTMonth<DTMonth>`, :ref:`DTYear<DTYear>`, :ref:`DTIsLeapYear<DTIsLeapYear>`, :ref:`DTDayOfWeek<DTDayOfWeek>`, :ref:`DateTime Formats<DateTime Formats>`

