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


.CODE

;   if m > 2 then
;       m = m - 3
;   else
;       m = m + 9 ; y = y - 1
;   end if
;   
;   c = y / 100 ; ya = y - 100 * c ;
;   j = (146097 * c) / 4 + (1461 * ya) / 4 + (153 * m + 2) / 5 + d + 1721119

DATETIME_ALIGN
;------------------------------------------------------------------------------
; DTQwordDateToJulianDate
;
; Converts a QWORD value containing date information to a Julian date integer. 
; On return RAX contains the date information in Julian Date format
;
; Parameters:
;
; * qwDate - QWORD value containing Date information to convert to a Julian date
;   integer.
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
; Returns:
;
; On return RAX contains Julian date integer value representing the date 
; specified.

; Notes:
;
; The Julian Day Count is a uniform count of days from a remote epoch in the 
; past (-4712 January 1, 12 hours Greenwich Mean Time (Julian proleptic Calendar)
;  = 4713 BCE January 1, 12 hours GMT (Julian proleptic Calendar) At this 
; instant, the Julian Day Number is 0.
;
; The Julian Day Count has nothing to do with the Julian Calendar introduced by 
; Julius Caesar. It is named for Julius Scaliger, the father of Josephus Justus 
; Scaliger, who invented the concept. It can also be thought of as a logical 
; follow-on to the old Egyptian civil calendar, which also used years of 
; constant lengths.
;
; Scaliger chose the particular date in the remote past because it was before 
; recorded history and because in that year, three important cycles coincided 
; with their first year of the cycle: The 19-year Metonic Cycle, the 15-year 
; Indiction Cycle (a Roman Taxation Cycle) and the 28-year Solar Cycle (the 
; length of time for the old Julian Calendar to repeat exactly).
;
;------------------------------------------------------------------------------
DTQwordDateToJulianDate PROC FRAME USES RBX RCX RDX qwDate:QWORD
    LOCAL _d:QWORD
    LOCAL _m:QWORD
    LOCAL _y:QWORD
    LOCAL _ya:QWORD
    LOCAL _c:QWORD  
    LOCAL _j:QWORD
    LOCAL _j1:QWORD
    LOCAL _j2:QWORD
    LOCAL _j3:QWORD

    mov rdx, qwDate
    xor rax, rax
    mov al, dl
    mov _d, rax
    
    xor rax, rax
    mov al, dh
    mov _m, rax
    
    mov rdx, qwDate
    shr rdx,16
    mov _y, rdx 
    
    .IF _m >  2
        sub _m, 3
    .ELSE
        add _m, 9d
        dec _y  
    .ENDIF
    
    mov rax, _y
    xor rdx, rdx
    mov rcx, 100d
    div rcx
    mov _c, rax
    
    mov rcx, 100
    mul rcx
    mov rbx, rax
    mov rax, _y
    sub rax, rbx
    mov _ya, rax
    
    mov rax, _c
    mov rcx, 146097d
    mul rcx
    xor rdx, rdx
    mov rcx, 4
    div rcx
    mov _j1, rax
    
    mov rax, _ya
    mov rcx, 1461d
    mul rcx
    xor rdx, rdx
    mov rcx, 4
    div rcx
    mov _j2, rax
    
    mov rax, _m
    mov rcx, 153d
    mul rcx
    add rax, 2
    xor rdx, rdx
    mov rcx, 5
    div rcx
    mov _j3, rax
    
    mov rax, _j1
    add rax, _j2
    add rax, _j3
    add rax, _d
    add rax, 1721119d
    
    ret
DTQwordDateToJulianDate ENDP





END