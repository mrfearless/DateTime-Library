.. _DTDwordDateTimeToDateTimeString:

===================================
DTDwordDateTimeToDateTimeString 
===================================

Converts ``DWORD`` values containing date & time information to a formatted date & time string as specified by the ``DateFormat`` parameter.


    
::

   DTDwordDateTimeToDateTimeString PROTO dwDate:DWORD, dwTime:DWORD, lpszDateTimeString:DWORD, DateFormat:DWORD


**Parameters**

* ``dwDate`` - ``DWORD`` value containing **Date** information to convert to the date & time string

 The format for the value containing the **date** information is as follows:
 
 **date** ``DWORD`` Register Bits:
 
 ::
 
    +------------------------+------------+-----------+
    | WORD                   | BYTE       | BYTE      |
    +------------------------+------------+-----------+
    | Bits 31-16             | Bits 15-8  | Bits 7-0  |
    +------------------------+------------+-----------+
    | Century Year           | Month      | Day       |
    +------------------------+------------+-----------+
    | CCCCYY                 | MM         | DD        |
    +------------------------+------------+-----------+
 
   
* ``dwTime`` - ``DWORD`` value containing **Time** information to convert to the date & time string

 The format for the value containing the **time** information is as follows:
 
 **time** ``DWORD`` Register Bits:
 
 ::
 
    +------------+------------+-----------+-----------+
    | BYTE       | BYTE       | BYTE      | BYTE      |
    +------------+------------+-----------+-----------+
    | Bits 31-23 | Bits 23-16 | Bits 15-8 | Bits 7-0  |
    +------------+------------+-----------+-----------+
    | Hour       | Minute     | Second    | Millisec  |
    +------------+------------+-----------+-----------+
    | HH         | MM         | SS        | MS        |
    +------------+------------+-----------+-----------+


* ``lpszDateTimeString`` - Pointer to a buffer to store the date & time string. The format of the date & time string is determined by the ``DateFormat`` parameter.
* ``DateFormat`` - Value indicating the date & time format to return in the buffer pointed to by ``lpszDateTimeString`` parameter. The parameter can contain one of the following constants as listed in the :ref:`DateTime Formats<DateTime Formats>` page and as defined in the ``DateTime.inc`` include file.
   
   

**Returns**

No return value

**Notes**



**Example**

::

   .data
   DateTimeStringValue db DATETIME_STRING dup (0) ; buffer to store date and time as string
   DateValue dd 0
   TimeValue dd 0
   
   .code
   xor eax, eax
   mov eax, 1974 ; save year
   shl eax, 16 ; move it into upper word of eax
   mov ah, 03 ; save month
   mov al, 15 ; save day
   mov DateValue, eax
   xor eax, eax
   mov ah, 12 ; save hours
   mov al, 34 ; save minutes
   shl eax, 16 ; move it into upper word of eax
   mov ah, 01 ; save seconds
   mov al, 0 ; save milliseconds
   mov TimeValue, eax
   
   Invoke DTDwordDateTimeToDateTimeString, DateValue, TimeValue, Addr DateTimeStringValue, CCYYMMDDHHMMSS
   ; DateTimeStringValue will now contain "1974/03/15 12:36:01"

**See Also**

:ref:`DTDateTimeStringToDwordDateTime<DTDateTimeStringToDwordDateTime>`, :ref:`DateTime Formats<DateTime Formats>`, :ref:`DTGetDateTime<DTGetDateTime>` 

