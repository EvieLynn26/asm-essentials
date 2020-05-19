;****************************************************************************************
;* Searches within the first num bytes of the block of memory pointed by ptr            *
;* for the first occurrence of value (a byte), returns the offset of the first entrance *
;* al -- value                                                                          *
;****************************************************************************************

.model tiny
.386

.data
    str_by_ptr db 'Hello! Let me find # in this string', '$'
.code
    LEN equ 35 
    
locals @@

org 100h

public memchr

start:  
    mov al, '#'
    mov cx, LEN
    mov di, offset str_by_ptr
    
    call memchr
    
    jmp stee


exit:   
    mov ax, 4c00h
    int 21h
  
          
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
    mov bx, LEN
    sub bx, cx
    dec bx
    
    ret           
memchr endp

end start



		
