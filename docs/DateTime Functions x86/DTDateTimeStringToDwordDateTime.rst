.. _DTDateTimeStringToDwordDateTime:

===================================
DTDateTimeStringToDwordDateTime 
===================================

Converts a formatted date & time string to ``DWORD`` values. On return ``EAX`` contains the **date** information and ``EDX`` the **time** information.
    
::

   DTDateTimeStringToDwordDateTime PROTO lpszDateTimeString:DWORD, DateFormat:DWORD


**Parameters**

* ``lpszDateTimeString`` - Pointer to a buffer containing the date & time string to convert to ``DWORD`` values. The format of the date & time string is determined by the ``DateFormat`` parameter.
* ``DateFormat`` - Value indicating the date & time format used in the buffer pointed to by ``lpszDateTimeString`` parameter. The parameter can contain one of the following constants as listed in the :ref:`DateTime Formats<DateTime Formats>` page and as defined in the ``DateTime.inc`` include file.
   

**Returns**

On return ``EAX`` will contain the **date** information in the following format:

``EAX`` Register Bits:

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
 

On return ``EDX`` will contain the **time** information in the following format:

``EDX`` Register Bits:

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
 

**Notes**

The registers always return the information in the format shown in the tables above, and do not change regardless of the ``DateFormat`` parameter.

The ``DateFormat`` parameter is used to indicate the format of the date & time string being passed to ``DTDateTimeStringToDwordDateTime``.

Some information may be unavailable to convert if the passed DateTime string does not contain enough information. For example if only year information is in the DateTime string, then the ``DWORD`` **date** and ``DWORD`` **time** will be based only on that.

To prevent this, always pass a full date time string of ``CCYYMMDDHHMMSSMS`` format or similar (``DDMMCCYYHHMMSSMS`` or ``MMDDCCYYHHMMSSMS``)


To retrieve the various values of the date & time ``DWORD`` values you can use the following as an example:


**Example**

::

   .data
   DateTimeStringValue db "2008/03/21 16:21:01:00",0
   
   .data?
   DateValue dd ?
   TimeValue dd ?
   CentYear dd ?
   Year dd ?
   Month dd ?
   Day dd ?
   
   .code
   Invoke DTDateTimeStringToDwordDateTime, Addr DateTimeStringValue, CCYYMMDDHHMMSSMS
   mov DateValue, eax ; Save date info in eax to a data variable
   mov TimeValue, edx ; Save time info in edx to a data variable
   
   ; save day, month, year and century info to data variables
   mov edx, DateValue ; use edx as our work place
   
   xor eax, eax ; clear register
   mov al, dl ; dl contains day info
   mov Day, eax ; save day info DD in dl to a data variable
   
   xor eax, eax ; clear register
   mov al, dh ; dh contains month info
   mov Month, eax ; save month info MM in dh to a data variable
   
   shr edx, 16 ; century and year are now in dx part of the register
   mov CentYear, edx ; save century and year info CCYY to a data variable
   
   xor eax, eax ; clear register
   mov al, dl ; dl contains YY part of year
   mov Year, eax ; save year info in dl to a data variable

**See Also**

:ref:`DTDwordDateTimeToDateTimeString<DTDwordDateTimeToDateTimeString>`, :ref:`DateTime Formats<DateTime Formats>`, :ref:`DTGetDateTime<DTGetDateTime>` 

