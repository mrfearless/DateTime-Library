.. _DTMillisecToQwordTime_x64:

===================================
DTMillisecToQwordTime 
===================================

Converts total milliseconds to a ``QWORD`` value containing time information in hours, minutes, seconds and milliseconds.


    
::

   DTMillisecToQwordTime PROTO Milliseconds:QWORD


**Parameters**

* ``Milliseconds`` - A ``QWORD`` value containting the total milliseconds to convert to hours, minutes, seconds and milliseconds in ``QWORD`` time in ``RAX``.


**Returns**

On return ``RAX`` will contain the **time** information in the following format:

``RAX`` Register Bits:

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



**Example**

::

   Invoke DTMillisecToQwordTime, qwMilliseconds


**See Also**

:ref:`DTQwordTimeToMillisec<DTQwordTimeToMillisec_x64>`, :ref:`DTQwordDateToJulianDate<DTQwordDateToJulianDate_x64>`, :ref:`DTQwordDateTimeToJulianMillisec<DTQwordDateTimeToJulianMillisec_x64>`, :ref:`DTJulianMillisecToQwordDateTime<DTJulianMillisecToQwordDateTime_x64>`

