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

.CODE

DATETIME_ALIGN
;------------------------------------------------------------------------------
; DTUnixTimeToQwordDateTime
;
; Converts a unix time UNIXTIMESTAMP value to QWORD values containing date and 
; time information.
;
; Parameters:
;
; * UnixTime - Unix timestamp value UNIXTIMESTAMP to convert to QWORD date & 
;   time values.
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
; Unix time is defined as the number of seconds elapsed since 00:00 Universal 
; time on January 1, 1970 in the Gregorian calendar (Julian day 2440587.5)
;
;------------------------------------------------------------------------------
DTUnixTimeToQwordDateTime PROC FRAME USES RBX RCX UnixTime:QWORD
    LOCAL _nDays:DWORD
    LOCAL _nHours:DWORD
    LOCAL _nMinutes:DWORD
    LOCAL _nSeconds:DWORD
    LOCAL _UnixEpoch:QWORD
    LOCAL _JulianDate:QWORD
    
;Public Function UnixTimeToDate(ByVal Timestamp As Long) As Date
;    Dim intDays As Integer, intHours As Integer, intMins As Integer, intSecs As Integer
;    intDays = Timestamp \ 86400
;    intHours = (Timestamp Mod 86400) \ 3600
;    intMins = (Timestamp Mod 3600) \ 60
;    intSecs = Timestamp Mod 60
;    UnixTimeToDate = DateSerial(1970, 1, intDays + 1) + TimeSerial(intHours, intMins, intSecs)
;End Function     

;    epoch-to-date: func [
;        "Return REBOL date from unix time format"
;        epoch [integer!] "Date in unix time format"
;    ][
;        day: 1-Jan-1970 + (to-integer epoch / 86400) 
;        hours:   to-integer epoch // 86400 / 3600
;        minutes: to-integer epoch // 86400 // 3600 / 60
;        seconds: to-integer epoch // 86400 // 3600 // 60
;        return (to-date rejoin [
;            day "/" hours ":" minutes ":" seconds now/zone
;        ]) + now/zone
;    ]

    mov rax, UnixTime
    xor rdx, rdx
    mov ecx, 86400
    div ecx 
    mov _nDays, eax ; let _nDays = nUnixTime / 86400
    
    mov rax, UnixTime
    xor rdx, rdx
    mov ecx, 86400
    div ecx
    mov eax, edx
    xor edx, edx
    mov ecx, 3600
    div ecx
    mov _nHours, eax ; let _nHours = nUnixTime mod 86400 / 3600
    
    mov rax, UnixTime    
    xor rdx, rdx
    mov ecx, 3600
    div ecx
    mov eax, edx
    xor edx, edx
    mov ecx, 60
    div ecx
    mov _nMinutes, eax ; let nMinutes = UnixTime mod 3600 / 60
    
    mov rax, UnixTime
    xor rdx, rdx
    mov ecx, 60
    div ecx
    mov _nSeconds, edx ; let nSeconds = UnixTime mod 60
    
    mov _UnixEpoch, 2440588d
    mov rax, _UnixEpoch
    add eax, _nDays
    mov _JulianDate, rax

    Invoke DTJulianDateToQwordDate, _JulianDate ; rax now contains the date qword
    xor rdx, rdx
    mov ebx, _nHours
    mov dh, bl
    mov ebx, _nMinutes
    
    mov dl, bl
    shl edx, 16
    mov ebx, _nSeconds
    mov dh, bl
    mov dl, 0   
    ; rdx now contains the time qword

    ret
DTUnixTimeToQwordDateTime ENDP





END