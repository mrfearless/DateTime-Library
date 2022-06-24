.. _DTIsLeapYear_x64:

===================================
DTIsLeapYear 
===================================

Calculate if a specified year is a leap year.

    
::

   DTIsLeapYear PROTO qwYear:QWORD


**Parameters**

* ``qwYear`` - a ``QWORD`` value that has the year value to check for leap year.


**Returns**

Returns ``TRUE`` if year is a leap year, otherwise ``FALSE``.

**Notes**

``qwYear`` must include the century. For example ``2008`` which in a ``QWORD`` value is stored as ``0x7D8``

A year will be a leap year if it is divisible by ``4`` but not by ``100``. If a year is divisible by ``4`` and by ``100``, it is not a leap year unless it is also divisible by ``400``.



**Example**

::

   .data
   CurrentDateTimeValue db 32 dup (0) ; buffer to store date & time as string
   Year dq 0
   
   .code
   Invoke DTGetDateTime, Addr CurrentDateTimeValue, CCYYMMDDHHMMSS
   Invoke DTYear, Addr CurrentDateTimeValue, CCYYMMDDHHMMSS
   mov Year, rax ; save year
   
   Invoke DTIsLeapYear, rax ; check leap year
   .IF rax == TRUE
        ; Leap year, do something...
   .ELSE
        ; No leap year, do something other...
   .ENDIF


**See Also**

:ref:`DTDay<DTDay_x64>`, :ref:`DTMonth<DTMonth_x64>`, :ref:`DTYear<DTYear_x64>`, :ref:`DTDayOfWeek<DTDayOfWeek_x64>`

