.. _DTMonth_x64:

===================================
DTMonth 
===================================

Get the month part of a date & time string.
    
::

   DTMonth PROTO lpszDateTimeString:QWORD, DateFormat:QWORD


**Parameters**

* ``lpszDateTimeString`` - Pointer to a buffer containing the date & time string to retrieve the **month** portion from. The format of the date & time string is determined by the ``DateFormat`` parameter.
* ``DateFormat`` - Value indicating the date & time format used in the buffer pointed to by ``lpszDateTimeString`` parameter.  The parameter can contain one of the following constants as listed in the :ref:`DateTime Formats<DateTime Formats>` page and as defined in the ``DateTime.inc`` include file.


**Returns**

Returns the month value in ``RAX``


**Example**

::

   .data
   DateTimeStringValue db "2008/03/21 16:21:01:00",0
   
   .data?
   MonthValue dq ?
   
   .code
   Invoke DTMonth, Addr DateTimeStringValue, CCYYMMDDHHMMSSMS
   mov MonthValue, rax ; save month part of date value to data variable
   ; rax should contain 3


**Example**

::

   .data?
   qwMonth1 dq ?
   qwMonth2 dq ?
   
   .code
   Invoke DTMonth, CTEXT("27/02/2009"), DDMMCCYY
   mov qwMonth1, rax ; save month to variable
    
   Invoke DTMonth, CTEXT("03/03/2009"), DDMMCCYY
   mov qwMonth2, rax ; save month to variable
   
   mov rbx, qwMonth1 ; place month1 variable in rbx
   sub rax, rbx ; subtract month2 from month1, rax = 1 in this example


**See Also**

:ref:`DTDay<DTDay_x64>`, :ref:`DTYear<DTYear_x64>`, :ref:`DTIsLeapYear<DTIsLeapYear_x64>`, :ref:`DTDayOfWeek<DTDayOfWeek_x64>`, :ref:`DateTime Formats<DateTime Formats>`

