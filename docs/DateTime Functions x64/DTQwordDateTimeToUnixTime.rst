.. _DTQwordDateTimeToUnixTime_x64:

===================================
DTQwordDateTimeToUnixTime 
===================================

Converts ``QWORD`` values containing date & time information to a ``QWORD`` value containing a unix time integer value. On return ``RAX`` contains the unix time integer value.
    
::

   DTQwordDateTimeToUnixTime PROTO qwDate:QWORD, qwTime:QWORD


**Parameters**

* ``qwDate`` - ``QWORD`` value containing **date** information to convert to a unix time integer value.

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
 
   
* ``qwTime`` - ``QWORD`` value containing **time** information to convert to a unix time integer value.

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

On return ``RAX`` will contain the unix time integer value.

**Notes**

Unix time is defined as the number of seconds elapsed since 00:00 Universal time on January 1, 1970 in the Gregorian calendar (Julian day 2440587.5)


**Example**

::

   Invoke DTQwordDateTimeToUnixTime, qwDate, qwTime
   

**See Also**

:ref:`DTUnixTimeToQwordDateTime<DTUnixTimeToQwordDateTime_x64>`, :ref:`DTDateTimeStringToUnixTime<DTDateTimeStringToUnixTime_x64>`, :ref:`DTUnixTimeToDateTimeString<DTUnixTimeToDateTimeString_x64>`

