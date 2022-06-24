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

include windows.inc

include kernel32.inc
includelib kernel32.lib

include masm32.inc
includelib masm32.lib

include DateTime.inc


.DATA
szDTDateSeperator     DB "/",0
szDTTimeSeperator     DB ":",0
szDTZero              DB "0",0
szDTSpace             DB " ",0


.CODE

DATETIME_ALIGN
;------------------------------------------------------------------------------
; DTDateFormat
;
; Converts a SYSTEMTIME structure, pointed to by the lpSystermtimeStruct 
; parameter, to a date & time string, into the buffer pointed to by the 
; lpszDateTimeString parameter and returns it formatted as specified by the 
; DateFormat parameter.
;
; Parameters:
; 
; * lpSystermtimeStruct - Pointer to a SYSTEMTIME type that contains date & time
;   information to convert.
; 
; * lpszDateTimeString - Pointer to a buffer to store the date & time string. 
;   The format of the date & time string is determined by the DateFormat parameter.
; 
; * DateFormat - Value indicating the date & time format to return in the buffer
;   pointed to by lpszDateTimeString parameter. The parameter can contain one 
;   of the constants as defined in the DateTime.inc
; 
; Returns:
; 
; TRUE if succesful, or FALSE otherwise.
; 
;------------------------------------------------------------------------------
DTDateFormat PROC USES EBX EDX ESI lpSystemtimeStruct:DWORD, lpszDateTimeString:DWORD, DateFormat:DWORD
    LOCAL Year[6]:BYTE              
    LOCAL Month[4]:BYTE             
    LOCAL Day[4]:BYTE               
    LOCAL Hour[4]:BYTE              
    LOCAL Minute[4]:BYTE            
    LOCAL Second[4]:BYTE            
    LOCAL Millisec[4]:BYTE          
    LOCAL DOW:DWORD             

    .IF lpSystemtimeStruct == NULL || lpszDateTimeString == NULL || DateFormat == NULL
        mov eax, FALSE
        ret
    .ENDIF

    mov ebx, lpSystemtimeStruct             ; SYSTEMTIME
    movzx edx, word ptr [ebx +0]            ; Offset 0 for structure SYSTEMTIME.wYear
    Invoke dwtoa, edx, Addr Year
    movzx edx, word ptr [ebx +2]            ; Offset 2 for structure SYSTEMTIME.wMonth
    Invoke dwtoa, edx, Addr Month
    movzx edx, word ptr [ebx +4]            ; Offset 4 for structure SYSTEMTIME.wDayOfWeek
    mov DOW, edx
    movzx edx, word ptr [ebx +6]            ; Offset 6 for structure SYSTEMTIME.wDay
    Invoke dwtoa, edx, Addr Day
    movzx edx, word ptr [ebx +8]            ; Offset 8 for structure SYSTEMTIME.wHour
    Invoke dwtoa, edx, Addr Hour
    movzx edx, word ptr [ebx +10]           ; Offset 10 for structure SYSTEMTIME.wMinute
    Invoke dwtoa, edx, Addr Minute
    movzx edx, word ptr [ebx +12]           ; Offset 12 for structure SYSTEMTIME.wSecond
    Invoke dwtoa, edx,  Addr Second
    movzx edx, word ptr [ebx +14]           ; Offset 14 for structure SYSTEMTIME.wMilliseconds
    Invoke dwtoa, edx,  Addr Millisec
    
    ; Main decision block
    .IF (DateFormat == CCYYMMDDHHMMSSMS) || (DateFormat == CCYYMMDDHHMMSS) || (DateFormat == CCYYMMDDHHMM) || (DateFormat == CCYYMMDD) || (DateFormat == CCYYMMDDHH) || (DateFormat == CCYYMM) || (DateFormat==YEAR)
        ; YEAR
        Invoke lstrcpy, lpszDateTimeString, Addr Year
        .IF DateFormat == YEAR
            mov eax, TRUE
            ret
        .ENDIF
        ; CCYYMM
        Invoke lstrcat, lpszDateTimeString, Addr szDTDateSeperator
        Invoke lstrlen, Addr Month
        .IF eax == 1
            Invoke lstrcat, lpszDateTimeString, Addr szDTZero
        .ENDIF
        Invoke lstrcat, lpszDateTimeString, Addr Month
        .IF DateFormat == CCYYMM
            mov eax, TRUE
            ret
        .ENDIF
        ; CCYYMMDD
        Invoke lstrcat, lpszDateTimeString, Addr szDTDateSeperator
        Invoke lstrlen, Addr Day
        .IF eax == 1
            Invoke lstrcat, lpszDateTimeString, Addr szDTZero
        .ENDIF
        Invoke lstrcat, lpszDateTimeString, Addr Day
        .IF DateFormat == CCYYMMDD
            mov eax, TRUE
            ret
        .ENDIF
        ;CCYYMMDDHH
        Invoke lstrcat, lpszDateTimeString, CTEXT(" ")
        Invoke lstrlen, Addr Hour
        .IF eax == 1
            Invoke lstrcat, lpszDateTimeString, CTEXT("0")
        .ENDIF
        Invoke lstrcat, lpszDateTimeString, Addr Hour
        .IF DateFormat == CCYYMMDDHH
            mov eax, TRUE
            ret
        .ENDIF          
        ; CCYYMMDDHHMM
        Invoke lstrcat, lpszDateTimeString, Addr szDTSpace
        Invoke lstrlen, Addr Hour
        .IF eax == 1
            Invoke lstrcat, lpszDateTimeString, Addr szDTZero
        .ENDIF
        Invoke lstrcat, lpszDateTimeString, Addr Hour
        Invoke lstrcat, lpszDateTimeString, Addr szDTTimeSeperator
        Invoke lstrlen, Addr Minute
        .IF eax == 1
            Invoke lstrcat, lpszDateTimeString, Addr szDTZero
        .ENDIF
        Invoke lstrcat, lpszDateTimeString, Addr Minute
        .IF DateFormat == CCYYMMDDHHMM
            mov eax, TRUE
            ret
        .ENDIF
        ; CCYYMMDDHHMMSS
        Invoke lstrcat, lpszDateTimeString, Addr szDTTimeSeperator
        Invoke lstrlen, Addr Second
        .IF eax == 1
            Invoke lstrcat, lpszDateTimeString, Addr szDTZero
        .ENDIF
        Invoke lstrcat, lpszDateTimeString, Addr Second
        .IF DateFormat == CCYYMMDDHHMMSS
            mov eax, TRUE
            ret
        .ENDIF
        ; CCYYMMDDHHMMSSMS
        Invoke lstrcat, lpszDateTimeString, Addr szDTTimeSeperator
        Invoke lstrlen, Addr Millisec
        .IF eax == 1
            Invoke lstrcat, lpszDateTimeString, Addr szDTZero
        .ENDIF
        Invoke lstrcat, lpszDateTimeString, Addr Millisec
        mov eax, TRUE
        ret
    
    .ELSEIF (DateFormat == YYMMDDHHMMSSMS) || (DateFormat == YYMMDDHHMMSS) || (DateFormat == YYMMDDHHMM) || (DateFormat == YYMMDD) || (DateFormat == YYMM) || (DateFormat == YY)
        ; YY
        lea esi, Year
        add esi, 2
        Invoke lstrcpy, lpszDateTimeString, esi
        .IF DateFormat == YY
            mov eax, TRUE
            ret
        .ENDIF
        ; YYMM
        Invoke lstrcat, lpszDateTimeString, Addr szDTDateSeperator
        Invoke lstrlen, Addr Month
        .IF eax == 1
            Invoke lstrcat, lpszDateTimeString, Addr szDTZero
        .ENDIF
        Invoke lstrcat, lpszDateTimeString, Addr Month
        .IF DateFormat == YYMM
            mov eax, TRUE
            ret
        .ENDIF
        ; YYMMDD
        Invoke lstrcat, lpszDateTimeString, Addr szDTDateSeperator
        Invoke lstrlen, Addr Day
        .IF eax == 1
            Invoke lstrcat, lpszDateTimeString, Addr szDTZero
        .ENDIF
        Invoke lstrcat, lpszDateTimeString, Addr Day
        .IF DateFormat == YYMMDD
            mov eax, TRUE
            ret
        .ENDIF
        ; YYMMDDHHMM
        Invoke lstrcat, lpszDateTimeString, Addr szDTSpace
        Invoke lstrlen, Addr Hour
        .IF eax == 1
            Invoke lstrcat, lpszDateTimeString, Addr szDTZero
        .ENDIF
        Invoke lstrcat, lpszDateTimeString, Addr Hour
        Invoke lstrcat, lpszDateTimeString, Addr szDTTimeSeperator
        Invoke lstrlen, Addr Minute
        .IF eax == 1
            Invoke lstrcat, lpszDateTimeString, Addr szDTZero
        .ENDIF
        Invoke lstrcat, lpszDateTimeString, Addr Minute
        .IF DateFormat == YYMMDDHHMM
            mov eax, TRUE
            ret
        .ENDIF
        ; YYMMDDHHMMSS
        Invoke lstrcat, lpszDateTimeString, Addr szDTTimeSeperator
        Invoke lstrlen, Addr Second
        .IF eax == 1
            Invoke lstrcat, lpszDateTimeString, Addr szDTZero
        .ENDIF
        Invoke lstrcat, lpszDateTimeString, Addr Second
        .IF DateFormat == YYMMDDHHMMSS
            mov eax, TRUE
            ret
        .ENDIF
        ; YYMMDDHHMMSSMS
        Invoke lstrcat, lpszDateTimeString, Addr szDTTimeSeperator
        Invoke lstrlen, Addr Millisec
        .IF eax == 1
            Invoke lstrcat, lpszDateTimeString, Addr szDTZero
        .ENDIF
        Invoke lstrcat, lpszDateTimeString, Addr Millisec       
        mov eax, TRUE
        ret
        
    .ELSEIF (DateFormat == DDMMCCYYHHMMSSMS) || (DateFormat == DDMMCCYYHHMMSS) || (DateFormat == DDMMCCYYHHMM) || (DateFormat == DDMMCCYY) || (DateFormat == DDMMYY) || (DateFormat == DDMM) || (DateFormat == DAY)
        ; DAY
        Invoke lstrlen, Addr Day
        .IF eax == 1
            Invoke lstrcpy, lpszDateTimeString, Addr szDTZero
            Invoke lstrcat, lpszDateTimeString, Addr Day
        .ELSE
            Invoke lstrcpy, lpszDateTimeString, Addr Day
        .ENDIF
        .IF DateFormat == DAY
            mov eax, TRUE
            ret
        .ENDIF
        Invoke lstrcat, lpszDateTimeString, Addr szDTDateSeperator
        Invoke lstrlen, Addr Month
        .IF eax == 1
            Invoke lstrcat, lpszDateTimeString, Addr szDTZero
        .ENDIF
        Invoke lstrcat, lpszDateTimeString, Addr Month
        .IF DateFormat == DDMM
            mov eax, TRUE
            ret
        .ENDIF
        ; DDMMCCYY
        Invoke lstrcat, lpszDateTimeString, Addr szDTDateSeperator
        Invoke lstrcat, lpszDateTimeString, Addr Year
        .IF DateFormat == DDMMCCYY
            mov eax, TRUE
            ret
        .ENDIF
        ; DDMMCCYYHHMM
        Invoke lstrcat, lpszDateTimeString, Addr szDTSpace
        Invoke lstrlen, Addr Hour
        .IF eax == 1
            Invoke lstrcat, lpszDateTimeString, Addr szDTZero
        .ENDIF
        Invoke lstrcat, lpszDateTimeString, Addr Hour
        Invoke lstrcat, lpszDateTimeString, Addr szDTTimeSeperator
        Invoke lstrlen, Addr Minute
        .IF eax == 1
            Invoke lstrcat, lpszDateTimeString, Addr szDTZero
        .ENDIF
        Invoke lstrcat, lpszDateTimeString, Addr Minute
        .IF DateFormat == DDMMCCYYHHMM
            mov eax, TRUE
            ret
        .ENDIF
        ; DDMMCCYYHHMMSS
        Invoke lstrcat, lpszDateTimeString, Addr szDTTimeSeperator
        Invoke lstrlen, Addr Second
        .IF eax == 1
            Invoke lstrcat, lpszDateTimeString, Addr szDTZero
        .ENDIF
        Invoke lstrcat, lpszDateTimeString, Addr Second
        .IF DateFormat == DDMMCCYYHHMMSS
            mov eax, TRUE
            ret
        .ENDIF
        ; DDMMCCYYHHMMSSMS      
        Invoke lstrcat, lpszDateTimeString, Addr szDTTimeSeperator
        Invoke lstrlen, Addr Millisec
        .IF eax == 1
            Invoke lstrcat, lpszDateTimeString, Addr szDTZero
        .ENDIF
        Invoke lstrcat, lpszDateTimeString, Addr Millisec
        mov eax, TRUE
        ret
        
    .ELSEIF (DateFormat == MMDDCCYYHHMMSSMS) || (DateFormat == MMDDCCYYHHMMSS) || (DateFormat == MMDDCCYYHHMM) || (DateFormat == MMDDCCYY) || (DateFormat == MMDDYY) || (DateFormat == MMDD) || (DateFormat == MONTH) 
        ; MONTH
        Invoke lstrlen, Addr Month
        .IF eax == 1
            Invoke lstrcpy, lpszDateTimeString, Addr szDTZero
            Invoke lstrcat, lpszDateTimeString, Addr Month
        .ELSE
            Invoke lstrcpy, lpszDateTimeString, Addr Month
        .ENDIF
        .IF DateFormat == MONTH
            mov eax, TRUE
            ret
        .ENDIF
        ; MMDD
        Invoke lstrcat, lpszDateTimeString, Addr szDTDateSeperator
        Invoke lstrlen, Addr Day
        .IF eax == 1
            Invoke lstrcat, lpszDateTimeString, Addr szDTZero
        .ENDIF
        Invoke lstrcat, lpszDateTimeString, Addr Day
        .IF DateFormat == MMDD
            mov eax, TRUE
            ret
        .ENDIF
        ; MMDDCCYY
        Invoke lstrcat, lpszDateTimeString, Addr szDTDateSeperator
        Invoke lstrcat, lpszDateTimeString, Addr Year
        .IF DateFormat == MMDDCCYY
            mov eax, TRUE
            ret
        .ENDIF
        ; MMDDCCYYHHMM
        Invoke lstrcat, lpszDateTimeString, Addr szDTSpace
        Invoke lstrlen, Addr Hour
        .IF eax == 1
            Invoke lstrcat, lpszDateTimeString, Addr szDTZero
        .ENDIF
        Invoke lstrcat, lpszDateTimeString, Addr Hour
        Invoke lstrcat, lpszDateTimeString, Addr szDTTimeSeperator
        Invoke lstrlen, Addr Minute
        .IF eax == 1
            Invoke lstrcat, lpszDateTimeString, Addr szDTZero
        .ENDIF
        Invoke lstrcat, lpszDateTimeString, Addr Minute
        .IF DateFormat == MMDDCCYYHHMM
            mov eax, TRUE
            ret
        .ENDIF
        ; MMDDCCYYHHMMSS
        Invoke lstrcat, lpszDateTimeString, Addr szDTTimeSeperator
        Invoke lstrlen, Addr Second
        .IF eax == 1
            Invoke lstrcat, lpszDateTimeString, Addr szDTZero
        .ENDIF
        Invoke lstrcat, lpszDateTimeString, Addr Second
        .IF DateFormat == MMDDCCYYHHMMSS
            mov eax, TRUE
            ret
        .ENDIF
        ; MMDDCCYYHHMMSSMS
        Invoke lstrcat, lpszDateTimeString, Addr szDTTimeSeperator
        Invoke lstrlen, Addr Millisec
        .IF eax == 1
            Invoke lstrcat, lpszDateTimeString, Addr szDTZero
        .ENDIF
        Invoke lstrcat, lpszDateTimeString, Addr Millisec
        mov eax, TRUE
        ret
        
    .ELSEIF DateFormat == DDMMYY
        ; DDMMYY
        Invoke lstrlen, Addr Day
        .IF eax == 1
            Invoke lstrcpy, lpszDateTimeString, Addr szDTZero
            Invoke lstrcat, lpszDateTimeString, Addr Day
        .ELSE
            Invoke lstrcpy, lpszDateTimeString, Addr Day
        .ENDIF
        Invoke lstrcat, lpszDateTimeString, Addr szDTDateSeperator
        Invoke lstrlen, Addr Month
        .IF eax == 1
            Invoke lstrcat, lpszDateTimeString, Addr szDTZero
        .ENDIF
        Invoke lstrcat, lpszDateTimeString, Addr Month
        Invoke lstrcat, lpszDateTimeString, Addr szDTDateSeperator
        lea ebx, Year
        inc ebx
        inc ebx
        Invoke lstrcat, lpszDateTimeString, ebx
        mov eax, TRUE
        ret
    
    .ELSEIF (DateFormat == HHMM) || (DateFormat == HHMMSS) || (DateFormat == HHMMSSMS)
        ; HHMM
        Invoke lstrlen, Addr Hour
        .IF eax == 1
            Invoke lstrcpy, lpszDateTimeString, Addr szDTZero
            Invoke lstrcat, lpszDateTimeString, Addr Hour   
        .ELSE
            Invoke lstrcpy, lpszDateTimeString, Addr Hour   
        .ENDIF
        Invoke lstrcat, lpszDateTimeString, Addr szDTTimeSeperator
        Invoke lstrlen, Addr Minute
        .IF eax == 1
            Invoke lstrcat, lpszDateTimeString, Addr szDTZero
        .ENDIF
        Invoke lstrcat, lpszDateTimeString, Addr Minute
        .IF DateFormat == HHMM
            mov eax, TRUE
            ret
        .ENDIF
        ; HHMMSS
        Invoke lstrcat, lpszDateTimeString, Addr szDTTimeSeperator
        Invoke lstrlen, Addr Second
        .IF eax == 1
            Invoke lstrcat, lpszDateTimeString, Addr szDTZero
        .ENDIF
        Invoke lstrcat, lpszDateTimeString, Addr Second
        .IF DateFormat == HHMMSS
            mov eax, TRUE
            ret
        .ENDIF
        ; HHMMSSMS
        Invoke lstrcat, lpszDateTimeString, Addr szDTTimeSeperator
        Invoke lstrlen, Addr Millisec
        .IF eax == 1
            Invoke lstrcat, lpszDateTimeString, Addr szDTZero
        .ENDIF
        Invoke lstrcat, lpszDateTimeString, Addr Millisec
        mov eax, TRUE
        ret
    
    .ELSEIF DateFormat == DAYOFWEEK
        mov eax, DOW
        .IF eax==0
            Invoke lstrcpy, lpszDateTimeString, CTEXT("Sunday") 
        .ELSEIF eax==1
            Invoke lstrcpy, lpszDateTimeString, CTEXT("Monday")
        .ELSEIF eax==2
            Invoke lstrcpy, lpszDateTimeString, CTEXT("Tuesday")
        .ELSEIF eax==3
            Invoke lstrcpy, lpszDateTimeString, CTEXT("Wednesday")
        .ELSEIF eax==4
            Invoke lstrcpy, lpszDateTimeString, CTEXT("Thursday")
        .ELSEIF eax==5
            Invoke lstrcpy, lpszDateTimeString, CTEXT("Friday")
        .ELSEIF eax==6
            Invoke lstrcpy, lpszDateTimeString, CTEXT("Saturday")
        .ENDIF
        mov eax, TRUE
        ret
    .ELSE
        mov eax, FALSE
        ret
    .ENDIF
    
    mov eax, TRUE
    ret
DTDateFormat ENDP

END