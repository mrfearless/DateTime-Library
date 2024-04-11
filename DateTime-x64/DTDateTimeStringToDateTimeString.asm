;==============================================================================
;
; DateTime Library x64 v1.0.0.4
;
; Copyright (c) 2024 by fearless
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

include Masm64.Inc
includelib Masm64.lib

include DateTime.inc

EXTERN DTQwordDateToJulianDate :PROTO qwDate:QWORD
EXTERN DTQwordTimeToMillisec :PROTO qwTime:QWORD
EXTERN DTDateTimeStringToQwordDateTime :PROTO lpszDateTimeString:QWORD, DateFormat:QWORD
EXTERN DTQwordDateTimeToDateTimeString :PROTO qwDate:QWORD, qwTime:QWORD, lpszDateTimeString:QWORD, DateFormat:QWORD

.CODE

DATETIME_ALIGN
;------------------------------------------------------------------------------
; DTDateTimeStringToDateTimeString
; 
; Converts a formatted date & time string to another formatted date & time string
;
; Parameters:
;
; * lpszDateTimeStringIn - Pointer to a buffer containing the date & time string 
;   to convert. The format of the date & time string is determined by the 
;   DateFormat parameter.
;
; * DateFormatIn - Value indicating the date & time format used in the buffer 
;   pointed to by lpszDateTimeStringIn parameter. The parameter can contain one 
;   of the constants as defined in the DateTime.inc
;
; * lpszDateTimeStringOut - Pointer to a buffer to contain the converted date & 
;   time string. The format of the date & time string is determined by the 
;   DateFormat parameter.
;
; * DateFormatOut - Value indicating the date & time format used in the buffer 
;   pointed to by lpszDateTimeStringOut parameter. The parameter can contain one 
;   of the constants as defined in the DateTime.inc
;
; Notes: 
;
; The DateFormat parameter is used to indicate the format of the date & time 
; string being passed to DTDateTimeStringToDwordDateTime.
;
; Some information may be unavailable to convert if the passed DateTime string 
; does not contain enough information.
;
; To prevent this, always pass a full date time string of CCYYMMDDHHMMSSMS 
; format or similar (DDMMCCYYHHMMSSMS or MMDDCCYYHHMMSSMS)
;
;------------------------------------------------------------------------------
DTDateTimeStringToDateTimeString PROC FRAME USES RDX lpszDateTimeStringIn:QWORD, DateFormatIn:QWORD, lpszDateTimeStringOut:QWORD, DateFormatOut:QWORD
    LOCAL qwDate:QWORD
    LOCAL qwTime:QWORD
    
    Invoke DTDateTimeStringToQwordDateTime, lpszDateTimeStringIn, DateFormatIn
    mov qwDate, rax
    mov qwTime, rdx
    
    Invoke DTQwordDateTimeToDateTimeString, qwDate, qwTime, lpszDateTimeStringOut, DateFormatOut
    
    xor eax, eax
    ret
DTDateTimeStringToDateTimeString ENDP





END