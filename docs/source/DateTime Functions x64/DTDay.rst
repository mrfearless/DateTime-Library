.. _DTDay_x64:

===================================
DTDay 
===================================

Get the day part of a date & time string.
    
::

   DTDay PROTO lpszDateTimeString:QWORD, DateFormat:QWORD


**Parameters**

* ``lpszDateTimeString`` - Pointer to a buffer containing the date & time string to retrieve the **day** portion from. The format of the date & time string is determined by the ``DateFormat`` parameter.
* ``DateFormat`` - Value indicating the date & time format used in the buffer pointed to by ``lpszDateTimeString`` parameter.  The parameter can contain one of the following constants as listed in the :ref:`DateTime Formats<DateTime Formats>` page and as defined in the ``DateTime.inc`` include file.


**Returns**

Returns the day value in ``RAX``


**Example**

::

   .data
   DateTimeStringValue db "2008/03/21 16:21:01:00",0
   
   .data?
   DayValue dq ?
   
   .code
   Invoke DTDay, Addr DateTimeStringValue, CCYYMMDDHHMMSSMS
   mov DayValue, rax ; save day part of date value to data variable
   ; rax should contain 21


**See Also**

:ref:`DTMonth<DTMonth_x64>`, :ref:`DTYear<DTYear_x64>`, :ref:`DTIsLeapYear<DTIsLeapYear_x64>`, :ref:`DTDayOfWeek<DTDayOfWeek_x64>`, :ref:`DateTime Formats<DateTime Formats>`

