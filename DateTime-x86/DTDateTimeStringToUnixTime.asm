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
; DTDateTimeStringToUnixTime
;
; Converts a formatted date & time string to a unix time UNIXTIMESTAMP value.
;
; Parameters:
;
; * lpszDateTimeString - Pointer to a buffer containing the date & time string 
;   to convert to a UNIXTIMESTAMP value. The format of the date & time string 
;   is determined by the DateFormat parameter.
;
; * DateFormat - Value indicating the date & time format used in the buffer 
;   pointed to by lpszDateTimeString parameter. The parameter can contain one 
;  of the constants as defined in the DateTime.inc
;
; Returns:
;
; On return EAX contains the unix time as a UNIXTIMESTAMP value.
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
DTDateTimeStringToUnixTime PROC USES EBX ECX EDX lpszDateTimeString:DWORD, DateFormat:DWORD
    LOCAL _Date:DWORD
    LOCAL _Time:DWORD
    LOCAL _jd:DWORD
    LOCAL _ms:DWORD
    LOCAL _UnixEpoch:DWORD
    LOCAL _UnixTime:DWORD

    ;Invoke DTDateToJulianMillisec, CTEXT("1970/01/01"), CCYYMMDD
    mov _UnixEpoch, 2440588d
    
    Invoke DTDateTimeStringToDwordDateTime, lpszDateTimeString, DateFormat
    mov _Date, eax  ; save date info 
    mov _Time, edx  ; save time info
    
    Invoke DTDwordDateToJulianDate, _Date
    mov _jd, eax
    
    .IF _Time != 0
        Invoke DTDwordTimeToMillisec, _Time
        mov _ms, eax
    .ELSE   
        mov _ms, 0
    .ENDIF
    
    mov eax, _jd
    mov ebx, _UnixEpoch ; Place UnixEpochDate in ebx
    sub eax, ebx ; subtract date2 from date1, eax = difference
    .IF eax < 0
        mov eax, 0
        ret
    .ENDIF
    
    mov edx, 86400d
    mul edx
    mov _UnixTime, eax
    
    ; Convert to seconds to add to final result
    .IF sdword ptr _ms > 0
        mov eax, _ms
        
        ; Div by 1000 using magicnumber
        mov edx,010624DD3h
        mul edx
        shr edx,06h        
        add _UnixTime, edx ; add to unixtime to give correct amount
        
        ;xor edx, edx
        ;mov ecx, 1000d
        ;div ecx
        ;add _UnixTime, eax ; add to unixtime to give correct amount
    .ENDIF
    mov eax, _UnixTime
    
    ret
DTDateTimeStringToUnixTime ENDP

END
