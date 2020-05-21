;****************************************************************************************
;* Searches of the string pointed by es:[di]                                            *
;* for the first occurrence of value (a byte)                                           *
;* returns the offset of the first entrancein di                                        *
;* al -- value to search for                                                            *
;****************************************************************************************

.model tiny
.386

.data
    nullptr equ 0
   
    str_by_ptr db 'Hello! Let me find # in this string', '$', 0

.code
    
locals @@

org 100h

public strchr

start:
	mov ax, ds
	mov es, ax
	lea di, str_by_ptr

	mov al, '#'

       	call strchr

       	mov ah, 09h
     	mov dx, di
        int 21h

strchr proc
    push ax
    push di
    call strlen
    pop di
    pop ax
    mov cx, bx

    call memchr

    ret
strchr endp
           
;****************************************************************************************
;* in case of not found -> di = nullptr                                                 *
;*                                                                                      *
;* Destroys cx                                                                          *
;****************************************************************************************      
memchr proc
    cld
    repne scasb
    
    je @@found
     
@@not_found:
    mov di, nullptr
    ret

@@found:
    dec di
    ret           
memchr endp

;****************************************************************************************
;* Goes through srting dec cx, while end of str by es:[di] not finished with 0          *
;* Returns length in bx	                                                                *
;* Destroys al, cx                                                                      *
;****************************************************************************************
strlen proc			
	mov cx, 0ffffh ; max available value of cx (16 bytes)
	mov bx, cx
	mov al, 0
            
	cld
	repne scasb
	sub bx, cx

	ret
strlen endp				


end start

