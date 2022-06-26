.. _DTDwordDateTimeToUnixTime:

===================================
DTDwordDateTimeToUnixTime 
===================================

Converts ``DWORD`` values containing date & time information to a ``DWORD`` value containing a unix time integer value. On return ``EAX`` contains the unix time integer value.
    
::

   DTDwordDateTimeToUnixTime PROTO dwDate:DWORD, dwTime:DWORD


**Parameters**

* ``dwDate`` - ``DWORD`` value containing **date** information to convert to a unix time integer value.

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
   
   
* ``dwTime`` - ``DWORD`` value containing **time** information to convert to a unix time integer value.

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

On return ``EAX`` will contain the unix time integer value.

**Notes**

Unix time is defined as the number of seconds elapsed since 00:00 Universal time on January 1, 1970 in the Gregorian calendar (Julian day 2440587.5)


**Example**

::

   Invoke DTDwordDateTimeToUnixTime, dwDate, dwTime
   

**See Also**

:ref:`DTUnixTimeToDwordDateTime<DTUnixTimeToDwordDateTime>`, :ref:`DTDateTimeStringToUnixTime<DTDateTimeStringToUnixTime>`, :ref:`DTUnixTimeToDateTimeString<DTUnixTimeToDateTimeString>`

