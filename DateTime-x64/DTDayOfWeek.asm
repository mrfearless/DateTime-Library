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

;------------------------------------------------------------------------------
; isleapyear MACRO
;------------------------------------------------------------------------------
isleapyear MACRO year
    mov rcx, 100
    mov rax, year
    xor rdx, rdx
    div rcx
    .IF (rdx)               ;; if not century year
        mov rax, year       ;; reload year
    .ENDIF
    and rax, 3
    
    mov rax, 1
    jz @F                   ;; if evenly divisible by 4
    xor rax, rax
    @@:

    EXITM <rax>
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
; On return RAX will contain a value to indicate the following day:
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
DTDayOfWeek PROC FRAME USES RBX RCX RDX lpszDateTimeString:QWORD, DateFormat:QWORD
    LOCAL Date:QWORD
    LOCAL CentYear:QWORD
    LOCAL Century:BYTE
    LOCAL Year:BYTE
    LOCAL Month:BYTE
    LOCAL Day:BYTE
    
    Invoke DTDateTimeStringToQwordDateTime, lpszDateTimeString, DateFormat
    mov Date, rax
    
    mov rdx, Date
    mov Day, dl
    mov Month, dh
    
    mov rdx, Date
    shr rdx,16
    mov CentYear, rdx
    mov Year, dl
    mov Century, dh
    
    ; ( DayOfMonth + MonthCode + Year + Year/4 – 2×(Century%4) – isLeapJanFeb ) % 7
    
    ; DayOfMonth
    xor rbx, rbx
    mov bl, Day
    ; JFM AMJ JAS OND 
    ; 511 462 403 513
    ; + MonthCode   
    .IF Month == 1 ; jan
        mov rax, 5
    .ELSEIF Month == 2
        mov rax, 1
    .ELSEIF Month == 3  
        mov rax, 1
    .ELSEIF Month == 4
        mov rax, 4
    .ELSEIF Month == 5  
        mov rax, 6
    .ELSEIF Month == 6
        mov rax, 2
    .ELSEIF Month == 7
        mov rax, 4  
    .ELSEIF Month == 8
        mov rax, 0
    .ELSEIF Month == 9
        mov rax, 3  
    .ELSEIF Month == 10
        mov rax, 5
    .ELSEIF Month == 11
        mov rax, 1
    .ELSEIF Month == 12
        mov rax, 3
    .ENDIF
    add rbx, rax
        
    ; + Year
    xor rdx, rdx
    xor rax, rax
    mov al, Year
    add rbx, rax
    ; + (Year/4)
    xor rcx, rcx
    mov rcx, 4
    xor rax, rax
    mov al, Year
    xor rdx, rdx
    div rcx
    ;  'Year/4+5'
    add rbx, 5
    add rbx, rax
    ; – 2×(Century%4)
    xor rax, rax
    mov al, Century
    mov rcx,4
    xor rdx,rdx
    div rcx  
    mov rax, rdx
    ; 'Century%4'
    xor rcx, rcx
    xor rdx, rdx
    mov rcx, 2
    mul rcx ; result in eax
    ; '2*Century%4'
    sub rbx, rax

    ; - isLeapJanFeb
    .IF isleapyear(CentYear)
        .IF Month == 1 || Month == 2
            mov rax, 1
        .ELSE
            mov rax, 0
        .ENDIF
    .ELSE
        mov rax, 0
    .ENDIF
    add rbx, rax
    ; result in ebx
    mov rax,rbx
    mov rcx,7
    xor rdx,rdx
    div rcx  
    mov rax, rdx
    ;_mod(ebx,7)
    
    ret
DTDayOfWeek ENDP





END