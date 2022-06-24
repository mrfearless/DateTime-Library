.. _DTDayOfWeek_x64:

===================================
DTDayOfWeek 
===================================

Returns an integer indicating the day of the week from a date & time string.

    
::

   DTDayOfWeek PROTO lpszDateTimeString:QWORD, DateFormat:QWORD


**Parameters**

* ``lpszDateTimeString`` - Pointer to a buffer containing the date & time string to check the day of the week for. The format of the date & time string is determined by the ``DateFormat`` parameter.
* ``DateFormat`` - Value indicating the date & time format used in the buffer pointed to by ``lpszDateTimeString`` parameter.  The parameter can contain one of the following constants as listed in the :ref:`DateTime Formats<DateTime Formats>` page and as defined in the ``DateTime.inc`` include file.


**Returns**

On return ``RAX`` will contain a value to indicate the following day:

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
   qwDate1 dq ?
   qwDayWeek dq ?
   qwStartWeek dq ?
    
   .code
   Invoke DTDateTimeStringToJulianMillisec, CTEXT("04/06/2009"), DDMMCCYY ; Convert date to julian date
   mov qwDate1, rax ; only save date info returned in eax, ignore time info returned in edx
    
   Invoke DTDayOfWeek, CTEXT("04/06/2009"), DDMMCCYY ; Get day of week for date
   mov qwDayWeek, rax ; Save the returned integer representing day 0-6
    
   mov rbx, rax 
   mov rax, qwDate1
   sub rax, rbx ; subtract julian date value from day of week integer
   mov qwStartWeek, rax ; we have new julian date which is start of the week
    
   Invoke DTJulianToDwordDate, qwStartWeek ; convert new julian date start of week number to a date in dword format
   Invoke DTDwordDateTimeToDate, rax, NULL, Addr szDateTime, DDMMCCYY ; convert dword date format to a string value
   ; szDateTime now contains '01/06/2009'


**See Also**

:ref:`DTDay<DTDay_x64>`, :ref:`DTMonth<DTMonth_x64>`, :ref:`DTYear<DTYear_x64>`, :ref:`DTIsLeapYear<DTIsLeapYear_x64>`, :ref:`DateTime Formats<DateTime Formats>`

