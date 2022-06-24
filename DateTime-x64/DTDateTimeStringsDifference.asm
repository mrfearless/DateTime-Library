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

EXTERN DTDateTimeStringToJulianMillisec :PROTO lpszDateTimeString:QWORD, DateFormat:QWORD

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
; On return RAX contains the difference between the two dates in days as an 
; integer, either positive or negative.
;
; On return RDX contains the difference in time or 0.
; 
; If both dates are the same date, then RAX will be 0. If both date & time 
; strings contain time values and the DateFormat parameter specified also 
; provides a time format, then RDX will contain the difference in time in 
; milliseconds.
;
;------------------------------------------------------------------------------
DTDateTimeStringsDifference PROC FRAME USES RBX lpszDateTimeString1:QWORD, lpszDateTimeString2:QWORD, DateFormat:QWORD
    LOCAL DT_JD1:QWORD ; Julian date 1
    LOCAL DT_JD2:QWORD ; Julian date 2
    LOCAL TM_JD1:QWORD ; Millisecs 1
    LOCAL TM_JD2:QWORD ; Millisecs 2
    LOCAL HH_JD1:QWORD ; Hours 1
    LOCAL HH_JD2:QWORD ; Hours 2
    LOCAL MM_JD1:QWORD ; Minutes 1
    LOCAL MM_JD2:QWORD ; Minutes 2
    LOCAL SS_JD1:QWORD ; Seconds 1
    LOCAL SS_JD2:QWORD ; Seconds 2
    
    Invoke DTDateTimeStringToJulianMillisec, lpszDateTimeString1, DateFormat
    mov DT_JD1, rax ; save value as julian date
    mov TM_JD1, rdx ; save value as milliseconds
    
    Invoke DTDateTimeStringToJulianMillisec, lpszDateTimeString2, DateFormat
    mov DT_JD2, rax ; save value as julian date
    mov TM_JD2, rdx ; save value as milliseconds
    
    mov rax, DT_JD1
    mov rbx, DT_JD2
    sub rax, rbx ;subtract date 1 from date 2 and return difference
    xor rdx, rdx

    .IF eax == 0 ; same date, check milliseconds
        ;(duration/(1000*60*60))%24) 3600000
        .IF DateFormat == CCYYMMDDHH
            ; Div by 3600000 using magicnumber
            mov rax,TM_JD1
            mov rdx,04A90BE587DE6E565h
            mul rdx
            shr rdx,014h
            mov HH_JD1, rdx          

            ; Div by 3600000 using magicnumber
            mov rax,TM_JD2
            mov rdx,04A90BE587DE6E565h
            mul rdx
            shr rdx,014h
            mov HH_JD2, rdx

            mov rax, HH_JD1
            mov rbx, HH_JD2
            sub rax, rbx

        
        .ELSEIF DateFormat == CCYYMMDDHHMM
            ; Div by 6000 using magicnumber
            mov rax,TM_JD1
            mov rdx,0AEC33E1F671529A5h
            mul rdx
            shr rdx,0Ch
            mov MM_JD1, rdx
            
            ; Div by 6000 using magicnumber
            mov rax,TM_JD2
            mov rdx,0AEC33E1F671529A5h
            mul rdx
            shr rdx,0Ch
            mov MM_JD2, rdx

            mov rax, MM_JD1
            mov rbx, MM_JD2
            sub rax, rbx   
            
        .ELSEIF DateFormat == CCYYMMDDHHMMSS
            ; Div by 1000 using magicnumber
            mov rax,TM_JD1
            mov rdx,083126E978D4FDF3Bh
            add rax,1
            .if !CARRY?
                mul rdx
            .endif
            shr rdx,09h
            mov SS_JD1, rdx
            
            ; Div by 1000 using magicnumber
            mov rax,TM_JD2
            mov rdx,083126E978D4FDF3Bh
            add rax,1
            .if !CARRY?
                mul rdx
            .endif
            shr rdx,09h
            mov SS_JD2, rdx

            mov rax, SS_JD1
            mov rbx, SS_JD2
            sub rax, rbx
              
        .ELSEIF DateFormat == CCYYMMDDHHMMSSMS
            mov rax,TM_JD1
            mov rbx,TM_JD2
            sub rax, rbx
        .ENDIF
        mov rdx, rax
        xor rax, rax
    .ENDIF
    
    ret
DTDateTimeStringsDifference ENDP





END