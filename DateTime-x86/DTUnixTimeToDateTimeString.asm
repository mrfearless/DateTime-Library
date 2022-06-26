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

include masm32.inc
includelib masm32.lib

EXTERN DTUnixTimeToDwordDateTime :PROTO UnixTime:DWORD
EXTERN DTDwordDateTimeToDateTimeString :PROTO dwDate:DWORD, dwTime:DWORD, lpszDateTimeString:DWORD, DateFormat:DWORD

.CODE

DATETIME_ALIGN
;------------------------------------------------------------------------------
; DTUnixTimeToDateTimeString
;  
; Converts a unix time UNIXTIMESTAMP value to a formatted date & time string as 
; specified by the DateFormat parameter.
;
;Parameters:
;
; * UnixTime - Unix timestamp value UNIXTIMESTAMP to convert to a date & time 
;   string.
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
; as specified by the DateFormat specified.
;
; Notes:
;
; Unix time is defined as the number of seconds elapsed since 00:00 Universal 
; time on January 1, 1970 in the Gregorian calendar (Julian day 2440587.5)
;
;------------------------------------------------------------------------------
DTUnixTimeToDateTimeString PROC USES EDX UnixTime:DWORD, lpszDateTimeString:DWORD, DateFormat:DWORD
    LOCAL _Date:DWORD
    LOCAL _Time:DWORD
    
    .IF DateFormat == UNIXTIMESTAMP
        Invoke dwtoa, UnixTime, lpszDateTimeString
        ret
    .ENDIF
    
    Invoke DTUnixTimeToDwordDateTime, UnixTime
    mov _Date, eax
    mov _Time, edx
    Invoke DTDwordDateTimeToDateTimeString, _Date, _Time, lpszDateTimeString, DateFormat
    
    ret
DTUnixTimeToDateTimeString ENDP

END
