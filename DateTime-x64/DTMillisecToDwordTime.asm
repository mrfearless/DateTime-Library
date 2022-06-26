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

includelib kernel32.lib

include DateTime.inc


.CODE

DATETIME_ALIGN
;------------------------------------------------------------------------------
; DTMillisecToQwordTime
; 
; Converts total milliseconds to a QWORD value containing time information in 
; hours, minutes, seconds and milliseconds.
; 
; Parameters:
; 
; * Milliseconds - A QWORD value containting the total milliseconds to convert 
;   to hours, minutes, seconds and milliseconds in QWORD time in RAX.
;
; Returns:
;
; On return RAX will contain the time information in the following format
;
; +--------------------------------------------------+------------+------------+-----------+-----------+
; | DWORD                                            | BYTE       | BYTE       | BYTE      | BYTE      |
; +--------------------------------------------------+------------+------------+-----------+-----------+
; | Bits 63-32                                       | Bits 31-23 | Bits 23-16 | Bits 15-8 | Bits 7-0  |
; +--------------------------------------------------+------------+------------+-----------+-----------+
; | Not used - Not applicable                        | Hour       | Minute     | Second    | Millisec  |
; +--------------------------------------------------+------------+------------+-----------+-----------+
; | N/A                                              | HH         | MM         | SS        | MS        |
; +--------------------------------------------------+------------+------------+-----------+-----------+
;
;------------------------------------------------------------------------------
DTMillisecToQwordTime PROC USES RBX RCX RDX Milliseconds:QWORD
    LOCAL _Days:DWORD
    LOCAL _Hours:DWORD
    LOCAL _Minutes:DWORD
    LOCAL _Seconds:DWORD
    
    xor rbx, rbx
    xor rcx, rcx
    xor rdx, rdx
    
    mov rax, Milliseconds; eax-> time in miliseconds
    mov ecx, 31B5D4h     ; 2^48 / 86400000
    mul ecx              ; high 16 bits of edx = days, dx:eax = fractional days(hours,mins,sec)
    mov ecx, edx         ; high 16 bits of ecx-> days
    shr ecx, 16          ; edx-> days
    mov _Days, ecx       ; saving days
    and edx, 0FFFFh      ; edx-> fractional days
    mov ebx, eax         ;
    mov ecx, edx         ;
    add eax, eax         ;
    adc edx, edx         ;
    add eax, ebx         ;
    adc edx, ecx         ;
    shrd eax, edx, 13    ;
    shr edx, 13          ; edx = hours, eax = fractions(min,sec)
    mov ebx, eax         ;
    shr ebx, 4           ;     
    mov _Hours, edx      ; saving hours
    sub eax, ebx         ;
    mov ebx, eax         ;
    and eax, 03FFFFFFh   ; eax-> low 26 bits;(min:sec)
    shr ebx, 26          ;
    mov edx, eax         ;       
    shr edx, 4           ;
    mov _Minutes, ebx    ; saving minutes
    sub eax, edx         ;         
    shr eax, 20          ; 
    mov _Seconds, eax    ; saving seconds

    xor rax, rax
    mov ebx, _Hours
    mov ah, bl
    mov ebx, _Minutes
    mov al, bl
    shl eax, 16
    mov ebx, _Seconds
    mov ah, bl
    mov al, 0   

    ret
DTMillisecToQwordTime ENDP





END