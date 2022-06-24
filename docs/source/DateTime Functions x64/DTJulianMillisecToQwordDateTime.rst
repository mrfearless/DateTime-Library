.. _DTJulianMillisecToQwordDateTime_x64:

===================================
DTJulianMillisecToQwordDateTime 
===================================

Converts Julian date integer value and total milliseconds to ``QWORD`` values containing date and time information.  On return ``RAX`` contains the **date** information and ``RDX`` the **time** information.


    
::

   DTJulianMillisecToQwordDateTime PROTO JulianDate:QWORD, Milliseconds:QWORD


**Parameters**

* ``JulianDate`` - A ``QWORD`` value containing the Julian date integer to convert to a ``QWORD`` date in ``RAX``.
* ``Milliseconds`` - A ``QWORD`` value containting the total milliseconds to convert to hours, minutes, seconds and milliseconds in ``QWORD`` time in ``RDX``.


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

The registers always return the information in the format shown in the tables above.

**Example**

::

   .data?
   qwDate dq ?
   qwTime dq ?
   Year dw ?
   Month db ?
   Day db ?
   Hours db ?
   Minutes db ?
   Seconds db ?
   Millisec db ?
   
   .code
   Invoke DTJulianMillisecToDwordDateTime, 2299161, 0
   mov qwDate, rax ; rax contains the date information
   mov qwTime, rdx ; rdx contains the time information
    
   mov rax, qwDate
   shr rax, 16 ; move year into upper word of eax 
   mov Year,  ax ; year
   mov rax, qwDate
   mov Month, ah ; month
   mov Day, al ; day
    
   mov rax, qwTime
   shr rax, 16 ; move hour and minute into upper word of eax 
   mov Hours, ah ; hours
   mov Minutes, al ; minutes
   mov rax, qwTime
   mov Seconds, ah ; seconds
   mov Millisec, al ; millseconds


**See Also**

:ref:`DTQwordDateTimeToJulianMillisec<DTQwordDateTimeToJulianMillisec_x64>`, :ref:`DTQwordDateToJulianDate<DTQwordDateToJulianDate_x64>`, :ref:`DTQwordTimeToMillisec<DTQwordTimeToMillisec_x64>`

