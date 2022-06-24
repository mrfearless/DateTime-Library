.. _DTGetDateTime_x64:

===================================
DTGetDateTime 
===================================

Get the current date & time and return it as a formatted string as specified by the ``DateFormat`` parameter.
    
::

   DTGetDateTime PROTO lpszDateTimeString:QWORD, DateFormat:QWORD


**Parameters**

* ``lpszDateTimeString`` - Pointer to a buffer to store the date & time string. The format of the date & time string is determined by the ``DateFormat`` parameter.
* ``DateFormat`` - Value indicating the date & time format to return in the buffer pointed to by ``lpszDateTimeString`` parameter. The parameter can contain one of the following constants as listed in the :ref:`DateTime Formats<DateTime Formats>` page and as defined in the ``DateTime.inc`` include file.


**Returns**

Returns in ``RAX`` ``TRUE`` if succesful, or ``FALSE`` otherwise.

**Notes**

The user is responsible for ensuring the buffer pointed to by the ``lpszDateTimeString`` parameter is large enought to hold the date & time string value. Recommeneded minimum size for the buffer is ``24`` bytes long as defined by the ``DATETIME_STRING`` constant.

**Example**

::

   .data
   DateTimeStringValue db DATETIME_STRING dup (0) ; buffer to store date and time as string
   
   .code
   Invoke DTGetDateTime, Addr DateTimeStringValue, CCYYMMDDHHMMSS


**See Also**

:ref:`DTDateFormat<DTDateFormat_x64>`, :ref:`DateTime Formats<DateTime Formats>`

