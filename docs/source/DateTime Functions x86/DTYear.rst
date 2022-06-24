.. _DTYear:

===================================
DTYear 
===================================

Get the year part of a date & time string.
    
::

   DTYear PROTO lpszDateTimeString:DWORD, DateFormat:DWORD


**Parameters**

* ``lpszDateTimeString`` - Pointer to a buffer containing the date & time string to retrieve the **year** portion from. The format of the date & time string is determined by the ``DateFormat`` parameter.
* ``DateFormat`` - Value indicating the date & time format used in the buffer pointed to by ``lpszDateTimeString`` parameter. The parameter can contain one of the following constants as listed in the :ref:`DateTime Formats<DateTime Formats>` page and as defined in the ``DateTime.inc`` include file.


**Returns**

Returns the year value in ``EAX``



**Example**

::

   .data
   DateTimeStringValue db "2008/03/21 16:21:01:00",0
   
   .data?
   YearValue dd ?
   
   .code
   Invoke DTYear, Addr DateTimeStringValue
   mov YearValue Value, eax ; save year part of date value to data variable
   ; eax should contain 2008


**See Also**

:ref:`DTDay<DTDay>`, :ref:`DTMonth<DTMonth>`, :ref:`DTIsLeapYear<DTIsLeapYear>`, :ref:`DTDayOfWeek<DTDayOfWeek>`, :ref:`DateTime Formats<DateTime Formats>`

