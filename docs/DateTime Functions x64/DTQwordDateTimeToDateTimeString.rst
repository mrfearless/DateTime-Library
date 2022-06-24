.. _DTQwordDateTimeToDateTimeString_x64:

===================================
DTQwordDateTimeToDateTimeString 
===================================

Converts ``QWORD`` values containing date & time information to a formatted date & time string as specified by the ``DateFormat`` parameter.


    
::

   DTQwordDateTimeToDateTimeString PROTO qwDate:QWORD, qwTime:QWORD, lpszDateTimeString:QWORD, DateFormat:QWORD


**Parameters**

* ``qwDate`` - ``QWORD`` value containing **Date** information to convert to the date & time string

 The format for the value containing the **date** information is as follows:
 
 **date** ``QWORD`` Register Bits:
 
 ::
 
    +--------------------------------------------------+------------------------+------------+-----------+
    | DWORD                                            | WORD                   | BYTE       | BYTE      |
    +--------------------------------------------------+------------------------+------------+-----------+
    | Bits 63-32                                       | Bits 31-16             | Bits 15-8  | Bits 7-0  |
    +--------------------------------------------------+------------------------+------------+-----------+
    | Not used - Not applicable                        | Century Year           | Month      | Day       |
    +--------------------------------------------------+------------------------+------------+-----------+
    | N/A                                              | CCCCYY                 | MM         | DD        |
    +--------------------------------------------------+------------------------+------------+-----------+
 
   
* ``qwTime`` - ``QWORD`` value containing **Time** information to convert to the date & time string

 The format for the value containing the **time** information is as follows:
 
 **time** ``QWORD`` Register Bits:
 
 ::
 
    +--------------------------------------------------+------------+------------+-----------+-----------+
    | DWORD                                            | BYTE       | BYTE       | BYTE      | BYTE      |
    +--------------------------------------------------+------------+------------+-----------+-----------+
    | Bits 63-32                                       | Bits 31-23 | Bits 23-16 | Bits 15-8 | Bits 7-0  |
    +--------------------------------------------------+------------+------------+-----------+-----------+
    | Not used - Not applicable                        | Hour       | Minute     | Second    | Millisec  |
    +--------------------------------------------------+------------+------------+-----------+-----------+
    | N/A                                              | HH         | MM         | SS        | MS        |
    +--------------------------------------------------+------------+------------+-----------+-----------+

* ``lpszDateTimeString`` - Pointer to a buffer to store the date & time string. The format of the date & time string is determined by the ``DateFormat`` parameter.
* ``DateFormat`` - Value indicating the date & time format to return in the buffer pointed to by ``lpszDateTimeString`` parameter.  The parameter can contain one of the following constants as listed in the :ref:`DateTime Formats<DateTime Formats>` page and as defined in the ``DateTime.inc`` include file.
   
   

**Returns**

No return value

**Notes**



**Example**

::

   .data
   DateTimeStringValue db DATETIME_STRING dup (0) ; buffer to store date and time as string
   DateValue dq 0
   TimeValue dq 0
   
   .code
   xor rax, rax
   mov rax, 1974 ; save year
   shl rax, 16 ; move it into upper word of rax
   mov ah, 03 ; save month
   mov al, 15 ; save day
   mov DateValue, rax
   xor rax, rax
   mov ah, 12 ; save hours
   mov al, 34 ; save minutes
   shl rax, 16 ; move it into upper word of rax
   mov ah, 01 ; save seconds
   mov al, 0 ; save milliseconds
   mov TimeValue, rax
   
   Invoke DTQwordDateTimeToDateTimeString, DateValue, TimeValue, Addr DateTimeStringValue, CCYYMMDDHHMMSS
   ; DateTimeStringValue will now contain "1974/03/15 12:36:01"

**See Also**

:ref:`DTDateTimeStringToQwordDateTime<DTDateTimeStringToQwordDateTime_x64>`, :ref:`DateTime Formats<DateTime Formats>`, :ref:`DTGetDateTime<DTGetDateTime_x64>` 

