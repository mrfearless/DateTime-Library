.. _DTDateStringsDifference_x64:

===================================
DTDateStringsDifference 
===================================

Returns the difference in days of the first date & time string to the second date & time string.
   
::

   DTDateStringsDifference PROTO lpszDateTimeString1:QWORD, lpszDateTimeString2:QWORD, DateFormat:QWORD


**Parameters**

* ``lpszDateTimeString1`` - Pointer to a buffer containing the first date & time string. The format of the date & time string is determined by the ``DateFormat`` parameter.
* ``lpszDateTimeString2`` - Pointer to a buffer containing the second date & time string. The format of the date & time string is determined by the ``DateFormat`` parameter.
* ``DateFormat`` - Value indicating the date & time format used in the buffer pointed to by both the ``lpszDateTimeString1`` parameter and the ``lpszDateTimeString2`` parameter.  The parameter can contain one of the following constants as listed in the :ref:`DateTime Formats<DateTime Formats>` page and as defined in the ``DateTime.inc`` include file.


**Returns**

On return ``RAX`` contains the difference between the two dates in days as an integer, either positive or negative.

**Notes**

The date & time string pointed to by the ``lpszDateTimeString1`` parameter is compared against the date & time string pointed to by the ``lpszDateTimeString2`` parameter to determine the difference of the dates.

Both dates are converted to Julian date format internally before comparing the days difference between dates.

If a date & time string contains time information this will be ignored.


**Example**

::

   .data
   CurrentDateTime db DATETIME_STRING dup (0)
   SomeOtherDateTime db "2008/03/21",0
   
   .data?
   DayDifference dq ?
   
   .code
   Invoke DTGetDateTime, Addr CurrentDateTime, CCYYMMDD
   Invoke DTDateStringsDifference, Addr CurrentDateTime, Addr SomeOtherDateTime, CCYYMMDD
   mov DayDifference, rax ; save day difference to data variable
   
   .IF rax == 0 
        ; No difference in dates, do something...
   .ELSE
        ; Day difference is - or +, do something else...
   .ENDIF


**See Also**

:ref:`DTDateStringsCompare<DTDateStringsCompare_x64>`, :ref:`DTDateTimeStringsDifference<DTDateTimeStringsDifference_x64>`, :ref:`DateTime Formats<DateTime Formats>`

