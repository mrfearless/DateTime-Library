.. _DTJulianMillisecToDwordDateTime:

===================================
DTJulianMillisecToDwordDateTime 
===================================

Converts Julian date integer value and total milliseconds to ``DWORD`` values containing date and time information.  On return ``EAX`` contains the **date** information and ``EDX`` the **time** information.


    
::

   DTJulianMillisecToDwordDateTime PROTO JulianDate:DWORD, Milliseconds:DWORD


**Parameters**

* ``JulianDate`` - A ``DWORD`` value containing the Julian date integer to convert to a ``DWORD`` date in ``EAX``.
* ``Milliseconds`` - A ``DWORD`` value containting the total milliseconds to convert to hours, minutes, seconds and milliseconds in ``DWORD`` time in ``EDX``.


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

The registers always return the information in the format shown in the tables above.

**Example**

::

   .data?
   dwDate dd ?
   dwTime dd ?
   Year dw ?
   Month db ?
   Day db ?
   Hours db ?
   Minutes db ?
   Seconds db ?
   Millisec db ?
   
   .code
   Invoke DTJulianMillisecToDwordDateTime, 2299161, 0
   mov dwDate, eax ; eax contains the date information
   mov dwTime, edx ; edx contains the time information
    
   mov eax, dwDate
   shr eax, 16 ; move year into upper word of eax 
   mov Year,  ax ; year
   mov eax, dwDate
   mov Month, ah ; month
   mov Day, al ; day
    
   mov eax, dwTime
   shr eax, 16 ; move hour and minute into upper word of eax 
   mov Hours, ah ; hours
   mov Minutes, al ; minutes
   mov eax, dwTime
   mov Seconds, ah ; seconds
   mov Millisec, al ; millseconds


**See Also**

:ref:`DTDwordDateTimeToJulianMillisec<DTDwordDateTimeToJulianMillisec>`, :ref:`DTDwordDateToJulianDate<DTDwordDateToJulianDate>`, :ref:`DTDwordTimeToMillisec<DTDwordTimeToMillisec>`

