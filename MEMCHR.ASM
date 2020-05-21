;****************************************************************************************
;* Searches within the first num bytes of the block of memory pointed by di             *
;* for the first occurrence of value (a byte), returns the offset of the first entrance *
;* al -- value                                                                          *
;****************************************************************************************
.model tiny
.386

.data
	str_by_ptr db 'Hello! Let me find # in this string', '$'
	check_lbl  db 'Now di points to byte: ', '$'

.code

	LEN equ 30
	nullptr equ 0
    
locals @@

org 100h

public memchr
public check_correct

start:  
	mov al, '#'
	mov cx, LEN
	lea di, str_by_ptr
    
	call memchr

	call check_correct

exit:   
	mov ax, 4c00h
	int 21h

          
;****************************************************************************************
;* Input: di = str_ptr, al = byte to find, cx = amount of bytes to check                *
;* Return ptr of fistr entrance in di                                                   *
;*        in case of not found -> return nullptr in di                                  *
;* Goes forward (DF = 0)                                                                *
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
;* In case of found shows finding byte                                                  *
;* If di = nullptr UB                                                                   *
;*                                                                                      *
;* Destroys ah, dx                                                                      *
;****************************************************************************************  
check_correct proc
	mov ah, 09h
	lea dx, check_lbl
	int 21h
	
	mov ah, 02h
	mov dl, byte ptr [di]
	int 21h

	ret
check_correct endp
	                 
end start
        


		
