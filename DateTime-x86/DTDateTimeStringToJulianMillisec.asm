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

EXTERN DTDateTimeStringToDwordDateTime :PROTO lpszDateTimeString:DWORD, DateFormat:DWORD
EXTERN DTDwordDateToJulianDate :PROTO dwDate:DWORD
EXTERN DTDwordTimeToMillisec :PROTO dwTime:DWORD

.CODE

DATETIME_ALIGN
;------------------------------------------------------------------------------
; DTDateTimeStringToJulianMillisec
;
; Converts a formatted date & time string to a Julian date integer in EAX and 
; milliseconds in EDX
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
; On return EAX contains Julian date integer value representing the date 
; specified and EDX will contain the total time in milliseconds.
;
; Notes:
;
; Some information may be unavailable to convert if the passed DateTime string 
; does not contain enough information. For example if only year information is 
; in the DateTime string, then the DWORD date and DWORD time will be based only
; on that.
;
; To prevent this, always pass a full date time string of CCYYMMDDHHMMSSMS 
; format or similar (DDMMCCYYHHMMSSMS or MMDDCCYYHHMMSSMS)
;
;------------------------------------------------------------------------------
DTDateTimeStringToJulianMillisec PROC lpszDateTimeString:DWORD, DateFormat:DWORD
    LOCAL _Date:DWORD
    LOCAL _Time:DWORD
    LOCAL _jd:DWORD
    LOCAL _ms:DWORD
    
    Invoke DTDateTimeStringToDwordDateTime, lpszDateTimeString, DateFormat
    
    mov _Date, eax  ; save date info 
    mov _Time, edx  ; save time info

    Invoke DTDwordDateToJulianDate, _Date
    mov _jd, eax

    .IF _Time != 0
        Invoke DTDwordTimeToMillisec, _Time
        mov _ms, eax
        mov eax, _jd
        mov edx, _ms
    .ELSE   
        mov eax, _jd
        mov edx, 0
    .ENDIF
    
    ret 
DTDateTimeStringToJulianMillisec ENDP

END