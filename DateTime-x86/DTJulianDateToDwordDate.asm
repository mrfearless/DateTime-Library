;==============================================================================
;
; DateTime Library v1.0.0.3
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

DATETIME_ALIGN
;------------------------------------------------------------------------------
; DTJulianDateToDwordDate
;
; Converts a Julian Date number to a DWORD value containing date information. 
; Uses CCYYMMDD DateTime Format
;
; Parameters:
;
; * JulianDate - A DWORD value containing the Julian date integer to convert to
;   a DWORD format in EAX

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
DTJulianDateToDwordDate PROC USES EBX ECX EDX JulianDate:DWORD
    
;    Let J = JD + 0.5: (note: this shifts the epoch back by one half day, to start it at 00:00UTC, instead of 12:00 UTC);
;
;        * let j = J + 32044; (note: this shifts the epoch back to astronomical year -4800 instead of the start of the Christian era in year 1 AD of the proleptic Gregorian calendar).
;        * let g = j div 146097; let dg = j mod 146097;
;        * let c = (dg div 36524 + 1) × 3 div 4; let dc = dg - c × 36524;
;        * let b = dc div 1461; let db = dc mod 1461;
;        * let a = (db div 365 + 1) × 3 div 4; let da = db - a × 365;
;        * let y = g × 400 + c × 100 + b × 4 + a; (note: this is the integer number of full years elapsed since March 1, 4801 BC at 00:00 UTC);
;        * let m = (da × 5 + 308) div 153 - 2; (note: this is the integer number of full months elapsed since the last March 1 at 00:00 UTC);
;        * let d = da - (m + 4) × 153 div 5 + 122; (note: this is the number of days elapsed since day 1 of the month at 00:00 UTC, including fractions of one day);
;        * let Y = y - 4800 + (m + 2) div 12; let M = (m + 2) mod 12 + 1; let D = d + 1;
;
;    return astronomical Gregorian date (Y, M, D).  
    
    LOCAL _j:DWORD
    LOCAL _g:DWORD
    LOCAL _dg:DWORD
    LOCAL _c:DWORD
    LOCAL _b:DWORD
    LOCAL _a:DWORD
    LOCAL _da:DWORD
    LOCAL _db:DWORD
    LOCAL _dc:DWORD
    LOCAL _dd:SDWORD
    LOCAL _y:DWORD
    LOCAL _m:DWORD
    LOCAL _d:DWORD
    
    mov eax, JulianDate
    add eax, 32044
    mov _j, eax ; * let j = J + 32044; (note: this shifts the epoch back to astronomical year -4800 instead of the start of the Christian era in year 1 AD of the proleptic Gregorian calendar).
    ;PrintDec _j
    
    xor edx, edx
    mov ecx, 146097
    div ecx
    mov _g, eax ; * let g = j div 146097
    ;PrintDec _g
    
    mov eax, _j
    xor edx, edx
    mov ecx, 146097
    div ecx
    mov _dg, edx ; let dg = j mod 146097
    ;PrintDec _dg
    
    mov eax, edx
    xor edx, edx
    mov ecx, 36524
    div ecx
    add eax, 1
    mov ecx, 3
    mul ecx
    xor edx, edx
    mov ecx, 4
    div ecx
    mov _c, eax ; let c = (dg div 36524 + 1) × 3 div 4
    ;PrintDec _c
    
    mov ebx, _dg
    mov eax, _c
    mov ecx, 36524
    mul ecx
    sub ebx, eax
    mov _dc, ebx ; let dc = dg - c × 36524; check if right for mult first then subtract
    ;PrintDec _dc

    mov eax, _dc
    xor edx, edx
    mov ecx, 1461
    div ecx
    mov _b, eax ; let b = dc div 1461
    ;PrintDec _b

    mov eax, _dc
    xor edx, edx
    mov ecx, 1461
    div ecx
    mov _db, edx ; let db = dc mod 1461;
    ;PrintDec _db
    
    mov eax, edx
    xor edx, edx
    mov ecx, 365
    div ecx
    add eax, 1
    mov ecx, 3
    mul ecx
    xor edx, edx
    mov ecx, 4
    div ecx 
    mov _a, eax ; let a = (db div 365 + 1) × 3 div 4
    ;PrintDec _a
    
    mov ebx, _db
    mov ecx, 365
    mul ecx
    sub ebx, eax
    mov _da, ebx ; let da = db - a × 365;
    ;PrintDec _da
    
    
    mov eax, _g
    mov ecx, 400
    mul ecx
    mov ebx, eax
    mov eax, _c
    mov ecx, 100
    mul ecx
    add eax, ebx
    mov ebx, eax
    mov eax, _b
    mov ecx, 4
    mul ecx
    add eax, ebx
    mov ebx, eax
    mov eax, _a
    add eax, ebx
    mov _y, eax ; let y = g × 400 + c × 100 + b × 4 + a; (note: this is the integer number of full years elapsed since March 1, 4801 BC at 00:00 UTC);
    ;PrintDec _y
    
    mov eax, _da
    mov ecx, 5
    mul ecx
    add eax, 308
    xor edx, edx
    mov ecx, 153
    div ecx
    sub eax, 2
    mov _m, eax ; let m = (da × 5 + 308) div 153 - 2; (note: this is the integer number of full months elapsed since the last March 1 at 00:00 UTC);
    ;PrintDec _m

    add eax, 4
    mov ecx, 153
    mul ecx
    xor edx, edx
    mov ecx, 5
    div ecx
    mov ebx, eax
    mov eax, _da
    sub eax, ebx
    add eax, 122
    mov _d, eax ; let d = da - (m + 4) × 153 div 5 + 122; (note: this is the number of days elapsed since day 1 of the month at 00:00 UTC, including fractions of one day);
    ;PrintDec _d
    
    mov eax, _y
    sub eax, 4800
    mov ebx, eax
    mov eax, _m
    add eax, 2
    xor edx, edx
    mov ecx, 12d
    div ecx
    add eax, ebx
    mov _y, eax ; let Y = y - 4800 + (m + 2) div 12 + a
    ;PrintDec _y
    
    mov eax, _m
    add eax, 2
    xor edx, edx
    mov ecx, 12
    div ecx
    add edx, 1
    mov _m, edx ; let M = (m + 2) mod 12 + 1
    
    mov eax, _d
    add eax, 1
    mov _d, eax ; let D = d + 1;
    
    mov eax, _y 
    shl eax, 16         ; move year into upper word of eax  
    mov ebx, _m
    mov ah, bl
    mov ebx, _d
    mov al, bl
    
    ; eax contains dword date in CCYYMMDD format
    ret 
DTJulianDateToDwordDate ENDP

END