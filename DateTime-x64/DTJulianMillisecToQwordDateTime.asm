;==============================================================================
;
; DateTime Library x64 v1.0.0.2
;
; Copyright (c) 2022 by fearless
;
; All Rights Reserved
;
; http://github.com/mrfearless
;
;
; This software is provided 'as-is', without any express or implied warranty. 
; In no event will the author be held liable for any damages arising from the 
; use of this software.
;
; Permission is granted to anyone to use this software for any non-commercial 
; program. If you use the library in an application, an acknowledgement in the
; application or documentation is appreciated but not required. 
;
; You are allowed to make modifications to the source code, but you must leave
; the original copyright notices intact and not misrepresent the origin of the
; software. It is not allowed to claim you wrote the original software. 
; Modified files must have a clear notice that the files are modified, and not
; in the original state. This includes the name of the person(s) who modified 
; the code. 
;
; If you want to distribute or redistribute any portion of this package, you 
; will need to include the full package in it's original state, including this
; license and all the copyrights.  
;
; While distributing this package (in it's original state) is allowed, it is 
; not allowed to charge anything for this. You may not sell or include the 
; package in any commercial package without having permission of the author. 
; Neither is it allowed to redistribute any of the package's components with 
; commercial applications.
;
;==============================================================================

.686
.MMX
.XMM
.x64

option casemap : none
option win64 : 11
option frame : auto
option stackbase : rsp

_WIN64 EQU 1
WINVER equ 0501h

include windows.inc

include DateTime.inc

EXTERN DTJulianDateToQwordDate :PROTO JulianDate:QWORD
EXTERN DTMillisecToQwordTime :PROTO Milliseconds:QWORD

.CODE

DATETIME_ALIGN
;------------------------------------------------------------------------------
; DTJulianMillisecToQwordDateTime
;
; Converts Julian date integer value and total milliseconds to QWORD values 
; containing date and time information. On return RAX contains the date 
; information and RDX the time information.
;
; Parameters:
;
; * JulianDate - A QWORD value containing the Julian date integer to convert 
;   to a QWORD date in RAX.
;
; * Milliseconds - A QWORD value containting the total milliseconds to convert
;   to hours, minutes, seconds and milliseconds in QWORD time in RDX.
;
; Returns:
;
; On return RAX will contain the date information in the following format:
;
; +--------------------------------------------------+------------------------+------------+-----------+
; | DWORD                                            | WORD                   | BYTE       | BYTE      |
; +--------------------------------------------------+------------------------+------------+-----------+
; | Bits 63-32                                       | Bits 31-16             | Bits 15-8  | Bits 7-0  |
; +--------------------------------------------------+------------------------+------------+-----------+
; | Not used - Not applicable                        | Century Year           | Month      | Day       |
; +--------------------------------------------------+------------------------+------------+-----------+
; | N/A                                              | CCCCYY                 | MM         | DD        |
; +--------------------------------------------------+------------------------+------------+-----------+
;
; On return RDX will contain the time information in the following format:
;
; +--------------------------------------------------+------------+------------+-----------+-----------+
; | DWORD                                            | BYTE       | BYTE       | BYTE      | BYTE      |
; +--------------------------------------------------+------------+------------+-----------+-----------+
; | Bits 63-32                                       | Bits 31-23 | Bits 23-16 | Bits 15-8 | Bits 7-0  |
; +--------------------------------------------------+------------+------------+-----------+-----------+
; | Not used - Not applicable                        | Hour       | Minute     | Second    | Millisec  |
; +--------------------------------------------------+------------+------------+-----------+-----------+
; | N/A                                              | HH         | MM         | SS        | MS        |
; +--------------------------------------------------+------------+------------+-----------+-----------+
;
; Notes:
;
; The registers always return the information in the format shown in the tables 
; above.
;
;------------------------------------------------------------------------------
DTJulianMillisecToQwordDateTime PROC FRAME JulianDate:QWORD, Milliseconds:QWORD
    LOCAL _Date:QWORD
    
    Invoke DTJulianDateToQwordDate, JulianDate
    mov _Date, rax
    
    Invoke DTMillisecToQwordTime, Milliseconds
    mov rdx, rax
    mov rax, _Date

    ret
DTJulianMillisecToQwordDateTime ENDP





END