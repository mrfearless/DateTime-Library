.. _DTDayOfWeek:

===================================
DTDayOfWeek 
===================================

Returns an integer indicating the day of the week from a date & time string.

    
::

   DTDayOfWeek PROTO lpszDateTimeString:DWORD, DateFormat:DWORD


**Parameters**

* ``lpszDateTimeString`` - Pointer to a buffer containing the date & time string to check the day of the week for. The format of the date & time string is determined by the ``DateFormat`` parameter.
* ``DateFormat`` - Value indicating the date & time format used in the buffer pointed to by ``lpszDateTimeString`` parameter. The parameter can contain one of the following constants as listed in the :ref:`DateTime Formats<DateTime Formats>` page and as defined in the ``DateTime.inc`` include file.


**Returns**

On return ``EAX`` will contain a value to indicate the following day:

* ``0`` = Monday
* ``1`` = Tuesday
* ``2`` = Wednesday
* ``3`` = Thursday
* ``4`` = Friday
* ``5`` = Saturday
* ``6`` = Sunday


**Example**

::

   ; The following example calculates the first day of the week from a date using the DTDayOfWeek function
   .data
   szDateTime db DATETIME_STRING dup (0)
   .data?
   dwDate1 dd ?
   dwDayWeek dd ?
   dwStartWeek dd ?
    
   .code
   Invoke DTDateTimeStringToJulianMillisec, CTEXT("04/06/2009"), DDMMCCYY ; Convert date to julian date
   mov dwDate1, eax ; only save date info returned in eax, ignore time info returned in edx
    
   Invoke DTDayOfWeek, CTEXT("04/06/2009"), DDMMCCYY ; Get day of week for date
   mov dwDayWeek, eax ; Save the returned integer representing day 0-6
    
   mov ebx, eax 
   mov eax, dwDate1
   sub eax, ebx ; subtract julian date value from day of week integer
   mov dwStartWeek, eax ; we have new julian date which is start of the week
    
   Invoke DTJulianToDwordDate, dwStartWeek ; convert new julian date start of week number to a date in dword format
   Invoke DTDwordDateTimeToDate, eax, NULL, Addr szDateTime, DDMMCCYY ; convert dword date format to a string value
   ; szDateTime now contains '01/06/2009'


**See Also**

:ref:`DTDay<DTDay>`, :ref:`DTMonth<DTMonth>`, :ref:`DTYear<DTYear>`, :ref:`DTIsLeapYear<DTIsLeapYear>`, :ref:`DateTime Formats<DateTime Formats>`

