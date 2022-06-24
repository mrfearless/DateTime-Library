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

EXTERN DTDwordDateToJulianDate :PROTO dwDate:DWORD
EXTERN DTDwordTimeToMillisec :PROTO dwTime:DWORD

.CODE

DATETIME_ALIGN
;------------------------------------------------------------------------------
; DTDwordDateTimeToUnixTime
; 
; Converts DWORD values containing date & time information to a unix time 
; UNIXTIMESTAMP value. On return EAX contains the UNIXTIMESTAMP value. 
;
; Parameters:
;
; * dwDate - DWORD value containing date information to convert to a 
;   UNIXTIMESTAMP.
;
;   The format for the value containing the date information is as follows:
;
;   +------------------------+------------+-----------+
;   | WORD                   | BYTE       | BYTE      |
;   +------------------------+------------+-----------+
;   | Bits 31-16             | Bits 15-8  | Bits 7-0  |
;   +------------------------+------------+-----------+
;   | Century Year           | Month      | Day       |
;   +------------------------+------------+-----------+
;   | CCCCYY                 | MM         | DD        |
;   +------------------------+------------+-----------+
;
; * dwTime - DWORD value containing time information to convert to a 
;   UNIXTIMESTAMP.
;
;   The format for the value containing the time information is as follows:
;
;   +------------+------------+-----------+-----------+
;   | BYTE       | BYTE       | BYTE      | BYTE      |
;   +------------+------------+-----------+-----------+
;   | Bits 31-23 | Bits 23-16 | Bits 15-8 | Bits 7-0  |
;   +------------+------------+-----------+-----------+
;   | Hour       | Minute     | Second    | Millisec  |
;   +------------+------------+-----------+-----------+
;   | HH         | MM         | SS        | MS        |
;   +------------+------------+-----------+-----------+
;
; Returns:
;
; On return EAX will contain the UNIXTIMESTAMP value.
;
; Notes:
;
; Unix time is defined as the number of seconds elapsed since 00:00 Universal 
; time on January 1, 1970 in the Gregorian calendar (Julian day 2440587.5)
;
;------------------------------------------------------------------------------
DTDwordDateTimeToUnixTime PROC USES EBX ECX EDX dwDate:DWORD, dwTime:DWORD
    LOCAL _jd:DWORD
    LOCAL _ms:DWORD
    LOCAL _UnixEpoch:DWORD
    LOCAL _UnixTime:DWORD

    mov _UnixEpoch, 2440588d
    Invoke DTDwordDateToJulianDate, dwDate
    mov _jd, eax
    
    .IF dwTime != 0
        Invoke DTDwordTimeToMillisec, dwTime
        mov _ms, eax
    .ELSE   
        mov _ms, 0
    .ENDIF
    
    mov eax, _jd
    mov ebx, _UnixEpoch ; Place UnixEpochDate in ebx
    sub eax, ebx ; subtract date2 from date1, eax = difference
    .IF sdword ptr eax < 0
        mov eax, 0
        ret
    .ENDIF
    
    mov edx, 86400d
    mul edx
    mov _UnixTime, eax
    
    ; Convert to seconds to add to final result
    .IF sdword ptr _ms > 0
        mov eax, _ms
        
        ; Div by 1000 using magicnumber
        mov edx,010624DD3h
        mul edx
        shr edx,06h
        add _UnixTime, edx ; add to unixtime to give correct amount
        
        ;xor edx, edx
        ;mov ecx, 1000d
        ;div ecx
        ;add _UnixTime, eax ; add to unixtime to give correct amount
    .ENDIF
    mov eax, _UnixTime
    
    ret
DTDwordDateTimeToUnixTime ENDP

END