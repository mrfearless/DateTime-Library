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

EXTERN DTDateTimeStringToQwordDateTime :PROTO lpszDateTimeString:QWORD, DateFormat:QWORD
EXTERN DTQwordDateToJulianDate :PROTO qwDate:QWORD
EXTERN DTQwordTimeToMillisec :PROTO qwTime:QWORD

.CODE

DATETIME_ALIGN
;------------------------------------------------------------------------------
; DTDateTimeStringToJulianMillisec
;
; Converts a formatted date & time string to a Julian date integer in RAX and 
; milliseconds in RDX
;
; Parameters:
;
; * lpszDateTimeString - Pointer to a buffer containing the date & time string
;   to convert to Julian date integer and millisec values. The format of the 
;   date & time string is determined by the DateFormat parameter.
;
; * DateFormat - Value indicating the date & time format used in the buffer 
;   pointed to by lpszDateTimeString parameter. The parameter can contain one 
;   of the constants as defined in the DateTime.inc
;
; Returns:
;
; On return RAX contains Julian date integer value representing the date 
; specified and RDX will contain the total time in milliseconds.
;
; Notes:
;
; Some information may be unavailable to convert if the passed DateTime string 
; does not contain enough information. For example if only year information is 
; in the DateTime string, then the QWORD date and QWORD time will be based only
; on that.
;
; To prevent this, always pass a full date time string of CCYYMMDDHHMMSSMS 
; format or similar (DDMMCCYYHHMMSSMS or MMDDCCYYHHMMSSMS)
;
;------------------------------------------------------------------------------
DTDateTimeStringToJulianMillisec PROC FRAME lpszDateTimeString:QWORD, DateFormat:QWORD
    LOCAL _Date:QWORD
    LOCAL _Time:QWORD
    LOCAL _jd:QWORD
    LOCAL _ms:QWORD
    
    Invoke DTDateTimeStringToQwordDateTime, lpszDateTimeString, DateFormat
    
    mov _Date, rax  ; save date info 
    mov _Time, rdx  ; save time info

    Invoke DTQwordDateToJulianDate, _Date
    mov _jd, rax

    .IF _Time != 0
        Invoke DTQwordTimeToMillisec, _Time
        mov _ms, rax
        mov rax, _jd
        mov rdx, _ms
    .ELSE   
        mov rax, _jd
        mov rdx, 0
    .ENDIF
    
    ret 
DTDateTimeStringToJulianMillisec ENDP



END