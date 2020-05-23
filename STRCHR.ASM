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
exit:
	mov ah, 4ch
	int 21h

strchr proc
	push ax
	push di
	call strlen
	pop di
    	pop ax
    
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
;* Goes through srting, while end of str by es:[di] not finished with 0                 *
;* Returns length in cx	                                                                *
;* Destroys di, al, cx                                                                  *
;****************************************************************************************
strlen proc			
	xor cx, cx
	not cx ; max available value of cx (16 bytes)
	xor al, al
            
	cld
	repne scasb
	
	not cx
	dec cx

	ret
strlen endp				


end start

