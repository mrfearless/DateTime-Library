.. _DTDateTimeStringToQwordDateTime_x64:

===================================
DTDateTimeStringToQwordDateTime 
===================================

Converts a formatted date & time string to ``QWORD`` values. On return ``RAX`` contains the **date** information and ``RDX`` the **time** information.
    
::

   DTDateTimeStringToQwordDateTime PROTO lpszDateTimeString:QWORD, DateFormat:QWORD


**Parameters**

* ``lpszDateTimeString`` - Pointer to a buffer containing the date & time string to convert to ``QWORD`` values. The format of the date & time string is determined by the ``DateFormat`` parameter.
* ``DateFormat`` - Value indicating the date & time format used in the buffer pointed to by ``lpszDateTimeString`` parameter.  The parameter can contain one of the following constants as listed in the :ref:`DateTime Formats<DateTime Formats>` page and as defined in the ``DateTime.inc`` include file.
   

**Returns**

On return ``RAX`` will contain the **date** information in the following format:

``RAX`` Register Bits:

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
 

On return ``RDX`` will contain the **time** information in the following format:

``RDX`` Register Bits:

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
   

**Notes**

The registers always return the information in the format shown in the tables above, and do not change regardless of the ``DateFormat`` parameter.

The ``DateFormat`` parameter is used to indicate the format of the date & time string being passed to ``DTDateTimeStringToQwordDateTime``.

Some information may be unavailable to convert if the passed DateTime string does not contain enough information. For example if only year information is in the DateTime string, then the ``DWORD`` **date** and ``DWORD`` **time** will be based only on that.

To prevent this, always pass a full date time string of ``CCYYMMDDHHMMSSMS`` format or similar (``DDMMCCYYHHMMSSMS`` or ``MMDDCCYYHHMMSSMS``)


To retrieve the various values of the date & time ``QWORD`` values you can use the following as an example:


**Example**

::

   .data
   DateTimeStringValue db "2008/03/21 16:21:01:00",0
   
   .data?
   DateValue dq ?
   TimeValue dq ?
   CentYear dq ?
   Year dq ?
   Month dq ?
   Day dq ?
   
   .code
   Invoke DTDateTimeStringToQwordDateTime, Addr DateTimeStringValue, CCYYMMDDHHMMSSMS
   mov DateValue, rax ; Save date info in rax to a data variable
   mov TimeValue, rdx ; Save time info in rdx to a data variable
   
   ; save day, month, year and century info to data variables
   mov rdx, DateValue ; use rdx as our work place
   
   xor rax, rax ; clear register
   mov al, dl ; dl contains day info
   mov Day, rax ; save day info DD in dl to a data variable
   
   xor rax, rax ; clear register
   mov al, dh ; dh contains month info
   mov Month, rax ; save month info MM in dh to a data variable
   
   shr edx, 16 ; century and year are now in dx part of the register
   mov CentYear, rdx ; save century and year info CCYY to a data variable
   
   xor rax, rax ; clear register
   mov al, dl ; dl contains YY part of year
   mov Year, rax ; save year info in dl to a data variable


**See Also**

:ref:`DTQwordDateTimeToDateTimeString<DTQwordDateTimeToDateTimeString_x64>`, :ref:`DateTime Formats<DateTime Formats>`, :ref:`DTGetDateTime<DTGetDateTime_x64>` 

