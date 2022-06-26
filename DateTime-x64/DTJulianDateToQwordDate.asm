;==============================================================================
;
; DateTime Library x64 v1.0.0.3
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

DATETIME_ALIGN
;------------------------------------------------------------------------------
; DTJulianDateToQwordDate
;
; Converts a Julian Date number to a QWORD value containing date information. 
; Uses CCYYMMDD DateTime Format
;
; Parameters:
;
; * JulianDate - A QWORD value containing the Julian date integer to convert to
;   a QWORD format in RAX

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
DTJulianDateToQwordDate PROC FRAME USES RBX RCX RDX JulianDate:QWORD
    
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
    
    LOCAL _j:QWORD
    LOCAL _g:QWORD
    LOCAL _dg:QWORD
    LOCAL _c:QWORD
    LOCAL _b:QWORD
    LOCAL _a:QWORD
    LOCAL _da:QWORD
    LOCAL _db:QWORD
    LOCAL _dc:QWORD
    LOCAL _dd:QWORD
    LOCAL _y:QWORD
    LOCAL _m:QWORD
    LOCAL _d:QWORD
    
    mov rax, JulianDate
    add rax, 32044
    mov _j, rax ; * let j = J + 32044; (note: this shifts the epoch back to astronomical year -4800 instead of the start of the Christian era in year 1 AD of the proleptic Gregorian calendar).
    ;PrintDec _j
    
    xor rdx, rdx
    mov rcx, 146097
    div rcx
    mov _g, rax ; * let g = j div 146097
    ;PrintDec _g
    
    mov rax, _j
    xor rdx, rdx
    mov rcx, 146097
    div rcx
    mov _dg, rdx ; let dg = j mod 146097
    ;PrintDec _dg
    
    mov rax, rdx
    xor rdx, rdx
    mov rcx, 36524
    div rcx
    add rax, 1
    mov rcx, 3
    mul rcx
    xor rdx, rdx
    mov rcx, 4
    div rcx
    mov _c, rax ; let c = (dg div 36524 + 1) × 3 div 4
    ;PrintDec _c
    
    mov rbx, _dg
    mov rax, _c
    mov rcx, 36524
    mul rcx
    sub rbx, rax
    mov _dc, rbx ; let dc = dg - c × 36524; check if right for mult first then subtract
    ;PrintDec _dc

    mov rax, _dc
    xor rdx, rdx
    mov rcx, 1461
    div rcx
    mov _b, rax ; let b = dc div 1461
    ;PrintDec _b

    mov rax, _dc
    xor rdx, rdx
    mov rcx, 1461
    div rcx
    mov _db, rdx ; let db = dc mod 1461;
    ;PrintDec _db
    
    mov rax, rdx
    xor rdx, rdx
    mov rcx, 365
    div rcx
    add rax, 1
    mov rcx, 3
    mul rcx
    xor rdx, rdx
    mov rcx, 4
    div rcx 
    mov _a, rax ; let a = (db div 365 + 1) × 3 div 4
    ;PrintDec _a
    
    mov rbx, _db
    mov rcx, 365
    mul rcx
    sub rbx, rax
    mov _da, rbx ; let da = db - a × 365;
    ;PrintDec _da
    
    
    mov rax, _g
    mov rcx, 400
    mul rcx
    mov rbx, rax
    mov rax, _c
    mov rcx, 100
    mul rcx
    add rax, rbx
    mov rbx, rax
    mov rax, _b
    mov rcx, 4
    mul rcx
    add rax, rbx
    mov rbx, rax
    mov rax, _a
    add rax, rbx
    mov _y, rax ; let y = g × 400 + c × 100 + b × 4 + a; (note: this is the integer number of full years elapsed since March 1, 4801 BC at 00:00 UTC);
    ;PrintDec _y
    
    mov rax, _da
    mov rcx, 5
    mul rcx
    add rax, 308
    xor rdx, rdx
    mov rcx, 153
    div rcx
    sub rax, 2
    mov _m, rax ; let m = (da × 5 + 308) div 153 - 2; (note: this is the integer number of full months elapsed since the last March 1 at 00:00 UTC);
    ;PrintDec _m

    add rax, 4
    mov rcx, 153
    mul rcx
    xor rdx, rdx
    mov rcx, 5
    div rcx
    mov rbx, rax
    mov rax, _da
    sub rax, rbx
    add rax, 122
    mov _d, rax ; let d = da - (m + 4) × 153 div 5 + 122; (note: this is the number of days elapsed since day 1 of the month at 00:00 UTC, including fractions of one day);
    ;PrintDec _d
    
    mov rax, _y
    sub rax, 4800
    mov rbx, rax
    mov rax, _m
    add rax, 2
    xor rdx, rdx
    mov rcx, 12d
    div rcx
    add rax, rbx
    mov _y, rax ; let Y = y - 4800 + (m + 2) div 12 + a
    ;PrintDec _y
    
    mov rax, _m
    add rax, 2
    xor rdx, rdx
    mov rcx, 12
    div rcx
    add rdx, 1
    mov _m, rdx ; let M = (m + 2) mod 12 + 1
    
    mov rax, _d
    add rax, 1
    mov _d, rax ; let D = d + 1;
    
    mov rax, _y 
    shl rax, 16         ; move year into upper word of eax  
    mov rbx, _m
    mov ah, bl
    mov rbx, _d
    mov al, bl
    
    ; eax contains dword date in CCYYMMDD format
    ret 
DTJulianDateToQwordDate ENDP





END