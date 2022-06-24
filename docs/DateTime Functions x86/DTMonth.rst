.. _DTMonth:

===================================
DTMonth 
===================================

Get the month part of a date & time string.
    
::

   DTMonth PROTO lpszDateTimeString:DWORD, DateFormat:DWORD


**Parameters**

* ``lpszDateTimeString`` - Pointer to a buffer containing the date & time string to retrieve the **month** portion from. The format of the date & time string is determined by the ``DateFormat`` parameter.
* ``DateFormat`` - Value indicating the date & time format used in the buffer pointed to by ``lpszDateTimeString`` parameter. The parameter can contain one of the following constants as listed in the :ref:`DateTime Formats<DateTime Formats>` page and as defined in the ``DateTime.inc`` include file.


**Returns**

Returns the month value in ``EAX``


**Example**

::

   .data
   DateTimeStringValue db "2008/03/21 16:21:01:00",0
   
   .data?
   MonthValue dd ?
   
   .code
   Invoke DTMonth, Addr DateTimeStringValue, CCYYMMDDHHMMSSMS
   mov MonthValue, eax ; save month part of date value to data variable
   ; eax should contain 3


**Example**

::

   .data?
   dwMonth1 dd ?
   dwMonth2 dd ?
   
   .code
   Invoke DTMonth, CTEXT("27/02/2009"), DDMMCCYY
   mov dwMonth1, eax ; save month to variable
    
   Invoke DTMonth, CTEXT("03/03/2009"), DDMMCCYY
   mov dwMonth2, eax ; save month to variable
   
   mov ebx, dwMonth1 ; place month1 variable in ebx
   sub eax, ebx ; subtract month2 from month1, eax = 1 in this example


**See Also**

:ref:`DTDay<DTDay>`, :ref:`DTYear<DTYear>`, :ref:`DTIsLeapYear<DTIsLeapYear>`, :ref:`DTDayOfWeek<DTDayOfWeek>`, :ref:`DateTime Formats<DateTime Formats>`

