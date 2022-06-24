.. _DTDateStringsCompare:

===================================
DTDateStringsCompare 
===================================

Compare two date & time strings to determine if they are: equal in value, one is less than another, or one is greater than another.
    
::

   DTDateStringsCompare PROTO lpszDateTimeString1:DWORD, lpszDateTimeString2:DWORD, DateFormat:DWORD


**Parameters**

* ``lpszDateTimeString1`` - Pointer to a buffer containing the first date & time string to compare. The format of the date & time string is determined by the ``DateFormat`` parameter.
* ``lpszDateTimeString2`` - Pointer to a buffer containing the second date & time string to compare. The format of the date & time string is determined by the ``DateFormat`` parameter.
* ``DateFormat`` - Value indicating the date & time format used in the buffer pointed to by both the ``lpszDateTimeString1`` parameter and the ``lpszDateTimeString2`` parameter. The parameter can contain one of the following constants as listed in the :ref:`DateTime Formats<DateTime Formats>` page and as defined in the ``DateTime.inc`` include file.


**Returns**

Return values in ``EAX`` indicate the following:

* ``-1`` First date is less than second date.
* ``0`` First date is equal to second date.
* ``+1`` First date is greater than second date.


**Notes**

The date & time string pointed to by the ``lpszDateTimeString1`` parameter is compared against the date & time string pointed to by the ``lpszDateTimeString2`` parameter.

Both dates are converted to ``DWORD`` values internally before the comparison to see which is greater or less than or equal.

If a date & time string contains time information this will be ignored.



**Example**

::

   Invoke DTDateStringsCompare, Addr szDateTime1, Addr szDateTime2, CCYYMMDD
   

**See Also**

:ref:`DTDateStringsDifference<DTDateStringsDifference>`, :ref:`DTDateTimeStringsDifference<DTDateTimeStringsDifference>`, :ref:`DateTime Formats<DateTime Formats>`

