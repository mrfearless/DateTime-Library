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

include Masm64.Inc
includelib Masm64.lib

include DateTime.inc

_DTStripDateTimeString PROTO lpszDateTimeString:QWORD, lpszStrippedString:QWORD

.CODE

DATETIME_ALIGN
;------------------------------------------------------------------------------
; Strips a datetime string of all '/', ':' and space characters - #INTERNAL#
;------------------------------------------------------------------------------
_DTStripDateTimeString PROC FRAME USES RDI RSI lpszDateTimeString:QWORD, lpszStrippedString:QWORD
    mov rsi, lpszDateTimeString
    mov rdi, lpszStrippedString ; rdi will point to somewhere to store the next output byte
    .WHILE byte ptr [rsi] != 0 ; while not null character, loop
        movzx rax, byte ptr [esi]
        .IF al == "/" || al == ":" || al == " "
            inc rsi
        .ELSE
            mov byte ptr [rdi], al
            inc rdi
            inc rsi
        .ENDIF
    .ENDW
    mov byte ptr [rdi],0 ; write the zero terminator
    
    ret
_DTStripDateTimeString ENDP

DATETIME_ALIGN
;------------------------------------------------------------------------------
; DTDateTimeStringToQwordDateTime
; 
; Converts a formatted date & time string to QWORD values. On return RAX 
; contains the date information and RDX the time information.
;
; Parameters:
;
; * lpszDateTimeString - Pointer to a buffer containing the date & time string 
;   to convert to QWORD values. The format of the date & time string is 
;   determined by the DateFormat parameter.
;
; * DateFormat - Value indicating the date & time format used in the buffer 
;   pointed to by lpszDateTimeString parameter. The parameter can contain one of 
;   the constants as defined in the DateTime.inc
;
; Returns:
;
; On return RAX will contain the date information in the following format:
;
; +--------------------------------------------------+------------------------+------------+-----------+
; | DWORD                                            | WORD                   | BYTE       | BYTE      |
; +--------------------------------------------------+------------------------+------------+-----------+
; | Bits 63-32                                       | Bits 31-16             | Bits 15-8  | Bits 7-0  |
; +--------------------------------------------------+------------------------+------------+-----------+
; | Not used - Not applicable                        | Century Year           | Month      | Day       |
; +--------------------------------------------------+------------------------+------------+-----------+
; | N/A                                              | CCCCYY                 | MM         | DD        |
; +--------------------------------------------------+------------------------+------------+-----------+
;
; On return RDX will contain the time information in the following format
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
; Notes: 
;
; The registers always return the information in the format shown in the tables
; above, and do not change regardless of the DateFormat parameter.
;
; The DateFormat parameter is used to indicate the format of the date & time 
; string being passed to DTDateTimeStringToQwordDateTime.
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
DTDateTimeStringToQwordDateTime PROC FRAME USES RBX RCX lpszDateTimeString:QWORD, DateFormat:QWORD
    LOCAL cDateTime[DATETIME_STRING]:BYTE
    LOCAL cCentYear[6]:BYTE
    LOCAL cCentury[4]:BYTE          
    LOCAL cYear[4]:BYTE             
    LOCAL cMonth[4]:BYTE            
    LOCAL cDay[4]:BYTE              
    LOCAL cHour[4]:BYTE             
    LOCAL cMinute[4]:BYTE           
    LOCAL cSecond[4]:BYTE           
    LOCAL cMillisec[4]:BYTE         
    
    LOCAL qwCentYear:QWORD
    LOCAL qwCentury:QWORD
    LOCAL qwYear:QWORD
    LOCAL qwMonth:QWORD
    LOCAL qwDay:QWORD
    LOCAL qwHour:QWORD
    LOCAL qwMinute:QWORD
    LOCAL qwSecond:QWORD
    LOCAL qwMillisec:QWORD
    
    LOCAL ReturnDate:QWORD
    LOCAL ReturnTime:QWORD
    
    .IF lpszDateTimeString == NULL || DateFormat == NULL
        mov rax, 0
        mov rdx, 0
        ret
    .ENDIF
    
    Invoke _DTStripDateTimeString, lpszDateTimeString, Addr cDateTime
    
    Invoke lstrlen, lpszDateTimeString
    .IF rax == 0
        mov rax, 0
        mov rdx, 0
        ret
    .ENDIF
    
    .IF (DateFormat == CCYYMMDDHHMMSSMS) || (DateFormat == CCYYMMDDHHMMSS) || (DateFormat == CCYYMMDDHHMM) || (DateFormat == CCYYMMDDHH) || (DateFormat == CCYYMMDD) || (DateFormat == CCYYMM) || (DateFormat == YEAR)
        
        ; Year
        lea rbx, cDateTime
        Invoke lstrcpyn, Addr cCentury, rbx, 3
        Invoke atoqw, Addr cCentury
        mov qwCentury, rax      
                
        lea rbx, cDateTime
        Invoke lstrcpyn, Addr cCentYear, rbx, 5     
        Invoke atoqw, Addr cCentYear
        mov qwCentYear, rax
        
        xor rax, rax
        mov rax, qwCentYear
        shl rax, 16
        mov ReturnDate, rax     
        xor rdx, rdx
        .IF DateFormat == YEAR
            ret
        .ENDIF
        
        ; CCYYMM
        lea rbx, cDateTime
        add rbx, 2
        Invoke lstrcpyn, Addr cYear, rbx, 3
        Invoke atoqw, Addr cYear
        mov qwYear, rax
        lea rbx, cDateTime      
        add rbx, 4
        Invoke lstrcpyn, Addr cMonth, rbx, 3    
        Invoke atoqw, Addr cMonth
        mov qwMonth, rax
        
        mov rax, ReturnDate         
        xor rcx, rcx
        mov rcx, qwMonth
        mov ah, cl
        mov ReturnDate, rax
        xor rdx, rdx
        .IF DateFormat == CCYYMM
            ret
        .ENDIF
        
        ; CCYYMMDD
        lea rbx, cDateTime
        add rbx, 6
        Invoke lstrcpyn, Addr cDay, rbx, 3
        Invoke atoqw, Addr cDay
        mov qwDay, rax      
        
        mov rax, ReturnDate         
        xor rcx, rcx
        mov rcx, qwDay
        mov al, cl
        mov ReturnDate, rax
        xor rdx, rdx
        .IF DateFormat == CCYYMMDD
            ret
        .ENDIF

        ; CCYYMMDDHH
        lea rbx, cDateTime
        add rbx, 8d
        Invoke lstrcpyn, Addr cHour, rbx, 3
        Invoke atoqw, Addr cHour
        mov qwHour, rax         

        mov rax, ReturnDate
        mov rdx, qwHour
        shl rdx, 24 ; move to high word     
        mov rax, ReturnDate
        mov ReturnTime, rdx     
        .IF DateFormat == CCYYMMDDHH
            ret
        .ENDIF  
        
        ; CCYYMMDDHHMM
        lea rbx, cDateTime
        add rbx, 8d
        Invoke lstrcpyn, Addr cHour, rbx, 3
        Invoke atoqw, Addr cHour
        mov qwHour, rax         
        lea rbx, cDateTime
        add rbx, 10d
        Invoke lstrcpyn, Addr cMinute, rbx, 3
        Invoke atoqw, Addr cMinute
        mov qwMinute, rax       
        
        mov rax, ReturnDate
        mov rdx, qwHour
        mov dh, dl
        xor rcx, rcx
        mov rcx, qwMinute
        mov dl, cl
        shl rdx, 16 ; move to high word     
        mov rax, ReturnDate
        mov ReturnTime, rdx     
        .IF DateFormat == CCYYMMDDHHMM
            ret
        .ENDIF      
            
        ; CCYYMMDDHHMMSS
        lea rbx, cDateTime
        add rbx, 12d                
        Invoke lstrcpyn, Addr cSecond, rbx, 3
        Invoke atoqw, Addr cSecond
        mov qwSecond, rax               
        
        mov rax, ReturnDate
        mov rdx, ReturnTime     
        xor rcx, rcx
        mov rcx, qwSecond
        mov dh, cl
        mov rax, ReturnDate
        mov ReturnTime, rdx
        .IF DateFormat == CCYYMMDDHHMMSS
            ret
        .ENDIF      

        ; CCYYMMDDHHMMSSMS
        lea rbx, cDateTime
        add rbx, 14d
        Invoke lstrcpyn, Addr cMillisec, rbx, 3
        Invoke atoqw, Addr cMillisec
        mov qwMillisec, rax 
        
        mov rax, ReturnDate
        mov rdx, ReturnTime
        xor rcx, rcx
        mov rcx, qwMillisec
        mov dl, cl
        mov ReturnTime, rdx
        ret             

    .ELSEIF (DateFormat == DDMMCCYYHHMMSSMS) || (DateFormat == DDMMCCYYHHMMSS) || (DateFormat == DDMMCCYYHHMM) || (DateFormat == DDMMCCYY) || (DateFormat == DDMMYY) || (DateFormat == DDMM) || (DateFormat == DAY)
    
        ; DAY
        lea rbx, cDateTime
        Invoke lstrcpyn, Addr cDay, rbx, 3
        Invoke atoqw, Addr cDay
        mov qwDay, rax      
                
        xor rax, rax
        mov rax, qwDay
        mov ReturnDate, rax     
        xor rdx, rdx
        .IF DateFormat == DAY
            ret
        .ENDIF

        ; DDMM
        lea rbx, cDateTime
        add rbx, 2
        Invoke lstrcpyn, Addr cMonth, rbx, 3
        Invoke atoqw, Addr cMonth
        mov qwMonth, rax
                
        mov rax, ReturnDate
        xor rcx, rcx
        mov rcx, qwMonth
        mov ah, cl
        mov ReturnDate, rax
        xor rdx, rdx
        .IF DateFormat == DDMM
            ret
        .ENDIF      
        
        ;DDMMYY
        lea rbx, cDateTime
        add rbx, 4      
        Invoke lstrcpyn, Addr cCentury, rbx, 3
        Invoke atoqw, Addr cCentury
        mov qwCentury, rax
        lea rbx, cDateTime
        add rbx, 4      
        Invoke lstrcpyn, Addr cCentYear, rbx, 5
        Invoke atoqw, Addr cCentYear
        mov qwCentYear, rax
                
        lea rbx, cDateTime
        add rbx, 6      
        Invoke lstrcpyn, Addr cYear, rbx, 3
        Invoke atoqw, Addr cYear
        mov qwYear, rax

        mov rax, ReturnDate
        xor rcx, rcx
        mov rcx, qwYear
        shl rcx, 16         ; move year to upper word
        mov cx, ax          ; move month and day to lower word
        mov rax, rcx
        mov ReturnDate, rax
        xor rdx, rdx
        .IF DateFormat == DDMMYY
            ret
        .ENDIF              
        
        ;DDMMCCYY
        mov rax, ReturnDate
        xor rcx, rcx
        mov rcx, qwCentYear
        shl rcx, 16         ; move year to upper word
        mov cx, ax          ; move month and day to lower word
        mov rax, rcx
        mov ReturnDate, rax
        xor rdx, rdx
        .IF DateFormat == DDMMCCYY
            ret
        .ENDIF      
        
        ;DDMMCCYYHHMM
        lea rbx, cDateTime
        add rbx, 8d
        Invoke lstrcpyn, Addr cHour, rbx, 3
        Invoke atoqw, Addr cHour
        mov qwHour, rax 
        lea rbx, cDateTime
        add rbx, 10d
        Invoke lstrcpyn, Addr cMinute, rbx, 3
        Invoke atoqw, Addr cMinute
        mov qwMinute, rax       
        
        mov rax, ReturnDate
        mov rdx, qwHour
        mov dh, dl
        xor rcx, rcx
        mov rcx, qwMinute
        mov dl, cl
        shl rdx, 16 ; move to high word     
        mov rax, ReturnDate
        mov ReturnTime, rdx     
        .IF DateFormat == DDMMCCYYHHMM
            ret
        .ENDIF      
        
        ;DDMMCCYYHHMMSS
        lea rbx, cDateTime
        add rbx, 12d                
        Invoke lstrcpyn, Addr cSecond, rbx, 3
        Invoke atoqw, Addr cSecond
        mov qwSecond, rax               
        mov rax, ReturnDate
        mov rdx, ReturnTime             
        xor rcx, rcx
        mov rcx, qwSecond
        mov dh, cl
        mov rax, ReturnDate
        mov ReturnTime, rdx
        .IF DateFormat == DDMMCCYYHHMMSS
            ret
        .ENDIF              
        
        ;DDMMCCYYHHMMSSMS
        lea rbx, cDateTime
        add rbx, 14d
        Invoke lstrcpyn, Addr cMillisec, rbx, 3
        Invoke atoqw, Addr cMillisec
        mov qwMillisec, rax 
        mov rax, ReturnDate
        mov rdx, ReturnTime
        xor rcx, rcx
        mov rcx, qwMillisec
        mov dl, cl
        mov ReturnTime, rdx
        ret

    .ELSEIF (DateFormat == MMDDCCYYHHMMSSMS) || (DateFormat == MMDDCCYYHHMMSS) || (DateFormat == MMDDCCYYHHMM) || (DateFormat == MMDDCCYY) || (DateFormat == MMDDYY) || (DateFormat == MMDD) || (DateFormat == MONTH)

        ; MM
        lea rbx, cDateTime
        Invoke lstrcpyn, Addr cMonth, rbx, 3
        Invoke atoqw, Addr cMonth
        mov qwMonth, rax        

        xor rax, rax
        mov rax, qwMonth
        mov ah, al
        ;shl rax, 16
        mov ReturnDate, rax     
        xor rdx, rdx
        .IF DateFormat == MONTH
            ret
        .ENDIF

        ; MMDD
        lea rbx, cDateTime
        add rbx, 2
        Invoke lstrcpyn, Addr cDay, rbx, 3
        Invoke atoqw, Addr cDay
        mov qwDay, rax
        
        mov rax, ReturnDate
        ;mov rax, qwMonth       
        xor rcx, rcx
        mov rcx, qwDay
        ;mov ah, al
        mov al, cl
        ;shl rax, 16
        mov ReturnDate, rax
        xor rdx, rdx
        .IF DateFormat == MMDD
            ret
        .ENDIF      
        
        ;MMDDYY
        lea rbx, cDateTime
        add rbx, 4      
        Invoke lstrcpyn, Addr cCentury, rbx, 3
        Invoke atoqw, Addr cCentury
        mov qwCentury, rax
        lea rbx, cDateTime
        add rbx, 4      
        Invoke lstrcpyn, Addr cCentYear, rbx, 5
        Invoke atoqw, Addr cCentYear
        mov qwCentYear, rax
        lea rbx, cDateTime
        add rbx, 6      
        Invoke lstrcpyn, Addr cYear, rbx, 3
        Invoke atoqw, Addr cYear
        mov qwYear, rax

        mov rax, ReturnDate
        xor rcx, rcx
        mov rcx, qwYear
        shl rcx, 16         ; move year to uppper word
        mov cx, ax
        ;mov ah, cl
        mov rax, rcx
        mov ReturnDate, rax
        xor rdx, rdx
        .IF DateFormat == MMDDYY
            ret
        .ENDIF              
        
        ;MMDDCCYY
        mov rax, ReturnDate
        xor rcx, rcx
        mov rcx, qwCentYear
        shl rcx, 16         ; move year to uppper word
        mov cx, ax
        mov rax, rcx
        mov ReturnDate, rax
        xor rdx, rdx
        .IF DateFormat == MMDDCCYY
            ret
        .ENDIF      
        
        ;MMDDCCYYHHMM
        lea rbx, cDateTime
        add rbx, 8d
        Invoke lstrcpyn, Addr cHour, rbx, 3
        Invoke atoqw, Addr cHour
        mov qwHour, rax         
        lea rbx, cDateTime
        add rbx, 10d
        Invoke lstrcpyn, Addr cMinute, rbx, 3
        Invoke atoqw, Addr cMinute
        mov qwMinute, rax       
        
        mov rax, ReturnDate
        mov rdx, qwHour
        mov dh, dl
        xor rcx, rcx
        mov rcx, qwMinute
        mov dl, cl
        shl rdx, 16 ; move to high word     
        mov rax, ReturnDate
        mov ReturnTime, rdx     
        .IF DateFormat == MMDDCCYYHHMM
            ret
        .ENDIF      
        
        ;MMDDCCYYHHMMSS
        lea rbx, cDateTime
        add rbx, 12d                
        Invoke lstrcpyn, Addr cSecond, rbx, 3
        Invoke atoqw, Addr cSecond
        mov qwSecond, rax               
        
        mov rax, ReturnDate
        mov rdx, ReturnTime             
        xor rcx, rcx
        mov rcx, qwSecond
        mov dh, cl
        mov rax, ReturnDate
        mov ReturnTime, rdx
        .IF DateFormat == MMDDCCYYHHMMSS
            ret
        .ENDIF              
        
        ;MMDDCCYYHHMMSSMS
        lea rbx, cDateTime
        add rbx, 14d
        Invoke lstrcpyn, Addr cMillisec, rbx, 3
        Invoke atoqw, Addr cMillisec
        mov qwMillisec, rax 
        
        mov rax, ReturnDate
        mov rdx, ReturnTime
        xor rcx, rcx
        mov rcx, qwMillisec
        mov dl, cl
        mov ReturnTime, rdx
        ret     
        
    .ELSEIF (DateFormat == HHMM) || (DateFormat == HHMMSS) || (DateFormat == HHMMSSMS)
        
        ; HH
        mov ReturnDate, 0
        
        lea rbx, cDateTime
        Invoke lstrcpyn, Addr cHour, rbx, 3
        Invoke atoqw, Addr cHour
        mov qwHour, rax         

        xor rax, rax
        mov rax, qwHour
        mov ah, al
        shl rax, 16
        mov rax, ReturnDate
        mov ReturnTime, rdx     
        xor rdx, rdx
        .IF DateFormat == HH
            ret
        .ENDIF

        ; HHMM
        lea rbx, cDateTime
        add rbx, 2d
        Invoke lstrcpyn, Addr cMinute, rbx, 3
        Invoke atoqw, Addr cMinute
        mov qwMinute, rax       
        
        mov rdx, qwHour
        mov dh, dl
        xor rcx, rcx
        mov rcx, qwMinute
        mov dl, cl
        shl rdx, 16 ; move to high word     
        mov rax, ReturnDate
        mov ReturnTime, rdx 
        xor rdx, rdx
        .IF DateFormat == HHMM
            ret
        .ENDIF      
        
        ;HHMMSS
        lea rbx, cDateTime
        add rbx, 4d             
        Invoke lstrcpyn, Addr cSecond, rbx, 3
        Invoke atoqw, Addr cSecond
        mov qwSecond, rax               
        
        mov rdx, ReturnTime             
        xor rcx, rcx
        mov rcx, qwSecond
        mov dh, cl
        mov rax, ReturnDate
        mov ReturnTime, rdx
        .IF DateFormat == HHMMSS
            ret
        .ENDIF              
        
        ;HHMMSSMS
        lea rbx, cDateTime
        add rbx, 6d
        Invoke lstrcpyn, Addr cMillisec, rbx, 3
        Invoke atoqw, Addr cMillisec
        mov qwMillisec, rax 

        mov rdx, ReturnTime
        xor rcx, rcx
        mov rcx, qwMillisec
        mov dl, cl
        mov rax, ReturnDate     
        mov ReturnTime, rdx
        .IF DateFormat == HHMMSSMS
            ret
        .ENDIF              
        ret
    
    .ELSEIF (DateFormat == YY) || (DateFormat == YYMM) || (DateFormat == YYMMDD) || (DateFormat == YYMMDDHHMM) || (DateFormat == YYMMDDHHMMSS) || (DateFormat == YYMMDDHHMMSSMS)
    
        ; YY
        lea rbx, cDateTime
        Invoke lstrcpyn, Addr cYear, rbx, 3     
        Invoke atoqw, Addr cYear
        mov qwYear, rax
        
        xor rcx, rcx
        mov rcx, qwYear
        mov ah, cl
        mov ReturnDate, rax
        xor rdx, rdx
        .IF DateFormat == YY
            ret
        .ENDIF
        
        ; YYMM
        lea rbx, cDateTime      
        add rbx, 2
        Invoke lstrcpyn, Addr cMonth, rbx, 3    
        Invoke atoqw, Addr cMonth
        mov qwMonth, rax
        
        mov rax, ReturnDate         
        xor rcx, rcx
        mov rcx, qwYear
        mov ah, cl
        xor rcx, rcx
        mov rcx, qwMonth
        mov al, cl
        mov ReturnDate, rax
        xor rdx, rdx
        .IF DateFormat == YYMM
            ret
        .ENDIF

        ; YYMMDD
        shl rax, 8              ; move year to top end of reg, month to ah
        mov ReturnDate, rax
        lea rbx, cDateTime
        add rbx, 4
        Invoke lstrcpyn, Addr cDay, rbx, 3
        Invoke atoqw, Addr cDay
        mov qwDay, rax      
        
        mov rax, ReturnDate         
        xor rcx, rcx
        mov rcx, qwDay
        mov al, cl
        mov ReturnDate, rax
        xor rdx, rdx
        .IF DateFormat == YYMMDD
            ret
        .ENDIF          


        ; YYMMDDHHMM
        lea rbx, cDateTime
        add rbx, 6d
        Invoke lstrcpyn, Addr cHour, rbx, 3
        Invoke atoqw, Addr cHour
        mov qwHour, rax         
        lea rbx, cDateTime
        add rbx, 8d
        Invoke lstrcpyn, Addr cMinute, rbx, 3
        Invoke atoqw, Addr cMinute
        mov qwMinute, rax       
        
        mov rax, ReturnDate
        mov rdx, qwHour
        mov dh, dl
        xor rcx, rcx
        mov rcx, qwMinute
        mov dl, cl
        shl rdx, 16 ; move to high word     
        mov rax, ReturnDate
        mov ReturnTime, rdx     
        .IF DateFormat == YYMMDDHHMM
            ret
        .ENDIF      
            
        ; YYMMDDHHMMSS
        lea rbx, cDateTime
        add rbx, 10d                
        Invoke lstrcpyn, Addr cSecond, rbx, 3
        Invoke atoqw, Addr cSecond
        mov qwSecond, rax               
        
        mov rax, ReturnDate
        mov rdx, ReturnTime     
        xor rcx, rcx
        mov rcx, qwSecond
        mov dh, cl
        mov rax, ReturnDate
        mov ReturnTime, rdx
        .IF DateFormat == YYMMDDHHMMSS
            ret
        .ENDIF      

        ; YYMMDDHHMMSSMS
        lea rbx, cDateTime
        add rbx, 12d
        Invoke lstrcpyn, Addr cMillisec, rbx, 3
        Invoke atoqw, Addr cMillisec
        mov qwMillisec, rax 
        
        mov rax, ReturnDate
        mov rdx, ReturnTime
        xor rcx, rcx
        mov rcx, qwMillisec
        mov dl, cl
        mov ReturnTime, rdx
    .ENDIF
    
    ret
DTDateTimeStringToQwordDateTime ENDP



END