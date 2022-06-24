.. _DTDateTimeStringsDifference:

===================================
DTDateTimeStringsDifference 
===================================

Returns the difference in days or milliseconds of the first date & time string to the second date & time string. 

    
::

   DTDateTimeStringsDifference PROTO lpszDateTimeString1:DWORD, lpszDateTimeString2:DWORD, DateFormat:DWORD


**Parameters**

* ``lpszDateTimeString1`` - Pointer to a buffer containing the first date & time string. The format of the date & time string is determined by the ``DateFormat`` parameter.
* ``lpszDateTimeString2`` - Pointer to a buffer containing the second date & time string. The format of the date & time string is determined by the ``DateFormat`` parameter.
* ``DateFormat`` - Value indicating the date & time format used in the buffer pointed to by both the ``lpszDateTimeString1`` parameter and the ``lpszDateTimeString2`` parameter. The parameter can contain one of the following constants as listed in the :ref:`DateTime Formats<DateTime Formats>` page and as defined in the ``DateTime.inc`` include file.


**Returns**

On return ``EAX`` contains the difference between the two dates in days as an integer, either positive or negative.

On return ``EDX`` contains the difference in time or ``0``, see notes below for details.


**Notes**

If both dates are the same date, then ``EAX`` will be ``0``. If both date & time strings contain time values and the ``DateFormat`` parameter specified also provides a time format, then ``EDX`` will contain the difference in time in milliseconds.

**Example**

::

   .data
   CurrentDateTime db DATETIME_STRING dup (0)
   SomeOtherDateTime db "2008/03/21",0
   
   .data?
   DayDifference dd ?
   MillisecDifference dd ?
   
   .code
   Invoke DTGetDateTime, Addr CurrentDateTime, CCYYMMDDHHMMSSMS
   Invoke DTDateTimeStringsDifference, Addr CurrentDateTime, Addr SomeOtherDateTime, CCYYMMDDHHMMSSMS
   mov DayDifference, eax ; save day difference to data variable
   mov MillisecDifference, edx ; save millisec diff if days the same
   
   .IF eax == 0 
        ; No difference in dates
        ; So MillisecDifference can be used
   .ELSE
        ; Day difference is - or +, do something else...
        ; MillisecDifference is 0 value
   .ENDIF



**See Also**

:ref:`DTDateStringsCompare<DTDateStringsCompare>`, :ref:`DTDateStringsDifference<DTDateStringsDifference>`, :ref:`DateTime Formats<DateTime Formats>` 

