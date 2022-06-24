.. _DTDateTimeStringsDifference_x64:

===================================
DTDateTimeStringsDifference 
===================================

Returns the difference in days or milliseconds of the first date & time string to the second date & time string. 

    
::

   DTDateTimeStringsDifference PROTO lpszDateTimeString1:QWORD, lpszDateTimeString2:QWORD, DateFormat:QWORD


**Parameters**

* ``lpszDateTimeString1`` - Pointer to a buffer containing the first date & time string. The format of the date & time string is determined by the ``DateFormat`` parameter.
* ``lpszDateTimeString2`` - Pointer to a buffer containing the second date & time string. The format of the date & time string is determined by the ``DateFormat`` parameter.
* ``DateFormat`` - Value indicating the date & time format used in the buffer pointed to by both the ``lpszDateTimeString1`` parameter and the ``lpszDateTimeString2`` parameter.  The parameter can contain one of the following constants as listed in the :ref:`DateTime Formats<DateTime Formats>` page and as defined in the ``DateTime.inc`` include file.


**Returns**

On return ``RAX`` contains the difference between the two dates in days as an integer, either positive or negative.

On return ``RDX`` contains the difference in time or ``0``, see notes below for details.


**Notes**

If both dates are the same date, then ``RAX`` will be ``0``. If both date & time strings contain time values and the ``DateFormat`` parameter specified also provides a time format, then ``RDX`` will contain the difference in time in milliseconds.

**Example**

::

   .data
   CurrentDateTime db DATETIME_STRING dup (0)
   SomeOtherDateTime db "2008/03/21",0
   
   .data?
   DayDifference dq ?
   MillisecDifference dq ?
   
   .code
   Invoke DTGetDateTime, Addr CurrentDateTime, CCYYMMDDHHMMSSMS
   Invoke DTDateTimeStringsDifference, Addr CurrentDateTime, Addr SomeOtherDateTime, CCYYMMDDHHMMSSMS
   mov DayDifference, rax ; save day difference to data variable
   mov MillisecDifference, rdx ; save millisec diff if days the same
   
   .IF rax == 0 
        ; No difference in dates
        ; So MillisecDifference can be used
   .ELSE
        ; Day difference is - or +, do something else...
        ; MillisecDifference is 0 value
   .ENDIF



**See Also**

:ref:`DTDateStringsCompare<DTDateStringsCompare_x64>`, :ref:`DTDateStringsDifference<DTDateStringsDifference_x64>`, :ref:`DateTime Formats<DateTime Formats>` 

