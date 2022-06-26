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

EXTERN DTDateTimeStringToJulianMillisec :PROTO lpszDateTimeString:DWORD, DateFormat:DWORD

.CODE

DATETIME_ALIGN
;-----------------------------------------------------------------------------
; DTDatesTimesDifference
; 
; Returns the difference in days or milliseconds of the first date & time 
; string to the second date & time string.
;
; Parameters:
;
; * lpszDateTimeString1 - Pointer to a buffer containing the first date & 
;   time string. The format of the date & time string is determined by the 
;   DateFormat parameter.
;
; * lpszDateTimeString2 - Pointer to a buffer containing the second date & 
;   time string. The format of the date & time string is determined by the 
;   DateFormat parameter.
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
; On return EDX contains the difference in time or 0.
; 
; If both dates are the same date, then EAX will be 0. If both date & time 
; strings contain time values and the DateFormat parameter specified also 
; provides a time format, then EDX will contain the difference in time in 
; milliseconds.
;
;------------------------------------------------------------------------------
DTDateTimeStringsDifference PROC USES EBX lpszDateTimeString1:DWORD, lpszDateTimeString2:DWORD, DateFormat:DWORD
    LOCAL DT_JD1:DWORD ; Julian date 1
    LOCAL DT_JD2:DWORD ; Julian date 2
    LOCAL TM_JD1:DWORD ; Millisecs 1
    LOCAL TM_JD2:DWORD ; Millisecs 2
    LOCAL HH_JD1:DWORD ; Hours 1
    LOCAL HH_JD2:DWORD ; Hours 2
    LOCAL MM_JD1:DWORD ; Minutes 1
    LOCAL MM_JD2:DWORD ; Minutes 2
    LOCAL SS_JD1:DWORD ; Seconds 1
    LOCAL SS_JD2:DWORD ; Seconds 2
    
    Invoke DTDateTimeStringToJulianMillisec, lpszDateTimeString1, DateFormat
    mov DT_JD1, eax ; save value as julian date
    mov TM_JD1, edx ; save value as milliseconds
    
    Invoke DTDateTimeStringToJulianMillisec, lpszDateTimeString2, DateFormat
    mov DT_JD2, eax ; save value as julian date
    mov TM_JD2, edx ; save value as milliseconds
    
    mov eax, DT_JD1
    mov ebx, DT_JD2
    sub eax, ebx ;subtract date 1 from date 2 and return difference
    xor edx, edx

    .IF eax == 0 ; same date, check milliseconds
        ;(duration/(1000*60*60))%24) 3600000
        .IF DateFormat == CCYYMMDDHH
            ; Div by 3600000 using magicnumber
            mov eax,TM_JD1
            mov edx,095217CB1h
            mul edx
            shr edx,015h
            mov HH_JD1, edx
            
            ; Div by 3600000 using magicnumber
            mov eax,TM_JD2
            mov edx,095217CB1h
            mul edx
            shr edx,015h
            mov HH_JD2, edx

            mov eax, HH_JD1
            mov ebx, HH_JD2
            sub eax, ebx
        
        .ELSEIF DateFormat == CCYYMMDDHHMM
            ; Div by 6000 using magicnumber
            mov eax,TM_JD1
            mov edx,057619F1h
            mul edx
            shr edx,07h
            mov MM_JD1, edx
            
            ; Div by 6000 using magicnumber
            mov eax,TM_JD2
            mov edx,057619F1h
            mul edx
            shr edx,07h
            mov MM_JD2, edx

            mov eax, MM_JD1
            mov ebx, MM_JD2
            sub eax, ebx   
            
        .ELSEIF DateFormat == CCYYMMDDHHMMSS
            ; Div by 1000 using magicnumber
            mov eax,TM_JD1
            mov edx,010624DD3h
            mul edx
            shr edx,06h
            mov SS_JD1, edx
            
            ; Div by 1000 using magicnumber
            mov eax,TM_JD2
            mov edx,010624DD3h
            mul edx
            shr edx,06h
            mov SS_JD2, edx

            mov eax, SS_JD1
            mov ebx, SS_JD2
            sub eax, ebx
              
        .ELSEIF DateFormat == CCYYMMDDHHMMSSMS
            mov eax,TM_JD1
            mov ebx,TM_JD2
            sub eax, ebx
        .ENDIF
        mov edx, eax
        xor eax, eax
    .ENDIF
    
    ret
DTDateTimeStringsDifference ENDP

END