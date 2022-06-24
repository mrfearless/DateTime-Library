.. _DTDwordDateTimeToJulianMillisec:

===================================
DTDwordDateTimeToJulianMillisec 
===================================

Converts ``DWORD`` values containing date & time information to Julian date and total milliseconds.


    
::

   DTDwordDateTimeToJulianMillisec PROTO dwDate:DWORD, dwTime:DWORD


**Parameters**

* ``dwDate`` - ``DWORD`` value containing **date** information to convert to Julian date.

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
 
   
* ``dwTime`` - ``DWORD`` value containing **time** information to convert to the total milliseconds.

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


**Returns**

On return ``EAX`` will contain the Julian date integer, and ``EDX`` the total millliseconds.

**Notes**



**Example**

::

   Invoke DTDwordDateTimeToJulianMillisec, dwDate, dwTime

**See Also**

:ref:`DTJulianMillisecToDwordDateTime<DTJulianMillisecToDwordDateTime>`, :ref:`DTJulianDateToDwordDate<DTJulianDateToDwordDate>`, :ref:`DTMillisecToDwordTime<DTMillisecToDwordTime>`

