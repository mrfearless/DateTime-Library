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


.CODE

DATETIME_ALIGN
;------------------------------------------------------------------------------
; DTQwordTimeToMillisec
;
; Converts a QWORD value containing time information to total amount of 
; milliseconds
;
;
; Parameters:
;
; * qwTime - QWORD value containing time information to convert to total amount 
;   of milliseconds.
;
;   The format for the value containing the time information is as follows:
;
;   +--------------------------------------------------+------------+------------+-----------+-----------+
;   | DWORD                                            | BYTE       | BYTE       | BYTE      | BYTE      |
;   +--------------------------------------------------+------------+------------+-----------+-----------+
;   | Bits 63-32                                       | Bits 31-23 | Bits 23-16 | Bits 15-8 | Bits 7-0  |
;   +--------------------------------------------------+------------+------------+-----------+-----------+
;   | Not used - Not applicable                        | Hour       | Minute     | Second    | Millisec  |
;   +--------------------------------------------------+------------+------------+-----------+-----------+
;   | N/A                                              | HH         | MM         | SS        | MS        |
;   +--------------------------------------------------+------------+------------+-----------+-----------+
;
; Returns:
;
; On return RAX will contain the total milliseconds
;
;------------------------------------------------------------------------------
DTQwordTimeToMillisec PROC FRAME USES RCX RDX qwTime:QWORD
    LOCAL _Hours:QWORD
    LOCAL _Minutes:QWORD
    LOCAL _Seconds:QWORD
    LOCAL _Milliseconds:QWORD   
    LOCAL _TotalMilliseconds:QWORD
    
    .IF qwTime == 0
        mov rax, 0
        ret
    .ENDIF
    
    mov rdx, qwTime
    shr rdx,16              ; hours and minutes in ah and al now
    xor rax, rax
    mov al, dh
    mov _Hours, rax
    
    xor rax, rax
    mov al, dl
    mov _Minutes, rax
    
    mov rdx, qwTime
    xor rax, rax
    mov al, dh
    mov _Seconds, rax
    
    xor rax, rax
    mov al, dl
    mov _Milliseconds, rax  
    
    mov rax, _Hours
    mov rcx, 3600000
    xor rdx, rdx
    mul rcx
    mov _TotalMilliseconds, rax
    
    mov rax, _Minutes
    mov rcx, 60000 
    xor rdx, rdx
    mul rcx
    add _TotalMilliseconds, rax
    
    mov rax, _Seconds
    mov rcx, 1000
    xor rdx, rdx
    mul rcx
    add _TotalMilliseconds, rax
     
    mov rax, _Milliseconds
    add _TotalMilliseconds, rax
    mov rax, _TotalMilliseconds
    
    ret
DTQwordTimeToMillisec ENDP





END