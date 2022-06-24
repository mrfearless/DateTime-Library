.. _DTQwordTimeToMillisec_x64:

===================================
DTQwordTimeToMillisec 
===================================

Converts a ``QWORD`` value containing time information to total amount of milliseconds.
    
::

   DTQwordTimeToMillisec PROTO dwTime:QWORD


**Parameters**

* ``qwTime`` - ``QWORD`` value containing **time** information to convert to total amount of milliseconds.

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

On return ``RAX`` will contain the total milliseconds.

**Notes**



**Example**

::

   Invoke DTQwordTimeToMillisec, qwTime
   

**See Also**

:ref:`DTMillisecToQwordTime<DTMillisecToQwordTime_x64>`, :ref:`DTJulianDateToQwordDate<DTJulianDateToQwordDate_x64>`, :ref:`DTQwordDateTimeToJulianMillisec<DTQwordDateTimeToJulianMillisec_x64>`, :ref:`DTJulianMillisecToQwordDateTime<DTJulianMillisecToQwordDateTime_x64>`

