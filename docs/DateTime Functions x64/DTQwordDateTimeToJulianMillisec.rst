.. _DTQwordDateTimeToJulianMillisec_x64:

===================================
DTQwordDateTimeToJulianMillisec 
===================================

Converts ``QWORD`` values containing date & time information to Julian date and total milliseconds.


    
::

   DTQwordDateTimeToJulianMillisec PROTO qwDate:QWORD, qwTime:QWORD


**Parameters**

* ``qwDate`` - ``QWORD`` value containing **date** information to convert to Julian date.

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
 
   
* ``qwTime`` - ``QWORD`` value containing **time** information to convert to the total milliseconds.

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


**Returns**

On return ``RAX`` will contain the Julian date integer, and ``RDX`` the total millliseconds.

**Notes**



**Example**

::

   Invoke DTQwordDateTimeToJulianMillisec, qwDate, qwTime

**See Also**

:ref:`DTJulianMillisecToQwordDateTime<DTJulianMillisecToQwordDateTime_x64>`, :ref:`DTJulianDateToQwordDate<DTJulianDateToQwordDate_x64>`, :ref:`DTMillisecToQwordTime<DTMillisecToQwordTime_x64>`

