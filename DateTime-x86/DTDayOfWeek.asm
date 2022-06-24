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

;------------------------------------------------------------------------------
; isleapyear MACRO
;------------------------------------------------------------------------------
isleapyear MACRO year
    mov ecx, 100
    mov eax, year
    xor edx, edx
    div ecx
    .IF (edx)               ;; if not century year
        mov eax, year       ;; reload year
    .ENDIF
    and eax, 3
    
    mov eax, 1
    jz @F                   ;; if evenly divisible by 4
    xor eax, eax
    @@:

    EXITM <eax>
ENDM

.CODE

DATETIME_ALIGN
;------------------------------------------------------------------------------
; DTDayOfWeek 
;
; Returns an integer indicating the day of the week from a date & time string
; 
; Parameters:
;
; * lpszDateTimeString - Pointer to a buffer containing the date & time string 
;   to check the day of the week for. The format of the date & time string is 
;   determined by the DateFormat parameter.
;
; * DateFormat - Value indicating the date & time format used in the buffer 
;   pointed to by lpszDateTimeString parameter. The parameter can contain one 
;   of the constants as defined in the DateTime.inc
;
; Returns:
;
; On return EAX will contain a value to indicate the following day:
;
; Mon   0   Aug
; Tue   1   Feb, Mar, Nov
; Wed   2   Jun
; Thu   3   Sep, Dec
; Fri   4   Apr, Jul
; Sat   5   Jan, Oct
; Sun   6   May 
;
;------------------------------------------------------------------------------
DTDayOfWeek PROC USES EBX ECX EDX lpszDateTimeString:DWORD, DateFormat:DWORD
    LOCAL Date:DWORD
    LOCAL CentYear:DWORD
    LOCAL Century:BYTE
    LOCAL Year:BYTE
    LOCAL Month:BYTE
    LOCAL Day:BYTE
    
    Invoke DTDateTimeStringToDwordDateTime, lpszDateTimeString, DateFormat
    mov Date, eax
    
    mov edx, Date
    mov Day, dl
    mov Month, dh
    
    mov edx, Date
    shr edx,16
    mov CentYear, edx
    mov Year, dl
    mov Century, dh
    
    ; ( DayOfMonth + MonthCode + Year + Year/4 – 2×(Century%4) – isLeapJanFeb ) % 7
    
    ; DayOfMonth
    xor ebx, ebx
    mov bl, Day
    ; JFM AMJ JAS OND 
    ; 511 462 403 513
    ; + MonthCode   
    .IF Month == 1 ; jan
        mov eax, 5
    .ELSEIF Month == 2
        mov eax, 1
    .ELSEIF Month == 3  
        mov eax, 1
    .ELSEIF Month == 4
        mov eax, 4
    .ELSEIF Month == 5  
        mov eax, 6
    .ELSEIF Month == 6
        mov eax, 2
    .ELSEIF Month == 7
        mov eax, 4  
    .ELSEIF Month == 8
        mov eax, 0
    .ELSEIF Month == 9
        mov eax, 3  
    .ELSEIF Month == 10
        mov eax, 5
    .ELSEIF Month == 11
        mov eax, 1
    .ELSEIF Month == 12
        mov eax, 3
    .ENDIF
    add ebx, eax
        
    ; + Year
    xor edx, edx
    xor eax, eax
    mov al, Year
    add ebx, eax
    ; + (Year/4)
    xor ecx, ecx
    mov ecx, 4
    xor eax, eax
    mov al, Year
    xor edx, edx
    div ecx
    ;  'Year/4+5'
    add ebx, 5
    add ebx, eax
    ; – 2×(Century%4)
    xor eax, eax
    mov al, Century
    mov ecx,4
    xor edx,edx
    div ecx  
    mov eax, edx
    ; 'Century%4'
    xor ecx, ecx
    xor edx, edx
    mov ecx, 2
    mul ecx ; result in eax
    ; '2*Century%4'
    sub ebx, eax

    ; - isLeapJanFeb
    .IF isleapyear(CentYear)
        .IF Month == 1 || Month == 2
            mov eax, 1
        .ELSE
            mov eax, 0
        .ENDIF
    .ELSE
        mov eax, 0
    .ENDIF
    add ebx, eax
    ; result in ebx
    mov eax,ebx
    mov ecx,7
    xor edx,edx
    div ecx  
    mov eax, edx
    ;_mod(ebx,7)
    
    ret
DTDayOfWeek ENDP

END