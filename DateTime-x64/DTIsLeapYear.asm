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

DATETIME_ALIGN
;------------------------------------------------------------------------------
; DTIsLeapYear
;
; Calculate if a specified year is a leap year.
; 
; Parameters:
;
; * qwYear - a QWORD value that has the year value to check for leap year.
;
; Returns:
;
; Returns TRUE if year is a leap year, otherwise FALSE.
;
; Notes:
; 
; dwYear must include the century. For example 2008 which in a QWORD value is 
; stored as 0x7D8
;
; A year will be a leap year if it is divisible by 4 but not by 100. If a year 
; is divisible by 4 and by 100, it is not a leap year unless it is also 
; divisible by 400.
;
;------------------------------------------------------------------------------
DTIsLeapYear PROC FRAME USES RCX RDX qwYear:QWORD
    mov rcx, 100
    mov rax, qwYear
    xor rdx, rdx
    div rcx
    .IF (rdx)       
        mov rax, qwYear ; reload year
    .ENDIF
    and rax, 3
    
    .IF rax == 0
        mov eax, TRUE
    .ELSE
        mov eax, FALSE  
    .ENDIF
    
    ret
DTIsLeapYear ENDP





END