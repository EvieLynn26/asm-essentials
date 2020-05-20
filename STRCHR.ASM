;****************************************************************************************
;* Searches of the string pointed by es:[di]                                            *
;* for the first occurrence of value (a byte)                                           *
;* returns the offset (bx) of the first entrance                                        *
;* al -- value to search for                                                            *
;****************************************************************************************

.model tiny
.386

.data
    str_by_ptr db 'Hello! Let me find # in this string', '$'

.code
    
locals @@

org 100h

extrn strlen
public strchr

start:  

strchr proc

    call strlen
    mov cx, bx

    call memchr

    ret
strchr endp
           
;****************************************************************************************
;* in case of not found -> al = 0
;* 
;* Destroys al, bx                                                                         *
;****************************************************************************************      
memchr proc
    cld
    repne scasb
    
    je @@found
     
@@not_found:
    mov al, 0 
    
@@found:
    sub bx, cx
    dec bx
    
    ret           
memchr endp

end start

