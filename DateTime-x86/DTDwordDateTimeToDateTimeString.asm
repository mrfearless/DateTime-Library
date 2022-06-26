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

include kernel32.inc
includelib kernel32.lib

include DateTime.inc

EXTERN DTDateFormat :PROTO DateTime:DWORD, lpszDateTimeString:DWORD, DateFormat:DWORD

.CODE

DATETIME_ALIGN
;------------------------------------------------------------------------------
; DTDwordDateTimeToDateTimeString
;
; Converts DWORD values containing date & time information to a formatted date 
; & time string as specified by the DateFormat parameter.
;
; Parameters:
;
; * dwDate - DWORD value containing Date information to convert to the date & 
;   time string
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
; * dwTime - DWORD value containing Time information to convert to the date & 
;   time string
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
; * lpszDateTimeString - Pointer to a buffer to store the date & time string. 
;   The format of the date & time string is determined by the DateFormat 
;   parameter.
;
; * DateFormat - Value indicating the date & time format to return in the buffer 
;   pointed to by lpszDateTimeString parameter. The parameter can contain one of
;   the constants as defined in the DateTime.inc
;
; Returns:
;
; No return value
;
;------------------------------------------------------------------------------
DTDwordDateTimeToDateTimeString PROC dwDate:DWORD, dwTime:DWORD, lpszDateTimeString:DWORD, DateFormat:DWORD
    LOCAL LocalDateTime[DATETIME_STRING]:BYTE

    Invoke RtlZeroMemory, Addr LocalDateTime, DATETIME_STRING
    
    lea ebx, LocalDateTime
    mov eax, dwDate
    shr eax, 16                 ; move year into upper word of eax      
    mov word ptr [ebx], ax      ; year

    mov eax, dwDate
    mov byte ptr [ebx +2], ah   ; month
    mov byte ptr [ebx +6], al   ; day
    
    mov eax, dwTime
    shr eax, 16                 ; move hour and minute into upper word of eax   
    mov byte ptr [ebx +8], ah   ; hours
    mov byte ptr [ebx +10], al  ; minutes
    mov eax, dwTime
    mov byte ptr [ebx +12], ah  ; seconds
    mov byte ptr [ebx +14], al  ; millseconds

    Invoke DTDateFormat, Addr LocalDateTime, lpszDateTimeString, DateFormat

    mov eax, 0
    
    ret
DTDwordDateTimeToDateTimeString ENDP

end