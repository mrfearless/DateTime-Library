;==============================================================================
;
; DateTime Library v1.0.0.2
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
.model flat,stdcall
option casemap:none
include \masm32\macros\macros.asm

include DateTime.inc

EXTERN DTJulianDateToDwordDate :PROTO JulianDate:DWORD

.CODE

DATETIME_ALIGN
;------------------------------------------------------------------------------
; DTUnixTimeToDwordDateTime
;
; Converts a unix time UNIXTIMESTAMP value to DWORD values containing date and 
; time information.
;
; Parameters:
;
; * UnixTime - Unix timestamp value UNIXTIMESTAMP to convert to DWORD date & 
;   time values.
;
; Returns:
;
; On return EAX will contain the date information in the following format:
;
; +------------------------+------------+-----------+
; | WORD                   | BYTE       | BYTE      |
; +------------------------+------------+-----------+
; | Bits 31-16             | Bits 15-8  | Bits 7-0  |
; +------------------------+------------+-----------+
; | Century Year           | Month      | Day       |
; +------------------------+------------+-----------+
; | CCCCYY                 | MM         | DD        |
; +------------------------+------------+-----------+
;
; On return EDX will contain the time information in the following format:
;
; +------------+------------+-----------+-----------+
; | BYTE       | BYTE       | BYTE      | BYTE      |
; +------------+------------+-----------+-----------+
; | Bits 31-23 | Bits 23-16 | Bits 15-8 | Bits 7-0  |
; +------------+------------+-----------+-----------+
; | Hour       | Minute     | Second    | Millisec  |
; +------------+------------+-----------+-----------+
; | HH         | MM         | SS        | MS        |
; +------------+------------+-----------+-----------+
;
; Notes:
;
; Unix time is defined as the number of seconds elapsed since 00:00 Universal 
; time on January 1, 1970 in the Gregorian calendar (Julian day 2440587.5)
;
;------------------------------------------------------------------------------
DTUnixTimeToDwordDateTime PROC USES EBX ECX UnixTime:DWORD
    LOCAL _nDays:DWORD
    LOCAL _nHours:DWORD
    LOCAL _nMinutes:DWORD
    LOCAL _nSeconds:DWORD
    LOCAL _UnixEpoch:DWORD
    LOCAL _JulianDate:DWORD
    
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

    mov eax, UnixTime
    xor edx, edx
    mov ecx, 86400
    div ecx 
    mov _nDays, eax ; let _nDays = nUnixTime / 86400
    
    mov eax, UnixTime
    xor edx, edx
    mov ecx, 86400
    div ecx
    mov eax, edx
    xor edx, edx
    mov ecx, 3600
    div ecx
    mov _nHours, eax ; let _nHours = nUnixTime mod 86400 / 3600
    
    mov eax, UnixTime    
    xor edx, edx
    mov ecx, 3600
    div ecx
    mov eax, edx
    xor edx, edx
    mov ecx, 60
    div ecx
    mov _nMinutes, eax ; let nMinutes = UnixTime mod 3600 / 60
    
    mov eax, UnixTime
    xor edx, edx
    mov ecx, 60
    div ecx
    mov _nSeconds, edx ; let nSeconds = UnixTime mod 60
    
    mov _UnixEpoch, 2440588d
    mov eax, _UnixEpoch
    add eax, _nDays
    mov _JulianDate, eax

    Invoke DTJulianDateToDwordDate, _JulianDate ; eax now contains the date dword
    xor edx, edx
    mov ebx, _nHours
    mov dh, bl
    mov ebx, _nMinutes
    
    mov dl, bl
    shl edx, 16
    mov ebx, _nSeconds
    mov dh, bl
    mov dl, 0   
    ; edx now contains the time dword

    ret
DTUnixTimeToDwordDateTime ENDP

END