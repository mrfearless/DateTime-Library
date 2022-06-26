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

includelib kernel32.lib

include DateTime.inc

EXTERN DTJulianDateToQwordDate :PROTO JulianDate:QWORD
EXTERN DTMillisecToQwordTime :PROTO Milliseconds:QWORD
EXTERN DTDateFormat :PROTO DateTime:QWORD, lpszDateTimeString:QWORD, DateFormat:QWORD

.CODE

DATETIME_ALIGN
;------------------------------------------------------------------------------
; DTJulianMillisecToDateTimeString
;
; Converts a Julian date integer and millisec time to a formatted date & time 
; string as specified by the DateFormat parameter.
;
; Parameters:

; * JulianDate - A QWORD value containing the Julian date integer to convert to
;   a gregorian date in the date & time string.
;
; * Milliseconds - A QWORD value containting the total milliseconds to convert 
;   to hours, minutes, seconds and milliseconds in the date & time string.
;
; * lpszDateTimeString - Pointer to a buffer to store the date & time string. 
;   The format of the date & time string is determined by the DateFormat 
;   parameter.
;
; * DateFormat - Value indicating the date & time format to return in the buffer 
;   pointed to by lpszDateTimeString parameter. The parameter can contain one 
;   of the constants as defined in the DateTime.inc
;
; Returns:
;
; There is no return value, the date & time string will contain the date & time 
; as specified by the DateFormat parameter.
;
; Notes:
;
; No time information is converted with the Julian date value, so if formatting 
; outputs a time, it will be empty as in 00:00:00:00
;
;------------------------------------------------------------------------------
DTJulianMillisecToDateTimeString PROC FRAME USES RBX RDX JulianDate:QWORD, Milliseconds:QWORD, lpszDateTimeString:QWORD, DateFormat:QWORD
    LOCAL LocalDateTime[DATETIME_STRING]:BYTE

    Invoke RtlZeroMemory, Addr LocalDateTime, DATETIME_STRING
    
    Invoke DTJulianDateToQwordDate, JulianDate

    lea rbx, LocalDateTime
    xor rdx, rdx
    mov rdx, rax
    shr rax, 16                 ; move year into upper word of rax      
    mov word ptr [rbx], ax
    mov rax, rdx
    mov byte ptr [rbx +2], ah
    mov byte ptr [rbx +6], al
    
    Invoke DTMillisecToQwordTime, Milliseconds
    
    lea rbx, LocalDateTime 
    xor rdx, rdx
    mov rdx, rax
    shr rax, 16                 ; move hour and minutes into upper word of rax      
    mov word ptr [rbx +8], ax
    mov rax, rdx
    mov byte ptr [rbx +10d], ah
    mov byte ptr [rbx +12d], 0

    Invoke DTDateFormat, Addr LocalDateTime, lpszDateTimeString, DateFormat

    ret
DTJulianMillisecToDateTimeString ENDP





END