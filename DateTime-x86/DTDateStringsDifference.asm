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

EXTERN DTDateTimeStringToJulianMillisec :PROTO lpszDateTimeString:DWORD, DateFormat:DWORD

.CODE

DATETIME_ALIGN
;------------------------------------------------------------------------------
; DTDateStringsDifference
;
; Returns the difference in days of the first date & time string to the second 
; date & time string.
;
; Parameters:
;
; * lpszDateTimeString1 - Pointer to a buffer containing the first date & time
;   string. The format of the date & time string is determined by the DateFormat
;   parameter.

; * lpszDateTimeString2 - Pointer to a buffer containing the second date & time
;   string. The format of the date & time string is determined by the DateFormat
;   parameter.
;
; * DateFormat - Value indicating the date & time format used in the buffer 
;   pointed to by both the lpszDateTimeString1 parameter and the 
;   lpszDateTimeString2 parameter. The parameter can contain one of the 
;   constants as defined in the DateTime.inc
;
; Returns:
;
; On return EAX contains the difference between the two dates in days as an 
; integer, either positive or negative.
;
;------------------------------------------------------------------------------
DTDateStringsDifference PROC USES EBX EDX lpszDateTimeString1:DWORD, lpszDateTimeString2:DWORD, DateFormat:DWORD
    LOCAL DT_JD1:DWORD ; Julian date
    LOCAL DT_JD2:DWORD ; Julian date
    
    Invoke DTDateTimeStringToJulianMillisec, lpszDateTimeString1, DateFormat
    mov DT_JD1, eax ; save value as julian date, ignore time in EDX
    
    Invoke DTDateTimeStringToJulianMillisec, lpszDateTimeString2, DateFormat
    mov DT_JD2, eax ; save value as julian date, ignore time in EDX
    
    mov eax, DT_JD1
    mov ebx, DT_JD2
    sub eax, ebx ;subtract date 1 from date 2 and return difference
    
    ret
DTDateStringsDifference ENDP

END