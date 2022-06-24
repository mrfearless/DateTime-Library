.. _DTIsLeapYear:

===================================
DTIsLeapYear 
===================================

Calculate if a specified year is a leap year.

    
::

   DTIsLeapYear PROTO dwYear:DWORD


**Parameters**

* ``dwYear`` - a ``DWORD`` value that has the year value to check for leap year.


**Returns**

Returns ``TRUE`` if year is a leap year, otherwise ``FALSE``.

**Notes**

``dwYear`` must include the century. For example ``2008`` which in a ``DWORD`` value is stored as ``0x7D8``

A year will be a leap year if it is divisible by ``4`` but not by ``100``. If a year is divisible by ``4`` and by ``100``, it is not a leap year unless it is also divisible by ``400``.



**Example**

::

   .data
   CurrentDateTimeValue db 32 dup (0) ; buffer to store date & time as string
   Year dd 0
   
   .code
   Invoke DTGetDateTime, Addr CurrentDateTimeValue, CCYYMMDDHHMMSS
   Invoke DTYear, Addr CurrentDateTimeValue, CCYYMMDDHHMMSS
   mov Year, eax ; save year
   
   Invoke DTIsLeapYear, eax ; check leap year
   .IF eax == TRUE
        ; Leap year, do something...
   .ELSE
        ; No leap year, do something other...
   .ENDIF


**See Also**

:ref:`DTDay<DTDay>`, :ref:`DTMonth<DTMonth>`, :ref:`DTYear<DTYear>`, :ref:`DTDayOfWeek<DTDayOfWeek>`

