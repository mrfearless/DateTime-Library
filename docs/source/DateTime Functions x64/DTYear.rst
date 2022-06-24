.. _DTYear_x64:

===================================
DTYear 
===================================

Get the year part of a date & time string.
    
::

   DTYear PROTO lpszDateTimeString:QWORD, DateFormat:QWORD


**Parameters**

* ``lpszDateTimeString`` - Pointer to a buffer containing the date & time string to retrieve the **year** portion from. The format of the date & time string is determined by the ``DateFormat`` parameter.
* ``DateFormat`` - Value indicating the date & time format used in the buffer pointed to by ``lpszDateTimeString`` parameter.  The paramater can contain one of the following constants as listed in the :ref:`DateTime Formats<DateTime Formats>` page and as defined in the ``DateTime.inc`` include file.


**Returns**

Returns the year value in ``RAX``



**Example**

::

   .data
   DateTimeStringValue db "2008/03/21 16:21:01:00",0
   
   .data?
   YearValue dq ?
   
   .code
   Invoke DTYear, Addr DateTimeStringValue
   mov YearValue Value, rax ; save year part of date value to data variable
   ; eax should contain 2008


**See Also**

:ref:`DTDay<DTDay_x64>`, :ref:`DTMonth<DTMonth_x64>`, :ref:`DTIsLeapYear<DTIsLeapYear_x64>`, :ref:`DTDayOfWeek<DTDayOfWeek_x64>`, :ref:`DateTime Formats<DateTime Formats>`

