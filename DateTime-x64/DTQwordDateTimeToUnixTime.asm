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

EXTERN DTQwordDateToJulianDate :PROTO qwDate:QWORD
EXTERN DTQwordTimeToMillisec :PROTO qwTime:QWORD

.CODE

DATETIME_ALIGN
;------------------------------------------------------------------------------
; DTQwordDateTimeToUnixTime
; 
; Converts QWORD values containing date & time information to a unix time 
; UNIXTIMESTAMP value. On return RAX contains the UNIXTIMESTAMP value. 
;
; Parameters:
;
; * qwDate - QWORD value containing date information to convert to a 
;   UNIXTIMESTAMP.
;
;   The format for the value containing the date information is as follows:
;
;   +--------------------------------------------------+------------------------+------------+-----------+
;   | DWORD                                            | WORD                   | BYTE       | BYTE      |
;   +--------------------------------------------------+------------------------+------------+-----------+
;   | Bits 63-32                                       | Bits 31-16             | Bits 15-8  | Bits 7-0  |
;   +--------------------------------------------------+------------------------+------------+-----------+
;   | Not used - Not applicable                        | Century Year           | Month      | Day       |
;   +--------------------------------------------------+------------------------+------------+-----------+
;   | N/A                                              | CCCCYY                 | MM         | DD        |
;   +--------------------------------------------------+------------------------+------------+-----------+
;
; * qwTime - QWORD value containing time information to convert to a 
;   UNIXTIMESTAMP.
;
;   The format for the value containing the time information is as follows:
;
;   +--------------------------------------------------+------------+------------+-----------+-----------+
;   | DWORD                                            | BYTE       | BYTE       | BYTE      | BYTE      |
;   +--------------------------------------------------+------------+------------+-----------+-----------+
;   | Bits 63-32                                       | Bits 31-23 | Bits 23-16 | Bits 15-8 | Bits 7-0  |
;   +--------------------------------------------------+------------+------------+-----------+-----------+
;   | Not used - Not applicable                        | Hour       | Minute     | Second    | Millisec  |
;   +--------------------------------------------------+------------+------------+-----------+-----------+
;   | N/A                                              | HH         | MM         | SS        | MS        |
;   +--------------------------------------------------+------------+------------+-----------+-----------+
;
; Returns:
;
; On return RAX will contain the UNIXTIMESTAMP value.
;
; Notes:
;
; Unix time is defined as the number of seconds elapsed since 00:00 Universal 
; time on January 1, 1970 in the Gregorian calendar (Julian day 2440587.5)
;
;------------------------------------------------------------------------------
DTQwordDateTimeToUnixTime PROC FRAME USES RBX RCX RDX qwDate:QWORD, qwTime:QWORD
    LOCAL _jd:QWORD
    LOCAL _ms:QWORD
    LOCAL _UnixEpoch:QWORD
    LOCAL _UnixTime:QWORD

    mov _UnixEpoch, 2440588d
    Invoke DTQwordDateToJulianDate, qwDate
    mov _jd, rax
    
    .IF qwTime != 0
        Invoke DTQwordTimeToMillisec, qwTime
        mov _ms, rax
    .ELSE   
        mov _ms, 0
    .ENDIF
    
    mov rax, _jd
    mov rbx, _UnixEpoch ; Place UnixEpochDate in ebx
    sub rax, rbx ; subtract date2 from date1, eax = difference
    .IF sqword ptr rax < 0
        mov rax, 0
        ret
    .ENDIF
    
    mov rdx, 86400d
    mul rdx
    mov _UnixTime, rax
    
    ; Convert to seconds to add to final result
    .IF sqword ptr _ms > 0
        mov rax, _ms
        
        ; Div by 1000 using magicnumber
        mov rdx,083126E978D4FDF3Bh
        add rax,1
        .if !CARRY?
            mul rdx
        .endif
        shr rdx,09h
        add _UnixTime, rdx ; add to unixtime to give correct amount
        
        ;xor edx, edx
        ;mov ecx, 1000d
        ;div ecx
        ;add _UnixTime, eax ; add to unixtime to give correct amount
    .ENDIF
    mov rax, _UnixTime
    
    ret
DTQwordDateTimeToUnixTime ENDP





END