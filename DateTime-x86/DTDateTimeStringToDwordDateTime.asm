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

include windows.inc

include kernel32.inc
includelib kernel32.lib

include masm32.inc
includelib masm32.lib

include DateTime.inc

_DTStripDateTimeString PROTO lpszDateTimeString:DWORD, lpszStrippedString:DWORD

EXTERN DTDwordDateToJulianDate :PROTO dwDate:DWORD
EXTERN DTDwordTimeToMillisec :PROTO dwTime:DWORD

.CODE

DATETIME_ALIGN
;------------------------------------------------------------------------------
; Strips a datetime string of all '/', ':' and space characters - #INTERNAL#
;------------------------------------------------------------------------------
_DTStripDateTimeString PROC USES EDI ESI lpszDateTimeString:DWORD, lpszStrippedString:DWORD
    mov esi, lpszDateTimeString
    mov edi, lpszStrippedString ; edi will point to somewhere to store the next output byte
    .WHILE byte ptr [esi] != 0 ; while not null character, loop
        movzx eax, byte ptr [esi]
        .IF al == "/" || al == ":" || al == " "
            inc esi
        .ELSE
            mov byte ptr [edi], al
            inc edi
            inc esi
        .ENDIF
    .ENDW
    mov byte ptr [edi],0 ; write the zero terminator
    
    ret
_DTStripDateTimeString ENDP

DATETIME_ALIGN
;------------------------------------------------------------------------------
; DTDateTimeStringToDwordDateTime
; 
; Converts a formatted date & time string to DWORD values. On return EAX 
; contains the date information and EDX the time information.
;
; Parameters:
;
; * lpszDateTimeString - Pointer to a buffer containing the date & time string 
;   to convert to DWORD values. The format of the date & time string is 
;   determined by the DateFormat parameter.
;
; * DateFormat - Value indicating the date & time format used in the buffer 
;   pointed to by lpszDateTimeString parameter. The parameter can contain one of 
;   the constants as defined in the DateTime.inc
;
; Returns:
;
; On return EAX will contain the date information in the following format:
;
; +------------------------+------------+-----------+
; | WORD                   | BYTE       | BYTE      |
; +------------------------+------------+-----------+
; | Bits 31-16             | Bits 15-8  | Bits 7-0  |
; +------------------------+------------+-----------+
; | Century Year           | Month      | Day       |
; +------------------------+------------+-----------+
; | CCCCYY                 | MM         | DD        |
; +------------------------+------------+-----------+
;
; On return EDX will contain the time information in the following format
; 
; +------------+------------+-----------+-----------+
; | BYTE       | BYTE       | BYTE      | BYTE      |
; +------------+------------+-----------+-----------+
; | Bits 31-23 | Bits 23-16 | Bits 15-8 | Bits 7-0  |
; +------------+------------+-----------+-----------+
; | Hour       | Minute     | Second    | Millisec  |
; +------------+------------+-----------+-----------+
; | HH         | MM         | SS        | MS        |
; +------------+------------+-----------+-----------+
;
; Notes: 
;
; The registers always return the information in the format shown in the tables
; above, and do not change regardless of the DateFormat parameter.
;
; The DateFormat parameter is used to indicate the format of the date & time 
; string being passed to DTDateTimeStringToDwordDateTime.
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
DTDateTimeStringToDwordDateTime PROC USES EBX ECX lpszDateTimeString:DWORD, DateFormat:DWORD
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
    
    LOCAL dwCentYear:DWORD
    LOCAL dwCentury:DWORD
    LOCAL dwYear:DWORD
    LOCAL dwMonth:DWORD
    LOCAL dwDay:DWORD
    LOCAL dwHour:DWORD
    LOCAL dwMinute:DWORD
    LOCAL dwSecond:DWORD
    LOCAL dwMillisec:DWORD
    
    LOCAL ReturnDate:DWORD
    LOCAL ReturnTime:DWORD
    
    .IF lpszDateTimeString == NULL || DateFormat == NULL
        mov eax, 0
        mov edx, 0
        ret
    .ENDIF
    
    Invoke _DTStripDateTimeString, lpszDateTimeString, Addr cDateTime
    
    Invoke lstrlen, lpszDateTimeString
    .IF eax == 0
        mov eax, 0
        mov edx, 0
        ret
    .ENDIF
    
    .IF (DateFormat == CCYYMMDDHHMMSSMS) || (DateFormat == CCYYMMDDHHMMSS) || (DateFormat == CCYYMMDDHHMM) || (DateFormat == CCYYMMDDHH) || (DateFormat == CCYYMMDD) || (DateFormat == CCYYMM) || (DateFormat == YEAR)
        
        ; Year
        lea ebx, cDateTime
        Invoke lstrcpyn, Addr cCentury, ebx, 3
        Invoke atodw, Addr cCentury
        mov dwCentury, eax      
                
        lea ebx, cDateTime
        Invoke lstrcpyn, Addr cCentYear, ebx, 5     
        Invoke atodw, Addr cCentYear
        mov dwCentYear, eax
        
        xor eax, eax
        mov eax, dwCentYear
        shl eax, 16
        mov ReturnDate, eax     
        xor edx, edx
        .IF DateFormat == YEAR
            ret
        .ENDIF
        
        ; CCYYMM
        lea ebx, cDateTime
        add ebx, 2
        Invoke lstrcpyn, Addr cYear, ebx, 3
        Invoke atodw, Addr cYear
        mov dwYear, eax
        lea ebx, cDateTime      
        add ebx, 4
        Invoke lstrcpyn, Addr cMonth, ebx, 3    
        Invoke atodw, Addr cMonth
        mov dwMonth, eax
        
        mov eax, ReturnDate         
        xor ecx, ecx
        mov ecx, dwMonth
        mov ah, cl
        mov ReturnDate, eax
        xor edx, edx
        .IF DateFormat == CCYYMM
            ret
        .ENDIF
        
        ; CCYYMMDD
        lea ebx, cDateTime
        add ebx, 6
        Invoke lstrcpyn, Addr cDay, ebx, 3
        Invoke atodw, Addr cDay
        mov dwDay, eax      
        
        mov eax, ReturnDate         
        xor ecx, ecx
        mov ecx, dwDay
        mov al, cl
        mov ReturnDate, eax
        xor edx, edx
        .IF DateFormat == CCYYMMDD
            ret
        .ENDIF

        ; CCYYMMDDHH
        lea ebx, cDateTime
        add ebx, 8d
        Invoke lstrcpyn, Addr cHour, ebx, 3
        Invoke atodw, Addr cHour
        mov dwHour, eax         

        mov eax, ReturnDate
        mov edx, dwHour
        shl edx, 24 ; move to high word     
        mov eax, ReturnDate
        mov ReturnTime, edx     
        .IF DateFormat == CCYYMMDDHH
            ret
        .ENDIF  
        
        ; CCYYMMDDHHMM
        lea ebx, cDateTime
        add ebx, 8d
        Invoke lstrcpyn, Addr cHour, ebx, 3
        Invoke atodw, Addr cHour
        mov dwHour, eax         
        lea ebx, cDateTime
        add ebx, 10d
        Invoke lstrcpyn, Addr cMinute, ebx, 3
        Invoke atodw, Addr cMinute
        mov dwMinute, eax       
        
        mov eax, ReturnDate
        mov edx, dwHour
        mov dh, dl
        xor ecx, ecx
        mov ecx, dwMinute
        mov dl, cl
        shl edx, 16 ; move to high word     
        mov eax, ReturnDate
        mov ReturnTime, edx     
        .IF DateFormat == CCYYMMDDHHMM
            ret
        .ENDIF      
            
        ; CCYYMMDDHHMMSS
        lea ebx, cDateTime
        add ebx, 12d                
        Invoke lstrcpyn, Addr cSecond, ebx, 3
        Invoke atodw, Addr cSecond
        mov dwSecond, eax               
        
        mov eax, ReturnDate
        mov edx, ReturnTime     
        xor ecx, ecx
        mov ecx, dwSecond
        mov dh, cl
        mov eax, ReturnDate
        mov ReturnTime, edx
        .IF DateFormat == CCYYMMDDHHMMSS
            ret
        .ENDIF      

        ; CCYYMMDDHHMMSSMS
        lea ebx, cDateTime
        add ebx, 14d
        Invoke lstrcpyn, Addr cMillisec, ebx, 3
        Invoke atodw, Addr cMillisec
        mov dwMillisec, eax 
        
        mov eax, ReturnDate
        mov edx, ReturnTime
        xor ecx, ecx
        mov ecx, dwMillisec
        mov dl, cl
        mov ReturnTime, edx
        ret             

    .ELSEIF (DateFormat == DDMMCCYYHHMMSSMS) || (DateFormat == DDMMCCYYHHMMSS) || (DateFormat == DDMMCCYYHHMM) || (DateFormat == DDMMCCYY) || (DateFormat == DDMMYY) || (DateFormat == DDMM) || (DateFormat == DAY)
    
        ; DAY
        lea ebx, cDateTime
        Invoke lstrcpyn, Addr cDay, ebx, 3
        Invoke atodw, Addr cDay
        mov dwDay, eax      
                
        xor eax, eax
        mov eax, dwDay
        mov ReturnDate, eax     
        xor edx, edx
        .IF DateFormat == DAY
            ret
        .ENDIF

        ; DDMM
        lea ebx, cDateTime
        add ebx, 2
        Invoke lstrcpyn, Addr cMonth, ebx, 3
        Invoke atodw, Addr cMonth
        mov dwMonth, eax
                
        mov eax, ReturnDate
        xor ecx, ecx
        mov ecx, dwMonth
        mov ah, cl
        mov ReturnDate, eax
        xor edx, edx
        .IF DateFormat == DDMM
            ret
        .ENDIF      
        
        ;DDMMYY
        lea ebx, cDateTime
        add ebx, 4      
        Invoke lstrcpyn, Addr cCentury, ebx, 3
        Invoke atodw, Addr cCentury
        mov dwCentury, eax
        lea ebx, cDateTime
        add ebx, 4      
        Invoke lstrcpyn, Addr cCentYear, ebx, 5
        Invoke atodw, Addr cCentYear
        mov dwCentYear, eax
                
        lea ebx, cDateTime
        add ebx, 6      
        Invoke lstrcpyn, Addr cYear, ebx, 3
        Invoke atodw, Addr cYear
        mov dwYear, eax

        mov eax, ReturnDate
        xor ecx, ecx
        mov ecx, dwYear
        shl ecx, 16         ; move year to upper word
        mov cx, ax          ; move month and day to lower word
        mov eax, ecx
        mov ReturnDate, eax
        xor edx, edx
        .IF DateFormat == DDMMYY
            ret
        .ENDIF              
        
        ;DDMMCCYY
        mov eax, ReturnDate
        xor ecx, ecx
        mov ecx, dwCentYear
        shl ecx, 16         ; move year to upper word
        mov cx, ax          ; move month and day to lower word
        mov eax, ecx
        mov ReturnDate, eax
        xor edx, edx
        .IF DateFormat == DDMMCCYY
            ret
        .ENDIF      
        
        ;DDMMCCYYHHMM
        lea ebx, cDateTime
        add ebx, 8d
        Invoke lstrcpyn, Addr cHour, ebx, 3
        Invoke atodw, Addr cHour
        mov dwHour, eax 
        lea ebx, cDateTime
        add ebx, 10d
        Invoke lstrcpyn, Addr cMinute, ebx, 3
        Invoke atodw, Addr cMinute
        mov dwMinute, eax       
        
        mov eax, ReturnDate
        mov edx, dwHour
        mov dh, dl
        xor ecx, ecx
        mov ecx, dwMinute
        mov dl, cl
        shl edx, 16 ; move to high word     
        mov eax, ReturnDate
        mov ReturnTime, edx     
        .IF DateFormat == DDMMCCYYHHMM
            ret
        .ENDIF      
        
        ;DDMMCCYYHHMMSS
        lea ebx, cDateTime
        add ebx, 12d                
        Invoke lstrcpyn, Addr cSecond, ebx, 3
        Invoke atodw, Addr cSecond
        mov dwSecond, eax               
        mov eax, ReturnDate
        mov edx, ReturnTime             
        xor ecx, ecx
        mov ecx, dwSecond
        mov dh, cl
        mov eax, ReturnDate
        mov ReturnTime, edx
        .IF DateFormat == DDMMCCYYHHMMSS
            ret
        .ENDIF              
        
        ;DDMMCCYYHHMMSSMS
        lea ebx, cDateTime
        add ebx, 14d
        Invoke lstrcpyn, Addr cMillisec, ebx, 3
        Invoke atodw, Addr cMillisec
        mov dwMillisec, eax 
        mov eax, ReturnDate
        mov edx, ReturnTime
        xor ecx, ecx
        mov ecx, dwMillisec
        mov dl, cl
        mov ReturnTime, edx
        ret

    .ELSEIF (DateFormat == MMDDCCYYHHMMSSMS) || (DateFormat == MMDDCCYYHHMMSS) || (DateFormat == MMDDCCYYHHMM) || (DateFormat == MMDDCCYY) || (DateFormat == MMDDYY) || (DateFormat == MMDD) || (DateFormat == MONTH)

        ; MM
        lea ebx, cDateTime
        Invoke lstrcpyn, Addr cMonth, ebx, 3
        Invoke atodw, Addr cMonth
        mov dwMonth, eax        

        xor eax, eax
        mov eax, dwMonth
        mov ah, al
        ;shl eax, 16
        mov ReturnDate, eax     
        xor edx, edx
        .IF DateFormat == MONTH
            ret
        .ENDIF

        ; MMDD
        lea ebx, cDateTime
        add ebx, 2
        Invoke lstrcpyn, Addr cDay, ebx, 3
        Invoke atodw, Addr cDay
        mov dwDay, eax
        
        mov eax, ReturnDate
        ;mov eax, dwMonth       
        xor ecx, ecx
        mov ecx, dwDay
        ;mov ah, al
        mov al, cl
        ;shl eax, 16
        mov ReturnDate, eax
        xor edx, edx
        .IF DateFormat == MMDD
            ret
        .ENDIF      
        
        ;MMDDYY
        lea ebx, cDateTime
        add ebx, 4      
        Invoke lstrcpyn, Addr cCentury, ebx, 3
        Invoke atodw, Addr cCentury
        mov dwCentury, eax
        lea ebx, cDateTime
        add ebx, 4      
        Invoke lstrcpyn, Addr cCentYear, ebx, 5
        Invoke atodw, Addr cCentYear
        mov dwCentYear, eax
        lea ebx, cDateTime
        add ebx, 6      
        Invoke lstrcpyn, Addr cYear, ebx, 3
        Invoke atodw, Addr cYear
        mov dwYear, eax

        mov eax, ReturnDate
        xor ecx, ecx
        mov ecx, dwYear
        shl ecx, 16         ; move year to uppper word
        mov cx, ax
        ;mov ah, cl
        mov eax, ecx
        mov ReturnDate, eax
        xor edx, edx
        .IF DateFormat == MMDDYY
            ret
        .ENDIF              
        
        ;MMDDCCYY
        mov eax, ReturnDate
        xor ecx, ecx
        mov ecx, dwCentYear
        shl ecx, 16         ; move year to uppper word
        mov cx, ax
        mov eax, ecx
        mov ReturnDate, eax
        xor edx, edx
        .IF DateFormat == MMDDCCYY
            ret
        .ENDIF      
        
        ;MMDDCCYYHHMM
        lea ebx, cDateTime
        add ebx, 8d
        Invoke lstrcpyn, Addr cHour, ebx, 3
        Invoke atodw, Addr cHour
        mov dwHour, eax         
        lea ebx, cDateTime
        add ebx, 10d
        Invoke lstrcpyn, Addr cMinute, ebx, 3
        Invoke atodw, Addr cMinute
        mov dwMinute, eax       
        
        mov eax, ReturnDate
        mov edx, dwHour
        mov dh, dl
        xor ecx, ecx
        mov ecx, dwMinute
        mov dl, cl
        shl edx, 16 ; move to high word     
        mov eax, ReturnDate
        mov ReturnTime, edx     
        .IF DateFormat == MMDDCCYYHHMM
            ret
        .ENDIF      
        
        ;MMDDCCYYHHMMSS
        lea ebx, cDateTime
        add ebx, 12d                
        Invoke lstrcpyn, Addr cSecond, ebx, 3
        Invoke atodw, Addr cSecond
        mov dwSecond, eax               
        
        mov eax, ReturnDate
        mov edx, ReturnTime             
        xor ecx, ecx
        mov ecx, dwSecond
        mov dh, cl
        mov eax, ReturnDate
        mov ReturnTime, edx
        .IF DateFormat == MMDDCCYYHHMMSS
            ret
        .ENDIF              
        
        ;MMDDCCYYHHMMSSMS
        lea ebx, cDateTime
        add ebx, 14d
        Invoke lstrcpyn, Addr cMillisec, ebx, 3
        Invoke atodw, Addr cMillisec
        mov dwMillisec, eax 
        
        mov eax, ReturnDate
        mov edx, ReturnTime
        xor ecx, ecx
        mov ecx, dwMillisec
        mov dl, cl
        mov ReturnTime, edx
        ret     
        
    .ELSEIF (DateFormat == HHMM) || (DateFormat == HHMMSS) || (DateFormat == HHMMSSMS)
        
        ; HH
        mov ReturnDate, 0
        
        lea ebx, cDateTime
        Invoke lstrcpyn, Addr cHour, ebx, 3
        Invoke atodw, Addr cHour
        mov dwHour, eax         

        xor eax, eax
        mov eax, dwHour
        mov ah, al
        shl eax, 16
        mov eax, ReturnDate
        mov ReturnTime, edx     
        xor edx, edx
        .IF DateFormat == HH
            ret
        .ENDIF

        ; HHMM
        lea ebx, cDateTime
        add ebx, 2d
        Invoke lstrcpyn, Addr cMinute, ebx, 3
        Invoke atodw, Addr cMinute
        mov dwMinute, eax       
        
        mov edx, dwHour
        mov dh, dl
        xor ecx, ecx
        mov ecx, dwMinute
        mov dl, cl
        shl edx, 16 ; move to high word     
        mov eax, ReturnDate
        mov ReturnTime, edx 
        xor edx, edx
        .IF DateFormat == HHMM
            ret
        .ENDIF      
        
        ;HHMMSS
        lea ebx, cDateTime
        add ebx, 4d             
        Invoke lstrcpyn, Addr cSecond, ebx, 3
        Invoke atodw, Addr cSecond
        mov dwSecond, eax               
        
        mov edx, ReturnTime             
        xor ecx, ecx
        mov ecx, dwSecond
        mov dh, cl
        mov eax, ReturnDate
        mov ReturnTime, edx
        .IF DateFormat == HHMMSS
            ret
        .ENDIF              
        
        ;HHMMSSMS
        lea ebx, cDateTime
        add ebx, 6d
        Invoke lstrcpyn, Addr cMillisec, ebx, 3
        Invoke atodw, Addr cMillisec
        mov dwMillisec, eax 

        mov edx, ReturnTime
        xor ecx, ecx
        mov ecx, dwMillisec
        mov dl, cl
        mov eax, ReturnDate     
        mov ReturnTime, edx
        .IF DateFormat == HHMMSSMS
            ret
        .ENDIF              
        ret
    
    .ELSEIF (DateFormat == YY) || (DateFormat == YYMM) || (DateFormat == YYMMDD) || (DateFormat == YYMMDDHHMM) || (DateFormat == YYMMDDHHMMSS) || (DateFormat == YYMMDDHHMMSSMS)
    
        ; YY
        lea ebx, cDateTime
        Invoke lstrcpyn, Addr cYear, ebx, 3     
        Invoke atodw, Addr cYear
        mov dwYear, eax
        
        xor ecx, ecx
        mov ecx, dwYear
        mov ah, cl
        mov ReturnDate, eax
        xor edx, edx
        .IF DateFormat == YY
            ret
        .ENDIF
        
        ; YYMM
        lea ebx, cDateTime      
        add ebx, 2
        Invoke lstrcpyn, Addr cMonth, ebx, 3    
        Invoke atodw, Addr cMonth
        mov dwMonth, eax
        
        mov eax, ReturnDate         
        xor ecx, ecx
        mov ecx, dwYear
        mov ah, cl
        xor ecx, ecx
        mov ecx, dwMonth
        mov al, cl
        mov ReturnDate, eax
        xor edx, edx
        .IF DateFormat == YYMM
            ret
        .ENDIF

        ; YYMMDD
        shl eax, 8              ; move year to top end of reg, month to ah
        mov ReturnDate, eax
        lea ebx, cDateTime
        add ebx, 4
        Invoke lstrcpyn, Addr cDay, ebx, 3
        Invoke atodw, Addr cDay
        mov dwDay, eax      
        
        mov eax, ReturnDate         
        xor ecx, ecx
        mov ecx, dwDay
        mov al, cl
        mov ReturnDate, eax
        xor edx, edx
        .IF DateFormat == YYMMDD
            ret
        .ENDIF          


        ; YYMMDDHHMM
        lea ebx, cDateTime
        add ebx, 6d
        Invoke lstrcpyn, Addr cHour, ebx, 3
        Invoke atodw, Addr cHour
        mov dwHour, eax         
        lea ebx, cDateTime
        add ebx, 8d
        Invoke lstrcpyn, Addr cMinute, ebx, 3
        Invoke atodw, Addr cMinute
        mov dwMinute, eax       
        
        mov eax, ReturnDate
        mov edx, dwHour
        mov dh, dl
        xor ecx, ecx
        mov ecx, dwMinute
        mov dl, cl
        shl edx, 16 ; move to high word     
        mov eax, ReturnDate
        mov ReturnTime, edx     
        .IF DateFormat == YYMMDDHHMM
            ret
        .ENDIF      
            
        ; YYMMDDHHMMSS
        lea ebx, cDateTime
        add ebx, 10d                
        Invoke lstrcpyn, Addr cSecond, ebx, 3
        Invoke atodw, Addr cSecond
        mov dwSecond, eax               
        
        mov eax, ReturnDate
        mov edx, ReturnTime     
        xor ecx, ecx
        mov ecx, dwSecond
        mov dh, cl
        mov eax, ReturnDate
        mov ReturnTime, edx
        .IF DateFormat == YYMMDDHHMMSS
            ret
        .ENDIF      

        ; YYMMDDHHMMSSMS
        lea ebx, cDateTime
        add ebx, 12d
        Invoke lstrcpyn, Addr cMillisec, ebx, 3
        Invoke atodw, Addr cMillisec
        mov dwMillisec, eax 
        
        mov eax, ReturnDate
        mov edx, ReturnTime
        xor ecx, ecx
        mov ecx, dwMillisec
        mov dl, cl
        mov ReturnTime, edx
    .ENDIF
    
    ret
DTDateTimeStringToDwordDateTime ENDP

END