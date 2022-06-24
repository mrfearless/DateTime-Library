.. _DTMillisecToDwordTime:

===================================
DTMillisecToDwordTime 
===================================

Converts total milliseconds to a ``DWORD`` value containing time information in hours, minutes, seconds and milliseconds.


    
::

   DTMillisecToDwordTime PROTO Milliseconds:DWORD


**Parameters**

* ``Milliseconds`` - A ``DWORD`` value containting the total milliseconds to convert to hours, minutes, seconds and milliseconds in ``DWORD`` time in ``EAX``.


**Returns**

On return ``EAX`` will contain the **time** information in the following format:

``EAX`` Register Bits:

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



**Example**

::

   Invoke DTMillisecToDwordTime, dwMilliseconds


**See Also**

:ref:`DTDwordTimeToMillisec<DTDwordTimeToMillisec>`, :ref:`DTDwordDateToJulianDate<DTDwordDateToJulianDate>`, :ref:`DTDwordDateTimeToJulianMillisec<DTDwordDateTimeToJulianMillisec>`, :ref:`DTJulianMillisecToDwordDateTime<DTJulianMillisecToDwordDateTime>`

