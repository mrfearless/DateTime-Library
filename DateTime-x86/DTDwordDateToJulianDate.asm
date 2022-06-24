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
; DTDwordDateToJulianDate
;
; Converts a DWORD value containing date information to a Julian date integer. 
; On return EAX contains the date information in Julian Date format
;
; Parameters:
;
; * dwDate - DWORD value containing Date information to convert to a Julian date
;   integer.
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
; Returns:
;
; On return EAX contains Julian date integer value representing the date 
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
DTDwordDateToJulianDate PROC USES EBX ECX EDX dwDate:DWORD
    LOCAL _d:DWORD
    LOCAL _m:DWORD
    LOCAL _y:DWORD
    LOCAL _ya:DWORD
    LOCAL _c:DWORD  
    LOCAL _j:DWORD
    LOCAL _j1:DWORD
    LOCAL _j2:DWORD
    LOCAL _j3:DWORD

    mov edx, dwDate
    xor eax, eax
    mov al, dl
    mov _d, eax
    
    xor eax, eax
    mov al, dh
    mov _m, eax
    
    mov edx, dwDate
    shr edx,16
    mov _y, edx 
    
    .IF _m >  2
        sub _m, 3
    .ELSE
        add _m, 9d
        dec _y  
    .ENDIF
    
    mov eax, _y
    xor edx, edx
    mov ecx, 100d
    div ecx
    mov _c, eax
    
    mov ecx, 100
    mul ecx
    mov ebx, eax
    mov eax, _y
    sub eax, ebx
    mov _ya, eax
    
    mov eax, _c
    mov ecx, 146097d
    mul ecx
    xor edx, edx
    mov ecx, 4
    div ecx
    mov _j1, eax
    
    mov eax, _ya
    mov ecx, 1461d
    mul ecx
    xor edx, edx
    mov ecx, 4
    div ecx
    mov _j2, eax
    
    mov eax, _m
    mov ecx, 153d
    mul ecx
    add eax, 2
    xor edx, edx
    mov ecx, 5
    div ecx
    mov _j3, eax
    
    mov eax, _j1
    add eax, _j2
    add eax, _j3
    add eax, _d
    add eax, 1721119d
    
    ret
DTDwordDateToJulianDate ENDP

END
