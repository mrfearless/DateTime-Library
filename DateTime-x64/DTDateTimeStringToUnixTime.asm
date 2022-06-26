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

include Masm64.Inc
includelib Masm64.lib

EXTERN DTDateTimeStringToQwordDateTime :PROTO lpszDateTimeString:QWORD, DateFormat:QWORD
EXTERN DTQwordDateToJulianDate :PROTO qwDate:QWORD
EXTERN DTQwordTimeToMillisec :PROTO qwTime:QWORD

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
; On return RAX contains the unix time as a UNIXTIMESTAMP value.
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
DTDateTimeStringToUnixTime PROC FRAME USES RBX RCX RDX lpszDateTimeString:QWORD, DateFormat:QWORD
    LOCAL _Date:QWORD
    LOCAL _Time:QWORD
    LOCAL _jd:QWORD
    LOCAL _ms:QWORD
    LOCAL _UnixEpoch:QWORD
    LOCAL _UnixTime:QWORD

    .IF DateFormat == UNIXTIMESTAMP
        Invoke atoqw, lpszDateTimeString
        ret
    .ENDIF

    ;Invoke DTDateToJulianMillisec, CTEXT("1970/01/01"), CCYYMMDD
    mov _UnixEpoch, 2440588d
    
    Invoke DTDateTimeStringToQwordDateTime, lpszDateTimeString, DateFormat
    mov _Date, rax  ; save date info 
    mov _Time, rdx  ; save time info
    
    Invoke DTQwordDateToJulianDate, _Date
    mov _jd, rax
    
    .IF _Time != 0
        Invoke DTQwordTimeToMillisec, _Time
        mov _ms, rax
    .ELSE   
        mov _ms, 0
    .ENDIF
    
    mov rax, _jd
    mov rbx, _UnixEpoch ; Place UnixEpochDate in ebx
    sub rax, rbx ; subtract date2 from date1, eax = difference
    .IF eax < 0
        mov rax, 0
        ret
    .ENDIF
    
    mov rdx, 86400d
    mul rdx
    mov _UnixTime, rax
    
    ; Convert to seconds to add to final result
    .IF sqword ptr _ms > 0
        mov rax, _ms
        
        ; Div by 1000 using magicnumber
        mov rdx,083126E978D4FDF3Bh
        add rax,1
        .if !CARRY?
            mul rdx
        .endif
        shr rdx,09h
        add _UnixTime, rdx ; add to unixtime to give correct amount
        
        ;xor rdx, rdx
        ;mov rcx, 1000d
        ;div rcx
        ;add _UnixTime, rax ; add to unixtime to give correct amount
    .ENDIF
    mov rax, _UnixTime
    
    ret
DTDateTimeStringToUnixTime ENDP





END