.. _DTDwordTimeToMillisec:

===================================
DTDwordTimeToMillisec 
===================================

Converts a ``DWORD`` value containing time information to total amount of milliseconds.
    
::

   DTDwordTimeToMillisec PROTO dwTime:DWORD


**Parameters**

* ``dwTime`` - ``DWORD`` value containing **time** information to convert to total amount of milliseconds.

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

On return ``EAX`` will contain the total milliseconds.


**Example**

::

   Invoke DTDwordTimeToMillisec, dwTime
   

**See Also**

:ref:`DTMillisecToDwordTime<DTMillisecToDwordTime>`, :ref:`DTJulianDateToDwordDate<DTJulianDateToDwordDate>`, :ref:`DTDwordDateTimeToJulianMillisec<DTDwordDateTimeToJulianMillisec>`, :ref:`DTJulianMillisecToDwordDateTime<DTJulianMillisecToDwordDateTime>`

